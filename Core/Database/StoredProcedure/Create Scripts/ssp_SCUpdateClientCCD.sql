
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCUpdateClientCCD]    Script Date: 06/09/2015 01:27:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCUpdateClientCCD]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCUpdateClientCCD]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_SCUpdateClientCCD]    Script Date: 06/09/2015 01:27:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCUpdateClientCCD] @DocumentVersionId INT
AS /*********************************************************************/
/* Stored Procedure: dbo.ssp_SCUpdateClientCCD            */
/* Creation Date:    24/Nov/2014                  */
/* Purpose:  Used to update ClientCCD Allergy, Medication and Problem from XML data                */
/*    Exec ssp_SCUpdateClientCCD                                              */
/* Input Parameters:                           */
/*  Date		Author			Purpose              */
/* 24/Nov/2014  Gautam			Created           Task #57,Certification 2014   */
/* 12/Oct/2017  Alok Kumar		Commented to overcome the 'XML parsing: undeclared prefix' error while linking Client in Direct Message screen.
								Ref:Task #26.2/#26.3 Meaningful Use - Stage 3
								
*********************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @XMLData AS XML
		DECLARE @ClientCCDId AS INT
		DECLARE @listAllergy VARCHAR(max)
		DECLARE @listMedication VARCHAR(max)
		DECLARE @listProblems VARCHAR(max)
		DECLARE @XMLTempdata VARCHAR(max)
		DECLARE @ClientId INT
		--DECLARE @ClientCCDId INT
		--GET THE CLIENTCCDId
		--SELECT @ClientCCDId = ClientCCDId FROM ClientCCDs where DocumentVersionId = @DocumentVersionId
		
		
		-- CHECK IF CCR OR CCD XML FORMAT
		-- BASED ON THE FORMAT THE 
		IF EXISTS (
				SELECT 1
				FROM ClientCCDs
				WHERE DocumentVersionId = @DocumentVersionId
					AND XMLData LIKE '%ccr.%'
				)
		BEGIN
			EXEC ssp_SCUpdateClientCCDOtherXML @DocumentVersionId

			--SELECT @ClientId = CLIENTID
			--FROM DOCUMENTS
			--WHERE CurrentDocumentVersionId = @DocumentVersionId

			--EXEC [SSP_HealthMaintenanceClinicalSupport] @ClientId
		END
		ELSE
		BEGIN
			SELECT @XMLData = convert(XML, XMLData)
				,@ClientCCDId = ClientCCDId
			FROM ClientCCDs
			WHERE DocumentVersionId = @DocumentVersionId

			SELECT @XMLTempdata = replace(cast(@XMLData AS VARCHAR(max)), 'xmlns:voc="urn:hl7-org:v3/voc"', '')

			--SELECT @XMLTempdata = replace(@XMLTempdata, 'xmlns:sdtc="urn:hl7-org:sdtc"', '')

			SELECT @XMLTempdata = replace(@XMLTempdata, 'xmlns="urn:hl7-org:v3"', '')

			SELECT @XMLData = cast(@XMLTempdata AS XML)

			CREATE TABLE #AllergyData (AllergyDesc VARCHAR(max))

			CREATE TABLE #MedicationData (MedicationDesc VARCHAR(max))

			CREATE TABLE #ProblemData (ProblemDesc VARCHAR(max))

			INSERT INTO #AllergyData (AllergyDesc)
			SELECT isnull(ltrim(rtrim(m.c.value('./td[1]', 'varchar(MAX)'))), '') + '-' + isnull(ltrim(rtrim(m.c.value('./td[2]', 'varchar(MAX)'))), '') + '-' + isnull(ltrim(rtrim(m.c.value('./td[3]', 'varchar(MAX)'))), '') + '-' + isnull(ltrim(rtrim(m.c.value('./td[4]', 'varchar(MAX)'))), '')
			FROM @XMLData.nodes('ClinicalDocument/component/structuredBody/component/section/text/table/tbody/tr') AS m(c)
			WHERE m.c.exist('../../../../templateId[@root ="2.16.840.1.113883.10.20.22.2.6.1"]') = 1

			INSERT INTO #MedicationData (MedicationDesc)
			SELECT isnull(ltrim(rtrim(m.c.value('./td[1]', 'varchar(MAX)'))), '') + '-' + isnull(ltrim(rtrim(m.c.value('./td[2]', 'varchar(MAX)'))), '') + '-' + isnull(ltrim(rtrim(m.c.value('./td[3]', 'varchar(MAX)'))), '') + '-' + isnull(ltrim(rtrim(m.c.value('./td[4]', 'varchar(MAX)'))), '') + '-' + isnull(ltrim(rtrim(m.c.value('./td[5]', 'varchar(MAX)'))), '') + '-' + isnull(ltrim(rtrim(m.c.value('./td[6]', 'varchar(MAX)'))), '')
			FROM @XMLData.nodes('ClinicalDocument/component/structuredBody/component/section/text/table/tbody/tr') AS m(c)
			WHERE m.c.exist('../../../../templateId[@root ="2.16.840.1.113883.10.20.22.2.1.1"]') = 1

			INSERT INTO #ProblemData (ProblemDesc)
			SELECT isnull(ltrim(rtrim(m.c.value('./td[1]', 'varchar(MAX)'))), '') + '-' + isnull(ltrim(rtrim(m.c.value('./td[2]', 'varchar(MAX)'))), '') + '-' + isnull(ltrim(rtrim(m.c.value('./td[3]', 'varchar(MAX)'))), '')
			FROM @XMLData.nodes('ClinicalDocument/component/structuredBody/component/section/text/table/tbody/tr') AS m(c)
			WHERE m.c.exist('../../../../templateId[@root ="2.16.840.1.113883.10.20.22.2.5.1"]') = 1

			SELECT @listAllergy = coalesce(@listAllergy + '<br>', '') + AllergyDesc
			FROM #AllergyData

			SELECT @listMedication = coalesce(@listMedication + '<br>', '') + MedicationDesc
			FROM #MedicationData

			SELECT @listProblems = coalesce(@listProblems + '<br>', '') + ProblemDesc
			FROM #ProblemData

			UPDATE ccd
			SET ccd.Allergies = @listAllergy
				,ccd.Medications = @listMedication
				,ccd.Problems = @listProblems
			FROM ClientCCDs ccd
			WHERE ClientCCDId = @ClientCCDId

			DECLARE @ReconceliationDocument INT

			SELECT @ReconceliationDocument = DocumentVersionId
			FROM dbo.ClinicalInformationReconciliation AS cir
			WHERE cir.DocumentVersionId = @DocumentVersionId

			IF (@ReconceliationDocument IS NOT NULL)
			BEGIN
				UPDATE dbo.ClinicalInformationReconciliation
				SET Allergies = @listAllergy
					,Medications = @listMedication
					,Diagnoses = @listProblems
				WHERE DocumentVersionId = @DocumentVersionId
			END
			ELSE
			BEGIN
				INSERT INTO dbo.ClinicalInformationReconciliation (
					DocumentVersionId
					,CreatedBy
					,CreatedDate
					,ModifiedBy
					,ModifiedDate
					,Medications
					,Allergies
					,Diagnoses
					--,ClientCCDId
					)
				SELECT @DocumentVersionId -- DocumentVersionId - int
					,ccd.CreatedBy -- CreatedBy - type_CurrentUser
					,ccd.CreatedDate -- CreatedDate - type_CurrentDatetime
					,ccd.ModifiedBy -- ModifiedBy - type_CurrentUser
					,ccd.ModifiedDate -- ModifiedDate - type_CurrentDatetime
					,@listMedication -- Medications - varchar(max)
					,@listAllergy -- Allergies - varchar(max)
					,@listProblems -- Diagnoses - varchar(max)
				FROM dbo.ClientCCDs AS ccd
				WHERE ccd.DocumentVersionId = @DocumentVersionId
			END

			--SELECT @ClientId = CLIENTID
			--FROM DOCUMENTS
			--WHERE CurrentDocumentVersionId = @DocumentVersionId

			--EXEC [SSP_HealthMaintenanceClinicalSupport] @ClientId
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(max)

		SET @Error = convert(VARCHAR, error_number()) + '*****' + convert(VARCHAR(4000), error_message()) + '*****' + isnull(convert(VARCHAR, error_procedure()), 'ssp_SCUpdateClientCCD') + '*****' + convert(VARCHAR, error_line()) + '*****' + convert(VARCHAR, error_severity()) + '*****' + convert(VARCHAR, error_state())

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

