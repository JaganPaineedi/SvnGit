IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssf_GetAttendanceServicesTimeIn]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ssf_GetAttendanceServicesTimeIn]
GO

CREATE FUNCTION [dbo].[ssf_GetAttendanceServicesTimeIn] (@GroupServiceId INT,@ClientId INT) RETURNS DATETIME
/****************************************************************************************/
/* Created(Task #829 in Woods - Customizations)							*/
/* Author: Avi Goyal																*/
/* Date: 05 Jun 2015																		*/
/****************************************************************************************/
AS
BEGIN
	DECLARE @TimeIn DATETIME
	SET @TimeIn =
				(
					--SELECT TOP 1  CONVERT(DATETIME, CONVERT(CHAR(8), S.DateOfService, 112)  + ' ' + CONVERT(CHAR(8), S.DateOfService, 108))
					--FROM Services S
					--WHERE S.ClientId=4 AND S.GroupServiceId=320 AND ISNULL(S.RecordDeleted,'N')='N'
					--ORDER BY CAST(S.DateOfService as TIME) ASC
					SELECT TOP 1  S.DateTimeIn
					FROM Services S
					WHERE S.ClientId=@ClientId AND S.GroupServiceId=@GroupServiceId AND ISNULL(S.RecordDeleted,'N')='N' AND S.DateTimeIn IS NOT NULL
					ORDER BY S.DateTimeIn ASC
				)
	RETURN @TimeIn
END
GO