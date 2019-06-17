/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientNamefromClientIdForServiceDetail]    Script Date: 04/26/2012 19:41:40 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetClientNamefromClientIdForServiceDetail]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetClientNamefromClientIdForServiceDetail]
GO

CREATE PROCEDURE [dbo].[ssp_SCGetClientNamefromClientIdForServiceDetail]
	-- Add the parameters for the stored procedure here              
	@ClientId INT
AS
/*********************************************************************/
/* Stored Procedure:ssp_SCGetClientNamefromClientIdForServiceDetail                */
/* Copyright: 2008 Streamline Healthcare Solutions,  LLC             */
/* Creation Date:   5/25/2010                                       */
/*                                                                   */
/* Purpose:  Get Name of Client */
/*                                                                   */
/* Input Parameters:              */
/*                                                                   */
/* Output Parameters:   None                   */
/*                                                                   */
/* Return:  0=success, otherwise an error number                     */
/*                                                                   */
/* Called By:                                                        */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:                                                          */
/*   Date   Author  Purpose                                    */
/*  20/Oct/2015	Revathi	  what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.           
							why:task #609, Network180 Customization  */
/*********************************************************************/
BEGIN
	DECLARE @ClientPhones VARCHAR(100)

	SELECT @ClientPhones = COALESCE(@ClientPhones + ', ', '') + CP.PhoneNumber
	FROM ClientPhones CP
	WHERE Phonetype IN (
			30
			,31
			)
		AND ISNULL(CP.RecordDeleted, 'N') = 'N'
		AND CP.ClientId = @ClientId

	SELECT
		-- Modified by Revathi 20/Oct/2015
		CASE 
			WHEN ISNULL(ClientType, 'I') = 'I'
				THEN ISNULL(LastName, '') + ', ' + ISNULL(FirstName, '')
			ELSE ISNULL(OrganizationName, '')
			END AS ClientName
		,Active
		,@ClientPhones AS ClientPhones
	FROM Clients
	WHERE ClientId = @ClientId
		AND ISNULL(RecordDeleted, 'N') = 'N'

	IF (@@error != 0)
	BEGIN
		RAISERROR 20002 'ssp_SCGetClientNamefromClientIdForServiceDetail'
	END
END
GO

