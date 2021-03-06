/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentEAPAdmissionReportViewMode]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentEAPAdmissionReportViewMode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentEAPAdmissionReportViewMode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentEAPAdmissionReportViewMode]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE	PROCEDURE   [dbo].[csp_RDLCustomDocumentEAPAdmissionReportViewMode]  
(  
@DocumentVersionId  int   
)  
AS  
--*/

/*
DECLARE	@DocumentVersionId  int   
SELECT	@DocumentVersionId = 1681771
--*/

/****************************************************************************/
/* Stored Procedure: dbo.[csp_RDLCustomDocumentEAPAdmissionReportViewMode]	*/
/* Purpose:  Get Data for csp_RDLCustomDocumentEAPAdmissionReport Pages		*/
/*																			*/
/* Updates:																	*/
/* Date:	Author:		Purpose:											*/
/* 4/25/12	Jess		Created												*/
/*3/Aug/2012		Jagdeep			Task No. 1851 - Harbor Go Live (To handle 2nd version exception in case of RDL)*/
/****************************************************************************/

BEGIN  

--BEGIN TRY  

SELECT	SystemConfig.OrganizationName,

		convert(varchar, CE.RegistrationDate, 101) AS ''Initial Contact Date'',
		SE2.DateOfService AS ''EAP Appt:'',
		S2.FirstName + '' '' + S2.LastName AS ''Clinician'',
		L2.LocationName AS ''Location'',

		S3.FirstName + '' '' + S3.LastName AS ''Intake Staff'',
		dbo.csf_GetGlobalCodeNameById(CE.ReferralType) AS ''Referral Source'',

		CE.ReferralComment AS ''Chief Complaint'',
		CE.ReferralName AS ''Referral Name & Phone'',

		D.ClientID,  
		C.SSN,
		C.DOB,

		C.LastName,
		C.FirstName,
		C.MiddleName,
		
		CAL.FirstName + '' '' + CAL.LastName AS ''AliasName'',
		dbo.csf_GetGlobalCodeNameById(C.MaritalStatus) AS ''MaritalStatus'',
		
		dbo.csf_GetGlobalCodeNameById(CR.RaceId) AS ''Race'',
		dbo.csf_GetGlobalCodeNameById(CC.Ethnicity) AS ''Ethnicity'',
		
		CA.Address,
		CA.City,
		CA.State,
		CA.Zip,
		Coalesce(CP.PhoneNumber, CP2.PhoneNumber) AS ''PhoneNumber'',
		Coalesce(CP3.PhoneNumber, CP4.PhoneNumber) AS ''Work Phone'',
		CP5.PhoneNumber AS ''Other Phone'',
		C.EmploymentInformation,
		
		
		
		P.ProgramName AS ''EAP Coverage Contract'',
	'''' AS ''Employee Occupation'',

	'''' AS ''EAP Employee'',
	'''' AS ''Employee Yrs. Of Service'',

	'''' AS ''Employee Relation to Patient'',
	'''' AS ''EAP Survey'',

		


		
		DC.DocumentName as DocumentName,
		CONVERT(VARCHAR(10), D.EffectiveDate, 101) as EffectiveDate,
		CASE	WHEN	substring(convert(varchar, D.CreatedDate, 108), 1, 2) = 00
				THEN	convert(varchar(2), 12) + substring(convert(varchar, D.CreatedDate, 108), 3, 3) + ''AM''
				WHEN	substring(convert(varchar, D.CreatedDate, 108), 1, 2) < 12
				THEN	substring(convert(varchar, D.CreatedDate, 108), 1, 5) + ''AM''
				WHEN	substring(convert(varchar, D.CreatedDate, 108), 1, 2) = 12
				THEN	substring(convert(varchar, D.CreatedDate, 108), 1, 5) + ''PM''
				WHEN	convert(varchar(2), substring(convert(varchar, D.CreatedDate, 108), 1, 2) - 12) < 10
				THEN	''0'' + convert(varchar(2), substring(convert(varchar, D.CreatedDate, 108), 1, 2) - 12) +
					convert(varchar(3), substring(convert(varchar, D.CreatedDate, 108), 3, 3)) + ''PM''
				ELSE	convert(varchar(2), substring(convert(varchar, D.CreatedDate, 108), 1, 2) - 12) +
					convert(varchar(3), substring(convert(varchar, D.CreatedDate, 108), 3, 3)) + ''PM''
		END	AS	''EffectiveTime'',
		CASE	WHEN	GC.CodeName IS NULL
				THEN	S.FirstName + '' '' + S.LastName
				ELSE	S.FirstName + '' '' + S.LastName + '', '' + GC.CodeName
		END		AS		ClinicianName
		/*
		CASE	DS.VerificationMode 
				WHEN	''P''
				THEN	''''
				WHEN	''S''
				THEN	(SELECT PhysicalSignature FROM DocumentSignatures DS WHERE dv.DocumentId = DS.DocumentId) 
		END	AS	Signature,
		CONVERT(VARCHAR(10), DS.SignatureDate, 101) as SignatureDate,
		DS.VerificationMode as VerificationStyle
		*/
/*
		LTRIM(RIGHT(CONVERT(VARCHAR(10), SE.DateOfService, 100), 7)) as StartTime,
		convert(varchar(10),SE.Unit)+'' ''+ GC2.CodeName  as Duration,
		L.LocationName as Location,  
		PC.ProcedureCodeName as ProcedureName,  
		TN.NeedNumber as NeedNumber,
		TN.GoalText as GoalText,
		TON.ObjectiveNumber as ObjectiveNumber,
		TON.ObjectiveText as ObjectiveText
*/
/*
		SSF.CreatedBy,  
		SSF.CreatedDate,  
		SSF.ModifiedBy,  
		SSF.ModifiedDate,  
		SSF.RecordDeleted,  
		SSF.DeletedBy,  
		SSF.DeletedDate,    
		SSF.Narrative
*/

FROM	DocumentVersions DV
JOIN	Documents D	ON	d.DocumentId = dv.DocumentId
JOIN	Staff S	ON	d.AuthorId = S.StaffId
JOIN	Clients C	ON	d.ClientId = C.ClientId
LEFT JOIN	ClientAddresses CA ON C.ClientId = CA.ClientId
LEFT JOIN	ClientPhones CP ON C.ClientId = CP.ClientId AND CP.PhoneType = 30	-- Home Phone 1
LEFT JOIN	ClientPhones CP2 ON C.ClientId = CP2.ClientId AND CP2.PhoneType = 32	-- Home Phone 2
LEFT JOIN	ClientPhones CP3 ON C.ClientId = CP3.ClientId AND CP3.PhoneType = 31	-- Business Phone 1
LEFT JOIN	ClientPhones CP4 ON C.ClientId = CP4.ClientId AND CP4.PhoneType = 33	-- Business Phone 2
LEFT JOIN	ClientPhones CP5 ON C.ClientId = CP5.ClientId AND CP5.PhoneType NOT IN (''30'', ''32'', ''31'', ''33'')	-- Home Phone 1 and 2, Business Phone 1 and 2
							AND CP5.PhoneType = (SELECT MIN(CP6.PhoneType) FROM ClientPhones CP6 WHERE CP5.ClientId = CP6.ClientId AND CP6.PhoneType NOT IN (''30'', ''32'', ''31'', ''33''))	-- Home Phone 1 and 2, Business Phone 1 and 2
LEFT JOIN	GlobalCodes GC	ON	S.Degree = GC.GlobalCodeId
LEFT JOIN	Services SE	ON	d.ServiceId = SE.ServiceId
LEFT JOIN	GlobalCodes GC2	ON	SE.UnitType = GC2.GlobalCodeId   
LEFT JOIN	ProcedureCodes PC	ON	SE.ProcedureCodeId = PC.ProcedureCodeId   
LEFT JOIN	GlobalCodes GC3	ON	SE.Status = GC3.GlobalCodeId 
--LEFT JOIN	DocumentSignatures DS	ON	dv.DocumentId = DS.DocumentId

LEFT JOIN	ClientEpisodes CE ON C.ClientId = CE.ClientId AND C.CurrentEpisodeNumber = CE.EpisodeNumber
LEFT JOIN	Services SE2
ON			C.ClientId = SE2.ClientId
AND			SE2.ProgramId IN (SELECT ProgramId FROM Programs WHERE ServiceAreaId = ''2'')	-- EAP Program
AND			SE2.DateOfService = (SELECT MAX(SE3.DateOfService) FROM Services SE3 WHERE SE2.ClientId = SE3.ClientId AND SE3.ProgramId IN (SELECT ProgramId FROM Programs WHERE ServiceAreaId = ''2''))	-- EAP Program
LEFT JOIN	Staff S2 ON SE2.ClinicianId = S2.StaffId
LEFT JOIN	Staff S3 ON CE.IntakeStaff = S3.StaffId
LEFT JOIN	Locations L2 ON SE2.LocationId = L2.LocationId
LEFT JOIN	Programs P ON SE2.ProgramId = P.ProgramId
LEFT JOIN	CustomClients CC ON C.ClientId = CC.ClientId
LEFT JOIN	ClientRaces CR ON C.ClientId = CR.ClientId
LEFT JOIN	ClientAliases CAL on C.ClientId = CAL.ClientId

/*
LEFT JOIN	ServiceGoals SG	ON	SE.ServiceId = SG.ServiceId 
LEFT JOIN	TPNeeds TN	ON	SG.NeedId = TN.NeedId
LEFT JOIN	ServiceObjectives SO	ON	SE.ServiceId = SO.ServiceId
LEFT JOIN	TPObjectives TON	ON	SO.ObjectiveId = ton.ObjectiveId 
*/
LEFT JOIN	Locations L	ON	SE.LocationId = L.LocationId  
LEFT JOIN	DocumentCodes DC	ON	dc.DocumentCodeId = PC.AssociatedNoteId
CROSS JOIN	SystemConfigurations as SystemConfig
WHERE	DV.DocumentVersionId = @DocumentVersionId   
AND		isnull(D.RecordDeleted, ''N'') = ''N''  
AND		isnull(S.RecordDeleted, ''N'') = ''N'' 
AND		isnull(C.RecordDeleted, ''N'') = ''N''
AND		isNull(GC.RecordDeleted, ''N'') = ''N''   
AND		isNull(SE.RecordDeleted, ''N'') = ''N''
AND		isNull(GC2.RecordDeleted, ''N'') = ''N''  
AND		ISNULL(PC.RecordDeleted, ''N'') = ''N'' 
AND		ISNULL(GC3.RecordDeleted, ''N'') = ''N''
--AND		isNull(DS.RecordDeleted, ''N'') = ''N''
/*
AND		isNull(SG.RecordDeleted, ''N'') = ''N''
AND		isNull(TN.RecordDeleted, ''N'') = ''N''
AND		isNull(SO.RecordDeleted, ''N'') = ''N''
AND		isNull(TON.RecordDeleted, ''N'') = ''N''
*/
  
--END TRY  
    

END  
/*
BEGIN CATCH  

   DECLARE @Error VARCHAR(8000)         
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + ''*****'' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                              
   + ''*****'' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),''csp_RDLCustomDocumentSuicideStatusForm'')                                                                                               
   + ''*****'' + CONVERT(VARCHAR,ERROR_LINE()) + ''*****'' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                                
   + ''*****'' + CONVERT(VARCHAR,ERROR_STATE())  
  RAISERROR  
  (  
   @Error, -- Message text.  
   16,  -- Severity.  
   1  -- State.  
  );  
END CATCH  
  
*/

' 
END
GO
