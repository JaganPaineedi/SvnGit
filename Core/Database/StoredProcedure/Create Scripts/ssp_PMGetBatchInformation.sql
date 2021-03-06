/****** Object:  StoredProcedure [dbo].[ssp_PMGetBatchInformation]    Script Date: 11/18/2011 16:25:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMGetBatchInformation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMGetBatchInformation]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[ssp_PMGetBatchInformation]                                
    @ERBatchId int,                                                                
    @PaymentID int                                                                                        
AS                                                                                                    
             
/* ******************************************************************* */                                                                 
/* Stored Procedure: dbo.[ssp_PMGetBatchInformation]                */                                                                  
/* Copyright: 2006 Streamlin Healthcare Solutions                   */     
/* Creation Date:  15th Nov 2007                                     */                                                  
/* Purpose:  get data for ERfileList Page to Fill datagrid for Display */                               
/* Input Parameters: @ERBatchId, @PaymentID                          */                                                          
/*                                                                   */      
/* Output Parameters:                                               * /                                                              
/* Return:                                                          */                                                
/* Called By: Rajinder Singh                                        */                                                  
/*                                                                   */           
/* Calls:                                                            */      
/*                                                                     */  
/* Data Modifications:                                               */                                              
/*   Updates:                                                        */                  
/*       Date                  Author                    Purpose      */                  
/* 15th Nov 2007               Rajinder Singh  Created                */                                    
/* 28th Feb 2008               Amrik Singh                            */   
/* 01 March 2017			   vsinha					What:  Length of "Display As" to handle procedure code display as increasing to 75     
														Why :  Keystone Customizations 69  */
 /* ******************************************************************* */                     
*/  
                                                                      
  BEGIN       
--**        
--removed by amrik                                                                                   
--select ERBatchID,Convert(varchar(15),ERBatchID)+  ' - ' + Convert(varchar(15),CheckAmount) + ' - '+ Convert(varchar(15),CheckNumber) AS CheckDetails,PaymentId from ERBatches where isnull(Recorddeleted,'N')='N'                                            
         
--Select 0;  --added by amrik        
--**        
               
--                                                                
-- If (@@error!=0)                                  Begin                                                                                                          
--   RAISERROR  20006   'ssp_PMGetBatchInformation: An Error Occured'                                  Return                                                                                                          
-- End                                       
---PaymentDetails                                                                

 BEGIN TRY                                                      
select PA.PaymentId,PA.Amount,PA.UnPostedAmount,FinancialActivityID from Payments PA                                                      
left join ERBatches ERB on ERB.PaymentId=PA.PaymentId where ERB.ERBatchID=@ERBatchId                                       
                  
                        
  If (@@error!=0) 
  BEGIN  
     RAISERROR                                             
   (                                            
     'ssp_PMGetBatchInformation: An Error Occured', -- Message text.                                
     16, -- Severity.                                            
     1 -- State.                                            
    );   Return                                                                                                          
  
  END  
                                            
   
--Added By Amrik start  
declare @FinancialActivityId int  
set @FinancialActivityId=(select FinancialActivityId from Payments where paymentid=@PaymentID)   
     
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
DateOfService            datetime          null,            
ProcedureUnit            varchar(350)      null,      --  01 March 2017			   vsinha    
Balance                  money             null,            
Charge                   money             null,            
Payment                  money             null,            
PaymentID                int               null,            
Adjustment               money             null,            
LedgerType               varchar(10)       null,            
Transfer                 money             null,
ARLedgerId				INT					NULL,            
         )            
            
insert into #FinancialActivitySummary (            
       ServiceId,            
       ChargeId,            
       FinancialActivityId,            
       FinancialActivityLineId,            
       CurrentVersion,            
       FinancialActivityVersion,            
       [Name],            
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
       ARLedgerId                                             
       )            
select s.ServiceId,             
       max(case when ch.ChargeId = fal.ChargeId then ch.ChargeId else 0 end),            
       fal.FinancialActivityId,            
       fal.FinancialActivityLineId,             
       fal.CurrentVersion,            
       arl.FinancialActivityVersion,            
       max(c.LastName + ', ' + c.FirstName) as [Name],            
       max(s.DateOfService),  
      (Convert(Varchar,max(s.DateOfService),108) + ' ' +                                                                
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
       arl.ARLedgerId                  
         
  from Arledger arl             
       join FinancialActivityLines fal on fal.FinancialActivityLineId = arl.FinancialActivityLineId            
       join Charges ch on ch.ChargeId = arl.ChargeId            
       join Services s on s.ServiceId = ch.ServiceId            
       join Clients c on c.ClientId = s.ClientId            
       left join OpenCharges oc on oc.ChargeId = ch.ChargeId            
       join ProcedureCodes pc on pc.ProcedurecodeId = s.ProcedureCodeId            
       left join GlobalCodes gc on gc.GlobalCodeId = s.UnitType            
 where isnull(arl.ErrorCorrection, 'N') = 'N'            
   and fal.FinancialActivityId = @FinancialActivityId     
 group by s.ServiceId,             
          fal.FinancialActivityId,            
          fal.FinancialActivityLineId,            
          fal.CurrentVersion,            
          arl.FinancialActivityVersion ,
          arl.ARLedgerId             
 order by s.ServiceId,             
          fal.FinancialActivityId,            
          fal.FinancialActivityLineId,            
          case when fal.CurrentVersion = arl.FinancialActivityVersion then 1 else 2 end,            
          arl.FinancialActivityVersion desc            
            
---- Set parent Id             
--update fas            
--   set ParentId = fas2.Identity1            
--  from #FinancialActivitySummary fas            
--       join #FinancialActivitySummary fas2 on fas2.ServiceId = fas.ServiceId and            
--                                              fas2.FinancialActivityLineId = fas.FinancialActivityLineId and            
--                                              fas2.Identity1 = fas.Identity1 - 1            
            
 select Identity1,            
       ParentId,            
       ServiceId,            
       ChargeId,            
       FinancialActivityId,            
       FinancialActivityLineId,            
       --CurrentVersion ,            
      -- FinancialActivityVersion,            
       [Name],            
       DateOfService,            
       ProcedureUnit,             
       --'$' + convert(varchar, Balance, 1) as  Balance,            
       '$' + convert(varchar, Charge, 1) as Charge,             
       '$' + convert(varchar, -Payment, 1) as Payment,            
       PaymentID,            
       '$' + convert(varchar, -Adjustment, 1) as Adjustment,            
      -- LedgerType,            
       '$' + convert(varchar, -Transfer, 1) as Transfer             
   from #FinancialActivitySummary            
 order by [Name], DateOfService   
--Added By Amrik end  
 
  
   If (@@error!=0) 
  BEGIN  
     RAISERROR                                             
   (                                            
     'ssp_PMGetBatchInformation: An Error Occured', -- Message text.                                
     16, -- Severity.                                            
     1 -- State.                                            
    );   Return                                                                                                          
  
  END  
                                                            
-----GlobalCodes                                                            
                                                       
----                                                            
----select * from GlobalCodes  where Category='Service Error Reason'                                                            
----amrik 9/feb/08                              
--select GlobalCodeId,CodeName from GlobalCodes where globalcodeId in(                              
--select CLiL.ERMessagetype from ERClaimLineItemLog CLiL                                  
-- inner join ERClaimLineItems CLi on CLi.ERClaimLineItemId =CLiL.ERClaimLineItemId                                  
-- where CLi.ERBatchID=@ERBatchId and isnull(CLiL.RecordDeleted,'N')='N'                                  
--  )                          
----select ERMessageType,ErMessage from ERClaimLineItemLog                              
--                                 
select distinct(substring(CLiL.ERMessage, 1, 50))  as ERMessage,CLiL.ERMessagetype,
CLiL.ERClaimLineItemId,CLiL.ErrorFlag from ERClaimLineItemLog CLiL                                  
 inner join ERClaimLineItems CLi on CLi.ERClaimLineItemId =CLiL.ERClaimLineItemId                                  
 where CLi.ERBatchID=@ERBatchId and isnull(CLiL.RecordDeleted,'N')='N'           

                                                             
  If (@@error!=0) 
  BEGIN  
     RAISERROR                                             
   (                                            
     'ssp_PMGetBatchInformation: An Error Occured', -- Message text.                                
     16, -- Severity.                                            
     1 -- State.                                            
    );   Return                                                                                                          
  
  END  
  
  
  END TRY
BEGIN CATCH
   DECLARE @Error varchar(8000)                                            
         SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                             
         + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_PMGetBatchInformation')                                        
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


