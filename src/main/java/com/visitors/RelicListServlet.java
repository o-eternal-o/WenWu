package com.visitors;

import com.DAO.RelicDAO;
import com.SQL.Relic_Bean;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/visitors/relicList")
public class RelicListServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RelicDAO relicDAO = new RelicDAO();
        try {
            String searchType = request.getParameter("searchType");
            String searchInput = request.getParameter("searchInput");
            List<Relic_Bean> relics;
            if (searchType != null && searchInput != null && !searchInput.trim().isEmpty()) {
                relics = relicDAO.searchRelics(searchType, searchInput);
            } else {
                relics = relicDAO.listRelics();
            }
            request.setAttribute("relics", relics);
            request.getRequestDispatcher("/visitors/Relic.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "文物数据获取失败");
        }
    }
}
