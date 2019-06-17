/****** Object:  StoredProcedure [dbo].[ssp_PMClaims837ProfessionalValidations]    Script Date: 11/17/2015 11:20:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
        
ALTER PROC [dbo].[ssp_PMClaims837ProfessionalValidations]
    @CurrentUser VARCHAR(30) ,
    @ClaimBatchId INT ,
    @FormatType CHAR(1) ,
    @Electronic CHAR(1)
AS
    SET ANSI_WARNINGS OFF

/*********************************************************************
/* Stored Procedure: dbo.ssp_PMClaims837ProfessionalValidations                         */
/* Creation Date:    3/13/14	NJain                                         */
/*					 9/4/2015	NJain	Updated to look at #ServiceDiagnosis for Electronic claims */
/*					10/09/2015 Streamline	Deleted out Charge Error checks:  "'Invalid Diagnosis ' + ISNULL(z.DiagnosisCode, '') + '. Please check Service or Other services on same day.'"	*/
/*					 11/08/2015 NJain	Added DiagnosisCode1 validation */
/*					 11/17/2015 Njain	Updated Paper Claim Validation */
/*					 02/23/2015 NJain	Added Validation for ClaimLineIds missing in the #ClaimLineDiagnoses table */
********************************************************************/

    BEGIN
        BEGIN TRY
            DECLARE @ErrorMessage VARCHAR(MAX)
            DECLARE @CurrentDate DATETIME

            SET @CurrentDate = GETDATE()


            IF EXISTS ( SELECT  *
                        FROM    #ClaimLines
                        WHERE   ISNULL(LTRIM(RTRIM(BillingCode)), '') = '' )
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
                                    'Missing Billing Code. Please check Procedure Rates/Billing Codes' ,
                                    @CurrentUser ,
                                    @CurrentDate ,
                                    @CurrentUser ,
                                    @CurrentDate
                            FROM    #ClaimLines a
                                    JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                            WHERE   ISNULL(LTRIM(RTRIM(a.BillingCode)), '') = ''  
                                
                                
                                
                   
                END  
                
            IF @Electronic = 'Y'
                BEGIN  
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
  
                            
  
                        END 
                END
                
                
                
            IF @Electronic = 'N'
                BEGIN  
                    IF EXISTS ( SELECT  *
                                FROM    #ClaimLineDiagnoses837
                                WHERE   ISNULL(LTRIM(RTRIM(PrimaryDiagnosis)), '') = '' )
                        OR EXISTS ( SELECT  *
                                    FROM    #ClaimLines a
                                            LEFT JOIN #ClaimLineDiagnoses837 b ON b.ClaimLineId = a.ClaimLineId
                                    WHERE   b.ClaimLineId IS NULL )
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
                                            JOIN #ClaimLineDiagnoses837 c ON c.ClaimLineId = a.ClaimLineId
                                    WHERE   ISNULL(LTRIM(RTRIM(c.PrimaryDiagnosis)), '') = ''
                                            AND ISNULL(c.DiagnosisCode, '') = ''
                                    UNION
                                    SELECT  b.ChargeId ,
                                            4556 ,
                                            'Primary diagnosis missing or invalid. Please check Service Details' ,
                                            @CurrentUser ,
                                            @CurrentDate ,
                                            @CurrentUser ,
                                            @CurrentDate
                                    FROM    #ClaimLines a
                                            JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                                            LEFT JOIN #ClaimLineDiagnoses837 c ON c.ClaimLineId = a.ClaimLineId
                                    WHERE   c.ClaimLineId IS NULL
                            
                            
                            
                            
							
                        END 
                END
                
                
                
        END TRY
    
        
        BEGIN CATCH
            DECLARE @ThisProcedureName VARCHAR(255) = ISNULL(OBJECT_NAME(@@PROCID), 'Testing')
            DECLARE @ErrorProc VARCHAR(4000) = CONVERT(VARCHAR(4000), ISNULL(ERROR_PROCEDURE(), @ThisProcedureName))                 
            SET @ErrorMessage = @ThisProcedureName + ' Reports Error Thrown by: ' + @ErrorProc + CHAR(13)
            SET @ErrorMessage += ISNULL(+CONVERT(VARCHAR(4000), ERROR_MESSAGE()), 'Unknown')
                    
                    --+ CHAR(13) + @ThisProcedureName + ' Variable dump:' + CHAR(13) 
                    --+ '@TableName:' + ISNULL(@TableName, 'Null') + CHAR(13) 
                    --+ '@IdentityColumn:' + ISNULL(@IdentityColumn,'Null') + CHAR(13)
                    --+ ISNULL(CAST(@DataStoreValues AS VARCHAR(MAX)), 'No ##DataStore') 
    
            RAISERROR                                                                                               
              (                                                               
               @ErrorMessage, -- Message.   
               16, -- Severity.   
               1 -- State.   
              );      
        END CATCH
    
    END




GO
