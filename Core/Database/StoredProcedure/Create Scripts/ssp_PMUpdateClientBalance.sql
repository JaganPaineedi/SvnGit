
/****** Object:  StoredProcedure [dbo].[ssp_PMUpdateClientBalance]    Script Date: 04/16/2011 06:58:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[ssp_PMUpdateClientBalance]') AND TYPE IN (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMUpdateClientBalance]
GO

/****** Object:  StoredProcedure [dbo].[ssp_PMUpdateClientBalance]    Script Date: 04/16/2011 06:58:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_PMUpdateClientBalance]
/********************************************************************************                                                  
-- Stored Procedure: ssp_PMUpdateClientBalance
--
-- Copyright: Streamline Healthcare Solutions
--
-- Purpose: Procedure to update client balance
--
-- Author:  Girish Sanaba
-- Date:    August 08 2011
--
-- *****History****
26 Aug 2011 Girish Changed RETURN statement and currentbalance computation	
27 Sep 2011 GIrish Removed RETURN statement and selecting currentbalance instead	
24 Feb 2012 Pradeep changed RETUEN statement and selecting PaymentId  	
16 Jul 2014 Pselvan	Insert new value TypeOfPosting into Payments table and inserting new row for PaymentCopayments table Why : For task #135 of Philhaven Development.
11 Feb 2015 Pselvan Calling ssp_SCAutoPaymentPosting SP for every payment (on click of Update button in Reception list page). For task #135 of Philhaven Development.
03 Mar 2015	Pselvan Calling the stored procedure 'ssp_SCAutoPaymentPosting' outside the while loop. For task #135 of Philhaven Development.
07 April 2015 Arjun K R Select @PaymentId is placed before executing ssp_SCAutoPaymentPosting sp - Task #88 WMU Customization Issues Tracking.
27 July 2015 MD Khusro Changed ElectronicPayment column value from 'Y' to 'N' if you collect a client payment for reception w.r.t task #1826 Core Bugs
*********************************************************************************/
@ClientId			INT,
@UserId				VARCHAR(30),
@DateReceived		DATETIME,
@NameIfNotClient	VARCHAR(100),
@PaymentMethod		INT,
@ReferenceNumber	VARCHAR(50),
@CardNumber			VARCHAR(25),
@ExpirationDate		VARCHAR(4),
@Amount				MONEY,
@LocationId			INT,
@PaymentSource		INT,
@Comment			TEXT,
@ServiceId int,
@TypeOfPosting int,
@CopaymentAmounts VARCHAR(4000)

  

	
	
AS
BEGIN  
                                                            
	BEGIN TRY
	
	DECLARE @FinancialActivityId INT
	DECLARE @PaymentId INT	
	
	INSERT INTO [FinancialActivities] ([PayerId], [CoveragePlanId], [ClientId], [ActivityType], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate])
	VALUES(NULL,NULL,@ClientId,4325,@UserId,GETDATE(),@UserId,GETDATE())
	
	SET @FinancialActivityId = SCOPE_IDENTITY();  
	-- Changed ElectronicPayment column value from 'Y' to 'N' on 07/27/2015 by MD Khusro
	INSERT INTO [Payments] ([FinancialActivityId], [PayerId], [CoveragePlanId], [ClientId], [DateReceived], [NameIfNotClient], [ElectronicPayment], [PaymentMethod], [ReferenceNumber], [CardNumber], [ExpirationDate], [Amount], [LocationId], [PaymentSource], [UnpostedAmount],  [Comment], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate],[TypeOfPosting])	
	VALUES(@FinancialActivityId,NULL,NULL,@ClientId,@DateReceived,@NameIfNotClient,'N',@PaymentMethod,@ReferenceNumber,@CardNumber,@ExpirationDate,@Amount,@LocationId,@PaymentSource,@Amount,@Comment,@UserId,GETDATE(),@UserId,GETDATE(),@TypeOfPosting)

	SET @PaymentId = SCOPE_IDENTITY();  
	
	UPDATE [Clients] SET [CurrentBalance] = isnull(CurrentBalance,0) - @Amount, [LastPaymentId] = @PaymentId
	WHERE [ClientId] = @ClientId 
	
	-- Ponnin Changes starts for inserting new rows in to •	PaymentCopayments table.
			DECLARE	@ClientCopayAmount Money
			DECLARE @ClientServiceID INT
			DECLARE	@PublicHealthSurveillanceId INT
			DECLARE	@RowCount INT  
			DECLARE	@Counter INT
	
	
			CREATE TABLE #SplitTable 
				(
				  Id INT IDENTITY,
				  SplitText varchar(100)
				)
				INSERT	INTO #SplitTable
					( SplitText
					)
					SELECT item 
					FROM	[dbo].fnSplit(@CopaymentAmounts, ',')  
					

			 
					SET @RowCount = @@RowCount
					SET @Counter = 1
	 --loop through the Clientids to insert the record in the PaymentCopayments table for each client id(row)
			WHILE @Counter <= @RowCount 
				BEGIN
					SELECT	@ClientCopayAmount =  SUBSTRING(SplitText, 1, CHARINDEX('~', SplitText) - 1),
					@ClientServiceID = SUBSTRING(SplitText, CHARINDEX('~', SplitText) + 1, LEN(SplitText)) 
					FROM	#SplitTable
					WHERE	Id = @Counter 
					

					
					-- insert the record in the PaymentCopayments table
					INSERT	INTO PaymentCopayments
							( PaymentId, 
							  ServiceId,
							  Copayment,
							  Applied,
							  CreatedBy,
							  CreatedDate,
							  ModifiedBy,
							  ModifiedDate
							)
					VALUES	( 
							  @PaymentId,
							  @ClientServiceID,
							  @ClientCopayAmount,
							  'N',
							  @UserId,
							  GETDATE(),
							  @UserId,
							  GETDATE()
							)  
							
						-- Auto-payment posting call on click of Reception 'Update' button. 
								SET @Counter = @Counter + 1 
					END    
					
					-- Arjun K R 07/04/2014
					SELECT @PaymentId	
					
			EXEC ssp_SCAutoPaymentPosting @PaymentId, NULL
	-- Ponnin Changes Ends for inserting new rows in to PaymentCopayments table.
	
	

	
	END TRY
	
	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)       
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                            
			+ '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_PMUpdateClientBalance')                                                                                             
			+ '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                              
			+ '*****' + CONVERT(VARCHAR,ERROR_STATE())
		RAISERROR
		(
			@Error, -- Message text.
			16,		-- Severity.
			1		-- State.
		);
	END CATCH
END

GO


