/****** Object:  StoredProcedure [dbo].[ssp_RDLPHQ9]  ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLPHQ9]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLPHQ9] 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                                                       
Create PROCEDURE [dbo].[ssp_RDLPHQ9] 
(                                                                                                                                                              
  @DocumentVersionId int                                                                     
)                                                                                                
                                                                                                
AS 
/******************************************************************************  
**  
**  Name: ssp_RDLPHQ9  
**  Desc:   
**  This procedure is used get RDL sp for PHQ9 document. 
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
**  08/18/2015   Vijay     This procedure is used get RDL sp for PHQ9 document  , Project :Post Certification and task no:11
**  02/05/2016	 Ravichandra what: 4 new Fields are added in the select Statement 
							 why  : Meaningful Use Stage 2 Task# 45
**  08/09/2016	 Chethan N	What : Added Columns 'PharmacologicalIntervention', 'OtherInterventions',and 'DocumentationFollowup'
							Why : Meaningful Use - Stage 3 task# 34
**  03/27/2018	 Akwinass       what: Reverted "CoreBugs task#2424" code and modified the code to display data on PDF for both CurrentDocumentVersionId and InProgressDocumentVersionId.  
							    why : The data is not displaying on view mode and on refresh of old version.														
*******************************************************************************/


Begin try
DECLARE @ClientName VARCHAR(100)
DECLARE @ClientID INT
DECLARE @EffectiveDate VARCHAR(10)
DECLARE @DOB VARCHAR(10)
DECLARE @DocumentName VARCHAR(100)

SELECT @ClientName = C.LastName + ', ' + C.FirstName
	,@ClientID = Documents.ClientID
	,@EffectiveDate = CASE 
		WHEN Documents.EffectiveDate IS NOT NULL
			THEN CONVERT(VARCHAR(10), Documents.EffectiveDate, 101)
		ELSE ''
		END
	,@DOB = CASE 
		WHEN C.DOB IS NOT NULL
			THEN CONVERT(VARCHAR(10), C.DOB, 101)
		ELSE ''
		END
	,@DocumentName = DocumentCodes.DocumentName
FROM Documents
JOIN Staff S ON Documents.AuthorId = S.StaffId
JOIN Clients C ON Documents.ClientId = C.ClientId
	AND isnull(C.RecordDeleted, 'N') <> 'Y'
JOIN DocumentVersions dv ON dv.DocumentId = documents.DocumentId
INNER JOIN DocumentCodes ON DocumentCodes.DocumentCodeid = Documents.DocumentCodeId
	AND ISNULL(DocumentCodes.RecordDeleted, 'N') = 'N'
LEFT JOIN GlobalCodes GC ON S.Degree = GC.GlobalCodeId
WHERE dv.DocumentVersionId = @DocumentVersionId
	AND isnull(Documents.RecordDeleted, 'N') = 'N'
SELECT CP.DocumentVersionId
	,dbo.ssf_GetGlobalCodeNameById(CP.LittleInterest) AS LittleInterest
	,dbo.ssf_GetGlobalCodeNameById(CP.FeelingDown) AS FeelingDown
	,dbo.ssf_GetGlobalCodeNameById(CP.TroubleFalling) AS TroubleFalling
	,dbo.ssf_GetGlobalCodeNameById(CP.FeelingTired) AS FeelingTired
	,dbo.ssf_GetGlobalCodeNameById(CP.PoorAppetite) AS PoorAppetite
	,dbo.ssf_GetGlobalCodeNameById(CP.FeelingBad) AS FeelingBad
	,dbo.ssf_GetGlobalCodeNameById(CP.TroubleConcentrating) AS TroubleConcentrating
	,dbo.ssf_GetGlobalCodeNameById(CP.MovingOrSpeakingSlowly) AS MovingOrSpeakingSlowly
	,dbo.ssf_GetGlobalCodeNameById(CP.HurtingYourself) AS HurtingYourself
	,dbo.ssf_GetGlobalCodeNameById(CP.GetAlongOtherPeople) AS GetAlongOtherPeople
	,CP.TotalScore
    ,CP.DepressionSeverity
    ,CP.Comments
    -- 02/05/2016	 Ravichandra
    ,ISNULL(CP.AdditionalEvalForDepressionPerformed,'N') as AdditionalEvalForDepressionPerformed
	,ISNULL(CP.ReferralForDepressionOrdered,'N') as ReferralForDepressionOrdered
	,ISNULL(CP.DepressionMedicationOrdered,'N') as DepressionMedicationOrdered
	,ISNULL(CP.SuicideRiskAssessmentPerformed,'N') as SuicideRiskAssessmentPerformed
	,CP.ClientRefusedOrContraIndicated
	--,CASE WHEN ISNULL(CP.ClientRefusedOrContraIndicated ,'N')='Y' THEN 'Yes' ELSE 'No' END AS ClientRefusedOrContraIndicated
	,@ClientName AS ClientName
	,@ClientID AS ClientID
	,@EffectiveDate AS EffectiveDate
	,@DocumentName AS DocumentName
	,@ClientName + ' (' + CONVERT(VARCHAR(10), @ClientID) + ')' AS ClientNameF
	,@DOB AS DOB	
	-- 08/09/2016 Chethan N
	,ISNULL(PharmacologicalIntervention, 'N') AS PharmacologicalIntervention
	,ISNULL(OtherInterventions, 'N') AS OtherInterventions
	,DocumentationFollowup
	,ClientDeclinedToParticipate
FROM PHQ9Documents AS CP
WHERE ISNull(CP.RecordDeleted, 'N') = 'N'	
	AND CP.DocumentVersionId = @DocumentVersionId
END TRY                                                       
                                                                                       
BEGIN CATCH                                               
  DECLARE @Error varchar(8000)                                                                                                         
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                                       
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_RDLPHQ9')                                                 
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                               
   + '*****' + Convert(varchar,ERROR_STATE())                                                                    
                                                                                                                                                      
                                                           
   RAISERROR                                                                                                                                       
   (                                                                                                              
    @Error, -- Message text.                                                                                                                                      
    16, -- Severity.      
    1 -- State.                                                                                                                                      
   );                                                                            
                                                            
 END CATCH  
