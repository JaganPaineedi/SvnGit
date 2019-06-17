

/****** Object:  StoredProcedure [dbo].[ssp_CMGetAlertMessagesList]    Script Date: 02/19/2016 16:11:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMGetAlertMessagesList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CMGetAlertMessagesList]
GO



/****** Object:  StoredProcedure [dbo].[ssp_CMGetAlertMessagesList]    Script Date: 02/19/2016 16:11:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[ssp_CMGetAlertMessagesList]          
(        
@userID int,        
@InsurerID int        
)        
AS        
/*********************************************************************/          
/* Stored Procedure: ssp_CMGetAlertMessagesList           */          
/* Copyright: 2005 Provider Claim Management System,  PCMS             */          
/* Creation Date:    11/18/05                                         */          
/*                                                                   */          
/* Purpose:  It is used to return the messages  or Alerts list which we show on the dashboard for the loged user          */         
/*                                                                   */        
/* Input Parameters: @userID,@InsurerID                 */        
/*                                                                   */          
/* Output Parameters:   None                               */          
/*                                                                   */          
/* Return:  0=success, otherwise an error number                     */          
/*                                                                   */          
/* Called By:                                                        */          
/*                                                                   */          
/* Calls:                                                            */          
/*                                                                   */          
/* Data Modifications:                                               */          
/*                                                                   */          
/* Updates:                                                          */          
/*  Date     Author       Purpose                                    */          
/* 11/18/05   Vikrant    Created                                    */         
/* 02/11/2014 Shruthi.S  Changed From to FromName.Ref :#2 Care Management to SmartCare.*/   
/* 03/28/2014 Shruthi.S  Changed users table to staff.Ref #1.1 Care Management to SmartCare   
 /*  21 Oct 2015  Revathi     what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  */   
/*             why:task #609, Network180 Customization  */   
/* 19/02/2016  Pradeep Kumar Yadav What: Added Condition to Check ClientID when selecting ClientName.
								Why : It was returning only ',' if ClientId is not there For Task #873 SWMBH-Support */ 
/* 23/06/2016  Bernardin    What: Removed Active = 'Y' check from client table.
                            Why: Wanted to display message even if the client status is inactive.*/								                                                          */    
/*********************************************************************/           
        
BEGIN
     BEGIN TRY   
if(@InsurerID<>0)        
 Begin        
  --get the data from messages        
  (        
  (Select distinct rtrim(Staff.LastName) + ', ' + rtrim(Staff.FirstName) as [FromName]  ,         
  convert(varchar(18),Messages.dateReceived,101) as Received , 
  case when Messages.ClientId<> 0 then       
    --Added by Revathi 21.Oct.2015   
  case when  ISNULL(Clients.ClientType,'I')='I' then     
  rtrim(ISNULL(Clients.LastName,''))  + ', ' + rtrim(ISNULL(Clients.FirstName,''))  
  else ISNULL(Clients.OrganizationName,'') end ELSE '' END  as Client ,         
  Messages.[Subject],    
 cast(Messages.[Message] as varchar(8000)) as [Message],     
-- Commented By Gursharan Singh    
 --Substring(Replace(Replace(Messages.Message,Char(10),''),Char(13),''),1,100) as Message,    
 Messages.MessageId,'M' as type         
  from Messages          
  left outer join Clients  on Clients.Clientid= Messages.Clientid  and IsNull(Clients.RecordDeleted,'N')='N'        
  left outer join Staff on Messages.FromStaffId=Staff.StaffId and IsNull(Staff.RecordDeleted,'N')='N'         
  left outer  join StaffInsurers  on Staff.StaffId=StaffInsurers.StaffId and IsNull(StaffInsurers.RecordDeleted,'N')='N'        
  where  Messages.unread='Y' and isNull(Messages.RecordDeleted,'N')<>'Y' and   Messages.ToStaffId=@userID         
  and StaffInsurers.InsurerID=@InsurerID)        
      
          
  union        
  -- get the Data from Alerts        
  (        
  select distinct 'System' as FromName,         
  convert(varchar(18), Alerts.dateReceived,101) as Received ,
  case when Alerts.ClientId<> 0 then        
--Added by Revathi 21.Oct.2015   
 case when  ISNULL(Clients.ClientType,'I')='I' then     
  rtrim(ISNULL(Clients.LastName,''))  + ', ' + rtrim(ISNULL(Clients.FirstName,''))  
  else ISNULL(Clients.OrganizationName,'') end ELSE '' END  as Client ,       
  alerts.[Subject],    
 cast(Alerts.[Message] as varchar(8000)) as [Message],     
-- Commented By Gursharan Singh    
--  Substring(Replace(Replace(Alerts.Message,Char(10),''),Char(13),''),1,100) as Message,     
  alerts.AlertId  as MessageId,'A' as type         
   from alerts       
   left outer join Clients on alerts.ClientId = Clients.ClientId      
   left outer join StaffInsurers  on  StaffInsurers.StaffId=alerts.ToStaffId      
   where  alerts.ToStaffId = @userID and alerts.unread='Y'        
   and   StaffInsurers.InsurerID=@InsurerID        
   and isNull(alerts.RecordDeleted,'N')<>'Y' and IsNull(Clients.RecordDeleted,'N')='N'        
   and IsNull(StaffInsurers.RecordDeleted,'N')='N'        
          
  ))        
  order by received desc        
    
--Checking For Errors    
--If (@@error!=0)  Begin  RAISERROR  20006  'ssp_CMGetAlertMessagesList: An Error Occured'     Return  End    
    
 End        
Else        
 Begin        
  --get the data from messages        
  (        
  (select distinct rtrim(Staff.LastName) + ', ' + rtrim(Staff.FirstName) as [FromName]  ,         
  convert(varchar(18),Messages.dateReceived,101) as Received ,        
   --Added by Revathi 21 Oct 2015 
   
  case when Messages.ClientId<> 0 then
  case when  ISNULL(Clients.ClientType,'I')='I' then     
  rtrim(ISNULL(Clients.LastName,''))  + ', ' + rtrim(ISNULL(Clients.FirstName,''))  
  else ISNULL(Clients.OrganizationName,'') end Else '' END as Client ,         
  Messages.[Subject],    
 cast(Messages.[Message] as varchar(8000)) as [Message],     
 -- Commented By Gursharan Singh    
--Substring(Replace(Replace(Messages.Message,Char(10),''),Char(13),''),1,100) as Message,     
Messages.MessageId,'M' as type         
  from Messages          
   left outer  join Clients  on Clients.Clientid= Messages.Clientid and IsNull(Clients.RecordDeleted,'N')='N'        
  left outer  join Staff on Messages.FromStaffId=Staff.StaffId and IsNull(Staff.RecordDeleted,'N')='N'         
  left outer  join StaffInsurers  on Staff.StaffId=StaffInsurers.StaffId and IsNull(StaffInsurers.RecordDeleted,'N')='N'        
  where  Messages.unread='Y' and isNull(Messages.RecordDeleted,'N')<>'Y' and   Messages.ToStaffId=@userID         
        
        
)        
        
          
  union        
  -- get the Data from Alerts        
  (select distinct 'System' as FromName,         
  convert(varchar(18), Alerts.dateReceived,101) as Received ,  
  case when Alerts.ClientId<> 0 then      
     --Added by Revathi 21 Oct 2015     
  case when  ISNULL(Clients.ClientType,'I')='I' then     
  rtrim(ISNULL(Clients.LastName,''))  + ', ' + rtrim(ISNULL(Clients.FirstName,''))  
  else ISNULL(Clients.OrganizationName,'') end ELSE '' END as CLientName,        
  alerts.[Subject],    
    cast(Alerts.[Message] as varchar(8000)) as [Message],     
  -- Commented By Gursharan Singh    
   --Substring(Replace(Replace(alerts.Message,Char(10),''),Char(13),''),1,100) as Message,    
   alerts.AlertId  as MessageId,'A' as type         
   from alerts       
   left outer join Clients on alerts.ClientId = Clients.ClientId  and clients.Active='Y' and  IsNull(Clients.RecordDeleted,'N')='N'        
   left outer join StaffInsurers on  StaffInsurers.StaffId=alerts.ToStaffId and IsNull(StaffInsurers.RecordDeleted,'N')='N'    
   where  alerts.ToStaffId = @userID and alerts.unread='Y'        
   and isNull(alerts.RecordDeleted,'N')<>'Y'    
       
           
  ))        
  order by received desc        
    
--Checking For Errors    
--If (@@error!=0)  Begin  RAISERROR  20006  'ssp_CMGetAlertMessagesList: An Error Occured'     Return  End    
    
 End        
 END TRY       
   BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_CMGetAlertMessagesList') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


