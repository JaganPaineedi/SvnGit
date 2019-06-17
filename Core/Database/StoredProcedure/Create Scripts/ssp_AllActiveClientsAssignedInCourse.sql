/****** Object:  StoredProcedure [dbo].[ssp_AllActiveClientsAssignedInCourse]    Script Date: 19/Mar/2018  ******/ 
IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_AllActiveClientsAssignedInCourse]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_AllActiveClientsAssignedInCourse] 

go 

/****** Object:  StoredProcedure [dbo].[ssp_AllActiveClientsAssignedInCourse]    Script Date: 19/Mar/2018  ******/ 
SET ansi_nulls ON 

go 

SET quoted_identifier ON 

go 

CREATE PROCEDURE [dbo].[ssp_AllActiveClientsAssignedInCourse]  
AS 
/*********************************************************************/ 
/* Stored Procedure: dbo.ssp_AllActiveClientsAssignedInCourse  2            */ 
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */ 
/* Creation Date:    19/Mar/2018                                         */ 
/*                                                                   */ 
/* Purpose:  To get all Active Clients assigned in course*/ 
/*                                                                   */ 
/* Author: Chita Ranjan                                               */ 
/* Output Parameters:   None                */ 
/*                                                                   */ 
  /*********************************************************************/ 
  BEGIN 
      BEGIN try 
         SELECT DISTINCT C.ClientId,C.LastName,C.FirstName, (C.LastName+', '+C.FirstName) As ClientName from CourseClientAssignments CCA JOIN Clients C ON C.ClientId=CCA.ClientId
          WHERE  C.Active='Y' AND ISNULL(C.RecordDeleted,'N')<>'Y' AND ISNULL(CCA.RecordDeleted,'N')<>'Y' 
		  AND EXISTS(SELECT 1 FROM Courses CS WHERE CS.CourseId=CCA.CourseId AND ISNULL(CS.RecordDeleted,'N')<>'Y')
      END try 

      BEGIN catch 
          DECLARE @Error VARCHAR(8000) 

          SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' 
                       + CONVERT(VARCHAR(4000), Error_message()) 
                       + '*****' 
                       + Isnull(CONVERT(VARCHAR, Error_procedure()), 
                       '[ssp_AllActiveClientsAssignedInCourse]') 
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
  
