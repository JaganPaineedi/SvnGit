IF EXISTS (
		SELECT *
		FROM sysobjects
		WHERE type = 'P'
			AND NAME = 'ssp_SCGetClientNamefromClientIdForPeerRecordReview'
		)
BEGIN
	DROP PROCEDURE ssp_SCGetClientNamefromClientIdForPeerRecordReview
END
GO

CREATE PROCEDURE [dbo].[ssp_SCGetClientNamefromClientIdForPeerRecordReview]
	-- Add the parameters for the stored procedure here                  
	@ClientId INT
AS
/*********************************************************************/
/* Stored Procedure:ssp_SCGetClientNamefromClientIdForPeerRecordReview                */
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
/*  03/JUNE/2010   Karan Garg         Created                                    */
/*    06-July-2012   Jagdeep Hundal   Added check of   Active='Y'   as per task #1426 Record review: On click of notify clientid is not get selected in compose m -	Thresholds - Bugs/Features (Offshore)    */
/* 24/Mar/2014    Ponnin		  Moved from Threshold's 'Record Review' and changed to Core SP - For task #22 of Customization Bugs */
/*  20/Oct/2015		Revathi		 what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.           
									why:task #609, Network180 Customization */
/*********************************************************************/
BEGIN
	SELECT
		-- Modified by Revathi 20/Oct/2015
		CASE 
			WHEN ISNULL(ClientType, 'I') = 'I'
				THEN ISNULL(LastName, '') + ', ' + ISNULL(FirstName, '')
			ELSE ISNULL(OrganizationName, '')
			END AS ClientName
		,Active
	FROM Clients
	WHERE ClientId = @ClientId
		AND ISNULL(RecordDeleted, 'N') = 'N'
		AND Active = 'Y'

	IF (@@error != 0)
	BEGIN
		RAISERROR 20002 'ssp_SCGetClientNamefromClientIdForPeerRecordReview'
	END
END