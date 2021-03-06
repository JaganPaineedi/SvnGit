/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentOutOfPocketCosts]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentOutOfPocketCosts]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentOutOfPocketCosts]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentOutOfPocketCosts]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N' CREATE PROCEDURE  [dbo].[csp_RDLCustomDocumentOutOfPocketCosts]                     
(                                                                                                                                                                                                      
  @DocumentVersionId int                                                                                                                                                                            
)                                                                                                                                                                                                      
As                                                                                                                                                     
/************************************************************************/                                                              
/* Stored Procedure: csp_RDLCustomDocumentOutOfPocketCosts        */                                                     
/*        */                                                              
/* Creation Date:  03 July 2012           */                                                              
/*                  */                                                              
/* Purpose: Gets rdl Data for Out-Of-Pocket       */                                                             
/* Input Parameters: @DocumentVersionId        */                                                            
/* Output Parameters:             */                                                              
/* Purpose: to getdata         */                                                    
/* Calls:                */                                                              
/*                  */                                                              
/* Author: Sudhir Singh             */ 
/*********************************************************************/  
BEGIN TRY                                   
BEGIN              
      
	SELECT   
		DocumentVersionId    
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedBy
		,DeletedDate
		,OutOfPocketCostDiscription
		,InNetIndividualFamilyTherapyCost
		,InNetPsychologicalCost
		,InNetGroupTherapyCost
		,InNetCrisisInterventionCost
		,InNetDiagnosticAssessmentCost
		,InNetMedicationSomaticCost
		,OutNetIndividualFamilyTherapyCost
		,OutNetPsychologicalCost
		,OutNetGroupTherapyCost
		,OutNetCrisisInterventionCost
		,OutNetDiagnosticAssessmentCost
		,OutNetMedicationSomaticCost
		,PatientId
		,PrimaryInsDOB
		,PrimaryInsCoName
		,PrimaryId
		,PrimaryInsCoPhone
		,PrimaryGroupName
		,Contact
		,PrimaryEmployer
		,EffectiveDate
		,IndividualContract
		,FamilyContract
		,IsHarborNetworkProvider
		,TypeOfPlan
		,PreExistingClause
		,PreCertification
		,EligibilityProvider
		,COB
		,MailingAddress
		,InNetOutPatientVisit
		,OutNetOutPatientVisit
		,PrimaryPolicyHolderName
		,PatientName
		,ServicesCovered
		,Benifits 
FROM  
CustomDocumentOutOfPocketCosts 
Where ISNULL(RecordDeleted,''N'')=''N''   
AND DocumentVersionId=@DocumentVersionId    
              
 END                                                                                      
 END TRY                                                                                               
 BEGIN CATCH                                                 
   DECLARE @Error varchar(8000)                                                                                                                               
   SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                    
   + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_RDLCustomDocumentOutOfPocketCosts'')                   
   + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****ERROR_SEVERITY='' + Convert(varchar,ERROR_SEVERITY())                                                                                    
   + ''*****ERROR_STATE='' + Convert(varchar,ERROR_STATE())                                                                                                                          
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                   
                                                                                                                              
 END CATCH ' 
END
GO
