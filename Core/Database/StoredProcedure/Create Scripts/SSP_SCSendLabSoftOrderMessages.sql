/****** Object:  StoredProcedure [dbo].[SSP_SCSendLabSoftOrderMessages]    Script Date: 10/29/2014 15:03:31 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCSendLabSoftOrderMessages]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_SCSendLabSoftOrderMessages]
GO

/****** Object:  StoredProcedure [dbo].[SSP_SCSendLabSoftOrderMessages]    Script Date: 10/29/2014 15:03:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_SCSendLabSoftOrderMessages]
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: Sept 23, 2014      
-- Description: Process the   
/*      
 Author			Modified Date			Reason      
   
      
*/
-- =============================================      
BEGIN
	BEGIN TRY
		DECLARE @LabSoftMessageId INT
		DECLARE @LabSoftServiceUrl VARCHAR(500)
		DECLARE @TimeOut INT
		DECLARE @ServiceKey VARCHAR(100)
		DECLARE @ServiceSecret VARCHAR(100)
		DECLARE @LabSoftOrganizationId INT
		DECLARE @CurrentUser VARCHAR(500)
		DECLARE @MessageOUTPUT INT

		SELECT @LabSoftOrganizationId = CONVERT(INT, ISNULL(dbo.ssf_GetSystemConfigurationKeyValue('LABSOFTORGANIZATIONID'), 0))

		SELECT @CurrentUser = SYSTEM_USER

		IF @LabSoftOrganizationId > 0
		BEGIN
			SELECT @LabSoftServiceUrl = ISNULL(dbo.ssf_GetSystemConfigurationKeyValue('LABSOFTWEBSERVICEURL'), '')

			SELECT @ServiceKey = AuthenticationKey
				,@ServiceSecret = AuthenticationSecret
			FROM LabSoftServiceAuthentications LSSA
			WHERE LSSA.LabSoftOrganizationId = @LabSoftOrganizationId
				AND ISNULL(LSSA.REcordDeleted, 'N') = 'N'

			DECLARE orderMessage CURSOR LOCAL FAST_FORWARD
			FOR
			SELECT LabSoftMessageId
			FROM LabSoftMessages
			WHERE MessageProcessingState = 9357
				AND ISNULL(RecordDeleted, 'N') = 'N'

			OPEN orderMessage

			WHILE 1 = 1
			BEGIN
				FETCH orderMessage
				INTO @LabSoftMessageId

				IF @@fetch_status <> 0
					BREAK

				-- ======================================
				-- Write your Logic Here
				-- ======================================
				SELECT @MessageOUTPUT = CAST([dbo].[SendLabOrderMessage](@LabSoftServiceUrl, 60*1000, @ServiceKey, @ServiceSecret, @LabSoftMessageId) AS INT)

				IF @MessageOUTPUT <= 0
				BEGIN
					INSERT INTO LabSoftEventLog (
						ErrorMessage
						,VerboseInfo
						,ErrorType
						,CreatedBy
						,CreatedDate
						)
					VALUES (
						'Message sending failed. Please try again.'
						,NULL
						,NULL
						,'LabSoft Procedure Error'
						,GetDate()
						)
				END
			END

			CLOSE orderMessage

			DEALLOCATE orderMessage
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'SSP_SCSendLabSoftOrderMessages') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


