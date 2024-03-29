/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentEnrollmentViewMode]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentEnrollmentViewMode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentEnrollmentViewMode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentEnrollmentViewMode]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE	PROCEDURE   [dbo].[csp_RDLCustomDocumentEnrollmentViewMode]  
(  
@DocumentVersionId  int   
)  
AS  
--*/

/*
DECLARE	@DocumentVersionId  int   
SELECT	@DocumentVersionId = 1688231
--*/

/************************************************************************************/
/* Stored Procedure: dbo.[csp_RDLCustomDocumentCustomDocumentEnrollmentViewMode]	*/
/* Purpose:  Get Data for csp_RDLCustomDocumentCustomDocumentEnrollment Pages		*/
/*																					*/
/* Updates:																			*/
/* Date:	Author:		Purpose:													*/
/* 6/07/12	Jess		Created														*/
/* 3/Aug/2012		Jagdeep			Task No. 1851 - Harbor Go Live (To handle 2nd version exception in case of RDL)*/
/************************************************************************************/

BEGIN  

--BEGIN TRY  

SELECT	SystemConfig.OrganizationName,  
		C.LastName + '', '' + C.FirstName as ClientName,  
		D.ClientID,  
		DC.DocumentName as DocumentName,
		CONVERT(VARCHAR(10), D.EffectiveDate, 101) as DocumentEffectiveDate,
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
		LTRIM(RIGHT(CONVERT(VARCHAR(10), SE.DateOfService, 108), 7)) as StartTime,
		SE.Unit / 60 as ''Duration'',
--		convert(varchar(10),SE.Unit)+'' ''+ GC2.CodeName  as Duration,  
		L.LocationName as Location,  
		PC.ProcedureCodeName as ProcedureName,  
		
		CDE.*,
		
		dbo.csf_GetGlobalCodeNameById(CDE.type) AS ''type2'',
		substring(CDE.MiddleName, 1, 1) AS ''MI'',
--		dbo.csf_GetGlobalCodeNameById(CDE.race) AS ''race2''
		substring(gc4.ExternalCode1, 1, 1) AS ''Race2'',
		substring(gc5.ExternalCode1, 1, 1) AS ''Ethnic2'',
		substring(gc6.ExternalCode1, 1, 1) AS ''MaritalStatus2'',
		dbo.csf_GetGlobalCodeNameById(CDE.Primary508) AS ''Primary5082'',
		dbo.csf_GetGlobalCodeNameById(CDE.Secondary508) AS ''Secondary5082'',
		dbo.csf_GetGlobalCodeNameById(CDE.AxisV70OrBelow) AS ''AxisV70OrBelow2'',
		dbo.csf_GetGlobalCodeNameById(CDE.HistoryMentalIllness) AS ''HistoryMentalIllness2'',
		dbo.csf_GetGlobalCodeNameById(CDE.SymptomsRequireService) AS ''SymptomsRequireService2'',
		dbo.csf_GetGlobalCodeNameById(CDE.GAFPrognosis) AS ''GAFPrognosis2'',
		dbo.csf_GetGlobalCodeNameById(CDE.GAFHistory) AS ''GAFHistory2'',
		dbo.csf_GetGlobalCodeNameById(CDE.LacksExternalSupports) AS ''LacksExternalSupports2''
		
FROM	CustomDocumentEnrollment CDE
JOIN	DocumentVersions DV	ON	dv.DocumentVersionId = CDE.DocumentVersionId
JOIN	Documents D	ON	d.DocumentId = dv.DocumentId
JOIN	Staff S	ON	d.AuthorId = S.StaffId
JOIN	Clients C	ON	d.ClientId = C.ClientId
LEFT JOIN	GlobalCodes GC	ON	S.Degree = GC.GlobalCodeId
LEFT JOIN	Services SE	ON	d.ServiceId = SE.ServiceId
LEFT JOIN	GlobalCodes GC2	ON	SE.UnitType = GC2.GlobalCodeId   
LEFT JOIN	ProcedureCodes PC	ON	SE.ProcedureCodeId = PC.ProcedureCodeId   
LEFT JOIN	GlobalCodes GC3	ON	SE.Status = GC3.GlobalCodeId 
--LEFT JOIN	DocumentSignatures DS	ON	dv.DocumentId = DS.DocumentId
--LEFT JOIN	ServiceGoals SG	ON	SE.ServiceId = SG.ServiceId 
--LEFT JOIN	TPNeeds TN	ON	SG.NeedId = TN.NeedId
--LEFT JOIN	ServiceObjectives SO	ON	SE.ServiceId = SO.ServiceId
--LEFT JOIN	TPObjectives TON	ON	SO.ObjectiveId = ton.ObjectiveId 
LEFT JOIN	Locations L	ON	SE.LocationId = L.LocationId  
LEFT JOIN	DocumentCodes DC	ON	dc.DocumentCodeId = PC.AssociatedNoteId

LEFT JOIN	GlobalCodes GC4	ON	CDE.Race = GC4.GlobalCodeId
LEFT JOIN	GlobalCodes GC5	ON	CDE.Ethnic = GC5.GlobalCodeId 
LEFT JOIN	GlobalCodes GC6	ON	CDE.MaritalStatus = GC6.GlobalCodeId 

CROSS JOIN	SystemConfigurations as SystemConfig
WHERE	CDE.DocumentVersionId = @DocumentVersionId   
AND		isnull(D.RecordDeleted, ''N'') = ''N''  
AND		isnull(S.RecordDeleted, ''N'') = ''N'' 
AND		isnull(C.RecordDeleted, ''N'') = ''N''
AND		isNull(GC.RecordDeleted, ''N'') = ''N''   
AND		isNull(SE.RecordDeleted, ''N'') = ''N''
AND		isNull(GC2.RecordDeleted, ''N'') = ''N''  
AND		ISNULL(PC.RecordDeleted, ''N'') = ''N'' 
AND		ISNULL(GC3.RecordDeleted, ''N'') = ''N''
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
