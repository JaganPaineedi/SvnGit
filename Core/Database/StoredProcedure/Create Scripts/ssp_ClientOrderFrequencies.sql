IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ClientOrderFrequencies]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_ClientOrderFrequencies]
GO

CREATE PROCEDURE [dbo].[ssp_ClientOrderFrequencies] @OrderId INT
AS
/**************************************************************          
  Created By   : Neha [ssp_ClientOrderFrequencies]  1078      
  Created Date : 17 Oct 2018         
  Description  : To get default frequency on order setup   
  Called From  :ClientOrderUserControl.ashx   
  /*  Date        Author          Description */                 
  **************************************************************/
BEGIN
	BEGIN TRY
		SELECT OTF.OrderTemplateFrequencyId
			,OTF.DisplayName
			,ISNULL(OFR.IsDefault,'N') as IsDefault
		FROM OrderFrequencies OFR
		INNER JOIN OrderTemplateFrequencies OTF ON OFR.OrderTemplateFrequencyId = OTF.OrderTemplateFrequencyId
			AND ISNULL(OTF.RecordDeleted, 'N') = 'N'
		WHERE
		 OFR.OrderId = @OrderId
			AND ISNULL(OFR.RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_ClientOrderFrequencies') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())

		RAISERROR (
				@Error
				,-- Message text.        
				16
				,-- Severity.        
				1 -- State.        
				);
	END CATCH
END
