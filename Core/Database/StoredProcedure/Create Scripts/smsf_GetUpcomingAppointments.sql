/****** Object:  UserDefinedFunction [dbo].[smsf_GetUpcomingAppointments]    Script Date: 09/30/2016 18:04:11 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[smsf_GetUpcomingAppointments]')
			AND type IN (
				N'FN'
				,N'IF'
				,N'TF'
				,N'FS'
				,N'FT'
				)
		)
	DROP FUNCTION [dbo].[smsf_GetUpcomingAppointments]
GO

/****** Object:  UserDefinedFunction [dbo].[smsf_GetUpcomingAppointments]    Script Date: 09/30/2016 18:04:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[smsf_GetUpcomingAppointments] (@ClientId INT)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @JsonResult VARCHAR(MAX)

	SELECT @JsonResult = dbo.smsf_FlattenedJSON((
				SELECT DISTINCT TOP 5 A.starttime
					,CONVERT(VARCHAR(10), A.starttime, 101) AS AppointmentDate
					,CONVERT(VARCHAR(15), CAST(A.StartTime AS TIME), 100) AS AppointmentTime
					,GC.CodeName AS ProcedureName
					,REPLACE(L.locationname, '''', '&quot;') AS Location
					,S.lastname + ', ' + S.firstname AS Provider
				FROM appointments A
				INNER JOIN staff S ON S.staffid = A.staffid
				LEFT JOIN Services serv ON serv.ServiceId = A.ServiceId
				INNER JOIN GlobalCodes GC ON GC.GlobalCodeId = A.AppointmentType
				INNER JOIN locations L ON L.locationid = A.locationid
				WHERE serv.ClientId = @ClientId
					AND ISNULL(A.RecordDeleted, 'N') = 'N'
					AND ISNULL(serv.RecordDeleted, 'N') = 'N'
					AND A.starttime >= GetDate()
				ORDER BY A.starttime
				FOR XML path
					,root
				))

	RETURN REPLACE(@JsonResult, '"', '''')
END
GO


