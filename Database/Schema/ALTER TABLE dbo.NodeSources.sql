ALTER TABLE dbo.NodeSources
    ADD source_id BIGINT NULL,
        CONSTRAINT FK_NodeSources_Sources 
            FOREIGN KEY (source_id) REFERENCES dbo.Sources(id);
GO