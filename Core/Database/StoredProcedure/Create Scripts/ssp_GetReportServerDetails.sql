
 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetReportServerDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetReportServerDetails]
GO

/* Object:  StoredProcedure [dbo].[ssp_GetReportServerDetails]   Script Date: 18/Feb/2016 */
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO               
CREATE PROCEDURE [dbo].[ssp_GetReportServerDetails] --exec [ssp_GetImageServerDetails] 

 --@ReportServerId int
AS
Begin
Begin Try
  
SELECT
ReportServerId,
Name,
URL,
ConnectionString,
DomainName,
UserName,
Password,
RowIdentifier,
CreatedBy,
CreatedDate,
ModifiedBy,
ModifiedDate,
RecordDeleted,
DeletedDate,
DeletedBy
FROM ReportServers
WHERE ISNULL(RecordDeleted, 'N') <> 'Y'
--AND ReportServerId = @ReportServerId

--ORDER BY ImageServerId DESC
END TRY

BEGIN CATCH
DECLARE @Error varchar(8000)                                                                            
  SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                         
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_GetReportServerDetails')                                                                                                             
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