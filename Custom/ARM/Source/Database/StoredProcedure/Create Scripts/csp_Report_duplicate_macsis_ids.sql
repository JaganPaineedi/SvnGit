/****** Object:  StoredProcedure [dbo].[csp_Report_duplicate_macsis_ids]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_duplicate_macsis_ids]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_duplicate_macsis_ids]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_duplicate_macsis_ids]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_Report_duplicate_macsis_ids] AS

/****************************************************************/
/* Stored Procedure: csp_duplicate_macsis_ids					*/
/* Creation Date:    03/20/2001		                            */
/* Copyright:        Harbor										*/
/*                                                              */
/* Purpose:          Called by Crystal Reports 					*/
/*                 												*/
/* Updates:														*/
/*      Date     Author        Purpose							*/
/*   03/20/2001 Kris Brahaney  Created							*/
/*   02/02/2006 Jess	       added nolock						*/
/*   07/01/2012 Jess	       Converted from Psych Consult		*/
/****************************************************************/

SELECT	C.ClientId,
		C.LastName + '', '' + C.FirstName as ''Client'',
		C.DOB,
		C.SSN,
		CC.MACUCI
FROM	CustomClients CC
JOIN	Clients C
ON		CC.ClientId = C.ClientId
WHERE	CC.MACUCI in	(	SELECT	CC2.MACUCI
							FROM	CustomClients CC2
							WHERE	CC2.MACUCI is not null
							AND		CC2.MACUCI <> ''''
							GROUP	BY	CC2.MACUCI
							HAVING	COUNT(DISTINCT CC2.ClientId) > 1
						)
' 
END
GO
