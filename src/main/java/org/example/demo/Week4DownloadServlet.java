package org.example.demo;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;

@WebServlet(name = "Week4DownloadServlet", value = "/api/week4/download")
public class Week4DownloadServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String file = req.getParameter("file");
        String name = req.getParameter("name");
        if (file == null || file.isBlank()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing file parameter");
            return;
        }

        Path uploadDir = Week4FileSupport.resolveUploadDirectory(getServletContext());
        Path target = uploadDir.resolve(file).normalize();
        if (!target.startsWith(uploadDir) || !Files.exists(target) || Files.isDirectory(target)) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found");
            return;
        }

        String downloadName = Week4FileSupport.sanitizeOriginalFilename(name);
        String contentType = Files.probeContentType(target);
        if (contentType == null || contentType.isBlank()) {
            contentType = "application/octet-stream";
        }

        resp.setContentType(contentType);
        resp.setContentLengthLong(Files.size(target));
        resp.setHeader("Content-Disposition",
                "attachment; filename*=UTF-8''" + URLEncoder.encode(downloadName, StandardCharsets.UTF_8).replace("+", "%20"));

        try (var inputStream = Files.newInputStream(target);
             var outputStream = resp.getOutputStream()) {
            inputStream.transferTo(outputStream);
        }
    }
}
