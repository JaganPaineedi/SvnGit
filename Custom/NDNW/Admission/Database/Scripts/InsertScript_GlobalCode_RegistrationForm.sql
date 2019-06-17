                                                                                   
 DELETE
           FROM   GlobalCodes 
           WHERE  Category = 'XREGISTRATIONFORM' 
                  AND Active = 'Y' and GlobalCodeId > 10000

IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodeCategories WHERE Category ='XREGISTRATIONFORM' AND CategoryName='XREGISTRATIONFORM')
 BEGIN
  Insert into GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory,HasSubcodes)
  values('XREGISTRATIONFORM','XREGISTRATIONFORM','Y','N','N','Y','N','N')
 END
 
IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'XREGISTRATIONFORM' AND CodeName='Advanced Healthcare Directive Brochure')
 BEGIN
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('XREGISTRATIONFORM','Individual Rights','AHDB','Y','Y',1)
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'XREGISTRATIONFORM' AND CodeName='Client Fee Agreement')
 BEGIN
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('XREGISTRATIONFORM','Complaint and Grievance Process','CFA','Y','Y',2)
 END
 
  IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'XREGISTRATIONFORM' AND CodeName='Consent to Treatment')
 BEGIN
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('XREGISTRATIONFORM','Notice of Privacy Practices','CT','Y','Y',3)
 END
 
  IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'XREGISTRATIONFORM' AND CodeName='Client Rights and Responsibilities')
 BEGIN
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('XREGISTRATIONFORM','Mental Health Advance Directive Information','CRR','Y','Y',4)
 END
 
  IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'XREGISTRATIONFORM' AND CodeName='Medicaid Handbook')
 BEGIN
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('XREGISTRATIONFORM','Rules associated with Substance Abuse/Gambling Treatment Enrollment','MH','Y','Y',5)
 END
 
  IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'XREGISTRATIONFORM' AND CodeName='Privacy Notice')
 BEGIN
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('XREGISTRATIONFORM','HIPAA','PN','Y','Y',6)
 END
  IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'XREGISTRATIONFORM' AND CodeName='Consent to Treatment')
 BEGIN
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('XREGISTRATIONFORM','Consent to Treatment','CTT','Y','Y',7)
 END
 
 
 