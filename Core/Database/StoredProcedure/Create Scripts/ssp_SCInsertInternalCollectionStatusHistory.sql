/****** Object:  StoredProcedure [dbo].[ssp_SCInsertInternalCollectionStatusHistory]    Script Date: 08/10/2015 19:38:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCInsertInternalCollectionStatusHistory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCInsertInternalCollectionStatusHistory]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCInsertInternalCollectionStatusHistory]    Script Date: 08/10/2015 19:38:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCInsertInternalCollectionStatusHistory] (
	@UserCode VARCHAR(30)
	,@CollectionId INT
	,@CollectionStatus INT
	,@ClientId INT
	,@PaymentPlanAmount DECIMAL(16,2)
	)
	/********************************************************************************                                                    
-- Stored Procedure: ssp_SCInsertInternalCollectionStatusHistory  
--  
-- Copyright: Streamline Healthcate Solutions  
--  
-- Purpose: To Insert Status History  
--  
-- Author: Akwinass   
-- Date:   12-AUG-2015  

*********************************************************************************/
AS
BEGIN
	BEGIN TRY	
		IF NOT EXISTS(SELECT 1 FROM Collections WHERE CollectionId = @CollectionId AND ClientId = @ClientId AND ISNULL(RecordDeleted, 'N') = 'N' AND ISNULL(PaymentPlanAmount,0.00) = @PaymentPlanAmount)
		BEGIN
			DECLARE @PaymentPlanCollectionStatus INT
			
			SELECT TOP 1 @PaymentPlanCollectionStatus = GlobalCodeId
			FROM GlobalCodes
			WHERE ISNULL(Category, '') = 'COLLECTIONSTATUS'
				AND ISNULL(Code, '') = 'PA'
				AND ISNULL(RecordDeleted, 'N') = 'N'
				AND ISNULL(Active, 'N') = 'Y'
							
			INSERT INTO CollectionStatusHistory (
				CreatedBy
				,CreatedDate
				,ModifiedBy
				,ModifiedDate
				,CollectionId
				,CollectionDate
				,CollectionStatus
				,Balance
				,IsDeletable
				)
			SELECT @UserCode
				,GETDATE()
				,@UserCode
				,GETDATE()
				,@CollectionId
				,GETDATE()
				,CASE WHEN @PaymentPlanCollectionStatus = 0 THEN NULL ELSE @PaymentPlanCollectionStatus END
				,(SELECT TOP 1 ISNULL(C.CurrentBalance, 0.00) FROM Clients C WHERE C.ClientId = @ClientId AND ISNULL(RecordDeleted, 'N') = 'N')
				,'N'
		END
			
		IF NOT EXISTS(SELECT 1 FROM Collections WHERE CollectionId = @CollectionId AND ClientId = @ClientId AND ISNULL(RecordDeleted, 'N') = 'N' AND ISNULL(CollectionStatus,0) = @CollectionStatus)
		BEGIN
			INSERT INTO CollectionStatusHistory (
				CreatedBy
				,CreatedDate
				,ModifiedBy
				,ModifiedDate
				,CollectionId
				,CollectionDate
				,CollectionStatus
				,Balance
				,IsDeletable
				)
			SELECT @UserCode
				,GETDATE()
				,@UserCode
				,GETDATE()
				,@CollectionId
				,GETDATE()
				,CASE WHEN @CollectionStatus = 0 THEN NULL ELSE @CollectionStatus END
				,(SELECT TOP 1 ISNULL(C.CurrentBalance, 0.00) FROM Clients C WHERE C.ClientId = @ClientId AND ISNULL(RecordDeleted, 'N') = 'N')
				,'Y'
		END

	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCInsertInternalCollectionStatusHistory') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


