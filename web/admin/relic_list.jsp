<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="header.jsp" %>
<%@ include file="sidebar.jsp" %>

<!-- 主内容区 -->
<div class="main-content py-4">
  <h3 class="mb-4 text-center">文物管理</h3>

  <!-- 文物搜索与新增 -->
  <div class="card mb-4">
    <div class="card-body py-2 d-flex justify-content-between align-items-center">
      <form class="d-flex gap-2" style="flex: 1; max-width: 50%;">
        <input type="text" class="form-control form-control-sm" placeholder="文物名称/朝代" style="flex: 1;">
        <button class="btn btn-sm btn-primary">搜索</button>
      </form>
      <!-- 空盒子用于间隔 -->
      <div style="width: 16px;"></div>
      <!-- 新增文物按钮 -->
      <a href="${pageContext.request.contextPath}/admin/function/relic_edit.jsp" class="btn btn-sm btn-success d-flex align-items-center"
         style="white-space: nowrap;">新增文物</a>
    </div>
  </div>

  <!-- 文物列表 -->
  <div class="card">
    <div class="card-body">
      <table class="table table-hover">
        <thead class="table-dark">
        <tr>
          <th>文物名称</th>
          <th>朝代</th>
          <th>所属展厅</th>
          <th>最后更新</th>
          <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${relicList}" var="relic">
          <tr>
            <td>${relic.relicName}</td>
            <td>${relic.dynasty}</td>
            <td>${relic.hallName}</td>
            <td><fmt:formatDate value="${relic.updateTime}" pattern="yyyy-MM-dd"/></td>
            <td>
              <a href="RelicServlet?action=edit&id=${relic.relicId}"
                 class="btn btn-sm btn-outline-warning me-2">编辑</a>
              <button class="btn btn-sm btn-outline-danger"
                      onclick="confirmDelete(${relic.relicId})">删除</button>
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
      window.location = 'RelicServlet?action=delete&id=' + id;
    }
  }
</script>

<%@ include file="footer.jsp" %>