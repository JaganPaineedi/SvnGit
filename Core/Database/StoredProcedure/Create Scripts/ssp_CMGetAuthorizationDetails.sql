if object_id('dbo.ssp_CMGetAuthorizationDetails') is not null
  drop procedure dbo.ssp_CMGetAuthorizationDetails 
go 

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure dbo.ssp_CMGetAuthorizationDetails
  @ProviderAuthorizationDocumentId int,
  @ClientId int,
  @AccessStaffId int,
  @ProviderAuthorizationIds varchar(max)
/********************************************************************************
-- Stored Procedure: dbo.[ssp_CMGetAuthorizationDetails]       
--                                                                                                               
-- Copyright: Streamline Healthcate Solutions                                                                                                               
--                                                                                                               
-- Purpose:  To fecth the data for the detail page CM Authorization                    
--         
-- Author: Malathi Shiva     
--       
-- Date: July 01 2014     
--                                                                                                             
-- Updates:              
-- Date        Author      Purpose      
-- Modified by SuryaBalan-30-Oct-2014 Task #68 Project:Care Management to SmartCare Env. Issues Tracking. 
-- Fixed Error on Save due to Duplicates records in ProviderAuthorizations Table
-- Modified Shruthi.S         To get the LCM Review level.Ref #127 CM to SC.
-- Modified Shruthi.S         Added billingcode and billingcodemodifierid check based on status.Ref #181 Care Management to SmartCare Env. Issues Tracking.
-- Modified Shruthi.S         Added proxy logic for documentation tab.#15.06 Env Issues.
-- Modified Shruthi.S         Added record deleted check while pulling values in dropdowns of History and Services tab.Ref : No task.
-- Modified Arjun K R         Added scsp to retrieve authorization event questions. Task #604 Network 180 Customization. 
-- 21 Oct 2015	Revathi	  what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  
--									why:task #609, Network180 Customization  
-- 28-10-2015  Manikandan R M      Added InterventionEndDate For ProviderAuthorizations. Task #669 Network 180 Customization. 
-- 19 Nov 2015 Arjun K R      Changes made for task #604 are reverted. Task #604 Network180 Customizations.
-- 9th Aug 2016 shivanand   changes made for task #342 Network 180 Environment Issues Tracking
-- 22-Sep-2016  Anto        Added a new column Assigned population in Authorizations table  KCMHSAS - Support #542
-- 29-Sep-2016 Himmat       Modified join condition as per   SWMBHA - Support #1074
-- 17-Oct-2016 Mani		Reverted 925 - Network 180 Environment Issues Tracking Change Why:Task # 929 Network 180 Environment Issues Tracking
-- 21-Dec-2016 Shivanand   changes made for task #1065 Network180 Support Go Live
-- 11-Jan-2017 Shivanand   What: selecting 'UnitTypeText', 'TextUnits'temp Columns for task #1018 Network180 Support Go Live.
-- 2-Feb-2017 Varun   What: Added InterventionEndDate Column to ProviderAuthorizationDocuments for task #1035 Network180 Support Go Live.
-- 05.16.2017 SFarber Removed some code related to TP to improve performance.
-- 14.07.2017 Lakshmi	What: unit field populated multiple times
						Why:  The Arc - Support Go Live #177
--29-Aug-2017 SuryaBalan In Services/Claims tab the dropdowns are displaying records which are having same billingcodeid because it is join with Modifiers.
                         Now I have made join with BillingCode and displaying Billing Codename with SiteName for KCMHSAS - Support #900.61
--24-NOV-2017   Akwinass    Added missing columns for ImageRecords table (Task #589 in Engineering Improvement Initiatives- NBL(I))
--01-Feb-2018   Arjun K R   Checking null for site id in select statement. If its null return 0. Task #3 SWMBH Ehancement.
--20-Sep-2018   k.Soujanya  What:Added logic to get EventId and DocumentId.Why:Partner Solutions - Enhancements #1
*********************************************************************************/
as
begin try 

  declare @str varchar(max)  
        
  create table #ProviderAuthorizationIds (ProviderAuthorizationId int)      
                
  set @str = @ProviderAuthorizationIds    
 
  insert  into #ProviderAuthorizationIds
          (ProviderAuthorizationId)
  (select Token
   from   dbo.SplitString(@str, ','))   
 
  declare @OrganizationName as nvarchar(100) 
  declare @StaffID as int 
  declare @SystemAdministrator as varchar(5) 
  declare @DocumentVersionId as int 
  declare @HideCustomAuthorizationControls char(1) 
  declare @PIHPUMID as int 

  select  @PIHPUMID = GlobalCodeId
  from    GlobalCodes
  where   Category like 'AUTHORIZATIONSTATUS'
          and CodeName like 'PIHP UM Determination' 

  set @HideCustomAuthorizationControls = 'N' 

  set @SystemAdministrator = (select  SystemAdministrator
                              from    Staff
                              where   StaffId = @AccessStaffId) 

  select top 1
          @OrganizationName = OrganizationName
  from    SystemConfigurations 

  declare @Today date

  set @Today = getdate()

  declare @EffectiveDate as date 

  select top 1
          @EffectiveDate = a.EffectiveDate
  from    Documents a
  where   a.ClientId = @ClientId
          and a.EffectiveDate <= convert(datetime, convert(varchar, getdate(), 101))
          and a.Status = 22
          and a.DocumentCodeId = 350
          and isnull(a.RecordDeleted, 'N') <> 'Y'
  order by a.EffectiveDate desc,
          ModifiedDate desc 

  -- FILLS ProviderAuthorizationDocuments    
  select top 1
          pad.ProviderAuthorizationDocumentId,
          null as DocumentCodeId,
          null as DocumentId,
          pad.Assigned,
          pad.StaffId,
          pad.RequestorComment,
          pad.ReviewerComment,
          pad.CreatedBy,
          pad.CreatedDate,
          pad.ModifiedBy,
          pad.ModifiedDate,
          pad.InsurerId,
          pad.ClientId,
          pad.EventId,
          pad.AuthorizationDocumentId,
          pad.StaffId,
          pad.DocumentName,
          pad.RequestorProgram,
          pad.RequestorDocumentId,
          pad.RequestorName,
          pad.RequestorId,
          pad.RequestDate,
          pad.LastReviewedBy,
          pad.LastReviewedOn,
          pad.Assigned,
          '' as EventType,
          null as CurrentDocumentVersionId,
          null as ServiceId,
          null as GroupServiceId,
          null as Status,
          null as AuthorID,
          CL.LOCName as LOC,
          CLC.LOCCategoryName as Population,
          isnull(@SystemAdministrator, 'N') as SystemAdministrator,
          pad.AssignedPopulation,
          pad.ImageRecordId,
          pad.InterventionEndDate,
          case when isnull(c.ClientType, 'I') = 'I' then c.LastName + ', ' + c.FirstName
               else c.OrganizationName
          end as ClientName,
          null as DocumentName,
          (s.LastName + ', ' + s.FirstName) as Requestor,
          pad.RequestorName as Requester,
          @OrganizationName as OrgranizationName,
          null as TxStartDate,
          null as TxExpireDate
  from    dbo.ProviderAuthorizationDocuments as pad
          left outer join dbo.ProviderAuthorizations as ads on ads.ProviderAuthorizationDocumentId = pad.ProviderAuthorizationDocumentId
          left outer join dbo.Clients as c on pad.ClientId = c.ClientId
          left outer join dbo.Staff as s on s.StaffId = pad.StaffId
          left outer join dbo.GlobalCodes as gcodes on gcodes.GlobalCodeId = pad.Assigned
          left outer join (select cc.ClientId,
                                  cc.LOCId,
                                  cc.ClientLOCId
                           from   dbo.CustomClientLOCs cc
                           where  ClientId = @ClientId
                                  and LOCStartDate <= @Today
                                  and (LOCEndDate is null
                                       or LOCEndDate > @Today)
                                  and isnull(RecordDeleted, 'N') = 'N') as CCL on CCL.ClientId = c.ClientId
          left outer join dbo.CustomLOCs as CL on CL.LOCId = CCL.LOCId
          left outer join dbo.CustomLOCCategories as CLC on CLC.LOCCategoryId = CL.LOCCategoryId
  where   pad.ProviderAuthorizationDocumentId = @ProviderAuthorizationDocumentId
          and isnull(pad.RecordDeleted, 'N') = 'N'
          and not exists ( select 1
                           from   CustomClientLOCs ccl2
                           where  ccl2.ClientId = CCL.ClientId
                                  and ccl2.ClientLOCId > CCL.ClientLOCId
                                  and (ccl2.LOCEndDate is null
                                       or ccl2.LOCEndDate > @Today)
                                  and ccl2.LOCStartDate <= @Today
                                  and isnull(ccl2.RecordDeleted, 'N') = 'N' )  

  -- FILLS ProviderAuthorizations    
  select  PA.ProviderAuthorizationId,
          PA.ProviderAuthorizationDocumentId,
          AC.Description as BillingCodeModifierIdText,
          AC.Description as RequestedBillingCodeModifierIdText,
          PA.BillingCodeModifierId,
          PA.RequestedBillingCodeModifierId,
          PA.RequestedBillingCodeId,
          PA.InsurerId,
          PA.ClientId,
          PA.BillingCodeId,
          GCUnitype.CodeName as UnitTypeText,
          UnitsApproved as TextUnits,
          PA.AuthorizationNumber,
          PA.CreatedBy,
          PA.CreatedDate,
          AuthorizationProviderBillingCodeId,
          PA.Modifier1,
          PA.Modifier2,
          PA.Modifier3,
          PA.Modifier4,
          PA.StartDate,
          PA.StartDateRequested,
          PA.DeletedBy,
          PA.DeletedDate,
          PA.EndDate,
          PA.Active,
          PA.Reason,
          PA.EndDateRequested,
          PA.FrequencyTypeRequested,
          PA.FrequencyTypeApproved,
          PA.ModifiedBy,
          PA.ModifiedDate,
          PA.RecordDeleted,
          PA.DeletedDate,
          PA.DeletedBy,
          DeniedDate,
          Modified,
          PA.ProviderId,
          PA.RecordDeleted,
          PA.ReviewLevel,
          PA.Comment,
          PA.SiteId,
          PA.InterventionEndDate,
          PA.Status,
          convert(decimal(10, 0), PA.TotalUnitsApproved) as TotalUnitsApproved,
          convert(decimal(10, 0), PA.TotalUnitsRequested) as TotalUnitsRequested,
          PA.UnitsApproved,
          PA.UnitsRequested,
          PA.UnitsRequested as UnitRequested,
          PA.UnitsUsed,
          PA.Urgent,
          GC.CodeName as FrequencyText,
          GCRequested.CodeName as FrequencyRequestedText,
          GCStatus.CodeName as StatusText,
          cast(P.ProviderId as varchar(10)) + '_' + isnull(cast(S.SiteId as varchar(10)),'0') as ProviderIdSiteId, --01-Feb-2018   Arjun K R 
          GCRL.CodeName as ReviewerLevel,
          dbo.GetBillingCodeButtonStatus(PA.BillingCodeId, S.SiteId) as BillingCodeButtonStatus,
          'N' as ReviewerAdded,
          PA.Status as OldStatus,
          '' as DeleteButton,
          'N' as RadioButton,
          case isnull(P.ProviderName, 'N')
            when 'N' then ''
            else P.ProviderName
          end + case isnull(S.SiteName, 'N')
                  when 'N' then ''
                  else '-' + S.SiteName
                end + case isnull(PA.ProviderId, '0')
                        when '0' then AG.AgencyName
                        else ''
                      end as SiteIdText,
          substring((select ',' + cast(ReasonId as varchar)
                     from   AuthorizationReasons
                     where  ProviderAuthorizationId = PA.ProviderAuthorizationId
                            and isnull(RecordDeleted, 'N') = 'N'
                    for
                     xml path('')), 2, 8000) as ReasonGlobalCodeIds,
          case when PA.ReviewLevel = 8726 then '[' + GCRL.CodeName + '] - [' + convert(varchar, dateadd(day, 30, PA.StartDateRequested), 101) + ']'
               when PA.ReviewLevel = 8727 then '[' + GCRL.CodeName + '] - [' + convert(varchar, dateadd(day, 14, PA.StartDateRequested), 101) + ']'
               when PA.ReviewLevel = 8728 then '[' + GCRL.CodeName + '] - [' + convert(varchar, dateadd(day, 3, PA.StartDateRequested), 101) + ']'
               when PA.ReviewLevel = 8738 then '[' + GCRL.CodeName + '] - [' + convert(varchar, dateadd(day, 3, PA.StartDateRequested), 101) + ']'
               else ''
          end as ReviewTypeDueDate,
          PA.AssignedPopulation
  from    ProviderAuthorizations PA
          left join Agency AG on AG.ProviderId = PA.ProviderId
          left join Providers as P on PA.ProviderId = P.ProviderId
          left join Sites as S on S.SiteId = PA.SiteId
          left join BillingCodeModifiers as AC on AC.BillingCodeModifierId = case when PA.Status in (2041, 2042, 2043, 2044, 2045, 2046, 2047, 2048, 2049) then PA.BillingCodeModifierId
                                                                                  else PA.RequestedBillingCodeModifierId
                                                                             end
                                                  and AC.BillingCodeId = case when PA.Status in (2041, 2042, 2043, 2044, 2045, 2046, 2047, 2048, 2049) then PA.BillingCodeId
                                                                              else PA.RequestedBillingCodeId
                                                                         end
          left join GlobalCodes as GC on GC.GlobalCodeId = PA.FrequencyTypeApproved
          left join GlobalCodes as GCRequested on GCRequested.GlobalCodeId = PA.FrequencyTypeRequested
          left join GlobalCodes as GCStatus on GCStatus.GlobalCodeId = PA.Status
          left join GlobalCodes as GCRL on GCRL.GlobalCodeId = PA.ReviewLevel
          left join BillingCodes BCC on BCC.BillingCodeId = PA.BillingCodeId
          left join GlobalCodes as GCUnitype on GCUnitype.GlobalCodeId = BCC.UnitType
  where   PA.ProviderAuthorizationDocumentId = @ProviderAuthorizationDocumentId
          and isnull(PA.RecordDeleted, 'N') = 'N'
  order by PA.ProviderAuthorizationId 
 


  declare @UMCodeId int 
  declare @ProviderAuthorizationId int 
  declare @AuthorizationCodeId int 
  declare @TotalUnitsRequested decimal 

  select top 1
          @ProviderAuthorizationId = ath.AuthorizationId,
          @AuthorizationCodeId = ath.AuthorizationCodeId,
          @TotalUnitsRequested = convert(numeric(18, 2), isnull(ath.TotalUnitsRequested, 0)),
          @UMCodeId = cUMACodes.UMCodeId
  from    dbo.ProviderAuthorizationDocuments as ad
          inner join dbo.Authorizations as ath on ath.AuthorizationDocumentId = ad.AuthorizationDocumentId
          inner join dbo.CustomUMCodeAuthorizationCodes as cUMACodes on cUMACodes.AuthorizationCodeId = ath.AuthorizationCodeId
  where   ath.AuthorizationDocumentId = @ProviderAuthorizationDocumentId
          and ad.ClientId = @ClientId
          and isnull(ath.RecordDeleted, 'N') = 'N'
          and isnull(ad.RecordDeleted, 'N') = 'N' 

  select distinct
          CUC.UMCodeId,
          CUC.CodeName as CodeName,
          GC.CodeName as ServiceCategory,
          convert(numeric(18, 2), clocUCodes.LCM12MonthUnitCap) as LCM12MonthUnitCap,
          convert(numeric(18, 2), clocUCodes.CCM12MonthUnitCao) as CCM12MonthUnitCao,
          convert(numeric(18, 2), isnull(ath.TotalUnitsRequested, 0)) as RequestedYTD,
          ACBC.AuthorizationCodeId,
          ath.ProviderAuthorizationId,
          cch.StartDate,
          cch.COBOrder
  from    dbo.ProviderAuthorizationDocuments as ad
          inner join dbo.ProviderAuthorizations as ath on ath.ProviderAuthorizationDocumentId = ad.ProviderAuthorizationDocumentId
          inner join dbo.AuthorizationCodeBillingCodes as ACBC on ACBC.BillingCodeId = ath.BillingCodeId
          inner join dbo.CustomUMCodeAuthorizationCodes as cUMACodes on cUMACodes.AuthorizationCodeId = ACBC.AuthorizationCodeId
          inner join dbo.CustomLOCUMCodes as clocUCodes on clocUCodes.UMCodeId = cUMACodes.UMCodeId
          inner join dbo.CustomUMCodes as CUC on CUC.UMCodeId = clocUCodes.UMCodeId
          inner join dbo.GlobalCodes as GC on GC.GlobalCodeId = clocUCodes.ServiceCategory
          inner join dbo.CustomClientLOCs ccl on clocUCodes.LOCId = ccl.LOCId
          inner join ClientCoveragePlans ccp on ccp.CoveragePlanId = clocUCodes.CoveragePlanId
          join dbo.ClientCoverageHistory cch on cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
                                                and isnull(cch.RecordDeleted, 'N') <> 'Y'
  where   ath.ProviderAuthorizationDocumentId = @ProviderAuthorizationDocumentId
          and ccl.ClientId = @ClientId
          and isnull(ath.RecordDeleted, 'N') = 'N'
          and isnull(clocUCodes.RecordDeleted, 'N') = 'N'
          and isnull(ccl.RecordDeleted, 'N') = 'N'
          and (ccl.LOCEndDate is null
               or ccl.LOCEndDate > @Today)
          and (ccl.LOCStartDate <= @Today
               or ccl.LOCStartDate is null)
          and cch.StartDate <= @Today
          and (cch.EndDate is null
               or cch.EndDate > @Today)
          and not exists ( select 1
                           from   CustomClientLOCs ccl2
                           where  ccl2.ClientId = ccl.ClientId
                                  and ccl2.ClientLOCId > ccl.ClientLOCId
                                  and (ccl2.LOCEndDate is null
                                       or ccl2.LOCEndDate > @Today)
                                  and ccl2.LOCStartDate <= @Today
                                  and isnull(ccl2.RecordDeleted, 'N') = 'N' )
          and isnull(ccp.RecordDeleted, 'N') = 'N'
          and ccp.ClientId = @ClientId
  order by ath.ProviderAuthorizationId,
          cch.StartDate,
          cch.COBOrder 


  -- Get data for dropdown on TP Service Tabs and History Tabs                                                                                  
  -- FOR Service TAB  
 select  A.ProviderAuthorizationId,
          null as TPProcedureId,
          A.BillingCodeId,
          A.ProviderId,
          A.SiteId,
          BC.BillingCode as Description, --29-Aug-2017 SuryaBalan
          case when isnull(S.SiteName, 'N') = 'N' then (select  AgencyName
                                                        from    Agency)
               else S.SiteName
          end as SiteName,
          case when isnull(A.SiteId, '') = '' then 
          BC.BillingCode + ' : ' 
                               + ISNULL(A.Modifier1+' ', '') 
                               + ISNULL(A.Modifier2+' ', '') 
                               + ISNULL(A.Modifier3+' ', '') 
                               + ISNULL(A.Modifier4+' ', '')  --29-Aug-2017 SuryaBalan
          + ' - ' + (select AgencyName
                                                                           from   Agency)
               else 
              BC.BillingCode + ' : ' 
                               + ISNULL(A.Modifier1+' ', '') 
                               + ISNULL(A.Modifier2+' ', '') 
                               + ISNULL(A.Modifier3+' ', '') 
                               + ISNULL(A.Modifier4+' ', '')   --29-Aug-2017 SuryaBalan
               + ' - ' + S.SiteName
          end as BillingCodeSiteName
  from    ProviderAuthorizations A
          join BillingCodes BC on A.BillingCodeId = BC.BillingCodeId
          left outer join Sites S on S.SiteId = A.SiteId
  where   A.ProviderAuthorizationDocumentId = @ProviderAuthorizationDocumentId
          and isnull(A.RecordDeleted, 'N') = 'N' 

  -- Get All TPIntervention Procedures based on Authorization Document ID                                                                                   
  select  TIP.TPProcedureId,
          TIP.TPInterventionProcedureId,
          AD.AuthorizationDocumentId,
          TIP.InterventionText,
          TIP.InterventionNumber,
          TIP.AuthorizationCodeId,
          TIP.SiteId,
          TIP.RecordDeleted
  from    ProviderAuthorizationDocuments AD
          inner join Documents on Documents.DocumentId = AD.RequestorDocumentId
          inner join DocumentVersions on Documents.CurrentDocumentVersionId = DocumentVersions.DocumentVersionId
          inner join TPNeeds on TPNeeds.DocumentVersionId = DocumentVersions.DocumentVersionId
          inner join TPInterventionProcedures TIP on TPNeeds.NeedId = TIP.NeedId
  where   AD.ProviderAuthorizationDocumentId = @ProviderAuthorizationDocumentId
          and isnull(AD.RecordDeleted, 'N') = 'N' 

  --Gets TPProcedureBillingCode                                                                         
  select  dbo.TPProcedureBillingCodes.TPProcedureBillingCodeId,
          dbo.TPProcedureBillingCodes.CreatedBy,
          dbo.TPProcedureBillingCodes.CreatedDate,
          dbo.TPProcedureBillingCodes.ModifiedBy,
          dbo.TPProcedureBillingCodes.ModifiedDate,
          dbo.TPProcedureBillingCodes.RecordDeleted,
          dbo.TPProcedureBillingCodes.DeletedDate,
          dbo.TPProcedureBillingCodes.DeletedBy,
          dbo.TPProcedureBillingCodes.TPProcedureId,
          dbo.TPProcedureBillingCodes.BillingCodeId,
          dbo.TPProcedureBillingCodes.Modifier1,
          dbo.TPProcedureBillingCodes.Modifier2,
          dbo.TPProcedureBillingCodes.Modifier3,
          dbo.TPProcedureBillingCodes.Modifier4,
          dbo.TPProcedureBillingCodes.Units,
          dbo.TPProcedureBillingCodes.SystemGenerated
  from    dbo.ProviderAuthorizations
          inner join ProviderAuthorizationDocuments on ProviderAuthorizationDocuments.ProviderAuthorizationDocumentId = ProviderAuthorizations.ProviderAuthorizationDocumentId
          inner join Documents on Documents.DocumentId = ProviderAuthorizationDocuments.RequestorDocumentId
          inner join DocumentVersions on Documents.CurrentDocumentVersionId = DocumentVersions.DocumentVersionId
          inner join dbo.TPProcedures on TPProcedures.DocumentVersionId = DocumentVersions.DocumentVersionId
          inner join dbo.TPProcedureBillingCodes on dbo.ProviderAuthorizations.BillingCodeId = dbo.TPProcedureBillingCodes.BillingCodeId
                                                    and TPProcedures.TPProcedureId = TPProcedureBillingCodes.TPProcedureId
  where   dbo.ProviderAuthorizations.ProviderAuthorizationDocumentId = @ProviderAuthorizationDocumentId
          and isnull(dbo.TPProcedureBillingCodes.RecordDeleted, 'N') = 'N'
          and isnull(TPProcedures.RecordDeleted, 'N') = 'N'
          and (dbo.ProviderAuthorizations.Status <> @PIHPUMID
               or @PIHPUMID is null)  
       
       
   --Gets AuthorizationProviderBilingCodes                                           
  select  dbo.AuthorizationProviderBilingCodes.AuthorizationProviderBilingCodeId,
          dbo.AuthorizationProviderBilingCodes.CreatedBy,
          dbo.AuthorizationProviderBilingCodes.CreatedDate,
          dbo.AuthorizationProviderBilingCodes.ModifiedBy,
          dbo.AuthorizationProviderBilingCodes.ModifiedDate,
          dbo.AuthorizationProviderBilingCodes.RecordDeleted,
          dbo.AuthorizationProviderBilingCodes.DeletedBy,
          dbo.AuthorizationProviderBilingCodes.DeletedDate,
          dbo.AuthorizationProviderBilingCodes.AuthorizationId,
          dbo.AuthorizationProviderBilingCodes.TPProcedureBillingCodeId,
          dbo.AuthorizationProviderBilingCodes.ProviderAuthorizationId,
          dbo.AuthorizationProviderBilingCodes.Modifier1,
          dbo.AuthorizationProviderBilingCodes.Modifier2,
          dbo.AuthorizationProviderBilingCodes.Modifier3,
          dbo.AuthorizationProviderBilingCodes.Modifier4,
          dbo.AuthorizationProviderBilingCodes.UnitsRequested,
          dbo.AuthorizationProviderBilingCodes.UnitsApproved
  from    dbo.ProviderAuthorizations
          inner join ProviderAuthorizationDocuments on ProviderAuthorizationDocuments.ProviderAuthorizationDocumentId = ProviderAuthorizations.ProviderAuthorizationDocumentId
          inner join Documents on Documents.DocumentId = ProviderAuthorizationDocuments.RequestorDocumentId
          inner join DocumentVersions on Documents.CurrentDocumentVersionId = DocumentVersions.DocumentVersionId
          inner join dbo.TPProcedures on TPProcedures.DocumentVersionId = DocumentVersions.DocumentVersionId
          inner join dbo.TPProcedureBillingCodes on dbo.ProviderAuthorizations.BillingCodeId = dbo.TPProcedureBillingCodes.BillingCodeId
                                                    and TPProcedures.TPProcedureId = TPProcedureBillingCodes.TPProcedureId
          inner join dbo.AuthorizationProviderBilingCodes on dbo.ProviderAuthorizations.ProviderAuthorizationId = dbo.AuthorizationProviderBilingCodes.ProviderAuthorizationId
                                                             and dbo.TPProcedureBillingCodes.TPProcedureBillingCodeId = dbo.AuthorizationProviderBilingCodes.TPProcedureBillingCodeId
  where   dbo.ProviderAuthorizations.ProviderAuthorizationDocumentId = @ProviderAuthorizationDocumentId
          and isnull(dbo.TPProcedureBillingCodes.RecordDeleted, 'N') = 'N'
          and isnull(dbo.AuthorizationProviderBilingCodes.RecordDeleted, 'N') = 'N'
          and isnull(TPProcedures.RecordDeleted, 'N') = 'N'

    --Get Staff Roles Based On StaffId Ref to task 276 in SC web phase II bugs/Features             
  select  StaffId,
          RoleId
  from    StaffRoles
  where   StaffId = @AccessStaffId
          and isnull(RecordDeleted, 'N') = 'N' 

  set @DocumentVersionId = null

  -- This is for assigned documentversionId for authorizationdocumentid w.r.f to task 372 in Sc web phase II bugs/Features                                                        
  exec ssp_SCGetPreviouslyRequestedUMCodeUnits @ClientId, @DocumentVersionId    
    
  select distinct
          ADOD.AuthorizationDocumentOtherDocumentId,
          ADOD.ProviderAuthorizationDocumentId,
          ADOD.DocumentId,
          d.CurrentDocumentVersionId as Version,
          d.DocumentCodeId,
          DV.DocumentVersionId,
          AD.ImageRecordId,
          ADOD.CreatedBy,
          ADOD.CreatedDate,
          ADOD.ModifiedBy,
          ADOD.ModifiedDate,
          ADOD.RecordDeleted,
          ADOD.DeletedBy,
          dc.DocumentName as DocumentName,
          '' as ProcedureName,
          convert(date, d.EffectiveDate, 101) as EffectiveDate,
          '' as DateOfService,
          gcs.CodeName as DocumentStatusName,
          '' as ServiceStatusName,
          (a.LastName + ', ' + a.FirstName) as DocumentAuthorName,
          '' as ServiceClinicianName,
          case when ADOD.DocumentId is not null then ADOD.DocumentId
          end as PrimaryId,
          case when dc.DocumentName is not null then dc.DocumentName
          end as Name,
          case when (a.LastName + ', ' + a.FirstName) is not null then (a.LastName + ', ' + a.FirstName)
          end as Staff,
          case when d.EffectiveDate is not null then convert(varchar, d.EffectiveDate, 101)
          end as Date,
          d.ClientId,
          case when ADOD.DocumentId is not null then 'true'
               else 'false'
          end as AddButtonEnabled,
          case when isnull(C.ClientType, 'I') = 'I' then isnull(C.LastName, '') + ',' + isnull(C.FirstName, '')
               else isnull(C.OrganizationName, '')
          end as ClientName,
          d.AuthorId as StaffId,
          d.EventId as EventId,
          S.ScreenId as ScreenId
  from    AuthorizationDocumentOtherDocuments as ADOD
          inner join ProviderAuthorizationDocuments as AD on ADOD.ProviderAuthorizationDocumentId = AD.ProviderAuthorizationDocumentId
          inner join Documents as d on d.DocumentId = ADOD.DocumentId
          inner join DocumentVersions DV on DV.DocumentId = d.DocumentId
                                            and DV.DocumentVersionId = d.CurrentDocumentVersionId
                                            and isnull(DV.RecordDeleted, 'N') = 'N'
          inner join DocumentCodes dc on dc.DocumentCodeId = d.DocumentCodeId
          inner join Screens S on S.DocumentCodeId = d.DocumentCodeId
                                  and isnull(S.RecordDeleted, 'N') = 'N'
          left join GlobalCodes gcs on gcs.GlobalCodeId = d.Status
          inner join Staff a on a.StaffId = d.AuthorId
          left join Clients C on d.ClientId = C.ClientId
  where   AD.ProviderAuthorizationDocumentId = @ProviderAuthorizationDocumentId
          and isnull(AD.RecordDeleted, 'N') = 'N'
          and isnull(AD.RecordDeleted, 'N') = 'N'
          and ADOD.DocumentId is not null
          and isnull(ADOD.RecordDeleted, 'N') = 'N'
  union
  select distinct
          ADOD.AuthorizationDocumentOtherDocumentId,
          ADOD.ProviderAuthorizationDocumentId,
          ADOD.DocumentId as ServiceDocumentId,
          null as Version,
          null,
          null,
          AD.ImageRecordId,
          ADOD.CreatedBy,
          ADOD.CreatedDate,
          ADOD.ModifiedBy,
          ADOD.ModifiedDate,
          ADOD.RecordDeleted,
          ADOD.DeletedBy,
          case when IRD.RecordDescription is not null then IRD.RecordDescription
          end as DocumentName,
          null as ProcedureName,
          '' as EffectiveDate,
          '' as DateOfService,
          case when IRD.ScannedOrUploaded = 'S' then 'Scanned'
               else 'Uploaded'
          end as DocumentStatusName,
          '' as ServiceStatusName,
          '' as DocumentAuthorName,
          (sf.LastName + ', ' + sf.FirstName) as ServiceClinicianName,
          case when AD.ImageRecordId is not null then AD.ImageRecordId
          end as PrimaryId,
          IRD.RecordDescription as Name,
          case when (sf.LastName + ', ' + sf.FirstName) is not null then (sf.LastName + ', ' + sf.FirstName)
          end as Staff,
          case when ADOD.ModifiedDate is not null then convert(varchar, ADOD.ModifiedDate, 101)
          end as Date,
          IRD.ClientId,
          'TRUE' as AddButtonEnabled  
             --Added by Revathi 21.Oct.2015
          ,
          case when isnull(C.ClientType, 'I') = 'I' then isnull(C.LastName, '') + ',' + isnull(C.FirstName, '')
               else isnull(C.OrganizationName, '')
          end as ClientName,
          sf.StaffId as StaffId,
          AD.EventId as EventId,
          S.ScreenId as ScreenId
  from    AuthorizationDocumentOtherDocuments as ADOD
          inner join ProviderAuthorizationDocuments as AD on ADOD.ProviderAuthorizationDocumentId = AD.ProviderAuthorizationDocumentId
          inner join Documents Doc on Doc.EventId = AD.EventId
                                      and isnull(Doc.RecordDeleted, 'N') = 'N'
          inner join Screens S on S.DocumentCodeId = Doc.DocumentCodeId
                                  and isnull(S.RecordDeleted, 'N') = 'N'
          left join ImageRecords as IRD on IRD.ImageRecordId = AD.ImageRecordId
          left join Staff as sf on sf.StaffId = IRD.ScannedBy
          left join Clients C on IRD.ClientId = C.ClientId
  where   ADOD.ProviderAuthorizationDocumentId = @ProviderAuthorizationDocumentId
          and isnull(AD.RecordDeleted, 'N') = 'N'
          and isnull(ADOD.RecordDeleted, 'N') = 'N'
          and AD.ImageRecordId is not null  
    
  select  ir.ImageRecordId,
          ir.CreatedBy,
          ir.CreatedDate,
          ir.ModifiedBy,
          ir.ModifiedDate,
          ir.RecordDeleted,
          ir.DeletedDate,
          ir.DeletedBy,
          ir.ScannedOrUploaded,
          ir.DocumentVersionId,
          ir.ImageServerId,
          ir.ClientId,
          ir.AssociatedId,
          ir.AssociatedWith,
          ir.RecordDescription,
          ir.EffectiveDate,
          ir.NumberOfItems,
          ir.AssociatedWithDocumentId,
          ir.AppealId,
          ir.StaffId,
          CASE 
			WHEN ir.DocumentVersionId IS NOT NULL -- K.Soujanya 20-Sep-2018  
				THEN ad.EventId 
			ELSE ir.EventId
			END AS EventId,
          ir.ProviderId,
          ir.TaskId,
          ir.ProviderAuthorizationDocumentId,
          ir.ScannedBy,
          ir.CoveragePlanId,
          ir.ClientDisclosureId,          
          ir.BatchId,
          ir.PaymentId,
          ir.ServiceId,
          d.DocumentId
  from    ImageRecords ir
          join ProviderAuthorizationDocuments AD on AD.ProviderAuthorizationDocumentId = ir.ProviderAuthorizationDocumentId
                 AND isnull(AD.RecordDeleted, 'N') = 'N' -- K.Soujanya 20-Sep-2018 Start
	      LEFT JOIN Documents AS d ON d.EventId = AD.EventId
		         AND isnull(d.RecordDeleted, 'N') = 'N'
		         AND d.DocumentCodeId = 1637
	      LEFT JOIN DocumentVersions DV ON DV.DocumentId = d.DocumentId
		  AND isnull(DV.RecordDeleted, 'N') = 'N'
	-- K.Soujanya 20-Sep-2018 End
  where   isnull(ir.RecordDeleted, 'N') <> 'Y'
          and AD.ProviderAuthorizationDocumentId = @ProviderAuthorizationDocumentId 

  --  Get "AuthorizationReasons" table   
  select  AR.ProviderAuthorizationReasonId,
          AR.ProviderAuthorizationId,
          AR.ReasonId,
          AR.CreatedBy,
          AR.CreatedDate,
          AR.ModifiedBy,
          AR.ModifiedDate,
          AR.RecordDeleted,
          AR.DeletedDate,
          AR.DeletedBy
  from    ProviderAuthorizationReasons AR
          inner join ProviderAuthorizations PA on AR.ProviderAuthorizationId = PA.ProviderAuthorizationId
  where   PA.ProviderAuthorizationDocumentId = @ProviderAuthorizationDocumentId
          and isnull(AR.RecordDeleted, 'N') = 'N'
          and isnull(PA.RecordDeleted, 'N') = 'N' 
           
     
     
     
end try 

begin catch 
  declare @Error varchar(8000) 

  set @Error = convert(varchar, error_number()) + '*****' + convert(varchar(4000), error_message()) + '*****' + isnull(convert(varchar, error_procedure()), 'ssp_CMGetAuthorizationDetails') + '*****' + convert(varchar, error_line()) + '*****' + convert(varchar, error_severity()) + '*****' + convert(varchar, error_state()) 

  raiserror ( @Error, 
                    -- Message text.                                                                                                          
                    16,-- Severity.                                 
                    1 
        -- State.                                                                        
        ); 
end catch 


go 
