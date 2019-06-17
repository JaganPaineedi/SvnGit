IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMUpdateUnpostedAndBalance]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMUpdateUnpostedAndBalance]
GO
/****** Object:  StoredProcedure [dbo].[ssp_PMUpdateUnpostedAndBalance]    Script Date: 06/01/2012 17:50:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[ssp_PMUpdateUnpostedAndBalance]
	/* Param List */
	@CurrentUser varchar(30),
	@PaymentId  int,
	@RefundAmount Money,
	@ResultAmount Money,
	@ModifiedDate datetime 
	
	 

AS

/******************************************************************************
**		File: 
**		Name: Stored_Procedure_Name
**		Desc:  This stored procedure is used to update Unposted Amount and Client Balance on Refund from Payment Adjustment screen
**
**		This template can be customized:
**              
**		Return values:
** 
**		Called by:   
**              
**		Parameters:
**		Input							Output
**     ----------							-----------
**
**		Auth: 
**		Date: 
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**		--------		--------				-------------------------------------------
**		16 Dec 2006       Bhupinder Bajwa	
**      04/06/2012        Shruthi.S    ModifiedDate and return statement to fix concurrency issue   
**          12/09/2013    Shruthi.S    Fixed unposted amount doubling issue.Ref #407 Venture Region 3.5 Implementation. 
**  28/03/2014		  Manju P      Calling the ssp to update client's current balance. What/Why: Core Bugs #2181 SC: payment delay .     
** 16.07.2014		PSelvan				For task #135 Philhaven development added new column TypeOfPosting in payments table
/*   20 Oct 2015	Revathi	  what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  */ 
/* 									why:task #609, Network180 Customization  */ 

*******************************************************************************/

  DECLARE @OldBalance money 
  BEGIN try  
  BEGIN tran   
  SELECT @OldBalance = ISNULL(UnpostedAMount,0) from Payments where Paymentid = @PaymentId --UnpostedAMount    
  
  --If there is a refund amount then apply following calculations--    
 if(@RefundAmount<>0)        
    begin     
 -- update unposted amount            
  Update Payments           
       set UnpostedAmount = isnull(UnpostedAmount,0) - isnull(@RefundAmount,0),  ModifiedBy=@CurrentUser, ModifiedDate=getDate()          
     where PaymentId = @PaymentId          
            
         
           
  -- update client balance          
  Update  Clients           
    set CurrentBalance = isnull(CurrentBalance,0) + isnull(@RefundAmount,0), ModifiedBy=@CurrentUser, ModifiedDate=getDate()          
    where ClientId = (Select ClientId from Payments where PaymentId=@PaymentId and isnull(RecordDeleted,'N')='N' )            
      
   end         
        
 if(@ResultAmount <>0)        
   begin        
      
 -- update unposted amount            
  Update Payments           
       set UnpostedAmount = isnull(UnpostedAmount,0) + isnull(@ResultAmount,0),  ModifiedBy=@CurrentUser, ModifiedDate=getDate()          
     where PaymentId = @PaymentId          
            
  
  -- update client balance          
  Update  Clients           
    set CurrentBalance = isnull(CurrentBalance,0) - isnull(@ResultAmount,0), ModifiedBy=@CurrentUser, ModifiedDate=getDate()          
    where ClientId = (Select ClientId from Payments where PaymentId=@PaymentId and isnull(RecordDeleted,'N')='N' )            
     
 end    
   
 Declare @ClientId int  
 Select @ClientId =ClientId from Payments where PaymentId=@PaymentId and isnull(RecordDeleted,'N')='N'   
 EXEC ssp_SCCalculateClientBalance @ClientId  
   
 commit tran  
   
 --select ModifiedDate,ModifiedBy,UnpostedAmount  from Payments where PaymentId = @PaymentId     
                
     SELECT                   
   P.PaymentId,                  
   P.FinancialActivityId,                  
   P.PayerId,                  
   P.CoveragePlanId,                  
   P.ClientId,            
 -- Modified by   Revathi   20 Oct 2015   
	case when  ISNULL(C.ClientType,'I')='I' then ISNULL(C.LastName,'') + ', ' + ISNULL(C.FirstName,'') else ISNULL(C.OrganizationName,'') end AS ClientName,      
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
   p.TypeOfPosting,             
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
      
     
end try  
BEGIN catch   
          DECLARE @Error VARCHAR(max)   
    if @@TRANCOUNT > 0 rollback tran  
          SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'   
                      + CONVERT(VARCHAR(4000), ERROR_MESSAGE())   
                      + '*****'   
                      + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),   
                      'ssp_PMUpdateUnpostedAndBalance'   
                      )   
                      + '*****' + CONVERT(VARCHAR, ERROR_LINE())   
                      + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY())   
                      + '*****' + CONVERT(VARCHAR, ERROR_STATE())   
  
          ROLLBACK TRANSACTION   
  
          RAISERROR ( @Error,   
                      -- Message text.                                                                                   
                      16,   
                      -- Severity.                                                                                   
                      1   
          -- State.                                                                                   
          );   
      END catch