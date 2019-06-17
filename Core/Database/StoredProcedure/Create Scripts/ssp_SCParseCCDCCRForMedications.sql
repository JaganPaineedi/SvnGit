/****** Object:  StoredProcedure [dbo].[ssp_SCParseCCDCCRForMedications]    Script Date: 05/19/2016 14:55:17 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCParseCCDCCRForMedications]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCParseCCDCCRForMedications]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCParseCCDCCRForMedications
]    Script Date: 05/19/2016 14:55:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCParseCCDCCRForMedications] @XMLData AS XML
	,@FileName AS VARCHAR(250)
AS /*********************************************************************/
/* Stored Procedure: dbo.ssp_SCParseCCDCCRForMedications            */
/* Creation Date:    27/Jan/2015                  */
/* Purpose:  To Get Diagnosis from XML data                */
/*    Exec ssp_SCParseCCDCCRForMedications                                              */
/* Input Parameters:                           */
/* Date   Author   Purpose              */
/* 29/Jan/2015  Gautam   Created           Certification 2014   */
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

		CREATE TABLE #MedicationData (
			RXNormCode VARCHAR(max)
			,MedicationName VARCHAR(max)
			,MedicationNameId VARCHAR(max)
			,Quantity VARCHAR(max)
			,Unit VARCHAR(500)
			,UnitId INT
			,StrengthDescription VARCHAR(max)
			,StrengthId INT
			,[Route] VARCHAR(max)
			,RouteId INT
			,Schedule VARCHAR(500)
			,ScheduleId INT
			,MedicationStartDateOld VARCHAR(max)
			,MedicationEndDateOld VARCHAR(max)
			,MedicationStartDate DATETIME
			,MedicationEndDate DATETIME
			,LastModificationDate VARCHAR(max)
			,LastModificationDateFormatted DATETIME
			,SourceInformation VARCHAR(max)
			)

		INSERT INTO #MedicationData (
			RXNormCode
			,MedicationName
			,Quantity
			,unit
			,Schedule
			,MedicationStartDateOld
			,MedicationEndDateOld
			,LastModificationDate
			,SourceInformation
			)
		SELECT isnull(ltrim(rtrim(m.c.value('data((./@code)[1])', 'varchar(MAX)'))), '')
			,isnull(ltrim(rtrim(m.c.value('data((./@displayName)[1])', 'varchar(MAX)'))), '')
			,isnull(ltrim(rtrim(m.c.value('data((../../../../doseQuantity/@value)[1])', 'varchar(MAX)'))), '')
			,isnull(ltrim(rtrim(m.c.value('data((../../../../doseQuantity/@unit)[1])', 'varchar(MAX)'))), '')
			,isnull(ltrim(rtrim(m.c.value('data((./originalText)[1])', 'varchar(MAX)'))), '')
			,isnull(ltrim(rtrim(m.c.value('data((../../../../effectiveTime/low/@value)[1])', 'varchar(MAX)'))), '')
			,isnull(ltrim(rtrim(m.c.value('data((../../../../effectiveTime/high/@value)[1])', 'varchar(MAX)'))), '')
			,isnull(ltrim(rtrim(m.c.value('data((../../../../effectiveTime/low/@value)[1])', 'varchar(MAX)'))), '') -- change this	
			,isnull(@legalAuthenticator + ' (' + @FileName + ')', '')
		FROM @FinalXMLData.nodes('ClinicalDocument/component/structuredBody/component/section/entry/substanceAdministration/consumable/manufacturedProduct/manufacturedMaterial/code') AS m(c)
		WHERE m.c.exist('../../../../../../templateId[@root ="2.16.840.1.113883.10.20.22.2.1.1"]') = 1

		UPDATE MD
		SET MD.UnitId = GC.GlobalCodeId
		FROM #MedicationData MD
		INNER JOIN GlobalCodes GC ON MD.unit = GC.CodeName
			AND GC.Category = 'MEDICATIONUNIT'

		UPDATE MD
		SET MD.ScheduleId = GC.GlobalCodeId
		FROM #MedicationData MD
		INNER JOIN GlobalCodes GC ON MD.Schedule = GC.CodeName
			AND GC.Category = 'MEDICATIONSCHEDULE'

		UPDATE MD
		SET MD.MedicationNameId = MS.MedicationNameId
			,MD.StrengthID = MS.MedicationId
			,MD.RouteId = MS.RouteId
			,MD.StrengthDescription = MS.StrengthDescription
		FROM #MedicationData MD
		INNER JOIN MDMedicationNames MN ON MD.MedicationName = MN.MedicationName
		INNER JOIN MDMedications MS ON MS.MedicationNameId = MN.MedicationNameId
		INNER JOIN MDDrugs MR ON MR.ClinicalFormulationId = MS.ClinicalFormulationId
		INNER JOIN MDRxNormCodes MX ON MX.NationalDrugCode = MR.NationalDrugCode
		WHERE MD.RxNormCode = MX.RxNormCode

		UPDATE MD
		SET MD.Route = MR.RouteDescription
		FROM #MedicationData MD
		INNER JOIN MDRoutes MR ON MD.RouteId = MR.RouteId

		UPDATE MD
		SET MD.MedicationStartDate = CASE 
				WHEN (
						MD.MedicationStartDateOld IS NOT NULL
						AND MD.MedicationStartDateOld <> ''
						)
					THEN cast(convert(VARCHAR, convert(DATETIME, substring(MD.MedicationStartDateOld, 1, 8)), 111) + ' ' + substring(substring(MD.MedicationStartDateOld, 9, 6), 1, 2) + ':' + substring(substring(MD.MedicationStartDateOld, 9, 6), 3, 2) + ':' + substring(substring(MD.MedicationStartDateOld, 9, 6), 5, 2) AS DATETIME)
				ELSE NULL
				END
			,MD.MedicationEndDate = CASE 
				WHEN (
						MD.MedicationEndDateOld IS NOT NULL
						AND MD.MedicationEndDateOld <> ''
						)
					THEN cast(convert(VARCHAR, convert(DATETIME, substring(MD.MedicationEndDateOld, 1, 8)), 111) + ' ' + substring(substring(MD.MedicationEndDateOld, 9, 6), 1, 2) + ':' + substring(substring(MD.MedicationEndDateOld, 9, 6), 3, 2) + ':' + substring(substring(MD.MedicationEndDateOld, 9, 6), 5, 2) AS DATETIME)
				ELSE NULL
				END
		FROM #MedicationData MD

		UPDATE MD
		SET MD.LastModificationDateFormatted = cast(CONVERT(VARCHAR(20), CONVERT(DATE, CONVERT(VARCHAR(8), MD.LastModificationDate), 112), 110) AS DATETIME)
		FROM #MedicationData MD

		UPDATE MD
		SET MD.MedicationNameId = 19461
			,StrengthId = 49125
			,StrengthDescription = '100unit/mL, soln, subQ'
			,[Route] = 'Subcutaneous'
			,[RouteId] = 28
		FROM #MedicationData MD
		WHERE MD.MedicationName = 'Insulin Glargine'

		SELECT row_number() OVER (
				ORDER BY MedicationNameId
				) AS RowNumber
			,RXNormCode
			,MedicationName
			,MedicationNameId
			,Quantity
			,Unit
			,UnitId
			,StrengthDescription
			,StrengthId
			,[Route]
			,RouteId
			,Schedule
			,ScheduleId
			,convert(VARCHAR(10), MedicationStartDate, 101) AS MedicationStartDate
			,convert(VARCHAR(10), MedicationEndDate, 101) AS MedicationEndDate
			,isNull('Source: ' + SourceInformation + @crlf + 'Status:Active' + @crlf + 'Last Modification Date:' + convert(VARCHAR(20), LastModificationDateFormatted, 110), '') AS AdditionalInformation
		FROM #MedicationData
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(max)

		SET @Error = convert(VARCHAR, error_number()) + '*****' + convert(VARCHAR(4000), error_message()) + '*****' + isnull(convert(VARCHAR, error_procedure()), 'ssp_SCParseCCDCCRForMedications') + '*****' + convert(VARCHAR, error_line()) + '*****' + convert(VARCHAR, error_severity()) + '*****' + convert(VARCHAR, error_state())

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


