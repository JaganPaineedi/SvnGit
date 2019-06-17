
GO

/****** Object:  StoredProcedure [dbo].[csp_SCInitCustomDocumentElectronicReleaseOfInformation]    Script Date: 01/23/2013 19:36:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCInitCustomDocumentElectronicReleaseOfInformation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCInitCustomDocumentElectronicReleaseOfInformation]
GO


GO

/****** Object:  StoredProcedure [dbo].[csp_SCInitCustomDocumentElectronicReleaseOfInformation]    Script Date: 01/23/2013 19:36:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

      
CREATE Procedure [dbo].[csp_SCInitCustomDocumentElectronicReleaseOfInformation]      
 @ClientID INT,                                    
 @StaffID INT,                                  
 @CustomParameters XML      
AS      
 /*********************************************************************/                                                                                            
 /* Stored Procedure: csp_SCInitCustomDocumentElectronicReleaseOfInformation    */                                                                                   
 /* Creation Date:  22/Jan/2013                                     */                                                                                            
 /* Purpose: To Initialized The Release Of Information      */      
 /* Input Parameters: @DocumentVersionId         */                                                                                          
 /* Output Parameters:              */                                                                                            
 /* Return:                 */                                                                                            
 /* Called By:Initialization of Screen          */                                                                                  
 /* Calls:                                                            */                                                                                            
 /*                                                                   */                                                                                            
 /* Data Modifications:                                               */                                                                                            
 /* Updates:                                                          */                                                                                            
 /* Date              Author                  Purpose      */           
 /* 22/Jan/2013   Sanjay Bhardwaj     Create   Task#2 in Project Newaygo Customization   */       
 /*********************************************************************/         
        
Begin                                  
Begin TRY       
      
--DECLARE @LatestDocumentVersionID INT;      
    
        
--SET @LatestDocumentVersionID =(SELECT TOP 1 CurrentDocumentVersionId from CustomDocumentReleaseOfInformations C inner join Documents Doc                                                                                             
-- on C.DocumentVersionId=Doc.CurrentDocumentVersionId           
--  and Doc.ClientId=@ClientID                           
--  and Doc.Status=22            
--  and IsNull(C.RecordDeleted,'N')='N'           
--  and IsNull(Doc.RecordDeleted,'N')='N'                                                                 
-- ORDER BY Doc.EffectiveDate DESC,Doc.ModifiedDate desc                                                                      
--)       
      
SELECT TOP 1 'CustomDocumentReleaseOfInformations' AS TableName --Placeholder.TableName  
  ,-1 AS ReleaseOfInformationId   
  ,CDRI.CreatedBy        
  ,CDRI.CreatedDate        
  ,CDRI.ModifiedBy        
  ,CDRI.ModifiedDate        
  ,CDRI.RecordDeleted        
  ,CDRI.DeletedBy        
  ,CDRI.DeletedDate        
  ,ISNULL(CDRI.DocumentVersionId,-1) AS DocumentVersionId --CDRI.DocumentVersionId      
  ,CDRI.OldDocumentVersionId      
  ,1 as ReleaseOfInformationOrder      
  ,CDRI.GetInformationFrom      
  ,CDRI.ReleaseInformationFrom      
  ,CDRI.ReleaseToReceiveFrom      
  ,convert(date,DateAdd(year,1,getdate()),101) [ReleaseEndDate]
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
    FROM  
systemconfigurations s  
 LEFT OUTER JOIN
  [CustomDocumentReleaseOfInformations] CDRI
 ON s.Databaseversion = -1      
 --FROM (SELECT 'CustomDocumentReleaseOfInformations' AS TableName) AS Placeholder              
 --LEFT JOIN CustomDocumentReleaseOfInformations CDRI ON ( CDRI.DocumentVersionId  = @LatestDocumentVersionID              
 --AND ISNULL(CDRI.RecordDeleted,'N') <> 'Y' )      
      
END TRY                                                                              
BEGIN CATCH                                  
DECLARE @Error varchar(8000)                                                                               
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                         
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_SCInitCustomDocumentElectronicReleaseOfInformation')                                                                                                             
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


