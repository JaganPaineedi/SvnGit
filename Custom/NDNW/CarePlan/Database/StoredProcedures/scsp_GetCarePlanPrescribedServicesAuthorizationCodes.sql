

/****** Object:  StoredProcedure [dbo].[Scsp_SCClientMemberOrder]    Script Date: 08/01/2013 18:29:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_GetCarePlanPrescribedServicesAuthorizationCodes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_GetCarePlanPrescribedServicesAuthorizationCodes]
GO



/****** Object:  StoredProcedure [dbo].[scsp_GetCarePlanPrescribedServicesAuthorizationCodes]    Script Date: 08/01/2013 18:29:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[scsp_GetCarePlanPrescribedServicesAuthorizationCodes]    
/*******************************************************************************
* Author:		Neelima
* Create date: 03/22/2019
* Description:	Initializing InterventionDetails of CarePlanPrescribedServices table. 	
* Why: New Directions - Support Go Live #932	  
*	Date		Author			Reason      
																
*******************************************************************************/
    
	@ClientID INT
	,@DocumentVersionId INT
	,@FlagInitGet CHAR(1)   
     
AS    
BEGIN    
	IF EXISTS (	SELECT *
				FROM sys.objects
				WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetCarePlanPrescribedServicesAuthorizationCodes]')
				AND type IN (N'P',N'PC'))
	BEGIN      
		EXEC csp_GetCarePlanPrescribedServicesAuthorizationCodes @ClientId,@DocumentVersionId,@FlagInitGet
	END      
 
RETURN    
END 




GO


