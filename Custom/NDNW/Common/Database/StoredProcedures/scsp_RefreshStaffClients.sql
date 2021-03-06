/****** Object:  StoredProcedure [dbo].[scsp_RefreshStaffClients]    Script Date: 10/11/2016 6:13:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if object_id('scsp_RefreshStaffClients', 'P') is not null
    drop procedure scsp_RefreshStaffClients
go

create procedure [dbo].[scsp_RefreshStaffClients]    
@StaffId int,    
@ClientId int    
/********************************************************************************    
-- Stored Procedure: dbo.scsp_RefreshStaffClients      
--    
-- Copyright: Streamline Healthcate Solutions    
--    
-- Purpose: Refreshes a list of clients that a staff member can access according to     
--          the custom client access rules (Category = 'CLIENTACCESSRULE' and GlobalCodeId > 10000)    
-- Called by: ssp_RefreshStaffClients    
--    
-- Updates:                                                           
-- Date        Author      Purpose    
-- 06.25.2010  SFarber     Created.          
-- 10.11.2016	TRemisoski  Altered to allow access to all clients  (inactive or not) for Staff with the "All Clients" privilege
*********************************************************************************/    
as    

declare @NonStaffUser char(1)
declare @AssociatedClientId int
declare @AllProviders char(1)

select  @NonStaffUser = s.NonStaffUser,
        @AssociatedClientId = s.TempClientId,
        @AllProviders = s.AllProviders
from    Staff s
where   s.StaffId = @StaffId
    
--
-- All Clients
-- Additional security check - non staff users cannot have access to all clients even if they have permissions
--
if isnull(@NonStaffUser, 'N') <> 'Y'
  and exists ( select *
               from   ViewStaffPermissions
               where  StaffId = @StaffId
                      and PermissionTemplateType = 5705
                      and PermissionItemId = 5741 ) 
begin

-- bring in all clients regardless of active status

insert  into StaffClients
        (StaffId,
         ClientId)
        select  @StaffId,
                c.ClientId
        from    Clients c
        where isnull(c.RecordDeleted, 'N') = 'N'
	   and not exists ( select *
                             from   StaffClients sc
                             where  sc.StaffId = @StaffId
                                    and sc.ClientId = c.ClientId )


end

    
return    
go
