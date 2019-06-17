/********************************************************************************                                                   
--  
-- Copyright: Streamline Healthcare Solutions  
-- "Relapse Prevention Plan"
-- Purpose: Global Code Entries to Bind Drop Down for New Directions - Customizations_18
--  
-- Author:  Anto
-- Date:    04-06-2015

*********************************************************************************/
-- Plan Status --
IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xRelapseplanstatus' AND Category = 'xRelapseplanstatus')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xRelapseplanstatus','xRelapseplanstatus','Y','Y','Y','Y','New Directions - Customizations #18','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xRelapseplanstatus' ,CategoryName = 'xRelapseplanstatus',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions - Customizations #18',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xRelapseplanstatus' AND Category = 'xRelapseplanstatus'
END

DELETE FROM GlobalCodes WHERE Category = 'xRelapseplanstatus'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES 
('xRelapseplanstatus','Inactive – Old Version','New Directions - Customizations #18','Y','N',1),
('xRelapseplanstatus','Active – Not Signed Off','New Directions - Customizations #18','Y','N',2),
('xRelapseplanstatus','Active – Signed Off','New Directions - Customizations #18','Y','N',3),
('xRelapseplanstatus','Inactive – Draft','New Directions - Customizations #18','Y','N',4)








-- High Risk Situations --
IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xRelapsehighrisk' AND Category = 'xRelapsehighrisk')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xRelapsehighrisk','xRelapsehighrisk','Y','Y','Y','Y','New Directions - Customizations #18','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xRelapsehighrisk' ,CategoryName = 'xRelapsehighrisk',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions - Customizations #18',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xRelapsehighrisk' AND Category = 'xRelapsehighrisk'
END

DELETE FROM GlobalCodes WHERE Category = 'xRelapsehighrisk'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES 
('xRelapsehighrisk','In a Bar','New Directions - Customizations #18','Y','N',1),
('xRelapsehighrisk','In a Crack House','New Directions - Customizations #18','Y','N',2),
('xRelapsehighrisk','At the house of a friend who is actively using alcohol or drugs.','New Directions - Customizations #18','Y','N',3),
('xRelapsehighrisk','At the house of a family member who is actively using alcohol or drugs.','New Directions - Customizations #18','Y','N',4),
('xRelapsehighrisk','Hanging out with active drinkers and/or drug users.','New Directions - Customizations #18','Y','N',5),
('xRelapsehighrisk','With significant other or spouse while he/she is drinking or using drugs.','New Directions - Customizations #18','Y','N',6),
('xRelapsehighrisk','With significant other or spouse or with former significant other or spouse.','New Directions - Customizations #18','Y','N',7),
('xRelapsehighrisk','Turning Tricks or Picking Up Prostitutes','New Directions - Customizations #18','Y','N',8),
('xRelapsehighrisk','At a Corner Store that Sells Alcohol','New Directions - Customizations #18','Y','N',9),
('xRelapsehighrisk','At a Party where Alcohol or Drugs are Available','New Directions - Customizations #18','Y','N',10),
('xRelapsehighrisk','Traveling through neighborhoods associated with past alcohol or drug use experiences.','New Directions - Customizations #18','Y','N',11),
('xRelapsehighrisk','Other','New Directions - Customizations #18','Y','N',12)







-- Recovery Activities --
IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xrelapserecoveract' AND Category = 'xrelapserecoveract')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xrelapserecoveract','xrelapserecoveract','Y','Y','Y','Y','New Directions - Customizations #18','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xrelapserecoveract' ,CategoryName = 'xrelapserecoveract',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions - Customizations #18',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xrelapserecoveract' AND Category = 'xrelapserecoveract'
END

DELETE FROM GlobalCodes WHERE Category = 'xrelapserecoveract'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES 
('xrelapserecoveract','Brothers and/or Sisters Events','New Directions - Customizations #18','Y','N',1),
('xrelapserecoveract','Participation in Sports / Other Recreation','New Directions - Customizations #18','Y','N',2),
('xrelapserecoveract','Activities with Child(ren)','New Directions - Customizations #18','Y','N',3),
('xrelapserecoveract','Activities with Clean and Sober Family Members','New Directions - Customizations #18','Y','N',4),
('xrelapserecoveract','Activities with clean and sober friends','New Directions - Customizations #18','Y','N',5),
('xrelapserecoveract','Church Services or Other Religious Practices','New Directions - Customizations #18','Y','N',6),
('xrelapserecoveract','Social Activities with Church or Other Groups','New Directions - Customizations #18','Y','N',7),
('xrelapserecoveract','Classes (GED, College, Community Education, etc.)','New Directions - Customizations #18','Y','N',8),
('xrelapserecoveract','Working Out / Going to the Gym','New Directions - Customizations #18','Y','N',9),
('xrelapserecoveract','Other','New Directions - Customizations #18','Y','N',10),
('xrelapserecoveract','Volunteering','New Directions - Customizations #18','Y','N',11),
('xrelapserecoveract','Participation in Community Service','New Directions - Customizations #18','Y','N',12)






-- Life Domain --
IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'Xlifedomain' AND Category = 'Xlifedomain')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('Xlifedomain','Xlifedomain','Y','Y','Y','Y','New Directions - Customizations #18','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'Xlifedomain' ,CategoryName = 'Xlifedomain',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions - Customizations #18',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'Xlifedomain' AND Category = 'Xlifedomain'
END

DELETE FROM GlobalCodes WHERE Category = 'Xlifedomain'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES 
('Xlifedomain','Recovery from substance use disorder','New Directions - Customizations #18','Y','N',1),
('Xlifedomain','Living and financial independence','New Directions - Customizations #18','Y','N',2),
('Xlifedomain','Employment and education','New Directions - Customizations #18','Y','N',3),
('Xlifedomain','Relationships and social supports','New Directions - Customizations #18','Y','N',4),
('Xlifedomain','Medical health','New Directions - Customizations #18','Y','N',5),
('Xlifedomain','Leisure and recreation','New Directions - Customizations #18','Y','N',6),
('Xlifedomain','Independence from legal problems and institutions','New Directions - Customizations #18','Y','N',7),
('Xlifedomain','Mental wellness and spirituality','New Directions - Customizations #18','Y','N',8)





-- Goal Status --
IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'Xrelapsegoalstatus' AND Category = 'Xrelapsegoalstatus')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('Xrelapsegoalstatus','Xrelapsegoalstatus','Y','Y','Y','Y','New Directions - Customizations #18','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'Xrelapsegoalstatus' ,CategoryName = 'Xrelapsegoalstatus',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions - Customizations #18',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'Xrelapsegoalstatus' AND Category = 'Xrelapsegoalstatus'
END

DELETE FROM GlobalCodes WHERE Category = 'Xrelapsegoalstatus'

INSERT INTO GlobalCodes (Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES 
('Xrelapsegoalstatus','In progress','INPROGRESS','New Directions - Customizations #18','Y','N',1),
('Xrelapsegoalstatus','Completed','COMPLETED','New Directions - Customizations #18','Y','N',2),
('Xrelapsegoalstatus','Deferred','DEFERRED','New Directions - Customizations #18','Y','N',3),
('Xrelapsegoalstatus','Withdrawn','WITHDRAWN','New Directions - Customizations #18','Y','N',4)


-- Action Step Status  --
IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'Xactionstepstatus' AND Category = 'Xactionstepstatus')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('Xactionstepstatus','Xactionstepstatus','Y','Y','Y','Y','New Directions - Customizations #18','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'Xactionstepstatus' ,CategoryName = 'Xactionstepstatus',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions - Customizations #18',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'Xactionstepstatus' AND Category = 'Xactionstepstatus'
END

DELETE FROM GlobalCodes WHERE Category = 'Xactionstepstatus'

INSERT INTO GlobalCodes (Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES 
('Xactionstepstatus','In progress','INPROGRESS','New Directions - Customizations #18','Y','N',1),
('Xactionstepstatus','Completed','COMPLETED','New Directions - Customizations #18','Y','N',2),
('Xactionstepstatus','Deferred','DEFERRED','New Directions - Customizations #18','Y','N',3),
('Xactionstepstatus','Withdrawn','WITHDRAWN','New Directions - Customizations #18','Y','N',4)




-- Objective status  --
IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'Xrelapseobjstatus' AND Category = 'Xrelapseobjstatus')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('Xrelapseobjstatus','Xrelapseobjstatus','Y','Y','Y','Y','New Directions - Customizations #18','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'Xrelapseobjstatus' ,CategoryName = 'Xrelapseobjstatus',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions - Customizations #18',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'Xrelapseobjstatus' AND Category = 'Xrelapseobjstatus'
END

DELETE FROM GlobalCodes WHERE Category = 'Xrelapseobjstatus'

INSERT INTO GlobalCodes (Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES 
('Xrelapseobjstatus','In progress','INPROGRESS','New Directions - Customizations #18','Y','N',1),
('Xrelapseobjstatus','Completed','COMPLETED','New Directions - Customizations #18','Y','N',2),
('Xrelapseobjstatus','Deferred','DEFERRED','New Directions - Customizations #18','Y','N',3),
('Xrelapseobjstatus','Withdrawn','WITHDRAWN','New Directions - Customizations #18','Y','N',4)

