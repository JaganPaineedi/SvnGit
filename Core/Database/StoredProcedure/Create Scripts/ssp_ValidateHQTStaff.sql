IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_ValidateHQTStaff]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_ValidateHQTStaff] 

go 

SET ansi_nulls ON 

go 

SET quoted_identifier ON 

go 

CREATE PROCEDURE [DBO].[ssp_validatehqtstaff] (@CourseId      INT, 
                                               @CourseGroupId INT, 
                                               @StaffId       INT) 
/********************************************************************/ 
/* Stored Procedure: dbo.ssp_ValidateHQTStaff    */ 
/* Creation Date:  20 Dec,2018                                      */ 
/*                                                                  */ 
/* Purpose: To Validate if a staff is HQT or not                   */ 
/*                                                                  */ 
/* Input Parameters: @ClientName        */ 
/*                                                                  */ 
/* Output Parameters:            */ 
/*                                                                  */ 
/*  Date                  Author                 Purpose   */ 
/* 19/Dec/2018             Chita Ranjan     Created - As part of task PEP-Customization Task - #10005.3 */ 
/********************************************************************/ 
AS 
  BEGIN 
      BEGIN try 
          DECLARE @RequiredHighlyQualifiedTeacher CHAR(1) 
          DECLARE @IsHQT CHAR(10) 

          SET @RequiredHighlyQualifiedTeacher = (SELECT HighlyQualifiedTeacher 
                                                 FROM   CourseTypes 
                                                 WHERE  CourseTypeid = @CourseId 
                                                        AND CourseGroup = @CourseGroupId 
                                                        AND Isnull(RecordDeleted,'N') = 'N') 

          IF( @RequiredHighlyQualifiedTeacher = 'Y' AND EXISTS (SELECT TOP 1 StaffId FROM  StaffhigHlyQualifiedTeachers WHERE StaffId = @StaffId 
                                 AND CourseType = @CourseId 
                                 AND CourseGroup = @CourseGroupId 
                                 AND Isnull(RecordDeleted, 'N') = 'N')) 
            BEGIN 
                SET @IsHQT = 'TRUE' 
            END 
          ELSE 
            BEGIN 
                SET @IsHQT = 'FALSE' 
            END 

          SELECT @IsHQT 
      END try 

      BEGIN catch 
          DECLARE @Error VARCHAR(8000) 

          SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' 
                       + CONVERT(VARCHAR(4000), Error_message()) 
                       + '*****' 
                       + Isnull(CONVERT(VARCHAR, Error_procedure()), 
                       'ssp_ValidateHQTStaff') 
                       + '*****' + CONVERT(VARCHAR, Error_line()) 
                       + '*****' + CONVERT(VARCHAR, Error_severity()) 
                       + '*****' + CONVERT(VARCHAR, Error_state()) 

          RAISERROR ( @Error, 
                      -- Message text.                                                                                                
                      16,-- Severity.                      
                      1 
          -- State.                                                             
          ); 
      END catch 
  END 