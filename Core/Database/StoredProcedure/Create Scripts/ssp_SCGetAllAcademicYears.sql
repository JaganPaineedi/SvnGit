/****** Object:  StoredProcedure [dbo].[ssp_SCGetAllAcademicYears]    Script Date: 19/Mar/2018  ******/ 
IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_SCGetAllAcademicYears]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_SCGetAllAcademicYears] 

go 

/****** Object:  StoredProcedure [dbo].[ssp_SCGetAllAcademicYears]    Script Date: 19/Mar/2018  ******/ 
SET ansi_nulls ON 

go 

SET quoted_identifier ON 

go 

CREATE PROCEDURE [dbo].[ssp_SCGetAllAcademicYears] 
AS 
/*********************************************************************/ 
/* Stored Procedure: dbo.ssp_SCGetAllAcademicYears              */ 
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */ 
/* Creation Date:    19/Mar/2018                                         */ 
/*                                                                   */ 
/* Purpose:  To get all active years entered in Academic Years Screen */ 
/*                                                                   */ 
/* Author: Chita Ranjan                                               */ 
/* Output Parameters:   None                */ 
/*                                                                   */ 
  /*********************************************************************/ 
  BEGIN 
      BEGIN try 
          SELECT AcademicYearId, 
                 AcademicName 
          FROM   AcademicYears 
          WHERE  Isnull(RecordDeleted, 'N') = 'N' 
                 AND Active = 'Y' 
                 AND AcademicYearId <> -1 ORDER BY AcademicName ASC
      END try 

      BEGIN catch 
          DECLARE @Error VARCHAR(8000) 

          SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' 
                       + CONVERT(VARCHAR(4000), Error_message()) 
                       + '*****' 
                       + Isnull(CONVERT(VARCHAR, Error_procedure()), 
                       '[ssp_SCGetAllAcademicYears]') 
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