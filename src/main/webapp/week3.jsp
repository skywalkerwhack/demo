<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>

<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>第 03 周作业 - AJAX 与 JSON</title>
    <style>
        :root {
            color-scheme: light;
            --bg: #f4f7fb;
            --panel: #ffffff;
            --line: #d5dceb;
            --text: #1f2937;
            --accent: #1d4ed8;
            --accent-soft: #dbeafe;
            --ok: #166534;
            --error: #b91c1c;
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            padding: 32px 16px 48px;
            font-family: "Microsoft YaHei", sans-serif;
            background: linear-gradient(180deg, #eef4ff 0%, var(--bg) 100%);
            color: var(--text);
        }

        .page {
            max-width: 1080px;
            margin: 0 auto;
        }

        .panel {
            background: var(--panel);
            border: 1px solid var(--line);
            border-radius: 16px;
            padding: 24px;
            box-shadow: 0 12px 32px rgba(15, 23, 42, 0.08);
        }

        h1, h2 {
            margin-top: 0;
        }

        .intro {
            margin-bottom: 20px;
        }

        .controls {
            display: grid;
            grid-template-columns: 1fr;
            gap: 16px;
            margin-bottom: 20px;
        }

        .field label {
            display: block;
            font-weight: 700;
            margin-bottom: 8px;
        }

        textarea {
            width: 100%;
            min-height: 180px;
            resize: vertical;
            padding: 14px;
            border: 1px solid var(--line);
            border-radius: 12px;
            font: 14px/1.6 Consolas, Monaco, monospace;
            background: #fbfdff;
        }

        .button-row {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
        }

        button {
            border: 0;
            border-radius: 999px;
            padding: 12px 20px;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            background: var(--accent);
            color: #fff;
        }

        button.secondary {
            background: #0f766e;
        }

        button.ghost {
            background: #475569;
        }

        .status {
            margin: 16px 0 0;
            padding: 12px 14px;
            border-radius: 12px;
            font-weight: 700;
            background: var(--accent-soft);
            color: var(--accent);
        }

        .status.ok {
            background: #dcfce7;
            color: var(--ok);
        }

        .status.error {
            background: #fee2e2;
            color: var(--error);
        }

        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        pre, .result-box {
            margin: 0;
            border: 1px solid var(--line);
            border-radius: 12px;
            background: #fbfdff;
            padding: 14px;
            min-height: 220px;
            overflow: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            border: 1px solid var(--line);
            padding: 10px 12px;
            text-align: left;
        }

        th {
            background: #e8eefc;
        }
    </style>
</head>
<body>
<div class="page">
    <div class="panel">
        <h1>第 03 周作业：XMLHttpRequest、jQuery、JSON</h1>
        <p class="intro">
            页面包含输入框、提交按钮、状态判断、完整 JSON 字符串显示，以及对后端返回
            <code>aaData</code> 的逐行解析结果。
        </p>

        <div class="controls">
            <div class="field">
                <label for="payloadInput">发送到后端的 JSON 数据</label>
                <textarea id="payloadInput">{
  "studentId": "20260001",
  "studentName": "张三",
  "week": 3,
  "course": "Web应用开发",
  "homework": {
    "title": "AJAX 与 JSON",
    "client": ["XMLHttpRequest", "jQuery"],
    "finished": true
  }
}</textarea>
            </div>
            <div class="button-row">
                <button type="button" onclick="sendByNative()">原生 XMLHttpRequest 提交</button>
                <button type="button" class="secondary" onclick="sendByJQuery()">jQuery 提交</button>
                <button type="button" class="ghost" onclick="loadByGet()">GET 获取固定 JSON</button>
            </div>
        </div>

        <div id="statusBox" class="status">等待发送请求</div>

        <div class="grid">
            <section>
                <h2>完整 JSON 字符串</h2>
                <pre id="rawResult">暂无结果</pre>
            </section>
            <section>
                <h2>后端确认收到的数据</h2>
                <pre id="echoResult">暂无结果</pre>
            </section>
        </div>

        <div class="grid">
            <section>
                <h2>aaData 解析结果</h2>
                <div id="tableContainer" class="result-box">暂无数据</div>
            </section>
            <section>
                <h2>关键字段</h2>
                <div id="summaryBox" class="result-box">暂无数据</div>
            </section>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
    const apiUrl = "api/week3/data";

    function setStatus(message, type) {
        const statusBox = document.getElementById("statusBox");
        statusBox.textContent = message;
        statusBox.className = "status" + (type ? " " + type : "");
    }

    function getPayloadText() {
        return document.getElementById("payloadInput").value.trim();
    }

    function parseInputPayload() {
        const payloadText = getPayloadText();
        if (!payloadText) {
            throw new Error("请输入要提交的 JSON 数据。");
        }
        return JSON.parse(payloadText);
    }

    function renderResult(data) {
        document.getElementById("rawResult").textContent = JSON.stringify(data, null, 2);
        document.getElementById("echoResult").textContent = data.receivedPayload || "本次没有向后端发送请求体。";

        const summary = [
            "code: " + data.code,
            "message: " + data.message,
            "method: " + data.method,
            "total: " + data.total
        ];
        document.getElementById("summaryBox").innerHTML = summary.map(function(item) {
            return "<div>" + escapeHtml(item) + "</div>";
        }).join("");

        renderTable(data.aaData || []);
    }

    function renderTable(rows) {
        const container = document.getElementById("tableContainer");
        if (!rows.length) {
            container.textContent = "aaData 为空";
            return;
        }

        const headers = ["编号", "作业名称", "学生", "状态", "分数"];
        let html = "<table><thead><tr>";
        headers.forEach(function(header) {
            html += "<th>" + escapeHtml(header) + "</th>";
        });
        html += "</tr></thead><tbody>";

        rows.forEach(function(row) {
            html += "<tr>";
            row.forEach(function(cell) {
                html += "<td>" + escapeHtml(String(cell)) + "</td>";
            });
            html += "</tr>";
        });

        html += "</tbody></table>";
        container.innerHTML = html;
    }

    function handleSuccess(xhr, data, source) {
        if (xhr.status >= 200 && xhr.status < 300) {
            setStatus(source + " 请求成功，HTTP 状态码：" + xhr.status, "ok");
            renderResult(data);
            return;
        }
        setStatus(source + " 请求失败，HTTP 状态码：" + xhr.status, "error");
    }

    function handleError(source, message) {
        setStatus(source + " 请求失败：" + message, "error");
    }

    function loadByGet() {
        const xhr = new XMLHttpRequest();
        xhr.open("GET", apiUrl, true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState !== 4) {
                return;
            }
            if (xhr.status >= 200 && xhr.status < 300) {
                handleSuccess(xhr, JSON.parse(xhr.responseText), "GET");
            } else {
                handleError("GET", "状态码不正确，status=" + xhr.status);
            }
        };
        xhr.onerror = function() {
            handleError("GET", "网络异常");
        };
        xhr.send();
    }

    function sendByNative() {
        let payloadObject;
        try {
            payloadObject = parseInputPayload();
        } catch (error) {
            handleError("原生 XMLHttpRequest", error.message);
            return;
        }

        const xhr = new XMLHttpRequest();
        xhr.open("POST", apiUrl, true);
        xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
        xhr.onreadystatechange = function() {
            if (xhr.readyState !== 4) {
                return;
            }
            if (xhr.status >= 200 && xhr.status < 300) {
                handleSuccess(xhr, JSON.parse(xhr.responseText), "原生 XMLHttpRequest");
            } else {
                handleError("原生 XMLHttpRequest", "状态码不正确，status=" + xhr.status);
            }
        };
        xhr.onerror = function() {
            handleError("原生 XMLHttpRequest", "网络异常");
        };
        xhr.send(JSON.stringify(payloadObject));
    }

    function sendByJQuery() {
        if (typeof window.jQuery === "undefined") {
            handleError("jQuery", "jQuery 未加载，请确认能访问 CDN，或改成本地引入 jquery.js");
            return;
        }

        let payloadObject;
        try {
            payloadObject = parseInputPayload();
        } catch (error) {
            handleError("jQuery", error.message);
            return;
        }

        $.ajax({
            url: apiUrl,
            type: "POST",
            contentType: "application/json;charset=UTF-8",
            dataType: "json",
            data: JSON.stringify(payloadObject),
            success: function(data, textStatus, jqXHR) {
                handleSuccess(jqXHR, data, "jQuery");
            },
            error: function(jqXHR, textStatus, errorThrown) {
                handleError("jQuery", errorThrown || textStatus || ("status=" + jqXHR.status));
            }
        });
    }

    function escapeHtml(value) {
        return value
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#39;");
    }
</script>
</body>
</html>