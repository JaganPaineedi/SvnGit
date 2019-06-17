/****** Object:  StoredProcedure [dbo].[ssp_ValidateAuthorizationChanges]    Script Date: 03/30/2017 00:34:22 ******/
IF EXISTS (SELECT
    *
  FROM sys.objects
  WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ValidateAuthorizationChanges]')
  AND type IN (N'P', N'PC'))
  DROP PROCEDURE [dbo].[ssp_ValidateAuthorizationChanges]
GO

/****** Object:  StoredProcedure [dbo].[ssp_ValidateAuthorizationChanges]    Script Date: 03/30/2017 00:34:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[ssp_ValidateAuthorizationChanges] @AuthorizationId int
, @ClientCoveragePlanId int
, @AuthorizationCodeId int
, @StaffId int
, @Units decimal(18, 2)
, @StartDate datetime
, @EndDate datetime
, @Frequency int
, @TotalUnits decimal(18, 2)
, @AuthNumber varchar(100)
, @Status int
, @UnitsRequested decimal(18, 2)
, @FrequencyRequested int
, @StartDateRequested datetime
, @EndDateRequested datetime
, @TotalUnitsRequested decimal(18, 2)
, @StaffIdRequested int

/********************************************************************************
-- Stored Procedure: dbo.ssp_ValidateAuthorizationChanges                       
--                                                          
-- Copyright: Streamline Healthcate Solutions                                     
--                                                          
-- Purpose: used by  Validate that Authorization should be allowed to modify or not
--                                                          
-- Updates:                                                                       
-- Date  			Author			Purpose                                       
-- August 2,2012	Varinder Verma	Created.  
-- Returns ErrorMessage 
-- 3/30/2017        Hemant          Included the SCSP scsp_ValidateAuthorizationChanges.
                                    Project :Woodlands - Support #217 
*********************************************************************************/
AS
BEGIN TRY
  DECLARE @ErrorTable TABLE (
    ErrorStatus char(1),
    ErrorMessage varchar(100)
  )


  DECLARE @ServiceMinDate datetime,
          @ServiceMaxDate datetime,
          @ReturnValue varchar(10) = 1


  SELECT
    @ServiceMinDate = MIN(S.DateOfService),
    @ServiceMaxDate = MAX(S.DateOfService)
  FROM ServiceAuthorizations SA
  INNER JOIN Services S
    ON SA.ServiceId = S.ServiceId
  WHERE AuthorizationId = @AuthorizationId
  AND S.Status = 75 -- Completed Service
  AND ISNULL(SA.RecordDeleted, 'N') = 'N'
  AND ISNULL(S.RecordDeleted, 'N') = 'N'

  IF (@ServiceMinDate IS NOT NULL
    OR @ServiceMaxDate IS NOT NULL)
  BEGIN
    IF @StartDate <= @ServiceMinDate
      AND @EndDate >= @ServiceMaxDate
      SELECT
        @ReturnValue = 1
    ELSE
    BEGIN
      INSERT INTO @ErrorTable
        VALUES ('E', 'Cannot modify this authorization as it is associated with a completed service')
    END
  END
  ELSE
    SELECT
      @ReturnValue = 1

  IF EXISTS (SELECT
      *
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[scsp_ValidateAuthorizationChanges]')
    AND type IN (N'P', N'PC'))
  BEGIN
    IF EXISTS (SELECT
        *
      FROM @ErrorTable)
    BEGIN
      DECLARE @BypassValidation int
      EXEC [dbo].[scsp_ValidateAuthorizationChanges] @AuthorizationId,
                                                     @ClientCoveragePlanId,
                                                     @AuthorizationCodeId,
                                                     @BypassValidation OUTPUT
      IF (@BypassValidation = 1)
      BEGIN
        DELETE FROM @ErrorTable
        WHERE ErrorMessage = 'Cannot modify this authorization as it is associated with a completed service'
      END

    END
  END

  SELECT
    ErrorStatus,
    ErrorMessage
  FROM @ErrorTable

END TRY

BEGIN CATCH
  DECLARE @Error varchar(8000)
  SET @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****' + CONVERT(varchar(4000), ERROR_MESSAGE())
  + '*****' + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()), 'ssp_ValidateAuthorizationChanges')
  + '*****' + CONVERT(varchar, ERROR_LINE()) + '*****' + CONVERT(varchar, ERROR_SEVERITY())
  + '*****' + CONVERT(varchar, ERROR_STATE())
  RAISERROR
  (
  @Error, -- Message text.    
  16,  -- Severity.    
  1  -- State.    
  );
END CATCH






GO