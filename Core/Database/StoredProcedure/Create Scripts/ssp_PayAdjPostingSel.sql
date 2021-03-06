/****** Object:  StoredProcedure [dbo].[ssp_PayAdjPostingSel]    Script Date: 11/18/2011 16:25:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PayAdjPostingSel]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PayAdjPostingSel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PayAdjPostingSel]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ssp_PayAdjPostingSel]
	/* Param List */
	--@PayerType varchar(50),              
	--@PayerId int              
	@ParamPaymentId INT
	,@ParamFinancialActivityId INT
AS
/******************************************************************************              
**  File:               
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
**  Input       Output              
**     ----------       -----------              
**              
**  Auth: Rohit              
**  Date:               
*******************************************************************************              
**  Change History              
*******************************************************************************              
**  Date:  Author:    Description:              
**  -------- --------    -------------------------------------------              
**  16 Oct 2015 Revathi  what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.     
         why:task #609, Network180 Customization                 
*******************************************************************************/
--***************************************************************              
--Table 0 For type dropdown              
--***************************************************************              
SELECT GlobalCodeId
	,CodeName
	,Category
FROM GlobalCodes
WHERE Category = ''FinancialActivity''
	AND GlobalCodeId IN (
		4323
		,4325
		,4326
		)
ORDER BY CodeName

--*****************************************************************              
--Table 1 for Payer dropdown              
--*****************************************************************              
SELECT 0 AS PayerId
	,'''' AS PayerName

UNION

SELECT PayerId
	,PayerName
FROM payers
WHERE (
		RecordDeleted = ''N''
		OR RecordDeleted IS NULL
		)
ORDER BY PayerName

--***************************************************************              
--Table 2 Coverage Plan              
--***************************************************************              
SELECT 0 AS CoveragePlanId
	,'''' AS CoveragePlanName
	,'''' AS DisplayAs

UNION

SELECT CoveragePlanId
	,CoveragePlanName
	,DisplayAs
FROM coverageplans
WHERE Active = ''Y''
	AND (
		RecordDeleted = ''N''
		OR RecordDeleted IS NULL
		)

UNION

SELECT CoveragePlanId
	,CoveragePlanName
	,DisplayAs
FROM coverageplans
WHERE (
		RecordDeleted = ''N''
		OR RecordDeleted IS NULL
		)
	AND CoveragePlanId IN (
		SELECT CoveragePlanId
		FROM financialactivities
		WHERE FinancialActivityId = @ParamFinancialActivityId
		)
ORDER BY DisplayAs

--***************************************************************              
--Table 3 Payment method              
--***************************************************************              
SELECT 0 AS GlobalCodeId
	,'''' AS CodeName

UNION

SELECT GlobalCodeId
	,CodeName
FROM globalcodes
WHERE Category = ''PAYMENTMETHOD''
	AND Active = ''Y''
	AND (
		RecordDeleted = ''N''
		OR RecordDeleted IS NULL
		)
ORDER BY CodeName

--***************************************************************              
--Table 4 Locations              
--***************************************************************              
--Following code Commented by kuldeep ref task 331 dated 28 jan 2007           
/*SELECT 0 as LocationId,              
 '''' as LocationCode              
union              
SELECT               
 LocationId, LocationCode              
FROM              
  Locations               
WHERE              
  Active=''Y''               
AND (RecordDeleted=''N'' or RecordDeleted is null)              
ORDER BY              
  LocationCode  */
--Following code added by kuldeep ref task 331 dated 28 jan 2007           
SELECT 0 AS LocationId
	,'''' AS LocationCode

UNION

SELECT GlobalCodeId AS LocationId
	,CodeName AS LocationCode
FROM globalcodes
WHERE Category = ''FINANCIALLOCATION''
	AND Active = ''Y''
	AND (
		RecordDeleted = ''N''
		OR RecordDeleted IS NULL
		)
ORDER BY LocationCode

--***************************************************************              
--Table 5 Payment Source              
--***************************************************************              
SELECT 0 AS GlobalCodeId
	,'''' AS CodeName

UNION

SELECT GlobalCodeId
	,CodeName
FROM GlobalCodes
WHERE Category = ''PAYMENTSOURCE''
	AND Active = ''Y''
	AND (
		RecordDeleted = ''N''
		OR RecordDeleted IS NULL
		)
ORDER BY CodeName

--***************************************************************              
--Table 06 Financial Activities              
--***************************************************************              
SELECT *
FROM FinancialActivities
WHERE FinancialActivityid = @ParamFinancialActivityId

--***************************************************************              
--Table 07 payments              
--***************************************************************              
--SELECT               
--  *              
--FROM              
--  Payments              
SELECT PaymentId
	,FinancialActivityId
	,PayerId
	,CoveragePlanId
	,ClientId
	,convert(VARCHAR, DateReceived, 101) AS DateReceived
	,NameIfNotClient
	,ElectronicPayment
	,PaymentMethod
	,ReferenceNumber
	,CardNumber
	,ExpirationDate
	,Amount
	,LocationId
	,PaymentSource
	,UnpostedAmount
	,Comment
	,RowIdentifier
	,CreatedBy
	,CreatedDate
	,ModifiedBy
	,ModifiedDate
	,RecordDeleted
	,DeletedDate
	,DeletedBy
FROM Payments
WHERE PaymentId = @ParamPaymentId
	AND FinancialActivityId = @ParamFinancialActivityId

--***************************************************************              
--Table 8 SELECT Services              
--***************************************************************              
--***************************************************************              
--Table 9 To fill Adj dropdown              
--***************************************************************              
SELECT 0 AS GlobalCodeId
	,'' Adj Code'' AS CodeName
	,'''' AS Category
	,NULL AS SortOrder

UNION

SELECT GlobalCodeId
	,CodeName
	,Category
	,SortOrder
FROM GlobalCodes
WHERE category = ''AdjustmentCode''
	AND Active = ''Y''
	AND (
		RecordDeleted = ''N''
		OR RecordDeleted IS NULL
		)
ORDER BY SortOrder
	,CodeName

--***************************************************************              
--Table 10 Coverage Plans               
--***************************************************************              
SET FMTONLY ON

SELECT 0 AS ClientCoveragePlanId
	,- 1 AS CoveragePlanId
	,'''' AS DisplayAs
	,0 AS ClientId
	,NULL AS StartDate
	,NULL AS EndDate
	,0 AS CobOrder

UNION

SELECT 0 AS ClientCoveragePlanId
	,0 AS CoveragePlanId
	,'''' AS DisplayAs
	,0 AS ClientId
	,NULL AS StartDate
	,NULL AS EndDate
	,0 AS CobOrder

UNION

SELECT CCH.ClientCoveragePlanId
	,CCP.CoveragePlanId AS CoveragePlanId
	,CASE 
		WHEN CCP.InsuredId IS NULL
			THEN CP.DisplayAs
		ELSE CP.DisplayAs + '' '' + CCP.InsuredId
		END AS DisplayAs
	,CCP.ClientId
	,CCH.StartDate
	,CCH.EndDate
	,CCH.CobOrder
FROM clientcoverageplans CCP
LEFT JOIN clientcoveragehistory CCH ON CCH.ClientCoveragePlanId = CCP.ClientCoveragePlanId
LEFT JOIN CoveragePlans CP ON CCP.CoveragePlanId = CP.CoveragePlanId
WHERE (
		CP.RecordDeleted = ''N''
		OR CP.RecordDeleted IS NULL
		)
--where CCP.ClientId=@ClientId              
--and CCH.startdate<=@StartDate and CCH.EndDate>=@EndDate              
ORDER BY CobOrder
	,CoveragePlanId ASC

SET FMTONLY OFF
--***************************************************************              
--Table 11 PrimaryCoveragePlans          moved to select services              
--***************************************************************           
SET FMTONLY ON

SELECT max(ChargeId) AS ChargeId
	,serviceId
	,CCP.CoveragePlanId
FROM charges C
LEFT JOIN clientcoverageplans CCP ON C.ClientCoveragePlanId = CCP.ClientCoverageplanId
WHERE C.Priority = 1
GROUP BY Serviceid
	,coverageplanId

SET FMTONLY OFF
--***************************************************************              
--Table 12 FinancialActivityLines              
--***************************************************************              
SET FMTONLY ON

SELECT *
FROM financialActivitylines

--***************************************************************              
--Table 13 FinancialActivityLinesFlagged              
--***************************************************************              
SELECT *
FROM FinancialActivityLinesFlagged

SET FMTONLY OFF

--***************************************************************              
--Table 14 Charges              
--***************************************************************              
SELECT C.*
FROM Charges C
LEFT JOIN FinancialActivityLines FAL ON C.ChargeId = FAL.ChargeId
WHERE FinancialActivityId = @ParamFinancialActivityId

--***************************************************************              
--Table 15 ARLedger              
--***************************************************************              
--SELECT *               
--FROM ARLedger              
SET FMTONLY ON

SELECT ARL.ARLedgerId
	,ARL.ChargeId
	,ARL.FinancialActivityLineId
	,ARL.FinancialActivityVersion
	,ARL.LedgerType
	,ARL.Amount
	,ARL.PaymentId
	,ARL.AdjustmentCode
	,ARL.AccountingPeriodId
	,ARL.PostedDate
	,ARL.ClientId
	,ARL.CoveragePlanId
	,convert(VARCHAR(10), ARL.DateOfService, 101) AS DateOfService
	,ARL.MarkedAsError
	,ARL.ErrorCorrection
	,ARL.RowIdentifier
	,ARL.CreatedBy
	,ARL.CreatedDate
	,ARL.ModifiedBy
	,ARL.ModifiedDate
	,ARL.RecordDeleted
	,ARL.DeletedDate
	,ARL.DeletedBy
	,GC.CodeName
	,CASE --Added by Revathi 16 Oct 2015                
		WHEN C.ClientCoveragePlanId IS NOT NULL
			THEN (CP.DisplayAs)
		ELSE CASE 
				WHEN ISNULL(CL.ClientType, ''I'') = ''I''
					THEN (ISNULL(CL.LastName, '''') + '', '' + ISNULL(CL.FirstName, ''''))
				ELSE ISNULL(CL.OrganizationName, '''')
				END
		END AS TransferedTo
	,C.DoNotBill
FROM arledger ARL
LEFT JOIN GlobalCodes GC ON ARL.AdjustmentCode = GC.GlobalCodeId
LEFT JOIN Charges C ON ARL.ChargeId = C.ChargeId
LEFT JOIN clientcoverageplans CCP ON C.ClientCoveragePlanId = CCP.ClientCoveragePlanId
LEFT JOIN CoveragePlans CP ON CCP.CoveragePlanId = CP.CoveragePlanId
LEFT JOIN Services S ON C.ServiceId = S.ServiceId
LEFT JOIN Clients CL ON S.ClientId = CL.ClientId

SET FMTONLY OFF
--***************************************************************              
--Table 16 OpenCharges              
--***************************************************************              
SET FMTONLY ON

SELECT *
FROM OpenCharges

SET FMTONLY OFF

--***************************************************************              
--Table 17 AccountingPeriods              
--***************************************************************              
SELECT *
FROM AccountingPeriods

--***************************************************************              
--Table 18 serviceMaxPriorities                  Moved to select services              
--***************************************************************              
SET FMTONLY ON

SELECT max(Priority) AS Priority
	,serviceid
FROM FinancialActivityLines FAL
LEFT JOIN charges ON FAL.ChargeId = charges.ChargeId
WHERE FAL.FinancialActivityId = @ParamFinancialActivityId
GROUP BY serviceid

SET FMTONLY OFF

--***************************************************************              
--Table 19 CoveragePlanCharge              
--use to fill the completedchargeid column of selectservices as per the selected payer              
--***************************************************************              
SELECT C.ChargeId
	,C.ServiceId
	,C.ClientCoveragePlanId
	,CCP.CoveragePlanId
	,CCP.ClientId
	,CP.PayerId
	,C.Priority
FROM FinancialActivityLines FAL
LEFT JOIN charges C ON FAL.ChargeId = C.ChargeId
LEFT JOIN ClientCoverageplans CCP ON C.ClientCoveragePlanId = CCP.ClientCoverageplanid
LEFT JOIN Coverageplans CP ON CCP.CoveragePlanId = CP.CoverageplanId
WHERE FAL.FinancialActivityId = @ParamFinancialActivityId

--***************************************************************              
--Table 20 for displaying services in Services tab of PaymentAdjustmentposting              
--***************************************************************              
/*              
DECLARE               
  @EditImage binary,            
--@ServiceId int,              
-- @ChargeID int,              
 @FinancialActivityLineId int,              
 @FinancialActivityId int,              
 @CurrentVersion int,              
 @FinancialActivityVersion int,              
--@Name varchar(100),              
--@DateOfService DateTime,              
 @ProcedureUnit varchar(100),              
--@Balance money,              
--@Charge money,              
 @Amount money,              
 @PaymentID int,              
--@LedgerType varchar(10),              
 @Flag char,              
 @Comment varchar(100),              
 @Payment money,              
 @Adjustment money,              
 @Transfer money,              
--@Counter int,              
--@TempGroupId int,              
 @TempFAVersion int,              
 @ParentId int,              
 @BitmapPresent varchar,              
 @EditButtonPresent varchar,              
 @PrevIdentity int,              
 @TempFALineId int--,              
--@ParamFinancialActivityId int               
              
--set @ParamFinancialActivityId=142              
              
              
DECLARE selServicePayment CURSOR FOR               
              
              
select              
 S.ServiceId, Ch.ChargeId,              
FAL.FinancialActivityLineId, FAL.FinancialActivityId,FAL.CurrentVersion,              
ARL.FinancialActivityVersion,       
 --Added by Revathi 16 OCT 2015            
case when  ISNULL(C.ClientType,''I'')=''I'' then ISNULL(C.LastName,'''') + '', '' + ISNULL(C.FirstName,'''') else ISNULL(C.OrganizationName,'''') end  as [Name],              
S.DateOfService,              
convert(varchar,PC.DisplayAs) + '' '' + convert(varchar,S.Unit) + '' '' + convert(varchar,GC.CodeName) as [ProcedureUnit],              
OC.Balance ,              
S.Charge,              
ARL.Amount,              
ARL.PaymentID,              
ARL.LedgerType,              
FAL.Flagged,              
FAL.Comment              
from Arledger ARL               
LEFT OUTER JOIN  financialactivityLines FAL ON ARL.FinancialActivityLineId=FAL.FinancialActivityLineId              
LEFT OUTER JOIN Charges Ch ON ARL.ChargeId=Ch.ChargeId              
LEFT OUTER JOIN Services S ON Ch.ServiceId=S.ServiceId              
LEFT OUTER JOIN Clients C ON S.ClientId=C.ClientId              
LEFT OUTER JOIN OpenCharges OC on Ch.ChargeId=Oc.ChargeId              
LEFT OUTER JOIN procedurecodes PC ON S.ProcedurecodeId=PC.ProcedureCodeId              
LEFT OUTER JOIN GlobalCodes GC ON S.UnitType=GC.GlobalCodeId              
 Where ARL.ErrorCorrection is null and FAL.FinancialActivityId=@ParamFinancialActivityId              
Order by  S.ServiceId, FAL.FinancialActivityLineId, ARL.FinancialActivityVersion DESC              
              
OPEN selServicePayment              
FETCH selServicePayment              
INTO @ServiceId ,              
 @ChargeID ,              
 @FinancialActivityLineId ,              
 @FinancialActivityId ,              
 @CurrentVersion ,              
 @FinancialActivityVersion ,              
 @Name ,              
 @DateOfService ,              
 @ProcedureUnit ,              
 @Balance,              
 @Charge ,              
 @Amount ,              
 @PaymentID ,              
 @LedgerType ,              
 @Flag ,              
 @Comment              
              
SET @Counter=1              
SET @TempGroupId=0              
CREATE TABLE #temp2              
  (              
   Identity1 int identity(1,1),              
   EditImage binary,              
   EditButton char              
   --EditButton binary              
  ,ParentId int              
  ,ServiceId int              
  ,ChargeID int              
  ,FinancialActivityId int              
  ,FinancialActivityLineId int              
  ,CurrentVersion int              
  ,FinancialActivityVersion int              
  ,[Name] varchar(100)              
  ,DateOfService DateTime              
  ,ProcedureUnit varchar(100)              
  ,Balance money              
  ,Charge money              
  ,Payment money              
  ,PaymentID int              
  ,Adjustment money              
  ,LedgerType varchar(10)              
  ,transfer money              
--  ,Bitmap varchar(50)              
  ,BitmapPresent varchar              
  ,Bitmap binary              
  ,coment varchar(100)              
  )              
              
WHILE @@Fetch_Status = 0                
BEGIN                
 IF @TempGroupId=@ServiceId and @TempFAVersion=@FinancialActivityVersion and @TempFALineId=@FinancialActivityLineId              
 BEGIN               
  SET @Counter=@Counter + 1              
  SET @ParentId=0              
 END              
 ELSE              
 BEGIN              
  IF @TempGroupId=@ServiceId and  @TempFALineId=@FinancialActivityLineId              
  BEGIN              
   --SET @ParentId=@TempFAVersion              
   SET @ParentId=@PrevIdentity              
  END              
  ELSE              
  BEGIN              
   SET @ParentId=0              
  END              
--print ''tempfal='' print convert(varchar,@TempFALineId)              
--print ''fal='' print convert(varchar,@FinancialActivityLineId)              
  --IF @TempFALineId=@FinancialActivityLineId              
  if @TempGroupId=@ServiceId and @TempFAVersion=@FinancialActivityVersion              
  begin              
   SET @ParentId=0              
  end              
              
  SET @TempGroupId=@ServiceId              
  SET  @TempFAVersion=@FinancialActivityVersion              
  SET @TempFALineId=@FinancialActivityLineId              
  SET @Counter=1              
 END              
 IF @Counter=1              
 BEGIN              
  print @LedgerType              
  SET @Adjustment=null               
  SET @Transfer=null              
  SET @Payment=null              
                
  IF @LedgerType=''4203''              
  BEGIN              
   print ''adjustment=''              
   print Convert(varchar(50),@Amount)              
   SET @Adjustment=abs(@Amount)              
  END              
                
  ELSE IF @LedgerType=''4204''              
  BEGIN              
   SET @Transfer=abs(@Amount)              
  END              
  ELSE IF @LedgerType=''4202''              
  BEGIN              
   SET @Payment=abs(@Amount)              
  END              
  -- Get if flag is set to Y if Y then put the flag bitmap into temp table              
                 
  Declare @Bitmap binary(130)              
  SET @Bitmap=null              
  SET @BitmapPresent=null              
  SET @EditButtonPresent=null              
  IF @Flag=''Y''              
  BEGIN              
  --SET @Bitmap=''Admit.bmp''              
  SET @BitmapPresent=''Y''              
  --SELECT  @Bitmap=[Image] from Bitmap Where Id=2              
  END              
  if @ParentId=0              
  set @EditButtonPresent=''E''              
          
              
  INSERT INTO #temp2(EditButton, ParentId, ServiceId ,ChargeID ,FinancialActivityId ,FinancialActivityLineId ,CurrentVersion ,FinancialActivityVersion ,[Name] ,DateOfService ,ProcedureUnit ,Balance ,Charge ,Payment ,PaymentID ,Adjustment ,LedgerType ,tra
  
     
     
        
n          
            
sfer ,BitmapPresent ,coment)              
  values(@EditButtonPresent, @ParentId, @ServiceId,  @ChargeID , @FinancialActivityId, @FinancialActivityLineId ,@CurrentVersion ,@FinancialActivityVersion ,@Name , @DateOfService ,@ProcedureUnit ,@Balance ,@Charge ,@Payment , @PaymentID, @Adjustment, @Le
  
    
      
         
          
            
dgerType,  @Transfer, @BitmapPresent, @Comment)              
  print ''Prev Identity=''              
  SELECT @PrevIdentity = Max(Identity1) from #temp2 --where Identity1=Max(Identity1)              
  print @PrevIdentity              
 END              
 else if @Counter>1              
 BEGIN              
  IF @LedgerType=''4202''              
  BEGIN              
   update #temp2 set Payment=  abs(@Amount), PaymentId=@PaymentID  where ServiceId=@ServiceId and  FinancialActivityVersion=@FinancialActivityVersion and FinancialActivityLineId=@FinancialActivityLineId              
  END              
  ELSE IF @LedgerType=''4203''              
  BEGIN     
   Declare @AdjAmt money              
   SELECT @AdjAmt= Adjustment from #temp2 where ServiceId=@ServiceId and  FinancialActivityVersion=@FinancialActivityVersion              
                 
   if @AdjAmt is null and @Amount is not null              
   BEGIN              
    print ''Adj Amnt=''              
    print convert(varchar,@Amount)              
    update #temp2 set Adjustment=  abs(@Amount) where ServiceId=@ServiceId and  FinancialActivityVersion=@FinancialActivityVersion and FinancialActivityLineId=@FinancialActivityLineId              
   END              
   else if @AdjAmt is not null and @Amount is not null              
   BEGIN              
    update #temp2 set Adjustment= Adjustment + abs(@Amount) where ServiceId=@ServiceId and  FinancialActivityVersion=@FinancialActivityVersion and FinancialActivityLineId=@FinancialActivityLineId              
   END              
  END              
                
  ELSE IF @LedgerType=''4204''              
  BEGIN              
   --print ''prev amount='' print convert(varchar,@Transfer )              
--   print ''Current amt=''              
 --  print convert(varchar,@Amount)              
   if @Transfer * -1 = @Amount              
   BEGIN              
    print ''same transfer''              
   END              
                 
   ELSE              
   BEGIN              
    Declare @TransAmt money              
    SELECT @TransAmt= Transfer from #temp2 where ServiceId=@ServiceId and  FinancialActivityVersion=@FinancialActivityVersion              
                  
    if @TransAmt is null and @Amount is not null              
    BEGIN              
     update #temp2 set Transfer=  abs(@Amount)  where ServiceId=@ServiceId and  FinancialActivityVersion=@FinancialActivityVersion and FinancialActivityLineId=@FinancialActivityLineId              
    END              
    else if @TransAmt is not null and @Amount is not null              
    BEGIN              
     update #temp2 set Transfer= Transfer + abs(@Amount)  where ServiceId=@ServiceId and  FinancialActivityVersion=@FinancialActivityVersion and FinancialActivityLineId=@FinancialActivityLineId              
    END              
   END              
  set @Transfer=  @Amount               
  END              
  print ''Prev Identity=''              
  SELECT @PrevIdentity = Max(Identity1) from #temp2 --where Identity1=Max(Identity1)              
  print @PrevIdentity              
 END              
FETCH selServicePayment              
INTO @ServiceId ,              
 @ChargeID ,              
 @FinancialActivityLineId ,              
 @FinancialActivityId ,              
 @CurrentVersion ,              
 @FinancialActivityVersion ,              
 @Name ,              
 @DateOfService ,              
 @ProcedureUnit ,              
 @Balance,              
 @Charge ,              
 @Amount ,              
 @PaymentID ,              
 @LedgerType ,              
 @Flag ,              
 @Comment              
END              
close selServicePayment                     
DEALLOCATE selServicePayment              
                  
select   Identity1 ,              
   EditImage ,              
   EditButton               
   --EditButton binary              
  ,ParentId               
  ,ServiceId              
  ,ChargeID               
  ,FinancialActivityId               
  ,FinancialActivityLineId               
  ,CurrentVersion               
  ,FinancialActivityVersion               
  ,[Name]               
  ,DateOfService               
  ,ProcedureUnit               
  ,Balance               
  ,Charge       ,''$'' + convert (varchar,Payment,10) as  Payment              
  ,PaymentID               
  ,''$'' + convert(varchar,Adjustment,10) as Adjustment              
  ,LedgerType               
  ,''$'' + convert(varchar,transfer,10) as transfer               
--  ,Bitmap varchar(50)              
  ,BitmapPresent               
  ,Bitmap               
  ,coment as Comment              
 from #temp2                  
drop table #temp2                  
              
    
*/
--***************************************************************              
--Table 21 Table Refunds              
--***************************************************************              
SELECT *
FROM Refunds
WHERE (
		RecordDeleted = ''N''
		OR RecordDeleted IS NULL
		)
	AND PaymentId = @ParamPaymentId

--*************************************************************              
--Table 22 Clients              
--*************************************************************              
SELECT *
FROM Clients
WHERE (
		RecordDeleted = ''N''
		OR RecordDeleted IS NULL
		)
	AND Clients.ClientId IN (
		SELECT ClientId
		FROM FinancialActivities
		WHERE Financialactivityid = @ParamFinancialActivityId
		)

--and Clients.ClientId in(select ClientId from Payments where paymentid=@ParamPaymentId)              
--*************************************************************              
--Table 23 Appliedpayment              
--*************************************************************              
SELECT sum(Amount) AS AppliedPayment
FROM ARLedger
WHERE paymentid = @ParamPaymentId

--*************************************************************              
--Table 23 Agency              
--*************************************************************              
SELECT *
FROM Agency

--*************************************************************              
--Table 23 Payer            
--*************************************************************              
/*              
SELECT              
  CCP.ClientId,              
  CP.CoveragePlanId,              
  CP.DisplayAs,      
  CP.PayerId               
FROM              
  clientcoverageplans CCP              
LEFT OUTER JOIN CoveragePlans CP on CCP.CoveragePlanID=CP.CoveragePlanId              
WHERE              
  CP.Active=''Y''               
AND               
 (CCP.RecordDeleted =''N'' or CCP.RecordDeleted is null)*/
--Added by Jaspreet Singh ref ticket#711(Selecting the default Accounting Period      
SELECT AccountingPeriodId
FROM AccountingPeriods
WHERE StartDate < GetDate()
	AND DateAdd(dd, 1, EndDate) > GetDate()
' 
END
GO
