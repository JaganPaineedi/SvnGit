IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_SCAlertsClientPrimaryCareExternalReferrals')
	BEGIN
		DROP  Procedure  ssp_SCAlertsClientPrimaryCareExternalReferrals
	END

GO

   
CREATE Procedure ssp_SCAlertsClientPrimaryCareExternalReferrals
AS    
/************************************************************************************/        
/* Stored Procedure: dbo.[ssp_SCAlertsClientPrimaryCareExternalReferrals]        */        
/* Copyright: 2012 Streamline Healthcare Solutions,  LLC       */        
/* Creation Date:   1-Oct-2012              */             
/* Purpose:It is used for insert Into Alerts.
 After the appointment date and time has passed an alert/note/message should be created to notify the user that entered the referral 
 that the appointment date and time has passed and that follow up from them is needed.The alert will be sent two days after the Date and Time have passed. 
 With ref Task#4 in primary care -summit pointe.  */       
/*                     */      
/* Input Parameters:                */      
/*                     */        
/* Output Parameters:   None              */        
/*                     */        
/* Return:  0=success, otherwise an error number         */        
/*                     */        
/* Called By:                  */        
/*                     */        
/* Calls:                   */        
/*                     */        
/* Data Modifications:                */        
/*                     */        
/* Updates:                   */        
/*  Date           Author             Purpose            */        
/* 1-Oct-2012      Vishant Garg       Created            */  
/*  21 Oct 2015		Revathi			what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  */   
/*									why:task #609, Network180 Customization  */        
/************************************************************************************/   
 Begin

declare @AlertToUser1 int

declare @AlertType int
--StaffId
set @AlertToUser1 =123

set @AlertType = 88  --(Category -AlertTYpe,CodeName-Referal Alert)

declare  @ClientPrimaryCareExternalReferrals table (  
Id       int identity not null,  
ClientId int null,  
ClientName varchar (100)
) 

insert into @ClientPrimaryCareExternalReferrals(ClientID,ClientName)
--Added by Revathi   21 Oct 2015
select g.ClientId,case when ISNULL(C.ClientType,'I')='I' THEN (ISNULL(c.LastName,'') + ', ' + ISNULL(c.FirstName,''))  ELSE  ISNULL(C.OrganizationName,'') END as ClientName from ClientPrimaryCareExternalReferrals g
join Clients c on g.ClientId = c.ClientId 
WHERE (DATEDIFF(DD,g.AppointmentDate,GETDATE()))> = 2 AND (DATEDIFF(MI,g.AppointmentTime,GETDATE()))>= (48*60)
AND ISNULL(g.RecordDeleted,'N')='N' 


---- Only one alert per client  
delete A  
from @ClientPrimaryCareExternalReferrals A  
where exists (select * from @ClientPrimaryCareExternalReferrals A2 where A2.ClientId = A.ClientId and A2.Id < A.Id )  
 

----Delete Old Alerts
 delete Al  
 from Alerts Al  
 where Al.AlertType = @AlertType --  (referalalert)  
 and not exists(select 1 from @ClientPrimaryCareExternalReferrals A where A.ClientId = Al.ClientId) 
  
  
 INSERT INTO Alerts (  
 ToStaffId, ClientId, AlertType,Unread,DateReceived,Subject,Message
 )   
 SELECT   
 @AlertToUser1, --to Staff (service clinician)  
 PCR.ClientId,   
 @AlertType, --referalalert 
 'Y',  
 GETDATE(),  
 'External Referral - ' + PCR.ClientName, --Subject  
 PCR.ClientName + ' - External Referral appointment has passed.  Please complete the required information for the referral.' --message  
from @ClientPrimaryCareExternalReferrals PCR
WHERE
 NOT EXISTS ( select 1 from Alerts al   
 WHERE  al.ClientId = PCR.ClientId  
 and al.AlertType = @AlertType and  ISNULL(al.RecordDeleted,'N') = 'N'  
 )   
   
--where not exists (select 1 from Alerts A where A.ClientId = PCR.ClientId and A.AlertType = @AlertType and  ISNULL(A.RecordDeleted,'') = 'N' AND A.ToStaffId=@AlertToUser1)  
 
END  

 