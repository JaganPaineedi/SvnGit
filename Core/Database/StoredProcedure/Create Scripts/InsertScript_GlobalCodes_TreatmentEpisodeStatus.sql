/************************************************************************************************                              
 
**  Author:  Sunil.D   
**  Date:    04/13/2017      
*************************************************************************************************      
**  Change History       
**  Date:    Author:   Description:       
**  --------   --------  -------------------------------------------------------------      
  
*************************************************************************************************/
 
IF NOT EXISTS (	SELECT 1	FROM GlobalCodeCategories	WHERE Category = 'TXEPISODESTATUS'	AND ISNULL(RecordDeleted, 'N') = 'N'		)
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
		'TXEPISODESTATUS'
		,'TXEPISODESTATUS'
		,'Y'
		,'N'
		,'N'
		,'Y'
		,NULL
		,'N'
		,'N'
		)
END

declare @Category varchar(20)='TXEPISODESTATUS';
declare @CodeName varchar(20)='Active';
declare @Code varchar(20)='A';

IF NOT EXISTS (	SELECT 1	FROM GlobalCodes 	WHERE Category = @Category	AND Code = @Code	AND ISNULL(RecordDeleted, 'N') = 'N'		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName		,Code
		,[Description]
		,Active		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1		,ExternalSource1		,ExternalCode2
		,ExternalSource2		,Bitmap
		,BitmapImage		,Color
		)
	VALUES (
		@Category
		,@CodeName
		,@Code
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
Else
begin 
update  GlobalCodes set Category=@Category, CodeName=@CodeName ,Code=@Code  	WHERE Category = @Category	AND Code = @Code
end
 
 
 
declare @CodeName1 varchar(20)='InActive';
declare @Code1 varchar(20)='I';

IF NOT EXISTS (	SELECT 1	FROM GlobalCodes 	WHERE Category = @Category	AND Code = @Code1	AND ISNULL(RecordDeleted, 'N') = 'N'		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName		,Code
		,[Description]
		,Active		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1		,ExternalSource1		,ExternalCode2
		,ExternalSource2		,Bitmap
		,BitmapImage		,Color
		)
	VALUES (
		@Category
		,@CodeName1
		,@Code1
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
Else
begin 
update  GlobalCodes set Category=@Category, CodeName=@CodeName ,Code=@Code  	WHERE Category = @Category	AND Code = @Code
end
 