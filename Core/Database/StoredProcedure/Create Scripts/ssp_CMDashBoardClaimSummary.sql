if object_id('dbo.ssp_CMDashBoardClaimSummary') is not null
  drop procedure dbo.ssp_CMDashBoardClaimSummary
go


create  procedure dbo.ssp_CMDashBoardClaimSummary
  @Insurerid int,
  @StaffID int 
/*********************************************************************                 
-- Stored Procedure: dbo.ssp_DashBoardClaimSummary                
-- Copyright: 2005 Provider Claim Management System                
-- Creation Date:  11/13/2005                
--                      
-- Purpose: It gets the Claims Summary for the  DashBoard                
--                                        
-- Updates:                
--  Date         Author       Purpose                 
--  01/03/2006   Vikrant      Created                
--  06/01/2006   SFarber      Optimized for better performance 
--  02/11/2014   Shruthi.S    Moved denial from 2.x.Ref #2 Care Management to SmartCare
--  11/01/2014   Shruthi.S    Added same logic as in claims list page under My office.
-- 11/08/2014   Shruthi.S    Added temp table to get the count for To be worked.Ref #2.1 CM to SC.
--  08/Jan/2015   SuryaBalan  Added conditions for Dashboard : Widget sp's needs to be changed to include StaffInsu StaffProvRef #331 CM to SC. 
--  21/Jan/2015   SuryaBalan  Added conditions for Dashboard : Widget sp's needs to be changed to include StaffInsu StaffProvRef #331 CM to SC.
--                            Provider Claims Widgets 
--  29/Jan/2015   SuryaBalan  Removed ProviderInsurer Join for Dashboard : Widget sp's needs to be changed to include StaffInsu StaffProvRef #331 CM to SC.
--                              Provider Claims Widgets
--  30/Jan/2015   Gautam      Seperated code for ToBeAdjudicated and IncompleteDataEntry, Why : Duplicate data get counted in ToBeAdjudicated  
--  30/Jan/2015   SuryaBalan  Added StaffInsurer Condition in Credits Not Taken Why : Count Mismatch
--  02/Feb/2015   Gautam      Added code for ToBePaid and PaymentOverDue Why : count mismatch with List page,task #331 in Care Management to SmartCare Env. Issues Tracking                        
--  12/Oct/2015   Ravichandra what:If ClientType =''I'' then Client FirstName and LastName and If ClientType=''O'' then OrganizationName
--							  why:task #609 Network180 Customization 
--  08.11.2017    SFarber     Redesigned to improve performance.
--  08.15.2017    SFarber     Modified to use LastAdjudicationDate.
*********************************************************************/
as
declare @IncompleteDataEntry int
declare @ToBeAdjudicated int
declare @PendedMoreThan30 int 
declare @PaymentOverdue int
declare @NeedsToBeWorked int
declare @ToBePaid int
declare @DenialLetterNotSent int

declare @AllStaffInsurer varchar(1)
declare @AllStaffProvider varchar(1)

select  @AllStaffInsurer = AllInsurers
from    Staff
where   StaffId = @StaffID

select  @AllStaffProvider = AllProviders
from    Staff
where   StaffId = @StaffID
	    		  
select  @DenialLetterNotSent = count(distinct cl.ClaimLineId)
from    ClaimLineDenials cld
        join ClaimLines cl on cl.ClaimLineId = cld.ClaimLineId
        join Claims c on c.ClaimId = cl.ClaimId
        join Sites as s on s.SiteId = c.SiteId
        join Providers as p on p.ProviderId = s.ProviderId
        join Insurers i on i.InsurerId = c.InsurerId
        join Clients ct on ct.ClientId = c.ClientId
where   cl.Status = 2024
        and cld.DenialLetterId is null
        and cld.CheckId is null
        and (c.InsurerId = @Insurerid
             or (isnull(@Insurerid, 0) = 0
                 and i.Active = 'Y'))
        and isnull(cl.NeedsToBeWorked, 'N') = 'N'
        and isnull(cl.ToReadjudicate, 'N') = 'N'
        and isnull(cld.RecordDeleted, 'N') = 'N'
        and isnull(cl.RecordDeleted, 'N') = 'N'
        and isnull(c.RecordDeleted, 'N') = 'N'
        and isnull(ct.RecordDeleted, 'N') = 'N'
        and isnull(i.RecordDeleted, 'N') = 'N'
        and isnull(p.RecordDeleted, 'N') = 'N'
        and isnull(s.RecordDeleted, 'N') = 'N'
        and (@AllStaffInsurer = 'Y'
             or exists ( select si.InsurerId
                         from   StaffInsurers si
                         where  si.StaffId = @StaffID
                                and c.InsurerId = si.InsurerId
                                and isnull(si.RecordDeleted, 'N') = 'N' ))
        and (@AllStaffProvider = 'Y'
             or exists ( select si.ProviderId
                         from   StaffProviders si
                         where  si.StaffId = @StaffID
                                and (p.ProviderId = si.ProviderId)
                                and isnull(si.RecordDeleted, 'N') = 'N' )) 
   
 

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
                              and isnull(i.RecordDeleted, 'N') = 'N'
        join Sites s on s.SiteId = c.SiteId
        join Providers p on p.ProviderId = s.ProviderId
                            and isnull(p.RecordDeleted, 'N') = 'N'
        join Clients ct on ct.ClientId = c.ClientId
where   isnull(cl.RecordDeleted, 'N') = 'N'
        and isnull(c.RecordDeleted, 'N') = 'N'
        and isnull(oc.RecordDeleted, 'N') = 'N'
        and isnull(s.RecordDeleted, 'N') <> 'Y'
        and isnull(p.RecordDeleted, 'N') <> 'Y'
        and isnull(ct.RecordDeleted, 'N') <> 'Y'
        and isnull(i.RecordDeleted, 'N') <> 'Y'
        and (c.InsurerId = @Insurerid
             or (isnull(@Insurerid, 0) = 0
                 and i.Active = 'Y'))
        and (@AllStaffInsurer = 'Y'
             or exists ( select si.InsurerId
                         from   StaffInsurers si
                         where  si.StaffId = @StaffID
                                and c.InsurerId = si.InsurerId
                                and isnull(si.RecordDeleted, 'N') = 'N' ))
        and (@AllStaffProvider = 'Y'
             or exists ( select si.ProviderId
                         from   StaffProviders si
                         where  si.StaffId = @StaffID
                                and (p.ProviderId = si.ProviderId)
                                and isnull(si.RecordDeleted, 'N') = 'N' )) 

select  isnull(@IncompleteDataEntry, 0) as IncompleteDataEntry
select  isnull(@ToBeAdjudicated, 0) as Adjudicated
select  isnull(@PendedMoreThan30, 0) as Pended
select  isnull(@PaymentOverdue, 0) as PaymentOverdue
select  isnull(@NeedsToBeWorked, 0) as Worked
select  isnull(@ToBePaid, 0) as Paid
select  isnull(@DenialLetterNotSent, 0) as DenialNoticeNotSent 

go


