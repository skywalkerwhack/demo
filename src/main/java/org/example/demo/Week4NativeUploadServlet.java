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

@WebServlet(name = "Week4NativeUploadServlet", value = "/api/week4/native-upload")
@MultipartConfig
public class Week4NativeUploadServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding(StandardCharsets.UTF_8.name());

        String studentName = req.getParameter("studentName");
        Part filePart = req.getPart("nativeFile");
        if (filePart == null || filePart.getSize() == 0) {
            writeError(resp, "请选择要上传的文件");
            return;
        }

        Path uploadDir = Week4FileSupport.resolveUploadDirectory(getServletContext());
        Week4FileSupport.StoredFile storedFile = Week4FileSupport.saveUploadedFile(filePart, uploadDir);

        resp.setCharacterEncoding(StandardCharsets.UTF_8.name());
        resp.setContentType("application/json;charset=UTF-8");
        resp.getWriter().write("{"
                + "\"code\":200,"
                + "\"message\":\"native upload success\","
                + "\"studentName\":\"" + Week4FileSupport.escapeJson(studentName) + "\","
                + "\"file\":{"
                + "\"originalName\":\"" + Week4FileSupport.escapeJson(storedFile.originalName()) + "\","
                + "\"storedName\":\"" + Week4FileSupport.escapeJson(storedFile.storedName()) + "\","
                + "\"size\":" + storedFile.size() + ','
                + "\"contentType\":\"" + Week4FileSupport.escapeJson(storedFile.contentType()) + "\","
                + "\"downloadUrl\":\"api/week4/download?file=" + Week4FileSupport.escapeJson(storedFile.storedName())
                + "&name=" + Week4FileSupport.escapeJson(storedFile.originalName()) + "\""
                + "}"
                + "}");
    }

    private void writeError(HttpServletResponse resp, String message) throws IOException {
        resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        resp.setCharacterEncoding(StandardCharsets.UTF_8.name());
        resp.setContentType("application/json;charset=UTF-8");
        resp.getWriter().write("{\"code\":400,\"message\":\"" + Week4FileSupport.escapeJson(message) + "\"}");
    }
}
