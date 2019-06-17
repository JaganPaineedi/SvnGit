IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   name = 'ssp_PMClaimsUpdateClaimsTablesNew' )
    DROP PROCEDURE  dbo.ssp_PMClaimsUpdateClaimsTablesNew
GO


SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO


CREATE PROC [dbo].[ssp_PMClaimsUpdateClaimsTablesNew]
    @CurrentUser VARCHAR(30) ,
    @ClaimBatchId INT
AS /*********************************************************************  
Stored Procedure: dbo.ssp_PMClaimsUpdateClaimsTablesNew
Creation Date:    12/14/2015

Purpose: With the Claim line bundling implementation, this ssp was created 
		 from ssp_PMClaimsUpdateClaimsTables for updates to Claims tables. 
		 The original ssp is referenced by custom claims stored procedures
		 and therefore cannot be changed for this implementation.


Date			ModifiedBy		Description of Change
12/14/2015		njain			Created 
06/08/2016		NJain			Updated to do DISTINCT Inserts into all core tables
11/10/2016      Dknewtson		Adding updated void functionality. Valley - Support Go Live #738
1/13/2017       Dknewtson		correcting an issue with insert into claim line item charges for Void claims.
9/08/2017		NJain			Journey Customizations #1 - Implemented scsp_PMClaimsUpdateClaimsTablesNew to support custom claim ids
								The scsp is called twice, when deleting old data related to the batch and when inserting new claim ids for the batch
								The first call is with @Action = Delete, in the scsp you can delete data from the temp table using this
								The second call is with @Action = Insert, in the scsp you can insert data from the temp table using this
*********************************************************************/  


  
    DECLARE @CurrentDate DATETIME  
  
    SET @CurrentDate = GETDATE()  

    DECLARE @ClaimFormatId INT
	
    SELECT  @ClaimFormatId = ClaimFormatId
    FROM    dbo.ClaimBatches
    WHERE   ClaimBatchId = @ClaimBatchId

    DECLARE @e_sep CHAR(1)
    DECLARE @se_sep CHAR(1)
    DECLARE @seg_term VARCHAR(2) 

    SELECT  @e_sep = ISNULL(ComponentElementSeparator, '*') ,
            @se_sep = ISNULL(ElementDelimiter, ':') ,
            @seg_term = ISNULL(SegmentTerminator, '~') --char(13)+char(10)  
    FROM    dbo.ClaimFormats
    WHERE   ClaimFormatId = @ClaimFormatId

    DECLARE @SQL NVARCHAR(4000)

-- Delete old data related to the batch  
	
	
    IF EXISTS ( SELECT  *
                FROM    sys.procedures
                WHERE   name = 'scsp_PMClaimsUpdateClaimsTablesNew' )
        BEGIN 
			
            EXEC scsp_PMClaimsUpdateClaimsTablesNew @CurrentUser = @CurrentUser, @ClaimBatchId = @ClaimBatchId, @Action = 'D'
			
        END
        
    IF @@error <> 0
        GOTO error  
        
        
        
    DELETE  c
    FROM    dbo.ClaimLineItemGroups a
            JOIN dbo.ClaimLineItems b ON ( a.ClaimLineItemGroupId = b.ClaimLineItemGroupId )
            JOIN dbo.ClaimLineItemCharges c ON ( c.ClaimLineItemId = b.ClaimLineItemId )
    WHERE   a.ClaimBatchId = @ClaimBatchId  
	  
    IF @@error <> 0
        GOTO error  

    DELETE  b
    FROM    dbo.ClaimLineItemGroups a
            JOIN dbo.ClaimLineItemGroupStoredData b ON b.ClaimLineItemGroupId = a.ClaimLineItemGroupId
    WHERE   a.ClaimBatchId = @ClaimBatchId  
  
    IF @@error <> 0
        GOTO error  
  
    DELETE  b
    FROM    dbo.ClaimLineItemGroups a
            JOIN dbo.ClaimLineItems b ON ( a.ClaimLineItemGroupId = b.ClaimLineItemGroupId )
    WHERE   a.ClaimBatchId = @ClaimBatchId  
  
    IF @@error <> 0
        GOTO error  
  
    DELETE  a
    FROM    dbo.ClaimLineItemGroups a
    WHERE   a.ClaimBatchId = @ClaimBatchId  
  
    IF @@error <> 0
        GOTO error 
        

  
-- Update Claims tables  
-- One record for each claim   
    INSERT  INTO dbo.ClaimLineItemGroups
            ( ClaimBatchId ,
              ClientId ,
              CreatedBy ,
              CreatedDate ,
              ModifiedBy ,
              ModifiedDate ,
              DeletedBy
			)
            SELECT DISTINCT
                    @ClaimBatchId ,
                    ClientId ,
                    @CurrentUser ,
                    @CurrentDate ,
                    @CurrentUser ,
                    @CurrentDate ,
                    CONVERT(VARCHAR, ClaimId)
            FROM    #ClaimLines  
  
  -- claim stored data
    INSERT  INTO dbo.ClaimLineItemGroupStoredData
            ( ClaimLineItemGroupId ,
              CreatedBy ,
              CreatedDate ,
              ModifiedBy ,
              ModifiedDate ,
              ElementSeperator ,
              SubElementSeperator ,
              SegmentTerminator ,
              BillingProviderTaxIdType ,
              BillingProviderTaxId ,
              BillingProviderIdType ,
              BillingProviderId ,
              BillingTaxonomyCode ,
              BillingProviderLastName ,
              BillingProviderFirstName ,
              BillingProviderMiddleName ,
              BillingProviderNPI ,
              PayToProviderTaxIdType ,
              PayToProviderTaxId ,
              PayToProviderIdType ,
              PayToProviderId ,
              PayToProviderLastName ,
              PayToProviderFirstName ,
              PayToProviderMiddleName ,
              PayToProviderNPI ,
              PaymentAddress1-- VARCHAR(30) NULL
              ,
              PaymentAddress2-- VARCHAR(30) NULL
              ,
              PaymentCity-- VARCHAR(30) NULL
              ,
              PaymentState-- CHAR(2) NULL
              ,
              PaymentZip-- VARCHAR(25) NULL
              ,
              PaymentPhone-- VARCHAR(10) NULL
              ,
              ClientId ,
              InsuredId ,
              ChargePriority ,
              CoveragePlanId ,
              GroupNumber ,
              GroupName ,
              InsuredLastName ,
              InsuredFirstName ,
              InsuredMiddleName ,
              InsuredSuffix ,
              InsuredRelation ,
              InsuredRelationCode ,
              InsuredAddress1 ,
              InsuredAddress2 ,
              InsuredCity ,
              InsuredState ,
              InsuredZip ,
              InsuredHomePhone ,
              InsuredSex ,
              InsuredSSN ,
              InsuredDOB ,
              ClientLastName ,
              ClientFirstname ,
              ClientMiddleName ,
              ClientSSN ,
              ClientSuffix ,
              ClientAddress1 ,
              ClientAddress2 ,
              ClientCity ,
              ClientState ,
              ClientZip ,
              ClientHomePhone ,
              ClientDOB ,
              ClientSex ,
              ClientIsSubscriber ,
              PayerAddress1 ,
              PayerAddress2 ,
              PayerCity ,
              PayerState ,
              PayerZip ,
              PayerName ,
              ProviderCommercialNumber --VARCHAR(50) NULL
              ,
              InsuranceCommissionersCode-- VARCHAR(50) NULL
              ,
              MedicareInsuranceTypeCode --CHAR(2) NULL
              ,
              ClaimFilingIndicatorCode --CHAR(2) NULL
              ,
              ElectronicClaimsPayerId ,
              ClaimOfficeNumber
			)
            SELECT  clig.ClaimLineItemGroupId -- ClaimLineItemGroupId - int
                    ,
                    @CurrentUser-- CreatedBy - type_CurrentUser
                    ,
                    @CurrentDate-- CreatedDate - type_CurrentDatetime
                    ,
                    @CurrentUser-- ModifiedBy - type_CurrentUser
                    ,
                    @CurrentDate-- ModifiedDate - type_CurrentDatetime
                    ,
                    @e_sep-- ElementSeperator - char(1)
                    ,
                    @se_sep-- SubElementSeperator - char(1)
                    ,
                    @seg_term-- SegmentTerminator - char(1)
                    ,
                    MAX(cl.BIllingProviderTaxIdType)-- BillingProviderTaxIdType - varchar(2)
                    ,
                    MAX(cl.BillingProviderTaxId) ,
                    MAX(cl.BillingProviderIdType) ,
                    MAX(cl.BillingProviderId) ,
                    MAX(cl.BillingTaxonomyCode) ,
                    MAX(cl.BillingProviderLastName) ,
                    MAX(cl.BillingProviderFirstName) ,
                    MAX(cl.BillingProviderMiddleName) ,
                    MAX(cl.BillingProviderNPI) ,
                    MAX(cl.PayToProviderTaxIdType) ,
                    MAX(cl.PayToProviderTaxId) ,
                    MAX(cl.PayToProviderIdType) ,
                    MAX(cl.PayToProviderId) ,
                    MAX(cl.PayToProviderLastName) ,
                    MAX(cl.PayToProviderFirstName) ,
                    MAX(cl.PayToProviderMiddleName) ,
                    MAX(cl.PayToProviderNPI) ,
                    MAX(cl.PaymentAddress1)-- VARCHAR(30) NULL
                    ,
                    MAX(cl.PaymentAddress2)-- VARCHAR(30) NULL
                    ,
                    MAX(cl.PaymentCity)-- VARCHAR(30) NULL
                    ,
                    MAX(cl.PaymentState)-- CHAR(2) NULL
                    ,
                    MAX(cl.PaymentZip)-- VARCHAR(25) NULL
                    ,
                    MAX(cl.PaymentPhone)-- VARCHAR(10) NULL
                    ,
                    MAX(cl.ClientId) ,
                    MAX(cl.InsuredId) ,
                    MAX(cl.[Priority]) ,
                    MAX(cl.CoveragePlanId) ,
                    MAX(cl.GroupNumber) ,
                    MAX(cl.GroupName) ,
                    MAX(cl.InsuredLastName) ,
                    MAX(cl.InsuredFirstName) ,
                    MAX(cl.InsuredMiddleName) ,
                    MAX(cl.InsuredSuffix) ,
                    MAX(cl.InsuredRelation) ,
                    MAX(cl.InsuredRelationCode) ,
                    MAX(cl.InsuredAddress1) ,
                    MAX(cl.InsuredAddress2) ,
                    MAX(cl.InsuredCity) ,
                    MAX(cl.InsuredState) ,
                    MAX(cl.InsuredZip) ,
                    MAX(cl.InsuredHomePhone) ,
                    MAX(cl.InsuredSex) ,
                    MAX(cl.InsuredSSN) ,
                    MAX(cl.InsuredDOB) ,
                    MAX(cl.ClientLastName) ,
                    MAX(cl.ClientFirstname) ,
                    MAX(cl.ClientMiddleName) ,
                    MAX(cl.ClientSSN) ,
                    MAX(cl.ClientSuffix) ,
                    MAX(cl.ClientAddress1) ,
                    MAX(cl.ClientAddress2) ,
                    MAX(cl.ClientCity) ,
                    MAX(cl.ClientState) ,
                    MAX(cl.ClientZip) ,
                    MAX(cl.ClientHomePhone) ,
                    MAX(cl.ClientDOB) ,
                    MAX(cl.ClientSex) ,
                    MAX(cl.ClientIsSubscriber) ,
                    MAX(cl.PayerAddress1) ,
                    MAX(cl.PayerAddress2) ,
                    MAX(cl.PayerCity) ,
                    MAX(cl.PayerState) ,
                    MAX(cl.PayerZip) ,
                    MAX(cl.PayerName) ,
                    MAX(cl.ProviderCommercialNumber) --VARCHAR(50) NULL
                    ,
                    MAX(cl.InsuranceCommissionersCode)-- VARCHAR(50) NULL
                    ,
                    MAX(cl.MedicareInsuranceTypeCode)--CHAR(2) NULL
                    ,
                    MAX(cl.ClaimFilingIndicatorCode)--CHAR(2) NULL
                    ,
                    MAX(cl.ElectronicClaimsPayerId) ,
                    MAX(cl.ClaimOfficeNumber)
            FROM    #ClaimLines cl
                    JOIN dbo.ClaimLineItemGroups clig ON ( CONVERT(VARCHAR, cl.ClaimId) = clig.DeletedBy )
                                                         AND clig.ClaimBatchId = @ClaimBatchId
            GROUP BY clig.ClaimLineItemGroupId

    IF @@error <> 0
        GOTO error  

    IF EXISTS ( SELECT  1
                FROM    tempdb.INFORMATION_SCHEMA.COLUMNS
                WHERE   COLUMN_NAME = 'ClaimLineItemGroupId'
                        AND TABLE_NAME LIKE '#ClaimLines%' )
        BEGIN
            SET @SQL = '
				UPDATE	a
				SET		ClaimLineItemGroupId = b.ClaimLineItemGroupId
				FROM	#ClaimLines a
				JOIN	dbo.ClaimLineItemGroups b ON ( CONVERT(VARCHAR, a.ClaimId) = b.DeletedBy )
														AND b.ClaimBatchId = ' + CONVERT(VARCHAR, @ClaimBatchId)

            EXEC(@SQL)

        END
    IF @@error <> 0
        GOTO error  
    IF NOT EXISTS ( SELECT  1
                    FROM    tempdb.sys.columns c
                    WHERE   c.object_id = OBJECT_ID('tempdb..#ClaimLines')
                            AND c.name = 'ToVoidClaimLineItemGroupId' )
        BEGIN
-- One record for each line item (same as number of claims in case of 837)  
            INSERT  INTO dbo.ClaimLineItems
                    ( ClaimLineItemGroupId ,
                      BillingCode ,
                      Modifier1 ,
                      Modifier2 ,
                      Modifier3 ,
                      Modifier4 ,
                      RevenueCode ,
                      RevenueCodeDescription ,
                      Units ,
                      DateOfService ,
                      ChargeAmount ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate ,
                      DeletedBy
			        )
                    SELECT DISTINCT
                            b.ClaimLineItemGroupId ,
                            a.BillingCode ,
                            a.Modifier1 ,
                            a.Modifier2 ,
                            a.Modifier3 ,
                            a.Modifier4 ,
                            a.RevenueCode ,
                            a.RevenueCodeDescription ,
                            a.ClaimUnits ,
                            a.DateOfService ,
                            a.ChargeAmount ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate ,
                            CONVERT(VARCHAR, a.ClaimLineId)
                    FROM    #ClaimLines a
                            JOIN dbo.ClaimLineItemGroups b ON ( CONVERT(VARCHAR, a.ClaimId) = b.DeletedBy )
                    WHERE   b.ClaimBatchId = @ClaimBatchId
                            AND a.SubmissionReasonCode <> '8'

        END

-- Create Claim Line Item Charges for Void Claims. Need to match the old claim.
    IF EXISTS ( SELECT  1
                FROM    tempdb.sys.columns c
                WHERE   c.object_id = OBJECT_ID('tempdb..#ClaimLines')
                        AND c.name = 'ToVoidClaimLineItemGroupId' )
        BEGIN
            SET @SQL = '
			INSERT	INTO dbo.ClaimLineItems
			( ClaimLineItemGroupId
			, BillingCode
			, Modifier1
			, Modifier2
			, Modifier3
			, Modifier4
			, RevenueCode
			, RevenueCodeDescription
			, Units
			, DateOfService
			, ChargeAmount
			, CreatedBy
			, CreatedDate
			, ModifiedBy
			, ModifiedDate
			, DeletedBy
			)
			SELECT DISTINCT
					b.ClaimLineItemGroupId
				  , a.BillingCode
				  , a.Modifier1
				  , a.Modifier2
				  , a.Modifier3
				  , a.Modifier4
				  , a.RevenueCode
				  , a.RevenueCodeDescription
				  , a.ClaimUnits
				  , a.DateOfService
				  , a.ChargeAmount
				  , ''' + @CurrentUser + '''
				  , ''' + CONVERT(VARCHAR, @CurrentDate, 126) + '''
				  , ''' + @CurrentUser + '''
				  , ''' + CONVERT(VARCHAR, @CurrentDate, 126) + '''
				  , CONVERT(VARCHAR, a.ClaimLineId)
			FROM	#ClaimLines a
			JOIN	dbo.ClaimLineItemGroups b ON ( CONVERT(VARCHAR, a.ClaimId) = b.DeletedBy )
			WHERE	b.ClaimBatchId = ' + CONVERT(VARCHAR, @ClaimBatchId) + '
					AND (a.SubmissionReasonCode <> ''8''
					OR ToVoidClaimLineItemGroupId IS NULL)

			INSERT	INTO dbo.ClaimLineItems
					( ClaimLineItemGroupId
					, BillingCode
					, Modifier1
					, Modifier2
					, Modifier3
					, Modifier4
					, RevenueCode
					, RevenueCodeDescription
					, Units
					, DateOfService
					, ChargeAmount
					, OriginalClaimLineItemId
					, ToBeVoided
					, CreatedBy
					, CreatedDate
					, ModifiedBy
					, ModifiedDate
					, DeletedBy
					)
					SELECT DISTINCT
							b.ClaimLineItemGroupId
						  , a.BillingCode
						  , a.Modifier1
						  , a.Modifier2
						  , a.Modifier3
						  , a.Modifier4
						  , a.RevenueCode
						  , a.RevenueCodeDescription
						  , a.Units
						  , a.DateOfService
						  , a.ChargeAmount
						  , a.ClaimLineItemId
						  , ''Y''
						  , ''' + @CurrentUser + '''
						  , ''' + CONVERT(VARCHAR, @CurrentDate, 126) + '''
						  , ''' + @CurrentUser + '''
						  , ''' + CONVERT(VARCHAR, @CurrentDate, 126) + '''
						  , CONVERT(VARCHAR, cl.ClaimLineId)
					FROM	dbo.ClaimLineItems AS a
					JOIN	#ClaimLines cl ON cl.ToVoidClaimLineItemGroupId = a.ClaimLineItemGroupId
					JOIN	dbo.ClaimLineItemGroups b ON ( CONVERT(VARCHAR, cl.ClaimId) = b.DeletedBy )
					

			
			INSERT	INTO dbo.ClaimLineItemCharges
					( ClaimLineItemId
					, ChargeId
					, CreatedBy
					, CreatedDate
					, ModifiedBy
					, ModifiedDate
					)
					SELECT DISTINCT
							cli.ClaimLineItemId
						  , clic.ChargeId
						  , ''' + @CurrentUser + '''
						  , ''' + CONVERT(VARCHAR, @CurrentDate, 126) + '''
						  , ''' + @CurrentUser + '''
						  , ''' + CONVERT(VARCHAR, @CurrentDate, 126) + '''
					FROM	#ClaimLines cl
					JOIN	dbo.ClaimLineItems AS cli ON  CONVERT(Varchar,cl.ClaimLineId) = cli.DeletedBy
					JOIN	ClaimLineItems cli2 on cli2.ClaimLineItemId = cli.OriginalClaimLineItemId
					JOIN	ClaimLineItemCharges clic on clic.ClaimLineItemId = cli2.ClaimLineItemId

			'

            EXEC(@SQL)

        END
  
    IF @@error <> 0
        GOTO error  
  
    
    UPDATE  a
    SET     LineItemControlNumber = b.ClaimLineItemId
    FROM    #ClaimLines a
            JOIN dbo.ClaimLineItems b ON b.DeletedBy = CONVERT(VARCHAR, a.ClaimLineId)
            JOIN dbo.ClaimLineItemGroups c ON c.ClaimLineItemGroupId = b.ClaimLineItemGroupId
    WHERE   c.ClaimBatchId = @ClaimBatchId  
    
    
    IF @@error <> 0
        GOTO error  
  
    UPDATE  c
    SET     c.DeletedBy = NULL
    FROM    dbo.ClaimLineItemGroups b
            JOIN dbo.ClaimLineItems c ON ( b.ClaimLineItemGroupId = c.ClaimLineItemGroupId )
    WHERE   b.ClaimBatchId = @ClaimBatchId  
  
    IF @@error <> 0
        GOTO error  
  
    UPDATE  b
    SET     b.DeletedBy = NULL
    FROM    dbo.ClaimLineItemGroups b
    WHERE   b.ClaimBatchId = @ClaimBatchId  
  
    IF @@error <> 0
        GOTO error 

    IF NOT EXISTS ( SELECT  1
                    FROM    tempdb.sys.columns c
                    WHERE   c.object_id = OBJECT_ID('tempdb..#ClaimLines')
                            AND c.name = 'ToVoidClaimLineItemGroupId' )
        BEGIN

            INSERT  INTO dbo.ClaimLineItemCharges
                    ( ClaimLineItemId ,
                      ChargeId ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
					)
                    SELECT DISTINCT
                            a.LineItemControlNumber ,
                            b.ChargeId ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #ClaimLines a
                            JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   ISNULL(b.SubmissionReasonCode, '1') <> '8'
  
            IF @@error <> 0
                GOTO error  
  

            UPDATE  c
            SET     c.BillingCode = a.BillingCode ,
                    c.Modifier1 = a.Modifier1 ,
                    c.Modifier2 = a.Modifier2 ,
                    c.Modifier3 = a.Modifier3 ,
                    c.Modifier4 = a.Modifier4 ,
                    c.RevenueCode = a.RevenueCode ,
                    c.RevenueCodeDescription = a.RevenueCodeDescription
            FROM    #ClaimLines a
                    JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    JOIN dbo.Charges c ON ( b.ChargeId = c.ChargeId )
            WHERE   ISNULL(b.SubmissionReasonCode, '1') <> '8'
  
            IF @@error <> 0
                GOTO error  

        END
    ELSE
        BEGIN
            SET @SQL = 'INSERT	INTO dbo.ClaimLineItemCharges
					( ClaimLineItemId
					, ChargeId
					, CreatedBy
					, CreatedDate
					, ModifiedBy
					, ModifiedDate
					)
					SELECT DISTINCT
							a.LineItemControlNumber
						  , b.ChargeId
						  , ''' + @CurrentUser + '''
						  , ''' + CONVERT(VARCHAR, @CurrentDate, 126) + '''
						  , ''' + @CurrentUser + '''
						  , ''' + CONVERT(VARCHAR, @CurrentDate, 126) + '''
					FROM	#ClaimLines a
					JOIN	#Charges b ON ( a.ClaimLineId = b.ClaimLineId )			
					WHERE	(ISNULL(b.SubmissionReasonCode, ''1'') <> ''8''
							or ToVoidClaimLineItemGroupId is null)
					
			
			UPDATE	c
			SET		c.BillingCode = a.BillingCode
				  , c.Modifier1 = a.Modifier1
				  , c.Modifier2 = a.Modifier2
				  , c.Modifier3 = a.Modifier3
				  , c.Modifier4 = a.Modifier4
				  , c.RevenueCode = a.RevenueCode
				  , c.RevenueCodeDescription = a.RevenueCodeDescription
			FROM	#ClaimLines a
			JOIN	#Charges b ON ( a.ClaimLineId = b.ClaimLineId )
			JOIN	dbo.Charges c ON ( b.ChargeId = c.ChargeId )
			WHERE	(ISNULL(b.SubmissionReasonCode, ''1'') <> ''8''
					or ToVoidClaimLineItemGroupId is null)'
        
		
            EXEC(@SQL)

        END
        

-- Added 7/15/2014
	--UPDATE	a
	--SET		a.ToBeVoided = 'Y'
	--	  , a.OriginalClaimLineItemId = b.VoidedClaimLineItemId
	--FROM	dbo.ClaimLineItems a
	--JOIN	#ClaimLines b ON a.ClaimLineItemId = b.LineItemControlNumber
	--WHERE	b.SubmissionReasonCode = '8'
	--		AND b.VoidedClaimLineItemId IS NOT NULL

    UPDATE  a
    SET     a.ToBeResubmitted = 'Y' ,
            a.OriginalClaimLineItemId = b.VoidedClaimLineItemId
    FROM    dbo.ClaimLineItems a
            JOIN #ClaimLines b ON a.ClaimLineItemId = b.LineItemControlNumber
    WHERE   b.SubmissionReasonCode = '7'

    UPDATE  a
    SET     a.OriginalClaimLineItemId = b.VoidedClaimLineItemId
    FROM    dbo.ClaimLineItems a
            JOIN #ClaimLines b ON a.ClaimLineItemId = b.LineItemControlNumber
    WHERE   b.SubmissionReasonCode = '1'
	
	
    IF EXISTS ( SELECT  *
                FROM    sys.procedures
                WHERE   name = 'scsp_PMClaimsUpdateClaimsTablesNew' )
        BEGIN 
			
            EXEC scsp_PMClaimsUpdateClaimsTablesNew @CurrentUser = @CurrentUser, @ClaimBatchId = @ClaimBatchId, @Action = 'I'
			
        END
	
	
	
    error:  
GO

