/****** Object:  StoredProcedure [dbo].[csp_ReportARSummaryByClient]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportARSummaryByClient]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportARSummaryByClient]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportARSummaryByClient]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'  
  
create     Procedure [dbo].[csp_ReportARSummaryByClient]    
@EndDate datetime,  
@ReportType int,  
@ChargesDT int,  
@PaymentsDT int,  
@AdjustmentsDT int,  
@ServiceAreaId int,  
@ProgramId int  
     
AS    
BEGIN    
/******************************************************************************    
**  File: dbo.csp_ARSummary.prc    
**  Name: dbo.csp_ARSummary    
**  Desc: Shows AR by Payer  
**    
**  This template can be customized:    
**                  
**  Return values:    
**     
**  Called by:       
**                  
**  Parameters:    
**  Input       Output    
**     ----------       -----------    
**    
**  Auth: Yogesh    
**  Date: 12/15/06    
*******************************************************************************    
**  Change History    
*******************************************************************************    
**  Author: Date:     Description:    
**  -------- --------    -------------------------------------------    
**  JHB  12/15/06 Created  
*******************************************************************************/    
  
--ReportTypes:  
--5-Client  
--6-ThirdPartyAR  
  
--LedgerTypes  
--4201 = Charge  
--4202 = Payment  
--4203 = Adjustment  
--4204 = Transfer  
  
DECLARE @Id INT,@Amount MONEY,@Date DATETIME  
  
CREATE TABLE #T1 (  
[Id] INT,   
GroupId2 int,  
GroupType2 VARCHAR(50),  
GroupName2 VARCHAR(50),  
GroupId int,  
GroupType VARCHAR(50),  
GroupName VARCHAR(50),  
DateType int,  
[DOS_0-30] MONEY DEFAULT 0,  
[DOS_31-60] MONEY DEFAULT 0,    
[DOS_61-90] MONEY DEFAULT 0,   
[DOS_91-120] MONEY DEFAULT 0,  
[DOS_121-150] MONEY DEFAULT 0,  
[DOS_151-180] MONEY DEFAULT 0,    
[DOS_181-365] MONEY DEFAULT 0,  
[DOS_>1 Year] MONEY DEFAULT 0,  
[DOS_Total] MONEY DEFAULT 0,  
[ACT_0-30] MONEY DEFAULT 0,  
[ACT_31-60] MONEY DEFAULT 0,    
[ACT_61-90] MONEY DEFAULT 0,   
[ACT_91-120] MONEY DEFAULT 0,  
[ACT_121-150] MONEY DEFAULT 0,  
[ACT_151-180] MONEY DEFAULT 0,    
[ACT_181-365] MONEY DEFAULT 0,  
[ACT_>1 Year] MONEY DEFAULT 0,  
[ACT_Total] MONEY DEFAULT 0,  
[POS_0-30] MONEY DEFAULT 0,  
[POS_31-60] MONEY DEFAULT 0,    
[POS_61-90] MONEY DEFAULT 0,   
[POS_91-120] MONEY DEFAULT 0,  
[POS_121-150] MONEY DEFAULT 0,  
[POS_151-180] MONEY DEFAULT 0,    
[POS_181-365] MONEY DEFAULT 0,  
[POS_>1 Year] MONEY DEFAULT 0,  
[POS_Total] MONEY DEFAULT 0)    
    
If @ReportType = 5 -- Client by third party  
BEGIN  
 insert into #T1    
  (GroupId2, GroupType2, GroupName2, GroupId, GroupType, GroupName, DateType,  
  [DOS_0-30], [DOS_31-60], [DOS_61-90], [DOS_91-120], [DOS_121-150], [DOS_151-180], [DOS_181-365], [DOS_>1 Year], [DOS_Total] ,  
  [ACT_0-30], [ACT_31-60], [ACT_61-90], [ACT_91-120], [ACT_121-150], [ACT_151-180], [ACT_181-365], [ACT_>1 Year], [ACT_Total],  
  [POS_0-30], [POS_31-60], [POS_61-90], [POS_91-120], [POS_121-150], [POS_151-180], [POS_181-365], [POS_>1 Year], [POS_Total])    
 SELECT   
  GroupId2 = null,  
  GroupType2 = null,   
  GroupName2 = null,   
  GroupId = Cl.ClientId,  
  GroupType = ''Client Name'',   
  GroupName= isnull(Cl.LastName + '', '' + Cl.FirstName, ''Name Missing'') + ''-'' + convert(varchar,Cl.ClientId),   
  DateType = case when a.LedgerType = 4201 or  a.LedgerType = 4204 then @ChargesDT  
   when a.LedgerType = 4202 then @PaymentsDT  
   else @AdjustmentsDT end,  
  [DOS_0-30] = sum(case when datediff(dd, g.DateOfService, @EndDate) between 0 and 30 then a.Amount else 0 end),    
  [DOS_31-60] = sum(case when datediff(dd, g.DateOfService, @EndDate) between 31 and 60 then a.Amount else 0 end),    
  [DOS_61-90] = sum(case when datediff(dd, g.DateOfService, @EndDate) between 61 and 90 then a.Amount else 0 end),    
  [DOS_91-120] = sum(case when datediff(dd, g.DateOfService, @EndDate) between 91 and 120 then a.Amount else 0 end),    
  [DOS_121-150] = sum(case when datediff(dd, g.DateOfService, @EndDate) between 121 and 150 then a.Amount else 0 end),    
  [DOS_151-180] = sum(case when datediff(dd, g.DateOfService, @EndDate) between 151 and 180 then a.Amount else 0 end),    
  [DOS_181-365] = sum(case when datediff(dd, g.DateOfService, @EndDate) between 181 and 365 then a.Amount else 0 end),    
  [DOS_>1 Year] = sum(case when datediff(dd, g.DateOfService, @EndDate) > 365 then a.Amount else 0 end),    
  [DOS_Total] = sum(case when datediff(dd, g.DateOfService, @EndDate) >=0 then a.Amount else 0 end),  
  [ACT_0-30] = sum(case when ap.EndDate < dateadd(dd,1,@EndDate) and datediff(dd, b.CreatedDate, @EndDate) < 31  then a.Amount else 0 end),  
  [ACT_31-60] = sum(case when ap.EndDate < dateadd(dd,1,@EndDate) and datediff(dd, b.CreatedDate, @EndDate) between 31 and 60 then a.Amount else 0 end),  
  [ACT_61-90] = sum(case when ap.EndDate < dateadd(dd,1,@EndDate) and datediff(dd, b.CreatedDate, @EndDate) between 61 and 90 then a.Amount else 0 end),  
  [ACT_91-120] = sum(case when ap.EndDate < dateadd(dd,1,@EndDate) and datediff(dd, b.CreatedDate, @EndDate) between 91 and 120 then a.Amount else 0 end),  
  [ACT_121-150] = sum(case when ap.EndDate < dateadd(dd,1,@EndDate) and datediff(dd, b.CreatedDate, @EndDate) between 121 and 150 then a.Amount else 0 end),  
  [ACT_151-180] = sum(case when ap.EndDate < dateadd(dd,1,@EndDate) and datediff(dd, b.CreatedDate, @EndDate) between 151 and 180 then a.Amount else 0 end),  
  [ACT_181-365] = sum(case when ap.EndDate < dateadd(dd,1,@EndDate) and datediff(dd, b.CreatedDate, @EndDate) between 181 and 365 then a.Amount else 0 end),  
  [ACT_>1 Year] = sum(case when ap.EndDate < dateadd(dd,1,@EndDate) and datediff(dd, b.CreatedDate, @EndDate) > 365 then a.Amount else 0 end),  
  [ACT_Total] = sum(case when ap.EndDate < dateadd(dd,1,@EndDate) then a.Amount else 0 end),  
  [POS_0-30] = sum(case when a.PostedDate < dateadd(dd,1,@EndDate) and datediff(dd, b.CreatedDate, @EndDate)< 31  then a.Amount else 0 end),    
  [POS_31-60] = sum(case when a.PostedDate < dateadd(dd,1,@EndDate) and datediff(dd, b.CreatedDate, @EndDate) between 31 and 60 then a.Amount else 0 end),    
  [POS_61-90] = sum(case when a.PostedDate < dateadd(dd,1,@EndDate) and datediff(dd, b.CreatedDate, @EndDate) between 61 and 90 then a.Amount else 0 end),    
  [POS_91-120] = sum(case when a.PostedDate < dateadd(dd,1,@EndDate) and datediff(dd, b.CreatedDate, @EndDate) between 91 and 120 then a.Amount else 0 end),    
  [POS_121-150] = sum(case when a.PostedDate < dateadd(dd,1,@EndDate) and datediff(dd, b.CreatedDate, @EndDate) between 121 and 150 then a.Amount else 0 end),    
  [POS_151-180] = sum(case when a.PostedDate < dateadd(dd,1,@EndDate) and datediff(dd, b.CreatedDate, @EndDate) between 151 and 180 then a.Amount else 0 end),    
  [POS_181-365] = sum(case when a.PostedDate < dateadd(dd,1,@EndDate) and datediff(dd, b.CreatedDate, @EndDate) between 181 and 365 then a.Amount else 0 end),    
  [POS_>1 Year] = sum(case when a.PostedDate < dateadd(dd,1,@EndDate) and datediff(dd, b.CreatedDate, @EndDate) > 365 then a.Amount else 0 end),    
  [POS_Total] = sum(case when a.PostedDate < dateadd(dd,1,@EndDate) then a.Amount else 0 end)  
 from ARLedger a  
 JOIN AccountingPeriods ap ON ap.AccountingPeriodId = a.AccountingPeriodId  
 JOIN Charges b ON (a.ChargeId = b.ChargeId)    
 JOIN Services g ON (b.ServiceId = g.ServiceId)  
 JOIN Programs Pr ON (g.ProgramId = Pr.ProgramId)  
 JOIN Clients Cl ON (g.ClientId = Cl.ClientId)  
 where b.ClientCoveragePlanId is null  
 and (isnull(@ServiceAreaId,-1) = -1 or Pr.ServiceAreaId = @ServiceAreaId)  
 and (isnull(@ProgramId,-1) = -1 or Pr.ProgramId = @ProgramId)  
 group by Cl.ClientId, isnull(Cl.LastName + '', '' + Cl.FirstName, ''Name Missing'') + ''-'' + convert(varchar,Cl.ClientId),  
  case when a.LedgerType = 4201 or  a.LedgerType = 4204 then @ChargesDT  
   when a.LedgerType = 4202 then @PaymentsDT  
   else @AdjustmentsDT end  
END  
  
  
If @ReportType = 6 -- Client by third party  
BEGIN  
 insert into #T1    
  (GroupId2, GroupType2, GroupName2, GroupId, GroupType, GroupName, DateType,  
  [DOS_0-30], [DOS_31-60], [DOS_61-90], [DOS_91-120], [DOS_121-150], [DOS_151-180], [DOS_181-365], [DOS_>1 Year], [DOS_Total] ,  
  [ACT_0-30], [ACT_31-60], [ACT_61-90], [ACT_91-120], [ACT_121-150], [ACT_151-180], [ACT_181-365], [ACT_>1 Year], [ACT_Total],  
  [POS_0-30], [POS_31-60], [POS_61-90], [POS_91-120], [POS_121-150], [POS_151-180], [POS_181-365], [POS_>1 Year], [POS_Total])    
 SELECT   
  GroupId2 = c.CoveragePlanId,  
  GroupType2 = ''Coverage Plan'',   
  GroupName2 = c.DisplayAs,   
  GroupId = Cl.ClientId,  
  GroupType = ''Client Name'',   
  GroupName= isnull(Cl.LastName + '', '' + Cl.FirstName, ''Name Missing'') + ''-'' + convert(varchar,Cl.ClientId),   
  DateType = case when a.LedgerType = 4201 or  a.LedgerType = 4204 then @ChargesDT  
   when a.LedgerType = 4202 then @PaymentsDT  
   else @AdjustmentsDT end,  
  [DOS_0-30] = sum(case when datediff(dd, g.DateOfService, @EndDate) between 0 and 30 then a.Amount else 0 end),    
  [DOS_31-60] = sum(case when datediff(dd, g.DateOfService, @EndDate) between 31 and 60 then a.Amount else 0 end),    
  [DOS_61-90] = sum(case when datediff(dd, g.DateOfService, @EndDate) between 61 and 90 then a.Amount else 0 end),    
  [DOS_91-120] = sum(case when datediff(dd, g.DateOfService, @EndDate) between 91 and 120 then a.Amount else 0 end),    
  [DOS_121-150] = sum(case when datediff(dd, g.DateOfService, @EndDate) between 121 and 150 then a.Amount else 0 end),    
  [DOS_151-180] = sum(case when datediff(dd, g.DateOfService, @EndDate) between 151 and 180 then a.Amount else 0 end),    
  [DOS_181-365] = sum(case when datediff(dd, g.DateOfService, @EndDate) between 181 and 365 then a.Amount else 0 end),    
  [DOS_>1 Year] = sum(case when datediff(dd, g.DateOfService, @EndDate) > 365 then a.Amount else 0 end),    
  [DOS_Total] = sum(case when datediff(dd, g.DateOfService, @EndDate) >=0 then a.Amount else 0 end),  
  [ACT_0-30] = sum(case when ap.EndDate < dateadd(dd,1,@EndDate) and datediff(dd, b.CreatedDate, @EndDate) < 31  then a.Amount else 0 end),  
  [ACT_31-60] = sum(case when ap.EndDate < dateadd(dd,1,@EndDate) and datediff(dd, b.CreatedDate, @EndDate) between 31 and 60 then a.Amount else 0 end),  
  [ACT_61-90] = sum(case when ap.EndDate < dateadd(dd,1,@EndDate) and datediff(dd, b.CreatedDate, @EndDate) between 61 and 90 then a.Amount else 0 end),  
  [ACT_91-120] = sum(case when ap.EndDate < dateadd(dd,1,@EndDate) and datediff(dd, b.CreatedDate, @EndDate) between 91 and 120 then a.Amount else 0 end),  
  [ACT_121-150] = sum(case when ap.EndDate < dateadd(dd,1,@EndDate) and datediff(dd, b.CreatedDate, @EndDate) between 121 and 150 then a.Amount else 0 end),  
  [ACT_151-180] = sum(case when ap.EndDate < dateadd(dd,1,@EndDate) and datediff(dd, b.CreatedDate, @EndDate) between 151 and 180 then a.Amount else 0 end),  
  [ACT_181-365] = sum(case when ap.EndDate < dateadd(dd,1,@EndDate) and datediff(dd, b.CreatedDate, @EndDate) between 181 and 365 then a.Amount else 0 end),  
  [ACT_>1 Year] = sum(case when ap.EndDate < dateadd(dd,1,@EndDate) and datediff(dd, b.CreatedDate, @EndDate) > 365 then a.Amount else 0 end),  
  [ACT_Total] = sum(case when ap.EndDate < dateadd(dd,1,@EndDate) then a.Amount else 0 end),  
  [POS_0-30] = sum(case when a.PostedDate < dateadd(dd,1,@EndDate) and datediff(dd, b.CreatedDate, @EndDate)< 31  then a.Amount else 0 end),    
  [POS_31-60] = sum(case when a.PostedDate < dateadd(dd,1,@EndDate) and datediff(dd, b.CreatedDate, @EndDate) between 31 and 60 then a.Amount else 0 end),    
  [POS_61-90] = sum(case when a.PostedDate < dateadd(dd,1,@EndDate) and datediff(dd, b.CreatedDate, @EndDate) between 61 and 90 then a.Amount else 0 end),    
  [POS_91-120] = sum(case when a.PostedDate < dateadd(dd,1,@EndDate) and datediff(dd, b.CreatedDate, @EndDate) between 91 and 120 then a.Amount else 0 end),    
  [POS_121-150] = sum(case when a.PostedDate < dateadd(dd,1,@EndDate) and datediff(dd, b.CreatedDate, @EndDate) between 121 and 150 then a.Amount else 0 end),    
  [POS_151-180] = sum(case when a.PostedDate < dateadd(dd,1,@EndDate) and datediff(dd, b.CreatedDate, @EndDate) between 151 and 180 then a.Amount else 0 end),    
  [POS_181-365] = sum(case when a.PostedDate < dateadd(dd,1,@EndDate) and datediff(dd, b.CreatedDate, @EndDate) between 181 and 365 then a.Amount else 0 end),    
  [POS_>1 Year] = sum(case when a.PostedDate < dateadd(dd,1,@EndDate) and datediff(dd, b.CreatedDate, @EndDate) > 365 then a.Amount else 0 end),    
  [POS_Total] = sum(case when a.PostedDate < dateadd(dd,1,@EndDate) then a.Amount else 0 end)  
 from ARLedger a  
 JOIN AccountingPeriods ap ON ap.AccountingPeriodId = a.AccountingPeriodId  
 JOIN Charges b ON (a.ChargeId = b.ChargeId)    
 JOIN Services g ON (b.ServiceId = g.ServiceId)  
 JOIN Programs Pr ON (g.ProgramId = Pr.ProgramId)  
 JOIN Clients Cl ON (g.ClientId = Cl.ClientId)  
 JOIN ClientCoveragePlans b1 ON (b.ClientCoveragePlanId = b1.ClientCoveragePlanId)    
 JOIN CoveragePlans c ON  (b1.CoveragePLanId = c.CoveragePLanId)   
 where (isnull(@ServiceAreaId,-1) = -1 or Pr.ServiceAreaId = @ServiceAreaId)  
 and (isnull(@ProgramId,-1) = -1 or Pr.ProgramId = @ProgramId)  
 group by c.CoveragePlanId, c.DisplayAs, Cl.ClientId, isnull(Cl.LastName + '', '' + Cl.FirstName, ''Name Missing'') + ''-'' + convert(varchar,Cl.ClientId),  
  case when a.LedgerType = 4201 or  a.LedgerType = 4204 then @ChargesDT  
   when a.LedgerType = 4202 then @PaymentsDT  
   else @AdjustmentsDT end  
END  
  
  
  
SELECT   
 SortOrder = RANK() OVER(Order BY CASE WHEN GroupName2 = ''Self Pay'' THEN 999999999 ELSE GroupId2 END),  
 GroupType2, GroupName2,  
 GroupId2,  
 ReportType=GroupType,GroupName,  
 [ID0-30] = SUM(CASE WHEN DateType = 1 THEN [POS_0-30]  
  WHEN DateType = 2 THEN [ACT_0-30]  
  WHEN DateType = 3 THEN [DOS_0-30]  
  ELSE 0 END),  
 [ID31-60] = SUM(CASE WHEN DateType = 1 THEN [POS_31-60]  
  WHEN DateType = 2 THEN [ACT_31-60]  
  WHEN DateType = 3 THEN [DOS_31-60]  
  ELSE 0 END),  
 [ID61-90] = SUM(CASE WHEN DateType = 1 THEN [POS_61-90]  
  WHEN DateType = 2 THEN [ACT_61-90]  
  WHEN DateType = 3 THEN [DOS_61-90]  
  ELSE 0 END),  
 [ID91-120] = SUM(CASE WHEN DateType = 1 THEN [POS_91-120]  
  WHEN DateType = 2 THEN [ACT_91-120]  
  WHEN DateType = 3 THEN [DOS_91-120]  
  ELSE 0 END),  
 [ID121-150] = SUM(CASE WHEN DateType = 1 THEN [POS_121-150]  
  WHEN DateType = 2 THEN [ACT_121-150]  
  WHEN DateType = 3 THEN [DOS_121-150]  
  ELSE 0 END),  
 [ID151-180] = SUM(CASE WHEN DateType = 1 THEN [POS_151-180]  
  WHEN DateType = 2 THEN [ACT_151-180]  
  WHEN DateType = 3 THEN [DOS_151-180]  
  ELSE 0 END),  
 [ID181-365] = SUM(CASE WHEN DateType = 1 THEN [POS_181-365]  
  WHEN DateType = 2 THEN [ACT_181-365]  
  WHEN DateType = 3 THEN [DOS_181-365]  
  ELSE 0 END),  
 [ID>1 Year] = SUM(CASE WHEN DateType = 1 THEN [POS_>1 Year]  
  WHEN DateType = 2 THEN [ACT_>1 Year]  
  WHEN DateType = 3 THEN [DOS_>1 Year]  
  ELSE 0 END),  
 [Total] = SUM(CASE WHEN DateType = 1 THEN [POS_Total]  
  WHEN DateType = 2 THEN [ACT_Total]  
  WHEN DateType = 3 THEN [DOS_Total]  
  ELSE 0 END)  
FROM #T1  
WHERE DateType is not null  
GROUP BY GroupType2, GroupName2, GroupId2, GroupType, GroupName, GroupId, DateType  
HAVING SUM(CASE WHEN DateType = 1 THEN [POS_Total]  
  WHEN DateType = 2 THEN [ACT_Total]  
  WHEN DateType = 3 THEN [DOS_Total]  
  ELSE 0 END) <> 0  
ORDER BY SortOrder  
  
END  
' 
END
GO
