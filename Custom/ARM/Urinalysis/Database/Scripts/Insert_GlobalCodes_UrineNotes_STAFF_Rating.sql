/******************************************************************************                        
**  Name: Insert Script for Globalcodes                   
**  Desc: [Category] = 'XURINENOTESTAFRATING' 
*******************************************************************************                        
**  Change History                        
*******************************************************************************                        
**  Date:          Author:          Description:    
    18/07/2013     Manju P          XURINENOTESTAFRATING        
*******************************************************************************/ 

IF NOT EXISTS (SELECT 1 FROM dbo.[GlobalCodeCategories] WHERE [Category] = 'XURINENOTESTAFRATING')
begin
INSERT INTO GLOBALCODECATEGORIES (Category
,CategoryName
,Active
,AllowAddDelete
,AllowCodeNameEdit
,AllowSortOrderEdit
,[Description]
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
VALUES ('XURINENOTESTAFRATING','Urine Note Staff Rating','Y','Y','Y','Y',NULL,'N','N',NULL,NULL,NULL,NEWID(),'sa',GETDATE(),'sa',GETDATE())
end

DELETE FROM GlobalCodes where RTRIM(LTRIM(Category)) ='XURINENOTESTAFRATING'
 
INSERT INTO GLOBALCODES (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
VALUES('sa',getdate(),'sa',GETDATE(),'XURINENOTESTAFRATING','Not Rated','Y','Y',1)
INSERT INTO GLOBALCODES (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
VALUES('sa',getdate(),'sa',GETDATE(),'XURINENOTESTAFRATING','No Progress','Y','Y',2)
INSERT INTO GLOBALCODES (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
VALUES('sa',getdate(),'sa',GETDATE(),'XURINENOTESTAFRATING','Some Progress','Y','Y',3)
INSERT INTO GLOBALCODES (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
VALUES('sa',getdate(),'sa',GETDATE(),'XURINENOTESTAFRATING','Good Progress','Y','Y',4)

 

