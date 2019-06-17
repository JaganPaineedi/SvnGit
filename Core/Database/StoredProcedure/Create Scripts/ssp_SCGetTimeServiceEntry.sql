IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetTimeServiceEntry]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetTimeServiceEntry]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetTimeServiceEntry] @ProgramId INT
	,@StartDate DATETIME
	,@EndDate DATETIME
	,@StaffId INT
	,@EnteredStaffId INT
	,@TimeServiceEntry CHAR(1)
	,@ClientId int
AS
/**************************************************************/
/* Stored Procedure: [ssp_SCGetTimeServiceEntry]   */
/* Creation Date:  03 -18 -2015                              */
/* Purpose: To Get Services Data   for Time Entry Screen */
/* Called By: Time Entry Screen screen     */
/* Updates:                                                   */
/* Date   Author   Purpose         */
/* 03 -18 -2015  Dhanil Manuel	Created		To get Time Service Entry Data  For ARC Customization Task #1 */
/* 06 -22 -2015  Basudev Sahu	Modified	To get Time Service Entry Data based on UserCode For ARC Customization Task #1.2 */
/* 07-July-2015   Hemant        Modified    Added OverrideCharge,OverrideChargeAmount,ChargeAmountOverrideBy in services table Why:Charge Override on the Service Detail Screen #605.1 Network 180 - Customizations*/
/*************************************************************/
BEGIN
	BEGIN TRY
		--Clients Temp Table who all are enrolled/requested/discharged after specified date for Program
	

		IF OBJECT_ID('tempdb..#TempClientServices') IS NOT NULL
			DROP TABLE #TempClientServices

		CREATE TABLE #TempClientServices (
			ServiceId [int] Identity(- 1, - 1)
			,ClientId INT
			,ClientName VARCHAR(210)
			,ClinicianId INT
			,ProcedureCodeId INT
			,RequiresTimeInTimeOut VARCHAR(1)
			,LocationId INT
			,ProgramId INT
			,DateOfService DATETIME
			,EndDateOfService DATETIME
			,[Time] DATETIME
			,[TimeOut] DATETIME
			,Unit DECIMAL(18, 2)
			,STATUS INT
			,GroupServiceId INT
			,CreatedBy VARCHAR(30)
			,CreatedDate DATETIME
			,ModifiedBy VARCHAR(30)
			,ModifiedDate DATETIME
			,RecordDeleted CHAR(1)
			,DeletedBy VARCHAR(30)
			,DeletedDate DATETIME
			,IsChecked CHAR(1)
			,GeographicLocation VARCHAR(50)
			,SchedulingComment VARCHAR(MAX)
			,SpecificLocation VARCHAR(MAX)
			,UnitType INT
			,CancelReason INT
			,ProviderId INT
			,AttendingId INT
			,Billable CHAR(1)			
			,ClientWasPresent CHAR(1)
			,OtherPersonsPresent VARCHAR(250)
			,AuthorizationsApproved INT
			,AuthorizationsNeeded INT
			,AuthorizationsRequested INT
			,NumberOfTimeRescheduled INT
			,NumberOfTimesCancelled INT
			,DoNotComplete CHAR(1)
			,Comment VARCHAR(MAX)
			,Flag1 CHAR(1)
			,OverrideError CHAR(1)
			,OverrideBy VARCHAR(30)
			,ReferringId INT
			,DateTimeIn DATETIME
			,DateTimeOut DATETIME
			,NoteAuthorId INT
			,ModifierId1 INT
			,ModifierId2 INT
			,ModifierId3 INT
			,ModifierId4 INT
			,PlaceOfServiceId INT
			,ServiceDetailTitle VARCHAR(max)
			,ProcedureCodeName VARCHAR(250)
			,StatusName VARCHAR(250)
			,UnitTypeName VARCHAR(250)
			,DocumentId INT
			,Charge MONEY
			,ProcedureRateId INT
			,SavedServiceStatus INT
			,RecurringService CHAR(1)
			,DisabledRow CHAR(1)
			,ProgramName VARCHAR(max)
			,ContractRate MONEY
			,AuthNumbers VARCHAR(max)
			,ClinicianName VARCHAR(max)
			,LocationName VARCHAR(max)
			,OverrideCharge CHAR(1)
            ,OverrideChargeAmount MONEY
            ,ChargeAmountOverrideBy VARCHAR(250)
			)
			
			--Modified on 06 -22 -2015 By Basudev Sahu
		Declare @EnteredStaffCode varchar(100); 
		Select @EnteredStaffCode = UserCode  from Staff  where StaffId = @EnteredStaffId

	

		SET IDENTITY_INSERT #TempClientServices ON

		INSERT INTO #TempClientServices (
			ServiceId
			,ClientId
			,ClientName
			,ClinicianId
			,ProcedureCodeId
			,RequiresTimeInTimeOut
			,LocationId
			,ProgramId
			,DateOfService
			,EndDateOfService
			,TIME
			,TimeOut
			,Unit
			,STATUS
			,S.CreatedBy
			,S.CreatedDate
			,S.ModifiedBy
			,S.ModifiedDate
			,S.RecordDeleted
			,S.DeletedBy
			,S.DeletedDate
			,IsChecked
			,GeographicLocation
			,SchedulingComment
			,SpecificLocation
			,UnitType
			,CancelReason
			,ProviderId
			,AttendingId
			,Billable
			,ClientWasPresent
			,OtherPersonsPresent
			,AuthorizationsApproved
			,AuthorizationsNeeded
			,AuthorizationsRequested
			,NumberOfTimeRescheduled
			,NumberOfTimesCancelled
			,DoNotComplete
			,Comment
			,Flag1
			,OverrideError
			,OverrideBy
			,ReferringId
			,DateTimeIn
			,DateTimeOut
			,NoteAuthorId
			,ModifierId1
			,ModifierId2
			,ModifierId3
			,ModifierId4
			,PlaceOfServiceId
			,ServiceDetailTitle
			,ProcedureCodeName
			,StatusName
			,UnitTypeName
			,DocumentId
			,Charge
			,ProcedureRateId
			,SavedServiceStatus
			,RecurringService
			,DisabledRow
			,ProgramName 
			,ContractRate 
			,AuthNumbers
			,ClinicianName
			,LocationName
			,OverrideCharge
            ,OverrideChargeAmount
            ,ChargeAmountOverrideBy
			)
		SELECT S.ServiceId
			,C.ClientId
			,C.LastName + ', ' + C.FirstName AS ClientName
			,S.ClinicianId
			,S.ProcedureCodeId
			,RequiresTimeInTimeOut
			,S.LocationId
			,S.ProgramId
			,S.DateOfService
			,S.EndDateOfService
			,RIGHT(CONVERT(DATETIME, S.DateOfService, 100), 7) AS [Time]
			,RIGHT(CONVERT(DATETIME, S.EndDateOfService, 100), 7) AS [TimeOut]
			,S.Unit
			,S.STATUS
			,S.CreatedBy
			,S.CreatedDate
			,S.ModifiedBy
			,S.ModifiedDate
			,S.RecordDeleted
			,S.DeletedBy
			,S.DeletedDate
			--,'N'
			,(
				CASE 
					WHEN isnull(s.ServiceId, 0) > 0
						THEN 'Y'
					ELSE 'N'
					END
				) Checked
			,C.GeographicLocation
			,C.SchedulingComment
			,S.SpecificLocation
			,S.UnitType
			,S.CancelReason
			,S.ProviderId
			,S.AttendingId
			,S.Billable
			,S.ClientWasPresent
			,S.OtherPersonsPresent
			,S.AuthorizationsApproved
			,S.AuthorizationsNeeded
			,S.AuthorizationsRequested
			,S.NumberOfTimeRescheduled
			,S.NumberOfTimesCancelled
			,S.DoNotComplete
			,S.Comment
			,S.Flag1
			,S.OverrideError
			,S.OverrideBy
			,S.ReferringId
			,S.DateTimeIn
			,S.DateTimeOut
			,S.NoteAuthorId
			,S.ModifierId1
			,S.ModifierId2
			,S.ModifierId3
			,S.ModifierId4
			,S.PlaceOfServiceId
			,(
				SELECT '' + PC.DisplayAs + ', ' + CONVERT(VARCHAR, CAST(S.DateOfService AS TIME), 100) + ', ' + (CAST(CAST(S.Unit AS INT) AS VARCHAR) + ' ' + ISNULL(GCUT.CodeName, '')) + ', ' + GC.CodeName + CASE 
						WHEN S.Comment IS NULL
							THEN ''
						ELSE ' (' + CAST(S.Comment AS VARCHAR(MAX)) + ')'
						END
				) AS Title
			,PC.DisplayAs
			,GC.CodeName
			,GCUT.CodeName
			,D.DocumentId
			,S.Charge
			,S.ProcedureRateId
			,S.STATUS AS SavedServiceStatus
			,S.RecurringService
			,(
				CASE 
					WHEN isnull(s.ServiceId, 0) > 0
						THEN 'Y'
					ELSE 'N'
					END
				) as DisabledRow
			,p.ProgramCode
			,st.Rate 
			,[dbo].[ssf_SCGetServiceAuthorizations](S.ServiceId) as AuthNumbers
			,Staff.DisplayAs as ClinicianName
			,loc.LocationName
			,s.OverrideCharge
			,s.OverrideChargeAmount
			,s.ChargeAmountOverrideBy
		FROM Services S
		INNER JOIN Clients C ON s.ClientId = C.ClientId
		INNER JOIN ProcedureCodes PC ON PC.ProcedureCodeId = S.ProcedureCodeId
		LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = S.STATUS
		LEFT JOIN GlobalCodes GCUT ON GCUT.GlobalCodeId = S.UnitType
		LEFT JOIN Documents D ON D.ServiceId = S.ServiceId
		left join Programs p on p.ProgramId = s.ProgramId 
		left join ServiceTimeEntries st on st.ServiceId = s.ServiceId 
		left join Staff on staff.StaffId = s.ClinicianId 
		left join Locations loc on loc.LocationId = s.LocationId 
		WHERE ISNULL(S.RecordDeleted, 'N') <> 'Y'
		and s.ClientId  = @ClientId
			AND (S.ProgramId = @ProgramId or @ProgramId= -1)
			AND (st.ServiceId  is not null or @TimeServiceEntry = 'N')
			AND S.GroupServiceId IS NULL
			AND (
				@StaffId = - 1
				OR S.ClinicianId = @StaffId
				)
				--Modified on 06 -22 -2015 By Basudev Sahu
			AND (
			   @EnteredStaffCode is null
			   or s.CreatedBy =@EnteredStaffCode
			)
			--AND (
			--	@TimeServiceEntry = 'N'
			--	OR (
			--		C.SchedulingPreferenceMonday = @SchedulingPreferenceMonday
			--		OR @SchedulingPreferenceMonday = 'N'
			--		)
			--	)
			
		
			AND CAST(CONVERT(VARCHAR(10), S.DateOfService, 101) AS DATETIME) >=CAST(CONVERT(VARCHAR(10),@StartDate, 101) AS DATETIME)  
			AND CAST(CONVERT(VARCHAR(10), S.DateOfService, 101) AS DATETIME) <= CAST(CONVERT(VARCHAR(10), @EndDate, 101) AS DATETIME) 
			AND EXISTS (
				SELECT 1
				FROM StaffPrograms SP
				LEFT JOIN Staff ON Staff.StaffId = SP.StaffId
				WHERE Staff.Active = 'Y'
					AND ISNULL(SP.RecordDeleted, 'N') <> 'Y'
					AND SP.StaffId = S.ClinicianId
					AND (SP.ProgramId = @ProgramId or @ProgramId= -1)
				)

		SET IDENTITY_INSERT #TempClientServices OFF

		
		--GET Services and Clients Finally 
		--if ((select COUNT(*) from  #TempClientServices)>0)
		--begin
			SELECT TCS.*
			FROM #TempClientServices TCS
			ORDER BY DateOfService
		--end
		

	
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetTimeServiceEntry') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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

