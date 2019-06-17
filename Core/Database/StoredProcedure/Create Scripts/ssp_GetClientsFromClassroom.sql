/****** Object:  StoredProcedure [dbo].[ssp_GetClientsFromClassroom]    Script Date: 19/Mar/2018  ******/ 
IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_GetClientsFromClassroom]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_GetClientsFromClassroom] 

go 

/****** Object:  StoredProcedure [dbo].[ssp_GetClientsFromClassroom]    Script Date: 19/Mar/2018  ******/ 
SET ansi_nulls ON 

go 

SET quoted_identifier ON 

go 

CREATE PROCEDURE [dbo].[ssp_GetClientsFromClassroom]  @ClassRoomId INT
AS 
/*********************************************************************/ 
/* Stored Procedure: dbo.ssp_GetClientsFromClassroom  11            */ 
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */ 
/* Creation Date:    19/Mar/2018                                         */ 
/*                                                                   */ 
/* Purpose:  To get all Active Clients from classroom */ 
/*                                                                   */ 
/* Author: Chita Ranjan                                               */ 
/* Output Parameters:   None                */ 
/*                                                                   */ 
  /*********************************************************************/ 
  BEGIN 
      BEGIN try 
           --Select DISTINCT C.ClientId,(C.LastName+', '+C.FirstName) As ClientName,CCA.Grade, CCA.QuarterOrSemester1, CCA.AttemptedCredit1,CCA.AwardedCredit1
           --    from Clients C INNER JOIN ClassroomAssignments CA ON  C.ClientId=CA.ClientId AND CA.ClassRoomId=@ClassRoomId 
           --     INNER JOIN  CourseClientAssignments CCA ON C.ClientId = CCA.ClientId
           --    Where C.Active='Y' AND ISNULL(C.RecordDeleted,'N')<>'Y'  
           
      --       Select DISTINCT C.ClientId,(C.LastName+', '+C.FirstName) As ClientName,CCA.Grade,CA.ClassRoomId as ClientsFromClassroom,CCA.QuarterOrSemester, CCA.AttemptedCredit,CCA.AwardedCredit   
      --         ,GC.CodeName AS GradeText, GC1.CodeName as QuarterOrSemesterText  
      --,GC2.CodeName as AttemptedCreditText, GC3.CodeName as  AwardedCreditText  
      --,R.RoomName as ClientsFromClassroomText  
      --         from Clients C INNER JOIN ClassroomAssignments CA ON  C.ClientId=CA.ClientId AND CA.ClassRoomId=@ClassRoomId     
      --          LEFT OUTER JOIN CourseClientAssignments CCA ON C.ClientId = CCA.ClientId   
      --           LEFT  JOIN GlobalCodes GC ON  CCA.Grade = GC.Globalcodeid  
      --          LEFT  JOIN GlobalCodes GC1 ON  CCA.QuarterOrSemester = GC1.Globalcodeid  
      --          Left  JOIN GlobalCodes GC2 ON  CCA.AttemptedCredit = GC2.Globalcodeid  
      --          Left  JOIN GlobalCodes GC3 ON CCA.AwardedCredit= GC3.Globalcodeid   
      --          LEFT  JOIN Rooms R ON R.RoomId = CA.ClassRoomId  
                    
      --         Where C.Active='Y' AND ISNULL(C.RecordDeleted,'N')<>'Y' 
      
      Select DISTINCT C.ClientId,(C.LastName+', '+C.FirstName) As ClientName, '' as Grade,CA.ClassRoomId as ClientsFromClassroom,'' as QuarterOrSemester, '' as AttemptedCredit,'' as AwardedCredit   
               ,'' as  GradeText, '' as  QuarterOrSemesterText  
      ,'' as  AttemptedCreditText,'' as   AwardedCreditText  
      ,R.RoomName as ClientsFromClassroomText  
               from Clients C INNER JOIN ClassroomAssignments CA ON  C.ClientId=CA.ClientId AND CA.ClassRoomId= @ClassRoomId   
                --LEFT OUTER JOIN CourseClientAssignments CCA ON C.ClientId = CCA.ClientId 
                --LEFT OUTER JOIN CourseClientAssignments CCA ON CCA.RoomID = CA.ClassRoomId   
                -- LEFT  JOIN GlobalCodes GC ON  CCA.Grade = GC.Globalcodeid  
                --LEFT  JOIN GlobalCodes GC1 ON  CCA.QuarterOrSemester = GC1.Globalcodeid  
                --Left  JOIN GlobalCodes GC2 ON  CCA.AttemptedCredit = GC2.Globalcodeid  
                --Left  JOIN GlobalCodes GC3 ON CCA.AwardedCredit= GC3.Globalcodeid   
                LEFT  JOIN Rooms R ON R.RoomId = CA.ClassRoomId  
                Where C.Active='Y' AND ISNULL(C.RecordDeleted,'N')= 'N' AND ISNULL(CA.RecordDeleted,'N') = 'N'
       END try 

      BEGIN catch 
          DECLARE @Error VARCHAR(8000) 

          SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' 
                       + CONVERT(VARCHAR(4000), Error_message()) 
                       + '*****' 
                       + Isnull(CONVERT(VARCHAR, Error_procedure()), 
                       '[ssp_GetClientsFromClassroom]') 
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
  
