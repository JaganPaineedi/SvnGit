/****** Object:  StoredProcedure [dbo].[csp_conv_CoveragePlans]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_CoveragePlans]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_conv_CoveragePlans]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_CoveragePlans]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'  
CREATE procedure [dbo].[csp_conv_CoveragePlans]
as

declare @reseed int

select @reseed = max(PayerId) + 1 from Payers

DBCC CHECKIDENT (Cstm_Conv_Map_Payers, reseed, @reseed) WITH NO_INFOMSGS

if @@error <> 0 goto error

insert into Cstm_Conv_Map_Payers (
       payor_id)
select payor_id
  from Psych..Payor p
 where not exists(select * from Cstm_Conv_Map_Payers pm where pm.payor_id = p.payor_id)
 
if @@error <> 0 goto error

set identity_insert Payers on

insert into Payers (
       PayerId,
       PayerName,
       PayerType,
       Active,
       CreatedBy,
       CreatedDate,
       ModifiedBy,
       ModifiedDate)
select pm.PayerId,
       p.name,
       gc.GlobalCodeId,
       case when left(p.status, 1) = ''A'' then ''Y'' else ''N'' end,
       p.user_id,
       p.entry_chron,
       p.user_id,
       p.entry_chron
  from Cstm_Conv_Map_Payers pm
       join Psych..Payor p on p.payor_id = pm.payor_id
       left join Cstm_Conv_Map_GlobalCodes gc on gc.Category = ''PAYERTYPE'' and gc.code = p.type
 where p.payor_id not in (''STANDARD'')
   and not exists(select * from Payers p where p.PayerId = pm.PayerId)
       
if @@error <> 0 goto error

set identity_insert Payers off

-- Coverage Plan

select @reseed = max(CoveragePlanId) + 1 from CoveragePlans

DBCC CHECKIDENT (Cstm_Conv_Map_CoveragePlans, reseed, @reseed) WITH NO_INFOMSGS

if @@error <> 0 goto error

insert into Cstm_Conv_Map_CoveragePlans (
        coverage_plan_id,
	hosp_status_code)
select coverage_plan_id,
       hosp_status_code
  from Psych..coverage_plan cp
--Do not Standard Plans
 where coverage_plan_id not in (''STANDARD'')
   and not exists(select * from Cstm_Conv_Map_CoveragePlans cpm where cpm.coverage_plan_id = cp.coverage_plan_id and cpm.hosp_status_code = cp.hosp_status_code)

if @@error <> 0 goto error

set identity_insert CoveragePlans on

insert into CoveragePlans (
       CoveragePlanId,
       CoveragePlanName,
       DisplayAs,
       Active,
       InformationComplete, --       InformationIsComplete,
       AddressHeading,
       Address, 
       City, 
       State, 
       ZipCode, 
       AddressDisplay, 
       PayerId, 
       Capitated, 
       ContactName, 
       ContactPhone, 
       ContactFax, 
       BillingCodeTemplate, 
       UseBillingCodesFrom, 
       UseStandardRules, 
       MedicaidPlan, 
       MedicarePlan, 
       ElectronicVerification, 
       Comment, 
       PaperClaimFormatId, 
       ElectronicClaimFormatId, 
       CombineClaimsAtPayerLevel, 
       ProviderIdType, 
       ProviderId, 
       ClaimFilingIndicatorCode, 
       ElectronicClaimsPayerId, 
       ElectronicClaimsOfficeNumber, 
       CreatedBy,
       CreatedDate, 
       ModifiedBy, 
       ModifiedDate)
select cpm.CoveragePlanId,
       cp.name,
       cp.coverage_plan_id, --DisplayAs
       case when left(cp.status, 1) = ''A'' then ''Y'' else ''N'' end,
       ''Y'',
       null, --AddressHeading
       case when ltrim(rtrim(isnull(cp.claims_addr_1, '''') + isnull(cp.claims_addr_2, ''''))) = ''''
            then null
            else isnull(ltrim(rtrim(cp.claims_addr_1)), '''') + 
                 case when isnull(ltrim(rtrim(cp.claims_addr_2)), '''') = ''''
                      then ''''
                      else char(13) + char(10) + ltrim(rtrim(cp.claims_addr_2)) 
                 end
       end,
       ltrim(rtrim(cp.claims_city)),
       ltrim(rtrim(cp.claims_state)),
       ltrim(rtrim(cp.claims_zip)),
       case when ltrim(rtrim(isnull(cp.claims_addr_1, '''') + isnull(cp.claims_addr_2, '''') + 
                 isnull(cp.claims_city, '''') + isnull(cp.claims_state, '''') + isnull(cp.claims_zip, ''''))) = '''' 
            then null
            else isnull(ltrim(rtrim(cp.claims_addr_1)), '''') +
                 case when isnull(ltrim(rtrim(cp.claims_addr_2)), '''') = ''''
                      then ''''
                      else char(13) + char(10) + ltrim(rtrim(cp.claims_addr_2)) 
                 end + char(13) + char(10) +
                 ltrim(rtrim(isnull(cp.claims_city,''''))) + '', '' + ltrim(rtrim(isnull(cp.claims_state, ''''))) + '' '' + 
                 ltrim(rtrim(isnull(cp.claims_zip, '''')))
       end,     
       pm.PayerId,
       case when cp.coverage_plan_id in (''MEDICAID'', ''MIABW'', ''GF'', ''MICHILD'')
            then ''Y''
            else ''N''
       end, -- Capitated?
       isnull(isnull(isnull(cp.contact, cp.claims_processing_contact), cp.elec_claims_processing_contact), cp.benefits_verif_contact),
       isnull(isnull(isnull(cp.contact_phone + 
                            case when len(ltrim(rtrim(cp.contact_phone_ext))) > 0 
                                 then '' '' + ltrim(rtrim(cp.contact_phone_ext)) else '''' end,
                            cp.claims_processing_phone + 
                            case when len(ltrim(rtrim(cp.claims_processing_phone_ext))) > 0 
                                 then '' '' + ltrim(rtrim(cp.claims_processing_phone_ext)) else '''' end),
                            cp.elec_claims_processing_phone + 
                            case when len(ltrim(rtrim(cp.elec_claims_processing_phone_e))) > 0 
                                 then '' '' + ltrim(rtrim(cp.elec_claims_processing_phone_e)) else '''' end),
                            cp.benefits_verif_phone + 
                            case when len(ltrim(rtrim(cp.benefits_verif_phone_ext))) > 0 
                                 then '' '' + ltrim(rtrim(cp.benefits_verif_phone_ext)) else '''' end),
       isnull(isnull(isnull(cp.fax, cp.claims_processing_fax), cp.elec_claims_processing_fax), cp.benefits_verif_fax),
       null, --BillingCodeTemplate
       null, --UseBillingCodesFrom
       ''Y'', --UseStandardRules
       case when gc.Name = ''Medicaid'' then ''Y'' else ''N'' end, --MedicaidPlan
       case when gc.Name = ''Medicare'' then ''Y'' else ''N'' end, --Medicare
       ''N'', --ElectronicVerification?
       cp.comments,
       null, --PaperClaimFormatId
       null, --ElectronicClaimFormatId
       ''N'',  --CombineClaimsAtPayerLevel?
       null, --ProviderIdType
       cp.provider_id, 
       null, --ClaimFilingIndicatorCode
       cp.elec_claims_payor_id, --ElectronicClaimsPayerId
       cp.elec_claims_payor_sub_id, --ElectronicClaimsOfficeNumber
       isnull(cp.user_id, ''sa''),
       isnull(cp.entry_chron, GetDate()),
       isnull(cp.user_id, ''sa''),
       isnull(cp.entry_chron, GetDate())
  from Cstm_Conv_Map_CoveragePlans cpm
       join Psych..coverage_plan cp on cp.coverage_plan_id = cpm.coverage_plan_id and cp.hosp_status_code = cpm.hosp_status_code
       left join Cstm_Conv_Map_Payers pm on pm.payor_id = cp.payor_id
       left join Cstm_Conv_Map_GlobalCodes gc on gc.Category = ''PAYERTYPE'' and
                                                 gc.code = cp.type 
 where not exists(select * from CoveragePlans cp where cp.CoveragePlanId = cpm.CoveragePlanId)
 
if @@error <> 0 goto error

set identity_insert CoveragePlans off

update c
   set ElectronicClaimsPayerId = cp.elec_claims_payor_id,
       ElectronicClaimsOfficeNumber = cp.elec_claims_payor_sub_id,
       PaperClaimFormatId = 1,
       ElectronicClaimFormatId = 3,
       BillingDiagnosisType = ''I'',
       ClaimFilingIndicatorCode = case cp.elec_claims_type
                                       when ''BLUESHIELD'' then 4782
                                       when ''CHAMPUS''    then 4783
                                       when ''CHAMPVA''    then 4788
                                       when ''COMMERCIAL'' then 4784
                                       when ''MEDICAID''   then 4786
                                       when ''MEDICARE''   then 4785     
                                  end
  from CoveragePlans c
       join Cstm_Conv_Map_CoveragePlans cpm on c.CoveragePlanId = cpm.CoveragePlanId
       join Psych..coverage_plan cp on cp.coverage_plan_id = cpm.coverage_plan_id and cp.hosp_status_code = cpm.hosp_status_code
 where c.ElectronicClaimsPayerId is null
 
if @@error <> 0 goto error

update cp
   set Active = ''N''
  from CoveragePlans cp
       join Cstm_Conv_Map_CoveragePlans cpm on cpm.CoveragePlanId = cp.CoveragePlanId
 where not exists(select ''*''
                    from Psych..Billing_Transaction bt
                         join Psych..Patient_Clin_Tran pct on pct.clinical_transaction_no = bt.clinical_transaction_no
                         join Psych..Group_Clin_Tran gct on gct.group_clin_tran_no = pct.group_clin_tran_no
                   where bt.coverage_plan_id = cpm.coverage_plan_id
                     and datediff(mm, gct.proc_chron, GetDate()) <= 11)
   and cp.Active = ''Y''

if @@error <> 0 goto error

update cps
   set Address = case when ltrim(rtrim(isnull(cp.addr_1, '''') + isnull(cp.addr_2, ''''))) = ''''
                      then null
                      else isnull(ltrim(rtrim(cp.addr_1)), '''') + 
                           case when isnull(ltrim(rtrim(cp.addr_2)), '''') = ''''
                                then ''''
                                else char(13) + char(10) + ltrim(rtrim(cp.addr_2)) 
                           end
                 end,
       City = ltrim(rtrim(cp.city)),
       State = ltrim(rtrim(cp.state)),
       ZipCode = ltrim(rtrim(cp.zip)),
       AddressDisplay = case when ltrim(rtrim(isnull(cp.addr_1, '''') + isnull(cp.addr_2, '''') + 
                                  isnull(cp.city, '''') + isnull(cp.state, '''') + isnull(cp.zip, ''''))) = '''' 
                             then null
                             else isnull(ltrim(rtrim(cp.addr_1)), '''') +
                                  case when isnull(ltrim(rtrim(cp.addr_2)), '''') = ''''
                                       then ''''
                                       else char(13) + char(10) + ltrim(rtrim(cp.addr_2)) 
                                  end + char(13) + char(10) + 
                                  ltrim(rtrim(isnull(cp.city,''''))) + '', '' + ltrim(rtrim(isnull(cp.state, ''''))) + '' '' + 
                                  ltrim(rtrim(isnull(cp.zip, '''')))
                             end     
  from CoveragePlans cps
       join Cstm_Conv_Map_CoveragePlans cpm on cpm.CoveragePlanId = cps.CoveragePlanId
       join Psych..coverage_plan cp on cp.coverage_plan_id = cpm.coverage_plan_id and 
                                             cp.hosp_status_code = cpm.hosp_status_code
 where cps.Address is null

if @@error <> 0 goto error


--Custom Modifications per harbor
update cp 
set Active = ''Y''
from CoveragePlans cp where DisplayAs = ''RSC17''

if @@error <> 0 goto error

--Add Authorization Required rule
Insert into CoveragePlanRules 
(CoveragePlanId, RuleTypeId,RuleName,AppliesToAllProcedureCodes, RuleViolationAction,createdby, createdDate, modifiedby,modifieddate)

SELECT cp.CoveragePlanId,
4264,''Authorization is required'',''Y'',-1,''avoss'',getdate(),''avoss'',getdate()
FROM dbo.Cstm_Conv_Map_CoveragePlans c 
JOIN dbo.CoveragePlans cp ON cp.CoveragePlanId = c.CoveragePlanId
JOIN Psych..Coverage_Plan pcp ON pcp.coverage_plan_id = c.coverage_plan_id
WHERE pcp.auth_req = ''Y''
AND NOT EXISTS ( SELECT 1 FROM CoveragePlanRules cpr where cpr.CoveragePlanId = cp.CoveragePlanId
	AND cpr.RuleTypeId = 4264 AND ISNULL(cpr.RecordDeleted,''N'')<>''Y'' )

IF @@ERROR <> 0 GOTO ERROR

 
return 

error:

raiserror 50020 ''csp_conv_CoveragePlans Failed''



' 
END
GO
