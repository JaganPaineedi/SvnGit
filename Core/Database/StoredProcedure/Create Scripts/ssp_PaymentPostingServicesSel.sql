/****** Object:  StoredProcedure [dbo].[ssp_PaymentPostingServicesSel]    Script Date: 11/18/2011 16:25:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PaymentPostingServicesSel]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PaymentPostingServicesSel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  Procedure [dbo].[ssp_PaymentPostingServicesSel]
	/* Param List */
AS

/******************************************************************************
**		File: dbo.PaymentPostingServicesSel.prc
**		Name: ssp_PaymentPostingServicesSel
**		Desc: 
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
**		Auth: Rohit
**		Date: 
*******************************************************************************
**		Change History
*******************************************************************************
**  Date:        Modified:    Description:            
**  --------      --------    -------------------------------------------            
/*  03/01/2017      vsinha	  What:  Length of "Display As" to handle procedure code display as increasing to 75     
							  Why :  Keystone Customizations 69  */
*******************************************************************************/
/*************************************************************************
**for displaying services in Services tab of PaymentAdjustmentposting
***************************************************************************/
BEGIN
BEGIN TRY
DECLARE @FinancialActivityId int,
	@ChargeID int,
	@ServiceId int,
	@Name varchar(100),
	@DateOfService DateTime,
	@ProcedureUnit varchar(350),   --03/01/2017      vsinha
	@Balance money,
	@Charge money,
	@Amount money,
	@PaymentID int,
	@LedgerType varchar(10),
	@Flag char,
	@Comment varchar(100),
	@Adjustment money,
	@Transfer money,
	@Counter int,
	@TempGroupId int

DECLARE selServicePayment CURSOR FOR 
SELECT
		 FAL.FinancialActivityId,
		 FAL.ChargeID,
		 Ch.ServiceId,
		 C.LastName + ' , ' + C.FirstName as [Name],
		 S.DateOfService,
		 convert(varchar,PC.DisplayAs) + ' ' + convert(varchar,S.Unit) + ' ' + convert(varchar,GC.CodeName) as [ProcedureUnit],
		 OC.Balance ,
		 S.Charge,
		 ARL.Amount,
		 ARL.PaymentID,
		 ARL.LedgerType,
		 FAL.Flagged,
		 FAL.Comment
FROM
	 financialActivitylines FAL
	 LEFT OUTER JOIN Charges Ch ON FAL.ChargeId=Ch.ChargeId
	 LEFT OUTER JOIN services S ON Ch.ServiceId=S.serviceID
	 LEFT OUTER JOIN clients C ON S.clientId=C.ClientID
	 LEFT OUTER JOIN procedurecodes PC ON S.ProcedurecodeId=PC.ProcedureCodeId
	 LEFT OUTER JOIN GlobalCodes GC ON S.UnitType=GC.GlobalCodeId
	 LEFT OUTER JOIN OpenCharges OC ON Ch.ChargeId=OC.ChargeId
	 LEFT OUTER JOIN ARLedger ARL ON ARL.FinancialActivityLineId=FAL.FinancialActivityLineId
WHERE
	 ARL.ChargeId = FAL.ChargeId 
AND  FAL.CurrentVersion = ARL.FinancialActivityVersion
ORDER BY
	 Ch.ServiceId

OPEN selServicePayment
FETCH	selServicePayment
INTO	@FinancialActivityId ,
		@ChargeID ,
		@ServiceId ,
		@Name ,
		@DateOfService ,
		@ProcedureUnit ,
		@Balance,
		@Charge ,
		@Amount ,
		@PaymentID ,
		@LedgerType,
		@Flag,
		@Comment

SET @Counter=1
SET @TempGroupId=0
CREATE TABLE #temp1
			(
				 EditButton char
				,FinancialActivityId int
				,ChargeID int
				,ServiceId int
				,[Name] varchar(100)
				,DateOfService DateTime
				,ProcedureUnit varchar(350)  --03/01/2017      vsinha
				,Balance money
				,Charge money
				,Payment money
				,PaymentID int
				,Adjustment money
				,LedgerType varchar(10)
				,transfer money
				,Bitmap varchar(50)
				,coment varchar(100)
			)

WHILE @@Fetch_Status = 0  
BEGIN  
	IF @TempGroupId=@FinancialActivityId
	BEGIN
		SET @Counter=@Counter + 1
		--call sp to find status of the groupservice
	END
	ELSE
	BEGIN
		SET @TempGroupId=@FinancialActivityId
		SET @Counter=1
		--Select @GroupId
	END
	
	IF @Counter=1
	BEGIN
		print @LedgerType
		SET @Adjustment=null	
		SET @Transfer=null
		
		IF @LedgerType='4203'
		BEGIN
			SET @Adjustment=@Amount
		END
		ELSE IF @LedgerType='4204'
		BEGIN
			SET @Transfer=@Amount
		END
		/*** Get if flag is set to Y if Y then put the flag bitmap into temp table
			**/
		Declare @Bitmap varchar(50)
		SET @Bitmap=null
		if @Flag='Y'
		begin
		SET @Bitmap='Admit.bmp'
		end

		insert into #temp1(EditButton,FinancialActivityId , ChargeID, ServiceId,[Name], DateOfService, ProcedureUnit, Balance, Charge, Payment, PaymentID,	Adjustment, LedgerType, transfer, Bitmap, coment)
		values('E',@FinancialActivityId, @ChargeID, @ServiceId, @Name, @DateOfService, @ProcedureUnit, @Balance, @Charge ,@Amount, @PaymentID, @Adjustment, @LedgerType, @Transfer, @Bitmap, @Comment)
	END
	else if @Counter>1
	begin

		if @LedgerType='4203'
		begin
			Declare @AdjAmt money
			select @AdjAmt= Adjustment from #temp1 where FinancialActivityId=@FinancialActivityId --ServiceId=@ServiceId
			
			if @AdjAmt is null and @Amount is not null
			begin
				update #temp1 set Adjustment=  @Amount where FinancialActivityId=@FinancialActivityId--- ServiceId=@ServiceId
			end
			else if @AdjAmt is not null and @Amount is not null
			begin
				update #temp1 set Adjustment= Adjustment + @Amount where FinancialActivityId=@FinancialActivityId --ServiceId=@ServiceId
			end
		end
		else if @LedgerType='4204'
		begin
			print 'prev amount=' print convert(varchar,@Transfer )
			print 'Current amt='
			print convert(varchar,@Amount)
			if @Transfer * -1 = @Amount
			begin
				print 'same transfer'
			end
			else
			begin
				Declare @TransAmt money
				select @TransAmt= Transfer from #temp1 where ServiceId=@ServiceId
				
				if @TransAmt is null and @Amount is not null
				begin
					update #temp1 set Transfer=  @Amount where FinancialActivityId=@FinancialActivityId --ServiceId=@ServiceId
				end
				else if @TransAmt is not null and @Amount is not null
				begin
					update #temp1 set Transfer= Transfer + @Amount  where FinancialActivityId=@FinancialActivityId-- ServiceId=@ServiceId
				end
			end
		set @Transfer=  @Amount 
		end

	end

Fetch	selServicePayment into
		 @FinancialActivityId ,
		@ChargeID ,
		@ServiceId ,
		@Name ,
		@DateOfService ,
		@ProcedureUnit ,
		@Balance,
		@Charge ,
		@Amount ,
		@PaymentID ,
		@LedgerType,
		@Flag,
		@Comment


END
close selServicePayment       
DEALLOCATE selServicePayment
    
Select * from #temp1    
drop table #temp1
END TRY
BEGIN CATCH
   DECLARE @Error varchar(8000)                                            
         SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                             
         + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_PaymentPostingServicesSel')                                        
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