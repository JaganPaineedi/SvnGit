/****** Object:  Table [CQMSolution].[StagingCQMData]    Script Date: 01-02-2018 11:50:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CQMSolution].[StagingCQMData]') AND type in (N'U'))
BEGIN
CREATE TABLE [CQMSolution].[StagingCQMData](
     StagingCQMDataBatchId int not null,
	[lngId] [varchar](255) NULL,
	[CLIENT_ID] [varchar](255) NULL,
	[REC_TYPE] [varchar](255) NULL,
	[SEC_TYPE] [varchar](255) NULL,
	[D001] [varchar](255) NULL,
	[D002] [varchar](255) NULL,
	[D003] [varchar](255) NULL,
	[D004] [varchar](255) NULL,
	[D005] [varchar](255) NULL,
	[D006] [varchar](255) NULL,
	[D007] [varchar](255) NULL,
	[D008] [varchar](255) NULL,
	[D009] [varchar](255) NULL,
	[D010] [varchar](255) NULL,
	[D011] [varchar](255) NULL,
	[D012] [varchar](255) NULL,
	[D013] [varchar](255) NULL,
	[D014] [varchar](255) NULL,
	[D015] [varchar](255) NULL,
	[D016] [varchar](255) NULL,
	[D017] [varchar](255) NULL,
	[D018] [varchar](255) NULL,
	[D019] [varchar](255) NULL,
	[D020] [varchar](255) NULL,
	[D021] [varchar](255) NULL,
	[D022] [varchar](255) NULL,
	[D023] [varchar](255) NULL,
	[D024] [varchar](255) NULL,
	[D025] [varchar](255) NULL,
	[D026] [varchar](255) NULL,
	[D027] [varchar](255) NULL,
	[D028] [varchar](255) NULL,
	[D029] [varchar](255) NULL,
	[D030] [varchar](255) NULL,
	[D031] [varchar](255) NULL,
	[D032] [varchar](255) NULL,
	[D033] [varchar](255) NULL,
	[D034] [varchar](255) NULL,
	[D035] [varchar](255) NULL,
	[D036] [varchar](255) NULL,
	[D037] [varchar](255) NULL,
	[D038] [varchar](255) NULL,
	[D039] [varchar](255) NULL,
	[D040] [varchar](255) NULL,
	[D041] [varchar](255) NULL,
	[D042] [varchar](255) NULL,
	[D043] [varchar](255) NULL,
	[D044] [varchar](255) NULL,
	[D045] [varchar](255) NULL,
	[D046] [varchar](255) NULL,
	[D047] [varchar](255) NULL,
	[D048] [varchar](255) NULL,
	[D049] [varchar](255) NULL,
	[D050] [varchar](255) NULL,
	[ValueSetOID] [varchar](255) NULL,
	[IDRoot] [varchar](255) NULL,
	[IDExtension] [varchar](255) NULL,
	[Account_Number] [varchar](100) NULL
) ON [PRIMARY]
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CQMSolution].[StagingCQMDataBatches]') AND type in (N'U'))
BEGIN
CREATE TABLE [CQMSolution].[StagingCQMDataBatches](
	StagingCQMDataBatchId int identity(1,1) primary key,
	[Type] varchar(255),  -- 'ep' or 'eh'
     ProviderNPI varchar(50),   -- this is whatever id is used to identify a physician in your system
     StartDate   datetime,      -- start date of the reporting period
     StopDate    datetime,      -- end date of the reporting period
     PracticeID  varchar(255),
	Processed bit not null,
	BatchCreatedDate datetime not null
) ON [PRIMARY]


END

IF NOT EXISTS (SELECT * FROM sys.objects o WHERE o.object_id = object_id(N'[CQMSolution].[FK_StagingCQMDataBatches_StagingCQMDataBatchId]') AND OBJECTPROPERTY(o.object_id, N'IsForeignKey') = 1)
begin
    alter table CQMSolution.StagingCQMData
    Add Constraint FK_StagingCQMDataBatches_StagingCQMDataBatchId
    Foreign Key (StagingCQMDataBatchId) References CQMSolution.StagingCQMDataBatches(StagingCQMDataBatchId)
end
GO