/********************************************************************************************
		Insert script for Registration - Document - Validation Messgae

Author			:  AlokKumar Meher 
CreatedDate		:  26 Aug 2018 
Purpose			:  Insert script for DocumentValidations
*********************************************************************************************/

DECLARE @DocumentCodeId INT
DECLARE @DocumentCode VARCHAR(100)

SET @DocumentCode = 'BDE62873-41E5-4842-AB04-C7E4D6D32C8D'
SET @DocumentCodeId = (SELECT Top 1 DocumentCodeId FROM DocumentCodes WHERE Code = @DocumentCode)

DELETE FROM  DocumentValidations WHERE DocumentCodeId=@DocumentCodeId
----Select * FROM  DocumentValidations WHERE DocumentCodeId=@DocumentCodeId



--Tab: Additional Information

INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentCodeId,Null,'Additional Information','4','DocumentRegistrationAdditionalInformations','EducationalLevel','FROM DocumentRegistrationAdditionalInformations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(EducationalLevel,'''')='''' ', 'Additional Information – Education level is required',1,'Additional Information – Education level is required')
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentCodeId,Null,'Additional Information','4','DocumentRegistrationAdditionalInformations','EducationStatus','FROM DocumentRegistrationAdditionalInformations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(EducationStatus,'''')='''' ', 'Additional Information – Education status is required',2,'Additional Information – Education status is required')
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentCodeId,Null,'Additional Information','4','DocumentRegistrationAdditionalInformations','EmploymentStatus','FROM DocumentRegistrationAdditionalInformations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(EmploymentStatus,'''')='''' ', 'Additional Information – Employment status is required',3,'Additional Information – Employment status is required')
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentCodeId,Null,'Additional Information','4','DocumentRegistrationAdditionalInformations','MilitaryStatus','FROM DocumentRegistrationAdditionalInformations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(MilitaryStatus,'''')='''' ', 'Additional Information – Have you ever or are you currently serving in the military is required',4,'Additional Information – Have you ever or are you currently serving in the military is required')
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentCodeId,Null,'Additional Information','4','DocumentRegistrationAdditionalInformations','SmokingStatus','FROM DocumentRegistrationAdditionalInformations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(SmokingStatus,'''')='''' ', 'Additional information – Tobacco Use is required',5,'Additional information – Tobacco Use is required')

INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentCodeId,Null,'Additional Information','4','DocumentRegistrationAdditionalInformations','AdvanceDirective','FROM DocumentRegistrationAdditionalInformations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(AdvanceDirective,'''')='''' ', 'Additional information – Advance Directive is required',6,'Additional information – advance directive is required')
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentCodeId,Null,'Additional Information','4','DocumentRegistrationAdditionalInformations','LivingArrangments','FROM DocumentRegistrationAdditionalInformations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(LivingArrangments,'''')='''' ', 'Additional information – Living Arrangements is required',7,'Additional information – living arrangements is required')



--Tab: Insurance

--INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentCodeId,Null,'Insurance','5','DocumentRegistrationCoverageInformations','InsuredId','FROM DocumentRegistrationCoverageInformations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(InsuredId,'''')='''' ', 'Coverage information- Insurance ID is required',1,'Coverage information- Insurance ID is required')
--INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentCodeId,Null,'Insurance','5','DocumentRegistrationCoverageInformations','GroupId','FROM DocumentRegistrationCoverageInformations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(GroupId,'''')='''' ', 'Coverage information-Group ID is required',2,'Coverage information-Group ID is required')



--Tab: Episode

INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentCodeId,Null,'Episode','6','DocumentRegistrationEpisodes','RegistrationDate','FROM DocumentRegistrationEpisodes WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RegistrationDate,'''')='''' ', 'Case information – Registration Date is required',1,'Case information – Registration Date is required')
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentCodeId,Null,'Episode','6','DocumentRegistrationEpisodes','ReferralDate','FROM DocumentRegistrationEpisodes WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(ReferralDate,'''')='''' ', 'Referral Resource – Referral Date is required',2,'Referral Resource – Referral Date is required')
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentCodeId,Null,'Episode','6','DocumentRegistrationEpisodes','ReferralType','FROM DocumentRegistrationEpisodes WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(ReferralType,'''')='''' ', 'Referral Resource – Referral Type is required',3,'Referral Resource – Referral Type is required')
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage])Values('Y',@DocumentCodeId,Null,'Episode','6','DocumentRegistrationEpisodes','ReferralOrganization','FROM DocumentRegistrationEpisodes WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(ReferralOrganization,'''')='''' AND (ISNULL(ReferrralFirstName,'''')='''' OR ISNULL(ReferrralLastName,'''')='''') AND (dbo.GetGlobalCodeName(ReferralType))!=''Family'' AND (dbo.GetGlobalCodeName(ReferralType))!=''Self''  ', 'Referral Resource – Organization name  or first/last name  is required',4,'Referral Resource – Organization name  or first/last name  is required')




--Tab: Program Enrollment

INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentCodeId,Null,'Program Enrollment','7','DocumentRegistrationProgramEnrollments','PrimaryProgramId','FROM DocumentRegistrationProgramEnrollments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(PrimaryProgramId,'''')='''' ', 'Primary program is required',1,'Primary program is required')
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentCodeId,Null,'Program Enrollment','7','DocumentRegistrationProgramEnrollments','ProgramStatus','FROM DocumentRegistrationProgramEnrollments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(ProgramStatus,'''')=''''', 'Status is required',2,'Status is required')
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentCodeId,Null,'Program Enrollment','7','DocumentRegistrationProgramEnrollments','ProgramRequestedDate','FROM DocumentRegistrationProgramEnrollments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(ProgramRequestedDate,'''')='''' AND (dbo.GetGlobalCodeName(ProgramStatus))=''Referred'' ', 'Requested date is required',3,'Requested date is required')
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y',@DocumentCodeId,Null,'Program Enrollment','7','DocumentRegistrationProgramEnrollments','ProgramEnrolledDate','FROM DocumentRegistrationProgramEnrollments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(ProgramEnrolledDate,'''')=''''  AND (dbo.GetGlobalCodeName(ProgramStatus))=''Enrolled'' ', 'Enrolled date is required',4,'Enrolled date is required')





