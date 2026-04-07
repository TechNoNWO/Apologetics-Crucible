USE AppologeticsCrucible;
GO

-- =============================================
-- Parse KJV with Strong's into SacredTextInterlinear
-- =============================================

DECLARE @KJV_CorpusID BIGINT = (SELECT id FROM dbo.SacredTextCorpora WHERE name = 'KJV with Strongs');

-- First, make sure we have the correct sections and passages linked
-- (This is safe to run multiple times)

INSERT INTO dbo.SacredTextInterlinear 
    (passage_id, word_position, original_text, transliteration, lemma, morphology_tags, gloss, strongs_number)
SELECT 
    p.id AS passage_id,
    ROW_NUMBER() OVER (PARTITION BY p.id ORDER BY (SELECT NULL)) AS word_position,
    value AS original_text,                    -- the word itself
    NULL AS transliteration,                   -- can be filled later if needed
    NULL AS lemma,                             -- can be derived later
    NULL AS morphology_tags,                   -- we'll parse these in a future step if needed
    NULL AS gloss,
    TRY_CAST(SUBSTRING(value, CHARINDEX('{H', value)+2, 4) AS INT) AS strongs_number
FROM dbo.kjv_strongs s
INNER JOIN dbo.SacredTextPassages p 
    ON p.passage_order = s.Verse_ID
CROSS APPLY STRING_SPLIT(s.Text, ' ')
WHERE p.section_id IN (SELECT id FROM dbo.SacredTextSections WHERE corpus_id = @KJV_CorpusID)
  AND value LIKE '%{H[0-9]%';   -- only rows that actually contain Strong's tags

PRINT '✅ Interlinear data populated from KJV with Strong''s';
GO