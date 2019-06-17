 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetAllProviders]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetAllProviders]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/******************************************************************************
**  File: csp_GetAllProviders.sql
**  Name: csp_GetAllProviders
**  Desc: ALL Provider Staff list 
**
**  Return values: <Return Values>
**
**  Called by: <Code file that calls>
**
**  Parameters:
**  Input   Output
**  ServiceId      -----------
**
**  Created By: Ravichandra 
**  Date:  DEC 21 2015
*******************************************************************************
**  Change History
*******************************************************************************
**   Date:			Author:    Description:  
**  --------		--------    -------------------------------------------  
	Dec 21-12-2015	Ravichandra	what: National Health Service Corps Report  Created RDL
								why: task #32  New Directions - Customizations


*******************************************************************************/
CREATE PROCEDURE [dbo].[csp_GetAllProviders] 
        
AS    
BEGIN
BEGIN TRY
		SELECT DISTINCT sf.StaffId
			,sf.LastName + ', ' + sf.FirstName AS Providers
		FROM Staff AS sf
		WHERE 
			 ISNULL(sf.RecordDeleted,'N') = 'N'  
			 AND ISNULL(sf.Active,'N') = 'Y'  
		UNION 
	SELECT 0,'All Providers'   
  
 END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_GetAllProviders') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	END CATCH

	RETURN
END

GO

     
    
    
    