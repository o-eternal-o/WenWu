<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="../header.jsp" %>
<%@ include file="../sidebar.jsp" %>

<div class="main-content py-4">
    <h3 class="mb-4 text-center">${empty relic.relicId ? '新增文物' : '编辑文物'}</h3>

    <form id="relicForm" method="post" enctype="multipart/form-data">
        <input type="hidden" name="action" value="${empty relic.relicId ? 'add' : 'update'}">
        <c:if test="${not empty relic.relicId}">
            <input type="hidden" name="relicId" value="${relic.relicId}">
        </c:if>

        <div class="row g-3">
            <div class="col-md-6">
                <label class="form-label" for="relicName">文物名称<span class="text-danger">*</span></label>
                <input type="text" class="form-control" id="relicName" name="relicName"
                       value="${relic.relicName}" required>
            </div>

            <div class="col-md-6">
                <label class="form-label" for="dynasty">所属朝代</label>
                <input type="text" class="form-control" id="dynasty" name="dynasty"
                       value="${relic.dynasty}">
            </div>

            <div class="col-md-6">
                <label class="form-label" for="hallId">展厅ID<span class="text-danger">*</span></label>
                <input type="number" class="form-control" id="hallId" name="hallId"
                       value="${relic.hallId}" required>
            </div>

            <div class="col-md-6">
                <label class="form-label" for="imagePath">图片路径</label>
                <c:if test="${not empty relic.imagePath}">
                    <div class="mb-2">
                        <img src="${relic.imagePath}" alt="文物图片" class="img-thumbnail" style="max-width: 200px;">
                    </div>
                </c:if>
                <input type="file" class="form-control" id="imagePath" name="imageFile" accept="image/*">
            </div>

            <div class="col-md-6">
                <label class="form-label" for="createdBy">创建人ID</label>
                <input type="number" class="form-control" id="createdBy" name="createdBy"
                       value="${relic.createdBy}">
            </div>

            <div class="col-md-6">
                <label class="form-label" for="createdAt">创建时间</label>
                <input type="text" class="form-control" id="createdAt" name="createdAt"
                       value="${relic.createdAt}" readonly>
            </div>

            <div class="col-12">
                <label class="form-label" for="description">描述</label>
                <textarea class="form-control" id="description" name="description" rows="4">${relic.description}</textarea>
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
        window.location = '${pageContext.request.contextPath}/RelicServlet?action=list'; // 默认链接
    }

    document.addEventListener("DOMContentLoaded", function() {
        document.getElementById("relicForm").addEventListener("submit", function(event) {
            event.preventDefault();

            const formData = new FormData(this); // 使用 FormData 包含表单数据
            const relicId = formData.get("relicId");
            const action = relicId ? 'update' : 'add';
            const url = `${pageContext.request.contextPath}/RelicServlet?action=` + action;

            const xhr = new XMLHttpRequest();
            xhr.open("POST", url, true);
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4) {
                    if (xhr.status === 200) {
                        if (xhr.responseText === "success") {
                            alert("保存成功！");
                            window.location = `${pageContext.request.contextPath}/admin/relic_list.jsp`;
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