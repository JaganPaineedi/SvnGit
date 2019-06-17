/****** Object:  StoredProcedure [dbo].[SMSP_ExecutePostSignatureLogic]    Script Date: 4/10/2017 3:41:44 PM ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[Smsp_ExecutePostSignatureLogic]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[Smsp_ExecutePostSignatureLogic]
GO

/****** Object:  StoredProcedure [dbo].[SMSP_ExecutePostSignatureLogic]    Script Date: 4/10/2017 3:41:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[Smsp_ExecutePostSignatureLogic] @ServiceId    INT,
                                           @LoggedInUser INT
AS
     BEGIN
         BEGIN TRY
             IF EXISTS
             (
                 SELECT *
                 FROM sys.objects
                 WHERE object_id = OBJECT_ID(N'Cmsp_ExecutePostSignatureLogic')
                       AND type IN(N'P', N'PC')
             )
                 BEGIN
                     EXEC Cmsp_ExecutePostSignatureLogic
                          @ServiceId,
                          @LoggedInUser;
                 END;
         END TRY
         BEGIN CATCH
             DECLARE @Error VARCHAR(8000);
             SET @Error = CONVERT(VARCHAR, ERROR_NUMBER())+'*****'+CONVERT(VARCHAR(4000), ERROR_MESSAGE())+'*****'+ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'Smsp_ExecutePostSignatureLogic')+'*****'+CONVERT(VARCHAR, ERROR_LINE())+'*****'+CONVERT(VARCHAR, ERROR_SEVERITY())+'*****'+CONVERT(VARCHAR, ERROR_STATE());
             RAISERROR(@Error, -- Message text.                                                                     
             16, -- Severity.                                                            
             1 -- State.                                                         
             );
         END CATCH;
     END;
GO


