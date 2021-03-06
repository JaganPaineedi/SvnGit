/****** Object:  StoredProcedure [dbo].[csp_Report_missing_primary_clinician]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_missing_primary_clinician]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_missing_primary_clinician]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_missing_primary_clinician]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE PROCEDURE [dbo].[csp_Report_missing_primary_clinician] 
	@location varchar(20)
AS
--*/

--DECLARE	@location varchar(20)

SET NOCOUNT ON; -- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
/**********************************************************/
/* Stored Procedure: csp_Report_missing_primary_clinician */
/*												          */
/* Called By: Missing Primary Clinician.rpt		          */
/*												          */
/* Updates:										          */
/*   Date       Author	Purpose					          */
/*   05/06/2008	Jess	Created					          */	
/*	 06/01/2012	Brian M Converted from Psychconsult       */
/**********************************************************/

IF	@location is null
SELECT	@location = ''%''

SELECT DISTINCT
	C.ClientId,
	C.CurrentEpisodeNumber, --episode_id,
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
LEFT JOIN	CustomClients CC   
	ON (C.ClientId = CC.ClientId
		--AND	p.episode_id = pc.episode_id
		AND ISNULL(CC.RecordDeleted,''N'')<>''Y'')
LEFT JOIN Locations L		-- Temporary added Left JOIN, no data in table currently 
	ON (L.LocationId = CC.Location 
		AND L.LocationCode like @location	-- Client''s Primary Location
		AND ISNULL(L.RecordDeleted,''N'')<>''Y'')
JOIN ClientEpisodes CE
	ON (CE.ClientId = C.ClientId
	--	AND CE.RegistrationDate is not null
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
		--AND S.Billable = ''Y''
		AND ISNULL(S.RecordDeleted,''N'')<>''Y'')
WHERE C.Active = ''Y''
AND		C.PrimaryClinicianId is Null 
AND		C.LastName <> ''Public''
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
