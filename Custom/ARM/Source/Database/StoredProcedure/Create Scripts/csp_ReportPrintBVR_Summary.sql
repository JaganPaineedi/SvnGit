/****** Object:  StoredProcedure [dbo].[csp_ReportPrintBVR_Summary]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportPrintBVR_Summary]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportPrintBVR_Summary]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportPrintBVR_Summary]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[csp_ReportPrintBVR_Summary](
	@ClaimBatchId  int = null,
	@AuthorizationId int = null
	)
/*
Purpose: Selects data to print on BVR claim form based on HCFA1500 claim form data.
      Either @ClaimBatchId or @ClaimProcessId has to be passed in.

Updates: 
Date		Author		Purpose
7/9/12      JJN			Created
7/12/12		JJN			Added logic for RDL
8/28/12		JJN			Changed Minute Units to Hours
08.29.2012	avoss		round the charge per vikki weible
09/05/2012	JJN			made changes to expected payments

*/  

AS
Begin

SET FMTONLY OFF


CREATE TABLE #ClaimLines (
	ClaimLineId int IDENTITY,
	ClaimLineItemId int,
	MaximumChargeId int,
	ExpectedPayment float,
	ServiceId int,
	ServiceUnits float,
	CoveragePlanId int,
	BillingCode varchar(25) null,    
	Modifier1 varchar(10) null,    
	Modifier2 varchar(10) null,    
	Modifier3 varchar(10) null,    
	Modifier4 varchar(10) null,    
	ClaimUnits decimal(15,2) null,    
	ChargeAmount Decimal(15,2) null, 
	RevenueCode varchar(25),
	RevenueCodeDescription varchar(200),
	DateofService datetime
	)

Create Table #AuthSummary (
	ServiceId int,
	AuthorizationNumber varchar(50),
	AuthorizationId int, 
	DateRange varchar(50),
	DateofService datetime,
	AuthorizationCodeName varchar(50),
	Rate decimal(15,2),
	Quantity decimal(15,2),
	UnitType varchar(25),
	ChargeAmt decimal(15,2),
	Billable char(1) null,
	ExpectedPayment money,
	ProcedureCodeId int null
	)


create table #ExpectedPayments (
	RecordId int identity not null,        
	ClaimLineId int not null,         
	ExpectedPayment money null,        
	ExpectedAdjustment money null
	)
DELETE FROM #ClaimLines 

INSERT INTO #ClaimLines (ServiceId, ServiceUnits, CoveragePlanId, ClaimUnits, 
	ExpectedPayment, DateofService, MaximumChargeId)
SELECT s.ServiceId,s.Unit,ccp.CoveragePlanId,NULL,
	s.Charge, s.DateofService, c.ChargeId
FROM Services s
JOIN ServiceAuthorizations sa ON sa.ServiceId = s.ServiceId
JOIN Authorizations a ON a.AuthorizationId = sa.AuthorizationId
JOIN Charges c ON c.ServiceId = s.ServiceId
JOIN ClientCoveragePlans ccp ON ccp.ClientCoveragePlanId = c.ClientCoveragePlanId
WHERE sa.AuthorizationId = @AuthorizationId
AND s.DateofService >= a.StartDate AND s.DateofService < DATEADD(dd,1,a.EndDate)

EXEC ssp_PMClaimsGetBillingCodes

--select * from #claimlines

-- Use ExpectedPayments table    
insert into #ExpectedPayments    
(ClaimLineId, ExpectedPayment)    
select CL.ClaimLineId,CL.ClaimUnits*EP.Payment    
from #ClaimLines CL        
JOIN Charges CH ON CL.MaximumChargeId = CH.ChargeId      
JOIN ClientCoveragePlans CCP ON (CH.ClientCoveragePlanId = CCP.ClientCoveragePlanId)    
JOIN CoveragePlans CP ON (CP.CoveragePlanId = CCP.CoveragePlanId)    
JOIN CoveragePlans CP2 ON ((CP.ExpectedPaymentTemplate = ''T'' and CP.CoveragePlanId = CP2.CoveragePlanId)      
	or (CP.ExpectedPaymentTemplate = ''O'' and CP2.CoveragePlanId = CP.UseExpectedPaymentTemplateId))   
JOIN Services S ON CH.ServiceId = S.ServiceId        
JOIN Staff ST ON (S.ClinicianId = ST.StaffId)
JOIN ExpectedPayment EP ON (EP.CoveragePlanId = CP2.CoveragePlanId    
	and CL.BillingCode = EP.BillingCode      
	and ISNULL(CL.Modifier1,'''') = ISNULL(EP.Modifier1,'''')      
	and ISNULL(CL.Modifier2,'''') = ISNULL(EP.Modifier2,'''')      
	and ISNULL(CL.Modifier3,'''') = ISNULL(EP.Modifier3,'''')      
	and ISNULL(CL.Modifier4,'''') = ISNULL(EP.Modifier4,'''')  
	)  
left outer join ExpectedPaymentPrograms EPP on EP.ExpectedPaymentId=EPP.ExpectedPaymentId   
AND isnull(EPP.RecordDeleted,''N'') =''N''   
left outer join ExpectedPaymentLocations EPL on EP.ExpectedPaymentId=EPL.ExpectedPaymentId    
AND isnull(EPL.RecordDeleted,''N'') =''N''     
left outer join ExpectedPaymentDegrees EPD on EP.ExpectedPaymentId=EPD.ExpectedPaymentId    
AND isnull(EPD.RecordDeleted,''N'') =''N''   
left outer join ExpectedPaymentStaff EPS on EP.ExpectedPaymentId=EPS.ExpectedPaymentId     
AND isnull(EPS.RecordDeleted,''N'') =''N''     
where  isnull(EP.RecordDeleted,''N'') =''N'' AND     
EP.FromDate<= S.DateOfService And        
(dateadd(dd, 1, EP.ToDate) > S.DateOfService  or EP.ToDate is NULL) And        
(EP.ClientId= S.ClientId or EP.ClientId is NULL)  
AND (EPP.programId= S.ProgramId or EP.ProgramGroupName is Null)   
AND (EPL.LocationId= S.LocationId or EP.LocationGroupName is NULL)    
AND (EPD.Degree= ST.Degree or EP.DegreeGroupName is NULL)       
AND (EPS.StaffId= S.ClinicianId or EP.StaffGroupName is NULL)    
order by CL.ClaimLineItemId, EP.Priority ASC       

update a        
set ExpectedPayment = b.ExpectedPayment       
from #ClaimLines a        
JOIN #ExpectedPayments b ON (a.ClaimLineId = b.ClaimLineId)        
where not exists        
(select * from #ExpectedPayments d        
where a.ClaimLineId = d.ClaimLineId        
and d.RecordId < b.RecordId)    

--select * from #expectedPayments

INSERT INTO #AuthSummary (
	ServiceId,
	AuthorizationNumber,
	AuthorizationId,
	DateRange,
	DateofService,
	AuthorizationCodeName,
	Rate,
	Quantity,
	UnitType,
	ChargeAmt,
	Billable,
	ExpectedPayment,
	ProcedureCodeId
	)
Select s.ServiceId,
	a.AuthorizationNumber,
	a.AuthorizationId, 
	DateRange = CONVERT(varchar(11),a.StartDate,101)+'' - ''+CONVERT(varchar(11),a.EndDate,101),
	s.DateofService,
	AuthorizationCodeName = RIGHT(ac.AuthorizationCodeName,LEN(ac.AuthorizationCodeName)-CHARINDEX('':'',ac.AuthorizationCodeName)), 
	Rate=case
		when s.ProcedureCodeId = 402 then cl.ExpectedPayment / s.Unit
		WHEN ac.UnitType=120 THEN cl.ExpectedPayment/(CASE WHEN s.unit = 0 THEN 1 ELSE s.Unit/6.0 end)
		when ac.UnitType in (123,124) then cl.ExpectedPayment / a.TotalUnits
		ELSE cl.ExpectedPayment/CASE WHEN s.unit = 0 THEN 1 ELSE s.Unit END
		END,
	Quantity=CASE 
		WHEN ac.UnitType=120 THEN (s.Unit/6.00)		-- convert to 6-minute units
		when s.ProcedureCodeId = 402 then s.Unit
		when ac.UnitType in (123,124) then a.TotalUnits
		ELSE s.Unit 
		END,	
	UnitType=CASE WHEN ac.UnitType IN (120,121)
		THEN ''unit''
		when s.ProcedureCodeId = 402 then ''mile''
		ELSE LOWER(LEFT(ut.CodeName,LEN(ut.CodeName)-1))
		END,
	ChargeAmt=cl.ExpectedPayment,
	Billable=IsNull(s.Billable,''N''),
	cl.ExpectedPayment,
	s.ProcedureCodeId
From ServiceAuthorizations sa
JOIN Authorizations a on sa.AuthorizationId = a.Authorizationid
JOIN AuthorizationCodes ac on ac.AuthorizationCodeId = a.AuthorizationCodeid
JOIN Services s on s.ServiceId = sa.ServiceId
JOIN Charges c on c.ServiceId = sa.ServiceId
JOIN ClaimBatchCharges cbc on cbc.ChargeId = c.ChargeId
JOIN GlobalCodes ut on ut.GlobalCodeId = ac.UnitType
JOIN #ClaimLines cl ON cl.ServiceId = s.ServiceId
Where cbc.ClaimBatchId = @ClaimBatchId
AND sa.AuthorizationId = @AuthorizationId
AND IsNull(sa.RecordDeleted,''N'') <> ''Y''
AND IsNull(a.RecordDeleted,''N'') <> ''Y''
AND IsNull(ac.RecordDeleted,''N'') <> ''Y''
AND IsNull(s.RecordDeleted,''N'') <> ''Y''
AND IsNull(c.RecordDeleted,''N'') <> ''Y''
AND IsNull(cbc.RecordDeleted,''N'') <> ''Y''
AND IsNull(ut.RecordDeleted,''N'') <> ''Y''

--select * from #AuthSummary
--select * from #claimlines

Select Rank=RANK() OVER (ORDER BY DateofService),
	ServiceId=a.ServiceId,
	AuthorizationNumber=a.AuthorizationNumber,
	AuthorizationId=a.AuthorizationId,
	DateRange=a.DateRange,
	DateofService=Convert(varchar(11),DateofService,101),
	AuthorizationCodeName=a.AuthorizationCodeName,
	Rate=CASE WHEN a.UnitType IN (''hr'',''minute'') THEN ''$''+CONVERT(varchar,CONVERT(decimal(15,2),a.Rate))+'' / unit''
		when a.ProcedureCodeId = 402 then ''$''+CONVERT(varchar,CONVERT(decimal(15,2),a.Rate))+'' / mile''
		WHEN a.UnitType IN (''item'',''encounter'') THEN NULL
		ELSE ''$''+CONVERT(varchar,CONVERT(decimal(15,2),a.Rate))+'' / ''+a.UnitType end,
	Quantity=CASE WHEN a.UnitType = ''item'' THEN NULL
		WHEN a.UnitType = ''encounter'' THEN null
		ELSE a.Quantity end,
	ChargeAmt=a.ChargeAmt,
	UnitType=CASE WHEN a.UnitType IN (''item'',''encounter'') THEN NULL 
		ELSE a.UnitType+''s'' end,
	RateTotal=CASE WHEN t.UnitType IN (120,121) THEN ''$''+CONVERT(varchar,CONVERT(decimal(15,2),t.Rate))+'' / unit''
		when a.ProcedureCodeId = 402 THEN ''$''+CONVERT(varchar,CONVERT(decimal(15,2),a.Rate))+'' / mile''
		WHEN t.UnitType IN (123,124) THEN NULL
		ELSE ''$''+CONVERT(varchar,CONVERT(decimal(15,2),a.Rate))+'' / ''+t.UnitTypeName end,
	QuantityTotal=CASE WHEN t.UnitType = 123 THEN NULL
		WHEN t.UnitType = 124 THEN null	--''1.00''
		ELSE CONVERT(varchar,CONVERT(decimal(15,2),t.Quantity)) end,
		
	ChargeAmtTotal=''$''+CONVERT(varchar,CONVERT(decimal(15,2),t.Quantity * t.Rate)),
	UnitTypeTotal=CASE WHEN t.UnitType in (123,124) THEN NULL
		ELSE t.UnitTypeName end
		, t.Quantity, t.rate
From #AuthSummary a
JOIN (
	Select authsum.AuthorizationId,ac.UnitType,Rate=avg(Rate),	
		Quantity=MIN(CASE WHEN ac.UnitType = 120 THEN TotalUnits/6.0
		--when ac.UnitType in (123,124) then 1
			ELSE TotalUnits	END),
		UnitTypeName=CASE WHEN ac.UnitType IN (120,121) THEN ''units''
			ELSE LOWER(MIN(gc.CodeName)) END
	From #AuthSummary authsum
	JOIN Authorizations auth on auth.AuthorizationId = authsum.AuthorizationId
	JOIN AuthorizationCodes ac ON ac.AuthorizationCodeId = auth.AuthorizationCodeId
	JOIN globalCodes gc ON gc.GlobalCodeId = ac.UnitType
	Group By authsum.AuthorizationId,ac.UnitType
	) t ON t.AuthorizationId = a.AuthorizationId
WHERE a.Billable = ''Y''


End
' 
END
GO
