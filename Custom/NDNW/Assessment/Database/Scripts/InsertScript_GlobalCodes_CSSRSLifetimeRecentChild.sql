IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'FREQUENCYONE' AND Category = 'FREQUENCYONE')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes)
	VALUES ('FREQUENCYONE','FREQUENCYONE','Y','Y','Y','Y','Valley - Customizations #968','N','N')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'FREQUENCYONE' ,CategoryName = 'FREQUENCYONE',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'Valley - Customizations #968',UserDefinedCategory = 'N',HasSubcodes = 'N' WHERE CategoryName = 'FREQUENCYONE' AND Category = 'FREQUENCYONE'
END

DELETE FROM GlobalCodes WHERE Category = 'FREQUENCYONE'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('FREQUENCYONE','1','Valley - Customizations #968','Y','N',1),
('FREQUENCYONE','2','Valley - Customizations #968','Y','N',2),
('FREQUENCYONE','3','Valley - Customizations #968','Y','N',3),
('FREQUENCYONE','4','Valley - Customizations #968','Y','N',4),
('FREQUENCYONE','5','Valley - Customizations #968','Y','N',5),
('FREQUENCYONE','6','Valley - Customizations #968','Y','N',6)

-- Frequency Two

IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'FREQUENCYTWO' AND Category = 'FREQUENCYTWO')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes)
	VALUES ('FREQUENCYTWO','FREQUENCYTWO','Y','Y','Y','Y','Valley - Customizations #968','N','N')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'FREQUENCYTWO' ,CategoryName = 'FREQUENCYTWO',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'Valley - Customizations #968',UserDefinedCategory = 'N',HasSubcodes = 'N' WHERE CategoryName = 'FREQUENCYTWO' AND Category = 'FREQUENCYTWO'
END

DELETE FROM GlobalCodes WHERE Category = 'FREQUENCYTWO'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('FREQUENCYTWO','1','Valley - Customizations #968','Y','N',1),
('FREQUENCYTWO','2','Valley - Customizations #968','Y','N',2),
('FREQUENCYTWO','3','Valley - Customizations #968','Y','N',3),
('FREQUENCYTWO','4','Valley - Customizations #968','Y','N',4),
('FREQUENCYTWO','5','Valley - Customizations #968','Y','N',5)