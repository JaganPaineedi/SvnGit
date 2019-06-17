/****** Object:  StoredProcedure [dbo].[ssp_SCGetFinancialActivityCollections]    Script Date: 02/06/2015 13:03:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetFinancialActivityCollections]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetFinancialActivityCollections]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetFinancialActivityCollections]    Script Date: 02/06/2015 13:03:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetFinancialActivityCollections] (@ClientId INT
	,@StaffId INT
	,@FromDate DATETIME
	,@ToDate DATETIME)
AS
/********************************************************************************                                                        
-- Stored Procedure: ssp_SCGetFinancialActivityCollections      
--      
-- Copyright: Streamline Healthcate Solutions      
--      
-- Purpose: Query to return data for the Collections.      
--      
-- Author:  Akwinass      
-- Date:    31 Aug 2015     
--      
-- *****History**** 
-- 31 Aug 2015     Akwinass        Created for Collections. (Task #936 in Valley - Customizations)
*********************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @CreatedBy VARCHAR(30)

		SELECT TOP 1 @CreatedBy = UserCode
		FROM Staff
		WHERE StaffId = @StaffId
			AND ISNULL(RecordDeleted, 'N') = 'N'

		SELECT DISTINCT C.CreatedDate AS ActivityDate,
		'Collections' AS Activity
		,CONVERT(VARCHAR, C.CreatedDate, 101) +' - $' + CAST(CAST(ISNULL([dbo].[ssf_SCGetPossibleCollections]('AmountDue',C.ClientId,C.CollectionId),0.00) AS DECIMAL(18,2)) AS VARCHAR(25))
		,S.LastName + ', ' + S.FirstName AS Staff
		FROM Collections C
		LEFT JOIN Staff S ON C.CreatedBy = S.UserCode
		WHERE (ClientId = @ClientId)
			AND CAST(C.CreatedDate AS DATE) >= CAST(@FromDate AS DATE)
			AND CAST(C.CreatedDate AS DATE) <= CAST(@ToDate AS DATE)
			AND (@CreatedBy IS NULL OR C.CreatedBy = @CreatedBy)
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetFinancialActivityCollections') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


