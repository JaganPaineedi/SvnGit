IF EXISTS 
(
	SELECT *
	FROM sys.objects
	WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportServicesDetail]')
	AND type IN (N'P', N'PC')
)
DROP PROCEDURE [dbo].[csp_ReportServicesDetail]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/***********************************************************************************************************************
Created by tmu 
	Ace # 562 ARM Report Request: Durations. 
	We are currently manually calculating productivity. Would it be possible to either add a column header in the 
	"Services" screen from My Office indicating duration of the service? If this isn't possible, can a query be created 
	showing all of those fields with addition to duration? Report? What would the timeline be on this?
========================================================================================================================
	MODIFICATIONS LOG:
========================================================================================================================
	Date		User		Description
	--------	-------		--------------------------------------------------------------------------------------------
	11/14/2016	tmu			Created
	04/11/2017	tmu			Modified the logic to accept more input parameters and make sure that the procedure 
							"Urine Test" has the 15 mins duration as per ARM # 600
	11/09/2017	vsinha      Modified the the length of ProcedureName from 30 to 80 char as per ARM Support# 730
***********************************************************************************************************************/

CREATE PROCEDURE [dbo].[csp_ReportServicesDetail]
(
	@FromDate DATETIME,
	@ToDate DATETIME,
	@Status CHAR(1),
	@ClinicianId INT
)
AS
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	--==========================================================================
	-- Variables declaration
	--==========================================================================
	
	DECLARE @Title VARCHAR(MAX)
	DECLARE @SubTitle VARCHAR(MAX)
	DECLARE @Comment VARCHAR(MAX)
	DECLARE @ErrorMessage VARCHAR(MAX)
	DECLARE @StoredProcedure VARCHAR(300)
	
	BEGIN TRY
		SET @Title = 'A Renewed Mind - Completed Services Detail with Service Duration'
		SET @SubTitle = 'All the completed services (billable and unbillable) between ' + CONVERT(VARCHAR, @FromDate, 101) + ' and ' + CONVERT(VARCHAR, @ToDate, 101)
		SET	@Comment = 'ARM 562 requesting a report with services info plus service duration'
		SET @StoredProcedure = OBJECT_NAME(@@PROCID)
		
		--==============================================================================================================
		-- Updates the CustomReportParts table
		--==============================================================================================================
		
		IF @StoredProcedure IS NOT NULL
			AND NOT EXISTS 
			(
				SELECT 1
				FROM CustomReportParts
				WHERE StoredProcedure = @StoredProcedure
			)
			BEGIN
				INSERT INTO CustomReportParts 
				(
					StoredProcedure
					,ReportName
					,Title
					,SubTitle
					,Comment
				)
				SELECT @StoredProcedure
					,@Title
					,@Title
					,@SubTitle
					,@Comment
			END
		ELSE
			BEGIN
				UPDATE CustomReportParts
				SET ReportName = @Title
					,Title = @Title
					,SubTitle = @SubTitle
					,Comment = @Comment
				WHERE StoredProcedure = @StoredProcedure
			END
			
		--==============================================================================================================
		-- Gets all the active clients and stores them in the temp table
		--==============================================================================================================
		
		IF OBJECT_ID('tempdb..#ActiveClientIds') IS NOT NULL
			DROP TABLE #ActiveClientIds
		CREATE TABLE #ActiveClientIds
		(
			ClientId INT NOT NULL
		)
		INSERT INTO #ActiveClientIds ( ClientId )
		SELECT	ClientId 
		FROM	dbo.Clients
		WHERE	ISNULL(RecordDeleted, 'N') <> 'Y'
			AND	LastName NOT LIKE '%test%'
			AND LastName NOT LIKE '%client%'
			AND FirstName != '25'
			AND (Active = @Status OR @Status IS NULL)
			AND ClientId != 2
			
		--==============================================================================================================
		-- Fetches the report content
		--==============================================================================================================
		
		IF OBJECT_ID('tempdb..#Report') IS NOT NULL
			DROP TABLE #Report
		CREATE TABLE #Report
		(
			ClientId INT NOT NULL,
			ClientName VARCHAR(250),
			DateOfService VARCHAR(100),
			StaffName VARCHAR(250),
			ProcedureName VARCHAR(80),
			Charge MONEY,
			ProgramName VARCHAR(250),
			LocationName VARCHAR(150),
			ServiceAreaName VARCHAR(150),
			Duration INT
		)
		INSERT INTO #Report
		(	
			ClientId ,
		    ClientName ,
		    DateOfService ,
		    StaffName ,
		    ProcedureName ,
		    Charge ,
		    ProgramName ,
		    LocationName ,
		    ServiceAreaName ,
		    Duration
		)
		SELECT	C.ClientId,
				C.LastName + ', ' + C.FirstName AS ClientName,
				CONVERT(VARCHAR, S.DateOfService, 101) AS DOS,
				ST.LastName + ', ' + ST.FirstName AS Clinician,
				PC.DisplayAs AS ProcedureName,
				ISNULL(S.Charge, 0) AS Charge,
				P.ProgramName,
				L.LocationName,
				SA.ServiceAreaName,
				CASE WHEN PC.DisplayAs = 'Urine Test'		-- tmu modification on 04/11/2017
						THEN 15
					 WHEN PC.DisplayAs = 'Partial Hosp'		-- tmu modification on 04/11/2017
						THEN S.Unit
					ELSE
						DATEDIFF(MINUTE, S.DateOfService, S.EndDateOfService)
				END AS Duration
		FROM	Services S
		JOIN	dbo.Clients C ON S.ClientId = C.ClientId AND ISNULL(C.RecordDeleted, 'N') = 'N'
		JOIN	dbo.Staff ST ON S.ClinicianId = ST.StaffId
		JOIN	dbo.ProcedureCodes PC ON S.ProcedureCodeId = PC.ProcedureCodeId AND ISNULL(PC.RecordDeleted, 'N') = 'N'
		JOIN	dbo.Programs P ON S.ProgramId = P.ProgramId AND ISNULL(P.RecordDeleted, 'N') = 'N'
		JOIN	dbo.Locations L ON S.LocationId = L.LocationId AND ISNULL(L.RecordDeleted, 'N') = 'N'
		JOIN	dbo.ServiceAreas SA ON P.ServiceAreaId = SA.ServiceAreaId AND ISNULL(SA.RecordDeleted, 'N') = 'N'
		WHERE	S.DateOfService >= @FromDate 
			AND S.DateOfService <  DATEADD(dd, 1, @ToDate)
			AND ISNULL(S.RecordDeleted, 'N') = 'N'
			AND S.Status = 75
			AND C.ClientId IN (SELECT ClientId FROM #ActiveClientIds)
			AND (S.ClinicianId = @ClinicianId OR @ClinicianId IS NULL)
			
		--==============================================================================================================
		-- Final selects
		--==============================================================================================================
		
		IF EXISTS (SELECT 1 FROM #Report)
			BEGIN
				SELECT *, @StoredProcedure AS StoredProcedure, @Title AS Title, @SubTitle AS SubTitle 
				FROM #Report
				ORDER BY ClientId
			END
		ELSE
			SELECT @StoredProcedure AS StoredProcedure, @Title AS Title, @SubTitle AS SubTitle 
			--FROM #Report
			--ORDER BY ClientId
			
		DROP TABLE #ActiveClientIds
		DROP TABLE #Report
		
		SET NOCOUNT OFF
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	END TRY
	BEGIN CATCH
		IF @@Trancount > 0
			ROLLBACK TRAN
		
		DECLARE @ErrorProc VARCHAR(4000) = CONVERT(VARCHAR(4000), ISNULL(ERROR_PROCEDURE(), @StoredProcedure))
		
		SET @ErrorMessage = @StoredProcedure + ' Reports Error Thrown by: ' + @ErrorProc
		SET @ErrorMessage += ISNULL(CONVERT(VARCHAR(4000), ERROR_MESSAGE()), 'Unknown') + CHAR(13) + @StoredProcedure + ' Variable dump:' + CHAR(13)
		
		RAISERROR 
		(
			@ErrorMessage,-- Message.   
			16,-- Severity.   
			1 -- State.   
		);

		SET NOCOUNT OFF
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	END CATCH
END

GO