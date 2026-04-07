USE AppologeticsCrucible;
GO

-- Clear any existing categories first (safe to re-run)
DELETE FROM dbo.Categories;
GO

-- Insert all RHS panel categories with proper weights
INSERT INTO dbo.Categories 
    (internal_name, display_name, data_type, applicable_entity, domain_weight, relevance_weight, is_active)
VALUES
    ('passage_context',         'Passage Context',          'TEXT',   'VERSE',  0.3,  80, 1),
    ('exegetic_strength',       'Exegetic Strength',        'ENUM',   'NODE',   0.5, 100, 1),
    ('citation',                'Citation',                 'REF',    'NODE',   0.2,  90, 1),
    ('related_topics',          'Related Topics to Proof',  'JSON',   'PROOF',  0.2,  70, 1),
    ('early_church_commentary', 'Early Church Commentary',  'TEXT',   'NODE',   0.4,  85, 1),
    ('earliest_manuscripts',    'Earliest Manuscripts',     'TEXT',   'VERSE',  0.3,  75, 1),
    ('historical_framework',    'Historical Framework',     'TEXT',   'NODE',   0.2,  65, 1),
    ('geographic_relevance',    'Geographic Relevance',     'TEXT',   'VERSE',  0.1,  50, 1),
    ('design_significance',     'Design Significance',      'TEXT',   'VERSE',  0.2,  60, 1),
    ('contemporary_figures',    'Contemporary Figures',     'TEXT',   'NODE',   0.2,  55, 1),
    ('political_government',    'Political/Government',     'TEXT',   'NODE',   0.1,  45, 1),
    -- New claim-type categories we discussed
    ('spiritual_meaning',       'Spiritual Component',      'TEXT',   'VERSE',  0.35, 80, 1),
    ('historical_lineage',      'Lineage / Genealogy',      'TEXT',   'VERSE',  0.25, 70, 1),
    ('idiom_expression',        'Idiomatic Expression',     'TEXT',   'VERSE',  0.30, 75, 1),
    ('symbolic_design',         'Symbolic / Typological',   'TEXT',   'VERSE',  0.25, 65, 1);
GO

PRINT '✅ Categories table populated (15 RHS panel items ready)';
GO