
IF NOT EXISTS (SELECT * FROM  CustomConfigurations)
begin
	INSERT INTO [CustomConfigurations] ([MaximumNeeds],[MaximumObjectives],[MaximumInterventions],[MaximumInterventionProcedures],[TPDischargeCriteria],[AssessmentInitializeAllFields],[AssessmentInitializeStoredProc],[AssessmentCreateAuthorizations],[AssessmentProcedures],[CafasURL],[HRMAssessmentHealthAssesmentLabel],[ScreenAssessmentExpirationDays],[DLAScale],[QITabEnableHealthMeasures],[QITabEnableDDMeasures],[ExternalServicesProgramType],[ExternalServicesInsurerId],[ExternalServicesResubmitYes],[ExternalServicesResubmitNo],[TxPlanDeliveryProcedureCodeId])VALUES(NULL,NULL,NULL,NULL,NULL,'N',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
end