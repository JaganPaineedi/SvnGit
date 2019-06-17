                                    /****** Object:  StoredProcedure ,dbo.ssp_GetSuicideRiskAssessment  ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetSuicideRiskAssessment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].ssp_GetSuicideRiskAssessment
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                                                       
Create PROCEDURE [dbo].[ssp_GetSuicideRiskAssessment]                                                                                                                              
  @DocumentVersionId int                                                                        
AS 
/******************************************************************************  
**  
**  Name: ssp_GetSuicideRiskAssessment  
**  Desc:   
**  This procedure is used to get sp for Suicide Risk Assessment document.  
**  
**  Parameters:  
**  Input       Output  
**              @DocumentVersionId int,  
**  Auth: Seema 
**  Date: 14/10/2015  
*******************************************************************************  
**  Change History  
*******************************************************************************  
**  Date:        Author:   Description:  
**  13/10/2015   Seema     This procedure is used to get sp for ssp_GetSuicideRiskAssessment document 
**  08/02/2016   Seema     To fetch SuicideRiskAssessmentNotDone Column Value 
						   Project :Meaningful Use Stage 2 and task no:47
**  07/27/2018	  jcarlson  Added PerformedAt to help gather data needed to pass CQM Measures
*******************************************************************************/

BEGIN TRY  

 
Select DocumentVersionId
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate
,RecordDeleted
,DeletedBy
,DeletedDate
,SuicideCurrent
,SuicidePrevious
,SuicideNotPresent
,SuicideIdeation
,SuicideActive
,SuicidePassive
,SuicideMeans
,SuicidePlan
,SuicideBehaviorsPastHistory
,SuicideClinicalResponse
,SuicideRiskAssessmentNotDone    --08/02/2016   Seema 
,PerformedAt
from SuicideRiskAssessmentDocuments SRA
where ISNull(SRA.RecordDeleted,'N')='N' AND SRA.DocumentVersionId =@DocumentVersionId

END TRY                                                       
                                                                                       
BEGIN CATCH                                               
  DECLARE @Error varchar(8000)                                                                                                         
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                                       
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_GetSuicideRiskAssessment')                                                 
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                               
   + '*****' + Convert(varchar,ERROR_STATE())                                                                    
                                                                                                                                                      
                                                           
   RAISERROR                                                                                                                                       
   (                                                                                                              
    @Error, -- Message text.                                                                                                                                      
    16, -- Severity.      
    1 -- State.                                                                                                                                      
   );                                                                            
                                                            
 END CATCH                                                            