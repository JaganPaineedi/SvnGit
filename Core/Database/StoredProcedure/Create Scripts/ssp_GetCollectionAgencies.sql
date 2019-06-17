IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetCollectionAgencies]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetCollectionAgencies]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/******************************************************************************  
**  File: ssp_GetCollectionAgencies.sql  
**  Desc: Provides a list of CollectionAgencies 
**  
**  Return values: CollectionAgencyId, Name 
**  
**  Called by: ExternalCollectionsPopup.ascx.cs  
**  
**  Created By: Vithobha  
**  Date:  Feb 01 2017  
*******************************************************************************  
**  Change History  
*******************************************************************************  
**  Date:  Author:    Description:  
**  --------  --------    -------------------------------------------  
  
*******************************************************************************/
CREATE PROCEDURE [dbo].[ssp_GetCollectionAgencies]
AS
BEGIN
	BEGIN TRY
		SELECT DISTINCT CollectionAgencyId
			,NAME
		FROM CollectionAgencies
		WHERE ISNULL(RecordDeleted, 'N') = 'N'
		ORDER BY NAME
	END TRY


	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetCollectionAgencies') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


