/********************************************************************************                                                   
--  
-- Copyright: Streamline Healthcare Solutions  
-- "Orders List Page"
-- Purpose:  
--  
-- Author:  Neha
-- Date:    18-Jul-2018
--  
-- *****History****  
   Date				Author			Description                    
   18/Jul/2018		Neha			Engineering Improvement Initiatives- NBL(I)-#694  
   21/Sept/2018     Neha            Added a new column called Laboratories.Engineering Improvement Initiatives- NBL(I)-#716                     
*********************************************************************************/

DECLARE @ListPageColumnConfigurationId INT
DECLARE @ScreenId INT = 901

	INSERT INTO ListPageColumnConfigurations(ScreenId, ViewName, Active, DefaultView, Template)
	SELECT @ScreenId, 'Original', 'Y', 'Y', 'Y'
	WHERE NOT EXISTS(SELECT * FROM ListPageColumnConfigurations WHERE ScreenId = @ScreenId AND ISNULL(RecordDeleted, 'N') = 'N')

SELECT @ListPageColumnConfigurationId = ListPageColumnConfigurationId
FROM dbo.ListPageColumnConfigurations
WHERE ScreenId = @ScreenId
AND ISNULL(RecordDeleted,'N')='N'


--------------------------------------------ListPageColumnConfigurationColumns-----------------------------------------------

INSERT INTO dbo.ListPageColumnConfigurationColumns (ListPageColumnConfigurationId, FieldName, Caption, DisplayAs, SortOrder, ShowColumn, Width, Fixed )
SELECT @ListPageColumnConfigurationId,'OrderName','Order Name','Order Name',1,'Y',200,'Y'
Where NOT EXISTS(SELECT 1 FROM ListPageColumnConfigurationColumns WHERE ListPageColumnConfigurationId = @ListPageColumnConfigurationId AND FieldName = 'OrderName' AND ISNULL(RecordDeleted, 'N') = 'N')
UNION ALL 
SELECT @ListPageColumnConfigurationId,'OrderType','Order Type','Order Type',20,'Y',150,'Y'
Where NOT EXISTS(SELECT 1 FROM ListPageColumnConfigurationColumns WHERE ListPageColumnConfigurationId = @ListPageColumnConfigurationId AND FieldName = 'OrderType' AND ISNULL(RecordDeleted, 'N') = 'N')
UNION ALL 
SELECT @ListPageColumnConfigurationId,'Active','Active','Active',30,'Y',100,'Y'
Where NOT EXISTS(SELECT 1 FROM ListPageColumnConfigurationColumns WHERE ListPageColumnConfigurationId = @ListPageColumnConfigurationId AND FieldName = 'Active' AND ISNULL(RecordDeleted, 'N') = 'N')
UNION ALL 
SELECT @ListPageColumnConfigurationId,'AdhocOrder','Adhoc Order','Adhoc Order',40,'Y',100,'Y'
Where NOT EXISTS(SELECT 1 FROM ListPageColumnConfigurationColumns WHERE ListPageColumnConfigurationId = @ListPageColumnConfigurationId AND FieldName = 'AdhocOrder' AND ISNULL(RecordDeleted, 'N') = 'N')
UNION ALL 
SELECT @ListPageColumnConfigurationId,'CreatedBy','Created By','Created By',50,'Y',200,'Y'
Where NOT EXISTS(SELECT 1 FROM ListPageColumnConfigurationColumns WHERE ListPageColumnConfigurationId = @ListPageColumnConfigurationId AND FieldName = 'CreatedBy' AND ISNULL(RecordDeleted, 'N') = 'N')
UNION ALL
SELECT @ListPageColumnConfigurationId,'Laboratory','Laboratory','Laboratory',60,'Y',200,'Y'
Where NOT EXISTS(SELECT 1 FROM ListPageColumnConfigurationColumns WHERE ListPageColumnConfigurationId = @ListPageColumnConfigurationId AND FieldName = 'Laboratory' AND ISNULL(RecordDeleted, 'N') = 'N')