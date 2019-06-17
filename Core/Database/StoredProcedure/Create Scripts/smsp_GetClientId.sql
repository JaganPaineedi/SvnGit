/****** Object:  StoredProcedure [dbo].[smsp_GetClientId]    Script Date: 10/04/2017 18:24:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[smsp_GetClientId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[smsp_GetClientId]
GO


/****** Object:  StoredProcedure [dbo].[smsp_GetClientId]    Script Date: 10/04/2017 18:24:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[smsp_GetClientId]  @SSN VARCHAR(20) = null
, @FirstName VARCHAR(100) = null
, @LastName VARCHAR(100) = null
, @DOB DATETIME = null
, @JsonResult VARCHAR(MAX) OUTPUT
AS
-- =============================================      
-- Author:  Vijay      
-- Create date: Oct 04, 2017      
-- Description: Retrieves ClientId(s)
-- Task:   MUS3 - Task#30, 31 and 32
/*      
 Author			Modified Date			Reason     
*/
-- =============================================      
BEGIN
	BEGIN TRY
	
	SET NOCOUNT ON
	
		SELECT @JsonResult = dbo.smsf_FlattenedJSON((
			SELECT DISTINCT ClientId
			FROM Clients  
				WHERE (ISNULL(@SSN, '')='' OR SSN = @SSN)
				AND (ISNULL(@FirstName, '')='' OR FirstName = @FirstName)
				AND (ISNULL(@LastName, '')='' OR LastName = @LastName)
				AND (ISNULL(@DOB, '')='' OR DOB = @DOB)
				AND Active = 'Y'
				AND ISNULL(RecordDeleted,'N')='N'
			FOR XML path
			,ROOT
			))
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'smsp_GetClientId') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


