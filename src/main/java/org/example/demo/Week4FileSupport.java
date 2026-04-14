package org.example.demo;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.text.Normalizer;
import java.time.Instant;
import java.util.Locale;
import java.util.UUID;

public final class Week4FileSupport {

    private Week4FileSupport() {
    }

    public static Path resolveUploadDirectory(ServletContext servletContext) throws IOException {
        String configured = servletContext.getInitParameter("week4UploadDir");
        Path uploadDir;
        if (configured != null && !configured.isBlank()) {
            uploadDir = Path.of(configured);
        } else {
            uploadDir = Path.of(System.getProperty("java.io.tmpdir"), "demo-week4-uploads");
        }
        Files.createDirectories(uploadDir);
        return uploadDir;
    }

    public static StoredFile saveUploadedFile(Part part, Path uploadDir) throws IOException {
        String originalName = sanitizeOriginalFilename(part.getSubmittedFileName());
        String extension = "";
        int dotIndex = originalName.lastIndexOf('.');
        if (dotIndex >= 0) {
            extension = originalName.substring(dotIndex);
        }

        String storedName = Instant.now().toEpochMilli() + "-" + UUID.randomUUID() + extension;
        Path target = uploadDir.resolve(storedName).normalize();
        if (!target.startsWith(uploadDir)) {
            throw new IOException("Invalid upload target path");
        }

        try (InputStream inputStream = part.getInputStream()) {
            Files.copy(inputStream, target, StandardCopyOption.REPLACE_EXISTING);
        }

        String contentType = part.getContentType();
        if (contentType == null || contentType.isBlank()) {
            contentType = Files.probeContentType(target);
        }
        if (contentType == null || contentType.isBlank()) {
            contentType = "application/octet-stream";
        }

        return new StoredFile(storedName, originalName, target, contentType, Files.size(target));
    }

    public static String readPartText(Part part) throws IOException {
        return new String(part.getInputStream().readAllBytes(), java.nio.charset.StandardCharsets.UTF_8);
    }

    public static String escapeJson(String value) {
        if (value == null) {
            return "";
        }

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
                        escaped.append(String.format(Locale.ROOT, "\\u%04x", (int) ch));
                    } else {
                        escaped.append(ch);
                    }
            }
        }
        return escaped.toString();
    }

    public static String sanitizeOriginalFilename(String filename) {
        if (filename == null || filename.isBlank()) {
            return "unnamed-file";
        }

        String normalized = Normalizer.normalize(filename, Normalizer.Form.NFKC)
                .replace('\\', '/');
        int slashIndex = normalized.lastIndexOf('/');
        if (slashIndex >= 0) {
            normalized = normalized.substring(slashIndex + 1);
        }

        normalized = normalized.replaceAll("[\\r\\n]", "_").trim();
        return normalized.isEmpty() ? "unnamed-file" : normalized;
    }

    public record StoredFile(
            String storedName,
            String originalName,
            Path path,
            String contentType,
            long size
    ) {
    }
}
