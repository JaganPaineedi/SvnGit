/****** Object:  StoredProcedure [dbo].[ssp_SCGetAuthorisationCodes]    Script Date: 05/26/2016 10:42:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetAuthorisationCodes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetAuthorisationCodes]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetAuthorisationCodes]    Script Date: 05/26/2016 10:42:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetAuthorisationCodes]
AS
BEGIN
	/*********************************************************************/
	/* Stored Procedure: dbo.ssp_SCGetAuthorisationCodes                */
	/* Purpose: Gets all the records from Authorization Codes for Shared Tables */
	/*                                                                   */
	/*                                                                   */
	/*                                                                   */
	/* Called By:     ssp_SCGetSharedTablesForApplication from getSharedTabelsDataForSCApplication()    */
	/*                                                                   */
	/* Calls:                                                            */
	/*                                                                   */
	/* Data Modifications:                                               */
	/*                                                                   */
	/*   Updates:                                                          */
	/*       Date              Author                  Purpose                                    */
	/*       22-Oct-2010		-					For Shared Tables		 	    */
	/*		 13-Nov-2010		Maninder			To Add New Columns 	*/
	/*		 1-Nov-2012			Shifali				What - Added Columns Internal and External
												Why - We need to show External Auth Codes in Auth Detail Screen (Thresholds)
												Ref task# 2170 (Thresholds Bugs/Features)*/
	/*       25/05/2016         Akwinass			Moved from 3.5x and Included Category1,Category2,Category3 columns in AuthorizationCodes (Task #418.03 Thresholds - Support)*/
	/*********************************************************************/
	BEGIN TRY
		SELECT [AuthorizationCodeId]
			,[AuthorizationCodeName]
			,[DisplayAs]
			,[Active]
			,[Units]
			,[UnitType]
			,[ProcedureCodeGroupName]
			,[BillingCodeGroupName]
			,[ClinicianMustSpecifyBillingCode]
			,[UMMustSpecifyBillingCode]
			,[DefaultBillingCodeId]
			,[DefaultModifier1]
			,[DefaultModifier2]
			,[DefaultModifier3]
			,[DefaultModifier4]
			,[RowIdentifier]
			,[CreatedBy]
			,[CreatedDate]
			,[ModifiedBy]
			,[ModifiedDate]
			,[RecordDeleted]
			,[DeletedDate]
			,[DeletedBy]
			,Internal
			,[External]
			-- 25/05/2016   Akwinass
			,[Category1]
			,[Category2]
			,[Category3]
		FROM [AuthorizationCodes]
		WHERE ISNULL([AuthorizationCodes].RecordDeleted, 'N') <> 'Y'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetAuthorisationCodes') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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