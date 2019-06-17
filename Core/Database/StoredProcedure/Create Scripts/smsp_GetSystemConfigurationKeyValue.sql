/****** Object:  StoredProcedure [dbo].[smsp_GetSystemConfigurationKeyValue]    Script Date: 2/9/2017 1:03:44 PM ******/

IF EXISTS
(
    SELECT *
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[smsp_GetSystemConfigurationKeyValue]')
          AND type IN(N'P', N'PC')
)
    DROP PROCEDURE [dbo].[smsp_GetSystemConfigurationKeyValue];
GO

/****** Object:  StoredProcedure [dbo].[smsp_GetSystemConfigurationKeyValue]    Script Date: 2/9/2017 1:03:44 PM ******/

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE PROCEDURE [dbo].[smsp_GetSystemConfigurationKeyValue](@KeyName VARCHAR(200),
                                                             @Value   VARCHAR(MAX) OUTPUT)
AS
     BEGIN
         IF EXISTS
         (
             SELECT 1
             FROM SystemConfigurationKeys
             WHERE [Key] = @KeyName
                   AND ISNULL(RecordDeleted, 'N') = 'N'
			    AND ISNULL(Modules,'') = 'MOBILE'
         )
             BEGIN
                 SELECT @Value = ISNULL([Value], '')
                 FROM SystemConfigurationKeys
                 WHERE [Key] = @KeyName
                       AND ISNULL(RecordDeleted, 'N') = 'N'
				   AND ISNULL(Modules,'') = 'MOBILE';
             END;
         ELSE
         SET @Value = '';
     END;
GO