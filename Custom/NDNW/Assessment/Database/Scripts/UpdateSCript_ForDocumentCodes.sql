If Exists(Select * from DocumentCodes Where DocumentCodeId=10018 And DocumentName='Assessment')
Begin
		Update DocumentCodes Set TableList='CustomHRMAssessments,CustomSubstanceUseAssessments,CustomSubstanceUseHistory2,CustomHRMAssessmentLevelOfCareOptions,CustomOtherRiskFactors,CustomHRMAssessmentSupports2,CustomMentalStatuses2,CustomDocumentCRAFFTs,CustomDispositions,CustomServiceDispositions,CustomProviderServices,CustomASAMPlacements,CustomDocumentAssessmentSubstanceUses,CustomHRMAssessmentMedications,DocumentFamilyHistory,CustomDocumentSafetyCrisisPlans,CustomSupportContacts,CustomSafetyCrisisPlanReviews,CustomCrisisPlanMedicalProviders,CustomCrisisPlanNetworkProviders,CustomDocumentDLA20s,CustomDailyLivingActivityScores,CustomYouthDLAScores,DocumentDiagnosisCodes,DocumentDiagnosis,DocumentDiagnosisFactors,CarePlanNeeds,CarePlanDomains,CarePlanDomainNeeds,CustomDocumentGambling'
		Where DocumentCodeId=10018 And DocumentName='Assessment'
End
