
/****** Object:  StoredProcedure [dbo].[ssp_JobForCreateClientNoteFlags]    Script Date: 07/26/2018 16:23:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_JobForCreateClientNoteFlags]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_JobForCreateClientNoteFlags]
GO

/****** Object:  StoredProcedure [dbo].[ssp_JobForCreateClientNoteFlags]    Script Date: 07/26/2018 16:23:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].ssp_JobForCreateClientNoteFlags (@RealTime CHAR(1)='N')
AS
/*********************************************************************  
-- Trigger: ssp_JobForCreateClientNoteFlags  
--  
-- Copyright: Streamline Healthcare Solutions  
--  Schduled for every 5 mins
-- Updates:   
--  Date         Author       Purpose  
--  07.11.2018   Ravi         Created For Task #590 Engineering Improvement Initiatives- NBL(I)
**********************************************************************/    
BEGIN
	BEGIN TRY
		DECLARE @ScreenKeyId INT
		DECLARE @SystemEventConfigurationId INT
		DECLARE @StoredProcedureName VARCHAR(250)
		DECLARE @SQL VARCHAR(max)

		DECLARE SystemEvents_cursor CURSOR
		FOR
		SELECT SEC.SystemEventConfigurationId
			,SE.EventKeyId
		FROM SystemEvents SE
		JOIN SystemEventConfigurations SEC ON SEC.SystemEventConfigurationId = SE.SystemEventConfigurationId
		WHERE ISNULL(SEC.RealTime, 'N') = @RealTime
			AND SE.EventStatus IS NULL

		OPEN SystemEvents_cursor

		FETCH NEXT
		FROM SystemEvents_cursor
		INTO @SystemEventConfigurationId
			,@ScreenKeyId

		WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT @StoredProcedureName = EventHandlerAgent
			FROM SystemEventConfigurations
			WHERE SystemEventConfigurationId = @SystemEventConfigurationId
			
			EXEC @StoredProcedureName @ScreenKeyId

			FETCH NEXT
			FROM SystemEvents_cursor
			INTO @SystemEventConfigurationId
				,@ScreenKeyId
		END

		CLOSE SystemEvents_cursor

		DEALLOCATE SystemEvents_cursor
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_ProcessClientNoteEpisodeStart') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,16
				,- 1
				);
	END CATCH
END
