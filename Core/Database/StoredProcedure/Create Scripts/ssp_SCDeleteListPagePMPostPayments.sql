IF EXISTS (SELECT
    *
  FROM sys.objects
  WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCDeleteListPagePMPostPayments]')
  AND type IN (
  N'P'
  , N'PC'
  ))
  DROP PROCEDURE [dbo].[ssp_SCDeleteListPagePMPostPayments]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE ssp_SCDeleteListPagePMPostPayments @SessionId varchar(30)
 /*********************************************************************/        
        
 /* Purpose:To delete ListPagePMPostPayments session data before popup open
    and after popup close. 
                                                                      */        
 /* Data Modifications:                                               */        
 /*                                                                   */        
 /* Updates:                                                          */        
 /*   Date          Author            Purpose                         */        
 /*  04 April 2016  Hemant Kumar      created                         */   

 /*********************************************************************/    
AS

BEGIN
  BEGIN TRY

    DELETE FROM dbo.ListPagePMPostPayments
    WHERE (SessionId = @SessionId)
     

  END TRY

  BEGIN CATCH
    DECLARE @Error varchar(8000)

    SET @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****'
    + CONVERT(varchar(4000), ERROR_MESSAGE()) + '*****'
    + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()), 'ssp_SCDeleteListPagePMPostPayments')
    + '*****' + CONVERT(varchar, ERROR_LINE())
    + '*****' + CONVERT(varchar, ERROR_SEVERITY()) + '*****' + CONVERT(varchar, ERROR_STATE())

    RAISERROR (
    @Error
    ,-- Message text.         
    16
    ,-- Severity.         
    1 -- State.         
    );
  END CATCH
END
GO