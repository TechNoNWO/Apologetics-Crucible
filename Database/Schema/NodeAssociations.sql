USE AppologeticsCrucible;
GO

-- Create NodeAssociations table for credit and linking
IF OBJECT_ID('dbo.NodeAssociations', 'U') IS NOT NULL 
    DROP TABLE dbo.NodeAssociations;
GO

CREATE TABLE dbo.NodeAssociations (
    id                  BIGINT         IDENTITY(1,1) PRIMARY KEY,
    new_node_id         BIGINT         NOT NULL,
    existing_node_id    BIGINT         NOT NULL,
    association_type    VARCHAR(20)    NOT NULL,   -- DUPLICATE, SIMILAR, REFUTES, SUPPORTS
    similarity_score    DECIMAL(5,4)   NULL,
    added_by            NVARCHAR(200)  NOT NULL,
    added_at            DATETIME2      NOT NULL DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_NodeAssociations_New 
        FOREIGN KEY (new_node_id) REFERENCES dbo.Nodes(id) ON DELETE CASCADE,

    CONSTRAINT FK_NodeAssociations_Existing 
        FOREIGN KEY (existing_node_id) REFERENCES dbo.Nodes(id),

    CONSTRAINT CK_NodeAssociations_Type 
        CHECK (association_type IN ('DUPLICATE','SIMILAR','REFUTES','SUPPORTS'))
);
GO

PRINT '✅ NodeAssociations table created - ready for credit and duplicate handling';
GO