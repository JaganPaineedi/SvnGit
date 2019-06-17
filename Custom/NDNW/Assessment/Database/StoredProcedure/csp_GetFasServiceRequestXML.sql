

/****** Object:  StoredProcedure [dbo].[csp_GetFasServiceRequestXML]    Script Date: 01/16/2015 17:08:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetFasServiceRequestXML]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetFasServiceRequestXML]
GO


/****** Object:  StoredProcedure [dbo].[csp_GetFasServiceRequestXML]    Script Date: 01/16/2015 17:08:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
   
CREATE procedure [dbo].[csp_GetFasServiceRequestXML]     
(    
@OrgSoftwareId varchar(50),    
@RequestType varchar(50),    
@ClientID Varchar(50),  
@StaffId varchar(50)    
)    
-- =============================================    
-- Author:  Mahesh     
-- Create date: 11 October 2010    
-- Description: To Generate the RequestXml    
-- Modified Date : 13 Dec 2010   
-- =============================================    
as    
Begin    
    
Begin Try    
declare @RequestXML varchar(max)    
declare @PreviousRequestXML varchar(max)    
declare @idoc int    
declare @FromDate datetime    
declare @ToDate datetime    
Declare @FasRequestID int    
declare @errorno int      
declare @errormsg varchar(max)     
    
--set @ClientID='742065'   Coomment this code by Rakesh Garg as CLientId was hardcoded  
    
if(@RequestType)= 'Assessment'    
Begin    
select Top 1 @PreviousRequestXML = RequestXML    
  from CustomFASRequestLog rl inner join CustomFASCAFASAssessments CFA on rl.FasRequestId=CFA.FASRequestId    
 where rl.ResponseProcessed = 'Y'    
   and isnull(rl.ResponseError, 'N') = 'N'    
   and rl.RequestType = 'Assessment' and rl.RequestXML like  '%client primaryId="'+@ClientID+'"/>%' and CFA.ClientId=@ClientID --and    
   and CFA.IsDeleted<>'Yes' and CFA.AssessmentStatus<>'Unsigned'    
      
    order by rl.FASRequestId desc    
                         
    
if len(@PreviousRequestXML) > 0    
begin    
  exec sp_xml_preparedocument @idoc output, @PreviousRequestXML    
    
  select @FromDate = ToDate    
    from openxml(@idoc, '/request/requestParams/criteria', 2)    
         with (ToDate  datetime  '@toDate')    
    
  exec sp_xml_removedocument @idoc    
end    
    
if @FromDate is null    
  set @FromDate = DATEADD(YY,-1,GETDATE())+1       -- Starting date    
    
-- Implemented so that Difference between FromDate and ToDate should not be Greater then 1 year as per t he Requirement from the FasServices.     
if @FromDate< DATEAdd(YY,-1,GETDATE())    
 set @FromDate = DATEADD(YY,-1,GETDATE())+1      
select @ToDate = getdate()    
    
set @RequestXML = '<request type="ProcessInteropRequest"><requestParams method="GetAddedOrUpdatedAssessments" versionNumber="1.0" >'    
                + '<criteria dataType="Extended" orgSoftwareId="' + @OrgSoftwareId + '" filterType="AddedOrUpdated" measure="CAFAS" '     
                + 'fromDate="' + convert(char(10), @FromDate, 101) + ' ' + convert(char(8), @FromDate, 108) + '.001" '    
                + 'toDate="' + convert(char(10), @ToDate, 101) + ' ' + convert(char(8), @ToDate, 108) + '.000">'    
                + '<clients><client primaryId="'+CONVERT(varchar(50),@ClientID)+'"/></clients>'    
                + '</criteria></requestParams></request>'    
    
End    
    
else if (@RequestType) = 'beginAssessment'    
Begin    
set @RequestXML = '<request type="ProcessInteropRequest"> <requestParams method="' + @RequestType + '" assessmentType="CAFAS" '+     
                   'userId="'+@StaffId+'" versionNumber="1.0" ' + 'requestingOrgSoftwareID="' + @OrgSoftwareId + '" primaryClientID="' + @ClientID +    
                   '" ></requestParams></request>'    
    
End     
    
insert into CustomFASRequestLog(RequestType, RequestXML) values (@RequestType, @RequestXML)    
    
End Try    
Begin catch    
    
if @@error <> 0      
begin      
  select @errorno = 50010, @errormsg = 'Failed to insert data into CustomFASRequestLog.'      
  --RAISERROR ( @errormsg, /* Message text.*/16, /* Severity.*/ 1 /*State.*/ );     
  goto error      
end      
    
End catch    
    
 set @FasRequestID= (select  @@identity )    
    
select @RequestXML as RequestXML,@FasRequestID as FasRequestID    
    
--commit tran      Coomment this code by Rakesh Garg as CLientId was hardcoded  
      
return      
      
error:      
  if @@trancount > 0      
    rollback tran      
      
  raiserror @errorno @errormsg      
      
    
End    
  
GO


