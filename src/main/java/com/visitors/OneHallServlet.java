package com.visitors;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.DAO.HallDAO;
import com.DAO.RelicDAO;
import com.SQL.Hall_Bean;
import com.SQL.Relic_Bean;

import java.io.IOException;
import java.util.List;

@WebServlet("/visitors/OneHall")
public class OneHallServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int hallId = Integer.parseInt(request.getParameter("hallId"));
        RelicDAO relicDAO = new RelicDAO();
        HallDAO hallDAO = new HallDAO();
        try {
            List<Relic_Bean> relics = relicDAO.searchRelics("hall_id", String.valueOf(hallId));
            Hall_Bean hall = hallDAO.getHallById(hallId);
            request.setAttribute("relics", relics);
            request.setAttribute("hall", hall);
            request.getRequestDispatcher("/visitors/OneHall").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}