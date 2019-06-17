/********************************************************************************                                                   
--  
-- Copyright: Streamline Healthcare Solutions  
-- "Psychiatric Note Service Note"
-- Purpose: Global Code Entries to Bind Drop Down for for Task #10 - Camino - Customizations.
--  
-- Author:  Lakshmi Kanth
-- Date:    13-11-2015
--  
-- *****History****  
*********************************************************************************/
--Severity---
IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XPSYCHEVALSEVERITY' AND Category = 'XPSYCHEVALSEVERITY')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('XPSYCHEVALSEVERITY','XPSYCHEVALSEVERITY','Y','Y','Y','Y','Camino - Customization','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XPSYCHEVALSEVERITY' ,CategoryName = 'XPSYCHEVALSEVERITY',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'Camino - Customization',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XPSYCHEVALSEVERITY' AND Category = 'XPSYCHEVALSEVERITY'
END

DELETE FROM GlobalCodes WHERE Category = 'XPSYCHEVALSEVERITY'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES 
('XPSYCHEVALSEVERITY','None','Camino - Customization','Y','N',1),
('XPSYCHEVALSEVERITY','Mild','Camino - Customization','Y','N',2),
('XPSYCHEVALSEVERITY','Moderate','Camino - Customization','Y','N',3),
('XPSYCHEVALSEVERITY','Severe','Camino - Customization','Y','N',4)

--Duration---
IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XPSYCHEVALDURATION' AND Category = 'XPSYCHEVALDURATION')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('XPSYCHEVALDURATION','XPSYCHEVALDURATION','Y','Y','Y','Y','Camino - Customization','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XPSYCHEVALDURATION' ,CategoryName = 'XPSYCHEVALDURATION',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'Camino - Customization',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XPSYCHEVALDURATION' AND Category = 'XPSYCHEVALDURATION'
END

DELETE FROM GlobalCodes WHERE Category = 'XPSYCHEVALDURATION'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('XPSYCHEVALDURATION','Less than a day','Camino - Customization','Y','N',1),
('XPSYCHEVALDURATION','1-7 days','Camino - Customization','Y','N',2),
('XPSYCHEVALDURATION','7-30 days','Camino - Customization','Y','N',3),
('XPSYCHEVALDURATION','1-3 months','Camino - Customization','Y','N',4),
('XPSYCHEVALDURATION','3-6 months','Camino - Customization','Y','N',5),
('XPSYCHEVALDURATION','More than 3 months','Camino - Customization','Y','N',6),
('XPSYCHEVALDURATION','4-8 hours','Camino - Customization','Y','N',7)


--Intensity---
IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XPSYCHEVALINTENSITY' AND Category = 'XPSYCHEVALINTENSITY')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('XPSYCHEVALINTENSITY','XPSYCHEVALINTENSITY','Y','Y','Y','Y','Camino - Customization','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XPSYCHEVALINTENSITY' ,CategoryName = 'XPSYCHEVALINTENSITY',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'Valley - Customizations #954',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XPSYCHEVALINTENSITY' AND Category = 'XPSYCHEVALINTENSITY'
END

DELETE FROM GlobalCodes WHERE Category = 'XPSYCHEVALINTENSITY'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('XPSYCHEVALINTENSITY','0(None)','Camino - Customization','Y','N',1),
('XPSYCHEVALINTENSITY','1','Camino - Customization','Y','N',2),
('XPSYCHEVALINTENSITY','2','Camino - Customization','Y','N',3),
('XPSYCHEVALINTENSITY','3','Camino - Customization','Y','N',4),
('XPSYCHEVALINTENSITY','4','Camino - Customization','Y','N',5),
('XPSYCHEVALINTENSITY','5','Camino - Customization','Y','N',6),
('XPSYCHEVALINTENSITY','6','Camino - Customization','Y','N',7),
('XPSYCHEVALINTENSITY','7','Camino - Customization','Y','N',8),
('XPSYCHEVALINTENSITY','8','Camino - Customization','Y','N',9),
('XPSYCHEVALINTENSITY','9','Camino - Customization','Y','N',10),
('XPSYCHEVALINTENSITY','10(Severe)','Camino - Customization','Y','N',11)

--Type of Problem--
IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XPROBLEMTYPE' AND Category = 'XPROBLEMTYPE')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('XPROBLEMTYPE','XPROBLEMTYPE','Y','Y','Y','Y','Camino - Customization - Psychiatric Notes','N','N','Y')
END

DELETE FROM GlobalCodes WHERE Category = 'XPROBLEMTYPE'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('XPROBLEMTYPE','Acute','Camino - Customization - Psychiatric Notes','Y','Y',1),
('XPROBLEMTYPE','Chronic','Camino - Customization - Psychiatric Notes','Y','Y',2)


--Insert script GlobalCodeCategories xAIMSMovements


IF(NOT EXISTS(SELECT Category FROM GlobalCodeCategories WHERE CATEGORY='xAIMSMovements'))
BEGIN
	INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory,HasSubcodes) 
	VALUES('xAIMSMovements','xAIMSMovements','Y','Y','Y','Y','Y','N')
END

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='xAIMSMovements' AND CodeName= '0 = None' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('xAIMSMovements','0 = None',0,'Y','N',1)
END

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='xAIMSMovements' AND CodeName= '1 = Minimal, maybe extreme normal' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('xAIMSMovements','1 = Minimal, maybe extreme normal',1,'Y','N',2)
END

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='xAIMSMovements' AND CodeName= '2 = Mild' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('xAIMSMovements','2 = Mild',2,'Y','N',3)
END

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='xAIMSMovements' AND CodeName= '3 = Moderate' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('xAIMSMovements','3 = Moderate',3,'Y','N',4)
END

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='xAIMSMovements' AND CodeName= '4 = Severe' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('xAIMSMovements','4 = Severe',4,'Y','N',5)
END

--Insert script GlobalCodeCategories xAIMSJudgments1


IF(NOT EXISTS(SELECT Category FROM GlobalCodeCategories WHERE CATEGORY='xAIMSJudgments1'))
BEGIN
	INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory,HasSubcodes) 
	VALUES('xAIMSJudgments1','xAIMSJudgments1','Y','Y','Y','Y','Y','N')
END

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='xAIMSJudgments1' AND CodeName= '0 = None, Normal' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('xAIMSJudgments1','0 = None, Normal',0,'Y','N',1)
END

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='xAIMSJudgments1' AND CodeName= '1 = Minimal' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('xAIMSJudgments1','1 = Minimal',1,'Y','N',2)
END

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='xAIMSJudgments1' AND CodeName= '2 = Mild' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('xAIMSJudgments1','2 = Mild',2,'Y','N',3)
END

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='xAIMSJudgments1' AND CodeName= '3 = Moderate' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('xAIMSJudgments1','3 = Moderate',3,'Y','N',4)
END

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='xAIMSJudgments1' AND CodeName= '4 = Severe' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('xAIMSJudgments1','4 = Severe',4,'Y','N',5)
END



--Insert script GlobalCodeCategories xAIMSJudgments2


IF(NOT EXISTS(SELECT Category FROM GlobalCodeCategories WHERE CATEGORY='xAIMSJudgments2'))
BEGIN
	INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory,HasSubcodes) 
	VALUES('xAIMSJudgments2','xAIMSJudgments2','Y','Y','Y','Y','Y','N')
END

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='xAIMSJudgments2' AND CodeName= '0 = No awareness' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('xAIMSJudgments2','0 = No awareness',0,'Y','N',1)
END

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='xAIMSJudgments2' AND CodeName= '1 = Aware, no distress' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('xAIMSJudgments2','1 = Aware, no distress',1,'Y','N',2)
END

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='xAIMSJudgments2' AND CodeName= '2 = Aware, mild distress')) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('xAIMSJudgments2','2 = Aware, mild distress',2,'Y','N',3)
END

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='xAIMSJudgments2' AND CodeName= '3 = Aware, moderate distress' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('xAIMSJudgments2','3 = Aware, moderate distress',3,'Y','N',4)
END

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='xAIMSJudgments2' AND CodeName= '4 = Aware, severe distress' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('xAIMSJudgments2','4 = Aware, severe distress',4,'Y','N',5)
END	



----Insert script GlobalCodeCategories XFrequency
IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XFrequency' AND Category = 'XFrequency')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('XFrequency','XFrequency','Y','Y','Y','Y','Camino - Customization','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XFrequency' ,CategoryName = 'XFrequency',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'Camino - Customization',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XFrequency' AND Category = 'XFrequency'
END

DELETE FROM GlobalCodes WHERE Category = 'XFrequency'



----Insert script GlobalCodeCategories XFrequency


IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='XFrequency' AND CodeName= 'Weekly' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('XFrequency','Weekly',1,'Y','N',2)
END

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='XFrequency' AND CodeName= 'Bi-weekly')) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('XFrequency','Bi-weekly',2,'Y','N',3)
END

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='XFrequency' AND CodeName= 'Twice a week' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('XFrequency','Twice a week',3,'Y','N',4)
END

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='XFrequency' AND CodeName= 'Daily' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('XFrequency','Daily',4,'Y','N',5)
END

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='XFrequency' AND CodeName= 'other' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('XFrequency','other',5,'Y','N',6)
END

----Insert script GlobalCodeCategories XDecessionMaking
IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XDecessionMaking' AND Category = 'XDecessionMaking')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('XDecessionMaking','XDecessionMaking','Y','Y','Y','Y','Camino - Customization','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XDecessionMaking' ,CategoryName = 'XDecessionMaking',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'Camino - Customization',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XDecessionMaking' AND Category = 'XDecessionMaking'
END

DELETE FROM GlobalCodes WHERE Category = 'XDecessionMaking'

----Insert script GlobalCodeCategories XDecessionMaking

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='XDecessionMaking' AND CodeName= 'Stable' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('XDecessionMaking','Stable',1,'Y','N',2)
END

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='XDecessionMaking' AND CodeName= 'Worsening')) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('XDecessionMaking','Worsening',2,'Y','N',3)
END

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='XDecessionMaking' AND CodeName= 'Improving' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('XDecessionMaking','Improving',3,'Y','N',4)
END

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='XDecessionMaking' AND CodeName= 'New' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('XDecessionMaking','New',4,'Y','N',5)
END

IF(NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='XDecessionMaking' AND CodeName= 'Resolved' )) 
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('XDecessionMaking','Resolved',5,'Y','N',6)
END


