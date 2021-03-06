/****** Object:  StoredProcedure [dbo].[csp_Report_eap_clients_seen_for_company]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_eap_clients_seen_for_company]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_eap_clients_seen_for_company]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_eap_clients_seen_for_company]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE	PROCEDURE  [dbo].[csp_Report_eap_clients_seen_for_company] 
	@Start_Date	datetime,
    @End_Date	datetime,
    @EAP_Program varchar(100)		    
AS
--*/

/* 
DECLARE	@Start_Date	datetime,
		@End_Date	datetime,
		@EAP_program varchar(100)

SELECT	@Start_Date = ''07/01/12'',
		@End_Date = ''08/01/12'',
		@EAP_program = ''Union Construction Workers Health Plan''
--*/

SET NOCOUNT ON; -- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
/*********************************************************************/
/* Stored Procedure: csp_Report_eap_clients_seen_for_company		 */
/* Creation Date:    04/12/2004                                      */
/* Copyright: Harbor Behavioral Healthcare                           */
/*                                                                   */
/* Updates:                                                          */
/* Date       	Author  Purpose     		                         */
/* 04/12/2004	Li      Created		        			             */
/* 01/06/2006   Kris    Added nolock, additional dates               */
/* 02/16/2006	Jess	modified: proc_chron -> appt_date            */
/* 06/25/2012	Brian M Converted from PsychConsult                  */
/*********************************************************************/
IF @EAP_program IS NULL 
	BEGIN
		SELECT @EAP_program = ''%''
	END

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~ Code Translated by Brian ~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/*
SELECT	CP.DisplayAs AS ''Coverage Plan ID'',-- ch.coverage_plan_id,                                 
		PC.DisplayAs AS ''Procedure Code'',  --ct.proc_code,
		convert(char(10),SS.DateOfService, 101) as proc_chron,
		SS.ClientId, 
		SS.Status,
		C.LastName + '', '' +  C.FirstName,
		SS.LocationId,
		DATEDIFF (MI,SS.DateOfService,SS.EndDateofService ) AS ''Proc_Duration'',--ct.proc_duration,
		S.LastName + '', '' + S.FirstName AS Staff,
		convert(char(10),SS.CreatedDate, 101) as entry_date,
		convert(char(10),SS.ModifiedDate, 101) as date_completed --pct.date_complete
FROM	Services SS
JOIN	Programs P
ON		P.ProgramId = SS.ProgramId
AND		ServiceAreaId = ''2''  --Employer - Employee Assistance
AND		ISNULL(SS.RecordDeleted,''N'')<>''Y'')
LEFT JOIN	ProcedureCodes PC
ON			PC.ProcedureCodeId = SS.ProcedureCodeId
AND			ISNULL(PC.RecordDeleted,''N'')<>''Y''
LEFT JOIN	Locations L
ON			L.LocationId = SS.LocationId
AND			ISNULL(L.RecordDeleted,''N'')<>''Y''
LEFT JOIN	ClientCoveragePlans CCP
ON			CCP.ClientId = SS.ClientId
AND			ISNULL(CCP.RecordDeleted,''N'')<>''Y''	
LEFT JOIN	CoveragePlans CP
ON			CP.CoveragePlanId = CCP.CoveragePlanId 
AND			ISNULL(CP.RecordDeleted,''N'')<>''Y''
LEFT JOIN	ClientCoverageHistory CCH --Coverage_History ch          
ON			CCH.ClientCoveragePlanId = CCP.ClientCoveragePlanId
AND			ISNULL(CCH.RecordDeleted,''N'')<>''Y''
---		and	CCH.ClientCoverageHistoryId = CCP.ClientCoveragePlanId  --c.coverage_plan_id
--		and	 CCH.StartDate <= SS.DateOfService --cast(ct.appt_date as datetime) 
--		and (CCH.EndDate >= SS.DateOfService  --cast(ct.appt_date as datetime) 
--		OR CCH.EndDate IS NULL)
--	LEFT JOIN coverage_custom cc  
--		ON	(cc.patient_id=pct.patient_id
--		AND	eap.coverage_plan_id=cc.coverage_plan_id
--		AND ISNULL(CC.RecordDeleted,''N'')<>''Y'')
LEFT JOIN	Clients C
ON			C.ClientId = SS.ClientId
AND			ISNULL(C.RecordDeleted,''N'')<>''Y''
JOIN		Staff S
ON			S.StaffId = SS.ClinicianId 
AND			ISNULL(S.RecordDeleted,''N'')<>''Y''
WHERE	SS.DateOfService >= @start_date		--cast(ct.appt_date as datetime)
		AND	SS.DateOfService < dateadd(day,1,@end_date)
		AND SS.DateOfService >= CCH.StartDate
		AND (SS.DateOfService < CCH.EndDate OR CCH.EndDate IS NULL)
		AND	SS.STATUS NOT IN (''76'',''73'')--(''ER'', ''CA'')
		AND	CP.DisplayAs LIKE @coverage_plan  --ch.coverage_plan_id
ORDER	BY
		SS.DateOfService
*/
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~ END OF Code Translated by Brian ~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~ Code Translated by Jess ~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SELECT	P.ProgramName,
		PC.DisplayAs AS ''Procedure Code'',
		SS.DateOfService,
		SS.ClientId,
		dbo.csf_GetGlobalCodeNameById(SS.Status) AS ''Status'',
		C.LastName + '', '' +  C.FirstName AS ''Client'',
		L.LocationName,
		DATEDIFF (MI,SS.DateOfService,SS.EndDateofService ) AS ''Duration'',
		S.LastName + '', '' + S.FirstName AS Staff,
		SS.CreatedDate,
		CASE	WHEN	SS.Status = 75	--Complete
				THEN	SS.ModifiedDate
				ELSE	NULL
		END		AS		''Completed Date''
FROM	Services SS
JOIN	Programs P
ON		P.ProgramId = SS.ProgramId
AND		ServiceAreaId = ''2''  --Employer - Employee Assistance
JOIN	ProcedureCodes PC
ON		PC.ProcedureCodeId = SS.ProcedureCodeId
AND		ISNULL(PC.RecordDeleted,''N'')<>''Y''
JOIN	Locations L
ON		L.LocationId = SS.LocationId
AND		ISNULL(L.RecordDeleted,''N'')<>''Y''
JOIN	Clients C
ON		C.ClientId = SS.ClientId
AND		ISNULL(C.RecordDeleted,''N'')<>''Y''
JOIN	Staff S
ON		S.StaffId = SS.ClinicianId 
AND		ISNULL(S.RecordDeleted,''N'')<>''Y''
WHERE	SS.DateOfService >= @Start_Date
AND		SS.DateOfService < dateadd(day, 1, @End_Date)
AND		SS.STATUS NOT IN (''76'',''73'')--(''ER'', ''CA'')
AND		ISNULL(SS.RecordDeleted,''N'')<>''Y''
AND		P.ProgramName like @EAP_program
ORDER	BY
		SS.DateOfService
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~ END OF Code Translated by Jess ~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' 
END
GO
