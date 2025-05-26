package com.visitors;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.DAO.RelicDAO;
import com.SQL.Relic_Bean;
import com.DAO.FeedbackDAO;
import com.SQL.Feedback_Bean;

import java.io.IOException;

@WebServlet("/visitors/OneRelic")
public class OneRelicServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int relicId = Integer.parseInt(request.getParameter("relicId"));
        RelicDAO relicDAO = new RelicDAO();
        FeedbackDAO feedbackDAO = new FeedbackDAO();

        try {
            // 获取文物信息
            Relic_Bean relic = relicDAO.getRelicById(relicId);
            if (relic == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "文物不存在");
                return;
            }
            request.setAttribute("relic", relic);
            request.getRequestDispatcher("/visitors/OneRelic.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        int relicId = Integer.parseInt(request.getParameter("relicId"));
        String content = request.getParameter("content");
        // 假设已登录用户ID为1，实际应从session获取
        Integer userId = (Integer) request.getSession().getAttribute("userid");
        Feedback_Bean fb = new Feedback_Bean();
        fb.setUserId(userId);
        fb.setRelicId(relicId);
        fb.setContent(content);
        fb.setStatus("submitted");
        fb.setResolvedResult(null);
        fb.setCreatedAt(new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date()));
        try {
            FeedbackDAO feedbackDAO = new FeedbackDAO();
            feedbackDAO.addFeedback(fb);
            request.setAttribute("feedbackMsg", "反馈提交成功！");
        } catch (Exception e) {
            request.setAttribute("feedbackMsg", "反馈提交失败，请稍后再试。");
        }
        // 重新获取文物信息并转发回详情页
        try {
            RelicDAO relicDAO = new RelicDAO();
            Relic_Bean relic = relicDAO.getRelicById(relicId);
            request.setAttribute("relic", relic);
            request.getRequestDispatcher("/visitors/OneRelic.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}