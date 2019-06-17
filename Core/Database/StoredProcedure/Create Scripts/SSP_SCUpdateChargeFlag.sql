

/****** Object:  StoredProcedure [dbo].[SSP_SCUpdateChargeFlag]    Script Date: 11/06/2015 01:03:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCUpdateChargeFlag]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCUpdateChargeFlag]
GO


/****** Object:  StoredProcedure [dbo].[SSP_SCUpdateChargeFlag]    Script Date: 11/06/2015 01:03:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SSP_SCUpdateChargeFlag] @ChargeId BIGINT
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: Sept 23, 2014      
-- Description: Retrieves CCR Reson for Referral Data      
/*      
 Author			Modified Date			Reason      
   
      
*/
-- =============================================      
BEGIN
	BEGIN TRY
		DECLARE @Flag CHAR(3)
		
		SELECT @Flag=Flagged From Charges Where ChargeId = @ChargeId And ISNULL(RecordDeleted,'N')='N'
		
		IF ISNULL(@Flag,'N') = 'Y'			
			Update Charges Set Flagged=NULL Where ChargeId = @ChargeId And ISNULL(RecordDeleted,'N')='N'
		ELSE
			Update Charges Set Flagged='Y' Where ChargeId = @ChargeId And ISNULL(RecordDeleted,'N')='N'
			
		SELECT @Flag=Flagged From Charges Where ChargeId = @ChargeId And ISNULL(RecordDeleted,'N')='N'
		
		IF ISNULL(@Flag,'N') = 'Y'
			SET @Flag = 'Yes'
		ELSE 
			SET @Flag=''
			
		SELECT @Flag
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'SSP_SCUpdateChargeFlag') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                     
				16
				,-- Severity.                                                            
				1 -- State.                                                         
				);
	END CATCH
END

GO


