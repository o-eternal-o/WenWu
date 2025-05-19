<%@ include file="../header.jsp" %>
<h3 class="mb-4">${empty user ? '新增用户' : '编辑用户'}</h3>

<form action="UserServlet" method="post">
    <input type="hidden" name="action" value="${empty user.userId ? 'add' : 'update'}">
    <c:if test="${not empty user.userId}">
        <input type="hidden" name="userId" value="${user.userId}">
    </c:if>

    <div class="row g-3">
        <div class="col-md-6">
            <label class="form-label">用户名</label>
            <input type="text" class="form-control" name="username"
                   value="${user.username}" required>
        </div>

        <div class="col-md-6">
            <label class="form-label">角色</label>
            <select class="form-select" name="role">
                <option value="admin" ${user.role == 'admin' ? 'selected' : ''}>管理员</option>
                <option value="visitor" ${user.role == 'visitor' ? 'selected' : ''}>游客</option>
            </select>
        </div>

        <div class="col-md-6">
            <label class="form-label">手机号</label>
            <input type="tel" class="form-control" name="phone"
                   value="${user.phone}" pattern="1[3-9]\d{9}">
        </div>

        <div class="col-md-6">
            <div class="form-check mt-4">
                <input class="form-check-input" type="checkbox" name="verified"
                       id="verified" ${user.realNameVerified ? 'checked' : ''}>
                <label class="form-check-label" for="verified">已实名认证</label>
            </div>
        </div>
    </div>

    <div class="mt-4">
        <button type="submit" class="btn btn-primary">保存</button>
        <button type="button" class="btn btn-secondary" onclick="goBack()">取消</button>
    </div>
</form>

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