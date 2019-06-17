/********************************************************************************                                                   
--  
-- Copyright: Streamline Healthcare Solutions  
-- "Psychiatric Evaluation Service Note"
-- Purpose: Global Code Entries to Bind Drop Down for for Task #822 - Woods - Customizations.
--  
-- Author:  Akwinass
-- Date:    06-JAN-2014
--  
-- *****History****  
*********************************************************************************/

--Severity---
IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XPSYCHEVALSEVERITY' AND Category = 'XPSYCHEVALSEVERITY')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('XPSYCHEVALSEVERITY','XPSYCHEVALSEVERITY','Y','Y','Y','Y','NDNW - Setup #4','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XPSYCHEVALSEVERITY' ,CategoryName = 'XPSYCHEVALSEVERITY',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'NDNW - Setup #4',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XPSYCHEVALSEVERITY' AND Category = 'XPSYCHEVALSEVERITY'
END

DELETE FROM GlobalCodes WHERE Category = 'XPSYCHEVALSEVERITY'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('XPSYCHEVALSEVERITY','Mild','NDNW - Setup #4','Y','N',1),
('XPSYCHEVALSEVERITY','Moderate','NDNW - Setup #4','Y','N',2),
('XPSYCHEVALSEVERITY','Severe','NDNW - Setup #4','Y','N',3)


--Duration---
IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XPSYCHEVALDURATION' AND Category = 'XPSYCHEVALDURATION')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('XPSYCHEVALDURATION','XPSYCHEVALDURATION','Y','Y','Y','Y','NDNW - Setup #4','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XPSYCHEVALDURATION' ,CategoryName = 'XPSYCHEVALDURATION',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'NDNW - Setup #4',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XPSYCHEVALDURATION' AND Category = 'XPSYCHEVALDURATION'
END

DELETE FROM GlobalCodes WHERE Category = 'XPSYCHEVALDURATION'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('XPSYCHEVALDURATION','Seconds','NDNW - Setup #4','Y','N',1),
('XPSYCHEVALDURATION','Few minutes','NDNW - Setup #4','Y','N',2),
('XPSYCHEVALDURATION','15-30 minutes','NDNW - Setup #4','Y','N',3),
('XPSYCHEVALDURATION','30-60 minutes','NDNW - Setup #4','Y','N',4),
('XPSYCHEVALDURATION','1 hour','NDNW - Setup #4','Y','N',5),
('XPSYCHEVALDURATION','2-3 hours','NDNW - Setup #4','Y','N',6),
('XPSYCHEVALDURATION','4-8 hours','NDNW - Setup #4','Y','N',7),
('XPSYCHEVALDURATION','9-12 hours','NDNW - Setup #4','Y','N',8),
('XPSYCHEVALDURATION','12-24 hours','NDNW - Setup #4','Y','N',9),
('XPSYCHEVALDURATION','1-2 days','NDNW - Setup #4','Y','N',10),
('XPSYCHEVALDURATION','3-5 days','NDNW - Setup #4','Y','N',11),
('XPSYCHEVALDURATION','5-7 days','NDNW - Setup #4','Y','N',12),
('XPSYCHEVALDURATION','< week','NDNW - Setup #4','Y','N',13),
('XPSYCHEVALDURATION','1-2 weeks','NDNW - Setup #4','Y','N',14),
('XPSYCHEVALDURATION','2-3 weeks','NDNW - Setup #4','Y','N',15),
('XPSYCHEVALDURATION','3-4 weeks','NDNW - Setup #4','Y','N',16),
('XPSYCHEVALDURATION','1-2 months','NDNW - Setup #4','Y','N',17),
('XPSYCHEVALDURATION','2-3 months','NDNW - Setup #4','Y','N',18),
('XPSYCHEVALDURATION','4-6 months','NDNW - Setup #4','Y','N',19),
('XPSYCHEVALDURATION','More than 6 months','NDNW - Setup #4','Y','N',20)

--Intensity---
IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XPSYCHEVALINTENSITY' AND Category = 'XPSYCHEVALINTENSITY')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('XPSYCHEVALINTENSITY','XPSYCHEVALINTENSITY','Y','Y','Y','Y','NDNW - Setup #4','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XPSYCHEVALINTENSITY' ,CategoryName = 'XPSYCHEVALINTENSITY',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'NDNW - Setup #4',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XPSYCHEVALINTENSITY' AND Category = 'XPSYCHEVALINTENSITY'
END

DELETE FROM GlobalCodes WHERE Category = 'XPSYCHEVALINTENSITY'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('XPSYCHEVALINTENSITY','Throbbing','NDNW - Setup #4','Y','N',1),
('XPSYCHEVALINTENSITY','Pulsating','NDNW - Setup #4','Y','N',2),
('XPSYCHEVALINTENSITY','Stabbing','NDNW - Setup #4','Y','N',3),
('XPSYCHEVALINTENSITY','Squeezing','NDNW - Setup #4','Y','N',4),
('XPSYCHEVALINTENSITY','Dull','NDNW - Setup #4','Y','N',5),
('XPSYCHEVALINTENSITY','Sharp','NDNW - Setup #4','Y','N',6)


--Associated Signs/Symptoms---
IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XPSYCHEVALSYMPTOMS' AND Category = 'XPSYCHEVALSYMPTOMS')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('XPSYCHEVALSYMPTOMS','XPSYCHEVALSYMPTOMS','Y','Y','Y','Y','NDNW - Setup #4','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XPSYCHEVALSYMPTOMS' ,CategoryName = 'XPSYCHEVALSYMPTOMS',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'NDNW - Setup #4',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XPSYCHEVALSYMPTOMS' AND Category = 'XPSYCHEVALSYMPTOMS'
END

DELETE FROM GlobalCodes WHERE Category = 'XPSYCHEVALSYMPTOMS'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('XPSYCHEVALSYMPTOMS','Aggression','NDNW - Setup #4','Y','N',1),
('XPSYCHEVALSYMPTOMS','Anger','NDNW - Setup #4','Y','N',2),
('XPSYCHEVALSYMPTOMS','Anhedonia','NDNW - Setup #4','Y','N',3),
('XPSYCHEVALSYMPTOMS','Anxiety','NDNW - Setup #4','Y','N',4),
('XPSYCHEVALSYMPTOMS','Apathy','NDNW - Setup #4','Y','N',5),
('XPSYCHEVALSYMPTOMS','Appetite','NDNW - Setup #4','Y','N',6),
('XPSYCHEVALSYMPTOMS','Avoidance','NDNW - Setup #4','Y','N',7),
('XPSYCHEVALSYMPTOMS','Behavioral disruption','NDNW - Setup #4','Y','N',8),
('XPSYCHEVALSYMPTOMS','Depression','NDNW - Setup #4','Y','N',9),
('XPSYCHEVALSYMPTOMS','Hopelessness','NDNW - Setup #4','Y','N',10),
('XPSYCHEVALSYMPTOMS','Irritability','NDNW - Setup #4','Y','N',11),
('XPSYCHEVALSYMPTOMS','Isolation','NDNW - Setup #4','Y','N',12),
('XPSYCHEVALSYMPTOMS','Oppositionality','NDNW - Setup #4','Y','N',13),
('XPSYCHEVALSYMPTOMS','Panic','NDNW - Setup #4','Y','N',14),
('XPSYCHEVALSYMPTOMS','Self-harm behaviors','NDNW - Setup #4','Y','N',15),
('XPSYCHEVALSYMPTOMS','Self-injurious behaviors','NDNW - Setup #4','Y','N',16),
('XPSYCHEVALSYMPTOMS','Other','NDNW - Setup #4','Y','N',17)

--Status---
IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XPSYCHEVALSTATUS' AND Category = 'XPSYCHEVALSTATUS')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('XPSYCHEVALSTATUS','XPSYCHEVALSTATUS','Y','Y','Y','Y','NDNW - Setup #4','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XPSYCHEVALSTATUS' ,CategoryName = 'XPSYCHEVALSTATUS',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'NDNW - Setup #4',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XPSYCHEVALSTATUS' AND Category = 'XPSYCHEVALSTATUS'
END

DELETE FROM GlobalCodes WHERE Category = 'XPSYCHEVALSTATUS'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('XPSYCHEVALSTATUS','Stable','NDNW - Setup #4','Y','N',1),
('XPSYCHEVALSTATUS','Worsening','NDNW - Setup #4','Y','N',2),
('XPSYCHEVALSTATUS','Improving','NDNW - Setup #4','Y','N',3),
('XPSYCHEVALSTATUS','New','NDNW - Setup #4','Y','N',4),
('XPSYCHEVALSTATUS','Resolved','NDNW - Setup #4','Y','N',5)


--Associated Signs/Symptoms---
IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XHISTORYSYMPTOMS' AND Category = 'XHISTORYSYMPTOMS')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('XHISTORYSYMPTOMS','XHISTORYSYMPTOMS','Y','Y','Y','Y','NDNW - Setup #4','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XHISTORYSYMPTOMS' ,CategoryName = 'XHISTORYSYMPTOMS',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'NDNW - Setup #4',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XHISTORYSYMPTOMS' AND Category = 'XHISTORYSYMPTOMS'
END

DELETE FROM GlobalCodes WHERE Category = 'XHISTORYSYMPTOMS'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('XHISTORYSYMPTOMS','Aggression','NDNW - Setup #4','Y','N',1),
('XHISTORYSYMPTOMS','Anger','NDNW - Setup #4','Y','N',2),
('XHISTORYSYMPTOMS','Anhedonia','NDNW - Setup #4','Y','N',3),
('XHISTORYSYMPTOMS','Anxiety','NDNW - Setup #4','Y','N',4),
('XHISTORYSYMPTOMS','Apathy','NDNW - Setup #4','Y','N',5),
('XHISTORYSYMPTOMS','Appetite','NDNW - Setup #4','Y','N',6),
('XHISTORYSYMPTOMS','Avoidance','NDNW - Setup #4','Y','N',7),
('XHISTORYSYMPTOMS','Behavioral disruption','NDNW - Setup #4','Y','N',8),
('XHISTORYSYMPTOMS','Depression','NDNW - Setup #4','Y','N',9),
('XHISTORYSYMPTOMS','Hopelessness','NDNW - Setup #4','Y','N',10),
('XHISTORYSYMPTOMS','Irritability','NDNW - Setup #4','Y','N',11),
('XHISTORYSYMPTOMS','Isolation','NDNW - Setup #4','Y','N',12),
('XHISTORYSYMPTOMS','Oppositionality','NDNW - Setup #4','Y','N',13),
('XHISTORYSYMPTOMS','Panic','NDNW - Setup #4','Y','N',14),
('XHISTORYSYMPTOMS','Self-harm behaviors','NDNW - Setup #4','Y','N',15),
('XHISTORYSYMPTOMS','Self-injurious behaviors','NDNW - Setup #4','Y','N',16),
('XHISTORYSYMPTOMS','Other','NDNW - Setup #4','Y','N',17)
