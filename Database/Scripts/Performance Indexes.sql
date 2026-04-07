USE AppologeticsCrucible;
GO

-- =============================================
-- Step 3: Performance Indexes (Fixed for Standard/Developer Edition)
-- =============================================

-- Vector search indexes
CREATE NONCLUSTERED INDEX IX_SacredTextPassages_Vector 
    ON dbo.SacredTextPassages(vector_embedding);

CREATE NONCLUSTERED INDEX IX_Nodes_Vector 
    ON dbo.Nodes(vector_embedding);

CREATE NONCLUSTERED INDEX IX_Proofs_Vector 
    ON dbo.Proofs(vector_embedding);

-- High-use FK and lookup indexes
CREATE INDEX IX_SacredTextSections_CorpusID 
    ON dbo.SacredTextSections(corpus_id);

CREATE INDEX IX_SacredTextPassages_SectionID 
    ON dbo.SacredTextPassages(section_id);

CREATE INDEX IX_SacredTextPassages_PassageOrder 
    ON dbo.SacredTextPassages(passage_order);

CREATE INDEX IX_SacredTextInterlinear_PassageID 
    ON dbo.SacredTextInterlinear(passage_id);

CREATE INDEX IX_ProofNodes_ProofID 
    ON dbo.ProofNodes(proof_id);

CREATE INDEX IX_ProofNodes_NodeID 
    ON dbo.ProofNodes(node_id);

CREATE INDEX IX_EntityCategoryValues_Entity 
    ON dbo.EntityCategoryValues(entity_type, entity_id);

CREATE INDEX IX_ProofStanceLinks_ProofID 
    ON dbo.ProofStanceLinks(proof_id);

CREATE INDEX IX_ProofStanceLinks_StanceID 
    ON dbo.ProofStanceLinks(stance_id);

PRINT '✅ Step 3 Complete: Performance indexes added (Standard Edition compatible)';
GO