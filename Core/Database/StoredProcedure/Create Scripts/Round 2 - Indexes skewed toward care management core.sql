
IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE6_ProviderAuthorizations' AND object_id = OBJECT_ID('[dbo].[ProviderAuthorizations]'))
	DROP INDEX [XIE6_ProviderAuthorizations] ON [dbo].[ProviderAuthorizations]

CREATE NONCLUSTERED INDEX XIE6_ProviderAuthorizations ON [dbo].[ProviderAuthorizations] 
(
	[Status],
	[StartDate]
)
INCLUDE (
	[RecordDeleted],
	[ClientId],
	[ProviderId],
	[EndDate]
)
GO

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE1_ProviderClients' AND object_id = OBJECT_ID('[dbo].[ProviderClients]'))
	DROP INDEX [XIE1_ProviderClients] ON [dbo].[ProviderClients]

CREATE NONCLUSTERED INDEX [XIE1_ProviderClients] ON [dbo].[ProviderClients]
(
	[ClientId] ASC
)
INCLUDE ( 	
	[Active],
	[RecordDeleted],
	[ProviderId],
	[MasterClientId]
) 
GO


IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE4_ProviderClients' AND object_id = OBJECT_ID('[dbo].[ProviderClients]'))
	DROP INDEX [XIE4_ProviderClients] ON [dbo].[ProviderClients]

CREATE NONCLUSTERED INDEX XIE4_ProviderClients
ON [dbo].[ProviderClients] 
(
	[Active]
)
INCLUDE (
	[ProviderClientId],
	[ClientId],
	[ProviderId],
	[RecordDeleted]
)
GO


IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE1_Claims' AND object_id = OBJECT_ID('[dbo].[Claims]'))
	DROP INDEX [XIE1_Claims] ON [dbo].[Claims]


CREATE NONCLUSTERED INDEX [XIE1_Claims] ON [dbo].[Claims]
(
	[ClientId] ASC
)
INCLUDE ( 	
	[RecordDeleted],
	[SiteId]
) 
GO


IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE2_Claims' AND object_id = OBJECT_ID('[dbo].[Claims]'))
	DROP INDEX [XIE2_Claims] ON [dbo].[Claims]

CREATE NONCLUSTERED INDEX [XIE2_Claims] ON [dbo].[Claims]
(
	[InsurerId] ASC
)
INCLUDE ( 	
	[ClaimId],
	[RecordDeleted],
	[ClientId],
	[SiteId]) 
GO



IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE1_ClaimLinePlans' AND object_id = OBJECT_ID('[dbo].[ClaimLines]'))
	DROP INDEX [XIE1_ClaimLinePlans] ON [dbo].[ClaimLines]

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE1_ClaimLines' AND object_id = OBJECT_ID('[dbo].[ClaimLines]'))
	DROP INDEX [XIE1_ClaimLines] ON [dbo].[ClaimLines]

CREATE NONCLUSTERED INDEX [XIE1_ClaimLines] ON [dbo].[ClaimLines]
(
	[ClaimId] ASC,
	[RecordDeleted] ASC
)
INCLUDE ( 	
	[ClaimLineId],
	[Status],
	[NeedsToBeWorked]
) 
GO


IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE4_ClaimLines' AND object_id = OBJECT_ID('[dbo].[ClaimLines]'))
	DROP INDEX [XIE4_ClaimLines] ON [dbo].[ClaimLines]

CREATE NONCLUSTERED INDEX [XIE4_ClaimLines] ON [dbo].[ClaimLines]
(
	[ClaimId] ASC,
	[ToDate] ASC
)
INCLUDE ( 	
	[RecordDeleted],
	[ClaimLineId]
) 
GO

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE5_ClaimLines' AND object_id = OBJECT_ID('[dbo].[ClaimLines]'))
	DROP INDEX [XIE5_ClaimLines] ON [dbo].[ClaimLines]

CREATE INDEX [XIE5_ClaimLines] ON [dbo].[ClaimLines] 
(
	[Status], 
	[PayableAmount]
)  INCLUDE ([ClaimLineId], [RecordDeleted], [ClaimId], [NeedsToBeWorked],[FromDate], [DoNotAdjudicate], [DenialReason], [PendedReason]);


IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE2_ClaimLineHistory' AND object_id = OBJECT_ID('[dbo].[ClaimLineHistory]'))
	DROP INDEX [XIE2_ClaimLineHistory] ON [dbo].[ClaimLineHistory]

CREATE NONCLUSTERED INDEX [XIE2_ClaimLineHistory] ON [dbo].[ClaimLineHistory]
(
	[ClaimLineId] ASC,
	[AdjudicationId] ASC
)
INCLUDE ( 	
	[ClaimLineHistoryId],
	[RecordDeleted],
	[ActivityDate]
) 
GO


IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE2_StaffRoles' AND object_id = OBJECT_ID('[dbo].[StaffRoles]'))
	DROP INDEX [XIE2_StaffRoles] ON [dbo].[StaffRoles]

CREATE INDEX [XIE2_StaffRoles] ON [dbo].[StaffRoles] 
(
	[RoleId]
)  
INCLUDE (
	[StaffId], 
	[RecordDeleted]
)

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE1_StaffInsurers' AND object_id = OBJECT_ID('[dbo].[StaffInsurers]'))
	DROP INDEX [XIE1_StaffInsurers] ON [dbo].[StaffInsurers]


CREATE NONCLUSTERED INDEX [XIE1_StaffInsurers] ON [dbo].[StaffInsurers]
(
	[InsurerId] ASC,
	[StaffId] ASC
)
INCLUDE ( 	
	[StaffInsurerId],
	[RecordDeleted]
) 
GO


IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE2_StaffInsurers' AND object_id = OBJECT_ID('[dbo].[StaffInsurers]'))
	DROP INDEX [XIE2_StaffInsurers] ON [dbo].[StaffInsurers]

CREATE NONCLUSTERED INDEX [XIE2_StaffInsurers] ON [dbo].[StaffInsurers]
(
	[StaffId] ASC,
	[InsurerId] ASC
)
INCLUDE ( 	
	[StaffInsurerId],
	[RecordDeleted]
) 
GO


IF EXISTS (SELECT * FROM sys.indexes  WHERE name='XIE1_ContractRateSites' AND object_id = OBJECT_ID('[dbo].[ContractRateSites]'))
	DROP INDEX [XIE1_ContractRateSites] ON [dbo].[ContractRateSites] 

CREATE INDEX [XIE1_ContractRateSites] ON [dbo].[ContractRateSites] 
(
	[ContractRateId]
)  
INCLUDE (
	SiteId,
	RecordDeleted
)
GO

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE2_ContractRateSites' AND object_id = OBJECT_ID('[dbo].[ContractRateSites]'))
	DROP INDEX [XIE2_ContractRateSites] ON [dbo].[ContractRateSites] 

CREATE INDEX [XIE2_ContractRateSites] ON [dbo].[ContractRateSites] 
(	[SiteId]
)  
INCLUDE (
	[ContractRateId],
	RecordDeleted
)
GO

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE3_Events' AND object_id = OBJECT_ID('[dbo].[Events]'))
	DROP INDEX [XIE3_Events] ON [dbo].[Events]
	
CREATE NONCLUSTERED INDEX [XIE3_Events] ON [dbo].[Events]
(
	[EventTypeId] ASC
)
INCLUDE ( 	
	[EventId],
	[RecordDeleted],
	[ClientId],
	[InsurerId],
	[EventDateTime]) 
GO


IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE1_DocumentDiagnosis' AND object_id = OBJECT_ID('[dbo].[DocumentDiagnosis]'))
	DROP INDEX [XIE1_DocumentDiagnosis] ON [dbo].[DocumentDiagnosis] 

CREATE INDEX [XIE1_DocumentDiagnosis] ON [dbo].[DocumentDiagnosis] 
(
	[DocumentVersionId]
) 
INCLUDE (RecordDeleted);


IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE2_DocumentVersions' AND object_id = OBJECT_ID('[dbo].[DocumentVersions]'))
	DROP INDEX [XIE2_DocumentVersions] ON [dbo].[DocumentVersions] 

CREATE NONCLUSTERED INDEX [XIE2_DocumentVersions] ON [dbo].[DocumentVersions]
(
	[DocumentVersionId] ASC
) INCLUDE (RecordDeleted);
GO


IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE8_Clients' AND object_id = OBJECT_ID('[dbo].[Clients]'))
	DROP INDEX [XIE8_Clients] ON [dbo].[Clients] 

CREATE NONCLUSTERED INDEX [XIE8_Clients] ON [dbo].[Clients]
(
	InpatientCaseManager ASC
)
INCLUDE ( 	
	[ClientId],
	[RecordDeleted],
	[LastName],
	[FirstName]) 
GO

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE3_Clients' AND object_id = OBJECT_ID('[dbo].[Clients]'))
	DROP INDEX [XIE3_Clients] ON [dbo].[Clients] 

CREATE NONCLUSTERED INDEX [XIE3_Clients] ON [dbo].[Clients]
(
	[LastName] ASC,
	[FirstName] ASC
)
INCLUDE ( 	
	[RecordDeleted],
	[LastNameSoundex],
	[FirstNameSoundex],
	[ClientType],
	[OrganizationName]
) 
GO

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE4_Clients' AND object_id = OBJECT_ID('[dbo].[Clients]'))
	DROP INDEX [XIE4_Clients] ON [dbo].[Clients] 

CREATE NONCLUSTERED INDEX [XIE4_Clients] ON [dbo].[Clients]
(
	[LastNameSoundex] ASC,
	[FirstNameSoundex] ASC
)
INCLUDE ( 	[RecordDeleted],
	[LastName],
	[FirstName],
	[ClientType],
	[OrganizationName]) 
GO


IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE7_Clients' AND object_id = OBJECT_ID('[dbo].[Clients]'))
	DROP INDEX [XIE7_Clients] ON [dbo].[Clients] 

CREATE NONCLUSTERED INDEX XIE7_Clients ON [dbo].[Clients] 
(
	[Active]
)
INCLUDE (
	[ClientId],
	[RecordDeleted]
)
GO

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE9_Clients' AND object_id = OBJECT_ID('[dbo].[Clients]'))
	DROP INDEX [XIE9_Clients] ON [dbo].[Clients] 

CREATE NONCLUSTERED INDEX [XIE9_Clients] ON [dbo].[Clients]
(
	[ClientType] ASC,
	[OrganizationName] ASC
)
INCLUDE ( 	[ClientId],
	[RecordDeleted],
	[LastName],
	[FirstName],
	[LastNameSoundex],
	[FirstNameSoundex]) ON [PRIMARY]
GO

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE1_SureScriptsOutgoingMessages' AND object_id = OBJECT_ID('[dbo].[SureScriptsOutgoingMessages]'))
       DROP INDEX [XIE1_SureScriptsOutgoingMessages] ON [dbo].[SureScriptsOutgoingMessages] 
GO

CREATE INDEX [XIE1_SureScriptsOutgoingMessages] ON [dbo].[SureScriptsOutgoingMessages] 
(
		[MessageType], 
		[ClientMedicationScriptId]
)  
INCLUDE ([RecordDeleted]);


IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE1_ClientMedicationScriptActivities' AND object_id = OBJECT_ID('[dbo].[ClientMedicationScriptActivities]'))
       DROP INDEX [XIE1_ClientMedicationScriptActivities] ON [dbo].[ClientMedicationScriptActivities] 
GO
CREATE INDEX [XIE1_ClientMedicationScriptActivities] ON [dbo].[ClientMedicationScriptActivities] 
(
		[Method], 
		[Status]
)  
INCLUDE ([ClientMedicationScriptActivityId], [ClientMedicationScriptId], [RecordDeleted]);



IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE1_Recodes' AND object_id = OBJECT_ID('[dbo].[Recodes]'))
       DROP INDEX [XIE1_Recodes] ON [dbo].[Recodes]
GO
CREATE NONCLUSTERED INDEX [XIE1_Recodes] ON [dbo].[Recodes]
(
       RecodeCategoryId
       ,CodeName
       ,UseForNonMatchedEntry    
) INCLUDE ([RecordDeleted],[FromDate],[ToDate],[TranslationValue1],[TranslationValue2],[IntegerCodeId], [CharacterCodeId])
GO 
 
IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE1_RecodeCategories' AND object_id = OBJECT_ID('[dbo].[RecodeCategories]'))
       DROP INDEX [XIE1_RecodeCategories] ON [dbo].[RecodeCategories]
GO
CREATE NONCLUSTERED INDEX [XIE1_RecodeCategories] ON [dbo].[RecodeCategories]
(
       CategoryCode
) INCLUDE ([RecordDeleted],[RecodeType],[RangeType])
GO 


IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='NIX_CoveragePlanRule_ProcedureCode' AND object_id = OBJECT_ID('[dbo].[CoveragePlanRuleVariables]'))
       DROP INDEX [NIX_CoveragePlanRule_ProcedureCode] ON [dbo].[CoveragePlanRuleVariables]
GO

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE1_CoveragePlanRuleVariables' AND object_id = OBJECT_ID('[dbo].[CoveragePlanRuleVariables]'))
       DROP INDEX [XIE1_CoveragePlanRuleVariables] ON [dbo].[CoveragePlanRuleVariables] 
GO

CREATE INDEX [XIE1_CoveragePlanRuleVariables] ON [dbo].[CoveragePlanRuleVariables] 
(
	[CoveragePlanRuleId],
	[ProcedureCodeId]
)  INCLUDE ([RecordDeleted], [CoveragePlanId], [StaffId], [AppliesToAllProcedureCodes], [AppliesToAllCoveragePlans], [AppliesToAllStaff], [AppliesToAllDSMCodes], [DiagnosisCode], [DiagnosisCodeType], [AppliesToAllICD9Codes], [AppliesToAllICD10Codes]) WITH (FILLFACTOR=100);
GO

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE6_Services' AND object_id = OBJECT_ID('[dbo].[Services]'))
       DROP INDEX [XIE6_Services] ON [dbo].[Services]
GO

CREATE INDEX [XIE6_Services] ON [dbo].[Services] 
(
	[Status], 
	[ProcedureCodeId]
)  
INCLUDE ([ServiceId], [RecordDeleted], [ClientId], [DateOfService], [Charge], [DoNotComplete])
GO

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE2_StaffWidgetData' AND object_id = OBJECT_ID('[dbo].[StaffWidgetData]'))
       DROP INDEX [XIE2_StaffWidgetData] ON [dbo].[StaffWidgetData]
GO

CREATE INDEX [XIE2_StaffWidgetData] ON [dbo].[StaffWidgetData] 
(
	[WidgetId]
)  
INCLUDE ([StaffId],[StaffWidgetDataId], [RecordDeleted], [LastRefreshed]) WITH (FILLFACTOR=100);
GO

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE2_StaffPrograms' AND object_id = OBJECT_ID('[dbo].[StaffPrograms]'))
       DROP INDEX [XIE2_StaffPrograms] ON [dbo].[StaffPrograms] 
GO

CREATE INDEX [XIE2_StaffPrograms] ON [dbo].[StaffPrograms] 
(
	[StaffId]
)  
INCLUDE ([ProgramId], [RecordDeleted]) WITH (FILLFACTOR=100);


IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE2_StaffLoginHistory' AND object_id = OBJECT_ID('[dbo].[StaffLoginHistory]'))
       DROP INDEX [XIE2_StaffLoginHistory] ON [dbo].[StaffLoginHistory] 
GO

CREATE INDEX [XIE2_StaffLoginHistory] ON [dbo].[StaffLoginHistory] 
(
	[SessionId]
)  WITH (FILLFACTOR=90);


IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE1_DocumentValidations' AND object_id = OBJECT_ID('[dbo].[DocumentValidations]'))
       DROP INDEX [XIE1_DocumentValidations] ON [dbo].[DocumentValidations]  
GO

CREATE INDEX [XIE1_DocumentValidations] ON [dbo].[DocumentValidations] 
(
	[Active], 
	[DocumentCodeId], 
	[DocumentValidationId], 
	[DocumentType]
)  INCLUDE ([RecordDeleted]) WITH (FILLFACTOR=90);


IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE6_Authorizations' AND object_id = OBJECT_ID('[dbo].[Authorizations]'))
       DROP INDEX [XIE6_Authorizations] ON [dbo].[Authorizations]   
GO

CREATE INDEX [XIE6_Authorizations] ON [dbo].[Authorizations] 
(	
	[Status], 
	[StartDate]
)  INCLUDE ([RecordDeleted], [AuthorizationId], [AuthorizationDocumentId], [AuthorizationCodeId], [EndDate]);

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE6_Authorizations' AND object_id = OBJECT_ID('[dbo].[Authorizations]'))
	DROP INDEX [ListPagePMPostPayments_AK] ON [dbo].[ListPagePMPostPayments]

CREATE UNIQUE NONCLUSTERED INDEX [ListPagePMPostPayments_AK] ON [dbo].[ListPagePMPostPayments]
(
	[SessionId] ASC,
	[InstanceId] ASC,
	[IsSelected] ASC,
	[RowNumber] ASC
)
INCLUDE ( 	[ListPagePMPostPaymentId],
	[ServiceId],
	[PageNumber]) 
GO

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XEI1_CustomFieldsData' AND object_id = OBJECT_ID('[dbo].[CustomFieldsData]'))
	DROP INDEX [XEI1_CustomFieldsData] ON [dbo].[CustomFieldsData] 
GO
CREATE INDEX [XEI1_CustomFieldsData] ON [dbo].[CustomFieldsData] 
(
	[DocumentType], 
	[PrimaryKey1]
);
GO

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XEI1_ListPagePMAppointments' AND object_id = OBJECT_ID('[dbo].[ListPagePMAppointments]'))
	DROP INDEX [XEI1_ListPagePMAppointments] ON [dbo].[ListPagePMAppointments] 
GO

CREATE INDEX [XEI1_ListPagePMAppointments] ON [dbo].[ListPagePMAppointments] 
(
	[SessionId], 
	[InstanceId]
)  
INCLUDE ([RowNumber],[PageNumber],[AvailableDateTime]);


IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE1_PermissionTemplateItems' AND object_id = OBJECT_ID('[dbo].[PermissionTemplateItems]'))
	DROP INDEX [XIE1_PermissionTemplateItems] ON [dbo].[PermissionTemplateItems]
GO
CREATE NONCLUSTERED INDEX [XIE1_PermissionTemplateItems] ON [dbo].[PermissionTemplateItems]
(
	[PermissionTemplateId] ASC,
	[PermissionItemId] ASC
)
INCLUDE ([RecordDeleted]) 
GO

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE1_PermissionTemplates' AND object_id = OBJECT_ID('[dbo].[PermissionTemplates]'))
DROP INDEX [XIE1_PermissionTemplates] ON [dbo].[PermissionTemplates]
GO

CREATE NONCLUSTERED INDEX [XIE1_PermissionTemplates] ON [dbo].[PermissionTemplates]
(
	[RoleId] ASC,
	[PermissionTemplateType] ASC
)
INCLUDE ( 	[PermissionTemplateId],
	[RecordDeleted]);
GO

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE12_Documents' AND object_id = OBJECT_ID('[dbo].[Documents]'))
	DROP INDEX [XIE12_Documents] ON [dbo].[Documents]
GO

CREATE NONCLUSTERED INDEX [XIE12_Documents] ON [dbo].[Documents]
(
	[CurrentVersionStatus] ASC,
	[DocumentCodeId] ASC
)
INCLUDE ( 	[DocumentId],
	[RecordDeleted],
	[EffectiveDate],
	[CurrentDocumentVersionId],
	[AuthorId],
	[ClientId],
	[AppointmentId],
	[ProxyId],
	[SignedByAuthor],
	[ReviewerId]) 
GO

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XEI1_CarePlanGoals' AND object_id = OBJECT_ID('[dbo].[CarePlanGoals]'))
	DROP INDEX [XEI1_CarePlanGoals] ON [dbo].[CarePlanGoals] 
GO

CREATE INDEX [XEI1_CarePlanGoals] ON [dbo].[CarePlanGoals] 
([DocumentVersionId]) 
INCLUDE (RecordDeleted);
GO

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XEI1_ClientContactNotes' AND object_id = OBJECT_ID('[dbo].[ClientContactNotes]'))
	DROP INDEX [XEI1_ClientContactNotes] ON [dbo].[ClientContactNotes]
GO

CREATE INDEX [XEI1_ClientContactNotes] ON [dbo].[ClientContactNotes] 
(	[ContactStatus], 
	[ContactDateTime]
)  INCLUDE ([RecordDeleted], [ClientId], [AssignedTo]);
GO

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XEI1_DiagnosisICD10CodeExcludeCodes' AND object_id = OBJECT_ID('[dbo].[DiagnosisICD10CodeExcludeCodes]'))
	DROP INDEX [XEI1_DiagnosisICD10CodeExcludeCodes] ON [dbo].[DiagnosisICD10CodeExcludeCodes]
GO

CREATE INDEX [XEI1_DiagnosisICD10CodeExcludeCodes] ON [dbo].[DiagnosisICD10CodeExcludeCodes] 
(
	[ExcludeCode]
)  INCLUDE ([ConditionCode]);


IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XEI5_Charges' AND object_id = OBJECT_ID('[dbo].[Charges]'))
	DROP INDEX [XEI5_Charges] ON [dbo].[Charges] 

CREATE INDEX [XEI5_Charges] ON [dbo].[Charges] 
(
[ClientCoveragePlanId]
)  
INCLUDE ([ChargeId], [RecordDeleted]);

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XEI1_DiagnosisICD10CodeAdditionalCodes' AND object_id = OBJECT_ID('[dbo].[DiagnosisICD10CodeAdditionalCodes]'))
	DROP INDEX [XEI1_DiagnosisICD10CodeAdditionalCodes] ON [dbo].[DiagnosisICD10CodeAdditionalCodes]  

CREATE INDEX [XEI1_DiagnosisICD10CodeAdditionalCodes] ON [dbo].[DiagnosisICD10CodeAdditionalCodes] 
(
[AdditionalCode]
)  
INCLUDE ([ConditionCode]);

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XEI7_ProviderAuthorizations' AND object_id = OBJECT_ID('[dbo].[ProviderAuthorizations]'))
	DROP INDEX [XEI7_ProviderAuthorizations] ON [dbo].[ProviderAuthorizations]  

CREATE INDEX [XEI7_ProviderAuthorizations] ON [dbo].[ProviderAuthorizations] 
(
	[ProviderAuthorizationDocumentId], 
	[ReviewLevel]
)  INCLUDE (RecordDeleted);


IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE1_ClientPrograms' AND object_id = OBJECT_ID('[dbo].[ClientPrograms]'))
	DROP INDEX [XIE1_ClientPrograms] ON [dbo].[ClientPrograms]
GO

CREATE NONCLUSTERED INDEX [XIE1_ClientPrograms] ON [dbo].[ClientPrograms]
(
	[ClientId] ASC,	
	[PrimaryAssignment] ASC
) INCLUDE (RecordDeleted,ProgramId,AssignedStaffId,EnrolledDate)
GO

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE11_ImageRecords' AND object_id = OBJECT_ID('[dbo].[ImageRecords]'))
	DROP INDEX [XIE11_ImageRecords] ON [dbo].[ImageRecords]
GO

CREATE NONCLUSTERED INDEX [XIE11_ImageRecords] ON [dbo].[ImageRecords]
(
	[AssociatedWith] ASC,
	[CreatedDate] DESC
) INCLUDE (ImageRecordId,ScannedBy,RecordDeleted,CoveragePlanId,EffectiveDate,ScannedOrUploaded,AssociatedId,ClientId,StaffId,ProviderId)
GO


IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE1_StaffProviders' AND object_id = OBJECT_ID('[dbo].[StaffProviders]'))
	DROP INDEX [XIE1_StaffProviders] ON [dbo].[StaffProviders]
GO

CREATE NONCLUSTERED INDEX [XIE1_StaffProviders] ON [dbo].[StaffProviders]
(
	[StaffId] ASC,
	[ProviderId] ASC
)
INCLUDE ([RecordDeleted]) 


IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE1_ClientHealthDataAttributes' AND object_id = OBJECT_ID('[dbo].[ClientHealthDataAttributes]'))
	DROP INDEX [XIE1_ClientHealthDataAttributes] ON [dbo].[ClientHealthDataAttributes]
GO

CREATE NONCLUSTERED INDEX [XIE1_ClientHealthDataAttributes] ON [dbo].[ClientHealthDataAttributes]
(
	[ClientId] ASC,
	[HealthRecordDate] ASC
)
INCLUDE ( 	[RecordDeleted],
	[HealthDataTemplateId],
	[HealthDataAttributeId],
	[HealthDataSubTemplateId],
	[SubTemplateCompleted],
	[CreatedBy],
	[ModifiedBy],
	[Value]) 
GO

/* Duplicate index to the above one - drop */
IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE2_ClientHealthDataAttributes' AND object_id = OBJECT_ID('[dbo].[ClientHealthDataAttributes]'))
	DROP INDEX [XIE2_ClientHealthDataAttributes] ON [dbo].[ClientHealthDataAttributes]
GO
