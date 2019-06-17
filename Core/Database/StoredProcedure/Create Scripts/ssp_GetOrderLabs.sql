--WARNING! ERRORS ENCOUNTERED DURING SQL PARSING!
/****** Object:  StoredProcedure [dbo].[ssp_GetOrderLabs]    Script Date: 11/30/2017 11:57:22 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetOrderLabs]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetOrderLabs]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetOrderLabs]    Script Date: 11/30/2017 11:57:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetOrderLabs] 
	@ClientId INT
	,@DocumentId INT
	,@EffectiveDate DATETIME
AS
/****************************************************************************
** Author:		Chethan N
** Create date: Nov, 30 2017
** Description:	To get Lab Orders to Progress Notes
**	EXEC ssp_GetOrderLabs 37558,738486,'2017-01-01' 
**	Modifications:
**		Date			Author			Description
**	--------------	------------------	------------------------------------

****************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @listStr VARCHAR(MAX)

		SELECT @listStr = COALESCE(@listStr + ', ', '') + (O.OrderName)
		FROM ClientOrders CO
		JOIN Documents D ON D.InProgressDocumentVersionId = CO.DocumentVersionId
		JOIN Orders O ON O.OrderId = CO.OrderId
		WHERE D.DocumentId = @DocumentId
			AND CO.OrderType = 'Labs'
			AND ISNULL(CO.RecordDeleted, 'N') = 'N'

		SELECT '<span style="color:black">' + CASE 
				WHEN @listStr IS NULL
					THEN '<span style="font-weight:bold">Ordered Labs</span><br>None'
				ELSE '<span style="font-weight:bold">Ordered Labs</span><br>' + @listStr
				END + '</span>'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetOrderLabs') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.    
				16
				,-- Severity.    
				1 -- State.    
				);
	END CATCH
END