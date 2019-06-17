/****** Object:  StoredProcedure [dbo].[csp_IndividualPrograms]   Script Date: 03/26/2014******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_IndividualPrograms]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_IndividualPrograms] 
GO

/****** Object:  StoredProcedure [dbo].[csp_IndividualPrograms]    Script Date: 03/26/2014******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_IndividualPrograms] (@ClientId BIGINT)
AS
BEGIN TRY
	/********************************************************************************                                                     
--    
-- Copyright: Streamline Healthcare Solutions    
-- "Psychiatric Service"  
-- Purpose: Script for Task #823 - Woods Customizations  
--    
-- Author:  Dhanil Manuel  
-- Date:    12-31-2014  
-- *****History****    
  
*********************************************************************************/
	SELECT DISTINCT P.ProgramId
		,CP.ClientId
		,CP.STATUS
		,P.ProgramName
	FROM ClientPrograms CP
	INNER JOIN Programs P ON P.ProgramId = CP.ProgramId
	WHERE ISNULL(P.RecordDeleted, 'N') = 'N'
		AND CP.STATUS IN (
			1
			,4
			)
		AND CP.ClientId = @ClientId
		order by P.ProgramName 
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_IndividualPrograms') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.                      
			16
			,-- Severity.                      
			1 -- State.                      
			);
END CATCH