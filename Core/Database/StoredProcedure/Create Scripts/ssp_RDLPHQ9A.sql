/****** Object:  StoredProcedure [dbo].[ssp_RDLPHQ9A]  ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLPHQ9A]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLPHQ9A] 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                                                       
Create PROCEDURE [dbo].[ssp_RDLPHQ9A] 
(                                                                                                                                                              
  @DocumentVersionId int                                                                     
)                                                                                                
                                                                                                
AS 
/******************************************************************************  
**  
**  Name: ssp_RDLPHQ9A  
**  Desc:   
**  This procedure is used to add PHQ9-A document as a core document  
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
**  08/18/2015   Vijay     To create PHQ9-A document as a core document  , Project :Post Certification and task no:12
**  02/05/2016	 Ravichandra what: 4 new Fields are added in the select Statement 
							 why  : Meaningful Use Stage 2 Task# 45
** 01/Sep/2016	Ponnin		Added new column "Comments".
							Why : For task #442 of AspenPointe-Customization
**  13/11/2017	Vandana Ojha	What :Changed 'CurrentDocumentVersionId' to 'InProgressVersionId' in Join with documents table
							    Why : CoreBugs task#2415
   20/April/2018	Pabitra		Added new column "ClientDeclinedToParticipate".
							Why : For task #84 of Texas Go Live Build issues							    
*******************************************************************************/


Begin try

SELECT CP.DocumentVersionId
	,dbo.ssf_GetGlobalCodeNameById(CP.FeelingDown) AS FeelingDown
	,dbo.ssf_GetGlobalCodeNameById(CP.LittleInterest) AS LittleInterest
	,dbo.ssf_GetGlobalCodeNameById(CP.TroubleFalling) AS TroubleFalling
	,dbo.ssf_GetGlobalCodeNameById(CP.FeelingTired) AS FeelingTired
	,dbo.ssf_GetGlobalCodeNameById(CP.PoorAppetite) AS PoorAppetite
	,dbo.ssf_GetGlobalCodeNameById(CP.FeelingBad) AS FeelingBad
	,dbo.ssf_GetGlobalCodeNameById(CP.TroubleConcentrating) AS TroubleConcentrating
	,dbo.ssf_GetGlobalCodeNameById(CP.MovingOrSpeakingSlowly) AS MovingOrSpeakingSlowly
	,dbo.ssf_GetGlobalCodeNameById(CP.HurtingYourself) AS HurtingYourself
	,CP.PastYear
	,dbo.ssf_GetGlobalCodeNameById(CP.ProblemDifficulty) AS ProblemDifficulty
	,CP.PastMonth
	,CP.SuicideAttempt
	,CP.SeverityScore
	 -- 02/05/2016	 Ravichandra
	 ,CP.TotalScore
    ,ISNULL(CP.AdditionalEvalForDepressionPerformed,'N') as AdditionalEvalForDepressionPerformed
	,ISNULL(CP.ReferralForDepressionOrdered,'N') as ReferralForDepressionOrdered
	,ISNULL(CP.DepressionMedicationOrdered,'N') as DepressionMedicationOrdered
	,ISNULL(CP.SuicideRiskAssessmentPerformed,'N') as SuicideRiskAssessmentPerformed
	,CP.ClientRefusedOrContraIndicated
	,C.LastName + ', ' + C.FirstName AS ClientName
	,D.ClientID
	,CONVERT(VARCHAR(10), D.EffectiveDate, 101) AS EffectiveDate
	,DC.DocumentName
	,ISNULL(C.LastName + ', ', '') + C.FirstName + ' (' + CONVERT(VARCHAR(10), C.ClientId) + ')' AS ClientNameF
	,CONVERT(VARCHAR(10), C.DOB, 101) AS DOB
	,Comments
	,ClientDeclinedToParticipate
FROM PHQ9ADocuments AS CP
INNER JOIN Documents D ON CP.DocumentVersionId =  D.InProgressDocumentVersionId  --Core Bugs #2415 --Vandana
INNER JOIN Clients C ON D.ClientId = C.ClientId
INNER JOIN DocumentCodes DC ON D.DocumentCodeId = DC.DocumentCodeId
WHERE ISNull(CP.RecordDeleted, 'N') = 'N'
	AND ISNull(D.RecordDeleted, 'N') = 'N'
	AND ISNull(C.RecordDeleted, 'N') = 'N'
	AND ISNull(DC.RecordDeleted, 'N') = 'N'
	AND CP.DocumentVersionId = @DocumentVersionId
END TRY                                                       
                                                                                       
BEGIN CATCH                                               
  DECLARE @Error varchar(8000)                                                                                                         
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                                       
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_RDLPHQ9A')                                                 
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                               
   + '*****' + Convert(varchar,ERROR_STATE())                                                                    
                                                                                                                                                      
                                                           
   RAISERROR                                                                                                                                       
   (                                                                                                              
    @Error, -- Message text.                                                                                                                                      
    16, -- Severity.      
    1 -- State.                                                                                                                                      
   );                                                                            
                                                            
 END CATCH  
