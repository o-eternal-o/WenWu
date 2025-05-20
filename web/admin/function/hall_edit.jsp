<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="../header.jsp" %>
<%@ include file="../sidebar.jsp" %>

<!-- 主内容区 -->
<div class="main-content py-4">
    <h3 class="mb-4 text-center">${empty hall.hallId ? '新增展厅' : '编辑展厅'}</h3>

    <div id="feedbackMessage" class="alert ${not empty feedbackMessage ? 'alert-success' : ''}"
         style="display: ${not empty feedbackMessage ? 'block' : 'none'};">
        ${feedbackMessage}
    </div>
    <!-- 表单区域 -->
    <form action="${pageContext.request.contextPath}/HallServlet?action=${empty hall.hallId ? 'add' : 'update'}"
          method="post" onsubmit="return validateForm()" accept-charset="UTF-8">
        <input type="hidden" name="action" value="${empty hall.hallId ? 'add' : 'update'}">
        <c:if test="${not empty hall.hallId}">
            <input type="hidden" name="hallId" value="${hall.hallId}">
        </c:if>

        <div class="row g-3">
            <!-- 展厅名称 -->
            <div class="col-md-6">
                <label class="form-label">展厅名称<span class="text-danger">*</span></label>
                <input type="text" class="form-control" id="hallName" name="hallName"
                       value="${hall.hallName}" required>
            </div>

            <!-- 所属朝代分类 -->
            <div class="col-md-6">
                <label class="form-label">所属朝代分类</label>
                <input type="text" class="form-control" id="dynasty" name="dynasty"
                       value="${hall.dynasty}">
            </div>

            <!-- 文物类型分类 -->
            <div class="col-md-6">
                <label class="form-label">文物类型分类</label>
                <input type="text" class="form-control" id="type" name="type"
                       value="${hall.type}">
            </div>

            <!-- 展厅布局规则描述 -->
            <div class="col-12">
                <label class="form-label">展厅布局规则描述</label>
                <textarea class="form-control" id="layoutRules" name="layoutRules" rows="4">${hall.layoutRules}</textarea>
            </div>

            <!-- 是否开放预约 -->
            <div class="col-md-6">
                <label class="form-label">是否开放预约</label>
                <select class="form-select" id="isOpenBooking" name="isOpenBooking">
                    <option value="1" ${hall.openBooking ? 'selected' : ''}>是</option>
                    <option value="0" ${!hall.openBooking ? 'selected' : ''}>否</option>
                </select>
            </div>

            <!-- 每日预约开始时间 -->
            <div class="col-md-6">
                <label class="form-label">每日预约开始时间</label>
                <input type="time" class="form-control" id="bookingStartTime" name="bookingStartTime"
                       value="${hall.bookingStartTime}">
            </div>

            <!-- 每日预约结束时间 -->
            <div class="col-md-6">
                <label class="form-label">每日预约结束时间</label>
                <input type="time" class="form-control" id="bookingEndTime" name="bookingEndTime"
                       value="${hall.bookingEndTime}">
            </div>

            <!-- 展厅最大承载人数 -->
            <div class="col-md-6">
                <label class="form-label">展厅最大承载人数<span class="text-danger">*</span></label>
                <input type="number" class="form-control" id="maxCapacity" name="maxCapacity"
                       value="${hall.maxCapacity}" required>
            </div>
        </div>

        <div class="mt-4 d-flex justify-content-between">
            <button type="submit" class="btn btn-primary">保存</button>
            <button type="button" class="btn btn-secondary" onclick="goBack()">取消</button>
        </div>
    </form>
</div>

<!-- 引入 footer -->
<%@ include file="../footer.jsp" %>

<script>
    // 返回上一页或跳转到默认页面
    function goBack() {
        if (document.referrer) {
            history.back(); // 返回上一页
        } else {
            window.location = '${pageContext.request.contextPath}/admin/admin.jsp'; // 默认链接
        }
    }

    // 表单验证
    function validateForm() {
        var hallName = document.getElementById("hallName").value.trim();
        var maxCapacity = document.getElementById("maxCapacity").value.trim();

        if (hallName === "") {
            alert("请填写展厅名称！");
            return false;
        }

        if (maxCapacity === "" || parseInt(maxCapacity) <= 0) {
            alert("请填写有效的最大承载人数！");
            return false;
        }

        return true;
    }

</script>