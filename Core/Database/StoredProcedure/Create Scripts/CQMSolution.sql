IF NOT EXISTS ( SELECT  1
                FROM    INFORMATION_SCHEMA.SCHEMATA AS a
                WHERE   a.SCHEMA_NAME = 'CQMSolution' )
    BEGIN 

        EXEC sp_executesql N' CREATE SCHEMA CQMSolution';  

    END;
