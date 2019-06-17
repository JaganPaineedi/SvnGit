/****** Object:  StoredProcedure [dbo].[smsp_GetCustomFieldJson]    Script Date: 10/29/2014 15:03:31 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[smsp_GetCustomFieldJson]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[smsp_GetCustomFieldJson]
GO

/****** Object:  StoredProcedure [dbo].[smsp_GetCustomFieldJson]    Script Date: 10/29/2014 15:03:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[smsp_GetCustomFieldJson] @serviceId INT,
@JsonResult VARCHAR(MAX) OUTPUT
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: Sept 23, 2014      
-- Description: Retrieves CCR Reson for Referral Data      
/*      
DECLARE @JsonResult VARCHAR(max)
EXECUTE [smsp_GetCustomFieldJson] 2004 ,@JsonResult OUTPUT
SELECT @JsonResult
 Author			Modified Date			Reason      
   
      
*/
-- =============================================      
BEGIN
	BEGIN TRY
		DECLARE @TableName VARCHAR(100)
		DECLARE @script nVARCHAR(500)
		DECLARE @ParmDefinition nvarchar(500) 
		
		SELECT @TableName = f.TableName
		FROM Screens sc 
		JOIN Forms f ON f.FormId = sc.CustomFieldFormId AND f.Active = 'Y'
		WHERE ScreenId = 29
			AND ISNULL(f.RecordDeleted, 'N') = 'N'
			AND ISNULL(sc.RecordDeleted, 'N') = 'N'

			
		SET @ParmDefinition = N'@sId bigint, @Json varchar(MAX) OUTPUT'; 
		
		SET @Script = 'SELECT @Json = dbo.smsf_FlattenedJSONObject((SELECT * from '+@TableName+' WHERE ServiceId = @sId AND ISNULL(RecordDeleted,''N'')=''N'' FOR XML path('''+@TableName+'''),root))'
		EXECUTE sp_executesql @script,@ParmDefinition, @sId = @serviceId, @Json=@JsonResult OUTPUT;
		
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'smsp_GetCustomFieldJson') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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



