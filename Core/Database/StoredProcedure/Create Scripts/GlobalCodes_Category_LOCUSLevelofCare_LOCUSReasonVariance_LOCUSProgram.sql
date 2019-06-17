/********************************************************************************************
Author      :  Shivanand
CreatedDate :  28/Oct/2016
Purpose     :  Insert script for GlobalCodes for LOCUS Document
*********************************************************************************************/

--Category = 'LOCUSLevelofCare'

IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodeCategories
		WHERE Category = 'LOCUSLevelofCare'
		)
BEGIN
	INSERT INTO [GlobalCodeCategories] (
		Category
		,CategoryName
		,Active
		,AllowAddDelete
		,AllowCodeNameEdit
		,AllowSortOrderEdit
		,UserDefinedCategory
		,HasSubcodes
		)
	VALUES (
		'LOCUSLevelofCare'
		,'LOCUSLevelofCare'
		,'Y'
		,'Y'
		,'Y'
		,'Y'
		,'N'
		,'N'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'LOCUSLevelofCare'
			AND CodeName = 'Level One – Recovery Maintenance and Health Management'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'LOCUSLevelofCare'
		,'Level One – Recovery Maintenance and Health Management'
		,'Level One – Recovery Maintenance and Health Management'
		,'Y'
		,'N'
		,1
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'LOCUSLevelofCare'
			AND CodeName = 'Level Two – Low Intensity Community Based Services'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'LOCUSLevelofCare'
		,'Level Two – Low Intensity Community Based Services'
		,'Level Two – Low Intensity Community Based Services'
		,'Y'
		,'N'
		,2
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'LOCUSLevelofCare'
			AND CodeName = 'Level Three – High Intensity Community Based Services'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'LOCUSLevelofCare'
		,'Level Three – High Intensity Community Based Services'
		,'Level Three – High Intensity Community Based Services'
		,'Y'
		,'N'
		,3
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'LOCUSLevelofCare'
			AND CodeName = 'Level Four – Medically Monitored Non-Residential Services'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'LOCUSLevelofCare'
		,'Level Four – Medically Monitored Non-Residential Services'
		,'Level Four – Medically Monitored Non-Residential Services'
		,'Y'
		,'N'
		,4
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'LOCUSLevelofCare'
			AND CodeName = 'Level Five – Medically Monitored Residential Services'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'LOCUSLevelofCare'
		,'Level Five – Medically Monitored Residential Services'
		,'Level Five – Medically Monitored Residential Services'
		,'Y'
		,'N'
		,5
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'LOCUSLevelofCare'
			AND CodeName = 'Level Six – Medically Managed Residential Services'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'LOCUSLevelofCare'
		,'Level Six – Medically Managed Residential Services'
		,'Level Six – Medically Managed Residential Services'
		,'Y'
		,'N'
		,6
		)
END

GO

--Category = 'LOCUSReasonVariance'

IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodeCategories
		WHERE Category = 'LOCUSReasonVariance'
		)
BEGIN
	INSERT INTO [GlobalCodeCategories] (
		Category
		,CategoryName
		,Active
		,AllowAddDelete
		,AllowCodeNameEdit
		,AllowSortOrderEdit
		,UserDefinedCategory
		,HasSubcodes
		)
	VALUES (
		'LOCUSReasonVariance'
		,'LOCUSReasonVariance'
		,'Y'
		,'Y'
		,'Y'
		,'Y'
		,'N'
		,'N'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'LOCUSReasonVariance'
			AND CodeName = 'Clinical Decision'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'LOCUSReasonVariance'
		,'Clinical Decision'
		,'Clinical Decision'
		,'Y'
		,'N'
		,1
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'LOCUSReasonVariance'
			AND CodeName = 'Legal (Court Order, etc.)'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'LOCUSReasonVariance'
		,'Legal (Court Order, etc.)'
		,'Legal (Court Order, etc.)'
		,'Y'
		,'N'
		,2
		)
END


IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'LOCUSReasonVariance'
			AND CodeName = 'Level of Care Unavailable'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'LOCUSReasonVariance'
		,'Level of Care Unavailable'
		,'Level of Care Unavailable'
		,'Y'
		,'N'
		,3
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'LOCUSReasonVariance'
			AND CodeName = '09Other – See Evaluation Notes'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'LOCUSReasonVariance'
		,'09Other – See Evaluation Notes'
		,'09Other – See Evaluation Notes'
		,'Y'
		,'N'
		,4
		)
END

GO


--Category = 'LOCUSProgram'

IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodeCategories
		WHERE Category = 'LOCUSProgram'
		)
BEGIN
	INSERT INTO [GlobalCodeCategories] (
		Category
		,CategoryName
		,Active
		,AllowAddDelete
		,AllowCodeNameEdit
		,AllowSortOrderEdit
		,UserDefinedCategory
		,HasSubcodes
		)
	VALUES (
		'LOCUSProgram'
		,'LOCUSProgram'
		,'Y'
		,'Y'
		,'Y'
		,'Y'
		,'N'
		,'N'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'LOCUSProgram'
			AND CodeName = 'Level One - Wellness Clinic – Waverly'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'LOCUSProgram'
		,'Level One - Wellness Clinic – Waverly'
		,'Level One - Wellness Clinic – Waverly'
		,'Y'
		,'N'
		,1
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'LOCUSProgram'
			AND CodeName = 'Level One - Wellness Clinic – Forest'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'LOCUSProgram'
		,'Level One - Wellness Clinic – Forest'
		,'Level One - Wellness Clinic – Forest'
		,'Y'
		,'N'
		,2
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'LOCUSProgram'
			AND CodeName = 'Level Two - Short-Term Case Management'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'LOCUSProgram'
		,'Level Two - Short-Term Case Management'
		,'Level Two - Short-Term Case Management'
		,'Y'
		,'N'
		,3
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'LOCUSProgram'
			AND CodeName = 'Level Two - Case Management+'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'LOCUSProgram'
		,'Level Two - Case Management+'
		,'Level Two - Case Management+'
		,'Y'
		,'N'
		,4
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'LOCUSProgram'
			AND CodeName = 'Level Three - Outreach Case Management Services (OCMS)'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'LOCUSProgram'
		,'Level Three - Outreach Case Management Services (OCMS)'
		,'Level Three - Outreach Case Management Services (OCMS)'
		,'Y'
		,'N'
		,5
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'LOCUSProgram'
			AND CodeName = 'Level Three - Mason Rural Outreach Program (MROP)'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'LOCUSProgram'
		,'Level Three - Mason Rural Outreach Program (MROP)'
		,'Level Three - Mason Rural Outreach Program (MROP)'
		,'Y'
		,'N'
		,6
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'LOCUSProgram'
			AND CodeName = 'Level Three - Older Adult Services (OAS)'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'LOCUSProgram'
		,'Level Three - Older Adult Services (OAS)'
		,'Level Three - Older Adult Services (OAS)'
		,'Y'
		,'N'
		,7
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'LOCUSProgram'
			AND CodeName = 'Level Three - Crisis Recovery Team (CRT)'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'LOCUSProgram'
		,'Level Three - Crisis Recovery Team (CRT)'
		,'Level Three - Crisis Recovery Team (CRT)'
		,'Y'
		,'N'
		,8
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'LOCUSProgram'
			AND CodeName = 'Level Four - Assertive Community Treatment (ACT)'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'LOCUSProgram'
		,'Level Four - Assertive Community Treatment (ACT)'
		,'Level Four - Assertive Community Treatment (ACT)'
		,'Y'
		,'N'
		,9
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'LOCUSProgram'
			AND CodeName = 'Level Five - Bridges Crisis Unit (BCU)'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'LOCUSProgram'
		,'Level Five - Bridges Crisis Unit (BCU)'
		,'Level Five - Bridges Crisis Unit (BCU)'
		,'Y'
		,'N'
		,10
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'LOCUSProgram'
			AND CodeName = 'Level Five  - Nursing Home'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'LOCUSProgram'
		,'Level Five  - Nursing Home'
		,'Level Five  - Nursing Home'
		,'Y'
		,'N'
		,11
		)
END

GO
