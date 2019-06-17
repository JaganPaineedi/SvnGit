IF EXISTS (
            SELECT *
            FROM sys.objects
            WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWDClientCalendarEvents]')
                  AND type IN (
                        N'P'
                        ,N'PC'
                        )
            )
      DROP PROCEDURE [dbo].[ssp_SCWDClientCalendarEvents]
GO
 
SET ANSI_NULLS ON
GO
 
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [dbo].[ssp_SCWDClientCalendarEvents]

    @ViewType VARCHAR(15), --('MULTISTAFF', 'SINGLESTAFF','SELECTED')  
    @StartDate DATETIME ,
    @EndDate DATETIME ,
    @ResourceList VARCHAR(MAX) ,
    @LoggedInStaffId INT ,
    @Page INT ,
    @ResourcesPerPage INT
    
/*******************************************************************************
** Author:  Wasif Butt
** Create date: Feb 06, 2014      
** Description: Pulls client appointments for the client scheduler 
**
** Modified Date	Modified By		Modification      
** 08/05/2015		njain			Added ClientId condition in the where clause in the ProgramAppointments union
** 11/04/2015		Vamsi			What: Added new condition to show GroupNote and external appointments and also added new column UsesAttendanceFunctions 
**									to show Group services with attendence  
**									Why: Woods - Custom Reports# 896
** 11/18/2015		Vamsi			What: Added Order By Condition because client calender is not showing properly.
**									Why: Woods - Custom Reports# 896
** 04/25/2016		Dhanil			What: changed 0 as SpecificLocation  to '' as SpecificLocation because of error
**									Why: Key Point - Support Go Live #186
** 05/24/2017	    jcarlson		Key Point SGL 913
**									Display the Clinican Name and Phone Number, Display the Activity Type and Activity Summary for external appointments
** 05/31/2017		jcarlson		Key Point SGL 913 - Build the subject in stored proc instead of code behind
** 06/28/2017		jcarlson		Key Point SGL 913 - Added in logic to handle more staff phones
*******************************************************************************/
AS
    BEGIN      

        DECLARE @MagicNumberLow INT ,
            @MagicNumberHigh INT
        SET @MagicNumberLow = ( ( @Page - 1 ) * @ResourcesPerPage ) + 1  
        SET @MagicNumberHigh = @MagicNumberLow + @ResourcesPerPage - 1

        CREATE TABLE #ClientIds
            (
              ClientId INT NOT NULL ,
              SortOrder INT NOT NULL
            )      
			
        CREATE TABLE #ClientIdsForPage
            (
              ClientId INT NOT NULL ,
              SortOrder INT NOT NULL
            )

        IF @ViewType = 'MULTISTAFF'
            OR @ViewType = 'SELECTED'
            OR @ViewType = 'SINGLESTAFF'
            BEGIN       
                INSERT  INTO #ClientIdsForPage
                        ( ClientId ,
                          SortOrder                                      
                        )
                        SELECT  ids ,
                                ROW_NUMBER() OVER ( ORDER BY c.lastName, c.firstName, a.ids ASC )
                        FROM    dbo.SplitIntegerString(@ResourceList, ',') a
                                JOIN clients c ON ( a.ids = c.ClientId )      
            END       
        ELSE
            BEGIN       
                INSERT  INTO #ClientIdsForPage
                        ( ClientId, SortOrder )
                VALUES  ( -1, 1 )      
            END
				
        INSERT  INTO #ClientIds
                ( ClientId ,
                  SortOrder 
                )
                SELECT  ClientId ,
                        SortOrder
                FROM    #ClientIdsForPage
                WHERE   SortOrder BETWEEN @MagicNumberLow
                                  AND     @MagicNumberHigh
								  
								  
        CREATE TABLE #Appointments
            (
              AppointmentId INT NOT NULL ,
              ClientId INT NOT NULL ,
              ServiceId INT NULL
            )      

--Calendar or Primary Care appointments for Client
        INSERT  INTO #Appointments
                ( AppointmentId ,
                  ClientId
                )
                SELECT  AppointmentId ,
                        ClientId
                FROM    appointments AS a
                WHERE   ClientId IN ( SELECT    ClientId
                                      FROM      #ClientIds )
                        AND ( EndTime >= @StartDate
                              OR EndTime IS NULL
                            )
                        AND ( StartTime <= @EndDate )
                        AND a.ServiceId IS NULL
                        AND ISNULL(a.RecordDeleted, 'N') = 'N'

--Service Appointments for Client
        INSERT  INTO #Appointments
                ( AppointmentId ,
                  ClientId ,
                  ServiceId
                )
                SELECT  a.AppointmentId ,
                        s.ClientId ,
                        s.ServiceId
                FROM    appointments a
                        JOIN dbo.Services AS s ON a.ServiceId = s.ServiceId
                WHERE   s.ClientId IN ( SELECT  ClientId
                                        FROM    #ClientIds )
                        AND ( EndTime >= @StartDate
                              OR EndTime IS NULL
                            )
                        AND ( StartTime <= @EndDate )
                        AND ( a.ServiceId IS NULL
                              OR ( ISNULL(s.RecordDeleted, 'N') = 'N'
                                   AND s.status IN ( 70, 71, 72, 75 )
                                 )
                            )
                        AND ISNULL(a.Status, 0) NOT IN ( 8044, 8045 )
                        AND ISNULL(a.RecordDeleted, 'N') = 'N'

-- Added By  Vamsi on 11/04/2015 to show Group Service Appointments for Client  
INSERT INTO #Appointments (
	AppointmentId
	,ClientId
	,ServiceId
	)
SELECT a.AppointmentId
	,S.ClientId
	,S.ServiceId
FROM appointments a
 Join GroupServices AS GS ON a.GroupServiceId=GS.GroupServiceId  
 JOIN Services S ON S.GroupServiceId=GS.GroupServiceId  
 JOIN #ClientIds CI ON CI.ClientId=S.ClientId
WHERE 
--S.ClientId IN (  
--   SELECT ClientId  
--   FROM #ClientIds  
--   )  
--  AND
   (  
   EndTime >= @StartDate  
   OR EndTime IS NULL  
   )  
  AND (a.StartTime <= @EndDate)  
  AND (  
   a.ServiceId IS NULL  
   OR (  
    isnull(S.RecordDeleted, 'N') = 'N'  
    AND S.STATUS IN (  
     70  
     ,71  
     ,72  
     ,75  
     )  
    )  
   )  
  AND isnull(a.STATUS, 0) NOT IN (  
   8044  
   ,8045  
   )  
  AND isnull(a.RecordDeleted, 'N') = 'N' 
-- End Here
		

								  
        SELECT  ap.AppointmentId ,
                a.staffid ,
                ISNULL(st.LastName, '') + ', ' + ISNULL(st.FirstName, '') AS StaffName ,
                ap.ClientId ,
                p.DisplayAs + CASE WHEN a.GroupServiceId IS NOT NULL 
									THEN CASE WHEN ISNULL(G.UsesAttendanceFunctions,'N') = 'Y' THEN ' (Group Service - Attendance) '
										 ELSE ' (Group Service) '
										 END 
										 ELSE ' (Service) ' END + CHAR(13)+CHAR(10) + 'Clinician: ' + st.DisplayAs  + CHAR(13)+CHAR(10) + 'Clinican Phone: ' + ISNULL(st.PhoneNumber,ISNULL(st.OfficePhone1,ISNULL(st.OfficePhone2,'')))  AS Subject ,
                a.StartTime ,
                a.endtime ,
                a.AppointmentType ,
                ISNULL(gst.CodeName, '') AS AppointmentTypeCodeName ,
                ISNULL(gst.Description, '') AS AppointmentTypeDescription ,
                CASE WHEN LEN(ISNULL(gat.color, '')) = 6 THEN 'ff' + ISNULL(gat.color, '')
                     ELSE ISNULL(gat.color, '')
                END AS AppointmentTypeColor ,
                a.Description ,
                a.ShowTimeAs ,
                ISNULL(gst.CodeName, '') AS ShowTimeAsCodeName ,
                ISNULL(gst.Description, '') AS ShowTimeAsDescription ,
                ISNULL(gst.color, '') AS ShowTimeAsColor ,
                a.locationid ,
                ap.ServiceId ,
                ISNULL(l.LocationCode, '') AS LocationCode ,
                ISNULL(l.LocationName, '') AS LocationName ,
                ISNULL(a.RecurringAppointment, 'N') AS RecurringAppointment ,
                ISNULL(a.RecurringAppointmentId, 0) AS RecurringAppointmentId ,
                1 AS READONLY ,
                0 AS DocumentId ,
                0 AS GroupId ,
                ISNULL(a.GroupServiceId, 0) AS GroupServiceId ,
                ISNULL(a.RecurringGroupServiceId, 0) AS RecurringGroupServiceId ,
                a.Status ,
                a.SpecificLocation ,
                ISNULL(p.Notoncalendar, 'N') AS NotonCalendar ,
                0 AS resource ,
                '' AS DataFrom,
                G.UsesAttendanceFunctions
        FROM    #Appointments ap
                JOIN appointments a ON ( ap.AppointmentId = a.AppointmentId )
                JOIN dbo.Staff AS st ON ( a.StaffId = st.StaffId )
                LEFT JOIN globalcodes gst ON ( a.ShowTimeAs = gst.GlobalCodeId
                                               AND gst.Category = 'SHOWTIMEAS'
                                             )
                LEFT JOIN globalcodes gat ON ( a.AppointmentType = gat.GlobalCodeId
                                               AND ( gat.Category = 'APPOINTMENTTYPE'
                                                     OR gat.Category = 'PCAPPOINTMENTTYPE'
                                                   )
                                             )
                LEFT JOIN dbo.Locations l ON ( l.LocationId = a.LocationId )
                LEFT JOIN dbo.Services AS s ON ap.ServiceId = s.ServiceId
                LEFT JOIN dbo.procedurecodes p ON p.Procedurecodeid = s.procedurecodeid
                   Left join  groupservices gs On gs. GroupServiceId=a.GroupServiceId           
                Left Join Groups G on G.GroupId=gs.GroupId 
                
        UNION ALL 
--In case the group service has not been created for program appointments yet based on program appointment group scheduling job
        SELECT  pa.ProgramAppointmentId ,
                st.StaffId ,
                ISNULL(st.LastName, '') + ', ' + ISNULL(st.FirstName, '') AS StaffName ,
                pa.ClientId ,
                pc.DisplayAs  + CHAR(13)+CHAR(10) + 'Clinician: ' + st.DisplayAs  + CHAR(13)+CHAR(10) + 'Clinican Phone: ' + ISNULL(st.PhoneNumber,ISNULL(st.OfficePhone1,ISNULL(st.OfficePhone2,''))) AS Subject ,
                CONVERT(VARCHAR(10), pa.appointmentdate, 101) + ' ' + LTRIM(SUBSTRING(RTRIM(RIGHT(CONVERT(VARCHAR(26), g.starttime, 100), 7)), 0, 6) + ' ' + RIGHT(CONVERT(VARCHAR(26), g.StartTime, 109), 2)) AS StartTime ,
                DATEADD(minute, g.Unit, ( CONVERT(VARCHAR(10), pa.appointmentdate, 101) + ' ' + LTRIM(SUBSTRING(RTRIM(RIGHT(CONVERT(VARCHAR(26), g.starttime, 100), 7)), 0, 6) + ' ' + RIGHT(CONVERT(VARCHAR(26), g.StartTime, 109), 2)) )) AS EndTime ,
                4763 AS AppointmentType ,
                ISNULL(gst.CodeName, '') AS AppointmentTypeCodeName ,
                ISNULL(gst.Description, '') AS AppointmentTypeDescription ,
                CASE WHEN LEN(ISNULL(gat.color, '')) = 6 THEN 'ff' + ISNULL(gat.color, '')
                     ELSE ISNULL(gat.color, '')
                END AS AppointmentTypeColor ,
                pc.DisplayAs AS Description ,
                ISNULL(gst.GlobalCodeId, '') AS ShowTimeAs ,
                ISNULL(gst.CodeName, '') AS ShowTimeAsCodeName ,
                ISNULL(gst.Description, '') AS ShowTimeAsDescription ,
                ISNULL(gst.color, '') AS ShowTimeAsColor ,
                g.locationid ,
                NULL ,
                ISNULL(l.LocationCode, '') AS LocationCode ,
                ISNULL(l.LocationName, '') AS LocationName ,
                'N' AS RecurringAppointment ,
                0 AS RecurringAppointmentId ,
                1 AS READONLY ,
                0 AS DocumentId ,
                0 AS GroupId ,
                0 AS GroupServiceId ,
                0 AS RecurringGroupServiceId ,
                8036 ,
                '' ,
                'N' AS NotonCalendar ,
                0 AS resource ,
                '' AS DataFrom,
                '' AS UsesAttendanceFunctions 
        FROM    dbo.ProgramAppointments AS pa
                JOIN dbo.Groups AS g ON pa.ProgramId = g.ProgramId
                JOIN dbo.Programs AS p ON g.ProgramId = p.ProgramId
                                          AND ISNULL(p.AfterSchoolProgram, 'N') = 'Y'
                JOIN dbo.ProcedureCodes AS pc ON g.ProcedureCodeId = pc.ProcedureCodeId
                JOIN dbo.GroupNoteDocumentCodes AS gndc ON g.GroupNoteDocumentCodeId = gndc.GroupNoteDocumentCodeId
                JOIN dbo.Staff AS st ON g.ClinicianId = st.StaffId
                LEFT JOIN globalcodes gst ON ( 4342 = gst.GlobalCodeId
                                               AND gst.Category = 'SHOWTIMEAS'
                                             )
                LEFT JOIN globalcodes gat ON ( 4763 = gat.GlobalCodeId
                                               AND ( gat.Category = 'APPOINTMENTTYPE'
                                                     OR gat.Category = 'PCAPPOINTMENTTYPE'
                                                   )
                                             )
                LEFT JOIN dbo.Locations l ON ( l.LocationId = g.LocationId )
        WHERE   ISNULL(g.RecordDeleted, 'N') = 'N'
                AND ISNULL(pa.RecordDeleted, 'N') = 'N'
                AND ISNULL(p.RecordDeleted, 'N') = 'N'
                AND ISNULL(pc.RecordDeleted, 'N') = 'N'
                AND ISNULL(gndc.RecordDeleted, 'N') = 'N'
                AND ISNULL(st.RecordDeleted, 'N') = 'N'
                AND pa.ClientId IN ( SELECT ClientId
                                     FROM   #ClientIds )
                AND NOT EXISTS ( SELECT *
                                 FROM   dbo.Services AS s
                                 WHERE  s.ClientId = pa.ClientId
                                        AND s.ProcedureCodeId = pc.ProcedureCodeId
                                        AND CONVERT(VARCHAR(10), pa.AppointmentDate, 101) = CONVERT(VARCHAR(10), DateOfService, 101) )

 -- Added By  Vamsi on 11/04/2015 to show external appointments
        Union All
       
        SELECT  -1 as AppointmentId ,  
                '' as staffid ,  
                '' AS StaffName ,  
                a.ClientId ,  
                'External Appointment' + CHAR(13)+CHAR(10) + 'Activity Type: ' + ISNULL(gca.CodeName,'') + CHAR(13)+CHAR(10) + 'Activity Summary: ' + ISNULL(a.ActivitySummary,'')  AS Subject ,  
                a.ActivityStartTime as StartTime,  
                a.ActivityEndTime as endtime ,  
                '' as AppointmentType ,  
                '' AS AppointmentTypeCodeName ,  
                '' AS AppointmentTypeDescription ,  
                '' AS AppointmentTypeColor ,  
                '' as Description ,  
               ISNULL(gst.GlobalCodeId, '') AS ShowTimeAs ,
                ISNULL(gst.CodeName, '') AS ShowTimeAsCodeName ,
                ISNULL(gst.Description, '') AS ShowTimeAsDescription ,
                ISNULL(gst.color, '') AS ShowTimeAsColor ,
                '' as locationid ,  
                NULL as ServiceId ,  
                '' AS LocationCode ,  
                '' AS LocationName ,  
                'N' AS RecurringAppointment ,  
                0 AS RecurringAppointmentId ,  
                1 AS READONLY ,  
                0 AS DocumentId ,  
                0 AS GroupId ,  
                0 AS GroupServiceId ,  
                0 AS RecurringGroupServiceId ,  
                Null as Status , 
                --Dhanil 04/25/2016
                '' as SpecificLocation ,  
                'N' AS NotonCalendar ,  
                0 AS resource ,  
                '' AS DataFrom  ,
                '' as UsesAttendanceFunctions
            FROM clientActivities a
	JOIN #ClientIds CI ON CI.Clientid=a.Clientid 
	LEFT JOIN globalcodes gst ON ( 4342 = gst.GlobalCodeId
                                               AND gst.Category = 'SHOWTIMEAS')
			JOIN GlobalCodes AS gca ON a.ActivityType = gca.GlobalCodeId
                                         
	WHERE 		(	a.ActivityEndTime >= @StartDate
			OR a.ActivityEndTime IS NULL)
			
		AND (a.ActivityStartTime <= @EndDate)	
		AND isnull(a.RecordDeleted, 'N') = 'N'
		-- Added By  Vamsi on 11/18/2015 to show orderby starttime
	order by  StartTime
		
-- End here		
               
        SELECT  c.ClientId ResourceId ,
                ISNULL(cl.LastName, '') + ', ' + ISNULL(cl.FirstName, '') ResourceName ,
                0 AS CanSchedule
        FROM    #ClientIds c
                JOIN clients cl ON cl.ClientId = c.ClientId
    END 
          
IF (@@error != 0)
BEGIN
      RAISERROR ('ssp_SCWDClientCalendarEvents: An Error Occured While fetching data ',16,1);
END

GO
