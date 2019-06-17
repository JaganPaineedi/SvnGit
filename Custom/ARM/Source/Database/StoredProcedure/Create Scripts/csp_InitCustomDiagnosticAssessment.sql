

/****** Object:  StoredProcedure [dbo].[csp_InitCustomDiagnosticAssessment]    Script Date: 12/08/2015 15:27:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDiagnosticAssessment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomDiagnosticAssessment]
GO



/****** Object:  StoredProcedure [dbo].[csp_InitCustomDiagnosticAssessment]    Script Date: 12/08/2015 15:27:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

   
    
CREATE procedure [dbo].[csp_InitCustomDiagnosticAssessment] (    
     @StaffId int,    
     @ClientID int,    
     @CustomParameters xml    
    )    
as     
begin    
/*********************************************************************/    
/* Stored Procedure: csp_InitCustomDiagnosticAssessment              */    
/* Copyright: 2009 Streamline Healthcare Solutions,  LLC             */    
/* Creation Date: 30 May,2011                                       */    
/*                                                                   */    
/* Purpose:  To Initialize Data for CustomDiagnosticAssessments Pages  */    
/*                                                                   */    
/* Input Parameters:   @StaffId,@ClientID,@CustomParameters  */    
/*                                                                   */    
/* Output Parameters:   None                   */    
/*                                                                   */    
/* Return:  0=success, otherwise an error number                     */    
/*                                                                   */    
/* Called By:  DiagnosticAssessment         */    
/*                 */    
/* Calls:         */    
/*                         */    
/* Data Modifications:                   */    
/*      */    
/* Updates:               */    
/*  Date   Author      Purpose                                */    
/* 30 May,2011  Minakshi To Initialize Data for CustomDiagnosticAssessment */    
/*  July 21, 2012 Pralyankar Modified for implementing the Placeholder Concept*/    
/*  Sep 13, 2012 Maninder Added @TypeOfAssessment - No need to initialize CustomDocumentAssessmentNeeds in Case of @TypeOfAssessment='E' */   
/*  Dec 08,2015  Pradeep Kumar Yadav  Add Some Modification CustomDocumentAssessmentNeeds Select Statement For Task #410 ARM Support */  
/*********************************************************************/    
    
    begin try    
  DECLARE @TypeOfAssessment CHAR(1)    
        declare @clientAge varchar(50)    
        exec csp_CalculateAge @ClientId, @clientAge out    
    
        declare @ReferralTransferReferenceURL varchar(1000)    
        set @ReferralTransferReferenceURL = (    
                                             select ReferralTransferReferenceUrl    
                                             from   CustomConfigurations    
                                            )    
    
        declare @AssessmentTypeCheck varchar(10)    
        declare @CurrentAuthorId int    
        set @AssessmentTypeCheck = @CustomParameters.value('(/Root/Parameters/@ScreenType)[1]',    
                                                           'varchar(10)')    
        set @CurrentAuthorId = @CustomParameters.value('(/Root/Parameters/@CurrentAuthorId)[1]',    
                                                       'int')    
    
    
        declare @LatestSignedDocumentVersionID int    
        set @LatestSignedDocumentVersionID = -1    
    
  declare @LatestSignedDiagnosisVersionId int    
  select top 1 @LatestSignedDiagnosisVersionId = d.CurrentDocumentVersionId    
  from dbo.Documents as d    
  where d.ClientId = @ClientId    
  and d.Status = 22    
  and d.DocumentCodeId = 5 -- Diagnosis    
  and DATEDIFF(DAY, d.EffectiveDate, GETDATE()) between 0 and 366 -- not more than a year old    
  and ISNULL(d.RecordDeleted, 'N') <> 'Y'    
  order by d.EffectiveDate desc, d.DocumentId desc    
      
 --Get the latest signed document version ID    
        set @LatestSignedDocumentVersionID = (    
                                              select top 1    
                                                        CurrentDocumentVersionId    
                                              from      CustomDocumentDiagnosticAssessments C,    
                                                        Documents D    
                                              where     C.DocumentVersionId = D.CurrentDocumentVersionId    
         and D.ClientId = @ClientID    
                                                        and D.Status = 22    
                                                        and DocumentCodeId = 1486    
                        and ISNULL(C.RecordDeleted,    
                                                              'N') = 'N'    
                                                        and ISNULL(D.RecordDeleted,    
                                                              'N') = 'N'    
                                              order by  D.EffectiveDate desc,    
                                                        D.ModifiedDate desc    
                                             )    
    
 SELECT @TypeOfAssessment=TypeOfAssessment FROM CustomDocumentDiagnosticAssessments WHERE DocumentVersionId= ISNULL(@LatestSignedDocumentVersionID,-1)    
     
  --IF((@AssessmentTypeCheck='I' or @AssessmentTypeCheck='' or @AssessmentTypeCheck='U') and (@LatestSignedDocumentVersionID is null))    
        if (    
            (    
             @LatestSignedDocumentVersionID is null    
             or @LatestSignedDocumentVersionID = -1    
            )    
            or (    
                @AssessmentTypeCheck = 'I'    
                and @LatestSignedDocumentVersionID > 0    
               )    
           )     
            begin    
    
    
    
  -----For CustomDocumentDiagnosticAssessments-----    
                select  Placeholder.TableName,-- 'CustomDocumentDiagnosticAssessments' as TableName,    
                        @AssessmentTypeCheck as InitialOrUpdate,    
                        -1 as DocumentVersionId,    
                        '' as CreatedBy,    
                        GETDATE() as CreatedDate,    
                        '' as ModifiedBy,    
                        GETDATE() as ModifiedDate,    
                        @clientAge as clientAge,    
                        'Need identified at the diagnostic assessment.' AS TransferAssessedNeed,    
                        @ReferralTransferReferenceURL as ReferralTransferReferenceURL    
                from  (SELECT 'CustomDocumentDiagnosticAssessments' AS TableName, -1 as DocumentVersionId) AS Placeholder --systemconfigurations s    
     left outer join CustomDocumentDiagnosticAssessments AS CDDA on CDDA.DocumentVersionId = Placeholder.DocumentVersionId    
    
    
  -----For DiagnosesIII-----    
     --           select  PlaceHolder.TableName,    
     --                   PlaceHolder.DocumentVersionId,    
     --                   '' as CreatedBy,    
     --                   GETDATE() as CreatedDate,    
     --                   '' as ModifiedBy,    
     --                   GETDATE() as ModifiedDate,    
     --                   dx.RecordDeleted,    
     --                   dx.DeletedDate,    
     --                   dx.DeletedBy,    
     --                   dx.Specification    
     --           from (select 'DiagnosesIII' as TableName, -1 as DocumentVersionId) as PlaceHolder    
     --left outer join DiagnosesIII as dx on dx.DocumentVersionId = @LatestSignedDiagnosisVersionId and ISNULL(dx.RecordDeleted, 'N') <> 'Y'    
    
    -- -----For DiagnosesIV-----    
     --           select  PlaceHolder.TableName,    
     --                   PlaceHolder.DocumentVersionId,    
     --                   dx.PrimarySupport,    
     --                   dx.SocialEnvironment,    
     --                   dx.Educational,    
     --                   dx.Occupational,    
     --                   dx.Housing,    
     --                   dx.Economic,    
     --                   dx.HealthcareServices,    
     --                   dx.Legal,    
     --                   dx.Other,    
     --                   dx.Specification,    
     --                   '' as CreatedBy,    
     --                   GETDATE() as CreatedDate,    
     --                   '' as ModifiedBy,    
     --                   GETDATE() as ModifiedDate,    
     --                   dx.RecordDeleted,    
     --                dx.DeletedDate,    
     --                   dx.DeletedBy    
     --           from (select 'DiagnosesIV' as TableName, -1 as DocumentVersionId) as PlaceHolder    
     --left outer join DiagnosesIV as dx on dx.DocumentVersionId = @LatestSignedDiagnosisVersionId and ISNULL(dx.RecordDeleted, 'N') <> 'Y'    
    
   ---- -----For DiagnosesV-----    
   --             select  PlaceHolder.TableName,    
   --                     PlaceHolder.DocumentVersionId,    
   --                     dx.AxisV,    
   --                     '' as CreatedBy,    
   --                     GETDATE() as CreatedDate,    
   --                     '' as ModifiedBy,    
   --                     GETDATE() as ModifiedDate,    
   --                     dx.RecordDeleted,    
   --                     dx.DeletedDate,    
   --                     dx.DeletedBy    
   --             from (select 'DiagnosesV' as TableName, -1 as DocumentVersionId) as PlaceHolder    
   --  left outer join DiagnosesV as dx on dx.DocumentVersionId = @LatestSignedDiagnosisVersionId and ISNULL(dx.RecordDeleted, 'N') <> 'Y'    
    
   -- --Diagnosis I and II    
   --             select  'DiagnosesIAndII' as TableName,    
   --                     CONVERT(int, 0    
   --                     - ROW_NUMBER() over (order by dx.DiagnosisId asc)) as DiagnosisId,    
   --                     dx.DocumentVersionId,    
   --                     dx.Axis,    
   --                     dx.DSMCode,    
   --                     dx.DSMNumber,    
   --                     dx.DiagnosisType,    
   --                     dx.RuleOut,    
   --                     dx.Billable,    
   --                     dx.Severity,    
   --                     dx.DSMVersion,    
   --                     dx.DiagnosisOrder,    
   --                     dx.Specifier,    
   --                     dx.Remission,    
   --                     dx.Source,    
   --                     dx.RowIdentifier,    
   --                     dx.CreatedBy,    
   --                     dx.CreatedDate,    
   --                     dx.ModifiedBy,    
   --                     dx.ModifiedDate,    
   --                     dx.RecordDeleted,    
   --                     dx.DeletedDate,    
   --                     dx.DeletedBy,    
   --   DSM.DSMDescription,    
   --                     'CustomGrid' as ParentChildName    
   --             from    dbo.DiagnosesIAndII as dx    
   -- left outer join DiagnosisDSMDescriptions as dsm on dsm.DSMCode = dx.DSMCode and dsm.DSMNumber = dx.DSMNumber    
   --             where   DocumentVersionId = @LatestSignedDiagnosisVersionId    
   --                     and ISNULL(RecordDeleted, 'N') = 'N'    
    
    
   -- --DiagnosesIIICodes    
   --             select  PlaceHolder.TableName,--'DiagnosesIIICodes' as TableName,    
   --                     DIIICod.DiagnosesIIICodeId,    
   --                     DIIICod.DocumentVersionId,    
   --                     DIIICod.ICDCode,    
   --                     DICD.ICDDescription,    
   --                     DIIICod.Billable,    
   --                     DIIICod.CreatedBy,    
   --                     DIIICod.CreatedDate,    
   --                     DIIICod.ModifiedBy,    
   --                     DIIICod.ModifiedDate,    
   --                     DIIICod.RecordDeleted,    
   --                     DIIICod.DeletedDate,    
   --                     DIIICod.DeletedBy    
   --                     -- Below From Statement Modified by Pralyankar On July 21, 2012 for implementing the PlaceHolder    
   --             from  (select 'DiagnosesIIICodes' as TableName, @LatestSignedDiagnosisVersionId as DocumentVersionId) as PlaceHolder      
   --  Left Outer Join DiagnosesIIICodes as DIIICod ON DIIICod.DocumentVersionId = PlaceHolder.DocumentVersionId    
   --  inner join DiagnosisICDCodes as DICD on DIIICod.ICDCode = DICD.ICDCode    
   --             where  ISNULL(DIIICod.RecordDeleted, 'N') = 'N' -- and (DIIICod.DocumentVersionId = @LatestSignedDiagnosisVersionId)     
    
   -- --DiagnosesIANDIIMaxOrder    
   --             select top 1    
   --                     'DiagnosesIANDIIMaxOrder' as TableName,    
   --                     MAX(DiagnosisOrder) as DiagnosesMaxOrder,    
   --                     CreatedBy,    
   --                     ModifiedBy,    
   --                     CreatedDate,    
   --                     ModifiedDate,    
   --                     RecordDeleted,    
   --                     DeletedBy,    
   --                     DeletedDate    
   --    from    DiagnosesIAndII    
   --             where   ISNULL(RecordDeleted, 'N') = 'N' and DocumentVersionId = @LatestSignedDiagnosisVersionId    
    
   --             group by CreatedBy,    
   --                     ModifiedBy,    
   --                     CreatedDate,    
   --                     ModifiedDate,    
   --                     RecordDeleted,    
   --                     DeletedBy,    
   --                     DeletedDate    
   --             order by DiagnosesMaxOrder desc    
    
  -- Mental Status --    
                select  PlaceHolder.TableName, --'CustomDocumentMentalStatuses' as TableName,    
                        -1 as DocumentVersionId,    
                        '' as CreatedBy,    
                        GETDATE() as CreatedDate,    
                        '' as ModifiedBy,    
                        GETDATE() as ModifiedDate    
                from  (select 'CustomDocumentMentalStatuses' as TableName, -1 as DocumentVersionId) as PlaceHolder--  systemconfigurations s    
     left outer join CustomDocumentMentalStatuses S on s.DocumentVersionId = PlaceHolder.DocumentVersionId    
    
    
   --exec ssp_ScwebInitializeTreatmentPlanInitial  @ClientID,@StaffId,@CustomParameters    
    
  --TP initialization    
    
                if (    
                    @AssessmentTypeCheck != ''    
                    and @AssessmentTypeCheck = 'I'    
                   )     
                    begin    
    
                        exec csp_InitCustomDiagnosticAssessmentTreatmentPlan @ClientID,    
                            @StaffId    
                    end    
    
            end    
    
        if (    
            @AssessmentTypeCheck = 'U'    
            and @LatestSignedDocumentVersionID > 0    
           )     
            begin    
                
    declare @LastDiagnosisDocumentVersion int    
        
    select @LastDiagnosisDocumentVersion = CurrentDocumentVersionId    
    from dbo.Documents as d    
    where d.ClientId = @ClientId    
    and d.DocumentCodeId = 5    
    and d.Status = 22    
    and ISNULL(d.RecordDeleted, 'N') <> 'Y'    
    and not exists (    
     select *    
     from dbo.Documents as d2    
     where d2.DocumentCodeId = d.DocumentCodeId    
     and d2.ClientId = d.ClientId    
     and ((d2.EffectiveDate > d.EffectiveDate)    
      or (d2.EffectiveDate = d.EffectiveDate and d2.DocumentId > d.DocumentId))    
     and ISNULL(d2.RecordDeleted, 'N') <> 'Y'    
    )    
         
        
    -----For CustomDocumentDiagnosticAssessments-----    
                select Placeholder.TableName,-- 'CustomDocumentDiagnosticAssessments' as TableName,    
                        Placeholder.DocumentVersionId,    
                        @AssessmentTypeCheck as InitialOrUpdate,    
                      ReasonForUpdate,    
                        CreatedBy,    
                        CreatedDate,    
                        ModifiedBy,    
                        ModifiedDate,    
                        RecordDeleted,    
                        DeletedBy,    
                        DeletedDate,    
                        TypeOfAssessment,    
                        PresentingProblem,    
                        OptionsAlreadyTried,    
                        ClientHasLegalGuardian,    
                        LegalGuardianInfo,    
                        AbilitiesInterestsSkills,    
                        FamilyHistory,    
                        EthnicityCulturalBackground,    
                        SexualOrientationGenderExpression,    
                        GenderExpressionConsistent,    
                        SupportSystems,    
                        ClientStrengths,    
                        LivingSituation,    
                        IncludeHousingAssessment,    
                        ClientEmploymentNotApplicable,    
                        ClientEmploymentMilitaryHistory,    
                        IncludeVocationalAssessment,    
                        HighestEducationCompleted,    
                        EducationComment,    
                        LiteracyConcerns,    
                        LegalInvolvement,    
                        LegalInvolvementComment,    
                        HistoryEmotionalProblemsClient,    
                        ClientHasReceivedTreatment,    
                        ClientPriorTreatmentDiagnosis,    
                        PriorTreatmentCounseling,    
                        PriorTreatmentCounselingDates,    
                        PriorTreatmentCounselingComment,    
                        PriorTreatmentCaseManagement,    
                        PriorTreatmentCaseManagementDates,    
                        PriorTreatmentCaseManagementComment,    
                        PriorTreatmentOther,    
                        PriorTreatmentOtherDates,    
                        PriorTreatmentOtherComment,    
                        PriorTreatmentMedication,    
                        PriorTreatmentMedicationDates,    
                        PriorTreatmentMedicationComment,    
                        TypesOfMedicationResults,    
                        ClientResponsePastTreatment,    
                        AbuseNotApplicable,    
                        AbuseEmotionalVictim,    
                        AbuseEmotionalOffender,    
                        AbuseVerbalVictim,    
                        AbuseVerbalOffender,    
                        AbusePhysicalVictim,    
                        AbusePhysicalOffender,    
                        AbuseSexualVictim,    
                        AbuseSexualOffender,    
                        AbuseNeglectVictim,    
                        AbuseNeglectOffender,    
                        AbuseComment,    
                        FamilyPersonalHistoryLossTrauma,    
                        BiologicalMotherUseNoneReported,    
                        BiologicalMotherUseAlcohol,    
                        BiologicalMotherTobacco,    
                        BiologicalMotherUseOther,    
                        BiologicalMotherUseOtherType,    
                        ClientReportAlcoholTobaccoDrugUse,    
                        ClientReportDrugUseComment,    
                        FurtherSubstanceAssessmentIndicated,    
                        ClientHasHistorySubstanceUse,    
                        ClientHistorySubstanceUseComment,    
                        AlcoholUseWithin30Days,    
                        AlcoholUseCurrentFrequency,    
                        AlcoholUseWithinLifetime,    
                        AlcoholUsePastFrequency,    
                        AlcoholUseReceivedTreatment,    
                        CocaineUseWithin30Days,    
                        CocaineUseCurrentFrequency,    
                        CocaineUseWithinLifetime,    
                        CocaineUsePastFrequency,    
                        CocaineUseReceivedTreatment,    
                        SedtativeUseWithin30Days,    
                        SedtativeUseCurrentFrequency,    
                        SedtativeUseWithinLifetime,    
                        SedtativeUsePastFrequency,    
                        SedtativeUseReceivedTreatment,    
                        HallucinogenUseWithin30Days,    
                        HallucinogenUseCurrentFrequency,    
                        HallucinogenUseWithinLifetime,    
                        HallucinogenUsePastFrequency,    
                        HallucinogenUseReceivedTreatment,    
                        StimulantUseWithin30Days,    
                     StimulantUseCurrentFrequency,    
                        StimulantUseWithinLifetime,    
                        StimulantUsePastFrequency,    
                        StimulantUseReceivedTreatment,    
                        NarcoticUseWithin30Days,    
                        NarcoticUseCurrentFrequency,    
                        NarcoticUseWithinLifetime,    
                        NarcoticUsePastFrequency,    
                        NarcoticUseReceivedTreatment,    
                        MarijuanaUseWithin30Days,    
                        MarijuanaUseWithinLifetime,    
                        MarijuanaUseReceivedTreatment,    
                        InhalantsUseWithin30Days,    
                        InhalantsUseCurrentFrequency,    
                        InhalantsUseWithinLifetime,    
                        InhalantsUsePastFrequency,    
                        InhalantsUseReceivedTreatment,    
                        OtherUseWithin30Days,    
                        OtherUseCurrentFrequency,    
                        OtherUseWithinLifetime,    
                        OtherUsePastFrequency,    
                        OtherUseReceivedTreatment,    
                        OtherUseType,    
                        DASTScore,    
                        MASTScore,    
                        ClientReferredSubstanceTreatment,    
                        ClientReferredSubstanceTreatmentWhere,    
                        cast(null as char(1)) as RiskSuicideIdeation,    
                        RiskSuicideIdeationComment,    
                        cast(null as char(1)) as RiskSuicideIntent,    
                        RiskSuicideIntentComment,    
                        cast(null as char(1)) as RiskSuicidePriorAttempts,    
                        RiskSuicidePriorAttemptsComment,    
                        cast(null as char(1)) as RiskPriorHospitalization,    
                        RiskPriorHospitalizationComment,    
                        cast(null as char(1)) as RiskPhysicalAggressionSelf,    
                        RiskPhysicalAggressionSelfComment,    
                        cast(null as char(1)) as RiskVerbalAggressionOthers,    
                        RiskVerbalAggressionOthersComment,    
                        cast(null as char(1)) as RiskPhysicalAggressionObjects,    
                        RiskPhysicalAggressionObjectsComment,    
                        cast(null as char(1)) as RiskPhysicalAggressionPeople,    
                        RiskPhysicalAggressionPeopleComment,    
                        cast(null as char(1)) as RiskReportRiskTaking,    
                        RiskReportRiskTakingComment,    
                        cast(null as char(1)) as RiskThreatClientPersonalSafety,    
                        RiskThreatClientPersonalSafetyComment,    
                        cast(null as char(1)) as RiskPhoneNumbersProvided,    
                        cast(null as char(1)) as RiskCurrentRiskIdentified,    
                        RiskTriggersDangerousBehaviors,    
                        RiskCopingSkills,    
                        RiskInterventionsPersonalSafetyNA,    
                        RiskInterventionsPersonalSafety,    
                        RiskInterventionsPublicSafetyNA,    
                        RiskInterventionsPublicSafety,    
                        PhysicalProblemsNoneReported,    
                        PhysicalProblemsComment,    
                        SpecialNeedsNoneReported,    
                        SpecialNeedsVisualImpairment,    
                        SpecialNeedsHearingImpairment,    
                        SpecialNeedsSpeechImpairment,    
                        SpecialNeedsOtherPhysicalImpairment,    
                        SpecialNeedsOtherPhysicalImpairmentComment,    
                        EducationSchoolName,    
                        EducationPreviousExpulsions,    
                        EducationClassification,    
                        EducationEmotionalDisturbance,    
                        EducationPreschoolersDisability,    
                        EducationTraumaticBrainInjury,    
                        EducationCognitiveDisability,    
                        EducationCurrent504,    
                        EducationOtherMajorHealthImpaired,    
                        EducationSpecificLearningDisability,    
                        EducationAutism,    
                        EducationOtherMinorHealthImpaired,    
                        EdcuationClassificationComment,    
                        EducationPreviousRetentions,    
                        EducationClientIsHomeSchooled,    
                        EducationClientAttendedPreschool,    
                        EducationFrequencyOfAttendance,    
                        EducationReceivedServicesAsToddler,    
                        EducationReceivedServicesAsToddlerComment,    
                        ClientPreferencesForTreatment,    
                        ExternalSupportsReferrals,    
                        PrimaryClinicianTransfer,    
                        EAPMentalStatus    
      -- this cannot be carried forward in an update    
                        ,    
                        CAST(null as varchar(max)) as DiagnosticImpressionsSummary,    
                        MilestoneUnderstandingLanguage,    
                        MilestoneVocabulary,    
                        MilestoneFineMotor,    
                        MilestoneGrossMotor,    
                        MilestoneIntellectual,    
                        MilestoneMakingFriends,    
                        MilestoneSharingInterests,    
                        MilestoneEyeContact,    
                        MilestoneToiletTraining,    
                        MilestoneCopingSkills,    
                        MilestoneComment,    
                        SleepConcernSleepHabits,    
                        SleepTimeGoToBed,    
                        SleepTimeFallAsleep,    
                        SleepThroughNight,    
                        SleepNightmares,    
                        SleepNightmaresHowOften,    
                        SleepTerrors,    
                        SleepTerrorsHowOften,    
                        SleepWalking,    
                        SleepWalkingHowOften,    
                        SleepTimeWakeUp,    
                        SleepShareRoom,    
                        SleepShareRoomWithWhom,    
                        SleepTakeNaps,    
                        SleepTakeNapsHowOften,    
                        FamilyPrimaryCaregiver,    
                        FamilyPrimaryCaregiverType,    
                        FamilyPrimaryCaregiverEducation,    
                        FamilyPrimaryCaregiverAge,    
                        FamilyAdditionalCareGivers,    
                        FamilyEmploymentFirstCareGiver,    
                        FamilyEmploymentSecondCareGiver,    
                        FamilyStatusParentsRelationship,    
                        FamilyNonCustodialContact,    
                        FamilyNonCustodialHowOften,    
                        FamilyNonCustodialTypeOfVisit,    
                        FamilyNonCustodialConsistency,    
                        FamilyNonCustodialLegalInvolvement,    
                        FamilyClientMovedResidences,    
                        FamilyClientMovedResidencesComment,    
                        FamilyClientHasSiblings,    
                        FamilyClientSiblingsComment,    
                        FamilyQualityRelationships,    
                        FamilySupportSystems,    
                        FamilyClientAbilitiesNA,    
                        FamilyClientAbilitiesComment,    
                        ChildHistoryLegalInvolvement,    
                        ChildHistoryLegalInvolvementComment,    
                        ChildHistoryBehaviorInFamily,    
                        ChildHistoryBehaviorInFamilyComment,    
                        ChildAbuseReported,    
            ChildProtectiveServicesInvolved,    
                        ChildProtectiveServicesReason,    
                        ChildProtectiveServicesCounty,    
                        ChildProtectiveServicesCaseWorker,    
                        ChildProtectiveServicesDates,    
                        ChildProtectiveServicesPlacements,    
                        ChildProtectiveServicesPlacementsComment,    
                        ChildHistoryOfViolence,    
                        ChildCTESComplete,    
                        ChildCTESResults,    
                        ChildWitnessedSubstances,    
                        ChildWitnessedSubstancesComment,    
                        ChildBornFullTermPreTerm,    
                        ChildBornFullTermPreTermComment,    
                        ChildMotherUsedDrugsPregnancy,    
                        ChildMotherUsedDrugsPregnancyComment,    
                        ChildConcernsNutrition,    
                        ChildConcernsNutritionComment,    
                        ChildConcernsAbilityUnderstand,    
                        ChildUsingWordsPhrases,    
      ChildReceivedSpeechEval,    
                        ChildReceivedSpeechEvalComment,    
                        ChildConcernMotorSkills,    
                        ChildGrossMotorSkillsProblem,    
                        ChildWalking14Months,    
                        ChildFineMotorSkillsProblem,    
                        ChildPickUpCheerios,    
                        ChildConcernSocialSkills,    
                        ChildConcernSocialSkillsComment,    
                        ChildToiletTraining,    
                        ChildToiletTrainingComment,    
                        ChildSensoryAversions,    
                        ChildSensoryAversionsComment,    
                        HousingHowStable,    
                        HousingAbleToStay,    
                        HousingEvictionsUnpaidUtilities,    
                        HousingAbleGetUtilities,    
                        HousingAbleSignLease,    
                        HousingSpecializedProgram,    
                        HousingHasPets,    
                        VocationalUnemployed,    
                        VocationalInterestedWorking,    
                        VocationalInterestedWorkingComment,    
                        VocationalTimeSinceEmployed,    
                        VocationalTimeJobHeld,    
                        VocationalBarriersGainingEmployment,    
                        VocationalEmployed,    
                        VocationalTimeCurrentJob,    
                        VocationalBarriersMaintainingEmployment,    
                        UpdatePsychoSocial,    
                        UpdateSubstanceUse,    
                        UpdateRiskIndicators,    
                        UpdatePhysicalHealth,    
                        UpdateEducationHistory,    
                        UpdateDevelopmentalHistory,    
                        UpdateSleepHygiene,    
                        UpdateFamilyHistory,    
                        UpdateHousing,    
                        UpdateVocational,    
                        TransferReceivingStaff,    
                        TransferReceivingProgram,    
                        'Need identified at the diagnostic assessment.' AS TransferAssessedNeed,    
                        TransferClientParticipated,    
                        ClientResponsePastTreatmentNA,    
                        MarijuanaUseCurrentFrequency,    
                        MarijuanaUsePastFrequency,    
                        ChildHistoryOfViolenceComment,    
                        ChildPostPartumDepression,    
                        @clientAge as clientAge,    
                        @ReferralTransferReferenceURL as ReferralTransferReferenceURL    
                -- Modified the From statement by Pralyankar on July 21, 2012 for placeholder Implementations.    
                from    (SELECT 'CustomDocumentDiagnosticAssessments' AS TableName, isnull(@LatestSignedDocumentVersionID,-1) as DocumentVersionId) AS Placeholder    
     LEFT OUTER JOIN CustomDocumentDiagnosticAssessments as CDDA On CDDA.DocumentVersionId = Placeholder.DocumentVersionId    
                where   ISNULL(RecordDeleted, 'N') = 'N' --AND DocumentVersionId = @LatestSignedDocumentVersionID    
                            
    
    
 --  -----For DiagnosesIII-----    
 --               select  PlaceHolder.TableName,    
 --                       DocumentVersionId,    
 --                       CreatedBy,    
 --                       CreatedDate,    
 --                       ModifiedBy,    
 --                       ModifiedDate,    
 --                       RecordDeleted,    
 --                       DeletedDate,    
 --                       DeletedBy,    
 --                       Specification    
 --               from (select 'DiagnosesIII' as TableName) as PlaceHolder    
 --    LEFT join DiagnosesIII as dx on DocumentVersionId = @LastDiagnosisDocumentVersion and ISNULL(RecordDeleted, 'N') = 'N'    
    
 --  -----For DiagnosesIV-----    
 --               select  PlaceHolder.TableName,    
 --                       DocumentVersionId,    
 --                       PrimarySupport,    
 --                       SocialEnvironment,    
 --                       Educational,    
 --                       Occupational,    
 --                       Housing,    
 --                       Economic,    
 --                       HealthcareServices,    
 --                       Legal,    
 --                       Other,    
 --                       Specification,    
 --                       CreatedBy,    
 --                       CreatedDate,    
 --                       ModifiedBy,    
 --                       ModifiedDate,    
 --                       RecordDeleted,    
 --                       DeletedDate,    
 --                       DeletedBy    
 --               from (select 'DiagnosesIV' as TableName) as PlaceHolder    
 --               LEFT join DiagnosesIV as dx on DocumentVersionId = @LastDiagnosisDocumentVersion and ISNULL(RecordDeleted, 'N') = 'N'    
    
 --   -----For DiagnosesV-----    
 --               select  PlaceHolder.TableName,    
 --                       DocumentVersionId,    
 --                       AxisV,    
 --                       CreatedBy,    
 --                       CreatedDate,    
 --                       ModifiedBy,    
 --                       ModifiedDate,    
 --                       RecordDeleted,    
 --                       DeletedDate,    
 --                       DeletedBy    
 --               from (select 'DiagnosesV' as TableName) as PlaceHolder    
 --               LEFT join DiagnosesV as dx on DocumentVersionId = @LastDiagnosisDocumentVersion and ISNULL(RecordDeleted, 'N') = 'N'    
    
 -------For DiagnosesIAndII-----    
 --               select  'DiagnosesIAndII' as TableName,    
 --                       D.DocumentVersionId,    
 --                       D.DiagnosisId,    
 --                       D.Axis,    
 --                       D.DSMCode,    
 --                       D.DSMNumber,    
 --                       D.DiagnosisType,    
 --                       D.RuleOut,    
 --                       D.Billable,    
 --                       D.Severity,    
 --                       D.DSMVersion,    
 --                       D.DiagnosisOrder,    
 --                       D.Specifier,    
 --                       D.Remission,    
 --                       D.Source,    
 --                       D.RowIdentifier,    
 --                       D.CreatedBy,    
 --                       D.CreatedDate,    
 --                       D.ModifiedBy,    
 --                       D.ModifiedDate,    
 --                       D.RecordDeleted,    
 --                       D.DeletedDate,    
 --                       D.DeletedBy,    
 --                       DSM.DSMDescription,    
 --                       CASE D.RuleOut    
 --                         when 'Y' then 'R/O'    
 --                  else ''    
 --                       end as RuleOutText    
 --               from    DiagnosesIAndII D    
 --               inner join DiagnosisDSMDescriptions DSM on DSM.DSMCode = D.DSMCode    
 --                                                          and DSM.DSMNumber = D.DSMNumber    
 --               where   DocumentVersionId = @LastDiagnosisDocumentVersion    
 --                       and ISNULL(RecordDeleted, 'N') = 'N'    
    
 -- --DiagnosesIIICodes    
 --               select  PlaceHolder.TableName, -- 'DiagnosesIIICodes' as TableName,    
 --                       DIIICod.DiagnosesIIICodeId,    
 --                       DIIICod.DocumentVersionId,    
 --                       DIIICod.ICDCode,    
 --                       DICD.ICDDescription,    
 --                       DIIICod.Billable,    
 --                       DIIICod.CreatedBy,    
 --                       DIIICod.CreatedDate,    
 --                       DIIICod.ModifiedBy,    
 --                       DIIICod.ModifiedDate,    
 --                       DIIICod.RecordDeleted,    
 --                       DIIICod.DeletedDate,    
 --                       DIIICod.DeletedBy    
 --               -- Below From Statement modified By pralyankar On July 21, 2012 for 'Placeholder' implementation    
 --               from  (select 'DiagnosesIIICodes' as TableName, @LastDiagnosisDocumentVersion as DocumentVersionId) as PlaceHolder     
 --    Left Outer Join DiagnosesIIICodes as DIIICod On DIIICod.DocumentVersionId = PlaceHolder.DocumentVersionId    
 --    inner join DiagnosisICDCodes as DICD on DIIICod.ICDCode = DICD.ICDCode    
 --               where ISNULL(DIIICod.RecordDeleted, 'N') = 'N' -- AND (DIIICod.DocumentVersionId = @LastDiagnosisDocumentVersion)    
    
    
 -----DiagnosesMaxOrder    
 --               select top 1    
 --                       'DiagnosesIANDIIMaxOrder' as TableName,    
 --                       MAX(DiagnosisOrder) as DiagnosesMaxOrder,    
 --                       CreatedBy,    
 --                       ModifiedBy,    
 --                       CreatedDate,    
 --                       ModifiedDate,    
 --                       RecordDeleted,    
 --                       DeletedBy,    
 --                       DeletedDate    
 --               from    DiagnosesIAndII    
 --               where   DocumentVersionId = @LastDiagnosisDocumentVersion    
 --                       and ISNULL(RecordDeleted, 'N') = 'N'    
 --               group by CreatedBy,    
 --                       ModifiedBy,    
 --                       CreatedDate,    
 --                       ModifiedDate,    
 --                       RecordDeleted,    
 --                       DeletedBy,    
 --                       DeletedDate    
 --               order by DiagnosesMaxOrder desc    
    
    
  ---Table CustomDocumentAssessmentNeeds----    
   if(isnull(@TypeOfAssessment,'')<>'E')    
   BEGIN    
                select  Placeholder.TableName, -- 'CustomDocumentAssessmentNeeds' as TableName,    
                        ISNULL(AssessmentNeedId,-1) AS  AssessmentNeedId,   
                        CDA.DocumentVersionId,
                        '' as CreatedBy,    
                        GETDATE() as CreatedDate,    
                        '' as ModifiedBy,    
                        GETDATE() ModifiedDate,    
                        NeedName,    
                        NeedDescription,    
                        NeedStatus,    
                        RecordDeleted,    
                        DeletedDate,    
                        DeletedBy    
                from  (SELECT 'CustomDocumentAssessmentNeeds' AS TableName, isnull(@LatestSignedDocumentVersionID,-1) as DocumentVersionId) AS Placeholder      
     Left Outer Join CustomDocumentAssessmentNeeds As CDA On CDA.DocumentVersionId = Placeholder.DocumentVersionId-- @LatestSignedDocumentVersionID    
                where ISNULL(RecordDeleted, 'N') = 'N' -- and DocumentVersionId = @LatestSignedDocumentVersionID    
   END                             
    
                select  Placeholder.TableName, --'CustomDocumentMentalStatuses' as TableName,    
                        -1 as DocumentVersionId,    
                        '' as CreatedBy,    
                        GETDATE() as CreatedDate,    
                        '' as ModifiedBy,    
                        GETDATE() as ModifiedDate    
                from  (SELECT 'CustomDocumentMentalStatuses' AS TableName, -1 as DocumentVersionId) AS Placeholder --  systemconfigurations s    
     left outer join CustomDocumentMentalStatuses AS CCMS on CCMS.DocumentVersionId = Placeholder.DocumentVersionId --s.Databaseversion = -1    
    
 --TP initialization    
                if (    
                    @AssessmentTypeCheck != ''    
                    and @AssessmentTypeCheck = 'I'    
                   )     
                    begin    
    
                        exec csp_InitCustomDiagnosticAssessmentTreatmentPlan @ClientID,    
                            @StaffId    
                    end    
    
    
            end    
exec ssp_InitCustomDiagnosisStandardInitializationNew @ClientID, @StaffID, @CustomParameters    
--Checking For Errors    
    
    end try    
    
    begin catch    
        declare @Error varchar(8000)    
        set @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****'    
            + CONVERT(varchar(4000), ERROR_MESSAGE()) + '*****'    
            + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),    
                     'csp_InitCustomDiagnosticAssessment') + '*****'    
            + CONVERT(varchar, ERROR_LINE()) + '*****ERROR_SEVERITY='    
            + CONVERT(varchar, ERROR_SEVERITY()) + '*****ERROR_STATE='    
            + CONVERT(varchar, ERROR_STATE())    
        raiserror (@Error  /* Message text*/,    
     16  /*Severity*/,    
              1  /*State*/   )    
    end catch    
end    
    
    
GO


