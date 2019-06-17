/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientInformationBedBoardByClientId]    Script Date: 01/08/2014 14:34:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetClientInformationBedBoardByClientId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetClientInformationBedBoardByClientId]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientInformationBedBoardByClientId]    Script Date: 01/08/2014 14:34:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetClientInformationBedBoardByClientId] @ClientId INT
AS
BEGIN
/*********************************************************************/                                                                          
 /* Stored Procedure: [ssp_SCGetClientInformationBedBoardByClientId] */                                                                 
 /* Creation Date:  Aug 2013                                         */                                                                          
 /* Creation By : Akwinass                                           */                                                                          
 /* Purpose: To get Date of Birth and Gender for Census Management   */                                                                         
 /*                                                                  */                                                                        
 /* Input Parameters:  @ClientId                                     */                                                                        
 /*                                                                  */                                                                           
 /* Output Parameters:                                               */                                                                          
 /*                                                                  */                                                                          
 /* Return:                                                          */                                                                          
 /*                                                                  */                                                                          
 /* Called By: DataService Bedboard Class                            */
 /* 06-12-2013   Akwinass            isnull is checked for Sex  column*/
 /* 08-Jan-2014  Akwinass            Removed Unwanted Column from Select Query*/
 /* 22-May-2015  Akwinass            Included ClientName(Task #1279 in Philhaven - Customization Issues Tracking )*/
/*  21 Oct 2015	 Revathi			what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  */ 
/* 									why:task #609, Network180 Customization  */  
 /*********************************************************************/   
	SELECT Active		
		,ISNULL(Sex,'') as Sex
		,CONVERT(VARCHAR(10),DOB,101) as DOB
		--Added by Revathi 21 Oct 2015
		,CASE WHEN ISNULL(ClientType,'I')='I' THEN  ISNULL(LastName,'') + ', '+ ISNULL(FirstName,'') ELSE ISNULL(OrganizationName,'') end as ClientName		
	FROM Clients
	WHERE Clients.ClientId = @ClientId
		AND ISNULL(Clients.RecordDeleted, 'N') <> 'Y'

	IF (@@error != 0)
	BEGIN
		RAISERROR 20002 'ssp_SCGetClientInformationBedBoardByClientId'
	END
END



GO


