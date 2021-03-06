/****** Object:  StoredProcedure [dbo].[csp_Report_minors_with_no_fin_responsible_relation]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_minors_with_no_fin_responsible_relation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_minors_with_no_fin_responsible_relation]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_minors_with_no_fin_responsible_relation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE PROCEDURE [dbo].[csp_Report_minors_with_no_fin_responsible_relation] 
	@location	varchar(10)
AS
--*/

/*
DECLARE	@location	varchar(10)
SELECT	@location = 	''%''
--*/

SET NOCOUNT ON;	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
/****************************************************************/
/* Stored Procedure: csp_minors_with_no_fin_responsible_relation*/
/* Creation Date:    06/22/2006									*/
/* Copyright:    Harbor Behavioral Healthcare					*/
/*																*/
/* Called By: Minors Without Fin Responsible Relation.rpt		*/
/*																*/
/* Input Parameters: @location									*/
/*																*/
/* Updates:														*/
/* Date		Author		Purpose									*/
/* 06/22/2006	Jess		Created	- WO 4217					*/
/* 06/15/2012   Brian M	 Coverted from PsychConsult				*/
/****************************************************************/
   
SELECT	
	CASE WHEN	CC.Location IS Null
			THEN 	''UNSPECIFIED'' 
		 ELSE	L.LocationName
	END	AS	''Location'',
	C.ClientId,
	C.LastName + '', '' + C.FirstName AS ''Client Name'',
	CE.RegistrationDate,
	S.LastName + '', '' + S.FirstName AS ''Intake Staff''
FROM Clients C 
	JOIN ClientEpisodes CE
		ON CE.ClientId = C.ClientId
		AND	CE.EpisodeNumber = C.CurrentEpisodeNumber
		AND ISNULL(CE.RecordDeleted,''N'')<>''Y'' 
	LEFT JOIN CustomClients CC
		ON C.ClientId = CC.ClientId			
		AND ISNULL(CC.RecordDeleted,''N'')<>''Y'' 
	 LEFT JOIN Locations L
		ON L.LocationId = CC.Location
		AND	L.LocationCode LIKE @location
		AND ISNULL(L.RecordDeleted,''N'')<>''Y''
	 LEFT JOIN Staff S 
		ON	S.Staffid = CE.IntakeStaff 
		AND ISNULL(S.RecordDeleted,''N'')<>''Y''	
WHERE	C.Active = ''Y''
/*
		AND	(	C.FinanciallyResponsible <> ''Y''
			OR	C.FinanciallyResponsible  is null
			)
--*/
		AND	NOT EXISTS	(
				SELECT	CCS.ClientId
				FROM	ClientContacts CCS 
				WHERE	C.ClientId = CCS.ClientId			
				AND	CCS.FinanciallyResponsible = ''Y''
			)
		AND	C.DOB > dateadd(yy, -18, getdate())
		AND ISNULL(C.RecordDeleted,''N'')<>''Y''
		
ORDER BY
	''Location'',
	''Client Name''' 
END
GO
