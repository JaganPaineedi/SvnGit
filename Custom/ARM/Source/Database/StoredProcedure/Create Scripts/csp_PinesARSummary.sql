/****** Object:  StoredProcedure [dbo].[csp_PinesARSummary]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PinesARSummary]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PinesARSummary]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PinesARSummary]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/****** Object:  Stored Procedure dbo.csp_PinesARSummary    Script Date: 12/19/2006 8:54:25 AM ******/

CREATE   Procedure [dbo].[csp_PinesARSummary]  
@EndDate datetime
   
AS  
  
/******************************************************************************  
**  File: dbo.csp_PinesARSummary.prc  
**  Name: dbo.csp_PinesARSummary  
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
**  Author:	Date:    	Description:  
**  --------	--------   	-------------------------------------------  
**  JHB		12/15/06	Created
*******************************************************************************/  
  
DECLARE @Id INT,@Amount MONEY,@Date DATETIME  
  
CREATE TABLE #T1 ([Id] INT  IDENTITY (101, 1),  
PayerId INT,PayerName VARCHAR(50), [0-30] MONEY DEFAULT 0,[31-60] MONEY DEFAULT 0,  
[61-90] MONEY DEFAULT 0, [91-120] MONEY DEFAULT 0,[121-150] MONEY DEFAULT 0,[151-180] MONEY DEFAULT 0,  
[181-365] MONEY DEFAULT 0,[>1 Year] MONEY DEFAULT 0,Total MONEY DEFAULT 0)  
  
set @EndDate = dateadd(dd, 1, @EndDate)
  
insert into #T1  
(PayerId, PayerName, [0-30], [31-60], [61-90], [91-120], [121-150],  
[151-180], [181-365], [>1 Year], Total)  
select case when b.Priority = 0 then 0 else d.PayerId end,
       case when b.Priority = 0 then ''Client'' else d.PayerName end,  
[0-30] = sum(case when datediff(dd, g.DateOfService, @EndDate) <= 30 then a.Amount else 0 end),  
[31-60] = sum(case when datediff(dd, g.DateOfService, @EndDate) between 31 and 60 then a.Amount else 0 end),  
[61-90] = sum(case when datediff(dd, g.DateOfService, @EndDate) between 61 and 90 then a.Amount else 0 end),  
[91-120] = sum(case when datediff(dd, g.DateOfService, @EndDate) between 91 and 120 then a.Amount else 0 end),  
[121-150] = sum(case when datediff(dd, g.DateOfService, @EndDate) between 121 and 150 then a.Amount else 0 end),  
[151-180] = sum(case when datediff(dd, g.DateOfService, @EndDate) between 151 and 180 then a.Amount else 0 end),  
[181-365] = sum(case when datediff(dd, g.DateOfService, @EndDate) between 181 and 365 then a.Amount else 0 end),  
[>1 Year] = sum(case when datediff(dd, g.DateOfService, @EndDate) > 365 then a.Amount else 0 end),  
Total = sum(a.Amount)  
from ARLedger a
JOIN Charges b ON (a.ChargeId = b.ChargeId)  
JOIN Services g ON (b.ServiceId = g.ServiceId)  
left JOIN ClientCoveragePlans b1 ON (b.ClientCoveragePlanId = b1.ClientCoveragePlanId)  
left JOIN CoveragePlans c ON  (b1.CoveragePLanId = c.CoveragePLanId)  
left JOIN Payers d ON  (c.PayerId = d.PayerId)  
where a.PostedDate < @EndDate 
group by case when b.Priority = 0 then 0 else d.PayerId end,
       case when b.Priority = 0 then ''Client'' else d.PayerName end
  
 
insert into #T1  
(PayerId, PayerName, [0-30], [31-60], [61-90], [91-120], [121-150],  
[151-180], [181-365], [>1 Year], Total)  
 SELECT   
   -1  
 ,''Total''  
 ,SUM([0-30])  
 ,SUM([31-60])  
 ,SUM([61-90])  
 ,SUM([91-120])  
 ,SUM([121-150])  
 ,SUM([151-180])  
 ,SUM([181-365])  
 ,SUM([>1 Year])  
 ,SUM([Total])    
FROM #T1  
  
SELECT [Id],  
       PayerId,
       PayerName,
       [0-30],
       [31-60],  
       [61-90],
       [91-120],
       [121-150],
       [151-180],  
       [181-365],
       [>1 Year],
       Total  
  FROM #T1  
 ORDER BY case PayerId when 0 then ''ZZZZZ0''when -1 then ''ZZZZZ1'' else PayerName end
' 
END
GO
