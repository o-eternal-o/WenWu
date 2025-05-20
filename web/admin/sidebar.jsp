<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<div class="sidebar col-md-2 sidebar" style="width: 200px;">
  <a href="#" class="sidebar-brand">文物展厅管理</a>
  <nav class="nav flex-column">
    <a class="nav-link active" href="${pageContext.request.contextPath}/AdminServlet">
      <i class="bi bi-speedometer2 me-2"></i>
      控制面板
    </a>
    <a class="nav-link" href="${pageContext.request.contextPath}/HallServlet?action=list">
      <i class="bi bi-building me-2"></i>
      展厅管理
    </a>
    <a class="nav-link" href="${pageContext.request.contextPath}/admin/relic_list.jsp">
      <i class="bi bi-archive me-2"></i>
      文物管理
    </a>
    <a class="nav-link" href="${pageContext.request.contextPath}/admin/news_list.jsp">
      <i class="bi bi-newspaper me-2"></i>
      新闻管理
    </a>
    <a class="nav-link" href="${pageContext.request.contextPath}/admin/user_list.jsp">
      <i class="bi bi-people me-2"></i>
      用户管理
    </a>
    <a class="nav-link" href="${pageContext.request.contextPath}/index.html">
      <i class="bi bi-box-arrow-right me-2"></i>
      退出登录
    </a>
  </nav>
</div>
