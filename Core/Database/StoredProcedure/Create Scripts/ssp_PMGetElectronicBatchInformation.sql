
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[ssp_PMGetElectronicBatchInformation]') AND TYPE IN (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMGetElectronicBatchInformation]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[ssp_PMGetElectronicBatchInformation]                                
    @ERBatchId int                                                                                      
AS                                                                                                    
BEGIN                 
              
/******************************************************************************     
** File: ssp_PMGetElectronicBatchInformation.sql    
** Name: ssp_PMGetElectronicBatchInformation    
** Desc:      
**     
**     
** This template can be customized:     
**     
** Return values: Filter Values -  Electronic Remittance    
**     
** Called by:     
**     
** Parameters:     
** Input Output     
** ---------- -----------     
** N/A   Dropdown values    
** Auth: Mary Suma    
** Date: 09/23/2011    
*******************************************************************************     
** Change History     
*******************************************************************************     
** Date:			Modified:			Description:     
--------			--------			---------------  
-- 01 March 2017    vsinha				What:  Length of "Display As" to handle procedure code display as increasing to 75     
--										Why :  Keystone Customizations 69  
*******************************************************************************/                                                               
    BEGIN TRY                                                              
                                                       
select PA.PaymentId,PA.Amount,PA.UnPostedAmount,FinancialActivityId,PA.DateReceived,PA.ElectronicPayment from Payments PA                                                      
left join ERBatches ERB on ERB.PaymentId=PA.PaymentId where ERB.ERBatchID=@ERBatchId                                       
                  
DECLARE @FinancialActivities TABLE
(
  FinancialActivityId int 
)                   
 
--declare @FinancialActivityId int  
--set @FinancialActivityId=(select FinancialActivityId from Payments where paymentid=@PaymentID) 
INSERT INTO @FinancialActivities SELECT   FinancialActivityId from Payments P
JOIN ERBatchPayments EP on EP.PaymentId = P.PaymentId AND EP.ERBatchId = @ERBatchId
     
create table #FinancialActivitySummary (            
Identity1                int identity(1,1) not null,            
ParentId                 int               null,            
ServiceId                int               null,            
ChargeId                 int               null,            
FinancialActivityId      int               null,            
FinancialActivityLineId  int               null,            
CurrentVersion           int               null,            
FinancialActivityVersion int               null,            
[Name]                   varchar(100)      null, 
Amount			         money             null,   
DateOfService            datetime          null,            
ProcedureUnit            varchar(350)      null,    --01 March 2017    vsinha        
Balance                  money             null,            
Charge                   money             null,            
Payment                  money             null,            
PaymentId                int               null,            
Adjustment               money             null,            
LedgerType               varchar(10)       null,            
Transfer                 money             null,
ARLedgerId				INT					NULL,  
PostedDate DateTime  ,
	   ClientId INT

         )            
            
insert into #FinancialActivitySummary (            
       ServiceId,            
       ChargeId,            
       FinancialActivityId,            
       FinancialActivityLineId,            
       CurrentVersion,            
       FinancialActivityVersion,            
       [Name],   
       Amount,         
       DateOfService,            
       ProcedureUnit,            
       Balance,            
       Charge,            
       Payment,            
       PaymentId,            
       Adjustment,            
       LedgerType,            
       Transfer,            
       ParentId,
       ARLedgerId   ,
        PostedDate,
	  ClientId  	                                            
       )            
select s.ServiceId,             
       max(case when ch.ChargeId = fal.ChargeId then ch.ChargeId else 0 end),            
       fal.FinancialActivityId,            
       fal.FinancialActivityLineId,             
       fal.CurrentVersion,            
       arl.FinancialActivityVersion,            
       max(c.LastName + ', ' + c.FirstName) as [Name],   
       arl.Amount as Amount,         
       max(s.DateOfService),  
      (substring(Convert(Varchar,max(s.DateOfService),100),13,5)  +   ' ' +                                                              
       max(pc.DisplayAs + ' ' + convert(varchar, s.Unit) + ' ' + gc.CodeName)) as ProcedureUnit,    
       max(oc.Balance) ,            
       max(s.Charge),            
       sum(case when arl.LedgerType = 4202 then arl.Amount else 0 end),            
       max(arl.PaymentId),            
       sum(case when arl.LedgerType = 4203 then arl.Amount else 0 end),            
       max(arl.LedgerType),         
sum(case when arl.LedgerType = 4204 and ch.ChargeId = fal.ChargeId then arl.Amount else 0 end),         
       --sum(case when arl.LedgerType = 4204 and arl.Amount < 0 then arl.Amount else 0 end),            
       0        ,
       arl.ARLedgerId	,                
        arl.PostedDate,
	   arl.ClientId
  from Arledger arl             
       join FinancialActivityLines fal on fal.FinancialActivityLineId = arl.FinancialActivityLineId  
       JOIN @FinancialActivities fal1 on fal1.FinancialActivityId = fal.FinancialActivityId          
       join Charges ch on ch.ChargeId = arl.ChargeId            
       join Services s on s.ServiceId = ch.ServiceId            
       join Clients c on c.ClientId = s.ClientId            
       left join OpenCharges oc on oc.ChargeId = ch.ChargeId            
       join ProcedureCodes pc on pc.ProcedurecodeId = s.ProcedureCodeId            
       left join GlobalCodes gc on gc.GlobalCodeId = s.UnitType            
 where isnull(arl.ErrorCorrection, 'N') = 'N'            
   --and fal.FinancialActivityId = @FinancialActivityId     
 group by s.ServiceId,             
          fal.FinancialActivityId,            
          fal.FinancialActivityLineId,            
          fal.CurrentVersion,            
          arl.FinancialActivityVersion ,
          arl.Amount,
          arl.ARLedgerId ,
          arl.PostedDate,
          arl.ClientId            
 order by s.ServiceId,             
          fal.FinancialActivityId,            
          fal.FinancialActivityLineId,            
          case when fal.CurrentVersion = arl.FinancialActivityVersion then 1 else 2 end,            
          arl.FinancialActivityVersion desc            
            
       
            
 select Identity1,            
       ParentId,            
       ServiceId,            
       ChargeId,            
       FinancialActivityId,            
       FinancialActivityLineId,            
       --CurrentVersion ,            
      -- FinancialActivityVersion,            
       [Name],  
       Amount,          
       DateOfService,            
       ProcedureUnit,             
       --'$' + convert(varchar, Balance, 1) as  Balance,            
       '$' + convert(varchar, Charge, 1) as Charge,             
       '$' + convert(varchar, -Payment, 1) as Payment, 
       FinancialActivityVersion,                  
       PaymentId,            
       '$' + convert(varchar, -Adjustment, 1) as Adjustment,            
       LedgerType,            
       '$' + convert(varchar, -Transfer, 1) as Transfer,ARLedgerId,PostedDate,ClientId	             
   from #FinancialActivitySummary            
 order by [Name], DateOfService   
--Added By Amrik end  
  
                                                           
                               
select distinct(substring(CLiL.ERMessage, 1, 50))  as ERMessage,CLiL.ERMessagetype,ERClaimLineItemLogId,
CLiL.ERClaimLineItemId,CLiL.ErrorFlag from ERClaimLineItemLog CLiL                                  
 inner join ERClaimLineItems CLi on CLi.ERClaimLineItemId =CLiL.ERClaimLineItemId                                  
 where CLi.ERBatchID=@ERBatchId and isnull(CLiL.RecordDeleted,'N')='N'           
                                                                    
 END TRY    
     
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)           
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                                
   + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_PMGetElectronicBatchInformation')                                                                                                 
   + '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                                  
   + '*****' + CONVERT(VARCHAR,ERROR_STATE())    
  RAISERROR    
  (    
   @Error, -- Message text.    
   16,  -- Severity.    
   1  -- State.    
  );    
 END CATCH    
   SET TRANSACTION ISOLATION LEVEL READ COMMITTED        
END    
     
              
GO 