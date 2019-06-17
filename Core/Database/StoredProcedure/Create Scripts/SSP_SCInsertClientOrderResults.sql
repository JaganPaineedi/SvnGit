/****** Object:  StoredProcedure [dbo].[SSP_SCInsertClientOrderResults]    Script Date: 10/29/2014 15:03:31 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCInsertClientOrderResults]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_SCInsertClientOrderResults] --10,'20151102051702','Pradeep,A(123)'
GO

/****** Object:  StoredProcedure [dbo].[SSP_SCInsertClientOrderResults]    Script Date: 10/29/2014 15:03:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_SCInsertClientOrderResults] @ClientOrderId BIGINT
	,@ResultDateTime VARCHAR(MAX)
	,@LabMedicalDirector VARCHAR(MAX)
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: Nov 11, 2015      
-- Description: Return ClientOrderResultId after insert into CLientOrderResults    
/*      
 Author			Modified Date			Reason      
   
      
*/
-- =============================================      
BEGIN
	BEGIN TRY
		DECLARE @ResultDate DATETIME
		DECLARE @User VARCHAR(200)
		DECLARE @ClientOrderResultId INT

		SET @User = CURRENT_USER
        
        IF LEN(@ResultDateTime) = 12
        BEGIN        
            SET @ResultDateTime = @ResultDateTime + '00'
        END
		SET @ResultDate = CONVERT(DATETIME, stuff(stuff(stuff(@ResultDateTime, 9, 0, ' '), 12, 0, ':'), 15, 0, ':'))

		IF NOT EXISTS (
				SELECT 1
				FROM ClientOrderResults
				WHERE ClientOrderId = @ClientOrderId
					AND LabMedicalDirector = @LabMedicalDirector
					AND ISNULL(RecordDeleted, 'N') = 'N'
				)
		BEGIN
			-- Delete the Existing ClientOrderResults entry if the @LabMedicalDirector,and ClientOrderId are not same.
			UPDATE ClientOrderResults
			SET RecordDeleted = 'Y'
				,DeletedDate = GETDATE()
				,DeletedBy = 'SSP_SCInsertClientOrderResults'
			WHERE ClientOrderId = @ClientOrderId
				AND LabMedicalDirector != @LabMedicalDirector

			INSERT INTO ClientOrderResults (
				CreatedBy
				,CreatedDate
				,ModifiedBy
				,ModifiedDate
				,ClientOrderId
				,LabMedicalDirector
				,ResultDateTime
				)
			VALUES (
				@User
				,GetDate()
				,@User
				,GetDate()
				,@ClientOrderId
				,@LabMedicalDirector
				,@ResultDate
				)

			SET @ClientOrderResultId = SCOPE_IDENTITY()
		END
		ELSE
		BEGIN
			SELECT @ClientOrderResultId = ClientOrderResultId
			FROM ClientOrderResults
			WHERE ClientOrderId = @ClientOrderId
				AND LabMedicalDirector = @LabMedicalDirector
				AND ISNULL(RecordDeleted, 'N') = 'N'

			UPDATE ClientOrderResults
			SET ResultDateTime = @ResultDate
			WHERE ClientOrderResultId = @ClientOrderResultId
		END

		RETURN @ClientOrderResultId
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'SSP_SCInsertClientOrderResults') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


