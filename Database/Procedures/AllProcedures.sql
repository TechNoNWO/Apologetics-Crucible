USE [AppologeticsCrucible]
GO
/****** Object:  StoredProcedure [dbo].[sp_ParseSourceForIngestion]    Script Date: 4/8/2026 9:09:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_ParseSourceForIngestion]
    @IngestionBatchID   INT,
    @SourceID           INT,           
    @RawText            NVARCHAR(MAX),
    @ParserOptions      NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @BatchStart DATETIME2(7) = GETDATE();

    -- Clear previous preview for this batch
    DELETE FROM dbo.IngestionPreview 
    WHERE IngestionBatchID = @IngestionBatchID;

    -- 1. Chunk the raw text
    DECLARE @Chunks TABLE (
        ChunkID    INT IDENTITY(1,1),
        ChunkText  NVARCHAR(4000),
        StartPos   INT
    );

    INSERT INTO @Chunks (ChunkText, StartPos)
    SELECT LTRIM(RTRIM(value)), CHARINDEX(value, @RawText)
    FROM STRING_SPLIT(@RawText, CHAR(10))
    WHERE LEN(LTRIM(RTRIM(value))) > 30;

    -- 2. Build preview (2019 compatible)
    DECLARE @Preview TABLE (
        ChunkID               INT,
        PreviewText           NVARCHAR(4000),
        SimilarityScoreNode   FLOAT,
        SuggestedNodeID       BIGINT,
        SimilarityScorePassage FLOAT,
        SuggestedPassageID    BIGINT,
        SuggestedStrength     VARCHAR(20),
        AssociationType       VARCHAR(30),
        Blurb                 NVARCHAR(800),
        SourceReference       NVARCHAR(500)
    );

    INSERT INTO @Preview
    SELECT 
        c.ChunkID,
        c.ChunkText,
        NULL AS SimilarityScoreNode,           
        NULL AS SuggestedNodeID,
        NULL AS SimilarityScorePassage,
        NULL AS SuggestedPassageID,
        'WEAK' AS SuggestedStrength,           
        'CREDIT' AS AssociationType,
        LEFT(c.ChunkText, 800) + '...' AS Blurb,
        COALESCE(s.title + ' (' + CAST(s.publication_year AS VARCHAR(4)) + ')', 'Unknown Source') AS SourceReference
    FROM @Chunks c
    LEFT JOIN dbo.Sources s ON s.id = @SourceID;

    -- 3. Save to IngestionPreview
    INSERT INTO dbo.IngestionPreview (
        IngestionBatchID, SourceID, ChunkText, SuggestedNodeID, 
        SimilarityScoreNode, SuggestedPassageID, SuggestedStrength, 
        AssociationType, Blurb, SourceReference, CreatedAt
    )
    SELECT 
        @IngestionBatchID, @SourceID, PreviewText, SuggestedNodeID, 
        SimilarityScoreNode, SuggestedPassageID, SuggestedStrength, 
        AssociationType, Blurb, SourceReference, @BatchStart
    FROM @Preview;

    -- 4. Return preview data for Angular UI
    SELECT 
        PreviewID,
        ChunkText,
        SuggestedNodeID,
        SimilarityScoreNode,
        SuggestedPassageID,
        SuggestedStrength,
        AssociationType,
        Blurb,
        SourceReference
    FROM dbo.IngestionPreview
    WHERE IngestionBatchID = @IngestionBatchID
    ORDER BY PreviewID;

    PRINT '✅ Ingestion parsing complete. ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' chunks staged (fully aligned with your schema).';
END
GO
/****** Object:  StoredProcedure [dbo].[sp_TestProc]    Script Date: 4/8/2026 9:09:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_TestProc]
AS
BEGIN
    SET NOCOUNT ON;
    PRINT '✅ Test procedure created and running successfully!';
    SELECT DB_NAME() AS CurrentDatabase, GETDATE() AS Now;
END
GO
