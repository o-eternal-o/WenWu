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
        $('#newsTable').DataTable({
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
    <h3 class="mb-4 text-center">新闻资讯管理</h3>
    <div class="card mb-4">
        <div class="card-body py-2 d-flex justify-content-between align-items-center">
            <form id="searchForm" action="${pageContext.request.contextPath}/NewsServlet" method="post" class="d-flex gap-2" style="flex: 1; max-width: 60%;">
                <input type="hidden" name="action" value="search">
                <select id="searchType" name="searchType" class="form-select form-select-sm" style="width: auto;">
                    <option value="title">标题</option>
                    <option value="content">内容</option>
                </select>
                <input id="searchInput" name="searchInput" type="text" class="form-control form-control-sm" placeholder="请输入查询内容" style="flex: 1;">
                <button id="searchButton" type="submit" class="btn btn-sm btn-primary">搜索</button>
            </form>
            <a href="${pageContext.request.contextPath}/admin/function/news_edit.jsp" class="btn btn-sm btn-success d-flex align-items-center" style="white-space: nowrap;">新增新闻</a>
        </div>
    </div>
    <div class="card mb-5">
        <div class="card-body">
            <table id="newsTable" class="table table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>标题</th>
                        <th>内容</th>
                        <th>发布时间</th>
                        <th>发布人ID</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                <c:if test="${empty requestScope.newsList}">
                    <p>暂无新闻信息</p>
                </c:if>
                <c:forEach var="news" items="${requestScope.newsList}">
                    <tr>
                        <td>${news.title}</td>
                        <td>${news.content}</td>
                        <td>${news.publishTime}</td>
                        <td>${news.publisherId}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/NewsServlet?action=edit&newsId=${news.newsId}" class="btn btn-sm btn-primary me-2">编辑</a>
                            <button class="btn btn-sm btn-danger" onclick="confirmDelete('${news.newsId}')">删除</button>
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
    function confirmDelete(newsId) {
        if (confirm("确定要删除该新闻吗？")) {
            fetch('NewsServlet?action=delete&newsId=' + newsId, {
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