-- Purpose : To update the WarningStoreProcedureUpdate SP 'ssp_WarningConfigurationKeyDetails' of  Configuration Key Details screen as part of Mobile-#6
-- Author :  Vishnu Narayanan  
-- Date   :  16 Jan 2019 

IF EXISTS
(
    SELECT 1
    FROM Screens
    WHERE ScreenId = 1061
          AND ISNULL(RecordDeleted, 'N') = 'N'
)
    BEGIN
        IF EXISTS
(
    SELECT 1
    FROM Screens
    WHERE ScreenId = 1061
          AND ISNULL(RecordDeleted, 'N') = 'N'
          AND WarningStoreProcedureUpdate <> 'ssp_WarningConfigurationKeyDetails'
)
            BEGIN
                RAISERROR('<<< FAILED updating WarningStoreProcedureUpdate. Different Stored Procedure already exists. >>>', 16, 1);
            END;
            ELSE
			BEGIN
        UPDATE Screens
          SET
              WarningStoreProcedureUpdate = 'ssp_WarningConfigurationKeyDetails'
        WHERE ScreenId = 1061;
		END
    END;