
/****** Object:  StoredProcedure [dbo].[SSP_UpdateLastTFATimeStamp]    Script Date: 08-13-2018 18:05:52 ******/
IF EXISTS
(
    SELECT *
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SSP_UpdateLastTFATimeStamp]')
          AND type IN(N'P', N'PC')
)
    DROP PROCEDURE [dbo].[SSP_UpdateLastTFATimeStamp];
GO

/****** Object:  StoredProcedure [dbo].[SSP_UpdateLastTFATimeStamp]    Script Date: 08-13-2018 18:05:52 ******/

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE PROCEDURE [dbo].[SSP_UpdateLastTFATimeStamp] @StaffId INT
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: 13-08-2018
-- Description: Get Offline Document
/*      
 Author			Modified Date			Reason      
 Pradeep 		Aug 21 2018				To Update StaffPreferences.LastTFATimeStamp filed on TFA authentication for Mobile #6
      
*/
-- =============================================  
     BEGIN
         BEGIN TRY
             UPDATE StaffPreferences SET LastTFATimeStamp =GETDATE() WHERE StaffId = @StaffId
         END TRY
         BEGIN CATCH
             DECLARE @Error VARCHAR(8000);
             SET @Error = CONVERT(VARCHAR, ERROR_NUMBER())+'*****'+CONVERT(VARCHAR(4000), ERROR_MESSAGE())+'*****'+ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'SSP_UpdateLastTFATimeStamp')+'*****'+CONVERT(VARCHAR, ERROR_LINE())+'*****'+CONVERT(VARCHAR, ERROR_SEVERITY())+'*****'+CONVERT(VARCHAR, ERROR_STATE());
             RAISERROR(@Error, -- Message text.                                                                     
             16, -- Severity.                                                            
             1 -- State.                                                         
             );
         END CATCH;
     END;
GO