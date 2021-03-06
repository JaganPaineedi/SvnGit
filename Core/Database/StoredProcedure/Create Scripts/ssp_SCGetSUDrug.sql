/****** Object:  StoredProcedure [dbo].[ssp_SCGetSUDrug]    Script Date: 11/18/2011 16:25:53 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetSUDrug]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetSUDrug]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetSUDrug]
AS
BEGIN
	/*********************************************************************/
	/* Stored Procedure: dbo.ssp_SCGetSUDrug                */	
	/* Creation Date: 27 March 2019                                       */
	/*                                                                   */
	/* Purpose: Gets Drug Details          */
	/*                                                                   */
	/* Input Parameters:      */
	/*                                                                   */
	/* Output Parameters:                                    */
	/*                                                                   */
	/* Return:   */
	/*                                                                   */
	/* Called By:         */
	/*                                                                   */
	/* Calls:                                                            */
	/*                                                                   */
	/* Data Modifications:                                               */
	/*                                                                   */
	/*   Updates:                                                          */

	/*   27 March 2019         Jyothi Bellapu            Purpose: Get Data from SUDrugs as part of OASAS-Customization -#62000  */
	
	/*********************************************************************/
	SELECT SUDrugId
		,DrugName
		,DrugDescription
		,Active
		,CommonStreetNames
		,SortOrder
	FROM SUDrugs
	WHERE (
			RecordDeleted = 'N'
			OR RecordDeleted IS NULL
			)
	ORDER BY SortOrder ASC

	--Checking For Errors                
	IF (@@error != 0)
	BEGIN
		RAISERROR (
				'ssp_SCGetSUDrug: An Error Occured'
				,16
				,1
				)

		RETURN
	END
END
GO


