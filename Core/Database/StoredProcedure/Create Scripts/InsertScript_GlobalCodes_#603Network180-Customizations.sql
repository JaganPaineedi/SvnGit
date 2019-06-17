--------------------------------------------------------------------------------------
--Author:  Shruthi.S
--Date  :  09/07/2015
--Purpose: Added globalcode and globalsubcodes for Denial reason popup.Ref #603 Network180
--08/03/2016 Changed Custom category to core category 'xOverrideReasons' to 'DENIALOVERRIDEREASON'.Ref : #603.4 Network180-Customizations
--------------------------------------------------------------------------------------


---GlobalCodeCategory entry for 'OVERRIDEDENIALREASON    '

IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'OVERRIDEDENIALREASON      ') 
BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) 
VALUES('OVERRIDEDENIALREASON      ','OVERRIDEDENIALREASON    ','Y','Y','Y','Y',NULL,'N','N','N','N') 
END 

---GlobalCode entry for Category 'OVERRIDEDENIALREASON    ' 
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category='OVERRIDEDENIALREASON      ' and CodeName='OVERRIDEDENIALREASON    ' and GlobalCodeId=8993) 
begin 
SET IDENTITY_INSERT globalcodes ON
INSERT INTO globalcodes (GlobalCodeId,Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) 
values(8993,'OVERRIDEDENIALREASON      ','OVERRIDEDENIALREASON    ',NULL,'Y','N',1,'01') 
SET IDENTITY_INSERT globalcodes OFF
END

-----GlobalSubCodes entry for Category 'OVERRIDEDENIALREASON    ' 


IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=8993 AND GlobalSubCodeId=6216 AND SubCodeName='Invalid Billing Code' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
SET IDENTITY_INSERT GlobalSubCodes ON
INSERT INTO GlobalSubCodes(GlobalSubCodeId,GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,sortorder)
VALUES(6216,8993,'Invalid Billing Code','Y','N',1)
SET IDENTITY_INSERT GlobalSubCodes OFF
END
GO


IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=8993 AND GlobalSubCodeId=6217 AND SubCodeName='No contract exists for claimed date of service' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
SET IDENTITY_INSERT GlobalSubCodes ON
INSERT INTO GlobalSubCodes(GlobalSubCodeId,GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,sortorder)
VALUES(6217,8993,'No contract exists for claimed date of service','Y','N',2)
SET IDENTITY_INSERT GlobalSubCodes OFF
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=8993 AND GlobalSubCodeId=6218 AND SubCodeName='Claim was received after the period mentioned in the Contract' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
SET IDENTITY_INSERT GlobalSubCodes ON
INSERT INTO GlobalSubCodes(GlobalSubCodeId,GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,sortorder)
VALUES(6218,8993,'Claim was received after the period mentioned in the Contract','Y','N',3)
SET IDENTITY_INSERT GlobalSubCodes OFF
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=8993 AND GlobalSubCodeId=6219 AND SubCodeName='Billing code is not in the Contract' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
SET IDENTITY_INSERT GlobalSubCodes ON
INSERT INTO GlobalSubCodes(GlobalSubCodeId,GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,sortorder)
VALUES(6219,8993,'Billing code is not in the Contract','Y','N',4)
SET IDENTITY_INSERT GlobalSubCodes OFF
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=8993 AND GlobalSubCodeId=6220 AND SubCodeName='Contracted rate is less than the claimed amount' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
SET IDENTITY_INSERT GlobalSubCodes ON
INSERT INTO GlobalSubCodes(GlobalSubCodeId,GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,sortorder)
VALUES(6220,8993,'Contracted rate is less than the claimed amount','Y','N',5)
SET IDENTITY_INSERT GlobalSubCodes OFF
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=8993 AND GlobalSubCodeId=6221 AND SubCodeName='Billing code requires Authorization but one does not exist' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
SET IDENTITY_INSERT GlobalSubCodes ON
INSERT INTO GlobalSubCodes(GlobalSubCodeId,GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,sortorder)
VALUES(6221,8993,'Billing code requires Authorization but one does not exist','Y','N',6)
SET IDENTITY_INSERT GlobalSubCodes OFF
END
GO


IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=8993 AND GlobalSubCodeId=6222 AND SubCodeName='All authorized units have already been used' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
SET IDENTITY_INSERT GlobalSubCodes ON
INSERT INTO GlobalSubCodes(GlobalSubCodeId,GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,sortorder)
VALUES(6222,8993,'All authorized units have already been used','Y','N',7)
SET IDENTITY_INSERT GlobalSubCodes OFF
END
GO



IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=8993 AND GlobalSubCodeId=6223 AND SubCodeName='Claim line exceeds units remaining on Authorization' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
SET IDENTITY_INSERT GlobalSubCodes ON
INSERT INTO GlobalSubCodes(GlobalSubCodeId,GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,sortorder)
VALUES(6223,8993,'Claim line exceeds units remaining on Authorization','Y','N',8)
SET IDENTITY_INSERT GlobalSubCodes OFF
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=8993 AND GlobalSubCodeId=6224 AND SubCodeName='Rendering Provider is required for this service' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
SET IDENTITY_INSERT GlobalSubCodes ON
INSERT INTO GlobalSubCodes(GlobalSubCodeId,GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,sortorder)
VALUES(6224,8993,'Rendering Provider is required for this service','Y','N',9)
SET IDENTITY_INSERT GlobalSubCodes OFF
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=8993 AND GlobalSubCodeId=6225 AND SubCodeName='Specified Rendering Provider is not associated with the Contract' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
SET IDENTITY_INSERT GlobalSubCodes ON
INSERT INTO GlobalSubCodes(GlobalSubCodeId,GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,sortorder)
VALUES(6225,8993,'Specified Rendering Provider is not associated with the Contract','Y','N',10)
SET IDENTITY_INSERT GlobalSubCodes OFF
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=8993 AND GlobalSubCodeId=6226 AND SubCodeName='Specified Rendering Provider is not associated with the Provider' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
SET IDENTITY_INSERT GlobalSubCodes ON
INSERT INTO GlobalSubCodes(GlobalSubCodeId,GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,sortorder)
VALUES(6226,8993,'Specified Rendering Provider is not associated with the Provider','Y','N',11)
SET IDENTITY_INSERT GlobalSubCodes OFF
END
GO


IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=8993 AND GlobalSubCodeId=6227 AND SubCodeName='Rendering Provider is not Credentialed' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
SET IDENTITY_INSERT GlobalSubCodes ON
INSERT INTO GlobalSubCodes(GlobalSubCodeId,GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,sortorder)
VALUES(6227,8993,'Rendering Provider is not Credentialed','Y','N',12)
SET IDENTITY_INSERT GlobalSubCodes OFF
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=8993 AND GlobalSubCodeId=6228 AND SubCodeName='Billing Code Unit Frequency exceeds Contract Rules' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
SET IDENTITY_INSERT GlobalSubCodes ON
INSERT INTO GlobalSubCodes(GlobalSubCodeId,GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,sortorder)
VALUES(6228,8993,'Billing Code Unit Frequency exceeds Contract Rules','Y','N',13)
SET IDENTITY_INSERT GlobalSubCodes OFF
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=8993 AND GlobalSubCodeId=6229 AND SubCodeName='Contract Billing Code amount cap has been reached' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
SET IDENTITY_INSERT GlobalSubCodes ON
INSERT INTO GlobalSubCodes(GlobalSubCodeId,GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,sortorder)
VALUES(6229,8993,'Contract Billing Code amount cap has been reached','Y','N',14)
SET IDENTITY_INSERT GlobalSubCodes OFF
END
GO


IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=8993 AND GlobalSubCodeId=6230 AND SubCodeName='Claimed amount exceeds remaining Contact Billing Code amount cap' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
SET IDENTITY_INSERT GlobalSubCodes ON
INSERT INTO GlobalSubCodes(GlobalSubCodeId,GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,sortorder)
VALUES(6230,8993,'Claimed amount exceeds remaining Contact Billing Code amount cap','Y','N',15)
SET IDENTITY_INSERT GlobalSubCodes OFF
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=8993 AND GlobalSubCodeId=6231 AND SubCodeName='Contract amount cap has been reached' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
SET IDENTITY_INSERT GlobalSubCodes ON
INSERT INTO GlobalSubCodes(GlobalSubCodeId,GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,sortorder)
VALUES(6231,8993,'Contract amount cap has been reached','Y','N',16)
SET IDENTITY_INSERT GlobalSubCodes OFF
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=8993 AND GlobalSubCodeId=6232 AND SubCodeName='Claimed amount exceeds remaining Contact amount cap' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
SET IDENTITY_INSERT GlobalSubCodes ON
INSERT INTO GlobalSubCodes(GlobalSubCodeId,GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,sortorder)
VALUES(6232,8993,'Claimed amount exceeds remaining Contact amount cap','Y','N',17)
SET IDENTITY_INSERT GlobalSubCodes OFF
END
GO


IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=8993 AND GlobalSubCodeId=6233 AND SubCodeName='Claim includes discharge day' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
SET IDENTITY_INSERT GlobalSubCodes ON
INSERT INTO GlobalSubCodes(GlobalSubCodeId,GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,sortorder)
VALUES(6233,8993,'Claim includes discharge day','Y','N',18)
SET IDENTITY_INSERT GlobalSubCodes OFF
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=8993 AND GlobalSubCodeId=6234 AND SubCodeName='Billing Code rate in contract is less than claimed amount' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
SET IDENTITY_INSERT GlobalSubCodes ON
INSERT INTO GlobalSubCodes(GlobalSubCodeId,GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,sortorder)
VALUES(6234,8993,'Billing Code rate in contract is less than claimed amount','Y','N',19)
SET IDENTITY_INSERT GlobalSubCodes OFF
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=8993 AND GlobalSubCodeId=6235 AND SubCodeName='Member is not eligible for any Plan' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
SET IDENTITY_INSERT GlobalSubCodes ON
INSERT INTO GlobalSubCodes(GlobalSubCodeId,GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,sortorder)
VALUES(6235,8993,'Member is not eligible for any Plan','Y','N',20)
SET IDENTITY_INSERT GlobalSubCodes OFF
END
GO


IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=8993 AND GlobalSubCodeId=6236 AND SubCodeName='No rate can be found for this claim line' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
SET IDENTITY_INSERT GlobalSubCodes ON
INSERT INTO GlobalSubCodes(GlobalSubCodeId,GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,sortorder)
VALUES(6236,8993,'No rate can be found for this claim line','Y','N',21)
SET IDENTITY_INSERT GlobalSubCodes OFF
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=8993 AND GlobalSubCodeId=6237 AND SubCodeName='Same Claim Line Exists' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
SET IDENTITY_INSERT GlobalSubCodes ON
INSERT INTO GlobalSubCodes(GlobalSubCodeId,GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,sortorder)
VALUES(6237,8993,'Same Claim Line Exists','Y','N',22)
SET IDENTITY_INSERT GlobalSubCodes OFF
END
GO


IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=8993 AND GlobalSubCodeId=6238 AND SubCodeName='Invalid diagnosis code' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
SET IDENTITY_INSERT GlobalSubCodes ON
INSERT INTO GlobalSubCodes(GlobalSubCodeId,GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,sortorder)
VALUES(6238,8993,'Invalid diagnosis code','Y','N',23)
SET IDENTITY_INSERT GlobalSubCodes OFF
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=8993 AND GlobalSubCodeId=6239 AND SubCodeName='Authorization cannot be found for some date(s) of service' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
SET IDENTITY_INSERT GlobalSubCodes ON
INSERT INTO GlobalSubCodes(GlobalSubCodeId,GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,sortorder)
VALUES(6239,8993,'Authorization cannot be found for some date(s) of service','Y','N',24)
SET IDENTITY_INSERT GlobalSubCodes OFF
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=8993 AND GlobalSubCodeId=6240 AND SubCodeName='Diagnosis not entered on claim' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
SET IDENTITY_INSERT GlobalSubCodes ON
INSERT INTO GlobalSubCodes(GlobalSubCodeId,GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,sortorder)
VALUES(6240,8993,'Diagnosis not entered on claim','Y','N',25)
SET IDENTITY_INSERT GlobalSubCodes OFF
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=8993 AND GlobalSubCodeId=6241 AND SubCodeName='Invalid date(s) of service or number of units' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
SET IDENTITY_INSERT GlobalSubCodes ON
INSERT INTO GlobalSubCodes(GlobalSubCodeId,GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,sortorder)
VALUES(6241,8993,'Invalid date(s) of service or number of units','Y','N',26)
SET IDENTITY_INSERT GlobalSubCodes OFF
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=8993 AND GlobalSubCodeId=6242 AND SubCodeName='Plan copayment' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
SET IDENTITY_INSERT GlobalSubCodes ON
INSERT INTO GlobalSubCodes(GlobalSubCodeId,GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,sortorder)
VALUES(6242,8993,'Plan copayment','Y','N',27)
SET IDENTITY_INSERT GlobalSubCodes OFF
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=8993 AND GlobalSubCodeId=6243 AND SubCodeName='Provider Not Credentialed' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
SET IDENTITY_INSERT GlobalSubCodes ON
INSERT INTO GlobalSubCodes(GlobalSubCodeId,GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,sortorder)
VALUES(6243,8993,'Provider Not Credentialed','Y','N',28)
SET IDENTITY_INSERT GlobalSubCodes OFF
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=8993 AND GlobalSubCodeId=6244 AND SubCodeName='Billing code not associated with the Member''s Plan' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
SET IDENTITY_INSERT GlobalSubCodes ON
INSERT INTO GlobalSubCodes(GlobalSubCodeId,GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,sortorder)
VALUES(6244,8993,'Billing code not associated with the Member''s Plan','Y','N',29)
SET IDENTITY_INSERT GlobalSubCodes OFF
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=8993 AND GlobalSubCodeId=6245 AND SubCodeName='Spenddown not met for period covering date of service' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
SET IDENTITY_INSERT GlobalSubCodes ON
INSERT INTO GlobalSubCodes(GlobalSubCodeId,GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,sortorder)
VALUES(6245,8993,'Spenddown not met for period covering date of service','Y','N',30)
SET IDENTITY_INSERT GlobalSubCodes OFF
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=8993 AND GlobalSubCodeId=6246 AND SubCodeName='Dates of service  not fully covered' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
SET IDENTITY_INSERT GlobalSubCodes ON
INSERT INTO GlobalSubCodes(GlobalSubCodeId,GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,sortorder)
VALUES(6246,8993,'Dates of service  not fully covered','Y','N',31)
SET IDENTITY_INSERT GlobalSubCodes OFF
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=8993 AND GlobalSubCodeId=6247 AND SubCodeName='Waiting for Third Party EOB' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
SET IDENTITY_INSERT GlobalSubCodes ON
INSERT INTO GlobalSubCodes(GlobalSubCodeId,GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,sortorder)
VALUES(6247,8993,'Waiting for Third Party EOB','Y','N',32)
SET IDENTITY_INSERT GlobalSubCodes OFF
END
GO


IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=8993 AND GlobalSubCodeId=6248 AND SubCodeName='Associated plan is pending' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
SET IDENTITY_INSERT GlobalSubCodes ON
INSERT INTO GlobalSubCodes(GlobalSubCodeId,GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,sortorder)
VALUES(6248,8993,'Associated plan is pending','Y','N',33)
SET IDENTITY_INSERT GlobalSubCodes OFF
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=8993 AND GlobalSubCodeId=6249 AND SubCodeName='More than one rate was found for this claim line' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
SET IDENTITY_INSERT GlobalSubCodes ON
INSERT INTO GlobalSubCodes(GlobalSubCodeId,GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,sortorder)
VALUES(6249,8993,'More than one rate was found for this claim line','Y','N',34)
SET IDENTITY_INSERT GlobalSubCodes OFF
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=8993 AND GlobalSubCodeId=6250 AND SubCodeName='The date of service occurred before the date the monthly deductible was met' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
SET IDENTITY_INSERT GlobalSubCodes ON
INSERT INTO GlobalSubCodes(GlobalSubCodeId,GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,sortorder)
VALUES(6250,8993,'The date of service occurred before the date the monthly deductible was met','Y','N',35)
SET IDENTITY_INSERT GlobalSubCodes OFF
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=8993 AND GlobalSubCodeId=6251 AND SubCodeName='Claim line has to be approved manually after Third Party EOB received' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
SET IDENTITY_INSERT GlobalSubCodes ON
INSERT INTO GlobalSubCodes(GlobalSubCodeId,GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,sortorder)
VALUES(6251,8993,'Claim line has to be approved manually after Third Party EOB received','Y','N',36)
SET IDENTITY_INSERT GlobalSubCodes OFF
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=8993 AND GlobalSubCodeId=6252 AND SubCodeName='Multiple rates for claim date span' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
SET IDENTITY_INSERT GlobalSubCodes ON
INSERT INTO GlobalSubCodes(GlobalSubCodeId,GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,sortorder)
VALUES(6252,8993,'Multiple rates for claim date span','Y','N',37)
SET IDENTITY_INSERT GlobalSubCodes OFF
END
GO


IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalSubCodes WHERE GlobalCodeId=8993 AND GlobalSubCodeId=6253 AND SubCodeName='Authorization for this claim is pended' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
SET IDENTITY_INSERT GlobalSubCodes ON
INSERT INTO GlobalSubCodes(GlobalSubCodeId,GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,sortorder)
VALUES(6253,8993,'Authorization for this claim is pended','Y','N',38)
SET IDENTITY_INSERT GlobalSubCodes OFF
END
GO


------------GlobalCode Entry for Reason dropdown-----------------

---GlobalCodeCategory entry for 'DENIALOVERRIDEREASON    '

--Core Category for Other------
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'DENIALOVERRIDEREASON      ') 
BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, [Description], UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) 
VALUES('DENIALOVERRIDEREASON      ','DENIALOVERRIDEREASON    ','Y','Y','Y','Y',NULL,'N','N','N','N') 
END

--Custom globalcodeid for custom values------

IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'xOverrideReasons      ') 
BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, [Description], UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) 
VALUES('xOverrideReasons      ','xOverrideReasons    ','Y','Y','Y','Y',NULL,'N','N','N','N') 
END

-----Global Code entries for DENIALOVERRIDEREASON and xOverrideReasons------

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category='DENIALOVERRIDEREASON      ' and CodeName='OTHER    ' and GlobalCodeId=8994) 
begin 
SET IDENTITY_INSERT globalcodes ON
INSERT INTO globalcodes (GlobalCodeId,Category, CodeName,Code, [Description], Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) 
values(8994,'DENIALOVERRIDEREASON      ','Other','OTHER','Other','Y','N',3,'01') 
SET IDENTITY_INSERT globalcodes OFF
END

-------------------------------------------------------------For custom--------------------

IF EXISTS (SELECT * FROM globalcodes WHERE Category='xOverrideReasons      ' and CodeName='xOverrideReasons    ' and Code='20 Sessions Used') 
begin 
 Update globalcodes set Category='DENIALOVERRIDEREASON' , CodeName='DENIALOVERRIDEREASON      ' , Code='20 Sessions Used'
END
else
begin
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category='DENIALOVERRIDEREASON      ' and Code='20 Sessions Used' ) 
	begin
	INSERT INTO globalcodes (Category, CodeName,Code, [Description], Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) 
	values('DENIALOVERRIDEREASON      ','20 Sessions Used','20 Sessions Used','20 Sessions Used','Y','N',1,'01') 
	end
END

IF EXISTS (SELECT * FROM globalcodes WHERE Category='xOverrideReasons      ' and CodeName='xOverrideReasons    ' and Code='Out of County') 
begin 
Update globalcodes set Category='DENIALOVERRIDEREASON' , CodeName='DENIALOVERRIDEREASON      ' , Code='Out of County'
END
else
begin
    IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category='DENIALOVERRIDEREASON      ' and Code='Out of County' ) 
	begin
	INSERT INTO globalcodes (Category, CodeName,Code, [Description], Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) 
	values('DENIALOVERRIDEREASON      ','Out of County','Out of County','Out of County','Y','N',2,'01') 
	end
END