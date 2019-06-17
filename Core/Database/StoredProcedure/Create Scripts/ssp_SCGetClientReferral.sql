/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientReferral]    Script Date: 03/31/2015 18:41:35 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetClientReferral]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetClientReferral]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientReferral]    Script Date: 03/31/2015 18:41:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ssp_SCGetClientReferral] @ClientId INT
	-- =============================================
	-- Author:		<Author,,Name>
	-- Create date: <Create Date,,>
	-- Description:	<Description,,>
	-- 25.05.2012	Vaibhav Khare		For Client information(c) tab 
	--Modified
	-- 14.Jul.2017	Alok Kumar		Added columns ProviderType, ProviderId in table ClientEpisodes for task#47 - Meaningful Use - Stage 3
	/*19 Aug 2018	Alok Kumar		Modified query related to ClientEpisodes table to return some more columns.	Ref#618 EII.				*/
	-- =============================================
AS
BEGIN
	BEGIN TRY
	--Clients                                                                                                                           
    SELECT  ClientId ,  
            ExternalClientId ,  
            Active ,  
            MRN ,  
            LastName ,  
            FirstName ,  
            MiddleName ,  
            Prefix ,  
            Suffix ,  
            SSN ,  
            SUBSTRING(SSN, 6, 9) AS ShortSSN ,  
            CONVERT(VARCHAR(5), DATEDIFF(YEAR, DOB, GETDATE()) - 1) + ' Years' AS Age ,  
            Sex ,  
            DOB ,  
            PrimaryClinicianId ,  
            CountyOfResidence ,  
            CountyOfTreatment ,  
            CorrectionStatus ,  
            Email ,  
            Comment ,  
            LivingArrangement ,  
            NumberOfBeds ,  
            MinimumWage ,  
            FinanciallyResponsible ,  
            AnnualHouseholdIncome ,  
            NumberOfDependents ,  
            MaritalStatus ,  
            EmploymentStatus ,  
            EmploymentInformation ,  
            MilitaryStatus ,  
            EducationalStatus ,  
            DoesNotSpeakEnglish ,  
            PrimaryLanguage ,  
            CurrentEpisodeNumber ,  
            AssignedAdminStaffId ,  
            InpatientCaseManager ,  
            InformationComplete ,  
            PrimaryProgramId ,  
            LastNameSoundex ,  
            FirstNameSoundex ,  
            CurrentBalance ,  
            CareManagementId ,  
            HispanicOrigin ,  
            DeceasedOn ,  
            LastStatementDate ,  
            LastPaymentId ,  
            LastClientStatementId ,  
            DoNotSendStatement ,  
            DoNotSendStatementReason ,  
            AccountingNotes ,  
            MasterRecord ,  
            ProviderPrimaryClinicianId ,  
            RowIdentifier ,  
            ExternalReferenceId ,  
            CreatedBy ,  
            DoNotOverwritePlan ,  
            Disposition ,  
            NoKnownAllergies ,  
            CreatedDate ,  
            ModifiedBy ,  
            ModifiedDate ,  
            RecordDeleted ,  
            DeletedDate ,  
            DeletedBy ,  
            ReminderPreference,  
            MobilePhoneProvider,  
   SchedulingPreferenceMonday,  
   SchedulingPreferenceTuesday,  
   SchedulingPreferenceWednesday,  
   SchedulingPreferenceThursday,  
   SchedulingPreferenceFriday,  
   GeographicLocation,  
   SchedulingComment,  
   CauseofDeath,  
   FosterCareLicence,  
   PrimaryPhysicianId,  
   UserStaffId,  
   -- Aug 28 2014  Veena S Mani    Added below 4 columns.  
   AllergiesLastReviewedBy,  
   AllergiesLastReviewedDate,  
   AllergiesReviewStatus,  
   HasNoMedications  
   ,ProfessionalSuffix  
     
    FROM    Clients  
    WHERE   ( ClientId = @ClientID )  
            AND ( RecordDeleted IS NULL  
                  OR RecordDeleted = 'N'  
                ) 
	
	----ClientEpisodes
		SELECT 0 AS DeleteButton
			,GC.CodeName
			,CE.ClientEpisodeId
			,CE.CreatedBy
			,CE.CreatedDate
			,CE.ModifiedBy
			,CE.ModifiedDate
			,CE.RecordDeleted
			,CE.DeletedDate
			,CE.DeletedBy
			,CE.ClientId
			,CE.EpisodeNumber
			,CE.RegistrationDate
			,CE.STATUS
			,CE.DischargeDate
			,CE.InitialRequestDate
			,CE.IntakeStaff
			,CE.AssessmentDate
			,CE.AssessmentFirstOffered
			,CE.AssessmentDeclinedReason
			,CE.TxStartDate
			,CE.TxStartFirstOffered
			,CE.TxStartDeclinedReason
			,CE.RegistrationComment
			,CE.ReferralSource
			,CE.ReferralDate
			,CE.ReferralType
			,CE.ReferralSubtype
			,CE.ReferralName
			,CE.ReferralAdditionalInformation
			,CE.ReferralReason1
			,CE.ReferralReason2
			,CE.ReferralReason3
			,CE.ReferralComment
			,CE.ExternalReferralInformation
			,CE.HasAlternateTreatmentOrder
			,CE.AlternateTreatmentOrderType
			,CE.AlternateTreatmentOrderExpirationDate
			,CE.ProviderType								--14.Jul.2017	Alok Kumar
			,CE.ProviderId
			,CE.ReferralOrganizationName
			,CE.ReferrralPhone
			,CE.ReferrralFirstName
			,CE.ReferrralLastName
			,CE.ReferrralAddressLine1
			,CE.ReferrralAddressLine2
			,CE.ReferrralCity
			,CE.ReferrralState
			,CE.ReferrralZipCode
			,CE.ReferrralEmail
		FROM ClientEpisodes AS CE
		LEFT JOIN GlobalCodes AS GC ON CE.STATUS = GC.GlobalCodeId
		WHERE (CE.ClientId = @ClientID)
			AND (
				CE.RecordDeleted IS NULL
				OR CE.RecordDeleted = 'N'
				)
		ORDER BY CE.EpisodeNumber ASC
		
		
		
		
	
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetClientReferral') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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

