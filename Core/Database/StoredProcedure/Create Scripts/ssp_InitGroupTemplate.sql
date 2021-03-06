/****** Object:  StoredProcedure [dbo].[ssp_InitGroupTemplate]    Script Date: 07/24/2015 12:06:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InitGroupTemplate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_InitGroupTemplate]
GO

/****** Object:  StoredProcedure [dbo].[ssp_InitGroupTemplate]    Script Date: 07/24/2015 12:06:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_InitGroupTemplate] (
	@ClientID INT
	,@StaffID INT
	,@CustomParameters XML
	)
AS
/*********************************************************************/
/* Stored Procedure: [ssp_InitGroupTemplate]               */
/* Creation Date:  13/APRIL/2016                                    */
/* Purpose: To Initialize */
/* Input Parameters:   @ClientID,@StaffID ,@CustomParameters*/
/*********************************************************************/
BEGIN
	BEGIN TRY
		SET ARITHABORT ON 
		DECLARE @CustomGroupId VARCHAR(20) = '0'
		DECLARE @CustomStartDate  VARCHAR(20) = ''
		DECLARE @GroupId INT
		DECLARE @StartDate DATETIME
		SET @CustomGroupId = @CustomParameters.value('(/Root/Parameters/@GroupId)[1]', 'varchar(20)');
		SET @CustomStartDate = @CustomParameters.value('(/Root/Parameters/@StartDate)[1]', 'varchar(20)');
		
		IF ISNULL(@CustomGroupId, '') <> ''
			SET @GroupId = CAST(@CustomGroupId AS INT)

		IF ISNULL(@CustomStartDate, '') <> ''
			SET @StartDate = CAST(@CustomStartDate AS DATETIME)
			
		SELECT 'Documents' AS TableName
			,0 AS DocumentId	
			,'' AS CreatedBy
			,getdate() AS CreatedDate
			,'' AS ModifiedBy
			,getdate() AS ModifiedDate	
			,@StaffID AS AuthorId		
		FROM systemconfigurations s
		LEFT OUTER JOIN Documents ON s.Databaseversion = - 1
			
		SELECT 'GroupTemplates' AS TableName
			,- 1 AS GroupTemplateId	
			,'' AS CreatedBy
			,getdate() AS CreatedDate
			,'' AS ModifiedBy
			,getdate() AS ModifiedDate
			,@GroupId AS GroupId
			,@StaffID AS StaffId
			,@StartDate AS StartDate			
		FROM systemconfigurations s
		LEFT OUTER JOIN GroupTemplates ON s.Databaseversion = - 1	
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[ssp_InitGroupTemplate]') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


