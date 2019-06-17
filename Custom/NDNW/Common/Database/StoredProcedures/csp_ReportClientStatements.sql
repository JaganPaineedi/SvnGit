/****** Object:  StoredProcedure [dbo].[csp_ReportClientStatements]    Script Date: 6/27/2018 10:33:59 AM ******/
if object_id('dbo.csp_ReportClientStatements') is not null 
DROP PROCEDURE [dbo].[csp_ReportClientStatements]
GO

/****** Object:  StoredProcedure [dbo].[csp_ReportClientStatements]    Script Date: 6/27/2018 10:33:59 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[csp_ReportClientStatements]
@ClientStatementId	Int = Null,
@ClientStatementBatchId	Int = Null
AS

/* Just in case the report is ever run without passing parameters return nothing.
   This will prevent the system from returning every row in the ClientStatements table*/
If (@clientStatementId Is Null and @clientStatementBatchId Is Null)
Begin
	Select NULL
End

Create Table #clientStatements
(
ClientStatementId		Int,
AgencyName			Varchar(100),
AgencyAddress			Varchar(250),
AgencyMainPhone			Varchar(20),
ResponsiblePartyName		Varchar(50),
ResponsiblePartyAddress		Varchar(250),
InsuranceBalanceForward		Money,
ClientBalanceForward		Money,
SortOrder			Varchar(50),
ClientName			Varchar(100),
ClientId			Int,
StatementDate			Varchar(10),
DateOfService			Varchar(10),
ProcedureDescription		Varchar(250),
Clinician			Varchar(25),
Charge				Money,
InsurancePayment		Money,
Adjustment			Money,
ClientPayment			Money,
InsuranceBalance		Money,
ClientBalance			Money,
OrganizationName        Varchar(100)
)

Insert Into #clientStatements
Select
b.ClientStatementId,
a.AgencyName,
--a.Address + Char(13)+Char(10) + a.City + ', ' + a.State + ' ' + a.ZipCode,
a.PaymentAddressDisplay,
a.MainPhone,
--a.BillingPhone,
b.ResponsiblePartyName,
b.ResponsiblePartyAddress,
b.InsuranceBalanceForward,
b.ClientBalanceForward,
b.SortOrder,
c.FirstName + ' ' + c.LastName,
b.ClientId,
Convert(Varchar(10),Getdate(),101),
Convert(Varchar(10),d.DateOfService,101),
d.ProcedureDescription,
d.Clinician,
d.Charge,
d.InsurancePayment,
d.Adjustment,
d.ClientPayment,
d.InsuranceBalance,
d.ClientBalance,
s.OrganizationName 


From Agency a
join ClientStatements b On b.ClientStatementBatchId = (Case When @ClientStatementBatchId Is Null Then b.clientStatementBatchId Else @clientStatementBatchId End) And b.ClientStatementId = (Case When @ClientStatementId Is Null Then b.ClientStatementId Else @clientStatementId End)
join Clients c On c.ClientId = b.ClientId
left join ClientStatementDetails d On d.ClientStatementId = b.ClientStatementId
cross join SystemConfigurations s

update c
set c.OrganizationName = sc.OrganizationName
from #clientStatements c
cross join SystemConfigurations sc

Select * From #clientStatements
--where isnull(charge, 0./00) <> 0.00
Order By SortOrder



GO


