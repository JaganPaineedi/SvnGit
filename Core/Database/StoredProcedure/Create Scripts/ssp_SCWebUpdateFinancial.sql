IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebUpdateFinancial]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCWebUpdateFinancial]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCWebUpdateFinancial]  
(
 @ClientID as bigint 
 )
	-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>f
-- 04.19.2016	Venkatesh		Update the Financial Record.
-- 09.15.2016	Vamsi		What: Modified Header lable Ammount to Amount and Fixed Fee to % of Standard Rate.
--                          Why : MFS - Customization Issue Tracking#953 
-- =============================================  
AS
BEGIN
 BEGIN TRY
	DECLARE @LastPaymentAmmount Money
DECLARE @LastPaymentDate DateTime
declare @FeeArrangement varchar(max)

SELECT Top 1 @LastPaymentAmmount=Amount,@LastPaymentDate=DateReceived FROM Payments WHERE ClientId=@ClientID AND (ISNULL(RecordDeleted, 'N') = 'N') ORDER BY 1 Desc 

IF OBJECT_ID('tempdb..#ClientFinancialSummaryReports') IS NOT NULL                
 DROP TABLE #ClientFinancialSummaryReports
IF OBJECT_ID('tempdb..#ClientFees') IS NOT NULL                
 DROP TABLE #ClientFees

DECLARE @CurrentDate DATETIME    
SELECT @CurrentDate = CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101)) 

CREATE TABLE #ClientFees (			
			StartDate DateTime,
			EndDate DateTime,
			PerSessionRatePercentage Decimal,
			PerSessionRateAmount money
			)
 
INSERT INTO #ClientFees
Select  StartDate,EndDate,PerSessionRatePercentage,PerSessionRateAmount from ClientFees where ClientId=@ClientId AND StartDate<=@CurrentDate AND (ISNULL(RecordDeleted, 'N') = 'N') AND (EndDate IS NULL OR EndDate>=@CurrentDate)

IF EXISTS (SELECT 1 FROM #ClientFees)
BEGIN
set @FeeArrangement = cast( (
select td = d.dbtable + '</td><td align="left">' +  ISNULL(d.entities, '') + '</td><td align="left">' +  ISNULL(d.PerSessionRateAmount, 0) + '</td><td align="left">' +  ISNULL(d.PerSessionRatePercentage, 0) 
from (
      select dbtable  = CONVERT(VARCHAR(19),StartDate,101) ,
               entities = CONVERT(VARCHAR(19),EndDate,101) ,
               PerSessionRatePercentage = CONVERT(VARCHAR(19),PerSessionRatePercentage),
               PerSessionRateAmount= CONVERT(VARCHAR(19),PerSessionRateAmount)               
      from #ClientFees      
      ) as d
for xml path( 'tr' ), type ) as varchar(max) )

set @FeeArrangement = '<div style="height:53px;overflow:auto;"><table cellpadding="2" cellspacing="2" border="0" style="width:100%;" align="left">'
              + '<tr><th align="left" style="font-weight:bold">Start Date</th><th style="font-weight:bold" align="left">End Date</th><th style="font-weight:bold" align="left">Amount</th><th style="font-weight:bold" align="left">% of Standard Rate</th></tr>' -- 09.15.2016	Vamsi
              + replace( replace( @FeeArrangement, '&lt;', '<' ), '&gt;', '>' )
              + '</table></div>'
END
ELSE
BEGIN
set @FeeArrangement = '<div style="height:53px;overflow:auto;"><table cellpadding="2" cellspacing="2" border="0" style="width:100%;" align="left">'
              + '<tr><th align="left" style="font-weight:bold">Start Date</th><th style="font-weight:bold" align="left">End Date</th><th style="font-weight:bold" align="left">Amount</th><th style="font-weight:bold" align="left">% of Standard Rate</th></tr>' -- 09.15.2016	Vamsi
              + replace( replace( '', '&lt;', '<' ), '&gt;', '>' )
              + '</table></div>'
END
 
CREATE TABLE #ClientFinancialSummaryReports (			
			[Type] VARCHAR(20),
			BalanceCurrent money,
			Balance30 money,
			Balance90 money,
			Balance180 money,
			BalanceTotal money
			)

INSERT INTO #ClientFinancialSummaryReports
SELECT     
   CASE   
    WHEN b.Priority = 0  
     THEN 'Client'  
    ELSE 'Coverage'  
    END  
   , SUM(CASE   
     WHEN DATEDIFF(dd, g.DateOfService, @CurrentDate) = 0  
      THEN a.Balance  
     ELSE 0  
     END)  
   , SUM(CASE   
     WHEN DATEDIFF(dd, g.DateOfService, @CurrentDate) BETWEEN 0  
       AND 30  
      THEN a.Balance  
     ELSE 0  
     END)  
   ,SUM(CASE   
     WHEN DATEDIFF(dd, g.DateOfService, @CurrentDate) BETWEEN 31  
       AND 90  
      THEN a.Balance  
     ELSE 0  
     END)  
   
   ,SUM(CASE   
     WHEN DATEDIFF(dd, g.DateOfService, @CurrentDate) > 180  
      THEN a.Balance  
     ELSE 0  
     END)  
   ,SUM(a.Balance) - SUM(CASE   
     WHEN DATEDIFF(dd, g.DateOfService, @CurrentDate) BETWEEN 91  
       AND 180  
      THEN a.Balance  
     ELSE 0  
     END)
  FROM OpenCharges a  
  INNER JOIN Charges b ON (a.ChargeId = b.ChargeId)   
  INNER JOIN Services g ON (b.ServiceId = g.ServiceId)  
  INNER JOIN Clients cl ON (cl.ClientId = g.ClientId)  
  LEFT JOIN ClientCoveragePlans b1 ON (b.ClientCoveragePlanId = b1.ClientCoveragePlanId)
  LEFT JOIN CoveragePlans c ON (b1.CoveragePLanId = c.CoveragePLanId)
  LEFT JOIN Payers d ON (c.PayerId = d.PayerId)  
  LEFT JOIN Staff st ON st.StaffId = g.ClinicianId  
  INNER JOIN ProcedureCodes pc ON pc.ProcedureCodeId = g.ProcedureCodeId  
  WHERE cl.ClientId=@ClientID AND
  ( ( ISNULL(b.DoNotBill,'N')='N' ) OR ( b.LastBilledDate IS NOT NULL AND ISNULL(b.DoNotBill,'N') = 'Y' ) )        
  GROUP BY    
  CASE   
    WHEN b.Priority = 0  
     THEN 'Client'  
    ELSE 'Coverage'
    END 

IF NOT EXISTS (SELECT 1 FROM ClientFinancialSummaryReports WHERE ClientId=@ClientId)
BEGIN
INSERT INTO ClientFinancialSummaryReports(ClientId,CoverageBalanceCurrent,CoverageBalance30,CoverageBalance90,CoverageBalance180,CoverageBalanceTotal,ClientBalanceCurrent, ClientBalance30,                                               
                      ClientBalance90, ClientBalance180, ClientBalanceTotal,ClientLastPaymentAmount,ClientLastPaymentDate,FeeArrangement)
SELECT  @ClientId,
	   (SELECT BalanceCurrent FROM #ClientFinancialSummaryReports WHERE [Type]='Coverage'),
	   (SELECT Balance30 FROM #ClientFinancialSummaryReports WHERE [Type]='Coverage'),
	   (SELECT Balance90 FROM #ClientFinancialSummaryReports WHERE [Type]='Coverage'),
	   (SELECT Balance180 FROM #ClientFinancialSummaryReports WHERE [Type]='Coverage'),
	   (SELECT BalanceTotal FROM #ClientFinancialSummaryReports WHERE [Type]='Coverage'),
	   (SELECT BalanceCurrent FROM #ClientFinancialSummaryReports WHERE [Type]='Client'),
	   (SELECT Balance30 FROM #ClientFinancialSummaryReports WHERE [Type]='Client'),
	   (SELECT Balance90 FROM #ClientFinancialSummaryReports WHERE [Type]='Client'),
	   (SELECT Balance180 FROM #ClientFinancialSummaryReports WHERE [Type]='Client'),
	   (SELECT BalanceTotal FROM #ClientFinancialSummaryReports WHERE [Type]='Client'),
	   @LastPaymentAmmount,
	   @LastPaymentDate,
	   @FeeArrangement	   
END
ELSE
BEGIN
	UPDATE ClientFinancialSummaryReports
	SET  CoverageBalanceCurrent= (SELECT BalanceCurrent FROM #ClientFinancialSummaryReports WHERE [Type]='Coverage'),
	   CoverageBalance30=(SELECT Balance30 FROM #ClientFinancialSummaryReports WHERE [Type]='Coverage'),
	   CoverageBalance90=(SELECT Balance90 FROM #ClientFinancialSummaryReports WHERE [Type]='Coverage'),
	   CoverageBalance180=(SELECT Balance180 FROM #ClientFinancialSummaryReports WHERE [Type]='Coverage'),
	   CoverageBalanceTotal=(SELECT BalanceTotal FROM #ClientFinancialSummaryReports WHERE [Type]='Coverage'),
	   ClientBalanceCurrent=(SELECT BalanceCurrent FROM #ClientFinancialSummaryReports WHERE [Type]='Client'),
	   ClientBalance30=(SELECT Balance30 FROM #ClientFinancialSummaryReports WHERE [Type]='Client'),
	   ClientBalance90=(SELECT Balance90 FROM #ClientFinancialSummaryReports WHERE [Type]='Client'),
	   ClientBalance180=(SELECT Balance180 FROM #ClientFinancialSummaryReports WHERE [Type]='Client'),
	   ClientBalanceTotal=(SELECT BalanceTotal FROM #ClientFinancialSummaryReports WHERE [Type]='Client'),
	   ClientLastPaymentAmount=@LastPaymentAmmount,
	   ClientLastPaymentDate=@LastPaymentDate,
	   FeeArrangement=@FeeArrangement
	   WHERE ClientId=@ClientId
END
		
END TRY
  BEGIN CATCH
    DECLARE @error varchar(8000)

    SET @error = CONVERT(varchar, ERROR_NUMBER()) + '*****'
    + CONVERT(varchar(4000), ERROR_MESSAGE())
    + '*****'
    + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),
    'ssp_SCWebUpdateFinancial')
    + '*****' + CONVERT(varchar, ERROR_LINE())
    + '*****' + CONVERT(varchar, ERROR_SEVERITY())
    + '*****' + CONVERT(varchar, ERROR_STATE())

    RAISERROR (@error,-- Message text.
    16,-- Severity.
    1 -- State.
    );
  END CATCH
END		