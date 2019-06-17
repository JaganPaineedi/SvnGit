/*******************************************************************************************************************************************/  
 Delete from GlobalCodes WHERE Category = 'CLIENTFLAGSDUEDATES'
/************************************* SourceofReferral **************************************************************************/
IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodeCategories WHERE Category ='CLIENTFLAGSDUEDATES' AND CategoryName='CLIENTFLAGSDUEDATES')
 BEGIN
  Insert into GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory,HasSubcodes)
  values('CLIENTFLAGSDUEDATES','CLIENTFLAGSDUEDATES','Y','N','N','Y','N','N')
 END
 
 
IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'CLIENTFLAGSDUEDATES' AND Code='Open')
 BEGIN
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('CLIENTFLAGSDUEDATES','Open','Open','Y','Y',1)
 END
 
IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'CLIENTFLAGSDUEDATES' AND Code='Started')
BEGIN
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('CLIENTFLAGSDUEDATES','Started','Started','Y','Y',2)
 END
 
IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'CLIENTFLAGSDUEDATES' AND Code='OverDue')
BEGIN
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('CLIENTFLAGSDUEDATES','OverDue','OverDue','Y','Y',3)
 END
 
IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'CLIENTFLAGSDUEDATES' AND Code='Due in 30 days')
BEGIN
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('CLIENTFLAGSDUEDATES','Due in 30 days','Due in 30 days','Y','Y',4)
 END
 
IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'CLIENTFLAGSDUEDATES' AND Code='Due in 60-31 days')
BEGIN
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('CLIENTFLAGSDUEDATES','Due in 60-31 days','Due in 60-31 days','Y','Y',5)
 END
 
IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'CLIENTFLAGSDUEDATES' AND Code='Due in 90-61 days')
BEGIN
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('CLIENTFLAGSDUEDATES','Due in 90-61 days','Due in 90-61 days','Y','Y',6)
 END
 
IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'CLIENTFLAGSDUEDATES' AND Code='Completed')
BEGIN
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('CLIENTFLAGSDUEDATES','Completed','Completed','Y','Y',7)
 END
 