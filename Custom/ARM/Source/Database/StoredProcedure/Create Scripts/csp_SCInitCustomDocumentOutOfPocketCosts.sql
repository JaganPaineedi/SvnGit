/****** Object:  StoredProcedure [dbo].[csp_SCInitCustomDocumentOutOfPocketCosts]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCInitCustomDocumentOutOfPocketCosts]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCInitCustomDocumentOutOfPocketCosts]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCInitCustomDocumentOutOfPocketCosts]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROC [dbo].[csp_SCInitCustomDocumentOutOfPocketCosts]
(
	 @ClientID int,                                
	 @StaffID int,                              
	 @CustomParameters xml                                                      
)
as
/************************************************************************/                                                              
/* Stored Procedure: csp_SCInitCustomDocumentOutOfPocketCosts        */                                                     
/*        */                                                              
/* Creation Date:  03 July 2012           */                                                              
/*                  */                                                              
/* Purpose: Gets Data for Out-Of-Pocket       */                                                             
/* Input Parameters: @StaffId, @ClientId, @CustomParameters        */                                                            
/* Output Parameters:             */                                                              
/* Purpose: to initialized         */                                                    
/* Calls:                */                                                              
/*                  */                                                              
/* Author: Sudhir Singh             */ 
/*********************************************************************/ 
BEGIN

	SELECT top 1 
		Placeholder.TableName,
		ISNULL(DocumentVersionId,-1) AS DocumentVersionId  
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
	FROM (SELECT ''CustomDocumentOutOfPocketCosts'' AS TableName) AS Placeholder      
	LEFT JOIN [CustomDocumentOutOfPocketCosts] ON ( DocumentVersionId  = -1 AND ISNULL(RecordDeleted,''N'') <> ''Y'' ) 
end



' 
END
GO
