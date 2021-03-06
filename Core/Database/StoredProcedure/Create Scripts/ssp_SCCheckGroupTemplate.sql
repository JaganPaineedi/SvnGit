/****** Object:  StoredProcedure [dbo].[ssp_SCCheckGroupTemplate]    Script Date: 07/24/2015 12:27:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCCheckGroupTemplate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCCheckGroupTemplate]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCCheckGroupTemplate]    Script Date: 07/24/2015 12:27:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCCheckGroupTemplate] @FilterDate DATE,
@GroupId INT
AS
/**************************************************************  
Created By   : Akwinass
Created Date : 13-APRIL-2016 
Description  : Used to check Group Template exists or not 
Called From  : Attendance Screens
/*  Date			  Author				  Description */
/*  13-APRIL-2016	  Akwinass				  Created    */
**************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @GroupTemplateId INT = 0		
		SELECT TOP 1 @GroupTemplateId = CAGT.GroupTemplateId			
		FROM GroupTemplates CAGT		
		WHERE CAST(CAGT.StartDate AS DATE) = @FilterDate
			AND ISNULL(CAGT.RecordDeleted, 'N') = 'N'
			AND CAGT.GroupId = @GroupId
			AND EndDate IS NULL
			AND StartDate IS NOT NULL	
			
		IF ISNULL(@GroupTemplateId,0) = 0
		BEGIN
			SELECT TOP 1 @GroupTemplateId = CAGT.GroupTemplateId			
			FROM GroupTemplates CAGT		
			WHERE ISNULL(CAGT.RecordDeleted, 'N') = 'N'
				AND CAGT.GroupId = @GroupId
				AND CAST(@FilterDate AS DATE) BETWEEN CAST(StartDate AS DATE) AND CAST(EndDate AS DATE)
				AND EndDate IS NOT NULL
				AND StartDate IS NOT NULL
		END		
			
		SELECT TOP 1 CAGT.GroupTemplateId
			,CAGT.CreatedBy
			,CAGT.CreatedDate
			,CAGT.ModifiedBy
			,CAGT.ModifiedDate
			,CAGT.RecordDeleted
			,CAGT.DeletedBy
			,CAGT.DeletedDate
			,CAGT.GroupId
			,CAGT.StaffId
			,CAGT.DocumentId
			,CAGT.StartDate
			,CAGT.EndDate			
		FROM GroupTemplates CAGT		
		WHERE CAGT.GroupTemplateId = @GroupTemplateId
			AND ISNULL(CAGT.RecordDeleted, 'N') = 'N'			
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[ssp_SCCheckGroupTemplate]') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


