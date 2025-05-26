package com.visitors;

import com.DAO.HallDAO;
import com.SQL.Hall_Bean;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/visitors/hallList")
public class HallListServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HallDAO hallDAO = new HallDAO();
        try {
            List<Hall_Bean> halls = hallDAO.listHalls();
            request.setAttribute("halls", halls);
            request.getRequestDispatcher("/visitors/Hall.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "展厅数据获取失败");
        }
    }
}