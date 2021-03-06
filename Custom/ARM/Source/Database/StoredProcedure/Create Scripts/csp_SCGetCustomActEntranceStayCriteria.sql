/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomActEntranceStayCriteria]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomActEntranceStayCriteria]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomActEntranceStayCriteria]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomActEntranceStayCriteria]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/****************************************************************************/                                                  
 /* Stored Procedure:csp_SCGetCustomActEntranceStayCriteria              */                                         
 /* Copyright: 2006 Streamlin Healthcare Solutions                           */       
 /* Author: Pradeep                                                          */                                                 
 /* Creation Date:  Aug 27,2009                                              */                                                  
 /* Purpose: Gets Data for ActEntranceStayCriteria  Document                 */                                                 
 /* Input Parameters: @DocumentId, @DocumentVersionId                        */                                                
 /* Output Parameters:None                                                   */                                                  
 /* Return:                                                                  */                                                  
 /* Calls:                                                                   */      
 /* Called From:                                                             */                                                  
 /* Data Modifications:                                                      */                                                  
 /*-------------Modification History--------------------------               */
 /*-------Date----Author-------Purpose---------------------------------------*/ 
 /* 11 Sept,2009  Pradeep      Made changes as per dataModel Venture3.0      */
 /* 03/04/2010 Vikas Monga             */  
 /* -- Remove [Documents] and [DocumentVersions]        */                        
 /****************************************************************************/ 
CREATE PROCEDURE  [dbo].[csp_SCGetCustomActEntranceStayCriteria]                                    
  @DocumentVersionId int                                     
AS                                                  
BEGIN                      
  BEGIN TRY                          
   --For CustomActEntranceStayCriteria Table                                                         
	SELECT     DocumentVersionId, CurrentAddress, CurrentDiagnosis, HasSeverePsychoticSymptoms, SymptomThoughtProcess, SymptomPanicReactions, 
					  SymptomQuestionableJudgment, SymptomPerception, SymptomAgitation, SymptomPsychomotor, SymptomMemory, SymptomAffect, 
					  SymptomObsessionsRuminations, SymptomWithdrawalorAvoidance, SymptomImpairmentsinRolePerformance, SymptomCompulsionsRituals, 
					  SymptomImpairmentsinFunctioning, SymptomHallucinations, SymptomDisorderedAberrantConduct, SymptomPhobias, SymptomConsciousness, SymptomDepression, 
					  SymptomDelusions, SymtpomImpulseControl, HasDisruptionsSelfCare, SelfCareUnableWithoutMonitoring, SelfCareIncapacityResponsibilities, 
					  SelfCareSeriousNeglect, SelfCareAdequateNutrition, SelfCareHousekeeping, SelfCareShopping, SelfCarePayingBills, SelfCareMealPreparation, 
					  SelfCareInterpersonalRelationships, SelfCareAccessingSupports, HasRiskToSelfOthers, RiskHistoryAssaultThreat, RiskVerbalized, RiskMinorPropertyDestruction, 
					  RiskHarmToSelf, RiskSelfMutilation, RiskPotentialSelf, RiskPotentialOthers, HasMedicationIssues, MedicationComplianceMonitoring, MedicationManagingSupport, 
					  MedicationPsychoticSymptoms, MedicationCoexistingCondition, HasCoOccuringSubstanceDisorder, HasFrequentInaptientServices, MostRecentHospitalizationDate, 
					  AdditionalComments, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy
	FROM         CustomActEntranceStayCriteria
	WHERE     (ISNULL(RecordDeleted, ''N'') = ''N'') AND (DocumentVersionId = @DocumentVersionId) 
                                                      
 END TRY                      
 BEGIN CATCH                      
  DECLARE @Error varchar(8000)                                                         
  SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                        
  + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''[csp_SCGetCustomActEntranceStayCriteria]'')                                                         
  + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****ERROR_SEVERITY='' + Convert(varchar,ERROR_SEVERITY())                                                        
  + ''*****ERROR_STATE='' + Convert(varchar,ERROR_STATE())                                                        
  RAISERROR ( @Error, /* Message text.*/16, /* Severity.*/ 1 /*State.*/ );                                                  
                    
 END CATCH                                    
End
' 
END
GO
