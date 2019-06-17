
/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentUrinalysisNote]    Script Date: 07/19/2013 18:41:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentUrinalysisNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentUrinalysisNote]
GO


/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentUrinalysisNote]    Script Date: 07/19/2013 18:41:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================    
-- Author:  <Manju Padmanabhan>    
-- Create date: <19 July, 2013>  
-- Modified by : Manju P	22 Aug, 2013	condition added for UrineNoteStaffRating - 'Not Rated'
-- Description: A Renewed Mind - Customizations Task #21 Urinalysis Service Note    
-- =============================================    
CREATE PROCEDURE [dbo].[csp_RDLCustomDocumentUrinalysisNote]     
 @DocumentVersionId INT     
AS    
BEGIN    
  
 BEGIN TRY    
   
 select   
  DocumentVersionId,  
  IssuesPresentedToday,  
  --CAST(CASE WHEN IssuesPresentedToday = '' THEN 'A'   
  --ELSE IssuesPresentedToday  
  --END AS CHAR(1)) AS IssuesPresentedToday,   
  MoodAffectComment,    
  RiskNone,    
  RiskIdeation,    
  RiskSelf,    
  RiskPlan,    
  RiskOthers,    
  RiskIntent,    
  RiskProperty,    
  RiskAttempt,    
  RiskOther,    
  RiskOtherComment,    
  InterventionADUL,    
  InterventionMDMA,    
  InterventionAMP,    
  InterventionMTD,    
  InterventionBZO,    
  InterventionOPI,    
  InterventionCOC,    
  InterventionBUP,    
  InterventionMET,    
  InterventionPCP,    
  InterventionMOP,    
  InterventionPPX,    
  InterventionTHC,    
  InterventionK2,    
  InterventionOXY,    
  InterventionOther,    
  InterventionOtherComment,    
  SampleSendToLab,    
  UrinalysisTemperature,    
  UrinalysisShareWithClient,    
  UrinalysisConsistentWithClientReport,    
  --UrineNoteStaffRating,  
    
  CAST(CASE UrineNoteStaffRating  
   WHEN 1009584 THEN  ('0 = ' + dbo.csf_GetGlobalCodeNameById(UrineNoteStaffRating))
   WHEN 1009585 THEN  ('1 = ' + dbo.csf_GetGlobalCodeNameById(UrineNoteStaffRating))  
   WHEN 1009586 THEN  ('2 = ' + dbo.csf_GetGlobalCodeNameById(UrineNoteStaffRating))  
   WHEN 1009587 THEN  ('3 = ' + dbo.csf_GetGlobalCodeNameById(UrineNoteStaffRating))  
   WHEN NULL    THEN  ('0 = ' + dbo.csf_GetGlobalCodeNameById(1009584)) 
   WHEN ''      THEN  ('0 = ' + dbo.csf_GetGlobalCodeNameById(1009584)) 
   ELSE  
    ('0 = ' + dbo.csf_GetGlobalCodeNameById(1009584))  
  END AS VARCHAR(100)) AS UrineNoteStaffRating,  
  --dbo.csf_GetGlobalCodeNameById(UrineNoteStaffRating) as UrineNoteStaffRating,  
  UrinalysisComment    
  FROM     
  [dbo].[CustomDocumentUrinalysis]  
   WHERE     (ISNULL(RecordDeleted, 'N') = 'N') AND (DocumentVersionId = @DocumentVersionId)      
 END TRY      
      
 BEGIN CATCH      
  DECLARE @Error VARCHAR(8000)      
   SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())      
    + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'csp_RDLCustomDocumentUrinalysisNote')      
    + '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())      
    + '*****' + CONVERT(VARCHAR,ERROR_STATE())      
   RAISERROR      
   (      
    @Error, -- Message text.      
    16,  -- Severity.      
    1  -- State.      
   );      
 END CATCH      
END 
GO


