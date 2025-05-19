<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="header.jsp" %>
<%@ include file="sidebar.jsp" %>

<!-- 主内容区 -->
<div class="main-content py-4">
    <h3 class="mb-4 text-center">新闻管理</h3>

    <!-- 新闻搜索与新增 -->
    <div class="card mb-4">
        <div class="card-body py-2 d-flex justify-content-between align-items-center">
            <form class="d-flex gap-2" style="flex: 1; max-width: 50%;">
                <input type="text" class="form-control form-control-sm" placeholder="新闻标题/分类" style="flex: 1;">
                <button class="btn btn-sm btn-primary">搜索</button>
            </form>
            <!-- 空盒子用于间隔 -->
            <div style="width: 16px;"></div>
            <!-- 新增新闻按钮 -->
            <a href="${pageContext.request.contextPath}/admin/function/new_edit.jsp" class="btn btn-sm btn-success d-flex align-items-center"
               style="white-space: nowrap;">发布新闻</a>
        </div>
    </div>

    <!-- 新闻列表 -->
    <div class="card">
        <div class="card-body">
            <table class="table table-hover">
                <thead class="table-dark">
                <tr>
                    <th>标题</th>
                    <th>发布时间</th>
                    <th>发布人</th>
                    <th>状态</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${newsList}" var="news">
                    <tr>
                        <td>${news.title}</td>
                        <td><fmt:formatDate value="${news.publishTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                        <td>${news.publisher}</td>
                        <td>
                            <span class="badge ${news.status == 'published' ? 'bg-success' : 'bg-secondary'}">
                                    ${news.status == 'published' ? '已发布' : '草稿'}
                            </span>
                        </td>
                        <td>
                            <a href="NewsServlet?action=edit&id=${news.newsId}"
                               class="btn btn-sm btn-outline-warning me-2">编辑</a>
                            <button class="btn btn-sm btn-outline-danger"
                                    onclick="confirmDelete(${news.newsId})">删除</button>
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
            window.location = 'NewsServlet?action=delete&id=' + id;
        }
    }
</script>

<%@ include file="footer.jsp" %>