
  IF NOT EXISTS (SELECT * 
               FROM   GlobalCodeCategories 
               WHERE  Category ='KPIType') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category 
                   ,CategoryName 
                   ,Active 
                   ,AllowAddDelete 
                   ,AllowCodeNameEdit 
                   ,UserDefinedCategory 
                   ,HasSubcodes) 
      VALUES      ('KPIType' 
                   ,'KPI Type' 
                   ,'Y'
                   ,'N' 
                   ,'Y' 
                   ,'N' 
                   ,'N') 
  END 
  
  IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Count'
			AND Category = 'KPIType' 
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
		'KPIType'
		,'Count'
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
		WHERE CodeName = 'Average'
			AND Category = 'KPIType' 
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
		'KPIType'
		,'Average'
		,''
		,NULL
		,'Y'
		,'N'
		,1
		)
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Percentile'
			AND Category = 'KPIType' 
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
		'KPIType'
		,'Percentile'
		,''
		,NULL
		,'Y'
		,'N'
		,2
		)
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Percentage'
			AND Category = 'KPIType' 
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
		'KPIType'
		,'Percentage'
		,''
		,NULL
		,'Y'
		,'N'
		,3
		)
END
