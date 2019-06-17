/********************************************************************************                                                   
--  
-- Copyright: Streamline Healthcare Solutions  
-- "Psychiatric Service Note"
-- Purpose: Global Code Entries to Bind Drop Down for for Task #822 - Woods - Customizations.
--  
-- Author:  Vichee
-- Date:    20-APR-2015
--  
-- *****History****  
*********************************************************************************/
--Severity---
IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XHISTORYSEVERITY' AND Category = 'XHISTORYSEVERITY')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('XHISTORYSEVERITY','XHISTORYSEVERITY','Y','Y','Y','Y','NDNW - Setup #4','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XHISTORYSEVERITY' ,CategoryName = 'XHISTORYSEVERITY',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'NDNW - Setup #4',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XHISTORYSEVERITY' AND Category = 'XHISTORYSEVERITY'
END

DELETE FROM GlobalCodes WHERE Category = 'XHISTORYSEVERITY'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('XHISTORYSEVERITY','Mild','NDNW - Setup #4','Y','N',1),
('XHISTORYSEVERITY','Moderate','NDNW - Setup #4','Y','N',2),
('XHISTORYSEVERITY','Severe','NDNW - Setup #4','Y','N',3)


--Intensity---
IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XHISTORYINTENSITY' AND Category = 'XHISTORYINTENSITY')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('XHISTORYINTENSITY','XHISTORYINTENSITY','Y','Y','Y','Y','NDNW - Setup #4','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XHISTORYINTENSITY' ,CategoryName = 'XHISTORYINTENSITY',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'NDNW - Setup #4',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XHISTORYINTENSITY' AND Category = 'XHISTORYINTENSITY'
END

DELETE FROM GlobalCodes WHERE Category = 'XHISTORYINTENSITY'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('XHISTORYINTENSITY','Throbbing','NDNW - Setup #4','Y','N',1),
('XHISTORYINTENSITY','Pulsating','NDNW - Setup #4','Y','N',2),
('XHISTORYINTENSITY','Stabbing','NDNW - Setup #4','Y','N',3),
('XHISTORYINTENSITY','Squeezing','NDNW - Setup #4','Y','N',4),
('XHISTORYINTENSITY','Dull','NDNW - Setup #4','Y','N',5),
('XHISTORYINTENSITY','Sharp','NDNW - Setup #4','Y','N',6)


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



--Status---
IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XPROBLEMSTATUS' AND Category = 'XPROBLEMSTATUS')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('XPROBLEMSTATUS','XPROBLEMSTATUS','Y','Y','Y','Y','NDNW - Setup #4','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XPROBLEMSTATUS' ,CategoryName = 'XPROBLEMSTATUS',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'NDNW - Setup #4',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XPROBLEMSTATUS' AND Category = 'XPROBLEMSTATUS'
END

DELETE FROM GlobalCodes WHERE Category = 'XPROBLEMSTATUS'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('XPROBLEMSTATUS','Stable','NDNW - Setup #4','Y','N',1),
('XPROBLEMSTATUS','Worsening','NDNW - Setup #4','Y','N',2),
('XPROBLEMSTATUS','Improving','NDNW - Setup #4','Y','N',3),
('XPROBLEMSTATUS','New','NDNW - Setup #4','Y','N',4),
('XPROBLEMSTATUS','Resolved','NDNW - Setup #4','Y','N',5)
