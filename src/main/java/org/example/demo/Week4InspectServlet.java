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
import java.util.Collection;

@WebServlet(name = "Week4InspectServlet", value = "/api/week4/inspect")
@MultipartConfig
public class Week4InspectServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding(StandardCharsets.UTF_8.name());
        Collection<Part> parts = req.getParts();

        StringBuilder partJson = new StringBuilder();
        int index = 0;
        for (Part part : parts) {
            if (index > 0) {
                partJson.append(',');
            }

            String submittedFileName = part.getSubmittedFileName();
            boolean filePart = submittedFileName != null && !submittedFileName.isBlank();
            partJson.append('{')
                    .append("\"index\":").append(index + 1).append(',')
                    .append("\"name\":\"").append(Week4FileSupport.escapeJson(part.getName())).append("\",")
                    .append("\"kind\":\"").append(filePart ? "file" : "field").append("\",")
                    .append("\"contentType\":\"").append(Week4FileSupport.escapeJson(part.getContentType())).append("\",")
                    .append("\"size\":").append(part.getSize());

            if (filePart) {
                partJson.append(",\"submittedFileName\":\"")
                        .append(Week4FileSupport.escapeJson(Week4FileSupport.sanitizeOriginalFilename(submittedFileName)))
                        .append('"');
            } else {
                partJson.append(",\"value\":\"")
                        .append(Week4FileSupport.escapeJson(Week4FileSupport.readPartText(part)))
                        .append('"');
            }
            partJson.append('}');
            index++;
        }

        resp.setCharacterEncoding(StandardCharsets.UTF_8.name());
        resp.setContentType("application/json;charset=UTF-8");
        resp.getWriter().write("{"
                + "\"code\":200,"
                + "\"message\":\"multipart request received\","
                + "\"partCount\":" + parts.size() + ","
                + "\"parts\":[" + partJson + "]"
                + "}");
    }
}
