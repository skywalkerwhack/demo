<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 4/14/2026
  Time: 6:47 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>frame.jsp 示例布局</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
        }
        /* 顶部区域 */
        #top {
            background-color: red;
            color: white;
            text-align: center;
            padding: 10px;
            cursor: pointer;
        }
        /* 底部区域 */
        #bottom {
            background-color: red;
            color: white;
            text-align: center;
            padding: 10px;
            cursor: pointer;
        }
        /* 左右容器 */
        #container {
            display: flex;
            height: calc(100vh - 100px); /* 减去上下高度 */
        }
        /* 左侧区域 */
        #left {
            background-color: yellow;
            width: 200px;
            text-align: center;
            line-height: calc(100vh - 100px);
            cursor: pointer;
            transition: width 0.3s;
        }
        /* 右侧区域 */
        #right {
            background-color: green;
            flex: 1;
            text-align: center;
            line-height: calc(100vh - 100px);
            color: white;
            cursor: pointer;
        }
        /* 左侧隐藏状态 */
        #left.hidden {
            width: 0;
            overflow: hidden;
        }
    </style>
</head>
<body>
<!-- 顶部红色区域 -->
<div id="top">网页的头部</div>

<!-- 左右容器 -->
<div id="container">
    <!-- 左侧黄色区域 -->
    <div id="left">网页的左部</div>
    <!-- 右侧绿色区域 -->
    <div id="right">网页的右部</div>
</div>

<!-- 底部红色区域 -->
<div id="bottom">网页的底部</div>

<script>
    const left = document.getElementById("left");
    const right = document.getElementById("right");
    const top = document.getElementById("top");
    const bottom = document.getElementById("bottom");

    // 点击右侧绿色区域弹出布局名称
    right.addEventListener("click", function() {
        alert("网页的右部");
    });

    // 点击左侧黄色区域隐藏左侧
    left.addEventListener("click", function() {
        left.classList.toggle("hidden");
    });

    // 点击顶部或底部红色区域显示左侧区域
    top.addEventListener("click", function() {
        left.classList.remove("hidden");
    });
    bottom.addEventListener("click", function() {
        left.classList.remove("hidden");
    });
</script>
</body>
</html>