-------------------------------------------------------
--Author :Vaibhav Khare
--Date   :09-04-2015
--Purpose:Showing orders Hazardous Medications category.
---------------------------------------------------------
IF NOT EXISTS (
		SELECT *
		FROM GlobalCodeCategories
		WHERE CategoryName = 'HazardousMedication'
			AND Category = 'HazardousMedication'
		)
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
		,UsedInPracticeManagement
		)
	VALUES (
		'HazardousMedication'
		,'HazardousMedication'
		,'Y'
		,'Y'
		,'Y'
		,'Y'
		,''
		,'N'
		,'N'
		,'Y'
		)
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories
	SET Category = 'HazardousMedication'
		,CategoryName = 'HazardousMedication'
		,Active = 'Y'
		,AllowAddDelete = 'Y'
		,AllowCodeNameEdit = 'Y'
		,AllowSortOrderEdit = 'Y'
		,[Description] = ''
		,UserDefinedCategory = 'N'
		,HasSubcodes = 'N'
		,UsedInPracticeManagement = 'Y'
	WHERE CategoryName = 'HazardousMedication'
		AND Category = 'HazardousMedication'
END
GO
IF NOT EXISTS(SELECT * FROM   GlobalCodes WHERE  GlobalcodeId=8984) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,Category, 
                   CodeName,
                   Code, 
                   Active, 
                   CannotModifyNameOrDelete,
                   [Description]) 
      VALUES     (8984,'HazardousMedication', 
                  'Category 1', 
                  'Category1', 
                  'Y', 
                  'N',
                  'Caution with handling, administering, and disposal.') 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END 
ELSE 
  BEGIN 
      UPDATE GlobalCodes 
      SET    Category = 'HazardousMedication', 
             CodeName = 'Category 1', 
             Code ='Category1',
             Active = 'Y', 
             CannotModifyNameOrDelete = 'N',
             [Description]='Caution with handling, administering, and disposal.' 
      WHERE  GlobalcodeId=8984
  END 




IF NOT EXISTS(SELECT * FROM   GlobalCodes WHERE  GlobalcodeId=8985) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,Category, 
                   CodeName,
                   Code, 
                   Active, 
                   CannotModifyNameOrDelete,
                   [Description]) 
      VALUES     (8985,'HazardousMedication', 
                  'Category 2', 
                  'Category2', 
                  'Y', 
                  'N',
                  'If product needs to be cut, use caution in handling. Gloves suggested.') 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END 
ELSE 
  BEGIN 
      UPDATE GlobalCodes 
      SET    Category = 'HazardousMedication', 
             CodeName = 'Category 2', 
             Code ='Category2',
             Active = 'Y', 
             CannotModifyNameOrDelete = 'N',
             [Description]='If product needs to be cut, use caution in handling. Gloves suggested.'
      WHERE  GlobalcodeId=8985
  END 


