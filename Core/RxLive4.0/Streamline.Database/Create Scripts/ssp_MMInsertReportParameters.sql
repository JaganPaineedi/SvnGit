Create  procedure [dbo].[ssp_MMInsertReportParameters]  
 @Value as varchar(100),  
 @SessionId as uniqueidentifier,  
 @Type as varchar(10)  
as      
/*********************************************************************/                  
/* Stored Procedure: dbo.ssp_MMInsertReportParameters */  
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC          */                  
/* Creation Date:  10/Dec/2008                                   */                  
/*                                                                   */                  
/* Purpose:Inserts the details of the Reports                     */                 
/*                                                                   */                
/* Input Parameters: @Type,@VAlue,@SessionId                       */                
/*                                                                   */                  
/* Output Parameters:                                                */                  
/*                                                                   */                  
/* Return:  */                  
/*                                                                   */                  
/* Called By:                                                        */                  
/*                                                                   */                  
/* Calls:                                                            */                  
/*                                                                   */                  
/* Data Modifications:                                               */                  
/*                                                                   */                  
/* Updates:                                                          */                  
/*  Date              Author       Purpose                           */                  
/*  10/Dec/2008        Rohit Veram   Inserts the details of the Reports*/                  
/*********************************************************************/                   
Begin      
  
if(@Type='Varchar')  
insert into ReportParameters (SessionId,VarcharValue1,CreatedDate) values (@SessionId,@Value,getdate())  
else  
insert into ReportParameters (SessionId,IntegerValue1,CreatedDate) values (@SessionId,@Value,getdate())  
--Checking For Errors  
If (@@error!=0)    RAISERROR  20006  'ssp_CMInsertReport: An Error Occured'     Return   
End  
  
  
  
  
  
  
