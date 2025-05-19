<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="header.jsp" %>
<%@ include file="sidebar.jsp" %>

<!-- 主内容区 -->
<div class="main-content py-4">
    <h3 class="mb-4 text-center">用户管理</h3>

    <!-- 用户搜索与新增 -->
    <div class="card mb-4">
        <div class="card-body py-2 d-flex justify-content-between align-items-center">
            <form class="d-flex gap-2" style="flex: 1; max-width: 50%;">
                <input type="text" class="form-control form-control-sm" placeholder="用户名/手机号" style="flex: 1;">
                <button class="btn btn-sm btn-primary">搜索</button>
            </form>
            <!-- 空盒子用于间隔 -->
            <div style="width: 16px;"></div>
            <!-- 新增用户按钮 -->
            <a href="${pageContext.request.contextPath}/admin/function/user_edit.jsp" class="btn btn-sm btn-success d-flex align-items-center"
               style="white-space: nowrap;">新增用户</a>
        </div>
    </div>

    <!-- 用户列表 -->
    <div class="card">
        <div class="card-body">
            <table class="table table-hover">
                <thead class="table-dark">
                <tr>
                    <th>用户名</th>
                    <th>角色</th>
                    <th>实名状态</th>
                    <th>注册时间</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${userList}" var="user">
                    <tr>
                        <td>${user.username}</td>
                        <td>
                            <span class="badge ${user.role == 'admin' ? 'bg-danger' : 'bg-primary'}">
                                    ${user.role}
                            </span>
                        </td>
                        <td>
                            <i class="bi ${user.realNameVerified ? 'bi-check-circle-fill text-success' : 'bi-x-circle-fill text-danger'}"></i>
                        </td>
                        <td><fmt:formatDate value="${user.createTime}" pattern="yyyy-MM-dd"/></td>
                        <td>
                            <a href="UserServlet?action=edit&id=${user.userId}"
                               class="btn btn-sm btn-outline-warning me-2">编辑</a>
                            <button class="btn btn-sm btn-outline-danger"
                                    onclick="confirmDelete(${user.userId})">删除</button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- 删除确认脚本 -->
<script>
    function confirmDelete(id) {
        if (confirm('确定删除该条目？')) {
            window.location = 'UserServlet?action=delete&id=' + id;
        }
    }
</script>

<%@ include file="footer.jsp" %>