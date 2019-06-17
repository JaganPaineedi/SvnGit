IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMGetPrimaryClinician]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CMGetPrimaryClinician]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

      
create procedure [dbo].[ssp_CMGetPrimaryClinician]  
@UserId int  
as          
/******************************************************************************          
**  File:           
**  Name: [ssp_CMGetPrimaryClinician]          
**  Desc:           
**          
**  Called by:             
**                        
**  Parameters:          
**  Input       Output          
**     ----------       -----------          
**          
**  Auth: Akash Saxena         
**  Date:  21-June-07         
*******************************************************************************          
**  Change History          
*******************************************************************************          
**  Date:      Author:    Description:          
**  --------   --------   -------------------------------------------          
**  06.21.2007 Akash      To get Providers  for Member Search          
**  04.28.2009 SFarber    Fixed Order By.  
*******************************************************************************/          
Begin       
  
declare @Providers table (ProviderId int, ProviderName varchar(100))  
  
insert into @Providers (ProviderId, ProviderName)  
select 0 as ProviderId, 'All Providers'  
union          
select p.ProviderId, p.ProviderName      
  from StaffProviders up  
       join Providers p on p.ProviderId = up.ProviderId     
 where up.StaffId = @UserId     
   and p.Active = 'Y'  
   and isnull(p.RecordDeleted,'N')='N'  
  
select ProviderId, ProviderName  
  from @Providers   
 order by case when ProviderId = 0 then 1 else 2 end, ProviderName           
  
End      
        
GO
