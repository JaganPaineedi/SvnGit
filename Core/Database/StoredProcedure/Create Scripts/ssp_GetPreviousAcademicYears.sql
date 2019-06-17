/****** Object:  StoredProcedure [dbo].[ssp_GetPreviousAcademicYears]    Script Date: 16/03/2018 11:54:00 ******/ 
IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_GetPreviousAcademicYears]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_GetPreviousAcademicYears] 

go 

/****** Object:  StoredProcedure [dbo].[ssp_GetPreviousAcademicYears]    Script Date: 16/03/2018 11:54:00 ******/ 
SET ansi_nulls ON 

go 

SET quoted_identifier ON 

go 

CREATE PROCEDURE [dbo].[ssp_GetPreviousAcademicYears] 
AS 
  -- =============================================   
  -- Author:  Chita Ranjan    
  -- Create date: 16/03/2018   
  -- Description: To get all Academic Years PEP-Customization: #10005.   
  --Modified By   Date          Reason     
  -- =============================================   
  BEGIN try 
      ---------AcademicYears               
      SELECT AcademicYearId, 
             AcademicName 
      FROM   AcademicYears 
      WHERE  Isnull(RecordDeleted, 'N') = 'N' 
  END try 

  BEGIN catch 
      DECLARE @Error VARCHAR(8000) 

      SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' 
                   + CONVERT(VARCHAR(4000), Error_message()) 
                   + '*****' 
                   + Isnull(CONVERT(VARCHAR, Error_procedure()), 
                   'ssp_GetPreviousAcademicYears') 
                   + '*****' + CONVERT(VARCHAR, Error_line()) 
                   + '*****' + CONVERT(VARCHAR, Error_severity()) 
                   + '*****' + CONVERT(VARCHAR, Error_state()) 

      RAISERROR ( @Error,-- Message text.                                       
                  16,-- Severity.                                       
                  1 -- State.                                       
      ); 
  END catch 