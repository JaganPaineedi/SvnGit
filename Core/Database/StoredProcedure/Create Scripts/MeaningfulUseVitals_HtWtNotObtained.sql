/**** Insert into GlobalCodeCategories XHGHTWHTNOTOBTAINED category ****/
DECLARE @GlobalCodeCategoryId INT = 0

SELECT @GlobalCodeCategoryId = GlobalCodeCategoryId
FROM GlobalCodeCategories
WHERE Category = 'XHGHTWHTNOTOBTAINED'
	AND ISNULL(RecordDeleted, 'N') = 'N'

IF @GlobalCodeCategoryId = 0
BEGIN
	INSERT INTO GlobalCodeCategories (
		Category
		,CategoryName
		,Active
		,AllowAddDelete
		,AllowCodeNameEdit
		,AllowSortOrderEdit
		,Description
		,UserDefinedCategory
		,HasSubcodes
		)
	VALUES (
		'XHGHTWHTNOTOBTAINED'
		,'XHGHTWHTNOTOBTAINED'
		,'Y'
		,'Y'
		,'Y'
		,'Y'
		,NULL
		,'Y'
		,'N'
		)

	SET @GlobalCodeCategoryId = SCOPE_IDENTITY()
END

/**** Insert GlobalCodes 'Client is receiving palliative care' for XHGHTWHTNOTOBTAINED category ****/
IF NOT EXISTS (
		SELECT GlobalCodeId
		FROM GlobalCodes
		WHERE Category = 'XHGHTWHTNOTOBTAINED'
			AND Code = 'CLIENTINPALLIATIVECARE'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,Active
		,CannotModifyNameOrDelete
		)
	VALUES (
		'XHGHTWHTNOTOBTAINED'
		,'Client is receiving palliative care'
		,'CLIENTINPALLIATIVECARE'
		,'Y'
		,'N'
		)
END

/**** Insert GlobalCodes 'Client is pregnant' for XHGHTWHTNOTOBTAINED category ****/
IF NOT EXISTS (
		SELECT GlobalCodeId
		FROM GlobalCodes
		WHERE Category = 'XHGHTWHTNOTOBTAINED'
			AND Code = 'CLIENTISPREGNANT'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,Active
		,CannotModifyNameOrDelete
		)
	VALUES (
		'XHGHTWHTNOTOBTAINED'
		,'Client is pregnant'
		,'CLIENTISPREGNANT'
		,'Y'
		,'N'
		)
END

/**** Insert GlobalCodes 'Client refuses height and/or weight measurement' for XHGHTWHTNOTOBTAINED category ****/
IF NOT EXISTS (
		SELECT GlobalCodeId
		FROM GlobalCodes
		WHERE Category = 'XHGHTWHTNOTOBTAINED'
			AND Code = 'CLIENTREFUSES'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,Active
		,CannotModifyNameOrDelete
		)
	VALUES (
		'XHGHTWHTNOTOBTAINED'
		,'Client refuses height and/or weight measurement'
		,'CLIENTREFUSES'
		,'Y'
		,'N'
		)
END

/**** Insert GlobalCodes 'Client is in an urgent or emergent medical situation' for XHGHTWHTNOTOBTAINED category ****/
IF NOT EXISTS (
		SELECT GlobalCodeId
		FROM GlobalCodes
		WHERE Category = 'XHGHTWHTNOTOBTAINED'
			AND Code = 'CLIENTINURGENTOREMERGENCY'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,Active
		,CannotModifyNameOrDelete
		)
	VALUES (
		'XHGHTWHTNOTOBTAINED'
		,'Client is in an urgent or emergent medical situation'
		,'CLIENTINURGENTOREMERGENCY'
		,'Y'
		,'N'
		)
END

/**** Insert GlobalCodes 'Other (provide comments)' for XHGHTWHTNOTOBTAINED category ****/
IF NOT EXISTS (
		SELECT GlobalCodeId
		FROM GlobalCodes
		WHERE Category = 'XHGHTWHTNOTOBTAINED'
			AND Code = 'OTHERPROVIDECOMMENTS'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,Active
		,CannotModifyNameOrDelete
		)
	VALUES (
		'XHGHTWHTNOTOBTAINED'
		,'Other (provide comments)'
		,'OTHERPROVIDECOMMENTS'
		,'Y'
		,'N'
		)
END

/*---------------------------  HEALTHDATAATTRIBUTES (DONE)   ------------------------*/
--Height/Weight Not Obtained
BEGIN
	DECLARE @HeightWeightNotObtainedHealthdataattributeid INT = 0

	SELECT @HeightWeightNotObtainedHealthdataattributeid = healthdataattributeid
	FROM healthdataattributes
	WHERE NAME = 'Height/Weight Not Obtained'

	IF (@HeightWeightNotObtainedHealthdataattributeid = 0)
	BEGIN
		INSERT INTO healthdataattributes (
			createdby
			,ModifiedBy
			,createddate
			,modifieddate
			,category
			,datatype
			,NAME
			,description
			,dropdowncategory
			,DropdownType
			)
		VALUES (
			'SHS-CORE'
			,'SHS-CORE'
			,GETDATE()
			,GETDATE()
			,8226
			,8081
			,'Height/Weight Not Obtained'
			,'Height/Weight Not Obtained'
			,@GlobalCodeCategoryId
			,'G'
			)

		SET @HeightWeightNotObtainedHealthdataattributeid = SCOPE_IDENTITY()
	END
END

--Height/Weight Not Obtained Comments
BEGIN
	DECLARE @HeightWeightNotObtainedCommentsHealthdataattributeid INT = 0

	SELECT @HeightWeightNotObtainedCommentsHealthdataattributeid = healthdataattributeid
	FROM healthdataattributes
	WHERE NAME = 'Comments'

	IF (@HeightWeightNotObtainedCommentsHealthdataattributeid = 0)
	BEGIN
		INSERT INTO healthdataattributes (
			createdby
			,ModifiedBy
			,createddate
			,modifieddate
			,category
			,datatype
			,NAME
			,description
			,dropdowncategory
			,DropdownType
			)
		VALUES (
			'SHS-CORE'
			,'SHS-CORE'
			,GETDATE()
			,GETDATE()
			,8226
			,8084
			,'Comments'
			,'Comments'
			,NULL
			,NULL
			)

		SET @HeightWeightNotObtainedCommentsHealthdataattributeid = SCOPE_IDENTITY()
	END
END

/*---------------------------  HEALTHDATASUBTEMPLATES   (DONE) ------------------------*/
BEGIN
	DECLARE @healthdatasubtemplateid INT = 0

	SELECT @healthdatasubtemplateid = healthdatasubtemplateid
	FROM healthdatasubtemplates
	WHERE NAME = 'Height/Weight Not Obtained'

	IF (@healthdatasubtemplateid = 0)
	BEGIN
		INSERT INTO healthdatasubtemplates (
			createdby
			,ModifiedBy
			,createddate
			,modifieddate
			,NAME
			,active
			,isheading
			)
		VALUES (
			'SHS-CORE'
			,'SHS-CORE'
			,GETDATE()
			,GETDATE()
			,'Height/Weight Not Obtained'
			,'Y'
			,NULL
			)

		SET @healthdatasubtemplateid = SCOPE_IDENTITY()
	END
END

/*---------------------------  HEALTHDATASUBTEMPLATEATTRIBUTES  (D0NE) ------------------------*/
--Height/Weight Not Obtained
BEGIN
	IF NOT EXISTS (
			SELECT *
			FROM healthdatasubtemplateattributes
			WHERE healthdatasubtemplateid = @healthdatasubtemplateid
				AND healthdataattributeid = @HeightWeightNotObtainedHealthdataattributeid
			)
	BEGIN
		INSERT INTO healthdatasubtemplateattributes (
			createdby
			,modifiedby
			,createddate
			,modifieddate
			,healthdatasubtemplateid
			,healthdataattributeid
			,displayinflowsheet
			,orderinflowsheet
			,issinglelinedisplay
			)
		VALUES (
			'SHS-CORE'
			,'SHS-CORE'
			,GETDATE()
			,GETDATE()
			,@healthdatasubtemplateid
			,@HeightWeightNotObtainedHealthdataattributeid
			,'Y'
			,1
			,'N'
			)
	END
END

--Height/Weight Not Obtained Comments
BEGIN
	IF NOT EXISTS (
			SELECT *
			FROM healthdatasubtemplateattributes
			WHERE healthdatasubtemplateid = @healthdatasubtemplateid
				AND healthdataattributeid = @HeightWeightNotObtainedCommentsHealthdataattributeid
			)
	BEGIN
		INSERT INTO healthdatasubtemplateattributes (
			createdby
			,modifiedby
			,createddate
			,modifieddate
			,healthdatasubtemplateid
			,healthdataattributeid
			,displayinflowsheet
			,orderinflowsheet
			,issinglelinedisplay
			)
		VALUES (
			'SHS-CORE'
			,'SHS-CORE'
			,GETDATE()
			,GETDATE()
			,@healthdatasubtemplateid
			,@HeightWeightNotObtainedCommentsHealthdataattributeid
			,'Y'
			,2
			,'N'
			)
	END
END

/*---------------------------  HEALTHDATATEMPLATEATTRIBUTES    (DONE) ------------------------*/
BEGIN
	IF NOT EXISTS (
			SELECT *
			FROM healthdatatemplateattributes
			WHERE healthdatatemplateid = 110
				AND healthdatasubtemplateid = @healthdatasubtemplateid
			)
	BEGIN
		INSERT INTO healthdatatemplateattributes (
			createdby
			,ModifiedBy
			,createddate
			,modifieddate
			,healthdatatemplateid
			,healthdatasubtemplateid
			,healthdatagroup
			,entrydisplayorder
			,showcompletedcheckbox
			)
		VALUES (
			'SHS-CORE'
			,'SHS-CORE'
			,GETDATE()
			,GETDATE()
			,110
			,@healthdatasubtemplateid
			,0
			,2
			,'N'
			)
	END
END

UPDATE A
SET A.EntryDisplayOrder = 1
FROM healthdatatemplateattributes A
JOIN HealthDataSubTemplates s ON a.HealthDataSubTemplateId = s.HealthDataSubTemplateId
WHERE S.NAME = 'Height/Weight/BMI'

UPDATE A
SET A.EntryDisplayOrder = 2
FROM healthdatatemplateattributes A
JOIN HealthDataSubTemplates s ON a.HealthDataSubTemplateId = s.HealthDataSubTemplateId
WHERE S.NAME = 'Height/Weight Not Obtained'

UPDATE A
SET A.EntryDisplayOrder = 3
FROM healthdatatemplateattributes A
JOIN HealthDataSubTemplates s ON a.HealthDataSubTemplateId = s.HealthDataSubTemplateId
WHERE S.NAME = 'BMI Intervention'

UPDATE A
SET A.EntryDisplayOrder = 4
FROM healthdatatemplateattributes A
JOIN HealthDataSubTemplates s ON a.HealthDataSubTemplateId = s.HealthDataSubTemplateId
WHERE S.NAME = 'Blood Pressure'

UPDATE A
SET A.EntryDisplayOrder = 5
FROM healthdatatemplateattributes A
JOIN HealthDataSubTemplates s ON a.HealthDataSubTemplateId = s.HealthDataSubTemplateId
WHERE S.NAME = 'Pulse'

UPDATE A
SET A.EntryDisplayOrder = 6
FROM healthdatatemplateattributes A
JOIN HealthDataSubTemplates s ON a.HealthDataSubTemplateId = s.HealthDataSubTemplateId
WHERE S.NAME = 'Respiratory'

UPDATE A
SET A.EntryDisplayOrder = 7
FROM healthdatatemplateattributes A
JOIN HealthDataSubTemplates s ON a.HealthDataSubTemplateId = s.HealthDataSubTemplateId
WHERE S.NAME = 'Abdominal Girth'

UPDATE A
SET A.EntryDisplayOrder = 8
FROM healthdatatemplateattributes A
JOIN HealthDataSubTemplates s ON a.HealthDataSubTemplateId = s.HealthDataSubTemplateId
WHERE S.NAME = 'Temperature'

UPDATE A
SET A.EntryDisplayOrder = 9
FROM healthdatatemplateattributes A
JOIN HealthDataSubTemplates s ON a.HealthDataSubTemplateId = s.HealthDataSubTemplateId
WHERE S.NAME = 'Smoking Status'

UPDATE A
SET A.EntryDisplayOrder = 10
FROM healthdatatemplateattributes A
JOIN HealthDataSubTemplates s ON a.HealthDataSubTemplateId = s.HealthDataSubTemplateId
WHERE S.NAME = 'Tobacco Use Intervention'

UPDATE A
SET A.EntryDisplayOrder = 11
FROM healthdatatemplateattributes A
JOIN HealthDataSubTemplates s ON a.HealthDataSubTemplateId = s.HealthDataSubTemplateId
WHERE S.NAME = 'Pain'

UPDATE A
SET A.EntryDisplayOrder = 12
FROM healthdatatemplateattributes A
JOIN HealthDataSubTemplates s ON a.HealthDataSubTemplateId = s.HealthDataSubTemplateId
WHERE S.NAME = 'Medication list reconciled'

UPDATE A
SET A.EntryDisplayOrder = 13
FROM healthdatatemplateattributes A
JOIN HealthDataSubTemplates s ON a.HealthDataSubTemplateId = s.HealthDataSubTemplateId
WHERE S.NAME = 'Fall Risk'
