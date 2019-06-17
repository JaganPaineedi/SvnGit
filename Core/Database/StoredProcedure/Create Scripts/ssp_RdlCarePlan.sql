/****** Object:  StoredProcedure [dbo].[ssp_RdlCarePlan]    Script Date: 01/13/2015 15:39:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RdlCarePlan]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RdlCarePlan]
GO


/****** Object:  StoredProcedure [dbo].[ssp_RdlCarePlan]    Script Date: 01/13/2015 15:39:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[ssp_RdlCarePlan]                                         
 (
  @DocumentVersionId AS INT  
 )    
AS
     
/******************************************************************************************************/                                                          
/* Stored Procedure: ssp_RdlCarePlan                                                                  */                                                 
/*        */                                                          
/* Creation Date:  24 Dec 2014                                                                        */                                                          
/*                                                                                                    */                                                          
/* Purpose: Gets Data for ssp_RdlCarePlan                                                             */                                                         
/* Input Parameters: DocumentVersionId                                                                */                                                        
/* Output Parameters:                                                                                 */                                                          
/* Purpose: Use For Rdl Report                                                                        */                                                
/* Calls:                                                                                             */                                                           
/*                                                                                                    */                                                          
/* Author: Aravind                                                                                    */ 
/*Created As part for Core CarePlan  Module- Task #915 -Ability to CRUD Treatment Plans
							Valley - Customizations                                                   */ 
-- 11/30/2015	jcarlson	Modified logic to be able to return selected information if the document being displayed is a new version 
--							NDNW 164, rdl throws errors if the documentversionid is the inprogressdocumentversionid 
--28-April-2016 SuryaBalan Added add the org name for Task Pathway - Environment Issues Tracking #28
-- 4/5/2016      Pavani     Added DocumentName,SHOWORGANIZATIONNAMEONCAREPLANRDL ,
--                          Task #150  Bradford Customizations
/*****************************************************************************/      
BEGIN 
/*     jcarlson 11/30/2015
	SELECT @DocumentVersionId  AS DocumentVersionId
		, d.EffectiveDate
		, d.ClientId
	FROM Documents d 
	WHERE d.CurrentDocumentVersionId = @DocumentVersionId
	AND ISNULL(d.RecordDeleted,'N')<>'Y'   
	*/
	SELECT @DocumentVersionId AS DocumentVersionId
	,(select OrganizationName from SystemConfigurations) as OrganizationName
		,d.EffectiveDate
		,d.ClientId
		--Pavani  4/5/2016
		,(
			SELECT DocumentName
			FROM DocumentCodes
			WHERE DocumentcodeId = 1620
			) AS DocumentName
		,(
			SELECT upper(Value)
			FROM SystemConfigurationKeys
			WHERE [Key] = 'SHOWORGANIZATIONNAMEONCAREPLANRDL'
			) AS SHOWORGANIZATIONNAMEONCAREPLANRDL
	FROM DocumentVersions dv
	INNER JOIN Documents d ON dv.DocumentId = d.DocumentId
		AND isnull(d.RecordDeleted, 'N') = 'N'
	WHERE isnull(dv.RecordDeleted, 'N') = 'N'
		AND dv.DocumentVersionId = @DocumentVersionId
	
END

GO


