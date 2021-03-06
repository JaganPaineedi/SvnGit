/****** Object:  StoredProcedure [dbo].[csp_Report_missing_primary_assigment]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_missing_primary_assigment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_missing_primary_assigment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_missing_primary_assigment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE PROCEDURE [dbo].[csp_Report_missing_primary_assigment]
	@location varchar(20)
AS
--*/

/*
declare @location varchar(20)
select @location = ''secor''
--*/

SET NOCOUNT ON;   -- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
/*********************************************************************/
/* Stored Procedure: csp_missing_prim_assignment                     */
/* Creation Date:    08/23/2001                                      */
/* Copyright:      Harbor Behavioral Healthcare                      */
/*                                                                   */
/* Purpose: List open case patients who are missing primary          */
/* assignment and have at least one billable service, won''t list     */
/* clients who only have nonbillable services                        */
/* Input Parameters:             				                     */
/*								                                     */
/* Output Parameters:                                                */
/*                                                                   */
/* Return Status:  0=success                                         */
/*                                                                   */
/* Called By: Missing Primary Assignment Report                      */
/*                                                                   */
/* Calls: 		                                                     */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:                                                          */
/*   Date       Author      Purpose                                  */
/*   08/23/2001 Qin        Created                                   */
/*   02/27/2002 Qin        modified                                  */
/*   02/03/2006 Jess       added nolock                              */
/*   02/22/2006	Jess	   removed clinician_id			             */
/*   04/25/2007	Jess	   modified per WO 6290			             */
/*   02/22/2008	Jess	   modified for efficiency and accuracy	     */
/*   06/01/2012 Brian M    Converted from Psychconsult               */
/*********************************************************************/

IF	@location is null
SELECT	@location = ''%''

SELECT DISTINCT
	C.ClientId,
	C.CurrentEpisodeNumber, 
	C.LastName + '', '' + C.FirstName as ''Client'',
	CE.RegistrationDate,
	CASE	WHEN	l.LocationCode is null
			THEN	''Unknown''
			ELSE	l.LocationCode
	END	AS	''LocationCode'',           
	max(S.DateOfService) as ''last_date_of_service'',
	CASE	WHEN	@location = ''%''
			THEN	''All Locations''
			ELSE	l.LocationCode
	END	AS	''Input''
FROM Clients C 
LEFT JOIN	CustomClients CC -- Temporary added Left JOIN, no data in table currently   
	ON (C.ClientId = CC.ClientId
		--AND	p.episode_id = pc.episode_id
		AND ISNULL(CC.RecordDeleted,''N'')<>''Y'')
LEFT JOIN Locations L		-- Temporary added Left JOIN, no data in table currently 
	ON (L.LocationId = CC.Location -- Client''s Primary Location
		AND L.LocationCode like @location
		AND ISNULL(L.RecordDeleted,''N'')<>''Y'')			
JOIN ClientEpisodes CE
	ON (CE.ClientId = C.ClientId
	--	AND CE.RegistrationDate is not null  -- Temporary commented out, verify how smartcare uses this.
		AND	CE.DischargeDate is null
		AND ISNULL(CE.RecordDeleted,''N'')<>''Y'')	
JOIN ClientPrograms CP 
	ON (CP.ClientId = C.ClientId
		--AND	p.episode_id = pa.episode_id
		AND	CP.Status <> 5 --Global Code Discharge 
		AND ISNULL(CP.RecordDeleted,''N'')<>''Y'')
JOIN Services S 
	ON (C.ClientId = S.ClientId
		--AND	p.episode_id = pct.episode_id c.CurrentEpisodeNumber
		AND	S.Status in  (71,75)--(''SH'', ''CO'')
		AND S.Billable = ''Y''
		AND ISNULL(S.RecordDeleted,''N'')<>''Y'')
WHERE  C.Active = ''Y''
	AND	NOT	EXISTS	(
			SELECT	CP.ClientProgramId
			FROM	ClientPrograms CP
			WHERE	C.ClientId = CP.ClientId
				--AND	p.episode_id = pa.episode_id C.CurrentEpisodeNumber
				AND	CP.PrimaryAssignment = ''Y''
				AND	CP.Status <> 5			-- Program not Discharged
				AND ISNULL(CP.RecordDeleted,''N'')<>''Y''
			)
GROUP BY
	C.LastName,
	C.FirstName,
	C.ClientId,
	C.CurrentEpisodeNumber,   
	CE.RegistrationDate,
	L.LocationCode

ORDER BY
	''Client''

' 
END
GO
