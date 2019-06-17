/********************************************************************************                                                   
--  
-- Copyright: Streamline Healthcare Solutions  
-- "Registration Document"
-- Purpose: Global Code XEDUCATIONALLEVEL Task #954 - Valley - Customizations.
--  
-- Author:  Akwinass
-- Date:    30-DEC-2014
--  
-- *****History****  
-- 30-DEC-2014     Akwinass           changed global code from EDUCATIONALSTATUS to XEDUCATIONALLEVEL
*********************************************************************************/
UPDATE FormItems SET GlobalCodeCategory = 'XEDUCATIONALLEVEL' FROM FormItems WHERE FormSectionId = 294 and ItemColumnName = 'EducationalLevel' and GlobalCodeCategory = 'EDUCATIONALSTATUS'

IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XEDUCATIONALLEVEL' AND Category = 'XEDUCATIONALLEVEL')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('XEDUCATIONALLEVEL','XEDUCATIONALLEVEL','Y','Y','Y','Y','Valley - Customizations #964.1','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XEDUCATIONALLEVEL' ,CategoryName = 'XEDUCATIONALLEVEL',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'Valley - Customizations #954',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XEDUCATIONALLEVEL' AND Category = 'XEDUCATIONALLEVEL'
END

DELETE FROM GlobalCodes WHERE Category = 'XEDUCATIONALLEVEL'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('XEDUCATIONALLEVEL','Preschool/Nursery/Head St','Valley - Customizations #964.1','Y','N',1),
('XEDUCATIONALLEVEL','Kindergarten','Valley - Customizations #964.1','Y','N',2),
('XEDUCATIONALLEVEL','1st Grade','Valley - Customizations #964.1','Y','N',3),
('XEDUCATIONALLEVEL','2nd Grade','Valley - Customizations #964.1','Y','N',4),
('XEDUCATIONALLEVEL','3rd Grade','Valley - Customizations #964.1','Y','N',5),
('XEDUCATIONALLEVEL','4th Grade','Valley - Customizations #964.1','Y','N',6),
('XEDUCATIONALLEVEL','5th Grade','Valley - Customizations #964.1','Y','N',7),
('XEDUCATIONALLEVEL','6th Grade','Valley - Customizations #964.1','Y','N',8),
('XEDUCATIONALLEVEL','7th Grade','Valley - Customizations #964.1','Y','N',9),
('XEDUCATIONALLEVEL','8th Grade','Valley - Customizations #964.1','Y','N',10),
('XEDUCATIONALLEVEL','9th Grade','Valley - Customizations #964.1','Y','N',11),
('XEDUCATIONALLEVEL','10th Grade','Valley - Customizations #964.1','Y','N',12),
('XEDUCATIONALLEVEL','11th Grade','Valley - Customizations #964.1','Y','N',13),
('XEDUCATIONALLEVEL','12th Grade','Valley - Customizations #964.1','Y','N',14),
('XEDUCATIONALLEVEL','High School Graduate','Valley - Customizations #964.1','Y','N',15),
('XEDUCATIONALLEVEL','Post High School Program','Valley - Customizations #964.1','Y','N',16),
('XEDUCATIONALLEVEL','College Graduate','Valley - Customizations #964.1','Y','N',17),
('XEDUCATIONALLEVEL','Some Graduate School','Valley - Customizations #964.1','Y','N',18),
('XEDUCATIONALLEVEL','Graduate School Graduate','Valley - Customizations #964.1','Y','N',19),
('XEDUCATIONALLEVEL','Never Attended School','Valley - Customizations #964.1','Y','N',20),
('XEDUCATIONALLEVEL','Special Education','Valley - Customizations #964.1','Y','N',21),
('XEDUCATIONALLEVEL','Vocational','Valley - Customizations #964.1','Y','N',22)


