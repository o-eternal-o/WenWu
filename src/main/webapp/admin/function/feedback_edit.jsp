<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="../header.jsp" %>
<%@ include file="../sidebar.jsp" %>

<div class="main-content py-4">
    <h3 class="mb-4 text-center">${empty feedback.feedbackId ? '新增反馈' : '编辑反馈'}</h3>
    <form id="feedbackForm" method="post">
        <input type="hidden" name="action" value="${empty feedback.feedbackId ? 'add' : 'update'}">
        <c:if test="${not empty feedback.feedbackId}">
            <input type="hidden" name="feedbackId" value="${feedback.feedbackId}">
        </c:if>
        <div class="row g-3">
            <div class="col-md-6">
                <label class="form-label" for="userId">用户ID<span class="text-danger">*</span></label>
                <input type="number" class="form-control" id="userId" name="userId"
                       value="${feedback.userId}" required>
            </div>
            <div class="col-md-6">
                <label class="form-label" for="relicId">文物ID</label>
                <input type="number" class="form-control" id="relicId" name="relicId"
                       value="${feedback.relicId}">
            </div>
            <div class="col-12">
                <label class="form-label" for="content">反馈内容<span class="text-danger">*</span></label>
                <textarea class="form-control" id="content" name="content" rows="3" required>${feedback.content}</textarea>
            </div>
            <div class="col-md-6">
                <label class="form-label" for="status">状态</label>
                <select class="form-select" id="status" name="status">
                    <option value="submitted" ${feedback.status == 'submitted' ? 'selected' : ''}>已提交</option>
                    <option value="processing" ${feedback.status == 'processing' ? 'selected' : ''}>处理中</option>
                    <option value="resolved" ${feedback.status == 'resolved' ? 'selected' : ''}>已解决</option>
                </select>
            </div>
            <div class="col-md-6">
                <label class="form-label" for="createdAt">创建时间</label>
                <input type="text" class="form-control" id="createdAt" name="createdAt"
                       value="${feedback.createdAt}" placeholder="yyyy-MM-dd HH:mm:ss">
            </div>
            <div class="col-12">
                <label class="form-label" for="resolvedResult">处理结果</label>
                <textarea class="form-control" id="resolvedResult" name="resolvedResult" rows="2">${feedback.resolvedResult}</textarea>
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
        window.location = '${pageContext.request.contextPath}/FeedbackServlet?action=list';
    }

    document.addEventListener("DOMContentLoaded", function() {
        document.getElementById("feedbackForm").addEventListener("submit", function(event) {
            event.preventDefault();
            const formElements = this.elements;
            const formData = {};
            for (let element of formElements) {
                if (element.name && !element.disabled) {
                    formData[element.name] = element.value;
                }
            }
            const feedbackId = document.querySelector("input[name='feedbackId']")?.value;
            const action = feedbackId ? 'update' : 'add';
            const url = `${pageContext.request.contextPath}/FeedbackServlet?action=` + action;

            const xhr = new XMLHttpRequest();
            xhr.open("POST", url, true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4) {
                    if (xhr.status === 200) {
                        if (xhr.responseText === "success") {
                            alert("保存成功！");
                            window.location = '${pageContext.request.contextPath}/FeedbackServlet?action=list';
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
