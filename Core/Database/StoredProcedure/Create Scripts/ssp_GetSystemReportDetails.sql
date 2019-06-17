
 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetSystemReportDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetSystemReportDetails]
GO

/* Object:  StoredProcedure [dbo].[ssp_GetSystemReportDetails]   Script Date: 09/Feb/2016 */
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO               
CREATE PROCEDURE [dbo].[ssp_GetSystemReportDetails] 

 @SystemReportId int
AS
Begin
Begin Try
  /*********************************************************************/ 
  /* Stored Procedure: dbo.ssp_GetSystemReportDetails                        */ 
  /* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */ 
  /* Creation Date:  12 October 2016                                        */ 
  /*                                                                   */ 
  /* Purpose: Gets SystemReports Detail                              */                                                                   
  /* Return: SystemReports description from SystemReports Table  */                                                                 
  /* Updates:                                                          */ 
  /*  Date   Author         Purpose                          */ 
  /* 10/12/2016  Vijeta       Created               */ 

/*********************************************************************/ 


SELECT 
    SystemReportId,
    ReportName,
    ReportURL,
    ReportRDL,
    PageId,
    Active,
    Description,
    ReportCategory,
    ReportSubCategory,
    AllowAllStaff,
    UsedInPracticeManagement,
    UsedInCareManagement,
    RowIdentifier,
    CreatedBy,
    CreatedDate,
    ModifiedBy,
    ModifiedDate,
    RecordDeleted,
    DeletedDate,
    DeletedBy
FROM  
 SystemReports
WHERE ISNULL(RecordDeleted, 'N') <> 'Y'
AND SystemReportId = @SystemReportId
--ORDER BY CustomVJContactId DESC
END TRY

BEGIN CATCH
DECLARE @Error varchar(8000)                                                                            
  SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                         
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_GetSystemReportDetails')                                                                                                             
  + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                              
  + '*****' + Convert(varchar,ERROR_STATE())                                                          
  RAISERROR                                                                                                             
  (                                                                               
  @Error, -- Message text.           
  16, -- Severity.           
  1 -- State.                                                             
  );        
END CATCH
END