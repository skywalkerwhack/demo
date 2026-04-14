<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>第 04 周作业 - 文件上传下载</title>
    <style>
        :root {
            color-scheme: light;
            --bg: #f3efe5;
            --paper: rgba(255, 251, 245, 0.95);
            --line: #d8cbb7;
            --text: #2d241d;
            --muted: #6f6256;
            --accent: #a16207;
            --accent-deep: #854d0e;
            --ok: #166534;
            --error: #b91c1c;
            --shadow: 0 18px 40px rgba(67, 48, 30, 0.10);
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            padding: 24px 14px 48px;
            font-family: "Microsoft YaHei", sans-serif;
            color: var(--text);
            background:
                radial-gradient(circle at top left, rgba(255, 234, 196, 0.8), transparent 32%),
                linear-gradient(180deg, #f8f5ee 0%, var(--bg) 100%);
        }

        .page {
            max-width: 1180px;
            margin: 0 auto;
        }

        .hero, .panel {
            background: var(--paper);
            border: 1px solid var(--line);
            border-radius: 20px;
            box-shadow: var(--shadow);
        }

        .hero {
            padding: 28px;
            margin-bottom: 18px;
        }

        .hero h1, .panel h2 {
            margin-top: 0;
        }

        .hero p, .panel p, .panel li {
            color: var(--muted);
            line-height: 1.7;
        }

        .hero-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 16px;
        }

        .tag {
            padding: 8px 12px;
            border-radius: 999px;
            background: #f7ead1;
            color: var(--accent-deep);
            font-size: 13px;
            font-weight: 700;
        }

        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(340px, 1fr));
            gap: 18px;
        }

        .panel {
            padding: 22px;
        }

        .field-grid {
            display: grid;
            gap: 14px;
        }

        .field-grid.two {
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 700;
        }

        input[type="text"], input[type="file"] {
            width: 100%;
            padding: 11px 12px;
            border: 1px solid var(--line);
            border-radius: 12px;
            background: #fffdf9;
            color: var(--text);
        }

        button {
            border: 0;
            border-radius: 999px;
            padding: 12px 18px;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            background: var(--accent);
            color: #fff;
        }

        button.secondary {
            background: #0f766e;
        }

        .actions {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            margin-top: 16px;
        }

        .progress-shell {
            height: 14px;
            border-radius: 999px;
            overflow: hidden;
            background: #efe4d3;
            margin-top: 14px;
        }

        .progress-bar {
            height: 100%;
            width: 0;
            background: linear-gradient(90deg, #d97706, #f59e0b);
            transition: width 120ms linear;
        }

        .status {
            margin-top: 14px;
            padding: 12px 14px;
            border-radius: 12px;
            background: #f7ead1;
            color: var(--accent-deep);
            font-weight: 700;
        }

        .status.ok {
            background: #dcfce7;
            color: var(--ok);
        }

        .status.error {
            background: #fee2e2;
            color: var(--error);
        }

        pre, .result-box {
            margin: 14px 0 0;
            min-height: 180px;
            padding: 14px;
            border-radius: 14px;
            border: 1px solid var(--line);
            background: #fffdf9;
            overflow: auto;
            white-space: pre-wrap;
            word-break: break-word;
            font: 13px/1.6 Consolas, Monaco, monospace;
        }

        .tip {
            margin-top: 12px;
            padding: 12px 14px;
            border-left: 4px solid var(--accent);
            background: #fff7e8;
            border-radius: 12px;
        }

        .snippet {
            margin-top: 12px;
            font: 13px/1.7 Consolas, Monaco, monospace;
        }

        .download-list a {
            display: inline-block;
            margin: 6px 10px 0 0;
            color: var(--accent-deep);
            font-weight: 700;
            text-decoration: none;
        }

        @media (max-width: 720px) {
            .hero, .panel {
                border-radius: 16px;
            }
        }
    </style>
</head>
<body>
<main class="page">
    <section class="hero">
        <h1>第 04 周作业：文件上传与下载</h1>
        <p>
            这个页面把文档里的要求落成一个可运行示例：观察 multipart 分段、原生 XMLHttpRequest 单文件上传并显示百分比、
            jQuery 异步多文件上传，以及通过后端流式下载文件。
        </p>
        <div class="hero-tags">
            <span class="tag">Multipart</span>
            <span class="tag">XMLHttpRequest</span>
            <span class="tag">jQuery</span>
            <span class="tag">Download Stream</span>
        </div>
    </section>

    <section class="grid">
        <div class="panel">
            <h2>1. Multipart 分段观察</h2>
            <p>字段和文件按交错顺序加入 <code>FormData</code>，后端返回每个 part 的顺序、名称、类型和大小，方便你对照 TCP 抓包结果。</p>
            <div class="field-grid">
                <div>
                    <label for="inspectUser">用户名字</label>
                    <input id="inspectUser" type="text" value="张三">
                </div>
                <div>
                    <label for="inspectFile01">第一个文件</label>
                    <input id="inspectFile01" type="file">
                </div>
                <div>
                    <label for="inspectRole">用户角色</label>
                    <input id="inspectRole" type="text" value="组长">
                </div>
                <div>
                    <label for="inspectFile02">第二个文件</label>
                    <input id="inspectFile02" type="file">
                </div>
            </div>
            <div class="actions">
                <button type="button" onclick="inspectMultipart()">提交并查看 part 顺序</button>
            </div>
            <div class="tip">如果你把 Tomcat 暂停，用 TCP 工具监听端口，再点这个按钮，就能看到和这里对应的 multipart 边界与字段顺序。</div>
            <pre id="inspectResult">等待发送 multipart 请求</pre>
        </div>

        <div class="panel">
            <h2>2. 原生 XMLHttpRequest 上传</h2>
            <p>这里不用 jQuery，只用最原始的 <code>XMLHttpRequest</code> 上传单文件，并显示上传百分比。</p>
            <div class="field-grid">
                <div>
                    <label for="nativeStudentName">学生姓名</label>
                    <input id="nativeStudentName" type="text" value="李四">
                </div>
                <div>
                    <label for="nativeFile">选择文件</label>
                    <input id="nativeFile" type="file">
                </div>
            </div>
            <div class="actions">
                <button type="button" onclick="uploadNative()">原生上传</button>
            </div>
            <div class="progress-shell">
                <div id="nativeProgressBar" class="progress-bar"></div>
            </div>
            <div id="nativeStatus" class="status">等待上传</div>
            <pre id="nativeResult">暂无结果</pre>
        </div>

        <div class="panel">
            <h2>3. jQuery 异步多文件上传</h2>
            <p>上传三个文件和用户信息，页面不跳转，后端保存文件后返回名字、编号、角色与下载地址，结果刷新在下面这个区域。</p>
            <div class="field-grid two">
                <div>
                    <label for="userName">用户名字</label>
                    <input id="userName" type="text" value="王五">
                </div>
                <div>
                    <label for="userId">用户编号</label>
                    <input id="userId" type="text" value="20260004">
                </div>
                <div>
                    <label for="userRole">用户角色</label>
                    <input id="userRole" type="text" value="资料员">
                </div>
            </div>
            <div class="field-grid" style="margin-top: 14px;">
                <div>
                    <label for="file01">第一个文件</label>
                    <input id="file01" type="file">
                </div>
                <div>
                    <label for="file02">第二个文件</label>
                    <input id="file02" type="file">
                </div>
                <div>
                    <label for="file03">第三个文件</label>
                    <input id="file03" type="file">
                </div>
            </div>
            <div class="actions">
                <button type="button" class="secondary" onclick="uploadByJQuery()">jQuery 多文件上传</button>
            </div>
            <div id="jqueryStatus" class="status">等待上传</div>
            <div id="jqueryResult" class="result-box">暂无结果</div>
        </div>

        <div class="panel">
            <h2>4. 流式下载与 5. 虚拟路径配置笔记</h2>
            <p>下载按钮来自后端返回的地址，点击后由 Servlet 以流的方式输出文件。下面同时给出两种 Tomcat 虚拟路径配置示例，方便整理作业讲解。</p>
            <div id="downloadArea" class="result-box download-list">先上传文件，成功后这里会出现下载链接。</div>
            <div class="snippet">conf/server.xml 中 Context 示例
&lt;Context path="/upload" docBase="C:\upload" reloadable="false" /&gt;</div>
            <div class="snippet">conf/Catalina/localhost/upload.xml 示例
&lt;Context docBase="C:\upload" path="/upload" /&gt;</div>
            <div class="tip">本项目默认把上传文件保存到 <code>java.io.tmpdir/demo-week4-uploads</code>。如果要改目录，可在容器里配置 <code>week4UploadDir</code> 上下文参数。</div>
        </div>
    </section>
</main>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
    function prettyPrint(targetId, data) {
        document.getElementById(targetId).textContent = JSON.stringify(data, null, 2);
    }

    function setStatus(targetId, message, type) {
        const box = document.getElementById(targetId);
        box.textContent = message;
        box.className = "status" + (type ? " " + type : "");
    }

    function inspectMultipart() {
        const formData = new FormData();
        formData.append("userName", document.getElementById("inspectUser").value);
        if (document.getElementById("inspectFile01").files[0]) {
            formData.append("fileA", document.getElementById("inspectFile01").files[0]);
        }
        formData.append("userRole", document.getElementById("inspectRole").value);
        if (document.getElementById("inspectFile02").files[0]) {
            formData.append("fileB", document.getElementById("inspectFile02").files[0]);
        }

        fetch("api/week4/inspect", {
            method: "POST",
            body: formData
        })
            .then(function (response) {
                return response.json();
            })
            .then(function (data) {
                prettyPrint("inspectResult", data);
            })
            .catch(function (error) {
                document.getElementById("inspectResult").textContent = "请求失败: " + error;
            });
    }

    function uploadNative() {
        const file = document.getElementById("nativeFile").files[0];
        if (!file) {
            setStatus("nativeStatus", "请先选择文件", "error");
            return;
        }

        const xhr = new XMLHttpRequest();
        const formData = new FormData();
        formData.append("studentName", document.getElementById("nativeStudentName").value);
        formData.append("nativeFile", file);

        xhr.open("POST", "api/week4/native-upload", true);
        xhr.responseType = "json";

        xhr.upload.onprogress = function (event) {
            if (event.lengthComputable) {
                const percent = Math.round(event.loaded / event.total * 100);
                document.getElementById("nativeProgressBar").style.width = percent + "%";
                setStatus("nativeStatus", "上传中 " + percent + "%");
            }
        };

        xhr.onload = function () {
            const payload = xhr.response || {};
            if (xhr.status >= 200 && xhr.status < 300) {
                setStatus("nativeStatus", "上传完成", "ok");
                prettyPrint("nativeResult", payload);
                renderDownloadLinks(payload.file ? [payload.file] : []);
            } else {
                setStatus("nativeStatus", payload.message || "上传失败", "error");
                prettyPrint("nativeResult", payload);
            }
        };

        xhr.onerror = function () {
            setStatus("nativeStatus", "网络错误", "error");
        };

        document.getElementById("nativeProgressBar").style.width = "0%";
        setStatus("nativeStatus", "准备上传");
        xhr.send(formData);
    }

    function uploadByJQuery() {
        if (typeof window.jQuery === "undefined") {
            setStatus("jqueryStatus", "jQuery CDN 未加载成功，当前环境无法执行这个示例", "error");
            return;
        }

        const formData = new FormData();
        formData.append("userName", document.getElementById("userName").value);
        formData.append("userId", document.getElementById("userId").value);
        formData.append("userRole", document.getElementById("userRole").value);

        const fileIds = ["file01", "file02", "file03"];
        fileIds.forEach(function (id) {
            const file = document.getElementById(id).files[0];
            if (file) {
                formData.append(id, file);
            }
        });

        setStatus("jqueryStatus", "正在异步上传");

        $.ajax({
            url: "api/week4/jquery-upload",
            method: "POST",
            data: formData,
            processData: false,
            contentType: false,
            success: function (data) {
                setStatus("jqueryStatus", "上传完成", "ok");
                document.getElementById("jqueryResult").textContent = JSON.stringify(data, null, 2);
                renderDownloadLinks(data.files || []);
            },
            error: function (xhr) {
                let payload = {};
                try {
                    payload = JSON.parse(xhr.responseText);
                } catch (error) {
                    payload = {message: "上传失败"};
                }
                setStatus("jqueryStatus", payload.message || "上传失败", "error");
                document.getElementById("jqueryResult").textContent = JSON.stringify(payload, null, 2);
            }
        });
    }

    function renderDownloadLinks(files) {
        const area = document.getElementById("downloadArea");
        if (!files.length) {
            area.textContent = "当前没有可下载文件。";
            return;
        }

        area.innerHTML = files.map(function (file) {
            return '<a href="' + file.downloadUrl + '">' + file.originalName + " 下载</a>";
        }).join("");
    }
</script>
</body>
</html>
