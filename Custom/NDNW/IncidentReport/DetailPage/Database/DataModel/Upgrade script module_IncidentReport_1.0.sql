----- STEP 1 ----------

------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins


--Part2 Ends

-----End of Step 2 -------

------ STEP 3 ------------

------ END OF STEP 3 -----

------ STEP 4 ---------- 
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomIncidentReports')
BEGIN
/* 
 TABLE: CustomIncidentReports 
 */ 
 CREATE TABLE CustomIncidentReports( 
		IncidentReportId									int identity(1,1)	 NOT NULL,
		CreatedBy											type_CurrentUser     NOT NULL,
		CreatedDate											type_CurrentDatetime NOT NULL,
		ModifiedBy											type_CurrentUser     NOT NULL,
		ModifiedDate										type_CurrentDatetime NOT NULL,
		RecordDeleted										type_YOrN			 NULL
															CHECK (RecordDeleted in ('Y','N')),
		DeletedBy											type_UserId         NULL,
		DeletedDate											datetime			NULL,
		ClientId											int					NULL,
		IncidentReportDetailId								int					NULL,
		IncidentReportFollowUpOfIndividualStatusId			int					NULL,
		IncidentReportSupervisorFollowUpId					int					NULL,
		IncidentReportAdministratorReviewId					int					NULL,
		IncidentReportFallDetailId							int					NULL,
		IncidentReportFallFollowUpOfIndividualStatusId		int					NULL,
		IncidentReportFallSupervisorFollowUpId				int					NULL,
		IncidentReportFallAdministratorReviewId				int					NULL,
		IncidentSeizureDetailId								int					NULL,
		IncidentReportSeizureFollowUpOfIndividualStatusId	int					NULL,
		IncidentReportSeizureSupervisorFollowUpId			int					NULL,
		IncidentReportSeizureAdministratorReviewId			int					NULL,
		DetailVersionStatus									type_GlobalCode		NULL,
		FollowUpOfIndividualStatusVersionStatus				type_GlobalCode		NULL,
		SupervisorFollowUpVersionStatus						type_GlobalCode		NULL,
		AdministratorReviewVersionStatus					type_GlobalCode		NULL,
		FallDetailVersionStatus								type_GlobalCode		NULL,
		FallFollowUpOfIndividualStatusVersionStatus			type_GlobalCode		NULL,
		FallSupervisorFollowUpVersionStatus					type_GlobalCode		NULL,
		FallAdministratorReviewVersionStatus				type_GlobalCode		NULL,
		SeizureDetailVersionStatus							type_GlobalCode		NULL,
		SeizureFollowUpOfIndividualStatusVersionStatus		type_GlobalCode		NULL,
		SeizureSupervisorFollowUpVersionStatus				type_GlobalCode		NULL,
		SeizureAdministratorReviewVersionStatus				type_GlobalCode 	NULL,
		CONSTRAINT CustomIncidentReports_PK PRIMARY KEY CLUSTERED (IncidentReportId) 
 )
 
  IF OBJECT_ID('CustomIncidentReports') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomIncidentReports >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomIncidentReports >>>', 16, 1)
/* 
 * TABLE: CustomIncidentReports 
 */   
   ALTER TABLE CustomIncidentReports ADD CONSTRAINT Clients_CustomIncidentReports_FK 
    FOREIGN KEY (ClientId)
    REFERENCES Clients(ClientId)
    
 PRINT 'STEP 4(A) COMPLETED'
 END


IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomIncidentReportGenerals')
BEGIN
/* 
 * TABLE: CustomIncidentReportGenerals 
 */
 CREATE TABLE CustomIncidentReportGenerals( 
		IncidentReportGeneralId						int identity(1,1)	 NOT NULL,
		CreatedBy									type_CurrentUser     NOT NULL,
		CreatedDate									type_CurrentDatetime NOT NULL,
		ModifiedBy									type_CurrentUser     NOT NULL,
		ModifiedDate								type_CurrentDatetime NOT NULL,
		RecordDeleted								type_YOrN			 NULL
													CHECK (RecordDeleted in ('Y','N')),
		DeletedBy									type_UserId          NULL,
		DeletedDate									datetime			 NULL,
		IncidentReportId							int					 NULL,
		GeneralProgram								int					 NULL,
		GeneralDateOfIncident						datetime			 NULL,
		GeneralTimeOfIncident						datetime			 NULL,
		GeneralResidence							varchar(MAX)		 NULL,
		GeneralDateStaffNotified					datetime			 NULL,
		GeneralSame									type_YOrN			 NULL
													CHECK (GeneralSame in ('Y','N')),
		GeneralTimeStaffNotified					datetime			 NULL,
		GeneralLocationOfIncident					type_GlobalCode		 NULL,
		GeneralLocationDetails						type_GlobalCode		 NULL,
		GeneralLocationDetailsText					varchar(MAX)		 NULL,
		GeneralIncidentCategory						type_GlobalCode		 NULL,
		GeneralSecondaryCategory					type_GlobalCode		 NULL,
		CONSTRAINT CustomIncidentReportGenerals_PK PRIMARY KEY CLUSTERED (IncidentReportGeneralId) 
 )
 
  IF OBJECT_ID('CustomIncidentReportGenerals') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomIncidentReportGenerals >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomIncidentReportGenerals >>>', 16, 1)
/* 
 * TABLE: CustomIncidentReportGenerals 
 */   
 
 ALTER TABLE CustomIncidentReportGenerals ADD CONSTRAINT CustomIncidentReports_CustomIncidentReportGenerals_FK 
    FOREIGN KEY (IncidentReportId)
    REFERENCES CustomIncidentReports(IncidentReportId)
    
  ALTER TABLE CustomIncidentReportGenerals ADD CONSTRAINT Programs_CustomIncidentReportGenerals_FK 
    FOREIGN KEY (GeneralProgram)
    REFERENCES Programs(ProgramId)
 
 
 
 PRINT 'STEP 4(B) COMPLETED'
 END
 
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomIncidentReportDetails')
BEGIN
/* 
 * TABLE: CustomIncidentReportDetails 
 */
 CREATE TABLE CustomIncidentReportDetails( 
		IncidentReportDetailId						int identity(1,1)	 NOT NULL,
		CreatedBy									type_CurrentUser     NOT NULL,
		CreatedDate									type_CurrentDatetime NOT NULL,
		ModifiedBy									type_CurrentUser     NOT NULL,
		ModifiedDate								type_CurrentDatetime NOT NULL,
		RecordDeleted								type_YOrN			 NULL
													CHECK (RecordDeleted in ('Y','N')),
		DeletedBy									type_UserId          NULL,
		DeletedDate									datetime			 NULL,
		IncidentReportId							int					 NULL,
		DetailsStaffNotifiedForInjury				int					 NULL,
		SignedBy									int					 NULL,
		DetailsDescriptionOfincident				type_Comment2		 NULL,
		DetailsActionsTakenByStaff					type_Comment2		 NULL,
		DetailsWitnesses							type_Comment2		 NULL,
		DetailsDateStaffNotified					datetime			 NULL,
		DetailsTimestaffNotified					datetime			 NULL,
		DetailsNoMedicalStaffNotified				type_YOrN			 NULL
													CHECK (DetailsNoMedicalStaffNotified in ('Y','N')),
		SignedDate									datetime			 NULL,
		PhysicalSignature							image				 NULL,
		CurrentStatus								type_GlobalCode		 NULL,
		InProgressStatus							type_GlobalCode		 NULL,
		CONSTRAINT CustomIncidentReportDetails_PK PRIMARY KEY CLUSTERED (IncidentReportDetailId) 
 )
 
  IF OBJECT_ID('CustomIncidentReportDetails') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomIncidentReportDetails >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomIncidentReportDetails >>>', 16, 1)
/* 
 * TABLE: CustomIncidentReportDetails 
 */   
 
 ALTER TABLE CustomIncidentReportDetails ADD CONSTRAINT CustomIncidentReports_CustomIncidentReportDetails_FK 
    FOREIGN KEY (IncidentReportId)
    REFERENCES  CustomIncidentReports(IncidentReportId)
    
 ALTER TABLE CustomIncidentReportDetails ADD CONSTRAINT Staff_CustomIncidentReportDetails_FK 
    FOREIGN KEY (DetailsStaffNotifiedForInjury)
    REFERENCES Staff(StaffId)
    
 ALTER TABLE CustomIncidentReportDetails ADD CONSTRAINT Staff_CustomIncidentReportDetails_FK2 
    FOREIGN KEY (SignedBy)
    REFERENCES Staff(StaffId)
    
 ALTER TABLE CustomIncidentReports ADD CONSTRAINT CustomIncidentReportDetails_CustomIncidentReports_FK
    FOREIGN KEY (IncidentReportDetailId)
    REFERENCES CustomIncidentReportDetails(IncidentReportDetailId)
 
 PRINT 'STEP 4(C) COMPLETED'
 END
 
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomIncidentReportFollowUpOfIndividualStatuses')
BEGIN
/* 
 * TABLE:   CustomIncidentReportFollowUpOfIndividualStatuses 
 */
 CREATE TABLE CustomIncidentReportFollowUpOfIndividualStatuses( 
		IncidentReportFollowUpOfIndividualStatusId				int	identity(1,1)	 NOT NULL,
		CreatedBy												type_CurrentUser     NOT NULL,
		CreatedDate												type_CurrentDatetime NOT NULL,
		ModifiedBy												type_CurrentUser     NOT NULL,
		ModifiedDate											type_CurrentDatetime NOT NULL,
		RecordDeleted											type_YOrN			 NULL
																CHECK (RecordDeleted in ('Y','N')),
		DeletedBy												type_UserId          NULL,
		DeletedDate												datetime			 NULL,
		IncidentReportId										int					 NULL,
		FollowUpIndividualStatusNurseStaffEvaluating			int					 NULL,
		FollowUpIndividualStatusStaffCompletedNotification		int					 NULL,
		SignedBy												int					 NULL,
		FollowUpIndividualStatusCredentialTitle					varchar(MAX)		 NULL,
		FollowUpIndividualStatusDetailsOfInjury					type_Comment2		 NULL,
		FollowUpIndividualStatusComments						type_Comment2		 NULL,
		FollowUpIndividualStatusFamilyGuardianCustodianNotified	type_YOrN			 NULL
																CHECK (FollowUpIndividualStatusFamilyGuardianCustodianNotified in ('Y','N')),
		FollowUpIndividualStatusDateOfNotification				datetime			 NULL,
		FollowUpIndividualStatusTimeOfNotification				datetime			 NULL,
		FollowUpIndividualStatusNameOfFamilyGuardianCustodian	varchar(MAX)		 NULL,
		FollowUpIndividualStatusDetailsOfNotification 			type_Comment2		 NULL,
		SignedDate												datetime			 NULL,
		PhysicalSignature										image				 NULL,
		CurrentStatus											type_GlobalCode		 NULL,
		InProgressStatus										type_GlobalCode		 NULL,
		CONSTRAINT CustomIncidentReportFollowUpOfIndividualStatuses_PK PRIMARY KEY CLUSTERED (IncidentReportFollowUpOfIndividualStatusId) 
 )
 
  IF OBJECT_ID('CustomIncidentReportFollowUpOfIndividualStatuses') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomIncidentReportFollowUpOfIndividualStatuses >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomIncidentReportFollowUpOfIndividualStatuses >>>', 16, 1)
/* 
 * TABLE: CustomIncidentReportFollowUpOfIndividualStatuses 
 */   
 
 ALTER TABLE CustomIncidentReportFollowUpOfIndividualStatuses ADD CONSTRAINT CustomIncidentReports_CustomIncidentReportFollowUpOfIndividualStatuses_FK 
    FOREIGN KEY (IncidentReportId)
    REFERENCES CustomIncidentReports(IncidentReportId)
    
 ALTER TABLE CustomIncidentReportFollowUpOfIndividualStatuses ADD CONSTRAINT Staff_CustomIncidentReportFollowUpOfIndividualStatuses_FK 
    FOREIGN KEY (FollowUpIndividualStatusNurseStaffEvaluating)
    REFERENCES Staff(StaffId)
    
 ALTER TABLE CustomIncidentReportFollowUpOfIndividualStatuses ADD CONSTRAINT Staff_CustomIncidentReportFollowUpOfIndividualStatuses_FK2
    FOREIGN KEY (FollowUpIndividualStatusStaffCompletedNotification)
    REFERENCES Staff(StaffId)
    
 ALTER TABLE CustomIncidentReportFollowUpOfIndividualStatuses ADD CONSTRAINT Staff_CustomIncidentReportFollowUpOfIndividualStatuses_FK3
    FOREIGN KEY (SignedBy)
    REFERENCES Staff(StaffId)
    
    ALTER TABLE CustomIncidentReports ADD CONSTRAINT CustomIncidentReportFollowUpOfIndividualStatuses_CustomIncidentReports_FK 
    FOREIGN KEY (IncidentReportFollowUpOfIndividualStatusId)
    REFERENCES CustomIncidentReportFollowUpOfIndividualStatuses(IncidentReportFollowUpOfIndividualStatusId)
 
 PRINT 'STEP 4(D) COMPLETED'
 END
 
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomIncidentReportSupervisorFollowUps')
BEGIN
/* 
 * TABLE:  CustomIncidentReportSupervisorFollowUps 
 */
 CREATE TABLE CustomIncidentReportSupervisorFollowUps( 
		IncidentReportSupervisorFollowUpId						int identity(1,1)	 NOT NULL,
		CreatedBy												type_CurrentUser     NOT NULL,
		CreatedDate												type_CurrentDatetime NOT NULL,
		ModifiedBy												type_CurrentUser     NOT NULL,
		ModifiedDate											type_CurrentDatetime NOT NULL,
		RecordDeleted											type_YOrN			 NULL
																CHECK (RecordDeleted in ('Y','N')),
		DeletedBy												type_UserId          NULL,
		DeletedDate												datetime			 NULL,
		IncidentReportId										int					 NULL,
		SupervisorFollowUpSupervisorName						int					 NULL,
		SupervisorFollowUpAdministrator							int					 NULL,
		SupervisorFollowUpStaffCompletedNotification			int					 NULL,
		SignedBy												int					 NULL,
		SupervisorFollowUpFollowUp								type_Comment2		 NULL,
		SupervisorFollowUpAdministratorNotified					type_YOrN			 NULL
																CHECK (SupervisorFollowUpAdministratorNotified in ('Y','N')),
		SupervisorFollowUpAdminDateOfNotification				datetime			 NULL,
		SupervisorFollowUpAdminTimeOfNotification				datetime			 NULL,
		SupervisorFollowUpFamilyGuardianCustodianNotified		type_YOrN			 NULL
																CHECK (SupervisorFollowUpFamilyGuardianCustodianNotified in ('Y','N')),
		SupervisorFollowUpFGCDateOfNotification					datetime			 NULL,
		SupervisorFollowUpFGCTimeOfNotification					datetime			 NULL,
		SupervisorFollowUpNameOfFamilyGuardianCustodian			varchar(MAX)		 NULL,
		SupervisorFollowUpDetailsOfNotification					type_Comment2		 NULL,
		SupervisorFollowUpAggressionPhysical 					type_YOrN			 NULL
																CHECK (SupervisorFollowUpAggressionPhysical in ('Y','N')),
		SupervisorFollowUpAggressionVerbal						type_YOrN			 NULL
																CHECK (SupervisorFollowUpAggressionVerbal in ('Y','N')),
		SupervisorFollowUpBehavioralRestraint					type_YOrN			 NULL
																CHECK (SupervisorFollowUpBehavioralRestraint in ('Y','N')),
		SupervisorFollowUpElopementOffCampus 					type_YOrN			 NULL
																CHECK (SupervisorFollowUpElopementOffCampus in ('Y','N')),
		SupervisorFollowUpElopementOnCampus 					type_YOrN			 NULL
																CHECK (SupervisorFollowUpElopementOnCampus in ('Y','N')),
		SupervisorFollowUpContraband 							type_YOrN			 NULL
																CHECK (SupervisorFollowUpContraband in ('Y','N')),
		SupervisorFollowUpPropertyDamage						type_YOrN			 NULL
																CHECK (SupervisorFollowUpPropertyDamage in ('Y','N')),
		SupervisorFollowUpPropertyDestruction 					type_YOrN			 NULL
																CHECK (SupervisorFollowUpPropertyDestruction in ('Y','N')),
		SupervisorFollowUpSearchSeizure  						type_YOrN			 NULL
																CHECK (SupervisorFollowUpSearchSeizure in ('Y','N')),
		SupervisorFollowUpSelfInjury  							type_YOrN			 NULL
																CHECK (SupervisorFollowUpSelfInjury in ('Y','N')),
		SupervisorFollowUpSuicideAttempt 						type_YOrN			 NULL
																CHECK (SupervisorFollowUpSuicideAttempt in ('Y','N')),
		SupervisorFollowUpSuicideThreatGesture 					type_YOrN			 NULL
																CHECK (SupervisorFollowUpSuicideThreatGesture in ('Y','N')),
		SupervisorFollowUpOutbreakOfDisease 					type_YOrN			 NULL
																CHECK (SupervisorFollowUpOutbreakOfDisease in ('Y','N')),
		SupervisorFollowUpIllness 								type_YOrN			 NULL
																CHECK (SupervisorFollowUpIllness in ('Y','N')),
		SupervisorFollowUpHospitalizationMedical 				type_YOrN			 NULL
																CHECK (SupervisorFollowUpHospitalizationMedical in ('Y','N')),
		SupervisorFollowUpHospitalizationPsychiatric			type_YOrN			 NULL
																CHECK (SupervisorFollowUpHospitalizationPsychiatric in ('Y','N')),
		SupervisorFollowUpTripToER 								type_YOrN			 NULL
																CHECK (SupervisorFollowUpTripToER in ('Y','N')),
		SupervisorFollowUpAllegedAbuse							type_YOrN			 NULL
																CHECK (SupervisorFollowUpAllegedAbuse in ('Y','N')),
		SupervisorFollowUpMisuseOfFundsProperty 				type_YOrN			 NULL
																CHECK (SupervisorFollowUpMisuseOfFundsProperty in ('Y','N')),
		SupervisorFollowUpViolationOfRights 					type_YOrN			 NULL
																CHECK (SupervisorFollowUpViolationOfRights in ('Y','N')),
		SupervisorFollowUpIndividualToIndividualInjury			type_YOrN			 NULL
																CHECK (SupervisorFollowUpIndividualToIndividualInjury in ('Y','N')),
		SupervisorFollowUpInjury 								type_YOrN			 NULL
																CHECK (SupervisorFollowUpInjury in ('Y','N')),
		SupervisorFollowUpInjuryFromRestraint 					type_YOrN			 NULL
																CHECK (SupervisorFollowUpInjuryFromRestraint in ('Y','N')),
		SupervisorFollowUpFireDepartmentInvolvement 			type_YOrN			 NULL
																CHECK (SupervisorFollowUpFireDepartmentInvolvement in ('Y','N')),
		SupervisorFollowUpPoliceInvolvement 					type_YOrN			 NULL
																CHECK (SupervisorFollowUpPoliceInvolvement in ('Y','N')),
		SupervisorFollowUpChokingSwallowingDifficulty			type_YOrN			 NULL
																CHECK (SupervisorFollowUpChokingSwallowingDifficulty in ('Y','N')),
		SupervisorFollowUpDeath 								type_YOrN			 NULL
																CHECK (SupervisorFollowUpDeath in ('Y','N')),
		SupervisorFollowUpDrugUsePossession 					type_YOrN			 NULL
																CHECK (SupervisorFollowUpDrugUsePossession in ('Y','N')),
		SupervisorFollowUpOutOfProgramArea 						type_YOrN			 NULL
																CHECK (SupervisorFollowUpOutOfProgramArea in ('Y','N')),
		SupervisorFollowUpSexualIncident 						type_YOrN			 NULL
																CHECK (SupervisorFollowUpSexualIncident in ('Y','N')),
		SupervisorFollowUpOther  								type_YOrN			 NULL
																CHECK (SupervisorFollowUpOther in ('Y','N')),
		SupervisorFollowUpOtherComments							varchar(MAX)		 NULL,
		SignedDate												datetime			 NULL,
		PhysicalSignature										image				 NULL,
		CurrentStatus											type_GlobalCode		 NULL,
		InProgressStatus										type_GlobalCode		 NULL,
		CONSTRAINT CustomIncidentReportSupervisorFollowUps_PK PRIMARY KEY CLUSTERED (IncidentReportSupervisorFollowUpId) 
 )
 
  IF OBJECT_ID('CustomIncidentReportSupervisorFollowUps') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomIncidentReportSupervisorFollowUps >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomIncidentReportSupervisorFollowUps >>>', 16, 1)
/* 
 * TABLE: CustomIncidentReportSupervisorFollowUps 
 */   
 
 ALTER TABLE CustomIncidentReportSupervisorFollowUps ADD CONSTRAINT CustomIncidentReports_CustomIncidentReportSupervisorFollowUps_FK 
    FOREIGN KEY (IncidentReportId)
    REFERENCES CustomIncidentReports(IncidentReportId)
    
 ALTER TABLE CustomIncidentReportSupervisorFollowUps ADD CONSTRAINT Staff_CustomIncidentReportSupervisorFollowUps_FK 
    FOREIGN KEY (SupervisorFollowUpSupervisorName)
    REFERENCES Staff(StaffId)
    
 ALTER TABLE CustomIncidentReportSupervisorFollowUps ADD CONSTRAINT Staff_CustomIncidentReportSupervisorFollowUps_FK2 
    FOREIGN KEY (SupervisorFollowUpAdministrator)
    REFERENCES Staff(StaffId)
    
  ALTER TABLE CustomIncidentReportSupervisorFollowUps ADD CONSTRAINT Staff_CustomIncidentReportSupervisorFollowUps_FK3 
    FOREIGN KEY (SupervisorFollowUpStaffCompletedNotification)
    REFERENCES Staff(StaffId)
    
   ALTER TABLE CustomIncidentReportSupervisorFollowUps ADD CONSTRAINT Staff_CustomIncidentReportSupervisorFollowUps_FK4
    FOREIGN KEY (SignedBy)
    REFERENCES Staff(StaffId)
    
   ALTER TABLE CustomIncidentReports ADD CONSTRAINT CustomIncidentReportSupervisorFollowUps_CustomIncidentReports_FK
    FOREIGN KEY (IncidentReportSupervisorFollowUpId)
    REFERENCES CustomIncidentReportSupervisorFollowUps(IncidentReportSupervisorFollowUpId)
 
 PRINT 'STEP 4(E) COMPLETED'
 END
 
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomIncidentReportAdministratorReviews')
BEGIN
/* 
 * TABLE: CustomIncidentReportAdministratorReviews 
 */
 CREATE TABLE CustomIncidentReportAdministratorReviews( 
		IncidentReportAdministratorReviewId			int identity(1,1)	 NOT NULL,
		CreatedBy									type_CurrentUser     NOT NULL,
		CreatedDate									type_CurrentDatetime NOT NULL,
		ModifiedBy									type_CurrentUser     NOT NULL,
		ModifiedDate								type_CurrentDatetime NOT NULL,
		RecordDeleted								type_YOrN			 NULL
													CHECK (RecordDeleted in ('Y','N')),
		DeletedBy									type_UserId          NULL,
		DeletedDate									datetime			 NULL,
		IncidentReportId							int					 NULL,
		AdministratorReviewAdministrator			int					 NULL,
		SignedBy									int					 NULL,
		AdministratorReviewAdministrativeReview		type_Comment2		 NULL,
		AdministratorReviewFiledReportableIncident	char(1)				 NULL
													CHECK (AdministratorReviewFiledReportableIncident in ('Y','N','O')),	
		AdministratorReviewComments					type_Comment2		 NULL,
		SignedDate									datetime			 NULL,
		PhysicalSignature							image				 NULL,
		CurrentStatus								type_GlobalCode		 NULL,
		InProgressStatus							type_GlobalCode		 NULL,
		CONSTRAINT CustomIncidentReportAdministratorReviews_PK PRIMARY KEY CLUSTERED (IncidentReportAdministratorReviewId) 
 )
 
  IF OBJECT_ID('CustomIncidentReportAdministratorReviews') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomIncidentReportAdministratorReviews >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomIncidentReportAdministratorReviews >>>', 16, 1)
/* 
 * TABLE: CustomIncidentReportAdministratorReviews 
 */   
 
 ALTER TABLE CustomIncidentReportAdministratorReviews ADD CONSTRAINT CustomIncidentReports_CustomIncidentReportAdministratorReviews_FK 
    FOREIGN KEY (IncidentReportId)
    REFERENCES CustomIncidentReports(IncidentReportId)
    
 ALTER TABLE CustomIncidentReportAdministratorReviews ADD CONSTRAINT Staff_CustomIncidentReportAdministratorReviews_FK 
    FOREIGN KEY (AdministratorReviewAdministrator)
    REFERENCES Staff(StaffId)
    
 ALTER TABLE CustomIncidentReportAdministratorReviews ADD CONSTRAINT Staff_CustomIncidentReportAdministratorReviews_FK2 
    FOREIGN KEY (SignedBy)
    REFERENCES Staff(StaffId)
    
 ALTER TABLE CustomIncidentReports ADD CONSTRAINT CustomIncidentReportAdministratorReviews_CustomIncidentReports_FK
    FOREIGN KEY (IncidentReportAdministratorReviewId)
    REFERENCES CustomIncidentReportAdministratorReviews(IncidentReportAdministratorReviewId)
    
 PRINT 'STEP 4(F) COMPLETED'
 END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomIncidentReportFallDetails')
BEGIN
/* 
 * TABLE:  CustomIncidentReportFallDetails 
 */
 CREATE TABLE CustomIncidentReportFallDetails( 
		IncidentReportFallDetailId   				int	identity(1,1)	 NOT NULL,
		CreatedBy									type_CurrentUser     NOT NULL,
		CreatedDate									type_CurrentDatetime NOT NULL,
		ModifiedBy									type_CurrentUser     NOT NULL,
		ModifiedDate								type_CurrentDatetime NOT NULL,
		RecordDeleted								type_YOrN			 NULL
													CHECK (RecordDeleted in ('Y','N')),
		DeletedBy									type_UserId          NULL,
		DeletedDate									datetime			 NULL,
		IncidentReportId							int					 NULL,
		SignedBy									int					 NULL,	
		FallDetailsDescribeIncident					type_GlobalCode		 NULL,
		FallDetailsCauseOfIncident					type_GlobalCode		 NULL,
		FallDetailsCauseOfIncidentText				varchar(MAX)		 NULL,
		FallDetailsNone								type_YOrN			 NULL
													CHECK (FallDetailsNone in ('Y','N')),
		FallDetailsCane								type_YOrN			 NULL
													CHECK (FallDetailsCane in ('Y','N')),
		FallDetailsSeatLapBelt						type_YOrN			 NULL
													CHECK (FallDetailsSeatLapBelt in ('Y','N')),
		FallDetailsWheelchair						type_YOrN			 NULL
													CHECK (FallDetailsWheelchair in ('Y','N')),
		FallDetailsGaitBelt							type_YOrN			 NULL
													CHECK (FallDetailsGaitBelt in ('Y','N')),
		FallDetailsWheellchairTray					type_YOrN			 NULL
													CHECK (FallDetailsWheellchairTray in ('Y','N')),
		FallDetailsWalker							type_YOrN			 NULL
													CHECK (FallDetailsWalker in ('Y','N')),
		FallDetailsMafosBraces						type_YOrN			 NULL
													CHECK (FallDetailsMafosBraces in ('Y','N')),
		FallDetailsHelmet							type_YOrN			 NULL
													CHECK (FallDetailsHelmet in ('Y','N')),
		FallDetailsChestHarness						type_YOrN			 NULL
													CHECK (FallDetailsChestHarness in ('Y','N')),
		FallDetailsOther							type_YOrN			 NULL
													CHECK (FallDetailsOther in ('Y','N')),
		FallDetailsOtherText						varchar(MAX)		 NULL,
		FallDetailsIncidentOccurredWhile			type_GlobalCode		 NULL,
		FallDetailsFootwearAtTimeOfIncident			type_GlobalCode		 NULL,
		FallDetailsWheelsLocked						type_YesNoUnknown	 NULL
													CHECK (FallDetailsWheelsLocked in ('Y','N','U')),
		FallDetailsWhereBedWheelsUnlocked			type_YOrNOrNA		 NULL
													CHECK (FallDetailsWhereBedWheelsUnlocked in ('Y','N','A')),
		FallDetailsNA								type_YOrN			 NULL
													CHECK (FallDetailsNA in ('Y','N')),
		FallDetailsFullLength						type_YOrN			 NULL
													CHECK (FallDetailsFullLength in ('Y','N')),
		FallDetails2Half							type_YOrN			 NULL
													CHECK (FallDetails2Half in ('Y','N')),
		FallDetails4Half							type_YOrN			 NULL
													CHECK (FallDetails4Half in ('Y','N')),
		FallDetailsBothSidesUp						type_YOrN			 NULL
													CHECK (FallDetailsBothSidesUp in ('Y','N')),
		FallDetailsOneSideUp						type_YOrN			 NULL
													CHECK (FallDetailsOneSideUp in ('Y','N')),
		FallDetailsBumperPads						type_YOrN			 NULL
													CHECK (FallDetailsBumperPads in ('Y','N')),
		FallDetailsFurtherDescription				type_YOrN			 NULL
													CHECK (FallDetailsFurtherDescription in ('Y','N')),
		FallDetailsFurtherDescriptiontext			varchar(MAX)		 NULL,
		FallDetailsWasAnAlarmPresent				type_YOrN			 NULL
													CHECK (FallDetailsWasAnAlarmPresent in ('Y','N')),
		FallDetailsAlarmSoundedDuringIncident		type_YOrN			 NULL
													CHECK (FallDetailsAlarmSoundedDuringIncident in ('Y','N')),
		FallDetailsAlarmDidNotSoundDuringIncident	type_YOrN			 NULL
													CHECK (FallDetailsAlarmDidNotSoundDuringIncident in ('Y','N')),
		FallDetailsBedMat							type_YOrN			 NULL
													CHECK (FallDetailsBedMat in ('Y','N')),
		FallDetailsBeam								type_YOrN			 NULL
													CHECK (FallDetailsBeam in ('Y','N')),
		FallDetailsBabyMonitor						type_YOrN			 NULL
													CHECK (FallDetailsBabyMonitor in ('Y','N')),
		FallDetailsFloorMat							type_YOrN			 NULL
													CHECK (FallDetailsFloorMat in ('Y','N')),
		FallDetailsMagneticClip						type_YOrN			 NULL
													CHECK (FallDetailsMagneticClip in ('Y','N')),
		FallDetailsTypeOfAlarmOtherText				type_YOrN			 NULL
													CHECK (FallDetailsTypeOfAlarmOtherText in ('Y','N')),
		FallDetailsTypeOfAlarmOther					varchar(MAX)		 NULL,
		FallDetailsDescriptionOfincident			type_Comment2		 NULL,
		FallDetailsActionsTakenByStaff				type_Comment2		 NULL,
		FallDetailsWitnesses						type_Comment2		 NULL,
		FallDetailsStaffNotifiedForInjury			int					 NULL,
		FallDetailsDateStaffNotified				datetime			 NULL,
		FallDetailsTimestaffNotified				datetime			 NULL,
		FallDetailsNoMedicalStaffNotified			type_YOrN			 NULL
													CHECK (FallDetailsNoMedicalStaffNotified in ('Y','N')),
		SignedDate									datetime			 NULL,
		PhysicalSignature							image				 NULL,
		CurrentStatus								type_GlobalCode		 NULL,
		InProgressStatus							type_GlobalCode		 NULL,
		CONSTRAINT CustomIncidentReportFallDetails_PK PRIMARY KEY CLUSTERED (IncidentReportFallDetailId) 
 )
 
  IF OBJECT_ID('CustomIncidentReportFallDetails') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomIncidentReportFallDetails >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomIncidentReportFallDetails >>>', 16, 1)
/* 
 * TABLE: CustomIncidentReportFallDetails 
 */   
 
 ALTER TABLE CustomIncidentReportFallDetails ADD CONSTRAINT CustomIncidentReports_CustomIncidentReportFallDetails_FK 
    FOREIGN KEY (IncidentReportId)
    REFERENCES CustomIncidentReports(IncidentReportId)
    
 ALTER TABLE CustomIncidentReportFallDetails ADD CONSTRAINT staff_CustomIncidentReportFallDetails_FK
    FOREIGN KEY (SignedBy)
    REFERENCES staff(staffId)
    
 ALTER TABLE CustomIncidentReports ADD CONSTRAINT CustomIncidentReportFallDetails_CustomIncidentReports_FK
    FOREIGN KEY (IncidentReportFallDetailId)
    REFERENCES CustomIncidentReportFallDetails(IncidentReportFallDetailId)

PRINT 'STEP 4(G) COMPLETED'
 END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomIncidentReportFallFollowUpOfIndividualStatuses')
BEGIN
/* 
 * TABLE:CustomIncidentReportFallFollowUpOfIndividualStatuses 
 */
 CREATE TABLE CustomIncidentReportFallFollowUpOfIndividualStatuses( 
		IncidentReportFallFollowUpOfIndividualStatusId				int identity(1,1)	 NOT NULL,
		CreatedBy													type_CurrentUser     NOT NULL,
		CreatedDate													type_CurrentDatetime NOT NULL,
		ModifiedBy													type_CurrentUser     NOT NULL,
		ModifiedDate												type_CurrentDatetime NOT NULL,
		RecordDeleted												type_YOrN			 NULL
																	CHECK (RecordDeleted in ('Y','N')),
		DeletedBy													type_UserId          NULL,
		DeletedDate													datetime			 NULL,
		IncidentReportId											int					 NULL,
		FallFollowUpIndividualStatusNurseStaffEvaluating			int					 NULL,
		FallFollowUpIndividualStatusStaffCompletedNotification		int					 NULL,
		SignedBy													int					 NULL,
		FallFollowUpIndividualStatusCredentialTitle					varchar(MAX)		 NULL,
		FallFollowUpIndividualStatusDetailsOfInjury					type_Comment2		 NULL,
		FallFollowUpIndividualStatusNoTreatmentNoInjury				type_YOrN			 NULL
																	CHECK (FallFollowUpIndividualStatusNoTreatmentNoInjury in ('Y','N')),
		FallFollowUpIndividualStatusFirstAidOnly					type_YOrN			 NULL
																	CHECK (FallFollowUpIndividualStatusFirstAidOnly in ('Y','N')),
		FallFollowUpIndividualStatusMonitor							type_YOrN			 NULL
																	CHECK (FallFollowUpIndividualStatusMonitor in ('Y','N')),
		FallFollowUpIndividualStatusToPrimaryCareProviderClinicEvaluation	type_YOrN			 NULL
																	CHECK (FallFollowUpIndividualStatusToPrimaryCareProviderClinicEvaluation in ('Y','N')),
		FallFollowUpIndividualStatusToEmergencyRoom					type_YOrN			 NULL
																	CHECK (FallFollowUpIndividualStatusToEmergencyRoom in ('Y','N')),
		FallFollowUpIndividualStatusOther							type_YOrN			 NULL
																	CHECK (FallFollowUpIndividualStatusOther in ('Y','N')),
		FallFollowUpIndividualStatusOtherText						varchar(MAX)		 NULL,
		FallFollowUpIndividualStatusComments						type_Comment2		 NULL,
		FallFollowUpIndividualStatusFamilyGuardianCustodianNotified	type_YOrN			 NULL
																	CHECK (FallFollowUpIndividualStatusFamilyGuardianCustodianNotified in ('Y','N')),
		FallFollowUpIndividualStatusDateOfNotification				datetime			 NULL,
		FallFollowUpIndividualStatusTimeOfNotification				datetime			 NULL,
		FallFollowUpIndividualStatusNameOfFamilyGuardianCustodian	varchar(MAX)		 NULL,
		FallFollowUpIndividualStatusDetailsOfNotification 			type_Comment2		 NULL,
		SignedDate													datetime			 NULL,
		PhysicalSignature											image				 NULL,
		CurrentStatus												type_GlobalCode		 NULL,
		InProgressStatus											type_GlobalCode		 NULL,
		CONSTRAINT CustomIncidentReportFallFollowUpOfIndividualStatuses_PK PRIMARY KEY CLUSTERED (IncidentReportFallFollowUpOfIndividualStatusId) 
 )
 
  IF OBJECT_ID('CustomIncidentReportFallFollowUpOfIndividualStatuses') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomIncidentReportFallFollowUpOfIndividualStatuses >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomIncidentReportFallFollowUpOfIndividualStatuses >>>', 16, 1)
/* 
 * TABLE: CustomIncidentReportFallFollowUpOfIndividualStatuses 
 */   
 
 ALTER TABLE CustomIncidentReportFallFollowUpOfIndividualStatuses ADD CONSTRAINT CustomIncidentReports_CustomIncidentReportFallFollowUpOfIndividualStatuses_FK 
    FOREIGN KEY (IncidentReportId)
    REFERENCES CustomIncidentReports(IncidentReportId)
    
 ALTER TABLE CustomIncidentReportFallFollowUpOfIndividualStatuses ADD CONSTRAINT Staff_CustomIncidentReportFallFollowUpOfIndividualStatuses_FK 
    FOREIGN KEY (FallFollowUpIndividualStatusNurseStaffEvaluating)
    REFERENCES Staff(StaffId)
    
 ALTER TABLE CustomIncidentReportFallFollowUpOfIndividualStatuses ADD CONSTRAINT Staff_CustomIncidentReportFallFollowUpOfIndividualStatuses_FK2 
    FOREIGN KEY (FallFollowUpIndividualStatusStaffCompletedNotification)
    REFERENCES Staff(StaffId)
    
 ALTER TABLE CustomIncidentReportFallFollowUpOfIndividualStatuses ADD CONSTRAINT Staff_CustomIncidentReportFallFollowUpOfIndividualStatuses_FK3 
    FOREIGN KEY (SignedBy)
    REFERENCES Staff(StaffId)
    
 ALTER TABLE CustomIncidentReports ADD CONSTRAINT CustomIncidentReportFallFollowUpOfIndividualStatuses_CustomIncidentReports_FK
    FOREIGN KEY (IncidentReportFallFollowUpOfIndividualStatusId)
    REFERENCES CustomIncidentReportFallFollowUpOfIndividualStatuses(IncidentReportFallFollowUpOfIndividualStatusId)


PRINT 'STEP 4(H) COMPLETED'
 END
 
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomIncidentReportFallSupervisorFollowUps')
BEGIN
/* 
 * TABLE:  CustomIncidentReportFallSupervisorFollowUps 
 */
 CREATE TABLE CustomIncidentReportFallSupervisorFollowUps( 
		IncidentReportFallSupervisorFollowUpId						int identity(1,1)	 NOT NULL,
		CreatedBy													type_CurrentUser     NOT NULL,
		CreatedDate													type_CurrentDatetime NOT NULL,
		ModifiedBy													type_CurrentUser     NOT NULL,
		ModifiedDate												type_CurrentDatetime NOT NULL,
		RecordDeleted												type_YOrN			 NULL
																	CHECK (RecordDeleted in ('Y','N')),
		DeletedBy													type_UserId          NULL,
		DeletedDate													datetime			 NULL,
		IncidentReportId											int					 NULL,
		FallSupervisorFollowUpSupervisorName						int					 NULL,
		FallSupervisorFollowUpAdministrator							int					 NULL,
		FallSupervisorFollowUpStaffCompletedNotification			int					 NULL,
		SignedBy													int					 NULL,
		FallSupervisorFollowUpFollowUp								type_Comment2		 NULL,
		FallSupervisorFollowUpAdministratorNotified					type_YOrN			 NULL
																	CHECK (FallSupervisorFollowUpAdministratorNotified in ('Y','N')),
		FallSupervisorFollowUpAdminDateOfNotification				datetime			 NULL,
		FallSupervisorFollowUpAdminTimeOfNotification				datetime			 NULL,
		FallSupervisorFollowUpFamilyGuardianCustodianNotified		type_YOrN			 NULL
																	CHECK (FallSupervisorFollowUpFamilyGuardianCustodianNotified in ('Y','N')),
		FallSupervisorFollowUpFGCDateOfNotification					datetime			 NULL,
		FallSupervisorFollowUpFGCTimeOfNotification					datetime			 NULL,
		FallSupervisorFollowUpNameOfFamilyGuardianCustodian			varchar(MAX)		 NULL,
		FallSupervisorFollowUpDetailsOfNotification					type_Comment2		 NULL,
		SignedDate													datetime			 NULL,
		PhysicalSignature											image				 NULL,
		CurrentStatus												type_GlobalCode		 NULL,
		InProgressStatus											type_GlobalCode		 NULL,
		CONSTRAINT CustomIncidentReportFallSupervisorFollowUps_PK PRIMARY KEY CLUSTERED (IncidentReportFallSupervisorFollowUpId) 
 )
 
  IF OBJECT_ID('CustomIncidentReportFallSupervisorFollowUps') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomIncidentReportFallSupervisorFollowUps >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomIncidentReportFallSupervisorFollowUps >>>', 16, 1)
/* 
 * TABLE: CustomIncidentReportFallSupervisorFollowUps 
 */   
 
 ALTER TABLE CustomIncidentReportFallSupervisorFollowUps ADD CONSTRAINT CustomIncidentReports_CustomIncidentReportFallSupervisorFollowUps_FK 
    FOREIGN KEY (IncidentReportId)
    REFERENCES CustomIncidentReports(IncidentReportId)
    
 ALTER TABLE CustomIncidentReportFallSupervisorFollowUps ADD CONSTRAINT Staff_CustomIncidentReportFallSupervisorFollowUps_FK 
    FOREIGN KEY (FallSupervisorFollowUpSupervisorName)
    REFERENCES Staff(StaffId)
    
  ALTER TABLE CustomIncidentReportFallSupervisorFollowUps ADD CONSTRAINT Staff_CustomIncidentReportFallSupervisorFollowUps_FK2
    FOREIGN KEY (FallSupervisorFollowUpAdministrator)
    REFERENCES Staff(StaffId)

 ALTER TABLE CustomIncidentReportFallSupervisorFollowUps ADD CONSTRAINT Staff_CustomIncidentReportFallSupervisorFollowUps_FK3
    FOREIGN KEY (FallSupervisorFollowUpStaffCompletedNotification)
    REFERENCES Staff(StaffId)
 
 ALTER TABLE CustomIncidentReportFallSupervisorFollowUps ADD CONSTRAINT Staff_CustomIncidentReportFallSupervisorFollowUps_FK4
    FOREIGN KEY (SignedBy)
    REFERENCES Staff(StaffId)
    
 ALTER TABLE CustomIncidentReports ADD CONSTRAINT CustomIncidentReportFallSupervisorFollowUps_CustomIncidentReports_FK
    FOREIGN KEY (IncidentReportFallSupervisorFollowUpId)
    REFERENCES CustomIncidentReportFallSupervisorFollowUps(IncidentReportFallSupervisorFollowUpId)

PRINT 'STEP 4(I) COMPLETED'
 END
 
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomIncidentReportFallAdministratorReviews')
BEGIN
/* 
 * TABLE:  CustomIncidentReportFallAdministratorReviews 
 */
 CREATE TABLE CustomIncidentReportFallAdministratorReviews( 
		IncidentReportFallAdministratorReviewId						int identity(1,1)	 NOT NULL,
		CreatedBy													type_CurrentUser     NOT NULL,
		CreatedDate													type_CurrentDatetime NOT NULL,
		ModifiedBy													type_CurrentUser     NOT NULL,
		ModifiedDate												type_CurrentDatetime NOT NULL,
		RecordDeleted												type_YOrN			 NULL
																	CHECK (RecordDeleted in ('Y','N')),
		DeletedBy													type_UserId          NULL,
		DeletedDate													datetime			 NULL,
		IncidentReportId											int					 NULL,			
		FallAdministratorReviewAdministrator						int					 NULL,
		SignedBy													int					 NULL,
		FallAdministratorReviewAdministrativeReview					type_Comment2		 NULL,
		FallAdministratorReviewFiledReportableIncident				char(1)				 NULL,
																	CHECK (FallAdministratorReviewFiledReportableIncident in ('Y','N','O')),
		FallAdministratorReviewComments								type_Comment2		 NULL,
		SignedDate													datetime			 NULL,
		PhysicalSignature											image				 NULL,
		CurrentStatus												type_GlobalCode		 NULL,
		InProgressStatus											type_GlobalCode		 NULL,
		CONSTRAINT CustomIncidentReportFallAdministratorReviews_PK PRIMARY KEY CLUSTERED (IncidentReportFallAdministratorReviewId) 
 )
 
  IF OBJECT_ID('CustomIncidentReportFallAdministratorReviews') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomIncidentReportFallAdministratorReviews >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomIncidentReportFallAdministratorReviews >>>', 16, 1)
/* 
 * TABLE: CustomIncidentReportFallAdministratorReviews 
 */   
 
 ALTER TABLE CustomIncidentReportFallAdministratorReviews ADD CONSTRAINT CustomIncidentReports_CustomIncidentReportFallAdministratorReviews_FK 
    FOREIGN KEY (IncidentReportId)
    REFERENCES CustomIncidentReports(IncidentReportId)
    
 ALTER TABLE CustomIncidentReportFallAdministratorReviews ADD CONSTRAINT Staff_CustomIncidentReportFallAdministratorReviews_FK 
    FOREIGN KEY (FallAdministratorReviewAdministrator)
    REFERENCES Staff(StaffId)
    
  ALTER TABLE CustomIncidentReportFallAdministratorReviews ADD CONSTRAINT Staff_CustomIncidentReportFallAdministratorReviews_FK2
    FOREIGN KEY (SignedBy)
    REFERENCES Staff(StaffId)
    
  ALTER TABLE CustomIncidentReports ADD CONSTRAINT CustomIncidentReportFallAdministratorReviews_CustomIncidentReports_FK
    FOREIGN KEY (IncidentReportFallAdministratorReviewId)
    REFERENCES CustomIncidentReportFallAdministratorReviews(IncidentReportFallAdministratorReviewId)
    
 PRINT 'STEP 4(J) COMPLETED'
 END 
 
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomIncidentReportSeizureDetails')
BEGIN
/* 
 * TABLE:CustomIncidentReportSeizureDetails 
 */
 CREATE TABLE CustomIncidentReportSeizureDetails( 
		IncidentReportSeizureDetailId					int identity (1,1)	 NOT NULL,
		CreatedBy										type_CurrentUser     NOT NULL,
		CreatedDate										type_CurrentDatetime NOT NULL,
		ModifiedBy										type_CurrentUser     NOT NULL,
		ModifiedDate									type_CurrentDatetime NOT NULL,
		RecordDeleted									type_YOrN			 NULL
														CHECK (RecordDeleted in ('Y','N')),
		DeletedBy										type_UserId          NULL,
		DeletedDate										datetime			 NULL,
		IncidentReportId								int					 NULL,
		SeizureDetailsSweating							type_GlobalCode		 NULL,
		SeizureDetailsUrinaryFecalIncontinence			type_GlobalCode		 NULL,
		SeizureDetailsTonicStiffnessOfArms				type_GlobalCode		 NULL,
		SeizureDetailsTonicStiffnessOfLegs				type_GlobalCode		 NULL,
		SeizureDetailsClonicTwitchingOfArms				type_GlobalCode		 NULL,
		SeizureDetailsClonicTwitchingOfLegs				type_GlobalCode		 NULL,
		SeizureDetailsPupilsDilated						type_GlobalCode		 NULL,
		SeizureDetailsAnyAbnormalEyeMovements			type_GlobalCode		 NULL,
		SeizureDetailsPostictalPeriod					type_GlobalCode		 NULL,
		SeizureDetailsVagalNerveStimulator				type_GlobalCode		 NULL,
		SeizureDetailsSwipedMagnet						type_GlobalCode		 NULL,
		SeizureDetailsNumberOfSwipes					int					 NULL,
		SeizureDetailsPulseRate							int					 NULL,
		SeizureDetailsBreathing							type_GlobalCode		 NULL,
		SeizureDetailsColor								type_GlobalCode		 NULL,
		SeizureDetailsTurnClientsHeadSide				type_YOrN			 NULL
														CHECK (SeizureDetailsTurnClientsHeadSide in ('Y','N')),			
		SeizureDetailsClientSuctioned					type_YOrN			 NULL
														CHECK (SeizureDetailsClientSuctioned in ('Y','N')),			 
		SeizureDetailsClothingLoosended					type_YOrN			 NULL
														CHECK (SeizureDetailsClothingLoosended in ('Y','N')),			 
		SeizureDetailsAirwayCleared						type_YOrN			 NULL
														CHECK (SeizureDetailsAirwayCleared in ('Y','N')),			
		SeizureDetailsO2Given							type_YOrN			 NULL
														CHECK (SeizureDetailsO2Given in ('Y','N')),			
		SeizureDetailsLiterMin							varchar(max)		 NULL,
		SeizureDetailsPlacedClientOnTheFloor			type_YOrN			 NULL
														CHECK (SeizureDetailsPlacedClientOnTheFloor in ('Y','N')),			 
		SeizureDetailsEmergencyMedicationsGiven			type_YOrN			 NULL
														CHECK (SeizureDetailsEmergencyMedicationsGiven in ('Y','N')),			
		SeizureDetailsPutClientToBed					type_YOrN			 NULL
														CHECK (SeizureDetailsPutClientToBed in ('Y','N')),			 
		SeizureDetailsNotesComments						type_Comment2		 NULL,
		CONSTRAINT CustomIncidentReportSeizureDetails_PK PRIMARY KEY CLUSTERED (IncidentReportSeizureDetailId) 
 )
 
  IF OBJECT_ID('CustomIncidentReportSeizureDetails') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomIncidentReportSeizureDetails >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomIncidentReportSeizureDetails >>>', 16, 1)
/* 
 * TABLE: CustomIncidentReportSeizureDetails 
 */   
 
 ALTER TABLE CustomIncidentReportSeizureDetails ADD CONSTRAINT CustomIncidentReports_CustomIncidentReportSeizureDetails_FK 
    FOREIGN KEY (IncidentReportId)
    REFERENCES CustomIncidentReports(IncidentReportId)
  
PRINT 'STEP 4(K) COMPLETED'
 END 

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomIncidentReportSeizures')
BEGIN
/* 
 * TABLE:  CustomIncidentReportSeizures 
 */
 CREATE TABLE CustomIncidentReportSeizures( 
		IncidentReportSeizureId					int identity(1,1)	NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime			 NULL,
		IncidentReportSeizureDetailId			int					 NULL,
		TimeOfSeizure							datetime			 NULL,
		DurationOfSeizureMin					int					 NULL,
		DurationOfSeizureSec					int					 NULL,
		CONSTRAINT CustomIncidentReportSeizures_PK PRIMARY KEY CLUSTERED (IncidentReportSeizureId) 
 )
 
  IF OBJECT_ID('CustomIncidentReportSeizures') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomIncidentReportSeizures >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomIncidentReportSeizures >>>', 16, 1)
/* 
 * TABLE: CustomIncidentReportSeizures 
 */   
 
 ALTER TABLE CustomIncidentReportSeizures ADD CONSTRAINT CustomIncidentReportSeizureDetails_CustomIncidentReportSeizures_FK 
    FOREIGN KEY (IncidentReportSeizureDetailId)
    REFERENCES CustomIncidentReportSeizureDetails(IncidentReportSeizureDetailId)
    
PRINT 'STEP 4(L) COMPLETED'
 END 

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomIncidentSeizureDetails')
BEGIN
/* 
 * TABLE: CustomIncidentSeizureDetails 
 */
 CREATE TABLE CustomIncidentSeizureDetails( 
		IncidentSeizureDetailId							int identity(1,1)	 NOT NULL,
		CreatedBy										type_CurrentUser     NOT NULL,
		CreatedDate										type_CurrentDatetime NOT NULL,
		ModifiedBy										type_CurrentUser     NOT NULL,
		ModifiedDate									type_CurrentDatetime NOT NULL,
		RecordDeleted									type_YOrN			 NULL
														CHECK (RecordDeleted in ('Y','N')),
		DeletedBy										type_UserId          NULL,
		DeletedDate										datetime			 NULL,
		IncidentReportId								int					 NULL,
		IncidentSeizureDetailsStaffNotifiedForInjury	int					 NULL,
		SignedBy										int					 NULL,
		IncidentSeizureDetailsDescriptionOfIncident		type_Comment2		 NULL,
		IncidentSeizureDetailsActionsTakenByStaff		type_Comment2		 NULL,
		IncidentSeizureDetailsWitnesses					type_Comment2		 NULL,
		IncidentSeizureDetailsDateStaffNotified			datetime			 NULL,
		IncidentSeizureDetailsTimeStaffNotified			datetime			 NULL,
		IncidentSeizureDetailsNoMedicalStaffNotified	type_YOrN			 NULL
														CHECK (IncidentSeizureDetailsNoMedicalStaffNotified in ('Y','N')),
		SignedDate										datetime			 NULL,
		PhysicalSignature								image				 NULL,
		CurrentStatus									type_GlobalCode		 NULL,
		InProgressStatus								type_GlobalCode		 NULL,
		CONSTRAINT CustomIncidentSeizureDetails_PK PRIMARY KEY CLUSTERED (IncidentSeizureDetailId) 
 )
 
  IF OBJECT_ID('CustomIncidentSeizureDetails') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomIncidentSeizureDetails >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomIncidentSeizureDetails >>>', 16, 1)
/* 
 * TABLE: CustomIncidentSeizureDetails 
 */   
 
 ALTER TABLE CustomIncidentSeizureDetails ADD CONSTRAINT CustomIncidentReports_CustomIncidentSeizureDetails_FK 
    FOREIGN KEY (IncidentReportId)
    REFERENCES CustomIncidentReports(IncidentReportId)
   
 ALTER TABLE CustomIncidentSeizureDetails ADD CONSTRAINT Staff_CustomIncidentSeizureDetails_FK 
    FOREIGN KEY (IncidentSeizureDetailsStaffNotifiedForInjury)
    REFERENCES Staff(StaffId)
    
 ALTER TABLE CustomIncidentSeizureDetails ADD CONSTRAINT Staff_CustomIncidentSeizureDetails_FK2
    FOREIGN KEY (SignedBy)
    REFERENCES Staff(StaffId)
    
    
      
  ALTER TABLE CustomIncidentReports ADD CONSTRAINT CustomIncidentSeizureDetails_CustomIncidentReports_FK 
    FOREIGN KEY (IncidentSeizureDetailId)
    REFERENCES CustomIncidentSeizureDetails(IncidentSeizureDetailId)
    
PRINT 'STEP 4(M) COMPLETED'
 END 
		
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomIncidentReportSeizureFollowUpOfIndividualStatuses')
BEGIN
/* 
 * TABLE: CustomIncidentReportSeizureFollowUpOfIndividualStatuses 
 */
 CREATE TABLE CustomIncidentReportSeizureFollowUpOfIndividualStatuses( 
		IncidentReportSeizureFollowUpOfIndividualStatusId				int	identity(1,1)	 NOT NULL,
		CreatedBy														type_CurrentUser     NOT NULL,
		CreatedDate														type_CurrentDatetime NOT NULL,
		ModifiedBy														type_CurrentUser     NOT NULL,
		ModifiedDate													type_CurrentDatetime NOT NULL,
		RecordDeleted													type_YOrN			 NULL
																		CHECK (RecordDeleted in ('Y','N')),
		DeletedBy														type_UserId          NULL,
		DeletedDate														datetime			 NULL,
		IncidentReportId												int					 NULL,
		SeizureFollowUpIndividualStatusNurseStaffEvaluating				int					 NULL,
		SeizureFollowUpIndividualStatusStaffCompletedNotification		int					 NULL,
		SignedBy														int					 NULL,
		SeizureFollowUpIndividualStatusCredentialTitle					varchar(MAX)		 NULL,
		SeizureFollowUpIndividualStatusDetailsOfInjury					type_Comment2		 NULL,
		SeizureFollowUpIndividualStatusComments							type_Comment2		 NULL,
		SeizureFollowUpIndividualStatusFamilyGuardianCustodianNotified	type_YOrN			 NULL
																		CHECK (SeizureFollowUpIndividualStatusFamilyGuardianCustodianNotified in ('Y','N')),
		SeizureFollowUpIndividualStatusDateOfNotification				datetime			 NULL,
		SeizureFollowUpIndividualStatusTimeOfNotification				datetime			 NULL,
		SeizureFollowUpIndividualStatusNameOfFamilyGuardianCustodian	varchar(MAX)		 NULL,
		SeizureFollowUpIndividualStatusDetailsOfNotification 			type_Comment2		 NULL,
		SignedDate														datetime			 NULL,
		PhysicalSignature												image				 NULL,
		CurrentStatus													type_GlobalCode		 NULL,
		InProgressStatus												type_GlobalCode		 NULL,
		CONSTRAINT CustomIncidentReportSeizureFollowUpOfIndividualStatuses_PK PRIMARY KEY CLUSTERED (IncidentReportSeizureFollowUpOfIndividualStatusId) 
 )
 
  IF OBJECT_ID('CustomIncidentReportSeizureFollowUpOfIndividualStatuses') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomIncidentReportSeizureFollowUpOfIndividualStatuses >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomIncidentReportSeizureFollowUpOfIndividualStatuses >>>', 16, 1)
/* 
 * TABLE: CustomIncidentReportSeizureFollowUpOfIndividualStatuses 
 */   
 
 ALTER TABLE CustomIncidentReportSeizureFollowUpOfIndividualStatuses ADD CONSTRAINT CustomIncidentReports_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_FK 
    FOREIGN KEY (IncidentReportId)
    REFERENCES CustomIncidentReports(IncidentReportId)
   
 ALTER TABLE CustomIncidentReportSeizureFollowUpOfIndividualStatuses ADD CONSTRAINT Staff_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_FK 
    FOREIGN KEY (SeizureFollowUpIndividualStatusNurseStaffEvaluating)
    REFERENCES Staff(StaffId)
    
 ALTER TABLE CustomIncidentReportSeizureFollowUpOfIndividualStatuses ADD CONSTRAINT Staff_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_FK2 
    FOREIGN KEY (SeizureFollowUpIndividualStatusStaffCompletedNotification)
    REFERENCES Staff(StaffId)
    
 ALTER TABLE CustomIncidentReportSeizureFollowUpOfIndividualStatuses ADD CONSTRAINT Staff_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_FK3 
    FOREIGN KEY (SignedBy)
    REFERENCES Staff(StaffId)
    
 ALTER TABLE CustomIncidentReports ADD CONSTRAINT CustomIncidentReportSeizureFollowUpOfIndividualStatuses_CustomIncidentReports_FK
    FOREIGN KEY (IncidentReportSeizureFollowUpOfIndividualStatusId)
    REFERENCES CustomIncidentReportSeizureFollowUpOfIndividualStatuses(IncidentReportSeizureFollowUpOfIndividualStatusId)
    
    
PRINT 'STEP 4(N) COMPLETED'
 END 
		
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomIncidentReportSeizureSupervisorFollowUps')
BEGIN
/* 
 * TABLE:   CustomIncidentReportSeizureSupervisorFollowUps 
 */
 CREATE TABLE CustomIncidentReportSeizureSupervisorFollowUps( 
		IncidentReportSeizureSupervisorFollowUpId				int identity(1,1)	 NOT NULL,
		CreatedBy												type_CurrentUser     NOT NULL,
		CreatedDate												type_CurrentDatetime NOT NULL,
		ModifiedBy												type_CurrentUser     NOT NULL,
		ModifiedDate											type_CurrentDatetime NOT NULL,
		RecordDeleted											type_YOrN			 NULL
																CHECK (RecordDeleted in ('Y','N')),
		DeletedBy												type_UserId          NULL,
		DeletedDate												datetime			 NULL,
		IncidentReportId										int					 NULL,
		SeizureSupervisorFollowUpSupervisorName					int					 NULL,
		SeizureSupervisorFollowUpAdministrator					int					 NULL,
		SeizureSupervisorFollowUpStaffCompletedNotification		int					 NULL,
		SignedBy												int					 NULL,
		SeizureSupervisorFollowUpFollowUp						type_Comment2		 NULL,
		SeizureSupervisorFollowUpAdministratorNotified			type_YOrN			 NULL
																CHECK (SeizureSupervisorFollowUpAdministratorNotified in ('Y','N')),
		SeizureSupervisorFollowUpAdminDateOfNotification		datetime			 NULL,
		SeizureSupervisorFollowUpAdminTimeOfNotification		datetime			 NULL,
		SeizureSupervisorFollowUpFamilyGuardianCustodianNotified type_YOrN			 NULL
																CHECK (SeizureSupervisorFollowUpFamilyGuardianCustodianNotified in ('Y','N')),
		SeizureSupervisorFollowUpFGCDateOfNotification			datetime			 NULL,
		SeizureSupervisorFollowUpFGCTimeOfNotification			datetime			 NULL,
		
		SeizureSupervisorFollowUpNameOfFamilyGuardianCustodian	varchar(MAX)		 NULL,
		SeizureSupervisorFollowUpDetailsOfNotification			type_Comment2		 NULL,
		SignedDate												datetime			 NULL,
		PhysicalSignature										image				 NULL,
		CurrentStatus											type_GlobalCode		 NULL,
		InProgressStatus										type_GlobalCode		 NULL,
		CONSTRAINT CustomIncidentReportSeizureSupervisorFollowUps_PK PRIMARY KEY CLUSTERED (IncidentReportSeizureSupervisorFollowUpId) 
 )
 
  IF OBJECT_ID('CustomIncidentReportSeizureSupervisorFollowUps') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomIncidentReportSeizureSupervisorFollowUps >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomIncidentReportSeizureSupervisorFollowUps >>>', 16, 1)
/* 
 * TABLE: CustomIncidentReportSeizureSupervisorFollowUps 
 */   
 
 ALTER TABLE CustomIncidentReportSeizureSupervisorFollowUps ADD CONSTRAINT CustomIncidentReports_CustomIncidentReportSeizureSupervisorFollowUps_FK 
    FOREIGN KEY (IncidentReportId)
    REFERENCES CustomIncidentReports(IncidentReportId)
   
 ALTER TABLE CustomIncidentReportSeizureSupervisorFollowUps ADD CONSTRAINT Staff_CustomIncidentReportSeizureSupervisorFollowUps_FK 
    FOREIGN KEY (SeizureSupervisorFollowUpSupervisorName)
    REFERENCES Staff(StaffId)
    
 ALTER TABLE CustomIncidentReportSeizureSupervisorFollowUps ADD CONSTRAINT Staff_CustomIncidentReportSeizureSupervisorFollowUps_FK2
    FOREIGN KEY (SeizureSupervisorFollowUpAdministrator)
    REFERENCES Staff(StaffId)
    
ALTER TABLE CustomIncidentReportSeizureSupervisorFollowUps ADD CONSTRAINT Staff_CustomIncidentReportSeizureSupervisorFollowUps_FK3
    FOREIGN KEY (SeizureSupervisorFollowUpStaffCompletedNotification)
    REFERENCES Staff(StaffId)
    
 ALTER TABLE CustomIncidentReportSeizureSupervisorFollowUps ADD CONSTRAINT Staff_CustomIncidentReportSeizureSupervisorFollowUps_FK4
    FOREIGN KEY (SignedBy)
    REFERENCES Staff(StaffId)
    
 ALTER TABLE CustomIncidentReports ADD CONSTRAINT CustomIncidentReportSeizureSupervisorFollowUps_CustomIncidentReports_FK
    FOREIGN KEY (IncidentReportSeizureSupervisorFollowUpId)
    REFERENCES CustomIncidentReportSeizureSupervisorFollowUps(IncidentReportSeizureSupervisorFollowUpId)
    
PRINT 'STEP 4(O) COMPLETED'
 END 

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomIncidentReportSeizureAdministratorReviews')
BEGIN
/* 
 * TABLE:  CustomIncidentReportSeizureAdministratorReviews 
 */
 CREATE TABLE CustomIncidentReportSeizureAdministratorReviews( 
		IncidentReportSeizureAdministratorReviewId				int identity(1,1)	 NOT NULL,
		CreatedBy												type_CurrentUser     NOT NULL,
		CreatedDate												type_CurrentDatetime NOT NULL,
		ModifiedBy												type_CurrentUser     NOT NULL,
		ModifiedDate											type_CurrentDatetime NOT NULL,
		RecordDeleted											type_YOrN			 NULL
																CHECK (RecordDeleted in ('Y','N')),
		DeletedBy												type_UserId          NULL,
		DeletedDate												datetime			 NULL,
		IncidentReportId										int					 NULL,
		SeizureAdministratorReviewAdministrator					int					 NULL,
		SignedBy												int					 NULL,
		SeizureAdministratorReviewAdministrativeReview			type_Comment2		 NULL,
		SeizureAdministratorReviewFiledReportableIncident		char(1)				 NULL
																CHECK (SeizureAdministratorReviewFiledReportableIncident in ('Y','N','O')),
		SeizureAdministratorReviewComments						type_Comment2		 NULL,
		SignedDate												datetime			 NULL,
		PhysicalSignature										image				 NULL,
		CurrentStatus											type_GlobalCode		 NULL,
		InProgressStatus										type_GlobalCode		 NULL,
		CONSTRAINT CustomIncidentReportSeizureAdministratorReviews_PK PRIMARY KEY CLUSTERED (IncidentReportSeizureAdministratorReviewId) 
 )
 
  IF OBJECT_ID('CustomIncidentReportSeizureAdministratorReviews') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomIncidentReportSeizureAdministratorReviews >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomIncidentReportSeizureAdministratorReviews >>>', 16, 1)
/* 
 * TABLE: CustomIncidentReportSeizureAdministratorReviews 
 */   
 
 ALTER TABLE CustomIncidentReportSeizureAdministratorReviews ADD CONSTRAINT CustomIncidentReports_CustomIncidentReportSeizureAdministratorReviews_FK 
    FOREIGN KEY (IncidentReportId)
    REFERENCES CustomIncidentReports(IncidentReportId)
   
 ALTER TABLE CustomIncidentReportSeizureAdministratorReviews ADD CONSTRAINT Staff_CustomIncidentReportSeizureAdministratorReviews_FK 
    FOREIGN KEY (SeizureAdministratorReviewAdministrator)
    REFERENCES Staff(StaffId)
    
 ALTER TABLE CustomIncidentReportSeizureAdministratorReviews ADD CONSTRAINT Staff_CustomIncidentReportSeizureAdministratorReviews_FK2 
    FOREIGN KEY (SignedBy)
    REFERENCES Staff(StaffId)
    
  ALTER TABLE CustomIncidentReports ADD CONSTRAINT CustomIncidentReportSeizureAdministratorReviews_CustomIncidentReports_FK 
    FOREIGN KEY (IncidentReportSeizureAdministratorReviewId)
    REFERENCES CustomIncidentReportSeizureAdministratorReviews(IncidentReportSeizureAdministratorReviewId)
    
PRINT 'STEP 4(P) COMPLETED'
 END 
---------------------------------------------------------------------------------------------
--END Of STEP 4 ------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

If NOT EXISTS (SELECT [key] FROM SystemConfigurationKeys WHERE [key] = 'CDM_IncidentReport')
	BEGIN
		INSERT INTO [dbo].[SystemConfigurationKeys]
				   (CreatedBy
				   ,CreateDate 
				   ,ModifiedBy
				   ,ModifiedDate
				   ,[Key]
				   ,Value
				   )
			 VALUES    
				   ('SHSDBA'
				   ,GETDATE()
				   ,'SHSDBA'
				   ,GETDATE()
				   ,'CDM_IncidentReport'
				   ,'1.0'
				   )

		PRINT 'STEP 7 COMPLETED'     
	END
Go