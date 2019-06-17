--Remove configuration

UPDATE Screens 
SET ValidationStoredProcedureUpdate = NULL 
WHERE ValidationStoredProcedureUpdate = 'ssp_SCValidateClientAddressHistory'
AND ScreenId = 2210

--Remove object
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_SCValidateClientAddressHistory')
                    AND type IN ( N'P', N'PC' ) )
    BEGIN
        DROP PROCEDURE ssp_SCValidateClientAddressHistory;
    END;
GO