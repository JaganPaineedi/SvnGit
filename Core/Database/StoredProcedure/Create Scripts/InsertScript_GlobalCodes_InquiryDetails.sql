/********************************************************************************************
Author			:  AlokKumar Meher 
CreatedDate		:  13 June 2018 
Purpose			:  Insert/Update script for GlobalCodes
*********************************************************************************************/



-- INQUIRYSATYPE
-- GlobalCodeCategories
IF NOT EXISTS(select category from GlobalCodeCategories where category='INQUIRYSATYPE')
	BEGIN
		INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory)
		VALUES('INQUIRYSATYPE','INQUIRYSATYPE','Y','Y','Y','Y','Y')
	END
GO

-- INQUIRYSATYPE
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='INQUIRYSATYPE')
BEGIN

	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='2=No, individual does not have an SUD' AND Category='INQUIRYSATYPE')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1]) 
		VALUES ('INQUIRYSATYPE','2=No, individual does not have an SUD','1','Y','N',NULL)
	END
	
	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='3=Not evaluated for SUD (e.g. person is an infant, in cisis situation etc.)' AND Category='INQUIRYSATYPE')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1]) 
		VALUES ('INQUIRYSATYPE','3=Not evaluated for SUD (e.g. person is an infant, in cisis situation etc.)','2','Y','N',NULL)
	END
	
	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='4=Individual has one or more DSV-IV substance use disorder(s) code 291xx,292xx,303xx,304xx,305xx with atleast one disorder either active' AND Category='INQUIRYSATYPE')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1]) 
		VALUES ('INQUIRYSATYPE','4=Individual has one or more DSV-IV substance use disorder(s) code 291xx,292xx,303xx,304xx,305xx with atleast one disorder either active','3','Y','N',NULL) 
	END
	
	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='5=Individual has one or more DSV-IV substance use disorder(s) code 291xx,292xx,303xx,304xx,305xx and all code substance use disorder' AND Category='INQUIRYSATYPE')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1]) 
		VALUES ('INQUIRYSATYPE','5=Individual has one or more DSV-IV substance use disorder(s) code 291xx,292xx,303xx,304xx,305xx and all code substance use disorder','4','Y','N',NULL) 
	END
	
	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='6=Results from screening or assessment sugest substance use disorder. This includes indication provisional diagnosis or rule out diagnosis' AND Category='INQUIRYSATYPE')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1]) 
		VALUES ('INQUIRYSATYPE','6=Results from screening or assessment sugest substance use disorder. This includes indication provisional diagnosis or rule out diagnosis','5','Y','N',NULL) 
	END
	
END
GO





-- INQUIRYSTATUS
-- GlobalCodeCategories
IF NOT EXISTS(select category from GlobalCodeCategories where category='INQUIRYSTATUS')
	BEGIN
		INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory)
		VALUES('INQUIRYSTATUS','INQUIRYSTATUS','Y','Y','Y','Y','Y')
	END
GO

-- INQUIRYSTATUS
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='INQUIRYSTATUS')
BEGIN

	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='In Progress' AND Category='INQUIRYSTATUS')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1]) 
		VALUES ('INQUIRYSTATUS','In Progress','INPROGRESS','Y','N',NULL)
	END
	
	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Complete' AND Category='INQUIRYSTATUS')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1]) 
		VALUES ('INQUIRYSTATUS','Complete','COMPLETE','Y','N',NULL)
	END
		
END
GO





-- INQURGENCYLEVEL
-- GlobalCodeCategories
IF NOT EXISTS(select category from GlobalCodeCategories where category='INQURGENCYLEVEL')
	BEGIN
		INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory)
		VALUES('INQURGENCYLEVEL','INQURGENCYLEVEL','Y','Y','Y','Y','Y')
	END
GO

-- INQURGENCYLEVEL
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='INQURGENCYLEVEL')
BEGIN

	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Not urgent' AND Category='INQURGENCYLEVEL')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1]) 
		VALUES ('INQURGENCYLEVEL','Not urgent','Not urgent','Y','N',NULL)
	END
	
	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Urgent' AND Category='INQURGENCYLEVEL')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1]) 
		VALUES ('INQURGENCYLEVEL','Urgent','Urgent','Y','N',NULL)
	END
	
	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Emergent' AND Category='INQURGENCYLEVEL')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1]) 
		VALUES ('INQURGENCYLEVEL','Emergent','Emergent','Y','N',NULL) 
	END
	
END
GO





-- INQUIRYTYPE
-- GlobalCodeCategories
IF NOT EXISTS(select category from GlobalCodeCategories where category='INQUIRYTYPE')
	BEGIN
		INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory)
		VALUES('INQUIRYTYPE','INQUIRYTYPE','Y','Y','Y','Y','Y')
	END
GO

-- INQUIRYTYPE
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='INQUIRYTYPE')
BEGIN

	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Screen' AND Category='INQUIRYTYPE')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1]) 
		VALUES ('INQUIRYTYPE','Screen','Screen','Y','N',NULL)
	END
	
	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Crisis' AND Category='INQUIRYTYPE')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1]) 
		VALUES ('INQUIRYTYPE','Crisis','Crisis','Y','N',NULL)
	END
	
	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Information' AND Category='INQUIRYTYPE')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1]) 
		VALUES ('INQUIRYTYPE','Information','Information','Y','N',NULL) 
	END
	
	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Jail Diversion' AND Category='INQUIRYTYPE')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1]) 
		VALUES ('INQUIRYTYPE','Jail Diversion','Jail Diversion','Y','N',NULL)
	END
	
	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Housing Evaluation' AND Category='INQUIRYTYPE')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1]) 
		VALUES ('INQUIRYTYPE','Housing Evaluation','Housing Evaluation','Y','N',NULL)
	END
	
	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Discharge Coordination' AND Category='INQUIRYTYPE')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1]) 
		VALUES ('INQUIRYTYPE','Discharge Coordination','Discharge Coordination','Y','N',NULL) 
	END
	
	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Transition planning consultation' AND Category='INQUIRYTYPE')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1]) 
		VALUES ('INQUIRYTYPE','Transition planning consultation','Transition planning consultation','Y','N',NULL) 
	END
	
END
GO





-- INQCONTACTTYPE
-- GlobalCodeCategories
IF NOT EXISTS(select category from GlobalCodeCategories where category='INQCONTACTTYPE')
	BEGIN
		INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory)
		VALUES('INQCONTACTTYPE','INQCONTACTTYPE','Y','Y','Y','Y','Y')
	END
GO

-- INQCONTACTTYPE
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='INQCONTACTTYPE')
BEGIN

	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Call' AND Category='INQCONTACTTYPE')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1]) 
		VALUES ('INQCONTACTTYPE','Call','Call','Y','N',NULL)
	END
	
	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Consult' AND Category='INQCONTACTTYPE')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1]) 
		VALUES ('INQCONTACTTYPE','Consult','Consult','Y','N',NULL)
	END
	
	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Face to Face' AND Category='INQCONTACTTYPE')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1]) 
		VALUES ('INQCONTACTTYPE','Face to Face','Face to Face','Y','N',NULL) 
	END
	
END
GO





-- INQUIRYDISPOSITION
-- GlobalCodeCategories
IF NOT EXISTS(select category from GlobalCodeCategories where category='INQUIRYDISPOSITION')
	BEGIN
		INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory,HasSubcodes)
		VALUES('INQUIRYDISPOSITION','INQUIRYDISPOSITION','Y','Y','Y','Y','Y','Y')
	END
GO

-- INQUIRYDISPOSITION
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='INQUIRYDISPOSITION')
BEGIN

	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Referred to internal service' AND Category='INQUIRYDISPOSITION')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1],[SortOrder]) 
		VALUES ('INQUIRYDISPOSITION','Referred to internal service','Referred to internal service','Y','N',NULL,1)
	END
	
	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Referred to external provider' AND Category='INQUIRYDISPOSITION')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1],[SortOrder]) 
		VALUES ('INQUIRYDISPOSITION','Referred to external provider','Referred to external provider','Y','N',NULL,2)
	END
	
	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Information Only' AND Category='INQUIRYDISPOSITION')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1],[SortOrder])
		VALUES ('INQUIRYDISPOSITION','Information Only','Information Only','Y','N',NULL,3)
	END
	
	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Individual refused service or referral' AND Category='INQUIRYDISPOSITION')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1],[SortOrder]) 
		VALUES ('INQUIRYDISPOSITION','Individual refused service or referral','Individual refused service or referral','Y','N',NULL,4)
	END
	
	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Never returned' AND Category='INQUIRYDISPOSITION')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1],[SortOrder]) 
		VALUES ('INQUIRYDISPOSITION','Never returned','Never returned','Y','N',NULL,5)
	END
	
	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Placed on waitlist' AND Category='INQUIRYDISPOSITION')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1],[SortOrder]) 
		VALUES ('INQUIRYDISPOSITION','Placed on waitlist','Placed on waitlist','Y','N',NULL,6)
	END
		
END
GO



-- INQUIRYDISPOSITION
--GlobalSubCodes  
IF EXISTS(select category from GlobalCodeCategories where category='INQUIRYDISPOSITION')
BEGIN
	
	DECLARE @GlobalCodeId INT 

	IF EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Referred to internal service' AND Category='INQUIRYDISPOSITION')
	BEGIN
	
		Set @GlobalCodeId = (Select Top 1 GlobalCodeId FROM GlobalCodes WHERE CodeName='Referred to internal service' AND Category='INQUIRYDISPOSITION')
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Case Management' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Case Management','Y','Y',1)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Crisis Residential' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Crisis Residential','Y','Y',2)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Outpatient' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Outpatient','Y','Y',3)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Partial Hospitalization' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Partial Hospitalization','Y','Y',4)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'SUD' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'SUD','Y','Y',5)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Inpatient' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Inpatient','Y','Y',6)
		END
		
	END
	
	IF EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Referred to external provider' AND Category='INQUIRYDISPOSITION')
	BEGIN
	
		Set @GlobalCodeId = (Select Top 1 GlobalCodeId FROM GlobalCodes WHERE CodeName='Referred to external provider' AND Category='INQUIRYDISPOSITION')
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Case Management' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Case Management','Y','Y',1)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Crisis Residential' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Crisis Residential','Y','Y',2)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Outpatient' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Outpatient','Y','Y',3)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Partial Hospitalization' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Partial Hospitalization','Y','Y',4)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'SUD' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'SUD','Y','Y',5)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Inpatient' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Inpatient','Y','Y',6)
		END
		
	END
	
	IF EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Information Only' AND Category='INQUIRYDISPOSITION')
	BEGIN
		
		Set @GlobalCodeId = (Select Top 1 GlobalCodeId FROM GlobalCodes WHERE CodeName='Information Only' AND Category='INQUIRYDISPOSITION')
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Case Management' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Case Management','Y','Y',1)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Crisis Residential' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Crisis Residential','Y','Y',2)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Outpatient' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Outpatient','Y','Y',3)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Partial Hospitalization' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Partial Hospitalization','Y','Y',4)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'SUD' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'SUD','Y','Y',5)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Inpatient' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Inpatient','Y','Y',6)
		END
		
	END
	
	IF EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Individual refused service or referral' AND Category='INQUIRYDISPOSITION')
	BEGIN
		
		Set @GlobalCodeId = (Select Top 1 GlobalCodeId FROM GlobalCodes WHERE CodeName='Individual refused service or referral' AND Category='INQUIRYDISPOSITION')
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Case Management' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Case Management','Y','Y',1)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Crisis Residential' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Crisis Residential','Y','Y',2)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Outpatient' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Outpatient','Y','Y',3)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Partial Hospitalization' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Partial Hospitalization','Y','Y',4)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'SUD' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'SUD','Y','Y',5)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Inpatient' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Inpatient','Y','Y',6)
		END
		
	END
	
	IF EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Never returned' AND Category='INQUIRYDISPOSITION')
	BEGIN
		
		Set @GlobalCodeId = (Select Top 1 GlobalCodeId FROM GlobalCodes WHERE CodeName='Never returned' AND Category='INQUIRYDISPOSITION')
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Case Management' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Case Management','Y','Y',1)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Crisis Residential' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Crisis Residential','Y','Y',2)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Outpatient' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Outpatient','Y','Y',3)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Partial Hospitalization' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Partial Hospitalization','Y','Y',4)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'SUD' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'SUD','Y','Y',5)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Inpatient' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Inpatient','Y','Y',6)
		END
		
	END
	
	IF EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Placed on waitlist' AND Category='INQUIRYDISPOSITION')
	BEGIN
		
		Set @GlobalCodeId = (Select Top 1 GlobalCodeId FROM GlobalCodes WHERE CodeName='Placed on waitlist' AND Category='INQUIRYDISPOSITION')
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Case Management' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Case Management','Y','Y',1)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Crisis Residential' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Crisis Residential','Y','Y',2)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Outpatient' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Outpatient','Y','Y',3)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Partial Hospitalization' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Partial Hospitalization','Y','Y',4)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'SUD' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'SUD','Y','Y',5)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Inpatient' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Inpatient','Y','Y',6)
		END
		
	END
		
END
GO





-- INQUIRYLOCATION
-- GlobalCodeCategories
IF NOT EXISTS(select category from GlobalCodeCategories where category='INQUIRYLOCATION')
	BEGIN
		INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory)
		VALUES('INQUIRYLOCATION','INQUIRYLOCATION','Y','Y','Y','Y','Y')
	END
GO

-- INQUIRYLOCATION
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='INQUIRYLOCATION')
BEGIN

	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Home' AND Category='INQUIRYLOCATION')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1],SortOrder) 
		VALUES ('INQUIRYLOCATION','Home','Home','Y','N',NULL,1)
	END
	
	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Office' AND Category='INQUIRYLOCATION')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1],SortOrder) 
		VALUES ('INQUIRYLOCATION','Office','Office','Y','N',NULL,2)
	END
	
END
GO




--######################################

-- REFERRALTYPE
-- GlobalCodeCategories
IF NOT EXISTS(select category from GlobalCodeCategories where category='REFERRALTYPE')
	BEGIN
		INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory)
		VALUES('REFERRALTYPE','REFERRALTYPE','Y','Y','Y','Y','Y')
	END
GO

-- REFERRALTYPE
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='REFERRALTYPE')
BEGIN

	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Self' AND Category='REFERRALTYPE')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1]) 
		VALUES ('REFERRALTYPE','Self','Self','Y','N',NULL)
	END
	
	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Family/Friend' AND Category='REFERRALTYPE')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1]) 
		VALUES ('REFERRALTYPE','Family/Friend','Family/Friend','Y','N',NULL)
	END
	
	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Physician or Medical Facility' AND Category='REFERRALTYPE')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1]) 
		VALUES ('REFERRALTYPE','Physician or Medical Facility','Physician or Medical Facility','Y','N',NULL) 
	END
	
	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Social or Community Agency' AND Category='REFERRALTYPE')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1]) 
		VALUES ('REFERRALTYPE','Social or Community Agency','Social or Community Agency','Y','N',NULL) 
	END
	
	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Education System' AND Category='REFERRALTYPE')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1]) 
		VALUES ('REFERRALTYPE','Education System','Education System','Y','N',NULL) 
	END
	
	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Div of WF Srvcs – Welfare' AND Category='REFERRALTYPE')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1]) 
		VALUES ('REFERRALTYPE','Div of WF Srvcs – Welfare','Div of WF Srvcs – Welfare','Y','N',NULL) 
	END
	
	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='DCFS' AND Category='REFERRALTYPE')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1]) 
		VALUES  ('REFERRALTYPE','DCFS','DCFS','Y','N',NULL) 
	END
	
	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Adult Court' AND Category='REFERRALTYPE')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1]) 
		VALUES ('REFERRALTYPE','Adult Court','Adult Court','Y','N',NULL) 
	END
	
	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Juvenile Court' AND Category='REFERRALTYPE')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1]) 
		VALUES ('REFERRALTYPE','Juvenile Court','Juvenile Court','Y','N',NULL) 
	END
	
	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Probation' AND Category='REFERRALTYPE')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1]) 
		VALUES ('REFERRALTYPE','Probation','Probation','Y','N',NULL) 
	END
	
	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Parole' AND Category='REFERRALTYPE')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1]) 
		VALUES ('REFERRALTYPE','Parole','Parole','Y','N',NULL) 
	END
	
	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Police' AND Category='REFERRALTYPE')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1]) 
		VALUES ('REFERRALTYPE','Police','Police','Y','N',NULL) 
	END
	
	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Prison' AND Category='REFERRALTYPE')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1]) 
		VALUES ('REFERRALTYPE','Prison','Prison','Y','N',NULL) 
	END
	
	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='DUI/DWI' AND Category='REFERRALTYPE')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1]) 
		VALUES ('REFERRALTYPE','DUI/DWI','DUI/DWI','Y','N',NULL)
	END
	
	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='New Choices Waiver' AND Category='REFERRALTYPE')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1]) 
		VALUES ('REFERRALTYPE','New Choices Waiver','New Choices Waiver','Y','N',NULL) 
	END
	
	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Psychiatric/MH Program' AND Category='REFERRALTYPE')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1]) 
		VALUES ('REFERRALTYPE','Psychiatric/MH Program','Psychiatric/MH Program','Y','N',NULL) 
	END
	
	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Clergy' AND Category='REFERRALTYPE')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1]) 
		VALUES ('REFERRALTYPE','Clergy','Clergy','Y','N',NULL) 
	END
	
	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Private Practice MH Professional' AND Category='REFERRALTYPE')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1]) 
		VALUES ('REFERRALTYPE','Private Practice MH Professional','Private Practice MH Professional','Y','N',NULL) 
	END
	
	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='A&D Abuse Care Provider' AND Category='REFERRALTYPE')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1]) 
		VALUES ('REFERRALTYPE','A&D Abuse Care Provider','A&D Abuse Care Provider','Y','N',NULL) 
	END
	
	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Other Person, Community or Organization' AND Category='REFERRALTYPE')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1]) 
		VALUES ('REFERRALTYPE','Other Person, Community or Organization','Other Person, Community or Organization','Y','N',NULL) 
	END
	
	IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Employer/EAP' AND Category='REFERRALTYPE')
	BEGIN
		INSERT INTO GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1]) 
		VALUES ('REFERRALTYPE','Employer/EAP','Employer/EAP','Y','N',NULL) 
	END
	
END
GO





-- REFERRALTYPE
--GlobalSubCodes  
IF EXISTS(select category from GlobalCodeCategories where category='REFERRALTYPE')
BEGIN
	
	DECLARE @GlobalCodeId INT 

	IF EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Physician or Medical Facility' AND Category='REFERRALTYPE')
	BEGIN
	
		Set @GlobalCodeId = (Select Top 1 GlobalCodeId FROM GlobalCodes WHERE CodeName='Physician or Medical Facility' AND Category='REFERRALTYPE')
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Emergency Room' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Emergency Room','Y','N',Null)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Physician' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Physician','Y','N',Null)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Nursing Home Ext Care' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Nursing Home Ext Care','Y','N',Null)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Assisted Living Nursing Facility' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Assisted Living Nursing Facility','Y','N',Null)
		END
		
	END
	
	IF EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Education System' AND Category='REFERRALTYPE')
	BEGIN
	
		Set @GlobalCodeId = (Select Top 1 GlobalCodeId FROM GlobalCodes WHERE CodeName='Education System' AND Category='REFERRALTYPE')
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'School District' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'School District','Y','N',Null)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'School' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'School','Y','N',Null)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Vocational' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Vocational','Y','N',Null)
		END
		
	END
	
	IF EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='New Choices Waiver' AND Category='REFERRALTYPE')
	BEGIN
		
		Set @GlobalCodeId = (Select Top 1 GlobalCodeId FROM GlobalCodes WHERE CodeName='New Choices Waiver' AND Category='REFERRALTYPE')
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Assisted Living Nursing Facility' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Assisted Living Nursing Facility','Y','N',Null)
		END
		
	END
	
	IF EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Psychiatric/MH Program' AND Category='REFERRALTYPE')
	BEGIN
		
		Set @GlobalCodeId = (Select Top 1 GlobalCodeId FROM GlobalCodes WHERE CodeName='Psychiatric/MH Program' AND Category='REFERRALTYPE')
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Private Psychiatric Hospital' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Private Psychiatric Hospital','Y','N',Null)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Public Psychiatric Hospital' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Public Psychiatric Hospital','Y','N',Null)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Private Outpt Srvcs' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Private Outpt Srvcs','Y','N',Null)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Public Outpt Srvcs' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Public Outpt Srvcs','Y','N',Null)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Private Residential' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Private Residential','Y','N',Null)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Public Residential' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Public Residential','Y','N',Null)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Private Partial Day' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Private Partial Day','Y','N',Null)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Public Partial Day' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Public Partial Day','Y','N',Null)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Private Psychiatrist' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Private Psychiatrist','Y','N',Null)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Public Psychiatrist' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Public Psychiatrist','Y','N',Null)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Private Other CMHC' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Private Other CMHC','Y','N',Null)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Public Other CMHC' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Public Other CMHC','Y','N',Null)
		END
	END
	
	IF EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='Private Practice MH Professional' AND Category='REFERRALTYPE')
	BEGIN
		
		Set @GlobalCodeId = (Select Top 1 GlobalCodeId FROM GlobalCodes WHERE CodeName='Private Practice MH Professional' AND Category='REFERRALTYPE')
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'VBH Commercial Practitioner' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'VBH Commercial Practitioner','Y','N',Null)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Other Private MH Practitioner' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Other Private MH Practitioner','Y','N',Null)
		END
		
	END
	
	IF EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='A&D Abuse Care Provider' AND Category='REFERRALTYPE')
	BEGIN
		
		Set @GlobalCodeId = (Select Top 1 GlobalCodeId FROM GlobalCodes WHERE CodeName='A&D Abuse Care Provider' AND Category='REFERRALTYPE')
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Outpt Tx' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Outpt Tx','Y','N',Null)
		END
		
		IF NOT EXISTS(Select GlobalSubCodeId FROM GlobalSubCodes WHERE SubCodeName = 'Inpt Tx' AND GlobalCodeId = @GlobalCodeId)
		BEGIN
			INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder) 
			VALUES (@GlobalCodeId,'Inpt Tx','Y','N',Null)
		END
		
	END
		
END
GO





-- RELATIONSHIP
-- GlobalCodeCategories
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'RELATIONSHIP') BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) VALUES('RELATIONSHIP','Relationship','Y','Y','Y','Y',NULL,'N','N','Y','N') END

-- RELATIONSHIP
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='RELATIONSHIP')
BEGIN
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Self') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Self','Self',NULL,'Y','Y',0,'18') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Aunt') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Aunt','Aunt',NULL,'Y','N',0,'G8') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Brother') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Brother','Brother',NULL,'Y','N',0,'34') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Court') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Court','Court',NULL,'Y','N',0,'G8') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Daughter') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Daughter','Daughter',NULL,'Y','N',0,'19') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'DCFSStaff') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','DCFS Staff','DCFSStaff',NULL,'Y','N',0,'G8') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Employer') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Employer','Employer',NULL,'Y','N',0,'20') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'EMTAmbulance') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','EMT/Ambulance','EMTAmbulance',NULL,'Y','N',0,'34') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Father') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Father','Father',NULL,'Y','N',0,'19') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'FosterChild') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Foster Child','FosterChild',NULL,'Y','N',0,'19') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'FosterParent') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Foster Parent','FosterParent',NULL,'Y','N',0,'G8') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'FosterMother') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Foster Mother','FosterMother',NULL,'Y','N',0,'34') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'FosterSon') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Foster Son','FosterSon',NULL,'Y','N',0,'19') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Friend') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Friend','Friend',NULL,'Y','N',0,'G8') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'GrandChild') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Grand Child','GrandChild',NULL,'Y','N',0,'19') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Grandfather') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Grandfather','Grandfather',NULL,'Y','N',0,'34') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Guardian') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Guardian','Guardian',NULL,'Y','N',0,'G8') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Grandson') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Grandson','Grandson',NULL,'Y','N',0,'19') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'JointCustodialParent') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Joint Custodial Parent','JointCustodialParent',NULL,'Y','N',0,'19') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'LawEnforcementOfficial') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Law Enforcement Official','LawEnforcementOfficial',NULL,'Y','N',0,'G8') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'LegalGuardian') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Legal Guardian','LegalGuardian',NULL,'Y','N',0,'34') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Mother') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Mother','Mother',NULL,'Y','N',0,'19') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'NonCustodialFather') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Non-Custodial Father','NonCustodialFather',NULL,'Y','N',0,'19') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Other') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Other','Other',NULL,'Y','N',0,'G8') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Sister') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Sister','Sister',NULL,'Y','N',0,'34') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Son') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Son','Son',NULL,'Y','N',0,'19') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'StepChild') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Step Child','StepChild',NULL,'Y','N',0,'G8') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'StepFather') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Step Father','StepFather',NULL,'Y','N',0,'G8') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'StepMother') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Step Mother','StepMother',NULL,'Y','N',0,'G8') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Stepson') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Stepson','Stepson',NULL,'Y','N',0,'19') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Uncle') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Uncle','Uncle',NULL,'Y','N',0,'G8') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Unknown') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Unknown','Unknown',NULL,'Y','N',0,'34') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Spouse') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Spouse','Spouse',NULL,'Y','N',0,'01') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Advocate') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Advocate','Advocate',NULL,'Y','N',0,'G8') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'PrimaryPhysician') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Primary Care Physician','PrimaryPhysician',NULL,'Y','N',0,'34') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'KinshipPlacement') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Kinship Placement','KinshipPlacement',NULL,'Y','N',0,'G8') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Parent') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Parent','Parent',NULL,'Y','N',0,'19') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Grandparent') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Grandparent','Grandparent',NULL,'Y','N',0,'19') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'NewChoicesWaiver') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','New Choices Waiver','NewChoicesWaiver',NULL,'Y','N',0,'21') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Billing') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Billing','Billing',NULL,'Y','N',0,'21') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'BiologicalParent') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Biological Parent','BiologicalParent',NULL,'Y','N',0,'19') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'CareGiver') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('RELATIONSHIP','Care Giver','CareGiver',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'CaseWorker') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('RELATIONSHIP','Case Worker','CaseWorker',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Child') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Child','Child',NULL,'Y','N',0,'G8') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'NonCustodialMother') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Non-Custodial Mother','NonCustodialMother',NULL,'Y','N',0,'19') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'NonCustodialParents(2)') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Non-Custodial Parents (2)','NonCustodialParents(2)',NULL,'Y','N',0,'19') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'None') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('RELATIONSHIP','None','None',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'NursingHome') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('RELATIONSHIP','Nursing Home','NursingHome',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'OtherFamilyMember') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Other Family Member','OtherFamilyMember',NULL,'Y','N',0,'G8') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Pharmacy') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('RELATIONSHIP','Pharmacy','Pharmacy',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'PrimaryCarePhysician') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('RELATIONSHIP','Primary Care Physician','PrimaryCarePhysician',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'SchoolDistrict') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('RELATIONSHIP','School District','SchoolDistrict',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Sibling') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Sibling','Sibling',NULL,'Y','N',0,'G8') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Primary Care Coordinator') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Primary Care Coordinator','Primary Care Coordinator',NULL,'Y','N',0,NULL) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'PrimaryPhysician') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('RELATIONSHIP','Primary Care Physician','PrimaryPhysician',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '6781') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Self','6781',NULL,'Y','N',0,'18') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Foster Parent/Guardian') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Foster Parent/Guardian','Foster Parent/Guardian','','Y','N',0,'') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Foster Care Worker') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Foster Care Worker','Foster Care Worker','','Y','N',0,'') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Plenary/Guardian') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Plenary/Guardian','Plenary/Guardian','','Y','N',0,'') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Adult Client has Payee') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RELATIONSHIP','Adult Client has Payee','Adult Client has Payee','','Y','N',0,'') END
END




-- PRIORITYPOPULATION
-- GlobalCodeCategories
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'PRIORITYPOPULATION') BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) VALUES('PRIORITYPOPULATION','PRIORITYPOPULATION','Y','Y','Y','Y','','N','N','N','N') END


-- PRIORITYPOPULATION
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='PRIORITYPOPULATION')
BEGIN
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'No Known Priority Population') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('PRIORITYPOPULATION','No Known Priority Population','No Known Priority Population',NULL,'Y','Y',1,'1') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Pregnant') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('PRIORITYPOPULATION','Pregnant','Pregnant',NULL,'Y','Y',2,'1') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'IV User') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('PRIORITYPOPULATION','IV User','IV User',NULL,'Y','Y',3,'1') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'CPS Involvement') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('PRIORITYPOPULATION','CPS Involvement','CPS Involvement',NULL,'Y','Y',4,'1') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Medicare') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('PRIORITYPOPULATION','Medicare','Medicare',NULL,'Y','Y',5,'1') END
END




-- MARITALSTATUS
-- GlobalCodeCategories
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'MARITALSTATUS') BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) VALUES('MARITALSTATUS','Marital Status','Y','Y','Y','Y','Valley - Customizations #948','N','N','Y','Y') END


-- MARITALSTATUS
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='MARITALSTATUS')
BEGIN
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '1') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('MARITALSTATUS','Divorced','1',NULL,'Y','N',0,'5') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '2') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('MARITALSTATUS','Married','2',NULL,'Y','N',0,'2') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '3') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('MARITALSTATUS','Never Married','3',NULL,'Y','N',0,'3') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '4') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('MARITALSTATUS','Separated','4',NULL,'Y','N',0,'4') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '6') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('MARITALSTATUS','Unknown','6',NULL,'N','N',0,'9') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '7') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('MARITALSTATUS','Widowed','7',NULL,'Y','N',0,'6') END
END





-- GENDERIDENTITY
-- GlobalCodeCategories
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'GENDERIDENTITY') BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) VALUES('GENDERIDENTITY','GENDERIDENTITY','Y','Y','Y','Y',NULL,'N','N','N','N') END


-- GENDERIDENTITY
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='GENDERIDENTITY')
BEGIN
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'TRANSGENDER') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('GENDERIDENTITY','Transgender','TRANSGENDER','','Y','Y',1,'TRANSGENDER') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Male') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('GENDERIDENTITY','Male','Male','','Y','Y',1,'446151000124109') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Female') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('GENDERIDENTITY','Female','Female','','Y','Y',2,'446141000124107') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Female-to-Male (FTM)/Transgender Male/Trans Man') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('GENDERIDENTITY','Female-to-Male (FTM)/Transgender Male/Trans Man','Female-to-Male (FTM)/Transgender Male/Trans Man','','Y','Y',3,'407377005') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Male-to-Female (MTF)/Transgender Female/Trans Woman') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('GENDERIDENTITY','Male-to-Female (MTF)/Transgender Female/Trans Woman','Male-to-Female (MTF)/Transgender Female/Trans Woman','','Y','Y',4,'407376001') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Genderqueer, neither exclusively male nor female') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('GENDERIDENTITY','Genderqueer, neither exclusively male nor female','Genderqueer, neither exclusively male nor female','','Y','Y',5,'446131000124102') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Other') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('GENDERIDENTITY','Other','Other','','Y','Y',5,'OTH') END
END





-- SEXUALORIENTATION
-- GlobalCodeCategories
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'SEXUALORIENTATION') BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) VALUES('SEXUALORIENTATION','SEXUALORIENTATION','Y','N','N','N',NULL,'N','N','N','N') END


-- SEXUALORIENTATION
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='SEXUALORIENTATION')
BEGIN
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Lesbian, gay or homosexual') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('SEXUALORIENTATION','Lesbian, gay or homosexual','Lesbian, gay or homosexual',NULL,'Y','Y',1,'38628009') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Straight or heterosexual') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('SEXUALORIENTATION','Straight or heterosexual','Straight or heterosexual',NULL,'Y','Y',2,'20430005') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Bisexual') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('SEXUALORIENTATION','Bisexual','Bisexual',NULL,'Y','Y',3,'42035005') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Don’t know') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('SEXUALORIENTATION','Don’t know','Don’t know',NULL,'Y','Y',4,'UNK') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Other') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('SEXUALORIENTATION','Other','Other',NULL,'Y','Y',5,'OTH') END
END





-- CAUSEOFDEATH
-- GlobalCodeCategories
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'CAUSEOFDEATH') BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) VALUES('CAUSEOFDEATH','Cause of Death','Y','Y','Y','Y','Used in Client Demographics','N','N','Y','Y') END


-- CAUSEOFDEATH
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='CAUSEOFDEATH')
BEGIN
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Cardiac Arrest') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('CAUSEOFDEATH','Cardiac Arrest','Cardiac Arrest',NULL,'Y','Y',1,'410429000') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Head Trauma') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('CAUSEOFDEATH','Head Trauma','Head Trauma',NULL,'Y','Y',2,'312972009') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Cerebrovascular Accident') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('CAUSEOFDEATH','Cerebrovascular Accident','Cerebrovascular Accident',NULL,'Y','Y',3,'230690007') END
END





-- LIVINGARRANGEMENT
-- GlobalCodeCategories
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'LIVINGARRANGEMENT') BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) VALUES('LIVINGARRANGEMENT','Living Arrangement','Y','Y','Y','Y','Valley - Customizations #948','N','N','Y','Y') END


-- LIVINGARRANGEMENT
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='LIVINGARRANGEMENT')
BEGIN
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '1') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('LIVINGARRANGEMENT','On Street or in a Homeless Shelter','1',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '2') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('LIVINGARRANGEMENT','Private Residence-Independent','2',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '3') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('LIVINGARRANGEMENT','Private Residence-Dependent','3',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '4') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('LIVINGARRANGEMENT','Jail or Correctional Facility','4',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '5') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('LIVINGARRANGEMENT','Institutional Setting','5',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '6') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('LIVINGARRANGEMENT','24-hour Residential Care','6',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '7') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('LIVINGARRANGEMENT','Adult or Child Foster Care','7',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '8') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('LIVINGARRANGEMENT','Unknown','8',NULL,'Y','N',0) END
END





-- EDUCATIONALSTATUS
-- GlobalCodeCategories
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'EDUCATIONALSTATUS') BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) VALUES('EDUCATIONALSTATUS','Educational Status','Y','Y','Y','Y','Valley Client Acceptance Testing Issues #64','N','N','Y','Y') END


-- EDUCATIONALSTATUS
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='EDUCATIONALSTATUS')
BEGIN
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '1') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('EDUCATIONALSTATUS','Yes currently enrolled','1',NULL,'Y','N',1,'1') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '2') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('EDUCATIONALSTATUS','Not currently enrolled','2',NULL,'Y','N',2,'2') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '3') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('EDUCATIONALSTATUS','Unknown','3',NULL,'N','N',3,'7') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '4') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALSTATUS','2nd Grade','4',NULL,'Y','N',4) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '5') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALSTATUS','3rd Grade','5',NULL,'Y','N',5) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '6') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALSTATUS','4th Grade','6',NULL,'Y','N',6) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '7') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALSTATUS','5th Grade','7',NULL,'Y','N',7) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '8') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALSTATUS','6th Grade','8',NULL,'Y','N',8) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '9') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALSTATUS','7th Grade','9',NULL,'Y','N',9) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '10') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALSTATUS','8th Grade','10',NULL,'Y','N',10) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '11') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALSTATUS','9th Grade','11',NULL,'Y','N',11) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '12') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALSTATUS','10th Grade','12',NULL,'Y','N',12) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '13') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALSTATUS','11th Grade','13',NULL,'Y','N',13) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '14') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALSTATUS','12th Grade','14',NULL,'Y','N',14) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '15') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALSTATUS','High School Graduate','15',NULL,'Y','N',15) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '16') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALSTATUS','Post High School Program','16',NULL,'Y','N',16) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '17') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALSTATUS','College Graduate','17',NULL,'Y','N',17) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '18') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALSTATUS','Some Graduate School','18',NULL,'Y','N',18) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '19') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALSTATUS','Graduate School Graduate','19',NULL,'Y','N',19) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '20') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALSTATUS','Never Attended School','20',NULL,'Y','N',20) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '21') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALSTATUS','Special Education','21',NULL,'Y','N',21) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '22') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALSTATUS','Vocational School','22',NULL,'Y','N',22) END
END





-- MILITARYSTATUS
-- GlobalCodeCategories
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'MILITARYSTATUS') BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) VALUES('MILITARYSTATUS','Military Status','Y','Y','Y','Y',NULL,'N','N','Y','Y') END


-- MILITARYSTATUS
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='MILITARYSTATUS')
BEGIN
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '1') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('MILITARYSTATUS','Yes','1',NULL,'Y','N',0,'Y') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '2') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('MILITARYSTATUS','No','2',NULL,'Y','N',0,'N') END
END





-- EMPLOYMENTSTATUS
-- GlobalCodeCategories
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'EMPLOYMENTSTATUS') BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) VALUES('EMPLOYMENTSTATUS','Employment Status','Y','Y','Y','Y','Valley - Customizations #948','N','N','Y','Y') END


-- EMPLOYMENTSTATUS
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='EMPLOYMENTSTATUS')
BEGIN
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '1') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('EMPLOYMENTSTATUS','Employed Full Time','1',NULL,'Y','N',0,'1') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '2') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('EMPLOYMENTSTATUS','Employed Part Time','2',NULL,'Y','N',0,'2') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '3') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('EMPLOYMENTSTATUS','Supported/Trans Employment','3',NULL,'Y','N',0,'13') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '4') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('EMPLOYMENTSTATUS','Homemaker','4',NULL,'Y','N',0,'11') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '5') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('EMPLOYMENTSTATUS','Student','5',NULL,'Y','N',0,'15') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '6') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('EMPLOYMENTSTATUS','Retired','6',NULL,'Y','N',0,'14') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '7') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('EMPLOYMENTSTATUS','Unemployed, seeking work','7',NULL,'Y','N',0,'7') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '8') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('EMPLOYMENTSTATUS','Unemployed, Not Seeking Work','8',NULL,'Y','N',0,'12') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '9') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('EMPLOYMENTSTATUS','Disabled - Not in Labor Force','9',NULL,'Y','N',0,'3') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '10') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('EMPLOYMENTSTATUS','Ages 0-5','10',NULL,'Y','N',0,'10') END
END





-- LANGUAGE
-- GlobalCodeCategories
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'LANGUAGE') BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) VALUES('LANGUAGE','Language','Y','Y','Y','Y',NULL,'N','N','Y','Y') END


-- LANGUAGE
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='LANGUAGE')
BEGIN
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'English') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('LANGUAGE','English','English',NULL,'Y','Y',1,'en') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '2') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('LANGUAGE','American Sign Language','2',NULL,'Y','N',2,'ach') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '3') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('LANGUAGE','Adangme','3',NULL,'Y','N',0,'ada') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '4') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('LANGUAGE','Afar','4',NULL,'Y','N',0,'aar') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '5') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('LANGUAGE','Akan','5',NULL,'Y','N',0,'aka') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '6') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('LANGUAGE','Arabic','6',NULL,'Y','N',3,'alb') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '7') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('LANGUAGE','Arabic','7',NULL,'Y','N',0,'ara') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '8') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('LANGUAGE','Armenian - arm','8',NULL,'Y','N',0,'arm') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '9') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('LANGUAGE','Armenian - hye','9',NULL,'Y','N',0,'hye') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '10') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('LANGUAGE','Bosnian','10',NULL,'Y','N',4,'bos') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '11') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('LANGUAGE','Chinese - Cantonese','11',NULL,'Y','N',6,'chi') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '12') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('LANGUAGE','Chinese - Mandarin','12',NULL,'Y','N',7,'efi') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '13') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('LANGUAGE','Cambodian','13',NULL,'Y','N',5,'eng') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'French') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('LANGUAGE','French','French',NULL,'Y','Y',2,'fr') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '15') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('LANGUAGE','German','15',NULL,'Y','N',9,'ger') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '16') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('LANGUAGE','German - deu','16',NULL,'Y','N',0,'deu') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '17') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('LANGUAGE','Greek','17',NULL,'Y','N',10,'gre') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '18') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('LANGUAGE','Hebrew','18',NULL,'Y','N',0,'heb') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '19') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('LANGUAGE','Hindi','19',NULL,'Y','N',11,'hin') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '20') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('LANGUAGE','Hmong','20',NULL,'Y','N',0,'hmn') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '21') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('LANGUAGE','Italian','21',NULL,'Y','N',12,'ita') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '22') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('LANGUAGE','Japanese','22',NULL,'Y','N',13,'jpn') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '23') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('LANGUAGE','Korean','23',NULL,'Y','N',0,'kor') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '24') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('LANGUAGE','Romanian','24',NULL,'Y','N',0,'rum') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '25') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('LANGUAGE','Russian','25',NULL,'Y','N',21,'rus') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '26') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('LANGUAGE','Sign languages','26',NULL,'Y','N',0,'sgn') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Spanish') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('LANGUAGE','Spanish','Spanish',NULL,'Y','Y',3,'es') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '28') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('LANGUAGE','Tamil','28',NULL,'Y','N',0,'tam') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '29') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('LANGUAGE','Vietnamese','29',NULL,'Y','N',28,'tha') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '30') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('LANGUAGE','Vietnamese','30',NULL,'Y','N',0,'vie') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '31') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('LANGUAGE','Native American:UTE ','31',NULL,'Y','N',19) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '32') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('LANGUAGE','Zulu','32',NULL,'Y','N',28) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '33') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('LANGUAGE','Other','33',NULL,'Y','N',29) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '34') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('LANGUAGE','Cambodian','34',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '35') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('LANGUAGE','Croatian','35',NULL,'Y','N',8,'sgn') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '36') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('LANGUAGE','Farsi','36',NULL,'Y','N',8,'spa') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '37') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('LANGUAGE','Karen','37',NULL,'Y','N',0,'tam') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '38') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('LANGUAGE','Kirundian','38',NULL,'Y','N',15,'tha') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '39') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('LANGUAGE','Kurdish','39',NULL,'Y','N',16,'vie') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '40') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('LANGUAGE','Laotian','40',NULL,'Y','N',17) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '41') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('LANGUAGE','Native American:Navajo ','41',NULL,'Y','N',18) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '42') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('LANGUAGE','Portuguese','42',NULL,'Y','N',20) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '43') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('LANGUAGE','Samoan','43',NULL,'Y','N',21) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '44') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('LANGUAGE','Serbian','44',NULL,'Y','N',22) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '45') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('LANGUAGE','Somali','45',NULL,'Y','N',23) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '46') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('LANGUAGE','Sudanese','46',NULL,'Y','N',24) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '47') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('LANGUAGE','Swahili','47',NULL,'Y','N',25) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '48') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('LANGUAGE','Tibetan','48',NULL,'Y','N',26) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '49') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('LANGUAGE','Tongan','49',NULL,'Y','N',27) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '50') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('LANGUAGE','Unknown','50',NULL,'Y','N',30,'97') END
END





-- HISPANICORIGIN
-- GlobalCodeCategories
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'HISPANICORIGIN') BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) VALUES('HISPANICORIGIN','Hispanic Origin','Y','Y','Y','Y','Valley - Customizations #948','N','N','Y','Y') END


-- HISPANICORIGIN
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='HISPANICORIGIN')
BEGIN
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '4') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('HISPANICORIGIN','Other Hispanic Origin','4',NULL,'Y','Y',4,'1') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '5') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('HISPANICORIGIN','Not of Hispanic Origin','5',NULL,'Y','Y',5,'2') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '7') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('HISPANICORIGIN','Unknown','7',NULL,'N','Y',6,'3') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '1') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('HISPANICORIGIN','Puerto Rican','1','Valley - Customizations #948','Y','N',1) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '2') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('HISPANICORIGIN','Mexican','2','Valley - Customizations #948','Y','N',2) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '3') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('HISPANICORIGIN','Cuban','3','Valley - Customizations #948','Y','N',3) END
END





-- REMINDERCOMMTYPE
-- GlobalCodeCategories
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'REMINDERCOMMTYPE') BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) VALUES('REMINDERCOMMTYPE','REMINDERCOMMTYPE','Y','Y','Y','Y',NULL,'N','N','N','N') END


-- REMINDERCOMMTYPE
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='REMINDERCOMMTYPE')
BEGIN
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Phone') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('REMINDERCOMMTYPE','Phone','Phone',NULL,'Y','Y',1,NULL) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Email') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('REMINDERCOMMTYPE','Email','Email',NULL,'Y','Y',2,NULL) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Mobile Text Message') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('REMINDERCOMMTYPE','Mobile Text Message','Mobile Text Message',NULL,'Y','Y',3,NULL) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'System Message') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('REMINDERCOMMTYPE','System Message','System Message',NULL,'Y','Y',4,NULL) END
END





-- MOBILEPHONEPROVIDER
-- GlobalCodeCategories
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'MOBILEPHONEPROVIDER') BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) VALUES('MOBILEPHONEPROVIDER','MOBILEPHONEPROVIDER','Y','Y','Y','Y',NULL,'N','N','N','N') END


---- MOBILEPHONEPROVIDER
---- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='MOBILEPHONEPROVIDER')
BEGIN
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Verizon') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('MOBILEPHONEPROVIDER','Verizon','Verizon',NULL,'Y','Y',1,NULL) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'AT&T') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('MOBILEPHONEPROVIDER','AT&T','AT&T',NULL,'Y','Y',2,NULL) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'T-Mobile') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('MOBILEPHONEPROVIDER','T-Mobile','T-Mobile',NULL,'Y','Y',3,NULL) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Sprint') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('MOBILEPHONEPROVIDER','Sprint','Sprint',NULL,'Y','Y',4,NULL) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'U.S. Cellular') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('MOBILEPHONEPROVIDER','U.S. Cellular','U.S. Cellular',NULL,'Y','Y',5,NULL) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Other') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('MOBILEPHONEPROVIDER','Other','Other',NULL,'Y','Y',6,NULL) END
END





-- RACE
-- GlobalCodeCategories
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'RACE') BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) VALUES('RACE','RACE','Y','Y','Y','Y','Valley - Customizations #948','N','N','Y','Y') END


-- RACE
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='RACE')
BEGIN
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '1') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RACE','Alaskan Native','1','Valley - Customizations #948','Y','N',1,'6') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '2') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RACE','American Indian','2','Valley - Customizations #948','Y','N',2,'1') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Asian') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RACE','Asian','Asian',NULL,'Y','Y',1,'2028-9') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '4') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RACE','Pacific Islander or Native Hawaiian','4','Valley - Customizations #948','Y','N',4,'7') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '5') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RACE','Black/African American','5','Valley - Customizations #948','Y','N',5,'3') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'White') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RACE','White','White',NULL,'Y','Y',12,'2106-3') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '7') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('RACE','Unknown','7','Valley - Customizations #948','N','N',7) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '8') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RACE','Two or more races','8','Valley - Customizations #948','Y','N',8,'8') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '0') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RACE','Other single race','0','Valley - Customizations #948','Y','N',9,'5') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Samoan') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RACE','Samoan','Samoan',NULL,'Y','Y',2,'2080-0') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Native Hawaiian') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RACE','Native Hawaiian','Native Hawaiian',NULL,'Y','Y',3,'2076-8') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Haitian') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RACE','Haitian','Haitian',NULL,'Y','Y',4,'2071-9') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Dominica Islander') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RACE','Dominica Islander','Dominica Islander',NULL,'Y','Y',5,'2070-1') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Black or African American') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RACE','Black or African American','Black or African American',NULL,'Y','Y',6,'2054-5') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Dominican') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RACE','Dominican','Dominican',NULL,'Y','Y',7,'2069-3') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Blackfoot Sioux') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RACE','Blackfoot Sioux','Blackfoot Sioux',NULL,'Y','Y',8,'1610-5') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'French') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RACE','French','French',NULL,'Y','Y',9,'2111-3') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Japanese') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RACE','Japanese','Japanese',NULL,'Y','Y',10,'2039-6') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'American Indian or Alaskan Native') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('RACE','American Indian or Alaskan Native','American Indian or Alaskan Native',NULL,'Y','Y',11,'1002-5') END
END





-- ClientConsents
-- GlobalCodeCategories
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'ClientConsents') BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) VALUES('ClientConsents','Client Declined To Provide','Y','N','N','N',NULL,'N','N','Y','N') END


-- ClientConsents
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='ClientConsents')
BEGIN
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Date of Birth') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('ClientConsents','Date of Birth','Date of Birth',NULL,'Y','Y',1,'Date of Birth') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Sex') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('ClientConsents','Sex','Sex',NULL,'Y','Y',2,'Sex') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Race') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('ClientConsents','Race','Race',NULL,'Y','Y',3,'Race') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Primary/Preferred Language') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('ClientConsents','Primary/Preferred Language','Primary/Preferred Language',NULL,'Y','Y',4,'Primary/Preferred Lang') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Hispanic Origin') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('ClientConsents','Hispanic Origin','Hispanic Origin',NULL,'Y','Y',5,'Hispanic Origin') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Gender Identity') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('ClientConsents','Gender Identity','Gender Identity',NULL,'Y','Y',6,'Gender Identity') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Sexual Orientation') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('ClientConsents','Sexual Orientation','Sexual Orientation',NULL,'Y','Y',7,'Sexual Orientation') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Ethnicity') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('ClientConsents','Ethnicity','Ethnicity',NULL,'Y','N',8,'Ethnicity') END
END





-- ETHNICITY
-- GlobalCodeCategories
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'ETHNICITY') BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) VALUES('ETHNICITY','ETHNICITY','Y','N','N','N',NULL,'N','N','N','N') END


-- ETHNICITY
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='ETHNICITY')
BEGIN
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Hispanic or Latino') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('ETHNICITY','Hispanic or Latino','Hispanic or Latino',NULL,'Y','Y',3,'2135-2') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Not Hispanic or Latino') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('ETHNICITY','Not Hispanic or Latino','Not Hispanic or Latino',NULL,'Y','Y',1,'2186-5') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Dominican') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('ETHNICITY','Dominican','Dominican',NULL,'Y','Y',2,'2184-0') END
END



-- CLIENTNAMEPREFIX
-- GlobalCodeCategories
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'CLIENTNAMEPREFIX') BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) VALUES('CLIENTNAMEPREFIX','CLIENTNAMEPREFIX','Y','Y','Y','Y',NULL,'N','Y','Y','N') END

-- CLIENTNAMEPREFIX
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='CLIENTNAMEPREFIX')
BEGIN
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Mr.') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('CLIENTNAMEPREFIX','Mr.',NULL,NULL,'Y','Y',NULL,NULL) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Mrs.') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('CLIENTNAMEPREFIX','Mrs.',NULL,NULL,'Y','Y',NULL,NULL) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Miss') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('CLIENTNAMEPREFIX','Miss',NULL,NULL,'Y','Y',NULL,NULL) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Ms.') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('CLIENTNAMEPREFIX','Ms.',NULL,NULL,'Y','N',NULL,NULL) END
END



-- CLIENTNAMESUFFIX
-- GlobalCodeCategories
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'CLIENTNAMESUFFIX') BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) VALUES('CLIENTNAMESUFFIX','CLIENTNAMESUFFIX','Y','Y','Y','Y',NULL,'N','Y','Y','N') END

-- CLIENTNAMESUFFIX
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='CLIENTNAMESUFFIX')
BEGIN
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'JR') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('CLIENTNAMESUFFIX','JR',NULL,NULL,'Y','N',1,NULL) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'SR') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('CLIENTNAMESUFFIX','SR',NULL,NULL,'Y','Y',2,NULL) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'II') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('CLIENTNAMESUFFIX','II',NULL,NULL,'Y','N',3,NULL) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'III') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('CLIENTNAMESUFFIX','III',NULL,NULL,'Y','N',4,NULL) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'IV') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('CLIENTNAMESUFFIX','IV',NULL,NULL,'Y','N',5,NULL) END
END


-- PREFERREDPRONOUN
-- GlobalCodeCategories
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'PREFERREDPRONOUN') BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) VALUES('PREFERREDPRONOUN','PREFERREDPRONOUN','Y','Y','Y','Y',NULL,'N','N','N','Y') END

-- PREFERREDPRONOUN
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='PREFERREDPRONOUN')
BEGIN
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'He') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('PREFERREDPRONOUN','He',NULL,NULL,'Y','N',1,NULL) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'She') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('PREFERREDPRONOUN','She',NULL,NULL,'Y','N',2,NULL) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'They') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('PREFERREDPRONOUN','They',NULL,NULL,'Y','N',3,NULL) END
END
