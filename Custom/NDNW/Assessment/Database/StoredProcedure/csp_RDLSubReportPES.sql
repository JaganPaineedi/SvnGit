
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportPES]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportPES]
GO


CREATE PROCEDURE   [dbo].[csp_RDLSubReportPES]     
(                                          
  @DocumentVersionId int                  
)                                           
As                                                                                                                                                          
/************************************************************/                                                                  
/* Stored Procedure: csp_RDLSubReportPES           */                                                                                                                   
/* Creation Date:       */                                                                                                                               
/* Purpose: Gets Data for PES    */                                                                 
/* Input Parameters: @DocumentVersionId      */                                                                                                                            
/* Author:         */      
    
/************************************************************/                                                                                                                                              
BEGIN TRY                                         
       
  BEGIN       
SELECT   
  CDPA.DocumentVersionId  
 ,CDPA.CreatedBy  
 ,CDPA.CreatedDate  
 ,CDPA.ModifiedBy  
 ,CDPA.ModifiedDate  
 ,CDPA.RecordDeleted  
 ,CDPA.DeletedBy  
 ,CDPA.DeletedDate  
 ,CDPA.EducationTraining  
 ,CDPA.EducationTrainingNeeds  
 ,CDPA.EducationTrainingNeedsComments  
 ,CDPA.PersonalCareerPlanning  
 ,CDPA.PersonalCareerPlanningNeeds  
 ,CDPA.PersonalCareerPlanningNeedsComments  
 ,CDPA.EmploymentOpportunities  
 ,CDPA.EmploymentOpportunitiesNeeds  
 ,CDPA.EmploymentOpportunitiesNeedsComments  
 ,CDPA.SupportedEmployment  
 ,CDPA.SupportedEmploymentNeeds  
 ,CDPA.SupportedEmploymentNeedsComments  
 ,CDPA.WorkHistory  
 ,CDPA.WorkHistoryNeeds  
 ,CDPA.WorkHistoryNeedsComments  
 ,CDPA.GainfulEmploymentBenefits  
 ,CDPA.GainfulEmploymentBenefitsNeeds  
 ,CDPA.GainfulEmploymentBenefitsNeedsComments  
 ,CDPA.GainfulEmployment  
 ,CDPA.GainfulEmploymentNeeds  
 ,CDPA.GainfulEmploymentNeedsComments  
 FROM CustomDocumentPreEmploymentActivities CDPA  
 WHERE ISNULL(RecordDeleted, 'N') = 'N'           
    AND CDPA.DocumentVersionId = @DocumentVersionId  
      
    End  
    END TRY                                                                                                     
 BEGIN CATCH                                                       
   DECLARE @Error varchar(8000)                                                                                                                                     
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                          
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RDLSubReportPES')                         
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                          
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                                                                
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                         
                                                                                                                                    
 END CATCH 