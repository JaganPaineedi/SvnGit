/****** Object:  StoredProcedure [dbo].[smsp_SCWDCalendarEvents]    Script Date: 05/20/2016 12:35:32 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[smsp_SCWDCalendarEvents]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[smsp_SCWDCalendarEvents]
GO

/****** Object:  StoredProcedure [dbo].[smsp_SCWDCalendarEvents]    Script Date: 05/20/2016 12:35:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[smsp_SCWDCalendarEvents] @ViewType VARCHAR(15)
	,@StartDate DATETIME
	,@EndDate DATETIME
	,@StaffList VARCHAR(max)
	,@LoggedInStaffId INT
	,@Page INT
	,@ResourcesPerPage INT
	,@JsonResult VARCHAR(MAX) OUTPUT
AS
BEGIN
	DECLARE @MagicNumberLow INT
		,@MagicNumberHigh INT

	SET @MagicNumberLow = ((@Page - 1) * @ResourcesPerPage) + 1
	SET @MagicNumberHigh = @MagicNumberLow + @ResourcesPerPage - 1

	CREATE TABLE #StaffIds (
		StaffId INT NOT NULL
		,SortOrder INT NOT NULL
		)

	CREATE TABLE #StaffIdsForPage (
		StaffId INT NOT NULL
		,SortOrder INT NOT NULL
		)

	CREATE TABLE #AppointmentList (
		AppointmentId INT
		,StaffId INT
		,Subject VARCHAR(250)
		,Start DATETIME
		,[End] DATETIME
		,AppointmentType INT
		,AppointmentTypeCodeName VARCHAR(250)
		,AppointmentTypeDescription TEXT
		,AppointmentTypeColor VARCHAR(10)
		,Description TEXT
		,ShowTimeAs INT
		,ShowTimeAsCodeName VARCHAR(250)
		,ShowTimeAsDescription TEXT
		,ShowTimeAsColor VARCHAR(10)
		,LocationId INT
		,ServiceId INT
		,LocationCode VARCHAR(30)
		,LocationName VARCHAR(100)
		,RecurringAppointment CHAR(1)
		,RecurringAppointmentId INT
		,ReadOnly INT
		,DocumentId INT
		,GroupId INT
		,GroupServiceId INT
		,RecurringGroupServiceId INT
		,STATUS INT
		,SpecificLocation VARCHAR(250)
		,NotonCalendar CHAR(1)
		,Resource VARCHAR(max) NULL
		,DataFrom VARCHAR(15) NULL
		)

	IF @ViewType = 'MULTISTAFF'
	BEGIN
		INSERT INTO #StaffIdsForPage (
			StaffId
			,SortOrder
			)
		SELECT a.staffid
			,row_number() OVER (
				ORDER BY s.lastName
					,s.firstName
					,a.StaffId ASC
				)
		FROM dbo.MultiStaffViewStaff a
		INNER JOIN staff s ON (a.StaffId = s.StaffId)
		WHERE MultiStaffViewId IN (
				SELECT ids
				FROM dbo.SplitIntegerString(@StaffList, ',')
				)
			AND isnull(a.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(s.RecordDeleted, 'N') = 'N'
	END
	ELSE IF @ViewType = 'SELECTED'
		OR @ViewType = 'SINGLESTAFF'
	BEGIN
		INSERT INTO #StaffIdsForPage (
			StaffId
			,SortOrder
			)
		SELECT ids
			,row_number() OVER (
				ORDER BY s.lastName
					,s.firstName
					,a.ids ASC
				)
		FROM dbo.SplitIntegerString(@StaffList, ',') a
		INNER JOIN staff s ON (a.ids = s.StaffId)
	END
	ELSE
	BEGIN
		INSERT INTO #StaffIdsForPage (
			StaffId
			,SortOrder
			)
		VALUES (
			- 1
			,1
			)
	END

	INSERT INTO #StaffIds (
		StaffId
		,SortOrder
		)
	SELECT StaffId
		,SortOrder
	FROM #StaffIdsForPage
	WHERE SortOrder BETWEEN @MagicNumberLow
			AND @MagicNumberHigh;

	WITH AppointmentList (
		AppointmentId
		,StaffId
		,Subject
		,Start
		,[End]
		,AppointmentType
		,AppointmentTypeCodeName
		,AppointmentTypeDescription
		,AppointmentTypeColor
		,Description
		,ShowTimeAs
		,ShowTimeAsCodeName
		,ShowTimeAsDescription
		,ShowTimeAsColor
		,LocationId
		,ServiceId
		,LocationCode
		,LocationName
		,RecurringAppointment
		,RecurringAppointmentId
		,ReadOnly
		,DocumentId
		,GroupId
		,GroupServiceId
		,RecurringGroupServiceId
		,STATUS
		,ClientId
		,Comments
		,SpecificLocation
		,NotonCalendar
		)
	AS (
		SELECT a.AppointmentId
			,a.staffid
			,a.Subject
			,a.StartTime
			,a.endtime
			,a.AppointmentType
			,isnull(c.CodeName, '') AS AppointmentTypeCodeName
			,isnull(c.Description, '') AS AppointmentTypeDescription
			,CASE 
				WHEN len(isnull(c.color, '')) = 6
					THEN 'ff' + isnull(c.color, '')
				ELSE isnull(c.color, '')
				END AS AppointmentTypeColor
			,a.Description
			,a.ShowTimeAs
			,isnull(b.CodeName, '') AS ShowTimeAsCodeName
			,isnull(b.Description, '') AS ShowTimeAsDescription
			,isnull(b.color, '') AS ShowTimeAsColor
			,a.locationid
			,a.ServiceId
			,isnull(d.LocationCode, '') AS LocationCode
			,isnull(d.LocationName, '') AS LocationName
			,isnull(a.RecurringAppointment, 'N') AS RecurringAppointment
			,isnull(a.RecurringAppointmentId, 0) AS RecurringAppointmentId
			,CASE 
				WHEN isnull(serv.ServiceId, - 1) = - 1
					THEN 0
				ELSE CASE 
						WHEN isnull(sc.ClientId, - 1) <> - 1
							THEN 0
						ELSE 1
						END
				END AS READONLY
			,isnull(doc.DocumentId, 0)
			,isnull(gs.GroupId, 0) AS GroupId
			,isnull(a.GroupServiceId, 0) AS GroupServiceId
			,isnull(a.RecurringGroupServiceId, 0) AS RecurringGroupServiceId
			,a.STATUS
			,a.ClientId
			,a.Description
			,a.SpecificLocation
			,isnull(p.Notoncalendar, 'N') AS NotonCalendar
		FROM #StaffIds s
		INNER JOIN appointments a ON (s.StaffId = a.StaffId)
		LEFT JOIN globalcodes b ON (
				a.ShowTimeAs = b.GlobalCodeId
				AND b.Category = 'SHOWTIMEAS'
				)
		LEFT JOIN globalcodes c ON (
				a.AppointmentType = c.GlobalCodeId
				AND (
					c.Category = 'APPOINTMENTTYPE'
					OR c.Category = 'PCAPPOINTMENTTYPE'
					)
				)
		LEFT JOIN dbo.Locations d ON (a.LocationId = d.LocationId)
		LEFT JOIN dbo.Services serv ON (
				a.ServiceId = serv.ServiceId
				AND isnull(serv.RecordDeleted, 'N') = 'N'
				AND serv.STATUS IN (
					70
					,71
					,72
					,75
					)
				)
		LEFT JOIN dbo.Documents doc ON (serv.ServiceId = doc.ServiceId)
		LEFT JOIN dbo.StaffClients sc ON (
				sc.StaffId = @LoggedInStaffId
				AND serv.ClientId = sc.ClientId
				)
		LEFT JOIN dbo.procedurecodes p ON p.Procedurecodeid = serv.procedurecodeid
		LEFT JOIN dbo.GroupServices gs ON (a.GroupServiceId = gs.GroupServiceId)
		WHERE (
				EndTime >= @StartDate
				OR EndTime IS NULL
				)
			AND (StartTime <= @EndDate)
			AND (
				a.ServiceId IS NULL
				OR (
					isnull(serv.RecordDeleted, 'N') = 'N'
					AND serv.STATUS IN (
						70
						,71
						,72
						,75
						)
					)
				)
			AND (
				gs.GroupServiceId IS NULL
				OR (
					isnull(gs.RecordDeleted, 'N') = 'N'
					AND gs.STATUS IN (
						70
						,71
						,72
						,75
						)
					)
				)
			AND isnull(a.STATUS, 0) NOT IN (
				8042
				,8044
				,8045
				)
			AND isnull(a.RecordDeleted, 'N') <> 'Y'
		)
	INSERT INTO #AppointmentList
	SELECT al.AppointmentId
		,al.StaffId
		,CASE 
			WHEN al.ReadOnly = 1
				THEN isnull(al.Subject, '')
			WHEN isnull(al.GroupServiceId, 0) <> 0
				THEN 'Group Service: ' + cast(g.GroupName AS VARCHAR(100)) + ' (#' + cast(al.GroupServiceId AS VARCHAR(100)) + ')'
			WHEN isnull(al.RecurringGroupServiceId, 0) <> 0
				THEN CASE 
						WHEN isnull(al.GroupServiceId, 0) = 0
							THEN 'Group Service Exists'
						END
			ELSE isnull(al.Subject, '')
			END AS Subject
		,al.Start
		,al.[End]
		,al.AppointmentType
		,al.AppointmentTypeCodeName
		,al.AppointmentTypeDescription
		,al.AppointmentTypeColor
		,al.Description
		,al.ShowTimeAs
		,al.ShowTimeAsCodeName
		,al.ShowTimeAsDescription
		,al.ShowTimeAsColor
		,al.LocationId
		,al.ServiceId
		,al.LocationCode
		,al.LocationName
		,al.RecurringAppointment
		,al.RecurringAppointmentId
		,CASE 
			WHEN isnull(al.RecurringGroupServiceId, 0) <> 0
				THEN CASE 
						WHEN isnull(al.GroupServiceId, 0) = 0
							THEN 1
						END
			ELSE al.ReadOnly
			END AS ReadOnly
		,al.DocumentId
		,al.GroupId
		,al.GroupServiceId
		,al.RecurringGroupServiceId
		,al.STATUS
		,al.SpecificLocation
		,NotonCalendar
		,'' AS Resource
		,'' AS DataFrom
	FROM AppointmentList al
	LEFT JOIN dbo.Groups g ON al.GroupId = g.GroupId
	WHERE (
			(
				al.RecurringAppointment = 'Y'
				AND al.RecurringAppointmentId > 0
				)
			OR al.RecurringAppointment = 'N'
			)
	ORDER BY al.Start
		,al.[End]
		,al.AppointmentId;

	INSERT INTO #AppointmentList
	SELECT AM.AppointmentMasterId AS AppointmentId
		,AMS.StaffId
		,isnull(AM.Subject, '') AS Subject
		,AM.StartTime AS Start
		,AM.EndTime AS [End]
		,AM.AppointmentType AS AppointmentType
		,isnull(c.CodeName, '') AS AppointmentTypeCodeName
		,isnull(c.Description, '') AS AppointmentTypeDescription
		,isnull(c.color, '') AS AppointmentTypeColor
		,AM.Description AS Description
		,AM.ShowTimeAs AS ShowTimeAs
		,isnull(b.CodeName, '') AS ShowTimeAsCodeName
		,isnull(b.Description, '') AS ShowTimeAsDescription
		,isnull(b.color, '') AS ShowTimeAsColor
		,'' AS LocationId
		,NULL AS ServiceId
		,'' AS LocationCode
		,'' AS LocationName
		,'N' AS RecurringAppointment
		,0 AS RecurringAppointmentId
		,0 AS ReadOnly
		,'' AS DocumentId
		,0 AS GroupId
		,0 AS GroupServiceId
		,0 AS RecurringGroupServiceId
		,NULL AS STATUS
		,'' AS SpecificLocation
		,'N' AS NotonCalendar
		,'' AS Resource
		,'ResourceEvents' AS DataFrom
	FROM AppointmentMasterStaff AMS
	INNER JOIN AppointmentMaster AM ON (AMS.AppointmentMasterId = AM.AppointmentMasterId)
	LEFT JOIN globalcodes b ON (
			AM.ShowTimeAs = b.GlobalCodeId
			AND b.Category = 'SHOWTIMEAS'
			)
	LEFT JOIN globalcodes c ON (
			AM.AppointmentType = c.GlobalCodeId
			AND c.Category = 'APPOINTMENTTYPE'
			)
	WHERE (
			EndTime >= @StartDate
			OR EndTime IS NULL
			)
		AND (StartTime <= @EndDate)
		AND (AM.ServiceId IS NULL)
		AND isnull(AM.RecordDeleted, 'N') <> 'Y'
	ORDER BY AM.StartTime
		,AM.EndTime
		,AM.AppointmentMasterId

	-- Update Resources where ServiceId is null                 
	UPDATE AP
	SET AP.Resource = ltrim(ResourceWithService.DisplayAs)
	FROM #AppointmentList AP
	LEFT JOIN (
		SELECT AppointmentResourceList.AppointmentMasterId
			,CASE 
				WHEN AppointmentResourceList.DisplayAs IS NOT NULL
					THEN '(' + AppointmentResourceList.DisplayAs + ')'
				ELSE AppointmentResourceList.DisplayAs
				END DisplayAs
		FROM (
			SELECT AM.AppointmentMasterId
				,replace(replace(stuff((
								SELECT DISTINCT ', ' + RES.DisplayAs
								FROM AppointmentMasterResources AMR
								INNER JOIN Resources RES ON RES.ResourceId = AMR.ResourceId
								WHERE AM.AppointmentMasterId = AMR.AppointmentMasterId
									AND isnull(AMR.RecordDeleted, 'N') <> 'Y'
									AND isnull(RES.RecordDeleted, 'N') <> 'Y'
								FOR XML path('')
								), 1, 1, ''), '&lt;', '<'), '&gt;', '>') 'DisplayAs'
			FROM #AppointmentList RS
			INNER JOIN AppointmentMaster AM ON RS.AppointmentId = AM.AppointmentMasterId
				AND RS.DataFrom = 'ResourceEvents'
			WHERE isnull(AM.RecordDeleted, 'N') <> 'Y'
			) AppointmentResourceList
		) ResourceWithService ON (
			AP.AppointmentId = ResourceWithService.AppointmentMasterId
			AND AP.DataFrom = 'ResourceEvents'
			)

	-- Update Resources where ServiceId is available                 
	UPDATE AP
	SET AP.Resource = ltrim(ResourceWithService.DisplayAs)
	FROM #AppointmentList AP
	LEFT JOIN (
		SELECT AppointmentResourceList.ServiceId
			,CASE 
				WHEN AppointmentResourceList.DisplayAs IS NOT NULL
					THEN '(' + AppointmentResourceList.DisplayAs + ')'
				ELSE AppointmentResourceList.DisplayAs
				END DisplayAs
		FROM (
			SELECT AM.AppointmentMasterId
				,AM.ServiceId
				,replace(replace(stuff((
								SELECT DISTINCT ', ' + RES.DisplayAs
								FROM AppointmentMasterResources AMR
								INNER JOIN Resources RES ON RES.ResourceId = AMR.ResourceId
								WHERE AM.AppointmentMasterId = AMR.AppointmentMasterId
									AND isnull(AMR.RecordDeleted, 'N') <> 'Y'
									AND isnull(RES.RecordDeleted, 'N') <> 'Y'
								FOR XML path('')
								), 1, 1, ''), '&lt;', '<'), '&gt;', '>') 'DisplayAs'
			FROM #AppointmentList RS
			INNER JOIN AppointmentMaster AM ON RS.ServiceId = AM.ServiceId
			WHERE isnull(AM.RecordDeleted, 'N') <> 'Y'
			) AppointmentResourceList
		) ResourceWithService ON AP.ServiceId = ResourceWithService.ServiceId
	WHERE AP.DataFrom <> 'ResourceEvents'

	SELECT @JsonResult = dbo.smsf_FlattenedJSON((
				SELECT appointmentId
					,staffId
					,subject
					,start
					,[end]
					,appointmentType
					,appointmentTypeCodeName
					,appointmentTypeDescription
					,appointmentTypeColor
					,description
					,showTimeAs
					,showTimeAsCodeName
					,showTimeAsDescription
					,showTimeAsColor AS backgroundColor
					,locationId
					,serviceId
					,locationCode
					,locationName
					,recurringAppointment
					,recurringAppointmentId
					,readOnly
					,documentId
					,groupId
					,groupServiceId
					,recurringGroupServiceId
					,STATUS
					,specificLocation
					,notonCalendar
					,resource
					,dataFrom
					,'#333333' AS borderColor
					,CASE DATEDIFF(HH, Start, [End])
						WHEN 24
							THEN 'true'
						ELSE 'false'
						END AS allDay
				FROM #AppointmentList
				ORDER BY Start
					,ShowTimeAs
				FOR XML path
					,root
				))
END
GO


