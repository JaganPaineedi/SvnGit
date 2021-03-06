/****** Object:  StoredProcedure [dbo].[ssp_PMClientAccountOverview]    Script Date: 11/18/2011 16:25:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMClientAccountOverview]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMClientAccountOverview]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMClientAccountOverview]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[ssp_PMClientAccountOverview]                
@ClientID int                
as                
                
/******************************************************************************                
**  File: dbo.SSP_PMClientAccountOverview.prc                
**  Name: Stored_Procedure_Name                
**  Desc:                 
**                
**  This template can be customized:                
**                              
**  Return values:                
**                 
**  Called by:                   
**                              
**  Parameters:                
**  Input                  
**              ----------                 
**                
**  Auth:                 
**  Date:                 
*******************************************************************************                
**  Change History                
*******************************************************************************                
** Date: Author:  Description:                
** -------- -------- -------------------------------------------                
** 02/10/2007  SFarber         Modified to improve perfromance      
** 16 Oct 2015  Revathi   what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.           
         why:task #609, Network180 Customization  
                  
*******************************************************************************/                
                
/******************************************************************************                
** Table : 00 Client Information                
******************************************************************************/                
declare @UnpaidServices money                
declare @UnpostedAmount money                
/*                
select @UnpaidServices = sum(a.Amount)                
  from Services s                
       join Charges c on c.ServiceId = s.ServiceId                
       join OpenCharges oc on oc.ChargeId = c.ChargeId                
       join ARLedger a on a.ChargeId = c.ChargeId                
 where s.ClientId = @ClientID                
   and c.Priority = 0                
   and isnull(a.RecordDeleted, ''N'') = ''N''                
 group by s.ClientID                
*/                
                
select @UnpostedAmount = sum(UnpostedAmount)                
  from Payments                 
 where ClientId = @ClientID                 
   and isnull(RecordDeleted, ''N'') = ''N''                
 group by ClientId                
                
SELECT   -- Added by Revathi 16 Oct 2015        
   case when  ISNULL(C.ClientType,''I'')=''I'' then ISNULL(C.LastName,'''') + '', '' + ISNULL(C.FirstName,'''') else ISNULL(C.OrganizationName,'''') end   AS ClientName                
  ,case C.FinanciallyResponsible when ''N'' then  CC.LastName + '', '' + CC.FirstName else case when  ISNULL(C.ClientType,''I'')=''I'' then ISNULL(C.LastName,'''') + '', '' + ISNULL(C.FirstName,'''')  else C.OrganizationName end end as FinRespName                
  ,CC.ClientContactId as ClientContactId                
  ,CurrentBalance                
  ,isnull(@UnpostedAmount, 0) as UnpostedAmount                
  ,isnull(c.CurrentBalance, 0) + isnull(@UnpostedAmount, 0) as UnpaidServices                
  ,LastStatementDate                
  ,DoNotSendStatement                
  ,DoNotSendStatementReason                
  ,InformationComplete                
  ,AccountingNotes                
FROM                 
  Clients C                
  LEFT JOIN ClientContacts CC ON CC.FinanciallyResponsible=''Y'' AND                 
                                               C.CLIENTID = cc.ClientID and                
                                               isnull(cc.RecordDeleted, ''N'') = ''N''                
WHERE                 
  C.CLIENTID = @ClientID                
AND                    
  isnull(C.RecordDeleted, ''N'') = ''N''                
                
                
/******************************************************************************                
** Table : 01 Reason Combobox on Client Account overview Page.                
******************************************************************************/                
--  commented by kamaljitsingh ref task#587  dated 587              
--SELECT                 
--   GlobalCodes.GlobalCodeId                
--  ,GlobalCodes.CodeName                
--FROM                 
--  GlobalCodes                
--WHERE                 
--  Category = ''STATEMENTREASON''                
--AND                
--  Active = ''Y''                
--AND               
--  (RecordDeleted IS NULL OR RecordDeleted = ''N'')                
--UNION                
--SELECT                 
--   NULL AS GlobalCodeId                
--  ,'''' AS CodeName           
--                
/******************************************************************************                
** Table : 02 Days Combobox on Client Account overview page.                
******************************************************************************/                
                
SELECT                 
   DayLimitId                
  ,DayLimit                
FROM                
  (                    
   SELECT 1 AS DayLimitId,''Last 30 Days'' as DayLimit                
   UNION ALL                
   SELECT 2 AS DayLimitId,''Last 60 Days'' as DayLimit                
   UNION ALL                
   SELECT 3 AS DayLimitId,''Last 90 Days'' as DayLimit                 
   UNION ALL                
   SELECT 4 AS DayLimitId,''All'' as DayLimit                 
  )                
Days                
ORDER BY DayLimitId                
                
/******************************************************************************                
** Table :03 All Client Notes Information                
 This table is used to show Note Level and Note description on client notes image datagrid                
 on Client Accounts overview. Also it used to check images. If Images are greater than 10                
 then show eillipsis buttton.                
******************************************************************************/                 
--CREATE TABLE #ClientNotesDetail                
--(   NoteId INT IDENTITY (1,1),                
-- ClientId INT,                
-- NoteType INT,                
-- NoteLevel INT,                
-- Note VARCHAR(100),                
-- Bitmap VARCHAR(200)                
--)                 
--INSERT #ClientNotesDetail                
--SELECT                 
--  CN.ClientId                
-- ,CN.NoteType                
-- ,CN.NoteLevel                
-- ,CN.Note                
-- ,GC.Bitmap                 
--FROM                 
-- ClientNotes CN LEFT OUTER JOIN GlobalCodes GC ON CN.NoteType=GC.GlobalCodeId                 
--                
--WHERE                 
-- GC.Category=''ClientNoteType''                          
-- AND                
-- CN.ClientId = 100           
--AND                
-- (CN.RecordDeleted = ''N'' OR CN.RecordDeleted IS NULL) And CN.Active=''Y''                
-- and (CN.StartDate <= Getdate() and isnull(CN.EndDate, DateAdd(yy, 1, GetDate())) >= GetDate())                 
--                
--SELECT * FROM #ClientNotesDetail                
--                
----DROP TABLE #ClientNotesDetail                
--                
--/******************************************************************************                
--** Table : 4 : First 10 Client Notes images to bind datagrid on client account overview page..                
--******************************************************************************/                 
--DECLARE @NoteType INT                
--DECLARE @Bitmap  VARCHAR(250)                
--DECLARE @BitmapNo INT                
--DECLARE @Counter INT                
--DECLARE @TempGroupId INT                
----Declare cursor                
--DECLARE NotesSelect CURSOR FAST_FORWARD FOR                 
--SELECT                 
--  CN.ClientId                
-- ,CN.NoteType                
-- ,GC.Bitmap                 
--FROM                 
-- ClientNotes CN LEFT OUTER JOIN GlobalCodes GC ON CN.NoteType=GC.GlobalCodeId                
--WHERE                 
-- GC.Category=''ClientNoteType''                  
--AND                
-- CN.ClientId = @ClientID                
--AND                
-- (CN.RecordDeleted = ''N'' OR CN.RecordDeleted IS NULL) AND CN.Active=''Y''          
--and (CN.StartDate <= Getdate() and isnull(CN.EndDate, DateAdd(yy, 1, GetDate())) >= GetDate())         
--             
--OPEN NotesSelect                
--FETCH NotesSelect INTO @ClientID,@NoteType,@Bitmap                
--                
--SET @Counter=1                
--SET @TempGroupId=0                
--CREATE TABLE #TempClientNotes                
--(                
-- ClientId int,                
-- NoteType int,                
-- BitmapNo int,                
-- Bitmap1 varchar(50),                
-- Bitmap2 varchar(50),                
-- Bitmap3 varchar(50),                
-- Bitmap4 varchar(50),                
-- Bitmap5 varchar(50),                
-- Bitmap6 varchar(50),                
-- Bitmap7 varchar(50),                
-- Bitmap8 varchar(50),                
-- Bitmap9 varchar(50),                
-- Bitmap10 varchar(50)                
--)                
--                
--WHILE @@Fetch_Status = 0                  
--BEGIN                
--                 
-- IF @TempGroupId=@ClientID                
-- BEGIN                
--  SET @Counter=@Counter + 1                
--  --call sp to find status of the groupservice                
-- END                
-- ELSE                
-- BEGIN                
--  SET @TempGroupId=@ClientID                
--  SET @Counter=1                
--  --Select @GroupId                
-- END                
-- IF @Counter=1                
-- BEGIN                
--                  
--  INSERT INTO #TempClientNotes(ClientId , NoteType ,BitmapNo ,Bitmap1)                
--  VALUES(@ClientID, @NoteType,1, @Bitmap)                
-- END                
-- ELSE IF @Counter=2                
-- BEGIN                
--  UPDATE #TempClientNotes SET BitmapNo=2, Bitmap2=@Bitmap WHERE ClientId=@ClientID                
-- END                
-- ELSE IF @Counter=3                
-- BEGIN                
--  UPDATE #TempClientNotes SET BitmapNo=3, Bitmap3=@Bitmap WHERE ClientId=@ClientID END                
-- ELSE IF @Counter=4                
-- BEGIN                
--  UPDATE #TempClientNotes SET BitmapNo=4, Bitmap4=@Bitmap WHERE ClientId=@ClientID                
-- END                
-- ELSE IF @Counter=5                
-- BEGIN                
--  UPDATE #TempClientNotes SET BitmapNo=5, Bitmap5=@Bitmap WHERE ClientId=@ClientID                
-- END                
-- ELSE IF @Counter=6                
-- BEGIN                
--  UPDATE #TempClientNotes SET BitmapNo=6, Bitmap6=@Bitmap WHERE ClientId=@ClientID                
-- END                
-- ELSE IF @Counter=7                
-- BEGIN                
--  UPDATE #TempClientNotes SET BitmapNo=7, Bitmap7=@Bitmap WHERE ClientId=@ClientID                
-- END                
-- ELSE IF @Counter=8                
-- BEGIN                
--  UPDATE #TempClientNotes SET BitmapNo=8, Bitmap8=@Bitmap WHERE ClientId=@ClientID                
-- END                
-- ELSE IF @Counter=9                
-- BEGIN                
--  UPDATE #TempClientNotes SET BitmapNo=9, Bitmap9=@Bitmap WHERE ClientId=@ClientID                
-- END                
-- ELSE IF @Counter=10                
-- BEGIN                
--  UPDATE #TempClientNotes SET BitmapNo=10, Bitmap10=@Bitmap WHERE ClientId=@ClientID                
-- END                
--FETCH NEXT FROM NotesSelect INTO @ClientID,@NoteType,@Bitmap                
--                
--END                
--CLOSE NotesSelect                       
--DEALLOCATE NotesSelect                
--                    
--SELECT * FROM #TempClientNotes                  
--                  
----DROP TABLE #TempClientNotes                    
                
/******************************************************************************                
**Table : 05 Client Row. Used to update information on the Client Account overview page.                
******************************************************************************/                 
SELECT                 
  *                
FROM                 
  CLIENTS                
WHERE                 
  ( RECORDDELETED = ''N'' OR RECORDDELETED IS NULL )                
--AND                
--  ACTIVE = ''Y''                
AND                
  CLIENTID = @ClientID                
                  
/******************************************************************************                
**Table : 06 Fee Arrangement                
******************************************************************************/                 
                
SELECT                 
  CONVERT(VARCHAR,StartDate,101) + '' To '' + CONVERT(VARCHAR,EndDate,101) + CHAR(10) + Description As FeeArragnement                 
FROM                 
  ClientFeeArrangements                 
WHERE                 
  ClientId = @ClientID                 
AND                 
  (RecorDDeleted IS NULL OR RecordDeleted = ''N'')                
                  
/******************************************************************************                
**Table 07 :3''rd Party Information                
******************************************************************************/                 
                
/******************************************************************************                
** Following query select PlanName,Balance,UnBilledAmt,>90 Days Balance and                 
** flagged count                
******************************************************************************/                 
                
/*SELECT                
  ClientCoveragePlanId,       
  CoveragePlanName,                
  SUM(Balance) AS Balance,                
  SUM(UnBilled) AS UnBilledAmt,                
  SUM(NinetyDays) AS NinetyDays,                
  SUM(Flagged) As Flagged                
FROM                
  (*/                
   SELECT                 
    CH.clientCoveragePlanId,                
    RTRIM(Cp.DisplayAs) + '' '' + Isnull(InsuredId,'''') as CoveragePlanName,                
    SUM(AR.AMOUNT) as Balance,                
    Sum(case when ch.LastBilledDate is null then AR.Amount else 0 end) as UnBilledAmt,                  
    SUM(case WHEN DATEDIFF(day,CH.LastBilledDate,getdate())>=90 THEN AR.AMOUNT ELSE 0 end)AS NinetyDays,                
    CASE                
     WHEN ch.flagged=''Y'' THEN Count(flagged)                
     ELSE NULL                
    END AS Flagged                
   FROM                  
    Services S LEFT JOIN Charges CH ON S.ServiceId = CH.ServiceId                
    LEFT JOIN ClientCoveragePlans CCP ON CH.clientCoveragePlanId = CCP.clientCoveragePlanId                 
    LEFT JOIN CoveragePlans CP ON CCP.CoveragePlanId = CP.CoveragePlanId                 
    LEFT JOIN ARLedger AR ON CH.ChargeId = AR.ChargeId                
   WHERE                  
    S.Clientid = @ClientID                
   AND                
    CH.clientCoveragePlanId is not null                
   AND                 
    (s.RecordDeleted IS NULL OR s.RecordDeleted = ''N'')                 
                   
   GROUP BY                 
    CH.clientCoveragePlanId                
    ,CH.Flagged                
    ,CP.DisplayAs                
    ,CCP.InsuredId                
   Having Sum(AR.Amount)>0         -- Bhupinder Bajwa REF Task # 333                
  --) BT                
  --GROUP BY                
  --clientCoveragePlanId,                
  --CoveragePlanName                   
                
/******************************************************************************                
** Table 08: Payments History                
** Discription : This sp returns all the payment history related to a client                  
******************************************************************************/                 
create table #PaymentHistoy                
(                
 PaymentId INT null, ChargeId int, Amount money null                
                 
)                
INSERT INTO #PaymentHistoy                
SELECT                 
 A.PaymentId, A.ChargeId,                
                 
 SUM(A.Amount) AS Amount      FROM                 
 Arledger A                
            JOIN CoveragePlans cp ON cp.CoveragePlanId = A.CoveragePlanId  -- Bhupinder Bajwa 11 Jan 2007 REF Task # 282                
WHERE                  
 isnull(A.RecordDeleted,''N'') = ''N''                
AND                
 (A.PaymentId IS NOT NULL AND A.Coverageplanid IS NOT NULL AND A.ClientId = @ClientID AND isnull(cp.Capitated,''N'')=''N'' )      -- Condition for Capitated added on 11 Jan 2007 (Bhupinder Bajwa REF Task # 282)                
group by A.PaymentId, A.ChargeId                
                 
SELECT                 
 py.PaymentId,                
 py.FinancialActivityId,                
 py.PayerId,                
 py.CoveragePlanId,                
 py.ClientId,                 
 rtrim(CP.DisplayAs) + '' '' + isnull(CCP.InsuredId,'''') As Payer,                 
 py.DateReceived,                
 ABS(tmp.Amount) AS Amount,                
 py.UnpostedAmount AS UnpostedAmount,                
 py.ReferenceNumber                
FROM #PaymentHistoy tmp                 
 JOIN Payments PY ON (tmp.PaymentId = Py.PaymentId)                
 JOIN Charges C ON tmp.ChargeId = C.ChargeId                
 JOIN ClientCoveragePlans CCP ON (C.ClientCoveragePlanId = CCP.ClientCoveragePlanId)                
 JOIN  CoveragePlans cp ON CCP.coverageplanid = CP.coverageplanid                
WHERE                 
 isnull(py.RecordDeleted,''N'') = ''N''                
UNION ALL                
SELECT                 
 py.PaymentId,                
 py.FinancialActivityId,                
 py.PayerId,                
 py.CoveragePlanId,                
 py.ClientID,                
 ''Client'' As Payer,                 
 py.DateReceived,                
 py.Amount AS Amount,                
 py.UnpostedAmount AS UnpostedAmount,                
 py.ReferenceNumber                
FROM                 
 Payments py       
WHERE                 
 isnull(py.RecordDeleted,''N'') = ''N''                
AND                
 py.ClientId = @ClientID                
                 
order by Payer                            
               
--DROP table #PaymentHistoy
' 
END
GO
