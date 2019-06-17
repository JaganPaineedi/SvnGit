IF EXISTS (SELECT * 
           FROM   SYS.objects 
           WHERE  object_id = 
                  Object_id(N'[dbo].[csp_SCGetCustomInvoluntaryServices]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[csp_SCGetCustomInvoluntaryServices] 

GO 

CREATE PROCEDURE [dbo].[csp_SCGetCustomInvoluntaryServices] --54 
-- csp_SCGetCustomInvoluntaryServices 54             
(@DocumentVersionId INT) 
AS 
/*********************************************************************/ 
/* Stored Procedure: [csp_SCGetCustomInvoluntaryServices]               */ 
/* Creation Date:  05 May 2015                                   */ 
/* Author:  Malathi Shiva                     */ 
/* Purpose: To load data after save */ 
/* Data Modifications:                   */ 
/*  Modified By    Modified Date    Purpose        */ 
/*                                                                   */ 
  /*********************************************************************/ 
  BEGIN TRY 
      DECLARE @LatestDocumentVersionID INT 
	  DECLARE @ClientID INT

	  SET @ClientID = (SELECT ClientId FROM Documents WHERE InProgressDocumentVersionId = @DocumentVersionId)

      SET @LatestDocumentVersionID =(SELECT TOP 1 CurrentDocumentVersionId 
                                     FROM   CustomDocumentRegistrations CDR 
                                            ,Documents Doc 
                                     WHERE 
      CDR.DocumentVersionId = Doc.CurrentDocumentVersionId 
      AND Doc.ClientId = @ClientID 
      AND Doc.Status = 22 
      AND DocumentCodeId = 28812
      AND IsNull(CDR.RecordDeleted, 'N') = 'N' 
      AND IsNull(Doc.RecordDeleted, 'N') = 'N' 
                                     ORDER  BY Doc.EffectiveDate DESC 
                                               ,Doc.ModifiedDate DESC) 

      --CustomDocumentInvoluntaryServices           
      SELECT CDI.DocumentVersionId 
      ,CDI.CreatedBy 
      ,CDI.CreatedDate 
      ,CDI.ModifiedBy 
      ,CDI.ModifiedDate 
      ,CDI.RecordDeleted 
      ,CDI.DeletedBy 
      ,CDI.DeletedDate 
      ,CDI.SIDNumber 
      ,CDI.ServiceStatus 
      ,CDI.TypeOfPetition 
      ,CDI.DateOfPetition 
      ,CDI.HearingRecommended 
      ,CDI.ReasonForHearing 
      ,CDI.BasisForInvoluntaryServices 
      ,CDI.DispositionByJudge 
      ,CDI.InvoluntaryServicesCommitted 
      ,CDI.ServiceSettingAssignedTo 
      ,CDI.DateOfCommitment 
      ,CDI.LengthOfCommitment 
      ,CDI.PeriodOfIntensiveTreatment 
      FROM   CustomDocumentInvoluntaryServices CDI 
      WHERE  ISNull(RecordDeleted, 'N') = 'N' 
             AND [DocumentVersionId] = @DocumentVersionId 
  END TRY 

  BEGIN CATCH 
      DECLARE @Error VARCHAR(8000) 

      SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
                  + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) 
                  + '*****' 
                  + isnull(CONVERT(VARCHAR, ERROR_PROCEDURE()), 
                  'csp_SCGetCustomInvoluntaryServices') 
                  + '*****' + CONVERT(VARCHAR, ERROR_LINE()) 
                  + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) 
                  + '*****' + CONVERT(VARCHAR, ERROR_STATE()) 

      RAISERROR ( @Error,-- Message text.                         
                  16,-- Severity.                         
                  1 -- State.                         
      ); 
  END CATCH 

GO 