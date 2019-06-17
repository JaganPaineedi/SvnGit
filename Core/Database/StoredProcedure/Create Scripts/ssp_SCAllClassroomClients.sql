/****** Object:  StoredProcedure [dbo].[ssp_SCAllClassroomClients]    Script Date: 19/Mar/2018  ******/ 
IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_SCAllClassroomClients]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_SCAllClassroomClients] 

go 

/****** Object:  StoredProcedure [dbo].[ssp_SCAllClassroomClients]    Script Date: 19/Mar/2018  ******/ 
SET ansi_nulls ON 

go 

SET quoted_identifier ON 

go 

CREATE PROCEDURE [dbo].[ssp_SCAllClassroomClients]  @ClientsToExclude varchar(max), @GroupId INT, @ClassroomId INT
AS 
/*********************************************************************/ 
/* Stored Procedure: dbo.ssp_SCAllClassroomClients  '',33585,0            */ 
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */ 
/* Creation Date:    19/Mar/2018                                         */ 
/*                                                                   */ 
/* Purpose:  To get all Active Clients present in the Classroom*/ 
/*                                                                   */ 
/* Author: Chita Ranjan                                               */ 
/* Output Parameters:   None                */ 
/*                                                                   */ 
  /*********************************************************************/ 
  BEGIN 
      BEGIN try 
      IF (@ClassroomId<>0)
      BEGIN
      print 1
         SELECT C.ClientId,(C.LastName+', '+C.FirstName) As ClientName from Clients C WHERE EXISTS(
         SELECT 1 FROM ClassroomAssignments CA   
          Where C.ClientId=CA.ClientId and C.Active='Y' AND ClassroomId=@ClassroomId AND ISNULL(C.RecordDeleted,'N')<>'Y' AND  ISNULL(CA.RecordDeleted,'N')<>'Y' 
          AND NOT EXISTS (  
    SELECT 1  
    FROM dbo.SplitString(@ClientsToExclude, ';')  
    WHERE Token = C.ClientId  
    ))
    END
    ELSE
    BEGIN
    SELECT C.ClientId,(C.LastName+', '+C.FirstName) As ClientName from Clients C WHERE EXISTS(
         SELECT 1 FROM ClassroomAssignments CA 
         JOIN Groups G ON G.ClassroomId = CA.ClassroomId  
          Where C.ClientId=CA.ClientId and C.Active='Y' AND G.GroupId=@GroupId AND ISNULL(C.RecordDeleted,'N')<>'Y' AND  ISNULL(CA.RecordDeleted,'N')<>'Y' AND ISNULL(G.RecordDeleted,'N')<>'Y'
          AND NOT EXISTS (  
    SELECT 1  
    FROM dbo.SplitString(@ClientsToExclude, ';')  
    WHERE Token = C.ClientId  
    ))
    END
    
      END try 

      BEGIN catch 
          DECLARE @Error VARCHAR(8000) 

          SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' 
                       + CONVERT(VARCHAR(4000), Error_message()) 
                       + '*****' 
                       + Isnull(CONVERT(VARCHAR, Error_procedure()), 
                       '[ssp_SCAllClassroomClients]') 
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
  
