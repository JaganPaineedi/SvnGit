-- GlobalCodes for AdultLT and Child LT

-- Yes or No
IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XCSSRSYESNO' AND Category = 'XCSSRSYESNO')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes)
	VALUES ('XCSSRSYESNO','XCSSRSYESNO','Y','Y','Y','Y','Valley - Customizations #955','N','N')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XCSSRSYESNO' ,CategoryName = 'XCSSRSYESNO',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'Valley - Customizations #955',UserDefinedCategory = 'N',HasSubcodes = 'N' WHERE CategoryName = 'XCSSRSYESNO' AND Category = 'XCSSRSYESNO'
END

DELETE FROM GlobalCodes WHERE Category = 'XCSSRSYESNO'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('XCSSRSYESNO','Yes','Valley - Customizations #955','Y','N',1),
('XCSSRSYESNO','No','Valley - Customizations #955','Y','N',2)

-- Severity

IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XSEVERITY' AND Category = 'XSEVERITY')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes)
	VALUES ('XSEVERITY','XSEVERITY','Y','Y','Y','Y','Valley - Customizations #955','N','N')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XSEVERITY' ,CategoryName = 'XSEVERITY',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'Valley - Customizations #955',UserDefinedCategory = 'N',HasSubcodes = 'N' WHERE CategoryName = 'XSEVERITY' AND Category = 'XSEVERITY'
END

DELETE FROM GlobalCodes WHERE Category = 'XSEVERITY'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('XSEVERITY','1','Valley - Customizations #955','Y','N',1),
('XSEVERITY','2','Valley - Customizations #955','Y','N',2),
('XSEVERITY','3','Valley - Customizations #955','Y','N',3),
('XSEVERITY','4','Valley - Customizations #955','Y','N',4),
('XSEVERITY','5','Valley - Customizations #955','Y','N',5)

-- Frequency One

IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XFrequencyOne' AND Category = 'XFrequencyOne')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes)
	VALUES ('XFrequencyOne','XFrequencyOne','Y','Y','Y','Y','Valley - Customizations #955','N','N')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XFrequencyOne' ,CategoryName = 'XFrequencyOne',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'Valley - Customizations #955',UserDefinedCategory = 'N',HasSubcodes = 'N' WHERE CategoryName = 'XFrequencyOne' AND Category = 'XFrequencyOne'
END

DELETE FROM GlobalCodes WHERE Category = 'XFrequencyOne'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('XFrequencyOne','1','Valley - Customizations #955','Y','N',1),
('XFrequencyOne','2','Valley - Customizations #955','Y','N',2),
('XFrequencyOne','3','Valley - Customizations #955','Y','N',3),
('XFrequencyOne','4','Valley - Customizations #955','Y','N',4),
('XFrequencyOne','5','Valley - Customizations #955','Y','N',5),
('XFrequencyOne','6','Valley - Customizations #955','Y','N',6),
('XFrequencyOne','7','Valley - Customizations #955','Y','N',7),
('XFrequencyOne','8','Valley - Customizations #955','Y','N',8),
('XFrequencyOne','9','Valley - Customizations #955','Y','N',9),
('XFrequencyOne','10','Valley - Customizations #955','Y','N',10),
('XFrequencyOne','11','Valley - Customizations #955','Y','N',11),
('XFrequencyOne','12','Valley - Customizations #955','Y','N',12),
('XFrequencyOne','13','Valley - Customizations #955','Y','N',13),
('XFrequencyOne','14','Valley - Customizations #955','Y','N',14),
('XFrequencyOne','15','Valley - Customizations #955','Y','N',15),
('XFrequencyOne','16','Valley - Customizations #955','Y','N',16),
('XFrequencyOne','17','Valley - Customizations #955','Y','N',17),
('XFrequencyOne','18','Valley - Customizations #955','Y','N',18),
('XFrequencyOne','19','Valley - Customizations #955','Y','N',19),
('XFrequencyOne','20+','Valley - Customizations #955','Y','N',20)

-- Frequency Two

IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XFrequencyTwo' AND Category = 'XFrequencyTwo')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes)
	VALUES ('XFrequencyTwo','XFrequencyTwo','Y','Y','Y','Y','Valley - Customizations #955','N','N')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XFrequencyTwo' ,CategoryName = 'XFrequencyTwo',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'Valley - Customizations #955',UserDefinedCategory = 'N',HasSubcodes = 'N' WHERE CategoryName = 'XFrequencyTwo' AND Category = 'XFrequencyTwo'
END

DELETE FROM GlobalCodes WHERE Category = 'XFrequencyTwo'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('XFrequencyTwo','1','Valley - Customizations #955','Y','N',1),
('XFrequencyTwo','2','Valley - Customizations #955','Y','N',2),
('XFrequencyTwo','3','Valley - Customizations #955','Y','N',3),
('XFrequencyTwo','4','Valley - Customizations #955','Y','N',4),
('XFrequencyTwo','5','Valley - Customizations #955','Y','N',5),
('XFrequencyTwo','6','Valley - Customizations #955','Y','N',6),
('XFrequencyTwo','7','Valley - Customizations #955','Y','N',7),
('XFrequencyTwo','8','Valley - Customizations #955','Y','N',8),
('XFrequencyTwo','9','Valley - Customizations #955','Y','N',9),
('XFrequencyTwo','10+','Valley - Customizations #955','Y','N',10)

-- Duration

--IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XDuration' AND Category = 'XDuration')
--BEGIN
--	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes)
--	VALUES ('XDuration','XDuration','Y','Y','Y','Y','Valley - Customizations #955','N','N')
--END
--ELSE
--BEGIN
--	UPDATE GlobalCodeCategories SET Category = 'XDuration' ,CategoryName = 'XDuration',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'Valley - Customizations #955',UserDefinedCategory = 'N',HasSubcodes = 'N' WHERE CategoryName = 'XDuration' AND Category = 'XDuration'
--END

--DELETE FROM GlobalCodes WHERE Category = 'XDuration'

--INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
--VALUES ('XDuration','1','Valley - Customizations #955','Y','N',1),
--('XDuration','2','Valley - Customizations #955','Y','N',2),
--('XDuration','3','Valley - Customizations #955','Y','N',3),
--('XDuration','4','Valley - Customizations #955','Y','N',4),
--('XDuration','5','Valley - Customizations #955','Y','N',5)


-- GlobalCodes for "Controllability","Deterrents" and "Reasons for Ideation"

IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XConDetReason' AND Category = 'XConDetReason')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes)
	VALUES ('XConDetReason','XConDetReason','Y','Y','Y','Y','Valley - Customizations #955','N','N')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XConDetReason' ,CategoryName = 'XConDetReason',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'Valley - Customizations #955',UserDefinedCategory = 'N',HasSubcodes = 'N' WHERE CategoryName = 'XConDetReason' AND Category = 'XConDetReason'
END

DELETE FROM GlobalCodes WHERE Category = 'XConDetReason'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('XConDetReason','1','Valley - Customizations #955','Y','N',1),
('XConDetReason','2','Valley - Customizations #955','Y','N',2),
('XConDetReason','3','Valley - Customizations #955','Y','N',3),
('XConDetReason','4','Valley - Customizations #955','Y','N',4),
('XConDetReason','5','Valley - Customizations #955','Y','N',5),
('XConDetReason','0','Valley - Customizations #955','Y','N',6)

-- GlobalCodes for Actual Lethality 

IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XActualLethality' AND Category = 'XActualLethality')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes)
	VALUES ('XActualLethality','XActualLethality','Y','Y','Y','Y','Valley - Customizations #955','N','N')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XActualLethality' ,CategoryName = 'XActualLethality',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'Valley - Customizations #955',UserDefinedCategory = 'N',HasSubcodes = 'N' WHERE CategoryName = 'XActualLethality' AND Category = 'XActualLethality'
END

DELETE FROM GlobalCodes WHERE Category = 'XActualLethality'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('XActualLethality','0 - No physical damage or very minor','Valley - Customizations #955','Y','N',1),
('XActualLethality','1 - Minor physical damage','Valley - Customizations #955','Y','N',2),
('XActualLethality','2 - Moderate physical damage','Valley - Customizations #955','Y','N',3),
('XActualLethality','3 - Moderately severe physical damage','Valley - Customizations #955','Y','N',4),
('XActualLethality','4 - Severe physical damage','Valley - Customizations #955','Y','N',5),
('XActualLethality','5 - Death','Valley - Customizations #955','Y','N',6)

-- GlobalCodes for Potential Lethality 

IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XPotentialLethality' AND Category = 'XPotentialLethality')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes)
	VALUES ('XPotentialLethality','XPotentialLethality','Y','Y','Y','Y','Valley - Customizations #955','N','N')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XPotentialLethality' ,CategoryName = 'XPotentialLethality',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'Valley - Customizations #955',UserDefinedCategory = 'N',HasSubcodes = 'N' WHERE CategoryName = 'XPotentialLethality' AND Category = 'XPotentialLethality'
END

DELETE FROM GlobalCodes WHERE Category = 'XPotentialLethality'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('XPotentialLethality','0 - Behavior not likely to result in injury','Valley - Customizations #955','Y','N',1),
('XPotentialLethality','1 - Behavior likely to result in injury but not likely to cause death','Valley - Customizations #955','Y','N',2),
('XPotentialLethality','2 - Behavior likely to result in death despite available medical care','Valley - Customizations #955','Y','N',3)