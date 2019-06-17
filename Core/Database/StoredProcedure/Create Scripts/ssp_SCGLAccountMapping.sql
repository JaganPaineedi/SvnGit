IF EXISTS ( SELECT
                    *
                FROM
                    sys.objects
                WHERE
                    object_id = OBJECT_ID(N'ssp_SCGLAccountMapping')
                    AND type IN ( N'P' , N'PC' ) )
    BEGIN 
        DROP PROCEDURE ssp_SCGLAccountMapping; 
    END;
                    GO
CREATE PROCEDURE ssp_SCGLAccountMapping
    @GLExtractBatchIds GLExtractBatchIds READONLY,
    @CurrentUser VARCHAR(30)
AS /********************************************************************************
-- Stored Procedure: dbo.ssp_SCGLAccountMapping  
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
        
        DECLARE
            @errorMessage VARCHAR(MAX) ,
            @currentDate DATETIME = GETDATE() ,
            @errorMessageHeader VARCHAR(MAX) = '*****************************' + CHAR(10) + CHAR(13) + 'Error in ssp_SCGLAccountMapping'; 

	   DECLARE @BatchStatus INT 

	   SELECT @BatchStatus = gc.GlobalCodeId
	   FROM dbo.GlobalCodes AS gc
	   WHERE ISNULL(gc.RecordDeleted,'N')='N'
	   AND gc.Category = 'GLBatchStatus'
	   and gc.Code = 'AM' -- Accounts Mapped

        CREATE TABLE #Batches
            (
              BatchId INT ,
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
              AccountingStartDate DATETIME NULL ,
              AccountingEndDate DATETIME NULL ,
              PostedDate DATETIME NULL ,
              Amount MONEY NULL ,
              AccountType VARCHAR(100) NULL ,
              AdjustmentCode INT NULL ,
              AccountString VARCHAR(100) NULL ,
              ARAccountString VARCHAR(100) NULL ,
              PayerType INT ,
              LocationPlaceOfService INT ,
              ServicePlaceOfService INT ,
              StaffDegree INT ,
              LedgerType INT ,
              CoveragePlanAccountString VARCHAR(10) ,
		      CoveragePlanARAccountString VARCHAR(10),
              PayerAccountString VARCHAR(10) ,
		      PayerARAccountString VARCHAR(10),
              StaffAccountString VARCHAR(10) ,
		      StaffARAccountString VARCHAR(10),
              ProgramAccountString VARCHAR(10) ,
		      ProgramARAccountString VARCHAR(10) ,
              LocationAccountString VARCHAR(10) ,
		      LocationARAccountString VARCHAR(10) ,
              ProcedureAccountString VARCHAR(10) ,
		      ProcedureARAccountString VARCHAR(10) ,
              AccountingPeriodId INT ,
              ExtractBatchId INT
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
                  ExtractBatchId
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
                    b.BatchId
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
                LEFT JOIN dbo.StaffLicenseDegrees AS sld ON s.ClinicianId = sld.StaffId
                                                            AND sld.Billing = 'Y'
															and s.dateofservice between sld.startdate and coalesce(sld.enddate, getdate())
                                                            AND ISNULL(sld.RecordDeleted , 'N') = 'N';
             
/*****************************
* Run best fit logic to find the GL Account number for each arledger id
* Find AR Accounts first, then Revenue, Adjustment and Cash select * from #records
*****************************/
--AR
        EXEC dbo.ssp_SCGLAccountGetMappings @ARAccount = 1;
    /******
    * Update the record with the Account String mapped on
    ******/
        UPDATE
                r
            SET
                r.ARAccountString = ISNULL(a.AccountString , 'No GL Mapping Found')
            FROM
                #Records AS r
            JOIN #GLAccountMapping AS a ON r.ARLedgerId = a.ARLedgerId
                                           AND a.RowNumber = 1;

        TRUNCATE TABLE #GLAccountMapping;
--Non AR, Revenue, Cash and Adjustment
        EXEC dbo.ssp_SCGLAccountGetMappings @ARAccount = 0;

    /******
    * Update the record with the Account Type and Account String mapped on
    ******/
        UPDATE
                r
            SET
                r.AccountString = ISNULL(a.AccountString , 'No GL Mapping Found') ,
                r.AccountType = ISNULL(gc.CodeName , 'No GL Mapping Found')
            FROM
                #Records AS r
            JOIN #GLAccountMapping AS a ON r.ARLedgerId = a.ARLedgerId AND a.RowNumber = 1
            LEFT JOIN dbo.GlobalCodes AS gc ON a.AccountType = gc.GlobalCodeId

BEGIN TRAN;
        INSERT INTO dbo.GLExtractBatchData
                ( ExtractBatchId ,
                  GLAccountNumber ,
                  GLARAccountNumber ,
                  ARLedgerId
                )
            SELECT
                    r.ExtractBatchId ,
                    ISNULL(r.AccountString , 'No GL Mapping Found') AS AccountNumber ,
                    ISNULL(r.ARAccountString , 'No AR Account Found') AS ARAccountNumber ,
                    r.ARLedgerId
                FROM
                    #Records r;

			UPDATE
                        a
                    SET
                        a.ModifiedBy = @CurrentUser ,
                        a.ModifiedDate = GETDATE() ,
				    a.BatchStatus = @BatchStatus -- like accounts mapped.
                    FROM
                        dbo.GLExtractBatches AS a
                    JOIN @GLExtractBatchIds AS b ON b.ExtractBatchId = a.ExtractBatchId;
				TRUNCATE TABLE #Records
				TRUNCATE TABLE #GLAccountMapping;
				DROP TABLE #Records
				DROP TABLE #GLAccountMapping

        COMMIT TRAN;

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            BEGIN
                ROLLBACK TRAN;
            END;
    SELECT ERROR_MESSAGE()
    END CATCH; 



GO


