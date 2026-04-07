USE AppologeticsCrucible;
GO

-- 1. Create the Sources table (idempotent)
IF OBJECT_ID('dbo.Sources', 'U') IS NOT NULL 
    DROP TABLE dbo.Sources;
GO

CREATE TABLE dbo.Sources (
    id                BIGINT         IDENTITY(1,1) PRIMARY KEY,
    source_type       VARCHAR(50)    NOT NULL,
    title             NVARCHAR(500)  NOT NULL,
    author            NVARCHAR(200)  NULL,
    publication_year  SMALLINT       NULL,
    tradition_group   NVARCHAR(100)  NULL,
    authority_tier    TINYINT        NOT NULL DEFAULT 4,
    source_url        NVARCHAR(500)  NULL,
    license_note      NVARCHAR(500)  NULL,
    created_at        DATETIME2      NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

-- 2. Make sure source_id exists in NodeSources (idempotent)
IF NOT EXISTS (
    SELECT 1 
    FROM sys.columns 
    WHERE object_id = OBJECT_ID('dbo.NodeSources') 
      AND name = 'source_id'
)
BEGIN
    ALTER TABLE dbo.NodeSources 
        ADD source_id BIGINT NULL;
END
GO

-- 3. Add the foreign key if it doesn't exist
IF NOT EXISTS (
    SELECT 1 
    FROM sys.foreign_keys 
    WHERE name = 'FK_NodeSources_Sources'
)
BEGIN
    ALTER TABLE dbo.NodeSources
        ADD CONSTRAINT FK_NodeSources_Sources 
            FOREIGN KEY (source_id) REFERENCES dbo.Sources(id);
END
GO

PRINT '✅ Sources table created and NodeSources updated with source_id + FK';
GO