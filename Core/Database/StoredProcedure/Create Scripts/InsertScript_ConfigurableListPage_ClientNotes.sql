--Get the screen Id
DECLARE @ScreenId INT

SELECT  @ScreenId = ScreenId
FROM Screens 
WHERE ScreenName = 'Client Flags' AND ScreenType=5762 AND TabId=1 AND ISNULL(RecordDeleted,'N')='N'

DECLARE @ListPageColumnConfigurationId INT;
--Create the Template View Records
INSERT INTO dbo.ListPageColumnConfigurations (  ScreenId, StaffId, ViewName, Active, DefaultView, Template )
SELECT @ScreenId,
NULL, --StaffId is not currently being used, it may in the future
'Client Notes Original', --Must be Original
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
SELECT @ListPageColumnConfigurationId,'ClientId','ClientId','ClientId',1,'Y',50,'N'
WHERE NOT EXISTS( SELECT 1
				  FROM dbo.ListPageColumnConfigurationColumns
				  WHERE FieldName = 'ClientId' and ListPageColumnConfigurationId 
				  in (SELECT LPCC.ListPageColumnConfigurationId
				  FROM dbo.ListPageColumnConfigurations LPCC 
				  WHERE ScreenId = @ScreenId 
				  AND ISNULL(RecordDeleted,'N')='N') 
				  AND ISNULL(RecordDeleted,'N')='N'
				  )
UNION ALL 
SELECT @ListPageColumnConfigurationId,'ClientName','Client Name','Client Name',2,'Y',150,'N'
WHERE NOT EXISTS( SELECT 1
				  FROM dbo.ListPageColumnConfigurationColumns
				  WHERE FieldName = 'ClientName' and ListPageColumnConfigurationId 
				  in (SELECT LPCC.ListPageColumnConfigurationId
				  FROM dbo.ListPageColumnConfigurations LPCC 
				  WHERE ScreenId = @ScreenId 
				  AND ISNULL(RecordDeleted,'N')='N') 
				  AND ISNULL(RecordDeleted,'N')='N'
				  )
UNION ALL 
SELECT @ListPageColumnConfigurationId,'NoteTypeName','Flag','Flag',3,'Y',100,'N'
WHERE NOT EXISTS( SELECT 1
				  FROM dbo.ListPageColumnConfigurationColumns
				  WHERE FieldName = 'NoteTypeName' and ListPageColumnConfigurationId 
				  in (SELECT LPCC.ListPageColumnConfigurationId
				  FROM dbo.ListPageColumnConfigurations LPCC 
				  WHERE ScreenId = @ScreenId 
				  AND ISNULL(RecordDeleted,'N')='N') 
				  AND ISNULL(RecordDeleted,'N')='N'
				  )
UNION ALL 
SELECT @ListPageColumnConfigurationId,'AssignedTo','Assigned Staff','Assigned Staff',4,'Y',150,'N'
WHERE NOT EXISTS( SELECT 1
				  FROM dbo.ListPageColumnConfigurationColumns
				  WHERE FieldName = 'AssignedTo' and ListPageColumnConfigurationId 
				  in (SELECT LPCC.ListPageColumnConfigurationId
				  FROM dbo.ListPageColumnConfigurations LPCC 
				  WHERE ScreenId = @ScreenId 
				  AND ISNULL(RecordDeleted,'N')='N') 
				  AND ISNULL(RecordDeleted,'N')='N'
				  )
UNION ALL 
SELECT @ListPageColumnConfigurationId,'OpenDate','Open Date','Open Date',5,'Y',100,'N'
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
SELECT @ListPageColumnConfigurationId,'StartDate','Start Date','Start Date',6,'Y',100,'N'
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
SELECT @ListPageColumnConfigurationId,'DueDate','Due Date','Due Date',7,'Y',100,'N'
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
SELECT @ListPageColumnConfigurationId,'DocumentName','Link To','Link To',8,'Y',150,'N'
WHERE NOT EXISTS( SELECT 1
				  FROM dbo.ListPageColumnConfigurationColumns
				  WHERE FieldName = 'DocumentName' and ListPageColumnConfigurationId 
				  in (SELECT LPCC.ListPageColumnConfigurationId
				  FROM dbo.ListPageColumnConfigurations LPCC 
				  WHERE ScreenId = @ScreenId 
				  AND ISNULL(RecordDeleted,'N')='N') 
				  AND ISNULL(RecordDeleted,'N')='N'
				  )
UNION ALL
SELECT @ListPageColumnConfigurationId,'ClientNoteId','','ClientNote Id',9,'Y',30,'N'
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
SELECT @ListPageColumnConfigurationId,'EndDate','Completed Date','Completed Date',10,'Y',90,'N'
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
SELECT @ListPageColumnConfigurationId,'CompletedBy','Completed By','Completed By',11,'Y',100,'N'
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
SELECT @ListPageColumnConfigurationId,'Note','Note Field','Note Field',12,'Y',100,'N'
WHERE NOT EXISTS( SELECT 1
				  FROM dbo.ListPageColumnConfigurationColumns
				  WHERE FieldName = 'Note' and ListPageColumnConfigurationId 
				  in (SELECT LPCC.ListPageColumnConfigurationId
				  FROM dbo.ListPageColumnConfigurations LPCC 
				  WHERE ScreenId = @ScreenId 
				  AND ISNULL(RecordDeleted,'N')='N') 
				  AND ISNULL(RecordDeleted,'N')='N'
				  )
UNION ALL
SELECT @ListPageColumnConfigurationId,'AssignedRoles','Assigned Roles','Assigned Roles',13,'Y',150,'N'
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
SELECT @ListPageColumnConfigurationId,'Protocol','Protocol','Protocol',14,'Y',100,'N'
WHERE NOT EXISTS( SELECT 1
				  FROM dbo.ListPageColumnConfigurationColumns
				  WHERE FieldName = 'Protocol' and ListPageColumnConfigurationId 
				  in (SELECT LPCC.ListPageColumnConfigurationId
				  FROM dbo.ListPageColumnConfigurations LPCC 
				  WHERE ScreenId = @ScreenId 
				  AND ISNULL(RecordDeleted,'N')='N') 
				  AND ISNULL(RecordDeleted,'N')='N'
				  )
UNION ALL
SELECT @ListPageColumnConfigurationId,'WorkGroupName','Work Group','Work Group',15,'Y',100,'N'
WHERE NOT EXISTS( SELECT 1
				  FROM dbo.ListPageColumnConfigurationColumns
				  WHERE FieldName = 'WorkGroupName' and ListPageColumnConfigurationId 
				  in (SELECT LPCC.ListPageColumnConfigurationId
				  FROM dbo.ListPageColumnConfigurations LPCC 
				  WHERE ScreenId = @ScreenId 
				  AND ISNULL(RecordDeleted,'N')='N') 
				  AND ISNULL(RecordDeleted,'N')='N'
				  )
