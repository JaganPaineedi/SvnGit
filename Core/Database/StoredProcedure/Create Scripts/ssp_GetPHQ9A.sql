/****** Object:  StoredProcedure [dbo].[ssp_GetPHQ9A]  ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetPHQ9A]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetPHQ9A]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                                                       
Create PROCEDURE [dbo].[ssp_GetPHQ9A]                                                                                   
(                                                                                                                                                              
  @DocumentVersionId int                                                                     
)                                                                                                
                                                                                                
AS 
/******************************************************************************  
**  
**  Name: ssp_GetPHQ9A  
**  Desc:   
**  This procedure is used to get sp for PHQ9-A document.  
**  
**  Parameters:  
**  Input       Output  
**              @DocumentVersionId int,  
**  Auth: Vijay 
**  Date: 08/18/2015  
*******************************************************************************  
**  Change History  
*******************************************************************************  
**  Date:        Author:   Description:  
**  08/18/2015   Vijay     To add PHQ9-A document as a core document  , Project :Post Certification and task no:12
**  02/09/2016	 Seema	   To Fetch TotalScore,AdditionalEvalForDepressionPerformed,ReferralForDepressionOrdered,
						   DepressionMedicationOrdered,SuicideRiskAssessmentPerformed,ClientRefusedOrContraIndicated
						   Project :Meaningful Use Stage 2 and task no:45
** 01/Sep/2016	Ponnin		Added new column "Comments".
							Why : For task #442 of AspenPointe-Customization
   20/April/2018	Pabitra		Added new column "ClientDeclinedToParticipate".
							Why : For task #84 of Texas Go Live Build issues		
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
,FeelingDown
,LittleInterest
,TroubleFalling
,FeelingTired
,PoorAppetite
,FeelingBad
,TroubleConcentrating
,MovingOrSpeakingSlowly
,HurtingYourself
,PastYear
,ProblemDifficulty
,PastMonth
,SuicideAttempt
,SeverityScore
--02/09/2016	 Seema
,TotalScore
,AdditionalEvalForDepressionPerformed
,ReferralForDepressionOrdered
,DepressionMedicationOrdered
,SuicideRiskAssessmentPerformed
,ClientRefusedOrContraIndicated
,Comments
,ClientDeclinedToParticipate
,PerformedAt
from PHQ9ADocuments CP
where ISNull(CP.RecordDeleted,'N')='N' AND DocumentVersionId =@DocumentVersionId

END TRY                                                       
                                                                                       
BEGIN CATCH                                               
  DECLARE @Error varchar(8000)                                                                                                         
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                                       
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_GetPHQ9A')                                                 
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                               
   + '*****' + Convert(varchar,ERROR_STATE())                                                                    
                                                                                                                                                      
                                                           
   RAISERROR                                                                                                                                       
   (                                                                                                              
    @Error, -- Message text.                                                                                                                                      
    16, -- Severity.      
    1 -- State.                                                                                                                                      
   );                                                                            
                                                            
 END CATCH 