/****** Object:  StoredProcedure [dbo].[ssp_RDLSuicideRiskAssessment]  ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSuicideRiskAssessment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLSuicideRiskAssessment] 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                                                       
Create PROCEDURE [dbo].[ssp_RDLSuicideRiskAssessment] 
(                                                                                                                                                              
  @DocumentVersionId int                                                                     
)                                                                                                
                                                                                                
AS 
/******************************************************************************  
**  
**  Name: ssp_RDLSuicideRiskAssessment  
**  Desc:   
**  This procedure is used to add Suicide Risk Assessment document as a core document  
**  
**  Parameters:  
**  Input       Output  
**              @DocumentVersionId int,  
**  Auth: Vijay 
**  Date: 10/14/2015 
*******************************************************************************  
**  Change History  
*******************************************************************************  
**  Date:        Author:   Description:  
**  10/14/2015   Vijay     To create Suicide Risk Assessment as a core document  , Project :Post Certification and task no:20
**  02/05/2016	 Ravichandra what: 1 new check box is added to this document   
							 why  : Meaningful Use Stage 2 Task# 47
**  02/26/2018	 Venkatesh  what: Compare the DocumentVersionId with InProgressDocumentVersionId instead CurrentDocumentVersionId  
							 why  : Texas Go Live Build Issues Task# 152
**  03/27/2018	 Akwinass    what: Reverted Texas Go Live Build Issues Task# 152 code and modified the code to display data on PDF for both CurrentDocumentVersionId and InProgressDocumentVersionId.  
							 why : The data is not displaying on view mode.
*******************************************************************************/


Begin try

DECLARE @OrganizationName VARCHAR(250)
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
	,CP.SuicideCurrent
    ,CP.SuicidePrevious
    ,CP.SuicideNotPresent
    ,CP.SuicideIdeation
    ,CP.SuicideActive
    ,CP.SuicidePassive
    ,CP.SuicideMeans
    ,CP.SuicidePlan
    ,CP.SuicideBehaviorsPastHistory
    ,CP.SuicideClinicalResponse 
    ,ISNULL(CP.SuicideRiskAssessmentNotDone,'N') AS SuicideRiskAssessmentNotDone -- 02/05/2016	 Ravichandra
	,@ClientName AS ClientName
	,@ClientID AS ClientID
	,@EffectiveDate AS EffectiveDate
	,@DocumentName AS DocumentName
	,@ClientName + ' (' + CONVERT(VARCHAR(10), @ClientID) + ')' AS ClientNameF
	,@DOB AS DOB
FROM SuicideRiskAssessmentDocuments AS CP
WHERE ISNull(CP.RecordDeleted, 'N') = 'N'	
	AND CP.DocumentVersionId = @DocumentVersionId
END TRY                                                       
                                                                                       
BEGIN CATCH                                               
  DECLARE @Error varchar(8000)                                                                                                         
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                                       
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_RDLSuicideRiskAssessment')                                                 
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                               
   + '*****' + Convert(varchar,ERROR_STATE())                                                                    
                                                                                                                                                      
                                                           
   RAISERROR                                                                                                                                       
   (                                                                                                              
    @Error, -- Message text.                                                                                                                                      
    16, -- Severity.      
    1 -- State.                                                                                                                                      
   );                                                                            
                                                            
 END CATCH  
