USE [AppologeticsCrucible]
GO
/****** Object:  Table [dbo].[Categories]    Script Date: 4/8/2026 8:30:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[internal_name] [nvarchar](100) NOT NULL,
	[display_name] [nvarchar](100) NOT NULL,
	[data_type] [varchar](20) NOT NULL,
	[applicable_entity] [varchar](20) NOT NULL,
	[conditional_rule] [nvarchar](1000) NULL,
	[domain_weight] [decimal](3, 1) NOT NULL,
	[relevance_weight] [tinyint] NOT NULL,
	[is_active] [bit] NOT NULL,
	[created_at] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[internal_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CrossReferences]    Script Date: 4/8/2026 8:30:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CrossReferences](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[primary_passage_id] [bigint] NOT NULL,
	[related_passage_id] [bigint] NOT NULL,
	[reference_type] [varchar](20) NOT NULL,
	[strength] [tinyint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EntityCategoryValues]    Script Date: 4/8/2026 8:30:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EntityCategoryValues](
	[entity_type] [nvarchar](20) NOT NULL,
	[entity_id] [bigint] NOT NULL,
	[category_id] [bigint] NOT NULL,
	[value_text] [nvarchar](max) NULL,
	[value_json] [nvarchar](max) NULL,
	[value_ref_table] [nvarchar](100) NULL,
	[value_ref_id] [bigint] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ExegeticScoreRubrics]    Script Date: 4/8/2026 8:30:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExegeticScoreRubrics](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[score_range_start] [tinyint] NOT NULL,
	[score_range_end] [tinyint] NOT NULL,
	[description] [nvarchar](200) NOT NULL,
	[criteria] [nvarchar](max) NOT NULL,
	[created_at] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IngestionBatches]    Script Date: 4/8/2026 8:30:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IngestionBatches](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[source_name] [nvarchar](500) NOT NULL,
	[source_type] [varchar](50) NOT NULL,
	[uploaded_by] [nvarchar](200) NOT NULL,
	[uploaded_at] [datetime2](7) NOT NULL,
	[status] [varchar](20) NOT NULL,
	[record_count] [int] NULL,
	[blurb_summary] [nvarchar](max) NULL,
	[raw_file_path] [nvarchar](1000) NULL,
	[created_at] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IngestionPreview]    Script Date: 4/8/2026 8:30:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IngestionPreview](
	[PreviewID] [int] IDENTITY(1,1) NOT NULL,
	[IngestionBatchID] [int] NOT NULL,
	[SourceID] [int] NULL,
	[ChunkText] [nvarchar](4000) NULL,
	[SuggestedNodeID] [int] NULL,
	[SimilarityScoreNode] [float] NULL,
	[SuggestedPassageID] [int] NULL,
	[SuggestedStrength] [varchar](20) NULL,
	[AssociationType] [varchar](30) NULL,
	[Blurb] [nvarchar](800) NULL,
	[SourceReference] [nvarchar](500) NULL,
	[CreatedAt] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[PreviewID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[kjv]    Script Date: 4/8/2026 8:30:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[kjv](
	[Verse_ID] [smallint] NOT NULL,
	[Book_Name] [nvarchar](50) NOT NULL,
	[Book_Number] [tinyint] NOT NULL,
	[Chapter] [tinyint] NOT NULL,
	[Verse] [tinyint] NOT NULL,
	[Text] [varchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[kjv_strongs]    Script Date: 4/8/2026 8:30:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[kjv_strongs](
	[Verse_ID] [smallint] NOT NULL,
	[Book_Name] [nvarchar](50) NOT NULL,
	[Book_Number] [tinyint] NOT NULL,
	[Chapter] [tinyint] NOT NULL,
	[Verse] [tinyint] NOT NULL,
	[Text] [varchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NodeAssociations]    Script Date: 4/8/2026 8:30:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NodeAssociations](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[new_node_id] [bigint] NOT NULL,
	[existing_node_id] [bigint] NOT NULL,
	[association_type] [varchar](20) NOT NULL,
	[similarity_score] [decimal](5, 4) NULL,
	[added_by] [nvarchar](200) NOT NULL,
	[added_at] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NodeRatings]    Script Date: 4/8/2026 8:30:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NodeRatings](
	[node_id] [bigint] NOT NULL,
	[rated_by] [nvarchar](200) NOT NULL,
	[rating_strength] [varchar](20) NOT NULL,
	[rating_score] [tinyint] NOT NULL,
	[feedback_note] [nvarchar](1000) NULL,
	[rated_at] [datetime2](7) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NodeRevisions]    Script Date: 4/8/2026 8:30:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NodeRevisions](
	[original_node_id] [bigint] NOT NULL,
	[new_node_id] [bigint] NOT NULL,
	[revision_type] [varchar](20) NOT NULL,
	[reason_note] [nvarchar](1000) NULL,
	[created_at] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_NodeRevisions] PRIMARY KEY CLUSTERED 
(
	[original_node_id] ASC,
	[new_node_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Nodes]    Script Date: 4/8/2026 8:30:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Nodes](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[content] [nvarchar](max) NOT NULL,
	[exegetic_strength] [varchar](20) NOT NULL,
	[exegetic_score] [tinyint] NOT NULL,
	[inference_steps] [tinyint] NOT NULL,
	[strength_rationale] [nvarchar](1000) NULL,
	[created_at] [datetime2](7) NOT NULL,
	[vector_embedding] [varbinary](8000) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NodeSources]    Script Date: 4/8/2026 8:30:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NodeSources](
	[node_id] [bigint] NOT NULL,
	[source_id] [bigint] NULL,
	[credited_to] [nvarchar](200) NOT NULL,
	[contribution_note] [nvarchar](500) NULL,
	[added_at] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_NodeSources] PRIMARY KEY CLUSTERED 
(
	[node_id] ASC,
	[credited_to] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProofComparisons]    Script Date: 4/8/2026 8:30:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProofComparisons](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[proof1_id] [bigint] NOT NULL,
	[proof2_id] [bigint] NOT NULL,
	[score_delta] [decimal](10, 2) NULL,
	[shared_cross_refs] [int] NULL,
	[differing_domains] [int] NULL,
	[created_at] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProofNodes]    Script Date: 4/8/2026 8:30:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProofNodes](
	[proof_id] [bigint] NOT NULL,
	[node_id] [bigint] NOT NULL,
	[parent_node_id] [bigint] NULL,
	[relationship_type] [varchar](20) NOT NULL,
	[sort_order] [int] NOT NULL,
 CONSTRAINT [PK_ProofNodes] PRIMARY KEY CLUSTERED 
(
	[proof_id] ASC,
	[node_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Proofs]    Script Date: 4/8/2026 8:30:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Proofs](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[title] [nvarchar](500) NOT NULL,
	[central_question] [nvarchar](max) NULL,
	[conclusion] [nvarchar](max) NULL,
	[hermeneutic_overview] [nvarchar](max) NOT NULL,
	[disclaimers] [nvarchar](max) NOT NULL,
	[status] [varchar](20) NOT NULL,
	[created_at] [datetime2](7) NOT NULL,
	[vector_embedding] [varbinary](8000) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProofStanceLinks]    Script Date: 4/8/2026 8:30:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProofStanceLinks](
	[proof_id] [bigint] NOT NULL,
	[stance_id] [bigint] NOT NULL,
 CONSTRAINT [PK_ProofStanceLinks] PRIMARY KEY CLUSTERED 
(
	[proof_id] ASC,
	[stance_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SacredTextCorpora]    Script Date: 4/8/2026 8:30:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SacredTextCorpora](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[abbreviation] [nvarchar](50) NULL,
	[language] [nvarchar](50) NULL,
	[tradition_group] [nvarchar](100) NULL,
	[is_gold_standard] [bit] NOT NULL,
	[authority_tier] [tinyint] NOT NULL,
	[vector_embedding] [varbinary](8000) NULL,
	[source_url] [nvarchar](500) NULL,
	[license_note] [nvarchar](500) NULL,
	[created_at] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SacredTextInterlinear]    Script Date: 4/8/2026 8:30:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SacredTextInterlinear](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[passage_id] [bigint] NOT NULL,
	[word_position] [smallint] NOT NULL,
	[original_text] [nvarchar](200) NULL,
	[transliteration] [nvarchar](200) NULL,
	[lemma] [nvarchar](100) NULL,
	[morphology_tags] [nvarchar](200) NULL,
	[gloss] [nvarchar](200) NULL,
	[strongs_number] [int] NULL,
	[created_at] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SacredTextPassages]    Script Date: 4/8/2026 8:30:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SacredTextPassages](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[section_id] [bigint] NOT NULL,
	[passage_order] [bigint] NOT NULL,
	[reference_label] [nvarchar](50) NULL,
	[text_content] [nvarchar](max) NOT NULL,
	[vector_embedding] [varbinary](8000) NULL,
	[created_at] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[passage_order] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SacredTextSections]    Script Date: 4/8/2026 8:30:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SacredTextSections](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[corpus_id] [bigint] NOT NULL,
	[name] [nvarchar](200) NOT NULL,
	[standard_order] [int] NOT NULL,
	[parent_section_id] [bigint] NULL,
	[created_at] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sources]    Script Date: 4/8/2026 8:30:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sources](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[source_type] [varchar](50) NOT NULL,
	[title] [nvarchar](500) NOT NULL,
	[author] [nvarchar](200) NULL,
	[publication_year] [smallint] NULL,
	[tradition_group] [nvarchar](100) NULL,
	[authority_tier] [tinyint] NOT NULL,
	[source_url] [nvarchar](500) NULL,
	[license_note] [nvarchar](500) NULL,
	[created_at] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TheologicalStances]    Script Date: 4/8/2026 8:30:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TheologicalStances](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[internal_name] [nvarchar](100) NOT NULL,
	[display_name] [nvarchar](200) NOT NULL,
	[tradition_group] [nvarchar](100) NULL,
	[created_at] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[internal_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[web]    Script Date: 4/8/2026 8:30:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[web](
	[Verse_ID] [smallint] NOT NULL,
	[Book_Name] [nvarchar](50) NOT NULL,
	[Book_Number] [tinyint] NOT NULL,
	[Chapter] [tinyint] NOT NULL,
	[Verse] [tinyint] NOT NULL,
	[Text] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Categories] ADD  DEFAULT ((0.1)) FOR [domain_weight]
GO
ALTER TABLE [dbo].[Categories] ADD  DEFAULT ((50)) FOR [relevance_weight]
GO
ALTER TABLE [dbo].[Categories] ADD  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[Categories] ADD  DEFAULT (sysutcdatetime()) FOR [created_at]
GO
ALTER TABLE [dbo].[ExegeticScoreRubrics] ADD  DEFAULT (sysutcdatetime()) FOR [created_at]
GO
ALTER TABLE [dbo].[IngestionBatches] ADD  DEFAULT (sysutcdatetime()) FOR [uploaded_at]
GO
ALTER TABLE [dbo].[IngestionBatches] ADD  DEFAULT ('COMMITTED') FOR [status]
GO
ALTER TABLE [dbo].[IngestionBatches] ADD  DEFAULT (sysutcdatetime()) FOR [created_at]
GO
ALTER TABLE [dbo].[NodeAssociations] ADD  DEFAULT (sysutcdatetime()) FOR [added_at]
GO
ALTER TABLE [dbo].[NodeRatings] ADD  DEFAULT (sysutcdatetime()) FOR [rated_at]
GO
ALTER TABLE [dbo].[NodeRevisions] ADD  DEFAULT (sysutcdatetime()) FOR [created_at]
GO
ALTER TABLE [dbo].[Nodes] ADD  DEFAULT ((50)) FOR [exegetic_score]
GO
ALTER TABLE [dbo].[Nodes] ADD  DEFAULT ((0)) FOR [inference_steps]
GO
ALTER TABLE [dbo].[Nodes] ADD  DEFAULT (sysutcdatetime()) FOR [created_at]
GO
ALTER TABLE [dbo].[NodeSources] ADD  DEFAULT (sysutcdatetime()) FOR [added_at]
GO
ALTER TABLE [dbo].[ProofComparisons] ADD  DEFAULT (sysutcdatetime()) FOR [created_at]
GO
ALTER TABLE [dbo].[Proofs] ADD  DEFAULT ('DRAFT') FOR [status]
GO
ALTER TABLE [dbo].[Proofs] ADD  DEFAULT (sysutcdatetime()) FOR [created_at]
GO
ALTER TABLE [dbo].[SacredTextCorpora] ADD  DEFAULT ((0)) FOR [is_gold_standard]
GO
ALTER TABLE [dbo].[SacredTextCorpora] ADD  DEFAULT ((1)) FOR [authority_tier]
GO
ALTER TABLE [dbo].[SacredTextCorpora] ADD  DEFAULT (sysutcdatetime()) FOR [created_at]
GO
ALTER TABLE [dbo].[SacredTextInterlinear] ADD  DEFAULT (sysutcdatetime()) FOR [created_at]
GO
ALTER TABLE [dbo].[SacredTextPassages] ADD  DEFAULT (sysutcdatetime()) FOR [created_at]
GO
ALTER TABLE [dbo].[SacredTextSections] ADD  DEFAULT (sysutcdatetime()) FOR [created_at]
GO
ALTER TABLE [dbo].[Sources] ADD  DEFAULT ((4)) FOR [authority_tier]
GO
ALTER TABLE [dbo].[Sources] ADD  DEFAULT (sysutcdatetime()) FOR [created_at]
GO
ALTER TABLE [dbo].[TheologicalStances] ADD  DEFAULT (sysutcdatetime()) FOR [created_at]
GO
ALTER TABLE [dbo].[CrossReferences]  WITH CHECK ADD  CONSTRAINT [FK_CrossReferences_Primary] FOREIGN KEY([primary_passage_id])
REFERENCES [dbo].[SacredTextPassages] ([id])
GO
ALTER TABLE [dbo].[CrossReferences] CHECK CONSTRAINT [FK_CrossReferences_Primary]
GO
ALTER TABLE [dbo].[CrossReferences]  WITH CHECK ADD  CONSTRAINT [FK_CrossReferences_Related] FOREIGN KEY([related_passage_id])
REFERENCES [dbo].[SacredTextPassages] ([id])
GO
ALTER TABLE [dbo].[CrossReferences] CHECK CONSTRAINT [FK_CrossReferences_Related]
GO
ALTER TABLE [dbo].[EntityCategoryValues]  WITH CHECK ADD  CONSTRAINT [FK_EntityCategoryValues_Category] FOREIGN KEY([category_id])
REFERENCES [dbo].[Categories] ([id])
GO
ALTER TABLE [dbo].[EntityCategoryValues] CHECK CONSTRAINT [FK_EntityCategoryValues_Category]
GO
ALTER TABLE [dbo].[NodeAssociations]  WITH CHECK ADD  CONSTRAINT [FK_NodeAssociations_Existing] FOREIGN KEY([existing_node_id])
REFERENCES [dbo].[Nodes] ([id])
GO
ALTER TABLE [dbo].[NodeAssociations] CHECK CONSTRAINT [FK_NodeAssociations_Existing]
GO
ALTER TABLE [dbo].[NodeAssociations]  WITH CHECK ADD  CONSTRAINT [FK_NodeAssociations_New] FOREIGN KEY([new_node_id])
REFERENCES [dbo].[Nodes] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[NodeAssociations] CHECK CONSTRAINT [FK_NodeAssociations_New]
GO
ALTER TABLE [dbo].[NodeRatings]  WITH CHECK ADD  CONSTRAINT [FK_NodeRatings_Node] FOREIGN KEY([node_id])
REFERENCES [dbo].[Nodes] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[NodeRatings] CHECK CONSTRAINT [FK_NodeRatings_Node]
GO
ALTER TABLE [dbo].[NodeRevisions]  WITH CHECK ADD  CONSTRAINT [FK_NodeRevisions_New] FOREIGN KEY([new_node_id])
REFERENCES [dbo].[Nodes] ([id])
GO
ALTER TABLE [dbo].[NodeRevisions] CHECK CONSTRAINT [FK_NodeRevisions_New]
GO
ALTER TABLE [dbo].[NodeRevisions]  WITH CHECK ADD  CONSTRAINT [FK_NodeRevisions_Original] FOREIGN KEY([original_node_id])
REFERENCES [dbo].[Nodes] ([id])
GO
ALTER TABLE [dbo].[NodeRevisions] CHECK CONSTRAINT [FK_NodeRevisions_Original]
GO
ALTER TABLE [dbo].[NodeSources]  WITH CHECK ADD  CONSTRAINT [FK_NodeSources_Node] FOREIGN KEY([node_id])
REFERENCES [dbo].[Nodes] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[NodeSources] CHECK CONSTRAINT [FK_NodeSources_Node]
GO
ALTER TABLE [dbo].[NodeSources]  WITH CHECK ADD  CONSTRAINT [FK_NodeSources_Sources] FOREIGN KEY([source_id])
REFERENCES [dbo].[Sources] ([id])
GO
ALTER TABLE [dbo].[NodeSources] CHECK CONSTRAINT [FK_NodeSources_Sources]
GO
ALTER TABLE [dbo].[ProofComparisons]  WITH CHECK ADD  CONSTRAINT [FK_ProofComparisons_Proof1] FOREIGN KEY([proof1_id])
REFERENCES [dbo].[Proofs] ([id])
GO
ALTER TABLE [dbo].[ProofComparisons] CHECK CONSTRAINT [FK_ProofComparisons_Proof1]
GO
ALTER TABLE [dbo].[ProofComparisons]  WITH CHECK ADD  CONSTRAINT [FK_ProofComparisons_Proof2] FOREIGN KEY([proof2_id])
REFERENCES [dbo].[Proofs] ([id])
GO
ALTER TABLE [dbo].[ProofComparisons] CHECK CONSTRAINT [FK_ProofComparisons_Proof2]
GO
ALTER TABLE [dbo].[ProofNodes]  WITH CHECK ADD  CONSTRAINT [FK_ProofNodes_Node] FOREIGN KEY([node_id])
REFERENCES [dbo].[Nodes] ([id])
GO
ALTER TABLE [dbo].[ProofNodes] CHECK CONSTRAINT [FK_ProofNodes_Node]
GO
ALTER TABLE [dbo].[ProofNodes]  WITH CHECK ADD  CONSTRAINT [FK_ProofNodes_Parent] FOREIGN KEY([parent_node_id])
REFERENCES [dbo].[Nodes] ([id])
GO
ALTER TABLE [dbo].[ProofNodes] CHECK CONSTRAINT [FK_ProofNodes_Parent]
GO
ALTER TABLE [dbo].[ProofNodes]  WITH CHECK ADD  CONSTRAINT [FK_ProofNodes_Proof] FOREIGN KEY([proof_id])
REFERENCES [dbo].[Proofs] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProofNodes] CHECK CONSTRAINT [FK_ProofNodes_Proof]
GO
ALTER TABLE [dbo].[ProofStanceLinks]  WITH CHECK ADD  CONSTRAINT [FK_ProofStanceLinks_Proof] FOREIGN KEY([proof_id])
REFERENCES [dbo].[Proofs] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProofStanceLinks] CHECK CONSTRAINT [FK_ProofStanceLinks_Proof]
GO
ALTER TABLE [dbo].[ProofStanceLinks]  WITH CHECK ADD  CONSTRAINT [FK_ProofStanceLinks_Stance] FOREIGN KEY([stance_id])
REFERENCES [dbo].[TheologicalStances] ([id])
GO
ALTER TABLE [dbo].[ProofStanceLinks] CHECK CONSTRAINT [FK_ProofStanceLinks_Stance]
GO
ALTER TABLE [dbo].[SacredTextInterlinear]  WITH CHECK ADD  CONSTRAINT [FK_SacredTextInterlinear_Passage] FOREIGN KEY([passage_id])
REFERENCES [dbo].[SacredTextPassages] ([id])
GO
ALTER TABLE [dbo].[SacredTextInterlinear] CHECK CONSTRAINT [FK_SacredTextInterlinear_Passage]
GO
ALTER TABLE [dbo].[SacredTextPassages]  WITH CHECK ADD  CONSTRAINT [FK_SacredTextPassages_Section] FOREIGN KEY([section_id])
REFERENCES [dbo].[SacredTextSections] ([id])
GO
ALTER TABLE [dbo].[SacredTextPassages] CHECK CONSTRAINT [FK_SacredTextPassages_Section]
GO
ALTER TABLE [dbo].[SacredTextSections]  WITH CHECK ADD  CONSTRAINT [FK_SacredTextSections_Corpus] FOREIGN KEY([corpus_id])
REFERENCES [dbo].[SacredTextCorpora] ([id])
GO
ALTER TABLE [dbo].[SacredTextSections] CHECK CONSTRAINT [FK_SacredTextSections_Corpus]
GO
ALTER TABLE [dbo].[SacredTextSections]  WITH CHECK ADD  CONSTRAINT [FK_SacredTextSections_Parent] FOREIGN KEY([parent_section_id])
REFERENCES [dbo].[SacredTextSections] ([id])
GO
ALTER TABLE [dbo].[SacredTextSections] CHECK CONSTRAINT [FK_SacredTextSections_Parent]
GO
ALTER TABLE [dbo].[Categories]  WITH CHECK ADD  CONSTRAINT [CK_Categories_ApplicableEntity] CHECK  (([applicable_entity]='VERSE' OR [applicable_entity]='NODE' OR [applicable_entity]='PROOF'))
GO
ALTER TABLE [dbo].[Categories] CHECK CONSTRAINT [CK_Categories_ApplicableEntity]
GO
ALTER TABLE [dbo].[Categories]  WITH CHECK ADD  CONSTRAINT [CK_Categories_DataType] CHECK  (([data_type]='BOOLEAN' OR [data_type]='ENUM' OR [data_type]='REF' OR [data_type]='JSON' OR [data_type]='TEXT'))
GO
ALTER TABLE [dbo].[Categories] CHECK CONSTRAINT [CK_Categories_DataType]
GO
ALTER TABLE [dbo].[CrossReferences]  WITH CHECK ADD  CONSTRAINT [CK_CrossReferences_Type] CHECK  (([reference_type]='ALLUSION' OR [reference_type]='FULFILLMENT' OR [reference_type]='SAME_TOPIC' OR [reference_type]='PARALLEL'))
GO
ALTER TABLE [dbo].[CrossReferences] CHECK CONSTRAINT [CK_CrossReferences_Type]
GO
ALTER TABLE [dbo].[EntityCategoryValues]  WITH CHECK ADD  CONSTRAINT [CK_EntityCategoryValues_EntityType] CHECK  (([entity_type]='VERSE' OR [entity_type]='NODE' OR [entity_type]='PROOF'))
GO
ALTER TABLE [dbo].[EntityCategoryValues] CHECK CONSTRAINT [CK_EntityCategoryValues_EntityType]
GO
ALTER TABLE [dbo].[NodeAssociations]  WITH CHECK ADD  CONSTRAINT [CK_NodeAssociations_Type] CHECK  (([association_type]='SUPPORTS' OR [association_type]='REFUTES' OR [association_type]='SIMILAR' OR [association_type]='DUPLICATE'))
GO
ALTER TABLE [dbo].[NodeAssociations] CHECK CONSTRAINT [CK_NodeAssociations_Type]
GO
ALTER TABLE [dbo].[NodeRatings]  WITH CHECK ADD  CONSTRAINT [CK_NodeRatings_Score] CHECK  (([rating_score]>=(0) AND [rating_score]<=(100)))
GO
ALTER TABLE [dbo].[NodeRatings] CHECK CONSTRAINT [CK_NodeRatings_Score]
GO
ALTER TABLE [dbo].[NodeRatings]  WITH CHECK ADD  CONSTRAINT [CK_NodeRatings_Strength] CHECK  (([rating_strength]='WEAK' OR [rating_strength]='INFERENTIAL' OR [rating_strength]='STRONG' OR [rating_strength]='DIRECT'))
GO
ALTER TABLE [dbo].[NodeRatings] CHECK CONSTRAINT [CK_NodeRatings_Strength]
GO
ALTER TABLE [dbo].[NodeRevisions]  WITH CHECK ADD  CONSTRAINT [CK_NodeRevisions_Type] CHECK  (([revision_type]='REFUTES' OR [revision_type]='IMPROVES'))
GO
ALTER TABLE [dbo].[NodeRevisions] CHECK CONSTRAINT [CK_NodeRevisions_Type]
GO
ALTER TABLE [dbo].[Nodes]  WITH CHECK ADD  CONSTRAINT [CK_Nodes_ExegeticScore] CHECK  (([exegetic_score]>=(0) AND [exegetic_score]<=(100)))
GO
ALTER TABLE [dbo].[Nodes] CHECK CONSTRAINT [CK_Nodes_ExegeticScore]
GO
ALTER TABLE [dbo].[Nodes]  WITH CHECK ADD  CONSTRAINT [CK_Nodes_ExegeticStrength] CHECK  (([exegetic_strength]='WEAK' OR [exegetic_strength]='INFERENTIAL' OR [exegetic_strength]='STRONG' OR [exegetic_strength]='DIRECT'))
GO
ALTER TABLE [dbo].[Nodes] CHECK CONSTRAINT [CK_Nodes_ExegeticStrength]
GO
ALTER TABLE [dbo].[ProofNodes]  WITH CHECK ADD  CONSTRAINT [CK_ProofNodes_RelationshipType] CHECK  (([relationship_type]='IMPLIES' OR [relationship_type]='REFUTES' OR [relationship_type]='SUPPORTS'))
GO
ALTER TABLE [dbo].[ProofNodes] CHECK CONSTRAINT [CK_ProofNodes_RelationshipType]
GO
ALTER TABLE [dbo].[Proofs]  WITH CHECK ADD  CONSTRAINT [CK_Proofs_Status] CHECK  (([status]='ARCHIVED' OR [status]='PUBLISHED' OR [status]='DRAFT'))
GO
ALTER TABLE [dbo].[Proofs] CHECK CONSTRAINT [CK_Proofs_Status]
GO
