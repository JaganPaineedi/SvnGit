/****** Object:  StoredProcedure [dbo].[ssp_InsertCCDsDataExport]    Script Date: 04/29/2015 14:51:57 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InsertCCDsDataExport]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_InsertCCDsDataExport]
GO

/****** Object:  StoredProcedure [dbo].[ssp_InsertCCDsDataExport]    Script Date: 04/29/2015 14:51:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_InsertCCDsDataExport] @CCDsDataExportId INT
	,@ClientReportFileName VARCHAR(100)
	,@FromDate DATETIME
	,@ToDate DATETIME
	,@CCDsType VARCHAR(1)
	,@LocationType VARCHAR(100)
	,@ClientIds VARCHAR(500)
	,@CreatedBy VARCHAR(250)
	,@ModifiedBy VARCHAR(250)
AS
-- =============================================      
-- Author:  Vijay      
-- Create date: Oct 14, 2017     
-- Description:   Adding Data to CCDsDataExport table
/*      
 Author			Modified Date			Reason      
      
*/
-- ============================================= 
BEGIN TRY
	BEGIN
		
		IF @CCDsDataExportId = 0
		BEGIN
			INSERT INTO CCDsDataExport (
				 FromDate
				,ToDate
				,CCDsType
				,LocationType
				,ClientIds
				,CreatedBy
				,ModifiedBy
				)
			VALUES (
				@FromDate
				,@ToDate
				,@CCDsType
				,@LocationType
				,@ClientIds
				,@CreatedBy
				,@ModifiedBy
				);
		END
		ELSE
		BEGIN
		INSERT INTO CCDsDataExportDetails(
				 CCDsDataExportId
				,CCDFileName
				,ExportDateTime
				,CreatedBy
				,ModifiedBy
				)
			VALUES (
				@CCDsDataExportId
				,@ClientReportFileName
				,GETDATE()
				,@CreatedBy
				,@ModifiedBy
				);
		END
		
			
		SELECT @@IDENTITY
	END
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_InsertCCDsDataExport') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.       
			16
			,-- Severity.       
			1 -- State.                                                         
			);
END CATCH
GO

