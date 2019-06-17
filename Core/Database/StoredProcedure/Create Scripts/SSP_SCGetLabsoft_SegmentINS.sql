/****** Object:  StoredProcedure [dbo].[SSP_SCGetLabsoft_SegmentINS]    Script Date: 09/11/2015 12:39:47 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCGetLabsoft_SegmentINS]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_SCGetLabsoft_SegmentINS]
GO

/****** Object:  StoredProcedure [dbo].[SSP_SCGetLabsoft_SegmentINS]    Script Date: 09/11/2015 12:39:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_SCGetLabsoft_SegmentINS] @ClientId INT
	,@EncodingChars NVARCHAR(5)
	,@INSSegmentRaw NVARCHAR(max) OUTPUT
AS
/*  
-- ================================================================    
-- Stored Procedure: SSP_SCGetLabsoft_SegmentINS    
-- Create Date : Sep 09 2015   
-- Purpose : Get INS Segment for Labsoft    
-- Created By : Gautam    
 declare @INSSegmentRaw nVarchar(max)  
 exec SSP_SCGetLabsoft_SegmentINS 7783, '|^~\&' ,@INSSegmentRaw Output  
 select @INSSegmentRaw   
-- ================================================================    
-- History --    
-- 06-15-2016	PradeepA	Moved the logic to SCSP for customization.
-- ================================================================    
*/
BEGIN
	BEGIN TRY
		EXEC SCSP_SCGetLabsoft_SegmentINS @ClientId,@EncodingChars,@INSSegmentRaw OUTPUT
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_SCGetLabsoft_SegmentINS') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		INSERT INTO ErrorLog (
			ErrorMessage
			,VerboseInfo
			,DataSetInfo
			,ErrorType
			,CreatedBy
			,CreatedDate
			)
		VALUES (
			@Error
			,NULL
			,NULL
			,'Labsoft Procedure Error'
			,'SmartCare'
			,GetDate()
			)

		RAISERROR (
				@Error
				,-- Message text.                                                                        
				16
				,-- Severity.                                                                        
				1 -- State.                                                                        
				);
	END CATCH
END
