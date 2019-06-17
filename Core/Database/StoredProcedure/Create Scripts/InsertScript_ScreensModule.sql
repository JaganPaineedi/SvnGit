INSERT INTO Modules (ModuleName)
SELECT 'DocumentValidations'
WHERE NOT EXISTS (
		SELECT 1
		FROM Modules AS m
		WHERE m.ModuleName = 'DocumentValidations'
			AND ISNULL(m.RecordDeleted, 'N') = 'N'
		)

DECLARE @ModuleId INT;

SELECT @ModuleId = m.ModuleId
FROM Modules AS m
WHERE m.ModuleName = 'DocumentValidations'
	AND ISNULL(m.RecordDeleted, 'N') = 'N'

DECLARE @ScreenId INT = 2263;
set identity_insert dbo.Screens on
INSERT INTO Screens (
	ScreenId
	,ScreenName
	,ScreenType
	,ScreenURL
	,ScreenToolbarURL
	,TabId
	,Code
	)
SELECT @ScreenId
     ,'Document Validations'
	,5762
	,'Modules/DocumentValidations/WebPages/DocumentValidations.ascx'
	,'Modules/DocumentValidations/WebPages/DocumentValidationsToolBar.ascx'
	,4
	,'DocumentValidationList'
WHERE NOT EXISTS (
		SELECT 1
		FROM Screens AS a
		WHERE ISNULL(a.RecordDeleted, 'N') = 'N'
			AND a.ScreenId = @ScreenId
		)
		
set identity_insert dbo.Screens off

INSERT INTO ModuleScreens (
	ModuleId
	,ScreenId
	)
SELECT @ModuleId
	,@ScreenId
WHERE NOT EXISTS (
		SELECT 1
		FROM ModuleScreens AS ms
		WHERE ISNULL(ms.RecordDeleted, 'N') = 'N'
			AND ms.ModuleId = @ModuleId
			AND ms.ScreenId = @ScreenId
		)
insert into Banners(BannerName,DisplayAs,Active,DefaultOrder,[Custom],TabId,ScreenId)
select 'Document Validations','Document Validations','Y',9999,'N',4,@ScreenId
where not exists ( select 1
				from Banners as b
				where ISNULL(b.RecordDeleted,'N')='N'
				and b.ScreenId = @ScreenId
				)


DECLARE @ListPageColumnConfigurationId INT;
--Create the Template View Records
INSERT INTO dbo.ListPageColumnConfigurations (  ScreenId, StaffId, ViewName, Active, DefaultView, Template )
SELECT @ScreenId,
NULL, --StaffId is not currently being used, it may in the future
'Original', --Must be Original
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
SELECT @ListPageColumnConfigurationId,'DocumentName','Document Name','Document Name',1,'Y',250,'N'
where not exists (
select 1
	   from ListPageColumnConfigurationColumns as a
	   where a.ListPageColumnConfigurationId = @ListPageColumnConfigurationId
	   and a.FieldName = 'DocumentName'
	   and ISNULL(a.RecordDeleted,'N')='N'
	   )
UNION ALL 
SELECT @ListPageColumnConfigurationId,'Active','Active','Active',20,'Y',50,'N'where not exists (
select 1
	   from ListPageColumnConfigurationColumns as a
	   where a.ListPageColumnConfigurationId = @ListPageColumnConfigurationId
	   and a.FieldName = 'Active'
	   and ISNULL(a.RecordDeleted,'N')='N'
	   )
UNION ALL 
SELECT @ListPageColumnConfigurationId,'ServiceNote','Service Note','Service Note',30,'Y',75,'N'where not exists (
select 1
	   from ListPageColumnConfigurationColumns as a
	   where a.ListPageColumnConfigurationId = @ListPageColumnConfigurationId
	   and a.FieldName = 'ServiceNote'
	   and ISNULL(a.RecordDeleted,'N')='N'
	   )
UNION ALL 
SELECT @ListPageColumnConfigurationId,'ValidationDescription','Description','Description',40,'Y',400,'N'where not exists (
select 1
	   from ListPageColumnConfigurationColumns as a
	   where a.ListPageColumnConfigurationId = @ListPageColumnConfigurationId
	   and a.FieldName = 'ValidationDescription'
	   and ISNULL(a.RecordDeleted,'N')='N'
	   )
UNION ALL 
SELECT @ListPageColumnConfigurationId,'ErrorMessage','Error Message','Error Message',50,'Y',400,'N'where not exists (
select 1
	   from ListPageColumnConfigurationColumns as a
	   where a.ListPageColumnConfigurationId = @ListPageColumnConfigurationId
	   and a.FieldName = 'ErrorMessage'
	   and ISNULL(a.RecordDeleted,'N')='N'
	   )
UNION ALL 
SELECT @ListPageColumnConfigurationId,'Manual','Manual','Manual',60,'Y',75,'N'where not exists (
select 1
	   from ListPageColumnConfigurationColumns as a
	   where a.ListPageColumnConfigurationId = @ListPageColumnConfigurationId
	   and a.FieldName = 'Manual'
	   and ISNULL(a.RecordDeleted,'N')='N'
	   )
UNION ALL 
SELECT @ListPageColumnConfigurationId,'Order','Order','Order',70,'Y',40,'N'where not exists (
select 1
	   from ListPageColumnConfigurationColumns as a
	   where a.ListPageColumnConfigurationId = @ListPageColumnConfigurationId
	   and a.FieldName = 'Order'
	   and ISNULL(a.RecordDeleted,'N')='N'
	   )
UNION ALL 
SELECT @ListPageColumnConfigurationId,'ChangeOrder','ChangeOrder','Reorder',80,'Y',50,'N'where not exists (
select 1
	   from ListPageColumnConfigurationColumns as a
	   where a.ListPageColumnConfigurationId = @ListPageColumnConfigurationId
	   and a.FieldName = 'ChangeOrder'
	   and ISNULL(a.RecordDeleted,'N')='N'
	   )

/*
select * from screens order by 1 desc
select * From globalcodes where category like '%screen%'
*/
set @ScreenId = 2264;

set identity_insert dbo.Screens on
INSERT INTO Screens (
	ScreenId
	,ScreenName
	,ScreenType
	,ScreenURL
	,ScreenToolbarURL
	,TabId
	,Code
	,InitializationStoredProcedure
	)
SELECT @ScreenId
     ,'Document Validation'
	,5761
	,'Modules/DocumentValidations/WebPages/DocumentValidation.ascx'
	,NULL
	,4
	,'DocumentValidationDetail'
	,null
WHERE NOT EXISTS (
		SELECT 1
		FROM Screens AS a
		WHERE ISNULL(a.RecordDeleted, 'N') = 'N'
			AND a.ScreenId = @ScreenId
		)
set identity_insert dbo.Screens off

INSERT INTO ModuleScreens (
	ModuleId
	,ScreenId
	)
SELECT @ModuleId
	,@ScreenId
WHERE NOT EXISTS (
		SELECT 1
		FROM ModuleScreens AS ms
		WHERE ISNULL(ms.RecordDeleted, 'N') = 'N'
			AND ms.ModuleId = @ModuleId
			AND ms.ScreenId = @ScreenId
		)

set @ScreenId = 2265;

set identity_insert dbo.Screens on
INSERT INTO Screens (
	ScreenId
	,ScreenName
	,ScreenType
	,ScreenURL
	,ScreenToolbarURL
	,TabId
	,Code
	,InitializationStoredProcedure
	)
SELECT @ScreenId
     ,'Document Validation Import Export'
	,5765
	,'Modules/DocumentValidations/WebPages/DocumentValidationImportExport.ascx'
	,NULL
	,4
	,'DocumentValidationImportExport'
	,null
WHERE NOT EXISTS (
		SELECT 1
		FROM Screens AS a
		WHERE ISNULL(a.RecordDeleted, 'N') = 'N'
			AND a.ScreenId = @ScreenId
		)
set identity_insert dbo.Screens off

INSERT INTO ModuleScreens (
	ModuleId
	,ScreenId
	)
SELECT @ModuleId
	,@ScreenId
WHERE NOT EXISTS (
		SELECT 1
		FROM ModuleScreens AS ms
		WHERE ISNULL(ms.RecordDeleted, 'N') = 'N'
			AND ms.ModuleId = @ModuleId
			AND ms.ScreenId = @ScreenId
		)