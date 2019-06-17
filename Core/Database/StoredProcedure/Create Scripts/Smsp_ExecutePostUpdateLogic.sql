/****** Object:  StoredProcedure [dbo].[Smsp_ExecutePostUpdateLogic]    Script Date: 4/10/2017 3:38:06 PM ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[Smsp_ExecutePostUpdateLogic]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[Smsp_ExecutePostUpdateLogic]
GO

/****** Object:  StoredProcedure [dbo].[Smsp_ExecutePostUpdateLogic]    Script Date: 4/10/2017 3:38:06 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[Smsp_ExecutePostUpdateLogic] @ServiceId    INT,
                                           @LoggedInUser INT
AS
     BEGIN
         BEGIN TRY
             IF EXISTS
             (
                 SELECT 1
                 FROM sys.objects
                 WHERE object_id = OBJECT_ID(N'Cmsp_ExecutePostSignatureLogic')
                       AND type IN(N'P', N'PC')
             )
                 BEGIN
                     EXEC Cmsp_ExecutePostUpdateLogic
                          @ServiceId,
                          @LoggedInUser;
                 END;
         END TRY
         BEGIN CATCH
             DECLARE @Error VARCHAR(8000);
             SET @Error = CONVERT(VARCHAR, ERROR_NUMBER())+'*****'+CONVERT(VARCHAR(4000), ERROR_MESSAGE())+'*****'+ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'SMSP_ExecutePostSignatureLogic')+'*****'+CONVERT(VARCHAR, ERROR_LINE())+'*****'+CONVERT(VARCHAR, ERROR_SEVERITY())+'*****'+CONVERT(VARCHAR, ERROR_STATE());
             RAISERROR(@Error, -- Message text.                                                                     
             16, -- Severity.                                                            
             1 -- State.                                                         
             );
         END CATCH;
     END;
GO


