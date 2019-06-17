SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CustomClients]
(
	[ClientId] [int] NOT NULL,
	[CreatedBy] [dbo].[type_CurrentUser] NOT NULL,
	[CreatedDate] [dbo].[type_CurrentDatetime] NOT NULL,
	[ModifiedBy] [dbo].[type_CurrentUser] NOT NULL,
	[ModifiedDate] [dbo].[type_CurrentDatetime] NOT NULL,
	[RecordDeleted] [dbo].[type_YOrN] NULL,
	[DeletedBy] [dbo].[type_UserId] NULL,
	[DeletedDate] [datetime] NULL,
	[AccompaniedByChild] [dbo].[type_YOrN] NULL,
	[ChildName1] [varchar](250) NULL,
	[ChildDOB1] [datetime] NULL,
	[MoveInDate1] [datetime] NULL,
	[MoveOutDate1] [datetime] NULL,
	[ReasonForLeaving1] [varchar](250) NULL,
	[ChildName2] [varchar](250) NULL,
	[ChildDOB2] [datetime] NULL,
	[MoveInDate2] [datetime] NULL,
	[MoveOutDate2] [datetime] NULL,
	[ReasonForLeaving2] [varchar](250) NULL,
	[ChildName3] [varchar](250) NULL,
	[ChildDOB3] [varchar](250) NULL,
	[MoveInDate3] [datetime] NULL,
	[MoveOutDate3] [datetime] NULL,
	[ReasonForLeaving3] [varchar](250) NULL,
	[CurrentlyEnrolledInEducation] [dbo].[type_YOrN] NULL,
	[NameOfSchool] [varchar](250) NULL,
	[TCUEntryDate] [datetime] NULL,
	[TCUScore] [varchar](250) NULL,
	[NinetyDayScoreDate] [datetime] NULL,
	[NinetyDayScore] [varchar](250) NULL,
	[DischargeScoreDate] [datetime] NULL,
	[DischargeScore] [varchar](250) NULL,
	[AIPDateOfIncarceration] [datetime] NULL,
	[AIPPotentialReleaseDate] [datetime] NULL,
	[AIPActualReleaseDate] [datetime] NULL,
	[AIPTransLeaveDate] [datetime] NULL,
	[AIPPostPrisonSupervisionEndDate] [datetime] NULL,
	[ChildMedicaidId1] [int] NULL,
	[ChildMedicaidId2] [int] NULL,
	[ChildMedicaidId3] [int] NULL,
	[FoodStampsAdmissionDate] [date] NULL,
	[FoodStampsSubmittedDate] [date] NULL,
	[FoodStampsApprovalDate] [date] NULL,
	[FoodStampsClientLeaveDate] [date] NULL,
	[FoodStampsClientLeaveTime] [datetime] NULL,
	[Legal] [dbo].[type_GlobalCode] NULL,
	[SIDNumber] [varchar](30) NULL,
	[ODLOINumber] [varchar](30) NULL,
	[EducationLevel] [dbo].[type_GlobalCode] NULL,
	[ForensicTreatment] [dbo].[type_GlobalCode] NULL,
	[MilitaryService] [dbo].[type_GlobalCode] NULL,
	[JusticeSystemInvolvement] [dbo].[type_GlobalCode] NULL,
	[NumberOfArrestsLast30Days] [int] NULL,
	[AdvanceDirective] [dbo].[type_GlobalCode] NULL,
	[TobaccoUse] [dbo].[type_GlobalCode] NULL,
	[AgeOfFirstTobaccoUse] [int] NULL,
	[TitleXXNo] [varchar](50) NULL,
	[SamhisId] [varchar](50) NULL,
	[InterpreterNeeded] [dbo].[type_GlobalCode] NULL,
	[AIPSIDNumber] [varchar](30) NULL,
	[MotherMaidenName] [varchar](50) NULL,
	[JailDiversionStatus] [dbo].[type_GlobalCode] NULL,
	[Race] [varchar](30) NULL,
	[Ethnicity] [varchar](30) NULL,
	[MaritalStatus] [varchar](30) NULL,
	[EmploymentStatus] [varchar](30) NULL,
	[EmploymentStartDate] [date] NULL,
	[EmploymentEndDate] [date] NULL,
	[WellVisitLast12Months] [dbo].[type_YOrN] NULL,
	[WellVisitLastDate] [datetime] NULL,
	[WellVisitReferralDate] [datetime] NULL,
	[PrimaryPhysician] [dbo].[type_GlobalCode] NULL,
	[InsuranceType] [dbo].[type_GlobalCode] NULL,
	PRIMARY KEY CLUSTERED 
	(
		[ClientId] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO