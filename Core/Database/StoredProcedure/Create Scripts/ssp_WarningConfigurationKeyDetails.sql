
/****** Object:  StoredProcedure [dbo].[ssp_WarningConfigurationKeyDetails]    Script Date: 16/01/2019 17:19:28 ******/

IF EXISTS
(
    SELECT *
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[ssp_WarningConfigurationKeyDetails]')
          AND type IN(N'P', N'PC')
)
    DROP PROCEDURE [dbo].[ssp_WarningConfigurationKeyDetails];
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE PROCEDURE [dbo].[ssp_WarningConfigurationKeyDetails]
(@CurrentUserId INT,
 @ScreenKeyId   INT
)  
	
/**************************************************************************************                                                    
-- Stored Procedure : ssp_WarningConfigurationKeyDetails
--  
-- Copyright : Streamline Healthcate Solutions  
--  
-- Purpose : To display Warning while user changing SystemConfigurationKey value  
--  
-- Author :  Vishnu Narayanan  
-- Date   :  16 Jan 2019  
--			
-- Date			 Author			    Purpose 
-- 16 Jan 2019   Vishnu Narayanan   Mobile-#6				
***************************************************************************************/
	
AS
     BEGIN
         BEGIN TRY
             CREATE TABLE #WarningReturnTable
(TableName       VARCHAR(200),
 ColumnName      VARCHAR(200),
 ErrorMessage    VARCHAR(MAX),
 PageIndex       INT,
 TabOrder        INT,
 ValidationOrder INT
);
             DECLARE @ConfigurationKey VARCHAR(MAX);
             DECLARE @ErrorMessage VARCHAR(MAX);
             SET @ConfigurationKey =
(
    SELECT [Key]
    FROM SystemConfigurationKeys
    WHERE SystemConfigurationKeyId = @ScreenKeyId
          AND [Value] = 'Yes'
          AND ISNULL(RecordDeleted, 'N') = 'N'
);
             IF @ConfigurationKey = 'EnableMobileTFA'
                 BEGIN
                     INSERT INTO #WarningReturnTable
(TableName,
 ColumnName,
 ErrorMessage,
 PageIndex,
 TabOrder,
 ValidationOrder
)
                     VALUES
('SystemConfigurationKeys',
 'Value',
 'Enabling this may result in these users getting locked out of application unless their phonenumber or email or push notification setup and enabled.',
 1,
 1,
 1
);
                 END;
             SELECT TableName,
                    ColumnName,
                    ErrorMessage,
                    1,
                    1
             FROM #WarningReturnTable;
         END TRY
         BEGIN CATCH
             DECLARE @Error VARCHAR(8000);
             SET @Error = CONVERT(VARCHAR, ERROR_NUMBER())+'*****'+CONVERT(VARCHAR(4000), ERROR_MESSAGE())+'*****'+ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_WarningConfigurationKeyDetails')+'*****'+CONVERT(VARCHAR, ERROR_LINE())+'*****'+CONVERT(VARCHAR, ERROR_SEVERITY())+'*****'+CONVERT(VARCHAR, ERROR_STATE());
             RAISERROR(@Error, -- Message text.  
             16, -- Severity.  
             1 -- State.  
             );
         END CATCH;
     END;