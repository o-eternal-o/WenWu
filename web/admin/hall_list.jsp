<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="header.jsp" %>
<%@ include file="sidebar.jsp" %>

<!-- 主内容区 -->
<div class="main-content py-4">
    <h3 class="mb-4 text-center">展厅管理</h3>

    <!-- 展厅搜索与新增 -->
    <div class="card mb-4">
        <div class="card-body py-2 d-flex justify-content-between align-items-center">
            <form class="d-flex gap-2" style="flex: 1; max-width: 50%;">
                <input type="text" class="form-control form-control-sm" placeholder="展厅名称/位置" style="flex: 1;">
                <button class="btn btn-sm btn-primary">搜索</button>
            </form>
            <!-- 空盒子用于间隔 -->
            <div style="width: 16px;"></div>
            <!-- 新增展厅按钮 -->
            <a href="${pageContext.request.contextPath}/admin/function/hall_edit.jsp" class="btn btn-sm btn-success d-flex align-items-center"
               style="white-space: nowrap;">新增展厅</a>
        </div>
    </div>

    <!-- 展厅列表 -->
    <div class="card mb-5">
        <div class="card-body">
            <table class="table table-hover">
                <thead class="table-dark">
                <tr>
                    <th>展厅名称</th>
                    <th>展厅位置</th>
                    <th>展厅描述</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${hallList}" var="hall">
                    <tr>
                        <td>${hall.hallName}</td>
                        <td>${hall.location}</td>
                        <td>${hall.description}</td>
                        <td>
                            <a href="HallServlet?action=edit&hallId=${hall.hallId}"
                               class="btn btn-sm btn-outline-warning me-2">编辑</a>
                            <button class="btn btn-sm btn-outline-danger"
                                    onclick="confirmDelete(${hall.hallId})">删除</button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

<!-- 删除确认脚本 -->
<script>
    function confirmDelete(id) {
        if (confirm('确定删除该条目？')) {
            window.location = 'HallServlet?action=delete&hallId=' + id;
        }
    }
</script>

<%@ include file="footer.jsp" %>