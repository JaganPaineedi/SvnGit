IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMUpdateClientStatementDate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMUpdateClientStatementDate]
GO
CREATE PROCEDURE ssp_PMUpdateClientStatementDate
 (
  @ClientStatementBatchID				INT
 )
 AS
 
 /****************************************************************************** 
** Name: ssp_PMUpdateClientAccountDetail
******************************************************************************* 
** Date: 			Author: 			Description: 
** 20/01/2013		Bernardin			To update last statement date on close
*******************************************************************************/


 BEGIN
 BEGIN TRY
 
      UPDATE Clients SET LastStatementDate = GETDATE() FROM Clients C INNER JOIN
                      ClientStatements CS ON C.ClientId = CS.ClientId WHERE ClientStatementBatchId = @ClientStatementBatchID
    
 END TRY
 
 BEGIN CATCH
  DECLARE @Error VARCHAR(8000)       
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                            
   + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_PMUpdateClientAccountDetail')                                                                                             
   + '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                              
   + '*****' + CONVERT(VARCHAR,ERROR_STATE())
  RAISERROR
  (
   @Error, -- Message text.
   16,  -- Severity.
   1  -- State.
  );
 END CATCH
 END
 
