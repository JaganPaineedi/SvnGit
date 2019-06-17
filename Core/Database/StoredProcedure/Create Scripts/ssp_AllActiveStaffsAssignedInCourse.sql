/****** Object:  StoredProcedure [dbo].[ssp_AllActiveStaffsAssignedInCourse]    Script Date: 19/Mar/2018  ******/ 
IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_AllActiveStaffsAssignedInCourse]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_AllActiveStaffsAssignedInCourse] 

go 

/****** Object:  StoredProcedure [dbo].[ssp_AllActiveStaffsAssignedInCourse]    Script Date: 19/Mar/2018  ******/ 
SET ansi_nulls ON 

go 

SET quoted_identifier ON 

go 

CREATE PROCEDURE [dbo].[ssp_AllActiveStaffsAssignedInCourse]  
AS 
/*********************************************************************/ 
/* Stored Procedure: dbo.ssp_AllActiveStaffsAssignedInCourse  2            */ 
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */ 
/* Creation Date:    19/Mar/2018                                         */ 
/*                                                                   */ 
/* Purpose:  To get all Staff names assigned in course*/ 
/*                                                                   */ 
/* Author: Chita Ranjan                                               */ 
/* Output Parameters:   None                */ 
/*                                                                   */ 
  /*********************************************************************/ 
  BEGIN 
      BEGIN try 
         Select DISTINCT S.StaffId, S.DisplayAs As StaffName from CourseStaffAssignments CSA JOIN Staff S ON S.StaffId=CSA.StaffId
         JOIN Courses CS ON CS.CourseId=CSA.CourseId WHERE  ISNULL(S.RecordDeleted,'N')<>'Y' AND ISNULL(CSA.RecordDeleted,'N')<>'Y' AND ISNULL(CS.RecordDeleted,'N')<>'Y'
      END try 

      BEGIN catch 
          DECLARE @Error VARCHAR(8000) 

          SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' 
                       + CONVERT(VARCHAR(4000), Error_message()) 
                       + '*****' 
                       + Isnull(CONVERT(VARCHAR, Error_procedure()), 
                       '[ssp_AllActiveStaffsAssignedInCourse]') 
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
  
