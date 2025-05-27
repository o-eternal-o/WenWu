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
        // 从Session中获取用户ID
        HttpSession session = request.getSession(false); // 获取当前会话，不创建新会话
        if (session == null || session.getAttribute("userid") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "请先登录");
            return;
        }

        int userId = (int) session.getAttribute("userid"); // 直接从 session 中获取 userId
//        System.out.println("User ID: " + userId); // 打印用户 ID

        try {
            UserVerification_Bean verification = userVerificationDAO.getVerificationByUserId(userId);

            int currentStep;
            String message;

            if (verification == null) {
                // 没有记录，跳转到实名认证表单页面
                currentStep = 1; // 第一步：未提交认证信息
                message = "请填写您的个人信息并上传身份证照片。";
            } else {
                // 已有记录，根据状态返回相应页面
                String status = verification.getStatus();
                if ("PENDING".equals(status)) {
                    currentStep = 2; // 第二步：审核中
                    message = "您的实名认证正在审核中，请耐心等待。";
                } else if ("APPROVED".equals(status)) {
                    currentStep = 3; // 第三步：认证成功
                    message = "您的实名认证已通过！";
                } else if ("REJECTED".equals(status)) {
                    currentStep = 1; // 回到第一步
                    message = "您的实名认证未通过，原因：" + verification.getRejectReason();
                } else {
                    currentStep = 1; // 默认回到第一步
                    message = "未知状态，请重新提交认证信息。";
                }
            }

            // 设置 currentStep 和 message 到请求属性
            request.setAttribute("currentStep", currentStep);
            request.setAttribute("message", message);

            // 转发到 JSP 页面
            request.getRequestDispatcher("/visitors/Identity_verification.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "服务器错误");
        }
    }

   @Override
   protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
       HttpSession session = request.getSession(false);
       int userId = (int) session.getAttribute("userid");
       String realName = request.getParameter("realName");
       String phone = request.getParameter("phone");
       String idNumber = request.getParameter("idNumber");
       Part filePart = request.getPart("idImage");

       // 获取文件名
       String fileName = UUID.randomUUID().toString() + "_" + filePart.getSubmittedFileName();

       // 定义存储路径
       String uploadDir = getServletContext().getRealPath("/uploads");
       File uploadDirFile = new File(uploadDir);
       if (!uploadDirFile.exists()) {
           uploadDirFile.mkdirs(); // 创建目录
       }

       // 保存文件
       String filePath = uploadDir + File.separator + fileName;
       filePart.write(filePath);

       // 创建UserVerification_Bean对象并设置属性
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

           int currentStep = 2;
           request.setAttribute("currentStep", currentStep);
           request.setAttribute("message", "您的实名认证信息已提交成功，请等待审核。");
           request.getRequestDispatcher("/visitors/Identity_verification.jsp").forward(request, response);
       } catch (Exception e) {
           e.printStackTrace();
           response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "服务器错误");
       }
   }

}