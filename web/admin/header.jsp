<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>文物展厅管理系统</title>
  <!-- Bootstrap 5 -->
  <link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
  <!-- 自定义样式 -->
  <style>
    .admin-container {
      min-height: 100vh;
      background-color: #f8f9fa;
    }
    .sidebar {
      width: 250px;
      background-color: #2c3e50;
      position: fixed;
      height: 100%;
      padding: 20px;
    }
    .sidebar-brand {
      color: #c5a47e;
      font-size: 1.5rem;
      margin-bottom: 30px;
      display: block;
      text-decoration: none;
    }
    .nav-link {
      color: #c5a47e!important;
      padding: 12px 15px;
      border-radius: 5px;
      margin-bottom: 5px;
    }
    .nav-link:hover {
      background-color: rgba(255,255,255,0.1);
    }
    .main-content {
      margin-left: 250px;
      padding: 30px;
    }
    .stat-card {
      background: white;
      border-radius: 10px;
      padding: 20px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
  </style>
</head>
<body>