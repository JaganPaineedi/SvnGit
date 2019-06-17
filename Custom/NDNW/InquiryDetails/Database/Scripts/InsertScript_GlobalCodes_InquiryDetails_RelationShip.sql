/********************************************************************************************
Author    :  Malathi Shiva 
CreatedDate  :  18 Dec 2014 
Purpose    :  Insert/Update script to modify existing GlobalCodes.CodeName as per the clients requirement
*********************************************************************************************/
DELETE FROM GlobalCodes where Category = 'RELATIONSHIP' and GlobalCodeId >10000
  
INSERT INTO [GlobalCodes] 
            ([Category] 
             ,[CodeName] 
             ,[Code] 
             ,[Active] 
             ,[CannotModifyNameOrDelete] 
             ,[ExternalCode1]) 
VALUES     ('RELATIONSHIP' 
            ,'Aunt' 
            ,'Aunt' 
            ,'Y' 
            ,'N' 
            ,'34') 

INSERT INTO [GlobalCodes] 
            ([Category] 
             ,[CodeName] 
             ,[Code] 
             ,[Active] 
             ,[CannotModifyNameOrDelete] 
             ,[ExternalCode1]) 
VALUES     ('RELATIONSHIP' 
            ,'Brother' 
            ,'Brother' 
            ,'Y' 
            ,'N' 
            ,'34') 

INSERT INTO [GlobalCodes] 
            ([Category] 
             ,[CodeName] 
             ,[Code] 
             ,[Active] 
             ,[CannotModifyNameOrDelete] 
             ,[ExternalCode1]) 
VALUES     ('RELATIONSHIP' 
            ,'Court' 
            ,'Court' 
            ,'Y' 
            ,'N' 
            ,'34') 

INSERT INTO [GlobalCodes] 
            ([Category] 
             ,[CodeName] 
             ,[Code] 
             ,[Active] 
             ,[CannotModifyNameOrDelete] 
             ,[ExternalCode1]) 
VALUES     ('RELATIONSHIP' 
            ,'Daughter' 
            ,'Daughter' 
            ,'Y' 
            ,'N' 
            ,'19') 

INSERT INTO [GlobalCodes] 
            ([Category] 
             ,[CodeName] 
             ,[Code] 
             ,[Active] 
             ,[CannotModifyNameOrDelete] 
             ,[ExternalCode1]) 
VALUES     ('RELATIONSHIP' 
            ,'DCFS Staff' 
            ,'DCFSStaff' 
            ,'Y' 
            ,'N' 
            ,'34') 

INSERT INTO [GlobalCodes] 
            ([Category] 
             ,[CodeName] 
             ,[Code] 
             ,[Active] 
             ,[CannotModifyNameOrDelete] 
             ,[ExternalCode1]) 
VALUES     ('RELATIONSHIP' 
            ,'Employer' 
            ,'Employer' 
            ,'Y' 
            ,'N' 
            ,'34') 

INSERT INTO [GlobalCodes] 
            ([Category] 
             ,[CodeName] 
             ,[Code] 
             ,[Active] 
             ,[CannotModifyNameOrDelete] 
             ,[ExternalCode1]) 
VALUES     ('RELATIONSHIP' 
            ,'EMT/Ambulance' 
            ,'EMTAmbulance' 
            ,'Y' 
            ,'N' 
            ,'34') 

INSERT INTO [GlobalCodes] 
            ([Category] 
             ,[CodeName] 
             ,[Code] 
             ,[Active] 
             ,[CannotModifyNameOrDelete] 
             ,[ExternalCode1]) 
VALUES     ('RELATIONSHIP' 
            ,'Father' 
            ,'Father' 
            ,'Y' 
            ,'N' 
            ,'19') 

INSERT INTO [GlobalCodes] 
            ([Category] 
             ,[CodeName] 
             ,[Code] 
             ,[Active] 
             ,[CannotModifyNameOrDelete] 
             ,[ExternalCode1]) 
VALUES     ('RELATIONSHIP' 
            ,'Foster Daughter' 
            ,'FosterDaughter' 
            ,'Y' 
            ,'N' 
            ,'19') 

INSERT INTO [GlobalCodes] 
            ([Category] 
             ,[CodeName] 
             ,[Code] 
             ,[Active] 
             ,[CannotModifyNameOrDelete] 
             ,[ExternalCode1]) 
VALUES     ('RELATIONSHIP' 
            ,'Foster Father' 
            ,'FosterFather' 
            ,'Y' 
            ,'N' 
            ,'34') 

INSERT INTO [GlobalCodes] 
            ([Category] 
             ,[CodeName] 
             ,[Code] 
             ,[Active] 
             ,[CannotModifyNameOrDelete] 
             ,[ExternalCode1]) 
VALUES     ('RELATIONSHIP' 
            ,'Foster Mother' 
            ,'FosterMother' 
            ,'Y' 
            ,'N' 
            ,'34') 

INSERT INTO [GlobalCodes] 
            ([Category] 
             ,[CodeName] 
             ,[Code] 
             ,[Active] 
             ,[CannotModifyNameOrDelete] 
             ,[ExternalCode1]) 
VALUES     ('RELATIONSHIP' 
            ,'Foster Son' 
            ,'FosterSon' 
            ,'Y' 
            ,'N' 
            ,'19') 

INSERT INTO [GlobalCodes] 
            ([Category] 
             ,[CodeName] 
             ,[Code] 
             ,[Active] 
             ,[CannotModifyNameOrDelete] 
             ,[ExternalCode1]) 
VALUES     ('RELATIONSHIP' 
            ,'Friend' 
            ,'Friend' 
            ,'Y' 
            ,'N' 
            ,'34') 

INSERT INTO [GlobalCodes] 
            ([Category] 
             ,[CodeName] 
             ,[Code] 
             ,[Active] 
             ,[CannotModifyNameOrDelete] 
             ,[ExternalCode1]) 
VALUES     ('RELATIONSHIP' 
            ,'Granddaughter' 
            ,'Granddaughter' 
            ,'Y' 
            ,'N' 
            ,'19') 

INSERT INTO [GlobalCodes] 
            ([Category] 
             ,[CodeName] 
             ,[Code] 
             ,[Active] 
             ,[CannotModifyNameOrDelete] 
             ,[ExternalCode1]) 
VALUES     ('RELATIONSHIP' 
            ,'Grandfather' 
            ,'Grandfather' 
            ,'Y' 
            ,'N' 
            ,'34') 

INSERT INTO [GlobalCodes] 
            ([Category] 
             ,[CodeName] 
             ,[Code] 
             ,[Active] 
             ,[CannotModifyNameOrDelete] 
             ,[ExternalCode1]) 
VALUES     ('RELATIONSHIP' 
            ,'Grandmother' 
            ,'Grandmother' 
            ,'Y' 
            ,'N' 
            ,'34') 

INSERT INTO [GlobalCodes] 
            ([Category] 
             ,[CodeName] 
             ,[Code] 
             ,[Active] 
             ,[CannotModifyNameOrDelete] 
             ,[ExternalCode1]) 
VALUES     ('RELATIONSHIP' 
            ,'Grandson' 
            ,'Grandson' 
            ,'Y' 
            ,'N' 
            ,'19') 

INSERT INTO [GlobalCodes] 
            ([Category] 
             ,[CodeName] 
             ,[Code] 
             ,[Active] 
             ,[CannotModifyNameOrDelete] 
             ,[ExternalCode1]) 
VALUES     ('RELATIONSHIP' 
            ,'Husband' 
            ,'Husband' 
            ,'Y' 
            ,'N' 
            ,'01') 

INSERT INTO [GlobalCodes] 
            ([Category] 
             ,[CodeName] 
             ,[Code] 
             ,[Active] 
             ,[CannotModifyNameOrDelete] 
             ,[ExternalCode1]) 
VALUES     ('RELATIONSHIP' 
            ,'Law Enforcement Official' 
            ,'LawEnforcementOfficial' 
            ,'Y' 
            ,'N' 
            ,'34') 

INSERT INTO [GlobalCodes] 
            ([Category] 
             ,[CodeName] 
             ,[Code] 
             ,[Active] 
             ,[CannotModifyNameOrDelete] 
             ,[ExternalCode1]) 
VALUES     ('RELATIONSHIP' 
            ,'Legal Guardian' 
            ,'LegalGuardian' 
            ,'Y' 
            ,'N' 
            ,'34') 

INSERT INTO [GlobalCodes] 
            ([Category] 
             ,[CodeName] 
             ,[Code] 
             ,[Active] 
             ,[CannotModifyNameOrDelete] 
             ,[ExternalCode1]) 
VALUES     ('RELATIONSHIP' 
            ,'Mother' 
            ,'Mother' 
            ,'Y' 
            ,'N' 
            ,'19') 

INSERT INTO [GlobalCodes] 
            ([Category] 
             ,[CodeName] 
             ,[Code] 
             ,[Active] 
             ,[CannotModifyNameOrDelete] 
             ,[ExternalCode1]) 
VALUES     ('RELATIONSHIP' 
            ,'None' 
            ,'None' 
            ,'Y' 
            ,'N' 
            ,'34') 

INSERT INTO [GlobalCodes] 
            ([Category] 
             ,[CodeName] 
             ,[Code] 
             ,[Active] 
             ,[CannotModifyNameOrDelete] 
             ,[ExternalCode1]) 
VALUES     ('RELATIONSHIP' 
            ,'Other' 
            ,'Other' 
            ,'Y' 
            ,'N' 
            ,'34') 

INSERT INTO [GlobalCodes] 
            ([Category] 
             ,[CodeName] 
             ,[Code] 
             ,[Active] 
             ,[CannotModifyNameOrDelete] 
             ,[ExternalCode1]) 
VALUES     ('RELATIONSHIP' 
            ,'Sister' 
            ,'Sister' 
            ,'Y' 
            ,'N' 
            ,'34') 

INSERT INTO [GlobalCodes] 
            ([Category] 
             ,[CodeName] 
             ,[Code] 
             ,[Active] 
             ,[CannotModifyNameOrDelete] 
             ,[ExternalCode1]) 
VALUES     ('RELATIONSHIP' 
            ,'Son' 
            ,'Son' 
            ,'Y' 
            ,'N' 
            ,'19') 

INSERT INTO [GlobalCodes] 
            ([Category] 
             ,[CodeName] 
             ,[Code] 
             ,[Active] 
             ,[CannotModifyNameOrDelete] 
             ,[ExternalCode1]) 
VALUES     ('RELATIONSHIP' 
            ,'Stepdaughter' 
            ,'Stepdaughter' 
            ,'Y' 
            ,'N' 
            ,'34') 

INSERT INTO [GlobalCodes] 
            ([Category] 
             ,[CodeName] 
             ,[Code] 
             ,[Active] 
             ,[CannotModifyNameOrDelete] 
             ,[ExternalCode1]) 
VALUES     ('RELATIONSHIP' 
            ,'Stepfather' 
            ,'Stepfather' 
            ,'Y' 
            ,'N' 
            ,'34') 

INSERT INTO [GlobalCodes] 
            ([Category] 
             ,[CodeName] 
             ,[Code] 
             ,[Active] 
             ,[CannotModifyNameOrDelete] 
             ,[ExternalCode1]) 
VALUES     ('RELATIONSHIP' 
            ,'Stepmother' 
            ,'Stepmother' 
            ,'Y' 
            ,'N' 
            ,'34') 

INSERT INTO [GlobalCodes] 
            ([Category] 
             ,[CodeName] 
             ,[Code] 
             ,[Active] 
             ,[CannotModifyNameOrDelete] 
             ,[ExternalCode1]) 
VALUES     ('RELATIONSHIP' 
            ,'Stepson' 
            ,'Stepson' 
            ,'Y' 
            ,'N' 
            ,'19') 

INSERT INTO [GlobalCodes] 
            ([Category] 
             ,[CodeName] 
             ,[Code] 
             ,[Active] 
             ,[CannotModifyNameOrDelete] 
             ,[ExternalCode1]) 
VALUES     ('RELATIONSHIP' 
            ,'Uncle' 
            ,'Uncle' 
            ,'Y' 
            ,'N' 
            ,'34') 

INSERT INTO [GlobalCodes] 
            ([Category] 
             ,[CodeName] 
             ,[Code] 
             ,[Active] 
             ,[CannotModifyNameOrDelete] 
             ,[ExternalCode1]) 
VALUES     ('RELATIONSHIP' 
            ,'Unknown' 
            ,'Unknown' 
            ,'Y' 
            ,'N' 
            ,'34') 

INSERT INTO [GlobalCodes] 
            ([Category] 
             ,[CodeName] 
             ,[Code] 
             ,[Active] 
             ,[CannotModifyNameOrDelete] 
             ,[ExternalCode1]) 
VALUES     ('RELATIONSHIP' 
            ,'Wife' 
            ,'Wife' 
            ,'Y' 
            ,'N' 
            ,'01') 

INSERT INTO [GlobalCodes] 
            ([Category] 
             ,[CodeName] 
             ,[Code] 
             ,[Active] 
             ,[CannotModifyNameOrDelete] 
             ,[ExternalCode1]) 
VALUES     ('RELATIONSHIP' 
            ,'Advocate' 
            ,'Advocate' 
            ,'Y' 
            ,'N' 
            ,'34') 

INSERT INTO [GlobalCodes] 
            ([Category] 
             ,[CodeName] 
             ,[Code] 
             ,[Active] 
             ,[CannotModifyNameOrDelete] 
             ,[ExternalCode1]) 
VALUES     ('RELATIONSHIP' 
            ,'Primary Physician' 
            ,'PrimaryPhysician' 
            ,'Y' 
            ,'N' 
            ,'34') 

INSERT INTO [GlobalCodes] 
            ([Category] 
             ,[CodeName] 
             ,[Code] 
             ,[Active] 
             ,[CannotModifyNameOrDelete] 
             ,[ExternalCode1]) 
VALUES     ('RELATIONSHIP' 
            ,'Next of Kin' 
            ,'NextofKin' 
            ,'Y' 
            ,'N' 
            ,'34') 

INSERT INTO [GlobalCodes] 
            ([Category] 
             ,[CodeName] 
             ,[Code] 
             ,[Active] 
             ,[CannotModifyNameOrDelete] 
             ,[ExternalCode1]) 
VALUES     ('RELATIONSHIP' 
            ,'Parent' 
            ,'Parent' 
            ,'Y' 
            ,'N' 
            ,'19') 

INSERT INTO [GlobalCodes] 
            ([Category] 
             ,[CodeName] 
             ,[Code] 
             ,[Active] 
             ,[CannotModifyNameOrDelete] 
             ,[ExternalCode1]) 
VALUES     ('RELATIONSHIP' 
            ,'Grandparent' 
            ,'Grandparent' 
            ,'Y' 
            ,'N' 
            ,'19') 

INSERT INTO [GlobalCodes] 
            ([Category] 
             ,[CodeName] 
             ,[Code] 
             ,[Active] 
             ,[CannotModifyNameOrDelete] 
             ,[ExternalCode1]) 
VALUES     ('RELATIONSHIP' 
            ,'New Choices Waiver' 
            ,'NewChoicesWaiver' 
            ,'Y' 
            ,'N' 
            ,NULL) 
            
            
GO
  
    
  