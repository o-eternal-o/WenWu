<%--
  Created by IntelliJ IDEA.
  User: 19700
  Date: 2025/5/15
  Time: 16:34
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login</title>
</head>
<body>
<center>
    <h1>Login</h1>
    <font color=black>登录</font>
    <br>
    <hr>
    <form action="LoginCLServlet" method="POST">
        <font color=black>用户名：</font>
        <input type="text" name="username">
        <br>
        <font color=black>密码:</font>
        <input type="password" name="password">
        <br>
        <input type="submit" value="登录">
        <input type="submit" value="注册">
        <input type="reset" value="重置">
        <br>
        <br />
    </form>
</center>
</body>
</html>
