package org.example.demo;

import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.BufferedReader;
import java.io.IOException;
import java.nio.charset.StandardCharsets;

@WebServlet(name = "Week3JsonServlet", value = "/api/week3/data")
public class Week3JsonServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        writeJsonResponse(resp, "", "GET");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding(StandardCharsets.UTF_8.name());
        writeJsonResponse(resp, readRequestBody(req), "POST");
    }

    private void writeJsonResponse(HttpServletResponse resp, String requestBody, String method)
            throws IOException {
        resp.setCharacterEncoding(StandardCharsets.UTF_8.name());
        resp.setContentType("application/json;charset=UTF-8");

        String responseJson = "{"
                + "\"code\":200,"
                + "\"message\":\"success\","
                + "\"method\":\"" + escapeJson(method) + "\","
                + "\"receivedPayload\":\"" + escapeJson(requestBody) + "\","
                + "\"total\":4,"
                + "\"aaData\":["
                + "[\"1001\",\"Java Web\",\"张三\",\"已提交\",\"95\"],"
                + "[\"1002\",\"Ajax 与 JSON\",\"李四\",\"已接收\",\"91\"],"
                + "[\"1003\",\"Servlet 实验\",\"王五\",\"待批改\",\"88\"],"
                + "[\"1004\",\"jQuery 请求\",\"赵六\",\"已完成\",\"97\"]"
                + "]"
                + "}";

        resp.getWriter().write(responseJson);
    }

    private String readRequestBody(HttpServletRequest req) throws IOException {
        StringBuilder builder = new StringBuilder();
        try (BufferedReader reader = req.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                builder.append(line);
            }
        }
        return builder.toString();
    }

    private String escapeJson(String value) {
        StringBuilder escaped = new StringBuilder();
        for (char ch : value.toCharArray()) {
            switch (ch) {
                case '\\':
                    escaped.append("\\\\");
                    break;
                case '"':
                    escaped.append("\\\"");
                    break;
                case '\b':
                    escaped.append("\\b");
                    break;
                case '\f':
                    escaped.append("\\f");
                    break;
                case '\n':
                    escaped.append("\\n");
                    break;
                case '\r':
                    escaped.append("\\r");
                    break;
                case '\t':
                    escaped.append("\\t");
                    break;
                default:
                    if (ch < 0x20) {
                        escaped.append(String.format("\\u%04x", (int) ch));
                    } else {
                        escaped.append(ch);
                    }
                    break;
            }
        }
        return escaped.toString();
    }
}