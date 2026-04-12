package com.apologeticscrucible.apologeticscruciblebackend;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * Main Spring Boot application entry point for Apologetics Crucible Backend
 *
 * Enables:
 * - DataSource auto-configuration (database connection)
 * - Component scanning
 * - Auto-configuration of Spring beans
 */
@SpringBootApplication
public class ApologeticsCrucibleBackendApplication {

	public static void main(String[] args) {
		SpringApplication.run(ApologeticsCrucibleBackendApplication.class, args);
	}

}
