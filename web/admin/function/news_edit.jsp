<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="../header.jsp" %>
<%@ include file="../sidebar.jsp" %>

<div class="main-content py-4">
    <h3 class="mb-4 text-center">${empty news.newsId ? '新增新闻' : '编辑新闻'}</h3>
    <form id="newsForm" method="post">
        <input type="hidden" name="action" value="${empty news.newsId ? 'add' : 'update'}">
        <c:if test="${not empty news.newsId}">
            <input type="hidden" name="newsId" value="${news.newsId}">
        </c:if>
        <div class="row g-3">
            <div class="col-md-6">
                <label class="form-label" for="title">标题<span class="text-danger">*</span></label>
                <input type="text" class="form-control" id="title" name="title"
                       value="${news.title}" required>
            </div>
            <div class="col-md-6">
                <label class="form-label" for="publisherId">发布人ID<span class="text-danger">*</span></label>
                <input type="number" class="form-control" id="publisherId" name="publisherId"
                       value="${news.publisherId}" required>
            </div>
            <div class="col-md-6">
                <label class="form-label" for="publishTime">发布时间</label>
                <input type="text" class="form-control" id="publishTime" name="publishTime"
                       value="${news.publishTime}" placeholder="yyyy-MM-dd HH:mm:ss">
            </div>
            <div class="col-12">
                <label class="form-label" for="content">内容</label>
                <textarea class="form-control" id="content" name="content" rows="4">${news.content}</textarea>
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
        document.getElementById("newsForm").addEventListener("submit", function(event) {
            event.preventDefault();
            const formElements = this.elements;
            const formData = {};
            for (let element of formElements) {
                if (element.name && !element.disabled) {
                    formData[element.name] = element.value;
                }
            }
            const newsId = document.querySelector("input[name='newsId']")?.value;
            const action = newsId ? 'update' : 'add';
            const url = `${pageContext.request.contextPath}/NewsServlet?action=` + action;

            const xhr = new XMLHttpRequest();
            xhr.open("POST", url, true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4) {
                    if (xhr.status === 200) {
                        if (xhr.responseText === "success") {
                            alert("保存成功！");
                            window.location = '${pageContext.request.contextPath}/admin/news_list.jsp';
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