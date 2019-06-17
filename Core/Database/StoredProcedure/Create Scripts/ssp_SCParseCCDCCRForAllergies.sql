/****** Object:  StoredProcedure [dbo].[ssp_SCParseCCDCCRForAllergies]    Script Date: 05/19/2016 14:54:25 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCParseCCDCCRForAllergies]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCParseCCDCCRForAllergies]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCParseCCDCCRForAllergies]    Script Date: 05/19/2016 14:54:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCParseCCDCCRForAllergies] @XMLData AS XML
	,@FileName AS VARCHAR(250)
AS /*********************************************************************/
/* Stored Procedure: dbo.ssp_SCParseCCDCCRForAllergies            */
/* Creation Date:    27/Jan/2015                  */
/* Purpose:  To Get Allergy from XML data                */
/*    Exec ssp_SCParseCCDCCRForAllergies                                              */
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

		SELECT @legalAuthenticator = isnull(ltrim(rtrim(@FinalXMLData.value('(ClinicalDocument/legalAuthenticator/assignedEntity/representedOrganization/telecom/@value)[1]', 'varchar(MAX)'))), 'Get Well Clinic')

		SELECT @crlf = CHAR(13) + CHAR(10)

		SELECT @XMLTempdata = replace(cast(@XMLData AS VARCHAR(max)), 'xmlns="urn:hl7-org:v3"', '')

		SELECT @FinalXMLData = cast(@XMLTempdata AS XML)

		CREATE TABLE #AllergyData (
			RXNormCode VARCHAR(max)
			,AllergyDesc VARCHAR(max)
			,Reaction VARCHAR(max)
			,LastModificationDate VARCHAR(max)
			,LastModificationDateFormatted DATETIME
			,AdditionalInfomrmation VARCHAR(max)
			,SourceInformation VARCHAR(max)
			)

		INSERT INTO #AllergyData (
			RXNormCode
			,AllergyDesc
			,Reaction
			,LastModificationDate
			,SourceInformation
			)
		SELECT isnull(ltrim(rtrim(m.c.value('data((./@code)[1])', 'varchar(MAX)'))), '')
			,isnull(ltrim(rtrim(m.c.value('data((./@displayName)[1])', 'varchar(MAX)'))), '')
			,isnull(ltrim(rtrim(m.c.value('data((../../../../entryRelationship/observation/value/originalText)[1])', 'varchar(MAX)'))), '')
			,isnull(ltrim(rtrim(m.c.value('data((../../../../entryRelationship/observation/effectiveTime/low/@value)[1])', 'varchar(MAX)'))), '')
			,isnull(@legalAuthenticator + ' (' + @FileName + ')', '')
		FROM @FinalXMLData.nodes('ClinicalDocument/component/structuredBody/component/section/entry/act/entryRelationship/observation/participant/participantRole/playingEntity/code') AS m(c)
		WHERE m.c.exist('../../../../../../../../templateId[@root ="2.16.840.1.113883.10.20.22.2.6.1"]') = 1

		UPDATE AD
		SET AD.LastModificationDateFormatted = cast(CONVERT(VARCHAR(20), CONVERT(DATE, CONVERT(VARCHAR(8), LastModificationDate), 112), 110) AS DATETIME)
		FROM #AllergyData AD

		--select * from #AllergyData
		SELECT Ad.RXNormCode
			,Ad.AllergyDesc
			,CASE 
				WHEN Ad.RXNormCode = '7982'
					THEN 4038
				WHEN Ad.RXNormCode = '2670'
					THEN 493
				WHEN Ad.RXNormCode = '1191'
					THEN 1162
				WHEN Ad.RXNormCode = '10185'
					THEN 148
				WHEN Ad.RXNormCode = '7984'
					THEN 2290
				WHEN Ad.RXNormCode = '2002'
					THEN 525
				WHEN Ad.RXNormCode = '9524'
					THEN 1056
				ELSE ''
				END AS 'AllergenConceptId'
			,CASE Ad.RXNormCode
				WHEN '2002'
					THEN isNull('Source: ' + SourceInformation + @crlf + 'Reaction:' + Reaction + @crlf + 'Status:Inactive' + @crlf + 'Last Modification Date:' + convert(VARCHAR(20), LastModificationDateFormatted, 110), '')
				ELSE isNull('Source: ' + SourceInformation + @crlf + 'Reaction:' + Reaction + @crlf + 'Status:Active' + @crlf + 'Last Modification Date:' + convert(VARCHAR(20), LastModificationDateFormatted, 110), '')
				END AS AdditionalInformation
		FROM #AllergyData Ad
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(max)

		SET @Error = convert(VARCHAR, error_number()) + '*****' + convert(VARCHAR(4000), error_message()) + '*****' + isnull(convert(VARCHAR, error_procedure()), 'ssp_SCParseCCDCCRForAllergies') + '*****' + convert(VARCHAR, error_line()) + '*****' + convert(VARCHAR, error_severity()) + '*****' + convert(VARCHAR, error_state())

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


