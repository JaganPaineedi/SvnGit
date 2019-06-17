 IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[ssp_PMUpdateClientCurrentBalance]') AND TYPE IN (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMUpdateClientCurrentBalance]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[ssp_PMUpdateClientCurrentBalance]
      /* Param List */
      @CurrentBalance Money,  
      @CurrentUser  varchar(30),  
      @PaymentId int,  
      @NewPayment char(1) ,
      @OldAmount Money 
AS
 
/******************************************************************************
**          File: 
**          Name: Stored_Procedure_Name
**          Desc:  This stored procedure is used to Update ClientBalance in Clients
**
**          This template can be customized:
**              
**          Called by:   
**              
**          Parameters:
**          Input                                     Output
**     ----------                                     -----------
**
**          Auth: 
**          Date: 
*******************************************************************************
**          Change History
*******************************************************************************
**          Date:			Author:                 Description:
**          --------		--------         -------------------------------------------
**          17 June 2012    Veena S Mani  
**			19 Oct 2015		Revathi			what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.        
**											why:task #609, Network180 Customization       
*******************************************************************************/
 
  begin      
    
  DECLARE @ResultAmount money  
  DECLARE @OldBalance money  
  SELECT @OldBalance = ISNULL(UnpostedAMount,0) from Payments where Paymentid = @PaymentId --UnpostedAMount  
  SET @ResultAmount =@CurrentBalance-@OldAmount   
  --SET @ResultAmount = @OldBalance - @CurrentBalance  
    
  IF @NewPayment = 'Y'  
  BEGIN  
     Update  Clients       
   set CurrentBalance = isnull(CurrentBalance,0)+ isnull(-@CurrentBalance,0) , ModifiedDate=getDate(),ModifiedBy=@CurrentUser ,LastPaymentId=@PaymentId       
   where ClientId = (Select ClientId from Payments where PaymentId=@PaymentId and isnull(RecordDeleted,'N')='N' )        
  
  --Update Payments       
  --    set UnpostedAmount = isnull(UnpostedAmount,0) + isnull(@ResultAmount,0),   ModifiedDate=getDate()      
  --  where PaymentId = @PaymentId    
     
  END  
  ELSE  
    
  --if(@ResultAmount <>0)    
   begin    
  
 -- update unposted amount        
    Update Payments       
      set UnpostedAmount = isnull(UnpostedAmount,0) + isnull(@ResultAmount,0),   ModifiedDate=getDate()      
    where PaymentId = @PaymentId      
          
     
         
    -- update client balance      
    Update  Clients       
   set CurrentBalance = isnull(CurrentBalance,0) - isnull(@ResultAmount,0), ModifiedDate=getDate() ,ModifiedBy=@CurrentUser,LastPaymentId=@PaymentId    
   where ClientId = (Select ClientId from Payments where PaymentId=@PaymentId and isnull(RecordDeleted,'N')='N' )        
  
    end     
     
      
      
   end     
    SELECT               
   P.PaymentId,              
   P.FinancialActivityId,              
   P.PayerId,              
   P.CoveragePlanId,  
   P.ClientId,     
   --Added by Revathi    
   case when  ISNULL(C.ClientType,'I')='I' then ISNULL(C.LastName,'')+', '+ ISNULL(C.FirstName,'') else ISNULL(C.OrganizationName,'') end AS ClientName,  
   --convert(varchar,P.DateReceived,101) as DateReceived, 
   P.DateReceived,             
   P.NameIfNotClient,              
   P.ElectronicPayment,              
   P.PaymentMethod,              
   P.ReferenceNumber,              
   P.CardNumber,              
   P.ExpirationDate,              
   P.Amount,              
   P.LocationId,              
   P.PaymentSource,              
   P.UnpostedAmount,              
   P.Comment,       
   p.FundsNotReceived,         
   P.RowIdentifier,              
   P.CreatedBy,              
   P.CreatedDate,              
   P.ModifiedBy,              
   P.ModifiedDate,              
   P.RecordDeleted,              
   P.DeletedDate,              
   P.DeletedBy              
  FROM              
    Payments  P      
  LEFT JOIN   
   Clients C      
    ON  
    C.ClientId = P.ClientId  
  WHERE               
   P.PaymentId=@PaymentId             
  
