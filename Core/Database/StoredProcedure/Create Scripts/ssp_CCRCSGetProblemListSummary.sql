/****** Object:  StoredProcedure [dbo].[ssp_CCRCSGetProblemListSummary]    Script Date: 06/11/2015 17:24:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CCRCSGetProblemListSummary]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CCRCSGetProblemListSummary]
GO

/****** Object:  StoredProcedure [dbo].[ssp_CCRCSGetProblemListSummary]    Script Date: 06/11/2015 17:24:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_CCRCSGetProblemListSummary] (
	@ClientId INT
	,@ServiceId INT
	,@DocumentVersionId INT = NULL
	)
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: Sept 19, 2014      
-- Description: Retrieves CCR Message      
/*      
 Author			Modified Date			Reason      
   
      
*/
-- =============================================   
BEGIN
	DECLARE @DOS DATETIME = NULL
	DECLARE @DocumentCodeId INT

	IF (@ServiceId IS NOT NULL)
	BEGIN
		SELECT @DOS = DateOfService
		FROM Services
		WHERE ServiceId = @ServiceId
	END
	ELSE IF (
			@ServiceId IS NULL
			AND @DocumentVersionId IS NOT NULL
			)
	BEGIN
		SELECT TOP 1 @DOS = EffectiveDate
			,@DocumentCodeId = DocumentCodeId
		FROM Documents
		WHERE InProgressDocumentVersionId = @DocumentVersionId
			AND ISNULL(RecordDeleted, 'N') = 'N'
	END

	BEGIN TRY
		DECLARE @IsProgressNote CHAR(1)

		IF (
				@DocumentCodeId = 1611
				AND @ServiceId IS NULL
				)
		BEGIN
			DECLARE @RegistrationDate DATETIME

			SELECT TOP 1 @RegistrationDate = RegistrationDate
			FROM ClientEpisodes
			WHERE EpisodeNumber = (
					SELECT max(EpisodeNumber)
					FROM ClientEpisodes
					WHERE ClientId = @ClientId
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				AND ClientId = @ClientId
				AND ISNULL(RecordDeleted, 'N') = 'N'

			DECLARE @LatestDiagnosesDocumentVersionID INT

			SELECT TOP 1 @LatestDiagnosesDocumentVersionID = ISNULL(d.CurrentDocumentVersionId, - 1)
			FROM Documents d
			INNER JOIN DocumentCodes Dc ON Dc.DocumentCodeid = d.DocumentCodeid
			WHERE d.ClientId = @ClientId
				AND d.[Status] = 22
				AND Dc.DiagnosisDocument = 'Y'
				AND CAST(d.EffectiveDate AS DATE) = CAST(@RegistrationDate AS DATE)
				AND ISNULL(d.RecordDeleted, 'N') = 'N'
				AND ISNULL(Dc.RecordDeleted, 'N') <> 'Y'
			ORDER BY d.EffectiveDate DESC
				,d.DocumentId DESC

			SELECT DISTINCT 
				'PR.' + CAST(DI.DocumentVersionId AS VARCHAR(100)) + '.' + CAST(DI.DocumentVersionId AS VARCHAR(100)) AS CCRDataObjectID
				    ,CAST(DI.DocumentVersionId AS VARCHAR(100)) + '.' + CAST(DI.DocumentVersionId AS VARCHAR(100)) AS ID1_ActorID
				    ,'Problem ID' AS ID1_IDType
					,'SmartcareWeb' AS ID1_Source_ActorID
					,DI.DSMCODE AS Code_Value					
					,DSM.DSMDescription AS Description
					,'DSM Code' AS Code_CodingSystem
					,CONVERT(VARCHAR(10), @RegistrationDate, 21) AS ApproximateDateTime
					,'Effective Date' AS [DateType]
					,'Active' AS Status
					,'SmartcareWeb' AS SLRCGroup_Source_ActorID
			FROM DiagnosesIAndII DI
			INNER JOIN DiagnosisDSMDescriptions AS DSM ON DI.DSMCODE = DSM.DSMCode
				AND DI.DSMNumber = DSM.DSMNumber
			WHERE DI.DocumentVersionid = @LatestDiagnosesDocumentVersionID
				AND ISNULL(DI.RecordDeleted, 'N') = 'N'
			
			UNION
			
			SELECT DISTINCT
					 'PR.' + CAST(@DocumentCodeId AS VARCHAR(100)) + '.' + CAST(DI.ClientProblemId AS VARCHAR(100)) AS CCRDataObjectID
				    ,CAST(@DocumentCodeId AS VARCHAR(100)) + '.' + CAST(DI.ClientProblemId AS VARCHAR(100)) AS ID1_ActorID
				    ,'Problem ID' AS ID1_IDType
					,'SmartcareWeb' AS ID1_Source_ActorID
					,DI.dsmcode AS Code_Value					
					,DIC.ICDDescription AS Description
					,'DSM Code' AS Code_CodingSystem
					,CONVERT(VARCHAR(10), DI.StartDate, 21) AS ApproximateDateTime
					,'Effective Date' AS [DateType]
					,'Active' AS Status
					,'SmartcareWeb' AS SLRCGroup_Source_ActorID
			FROM clientproblems DI
			LEFT JOIN DiagnosisICDCodes DIC ON DI.DSMCode = DIC.ICDCode
			WHERE DI.clientid = @ClientId
				AND (
					DI.StartDate IS NULL
					OR cast(DI.StartDate AS DATE) <= cast(@DOS AS DATE)
					)
				AND (
					DI.EndDate IS NULL
					OR cast(DI.EndDate AS DATE) >= cast(@DOS AS DATE)
					)
				AND ISNULL(DI.RecordDeleted, 'N') = 'N'
		END
		ELSE
		BEGIN
			IF (@DocumentVersionId IS NULL)
			BEGIN
				SET @IsProgressNote = 'N'
			END
			ELSE
			BEGIN
				SELECT TOP 1 @DocumentCodeId = DocumentCodeId
				FROM Documents
				WHERE InProgressDocumentVersionid = @DocumentVersionId
					AND ISNULL(RecordDeleted, 'N') = 'N'

				IF (@DocumentCodeId = 300)
				BEGIN
					SET @IsProgressNote = 'Y'
				END
				ELSE
				BEGIN
					SET @IsProgressNote = 'N'
				END
			END

			IF (@IsProgressNote = 'Y')
			BEGIN
				SELECT DISTINCT
					 'PR.' + CAST(@DocumentCodeId AS VARCHAR(100)) + '.' + CAST(DI.ClientProblemId AS VARCHAR(100)) AS CCRDataObjectID
				    ,CAST(@DocumentCodeId AS VARCHAR(100)) + '.' + CAST(DI.ClientProblemId AS VARCHAR(100)) AS ID1_ActorID
				    ,'Problem ID' AS ID1_IDType
					,'SmartcareWeb' AS ID1_Source_ActorID
					,'DI.dsmcode' AS Code_Value					
					,DIC.ICDDescription AS Description
					,'DSM Code' AS Code_CodingSystem
					,CONVERT(VARCHAR(10), DI.StartDate, 21) AS ApproximateDateTime
					,'Effective Date' AS [DateType]
					,'Active' AS Status
					,'SmartcareWeb' AS SLRCGroup_Source_ActorID
				FROM clientproblems DI
				LEFT JOIN DiagnosisICDCodes DIC ON DI.DSMCode = DIC.ICDCode
				WHERE DI.clientid = @ClientId
					AND (
						DI.StartDate IS NULL
						OR cast(DI.StartDate AS DATE) <= cast(@DOS AS DATE)
						)
					AND (
						DI.EndDate IS NULL
						OR cast(DI.EndDate AS DATE) >= cast(@DOS AS DATE)
						)
					AND ISNULL(DI.RecordDeleted, 'N') = 'N'
			END
					--if serviceid exist. 
			ELSE
			BEGIN
				SELECT DISTINCT 
				    'PR.' + CAST(D.DocumentId AS VARCHAR(100)) + '.' + CAST(DI.ServiceId AS VARCHAR(100)) AS CCRDataObjectID
				    ,CAST(D.DocumentId AS VARCHAR(100)) + '.' + CAST(DI.ServiceId AS VARCHAR(100)) AS ID1_ActorID
				    ,'Problem ID' AS ID1_IDType
					,'SmartcareWeb' AS ID1_Source_ActorID
				    --,DSM.axis
					,'DSM.dsmcode' AS Code_Value
					,'DSM.dsmdescription' AS Description
					,'DSM Code' AS Code_CodingSystem
					,CONVERT(VARCHAR(10), D.EffectiveDate, 21) AS ApproximateDateTime
					,'Effective Date' AS [DateType]
					,'Active' AS Status
					,'SmartcareWeb' AS SLRCGroup_Source_ActorID
					--,CASE DSM.axis
					--	WHEN 1
					--		THEN 'I'
					--	ELSE 'II'
					--	END AS 'AxisIOrII'
				FROM  Services DI 
				INNER JOIN Documents D ON D.ServiceId = DI.ServiceId
				WHERE DI.ServiceId = @ServiceId
					AND ISNULL(DI.RecordDeleted, 'N') = 'N'
			END
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), '[ssp_CCRCSGetProblemListSummary]') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


