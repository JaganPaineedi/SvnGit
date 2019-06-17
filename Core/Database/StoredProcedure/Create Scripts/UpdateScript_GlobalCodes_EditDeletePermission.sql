UPDATE GlobalCodeCategories
SET AllowAddDelete = 'Y'
	,AllowCodeNameEdit = 'Y'
	,AllowSortOrderEdit = 'Y'
WHERE Category IN (
		 'ROIContact'
		,'ROIPURPOSEOFDISCLOSU'
		,'ROIEXPIRATION'
		,'ROITYPE'
		,'ROIINFORMATIONUSED'
		,'ROIIDVerify'
		)


UPDATE GlobalCodes
SET CannotModifyNameOrDelete = 'N'
WHERE Category IN (
		 'ROIContact'
		,'ROIPURPOSEOFDISCLOSU'
		,'ROIEXPIRATION'
		,'ROITYPE'
		,'ROIINFORMATIONUSED'
		,'ROIIDVerify'
		)