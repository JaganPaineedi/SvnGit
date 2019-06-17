IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_SCGetPartialIOPData]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [dbo].[ssp_SCGetPartialIOPData]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetPartialIOPData]    Script Date: 07/01/2014******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetPartialIOPData]
    @ProgramId INT ,
    @DateFilter DATETIME ,
    @StaffId INT ,
    @SchedulingPreferenceMonday CHAR(1) ,
    @SchedulingPreferenceTuesday CHAR(1) ,
    @SchedulingPreferenceWednesday CHAR(1) ,
    @SchedulingPreferenceThursday CHAR(1) ,
    @SchedulingPreferenceFriday CHAR(1) ,
    @IncludeShowCompleteService CHAR(1) ,
    @CopyDateFilter DATETIME ,
    @ScreenAction CHAR(1) ,
    @ProcedureGroup INT ,
    @OnlyShowClientsSeenInLast90Days CHAR(1) ,
    @PageNumber INT ,
    @PageSize INT, --Number of Clients Per Page
    @LastNameIndex INT,
	@ProgramsFromOrganizations VARCHAR(MAX)
AS /**************************************************************/
/* Stored Procedure: [ssp_SCGetPartialIOPData]   */
/* Creation Date:  07 Jan 2014                              */
/* Purpose: To Get Team Scheduling Detail Data   for Partial IOP */
/* Called By: Team Scheduling Detail(Partial IOP in Philhaven) screen     */
/* Updates:                                                   */
/* Date   Author   Purpose         */
/* 07 Jan 2014 Dhanil Manuel	Created		To get Team Scheduling Detail Data  For Philhaven development task #141 */
/* 07 Feb 2014 Dhanil Manuel	Modified    To Rmove copy service part    For Philhaven development task #141*/
/* 11 Feb 2014 Dhanil Manuel	Modified    @IncludeShowCompleteService logic modified  For Philhaven development task #141*/
/* 13 Feb 2014 Dhanil Manuel	Modified   Status = 71 logic modified  For Philhaven development task #141*/
/* 23 Jun 2014 Kirtee           Modified    Checked value set to Y if ServiceId > 0 and N if serviceId < 0 wrf Philhaven - Customization Issues Tracking task# 1125  */

/* 11 Jul 2014 Smitha Sebastian  Added DisabledRow Flag to check whether the service have Note attached to it and Status is 'Show' w.r.t Philhaven - Customization Issues Tracking task# 1125  */
-- OCT-07-2014 Akwinass       Removed Columns 'DiagnosisCode1,DiagnosisNumber1,DiagnosisVersion1,DiagnosisCode2,DiagnosisNumber2,DiagnosisVersion2,DiagnosisCode3,DiagnosisNumber3,DiagnosisVersion3' from Services table (Task #134 in Engineering Improvement Initiatives- NBL(I))
-- APRIL-30-2015  Akwinass     Included New Column 'ReasonForNewVersion' (Task #233 in Philhaven Development)
/* 07-July-2015   Hemant       Added OverrideCharge,OverrideChargeAmount,ChargeAmountOverrideBy in services table Why:Charge Override on the Service Detail Screen #605.1 Network 180 - Customizations*/
/* August-11-2015 NJain			Fixed the page number assignment to client logic. While the page size is set to 50, row number 50 was getting assigned to Page 2*/
-- September-11-2015 Vijay     Added Parameter '@LastNameIndex' (Task #334 in Philhaven Development)
-- 18-JULY-2016   Akwinass     Removed Hard Coded Program Status Check and Included Recodes (Task #352 in Engineering Improvement Initiatives- NBL(I))
-- 20-Feb-2017	  Ponnin	   Changing it to 20 client records per page. Task #159  Bradford - Environment Issues Tracking.
-- 26-May-2017	  Nandita	   Filter Programs based on the selected program ids 
-- 15/07/2017	  Sunil.D      What:Modified CustomDetailScreenConfiguration table check warning's to 'N'
--							   Why :Service Not created beacause its checking warnings before creating service #194 Philhaven Support.
-- 9/13/2017      Hemant       What:Included the string null check for @ProgramsFromOrganizations parameter.
--                             Why:The checkbox "Also include complete/show service for the day" should show all previously entered batch service.
--                             Project:Philhaven-Support #222
-- 12/19/2017	 jcarlson		Bradford SGL 279.1
--								Updated logic to handle program and organizational hierarchy programs
--								added temp table #TempPrograms to join to that stores all the user selected program Ids
--								Updated logic to use recode functions instead of looking directly at the recode tables
-- 14/05/2018	 Sunil Dasari	Philhaven-Support #353
--								What: Modified Logic to show clients either Enrolled programs or equal discharge date as filter date.
--								Why:The system should only display clients in Batch Service Entry with those with an ‘Enrolled’
--								 status for Programs. It should not pull in any clients with those with a ‘Requested’, ‘Referred’, ‘Discharged’ status.
--								 The only time Discharged clients should show on this list is if the date in the Batch Service Entry is the client’s
--								 Discharge Date. Any dates after the Discharge Date should not show the client in Batch Service Entry.

/*************************************************************/
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
   set nocount on
  
    BEGIN
        BEGIN TRY
		--Clients Temp Table who all are enrolled/requested/discharged after specified date for Program

            IF OBJECT_ID('tempdb..#TempClientPrograms') IS NULL
                BEGIN
                    CREATE TABLE #TempClientPrograms
                        (
                          ClientId INT ,
                          RowNum INT ,
                          ClientName VARCHAR(MAX)
                        )
                END
			IF OBJECT_ID('tempdb..#TempPrograms') IS NULL
                BEGIN
                    CREATE TABLE #TempPrograms
                        (
                          ProgramId INT 
                        )
                END
            IF OBJECT_ID('tempdb..#TempProcedureCodes') IS NULL
                BEGIN
                    CREATE TABLE #TempProcedureCodes ( ProcedureCodeId INT )
                END
				IF (@ProgramId != -1)
				BEGIN
					INSERT INTO #TempPrograms ( ProgramId )
					SELECT @ProgramId
				END
				
				IF @ProgramId = -1
				BEGIN
                INSERT INTO #TempPrograms ( ProgramId )
                SELECT 
				CONVERT(INT,item)
				FROM dbo.fnSplitWithIndex(@ProgramsFromOrganizations,',')

				END

			DECLARE @AllProcedureCodes VARCHAR(1);

            SELECT  @AllProcedureCodes = AllProcedureCodes
            FROM    ProcedureGroupViews
            WHERE   ProcedureGroupViews.ProcedureGroupViewId = @ProcedureGroup

            IF ( @AllProcedureCodes = 'N' )
                BEGIN
                    INSERT  INTO #TempProcedureCodes
                            SELECT  m.ProcedureCodeId
                            FROM    ProcedureGroupViewMaps m
                            WHERE   m.ProcedureGroupViewId = @ProcedureGroup
                                    AND ISNULL(m.RecordDeleted, 'N') <> 'Y';
                END
            ELSE
                IF ( @AllProcedureCodes = 'Y'
                     OR @ProcedureGroup = -1
                   )
                    BEGIN
                        INSERT  INTO #TempProcedureCodes
                                SELECT  pc.ProcedureCodeId
                                FROM    ProcedureCodes pc
                                WHERE   pc.Active = 'Y'
                                        AND ISNULL(pc.RecordDeleted, 'N') <> 'Y'
                    END

            CREATE TABLE #TempClientServices
                (
                  ServiceId [int] IDENTITY(- 1, - 1) ,
                  ClientId INT ,
                  ClientName VARCHAR(210) ,
                  ClinicianId INT ,
                  ProcedureCodeId INT ,
                  RequiresTimeInTimeOut VARCHAR(1) ,
                  LocationId INT ,
                  ProgramId INT ,
                  DateOfService DATETIME ,
                  EndDateOfService DATETIME ,
                  [Time] DATETIME ,
                  [TimeOut] DATETIME ,
                  Unit DECIMAL(18, 2) ,
                  STATUS INT ,
                  GroupServiceId INT ,
                  CreatedBy VARCHAR(30) ,
                  CreatedDate DATETIME ,
                  ModifiedBy VARCHAR(30) ,
                  ModifiedDate DATETIME ,
                  RecordDeleted CHAR(1) ,
                  DeletedBy VARCHAR(30) ,
                  DeletedDate DATETIME ,
                  IsChecked CHAR(1) ,
                  SchedulingPreferenceMonday CHAR(1) ,
                  SchedulingPreferenceTuesday CHAR(1) ,
                  SchedulingPreferenceWednesday CHAR(1) ,
                  SchedulingPreferenceThursday CHAR(1) ,
                  SchedulingPreferenceFriday CHAR(1) ,
                  GeographicLocation VARCHAR(50) ,
                  SchedulingComment VARCHAR(MAX) ,
                  SpecificLocation VARCHAR(MAX) ,
                  Preference VARCHAR(100) ,
                  UnitType INT ,
                  CancelReason INT ,
                  ProviderId INT ,
                  AttendingId INT ,
                  Billable CHAR(1) ,
                  ClientWasPresent CHAR(1) ,
                  OtherPersonsPresent VARCHAR(250) ,
                  AuthorizationsApproved INT ,
                  AuthorizationsNeeded INT ,
                  AuthorizationsRequested INT ,
                  NumberOfTimeRescheduled INT ,
                  NumberOfTimesCancelled INT ,
                  DoNotComplete CHAR(1) ,
                  Comment VARCHAR(MAX) ,
                  Flag1 CHAR(1) ,
                  OverrideError CHAR(1) ,
                  OverrideBy VARCHAR(30) ,
                  ReferringId INT ,
                  DateTimeIn DATETIME ,
                  DateTimeOut DATETIME ,
                  NoteAuthorId INT ,
                  ModifierId1 INT ,
                  ModifierId2 INT ,
                  ModifierId3 INT ,
                  ModifierId4 INT ,
                  PlaceOfServiceId INT ,
                  ServiceDetailTitle VARCHAR(MAX) ,
                  ProcedureCodeName VARCHAR(250) ,
                  StatusName VARCHAR(250) ,
                  UnitTypeName VARCHAR(250) ,
                  DocumentId INT ,
                  Charge MONEY ,
                  ProcedureRateId INT ,
                  SavedServiceStatus INT ,
                  RecurringService CHAR(1) ,
                  DisabledRow CHAR(1) ,
                  ClinicianName VARCHAR(MAX) ,
                  LocationName VARCHAR(MAX) ,
                  OverrideCharge CHAR(1) ,
                  OverrideChargeAmount MONEY ,
                  ChargeAmountOverrideBy VARCHAR(250)
                  ,LastNameIndex INT
                )

            DECLARE @CurrentDate DATE
            DECLARE @LastName CHAR(1)
            
            IF @LastNameIndex = - 1
			SET @LastName = NULL
		ELSE
			SET @LastName = CHAR(@LastNameIndex)
		
            SET @CurrentDate = GETDATE()
		
            INSERT  INTO #TempClientPrograms
                    ( ClientId ,
                      RowNum ,
                      ClientName
                    )
                    SELECT  C.ClientId ,
                            ROW_NUMBER() OVER ( ORDER BY C.LastName ) AS RowNum ,
                            ( CASE     -- modify by Basudev  for  network 180 task #609
								WHEN ISNULL(C.ClientType, 'I') = 'I'
								THEN ISNULL(C.LastName, '') + ' ' + ISNULL(C.FirstName, '')
								ELSE ISNULL(C.OrganizationName, '')
								END  ) AS ClientName
                    FROM    Clients C
                    WHERE   ISNULL(C.RecordDeleted, 'N') = 'N'
                            AND C.Active = 'Y'
                            AND (
						          @LastName IS NULL
						          OR C.LastName LIKE (@LastName + '%')
						         )
                            AND EXISTS ( SELECT 1
                                         FROM   ClientPrograms CP
										 JOIN #TempPrograms AS tp ON tp.ProgramId = CP.ProgramId
                                         WHERE  CP.ClientId = C.ClientId
                                                AND ISNULL(CP.RecordDeleted, 'N') <> 'Y'
												AND NOT EXISTS( SELECT 1
																FROM dbo.ssf_RecodeValuesCurrent('PROGRAMSTATUS') AS r
																JOIN GlobalCodes AS gc ON r.IntegerCodeId = gc.GlobalCodeId
																AND gc.Active = 'Y'
																AND ISNULL(gc.RecordDeleted,'N')='N'
																WHERE r.IntegerCodeId = cp.[Status]
															  )
												AND (CP.RequestedDate <= @DateFilter OR CP.RequestedDate IS NULL)
												AND (CP.EnrolledDate <= @DateFilter OR CP.EnrolledDate IS NULL)
												AND (CP.DischargedDate >= @DateFilter OR CP.DischargedDate IS NULL)
												--AND ((CP.[Status] = (SELECT globalcodeid FROM GlobalCodes where Category='PROGRAMSTATUS' and CodeName='Enrolled'))
														--	OR (CP.[Status] =(SELECT globalcodeid FROM GlobalCodes where Category='PROGRAMSTATUS' and CodeName='Discharged') and CP.DischargedDate = @DateFilter)
																--OR CP.DischargedDate IS NULL ) 
                                                    )
                            AND ( ( ISNULL(@OnlyShowClientsSeenInLast90Days, 'N') = 'N'
                                    OR @StaffId IS NULL
                                  )
                                  OR EXISTS ( SELECT    1
                                              FROM      Services s
                                              WHERE     s.ClientId = C.ClientId
                                                        AND s.ClinicianId = @StaffId
                                                        AND s.DateOfService >= DATEADD(DD, -90, @CurrentDate)
                                                        AND s.Status IN ( 75, 71 ) -- Show and Complete Services
                                                        AND ISNULL(s.RecordDeleted, 'N') = 'N' )
                                )
				
		----Pagination Logic
            DECLARE @NumberOfClients INT;
            DECLARE @NumberofPages INT;
            SET @NumberOfClients = ( SELECT MAX(CP.RowNum)
                                     FROM   #TempClientPrograms CP
                                   )
            SET @NumberofPages = @NumberOfClients / @PageSize;
            CREATE TABLE #TempClientPages
                (
                  ClientId INT ,
                  RowNum INT ,
                  PageNumber INT ,
                  ClientName VARCHAR(MAX)
                )
		
            INSERT  INTO #TempClientPages
                    ( ClientId ,
                      RowNum ,
                      PageNumber ,
                      ClientName
                    )
                    SELECT  TC.ClientId ,
                            tc.RowNum ,
                            CASE WHEN tc.RowNum % @PageSize = 0 THEN tc.RowNum / @PageSize
                                 ELSE ( ROUND(tc.RowNum / @PageSize, 0) + 1 )
                            END ,
                            TC.ClientName
                    FROM    #TempClientPrograms TC
		
	
            SET IDENTITY_INSERT #TempClientServices ON
            INSERT  INTO #TempClientServices
                    ( ServiceId ,
                      ClientId ,
                      ClientName ,
                      ClinicianId ,
                      ProcedureCodeId ,
                      RequiresTimeInTimeOut ,
                      LocationId ,
                      ProgramId ,
                      DateOfService ,
                      EndDateOfService ,
                      TIME ,
                      TimeOut ,
                      Unit ,
                      STATUS ,
                      S.CreatedBy ,
                      S.CreatedDate ,
                      S.ModifiedBy ,
                      S.ModifiedDate ,
                      S.RecordDeleted ,
                      S.DeletedBy ,
                      S.DeletedDate ,
                      IsChecked ,
                      SchedulingPreferenceMonday ,
                      SchedulingPreferenceTuesday ,
                      SchedulingPreferenceWednesday ,
                      SchedulingPreferenceThursday ,
                      SchedulingPreferenceFriday ,
                      GeographicLocation ,
                      SchedulingComment ,
                      SpecificLocation ,
                      Preference ,
                      UnitType ,
                      CancelReason ,
                      ProviderId ,
                      AttendingId ,
                      Billable ,
                      ClientWasPresent ,
                      OtherPersonsPresent ,
                      AuthorizationsApproved ,
                      AuthorizationsNeeded ,
                      AuthorizationsRequested ,
                      NumberOfTimeRescheduled ,
                      NumberOfTimesCancelled ,
                      DoNotComplete ,
                      Comment ,
                      Flag1 ,
                      OverrideError ,
                      OverrideBy ,
                      ReferringId ,
                      DateTimeIn ,
                      DateTimeOut ,
                      NoteAuthorId ,
                      ModifierId1 ,
                      ModifierId2 ,
                      ModifierId3 ,
                      ModifierId4 ,
                      PlaceOfServiceId ,
                      ServiceDetailTitle ,
                      ProcedureCodeName ,
                      StatusName ,
                      UnitTypeName ,
                      DocumentId ,
                      Charge ,
                      ProcedureRateId ,
                      SavedServiceStatus ,
                      RecurringService ,
                      DisabledRow ,
                      ClinicianName ,
                      LocationName ,
                      OverrideCharge ,
                      OverrideChargeAmount ,
                      ChargeAmountOverrideBy
			        )
                    SELECT  S.ServiceId ,
                            C.ClientId ,
                            CASE     -- modify by Basudev  for  network 180 task #609
								WHEN ISNULL(C.ClientType, 'I') = 'I'
								THEN ISNULL(C.LastName, '') + ' ' + ISNULL(C.FirstName, '')
								ELSE ISNULL(C.OrganizationName, '')
								END AS ClientName,
                            --C.LastName + ', ' + C.FirstName AS ClientName ,
                            S.ClinicianId ,
                            S.ProcedureCodeId ,
                            RequiresTimeInTimeOut ,
                            S.LocationId ,
                            S.ProgramId ,
                            S.DateOfService ,
                            S.EndDateOfService ,
                            RIGHT(CONVERT(DATETIME, S.DateOfService, 100), 7) AS [Time] ,
                            RIGHT(CONVERT(DATETIME, S.EndDateOfService, 100), 7) AS [TimeOut] ,
                            Unit ,
                            S.STATUS ,
                            S.CreatedBy ,
                            S.CreatedDate ,
                            S.ModifiedBy ,
                            S.ModifiedDate ,
                            S.RecordDeleted ,
                            S.DeletedBy ,
                            S.DeletedDate
			--,'N'
                            ,
                            ( CASE WHEN ISNULL(s.ServiceId, 0) > 0 THEN 'Y'
                                   ELSE 'N'
                              END ) Checked ,
                            C.SchedulingPreferenceMonday ,
                            C.SchedulingPreferenceTuesday ,
                            C.SchedulingPreferenceWednesday ,
                            C.SchedulingPreferenceThursday ,
                            C.SchedulingPreferenceFriday ,
                            C.GeographicLocation ,
                            C.SchedulingComment ,
                            S.SpecificLocation ,
                            SUBSTRING(CASE WHEN C.SchedulingPreferenceMonday = 'Y' THEN ',M '
                                           ELSE ''
                                      END + CASE WHEN C.SchedulingPreferenceTuesday = 'Y' THEN ',TU '
                                                 ELSE ''
                                            END + CASE WHEN C.SchedulingPreferenceWednesday = 'Y' THEN ',W '
                                                       ELSE ''
                                                  END + CASE WHEN C.SchedulingPreferenceThursday = 'Y' THEN ',TH '
                                                             ELSE ''
                                                        END + CASE WHEN C.SchedulingPreferenceFriday = 'Y' THEN ',F'
                                                                   ELSE ''
                                                              END, 2, 20) ,
                            S.UnitType ,
                            S.CancelReason ,
                            S.ProviderId ,
                            S.AttendingId ,
                            S.Billable ,
                            S.ClientWasPresent ,
                            S.OtherPersonsPresent ,
                            S.AuthorizationsApproved ,
                            S.AuthorizationsNeeded ,
                            S.AuthorizationsRequested ,
                            S.NumberOfTimeRescheduled ,
                            S.NumberOfTimesCancelled ,
                            S.DoNotComplete ,
                            S.Comment ,
                            S.Flag1 ,
                            S.OverrideError ,
                            S.OverrideBy ,
                            S.ReferringId ,
                            S.DateTimeIn ,
                            S.DateTimeOut ,
                            S.NoteAuthorId ,
                            S.ModifierId1 ,
                            S.ModifierId2 ,
                            S.ModifierId3 ,
                            S.ModifierId4 ,
                            S.PlaceOfServiceId ,
                            ( SELECT    '' + PC.DisplayAs + ', ' + CONVERT(VARCHAR, CAST(S.DateOfService AS TIME), 100) + ', ' + ( CAST(CAST(S.Unit AS INT) AS VARCHAR) + ' ' + ISNULL(GCUT.CodeName, '') ) + ', ' + GC.CodeName + CASE WHEN S.Comment IS NULL THEN ''
                                                                                                                                                                                                                                        ELSE ' (' + CAST(S.Comment AS VARCHAR(MAX)) + ')'
                                                                                                                                                                                                                                   END
                            ) AS Title ,
                            ISNULL(PC.DisplayAs, 'Procedure Code') AS DisplayAs ,
                            GC.CodeName ,
                            GCUT.CodeName ,
                            D.DocumentId ,
                            S.Charge ,
                            S.ProcedureRateId ,
                            S.STATUS AS SavedServiceStatus ,
                            S.RecurringService ,
                            CASE WHEN ( S.Status = 71
                                        AND ( ISNULL(D.RecordDeleted, 'N') = 'Y'
                                              OR ISNULL(D.DocumentId, 0) = 0
                                            )
                                      ) THEN 'N'
                                 ELSE 'Y'
                            END AS DisabledRow ,
                            ISNULL(Staff.DisplayAs, 'Staff Name') AS ClinicianName ,
                            loc.LocationName ,
                            S.OverrideCharge ,
                            S.OverrideChargeAmount ,
                            S.ChargeAmountOverrideBy
                    FROM    Services S
                            INNER JOIN #TempClientPrograms AS [TCP] ON [TCP].ClientId = S.ClientId
                            INNER JOIN #TempClientPages TP ON [TCP].ClientId = tp.ClientId
                                                              AND tp.PageNumber = @PageNumber
							JOIN #TempPrograms AS tpro ON tpro.ProgramId = S.ProgramId
                            INNER JOIN Clients C ON [TCP].ClientId = C.ClientId
                            INNER JOIN ProcedureCodes PC ON PC.ProcedureCodeId = S.ProcedureCodeId
                            INNER JOIN #TempProcedureCodes PG ON PG.ProcedureCodeId = PC.ProcedureCodeId
                            LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = S.STATUS
                            LEFT JOIN GlobalCodes GCUT ON GCUT.GlobalCodeId = S.UnitType
                            LEFT JOIN Documents D ON D.ServiceId = S.ServiceId
                                                     AND ISNULL(D.RecordDeleted, 'N') <> 'Y'
                            LEFT JOIN Staff ON staff.StaffId = s.ClinicianId
                            LEFT JOIN Locations loc ON loc.LocationId = s.LocationId
                    WHERE   ISNULL(S.RecordDeleted, 'N') <> 'Y'
                            AND S.GroupServiceId IS NULL
                            AND ( @StaffId = -1
                                  OR S.ClinicianId = @StaffId
                                )
                            AND ( @IncludeShowCompleteService = 'Y'
                                  OR ( C.SchedulingPreferenceMonday = @SchedulingPreferenceMonday
                                       OR @SchedulingPreferenceMonday = 'N'
                                     )
                                )
                            AND ( @IncludeShowCompleteService = 'Y'
                                  OR ( C.SchedulingPreferenceTuesday = @SchedulingPreferenceTuesday
                                       OR @SchedulingPreferenceTuesday = 'N'
                                     )
                                )
                            AND ( @IncludeShowCompleteService = 'Y'
                                  OR ( C.SchedulingPreferenceWednesday = @SchedulingPreferenceWednesday
                                       OR @SchedulingPreferenceWednesday = 'N'
                                     )
                                )
                            AND ( @IncludeShowCompleteService = 'Y'
                                  OR ( C.SchedulingPreferenceThursday = @SchedulingPreferenceThursday
                                       OR @SchedulingPreferenceThursday = 'N'
                                     )
                                )
                            AND ( @IncludeShowCompleteService = 'Y'
                                  OR ( C.SchedulingPreferenceFriday = @SchedulingPreferenceFriday
                                       OR @SchedulingPreferenceFriday = 'N'
                                     )
                                )
                            AND ( ( @IncludeShowCompleteService = 'N'
                                    AND S.STATUS IN ( 70 )
                                  )
                                  OR ( @IncludeShowCompleteService = 'Y'
                                       AND S.STATUS IN ( 70, 71, 75 )
                                     )
                                )
                            AND CAST(CONVERT(VARCHAR(10), S.DateOfService, 101) AS DATETIME) = @DateFilter
                            AND EXISTS ( SELECT 1
                                         FROM   StaffPrograms SP
                                                LEFT JOIN Staff ON Staff.StaffId = SP.StaffId
												JOIN #TempPrograms AS tpstaffpro ON tpstaffpro.ProgramId = SP.ProgramId
                                         WHERE  Staff.Active = 'Y'
                                                AND ISNULL(SP.RecordDeleted, 'N') <> 'Y'
                                                AND SP.StaffId = S.ClinicianId )											

            SET IDENTITY_INSERT #TempClientServices OFF

            INSERT  INTO #TempClientServices
                    ( ClientId ,
                      ClientName ,
                      DateOfService ,
                      IsChecked ,
                      STATUS ,
                      ProgramId ,
                      SchedulingPreferenceMonday ,
                      SchedulingPreferenceTuesday ,
                      SchedulingPreferenceWednesday ,
                      SchedulingPreferenceThursday ,
                      SchedulingPreferenceFriday ,
                      GeographicLocation ,
                      SchedulingComment ,
                      Preference ,
                      StatusName ,
                      SavedServiceStatus
			        )
                    SELECT DISTINCT
                            C.ClientId ,
                            CASE     -- modify by Basudev  for  network 180 task #609
								WHEN ISNULL(C.ClientType, 'I') = 'I'
								THEN ISNULL(C.LastName, '') + ' ' + ISNULL(C.FirstName, '')
								ELSE ISNULL(C.OrganizationName, '')
								END AS ClientName,
                            --LastName + ', ' + FirstName AS ClientName ,
                            @DateFilter ,
                            'N' ,
                            71 ,
                            @ProgramId ,
                            C.SchedulingPreferenceMonday ,
                            C.SchedulingPreferenceTuesday ,
                            C.SchedulingPreferenceWednesday ,
                            C.SchedulingPreferenceThursday ,
                            C.SchedulingPreferenceFriday ,
                            C.GeographicLocation ,
                            C.SchedulingComment ,
                            SUBSTRING(CASE WHEN C.SchedulingPreferenceMonday = 'Y' THEN ',M '
                                           ELSE ''
                                      END + CASE WHEN C.SchedulingPreferenceTuesday = 'Y' THEN ',TU '
                                                 ELSE ''
                                            END + CASE WHEN C.SchedulingPreferenceWednesday = 'Y' THEN ',W '
                                                       ELSE ''
                                                  END + CASE WHEN C.SchedulingPreferenceThursday = 'Y' THEN ',TH '
                                                             ELSE ''
                                                        END + CASE WHEN C.SchedulingPreferenceFriday = 'Y' THEN ',F'
                                                                   ELSE ''
                                                              END, 2, 20) ,
                            'Show' ,
                            71
                    FROM    #TempClientPrograms [TCP]
                            INNER JOIN clients C ON [TCP].ClientId = C.ClientId
                            INNER JOIN #TempClientPages TP ON tp.ClientId = [TCP].ClientId
                                                              AND tp.PageNumber = @PageNumber
		--and  [TCP].RowNum<150
                                                              AND ( @IncludeShowCompleteService = 'Y'
                                                                    OR ( C.SchedulingPreferenceMonday = @SchedulingPreferenceMonday
                                                                         OR @SchedulingPreferenceMonday = 'N'
                                                                       )
                                                                  )
                                                              AND ( @IncludeShowCompleteService = 'Y'
                                                                    OR ( C.SchedulingPreferenceTuesday = @SchedulingPreferenceTuesday
                                                                         OR @SchedulingPreferenceTuesday = 'N'
                                                                       )
                                                                  )
                                                              AND ( @IncludeShowCompleteService = 'Y'
                                                                    OR ( C.SchedulingPreferenceWednesday = @SchedulingPreferenceWednesday
                                                                         OR @SchedulingPreferenceWednesday = 'N'
                                                                       )
                                                                  )
                                                              AND ( @IncludeShowCompleteService = 'Y'
                                                                    OR ( C.SchedulingPreferenceThursday = @SchedulingPreferenceThursday
                                                                         OR @SchedulingPreferenceThursday = 'N'
                                                                       )
                                                                  )
                                                              AND ( @IncludeShowCompleteService = 'Y'
                                                                    OR ( C.SchedulingPreferenceFriday = @SchedulingPreferenceFriday
                                                                         OR @SchedulingPreferenceFriday = 'N'
                                                                       )
                                                                  )
                                                              AND NOT EXISTS ( SELECT   ClientId
                                                                               FROM     #TempClientServices
                                                                               WHERE    ClientId = [TCP].ClientId )
															  --AND  IN  (SELECT item FROM dbo.fnSplit(@ProgramsFromOrganizations , ',')) 
      
		--GET Services and Clients Finally 
            SELECT  TCS.*
            FROM    #TempClientServices TCS
            ORDER BY ClientName

		--CustomDetailScreenConfiguration Table
            SELECT  'Y' AS ValidateAppointments ,
                    'Y' AS CalculateServiceCharge ,
                    'Y' AS ValidateServices ,
                    'Y' AS DeleteAppointments ,
                    'N' AS CheckForWarnings ,   --15/07/2017	  Sunil.D 
                    'Y' AS UseNewTransEachRow

		--ServiceErrors Table
            SELECT  [ServiceErrorId] ,
                    SE.[ServiceId] ,
                    SE.[CoveragePlanId] ,
                    SE.[ErrorType] ,
                    SE.[ErrorSeverity] ,
                    SE.[ErrorMessage] ,
                    SE.[NextStep] ,
                    SE.[RowIdentifier] ,
                    SE.[CreatedBy] ,
                    SE.[CreatedDate] ,
                    SE.[ModifiedBy] ,
                    SE.[ModifiedDate] ,
                    SE.[RecordDeleted] ,
                    SE.[DeletedDate] ,
                    SE.[DeletedBy]
		--FROM #TempClientServices TCS  INNER JOIN [ServiceErrors] SE ON  TCS.ServiceId = SE.ServiceId
            FROM    #TempClientServices TCS
                    INNER JOIN [ServiceErrors] SE ON SE.ServiceId = -1
            WHERE   ISNULL(SE.RecordDeleted, 'N') <> 'Y'
            ORDER BY SE.ServiceId

		--Appointments
            SELECT  AP.[AppointmentId] ,
                    AP.[StaffId] ,
                    AP.[Subject] ,
                    AP.[StartTime] ,
                    AP.[EndTime] ,
                    AP.[AppointmentType] ,
                    AP.[Description] ,
                    AP.[ShowTimeAs] ,
                    AP.[LocationId] ,
                    AP.[ServiceId] ,
                    AP.[GroupServiceId] ,
                    AP.[AppointmentProcedureGroupId] ,
                    AP.[RecurringAppointment] ,
                    AP.[RecurringDescription] ,
                    AP.[RecurringAppointmentId] ,
                    AP.[RecurringServiceId] ,
                    AP.[RecurringGroupServiceId] ,
                    AP.[RowIdentifier] ,
                    AP.[CreatedBy] ,
                    AP.[CreatedDate] ,
                    AP.[ModifiedBy] ,
                    AP.[ModifiedDate] ,
                    AP.[RecordDeleted] ,
                    AP.[DeletedDate] ,
                    AP.[DeletedBy] ,
                    AP.[RecurringOccurrenceIndex] ,
                    AP.[Status] ,
                    AP.[CancelReason] ,
                    AP.[ExamRoom] ,
                    AP.[ClientWasPresent] ,
                    AP.[OtherPersonsPresent] ,
                    AP.[ClientId] ,
                    AP.[SpecificLocation] ,
                    AP.[NumberofTimeRescheduled]
            FROM    [Appointments] AP
                    INNER JOIN #TempClientServices TCS ON AP.ServiceId = TCS.ServiceId

		--Documents
            SELECT  D.[DocumentId] ,
                    D.[CreatedBy] ,
                    D.[CreatedDate] ,
                    D.[ModifiedBy] ,
                    D.[ModifiedDate] ,
                    D.[RecordDeleted] ,
                    D.[DeletedDate] ,
                    D.[DeletedBy] ,
                    D.[ClientId] ,
                    D.[ServiceId] ,
                    D.[GroupServiceId] ,
                    D.[EventId] ,
                    D.[ProviderId] ,
                    D.[DocumentCodeId] ,
                    D.[EffectiveDate] ,
                    D.[DueDate] ,
                    D.[Status] ,
                    D.[AuthorId] ,
                    D.[CurrentDocumentVersionId] ,
                    D.[DocumentShared] ,
                    D.[SignedByAuthor] ,
                    D.[SignedByAll] ,
                    D.[ToSign] ,
                    D.[ProxyId] ,
                    D.[UnderReview] ,
                    D.[UnderReviewBy] ,
                    D.[RequiresAuthorAttention] ,
                    D.[InitializedXML] ,
                    D.[BedAssignmentId] ,
                    D.[ReviewerId] ,
                    D.[InProgressDocumentVersionId] ,
                    D.[CurrentVersionStatus] ,
                    D.[ClientLifeEventId] ,
                    D.[AppointmentId]
            FROM    [Documents] [D]
                    INNER JOIN #TempClientServices TCS ON [D].ServiceId = TCS.ServiceId
            WHERE   TCS.ServiceId > 0

		--DocumentVersions
            SELECT  DV.[DocumentVersionId] ,
                    DV.[CreatedBy] ,
                    DV.[CreatedDate] ,
                    DV.[ModifiedBy] ,
                    DV.[ModifiedDate] ,
                    DV.[RecordDeleted] ,
                    DV.[DeletedBy] ,
                    DV.[DeletedDate] ,
                    DV.[DocumentId] ,
                    DV.[Version] ,
                    DV.[AuthorId] ,
                    DV.[EffectiveDate] ,
                    DV.[DocumentChanges] ,
                    DV.[ReasonForChanges] ,
                    DV.[RevisionNumber] ,
                    DV.[RefreshView] ,
                    DV.[ReasonForNewVersion]
            FROM    [DocumentVersions] DV
                    INNER JOIN #TempClientServices TCS ON DV.DocumentId = TCS.DocumentId
                    INNER JOIN [Documents] [D] ON D.InProgressDocumentVersionId = DV.DocumentversionId
            WHERE   TCS.ServiceId > 0

		--DocumentSignatures
            SELECT  DS.[SignatureId] ,
                    DS.[CreatedBy] ,
                    DS.[CreatedDate] ,
                    DS.[ModifiedBy] ,
                    DS.[ModifiedDate] ,
                    DS.[RecordDeleted] ,
                    DS.[DeletedDate] ,
                    DS.[DeletedBy] ,
                    DS.[DocumentId] ,
                    DS.[SignedDocumentVersionId] ,
                    DS.[StaffId] ,
                    DS.[ClientId] ,
                    DS.[IsClient] ,
                    DS.[RelationToClient] ,
                    DS.[RelationToAuthor] ,
                    DS.[SignerName] ,
                    DS.[SignatureOrder] ,
                    DS.[SignatureDate] ,
                    DS.[VerificationMode] ,
                    DS.[PhysicalSignature] ,
                    DS.[DeclinedSignature] ,
                    DS.[ClientSignedPaper] ,
                    DS.[RevisionNumber]
            FROM    [DocumentSignatures] DS
                    INNER JOIN #TempClientServices TCS ON DS.DocumentId = TCS.DocumentId
            WHERE   TCS.ServiceId > 0
	
	
            SELECT  cp.PageNumber ,
                    cp.RowNum ,
                    cp.ClientId ,
                    cp.ClientName ,
                    @NumberOfClients AS NumberOfClients
            FROM    #TempClientPages cp
            
            Drop TABLE #TempClientPrograms
            Drop TABLE #TempProcedureCodes
            Drop TABLE #TempClientServices
            Drop TABLE #TempClientPages
              
        END TRY

        BEGIN CATCH
            DECLARE @Error VARCHAR(8000)

            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetPartialIOPData') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

            RAISERROR (
				@Error
				,-- Message text.         
				16
				,-- Severity.         
				1 -- State.                                                           
				);
        END CATCH
    END
GO

