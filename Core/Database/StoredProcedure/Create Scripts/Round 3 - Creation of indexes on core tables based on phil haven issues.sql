IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE2_ClientPrograms' AND object_id = OBJECT_ID('[dbo].[ClientPrograms]'))
	DROP INDEX [XIE2_ClientPrograms] ON [dbo].[ClientPrograms]


CREATE NONCLUSTERED INDEX [XIE2_ClientPrograms] ON [dbo].[ClientPrograms]
(
	[ProgramId] ASC,
	[EnrolledDate] ASC
)
INCLUDE (
	[RecordDeleted],
	[ClientId],
	[Status]
);

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE7_Appointments' AND object_id = OBJECT_ID('[dbo].[Appointments]'))
	DROP INDEX [XIE7_Appointments] ON [dbo].[Appointments] 

CREATE NONCLUSTERED  INDEX [XIE7_Appointments] ON [dbo].[Appointments] 
(
	[RecurringAppointmentId]
)  
INCLUDE ([StartTime], [RecordDeleted]);


IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XEI1_RecurringAppointmentExceptions' AND object_id = OBJECT_ID('[dbo].[RecurringAppointmentExceptions]'))
	DROP INDEX [XEI1_RecurringAppointmentExceptions] ON [dbo].[RecurringAppointmentExceptions]  

CREATE INDEX [XEI1_RecurringAppointmentExceptions] ON [dbo].[RecurringAppointmentExceptions] 
(
	[RecurringAppointmentId]
)  INCLUDE ([ExceptionDate], [RecordDeleted]);


IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE1_ReceptionViewStaff' AND object_id = OBJECT_ID('[dbo].[ReceptionViewStaff]'))
	DROP INDEX [XIE1_ReceptionViewStaff] ON [dbo].[ReceptionViewStaff]

CREATE NONCLUSTERED INDEX [XIE1_ReceptionViewStaff] ON [dbo].[ReceptionViewStaff]
(
	[ReceptionViewId] ASC,
	[StaffId] ASC
)
INCLUDE ([RecordDeleted]);
GO

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='ListPagePMPostPaymentsAdjServicesTab_AK' AND object_id = OBJECT_ID('[dbo].[ListPagePMPostPaymentsAdjServicesTabs]'))
	DROP INDEX [ListPagePMPostPaymentsAdjServicesTab_AK] ON [dbo].[ListPagePMPostPaymentsAdjServicesTabs]

CREATE UNIQUE NONCLUSTERED INDEX [ListPagePMPostPaymentsAdjServicesTab_AK] ON [dbo].[ListPagePMPostPaymentsAdjServicesTabs]
(
	[SessionId] ASC,
	[InstanceId] ASC,
	[RowNumber] ASC
)
INCLUDE ( 	[PageNumber],
	[Identity1]) 
GO

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE10_Clients' AND object_id = OBJECT_ID('[dbo].[Clients]'))
	DROP INDEX [XIE10_Clients] ON [dbo].[Clients]; 

CREATE INDEX [XIE10_Clients] ON [dbo].[Clients] 
(
	[DOB]
) INCLUDE(RecordDeleted,Active);

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE11_Clients' AND object_id = OBJECT_ID('[dbo].[Clients]'))
	DROP INDEX [XIE11_Clients] ON [dbo].[Clients]; 

CREATE INDEX [XIE11_Clients] ON [dbo].[Clients] 
(
	[SSN]
) INCLUDE(RecordDeleted,Active)  



IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE2_PermissionTemplateItems' AND object_id = OBJECT_ID('[dbo].[PermissionTemplateItems]'))
	DROP INDEX [XIE2_PermissionTemplateItems] ON [dbo].[PermissionTemplateItems]; 

CREATE NONCLUSTERED INDEX [XIE2_PermissionTemplateItems] ON [dbo].[PermissionTemplateItems]
(
	[PermissionItemId] ASC
)
INCLUDE ( 	[PermissionTemplateId],
	[RecordDeleted])


IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE1_DiagnosesIAndII' AND object_id = OBJECT_ID('[dbo].[DiagnosesIAndII]'))
	DROP INDEX [XIE1_DiagnosesIAndII] ON [dbo].[DiagnosesIAndII]; 

CREATE NONCLUSTERED INDEX [XIE1_DiagnosesIAndII] ON [dbo].[DiagnosesIAndII]
(
	[DocumentVersionId] ASC,
	[DSMCode] ASC
);


IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE2_StaffLicenseDegrees' AND object_id = OBJECT_ID('[dbo].[StaffLicenseDegrees]'))
	DROP INDEX [XIE2_StaffLicenseDegrees] ON [dbo].[StaffLicenseDegrees]; 

CREATE NONCLUSTERED INDEX [XIE2_StaffLicenseDegrees]
ON [dbo].[StaffLicenseDegrees] ([StartDate],[EndDate])
INCLUDE ([RecordDeleted],[LicenseTypeDegree])

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE3_Services' AND object_id = OBJECT_ID('[dbo].[Services]'))
	DROP INDEX [XIE3_Services] ON [dbo].[Services]; 
	
CREATE NONCLUSTERED INDEX [XIE3_Services] ON [dbo].[Services]
(
	[GroupServiceId] ASC,
	[Status] ASC
)
INCLUDE ([RecordDeleted]) 

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE1_ClientPrograms' AND object_id = OBJECT_ID('[dbo].[ClientPrograms]'))
	DROP INDEX [XIE1_ClientPrograms] ON [dbo].[ClientPrograms]; 
	
CREATE NONCLUSTERED INDEX [XIE1_ClientPrograms] ON [dbo].[ClientPrograms]
(
	[ClientId] ASC,
	[PrimaryAssignment] ASC
)
INCLUDE ( 	[RecordDeleted],
	[ProgramId],
	[AssignedStaffId],
	[EnrolledDate],
	[Status]) 

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE1_ProcedureCodeStaffCredentials' AND object_id = OBJECT_ID('[dbo].[ProcedureCodeStaffCredentials]'))
	DROP INDEX [XIE1_ProcedureCodeStaffCredentials] ON [dbo].[ProcedureCodeStaffCredentials]; 

	
CREATE NONCLUSTERED INDEX [XIE1_ProcedureCodeStaffCredentials] ON [dbo].[ProcedureCodeStaffCredentials]
(
	[ProcedureCodeId] ASC
)
INCLUDE ([RecordDeleted]) 
GO


IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE2_Documents' AND object_id = OBJECT_ID('[dbo].[Documents]'))
	DROP INDEX [XIE2_Documents] ON [dbo].[Documents]; 

CREATE NONCLUSTERED INDEX [XIE2_Documents] ON [dbo].[Documents]
(
	[ServiceId] ASC
)
INCLUDE ( 	[DocumentId],
	[RecordDeleted]) 
GO

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE2_ProcedureCodeStaffCredentials' AND object_id = OBJECT_ID('[dbo].[ProcedureCodeStaffCredentials]'))
	DROP INDEX [XIE2_ProcedureCodeStaffCredentials] ON [dbo].[ProcedureCodeStaffCredentials]; 

CREATE NONCLUSTERED INDEX [XIE2_ProcedureCodeStaffCredentials] ON [dbo].[ProcedureCodeStaffCredentials]
(
	[DegreeLicenseType] ASC,
	[ProcedureCodeId] ASC
)
INCLUDE ([RecordDeleted]) 
GO

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE1_StaffLicenseDegrees' AND object_id = OBJECT_ID('[dbo].[StaffLicenseDegrees]'))
	DROP INDEX [XIE1_StaffLicenseDegrees] ON [dbo].[StaffLicenseDegrees]; 

CREATE NONCLUSTERED INDEX [XIE1_StaffLicenseDegrees] ON [dbo].[StaffLicenseDegrees]
(
	[StaffId] ASC,
	[StartDate] ASC,
	[EndDate] ASC
)
INCLUDE ( 	[RecordDeleted],
	[LicenseTypeDegree]) 
GO

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE3_StaffLicenseDegrees' AND object_id = OBJECT_ID('[dbo].[StaffLicenseDegrees]'))
	DROP INDEX [XIE3_StaffLicenseDegrees] ON [dbo].[StaffLicenseDegrees]; 

CREATE NONCLUSTERED INDEX [XIE3_StaffLicenseDegrees] ON [dbo].[StaffLicenseDegrees]
(
	[LicenseTypeDegree] ASC
)
INCLUDE ( 	[RecordDeleted]) 
GO


IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE1_ProcedureCodes' AND object_id = OBJECT_ID('[dbo].[ProcedureCodes]'))
	DROP INDEX [XIE1_ProcedureCodes] ON [dbo].[ProcedureCodes]; 

CREATE NONCLUSTERED INDEX [XIE1_ProcedureCodes] ON [dbo].[ProcedureCodes]
(
	[Active] ASC
)
INCLUDE ( 	[ProcedureCodeId],
	[RecordDeleted],
	[ProcedureCodeName],
	[AllowAllPrograms],
	[DisplayAs],
	[AllowAllLicensesDegrees]) 


IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE2_ProgramProcedures' AND object_id = OBJECT_ID('[dbo].[ProgramProcedures]'))
	DROP INDEX [XIE2_ProgramProcedures] ON [dbo].[ProgramProcedures]; 

CREATE NONCLUSTERED INDEX [XIE2_ProgramProcedures] ON [dbo].[ProgramProcedures]
(
	[ProcedureCodeId] ASC,
	[ProgramId] ASC
	
)
INCLUDE ( 	[RecordDeleted]) 
GO
