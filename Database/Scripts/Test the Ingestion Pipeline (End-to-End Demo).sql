USE AppologeticsCrucible;
GO

DECLARE @BatchID BIGINT;
DECLARE @SampleSourceText NVARCHAR(MAX) = 
'Claim 1: John 3:16 shows God gave His only Son for the world. 
Claim 2: Romans 5:8 proves God demonstrates His love while we were still sinners.';

EXEC dbo.sp_ParseSourceForIngestion 
    @source_text = @SampleSourceText,
    @credited_to = 'Test User',
    @batch_id = @BatchID OUTPUT;

PRINT '✅ Batch created with ID: ' + CAST(@BatchID AS VARCHAR(10));

-- Preview grid (what the user will see)
SELECT 
    row_num,
    node_content,
    exegetic_strength,
    exegetic_score,
    inference_steps,
    cited_refs,
    guardrail_passed,
    guardrail_reason
FROM dbo.IngestionPreview 
WHERE batch_id = @BatchID
ORDER BY row_num;

-- High-level blurb
SELECT blurb_summary 
FROM dbo.IngestionBatches 
WHERE id = @BatchID;

PRINT '✅ Step 5 Complete: Ingestion pipeline test successful';
GO