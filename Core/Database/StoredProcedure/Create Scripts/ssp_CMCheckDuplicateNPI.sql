
set quoted_identifier on
set ansi_nulls on
go

if exists ( select  1
            from    sys.procedures
            where   name = 'ssp_CMCheckDuplicateNPI' )
  begin
    drop procedure ssp_CMCheckDuplicateNPI
  end
go

create procedure dbo.ssp_CMCheckDuplicateNPI
  @NPI varchar(500),
  @ProviderId int    
/*********************************************************************/                  
/* Stored Procedure: dbo.ssp_CMCheckDuplicateNPI			*/              
                 
/*                                                                  */                  
/* Data Modifications:												*/                  
/*																	*/                  
/* Updates:															*/
/********************************************************************/
/*	Date			Author			Purpose							*/	
/*  19 Dec 2014     Vichee Humane  To check duplicate NPI .Ref #164 Care Management to SmartCare Env. Issues Tracking*/
/*	21 Apr 2015		RQuigley	   Don't count blank NPIs.			*/
--  06.26.2017      SFarber        Modified to look only at active providers
/********************************************************************/
as
begin
   
  begin try     
 
    select  count(*) as NPICount
    from    Sites s
            join Providers p on p.ProviderId = s.ProviderId
    where   s.NationalProviderId = nullif(@NPI, '')
            and s.Active = 'Y'
            and p.Active = 'Y'
            and isnull(s.RecordDeleted, 'N') <> 'Y'
            and isnull(p.RecordDeleted, 'N') <> 'Y'
            and exists ( select 1
                         from   Sites s2
                                join Providers p2 on p2.ProviderId = s2.ProviderId
                         where  s2.ProviderId <> @ProviderId
                                and s2.NationalProviderId = s.NationalProviderId
                                and s2.Active = 'Y'
                                and p2.Active = 'Y'
                                and isnull(s2.RecordDeleted, 'N') <> 'Y'
                                and isnull(p2.RecordDeleted, 'N') <> 'Y' )
   
  end try
	
  begin catch
    declare @Error varchar(8000)   
  
    set @Error = convert(varchar, error_number()) + '*****' + convert(varchar(4000), error_message()) + '*****' + isnull(convert(varchar, error_procedure()), 'ssp_CMCheckDuplicateNPI') + '*****' + convert(varchar, error_line()) + '*****' + convert(varchar, error_severity()) + '*****' + convert(varchar, error_state())   
  
    raiserror ( @Error,-- Message text.                
                      16,-- Severity.                
                      1 -- State.                
          );   
  end catch
end  

go


