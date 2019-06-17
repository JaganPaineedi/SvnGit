IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMPostPaymentsServicesSearchSel]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_PMPostPaymentsServicesSearchSel]
GO

/****** Object:  StoredProcedure [dbo].[ssp_PMPostPaymentsServicesSearchSel]    Script Date: 09/06/2016 15:54:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_PMPostPaymentsServicesSearchSel] 
	@SessionId VARCHAR(30)
	,@InstanceId INT
	,@PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@PayerId INT
	,@CoveragePlanId INT
	,@ClientId INT
	,@DOSFrom VARCHAR(30)
	,@DOSTo VARCHAR(30)
	,@BatchNumbers VARCHAR(100)			-- eg. 345 or 345, 346, 348 or 345-350  
	,@ServiceWithBalance CHAR(1)		-- Y/N  
	,@IncludeCreditServices CHAR(1)
	,@RowSelectionList VARCHAR(MAX)
	,@ClientIdNew VARCHAR(MAX)
	,@ServiceId INT
	,@ClientName VARCHAR(110)
	,@ClaimLineItemId INT
	,@StaffId INT = NULL
	,@ClientIdSearchParam INT = NULL	-- Dhanil 03 Aug 2016 
	-- 09-DEC-2016 Akwinass
	,@ProcedureCodeId INT = NULL
	,@ProgramId INT = NULL
	,@ClinicianName VARCHAR(110) = NULL
	,@ChargesDummyXML XML = NULL
	,@CPTCode VARCHAR(MAX)
	,@ExcludeErroredServices CHAR(1)=NULL --06/12/2018	Ravi

/***********************************************************************************************************************         
** File: ssp_PMPostPaymentsServicesSearchSel.sql        
** Name: ssp_PMPostPaymentsServicesSearchSel        
** Desc:          
**         
**         
** This template can be customized:         
**         
** Return values: Filter Values -  Post Payments Find Services List Page        
**         
** Called by:         
**         
** Parameters:         
** Input Output         
** ---------- -----------         
** N/A   Dropdown values        
** Auth: Mary Suma        
** Date: 03/25/2011        
************************************************************************************************************************         
** Change History         
************************************************************************************************************************         
** Date:		Author:		Description:              
-------------	--------    ---------------------------------------------------- 
** 03/25/2011	MSuma		Query to return values for the grid in Post Payment search ServicesList Page        
** 09/06/2011   MSuma		Included Additional column to retrieve NextPayer         
** 28 Sep 2011  Girish		Changed detail page to listpage as per Suma and Slavik                 
** 02 Oct 2011  MSuma		Included Next Payer Dropdown        
** 10 Oct 2011  MSuma		Included Paging for CheckBox        
** 10 Oct 2011  MSuma		Included Paging for CheckBox        
** 03 Nov 2011  MSuma		Modified rownumber based on ChargeId instead of ServiceId        
** 05 Dec 2011  MSuma		Included ID column in the final select        
** 14 Dec 2011  MSuma		Made default value for ClientCoverage as -1        
** 24 Mar 2012  MSuma		Performance Tuning      
** 23 May 2012  MSuma		Added additional Parameter @ServiceId      
** 04 June 2012 MSuma		Moved filter on @ServiceId      
** 22 June 2012 MSuma		Included ServiceArea condition for ClientCoverageHistory      
** 27 Jun 2012  PSelvan		For Ace project PM Web Bugs #1814      
** 30 Jul 2012  MSuma		Additional check for COBOrder with Same ServiceAReaId      
** 09 Aug 2012  MSuma		Additional check to remove different ServiceAReaId      
** 02 Oct 2012  MSuma		Included all services excluding errors    
** 02 Jun 2013	Javed		changes made by Javed     
** 22 Jul 2013  SFarber		Fixed Coverage Plan selection logic.   
** 25 Nov 2013  Gautam		What : Added default sorting by client name/ DOS and if an alternate column is selected for 
							sorting by clicking on the column header then it should sort by that column/ClientName/DOS .  
							Why :  Required for the task #345, Core Bugs  
** DEC-9-2013	dharvey		Moved sort order from outer column desc to sortexpression column
							and moved dynamic logic to row/page update.  Restore PageNumber/rowNumber sort on final select
**  DEC-13-2013	Deej		Modified the RowSelection Logic to handle the sort scenario and check box selection	
**				sbhowmik	Modified to check @RowSelectionList 	
** JAN-21-2014	dharvey		Modified delimited value check to ISNULL on @RowSelection		
** Feb-04-2014	Manju P		Modified for Core Bugs: #1374 Payments/Adjustment: Add Client Name Search criteria on pop up				
** Feb-21-2014	Manju P		Reverting Changes done by Dan on Jan 21, 2014 -delimited value check to ISNULL on @RowSelection	
** Apr-09-2014 John S		Truncate the Unit field at the end to 250 chars(change approved by Javed).		
** July-14-2014 Deej		Included @SessionId and @InstanceId check in the where clause to update the Isselected field 
							only for the specific session. 
** May-15-2015 Dhanil Manuel Added new parameter @ClaimLineItemId for task #960 Vally-Cusomizations  	
--21-DEC-2015   Basudev Sahu Modified For Task #609 Network180 Customization to Get Organisation  As ClientName
-- 03-10-2016   MJensen		Performance improvements per Thresholds 358 Move get next insured section to 
							Ssp_pmpostpaymentsgetselectedservices
** 25-Mar-2016 Gautam		What: Changed code to limiting the clients based on StaffClients access and added new input 
							parameter @StaffId 
							Why: Task#573, Pines Support
** 24-MAY-2016 Akwinass	What: Removed Status <> 76 check, Why: Posting payments to errored services, (Task #354 in 
							Engineering Improvement Initiatives- NBL(I))
** 14-JUL-2016	Wasif Butt	Issue with parameter sniffing, excution plan cache was invalid for Arithabort off, adding 
							option recompile to improve performance.  Bradford - Support Go Live #60
** 20-Jul-2016 Deej			commented the code where isselected is updating 0 incase of Allonpage (Bradford - Support Go Live #83)
** 03- Aug- 2016 Dhanil		Modified Client search to include client id with client name (Task #379 in Engineering 
							Improvement Initiatives- NBL(I)))
** 06-Sep-2016	Deej		Added condition to avoid keeping the selected services in case the row selection is "None"
** 09-DEC-2016  Akwinass	What: Added @ProcedureCodeId, @ProgramId, @ClinicianName, @ChargesDummyXML and added logic 
							for Balance Sum.
                            Why: Task #306 Woods - Support Go Live
** 20-DEC-2016  Akwinass	What: Modified @ClinicianName filter to return result for full name.
                            Why: Task #306 Woods - Support Go Live
** 19-JAN-2017  Gautam		What: Removed the used index XIE1_ARLedger from query.
							Why: using expensive operation clustered key lookup and not using existing index ,Philhaven 
							support 78.2   
** 3/8/2017     Lakshmi		What:Commeted the unwanted Update statment for ListPagePMPostPayments.
                            Why:Woods - Support Go Live #562
** 04/27/2017	Ting-Yu Mu	What: The variable @CPTCode is never passed in as NULL, so I added a ISNULL check for
							@CPTCode in the INSERT INTO #ResultSet statement instead of @CPTCode IS NULL, the Charges 
							table for BillingCode and RevenueCode are NULL, then the valid record will get eliminated 
							from the result set
							Why: WMU - Support #364		
** 4/28/2017	Msood		What: Added RecordDeleted check for Services
							Why: Showing Deleted Services on Filter as per Woods - Support Go Live Task #589
** 12/29/2017	Hemant		What: Added RecordDeleted check for ClientCoverageHistory and services
							Why: Service showing twice on Payment/Adjustment Posting Screen as per 	Key Point - Support Go Live #1254
** 06/12/2018	Ravi		What: Added New Filter Parameter @ExcludeErroredServices to avoid Showing Errored Services based on ExcludeErroredServices search   
							Why: CEI - Enhancements > Tasks #870 > SC: Payment Service Search-Showing Errored Services 													
***********************************************************************************************************************/
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	BEGIN TRY
		--14-FEB-2017  Deej
		IF @CPTCode = ''
			SET @CPTCode = NULL

		--Added By Deej
		PRINT @RowSelectionList
		PRINT '1121'

		-- This code is added to retain the services selected in earlier selection and 
		-- cancelled the posting inbetween and again search new services. 
		DECLARE @SelectedServices TABLE (ServiceId INT)

		IF (LOWER(@RowSelectionList) <> 'none')
		BEGIN
			INSERT INTO @SelectedServices (ServiceId)
			SELECT ServiceId
			FROM ListPagePMPostPayments
			WHERE SessionId = @SessionId
				AND InstanceId = @InstanceId
				AND IsSelected = 1
		END

		--IF ((LOWER(@RowSelectionList) <> 'all')  AND (LOWER(@RowSelectionList) <> 'none') AND (LOWER(@RowSelectionList) <> 'allonpage'))
		IF (CHARINDEX(',', @RowSelectionList) > 0)
			--IF ISNULL(@RowSelectionList,'') <> ''
		BEGIN
			CREATE TABLE #RowSelection (
				RowNumber INT
				,ServiceId INT
				,IsSelected BIT
				)

			INSERT INTO #RowSelection (
				RowNumber
				,IsSelected
				)
			SELECT ids
				,IsSelected
			FROM dbo.SplitJSONString(@RowSelectionList, ',')

			UPDATE R
			SET R.ServiceId = LP.ServiceId
			FROM #RowSelection R
			INNER JOIN ListPagePMPostPayments LP ON LP.RowNumber = R.RowNumber
				AND LP.SessionId = @SessionId
				AND LP.InstanceId = @InstanceId
		END

		---------------------         
		CREATE TABLE #ResultSet (
			Identity1 [bigint] IDENTITY(1, 1) NOT NULL
			,RowNumber INT
			,PageNumber INT
			,RadioButton CHAR(1)
			,ServiceId INT
			,ClientId INT
			,[Name] VARCHAR(100)
			,DateOfService DATETIME
			,Unit VARCHAR(450)
			,Charge MONEY
			,ChargeId INT
			,Priority INT
			,Payment MONEY
			,Adjustment MONEY
			,Balance MONEY
			,LedgerType INT
			,ClaimBatchId INT
			,CoveragePlanId INT
			,ProcedureCodeId INT
			,COBOrder INT
			,NextPayer VARCHAR(50)
			,IsSelected BIT
			,ServiceAreaId INT
			,ClientCoveragePlanId INT
			,
			-- 09-DEC-2016 Akwinass
			ProcedureCode VARCHAR(500)
			,ProgramCode VARCHAR(100)
			,ClinicianName VARCHAR(60)
			,CPTCode VARCHAR(100)
			,ClaimLineNumber INT
			)

		DECLARE @CustomFilters TABLE (CoveragePlanId INT)
		DECLARE @ApplyFilterClicked CHAR(1)
		DECLARE @CustomFiltersApplied CHAR(1)

		-- Generate Batch Numbers              
		CREATE TABLE #BatchNumbers (ClaimBatchId INT)

		DECLARE @BatchString VARCHAR(30)
			,@BatchStart VARCHAR(15)
			,@BatchEnd VARCHAR(15)
		DECLARE @BatchStartINT INT
			,@BatchEndINT INT
		DECLARE @BatchNumbersExist CHAR(1)
		DECLARE @strSQL NVARCHAR(4000)

		SET @BatchNumbers = REPLACE(@BatchNumbers, ' ', RTRIM(''))

		WHILE ISNULL(RTRIM(@BatchNumbers), '') <> ''
		BEGIN
			IF CHARINDEX(',', @BatchNumbers) > 1
			BEGIN
				SET @BatchString = SUBSTRING(@BatchNumbers, 1, CHARINDEX(',', @BatchNumbers) - 1)
				SET @BatchNumbers = RIGHT(@BatchNumbers, LEN(@BatchNumbers) - CHARINDEX(',', @BatchNumbers))
			END
			ELSE
			BEGIN
				SET @BatchString = @BatchNumbers
				SET @BatchNumbers = ''
			END

			IF CHARINDEX('-', @BatchString) > 1
			BEGIN
				SET @BatchStart = SUBSTRING(@BatchString, 1, CHARINDEX('-', @BatchString) - 1)
				SET @BatchEnd = RIGHT(@BatchString, LEN(@BatchString) - CHARINDEX('-', @BatchString))

				IF ISNUMERIC(@BatchStart) = 1
					AND ISNUMERIC(@BatchEnd) = 1
				BEGIN
					SET @BatchStartINT = CONVERT(INT, @BatchStart)
					SET @BatchEndINT = CONVERT(INT, @BatchEnd)

					WHILE @BatchStartINT <= @BatchEndINT
					BEGIN
						INSERT INTO #BatchNumbers (ClaimBatchId)
						VALUES (@BatchStartINT)

						SET @BatchStartINT = @BatchStartINT + 1
					END
				END
			END
			ELSE
			BEGIN
				IF ISNUMERIC(@BatchString) = 1
				BEGIN
					SET @BatchStartINT = CONVERT(INT, @BatchString)

					INSERT INTO #BatchNumbers (ClaimBatchId)
					VALUES (@BatchStartINT)
				END
			END
		END

		IF EXISTS (
				SELECT *
				FROM #BatchNumbers
				)
			SET @BatchNumbersExist = 'Y'
		ELSE
			SET @BatchNumbersExist = 'N'

		IF (@DOSFrom = CONVERT(DATETIME, N''))
		BEGIN
			SET @DOSFrom = NULL
		END

		IF (@DOSTo = CONVERT(DATETIME, N''))
		BEGIN
			SET @DOSTo = NULL
		END

		SET @SortExpression = RTRIM(LTRIM(@SortExpression))

		IF ISNULL(@SortExpression, '') = ''
			SET @SortExpression = 'ServiceId'

		--       
		-- If a specific page was requested, goto GetPage and retrieve this page of the previously selected data                                                        
		--                                                        
		IF @PageNumber > 0
			AND EXISTS (
				SELECT *
				FROM ListPagePMPostPayments
				WHERE SessionId = @SessionId
					AND InstanceId = @InstanceId
				)
		BEGIN
			SET @ApplyFilterClicked = 'N'

			GOTO GetPage
		END

		--       
		-- New retrieve - the request came by clicking on the Apply Filter button                         
		--      
		SET @ApplyFilterClicked = 'Y'
		SET @CustomFiltersApplied = 'N'
		SET @PageNumber = 1

		IF @ServiceWithBalance = 'Y'
		BEGIN
			INSERT INTO #ResultSet (
				RadioButton
				,ServiceId
				,ClientId
				,[Name]
				,DateOfService
				,Unit
				,Charge
				,ChargeId
				,Priority
				,ClaimBatchId
				,CoveragePlanId
				,ProcedureCodeId
				,COBOrder
				,NextPayer
				,IsSelected
				,ServiceAreaId
				,ClientCoveragePlanId
				,
				-- 09-DEC-2016 Akwinass
				ProcedureCode
				,ProgramCode
				,ClinicianName
				,CPTCode
				,ClaimLineNumber
				)
			SELECT '0' AS RadioButton
				,S.ServiceId
				,C.ClientId
				,CASE 
					WHEN ISNULL(C.ClientType, 'I') = 'I'
						THEN C.LastName + ', ' + C.FirstName
					ELSE C.OrganizationName
					END + ' (' + CONVERT(VARCHAR, C.ClientId) + ')' AS [Name]
				,S.DateOfService
				,RTRIM(PC.DisplayAs) + ' ' + CONVERT(VARCHAR, S.Unit) + ' ' + GC.CodeName AS [unit]
				,S.Charge
				,Ch.ChargeId
				,Ch.Priority
				,1 AS ClaimBatchId
				,--CB.ClaimBatchId,              
				CCP.coverageplanid
				,
				--      
				PC.ProcedureCodeId
				,ISNULL(CCH.COBOrder, 0)
				,NULL
				,0
				,CCH.ServiceAreaID
				,CCP.ClientCoveragePlanId
				,
				-- 09-DEC-2016 Akwinass
				PC.DisplayAs
				,P.ProgramCode
				,ST.LastName + ', ' + ST.FirstName
				,CH.BillingCode AS CPTCode
				,NULL AS ClaimLineNumber
			FROM OpenCharges OC
			JOIN Charges Ch ON (Ch.ChargeId = OC.ChargeId)
			JOIN Services S ON Ch.ServiceId = S.ServiceId
				AND isnull(S.RecordDeleted, 'N') = 'N' -- msood 4/28/2017
			JOIN Programs P ON P.ProgramId = S.ProgramId
			JOIN Clients C ON S.ClientId = C.ClientId
			JOIN ProcedureCodes PC ON S.ProcedureCodeId = PC.ProcedureCodeId
			LEFT OUTER JOIN GlobalCodes GC ON (S.UnitType = GC.GlobalCodeId)
			LEFT OUTER JOIN ClientCoverageplans CCP ON Ch.ClientCoveragePlanId = CCP.ClientCoveragePlanId
			-- included      
			LEFT OUTER JOIN ClientCoverageHistory CCH ON (
					Ch.ClientCoveragePlanId = CCH.ClientCoveragePlanId
					AND CCH.StartDate <= S.DateOfService
					AND (
						CCH.EndDate IS NULL
						OR DATEADD(dd, 1, CCH.EndDate) > S.DateOfService
						)
					)
				AND CCH.ServiceAreaId = P.ServiceAreaid
				AND isnull(CCH.RecordDeleted, 'N') = 'N' -- Hemant 12/29/2017
			--end      
			LEFT OUTER JOIN CoveragePlans CP ON CCP.CoveragePlanId = CP.CoveragePlanId
			LEFT JOIN Staff ST ON S.ClinicianId = ST.StaffId
			WHERE --S.Status <> 76 AND 24-MAY-2016 Akwinass
				--25/Mar/2016 Gautam
				EXISTS (
					SELECT 1
					FROM StaffClients SC
					WHERE SC.StaffId = @StaffId
						AND SC.ClientId = C.ClientId
					)
				AND (
					@PayerId = - 1
					OR CP.PayerId = @PayerId
					)
				AND (
					@CoveragePlanId = - 1
					OR CP.CoveragePlanId = @CoveragePlanId
					)
				AND (
					@ClientId = - 1
					OR (
						Ch.Priority = 0
						AND S.ClientId = @ClientId
						)
					)
				AND (
					@DOSFrom IS NULL
					OR S.DateOfService >= @DOSFrom
					)
				AND (
					@DOSTo IS NULL
					OR S.DateOfService < DATEADD(dd, 1, @DOSTo)
					)
				AND (
					ISNULL(@IncludeCreditServices, 'N') = 'Y'
					OR OC.Balance > 0
					)
				AND (
					@BatchNumbersExist = 'N'
					OR EXISTS (
						SELECT *
						FROM #BatchNumbers z
						JOIN ClaimBatchCharges y ON (z.ClaimBatchId = y.ClaimBatchId)
						WHERE y.ChargeId = ch.ChargeId
						)
					)
				AND (
					@ServiceId = - 1
					OR S.ServiceId = @ServiceId
					)
				--Added by Manju P Feb 04, 2014 - Core Bugs #1374 - Payments/Adjustment: Add Client Name Search criteria on pop up
				AND (
					@ClientName IS NULL
					OR C.LastName LIKE '%' + @ClientName + '%'
					OR C.FirstName LIKE '%' + @ClientName + '%'
					OR C.OrganizationName LIKE '%' + @ClientName + '%'
					)
				-- Dhanil 03 Aug 2016
				AND (
					isnull(@ClientIdSearchParam, - 1) = - 1
					OR C.ClientId = @ClientIdSearchParam
					)
				AND (
					isnull(@ProcedureCodeId, - 1) <= 0
					OR PC.ProcedureCodeId = @ProcedureCodeId
					)
				AND (
					isnull(@ProgramId, - 1) <= 0
					OR P.ProgramId = @ProgramId
					)
				AND (
					ISNULL(@ClinicianName, '') = ''
					OR ST.LastName LIKE '%' + @ClinicianName + '%'
					OR ST.FirstName LIKE '%' + @ClinicianName + '%'
					OR (ST.LastName + ', ' + ST.FirstName) LIKE '%' + @ClinicianName + '%'
					)
				--Modified by Dhanil on 15 May 2015
				AND (
					@ClaimLineItemId = - 1
					OR EXISTS (
						SELECT ci.*
						FROM ClaimLineItemCharges CLIC
						JOIN dbo.ClaimLineItems CI ON CI.ClaimLineItemId = CLIC.ClaimLineItemId
						WHERE CLIC.ChargeId = CH.ChargeId
							AND ISNULL(CLIC.RecordDeleted, 'N') = 'N'
							AND ISNULL(CLIC.RecordDeleted, 'N') = 'N'
							AND CI.ClaimLineItemId = @ClaimLineItemId
						)
					)
				AND (
					ISNULL(@CPTCode, '') = '' --@CPTCode IS NULL TMU modification on 04/27/2017
					OR CH.BillingCode LIKE '%' + @CPTCode + '%'
					OR CH.RevenueCode LIKE '%' + @CPTCode + '%'
					)
				
				AND (
						ISNULL(@ExcludeErroredServices, 'N') = 'N' --06/12/2018	Ravi
						OR (
							ISNULL(@ExcludeErroredServices, 'N') = 'Y'
							AND S.[Status] <> 76 --Error
							)
					)

			OPTION (RECOMPILE)
		END
		ELSE
		BEGIN
			INSERT INTO #ResultSet (
				RadioButton
				,ServiceId
				,ClientId
				,[Name]
				,DateOfService
				,Unit
				,Charge
				,ChargeId
				,Priority
				,ClaimBatchId
				,CoveragePlanId
				,ProcedureCodeId
				,COBOrder
				,NextPayer
				,IsSelected
				,ServiceAreaID
				,ClientCoveragePlanId
				,
				-- 09-DEC-2016 Akwinass
				ProcedureCode
				,ProgramCode
				,ClinicianName
				,CPTCode
				,ClaimLineNumber
				)
			SELECT '0' AS RadioButton
				,S.ServiceId
				,C.ClientId
				,CASE 
					WHEN ISNULL(C.ClientType, 'I') = 'I'
						THEN C.LastName + ', ' + C.FirstName
					ELSE C.OrganizationName
					END + ' (' + CONVERT(VARCHAR, C.ClientId) + ')' AS [Name]
				,S.DateOfService
				,RTRIM(PC.DisplayAs) + ' ' + CONVERT(VARCHAR, S.Unit) + ' ' + GC.CodeName AS [unit]
				,S.Charge
				,Ch.ChargeId
				,Ch.Priority
				,1 AS ClaimBatchId
				,CCP.coverageplanid
				,PC.ProcedureCodeId
				,ISNULL(CCH.COBOrder, 0)
				,NULL
				,0
				,CCH.ServiceAreaID
				,CCP.ClientCoveragePlanId
				,
				-- 09-DEC-2016 Akwinass
				PC.DisplayAs
				,P.ProgramCode
				,ST.LastName + ', ' + ST.FirstName
				,CH.BillingCode AS CPTCode
				,NULL AS ClaimLineNumber
			FROM Charges Ch
			JOIN Services S ON Ch.ServiceId = S.ServiceId
			AND isnull(S.RecordDeleted, 'N') = 'N' -- Hemant 12/29/2017
			JOIN Clients C ON S.ClientId = C.ClientId
			JOIN Programs P ON P.ProgramId = S.ProgramId
			JOIN ProcedureCodes PC ON S.ProcedureCodeId = PC.ProcedureCodeId
			LEFT OUTER JOIN GlobalCodes GC ON (S.UnitType = GC.GlobalCodeId)
			LEFT OUTER JOIN ClientCoverageplans CCP ON Ch.ClientCoveragePlanId = CCP.ClientCoveragePlanId
			-- included      
			LEFT OUTER JOIN ClientCoverageHistory CCH ON (
					Ch.ClientCoveragePlanId = CCH.ClientCoveragePlanId
					AND CCH.StartDate <= S.DateOfService
					AND (
						CCH.EndDate IS NULL
						OR DATEADD(dd, 1, CCH.EndDate) > S.DateOfService
						)
					)
				AND CCH.ServiceAreaId = P.ServiceAreaid
				AND isnull(CCH.RecordDeleted, 'N') = 'N' -- Hemant 12/29/2017
			--end            
			LEFT OUTER JOIN CoveragePlans CP ON CCP.CoveragePlanId = CP.CoveragePlanId
			LEFT JOIN Staff ST ON S.ClinicianId = ST.StaffId
			WHERE --S.Status <> 76 AND 24-MAY-2016 Akwinass
				--25/Mar/2016 Gautam
				EXISTS (
					SELECT 1
					FROM StaffClients SC
					WHERE SC.StaffId = @StaffId
						AND SC.ClientId = C.ClientId
					)
				AND (
					@PayerId = - 1
					OR CP.PayerId = @PayerId
					)
				AND (
					@CoveragePlanId = - 1
					OR CP.CoveragePlanId = @CoveragePlanId
					)
				AND (
					@ClientId = - 1
					OR (
						Ch.Priority = 0
						AND S.ClientId = @ClientId
						)
					)
				AND (
					@DOSFrom IS NULL
					OR S.DateOfService >= @DOSFrom
					)
				AND (
					@DOSTo IS NULL
					OR S.DateOfService < DATEADD(dd, 1, @DOSTo)
					)
				AND (
					ISNULL(@IncludeCreditServices, 'N') = 'Y'
					OR NOT EXISTS (
						SELECT *
						FROM OpenCharges OC2
						WHERE OC2.ChargeId = Ch.ChargeId
							AND OC2.Balance < 0
						)
					)
				AND (
					@BatchNumbersExist = 'N'
					OR EXISTS (
						SELECT *
						FROM #BatchNumbers z
						JOIN ClaimBatchCharges y ON (z.ClaimBatchId = y.ClaimBatchId)
						WHERE y.ChargeId = ch.ChargeId
						)
					)
				AND (
					@ServiceId = - 1
					OR S.ServiceId = @ServiceId
					)
				--Added by Manju P Feb 04, 2014 - Core Bugs #1374 - Payments/Adjustment: Add Client Name Search criteria on pop up       
				AND (
					@ClientName IS NULL
					OR C.LastName LIKE '%' + @ClientName + '%'
					OR C.FirstName LIKE '%' + @ClientName + '%'
					OR C.OrganizationName LIKE '%' + @ClientName + '%'
					)
				-- Dhanil 03 Aug 2016
				AND (
					isnull(@ClientIdSearchParam, - 1) = - 1
					OR C.ClientId = @ClientIdSearchParam
					)
				AND (
					isnull(@ProcedureCodeId, - 1) <= 0
					OR PC.ProcedureCodeId = @ProcedureCodeId
					)
				AND (
					isnull(@ProgramId, - 1) <= 0
					OR P.ProgramId = @ProgramId
					)
				AND (
					ISNULL(@ClinicianName, '') = ''
					OR ST.LastName LIKE '%' + @ClinicianName + '%'
					OR ST.FirstName LIKE '%' + @ClinicianName + '%'
					OR (ST.LastName + ', ' + ST.FirstName) LIKE '%' + @ClinicianName + '%'
					)
				--Modified by Dhanil on 15 May 2015
				AND (
					@ClaimLineItemId = - 1
					OR EXISTS (
						SELECT ci.*
						FROM ClaimLineItemCharges CLIC
						JOIN dbo.ClaimLineItems CI ON CI.ClaimLineItemId = CLIC.ClaimLineItemId
						WHERE CLIC.ChargeId = CH.ChargeId
							AND ISNULL(CLIC.RecordDeleted, 'N') = 'N'
							AND ISNULL(CLIC.RecordDeleted, 'N') = 'N'
							AND CI.ClaimLineItemId = @ClaimLineItemId
						)
					)
				AND (
					ISNULL(@CPTCode, '') = '' --@CPTCode IS NULL TMU modification on 04/27/2017
					OR ch.BillingCode LIKE '%' + @CPTCode + '%'
					OR CH.RevenueCode LIKE '%' + @CPTCode + '%'
					)
				AND (
						ISNULL(@ExcludeErroredServices, 'N') = 'N'	--06/12/2018	Ravi
						OR (
							ISNULL(@ExcludeErroredServices, 'N') = 'Y'
							AND S.[Status] <> 76 --Error
							)
					)
			OPTION (RECOMPILE)
		END

		UPDATE t
		SET t.ClaimLineNumber = l.ClaimLineNumber
		FROM #ResultSet t
		JOIN (
			SELECT clic.ChargeId
				,MAX(clic.ClaimLineItemId) AS ClaimLineNumber
			FROM #ResultSet t1
			JOIN ClaimLineItemCharges clic ON t1.ChargeId = clic.ChargeId
			WHERE ISNULL(clic.RecordDeleted, 'N') = 'N'
			GROUP BY clic.ChargeId
			) l ON l.ChargeId = t.ChargeId

		-- 3/10/2016 Update next payer section moved to Ssp_pmpostpaymentsgetselectedservices
		UPDATE t
		SET Payment = l.Payment
			,Adjustment = l.Adjustment
			,Balance = l.Balance
			,LedgerType = l.LedgerType
		FROM #ResultSet t
		JOIN (
			SELECT arl.ChargeId
				,SUM(CASE 
						WHEN arl.LedgerType = 4202
							THEN arl.Amount
						ELSE 0
						END) AS Payment
				,SUM(CASE 
						WHEN arl.LedgerType = 4203
							THEN arl.Amount
						ELSE 0
						END) AS Adjustment
				,SUM(arl.Amount) AS Balance
				,MIN(arl.LedgerType) AS LedgerType
			FROM #ResultSet t1
			JOIN ARLedger arl ON t1.ChargeId = arl.ChargeId --WITH ( INDEX ( XIE1_ARLedger ) )
			WHERE ISNULL(arl.RecordDeleted, 'N') = 'N'
			GROUP BY arl.ChargeId
			) l ON l.ChargeId = t.ChargeId

		GetPage:

		IF @ApplyFilterClicked = 'N'
			AND EXISTS (
				SELECT *
				FROM ListPagePMPostPayments
				WHERE SessionId = @SessionId
					AND InstanceId = @InstanceId
					AND SortExpression = @SortExpression
				)
			GOTO Final

		--IF @PageNumber = 0      
		SET @PageNumber = 1

		IF @ApplyFilterClicked = 'N'
			INSERT INTO #ResultSet (
				ServiceId
				,ClientId
				,[Name]
				,DateOfService
				,Unit
				,Charge
				,ChargeId
				,Priority
				,Payment
				,Adjustment
				,Balance
				,LedgerType
				,ClaimBatchId
				,CoveragePlanId
				,NextPayer
				,IsSelected
				,CPTCode
				,ClaimLineNumber
				)
			SELECT ServiceId
				,ClientId
				,[Name]
				,DateOfService
				,Unit
				,Charge
				,ChargeId
				,Priority
				,Payment
				,Adjustment
				,Balance
				,LedgerType
				,ClaimBatchId
				,CoveragePlanId
				,NextPayer
				,IsSelected
				,CPTCode
				,ClaimLineNumber
			FROM ListPagePMPostPayments
			WHERE SessionId = @SessionId
				AND InstanceId = @InstanceId

		SET @strSQL = '
            UPDATE  d
            SET     RowNumber = rn.RowNumber ,
                    PageNumber = ( rn.RowNumber / ' + CONVERT(VARCHAR(100), @PageSize) + ' ) 
						+ CASE WHEN rn.RowNumber % ' + CONVERT(VARCHAR(100), @PageSize) + ' = 0 THEN 0
                                                                     ELSE 1
                                                                END
            FROM    #ResultSet d
                    JOIN ( SELECT   Identity1 ,
                                    ROW_NUMBER() OVER ( ORDER BY  
           '

		IF @SortExpression = 'Name'
		BEGIN
			SET @strSQL = @strSQL + ' Name,DateOfService asc'
		END
		ELSE IF @SortExpression = 'Name desc'
		BEGIN
			SET @strSQL = @strSQL + ' Name desc,DateOfService'
		END
		ELSE IF @SortExpression = 'ServiceId'
		BEGIN
			SET @strSQL = @strSQL + ' ServiceId,Name,DateOfService'
		END
		ELSE IF @SortExpression = 'ServiceId desc'
		BEGIN
			SET @strSQL = @strSQL + ' ServiceId desc,Name,DateOfService'
		END
		ELSE IF @SortExpression = 'DateOfService'
		BEGIN
			SET @strSQL = @strSQL + ' DateOfService,Name'
		END
		ELSE IF @SortExpression = 'DateOfService desc'
		BEGIN
			SET @strSQL = @strSQL + ' DateOfService desc,Name'
		END
		ELSE IF @SortExpression = 'Unit'
		BEGIN
			SET @strSQL = @strSQL + ' Unit,Name,DateOfService'
		END
		ELSE IF @SortExpression = 'Unit desc'
		BEGIN
			SET @strSQL = @strSQL + ' Unit desc,Name,DateOfService'
		END
		ELSE IF @SortExpression = 'Charge'
		BEGIN
			SET @strSQL = @strSQL + ' Charge,Name,DateOfService'
		END
		ELSE IF @SortExpression = 'Charge desc'
		BEGIN
			SET @strSQL = @strSQL + ' Charge desc,Name,DateOfService'
		END
		ELSE IF @SortExpression = 'Priority'
		BEGIN
			SET @strSQL = @strSQL + ' Priority,Name,DateOfService'
		END
		ELSE IF @SortExpression = 'Priority desc'
		BEGIN
			SET @strSQL = @strSQL + ' Priority desc,Name,DateOfService'
		END
		ELSE IF @SortExpression = 'Payment'
		BEGIN
			SET @strSQL = @strSQL + ' Payment,Name,DateOfService'
		END
		ELSE IF @SortExpression = 'Payment desc'
		BEGIN
			SET @strSQL = @strSQL + ' Payment desc ,Name,DateOfService'
		END
		ELSE IF @SortExpression = 'Adjustment'
		BEGIN
			SET @strSQL = @strSQL + ' Adjustment,Name,DateOfService'
		END
		ELSE IF @SortExpression = 'Adjustment desc'
		BEGIN
			SET @strSQL = @strSQL + ' Adjustment desc,Name,DateOfService'
		END
		ELSE IF @SortExpression = 'Balance'
		BEGIN
			SET @strSQL = @strSQL + ' Balance,Name,DateOfService'
		END
		ELSE IF @SortExpression = 'Balance desc'
		BEGIN
			SET @strSQL = @strSQL + ' Balance desc,Name,DateOfService'
		END
				-- 09-DEC-2016 Akwinass  
		ELSE IF @SortExpression = 'ProcedureCode'
		BEGIN
			SET @strSQL = @strSQL + ' ProcedureCode'
		END
		ELSE IF @SortExpression = 'ProcedureCode desc'
		BEGIN
			SET @strSQL = @strSQL + ' ProcedureCode desc'
		END
		ELSE IF @SortExpression = 'ProgramCode'
		BEGIN
			SET @strSQL = @strSQL + ' ProgramCode'
		END
		ELSE IF @SortExpression = 'ProgramCode desc'
		BEGIN
			SET @strSQL = @strSQL + ' ProgramCode desc'
		END
		ELSE IF @SortExpression = 'ClinicianName'
		BEGIN
			SET @strSQL = @strSQL + ' ClinicianName'
		END
		ELSE IF @SortExpression = 'ClinicianName desc'
		BEGIN
			SET @strSQL = @strSQL + ' ClinicianName desc'
		END
		ELSE IF @SortExpression = 'CPTCode'
		BEGIN
			SET @strSQL = @strSQL + ' CPTCode,Name, DateOfService'
		END
		ELSE IF @SortExpression = 'CPTCode desc'
		BEGIN
			SET @strSQL = @strSQL + ' CPTCode desc, Name, DateOfService'
		END
		ELSE IF @SortExpression = 'ClaimLineNumber'
		BEGIN
			SET @strSQL = @strSQL + ' ClaimLineNumber,Name, DateOfService'
		END
		ELSE IF @SortExpression = 'ClaimLineNumber desc'
		BEGIN
			SET @strSQL = @strSQL + ' ClaimLineNumber desc, Name, DateOfService'
		END
		ELSE
		BEGIN
			SET @strSQL = @strSQL + ' ServiceId'
		END

		SET @strSQL = @strSQL + ' ) AS RowNumber
                           FROM     #ResultSet
                         ) rn ON rn.Identity1 = d.Identity1       '

		EXEC sp_executeSQL @strSQL

		DELETE
		FROM ListPagePMPostPayments
		WHERE SessionId = @SessionId
			AND InstanceId = @InstanceId

		IF @ChargesDummyXML IS NOT NULL -- 09-DEC-2016 Akwinass
		BEGIN
			UPDATE RS
			SET RS.IsSelected = 1
			FROM #ResultSet RS
			WHERE EXISTS (
					SELECT 1
					FROM @ChargesDummyXML.nodes('NewDataSet/ChargesDummy') a(b)
					WHERE a.b.value('ServiceId[1]', 'INT') = RS.ServiceId
						AND a.b.value('ChargeId[1]', 'INT') = RS.ChargeId
					)
		END

		INSERT INTO ListPagePMPostPayments (
			SessionId
			,InstanceId
			,RowNumber
			,PageNumber
			,SortExpression
			,RadioButton
			,ServiceId
			,ClientId
			,[Name]
			,DateOfService
			,Unit
			,Charge
			,ChargeId
			,Priority
			,Payment
			,Adjustment
			,Balance
			,LedgerType
			,ClaimBatchId
			,CoveragePlanId
			,NextPayer
			,IsSelected
			,CPTCode
			,ClaimLineNumber
			)
		SELECT @SessionId
			,@InstanceId
			,RowNumber
			,PageNumber
			,@SortExpression
			,RadioButton
			,ServiceId
			,ClientId
			,[Name]
			,DateOfService
			,CASE 
				WHEN LEN(Unit) > 250
					THEN SUBSTRING(Unit, 0, 247) + '...'
				ELSE Unit
				END AS Unit
			,Charge
			,ChargeId
			,Priority
			,Payment
			,Adjustment
			,Balance
			,LedgerType
			,ClaimBatchId
			,CoveragePlanId
			,NextPayer
			,IsSelected
			,CPTCode
			,ClaimLineNumber
		FROM #ResultSet

		Final:

		--BEGIN Included for handling checkbox       
		IF LOWER(@RowSelectionList) = 'all'
		BEGIN
			UPDATE ListPagePMPostPayments
			SET IsSelected = 1
			WHERE SessionId = @SessionId
				AND InstanceId = @InstanceId
		END
		ELSE
		BEGIN
			IF LOWER(@RowSelectionList) = 'none'
			BEGIN
				UPDATE ListPagePMPostPayments
				SET IsSelected = 0
				WHERE SessionId = @SessionId
					AND InstanceId = @InstanceId
			END
			ELSE IF LOWER(@RowSelectionList) = 'allonpage'
			BEGIN
				UPDATE ListPagePMPostPayments
				SET IsSelected = 1
				WHERE SessionId = @SessionId
					AND InstanceId = @InstanceId
					AND PageNumber = @PageNumber
			END
			ELSE IF (CHARINDEX(',', @RowSelectionList) > 0)
				--IF ISNULL(@RowSelectionList,'') <> ''
			BEGIN
				--Changes By Deej - 14-July-2014
				-- Included @SessionId and @InstanceId check in the where clause
				UPDATE ListPagePMPostPayments
				SET IsSelected = a.IsSelected
				FROM #RowSelection a
				WHERE a.ServiceId = ListPagePMPostPayments.ServiceId
					AND SessionId = @SessionId
					AND InstanceId = @InstanceId
					-- Deej Changes Ends here
			END
		END

		--Lakshmi 3/8/2017 Commentes End
		--                                       
		SELECT @PageNumber AS PageNumber
			,ISNULL(MAX(PageNumber), 0) AS NumberOfPages
			,ISNULL(MAX(RowNumber), 0) AS NumberOfRows
			,'' AS ArrayList
		FROM ListPagePMPostPayments
		WHERE SessionId = @SessionId
			AND InstanceId = @InstanceId

		DECLARE @SumBalance VARCHAR(100) -- 09-DEC-2016 Akwinass

		SELECT @SumBalance = CONVERT(VARCHAR, SUM(LP.Balance), 100)
		FROM ListPagePMPostPayments LP
		WHERE LP.SessionId = @SessionId
			AND LP.InstanceId = @InstanceId
			AND (
				@ServiceId = - 1
				OR LP.ServiceId = @ServiceId
				)
			AND ISNULL(LP.IsSelected, 0) = 1

		SELECT LP.PageNumber
			,LP.ServiceId
			,LP.ClientId
			,LP.[Name]
			,LP.DateOfService
			,CONVERT(VARCHAR, LP.DateOfService, 101) + ' ' + LTRIM(SUBSTRING(CONVERT(VARCHAR(19), LP.DateOfService, 100), 12, 6)) + ' ' + LTRIM(SUBSTRING(CONVERT(VARCHAR(19), LP.DateOfService, 100), 18, 3)) AS DateOfServiceFormatted
			,LP.Unit
			,LP.Charge
			,LP.ChargeId
			,LP.Priority
			,'$' + CONVERT(VARCHAR, LP.Payment * - 1, 10) AS Payment
			,'$' + CONVERT(VARCHAR, LP.Adjustment * - 1, 10) AS Adjustment
			,'$' + CONVERT(VARCHAR, LP.Balance, 10) AS BalanceForGird
			,LP.Balance
			,LP.LedgerType
			,LP.ClaimBatchId
			,LP.CoveragePlanId
			,LP.NextPayer
			,LP.IsSelected
			,LP.ListPagePMPostPaymentId
			,LP.RowNumber
			,
			-- 09-DEC-2016 Akwinass
			P.ProgramCode
			,PC.DisplayAs AS ProcedureCode
			,ST.LastName + ', ' + ST.FirstName AS ClinicianName
			,@SumBalance AS SumBalance
			,LP.CPTCode AS CPTCode
			,LP.ClaimLineNumber AS ClaimLineNumber
		FROM ListPagePMPostPayments LP
		LEFT JOIN Services S ON LP.ServiceId = S.ServiceId
			AND isnull(S.RecordDeleted, 'N') = 'N' -- msood 4/28/2017
		LEFT JOIN Programs P ON S.ProgramId = P.ProgramId
		LEFT JOIN ProcedureCodes PC ON S.ProcedureCodeId = PC.ProcedureCodeId
		LEFT JOIN Staff ST ON S.ClinicianId = ST.StaffId
		WHERE LP.SessionId = @SessionId
			AND LP.InstanceId = @InstanceId
			AND (
				(
					@ServiceId = - 1
					AND LP.PageNumber = @PageNumber
					)
				OR (@ServiceId <> - 1)
				)
			AND (
				@ServiceId = - 1
				OR LP.ServiceId = @ServiceId
				)
		ORDER BY PageNumber
			,RowNumber

		CREATE TABLE #ClientList (ClientId INT)

		WHILE (CHARINDEX(',', @ClientIdNew) > 0)
		BEGIN
			DECLARE @Form VARCHAR(30)

			SET @Form = SUBSTRING(@ClientIdNew, 0, CHARINDEX(',', @ClientIdNew))

			INSERT INTO #ClientList
			VALUES (@Form)

			SET @ClientIdNew = SUBSTRING(@ClientIdNew, CHARINDEX(',', @ClientIdNew) + 1, LEN(@ClientIdNew))
		END

		-- Select coverage plans that can be use for Transfer To			
		SELECT DISTINCT ccp.ClientCoveragePlanId
			,cp.CoveragePlanId
			,cp.DisplayAs + ' ' + ISNULL(ccp.InsuredId, '') + '(' + CONVERT(VARCHAR, ISNULL(cch.COBOrder, '')) + ')' AS DisplayAs
			,s.ClientId
			,cch.StartDate
			,cch.EndDate
			,cch.CobOrder
			,s.ServiceId
			,p.ServiceAreaId
			,s.ProgramId
		FROM #ResultSet t
		JOIN #ClientList cl ON cl.ClientId = t.ClientId
		JOIN Services s ON s.ServiceId = t.ServiceId
			AND isnull(S.RecordDeleted, 'N') = 'N' -- msood 4/28/2017
		JOIN Programs p ON p.ProgramId = s.ProgramId
		JOIN ClientCoveragePlans ccp ON ccp.ClientId = s.ClientId
		JOIN ClientCoverageHistory cch ON cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
			AND cch.ServiceAreaId = p.ServiceAreaId
		JOIN CoveragePlans cp ON cp.CoveragePlanId = ccp.CoveragePlanId
		LEFT JOIN Charges c ON c.ChargeId = t.ChargeId
			AND ISNULL(c.RecordDeleted, 'N') = 'N'
		WHERE (
				c.ClientCoveragePlanId IS NULL
				OR c.ClientCoveragePlanId <> ccp.ClientCoveragePlanId
				)
			AND cch.StartDate <= s.DateOfService
			AND (
				cch.EndDate IS NULL
				OR DATEADD(dd, 1, cch.EndDate) > s.DateOfService
				)
			AND ISNULL(ccp.RecordDeleted, 'N') = 'N'
			AND ISNULL(cch.RecordDeleted, 'N') = 'N'
			-- Check if procedure is billable
			AND NOT EXISTS (
				SELECT *
				FROM CoveragePlanRules cpr
				WHERE (
						(
							cpr.CoveragePlanId = cp.CoveragePlanId
							AND ISNULL(cp.BillingRulesTemplate, 'T') = 'T'
							)
						OR (
							cpr.CoveragePlanId = cp.UseBillingRulesTemplateId
							AND ISNULL(cp.BillingRulesTemplate, 'T') = 'O'
							)
						)
					AND cpr.RuleTypeId = 4267
					AND ISNULL(cpr.RecordDeleted, 'N') = 'N'
					AND (
						cpr.AppliesToAllProcedureCodes = 'Y'
						OR EXISTS (
							SELECT *
							FROM CoveragePlanRuleVariables cprv
							WHERE cprv.CoveragePlanRuleId = cpr.CoveragePlanRuleId
								AND cprv.ProcedureCodeId = s.ProcedureCodeId
								AND ISNULL(cprv.RecordDeleted, 'N') = 'N'
							)
						)
				)
			-- Check if Program is billable
			AND NOT EXISTS (
				SELECT *
				FROM ProgramPlans pp
				WHERE pp.CoveragePlanId = cp.CoveragePlanId
					AND pp.ProgramId = s.ProgramId
					AND ISNULL(pp.RecordDeleted, 'N') = 'N'
				)
		ORDER BY s.ServiceId
			,cch.CobOrder

		DROP TABLE #ClientList
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PMPostPaymentsServicesSearchSel') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.      
				16
				,-- Severity.      
				1 -- State.      
				);
	END CATCH

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
GO


