
/****** Object:  StoredProcedure [dbo].[ssp_GetRWQMRuleByName]    Script Date: 05/07/2017 16:14:52 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[ssp_GetRWQMRuleByName]')
			AND TYPE IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetRWQMRuleByName] 
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetRWQMRuleByName]    Script Date: 05/07/2017 16:14:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetRWQMRuleByName] (@RWQMRuleName Varchar(250))
AS
-- =============================================
-- Author:		Ajay 
-- Create date: 05/07/2017
-- Description:	To get all previous Actions.AHN-Customization: #44.
--Modified By   Date          Reason 	
-- =============================================
BEGIN TRY
---------RWQMActions	           
Select RWQMRuleId
,RWQMRuleName
From RWQMRules
Where RWQMRuleName like ''+@RWQMRuleName+''
AND ISNULL(RecordDeleted,'N')='N'


END TRY		
BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetRWQMRuleByName') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.                                    
			16
			,-- Severity.                                    
			1 -- State.                                    
			);
END CATCH
GO

