
/****** Object:  StoredProcedure [dbo].[ssp_GetScheduledCCDs]    Script Date: 10/23/2017 16:24:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetScheduledCCDs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetScheduledCCDs]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetScheduledCCDs]    Script Date: 10/23/2017 16:24:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_GetScheduledCCDs]   
  
AS  
-- =============================================                               
/*                    
 Author   Added Date   Reason   Task  
 Vijay    23/10/2017   Initial  MUS3 - Task#25.4 Transition of Care - CCDA Generation      
*/  
-- =============================================     
BEGIN  
 BEGIN TRY  
  SELECT cde.CCDsDataExportId  
      ,cde.FromDate
	  ,cde.ToDate
	  ,cde.CCDsType
	  ,cde.LocationType
	  ,cde.ClientIds
	  ,SC.StartTime
	  ,SC.EndTime
	  ,SC.RecurrenceType
	  ,SC.RecurrenceStartDate
	  ,SC.NoEndDate
	  ,SC.NumberOfOccurences
	  ,SC.EndDate
  FROM CCDsDataExport cde 
  JOIN CCDsDataExportSchedules SC ON  SC.CCDsDataExportId = cde.CCDsDataExportId 
  WHERE ISNULL(cde.RecordDeleted,'N')='N'  
  
  
END TRY  
  
BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetScheduledCCDs') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())  
  
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


