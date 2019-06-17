/****** Object:  StoredProcedure [dbo].[ssp_GetPHQ9]  ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetPHQ9]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetPHQ9]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                                                       
Create PROCEDURE [dbo].[ssp_GetPHQ9]                                                                                   
(                                                                                                                                                              
  @DocumentVersionId int                                                                     
)                                                                                                
                                                                                                
AS 
/******************************************************************************  
**  
**  Name: ssp_GetPHQ9  
**  Desc:   
**  This procedure is used to get sp for PHQ9 document.  
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
**  08/18/2015   Vijay     This procedure is used to get sp for PHQ9 document  , Project :Post Certification and task no:11
**  02/08/2016   Seema     To Fetch  AdditionalEvalForDepressionPerformed,ReferralForDepressionOrdered,DepressionMedicationOrdered,SuicideRiskAssessmentPerformed , 
				 Project :Meaningful Use Stage 2 and task no:46
**  08/09/2016	 Chethan N	What : Added Columns 'PharmacologicalIntervention', 'OtherInterventions',and 'DocumentationFollowup'
							Why : Meaningful Use - Stage 3 task# 34
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
,LittleInterest
,FeelingDown
,TroubleFalling
,FeelingTired
,PoorAppetite
,FeelingBad
,TroubleConcentrating
,MovingOrSpeakingSlowly
,HurtingYourself
,GetAlongOtherPeople
,TotalScore
,DepressionSeverity
,Comments
--02/08/2016   Seema 
,AdditionalEvalForDepressionPerformed
,ReferralForDepressionOrdered
,DepressionMedicationOrdered
,SuicideRiskAssessmentPerformed
,ClientRefusedOrContraIndicated
-- 08/09/2016 Chethan N
,PharmacologicalIntervention
,OtherInterventions
,DocumentationFollowup
,ClientDeclinedToParticipate
,PerformedAt
from PHQ9Documents PH
where ISNull(PH.RecordDeleted,'N')='N' AND DocumentVersionId =@DocumentVersionId

END TRY                                                       
                                                                                       
BEGIN CATCH                                               
  DECLARE @Error varchar(8000)                                                                                                         
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                                       
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_GetPHQ9')                                                 
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                               
   + '*****' + Convert(varchar,ERROR_STATE())                                                                    
                                                                                                                                                      
                                                           
   RAISERROR                                                                                                                                       
   (                                                                                                              
    @Error, -- Message text.                                                                                                                                      
    16, -- Severity.      
    1 -- State.                                                                                                                                      
   );                                                                            
                                                            
 END CATCH 