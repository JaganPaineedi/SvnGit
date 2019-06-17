-- Global codes script for category MEANINGFULUSEMEASURE and related Global codes Add Global Codes for 'Stage 2 – Modified’
-- Gautam       4th  Jan 2015  
IF NOT EXISTS (
		SELECT Category
		FROM GlobalCodeCategories
		WHERE Category = 'MeaningFulUseStages'
		)
BEGIN
	INSERT INTO GlobalCodeCategories (
		Category
		,CategoryName
		,Active
		,AllowAddDelete
		,AllowCodeNameEdit
		,AllowSortOrderEdit
		,[Description]
		,UserDefinedCategory
		,HasSubcodes
		,UsedInCareManagement
		)
	VALUES (
		'MEANINGFULUSESTAGES'
		,'MEANINGFULUSESTAGES'
		,'Y'
		,'N'
		,'Y'
		,'Y'
		,'Category for MEANINGFULUSE Stages'
		,'N'
		,'N'
		,'Y'
		)
END
GO

IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE GlobalcodeId = 9476
		)
BEGIN
	SET IDENTITY_INSERT GlobalCodes ON

	INSERT INTO GlobalCodes (
		GlobalcodeId
		,Category
		,CodeName
		,Code
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode2
		)
	VALUES (
		9476
		,'MEANINGFULUSESTAGES'
		,'ACI Transition -  Stage 3'
		,'ACITRANSITIONSTAGE3'
		,'Y'
		,'N'
		,4
		,NULL
		)

	SET IDENTITY_INSERT GlobalCodes OFF
END

IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE GlobalcodeId = 9477
		)
BEGIN
	SET IDENTITY_INSERT GlobalCodes ON

	INSERT INTO GlobalCodes (
		GlobalcodeId
		,Category
		,CodeName
		,Code
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode2
		)
	VALUES (
		9477
		,'MEANINGFULUSESTAGES'
		,'Group ACI Transition - Stage 3'
		,'GROUPACITRANSITIONSTAGE3'
		,'Y'
		,'N'
		,5
		,NULL
		)

	SET IDENTITY_INSERT GlobalCodes OFF
END

IF NOT EXISTS (
		SELECT GlobalCodeId
		FROM GlobalCodes
		WHERE GlobalCodeId = 9480
		)
BEGIN
	SET IDENTITY_INSERT GlobalCodes ON

	INSERT INTO GlobalCodes (
		GlobalCodeId
		,Category
		,CodeName
		,Code
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode2
		)
	VALUES (
		9480
		,'MEANINGFULUSESTAGES'
		,'ACI Transition - Stage2 – Modified'
		,'ACITRANSITIONSTAGE2-MODIFIED'
		,'Y'
		,'N'
		,6
		,NULL
		)

	SET IDENTITY_INSERT GlobalCodes OFF
END

IF NOT EXISTS (
		SELECT GlobalCodeId
		FROM GlobalCodes
		WHERE GlobalCodeId = 9481
		)
BEGIN
	SET IDENTITY_INSERT GlobalCodes ON

	INSERT INTO GlobalCodes (
		GlobalCodeId
		,Category
		,CodeName
		,Code
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode2
		)
	VALUES (
		9481
		,'MEANINGFULUSESTAGES'
		,'Group ACI Transition - Stage2 – Modified'
		,'GROUPACITRANSITIONSTAGE2-MODIFIED'
		,'Y'
		,'N'
		,7
		,NULL
		)

	SET IDENTITY_INSERT GlobalCodes OFF
END

---MEANINGFULUSEMEASURE
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE GlobalcodeId = 8710
		)
BEGIN
	SET IDENTITY_INSERT GlobalCodes ON

	INSERT INTO GlobalCodes (
		GlobalcodeId
		,Category
		,CodeName
		,Code
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode2
		)
	VALUES (
		8710
		,'MEANINGFULUSEMEASURE'
		,'View, Download, Transmit'
		,'VIEWDOWNLOADTRANSMIT'
		,'Y'
		,'Y'
		,33
		,NULL
		)

	SET IDENTITY_INSERT GlobalCodes OFF
END

IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE GlobalcodeId = 9478
		)
BEGIN
	SET IDENTITY_INSERT GlobalCodes ON

	INSERT INTO GlobalCodes (
		GlobalcodeId
		,Category
		,CodeName
		,Code
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode2
		)
	VALUES (
		9478
		,'MEANINGFULUSEMEASURE'
		,'Patient Generated Health Data'
		,'PATIENTGENERATEDHEALTHDATA'
		,'Y'
		,'Y'
		,34
		,NULL
		)

	SET IDENTITY_INSERT GlobalCodes OFF
END

IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE GlobalcodeId = 9479
		)
BEGIN
	SET IDENTITY_INSERT GlobalCodes ON

	INSERT INTO GlobalCodes (
		GlobalcodeId
		,Category
		,CodeName
		,Code
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode2
		)
	VALUES (
		9479
		,'MEANINGFULUSEMEASURE'
		,'Receive and Incorporate'
		,'RECEIVEANDINCORPORATE'
		,'Y'
		,'Y'
		,35
		,NULL
		)

	SET IDENTITY_INSERT GlobalCodes OFF
END

---GlobalSubCodes
IF EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE GlobalCodeId = 8683
			AND isnull(RecordDeleted, 'N') = 'N'
		)
BEGIN
	IF NOT EXISTS (
			SELECT 1
			FROM GlobalSubCodes
			WHERE GlobalSubCodeId = 6266
				AND isnull(RecordDeleted, 'N') = 'N'
			)
	BEGIN
		SET IDENTITY_INSERT GlobalSubCodes ON

		INSERT INTO GlobalSubCodes (
			GlobalSubCodeId
			,GlobalCodeId
			,SubCodeName
			,Active
			,CannotModifyNameOrDelete
			,SortOrder
			)
		VALUES (
			6266
			,8683
			,'Measure1'
			,'Y'
			,'N'
			,1
			)

		SET IDENTITY_INSERT GlobalSubCodes OFF
	END

	IF NOT EXISTS (
			SELECT 1
			FROM GlobalSubCodes
			WHERE GlobalSubCodeId = 6267
				AND isnull(RecordDeleted, 'N') = 'N'
			)
	BEGIN
		SET IDENTITY_INSERT GlobalSubCodes ON

		INSERT INTO GlobalSubCodes (
			GlobalSubCodeId
			,GlobalCodeId
			,SubCodeName
			,Active
			,CannotModifyNameOrDelete
			,SortOrder
			)
		VALUES (
			6267
			,8683
			,'Measure2'
			,'Y'
			,'N'
			,2
			)

		SET IDENTITY_INSERT GlobalSubCodes OFF
	END
END
