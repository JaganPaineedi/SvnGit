/****** Object:  StoredProcedure [dbo].[ssp_ServiceNoteUpdateGroupServiceStatus]    Script Date: 02/19/2016 10:12:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ServiceNoteUpdateGroupServiceStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ServiceNoteUpdateGroupServiceStatus]
GO

/****** Object:  StoredProcedure [dbo].[ssp_ServiceNoteUpdateGroupServiceStatus]    Script Date: 02/19/2016 10:12:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[ssp_ServiceNoteUpdateGroupServiceStatus] @ScreenKeyId INT
	,@StaffId INT
	,@CurrentUser VARCHAR(30)
	,@CustomParameters XML
AS
/******************************************************************************                      
**  File:                       
**  Name: ssp_ServiceNotePostUpdate                      
**  Desc:                       
**                      
**  This template can be customized:                      
**                                    
**  Return values:                      
**                       
**  Called by:                         
**                                    
**  Parameters:                      
**  Input       Output                      
**     ----------       -----------                      
**                      
**  Auth:                       
**  Date:                       
*******************************************************************************                      
**  Change Histor6y                      
*******************************************************************************                      
**  Date:      Author:  Purpose:      Description:                      
**  ---------  --------  ----------    -------------------------------------------                      
**  11Sept2012  Shifali  Created    Thresholds Bugs/Features, task# 1855 (update Group Service status if service is part of Group Service)  
**  22-Feb-2016	Akwinass	What:Included ssp_SCManageAttendanceToDoDocuments, To create To Do document for the Associated Attendance Group Service.          
**							Why:task #167 Valley - Support Go Live
*******************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @GroupServiceId INT
		DECLARE @GroupStatus INT

		SELECT @GroupServiceId = GroupServiceId
		FROM Services
		WHERE ServiceId = @ScreenKeyId

		IF (ISNULL(@GroupServiceId, 0) > 0)
		BEGIN
			SET @GroupStatus = (SELECT [dbo].[SCGetGroupServiceStatus](@GroupServiceId))

			IF (ISNULL(@GroupStatus, '') <> '')
			BEGIN
				UPDATE Groupservices SET [Status] = @GroupStatus WHERE GroupServiceId = @GroupServiceId
			END
		END

		--22-Feb-2016	Akwinass		
		DECLARE @ClientId INT
		SELECT TOP 1 @ClientId = ClientId FROM Services WHERE ServiceId = @ScreenKeyId AND ISNULL(RecordDeleted, 'N') = 'N'
		EXEC ssp_SCManageAttendanceToDoDocuments @ScreenKeyId,NULL,@CurrentUser,@ClientId		
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_ServiceNoteUpdateGroupServiceStatus') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


