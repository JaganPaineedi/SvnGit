IF EXISTS ( SELECT
                    *
                FROM
                    sys.objects
                WHERE
                    object_id = OBJECT_ID(N'ssp_SCGLAccountExportData')
                    AND type IN ( N'P' , N'PC' ) )
    BEGIN 
        DROP PROCEDURE ssp_SCGLAccountExportData; 
    END;
                    GO
CREATE PROCEDURE ssp_SCGLAccountExportData
    @ReportType CHAR(1) = 'C' , -- 'F' - Flat File Extract, 'C' = CSV Extract, 'D' = Detail
    @GLExtractBatchIds GLExtractBatchIds READONLY,
    @CurrentUser VARCHAR(30)
AS/********************************************************************************
-- Stored Procedure: dbo.ssp_SCGLAccountExportData  
--
-- Copyright: 2016 Streamline Healthcate Solutions
--
-- Purpose: Find the GL numbers each record maps to
--
-- Updates:                     		                                
-- Date        Author      Purpose
-- 07/08/2016	 jcarlson	   created
-- 04/04/2018	 jcarlson	   Texas Go Live Build Issues 207 - Merged in TxAce changes
*********************************************************************************/
    BEGIN TRY
    DECLARE @CurrentDate DATETIME = GETDATE();
        CREATE TABLE #Batches
            (
              BatchId INT ,
              AccountingPeriodId INT
            );    

        CREATE TABLE #Extract
            (
              GLType VARCHAR(20) ,
              FullGLAccount VARCHAR(100) ,
              AccountingStartDate VARCHAR(8) ,
              AccountingEndDate VARCHAR(8) ,
              Credits DECIMAL(11 , 2) ,
              Debits DECIMAL(11 , 2) ,
              FlatFileRecord CHAR(1000) ,
              AccountingPeriodId INT
            );
        CREATE TABLE #GLAccountMapping
            (
              ARLedgerId INT ,
              AccountString VARCHAR(100) ,
              AccountType INT ,
              RowNumber INT
            );
        CREATE TABLE #Records
            (
              ClientId INT NULL ,
              ServiceAreaId INT NULL ,
              ServiceId INT NULL ,
              ChargeId INT NULL ,
              ARLedgerId INT NULL ,
              CoveragePlanId INT NULL ,
              PayerId INT NULL ,
              StaffId INT NULL ,
              ProgramId INT NULL ,
              LocationId INT NULL ,
              ProcedureCodeId INT NULL ,
              DateOfService DATETIME NULL ,
		    LocationPlaceOfService INT,
		    ServicePlaceOfService INT,
              AccountingStartDate DATETIME NULL ,
              AccountingEndDate DATETIME NULL ,
              PostedDate DATETIME NULL ,
              Amount MONEY NULL ,
              AccountType VARCHAR(100) NULL ,
              AdjustmentCode INT NULL ,
              AccountString VARCHAR(100) NULL ,
              ARAccountString VARCHAR(100) NULL ,
              AccountingPeriodId INT ,
              ExtractBatchId INT,
		    PayerType INT,
		    StaffDegree INT,
		    LedgerType INT 
            );

        INSERT INTO #Batches
                ( BatchId ,
                  AccountingPeriodId
                )
            SELECT
                    a.ExtractBatchId ,
                    a.AccountingPeriodId
                FROM
                    dbo.GLExtractBatches AS a
                JOIN @GLExtractBatchIds AS b ON b.ExtractBatchId = a.ExtractBatchId;
/**************************
* Gather records to be processed
**************************/
        INSERT INTO #Records
                ( ClientId ,
                  ServiceId ,
                  ChargeId ,
                  ARLedgerId ,
                  CoveragePlanId ,
                  StaffId ,
                  ProgramId ,
                  LocationId ,
                  ProcedureCodeId ,
                  DateOfService ,
                  AccountingStartDate ,
                  AccountingEndDate ,
                  PostedDate ,
                  AdjustmentCode ,
                  Amount ,
                  PayerId ,
                  PayerType ,
                  LocationPlaceOfService ,
                  ServicePlaceOfService ,
                  StaffDegree ,
                  LedgerType ,
                  AccountingPeriodId ,
                  ExtractBatchId,
			      AccountString,
			      ARAccountString
                )
            SELECT
                    s.ClientId ,
                    s.ServiceId ,
                    c.ChargeId ,
                    l.ARLedgerId ,
                    ccp.CoveragePlanId ,
                    s.ClinicianId ,
                    s.ProgramId ,
                    s.LocationId ,
                    s.ProcedureCodeId ,
                    s.DateOfService ,
                    ap.StartDate ,
                    ap.EndDate ,
                    l.PostedDate ,
                    l.AdjustmentCode ,
                    l.Amount ,
                    p.PayerId ,
                    p.PayerType ,
                    loc.PlaceOfService ,
                    s.PlaceOfServiceId ,
                    sld.LicenseTypeDegree ,
                    l.LedgerType ,
                    l.AccountingPeriodId ,
                    b.BatchId,
				    glebd.GLAccountNumber,
				    glebd.GLARAccountNumber
                FROM
                    dbo.Services s
                JOIN dbo.Charges c ON c.ServiceId = s.ServiceId
                JOIN dbo.ARLedger l ON l.ChargeId = c.ChargeId
                    AND ISNULL(l.RecordDeleted , 'N') = 'N'
                LEFT JOIN dbo.ClientCoveragePlans ccp ON ccp.ClientCoveragePlanId = c.ClientCoveragePlanId
                LEFT JOIN dbo.CoveragePlans AS cp ON cp.CoveragePlanId = ccp.CoveragePlanId
                LEFT JOIN dbo.Payers AS p ON p.PayerId = cp.PayerId
                JOIN dbo.Locations AS loc ON loc.LocationId = s.LocationId
                JOIN dbo.AccountingPeriods AS ap ON ap.AccountingPeriodId = l.AccountingPeriodId
                JOIN #Batches AS b ON b.AccountingPeriodId = l.AccountingPeriodId
				JOIN dbo.GLExtractBatches AS gleb ON gleb.AccountingPeriodId = b.AccountingPeriodId
					AND gleb.ExtractBatchId = b.BatchId
				JOIN dbo.GLExtractBatchData AS glebd ON glebd.ARLedgerId = l.ARLedgerId
					AND gleb.ExtractBatchId = glebd.ExtractBatchId
                LEFT JOIN dbo.StaffLicenseDegrees AS sld ON s.ClinicianId = sld.StaffId
					AND sld.Billing = 'Y'
					and s.dateofservice between sld.startdate and coalesce(sld.enddate, getdate())
					AND ISNULL(sld.RecordDeleted , 'N') = 'N';


/************************
* Group GL Account numbers data select * from #Records; truncate table #Extract
************************/
				/***************************************
				* Custom Hook for custom extract formats
				***************************************/
        DECLARE @CustomFormatAppliedPre CHAR(1) = 'N';
        IF EXISTS ( SELECT
                            *
                        FROM
                            sys.objects
                        WHERE
                            object_id = OBJECT_ID(N'scsp_SCGLAccountExtractCustomFormatPreGrouping')
                            AND type IN ( N'P' , N'PC' ) )
            AND @ReportType <> 'D'
            BEGIN 
                SET @CustomFormatAppliedPre = 'Y';
                EXEC dbo.scsp_SCGLAccountExtractCustomFormatPreGrouping @CurrentUser = @CurrentUser, @CurrentDate = @CurrentDate;

			
            END;           
        IF @CustomFormatAppliedPre = 'N'
            BEGIN
            
                INSERT INTO #Extract
                        ( GLType ,
                          FullGLAccount ,
                          AccountingStartDate ,
                          AccountingEndDate ,
                          Debits ,
                          Credits ,
                          AccountingPeriodId
        	              )
                    SELECT
                            'credit' ,
                            r.AccountString ,
                            REPLACE(CONVERT(VARCHAR(10) , CONVERT(DATE , r.AccountingStartDate) , 101) , '/' , '') ,
                            REPLACE(CONVERT(VARCHAR(10) , CONVERT(DATE , r.AccountingEndDate) , 101) , '/' , '') ,
                            -( CASE WHEN SUM(r.Amount) < 0 THEN SUM(r.Amount)
                                    ELSE 0
                               END ) ,
                            CASE WHEN SUM(r.Amount) > 0 THEN SUM(r.Amount)
                                 ELSE 0
                            END ,
                            r.AccountingPeriodId
                        FROM
                            #Records AS r
                        GROUP BY
                            r.AccountString ,
                            REPLACE(CONVERT(VARCHAR(10) , CONVERT(DATE , r.AccountingStartDate) , 101) , '/' , '') ,
                            REPLACE(CONVERT(VARCHAR(10) , CONVERT(DATE , r.AccountingEndDate) , 101) , '/' , '') ,
                            r.AccountingPeriodId; 


                INSERT INTO #Extract
                        ( GLType ,
                          FullGLAccount ,
                          AccountingStartDate ,
                          AccountingEndDate ,
                          Debits ,
                          Credits ,
                          AccountingPeriodId
        	              )
                    SELECT
                            'debit' ,
                            r.ARAccountString ,
                            REPLACE(CONVERT(VARCHAR(10) , CONVERT(DATE , r.AccountingStartDate) , 101) , '/' , '') ,
                            REPLACE(CONVERT(VARCHAR(10) , CONVERT(DATE , r.AccountingEndDate) , 101) , '/' , '') ,
                            CASE WHEN SUM(r.Amount) > 0 THEN SUM(r.Amount)
                                 ELSE 0
                            END ,
                            -( CASE WHEN SUM(r.Amount) < 0 THEN SUM(r.Amount)
                                    ELSE 0
                               END ) ,
                            r.AccountingPeriodId
                        FROM
                            #Records AS r
                        GROUP BY
                            r.ARAccountString ,
                            REPLACE(CONVERT(VARCHAR(10) , CONVERT(DATE , r.AccountingStartDate) , 101) , '/' , '') ,
                            REPLACE(CONVERT(VARCHAR(10) , CONVERT(DATE , r.AccountingEndDate) , 101) , '/' , '') ,
                            r.AccountingPeriodId; 


/****************************
* Apply rules select sum(credits),sum(debits) From #extract ; select * From #extract where flatfilerecord = 'x' order by GLType
****************************/
                  exec ssp_SCGLAccountRules;
                UPDATE
                        #Extract
                    SET
                        Debits = CASE WHEN Debits > Credits THEN Debits - Credits
                                      ELSE 0.0
                                 END ,
                        Credits = CASE WHEN Credits > Debits THEN Credits - Debits
                                       ELSE 0.0
                                  END;
                DELETE FROM
                        #Extract
                    WHERE
                        Credits = 0
                        AND Debits = 0;

                UPDATE
                        #Extract
                    SET
                        FlatFileRecord = 'JV    ' + 'AR' + AccountingStartDate + '    ' + AccountingStartDate + 'AR' + AccountingStartDate + '     '
                        + FullGLAccount + REPLICATE('0' , 11 - LEN(REPLACE(CAST(Debits AS VARCHAR) , '.' , ''))) + REPLACE(CAST(Debits AS VARCHAR) , '.' , '')
                        + REPLICATE('0' , 11 - LEN(REPLACE(CAST(Credits AS VARCHAR) , '.' , ''))) + REPLACE(CAST(Credits AS VARCHAR) , '.' , '');

            END;
        
        
/********************************************
* Extract the data in various ways
********************************************/
				/***************************************
				* Custom Hook for custom extract formats
				***************************************/
        DECLARE @CustomFormatAppliedPost CHAR(1) = 'N';
        IF EXISTS ( SELECT
                            *
                        FROM
                            sys.objects
                        WHERE
                            object_id = OBJECT_ID(N'scsp_SCGLAccountExtractCustomFormatPostGrouping')
                            AND type IN ( N'P' , N'PC' ) )
            AND @ReportType <> 'D'
            BEGIN 
                SET @CustomFormatAppliedPost = 'Y';
                EXEC dbo.scsp_SCGLAccountExtractCustomFormatPostGrouping @BatchId = 1;

			
            END;


        IF @CustomFormatAppliedPost <> 'Y'
            AND @CustomFormatAppliedPre <> 'Y'
            BEGIN

/**********
* Flat File
**********/
                IF @ReportType = 'F'
                    BEGIN
                        SELECT
                                FlatFileRecord
                            FROM
                                #Extract
                            ORDER BY
                                FullGLAccount ,
                                AccountingStartDate;
                    END;
                ELSE
/**********
* CSV
**********/
                    IF @ReportType = 'C'
                        BEGIN
                            SELECT
                                    'SCGL' + CONVERT(VARCHAR , GETDATE() , 112) AS Batch ,
                                    SUBSTRING(AccountingEndDate , 1 , 2) + '/' + SUBSTRING(AccountingEndDate , 3 , 2) + '/' + SUBSTRING(AccountingEndDate , 5 ,
                                                                                                                                        4) AS TransactionDate ,
                                    'Smartcare Import ' + SUBSTRING(AccountingEndDate , 1 , 2) + '/' + SUBSTRING(AccountingEndDate , 3 , 2) + '/'
                                    + SUBSTRING(AccountingEndDate , 5 , 4) AS Reference ,
                                    ISNULL(FullGLAccount , 'No GL Mapping Found') AS FullGLAccount ,
                                    Debits AS Debit ,
                                    Credits AS Credit
                                FROM
                                    #Extract
                                ORDER BY
                                    AccountingStartDate ,
                                    FullGLAccount;

                        END;
                    ELSE
/**********
* Detail Report
**********/
                        IF @ReportType = 'D'
                            BEGIN
                                CREATE TABLE #Results
                                    (
                                      ChargeId INT ,
                                      AccountNumber VARCHAR(100) ,
                                      AccountType VARCHAR(100) ,
                                      Debit DECIMAL(18 , 2) ,
                                      Credit DECIMAL(18 , 2) ,
                                      AccountingStartDate VARCHAR(12) ,
                                      AccountingEndDate VARCHAR(12) ,
                                      CoveragePlanName VARCHAR(250) ,
                                      ServiceAreaName VARCHAR(250) ,
                                      LocationCode VARCHAR(250) ,
                                      ProgramCode VARCHAR(250) ,
                                      ProcedureCodeName VARCHAR(250) ,
                                      ServiceId INT ,
                                      ClientId INT ,
                                      DateOfService DATETIME ,
                                      PostedDate DATETIME ,
                                      ARLedgerId INT ,
                                      LedgerType VARCHAR(25)
                                    );
                                INSERT INTO #Results
                                        ( ChargeId ,
                                          AccountNumber ,
                                          AccountType ,
                                          LedgerType ,
                                          Debit ,
                                          Credit ,
                                          AccountingStartDate ,
                                          AccountingEndDate ,
                                          CoveragePlanName ,
                                          ServiceAreaName ,
                                          LocationCode ,
                                          ProgramCode ,
                                          ProcedureCodeName ,
                                          ServiceId ,
                                          ClientId ,
                                          DateOfService ,
                                          PostedDate ,
                                          ARLedgerId
		                              )
                                    SELECT
                                            r.ChargeId ,
                                            ISNULL(r.AccountString , 'No GL Mapping Found') AS AccountNumber ,
                                            r.AccountType ,
                                            dbo.ssf_GetGlobalCodeNameById(al.LedgerType) AS LedgerType ,
                                            -CASE WHEN r.Amount > 0 THEN 0
                                                  ELSE r.Amount
                                             END AS debit ,
                                            CASE WHEN r.Amount < 0 THEN 0
                                                 ELSE r.Amount
                                            END AS credit ,
                                            REPLACE(CONVERT(VARCHAR(10) , CONVERT(DATE , r.AccountingStartDate) , 101) , '/' , '') AS AccountingStartDate ,
                                            REPLACE(CONVERT(VARCHAR(10) , CONVERT(DATE , r.AccountingEndDate) , 101) , '/' , '') AS AccountingEndDate ,
                                            ISNULL(cp.CoveragePlanName , 'Client') AS CoveragePlanName ,
                                            ISNULL(sa.ServiceAreaName , '(none)') AS ServiceAreaName ,
                                            ISNULL(l.LocationCode , '(none)') AS LocationCode ,
                                            ISNULL(p.ProgramCode , '(none)') AS ProgramCode ,
                                            ISNULL(pc.DisplayAs , '(none)') AS DisplayAs ,
                                            r.ServiceId ,
                                            r.ClientId ,
                                            r.DateOfService ,
                                            r.PostedDate ,
                                            r.ARLedgerId
                                        FROM
                                            #Records r
                                        LEFT JOIN dbo.CoveragePlans cp ON cp.CoveragePlanId = r.CoveragePlanId
                                        JOIN dbo.ARLedger al ON al.ARLedgerId = r.ARLedgerId
                                        LEFT JOIN dbo.ServiceAreas sa ON r.ServiceAreaId = sa.ServiceAreaId
                                        LEFT JOIN dbo.Locations l ON r.LocationId = l.LocationId
                                        LEFT JOIN dbo.Programs p ON r.ProgramId = p.ProgramId
                                        LEFT JOIN dbo.ProcedureCodes pc ON r.ProcedureCodeId = pc.ProcedureCodeId
                                    UNION ALL
                                    SELECT
                                            r.ChargeId ,
                                            ISNULL(r.ARAccountString , 'No AR Account') AS AccountNumber ,
                                            'AR' ,
                                            dbo.ssf_GetGlobalCodeNameById(al.LedgerType) AS LedgerType ,
                                            CASE WHEN r.Amount < 0 THEN 0
                                                 ELSE r.Amount
                                            END AS debit ,
                                            -CASE WHEN r.Amount > 0 THEN 0
                                                  ELSE r.Amount
                                             END AS credit ,
                                            REPLACE(CONVERT(VARCHAR(10) , CONVERT(DATE , r.AccountingStartDate) , 101) , '/' , '') AS AccountingStartDate ,
                                            REPLACE(CONVERT(VARCHAR(10) , CONVERT(DATE , r.AccountingEndDate) , 101) , '/' , '') AS AccountingEndDate ,
                                            ISNULL(cp.CoveragePlanName , 'Client') AS CoveragePlanName ,
                                            ISNULL(sa.ServiceAreaName , '(none)') AS ServiceAreaName ,
                                            ISNULL(l.LocationCode , '(none)') AS LocationCode ,
                                            ISNULL(p.ProgramCode , '(none)') AS ProgramCode ,
                                            ISNULL(pc.DisplayAs , '(none)') AS DisplayAs ,
                                            r.ServiceId ,
                                            r.ClientId ,
                                            r.DateOfService ,
                                            r.PostedDate ,
                                            r.ARLedgerId
                                        FROM
                                            #Records r
                                        LEFT JOIN dbo.CoveragePlans cp ON cp.CoveragePlanId = r.CoveragePlanId
                                        JOIN dbo.ARLedger al ON al.ARLedgerId = r.ARLedgerId
                                        LEFT JOIN dbo.ServiceAreas sa ON r.ServiceAreaId = sa.ServiceAreaId
                                        LEFT JOIN dbo.Locations l ON r.LocationId = l.LocationId
                                        LEFT JOIN dbo.Programs p ON r.ProgramId = p.ProgramId
                                        LEFT JOIN dbo.ProcedureCodes pc ON r.ProcedureCodeId = pc.ProcedureCodeId;

                                SELECT
                                        a.ChargeId ,
                                        a.AccountNumber ,
                                        a.AccountType ,
                                        a.LedgerType ,
                                        a.Debit ,
                                        a.Credit ,
                                        a.AccountingStartDate ,
                                        a.AccountingEndDate ,
                                        a.CoveragePlanName ,
                                        a.ServiceAreaName ,
                                        a.LocationCode ,
                                        a.ProgramCode ,
                                        a.ProcedureCodeName ,
                                        a.ServiceId ,
                                        a.ClientId ,
                                        a.DateOfService ,
                                        a.PostedDate ,
                                        a.ARLedgerId
                                    FROM
                                        #Results AS a
                                    ORDER BY
                                        a.ARLedgerId;
                            END;                     

				                      
            END;
		  		TRUNCATE TABLE #Records
				TRUNCATE TABLE #Extract
				DROP TABLE #Extract
				DROP TABLE #Records
   
    END TRY
    BEGIN CATCH 

                    
        SELECT
                ERROR_MESSAGE();
    END CATCH;
GO


