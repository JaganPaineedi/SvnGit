/****** Object:  StoredProcedure [dbo].[csp_Report_manually_completed_services]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_manually_completed_services]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_manually_completed_services]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_manually_completed_services]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE	PROCEDURE [dbo].[csp_Report_manually_completed_services]
	@start_date	datetime,
	@end_date	datetime

AS
--*/

/*
DECLARE	@start_date	datetime,
		@end_date	datetime

SELECT	@start_date = ''4/1/12'',
		@end_date = ''8/16/12''
--*/

/************************************************************/
/* Stored Procedure: csp_Report_manually_completed_services	*/
/* Creation Date:    01/03/2008								*/
/* Copyright:    Harbor Behavioral Healthcare				*/
/*															*/
/* Purpose: Billing Reports									*/
/*															*/
/* Updates:													*/
/* Date		Author		Purpose								*/
/* 01/03/2008	Jess		Created - WO 3924				*/
/* 05/23/2008	Jess		Modified - WO 9703				*/
/* 05/27/2009	Jess		Modified - WO 12642				*/
/* 12/14/2010	Jess		Modified - WO 16439				*/
/* 12/14/2010	Jess		Modified - WO 16439				*/
/* 07/19/2011	Jess		Modified - WO 18114 & 18244		*/
/* 09/19/2011	Jess		Modified per WO 19194			*/
/* 06/27/2012   Jess		Coverted from PsychConsult		*/
/************************************************************/


SELECT	C.LastName + '', '' + C.FirstName AS ''Client'',
		S.LastName + '', '' + S.FirstName AS ''Clinician'',
		SS.ClientId,
		SS.DateOfService,
		SS.ModifiedDate,
		SS.OverrideBy,
		PC.DisplayAs,
		SE.ErrorMessage,
		CASE	WHEN	EXISTS	(	SELECT	CCH.ClientCoveragePlanId
									FROM	ClientCoverageHistory CCH
									JOIN	ClientCoveragePlans CCP
									ON		CCH.ClientCoveragePlanId = CCP.ClientCoveragePlanId
									JOIN	CoveragePlans CP
									ON		CCP.CoveragePlanId = CP.CoveragePlanId
									WHERE	SS.ClientId = CCP.ClientId
									AND		CCH.StartDate <= SS.DateOfService
									AND	(	CCH.EndDate is null
										OR	CCH.EndDate >= SS.DateOfService
										)
									AND	(	CP.DisplayAs like ''DFNON%''
										OR	CP.DisplayAs like ''DFMCD%''
										OR	CP.DisplayAs like ''MHNON%''
										OR	CP.DisplayAs like ''MHMCD%''
										)
								)
				THEN	''Public''
				ELSE	''Private''
		END	AS	''PublicOrPrivate''
FROM	Services SS
JOIN	Clients C
ON		(SS.ClientId = C.ClientId
AND		ISNULL(C.RecordDeleted,''N'')<>''Y'') 
JOIN	Staff S
ON		(SS.ClinicianId = S.StaffId
AND		ISNULL(S.RecordDeleted,''N'')<>''Y'') 
JOIN	ProcedureCodes PC
ON		(PC.ProcedureCodeId = SS.ProcedureCodeId
AND		ISNULL(SS.RecordDeleted,''N'')<>''Y'') 
LEFT JOIN	ServiceErrors SE
ON		SS.ServiceId = SE.ServiceId
WHERE	SS.Status = ''75''	--''CO''
AND		SS.OverrideBy IS NOT NULL
--		AND	SS.ModifiedBy NOT IN(''BILLING'', ''SERVICECOMPLETE'')
AND		SS.ModifiedDate BETWEEN @start_date AND DATEADD(dd, 1, @end_date)
AND		C.LastName <> ''PUBLIC''
AND		PC.DisplayAs NOT LIKE ''OWF%''
AND		PC.DisplayAs NOT LIKE ''WIA%''
AND		PC.DisplayAs NOT LIKE ''EAPCASE%''' 
END
GO
