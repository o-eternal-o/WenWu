package com.admin;

import com.DAO.UserVerificationDAO;
import com.SQL.UserVerification_Bean;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Timestamp;
import java.util.List;
import java.util.UUID;

@MultipartConfig
@WebServlet("/UserVerificationServlet")
public class UserVerificationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    public UserVerificationDAO dao = new UserVerificationDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            response.getWriter().write("Invalid action");
            return;
        }
        try {
            switch (action) {
                case "list":
                    list(request, response);
                    break;
                case "search":
                    search(request, response);
                    response.setContentType("text/plain;charset=UTF-8");
                    response.getWriter().write("success");
                    break;
                case "add":
                    add(request, response);
                    response.setContentType("text/plain;charset=UTF-8");
                    response.getWriter().write("success");
                    break;
                case "edit":
                    edit(request, response);
                    request.getRequestDispatcher("/admin/function/user_verification_edit.jsp").forward(request, response);
                    break;
                case "update":
                    try {
                        update(request, response);
                        response.setContentType("text/plain;charset=UTF-8");
                        response.getWriter().write("success");
                    } catch (Exception e) {
                        e.printStackTrace();
                        response.setContentType("text/plain;charset=UTF-8");
                        response.getWriter().write("error");
                    }
                    break;
                case "delete":
                    delete(request, response);
                    response.setContentType("text/plain;charset=UTF-8");
                    response.getWriter().write("success");
                    break;
                default:
                    response.setContentType("text/plain;charset=UTF-8");
                    response.getWriter().write("defeat");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void list(HttpServletRequest request, HttpServletResponse response) throws Exception {
        List<UserVerification_Bean> list = dao.listVerifications();
        request.setAttribute("verificationList", list);
        request.getRequestDispatcher("/admin/user_verification_list.jsp").forward(request, response);
    }

    private void search(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String searchType = request.getParameter("searchType");
        String searchInput = request.getParameter("searchInput");
        List<UserVerification_Bean> list = dao.searchVerifications(searchType, searchInput);
        request.setAttribute("verificationList", list);
        request.getRequestDispatcher("/admin/user_verification_list.jsp").forward(request, response);
    }

    private void add(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Part idImage = request.getPart("idImage");
        String idImagePath = saveImageToServer(request, idImage);

        UserVerification_Bean bean = buildBean(request);
        bean.setIdImagePath(idImagePath);
        bean.setSubmittedAt(new Timestamp(System.currentTimeMillis()));
        bean.setReviewedAt(new Timestamp(System.currentTimeMillis()));

        dao.addVerification(bean);
    }

    private void edit(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int id = Integer.parseInt(request.getParameter("verificationId"));
        UserVerification_Bean bean = dao.getVerificationById(id);
        request.setAttribute("verification", bean);
    }


    private void update(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Part idImage = request.getPart("idImage");
        String idImagePath = saveImageToServer(request, idImage);
        UserVerification_Bean bean = buildBean(request);
        // 从请求中获取 verificationId 并设置到 bean 中
        String verificationIdParam = request.getParameter("verificationId");
        if (verificationIdParam != null && !verificationIdParam.isEmpty()) {
            bean.setVerificationId(Integer.parseInt(verificationIdParam));
        }
        if (idImagePath != null) {
            bean.setIdImagePath(idImagePath);
        }
        bean.setReviewedAt(new Timestamp(System.currentTimeMillis()));
        System.out.println("Verification ID: " + bean.getVerificationId());
        System.out.println("User ID: " + bean.getUserId());
        System.out.println("Real Name: " + bean.getRealName());
        System.out.println("Phone: " + bean.getPhone());
        System.out.println("ID Number: " + bean.getIdNumber());
        System.out.println("Status: " + bean.getStatus());
        try{
            dao.updateVerification(bean);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void delete(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int id = Integer.parseInt(request.getParameter("verificationId"));
        dao.deleteVerification(id);
    }

    private UserVerification_Bean buildBean(HttpServletRequest request) {
        UserVerification_Bean bean = new UserVerification_Bean();
        bean.setUserId(Integer.parseInt(request.getParameter("userId")));
        bean.setRealName(request.getParameter("realName"));
        bean.setPhone(request.getParameter("phone")); // 新增
        bean.setIdNumber(request.getParameter("idNumber"));
        bean.setIdImagePath(request.getParameter("idImagePath"));
        bean.setStatus(request.getParameter("status"));
        String submittedAt = request.getParameter("submittedAt");
        bean.setSubmittedAt(submittedAt == null || submittedAt.isEmpty() ? null : Timestamp.valueOf(submittedAt));
        String reviewedAt = request.getParameter("reviewedAt");
        bean.setReviewedAt(reviewedAt == null || reviewedAt.isEmpty() ? null : Timestamp.valueOf(reviewedAt));
        String reviewedBy = request.getParameter("reviewedBy");
        bean.setReviewedBy((reviewedBy == null || reviewedBy.isEmpty()) ? null : Integer.valueOf(reviewedBy));
        bean.setRejectReason(request.getParameter("rejectReason"));
        return bean;
    }


    private String saveImageToServer(HttpServletRequest request, Part imageFile) throws IOException {
        if (imageFile != null && imageFile.getSize() > 0) {
            String fileName = UUID.randomUUID().toString() + "_" + Paths.get(imageFile.getSubmittedFileName()).getFileName().toString();
            String uploadDir = getServletContext().getRealPath("/uploads");
            File uploadDirFile = new File(uploadDir);
            if (!uploadDirFile.exists()) {
                uploadDirFile.mkdirs();
            }
            String filePath = uploadDir + File.separator + fileName;
            imageFile.write(filePath);
            return request.getContextPath() + "/uploads/" + fileName;
        }
        return null;
    }
}