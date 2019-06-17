BEGIN TRY
    BEGIN TRANSACTION
    IF NOT EXISTS
    (   SELECT  1
        FROM    GlobalCodes AS gc
        WHERE   ISNULL(gc.RecordDeleted, 'N') = 'N'
                AND gc.Category = 'CHARGEERRORTYPE'
                AND gc.CodeName = 'Clinician on service is not billable to this plan' )
        BEGIN
            INSERT INTO GlobalCodes ( CreatedBy,
                                      ModifiedBy,
                                      Category,
                                      CodeName,
                                      Code,
                                      Description,
                                      Active,
                                      CannotModifyNameOrDelete )
            VALUES ( 'MHP - SGL #288',                                      -- CreatedBy - type_CurrentUser
                     'MHP - SGL #288',                                      -- ModifiedBy - type_CurrentUser
                     'CHARGEERRORTYPE',                                     -- Category - char(20)
                     'Clinician on service is not billable to this plan',   -- CodeName - varchar(250)
                     'Clinician on service is not billable to this plan',   -- Code - varchar(100)
                     NULL,                                                  -- Description - type_Comment
                     'Y',                                                   -- Active - type_Active
                     'N'                                                    -- CannotModifyNameOrDelete - type_YOrN
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