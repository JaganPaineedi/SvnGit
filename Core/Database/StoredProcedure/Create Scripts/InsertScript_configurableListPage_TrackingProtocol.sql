--Get the screen Id
DECLARE @ScreenId INT

SELECT  @ScreenId = ScreenId
FROM Screens 
WHERE ScreenName = 'Tracking Protocols' AND ScreenType=5762 AND TabId=4 AND ISNULL(RecordDeleted,'N')='N'

DECLARE @ListPageColumnConfigurationId INT;
--Create the Template View Records
INSERT INTO dbo.ListPageColumnConfigurations (  ScreenId, StaffId, ViewName, Active, DefaultView, Template )
SELECT @ScreenId,
NULL, --StaffId is not currently being used, it may in the future
'Tracking Protocols Original', --Must be Original
'Y',
NULL, --Must be null
'Y'
WHERE NOT EXISTS( SELECT 1
				  FROM dbo.ListPageColumnConfigurations
				  WHERE ScreenId = @ScreenId
				  AND ISNULL(RecordDeleted,'N')='N'
				  )

SELECT @ListPageColumnConfigurationId = ListPageColumnConfigurationId
				  FROM dbo.ListPageColumnConfigurations
				  WHERE ScreenId = @ScreenId
				  AND ISNULL(RecordDeleted,'N')='N'

--Create a record for each column in the user control	
/*
FieldName should match the "FieldName" attribute of the column in the usercontrol
SortOrder starts at 1
All SortOrders of Fixed Columns (Y) must be less than All sort orders of Non Fixed Columns (N)
*/	  
INSERT INTO dbo.ListPageColumnConfigurationColumns (ListPageColumnConfigurationId, FieldName, Caption, DisplayAs, SortOrder, ShowColumn, Width, Fixed )
SELECT @ListPageColumnConfigurationId,'ProtocolName','ProtocolName','ProtocolName',1,'Y',150,'N'
WHERE NOT EXISTS( SELECT 1
				  FROM dbo.ListPageColumnConfigurationColumns
				  WHERE FieldName = 'ProtocolName' and ListPageColumnConfigurationId 
				  in (SELECT LPCC.ListPageColumnConfigurationId
				  FROM dbo.ListPageColumnConfigurations LPCC 
				  WHERE ScreenId = @ScreenId 
				  AND ISNULL(RecordDeleted,'N')='N') 
				  AND ISNULL(RecordDeleted,'N')='N'
				  )
UNION ALL 
SELECT @ListPageColumnConfigurationId,'StartDate','Start Date','Start Date',2,'Y',150,'N'
WHERE NOT EXISTS( SELECT 1
				  FROM dbo.ListPageColumnConfigurationColumns
				  WHERE FieldName = 'StartDate' and ListPageColumnConfigurationId 
				  in (SELECT LPCC.ListPageColumnConfigurationId
				  FROM dbo.ListPageColumnConfigurations LPCC 
				  WHERE ScreenId = @ScreenId 
				  AND ISNULL(RecordDeleted,'N')='N') 
				  AND ISNULL(RecordDeleted,'N')='N'
				  )
UNION ALL 
SELECT @ListPageColumnConfigurationId,'EndDate','End Date','End Date',3,'Y',150,'N'
WHERE NOT EXISTS( SELECT 1
				  FROM dbo.ListPageColumnConfigurationColumns
				  WHERE FieldName = 'EndDate' and ListPageColumnConfigurationId 
				  in (SELECT LPCC.ListPageColumnConfigurationId
				  FROM dbo.ListPageColumnConfigurations LPCC 
				  WHERE ScreenId = @ScreenId 
				  AND ISNULL(RecordDeleted,'N')='N') 
				  AND ISNULL(RecordDeleted,'N')='N'
				  )
UNION ALL 
SELECT @ListPageColumnConfigurationId,'Active','Active','Active',4,'Y',150,'N'
WHERE NOT EXISTS( SELECT 1
				  FROM dbo.ListPageColumnConfigurationColumns
				  WHERE FieldName = 'Active' and ListPageColumnConfigurationId 
				  in (SELECT LPCC.ListPageColumnConfigurationId
				  FROM dbo.ListPageColumnConfigurations LPCC 
				  WHERE ScreenId = @ScreenId 
				  AND ISNULL(RecordDeleted,'N')='N') 
				  AND ISNULL(RecordDeleted,'N')='N'
				  )
UNION ALL 
SELECT @ListPageColumnConfigurationId,'FlagCount','# of Flag','# of Flag',5,'Y',132,'N'
WHERE NOT EXISTS( SELECT 1
				  FROM dbo.ListPageColumnConfigurationColumns
				  WHERE FieldName = 'FlagCount' and ListPageColumnConfigurationId 
				  in (SELECT LPCC.ListPageColumnConfigurationId
				  FROM dbo.ListPageColumnConfigurations LPCC 
				  WHERE ScreenId = @ScreenId 
				  AND ISNULL(RecordDeleted,'N')='N') 
				  AND ISNULL(RecordDeleted,'N')='N'
				  )
UNION ALL
SELECT @ListPageColumnConfigurationId,'CreateProtocolName','Created','Created',6,'Y',100,'N'
WHERE NOT EXISTS( SELECT 1
				  FROM dbo.ListPageColumnConfigurationColumns
				  WHERE FieldName = 'CreateProtocolName' and ListPageColumnConfigurationId 
				  in (SELECT LPCC.ListPageColumnConfigurationId
				  FROM dbo.ListPageColumnConfigurations LPCC 
				  WHERE ScreenId = @ScreenId 
				  AND ISNULL(RecordDeleted,'N')='N') 
				  AND ISNULL(RecordDeleted,'N')='N'
				  )
UNION ALL
SELECT @ListPageColumnConfigurationId,'Programs','Programs','Programs',7,'Y',100,'N'
WHERE NOT EXISTS( SELECT 1
				  FROM dbo.ListPageColumnConfigurationColumns
				  WHERE FieldName = 'Programs' and ListPageColumnConfigurationId 
				  in (SELECT LPCC.ListPageColumnConfigurationId
				  FROM dbo.ListPageColumnConfigurations LPCC 
				  WHERE ScreenId = @ScreenId 
				  AND ISNULL(RecordDeleted,'N')='N') 
				  AND ISNULL(RecordDeleted,'N')='N'
				  )
UNION ALL
SELECT @ListPageColumnConfigurationId,'Roles','Roles','Roles',8,'Y',100,'N'
WHERE NOT EXISTS( SELECT 1
				  FROM dbo.ListPageColumnConfigurationColumns
				  WHERE FieldName = 'Roles' and ListPageColumnConfigurationId 
				  in (SELECT LPCC.ListPageColumnConfigurationId
				  FROM dbo.ListPageColumnConfigurations LPCC 
				  WHERE ScreenId = @ScreenId 
				  AND ISNULL(RecordDeleted,'N')='N') 
				  AND ISNULL(RecordDeleted,'N')='N'
				  )
