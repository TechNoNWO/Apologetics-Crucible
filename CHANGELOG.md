# Changelog

All notable changes to the **Apologetics Crucible** project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial database schema with 18 tables (idempotent creation script)
- Gold Sacred Text Layer (`SacredTextCorpora`, `SacredTextSections`, `SacredTextPassages`, `SacredTextInterlinear`)
- Core Proof & Logic Layer (`Proofs`, `Nodes`, `ProofNodes`)
- Dynamic RHS Panel system (`Categories`, `EntityCategoryValues`)
- Stance, Comparison & Cross-Reference tables
- Node revision & refutation tracking (`NodeRevisions`, `NodeRatings`, `NodeSources`)
- Ingestion tracking table (`IngestionBatches`) for automated source processing

### Changed
- All CREATE TABLE scripts made fully idempotent (safe to re-run)

### Todo (next milestones)
- Insert initial Categories data (RHS panel + spiritual/lineage/idiom claim types)
- Create `v_TopicExegeticSigma` master ranking view
- Add vector search performance indexes
- Implement automated ingestion pipeline (Grok parser + guardrail + preview grid)
- Load sample data (Vinson vs Shamoun Trinity case study)

## [0.1.0] - 2026-04-05

**Initial Schema Release**

First public schema for the Apologetics Crucible project.

- Complete foundational database (18 tables)
- Full support for vector embeddings and RAG
- Strict enforcement of exegetic guardrails
- Ingestion batch tracking ready for transcripts, blogs, PDFs, etc.

**See** [Database/Schema/](Database/Schema/) for the idempotent initialization script.