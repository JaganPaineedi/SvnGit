/****** Object:  StoredProcedure [dbo].[ssp_PMClaims837InstiutionalValidations]    Script Date: 10/15/2015 10:31:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[ssp_PMClaims837InstiutionalValidations]
    @CurrentUser VARCHAR(30) ,
    @ClaimBatchId INT ,
    @FormatType CHAR(1) ,
    @Electronic CHAR(1)
AS
    SET ANSI_WARNINGS OFF

/*********************************************************************
/* Stored Procedure: dbo.ssp_PMClaims837InstiutionalValidations                         */
/* Creation Date:    3/13/14	NJain                                         */
/*					 8/18/2015	NJain	Updated to validate for Attending provider only when there is an Admit Date */
/*					 10/15/2015	NJain	Updated to always look for Revenue Code */
/*					 2/1/2017   NJain	Added validation that Claim Frequency Code of 7 requires a Payer Claim Number */
********************************************************************/


    DECLARE @CurrentDate DATETIME

    SET @CurrentDate = GETDATE()


    IF EXISTS ( SELECT  *
                FROM    #ClaimLines
                WHERE   LTRIM(RTRIM(ISNULL(AttendingProviderId, ''))) = ''
                        AND InpatientAdmitDate IS NOT NULL )
        BEGIN  
            INSERT  INTO ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
                    )
                    SELECT  b.ChargeId ,
                            4556 ,
                            'Required field Attending Provider Id is missing' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #ClaimLines a
                            JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   ISNULL(LTRIM(RTRIM(a.AttendingProviderId)), '') = ''
                            AND a.InpatientAdmitDate IS NOT NULL
  
            IF @@error <> 0
                GOTO error    
        END


    IF EXISTS ( SELECT  *
                FROM    #ClaimLines
                WHERE   ISNULL(PlaceOfServiceCode, '') IN ( '21', '31', '51', '52', '62' )
                        AND RelatedHospitalAdmitDate IS NULL )
        BEGIN  
            INSERT  INTO ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
                    )
                    SELECT  b.ChargeId ,
                            4556 ,
                            'Admit date is required for Inpatient claims. Please set Registration date field for the Client' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #ClaimLines a
                            JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   ISNULL(a.PlaceOfServiceCode, '') IN ( '21', '31', '51', '62' )
                            AND a.RelatedHospitalAdmitDate IS NULL  
  
            IF @@error <> 0
                GOTO error  
  
        END  


    IF EXISTS ( SELECT  *
                FROM    #ClaimLines
                WHERE   ISNULL(LTRIM(RTRIM(RevenueCode)), '') = '' )
        BEGIN  
            INSERT  INTO ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
                    )
                    SELECT  b.ChargeId ,
                            4556 ,
                            'Missing Revenue Code. Please check Procedure Rates/Billing Codes' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #ClaimLines a
                            JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   ISNULL(LTRIM(RTRIM(a.RevenueCode)), '') = ''  
  
            IF @@error <> 0
                GOTO error  
  
        END  


    IF EXISTS ( SELECT  *
                FROM    #ClaimLines
                WHERE   InpatientAdmitDate IS NOT NULL
                        AND ( ISNULL(AdmissionTypeCode, '') = ''
                              OR ISNULL(AdmissionSourceCode, '') = ''
                              OR ISNULL(PatientStatusCode, '') = ''
                              OR ISNULL(AuthorizationNumber, '') = ''
                            ) )
        BEGIN 
            INSERT  INTO ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
                    )
                    SELECT  b.ChargeId ,
                            4556 ,
                            'Missing Admission Type Code.' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #ClaimLines a
                            JOIN #Charges b ON a.ClaimLineId = b.ClaimLineId
                    WHERE   a.InpatientAdmitDate IS NOT NULL
                            AND ISNULL(a.AdmissionTypeCode, '') = ''
 
            INSERT  INTO ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
                    )
                    SELECT  b.ChargeId ,
                            4556 ,
                            'Missing Admission Source Code.' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #ClaimLines a
                            JOIN #Charges b ON a.ClaimLineId = b.ClaimLineId
                    WHERE   a.InpatientAdmitDate IS NOT NULL
                            AND ISNULL(a.AdmissionSourceCode, '') = ''

            INSERT  INTO ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
                    )
                    SELECT  b.ChargeId ,
                            4556 ,
                            'Missing Patient Status Code.' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #ClaimLines a
                            JOIN #Charges b ON a.ClaimLineId = b.ClaimLineId
                    WHERE   a.InpatientAdmitDate IS NOT NULL
                            AND ISNULL(a.PatientStatusCode, '') = '' 
                            
            --INSERT  INTO ChargeErrors
            --        ( ChargeId ,
            --          ErrorType ,
            --          ErrorDescription ,
            --          CreatedBy ,
            --          CreatedDate ,
            --          ModifiedBy ,
            --          ModifiedDate
            --        )
            --        SELECT  b.ChargeId ,
            --                4556 ,
            --                'Missing Authorization Number.' ,
            --                @CurrentUser ,
            --                @CurrentDate ,
            --                @CurrentUser ,
            --                @CurrentDate
            --        FROM    #ClaimLines a
            --                JOIN #Charges b ON a.ClaimLineId = b.ClaimLineId
            --        WHERE   a.InpatientAdmitDate IS NOT NULL
            --                AND ISNULL(a.AuthorizationNumber, '') = ''
 
        END

    IF EXISTS ( SELECT  *
                FROM    #ClaimLines
                WHERE   ISNULL(LTRIM(RTRIM(DiagnosisCode1)), '') = '' )
        BEGIN  
            INSERT  INTO ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
                    )
                    SELECT  b.ChargeId ,
                            4556 ,
                            'Primary diagnosis missing or invalid. Please check Service Details' ,
                            @CurrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #ClaimLines a
                            JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    WHERE   ISNULL(LTRIM(RTRIM(a.DiagnosisCode1)), '') = ''  
  
            IF @@error <> 0
                GOTO error  
  
        END

-- Added 4/22/2014
-- Diagnosis Document Errors

    IF EXISTS ( SELECT  *
                FROM    #DiagnosisDocumentErrors )
        BEGIN

            INSERT  INTO ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
                    )
                    SELECT DISTINCT
                            b.ChargeId ,
                            4556 ,
                            ErrorMessage ,
                            --'Client Id:' + CONVERT(VARCHAR, c.ClientId) + ' does not have a Diagnosis Document' ,
                            @CUrrentUser ,
                            @CurrentDate ,
                            @CurrentUser ,
                            @CurrentDate
                    FROM    #ClaimLines a
                            JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                            JOIN #DiagnosisDocumentErrors c ON ( a.XClaimId = c.XClaimId )
 

-- Corrected Claims Validation for Payer Claim Number
            IF EXISTS ( SELECT  *
                        FROM    #ClaimLines
                        WHERE   ISNULL(ClaimFrequencyCode, '0') = '7' )
                BEGIN 
		
                    INSERT  INTO ChargeErrors
                            ( ChargeId ,
                              ErrorType ,
                              ErrorDescription ,
                              CreatedBy ,
                              CreatedDate ,
                              ModifiedBy ,
                              ModifiedDate
                            )
                            SELECT DISTINCT
                                    b.ChargeId ,
                                    4556 ,
                                    'Payer Claim Number is required for Corrected Claims' ,
                                    @CUrrentUser ,
                                    @CurrentDate ,
                                    @CurrentUser ,
                                    @CurrentDate
                            FROM    #ClaimLines a
                                    JOIN #Charges b ON a.ClaimLineId = b.ClaimLineId
                            WHERE   ISNULL(a.ClaimFrequencyCode, '0') = '7'
		
                END


        END 


    RETURN  
  
    error: 


GO
