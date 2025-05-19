<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../header.jsp" %>
<%@ include file="../sidebar.jsp" %>

<!-- 主内容区 -->
<div class="main-content">
    <h3 class="mb-4">${empty news ? '发布新闻' : '编辑新闻'}</h3>

    <form action="NewsServlet" method="post">
        <input type="hidden" name="action" value="${empty news.newsId ? 'add' : 'update'}">
        <c:if test="${not empty news.newsId}">
            <input type="hidden" name="newsId" value="${news.newsId}">
        </c:if>

        <div class="row g-3">
            <!-- 新闻标题 -->
            <div class="col-12">
                <label class="form-label">新闻标题</label>
                <input type="text" class="form-control w-100" name="title"
                       value="${news.title}" required>
            </div>

            <!-- 分类 -->
            <div class="col-md-6">
                <label class="form-label">分类</label>
                <select class="form-select w-100" name="category">
                    <option value="exhibition" ${news.category == 'exhibition' ? 'selected' : ''}>展览通知</option>
                    <option value="discovery" ${news.category == 'discovery' ? 'selected' : ''}>文物发现</option>
                    <option value="activity" ${news.category == 'activity' ? 'selected' : ''}>文化活动</option>
                </select>
            </div>

            <!-- 新闻内容 -->
            <div class="col-12">
                <label class="form-label">新闻内容</label>
                <div class="form-check form-switch mb-3">
                    <input class="form-check-input" type="checkbox" name="publishNow"
                           id="publishNow" ${news.status == 'published' ? 'checked' : ''}>
                    <label class="form-check-label" for="publishNow">立即发布</label>
                </div>
                <textarea id="editor" name="content" class="w-100">${news.content}</textarea>
            </div>
        </div>

        <div class="mt-4">
            <button type="submit" class="btn btn-primary">保存</button>
            <button type="button" class="btn btn-secondary" onclick="goBack()">取消</button>
        </div>
    </form>

    <!-- 富文本编辑器 -->
    <link href="${pageContext.request.contextPath}/js/ckeditor/ckeditor.css" rel="stylesheet">
    <script src="${pageContext.request.contextPath}/js/ckeditor/ckeditor.js"></script>
    <script>
        // 初始化 CKEditor，并设置固定高度和文件上传功能
        ClassicEditor
            .create(document.querySelector('#editor'), {
                toolbar: ['heading', '|', 'bold', 'italic', 'link', 'bulletedList', 'numberedList', 'blockQuote', 'uploadImage'],
                image: {
                    toolbar: ['imageTextAlternative', '|', 'imageStyle:alignLeft', 'imageStyle:full', 'imageStyle:alignRight'],
                    styles: [
                        'full',
                        'alignLeft',
                        'alignRight'
                    ],
                    upload: {
                        types: ['jpeg', 'png', 'gif', 'bmp', 'webp', 'tiff']
                    }
                },
                simpleUpload: {
                    // The URL that the images are uploaded to.
                    uploadUrl: '${pageContext.request.contextPath}/uploadImage',

                    // Enable the XMLHttpRequest.withCredentials property.
                    withCredentials: true,

                    // Headers sent along with the XMLHttpRequest to the upload server.
                    headers: {
                        'X-CSRF-TOKEN': 'CSRF-Token',
                        Authorization: 'Bearer <JSON Web Token>'
                    }
                }
            })
            .then(editor => {
                const editableElement = editor.editing.view.getDomRoot(); // 获取编辑器的可编辑区域

                // 设置固定高度
                editableElement.style.height = '500px'; // 固定高度为 500px
                editableElement.style.overflowY = 'auto'; // 启用垂直滚动条
            })
            .catch(error => console.error(error));
    </script>
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