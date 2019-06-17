/****** Object:  StoredProcedure [dbo].[SSP_GetAcknowledgementVersion]    Script Date: 5/15/2018 3:59:43 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_GetAcknowledgementVersion]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_GetAcknowledgementVersion]
GO

/****** Object:  StoredProcedure [dbo].[SSP_GetAcknowledgementVersion]    Script Date: 5/15/2018 3:59:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[SSP_GetAcknowledgementVersion] @Import837SenderId INT
AS
--=======================================================================
-- Date		 Author	    Description
-- 05/15/2018	 PradeepA	    What: Created to get the Acknowledgement Version
--					    Why: SWMBH - Enhancements #1353
--=======================================================================
BEGIN
    BEGIN TRY
        SELECT TOP 1 ISNULL(AcknowledgementFormat, '999')
        FROM Import837Senders
        WHERE ISNULL(RecordDeleted, 'N') = 'N'
              AND Import837SenderId = @Import837SenderId;
    END TRY
    BEGIN CATCH
        DECLARE @Error VARCHAR(8000);
        SET @Error = CONVERT(VARCHAR, ERROR_NUMBER())+'*****'+CONVERT(VARCHAR(4000), ERROR_MESSAGE())+'*****'+isnull(CONVERT(VARCHAR, ERROR_PROCEDURE()), '[SSP_GetAcknowledgementVersion]')+'*****'+CONVERT(VARCHAR, ERROR_LINE())+'*****'+CONVERT(VARCHAR, ERROR_SEVERITY())+'*****'+CONVERT(VARCHAR, ERROR_STATE());
        RAISERROR(@Error, -- Message text.                                                                                                   
        16, -- Severity.                                                                                                    
        1 -- State.                                                                                                   
        );
    END CATCH;
END;
GO


