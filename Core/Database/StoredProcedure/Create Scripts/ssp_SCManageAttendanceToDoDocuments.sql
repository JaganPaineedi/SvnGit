/****** Object:  StoredProcedure [dbo].[ssp_SCManageAttendanceToDoDocuments]    Script Date: 02/17/2016 13:08:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCManageAttendanceToDoDocuments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCManageAttendanceToDoDocuments]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCManageAttendanceToDoDocuments]    Script Date: 02/17/2016 13:08:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCManageAttendanceToDoDocuments] (
	@ServiceId INT
	,@GroupServiceId INT
	,@UserCode VARCHAR(30)
	,@ClientId INT	
	)

/********************************************************************************                                                 
** Stored Procedure: ssp_SCManageAttendanceToDoDocuments                                                    
**                                                  
** Copyright: Streamline Healthcate Solutions                                                    
** Updates:                                                                                                         
** Date            Author              Purpose   
** 17-FEB-2016	   Akwinass			   What:Managed Attendance(Weekly Note & Daily Note) To Do Documents
**									   Why:Task #167 in Valley - Support Go Live   
*********************************************************************************/
AS
BEGIN
	BEGIN TRY	
		IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_SCManageAttendanceToDoDocuments]') AND type in (N'P', N'PC'))
		BEGIN
			EXEC scsp_SCManageAttendanceToDoDocuments @ServiceId,@GroupServiceId,@UserCode,@ClientId
		END
	END TRY

      BEGIN CATCH
          DECLARE @error VARCHAR(8000)

          SET @error= CONVERT(VARCHAR, Error_number()) + '*****'
                      + CONVERT(VARCHAR(4000), Error_message())
                      + '*****'
                      + Isnull(CONVERT(VARCHAR, Error_procedure()),
                      'ssp_SCManageAttendanceToDoDocuments')
                      + '*****' + CONVERT(VARCHAR, Error_line())
                      + '*****' + CONVERT(VARCHAR, Error_severity())
                      + '*****' + CONVERT(VARCHAR, Error_state())

          RAISERROR (@error,-- Message text.
                     16,-- Severity.
                     1 -- State.
          );
      END CATCH
  END 
GO