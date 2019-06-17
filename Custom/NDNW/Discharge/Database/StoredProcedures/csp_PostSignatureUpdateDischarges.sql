/****** Object:  StoredProcedure [dbo].[csp_PostSignatureUpdateDischarges]    Script Date: 10/13/2015 15:31:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PostSignatureUpdateDischarges]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PostSignatureUpdateDischarges]
GO


/****** Object:  StoredProcedure [dbo].[csp_PostSignatureUpdateDischarges]    Script Date: 07/18/2014 15:24:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE  PROCEDURE [dbo].[csp_PostSignatureUpdateDischarges] (@DocumentVersionId INT)
AS
/******************************************************************** */
/* Stored Procedure: [csp_PostSignatureUpdateDischarges]               */
/* Creation Date:  08/FEB/2015                                    */
/* Purpose: To Create a Todo document */
/*       Date              Author                  Purpose                   */
/*      23-05-2018     Neethu              Added insert query for [ClientProgramHistory] table   */

/***********************************************************************/
BEGIN
	BEGIN TRY

			DECLARE @ClientId INT
			DECLARE @ToDoDocumentId INT
			DECLARE @CurrentUserId VARCHAR(20)
			DECLARE @CurrentUserCode VARCHAR(20)
			DECLARE @AssignedTo INT
			DECLARE @ToDoEffectiveDate DATETIME
			DECLARE @DocumentCodeId INT
			DECLARE @EffectiveDate DATETIME
			DECLARE @ToDoDocumentVersionId INT
			DECLARE @Day varchar(20)
			DECLARE @AssignedTo1 INT

			SELECT @ClientId = ClientId
				,@EffectiveDate = EffectiveDate
				,@DocumentCodeId = DocumentCodeId
				,@AssignedTo = AuthorId
			FROM Documents
			WHERE CurrentDocumentVersionid = @DocumentVersionId
	
		DECLARE @TypeOfDischarge VARCHAR(1)
		DECLARE @ClientEpisodeId INT 
		DECLARE @ClientProgramId INT
		
		SET @ClientProgramId = (
				SELECT NewPrimaryClientProgramId
				FROM CustomDocumentDischarges
				WHERE DocumentVersionId = @DocumentVersionId
				)
				
		UPDATE ClientPrograms
		SET PrimaryAssignment = 'N'
		WHERE ClientId = @ClientId
			AND PrimaryAssignment = 'Y'
			
		UPDATE ClientPrograms
		SET PrimaryAssignment = 'Y'
		WHERE ClientProgramId = @ClientProgramId
			AND ClientId = @ClientId

		
		SET @TypeOfDischarge = (
				SELECT DischargeType
				FROM CustomDocumentDischarges
				WHERE DocumentVersionId = @DocumentVersionId
				)
				
		SET @ClientEpisodeId = (
				SELECT max(ce.ClientEpisodeId)
				FROM ClientEpisodes ce
				WHERE ISNULL(ce.RecordDeleted, 'N') = 'N'
					AND ce.ClientId = @ClientId
					AND ce.DischargeDate IS NULL
				) 

		UPDATE ClientPrograms
		SET Status = 5
			,DischargedDate = Case when (cast(convert(VARCHAR(10), EnrolledDate, 101) AS DATE) <= cast(convert(VARCHAR(10), @EffectiveDate, 101) AS DATE)) then convert(VARCHAR(10), @EffectiveDate, 101) else convert(VARCHAR(10), GETDATE(), 101) end
		WHERE ClientId = @ClientId
			AND ClientProgramId IN (
				SELECT ClientProgramId
				FROM CustomDischargePrograms
				WHERE DocumentVersionId = @DocumentVersionId
					AND RecordDeleted = 'N'
				)
				
						
  	
	INSERT INTO [ClientProgramHistory] ([CreatedDate],[ModifiedDate],[ClientProgramId],[Status],[RequestedDate],[EnrolledDate],[DischargedDate],[PrimaryAssignment],[AssignedStaffId])  
   SELECT  GETDATE()  
    ,GETDATE()  
    ,ClientProgramId  
    ,[Status]  
    ,RequestedDate  
    ,EnrolledDate  
    ,DischargedDate  
    ,PrimaryAssignment  
    ,AssignedStaffId  
   FROM ClientPrograms  
  	 		WHERE ClientId = @ClientId
			AND ClientProgramId IN (
				SELECT ClientProgramId
				FROM CustomDischargePrograms
				WHERE DocumentVersionId = @DocumentVersionId
					AND RecordDeleted = 'N'
				)
 		
				
					
		IF (@TypeOfDischarge = 'A')
		BEGIN
			UPDATE ClientEpisodes
			SET Status = 102
				,DischargeDate = GETDATE()
				,ModifiedBy = CURRENT_USER
				,ModifiedDate = GETDATE()
			WHERE ClientId = @ClientId
				AND ClientEpisodeId = @ClientEpisodeId
		END
		
		IF (@TypeOfDischarge = 'A')
		BEGIN
		Update ClientCoverageHistory SET EndDate = convert(VARCHAR(10), @EffectiveDate, 101) where ClientCoveragePlanId in
(select CCP.ClientCoveragePlanId from dbo.ClientCoveragePlans CCP join CoveragePlans CP on CP.CoveragePlanId = CCP.CoveragePlanId  where ClientId = @ClientId 
and CP.Active = 'Y') and IsNULL (StartDate,'') != '' and  IsNULL (EndDate,'') = ''
END

		--IF (@TypeOfDischarge = 'A')
		--BEGIN
		--Update CustomClientFees SET EndDate = convert(VARCHAR(10), @EffectiveDate, 101) where ClientId = @ClientId
		--and IsNULL (StartDate,'') != '' and  IsNULL (EndDate,'') = ''
		--END



		
										
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_PostSignatureUpdateDischarges') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                                  
				16
				,-- Severity.                                                                                                  
				1 -- State.                                                                                                  
				);
	END CATCH
END


GO
