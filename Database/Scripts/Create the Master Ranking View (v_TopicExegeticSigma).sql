USE AppologeticsCrucible;
GO

IF OBJECT_ID('dbo.v_TopicExegeticSigma', 'V') IS NOT NULL
    DROP VIEW dbo.v_TopicExegeticSigma;
GO

CREATE VIEW dbo.v_TopicExegeticSigma
AS
SELECT 
    ts.display_name AS Stance,
    COUNT(DISTINCT p.id) AS Proofs,
    SUM(n.exegetic_score) AS Raw_Sigma,
    AVG(n.inference_steps) AS Avg_Inference_Steps,
    COUNT(DISTINCT ecv.category_id) AS Distinct_Domains,
    
    -- Weighted Σ = Raw Sum × Inference Penalty × Domain Bonus
    ROUND(
        SUM(n.exegetic_score) 
        * (1.0 / (1 + AVG(n.inference_steps)))                    -- Inference Penalty
        * (1 + SUM(c.domain_weight)),                             -- Domain Bonus
        2
    ) AS Weighted_Sigma

FROM dbo.TheologicalStances ts
INNER JOIN dbo.ProofStanceLinks psl ON psl.stance_id = ts.id
INNER JOIN dbo.Proofs p ON p.id = psl.proof_id AND p.status = 'PUBLISHED'
INNER JOIN dbo.ProofNodes pn ON pn.proof_id = p.id
INNER JOIN dbo.Nodes n ON n.id = pn.node_id
LEFT JOIN dbo.EntityCategoryValues ecv 
    ON ecv.entity_id = n.id 
   AND ecv.entity_type = 'NODE'
LEFT JOIN dbo.Categories c ON c.id = ecv.category_id AND c.is_active = 1

GROUP BY ts.display_name;
GO

PRINT '✅ Step 2 Complete: v_TopicExegeticSigma view created';
GO