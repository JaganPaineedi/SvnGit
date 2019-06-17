
/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomDocumentUrinalysisNote]    Script Date: 07/19/2013 18:40:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDocumentUrinalysisNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomDocumentUrinalysisNote]
GO


/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomDocumentUrinalysisNote]    Script Date: 07/19/2013 18:40:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================    
-- Author:  <Manju Padmanabhan>    
-- Create date: <18 July, 2013>    
-- Description: A Renewed Mind - Customizations Task #21 Urinalysis Service Note    
-- =============================================    
CREATE PROCEDURE [dbo].[csp_SCGetCustomDocumentUrinalysisNote]     
 @DocumentVersionId INT     
AS    
BEGIN    
  
 BEGIN TRY    
   
 select   
  DocumentVersionId,    
  CreatedBy,    
  CreatedDate,    
  ModifiedBy,    
  ModifiedDate,    
  RecordDeleted,    
  DeletedBy,    
  DeletedDate,    
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
  UrineNoteStaffRating,    
  UrinalysisComment     
  FROM     
  [dbo].[CustomDocumentUrinalysis]    
   WHERE     (ISNULL(RecordDeleted, 'N') = 'N') AND ([DocumentVersionId] = @DocumentVersionId)      
 END TRY      
      
 BEGIN CATCH      
  DECLARE @Error VARCHAR(8000)      
   SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())      
    + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'csp_SCGetCustomDocumentUrinalysisNote')      
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


