<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../header.jsp" %>
<%@ include file="../sidebar.jsp" %>

<!-- 主内容区 -->
<div class="main-content">
    <h3 class="mb-4">新增展厅</h3>

    <form action="HallServlet" method="post">
        <input type="hidden" name="action" value="${empty hall.hallId ? 'add' : 'update'}">
        <c:if test="${not empty hall.hallId}">
            <input type="hidden" name="hallId" value="${hall.hallId}">
        </c:if>

        <div class="row g-3">
            <div class="col-md-6">
                <label class="form-label">展厅名称</label>
                <input type="text" class="form-control" name="hallName"
                       value="${hall.hallName}" required>
            </div>

            <div class="col-md-6">
                <label class="form-label">展厅位置</label>
                <input type="text" class="form-control" name="location"
                       value="${hall.location}" required>
            </div>

            <div class="col-12">
                <label class="form-label">展厅描述</label>
                <textarea class="form-control" name="description" rows="4">${hall.description}</textarea>
            </div>
        </div>

        <div class="mt-4">
            <button type="submit" class="btn btn-primary">保存</button>
            <!-- 修改取消按钮 -->
            <button type="button" class="btn btn-secondary" onclick="goBack()">取消</button>
        </div>
    </form>
</div>

<script>
    // 返回上一页或跳转到默认页面
    function goBack() {
        if (document.referrer) {
            history.back(); // 返回上一页
        } else {
            window.location = '${pageContext.request.contextPath}/admin/admin.jsp'; // 默认链接
        }
    }
</script>

<%@ include file="../footer.jsp" %>