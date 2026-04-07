USE AppologeticsCrucible;
GO

-- =============================================
-- Load Books (SacredTextSections) and Verses (SacredTextPassages)
-- for both KJV with Strong's and WEB
-- =============================================

DECLARE @KJV_CorpusID BIGINT = (SELECT id FROM dbo.SacredTextCorpora WHERE name = 'KJV with Strongs');
DECLARE @WEB_CorpusID  BIGINT = (SELECT id FROM dbo.SacredTextCorpora WHERE name = 'World English Bible');

-- 1. KJV - Books
INSERT INTO dbo.SacredTextSections (corpus_id, name, standard_order, parent_section_id)
SELECT DISTINCT 
    @KJV_CorpusID,
    Book_Name,
    Book_Number,
    NULL
FROM dbo.kjv_strongs s
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.SacredTextSections 
    WHERE corpus_id = @KJV_CorpusID AND name = s.Book_Name
);

-- 2. KJV - Verses
INSERT INTO dbo.SacredTextPassages (section_id, passage_order, reference_label, text_content)
SELECT 
    sec.id,
    s.Verse_ID,
    CONCAT(s.Book_Name, ' ', s.Chapter, ':', s.Verse),
    s.Text
FROM dbo.kjv_strongs s
INNER JOIN dbo.SacredTextSections sec 
    ON sec.corpus_id = @KJV_CorpusID AND sec.name = s.Book_Name
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.SacredTextPassages 
    WHERE passage_order = s.Verse_ID
);

-- 3. WEB - Books
INSERT INTO dbo.SacredTextSections (corpus_id, name, standard_order, parent_section_id)
SELECT DISTINCT 
    @WEB_CorpusID,
    Book_Name,
    Book_Number,
    NULL
FROM dbo.web s
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.SacredTextSections 
    WHERE corpus_id = @WEB_CorpusID AND name = s.Book_Name
);

-- 4. WEB - Verses
INSERT INTO dbo.SacredTextPassages (section_id, passage_order, reference_label, text_content)
SELECT 
    sec.id,
    s.Verse_ID,
    CONCAT(s.Book_Name, ' ', s.Chapter, ':', s.Verse),
    s.Text
FROM dbo.web s
INNER JOIN dbo.SacredTextSections sec 
    ON sec.corpus_id = @WEB_CorpusID AND sec.name = s.Book_Name
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.SacredTextPassages 
    WHERE passage_order = s.Verse_ID
);

PRINT '✅ Books and Verses loaded for KJV with Strong''s and WEB';
GO