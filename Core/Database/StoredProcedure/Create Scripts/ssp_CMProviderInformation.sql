if object_id('dbo.ssp_CMProviderInformation') is not null
  drop procedure dbo.ssp_CMProviderInformation
go

create procedure dbo.ssp_CMProviderInformation 
@ProviderId int  
/*********************************************************************/                
/* Stored Procedure: dbo.ssp_ProviderInformation             */                  
/* Copyright: 2005 Provider Claim Management System       */                  
/* Creation Date:  11/17/2005                                     */                  
/*                                                                     */                  
/* Purpose:To collect data from multiple tables for displaying & updating Provider information (This Procedure is used for Provider Information screen in the application) */              
/*                                                                     */                
/* Input Parameters:  @ProviderID             */                
/*                                                          */                  
/* Output Parameters:                               */                  
/*                                                                      */                  
/* Return: provider        */                  
/*                                                                     */                  
/* Called By:                                                         */                  
/*                                                                      */                  
/* Calls:                                                               */                  
/*                                                                       */                  
/* Data Modifications:                                                           */                  
/* Bhupinder Bajwa      */  
/* Updates:                                                                          */                  
/*  Date                Author    Purpose                                    */                  
/* 11/17/2005     gagan     Created                                     */  
/* SuryaBalan Task# 20 CM to SC Application 22-May-2014*/   
/* SuryaBalan Task# 20 CM to SC Application 2-June-2014 Removed Rowidentifier from Sites table*/ 
/* SuryaBalan Task# 20 CM to SC Application 24-June-2014 Added SiteTyeName in Sites*/    
/* Shruthi.S  Task# 20 CM to SC 14-Aug-2014 Modified ProviderContracts and Sites retrieval fields order to avoid concurrency issue.*/   
/* Shruthi.S  Task #618 Network 180 Customizations Added new field ProgramID.
   Shruthi.S  Task #3  CEI Customizations Added new field AssociatedClinicianId.*/
/* jwheeler   Task # 374 turned programid into a left join so they list on load */
/* Hemanth    Task # 530 Customization Bugs 
              What:Modified logic for For1099 column.   
*/  
/* Veena      Task #2 Family & Children Services Customization  Added  PlacementFamilyId,Family name to add a link to Placement Family on 12/11/15  
   Shruthi.S  Added new fields of Sites tab.Ref : #401 Aspen Pointe-Customizations.
   Basudev Sahu Added new fields - RenderingProvider in providers for task # CEI SGL */
/* 06.26.2017   SFarber   Modified to check for RecordDeleted flag when selecting ProviderAffiliates and ProviderInsurers   */
/* 24/11/2017(   Neethu- Allegan - Support #1237 -  Commented table 'globalcodes' because from dataset 'DataSetProviderInformation'  Globalcode table is removed */
 /* 07/12/2017 -  Sunil.Dasari - What: Dummy column Name from TypeName to ContactTypeText 
								 Why:	Architecture not associting the type valeu to grid,as per o*/   
/*********************************************************************/
as 

-- Variables declared to hold different Status Values  
declare @OfficeAddressType int,
  @HomeAddressType int,
  @TempAddressType int  

declare @BusinessPhoneType int,
  @FaxPhoneType int,
  @HomePhoneType int,
  @Home2PhoneType int,
  @Business2PhoneType int,
  @MobilePhoneType int,
  @Mobile2PhoneType int,
  @SchoolPhoneType int,
  @OtherPhoneType int,
  @SiteId int 
  
set @OfficeAddressType = 91  
set @HomeAddressType = 90  
set @TempAddressType = 92   
   
set @BusinessPhoneType = 31  
set @FaxPhoneType = 36  
set @HomePhoneType = 30  
set @Home2PhoneType = 32  
set @Business2PhoneType = 33  
set @MobilePhoneType = 34  
set @Mobile2PhoneType = 35  
set @SchoolPhoneType = 37  
set @OtherPhoneType = 38   

  
-- fetching data from Providers table  
select  P.ProviderId,
        P.ProviderType,
        P.Active,
        P.NonNetwork,
        P.DataEntryComplete,
        P.ProviderName,
        P.FirstName,
        P.ExternalId,
        P.Website,
        P.Comment,
        P.PrimarySiteId,
        P.PrimaryContactId,
        P.ContractingContactId,
        P.ApplyTaxIDToAllSites,
        P.ProviderIdAppliesToAllSites,
        P.POSAppliesToAllSites,
        P.TaxonomyAppliesToAllSites,
        P.NPIAppliesToAllSites,
        P.DataEntryCompleteForAuthorization,
        P.UsesProviderAccess,
        P.SubstanceUseProvider,
        P.AccessAgency,
        P.CredentialApproachingExpiration,
        P.RowIdentifier,
        P.CreatedBy,
        P.CreatedDate,
        P.ModifiedBy,
        P.ModifiedDate,
        P.RecordDeleted,
        P.DeletedDate,
        P.DeletedBy,
        S.SiteName,
        P.ProviderName as LastName,
        P.AssociatedClinicianId as AssociatedClinicianId,
        P.RenderingProvider,         --Added by Basudev for #364 CEI SGL
--Added by Veena  #2 Family & Children Services Customization
        PF.PlacementFamilyId,
        PF.FamilyName
from    Providers P
        left join Sites S on P.PrimarySiteId = S.SiteId
                             and isnull(S.RecordDeleted, 'N') <> 'Y'
        left join PlacementFamilies PF on P.ProviderId = PF.LinkedProviderId
                                          and isnull(PF.RecordDeleted, 'N') <> 'Y'
where   P.ProviderId = @ProviderId
        and isnull(P.RecordDeleted, 'N') <> 'Y'

--Checking For Errors  
if (@@error != 0)
  begin
    raiserror('ssp_ProviderInformation  : An Error Occured', 16, 1)
    return
  end                                     
  
-- fetching data of ProviderContacts for Contacts tab on Provider Information screen  
--Changed by Bhupinder Bajwa  
select  pc.ProviderContactId,
        pc.ProviderId,
        pc.LastName,
        pc.FirstName,
        pc.Prefix,
        pc.Suffix,
        pc.ListAs,
        pc.Email,
        pc.ContactType,
        pc.WorkPhone,
        pc.MobilePhone,
        pc.Fax,
        pc.Comment,
        pc.RowIdentifier,
        pc.CreatedBy,
        pc.CreatedDate,
        pc.ModifiedBy,
        pc.ModifiedDate,
        pc.RecordDeleted,
        pc.DeletedDate,
        pc.DeletedBy,
        pc.LastName + ', ' + pc.FirstName as Contact,
        case when p.PrimaryContactId = pc.ProviderContactId then 'Yes'
             else 'No'
        end as [Primary],
        case when p.ContractingContactId = pc.ProviderContactId then 'Yes'
             else 'No'
        end as Contracting,
        case when p.PrimaryContactId = pc.ProviderContactId then 'Y'
             else 'N'
        end as PrimaryContact,
        case when p.ContractingContactId = pc.ProviderContactId then 'Y'
             else 'N'
        end as ContractingContact,
        gc.CodeName as ContactTypeText
from    ProviderContacts as pc
        inner join Providers as p on p.ProviderId = pc.ProviderId
                                     and isnull(p.RecordDeleted, 'N') <> 'Y'
        left outer join GlobalCodes gc on pc.ContactType = gc.GlobalCodeId
                                          and isnull(gc.RecordDeleted, 'N') <> 'Y'
where   pc.ProviderId = @ProviderId
        and isnull(pc.RecordDeleted, 'N') <> 'Y' 
 
--Checking For Errors  
if (@@error != 0)
  begin
    raiserror('ssp_ProviderInformation  : An Error Occured', 16, 1)
    return
  end                                     
  
-- fetching data of Sites associated with this provider for Sites tab, Providers & Contacts tab on Provider Information screen   
select  Sites.SiteId,
        Sites.ProviderId,
        Sites.SiteName,
        Sites.Active,
        Sites.SiteType,
        GC.CodeName as SiteTypeName,
        Sites.Capacity,
        Sites.CurrentOpenings,
        Sites.OpeningsAsOf,
        Sites.HandicapAccess,
        Sites.EveningHours,
        Sites.WeekendHours,
        Sites.Adults,
        Sites.DDPopulation,
        Sites.MIPopulation,
        Sites.Children,
        Sites.TaxIDType,
        Sites.TaxID,
        Sites.PayableName,
        Sites.SecondaryProviderId,
        Sites.NationalProviderId,
        Sites.PlaceOfService,
        Sites.Comment,
        Sites.PrimaryContactId,
        Sites.LicenseNumber,
        Sites.Credentialed,
        Sites.TaxonomyCode,
        Sites.CreatedBy,
        Sites.CreatedDate,
        Sites.ModifiedBy,
        Sites.ModifiedDate,
        Sites.RecordDeleted,
        Sites.DeletedDate,
        Sites.DeletedBy,
--start:Hemanth 11/23/2015 10:52 pm
--'' as For1099,
        isnull((select top 1
                        SA.For1099
                from    SiteAddressess as SA
                where   Sites.SiteId = SA.SiteId
                        and isnull(SA.RecordDeleted, 'N') <> 'Y'
                order by SA.ModifiedDate desc), 'N') as For1099,
--End
        case when p.PrimarySiteId = Sites.SiteId then 'Y'
             else 'N'
        end as PrimarySite,
        case when p.PrimarySiteId = Sites.SiteId then 'Yes'
             else 'No'
        end as [Primary],
        Sites.ProgramId,
        Sites.StartDate,
        Sites.EndDate,
        Sites.SUDPopulation,
        (select Phone
         from   dbo.ssf_GetSitePhoneTypes(Sites.SiteId)) as Phone,
        (select ContactTypeText
         from   dbo.ssf_GetSitePhoneTypes(Sites.SiteId)) as ContactTypeText,
        Pg.ProgramName as ProgramIdText,
        Sites.MondayOpen,
        Sites.MondayClose,
        Sites.TuesdayOpen,
        Sites.TuesdayClose,
        Sites.WednesdayOpen,
        Sites.WednesdayClose,
        Sites.ThursdayOpen,
        Sites.ThursdayClose,
        Sites.FridayOpen,
        Sites.FridayClose,
        Sites.SaturdayOpen,
        Sites.SaturdayClose,
        Sites.SundayOpen,
        Sites.SundayClose,
        Sites.SiteCategory
from    Sites
        inner join GlobalCodes GC on Sites.SiteType = GC.GlobalCodeId
        left join Programs Pg on Sites.ProgramId = Pg.ProgramId
                                 and Pg.Active = 'Y'
                                 and isnull(Pg.RecordDeleted, 'N') <> 'Y'
        inner join Providers as p on p.ProviderId = Sites.ProviderId
                                     and isnull(p.RecordDeleted, 'N') <> 'Y'      
--left join SiteAddressess as SA on Sites.SiteId=SA.SiteId and isNull(SA.RecordDeleted,'N')<>'Y'
where   Sites.ProviderId = @ProviderId
        and isnull(Sites.RecordDeleted, 'N') <> 'Y'
order by Sites.SiteName
  
--Checking For Errors  
if (@@error != 0)
  begin
    raiserror('ssp_ProviderInformation  : An Error Occured', 16, 1)
    return
  end                                     
  
-- fetching data of SitesAddresses   
select  sa.SiteAddressId,
        sa.SiteId,
        sa.AddressType,
        sa.Address,
        sa.City,
        sa.State,
        sa.Zip,
        sa.Display,
        sa.Billing,
        sa.For1099,
        sa.RowIdentifier,
        sa.CreatedBy,
        sa.CreatedDate,
        sa.ModifiedBy,
        sa.ModifiedDate,
        sa.RecordDeleted,
        sa.DeletedDate,
        sa.DeletedBy,
        GC.SortOrder  
--case when sa.AddressType=@OfficeAddressType then 1 when sa.AddressType=@HomeAddressType then 2  when sa.AddressType=@TempAddressType then 3 else GC.GlobalCodeID end as SortOrder  
from    SiteAddressess as sa
        inner join Sites as s on sa.SiteId = s.SiteId
        inner join Providers as p on s.ProviderId = p.ProviderId
        left outer join GlobalCodes GC on sa.AddressType = GC.GlobalCodeId
where   p.ProviderId = @ProviderId
        and isnull(sa.RecordDeleted, 'N') <> 'Y'
        and isnull(s.RecordDeleted, 'N') <> 'Y'
        and isnull(p.RecordDeleted, 'N') <> 'Y'
order by sa.SiteId,
        GC.SortOrder  
  
--Checking For Errors  
if (@@error != 0)
  begin
    raiserror('ssp_ProviderInformation  : An Error Occured', 16, 1)
    return
  end                                     
  
-- fetching data of SitesPhones  
select  sp.SitePhoneId,
        sp.SiteId,
        sp.PhoneType,
        sp.PhoneNumber,
        sp.PhoneNumberText,
        sp.RowIdentifier,
        sp.CreatedBy,
        sp.CreatedDate,
        sp.ModifiedBy,
        sp.ModifiedDate,
        sp.RecordDeleted,
        sp.DeletedDate,
        sp.DeletedBy,
        GC.SortOrder  
--case when sp.PhoneType=@BusinessPhoneType then 1 when sp.PhoneType=@FaxPhoneType then 2 when sp.PhoneType=@HomePhoneType then 3  
--when sp.PhoneType=@Home2PhoneType then 4 when sp.PhoneType=@Business2PhoneType then 5 when sp.PhoneType=@MobilePhoneType then 6  
--when sp.PhoneType=@Mobile2PhoneType then 7 when sp.PhoneType=@SchoolPhoneType then 8 when sp.PhoneType=@OtherPhoneType then 9 else null end as SortOrder  
from    SitePhones sp
        inner join Sites as s on s.SiteId = sp.SiteId
        inner join Providers as p on s.ProviderId = p.ProviderId
        left outer join GlobalCodes GC on sp.PhoneType = GC.GlobalCodeId
where   p.ProviderId = @ProviderId
        and isnull(sp.RecordDeleted, 'N') <> 'Y'
        and isnull(s.RecordDeleted, 'N') <> 'Y'
        and isnull(p.RecordDeleted, 'N') <> 'Y'
order by sp.SiteId,
        GC.SortOrder  
  
--Checking For Errors  
if (@@error != 0)
  begin
    raiserror('ssp_ProviderInformation  : An Error Occured', 16, 1)
    return
  end                                     
  
-- fetching data for Sites associated with ProviderContacts  
--Changed By Bhupinder Bajwa as on 17/01/2006  
select  pcs.ProviderContactSiteId,
        pcs.SiteId,
        pcs.ProviderContactId,
        pcs.CreatedBy,
        pcs.CreatedDate,
        pcs.ModifiedBy,
        pcs.ModifiedDate,
        pcs.RecordDeleted,
        pcs.DeletedDate,
        pcs.DeletedBy
from    ProviderContactSites pcs,
        ProviderContacts pc
where   pc.ProviderContactId = pcs.ProviderContactId
        and pc.ProviderId = @ProviderId
        and isnull(pc.RecordDeleted, 'N') <> 'Y'
        and isnull(pcs.RecordDeleted, 'N') <> 'Y'  
  
--Checking For Errors  
if (@@error != 0)
  begin
    raiserror('ssp_ProviderInformation  : An Error Occured', 16, 1)
    return
  end                                     
  
-- fetching data of ProviderContacts associated with the Sites for displaying in the grid of Site control used in Provider Information screen.   
select  PC.ProviderId,
        PCS.SiteId,
        rtrim(isnull(PC.LastName, '')) + ', ' + rtrim(isnull(PC.FirstName, '')) as ProviderContactName,
        PC.WorkPhone,
        isnull(GC.CodeName, '') as CodeName,
        PC.ProviderContactId,
        PC.RecordDeleted
from    ProviderContactSites PCS
        inner join dbo.ProviderContacts PC on PCS.ProviderContactId = PC.ProviderContactId
        left outer join dbo.GlobalCodes GC on GC.GlobalCodeId = PC.ContactType
                                              and isnull(GC.RecordDeleted, 'N') = 'N'
where   PC.ProviderId = @ProviderId
        and isnull(PC.RecordDeleted, 'N') = 'N'
        and isnull(PCS.RecordDeleted, 'N') = 'N'
order by 3  
  
--Checking For Errors  
if (@@error != 0)
  begin
    raiserror('ssp_ProviderInformation  : An Error Occured', 16, 1)
    return
  end                                     
  
-- this is used to fill the site gird on sites tab in provider information  
--Changed by Bhupinder Bajwa as on 28/01/2006  
  

  
--Checking For Errors  
if (@@error != 0)
  begin
    raiserror('ssp_ProviderInformation  : An Error Occured', 16, 1)
    return
  end                                     
  
-- fetching list of affiliated providers for this provider  
-- Changed By Bhupinder Bajwa as on 16/01/2006  
select  PA.ProviderAffiliateId,
        PA.ProviderId,
        PA.AffiliateProviderId,
        PA.CreatedBy,
        PA.CreatedDate,
        PA.ModifiedBy,
        PA.ModifiedDate,
        PA.RecordDeleted,
        PA.DeletedDate,
        PA.DeletedBy,
        P.ProviderName
from    ProviderAffiliates PA
        inner join Providers P on P.ProviderId = PA.AffiliateProviderId
where   isnull(PA.RecordDeleted, 'N') <> 'Y'
        and isnull(P.RecordDeleted, 'N') <> 'Y'
        and PA.ProviderId = @ProviderId  
		  
  
--Checking For Errors  
if (@@error != 0)
  begin
    raiserror('ssp_ProviderInformation  : An Error Occured', 16, 1)
    return
  end                                     
  
-- fetching list of associated insurers for this provider  
-- Changed By Bhupinder Bajwa as on 16/01/2006  
select  PIn.ProviderInsurerId,
        PIn.ProviderId,
        PIn.InsurerId,
        PIn.CreatedBy,
        PIn.CreatedDate,
        PIn.ModifiedBy,
        PIn.ModifiedDate,
        PIn.RecordDeleted,
        PIn.DeletedDate,
        PIn.DeletedBy,
        I.InsurerName
from    ProviderInsurers PIn
        inner join Insurers I on I.InsurerId = PIn.InsurerId
where   PIn.ProviderId = @ProviderId
        and isnull(PIn.RecordDeleted, 'N') <> 'Y'
        and isnull(I.RecordDeleted, 'N') <> 'Y'
  
--Checking For Errors  
if (@@error != 0)
  begin
    raiserror('ssp_ProviderInformation  : An Error Occured', 16, 1)
    return
  end                                     
  
-- Added By Bhupinder Bajwa for filling Associated Insurers datagrid on 13/1/2006  
  
select  i.InsurerId,
        i.InsurerName,
        (select pin.ProviderId
         from   ProviderInsurers pin
         where  pin.InsurerId = i.InsurerId
                and pin.ProviderId = @ProviderId
                and isnull(pin.RecordDeleted, 'N') <> 'Y') as ProviderId,
        i.RecordDeleted
from    Insurers i
where   i.Active = 'Y'
        and isnull(i.RecordDeleted, 'N') <> 'Y'
order by i.InsurerName  
  
--Checking For Errors  
if (@@error != 0)
  begin
    raiserror('ssp_ProviderInformation  : An Error Occured', 16, 1)
    return
  end                                     
  
-- Added By Bhupinder Bajwa for filling Affiliated Providers datagrid on 13/1/2006  

select  p.ProviderId,
        case when p.ProviderType = 'I' then isnull(p.ProviderName, '') + ', ' + isnull(p.FirstName, '')
             else isnull(p.ProviderName, '')
        end as ProviderName,
        p.RecordDeleted
from    Providers p
where   p.Active = 'Y'
        and isnull(p.RecordDeleted, 'N') <> 'Y'
        and p.ProviderId <> @ProviderId
        and p.ProviderId > 0
order by p.ProviderName  
  
--Checking For Errors  
if (@@error != 0)
  begin
    raiserror('ssp_ProviderInformation  : An Error Occured', 16, 1)
    return
  end                                     
  
  
-- Added by Bhupinder Bajwa on 22/02/2006 to store Contracts of selected provider with different Insurers  
select   distinct
        c.ProviderId,
        c.InsurerId,
        i.InsurerName
from    Contracts c
        inner join Insurers i on c.InsurerId = i.InsurerId
where   c.ProviderId = @ProviderId
        and c.Status = 'A'
        and isnull(c.RecordDeleted, 'N') = 'N'
        and isnull(i.RecordDeleted, 'N') = 'N'
order by c.InsurerId  
  
 --neethu--
 --allegan 1237--

--GlobalCodes                       
--select  GlobalCodeId,
--        Category,
--        CodeName,
--        Description,
--        Active,
--        CannotModifyNameOrDelete,
--        SortOrder,
--        ExternalCode1,
--        ExternalSource1,
--        ExternalCode2,
--        ExternalSource2,
--        Bitmap,
--        BitmapImage,
--        Color,
--        CreatedBy,
--        CreatedDate,
--        ModifiedBy,
--        ModifiedDate,
--        DeletedBy,
--        RecordDeleted,
--        DeletedDate
--from    GlobalCodes
--where   Category like '%ADDRESSTYPE%' 
        
--SiteCategories  
select  SC.SiteCategoryId,
        SC.CreatedBy,
        SC.CreatedDate,
        SC.ModifiedBy,
        SC.ModifiedDate,
        SC.RecordDeleted,
        SC.DeletedBy,
        SC.DeletedDate,
        SC.SiteId,
        SC.CategoryId
from    SiteCategories SC
        left join Sites S on S.SiteId = SC.SiteId
where   S.ProviderId = @ProviderId
        and isnull(SC.RecordDeleted, 'N') = 'N'
        and isnull(S.RecordDeleted, 'N') = 'N'
	
	
--Checking For Errors  
if (@@error != 0)
  begin
    raiserror('ssp_ProviderInformation  : An Error Occured', 16, 1)
    return
  end  


go
