
  IF NOT EXISTS (SELECT * 
               FROM   GlobalCodeCategories 
               WHERE  Category ='CollectionMethod') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category 
                   ,CategoryName 
                   ,Active 
                   ,AllowAddDelete 
                   ,AllowCodeNameEdit 
                   ,AllowSortOrderEdit
                   ,UserDefinedCategory 
                   ,HasSubcodes) 
      VALUES      ('CollectionMethod' 
                   ,'Collection Method' 
                   ,'Y'
                   ,'N' 
                   ,'Y' 
                   ,'Y'
                   ,'N' 
                   ,'N') 
  END 
  
  IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Automatic'
			AND Category = 'CollectionMethod' 
		)
BEGIN
	INSERT INTO globalcodes (
		Category
		,CodeName
		,[Code]
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		'CollectionMethod'
		,'Automatic'
		,''
		,NULL
		,'Y'
		,'N'
		,0
		)
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Manual'
			AND Category = 'CollectionMethod' 
		)
BEGIN
	INSERT INTO globalcodes (
		Category
		,CodeName
		,[Code]
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		'CollectionMethod'
		,'Manual'
		,''
		,NULL
		,'Y'
		,'N'
		,1
		)
END