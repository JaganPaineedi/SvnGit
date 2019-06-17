IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[scsp_CreateImageRecordsMapping]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[scsp_CreateImageRecordsMapping]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[scsp_CreateImageRecordsMapping] --- 5,46,9354   -- 5,53,9354  
	(
	@ScreenKeyId BIGINT
	,@ImageRecordId BIGINT
	,@AssociateWith BIGINT
	)
	/********************************************************************************/
	/* Stored Procedure: SCSP_CreateImageRecordsMapping         */
	/* Copyright: Streamline Healthcare Solutions         */
	/* Creation Date:  12.10.2015             */
	/* Purpose: used by Custom Logic for Mapping Image Records Upload Process       */
	/* Input Parameters:               */
	/*                    */
	/* Output ParametersScreenKeyId,ImageRecordId ,AssociateWith       */
	/*                    */
	/* Return:                     */
	/*                    */
	/* Called By: FosterCare.cs                */
	/*                    */
	/* Calls:                  */
	/*                    */
	/* Data Modifications:               */
	/*                    */
	/*   Updates:                 */
	/*       Date              Author                  Purpose                      */
	/*  12-10-2015            R.M.Manikandan           Created                      */
	/********************************************************************************/
AS
BEGIN
	DECLARE @Error VARCHAR(8000)

	SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'scsp_CreateImageRecordsMapping') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())
		--RAISERROR  
		--(  
		-- @Error, -- Message text.  
		-- 16,  -- Severity.  
		-- 1  -- State.  
		--);   
END