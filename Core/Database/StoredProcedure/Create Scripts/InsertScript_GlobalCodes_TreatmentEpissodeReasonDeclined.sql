/************************************************************************************************                              
 
**  Author:  Sunil.D   
**  Date:    04/13/2017      
*************************************************************************************************      
**  Change History       
**  Date:    Author:   Description:       
**  --------   --------  -------------------------------------------------------------      
  
*************************************************************************************************/
IF NOT EXISTS (	SELECT 1	FROM GlobalCodeCategories	WHERE Category = 'TXEPREASONDECLINED'	AND ISNULL(RecordDeleted, 'N') = 'N'		)
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
		'TXEPREASONDECLINED'
		,'TXEPREASONDECLINED'
		,'Y'
		,'N'
		,'N'
		,'Y'
		,NULL
		,'N'
		,'N'
		)
END
IF NOT EXISTS (	SELECT 1	FROM GlobalCodes	WHERE Category = 'TXEPREASONDECLINED'	AND CodeName = 'Reason1'	AND ISNULL(RecordDeleted, 'N') = 'N'		)
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
		'TXEPREASONDECLINED'
		,'Reason1'
		,'Reason1'
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
		WHERE Category = 'TXEPREASONDECLINED'
			AND CodeName = 'Reason2'
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
		'TXEPREASONDECLINED'
		,'Reason2'
		,'Reason2'
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
