/****** Object:  UserDefinedFunction [dbo].[CheckNewClient]    Script Date: 06/19/2013 18:03:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CheckNewClient]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[CheckNewClient]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CheckNewClient]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'/*********************************************************************/                
/*Function: dbo.CheckNewClient */                
/* Copyright: 2007 Streamline HealthCare */                
/* Creation Date:  12/14/2006                                    */                
/*                                                                   */                
/* Purpose: it will get Insurer Name            */               
/*                                                                   */              
/* Output Parameters:        bit(Exist/Not Exist)                       */                
/*                                                                   */                
/* Called By:                                                        */                
/*                                                                   */                
/* Calls:                                                            */                
/*                                                                   */                
/* Data Modifications:                                               */                
/*                                                                   */                
/* Updates:                                                          */                
/*  Date          Author      Purpose                                    */                
/* 12/14/2006   Rajesh Kumar    Created                                    */                
CREATE FUNCTION [dbo].[CheckNewClient](@StaffId int, @MachineID varchar(50))  
RETURNS bit AS    
BEGIN   
--Declare @NewClient as bit  

	-- Condition added by Balvinder on 31st-Aug-07 if no client exists for Selected StaffId
  if not exists(Select ClientID from OfflineStaffClients where StaffID= @StaffID and MachineId=@MachineId)
	return 1
--set @InsurerName=(SELECT InsurerName FROM Insurers WHERE (InsurerId = @InsurerId))   
--My Primary Clients  
 if exists(Select @StaffId from Clients where PrimaryClinicianId=@StaffId and  (RecordDeleted =''N'' or RecordDeleted is Null)  
   and ClientID not in (Select ClientID from OfflineStaffClients where StaffID= @StaffID and MachineId=@MachineId ))  
 return 1    
  
 --client seen in last 3 months  
 /*if exists(select @StaffID  from Clients where clientid in (select ClientId from Services where DateOfService>=DATEADD(month, -3, getdate()) and ClinicianId=@StaffID  and   
  (RecordDeleted =''N'' or RecordDeleted is Null)) and ClientID not in (Select ClientID from OfflineStaffClients where StaffID= @StaffID and MachineId=@MachineId ))  
  return 1  
*/  
 --Clients where the user is the sender or receiver of a message (not deleted).  
 if exists(Select @StaffID  from Messages where ( FromStaffID=@StaffID or ToStaffID=@StaffID )  and clientid is not null  
  and (RecordDeleted =''N'' or RecordDeleted is Null) and ClientID not in (Select ClientID from OfflineStaffClients where StaffID= @StaffID and MachineId=@MachineId ))  
 --Clients  where user is the staff on alert  
 if exists(Select  @StaffID from Alerts where ToStaffID=@StaffID  and clientid is not null  
  and (RecordDeleted =''N'' or RecordDeleted is Null) and ClientID not in (Select ClientID from OfflineStaffClients where StaffID= @StaffID and MachineId=@MachineId ))  
  return 1  
 --Staff is an Author of ToDo or InProgress  Document.  
 if exists(select @StaffID from documents where status in(20,21) and authorid=@StaffID and (RecordDeleted =''N'' or RecordDeleted is Null)  
   and ClientID not in (Select ClientID from OfflineStaffClients where StaffID= @StaffID and MachineId=@MachineId ))  
  return 1  
  
 --Staff is a signer but has  not signed yet.  
 if exists(select @StaffID  from documents doc join DocumentSignatures ds  on ds.documentid = doc.Documentid  
  where ds.staffid = @StaffID  and (ds.RecordDeleted =''N'' or ds.RecordDeleted is Null) and ds.SignatureDate is null  
  and doc.ClientID not in (Select ClientID from OfflineStaffClients where StaffID= @StaffID and MachineId=@MachineId ))  
  return 1  
  
 
 return 0  
  
END
' 
END
GO
