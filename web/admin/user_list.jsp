<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>
<%@ include file="header.jsp" %>
<%@ include file="sidebar.jsp" %>
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

<script>
    $(document).ready(function () {
        $('#userTable').DataTable({
            "paging": true,
            "ordering": true,
            "info": true,
            "language": {
                "url": "https://cdn.datatables.net/plug-ins/1.13.6/i18n/zh-Hans.json"
            }
        });
    });
</script>

<div class="main-content py-4">
    <h3 class="mb-4 text-center">用户管理</h3>
    <div class="card mb-4">
        <div class="card-body py-2 d-flex justify-content-between align-items-center">
            <form id="searchForm" action="${pageContext.request.contextPath}/UserServlet" method="post" class="d-flex gap-2" style="flex: 1; max-width: 60%;">
                <input type="hidden" name="action" value="search">
                <select id="searchType" name="searchType" class="form-select form-select-sm" style="width: auto;">
                    <option value="username">用户名</option>
                    <option value="phone">手机号</option>
                    <option value="role">角色</option>
                </select>
                <input id="searchInput" name="searchInput" type="text" class="form-control form-control-sm" placeholder="请输入查询内容" style="flex: 1;">
                <button id="searchButton" type="submit" class="btn btn-sm btn-primary">搜索</button>
            </form>
            <a href="${pageContext.request.contextPath}/admin/function/user_edit.jsp" class="btn btn-sm btn-success d-flex align-items-center" style="white-space: nowrap;">新增用户</a>
        </div>
    </div>
    <div class="card mb-5">
        <div class="card-body">
            <table id="userTable" class="table table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>用户名</th>
                        <th>手机号</th>
                        <th>角色</th>
                        <th>实名</th>
                        <th>实名状态</th>
                        <th>创建时间</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                <c:if test="${empty requestScope.userList}">
                    <p>暂无用户信息</p>
                </c:if>
                <c:forEach var="user" items="${requestScope.userList}">
                    <tr>
                        <td>${user.username}</td>
                        <td>${user.phone}</td>
                        <td>${user.role}</td>
                        <td>${user.realName}</td>
                        <td>
                            <c:choose>
                                <c:when test="${user.realNameVerified}">
                                    <span class="badge bg-success">已实名</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-danger">未实名</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${user.createdAt}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/UserServlet?action=edit&userId=${user.userId}" class="btn btn-sm btn-primary me-2">编辑</a>
                            <button class="btn btn-sm btn-danger" onclick="confirmDelete('${user.userId}')">删除</button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>

<script>
    function confirmDelete(userId) {
        if (confirm("确定要删除该用户吗？")) {
            fetch('UserServlet?action=delete&userId=' + userId, {
                method: 'POST'
            })
            .then(response => response.text())
            .then(data => {
                if (data === "success") {
                    alert("删除成功！");
                    location.reload();
                } else {
                    alert("删除失败，请稍后再试！");
                }
            })
            .catch(error => {
                console.error("删除请求出错:", error);
                alert("删除请求出错，请检查网络连接！");
            });
        }
    }
</script>
<script>
    window.onload = function() {
        if (window.name === "refresh") {
            window.name = "";
            location.reload();
        }
    };
</script>