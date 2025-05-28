package com.admin;

import com.DAO.NewsDAO;
import com.SQL.News_Bean;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Enumeration;
import java.util.List;

@WebServlet("/NewsServlet")
public class NewsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    public NewsDAO newsDAO = new NewsDAO();

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
                    listNews(request, response);
                    break;
                case "search":
                    searchNews(request, response);
                    response.setContentType("text/plain;charset=UTF-8");
                    response.getWriter().write("success");
                    break;
                case "add":
                    addNews(request, response);
                    response.setContentType("text/plain;charset=UTF-8");
                    response.getWriter().write("success");
                    break;
                case "edit":
                    editNews(request, response);
                    response.setContentType("text/plain;charset=UTF-8");
                    request.getRequestDispatcher("/admin/function/news_edit.jsp").forward(request, response);
                    break;
                case "update":
                    updateNews(request, response);
                    response.setContentType("text/plain;charset=UTF-8");
                    response.getWriter().write("success");
                    break;
                case "delete":
                    deleteNews(request, response);
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

    private void listNews(HttpServletRequest request, HttpServletResponse response) throws Exception {
        List<News_Bean> newsList = newsDAO.listNews();
        request.setAttribute("newsList", newsList);
        request.getRequestDispatcher("/admin/news_list.jsp").forward(request, response);
    }

    private void searchNews(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String searchType = request.getParameter("searchType");
        String searchInput = request.getParameter("searchInput");
        List<News_Bean> newsList = newsDAO.searchNews(searchType, searchInput);
        request.setAttribute("newsList", newsList);
        request.getRequestDispatcher("/admin/news_list.jsp").forward(request, response);
    }

    private void addNews(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String publishTime = request.getParameter("publishTime");
        int publisherId = Integer.parseInt(request.getParameter("publisherId"));

        News_Bean news = new News_Bean();
        news.setTitle(title);
        news.setContent(content);
        news.setPublishTime(publishTime);
        news.setPublisherId(publisherId);

        newsDAO.addNews(news);
    }

    private void editNews(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int newsId = Integer.parseInt(request.getParameter("newsId"));
        News_Bean news = newsDAO.getNewsById(newsId);
        request.setAttribute("news", news);
    }

    private void updateNews(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int newsId = Integer.parseInt(request.getParameter("newsId"));
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String publishTime = request.getParameter("publishTime");
        int publisherId = Integer.parseInt(request.getParameter("publisherId"));

        News_Bean news = new News_Bean();
        news.setNewsId(newsId);
        news.setTitle(title);
        news.setContent(content);
        news.setPublishTime(publishTime);
        news.setPublisherId(publisherId);

        newsDAO.updateNews(news);
    }

    private void deleteNews(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int newsId = Integer.parseInt(request.getParameter("newsId"));
        newsDAO.deleteNews(newsId);
    }
}
