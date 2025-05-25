<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>实名认证</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f7f7f7; }
        .container { max-width: 400px; margin: 40px auto; background: #fff; padding: 30px 40px; border-radius: 8px; box-shadow: 0 2px 8px #eee; }
        h2 { text-align: center; margin-bottom: 30px; }
        .form-group { margin-bottom: 18px; }
        label { display: block; margin-bottom: 6px; font-weight: bold; }
        input[type="text"], input[type="tel"], input[type="file"] {
            width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px;
        }
        .btn { width: 100%; padding: 10px; background: #007bff; color: #fff; border: none; border-radius: 4px; font-size: 16px; cursor: pointer; }
        .btn:disabled { background: #aaa; }
        .msg { margin-top: 18px; text-align: center; }
        .msg.success { color: #28a745; }
        .msg.error { color: #dc3545; }
    </style>
</head>
<body>
<div class="container">
    <h2>实名认证</h2>
    <form id="verifyForm" method="post" action="${pageContext.request.contextPath}/identityVerification" enctype="multipart/form-data">
        <div class="form-group">
            <label for="realName">真实姓名</label>
            <input type="text" id="realName" name="realName" required>
        </div>
        <div class="form-group">
            <label for="phone">手机号</label>
            <input type="tel" id="phone" name="phone" required pattern="1[3-9]\d{9}">
        </div>
        <div class="form-group">
            <label for="idNumber">身份证号</label>
            <input type="text" id="idNumber" name="idNumber" required pattern="(^\d{15}$)|(^\d{17}([0-9Xx])$)">
        </div>
        <div class="form-group">
            <label for="idImage">身份证照片</label>
            <input type="file" id="idImage" name="idImage" accept="image/*" required>
        </div>
        <button type="submit" class="btn">提交认证</button>
        <div id="msg" class="msg"></div>
    </form>
</div>
<script>
    document.getElementById('verifyForm').onsubmit = function(e) {
        e.preventDefault();
        const form = e.target;
        const formData = new FormData(form);
        const msg = document.getElementById('msg');
        msg.textContent = '';
        msg.className = 'msg';

        fetch(form.action, {
            method: 'POST',
            body: formData
        }).then(res => res.json())
          .then(data => {
              if (data.status === 'success') {
                  msg.textContent = data.message;
                  msg.className = 'msg success';
                  form.reset();
              } else {
                  msg.textContent = data.message;
                  msg.className = 'msg error';
              }
          }).catch(() => {
              msg.textContent = '提交失败，请稍后重试';
              msg.className = 'msg error';
          });
    };
</script>
</body>
</html>