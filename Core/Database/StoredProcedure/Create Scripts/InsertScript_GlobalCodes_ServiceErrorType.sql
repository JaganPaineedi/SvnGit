/************************************
* Create new core global codes
************************************/
BEGIN TRY
BEGIN TRAN
SET IDENTITY_INSERT dbo.GlobalCodes ON;

INSERT INTO dbo.GlobalCodes
        ( GlobalCodeId ,
          Category ,
          CodeName ,
          Code ,
          Active ,
          CannotModifyNameOrDelete
        )
    SELECT
            4411 ,
            'SERVICEERRORTYPE' ,
            'Duration does not match DateTimeIn/DateTimeOut.' ,
            'DURATIONDOESNOTMATCH' ,
            'Y' ,
            'Y'
    UNION ALL
    SELECT
            4412 ,
            'SERVICEERRORTYPE' ,
            'End Date does not equal Start Date.' ,
            'ENDDATEDOESNOTEQUAL' ,
            'Y' ,
            'Y'
    UNION ALL
    SELECT
            4413 ,
            'SERVICEERRORTYPE' ,
            'Duration cannot be negative.' ,
            'DURATIONCANNOTBENEGATIVE' ,
            'Y' ,
            'Y'
    UNION ALL
    SELECT
            4414 ,
            'SERVICEERRORTYPE' ,
            'Service Date/Time does not match Time In/Time Out.' ,
            'SERVICEDATETIMEDOESNOTMATCH' ,
            'Y' ,
            'Y';
SET IDENTITY_INSERT dbo.GlobalCodes OFF; 


    COMMIT TRAN;
END TRY
BEGIN CATCH
                             
    IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRAN;
        END;
                             
END CATCH;