# Changelog

## [Unreleased]

### Added
- Initial project setup with Spring Boot 3.3.4 and Java 21
- Dependencies: Spring Web, Spring Data JDBC, MSSQL JDBC, Lombok, Springdoc OpenAPI
- Basic application structure and configuration
- .gitignore file with standard exclusions including changelog.md
- Maven wrapper files (mvnw.cmd, mvnw, .mvn/wrapper/) for consistent builds
- IngestionPreviewController with REST endpoints for ingestion preview operations
- Swagger/OpenAPI documentation setup
- Successful build verification and runtime testing

### Changed
- Excluded DataSource auto-configuration for testing without database
- Commented out datasource configuration in application.properties for standalone testing

### Fixed
- Corrected Springdoc OpenAPI dependency to springdoc-openapi-starter-webmvc-ui version 2.5.0
