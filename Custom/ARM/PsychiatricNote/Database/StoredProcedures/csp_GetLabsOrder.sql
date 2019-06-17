/****** Object:  StoredProcedure [dbo].[csp_GetLabsOrder]    Script Date: 07/07/2015 16:26:11 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetLabsOrder]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_GetLabsOrder]
GO

/****** Object:  StoredProcedure [dbo].[csp_GetLabsOrder]    Script Date: 07/07/2015 16:26:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_GetLabsOrder] (
	@ClientID INT,
	@Output VARCHAR(max) OUTPUT
	)
AS
/*********************************************************************/
/* Stored Procedure: csp_GetLabsOrder               */
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
		DECLARE @PLACEHOLDER VARCHAR(MAX) = '<table border="0" width="90%" cellspacing="3" cellpadding="0"><tr style="text-decoration:underline"><td>Order Date</td><td>Lab Order</td><td>Ordering Provider</td></tr>###TRSECTION###</table>'
DECLARE @trContent VARCHAR(MAX) = '<tr><td>##OrderStartDate##</td><td>##OrderName##</td><td>##StaffName##</td></tr>'
DECLARE @finalTR VARCHAR(MAX)

SET @finalTR = ''

CREATE TABLE #TempLabOrder (
	ClientOrderId INT
	,OrderStartDateTime VARCHAR(20)
	,OrderName VARCHAR(500)
	,StaffName VARCHAR(200)
	)

DECLARE @OrderStartDateTime VARCHAR(20)
DECLARE @OrderName VARCHAR(500)
DECLARE @StaffName VARCHAR(200)
DECLARE @loopCOUNT INT = 0

INSERT INTO #TempLabOrder
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
WHERE CO.ClientId = @ClientID
	AND O.OrderType = 6481
	AND D.STATUS = 22
	AND ISNULL(D.RecordDeleted, 'N') <> 'Y'
	AND ISNULL(CO.RecordDeleted, 'N') <> 'Y'
	AND ISNULL(O.RecordDeleted, 'N') <> 'Y'

IF EXISTS (
		SELECT *
		FROM #TempLabOrder
		)
BEGIN
	DECLARE #LabOrderCursor CURSOR FAST_FORWARD
	FOR
	SELECT OrderStartDateTime
		,OrderName
		,StaffName
	FROM #TempLabOrder

	OPEN #LabOrderCursor

	FETCH NEXT
	FROM #LabOrderCursor
	INTO @OrderStartDateTime
		,@OrderName
		,@StaffName

	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		SET @finalTR = @finalTR + @trContent
		SET @finalTR = REPLACE(@finalTR, '##OrderStartDate##', @OrderStartDateTime)
		SET @finalTR = REPLACE(@finalTR, '##OrderName##', @OrderName)
		SET @finalTR = REPLACE(@finalTR, '##StaffName##', @StaffName)
		SET @loopCOUNT = @loopCOUNT + 1

		FETCH NEXT
		FROM #LabOrderCursor
		INTO @OrderStartDateTime
			,@OrderName
			,@StaffName
	END
	
	CLOSE #LabOrderCursor

	DEALLOCATE #LabOrderCursor

	DROP TABLE #TempLabOrder

	--DECLARE @FinalOutput VARCHAR(MAX)

	SET @Output = REPLACE(@PLACEHOLDER, '###TRSECTION###', @finalTR)
END
ELSE
BEGIN
	SET @Output = ''
END

--SELECT @FinalOutput
		

	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_GetLabsOrder') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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

