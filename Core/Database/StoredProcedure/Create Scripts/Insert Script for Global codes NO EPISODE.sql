IF NOT EXISTS (
  SELECT *
  FROM dbo.GlobalCodeCategories
  WHERE Category = 'PROGRAMTYPE'
  )
BEGIN
 INSERT INTO dbo.GlobalCodeCategories (
  Category
  ,CategoryName
  ,Active
  ,AllowAddDelete
  ,AllowCodeNameEdit
  ,AllowSortOrderEdit
  ,Description
  ,UserDefinedCategory
  ,HasSubcodes
  ,UsedInPracticeManagement
  ,UsedInCareManagement
  )
 VALUES (
  'PROGRAMTYPE'
  ,'Program Type'
  ,'Y'
  ,'Y'
  ,'Y'
  ,'Y'
  ,NULL
  ,'N'
  ,'N'
  ,'Y'
  ,'N'
  )
END
ELSE
BEGIN
 UPDATE GlobalCodeCategories
 SET CategoryName = 'Program Type'
  ,Active = 'Y'
 WHERE Category = 'PROGRAMTYPE'
END

IF NOT EXISTS (
  SELECT *
  FROM globalcodes
  WHERE GlobalCodeId = 8867
  )
BEGIN
 SET IDENTITY_INSERT dbo.GlobalCodes ON

 INSERT INTO globalcodes (
  GlobalCodeId
  ,Category
  ,CodeName
  ,Code
  ,Description
  ,Active
  ,CannotModifyNameOrDelete
  ,SortOrder
  )
 VALUES (
  8867
  ,'PROGRAMTYPE'
  ,'No Episode'
  ,'NOEPISODE'
  ,NULL
  ,'Y'
  ,'N'
  ,18
  )

 SET IDENTITY_INSERT dbo.GlobalCodes OFF
END
ELSE
BEGIN
 UPDATE globalcodes
 SET Category = 'PROGRAMTYPE'
  ,CodeName = 'No Episode'
  ,Code = 'NO EPISODE'
  ,Description = NULL
  ,Active = 'Y'
  ,CannotModifyNameOrDelete = 'N'
  ,SortOrder = 18
  ,ExternalCode1 = NULL
 WHERE GlobalCodeId = 8867
END
