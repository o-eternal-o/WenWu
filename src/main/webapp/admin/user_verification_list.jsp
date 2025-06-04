<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>
<%@ include file="header.jsp" %>
<%@ include file="sidebar.jsp" %>
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

<script>
    $(document).ready(function () {
        $('#verificationTable').DataTable({
            "paging": true,
            "ordering": true,
            "info": true,
            "language": {
                "url": "https://cdn.datatables.net/plug-ins/1.13.6/i18n/zh-Hans.json"
            }
        });
    });
</script>

<div class="main-content py-4">
    <h3 class="mb-4 text-center">实名认证管理</h3>
    <div class="card mb-4">
        <div class="card-body py-2 d-flex justify-content-between align-items-center">
            <form id="searchForm" action="${pageContext.request.contextPath}/UserVerificationServlet" method="post" class="d-flex gap-2" style="flex: 1; max-width: 60%;">
                <input type="hidden" name="action" value="search">
                <select id="searchType" name="searchType" class="form-select form-select-sm" style="width: auto;">
                    <option value="real_name">真实姓名</option>
                    <option value="id_number">证件号码</option>
                    <option value="status">状态</option>
                </select>
                <input id="searchInput" name="searchInput" type="text" class="form-control form-control-sm" placeholder="请输入查询内容" style="flex: 1;">
                <button id="searchButton" type="submit" class="btn btn-sm btn-primary">搜索</button>
            </form>
            <a href="${pageContext.request.contextPath}/admin/function/user_verification_edit.jsp" class="btn btn-sm btn-success d-flex align-items-center" style="white-space: nowrap;">新增认证</a>
        </div>
    </div>
    <div class="card mb-5">
        <div class="card-body">
            <table id="verificationTable" class="table table-hover">
                <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>用户ID</th>
                    <th>真实姓名</th>
                    <th>联系电话</th>
                    <th>证件号码</th>
                    <th>状态</th>
                    <th>提交时间</th>
                    <th>审核时间</th>
                    <th>审核人</th>
                    <th>拒绝原因</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="v" items="${requestScope.verificationList}">
                    <tr>
                        <td>${v.verificationId}</td>
                        <td>${v.userId}</td>
                        <td>${v.realName}</td>
                        <td>${v.phone}</td>
                        <td>${v.idNumber}</td>
                        <td>${v.status}</td>
                        <td>${v.submittedAt}</td>
                        <td>${v.reviewedAt}</td>
                        <td>${v.reviewedBy}</td>
                        <td>${v.rejectReason}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/UserVerificationServlet?action=edit&verificationId=${v.verificationId}" class="btn btn-sm btn-primary me-2">编辑</a>
                            <button class="btn btn-sm btn-danger" onclick="confirmDelete('${v.verificationId}')">删除</button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>


<%@ include file="footer.jsp" %>
<script>
    function confirmDelete(verificationId) {
        if (confirm("确定要删除该认证记录吗？")) {
            fetch('UserVerificationServlet?action=delete&verificationId=' + verificationId, {
                method: 'POST'
            })
                .then(response => response.text())
                .then(data => {
                    if (data === "success") {
                        alert("删除成功！");
                        location.reload();
                    } else {
                        alert("删除失败，请稍后再试！");
                    }
                })
                .catch(error => {
                    alert("删除请求出错，请检查网络连接！");
                });
        }
    }
</script>
<script>
    window.onload = function() {
        if (window.name === "refresh") {
            window.name = "";
            location.reload();
        }
    };
</script>