IF object_id('ssp_SCGetSchoolDistrictAssignmentDetail', 'P') IS NOT NULL
	DROP PROCEDURE dbo.ssp_SCGetSchoolDistrictAssignmentDetail
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetSchoolDistrictAssignmentDetail] @SchoolDistrictAssignmentId int
AS
/********************************************************************************                                            
-- Stored Procedure: dbo.ssp_SCGetSchoolDistrictAssignmentDetail                                               
-- Copyright: Streamline Healthcare Solutions                                             
-- Purpose: Used in getdata() for School District Assignment Detail Page                                            
-- Updates:                                                                                                   
-- Date         Author      Purpose                                             
-- 09/Apr/2018  Abhishek    Created.          
*********************************************************************************/
BEGIN
  BEGIN TRY
    SELECT
      SDA.SchoolDistrictAssignmentId,
      SDA.CreatedBy,
      SDA.CreatedDate,
      SDA.ModifiedBy,
      SDA.ModifiedDate,
      SDA.RecordDeleted,
      SDA.DeletedBy,
      SDA.DeletedDate,
      SDA.EducatingSchoolDistrictId,
      SDA.ResidentialSchoolDistrictId,
      SDA.StartDate,
      SDA.EndDate,
      SDA.StudentId,
      SDA.SSDI

    FROM SchoolDistrictAssignments SDA
    WHERE SDA.SchoolDistrictAssignmentId = @SchoolDistrictAssignmentId
    AND ISNULL(SDA.RecordDeleted, 'N') = 'N'

  END TRY

  BEGIN CATCH
    DECLARE @Error varchar(8000)

    SET @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****' + CONVERT(varchar(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()), '[ssp_SCGetSchoolDistrictAssignmentDetail]') + '*****' + CONVERT(varchar, ERROR_LINE()) + '*****' + CONVERT(varchar, ERROR_SEVERITY()) + '*****' + CONVERT(varchar, ERROR_STATE())

    RAISERROR (
    @Error
    ,-- Message text.                                                                                      
    16
    ,-- Severity.                                                                                      
    1 -- State.                                                                                      
    );
  END CATCH
END