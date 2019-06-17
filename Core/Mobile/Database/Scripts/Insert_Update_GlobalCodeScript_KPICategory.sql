IF NOT EXISTS (SELECT * 
               FROM   GlobalCodeCategories 
               WHERE  Category ='KPICategory') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category 
                   ,CategoryName 
                   ,Active 
                   ,AllowAddDelete 
                   ,AllowCodeNameEdit 
                   ,UserDefinedCategory 
                   ,HasSubcodes) 
      VALUES      ('KPICategory' 
                   ,'KPI Category' 
                   ,'Y'
                   ,'N' 
                   ,'Y' 
                   ,'N' 
                   ,'N') 
  END 
  
  IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Interface'
			AND Category = 'KPICategory ' 
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
		,ExternalCode1
		)
	VALUES (
		'KPICategory'
		,'Interface'
		,''
		,NULL
		,'Y'
		,'N'
		,0
		,'???'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Error Log'
			AND Category = 'KPICategory' 
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
		,ExternalCode1
		)
	VALUES (
		'KPICategory        '
		,'Error Log'
		,''
		,NULL
		,'Y'
		,'N'
		,1
		,'MetricDataErrorLogs'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Performance Log'
			AND Category = 'KPICategory' 
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
		,ExternalCode1
		)
	VALUES (
		'KPICategory'
		,'Performance Log'
		,''
		,NULL
		,'Y'
		,'N'
		,2
		,'MetricDataPerformanceLogs'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Report Log'
			AND Category = 'KPICategory' 
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
		,ExternalCode1
		)
	VALUES (
		'KPICategory'
		,'Report Log'
		,''
		,NULL
		,'Y'
		,'N'
		,2
		,'MetricDataReportLogs'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Azure'
			AND Category = 'KPICategory' 
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
		'KPICategory'
		,'Azure'
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
		WHERE CodeName = 'IIS'
			AND Category = 'KPICategory' 
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
		'KPICategory'
		,'IIS'
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
		WHERE CodeName = 'SQL'
			AND Category = 'KPICategory' 
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
		'KPICategory'
		,'SQL'
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
		WHERE CodeName = 'System'
			AND Category = 'KPICategory' 
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
		'KPICategory'
		,'System'
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
		WHERE CodeName = 'Customer Experience'
			AND Category = 'KPICategory' 
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
		'KPICategory'
		,'Customer Experience'
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
		WHERE CodeName = 'Support'
			AND Category = 'KPICategory' 
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
		'KPICategory'
		,'Support'
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
		WHERE CodeName = 'Schedule Task'
			AND Category = 'KPICategory' 
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
		'KPICategory'
		,'Schedule Task'
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
		WHERE CodeName = 'Other'
			AND Category = 'KPICategory' 
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
		'KPICategory'
		,'Other'
		,''
		,NULL
		,'Y'
		,'N'
		,2
		)
END
