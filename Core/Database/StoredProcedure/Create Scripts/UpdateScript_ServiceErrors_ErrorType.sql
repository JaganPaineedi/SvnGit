/****************************
* Update service errors to correct global code id
****************************/

--SELECT
--        se.ErrorType,se.ErrorMessage,*
BEGIN TRY
    BEGIN TRAN;
    UPDATE
            se
        SET
            se.ErrorType = CASE se.ErrorMessage
                             WHEN 'Duration does not match DateTimeIn/DateTimeOut.' THEN 4411
                             WHEN 'End Date does not equal Start Date.' THEN 4412
                             WHEN 'Duration cannot be negative.' THEN 4413
                             WHEN 'Service Date/Time does not match Time In/Time Out.' THEN 4414
                           END
        FROM
            dbo.ServiceErrors AS se
        WHERE
            se.ErrorMessage IN ( 'Duration does not match DateTimeIn/DateTimeOut.' , 'End Date does not equal Start Date.' , 'Duration cannot be negative.' ,
                                 'Service Date/Time does not match Time In/Time Out.' );
    COMMIT TRAN;
END TRY
BEGIN CATCH
                             
    IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRAN;
        END;
                             
END CATCH;
                             