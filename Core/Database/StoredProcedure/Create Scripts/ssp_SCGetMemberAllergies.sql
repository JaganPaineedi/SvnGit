/****** Object:  StoredProcedure [dbo].[ssp_SCGetMemberAllergies]    Script Date: 11/19/2013 10:53:22 AM ******/
IF EXISTS ( SELECT	1
			FROM	INFORMATION_SCHEMA.ROUTINES
			WHERE	SPECIFIC_SCHEMA = 'dbo'
					AND SPECIFIC_NAME = 'ssp_SCGetMemberAllergies' ) 
	DROP PROCEDURE [dbo].[ssp_SCGetMemberAllergies]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetMemberAllergies] 123753   Script Date: 11/19/2013 10:53:22 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[ssp_SCGetMemberAllergies] ( @ClientId INT )
AS 

/************************************************************************/                                                              
/* Stored Procedure: ssp_SCGetMemberAllergies      */                                                     
/*        */                                                              
/* Creation Date:  11/19/2013           */                                                              
/*                  */                                                              
/* Purpose: Gets Data for ssp_SCGetMemberAllergies     */                                                             
/* Input Parameters: ClientId        */                                                            
/* Output Parameters:             */                                                              
/* Calls:                */  
                                                                                                                          
/* Author: Chuck Blaine          */     
/* Data Modifications:                                               */                        
/*                                                                   */                        
/*   Updates:                                                          */                                     
/*       Date              Author                  Purpose            */
/*	09/July/2014		Md Hussain Khusro		Added 'UserStaffId' in clients table result set as the new column is added in clients table wrt task#20 Meaningful Use 
												for task #1158 Philhaven - Customization Issues Tracking   */
/*	09/July/2014		Jagan		Added 'ProfessionalSuffix' in clients table result set as the new column is added in clients table wrt task#801 Woods Customizations 
												for task #1232 Philhaven - Customization Issues Tracking   */
/* 29/Jan/2015			Chethan N				What: Commented Union statement of ClientAllergyHistory table.
												Why: Philhaven - Customization Issues Tracking task# 1200 */
/* 09/Feb/2015			Chethan N				What: Record Deleted check for MDAllergenConcepts table.
												Why: Philhaven - Customization Issues Tracking task# 1232 */
/* 24/Aug/2015			Chethan N				What: Retrieving Distinct ClientAllergies.
												Why: Key Point - Environment Issues Tracking task# 104 */
/* 12/02/2016			Lakshmi   			    What: Added some coloumns to clients select query 
												Why: Woods - Environment Issues Tracking #122 */
/* 28-April-2016        SuryaBalan              Pathway - Customizations #44 Fixed My Preferences "Click on unsaved change for Client Allergies received error"
                                                Issue is Because Main table for Client Allergy screen is Clients Table, so it should be in first place in Dataset(but it is not) so it is throwing error when click on unsaved changes*/
/* 13-Feb-2017         Himmat                   woods support go live - #530*/
/* 03-April-2017       Bernardin                Reverted Previous changes and selected 'SexualOrientation' column from Clients table.woods support go live - #586*/
/* 09-May-2017         Himmat                   Added "NoKnownAllergiesLastUpdatedBy","NoKnownAllergiesLastUpdatedDate" in Clients table.to display last ModifiedBy,ModifiedDate , client Allergey woods support go live - #599 */    
/* 10-August-2017      Arjun K R                Added "AllergyReaction" and "AllergySeverity" column into ClientAllergies and ClientAllergyHistory select statements.Task #49 MeaningfullUse Stage 3*/
/*********************************************************************/ 

	BEGIN TRY
  -- Clients  
  
  SELECT c.ClientId  
     , c.CreatedBy  
     , c.CreatedDate  
    -- ,CASE       
    --WHEN  isnull (c.NoKnownAllergies,'N') = 'N'        
    -- THEN ISNULL(c.ModifiedBy, '')    
    --   else ''
    -- End as 'ModifiedBy'
     , c.ModifiedBy  
     , c.ModifiedDate  
     , c.RecordDeleted  
     , c.DeletedDate  
     , c.DeletedBy  
     , c.ExternalClientId  
     , c.Active  
     , c.MRN  
      --Added by Revathi  19 Oct 2015    
    ,CASE     
    WHEN ISNULL(ClientType, 'I') = 'I'    
     THEN ISNULL(c.LastName, '') -- + ', ' + ISNULL(c.FirstName, '')    
    ELSE ISNULL(c.OrganizationName, '')    
    END AS 'Name'       
     , c.LastName --uncommented LastName,FirstName by Lakshmi on 12/02/2016  
     , c.FirstName   
     , c.MiddleName  
     , c.Prefix  
     , c.Suffix  
     , c.SSN  
     , c.Sex  
     , c.DOB  
     , c.PrimaryClinicianId  
     , c.CountyOfResidence  
     , c.CountyOfTreatment  
     , c.CorrectionStatus  
     , c.Email  
     , c.Comment  
     , c.LivingArrangement  
     , c.NumberOfBeds  
     , c.MinimumWage  
     , c.FinanciallyResponsible  
     , c.AnnualHouseholdIncome  
     , c.NumberOfDependents  
     , c.MaritalStatus  
     , c.EmploymentStatus  
     , c.EmploymentInformation  
     , c.MilitaryStatus  
     , c.EducationalStatus  
     , c.DoesNotSpeakEnglish  
     , c.PrimaryLanguage  
     , c.CurrentEpisodeNumber  
     , c.AssignedAdminStaffId  
     , c.InpatientCaseManager  
     , c.InformationComplete  
     , c.PrimaryProgramId  
     , c.LastNameSoundex  
     , c.FirstNameSoundex  
     , c.CurrentBalance  
     , c.CareManagementId  
     , c.HispanicOrigin  
     , c.DeceasedOn  
     , c.LastStatementDate  
     , c.LastPaymentId  
     , c.LastClientStatementId  
     , c.DoNotSendStatement  
     , c.DoNotSendStatementReason  
     , c.AccountingNotes  
     , c.MasterRecord  
     , c.ProviderPrimaryClinicianId  
     , c.RowIdentifier  
     , c.ExternalReferenceId  
     , c.DoNotOverwritePlan  
     , c.Disposition  
     , c.NoKnownAllergies  
     , c.ReminderPreference  
     , c.MobilePhoneProvider  
     , c.SchedulingPreferenceMonday  
     , c.SchedulingPreferenceTuesday  
     , c.SchedulingPreferenceWednesday  
     , c.SchedulingPreferenceThursday  
     , c.SchedulingPreferenceFriday  
     , c.GeographicLocation  
     , c.SchedulingComment  
     , c.CauseofDeath  
     , c.FosterCareLicence  
     , c.PrimaryPhysicianId  
     ,c.AllergiesLastReviewedBy --Added AllergiesLastReviewedBy,AllergiesLastReviewedDate,AllergiesReviewStatus,                 AllergiesReviewStatus, HasNoMedications by Lakshmi on 12/02/2016  
              ,c.AllergiesLastReviewedDate  
              ,c.AllergiesReviewStatus  
              ,c.HasNoMedications   
     , ISNULL('Last reviewed by: ' + s.FirstName + ' ' + s.LastName  
        + '<br />On '  
        + REPLACE(REPLACE(CONVERT(VARCHAR(30), car.AllergiesLastReviewedDate, 100),  
           'AM', ' AM'), 'PM', ' PM')  
        + '<br /> Status: '  
        + ISNULL(CONVERT(VARCHAR(500), gc.Description), ''), '') AS LastReviewInfo  
     ,UserStaffId -- Added on 09/July/2014 by Hussain Khusro   
     ,ProfessionalSuffix   
              ,ClientType   
             , OrganizationName   
              ,EIN    
              ,GenderIdentity  
              ,SexualOrientation
              ,NoKnownAllergiesLastUpdatedBy    
              ,NoKnownAllergiesLastUpdatedDate  
  FROM dbo.Clients c  
    LEFT JOIN dbo.ClientAllergyReviews car ON car.ClientId = c.ClientId  
                AND car.ClientAllergyReviewId = ( SELECT TOP 1  
                 ClientAllergyReviewId  
                 FROM  
                 dbo.ClientAllergyReviews  
                 WHERE  
                 ClientId = c.ClientId  
                 ORDER BY CreatedDate DESC  
                 )  
    LEFT JOIN dbo.Staff s ON s.UserCode = car.AllergiesLastReviewedBy  
    LEFT JOIN dbo.GlobalCodes gc ON gc.GlobalCodeId = car.AllergiesReviewStatus  
  WHERE c.ClientId = @ClientId  
    AND ISNULL(c.RecordDeleted, 'N') = 'N' 
 
	
	-- Client Allergy History

		SELECT	cah.ClientAllergyHistoryId
			  , cah.CreatedBy
			  , cah.CreatedDate
			  , cah.ModifiedBy
			  , cah.ModifiedDate
			  , cah.RecordDeleted
			  , cah.DeletedDate
			  , cah.DeletedBy
			  , cah.ClientAllergyId
			  , cah.Active
			  , cah.AllergyType
			  , cah.Comment
			  , cah.SNOMEDCode
			  , gc.CodeName AS SNOMEDCodeName
			  , cah.LastReviewedBy
			  , cah.AllergyReaction -- 10-August-2017      Arjun K R    
			  , cah.AllergySeverity
		FROM	dbo.ClientAllergyHistory cah
				LEFT JOIN dbo.GlobalCodes gc ON gc.GlobalCodeId = cah.SNOMEDCode
				JOIN dbo.ClientAllergies ca ON ca.ClientAllergyId = cah.ClientAllergyId
		WHERE	ISNULL(cah.RecordDeleted, 'N') = 'N'
				AND ca.ClientId = @ClientId

	

	-- Client Allergy Reviews

		SELECT	ClientAllergyReviewId
			  , CreatedBy
			  , CreatedDate
			  , ModifiedBy
			  , ModifiedDate
			  , RecordDeleted
			  , DeletedDate
			  , DeletedBy
			  , ClientId
			  , AllergiesLastReviewedBy
			  , AllergiesLastReviewedDate
			  , AllergiesReviewStatus
		FROM	dbo.ClientAllergyReviews car
		WHERE	car.ClientId = @ClientId
		ORDER BY CreatedDate DESC
  
  -- Review History
		DECLARE	@ReviewHistory AS VARCHAR(MAX) = '';
		DECLARE	@History TABLE
			(
			  History VARCHAR(MAX) NULL
			);
		INSERT	INTO @History
				SELECT	ISNULL(REPLACE(REPLACE(CONVERT(VARCHAR(30), car.AllergiesLastReviewedDate, 100),
											   'AM', ' AM'), 'PM', ' PM')
							   + ' - ' + s.FirstName + ' ' + s.LastName + ' ('
							   + ISNULL(CONVERT(VARCHAR(500), gc.Description),
										''), '') + ')<br />'
				FROM	dbo.ClientAllergyReviews AS car
						LEFT JOIN dbo.Staff s ON s.UserCode = car.AllergiesLastReviewedBy
						LEFT JOIN dbo.GlobalCodes gc ON gc.GlobalCodeId = car.AllergiesReviewStatus
				WHERE	car.ClientId = @ClientId
				ORDER BY car.AllergiesLastReviewedDate DESC

		SELECT	@ReviewHistory = @ReviewHistory + History
		FROM	@History
		
		SELECT	'Review History: ' + '<br />' + @ReviewHistory AS ReviewHistoryRecord
		
		 -- Client Allergies
    
		SELECT *
		FROM (
			SELECT ROW_NUMBER() OVER (
					PARTITION BY ca.ClientAllergyId ORDER BY ca.ClientAllergyId
					) AS row
				,ca.ClientAllergyId
				,ca.CreatedBy
				,ca.CreatedDate
				,ca.ModifiedBy
				,ca.ModifiedDate
				,ca.RecordDeleted
				,ca.DeletedDate
				,ca.DeletedBy
				,ca.ClientId
				,ca.AllergenConceptId
				,ca.AllergyType
				,ca.Comment
				,ca.Active
				,ca.SNOMEDCode
				,gc.CodeName AS SNOMEDCodeName
				,mda.ConceptDescription AS AllergenConceptName
				,COALESCE((LTRIM(RTRIM(s2.LastName)) + ', ' + LTRIM(RTRIM(s2.FirstName))), (LTRIM(RTRIM(s.LastName)) + ', ' + LTRIM(RTRIM(s.FirstName)))) + ' on ' + REPLACE(REPLACE(CONVERT(VARCHAR(30), ca.ModifiedDate, 100), 'AM', ' AM'), 'PM', ' PM') AS ModifiedInfo
				,s.StaffId AS ModifiedById
				,CASE ca.Active
					WHEN 'Y'
						THEN 'Yes'
					ELSE 'No'
					END AS ActiveLabel
				,CASE ca.AllergyType
					WHEN 'A'
						THEN 'Allergy'
					WHEN 'I'
						THEN 'Intolerance'
					WHEN 'F'
						THEN 'Failed Trial'
					END AS AllergyTypeLabel
				,ca.LastReviewedBy
				,ca.AllergyReaction  -- 10-August-2017      Arjun K R    
				,ca.AllergySeverity
			FROM dbo.ClientAllergies ca
			LEFT JOIN dbo.GlobalCodes gc ON gc.GlobalCodeId = ca.SNOMEDCode
			INNER JOIN dbo.MDAllergenConcepts mda ON mda.AllergenConceptId = ca.AllergenConceptId
			INNER JOIN dbo.Staff s ON s.UserCode = ca.ModifiedBy
			LEFT JOIN dbo.Staff s2 ON s2.StaffId = ca.LastReviewedBy
			WHERE ISNULL(ca.RecordDeleted, 'N') = 'N'
				AND ca.ClientId = @ClientId
				AND ISNULL(mda.RecordDeleted, 'N') = 'N'-- Chethan N changes on 09/Feb/2015
			) AS t
		WHERE t.row = 1 
        
	END TRY

	BEGIN CATCH
		DECLARE	@Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
			+ CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
			+ ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
					 'ssp_SCGetMemberAllergies') + '*****'
			+ CONVERT(VARCHAR, ERROR_LINE()) + '*****'
			+ CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
			+ CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
			@Error
			,-- Message text.                            
			16
			,-- Severity.                            
			1 -- State.                            
			);
	END CATCH

GO


