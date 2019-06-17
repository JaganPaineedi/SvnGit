
GO
/****** Object:  StoredProcedure [dbo].[ssp_PMElectronicRemittanceUpdateERFile]    Script Date: 08-09-2012 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMElectronicRemittanceUpdateERFile]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMElectronicRemittanceUpdateERFile]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMElectronicRemittanceUpdateERFile]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE  [dbo].[ssp_PMElectronicRemittanceUpdateERFile]            
    (
		@ERFileId INT,
		@ApplyAdjustments VARCHAR(1),
		@ApplyTransfers VARCHAR(1),
		@DoNotProcess VARCHAR(1),
		@ModifiedBy VARCHAR(500),
		@TotalPayments Money,
		@AccountingPeriodId INT,
		@PaymentDate DATETIME
    )                                                                      
AS                                                                          
                                                                                  
BEGIN                                                                                  
/****************************************************************************** 
** File: ssp_PMElectronicRemittanceUpdateERFile.sql
** Name: ssp_PMElectronicRemittanceUpdateERFile
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
** Auth: Deejkumar MG
** Date: 08/09/2012
******************************************************************************* 
** Change History 
******************************************************************************* 
** Date: 			Author: 			Description: 
** 
-------- 			-------- 			--------------- 
** 
** Modified by Deej 01/19/2018 
** Wht & Why: To include two more columns(AccountingPeriodId,PaymentDate)  as part of parameter but will save only Accounting Period Id. AHN-Customizations #72
*******************************************************************************/
BEGIN TRY 
		UPDATE 
			ERFiles   
		SET
			ApplyAdjustments= @ApplyAdjustments
			,ApplyTransfers=@ApplyTransfers
			,DoNotProcess=@DoNotProcess
			,Processing=''N''
			,ModifiedBy= @ModifiedBy
			,ModifiedDate=GETDATE()
			,TotalPayments=@TotalPayments
			,AccountingPeriodId=@AccountingPeriodId	    
			,PaymentDate=@PaymentDate                                                
		WHERE
			ERFileId=@ERFileId
	
	END TRY
	
	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)       
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + ''*****'' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                            
			+ ''*****'' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),''ssp_PMElectronicRemittanceUpdateERFile'')                                                                                             
			+ ''*****'' + CONVERT(VARCHAR,ERROR_LINE()) + ''*****'' + Convert(VARCHAR,ERROR_SEVERITY())                                                                                              
			+ ''*****'' + CONVERT(VARCHAR,ERROR_STATE())
		RAISERROR
		(
			@Error, -- Message text.
			16,		-- Severity.
			1		-- State.
		);
	END CATCH
	

END

' 
END
GO
