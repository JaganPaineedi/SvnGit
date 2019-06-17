 DELETE
           FROM   GlobalCodes 
           WHERE  Category = 'Xdischargeclientype' 
                  AND Active = 'Y' and GlobalCodeId > 10000
                  
                  IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodeCategories WHERE Category ='Xdischargeclientype' AND CategoryName='Xdischargeclientype')
 BEGIN
  Insert into GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory,HasSubcodes)
  values('Xdischargeclientype','Xdischargeclientype','Y','N','N','Y','N','N')
 END
 
IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'Xdischargeclientype' AND CodeName='Inpatient Mental Health')
 BEGIN
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('Xdischargeclientype','Inpatient Mental Health','AHDB','Y','Y',1)
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'Xdischargeclientype' AND CodeName='Medication Management')
 BEGIN
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('Xdischargeclientype','Medication Management','AHDB','Y','Y',1)
 END
 
  IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'Xdischargeclientype' AND CodeName='Outpatient Mental Health')
 BEGIN
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('Xdischargeclientype','Outpatient Mental Health','AHDB','Y','Y',1)
 END
 
   IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'Xdischargeclientype' AND CodeName='Supported Living')
 BEGIN
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('Xdischargeclientype','Supported Living','AHDB','Y','Y',1)
 END
 
   IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'Xdischargeclientype' AND CodeName='Other')
 BEGIN
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('Xdischargeclientype','Other','AHDB','Y','Y',1)
 END
 
  
   IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'Xdischargeclientype' AND CodeName='None')
 BEGIN
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('Xdischargeclientype','None','AHDB','Y','Y',1)
 END