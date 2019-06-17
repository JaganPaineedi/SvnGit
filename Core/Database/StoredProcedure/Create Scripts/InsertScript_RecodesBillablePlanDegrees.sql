BEGIN TRY
    BEGIN TRANSACTION
    DECLARE @CascadeCategory INT = (   SELECT TOP 1
                                                rc.RecodeCategoryId
                                       FROM     RecodeCategories AS rc
                                       WHERE    ISNULL(rc.RecordDeleted, 'N') = 'N'
                                                AND rc.CategoryCode = 'CascadePayerChargeErrors' )

    DECLARE @CodeId INT = (   SELECT TOP 1
                                    gc.GlobalCodeId
                              FROM  GlobalCodes AS gc
                              WHERE ISNULL(gc.RecordDeleted, 'N') = 'N'
                                    AND gc.Active = 'Y'
                                    AND gc.Category = 'ChargeErrorType'
                                    AND gc.CodeName = 'Clinician on service is not billable to this plan' )

    IF @CascadeCategory IS NULL
       OR   @CodeId IS NULL
        BEGIN
            RAISERROR('@CascadeCategory or @CodeId cannot be found', 16, 1)
        END

    IF NOT EXISTS
    (   SELECT  1
        FROM    Recodes AS r
        WHERE   ISNULL(r.RecordDeleted, 'N') = 'N'
                AND r.RecodeCategoryId = @CascadeCategory
                AND r.IntegerCodeId = @CodeId
                AND DATEDIFF(DAY, r.FromDate, GETDATE()) >= 0
                AND ( DATEDIFF(DAY, r.ToDate, GETDATE()) <= 0 OR r.ToDate IS NULL ))
        BEGIN
            INSERT INTO Recodes ( CreatedBy,
                                  ModifiedBy,
                                  IntegerCodeId,
                                  CharacterCodeId,
                                  CodeName,
                                  FromDate,
                                  ToDate,
                                  RecodeCategoryId )
            VALUES ( 'MHP - SGL #288',                                                      -- CreatedBy - type_CurrentUser
                     'MHP - SGL #288',                                                      -- ModifiedBy - type_CurrentUser
                     @CodeId,                                                               -- IntegerCodeId - int
                     NULL,                                                                  -- CharacterCodeId - varchar(100)
                     'Clinician on service is not billable to this plan',    -- CodeName - varchar(100)
                     '2000-01-01',                                                          -- FromDate - date
                     NULL,                                                                  -- ToDate - date
                     @CascadeCategory                                                       -- RecodeCategoryId - int
                )
        END
    COMMIT TRANSACTION
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        BEGIN
            PRINT 'Rolling back transaction...'
            ROLLBACK TRANSACTION
            PRINT 'The transaction was rolled back'
        END

    DECLARE @Error VARCHAR(8000)

    SET @Error =
        CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
        + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

    RAISERROR(@Error,
                -- Message text.
              16,
                -- Severity.
              1 -- State.
    );


END CATCH