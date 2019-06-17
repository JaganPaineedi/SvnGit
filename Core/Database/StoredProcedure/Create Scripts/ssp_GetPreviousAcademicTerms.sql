/****** Object:  StoredProcedure [dbo].[ssp_GetPreviousAcademicTerms]    Script Date: 16/03/2018 11:54:00 ******/ 
IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_GetPreviousAcademicTerms]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_GetPreviousAcademicTerms] 

go 

/****** Object:  StoredProcedure [dbo].[ssp_GetPreviousAcademicTerms]    Script Date: 16/03/2018 11:54:00 ******/ 
SET ansi_nulls ON 

go 

SET quoted_identifier ON 

go 

CREATE PROCEDURE [dbo].[ssp_GetPreviousAcademicTerms] 
AS 
  -- =============================================   
  -- Author:  Chita Ranjan    
  -- Create date: 16/03/2018   
  -- Description: To get all Academic Terms PEP-Customization: #10005.   
  --Modified By   Date          Reason     
  -- =============================================   
  BEGIN try 
      SELECT AT.AcademicTermId, 
             AT.AcademicTermName 
      FROM   AcademicTerms AT JOIN AcademicYears AY ON AT.AcademicYearId = AY.AcademicYearId  
      WHERE  Isnull(AT.RecordDeleted, 'N') = 'N' AND Isnull(AY.RecordDeleted, 'N') = 'N' AND AY.Active = 'Y'
  END try 

  BEGIN catch 
      DECLARE @Error VARCHAR(8000) 

      SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' 
                   + CONVERT(VARCHAR(4000), Error_message()) 
                   + '*****' 
                   + Isnull(CONVERT(VARCHAR, Error_procedure()), 
                   'ssp_GetPreviousAcademicTerms') 
                   + '*****' + CONVERT(VARCHAR, Error_line()) 
                   + '*****' + CONVERT(VARCHAR, Error_severity()) 
                   + '*****' + CONVERT(VARCHAR, Error_state()) 

      RAISERROR ( @Error,-- Message text.                                       
                  16,-- Severity.                                       
                  1 -- State.                                       
      ); 
  END catch 