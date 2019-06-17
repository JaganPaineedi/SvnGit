
/****** Object:  StoredProcedure [dbo].[ssp_CheckEducatingSchoolDistricts]    Script Date: 10/25/2018 15:42:33 ******/
IF EXISTS (SELECT
    *
  FROM sys.objects
  WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CheckEducatingSchoolDistricts]')
  AND type IN (N'P', N'PC'))
  DROP PROCEDURE [dbo].[ssp_CheckEducatingSchoolDistricts]
GO

/****** Object:  StoredProcedure [dbo].[ssp_CheckEducatingSchoolDistricts]    Script Date: 10/25/2018 15:42:33 ******/
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[ssp_CheckEducatingSchoolDistricts] (@SchoolDistrictAssignmentId int
, @EducatingSchoolDistrictId int
, @StartDate datetime
, @EndDate datetime
, @ClientId int)
AS
-- =============================================  ssp_CheckEducatingSchoolDistricts 3, '10/31/2018', '11/26/2018'
-- Author:  Chita Ranjan
-- Create date: 10/25/2018  
-- Description: To check if Education School District is already exists between startdate and enddate  
--Modified By   Date          Reason    
-- =============================================  
BEGIN TRY

  IF @EndDate <> '1900-01-01 00:00:00.000'

  BEGIN
    SELECT
      1
    FROM SchoolDistrictAssignments
    WHERE SchoolDistrictAssignmentId <> @SchoolDistrictAssignmentId
    AND EducatingSchoolDistrictId = @EducatingSchoolDistrictId
    AND @StartDate BETWEEN StartDate AND EndDate
    AND @EndDate BETWEEN StartDate AND EndDate
    AND ClientId = @ClientId

  END

  ELSE

  BEGIN
    SELECT
      1
    FROM SchoolDistrictAssignments
    WHERE SchoolDistrictAssignmentId <> @SchoolDistrictAssignmentId
    AND EducatingSchoolDistrictId = @EducatingSchoolDistrictId
    AND @StartDate BETWEEN StartDate AND EndDate
    AND ClientId = @ClientId
  END

END TRY
BEGIN CATCH
  DECLARE @Error varchar(8000)

  SET @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****' + CONVERT(varchar(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()), 'ssp_CheckEducatingSchoolDistricts') + '*****' + CONVERT(varchar, ERROR_LINE()) + '*****' + CONVERT(varchar, ERROR_SEVERITY()) + '*****' + CONVERT(varchar, ERROR_STATE())

  RAISERROR (
  @Error
  ,-- Message text.                                      
  16
  ,-- Severity.                                      
  1 -- State.                                      
  );
END CATCH
GO