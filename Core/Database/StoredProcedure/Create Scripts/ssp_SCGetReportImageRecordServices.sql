/****** Object:  StoredProcedure [dbo].[ssp_SCGetReportImageRecordServices]    Script Date: 11/24/2017 15:05:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetReportImageRecordServices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetReportImageRecordServices]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetReportImageRecordServices]    Script Date: 11/24/2017 15:05:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- ============================================================================================================================   
-- Author      : Akwinass.D 
-- Date        : 28/NOV/2017
-- Purpose     : To get image record items for "Scan/Upload Service"
-- Updates:
-- Date			Author    Purpose 
-- 28/NOV/2017  Akwinass  Created.(Task #589 in Engineering Improvement Initiatives- NBL(I)) */
-- 07/Dec/2018  MD        Commented out the condition to check IM.ItemImage IS NOT NULL because it is creating performance issue and not returning result w.r.t Comprehensive-Support Go Live #154 
-- ============================================================================================================================
CREATE PROCEDURE [dbo].[ssp_SCGetReportImageRecordServices] @ImageRecordIds VARCHAR(MAX)
AS
BEGIN
	BEGIN TRY
		IF OBJECT_ID('tempdb..#ImageRecordIds') IS NOT NULL
			DROP TABLE #ImageRecordIds

		CREATE TABLE #ImageRecordIds (ImageRecordId INT)

		INSERT INTO #ImageRecordIds (ImageRecordId)
		SELECT CAST(item AS INT)
		FROM dbo.fnSplit(@ImageRecordIds, ',')
		WHERE ISNULL(item, '') <> ''
		
		SELECT IM.ImageRecordId,IM.ItemImage
		FROM ImageRecordItems IM
		WHERE ISNULL(IM.RecordDeleted,'N') = 'N'
			AND EXISTS (SELECT 1 FROM #ImageRecordIds Ids WHERE Ids.ImageRecordId = IM.ImageRecordId)
			--AND IM.ItemImage IS NOT NULL  -- Commented out by MD on 12/07/2018
		ORDER BY IM.ImageRecordId ASC
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetReportImageRecordServices') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


