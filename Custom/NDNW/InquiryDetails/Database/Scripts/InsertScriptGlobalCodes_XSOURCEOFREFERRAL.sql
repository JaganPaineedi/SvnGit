/********************************************************************************************
Author    :  SuryaBalan 
ModifiedDate  :  04 March 2015  
Purpose    :  Insert/Update script to modify existing GlobalCodes.CodeName[SOURCEOFREFERRAL] as per the clients requirement for Task 5 Client Inquiries-New Directions Project
*********************************************************************************************/
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'XSOURCEOFREFERRAL') 
	BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) 
	VALUES('XSOURCEOFREFERRAL','XSOURCEOFREFERRAL','Y','Y','Y','Y',NULL,'N','N','N','N') END 
	
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'ADES') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XSOURCEOFREFERRAL','ADES',NULL,'Y','N',1) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XSOURCEOFREFERRAL',CodeName='ADES',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=1, ExternalCode1=NULL WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'ADES' 
	
END 
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Advocacy Group') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XSOURCEOFREFERRAL','Advocacy Group',NULL,'Y','N',2) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XSOURCEOFREFERRAL',CodeName='Advocacy Group',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=2, ExternalCode1=NULL WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Advocacy Group' 
	
END 
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Aging and People with Disabilities') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XSOURCEOFREFERRAL','Aging and People with Disabilities',NULL,'Y','N',3) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XSOURCEOFREFERRAL',CodeName='Aging and People with Disabilities',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=3, ExternalCode1=NULL WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Aging and People with Disabilities' 
	
END 
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Attorney') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XSOURCEOFREFERRAL','Attorney',NULL,'Y','N',4) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XSOURCEOFREFERRAL',CodeName='Attorney',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=4, ExternalCode1=NULL WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Attorney' 
	
END 
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Child Welfare (CW)') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XSOURCEOFREFERRAL','Child Welfare (CW)',NULL,'Y','N',5) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XSOURCEOFREFERRAL',CodeName='Child Welfare (CW)',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=5, ExternalCode1=NULL WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Child Welfare (CW)' 
	
END 
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Circuit Court') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XSOURCEOFREFERRAL','Circuit Court',NULL,'Y','N',6) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XSOURCEOFREFERRAL',CodeName='Circuit Court',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=6, ExternalCode1=NULL WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Circuit Court' 
	
END 
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Coordinated Care Organization') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XSOURCEOFREFERRAL','Coordinated Care Organization',NULL,'Y','N',7) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XSOURCEOFREFERRAL',CodeName='Coordinated Care Organization',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=7, ExternalCode1=NULL WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Coordinated Care Organization' 
	
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Community Based MH or SA Provider') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XSOURCEOFREFERRAL','Community Based MH or SA Provider',NULL,'Y','N',8) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XSOURCEOFREFERRAL',CodeName='Community Based MH or SA Provider',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=8, ExternalCode1=NULL WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Community Based MH or SA Provider' 
	
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Community Housing') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XSOURCEOFREFERRAL','Community Housing',NULL,'Y','N',9) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XSOURCEOFREFERRAL',CodeName='Community Housing',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=9, ExternalCode1=NULL WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Community Housing' 
	
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Crisis/Helpline') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XSOURCEOFREFERRAL','Crisis/Helpline',NULL,'Y','N',10) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XSOURCEOFREFERRAL',CodeName='Crisis/Helpline',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=10, ExternalCode1=NULL WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Crisis/Helpline' 
	
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Developmental Disabilities') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XSOURCEOFREFERRAL','Developmental Disabilities',NULL,'Y','N',11) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XSOURCEOFREFERRAL',CodeName='Developmental Disabilities',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=11, ExternalCode1=NULL WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Developmental Disabilities' 
	
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Employment Services') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XSOURCEOFREFERRAL','Employment Services',NULL,'Y','N',12) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XSOURCEOFREFERRAL',CodeName='Employment Services',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=12, ExternalCode1=NULL WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Employment Services' 
	
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Employment Services') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XSOURCEOFREFERRAL','Employment Services',NULL,'Y','N',12) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XSOURCEOFREFERRAL',CodeName='Employment Services',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=12, ExternalCode1=NULL WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Employment Services' 
	
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Employment/EAP') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XSOURCEOFREFERRAL','Employment/EAP',NULL,'Y','N',13) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XSOURCEOFREFERRAL',CodeName='Employment/EAP',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=13, ExternalCode1=NULL WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Employment/EAP' 
	
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Family/Friend') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XSOURCEOFREFERRAL','Family/Friend',NULL,'Y','N',14) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XSOURCEOFREFERRAL',CodeName='Family/Friend',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=14, ExternalCode1=NULL WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Family/Friend' 
	
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Federal Correctional Facility') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XSOURCEOFREFERRAL','Federal Correctional Facility',NULL,'Y','N',15) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XSOURCEOFREFERRAL',CodeName='Federal Correctional Facility',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=15, ExternalCode1=NULL WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Federal Correctional Facility' 
	
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Federal Court') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XSOURCEOFREFERRAL','Federal Court',NULL,'Y','N',16) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XSOURCEOFREFERRAL',CodeName='Federal Court',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=16, ExternalCode1=NULL WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Federal Court' 
	
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Integrated Treatment Court') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XSOURCEOFREFERRAL','Integrated Treatment Court',NULL,'Y','N',17) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XSOURCEOFREFERRAL',CodeName='Integrated Treatment Court',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=17, ExternalCode1=NULL WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Integrated Treatment Court' 
	
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Jail') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XSOURCEOFREFERRAL','Jail',NULL,'Y','N',18) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XSOURCEOFREFERRAL',CodeName='Jail',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=18, ExternalCode1=NULL WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Jail' 
	
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Justice Court') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XSOURCEOFREFERRAL','Justice Court',NULL,'Y','N',19) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XSOURCEOFREFERRAL',CodeName='Justice Court',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=19, ExternalCode1=NULL WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Justice Court' 
	
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Juvenile Justice System/OYA') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XSOURCEOFREFERRAL','Juvenile Justice System/OYA',NULL,'Y','N',20) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XSOURCEOFREFERRAL',CodeName='Juvenile Justice System/OYA',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=20, ExternalCode1=NULL WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Juvenile Justice System/OYA' 
	
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Local MH Authority/Community MH Provider') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XSOURCEOFREFERRAL','Local MH Authority/Community MH Provider',NULL,'Y','N',21) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XSOURCEOFREFERRAL',CodeName='Local MH Authority/Community MH Provider',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=21, ExternalCode1=NULL WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Local MH Authority/Community MH Provider' 
	
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Municipal Court') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XSOURCEOFREFERRAL','Municipal Court',NULL,'Y','N',22) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XSOURCEOFREFERRAL',CodeName='Municipal Court',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=22, ExternalCode1=NULL WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Municipal Court' 
	
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'None') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XSOURCEOFREFERRAL','None',NULL,'Y','N',23) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XSOURCEOFREFERRAL',CodeName='None',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=23, ExternalCode1=NULL WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'None' 
	
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Other') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XSOURCEOFREFERRAL','Other',NULL,'Y','N',24) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XSOURCEOFREFERRAL',CodeName='Other',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=24, ExternalCode1=NULL WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Other' 
	
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Parole') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XSOURCEOFREFERRAL','Parole',NULL,'Y','N',25) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XSOURCEOFREFERRAL',CodeName='Parole',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=25, ExternalCode1=NULL WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Parole' 
	
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Police/Sherriff') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XSOURCEOFREFERRAL','Police/Sherriff',NULL,'Y','N',26) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XSOURCEOFREFERRAL',CodeName='Police/Sherriff',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=26, ExternalCode1=NULL WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Police/Sherriff' 
	
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Private Health Professional') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XSOURCEOFREFERRAL','Private Health Professional',NULL,'Y','N',27) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XSOURCEOFREFERRAL',CodeName='Private Health Professional',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=27, ExternalCode1=NULL WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Private Health Professional' 
	
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Probation') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XSOURCEOFREFERRAL','Probation',NULL,'Y','N',28) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XSOURCEOFREFERRAL',CodeName='Probation',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=28, ExternalCode1=NULL WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Probation' 
	
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Psychiatric Security review Board (PSRB)') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XSOURCEOFREFERRAL','Psychiatric Security review Board (PSRB)',NULL,'Y','N',29) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XSOURCEOFREFERRAL',CodeName='Psychiatric Security review Board (PSRB)',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=29, ExternalCode1=NULL WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Psychiatric Security review Board (PSRB)' 
	
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'School') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XSOURCEOFREFERRAL','School',NULL,'Y','N',30) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XSOURCEOFREFERRAL',CodeName='School',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=30, ExternalCode1=NULL WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'School' 
	
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Self') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XSOURCEOFREFERRAL','Self',NULL,'Y','N',31) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XSOURCEOFREFERRAL',CodeName='Self',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=31, ExternalCode1=NULL WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Self' 
	
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'State Correctional Facility') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XSOURCEOFREFERRAL','State Correctional Facility',NULL,'Y','N',32) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XSOURCEOFREFERRAL',CodeName='State Correctional Facility',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=32, ExternalCode1=NULL WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'State Correctional Facility' 
	
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'State Psychiatric Facility') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XSOURCEOFREFERRAL','State Psychiatric Facility',NULL,'Y','N',33) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XSOURCEOFREFERRAL',CodeName='State Psychiatric Facility',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=33, ExternalCode1=NULL WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'State Psychiatric Facility' 
	
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Unknown') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XSOURCEOFREFERRAL','Unknown',NULL,'Y','N',34) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XSOURCEOFREFERRAL',CodeName='Unknown',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=34, ExternalCode1=NULL WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Unknown' 
	
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Veterans Affairs (VA)') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XSOURCEOFREFERRAL','Veterans Affairs (VA)',NULL,'Y','N',35) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XSOURCEOFREFERRAL',CodeName='Veterans Affairs (VA)',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=35, ExternalCode1=NULL WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Veterans Affairs (VA)' 
	
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Vocational Rehabilitation') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XSOURCEOFREFERRAL','Vocational Rehabilitation',NULL,'Y','N',36) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XSOURCEOFREFERRAL',CodeName='Vocational Rehabilitation',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=36, ExternalCode1=NULL WHERE Category = 'XSOURCEOFREFERRAL' and CodeName= 'Vocational Rehabilitation' 
	
END


