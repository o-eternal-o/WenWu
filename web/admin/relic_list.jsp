<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>
<%@ include file="header.jsp" %>
<%@ include file="sidebar.jsp" %>
<!-- DataTables 插件 -->
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

<script>
    $(document).ready(function () {
        $('#relicTable').DataTable({
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
    <h3 class="mb-4 text-center">文物管理</h3>

    <!-- 文物搜索、新增 -->
    <div class="card mb-4">
        <div class="card-body py-2 d-flex justify-content-between align-items-center">
            <form id="searchForm" action="${pageContext.request.contextPath}/RelicServlet" method="post" class="d-flex gap-2" style="flex: 1; max-width: 60%;">
                <input type="hidden" name="action" value="search">
                <select id="searchType" name="searchType" class="form-select form-select-sm" style="width: auto;">
                    <option value="relic_name">文物名称</option>
                    <option value="dynasty">所属朝代</option>
                    <option value="description">描述</option>
                </select>
                <input id="searchInput" name="searchInput" type="text" class="form-control form-control-sm" placeholder="请输入查询内容" style="flex: 1;">
                <button id="searchButton" type="submit" class="btn btn-sm btn-primary">搜索</button>
            </form>
            <a href="${pageContext.request.contextPath}/admin/function/relic_edit.jsp" class="btn btn-sm btn-success d-flex align-items-center" style="white-space: nowrap;">新增文物</a>
        </div>
    </div>

    <!-- 文物列表 -->
    <div class="card mb-5">
        <div class="card-body">
            <table id="relicTable" class="table table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>文物名称</th>
                        <th>所属朝代</th>
                        <th>展厅ID</th>
                        <th>图片路径</th>
                        <th>创建人</th>
                        <th>创建时间</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                <c:if test="${empty requestScope.relicList}">
                    <p>暂无文物信息</p>
                </c:if>
                <c:forEach var="relic" items="${requestScope.relicList}">
                    <tr>
                        <td>${relic.relicName}</td>
                        <td>${relic.dynasty}</td>
                        <td>${relic.hallId}</td>
                        <td>${relic.imagePath}</td>
                        <td>${relic.createdBy}</td>
                        <td>${relic.createdAt}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/RelicServlet?action=edit&relicId=${relic.relicId}" class="btn btn-sm btn-primary me-2">编辑</a>
                            <button class="btn btn-sm btn-danger" onclick="confirmDelete('${relic.relicId}')">删除</button>
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
    function confirmDelete(relicId) {
        if (confirm("确定要删除该文物吗？")) {
            fetch('RelicServlet?action=delete&relicId=' + relicId, {
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