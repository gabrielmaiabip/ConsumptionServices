USE [ConsumptionDB_Dev]
GO

/****** Object:  Table [dbo].[BatchCorrelation]    Script Date: 9/8/2026 5:08:57 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[BatchCorrelation](
	[BatchCorrelationId] [int] IDENTITY(1,1) NOT NULL,
	[ProductionOrderId] [int] NULL,
	[BatchHandle] [nvarchar](120) NULL,
	[BatchName] [nvarchar](120) NULL,
	[EntryId] [nvarchar](120) NULL,
	[EquipmentId] [nvarchar](120) NULL,
	[OrderName] [nvarchar](120) NULL,
 CONSTRAINT [PK_BatchCorrelation] PRIMARY KEY CLUSTERED 
(
	[BatchCorrelationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[BatchCorrelation]  WITH CHECK ADD  CONSTRAINT [FK_BatchCorrelation_ProductionOrder] FOREIGN KEY([ProductionOrderId])
REFERENCES [dbo].[ProductionOrder] ([ProductionOrderId])
GO

ALTER TABLE [dbo].[BatchCorrelation] CHECK CONSTRAINT [FK_BatchCorrelation_ProductionOrder]
GO


USE [ConsumptionDB_Dev]
GO

/****** Object:  Table [dbo].[ConsumptionBatchMovement]    Script Date: 9/8/2026 5:09:06 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ConsumptionBatchMovement](
	[ConsumptionBatchMovementId] [int] IDENTITY(1,1) NOT NULL,
	[BatchCorrelationId] [int] NOT NULL,
	[ProductionOrderId] [int] NULL,
	[NotificationId] [nvarchar](120) NULL,
	[NotificationType] [nvarchar](80) NULL,
	[MessageIdempotencyKey] [nvarchar](200) NOT NULL,
	[MaterialId] [nvarchar](120) NOT NULL,
	[MaterialLotId] [nvarchar](120) NULL,
	[Quantity] [decimal](18, 6) NOT NULL,
	[Uom] [nvarchar](20) NULL,
	[RopContId] [nvarchar](40) NULL,
	[ActivationCounter] [int] NOT NULL,
	[EventTime] [datetime] NOT NULL,
	[SentToSap] [bit] NOT NULL,
	[SentAt] [datetime] NULL,
	[Discarded] [bit] NOT NULL,
 CONSTRAINT [PK_ConsumptionBatchMovement] PRIMARY KEY CLUSTERED 
(
	[ConsumptionBatchMovementId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ConsumptionBatchMovement] ADD  DEFAULT ((1)) FOR [ActivationCounter]
GO

ALTER TABLE [dbo].[ConsumptionBatchMovement] ADD  DEFAULT ((0)) FOR [SentToSap]
GO

ALTER TABLE [dbo].[ConsumptionBatchMovement] ADD  DEFAULT ((0)) FOR [Discarded]
GO

ALTER TABLE [dbo].[ConsumptionBatchMovement]  WITH CHECK ADD  CONSTRAINT [FK_ConsumptionBatchMovement_BatchCorrelation] FOREIGN KEY([BatchCorrelationId])
REFERENCES [dbo].[BatchCorrelation] ([BatchCorrelationId])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[ConsumptionBatchMovement] CHECK CONSTRAINT [FK_ConsumptionBatchMovement_BatchCorrelation]
GO

ALTER TABLE [dbo].[ConsumptionBatchMovement]  WITH CHECK ADD  CONSTRAINT [FK_ConsumptionBatchMovement_ProductionOrder] FOREIGN KEY([ProductionOrderId])
REFERENCES [dbo].[ProductionOrder] ([ProductionOrderId])
GO

ALTER TABLE [dbo].[ConsumptionBatchMovement] CHECK CONSTRAINT [FK_ConsumptionBatchMovement_ProductionOrder]
GO

USE [ConsumptionDB_Dev]
GO

/****** Object:  Table [dbo].[MaterialStorageLocation]    Script Date: 9/8/2026 5:09:34 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MaterialStorageLocation](
	[MaterialId] [nvarchar](120) NOT NULL,
	[StorageLocation] [nvarchar](120) NOT NULL,
 CONSTRAINT [PK_MaterialStorageLocation] PRIMARY KEY CLUSTERED 
(
	[MaterialId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

USE [ConsumptionDB_Dev]
GO

/****** Object:  Table [dbo].[MessageBacklog]    Script Date: 9/8/2026 5:09:43 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MessageBacklog](
	[MessageBacklogId] [int] IDENTITY(1,1) NOT NULL,
	[BatchCorrelationId] [int] NOT NULL,
	[ProductionOrderId] [int] NULL,
	[RopContId] [nvarchar](40) NULL,
	[ActivationCounter] [int] NOT NULL,
	[BacklogKey] [nvarchar](64) NOT NULL,
	[PayloadXml] [nvarchar](max) NOT NULL,
	[ItemCount] [int] NOT NULL,
	[Status] [nvarchar](20) NULL,
	[AttemptCount] [int] NOT NULL,
	[SentAt] [datetime] NULL,
	[ErrorMessage] [nvarchar](1000) NULL,
 CONSTRAINT [PK_MessageBacklog] PRIMARY KEY CLUSTERED 
(
	[MessageBacklogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[MessageBacklog] ADD  DEFAULT ((1)) FOR [ActivationCounter]
GO

ALTER TABLE [dbo].[MessageBacklog] ADD  DEFAULT ((0)) FOR [ItemCount]
GO

ALTER TABLE [dbo].[MessageBacklog] ADD  DEFAULT ((0)) FOR [AttemptCount]
GO

ALTER TABLE [dbo].[MessageBacklog]  WITH CHECK ADD  CONSTRAINT [FK_MessageBacklog_BatchCorrelation] FOREIGN KEY([BatchCorrelationId])
REFERENCES [dbo].[BatchCorrelation] ([BatchCorrelationId])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[MessageBacklog] CHECK CONSTRAINT [FK_MessageBacklog_BatchCorrelation]
GO

ALTER TABLE [dbo].[MessageBacklog]  WITH CHECK ADD  CONSTRAINT [FK_MessageBacklog_ProductionOrder] FOREIGN KEY([ProductionOrderId])
REFERENCES [dbo].[ProductionOrder] ([ProductionOrderId])
GO

ALTER TABLE [dbo].[MessageBacklog] CHECK CONSTRAINT [FK_MessageBacklog_ProductionOrder]
GO

USE [ConsumptionDB_Dev]
GO

/****** Object:  Table [dbo].[PlannedMaterial]    Script Date: 9/8/2026 5:09:57 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[PlannedMaterial](
	[PlannedMaterialId] [int] IDENTITY(1,1) NOT NULL,
	[ProductionOrderId] [int] NOT NULL,
	[MaterialId] [nvarchar](120) NOT NULL,
	[MaterialDescription] [nvarchar](200) NULL,
	[PlannedQuantity] [decimal](18, 6) NOT NULL,
	[Uom] [nvarchar](20) NULL,
	[BomItem] [nvarchar](40) NULL,
 CONSTRAINT [PK_PlannedMaterial] PRIMARY KEY CLUSTERED 
(
	[PlannedMaterialId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[PlannedMaterial] ADD  DEFAULT ((0)) FOR [PlannedQuantity]
GO

ALTER TABLE [dbo].[PlannedMaterial]  WITH CHECK ADD  CONSTRAINT [FK_PlannedMaterial_ProductionOrder] FOREIGN KEY([ProductionOrderId])
REFERENCES [dbo].[ProductionOrder] ([ProductionOrderId])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[PlannedMaterial] CHECK CONSTRAINT [FK_PlannedMaterial_ProductionOrder]
GO

USE [ConsumptionDB_Dev]
GO

/****** Object:  Table [dbo].[ProcessedNotification]    Script Date: 9/8/2026 5:10:06 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ProcessedNotification](
	[ProcessedNotificationId] [int] IDENTITY(1,1) NOT NULL,
	[SourceSystem] [nvarchar](80) NULL,
	[NotificationId] [nvarchar](120) NULL,
	[NotificationType] [nvarchar](80) NULL,
	[MessageIdempotencyKey] [nvarchar](200) NOT NULL,
	[BatchHandle] [nvarchar](120) NULL,
	[OrderName] [nvarchar](120) NULL,
	[RopContId] [nvarchar](40) NULL,
	[ProcessingStatus] [nvarchar](20) NULL,
	[ProcessedAt] [datetime] NOT NULL,
 CONSTRAINT [PK_ProcessedNotification] PRIMARY KEY CLUSTERED 
(
	[ProcessedNotificationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ProcessedNotification] ADD  DEFAULT (getutcdate()) FOR [ProcessedAt]
GO

USE [ConsumptionDB_Dev]
GO

/****** Object:  Table [dbo].[ProductionOrder]    Script Date: 9/8/2026 5:10:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ProductionOrder](
	[ProductionOrderId] [int] IDENTITY(1,1) NOT NULL,
	[OrderName] [nvarchar](120) NOT NULL,
	[OrderCategoryName] [nvarchar](120) NULL,
	[BatchName] [nvarchar](120) NULL,
	[BatchHandle] [nvarchar](120) NULL,
	[RecipeProcedureName] [nvarchar](200) NULL,
	[PlannedQuantity] [decimal](18, 6) NOT NULL,
	[PlannedUom] [nvarchar](20) NULL,
	[CurrentState] [nvarchar](80) NULL,
	[CreatedAt] [datetime] NOT NULL,
 CONSTRAINT [PK_ProductionOrder] PRIMARY KEY CLUSTERED 
(
	[ProductionOrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ProductionOrder] ADD  DEFAULT ((0)) FOR [PlannedQuantity]
GO

ALTER TABLE [dbo].[ProductionOrder] ADD  DEFAULT (getutcdate()) FOR [CreatedAt]
GO





