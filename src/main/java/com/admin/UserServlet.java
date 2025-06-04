package com.admin;

import com.DAO.UserDAO;
import com.SQL.User_Bean;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/UserServlet")
public class UserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    public UserDAO userDAO = new UserDAO();

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
                    listUsers(request, response);
                    break;
                case "search":
                    searchUsers(request, response);
                    response.setContentType("text/plain;charset=UTF-8");
                    response.getWriter().write("success");
                    break;
                case "add":
                    addUser(request, response);
                    response.setContentType("text/plain;charset=UTF-8");
                    response.getWriter().write("success");
                    break;
                case "edit":
                    editUser(request, response);
                    response.setContentType("text/plain;charset=UTF-8");
                    request.getRequestDispatcher("/admin/function/user_edit.jsp").forward(request, response);
                    break;
                case "update":
                    updateUser(request, response);
                    response.setContentType("text/plain;charset=UTF-8");
                    response.getWriter().write("success");
                    break;
                case "delete":
                    deleteUser(request, response);
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

    private void listUsers(HttpServletRequest request, HttpServletResponse response) throws Exception {
        List<User_Bean> userList = userDAO.listUsers();
        request.setAttribute("userList", userList);
        request.getRequestDispatcher("/admin/user_list.jsp").forward(request, response);
    }

    private void searchUsers(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String searchType = request.getParameter("searchType");
        String searchInput = request.getParameter("searchInput");
        List<User_Bean> userList = userDAO.searchUsers(searchType, searchInput);
        request.setAttribute("userList", userList);
        request.getRequestDispatcher("/admin/user_list.jsp").forward(request, response);
    }

    private void addUser(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        boolean realNameVerified = "1".equals(request.getParameter("realNameVerified"));
        String createdAt = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());

        User_Bean user = new User_Bean();
        user.setUsername(username);
        user.setPassword(password);
        user.setRole(role);
        user.setRealNameVerified(realNameVerified);
        user.setCreatedAt(createdAt);

        userDAO.addUser(user);
    }

    private void editUser(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int userId = Integer.parseInt(request.getParameter("userId"));
        User_Bean user = userDAO.getUserById(userId);
        request.setAttribute("user", user);
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int userId = Integer.parseInt(request.getParameter("userId"));
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        boolean realNameVerified = "1".equals(request.getParameter("realNameVerified"));
        String createdAt = request.getParameter("createdAt");

        User_Bean user = new User_Bean();
        user.setUserId(userId);
        user.setUsername(username);
        user.setPassword(password);
        user.setRole(role);
        user.setRealNameVerified(realNameVerified);
        user.setCreatedAt(createdAt);

        userDAO.updateUser(user);
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int userId = Integer.parseInt(request.getParameter("userId"));
        userDAO.deleteUser(userId);
    }
}
