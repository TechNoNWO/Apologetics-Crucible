-- =============================================
-- FULL SCHEMA CREATION SCRIPT (Corrected Idempotent Version)
-- Database: AppologeticsCrucible
-- Drops in reverse dependency order, then creates in normal order
-- =============================================

USE AppologeticsCrucible;
GO

-- =============================================
-- DROP SECTION - Reverse dependency order (children first)
-- =============================================
IF OBJECT_ID('dbo.IngestionBatches', 'U') IS NOT NULL DROP TABLE dbo.IngestionBatches;
IF OBJECT_ID('dbo.NodeRevisions', 'U') IS NOT NULL DROP TABLE dbo.NodeRevisions;
IF OBJECT_ID('dbo.NodeRatings', 'U') IS NOT NULL DROP TABLE dbo.NodeRatings;
IF OBJECT_ID('dbo.NodeSources', 'U') IS NOT NULL DROP TABLE dbo.NodeSources;
IF OBJECT_ID('dbo.ExegeticScoreRubrics', 'U') IS NOT NULL DROP TABLE dbo.ExegeticScoreRubrics;
IF OBJECT_ID('dbo.CrossReferences', 'U') IS NOT NULL DROP TABLE dbo.CrossReferences;
IF OBJECT_ID('dbo.ProofComparisons', 'U') IS NOT NULL DROP TABLE dbo.ProofComparisons;
IF OBJECT_ID('dbo.ProofStanceLinks', 'U') IS NOT NULL DROP TABLE dbo.ProofStanceLinks;
IF OBJECT_ID('dbo.EntityCategoryValues', 'U') IS NOT NULL DROP TABLE dbo.EntityCategoryValues;
IF OBJECT_ID('dbo.ProofNodes', 'U') IS NOT NULL DROP TABLE dbo.ProofNodes;
IF OBJECT_ID('dbo.Nodes', 'U') IS NOT NULL DROP TABLE dbo.Nodes;
IF OBJECT_ID('dbo.Proofs', 'U') IS NOT NULL DROP TABLE dbo.Proofs;
IF OBJECT_ID('dbo.Categories', 'U') IS NOT NULL DROP TABLE dbo.Categories;
IF OBJECT_ID('dbo.TheologicalStances', 'U') IS NOT NULL DROP TABLE dbo.TheologicalStances;
IF OBJECT_ID('dbo.SacredTextInterlinear', 'U') IS NOT NULL DROP TABLE dbo.SacredTextInterlinear;
IF OBJECT_ID('dbo.SacredTextPassages', 'U') IS NOT NULL DROP TABLE dbo.SacredTextPassages;
IF OBJECT_ID('dbo.SacredTextSections', 'U') IS NOT NULL DROP TABLE dbo.SacredTextSections;
IF OBJECT_ID('dbo.SacredTextCorpora', 'U') IS NOT NULL DROP TABLE dbo.SacredTextCorpora;
GO

-- =============================================
-- CREATE SECTION - Forward dependency order (parents first)
-- =============================================

-- 01_SacredTextCorpora
CREATE TABLE dbo.SacredTextCorpora (
    id                BIGINT         IDENTITY(1,1) PRIMARY KEY,
    name              NVARCHAR(100)  NOT NULL UNIQUE,
    abbreviation      NVARCHAR(50)   NULL,
    language          NVARCHAR(50)   NULL,
    tradition_group   NVARCHAR(100)  NULL,
    is_gold_standard  BIT            NOT NULL DEFAULT 0,
    authority_tier    TINYINT        NOT NULL DEFAULT 1,
    vector_embedding  VARBINARY(8000) NULL,
    source_url        NVARCHAR(500)  NULL,
    license_note      NVARCHAR(500)  NULL,
    created_at        DATETIME2      NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

-- 02_SacredTextSections
CREATE TABLE dbo.SacredTextSections (
    id                BIGINT         IDENTITY(1,1) PRIMARY KEY,
    corpus_id         BIGINT         NOT NULL,
    name              NVARCHAR(200)  NOT NULL,
    standard_order    INT            NOT NULL,
    parent_section_id BIGINT         NULL,
    created_at        DATETIME2      NOT NULL DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_SacredTextSections_Corpus FOREIGN KEY (corpus_id) REFERENCES dbo.SacredTextCorpora(id),
    CONSTRAINT FK_SacredTextSections_Parent FOREIGN KEY (parent_section_id) REFERENCES dbo.SacredTextSections(id)
);
GO

-- 03_SacredTextPassages
CREATE TABLE dbo.SacredTextPassages (
    id                BIGINT         IDENTITY(1,1) PRIMARY KEY,
    section_id        BIGINT         NOT NULL,
    passage_order     BIGINT         NOT NULL UNIQUE,
    reference_label   NVARCHAR(50)   NULL,
    text_content      NVARCHAR(MAX)  NOT NULL,
    vector_embedding  VARBINARY(8000) NULL,
    created_at        DATETIME2      NOT NULL DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_SacredTextPassages_Section FOREIGN KEY (section_id) REFERENCES dbo.SacredTextSections(id)
);
GO

-- 04_SacredTextInterlinear
CREATE TABLE dbo.SacredTextInterlinear (
    id                BIGINT         IDENTITY(1,1) PRIMARY KEY,
    passage_id        BIGINT         NOT NULL,
    word_position     SMALLINT       NOT NULL,
    original_text     NVARCHAR(200)  NULL,
    transliteration   NVARCHAR(200)  NULL,
    lemma             NVARCHAR(100)  NULL,
    morphology_tags   NVARCHAR(200)  NULL,
    gloss             NVARCHAR(200)  NULL,
    strongs_number    INT            NULL,
    created_at        DATETIME2      NOT NULL DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_SacredTextInterlinear_Passage FOREIGN KEY (passage_id) REFERENCES dbo.SacredTextPassages(id)
);
GO

-- 05_Proofs
CREATE TABLE dbo.Proofs (
    id                    BIGINT         IDENTITY(1,1) PRIMARY KEY,
    title                 NVARCHAR(500)  NOT NULL,
    central_question      NVARCHAR(MAX)  NULL,
    conclusion            NVARCHAR(MAX)  NULL,
    hermeneutic_overview  NVARCHAR(MAX)  NOT NULL,
    disclaimers           NVARCHAR(MAX)  NOT NULL,
    status                VARCHAR(20)    NOT NULL DEFAULT 'DRAFT',
    created_at            DATETIME2      NOT NULL DEFAULT SYSUTCDATETIME(),
    vector_embedding      VARBINARY(8000) NULL,

    CONSTRAINT CK_Proofs_Status CHECK (status IN ('DRAFT','PUBLISHED','ARCHIVED'))
);
GO

-- 06_Nodes
CREATE TABLE dbo.Nodes (
    id                    BIGINT         IDENTITY(1,1) PRIMARY KEY,
    content               NVARCHAR(MAX)  NOT NULL,
    exegetic_strength     VARCHAR(20)    NOT NULL,
    exegetic_score        TINYINT        NOT NULL DEFAULT 50,
    inference_steps       TINYINT        NOT NULL DEFAULT 0,
    strength_rationale    NVARCHAR(1000) NULL,
    created_at            DATETIME2      NOT NULL DEFAULT SYSUTCDATETIME(),
    vector_embedding      VARBINARY(8000) NULL,

    CONSTRAINT CK_Nodes_ExegeticStrength CHECK (exegetic_strength IN ('DIRECT','STRONG','INFERENTIAL','WEAK')),
    CONSTRAINT CK_Nodes_ExegeticScore CHECK (exegetic_score BETWEEN 0 AND 100)
);
GO

-- 07_ProofNodes
CREATE TABLE dbo.ProofNodes (
    proof_id          BIGINT     NOT NULL,
    node_id           BIGINT     NOT NULL,
    parent_node_id    BIGINT     NULL,
    relationship_type VARCHAR(20) NOT NULL,
    sort_order        INT        NOT NULL,

    CONSTRAINT PK_ProofNodes PRIMARY KEY (proof_id, node_id),
    CONSTRAINT FK_ProofNodes_Proof FOREIGN KEY (proof_id) REFERENCES dbo.Proofs(id) ON DELETE CASCADE,
    CONSTRAINT FK_ProofNodes_Node FOREIGN KEY (node_id) REFERENCES dbo.Nodes(id),
    CONSTRAINT FK_ProofNodes_Parent FOREIGN KEY (parent_node_id) REFERENCES dbo.Nodes(id),
    CONSTRAINT CK_ProofNodes_RelationshipType CHECK (relationship_type IN ('SUPPORTS','REFUTES','IMPLIES'))
);
GO

-- 08_Categories
CREATE TABLE dbo.Categories (
    id                 BIGINT         IDENTITY(1,1) PRIMARY KEY,
    internal_name      NVARCHAR(100)  NOT NULL UNIQUE,
    display_name       NVARCHAR(100)  NOT NULL,
    data_type          VARCHAR(20)    NOT NULL,
    applicable_entity  VARCHAR(20)    NOT NULL,
    conditional_rule   NVARCHAR(1000) NULL,
    domain_weight      DECIMAL(3,1)   NOT NULL DEFAULT 0.1,
    relevance_weight   TINYINT        NOT NULL DEFAULT 50,
    is_active          BIT            NOT NULL DEFAULT 1,
    created_at         DATETIME2      NOT NULL DEFAULT SYSUTCDATETIME(),

    CONSTRAINT CK_Categories_DataType CHECK (data_type IN ('TEXT','JSON','REF','ENUM','BOOLEAN')),
    CONSTRAINT CK_Categories_ApplicableEntity CHECK (applicable_entity IN ('PROOF','NODE','VERSE'))
);
GO

-- 09_EntityCategoryValues
CREATE TABLE dbo.EntityCategoryValues (
    entity_type     NVARCHAR(20)   NOT NULL,
    entity_id       BIGINT         NOT NULL,
    category_id     BIGINT         NOT NULL,
    value_text      NVARCHAR(MAX)  NULL,
    value_json      NVARCHAR(MAX)  NULL,
    value_ref_table NVARCHAR(100)  NULL,
    value_ref_id    BIGINT         NULL,

    CONSTRAINT FK_EntityCategoryValues_Category FOREIGN KEY (category_id) REFERENCES dbo.Categories(id),
    CONSTRAINT CK_EntityCategoryValues_EntityType CHECK (entity_type IN ('PROOF','NODE','VERSE'))
);
GO

-- 10_TheologicalStances
CREATE TABLE dbo.TheologicalStances (
    id                BIGINT         IDENTITY(1,1) PRIMARY KEY,
    internal_name     NVARCHAR(100)  NOT NULL UNIQUE,
    display_name      NVARCHAR(200)  NOT NULL,
    tradition_group   NVARCHAR(100)  NULL,
    created_at        DATETIME2      NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

-- 11_ProofStanceLinks
CREATE TABLE dbo.ProofStanceLinks (
    proof_id   BIGINT NOT NULL,
    stance_id  BIGINT NOT NULL,

    CONSTRAINT PK_ProofStanceLinks PRIMARY KEY (proof_id, stance_id),
    CONSTRAINT FK_ProofStanceLinks_Proof FOREIGN KEY (proof_id) REFERENCES dbo.Proofs(id) ON DELETE CASCADE,
    CONSTRAINT FK_ProofStanceLinks_Stance FOREIGN KEY (stance_id) REFERENCES dbo.TheologicalStances(id)
);
GO

-- 12_ProofComparisons
CREATE TABLE dbo.ProofComparisons (
    id                BIGINT         IDENTITY(1,1) PRIMARY KEY,
    proof1_id         BIGINT         NOT NULL,
    proof2_id         BIGINT         NOT NULL,
    score_delta       DECIMAL(10,2)  NULL,
    shared_cross_refs INT            NULL,
    differing_domains INT            NULL,
    created_at        DATETIME2      NOT NULL DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_ProofComparisons_Proof1 FOREIGN KEY (proof1_id) REFERENCES dbo.Proofs(id),
    CONSTRAINT FK_ProofComparisons_Proof2 FOREIGN KEY (proof2_id) REFERENCES dbo.Proofs(id)
);
GO

-- 13_CrossReferences
CREATE TABLE dbo.CrossReferences (
    id                  BIGINT         IDENTITY(1,1) PRIMARY KEY,
    primary_passage_id  BIGINT         NOT NULL,
    related_passage_id  BIGINT         NOT NULL,
    reference_type      VARCHAR(20)    NOT NULL,
    strength            TINYINT        NOT NULL,

    CONSTRAINT FK_CrossReferences_Primary FOREIGN KEY (primary_passage_id) REFERENCES dbo.SacredTextPassages(id),
    CONSTRAINT FK_CrossReferences_Related FOREIGN KEY (related_passage_id) REFERENCES dbo.SacredTextPassages(id),
    CONSTRAINT CK_CrossReferences_Type CHECK (reference_type IN ('PARALLEL','SAME_TOPIC','FULFILLMENT','ALLUSION'))
);
GO

-- 14_ExegeticScoreRubrics
CREATE TABLE dbo.ExegeticScoreRubrics (
    id                BIGINT         IDENTITY(1,1) PRIMARY KEY,
    score_range_start TINYINT        NOT NULL,
    score_range_end   TINYINT        NOT NULL,
    description       NVARCHAR(200)  NOT NULL,
    criteria          NVARCHAR(MAX)  NOT NULL,
    created_at        DATETIME2      NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

-- 15_NodeSources
CREATE TABLE dbo.NodeSources (
    node_id           BIGINT         NOT NULL,
    source_id         BIGINT         NULL,
    credited_to       NVARCHAR(200)  NOT NULL,
    contribution_note NVARCHAR(500)  NULL,
    added_at          DATETIME2      NOT NULL DEFAULT SYSUTCDATETIME(),

    CONSTRAINT PK_NodeSources PRIMARY KEY (node_id, credited_to),
    CONSTRAINT FK_NodeSources_Node FOREIGN KEY (node_id) REFERENCES dbo.Nodes(id) ON DELETE CASCADE
);
GO

-- 16_NodeRatings
CREATE TABLE dbo.NodeRatings (
    node_id           BIGINT      NOT NULL,
    rated_by          NVARCHAR(200) NOT NULL,
    rating_strength   VARCHAR(20) NOT NULL,
    rating_score      TINYINT     NOT NULL,
    feedback_note     NVARCHAR(1000) NULL,
    rated_at          DATETIME2   NOT NULL DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_NodeRatings_Node FOREIGN KEY (node_id) REFERENCES dbo.Nodes(id) ON DELETE CASCADE,
    CONSTRAINT CK_NodeRatings_Strength CHECK (rating_strength IN ('DIRECT','STRONG','INFERENTIAL','WEAK')),
    CONSTRAINT CK_NodeRatings_Score CHECK (rating_score BETWEEN 0 AND 100)
);
GO

-- 17_NodeRevisions
CREATE TABLE dbo.NodeRevisions (
    original_node_id   BIGINT      NOT NULL,
    new_node_id        BIGINT      NOT NULL,
    revision_type      VARCHAR(20) NOT NULL,
    reason_note        NVARCHAR(1000) NULL,
    created_at         DATETIME2   NOT NULL DEFAULT SYSUTCDATETIME(),

    CONSTRAINT PK_NodeRevisions PRIMARY KEY (original_node_id, new_node_id),
    CONSTRAINT FK_NodeRevisions_Original FOREIGN KEY (original_node_id) REFERENCES dbo.Nodes(id),
    CONSTRAINT FK_NodeRevisions_New FOREIGN KEY (new_node_id) REFERENCES dbo.Nodes(id),
    CONSTRAINT CK_NodeRevisions_Type CHECK (revision_type IN ('IMPROVES','REFUTES'))
);
GO

-- 18_IngestionBatches
CREATE TABLE dbo.IngestionBatches (
    id                  BIGINT         IDENTITY(1,1) PRIMARY KEY,
    source_name         NVARCHAR(500)  NOT NULL,
    source_type         VARCHAR(50)    NOT NULL,
    uploaded_by         NVARCHAR(200)  NOT NULL,
    uploaded_at         DATETIME2      NOT NULL DEFAULT SYSUTCDATETIME(),
    status              VARCHAR(20)    NOT NULL DEFAULT 'COMMITTED',
    record_count        INT            NULL,
    blurb_summary       NVARCHAR(MAX)  NULL,
    raw_file_path       NVARCHAR(1000) NULL,
    created_at          DATETIME2      NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

PRINT 'All 18 tables dropped (if existed) and recreated successfully in AppologeticsCrucible.';
GO