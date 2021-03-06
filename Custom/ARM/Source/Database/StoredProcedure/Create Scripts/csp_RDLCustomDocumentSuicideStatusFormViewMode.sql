/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentSuicideStatusFormViewMode]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentSuicideStatusFormViewMode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentSuicideStatusFormViewMode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentSuicideStatusFormViewMode]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'  
--/*
CREATE	PROCEDURE   [dbo].[csp_RDLCustomDocumentSuicideStatusFormViewMode]  
(  
@DocumentVersionId  int   
)  
AS  
--*/

/*
DECLARE	@DocumentVersionId  int   
SELECT	@DocumentVersionId = 374
--*/

/****************************************************************************/
/* Stored Procedure: dbo.[csp_RDLCustomDocumentSuicideStatusFormViewMode]	*/
/* Purpose:  Get Data for csp_RDLCustomDocumentSuicideStatusForm Pages		*/
/*																			*/
/* Updates:																	*/
/* Date:	Author:		Purpose:											*/
/* 9/29/11	Jess		Created												*/
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
		CASE	DS.VerificationMode 
				WHEN	''P''
				THEN	''''
				WHEN	''S''
				THEN	(SELECT PhysicalSignature FROM DocumentSignatures DS WHERE dv.DocumentId = DS.DocumentId) 
		END	AS	Signature,
		CONVERT(VARCHAR(10), DS.SignatureDate, 101) as SignatureDate,
		DS.VerificationMode as VerificationStyle, 
		LTRIM(RIGHT(CONVERT(VARCHAR(10), SE.DateOfService, 100), 7)) as StartTime,  
		convert(varchar(10),SE.Unit)+'' ''+ GC2.CodeName  as Duration,  
		L.LocationName as Location,  
		PC.ProcedureCodeName as ProcedureName,  
		TN.NeedNumber as NeedNumber,
		TN.GoalText as GoalText,
		TON.ObjectiveNumber as ObjectiveNumber,
		TON.ObjectiveText as ObjectiveText,
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

dbo.csf_GetGlobalCodeNameById(SSF.PainRank) as ''PainRank'',
dbo.csf_GetGlobalCodeNameById(SSF.PainScore) as ''PainScore'',
SSF.PainComment,
dbo.csf_GetGlobalCodeNameById(SSF.StressRank) as ''StressRank'',
dbo.csf_GetGlobalCodeNameById(SSF.StressScore) as ''StressScore'',
SSF.StressComment,
dbo.csf_GetGlobalCodeNameById(SSF.AgitationRank) as ''AgitationRank'',
dbo.csf_GetGlobalCodeNameById(SSF.AgitationScore) as ''AgitationScore'',
SSF.AgitationComment,
dbo.csf_GetGlobalCodeNameById(SSF.HopelessnessRank) as ''HopelessnessRank'',
dbo.csf_GetGlobalCodeNameById(SSF.HopelessnessScore) as ''HopelessnessScore'',
SSF.HopelessnessComment,
dbo.csf_GetGlobalCodeNameById(SSF.SelfHateRank) as ''SelfHateRank'',
dbo.csf_GetGlobalCodeNameById(SSF.SelfHateScore) as ''SelfHateScore'',
SSF.SelfHateComment,
dbo.csf_GetGlobalCodeNameById(SSF.OverallRisk) as ''OverallRisk'',
dbo.csf_GetGlobalCodeNameById(SSF.RelatedToSelfScore) as ''RelatedToSelfScore'',
dbo.csf_GetGlobalCodeNameById(SSF.RelatedToOthersScore) as ''RelatedToOthersScore'',
dbo.csf_GetGlobalCodeNameById(SSF.ReasonsForLivingRank01) as ''ReasonsForLivingRank01'',
SSF.ReasonsForLiving01,
dbo.csf_GetGlobalCodeNameById(SSF.ReasonsForLivingRank02) as ''ReasonsForLivingRank02'',
SSF.ReasonsForLiving02,
dbo.csf_GetGlobalCodeNameById(SSF.ReasonsForLivingRank03) as ''ReasonsForLivingRank03'',
SSF.ReasonsForLiving03,
dbo.csf_GetGlobalCodeNameById(SSF.ReasonsForLivingRank04) as ''ReasonsForLivingRank04'',
SSF.ReasonsForLiving04,
dbo.csf_GetGlobalCodeNameById(SSF.ReasonsForLivingRank05) as ''ReasonsForLivingRank05'',
SSF.ReasonsForLiving05,
dbo.csf_GetGlobalCodeNameById(SSF.ReasonsForDyingRank01) as ''ReasonsForDyingRank01'',
SSF.ReasonsForDying01,
dbo.csf_GetGlobalCodeNameById(SSF.ReasonsForDyingRank02) as ''ReasonsForDyingRank02'',
SSF.ReasonsForDying02,
dbo.csf_GetGlobalCodeNameById(SSF.ReasonsForDyingRank03) as ''ReasonsForDyingRank03'',
SSF.ReasonsForDying03,
dbo.csf_GetGlobalCodeNameById(SSF.ReasonsForDyingRank04) as ''ReasonsForDyingRank04'',
SSF.ReasonsForDying04,
dbo.csf_GetGlobalCodeNameById(SSF.ReasonsForDyingRank05) as ''ReasonsForDyingRank05'',
SSF.ReasonsForDying05,
dbo.csf_GetGlobalCodeNameById(SSF.WishToLiveScore) as ''WishToLiveScore'',
dbo.csf_GetGlobalCodeNameById(SSF.WishToDieScore) as ''WishToDieScore'',
SSF.WhatWouldHelpComment,
CASE	SSF.SuicidePlanYN	WHEN ''Y'' THEN ''Yes''	WHEN ''N'' THEN ''No'' ELSE NULL	END AS ''SuicidePlanYN'',
SSF.SuicidePlanWhen,
SSF.SuicidePlanWhere,
SSF.SuicidePlanHow01,
CASE	SSF.SuicidePlanHow01MeansYN	WHEN ''Y'' THEN ''Yes''	WHEN ''N'' THEN ''No'' ELSE NULL	END AS ''SuicidePlanHow01MeansYN'',
SSF.SuicidePlanHow02,
CASE	SSF.SuicidePlanHow02MeansYN	WHEN ''Y'' THEN ''Yes''	WHEN ''N'' THEN ''No'' ELSE NULL	END AS ''SuicidePlanHow02MeansYN'',
CASE	SSF.SuicidePreparationYN	WHEN ''Y'' THEN ''Yes''	WHEN ''N'' THEN ''No'' ELSE NULL	END AS ''SuicidePreparationYN'',
SSF.SuicidePreparationComments,
CASE	SSF.SuicideRehearsalYN	WHEN ''Y'' THEN ''Yes''	WHEN ''N'' THEN ''No'' ELSE NULL	END AS ''SuicideRehearsalYN'',
SSF.SuicideRehearsalComments,
CASE	SSF.HistoryOfSuicidalityYN	WHEN ''Y'' THEN ''Yes''	WHEN ''N'' THEN ''No'' ELSE NULL	END AS ''HistoryOfSuicidalityYN'',
SSF.HistoryOfSuicidalityIdeation,
SSF.IdeationFrequencyAmount,
dbo.csf_GetGlobalCodeNameById(SSF.IdeationFrequencyType) AS ''IdeationFrequencyType'',
SSF.IdeationDurationAmount,
dbo.csf_GetGlobalCodeNameById(SSF.IdeationDurationType) AS ''IdeationDurationType'',
SSF.SingleAttempt,
SSF.MultipleAttempts,
CASE	SSF.CurrentIntentYN	WHEN ''Y'' THEN ''Yes''	WHEN ''N'' THEN ''No'' ELSE NULL	END AS ''CurrentIntentYN'',
SSF.CurrentIntentComments,
CASE	SSF.ImpulsivityYN	WHEN ''Y'' THEN ''Yes''	WHEN ''N'' THEN ''No'' ELSE NULL	END AS ''ImpulsivityYN'',
SSF.ImpulsivityComments,
CASE	SSF.SubstanceAbuseYN	WHEN ''Y'' THEN ''Yes''	WHEN ''N'' THEN ''No'' ELSE NULL	END AS ''SubstanceAbuseYN'',
SSF.SubstanceAbuseComments,
CASE	SSF.SignificantLossYN	WHEN ''Y'' THEN ''Yes''	WHEN ''N'' THEN ''No'' ELSE NULL	END AS ''SignificantLossYN'',
SSF.SignificantLossComments,
CASE	SSF.InterpersonalIsolationYN	WHEN ''Y'' THEN ''Yes''	WHEN ''N'' THEN ''No'' ELSE NULL	END AS ''InterpersonalIsolationYN'',
SSF.InterpersonalIsolationComments,
CASE	SSF.RelationshipProblemsYN	WHEN ''Y'' THEN ''Yes''	WHEN ''N'' THEN ''No'' ELSE NULL	END AS ''RelationshipProblemsYN'',
SSF.RelationshipProblemsComments,
CASE	SSF.HealthProblemsYN	WHEN ''Y'' THEN ''Yes''	WHEN ''N'' THEN ''No'' ELSE NULL	END AS ''HealthProblemsYN'',
SSF.HealthProblemsComments,
CASE	SSF.PhysicalPainYN	WHEN ''Y'' THEN ''Yes''	WHEN ''N'' THEN ''No'' ELSE NULL	END AS ''PhysicalPainYN'',
SSF.PhysicalPainComments,
CASE	SSF.LegalProblemsYN	WHEN ''Y'' THEN ''Yes''	WHEN ''N'' THEN ''No'' ELSE NULL	END AS ''LegalProblemsYN'',
SSF.LegalProblemsComments,
CASE	SSF.ShameYN	WHEN ''Y'' THEN ''Yes''	WHEN ''N'' THEN ''No'' ELSE NULL	END AS ''ShameYN'',
SSF.ShameComments

FROM	CustomDocumentSuicideStatusForm SSF
JOIN	DocumentVersions DV	ON	dv.DocumentVersionId = SSF.DocumentVersionId
JOIN	Documents D	ON	d.DocumentId = dv.DocumentId
JOIN	Staff S	ON	d.AuthorId = S.StaffId
JOIN	Clients C	ON	d.ClientId = C.ClientId
LEFT JOIN	GlobalCodes GC	ON	S.Degree = GC.GlobalCodeId
LEFT JOIN	Services SE	ON	d.ServiceId = SE.ServiceId
LEFT JOIN	GlobalCodes GC2	ON	SE.UnitType = GC2.GlobalCodeId   
LEFT JOIN	ProcedureCodes PC	ON	SE.ProcedureCodeId = PC.ProcedureCodeId   
LEFT JOIN	GlobalCodes GC3	ON	SE.Status = GC3.GlobalCodeId 
LEFT JOIN	DocumentSignatures DS	ON	dv.DocumentId = DS.DocumentId
LEFT JOIN	ServiceGoals SG	ON	SE.ServiceId = SG.ServiceId 
LEFT JOIN	TPNeeds TN	ON	SG.NeedId = TN.NeedId
LEFT JOIN	ServiceObjectives SO	ON	SE.ServiceId = SO.ServiceId
LEFT JOIN	TPObjectives TON	ON	SO.ObjectiveId = ton.ObjectiveId 
LEFT JOIN	Locations L	ON	SE.LocationId = L.LocationId  
LEFT JOIN	DocumentCodes DC	ON	dc.DocumentCodeId = PC.AssociatedNoteId
CROSS JOIN	SystemConfigurations as SystemConfig
WHERE	SSF.DocumentVersionId = @DocumentVersionId   
AND		isnull(D.RecordDeleted, ''N'') = ''N''  
AND		isnull(S.RecordDeleted, ''N'') = ''N'' 
AND		isnull(C.RecordDeleted, ''N'') = ''N''
AND		isNull(GC.RecordDeleted, ''N'') = ''N''   
AND		isNull(SE.RecordDeleted, ''N'') = ''N''
AND		isNull(GC2.RecordDeleted, ''N'') = ''N''  
AND		ISNULL(PC.RecordDeleted, ''N'') = ''N'' 
AND		ISNULL(GC3.RecordDeleted, ''N'') = ''N''
AND		isNull(DS.RecordDeleted, ''N'') = ''N''
AND		isNull(SG.RecordDeleted, ''N'') = ''N''
AND		isNull(TN.RecordDeleted, ''N'') = ''N''
AND		isNull(SO.RecordDeleted, ''N'') = ''N''
AND		isNull(TON.RecordDeleted, ''N'') = ''N''
  
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
