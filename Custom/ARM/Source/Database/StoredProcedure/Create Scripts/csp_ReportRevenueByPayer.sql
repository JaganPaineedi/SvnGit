/****** Object:  StoredProcedure [dbo].[csp_ReportRevenueByPayer]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportRevenueByPayer]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportRevenueByPayer]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportRevenueByPayer]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_ReportRevenueByPayer] (
	@startDate	smalldatetime = NULL,
	@endDate	smalldatetime = NULL,
	@DateType	int = NULL,
	@ReportType	int = NULL,
	@ProgramId int = -1,
	@PayerTypeId int = -1,
	@StaffId int = -1
	)
/* @Entry is integer passed from the report and is defined in the Report Parameters.*/

AS
BEGIN

SELECT 
	Visits = COUNT(ServiceId),
	AvgFee = SUM(Charges)/COALESCE(COUNT(ServiceId),1),
	OrganizationName = MIN(OrganizationName),
	Description = Case
			When @ReportType=1 Then ''Payer''
			When @ReportType=2 Then ''Payer Type''
			When @ReportType=3 Then ''Coverage Plan''
			When @ReportType=4 Then ''Clinical Proc''
			When @ReportType=5 Then ''Service Area''
			When @ReportType=6 Then ''Program''
			Else '''' End,
	DateType = Case
			When @DateType=1 Then ''Posted Date''
			When @DateType=2 Then ''Accounting Date''
			When @DateType=3 Then ''Date of Service''
			Else ''''  End,
	GroupID, GroupName=Min(GroupName), 
	Charges=Sum(Charges),Adjustments=SUM(Adjustments),Payments=SUM(Payments),
	Program, PayerType, Staff
From (
	Select 
		s.ServiceId,
		f.OrganizationName,
		GROUPID = Case
			When @ReportType=1 Then ISNULL(p.PayerId, -1)
			When @ReportType=2 Then ISNULL(pt.GlobalCodeId, -1) --PayerType
			When @ReportType=3 Then ISNULL(cp.CoveragePlanId, -1)
			When @ReportType=4 Then pc.ProcedureCodeId
			When @ReportType=5 Then sa.ServiceAreaId
			When @ReportType=6 Then pro.ProgramId
			Else NULL End,
		GROUPNAME = Case
			When @ReportType=1 Then ISNULL(p.PayerName, ''Self Pay'')
			When @ReportType=2 Then ISNULL(pt.CodeName, ''Self Pay'') --PayerType
			When @ReportType=3 Then ISNULL(cp.CoveragePlanName, ''Self Pay'')
			When @ReportType=4 Then pc.ProcedureCodeName
			When @ReportType=5 Then sa.ServiceAreaName
			When @ReportType=6 Then pro.ProgramName
			Else NULL End,
		--p.PayerId,pt.GlobalCodeId,cp.CoveragePlanId,pc.ProcedureCodeId,sa.ServiceAreaId,pro.ProgramId,
		Charges = CASE
			when ar.ledgertype in (4201, 4204) then ar.amount
			else 0 end,
		Adjustments = CASE
			When ar.ledgertype = 4203 then ar.amount
			else 0 end,
		Payments = CASE
			when ar.ledgertype = 4202 then ar.amount
			else 0 end,
		Program = CASE WHEN @ProgramId = -1 THEN ''All'' ELSE pro.ProgramName END,
		PayerType = CASE WHEN @PayerTypeId = -1 THEN ''All'' ELSE pt.CodeName END,
		Staff = CASE WHEN @StaffId = -1 THEN ''All'' ELSE st.LastName + '', '' + st.FirstName + COALESCE('' '' + st.MiddleName + ''.'','''') END
		--VisitCount = RANK() OVER(PARTITION BY s.ServiceId ORDER BY GROUPID)
	From
	Services s
	Join charges c on c.serviceid = s.serviceid
	Join arledger ar on ar.chargeid = c.chargeid
	join dbo.AccountingPeriods as ap on ap.AccountingPeriodId = ar.AccountingPeriodId
	LEFT JOIN Staff st ON st.StaffId = s.ClinicianId
	LEFT JOIN Programs pro ON pro.ProgramId = s.ProgramId
	LEFT JOIN ServiceAreas sa ON sa.ServiceAreaId = pro.ServiceAreaId
	Left Join ProcedureCodes pc ON pc.ProcedureCodeId = s.ProcedureCodeId
	LEFT join dbo.ClientCoveragePlans as ccp on ccp.ClientCoveragePlanId = c.ClientCoveragePlanId
	Left Join CoveragePlans cp ON cp.CoveragePlanId = ccp.CoveragePlanId
	Left Join Payers p ON p.PayerId = cp.PayerId
	Left Join GlobalCodes pt ON pt.globalCodeId = p.PayerType
	Cross Join SystemConfigurations f
	Where (@DateType <> 1 OR (DATEDIFF(DAY, ar.PostedDate, @StartDate) <= 0 and DATEDIFF(DAY, ar.PostedDate, @endDate) >= 0))
	AND	(@DateType <> 2 OR (DATEDIFF(DAY, ap.EndDate, @StartDate) <= 0 and DATEDIFF(DAY, ap.StartDate, @endDate) >= 0))
	AND	(@DateType <> 3 OR (DATEDIFF(DAY, s.DateOfService, @StartDate) <= 0 and DATEDIFF(DAY, s.dateOfService, @endDate) >= 0))
	AND	(@ProgramId = -1 OR pro.ProgramId = @ProgramId) 
	AND	(@PayerTypeId = -1 OR pt.GlobalCodeId = @PayerTypeID) 
	AND	(@StaffId = -1 OR st.StaffId = @StaffId)
--	AND IsNull(s.RecordDeleted,''N'') <> ''Y''
--	AND IsNull(c.RecordDeleted,''N'') <> ''Y''
	AND IsNull(ar.RecordDeleted,''N'') <> ''Y''
	--AND IsNull(st.RecordDeleted,''N'') <> ''Y''
	--AND IsNull(pro.RecordDeleted,''N'') <> ''Y''
	--AND IsNull(sa.RecordDeleted,''N'') <> ''Y''
	) as Revenue
Where GroupId Is Not NULL
Group By Groupid, Program, PayerType, Staff
Order By GroupName

END

' 
END
GO
