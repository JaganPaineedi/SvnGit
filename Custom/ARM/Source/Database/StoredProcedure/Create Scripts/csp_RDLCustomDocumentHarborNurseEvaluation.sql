/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentHarborNurseEvaluation]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentHarborNurseEvaluation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentHarborNurseEvaluation]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentHarborNurseEvaluation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
 CREATE Procedure [dbo].[csp_RDLCustomDocumentHarborNurseEvaluation]  
 @DocumentVersionId INT  
 AS  
 /*********************************************************************/                                                                                        
 /* Stored Procedure: csp_RDLCustomDocumentHarborNurseEvaluation	  */                                                                               
 /* Creation Date:  11/May/2012				                          */                                                                                        
 /* Purpose: To Get The Nurse Evaluation		   					  */                                                                                       
 /* Input Parameters: @DocumentVersionId							  */                                                                                      
 /* Output Parameters:												  */                                                                                        
 /* Return:															  */                                                                                        
 /* Called By:Report For Release of information					      */                                                                              
 /* Calls:                                                            */                                                                                        
 /*                                                                   */                                                                                        
 /* Data Modifications:                                               */                                                                                        
 /* Updates:                                                          */                                                                                        
 /* Date              Author                  Purpose				  */       
 /* 11/May/2012       Vikas Kashyap           Create	   		      */   
 /*********************************************************************/     
    
  Begin                              
  Begin TRY   
  
  SELECT               
         CDNHE.DocumentVersionId    
        ,CDNHE.CreatedBy
		,CDNHE.CreatedDate
		,CDNHE.ModifiedBy
		,CDNHE.ModifiedDate
		,CDNHE.RecordDeleted
		,CDNHE.DeletedBy
		,CDNHE.DeletedDate
		,CDNHE.ReasonForReferral
		,CDNHE.ExplainedPharmacologicManagement
		,CDNHE.ClientHasLegalGuardian
		,CDNHE.LegalGuardianConsentObtained
		,CDNHE.LegalGuardianConsentComment
		,CDNHE.VitalSignsObtained
		,CDNHE.NoHealthConditionsReported
		,CDNHE.HealthConditionsReported
		,CDNHE.HealthConditionsComment
		,CDNHE.SubstanceUseNoneAlcohol
		,CDNHE.SubstanceUseCurrentAlcohol
		,CDNHE.SubstanceUsePastAlcohol
		,CDNHE.SubstanceUseNoneTobacco
		,CDNHE.SubstanceUseCurrentTobacco
		,CDNHE.SubstanceUsePastTobacco
		,CDNHE.SubstanceUseNoneDrugs
		,CDNHE.SubstanceUseCurrentDrugs
		,CDNHE.SubstanceUsePastDrugs
		,CDNHE.SubstanceUseComment
		,CDNHE.MedicationReconciliationComplete
		,CDNHE.ReviewOfAllergiesComplete
		,CDNHE.OtherTreatmentProvidedIn12Months
		,CDNHE.OARRSChecked
		,CDNHE.OARRSHasItemsOfConcern
		,CDNHE.OOARSItemsOfConcernComment
		,CDNHE.PhamacologicServicesRecommended
		,CDNHE.AdditionalGoalsRequired
		,Convert(varchar(10),CDNHE.PsychiatricEvalDate,101) AS PsychiatricEvalDate
		,CDNHE.PreviousTreatmentComment             
 FROM  CustomDocumentHarborNurseEvaluations AS CDNHE  
 WHERE ISNull(CDNHE.RecordDeleted,''N'')=''N'' AND CDNHE.DocumentVersionId=@DocumentVersionId   
 
  END TRY                                                                          
  BEGIN CATCH                              
  DECLARE @Error varchar(8000)                                                                           
  SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                     
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_RDLCustomDocumentHarborNurseEvaluation'')                                                                                                         
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                                                          
    + ''*****'' + Convert(varchar,ERROR_STATE())                          
   RAISERROR                                                                                                         
   (                                                                           
    @Error, -- Message text.                                                                                                        
    16, -- Severity.                                                                                                        
    1 -- State.                                                                                                        
   );                                                                                                      
  END CATCH                                                     
  END       
' 
END
GO
