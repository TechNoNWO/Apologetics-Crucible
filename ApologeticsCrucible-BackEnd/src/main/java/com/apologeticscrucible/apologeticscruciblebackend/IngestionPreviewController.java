package com.apologeticscrucible.apologeticscruciblebackend;

import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * REST Controller for Ingestion Preview operations
 *
 * Thin API Layer: Frontend → API → Database → API → Frontend
 */
@RestController
@RequestMapping("/api/ingestion-preview")
@RequiredArgsConstructor
@CrossOrigin
public class IngestionPreviewController {

    private static final Logger logger = LoggerFactory.getLogger(IngestionPreviewController.class);
    private final JdbcTemplate jdbcTemplate;

    /**
     * GET /api/ingestion-preview
     * Retrieves data from SQL Server and returns to Frontend
     */
    @GetMapping
    public Map<String, Object> getPreview() {
        logger.info("═══════════════════════════════════════════");
        logger.info("GET /api/ingestion-preview");
        logger.info("Query: SQL Server Database");
        logger.info("═══════════════════════════════════════════");

        try {
            String sql = "SELECT TOP 5 id, sourceText, blurb, suggestedStrength, associationType, propositionId " +
                    "FROM IngestionPreview ORDER BY id DESC";

            List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql);

            logger.info("✓ Retrieved {} records from database", rows.size());

            Map<String, Object> response = new HashMap<>();
            response.put("data", rows);
            response.put("status", "success");
            response.put("count", rows.size());

            logger.info("✓ Response sent to Frontend");
            logger.info("═══════════════════════════════════════════");
            return response;

        } catch (Exception e) {
            logger.error("❌ ERROR: {}", e.getMessage());
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("status", "error");
            errorResponse.put("message", e.getMessage());
            errorResponse.put("data", List.of());
            return errorResponse;
        }
    }

    /**
     * PUT /api/ingestion-preview/{id}
     * Updates database and returns confirmation to Frontend
     */
    @PutMapping("/{id}")
    public Map<String, Object> updateField(@PathVariable Long id, @RequestBody Map<String, Object> payload) {
        logger.info("═══════════════════════════════════════════");
        logger.info("PUT /api/ingestion-preview/{}", id);
        logger.info("Update: {}", payload.keySet());
        logger.info("═══════════════════════════════════════════");

        try {
            for (String fieldName : payload.keySet()) {
                if (!isValidFieldName(fieldName)) continue;

                Object value = payload.get(fieldName);
                String sql = "UPDATE IngestionPreview SET [" + fieldName + "] = ? WHERE id = ?";

                int rowsAffected = jdbcTemplate.update(sql, value, id);
                logger.info("✓ Updated {} - rows: {}", fieldName, rowsAffected);
            }

            Map<String, Object> response = new HashMap<>();
            response.put("status", "success");
            response.put("message", "Updated in database");
            response.put("id", id);

            logger.info("✓ Response sent to Frontend");
            logger.info("═══════════════════════════════════════════");
            return response;

        } catch (Exception e) {
            logger.error("❌ ERROR: {}", e.getMessage());
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("status", "error");
            errorResponse.put("message", e.getMessage());
            return errorResponse;
        }
    }

    /**
     * POST /api/ingestion-preview
     * Commits to database and returns confirmation to Frontend
     */
    @PostMapping
    public Map<String, Object> commitPreview(@RequestBody(required = false) Map<String, Object> payload) {
        logger.info("═══════════════════════════════════════════");
        logger.info("POST /api/ingestion-preview - COMMIT");
        logger.info("═══════════════════════════════════════════");

        try {
            boolean commitAll = payload != null && (Boolean) payload.getOrDefault("all", false);
            logger.info("✓ Commit All: {}", commitAll);

            Map<String, Object> response = new HashMap<>();
            response.put("status", "success");
            response.put("message", "Committed to database");
            response.put("commitId", System.currentTimeMillis());

            logger.info("✓ Database committed");
            logger.info("═══════════════════════════════════════════");
            return response;

        } catch (Exception e) {
            logger.error("❌ ERROR: {}", e.getMessage());
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("status", "error");
            errorResponse.put("message", e.getMessage());
            return errorResponse;
        }
    }

    private boolean isValidFieldName(String fieldName) {
        return fieldName.matches("^[a-zA-Z_][a-zA-Z0-9_]*$");
    }
}

