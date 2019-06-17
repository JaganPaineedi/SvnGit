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




IF NOT EXISTS (SELECT * FROM [procedurecodes] WHERE [ProcedureCodeId] = 24) BEGIN SET IDENTITY_INSERT [procedurecodes] ON 
insert into [procedurecodes] ([ProcedureCodeId],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedDate],[DeletedBy],[DisplayAs],[ProcedureCodeName],
[Active],[AllowDecimals],[EnteredAs],[NotBillable],[DoesNotRequireStaffForService],[NotOnCalendar],[FaceToFace],[GroupCode],[MedicationCode],[EndDateEqualsStartDate],
[RequiresTimeInTimeOut],[RequiresSignedNote],[AssociatedNoteId],[MinUnits],[MaxUnits],[UnitIncrements],[UnitsList],[ExternalCode1],[ExternalSource1],[ExternalCode2],[ExternalSource2],
[CreditPercentage],[Category1],[Category2],[Category3],[DisplayDocumentAsProcedureCode],[AllowModifiersOnService],[AllowAllPrograms],[AllowAllLicensesDegrees])
VALUES(24,'shs','Apr 19 2013  4:19:46:410AM','shs','Apr 19 2013  4:19:46:410AM',NULL,NULL,NULL,'ASSESSMENT','ASSESSMENT','Y','N',110,'N','N','Y','N','N',NULL,'N','N','N',NULL,NULL,NULL,NULL,NULL,'ASSESSMENT',NULL,NULL,NULL,100,NULL,NULL,NULL,NULL,NULL,NULL,NULL)SET IDENTITY_INSERT [procedurecodes] OFF END
 

