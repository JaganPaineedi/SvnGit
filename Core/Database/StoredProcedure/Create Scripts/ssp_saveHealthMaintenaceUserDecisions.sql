GO

/****** Object:  StoredProcedure [dbo].[ssp_saveHealthMaintenaceUserDecisions]    Script Date: 08/12/2014 19:14:42 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_saveHealthMaintenaceUserDecisions]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_saveHealthMaintenaceUserDecisions]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_saveHealthMaintenaceUserDecisions]    Script Date: 08/12/2014 19:14:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_saveHealthMaintenaceUserDecisions] (
	@acceptedKeys VARCHAR(max)
	,@rejectedKeys VARCHAR(max)
	,@clientId INT
	,@usercode VARCHAR(100) --Added by Veena on 08/14/18 Boundless - Support #273
	)
/*********************************************************************************/                
/* Stored Procedure: ssp_ListPageSCClientHealthMaintenance         */       
/* Copyright: Streamline Healthcare Solutions          */                                                
/* Date              Modified by             Purpose        */                
/* 27-Nov-2016       Pavani			         What:Added ModifiedDate column while updating ClientHealthMaintenanceDecisions table
                                             Why : Meaningful Stage-3 Task#37  */   
/* 14-Aug-2018       Veena                   What:Added Usercode as parameter
                                             Why:while updating userdecision,the accepted staff is not getting recorded.  	Boundless - Support #273 */  
/*********************************************************************************/ 
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

		IF (
				@acceptedKeys IS NOT NULL
				AND @acceptedKeys <> ''
				)
		BEGIN
			UPDATE ClientHealthMaintenanceDecisions
			SET UserDecision = 'Y'
			--Added by Veena on 08/14/18 Boundless - Support #273
			,ModifiedBy = @usercode ,ModifiedDate =getdate()
			WHERE ClientHealthMaintenanceDecisionId IN (
					SELECT Token
					FROM [dbo].[SplitString](@acceptedKeys, ',')
					)
					
			-- Added by ponnin
			
			INSERT INTO HealthMaintenanceClientTemplates (HealthMaintenanceTemplateId, ClientId, Active ) 
			
			SELECT  DISTINCT HealthMaintenanceTemplateId, @clientId, 'Y' FROM ClientHealthMaintenanceDecisions
			WHERE UserDecision = 'Y' AND ClientHealthMaintenanceDecisionId IN (
			SELECT Token
			FROM [dbo].[SplitString](@acceptedKeys, ',')
			)
			-- Added by ponnin Ends here.....
					
					
					
		END

		IF (
				@rejectedKeys IS NOT NULL
				AND @rejectedKeys <> ''
				)
		BEGIN
			UPDATE ClientHealthMaintenanceDecisions
			SET UserDecision = 'N',
			--Added by Veena on 08/14/18 Boundless - Support #273
			ModifiedBy = @usercode 
			--27-Nov-2016       Pavani
			,ModifiedDate=GETDATE()
			--End
			WHERE ClientHealthMaintenanceDecisionId IN (
					SELECT Token
					FROM [dbo].[SplitString](@rejectedKeys, ',')
					)
		END

			
			select dbo.ssf_getHealthMaintenanceAlertCount (@clientId) as TotalHealthMaintenanceAlertCount

		COMMIT TRANSACTION

		IF @@error <> 0
			GOTO rollback_tran

		RETURN

		rollback_tran:

		ROLLBACK TRANSACTION
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_saveHealthMaintenaceUserDecisions') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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

