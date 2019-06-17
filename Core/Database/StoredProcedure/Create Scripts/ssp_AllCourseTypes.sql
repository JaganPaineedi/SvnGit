/****** Object:  StoredProcedure [dbo].[ssp_GetAllCourseTypes]    Script Date: 14/April/2018  ******/ 
IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_GetAllCourseTypes]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_GetAllCourseTypes] 

go 

/****** Object:  StoredProcedure [dbo].[ssp_GetAllCourseTypes]    Script Date: 14/April/2018  ******/ 
SET ansi_nulls ON 

go 

SET quoted_identifier ON 

go 

CREATE PROCEDURE [dbo].[ssp_GetAllCourseTypes]  
AS 
/*********************************************************************/ 
/* Stored Procedure: dbo.ssp_GetAllCourseTypes  2            */ 
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */ 
/* Creation Date:    14/April/2018                                         */ 
/*                                                                   */ 
/* Purpose:  To get all Course Types */ 
/*                                                                   */ 
/* Author: Chita Ranjan                                               */ 
/* Output Parameters:   None                */ 
/*                                                                   */ 
  /*********************************************************************/ 
  BEGIN 
      BEGIN try 
         SELECT CT.TypeOfCourse, CT.CourseTypeId,ISNULL(CT.CourseGroup,0) AS CourseGroup FROM CourseTypes CT Where ISNULL(CT.RecordDeleted,'N')<>'Y' AND CT.Active='Y' AND CT.TypeOfCourse IS NOT NULL
      END try 

      BEGIN catch 
          DECLARE @Error VARCHAR(8000) 

          SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' 
                       + CONVERT(VARCHAR(4000), Error_message()) 
                       + '*****' 
                       + Isnull(CONVERT(VARCHAR, Error_procedure()), 
                       '[ssp_GetAllCourseTypes]') 
                       + '*****' + CONVERT(VARCHAR, Error_line()) 
                       + '*****' + CONVERT(VARCHAR, Error_severity()) 
                       + '*****' + CONVERT(VARCHAR, Error_state()) 

          RAISERROR ( @Error, 
                      -- Message text.                                                                                 
                      16, 
                      -- Severity.                                                                                 
                      1 
          -- State.                                                                                 
          ); 
      END catch 
  END 
  
