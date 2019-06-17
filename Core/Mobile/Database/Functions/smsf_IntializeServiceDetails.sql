/****** Object:  UserDefinedFunction [dbo].[smsf_IntializeServiceDetails]    Script Date: 11/22/2016 12:46:33 PM ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[smsf_IntializeServiceDetails]')
			AND type IN (
				N'FN'
				,N'IF'
				,N'TF'
				,N'FS'
				,N'FT'
				)
		)
	DROP FUNCTION [dbo].[smsf_IntializeServiceDetails]
GO

/****** Object:  UserDefinedFunction [dbo].[smsf_IntializeServiceDetails]    Script Date: 11/22/2016 12:46:33 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[smsf_IntializeServiceDetails] (
	@StaffId INT
	,@ProgramId INT
	)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @JsonResult VARCHAR(MAX)
	DECLARE @StartDate DATETIME
	DECLARE @EndDate DATETIME

	SELECT @StartDate = DATEADD(dd, - MobileCalendarEventsDaysLookUpInPast - DATEPART(DW, GETDATE()), GETDATE())
		,@EndDate = DATEADD(dd, MobileCalendarEventsDaysLookUpInFuture - DATEPART(DW, GETDATE()), GETDATE())
	FROM StaffPreferences SP
	WHERE SP.StaffId = @StaffId
		AND ISNULL(RecordDeleted, 'N') = 'N'

	DECLARE @TempServiceDetails TABLE (
		StaffId INT
		,ClientId INT
		,ServiceId INT
		,AppointmentId INT
		,DocumentId INT
		,LastName VARCHAR(100)
		,FirstName VARCHAR(100)
		,ProcedureCodeName VARCHAR(500)
		,DateOfService DATETIME
		,Duration VARCHAR(50)
		,STATUS VARCHAR(50)
		,Comment NVARCHAR(MAX)
		,ClientName VARCHAR(100)
		,GroupCode VARCHAR(50)
		,GroupId INT
		)

	INSERT INTO @TempServiceDetails
	SELECT SV.ClinicianId
		,C.ClientId
		,SV.ServiceId
		,A.AppointmentId
		,Doc.DocumentId
		,C.LastName
		,c.FirstName
		,PC.DisplayAs
		,sv.DateOfService
		,(CAST(CAST(Sv.Unit AS INT) AS VARCHAR) + ' ' + ISNULL(Gc.CodeName, '')) AS Duration
		,sv.STATUS
		,sv.Comment
		,CASE 
			WHEN ISNULL(C.ClientType, 'I') = 'I'
				THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')
			ELSE ISNULL(C.OrganizationName, '')
			END
		,G.GroupCode
		,G.GroupId
	FROM Services SV
	INNER JOIN Appointments A ON A.ServiceId = SV.ServiceId
	INNER JOIN Clients C ON C.ClientId = SV.ClientId
	INNER JOIN ClientPrograms CP ON CP.ClientId = SV.ClientId
	LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = SV.UnitType
		AND ISNULL(GC.RecordDeleted, 'N') = 'N'
	LEFT JOIN ProcedureCodes PC ON PC.ProcedureCodeId = SV.ProcedureCodeId
		AND ISNULL(PC.RecordDeleted, 'N') = 'N'
	LEFT JOIN Documents Doc ON Doc.ServiceId = SV.ServiceId
		AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
	LEFT JOIN GroupServices GS ON GS.GroupServiceId = SV.GroupServiceId
		AND ISNULL(GS.RecordDeleted, 'N') = 'N'
	LEFT JOIN Groups G ON G.GroupId = GS.GroupId
		AND ISNULL(G.RecordDeleted, 'N') = 'N'
		AND G.Active = 'Y'
	WHERE SV.ClinicianId = @StaffId
		AND SV.ProgramId = @ProgramId
		AND SV.DateOfService >= @StartDate
		AND SV.DateOfService < @EndDate
		AND SV.STATUS IN (
			70
			,71
			,75
			) -- here 70=Scheduled, 71=Show and 75=Complete 	
		AND ISNULL(SV.RecordDeleted, 'N') = 'N'
		AND ISNULL(C.RecordDeleted, 'N') = 'N'
		AND C.Active = 'Y'
		AND CP.ProgramId = @ProgramId
		AND (
			(
				CP.STATUS = 1
				AND (
					CP.RequestedDate IS NULL
					OR CP.RequestedDate < @EndDate
					)
				)
			OR (
				Cp.STATUS = 4
				AND (
					CP.EnrolledDate IS NULL
					OR CP.EnrolledDate < @EndDate
					)
				)
			OR (
				CP.STATUS = 5
				AND (
					(
						CP.RequestedDate IS NULL
						OR CP.RequestedDate < @EndDate
						)
					OR (
						CP.EnrolledDate IS NULL
						OR CP.EnrolledDate < @EndDate
						)
					)
				AND (
					CP.DischargedDate IS NULL
					OR CP.DischargedDate >= @StartDate
					)
				)
			)
		AND ISNULL(CP.RecordDeleted, 'N') = 'N'

	SELECT @JsonResult = dbo.smsf_FlattenedJSON((
				SELECT StaffId
					,ClientId
					,ServiceId
					,AppointmentId
					,DocumentId
					,LastName
					,FirstName
					,ProcedureCodeName
					,DateOfService
					,Duration
					,STATUS
					,Comment
					,ClientName
					,GroupCode
					,GroupId
				FROM @TempServiceDetails
				GROUP BY StaffId
					,ClientId
					,ServiceId
					,AppointmentId
					,DocumentId
					,LastName
					,FirstName
					,ProcedureCodeName
					,DateOfService
					,Duration
					,STATUS
					,Comment
					,ClientName
					,GroupCode
					,GroupId
				FOR XML path
					,root
				))

	RETURN REPLACE(@JsonResult, '"', '''')
END
GO


