

/****** Object:  StoredProcedure [dbo].[ssp_RDLCarePlanPrescribedServices]    Script Date: 01/13/2015 12:46:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLCarePlanPrescribedServices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLCarePlanPrescribedServices]
GO



/****** Object:  StoredProcedure [dbo].[ssp_RDLCarePlanPrescribedServices]    Script Date: 01/13/2015 12:46:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RDLCarePlanPrescribedServices]  --292,29     
 (
 @DocumentVersionId  int,
 @CarePlanObjectiveId int
 )
AS 
      
/************************************************************************/                                                          
/* Stored Procedure: ssp_RDLCarePlanPrescribedServices        */                                                 
/*                                         */                                                          
/* Creation Date:  21 Dec 2011                             */                                                          
/*                                                        */                                                          
/* Purpose: Gets Data for ssp_RDLCarePlanPrescribedServices       */                                                         
/* Input Parameters:         */                                                        
/* Output Parameters:             */                                                          
/* Purpose: Use For Rdl Report           */                                                
/* Calls:                */                                                          
/*                  */                                                          
/* Author: Rohit Katoch             */  
/* 26 Dec 2014  Aravind             Modified As part for Core CarePlan  Module- Task #915 -Ability to CRUD Treatment Plans
							         Valley - Customizations                                                                */
/* 14-July Changed the join to Left join with CarePlanPrescribedServiceObjectives table*/							                                                               
/*******************************************************************************************************************************/           
BEGIN      
 SELECT   
 AC.DisplayAs As AuthorizationCodeName  
,CPPS.CarePlanPrescribedServiceId  
,CPPS.[CreatedBy]  
,CPPS.[CreatedDate]  
,CPPS.[ModifiedBy]  
,CPPS.[ModifiedDate]  
,CPPS.[RecordDeleted]  
,CPPS.[DeletedDate]  
,CPPS.[DeletedBy]  
,@DocumentVersionId  AS DocumentVersionId    
,CPPS.[NumberOfSessions]  
,CPPS.[Units]  
--,CCPS.[UnitType]  
,isnull(convert(nvarchar,CPPS.[Units]),'')+'  '+isnull(dbo.csf_GetGlobalCodeNameById(CPPS.[UnitType]),'') as [UnitType]
,dbo.csf_GetGlobalCodeNameById(CPPS.[FrequencyType]) as [FrequencyType] 
--,CCPS.[FrequencyType]  
--,CCPS.[PersonResponsible]  
,dbo.csf_GetGlobalCodeNameById(CPPS.[PersonResponsible]) as PersonResponsible
--,CDCP.[OverallProgress]
FROM   CarePlanPrescribedServices CPPS  
LEFT JOIN CarePlanPrescribedServiceObjectives CPPSO ON   CPPSO.CarePlanPrescribedServiceId=CPPS.CarePlanPrescribedServiceId
LEFT JOIN AuthorizationCodes   AC ON AC.AuthorizationCodeId = CPPS.AuthorizationCodeId  
LEFT JOIN [DocumentCarePlans] DCP ON DCP.DocumentVersionId = CPPS.DocumentVersionId
WHERE ISNULL(AC.RecordDeleted,'N')<>'Y'  
AND ISNULL(CPPS.RecordDeleted,'N')<>'Y'  
AND ISNULL(CPPSO.RecordDeleted,'N')<>'Y'  
AND ISNULL(DCP.RecordDeleted,'N')<>'Y'  
AND CPPSO.[CarePlanObjectiveId]=@CarePlanObjectiveId
And CPPS.DocumentVersionId = @DocumentVersionId        
 
 END

GO

--select * from AuthorizationCodes
--select * from CarePlanPrescribedServices

--Update CarePlanPrescribedServices set RecordDeleted=Null where CarePlanPrescribedServiceId=1
--select * from CarePlanPrescribedServiceObjectives

