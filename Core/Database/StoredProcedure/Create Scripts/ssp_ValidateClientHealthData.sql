IF EXISTS (SELECT
    *
  FROM sys.objects
  WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ValidateClientHealthData]')
  AND type IN (N'P', N'PC'))
  DROP PROCEDURE [dbo].[ssp_ValidateClientHealthData] --550,10559
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_ValidateClientHealthData] @CurrentUserId int,
@ScreenKeyId int

AS
/******************************************************************************                                        
**  File: [ssp_ValidateClientHealthData]                                    
**  Name: [ssp_ValidateClientHealthData]                
**  Desc: For Validation on New Entry Flow Sheet Detail Page    
**  Return values: Resultset having validation messages                                        
**  Called by:                                         
**  Parameters:                    
**  Auth:  Hemant Kumar                       
**  Date:  oct 23 2017  
**  Project: Woods - support go live - #767                                
*******************************************************************************                                        
**  Change History                                        
*******************************************************************************                                        
**  Date:       Author:       Description:                                        
    12/03/2018  MD			  Converted the HealthRecordDate field to ignore seconds from time before comparing Health Record Date w.r.t CCC - Support Go Live #121

*******************************************************************************/

BEGIN

  BEGIN TRY

    DECLARE @ClientId int
    DECLARE @HealthRecordDate datetime

    SELECT
      @ClientId = ClientId,
      @HealthRecordDate = HealthRecordDate
    FROM ClientHealthDataAttributes
    WHERE ClientHealthDataAttributeId = @ScreenKeyId

    DECLARE @validationReturnTable TABLE (
      TableName varchar(200),
      ColumnName varchar(200),
      ErrorMessage varchar(1000)
    )
    INSERT INTO @validationReturnTable (TableName,
    ColumnName,
    ErrorMessage)

      SELECT TOP 1
        '',
        '',
        '"The client health record with "' + CONVERT(varchar, @HealthRecordDate) + '" is already exists. Please change the health record date/time"'
      FROM ClientHealthDataAttributes
      WHERE ISNULL(RecordDeleted, 'N') = 'N'
      AND ClientId = @ClientId
      AND CAST(CONVERT(CHAR(16), HealthRecordDate ,113) AS datetime) = CAST(CONVERT(CHAR(16), @HealthRecordDate ,113) AS datetime) -- Modified by MD on 12/03/2018
      GROUP BY HealthDataAttributeId,
               HealthRecordDate,
               HealthDataTemplateId,
               HealthDataSubTemplateId

      HAVING COUNT(*) > 1



    SELECT
      TableName,
      ColumnName,
      ErrorMessage
    FROM @validationReturnTable

    IF EXISTS (SELECT
        *
      FROM @validationReturnTable)
    BEGIN
      SELECT
        1 AS ValidationStatus
    END
    ELSE
    BEGIN
      SELECT
        0 AS ValidationStatus
    END




  END TRY

  BEGIN CATCH

    DECLARE @Error varchar(8000)
    SET @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****' + CONVERT(varchar(4000), ERROR_MESSAGE())
    + '*****' + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()), '[ssp_ValidateClientHealthData]')
    + '*****' + CONVERT(varchar, ERROR_LINE()) + '*****' + CONVERT(varchar, ERROR_SEVERITY())
    + '*****' + CONVERT(varchar, ERROR_STATE())
    RAISERROR
    (
    @Error, -- Message text.                                                                                        
    16, -- Severity.                                                                                        
    1 -- State.                                                                                        
    );
  END CATCH
END

GO