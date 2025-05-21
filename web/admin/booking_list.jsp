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
            $('#bookingTable').DataTable({
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
        <h3 class="mb-4 text-center">预约管理</h3>
        <div class="card mb-4">
            <div class="card-body py-2 d-flex justify-content-between align-items-center">
                <form id="searchForm" action="${pageContext.request.contextPath}/BookingServlet" method="post" class="d-flex gap-2" style="flex: 1; max-width: 60%;">
                    <input type="hidden" name="action" value="search">
                    <select id="searchType" name="searchType" class="form-select form-select-sm" style="width: auto;">
                        <option value="user_id">用户ID</option>
                        <option value="hall_id">展厅ID</option>
                        <option value="status">状态</option>
                    </select>
                    <input id="searchInput" name="searchInput" type="text" class="form-control form-control-sm" placeholder="请输入查询内容" style="flex: 1;">
                    <button id="searchButton" type="submit" class="btn btn-sm btn-primary">搜索</button>
                </form>
                <a href="${pageContext.request.contextPath}/admin/function/booking_edit.jsp" class="btn btn-sm btn-success d-flex align-items-center" style="white-space: nowrap;">新增预约</a>
            </div>
        </div>
        <div class="card mb-5">
            <div class="card-body">
                <table id="bookingTable" class="table table-hover">
                    <thead class="table-dark">
                        <tr>
                            <th>预约ID</th>
                            <th>用户ID</th>
                            <th>展厅ID</th>
                            <th>预约时间</th>
                            <th>状态</th>
                            <th>团体</th>
                            <th>团体人数</th>
                            <th>创建时间</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                    <c:if test="${empty requestScope.bookingList}">
                        <tr><td colspan="9" class="text-center">暂无预约信息</td></tr>
                    </c:if>
                    <c:forEach var="b" items="${requestScope.bookingList}">
                        <tr>
                            <td>${b.bookingId}</td>
                            <td>${b.userId}</td>
                            <td>${b.hallId}</td>
                            <td>${b.bookingTime}</td>
                            <td>${b.status}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${b.group}"><span class="badge bg-success">是</span></c:when>
                                    <c:otherwise><span class="badge bg-secondary">否</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td>${b.groupSize}</td>
                            <td>${b.createdAt}</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/BookingServlet?action=edit&bookingId=${b.bookingId}" class="btn btn-sm btn-primary me-2">编辑</a>
                                <button class="btn btn-sm btn-danger" onclick="confirmDelete('${b.bookingId}')">删除</button>
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
        function confirmDelete(bookingId) {
            if (confirm("确定要删除该预约吗？")) {
                fetch('BookingServlet?action=delete&bookingId=' + bookingId, {
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