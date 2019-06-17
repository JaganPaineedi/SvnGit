/****** Object:  StoredProcedure [dbo].[csp_SCNotificationOfContractedProviders]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCNotificationOfContractedProviders]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCNotificationOfContractedProviders]
GO

/****** Object:  StoredProcedure [dbo].[csp_SCNotificationOfContractedProviders]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


   
CREATE Procedure [dbo].[csp_SCNotificationOfContractedProviders]
(
 @ClientId int,
 @CurrentUser varchar(50)
 )
AS    
/************************************************************************************/        
/* Stored Procedure: dbo.[csp_SCNotificationOfContractedProviders]        */        
/* Copyright: 2012 Streamline Healthcare Solutions,  LLC       */        
/* Creation Date:   29-March-2012              */             
/* Purpose:It is used to send message,task 85 General Impelementation.   */       
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
/* 29-March-2012   Saurav Pande       Created            */        
/************************************************************************************/   
Begin
Begin Try

 declare @sub varchar(100)
 declare @msg varchar(200)
 declare @ToStaffId int                                        
 declare @CurrentDate Datetime
 declare @FromStaffId varchar(50)
 
 set @ToStaffId = (select top 1 StaffID st from Staff
join Clients ct on ct.PrimaryClinicianId = Staff.StaffId
where ClientId  = @ClientId )

 set @FromStaffId = (select StaffId from Staff where Usercode =@CurrentUser)
 
 set @sub = 'Pre-admission hospital screen completed'
 set @msg = 'A pre-admission hospital screen was completed last night by the author of this message for the associated client.'
 set @CurrentDate = getdate();
 
 if exists(select top 1 StaffID st from Staff
join Clients ct on ct.PrimaryClinicianId = Staff.StaffId
where ClientId  = @ClientId)
 Begin
 Declare @myTable table(MessageIdInserted int null) 
 INSERT INTO @myTable
 Exec ssp_SCSaveMessage @FromStaffId,@ToStaffId,@ClientId,'Y',@CurrentDate,@sub,@msg,60,null,null,null,'',@CurrentUser,@CurrentDate,@CurrentUser,@CurrentDate,null,null,null,null,null,null,null,null,null,'Y','Y',-1,@ToStaffId,null,null,null,null,null,'N'
 End
 

 End Try                            
  Begin Catch                              
  declare @Error varchar(8000)                                            
  set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                             
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_SCNotificationOfContractedProviders')                                             
  + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                              
  + '*****' + Convert(varchar,ERROR_STATE())                                                            
  End Catch                              

 End            
      
      

GO


