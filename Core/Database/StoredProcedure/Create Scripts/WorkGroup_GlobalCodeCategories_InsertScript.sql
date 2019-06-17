--Script by Veena on 05/19/2016 for EI #340
IF NOT EXISTS(Select Category from GlobalCodeCategories where Category='WorkGroup')
BEGIN
insert into GlobalCodeCategories(Category
,CategoryName
,Active
,AllowAddDelete
,AllowCodeNameEdit
,AllowSortOrderEdit
,Description
,UserDefinedCategory

,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate)
Values
('WorkGroup','Work Group','Y','Y','Y','Y','Work Group for ClientNotes','N','Admin',GETDATE(),'Admin',GETDATE())
END