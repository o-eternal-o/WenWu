<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="../header.jsp" %>
<%@ include file="../sidebar.jsp" %>

<div class="main-content py-4">
    <h3 class="mb-4 text-center">${empty booking.bookingId ? '新增预约' : '编辑预约'}</h3>
    <form id="bookingForm" method="post">
        <input type="hidden" name="action" value="${empty booking.bookingId ? 'add' : 'update'}">
        <c:if test="${not empty booking.bookingId}">
            <input type="hidden" name="bookingId" value="${booking.bookingId}">
        </c:if>
        <div class="row g-3">
            <div class="col-md-6">
                <label class="form-label" for="userId">用户ID<span class="text-danger">*</span></label>
                <input type="number" class="form-control" id="userId" name="userId"
                       value="${booking.userId}" required>
            </div>
            <div class="col-md-6">
                <label class="form-label" for="hallId">展厅ID<span class="text-danger">*</span></label>
                <input type="number" class="form-control" id="hallId" name="hallId"
                       value="${booking.hallId}" required>
            </div>
            <div class="col-md-6">
                <label class="form-label" for="bookingTime">预约时间<span class="text-danger">*</span></label>
                <input type="datetime-local" class="form-control" id="bookingTime" name="bookingTime"
                       value="${booking.bookingTime}" required>
            </div>
            <div class="col-md-6">
                <label class="form-label" for="status">状态</label>
                <select class="form-select" id="status" name="status">
                    <option value="pending" ${booking.status == 'pending' ? 'selected' : ''}>待处理</option>
                    <option value="confirmed" ${booking.status == 'confirmed' ? 'selected' : ''}>已确认</option>
                    <option value="canceled" ${booking.status == 'canceled' ? 'selected' : ''}>已取消</option>
                </select>
            </div>
            <div class="col-md-6">
                <label class="form-label" for="isGroup">是否团体</label>
                <select class="form-select" id="isGroup" name="isGroup">
                    <option value="1" ${booking.group ? 'selected' : ''}>是</option>
                    <option value="0" ${!booking.group ? 'selected' : ''}>否</option>
                </select>
            </div>
            <div class="col-md-6">
                <label class="form-label" for="groupSize">团体人数</label>
                <input type="number" class="form-control" id="groupSize" name="groupSize"
                       value="${booking.groupSize}">
            </div>
            <div class="col-md-6">
                <label class="form-label" for="createdAt">创建时间</label>
                <input type="text" class="form-control" id="createdAt" name="createdAt"
                       value="${booking.createdAt}" placeholder="yyyy-MM-dd HH:mm:ss">
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
            window.location = '${pageContext.request.contextPath}/admin/booking_list.jsp';
        }
    }

    document.addEventListener("DOMContentLoaded", function() {
        document.getElementById("bookingForm").addEventListener("submit", function(event) {
            event.preventDefault();
            const formElements = this.elements;
            const formData = {};
            for (let element of formElements) {
                if (element.name && !element.disabled) {
                    formData[element.name] = element.value;
                }
            }
            const bookingId = document.querySelector("input[name='bookingId']")?.value;
            const action = bookingId ? 'update' : 'add';
            const url = `${pageContext.request.contextPath}/BookingServlet?action=` + action;

            const xhr = new XMLHttpRequest();
            xhr.open("POST", url, true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4) {
                    if (xhr.status === 200) {
                        if (xhr.responseText === "success") {
                            alert("保存成功！");
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