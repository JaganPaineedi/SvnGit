 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCUpdateForms]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCUpdateForms]
GO
 CREATE PROCEDURE [DBO].[SSP_SCUpdateForms]  
AS /*********************************************************************/  
/* Stored Procedure: dbo.ssp_SCGetFlagTypes            */  
/* Creation Date:    24/Nov/2014                  */  
/* Purpose:  Used to update Forms table as FormHTML as NULL as per task                */  
/*    Exec ssp_SCGetFlagTypes                                              */  
/* Input Parameters:                           */  
/*  Date  Author   Purpose              */  
/*********************************************************************/  
BEGIN  
 BEGIN TRY  
  Update Forms Set FormHTML=NULL
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(max)  
  
  SET @Error = convert(VARCHAR, error_number()) + '*****' + convert(VARCHAR(4000), error_message()) + '*****' + isnull(convert(VARCHAR, error_procedure()), 'SSP_SCUpdateForms') + '*****' + convert(VARCHAR, error_line()) + '*****' + convert(VARCHAR, error_severity()) + '*****' + convert(VARCHAR, error_state())  
  
  RAISERROR (  
    @Error  
    ,  
    -- Message text.                                                                                       
    16  
    ,  
    -- Severity.                                                                                       
    1  
    -- State.                                                                                       
    );  
 END CATCH  
END  