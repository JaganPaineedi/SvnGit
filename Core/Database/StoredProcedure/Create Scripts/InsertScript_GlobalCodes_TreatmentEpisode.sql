/************************************************************************************************                              
 
**  Author:  Sunil.D   
**  Date:    04/13/2017      
*************************************************************************************************      
**  Change History       
**  Date:    Author:   Description:       
**  --------   --------  -------------------------------------------------------------      
  
*************************************************************************************************/  
IF NOT EXISTS (	SELECT 1	FROM GlobalCodeCategories	WHERE Category = 'TREATMENTEPISODETYPE'	AND ISNULL(RecordDeleted, 'N') = 'N'		)
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
		'TREATMENTEPISODETYPE'
		,'TREATMENTEPISODETYPE'
		,'Y'
		,'N'
		,'N'
		,'Y'
		,NULL
		,'N'
		,'Y'
		)
END
IF NOT EXISTS (	SELECT 1	FROM GlobalCodes	WHERE Category = 'TREATMENTEPISODETYPE'	AND CodeName = 'Test1'	AND ISNULL(RecordDeleted, 'N') = 'N'		)
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
		'TREATMENTEPISODETYPE'
		,'Test1'
		,'Test1'
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
declare   @GlobalCodeId int
set @GlobalCodeId=(SELECT GlobalCodeId	FROM GlobalCodes	WHERE Category = 'TREATMENTEPISODETYPE'	AND Code = 'Test1'	AND ISNULL(RecordDeleted, 'N') = 'N')
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=@GlobalCodeId AND Code='TestSub1' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Code,Active,CannotModifyNameOrDelete,sortorder)
VALUES(@GlobalCodeId,'TestSub1','TestSub1','Y','N',1)
END
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=@GlobalCodeId AND Code='TestSub2' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Code,Active,CannotModifyNameOrDelete,sortorder)
VALUES(@GlobalCodeId,'TestSub2','TestSub2','Y','N',1)
END

IF NOT EXISTS (	SELECT 1	FROM GlobalCodes	WHERE Category = 'TREATMENTEPISODETYPE'		AND Code = 'Test2'		AND ISNULL(RecordDeleted, 'N') = 'N'
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
		'TREATMENTEPISODETYPE'
		,'Test2'
		,'Test2'
		,NULL
		,'Y'
		,'Y'
		,2
		,'1'
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END

set @GlobalCodeId=(SELECT GlobalCodeId	FROM GlobalCodes	WHERE Category = 'TREATMENTEPISODETYPE'	AND Code = 'Test2'	AND ISNULL(RecordDeleted, 'N') = 'N')
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=@GlobalCodeId AND SubCodeName='Test2Sub1' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Code,Active,CannotModifyNameOrDelete,sortorder)
VALUES(@GlobalCodeId,'Test2Sub1','Test2Sub1','Y','N',1)
END
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=@GlobalCodeId AND Code='Test2Sub2' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Code,Active,CannotModifyNameOrDelete,sortorder)
VALUES(@GlobalCodeId,'Test2Sub2','Test2Sub2','Y','N',1)
END

 
 