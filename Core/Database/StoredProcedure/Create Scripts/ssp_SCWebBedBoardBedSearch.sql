/****** Object:  StoredProcedure [dbo].[ssp_SCWebBedBoardBedSearch]    Script Date: 04/25/2014 14:35:48 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebBedBoardBedSearch]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCWebBedBoardBedSearch]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCWebBedBoardBedSearch]    Script Date: 04/25/2014 14:35:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCWebBedBoardBedSearch] --'2010-11-03 00:00:00.000','',-1,0,0,0,0,0,0 ,null,     
	/* Param List */
	@FromDate DATETIME
	,@ToDate VARCHAR(20)
	,@ProgramId INT
	,@UnitId INT
	,@RoomId INT
	,@Type1 INT
	,@Type2 INT
	,@Type3 INT
	,@Type4 INT
	,@bedassignmentid VARCHAR(max) = NULL
	,@hideprogram VARCHAR(20)
	,@mode VARCHAR(20) = ''
	,@BedName VARCHAR(100) = ''
	,@StaffId INT=0
AS
/*********************************************************************/
/* Stored Procedure: dbo.ssp_SCWebBedBoardBedSearch                              */
/* Creation Date:    30/07/2010                                         */
/*                                                                   */
/* Purpose:   Populate the BedSearch Page in the application        */
/* Input Parameters:@FromDate,@ToDate,@ProgramId,@UnitId ,@RoomId,@Type1,@Type2,@Type3,@Type4-*/
/*                                                                   */
/* Output Parameters:   None                                         */
/*                                                                   */
/* Return:  0=success, otherwise an error number                 */
/*                                                                   */
/* Called By:                  */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:                                                          */
/*   Date        Author                 Purpose                      */
/*  20/08/2013   Veena S Mani           Created                      */
/*  11/09/2013   Akwinass               Modified for bedboard        */
/*  22/09/2013   Akwinass               Modified for bedboard Prgram fillter */
-- 19-11-2013    Akwinass               Based on the program fillter applied
-- 30-12-2013    Akwinass               Create Table Script Implemented for #BedSearch
-- 06-01-2014    Akwinass               Date CAST implemented.
-- 01-April-2014 Akwinass               Datetime to Date CAST implemented.
-- 21-April-2014 Akwinass               Changed the input parameter type @bedassignmentid int to varchar to pass more than on bed assignment id
-- 08-july-2014  Akwinass               parameter @BedName included to filter based on bed name as per task #1548 in Core Bugs
-- 27 May 2015      Veena               Added Condtion for ShowOnBedCensus and ShowOnBedBedBoard based on added parameter @CalledPage conditions in filter Philhaven Development #248**
-- 02-June-2015     Akwinass            Since we already have @mode Parameter, Removed @CalledPage(#248 in Philhaven Development )
-- 03-June-2015     Akwinass            ShowOnBedCensus and ShowOnBedBedBoard Added in Missed Place(#248 in Philhaven Development )
-- 27-Jan-2016   Akwinass               Since Time field is not managed on Search Popup, Date Cast Implemented task #372 in Philhaven Development
-- 21-SEP-2016		Akwinass			Included BlockBeds table to avoid pulling blocked beds (Task #630 Renaissance - Dev Items)
-- 24-July-2018	Deej				Added Logic to  bind the records only for the staff has access to Units and Programs. Bradford - Enhancements #400.2
/*********************************************************************/
BEGIN
	BEGIN TRY
		--Added by Deej
		  DECLARE @ListDataBasedOnStaffsAccessToProgramsAndUnits varchar(3)  
		  --SET @ListDataBasedOnStaffsAccessToProgramsAndUnits= CASE WHEN ssf_GetSystemConfigurationKeyValue( 'EnableStaffsAssociatedUnitAndProgramsFilteringInData') = 'Yes' THEN 'Y'
		  SELECT @ListDataBasedOnStaffsAccessToProgramsAndUnits = CASE WHEN [Value]='Yes' THEN 'Y' ELSE 'N' END 
		  FROM SystemConfigurationKeys WHERE [Key]= 'FilterDataBasedOnStaffAssociatedToProgramsAndUnits'   
		DECLARE @FromDateTime DATETIME = @FromDate
		
		CREATE TABLE #Beds (BedId INT)
		INSERT INTO #Beds
		SELECT BedId FROM BedAssignments BA WHERE EXISTS (SELECT 1 FROM dbo.fn_CommaSeparatedStringToTable(@bedassignmentid, '') WHERE CAST(ISNULL(Value, '0') AS INT) = BA.BedAssignmentId)
		
		CREATE TABLE #BedSearch (
			BedId INT NOT NULL
			,BedName VARCHAR(100) NULL
			,BedDisplayAs VARCHAR(50) NULL
			,StartDate DATE NULL
			,EndDate DATE NULL
			,ProgramCode VARCHAR(100) NULL
			,ProgramId INT NOT NULL
			,ProgramName VARCHAR(250) NULL
			,UnitName VARCHAR(100) NULL
			,UnitDisplayAs VARCHAR(50) NULL
			,RoomName VARCHAR(100) NULL
			,RoomDisplayAs VARCHAR(50) NULL
			,Type1 VARCHAR(250) NULL
			,Type2 VARCHAR(250) NULL
			,Type3 VARCHAR(250) NULL
			,Type4 VARCHAR(250) NULL
			,LocationId INT NULL
			,ProcedureCodeId INT NULL
			,FRoomId INT NULL
			,InpatientProgram CHAR(1) NULL
			,ResidentialProgram CHAR(1) NULL
			,ShowOnBedBoard CHAR(1) NULL
			,ShowOnBedCensus CHAR(1) NULL
			,ShowOnWhiteBoard CHAR(1) NULL
			)

		IF @ToDate <> ''
			AND @FromDateTime <> ''
		BEGIN
			SET @FromDateTime = GETDATE()
		END

		INSERT INTO #BedSearch (
			BedId
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
			,Type1
			,Type2
			,Type3
			,Type4
			,LocationId
			,ProcedureCodeId
			,FRoomId
			,InpatientProgram
			,ResidentialProgram
			--Added by  Veena  for ShowOnBedCensus and ShowOnBedBedBoard based on added parameter @CalledPage conditions in filter Philhaven Development #248**
			,ShowOnBedBoard
			,ShowOnBedCensus
			,ShowOnWhiteBoard
			)
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
			,GC1.CodeName AS Type1
			,GC2.CodeName AS Type2
			,GC3.CodeName AS Type3
			,GC4.CodeName AS Type4
			,BAH.LocationId
			,BAH.ProcedureCodeId
			,BS.RoomId AS FRoomId
			,PS.InpatientProgram
			,PS.ResidentialProgram
			--Added by  Veena  for ShowOnBedCensus and ShowOnBedBedBoard based on added parameter @CalledPage conditions in filter Philhaven Development #248**
			,US.ShowOnBedBoard
			,US.ShowOnBedCensus
			,US.ShowOnWhiteBoard
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
		LEFT JOIN GlobalCodes AS GC1 ON GC1.GlobalCodeId = BS.Type1
			AND ISNULL(GC1.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes AS GC2 ON GC2.GlobalCodeId = BS.Type2
			AND ISNULL(GC2.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes AS GC3 ON GC3.GlobalCodeId = BS.Type3
			AND ISNULL(GC3.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes AS GC4 ON GC4.GlobalCodeId = BS.Type4
			AND ISNULL(GC4.RecordDeleted, 'N') = 'N'
		WHERE 
				    --Added by Deej 7/24/2018
                       (@ListDataBasedOnStaffsAccessToProgramsAndUnits='N' or (@ListDataBasedOnStaffsAccessToProgramsAndUnits='Y' and
				    (EXISTS(select 1 from StaffUnits SU WHERE SU.StaffId=@StaffId AND SU.UnitId=US.UnitId and ISNULL(SU.Recorddeleted,'N')='N' )
				    AND EXISTS(SELECT 1 FROM StaffPrograms SP WHERE SP.StaffId=@StaffId AND SP.ProgramId=PS.ProgramId AND ISNULL(SP.RecordDeleted,'N')='N'  ) ))) AND				
				(
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
				BS.Type1 = @Type1
				OR @Type1 = 0
				)
			AND (
				BS.Type2 = @Type2
				OR @Type2 = 0
				)
			AND (
				BS.Type3 = @Type3
				OR @Type3 = 0
				)
			AND (
				BS.Type4 = @Type4
				OR @Type4 = 0
				)
			-- 08-july-2014  Akwinass
			AND (ISNULL(BS.DisplayAs, '')) LIKE '%' + @BedName + '%'
			AND CAST(bah.StartDate AS DATE) <= CAST(@FromDateTime AS DATE)
			AND (CAST(bah.EndDate AS DATE) >= CAST(@FromDateTime AS DATE) OR bah.EndDate IS NULL)
			AND rah.StartDate <= CAST(@FromDateTime AS DATE)
			AND (
				rah.EndDate >= CAST(@FromDateTime AS DATE)
				OR rah.EndDate IS NULL
				)
			AND uah.StartDate <= CAST(@FromDateTime AS DATE)
			AND (
				uah.EndDate >= CAST(@FromDateTime AS DATE)
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
					AND isnull(ba.RecordDeleted, 'N') = 'N'
					AND (
						ba.EndDate IS NULL
						OR (
							CAST(ba.EndDate AS DATE) = CAST(@FromDate AS DATE)
							AND Disposition IS NULL
							)
						OR CAST(ba.EndDate AS DATE) > CAST(@FromDateTime AS DATE)
						)
					AND CAST(ba.StartDate AS DATE) <= CAST(@FromDateTime AS DATE)
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
							FROM dbo.fn_CommaSeparatedStringToTable(@bedassignmentid, '')
							)
						AND CASE 
							WHEN @ProgramId > 0
								THEN ba.ProgramId
							ELSE @ProgramId
							END = @ProgramId
						AND (
							b2.Type1 = @Type1
							OR @Type1 = 0
							)
						AND (
							b2.Type2 = @Type2
							OR @Type2 = 0
							)
						AND (
							b2.Type3 = @Type3
							OR @Type3 = 0
							)
						AND (
							b2.Type4 = @Type4
							OR @Type4 = 0
							)
					)
				)

		IF @ToDate = ''
		BEGIN
			IF (@hideprogram = '')
			BEGIN
				IF (@mode = 'InpatientProgram')
				BEGIN
					SELECT *
					FROM #BedSearch BS
					WHERE BS.InpatientProgram = 'Y'
					AND ISNULL(BS.ShowOnBedBoard, 'N') = 'Y'
					AND NOT EXISTS(SELECT 1 FROM BlockBeds BB WHERE BB.BedId NOT IN(SELECT BedId FROM #Beds) AND BB.BedId = BS.BedId AND BB.StartDate <= @FromDate AND (BB.EndDate >= @FromDate OR BB.EndDate IS NULL ) AND ISNULL(BB.RecordDeleted,'N') = 'N' )
				END
				ELSE
				BEGIN
					SELECT *
					FROM #BedSearch BS
					WHERE BS.ResidentialProgram = 'Y'
					AND ISNULL(BS.ShowOnBedCensus, 'N') = 'Y'
					AND NOT EXISTS(SELECT 1 FROM BlockBeds BB WHERE NOT EXISTS(SELECT BedId FROM #Beds B WHERE B.BedId = BB.BedId) AND BB.BedId = BS.BedId AND BB.StartDate <= @FromDate AND (BB.EndDate >= @FromDate OR BB.EndDate IS NULL ) AND ISNULL(BB.RecordDeleted,'N') = 'N' )
				END
			END
			ELSE
			BEGIN
				IF (@mode = 'InpatientProgram')
				BEGIN
					SELECT *
					FROM #BedSearch BS
					WHERE BS.ProgramId <> cast(@hideprogram AS INT)
						AND BS.InpatientProgram = 'Y'
						AND ISNULL(BS.ShowOnBedBoard, 'N') = 'Y'
						AND NOT EXISTS(SELECT 1 FROM BlockBeds BB WHERE NOT EXISTS(SELECT BedId FROM #Beds B WHERE B.BedId = BB.BedId) AND BB.BedId = BS.BedId AND BB.StartDate <= @FromDate AND (BB.EndDate >= @FromDate OR BB.EndDate IS NULL ) AND ISNULL(BB.RecordDeleted,'N') = 'N' )
				END
				ELSE
				BEGIN
					SELECT *
					FROM #BedSearch BS
					WHERE BS.ProgramId <> cast(@hideprogram AS INT)
						AND BS.ResidentialProgram = 'Y'
						AND ISNULL(BS.ShowOnBedCensus, 'N') = 'Y'
						AND NOT EXISTS(SELECT 1 FROM BlockBeds BB WHERE NOT EXISTS(SELECT BedId FROM #Beds B WHERE B.BedId = BB.BedId) AND BB.BedId = BS.BedId AND BB.StartDate <= @FromDate AND (BB.EndDate >= @FromDate OR BB.EndDate IS NULL ) AND ISNULL(BB.RecordDeleted,'N') = 'N' )
				END
			END
		END
		ELSE
		BEGIN
			IF (@hideprogram = '')
			BEGIN
				IF (@mode = 'InpatientProgram')
				BEGIN
					SELECT *
					FROM #BedSearch BS
					WHERE BS.StartDate >= CAST(@FromDate as Date)
						AND (
							BS.EndDate <= CAST(@ToDate as Date)
							OR BS.EndDate IS NULL
							)
						AND BS.InpatientProgram = 'Y'
						AND ISNULL(BS.ShowOnBedBoard, 'N') = 'Y'
						AND NOT EXISTS (SELECT 1 FROM BlockBeds BB WHERE NOT EXISTS(SELECT BedId FROM #Beds B WHERE B.BedId = BB.BedId) AND BB.BedId = BS.BedId AND (@FromDate BETWEEN BB.StartDate AND ISNULL(BB.EndDate,CAST('9999-12-31' AS DATE)) OR @ToDate BETWEEN BB.StartDate AND ISNULL(BB.EndDate,CAST('9999-12-31' AS DATE))) AND ISNULL(BB.RecordDeleted, 'N') = 'N')
				END
				ELSE
				BEGIN									
					SELECT *
					FROM #BedSearch BS
					WHERE BS.StartDate >= CAST(@FromDate AS DATE)
						AND (
							BS.EndDate <= CAST(@ToDate AS DATE)
							OR BS.EndDate IS NULL
							)
						AND BS.ResidentialProgram = 'Y'
						AND ISNULL(BS.ShowOnBedCensus, 'N') = 'Y'
						AND NOT EXISTS (SELECT 1 FROM BlockBeds BB WHERE NOT EXISTS(SELECT BedId FROM #Beds B WHERE B.BedId = BB.BedId) AND BB.BedId = BS.BedId AND (@FromDate BETWEEN BB.StartDate AND ISNULL(BB.EndDate,CAST('9999-12-31' AS DATE)) OR @ToDate BETWEEN BB.StartDate AND ISNULL(BB.EndDate,CAST('9999-12-31' AS DATE))) AND ISNULL(BB.RecordDeleted, 'N') = 'N')
				END
			END
			ELSE
			BEGIN
				IF (@mode = 'InpatientProgram')
				BEGIN
					SELECT *
					FROM #BedSearch BS
					WHERE BS.StartDate >= CAST(@FromDate as Date)
						AND (
							BS.EndDate <= CAST(@ToDate as Date)
							OR BS.EndDate IS NULL
							)
						AND BS.ProgramId <> cast(@hideprogram AS INT)
						AND BS.InpatientProgram = 'Y'
						AND ISNULL(BS.ShowOnBedBoard, 'N') = 'Y'
						AND NOT EXISTS (SELECT 1 FROM BlockBeds BB WHERE NOT EXISTS(SELECT BedId FROM #Beds B WHERE B.BedId = BB.BedId) AND BB.BedId = BS.BedId AND (@FromDate BETWEEN BB.StartDate AND ISNULL(BB.EndDate,CAST('9999-12-31' AS DATE)) OR @ToDate BETWEEN BB.StartDate AND ISNULL(BB.EndDate,CAST('9999-12-31' AS DATE))) AND ISNULL(BB.RecordDeleted, 'N') = 'N')
				END
				ELSE
				BEGIN
					SELECT *
					FROM #BedSearch BS
					WHERE BS.StartDate >= CAST(@FromDate as Date)
						AND (
							BS.EndDate <= CAST(@ToDate as Date)
							OR BS.EndDate IS NULL
							)
						AND BS.ProgramId <> cast(@hideprogram AS INT)
						AND BS.ResidentialProgram = 'Y'
						AND ISNULL(BS.ShowOnBedCensus, 'N') = 'Y'
						AND NOT EXISTS (SELECT 1 FROM BlockBeds BB WHERE NOT EXISTS(SELECT BedId FROM #Beds B WHERE B.BedId = BB.BedId) AND BB.BedId = BS.BedId AND (@FromDate BETWEEN BB.StartDate AND ISNULL(BB.EndDate,CAST('9999-12-31' AS DATE)) OR @ToDate BETWEEN BB.StartDate AND ISNULL(BB.EndDate,CAST('9999-12-31' AS DATE))) AND ISNULL(BB.RecordDeleted, 'N') = 'N')
				END
			END
		END

		DROP TABLE #BedSearch
		DROP TABLE #Beds
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCWebBedBoardBedSearch') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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

