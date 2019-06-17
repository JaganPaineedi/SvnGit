/****** Object:  StoredProcedure [dbo].[ssp_SCGetAttendanceAssignment]    Script Date: 01/08/2018 11:22:52 ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_SCGetAttendanceAssignment]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [dbo].[ssp_SCGetAttendanceAssignment]
GO


/****** Object:  StoredProcedure [dbo].[ssp_SCGetAttendanceAssignment]    Script Date: 01/08/2018 11:22:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetAttendanceAssignment]
    @StaffId INT ,
    @GroupId INT ,
    @ProgramId INT ,
    @Date DATETIME = NULL ,
    @PageNumber INT = 1 ,
    @UnsavedChange XML = NULL ,
    @Mode VARCHAR(10) = NULL ,
    @AttendanceAssignmentId INT = NULL
AS /****************************************************************************/
/* Stored Procedure: ssp_SCGetAttendanceAssignment                          */
/* Copyright: 2006 Streamline Healthcare Solutions                           */
/* Author: Akwinass                                                         */
/* Creation Date:  April 29,2015                                            */
/* Purpose: To Get Attendance Assignment Records                            */
/* Input Parameters:@StaffId,@GroupId,@ProgramId,@Date,@PageNumber,
@UnsavedChange,@Mode,@AttendanceAssignmentId                                */
/* Output Parameters:None                                                   */
/* Return:                                                                  */
/* Calls:                                                                   */
/* Called From: Attendance Assignment  Details Page                         */
/* Data Modifications:                                                       */
/*                                                                          */
/*-------------Modification History--------------------------               */
/*-------Date-----------Author------------Purpose---------------------------*/
/*       29-APRIL-2015  Akwinass          Created(Task #829 in Woods - Customizations).*/
/*       23-June-2015   Akwinass          Included Distinct Condition to Avoid Duplicates(Task #829.01 in Woods - Environment Issues Tracking).*/
/*       07-July-2015   Hemant            Added OverrideCharge,OverrideChargeAmount,ChargeAmountOverrideBy in services table Why:Charge Override on the Service Detail Screen #605.1 Network 180 - Customizations*/
/*       29-AUG-2015    Akwinass          Increased the Performance of the Page(Task #355 in Valley Client Acceptance Testing Issues).*/
/*       26-OCT-2015    Akwinass          Logic included to manage unsaved changes(Task #13 in Valley - Support Go Live).*/
/*       26-JULY-2016   Pabitra           Added condition to check the staff in StaffPrograms table (Task # 50 in Camino - Support Go Live ) */
/*		 01-Jan-2018	NJain				Updated @PageSize to 200 from 50. Boundless Support #67*/
/****************************************************************************/
    BEGIN
        BEGIN TRY		
            DECLARE @UserCode VARCHAR(30)
            SELECT TOP 1
                    @UserCode = UserCode
            FROM    Staff
            WHERE   ISNULL(RecordDeleted, 'N') = 'N'
                    AND ISNULL(Active, 'N') = 'Y'
            DECLARE @PageSize INT = 200
		
            IF @Mode = 'GetData'
                AND @Date IS NOT NULL
                BEGIN				
                    IF EXISTS ( SELECT  ServiceId
                                FROM    Services
                                WHERE   ServiceId = @AttendanceAssignmentId
                                        AND ISNULL(RecordDeleted, 'N') = 'N' )
                        BEGIN
                            IF OBJECT_ID('tempdb..#ServiceIds') IS NOT NULL
                                DROP TABLE #ServiceIds
					
                            CREATE TABLE #ServiceIds ( ServiceId INT )
				
                            IF @AttendanceAssignmentId > 0
                                AND NOT EXISTS ( SELECT ServiceId
                                                 FROM   #ServiceIds
                                                 WHERE  ServiceId = @AttendanceAssignmentId )
                                BEGIN
                                    INSERT  INTO #ServiceIds
                                            ( ServiceId )
                                    VALUES  ( @AttendanceAssignmentId )
                                END
				
                            SELECT  s.ServiceId AS AttendanceAssignmentId ,
                                    s.CreatedBy ,
                                    s.CreatedDate ,
                                    s.ModifiedBy ,
                                    s.ModifiedDate ,
                                    s.ClientId ,
                                    C.LastName + ', ' + C.FirstName AS ClientName ,
                                    g.GroupId ,
                                    G.GroupName ,
                                    s.ProgramId ,
                                    P.ProgramCode ,
                                    s.ClinicianId AS StaffId ,
                                    ST.LastName + ', ' + ST.FirstName AS StaffName ,
                                    'Y' AS IsSaved ,
                                    s.DateOfService AS AssignmentDate ,
                                    s.DateOfService AS StartDateTime ,
                                    s.EndDateOfService AS EndDateTime ,
                                    s.GroupServiceId ,
                                    g.GroupId AS CurrentGroupId
                            FROM    GroupServices gs
                                    JOIN Groups g ON g.GroupId = gs.GroupId
                                                     AND ISNULL(g.RecordDeleted, 'N') = 'N'
                                                     AND ISNULL(g.UsesAttendanceFunctions, 'N') = 'Y'
                                                     AND ISNULL(g.Active, 'N') = 'Y'
                                    JOIN Services s ON s.GroupServiceId = gs.GroupServiceId
                                                       AND ISNULL(s.RecordDeleted, 'N') = 'N'
				--JOIN StaffPrograms SP ON SP.ProgramId = S.ProgramId AND ISNULL(SP.RecordDeleted, 'N') = 'N'
                                    JOIN Programs p ON s.ProgramId = p.ProgramId
                                                       AND ISNULL(p.RecordDeleted, 'N') = 'N'
                                                       AND ISNULL(p.Active, 'N') = 'Y'
                                    JOIN ProcedureCodes ON ProcedureCodes.ProcedureCodeId = s.ProcedureCodeId
                                    JOIN Clients C ON s.ClientId = C.ClientId
                                                      AND ISNULL(C.RecordDeleted, 'N') = 'N'
                                                      AND ISNULL(C.Active, 'N') = 'Y'	
				--JOIN StaffClients sc ON C.ClientId = sc.ClientId AND sc.StaffId = @StaffId
                                    LEFT JOIN Staff ST ON s.ClinicianId = ST.StaffId
                                                          AND ISNULL(S.RecordDeleted, 'N') = 'N'
                                                          AND ISNULL(ST.Active, 'N') = 'Y'
                            WHERE   EXISTS ( SELECT 1
                                             FROM   #ServiceIds SI
                                             WHERE  SI.ServiceId = s.ServiceId )
                            ORDER BY ( CASE s.ServiceId
                                         WHEN @AttendanceAssignmentId THEN 0
                                         ELSE 1
                                       END ) ,
                                    ClientName ,
                                    ClientId ASC
				
                            SELECT TOP 0
                                    [ServiceId] ,
                                    [CreatedBy] ,
                                    [CreatedDate] ,
                                    [ModifiedBy] ,
                                    [ModifiedDate] ,
                                    [RecordDeleted] ,
                                    [DeletedDate] ,
                                    [DeletedBy] ,
                                    [ClientId] ,
                                    [GroupServiceId] ,
                                    [ProcedureCodeId] ,
                                    [DateOfService] ,
                                    [EndDateOfService] ,
                                    [RecurringService] ,
                                    [Unit] ,
                                    [UnitType] ,
                                    [Status] ,
                                    [CancelReason] ,
                                    [ProviderId] ,
                                    [ClinicianId] ,
                                    [AttendingId] ,
                                    [ProgramId] ,
                                    [LocationId] ,
                                    [Billable] ,
                                    [ClientWasPresent] ,
                                    [OtherPersonsPresent] ,
                                    [AuthorizationsApproved] ,
                                    [AuthorizationsNeeded] ,
                                    [AuthorizationsRequested] ,
                                    [Charge] ,
                                    [NumberOfTimeRescheduled] ,
                                    [NumberOfTimesCancelled] ,
                                    [ProcedureRateId] ,
                                    [DoNotComplete] ,
                                    [Comment] ,
                                    [Flag1] ,
                                    [OverrideError] ,
                                    [OverrideBy] ,
                                    [ReferringId] ,
                                    [DateTimeIn] ,
                                    [DateTimeOut] ,
                                    [NoteAuthorId] ,
                                    [ModifierId1] ,
                                    [ModifierId2] ,
                                    [ModifierId3] ,
                                    [ModifierId4] ,
                                    [PlaceOfServiceId] ,
                                    [SpecificLocation] ,
                                    [OverrideCharge] ,
                                    [OverrideChargeAmount] ,
                                    [ChargeAmountOverrideBy]
                            FROM    [Services]
                        END
                    ELSE
                        BEGIN
                            SELECT  0 AS AttendanceAssignmentId ,
                                    @UserCode AS CreatedBy ,
                                    GETDATE() AS CreatedDate ,
                                    @UserCode AS ModifiedBy ,
                                    GETDATE() AS ModifiedDate

                            SELECT TOP 0
                                    [ServiceId] ,
                                    [CreatedBy] ,
                                    [CreatedDate] ,
                                    [ModifiedBy] ,
                                    [ModifiedDate] ,
                                    [RecordDeleted] ,
                                    [DeletedDate] ,
                                    [DeletedBy] ,
                                    [ClientId] ,
                                    [GroupServiceId] ,
                                    [ProcedureCodeId] ,
                                    [DateOfService] ,
                                    [EndDateOfService] ,
                                    [RecurringService] ,
                                    [Unit] ,
                                    [UnitType] ,
                                    [Status] ,
                                    [CancelReason] ,
                                    [ProviderId] ,
                                    [ClinicianId] ,
                                    [AttendingId] ,
                                    [ProgramId] ,
                                    [LocationId] ,
                                    [Billable] ,
                                    [ClientWasPresent] ,
                                    [OtherPersonsPresent] ,
                                    [AuthorizationsApproved] ,
                                    [AuthorizationsNeeded] ,
                                    [AuthorizationsRequested] ,
                                    [Charge] ,
                                    [NumberOfTimeRescheduled] ,
                                    [NumberOfTimesCancelled] ,
                                    [ProcedureRateId] ,
                                    [DoNotComplete] ,
                                    [Comment] ,
                                    [Flag1] ,
                                    [OverrideError] ,
                                    [OverrideBy] ,
                                    [ReferringId] ,
                                    [DateTimeIn] ,
                                    [DateTimeOut] ,
                                    [NoteAuthorId] ,
                                    [ModifierId1] ,
                                    [ModifierId2] ,
                                    [ModifierId3] ,
                                    [ModifierId4] ,
                                    [PlaceOfServiceId] ,
                                    [SpecificLocation] ,
                                    [OverrideCharge] ,
                                    [OverrideChargeAmount] ,
                                    [ChargeAmountOverrideBy]
                            FROM    [Services]
                        END			
                END
            ELSE
                IF @Date IS NOT NULL
                    BEGIN
                        IF OBJECT_ID('tempdb..#UnsavedChangeAttendanceAssignments') IS NOT NULL
                            DROP TABLE #UnsavedChangeAttendanceAssignments
                        IF OBJECT_ID('tempdb..#AttendanceAssignments') IS NOT NULL
                            DROP TABLE #AttendanceAssignments
                        IF OBJECT_ID('tempdb..#GroupClients') IS NOT NULL
                            DROP TABLE #GroupClients				
                        IF OBJECT_ID('tempdb..#EnrolledClients') IS NOT NULL
                            DROP TABLE #EnrolledClients
                        IF OBJECT_ID('tempdb..#NonAttendanceAssignments') IS NOT NULL
                            DROP TABLE #NonAttendanceAssignments
                        IF OBJECT_ID('tempdb..#ResultSet') IS NOT NULL
                            DROP TABLE #ResultSet
				
                        CREATE TABLE #UnsavedChangeAttendanceAssignments
                            (
                              AttendanceAssignmentId INT ,
                              ModifiedBy VARCHAR(30) ,
                              ModifiedDate DATETIME ,
                              ClientId INT ,
                              GroupId INT ,
                              ProgramId INT ,
                              StaffId INT ,
                              IsSaved CHAR(1) ,
                              AssignmentDate DATETIME ,
                              StartDateTime DATETIME ,
                              EndDateTime DATETIME
                            )
				
			--IF @UnsavedChange IS NOT NULL
			--BEGIN
			--	INSERT INTO #UnsavedChangeAttendanceAssignments(AttendanceAssignmentId,ModifiedBy,ModifiedDate,ClientId,GroupId,ProgramId,StaffId,IsSaved,AssignmentDate,StartDateTime,EndDateTime)
			--	SELECT a.b.value('AttendanceAssignmentId[1]', 'INT')					
			--		,a.b.value('ModifiedBy[1]', 'VARCHAR(30)')
			--		,a.b.value('xs:dateTime(ModifiedDate[1])', 'DATETIME')
			--		,a.b.value('ClientId[1]', 'INT')
			--		,a.b.value('GroupId[1]', 'INT')
			--		,a.b.value('ProgramId[1]', 'INT')
			--		,a.b.value('StaffId[1]', 'INT')
			--		,a.b.value('IsSaved[1]', 'CHAR(1)')					
			--		,a.b.value('xs:dateTime(AssignmentDate[1])', 'DATETIME')
			--		,a.b.value('xs:dateTime(StartDateTime[1])', 'DATETIME')
			--		,a.b.value('xs:dateTime(EndDateTime[1])', 'DATETIME')
			--	FROM @UnsavedChange.nodes('DataSetAttendanceAssignment/AttendanceAssignments') a(b)				
			--END
		
                        CREATE TABLE #AttendanceAssignments
                            (
                              AttendanceAssignmentId INT ,
                              CreatedBy VARCHAR(30) ,
                              CreatedDate DATETIME ,
                              ModifiedBy VARCHAR(30) ,
                              ModifiedDate DATETIME ,
                              ClientId INT ,
                              ClientName VARCHAR(90) ,
                              GroupId INT ,
                              GroupName VARCHAR(250) ,
                              ProgramId INT ,
                              ProgramCode VARCHAR(100) ,
                              StaffId INT ,
                              StaffName VARCHAR(90) ,
                              IsSaved CHAR(1) ,
                              AssignmentDate DATETIME ,
                              StartDateTime DATETIME ,
                              EndDateTime DATETIME ,
                              GroupServiceId INT ,
                              CurrentGroupId INT
                            )
			
                        CREATE TABLE #GroupClients
                            (
                              CreatedBy VARCHAR(30) ,
                              CreatedDate DATETIME ,
                              ModifiedBy VARCHAR(30) ,
                              ModifiedDate DATETIME ,
                              ClientId INT ,
                              ClientName VARCHAR(90) ,
                              GroupId INT ,
                              GroupName VARCHAR(250) ,
                              ProgramId INT ,
                              ProgramCode VARCHAR(100) ,
                              StaffId INT ,
                              StaffName VARCHAR(90) ,
                              IsSaved CHAR(1) ,
                              AssignmentDate DATETIME ,
                              StartDateTime DATETIME ,
                              EndDateTime DATETIME
                            )	
			
                        CREATE TABLE #EnrolledClients
                            (
                              CreatedBy VARCHAR(30) ,
                              CreatedDate DATETIME ,
                              ModifiedBy VARCHAR(30) ,
                              ModifiedDate DATETIME ,
                              ClientId INT ,
                              ClientName VARCHAR(90) ,
                              GroupId INT ,
                              GroupName VARCHAR(250) ,
                              ProgramId INT ,
                              ProgramCode VARCHAR(100) ,
                              StaffId INT ,
                              StaffName VARCHAR(90) ,
                              IsSaved CHAR(1) ,
                              AssignmentDate DATETIME ,
                              StartDateTime DATETIME ,
                              EndDateTime DATETIME
                            )		
			
                        CREATE TABLE #NonAttendanceAssignments
                            (
                              AttendanceAssignmentId INT IDENTITY(1, 1) ,
                              CreatedBy VARCHAR(30) ,
                              CreatedDate DATETIME ,
                              ModifiedBy VARCHAR(30) ,
                              ModifiedDate DATETIME ,
                              ClientId INT ,
                              ClientName VARCHAR(90) ,
                              GroupId INT ,
                              GroupName VARCHAR(250) ,
                              ProgramId INT ,
                              ProgramCode VARCHAR(100) ,
                              StaffId INT ,
                              StaffName VARCHAR(90) ,
                              IsSaved CHAR(1) ,
                              AssignmentDate DATETIME ,
                              StartDateTime DATETIME ,
                              EndDateTime DATETIME
                            )		
				
                        CREATE TABLE #ResultSet
                            (
                              AttendanceAssignmentId INT ,
                              CreatedBy VARCHAR(30) ,
                              CreatedDate DATETIME ,
                              ModifiedBy VARCHAR(30) ,
                              ModifiedDate DATETIME ,
                              ClientId INT ,
                              ClientName VARCHAR(90) ,
                              GroupId INT ,
                              GroupName VARCHAR(250) ,
                              ProgramId INT ,
                              ProgramCode VARCHAR(100) ,
                              StaffId INT ,
                              StaffName VARCHAR(90) ,
                              IsSaved CHAR(1) ,
                              AssignmentDate DATETIME ,
                              StartDateTime DATETIME ,
                              EndDateTime DATETIME ,
                              GroupServiceId INT ,
                              CurrentGroupId INT
                            )
				
			
			
                        INSERT  INTO #AttendanceAssignments
                                ( AttendanceAssignmentId ,
                                  CreatedBy ,
                                  CreatedDate ,
                                  ModifiedBy ,
                                  ModifiedDate ,
                                  ClientId ,
                                  ClientName ,
                                  GroupId ,
                                  GroupName ,
                                  ProgramId ,
                                  ProgramCode ,
                                  StaffId ,
                                  StaffName ,
                                  IsSaved ,
                                  AssignmentDate ,
                                  StartDateTime ,
                                  EndDateTime ,
                                  GroupServiceId ,
                                  CurrentGroupId
				                )
                        OUTPUT  inserted.AttendanceAssignmentId ,
                                inserted.CreatedBy ,
                                inserted.CreatedDate ,
                                inserted.ModifiedBy ,
                                inserted.ModifiedDate ,
                                inserted.ClientId ,
                                inserted.ClientName ,
                                inserted.GroupId ,
                                inserted.GroupName ,
                                inserted.ProgramId ,
                                inserted.ProgramCode ,
                                inserted.StaffId ,
                                inserted.StaffName ,
                                inserted.IsSaved ,
                                inserted.AssignmentDate ,
                                inserted.StartDateTime ,
                                inserted.EndDateTime ,
                                inserted.GroupServiceId ,
                                inserted.CurrentGroupId
                                INTO #ResultSet
                                SELECT  s.ServiceId ,
                                        s.CreatedBy ,
                                        s.CreatedDate ,
                                        s.ModifiedBy ,
                                        s.ModifiedDate ,
                                        s.ClientId ,
                                        C.LastName + ', ' + C.FirstName AS ClientName ,
                                        g.GroupId ,
                                        G.GroupName ,
                                        s.ProgramId ,
                                        P.ProgramCode ,
                                        s.ClinicianId AS StaffId ,
                                        ST.LastName + ', ' + ST.FirstName AS StaffName ,
                                        'Y' AS IsSaved ,
                                        s.DateOfService AS AssignmentDate ,
                                        s.DateOfService AS StartDateTime ,
                                        s.EndDateOfService AS EndDateTime ,
                                        s.GroupServiceId ,
                                        g.GroupId AS CurrentGroupId
                                FROM    GroupServices gs
                                        JOIN Groups g ON g.GroupId = gs.GroupId
                                                         AND ISNULL(g.RecordDeleted, 'N') = 'N'
                                                         AND ISNULL(g.UsesAttendanceFunctions, 'N') = 'Y'
                                                         AND ISNULL(g.Active, 'N') = 'Y'
                                        JOIN Services s ON s.GroupServiceId = gs.GroupServiceId
                                                           AND ISNULL(s.RecordDeleted, 'N') = 'N'
			--JOIN StaffPrograms SP ON SP.ProgramId = S.ProgramId AND ISNULL(SP.RecordDeleted, 'N') = 'N'
                                        JOIN Programs p ON s.ProgramId = p.ProgramId
                                                           AND ISNULL(p.RecordDeleted, 'N') = 'N'
                                                           AND ISNULL(p.Active, 'N') = 'Y'
                                        JOIN ProcedureCodes ON ProcedureCodes.ProcedureCodeId = s.ProcedureCodeId
                                        JOIN Clients C ON s.ClientId = C.ClientId
                                                          AND ISNULL(C.RecordDeleted, 'N') = 'N'
                                                          AND ISNULL(C.Active, 'N') = 'Y'	
			--JOIN StaffClients sc ON C.ClientId = sc.ClientId AND sc.StaffId = @StaffId
                                        LEFT JOIN Staff ST ON s.ClinicianId = ST.StaffId
                                                              AND ISNULL(S.RecordDeleted, 'N') = 'N'
                                                              AND ISNULL(ST.Active, 'N') = 'Y'
                                WHERE   ISNULL(gs.RecordDeleted, 'N') = 'N'
                                        AND s.[Status] = 70
                                        AND CAST(s.DateOfService AS DATE) = CAST(@Date AS DATE)
                                        AND ( ISNULL(g.GroupId, -1) = @GroupId
                                              OR @GroupId = 0
                                            )
                                        AND ( ISNULL(s.ProgramId, -1) = @ProgramId
                                              OR @ProgramId = 0
                                            )
                                        AND EXISTS ( SELECT 1
                                                     FROM   StaffPrograms SP
                                                     WHERE  SP.ProgramId = s.ProgramId
                                                            AND ISNULL(SP.RecordDeleted, 'N') = 'N'
                                                            AND SP.StaffId = @StaffId )--Pabitra 07/26/2016
                                        AND EXISTS ( SELECT 1
                                                     FROM   StaffClients sc
                                                     WHERE  sc.ClientId = s.ClientId
                                                            AND sc.StaffId = @StaffId )
                                ORDER BY s.DateOfService DESC
			
			
                        INSERT  INTO #GroupClients
                                ( CreatedBy ,
                                  CreatedDate ,
                                  ModifiedBy ,
                                  ModifiedDate ,
                                  ClientId ,
                                  ClientName ,
                                  GroupId ,
                                  GroupName ,
                                  ProgramId ,
                                  ProgramCode ,
                                  StaffId ,
                                  StaffName ,
                                  AssignmentDate
                                )
                                SELECT  @UserCode ,
                                        GETDATE() ,
                                        @UserCode ,
                                        GETDATE() ,
                                        ClientId ,
                                        ClientName ,
                                        GroupId ,
                                        GroupName ,
                                        ProgramId ,
                                        ProgramCode ,
                                        ClinicianId ,
                                        ClinicianName ,
                                        AssignmentDate
                                FROM    ( SELECT DISTINCT
                                                    C.ClientId ,
                                                    C.LastName + ', ' + C.FirstName AS ClientName ,
                                                    GC.GroupId ,
                                                    G.GroupName ,
                                                    p.ProgramId ,
                                                    p.ProgramCode ,
                                                    G.ClinicianId ,
                                                    CASE WHEN G.ClinicianId IS NOT NULL THEN S.LastName + ', ' + S.FirstName
                                                         ELSE ''
                                                    END ClinicianName ,
                                                    @Date AS AssignmentDate
                                          FROM      GroupClients GC
                                                    JOIN Groups G ON GC.GroupId = G.GroupId
                                                                     AND ISNULL(G.RecordDeleted, 'N') = 'N'
                                                                     AND ISNULL(G.Active, 'N') = 'Y'
                                                                     AND ISNULL(G.UsesAttendanceFunctions, 'N') = 'Y' --AND ISNULL(G.AddClientsFromRoster,'N') = 'Y'
			   --JOIN StaffPrograms SP ON G.ProgramId = SP.ProgramId AND ISNULL(SP.RecordDeleted, 'N') = 'N'  
                                                    JOIN Programs p ON p.ProgramId = G.ProgramId
                                                                       AND ISNULL(p.RecordDeleted, 'N') = 'N'
                                                                       AND ISNULL(p.Active, 'N') = 'Y'
                                                    JOIN Clients C ON GC.ClientId = C.ClientId
                                                                      AND ISNULL(C.RecordDeleted, 'N') = 'N'
                                                                      AND ISNULL(C.Active, 'N') = 'Y'  
			   --JOIN StaffClients sc ON C.ClientId = sc.ClientId AND sc.StaffId = @StaffId  
                                                    LEFT JOIN Staff S ON G.ClinicianId = S.StaffId
                                                                         AND ISNULL(S.RecordDeleted, 'N') = 'N'
                                                                         AND ISNULL(S.Active, 'N') = 'Y'
                                          WHERE     ( ISNULL(GC.GroupId, -1) = @GroupId
                                                      OR @GroupId = 0
                                                    )
                                                    AND ( ISNULL(G.ProgramId, -1) = @ProgramId
                                                          OR @ProgramId = 0
                                                        )
                                                    AND ISNULL(GC.RecordDeleted, 'N') = 'N'
                                                    AND EXISTS ( SELECT 1
                                                                 FROM   StaffPrograms SP
                                                                 WHERE  SP.ProgramId = G.ProgramId
                                                                        AND ISNULL(SP.RecordDeleted, 'N') = 'N'
                                                                        AND SP.StaffId = @StaffId ) --Pabitra 07/26/2016
                                                    AND EXISTS ( SELECT 1
                                                                 FROM   StaffClients sc
                                                                 WHERE  sc.ClientId = C.ClientId
                                                                        AND sc.StaffId = @StaffId )
                                        ) AS T
			
                        DELETE  NAA
                        FROM    #GroupClients NAA
                                JOIN #AttendanceAssignments AA ON NAA.ClientId = AA.ClientId
                                                                  AND NAA.GroupId = AA.GroupId
                                                                  AND NAA.ProgramId = AA.ProgramId		
				
                        INSERT  INTO #EnrolledClients
                                ( CreatedBy ,
                                  CreatedDate ,
                                  ModifiedBy ,
                                  ModifiedDate ,
                                  ClientId ,
                                  ClientName ,
                                  GroupId ,
                                  GroupName ,
                                  ProgramId ,
                                  ProgramCode ,
                                  StaffId ,
                                  StaffName ,
                                  AssignmentDate
                                )
                                SELECT  @UserCode ,
                                        GETDATE() ,
                                        @UserCode ,
                                        GETDATE() ,
                                        ClientId ,
                                        ClientName ,
                                        GroupId ,
                                        GroupName ,
                                        ProgramId ,
                                        ProgramCode ,
                                        StaffId ,
                                        StaffName ,
                                        AssignmentDate
                                FROM    ( SELECT DISTINCT
                                                    c.ClientId ,
                                                    c.LastName + ', ' + c.FirstName AS ClientName ,
                                                    G.GroupId ,
                                                    G.GroupName ,
                                                    p.ProgramId ,
                                                    p.ProgramCode ,
                                                    CASE WHEN cp.AssignedStaffId IS NOT NULL THEN cp.AssignedStaffId
                                                         ELSE s.StaffId
                                                    END StaffId ,
                                                    CASE WHEN cp.AssignedStaffId IS NOT NULL THEN S2.LastName + ', ' + S2.FirstName
                                                         WHEN s.StaffId IS NOT NULL THEN s.LastName + ', ' + s.FirstName
                                                         ELSE ''
                                                    END StaffName ,
                                                    @Date AS AssignmentDate
                                          FROM      Clients AS c
                                                    INNER JOIN ClientPrograms AS cp ON cp.ClientId = c.ClientId
                                                                                       AND ISNULL(cp.RecordDeleted, 'N') = 'N'
                                                                                       AND ISNULL(c.RecordDeleted, 'N') = 'N'
                                                                                       AND ISNULL(c.Active, 'N') = 'Y'
			--JOIN StaffPrograms SP ON cp.ProgramId = SP.ProgramId AND ISNULL(SP.RecordDeleted, 'N') = 'N'
                                                    JOIN Programs p ON cp.ProgramId = p.ProgramId
                                                                       AND ISNULL(p.RecordDeleted, 'N') = 'N'
                                                                       AND ISNULL(p.Active, 'N') = 'Y'
                                                    INNER JOIN Groups G ON G.ProgramId = p.ProgramId
                                                                           AND ISNULL(G.RecordDeleted, 'N') = 'N'
                                                                           AND ISNULL(G.Active, 'N') = 'Y'
                                                                           AND ISNULL(G.UsesAttendanceFunctions, 'N') = 'Y'
                                                                           AND ISNULL(G.AttendanceClientsEnrolledPrograms, 'N') = 'Y'
			--INNER JOIN StaffClients sc ON sc.StaffId = @StaffId AND sc.ClientId = c.ClientId 
                                                    INNER JOIN GlobalCodes AS gc ON gc.GlobalCodeId = cp.[Status]
                                                                                    AND ISNULL(gc.RecordDeleted, 'N') = 'N'
                                                                                    AND gc.Active = 'Y'
                                                    LEFT OUTER JOIN Staff AS s ON s.StaffId = c.PrimaryClinicianId
                                                    LEFT JOIN Staff S2 ON cp.AssignedStaffId = S2.StaffId
                                          WHERE     gc.CodeName = 'Enrolled'
                                                    AND ( ISNULL(G.GroupId, -1) = @GroupId
                                                          OR @GroupId = 0
                                                        )
                                                    AND ( ISNULL(p.ProgramId, -1) = @ProgramId
                                                          OR @ProgramId = 0
                                                        )
                                                    AND EXISTS ( SELECT 1
                                                                 FROM   StaffPrograms SP
                                                                 WHERE  SP.ProgramId = cp.ProgramId
                                                                        AND ISNULL(SP.RecordDeleted, 'N') = 'N'
                                                                        AND SP.StaffId = @StaffId ) --Pabitra 07/27/2016
                                                    AND EXISTS ( SELECT 1
                                                                 FROM   StaffClients sc
                                                                 WHERE  sc.ClientId = c.ClientId
                                                                        AND sc.StaffId = @StaffId )
                                        ) AS T
				
                        DELETE  NAA
                        FROM    #EnrolledClients NAA
                                JOIN #AttendanceAssignments AA ON NAA.ClientId = AA.ClientId
                                                                  AND NAA.GroupId = AA.GroupId
                                                                  AND NAA.ProgramId = AA.ProgramId
				
                        DELETE  NAA
                        FROM    #EnrolledClients NAA
                                JOIN #GroupClients AA ON NAA.ClientId = AA.ClientId
                                                         AND NAA.GroupId = AA.GroupId
                                                         AND NAA.ProgramId = AA.ProgramId
				
                        INSERT  INTO #NonAttendanceAssignments
                                ( CreatedBy ,
                                  CreatedDate ,
                                  ModifiedBy ,
                                  ModifiedDate ,
                                  ClientId ,
                                  ClientName ,
                                  GroupId ,
                                  GroupName ,
                                  ProgramId ,
                                  ProgramCode ,
                                  StaffId ,
                                  StaffName ,
                                  AssignmentDate
                                )
                                SELECT  CreatedBy ,
                                        CreatedDate ,
                                        ModifiedBy ,
                                        ModifiedDate ,
                                        ClientId ,
                                        ClientName ,
                                        GroupId ,
                                        GroupName ,
                                        ProgramId ,
                                        ProgramCode ,
                                        StaffId ,
                                        StaffName ,
                                        AssignmentDate
                                FROM    #GroupClients
			
                        INSERT  INTO #NonAttendanceAssignments
                                ( CreatedBy ,
                                  CreatedDate ,
                                  ModifiedBy ,
                                  ModifiedDate ,
                                  ClientId ,
                                  ClientName ,
                                  GroupId ,
                                  GroupName ,
                                  ProgramId ,
                                  ProgramCode ,
                                  StaffId ,
                                  StaffName ,
                                  AssignmentDate
                                )
                                SELECT  CreatedBy ,
                                        CreatedDate ,
                                        ModifiedBy ,
                                        ModifiedDate ,
                                        ClientId ,
                                        ClientName ,
                                        GroupId ,
                                        GroupName ,
                                        ProgramId ,
                                        ProgramCode ,
                                        StaffId ,
                                        StaffName ,
                                        AssignmentDate
                                FROM    #EnrolledClients
						
                        INSERT  INTO #ResultSet
                                ( AttendanceAssignmentId ,
                                  CreatedBy ,
                                  CreatedDate ,
                                  ModifiedBy ,
                                  ModifiedDate ,
                                  ClientId ,
                                  ClientName ,
                                  GroupId ,
                                  GroupName ,
                                  ProgramId ,
                                  ProgramCode ,
                                  StaffId ,
                                  StaffName ,
                                  AssignmentDate
                                )
                                SELECT  ( ROW_NUMBER() OVER ( ORDER BY ClientName, ClientId, AttendanceAssignmentId ) * -1 ) ,
                                        CreatedBy ,
                                        CreatedDate ,
                                        ModifiedBy ,
                                        ModifiedDate ,
                                        ClientId ,
                                        ClientName ,
                                        GroupId ,
                                        GroupName ,
                                        ProgramId ,
                                        ProgramCode ,
                                        StaffId ,
                                        StaffName ,
                                        AssignmentDate
                                FROM    #NonAttendanceAssignments
                                ORDER BY ClientName ,
                                        ClientId ,
                                        AttendanceAssignmentId ASC;
                            WITH    Counts
                                      AS ( SELECT   COUNT(*) AS TotalRows
                                           FROM     #ResultSet
                                         ),
                                    RankResultSet
                                      AS ( SELECT   AttendanceAssignmentId ,
                                                    CreatedBy ,
                                                    CreatedDate ,
                                                    ModifiedBy ,
                                                    ModifiedDate ,
                                                    ClientId ,
                                                    ClientName ,
                                                    GroupId ,
                                                    GroupName ,
                                                    ProgramId ,
                                                    ProgramCode ,
                                                    StaffId ,
                                                    StaffName ,
                                                    IsSaved ,
                                                    AssignmentDate ,
                                                    StartDateTime ,
                                                    EndDateTime ,
                                                    GroupServiceId ,
                                                    CurrentGroupId ,
                                                    COUNT(*) OVER ( ) AS TotalCount ,
                                                                    RANK() OVER ( ORDER BY ClientName, AttendanceAssignmentId ) AS RowNumber
                                           FROM                     #ResultSet
                                         )
                            SELECT TOP ( CASE WHEN ( @PageNumber = -1 ) THEN ( SELECT   ISNULL(TotalRows, 0)
                                                                               FROM     Counts
                                                                             )
                                              ELSE ( @PageSize )
                                         END )
                                    AttendanceAssignmentId ,
                                    CreatedBy ,
                                    CreatedDate ,
                                    ModifiedBy ,
                                    ModifiedDate ,
                                    ClientId ,
                                    ClientName ,
                                    GroupId ,
                                    GroupName ,
                                    ProgramId ,
                                    ProgramCode ,
                                    StaffId ,
                                    StaffName ,
                                    IsSaved ,
                                    AssignmentDate ,
                                    StartDateTime ,
                                    EndDateTime ,
                                    GroupServiceId ,
                                    CurrentGroupId ,
                                    TotalCount ,
                                    RowNumber
                            INTO    #FinalResultSet
                            FROM    RankResultSet
                            WHERE   RowNumber > ( ( @PageNumber - 1 ) * @PageSize )

                        IF ( SELECT ISNULL(COUNT(*), 0)
                             FROM   #FinalResultSet
                           ) < 1
                            BEGIN
                                SELECT  0 AS PageNumber ,
                                        0 AS NumberOfPages ,
                                        0 NumberofRows
                            END
                        ELSE
                            BEGIN
                                SELECT TOP 1
                                        @PageNumber AS PageNumber ,
                                        CASE ( Totalcount % @PageSize )
                                          WHEN 0 THEN ISNULL(( Totalcount / @PageSize ), 0)
                                          ELSE ISNULL(( Totalcount / @PageSize ), 0) + 1
                                        END AS NumberOfPages ,
                                        ISNULL(Totalcount, 0) AS NumberofRows
                                FROM    #FinalResultSet
                            END
				
                        UPDATE  FRS
                        SET     FRS.ModifiedBy = US.ModifiedBy ,
                                FRS.ModifiedDate = US.ModifiedDate ,
                                FRS.StaffId = US.StaffId ,
                                FRS.StaffName = CASE WHEN US.StaffId IS NOT NULL THEN S.LastName + ', ' + S.FirstName
                                                     ELSE ''
                                                END ,
                                FRS.IsSaved = US.IsSaved ,
                                FRS.StartDateTime = US.StartDateTime ,
                                FRS.EndDateTime = US.EndDateTime ,
                                FRS.GroupId = US.GroupId ,
                                FRS.GroupName = g.GroupName
                        FROM    #FinalResultSet FRS
                                JOIN ( SELECT   a.b.value('AttendanceAssignmentId[1]', 'INT') AS AttendanceAssignmentId ,
                                                a.b.value('ModifiedBy[1]', 'VARCHAR(30)') AS ModifiedBy ,
                                                a.b.value('xs:dateTime(ModifiedDate[1])', 'DATETIME') AS ModifiedDate ,
                                                a.b.value('ClientId[1]', 'INT') AS ClientId ,
                                                a.b.value('GroupId[1]', 'INT') AS GroupId ,
                                                a.b.value('ProgramId[1]', 'INT') AS ProgramId ,
                                                a.b.value('StaffId[1]', 'INT') AS StaffId ,
                                                a.b.value('IsSaved[1]', 'CHAR(1)') AS IsSaved ,
                                                a.b.value('xs:dateTime(AssignmentDate[1])', 'DATETIME') AS AssignmentDate ,
                                                a.b.value('xs:dateTime(StartDateTime[1])', 'DATETIME') AS StartDateTime ,
                                                a.b.value('xs:dateTime(EndDateTime[1])', 'DATETIME') AS EndDateTime
                                       FROM     @UnsavedChange.nodes('DataSetAttendanceAssignment/AttendanceAssignments') a ( b )
                                     ) US ON FRS.AttendanceAssignmentId = US.AttendanceAssignmentId
                                LEFT JOIN Staff S ON US.StaffId = S.StaffId
                                                     AND ISNULL(S.RecordDeleted, 'N') = 'N'
                                                     AND ISNULL(S.Active, 'N') = 'Y'
                                LEFT JOIN Groups g ON US.GroupId = g.GroupId
                                                      AND ISNULL(g.RecordDeleted, 'N') = 'N'
                                                      AND ISNULL(g.UsesAttendanceFunctions, 'N') = 'Y'
                                                      AND ISNULL(g.Active, 'N') = 'Y'
                        WHERE   FRS.ClientId = US.ClientId
				--AND FRS.GroupId = US.GroupId
                                AND FRS.ProgramId = US.ProgramId
                                AND CAST(FRS.AssignmentDate AS DATE) = CAST(US.AssignmentDate AS DATE)
				
                        SELECT  AttendanceAssignmentId ,
                                CreatedBy ,
                                CreatedDate ,
                                ModifiedBy ,
                                ModifiedDate ,
                                ClientId ,
                                ClientName ,
                                GroupId ,
                                GroupName ,
                                ProgramId ,
                                ProgramCode ,
                                StaffId ,
                                StaffName ,
                                IsSaved ,
                                AssignmentDate ,
                                StartDateTime ,
                                EndDateTime ,
                                GroupServiceId ,
                                CurrentGroupId
                        FROM    #FinalResultSet
                        ORDER BY ClientName ,
                                ClientId ASC
			
                        IF OBJECT_ID('tempdb..#UnsavedChangeAttendanceAssignments') IS NOT NULL
                            DROP TABLE #UnsavedChangeAttendanceAssignments
                        IF OBJECT_ID('tempdb..#AttendanceAssignments') IS NOT NULL
                            DROP TABLE #AttendanceAssignments
                        IF OBJECT_ID('tempdb..#GroupClients') IS NOT NULL
                            DROP TABLE #GroupClients
                        IF OBJECT_ID('tempdb..#EnrolledClients') IS NOT NULL
                            DROP TABLE #EnrolledClients
                        IF OBJECT_ID('tempdb..#NonAttendanceAssignments') IS NOT NULL
                            DROP TABLE #NonAttendanceAssignments
                        IF OBJECT_ID('tempdb..#ResultSet') IS NOT NULL
                            DROP TABLE #ResultSet

                    END
                ELSE
                    BEGIN
                        SELECT  0 AS AttendanceAssignmentId ,
                                @UserCode AS CreatedBy ,
                                GETDATE() AS CreatedDate ,
                                @UserCode AS ModifiedBy ,
                                GETDATE() AS ModifiedDate

                        SELECT TOP 0
                                [ServiceId] ,
                                [CreatedBy] ,
                                [CreatedDate] ,
                                [ModifiedBy] ,
                                [ModifiedDate] ,
                                [RecordDeleted] ,
                                [DeletedDate] ,
                                [DeletedBy] ,
                                [ClientId] ,
                                [GroupServiceId] ,
                                [ProcedureCodeId] ,
                                [DateOfService] ,
                                [EndDateOfService] ,
                                [RecurringService] ,
                                [Unit] ,
                                [UnitType] ,
                                [Status] ,
                                [CancelReason] ,
                                [ProviderId] ,
                                [ClinicianId] ,
                                [AttendingId] ,
                                [ProgramId] ,
                                [LocationId] ,
                                [Billable] ,
                                [ClientWasPresent] ,
                                [OtherPersonsPresent] ,
                                [AuthorizationsApproved] ,
                                [AuthorizationsNeeded] ,
                                [AuthorizationsRequested] ,
                                [Charge] ,
                                [NumberOfTimeRescheduled] ,
                                [NumberOfTimesCancelled] ,
                                [ProcedureRateId] ,
                                [DoNotComplete] ,
                                [Comment] ,
                                [Flag1] ,
                                [OverrideError] ,
                                [OverrideBy] ,
                                [ReferringId] ,
                                [DateTimeIn] ,
                                [DateTimeOut] ,
                                [NoteAuthorId] ,
                                [ModifierId1] ,
                                [ModifierId2] ,
                                [ModifierId3] ,
                                [ModifierId4] ,
                                [PlaceOfServiceId] ,
                                [SpecificLocation] ,
                                [OverrideCharge] ,
                                [OverrideChargeAmount] ,
                                [ChargeAmountOverrideBy]
                        FROM    [Services]

                    END
				
        END TRY

        BEGIN CATCH
            DECLARE @Error VARCHAR(8000)                                                                                         
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetAttendanceAssignment') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())                                                                    
            RAISERROR                                                                           
    (                                                                                          
     @Error, -- Message text.                                                                                                                      
     16, -- Severity.                                                                                                                      
     1 -- State.                                                                                                                      
     );        

        END CATCH
    END

GO


