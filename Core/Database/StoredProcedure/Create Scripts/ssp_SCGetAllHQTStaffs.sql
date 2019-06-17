/****** Object:  StoredProcedure [dbo].[ssp_SCGetAllHQTStaffs]    Script Date: 19/Mar/2018  ******/ 
IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_SCGetAllHQTStaffs]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_SCGetAllHQTStaffs] 

go 

/****** Object:  StoredProcedure [dbo].[ssp_SCGetAllHQTStaffs]    Script Date: 19/Mar/2018  ******/ 
SET ansi_nulls ON 

go 

SET quoted_identifier ON 

go 

CREATE PROCEDURE [dbo].[ssp_SCGetAllHQTStaffs]  
AS 
/*********************************************************************/ 
/* Stored Procedure: dbo.ssp_SCGetAllHQTStaffs  2            */ 
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */ 
/* Creation Date:    19/Mar/2018                                         */ 
/*                                                                   */ 
/* Purpose:  To get all HQT Highly Qualified Staffs */ 
/*                                                                   */ 
/* Author: Chita Ranjan                                               */ 
/* Output Parameters:   None                */ 
/*                                                                   */ 
  /*********************************************************************/ 
  BEGIN 
      BEGIN try 
         Select S.StaffId, S.DisplayAs As DisplayAs from Staff S WHERE EXISTS(SELECT 1 FROM StaffHighlyQualifiedTeachers HQT WHERE S.StaffId=HQT.StaffId AND DisplayAs IS NOT NULL AND ISNULL(HQT.RecordDeleted,'N')<>'Y')
          AND ISNULL(S.RecordDeleted,'N')<>'Y'
      END try 

      BEGIN catch 
          DECLARE @Error VARCHAR(8000) 

          SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' 
                       + CONVERT(VARCHAR(4000), Error_message()) 
                       + '*****' 
                       + Isnull(CONVERT(VARCHAR, Error_procedure()), 
                       '[ssp_SCGetAllHQTStaffs]') 
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
  
