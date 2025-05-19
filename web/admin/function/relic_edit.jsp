<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../header.jsp" %>
<%@ include file="../sidebar.jsp" %>

<!-- 主内容区 -->
<div class="main-content">

    <h3 class="mb-4">${empty relic ? '新增文物' : '编辑文物'}</h3>

    <form action="RelicServlet" method="post" enctype="multipart/form-data">
        <input type="hidden" name="action" value="${empty relic.relicId ? 'add' : 'update'}">
        <c:if test="${not empty relic.relicId}">
            <input type="hidden" name="relicId" value="${relic.relicId}">
        </c:if>

        <div class="row g-3">
            <div class="col-md-6">
                <label class="form-label">文物名称</label>
                <input type="text" class="form-control" name="relicName"
                       value="${relic.relicName}" required>
            </div>

            <div class="col-md-6">
                <label class="form-label">所属展厅</label>
                <select class="form-select" name="hallId">
                    <c:forEach items="${hallList}" var="hall">
                        <option value="${hall.hallId}"
                            ${relic.hallId == hall.hallId ? 'selected' : ''}>
                                ${hall.hallName}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="col-12">
                <label class="form-label">文物描述</label>
                <textarea class="form-control" name="description"
                          rows="4">${relic.description}</textarea>
            </div>

            <div class="col-md-6">
                <label class="form-label">文物图片</label>
                <input type="file" class="form-control" name="imageFile" accept="image/*">
                <c:if test="${not empty relic.imageUrl}">
                    <img src="${relic.imageUrl}" class="mt-2" style="max-width: 200px;">
                </c:if>
            </div>
        </div>

        <div class="mt-4">
            <button type="submit" class="btn btn-primary">保存</button>
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
