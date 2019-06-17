--Get the screen Id
DECLARE @ScreenId INT

SELECT  @ScreenId = ScreenId
FROM Screens 
WHERE ScreenName = 'Client Tracking' AND ScreenType=5762 AND TabId=2 AND ISNULL(RecordDeleted,'N')='N'

--select @screenid
DECLARE @ListPageColumnConfigurationId INT;
--Create the Template View Records
INSERT INTO dbo.ListPageColumnConfigurations (  ScreenId, StaffId, ViewName, Active, DefaultView, Template )
SELECT @ScreenId,
NULL, --StaffId is not currently being used, it may in the future
'Client Tracking Original', --Must be Original
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
SELECT @ListPageColumnConfigurationId,'FlagType','Flag','Flag',1,'Y',100,'N'
WHERE NOT EXISTS( SELECT 1
				  FROM dbo.ListPageColumnConfigurationColumns
				  WHERE FieldName = 'FlagType' and ListPageColumnConfigurationId 
				  in (SELECT LPCC.ListPageColumnConfigurationId
				  FROM dbo.ListPageColumnConfigurations LPCC 
				  WHERE ScreenId = @ScreenId 
				  AND ISNULL(RecordDeleted,'N')='N') 
				  AND ISNULL(RecordDeleted,'N')='N'
				  )
UNION ALL 
SELECT @ListPageColumnConfigurationId,'AssignedStaff','Assigned Staff','Assigned Staff',2,'Y',150,'N'
WHERE NOT EXISTS( SELECT 1
				  FROM dbo.ListPageColumnConfigurationColumns
				  WHERE FieldName = 'AssignedStaff' and ListPageColumnConfigurationId 
				  in (SELECT LPCC.ListPageColumnConfigurationId
				  FROM dbo.ListPageColumnConfigurations LPCC 
				  WHERE ScreenId = @ScreenId 
				  AND ISNULL(RecordDeleted,'N')='N') 
				  AND ISNULL(RecordDeleted,'N')='N'
				  )
UNION ALL 
SELECT @ListPageColumnConfigurationId,'OpenDate','Open Date','Open Date',3,'Y',70,'N'
WHERE NOT EXISTS( SELECT 1
				  FROM dbo.ListPageColumnConfigurationColumns
				  WHERE FieldName = 'OpenDate' and ListPageColumnConfigurationId 
				  in (SELECT LPCC.ListPageColumnConfigurationId
				  FROM dbo.ListPageColumnConfigurations LPCC 
				  WHERE ScreenId = @ScreenId 
				  AND ISNULL(RecordDeleted,'N')='N') 
				  AND ISNULL(RecordDeleted,'N')='N'
				  )
UNION ALL
SELECT @ListPageColumnConfigurationId,'StartDate','Start Date','Start Date',4,'Y',70,'N'
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
SELECT @ListPageColumnConfigurationId,'DueDate','Due Date','Due Date',5,'Y',70,'N'
WHERE NOT EXISTS( SELECT 1
				  FROM dbo.ListPageColumnConfigurationColumns
				  WHERE FieldName = 'DueDate' and ListPageColumnConfigurationId 
				  in (SELECT LPCC.ListPageColumnConfigurationId
				  FROM dbo.ListPageColumnConfigurations LPCC 
				  WHERE ScreenId = @ScreenId 
				  AND ISNULL(RecordDeleted,'N')='N') 
				  AND ISNULL(RecordDeleted,'N')='N'
				  )
UNION ALL
SELECT @ListPageColumnConfigurationId,'LinkTo','Link To','Link To',6,'Y',150,'N'
WHERE NOT EXISTS( SELECT 1
				  FROM dbo.ListPageColumnConfigurationColumns
				  WHERE FieldName = 'LinkTo' and ListPageColumnConfigurationId 
				  in (SELECT LPCC.ListPageColumnConfigurationId
				  FROM dbo.ListPageColumnConfigurations LPCC 
				  WHERE ScreenId = @ScreenId 
				  AND ISNULL(RecordDeleted,'N')='N') 
				  AND ISNULL(RecordDeleted,'N')='N'
				  )
UNION ALL
SELECT @ListPageColumnConfigurationId,'ClientNoteId','','ClientNote Id',7,'Y',30,'N'
WHERE NOT EXISTS( SELECT 1
				  FROM dbo.ListPageColumnConfigurationColumns
				  WHERE FieldName = 'ClientNoteId' and ListPageColumnConfigurationId 
				  in (SELECT LPCC.ListPageColumnConfigurationId
				  FROM dbo.ListPageColumnConfigurations LPCC 
				  WHERE ScreenId = @ScreenId 
				  AND ISNULL(RecordDeleted,'N')='N') 
				  AND ISNULL(RecordDeleted,'N')='N'
				  )
UNION ALL
SELECT @ListPageColumnConfigurationId,'CompletedDate','Completed Date','Completed Date',8,'Y',90,'N'
WHERE NOT EXISTS( SELECT 1
				  FROM dbo.ListPageColumnConfigurationColumns
				  WHERE FieldName = 'CompletedDate' and ListPageColumnConfigurationId 
				  in (SELECT LPCC.ListPageColumnConfigurationId
				  FROM dbo.ListPageColumnConfigurations LPCC 
				  WHERE ScreenId = @ScreenId 
				  AND ISNULL(RecordDeleted,'N')='N') 
				  AND ISNULL(RecordDeleted,'N')='N'
				  )
UNION ALL
SELECT @ListPageColumnConfigurationId,'CompletedBy','Completed By','Completed By',9,'Y',100,'N'
WHERE NOT EXISTS( SELECT 1
				  FROM dbo.ListPageColumnConfigurationColumns
				  WHERE FieldName = 'CompletedBy' and ListPageColumnConfigurationId 
				  in (SELECT LPCC.ListPageColumnConfigurationId
				  FROM dbo.ListPageColumnConfigurations LPCC 
				  WHERE ScreenId = @ScreenId 
				  AND ISNULL(RecordDeleted,'N')='N') 
				  AND ISNULL(RecordDeleted,'N')='N'
				  )
UNION ALL
SELECT @ListPageColumnConfigurationId,'NoteField','Note Field','Note Field',10,'Y',100,'N'
WHERE NOT EXISTS( SELECT 1
				  FROM dbo.ListPageColumnConfigurationColumns
				  WHERE FieldName = 'NoteField' and ListPageColumnConfigurationId 
				  in (SELECT LPCC.ListPageColumnConfigurationId
				  FROM dbo.ListPageColumnConfigurations LPCC 
				  WHERE ScreenId = @ScreenId 
				  AND ISNULL(RecordDeleted,'N')='N') 
				  AND ISNULL(RecordDeleted,'N')='N'
				  )
UNION ALL
SELECT @ListPageColumnConfigurationId,'AssignedRoles','Assigned Roles','Assigned Roles',11,'Y',150,'N'
WHERE NOT EXISTS( SELECT 1
				  FROM dbo.ListPageColumnConfigurationColumns
				  WHERE FieldName = 'AssignedRoles' and ListPageColumnConfigurationId 
				  in (SELECT LPCC.ListPageColumnConfigurationId
				  FROM dbo.ListPageColumnConfigurations LPCC 
				  WHERE ScreenId = @ScreenId 
				  AND ISNULL(RecordDeleted,'N')='N') 
				  AND ISNULL(RecordDeleted,'N')='N'
				  )
UNION ALL
SELECT @ListPageColumnConfigurationId,'ProtocolName','Protocol','Protocol',12,'Y',100,'N'
WHERE NOT EXISTS( SELECT 1
				  FROM dbo.ListPageColumnConfigurationColumns
				  WHERE FieldName = 'ProtocolName' and ListPageColumnConfigurationId 
				  in (SELECT LPCC.ListPageColumnConfigurationId
				  FROM dbo.ListPageColumnConfigurations LPCC 
				  WHERE ScreenId = @ScreenId 
				  AND ISNULL(RecordDeleted,'N')='N') 
				  AND ISNULL(RecordDeleted,'N')='N'
				  )

