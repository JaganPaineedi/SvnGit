/****** Object:  StoredProcedure [dbo].[ssp_MMUpdateSureScriptCodes]    Script Date: 04/25/2016 17:09:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_MMUpdateSureScriptsCodes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_MMUpdateSureScriptsCodes]
GO

/****** Object:  StoredProcedure [dbo].[ssp_MMUpdateSureScriptCodes]    Script Date: 04/25/2016 17:09:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



CREATE procedure [dbo].[ssp_MMUpdateSureScriptsCodes]
--
-- Called by the automated Medication Update Process
-- Official proc generated: 04/25/2016 praorane
--
as

	-- Potency Unit Code
	-- Deletes
	UPDATE ssc
	SET RecordDeleted = 'Y'
	,   DeletedBy     = 'MMUpdate'
	,   DeletedDate   = GETDATE()
	From dbo.SureScriptsCodes ssc
	WHERE Category LIKE 'PotencyUnitCode'
		AND ISNULL(ssc.RecordDeleted, 'N') <> 'Y'
		AND NOT EXISTS (SELECT 1
		FROM       MedicationDatabase.dbo.MDDosageFormCodesPotencyUnitCodes fcpc
		INNER JOIN MedicationDatabase.dbo.MDDosageFormCodes                 fc   ON fc.DosageFormCodeId = fcpc.DosageFormCodeId
				AND ISNULL(fc.RecordDeleted, 'N') <> 'Y'
		INNER JOIN MedicationDatabase.dbo.MDNCPDPScriptQuantityQualifiers   pc   ON pc.NCPDPScriptQuantityQualifierId = fcpc.NCPDPSCRIPTQuantityQualifierId
				AND ISNULL(pc.RecordDeleted, 'N') <> 'Y'
		WHERE pc.XRefSourceId = 2
			AND ssc.SureScriptsCode = pc.QuantityQualifierCode
			AND ssc.SmartCareRxCode = fc.DosageFormCode)

	-- Adds
	INSERT INTO dbo.SureScriptsCodes ( CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, Category, SureScriptsCode, SmartCareRxCode )
	SELECT DISTINCT 'MMUpdate'
	,               GETDATE()
	,               'MMUpdate'
	,               GETDATE()
	,               'PotencyUnitCode'
	,               pc.QuantityQualifierCode
	,               fc.DosageFormCode
	FROM       MedicationDatabase.dbo.MDDosageFormCodesPotencyUnitCodes fcpc
	INNER JOIN MedicationDatabase.dbo.MDDosageFormCodes                 fc   ON fc.DosageFormCodeId = fcpc.DosageFormCodeId
			AND ISNULL(fc.RecordDeleted, 'N') <> 'Y'
	INNER JOIN MedicationDatabase.dbo.MDNCPDPScriptQuantityQualifiers   pc   ON pc.NCPDPScriptQuantityQualifierId = fcpc.NCPDPSCRIPTQuantityQualifierId
			AND ISNULL(pc.RecordDeleted, 'N') <> 'Y'
	WHERE pc.XRefSourceId = 2
		AND NOT EXISTS (SELECT 1
		FROM dbo.SureScriptsCodes ssc
		WHERE ISNULL(ssc.RecordDeleted, 'N') <> 'Y'
			AND pc.QuantityQualifierCode = ssc.SureScriptsCode
			AND fc.DosageFormCode = ssc.SmartCareRxCode
			AND Category = 'PotencyUnitCode')


	-- QuantityUnitOfMeasure
	-- Deletes
	UPDATE ssc
	SET RecordDeleted = 'Y'
	,   DeletedBy     = 'MMUpdate'
	,   DeletedDate   = GETDATE()
	From dbo.SureScriptsCodes ssc
	WHERE Category LIKE 'QuantityUnitOfMeasure'
		AND ISNULL(ssc.RecordDeleted, 'N') <> 'Y'
		AND NOT EXISTS (SELECT 1
		FROM       MedicationDatabase.dbo.MDDosageFormsPotencyUnitCode   fcpc
		INNER JOIN MedicationDatabase.dbo.MDDosageForms                  fc   ON fc.DosageFormId = fcpc.DosageFormId
				AND ISNULL(fc.RecordDeleted, 'N') <> 'Y'
		INNER JOIN MedicationDatabase.dbo.MDNCPDPScriptQuantityQualifier pc   ON pc.NCPDPScriptQuantityQualifierId = fcpc.NCPDPSCRIPTQuantityQualifierId
				AND ISNULL(pc.RecordDeleted, 'N') <> 'Y'
		WHERE pc.XRefSourceId = 2
			AND ssc.SureScriptsCode = pc.QuantityQualifierCode
			AND ssc.SmartCareRxCode = fc.DosageFormDescription)

	-- Adds
	INSERT INTO dbo.SureScriptsCodes ( CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, Category, SureScriptsCode, SmartCareRxCode )
	SELECT DISTINCT 'MMUpdate'
	,               GETDATE()
	,               'MMUpdate'
	,               GETDATE()
	,               'QuantityUnitOfMeasure'
	,               pc.QuantityQualifierCode
	,               fc.DosageFormDescription
	FROM       MedicationDatabase.dbo.MDDosageFormsPotencyUnitCode   fcpc
	INNER JOIN MedicationDatabase.dbo.MDDosageForms                  fc   ON fc.DosageFormId = fcpc.DosageFormId
			AND ISNULL(fc.RecordDeleted, 'N') <> 'Y'
	INNER JOIN MedicationDatabase.dbo.MDNCPDPScriptQuantityQualifier pc   ON pc.NCPDPScriptQuantityQualifierId = fcpc.NCPDPSCRIPTQuantityQualifierId
			AND ISNULL(pc.RecordDeleted, 'N') <> 'Y'
	WHERE pc.XRefSourceId = 2
		AND NOT EXISTS (SELECT 1
		FROM dbo.SureScriptsCodes ssc
		WHERE ISNULL(ssc.RecordDeleted, 'N') <> 'Y'
			AND pc.QuantityQualifierCode = ssc.SureScriptsCode
			AND fc.DosageFormDescription = ssc.SmartCareRxCode
			AND ssc.Category = 'QuantityUnitOfMeasure')

	-- DOSAGEFORM
	-- Deletes
	UPDATE ssc
	SET RecordDeleted = 'Y'
	,   DeletedBy     = 'MMUpdate'
	,   DeletedDate   = GETDATE()
	From dbo.SureScriptsCodes ssc
	WHERE Category LIKE 'DOSAGEFORM'
		AND ISNULL(ssc.RecordDeleted, 'N') <> 'Y'
		AND NOT EXISTS (SELECT 1
		FROM       MedicationDatabase.dbo.MDDosageFormCodesPotencyUnitCodes fcpc
		INNER JOIN MedicationDatabase.dbo.MDDosageFormCodes                 fc   ON fc.DosageFormCodeId = fcpc.DosageFormCodeId
				AND ISNULL(fc.RecordDeleted, 'N') <> 'Y'
		INNER JOIN MedicationDatabase.dbo.MDNCPDPScriptQuantityQualifiers   pc   ON pc.NCPDPScriptQuantityQualifierId = fcpc.NCPDPSCRIPTQuantityQualifierId
				AND ISNULL(pc.RecordDeleted, 'N') <> 'Y'
		WHERE pc.XRefSourceId = 1
			AND ssc.SureScriptsCode = pc.QuantityQualifierCode
			AND ssc.SmartCareRxCode = fc.DosageFormCode)

	--Adds
	INSERT INTO dbo.SureScriptsCodes ( CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, Category, SureScriptsCode, SmartCareRxCode )
	SELECT DISTINCT 'MMUpdate'
	,               GETDATE()
	,               'MMUpdate'
	,               GETDATE()
	,               'DOSAGEFORM'
	,               pc.QuantityQualifierCode
	,               fc.DosageFormCode
	FROM       MedicationDatabase.dbo.MDDosageFormCodesPotencyUnitCodes fcpc
	INNER JOIN MedicationDatabase.dbo.MDDosageFormCodes                 fc   ON fc.DosageFormCodeId = fcpc.DosageFormCodeId
			AND ISNULL(fc.RecordDeleted, 'N') <> 'Y'
	INNER JOIN MedicationDatabase.dbo.MDNCPDPScriptQuantityQualifiers   pc   ON pc.NCPDPScriptQuantityQualifierId = fcpc.NCPDPSCRIPTQuantityQualifierId
			AND ISNULL(pc.RecordDeleted, 'N') <> 'Y'
	WHERE pc.XRefSourceId = 1
		AND NOT EXISTS (SELECT 1
		FROM dbo.SureScriptsCodes ssc
		WHERE ISNULL(ssc.RecordDeleted, 'N') <> 'Y'
			AND pc.QuantityQualifierCode = ssc.SureScriptsCode
			AND fc.DosageFormCode = ssc.SmartCareRxCode
			AND ssc.Category = 'DOSAGEFORM')

	-- Quantity
	-- Deletes
	UPDATE ssc
	SET RecordDeleted = 'Y'
	,   DeletedBy     = 'MMUpdate'
	,   DeletedDate   = GETDATE()
	From dbo.SureScriptsCodes ssc
	WHERE Category LIKE 'Quantity'
		AND ISNULL(ssc.RecordDeleted, 'N') <> 'Y'
		AND NOT EXISTS (SELECT 1
		FROM       MedicationDatabase.dbo.MDDosageFormsPotencyUnitCodes   fcpc
		INNER JOIN MedicationDatabase.dbo.MDDosageForms                   fc   ON fc.DosageFormId = fcpc.DosageFormId
				AND ISNULL(fc.RecordDeleted, 'N') <> 'Y'
		INNER JOIN MedicationDatabase.dbo.MDNCPDPScriptQuantityQualifiers pc   ON pc.NCPDPScriptQuantityQualifierId = fcpc.NCPDPSCRIPTQuantityQualifierId
				AND ISNULL(pc.RecordDeleted, 'N') <> 'Y'
		WHERE pc.XRefSourceId = 1
			AND ssc.SureScriptsCode = pc.QuantityQualifierCode
			AND ssc.SmartCareRxCode = fc.DosageFormDescription)

	--Adds
	INSERT INTO dbo.SureScriptsCodes ( CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, Category, SureScriptsCode, SmartCareRxCode )
	SELECT DISTINCT 'MMUpdate'
	,               GETDATE()
	,               'MMUpdate'
	,               GETDATE()
	,               'Quantity'
	,               pc.QuantityQualifierCode
	,               fc.DosageFormDescription
	FROM       MedicationDatabase.dbo.MDDosageFormsPotencyUnitCodes   fcpc
	INNER JOIN MedicationDatabase.dbo.MDDosageForms                   fc   ON fc.DosageFormId = fcpc.DosageFormId
			AND ISNULL(fc.RecordDeleted, 'N') <> 'Y'
	INNER JOIN MedicationDatabase.dbo.MDNCPDPScriptQuantityQualifiers pc   ON pc.NCPDPScriptQuantityQualifierId = fcpc.NCPDPSCRIPTQuantityQualifierId
			AND ISNULL(pc.RecordDeleted, 'N') <> 'Y'
	WHERE pc.XRefSourceId = 1
		AND NOT EXISTS (SELECT 1
		FROM dbo.SureScriptsCodes ssc
		WHERE ISNULL(ssc.RecordDeleted, 'N') <> 'Y'
			AND pc.QuantityQualifierCode = ssc.SureScriptsCode
			AND fc.DosageFormDescription = ssc.SmartCareRxCode
			AND ssc.Category = 'Quantity')

GO


