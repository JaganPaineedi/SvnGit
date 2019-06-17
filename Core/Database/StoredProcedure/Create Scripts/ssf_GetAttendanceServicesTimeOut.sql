IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssf_GetAttendanceServicesTimeOut]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ssf_GetAttendanceServicesTimeOut]
GO
--select [dbo].[ssf_GetAttendanceServicesTimeOut](594,4)
CREATE FUNCTION [dbo].[ssf_GetAttendanceServicesTimeOut] (@GroupServiceId INT,@ClientId INT) RETURNS DATETIME
/****************************************************************************************/
/* Created(Task #829 in Woods - Customizations)							*/
/* Author: Avi Goyal																*/
/* Date: 05 Jun 2015																		*/
/****************************************************************************************/
AS
BEGIN
	DECLARE @TimeOut DATETIME=NULL
	
	IF NOT EXISTS(
					SELECT TOP 1 S.DateOfService
					FROM Services S
					WHERE S.ClientId=@ClientId AND S.GroupServiceId=@GroupServiceId AND ISNULL(S.RecordDeleted,'N')='N'
							AND S.DateTimeOut IS NULL
					)
	BEGIN
		SET @TimeOut =
					(
						SELECT TOP 1 S.DateTimeOut
						FROM Services S
						WHERE S.ClientId=@ClientId AND S.GroupServiceId=@GroupServiceId AND ISNULL(S.RecordDeleted,'N')='N'
						ORDER BY S.DateTimeOut DESC
					)
	END
	RETURN @TimeOut
END
GO