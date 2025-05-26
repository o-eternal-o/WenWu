// 文件：src/main/java/com/visitors/NewsListServlet.java
package com.visitors;

import com.DAO.NewsDAO;
import com.SQL.News_Bean;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/VisitorsServlet")
public class VisitorsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        NewsDAO newsDAO = new NewsDAO();
        try {
            List<News_Bean> newsList = newsDAO.listNews();
            request.setAttribute("newsList", newsList);
            request.getRequestDispatcher("/visitors.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "新闻数据获取失败");
        }
    }
}
