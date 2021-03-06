/****** Object:  StoredProcedure [dbo].[csp_Report_Missing_Admits]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Missing_Admits]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_Missing_Admits]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Missing_Admits]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE PROCEDURE [dbo].[csp_Report_Missing_Admits]
AS
--*/

SET NOCOUNT ON; 	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
/*********************************************************************/
/* Stored Procedure: csp_Report_Missing_Admits                       */
/* Creation Date:    05/01/2000		                                 */
/* Copyright:        Harbor Behavioral Healthcare 	                 */
/*                                                                   */
/*                   Processing Report (for patients with missing    */
/*                   admit dates or invalid admit date)              */
/* Purpose:          Called by Crystal Reports to run the Daily	     */
/*								                                     */
/* Input Parameters: none                                            */
/*                                                                   */
/* Output Parameters:                                                */
/*                                                                   */
/* Return Status:    0=success, -1= failure                          */
/*                                                                   */
/* Called By:        				                                 */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:                                                          */
/*      Date     Author        Purpose                               */
/*   05/01/2000 Kris Brahaney  Created                        	     */
/*   02/09/2006	Jess	       added nolock 						 */
/*   06/08/2012 Brian M        Coverted from Psychconsult            */
/*********************************************************************/

SELECT	SS.ServiceId,
		C.ClientId,     		
		C.LastName + '', '' + C.FirstName AS ''Client'',
		C.CurrentEpisodeNumber AS ''Episode'',
		L.LocationName,
		convert(varchar(10),SS.DateOfService,101) as proc_date,/* The following line pulls the date only out of a smalldatetime field */
		convert(varchar(10),SS.DateOfService,108) as proc_time,/* The following line pulls the time only out of a smalldatetime field */
		PC.DisplayAs AS ''ProcedureCode'',
		P.ProgramCode,
		S.LastName + '','' + S.FirstName as Staff,
		SS.DateOfService,
		CE.RegistrationDate,
		CE.DischargeDate,		--p.episode_close_date,
		CE.Status AS ''ClientEpisodeStatus'',
		SS.Status AS ''ServiceStatus''
			
FROM Clients C
	JOIN ClientEpisodes CE	
		ON (CE.ClientId = C.ClientId		
		AND ISNULL(CE.RecordDeleted,''N'')<>''Y'')
	JOIN Services     SS  
		ON	(C.ClientId = SS.ClientId
		AND ISNULL(C.RecordDeleted,''N'')<>''Y'')
	JOIN Programs P
		ON (P.ProgramId = SS.ProgramId
		AND ISNULL(P.RecordDeleted,''N'')<>''Y'')	
	JOIN ProcedureCodes PC
		ON (PC.ProcedureCodeId = SS.ProcedureCodeId
		AND ISNULL(PC.RecordDeleted,''N'')<>''Y'')
	JOIN Locations L
		ON (L.LocationId = SS.LocationId	
		AND ISNULL(L.RecordDeleted,''N'')<>''Y'')	
	JOIN Staff S 
		ON (S.StaffId = SS.ClinicianId      
		AND ISNULL(S.RecordDeleted,''N'')<>''Y'')
				
WHERE ((PC.DisplayAs = ''PART_HOSP'' AND SS.Status IN (''70'',''71''))  -- SC,SH,SP
		AND (CE.RegistrationDate IS NULL 
			OR (SS.DateOfService NOT BETWEEN CE.RegistrationDate AND CE.DischargeDate)))
		AND P.ServiceAreaId <> ''2'' --Employer - Employee Assistance   
		AND CE.Status <> ''102'' --Discharged Episode
		AND ISNULL(C.RecordDeleted,''N'')<>''Y''
ORDER BY 
		 L.LocationName,	
		 proc_date,
		 proc_time,
		 C.LastName,
		 C.FirstName' 
END
GO
