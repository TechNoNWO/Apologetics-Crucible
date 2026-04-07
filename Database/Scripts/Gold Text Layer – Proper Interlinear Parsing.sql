USE AppologeticsCrucible;
GO

-- Clear any existing KJV interlinear data (idempotent)
DELETE FROM dbo.SacredTextInterlinear 
WHERE passage_id IN (
    SELECT id FROM dbo.SacredTextPassages 
    WHERE section_id IN (
        SELECT id FROM dbo.SacredTextSections 
        WHERE corpus_id = (SELECT id FROM dbo.SacredTextCorpora WHERE name = 'KJV with Strongs')
    )
);
GO

-- Parse and load interlinear data
INSERT INTO dbo.SacredTextInterlinear 
    (passage_id, word_position, original_text, morphology_tags, strongs_number)
SELECT 
    p.id AS passage_id,
    ROW_NUMBER() OVER (PARTITION BY s.Verse_ID ORDER BY (SELECT NULL)) AS word_position,
    TRIM(REPLACE(REPLACE(value, CHAR(13), ''), CHAR(10), '')) AS original_text,
    CASE 
        WHEN value LIKE '%{%' THEN SUBSTRING(value, CHARINDEX('{', value), LEN(value))
        ELSE NULL 
    END AS morphology_tags,
    TRY_CAST(
        SUBSTRING(
            value, 
            CHARINDEX('{H', value) + 2, 
            CASE WHEN CHARINDEX('}', value, CHARINDEX('{H', value)) > 0 
                 THEN CHARINDEX('}', value, CHARINDEX('{H', value)) - CHARINDEX('{H', value) - 2 
                 ELSE 0 
            END
        ) AS INT
    ) AS strongs_number
FROM dbo.kjv_strongs s
INNER JOIN dbo.SacredTextPassages p 
    ON p.passage_order = s.Verse_ID
CROSS APPLY STRING_SPLIT(s.Text, ' ')
WHERE p.section_id IN (
    SELECT id FROM dbo.SacredTextSections 
    WHERE corpus_id = (SELECT id FROM dbo.SacredTextCorpora WHERE name = 'KJV with Strongs')
);
GO

PRINT '✅ Step 1 Complete: SacredTextInterlinear populated from KJV with Strong''s';
GO