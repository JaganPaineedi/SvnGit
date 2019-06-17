/****** Object:  StoredProcedure [dbo].[ssp_SCGetServiceImageRecords]    Script Date: 11/24/2017 12:10:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetServiceImageRecords]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetServiceImageRecords]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetServiceImageRecords]    Script Date: 11/24/2017 12:10:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- ============================================================================================================================   
-- Author      : Akwinass.D 
-- Date        : 03/NOV/2017
-- Purpose     : To get image records for "Scan/Upload Service"
-- Updates:
-- Date			Author    Purpose 
-- 10/NOV/2017  Akwinass  Created.(Task #589 in Engineering Improvement Initiatives- NBL(I)) */
-- ============================================================================================================================
CREATE PROCEDURE [dbo].[ssp_SCGetServiceImageRecords] @ServiceId INT
AS
BEGIN
	BEGIN TRY
		SELECT TOP 0 *
		FROM ImageRecords
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetServiceImageRecords') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


