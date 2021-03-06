/****** Object:  StoredProcedure [dbo].[csp_Report_find_client_by_MACUCI]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_find_client_by_MACUCI]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_find_client_by_MACUCI]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_find_client_by_MACUCI]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE	PROCEDURE	[dbo].[csp_Report_find_client_by_MACUCI]
	@MACUCI varchar(35) = null
AS
--*/

/*
DECLARE		@MACUCI varchar(35)
SELECT		@MACUCI = ''%''--''1931734''
--*/

/****************************************************************/
/* Stored Procedure: csp_Report_find_client_by_MACUCI			*/
/* Creation Date:    1/5/2002		                            */
/* Copyright:        Harbor										*/
/*                                                              */
/* Updates:														*/
/*	Date		Author			Purpose							*/
/*	01/05/2002					Created							*/
/*	02/03/2006	Jess			added nolock					*/
/*	07/02/2012	Jess			Converted from Psych Consult	*/
/****************************************************************/


SELECT	C.ClientId,
		C.FirstName + '' '' + C.LastName as ''Client'',
		CC.MACUCI,
		CASE	WHEN	C.Active = ''N''
				THEN	''Inactive''
	     		WHEN	C.Active = ''Y''
				THEN	''Active''
		End		AS		''Status''
FROM		Clients C
LEFT JOIN	CustomClients CC
ON			C.ClientId = CC.ClientId
WHERE	CC.MACUCI like @MACUCI
ORDER	BY
		C.LastName' 
END
GO
