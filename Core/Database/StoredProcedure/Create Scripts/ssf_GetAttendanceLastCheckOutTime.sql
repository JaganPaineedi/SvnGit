/****** Object:  UserDefinedFunction [dbo].[ssf_GetAttendanceLastCheckOutTime]    Script Date: 10/28/2015 17:54:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssf_GetAttendanceLastCheckOutTime]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ssf_GetAttendanceLastCheckOutTime]
GO

/****** Object:  UserDefinedFunction [dbo].[ssf_GetAttendanceLastCheckOutTime]    Script Date: 10/28/2015 17:54:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--select [dbo].[ssf_GetAttendanceLastCheckOutTime](594,4)
CREATE FUNCTION [dbo].[ssf_GetAttendanceLastCheckOutTime] (
	@GroupServiceId INT
	,@ClientId INT
	)
RETURNS DATETIME
	/****************************************************************************************/
	/* Created(Task #17 in Valley - Support Go Live)							            */
	/* Author: Akwinass																        */
	/* Date: 28 OCT 2015																	*/
	/* Updates:                                                                             */
	/* Date            Author              Purpose                                          */
	/* 15-APRIL-2016  Akwinass	           What:Included "Complete" Services.               */
	/*							           Why:task #207 Valley - Support Go Live           */
	/****************************************************************************************/
AS
BEGIN
	DECLARE @TimeOut DATETIME = NULL

	SET @TimeOut = (
			SELECT TOP 1 S.DateTimeOut
			FROM Services S
			WHERE S.ClientId = @ClientId
				AND S.GroupServiceId = @GroupServiceId
				AND ISNULL(S.RecordDeleted, 'N') = 'N'
				AND S.[Status] IN (71,75)
			ORDER BY s.ServiceId DESC
			)

	RETURN @TimeOut

END

GO