/****** Object:  StoredProcedure [dbo].[ssp_SCWebBedBoardGetAvailableBed]    Script Date: 04/25/2014 14:34:59 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebBedBoardGetAvailableBed]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCWebBedBoardGetAvailableBed]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCWebBedBoardGetAvailableBed]    Script Date: 04/25/2014 14:34:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCWebBedBoardGetAvailableBed] @ProgramId INT
	,@UnitId INT
	,@RoomId INT
	,@BedId INT
	,@FromDate DATETIME = NULL
	,@ToDate DATETIME = NULL
	,@ClientInpatientVisitId INT = NULL
	,@IsOverflow BIT = 0
	,@mode VARCHAR(20) = ''
	,@BedAssignmentId VARCHAR(max) = NULL
	,@Action VARCHAR(400) = NULL
AS /*********************************************************************************************************/
/* Creation Date:    07/21/2011																				*/
/*																											*/
/* Purpose:   Populate the Available Bed  as per criteria													*/
/*																											*/
/* Output Parameters:																						*/
/*																											*/
/* Data Modifications:																						*/
/*																											*/
/* Updates:																									*/
/*	Date			Author              Purpose																*/
/*  2012-09-27		Chuck Blaine		Changed logic to account for deprecation of BedAvailabilitySlots table	*/
/*  Nov 2nd 2012	Chuck Blaine		Added flag and logic for overflow bed assignments	                */
/*  Aug 2013        Akwinass            Copied from bedcensus and modified for Bedboard                     */
-- Septemper 2013   Akwinass            Modified for bedboard
-- 20-09-2013       Akwinass            Included time fields in bedassignments
-- 19-11-2013       Akwinass            Based on the program fillter applied
-- 06-12-2013       Akwinass            Bedassignmentid included in parameter for getting exact fillter.
-- 02-01-2014       Akwinass            Datetime to Date CAST implemented.
-- 01-April-2014    Akwinass            Datetime to Date CAST implemented.
-- 21-April-2014    Akwinass            Changed the input parameter type @BedAssignmentId int to varchar to pass more than on bed assignment id
-- 02-June-2015     Akwinass            Since we already have @mode Parameter, Removed @CalledPage(#248 in Philhaven Development )
-- 27-Jan-2016      Akwinass            Date Cast Implemented based on Program and Action task #372 in Philhaven Development
-- 21-SEP-2016		Akwinass			Included BlockBeds table to avoid pulling blocked beds (Task #630 Renaissance - Dev Items)
-- 22-Mar-2018		Kaushal Pandey		We need a validation that prevents the staff from admitting males and females to the same room.
/************************************************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @ValidateTime VARCHAR(10) = 'FALSE'
		DECLARE @ConfigurationKeys VARCHAR(3) 
		SELECT @ConfigurationKeys = Value FROM SystemConfigurationKeys WHERE [Key] = 'ValidateClientGenderOnBedAdmit'

		IF @Action = 'admit' OR @mode = 'InpatientProgram'
		BEGIN
			SET @ValidateTime = 'TRUE'
		END;

		WITH Common
		AS (
			SELECT BS.BedId
				,BS.BedName
				,BS.DisplayAs AS BedDisplayAs
				,BAH.StartDate AS StartDate
				,BAH.EndDate AS EndDate
				,PS.ProgramCode
				,PS.ProgramId AS ProgramId
				,PS.ProgramName
				,US.UnitName
				,US.DisplayAs AS UnitDisplayAs
				,RS.RoomName
				,RS.DisplayAs AS RoomDisplayAs
				,--GlobalCodes.CodeName as [Type]    
				BAH.LocationId
				,BAH.ProcedureCodeId
				,BS.DisplayAs AS BedNameDisplayAs
				,PS.InpatientProgram
				,PS.ResidentialProgram
				,US.ShowOnBedBoard
				,US.ShowOnBedCensus
				,US.ShowOnWhiteBoard
				,(CASE WHEN upper(@ConfigurationKeys) = 'YES' THEN
					(SELECT TOP 1 CASE 
							WHEN ISNULL(C.Sex, '') = 'F'
								THEN 'Female'
							WHEN ISNULL(C.Sex, '') = 'M'
								THEN 'Male'
							ELSE ''
							END
						FROM BedAssignments BA
						JOIN ClientInpatientVisits CIV ON BA.ClientInpatientVisitId = CIV.ClientInpatientVisitId
							AND ISNULL(CIV.RecordDeleted, 'N') = 'N'
						JOIN Clients C ON CIV.ClientId = C.ClientId
						JOIN Beds TB ON TB.BedId = BA.BedId
						JOIN Rooms TR ON TB.RoomId = TR.RoomId AND TR.RoomId = RS.RoomId
						WHERE BA.[Status] = 5002
							AND ISNULL(BA.RecordDeleted, 'N') = 'N'
							AND BA.Disposition IS NULL
					) 
				 ELSE 
					''
				 END) GenderType
			FROM Units AS US
			INNER JOIN UnitAvailabilityHistory UAH ON UAH.UnitId = US.UnitId
			INNER JOIN Rooms AS RS ON US.UnitId = RS.UnitId
				AND (
					ISNULL(RS.RecordDeleted, 'N') = 'N'
					AND ISNULL(RS.Active, 'Y') = 'Y'
					)
				AND (
					ISNULL(US.RecordDeleted, 'N') = 'N'
					AND ISNULL(US.Active, 'Y') = 'Y'
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
			INNER JOIN Programs AS PS ON BAH.ProgramId = PS.ProgramId
				AND (
					ISNULL(PS.RecordDeleted, 'N') = 'N'
					AND ISNULL(PS.Active, 'Y') = 'Y'
					)
			WHERE (
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
				AND ((bah.StartDate <= @FromDate AND @ValidateTime = 'TRUE') OR ((CAST(bah.StartDate AS DATE) <= CAST(@FromDate AS DATE) AND @ValidateTime = 'FALSE')))
				AND ((bah.EndDate >= @FromDate AND @ValidateTime = 'TRUE') OR (CAST(bah.EndDate AS DATE) >= CAST(@FromDate AS DATE) AND @ValidateTime = 'FALSE') OR bah.EndDate IS NULL)
				AND rah.StartDate <= CAST(@FromDate AS DATE)
				AND (rah.EndDate >= CAST(@FromDate AS DATE) OR rah.EndDate IS NULL)
				AND uah.StartDate <= CAST(@FromDate AS DATE)
				AND (uah.EndDate >= CAST(@FromDate AS DATE) OR uah.EndDate IS NULL)
				AND ISNULL(UAH.RecordDeleted, 'N') = 'N'
				AND NOT EXISTS(SELECT 1 FROM BlockBeds BB WHERE BB.BedId = BS.BedId AND BB.StartDate <= @FromDate AND (BB.EndDate >= @FromDate OR BB.EndDate IS NULL ) AND ISNULL(BB.RecordDeleted,'N') = 'N' )
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
							OR (
								CAST(ba.EndDate AS DATE) = CAST(@FromDate AS DATE)
								AND Disposition IS NULL
								)
							OR CAST(ba.EndDate AS DATE) > CAST(@FromDate AS DATE)
							)
						AND CAST(ba.StartDate AS DATE) <= CAST(@FromDate AS DATE)
						-- If Bed Assignment is on leave or scheduled leave, check if bed is marked as hold  
						AND (
							ba.[Status] NOT IN (
								5005
								,5006
								)
							OR ba.BedNotAvailable = 'Y'
							)
					)
				OR (
					EXISTS (
						SELECT 1
						FROM BedAssignments ba
						INNER JOIN Beds b2 ON (ba.BedId = b2.BedId)
						INNER JOIN Rooms r2 ON (b2.RoomId = r2.RoomId)
						WHERE b2.BedId = BS.BedId
							AND b2.RoomId = BS.RoomId
							AND R2.UnitId = US.UnitId
							AND ISNULL(ba.RecordDeleted, 'N') = 'N'
							AND ba.BedAssignmentId IN (
								SELECT Value
								FROM dbo.fn_CommaSeparatedStringToTable(@BedAssignmentId, '')
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
										OR (
											CAST(ba.EndDate AS DATE) = CAST(@FromDate AS DATE)
											AND Disposition IS NULL
											)
										OR CAST(ba.EndDate AS DATE) > CAST(@FromDate AS DATE)
										)
									AND CAST(ba.StartDate AS DATE) <= CAST(@FromDate AS DATE)
									AND (
										ba.[Status] NOT IN (
											5005
											,5006
											)
										OR ba.BedNotAvailable = 'Y'
										)
									AND ba.ClientInpatientVisitId <> @ClientInpatientVisitId
								)
							--AND (
							--	ba.EndDate IS NULL
							--	OR (
							--		CONVERT(VARCHAR(10), ba.EndDate, 101) = CONVERT(VARCHAR(10), @FromDate, 101)
							--		AND ba.Disposition IS NOT NULL
							--		)
							--	OR ba.EndDate > @FromDate
							--	)
							--AND ba.StartDate <= @FromDate
							--AND ba.ClientInpatientVisitId = @ClientInpatientVisitId
						)
					)
			)
		SELECT DISTINCT BedId
			,BedName
			,BedDisplayAs
			,StartDate
			,EndDate
			,ProgramCode
			,ProgramId
			,ProgramName
			,UnitName
			,UnitDisplayAs
			,RoomName
			,RoomDisplayAs
			,LocationId
			,ProcedureCodeId
			,BedNameDisplayAs
			,InpatientProgram
			,ResidentialProgram
			,ShowOnBedBoard
			,ShowOnBedCensus
			,ShowOnWhiteBoard
			,GenderType 
		INTO #BedSearch
		FROM Common

		IF (@mode = 'InpatientProgram')
		BEGIN			
			SELECT BedId
				,BedName
				,BedDisplayAs
				,StartDate
				,EndDate
				,ProgramCode
				,ProgramId
				,ProgramName
				,UnitName
				,UnitDisplayAs
				,RoomName
				,RoomDisplayAs
				,LocationId
				,ProcedureCodeId
				,BedNameDisplayAs
				,GenderType 
			FROM #BedSearch
			WHERE InpatientProgram = 'Y'
				AND ISNULL(ShowOnBedBoard, 'N') = 'Y'
		END
		ELSE
		BEGIN			
			SELECT BedId
				,BedName
				,BedDisplayAs
				,StartDate
				,EndDate
				,ProgramCode
				,ProgramId
				,ProgramName
				,UnitName
				,UnitDisplayAs
				,RoomName
				,RoomDisplayAs
				,LocationId
				,ProcedureCodeId
				,BedNameDisplayAs
				,GenderType 
			FROM #BedSearch
			WHERE ResidentialProgram = 'Y'
				AND ISNULL(ShowOnBedCensus, 'N') = 'Y'			
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCWebBedBoardGetAvailableBed') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,16
				,1
				);
	END CATCH
END
GO

