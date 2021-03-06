/****** Object:  StoredProcedure [dbo].[csp_conv_Authorizations]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_Authorizations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_conv_Authorizations]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_Authorizations]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_conv_Authorizations]
as

declare @reseed int

select @reseed = max(AuthorizationCodeId) + 1 from AuthorizationCodes

DBCC CHECKIDENT (Cstm_Conv_Map_AuthorizationCodes, reseed, @reseed) WITH NO_INFOMSGS

if @@error <> 0 goto error

insert into Cstm_Conv_Map_AuthorizationCodes (
       proc_code,
       is_proc_group)
select distinct 
       pa.proc_code,
       pa.is_proc_group
  from Psych..Procedure_Authorization pa       
 order by pa.is_proc_group desc, pa.proc_code
          
if @@error <> 0 goto error

set identity_insert AuthorizationCodes on

if @@error <> 0 goto error

insert into AuthorizationCodes (
       AuthorizationCodeId
      ,AuthorizationCodeName
      ,DisplayAs
      ,Active
      ,Units
      ,UnitType
      ,ProcedureCodeGroupName
      ,BillingCodeGroupName
      ,ClinicianMustSpecifyBillingCode
      ,UMMustSpecifyBillingCode
      ,DefaultBillingCodeId
      ,DefaultModifier1
      ,DefaultModifier2
      ,DefaultModifier3
      ,DefaultModifier4
      ,CreatedBy
      ,CreatedDate
      ,ModifiedBy
      ,ModifiedDate)
select acm.AuthorizationCodeId
      ,left(isnull(isnull(isnull(pg.proc_group_desc, pg.proc_group_code), isnull(pc.proc_desc, pc.proc_code)), acm.proc_code) , 100) --AuthorizationCodeName
      ,isnull(isnull(pg.proc_group_code, pc.proc_code), acm.proc_code) --DisplayAs
      ,''Y'' --Active
      ,1 --Units
      ,124 --UnitType
      ,null --ProcedureCodeGroupName
      ,null --BillingCodeGroupName
      ,null --ClinicianMustSpecifyBillingCode
      ,null --UMMustSpecifyBillingCode
      ,null --DefaultBillingCodeId
      ,null --DefaultModifier1
      ,null --DefaultModifier2
      ,null --DefaultModifier3
      ,null --DefaultModifier4
      ,isnull(isnull(pg.user_id, pc.user_id), ''sa'') --CreatedBy
      ,isnull(isnull(pg.entry_chron, pc.entry_chron), getdate()) --CreatedDate
      ,isnull(isnull(pg.user_id, pc.user_id), ''sa'') --ModifiedBy
      ,isnull(isnull(pg.entry_chron, pc.entry_chron), getdate()) --ModifiedDate
  from Cstm_Conv_Map_AuthorizationCodes acm
       left join Psych..Procedure_Group pg on pg.proc_group_code = acm.proc_code and acm.is_proc_group = ''Y''
       left join Psych..Procedure_Code pc on pc.proc_code = acm.proc_code and acm.is_proc_group = ''N''
        
if @@error <> 0 goto error

set identity_insert AuthorizationCodes off

if @@error <> 0 goto error

insert into AuthorizationCodeProcedureCodes (
       AuthorizationCodeId
      ,ProcedureCodeId
      ,CreatedBy
      ,CreatedDate
      ,ModifiedBy
      ,ModifiedDate)
select acm.AuthorizationCodeId,
       pcm.ProcedureCodeId,
       ''sa'',
       getdate(),
       ''sa'',
       getdate()
  from Cstm_Conv_Map_AuthorizationCodes acm
       join Psych..Procedure_Group pg on pg.proc_group_code = acm.proc_code and acm.is_proc_group = ''Y''
       join Psych..Procedure_Relation pr on pr.proc_group_code = pg.proc_group_code
       join Cstm_Conv_Map_ProcedureCodes pcm on pcm.proc_code = pr.proc_code
union
select acm.AuthorizationCodeId,
       pcm.ProcedureCodeId,
       ''sa'',
       getdate(),
       ''sa'',
       getdate()
  from Cstm_Conv_Map_AuthorizationCodes acm
       join Psych..Procedure_Code pc on pc.proc_code = acm.proc_code and acm.is_proc_group = ''N''
       join Cstm_Conv_Map_ProcedureCodes pcm on pcm.proc_code = pc.proc_code
 order by 1, 2
 
if @@error <> 0 goto error

insert into cstm_conv_map_Authorizations(authorization_no)
select pa.authorization_no
  from Psych..Procedure_Authorization pa
 order by 1

if @@error <> 0 goto error

set identity_insert AuthorizationDocuments on

if @@error <> 0 goto error

insert into AuthorizationDocuments(
       AuthorizationDocumentId
      ,ClientCoveragePlanId
      ,DocumentId
      ,Assigned
      ,StaffId
      ,RequesterComment
      ,ReviewerComment
      ,ProviderAuthorizationDocumentId
      ,CreatedBy
      ,CreatedDate
      ,ModifiedBy
      ,ModifiedDate
      ,AssignedPopulation)
select am.AuthorizationId --AuthorizationDocumentId 
      ,null --ClientCoveragePlanId
      ,null --DocumentId
      ,null --Assigned
      ,sm.StaffId
      ,null --RequesterComment
      ,pa.comments --ReviewerComment
      ,null --ProviderAuthorizationDocumentId
      ,pa.orig_user_id --CreatedBy
      ,pa.orig_entry_chron --CreatedDate
      ,pa.user_id --ModifiedBy
      ,pa.entry_chron --ModifiedDate
      ,null --AssignedPopulation
  from cstm_conv_map_Authorizations am
       join Psych..Procedure_Authorization pa on pa.authorization_no = am.authorization_no
       left join Cstm_Conv_Map_Staff sm on sm.staff_id = pa.clinician_id

if @@error <> 0 goto error

set identity_insert AuthorizationDocuments off

if @@error <> 0 goto error

update ad
   set ClientCoveragePlanId = ccp.ClientCoveragePlanId
  from AuthorizationDocuments ad
       join cstm_conv_map_Authorizations am on am.AuthorizationId = ad.AuthorizationDocumentId
       join Psych..Procedure_Authorization pa on pa.authorization_no = am.authorization_no
       join Cstm_Conv_Map_CoveragePlans cpm on cpm.coverage_plan_id = pa.coverage_plan_id and cpm.hosp_status_code = pa.hosp_status_code
       join Cstm_Conv_Map_Clients cm on cm.patient_id = pa.patient_id
       join ClientCoveragePlans ccp on ccp.ClientId = cm.ClientId and ccp.CoveragePlanId = cpm.CoveragePlanId 
 where exists(select *
                from ClientCoverageHistory cch
               where cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
                 and cch.StartDate <= pa.orig_entry_date
                 and (dateadd(dd, 1, cch.EndDate) > pa.orig_entry_date or cch.EndDate is null))
                 
if @@error <> 0 goto error

update ad
   set ClientCoveragePlanId = ccp.ClientCoveragePlanId
  from AuthorizationDocuments ad
       join cstm_conv_map_Authorizations am on am.AuthorizationId = ad.AuthorizationDocumentId
       join Psych..Procedure_Authorization pa on pa.authorization_no = am.authorization_no
       join Cstm_Conv_Map_CoveragePlans cpm on cpm.coverage_plan_id = pa.coverage_plan_id and cpm.hosp_status_code = pa.hosp_status_code
       join Cstm_Conv_Map_Clients cm on cm.patient_id = pa.patient_id
       join ClientCoveragePlans ccp on ccp.ClientId = cm.ClientId and ccp.CoveragePlanId = cpm.CoveragePlanId 
 where ad.ClientCoveragePlanId is null
   and exists(select *
                from ClientCoverageHistory cch
               where cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
                 and cch.StartDate <= pa.expiration_date
                 and (dateadd(dd, 1, cch.EndDate) > pa.expiration_date or cch.EndDate is null))

if @@error <> 0 goto error

update ad
   set ClientCoveragePlanId = ccp.ClientCoveragePlanId
  from AuthorizationDocuments ad
       join cstm_conv_map_Authorizations am on am.AuthorizationId = ad.AuthorizationDocumentId
       join Psych..Procedure_Authorization pa on pa.authorization_no = am.authorization_no
       join Cstm_Conv_Map_CoveragePlans cpm on cpm.coverage_plan_id = pa.coverage_plan_id and cpm.hosp_status_code = pa.hosp_status_code
       join Cstm_Conv_Map_Clients cm on cm.patient_id = pa.patient_id
       join ClientCoveragePlans ccp on ccp.ClientId = cm.ClientId and ccp.CoveragePlanId = cpm.CoveragePlanId 
 where ad.ClientCoveragePlanId is null

if @@error <> 0 goto error

set identity_insert Authorizations on

if @@error <> 0 goto error

insert into Authorizations (
       AuthorizationId
      ,CreatedBy
      ,CreatedDate
      ,ModifiedBy
      ,ModifiedDate
      ,AuthorizationDocumentId
      ,AuthorizationNumber
      ,AuthorizationCodeId
      ,Status
      ,TPProcedureId
      ,Units
      ,Frequency
      ,StartDate
      ,EndDate
      ,TotalUnits
      ,StaffId
      ,UnitsRequested
      ,FrequencyRequested
      ,StartDateRequested
      ,EndDateRequested
      ,TotalUnitsRequested
      ,StaffIdRequested
      ,ProviderId
      ,SiteId
      ,DateRequested
      ,DateReceived
      ,UnitsUsed
      ,StartDateUsed
      ,EndDateUsed
      ,UnitsScheduled
      ,ProviderAuthorizationId
      ,Urgent
      ,ReviewLevel
      ,ReviewerId
      ,ReviewerOther
      ,ReviewedOn
      ,Rationale)
select am.AuthorizationId
      ,ad.CreatedBy
      ,ad.CreatedDate
      ,ad.ModifiedBy
      ,ad.ModifiedDate
      ,ad.AuthorizationDocumentId
      ,pa.referral_no --AuthorizationNumber
      ,acm.AuthorizationCodeId
      /*,case when pa.num_cap_pol > 0 or pa.num_cap_yr  > 0 or pa.num_cap_month > 0 or 
                 pa.num_cap_wk > 0 or pa.num_cap_day > 0 or pa.time_cap_pol > 0 or pa.amt_cap_pol > 0
            then 4243 -- Approved
			WHEN ( pa.num_cap_pol IS NULL 
				AND pa.num_cap_yr IS NULL
				AND pa.num_cap_month IS NULL 
				AND pa.num_cap_wk IS NULL 
				AND pa.num_cap_day IS NULL
				AND pa.time_cap_pol IS NULL
				AND pa.amt_cap_pol IS NULL )
			THEN 4243	
            else 4242 -- Requested
       end*/ 
       ,4243 --Status (Approved)
      ,null --TPProcedureId
      ,case when pa.num_cap_pol > 0 then pa.num_cap_pol
            when pa.num_cap_yr > 0 then pa.num_cap_yr
            when pa.num_cap_month > 0 then pa.num_cap_month
            when pa.num_cap_wk > 0 then pa.num_cap_wk
            when pa.num_cap_day > 0 then pa.num_cap_day
            when pa.time_cap_pol > 0 AND ISNULL(p.PayerType,0) <> 20479 then pa.time_cap_pol / 15
            when pa.time_cap_pol > 0 AND ISNULL(p.PayerType,0) = 20479 then pa.time_cap_pol
            when pa.amt_cap_pol > 0 then pa.amt_cap_pol * 100
            
            WHEN ( pa.num_cap_pol IS NULL 
				AND pa.num_cap_yr IS NULL
				AND pa.num_cap_month IS NULL 
				AND pa.num_cap_wk IS NULL 
				AND pa.num_cap_day IS NULL
				AND pa.time_cap_pol IS NULL
				AND pa.amt_cap_pol IS NULL )
			THEN 999999999	
            
            else 0
       end  --Units
      ,176 --Frequency
      ,pa.orig_entry_date --StartDate
      ,pa.expiration_date --EndDate
      ,case when pa.num_cap_pol > 0 then pa.num_cap_pol
            when pa.num_cap_yr > 0 then pa.num_cap_yr
            when pa.num_cap_month > 0 then pa.num_cap_month
            when pa.num_cap_wk > 0 then pa.num_cap_wk
            when pa.num_cap_day > 0 then pa.num_cap_day
            when pa.time_cap_pol > 0 AND ISNULL(p.PayerType,0) <> 20479 then pa.time_cap_pol / 15
            when pa.time_cap_pol > 0 AND ISNULL(p.PayerType,0) = 20479 then pa.time_cap_pol
            when pa.amt_cap_pol > 0 then pa.amt_cap_pol * 100

			WHEN ( pa.num_cap_pol IS NULL 
				AND pa.num_cap_yr IS NULL
				AND pa.num_cap_month IS NULL 
				AND pa.num_cap_wk IS NULL 
				AND pa.num_cap_day IS NULL
				AND pa.time_cap_pol IS NULL
				AND pa.amt_cap_pol IS NULL )
			THEN 999999999	
			
            else 0
       end --TotalUnits
      ,ad.StaffId
      /*
      ,case when pa.num_cap_requested > 0 then pa.num_cap_requested
            when pa.num_cap_pol > 0 then pa.num_cap_pol
            when pa.num_cap_yr > 0 then pa.num_cap_yr
            when pa.num_cap_month > 0 then pa.num_cap_month
            when pa.num_cap_wk > 0 then pa.num_cap_wk
            when pa.num_cap_day > 0 then pa.num_cap_day 
            when pa.time_cap_requested > 0 then pa.time_cap_requested / 15
            when pa.time_cap_pol > 0 then pa.time_cap_pol / 15 
            else 0
       end  --UnitsRequested
      ,null --FrequencyRequested
      ,pa.orig_entry_date --StartDateRequested
      ,pa.expiration_date --EndDateRequested
      ,case when pa.num_cap_requested > 0 then pa.num_cap_requested
            when pa.num_cap_pol > 0 then pa.num_cap_pol
            when pa.num_cap_yr > 0 then pa.num_cap_yr
            when pa.num_cap_month > 0 then pa.num_cap_month
            when pa.num_cap_wk > 0 then pa.num_cap_wk
            when pa.num_cap_day > 0 then pa.num_cap_day 
            when pa.time_cap_requested > 0 then pa.time_cap_requested / 15
            when pa.time_cap_pol > 0 then pa.time_cap_pol / 15 
            else 0
       end  --TotalUnitsRequested
      ,ad.StaffId --StaffIdRequested
      */
      ,null  --UnitsRequested
      ,null --FrequencyRequested
      ,null --StartDateRequested
      ,null --EndDateRequested
      ,null  --TotalUnitsRequested
      ,null --StaffIdRequested
      ,null --ProviderId
      ,null --SiteId
      ,pa.cap_request_date --DateRequested
      ,pa.orig_entry_chron --DateReceived
      ,null --UnitsUsed
      ,null --StartDateUsed
      ,null --EndDateUsed
      ,null --UnitsScheduled
      ,null --ProviderAuthorizationId
      ,null --Urgent
      ,null --ReviewLevel
      ,null --ReviewerId
      ,null --ReviewerOther
      ,null --ReviewedOn
      ,pa.comments + CASE WHEN pa.amt_cap_pol > 0 THEN CHAR(13)+CHAR(10)+ ''$ '' + convert(varchar, pa.amt_cap_pol) ELSE '''' end
		--Rationale
  from cstm_conv_map_Authorizations am
       join Psych..Procedure_Authorization pa on pa.authorization_no = am.authorization_no
       join AuthorizationDocuments ad on ad.AuthorizationDocumentId = am.AuthorizationId
       left join Cstm_Conv_Map_AuthorizationCodes acm on acm.proc_code = pa.proc_code and acm.is_proc_group = pa.is_proc_group
       LEFT JOIN dbo.ClientCoveragePlans ccp ON ccp.ClientCoveragePlanId = ad.ClientCoveragePlanId
       LEFT JOIN dbo.CoveragePlans cp ON cp.CoveragePlanId = ccp.CoveragePlanId 
       LEFT JOIN dbo.Payers p ON p.PayerId = cp.PayerId
       
 /*where (pa.num_cap_pol > 0 
    or  pa.num_cap_yr > 0
    or  pa.num_cap_month > 0
    or  pa.num_cap_wk > 0 
    or  pa.num_cap_day > 0
    or  pa.time_cap_pol > 0
    or  pa.num_cap_requested > 0
    or  pa.time_cap_requested > 0)*/
             
if @@error <> 0 goto error

set identity_insert Authorizations off

if @@error <> 0 goto error

update a
   set Units = null,
       TotalUnits = null
  from Authorizations a
 where Status = 4242  
       
if @@error <> 0 goto error

insert into ServiceAuthorizations (
       ServiceId
      ,ClientCoveragePlanId
      ,AuthorizationRequested
      ,AuthorizationId
      ,UnitsUsed
      ,UnitsScheduled
      ,RowIdentifier
      ,CreatedBy
      ,CreatedDate
      ,ModifiedBy
      ,ModifiedDate)
select sm.ServiceId
      ,ad.ClientCoveragePlanId
      ,''N'' --AuthorizationRequested
      ,am.AuthorizationId
      ,case when s.Status in (71, 75)
            then case when pa.num_cap_pol > 0 or pa.num_cap_yr > 0 or pa.num_cap_month > 0 or 
                      pa.num_cap_wk > 0 or pa.num_cap_day > 0
                      then 1
                      when pa.time_cap_pol > 0 and isnull(p.PayerType, 0) = 20479 
                      then case pctc.duration_type 
                                when ''MI'' then pctc.proc_duration
                                when ''HO'' then (pctc.proc_duration * 60)
                                when ''DA'' then (pctc.proc_duration * 1440)
                                else pctc.proc_duration
                           end
                      when pa.time_cap_pol > 0 
                      then case pctc.duration_type 
                                when ''MI'' then pctc.proc_duration / 15
                                when ''HO'' then (pctc.proc_duration * 60) / 15
                                when ''DA'' then (pctc.proc_duration * 1440) / 15
                                else pctc.proc_duration
                           end  
                      when pa.amt_cap_pol > 0 then s.Charge * 100
                      else 1
                  end
            else 0
       end as UnitsUsed
      ,case when s.Status = 70
            then case when pa.num_cap_pol > 0 or pa.num_cap_yr > 0 or pa.num_cap_month > 0 or 
                      pa.num_cap_wk > 0 or pa.num_cap_day > 0
                      then 1
                      when pa.time_cap_pol > 0 and isnull(p.PayerType, 0) = 20479 
                      then case pctc.duration_type 
                                when ''MI'' then pctc.proc_duration
                                when ''HO'' then (pctc.proc_duration * 60)
                                when ''DA'' then (pctc.proc_duration * 1440)
                                else pctc.proc_duration
                           end
                      when pa.time_cap_pol > 0
                      then case pctc.duration_type 
                                when ''MI'' then pctc.proc_duration / 15
                                when ''HO'' then (pctc.proc_duration * 60) / 15
                                when ''DA'' then (pctc.proc_duration * 1440) / 15
                                else pctc.proc_duration
                           end  
                      when pa.amt_cap_pol > 0 then s.Charge*100 -- Use the charge for money    
                      else 1
                  end
            else 0
       end as UnitsScheduled
      ,newid() --RowIdentifier
      ,pctc.orig_user_id --CreatedBy
      ,pctc.orig_entry_chron  --CreatedDate
      ,pctc.user_id --ModifiedBy
      ,pctc.entry_chron --ModifiedDate
  from cstm_conv_map_Authorizations am
       join Authorizations a on a.AuthorizationId = am.AuthorizationId   
       join AuthorizationDocuments ad on ad.AuthorizationDocumentId = a.AuthorizationDocumentId
       join Psych..Procedure_Authorization pa on pa.authorization_no = am.authorization_no
       join Psych..Patient_Clin_Tran_Cov pctc on pctc.authorization_no = am.authorization_no
       join Cstm_Conv_Map_Services sm on sm.clinical_transaction_no = pctc.clinical_transaction_no
       join Services s on s.ServiceId = sm.ServiceId
       left join dbo.ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = ad.ClientCoveragePlanId
       left join dbo.CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId 
       left join dbo.Payers p on p.PayerId = cp.PayerId
 where s.Status in (70, 71, 75)       

if @@error <> 0 goto error

update a
   set UnitsUsed = sa.UnitsUsed,
       StartDateUsed = sa.StartDateUsed,
       EndDateUsed = sa.EndDateUsed
  from Authorizations a
       join (select sa.AuthorizationId,
                    sum(sa.UnitsUsed) as UnitsUsed,
                    min(s.DateOfService) as StartDateUsed,
                    max(s.DateOfService) as EndDateUsed
               from ServiceAuthorizations sa
                    join Services s on s.ServiceId = sa.ServiceId
              where sa.UnitsUsed > 0                    
              group by sa.AuthorizationId) as sa on sa.AuthorizationId = a.AuthorizationId
              
if @@error <> 0 goto error

update a
   set UnitsScheduled = sa.UnitsScheduled
  from Authorizations a
       join (select sa.AuthorizationId,
                    sum(sa.UnitsScheduled) as UnitsScheduled
               from ServiceAuthorizations sa
                    join Services s on s.ServiceId = sa.ServiceId
              where sa.UnitsScheduled > 0                    
              group by sa.AuthorizationId) as sa on sa.AuthorizationId = a.AuthorizationId

if @@error <> 0 goto error

insert into AuthorizationHistory (
       CreatedBy
      ,CreatedDate
      ,ModifiedBy
      ,ModifiedDate
      ,AuthorizationId
      ,AuthorizationNumber
      ,Status
      ,Units
      ,Frequency
      ,StartDate
      ,EndDate
      ,TotalUnits
      ,UnitsRequested
      ,FrequencyRequested
      ,StartDateRequested
      ,EndDateRequested
      ,TotalUnitsRequested
      ,ProviderAuthorizationId
      ,Urgent
      ,ReviewLevel
      ,ReviewerId
      ,ReviewerOther
      ,ReviewedOn
      ,StaffId
      ,StaffIdRequested
      ,Rationale)
select aeh.orig_user_id --CreatedBy
      ,aeh.orig_entry_chron --CreatedDate
      ,aeh.user_id --ModifiedBy
      ,aeh.entry_chron --ModifiedDate
      ,a.AuthorizationId
      ,aeh.referral_no --AuthorizationNumber
      --FIX FOR UNLIMITED
      ,case when aeh.num_cap_pol > 0 or aeh.num_cap_yr  > 0 or aeh.num_cap_month > 0 or 
                 aeh.num_cap_wk > 0 or aeh.num_cap_day > 0 or aeh.time_cap_pol > 0 
                 or aeh.amt_cap_pol > 0
            then 4243 -- Approved
            else 4242 -- Requested
       end as Status
      ,case when aeh.num_cap_pol > 0 then aeh.num_cap_pol
            when aeh.num_cap_yr > 0 then aeh.num_cap_yr
            when aeh.num_cap_month > 0 then aeh.num_cap_month
            when aeh.num_cap_wk > 0 then aeh.num_cap_wk
            when aeh.num_cap_day > 0 then aeh.num_cap_day
            when aeh.time_cap_pol > 0 and isnull(p.PayerType, 0) = 20479 then aeh.time_cap_pol
            when aeh.time_cap_pol > 0 then aeh.time_cap_pol / 15 
            when aeh.amt_cap_pol > 0 then aeh.amt_cap_pol * 100
           else 0
       end  --Units
      ,null --Frequency
      ,aeh.orig_entry_date --StartDate
      ,aeh.expiration_date --EndDate
      --FIX FOR UNLIMITED
      ,case when aeh.num_cap_pol > 0 then aeh.num_cap_pol
            when aeh.num_cap_yr > 0 then aeh.num_cap_yr
            when aeh.num_cap_month > 0 then aeh.num_cap_month
            when aeh.num_cap_wk > 0 then aeh.num_cap_wk
            when aeh.num_cap_day > 0 then aeh.num_cap_day
            when aeh.time_cap_pol > 0 and isnull(p.PayerType, 0) = 20479 then aeh.time_cap_pol
            when aeh.time_cap_pol > 0 then aeh.time_cap_pol / 15 
            when aeh.amt_cap_pol > 0 then aeh.amt_cap_pol * 100
            else 0
       end  --TotalUnits
       --FIX FOR UNLIMITED
      ,case when aeh.num_cap_requested > 0 then aeh.num_cap_requested
            when aeh.num_cap_pol > 0 then aeh.num_cap_pol
            when aeh.num_cap_yr > 0 then aeh.num_cap_yr
            when aeh.num_cap_month > 0 then aeh.num_cap_month
            when aeh.num_cap_wk > 0 then aeh.num_cap_wk
            when aeh.num_cap_day > 0 then aeh.num_cap_day 
            when aeh.time_cap_requested > 0 and isnull(p.PayerType, 0) = 20479 then aeh.time_cap_requested
            when aeh.time_cap_requested > 0 then aeh.time_cap_requested / 15
            when aeh.time_cap_pol > 0 and isnull(p.PayerType, 0) = 20479 then aeh.time_cap_pol
            when aeh.time_cap_pol > 0 then aeh.time_cap_pol / 15 
            when aeh.amt_cap_requested > 0 then aeh.amt_cap_requested * 100
            when aeh.amt_cap_pol > 0 then aeh.amt_cap_pol * 100
            else 0
       end  --UnitsRequested
      ,null --FrequencyRequested
      ,aeh.orig_entry_date --StartDateRequested
      ,aeh.expiration_date --EndDateRequested
      --FIX FOR UNLIMITED
      ,case when aeh.num_cap_requested > 0 then aeh.num_cap_requested
            when aeh.num_cap_pol > 0 then aeh.num_cap_pol
            when aeh.num_cap_yr > 0 then aeh.num_cap_yr
            when aeh.num_cap_month > 0 then aeh.num_cap_month
            when aeh.num_cap_wk > 0 then aeh.num_cap_wk
            when aeh.num_cap_day > 0 then aeh.num_cap_day 
            when aeh.time_cap_requested > 0 and isnull(p.PayerType, 0) = 20479 then aeh.time_cap_requested
            when aeh.time_cap_requested > 0 then aeh.time_cap_requested / 15
            when aeh.time_cap_pol > 0 and isnull(p.PayerType, 0) = 20479 then aeh.time_cap_pol
            when aeh.time_cap_pol > 0 then aeh.time_cap_pol / 15 
            when aeh.amt_cap_requested > 0 then aeh.amt_cap_requested * 100
            when aeh.amt_cap_pol > 0 then aeh.amt_cap_pol * 100
            else 0
       end  --TotalUnitsRequested
      ,null --ProviderAuthorizationId
      ,null --Urgent
      ,null --ReviewLevel
      ,null --ReviewerId
      ,null --ReviewerOther
      ,null --ReviewedOn
      ,sm.StaffId
      ,sm.StaffId --StaffIdRequested
      ,aeh.comments --Rationale
  from cstm_conv_map_Authorizations am
       join Authorizations a on a.AuthorizationId = am.AuthorizationId
       join AuthorizationDocuments ad on ad.AuthorizationDocumentId = a.AuthorizationDocumentId
       join Psych..Auth_Edit_History aeh on aeh.authorization_no = am.authorization_no
       left join Cstm_Conv_Map_Staff sm on sm.staff_id = aeh.clinician_id
       left join dbo.ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = ad.ClientCoveragePlanId
       left join dbo.CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId 
       left join dbo.Payers p on p.PayerId = cp.PayerId

 order by aeh.entry_chron, am.AuthorizationId
  
if @@error <> 0 goto error

return 

error:

raiserror 50010 ''Failed to execute csp_conv_Authorizations''

' 
END
GO
