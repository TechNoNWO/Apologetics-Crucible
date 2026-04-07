USE AppologeticsCrucible;
GO

-- Helper table for previewing parsed data before committing
IF OBJECT_ID('dbo.IngestionPreview', 'U') IS NOT NULL DROP TABLE dbo.IngestionPreview;
GO

CREATE TABLE dbo.IngestionPreview (
    batch_id          BIGINT,
    row_num           INT,
    node_content      NVARCHAR(MAX),
    exegetic_strength VARCHAR(20),
    exegetic_score    TINYINT,
    inference_steps   TINYINT,
    cited_refs        NVARCHAR(500),
    guardrail_passed  BIT DEFAULT 1,
    guardrail_reason  NVARCHAR(500)
);
GO

-- Stored procedure that simulates the AI parser + guardrail
CREATE OR ALTER PROCEDURE dbo.sp_ParseSourceForIngestion
    @source_text NVARCHAR(MAX),
    @credited_to NVARCHAR(200),
    @batch_id    BIGINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.IngestionBatches 
        (source_name, source_type, uploaded_by, status, blurb_summary)
    VALUES 
        ('Uploaded Source', 'MANUAL', @credited_to, 'PENDING', 'AI parsing in progress...');

    SET @batch_id = SCOPE_IDENTITY();

    -- Simulated Grok-style parser (in real backend this would call your AI)
    INSERT INTO dbo.IngestionPreview (batch_id, row_num, node_content, exegetic_strength, exegetic_score, inference_steps, cited_refs, guardrail_passed, guardrail_reason)
    SELECT 
        @batch_id,
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)),
        value,
        'STRONG',
        75,
        1,
        'John 3:16',
        1,
        'Within gold text'
    FROM STRING_SPLIT(@source_text, CHAR(10));

    -- Generate high-level blurb
    UPDATE dbo.IngestionBatches
    SET blurb_summary = CONCAT(
        'Parsed ', (SELECT COUNT(*) FROM dbo.IngestionPreview WHERE batch_id = @batch_id),
        ' nodes. ',
        'Contains scripture references and logical claims. Guardrail passed.'
    )
    WHERE id = @batch_id;
END;
GO

PRINT '✅ Step 4 Complete: Ingestion pipeline foundation created (IngestionPreview + sp_ParseSourceForIngestion)';
GO