
GO

/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomDocumentElectronicReleaseOfInformation]    Script Date: 01/23/2013 19:37:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDocumentElectronicReleaseOfInformation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomDocumentElectronicReleaseOfInformation]
GO


GO

/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomDocumentElectronicReleaseOfInformation]    Script Date: 01/23/2013 19:37:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
 CREATE Procedure [dbo].[csp_SCGetCustomDocumentElectronicReleaseOfInformation]  
 @DocumentVersionId INT  
 AS  
 /*********************************************************************/                                                                                        
 /* Stored Procedure: csp_SCGetCustomDocumentElectronicReleaseOfInformation     */                                                                               
 /* Creation Date:  22/Jan/2013                                     */                                                                                        
 /* Purpose: To Get The Release Of Information        */                                                                                       
 /* Input Parameters: @DocumentVersionId         */                                                                                      
 /* Output Parameters:              */                                                                                        
 /* Return:                 */                                                                                        
 /* Called By:Initialization of Screen          */                                                                              
 /* Calls:                                                            */                                                                                        
 /*                                                                   */                                                                                        
 /* Data Modifications:                                               */                                                                                        
 /* Updates:                                                          */                                                                                        
 /* Date              Author                  Purpose      */       
 /* 22/Jan/2013   Sanjay     Create      */   
 /*08/Apr/2013			 Sanjay Bhardwaj	  Modified wrt Task#2 Newaygo Customizations
										  What & Why : remove ReleaseEndDate initialization */
 /*********************************************************************/     
    
  Begin                              
  Begin TRY   
  
  SELECT 
  ReleaseOfInformationId              
   ,CDRI.CreatedBy    
  ,CDRI.CreatedDate    
  ,CDRI.ModifiedBy    
  ,CDRI.ModifiedDate    
  ,CDRI.RecordDeleted    
  ,CDRI.DeletedBy    
  ,CDRI.DeletedDate    
  ,CDRI.DocumentVersionId  
  ,CDRI.OldDocumentVersionId  
  ,CDRI.ReleaseOfInformationOrder  
  ,CDRI.GetInformationFrom  
  ,CDRI.ReleaseInformationFrom  
  ,CDRI.ReleaseToReceiveFrom  
  ,CDRI.ReleaseEndDate  --ISNULL(CDRI.ReleaseEndDate,convert(date,DateAdd(year,1,getdate()),101))   [ReleaseEndDate]
  ,CDRI.ReleaseContactType  
  ,CDRI.ReleaseName  
  ,CDRI.ReleaseAddress  
  ,CDRI.ReleaseCity  
  ,CDRI.ReleasedState  
  ,CDRI.ReleasePhoneNumber  
  ,CDRI.ReleasedZip  
  ,CDRI.AssessmentEvaluation  
  ,CDRI.PersonPlan  
  ,CDRI.ProgressNote  
  ,CDRI.PsychologicalTesting  
  ,CDRI.PsychiatricTreatment  
  ,CDRI.TreatmentServiceRecommendation  
  ,CDRI.EducationalDevelopmental  
  ,CDRI.DischargeTransferRecommendation  					
  ,CDRI.InformationBenefitInsurance  
  ,CDRI.WorkRelatedInformation  
  ,CDRI.ReleasedInfoOther  
  ,CDRI.ReleasedInfoOtherComment
  ,CDRI.TransmissionModesWritten  
  ,CDRI.TransmissionModesVerbal  
  ,CDRI.TransmissionModesElectronic  
  ,CDRI.TransmissionModesAudio  
  ,CDRI.TransmissionModesPhoto  
  ,CDRI.TransmissionModesReleaseInOther  
  ,CDRI.TransmissionModesReleaseInOtherComment  
  ,CDRI.TransmissionModesToProvideCaseCoordination  
  ,CDRI.TransmissionModesToDetermineEligibleService
  ,CDRI.TransmissionModesAtRequestIndividual
  ,CDRI.TransmissionModesInOther
  ,CDRI.TransmissionModesOtherComment
  ,CDRI.AlcoholDrugAbuse
  ,CDRI.AIDSRelatedComplex            
 FROM  CustomDocumentReleaseOfInformations AS CDRI  
 WHERE ISNull(CDRI.RecordDeleted,'N')='N' AND CDRI.DocumentVersionId=@DocumentVersionId   
   
    
  
  END TRY                                                                          
  BEGIN CATCH                              
  DECLARE @Error varchar(8000)                                                                           
  SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                         
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_SCGetCustomDocumentElectronicReleaseOfInformation')                                                                                                         
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                          
    + '*****' + Convert(varchar,ERROR_STATE())                          
   RAISERROR                                                                                                         
   (                                                                           
    @Error, -- Message text.                                                                                                        
    16, -- Severity.                                                                                                        
    1 -- State.                                                                                                        
   );                                                                                                      
  END CATCH                                                     
  END      
GO


