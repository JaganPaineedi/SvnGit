/*
Reason: optimize repeated calls to ssp_SCWebDashMyDocumentSelShowProc @StaffId=1348,@LoggedInStaffId=1348.
Improved performace from 3-4 seconds to <1 second
*/
IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE1_Documents' AND object_id = OBJECT_ID('[dbo].[Documents]'))
	DROP INDEX [XIE1_Documents] ON [dbo].[Documents];

CREATE NONCLUSTERED INDEX [XIE1_Documents] ON [dbo].[Documents]
(
	[ClientId] ASC
)
INCLUDE ( 	[RecordDeleted],
	[CurrentVersionStatus],
	[DocumentCodeId],
	[AuthorId],
	[ReviewerId]) ON [PRIMARY]


/* Services table has two non-clustered duplicate indexes [XIE4_Services] and [XIE7_Services] both on DateOfService. 
Only difference is [XIE7_Services] has a number of INCLUDED column while XIE4_Services only has DateOfService. 
removes [XIE7_Services] index and put in all the INCLUDED columns in [XIE4_Services]. */

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE7_Services' AND object_id = OBJECT_ID('[dbo].[Services]'))
	DROP INDEX [XIE7_Services] ON [dbo].[Services];

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE4_Services' AND object_id = OBJECT_ID('[dbo].[Services]'))
	DROP INDEX [XIE4_Services] ON [dbo].[Services];

CREATE NONCLUSTERED INDEX [XIE4_Services] ON [dbo].[Services]
(
	[DateOfService] ASC
)
INCLUDE ( 	[ClientId],
	[Status],
	[ClinicianId],
	[ProgramId],
	[LocationId],
	[ServiceId]) ON [PRIMARY];



/* Modified Index [XIE1_ClientCoverageHistory] and added in the INCLUDED COLUMNS part of the index - RecordDeleted, StartDate,EndDate and COBOrder so all queries to 
this table can use one index to get all the data they need */
IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE1_ClientCoverageHistory' AND object_id = OBJECT_ID('[dbo].[ClientCoverageHistory]'))
	DROP INDEX [XIE1_ClientCoverageHistory] ON [dbo].[ClientCoverageHistory];

CREATE NONCLUSTERED INDEX [XIE1_ClientCoverageHistory] ON [dbo].[ClientCoverageHistory]
(
	[ClientCoveragePlanId] ASC
)
INCLUDE ([RecordDeleted],
	[StartDate],
	[EndDate],
	[COBOrder]) ON [PRIMARY]



/* Created the following index on ClientEpisodes and ClientPrograms since most queries on this table always involves checking status and recorddeleted. */
IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE2_ClientEpisodes' AND object_id = OBJECT_ID('[dbo].[ClientEpisodes]'))
	DROP INDEX [XIE2_ClientEpisodes] ON [dbo].[ClientEpisodes]


CREATE NONCLUSTERED INDEX [XIE2_ClientEpisodes] ON [dbo].[ClientEpisodes]
(
	[Status] ASC
)
INCLUDE ([RecordDeleted]) ON [PRIMARY]
GO

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE4_ClientPrograms' AND object_id = OBJECT_ID('[dbo].[ClientPrograms]'))
	DROP INDEX [XIE4_ClientPrograms] ON [dbo].[ClientPrograms]

CREATE NONCLUSTERED INDEX [XIE4_ClientPrograms] ON [dbo].[ClientPrograms]
(
	[Status] ASC
)
INCLUDE ([RecordDeleted]) ON [PRIMARY]
GO


/* The following indexes was created based on running sp_BlitzIndex which shows cases where adding the below indexes can improve performance 
   on a large swath of queries */

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE1_Services' AND object_id = OBJECT_ID('[dbo].[Services]'))
	DROP INDEX [XIE1_Services] ON [dbo].[Services]
GO

/****** Object:  Index [XIE1_Services]    Script Date: 3/10/2017 1:16:17 PM ******/
CREATE NONCLUSTERED INDEX [XIE1_Services] ON [dbo].[Services]
(
	[ClientId] ASC
)
INCLUDE ( 	[RecordDeleted],
	[DateOfService]) ON [PRIMARY]
GO

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE7_Services' AND object_id = OBJECT_ID('[dbo].[Services]'))
	DROP INDEX [XIE7_Services] ON [dbo].[Services]
GO

CREATE NONCLUSTERED INDEX [XIE7_Services] ON [dbo].[Services]
(
	[ServiceId] ASC
)
INCLUDE ( 	[ProcedureCodeId],
	[ProgramId],
	[LocationId]) ON [PRIMARY]
GO


IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE5_Services' AND object_id = OBJECT_ID('[dbo].[Services]'))
	DROP INDEX [XIE5_Services] ON [dbo].[Services]	
GO

CREATE NONCLUSTERED INDEX [XIE5_Services] ON [dbo].[Services]
(
	[Status] ASC,
	[ClientId] ASC
)
INCLUDE ( 	[RecordDeleted],
	[DateOfService]) ON [PRIMARY]
GO



/* Consolidate duplicate appointment indexes and add often used columns as included columns */
IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE5_Appointments' AND object_id = OBJECT_ID('[dbo].[Appointments]'))
	DROP INDEX [XIE5_Appointments] ON [dbo].[Appointments];

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE1_Appointments' AND object_id = OBJECT_ID('[dbo].[Appointments]'))
	DROP INDEX [XIE1_Appointments] ON [dbo].[Appointments];

CREATE NONCLUSTERED INDEX [XIE1_Appointments] ON [dbo].[Appointments]
(
	[StaffId] ASC,
	[ShowTimeAs] ASC,
	[StartTime] ASC	
) INCLUDE ([AppointmentId], [EndTime], [AppointmentType], [ServiceId], [RecurringAppointment], [RecurringAppointmentId], [RecurringServiceId], [RecurringGroupServiceId], [RecordDeleted])

GO

/* Consolidate duplicate document indexes and add often used columns as included columns */
IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE11_Documents' AND object_id = OBJECT_ID('[dbo].[Documents]'))
	DROP INDEX [XIE11_Documents] ON [dbo].[Documents];

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE13_Documents' AND object_id = OBJECT_ID('[dbo].[Documents]'))
	DROP INDEX [XIE13_Documents] ON [dbo].[Documents];

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE3_Documents' AND object_id = OBJECT_ID('[dbo].[Documents]'))
	DROP INDEX [XIE3_Documents] ON [dbo].[Documents]
GO

CREATE NONCLUSTERED INDEX [XIE3_Documents] ON [dbo].[Documents]
(
	[AuthorId],
	[Status],
	[CurrentVersionStatus]
) INCLUDE ([DocumentId], [ClientId], [EffectiveDate], [CurrentDocumentVersionId], [RecordDeleted])
GO


IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE14_Documents' AND object_id = OBJECT_ID('[dbo].[Documents]'))
	DROP INDEX [XIE14_Documents] ON [dbo].[Documents];

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE12_Documents' AND object_id = OBJECT_ID('[dbo].[Documents]'))
	DROP INDEX [XIE12_Documents] ON [dbo].[Documents]
GO

CREATE INDEX [XIE12_Documents] ON [dbo].[Documents] 
	( [DocumentCodeId], 
	  [CurrentVersionStatus]
	) 
INCLUDE ([DocumentId],[RecordDeleted],[EffectiveDate],[CurrentDocumentVersionId],[AuthorId],[ClientId],[AppointmentId],[ProxyId],[SignedByAuthor],[ReviewerId]);
GO


/* Consolidate duplicate charges indexes and add often used columns as included columns */
IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE3_Charges' AND object_id = OBJECT_ID('[dbo].[Charges]'))
	DROP INDEX [XIE3_Charges] ON [dbo].[Charges];

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE2_Charges' AND object_id = OBJECT_ID('[dbo].[Charges]'))
	DROP INDEX [XIE2_Charges] ON [dbo].[Charges]
GO

CREATE INDEX [XIE2_Charges] ON [dbo].[Charges] ( [LastBilledDate] ) 
INCLUDE ( [ChargeId], [ServiceId], [ClientCoveragePlanId],[RecordDeleted], [Priority], [DoNotBill])
GO


/* Expand ClinicianId index on Service to include status and included columns typically used */
IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE2_Services' AND object_id = OBJECT_ID('[dbo].[Services]'))
	DROP INDEX [XIE2_Services] ON [dbo].[Services]
GO

CREATE NONCLUSTERED INDEX [XIE2_Services] ON [dbo].[Services]
(
	[ClinicianId], 
	[Status]
)  
INCLUDE ([RecordDeleted], [ClientId], [DateOfService])
GO


/* Consolidate duplicate document signature indexes and add often used columns as included columns */
IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE4_DocumentSignatures' AND object_id = OBJECT_ID('[dbo].[DocumentSignatures]'))
	DROP INDEX [XIE4_DocumentSignatures] ON [dbo].[DocumentSignatures];

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE2_DocumentSignatures' AND object_id = OBJECT_ID('[dbo].[DocumentSignatures]'))
	DROP INDEX [XIE2_DocumentSignatures] ON [dbo].[DocumentSignatures];

CREATE INDEX [XIE2_DocumentSignatures] ON [dbo].[DocumentSignatures] 
( 
	[StaffId], 
	[SignatureDate] 
) INCLUDE ( [DocumentId], [RecordDeleted],[SignedDocumentVersionId],[DeclinedSignature])
GO

/* Expand clientprogram indexe and add often used columns as included columns */
IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE4_ClientPrograms' AND object_id = OBJECT_ID('[dbo].[ClientPrograms]'))
	DROP INDEX [XIE4_ClientPrograms] ON [dbo].[ClientPrograms]
GO

CREATE NONCLUSTERED INDEX [XIE4_ClientPrograms] ON [dbo].[ClientPrograms]
(
	[Status] ASC
)
INCLUDE ( 	[RecordDeleted], [ClientId], [ProgramId]) 


IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE2_ClientPrograms' AND object_id = OBJECT_ID('[dbo].[ClientPrograms]'))
	DROP INDEX [XIE2_ClientPrograms] ON [dbo].[ClientPrograms]

CREATE NONCLUSTERED INDEX [XIE2_ClientPrograms] ON [dbo].[ClientPrograms]
(
	[ProgramId] ASC
) INCLUDE ([RecordDeleted], [ClientId], [Status])
GO

/* Expand ClientContactNotes indexe and add often used columns as included columns */
IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE2_ClientContactNotes' AND object_id = OBJECT_ID('[dbo].[ClientContactNotes]'))
	DROP INDEX [XIE2_ClientContactNotes] ON [dbo].[ClientContactNotes]
GO

CREATE NONCLUSTERED INDEX [XIE2_ClientContactNotes] ON [dbo].[ClientContactNotes]
(
	[ContactDateTime] ,
	[ContactStatus] ,
	[ContactReason] 
) INCLUDE ([RecordDeleted], [ClientId], [AssignedTo])
GO

/* Expand [ListPagePMPostPayments] index and add often used columns as included columns */
IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='ListPagePMPostPayments_AK' AND object_id = OBJECT_ID('[dbo].[ListPagePMPostPayments]'))
	DROP INDEX [ListPagePMPostPayments_AK] ON [dbo].[ListPagePMPostPayments]
GO

CREATE UNIQUE NONCLUSTERED INDEX [ListPagePMPostPayments_AK] ON [dbo].[ListPagePMPostPayments]
(
	[SessionId] ASC,
	[InstanceId] ASC,
	[IsSelected] ASC,
	[RowNumber] ASC
) INCLUDE ([ListPagePMPostPaymentId], [ServiceId])
GO

/* Expand [ListPagePMPostPayments] index and add often used columns as included columns */
IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE1_PermissionTemplates' AND object_id = OBJECT_ID('[dbo].[PermissionTemplates]'))
	DROP INDEX [XIE1_PermissionTemplates] ON [dbo].[PermissionTemplates]

CREATE NONCLUSTERED INDEX [XIE1_PermissionTemplates] ON [dbo].[PermissionTemplates]
(
	[PermissionTemplateType],
	[RoleId] 
)
INCLUDE ( 	[PermissionTemplateId],[RecordDeleted]) 
GO

/* Remove dupe index on ClientMedicationScriptDrugs */
IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='IX_ClientMedicationInstructions_ClientMedicationInstructionId' AND object_id = OBJECT_ID('[dbo].[ClientMedicationScriptDrugs]'))
	DROP INDEX [IX_ClientMedicationInstructions_ClientMedicationInstructionId] ON [dbo].[ClientMedicationScriptDrugs]


/* Create index on [DocumentDiagnosis] */
IF NOT EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE1_DocumentDiagnosis' AND object_id = OBJECT_ID('[dbo].[DocumentDiagnosis]'))
	CREATE INDEX [XIE1_DocumentDiagnosis] ON [dbo].[DocumentDiagnosis] ([DocumentVersionId],[RecordDeleted]);