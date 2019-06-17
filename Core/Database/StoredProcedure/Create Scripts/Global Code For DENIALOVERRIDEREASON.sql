--Moved Global code from custom to core 
delete from GlobalCodes where  CodeName='Out of County' and Category = 'DENIALOVERRIDEREASON'
delete from GlobalCodes where  CodeName='20 Sessions Used' and Category = 'DENIALOVERRIDEREASON'

IF NOT EXISTS (
  SELECT *
  FROM globalcodes
  WHERE GlobalCodeId = 8995
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
  ,ExternalCode1
  )
 VALUES (
  8995
  ,'DENIALOVERRIDEREASON'
  ,'20 Sessions Used'
  ,'20 Sessions Used'
  ,'20 Sessions Used'
  ,'Y'
  ,'N'
  ,2
  ,'01'
  )

 SET IDENTITY_INSERT dbo.GlobalCodes OFF
END
ELSE
BEGIN
 UPDATE globalcodes
 SET Category = 'DENIALOVERRIDEREASON'
  ,CodeName = '20 Sessions Used'
  ,Code = '20 Sessions Used'
  ,Description = '20 Sessions Used'
  ,Active = 'Y'
  ,CannotModifyNameOrDelete = 'N'
  ,SortOrder = 2
  ,ExternalCode1 = '01'
 WHERE GlobalCodeId = 8995
END

IF NOT EXISTS (
  SELECT *
  FROM globalcodes
  WHERE GlobalCodeId = 8996
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
  ,ExternalCode1
  )
 VALUES (
  8996
  ,'DENIALOVERRIDEREASON'
  ,'Out of County'
  ,'Out of County'
  ,'Out of County'
  ,'Y'
  ,'N'
  ,3
  ,'01'
  )

 SET IDENTITY_INSERT dbo.GlobalCodes OFF
END
ELSE
BEGIN
 UPDATE globalcodes
 SET Category = 'DENIALOVERRIDEREASON'
  ,CodeName = 'Out of County'
  ,Code = 'Out of County'
  ,Description = 'Out of County'
  ,Active = 'Y'
  ,CannotModifyNameOrDelete = 'N'
  ,SortOrder = 3
  ,ExternalCode1 = '01'
 WHERE GlobalCodeId = 8996
END





