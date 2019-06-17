/********************************************************************************************
Author      :  Kaushal Pandey
CreatedDate :  26/Nov/2018
Purpose     :  Created new copy of LOCUS TO CALOCUS for task#21 	MHP - Enhancements - CALOCUS
*********************************************************************************************/
--LOCUSReasonVariance - CALOCUSReasonVariance - CALOCUSReasonVar - (size)
--Category = 'CALOCUSLevelofCare'

IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodeCategories
		WHERE Category = 'CALOCUSLevelofCare'
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
		'CALOCUSLevelofCare'
		,'CALOCUSLevelofCare'
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
		WHERE Category = 'CALOCUSLevelofCare'
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
		'CALOCUSLevelofCare'
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
		WHERE Category = 'CALOCUSLevelofCare'
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
		'CALOCUSLevelofCare'
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
		WHERE Category = 'CALOCUSLevelofCare'
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
		'CALOCUSLevelofCare'
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
		WHERE Category = 'CALOCUSLevelofCare'
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
		'CALOCUSLevelofCare'
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
		WHERE Category = 'CALOCUSLevelofCare'
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
		'CALOCUSLevelofCare'
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
		WHERE Category = 'CALOCUSLevelofCare'
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
		'CALOCUSLevelofCare'
		,'Level Six – Medically Managed Residential Services'
		,'Level Six – Medically Managed Residential Services'
		,'Y'
		,'N'
		,6
		)
END

GO

--Category = 'CALOCUSReasonVar'

IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodeCategories
		WHERE Category = 'CALOCUSReasonVar'
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
		'CALOCUSReasonVar'
		,'CALOCUSReasonVar'
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
		WHERE Category = 'CALOCUSReasonVar'
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
		'CALOCUSReasonVar'
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
		WHERE Category = 'CALOCUSReasonVar'
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
		'CALOCUSReasonVar'
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
		WHERE Category = 'CALOCUSReasonVar'
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
		'CALOCUSReasonVar'
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
		WHERE Category = 'CALOCUSReasonVar'
			AND CodeName = 'Other – See Evaluation Notes'
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
		'CALOCUSReasonVar'
		,'Other – See Evaluation Notes'
		,'Other – See Evaluation Notes'
		,'Y'
		,'N'
		,4
		)
END

GO


--Category = 'CALOCUSProgram'

IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodeCategories
		WHERE Category = 'CALOCUSProgram'
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
		'CALOCUSProgram'
		,'CALOCUSProgram'
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
		WHERE Category = 'CALOCUSProgram'
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
		'CALOCUSProgram'
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
		WHERE Category = 'CALOCUSProgram'
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
		'CALOCUSProgram'
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
		WHERE Category = 'CALOCUSProgram'
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
		'CALOCUSProgram'
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
		WHERE Category = 'CALOCUSProgram'
			AND CodeName = 'Level Two - Case Management'
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
		'CALOCUSProgram'
		,'Level Two - Case Management'
		,'Level Two - Case Management'
		,'Y'
		,'N'
		,4
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'CALOCUSProgram'
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
		'CALOCUSProgram'
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
		WHERE Category = 'CALOCUSProgram'
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
		'CALOCUSProgram'
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
		WHERE Category = 'CALOCUSProgram'
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
		'CALOCUSProgram'
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
		WHERE Category = 'CALOCUSProgram'
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
		'CALOCUSProgram'
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
		WHERE Category = 'CALOCUSProgram'
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
		'CALOCUSProgram'
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
		WHERE Category = 'CALOCUSProgram'
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
		'CALOCUSProgram'
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
		WHERE Category = 'CALOCUSProgram'
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
		'CALOCUSProgram'
		,'Level Five  - Nursing Home'
		,'Level Five  - Nursing Home'
		,'Y'
		,'N'
		,11
		)
END

GO
