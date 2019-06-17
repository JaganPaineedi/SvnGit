/****** Object:  StoredProcedure [dbo].[csp_GetActiveStaff]   Script Date: 03/26/2014******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetActiveStaff]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_GetActiveStaff] 
GO

/****** Object:  StoredProcedure [dbo].[csp_GetActiveStaff]    Script Date: 03/26/2014******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_GetActiveStaff]
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
	SELECT S.StaffId,S.LastName + ', ' + S.FirstName AS DisplayAs
	FROM Staff S	
	WHERE ISNULL(S.RecordDeleted, 'N') = 'N'
		AND S.Active='Y'
		ORDER BY DisplayAs
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_GetActiveStaff') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.                      
			16
			,-- Severity.                      
			1 -- State.                      
			);
END CATCH