<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="../header.jsp" %>
<%@ include file="../sidebar.jsp" %>

<div class="main-content py-4">
    <h3 class="mb-4 text-center">${empty user.userId ? '新增用户' : '编辑用户'}</h3>
    <form id="userForm" method="post">
        <input type="hidden" name="action" value="${empty user.userId ? 'add' : 'update'}">
        <c:if test="${not empty user.userId}">
            <input type="hidden" name="userId" value="${user.userId}">
        </c:if>
        <div class="row g-3">
            <div class="col-md-6">
                <label class="form-label" for="username">用户名<span class="text-danger">*</span></label>
                <input type="text" class="form-control" id="username" name="username"
                       value="${user.username}" required>
            </div>
            <div class="col-md-6">
                <label class="form-label" for="password">密码<span class="text-danger">*</span></label>
                <input type="password" class="form-control" id="password" name="password"
                       value="${user.password}" required>
            </div>
            <div class="col-md-6">
                <label class="form-label" for="phone">手机号</label>
                <input type="text" class="form-control" id="phone" name="phone"
                       value="${user.phone}">
            </div>
            <div class="col-md-6">
                <label class="form-label" for="role">角色</label>
                <select class="form-select" id="role" name="role">
                    <option value="admin" ${user.role == 'admin' ? 'selected' : ''}>管理员</option>
                    <option value="visitor" ${user.role == 'visitor' ? 'selected' : ''}>访客</option>
                </select>
            </div>
            <div class="col-md-6">
                <label class="form-label" for="realName">实名</label>
                <input type="text" class="form-control" id="realName" name="realName"
                       value="${user.realName}">
            </div>
            <div class="col-md-6">
                <label class="form-label" for="realNameVerified">实名状态</label>
                <select class="form-select" id="realNameVerified" name="realNameVerified">
                    <option value="1" ${user.realNameVerified ? 'selected' : ''}>已实名</option>
                    <option value="0" ${!user.realNameVerified ? 'selected' : ''}>未实名</option>
                </select>
            </div>
            <div class="col-md-6">
                <label class="form-label" for="createdAt">创建时间</label>
                <input type="text" class="form-control" id="createdAt" name="createdAt"
                       value="${user.createdAt}" placeholder="yyyy-MM-dd HH:mm:ss">
            </div>
        </div>
        <div class="mt-4 d-flex justify-content-between">
            <button type="submit" class="btn btn-primary">保存</button>
            <button type="button" class="btn btn-secondary" onclick="goBack()">返回</button>
        </div>
    </form>
</div>

<%@ include file="../footer.jsp" %>

<script>
    function goBack() {
        if (document.referrer) {
            history.back();
            window.name = "refresh";
            history.back();
        } else {
            window.location = '${pageContext.request.contextPath}/admin/admin.jsp';
        }
    }

    document.addEventListener("DOMContentLoaded", function() {
        document.getElementById("userForm").addEventListener("submit", function(event) {
            event.preventDefault();
            const formElements = this.elements;
            const formData = {};
            for (let element of formElements) {
                if (element.name && !element.disabled) {
                    formData[element.name] = element.value;
                }
            }
            const userId = document.querySelector("input[name='userId']")?.value;
            const action = userId ? 'update' : 'add';
            const url = `${pageContext.request.contextPath}/UserServlet?action=` + action;

            const xhr = new XMLHttpRequest();
            xhr.open("POST", url, true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4) {
                    if (xhr.status === 200) {
                        if (xhr.responseText === "success") {
                            alert("保存成功！");
                            window.location = '${pageContext.request.contextPath}/UserServlet?action=list';
                        } else {
                            alert("保存失败，请稍后再试！");
                        }
                    } else {
                        alert("请求出错，请检查网络连接！");
                    }
                }
            };
            const requestBody = Object.keys(formData)
                .map(key => encodeURIComponent(key) + "=" + encodeURIComponent(formData[key]))
                .join("&");
            xhr.send(requestBody);
        });
    });
</script>