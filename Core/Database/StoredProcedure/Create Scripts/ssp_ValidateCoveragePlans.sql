IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ValidateCoveragePlans]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ValidateCoveragePlans]
GO
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[ssp_ValidateCoveragePlans]
    @CurrentUserId INT ,
    @ScreenKeyId INT
AS /*========================================================================
Stored Procedure: ssp_ValidateCoveragePlans
Created Date:05/22/2017
Purpose: Validate Over Lapping Time if same BillingCode+CoveragePlan are selected with the overlapping time.
Data Modification:
Data            Author                 Purpose
08/2/2017       Pranay                 Added a validation if Billing code with out coveraga plan has overlapping dates
09/15/2017      Pranay                 Added ClientId
09/15/2017      Pranay                 Added SiteId
04/06/2018		Ravi				   What: Modified the Logic of LicensureGroupId and PlaceOfService  
									   Why:Heartland East - Customizations > Tasks #26 > Contracted Rates: List Page and Details Page Modifications >
===========================================================================*/
    BEGIN
        BEGIN TRY
            DECLARE @validationReturnTable TABLE
                (
                  TableName VARCHAR(200) ,
                  ColumnName VARCHAR(200) ,
                  ErrorMessage VARCHAR(1000)
                );
            DECLARE @ContractId INT;
            DECLARE @AllStartDate DATETIME;
            DECLARE @AllEndDate DATETIME;
            DECLARE @BillingCodeId INT;
            DECLARE @CoveragePlanId INT;
            DECLARE @ErrorFlag INT; 
            DECLARE @ErrorFlag1 INT;
            SELECT  @ContractId = ContractID
            FROM    dbo.ContractRates
            WHERE   ContractRateId = @ScreenKeyId;

            DECLARE @BillingCodesCoveragePlan TABLE
                (
                  ContractId INT ,
                  ContractRateId INT ,
                  StartDate DATETIME ,
                  EndDate DATETIME ,
                  BillingCode INT ,
                  CoveragePlanId INT ,
                  CoveragePlanGroupName VARCHAR(100) ,
                  Modifier1 VARCHAR(10) ,
                  Modifier2 VARCHAR(10) ,
                  Modifier3 VARCHAR(10) ,
                  Modifier4 VARCHAR(10) ,
                  ClientId INT ,
                  SiteId INT ,
                  AllSites CHAR(1),
				  LicensureGroupId INT,
				  PlaceOfService INT
                )

            INSERT  INTO @BillingCodesCoveragePlan
                    ( ContractId ,
                      ContractRateId ,
                      StartDate ,
                      EndDate ,
                      BillingCode ,
                      CoveragePlanId ,
                      CoveragePlanGroupName ,
                      Modifier1 ,
                      Modifier2 ,
                      Modifier3 ,
                      Modifier4 ,
                      ClientId ,
                      SiteId ,
                      AllSites,
					  LicensureGroupId,
					  PlaceOfService
			        )
                    SELECT  cr1.ContractId ,
                            cr1.ContractRateId ,
                            cr1.StartDate ,
                            cr1.EndDate ,
                            cr1.BillingCodeId ,
                            crcp.CoveragePlanId ,
                            cr1.CoveragePlanGroupName ,
                            cr1.Modifier1 ,
                            cr1.Modifier2 ,
                            cr1.Modifier3 ,
                            cr1.Modifier4 ,
                            cr1.ClientId ,
                            crs.SiteId ,
                            cr1.AllSites,
							CRL.LicenseTypeId AS LicenseAndDegreeGroupId, --04/06/2018		Ravi
							CRP.PlaceOfServiceId
                    FROM    ContractRates cr1
                            LEFT JOIN dbo.ContractRateCoveragePlans crcp ON crcp.ContractRateId = cr1.ContractRateId
                            LEFT JOIN dbo.ContractRateSites crs ON crs.ContractRateId = cr1.ContractRateId
							LEFT JOIN dbo.ContractRates CR ON CR.ContractId = cr1.ContractId
																--04/06/2018		Ravi
							LEFT JOIN dbo.ContractRateLicenseTypes CRL ON CRL.ContractRateId = cr1.ContractRateId AND ISNULL(CRL.Recorddeleted, 'N') = 'N'
							LEFT JOIN dbo.ContractRatePlaceOfServices CRP ON CRP.ContractRateId = cr1.ContractRateId AND ISNULL(CRP.Recorddeleted, 'N') = 'N'
                    WHERE   cr1.ContractId = @ContractId
                            AND ISNULL(cr1.Recorddeleted, 'N') = 'N';

            IF EXISTS ( SELECT  A.*
                        FROM    @BillingCodesCoveragePlan A
                                INNER JOIN @BillingCodesCoveragePlan B ON B.BillingCode = A.BillingCode
                                                              AND ISNULL(B.CoveragePlanId,
                                                              0) = ISNULL(A.CoveragePlanId,
                                                              0)
                                                              AND ISNULL(B.Modifier1,
                                                              '') = ISNULL(A.Modifier1,
                                                              '')
                                                              AND ISNULL(B.Modifier2,
                                                              '') = ISNULL(A.Modifier2,
                                                              '')
                                                              AND ISNULL(B.Modifier3,
                                                              '') = ISNULL(A.Modifier3,
                                                              '')
                                                              AND ISNULL(B.Modifier4,
                                                              '') = ISNULL(A.Modifier4,
                                                              '')
                                                              AND ISNULL(B.ClientId,
                                                              0) = ISNULL(A.ClientId,
                                                              0)
                                                              AND ( ISNULL(B.SiteId,
                                                              0) = ISNULL(A.SiteId,
                                                              0)
                                                              OR A.AllSites = 'Y'
                                                              OR B.AllSites = 'Y'
                                                              )
															  AND B.LicensureGroupId=A.LicensureGroupId
															  AND B.PlaceOfService=A.PlaceOfService
                        WHERE   B.ContractRateId <> A.ContractRateId
                                AND ( ISNULL(CONVERT(DATE, B.StartDate),
                                             CONVERT(DATE, '01-01-1900')) <= ISNULL(CONVERT(DATE, A.EndDate),
                                                              CONVERT(DATE, '01-01-2199')) )
                                AND ( ISNULL(CONVERT(DATE, B.EndDate),
                                             CONVERT(DATE, '01-01-2199')) >= ISNULL(CONVERT(DATE, A.StartDate),
                                                              CONVERT(DATE, '01-01-1900')) ) )
                BEGIN
                    SET @ErrorFlag = 1;
                END;		

            IF ( @ErrorFlag = 1 )
                BEGIN
                    INSERT  INTO @validationReturnTable
                            ( TableName ,
                              ColumnName ,
                              ErrorMessage
				            )
                    VALUES  ( 'MeaningFulUseDetails' ,
                              'MeasureType' ,
                              'The selected billing code is overlapping.'
				            );
                    SELECT  TableName ,
                            ColumnName ,
                            ErrorMessage
                    FROM    @validationReturnTable;
                END;
 
                 
            IF EXISTS ( SELECT  *
                        FROM    @validationReturnTable )
                BEGIN
                    SELECT  0 AS ValidationStatus;
                END;
            ELSE
                BEGIN
                    SELECT  0 AS ValidationStatus;
                END;
--ValidationErrors table                   
		
        END TRY

        BEGIN CATCH
            DECLARE @Error VARCHAR(8000);

            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
                + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
                         '[ssp_ValidateCoveragePlans]') + '*****'
                + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
                + CONVERT(VARCHAR, ERROR_STATE());

            RAISERROR (
				@Error
				,-- Message text.                                                                                                   
				16
				,-- Severity.                                                                                                    
				1 -- State.                                                                                                   
				);
        END CATCH;
    END;


GO

