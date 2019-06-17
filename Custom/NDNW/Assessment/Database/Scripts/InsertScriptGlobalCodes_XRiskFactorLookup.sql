IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'XRiskFactorLookup') 
	BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) 
	VALUES('XRiskFactorLookup','XRiskFactorLookup','Y','Y','Y','Y',NULL,'N','N','N','N') END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= '“All or none” thinking') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','“All or none” thinking',NULL,'Y','N',1) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XRiskFactorLookup',CodeName='“All or none” thinking',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=1, ExternalCode1=NULL WHERE Category = 'XRiskFactorLookup' and CodeName= '“All or none” thinking' 
END 
	
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Acting out behavior at home and/or school') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Acting out behavior at home and/or school',NULL,'Y','N',2) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XRiskFactorLookup',CodeName='Acting out behavior at home and/or school',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=2, ExternalCode1=NULL WHERE Category = 'XRiskFactorLookup' and CodeName= 'Acting out behavior at home and/or school' 
END 	

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Client has access to weapons') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Client has access to weapons',NULL,'Y','N',3) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XRiskFactorLookup',CodeName='Client has access to weapons',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=3, ExternalCode1=NULL WHERE Category = 'XRiskFactorLookup' and CodeName= 'Client has access to weapons' 
END

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Constricted thinking') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Constricted thinking',NULL,'Y','N',4) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XRiskFactorLookup',CodeName='Constricted thinking',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=4, ExternalCode1=NULL WHERE Category = 'XRiskFactorLookup' and CodeName= 'Constricted thinking' 
END  

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Dangerous neighborhood') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Dangerous neighborhood',NULL,'Y','N',5) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XRiskFactorLookup',CodeName='Dangerous neighborhood',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=5, ExternalCode1=NULL WHERE Category = 'XRiskFactorLookup' and CodeName= 'Dangerous neighborhood'
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Diagnosis of Major Depression, Personality Disorder, Alcohol/Drug Abuse or Dependence or Dissociative Disorder') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Diagnosis of Major Depression, Personality Disorder, Alcohol/Drug Abuse or Dependence or Dissociative Disorder',NULL,'Y','N',6) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XRiskFactorLookup',CodeName='Diagnosis of Major Depression, Personality Disorder, Alcohol/Drug Abuse or Dependence or Dissociative Disorder',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=6, ExternalCode1=NULL WHERE Category = 'XRiskFactorLookup' and CodeName= 'Diagnosis of Major Depression, Personality Disorder, Alcohol/Drug Abuse or Dependence or Dissociative Disorder' 
END  

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Drug manufacturing or selling in the home') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Drug manufacturing or selling in the home',NULL,'Y','N',7) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XRiskFactorLookup',CodeName='Drug manufacturing or selling in the home',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=7, ExternalCode1=NULL WHERE Category = 'XRiskFactorLookup' and CodeName= 'Drug manufacturing or selling in the home' 
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Egosyntonic attitude') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Egosyntonic attitude',NULL,'Y','N',8) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XRiskFactorLookup',CodeName='Egosyntonic attitude',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=8, ExternalCode1=NULL WHERE Category = 'XRiskFactorLookup' and CodeName= 'Egosyntonic attitude'
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Explosive Behavior') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Explosive Behavior',NULL,'Y','N',9) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XRiskFactorLookup',CodeName='Explosive Behavior',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=9, ExternalCode1=NULL WHERE Category = 'XRiskFactorLookup' and CodeName= 'Explosive Behavior'
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Family – minimal or no support') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Family – minimal or no support',NULL,'Y','N',10) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XRiskFactorLookup',CodeName='Family – minimal or no support',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=10, ExternalCode1=NULL WHERE Category = 'XRiskFactorLookup' and CodeName= 'Family – minimal or no support'
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Family support available, but unwilling to help') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Family support available, but unwilling to help',NULL,'Y','N',11) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XRiskFactorLookup',CodeName='Family support available, but unwilling to help',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=11, ExternalCode1=NULL WHERE Category = 'XRiskFactorLookup' and CodeName= 'Family support available, but unwilling to help'
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Gambling') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Gambling',NULL,'Y','N',12) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XRiskFactorLookup',CodeName='Gambling',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=12, ExternalCode1=NULL WHERE Category = 'XRiskFactorLookup' and CodeName= 'Gambling'
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Giving away personal possessions') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Giving away personal possessions',NULL,'Y','N',13) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XRiskFactorLookup',CodeName='Giving away personal possessions',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=13, ExternalCode1=NULL WHERE Category = 'XRiskFactorLookup' and CodeName= 'Giving away personal possessions'
END

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Helplessness') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Helplessness',NULL,'Y','N',14) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XRiskFactorLookup',CodeName='Helplessness',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=14, ExternalCode1=NULL WHERE Category = 'XRiskFactorLookup' and CodeName= 'Helplessness'
END  

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'History of 2 or more suicide attempts in past 24 months') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','History of 2 or more suicide attempts in past 24 months',NULL,'Y','N',15) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XRiskFactorLookup',CodeName='History of 2 or more suicide attempts in past 24 months',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=15, ExternalCode1=NULL WHERE Category = 'XRiskFactorLookup' and CodeName= 'History of 2 or more suicide attempts in past 24 months'
END  

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'History of family completions') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','History of family completions',NULL,'Y','N',16) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XRiskFactorLookup',CodeName='History of family completions',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=16, ExternalCode1=NULL WHERE Category = 'XRiskFactorLookup' and CodeName= 'History of family completions'
END  

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Hoarding') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Hoarding',NULL,'Y','N',17) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XRiskFactorLookup',CodeName='Hoarding',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=17, ExternalCode1=NULL WHERE Category = 'XRiskFactorLookup' and CodeName= 'Hoarding'
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Hopelessness') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Hopelessness',NULL,'Y','N',18) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XRiskFactorLookup',CodeName='Hopelessness',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=18, ExternalCode1=NULL WHERE Category = 'XRiskFactorLookup' and CodeName= 'Hopelessness'
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Impulsive Behavior') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Impulsive Behavior',NULL,'Y','N',19) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XRiskFactorLookup',CodeName='Impulsive Behavior',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=19, ExternalCode1=NULL WHERE Category = 'XRiskFactorLookup' and CodeName= 'Impulsive Behavior'
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Interpersonal conflicts') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Interpersonal conflicts',NULL,'Y','N',19) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XRiskFactorLookup',CodeName='Interpersonal conflicts',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=19, ExternalCode1=NULL WHERE Category = 'XRiskFactorLookup' and CodeName= 'Interpersonal conflicts'
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'LGBT factors and acceptance') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','LGBT factors and acceptance',NULL,'Y','N',20) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XRiskFactorLookup',CodeName='LGBT factors and acceptance',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=20, ExternalCode1=NULL WHERE Category = 'XRiskFactorLookup' and CodeName= 'LGBT factors and acceptance'
END

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Loss of emotional support system') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Loss of emotional support system',NULL,'Y','N',21) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XRiskFactorLookup',CodeName='Loss of emotional support system',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=21, ExternalCode1=NULL WHERE Category = 'XRiskFactorLookup' and CodeName= 'Loss of emotional support system'
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Making preparations') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Making preparations',NULL,'Y','N',22) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XRiskFactorLookup',CodeName='Making preparations',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=22, ExternalCode1=NULL WHERE Category = 'XRiskFactorLookup' and CodeName= 'Making preparations'
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'No ambivalence') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','No ambivalence',NULL,'Y','N',23) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XRiskFactorLookup',CodeName='No ambivalence',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=23, ExternalCode1=NULL WHERE Category = 'XRiskFactorLookup' and CodeName= 'No ambivalence'
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Other Risk Factor(s)') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Other Risk Factor(s)',NULL,'Y','N',24) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XRiskFactorLookup',CodeName='Other Risk Factor(s)',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=24, ExternalCode1=NULL WHERE Category = 'XRiskFactorLookup' and CodeName= 'Other Risk Factor(s)'
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Poor Ability to Communicate') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Poor Ability to Communicate',NULL,'Y','N',25) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XRiskFactorLookup',CodeName='Poor Ability to Communicate',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=25, ExternalCode1=NULL WHERE Category = 'XRiskFactorLookup' and CodeName= 'Poor Ability to Communicate'
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Previous rescue(s) accidental') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Previous rescue(s) accidental',NULL,'Y','N',26) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XRiskFactorLookup',CodeName='Previous rescue(s) accidental',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=26, ExternalCode1=NULL WHERE Category = 'XRiskFactorLookup' and CodeName= 'Previous rescue(s) accidental'
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Sexual Addictions') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Sexual Addictions',NULL,'Y','N',27) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XRiskFactorLookup',CodeName='Sexual Addictions',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=27, ExternalCode1=NULL WHERE Category = 'XRiskFactorLookup' and CodeName= 'Sexual Addictions'
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Sexual Reactivity') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Sexual Reactivity',NULL,'Y','N',28) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XRiskFactorLookup',CodeName='Sexual Reactivity',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=28, ExternalCode1=NULL WHERE Category = 'XRiskFactorLookup' and CodeName= 'Sexual Reactivity'
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Substance abuse / dependence') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Substance abuse / dependence',NULL,'Y','N',28) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XRiskFactorLookup',CodeName='Substance abuse / dependence',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=29, ExternalCode1=NULL WHERE Category = 'XRiskFactorLookup' and CodeName= 'Substance abuse / dependence'
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Unusual Behavior') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Unusual Behavior',NULL,'Y','N',29) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XRiskFactorLookup',CodeName='Unusual Behavior',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=30, ExternalCode1=NULL WHERE Category = 'XRiskFactorLookup' and CodeName= 'Unusual Behavior'
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Video Game Addictions') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Video Game Addictions',NULL,'Y','N',30) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XRiskFactorLookup',CodeName='Video Game Addictions',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=31, ExternalCode1=NULL WHERE Category = 'XRiskFactorLookup' and CodeName= 'Video Game Addictions'
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Volatile living environment') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Volatile living environment',NULL,'Y','N',31) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XRiskFactorLookup',CodeName='Volatile living environment',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=32, ExternalCode1=NULL WHERE Category = 'XRiskFactorLookup' and CodeName= 'Volatile living environment' 
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XRiskFactorLookup' and CodeName= 'Withdrawn or isolated') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XRiskFactorLookup','Withdrawn or isolated',NULL,'Y','N',31) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XRiskFactorLookup',CodeName='Withdrawn or isolated',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=33, ExternalCode1=NULL WHERE Category = 'XRiskFactorLookup' and CodeName= 'Withdrawn or isolated' 
END 