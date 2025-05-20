<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="header.jsp">
  <jsp:param name="title" value="管理后台"/>
</jsp:include>

<div class="admin-container">
  <!-- 左侧导航栏 -->
  <jsp:include page="sidebar.jsp"/>

  <!-- 主内容区 -->
  <div class="main-content">
    <h3 class="mb-4">管理控制台</h3>

    <!-- 数据概览 -->
    <div class="row g-4 mb-4">
      <div class="col-md-3">
        <div class="stat-card">
          <h5 class="text-muted">开放展厅</h5>
          <h2 class="text-primary">${openHallCount}</h2>
        </div>
      </div>
      <div class="col-md-3">
        <div class="stat-card">
          <h5 class="text-muted">文物总数</h5>
          <h2 class="text-success">${relicTotal}</h2>
        </div>
      </div>
      <div class="col-md-3">
        <div class="stat-card">
          <h5 class="text-muted">待审预约</h5>
          <h2 class="text-warning">${pendingBookings}</h2>
        </div>
      </div>
      <div class="col-md-3">
        <div class="stat-card">
          <h5 class="text-muted">用户总数</h5>
          <h2 class="text-info">${userTotal}</h2>
        </div>
      </div>
    </div>

    <!-- 快捷操作 -->
    <div class="row g-4">
      <div class="col-md-4">
        <div class="card">
          <div class="card-body">
            <h5 class="card-title">快速操作</h5>
            <div class="d-grid gap-2">
              <a href="${pageContext.request.contextPath}/admin/function/hall_edit.jsp" class="btn btn-primary">
                <i class="bi bi-plus-circle"></i>
                新增展厅
              </a>
              <a href="${pageContext.request.contextPath}/admin/function/relic_edit.jsp" class="btn btn-success">
                <i class="bi bi-upload"></i>
                录入文物
              </a>
              <a href="${pageContext.request.contextPath}/admin/function/new_edit.jsp" class="btn btn-info">
                <i class="bi bi-megaphone"></i>
                发布新闻
              </a>
            </div>
          </div>
        </div>
      </div>

      <!-- 最新预约 -->
      <div class="col-md-8">
        <div class="card">
          <div class="card-body">
            <h5 class="card-title d-flex justify-content-between">
              <span>最新预约</span>
              <a href="#">查看更多</a>
            </h5>
            <table class="table table-striped">
              <thead>
              <tr>
                <th>用户</th>
                <th>预约时间</th>
                <th>状态</th>
              </tr>
              </thead>
              <tbody>
              <tr>
                <td>张三</td>
                <td>2023-10-01 10:00</td>
                <td><span class="badge bg-warning">待审核</span></td>
              </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- 引入公用尾部 -->
<%@ include file="footer.jsp" %>