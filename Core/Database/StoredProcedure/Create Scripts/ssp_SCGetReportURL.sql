IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetReportURL]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetReportURL]
GO
CREATE Procedure [dbo].[ssp_SCGetReportURL]   
  
(          
@ReportID int,          
@SessionID nvarchar(50)  
)                
  
As  
  
  
/*********************************************************************/                  
/* Stored Procedure: dbo.ssp_SCGetReportURL             */                  
/* Copyright: 2006 Streamline Healthcare Solutions             */                  
/* Creation Date:  12th Dec 2006                                  */                  
/*                                                                   */                  
/* Purpose: To show data in list page              */                 
/*                                                                   */                
/* Input Parameters: @ReportID, @SessionID          */                
/*                                                                   */                  
/* Output Parameters:                                */                  
/*                                                                   */                  
/* Return: Url with replaced URL  */                  
/*                                                                   */                  
/* Called By: GetReportURL(int systemReportId,string sessioID) Method in DataService Layer of SmartClient Application   */                  
/*                                                                   */                  
/* Calls:                                                            */                  
/*                                                                   */                  
/* Data Modifications:                                               */                  
/*                                                                   */                  
/* Updates:                                                          */                  
/*  Date                     Author       Purpose                                    */                  
/* 12th Dec 2006      Piyush      Created                                    */  
/* 30th Dec 2015      Rajesh      Modified - Bear river task 5-     @varReport size from 200 to max                                */                  
/*********************************************************************/   
  
DECLARE @varReport NVARCHAR(MAX)       
    
SET @varReport=(SELECT ISNULL(ReportURL,'') FROM SystemReports WHERE SystemReportId=@ReportID and IsNull(RecordDeleted,'N') <> 'Y')  
IF (@@error!=0)  Begin  RAISERROR  20006  'ssp_SCGetReportURL: An Error Occured'     Return  End  
  
SELECT REPLACE(@varReport,'<SessionID>',@SessionID) AS URL  
--Checking For Errors  
IF (@@error!=0)  Begin  RAISERROR  20006  'ssp_SCGetReportURL: An Error Occured'     Return  End  

