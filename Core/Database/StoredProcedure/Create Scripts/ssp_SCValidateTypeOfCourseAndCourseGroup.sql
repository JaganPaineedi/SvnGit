IF object_id('ssp_SCValidateTypeOfCourseAndCourseGroup', 'P') IS NOT NULL
	DROP PROCEDURE dbo.ssp_SCValidateTypeOfCourseAndCourseGroup
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ssp_SCValidateTypeOfCourseAndCourseGroup] @CourseTypeId int,    
@TypeOfCourse int,    
@CourseGroup int    
    
AS    
/*********************************************************************/    
/* Stored Procedure:ssp_SCValidateTypeOfCourseAndCourseGroup     */    
/* Copyright: 2018 Streamline Healthcare Solutions,  LLC             */    
/* Creation Date: 2April2018                                      */    
/*                                                                   */    
/* Purpose: This procedure will be used to Validate For        */    
/* Type Of Course and Course Group                               */    
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
/*  2April2018   Abhishek  Created                              */    
/*********************************************************************/    
BEGIN    
  BEGIN TRY    
    DECLARE @CourseExists nvarchar(10) = 'FALSE';    
    
    /*TypeOfCourse & CourseGroup Check Both Active/Inactive cases*/    
  IF @CourseGroup = 0  
    
  BEGIN  
  IF EXISTS (SELECT    
        CT.TypeOfCourse,    
        CT.CourseGroup    
      FROM CourseTypes CT    
      WHERE CT.TypeOfCourse = @TypeOfCourse   
      AND CT.CourseTypeId <> @CourseTypeId    
      AND ISNULL(CT.RecordDeleted, 'N') = 'N')    
    BEGIN    
      SET @CourseExists = 'TRUE';    
    END    
    ELSE    
    BEGIN    
      SET @CourseExists = 'FALSE';    
    END    
  END  
    
  ELSE  
    
  BEGIN  
    
    IF EXISTS (SELECT    
        CT.TypeOfCourse,    
        CT.CourseGroup    
      FROM CourseTypes CT    
      WHERE CT.TypeOfCourse = @TypeOfCourse    
      AND CT.CourseGroup = @CourseGroup    
      AND CT.CourseTypeId <> @CourseTypeId    
      AND ISNULL(CT.RecordDeleted, 'N') = 'N')    
    BEGIN    
      SET @CourseExists = 'TRUE';    
    END    
    ELSE    
    BEGIN    
      SET @CourseExists = 'FALSE';    
    END    
  END  
    SELECT    
      @CourseExists;    
    
  --Checking For Errors                
  END TRY    
  BEGIN CATCH    
    DECLARE @Error varchar(8000)    
    SET @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****' + CONVERT(varchar(4000), ERROR_MESSAGE())    
    + '*****' + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()), 'ssp_SCValidateTypeOfCourseAndCourseGroup')    
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