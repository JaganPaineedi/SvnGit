/****** Object:  StoredProcedure [dbo].[csp_conv_FinancialActivities]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_FinancialActivities]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_conv_FinancialActivities]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_FinancialActivities]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure [dbo].[csp_conv_FinancialActivities]
as

if OBJECT_ID(''psych.dbo.payment2'', ''U'') is not null
	drop table psych.dbo.payment2

create table  Psych..Payment2(
payment_id int IDENTITY(1,1) NOT NULL,
patient_id char(10) NULL,
coverage_plan_id char(10) NULL,
hosp_status_code char(2) NULL,
source varchar(30) NULL,
source_type char(2) NULL,
instrument char(2) NULL,
doc_reference varchar(30) NULL,
instrument_date datetime NULL,
payment_amount money NOT NULL,
balance_amount money NULL,
remark varchar(255) NULL,
orig_user_id char(10) NULL,
orig_entry_chron datetime NULL,
user_id char(10) NULL,
entry_chron dbo.UD_Entry_Chron NULL,
payor_id char(10) NULL,
payment_location char(10) NULL,
subtype char(2),
billing_ledger_no char(10),
CONSTRAINT XPKPayment2 PRIMARY KEY CLUSTERED (payment_id))

create index XIE1_Payment2 on Psych..Payment2 (billing_ledger_no)

insert into Psych..Payment2 (
       patient_id,
       coverage_plan_id,
       hosp_status_code,
       source,
       source_type,
       instrument,
       doc_reference,
       instrument_date,
       payment_amount,
       balance_amount,
       remark,
       orig_user_id,
       orig_entry_chron,
       user_id,
       entry_chron,
       payor_id,
       payment_location,
       subtype,
       billing_ledger_no)
select p.patient_id,
       p.coverage_plan_id,
       p.hosp_status_code,
       p.source,
       p.source_type,
       p.instrument,
       p.doc_reference,
       bl.accounting_date,
       -bl.amount,
       0,
       p.remark,
       bl.orig_user_id,
       bl.orig_entry_chron,
       bl.orig_user_id,
       bl.orig_entry_chron,
       payor_id,
       payment_location,
       ''PA'',
       bl.billing_ledger_no as billing_ledger_no
  from Psych..Payment p
       join Psych..Billing_Ledger bl on bl.payment_id = p.payment_id
 where bl.subtype = ''PA''
union
select p.patient_id,
       p.coverage_plan_id,
       p.hosp_status_code,
       p.source,
       p.source_type,
       p.instrument,
       p.doc_reference,
       bl.accounting_date,
       0, --bl.amount,
       0,
       p.remark,
       bl.orig_user_id,
       bl.orig_entry_chron,
       bl.orig_user_id,
       bl.orig_entry_chron,
       payor_id,
       payment_location,
       ''RF'',
       bl.billing_ledger_no as billing_ledger_no
  from Psych..Payment p
       join Psych..Billing_Ledger bl on bl.payment_id = p.payment_id
 where bl.subtype = ''RF''
 order by billing_ledger_no
 


-- Allow for processing smaller datasets
declare @maximumValue		int,
		@currentValue		int,
		@incrementStep		int


create table #Priority (
PriorityId           int identity  not null,
ServiceId            int           not null,
ChargeId             int           not null,
ChargePriorityId     int           null,
copay_priority       smallint      null)

create table #ARLedgerCharges (
ServiceId        int      null,
billing_trans_no char(10) null,
ChargeId         int      null)

create table #Activity (
FinancialActivityId  int identity not null,
ActivityType         int          not null,
ActivityId           int          not null)

create table #IgnoreBillingLedger (
billing_ledger_no char(10)     null,
billing_trans_no  char(10)     null,
orig_entry_chron  datetime     null,
amount            money        null)

create table #Charges (
billing_trans_no        char(10)  null,
clinical_transaction_no int       null,
ServiceId               int       null,
copay_priority          int       null,
orig_entry_chron        datetime  null,
billing_ledger_no       char(10)  null,
type                    char(2)   null)

create table #NDChargeBillingLedger(
billing_ledger_no char(10) null,
billing_trans_no  char(10) null,
orig_entry_chron  datetime null)   

declare @FinancialActivityLineChargeId int
declare @ServiceId int
declare @Services int
declare @FinancialActivityLineId  int
declare @ActivityType  int
declare @CreatedDate datetime
declare @CreatedBy varchar(10)
declare @ServiceComplete int
declare @PayerPayment int
declare @ClientPayment int
declare @Adjustment int

set @ServiceComplete = 4321
set @PayerPayment = 4323
set @ClientPayment = 4325
set @Adjustment = 4326


--
-- Charges
--

insert into #ARLedgerCharges (
       ServiceId,
       billing_trans_no)
select s.ServiceId,
       bt.billing_trans_no
  from Services s
       join Cstm_Conv_Map_Services sm on sm.ServiceId = s.ServiceId
       join Psych..Billing_Transaction bt on bt.clinical_transaction_no = sm.clinical_transaction_no
       join (select clinical_transaction_no,
                    entry_chron,
                    min(copay_priority) as copay_priority
               from Psych..Billing_Transaction
              group by clinical_transaction_no, entry_chron) as cp on cp.clinical_transaction_no = bt.clinical_transaction_no and
                                                                      cp.entry_chron = bt.entry_chron and
                                                                      cp.copay_priority = bt.copay_priority
 where not exists(select *
                    from Psych..Billing_Transaction bt2
                   where bt2.clinical_transaction_no = sm.clinical_transaction_no
                     and bt2.entry_chron < bt.entry_chron)

if @@error <> 0 goto error

create index XE1_#ARLedgerCharges on #ARLedgerCharges(billing_trans_no)

if @@error <> 0 goto error

insert #Charges (
       billing_trans_no,
       clinical_transaction_no,
       ServiceId,
       copay_priority,
       orig_entry_chron,
       billing_ledger_no,
       type)
select bt.billing_trans_no,
       bt.clinical_transaction_no,
       sm.ServiceId,
       bt.copay_priority,
       db.orig_entry_chron,
       db.billing_ledger_no,
       ''BI''
  from Psych..Billing_Ledger db
       join Psych..Billing_Transaction bt on bt.billing_trans_no = db.billing_trans_no
       join Cstm_Conv_Map_Services sm on sm.clinical_transaction_no = bt.clinical_transaction_no  
       left join #ARLedgerCharges lc on lc.billing_trans_no = bt.billing_trans_no
 where db.type = ''DB''
   and db.subtype = ''BI''
   and (lc.billing_trans_no is not null
    or  not exists (select *
                      from Psych..Billing_Ledger cr
                   where cr.type = ''CR''
                     and cr.subtype = ''ND''
                     and cr.billing_trans_no = db.billing_trans_no
                     and db.orig_user_id = cr.orig_user_id

                     and abs(datediff(ss, cr.orig_entry_chron, db.orig_entry_chron)) between 0 and 60

                     and (cr.amount + db.amount) = 0))

if @@error <> 0 goto error

create index XE1_#Charges on #Charges(billing_trans_no)

if @@error <> 0 goto error

insert #Charges (
       billing_trans_no,
       clinical_transaction_no,
       ServiceId,
       copay_priority,
       orig_entry_chron,
       billing_ledger_no,
       type)
select bt.billing_trans_no,
       bt.clinical_transaction_no,
       sm.ServiceId,
       bt.copay_priority,
       min(db.orig_entry_chron),
       min(db.billing_ledger_no),
       ''ND''
  from Psych..Billing_Ledger db
       join Psych..Billing_Transaction bt on bt.billing_trans_no = db.billing_trans_no
       join Cstm_Conv_Map_Services sm on sm.clinical_transaction_no = bt.clinical_transaction_no
 where db.type = ''DB''
   and db.subtype = ''ND''
   and not exists(select *
                    from #Charges c
                   where c.billing_trans_no = bt.billing_trans_no)
   and not exists(select *
                    from Psych..Billing_Ledger db2
                   where db2.billing_trans_no = db.billing_trans_no
                     and db2.type = ''DB''
                     and db2.subtype = ''ND''
                     and db2.orig_entry_chron < db.orig_entry_chron) 
 group by bt.billing_trans_no,
          bt.clinical_transaction_no,
          sm.ServiceId,
          bt.copay_priority

if @@error <> 0 goto error

insert #Charges (
       billing_trans_no,
       clinical_transaction_no,
       ServiceId,
       copay_priority,
       orig_entry_chron,
       billing_ledger_no,
       type)
select bt.billing_trans_no,
       bt.clinical_transaction_no,
       sm.ServiceId,
       bt.copay_priority,
       min(db.orig_entry_chron),
       min(db.billing_ledger_no),
       ''CD''
  from Psych..Billing_Ledger db
       join Psych..Billing_Transaction bt on bt.billing_trans_no = db.billing_trans_no
       join Cstm_Conv_Map_Services sm on sm.clinical_transaction_no = bt.clinical_transaction_no
 where db.type = ''DB''
   and db.subtype = ''CD''
   and not exists(select *
                    from #Charges c
                   where c.billing_trans_no = bt.billing_trans_no)
   and not exists(select *
                    from Psych..Billing_Ledger db2
                   where db2.billing_trans_no = db.billing_trans_no
                     and db2.type = ''DB''
                     and db2.subtype = ''CD''
                     and db2.orig_entry_chron < db.orig_entry_chron) 
 group by bt.billing_trans_no,
          bt.clinical_transaction_no,
          sm.ServiceId,
          bt.copay_priority

if @@error <> 0 goto error

-- Add to charges if there was any activity in Billing Ledger 
insert #Charges (
       billing_trans_no,
       clinical_transaction_no,
       ServiceId,
       copay_priority,
       orig_entry_chron,
       billing_ledger_no,
       type)
select bt.billing_trans_no,
       bt.clinical_transaction_no,
       sm.ServiceId,
       bt.copay_priority,
       db.orig_entry_chron,
       db.billing_ledger_no,
       ''BI''
  from Psych..Billing_Ledger db
       join Psych..Billing_Transaction bt on bt.billing_trans_no = db.billing_trans_no
       join Cstm_Conv_Map_Services sm on sm.clinical_transaction_no = bt.clinical_transaction_no  
 where db.type = ''DB''
   and db.subtype = ''BI''
   and not exists(select *
                    from #Charges c
                   where c.billing_trans_no = bt.billing_trans_no)
   and exists(select *
                from Psych..Billing_Ledger db2
               where db2.billing_trans_no = db.billing_trans_no
                 and db2.subtype in (''CD'', ''WO'', ''PA'')) 

if @@error <> 0 goto error

-- Add to charges if there is any balance left
insert #Charges (
       billing_trans_no,
       clinical_transaction_no,
       ServiceId,
       copay_priority,
       orig_entry_chron,
       billing_ledger_no,
       type)
select bt.billing_trans_no,
       bt.clinical_transaction_no,
       sm.ServiceId,
       bt.copay_priority,
       db.orig_entry_chron,
       db.billing_ledger_no,
       ''BI''
  from Psych..Billing_Ledger db
       join Psych..Billing_Transaction bt on bt.billing_trans_no = db.billing_trans_no
       join Cstm_Conv_Map_Services sm on sm.clinical_transaction_no = bt.clinical_transaction_no  
       join (select billing_trans_no
               from Psych..Billing_Ledger
              group by billing_trans_no
             having sum(amount) <> 0) as bl on bl.billing_trans_no = bt.billing_trans_no
 where db.type = ''DB''
   and db.subtype = ''BI''
   and not exists(select *
                    from #Charges c
                   where c.billing_trans_no = bt.billing_trans_no)

if @@error <> 0 goto error

-- Special case for STANDARD
insert #Charges (
       billing_trans_no,
       clinical_transaction_no,
       ServiceId,
       copay_priority,
       orig_entry_chron,
       billing_ledger_no,
       type)
select bt.billing_trans_no,
       bt.clinical_transaction_no,
       sm.ServiceId,
       bt.copay_priority,
       db.orig_entry_chron,
       db.billing_ledger_no,
       ''BI''
  from Psych..Billing_Ledger db
       join Psych..Billing_Transaction bt on bt.billing_trans_no = db.billing_trans_no
       join Cstm_Conv_Map_Services sm on sm.clinical_transaction_no = bt.clinical_transaction_no  
 where db.type = ''CR''
   and db.subtype = ''BI''
   and bt.coverage_plan_id = ''STANDARD''
   and not exists(select *  
                    from Psych..Billing_Transaction bt2
                   where bt2.clinical_transaction_no = sm.clinical_transaction_no
                     and bt2.billing_trans_no <> bt.billing_trans_no)
   and not exists(select *
                    from #Charges c
                   where c.billing_trans_no = bt.billing_trans_no)

if @@error <> 0 goto error

insert Cstm_Conv_Map_Charges (
       billing_trans_no,
       clinical_transaction_no,
       ServiceId,
       copay_priority,
       CreatedDate,
       billing_ledger_no)
select billing_trans_no,
       clinical_transaction_no,
       ServiceId,
       copay_priority,
       orig_entry_chron,
       billing_ledger_no
  from #Charges
 order by ServiceId, orig_entry_chron, copay_priority

if @@error <> 0 goto error


update lc
   set ChargeId = cm.ChargeId
  from #ARLedgerCharges lc
       join Cstm_Conv_Map_Charges cm on cm.billing_trans_no = lc.billing_trans_no

if @@error <> 0 goto error

create index XE2_#ARLedgerCharges on #ARLedgerCharges(ChargeId)

if @@error <> 0 goto error

insert into #Priority (
       ServiceId,
       ChargeId,
       copay_priority)
select ServiceId,
       ChargeId,
       copay_priority
  from Cstm_Conv_Map_Charges
 order by ServiceId, copay_priority, ChargeId

if @@error <> 0 goto error

update p
   set ChargePriorityId = cp.ChargePriorityId
  from #Priority p
       join (select ServiceId,
                    min(PriorityId) as ChargePriorityId
               from #Priority
              group by ServiceId) cp on cp.ServiceId = p.ServiceId

if @@error <> 0 goto error

set identity_insert Charges on

insert into Charges(
       ChargeId, 
       ServiceId, 
       ClientCoveragePlanId,
       Priority,
       ReadyToBill, 
       Flagged, 
       ExpectedPayment, 
       ExpectedAdjustment, 
       ClientCopay, 
       FirstBilledDate, 
       LastBilledDate, 
       BillingCode, 
       Modifier1, 
       Modifier2, 
       Modifier3, 
       Modifier4, 
       RevenueCode,
       RevenueCodeDescription,
       Units, 
       CreatedBy,
       CreatedDate, 
       ModifiedBy, 
       ModifiedDate)
select cm.ChargeId,
       cm.ServiceId,
       null, --ClientCoveragePlanId
       case when p.copay_priority = 7 
            then 0
            else (p.PriorityId - p.ChargePriorityId + 1)
       end,
       ''N'',
       null, --Flagged,
       bt.payor_payment,
       bt.payor_disallowance,
       null, --ClientCopay
       bt.bill_date, --FirstBilledDate
       bt.bill_date, --LastBilledDate
       null, --BillingCode
       null, --Modifier1
       null, --Modifier2 
       null, --Modifier3
       null, --Modifier4
       null, --RevenueCode
       null, --RevenueCodeDescription
       bt.qty, --Units
       bl.orig_user_id,
       cm.CreatedDate,
       bl.orig_user_id,
       cm.CreatedDate
  from Cstm_Conv_Map_Charges cm
       join Psych..Billing_Transaction bt on bt.billing_trans_no = cm.billing_trans_no
       join Psych..Billing_Ledger bl on bl.billing_ledger_no = cm.billing_ledger_no
       join #Priority p on p.ChargeId = cm.ChargeId
 order by cm.ChargeId

if @@error <> 0 goto error

set identity_insert Charges off


-- Set coverage plans

update c
   set ClientCoveragePlanId = ccp.ClientCoveragePlanId
  from Charges c
       join Cstm_Conv_Map_Charges cm on cm.ChargeId = c.ChargeId
       join Psych..Billing_Transaction bt on bt.billing_trans_no = cm.billing_trans_no
       join Services s on s.ServiceId = c.ServiceId
       join Cstm_Conv_Map_CoveragePlans cpm on cpm.coverage_plan_id = bt.coverage_plan_id and
                                               cpm.hosp_status_code = bt.hosp_status_code
       join ClientCoveragePlans ccp on ccp.ClientId = s.ClientId and
                                       ccp.CoveragePlanId = cpm.CoveragePlanId and
                                       isnull(ccp.InsuredId, ''IsNuLl'') = isnull(bt.insured_id, ''IsNuLl'')
 where c.Priority <> 0

if @@error <> 0 goto error

update c
   set ClientCoveragePlanId = ccp.ClientCoveragePlanId
  from Charges c
       join Cstm_Conv_Map_Charges cm on cm.ChargeId = c.ChargeId
       join Psych..Billing_Transaction bt on bt.billing_trans_no = cm.billing_trans_no
       join Services s on s.ServiceId = c.ServiceId
       join Cstm_Conv_Map_CoveragePlans cpm on cpm.coverage_plan_id = bt.coverage_plan_id and
                                               cpm.hosp_status_code = bt.hosp_status_code
       join ClientCoveragePlans ccp on ccp.ClientId = s.ClientId and
                                       ccp.CoveragePlanId = cpm.CoveragePlanId
 where c.Priority <> 0
   and c.ClientCoveragePlanId is null
               
if @@error <> 0 goto error

-- Set client copay
update c
   set ClientCopay = pctc.patient_copay
  from Charges c
       join Cstm_Conv_Map_Charges cm on cm.ChargeId = c.ChargeId
       join Psych..Billing_Transaction bt on bt.billing_trans_no = cm.billing_trans_no
       join Psych..Patient_Clin_Tran_Cov pctc on pctc.clinical_transaction_no = bt.clinical_transaction_no and
                                                       pctc.coverage_plan_id = bt.coverage_plan_id
 where isnull(pctc.patient_copay, 0) <> 0

if @@error <> 0 goto error

-- FirstBilledDate & LastBilledDate
update c
   set FirstBilledDate = bh.FirstBilledDate,
       LastBilledDate = bh.LastBilledDate
  from Charges c
       join Cstm_Conv_Map_Charges cm on cm.ChargeId = c.ChargeId
       join (select billing_trans_no,
                    min(print_date) as FirstBilledDate,
                    max(print_date) as LastBilledDate
               from Psych..Bill_History
              group by billing_trans_no) bh on bh.billing_trans_no = cm.billing_trans_no

if @@error <> 0 goto error

-- Set billing codes    
update c
   set BillingCode = ct.cpt_code,
       Modifier1 = ct.cpt_modifier_1,
       Modifier2 = ct.cpt_modifier_2, 
       Modifier3 = ct.cpt_modifier_3,
       RevenueCode = ct.revenue_code,
       RevenueCodeDescription = left(rc.revenue_desc, 100)
  from Charges c
       join Cstm_Conv_Map_Charges cm on cm.ChargeId = c.ChargeId
       join Psych..Claim_Transaction ct on ct.billing_trans_no = cm.billing_trans_no
       left join Psych..Revenue_Code rc on rc.revenue_code = ct.revenue_code
 where not exists(select * 
                    from Psych..Claim_Transaction ct2 
                   where ct2.billing_trans_no = ct.billing_trans_no
                     and ct2.claim_id > ct.claim_id)

if @@error <> 0 goto error

-- Payments mapping
--


insert into Cstm_Conv_Map_Payments (
       payment_id,
       billing_ledger_no)
select payment_id,
       billing_ledger_no
  from Psych..Payment2 p
 order by p.patient_id  
      

--
-- AR Ledger mapping
--

insert into #IgnoreBillingLedger (
       billing_ledger_no,
       billing_trans_no,
       orig_entry_chron,
       amount)
select bl.billing_ledger_no,
       bl.billing_trans_no,
       bl.orig_entry_chron,
       bl.amount
  from Psych..Billing_Ledger bl
 where bl.subtype = ''BI''
   and exists(select *
                from #Charges c
               where c.billing_trans_no = bl.billing_trans_no
                 and c.type = ''ND'')

if @@error <> 0 goto error

insert into #IgnoreBillingLedger (
       billing_ledger_no,
       billing_trans_no,
       orig_entry_chron,
       amount)
select bl.billing_ledger_no,
       bl.billing_trans_no,
       bl.orig_entry_chron,
       bl.amount
  from Psych..Billing_Ledger bl
 where bl.subtype = ''ND''
   and bl.type = ''CR''
   and exists(select *
                from #Charges c
               where c.billing_trans_no = bl.billing_trans_no
                 and c.type = ''ND'')
   and exists(select *
                from #IgnoreBillingLedger il
               where il.billing_trans_no = bl.billing_trans_no
                 and (il.amount + bl.amount) = 0
                 and abs(datediff(ss, il.orig_entry_chron, bl.orig_entry_chron)) between 0 and 60)
   and not exists(select * 
                    from Psych..Billing_Ledger bl2
                   where bl2.billing_trans_no = bl.billing_trans_no
                     and bl2.subtype = ''ND''
                     and bl2.type = ''CR''
                     and bl2.amount = bl.amount
                     and abs(datediff(ss, bl2.orig_entry_chron, bl.orig_entry_chron)) between 0 and 60
                     and bl2.billing_ledger_no < bl.billing_ledger_no)

if @@error <> 0 goto error

insert into #NDChargeBillingLedger (
       billing_ledger_no,
       billing_trans_no,
       orig_entry_chron)
select bl.billing_ledger_no,
       bl.billing_trans_no,
       bl.orig_entry_chron
  from Psych..Billing_Ledger bl
 where bl.subtype = ''BI''
   and exists(select *
                from #Charges c
               where c.billing_trans_no = bl.billing_trans_no
                 and c.type = ''BI'')
   and not exists(select *
                    from #ARLedgerCharges lc 
                   where lc.billing_trans_no = bl.billing_trans_no)

if @@error <> 0 goto error

insert into #NDChargeBillingLedger (
       billing_ledger_no,
       billing_trans_no,
       orig_entry_chron)
select bl.billing_ledger_no,
       bl.billing_trans_no,
       bl.orig_entry_chron
  from Psych..Billing_Ledger bl
 where bl.subtype = ''ND''
   and bl.type = ''CR''
   and exists(select *
                from #Charges c
               where c.billing_trans_no = bl.billing_trans_no
                 and c.type = ''BI'')
   and exists(select *
                from #NDChargeBillingLedger nd
               where nd.billing_trans_no = bl.billing_trans_no
                 and abs(datediff(ss, nd.orig_entry_chron, bl.orig_entry_chron)) between 0 and 60)
   and not exists(select * 
                    from Psych..Billing_Ledger bl2
                   where bl2.billing_trans_no = bl.billing_trans_no
                     and bl2.subtype = ''ND''
                     and bl2.type = ''CR''
                     and abs(datediff(ss, bl2.orig_entry_chron, bl.orig_entry_chron)) between 0 and 60
                     and bl2.billing_ledger_no < bl.billing_ledger_no)

if @@error <> 0 goto error
 
insert into Cstm_Conv_Map_ARLedger(
       billing_ledger_no,
       Amount,
       LedgerType,
       ChargeId,
       ServiceId,
       PaymentId,
       CreatedBy,
       CreatedDate
       )
select LedgerNo,
       Amount,
       LedgerType,
       ChargeId,
       ServiceId,
       PaymentId,
       CreatedBy,
       CreatedDate
from (
select max(bl.billing_ledger_no) as LedgerNo,
       sum(bl.amount) as Amount,
       4204 as LedgerType, -- Trasfer
       c.ChargeId as ChargeId,
       c.ServiceId as ServiceId,
       null as PaymentId,
       c.CreatedBy as CreatedBy,
       c.CreatedDate as CreatedDate,
       ''DB'' as type
  from Charges c
       join Cstm_Conv_Map_Charges cm on cm.ChargeId = c.ChargeId
       join Psych..Billing_Ledger bl on bl.billing_trans_no = cm.billing_trans_no
       --LEFT join cstm_conv_map_adjustment_codes as adj on adj.adjustment_code = bl.adjustment_code and ISNULL(adj.Reason, '''') = ISNULL(LTRIM(RTRIM(bl.reason)), '''')
       join #NDChargeBillingLedger ndl on ndl.billing_ledger_no = bl.billing_ledger_no
 group by c.ServiceId, c.ChargeId, c.CreatedBy, c.CreatedDate
union
select bl.billing_ledger_no as LedgerNo,
       bl.amount as Amount,
       case bl.subtype -- LedgerType
            when ''BI'' then case when lc.ChargeId is not null then 4201 else 4204 end -- Charge/Transfer
            when ''ND'' then 4204 --Transfer
            when ''PA'' then 4202 --Payment
            when ''RF'' then 4202
            else 4203 -- Adjustment
       end as LedgerType,
       c.ChargeId as ChargeId,
       c.ServiceId as ServiceId,
       pm.PaymentId as PaymentId,
       bl.orig_user_id as CreatedBy,
       bl.orig_entry_chron as CreatedDate,
       bl.type as type
  from Charges c
       join Cstm_Conv_Map_Charges cm on cm.ChargeId = c.ChargeId
       join Psych..Billing_Ledger bl on bl.billing_trans_no = cm.billing_trans_no
       left join Cstm_Conv_Map_Payments pm on pm.billing_ledger_no = bl.billing_ledger_no
       left join #ARLedgerCharges lc on lc.ChargeId = c.ChargeId
 where not exists(select *
                    from #IgnoreBillingLedger il
                   where il.billing_ledger_no = bl.billing_ledger_no)
   and not exists(select *
                    from #NDChargeBillingLedger ndl 
                   where ndl.billing_ledger_no = bl.billing_ledger_no)
) as l
 order by CreatedDate,
          ServiceId,
          ChargeId,
          case when Type = ''DB'' then 1 else 2 end, 
          CreatedBy,
          LedgerNo

if @@error <> 0 goto error

--
-- Set activity type
--

-- Service Compete

update arm
   set ActivityType = @ServiceComplete,
       ActivityId   = arm.ServiceId
  from Cstm_Conv_Map_ARLedger arm
       join Charges c on c.ChargeId = arm.ChargeId
       join #ARLedgerCharges lc on lc.ServiceId = arm.ServiceId
       join Charges fc on fc.ChargeId = lc.ChargeId
       join Psych..Billing_Ledger bl on bl.billing_ledger_no = arm.billing_ledger_no
 where bl.subtype in (''BI'', ''ND'', ''CD'')
   and abs(datediff(ss, fc.CreatedDate, c.CreatedDate)) between 0 and 60
   and c.CreatedBy = bl.orig_user_id
   and abs(datediff(ss, fc.CreatedDate, bl.orig_entry_chron)) between 0 and 60



if @@error <> 0 goto error

-- Payment

update arm
   set ActivityId = PaymentId
  from Cstm_Conv_Map_ARLedger arm
 where arm.PaymentId is not null
   and arm.ActivityType is null

if @@error <> 0 goto error

-- Adjustments and Write Offs are part of the payment activity within the same payer
update arm
   set ActivityId = p.PaymentId
  from Cstm_Conv_Map_ARLedger arm
       join Psych..Billing_Ledger bl on bl.billing_ledger_no = arm.billing_ledger_no
       join (select ChargeId,
                    PaymentId,
                    min(CreatedDate) as CreatedDate,
		            CreatedBy
               from Cstm_Conv_Map_ARLedger
              where PaymentId is not null
              group by ChargeId,
                       PaymentId,
		       CreatedBy) p on p.ChargeId = arm.ChargeId and
                                       abs(datediff(ss, p.CreatedDate, arm.CreatedDate)) between 0 and 60
					--RJN 1/8/2007 There are instances where this logic doesn''t hold.  Separate transactions are being grouped together.
					and p.createdBy = arm.CreatedBy
 where bl.subtype in (''CD'', ''WO'')
   and arm.ActivityType is null

if @@error <> 0 goto error

-- Transfers are part of the payment activity within the same service
update arm
   set ActivityId = p.PaymentId
  from Cstm_Conv_Map_ARLedger arm
       join Psych..Billing_Ledger bl on bl.billing_ledger_no = arm.billing_ledger_no
       join (select ServiceId,
                    PaymentId,
                    min(CreatedDate) as CreatedDate,
                    CreatedBy
               from Cstm_Conv_Map_ARLedger
              where PaymentId is not null
              group by ServiceId,
                       PaymentId,
                       CreatedBy) p on p.ServiceId = arm.ServiceId and
                                       abs(datediff(ss, p.CreatedDate, arm.CreatedDate)) between 0 and 60
					--SF 1/29/2007
					and p.CreatedBy = arm.CreatedBy
 where bl.subtype in (''ND'')
   and arm.ActivityType is null


if @@error <> 0 goto error

update arm
   set ActivityType = case when p.patient_id is null
                           then @PayerPayment
                           else @ClientPayment
                      end
  from Cstm_Conv_Map_ARLedger arm
       join Cstm_Conv_Map_Payments pm on pm.PaymentId = arm.ActivityId
       join Psych..Payment2 p on p.payment_id = pm.payment_id        
 where arm.ActivityType is null



if @@error <> 0 goto error

-- Adjustment/Write Off
update arm
   set ActivityType = @Adjustment
  from Cstm_Conv_Map_ARLedger arm
 where arm.ActivityType is null

if @@error <> 0 goto error

--
-- Financial Activity
--
create table #ARActivities
(FinancialActivityLineId int identity not null,
ServiceId int null,
ActivityType int null,
CreatedDate datetime null,
CreatedBy varchar(30) null,
FinancialActivityLineChargeId int null,
)

create table #ARActivitiesLedgerCount
(ServiceId int null,
ActivityType int null,
CreatedDate datetime null,
CreatedBy varchar(30) null,
ChargeId int null,
UsedCnt int null,
)

  while exists(select * from Cstm_Conv_Map_ARLedger where FinancialActivityLineId is null)
  begin

	delete from #ARActivities
	
	insert into #ARActivities
	(ServiceId, ActivityType, CreatedDate,  CreatedBy)
	select ServiceId, ActivityType, CreatedDate, CreatedBy
      from Cstm_Conv_Map_ARLedger arm
     where /*ServiceId = @ServiceId
       and*/ FinancialActivityLineId is null
       and not exists(select *
                        from Cstm_Conv_Map_ARLedger arm2
                       where arm2.ServiceId = arm.ServiceId
                         --and arm2.ActivityType = arm.ActivityType
                         and arm2.FinancialActivityLineId is null
                         and arm2.CreatedDate < arm.CreatedDate)
     order by ServiceId

    -- Leave  only 1 record per serviceid in #ARActivities table
	delete a
	from #ARActivities a
	where exists
	(select * from #ARActivities b
	where a.ServiceId = b.ServiceId
	and b.FinancialActivityLineId > a.FinancialActivityLineId)
	
    -- Figure out a charge ID that should be associated with the activity line
    
    update a
	set FinancialActivityLineChargeId = b.ChargeId
    from #ARActivities a
    JOIN #ARLedgerCharges b ON  (a.ServiceId  = b.ServiceId)
    where a.ActivityType = @ServiceComplete

    update a
    set FinancialActivityLineChargeId = b.ChargeId
    from #ARActivities a
    JOIN Cstm_Conv_Map_ARLedger b ON  (a.ServiceId  = b.ServiceId
    and a.ActivityType = b.ActivityType
    and a.CreatedBy = b.CreatedBy)
    where a.ActivityType in (@PayerPayment, @ClientPayment)
	and abs(datediff(ss, b.CreatedDate, a.CreatedDate)) between 0 and 60
    and b.PaymentId is not null      
      
    delete from #ARActivitiesLedgerCount
    
    insert into #ARActivitiesLedgerCount
    (ServiceId, ActivityType, CreatedDate, CreatedBy, ChargeId, UsedCnt)
    select a.ServiceId, a.ActivityType, a.CreatedDate, a.CreatedBy, b.ChargeId, count(*)
    from #ARActivities a
    JOIN Cstm_Conv_Map_ARLedger b ON  (a.ServiceId  = b.ServiceId
    and a.ActivityType = b.ActivityType
    and a.CreatedBy = b.CreatedBy)
    where a.ActivityType = @Adjustment
    and abs(datediff(ss, b.CreatedDate, a.CreatedDate)) between 0 and 60
    group by a.ServiceId, a.ActivityType, a.CreatedDate, a.CreatedBy, b.ChargeId
    
    update a
	set FinancialActivityLineChargeId = b.ChargeId
    from #ARActivities a
    JOIN #ARActivitiesLedgerCount b ON  (a.ServiceId  = b.ServiceId
    and a.ActivityType = b.ActivityType
    and a.CreatedBy = b.CreatedBy)
    where not exists
    (select * from #ARActivitiesLedgerCount c
    where a.ServiceId  = c.ServiceId
    and a.ActivityType = c.ActivityType
    and a.CreatedBy = c.CreatedBy
    and c.UsedCnt > b.UsedCnt)
    
    
    update b
       set FinancialActivityLineId = a.FinancialActivityLineId,
           FinancialActivityLineChargeId = a.FinancialActivityLineChargeId,
           ActivityId = isnull(ActivityId, a.FinancialActivityLineId)
    from #ARActivities a
    JOIN Cstm_Conv_Map_ARLedger b ON  (a.ServiceId  = b.ServiceId
    and a.ActivityType = b.ActivityType
    and a.CreatedBy = b.CreatedBy)
    where abs(datediff(ss, b.CreatedDate, a.CreatedDate)) between 0 and 60

    if @@error <> 0 goto error
  
  end 


--
-- Financial Activity
--


insert into #Activity (
       ActivityType,
       ActivityId)
select ActivityType,
       ActivityId
  from Cstm_Conv_Map_ARLedger
 group by ActivityType, ActivityId

if @@error <> 0 goto error

update arm
   set FinancialActivityId = a.FinancialActivityId
  from Cstm_Conv_Map_ARLedger arm
       join #Activity a on a.ActivityType = arm.ActivityType and a.ActivityId = arm.ActivityId

if @@error <> 0 goto error

insert into #Activity (
       ActivityType,
       ActivityId)
select case when p.patient_id is not null then @ClientPayment else @PayerPayment end,
       pm.PaymentId
  from Cstm_Conv_Map_Payments pm 
       join Psych..Payment2 p on p.payment_id = pm.payment_id
 where not exists(select * 
                    from #Activity a 
                   where a.ActivityType in (@PayerPayment, @ClientPayment) 
                     and a.ActivityId = pm.PaymentId)

if @@error <> 0 goto error

set identity_insert FinancialActivities on

insert into FinancialActivities (
       FinancialActivityId,
       PayerId,
       CoveragePlanId,
       ClientId,
       ActivityType,
       CreatedBy,
       CreatedDate,
       ModifiedBy,
       ModifiedDate)
select a.FinancialActivityId,
       null,
       ccp.CoveragePlanId,
       case when ccp.CoveragePlanId is null then s.ClientId else null end,
       a.ActivityType,
       c.CreatedBy,
       c.CreatedDate,
       c.CreatedBy,
       c.CreatedDate
  from #Activity a 
       join Services s on s.ServiceId = a.ActivityId
       join #ARLedgerCharges lc on lc.ServiceId = s.ServiceId
       join Charges c on c.ChargeId = lc.ChargeId
       left join ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = c.ClientCoveragePlanId
 where a.ActivityType = @ServiceComplete
union
select a.FinancialActivityId,
       null,
       cp.CoveragePlanId,
       cm.ClientId,
       a.ActivityType,
       isnull(p.orig_user_id, ''sa''),
       p.orig_entry_chron,
       isnull(p.user_id, ''sa''),
       p.entry_chron
  from #Activity a
       join Cstm_Conv_Map_Payments pm on pm.PaymentId = a.ActivityId
       join Psych..Payment2 p on p.payment_id = pm.payment_id
       left join Cstm_Conv_Map_CoveragePlans cpm on cpm.coverage_plan_id = p.coverage_plan_id and
                                                    cpm.hosp_status_code = p.hosp_status_code
       left join CoveragePlans cp on cp.CoveragePlanId = cpm.CoveragePlanId
       left join Cstm_Conv_Map_Clients cm on cm.patient_id = p.patient_id
 where a.ActivityType in (@PayerPayment, @ClientPayment)
union
select a.FinancialActivityId,
       null,
       ccp.CoveragePlanId,
       case when ccp.CoveragePlanId is null then s.ClientId else null end,
       a.ActivityType,
       arm.CreatedBy,
       arm.CreatedDate,
       arm.CreatedBy,
       arm.CreatedDate
  from #Activity a
       join Cstm_Conv_Map_ARLedger arm on arm.FinancialActivityId = a.FinancialActivityId
       join Services s on s.ServiceId = arm.ServiceId
       join Charges c on c.ChargeId = arm.FinancialActivityLineChargeId
       left join ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = c.ClientCoveragePlanId
 where a.ActivityType = @Adjustment
   and not exists(select * 
                    from Cstm_Conv_Map_ARLedger arm2
                   where arm2.FinancialActivityId = arm.FinancialActivityId
                     and arm2.ARLedgerId < arm.ARLedgerId)

if @@error <> 0 goto error

set identity_insert FinancialActivities off

set identity_insert FinancialActivityLines on

insert into FinancialActivityLines (
       FinancialActivityLineId,
       FinancialActivityId,
       ChargeId,
       CurrentVersion,
       Flagged,
       Comment,
       CreatedBy,
       CreatedDate,
       ModifiedBy,
       ModifiedDate)
select arm.FinancialActivityLineId,
       arm.FinancialActivityId,
       arm.FinancialActivityLineChargeId,
       1,
       null, --Flagged
       null, --Comment
       arm.CreatedBy,
       arm.CreatedDate,
       arm.CreatedBy,
       arm.CreatedDate
  from Cstm_Conv_Map_ARLedger arm
 where not exists(select * 
                    from Cstm_Conv_Map_ARLedger arm2
                   where arm2.FinancialActivityLineId = arm.FinancialActivityLineId
                     and arm2.ARLedgerId < arm.ARLedgerId)

if @@error <> 0 goto error

set identity_insert FinancialActivityLines off

--
-- Payments
--

-- create globalcode entries for source dynamically
delete from dbo.GlobalCodes where Category = ''PAYMENTSOURCE''

if @@error <> 0 goto error

insert into dbo.GlobalCodes 
        (
         Category,
         CodeName,
         Description,
         Active,
         CannotModifyNameOrDelete,
         SortOrder
        )
select ''PAYMENTSOURCE'', 
case when source_type is null then '''' else source_type + case when source is not null then ''/'' else '''' end end + ISNULL(source, ''''),
case when source_type is null then '''' else source_type + case when source is not null then ''/'' else '''' end end + ISNULL(source, '''') + '' (imported from PC)'',
''Y'',
''N'',
ROW_NUMBER() over(order by case when source_type is null then '''' else source_type + case when source is not null then ''/'' else '''' end end + ISNULL(source, ''''))
from psych.dbo.payment
where LEN(case when source_type is null then '''' else source_type + case when source is not null then ''/'' else '''' end end + ISNULL(source, '''')) > 0
group by
case when source_type is null then '''' else source_type + case when source is not null then ''/'' else '''' end end + ISNULL(source, '''')

if @@error <> 0 goto error





set identity_insert Payments on

insert into Payments(
       PaymentId, 
       FinancialActivityId, 
       PayerId, 
       CoveragePlanId, 
       ClientId, 
       DateReceived, 
       NameIfNotClient, 
       ElectronicPayment, 
       PaymentMethod, 
       ReferenceNumber, 
       CardNumber, 
       ExpirationDate, 
       Amount, 
       LocationId, 
       PaymentSource, 
       UnpostedAmount, 
       Comment, 
       CreatedBy, 
       CreatedDate, 
       ModifiedBy, 
       ModifiedDate)
select pm.PaymentId,
       fa.FinancialActivityId,
       fa.PayerId,
       fa.CoveragePlanId,
       fa.ClientId,
       p.instrument_date, --DateReceived
       cp.DisplayAs, --NameIfNotClient
       ''N'', --case when p.source_type = ''SY'' then ''Y'' else ''N'' end, --ElectronicPayment
       gcm.GlobalCodeId, -- Payment Method 
       p.doc_reference, 
       null, --CardNumber
       null, --ExpirationDate
       p.payment_amount, 
       null, --LocationId, 
       gc.GlobalCodeId, --PaymentSource
       p.balance_amount, --UnpostedAmount 
       p.remark, 
       isnull(p.orig_user_id, ''sa''), 
       p.orig_entry_chron, 
       isnull(p.user_id, ''sa''), 
       p.entry_chron
  from Cstm_Conv_Map_Payments pm
       join Psych..Payment2 p on p.payment_id = pm.payment_id
       join #Activity a on a.ActivityType in (@PayerPayment, @ClientPayment) and a.ActivityId = pm.PaymentId
       join FinancialActivities fa on fa.FinancialActivityId = a.FinancialActivityId
       left join CoveragePlans cp on cp.CoveragePlanId = fa.CoveragePlanId 
       left join Cstm_Conv_Map_GlobalCodes gcm on gcm.Category = ''PAYMENTMETHOD'' and
                                                  gcm.code = p.instrument
	   LEFT join dbo.GlobalCodes as gc on gc.category = ''PAYMENTSOURCE''
			and gc.codeName = case when source_type is null then '''' else source_type + case when source is not null then ''/'' else '''' end end + ISNULL(source, '''')

if @@error <> 0 goto error

set identity_insert Payments off

if @@error <> 0 goto error
          
--
-- Refunds
--

insert into Refunds(
       PaymentId, 
       Correction, 
       Amount, 
       RefundDate, 
       Comment, 
       CreatedBy, 
       CreatedDate, 
       ModifiedBy, 
       ModifiedDate)
select pm.PaymentId,
       ''N'', --Correction
       bl.amount,
       bl.accounting_date,
       null, -- Comment
       bl.orig_user_id,
       bl.orig_entry_chron,
       bl.orig_user_id,
       bl.orig_entry_chron
  from Psych..Billing_Ledger bl
       join Cstm_Conv_Map_Payments pm on pm.billing_ledger_no = bl.billing_ledger_no
 where bl.subtype = ''RF''
 
if @@error <> 0 goto error
                   
 
--
-- AR Ledger
--


set identity_insert ARLedger on


insert into ARLedger(
       ARLedgerId, 
       ChargeId, 
       FinancialActivityLineId,
       FinancialActivityVersion,
       LedgerType, 
       Amount, 
       PaymentId, 
       AdjustmentCode,
       AccountingPeriodId,
       PostedDate,
       ClientId,
       CoveragePlanId, 
       DateOfService, 
       MarkedAsError,
       ErrorCorrection,
       CreatedBy,
       CreatedDate, 
       ModifiedBy, 
       ModifiedDate)
select arm.ARLedgerId,
       arm.ChargeId,
       arm.FinancialActivityLineId,
       1,
       arm.LedgerType,
       arm.Amount, 
       arm.PaymentId, 
       arm.AdjustmentCode,
       ap.AccountingPeriodId,
       bl.posted_date,
       s.ClientId,
       ccp.CoveragePlanId, 
       s.DateOfService, 
       ''N'', --MarkedAsError
       ''N'', --ErrorCorrection
       arm.CreatedBy,
       arm.CreatedDate, 
       arm.CreatedBy,
       arm.CreatedDate
  from Cstm_Conv_Map_ARLedger arm
       join Psych..Billing_Ledger bl on bl.billing_ledger_no = arm.billing_ledger_no
       join Services s on s.ServiceId = arm.ServiceId
       join Charges c on c.ChargeId = arm.ChargeId

       left join ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = c.ClientCoveragePlanId
       left join AccountingPeriods ap on ap.StartDate <= bl.accounting_date and
                                         dateadd(dd, 1, ap.EndDate) > bl.accounting_date

if @@error <> 0 goto error

set identity_insert ARLedger off

-- Fix CreatedDate of the Charges table if it is after CreatedDate of the first ARLedger record 
update c
   set CreatedDate = l.CreatedDate,
       CreatedBy = l.CreatedBy
  from Charges c
       join Services s on s.ServiceId = c.ServiceId
       join ARLedger l on l.ChargeId = c.ChargeId
 where c.CreatedDate > l.CreatedDate
   and not exists(select *
                    from ARLedger l2
                  where l2.ChargeId = l.ChargeId
                    and l2.ARLedgerId < l.ARLedgerId)

if @@error <> 0 goto error

--
-- Open Charges
--

insert into OpenCharges (
       ChargeId,
       Balance,
       CreatedBy,
       CreatedDate,
       ModifiedBy,
       ModifiedDate)
select cm.ChargeId,
       btb.balance_amount,
       isnull(btb.user_id, ''sa''),
       btb.orig_entry_chron,
       isnull(btb.user_id, ''sa''),
       btb.entry_chron
  from Psych..Billing_Transaction_Balance btb
       join Cstm_Conv_Map_Charges cm on cm.billing_trans_no = btb.billing_trans_no
 where isnull(btb.balance_amount, 0) <> 0

if @@error <> 0 goto error

--
-- Billing History
--

insert into BillingHistory (
       ChargeId,
       BilledDate,
       CreatedBy,
       CreatedDate,
       ModifiedBy, 
       ModifiedDate)
select cm.ChargeId,
       bh.print_date,
       bh.user_id,
       bh.print_date,
       bh.user_id,
       bh.print_date
  from Psych..Bill_History bh
       join Cstm_Conv_Map_Charges cm on cm.billing_trans_no = bh.billing_trans_no
 order by bh.print_date, cm.ChargeId

if @@error <> 0 goto error

--
-- Update Clients 
--

update c
   set LastPaymentId = p.PaymentId
  from Clients c
       join Payments p on p.ClientId = c.ClientId
 where not exists(select *
                    from Payments p2
                   where p2.ClientId = p.ClientId
                     and p2.DateReceived > p.DateReceived)

if @@error <> 0 goto error

update c
   set CurrentBalance = isnull(ub.UnpaidBalance, 0) - isnull(up.UnpostedAmount, 0)
  from Clients c
       left join (select s.ClientId,
                    sum(arl.Amount) as UnpaidBalance
               from Services s
                    join Charges ch on ch.ServiceId = s.ServiceId
                    join ARLedger arl on arl.ChargeId = ch.ChargeId
              where ch.Priority = 0
              group by s.ClientId) ub on ub.ClientId = c.ClientId
       left join (select Clientid,
                         sum(UnpostedAmount) as UnpostedAmount
                    from Payments
                   where ClientId is not null
                   group by ClientId) up on up.ClientId = c.ClientId                       

if @@error <> 0 goto error

--
-- Convert Billing Ledger Remarks
--

create table #Remarks (
FinancialActivityLineId  int          null,
Remark                   varchar(max) null,
billing_ledger_no        char(10)     null,
Processed                char(1)      null)

insert into #Remarks (
       FinancialActivityLineId,
       Remark,
       billing_ledger_no,
       Processed)
select m.FinancialActivityLineId,
       l.remark,
       min(l.billing_ledger_no) as billing_ledger_no,
       ''N''
  from Psych..Billing_Ledger l
       join cstm_conv_map_ARLedger m on m.billing_ledger_no = l.billing_ledger_no
 where len(l.remark) > 0
 group by FinancialActivityLineId, Remark
 order by billing_ledger_no
 
create index I1_#Remarks on #Remarks(FinancialActivityLineId)

 
while exists(select * from #Remarks where Processed = ''N'')
begin

  update fal
     set Comment = case when fal.Comment is null then r.Remark
                        else convert(varchar(max), fal.Comment) + char(13) + char(10) + r.Remark
                   end     
    from FinancialActivityLines fal
         join #Remarks r on r.FinancialActivityLineId = fal.FinancialActivityLineId
   where r.Processed = ''N''
     and not exists(select *
                      from #Remarks r2
                     where r2.FinancialActivityLineId = r.FinancialActivityLineId
                       and r2.Processed = ''N''
                       and r2.billing_ledger_no < r.billing_ledger_no)
                       
  update r
     set Processed = ''Y''
    from #Remarks r
   where Processed = ''N''
     and not exists(select *
                      from #Remarks r2
                     where r2.FinancialActivityLineId = r.FinancialActivityLineId
                       and r2.Processed = ''N''
                       and r2.billing_ledger_no < r.billing_ledger_no)
                         
 
end

update a
set CreatedDate = b.entry_chron
from Cstm_Conv_Map_Charges a
JOIN Psych..Billing_Transaction b
ON a.billing_trans_no = b.billing_trans_no
where a.CreatedDate <> b.entry_chron

if @@error <> 0 goto error

update a
set CreatedDate = b.CreatedDate
from Charges a
JOIN Cstm_Conv_Map_Charges b ON (a.ChargeId = b.ChargeId)

if @@error <> 0 goto error

--
-- Map adjustment codes
--
update ar set
	AdjustmentCode = mac.GlobalCodeId
from dbo.Cstm_Conv_Map_ARLedger as map
join dbo.ARLedger as ar on ar.ARLedgerId = map.ARLedgerId
join Psych.dbo.Billing_Ledger as bl on bl.billing_ledger_no = map.billing_ledger_no
join psych.dbo.Global_Subcode as sc on sc.category = ''ACCTSUBTYP'' and sc.code = bl.subtype and sc.subcode = bl.reason
join dbo.cstm_conv_map_adjustment_codes as mac on mac.adjustment_code = bl.adjustment_code and mac.reason = bl.reason and mac.SubCodeDescription = sc.name
where LEN(LTRIM(RTRIM(bl.adjustment_code)))  > 0
and LEN(LTRIM(RTRIM(bl.reason)))  > 0
and ar.AdjustmentCode is null

if @@error <> 0 goto error

update ar set
	AdjustmentCode = mac.GlobalCodeId
--select top 100 map.*
from dbo.Cstm_Conv_Map_ARLedger as map
join dbo.ARLedger as ar on ar.ARLedgerId = map.ARLedgerId
join Psych.dbo.Billing_Ledger as bl on bl.billing_ledger_no = map.billing_ledger_no
join (
	select z.subcode, z.name
	from psych.dbo.Global_Subcode as z
	where z.category = ''ACCTSUBTYP''
	group by z.subcode, z.name
)
as sc on sc.subcode = bl.reason
join dbo.cstm_conv_map_adjustment_codes as mac on mac.adjustment_code = bl.adjustment_code and mac.reason = bl.reason and mac.SubCodeDescription = sc.name
where LEN(LTRIM(RTRIM(bl.adjustment_code)))  > 0
and LEN(LTRIM(RTRIM(bl.reason)))  > 0
and ar.AdjustmentCode is null

if @@error <> 0 goto error

update ar set
	AdjustmentCode = mac.GlobalCodeId
from dbo.Cstm_Conv_Map_ARLedger as map
join dbo.ARLedger as ar on ar.ARLedgerId = map.ARLedgerId
join Psych.dbo.Billing_Ledger as bl on bl.billing_ledger_no = map.billing_ledger_no
join dbo.cstm_conv_map_adjustment_codes as mac on mac.adjustment_code = bl.adjustment_code and mac.reason is null
where LEN(LTRIM(RTRIM(bl.adjustment_code)))  > 0
and LEN(LTRIM(RTRIM(ISNULL(bl.reason, ''''))))  = 0
and ar.AdjustmentCode is null

if @@error <> 0 goto error

-- final unmapped reason codes
update ar set
	AdjustmentCode = mac.GlobalCodeId
from dbo.Cstm_Conv_Map_ARLedger as map
join dbo.ARLedger as ar on ar.ARLedgerId = map.ARLedgerId
join Psych.dbo.Billing_Ledger as bl on bl.billing_ledger_no = map.billing_ledger_no
join dbo.cstm_conv_map_adjustment_codes as mac on mac.adjustment_code = bl.adjustment_code and mac.reason is null
where LEN(LTRIM(RTRIM(bl.adjustment_code)))  > 0
and ar.AdjustmentCode is null

if @@error <> 0 goto error

--select bl.*
--from dbo.Cstm_Conv_Map_ARLedger as map
--join dbo.ARLedger as ar on ar.ARLedgerId = map.ARLedgerId
--join Psych.dbo.Billing_Ledger as bl on bl.billing_ledger_no = map.billing_ledger_no
--where LEN(LTRIM(RTRIM(bl.adjustment_code)))  > 0
--and ar.AdjustmentCode is null

if @@error <> 0 goto error

update dbo.ARLedger set AdjustmentCode = null where AdjustmentCode is not null and LedgerType not in (4203,4204)

if @@error <> 0 goto error

-- close accounting periods
update AccountingPeriods
set OpenPeriod = ''N''

if @@error <> 0 goto error

update AccountingPeriods
   set OpenPeriod = ''Y''
 where StartDate >= ''6/1/2012''

if @@error <> 0 goto error

return

error:

raiserror 50001 ''csp_conv_FinancialActvities failed''

return

' 
END
GO
