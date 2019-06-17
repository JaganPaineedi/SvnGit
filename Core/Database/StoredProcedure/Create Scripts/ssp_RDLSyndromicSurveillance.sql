/****** Object:  StoredProcedure [dbo].[ssp_RDLSyndromicSurveillance]    Script Date: 05/31/2016 12:01:01 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSyndromicSurveillance]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLSyndromicSurveillance]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLSyndromicSurveillance]    Script Date: 05/31/2016 12:01:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RDLSyndromicSurveillance] (@DocumentVersionId INT)
AS
BEGIN
	/************************************************************************/
	/* Stored Procedure: csp_RDLSyndromicSurveillance     */
	/* Copyright: 2006 Streamline SmartCare         */
	/* Creation Date: 27-5-2016           */
	/*                  */
	/* Purpose: Gets Data for SyndromicSurveillance        */
	/*                  */
	/* Input Parameters: DocumentVersionId         */
	/* Output Parameters:             */
	/*********************************************************************/
	DECLARE @OrganizationName VARCHAR(250)

	SELECT TOP 1 @OrganizationName = OrganizationName
	FROM SystemConfigurations

	SELECT @OrganizationName AS OrganizationName
		,CurrentDocumentVersionId AS DocumentVersionId
		,DC.ClientId AS ClientId
		,(
			CASE 
				WHEN ISNULL(C.ClientType, 'I') = 'I'
					THEN ISNull(C.FirstName, '') + ' ' + ISNull(C.MiddleName, '') + ' ' + ISNull(C.LastName, '')
				ELSE ISNULL(C.OrganizationName, '')
				END
			) AS NAME
		,Convert(VARCHAR(10), C.DOB, 101) DOB
		,CONVERT(VARCHAR(10), DC.EffectiveDate, 101) AS EffectiveDate
		,doc.DocumentName AS DocumentName
		,CONVERT(VARCHAR(10), CE.RegistrationDate, 101) AS AdmitDate
		,gc.CodeName AS GeneralType
		,CONVERT(VARCHAR(10), DSS.AdmissionDateTime, 101) AS AdmissionDateTime
		,DSS.AdmissionDateTime AS AdmissionDateTimes
		,CONVERT(VARCHAR(10), DSS.DischargeDateTime, 101) AS DischargeDateTime
		,DSS.DischargeDateTime AS DischargeDateTimes
		,CONVERT(VARCHAR(10), DSS.DeathDateTime, 101) AS DeathDateTime
		,DSS.DeathDateTime AS DeathDateTimes
		,gcs.CodeName AS DischargeReason
		,DSS.ChiefComplaint AS ChiefComplaint
		,DSS.FacilityVisitType AS VisitType
	FROM documents dc
	JOIN Clients C ON C.ClientId = DC.ClientId
	JOIN DocumentCodes doc ON dc.DocumentCodeId = doc.DocumentCodeId
	JOIN ClientEpisodes CE ON dc.ClientId = CE.ClientId
	JOIN DocumentSyndromicSurveillances DSS ON dc.CurrentDocumentVersionId = DSS.DocumentVersionId
	JOIN GlobalCodes gc ON gc.globalcodeid = DSS.GeneralType
	JOIN GlobalCodes gcs ON gcs.globalcodeid = DSS.DischargeReason
	WHERE dc.InProgressDocumentVersionId = @DocumentVersionId
		AND ISNULL(dc.RecordDeleted, 'N') = 'N'

	IF (@@error != 0)
	BEGIN
		RAISERROR 20006 'csp_RDLSyndromicSurveillance : An Error Occured'

		RETURN
	END
END
GO

