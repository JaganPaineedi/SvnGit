/****** Object:  StoredProcedure [dbo].[ssp_SCListPageBedAttendance]    Script Date: 04/11/2014 18:34:23 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCListPageBedAttendance]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCListPageBedAttendance]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCListPageBedAttendance]    Script Date: 04/11/2014 18:34:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCListPageBedAttendance] @SessionId VARCHAR(30)
	,@InstanceId INT
	,@PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@ClientId INT
	,@Status INT
	,@ProgramId INT
	,@UnitId INT
	,@RoomId INT
	,@BedId INT
	,@AttendanceDate DATETIME
	,@OtherFilter INT
	/********************************************************************************                                                                                
-- Stored Procedure: dbo.ssp_SCListPageBedAttendance                                                                                 
--                                                                                
-- Copyright: Streamline Healthcate Solutions                                                                                
--                                                                                
-- Purpose: used by Bed Census Attendance list page                                                                                
--                                                                                
-- Updates:                                                                                                                                       
-- Date				Author				Purpose                                                                                
-- 01.18.2012		Wasif Butt          BedCensus Listpage data.
-- 03.09.2012		Wasif Butt			Issue related to duplicate row number generated causing a system error
-- 08.JUL.2012		MSuma				Removed ListPageTable using CTE
-- 2012-09-21		Chuck Blaine		Added select for Life Events
-- 07-Jan-2014      Akwinass            Filter the Query based on ResidentialProgram and Inluded Procedure Codes
-- 16-Jan-2014      Akwinass            Modified Query to Show Scheduled Discharge(not yet discharged still in bed) Bed on Attendance List
-- 14-Mar-2014      Akwinass            Included record deleted condition for BedAvailabilityHistory.
-- 11-04-2014       Akwinass            Program Code pulled instead program Name for task #979 in philhaven customization issues.
-- 11-July-2014     Akwinass            'AttendanceDate' Column Included for task #1537 in Core Bugs.
-- 16-July-2015     Akwinass            @ProgramId Default Condition and ShowOnBedCensus Condition Included (Task #21 in New Directions - Support Go Live).
-- 28-July-2015     Varun               Added conditions to compare  @AttendanceDate with BedAttendances.AttendanceDate (CHC Support Go Live - #11)
-- 21 Oct 2015      Revathi				what:Changed code to display Clients LastName and FirstName when ClientType='I' else  OrganizationName.  /   
--										why:task #609, Network180 Customization  /
-- 01.06.2016		Wasif				Added record delete check when selecting latest bed assignment in RankResults.
-- 28-Jan-2016      Akwinass            Time field is managed based on Bed Availability History task #372 in Philhaven Development
-- 10/05/2017       Hemant              What:Included the servicestatus field to disable the row.
                                        Why:Do not allow the user to modify the Attendance Record if there is already an Attendance Record 
                                        in the system and there is a Service ID associated to the attendance record and the Service ID's status 
                                        is anything BUT Error.
                                        Project:Woods - Support Go Live #732
*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		-- 16-July-2015     Akwinass
		IF @ProgramId <= 0
			SET @ProgramId = - 1

		DECLARE @ResultSetTemp TABLE (
			RowNumber INT
			,PageNumber INT
			,ClientName VARCHAR(50)
			,[Status] VARCHAR(100) NULL
			,ActivityStatusId INT NULL
			,AdmitDate VARCHAR(20)
			,DischargedDate VARCHAR(20)
			,RequestedDate DATETIME NULL
			,ScheduledDate DATETIME NULL
			,BedName VARCHAR(50)
			,
			--  Comment Varchar(max),                                          
			ClientId INT
			,FUnitId INT
			,FRoomId INT
			,EBedId INT
			,StartDate DATETIME NULL
			,EndDate DATETIME NULL
			,BStatus INT NULL
			,BDisposition INT NULL
			,DClientInPatientVisitId INT NULL
			,BedAssignmentId INT NULL
			,BedAttendanceId INT NULL
			,Present CHAR(1)
			,BedLeaveReasonId INT
			,
			-- 11-July-2014     Akwinass
			AttendanceDate DATETIME NULL
			,Processed VARCHAR(12)
			,ServiceId INT
			,ProgramName VARCHAR(100)
			,
			--  ProgramCode Varchar(100),                                      
			ProgramId INT
			,Exclamation VARCHAR(100)
			,BedDisplayAs VARCHAR(100)
			,UnitDisplayAS VARCHAR(100)
			,RoomDisplayAs VARCHAR(100)
			,ProcedureCodeId INT
			,ProcedureCodeName VARCHAR(100)
			,NextBAId INT
			,NextBAStatus INT
			,PreviousBAStatus INT
			)
		--  ,LocationId int                                        
		DECLARE @ResultSet TABLE (
			RowNumber INT
			,PageNumber INT
			,ClientName VARCHAR(50)
			,[Status] VARCHAR(100) NULL
			,ActivityStatusId INT NULL
			,AdmitDate VARCHAR(20)
			,DischargedDate VARCHAR(20)
			,RequestedDate DATETIME NULL
			,ScheduledDate DATETIME NULL
			,BedName VARCHAR(50)
			,
			--Comment Varchar(max),                                          
			ClientId INT
			,FUnitId INT
			,FRoomId INT
			,EBedId INT
			,StartDate DATETIME NULL
			,EndDate DATETIME NULL
			,BStatus INT NULL
			,BDisposition INT NULL
			,DClientInPatientVisitId INT NULL
			,BedAssignmentId INT NULL
			,BedAttendanceId INT NULL
			,Present CHAR(1)
			,BedLeaveReasonId INT
			,
			-- 11-July-2014     Akwinass
			AttendanceDate DATETIME NULL
			,Processed VARCHAR(12)
			,ServiceId INT
			,ProgramName VARCHAR(100)
			,
			--ProgramCode Varchar(100),                                      
			ProgramId INT
			,Exclamation VARCHAR(100)
			,BedDisplayAs VARCHAR(100)
			,UnitDisplayAS VARCHAR(100)
			,RoomDisplayAs VARCHAR(100)
			,ProcedureCodeId INT
			,ProcedureCodeName VARCHAR(100)
			,NextBAId INT
			,NextBAStatus INT
			,PreviousBAStatus INT
			)
		--,LocationId int                                           
		DECLARE @CustomFilters TABLE (
			BedAssignmentId INT
			,BedId INT
			)
		DECLARE @CustomFiltersApplied CHAR(1)
		DECLARE @Today DATETIME
		DECLARE @ApplyFilterClicked CHAR(1)
		DECLARE @bedAssignmentId INT

		SET @SortExpression = RTRIM(LTRIM(@SortExpression))
		SET @bedAssignmentId = - 1000

		IF ISNULL(@SortExpression, '') = ''
			SET @SortExpression = 'ClientName desc'
		SET @ApplyFilterClicked = 'Y'
		SET @CustomFiltersApplied = 'N'
		SET @Today = GETDATE()

		-- Get custom filters                                     
		IF @OtherFilter > 10000
		BEGIN
			SET @CustomFiltersApplied = 'Y'

			INSERT INTO @CustomFilters (
				BedAssignmentId
				,BedId
				)
			EXEC scsp_SCListPageBedCensus @ClientId
				,@Status
				,@ProgramId
				,@UnitId
				,@RoomId
				,@BedId
				,@AttendanceDate
				,@OtherFilter
		END
				-- Bed Assignments  
				;

		WITH BedAssignmentSResults
		AS (
			SELECT ba.BedAssignmentId
				,ba.BedId
			FROM BedAssignments ba
			INNER JOIN Beds BS ON (ba.BedId = BS.BedId)
			INNER JOIN Rooms RS ON (BS.RoomId = RS.RoomId)
			INNER JOIN BedAvailabilityHistory BAH ON (ba.BedId = bah.BedId)
			-- 07-Jan-2014       Akwinass            Filter the Query based on ResidentialProgram
			INNER JOIN Programs PR ON (
					ba.ProgramId = PR.ProgramId
					AND PR.ResidentialProgram = 'Y'
					)
			WHERE (
					@CustomFiltersApplied = 'Y'
					AND EXISTS (
						SELECT *
						FROM @CustomFilters cf
						WHERE cf.BedAssignmentId = ba.BedAssignmentId
						)
					)
				OR (
					@CustomFiltersApplied = 'N'
					AND (
						@Status = 0 -- All  
						OR (
							@Status = 1
							AND BA.STATUS = 5002
							) -- Occupied  
						OR (
							@Status = 2
							AND BA.STATUS IN (
								5001
								,5003
								,5004
								,5005
								,5007
								)
							) -- Scheduled  
						OR (
							@Status = 3
							AND BA.STATUS = 5006
							) -- On Leave  
						)
					AND (
						BAH.ProgramId = @ProgramId
						OR @ProgramId = - 1
						)
					AND (
						RS.UnitID = @UnitId
						OR @UnitId = 0
						)
					AND (
						RS.RoomId = @RoomId
						OR @RoomId = 0
						)
					AND (
						BS.BedId = @BedId
						OR @BedId = 0
						)
					AND ISNULL(ba.RecordDeleted, 'N') = 'N'
					AND CAST(ba.StartDate AS DATE) <= CAST(@AttendanceDate AS DATE)
					AND ISNULL(BAH.RecordDeleted, 'N') = 'N'
					AND ba.STATUS IN (
						5002
						,5006
						) -- Occupied or On Leave
					AND (
						-- Bed Assignments that are current  
						(
							(
								ba.EndDate IS NULL
								OR CAST(ba.EndDate AS DATE) > CAST(@AttendanceDate AS DATE)
								)
							)
						OR
						-- Bed Assignments with dispositions due on the date  
						(
							CAST(ba.EndDate AS DATE) = CAST(@AttendanceDate AS DATE)
							AND ba.Disposition IS NOT NULL
							)
						OR
						-- Bed Assignments where disposition is overdue and end date was up to 90 days old  
						(
							CAST(ba.EndDate AS DATE) >= DATEADD(dd, - 90, CAST(@AttendanceDate AS DATE))
							AND ba.Disposition IS NULL
							)
						)
					AND CAST(bah.StartDate as Date) <= CAST(@AttendanceDate as Date)
					AND (CAST(bah.EndDate as Date) >= CAST(@AttendanceDate as Date) OR bah.EndDate IS NULL)
					)
			
			UNION ALL
			
			-- Logic for Open Beds  
			SELECT NULL
				,BS.BedId
			FROM Units AS US
			INNER JOIN UnitAvailabilityHistory UAH ON UAH.UnitId = US.UnitId
				AND ISNULL(UAH.RecordDeleted, 'N') = 'N'
			INNER JOIN Rooms AS RS ON US.UnitId = RS.UnitId
				AND (
					ISNULL(RS.RecordDeleted, 'N') = 'N'
					AND ISNULL(RS.Active, 'Y') = 'Y'
					)
				AND (
					ISNULL(US.RecordDeleted, 'N') = 'N'
					AND ISNULL(US.Active, 'Y') = 'Y'
					-- 16-July-2015     Akwinass
					--   Added ShowOnBedCensus conditions in filter Philhaven Development #248
					AND ISNULL(US.ShowOnBedCensus, 'N') = 'Y'
					)
			INNER JOIN RoomAvailabilityHistory RAH ON RAH.RoomId = RS.RoomId
				AND ISNULL(RAH.RecordDeleted, 'N') = 'N'
			INNER JOIN Beds AS BS ON RS.RoomId = BS.RoomId
				AND (
					ISNULL(BS.RecordDeleted, 'N') = 'N'
					AND ISNULL(BS.Active, 'Y') = 'Y'
					)
			INNER JOIN BedAvailabilityHistory AS BAH ON BS.BedId = BAH.BedId
				AND ISNULL(BS.RecordDeleted, 'N') = 'N'
				AND ISNULL(BAH.RecordDeleted, 'N') = 'N'
				AND BAH.EndDate IS NULL
			-- 07-Jan-2014       Akwinass            Filter the Query based on ResidentialProgram
			INNER JOIN Programs AS PS ON (
					BAH.ProgramId = PS.ProgramId
					AND PS.ResidentialProgram = 'Y'
					)
				AND (
					ISNULL(PS.RecordDeleted, 'N') = 'N'
					AND ISNULL(PS.Active, 'Y') = 'Y'
					)
			WHERE (
					@CustomFiltersApplied = 'Y'
					AND EXISTS (
						SELECT *
						FROM @CustomFilters cf
						WHERE cf.BedId = BS.BedId
						)
					)
				OR (
					@CustomFiltersApplied = 'N'
					AND @Status IN (
						0
						,4
						) -- All or Open  
					AND (
						BAH.ProgramId = @ProgramId
						OR @ProgramId = - 1
						)
					AND (
						RS.UnitID = @UnitId
						OR @UnitId = 0
						)
					AND (
						RS.RoomId = @RoomId
						OR @RoomId = 0
						)
					AND (
						BS.BedId = @BedId
						OR @BedId = 0
						)
					AND bah.StartDate <= @AttendanceDate
					AND (bah.EndDate >= @AttendanceDate OR bah.EndDate IS NULL)
					AND rah.StartDate <= CAST(@AttendanceDate AS DATE)
					AND (
						rah.EndDate >= CAST(@AttendanceDate AS DATE)
						OR rah.EndDate IS NULL
						)
					AND uah.StartDate <= CAST(@AttendanceDate AS DATE)
					AND (
						uah.EndDate >= CAST(@AttendanceDate AS DATE)
						OR uah.EndDate IS NULL
						)
					AND NOT EXISTS (
						SELECT *
						FROM BedAssignments ba
						INNER JOIN Beds b2 ON (ba.BedId = b2.BedId)
						INNER JOIN Rooms r2 ON (b2.RoomId = r2.RoomId)
						WHERE b2.BedId = BS.BedId
							AND b2.RoomId = BS.RoomId
							AND R2.UnitId = US.UnitId
							AND ISNULL(ba.RecordDeleted, 'N') = 'N'
							AND (
								ba.EndDate IS NULL
								OR CAST(ba.EndDate AS DATE) > CAST(@AttendanceDate AS DATE)
								OR (
									CAST(ba.EndDate AS DATE) = CAST(@AttendanceDate AS DATE)
									AND Disposition IS NULL
									)
								OR CAST(ba.EndDate AS DATE) > CAST(@AttendanceDate AS DATE)
								)
							AND CAST(ba.StartDate AS DATE) <= CAST(@AttendanceDate AS DATE)
							AND ba.STATUS IN (
								5002
								,5006
								) -- Occupied or On Leave
						)
					)
			)
			,RankResults
		AS (
			SELECT
				--Added by Revathi 21 Oct 2015
				CASE 
					WHEN ISNULL(C.ClientType, 'I') = 'I'
						THEN C.LastName + ', ' + C.FirstName
					ELSE ISNULL(C.OrganizationName, '')
					END AS ClientName
				,CASE 
					WHEN CF.BedAssignmentId IS NULL
						THEN 'Open'
					WHEN BA.EndDate IS NULL
						OR CAST(BA.EndDate AS DATE) > CAST(@AttendanceDate AS DATE)
						THEN GC.CodeName
					WHEN CAST(BA.EndDate AS DATE) = CAST(@AttendanceDate AS DATE)
						AND BA.Disposition IS NOT NULL
						THEN GC2.CodeName
					WHEN CAST(BA.EndDate AS DATE) <= CAST(@AttendanceDate AS DATE)
						AND BA.Disposition IS NULL
						AND BA.NextBedAssignmentId IS NOT NULL
						THEN GC.CodeName
					WHEN CAST(BA.EndDate AS DATE) <= CAST(@AttendanceDate AS DATE)
						AND BA.Disposition IS NULL
						AND BA.NextBedAssignmentId IS NULL
						THEN 'Scheduled Discharge'
					END AS [Status]
				,BA.[Status] AS ActivityStatusId
				,CONVERT(NVARCHAR(50), CIV.AdmitDate, 101) AS AdmitDate
				,CIV.DischargedDate
				,CIV.RequestedDate
				,CIV.ScheduledDate
				,ISNULL(B.BedName, '') + ISNULL(' (' + PR.ProgramCode + ')', '') AS BedName
				,
				--,BA.Comment  
				CIV.ClientId
				,R.UnitId AS FUnitId
				,R.RoomId AS FRoomId
				,B.BedId AS EBedId
				,BA.StartDate
				,BA.EndDate
				,BA.STATUS AS BStatus
				,BA.Disposition AS BDisposition
				,CIV.ClientInpatientVisitId AS DClientInpatientVisitId
				,BA.BedAssignmentId
				,CASE 
					WHEN CAST(BATT.AttendanceDate AS DATE) <> CAST(@AttendanceDate AS DATE)
						THEN NULL
					ELSE BATT.BedAttendanceId
					END AS [BedAttendanceId]
				,CASE 
					WHEN CAST(BATT.AttendanceDate AS DATE) <> CAST(@AttendanceDate AS DATE)
						THEN NULL
					ELSE BATT.Present
					END AS [Present]
				,CASE 
					WHEN CAST(BATT.AttendanceDate AS DATE) <> CAST(@AttendanceDate AS DATE)
						THEN NULL
					ELSE BATT.BedLeaveReasonId
					END AS [BedLeaveReasonId]
				,
				-- 11-July-2014     Akwinass
				CASE 
					WHEN CAST(BATT.AttendanceDate AS DATE) <> CAST(@AttendanceDate AS DATE)
						THEN @AttendanceDate
					ELSE BATT.AttendanceDate
					END AS [AttendanceDate]
				,GC3.SubCodeName AS BedLeaveReasonName
				,CASE 
					WHEN CAST(BATT.AttendanceDate AS DATE) <> CAST(@AttendanceDate AS DATE)
						THEN NULL
					ELSE BATT.Processed
					END AS [Processed]
				,CASE 
					WHEN CAST(BATT.AttendanceDate AS DATE) <> CAST(@AttendanceDate AS DATE)
						THEN NULL
					ELSE BATT.ServiceId
					END AS [ServiceId]
				,PR.ProgramName
				,
				--,PS.ProgramCode  
				PR.ProgramId
				,CASE 
					WHEN CAST(BA.EndDate AS DATE) < CAST(@Today AS DATE)
						AND BA.Disposition IS NULL
						THEN 'Past Due'
					ELSE 'False'
					END AS Exclamation
				,B.DisplayAs AS BedDisplayAs
				,U.DisplayAs AS UnitDisplayAS
				,R.DisplayAs AS RoomDisplayAs
				,BA.ProcedureCodeId AS ProcedureCodeId
				,PC.DisplayAs AS ProcedureCodeName
				,
				--,BAH.LocationId as LocationId                                      
				BA.NextBedAssignmentId AS NextBAId
				,BA_Next.STATUS AS NextBAStatus
				,BA_Prev.STATUS AS PreviousBAStatus
				,ddo.DropdownOptions AS DropdownOptions
			FROM BedAssignmentsResults CF
			INNER JOIN Beds B ON (CF.BedId = B.BedId)
			INNER JOIN Rooms R ON (B.RoomId = R.RoomId)
			INNER JOIN Units U ON (R.UnitId = U.UnitId)
			LEFT JOIN BedAssignments BA ON (BA.BedAssignmentId = CF.BedAssignmentId)
			LEFT JOIN BedAttendances BATT ON BA.BedAssignmentId = BATT.BedAssignmentId
				AND (ISNULL(BATT.RecordDeleted, 'N') = 'N')
				AND CAST(BATT.AttendanceDate AS DATE) = CAST(@AttendanceDate AS DATE)
			LEFT JOIN ClientInpatientVisits CIV ON (BA.ClientInpatientVisitId = CIV.ClientInpatientVisitId)
			LEFT JOIN BedAvailabilityHistory BAH ON (
					B.BedId = bah.BedId
					AND ISNULL(bah.RecordDeleted, 'N') = 'N'
					AND (bah.EndDate IS NULL OR (bah.EndDate > GETDATE() AND CF.BedAssignmentId IS NOT NULL))
					)
			LEFT JOIN Programs PR ON (BAH.ProgramId = PR.ProgramId)
			LEFT JOIN Clients C ON (CIV.ClientId = C.ClientId)
			LEFT JOIN BedAssignments BA_Next ON (
					BA.NextBedAssignmentId = BA_Next.BedAssignmentId
					AND ISNULL(BA_Next.RecordDeleted, 'N') = 'N'
					)
			LEFT JOIN BedAssignments BA_Prev ON (
					BA.BedAssignmentId = BA_Prev.NextBedAssignmentId
					AND ISNULL(BA_Prev.RecordDeleted, 'N') = 'N'
					)
			LEFT JOIN GlobalCodes GC ON (BA.STATUS = GC.GlobalCodeId)
			LEFT JOIN GlobalCodes GC2 ON (BA.Disposition = GC2.GlobalCodeId)
			LEFT JOIN GlobalSubCodes GC3 ON (BATT.BedLeaveReasonId = GC3.GlobalSubCodeId)
			LEFT JOIN ProcedureCodes PC ON (BA.ProcedureCodeId = PC.ProcedureCodeId)
			LEFT JOIN BedCensusStatusChangeDropdowns ddo ON (
					ISNULL(BA.STATUS, 1) = ISNULL(ddo.BedAssignmentStatus, 1)
					AND (
						ddo.PreviousAssignmentOccupied IS NULL
						OR (
							ddo.PreviousAssignmentOccupied = 'Y'
							AND BA_Prev.STATUS = 5002
							)
						OR (
							ddo.PreviousAssignmentOccupied = 'N'
							AND BA_Prev.STATUS <> 5002
							)
						)
					AND (
						ddo.PreviousAssignmentOnLeave IS NULL
						OR (
							ddo.PreviousAssignmentOnLeave = 'Y'
							AND BA_Prev.STATUS = 5006
							)
						OR (
							ddo.PreviousAssignmentOnLeave = 'N'
							AND BA_Prev.STATUS <> 5006
							)
						)
					AND (
						ddo.PreviousAssignmentScheduledOnLeave IS NULL
						OR (
							ddo.PreviousAssignmentScheduledOnLeave = 'Y'
							AND BA_Prev.STATUS = 5005
							)
						OR (
							ddo.PreviousAssignmentScheduledOnLeave = 'N'
							AND BA_Prev.STATUS <> 5005
							)
						)
					AND (
						ddo.DispositionIsNull IS NULL
						OR (
							ddo.DispositionIsNull = 'Y'
							AND BA.Disposition IS NULL
							)
						OR (
							ddo.DispositionIsNull = 'N'
							AND BA.Disposition IS NOT NULL
							)
						)
					AND (
						ddo.NextAssignmentIsNull IS NULL
						OR (
							ddo.NextAssignmentIsNull = 'Y'
							AND BA.NextBedAssignmentId IS NULL
							)
						OR (
							ddo.NextAssignmentIsNull = 'N'
							AND BA.NextBedAssignmentId IS NOT NULL
							)
						)
					)
			WHERE BA.BedAssignmentId IS NULL
				OR (
					BA.BedAssignmentId = (
						SELECT TOP 1 BedAssignmentId
						FROM dbo.BedAssignments
						WHERE ClientInpatientVisitId = BA.ClientInpatientVisitId
							AND CAST(StartDate AS DATE) <= CAST(@AttendanceDate AS DATE)
    						and isnull(RecordDeleted, 'N') = 'N'
						ORDER BY 1 DESC
						)
					)
				--WHERE  BA.StartDate IS NOT NULL
			)
			,counts
		AS (
			SELECT COUNT(*) AS totalrows
			FROM RankResults
			)
			,FinalResults
		AS (
			SELECT ClientName
				,[Status]
				,ActivityStatusId
				,AdmitDate
				,DischargedDate
				,RequestedDate
				,ScheduledDate
				,BedName
				,ClientId
				,FUnitId
				,FRoomId
				,EBedId
				,StartDate
				,EndDate
				,BStatus
				,BDisposition
				,DClientInPatientVisitId
				,BedAssignmentId
				,BedAttendanceId
				,Present
				,BedLeaveReasonId
				,
				-- 11-July-2014     Akwinass
				AttendanceDate
				,BedLeaveReasonName
				,Processed
				,ServiceId
				,ProgramName
				,ProgramId
				,Exclamation
				,BedDisplayAs
				,UnitDisplayAS
				,RoomDisplayAs
				,ProcedureCodeId
				,ProcedureCodeName
				,NextBAId
				,NextBAStatus
				,PreviousBAStatus
				,DropdownOptions
				,COUNT(*) OVER () AS TotalCount
				,RANK() OVER (
					ORDER BY CASE 
							WHEN @SortExpression = 'ClientName'
								THEN ClientName
							END
						,CASE 
							WHEN @SortExpression = 'Status'
								THEN [Status]
							END
						,CASE 
							WHEN @SortExpression = 'ClientName desc'
								THEN ClientName
							END DESC
						,CASE 
							WHEN @SortExpression = 'Status desc'
								THEN [Status]
							END DESC
						,CASE 
							WHEN @SortExpression = 'AdmitDate'
								THEN AdmitDate
							END
						,CASE 
							WHEN @SortExpression = 'AdmitDate desc'
								THEN AdmitDate
							END DESC
						,CASE 
							WHEN @SortExpression = 'DischargedDate'
								THEN DischargedDate
							END
						,CASE 
							WHEN @SortExpression = 'DischargedDate desc'
								THEN DischargedDate
							END DESC
						,CASE 
							WHEN @SortExpression = 'BedName'
								THEN BedName
							END
						,CASE 
							WHEN @SortExpression = 'BedName desc'
								THEN BedName
							END DESC
						,CASE 
							WHEN @SortExpression = 'Proc'
								THEN ProcedureCodeName
							END
						,CASE 
							WHEN @SortExpression = 'Proc desc'
								THEN ProcedureCodeName
							END DESC
						,CASE 
							WHEN @SortExpression = 'LeaveReason'
								THEN BedLeaveReasonName
							END
						,CASE 
							WHEN @SortExpression = 'LeaveReason desc'
								THEN BedLeaveReasonName
							END DESC
						,CASE 
							WHEN @SortExpression = 'Processed'
								THEN Processed
							END
						,CASE 
							WHEN @SortExpression = 'Processed desc'
								THEN Processed
							END DESC
						,CASE 
							WHEN @SortExpression = 'Present'
								THEN Present
							END
						,CASE 
							WHEN @SortExpression = 'Present desc'
								THEN Present
							END DESC
						,CASE 
							WHEN @SortExpression = 'AttendanceDate'
								THEN AttendanceDate
							END
						,CASE 
							WHEN @SortExpression = 'AttendanceDate desc'
								THEN AttendanceDate
							END DESC
						,CASE 
							WHEN @SortExpression = 'ProgramName'
								THEN ProgramName
							END
						,CASE 
							WHEN @SortExpression = 'ProgramName desc'
								THEN ProgramName
							END DESC
						,ISNULL(BedAssignmentId, EBedId) ) AS RowNumber  
			FROM RankResults
			)
		SELECT TOP (
				CASE 
					WHEN (@PageNumber = - 1)
						THEN (
								SELECT ISNULL(totalrows, 0)
								FROM counts
								)
					ELSE (@PageSize)
					END
				) ClientName
			,[Status]
			,ActivityStatusId
			,AdmitDate
			,DischargedDate
			,RequestedDate
			,ScheduledDate
			,BedName
			,ClientId
			,FUnitId
			,FRoomId
			,EBedId
			,StartDate
			,EndDate
			,BStatus
			,BDisposition
			,DClientInPatientVisitId
			,BedAssignmentId
			,BedAttendanceId
			,Present
			,BedLeaveReasonId
			,
			-- 11-July-2014     Akwinass
			AttendanceDate
			,BedLeaveReasonName
			,Processed
			,ServiceId
			,ProgramName
			,ProgramId
			,Exclamation
			,BedDisplayAs
			,UnitDisplayAS
			,RoomDisplayAs
			,ProcedureCodeId
			,ProcedureCodeName
			,NextBAId
			,NextBAStatus
			,PreviousBAStatus
			,DropdownOptions
			,TotalCount
			,RowNumber
		--NextBedAssignmentStatus,
		INTO #FinalResultSet
		FROM FinalResults
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize)

		IF (
				SELECT ISNULL(COUNT(*), 0)
				FROM #FinalResultSet
				) < 1
		BEGIN
			SELECT 0 AS PageNumber
				,0 AS NumberOfPages
				,0 NumberOfRows
		END
		ELSE
		BEGIN
			SELECT TOP 1 @PageNumber AS PageNumber
				,CASE (TotalCount % @PageSize)
					WHEN 0
						THEN ISNULL((TotalCount / @PageSize), 0)
					ELSE ISNULL((TotalCount / @PageSize), 0) + 1
					END AS NumberOfPages
				,ISNULL(TotalCount, 0) AS NumberOfRows
			FROM #FinalResultSet
		END

		SELECT ClientName
			,frs.[Status]
			,ActivityStatusId
			,AdmitDate
			,DischargedDate
			,RequestedDate
			,ScheduledDate
			,BedName
			,ClientId
			,FUnitId
			,FRoomId
			,EBedId
			,ISNULL(frs.StartDate, @AttendanceDate) AS StartDate
			,frs.EndDate
			,BStatus
			,BDisposition
			,DClientInPatientVisitId
			,frs.BedAssignmentId
			,BedAttendanceId
			,Present
			,BedLeaveReasonId
			,
			-- 11-July-2014     Akwinass
			AttendanceDate
			,BedLeaveReasonName
			,Processed
			,ServiceId
			,ProgramName
			,frs.ProgramId
			,Exclamation
			,BedDisplayAs
			,UnitDisplayAS
			,RoomDisplayAs
			,frs.ProcedureCodeId
			,frs.ProcedureCodeName
			,NextBAId
			,NextBAStatus
			,gc.CodeName + ' - ' + CONVERT(VARCHAR(50), bedas.StartDate) AS NextBAStatusDisplayAs
			,PreviousBAStatus
			,DropdownOptions
			,NEWID() AS UniqueRowIdentity
			,(
				SELECT dbo.GetNoteTypeByClientId(ClientId)
				) AS TypeId
			,(
				SELECT dbo.SCGetServiceStatus(ServiceId)
				) AS ServiceStatus    --Hemant 10/05/2017
		FROM #FinalResultSet frs
		LEFT JOIN dbo.GlobalCodes gc ON frs.NextBAStatus = gc.GlobalCodeId
		LEFT JOIN dbo.BedAssignments bedas ON bedas.BedAssignmentId = frs.NextBAId
		ORDER BY RowNumber

		-- Life Events            
		SELECT CLE.ClientId
			,CLE.BeginDate
			,CLE.EndDate
			,LE.LifeEventName
			,LE.BeginDateLabel
			,LE.EndDateLabel
		FROM dbo.ClientLifeEvents CLE
		INNER JOIN dbo.LifeEvents LE ON (
				LE.LifeEventId = CLE.LifeEventId
				AND ISNULL(LE.RecordDeleted, 'N') = 'N'
				AND ISNULL(CLE.RecordDeleted, 'N') = 'N'
				AND LE.Active = 'Y'
				)
		INNER JOIN #FinalResultSet FRS ON FRS.ClientId = CLE.ClientId
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCListPageBedAttendance') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	END CATCH

	RETURN
END
GO

