/************************************************************************************************                              
 
**  Author:  Sunil.D   
**  Date:    28/06/2017      
	Purpose     SC: Implantable Devices Details Page Screen Details #24 MeaningfulUses-Stage3
*************************************************************************************************      
**  Change History       
**  Date:    Author:   Description:       
**  --------   --------  -------------------------------------------------------------      
  
*************************************************************************************************/
IF NOT EXISTS (	SELECT 1	FROM GlobalCodeCategories	WHERE Category = 'ImpDeviceStatus'	AND ISNULL(RecordDeleted, 'N') = 'N'		)
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
		)
	VALUES (
		'ImpDeviceStatus'
		,'ImpDeviceStatus'
		,'Y'
		,'N'
		,'N'
		,'Y'
		,NULL
		,'N'
		,'N'
		)
END
IF NOT EXISTS (	SELECT 1	FROM GlobalCodes	WHERE Category = 'ImpDeviceStatus'	AND CodeName = 'Active'	AND ISNULL(RecordDeleted, 'N') = 'N'		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'ImpDeviceStatus'
		,'Active'
		,'A'
		,NULL
		,'Y'
		,'Y'
		,1
		,'1'
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
		
END
 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'ImpDeviceStatus'
			AND CodeName = 'Inactive'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'ImpDeviceStatus'
		,'Inactive'
		,'I'
		,NULL
		,'Y'
		,'Y'
		,4
		,'1'
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
