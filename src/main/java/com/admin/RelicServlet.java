package com.admin;

import com.DAO.RelicDAO;
import com.SQL.Relic_Bean;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Enumeration;
import java.util.List;
import java.util.UUID;

@MultipartConfig
@WebServlet("/RelicServlet")
public class RelicServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    public RelicDAO relicDAO = new RelicDAO();

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
                    listRelics(request, response);
                    break;
                case "search":
                    searchRelics(request, response);
                    response.setContentType("text/plain;charset=UTF-8");
                    response.getWriter().write("success");
                    break;
                case "add":
                    addRelic(request, response);
                    response.setContentType("text/plain;charset=UTF-8");
                    response.getWriter().write("success");
                    break;
                case "edit":
                    editRelic(request, response);
                    request.getRequestDispatcher("/admin/function/relic_edit.jsp").forward(request, response);
                    break;
                case "update":
                    updateRelic(request, response);
                    response.setContentType("text/plain;charset=UTF-8");
                    response.getWriter().write("success");
                    break;
                case "delete":
                    deleteRelic(request, response);
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

    // 查询所有文物
    private void listRelics(HttpServletRequest request, HttpServletResponse response) throws Exception {
        List<Relic_Bean> relics = relicDAO.listRelics();
        request.setAttribute("relicList", relics);
        request.getRequestDispatcher("/admin/relic_list.jsp").forward(request, response);
    }

    // 按条件查询文物
    private void searchRelics(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String searchType = request.getParameter("searchType");
        String searchInput = request.getParameter("searchInput");
        List<Relic_Bean> relics = relicDAO.searchRelics(searchType, searchInput);
        request.setAttribute("relicList", relics);
        request.getRequestDispatcher("/admin/relic_list.jsp").forward(request, response);
    }

    // 添加文物
    private void addRelic(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Part imageFile = request.getPart("imageFile");
        String imagePath = saveImageToServer(request, imageFile);

        String relicName = request.getParameter("relicName");
        String dynasty = request.getParameter("dynasty");
        String description = request.getParameter("description");
        int hallId = Integer.parseInt(request.getParameter("hallId"));
        Integer createdBy = request.getParameter("createdBy") != null ? Integer.parseInt(request.getParameter("createdBy")) : null;
        String createdAt = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());

        Relic_Bean relic = new Relic_Bean();
        relic.setRelicName(relicName);
        relic.setDynasty(dynasty);
        relic.setDescription(description);
        relic.setHallId(hallId);
        relic.setImagePath(imagePath);
        relic.setCreatedBy(createdBy);
        relic.setCreatedAt(createdAt);

        relicDAO.addRelic(relic);
    }

    // 获取单个文物用于编辑
    private void editRelic(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int relicId = Integer.parseInt(request.getParameter("relicId"));
        Relic_Bean relic = relicDAO.getRelicById(relicId);
        request.setAttribute("relic", relic);
    }

    // 修改文物
    private void updateRelic(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Part imageFile = request.getPart("imageFile");
        String imagePath = saveImageToServer(request, imageFile);

        int relicId = Integer.parseInt(request.getParameter("relicId"));
        String relicName = request.getParameter("relicName");
        String dynasty = request.getParameter("dynasty");
        String description = request.getParameter("description");
        int hallId = Integer.parseInt(request.getParameter("hallId"));
        Integer createdBy = request.getParameter("createdBy") != null ? Integer.parseInt(request.getParameter("createdBy")) : null;

        Relic_Bean relic = new Relic_Bean();
        relic.setRelicId(relicId);
        relic.setRelicName(relicName);
        relic.setDynasty(dynasty);
        relic.setDescription(description);
        relic.setHallId(hallId);
        relic.setImagePath(imagePath);
        relic.setCreatedBy(createdBy);

        relicDAO.updateRelic(relic);
    }

    // 删除文物
    private void deleteRelic(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int relicId = Integer.parseInt(request.getParameter("relicId"));
        relicDAO.deleteRelic(relicId);
    }

    private String saveImageToServer(HttpServletRequest request, Part imageFile) throws IOException {
        if (imageFile != null && imageFile.getSize() > 0) {
            // 获取文件名
            String fileName = UUID.randomUUID().toString() + "_" + Paths.get(imageFile.getSubmittedFileName()).getFileName().toString();

            // 定义存储路径
            String uploadDir = getServletContext().getRealPath("/uploads");
            File uploadDirFile = new File(uploadDir);
            if (!uploadDirFile.exists()) {
                uploadDirFile.mkdirs(); // 创建目录
            }

            // 保存文件
            String filePath = uploadDir + File.separator + fileName;
            imageFile.write(filePath);

            // 返回文件的 URL
            return request.getContextPath() + "/uploads/" + fileName;
        }
        return null;
    }
}