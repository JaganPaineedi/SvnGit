if object_id('dbo.ssp_PADashBoardClaimSummary') is not null
  drop procedure dbo.ssp_PADashBoardClaimSummary
go

create procedure dbo.ssp_PADashBoardClaimSummary
  @ProviderId int,
  @StaffId int    
/*********************************************************************  
-- Stored Procedure: dbo.ssp_PADashBoardClaimSummary  
-- Copyright: 2007 Provider Access                    
--                                                    
-- Purpose: It gets the Claims Summary for the  DashBoard  
--                                                         
-- Updates:  
--  Date           Author       Purpose                   
--  04/01/2014     Shruthi.S    It gets the Claims Summary for the  DashBoard   
/*  11/08/2014     Shruthi.S    Added temp table to get the count for To be worked.Ref #2.1 CM to SC. */

/*  21-Jan-2015   SuryaBalan    Added Statt Insurers and Providers condition for Task331 CM to SC Issues.
 Dashboard : Widget sp's needs to be changed to include StaffInsu StaffProv*/
 
 /*  03-Feb-2015   SuryaBalan    Modified condition for TobeAdjudicated and ClaimLinesENtry for Task331 CM to SC Issues.
 Dashboard : Widget sp's needs to be changed to include StaffInsu StaffProv*/
  /*  03-Feb-2015   SuryaBalan    Added ProviderId for all counts for Task331 CM to SC Issues.
 Dashboard : Widget sp's needs to be changed to include StaffInsu StaffProv
    03/03/2015      Shruthi.S    Removed provider temp table join because Provider claims widget count was appearing 0.Ref #548 Env Issues. */
/* 06-APR-2015		RQuigley	Changed #ClaimLineToBeWorked.Status to VARCHAR(250) to match size of Codename in GLobalcodes */
/* MAY-21-2015		dharvey  The @DenialNoticeNotSent value is not included in SELECT list so I am commenting out the logic for now. */  
/* 01-Feb-2016      Gautam      What : Changed the code to match with List page count why : Count mismatch with List page, task#797 SWMBH - Support */
/*05-July-2016		Manjunath What: Changed the code to match with List page count based on @Staff. Why:The ARC - Environment Issues Tracking #49 */
/*18-Jan-2017*/     Lakshmi   What: Dashboard - Provider Claims widget:  shows 0 for To Be Adjudicated but there are claims
							  Why: The Arc - Support Go Live #116
-- 02.12.2018       SFarber   Modified to improve performance.
*********************************************************************/
as
begin try  
  declare @IncompleteDataEntry int  
  declare @ToBeAdjudicated int    
  declare @PendedMoreThan30 int     
  declare @PaymentOverdue int    
  declare @NeedsToBeWorked int    
  declare @ToBePaid int    
  
  declare @AllStaffInsurers char(1)  
  declare @AllStaffProviders char(1)  
  
  select  @AllStaffInsurers = AllInsurers,
          @AllStaffProviders = AllProviders
  from    Staff
  where   StaffId = @StaffId  


  select  @PendedMoreThan30 = sum(case when cl.Status = 2027
                                            and datediff(d, cl.LastAdjudicationDate, getdate()) > 30 then 1
                                       else 0
                                  end),
          @PaymentOverdue = sum(case when cl.Status in (2023, 2025)
                                          and datediff(d, c.CleanClaimDate, getdate()) >= 30 then 1
                                     else 0
                                end),
          @NeedsToBeWorked = sum(case when cl.NeedsToBeWorked = 'Y' then 1
                                      else 0
                                 end),
          @ToBePaid = sum(case when cl.Status in (2023, 2025)
                                    and isnull(cl.NeedsToBeWorked, 'N') = 'N' then 1
                               else 0
                          end),
          @ToBeAdjudicated = sum(case when (isnull(cl.DoNotAdjudicate, 'N') <> 'Y'
                                            and (cl.Status = 2022
                                                 or (cl.ToReadjudicate = 'Y'
                                                     and Status in (2024, 2027)))) then 1
                                      else 0
                                 end),
          @IncompleteDataEntry = sum(case when cl.Status in (2021) then 1
                                          else 0
                                     end)
  from    OpenClaims oc
          join ClaimLines cl on cl.ClaimLineId = oc.ClaimLineId
          join Claims c on c.ClaimId = cl.ClaimId
          join Insurers as i on i.InsurerId = c.InsurerId
          join Sites s on s.SiteId = c.SiteId
          join Providers p on p.ProviderId = s.ProviderId
          join Clients ct on ct.ClientId = c.ClientId
  where   isnull(cl.RecordDeleted, 'N') = 'N'
          and isnull(c.RecordDeleted, 'N') = 'N'
          and isnull(oc.RecordDeleted, 'N') = 'N'
          and isnull(s.RecordDeleted, 'N') = 'N'
          and isnull(p.RecordDeleted, 'N') = 'N'
          and isnull(ct.RecordDeleted, 'N') = 'N'
          and isnull(i.RecordDeleted, 'N') = 'N'
          and i.Active = 'Y'
          and (p.ProviderId = @ProviderId
               or isnull(@ProviderId, 0) = 0)
          and (@AllStaffInsurers = 'Y'
               or exists ( select si.InsurerId
                           from   StaffInsurers si
                           where  si.StaffId = @StaffId
                                  and c.InsurerId = si.InsurerId
                                  and isnull(si.RecordDeleted, 'N') = 'N' ))
          and (@AllStaffProviders = 'Y'
               or exists ( select sp.ProviderId
                           from   StaffProviders sp
                           where  sp.StaffId = @StaffId
                                  and (p.ProviderId = sp.ProviderId)
                                  and isnull(sp.RecordDeleted, 'N') = 'N' )) 
     

  select  isnull(@IncompleteDataEntry, 0) as IncompleteDataEntry      
  select  isnull(@ToBeAdjudicated, 0) as Adjudicated      
  select  isnull(@PendedMoreThan30, 0) as Pended      
  select  isnull(@PaymentOverdue, 0) as PaymentOverdue      
  select  isnull(@NeedsToBeWorked, 0) as Worked      
  select  isnull(@ToBePaid, 0) as Paid     
  
end try  
  
begin catch  
  
  declare @Error varchar(8000)      
  set @Error = convert(varchar, error_number()) + '*****' + convert(varchar(4000), error_message()) + '*****' + isnull(convert(varchar, error_procedure()), 'ssp_PADashBoardClaimSummary') + '*****' + convert(varchar, error_line()) + '*****' + convert(varchar, error_severity()) + '*****' + convert(varchar, error_state())      
        
  raiserror       
 (      
  @Error, -- Message text.      
  16, -- Severity.      
  1 -- State.      
 )      
      
end catch      
  
go


