/****** Object:  StoredProcedure [ssp_PMServices]    Script Date: 03/28/2012 13:09:23 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[ssp_PMServices]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [ssp_PMFinancialCorrectionSel]
GO

/****** Object:  StoredProcedure [ssp_PMServices]    Script Date: 03/28/2012 13:09:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[ssp_PMFinancialCorrectionSel]           
       
 @ServiceId int,                
 @FinancialActivityId int,                
 @paymentId int,                
 @FinancialActivityLineId int                
                 
AS            
BEGIN

BEGIN TRY

/****************************************************************************** 
** File: ssp_PMFinancialCorrectionSel.sql
** Name: ssp_PMFinancialCorrectionSel
** Desc: This SP returns the drop down values for posting Payments
** 
** This template can be customized: 
** 
** Return values: 
** 
** Called by: 
** 
** Parameters: 
** Input Output 
** ---------- ----------- 
** 
** Auth: Mary Suma
** Date: 10/05/2011
******************************************************************************* 
** Change History 
******************************************************************************* 
** Date: 			Author: 			Description: 
** 
-------- 			-------- 			--------------- 
-- 24 Aug 2011		Girish				Removed References to Rowidentifier and/or ExternalReferenceId
-- 27 Aug 2011		Girish				Readded References to Rowidentifier and ExternalReferenceId
-- 28 Sep 2011		MSuma				Replaced '*' with Column Names
-- 08 Dec 2011		MSuma				Formatted Date
-- 09 Dec 2011		MSuma				Included ARLedger for current version
-- 27 Jun 2012      PSelvan				For Ace project PM Web Bugs #1814
-- DEC-30-2013		dharvey				Removed LedgerType restriction on previous entries
----21-DEC-2015   Basudev Sahu Modified For Task #609 Network180 Customization to Get Organisation  As ClientName
-- 03/16/2016       Bernardin           Client Name format changed to "LastName, FirstName". Core Bugs Task# 2040
-- 04/05/2019		TRemisoski			What: Restrict the calculated field named "ProcedureName" to 50 characters.  Porter-Starke SGL #551.
										Why: String or binary data truncated errors.

-- 04/05/2019		TRemisoski			What: Restrict the calculated field named "ProcedureName" to 50 characters.  Porter-Starke SGL #551.
										Why: String or binary data truncated errors.

*******************************************************************************/      
		
--******************************************************************************                
--Table 01: ServiceBalance                
--******************************************************************************                
		SELECT S.ServiceId, S.ClientId,
		  CASE     
						WHEN ISNULL(C.ClientType, 'I') = 'I'
						 THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')
						ELSE ISNULL(C.OrganizationName, '')
						END as [Name],              
		-- C.LastName +', ' + C.FirstName as [Name],                
		 PC.ProcedureCodeId,PC.DisplayAs as ProcedureCode, 
		 --Convert(varchar(10),S.DateOfService,101) AS DateOfService,   
		 convert(varchar(19), DateOfService, 101)+ ' '+  
				ltrim(substring(convert(varchar(19), DateOfService, 100), 12, 6) )+ ' '+ 
				ltrim(substring(convert(varchar(19), DateOfService, 100), 18, 2) ) AS DateOfService,	              
		 --Ch.ChargeId,                
		 --sum(OC.Balance) as Balance,                
		 '$' + convert(varchar,sum(OC.Balance),10) as Balance,                
		 CCP.CoveragePlanId  
		FROM                
		 Services S                
		LEFT OUTER JOIN Clients C ON S.ClientId=C.ClientId                
		LEFT OUTER JOIN ProcedureCodes PC ON S.ProcedureCodeId=PC.ProcedureCodeId                
		LEFT OUTER JOIN Charges Ch ON S.ServiceId=Ch.ServiceId                
		LEFT OUTER JOIN FinancialActivityLines FAL ON FAL.Chargeid=Ch.ChargeId                
		LEFT OUTER JOIN OpenCharges OC ON Ch.ChargeId=OC.ChargeId                
		LEFT OUTER JOIN clientcoverageplans CCP ON Ch.ClientCOveragePlanId=CCP.ClientCoveragePlanId                
		WHERE                 
		 S.ServiceId=@ServiceId                
		AND                
		 FAL.FinancialActivityLineId=@FinancialActivityLineId                
		GROUP BY S.ServiceId, S.ClientId,                
		 C.LastName +', ' + C.FirstName, 
		 C.ClientType,C.OrganizationName,
		 C.LastName,C.FirstName,
		 PC.ProcedureCodeId, PC.DisplayAs, S.DateOfService,CCP.CoveragePlanId                
                 
--******************************************************************************                
--Table 02: Payers                
--******************************************************************************                
                 
		CREATE TABLE #ChargeSummary                
		(                 
		 ServiceId  INT,                
		 FlaggedImg  INT,                
		 ProcedureName VARCHAR(50),                
		 Charges   MONEY,                
		 UnBilled  VARCHAR(20),                
		 Payments  MONEY,                
		 Adj    MONEY,                
		 Balance   MONEY                
		)                
		                
		INSERT #ChargeSummary                
		SELECT                 
		  ServiceId,                
		  SUM(FlaggedImg) as FlaggedImg,
		  -- Tremisoski 4/5/19                
		  LEFT(ProcedureName, 50) as ProcedureName,                
		  SUM(Charges) AS Charges,                
		  UnBilled,                
		  Payment,                
		  Adj,                
		  Balance                
		FROM                
		  (                
		   SELECT                
			S.ServiceId,            
			(SELECT count(FAL.Flagged) FROM FinancialActivityLines FAL WHERE FAL.Flagged= 'Y' AND FAL.FinancialActivityLineId=AR.FinancialActivityLineId) AS FlaggedImg,        
			CASE                 
			 WHEN C.ClientCoveragePlanId Is NOT NULL THEN                 
			 (                
			  CASE                
			   WHEN                 
			   (                
		 SELECT InsuredId From ClientCoveragePlans CCP,CoveragePlans CP                 
			   WHERE CCP.ClientCoveragePlanId = C.ClientCoveragePlanId AND CCP.CoveragePlanId = CP.CoveragePlanId                
			   ) IS NULL THEN                
			   (                
			   SELECT DisplayAs From ClientCoveragePlans CCP,CoveragePlans CP                 
			   WHERE CCP.ClientCoveragePlanId = C.ClientCoveragePlanId AND CCP.CoveragePlanId = CP.CoveragePlanId                
			   )                
			   ELSE                
			   (                
			   SELECT DisplayAs + ' ' + InsuredId From ClientCoveragePlans CCP,CoveragePlans CP                 
			   WHERE CCP.ClientCoveragePlanId = C.ClientCoveragePlanId AND CCP.CoveragePlanId = CP.CoveragePlanId                
			   )                
			  END                
			 )                
			 ELSE 'Client'                
			END AS ProcedureName,                
			SUM(AR.Amount) AS Charges,                
			'0' AS UnBilled,                
			0 AS Payment,                
			0 AS Adj,                
			0 AS Balance                
		                    
		   FROM                
			Services S LEFT JOIN Charges C ON S.ServiceId = C.ServiceId                
			LEFT JOIN Arledger AR ON C.ChargeId = Ar.ChargeId                
			LEFT JOIN ClientCoveragePlans CC ON CC.ClientCoveragePlanId = C.ClientCoveragePlanId                
		   WHERE                 
			S.ServiceId = @ServiceId                
			AND (s.RecordDeleted IS NULL OR s.RecordDeleted = 'N')                
			AND (CC.RECORDDELETED IS NULL OR CC.RECORDDELETED = 'N')                
			AND AR.LedgerType IN('4201','4204')                
			GROUP BY S.ServiceId,C.ClientCoveragePlanId,AR.FinancialActivityLineId                
		  ) T                 
		  GROUP BY                 
		  ServiceId,                
		  -- Tremisoski 4/5/19                
		  LEFT(ProcedureName, 50),                
		  UnBilled,                
		  Payment,                
		  Adj,                
		  Balance                
		                
		UPDATE #ChargeSummary                
		SET UnBilled = T.UnBilled                
		FROM                
		(                
		                
		SELECT                
		S.ServiceId,                
		CASE                 
		 WHEN C.ClientCoveragePlanId IS NOT NULL THEN                 
		 (                
		  CASE                
		   WHEN                 
		   (                
		   SELECT InsuredId From ClientCoveragePlans CCP,CoveragePlans CP                 
		   WHERE CCP.ClientCoveragePlanId = C.ClientCoveragePlanId AND ISNULL(CCP.RECORDDELETED,'N')='N' AND CCP.CoveragePlanId = CP.CoveragePlanId                
		   ) IS NULL THEN                
		   (                
		   SELECT DisplayAs From ClientCoveragePlans CCP,CoveragePlans CP                 
		   WHERE CCP.ClientCoveragePlanId = C.ClientCoveragePlanId AND ISNULL(CCP.RECORDDELETED,'N')='N' AND CCP.CoveragePlanId = CP.CoveragePlanId                
		   )                
		   ELSE                
		   (                
		   SELECT DisplayAs + ' ' +  InsuredId From ClientCoveragePlans CCP,CoveragePlans CP                 
		   WHERE CCP.ClientCoveragePlanId = C.ClientCoveragePlanId AND ISNULL(CCP.RECORDDELETED,'N')='N' AND CCP.CoveragePlanId = CP.CoveragePlanId                
		   )                
		  END                
		 )                
		 ELSE 'Client'                
		END As ProcedureName,                
		CASE                 
		 WHEN                 
		 (                
		  SELECT COUNT(CP.CoveragePlanId) FROM ClientCoveragePlans CCP,CoveragePlans CP                 
		  WHERE CCP.ClientCoveragePlanId = C.ClientCoveragePlanId AND ISNULL(CCP.RECORDDELETED,'N')='N' AND CCP.CoveragePlanId = CP.CoveragePlanId and CP.Capitated = 'Y'                
		)>0 THEN 'Capitated'                   
		 ELSE Convert(varchar,SUM(AR.Amount),101)                
		End as UnBilled                
		FROM                
		 Services S LEFT JOIN Charges C on S.ServiceId = C.ServiceId                
		 LEFT JOIN Arledger AR on C.ChargeId = Ar.ChargeId                
		 LEFT JOIN ClientCoveragePlans CC ON CC.ClientCoveragePlanId = C.ClientCoveragePlanId                
		WHERE                 
		 S.ServiceId = @ServiceId                
		AND                
		 C.LastBilledDate is NULL                 
		AND (s.RecordDeleted IS NULL OR s.RecordDeleted = 'N')                
		AND (CC.RECORDDELETED IS NULL OR CC.RECORDDELETED = 'N')                
		GROUP BY S.ServiceId,C.ClientCoveragePlanId                
		      
		)T,#ChargeSummary CS                
		WHERE                
		T.ServiceId = cs.ServiceId                
		AND                
		T.ProcedureName = CS.ProcedureName                
		                
		UPDATE #ChargeSummary                
		SET Payments = T.Payment                
		FROM                
		(                
		SELECT                
		 S.ServiceId,                
		 CASE                 
		  WHEN C.ClientCoveragePlanId Is NOT NULL THEN                 
		  (                
		   CASE           
			WHEN                 
			(                
			SELECT InsuredId From ClientCoveragePlans CCP,CoveragePlans CP                 
			WHERE CCP.ClientCoveragePlanId = C.ClientCoveragePlanId AND ISNULL(CCP.RECORDDELETED,'N')='N' AND CCP.CoveragePlanId = CP.CoveragePlanId                
			) IS NULL THEN                
			(                
			SELECT DisplayAs From ClientCoveragePlans CCP,CoveragePlans CP                 
			WHERE CCP.ClientCoveragePlanId = C.ClientCoveragePlanId AND ISNULL(CCP.RECORDDELETED,'N')='N' AND CCP.CoveragePlanId = CP.CoveragePlanId                
			)                
			ELSE                
			(                
			SELECT DisplayAs + ' ' +  InsuredId From ClientCoveragePlans CCP,CoveragePlans CP                 
			WHERE CCP.ClientCoveragePlanId = C.ClientCoveragePlanId AND ISNULL(CCP.RECORDDELETED,'N')='N' AND CCP.CoveragePlanId = CP.CoveragePlanId                
			)                
		   END                
		  )        ELSE 'Client'                
		 END As ProcedureName,                
		 ABS(SUM(AR.Amount)) AS Payment                
		FROM                
		 Services S Left join Charges C on S.ServiceId = C.ServiceId                
		 LEFT JOIN Arledger AR on C.ChargeId = Ar.ChargeId                
		 LEFT JOIN ClientCoveragePlans CC ON CC.ClientCoveragePlanId = C.ClientCoveragePlanId                
		WHERE                 
		 S.ServiceId = @ServiceId                
		AND                 
		 AR.LedgerType IN('4202')                
		AND (s.RecordDeleted IS NULL OR s.RecordDeleted = 'N')                
		AND (CC.RECORDDELETED IS NULL OR CC.RECORDDELETED = 'N')                
		GROUP BY S.ServiceId,C.ClientCoveragePlanId                
		)T,#ChargeSummary CS                
		where                 
		T.ServiceId = cs.ServiceId                
		AND                
		T.ProcedureName = CS.ProcedureName                
		                
		UPDATE #ChargeSummary                
		SET Adj = T.Adj                
		FROM                
		(                
		select                
		S.ServiceId,                
		Case                 
		 when C.ClientCoveragePlanId Is NOT NULL THEN                 
		 (                
		  CASE                
		   WHEN                 
		   (                
		   SELECT InsuredId From ClientCoveragePlans CCP,CoveragePlans CP                 
		   WHERE CCP.ClientCoveragePlanId = C.ClientCoveragePlanId AND ISNULL(CCP.RECORDDELETED,'N')='N' AND CCP.CoveragePlanId = CP.CoveragePlanId                
		   ) IS NULL THEN                
		   (                
		   SELECT DisplayAs From ClientCoveragePlans CCP,CoveragePlans CP                 
		   WHERE CCP.ClientCoveragePlanId = C.ClientCoveragePlanId AND ISNULL(CCP.RECORDDELETED,'N')='N' AND CCP.CoveragePlanId = CP.CoveragePlanId                
		   )                
		   ELSE                
		   (                
		   SELECT DisplayAs + ' ' +  InsuredId From ClientCoveragePlans CCP,CoveragePlans CP                 
		   WHERE CCP.ClientCoveragePlanId = C.ClientCoveragePlanId AND ISNULL(CCP.RECORDDELETED,'N')='N' AND CCP.CoveragePlanId = CP.CoveragePlanId                
		   )                
		  END                
		 )                
		 ELSE 'Client'                
		END As ProcedureName,                
		ABS(SUM(AR.Amount)) AS Adj                
		FROM                
		 Services S Left join Charges C on S.ServiceId = C.ServiceId                
		 LEFT JOIN Arledger AR on C.ChargeId = Ar.ChargeId     
		 LEFT JOIN ClientCoveragePlans CC ON CC.ClientCoveragePlanId = C.ClientCoveragePlanId                
		WHERE                 
		 S.ServiceId = @ServiceId                
		AND                 
		 AR.LedgerType IN('4203')                
		AND                 
		  (s.RecordDeleted IS NULL OR s.RecordDeleted = 'N')                
		AND (CC.RECORDDELETED IS NULL OR CC.RECORDDELETED = 'N')                
		GROUP BY S.ServiceId,C.ClientCoveragePlanId                
		)T,#ChargeSummary CS                
		WHERE                 
		T.ServiceId = cs.ServiceId                
		AND                
		T.ProcedureName = CS.ProcedureName                
		                
		                
		UPDATE #ChargeSummary                
		SET Balance = T.Balance                
		FROM                
		(                
		SELECT                
		 ServiceId,                
		 ProcedureName,                
		 CASE                
		  WHEN SUM(Balance) IS NULL THEN 0                
		  ELSE SUM(Balance)                 
		 END as Balance                
		FROM                
		(                
		 SELECT                
		  S.ServiceId,                
		  Case                 
		   when C.ClientCoveragePlanId Is NOT NULL THEN                 
		   (                
			CASE                
			 WHEN                 
			 (                
			 SELECT InsuredId From ClientCoveragePlans CCP,CoveragePlans CP                 
			 WHERE CCP.ClientCoveragePlanId = C.ClientCoveragePlanId AND ISNULL(CCP.RECORDDELETED,'N')='N' AND CCP.CoveragePlanId = CP.CoveragePlanId                
			 ) IS NULL THEN                
			 (                
			 SELECT DisplayAs From ClientCoveragePlans CCP,CoveragePlans CP                 
			 WHERE CCP.ClientCoveragePlanId = C.ClientCoveragePlanId AND ISNULL(CCP.RECORDDELETED,'N')='N' AND CCP.CoveragePlanId = CP.CoveragePlanId                
			 )                
			 ELSE                
			 (                
			 SELECT DisplayAs + ' ' +  InsuredId From ClientCoveragePlans CCP,CoveragePlans CP                 
			 WHERE CCP.ClientCoveragePlanId = C.ClientCoveragePlanId AND ISNULL(CCP.RECORDDELETED,'N')='N' AND CCP.CoveragePlanId = CP.CoveragePlanId                
			 )                
			END                
		   )                
		   ELSE 'Client'                
		  END As ProcedureName,                
		  SUM(AR.Amount) as Balance                
		 FROM                
		  Services S Left join Charges C on S.ServiceId = C.ServiceId                
		  LEFT JOIN Arledger AR on C.ChargeId = Ar.ChargeId                
		  LEFT JOIN ClientCoveragePlans CC ON CC.ClientCoveragePlanId = C.ClientCoveragePlanId                
		 WHERE                 
		  S.ServiceId = @ServiceId                
		 AND                 
		  (s.RecordDeleted IS NULL OR s.RecordDeleted = 'N')                
		 AND (CC.RECORDDELETED IS NULL OR CC.RECORDDELETED = 'N')                
		 GROUP BY S.ServiceId,S.ClientId,C.ClientCoveragePlanId                
		)BTEMP                 
		GROUP BY ServiceId,ProcedureName                
		)T,#ChargeSummary CS                
		where                 
		T.ServiceId = cs.ServiceId                
		AND                
		T.ProcedureName = CS.ProcedureName                
		                
		SELECT                 
		   ServiceId                 
		  ,CASE                
			WHEN FlaggedImg > 0 THEN 'Admit.bmp'                
			ELSE NULL                
		   END FlaggedImg                
		  ,ProcedureName                 
		  ,'$' + Convert(Varchar,Charges,20) as Charges                   
		  ,Case                
			WHEN UnBilled = 'Capitated' THEN 'Capitated'                
			ELSE '$' +  UnBilled                
		   END AS UnBilled                
		  ,'$' + Convert(Varchar,Payments,20) as Payements                   
		  ,'$' + Convert(Varchar,Adj,20) as Adj                     
		  ,'$' + Convert(Varchar,Balance,20) as Balance                    
		 FROM                 
		  #ChargeSummary                
		                
		DROP TABLE #ChargeSummary                
                
--**************************************************************                
--Table 03: FinancialActivityData                
--*************************************************************                
                
		select distinct P.PaymentId, P.FinancialActivityId,                
		 CASE                
		WHEN p.PayerId is not null THEN                
		  ( PA.PayerName                 
		   )                 
		  WHEN P.CoveragePlanId is not null THEN                
		  (CP.DisplayAs)                
		  WHEN P.ClientId is not null THEN                
		  ( C.LastName +', ' + C.FirstName)                
		 END as Payer,                
		  P.PayerId ,                 
		  P.CoveragePlanId,                
		  P.ClientId,                
		  GC.CodeName,                
		   Convert(varchar(10),P.DateReceived,101) as DateReceived,                
		   P.ModifiedBy,                
		 '$' +  convert(varchar,P.Amount,10) as Amount ,                 
		 --'$' +  convert(varchar,RF.Amount,10) as Refund,                 
		 '$' + convert(varchar,(select sum(Amount) from refunds where PaymentId=@paymentId)) as Refund,                
		 '$' +  convert(varchar,Sum(ARL.Amount) * -1,10) as Applied   ,             
		  '$' +  convert(varchar,P.UnpostedAmount,10) as Balance               
		from payments P                
		LEFT OUTER JOIN Payers PA ON P.Payerid=PA.PayerId                
		LEFT OUTER JOIN CoveragePlans CP ON P.CoveragePlanId=CP.CoveragePlanId                
		LEFT OUTER JOIN Clients C ON P.ClientId=C.ClientId                
		LEFT OUTER JOIN Refunds RF ON P.PaymentId=RF.PaymentId                
		LEFT OUTER JOIN ARLedger ARL ON P.PaymentId=ARL.paymentId                
		LEFT OUTER JOIN financialActivities FA ON P.FinancialActivityId=FA.FinancialActivityId                
		LEFT OUTER JOIN globalcodes GC ON FA.ActivityType=GC.GlobalCodeId                
		Where P.FinancialActivityId=@FinancialActivityId                 
		 AND P.PaymentId=@paymentId  
		Group By P.PaymentId, P.FinancialActivityId,              
		  PA.PayerName ,CP.DisplayAs,                
		 C.LastName , C.FirstName,P.PayerId , P.CoveragePlanId,                
		  P.ClientId, GC.CodeName, P.DateReceived, P.ModifiedBy, P.Amount, RF.Amount , P.UnpostedAmount               
                  
--***********************************************************************************                
--Table 04: PreviousEntry                
--**********************************************************************************                
			IF OBJECT_ID('#ARLEdgerTemp') IS NOT NULL
			BEGIN
				DROP TABLE #ARLEdgerTemp;
			END 
		 SELECT 
			ARL.ARLedgerId,
			ARL.ChargeId,
			ARL.FinancialActivityLineId,   
			FAL.FinancialActivityId,              
			ARL.FinancialActivityVersion,
			ARL.LedgerType,
			ARL.Amount,
			ARL.PaymentId,                
			ARL.AdjustmentCode,
			ARL.PostedDate,
			ARL.ClientId,                
		 ARL.CoveragePlanId,convert(varchar(10),ARL.DateOfService,101) as DOS, ARL.DateOfService,                
		 ARL.MarkedAsError,ARL.ErrorCorrection
		 ,ARL.RowIdentifier
		 ,ARL.CreatedBy,                
		 ARL.CreatedDate,ARL.ModifiedBy,ARL.ModifiedDate,ARL.RecordDeleted,                
		 ARL.DeletedDate,ARL.DeletedBy, ' '+GC.CodeName AS CodeName,   FAL.Flagged      , ARL.AccountingPeriodId,
		 AP.FiscalYear
		,AP.[Description]   ,   c.ClientCoveragePlanId,      
		 CASE                
		  WHEN C.ClientCoveragePlanId is NOT NULL then                
		  (CP.DisplayAs)                
		  ELSE                
		  (CL.LastName +', ' + CL.FirstName)         
		 END  as TransferedTo, C.DoNotBill                
		 INTO #ARLEdgerTemp               
		from  arledger ARL    
		LEFT OUTER JOIN FinancialActivityLines FAL ON ARL.FinancialActivityLineId= FAL.FinancialActivityLineId             
		LEFT OUTER JOIN GlobalCodes GC ON ARL.AdjustmentCode=GC.GlobalCodeId                
		LEFT OUTER JOIN Charges C ON ARL.ChargeId=C.ChargeId                
		LEFT OUTER JOIN clientcoverageplans CCP ON C.ClientCoveragePlanId=CCP.ClientCoveragePlanId                
		LEFT OUTER JOIN CoveragePlans CP ON CCP.CoveragePlanId=CP.CoveragePlanId                
		LEFT OUTER JOIN Services S ON C.ServiceId=S.ServiceId                
		LEFT OUTER JOIN Clients CL ON S.ClientId=CL.ClientId    
		LEFT OUTER JOIN AccountingPeriods AP ON   AP.AccountingPeriodId = ARL.AccountingPeriodId                
		WHERE FAL.FinancialActivityLineId= @FinancialActivityLineId
		AND   ARL.FinancialActivityVersion =FAL.CurrentVersion        
		 AND  FinancialActivityId=@FinancialActivityId 
		 
		-- DECLARE @ChargeId INT
		-- select @ChargeID = ChargeId from #ARLEdgerTemp 
		-- --WHERE LedgerType = 4202
		----WHERE LedgerType IN ( 4202, 4204 ) --Payments, Transfers
		 
		 select DISTINCT
		ARLedgerId,
		Amount, 
		LedgerType, 
		FinancialActivityId, 
		CodeName , 
		Flagged                 
		,ClientCoveragePlanId, FinancialActivityLineId                
		,AccountingPeriodId
		,FiscalYear
		,Description
		  FROM #ARLEdgerTemp
		 --WHERE ChargeId = @ChargeId               
		                
                
                
--*****************************************************************************************                
--Table 05: PrevTransferedTo                
--*****************************************************************************************                
		DECLARE @ChargeIdNew INT  
		select @ChargeIdNew = Max(ChargeId) from #ARLEdgerTemp where LedgerType = 4204    
		DECLARE @Count INT
        select @Count = count(distinct(isnull(ClientCoveragePlanId,0))) from #ARLEdgerTemp where LedgerType = 4204 and Amount > 0  

		SELECT TOP 1  CASE                  
		WHEN @Count > 1 then                  
		('Multiple')                  
		ELSE                  
		(TransferedTo)           
		END  as TransferedTo,
		ClientCoveragePlanId  as TransferedId
		FROM #ARLEdgerTemp  
		WHERE ChargeId = @ChargeIdNew  and LedgerType = 4204 
   
	--select '' as TransferedTo,                
	-- 0 as TransferedId                
	--UNION                
	--SELECT                 
	-- CASE                
	--   WHEN C.ClientCoveragePlanId is NOT NULL then                
	--  (CP.DisplayAs)                
	--  ELSE                
	--  (CL.LastName +', ' + CL.FirstName)                
	--  END  as TransferedTo,                
	-- CASE                
	--   WHEN C.ClientCoveragePlanId is NOT NULL then                
	--  (C.ClientCoveragePlanId)                
	--  ELSE                
	--  (CL.ClientId)                
	--  END  as TransferedId                
	--FROM charges C                
	--LEFT OUTER JOIN clientcoverageplans CCP ON C.ClientCoveragePlanId=CCP.ClientCoveragePlanId                
	--LEFT OUTER JOIN CoveragePlans CP ON CCP.CoveragePlanId=CP.CoveragePlanId                
	--LEFT OUTER JOIN Services S ON C.ServiceId=S.ServiceId                
	--LEFT OUTER JOIN Clients CL ON S.ClientId=CL.ClientId                
	--LEFT OUTER JOIN ARLedger ARL ON C.ChargeId=ARL.ChargeId                
	--LEFT OUTER JOIN FinancialActivityLines FAL ON ARL.FinancialActivityLineId=FAL.FinancialActivityLineId                
	--LEFT OUTER JOIN FinancialActivities FA ON FAL.FinancialActivityId=FA.FinancialActivityId                
	--WHERE                
	--  C.ServiceId=@ServiceId                 
	----AND Priority<>1                
	--AND FA.FinancialActivityId=@FinancialActivityId                 
	--AND                
	-- FAL.FinancialActivityLineId=@FinancialActivityLineId                
	--AND                
	-- ARL.LedgerType='4204'                
	--AND                
	-- ARL.Amount>0                
	--Group By                 
	-- CP.DisplayAs,CL.LastName ,  CL.FirstName,C.ClientCoveragePlanId, CL.ClientId                
                 
--***************************************************************                
--Table 06 ARLedger                
--***************************************************************                
              
		--select ARL.ARLedgerId,ARL.ChargeId,ARL.FinancialActivityLineId,                
		-- ARL.FinancialActivityVersion,ARL.LedgerType,ARL.Amount,ARL.PaymentId,                
		-- ARL.AdjustmentCode,ARL.AccountingPeriodId,ARL.PostedDate,ARL.ClientId,                
		-- ARL.CoveragePlanId,convert(varchar(10),ARL.DateOfService,101) as DOS, ARL.DateOfService,                
		-- ARL.MarkedAsError,ARL.ErrorCorrection
		-- ,ARL.RowIdentifier
		-- ,ARL.CreatedBy,                
		-- ARL.CreatedDate,ARL.ModifiedBy,ARL.ModifiedDate,ARL.RecordDeleted,                
		-- ARL.DeletedDate,ARL.DeletedBy, GC.CodeName,                
		-- CASE                
		--  WHEN C.ClientCoveragePlanId is NOT NULL then                
		--  (CP.DisplayAs)                
		--  ELSE                
		--  (CL.LastName +', ' + CL.FirstName)         
		-- END  as TransferedTo, C.DoNotBill                
		                
		--from  arledger ARL                
		--LEFT OUTER JOIN GlobalCodes GC ON ARL.AdjustmentCode=GC.GlobalCodeId                
		--LEFT OUTER JOIN Charges C ON ARL.ChargeId=C.ChargeId                
		--LEFT OUTER JOIN clientcoverageplans CCP ON C.ClientCoveragePlanId=CCP.ClientCoveragePlanId                
		--LEFT OUTER JOIN CoveragePlans CP ON CCP.CoveragePlanId=CP.CoveragePlanId                
		--LEFT OUTER JOIN Services S ON C.ServiceId=S.ServiceId                
		--LEFT OUTER JOIN Clients CL ON S.ClientId=CL.ClientId                
		--WHERE FinancialActivityLineId= @FinancialActivityLineId  
		 
--***************************************************************                
--Table 07 FinancialActivityLines                
--***************************************************************                
SELECT 
		FinancialActivityLineId,
		FinancialActivityId,
		ChargeId,
		CurrentVersion,
		Flagged,
		Comment,
		RowIdentifier,
		CreatedBy,
		CreatedDate,
		ModifiedBy,
		ModifiedDate,
		RecordDeleted,
		DeletedDate,
		DeletedBy                 
FROM financialActivitylines                
WHERE FinancialActivityLineId= @FinancialActivityLineId                
                
--***************************************************************                
--Table 13 Coverage Plans                 
--***************************************************************                
              
SELECT  CCH1.ClientCoveragePlanId,                
  CCP1.CoveragePlanId as CoveragePlanId,                 
  --CP.DisplayAs,                
CASE                
  WHEN CCP1.InsuredId IS NULL THEN                
  CP.DisplayAs                
 ELSE                
 CP.DisplayAs + ' ' + isnull(CCP1.InsuredId,'')+ '(' +CONVERT(VARCHAR, isnull(CCH1.COBOrder,'')) + ')' 
 END                 
AS                
  DisplayAs,                
  CCP1.ClientId,                 
  CCH1.StartDate,                 
  CCH1.EndDate ,                 
  CCH1.CobOrder ,   s.ServiceId   ,   p.ServiceAreaId,P.ProgramId                  
-- JHB 12/1/06              
-- Changed complete logic              
from  Services S              
JOIN ClientCoveragePlans CCP1  ON (S.ClientId = CCP1.ClientId)            
JOIN ClientCoverageHistory CCH1 ON (CCP1.ClientCoveragePlanId = CCH1.ClientCoveragePlanId) 
JOIN CoveragePlans CP ON (CCP1.CoveragePlanId = CP.CoveragePlanId)
JOIN Programs P on P.ProgramId = S.ProgramID AND ISNULL(P.RecordDeleted,'N')='N'                   
/*               
LEFT JOIN CoveragePlanRules CPR1 ON (CCP1.CoveragePlanId = CPR1.CoveragePlanId                
and isnull(CPR1.RecordDeleted,'N') = 'N'                
and  CPR1.RuleTypeId = 4267)                
LEFT JOIN CoveragePlanRuleVariables CPRV1                 
ON (CPR1.CoveragePlanRuleId = CPRV1.CoveragePlanRuleId                
and (CPRV1.ProcedureCodeId = S.ProcedureCodeId)              
and isnull(CPRV1.RecordDeleted,'N') = 'N')  
*/              
where S.ServiceId=@ServiceId                
and CCH1.StartDate<= S.DateOfService                
and (CCH1.EndDate is null or dateadd(dd, 1, CCH1.EndDate) > S.DateOfService)              
-- JHB 12/1/06              
--and CPRV1.RuleVariableId is null  
-- JHB 5/28/2013
		  and not exists 
		(select * from CoveragePlans cp1
		JOIN CoveragePlanRules cpr1 ON ((cp1.CoveragePlanId = cpr1.CoveragePlanId
		or cp1.UseBillingRulesTemplateId = cpr1.CoveragePlanId)
		and  isnull(CPR1.RecordDeleted, 'N') = 'N'  
		and  CPR1.RuleTypeId = 4267)
		JOIN CoveragePlanRuleVariables cprv1    
		ON ((cpr1.CoveragePlanRuleId = cprv1.CoveragePlanRuleId    
		and (cprv1.ProcedureCodeId = s.ProcedureCodeId) 
		and (isnull(cprv1.RecordDeleted, 'N') = 'N')) 
		or ISNULL(cpr1.AppliesToAllProcedureCodes,'N')='Y')
		where cp1.CoveragePlanId = cp.CoveragePlanId
		)
		-- Check if Program is billable
		and not exists
		(select * from ProgramPlans pp1
		where pp1.CoveragePlanId = cp.CoveragePlanId
		and pp1.ProgramId = s.ProgramId
		and ISNULL(pp1.RecordDeleted,'N') = 'N')
              
order by  CobOrder   
 
		 
END TRY
              
	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)       
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                            
			+ '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_PMFinancialCorrectionSel')                                                                                             
			+ '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                              
			+ '*****' + CONVERT(VARCHAR,ERROR_STATE())
		RAISERROR
		(
			@Error, -- Message text.
			16,		-- Severity.
			1		-- State.
		);
	END CATCH 
	RETURN
END


GO


