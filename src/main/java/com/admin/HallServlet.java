package com.admin;

import com.DAO.HallDAO;
import com.SQL.Hall_Bean;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Enumeration;
import java.util.List;

@WebServlet("/HallServlet")
public class HallServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    public HallDAO hallDAO = new HallDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request ,response);
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
                   listHalls(request, response);
                   break;
               case "search":
                   searchHalls(request, response);
                   response.setContentType("text/plain;charset=UTF-8");
                   response.getWriter().write("success");
                   break;
               case "add":
                   addHall(request, response);
                   response.setContentType("text/plain;charset=UTF-8");
                   response.getWriter().write("success");
                   break;
               case "edit":
                   editHall(request, response);
                   response.setContentType("text/plain;charset=UTF-8");
                   request.getRequestDispatcher("/admin/function/hall_edit.jsp").forward(request, response);
                   break;
               case "update":
                   updateHall(request, response);
                   response.setContentType("text/plain;charset=UTF-8"); // 设置为 text/plain
                   response.getWriter().write("success");
                   break;
               case "delete":
                   deleteHall(request, response);
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

   /**
     * 查询所有展厅信息并存储
     */
    private void listHalls(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 调用 DAO 获取展厅列表
        List<Hall_Bean> halls = hallDAO.listHalls();
        request.setAttribute("hallList", halls);
        request.getRequestDispatcher("/admin/hall_list.jsp").forward(request, response);
    }

    /**
     * 查询特定展厅信息并存储
     */
    private void searchHalls(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String searchType = request.getParameter("searchType"); // 下拉菜单选中的值
        String searchInput = request.getParameter("searchInput"); // 输入框的内容

        List<Hall_Bean> halls = hallDAO.searchHalls(searchType, searchInput);
        request.setAttribute("hallList", halls);
        request.getRequestDispatcher("/admin/hall_list.jsp").forward(request, response);
    }

    /**
     * 添加展厅信息
     */
    private void addHall(HttpServletRequest request, HttpServletResponse response) throws Exception {

        String hallName = request.getParameter("hallName");
        String dynasty = request.getParameter("dynasty");
        String type = request.getParameter("type");
        String layoutRules = request.getParameter("layoutRules");
        String isOpenBookingParam = request.getParameter("isOpenBooking");//前端传来的”1“是字符串
        boolean isOpenBooking = "1".equals(isOpenBookingParam); // 将 "1" 视为 true，其他值视为 false
        String bookingStartTime = request.getParameter("bookingStartTime");
        String bookingEndTime = request.getParameter("bookingEndTime");
        int maxCapacity = Integer.parseInt(request.getParameter("maxCapacity"));

        Hall_Bean hall = new Hall_Bean();
        hall.setHallName(hallName);
        hall.setDynasty(dynasty);
        hall.setType(type);
        hall.setLayoutRules(layoutRules);
        hall.setOpenBooking(isOpenBooking);
        hall.setBookingStartTime(bookingStartTime);
        hall.setBookingEndTime(bookingEndTime);
        hall.setMaxCapacity(maxCapacity);

        hallDAO.addHall(hall);
    }

    /**
     * 获取单个展厅信息用于编辑
     */
    private void editHall(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int hallId = Integer.parseInt(request.getParameter("hallId"));  // 确保参数名为 "hallId"
        Hall_Bean hall = hallDAO.getHallById(hallId);  // 调用 DAO 方法
        request.setAttribute("hall", hall);
       }

    /**
     * 修改展厅信息
     */
    private void updateHall(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int hallId = Integer.parseInt(request.getParameter("hallId"));  // 确保参数名为 "hallId"
        String hallName = request.getParameter("hallName");
        String dynasty = request.getParameter("dynasty");
        String type = request.getParameter("type");
        String layoutRules = request.getParameter("layoutRules");
        String isOpenBookingParam = request.getParameter("isOpenBooking");//前端传来的”1“是字符串
        boolean isOpenBooking = "1".equals(isOpenBookingParam); // 将 "1" 视为 true，其他值视为 false
        String bookingStartTime = request.getParameter("bookingStartTime");
        String bookingEndTime = request.getParameter("bookingEndTime");
        int maxCapacity = Integer.parseInt(request.getParameter("maxCapacity"));

        Hall_Bean hall = new Hall_Bean();
        hall.setHallId(hallId);
        hall.setHallName(hallName);
        hall.setDynasty(dynasty);
        hall.setType(type);
        hall.setLayoutRules(layoutRules);
        hall.setOpenBooking(isOpenBooking);
        hall.setBookingStartTime(bookingStartTime);
        hall.setBookingEndTime(bookingEndTime);
        hall.setMaxCapacity(maxCapacity);

        hallDAO.updateHall(hall);
    }

    /**
     * 删除展厅信息
     */
    private void deleteHall(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int hallId = Integer.parseInt(request.getParameter("hallId"));  // 确保参数名为 "hallId"
        hallDAO.deleteHall(hallId);
    }
}