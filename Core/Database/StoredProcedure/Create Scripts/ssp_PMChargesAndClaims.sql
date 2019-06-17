/****** Object:  StoredProcedure [dbo].[ssp_PMChargesAndClaims]    Script Date: 10/19/2015 10:51:17 ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_PMChargesAndClaims]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE dbo.ssp_PMChargesAndClaims
GO

/****** Object:  StoredProcedure [dbo].[ssp_PMChargesAndClaims]    Script Date: 10/19/2015 10:51:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_PMChargesAndClaims]
    @SessionId VARCHAR(30) ,
    @InstanceId INT ,
    @PageNumber INT ,
    @PageSize INT ,
    @SortExpression VARCHAR(100) ,
    @PlanType INT ,
    @PayerId INT ,
    @CoveragePlanId INT ,
    @ProgramId INT ,
    @ReadyToBill INT ,
    @ShowCharges INT ,
    @ChargeErrorType INT ,
    @Priority INT ,
    @ServiceId INT ,
    @ChargeId INT ,
    @ClaimProcessId INT ,
    @ClaimBatchId INT ,
    @ClientId INT ,
    @DOSFrom DATETIME ,
    @DOSTo DATETIME ,
    @ProcessedFrom DATETIME ,
    @ProcessedTo DATETIME ,
    @ChargesWithBalance INT ,
    @RowSelectionList VARCHAR(MAX) ,
    @OtherFilter INT ,
    @StaffId INT ,
    @ProcedureCodeId INT = -1 ,
    @LocationId INT ,
    @FinancialAssignmentId INT ,
    @ServiceAreaId INT ,
    @DashBoardPayerType INT = NULL ,
    @Capitated CHAR(2) = NULL ,
    @ChargesWithPositiveBalance INT ,
    @ClinicianId INT = NULL ,
    @IncludedErrorServices VARCHAR(3) = 'N' ,
    @ShowChargesInCollections VARCHAR(3) = 'N' ,
    @NumOfStatements INT = -1 ,
    @ChargeCreationFrom DATETIME = NULL ,
    @ChargeCreationTo DATETIME = NULL ,
    @ExcludeFromWorkQueue VARCHAR(3) = 'N'  --Added by Ajay on 26 July 2017
    ,
    @NotCountedTowardWQP VARCHAR(3) = 'N'  --Added by Ajay on 26 July 2017
    ,@ChargesWithBalancesGreaterThanZero Char(1)='N' --Added by Swatika Shinde on 14 Nov 2018
	/********************************************************************************                                                        
-- Stored Procedure: ssp_PMChargesAndClaims       
--       
-- Copyright: Streamline Healthcate Solutions       
--       
-- Purpose: Query to return data for the Charges and Claims list page.       
--       
-- Author:  Girish Sanaba       
-- Date:    28 Apr 2011       
--       
-- *****History****       
-- 05.23.2011      SFarber        Redesigned to improve performance.       
-- 08.29.2011      Girish        Added recorddeleted check to coverage plans and clientcoverageplans      
-- 08.30.2011      MSuma        Included additional Logic to match Dashboard values for ALl Claims for Clients      
-- 10.07.2011      Girish        Added condition for isselected check for allonpage       
-- 18.10.2011      MSuma        Added RecordDeleted check- To resolve issues with Charged Details page      
-- 23.11.2011      MSuma        Added RecordDeleted check- for Charges       
-- 05.12.2011      MSuma        Modified Left Join on CoveragePlan       
-- 28.03.2012      Shruthi.S      Pulled cache table removed changes        
-- 4.04.2012      Ponnin Selvan    Conditions added for Export        
-- 05.04.2012      Shruthi.S      Added a check for null and setting default charge and balance      
-- 12.04.2012      MSUma        Removed Temp table       
-- 13.04.2012      PSelvan        Added Conditions for NumberOfPages.        
-- 15.04.2012      MSuma        Moved all the required column on Join to #ChargeFilters for performance tuning       
-- 20.04.2012      MSuma        Moved Join on Services        
-- 14.05.2012     Pselvan        For the Kalamazoo Ace task #1193       
-- 14.06.2012     Pselvan        Modified int datatype to money to according to DashBoard value      
-- 14.06.2012     Pselvan        For the Kalamazoo Ace task # 1553       
-- 27.06.2012     MSuma        Modified Varchar(4000) to MAX       
-- 5.07.2012      MSuma        Added Max from SP for performance       
-- 06.10.2013     John S        Added "@ProcedureCodeId" parameter to support search by ProcedureCodes(Task 147 - InteractSupport)    
-- 06.15.2013     SFarber        Moved create index on #ChargeFilters to right after the insert to improve performance    
-- OCT-28-2013    dharvey        Added LEFT join on ClientCoveragePlans and CoveragePlans 
-- 10.31.2013     Changed        @ProcessedFrom/@ProcessedTo logic to look at BillingHistory instead of last billed date
-- 17.12.2014     Revathi        what:One more Parameter @LocationId added to filter LocationName 
                    why:task #179 MFS - Customizations  
-- 09.04.2015           Arjun K R           Counts does not match when we select "show billed and unbilled" and "Show unbilled and rebill" issue is fixed. 
--                                          Task #89 WMU Customization Issues Tracking. 
--17.Apr.2015    Revathi        what:FinancialAssignment filter added why:task #950 Valley - Customizations 
-- 09.11.2015    JHB          Added logic to show Do Not Bill Charges, 
							Engineering Improvement Initiatives- NBL(I) ,Task #218 ,Updates for Charges/Claims SP                    
--05.10.2015    Vaibhav        What: Adding Service Area and ServiceAreaId Filter field in Charges/Claims list page Task #221  Engineering Improvement Initiatives- NBL(I)
--22.Oct.2015   Gautam         Added code to include ChargeErrors  for all the cases . why : Filter was not working on "show billed and unbilled charges" with Error Reasons
								for Woodlands - Support # 176  
--06.Nov.2015	Shankha			Changed the logic for the @Priority to								 
--06.Nov.2015   Revathi		 what:@DashBoardPayerType why:task #950 	Valley - Customizations			
--10.Nov.2015   Gautam      Added code for @Capitated Parameter added , Engineering Improvement Initiatives- NBL(I) - #226	
--10.Dec.2015   Gautam      Added code for Clinician,Procedure sorting , Core Bugs - #1944		
--21-DEC-2015   Basudev Sahu Modified For Task #609 Network180 Customization to Get Organisation  As ClientName	
--02.Feb.2016   Veena       Changed Capitated/NonCapitated to Yes/No in the grid ,Engineering Improvement Initiatives- NBL(I) #274		
--17.Feb.2016	NJain		Updated to include RecordDeleted data from ClientCoveragePlans	
--28.Feb.2016	 jcarlson		  removed rebill condition from show charges = 580 statements	
-- 22.Mar.2016  jcarlson	   	removed record delete check(S) in PaymentResultSet CTE
-- 01.Apr.2016  Gautam      Added code in Where clause to check @ChargesWithBalance selected or not.Why: Condition was not checked earlier,
							Woodlands - Support > Tasks#271 > SC: TRAIN: 2: Charges- with balance 
-- 04.April.2016 Manjunath K	Added code in @WhereTemp to check @ProcedureCodeId. 
--								Why:On 'Show unbilled and rebill charges' drop down selection (@ShowCharges=583),
--								It was not checking condition for ProcedureCodeId. Harbor - Support #888.
-- 12.July.2016	Wasif Butt		Filter client charges when 'Financial Assignment' says not to include Client charges for 'All Payer Types'. Bradford SGL # 54
-- 27.July.2016	Nandita			Implemented Show chanrges with credit checkbox
-- 09.Aug.2016  Jcarlson			fixed bug where when user select "unbilled charges", they system would ignore the Balance checkbox and always put a join on to OpenCharges
-- 28.Aug.2016 	MJensen			Correct problem with Batch & process numbers not displaying - Thresholds task #711 
-- 05.OCT.2016	Dknewtson		Included Filters for Void Charges
-- 09.Nov.2016  Gautam			Added fiter on @ClinicianId & @IncludedErrorServices (include/exclude all error services ) & included Jcarlson code, Task#567, Allegan - support
-- 04.Jan.2017	Govind			Replaced PaymentResultSet & RankResultSet CTE with Temp Tables to reduce time taken to calculate
--								sum(charges) and sum(balance) - Performance Improvement - ARC Support Go Live Task#114
-- 08.Feb.2017 Ponnin			SET @ClinicianId = -1 if the input parameter value is 0. Why : For task #324 of Bradford - Support Go Live
-- 10.Feb.2017 Gautam           Removed the code for @DashBoardPayerType parameter passed from dashboard and coded for Financial Assignment filter as normal filter not union 
								why :  No need to send special variable for the dashboard on the list page, #267, Bradford - Support Go Live 
-- 02.Feb.2017 jcarlson			removed hardcoded join to opencharges, this should only be added based on the check boxes -- ChargesWithBalance and ChargesWithBalanceWithPositiveBalance
								Bradford SGL 310
-- 10 Feb 2017	Vithobha		Added @ShowChargesInCollections param for Renaissance - Dev Items #830
-- 27.FEB.2017  Dknewtson       Cleaned up dynamic code, removed duplicate conditions, moved most of the filter code to prior to any @ShowCharge conditions. 
								Executing dynamic sql once for each kind of @ShowCharge (unbilled, rebilled, billed etc.) so we can reuse code.
								Removing autoincluded joins to open charges for unbilled and rebill. Bradford SGL #310
-- 01 Mar 2017  Pradeep Y		Added logic to Append  ClientId with ClientName
--								For Task #1092 Harbor-Support
-- 23 Mar 2017  Dknewtson		Removed intermediary temp table insert - unneccesary. Removal improves performance.
-- 18 APRIL 2017 Akwinass       Added filter logic for "Charge Creation From Date", "Charge Creation To Date" and "# of Client Statements Since Charge Creation" (Task #830.1 in  	Renaissance - Dev Items)
-- 12 MAY 2017	dknewtson		adding clustered index to #ChargeFilters to bypass a page allocation error in SQL Server 2008 R2 https://support.microsoft.com/en-us/help/974006/sql-server-query-optimizer-hotfix-trace-flag-4199-servicing-model
								Removed "TotalSumCharges" and replaced with "TotalSelectedCharges" as column name has changed in the table.
-- 16 MAY 2017  Dknewtson		Adding or conditions for additional Show Charges filters that were missing for unbilled charges, rebill and voids when we are also filtering for replacement charges.
-- 12 JUNE 2017 Dknewtson		Correcting an issue with pagination. Valley Support Go Live #1233
-- 13 July 2017 NJain			When doing the final insert into #FinalResultSet, replaced @sql with regular sql insert statement Bradford SGL #456
-- 07 July 2017 NJain			Reverting the changes above. It broke the sort functionality
-- 27 July 2017 Dknewtson		Removed check for NULL OriginalClaimLineItemId when filtering for replacements. We can replace a replaced claim. VSGL - 1280
-- 03 Aug  2017 jcarlson		Added isnull check for parameter @SumBalances incase none of the charges selected have a balance, this will still allow the @sql statement to be built
								 Bradford SGL 475
-- 16 June 2017 Ajay            1.Added condition for AdjustmentCode applied in financial assignment, 
--                              2.Added condition for Exclude Payer Charges
--                              3.Added condition for Exclude if Client is not financially Responsible or its contact is not financially Responsible.
--                              4.Added two filters @ExcludeFromWorkQueue and @NotCountedTowardWQP 
--								AHN-Customization:#44
-- 23 Mar 2018 Gautam           Replaced COALESCE with XML to display comma seperated value when we select "ALL" on page due to performance issue, .
								Task#401,BC1: 2018 : Error is getting displayed when clicking on 'ALL' in 'Charges/Claim' 
-- 04 Apr 2018 NJain			Boundless Support #214
								When filtering for Unbilled and Replacement Charges, Unbilled charges were not showing up. Added 590 to condition for Unbilled charges		
--12 SEP 2018  Lakshmi         What: @IncludedErrorServices parameter empty check has been added because in result set it is listing errored										services and it was causing the issue for enduser.
							   Why: @IncludedErrorServices parameter comming empty when procedure get executed. Valley - Support Go Live #1588			
				
--17 SEP 2018  Lakshmi        What: the temp table (#PaymentResultSetTable) data not ordered properly and it was causing pagination issue.										so we ordered data based on temp table ResultSetId since it is an identity column.
							  Why:  Valley - Support Go Live #1588		
-- 20 Sep 2018 Dknewtson		Going through DocumentMoves table to find charges marked to be corrected. Philhaven - Support #337.1
-- 12- Oct-2018  Sachin      What: When user is clicking on "ALL" option on Charges/Claims list page, The IncludedErrorServices is passing "No" instead of "N" hence the wrong values are showing on Claims Processing popup.
							 Why: @IncludedErrorServices parameter comming "No" when procedure get executed. CCC - Support Go Live# 66	
-- 14- Nov-2018  Swatika     What/Why: Added new parameter @ChargesWithBalancesGreaterThanZero for  Charges/Claims list page filter to show balances greater than zero. 
							  Thresholds - Enhancements Task #39	
-- 16- Nov-2018  K.Soujanya   What/Why: Added 'Units' column to show in Charges/Claims list page grid/Ref.CEI - Enhancements Task #15	
-- 27 Nov 2018  Chita Ranjan  What/Why: Added two columns ToBeVoided and ToBeResubmitted in the select statement. These two columns are required to check if a charge is 'voided' or 'replaced'.
							  Valley - Enhancements Task #1212	
-- 01- Feb-2019  K.Soujanya   What/Why: Added 'AttendingStaffName' and AttendingStaffId columns in the select statement to show in Charges/Claims list page grid/Ref.AHN - Enhancements Task #41							  				 						  							 						  								 						  			
*********************************************************************************/
AS
    BEGIN
        SET NOCOUNT ON
        BEGIN TRY
		
            IF @ClinicianId = 0
                SET @ClinicianId = -1 
			
            IF @ProcedureCodeId = 0
                SET @ProcedureCodeId = -1

            IF @ServiceAreaId = 0
                SET @ServiceAreaId = -1
                
            IF @IncludedErrorServices='' --Added by Lakshmi on 12-09-2018
				SET @IncludedErrorServices='N'
				
			IF @IncludedErrorServices='No' --Added by Sachin on 12-10-2018
				SET @IncludedErrorServices='N'
---------------------------------------------------------------------------------------------------------
            CREATE TABLE #PaymentResultSetTable
                (
                  ResultSetId INT IDENTITY ,
                  ChargeId INT ,
                  CoveragePlanId INT ,
                  CoveragePlanName VARCHAR(MAX) ,
                  ClientId INT ,
                  ClientName VARCHAR(MAX) ,
                  ServiceId INT ,
                  DateOfService DATETIME ,
                  StaffId INT ,
                  Clinician VARCHAR(MAX) ,
                  ProcedureCodeId INT ,
                  ProcedureCode VARCHAR(MAX) ,
                  Charge MONEY ,
                  Balance MONEY ,
                  Unbilled VARCHAR(MAX) ,
                  PaidAmount MONEY ,
                  PaymentId INT ,
                  PaymentFinancialActivityId INT ,
                  PaymentFinancialActivityLineId INT ,
                  BillDate DATETIME ,
                  ClaimProcessId INT ,
                  ClaimBatchId INT ,
                  ClaimFormatElectronic VARCHAR(MAX) ,
                  PRIORITY VARCHAR(MAX) ,
                  ErrorMessage VARCHAR(MAX) ,
                  IsSelected VARCHAR(MAX) ,
                  LocationName VARCHAR(MAX) ,
                  ServiceAreaName VARCHAR(MAX) ,
                  Flagged VARCHAR(MAX) ,
                  Comments VARCHAR(MAX) ,
                  ClaimLineItemId INT ,
                  ProgramName VARCHAR(MAX) ,
                  Capitated VARCHAR(MAX) ,
                  Units decimal(18,2),
                  AttendingStaffId INT,--Added by K.Soujanya on 02/01/2019
                  AttendingStaffName VARCHAR(100),
                  TotalRows INT ,
                  RowNumber INT ,
                  TotalSelectedCharges MONEY ,
                  TotalSelectedBalances MONEY,
                  ToBeVoided varchar(1),
				  ToBeResubmitted varchar(1)
                )
--------------------------------------------------------------------------------
            CREATE TABLE #FinalResultSet
                (
                  RowNumber INT ,
                  ChargeId INT ,
                  CoveragePlanId INT ,
                  CoveragePlanName VARCHAR(MAX) ,
                  ClientId INT ,
                  ClientName VARCHAR(MAX) ,
                  ServiceId INT ,
                  DateOfService DATETIME ,
                  StaffId INT ,
                  Clinician VARCHAR(MAX) ,
                  ProcedureCodeId INT ,
                  ProcedureCode VARCHAR(MAX) ,
                  Charge MONEY ,
                  Balance MONEY ,
                  Unbilled VARCHAR(MAX) ,
                  PaidAmount MONEY ,
                  PaymentId INT ,
                  PaymentFinancialActivityId INT ,
                  PaymentFinancialActivityLineId INT ,
                  BillDate DATETIME ,
                  ClaimProcessId INT ,
                  ClaimBatchId INT ,
                  ClaimFormatElectronic VARCHAR(MAX) ,
                  PRIORITY VARCHAR(MAX) ,
                  ErrorMessage VARCHAR(MAX) ,
                  IsSelected VARCHAR(MAX) ,
                  LocationName VARCHAR(MAX) ,
                  ServiceAreaName VARCHAR(MAX) ,
                  Flagged VARCHAR(MAX) ,
                  Comments VARCHAR(MAX) ,
                  ClaimLineItemId INT ,
                  ProgramName VARCHAR(MAX) ,
                  Capitated VARCHAR(MAX) ,
                  Units decimal(18,2),
                  AttendingStaffId INT, --Added by K.Soujanya on 02/01/2019
                  AttendingStaffName VARCHAR(100),
                  TotalCount INT ,
                  TotalSelectedCharges MONEY ,
                  TotalSelectedBalances MONEY,
                  ToBeVoided varchar(1),
				  ToBeResubmitted varchar(1)
                )
-------------------------------------
--------------------------------------------------------------------------------
            CREATE TABLE #ChargeFilters
                (
                  ChargeId INT ,
                  ClaimBatchId INT ,
                  ClaimProcessId INT ,
                  ClaimFormatElectronic CHAR(1) ,
                  MaxChargeErrorId INT ,
                  ErrorMessage VARCHAR(1000) ,
                  LastBilledDate DATETIME ,
                  Priority INT ,
                  ClientCoveragePlanId INT ,
                  ServiceId INT ,
                  DateOfService DATETIME ,
                  Charge MONEY ,
                  ClientId INT ,
                  ClinicianId INT ,
                  ProcedureCodeId INT ,
                  LocationId INT ,--Added by Revathi 17.12.2014   
                  ProgramId INT --Added by Vaibhav 10.05.2015  
			-- Added by Shankha 10/13/15 
                  ,
                  Comments VARCHAR(MAX) ,
                  Flagged CHAR(1) ,
                  ClaimLineItemId INT,
                  Units decimal(18,2),
                  ToBeVoided varchar(1),
				  ToBeResubmitted varchar(1),
				  AttendingStaffId INT --Added by K.Soujanya on 02/01/2019 
                )

            CREATE CLUSTERED INDEX XI_Temp_ChargeFiltersChargeId ON #ChargeFilters(ChargeId)

            CREATE TABLE #Payments
                (
                  ChargeId INT ,
                  PaidAmount MONEY ,
                  PaymentId INT ,
                  FinancialActivityId INT ,
                  FinancialActivityLineId INT
                )

            CREATE TABLE #ChargeErrors
                (
                  ChargeId INT ,
                  MaxChargeErrorId INT ,
                  ErrorMessage VARCHAR(500)
                )

            CREATE TABLE #ChargeErrorsAll
                (
                  ChargeId INT ,
                  ChargeErrorId INT ,
                  Errordescription VARCHAR(500)
                )

            DECLARE @SqlStatement NVARCHAR(MAX)
            DECLARE @From VARCHAR(MAX)
            DECLARE @Where VARCHAR(MAX)
            DECLARE @InsertString NVARCHAR(MAX)
            DECLARE @ApplyFilterClicked CHAR(1)
            DECLARE @CustomFiltersApplied CHAR(1)
		-- Arjun K R  09/04/2015   
            DECLARE @FromTemp VARCHAR(MAX)
            DECLARE @WhereTemp VARCHAR(MAX)

            IF ISNULL(@SortExpression, '') = ''
                SET @SortExpression = 'CoveragePlanName'

		--Added by Revathi 17.Apr.2015            
            DECLARE @ChargeResponsibleDays INT
            DECLARE @ClientFirstLastName VARCHAR(25)
            DECLARE @ClientLastLastName VARCHAR(25)
            DECLARE @ClientLastNameCount INT = 0
            DECLARE @IncludeClientCharge CHAR(1)

            CREATE TABLE #ClientLastNameSearch
                (
                  LastNameSearch VARCHAR(50)
                )

            IF ISNULL(@FinancialAssignmentId, -1) <> -1
                BEGIN
                    SELECT  @ClientFirstLastName = FinancialAssignmentChargeClientLastNameFrom ,
                            @ClientLastLastName = FinancialAssignmentChargeClientLastNameTo
                    FROM    dbo.FinancialAssignments
                    WHERE   FinancialAssignmentId = @FinancialAssignmentId
                            AND ISNULL(RecordDeleted, 'N') = 'N'

                    INSERT  INTO #ClientLastNameSearch
                            EXEC dbo.ssp_SCGetPatientSearchValues @ClientFirstLastName,
                                @ClientLastLastName

                    IF EXISTS ( SELECT  1
                                FROM    #ClientLastNameSearch )
                        BEGIN
                            SET @ClientLastNameCount = 1
                        END
                END

		--          
		-- New retrieve - the request came by clicking on the Apply Filter button                           
		--         
            SET @ApplyFilterClicked = 'Y'
            SET @CustomFiltersApplied = 'N'

		--set @PageNumber = 1         
            IF @OtherFilter > 10000
                OR @ShowCharges > 10000
                OR @Priority > 10000
                BEGIN
                    SET @CustomFiltersApplied = 'Y'

                    INSERT  INTO #ChargeFilters
                            ( ChargeId
							)
                            EXEC dbo.scsp_PMChargesAndClaims @PlanType = @PlanType,
                                @PayerId = @PayerId,
                                @CoveragePlanId = @CoveragePlanId,
                                @ProgramId = @ProgramId,
                                @ReadyToBill = @ReadyToBill,
                                @ShowCharges = @ShowCharges,
                                @ChargeErrorType = @ChargeErrorType,
                                @Priority = @Priority, @ServiceId = @ServiceId,
                                @ChargeId = @ChargeId,
                                @ClaimProcessId = @ClaimProcessId,
                                @ClaimBatchId = @ClaimBatchId,
                                @ClientId = @ClientId, @DOSFrom = @DOSFrom,
                                @DOSTo = @DOSTo,
                                @ProcessedFrom = @ProcessedFrom,
                                @ProcessedTo = @ProcessedTo,
                                @ChargesWithBalance = @ChargesWithBalance,
                                @RowSelectionList = @RowSelectionList,
                                @OtherFilter = @OtherFilter,
                                @StaffId = @StaffId

                    GOTO common
                END

		-- Build sql to filter charges if custom filter has not been applied         
            SET @From = ''
            SET @Where = ''

            IF ISNULL(@ChargeId, -1) <> -1
                SET @Where = @Where + ' and ch.ChargeId = '
                    + CONVERT(VARCHAR, @ChargeId)

            IF ISNULL(@ServiceId, -1) <> -1
                SET @Where = @Where + ' and ch.ServiceId = '
                    + CONVERT(VARCHAR, @ServiceId)

            IF ISNULL(@ClientId, -1) <> -1
                SET @Where = @Where + ' and s.ClientId = '
                    + CONVERT(VARCHAR, @ClientId)
			
			-- 09.Nov.2016  Gautam
            IF ISNULL(@ClinicianId, -1) <> -1
                SET @Where = @Where + ' and s.ClinicianId = '
                    + CONVERT(VARCHAR, @ClinicianId);  
            
            IF ISNULL(@IncludedErrorServices, 'N') = 'N'
                SET @Where = @Where + ' and s.Status <> 76 '  
            
            ----Added by Ajay on 26 July 2017 on  16-June-2017
            IF ISNULL(@ExcludeFromWorkQueue, 'N') = 'Y'
                SET @Where = @Where
                    + ' and ch.ExcludeChargeFromQueue = ''Y'' '  
             
            IF ISNULL(@NotCountedTowardWQP, 'N') = 'Y'
                SET @Where = @Where
                    + ' and ch.DoNotCountTowardProductivity = ''Y'' '  
                
                -- 10 Feb 2017	Vithobha
            IF ISNULL(@ShowChargesInCollections, 'N') = 'Y'
                SET @Where = @Where
                    + ' and EXISTS(SELECT TOP 1 COCH.InternalCollectionChargeId FROM InternalCollectionCharges COCH JOIN Collections CO ON COCH.CollectionId = CO.CollectionId AND ISNULL(COCH.RecordDeleted, ''N'') = ''N'' AND ISNULL(CO.RecordDeleted, ''N'') = ''N'' AND COCH.ChargeId = ch.ChargeId) '
          
			-- 18 APRIL 2017 Akwinass
            IF ISNULL(@ChargeCreationFrom, '') <> ''
                AND ISNULL(@ChargeCreationTo, '') <> ''
                BEGIN
                    SET @Where = @Where
                        + ' and CAST(ch.CreatedDate AS DATE) >= CAST('''
                        + CAST(@ChargeCreationFrom AS VARCHAR(100))
                        + ''' AS DATE) '
                    SET @Where = @Where
                        + ' and CAST(ch.CreatedDate AS DATE) <= CAST('''
                        + CAST(@ChargeCreationTo AS VARCHAR(100))
                        + ''' AS DATE) '
                END
            ELSE
                IF ISNULL(@ChargeCreationFrom, '') <> ''
                    BEGIN
                        SET @Where = @Where
                            + ' and CAST(ch.CreatedDate AS DATE) >= CAST('''
                            + CAST(@ChargeCreationFrom AS VARCHAR(100))
                            + ''' AS DATE) '				
                    END			
            IF ISNULL(@NumOfStatements, 0) > 0
                BEGIN
                    DECLARE @CodeName VARCHAR(250) 
                    SELECT TOP 1
                            @CodeName = ISNULL(GC.CodeName, '0')
                    FROM    GlobalCodes GC
                    WHERE   GC.GlobalCodeId = @NumOfStatements
                            AND ISNULL(GC.RecordDeleted, 'N') = 'N'
                    IF ISNUMERIC(ISNULL(@CodeName, '0')) = 1
                        BEGIN				
                            IF CAST(@CodeName AS INT) > 0
                                BEGIN					
                                    SET @Where = @Where
                                        + ' and (SELECT COUNT(CS.ClientStatementId) FROM ClientStatements CS WHERE ISNULL(CS.RecordDeleted, ''N'') = ''N'' AND CS.ClientId = s.ClientId AND CS.CreatedDate >= ch.CreatedDate) = '
                                        + @CodeName
                                END
                        END
                END
                
                
		--IF ISNULL(@ServiceAreaId, -1) <> -1    
		--    SET @Where = @Where + ' and ser.ServiceAreaId = ' + CONVERT(VARCHAR, @ServiceAreaId)     
            IF @ReadyToBill = 1
                SET @Where = @Where + ' and ch.ReadyToBill = ''Y'''

            IF @ReadyToBill = 2
                SET @Where = @Where
                    + ' and isnull(ch.ReadyToBill, ''N'') = ''N'''

		--if isnull(@ProgramId, -1) <> -1 or isnull(@DOSFrom, '') <> '' or isnull(@DOSTo, '') <> '' or isnull(@ClientId, -1) <> -1                  
		-- set @From = @From + ' join Services s on s.ServiceId = ch.ServiceId'                    
            IF ISNULL(@ProgramId, -1) <> -1
                BEGIN
                    SET @Where = @Where + ' and   s.ProgramId = '
                        + CONVERT(VARCHAR, @ProgramId)
                END
            IF ( ISNULL(@FinancialAssignmentId, -1) <> -1
                 AND EXISTS ( SELECT    1
                              FROM      FinancialAssignmentPrograms
                              WHERE     FinancialAssignmentId = @FinancialAssignmentId
                                        AND AssignmentType = 8979
                                        AND ISNULL(RecordDeleted, 'N') = 'N' )
               )
                BEGIN
                    SET @Where = @Where
                        + ' and Exists(SELECT 1 FROM  FinancialAssignmentPrograms FAP WHERE FinancialAssignmentId='
                        + CAST(@FinancialAssignmentId AS VARCHAR)
                        + ' AND FAP.ProgramId=S.ProgramId  AND AssignmentType=8979 AND  ISNULL(FAP.RecordDeleted,''N'')=''N'' ) '
                END

            IF ISNULL(@ServiceAreaId, -1) <> -1
                OR EXISTS ( SELECT  1
                            FROM    FinancialAssignmentServiceAreas
                            WHERE   FinancialAssignmentId = @FinancialAssignmentId
                                    AND AssignmentType = 8979
                                    AND ISNULL(RecordDeleted, 'N') = 'N' )
                BEGIN
                    SET @From = @From
                        + '  LEFT JOIN Programs pr ON pr.programId = s.programId   AND ISNULL(pr.RecordDeleted, ''N'') = ''N''     LEFT JOIN ServiceAreas ser ON ser.ServiceAreaId = pr.ServiceAreaId AND ISNULL(ser.RecordDeleted, ''N'') = ''N'' '
				
                    IF ISNULL(@ServiceAreaId, -1) <> -1
                        BEGIN
				--filter with  FinancialAssignmentServiceAreas
                            SET @Where = @Where + ' and ser.ServiceAreaId  = '
                                + CONVERT(VARCHAR, @ServiceAreaId) + ''
                        END
					
                    IF ( ISNULL(@FinancialAssignmentId, -1) <> -1
                         AND EXISTS ( SELECT    1
                                      FROM      FinancialAssignmentServiceAreas
                                      WHERE     FinancialAssignmentId = @FinancialAssignmentId
                                                AND AssignmentType = 8979
                                                AND ISNULL(RecordDeleted, 'N') = 'N' )
                       )
                        BEGIN
					--filter with  FinancialAssignmentServiceAreas
                            SET @Where = @Where
                                + ' and Exists(SELECT 1 FROM  FinancialAssignmentServiceAreas  WHERE FinancialAssignmentId='
                                + CAST(@FinancialAssignmentId AS VARCHAR)
                                + ' AND ServiceAreaId=ser.ServiceAreaId AND AssignmentType=8979 AND  ISNULL(RecordDeleted,''N'')=''N'' )'
					
                        END
                END

            IF ISNULL(@FinancialAssignmentId, -1) <> -1
                SET @ChargeResponsibleDays = ( SELECT   ChargeResponsibleDays
                                               FROM     dbo.FinancialAssignments
                                               WHERE    FinancialAssignmentId = @FinancialAssignmentId
                                                        AND ISNULL(RecordDeleted,
                                                              'N') = 'N'
                                             )

            IF ISNULL(@ChargeResponsibleDays, -1) <> -1
                BEGIN
			--filter with  "Responsible for 3rd party Charges with a balance older than"
                    SET @Where = @Where + 'AND (('
                        + CAST(@ChargeResponsibleDays AS VARCHAR)
                        + ' =8980 AND 
			s.DateOfService <''' + CONVERT(VARCHAR, DATEADD(dd, -90, GETDATE()), 101)
                        + ''' )   
			  OR (' + CAST(@ChargeResponsibleDays AS VARCHAR) + ' = 8981 
			  AND s.DateOfService <''' + CONVERT(VARCHAR, DATEADD(dd, -180,
                                                              GETDATE()), 101)
                        + ''' )        
			  OR (' + CAST(@ChargeResponsibleDays AS VARCHAR)
                        + ' =8982 AND s.DateOfService <'''
                        + CONVERT(VARCHAR, DATEADD(dd, -360, GETDATE()), 101)
                        + ''' ) )'

                    IF ISNULL(@DOSFrom, '') <> ''
                        SET @Where = @Where + ' and s.DateOfService >= '''
                            + CONVERT(CHAR(10), @DOSFrom, 101) + ''''

                    IF ISNULL(@DOSTo, '') <> ''
                        SET @Where = @Where + ' and s.DateOfService < '''
                            + CONVERT(CHAR(10), DATEADD(dd, 1, @DOSTo), 101)
                            + ''''
                END
            ELSE
                BEGIN
                    IF ISNULL(@DOSFrom, '') <> ''
                        SET @Where = @Where + ' and s.DateOfService >= '''
                            + CONVERT(CHAR(10), @DOSFrom, 101) + ''''

                    IF ISNULL(@DOSTo, '') <> ''
                        SET @Where = @Where + ' and s.DateOfService < '''
                            + CONVERT(CHAR(10), DATEADD(dd, 1, @DOSTo), 101)
                            + ''''
                END

		-- JHB 10/30/2013   
		/*   
    if isnull(@ProcessedFrom, '') <> ''                    
    set @Where = @Where + ' and ch.LastBilledDate >= ''' + convert(char(10), @ProcessedFrom, 101) + ''''                  
       
    if @ProcessedTo <> ''                    
    set @Where = @Where + ' and ch.LastBilledDate < ''' + convert(char(10), dateadd(dd, 1, @ProcessedTo), 101) + ''''                  
    */
            IF ISNULL(@CoveragePlanId, -1) <> -1
                OR ( ISNULL(@PlanType, -1) NOT IN ( -1, -2, -3 ) )
                OR ISNULL(@PayerId, -1) <> -1
                OR ( ISNULL(@FinancialAssignmentId, -1) <> -1
                     AND ( EXISTS ( SELECT  1
                                    FROM    dbo.FinancialAssignmentPlans
                                    WHERE   FinancialAssignmentId = @FinancialAssignmentId
                                            AND AssignmentType = 8979
                                            AND ISNULL(RecordDeleted, 'N') = 'N' )
                           OR EXISTS ( SELECT   1
                                       FROM     dbo.FinancialAssignmentPayers
                                       WHERE    FinancialAssignmentId = @FinancialAssignmentId
                                                AND AssignmentType = 8979
                                                AND ISNULL(RecordDeleted, 'N') = 'N' )
                           OR EXISTS ( SELECT   1
                                       FROM     dbo.FinancialAssignmentPayerTypes
                                       WHERE    FinancialAssignmentId = @FinancialAssignmentId
                                                AND AssignmentType = 8979
                                                AND ISNULL(RecordDeleted, 'N') = 'N' )
                         )
                   )
                SET @From = @From
                    + ' join ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = ch.ClientCoveragePlanId'
                    + ' join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId'

            IF ISNULL(@CoveragePlanId, -1) <> -1
                BEGIN
                    SET @Where = @Where + ' and cp.CoveragePlanId = '
                        + CONVERT(VARCHAR, @CoveragePlanId)
                END
			
            IF ( ISNULL(@FinancialAssignmentId, -1) <> -1
                 AND EXISTS ( SELECT    1
                              FROM      FinancialAssignmentPlans
                              WHERE     FinancialAssignmentId = @FinancialAssignmentId
                                        AND AssignmentType = 8979
                                        AND ISNULL(RecordDeleted, 'N') = 'N' )
               )
				--filter with  FinancialAssignmentPlans 
                BEGIN
                    SET @Where = @Where
                        + ' and EXISTS(SELECT 1 FROM FinancialAssignmentPlans FAP WHERE FAP.FinancialAssignmentId='
                        + CAST(@FinancialAssignmentId AS VARCHAR)
                        + ' AND cp.CoveragePlanId =FAP.CoveragePlanId AND FAP.AssignmentType=8979 AND ISNULL(FAP.RecordDeleted,''N'')=''N'')'
                END
			
            IF ISNULL(@PayerId, -1) <> -1
                BEGIN
                    SET @Where = @Where + ' and cp.PayerId = '
                        + CONVERT(VARCHAR, @PayerId)
                END
			
            IF ( ISNULL(@FinancialAssignmentId, -1) <> -1
                 AND EXISTS ( SELECT    1
                              FROM      dbo.FinancialAssignmentPayers
                              WHERE     FinancialAssignmentId = @FinancialAssignmentId
                                        AND AssignmentType = 8979
                                        AND ISNULL(RecordDeleted, 'N') = 'N' )
               )
				--filter with  FinancialAssignmentPayers 
                BEGIN
                    SET @Where = @Where
                        + ' and EXISTS(SELECT 1 FROM FinancialAssignmentPayers FAP WHERE FAP.FinancialAssignmentId='
                        + CAST(@FinancialAssignmentId AS VARCHAR)
                        + ' AND cp.PayerId =FAP.PayerId AND FAP.AssignmentType=8979 AND ISNULL(FAP.RecordDeleted,''N'')=''N'')'
                END
            IF ISNULL(@PlanType, -1) NOT IN ( -1, -2, -3 )
                OR ( ISNULL(@FinancialAssignmentId, -1) <> -1
                     AND EXISTS ( SELECT    1
                                  FROM      dbo.FinancialAssignmentPayerTypes
                                  WHERE     FinancialAssignmentId = @FinancialAssignmentId
                                            AND AssignmentType = 8979
                                            AND ISNULL(RecordDeleted, 'N') = 'N' )
                   )
                BEGIN
                    SET @From = @From
                        + ' join Payers pa on pa.PayerId = cp.PayerId'

                    IF ( ISNULL(@FinancialAssignmentId, -1) <> -1 )
                        AND ( EXISTS ( SELECT   1
                                       FROM     FinancialAssignmentPayerTypes
                                       WHERE    FinancialAssignmentId = @FinancialAssignmentId
                                                AND AssignmentType = 8979
                                                AND ISNULL(RecordDeleted, 'N') = 'N' ) )
                        BEGIN
						--filter with  FinancialAssignmentPayerTypes 
                            SET @Where = @Where
                                + ' and EXISTS(SELECT 1 FROM FinancialAssignmentPayerTypes FAP WHERE FAP.FinancialAssignmentId='
                                + CAST(@FinancialAssignmentId AS VARCHAR)
                                + ' AND pa.PayerType =FAP.PayerTypeId  AND FAP.AssignmentType=8979 AND ISNULL(FAP.RecordDeleted,''N'')=''N'')'
                        END
                    IF ISNULL(@PlanType, -1) NOT IN ( -1, -2, -3 )
                        BEGIN
							--filter with  FinancialAssignmentPayerTypes 
                            SET @Where = @Where + ' and pa.PayerType = '
                                + CONVERT(VARCHAR, @PlanType) + ''
                        END	
                END

            IF ISNULL(@FinancialAssignmentId, -1) <> -1
                SET @IncludeClientCharge = ( SELECT ChargeIncludeClientCharge
                                             FROM   dbo.FinancialAssignments
                                             WHERE  FinancialAssignmentId = @FinancialAssignmentId
                                                    AND ISNULL(RecordDeleted,
                                                              'N') = 'N'
                                           )

            IF @PlanType = -2 -- 3rd Party Plans           
                OR ( @PlanType = -1
                     AND ISNULL(@IncludeClientCharge, 'N') = 'N'
                     AND EXISTS ( SELECT    ChargeIncludeClientCharge
                                  FROM      dbo.FinancialAssignments
                                  WHERE     FinancialAssignmentId = @FinancialAssignmentId
                                            AND ISNULL(RecordDeleted, 'N') = 'N' )
                   )	-- All Plans but financial assignment says not to include client charges (FinancialAssignment IncludeClientCharge check box)
                BEGIN
                    SET @Where = @Where + ' and ch.Priority > 0'
                END

            IF @PlanType = -3 --Client Plan
                BEGIN
                    SET @Where = @Where + ' and ch.Priority = 0'
                END

				--dk moved this to prior to the saved conditions
            IF ( ISNULL(@FinancialAssignmentId, -1) <> -1
                 AND EXISTS ( SELECT    1
                              FROM      dbo.FinancialAssignmentErrorReasons FAR
                              WHERE     FAR.FinancialAssignmentId = @FinancialAssignmentId
                                        AND FAR.AssignmentType = 8979
                                        AND ISNULL(FAR.RecordDeleted, 'N') = 'N' )
               )
                BEGIN
				-- filter with FinancialAssignmentErrorReasons
                    SET @Where = @Where + ' and exists(select *'
                        + ' from ChargeErrors che where che.ChargeId = ch.ChargeId and EXISTS(SELECT 1 FROM FinancialAssignmentErrorReasons FAR WHERE FAR.FinancialAssignmentId='
                        + CAST(@FinancialAssignmentId AS VARCHAR)
                        + ' AND che.ErrorType=FAR.ErrorReasonId AND FAR.AssignmentType=8979 AND ISNULL(FAR.RecordDeleted,''N'')=''N'') and isnull(che.RecordDeleted, ''N'') = ''N'')'
                END
            IF ISNULL(@ChargeErrorType, -1) <> -1
                BEGIN
                    SET @Where = @Where + ' and exists(select *'
                        + ' from ChargeErrors che'
                        + ' where che.ChargeId = ch.ChargeId'
                        + ' and che.ErrorType = '
                        + CONVERT(VARCHAR, @ChargeErrorType)
                        + ' and isnull(che.RecordDeleted, ''N'') = ''N'')'

                END
            ----Added by Ajay on 26 July 2017 on  16-June-2017   changes start here
            IF ( ISNULL(@FinancialAssignmentId, -1) <> -1
                 AND EXISTS ( SELECT    1
                              FROM      FinancialAssignmentAdjustmentCodes FAA
                              WHERE     FAA.FinancialAssignmentId = @FinancialAssignmentId
                                        AND FAA.AssignmentType = 8979
                                        AND ISNULL(FAA.RecordDeleted, 'N') = 'N' )
               )
                BEGIN  
				-- filter with FinancialAssignmentAdjustmentCodes						
                    SET @Where = @Where
                        + ' and EXISTS(select 1 from ARLedger arl Inner Join FinancialAssignmentAdjustmentCodes FAA on arl.AdjustmentCode= FAA.AdjustmentCodes WHERE ch.ChargeId= arl.ChargeId AND FAA.FinancialAssignmentId='
                        + CAST(@FinancialAssignmentId AS VARCHAR)
                        + ' AND FAA.AssignmentType=8979 AND ISNULL(FAA.RecordDeleted,''N'')=''N'' AND ISNULL(arl.RecordDeleted,''N'')=''N'') '
                END
                        
            IF ( ISNULL(@FinancialAssignmentId, -1) <> -1
                 AND EXISTS ( SELECT    1
                              FROM      FinancialAssignments FA
                              WHERE     FA.FinancialAssignmentId = @FinancialAssignmentId
                                        AND ISNULL(FA.ExcludePayerCharges, 'N') = 'Y'
                                        AND ISNULL(FA.RecordDeleted, 'N') = 'N' )
               )
                BEGIN   
                    SET @Where = @Where
                        + ' and ch.ClientCoveragePlanId is null '			 
                END
            IF ( ISNULL(@FinancialAssignmentId, -1) <> -1
                 AND EXISTS ( SELECT    *
                              FROM      FinancialAssignments FA
                              WHERE     FA.FinancialAssignmentId = @FinancialAssignmentId
                                        AND ISNULL(FA.ClientFinancialResponsible,
                                                   '') = 'F'
                                        AND ISNULL(FA.RecordDeleted, 'N') = 'N' )
               )
                BEGIN    
                    SET @Where = @Where
                        + ' and EXISTS(select 1 from Clients C WHERE   C.ClientId =S.ClientId AND (ISNULL(C.FinanciallyResponsible,''N'')=''Y'' OR EXISTS (SELECT * FROM  ClientContacts CC WHERE CC.ClientId=C.ClientId AND ISNULL(CC.FinanciallyResponsible,''N'')=''Y''))) '			 
                END 
             --print @Where
-- changes end here
			-- dk moved to prior to the split for saved conditions
            IF @ChargesWithBalance = 1
                BEGIN
                    IF @From NOT LIKE '%join OpenCharges oc%'
                        SET @From = @From
                            + ' join OpenCharges oc on oc.ChargeId = ch.ChargeId'
					
                END

			-- dk moved to prior to the split for saved conditions
            IF @ChargesWithPositiveBalance = 1
                BEGIN
                    IF @From NOT LIKE '%join OpenCharges oc%'
                        SET @From = @From
                            + ' join OpenCharges oc on oc.ChargeId = ch.ChargeId'
                    IF @From LIKE '%join OpenCharges oc%'
                        SET @Where = @Where + ' and oc.Balance < 0'
                END




--14- Nov-2018  Swatika check the condition OpenCharges Balance Greater Than Zero 
IF @ChargesWithBalancesGreaterThanZero = 'Y'
                BEGIN
                    IF @From NOT LIKE '%join OpenCharges oc%'
                        SET @From = @From
                            + ' join OpenCharges oc on oc.ChargeId = ch.ChargeId'
                    IF @From LIKE '%join OpenCharges oc%'
                        SET @Where = @Where + 'AND oc.Balance > 0'
                END
                
           
--------------------------------


            IF ISNULL(@ClaimBatchId, -1) <> -1
                BEGIN
                    SET @Where = @Where + ' and exists(select *'
                        + ' from ClaimBatchCharges cbch'
                        + ' where cbch.ChargeId = ch.ChargeId'
                        + ' and cbch.ClaimBatchId = '
                        + CONVERT(VARCHAR, @ClaimBatchId)
                        + ' and isnull(cbch.RecordDeleted, ''N'') = ''N'')'
                END

            IF ISNULL(@ClaimProcessId, -1) <> -1
                BEGIN
                    SET @Where = @Where + ' and exists(select *'
                        + ' from ClaimBatches cb'
                        + ' join ClaimBatchCharges cbch on cbch.ClaimBatchId = cb.ClaimBatchId'
                        + ' where cb.ClaimProcessId = '
                        + CONVERT(VARCHAR, @ClaimProcessId)
                        + ' and cbch.ChargeId = ch.ChargeId'
                        + ' and isnull(cb.RecordDeleted, ''N'') = ''N'''
                        + ' and isnull(cbch.RecordDeleted, ''N'') = ''N'')'
                END

            IF @Priority = 604
                BEGIN
                    SET @Where = @Where + ' and ch.Priority = 1'
                END

            IF @Priority = 605
                BEGIN
                    SET @Where = @Where + ' and ch.Priority > 1'
                END


            IF ( ISNULL(@FinancialAssignmentId, -1) <> -1
                 AND EXISTS ( SELECT    1
                              FROM      dbo.FinancialAssignmentProcedureCodes
                              WHERE     FinancialAssignmentId = @FinancialAssignmentId
                                        AND AssignmentType = 8979
                                        AND ISNULL(RecordDeleted, 'N') = 'N' )
               )
                BEGIN
                    SET @Where = @Where
                        + ' and EXISTS(SELECT 1 FROM FinancialAssignmentProcedureCodes FAP WHERE FAP.FinancialAssignmentId='
                        + CAST(@FinancialAssignmentId AS VARCHAR)
                        + ' AND s.ProcedurecodeId =FAP.ProcedureCodeId AND FAP.AssignmentType=8979 AND ISNULL(FAP.RecordDeleted,''N'')=''N'') '
                END
						
            IF ISNULL(@ProcedureCodeId, -1) <> -1
                BEGIN
                    SET @Where = @Where + ' and s.ProcedurecodeId='
                        + CONVERT(VARCHAR(20), @ProcedureCodeId)
                END

            IF ( ISNULL(@FinancialAssignmentId, -1) <> -1
                 AND EXISTS ( SELECT    1
                              FROM      dbo.FinancialAssignmentLocations
                              WHERE     FinancialAssignmentId = @FinancialAssignmentId
                                        AND AssignmentType = 8979
                                        AND ISNULL(RecordDeleted, 'N') = 'N' )
               )
		-- filter with FinancialAssignmentLocations
                BEGIN
                    SET @Where = @Where
                        + ' and EXISTS(SELECT 1 FROM FinancialAssignmentLocations FAL WHERE FAL.FinancialAssignmentId='
                        + CAST(@FinancialAssignmentId AS VARCHAR)
                        + ' AND s.LocationId =FAL.LocationId AND FAL.AssignmentType=8979 AND ISNULL(FAL.RecordDeleted,''N'')=''N'')'
                END
            IF ISNULL(@LocationId, -1) <> -1
                BEGIN
                    SET @Where = @Where + ' and s.LocationId='
                        + CONVERT(VARCHAR(20), @LocationId)
                END

				
            IF @Capitated IS NOT NULL
                AND @Capitated <> '-1'
                BEGIN	--Added by Revathi 06.Nov.2015
                    IF @From NOT LIKE '%join CoveragePlans cp%'
                        SET @From = @From
                            + ' LEFT join ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = ch.ClientCoveragePlanId'
                            + ' LEFT join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId'
                    SET @Where = @Where + ' and isnull(cp.Capitated,''N'')='''
                        + CAST(ISNULL(@Capitated, 'N') AS VARCHAR(1)) + ''''
                END

			--DECLARE	@VoidFrom VARCHAR(MAX)
			--  , @VoidWhere VARCHAR(MAX)

			-- Previous conditions are the same for all statements.
			-- Use FromTemp and WhereTemp to run insert statements				
            SET @FromTemp = @From
            SET @WhereTemp = @Where
			
            DECLARE @Insert VARCHAR(MAX)= 'insert into #ChargeFilters (ChargeId,LastBilledDate,Priority,ClientCoveragePlanId,ServiceId,DateOfService,Charge,ClientId,ClinicianId,ProcedureCodeId,LocationId,ProgramId,Flagged,Comments,Units,AttendingStaffId )'

			-- we will do three inserts for 588 
			-- we will only do 2 for 587, but it is DRYer to reuse the void code and have the first insert do the unbilled charges.
			-- we will reuse the code for 578 for 587
			--IF @ShowCharges IN ( 588, 587 )
			--	BEGIN
			--		SET @VoidFrom = @From
			--		SET @VoidWhere = @Where
			--	END
			
			-- BILLED charges insert
            IF ( @ShowCharges = 579 -- BILLED 
                 OR @ShowCharges = 580 -- BILL AND UNBILLED
               ) -- Arjun K R  09/04/2015   
                BEGIN
				
                    IF ISNULL(@ProcessedFrom, '') <> ''
                        AND @ProcessedTo <> ''
                        BEGIN
                            SET @WhereTemp = @WhereTemp
                                + ' and exists (select * from BillingHistory bh where ch.ChargeId = bh.ChargeId and isnull(bh.RecordDeleted,''N'') = ''N'' '
                                + ' and bh.BilledDate >= '''
                                + CONVERT(CHAR(10), @ProcessedFrom, 101)
                                + '''' + ' and bh.BilledDate < '''
                                + CONVERT(CHAR(10), DATEADD(dd, 1,
                                                            @ProcessedTo), 101)
                                + '''' + ' ) '
                        END
                    ELSE
                        IF ISNULL(@ProcessedFrom, '') <> ''
                            BEGIN
                                SET @WhereTemp = @WhereTemp
                                    + ' and exists (select * from BillingHistory bh where ch.ChargeId = bh.ChargeId and isnull(bh.RecordDeleted,''N'') = ''N'' '
                                    + ' and bh.BilledDate >= '''
                                    + CONVERT(CHAR(10), @ProcessedFrom, 101)
                                    + '''' + ' ) '
                            END
                        ELSE
                            IF @ProcessedTo <> ''
                                BEGIN
                                    SET @WhereTemp = @WhereTemp
                                        + ' and exists (select * from BillingHistory bh where ch.ChargeId = bh.ChargeId and isnull(bh.RecordDeleted,''N'') = ''N'' '
                                        + ' and bh.BilledDate < '''
                                        + CONVERT(CHAR(10), DATEADD(dd, 1,
                                                              @ProcessedTo), 101)
                                        + '''' + ' ) '
                                END

                    IF @FromTemp NOT LIKE '%join CoveragePlans cp%'
                        SET @FromTemp = @FromTemp
                            + ' LEFT join ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = ch.ClientCoveragePlanId'
                            + ' LEFT join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId'
					
                    SET @WhereTemp = @WhereTemp
                        + ' and isnull(cp.RecordDeleted, ''N'') = ''N'' /*and isnull(ccp.RecordDeleted, ''N'') = ''N''*/ and ch.LastBilledDate is not null '

				--Added by MSuma: Moved all the required column on Join to #ChargeFilters for performance tuning          
				-- Added by Revathi 17.12.2014    
					
                    SET @InsertString = @Insert
                    SET @SqlStatement = 'select ch.ChargeId,ch.LastBilledDate,ch.Priority,ch.ClientCoveragePlanId,Ch.serviceid, s.DateOfService,s.Charge,s.ClientId,s.ClinicianId,s.ProcedureCodeId,s.LocationId,s.ProgramId, ch.Flagged, ch.Comments ,ch.Units,s.AttendingId from Charges ch JOIN Services s on s.ServiceId = ch.serviceid '
                        + @FromTemp
                        + ' where ISNULL(ch.RecordDeleted,''N'')=''N'' and ISNULL(s.RecordDeleted,''N'')=''N'' '
                        + @WhereTemp
                    SET @InsertString = @InsertString + @SqlStatement

                    PRINT '/*Billed*/' + @InsertString

                    EXEC sys.sp_executesql @InsertString

					-- reset the conditions
                    SET @WhereTemp = @Where
                    SET @FromTemp = @From
                END
			
			-- UNBILLED  
            IF @ShowCharges = 578 -- 'UNBILLED'     
                OR @ShowCharges = 587 -- UNBILLED and VOID     
                OR @ShowCharges = 583 -- 'UNBILLEDANDREBILL'    
                OR @ShowCharges = 588 -- 'UNBILLREBILLANDVOID'  
                OR @ShowCharges = 580 -- 'BILLEDANDUNBILLED'       
                OR @ShowCharges = 592 -- Unbilled, Rebill, and Replacement
                OR @ShowCharges = 593 -- Unbill, Rebill, Replacement and Void.
                OR @ShowCharges = 590 -- Unbilled, Replacement
                BEGIN
					-- Removing 
					--IF @From NOT LIKE '%join OpenCharges oc%'
					--	SET @From = @From + ' join OpenCharges oc on oc.ChargeId = ch.ChargeId'

                    IF @FromTemp NOT LIKE '%join CoveragePlans cp%'
                        SET @FromTemp = @FromTemp
                            + ' LEFT join ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = ch.ClientCoveragePlanId'
                            + ' LEFT join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId'

					-- intentionally not checking record deleted on client coverage plans
                    SET @WhereTemp = @WhereTemp
                        + ' and isnull(cp.RecordDeleted, ''N'') = ''N'' and ch.LastBilledDate is null and isnull(ch.DoNotBill,''N'') <> ''Y''' --and isnull(cp.Capitated,''N'') <> ''Y'' 


                    SET @InsertString = @Insert	
                    SET @SqlStatement = 'select ch.ChargeId,ch.LastBilledDate,ch.Priority,ch.ClientCoveragePlanId,Ch.serviceid,s.DateOfService,s.Charge,s.ClientId,s.ClinicianId,s.ProcedureCodeId,s.LocationId,s.ProgramId, ch.Flagged, ch.Comments,ch.Units,s.AttendingId from Charges ch JOIN Services s on s.ServiceId = ch.serviceid '
                        + @FromTemp + '' 
                    SET @SqlStatement = @SqlStatement
                        + ' where NOT EXISTS (SELECT 1 From #ChargeFilters CF1 where CF1.ChargeId=ch.ChargeId) And '
                    SET @SqlStatement = @SqlStatement
                        + ' ISNULL(ch.RecordDeleted,''N'')=''N'' and ISNULL(s.RecordDeleted,''N'')=''N'' '
                        + @WhereTemp
                    SET @InsertString = @InsertString + @SqlStatement

                    PRINT '/*UnBilled*/' + @InsertString

                    EXEC sys.sp_executesql @InsertString

					-- reset the conditions
                    SET @WhereTemp = @Where
                    SET @FromTemp = @From						                        
                END
			
			-- REBILL 
            IF @ShowCharges = 584 -- 'REBILL' 
                OR @ShowCharges = 583 -- 'UNBILLANDREBILL'
                OR @ShowCharges = 588 -- 'UNBILLREBILLANDVOID'
                OR @ShowCharges = 591 -- Rebill and Replacement
                OR @ShowCharges = 592 -- Unbilled Rebill and Replacement
                OR @ShowCharges = 593 -- Unbilled Rebill Replacement and Void
                BEGIN
					--IF @From NOT LIKE '%join OpenCharges oc%'
					--	SET @From = @From + ' join OpenCharges oc on oc.ChargeId = ch.ChargeId'

                    SET @WhereTemp = @WhereTemp + ' and ch.Rebill = ''Y'''

                    SET @InsertString = @Insert
                    SET @SqlStatement = 'select ch.ChargeId,ch.LastBilledDate,ch.Priority,ch.ClientCoveragePlanId,Ch.serviceid,s.DateOfService,s.Charge,s.ClientId,s.ClinicianId,s.ProcedureCodeId,s.LocationId,s.ProgramId, ch.Flagged, ch.Comments,ch.Units,s.AttendingId from Charges ch JOIN Services s on s.ServiceId = ch.serviceid '
                        + @FromTemp + '' 
                    SET @SqlStatement = @SqlStatement
                        + ' where NOT EXISTS (SELECT 1 From #ChargeFilters CF1 where CF1.ChargeId=ch.ChargeId) And '
                    SET @SqlStatement = @SqlStatement
                        + ' ISNULL(ch.RecordDeleted,''N'')=''N'' and ISNULL(s.RecordDeleted,''N'')=''N'' '
                        + @WhereTemp
                    SET @InsertString = @InsertString + @SqlStatement

                    PRINT '/*ReBill*/' + @InsertString

                    EXEC sys.sp_executesql @InsertString

					-- reset the conditions
                    SET @WhereTemp = @Where
                    SET @FromTemp = @From		
                END

		-- JHB 9/11/2015 - Added logic for Do Not Bill     
			-- DONOTBILL                     
            IF @ShowCharges = 585 -- 'DONOTBILL'                 
                BEGIN
                    SET @WhereTemp = @WhereTemp + ' and ch.DoNotBill = ''Y'''

                    SET @InsertString = @Insert
                    SET @SqlStatement = 'select ch.ChargeId,ch.LastBilledDate,ch.Priority,ch.ClientCoveragePlanId,Ch.serviceid,s.DateOfService,s.Charge,s.ClientId,s.ClinicianId,s.ProcedureCodeId,s.LocationId,s.ProgramId, ch.Flagged, ch.Comments,ch.Units,s.AttendingId from Charges ch JOIN Services s on s.ServiceId = ch.serviceid '
                        + @FromTemp + '' 
                    SET @SqlStatement = @SqlStatement
                        + ' where NOT EXISTS (SELECT 1 From #ChargeFilters CF1 where CF1.ChargeId=ch.ChargeId) And '
                    SET @SqlStatement = @SqlStatement
                        + ' ISNULL(ch.RecordDeleted,''N'')=''N'' and ISNULL(s.RecordDeleted,''N'')=''N'' '
                        + @WhereTemp
                    SET @InsertString = @InsertString + @SqlStatement

                    PRINT '/*Do Not Bill*/' + @InsertString

                    EXEC sys.sp_executesql @InsertString

					-- reset the conditions
                    SET @WhereTemp = @Where
                    SET @FromTemp = @From		
                END

			--FLAGGED
            IF @ShowCharges = 581 --'FLAGGED'                   
                BEGIN
			--SET @Where = @Where + ' and exists(select *' + ' from FinancialActivityLinesFlagged falf' + ' join FinancialActivityLines fal on fal.FinancialActivityLineId = falf.FinancialActivityLineId' + ' where fal.ChargeId = ch.ChargeId' + ' and isnull(falf.RecordDeleted, ''N'') = ''N''' + ' and isnull(fal.RecordDeleted, ''N'') = ''N'')'
                    SET @WhereTemp = @WhereTemp + ' and ch.Flagged = ''Y'''

                    SET @InsertString = @Insert
                    SET @SqlStatement = 'select ch.ChargeId,ch.LastBilledDate,ch.Priority,ch.ClientCoveragePlanId,Ch.serviceid,s.DateOfService,s.Charge,s.ClientId,s.ClinicianId,s.ProcedureCodeId,s.LocationId,s.ProgramId, ch.Flagged, ch.Comments,ch.Units,s.AttendingId from Charges ch JOIN Services s on s.ServiceId = ch.serviceid '
                        + @FromTemp + '' 
                    SET @SqlStatement = @SqlStatement
                        + ' where NOT EXISTS (SELECT 1 From #ChargeFilters CF1 where CF1.ChargeId=ch.ChargeId) And '
                    SET @SqlStatement = @SqlStatement
                        + ' ISNULL(ch.RecordDeleted,''N'')=''N'' and ISNULL(s.RecordDeleted,''N'')=''N'' '
                        + @WhereTemp
                    SET @InsertString = @InsertString + @SqlStatement

                    PRINT '/*Flagged*/' + @InsertString

                    EXEC sys.sp_executesql @InsertString

					-- reset the conditions
                    SET @WhereTemp = @Where
                    SET @FromTemp = @From	
                END

			--CHARGESWITHERRORS
            IF @ShowCharges = 582 -- 'CHARGESWITHERRORS'                  
                BEGIN
                    IF @WhereTemp NOT LIKE '%ChargeErrors che%'
                        SET @WhereTemp = @WhereTemp + ' and exists(select *'
                            + ' from ChargeErrors che'
                            + ' where che.ChargeId = ch.ChargeId'
                            + ' and isnull(che.RecordDeleted, ''N'') = ''N'')'

                    SET @InsertString = @Insert
                    SET @SqlStatement = 'select ch.ChargeId,ch.LastBilledDate,ch.Priority,ch.ClientCoveragePlanId,Ch.serviceid,s.DateOfService,s.Charge,s.ClientId,s.ClinicianId,s.ProcedureCodeId,s.LocationId,s.ProgramId, ch.Flagged, ch.Comments,ch.Units,s.AttendingId from Charges ch JOIN Services s on s.ServiceId = ch.serviceid '
                        + @FromTemp + '' 
                    SET @SqlStatement = @SqlStatement
                        + ' where NOT EXISTS (SELECT 1 From #ChargeFilters CF1 where CF1.ChargeId=ch.ChargeId) And '
                    SET @SqlStatement = @SqlStatement
                        + ' ISNULL(ch.RecordDeleted,''N'')=''N'' and ISNULL(s.RecordDeleted,''N'')=''N'' '
                        + @WhereTemp
                    SET @InsertString = @InsertString + @SqlStatement

                    PRINT '/*Charges With Errors*/' + @InsertString

                    EXEC sys.sp_executesql @InsertString

					-- reset the conditions
                    SET @WhereTemp = @Where
                    SET @FromTemp = @From									
                END

			--VOID
            IF @ShowCharges = 586 -- VOID
                OR @ShowCharges = 587 -- UNBILLEDANDVOID
                OR @ShowCharges = 588 -- UNBILLEDREBILLANDVOID
                OR @ShowCharges = 593 -- Unbilled Rebill Replacement and Void
                BEGIN
                    SET @WhereTemp = @WhereTemp
                        + ' and exists (SELECT 1 FROM ClaimLineItemCharges clic JOIN ClaimLineItems cli ON cli.ClaimLineItemId = clic.ClaimLineItemId JOIN dbo.ClaimLineItemGroups clig ON cli.ClaimLineItemGroupId = clig.ClaimLineItemGroupId JOIN dbo.ClaimBatches cb ON clig.ClaimBatchId = cb.ClaimBatchId and isnull(cb.RecordDeleted,''N'') <> ''Y'' 
														WHERE clic.ChargeId = ch.ChargeId AND ISNULL(cli.ToBeVoided, ''N'') = ''Y'' AND ISNULL(cli.RecordDeleted,''N'') <> ''Y''
                                                        and cli.OriginalClaimLineItemId IS NULL )'

                    SET @InsertString = @Insert
                    SET @SqlStatement = 'select ch.ChargeId,ch.LastBilledDate,ch.Priority,ch.ClientCoveragePlanId,Ch.serviceid,s.DateOfService,s.Charge,s.ClientId,s.ClinicianId,s.ProcedureCodeId,s.LocationId,s.ProgramId, ch.Flagged, ch.Comments,ch.Units,s.AttendingId from Charges ch JOIN Services s on s.ServiceId = ch.serviceid '
                        + @FromTemp + '' 
                    SET @SqlStatement = @SqlStatement
                        + ' where NOT EXISTS (SELECT 1 From #ChargeFilters CF1 where CF1.ChargeId=ch.ChargeId) And '
                    SET @SqlStatement = @SqlStatement
                        + ' ISNULL(ch.RecordDeleted,''N'')=''N'' and ISNULL(s.RecordDeleted,''N'')=''N'' '
                        + @WhereTemp
                    SET @InsertString = @InsertString + @SqlStatement

                    PRINT '/*Void*/' + @InsertString

                    EXEC sys.sp_executesql @InsertString

					-- reset the conditions
                    SET @WhereTemp = @Where
                    SET @FromTemp = @From	
							
                END

			--TOBEREPLACED
            IF @ShowCharges IN ( 589, 590, 591, 592, 593 )
                BEGIN
                    SET @WhereTemp = @WhereTemp
                        + ' and exists (SELECT 1 FROM ClaimLineItemCharges clic JOIN ClaimLineItems cli ON cli.ClaimLineItemId = clic.ClaimLineItemId JOIN dbo.ClaimLineItemGroups clig ON cli.ClaimLineItemGroupId = clig.ClaimLineItemGroupId JOIN dbo.ClaimBatches cb ON clig.ClaimBatchId = cb.ClaimBatchId and isnull(cb.RecordDeleted,''N'') <> ''Y'' 
														WHERE clic.ChargeId = ch.ChargeId AND ISNULL(cli.ToBeResubmitted, ''N'') = ''Y'' AND ISNULL(cli.RecordDeleted,''N'') <> ''Y''
                                                        )'

                    SET @InsertString = @Insert
                    SET @SqlStatement = 'select ch.ChargeId,ch.LastBilledDate,ch.Priority,ch.ClientCoveragePlanId,Ch.serviceid,s.DateOfService,s.Charge,s.ClientId,s.ClinicianId,s.ProcedureCodeId,s.LocationId,s.ProgramId, ch.Flagged, ch.Comments,ch.Units,s.AttendingId from Charges ch JOIN Services s on s.ServiceId = ch.serviceid '
                        + @FromTemp + '' 
                    SET @SqlStatement = @SqlStatement
                        + ' where NOT EXISTS (SELECT 1 From #ChargeFilters CF1 where CF1.ChargeId=ch.ChargeId) And '
                    SET @SqlStatement = @SqlStatement
                        + ' ISNULL(ch.RecordDeleted,''N'')=''N'' and ISNULL(s.RecordDeleted,''N'')=''N'' '
                        + @WhereTemp
                    SET @InsertString = @InsertString + @SqlStatement

                    PRINT '/*Replace*/' + @InsertString

                    EXEC sys.sp_executesql @InsertString

					-- reset the conditions
                    SET @WhereTemp = @Where
                    SET @FromTemp = @From	

					SET @WhereTemp = @WhereTemp
                        + ' and exists (SELECT 1 FROM DocumentMoves dm JOIN Charges ch2 on ch2.ServiceId = dm.ServiceIdFrom and ISNULL(ch2.RecordDeleted,''N'')<>''Y'' and ch2.ClientCoveragePlanId = ch.ClientCoveragePlanId JOIN ClaimLineItemCharges clic on clic.ChargeId = ch2.ChargeId JOIN ClaimLineItems cli ON cli.ClaimLineItemId = clic.ClaimLineItemId AND ISNULL(cli.ToBeResubmitted, ''N'') = ''Y'' AND ISNULL(cli.RecordDeleted,''N'') <> ''Y'' JOIN dbo.ClaimLineItemGroups clig ON cli.ClaimLineItemGroupId = clig.ClaimLineItemGroupId JOIN dbo.ClaimBatches cb ON clig.ClaimBatchId = cb.ClaimBatchId and isnull(cb.RecordDeleted,''N'') <> ''Y'' 
														where dm.ServiceIdTo = ch.ServiceId and isnull(dm.RecordDeleted,''N'') <> ''Y''
                                                        )'

                    SET @InsertString = @Insert
                    SET @SqlStatement = 'select ch.ChargeId,ch.LastBilledDate,ch.Priority,ch.ClientCoveragePlanId,Ch.serviceid,s.DateOfService,s.Charge,s.ClientId,s.ClinicianId,s.ProcedureCodeId,s.LocationId,s.ProgramId, ch.Flagged, ch.Comments,ch.Units,s.AttendingId from Charges ch JOIN Services s on s.ServiceId = ch.serviceid '
                        + @FromTemp + '' 
                    SET @SqlStatement = @SqlStatement
                        + ' where NOT EXISTS (SELECT 1 From #ChargeFilters CF1 where CF1.ChargeId=ch.ChargeId) And '
                    SET @SqlStatement = @SqlStatement
                        + ' ISNULL(ch.RecordDeleted,''N'')=''N'' and ISNULL(s.RecordDeleted,''N'')=''N'' '
                        + @WhereTemp
                    SET @InsertString = @InsertString + @SqlStatement

                    PRINT '/*Replace Through Document Moves*/' + @InsertString

                    EXEC sys.sp_executesql @InsertString
							
							
                END

		--XXX 
		--print @InsertString       
            COMMON:

            CREATE NONCLUSTERED INDEX XIE1_ChargeFilter ON #ChargeFilters (
            ChargeId
            ,ClientId
            ,ClientCoveragePlanId
            )

		-- Get claim batch info         
            UPDATE  CF
            SET     CF.ClaimBatchId = CBC.ClaimBatchId ,
                    CF.ClaimProcessId = CB.ClaimProcessId ,
                    CF.ClaimFormatElectronic = CLF.Electronic
            FROM    #ChargeFilters CF
                    JOIN dbo.ClaimBatchCharges CBC ON CBC.ChargeId = CF.ChargeId
                    JOIN dbo.ClaimBatches CB ON CB.ClaimBatchId = CBC.ClaimBatchId
                    LEFT JOIN dbo.ClaimFormats CLF ON CLF.ClaimFormatId = CB.ClaimFormatId
            WHERE   ISNULL(CBC.RecordDeleted, 'N') = 'N'
                    AND NOT EXISTS ( SELECT *
                                     FROM   dbo.ClaimBatchCharges CBC2
                                     WHERE  CBC2.ChargeId = CF.ChargeId
				--	AND ISNULL(CBC.RecordDeleted, 'N') = 'N'
                                            AND ISNULL(CBC2.RecordDeleted, 'N') = 'N'
                                            AND CBC2.ClaimBatchId > CBC.ClaimBatchId )

		-- Get claim Line Item         
            UPDATE  CF
            SET     CF.ClaimLineItemId = CB.ClaimLineItemId,
                    CF.ToBeVoided = CB.ToBeVoided,
					CF.ToBeResubmitted = CB.ToBeResubmitted
            FROM    #ChargeFilters CF
                    JOIN dbo.ClaimLineItemGroups CBC ON CBC.ClaimBatchId = CF.ClaimBatchId
                    JOIN dbo.ClaimLineItems CB ON CB.ClaimLineItemGroupId = CBC.ClaimLineItemGroupId
                    JOIN dbo.ClaimLineItemCharges CLIC ON CLIC.ClaimLineItemId = CB.ClaimLineItemId
            WHERE   ISNULL(CBC.RecordDeleted, 'N') = 'N'
                    AND ISNULL(CB.RecordDeleted, 'N') = 'N'
                    AND CF.ChargeId = CLIC.ChargeId

		-- Get payments         
            INSERT  INTO #Payments
                    ( ChargeId ,
                      PaidAmount ,
                      FinancialActivityLineId
					)
                    SELECT  CF.ChargeId ,
                            -SUM(ARL.Amount) ,
                            MAX(ARL.FinancialActivityLineId)
                    FROM    #ChargeFilters CF
                            JOIN dbo.ARLedger ARL ON ARL.ChargeId = CF.ChargeId
                    WHERE   ARL.LedgerType = 4202
                            AND ISNULL(ARL.RecordDeleted, 'N') = 'N'
                    GROUP BY CF.ChargeId

            UPDATE  P
            SET     P.FinancialActivityId = FAL.FinancialActivityId ,
                    P.PaymentId = PA.PaymentId
            FROM    #Payments P
                    JOIN dbo.FinancialActivityLines FAL ON FAL.FinancialActivityLineId = P.FinancialActivityLineId
                    JOIN dbo.Payments PA ON PA.FinancialActivityId = FAL.FinancialActivityId
            WHERE   ISNULL(PA.RecordDeleted, 'N') = 'N'

		-- Get charge errors               
		-- Show a maximum of 3 errors                     
            INSERT  INTO #ChargeErrorsAll
                    ( ChargeId ,
                      ChargeErrorId ,
                      Errordescription
					)
                    SELECT  CE.ChargeId ,
                            CE.ChargeErrorId ,
                            CE.ErrorDescription
                    FROM    #ChargeFilters CF
                            JOIN dbo.ChargeErrors CE ON CE.ChargeId = CF.ChargeId
                    WHERE   ISNULL(CE.RecordDeleted, 'N') = 'N'

            PRINT '4'

            UPDATE  CF
            SET     CF.ErrorMessage = CASE WHEN LEN(CEA.Errordescription) > 300
                                           THEN SUBSTRING(CEA.Errordescription,
                                                          1, 297) + '...'
                                           ELSE CEA.Errordescription
                                      END ,
                    CF.MaxChargeErrorId = CEA.ChargeErrorId
            FROM    #ChargeFilters CF
                    JOIN #ChargeErrorsAll CEA ON CEA.ChargeId = CF.ChargeId
            WHERE   NOT EXISTS ( SELECT *
                                 FROM   #ChargeErrorsAll CEA2
                                 WHERE  CEA2.ChargeId = CF.ChargeId
                                        AND CEA2.ChargeErrorId < CEA.ChargeErrorId )

            PRINT '5'

            UPDATE  CF
            SET     CF.ErrorMessage = CASE WHEN LEN(CEA.Errordescription
                                                    + ', ' + CF.ErrorMessage) > 300
                                           THEN SUBSTRING(CEA.Errordescription
                                                          + ', '
                                                          + CF.ErrorMessage, 1,
                                                          297) + '...'
                                           ELSE CEA.Errordescription + ', '
                                                + CF.ErrorMessage
                                      END ,
                    CF.MaxChargeErrorId = CEA.ChargeErrorId
            FROM    #ChargeFilters CF
                    JOIN #ChargeErrorsAll CEA ON CEA.ChargeId = CF.ChargeId
            WHERE   CEA.ChargeErrorId > CF.MaxChargeErrorId
                    AND LEN(CF.ErrorMessage) < 300
                    AND NOT EXISTS ( SELECT *
                                     FROM   #ChargeErrorsAll CEA2
                                     WHERE  CEA2.ChargeId = CF.ChargeId
                                            AND CEA2.ChargeErrorId > CF.MaxChargeErrorId
                                            AND CEA2.ChargeErrorId < CEA.ChargeErrorId )

            PRINT '6'

            UPDATE  CF
            SET     CF.ErrorMessage = CASE WHEN LEN(CEA.Errordescription
                                                    + ', ' + CF.ErrorMessage) > 300
                                           THEN SUBSTRING(CEA.Errordescription
                                                          + ', '
                                                          + CF.ErrorMessage, 1,
                                                          297) + '...'
                                           ELSE CEA.Errordescription + ', '
                                                + CF.ErrorMessage
                                      END ,
                    CF.MaxChargeErrorId = CEA.ChargeErrorId
            FROM    #ChargeFilters CF
                    JOIN #ChargeErrorsAll CEA ON CEA.ChargeId = CF.ChargeId
            WHERE   CEA.ChargeErrorId > CF.MaxChargeErrorId
                    AND LEN(CF.ErrorMessage) < 300
                    AND NOT EXISTS ( SELECT *
                                     FROM   #ChargeErrorsAll CEA2
                                     WHERE  CEA2.ChargeId = CF.ChargeId
                                            AND CEA2.ChargeErrorId > CF.MaxChargeErrorId
                                            AND CEA2.ChargeErrorId < CEA.ChargeErrorId )

		--PRINT '7'   
----------------------------------------------------------------------------------
            INSERT  INTO #PaymentResultSetTable
                    ( ChargeId ,
                      CoveragePlanId ,
                      CoveragePlanName ,
                      ClientId ,
                      ClientName ,
                      ServiceId ,
                      DateOfService ,
                      StaffId ,
                      Clinician ,
                      ProcedureCodeId ,
                      ProcedureCode ,
                      Charge ,
                      Balance ,
                      Unbilled ,
                      PaidAmount ,
                      PaymentId ,
                      PaymentFinancialActivityId ,
                      PaymentFinancialActivityLineId ,
                      BillDate ,
                      ClaimProcessId ,
                      ClaimBatchId ,
                      ClaimFormatElectronic ,
                      PRIORITY ,
                      ErrorMessage ,
                      IsSelected ,
                      LocationName
				--Added by Vaibhav 05.10.2015 
                      ,
                      ServiceAreaName ,
                      Flagged ,
                      Comments ,
                      ClaimLineItemId ,
                      ProgramName --Added by Revathi 06.Nov.2015
                      ,
                      Capitated,
                      Units,
                      ToBeVoided,
					  ToBeResubmitted,
					  AttendingStaffId,
					  AttendingStaffName
					  
				    )
                    SELECT  CH.ChargeId ,
                            CP.CoveragePlanId ,
                            CP.DisplayAs AS CoveragePlanName ,
                            C.ClientId ,
                            CASE WHEN ISNULL(C.ClientType, 'I') = 'I'
                                 THEN C.LastName + ', ' + C.FirstName + ' '
                                      + '(' + CAST(C.ClientId AS VARCHAR(20))
                                      + ')'
                                 ELSE C.OrganizationName + ' ' + '('
                                      + CAST(C.ClientId AS VARCHAR(20)) + ')'
                            END ,
                            CH.ServiceId ,
                            CH.DateOfService ,
                            ST.StaffId ,
                            ST.LastName + ', ' + ST.FirstName AS Clinician ,
                            PC.ProcedureCodeId ,
                            PC.DisplayAs AS ProcedureCode ,
                            CH.Charge ,
                            OCH.Balance ,
                            CASE WHEN CH.LastBilledDate IS NULL
                                      AND CH.Priority <> 0
                                      AND ISNULL(CP.Capitated, 'N') <> 'Y'
                                      AND OCH.Balance > 0 THEN OCH.Balance
                                 ELSE NULL
                            END AS Unbilled ,
                            P.PaidAmount ,
                            P.PaymentId ,
                            P.FinancialActivityId AS PaymentFinancialActivityId ,
                            P.FinancialActivityLineId AS PaymentFinancialActivityLineId ,
                            CH.LastBilledDate AS BillDate ,
                            CH.ClaimProcessId ,
                            CH.ClaimBatchId ,
                            CH.ClaimFormatElectronic ,
                            CH.Priority ,
                            CH.ErrorMessage ,
                            0 AS IsSelected ,
                            L.LocationName
				--Added by Vaibhav 05.10.2015 
                            ,
                            SER.ServiceAreaName ,
                            CASE WHEN ISNULL(CH.Flagged, 'N') = 'N' THEN ''
                                 WHEN CH.Flagged = 'Y' THEN 'Yes'
                            END AS Flagged ,
                            CH.Comments ,
                            CH.ClaimLineItemId ,
                            PR.ProgramName
				-- Added by Veena on 02/02/16 Changed Capitated/NonCapitated to Yes/No in the grid ,Engineering Improvement Initiatives- NBL(I) #274	
                            ,
                            CASE WHEN ISNULL(CP.Capitated, 'N') = 'Y'
                                 THEN 'Yes'
                                 ELSE 'No'
                            END AS Capitated
                            ,CH.Units
                            ,CH.ToBeVoided
							,CH.ToBeResubmitted
							,ST1.StaffId AS AttendingStaffId
							,ST1.LastName + ', ' + ST1.FirstName AS AttendingStaffName 
			--Added by Vaibhav 05.10.2015 
                    FROM    #ChargeFilters CH --join #ChargeFilters cf on cf.ChargeId = ch.ChargeId  AND ISNULL(ch.RecordDeleted,'N')='N'        
			--join Services s on s.ServiceId = ch.ServiceId   AND ISNULL(S.RecordDeleted,'N')='N'               
                            JOIN dbo.Clients C ON C.ClientId = CH.ClientId
                                                  AND ISNULL(C.RecordDeleted,
                                                             'N') = 'N'
				--Added by Revathi 17.Apr.2015     
                                                  AND ( EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              #ClientLastNameSearch F
                                                              WHERE
                                                              ISNULL(C.ClientType,
                                                              'I') = 'I'
                                                              AND C.LastName COLLATE DATABASE_DEFAULT LIKE F.LastNameSearch COLLATE DATABASE_DEFAULT )
                                                        OR EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              #ClientLastNameSearch F
                                                              WHERE
                                                              ISNULL(C.ClientType,
                                                              'I') = 'O'
                                                              AND C.OrganizationName COLLATE DATABASE_DEFAULT LIKE F.LastNameSearch COLLATE DATABASE_DEFAULT )
                                                        OR ( ISNULL(@ClientLastNameCount,
                                                              0) = 0 )
                                                      )
                            JOIN dbo.ProcedureCodes PC ON PC.ProcedureCodeId = CH.ProcedureCodeId
			--	AND ISNULL(PC.RecordDeleted, 'N') = 'N'
                            JOIN dbo.StaffClients SC ON SC.StaffId = @StaffId
                                                        AND SC.ClientId = CH.ClientId
                            LEFT JOIN dbo.ClientCoveragePlans CCP ON CCP.ClientCoveragePlanId = CH.ClientCoveragePlanId
				--AND ISNULL(CCP.RecordDeleted, 'N') = 'N'
                            LEFT JOIN dbo.CoveragePlans CP ON CP.CoveragePlanId = CCP.CoveragePlanId
			--	AND ISNULL(CP.RecordDeleted, 'N') = 'N'
                            LEFT JOIN dbo.OpenCharges OCH ON OCH.ChargeId = CH.ChargeId
                            LEFT JOIN #Payments P ON P.ChargeId = CH.ChargeId
                            LEFT JOIN dbo.Staff ST ON ST.StaffId = CH.ClinicianId
			--	AND ISNULL(ST.RecordDeleted, 'N') = 'N'
			--Added by Revathi 17.12.2014               
                            LEFT JOIN dbo.Locations L ON L.LocationId = CH.LocationId
			--	AND ISNULL(L.RecordDeleted, 'N') = 'N'
                            LEFT JOIN dbo.Programs PR ON PR.ProgramId = CH.ProgramId
			--	AND ISNULL(PR.RecordDeleted, 'N') = 'N'
                            LEFT JOIN dbo.ServiceAreas SER ON SER.ServiceAreaId = PR.ServiceAreaId
			--	AND ISNULL(SER.RecordDeleted, 'N') = 'N'
							LEFT JOIN dbo.Staff ST1 ON ST1.StaffId = CH.AttendingStaffId
			-- 01.Apr.2016  Gautam start
                    WHERE   ( @ChargesWithBalance = 0
                              OR ( @ChargesWithBalance = 1
                                   AND OCH.Balance <> 0
                                 )
                            )
                    ORDER BY CASE WHEN @SortExpression = 'ChargeId desc'
                                  THEN CH.ChargeId
                             END DESC ,
                            CASE WHEN @SortExpression = 'CoveragePlanName'
                                 THEN CP.CoveragePlanName
                            END ,
                            CASE WHEN @SortExpression = 'CoveragePlanName desc'
                                 THEN CP.CoveragePlanName
                            END DESC ,
                            CASE WHEN @SortExpression = 'ClientName'
                                 THEN CASE WHEN ISNULL(C.ClientType, 'I') = 'I'
                                           THEN C.LastName + ', '
                                                + C.FirstName + ' ' + '('
                                                + CAST(C.ClientId AS VARCHAR(20))
                                                + ')'
                                           ELSE C.OrganizationName + ' ' + '('
                                                + CAST(C.ClientId AS VARCHAR(20))
                                                + ')'
                                      END
                            END ,
                            CASE WHEN @SortExpression = 'ClientName desc'
                                 THEN CASE WHEN ISNULL(C.ClientType, 'I') = 'I'
                                           THEN C.LastName + ', '
                                                + C.FirstName + ' ' + '('
                                                + CAST(C.ClientId AS VARCHAR(20))
                                                + ')'
                                           ELSE C.OrganizationName + ' ' + '('
                                                + CAST(C.ClientId AS VARCHAR(20))
                                                + ')'
                                      END
                            END DESC ,
                            CASE WHEN @SortExpression = 'DateOfService'
                                 THEN CH.DateOfService
                            END ,
                            CASE WHEN @SortExpression = 'DateOfService desc'
                                 THEN CH.DateOfService
                            END DESC ,
                            CASE WHEN @SortExpression = 'Clinician'
                                 THEN ST.StaffId
                            END ,
                            CASE WHEN @SortExpression = 'Clinician desc'
                                 THEN ST.StaffId
                            END DESC ,
                            CASE WHEN @SortExpression = 'ProcedureCode'
                                 THEN PC.ProcedureCodeId
                            END ,
                            CASE WHEN @SortExpression = 'ProcedureCode desc'
                                 THEN PC.ProcedureCodeId
                            END DESC ,
                            CASE WHEN @SortExpression = 'Charge'
                                 THEN CH.Charge
                            END ,
                            CASE WHEN @SortExpression = 'Charge desc'
                                 THEN CH.Charge
                            END DESC ,
                            CASE WHEN @SortExpression = 'Balance'
                                 THEN OCH.Balance
                            END ,
                            CASE WHEN @SortExpression = 'Balance desc'
                                 THEN OCH.Balance
                            END DESC ,
                            CASE WHEN @SortExpression = 'Unbilled'
                                 THEN CASE WHEN CH.LastBilledDate IS NULL
                                                AND CH.Priority <> 0
                                                AND ISNULL(CP.Capitated, 'N') <> 'Y'
                                                AND OCH.Balance > 0
                                           THEN OCH.Balance
                                           ELSE NULL
                                      END
                            END ,
                            CASE WHEN @SortExpression = 'Unbilled desc'
                                 THEN CASE WHEN CH.LastBilledDate IS NULL
                                                AND CH.Priority <> 0
                                                AND ISNULL(CP.Capitated, 'N') <> 'Y'
                                                AND OCH.Balance > 0
                                           THEN OCH.Balance
                                           ELSE NULL
                                      END
                            END DESC ,
                            CASE WHEN @SortExpression = 'PaidAmount'
                                 THEN P.PaidAmount
                            END ,
                            CASE WHEN @SortExpression = 'PaidAmount desc'
                                 THEN P.PaidAmount
                            END DESC ,
                            CASE WHEN @SortExpression = 'BillDate'
                                 THEN CH.LastBilledDate
                            END ,
                            CASE WHEN @SortExpression = 'BillDate desc'
                                 THEN CH.LastBilledDate
                            END DESC ,
                            CASE WHEN @SortExpression = 'ClaimProcessId'
                                 THEN CH.ClaimProcessId
                            END ,
                            CASE WHEN @SortExpression = 'ClaimProcessId desc'
                                 THEN CH.ClaimProcessId
                            END DESC ,
                            CASE WHEN @SortExpression = 'ClaimBatchId'
                                 THEN CH.ClaimBatchId
                            END ,
                            CASE WHEN @SortExpression = 'ClaimBatchId desc'
                                 THEN CH.ClaimBatchId
                            END DESC ,
                            CASE WHEN @SortExpression = 'Priority'
                                 THEN CH.Priority
                            END ,
                            CASE WHEN @SortExpression = 'Priority desc'
                                 THEN CH.Priority
                            END DESC ,
                            CASE WHEN @SortExpression = 'ErrorMessage'
                                 THEN CH.ErrorMessage
                            END ,
                            CASE WHEN @SortExpression = 'ErrorMessage desc'
                                 THEN CH.ErrorMessage
                            END DESC ,
                            CASE WHEN @SortExpression = 'LocationName'
                                 THEN L.LocationName
                            END ,
                            CASE WHEN @SortExpression = 'LocationName desc'
                                 THEN L.LocationName
                            END DESC ,
                            CASE WHEN @SortExpression = 'ServiceAreaName'
                                 THEN SER.ServiceAreaName
                            END ,
                            CASE WHEN @SortExpression = 'ServiceAreaName desc'
                                 THEN SER.ServiceAreaName
                            END DESC ,
                            CASE WHEN @SortExpression = 'Flagged'
                                 THEN CASE WHEN ISNULL(CH.Flagged, 'N') = 'N'
                                           THEN ''
                                           WHEN CH.Flagged = 'Y' THEN 'Yes'
                                      END
                            END ,
                            CASE WHEN @SortExpression = 'Flagged desc'
                                 THEN CASE WHEN ISNULL(CH.Flagged, 'N') = 'N'
                                           THEN ''
                                           WHEN CH.Flagged = 'Y' THEN 'Yes'
                                      END
                            END DESC ,
                            CASE WHEN @SortExpression = 'Comments'
                                 THEN CH.Comments
                            END ,
                            CASE WHEN @SortExpression = 'Comments desc'
                                 THEN CH.Comments
                            END DESC ,
                            CASE WHEN @SortExpression = 'ClaimLineItemId'
                                 THEN CH.ClaimLineItemId
                            END ,
                            CASE WHEN @SortExpression = 'ClaimLineItemId desc'
                                 THEN CH.ClaimLineItemId
                            END DESC ,
                            CASE WHEN @SortExpression = 'ProgramName'
                                 THEN PR.ProgramName
                            END ,
                            CASE WHEN @SortExpression = 'ProgramName desc'
                                 THEN PR.ProgramName
                            END DESC ,
                            CASE WHEN @SortExpression = 'Capitated'
                                 THEN ISNULL(CP.Capitated, 'N')
                            END ,
                            CASE WHEN @SortExpression = 'Capitated desc'
                                 THEN ISNULL(CP.Capitated, 'N')
                            END DESC ,
                             CASE WHEN @SortExpression = 'Units'
                                 THEN CH.Units
                            END ,
                            CASE WHEN @SortExpression = 'Units desc'
                                 THEN CH.Units
                            END DESC ,
                             CASE WHEN @SortExpression = 'AttendingStaffName'
                                 THEN ST1.StaffId
                            END ,
                            CASE WHEN @SortExpression = 'AttendingStaffName desc'
                                 THEN ST1.StaffId
                            END DESC ,
                            CH.ChargeId 
--------------------------------------------------------------------------------
            DECLARE @TotalRows INT = ( SELECT   COUNT(*)
                                       FROM     #PaymentResultSetTable
                                     )
            UPDATE  #PaymentResultSetTable
            SET     TotalRows = @TotalRows

            DECLARE @SumCharges MONEY = ( SELECT    SUM(Charge)
                                          FROM      #PaymentResultSetTable AS prst
                                        )

            DECLARE @SumBalances MONEY = ( SELECT   SUM(Balance)
                                           FROM     #PaymentResultSetTable AS prst
                                         )
            DECLARE @sql VARCHAR(MAX)
            SET @sql = '
					insert into #FinalResultSet
					(RowNumber
					,ChargeId
					,CoveragePlanId
					,CoveragePlanName
					,ClientId
					,Clientname
					,ServiceId
					,DateOfService
					,StaffId
					,Clinician
					,ProcedureCodeId
					,ProcedureCode
					,Charge
					,Balance
					,Unbilled
					,PaidAmount
					,PaymentId
					,PaymentFinancialActivityId
					,PaymentFinancialActivityLineId
					,BillDate
					,ClaimProcessId
					,ClaimBatchId
					,ClaimFormatElectronic
					,Priority
					,ErrorMessage
					,IsSelected
					,Locationname
					,ServiceAreaName
					,Flagged
					,Comments
					,ClaimLineItemId
					,ProgramName
					,Capitated
					,Units
					,ToBeVoided
                    ,ToBeResubmitted
                    ,AttendingStaffId
                    ,AttendingStaffName
					,TotalCount
					,TotalSelectedCharges
					,TotalSelectedBalances)
				SELECT TOP ('
                + CAST(CASE WHEN ( @PageNumber = -1
                                   OR @RowSelectionList = 'all'
                                 ) THEN ISNULL(@TotalRows, 0) --FROM counts
                            ELSE ( @PageSize )
                       END AS VARCHAR(MAX)) + ')
					  RANK() Over (Order by ' + @SortExpression + ', ChargeId)
					  , prst.ChargeId
					  , prst.CoveragePlanId
					  , prst.CoveragePlanName
					  , prst.ClientId
					  , prst.ClientName
					  , prst.ServiceId
					  , prst.DateOfService
					  , prst.StaffId
					  , prst.Clinician
					  , prst.ProcedureCodeId
					  , prst.ProcedureCode
					  , prst.Charge
					  , prst.Balance
					  , prst.Unbilled
					  , prst.PaidAmount
					  , prst.PaymentId
					  , prst.PaymentFinancialActivityId
					  , prst.PaymentFinancialActivityLineId
					  , prst.BillDate
					  , prst.ClaimProcessId
					  , prst.ClaimBatchId
					  , prst.ClaimFormatElectronic
					  , prst.Priority
					  , prst.ErrorMessage
					  , prst.IsSelected
					  , prst.LocationName
					  , prst.ServiceAreaName
					  , prst.Flagged
					  , prst.Comments
					  , prst.ClaimLineItemId
					  , prst.ProgramName --Added by Revathi 06.Nov.2015
					  , prst.Capitated
					  , prst.Units
					  ,ToBeVoided
                      ,ToBeResubmitted
                      ,prst.AttendingStaffId
					  ,prst.AttendingStaffName
					  , ' + CAST(@TotalRows AS VARCHAR) + '
					  , ' + CAST(@SumCharges AS VARCHAR(MAX))
                + ' AS TotalSumCharges
					  , ' + ISNULL(CAST(@SumBalances AS VARCHAR(MAX)), '0.00')
                + ' AS TotalSumBalance
				
				FROM  #PaymentResultSetTable AS prst
				where ResultSetId > '
                + CAST(ISNULL(NULLIF(@PageNumber, -1) - 1, 0) * @PageSize AS VARCHAR(MAX))
                + '
					order by ResultSetId,' + ISNULL(@SortExpression, 'ChargeId') -- ResultSetId added by Lakshmi on 17-09-2018 
			
            
                    
                    

            PRINT @sql
            EXEC (@sql)

            DECLARE @TotalCharges MONEY
            DECLARE @TotalBalance MONEY
            DECLARE @PageCharges MONEY
		--DECLARE @TotalCharges MONEYDECLARE @TempTotalCharge int         
            DECLARE @TempTotalCharge MONEY
            DECLARE @TempTotalBalance MONEY

            SELECT  @TempTotalCharge = TotalSelectedCharges
            FROM    #FinalResultSet

            SELECT  @TempTotalBalance = TotalSelectedBalances
            FROM    #FinalResultSet

            IF ( @TempTotalCharge IS NULL )
                SET @TempTotalCharge = 0.00

            IF ( @TempTotalBalance IS NULL )
                SET @TempTotalBalance = 0.00

            SELECT TOP 1
                    @TotalCharges = @TempTotalCharge ,
                    @TotalBalance = @TempTotalBalance
            FROM    #FinalResultSet

            IF ( SELECT ISNULL(COUNT(*), 0)
                 FROM   #FinalResultSet
               ) < 1
                BEGIN
                    SELECT  0 AS PageNumber ,
                            0 AS NumberOfPages ,
                            0 NumberOfRows ,
                            0 AS SelectedCharges ,
                            0 AS SelectedBalance ,
                            '' AS ArrayList
                END
            ELSE
                BEGIN
                    SELECT TOP 1
                            @PageNumber AS PageNumber ,
                            CASE ( TotalCount % @PageSize )
                              WHEN 0
                              THEN ISNULL(( TotalCount / @PageSize ), 0)
                              ELSE ISNULL(( TotalCount / @PageSize ), 0) + 1
                            END AS NumberOfPages ,
                            ISNULL(TotalCount, 0) AS NumberOfRows ,
                            @TotalCharges AS SelectedCharges ,
                            @TotalBalance AS SelectedBalance ,
				-- sum(case when PageNumber = @PageNumber then Charge else 0 end) as PageCharges,         
				-- sum(case when PageNumber = @PageNumber then Balance else 0 end) as PageBalance,         
				-- SUM(Case when IsSelected = 1 then Charge else 0 end) as SelectedCharges,         
				-- SUM(Case when IsSelected = 1 then Balance else 0 end) as SelectedBalance,         
                            '' AS ArrayList
                    FROM    #FinalResultSet
                END

            SELECT  RowNumber ,
                    ChargeId ,
                    CoveragePlanId ,
                    CoveragePlanName ,
                    ClientId ,
                    ClientName ,
                    ServiceId ,
                    DateOfService ,
                    StaffId ,
                    Clinician ,
                    ProcedureCodeId ,
                    ProcedureCode ,
                    Charge ,
                    Balance ,
                    Unbilled ,
                    PaidAmount ,
                    PaymentId ,
                    PaymentFinancialActivityId ,
                    PaymentFinancialActivityLineId ,
                    BillDate ,
                    ClaimProcessId ,
                    ClaimBatchId ,
                    ClaimFormatElectronic ,
                    PRIORITY ,
                    ErrorMessage ,
                    CONVERT(BIT, IsSelected) AS IsSelected ,
                    LocationName
			--Added by Vaibhav 05-10-2015   
                    ,
                    ServiceAreaName ,
                    Flagged ,
                    Comments ,
                    ClaimLineItemId ,
                    ProgramName --Added by Revathi 06.Nov.2015
                    ,
                    Capitated
                    ,Units
                    ,ToBeVoided
                    ,ToBeResubmitted
                    ,AttendingStaffId
                    ,AttendingStaffName
		--Added by Vaibhav 05-10-2015    
            FROM    #FinalResultSet
            ORDER BY RowNumber

            DECLARE @str VARCHAR(MAX)

            --SELECT  @str = COALESCE(@str + ',', '') + CONVERT(VARCHAR, ChargeId)
            --FROM    #FinalResultSet
            -- 23 Mar 2018 Gautam 
            SELECT  @str = STUFF(( SELECT   ','
                                            + CAST(ChargeId AS VARCHAR(MAX))
                                   FROM     #FinalResultSet
                                 FOR
                                   XML PATH('')
                                 ), 1, 1, '');

            SELECT  @str AS ChargeIds
        END TRY

        BEGIN CATCH
            DECLARE @Error VARCHAR(8000)

            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
                + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
                         'ssp_PMChargesAndClaims') + '*****'
                + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
                + CONVERT(VARCHAR, ERROR_STATE())

            RAISERROR (
				@Error
				,-- Message text.         
				16
				,-- Severity.         
				1 -- State.         
				);
        END CATCH
        SET NOCOUNT OFF
    END
GO


