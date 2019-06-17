/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientEpisode]    Script Date: 03/31/2015 18:41:35 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetClientEpisode]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetClientEpisode]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientEpisode]    Script Date: 03/31/2015 18:41:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ssp_SCGetClientEpisode] @ClientId INT
	-- =============================================
	-- Author:		<Author,,Name>
	-- Create date: <Create Date,,>
	-- Description:	<Description,,>
	-- 25.05.2012	Vaibhav Khare		For Client information(c) tab 
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
			,CE.ReferralSubType
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
		FROM ClientEpisodes AS CE
		LEFT JOIN GlobalCodes AS GC ON CE.STATUS = GC.GlobalCodeId
		WHERE (CE.ClientId = @ClientID)
			AND (
				CE.RecordDeleted IS NULL
				OR CE.RecordDeleted = 'N'
				)
		ORDER BY CE.EpisodeNumber ASC
		
		
		
		
		-- CustomTimeliness                                                                          
    SELECT  ClientEpisodeId ,  
            ServicePopulationMI ,  
            ServicePopulationDD ,  
            ServicePopulationSUD ,  
            ServicePopulationMIManualOverride ,  
            ServicePopulationDDManualOverride ,  
            ServicePopulationSUDManualOverride ,  
            ServicePopulationMIManualDetermination ,  
            ServicePopulationDDManualDetermination ,  
            ServicePopulationSUDManualDetermination ,  
            DiagnosticCategory ,  
            SystemDateOfInitialRequest ,  
            SystemDateOfInitialAssessment ,  
            SystemDaysRequestToAssessment ,  
            ManualDateOfInitialRequest ,  
            ManualDateOfInitialAssessment ,  
            ManualDaysRequestToAssessment ,  
            InitialStatus ,  
            InitialReason ,  
            SystemDateOfTreatment ,  
            SystemDaysAssessmentToTreatment ,  
            SystemTreatmentServiceId ,  
            SystemInitialAssessmentServiceId ,  
            ManualDateOfTreatment ,  
            ManualDaysAssessmentToTreatment ,  
            OnGoingStatus ,  
            OnGoingReason ,  
            CreatedBy ,  
            CreatedDate ,  
            ModifiedBy ,  
            ModifiedDate ,  
            RecordDeleted ,  
            DeletedDate ,  
            DeletedBy  
    FROM    CustomTimeliness  
    WHERE   ( ClientEpisodeId IN (  
              SELECT   ClientEpisodeId  
              FROM      ClientEpisodes  
              WHERE     ( ClientId = @ClientId )  
                        AND ( ISNULL(RecordDeleted, 'N') = 'N' ) ) )  
            AND ( ISNULL(RecordDeleted, 'N') = 'N' )                                            

	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetClientEpisode') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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

