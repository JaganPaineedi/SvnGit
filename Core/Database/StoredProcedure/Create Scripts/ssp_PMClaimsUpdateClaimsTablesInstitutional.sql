/****** Object:  StoredProcedure [dbo].[ssp_PMClaimsUpdateClaimsTablesInstitutional]    Script Date: 10/07/2015 12:40:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[ssp_PMClaimsUpdateClaimsTablesInstitutional]
    @CurrentUser VARCHAR(30) ,
    @ClaimFormatId INT ,
    @ClaimBatchId INT
AS
    SET ANSI_WARNINGS OFF



/*********************************************************************/
/* Stored Procedure: dbo.ssp_PMClaimsUpdateClaimsTablesInstitutional */
/* Creation Date:    9/25/06                                         */
/*                                                                   */
/* Purpose:           */
/*                                                                   */
/* Input Parameters:						     */
/*                                                                   */
/* Output Parameters:                                                */
/*                                                                   */
/* Return Status:                                                    */
/*                                                                   */
/* Called By:       */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:                                                          */
/*   Date     Author       Purpose                                    */
/*  9/25/06   JHB	  	   Created                                    */
/*	1/15/14   APoole  	   modified to use XClaimId as link (temporarily)*/
/*                     	   between the ClaimLineItemGroups and ClaimLineItems */
/*	1/17/14   APoole  	   revised to have BEGIN TRY error handling 	*/
/*  1/20/2014 NJain	  	   modified to include UB04 tables 				*/
/*  7/15/2014  NJain   	   Added logic for Voids & Rebills			 	*/
/*	10/7/2015	NJain		Updated to insert ClaimLineId in the ClaimLineItems DeletedBy column */
/*  6/8/2016	NJain		Updated to do DISTINCT Inserts into all core tables */
/*  03/20/2017  NJain		Updated to remove DeletedBy from Core Tables at the end. Bradford SGL #372*/
/*********************************************************************/


    DECLARE @CurrentDate DATETIME  
    DECLARE @Electronic CHAR(1) ---- Y or N



    SELECT  @Electronic = Electronic
    FROM    dbo.ClaimFormats
    WHERE   ClaimFormatId = @ClaimFormatId

  
    SET @CurrentDate = GETDATE()  


-- Delete old data related to the batch
    DELETE  c
    FROM    ClaimLineItemGroups a
            JOIN ClaimLIneItems b ON ( a.ClaimLineItemGroupId = b.ClaimLineItemGroupId )
            JOIN ClaimLIneItemCharges c ON ( c.ClaimLineItemId = b.ClaimLineItemId )
    WHERE   a.ClaimBatchId = @ClaimBatchId

    DELETE  b
    FROM    ClaimLineItemGroups a
            JOIN ClaimLIneItems b ON ( a.ClaimLineItemGroupId = b.ClaimLineItemGroupId )
    WHERE   a.ClaimBatchId = @ClaimBatchId

    IF @Electronic <> 'Y'
        BEGIN 
-- Delete from ClaimUB04s table
            DELETE  b
            FROM    ClaimLineItemGroups a
                    JOIN ClaimUB04s b ON ( a.ClaimLineItemGroupId = b.ClaimLineItemGroupId )
            WHERE   a.ClaimBatchId = @ClaimBatchId
        END 

    DELETE  a
    FROM    ClaimLineItemGroups a
    WHERE   a.ClaimBatchId = @ClaimBatchId

-- Update Claims tables
-- One record for each claim 
    INSERT  INTO ClaimLineItemGroups
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
                    CONVERT(VARCHAR, XClaimId)
            FROM    #XClaims


    IF @Electronic <> 'Y'
        BEGIN
-- Update #ClaimPages2 table with ClaimLineItemGroupId; specific to UB04
            UPDATE  a
            SET     a.ClaimLineItemGroupId = b.ClaimLineItemGroupId
            FROM    #ClaimPages2 a
                    JOIN ClaimLineItemGroups b ON CONVERT(VARCHAR, a.XClaimId) = b.DeletedBy
        END

-- One record for each line item 
    INSERT  INTO ClaimLineItems
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
                    JOIN ClaimLineItemGroups b ON ( CONVERT(VARCHAR, a.XClaimId) = b.DeletedBy )
            WHERE   b.ClaimBatchId = @ClaimBatchId

    UPDATE  a
    SET     LineItemControlNumber = c.ClaimLineItemId
    FROM    #ClaimLines a
            JOIN ClaimLineItemGroups b ON ( CONVERT(VARCHAR, a.XClaimId) = b.DeletedBy )
            JOIN ClaimLineItems c ON ( CONVERT(VARCHAR, c.DeletedBy) = a.ClaimLineId )
    WHERE   b.ClaimBatchId = @ClaimBatchId

   
	
    IF EXISTS ( SELECT  *
                FROM    [tempdb].[INFORMATION_SCHEMA].[COLUMNS]
                WHERE   COLUMN_NAME = 'VoidedClaimLineItemId'
                        AND TABLE_NAME LIKE '#Charges%' )
        BEGIN

            INSERT  INTO ClaimLineItemCharges
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
                            JOIN ClaimLineItemGroups c ON ( CONVERT(VARCHAR, a.XClaimId) = c.DeletedBy )
                    WHERE   c.ClaimBatchId = @ClaimBatchId
                            AND ISNULL(b.SubmissionReasonCode, '1') <> '8'
  
  
-- In case of voided claims, keep the original list of charges while voiding
            INSERT  INTO ClaimLineItemCharges
                    ( ClaimLineItemId ,
                      ChargeId ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
                    )
                    SELECT DISTINCT
                            a.LineItemControlNumber ,
                            c.ChargeId ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #ClaimLines a
                            JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                            JOIN ClaimLineItemCharges c ON b.VoidedClaimLineItemId = c.ClaimLineItemId
                            JOIN ClaimLineItemGroups d ON ( CONVERT(VARCHAR, a.XClaimId) = d.DeletedBy )
                    WHERE   d.ClaimBatchId = @ClaimBatchId
                            AND ISNULL(b.SubmissionReasonCode, '1') = '8'
  

            UPDATE  c
            SET     BillingCode = a.BillingCode ,
                    Modifier1 = a.Modifier1 ,
                    Modifier2 = a.Modifier2 ,
                    Modifier3 = a.Modifier3 ,
                    Modifier4 = a.Modifier4 ,
                    RevenueCode = a.RevenueCode ,
                    RevenueCodeDescription = a.RevenueCodeDescription
            FROM    #ClaimLines a
                    JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    JOIN Charges c ON ( b.ChargeId = c.ChargeId )
            WHERE   ISNULL(b.SubmissionReasonCode, '1') <> '8'
  
  
        END

    ELSE
        BEGIN

            INSERT  INTO ClaimLineItemCharges
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
                            JOIN ClaimLineItemGroups c ON ( CONVERT(VARCHAR, a.XClaimId) = c.DeletedBy )
                    WHERE   c.ClaimBatchId = @ClaimBatchId
                            AND ISNULL(b.SubmissionReasonCode, '1') <> '8'
  
  
            UPDATE  c
            SET     BillingCode = a.BillingCode ,
                    Modifier1 = a.Modifier1 ,
                    Modifier2 = a.Modifier2 ,
                    Modifier3 = a.Modifier3 ,
                    Modifier4 = a.Modifier4 ,
                    RevenueCode = a.RevenueCode ,
                    RevenueCodeDescription = a.RevenueCodeDescription
            FROM    #ClaimLines a
                    JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    JOIN Charges c ON ( b.ChargeId = c.ChargeId )
            WHERE   ISNULL(b.SubmissionReasonCode, '1') <> '8'
  

        END 
	
	
	
	
    UPDATE  c
    SET     DeletedBy = NULL
    FROM    ClaimLineItemGroups b
            JOIN ClaimLineItems c ON ( b.ClaimLineItemGroupId = c.ClaimLineItemGroupId )
    WHERE   b.ClaimBatchId = @ClaimBatchId

    UPDATE  b
    SET     DeletedBy = NULL
    FROM    ClaimLineItemGroups b
    WHERE   b.ClaimBatchId = @ClaimBatchId
    
    

-- Added 7/15/2014
    UPDATE  a
    SET     a.ToBeVoided = 'Y' ,
            a.OriginalClaimLineItemId = b.VoidedClaimLineItemId
    FROM    ClaimLineItems a
            JOIN #ClaimLines b ON a.ClaimLineItemId = b.LineItemControlNumber
    WHERE   b.SubmissionReasonCode = '8'

    UPDATE  a
    SET     a.ToBeResubmitted = 'Y' ,
            a.OriginalClaimLineItemId = b.VoidedClaimLineItemId
    FROM    ClaimLineItems a
            JOIN #ClaimLines b ON a.ClaimLineItemId = b.LineItemControlNumber
    WHERE   b.SubmissionReasonCode = '7'

    UPDATE  a
    SET     a.OriginalClaimLineItemId = b.VoidedClaimLineItemId
    FROM    ClaimLineItems a
            JOIN #ClaimLines b ON a.ClaimLineItemId = b.LineItemControlNumber
    WHERE   b.SubmissionReasonCode = '1'

GO
