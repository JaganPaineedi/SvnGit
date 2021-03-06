/****** Object:  StoredProcedure [dbo].[csp_ReportPrintCorporateStatement]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportPrintCorporateStatement]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportPrintCorporateStatement]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportPrintCorporateStatement]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
--[csp_ReportPrintCorporateStatement] 445

CREATE procedure [dbo].[csp_ReportPrintCorporateStatement]

@ClaimBatchId  int = null,
@ClaimProcessId int = null
/*
Purpose: Selects data to print on Corporate Statement based on HCFA1500 claim form data.
      Either @ClaimBatchId or @ClaimProcessId has to be passed in.  InvoiceId is the ClaimLineItemGroupId from
      ClaimsNPIHCFA1500s

Updates: 
Date         Author       Purpose


*/                 

as
begin

IF object_id(''tempdb..#ChargeSummary'') IS NOT NULL
  Drop Table #ChargeSummary
  
Create Table #ChargeSummary (
ClaimLineItemGroupId int,
ClientName varchar(100),
Period varchar(11),
DateofService datetime,
ProcedureCodeName varchar(200),
Charges money,
NumberCharges int,
PayerNameAndAddress varchar(100),
TaxId varchar(25)
)

Insert Into #ChargeSummary
(ClientName,Period,DateofService,ProcedureCodeName,Charges,NumberCharges)
select Field2PatientName,Field24aFromYY1+Field24aFromMM1, DateofService=Convert(datetime,Field24aFromYY1+Field24aFromMM1+Field24aFromDD1),
	ProcedureCodeName=Coalesce(pc.ProcedureCodeName,''''),
	Charges=Field24fCharges11,NumberCharges=Coalesce(Field24gUnits1,0)
	from claimnpihcfa1500s c
       join ClaimLineItemGroups clig on clig.ClaimLineItemGroupId = c.ClaimLineItemGroupId
       join ClaimBatches cb on cb.ClaimBatchId = clig.ClaimBatchId
       left join ProcedureCodes pc on pc.ProcedureCodeName = c.Field24dProcedureCode1
 where (cb.ClaimBatchId = @ClaimBatchId or cb.ClaimProcessId = @ClaimProcessId)
   and isnull(clig.RecordDeleted, ''N'') = ''N''
   and isnull(c.RecordDeleted, ''N'') = ''N'' union all
select Field2PatientName,Field24aFromYY2+Field24aFromMM2, DateofService=Convert(datetime,Field24aFromYY2+Field24aFromMM2+Field24aFromDD2),
	ProcedureCodeName=Coalesce(pc.ProcedureCodeName,''''),
	Charges=Field24fCharges12,NumberCharges=Coalesce(Field24gUnits2,0)
	from claimnpihcfa1500s c
       join ClaimLineItemGroups clig on clig.ClaimLineItemGroupId = c.ClaimLineItemGroupId
       join ClaimBatches cb on cb.ClaimBatchId = clig.ClaimBatchId
       left join ProcedureCodes pc on pc.ProcedureCodeName = c.Field24dProcedureCode2
 where (cb.ClaimBatchId = @ClaimBatchId or cb.ClaimProcessId = @ClaimProcessId)
   and isnull(clig.RecordDeleted, ''N'') = ''N''
   and isnull(c.RecordDeleted, ''N'') = ''N'' union all
select Field2PatientName,Field24aFromYY3+Field24aFromMM3, DateofService=Convert(datetime,Field24aFromYY3+Field24aFromMM3+Field24aFromDD3),
	ProcedureCodeName=Coalesce(pc.ProcedureCodeName,''''),
	Charges=Field24fCharges13,NumberCharges=Coalesce(Field24gUnits3,0)
	from claimnpihcfa1500s c
       join ClaimLineItemGroups clig on clig.ClaimLineItemGroupId = c.ClaimLineItemGroupId
       join ClaimBatches cb on cb.ClaimBatchId = clig.ClaimBatchId
       left join ProcedureCodes pc on pc.ProcedureCodeName = c.Field24dProcedureCode3
 where (cb.ClaimBatchId = @ClaimBatchId or cb.ClaimProcessId = @ClaimProcessId)
   and isnull(clig.RecordDeleted, ''N'') = ''N''
   and isnull(c.RecordDeleted, ''N'') = ''N'' union all
select Field2PatientName,Field24aFromYY4+Field24aFromMM4, DateofService=Convert(datetime,Field24aFromYY4+Field24aFromMM4+Field24aFromDD4),
	ProcedureCodeName=Coalesce(pc.ProcedureCodeName,''''),
	Charges=Field24fCharges14,NumberCharges=Coalesce(Field24gUnits4,0)
	from claimnpihcfa1500s c
       join ClaimLineItemGroups clig on clig.ClaimLineItemGroupId = c.ClaimLineItemGroupId
       join ClaimBatches cb on cb.ClaimBatchId = clig.ClaimBatchId
       left join ProcedureCodes pc on pc.ProcedureCodeName = c.Field24dProcedureCode4
 where (cb.ClaimBatchId = @ClaimBatchId or cb.ClaimProcessId = @ClaimProcessId)
   and isnull(clig.RecordDeleted, ''N'') = ''N''
   and isnull(c.RecordDeleted, ''N'') = ''N'' union all
select Field2PatientName,Field24aFromYY5+Field24aFromMM5, DateofService=Convert(datetime,Field24aFromYY5+Field24aFromMM5+Field24aFromDD5),
	ProcedureCodeName=Coalesce(pc.ProcedureCodeName,''''),
	Charges=Field24fCharges15,NumberCharges=Coalesce(Field24gUnits5,0)
	from claimnpihcfa1500s c
       join ClaimLineItemGroups clig on clig.ClaimLineItemGroupId = c.ClaimLineItemGroupId
       join ClaimBatches cb on cb.ClaimBatchId = clig.ClaimBatchId
       left join ProcedureCodes pc on pc.ProcedureCodeName = c.Field24dProcedureCode5
 where (cb.ClaimBatchId = @ClaimBatchId or cb.ClaimProcessId = @ClaimProcessId)
   and isnull(clig.RecordDeleted, ''N'') = ''N''
   and isnull(c.RecordDeleted, ''N'') = ''N'' union all
select Field2PatientName,Field24aFromYY6+Field24aFromMM6, DateofService=Convert(datetime,Field24aFromYY6+Field24aFromMM6+Field24aFromDD6),
	ProcedureCodeName=Coalesce(pc.ProcedureCodeName,''''),
	Charges=Field24fCharges16,NumberCharges=Coalesce(Field24gUnits6,0)
	from claimnpihcfa1500s c
       join ClaimLineItemGroups clig on clig.ClaimLineItemGroupId = c.ClaimLineItemGroupId
       join ClaimBatches cb on cb.ClaimBatchId = clig.ClaimBatchId
       left join ProcedureCodes pc on pc.ProcedureCodeName = c.Field24dProcedureCode6
 where (cb.ClaimBatchId = @ClaimBatchId or cb.ClaimProcessId = @ClaimProcessId)
   and isnull(clig.RecordDeleted, ''N'') = ''N''
   and isnull(c.RecordDeleted, ''N'') = ''N''

update a
set ClaimLineItemGroupId=c.ClaimLineItemGroupId, 
	PayerNameAndAddress=c.PayerNameAndAddress,
	TaxId=c.Field25TaxId
from #ChargeSummary a
	   join claimnpihcfa1500s c on 1=1
       join ClaimLineItemGroups clig on clig.ClaimLineItemGroupId = c.ClaimLineItemGroupId
       join ClaimBatches cb on cb.ClaimBatchId = clig.ClaimBatchId
 where (cb.ClaimBatchId = @ClaimBatchId or cb.ClaimProcessId = @ClaimProcessId)
   and isnull(clig.RecordDeleted, ''N'') = ''N''
   and isnull(c.RecordDeleted, ''N'') = ''N''

Select TodayDate=CONVERT(varchar(25),GETDATE(),107),DateofService = CONVERT(varchar(25),cs.DateofService,107),
	total.ClientName,ProcedureCodeName,
	cs.BillingMonth,cs.NumberCharges,cs.Rate,cs.Charges,cs.PayerNameAndAddress,cs.TaxId,cs.InvoiceId,
	total.TotalCharges, a.PaymentAddressDisplay
From Agency a
Join (       
	Select BillingMonth=DATENAME(month,MIN(DateofService))++'', ''+DATENAME(year,MIN(DateofService)), 
		ProcedureCodeName,DateofService,
		Charges=SUM(Charges), NumberCharges=SUM(NumberCharges), Rate=SUM(Charges)/SUM(NumberCharges),
		PayerNameAndAddress=MIN(PayerNameAndAddress),TaxId=MIN(TaxId),InvoiceId=MIN(ClaimLineItemGroupId)
	From #ChargeSummary
	Where DateofService is not null
	Group By Period,ProcedureCodeName,DateofService
	) cs on 1=1
Join (
	Select ClientName=Min(ClientName), TotalCharges=SUM(Charges)
	From #ChargeSummary
	) total on 1=1
Order by cs.DateofService
	

end

' 
END
GO
