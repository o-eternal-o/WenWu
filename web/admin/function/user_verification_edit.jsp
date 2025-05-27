<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="../header.jsp" %>
<%@ include file="../sidebar.jsp" %>

<div class="main-content py-4">
    <h3 class="mb-4 text-center">${empty verification.verificationId ? '新增实名认证' : '编辑实名认证'}</h3>
    <form id="verificationForm" method="post">
        <input type="hidden" name="action" value="${empty verification.verificationId ? 'add' : 'update'}">
        <c:if test="${not empty verification.verificationId}">
            <input type="hidden" name="verificationId" value="${verification.verificationId}">
        </c:if>
        <div class="row g-3">
            <div class="col-md-6">
                <label class="form-label" for="userId">用户ID<span class="text-danger">*</span></label>
                <input type="number" class="form-control" id="userId" name="userId"
                       value="${verification.userId}" required>
            </div>
            <div class="col-md-6">
                <label class="form-label" for="realName">真实姓名<span class="text-danger">*</span></label>
                <input type="text" class="form-control" id="realName" name="realName"
                       value="${verification.realName}" required>
            </div>
            <div class="col-md-6">
                <label class="form-label" for="phone">联系电话<span class="text-danger">*</span></label>
                <input type="text" class="form-control" id="phone" name="phone"
                       value="${verification.phone}" required>
            </div>
            <div class="col-md-6">
                <label class="form-label" for="idNumber">证件号码<span class="text-danger">*</span></label>
                <input type="text" class="form-control" id="idNumber" name="idNumber"
                       value="${verification.idNumber}" required>
            </div>
            <div class="col-md-6">
                <label class="form-label" for="idImage">证件图片</label>
                <c:if test="${not empty verification.idImagePath}">
                    <div class="mb-2">
                        <img src="${verification.idImagePath}" alt="证件图片" class="img-thumbnail" style="max-width: 200px;">
                    </div>
                </c:if>
                <input type="file" class="form-control" id="idImage" name="idImage" accept="image/*">
            </div>
            <div class="col-md-6">
                <label class="form-label" for="status">状态</label>
                <select class="form-select" id="status" name="status">
                    <option value="PENDING" ${verification.status == 'PENDING' ? 'selected' : ''}>待审核</option>
                    <option value="APPROVED" ${verification.status == 'APPROVED' ? 'selected' : ''}>已通过</option>
                    <option value="REJECTED" ${verification.status == 'REJECTED' ? 'selected' : ''}>已拒绝</option>
                </select>
            </div>
            <div class="col-md-6">
                <label class="form-label" for="submittedAt">提交时间</label>
                <input type="text" class="form-control" id="submittedAt" name="submittedAt"
                       value="${verification.submittedAt}" readonly>
            </div>
            <div class="col-md-6">
                <label class="form-label" for="reviewedAt">审核时间</label>
                <input type="text" class="form-control" id="reviewedAt" name="reviewedAt"
                       value="${verification.reviewedAt}" readonly>
            </div>
            <div class="col-md-6">
                <label class="form-label" for="reviewedBy">审核人ID</label>
                <input type="number" class="form-control" id="reviewedBy" name="reviewedBy"
                       value="${verification.reviewedBy}">
            </div>
            <div class="col-12">
                <label class="form-label" for="rejectReason">拒绝原因</label>
                <textarea class="form-control" id="rejectReason" name="rejectReason" rows="2">${verification.rejectReason}</textarea>
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
        window.location = '${pageContext.request.contextPath}/UserVerificationServlet?action=list';
    }

    document.addEventListener("DOMContentLoaded", function() {
        const verificationForm = document.getElementById("verificationForm");

        // 设置时间字段为只读
        const submittedAtField = document.getElementById("submittedAt");
        const reviewedAtField = document.getElementById("reviewedAt");

        if (!submittedAtField.value) {
            // 新增时设置提交时间为当前时间
            const now = new Date().toISOString().slice(0, 19).replace("T", " ");
            submittedAtField.value = now;
        }
        // 审核时间始终为当前时间
        reviewedAtField.value = new Date().toISOString().slice(0, 19).replace("T", " ");

        // 提交表单
        verificationForm.addEventListener("submit", function(event) {
            event.preventDefault();

            const formData = new FormData(this); // 使用 FormData 包含表单数据
            const verificationId = formData.get("verificationId");
            const action = verificationId ? "update" : "add";
            const url = `${pageContext.request.contextPath}/UserVerificationServlet?action=` + action;

            const xhr = new XMLHttpRequest();
            xhr.open("POST", url, true);
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4) {
                    if (xhr.status === 200) {
                        if (xhr.responseText === "success") {
                            alert("保存成功！");
                            window.location = `${pageContext.request.contextPath}/UserVerificationServlet?action=list`;
                        } else {
                            alert("保存失败，请稍后再试！");
                        }
                    } else {
                        alert("请求出错，请检查网络连接！");
                    }
                }
            };
            xhr.send(formData); // 直接发送 FormData
        });
    });
</script>