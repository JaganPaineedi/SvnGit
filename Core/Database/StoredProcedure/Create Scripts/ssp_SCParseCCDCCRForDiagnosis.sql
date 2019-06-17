/****** Object:  StoredProcedure [dbo].[ssp_SCParseCCDCCRForDiagnosis]    Script Date: 05/19/2016 14:54:52 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCParseCCDCCRForDiagnosis]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCParseCCDCCRForDiagnosis]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCParseCCDCCRForDiagnosis]    Script Date: 05/19/2016 14:54:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCParseCCDCCRForDiagnosis] @XMLData AS XML
	,@FileName AS VARCHAR(250)
AS /*********************************************************************/
/* Stored Procedure: dbo.ssp_SCParseCCDCCRForDiagnosis            */
/* Creation Date:    27/Jan/2015                  */
/* Purpose:  To Get Diagnosis from XML data                */
/*    Exec ssp_SCParseCCDCCRForDiagnosis                                              */
/* Input Parameters:                           */
/* Date   Author   Purpose              */
/* 27/Jan/2015  Gautam   Created           Certification 2014   */
/*********************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @XMLTempdata VARCHAR(max)
		DECLARE @FinalXMLData XML
		DECLARE @crlf CHAR(2)
		DECLARE @legalAuthenticator VARCHAR(max)

		SELECT @crlf = CHAR(13) + CHAR(10)

		SELECT @XMLTempdata = replace(cast(@XMLData AS VARCHAR(max)), 'xmlns="urn:hl7-org:v3"', '')

		SELECT @FinalXMLData = cast(@XMLTempdata AS XML)

		SELECT @legalAuthenticator = isnull(ltrim(rtrim(@FinalXMLData.value('(ClinicalDocument/legalAuthenticator/assignedEntity/representedOrganization/name)[1]', 'varchar(MAX)'))), 'Unknown')

		CREATE TABLE #DiagnosisData (
			SNOMEDCode VARCHAR(max)
			,ICD10Code VARCHAR(max)
			,ICDDescription VARCHAR(max)
			,DSMVCodeId VARCHAR(max)
			,ICD9Code VARCHAR(max)
			,DiagnosisType VARCHAR(max)
			,DiagnosisTypeName VARCHAR(100)
			,SNOMEDDescription VARCHAR(max)
			,LastModificationDate VARCHAR(max)
			,LastModificationDateFormatted DATETIME
			,SourceInformation VARCHAR(max)
			)

		INSERT INTO #DiagnosisData (
			SNOMEDCode
			,ICD10Code
			,ICDDescription
			,LastModificationDate
			,SourceInformation
			)
		SELECT isnull(ltrim(rtrim(m.c.value('data((./@code)[1])', 'varchar(MAX)'))), '')
			,isnull(ltrim(rtrim(m.c.value('data((./translation/@code)[1])', 'varchar(MAX)'))), '')
			,isnull(ltrim(rtrim(m.c.value('data((./translation/@displayName)[1])', 'varchar(MAX)'))), '')
			,isnull(ltrim(rtrim(m.c.value('data((../effectiveTime/low/@value)[1])', 'varchar(MAX)'))), '')
			,isnull(@legalAuthenticator + ' (' + @FileName + ')', '')
		FROM @FinalXMLData.nodes('ClinicalDocument/component/structuredBody/component/section/entry/act/entryRelationship/observation/value') AS m(c)
		WHERE m.c.exist('../../../../../templateId[@root ="2.16.840.1.113883.10.20.22.2.5.1"]') = 1

		UPDATE DD
		SET DD.ICD9Code = DC1.ICD9Code
			,DD.DSMVCodeId = DC.ICD10CodeId
			,DD.DiagnosisType = 142
			,DD.DiagnosisTypeName = 'Additional'
			,DD.SNOMEDDescription = SC.SNOMEDCTDescription
		FROM #DiagnosisData DD
		INNER JOIN dbo.DiagnosisICD10Codes DC ON DC.ICD10Code = DD.ICD10Code
		INNER JOIN dbo.DiagnosisICD10ICD9Mapping DC1 ON DC1.ICD10CodeId = DC.ICD10CodeId
		INNER JOIN dbo.SNOMEDCTCodes SC ON SC.SNOMEDCTCode = DD.SNOMEDCode

		UPDATE DD
		SET DD.LastModificationDateFormatted = cast(CONVERT(VARCHAR(20), CONVERT(DATE, CONVERT(VARCHAR(8), DD.LastModificationDate), 112), 110) AS DATETIME)
		FROM #DiagnosisData DD

		SELECT SNOMEDCode
			,ICD10Code
			,ICDDescription
			,DSMVCodeId
			,ICD9Code
			,DiagnosisType
			,DiagnosisTypeName
			,SNOMEDDescription
			,CASE SNOMEDCode
				WHEN '49436004'
					THEN isNull('Source: ' + SourceInformation + @crlf + 'Status:Resolved' + @crlf + 'Last Modification Date:' + convert(VARCHAR(20), LastModificationDateFormatted, 110), '')
				ELSE isNull('Source: ' + SourceInformation + @crlf + 'Status:Active' + @crlf + 'Last Modification Date:' + convert(VARCHAR(20), LastModificationDateFormatted, 110), '')
				END AS AdditionalInformation
		FROM #DiagnosisData
			--drop table #DiagnosisData      
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(max)

		SET @Error = convert(VARCHAR, error_number()) + '*****' + convert(VARCHAR(4000), error_message()) + '*****' + isnull(convert(VARCHAR, error_procedure()), 'ssp_SCParseCCDCCRForDiagnosis') + '*****' + convert(VARCHAR, error_line()) + '*****' + convert(VARCHAR, error_severity()) + '*****' + convert(VARCHAR, error_state())

		RAISERROR (
				@Error
				,
				-- Message text.                                                                                           
				16
				,
				-- Severity.                                                                                           
				1
				-- State.                                                                                           
				);
	END CATCH
END
GO


