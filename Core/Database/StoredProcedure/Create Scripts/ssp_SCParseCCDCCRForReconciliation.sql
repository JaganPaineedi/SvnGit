/****** Object:  StoredProcedure [dbo].[ssp_SCParseCCDCCRForReconciliation]    Script Date: 05/19/2016 14:55:17 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCParseCCDCCRForReconciliation]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCParseCCDCCRForReconciliation]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCParseCCDCCRForReconciliation
]    Script Date: 05/19/2016 14:55:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROCEDURE [dbo].[ssp_SCParseCCDCCRForReconciliation] @ClientCCDId INT
AS /*********************************************************************/
/* Stored Procedure: dbo.ssp_SCParseCCDCCRForReconciliation   1         */
/* Creation Date:    21/Aug/2017                */
/* Purpose:  To Get Medications from XML data                */
/*    Exec ssp_SCParseCCDCCRForReconciliation                                              */
/* Input Parameters:                           */
/* Date   Author   Purpose              */
/* 21/Aug/2017  Gautam   Created      Meaningful Use - Stage 3 26.1 - Reconciliation   */
/*********************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @XMLTempdata VARCHAR(max)
		DECLARE @FinalXMLData XML
		DECLARE @crlf CHAR(2)
		DECLARE @legalAuthenticator VARCHAR(max)
			,@XMLData AS XML
			,@FileName AS VARCHAR(250)
		DECLARE @UserDefinedMedicationId INT
		DECLARE @RXNormCode VARCHAR(50)
			,@MedicationNameExternal VARCHAR(500)
		DECLARE @Strength VARCHAR(25)
			,@StrengthUnitOfMeasure VARCHAR(25)
			,@StrengthDescription VARCHAR(250)
			,@MedicationStatus INT
			,@RouteId INT
			,@UserDefinedDrugCode VARCHAR(50)
		DECLARE @MatchFound VARCHAR(1)

		SELECT @crlf = CHAR(13) + CHAR(10)

		SELECT @XMLData = XMLData
			,@FileName = [FileName]
		FROM ClientCCDs
		WHERE ClientCCDId = @ClientCCDId

		SELECT @XMLTempdata = replace(cast(@XMLData AS VARCHAR(max)), 'xmlns="urn:hl7-org:v3"', '')

		SELECT @FinalXMLData = cast(@XMLTempdata AS XML)

		SELECT @legalAuthenticator = isnull(ltrim(rtrim(@FinalXMLData.value('(ClinicalDocument/legalAuthenticator/assignedEntity/representedOrganization/name)[1]', 'varchar(MAX)'))), 'Unknown')

		CREATE TABLE #MedicationData (
			RXNormCode VARCHAR(max)
			,MedicationName VARCHAR(max)
			,MedicationNameExternal VARCHAR(max)
			,UserDefinedMedicationId INT
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
			,MatchFound VARCHAR(1) DEFAULT 'N'
			)

		INSERT INTO #MedicationData (
			RXNormCode
			,MedicationNameExternal
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
		WHERE m.c.exist('../../../../../../templateId[@root ="2.16.840.1.113883.10.20.22.2.1.1"]') = 1;

		UPDATE MD
		SET MD.MatchFound = 'Y'
		FROM #MedicationData MD
		JOIN MDExternalVocabularyDescriptions dsc ON dsc.MDExternalVocabularyIdentifier = MD.RXNormCode
			AND dsc.MDExternalVocabularyDescription = MD.MedicationNameExternal

		UPDATE MD
		SET MD.UserDefinedMedicationId = dsc.UserDefinedMedicationId
		FROM #MedicationData MD
		JOIN UserDefinedMedications dsc ON dsc.UserDefinedDrugCode = MD.RXNormCode
			AND dsc.MedicationDescription = MD.MedicationNameExternal;

		WITH CTE_MDM
		AS (
			SELECT MD.RXNormCode
				,mdm.MedicationNameId
				,MN.MedicationName
				,mdm.StrengthUnitOfMeasure AS 'Unit'
				,mdm.StrengthDescription
				,mdm.RouteId
				,MR.RouteDescription AS [Route]
				,MD.Schedule
				,mdm.MedicationId
				,row_number() OVER (
					PARTITION BY mdm.MedicationId ORDER BY mdm.MedicationId
					) AS Ranking
			FROM #MedicationData MD
			JOIN MDExternalVocabularyDescriptions dsc ON dsc.MDExternalVocabularyIdentifier = MD.RXNormCode
			JOIN MDExternalVocabularyMappings AS lnk ON dsc.MDExternalVocabularyIdentifier = lnk.MDExternalVocabularyIdentifier
				AND dsc.MDExternalVocabularyType = lnk.MDExternalVocabularyType
			JOIN MDMedications AS mdm ON lnk.FirstDatabankVocabularyIdentifier = cast(mdm.ExternalMedicationId AS VARCHAR(20))
			INNER JOIN MDMedicationNames MN ON MN.MedicationNameId = mdm.MedicationNameId
			LEFT JOIN MDRoutes MR ON mdm.RouteId = MR.RouteId
			--AND lnk.MDVocabularyLinkType = 3   dsc.MDExternalVocabularyIdentifier='209459'      
			WHERE ISNULL(dsc.RecordDeleted, 'N') = 'N'
				AND ISNULL(lnk.RecordDeleted, 'N') = 'N'
				AND ISNULL(mdm.RecordDeleted, 'N') = 'N'
				AND ISNULL(MD.RXNormCode, '') <> ''
			)
		UPDATE M
		SET M.MedicationName = C.MedicationName
			,M.MedicationNameId = C.MedicationNameId
			,M.Unit = C.Unit
			,M.UnitId = GC.GlobalCodeId
			,M.StrengthDescription = C.StrengthDescription
			,M.StrengthId = C.MedicationId
			,M.[Route] = C.[Route]
			,M.RouteId = C.RouteId
			,M.Schedule = C.Schedule
		FROM #MedicationData M
		JOIN CTE_MDM C ON M.RXNormCode = C.RXNormCode
		LEFT JOIN GlobalCodes GC ON C.unit = GC.CodeName
			AND GC.Category = 'MEDICATIONUNIT'
		WHERE C.Ranking = 1

		INSERT INTO Globalcodes (
			Category
			,CodeName
			,Active
			,CannotModifyNameOrDelete
			)
		SELECT 'MEDICATIONUNIT'
			,M.Unit
			,'Y'
			,'Y'
		FROM #MedicationData M
		WHERE M.UnitId IS NULL
			AND NOT EXISTS (
				SELECT 1
				FROM Globalcodes g
				WHERE g.CodeName = M.Unit
					AND g.Category = 'MEDICATIONUNIT'
				)

		UPDATE M
		SET M.UnitId = GC.GlobalCodeId
		FROM #MedicationData M
		JOIN GlobalCodes GC ON M.unit = GC.CodeName
			AND GC.Category = 'MEDICATIONUNIT'

		UPDATE MD
		SET MD.ScheduleId = GC.GlobalCodeId
		FROM #MedicationData MD
		INNER JOIN GlobalCodes GC ON MD.Schedule = GC.CodeName

		UPDATE MD
		SET MD.LastModificationDateFormatted = cast(CONVERT(VARCHAR(20), CONVERT(DATE, CONVERT(VARCHAR(8), MD.LastModificationDate), 112), 110) AS DATETIME)
		FROM #MedicationData MD

		UPDATE MD
		SET MD.MedicationStartDate = cast(CONVERT(VARCHAR(20), CONVERT(DATE, CONVERT(VARCHAR(8), MD.MedicationStartDateOld), 112), 110) AS DATETIME)
		FROM #MedicationData MD
		WHERE (
				MD.MedicationStartDateOld IS NOT NULL
				OR MD.MedicationStartDateOld <> ''
				)

		UPDATE MD
		SET MD.MedicationEndDate = cast(CONVERT(VARCHAR(20), CONVERT(DATE, CONVERT(VARCHAR(8), MD.MedicationEndDateOld), 112), 110) AS DATETIME)
		FROM #MedicationData MD
		WHERE (
				MD.MedicationEndDateOld IS NOT NULL
				OR MD.MedicationEndDateOld <> ''
				)

		--UPDATE MD      
		--SET MD.MedicationNameId = 19461      
		-- ,StrengthId = 49125      
		-- ,StrengthDescription = '100unit/mL, soln, subQ'      
		-- ,[Route] = 'Subcutaneous'      
		-- ,[RouteId] = 28      
		--FROM #MedicationData MD      
		--WHERE MD.MedicationName = 'Insulin Glargine'      
		DECLARE #SCParseCCD CURSOR FAST_FORWARD
		FOR
		SELECT RXNormCode
			,MedicationNameExternal
			,Unit
			,StrengthDescription
			,MatchFound
			,RouteId
		FROM #MedicationData
		WHERE UserDefinedMedicationId IS NULL
			AND MedicationNameExternal IS NOT NULL

		OPEN #SCParseCCD

		FETCH #SCParseCCD
		INTO @RXNormCode
			,@MedicationNameExternal
			,@Strength
			,@StrengthDescription
			,@MatchFound
			,@RouteId

		WHILE @@fetch_status = 0
		BEGIN
			IF @MatchFound = 'N'
				AND NOT EXISTS (
					SELECT 1
					FROM UserDefinedMedicationNames
					WHERE MedicationName = @MedicationNameExternal
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
			BEGIN
				INSERT INTO UserDefinedMedicationNames (
					MedicationName
					,MedicationStatus
					)
				SELECT @MedicationNameExternal
					,2161 --MEDICATIONSTATUS     Current    

				SET @UserDefinedMedicationId = Scope_Identity()

				INSERT INTO UserDefinedMedications (
					UserDefinedMedicationNameId
					,Strength
					,StrengthUnitOfMeasure
					,StrengthDescription
					,MedicationDescription
					,MedicationStatus
					,RouteId
					,UserDefinedDrugCode
					)
				SELECT @UserDefinedMedicationId
					,NULL
					,@Strength
					,@StrengthDescription
					,@MedicationNameExternal
					,2161
					,@RouteId
					,@RXNormCode

				SET @UserDefinedMedicationId = Scope_Identity()

				UPDATE M
				SET M.UserDefinedMedicationId = @UserDefinedMedicationId
				FROM #MedicationData M
				WHERE RXNormCode = @RXNormCode
			END

			FETCH #SCParseCCD
			INTO @RXNormCode
				,@MedicationNameExternal
				,@Strength
				,@StrengthDescription
				,@MatchFound
				,@RouteId
		END -- Fetch    

		CLOSE #SCParseCCD

		DEALLOCATE #SCParseCCD

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
			,MedicationNameExternal
			,UserDefinedMedicationId
		FROM #MedicationData
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(max)

		SET @Error = convert(VARCHAR, error_number()) + '*****' + convert(VARCHAR(4000), error_message()) + '*****' + isnull(convert(VARCHAR, error_procedure()), 'ssp_SCParseCCDCCRForReconciliation') + '*****' + convert(VARCHAR, error_line()) + '*****' + convert(VARCHAR, error_severity()) + '*****' + convert(VARCHAR, error_state())

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
