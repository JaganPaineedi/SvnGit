IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCValidateNewInpatientCodingDocument]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCValidateNewInpatientCodingDocument]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCValidateNewInpatientCodingDocument] @StaffId INT
	,@ClientId INT
	,@DocumentCodeId INT
AS
/*********************************************************************/
/* Stored Procedure: [ssp_SCValidateNewInpatientCodingDocument]      */
/* Date              Author                  Purpose                 */
/* 4/17/2015         Hemant kumar            Client must have at least one inpatient admission for the users to be able to create this document (new document validation).why:Inpatient Coding Document #228*/
/*********************************************************************/
/**  Change History **/                                                                         
/********************************************************************************/                                                                           
/**  Date:    Author:     Description: **/                                                                         
/**  --------  --------    ------------------------------------------- */  

BEGIN
	DECLARE @ClientInpatientAdmissionCount INT = 0

	SELECT @ClientInpatientAdmissionCount = COUNT(ClientID)
	FROM clientinpatientvisits
	WHERE ClientId = @ClientId
		AND ISNULL(RecordDeleted, 'N') = 'N'
		AND ISNULL(RecordDeleted, 'N') = 'N'

	PRINT @ClientInpatientAdmissionCount

	IF @ClientInpatientAdmissionCount = 0
	BEGIN
		Select dbo.Ssf_GetMesageByMessageCode(1120,'InpatientAdmission','') AS ValidationMessage
			,'E' AS WarningOrError
	END
END
IF @@error <> 0
	GOTO error

RETURN

error:

RAISERROR 50000 'ssp_SCValidateNewInpatientCodingDocument failed.  Please contact your system administrator. We apologize for the inconvenience.'
GO


