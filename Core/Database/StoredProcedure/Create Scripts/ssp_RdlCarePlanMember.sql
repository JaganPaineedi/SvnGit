/****** Object:  StoredProcedure [dbo].[ssp_RdlCarePlanMember]    Script Date: 01/12/2015 15:36:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RdlCarePlanMember]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RdlCarePlanMember]
GO


/****** Object:  StoredProcedure [dbo].[ssp_RdlCarePlanMember]    Script Date: 01/12/2015 15:36:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

/***************************************************************************************************************************/                                                          
/* Stored Procedure: ssp_RdlCarePlanMember        */                                                 
/*        */                                                          
/* Creation Date:  4Jan2011                             */                                                          
/*                                                        */                                                          
/* Purpose: Gets Data for ssp_RdlCarePlanMember       */                                                         
/* Input Parameters: DocumentVersionId        */                                                        
/* Output Parameters:             */                                                          
/* Purpose: Use For Rdl Report           */                                                
/* Calls:                */                                                          
/*                  */                                                          
/* Author: Rohit Katoch             */   
/* 26 Dec 2014  Aravind             Modified As part for Core CarePlan  Module- Task #915 -Ability to CRUD Treatment Plans
							         Valley - Customizations */ 
/* 31 Jul 2015  Venkatesh           Modified As part for Core CarePlan  Module- Task #251 -Care Plan - PDF Header
									Valley Client Acceptence Testing */ 
/*22-DEC-2015 Basudev Sahu			Modified For Task #609 Network180 Customization to Get Organisation  As ClientName	*/
/*********************************************************************?********************************************************/
                        
CREATE PROCEDURE [dbo].[ssp_RdlCarePlanMember] --180                                         
 (
  @DocumentVersionId AS INT  
 )    
AS      
BEGIN      
	 Select           
	DC.CurrentDocumentVersionId,
	DC.ClientId,
	(
	CASE     
	WHEN ISNULL(C.ClientType, 'I') = 'I'
	 THEN ISNull(C.FirstName,'') +' '+ISNull(C.MiddleName,'')+' '+ISNull(C.LastName,'')
	ELSE ISNULL(C.OrganizationName, '')
	END 
	--ISNull(C.FirstName,'') +' '+ISNull(C.MiddleName,'')+' '+ISNull(C.LastName,'')
	) AS [Name],
	DCP.NameInGoalDescriptions AS Alias  
	,Convert(varchar(10),C.DOB,101) as DateOfBirth
	,CONVERT(VARCHAR(10),DC.EffectiveDate,101) as EffectiveDate 
	FROM Documents DC 
	INNER JOIN Clients C ON C.ClientId=DC.ClientId 
	INNER JOIN DocumentCarePlans DCP ON DC.CurrentDocumentVersionId=DCP.DocumentVersionId            
	WHERE ISNull(C.RecordDeleted,'N')='N'
	AND ISNull(DC.RecordDeleted,'N')='N'
	AND ISNull(DCP.RecordDeleted,'N')='N'
	AND DC.CurrentDocumentVersionId=@DocumentVersionId          
	  
   
END

GO



