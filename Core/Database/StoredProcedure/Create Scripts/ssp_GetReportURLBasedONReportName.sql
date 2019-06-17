/****** Object:  StoredProcedure [dbo].[csp_CMPostUpdateCMAuthorizations]    Script Date: 08/17/2015 18:11:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetReportURLBasedONReportName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetReportURLBasedONReportName]
GO

/****** Object:  StoredProcedure [dbo].[csp_CMPostUpdateCMAuthorizations]    Script Date: 08/17/2015 18:11:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
    
Create Procedure [dbo].[ssp_GetReportURLBasedONReportName]   
  
(          
@ReportName nvarchar(500),          
@SessionID nvarchar(50)  
)                
  
As  

DECLARE @varReport NVARCHAR(MAX)       
    
SET @varReport=(SELECT ISNULL(ReportURL,'') FROM SystemReports WHERE ReportName=@ReportName and IsNull(RecordDeleted,'N') <> 'Y')  
IF (@@error!=0)  Begin  RAISERROR  20006  'ssp_GetReportURLBasedONReportName: An Error Occured'     Return  End  
  
SELECT REPLACE(@varReport,'<SessionID>',@SessionID) AS URL  
--Checking For Errors  
IF (@@error!=0)  Begin  RAISERROR  20006  'ssp_GetReportURLBasedONReportName: An Error Occured'     Return  End  

