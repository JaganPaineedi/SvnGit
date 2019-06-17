/********************************************************************************                                                   
--  
-- Copyright: Streamline Healthcare Solutions  
-- "Crisis Service Note"
-- Purpose: Global Code Entries to Bind Drop Down for for Task #3 - New Directions - Customizations.
--  
-- Author:  Vichee
-- Date:    06-APR-2015
--  
-- *****History****  
*********************************************************************************/


IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xCrisisNoteQ1' AND Category = 'xCrisisNoteQ1')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xCrisisNoteQ1','xCrisisNoteQ1','Y','Y','Y','Y','New Directions- Customizations #3','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xCrisisNoteQ1' ,CategoryName = 'xCrisisNoteQ1',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions- Customizations #3',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xCrisisNoteQ1' AND Category = 'xCrisisNoteQ1'
END

DELETE FROM GlobalCodes WHERE Category = 'xCrisisNoteQ1'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('xCrisisNoteQ1','0 – Vague','New Directions- Customizations #3','Y','N',1),
('xCrisisNoteQ1','1 – Some Specifics','New Directions- Customizations #3','Y','N',2),
('xCrisisNoteQ1','2 – Well thought out, knows when, where, how','New Directions- Customizations #3','Y','N',3)


IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xCrisisNoteQ2' AND Category = 'xCrisisNoteQ2')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xCrisisNoteQ2','xCrisisNoteQ2','Y','Y','Y','Y','New Directions- Customizations #3','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xCrisisNoteQ2' ,CategoryName = 'xCrisisNoteQ2',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions- Customizations #3',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xCrisisNoteQ2' AND Category = 'xCrisisNoteQ2'
END

DELETE FROM GlobalCodes WHERE Category = 'xCrisisNoteQ2'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('xCrisisNoteQ2','0 – Not available, will have to get 0','New Directions- Customizations #3','Y','N',1),
('xCrisisNoteQ2','1 – Available, have close by 1','New Directions- Customizations #3','Y','N',2),
('xCrisisNoteQ2','2 – Have on hand','New Directions- Customizations #3','Y','N',3)


IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xCrisisNoteQ3' AND Category = 'xCrisisNoteQ3')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xCrisisNoteQ3','xCrisisNoteQ3','Y','Y','Y','Y','New Directions- Customizations #3','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xCrisisNoteQ3' ,CategoryName = 'xCrisisNoteQ3',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions- Customizations #3',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xCrisisNoteQ3' AND Category = 'xCrisisNoteQ3'
END

DELETE FROM GlobalCodes WHERE Category = 'xCrisisNoteQ3'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('xCrisisNoteQ3','0 -  No specific time or in future ','New Directions- Customizations #3','Y','N',1),
('xCrisisNoteQ3','1 – Within a few hours','New Directions- Customizations #3','Y','N',2),
('xCrisisNoteQ3','2 – Immediately','New Directions- Customizations #3','Y','N',3)




IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xCrisisNoteQ4' AND Category = 'xCrisisNoteQ4')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xCrisisNoteQ4','xCrisisNoteQ4','Y','Y','Y','Y','New Directions- Customizations #3','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xCrisisNoteQ4' ,CategoryName = 'xCrisisNoteQ4',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions- Customizations #3',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xCrisisNoteQ4' AND Category = 'xCrisisNoteQ4'
END

DELETE FROM GlobalCodes WHERE Category = 'xCrisisNoteQ4'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('xCrisisNoteQ4','0 -  Pills, slash wrists, cutting','New Directions- Customizations #3','Y','N',1),
('xCrisisNoteQ4','1 – Drugs and alcohol, car wreck, carbon monoxide','New Directions- Customizations #3','Y','N',2),
('xCrisisNoteQ4','2 – Gun, hanging, jumping','New Directions- Customizations #3','Y','N',3)


IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xCrisisNoteQ5' AND Category = 'xCrisisNoteQ5')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xCrisisNoteQ5','xCrisisNoteQ5','Y','Y','Y','Y','New Directions- Customizations #3','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xCrisisNoteQ5' ,CategoryName = 'xCrisisNoteQ5',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions- Customizations #3',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xCrisisNoteQ5' AND Category = 'xCrisisNoteQ5'
END

DELETE FROM GlobalCodes WHERE Category = 'xCrisisNoteQ5'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('xCrisisNoteQ5','0 -  None or one of low lethality','New Directions- Customizations #3','Y','N',1),
('xCrisisNoteQ5','1 – Multiple of low lethality or one of medium lethality, history of repeated threats','New Directions- Customizations #3','Y','N',2),
('xCrisisNoteQ5','2 – One high lethality or multiple of moderate','New Directions- Customizations #3','Y','N',3)


IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xCrisisNoteQ6' AND Category = 'xCrisisNoteQ6')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xCrisisNoteQ6','xCrisisNoteQ6','Y','Y','Y','Y','New Directions- Customizations #3','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xCrisisNoteQ6' ,CategoryName = 'xCrisisNoteQ6',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions- Customizations #3',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xCrisisNoteQ6' AND Category = 'xCrisisNoteQ6'
END

DELETE FROM GlobalCodes WHERE Category = 'xCrisisNoteQ6'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('xCrisisNoteQ6','0 -  Somebody present most of the time','New Directions- Customizations #3','Y','N',1),
('xCrisisNoteQ6','1 –  Somebody nearby, or in visual or vocal contact','New Directions- Customizations #3','Y','N',2),
('xCrisisNoteQ6','2 – No one nearby or in visual or vocal contact','New Directions- Customizations #3','Y','N',3)



IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xCrisisNoteQ7' AND Category = 'xCrisisNoteQ7')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xCrisisNoteQ7','xCrisisNoteQ7','Y','Y','Y','Y','New Directions- Customizations #3','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xCrisisNoteQ7' ,CategoryName = 'xCrisisNoteQ7',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions- Customizations #3',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xCrisisNoteQ7' AND Category = 'xCrisisNoteQ7'
END

DELETE FROM GlobalCodes WHERE Category = 'xCrisisNoteQ7'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('xCrisisNoteQ7','0 -  Intervention probable','New Directions- Customizations #3','Y','N',1),
('xCrisisNoteQ7','1 – Intervention unlikely','New Directions- Customizations #3','Y','N',2),
('xCrisisNoteQ7','2 – Intervention highly unlikely','New Directions- Customizations #3','Y','N',3)


IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xCrisisNoteQ8' AND Category = 'xCrisisNoteQ8')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xCrisisNoteQ8','xCrisisNoteQ8','Y','Y','Y','Y','New Directions- Customizations #3','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xCrisisNoteQ8' ,CategoryName = 'xCrisisNoteQ8',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions- Customizations #3',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xCrisisNoteQ8' AND Category = 'xCrisisNoteQ8'
END

DELETE FROM GlobalCodes WHERE Category = 'xCrisisNoteQ8'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('xCrisisNoteQ8','0 – No precautions','New Directions- Customizations #3','Y','N',1),
('xCrisisNoteQ8','1 – Passive precautions, e.g. avoiding others but not doing anything to prevent their  intervention, alone in room with unlocked door ','New Directions- Customizations #3','Y','N',2),
('xCrisisNoteQ8','2 – Active precautions, e.g. locked door','New Directions- Customizations #3','Y','N',3)


IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xCrisisNoteQ9' AND Category = 'xCrisisNoteQ9')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xCrisisNoteQ9','xCrisisNoteQ9','Y','Y','Y','Y','New Directions- Customizations #3','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xCrisisNoteQ9' ,CategoryName = 'xCrisisNoteQ9',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions- Customizations #3',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xCrisisNoteQ9' AND Category = 'xCrisisNoteQ9'
END

DELETE FROM GlobalCodes WHERE Category = 'xCrisisNoteQ9'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('xCrisisNoteQ9','0 – Notified potential helper regarding attempt','New Directions- Customizations #3','Y','N',1),
('xCrisisNoteQ9','1 – Contacted but did not specifically notify potential helper regarding attempt','New Directions- Customizations #3','Y','N',2),
('xCrisisNoteQ9','2 – Did not contact or notify potential helper','New Directions- Customizations #3','Y','N',3)




IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xCrisisNoteQ10' AND Category = 'xCrisisNoteQ10')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xCrisisNoteQ10','xCrisisNoteQ10','Y','Y','Y','Y','New Directions- Customizations #3','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xCrisisNoteQ10' ,CategoryName = 'xCrisisNoteQ10',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions- Customizations #3',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xCrisisNoteQ10' AND Category = 'xCrisisNoteQ10'
END

DELETE FROM GlobalCodes WHERE Category = 'xCrisisNoteQ10'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('xCrisisNoteQ10','0 - None','New Directions- Customizations #3','Y','N',1),
('xCrisisNoteQ10','1 – Thought about or made some arrangements','New Directions- Customizations #3','Y','N',2),
('xCrisisNoteQ10','2 – Made definite plans or completed arrangements','New Directions- Customizations #3','Y','N',3)


IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xCrisisNoteQ11' AND Category = 'xCrisisNoteQ11')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xCrisisNoteQ11','xCrisisNoteQ11','Y','Y','Y','Y','New Directions- Customizations #3','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xCrisisNoteQ11' ,CategoryName = 'xCrisisNoteQ11',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions- Customizations #3',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xCrisisNoteQ11' AND Category = 'xCrisisNoteQ11'
END

DELETE FROM GlobalCodes WHERE Category = 'xCrisisNoteQ11'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('xCrisisNoteQ11','0 - None','New Directions- Customizations #3','Y','N',1),
('xCrisisNoteQ11','1 – Minimal to moderate','New Directions- Customizations #3','Y','N',2),
('xCrisisNoteQ11','2 – Extensive','New Directions- Customizations #3','Y','N',3)


IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xCrisisNoteQ12' AND Category = 'xCrisisNoteQ12')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xCrisisNoteQ12','xCrisisNoteQ12','Y','Y','Y','Y','New Directions- Customizations #3','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xCrisisNoteQ12' ,CategoryName = 'xCrisisNoteQ12',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions- Customizations #3',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xCrisisNoteQ12' AND Category = 'xCrisisNoteQ12'
END

DELETE FROM GlobalCodes WHERE Category = 'xCrisisNoteQ12'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('xCrisisNoteQ12','0 – Absence of note/message','New Directions- Customizations #3','Y','N',1),
('xCrisisNoteQ12','1 – Note/Message written or torn up, or thought about ','New Directions- Customizations #3','Y','N',2),
('xCrisisNoteQ12','2 – Presence of note/message','New Directions- Customizations #3','Y','N',3)

IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xCrisisNoteQ13' AND Category = 'xCrisisNoteQ13')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xCrisisNoteQ13','xCrisisNoteQ13','Y','Y','Y','Y','New Directions- Customizations #3','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xCrisisNoteQ13' ,CategoryName = 'xCrisisNoteQ13',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions- Customizations #3',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xCrisisNoteQ13' AND Category = 'xCrisisNoteQ13'
END

DELETE FROM GlobalCodes WHERE Category = 'xCrisisNoteQ13'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('xCrisisNoteQ13','0 - None','New Directions- Customizations #3','Y','N',1),
('xCrisisNoteQ13','1 – Equivocal communication','New Directions- Customizations #3','Y','N',2),
('xCrisisNoteQ13','2 – Unequivocal communication','New Directions- Customizations #3','Y','N',3)


IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xCrisisNoteQ14' AND Category = 'xCrisisNoteQ14')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xCrisisNoteQ14','xCrisisNoteQ14','Y','Y','Y','Y','New Directions- Customizations #3','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xCrisisNoteQ14' ,CategoryName = 'xCrisisNoteQ14',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions- Customizations #3',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xCrisisNoteQ14' AND Category = 'xCrisisNoteQ14'
END

DELETE FROM GlobalCodes WHERE Category = 'xCrisisNoteQ14'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('xCrisisNoteQ14','0 – To manipulate environment, get attention','New Directions- Customizations #3','Y','N',1),
('xCrisisNoteQ14','1 – Revenge','New Directions- Customizations #3','Y','N',2),
('xCrisisNoteQ14','2 – To escape, solve problems','New Directions- Customizations #3','Y','N',3)


IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xCrisisNoteQ15' AND Category = 'xCrisisNoteQ15')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xCrisisNoteQ15','xCrisisNoteQ15','Y','Y','Y','Y','New Directions- Customizations #3','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xCrisisNoteQ15' ,CategoryName = 'xCrisisNoteQ15',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions- Customizations #3',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xCrisisNoteQ15' AND Category = 'xCrisisNoteQ15'
END

DELETE FROM GlobalCodes WHERE Category = 'xCrisisNoteQ15'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('xCrisisNoteQ15','0 – Thought that death was unlikely','New Directions- Customizations #3','Y','N',1),
('xCrisisNoteQ15','1 – Thought that death was possible, not probable','New Directions- Customizations #3','Y','N',2),
('xCrisisNoteQ15','2 – Thought that death was probable or certain','New Directions- Customizations #3','Y','N',3)


----- Till 15 it has been done

IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xCrisisNoteQ16' AND Category = 'xCrisisNoteQ16')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xCrisisNoteQ16','xCrisisNoteQ16','Y','Y','Y','Y','New Directions- Customizations #3','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xCrisisNoteQ16' ,CategoryName = 'xCrisisNoteQ16',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions- Customizations #3',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xCrisisNoteQ16' AND Category = 'xCrisisNoteQ16'
END

DELETE FROM GlobalCodes WHERE Category = 'xCrisisNoteQ16'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('xCrisisNoteQ16','0 – Did less to self than thought would be lethal','New Directions- Customizations #3','Y','N',1),
('xCrisisNoteQ16','1 – Was unsure if action would be lethal','New Directions- Customizations #3','Y','N',2),
('xCrisisNoteQ16','2 – Equated or exceeded what she/he thought would be lethal','New Directions- Customizations #3','Y','N',3)


IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xCrisisNoteQ17' AND Category = 'xCrisisNoteQ17')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xCrisisNoteQ17','xCrisisNoteQ17','Y','Y','Y','Y','New Directions- Customizations #3','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xCrisisNoteQ17' ,CategoryName = 'xCrisisNoteQ17',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions- Customizations #3',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xCrisisNoteQ17' AND Category = 'xCrisisNoteQ17'
END

DELETE FROM GlobalCodes WHERE Category = 'xCrisisNoteQ17'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('xCrisisNoteQ17','0 – Did not seriously attempt to end life','New Directions- Customizations #3','Y','N',1),
('xCrisisNoteQ17','1 – Uncertain about seriousness to end life','New Directions- Customizations #3','Y','N',2),
('xCrisisNoteQ17','2 – Seriously attempted to end life','New Directions- Customizations #3','Y','N',3)


IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xCrisisNoteQ18' AND Category = 'xCrisisNoteQ18')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xCrisisNoteQ18','xCrisisNoteQ18','Y','Y','Y','Y','New Directions- Customizations #3','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xCrisisNoteQ18' ,CategoryName = 'xCrisisNoteQ18',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions- Customizations #3',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xCrisisNoteQ18' AND Category = 'xCrisisNoteQ18'
END

DELETE FROM GlobalCodes WHERE Category = 'xCrisisNoteQ18'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('xCrisisNoteQ18','0 – Did not want to die','New Directions- Customizations #3','Y','N',1),
('xCrisisNoteQ18','1 – Components','New Directions- Customizations #3','Y','N',2),
('xCrisisNoteQ18','2 – Wanted to die','New Directions- Customizations #3','Y','N',3)


IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xCrisisNoteQ19' AND Category = 'xCrisisNoteQ19')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xCrisisNoteQ19','xCrisisNoteQ19','Y','Y','Y','Y','New Directions- Customizations #3','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xCrisisNoteQ19' ,CategoryName = 'xCrisisNoteQ19',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions- Customizations #3',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xCrisisNoteQ19' AND Category = 'xCrisisNoteQ19'
END

DELETE FROM GlobalCodes WHERE Category = 'xCrisisNoteQ19'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('xCrisisNoteQ19','0 – Thought death would be unlikely with medical attention','New Directions- Customizations #3','Y','N',1),
('xCrisisNoteQ19','1 – Was uncertain whether death could be averted by medical attention','New Directions- Customizations #3','Y','N',2),
('xCrisisNoteQ19','2 – Was certain of death even with medical attention','New Directions- Customizations #3','Y','N',3)


IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xCrisisNoteQ20' AND Category = 'xCrisisNoteQ20')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xCrisisNoteQ20','xCrisisNoteQ20','Y','Y','Y','Y','New Directions- Customizations #3','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xCrisisNoteQ20' ,CategoryName = 'xCrisisNoteQ20',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions- Customizations #3',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xCrisisNoteQ20' AND Category = 'xCrisisNoteQ20'
END

DELETE FROM GlobalCodes WHERE Category = 'xCrisisNoteQ20'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('xCrisisNoteQ20','0 - None','New Directions- Customizations #3','Y','N',1),
('xCrisisNoteQ20','1 – Minimal to moderate','New Directions- Customizations #3','Y','N',2),
('xCrisisNoteQ20','2 – Extensive','New Directions- Customizations #3','Y','N',3)


IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xCrisisNoteQ21' AND Category = 'xCrisisNoteQ21')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xCrisisNoteQ21','xCrisisNoteQ21','Y','Y','Y','Y','New Directions- Customizations #3','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xCrisisNoteQ21' ,CategoryName = 'xCrisisNoteQ21',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions- Customizations #3',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xCrisisNoteQ21' AND Category = 'xCrisisNoteQ21'
END

DELETE FROM GlobalCodes WHERE Category = 'xCrisisNoteQ21'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('xCrisisNoteQ21','0 – No significant stress','New Directions- Customizations #3','Y','N',1),
('xCrisisNoteQ21','1 – Moderate reaction to loss and environmental changes','New Directions- Customizations #3','Y','N',2),
('xCrisisNoteQ21','2 – Severe reaction to loss or environmental changes','New Directions- Customizations #3','Y','N',3)




IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xCrisisNoteQ22' AND Category = 'xCrisisNoteQ22')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xCrisisNoteQ22','xCrisisNoteQ22','Y','Y','Y','Y','New Directions- Customizations #3','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xCrisisNoteQ22' ,CategoryName = 'xCrisisNoteQ22',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions- Customizations #3',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xCrisisNoteQ22' AND Category = 'xCrisisNoteQ22'
END

DELETE FROM GlobalCodes WHERE Category = 'xCrisisNoteQ22'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('xCrisisNoteQ22','0 – Daily activities continue as usual with little change','New Directions- Customizations #3','Y','N',1),
('xCrisisNoteQ22','1 – Some daily activities interrupted, disturbance in eating, sleeping, school work, work','New Directions- Customizations #3','Y','N',2),
('xCrisisNoteQ22','2 – Gross disturbance of daily functions','New Directions- Customizations #3','Y','N',3)


IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xCrisisNoteQ23' AND Category = 'xCrisisNoteQ23')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xCrisisNoteQ23','xCrisisNoteQ23','Y','Y','Y','Y','New Directions- Customizations #3','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xCrisisNoteQ23' ,CategoryName = 'xCrisisNoteQ23',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions- Customizations #3',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xCrisisNoteQ23' AND Category = 'xCrisisNoteQ23'
END

DELETE FROM GlobalCodes WHERE Category = 'xCrisisNoteQ23'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('xCrisisNoteQ23','0 – Mild, feels slightly down','New Directions- Customizations #3','Y','N',1),
('xCrisisNoteQ23','1 – Moderate, some moodiness, sadness, irritability, loneliness and decrease of energy','New Directions- Customizations #3','Y','N',2),
('xCrisisNoteQ23','2 – Overwhelmed with hopelessness, sadness and feels worthless','New Directions- Customizations #3','Y','N',3)


IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xCrisisNoteQ24' AND Category = 'xCrisisNoteQ24')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xCrisisNoteQ24','xCrisisNoteQ24','Y','Y','Y','Y','New Directions- Customizations #3','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xCrisisNoteQ24' ,CategoryName = 'xCrisisNoteQ24',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions- Customizations #3',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xCrisisNoteQ24' AND Category = 'xCrisisNoteQ24'
END

DELETE FROM GlobalCodes WHERE Category = 'xCrisisNoteQ24'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('xCrisisNoteQ24','0 – Help available; significant others concerned and willing to help','New Directions- Customizations #3','Y','N',1),
('xCrisisNoteQ24','1 – Family and Friends available, but unwilling to consistently help','New Directions- Customizations #3','Y','N',2),
('xCrisisNoteQ24','2 – Family and friends not available, are hostile, exhausted, injurious','New Directions- Customizations #3','Y','N',3)


IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xCrisisNoteQ25' AND Category = 'xCrisisNoteQ25')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xCrisisNoteQ25','xCrisisNoteQ25','Y','Y','Y','Y','New Directions- Customizations #3','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xCrisisNoteQ25' ,CategoryName = 'xCrisisNoteQ25',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions- Customizations #3',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xCrisisNoteQ25' AND Category = 'xCrisisNoteQ25'
END

DELETE FROM GlobalCodes WHERE Category = 'xCrisisNoteQ25'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('xCrisisNoteQ25','0 -  Stable relationships, personality and school/work performance','New Directions- Customizations #3','Y','N',1),
('xCrisisNoteQ25','1 – Recent, acting out behavior and substance abuse, acute suicidal','New Directions- Customizations #3','Y','N',2),
('xCrisisNoteQ25','2 – Suicidal behavior is unstable personality, emotional disturbance, repeated difficulty with peers, family, school, work','New Directions- Customizations #3','Y','N',3)


IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xCrisisNoteQ26' AND Category = 'xCrisisNoteQ26')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xCrisisNoteQ26','xCrisisNoteQ26','Y','Y','Y','Y','New Directions- Customizations #3','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xCrisisNoteQ26' ,CategoryName = 'xCrisisNoteQ26',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions- Customizations #3',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xCrisisNoteQ26' AND Category = 'xCrisisNoteQ26'
END

DELETE FROM GlobalCodes WHERE Category = 'xCrisisNoteQ26'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('xCrisisNoteQ26','0 -  No significant medical problems','New Directions- Customizations #3','Y','N',1),
('xCrisisNoteQ26','1 – Acute, but short term or psychosomatic illness','New Directions- Customizations #3','Y','N',2),
('xCrisisNoteQ26','2 – Chronic debilitating or acute catastrophic illness','New Directions- Customizations #3','Y','N',3)



IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'Xcrisisdangers' AND Category = 'Xcrisisdangers')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('Xcrisisdangers','Xcrisisdangers','Y','Y','Y','Y','New Directions- Customizations #3','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'Xcrisisdangers' ,CategoryName = 'Xcrisisdangers',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions- Customizations #3',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'Xcrisisdangers' AND Category = 'Xcrisisdangers'
END

DELETE FROM GlobalCodes WHERE Category = 'Xcrisisdangers'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('Xcrisisdangers','Thoughts','New Directions- Customizations #3','Y','N',1),
('Xcrisisdangers','Threats','New Directions- Customizations #3','Y','N',2),
('Xcrisisdangers','Plan','New Directions- Customizations #3','Y','N',3),
('Xcrisisdangers','Action/Behavior','New Directions- Customizations #3','Y','N',4),
('Xcrisisdangers','None','New Directions- Customizations #3','Y','N',5),
('Xcrisisdangers','Unknown','New Directions- Customizations #3','Y','N',6)

IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'Xcrisisdangers' AND Category = 'Xcrisisdangers')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('Xcrisisdangers','Xcrisisdangers','Y','Y','Y','Y','New Directions- Customizations #3','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'Xcrisisdangers' ,CategoryName = 'Xcrisisdangers',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions- Customizations #3',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'Xcrisisdangers' AND Category = 'Xcrisisdangers'
END

DELETE FROM GlobalCodes WHERE Category = 'Xcrisisdangers'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('Xcrisisdangers','Thoughts','New Directions- Customizations #3','Y','N',1),
('Xcrisisdangers','Threats','New Directions- Customizations #3','Y','N',2),
('Xcrisisdangers','Plan','New Directions- Customizations #3','Y','N',3),
('Xcrisisdangers','Action/Behavior','New Directions- Customizations #3','Y','N',4),
('Xcrisisdangers','None','New Directions- Customizations #3','Y','N',5),
('Xcrisisdangers','Unknown','New Directions- Customizations #3','Y','N',6)



IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'Xcrisisdangers' AND Category = 'Xcrisisdangers')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('Xcrisisdangers','Xcrisisdangers','Y','Y','Y','Y','New Directions- Customizations #3','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'Xcrisisdangers' ,CategoryName = 'Xcrisisdangers',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions- Customizations #3',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'Xcrisisdangers' AND Category = 'Xcrisisdangers'
END

DELETE FROM GlobalCodes WHERE Category = 'Xcrisisdangers'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('Xcrisisdangers','Thoughts','New Directions- Customizations #3','Y','N',1),
('Xcrisisdangers','Threats','New Directions- Customizations #3','Y','N',2),
('Xcrisisdangers','Plan','New Directions- Customizations #3','Y','N',3),
('Xcrisisdangers','Action/Behavior','New Directions- Customizations #3','Y','N',4),
('Xcrisisdangers','None','New Directions- Customizations #3','Y','N',5),
('Xcrisisdangers','Unknown','New Directions- Customizations #3','Y','N',6)


