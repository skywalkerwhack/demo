package org.example.demo;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "Week4JQueryUploadServlet", value = "/api/week4/jquery-upload")
@MultipartConfig
public class Week4JQueryUploadServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding(StandardCharsets.UTF_8.name());
        Path uploadDir = Week4FileSupport.resolveUploadDirectory(getServletContext());

        String userName = req.getParameter("userName");
        String userId = req.getParameter("userId");
        String userRole = req.getParameter("userRole");

        List<Week4FileSupport.StoredFile> files = new ArrayList<>();
        collectFile(req.getPart("file01"), uploadDir, files);
        collectFile(req.getPart("file02"), uploadDir, files);
        collectFile(req.getPart("file03"), uploadDir, files);

        if (files.isEmpty()) {
            writeError(resp, "至少选择一个文件");
            return;
        }

        StringBuilder fileJson = new StringBuilder();
        for (int i = 0; i < files.size(); i++) {
            Week4FileSupport.StoredFile file = files.get(i);
            if (i > 0) {
                fileJson.append(',');
            }
            fileJson.append("{")
                    .append("\"originalName\":\"").append(Week4FileSupport.escapeJson(file.originalName())).append("\",")
                    .append("\"storedName\":\"").append(Week4FileSupport.escapeJson(file.storedName())).append("\",")
                    .append("\"size\":").append(file.size()).append(',')
                    .append("\"contentType\":\"").append(Week4FileSupport.escapeJson(file.contentType())).append("\",")
                    .append("\"downloadUrl\":\"api/week4/download?file=").append(Week4FileSupport.escapeJson(file.storedName()))
                    .append("&name=").append(Week4FileSupport.escapeJson(file.originalName())).append("\",")
                    .append("\"virtualUrlExample\":\"/upload/demo/").append(Week4FileSupport.escapeJson(file.storedName())).append("\"")
                    .append("}");
        }

        resp.setCharacterEncoding(StandardCharsets.UTF_8.name());
        resp.setContentType("application/json;charset=UTF-8");
        resp.getWriter().write("{"
                + "\"code\":200,"
                + "\"message\":\"jquery multi-file upload success\","
                + "\"user\":{"
                + "\"name\":\"" + Week4FileSupport.escapeJson(userName) + "\","
                + "\"id\":\"" + Week4FileSupport.escapeJson(userId) + "\","
                + "\"role\":\"" + Week4FileSupport.escapeJson(userRole) + "\""
                + "},"
                + "\"files\":[" + fileJson + "]"
                + "}");
    }

    private void collectFile(Part part, Path uploadDir, List<Week4FileSupport.StoredFile> files) throws IOException {
        if (part != null && part.getSize() > 0) {
            files.add(Week4FileSupport.saveUploadedFile(part, uploadDir));
        }
    }

    private void writeError(HttpServletResponse resp, String message) throws IOException {
        resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        resp.setCharacterEncoding(StandardCharsets.UTF_8.name());
        resp.setContentType("application/json;charset=UTF-8");
        resp.getWriter().write("{\"code\":400,\"message\":\"" + Week4FileSupport.escapeJson(message) + "\"}");
    }
}
