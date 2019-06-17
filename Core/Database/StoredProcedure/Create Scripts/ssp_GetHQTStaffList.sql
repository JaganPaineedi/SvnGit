IF object_id('ssp_GetHQTStaffList', 'P') IS NOT NULL
	DROP PROCEDURE dbo.ssp_GetHQTStaffList
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ssp_GetHQTStaffList] 
@TypeOfCourse int,
@CourseGroup int

AS
/*********************************************************************/
/* Stored Procedure:ssp_SCValidateCourses     */
/* Copyright: 2018 Streamline Healthcare Solutions,  LLC             */
/* Creation Date: 30April2018                                      */
/*                                                                   */
/* Purpose: This procedure will be used to Get theList of         */
/* Staff for Type Of Course and Course Group                               */
/* Input Parameters: @TypeOfCourse,@CourseGroup          */
/*                                                                   */
/* Output Parameters:   None                                         */
/*                                                                   */
/* Return:  0=success, otherwise an error number                     */
/*                                                                   */
/* Called By:                                                        */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:                                                          */
/*   Date        Author   Purpose                              */
/*  30April2018   Abhishek  Created                              */
/*********************************************************************/
BEGIN
  BEGIN TRY
    

    /*TypeOfCourse & CourseGroup Check Both Active/Inactive cases*/

 Select S.StaffId, S.DisplayAs As DisplayAs from Staff S WHERE EXISTS(SELECT 1 FROM StaffHighlyQualifiedTeachers HQT WHERE S.StaffId=HQT.StaffId AND DisplayAs IS NOT NULL AND ISNULL(HQT.RecordDeleted,'N')<>'Y')
          AND ISNULL(S.RecordDeleted,'N')<>'Y'
  
       

  --Checking For Errors            
  END TRY
  BEGIN CATCH
    DECLARE @Error varchar(8000)
    SET @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****' + CONVERT(varchar(4000), ERROR_MESSAGE())
    + '*****' + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()), 'ssp_GetHQTStaffList')
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