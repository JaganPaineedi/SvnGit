/********************************************************************************************
Author    :  SuryaBalan 
ModifiedDate  :  04 March 2015  
Purpose    :  Insert/Update script to modify existing GlobalCodes.CodeName[XINQUIRYPSOURCE] as per the clients requirement for Task 5 Client Inquiries-New Directions Project
*********************************************************************************************/
-- Primary Source of Income--

IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XINQUIRYPSOURCE' AND Category = 'XINQUIRYPSOURCE')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('XINQUIRYPSOURCE','XINQUIRYPSOURCE','Y','Y','Y','Y','Valley - Customizations #948','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XINQUIRYPSOURCE' ,CategoryName = 'XINQUIRYPSOURCE',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'Valley - Customizations #948',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XINQUIRYPSOURCE' AND Category = 'XINQUIRYPSOURCE'
END

DELETE FROM GlobalCodes WHERE Category = 'XINQUIRYPSOURCE'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,Code)
VALUES 
('XINQUIRYPSOURCE','Legal Employment','Valley - Customizations #948','Y','N',1,1),
('XINQUIRYPSOURCE','Welfare, Public Assistance','Valley - Customizations #948','Y','N',2,2),
('XINQUIRYPSOURCE','Pension, Retirement Benefits, Social Security','Valley - Customizations #948','Y','N',3,3),
('XINQUIRYPSOURCE','Disability, Workers Compensation','Valley - Customizations #948','Y','N',4,4),
('XINQUIRYPSOURCE','Other','Valley - Customizations #948','Y','N',5,5),
('XINQUIRYPSOURCE','None','Valley - Customizations #948','Y','N',6,6),
('XINQUIRYPSOURCE','Unknown','Valley - Customizations #948','Y','N',7,7)


