IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_DetailPageCMUpdatePrimarySiteProvdierInformation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_DetailPageCMUpdatePrimarySiteProvdierInformation]
GO
CREATE PROCEDURE  [dbo].[ssp_DetailPageCMUpdatePrimarySiteProvdierInformation]                
(                                                      
@ProviderID INT,
@PrimarySiteID INT ,
@UserCode varchar(30)                                                          
)                                                                              
As  
---------------------------------------------
--Author :Shruthi.S
--Date   :22/08/2014
--Purpose:To update PrimarySiteId in Providers table.Ref #20 CM to SC.
--Updates:
/* Hemanth    Task # 530 Customization Bugs 
              What:Modified logic for For1099 column.   
*/ 
----------------------------------------------

IF EXISTS(select providerid from Providers where ProviderId=@ProviderID)
BEGIN
UPDATE Providers SET PrimarySiteId=@PrimarySiteID,ModifiedBy=@UserCode,ModifiedDate=GETDATE() WHERE ProviderId=@ProviderID  
END

-- fetching data from Providers table  
Select P.ProviderId,P.ProviderType,P.Active,P.NonNetwork,P.DataEntryComplete,P.ProviderName,P.FirstName,P.ExternalId,P.Website,P.Comment,P.PrimarySiteId,P.PrimaryContactId,  
P.ContractingContactId,P.ApplyTaxIDToAllSites,P.ProviderIdAppliesToAllSites,P.POSAppliesToAllSites,P.TaxonomyAppliesToAllSites,P.NPIAppliesToAllSites,P.DataEntryCompleteForAuthorization,  
P.UsesProviderAccess,P.SubstanceUseProvider,P.AccessAgency,P.CredentialApproachingExpiration,P.RowIdentifier,P.CreatedBy,P.CreatedDate,P.ModifiedBy,P.ModifiedDate,P.RecordDeleted,  
P.DeletedDate,P.DeletedBy,S.SiteName from Providers P
left join sites S on P.PrimarySiteId=S.SiteId and IsNull(S.RecordDeleted,'N')<>'Y'    
  where  P.ProviderId =@ProviderId and IsNull(P.RecordDeleted,'N')<>'Y'
  
  -- fetching data of ProviderContacts for Contacts tab on Provider Information screen  
--Changed by Bhupinder Bajwa  
Select  
pc.ProviderContactId,
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
case when p.PrimaryContactId=pc.ProviderContactId then 'Yes' else 'No' end as 'Primary',    
case when p.ContractingContactId=pc.ProviderContactId then 'Yes' else 'No' end  as 'Contracting', 
case when p.PrimaryContactId=pc.ProviderContactId then 'Y' else 'N' end as 'PrimaryContact',    
case when p.ContractingContactId=pc.ProviderContactId then 'Y' else 'N' end  as 'ContractingContact',
gc.CodeName as TypeName  
from ProviderContacts as pc    
inner join Providers as p on p.ProviderId=pc.ProviderId and isNull(p.RecordDeleted,'N')<>'Y'    
left outer join GlobalCodes gc on pc.ContactType=gc.GlobalCodeId and IsNull(gc.RecordDeleted,'N') <> 'Y'    
where   pc.ProviderId = @ProviderId and isNull(pc.RecordDeleted,'N')<>'Y' 

-- fetching data of Sites associated with this provider for Sites tab, Providers & Contacts tab on Provider Information screen   
Select  
    
Sites.SiteId, 
Sites.ProviderId,
Sites.SiteName,
Sites.Active,
Sites.SiteType,
GC.CodeName AS SiteTypeName,
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
--SA.For1099,
isnull((select top 1 SA.For1099 from SiteAddressess as SA where Sites.SiteId=SA.SiteId and isNull(SA.RecordDeleted,'N')<>'Y' order by sa.ModifiedDate desc),'N') as For1099,
--End
case when p.PrimarySiteId=sites.SiteId then 'Y' else 'N' end as 'PrimarySite',
case when p.PrimarySiteId=sites.SiteId then 'Yes' else 'No' end as 'Primary'
from Sites    
inner join GlobalCodes GC on Sites.SiteType=GC.GlobalCodeId  
inner join Providers as p on p.ProviderId=Sites.ProviderId and isNull(p.RecordDeleted,'N')<>'Y'      
--left join SiteAddressess as SA on Sites.SiteId=SA.SiteId and isNull(SA.RecordDeleted,'N')<>'Y'
where Sites.ProviderId= @ProviderId    
and IsNull(Sites.RecordDeleted,'N')<>'Y' order by Sites.SiteName    
  

--Checking For Errors  
If (@@error!=0)  Begin  RAISERROR  20006 'ssp_DetailPageCMUpdatePrimarySiteProvdierInformation  : An Error Occured'   Return  End  
Go