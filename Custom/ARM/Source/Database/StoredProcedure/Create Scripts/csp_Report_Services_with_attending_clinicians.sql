/****** Object:  StoredProcedure [dbo].[csp_Report_Services_with_attending_clinicians]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Services_with_attending_clinicians]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_Services_with_attending_clinicians]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Services_with_attending_clinicians]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
--/*
CREATE PROCEDURE [dbo].[csp_Report_Services_with_attending_clinicians]
	@start_date datetime,
	@end_date datetime
AS
--*/

/*
DECLARE @start_date datetime,
		@end_date datetime
	
Select @start_date = ''06/1/12''
Select @end_date = ''6/17/12''
--*/

/*********************************************************************/
/* Stored Procedure: csp_transaction .SQL							 */
/* Creation Date:    09/04/2003                                      */
/* Copyright:    Harbor Behavioral Healthcare                        */
/*                                                                   */
/* Updates:                                                          */
/*Date       	Author   Purpose								     */
/*09/04/2003	Li  Qin  Created									 */
/*02/24/2006	Jess	 changed proc_chron -> appt)date			 */
/*06/20/2012    Brian M  Coverted from PsychConsult                  */
/*																     */
/*********************************************************************/

SELECT	SS.ClinicianId,
		S.LastName + '', '' + S.FirstName  AS ''Clinician Name'',
		SS.AttendingId,
		S1.LastName + '', '' + S1.FirstName AS ''Attending Name'',
		dbo.csf_GetGlobalCodeNameById(SS.Status) AS ''Status'',
		SS.ClientId,
		convert(char(10), SS.DateOfService,101) AS ''DateOfService'',
		PC.DisplayAs --procedure code
			
FROM Services SS
	JOIN Staff S
		ON (S.StaffId = SS.ClinicianId		
		AND ISNULL(S.RecordDeleted,''N'')<>''Y'')	
	JOIN Staff S1 
		ON (S1.StaffId = SS.AttendingId 
		AND ISNULL(S1.RecordDeleted,''N'')<>''Y'')
	JOIN ProcedureCodes PC
		ON (PC.ProcedureCodeId = SS.ProcedureCodeId
		AND ISNULL(PC.RecordDeleted,''N'')<>''Y'')

WHERE (SS.DateOfService >= @start_date
	AND SS.DateOfService < dateadd(day, 1, @end_date))
	AND SS.ClinicianId <> SS.AttendingId 
	AND ISNULL(SS.RecordDeleted,''N'')<>''Y''

order by ''Clinician Name'', ''Attending Name'', ''DateOfService''


' 
END
GO
