/******************************************************************************                        
**  Name: Insert Script for GlobalCodeCategories                      
**  Desc: [Category] = 'XLEVELOFCARE'  
*******************************************************************************                        
**  Change History                        
*******************************************************************************                        
**  Date:          Author:          Description:    
    29/04/2013     Veena            Globalcodes for Level Of Care       
*******************************************************************************/ 
IF NOT EXISTS (SELECT 1 FROM dbo.[GlobalCodeCategories] WHERE [Category] = 'XLEVELOFCARE')
begin
INSERT INTO GLOBALCODECATEGORIES (Category
,CategoryName
,Active
,AllowAddDelete
,AllowCodeNameEdit
,AllowSortOrderEdit
,Description
,UserDefinedCategory
,HasSubcodes
,UsedInPracticeManagement
,UsedInCareManagement
,ExternalReferenceId
,RowIdentifier
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate)
VALUES ('XLEVELOFCARE','Level Of Care','Y','Y','Y','Y',NULL,'N','N',NULL,NULL,NULL,NEWID(),'vmani',GETDATE(),'vmani',GETDATE())
end

DELETE FROM GlobalCodes where RTRIM(LTRIM(Category)) ='XLEVELOFCARE'
 
INSERT INTO GLOBALCODES (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
VALUES('vmani',getdate(),'vmani',GETDATE(),'XLEVELOFCARE','Level I OP Tx','Y','Y',1)
INSERT INTO GLOBALCODES (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
VALUES('vmani',getdate(),'vmani',GETDATE(),'XLEVELOFCARE','Level II.1 IOP','Y','Y',2)
INSERT INTO GLOBALCODES (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
VALUES('vmani',getdate(),'vmani',GETDATE(),'XLEVELOFCARE','Level II.5 Partial','Y','Y',3)
INSERT INTO GLOBALCODES (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
VALUES('vmani',getdate(),'vmani',GETDATE(),'XLEVELOFCARE','Level II.1 Res (Low)','Y','Y',4)
INSERT INTO GLOBALCODES (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
VALUES('vmani',getdate(),'vmani',GETDATE(),'XLEVELOFCARE','N/A','Y','Y',5)
 

