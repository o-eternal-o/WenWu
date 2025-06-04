package com.admin;

import com.DAO.FeedbackDAO;
import com.SQL.Feedback_Bean;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Collections;
import java.util.List;

@WebServlet("/FeedbackServlet")
public class FeedbackServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    public FeedbackDAO feedbackDAO = new FeedbackDAO();

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
                    listFeedbacks(request, response);
                    break;
                case "search":
                    searchFeedbacks(request, response);
                    response.setContentType("text/plain;charset=UTF-8");
                    response.getWriter().write("success");
                    break;
                case "add":
                    addFeedback(request, response);
                    response.setContentType("text/plain;charset=UTF-8");
                    response.getWriter().write("success");
                    break;
                case "edit":
                    editFeedback(request, response);
                    request.getRequestDispatcher("/admin/function/feedback_edit.jsp").forward(request, response);
                    break;
                case "update":
                    updateFeedback(request, response);
                    response.setContentType("text/plain;charset=UTF-8");
                    response.getWriter().write("success");
                    break;
                case "delete":
                    deleteFeedback(request, response);
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
            response.setContentType("text/plain;charset=UTF-8");
            response.getWriter().write("Error: " + e.getMessage());
        }
    }

    private void listFeedbacks(HttpServletRequest request, HttpServletResponse response) throws Exception {
        List<Feedback_Bean> list = feedbackDAO.listFeedbacks();
        request.setAttribute("feedbackList", list);
        request.getRequestDispatcher("/admin/feedback_list.jsp").forward(request, response);
    }

    private void searchFeedbacks(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String searchType = request.getParameter("searchType");
        String searchInput = request.getParameter("searchInput");

        // 验证参数是否为空
        if (searchType == null || searchType.isEmpty() || searchInput == null || searchInput.isEmpty()) {
            response.setContentType("text/plain;charset=UTF-8");
            response.getWriter().write("Invalid search parameters");
            return;
        }

        List<Feedback_Bean> list = feedbackDAO.searchFeedbacks(searchType, searchInput);
        if (list == null) {
            list = Collections.emptyList(); // 避免 NullPointerException
        }
        request.setAttribute("feedbackList", list);
        request.getRequestDispatcher("/admin/feedback_list.jsp").forward(request, response);
    }
    private void addFeedback(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int userId = Integer.parseInt(request.getParameter("userId"));
        String relicIdStr = request.getParameter("relicId");
        Integer relicId = (relicIdStr == null || relicIdStr.isEmpty()) ? null : Integer.parseInt(relicIdStr);
        String content = request.getParameter("content");
        String status = request.getParameter("status");
        String resolvedResult = request.getParameter("resolvedResult");
        String createdAt = request.getParameter("createdAt");

        Feedback_Bean fb = new Feedback_Bean();
        fb.setUserId(userId);
        fb.setRelicId(relicId);
        fb.setContent(content);
        fb.setStatus(status);
        fb.setResolvedResult(resolvedResult);
        fb.setCreatedAt(createdAt);

        feedbackDAO.addFeedback(fb);
    }

    private void editFeedback(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int feedbackId = Integer.parseInt(request.getParameter("feedbackId"));
        Feedback_Bean fb = feedbackDAO.getFeedbackById(feedbackId);
        if (fb == null) {
            response.setContentType("text/plain;charset=UTF-8");
            response.getWriter().write("Feedback not found");
            return;
        }
        request.setAttribute("feedback", fb);
    }

    private void updateFeedback(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int feedbackId = Integer.parseInt(request.getParameter("feedbackId"));
        int userId = Integer.parseInt(request.getParameter("userId"));
        String relicIdStr = request.getParameter("relicId");
        Integer relicId = (relicIdStr == null || relicIdStr.isEmpty()) ? null : Integer.parseInt(relicIdStr);
        System.out.println(relicId);
        String content = request.getParameter("content");
        String status = request.getParameter("status");
        String resolvedResult = request.getParameter("resolvedResult");
        String createdAt = request.getParameter("createdAt");

        Feedback_Bean fb = new Feedback_Bean();
        fb.setFeedbackId(feedbackId);
        fb.setUserId(userId);
        fb.setRelicId(relicId);
        fb.setContent(content);
        fb.setStatus(status);
        fb.setResolvedResult(resolvedResult);
        fb.setCreatedAt(createdAt);

        feedbackDAO.updateFeedback(fb);
    }

    private void deleteFeedback(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int feedbackId = Integer.parseInt(request.getParameter("feedbackId"));
        feedbackDAO.deleteFeedback(feedbackId);
    }
}