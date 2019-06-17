/****** Object:  StoredProcedure [dbo].[ssp_GetSummaryOfCareCCDXML]    Script Date: 10/11/2017 12:38:45 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetSummaryOfCareCCDXML]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetSummaryOfCareCCDXML]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetSummaryOfCareCCDXML]    Script Date: 10/11/2017 12:38:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetSummaryOfCareCCDXML] @ClientId INT = NULL
	,@Type VARCHAR(10) = NULL
	,@DocumentVersionId INT = NULL
	,@FromDate DATETIME = NULL
	,@ToDate DATETIME = NULL
	,@OutputComponentXML VARCHAR(MAX) OUTPUT
	-- =============================================                              
	-- Author:  Vijay                              
	-- Create date: 9/8/2017              
	-- Description: Retrieves CCD XML for Summary Of Care    
	-- Task:   MUS3 - Task#25.4 Transition of Care - CCDA Generation               
	/*                              
 Author   Modified Date   Reason                              
 Shankha                Initial                        
                              
*/
AS
BEGIN
	DECLARE @DocFromDate DATETIME
	DECLARE @DocToDate DATETIME
	DECLARE @TransitionType VARCHAR(25)

	IF @DocumentVersionId IS NULL
		AND @ClientId IS NOT NULL
	BEGIN
		SELECT Top 1 @DocumentVersionId = DocumentVersionId
		FROM TransitionOfCareDocuments t
		Join Documents d on d.CurrentDocumentVersionId = t.DocumentVersionId
		WHERE t.TransitionType	= @Type
			AND (
				CAST(t.FromDate AS Date)   = @FromDate
				AND CAST(t.ToDate As Date) = @ToDate
				)
			AND d.ClientID = @ClientId
			AND d.STATUS = 22
			AND ISNULL(D.RecordDeleted, 'N') = 'N'
			AND ISNULL(T.RecordDeleted, 'N') = 'N'
		Order by D.EffectiveDate Desc						
	END

	IF @DocumentVersionId IS NOT NULL --AND @ClientId IS NULL                 
	BEGIN
		SELECT TOP 1 @ClientId = D.ClientId
			,@DocFromDate = cast(T.FromDate AS DATETIME)
			,@DocToDate = cast(T.ToDate AS DATETIME)
			,@TransitionType = (
				CASE 
					WHEN T.TransitionType = 'I'
						THEN 'Inpateint'
					WHEN T.TransitionType = 'O'
						THEN 'Outpatient'
					WHEN T.TransitionType = 'P'
						THEN 'Primary Care'
					ELSE ''
					END
				)
		FROM TransitionOfCareDocuments T
		JOIN documentVersions dv ON T.DocumentVersionId = dv.DocumentVersionId
		JOIN Documents d ON d.DocumentId = dv.DocumentId
		WHERE ISNULL(T.RecordDeleted, 'N') = 'N'
			AND T.DocumentVersionId = @DocumentVersionId
			AND ISNULL(Dv.RecordDeleted, 'N') = 'N'
			AND ISNULL(D.RecordDeleted, 'N') = 'N'

		IF @FromDate IS NULL
			OR @FromDate = '01/01/1753'
		BEGIN
			SET @FromDate = @DocFromDate
		END

		IF @ToDate IS NULL
			OR @ToDate = '12/31/9999'
		BEGIN
			SET @ToDate = @DocToDate
		END

		IF @Type IS NULL
			OR @Type = ''
		BEGIN
			SET @Type = @TransitionType
		END
	END

	DECLARE @ccdXML VARCHAR(MAX) = 
		'<?xml version="1.0" encoding="UTF-8"?>              
<?xml-stylesheet type="text/xsl" href="CDA.xsl"?>              
<ClinicalDocument xmlns="urn:hl7-org:v3" xmlns:cda="urn:hl7-org:v3" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:hl7-org:v3 C:\XML\C32_CDA_Schema\infrastructure\cda\C32_CDA.xsd">              
   <!--              
********************************************************              
  CDA Header              
********************************************************              
 -->              
   <!-- CONF 16791 -->              
   <realmCode code="US" />              
   <!-- CONF 5361 -->              
   <typeId root="2.16.840.1.113883.1.3" extension="POCD_HD000040" />              
   <!-- US General Header Template -->              
   <!-- CONF 5252 -->              
   <templateId root="2.16.840.1.113883.10.20.22.1.1" />              
   <!-- *** Note:  The next templateId, code and title will differ depending on what type of document is being sent. *** -->              
   <!-- conforms to the document specific requirements  -->              
   <templateId root="2.16.840.1.113883.10.20.22.1.2" />              
   <!-- CONF 5363 -->              
   <id extension="Test CCDA" root="1.1.1.1.1.1.1.1.1" />              
   <!-- CONF 5253 "CCD document" -->              
   <code codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" code="34133-9" displayName="Summarization of Episode Note" />              
  ###RECORDTARGET###                  
  ###AUTHOR###                 
  ###DATAENTERER###                  
  ###INFORMANT###                      
  ###CUSTODIAN###                  
  ###INFORMATIONRECIPIENT###                  
  ###LEGALAUTHENTICATOR###                 
  ###AUTHENTICATOR###                  
  ###PARTICIPANT###                  
  ###DOCUMENTATIONOF###            
  ###COMPONENTOF###              
  <component>              
   <structuredBody>
    ###PRIVACYANDSECURITY###                  
    ###ALLERGIES###              
    ###ENCOUNTERS###              
    ###IMMUNIZATIONS###              
    ###MEDICATIONS###             
    ###ASSESSMENT###             
    ###CAREPLAN###              
    ###REFERRAL###             
    ###PROBLEMLIST###              
    ###PROCEDURES###              
    ###FUNCTIONALANDCOGNITIVESTATUS###            
    ###RESULTS###             
    ###SOCIALHISTORY###              
    ###VITALSIGNS###              
   </structuredBody>                    
  </component>                  
</ClinicalDocument>'
	DECLARE @ccdComponentXML VARCHAR(MAX)

	EXEC ssp_GetRecordTargetXMLString @ClientId
		,@Type
		,@DocumentVersionId
		,@FromDate
		,@ToDate
		,@ccdComponentXML OUTPUT

	SET @ccdXML = REPLACE(@ccdXML, '###RECORDTARGET###', @ccdComponentXML)

	EXEC ssp_GetAuthorXMLString @ClientId
		,@Type
		,@DocumentVersionId
		,@FromDate
		,@ToDate
		,@ccdComponentXML OUTPUT

	SET @ccdXML = REPLACE(@ccdXML, '###AUTHOR###', @ccdComponentXML)

	EXEC ssp_GetDataEntererXMLString @ClientId
		,@Type
		,@DocumentVersionId
		,@FromDate
		,@ToDate
		,@ccdComponentXML OUTPUT

	SET @ccdXML = REPLACE(@ccdXML, '###DATAENTERER###', @ccdComponentXML)

	EXEC ssp_GetInformantXMLString @ClientId
		,@Type
		,@DocumentVersionId
		,@FromDate
		,@ToDate
		,@ccdComponentXML OUTPUT

	SET @ccdXML = REPLACE(@ccdXML, '###INFORMANT###', @ccdComponentXML)

	EXEC ssp_GetCustodianXMLString @ClientId
		,@Type
		,@DocumentVersionId
		,@FromDate
		,@ToDate
		,@ccdComponentXML OUTPUT

	SET @ccdXML = REPLACE(@ccdXML, '###CUSTODIAN###', @ccdComponentXML)

	EXEC ssp_GetInformationRecipientXMLString @ClientId
		,@Type
		,@DocumentVersionId
		,@FromDate
		,@ToDate
		,@ccdComponentXML OUTPUT

	SET @ccdXML = REPLACE(@ccdXML, '###INFORMATIONRECIPIENT###', @ccdComponentXML)

	EXEC ssp_GetLegalAuthenticatorXMLString @ClientId
		,@Type
		,@DocumentVersionId
		,@FromDate
		,@ToDate
		,@ccdComponentXML OUTPUT

	SET @ccdXML = REPLACE(@ccdXML, '###LEGALAUTHENTICATOR###', @ccdComponentXML)

	EXEC ssp_GetAuthenticatorXMLString @ClientId
		,@Type
		,@DocumentVersionId
		,@FromDate
		,@ToDate
		,@ccdComponentXML OUTPUT

	SET @ccdXML = REPLACE(@ccdXML, '###AUTHENTICATOR###', @ccdComponentXML)

	EXEC ssp_GetParticipantXMLString @ClientId
		,@Type
		,@DocumentVersionId
		,@FromDate
		,@ToDate
		,@ccdComponentXML OUTPUT

	SET @ccdXML = REPLACE(@ccdXML, '###PARTICIPANT###', @ccdComponentXML)

	EXEC ssp_GetDocumentationOfXMLString @ClientId
		,@Type
		,@DocumentVersionId
		,@FromDate
		,@ToDate
		,@ccdComponentXML OUTPUT

	SET @ccdXML = REPLACE(@ccdXML, '###DOCUMENTATIONOF###', @ccdComponentXML)

	EXEC ssp_GetComponentOfXMLString @ClientId
		,@Type
		,@DocumentVersionId
		,@FromDate
		,@ToDate
		,@ccdComponentXML OUTPUT

	SET @ccdXML = REPLACE(@ccdXML, '###COMPONENTOF###', @ccdComponentXML)

	EXEC ssp_GetPrivacyAndSecurityMarkingsXMLString @ClientId
		,@Type
		,@DocumentVersionId
		,@FromDate
		,@ToDate
		,@ccdComponentXML OUTPUT

	SET @ccdXML = REPLACE(@ccdXML, '###PRIVACYANDSECURITY###', @ccdComponentXML)

	EXEC ssp_GetAllergiesXMLString @ClientId
		,@Type
		,@DocumentVersionId
		,@FromDate
		,@ToDate
		,@ccdComponentXML OUTPUT

	SET @ccdXML = REPLACE(@ccdXML, '###ALLERGIES###', @ccdComponentXML)

	EXEC ssp_GetEncountersXMLString @ClientId
		,@Type
		,@DocumentVersionId
		,@FromDate
		,@ToDate
		,@ccdComponentXML OUTPUT

	SET @ccdXML = REPLACE(@ccdXML, '###ENCOUNTERS###', @ccdComponentXML)

	EXEC ssp_GetImmunizationsXMLString @ClientId
		,@Type
		,@DocumentVersionId
		,@FromDate
		,@ToDate
		,@ccdComponentXML OUTPUT

	SET @ccdXML = REPLACE(@ccdXML, '###IMMUNIZATIONS###', @ccdComponentXML)

	EXEC ssp_GetCurrentMedicationsXMLString @ClientId
		,@Type
		,@DocumentVersionId
		,@FromDate
		,@ToDate
		,@ccdComponentXML OUTPUT

	SET @ccdXML = REPLACE(@ccdXML, '###MEDICATIONS###', @ccdComponentXML)

	EXEC ssp_GetAssessmentXMLString @ClientId
		,@Type
		,@DocumentVersionId
		,@FromDate
		,@ToDate
		,@ccdComponentXML OUTPUT

	SET @ccdXML = REPLACE(@ccdXML, '###ASSESSMENT###', @ccdComponentXML)

	EXEC ssp_GetPlanOfTreatmentXMLString @ClientId
		,@Type
		,@DocumentVersionId
		,@FromDate
		,@ToDate
		,@ccdComponentXML OUTPUT

	SET @ccdXML = REPLACE(@ccdXML, '###CAREPLAN###', @ccdComponentXML)

	EXEC ssp_GetReferralXMLString @ClientId
		,@Type
		,@DocumentVersionId
		,@FromDate
		,@ToDate
		,@ccdComponentXML OUTPUT

	SET @ccdXML = REPLACE(@ccdXML, '###REFERRAL###', @ccdComponentXML)

	EXEC ssp_GetActiveProblemsXMLString @ClientId
		,@Type
		,@DocumentVersionId
		,@FromDate
		,@ToDate
		,@ccdComponentXML OUTPUT

	SET @ccdXML = REPLACE(@ccdXML, '###PROBLEMLIST###', @ccdComponentXML)

	EXEC ssp_GetHistoryOfProceduresXMLString @ClientId
		,@Type
		,@DocumentVersionId
		,@FromDate
		,@ToDate
		,@ccdComponentXML OUTPUT

	SET @ccdXML = REPLACE(@ccdXML, '###PROCEDURES###', @ccdComponentXML)

	EXEC ssp_GetFunctionalCognitiveXMLString @ClientId
		,@Type
		,@DocumentVersionId
		,@FromDate
		,@ToDate
		,@ccdComponentXML OUTPUT

	SET @ccdXML = REPLACE(@ccdXML, '###FUNCTIONALANDCOGNITIVESTATUS###', @ccdComponentXML)

	EXEC ssp_GetLaboratoryTestsXMLString @ClientId
		,@Type
		,@DocumentVersionId
		,@FromDate
		,@ToDate
		,@ccdComponentXML OUTPUT

	SET @ccdXML = REPLACE(@ccdXML, '###RESULTS###', @ccdComponentXML)

	EXEC ssp_GetSocialHistoryXMLString @ClientId
		,@Type
		,@DocumentVersionId
		,@FromDate
		,@ToDate
		,@ccdComponentXML OUTPUT

	SET @ccdXML = REPLACE(@ccdXML, '###SOCIALHISTORY###', @ccdComponentXML)

	EXEC ssp_GetVitalSignsXMLString @ClientId
		,@Type
		,@DocumentVersionId
		,@FromDate
		,@ToDate
		,@ccdComponentXML OUTPUT

	SET @ccdXML = REPLACE(@ccdXML, '###VITALSIGNS###', @ccdComponentXML)
	SET @OutputComponentXML = @ccdXML
END
GO


