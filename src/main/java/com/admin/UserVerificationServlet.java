package com.admin;

import com.DAO.UserVerificationDAO;
import com.SQL.UserVerification_Bean;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.Enumeration;
import java.util.List;

@WebServlet("/UserVerificationServlet")
public class UserVerificationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserVerificationDAO dao = new UserVerificationDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action");
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
                    update(request, response);
                    response.setContentType("text/plain;charset=UTF-8");
                    response.getWriter().write("success");
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
        UserVerification_Bean bean = buildBean(request);
        dao.addVerification(bean);
    }

    private void edit(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int id = Integer.parseInt(request.getParameter("verificationId"));
        UserVerification_Bean bean = dao.getVerificationById(id);
        request.setAttribute("verification", bean);
    }

    private void update(HttpServletRequest request, HttpServletResponse response) throws Exception {
        UserVerification_Bean bean = buildBean(request);
        bean.setVerificationId(Integer.parseInt(request.getParameter("verificationId")));
        dao.updateVerification(bean);
    }

    private void delete(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int id = Integer.parseInt(request.getParameter("verificationId"));
        dao.deleteVerification(id);
    }

    private UserVerification_Bean buildBean(HttpServletRequest request) {
        UserVerification_Bean bean = new UserVerification_Bean();
        bean.setUserId(Integer.parseInt(request.getParameter("userId")));
        bean.setRealName(request.getParameter("realName"));
        bean.setIdType(request.getParameter("idType"));
        bean.setIdNumber(request.getParameter("idNumber"));
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
}