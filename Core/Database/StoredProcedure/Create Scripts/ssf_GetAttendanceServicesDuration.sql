IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssf_GetAttendanceServicesDuration]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ssf_GetAttendanceServicesDuration]
GO
--select [dbo].[ssf_GetAttendanceServicesDuration](594,4)
CREATE FUNCTION [dbo].[ssf_GetAttendanceServicesDuration] (@GroupServiceId INT,@ClientId INT) RETURNS VARCHAR(200)
/****************************************************************************************/
/* Created(Task #829 in Woods - Customizations)							*/
/* Author: Avi Goyal																*/
/* Date: 05 Jun 2015																		*/
/****************************************************************************************/
AS
BEGIN
	DECLARE @Duration VARCHAR(200)='0'
	
	IF NOT EXISTS(
					SELECT 1
					FROM Services S
					WHERE S.ClientId=@ClientId AND S.GroupServiceId=@GroupServiceId AND ISNULL(S.RecordDeleted,'N')='N'
							AND S.DateTimeOut IS NULL
					)
	BEGIN
	
		--DECLARE @TimeIn DATETIME
		--SET @TimeIn =
		--		(
		--			SELECT TOP 1  S.DateOfService
		--			FROM Services S
		--			WHERE S.ClientId=@ClientId AND S.GroupServiceId=@GroupServiceId AND ISNULL(S.RecordDeleted,'N')='N'
		--			ORDER BY S.DateOfService ASC
		--		)
		--DECLARE @TimeOut DATETIME=NULL
		--SET @TimeOut =
		--			(
		--				SELECT TOP 1 S.EndDateOfService
		--				FROM Services S
		--				WHERE S.ClientId=@ClientId AND S.GroupServiceId=@GroupServiceId AND ISNULL(S.RecordDeleted,'N')='N'
		--				ORDER BY S.EndDateOfService DESC
		--			)
	
		SET @Duration =CAST 
						(
							(
								SELECT SUM(DATEDIFF(MINUTE,S.DateTimeIn,S.DateTimeOut)) AS Duration
								FROM Services S
								WHERE S.ClientId=@ClientId AND S.GroupServiceId=@GroupServiceId AND ISNULL(S.RecordDeleted,'N')='N'
							)
							AS
							VARCHAR(200)
						)
	END
	
	RETURN ISNULL(@Duration,'0')
END
GO