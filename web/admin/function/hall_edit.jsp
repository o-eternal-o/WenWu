<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="../header.jsp" %>
<%@ include file="../sidebar.jsp" %>

<!-- 主内容区 -->
<div class="main-content py-4">
    <h3 class="mb-4 text-center">${empty hall.hallId ? '新增展厅' : '编辑展厅'}</h3>

    <!-- 表单区域 -->
    <form id="hallForm" method="post">
        <!-- 隐藏字段 -->
        <input type="hidden" name="action" value="${empty hall.hallId ? 'add' : 'update'}">
        <c:if test="${not empty hall.hallId}">
            <input type="hidden" name="hallId" value="${hall.hallId}">
        </c:if>

        <div class="row g-3">
            <!-- 展厅名称 -->
            <div class="col-md-6">
                <label class="form-label" for="hallName">展厅名称<span class="text-danger">*</span></label>
                <input type="text" class="form-control" id="hallName" name="hallName"
                       value="${hall.hallName}" required>
            </div>

            <!-- 所属朝代分类 -->
            <div class="col-md-6">
                <label class="form-label" for="dynasty">所属朝代分类</label>
                <input type="text" class="form-control" id="dynasty" name="dynasty"
                       value="${hall.dynasty}">
            </div>

            <!-- 文物类型分类 -->
            <div class="col-md-6">
                <label class="form-label" for="type">文物类型分类</label>
                <input type="text" class="form-control" id="type" name="type"
                       value="${hall.type}">
            </div>

            <!-- 展厅布局规则描述 -->
            <div class="col-12">
                <label class="form-label" for="layoutRules">展厅布局规则描述</label>
                <textarea class="form-control" id="layoutRules" name="layoutRules" rows="4">${hall.layoutRules}</textarea>
            </div>

            <!-- 是否开放预约 -->
            <div class="col-md-6">
                <label class="form-label" for="isOpenBooking">是否开放预约</label>
                <select class="form-select" id="isOpenBooking" name="isOpenBooking">
                    <option value="1" ${hall.openBooking ? 'selected' : ''}>是</option>
                    <option value="0" ${!hall.openBooking ? 'selected' : ''}>否</option>
                </select>
            </div>

            <!-- 每日预约开始时间 -->
            <div class="col-md-6">
                <label class="form-label" for="bookingStartTime">每日预约开始时间</label>
                <input type="time" class="form-control" id="bookingStartTime" name="bookingStartTime"
                       value="${hall.bookingStartTime}">
            </div>

            <!-- 每日预约结束时间 -->
            <div class="col-md-6">
                <label class="form-label" for="bookingEndTime">每日预约结束时间</label>
                <input type="time" class="form-control" id="bookingEndTime" name="bookingEndTime"
                       value="${hall.bookingEndTime}">
            </div>

            <!-- 展厅最大承载人数 -->
            <div class="col-md-6">
                <label class="form-label" for="maxCapacity">展厅最大承载人数<span class="text-danger">*</span></label>
                <input type="number" class="form-control" id="maxCapacity" name="maxCapacity"
                       value="${hall.maxCapacity}" required>
            </div>
        </div>

        <div class="mt-4 d-flex justify-content-between">
            <button type="submit" class="btn btn-primary">保存</button>
            <button type="button" class="btn btn-secondary" onclick="goBack()">返回</button>
        </div>
    </form>

</div>

<!-- 引入 footer -->
<%@ include file="../footer.jsp" %>

<script>
    // 返回上一页或跳转到默认页面
    function goBack() {
        window.location = '${pageContext.request.contextPath}/HallServlet?action=list'; // 默认链接
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

    document.addEventListener("DOMContentLoaded", function() {
        document.getElementById("hallForm").addEventListener("submit", function(event) {
            event.preventDefault(); // 阻止默认表单提交

            // 手动收集表单数据
            const formElements = this.elements; // 获取表单中的所有元素
            const formData = {}; // 用于存储表单数据的对象

            for (let element of formElements) {
                if (element.name && !element.disabled) { // 确保元素有 name 属性且未被禁用
                    if (element.type === "checkbox" || element.type === "radio") {
                        if (element.checked) {
                            formData[element.name] = element.value;
                        }
                    } else if (element.type === "select-multiple") {
                        formData[element.name] = Array.from(element.selectedOptions).map(option => option.value);
                    } else {
                        formData[element.name] = element.value;
                    }
                }
            }

            // 动态设置请求 URL
            const hallId = document.querySelector("input[name='hallId']")?.value;
            const action = hallId ? 'update' : 'add';
            const url = `${pageContext.request.contextPath}/HallServlet?action=` + action;

            // 使用 XMLHttpRequest 发送 Ajax 请求
            const xhr = new XMLHttpRequest();
            xhr.open("POST", url, true); // 设置请求方法、URL 和异步标志

            // 设置请求头
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

            // 处理响应
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4) { // 请求完成
                    if (xhr.status === 200) { // 响应成功
                        console.log("响应数据:", xhr.responseText);
                        if (xhr.responseText === "success") {
                            alert("保存成功！");
                        } else {
                            alert("保存失败，请稍后再试！");
                        }
                    } else {
                        console.error("请求出错:", xhr.statusText);
                        alert("请求出错，请检查网络连接！");
                    }
                }
            };

            // 构建请求体数据
            const requestBody = Object.keys(formData)
                .map(key => encodeURIComponent(key) + "=" + encodeURIComponent(formData[key]))
                .join("&");

            // 发送请求
            xhr.send(requestBody);
        });
    });
</script>