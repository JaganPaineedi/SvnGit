IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_GetDisclosureReportSendFaxes')
	BEGIN
		DROP  Procedure  ssp_GetDisclosureReportSendFaxes
	END

GO

/* Stored Procedure: dbo.[ssp_GetDisclosureReportSendFaxes]                */                                                                                                                                  
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                                                                                                                                  
/* Creation Date:    04/Jan/2012                                         */                                                                                                                                 
/* Modified Date:    27/Jan/2012                                                              */                                                                                                                                  
/* Purpose:  To Bind The dropDown of disclosure Send Faxes report  */                                                                                                                                  
/*                                                                   */                                                                                                                                
/* Input Parameters: none      */                                                                                                                                
/*                                                                   */                                                                                                                                  
/* Output Parameters:   None                           */                                                                                                                                  
/*                                                                   */                                                                                                                                  
/* Return: Reports table having the report folder id                   */                                                                                                                                  
/*                                                                   */                                                                                                                                  
/* Called By:   Disclosure.cs                                                     */                                                                                                                                  
/*                                                                   */                                                                                                                                  
/* Calls:                                                            */                                                                                                                                  
/*                                                                   */                                                                                                                                  
/* Data Modifications:              */                           
/*Data model : 10.88 */
/*                           */                 
/* Updates:  */                               
/*   Date			Author						Purpose                  */                                  
/*  04/Jan/2012		Amit Kumar Srivastava		Created      */   
/*  27/Jan/2012		Amit Kumar Srivastava		Modified due to  FaxCoverLetterFoderid     */   
/*  09/Feb/2012		Amit Kumar Srivastava		Modified due to  FaxCoverLetterFolderd      */   

/*11-Sep-2015		Lakshmi Kanth				Copied from 3.5 to 4.0		*/
create PROCEDURE [dbo].[ssp_GetDisclosureReportSendFaxes]  
  
AS  
 BEGIN
  BEGIN TRY 
Declare @DisclosureFaxCoverLetterFolderId as int  
  
select @DisclosureFaxCoverLetterFolderId= FaxCoverLetterFolderId from SystemConfigurations                                             
    
select ReportId, Name , [Description],IsFolder,AssociatedWith,ReportServerId,ReportServerPath,ParentFolderId from Reports where ParentFolderId=@DisclosureFaxCoverLetterFolderId   
  
END TRY              
 BEGIN CATCH              
  DECLARE @Error varchar(8000)                                                                                                  
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                                                                               
  + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_GetDisclosureReportSendFaxes')                                
  + '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                          
  + '*****' + CONVERT(VARCHAR,ERROR_STATE())                                                                                                                             
  RAISERROR                    
  (                                                                                        
   @Error, -- Message text.                                                                                                            
   16, -- Severity.                                 
   1 -- State.                                                                        
  );               
 END CATCH              
END

