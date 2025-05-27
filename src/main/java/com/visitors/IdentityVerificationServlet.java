package com.visitors;

import com.DAO.UserVerificationDAO;
import com.SQL.UserVerification_Bean;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.UUID;

@WebServlet("/identityVerificationServlet")
@MultipartConfig
public class IdentityVerificationServlet extends HttpServlet {

    private UserVerificationDAO userVerificationDAO = new UserVerificationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userid") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "请先登录");
            return;
        }

        int userId = (int) session.getAttribute("userid");
        System.out.println("Session UserID: " + userId);

        try {
            UserVerification_Bean verification = userVerificationDAO.getVerificationByUserId(userId);

            int currentStep;
            String message;

            if (verification == null) {
                currentStep = 1;
                message = "请填写您的个人信息并上传身份证照片。";
            } else {
                String status = verification.getStatus();
                if ("PENDING".equals(status)) {
                    currentStep = 2;
                    message = "您的实名认证正在审核中，请耐心等待。";
                } else if ("APPROVED".equals(status)) {
                    currentStep = 3;
                    message = "您的实名认证已通过！";
                } else if ("REJECTED".equals(status)) {
                    currentStep = 1;
                    message = "您的实名认证未通过，原因：" + verification.getRejectReason();
                } else {
                    currentStep = 1;
                    message = "未知状态，请重新提交认证信息。";
                }
            }

            // 日志输出
            System.out.println("Current Step: " + currentStep);
            System.out.println("Message: " + message);

            request.setAttribute("currentStep", currentStep);
            request.setAttribute("message", message);

            request.getRequestDispatcher("/visitors/Identity_verification.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "服务器错误");
        }
    }

   @Override
   protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
       request.setCharacterEncoding("UTF-8");
       response.setCharacterEncoding("UTF-8");
       response.setContentType("application/json;charset=UTF-8");

       HttpSession session = request.getSession(false);
       int userId = (int) session.getAttribute("userid");
       String realName = request.getParameter("realName");
       String phone = request.getParameter("phone");
       String idNumber = request.getParameter("idNumber");
       Part filePart = request.getPart("idImage");

       String fileName = UUID.randomUUID().toString() + "_" + filePart.getSubmittedFileName();
       String uploadDir = getServletContext().getRealPath("/uploads");
       File uploadDirFile = new File(uploadDir);
       if (!uploadDirFile.exists()) {
           uploadDirFile.mkdirs();
       }
       String filePath = uploadDir + File.separator + fileName;
       filePart.write(filePath);

       UserVerification_Bean verification = new UserVerification_Bean();
       verification.setUserId(userId);
       verification.setRealName(realName);
       verification.setPhone(phone);
       verification.setIdNumber(idNumber);
       verification.setIdImagePath(request.getContextPath() + "/uploads/" + fileName);
       verification.setStatus("PENDING");
       verification.setSubmittedAt(new Timestamp(System.currentTimeMillis()));

       try {
           UserVerification_Bean existingVerification = userVerificationDAO.getVerificationByUserId(userId);

           if (existingVerification == null) {
               userVerificationDAO.addVerification(verification);
           } else {
               int verificationId = existingVerification.getVerificationId();
               verification.setVerificationId(verificationId);
               userVerificationDAO.updateVerification(verification);
           }

           // 返回 JSON 响应
           response.getWriter().write("{\"status\":\"success\",\"message\":\"提交成功！\"}");
       } catch (Exception e) {
           e.printStackTrace();
           response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
           response.getWriter().write("{\"status\":\"error\",\"message\":\"服务器错误，请稍后重试。\"}");
       }
   }

}