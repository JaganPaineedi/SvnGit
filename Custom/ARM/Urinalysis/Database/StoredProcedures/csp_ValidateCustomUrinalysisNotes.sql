
/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomUrinalysisNotes]    Script Date: 07/22/2013 10:54:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomUrinalysisNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomUrinalysisNotes]
GO


/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomUrinalysisNotes]    Script Date: 07/22/2013 10:54:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Manju Padmanabhan>
-- Create date: <21 July, 2013>
-- Description:	A Renewed Mind - Customizations Task #21 Urinalysis Service Note
-- =============================================
CREATE PROCEDURE [dbo].[csp_ValidateCustomUrinalysisNotes] 
	@DocumentVersionId INT 
AS
BEGIN
	BEGIN TRY
	 CREATE TABLE #CustomDocumentUrinalysis(
	   DocumentVersionId Int ,
	   CreatedBy varchar(100),
	   CreatedDate datetime,
	   ModifiedBy varchar(100),
	   ModifiedDate datetime,
	   RecordDeleted char(1),
	   DeletedBy varchar(100),
	   DeletedDate datetime,
	   IssuesPresentedToday char(1),
	   MoodAffectComment varchar(max),
	   RiskNone char(1),
	   RiskIdeation char(1),
	   RiskSelf	 char(1),
	   RiskPlan char(1),
	   RiskOthers char(1),
	   RiskIntent char(1),
	   RiskProperty char(1),
	   RiskAttempt char(1),
	   RiskOther char(1),
	   RiskOtherComment varchar(max),
	   InterventionADUL char(1),
	   InterventionMDMA char(1),
	   InterventionAMP char(1),
	   InterventionMTD char(1),
	   InterventionBZO char(1),
	   InterventionOPI char(1),
	   InterventionCOC char(1),
	   InterventionBUP char(1),
	   InterventionMET char(1),
	   InterventionPCP char(1),
	   InterventionMOP char(1),
	   InterventionPPX char(1),
	   InterventionTHC char(1),
	   InterventionK2 char(1),
	   InterventionOXY char(1),
	   InterventionOther char(1),
	   InterventionOtherComment  varchar(max),
	   SampleSendToLab char(1),
	   UrinalysisTemperature char(1),
	   UrinalysisShareWithClient char(1),
	   UrinalysisConsistentWithClientReport char(1),
	   UrineNoteStaffRating int,
	   UrinalysisComment varchar(max))
	   
	   INSERT INTO #CustomDocumentUrinalysis(
	   DocumentVersionId,
	   CreatedBy ,
	   CreatedDate,
	   ModifiedBy ,
	   ModifiedDate ,
	   RecordDeleted ,
	   DeletedBy ,
	   DeletedDate ,
	   IssuesPresentedToday ,
	   MoodAffectComment ,
	   RiskNone ,
	   RiskIdeation ,
	   RiskSelf	 ,
	   RiskPlan,
	   RiskOthers ,
	   RiskIntent ,
	   RiskProperty ,
	   RiskAttempt ,
	   RiskOther ,
	   RiskOtherComment,
	   InterventionADUL,
	   InterventionMDMA ,
	   InterventionAMP ,
	   InterventionMTD,
	   InterventionBZO ,
	   InterventionOPI ,
	   InterventionCOC ,
	   InterventionBUP ,
	   InterventionMET ,
	   InterventionPCP ,
	   InterventionMOP,
	   InterventionPPX ,
	   InterventionTHC ,
	   InterventionK2 ,
	   InterventionOXY ,
	   InterventionOther ,
	   InterventionOtherComment ,
	   SampleSendToLab ,
	   UrinalysisTemperature ,
	   UrinalysisShareWithClient,
	   UrinalysisConsistentWithClientReport ,
	   UrineNoteStaffRating ,
	   UrinalysisComment )
	   SELECT 
	   u.DocumentVersionId  ,
	   u.CreatedBy ,
	   u.CreatedDate ,
	   u.ModifiedBy ,
	   u.ModifiedDate ,
	   u.RecordDeleted,
	   u.DeletedBy,
	   u.DeletedDate ,
	   u.IssuesPresentedToday ,
	   u.MoodAffectComment,
	   u.RiskNone ,
	   u.RiskIdeation ,
	   u.RiskSelf	,
	   u.RiskPlan ,
	   u.RiskOthers ,
	   u.RiskIntent ,
	   u.RiskProperty ,
	   u.RiskAttempt ,
	   u.RiskOther ,
	   u.RiskOtherComment ,
	   u.InterventionADUL ,
	   u.InterventionMDMA ,
	   u.InterventionAMP ,
	   u.InterventionMTD ,
	   u.InterventionBZO ,
	   u.InterventionOPI ,
	   u.InterventionCOC ,
	   u.InterventionBUP ,
	   u.InterventionMET ,
	   u.InterventionPCP ,
	   u.InterventionMOP ,
	   u.InterventionPPX ,
	   u.InterventionTHC ,
	   u.InterventionK2 ,
	   u.InterventionOXY ,
	   u.InterventionOther ,
	   u.InterventionOtherComment ,
	   u.SampleSendToLab ,
	   u.UrinalysisTemperature ,
	   u.UrinalysisShareWithClient ,
	   u.UrinalysisConsistentWithClientReport ,
	   u.UrineNoteStaffRating ,
	   u.UrinalysisComment
	   FROM CustomDocumentUrinalysis u WHERE u.DocumentVersionId = @DocumentVersionId
	   
	   
	   INSERT INTO #validationReturnTable
		(TableName,
		ColumnName,
		ErrorMessage
		)
		SELECT 'CustomDocumentUrinalysis', 'IssuesPresentedToday', 'Issues Presented Today must be specified'
		FROM #CustomDocumentUrinalysis
		WHERE IssuesPresentedToday is null
	    UNION
	    SELECT 'CustomDocumentUrinalysis', 'DangerTo', 'Danger to must be specified'
		FROM #CustomDocumentUrinalysis
		WHERE (ISNULL(RiskNone,'N') = 'N') AND (ISNULL(RiskIdeation,'N') = 'N') AND (ISNULL(RiskSelf,'N') = 'N') AND (ISNULL(RiskPlan,'N') = 'N') AND (ISNULL(RiskOthers,'N') = 'N') 
		  AND (ISNULL(RiskIntent,'N') = 'N') AND (ISNULL(RiskProperty,'N') = 'N') AND (ISNULL(RiskAttempt,'N') = 'N') AND (ISNULL(RiskOther,'N') = 'N')  
	    UNION
	    SELECT 'CustomDocumentUrinalysis', 'DangerTo', 'Danger to comment must be specified'
		FROM #CustomDocumentUrinalysis
		WHERE (ISNULL(RiskOther,'N') = 'Y') AND (RiskOtherComment IS NULL)  
		UNION
	    SELECT 'CustomDocumentUrinalysis', 'TherapeuticInterventions', 'Therapeutic Interventions Provided/Planned must be specified'
		FROM #CustomDocumentUrinalysis
		WHERE (ISNULL(InterventionADUL,'N') = 'N') AND (ISNULL(InterventionMDMA,'N') = 'N') AND (ISNULL(InterventionAMP,'N') = 'N') AND (ISNULL(InterventionMTD,'N') = 'N') AND 
	          (ISNULL(InterventionBZO,'N') = 'N') AND (ISNULL(InterventionOPI,'N') = 'N') AND (ISNULL(InterventionCOC,'N') = 'N') AND (ISNULL(InterventionBUP,'N') = 'N') AND 
	          (ISNULL(InterventionMET,'N') = 'N') AND (ISNULL(InterventionPCP,'N') = 'N') AND (ISNULL(InterventionMOP,'N') = 'N') AND (ISNULL(InterventionPPX,'N') = 'N') AND 
	          (ISNULL(InterventionTHC,'N') = 'N') AND (ISNULL(InterventionK2,'N') = 'N') AND (ISNULL(InterventionOXY,'N') = 'N') AND (ISNULL(InterventionOther,'N') = 'N')  
		UNION
	    SELECT 'CustomDocumentUrinalysis', 'TherapeuticInterventions', 'Therapeutic Interventions Provided/Planned comment must be specified'
		FROM #CustomDocumentUrinalysis
		WHERE (ISNULL(InterventionOther,'N') = 'Y') AND (InterventionOtherComment IS NULL) 
		UNION
	    SELECT 'CustomDocumentUrinalysis', 'ResponseToIntervention', 'Temperature of urine sample must be specified'
		FROM #CustomDocumentUrinalysis
		WHERE UrinalysisTemperature IS NULL 
		UNION
	    SELECT 'CustomDocumentUrinalysis', 'ResponseToIntervention', 'Share with client must be specified'
		FROM #CustomDocumentUrinalysis
		WHERE UrinalysisShareWithClient IS NULL
		UNION
	    SELECT 'CustomDocumentUrinalysis', 'ResponseToIntervention', 'Consistent with client report must be specified'
		FROM #CustomDocumentUrinalysis
		WHERE UrinalysisConsistentWithClientReport IS NULL
		
		Insert into #validationReturnTable
		(TableName,
		ColumnName,
		ErrorMessage
		)
	    SELECT 'CustomDocumentUrinalysis', 'DeletedBy', 'Error occurred. Please contact your system administrator. No record exists in custom table.'
		WHERE NOT EXISTS  (SELECT 1 FROM #CustomDocumentUrinalysis)

	END TRY  
  
	BEGIN CATCH  
	 DECLARE @Error VARCHAR(5000)  
	  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(5000),ERROR_MESSAGE())  
	   + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'csp_ValidateCustomUrinalysisNotes')  
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


