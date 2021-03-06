/****** Object:  StoredProcedure [dbo].[ssp_PMGetClientNameById]    Script Date: 11/18/2011 16:25:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMGetClientNameById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMGetClientNameById]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMGetClientNameById]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ssp_PMGetClientNameById] @ClientId INT
AS
/*********************************************************************/
/* Stored Procedure: ssp_PMGetClientNameById                                                          */
/* Copyright: 2006 Streanline Practice Management Application                                                    */
/* Creation Date:  07 Dec 2006                                                                                     */
/*                                                                                                                           */
/* Purpose:  fetches the LastNAme & FirstName from Clients on the basis on clientid          */
/*                                                                                                                                          */
/* Input Parameters:  @ClientId  */
/*                                                                   */
/*                                                                                                                              */
/*                                                                                                                              */
/*                                                                                                                              */
/* Called By:  Funtions.cs                                                                                                           */
/*                                                                                                                              */
/* Calls:                                                                                                                     */
/*                                                                                                                              */
/* Data Modifications:                                                                                               */
/*                                                                                                                            */
/* Created on , Created By:                                                                                          */
/*  Date              Author                Purpose                                                                   */
/* 07 Dec 2006  Bhupinder Bajwa				Created                                                                        */
/*Modified on,  Modified By                        */
/* 19 Oct 2015  Revathi						what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.      
											why:task #609, Network180 Customization */
/****************************************************************************/
--Enumeration used   
BEGIN
	SELECT
	--Added by Revathi  19 Oct 2015
	CASE 
			WHEN ISNULL(ClientType, ''I'') = ''I''
				THEN rtrim(ISNULL(LastName, '''')) + '', '' + rtrim(ISNULL(FirstName, ''''))
			ELSE ISNULL(OrganizationName, '''')
			END
	FROM Clients
	WHERE ClientId = @ClientId
END

IF (@@error != 0)
BEGIN
	RAISERROR 20006 ''ssp_PMGetClientNameById: An Error Occured''

	RETURN
END
' 
END
GO
