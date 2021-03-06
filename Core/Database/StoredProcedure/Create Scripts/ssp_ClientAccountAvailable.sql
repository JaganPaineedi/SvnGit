/****** Object:  StoredProcedure [dbo].[ssp_ClientAccountAvailable]    Script Date: 11/18/2011 16:25:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ClientAccountAvailable]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ClientAccountAvailable]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ssp_ClientAccountAvailable]          
 /* Param List */              
 @ClientID INT,              
 @PaidUnPaidService INT, --(1: UnPaid Service, 2: Paind and unpaid Services )              
 @Payers INT,   --(-3: All Plans, -2: All Payers, -1: Client,>0 are Coverage plans)              
 @ClinicianId INT,               
 @ProgramId INT,              
 -- @Services INT,   --(1: All Services, 2: All Claims,3: Denied Claims, 4: Unbilled Services, 5: Flagged Claims, 6: Need Authorization) Out of these filter, right now we are working on "Unbilled Services" and "Need Authorization"            
 @Services INT,   -- (1: All Services, 2: Show only service errors)  --Bhupinder Bajwa 10 Jan 2007 REF Task # 275            
 @BalanceDays INT,   --(1: All Balance, 2: 'Balance > 90 Days',3: 'Balance > 180 Days',4: 'Balance > 360 Days')              
 @Dates INT,    --(1: All Dates, 2: Last 30 Days, 3: Last 60 Days, 4:Last 90 Days, 5:Exactly 90 Days)              
 @FromDate DATETIME = NULL,  --(Service happen between FromDate to ToDate)              
 @ToDate DATETIME = NULL              
AS              
/******************************************************************************              
**  File: dbo.ssp_ClientAccountAvailable.prc              
**  Name: ssp_ClientAccountAvailable              
**  Desc: This sp returns the avialable data for client account.              
**              
**  This template can be customized:              
**                            
**  Return values:Client Account Information              
**               
**  Called by:   Client Account Module              
**                            
**  Parameters:              
**  Input       Output              
**     ----------      -----------              
**  Client ID      Return All avialable data to fill defaults and dropdowns              
**  Auth: Vitthal Shinde              
**  Date: 05-Jul-2006              
*******************************************************************************              
**  Change History              
*******************************************************************************              
**  Date:     Author:    Description:              
**  --------  --------   -------------------------------------------              
**  09.19.07  SFarber    Modified to check for the RecordDeleted flag.          
*******************************************************************************/              
/** 02.10.09       Priya      Modified the datatype in lieu of ticket#1147         */   
/*  03/01/2017      vsinha	  What:  Length of "Display As" to handle procedure code display as increasing to 75     
							  Why :  Keystone Customizations 69  */
/*****************************************************************************             
Table 00: Payment charge Summary              
******************************************************************************/               
--Creates Temporary table to store the intermediate results of query.              
--Stores payment summary.              
 BEGIN
 BEGIN TRY             
create table #Charges              
(ServiceId int null,              
ChargeId  int null,              
Priority int null,              
DateOfService datetime null,              
ProcedureCodeId int null,              
Unit int null,              
UnitType int null,              
CoveragePlanId int null,              
InsuredId varchar(25) null,              
Charges money null,              
Unbilled money null,             
Billed money null,  --Added by kuldeep ref task 203 on 21-dec-2006            
Payments money null,              
Adjustments money null,              
Balance  money null,              
BalanceOldDays int null)              
              
create table #Services              
(ServiceId int null,              
DateOfService datetime null,              
ProcedureCodeId int null,              
Unit int null,              
UnitType int null,              
Charges money null,              
Unbilled money null,             
Billed money null,  --Added by kuldeep ref task 203 on 21-dec-2006            
Payments money null,              
Adjustments money null,              
Balance  money null,              
BalanceOldDays int null)              
              
CREATE TABLE #ChargeSummary              
(              
 TempID   INT IDENTITY (1,1),              
 Id    INT,              
 ParentId INT,              
 ServiceId  INT,              
 Priority int ,              
 DOS    VARCHAR(101),              
 DateOfService DateTime,              
 ProcedureName VARCHAR(350),     -- 03/01/2017      vsinha         
 Charges   money,--VARCHAR(20),              
 Unbilled  money,--VARCHAR(20),             
 Billed  money,--VARCHAR(20),  --Added by kuldeep ref task 203 on 21-dec-2006            
 Payments  money,--VARCHAR(20),              
 Adj    money,--VARCHAR(20),              
 Balance   money,--VARCHAR(20),               
 BalDaysOld  INT              
)              
              
if @FromDate = '1/1/1900' set @FromDate = null              
if @ToDate = '1/1/1900' set @ToDate = null              
              
if @Dates <> 1              
begin              
 if @Dates <> 5               
  set @FromDate = Dateadd(dd, case @Dates when 2 then -30 when 3 then -60 when 4 then -90 end              
  , convert(datetime, convert(varchar, getdate(),101)))              
 else               
  set @FromDate = Dateadd(dd, -90, convert(datetime, convert(varchar, getdate(),101)))              
              
 if @Dates = 5               
  set @ToDate = Dateadd(dd, -90, convert(datetime, convert(varchar, getdate(),101)))              
 --else              
 -- set @ToDate = null              
end              
              
/*if @Dates <> 1              
begin              
 if @Dates <> 5               
  set @FromDate = Dateadd(dd, case @Dates when 2 then -30 when 3 then -60 when 4 then -90 end              
  , convert(datetime, convert(varchar, getdate(),101)))              
 else               
  set @FromDate = null              
              
 if @Dates = 5               
  set @ToDate = Dateadd(dd, -90, convert(datetime, convert(varchar, getdate(),101)))              
 else               
  set @ToDate = null              
end*/              
              
--Select @FromDate,@ToDate              
              
insert into #Charges              
(ServiceId, ChargeId, Priority, DateOfService, ProcedureCodeId, Unit,              
UnitType, CoveragePlanId, InsuredId, Charges, Unbilled,Billed, Payments, Adjustments, Balance, BalanceOldDays)              
select a.ServiceId, b.ChargeId, b.Priority, a.DateOfService, a.ProcedureCodeId, a.Unit,              
a.UnitType, e.CoveragePlanId, e.InsuredId,               
sum(case when c.LedgerType in (4201, 4204) then c.Amount else 0 end),               
sum(case when b.LastBilledDate is null then c.Amount else 0 end),             
sum(case when b.LastBilledDate is Not null then c.Amount else 0 end),   --Added by kuldeep ref task 203 on 21-dec-2006             
sum(case when c.LedgerType = 4202 then -c.Amount else 0 end),               
sum(case when c.LedgerType = 4203 then -c.Amount else 0 end),               
sum(c.Amount), datediff(dd , a.DateOfService, getdate())              
from Services  a              
JOIN Charges b ON (a.ServiceId = b.ServiceId)              
JOIN ARLedger c ON (b.ChargeId = c.ChargeId)              
LEFT JOIN OpenCharges d  ON  (b.ChargeId = d.ChargeId)              
LEFT JOIN ClientCoveragePlans e ON (b.ClientCoveragePlanId  = e.ClientCoveragePlanId)              
where a.ClientId = @ClientID              
and isnull(b.RecordDeleted,'N') <> 'Y'              
and isnull(c.RecordDeleted,'N') <> 'Y'              
-- JHB 12/13/06            
--and a.Status <> 76            
-- Bhupinder Bajwa 10 Jan 2007 REF Task # 275            
and ((@Services = 2 and a.Status=76) or (@Services <> 2 and a.Status <> 76))            
and (@PaidUnPaidService = 2 or exists              
(select * from Charges c1              
JOIN OpenCharges d1 ON c1.ChargeId = d1.ChargeId              
where a.ServiceId = c1.ServiceId))              
and (@Payers = -2               
or (@Payers = -3 and (b.Priority > 0 or               
(b.Priority = 0 and exists              
(select * from Charges y              
where b.ServiceId = y.ServiceId              
and b.ChargeId <> y.ChargeId))))              
or (@Payers = -1 and exists              
(select * from Charges y              
where a.ServiceId = y.ServiceId              
and y.Priority = 0))              
or (@Payers > 0 and exists              
(select * from Charges z              
where a.ServiceId = z.ServiceId              
and z.ClientCoveragePlanId = @Payers)))              
and (@ClinicianId = -1 or a.ClinicianId = @ClinicianId)              
and (@ProgramId = -1 or a.ProgramId = @ProgramId)              
and (@BalanceDays = 1               
or (@BalanceDays = 2 and a.DateOfService < Dateadd(dd, -90, convert(datetime, convert(varchar, getdate(),101))))              
or (@BalanceDays = 3 and a.DateOfService < Dateadd(dd, -180, convert(datetime, convert(varchar, getdate(),101))))              
or (@BalanceDays = 4 and a.DateOfService < Dateadd(dd, -360, convert(datetime, convert(varchar, getdate(),101)))))              
and (@FromDate is null or a.DateOfService >= @FromDate)              
and (@ToDate is null or a.DateOfService <= dateadd(dd, 1, @ToDate))              
group by a.ServiceId, b.ChargeId, b.Priority, a.DateOfService,               
a.ProcedureCodeId, a.Unit, a.UnitType, e.CoveragePlanId, e.InsuredId,               
datediff(dd , a.DateOfService, getdate())              
              
insert into #Services              
(ServiceId, DateOfService, ProcedureCodeId, Unit,              
UnitType, Charges, Unbilled,Billed, Payments, Adjustments, Balance, BalanceOldDays)              
select ServiceId, DateOfService, ProcedureCodeId, Unit,              
UnitType, sum(Charges), sum(Unbilled),sum(Billed), sum(Payments), sum(Adjustments),               
sum(Balance), BalanceOldDays              
from #Charges              
group by ServiceId, DateOfService, ProcedureCodeId, Unit,              
UnitType, BalanceOldDays              
            
              
insert into #ChargeSummary              
(Id, ParentId, ServiceId, Priority, DOS,DateOfService, ProcedureName,              
Charges, Unbilled,Billed, Payments,  Adj, Balance, BalDaysOld)              
select 0, a.ServiceId, a.ServiceId, -1, CONVERT(VARCHAR,a.DateOfService,101) + ' '               
+ LTRIM(SUBSTRING(CONVERT(VARCHAR(19),a.DateOfService,100),12,8)),              
 CONVERT(VARCHAR,a.DateOfService,101),              
b.DisplayAs + ' ' + CONVERT(VARCHAR,a.Unit,6) + ' ' + c.CodeName ,              
convert(varchar, a.Charges), convert(varchar, a.Unbilled), convert(varchar, a.Billed),              
convert(varchar, a.Payments),               
convert(varchar, a.Adjustments), convert(varchar, a.Balance),              
convert(varchar, a.BalanceOldDays)              
from #Services a              
JOIN ProcedureCodes b ON (a.ProcedureCodeId = b.ProcedureCodeId)              
JOIN GlobalCodes  c ON (a.UnitType = c.GlobalCodeId)              
UNION              
select 0, a.ServiceId, a.ServiceId, case when a.Priority = 0  then 20000 else a.Priority end,               
CONVERT(VARCHAR,a.DateOfService,101) + ' '               
+ LTRIM(SUBSTRING(CONVERT(VARCHAR(19),a.DateOfService,100),12,8)),              
 CONVERT(VARCHAR,a.DateOfService,101),              
isnull(RTRIM(b.DisplayAs) + ' ' + isnull(a.InsuredId, ''), 'Client'),              
convert(varchar, a.Charges), convert(varchar, a.Unbilled),convert(varchar, a.Billed),               
convert(varchar, a.Payments),               
convert(varchar, a.Adjustments), convert(varchar, a.Balance),              
convert(varchar, a.BalanceOldDays)              
from #Charges a              
LEFT JOIN CoveragePlans b ON (a.CoveragePlanId = b.CoveragePlanId)              
order by 3, 4 asc              
              
update a              
set Id = b.TempID,ServiceId=Null,DOS=null              
from #ChargeSummary a              
JOIN #ChargeSummary b ON (a.ServiceId = b.ServiceId)              
where b.Priority = -1              
and a.Priority <> -1              
              
SELECT               
 TempID as Id,              
 Id as ParentId,              
 ServiceId,        
    
   
      
 cast(DOS as datetime) as DOS,                  
-- convert(datetime,DOS) as DOS,              
 DateOfService,              
 ProcedureName as 'Procedure',              
 CASE                
  WHEN Charges IS NULL THEN '0'              
  ELSE Charges
 END AS Charges,              
 CASE                
  WHEN Unbilled IS NULL THEN '0'              
  ELSE Unbilled               
 END AS Unbilled,            
CASE            
WHEN Billed is Null Then '0'            
ELSE Billed          END As Billed ,             
 CASE                
  WHEN Payments  IS NULL THEN '0'              
  ELSE Payments               
 END AS Payments,              
 CASE                
  WHEN Adj  IS NULL THEN '0'              
  ELSE Adj               
 END AS Adj ,              
 CASE               
  WHEN Balance IS NULL THEN '0'              
  ELSE Balance                
 END AS Balance,              
 BalDaysOld as 'Bal Days Old'              
FROM               
 #ChargeSummary               
Order by 2 ASC,DateOfService Desc        
              
--  ,DOS ASC DateOfService Desc,        
--DROP TABLE #ChargeSummary
END TRY
BEGIN CATCH
   DECLARE @Error varchar(8000)                                            
         SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                             
         + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_ClientAccountAvailable')                                        
         + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                              
         + '*****' + Convert(varchar,ERROR_STATE())                                            
        RAISERROR                                             
   (                                            
     @Error, -- Message text.                                
     16, -- Severity.                                            
     1 -- State.                                            
    ); 
END CATCH
END
GO