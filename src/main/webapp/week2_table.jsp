<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 4/14/2026
  Time: 6:45 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <title>项目安排表</title>
  <style>
    table {
      width: 60%;
      border-collapse: collapse;
      margin: 20px 0;
    }
    th, td {
      border: 1px solid #000;
      padding: 8px;
      height: 40px;
    }
    th {
      text-align: center;
      background-color: #f0f0f0;
    }
    /* 单元格对齐 */
    .left-center {
      text-align: left;
      vertical-align: middle;
    }
    .right-center {
      text-align: right;
      vertical-align: middle;
    }
    .center {
      text-align: center;
      vertical-align: middle;
    }
  </style>
</head>
<body>
<table>
  <tr>
    <th>项目 1</th>
    <th>项目 2</th>
    <th>项目 3</th>
    <th>项目 4</th>
  </tr>
  <tr>
    <td class="left-center">待办事项 1</td>
    <td></td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td class="left-center">待办事项 2</td>
    <td></td>
    <td></td>
    <td class="left-center">出差</td>
  </tr>
  <tr>
    <td class="left-center">待办事项 3</td>
    <td class="left-center"></td>
    <td class="center">开会</td>
    <td class="right-center"></td>
  </tr>
</table>
</body>
</html>
