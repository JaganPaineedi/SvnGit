/********************************************************************************                                                   
--  
-- Copyright: Streamline Healthcare Solutions  
-- "Locations List Page"
-- Purpose:  
--  
-- Author:  Neha
-- Date:    21-Aug-2018
--  
-- *****History****  
   Date				Author			Description                    
   21-Aug-2018		Neha			Engineering Improvement Initiatives- NBL(I)-#667                    
*********************************************************************************/

DECLARE @ListPageColumnConfigurationId INT
DECLARE @ScreenId INT = 306

IF NOT EXISTS(SELECT * FROM ListPageColumnConfigurations WHERE ScreenId = @ScreenId AND ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
	INSERT INTO ListPageColumnConfigurations(ScreenId, ViewName, Active, DefaultView, Template)
	VALUES(@ScreenId, 'Original', 'Y', 'Y', 'Y')

SELECT @ListPageColumnConfigurationId = ListPageColumnConfigurationId
FROM dbo.ListPageColumnConfigurations
WHERE ScreenId = @ScreenId
AND ISNULL(RecordDeleted,'N')='N'


--------------------------------------------ListPageColumnConfigurationColumns-----------------------------------------------

INSERT INTO dbo.ListPageColumnConfigurationColumns (ListPageColumnConfigurationId, FieldName, Caption, DisplayAs, SortOrder, ShowColumn, Width, Fixed )
SELECT @ListPageColumnConfigurationId,'LocationName','Location Name','Location Name',1,'Y',200,'Y'
UNION ALL 
SELECT @ListPageColumnConfigurationId,'LocationCode','Location Code','Location Code',20,'Y',150,'Y'
UNION ALL 
SELECT @ListPageColumnConfigurationId,'LocationAddress','Address','Address',30,'Y',100,'Y'
UNION ALL 
SELECT @ListPageColumnConfigurationId,'LocationPhone','Phone','Phone',40,'Y',100,'Y'
UNION ALL 
SELECT @ListPageColumnConfigurationId,'LabLocation','Lab Location','Lab Location',50,'Y',50,'Y'

END