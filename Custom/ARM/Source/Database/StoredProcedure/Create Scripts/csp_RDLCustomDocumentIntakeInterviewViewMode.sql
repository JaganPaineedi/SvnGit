/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentIntakeInterviewViewMode]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentIntakeInterviewViewMode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentIntakeInterviewViewMode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentIntakeInterviewViewMode]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE	PROCEDURE   [dbo].[csp_RDLCustomDocumentIntakeInterviewViewMode]  
(  
@DocumentVersionId  int   
)  
AS  
--*/

/*
DECLARE	@DocumentVersionId  int   
SELECT	@DocumentVersionId = 1186
--*/

/****************************************************************************/
/* Stored Procedure: dbo.[csp_RDLCustomDocumentIntakeInterviewViewMode]		*/
/* Purpose:  Get Data for csp_RDLCustomDocumentIntakeInterview Pages		*/
/*																			*/
/* Updates:																	*/
/* Date:	Author:		Purpose:											*/
/* 6/21/12	Jess		Created												*/
/*3/Aug/2012		Jagdeep			Task No. 1851 - Harbor Go Live (To handle 2nd version exception in case of RDL)*/
/****************************************************************************/

BEGIN  

--BEGIN TRY  

SELECT	SystemConfig.OrganizationName,  
		C.FirstName + '' '' + C.LastName as ClientName,  
		D.ClientID,  
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
		END		AS		ClinicianName,
		/*
		CASE	DS.VerificationMode 
				WHEN	''P''
				THEN	''''
				WHEN	''S''
				THEN	(SELECT PhysicalSignature FROM DocumentSignatures DS WHERE dv.DocumentId = DS.DocumentId) 
		END	AS	Signature,
		CONVERT(VARCHAR(10), DS.SignatureDate, 101) as SignatureDate,
		DS.VerificationMode as VerificationStyle, 
		*/
--		LTRIM(RIGHT(CONVERT(VARCHAR(10), SE.DateOfService, 100), 7)) as StartTime,  
--		convert(varchar(10),SE.Unit)+'' ''+ GC2.CodeName  as Duration,  
--		L.LocationName as Location,  
--		PC.ProcedureCodeName as ProcedureName,  
		
		CDII.*,
		dbo.csf_GetGlobalCodeNameById(CDII.Sex) AS ''ClientSexName'',
		dbo.csf_GetGlobalCodeNameById(CDII.MaritalStatus) AS ''MaritalStatusName'',
		dbo.csf_GetGlobalCodeNameById(CDII.LivingSituation) AS ''LivingSituationName'',
		dbo.csf_GetGlobalCodeNameById(CDII.HouseholdOccupants) AS ''HouseholdOccupantsName'',
		dbo.csf_GetGlobalCodeNameById(CDII.EducationObtained) AS ''EducationObtainedName'',
		dbo.csf_GetGlobalCodeNameById(CDII.VocHistoryTimeSincePrevious) AS ''VocHistoryTimeSincePreviousName'',
		dbo.csf_GetGlobalCodeNameById(CDII.VocHistoryTimeSpentAtPrevious) AS ''VocHistoryTimeSpentAtPreviousName'',
		dbo.csf_GetGlobalCodeNameById(CDII.VocHistoryShiftPreference) AS ''VocHistoryShiftPreferenceName'',
		dbo.csf_GetGlobalCodeNameById(CDII.VocHistoryHoursPreference) AS ''VocHistoryHoursPreferenceName'',
		dbo.csf_GetGlobalCodeNameById(CDII.VocHistoryDayPreference) AS ''VocHistoryDayPreferenceName'',
		dbo.csf_GetGlobalCodeNameById(CDII.VocHistoryTravelDistancePreference) AS ''VocHistoryTravelDistancePreferenceName'',
		dbo.csf_GetGlobalCodeNameById(CDII.Skill1) AS ''Skill1Name'',
		dbo.csf_GetGlobalCodeNameById(CDII.SkillRating1) AS ''SkillRating1Name'',
		dbo.csf_GetGlobalCodeNameById(CDII.Skill2) AS ''Skill2Name'',
		dbo.csf_GetGlobalCodeNameById(CDII.SkillRating2) AS ''SkillRating2Name'',
		dbo.csf_GetGlobalCodeNameById(CDII.Skill3) AS ''Skill3Name'',
		dbo.csf_GetGlobalCodeNameById(CDII.SkillRating3) AS ''SkillRating3Name''


FROM	CustomDocumentIntakeInterview CDII
JOIN	DocumentVersions DV	ON	dv.DocumentVersionId = CDII.DocumentVersionId
JOIN	Documents D	ON	d.DocumentId = dv.DocumentId
JOIN	Staff S	ON	d.AuthorId = S.StaffId
JOIN	Clients C	ON	d.ClientId = C.ClientId
LEFT JOIN	GlobalCodes GC	ON	S.Degree = GC.GlobalCodeId
--LEFT JOIN	Services SE	ON	d.ServiceId = SE.ServiceId
--LEFT JOIN	GlobalCodes GC2	ON	SE.UnitType = GC2.GlobalCodeId   
--LEFT JOIN	ProcedureCodes PC	ON	SE.ProcedureCodeId = PC.ProcedureCodeId   
--LEFT JOIN	GlobalCodes GC3	ON	SE.Status = GC3.GlobalCodeId 
--LEFT JOIN	DocumentSignatures DS	ON	dv.DocumentId = DS.DocumentId
--LEFT JOIN	Locations L	ON	SE.LocationId = L.LocationId  
LEFT JOIN	DocumentCodes DC	ON	dc.DocumentCodeId = D.DocumentCodeId
CROSS JOIN	SystemConfigurations as SystemConfig
WHERE	CDII.DocumentVersionId = @DocumentVersionId   
AND		isnull(D.RecordDeleted, ''N'') = ''N''  
AND		isnull(S.RecordDeleted, ''N'') = ''N'' 
AND		isnull(C.RecordDeleted, ''N'') = ''N''
AND		isNull(GC.RecordDeleted, ''N'') = ''N''   
--AND		isNull(SE.RecordDeleted, ''N'') = ''N''
--AND		isNull(GC2.RecordDeleted, ''N'') = ''N''  
--AND		ISNULL(PC.RecordDeleted, ''N'') = ''N'' 
--AND		ISNULL(GC3.RecordDeleted, ''N'') = ''N''
--AND		isNull(DS.RecordDeleted, ''N'') = ''N''
--AND		isNull(SG.RecordDeleted, ''N'') = ''N''
--AND		isNull(TN.RecordDeleted, ''N'') = ''N''
--AND		isNull(SO.RecordDeleted, ''N'') = ''N''
--AND		isNull(TON.RecordDeleted, ''N'') = ''N''
  
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
