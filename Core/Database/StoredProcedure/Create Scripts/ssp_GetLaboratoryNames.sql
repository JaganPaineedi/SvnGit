
/****** Object:  StoredProcedure [dbo].[ssp_GetLaboratoryNames]    Script Date: 08/12/2013 16:56:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetLaboratoryNames]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetLaboratoryNames]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetLaboratoryNames]    Script Date: 08/12/2013 16:56:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[ssp_GetLaboratoryNames]      
As        
----------------------------------------------------------------------      
-- Stored Procedure: ssp_GetLaboratoryNames      
-- Copyright: 2010  Streamline Healthcare Solutions      
-- Author: Neha    
-- Date: Sept 20 2018    
-- Purpose: Returns Laboratory names      
-- *****History****     
----------------------------------------------------------------------        
  BEGIN 
      BEGIN try 
      
            SELECT  LaboratoryId,LaboratoryName 
            from    Laboratories    
            WHERE ISNULL(RecordDeleted, 'N') = 'N'    
            
      END try 

      BEGIN catch 
          DECLARE @Error VARCHAR(8000) 

          SET @Error= CONVERT(VARCHAR, Error_number()) + '*****' 
                      + CONVERT(VARCHAR(4000), Error_message()) 
                      + '*****' 
                      + Isnull(CONVERT(VARCHAR, Error_procedure()), 
                      'ssp_GetLaboratoryNames' 
                      ) 
                      + '*****' + CONVERT(VARCHAR, Error_line()) 
                      + '*****' + CONVERT(VARCHAR, Error_severity()) 
                      + '*****' + CONVERT(VARCHAR, Error_state()) 

          RAISERROR ( @Error,-- Message text.            
                      16,-- Severity.            
                      1 -- State.            
          ); 
      END catch 
  END 

GO


