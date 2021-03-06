IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   OBJECT_ID = OBJECT_ID(N'[ssp_SCCreationofPatientStaff]')
                    AND OBJECTPROPERTY(OBJECT_ID, N'IsProcedure') = 1 ) 
    DROP PROCEDURE [dbo].[ssp_SCCreationofPatientStaff]
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
						 
Create PROCEDURE [dbo].[ssp_SCCreationofPatientStaff] 
@ClientId INT
	/********************************************************************************  
-- Stored Procedure: dbo.ssp_SCCreationofPatientStaff  
--  
-- Copyright: Streamline Healthcate Solutions  
--  
-- Purpose: To creat Patient Portal Staff  
--  
-- Updates:                                                         
-- Date					Author				Purpose  
-- 11/24/2014			Chethan N			To create Patient Portal Staff on creation of Client      
-- 11/03/2017			jcarlson			Harbor Support 1529 -  this stored procedure was overwriting the Role Setup for Patient Portal Role, 
												removed logic that would push items into permission templates and permission template items tables 
-- 11/29/2017			jcarlson			Harbor Support 1529 - bring removed logic back per core review
																	add conditional to only insert template items if they do not already exist
-- 2/27/2019			tchen				What: When creating non-staff users, made sure IntakeStaff field is inserted as 'N'
											Why : HighPlains - Environment Issues Tracking #94
*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		-- Script to insert Staff from Clients , roles and related tables
-- Gautam Task #20, MeaningfulUse

-- Insert all clients where UserStaffId is null and active 
Declare @UsePatientPortal varchar(1)=null
select @UsePatientPortal= [Value] from SystemConfigurationKeys where [key] = 'USEPATIENTPORTAL' and  isnull(RecordDeleted,'N')='N'

IF @UsePatientPortal='Y'
Begin
		
		Insert Into Staff
		(CreatedBy,
		CreatedDate,
		ModifiedBy,
		ModifiedDate,
		UserCode,
		LastName,
		FirstName,
		MiddleName,
		Active,
		SSN,
		Sex,
		DOB,
		CosignRequired,
		Clinician,
		Attending,
		ProgramManager,
		IntakeStaff,
		AppointmentSearch,
		CoSigner,
		AdminStaff,
		Prescriber,
		UserPassword,
		AllowedPrinting,
		InLineSpellCheck,
		DisplayPrimaryClients,
		EncryptionSwitch,--'Y'
		PasswordExpiresNextLogin,--'Y'
		AccessCareManagement,
		AccessSmartCare,--'Y'
		AccessPracticeManagement,
		Administrator,
		SystemAdministrator,
		CanViewStaffProductivity,
		CanCreateManageStaff,
		AllowRemoteAccess,--'Y'
		AccessProviderAccess,
		Initial,
		DisplayAs,
		NonStaffUser,
		TempClientId,
		ClientPagePreferenceScreenId,
		HomePageScreenId)
		Select 'SHSDBA',GetDate(),'SHSDBA',GetDate(),
				SUBSTRING(SUBSTRING(ltrim(FirstName),1,1)+ rtrim(ltrim(LastName)) + cast (Clients.ClientId as varchar(20)),1,30),
				SUBSTRING(LastName,1,30),SUBSTRING(FirstName,1,20),SUBSTRING(MiddleName,1,20),'Y',SSN,'U',DOB,'N',
				'N','N','N','N','N','N','N','N',
				'JXm7CJyoCBnURIrneTtflA==','N','N','N','Y','Y','N','Y','N','N','N','N','N','Y','N',LEFT(FirstName,1)+ LEFT(LastName,1),
				SUBSTRING(LastName +', ' + FirstName,1,60),'Y',Clients.ClientId,977,977
		From Clients 
		where UserStaffId is null and ISNULL(RecordDeleted,'N')='N'	and ISNULL(Active,'N')='Y'	and Clients.ClientId=@ClientId
		
		-- update the UserStaffId from Staff to Clients table
		
		Update C 
		Set C.UserStaffId=S.StaffId
		From Clients C	Join Staff S On C.ClientId=S.TempClientId
		Where C.UserStaffId is null


		-- Now insert data in all related staff permission tables
		
		IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes where Category='STAFFROLE' and CodeName='PATIENTPORTALUSER' and ISNULL(RecordDeleted,'N')='N')
		BEGIN
			INSERT INTO GlobalCodes(Category,CodeName,code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
			VALUES('STAFFROLE','PATIENTPORTALUSER','PATIENTPORTALUSER',NULL,'Y','Y',NULL,'CLIENTSTAFF',NULL,NULL,NULL,NULL,NULL,NULL) 
		END
		
		
		Declare @PatientPortalRoleId Int
	
		Select top 1 @PatientPortalRoleId =GlobalCodeId FROM GlobalCodes where Category='STAFFROLE' and CodeName='PATIENTPORTALUSER' and ISNULL(RecordDeleted,'N')='N'
		-- Insert into StaffRoles
		Insert Into StaffRoles
		(StaffId,RoleId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
		Select S.StaffId,@PatientPortalRoleId,'SHSDBA',GetDate(),'SHSDBA',GetDate()
		From Staff S
		Where S.TempClientId = @ClientId
		and not exists(Select 1 from StaffRoles SR where SR.RoleId=@PatientPortalRoleId and SR.StaffId=S.StaffId and ISNULL(SR.RecordDeleted,'N')='N')	

		-- Insert into PermissionTemplates
		
		
		Insert Into PermissionTemplates
		(RoleId,PermissionTemplateType,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
		Select @PatientPortalRoleId,G.GlobalCodeId ,'SHSDBA',GetDate(),'SHSDBA',GetDate()
		from GlobalCodes G where G.Category='PERMISSIONTEMPLATETP' and ISNULL(G.RecordDeleted,'N')='N'
		and not exists(Select 1 from PermissionTemplates SR where SR.PermissionTemplateType=G.GlobalCodeId 
															And SR.RoleId=@PatientPortalRoleId and ISNULL(SR.RecordDeleted,'N')='N')

		Declare @PermissionTemplateId int
		Select top 1 @PermissionTemplateId= PermissionTemplateId  From PermissionTemplates where RoleId=@PatientPortalRoleId 
							and PermissionTemplateType=5703 and ISNULL(RecordDeleted,'N')='N'
					
		-- Insert into PermissionTemplateItems for Banners

		--Only insert template items if there are non ( even record deleted ) for the Template Id
		--we consider any record because if they have any than the customer has modified the role in some way
		IF NOT EXISTS ( SELECT 1 
						FROM dbo.PermissionTemplateItems AS a
						WHERE a.PermissionTemplateId = @PermissionTemplateId
						)
		BEGIN
	
			Insert Into PermissionTemplateItems
			(PermissionTemplateId,PermissionItemId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
			Select @PermissionTemplateId,B.BannerId,'SHSDBA',GetDate(),'SHSDBA',GetDate()
			from Banners B where B.ScreenId in (5,13,45,715,718,721,775,973,977,985,984)
								and isnull(B.RecordDeleted,'N')='N' 
			and not exists(Select 1 from PermissionTemplateItems SR where SR.PermissionTemplateId=@PermissionTemplateId and
							 SR.PermissionItemId=B.BannerId and B.ScreenId in (5,13,45,715,718,721,775,973,977,985,984) and ISNULL(SR.RecordDeleted,'N')='N')						 
						 
			Select top 1 @PermissionTemplateId= PermissionTemplateId  From PermissionTemplates where RoleId=@PatientPortalRoleId 
								and PermissionTemplateType=5702 and ISNULL(RecordDeleted,'N')='N'	
		
			-- Insert into PermissionTemplateItems for DocumentCodes
		
		
			Insert Into PermissionTemplateItems
			(PermissionTemplateId,PermissionItemId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
			Select @PermissionTemplateId,B.DocumentCodeId,'SHSDBA',GetDate(),'SHSDBA',GetDate()
			from DocumentCodes B where B.DocumentCodeId =5 
								and isnull(B.RecordDeleted,'N')='N' 
			and not exists(Select 1 from PermissionTemplateItems SR where SR.PermissionTemplateId=@PermissionTemplateId and
							 SR.PermissionItemId=B.DocumentCodeId and ISNULL(SR.RecordDeleted,'N')='N')	
		 END


					 
End					
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCCreationofPatientStaff') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                    
				16
				,-- Severity.                                                                                    
				1 -- State.                                                                                    
				);
	END CATCH
END

GO

