/****** Object:  StoredProcedure [dbo].[csp_SCInitCustomDocumentHarborNurseEvaluation]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCInitCustomDocumentHarborNurseEvaluation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCInitCustomDocumentHarborNurseEvaluation]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCInitCustomDocumentHarborNurseEvaluation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N' 
Create PROCEDURE  [dbo].[csp_SCInitCustomDocumentHarborNurseEvaluation]                   
(                                                    
 @ClientID int,                              
 @StaffID int,                            
 @CustomParameters xml                                                    
)                                                                            
As                                                                                    
/*********************************************************************/                                                                                        
 /* Stored Procedure: [csp_SCInitCustomDocumentHarborNurseEvaluation]*/                                                                               
 /* Creation Date:  11/May/2011                                      */                                                                                        
 /* Purpose: To Initialize											 */                                                                                       
 /* Input Parameters:   @ClientID,@StaffID ,@CustomParameters		 */                                                                                      
 /* Output Parameters:												 */                                                                                        
 /* Return:															 */                                                                                        
 /* Called By:Nurse Evaluation										 */                                                                              
 /* Calls:                                                           */                                                                                        
 /*                                                                  */                                                                                        
 /* Data Modifications:                                              */                                                                                        
 /*   Updates:                                                       */                                                                                        
 /*       Date              Author                  Purpose			 */	        
 /*		  11 May 2011		Vikas Kashyap			Vikas Kashyap    */
 /*********************************************************************/     
    
                                                                                         
Begin                          
Begin Try               
            
DECLARE @LatestDocumentVersionID int              
DECLARE @DateOfService VARCHAR(10)
  
SET @LatestDocumentVersionID =(SELECT TOP 1 DocumentVersionId from CustomDocumentHarborNurseEvaluations C inner join Documents Doc                                                                                         
  on C.DocumentVersionId=Doc.CurrentDocumentVersionId       
  and Doc.ClientId=@ClientID                       
  and Doc.Status=22        
  and IsNull(C.RecordDeleted,''N'')=''N''       
  and IsNull(Doc.RecordDeleted,''N'')=''N''                                                             
 ORDER BY Doc.EffectiveDate DESC,Doc.ModifiedDate desc                                                                  
)       
SET @DateOfService =(Select Top 1 CONVERT(DATE,DateOfService) AS DateOfService 
from Services 
Where Status=70 
and Procedurecodeid=484 
and CLientId=@ClientID 
and DATEDIFF(DAY, DateOfService, GETDATE()) <= 0
and IsNull(RecordDeleted,''N'')=''N''
ORDER BY  DateOfService)        
   
SELECT TOP 1 Placeholder.TableName,  
  ISNULL(CDNHE.DocumentVersionId,-1) AS DocumentVersionId
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
		,@DateOfService AS PsychiatricEvalDate
		,CDNHE.PreviousTreatmentComment             
 FROM (SELECT ''CustomDocumentHarborNurseEvaluations'' AS TableName) AS Placeholder          
 LEFT JOIN CustomDocumentHarborNurseEvaluations CDNHE ON ( CDNHE.DocumentVersionId  = @LatestDocumentVersionID          
 AND ISNULL(CDNHE.RecordDeleted,''N'') <> ''Y'' )  
                         
END TRY                                                                      
BEGIN CATCH                          
DECLARE @Error varchar(8000)                                                                       
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                 
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_SCInitCustomDocumentHarborNurseEvaluation'')                                                                                                     
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
