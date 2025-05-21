<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>
<%@ include file="header.jsp" %>
<%@ include file="sidebar.jsp" %>
<!-- 引入 DataTables 插件 -->
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

<script>
    $(document).ready(function () {
        $('#hallTable').DataTable({
            "paging": true, // 启用分页
            "ordering": true, // 启用排序
            "info": true, // 显示信息
            "language": {
                "url": "https://cdn.datatables.net/plug-ins/1.13.6/i18n/zh-Hans.json" // 中文语言包
            }
        });
    });
</script>

<!-- 主内容区 -->
<div class="main-content py-4">
    <h3 class="mb-4 text-center">展厅管理</h3>

    <!-- 展厅搜索、新增 -->
    <div class="card mb-4">
        <div class="card-body py-2 d-flex justify-content-between align-items-center">

            <form id="searchForm" action="${pageContext.request.contextPath}/HallServlet" method="post" class="d-flex gap-2" style="flex: 1; max-width: 60%;">
                <!-- 隐藏字段：action -->
                <input type="hidden" name="action" value="search">

                <!-- 下拉菜单 -->
                <select id="searchType" name="searchType" class="form-select form-select-sm" style="width: auto;">
                    <option value="hall_name">名称</option>
                    <option value="dynasty">所属朝代</option>
                    <option value="type">文物类型</option>
                </select>

                <!-- 输入框 -->
                <input id="searchInput" name="searchInput" type="text" class="form-control form-control-sm" placeholder="请输入查询内容" style="flex: 1;">

                <!-- 搜索按钮 -->
                <button id="searchButton" type="submit" class="btn btn-sm btn-primary">搜索</button>
            </form>

            <!-- 新增展厅按钮 -->
            <a href="${pageContext.request.contextPath}/admin/function/hall_edit.jsp" class="btn btn-sm btn-success d-flex align-items-center"
               style="white-space: nowrap;">新增展厅</a>

        </div>
    </div>

    <!-- 展厅列表 -->
    <div class="card mb-5">
        <div class="card-body">
            <table id="hallTable" class="table table-hover">
            <thead class="table-dark">
                <tr>
<%--                    <th>展厅ID</th>--%>
                    <th>展厅名称</th>
                    <th>所属朝代</th>
                    <th>文物类型</th>
                    <th>预约状态</th>
                    <th>预约时间</th>
                    <th>最大承载人数</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <!-- 动态生成展厅信息 -->
                <c:if test="${empty requestScope.hallList}">
                    <p>暂无展厅信息</p>
                </c:if>
                <c:forEach var="hall" items="${requestScope.hallList}">
                    <tr>
                        <!-- 展厅 ID -->
<%--                        <td>${hall.hallId}</td>--%>
                        <!-- 展厅名称 -->
                        <td>${hall.hallName}</td>
                        <!-- 所属朝代 -->
                        <td>${hall.dynasty}</td>
                        <!-- 文物类型 -->
                        <td>${hall.type}</td>
                        <!-- 预约状态 -->
                        <td>
                            <c:choose>
                                <c:when test="${hall.openBooking}">
                                    <span class="badge bg-success">开放</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-danger">关闭</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <!-- 预约时间 -->
                        <td>
                                ${hall.bookingStartTime} 至 ${hall.bookingEndTime}
                        </td>
                        <!-- 最大承载人数 -->
                        <td>${hall.maxCapacity}</td>
                        <!-- 操作按钮 -->
                        <td>
                            <!-- 编辑按钮 -->
                            <a href="${pageContext.request.contextPath}/HallServlet?action=edit&hallId=${hall.hallId}"
                               class="btn btn-sm btn-primary me-2">编辑</a>
                            <!-- 删除按钮 -->
                            <button class="btn btn-sm btn-danger" onclick="confirmDelete('${hall.hallId}')">删除</button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>

<%--删除反馈--%>
<script>
    function confirmDelete(hallId) {
        if (confirm("确定要删除该展厅吗？")) {
            fetch('HallServlet?action=delete&hallId=' + hallId, {
                        method: 'POST'
            })
                .then(response => response.text()) // 解析纯文本响应
                .then(data => {
                    if (data === "success") {
                        alert("删除成功！");
                        location.reload(); // 刷新页面以更新展厅列表
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
<%--处理反回--%>
<script>
    window.onload = function() {
        if (window.name === "refresh") {
            window.name = ""; // 清除标记
            location.reload();
        }
    };
</script>