-- CREATE CATEGORY = CLIENTPROBLEMTYPES
IF NOT EXISTS (
  SELECT *
  FROM dbo.globalcodecategories
  WHERE category = 'CLIENTPROBLEMTYPES'
  )
BEGIN
 INSERT INTO dbo.globalcodecategories (
  category
  ,categoryname
  ,active
  ,allowadddelete
  ,allowcodenameedit
  ,allowsortorderedit
  ,description
  ,userdefinedcategory
  ,hassubcodes
  ,usedinpracticemanagement
  ,usedincaremanagement
  )
 VALUES (
  'CLIENTPROBLEMTYPES'
  ,'CLIENTPROBLEMTYPES'
  ,'Y'
  ,'Y'
  ,'Y'
  ,'Y'
  ,NULL
  ,'N'
  ,'N'
  ,'N'
  ,'N'
  )
END 
 
-- CREATE 'OTHER'  - NEW GLOBAL CODE FOR CATEGORY = CLIENTPROBLEMTYPES 
IF NOT EXISTS (
            SELECT GlobalCodeId
            FROM GlobalCodes
            WHERE Category = 'CLIENTPROBLEMTYPES'
                  AND Code = 'Major' AND GlobalCodeID = 8151
            )
BEGIN
      SET IDENTITY_INSERT dbo.globalcodes ON
      INSERT INTO GlobalCodes (
            globalcodeid
            ,Category
            ,CodeName
            ,Code
            ,Description
            ,Active
            ,CannotModifyNameOrDelete
            ,SortOrder
            )
      VALUES (
            8151
            ,'CLIENTPROBLEMTYPES'
            ,'Major'
            ,'Major'
            ,NULL
            ,'Y'
            ,'Y'
            ,1
            )
      SET IDENTITY_INSERT dbo.globalcodes OFF   
END         
 
 
IF NOT EXISTS (
            SELECT GlobalCodeId
            FROM GlobalCodes
            WHERE Category = 'CLIENTPROBLEMTYPES'
                  AND Code = 'Other' AND GlobalCodeID = 8152
            )
BEGIN
      SET IDENTITY_INSERT dbo.globalcodes ON
      INSERT INTO GlobalCodes (
            globalcodeid
            ,Category
            ,CodeName
            ,Code
            ,Description
            ,Active
            ,CannotModifyNameOrDelete
            ,SortOrder
            )
      VALUES (
            8152
            ,'CLIENTPROBLEMTYPES'
            ,'Other'
            ,'Other'
            ,NULL
            ,'Y'
            ,'Y'
            ,1
            )
      SET IDENTITY_INSERT dbo.globalcodes OFF   
END   
 
