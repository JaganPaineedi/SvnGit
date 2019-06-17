/****** Object:  StoredProcedure [dbo].[csp_RDLGetLabOrder]    Script Date: 07/07/2015 16:26:11 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLGetLabOrder]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_RDLGetLabOrder]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLGetLabOrder]    Script Date: 07/07/2015 16:26:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_RDLGetLabOrder] (
	@DocumentVersionId INT
	)
AS
/*********************************************************************/
/* Stored Procedure: csp_RDLGetLabOrder               */
/* Creation Date:  23/june/2012                                    */
/*                                                                   */
/* Purpose: */
/*                                                                   */
/* Input Parameters:  */
/*                                                                   */
/* Output Parameters:                                */
/*                                                                   */
/* Return:   */
/*                                                                   */
/* Called By:CustomDocuments Class Of DataService    */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/***********************************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @ClientId INT

SET @ClientId = (
		SELECT DISTINCT C.ClientId
		FROM Clients C
		INNER JOIN Documents D ON D.ClientId = C.ClientId
		INNER JOIN DocumentVersions DV ON DV.DocumentId = D.DocumentId
		WHERE D.CurrentDocumentVersionId = @DocumentVersionId
			AND ISNULL(D.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(C.RecordDeleted, 'N') <> 'Y'
		)

SELECT DISTINCT CO.ClientOrderId
	,CONVERT(VARCHAR(10), CO.OrderStartDateTime, 101) AS OrderStartDateTime
	,O.OrderName
	,S.LastName + ', ' + S.FirstName AS StaffName
FROM ClientOrders CO
INNER JOIN Clients C ON C.ClientId = CO.ClientId
	AND ISNULL(C.RecordDeleted, 'N') <> 'Y'
	AND ISNULL(CO.RecordDeleted, 'N') <> 'Y'
INNER JOIN Documents D ON D.DocumentId = CO.DocumentId
INNER JOIN Orders O ON CO.OrderId = O.OrderId
LEFT JOIN Staff S ON CO.OrderingPhysician = S.StaffId
WHERE CO.ClientId = @ClientId
	AND O.OrderType = 6481
	AND D.STATUS = 22
	AND ISNULL(D.RecordDeleted, 'N') <> 'Y'
	AND ISNULL(CO.RecordDeleted, 'N') <> 'Y'
	AND ISNULL(O.RecordDeleted, 'N') <> 'Y'

	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLGetLabOrder') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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

