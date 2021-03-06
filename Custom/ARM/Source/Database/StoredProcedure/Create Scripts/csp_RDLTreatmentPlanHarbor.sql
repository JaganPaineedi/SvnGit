/****** Object:  StoredProcedure [dbo].[csp_RDLTreatmentPlanHarbor]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLTreatmentPlanHarbor]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLTreatmentPlanHarbor]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLTreatmentPlanHarbor]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'      
/************************************************************************/                                                          
/* Stored Procedure: csp_RDLTreatmentPlanHarbor        */                                                 
/*        */                                                          
/* Creation Date:  22 June 2011           */                                                          
/*                  */                                                          
/* Purpose: Gets Data for csp_RDLTreatmentPlanHarbor       */                                                         
/* Input Parameters: DocumentVersionId        */                                                        
/* Output Parameters:             */                                                          
/* Purpose: Use For Rdl Report           */                                                
/* Calls:                */                                                          
/*                  */                                                          
/* Author: Davinder Kumar             */                                                          
/*********************************************************************/       
/* Updated by Jagdeep Hundal ( Added   OrganizationName)           */  
/* 01.31.2012 - T Remisoski - Changed EffectiveDate format and return document name. */
/* 02.06.2012 - RohitK      - Changed EffectiveDate format as MM/DD/YYYY. */
/* 22.12.2017 - Kavya.N     - Changed clientname and ClinicianName format to (Firstname Lastname) */
/*******************************************************************************/

CREATE PROCEDURE [dbo].[csp_RDLTreatmentPlanHarbor]         
 -- Add the parameters for the stored procedure here      
 @DocumentVersionId AS INT      
AS      
BEGIN      
      
  SELECT D.ClientId       
     ,CONVERT(VARCHAR(10),D.EffectiveDate,101) as EffectiveDate      
     ,C.FirstName+ '' '' + C.LastName  as ClientName        
     ,ST.FirstName + '' '' + ST.LastName as ClinicianName      
     ,CTP.CurrentDiagnosis      
     ,CTP.ClientStrengths      
     ,CTP.DischargeTransitionCriteria      
     ,CTP.DocumentVersionId      
     ,CTP.ClientParticipatedAndIsInAgreement      
     ,(Select OrganizationName from SystemConfigurations) as OrganizationName      
     ,CTP.ReasonForUpdate    
     ,D.DocumentCodeId 
     ,isnull(CTP.ClientDidNotParticipate,''N'') as ClientDidNotParticipate
     ,CTP.ClientDidNotParticpateComment
     ,isnull(CTP.ClientParticpatedPreviousDocumentation,''N'') as  ClientParticpatedPreviousDocumentation
     ,dc.DocumentName
  FROM CustomTreatmentPlans AS CTP  INNER JOIN DocumentVersions DV on CTP.DocumentVersionId=DV.DocumentVersionId   
  INNER JOIN Documents AS D ON D.DocumentId = DV.DocumentId and isnull(DV.RecordDeleted,''N'')<>''Y''  
  INNER JOIN Clients C ON C.ClientId=D.ClientId     
  INNER JOIN Staff ST ON ST.StaffId = d.AuthorId
  inner join dbo.DocumentCodes as dc on dc.DocumentCodeId = d.DocumentCodeId     
  WHERE CTP.DocumentVersionId=@DocumentVersionId AND (ISNULL(CTP.RecordDeleted, ''N'') = ''N'')     
  and ISNULL(D.RecordDeleted,''N'')=''N''                      
        
END 
' 
END
GO
