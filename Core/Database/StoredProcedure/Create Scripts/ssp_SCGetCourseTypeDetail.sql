IF object_id('ssp_SCGetCourseTypeDetail', 'P') IS NOT NULL
	DROP PROCEDURE dbo.ssp_SCGetCourseTypeDetail
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetCourseTypeDetail] @CourseTypeId int
AS

/********************************************************************************                                            
-- Stored Procedure: dbo.ssp_SCGetCourseTypeDetail  1137                                              
-- Copyright: Streamline Healthcare Solutions                                             
-- Purpose: Used in getdata() for Course Type Detail Page                                             
-- Updates:                                                                                                   
-- Date         Author      Purpose                                             
-- 21/Mar/2018  Abhishek    Created.          
*********************************************************************************/
BEGIN
  BEGIN TRY
    SELECT
      CT.CourseTypeId,
      CT.CreatedBy,
      CT.CreatedDate,
      CT.ModifiedBy,
      CT.ModifiedDate,
      CT.RecordDeleted,
      CT.DeletedBy,
      CT.DeletedDate,
      CT.TypeOfCourse,
      CT.Active,
      CT.HighlyQualifiedTeacher,
      CT.RequiredPoints,
      CT.NoOfCredits,
      CT.TestMode,
      CT.CourseLevel,
      CT.HSCredit,
      CT.CourseCode,
      CT.LengthOfInstruction,
      CT.CourseGroup,
      CT.ClientCourses
     FROM CourseTypes CT
    WHERE CT.CourseTypeId = @CourseTypeId
    AND ISNULL(CT.RecordDeleted, 'N') = 'N'

    SELECT
      CTHQT.CourseTypeHighlyQualifiedTeacherId,
      CTHQT.CreatedBy,
      CTHQT.CreatedDate,
      CTHQT.ModifiedBy,
      CTHQT.ModifiedDate,
      CTHQT.RecordDeleted,
      CTHQT.DeletedBy,
      CTHQT.DeletedDate,
      CTHQT.CourseTypeId,
      CTHQT.StaffId,
      CTHQT.Points,
      CTHQT.AsOfDate,
      S.DisplayAs AS StaffName
    FROM CourseTypeHighlyQualifiedTeachers AS CTHQT,
         Staff AS S
    WHERE CTHQT.CourseTypeId = @CourseTypeId
    AND CTHQT.StaffId = S.StaffId
    AND ISNULL(CTHQT.RecordDeleted, 'N') = 'N'

  END TRY

  BEGIN CATCH
    DECLARE @Error varchar(8000)

    SET @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****' + CONVERT(varchar(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()), '[ssp_SCGetCourseTypeDetail]') + '*****' + CONVERT(varchar, ERROR_LINE()) + '*****' + CONVERT(varchar, ERROR_SEVERITY()) + '*****' + CONVERT(varchar, ERROR_STATE())

    RAISERROR (
    @Error
    ,-- Message text.                                                                                      
    16
    ,-- Severity.                                                                                      
    1 -- State.                                                                                      
    );
  END CATCH
END