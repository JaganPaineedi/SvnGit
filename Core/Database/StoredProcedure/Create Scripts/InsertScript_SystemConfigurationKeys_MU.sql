
IF NOT EXISTS(select 1 from SystemConfigurationKeys where [Key] = 'ShowSummaryOfCareAuthorOfDocument')
BEGIN
INSERT INTO SystemConfigurationKeys (CreateDate,
									ModifiedDate,
									RecordDeleted,
									DeletedDate,
									DeletedBy,
									[Key],
									Value,
									[Description],
									AcceptedValues,
									ShowKeyForViewingAndEditing,
									Modules,
									Screens,
									AllowEdit)
								VALUES(GETDATE(),
										GETDATE(),
										null,
										null,
										null,
										'ShowSummaryOfCareAuthorOfDocument',
										'Y',
										'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary report is one of the 9 menu set measures which is mandatory to be fulfilled.  The objective as stated is to “The EP who transitions their patient to another setting of care or provider of care or refers their patient to another provider of care should provide summary care record for each transition of care or referral”. In SmartCare, we have added function with icon named as ‘SC’ and this icon is part of the tool bar on the document “Summary of Care” screen. On the click of the icon, the application creates PDF/XML Report.    The Summary of Care PDF/XML has 14 sections as part of the report. The section name ‘Client Information’   in the key is also one of them and this key configuration helps in either showing or hiding this section in the report.            IMPACT: If client does not have related data for the section, the system currently displays “No Information Available” on the generated PDF.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of ‘Client Information’ section.  N – Disables this section and will be not part of the generated PDF/XML report.',
										'Y,N',
										'N',
										'',
										'',
										'Y')
END
ELSE
BEGIN
UPDATE SystemConfigurationKeys
		SET Value = 'Y'
		WHERE [Key] = 'ShowSummaryOfCareAuthorOfDocument'
END


IF NOT EXISTS(select 1 from SystemConfigurationKeys where [Key] = 'ShowTransitionCareFunctionalStatus')
BEGIN
INSERT INTO SystemConfigurationKeys (CreateDate,
									ModifiedDate,
									RecordDeleted,
									DeletedDate,
									DeletedBy,
									[Key],
									Value,
									[Description],
									AcceptedValues,
									ShowKeyForViewingAndEditing,
									Modules,
									Screens,
									AllowEdit)
								VALUES(GETDATE(),
										GETDATE(),
										null,
										null,
										null,
										'ShowTransitionCareFunctionalStatus',
										'Y',
										'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary report is one of the 9 menu set measures which is mandatory to be fulfilled.  The objective as stated is to “The EP who transitions their patient to another setting of care or provider of care or refers their patient to another provider of care should provide summary care record for each transition of care or referral”. In SmartCare, we have added function with icon named as ‘SC’ and this icon is part of the tool bar on the document “Summary of Care” screen. On the click of the icon, the application creates PDF/XML Report.    The Summary of Care PDF/XML has 14 sections as part of the report. The section name ‘Client Information’   in the key is also one of them and this key configuration helps in either showing or hiding this section in the report.            IMPACT: If client does not have related data for the section, the system currently displays “No Information Available” on the generated PDF.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of ‘Client Information’ section.  N – Disables this section and will be not part of the generated PDF/XML report.',
										'Y,N',
										'N',
										'',
										'',
										'Y')
END
ELSE
BEGIN
UPDATE SystemConfigurationKeys
		SET Value = 'Y'
		WHERE [Key] = 'ShowTransitionCareFunctionalStatus'
END


IF NOT EXISTS(select 1 from SystemConfigurationKeys where [Key] = 'ShowTransitionCareCognitiveStatus')
BEGIN
INSERT INTO SystemConfigurationKeys (CreateDate,
									ModifiedDate,
									RecordDeleted,
									DeletedDate,
									DeletedBy,
									[Key],
									Value,
									[Description],
									AcceptedValues,
									ShowKeyForViewingAndEditing,
									Modules,
									Screens,
									AllowEdit)
								VALUES(GETDATE(),
										GETDATE(),
										null,
										null,
										null,
										'ShowTransitionCareCognitiveStatus',
										'Y',
										'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary report is one of the 9 menu set measures which is mandatory to be fulfilled.  The objective as stated is to “The EP who transitions their patient to another setting of care or provider of care or refers their patient to another provider of care should provide summary care record for each transition of care or referral”. In SmartCare, we have added function with icon named as ‘SC’ and this icon is part of the tool bar on the document “Summary of Care” screen. On the click of the icon, the application creates PDF/XML Report.    The Summary of Care PDF/XML has 14 sections as part of the report. The section name ‘Client Information’   in the key is also one of them and this key configuration helps in either showing or hiding this section in the report.            IMPACT: If client does not have related data for the section, the system currently displays “No Information Available” on the generated PDF.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of ‘Client Information’ section.  N – Disables this section and will be not part of the generated PDF/XML report.',
										'Y,N',
										'N',
										'',
										'',
										'Y')
END
ELSE
BEGIN
UPDATE SystemConfigurationKeys
		SET Value = 'Y'
		WHERE [Key] = 'ShowTransitionCareCognitiveStatus'
END


IF NOT EXISTS(select 1 from SystemConfigurationKeys where [Key] = 'ShowTransitionCareAssessmentandPlanTreatment')
BEGIN
INSERT INTO SystemConfigurationKeys (CreateDate,
									ModifiedDate,
									RecordDeleted,
									DeletedDate,
									DeletedBy,
									[Key],
									Value,
									[Description],
									AcceptedValues,
									ShowKeyForViewingAndEditing,
									Modules,
									Screens,
									AllowEdit)
								VALUES(GETDATE(),
										GETDATE(),
										null,
										null,
										null,
										'ShowTransitionCareAssessmentandPlanTreatment',
										'Y',
										'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary report is one of the 9 menu set measures which is mandatory to be fulfilled.  The objective as stated is to “The EP who transitions their patient to another setting of care or provider of care or refers their patient to another provider of care should provide summary care record for each transition of care or referral”. In SmartCare, we have added function with icon named as ‘SC’ and this icon is part of the tool bar on the document “Summary of Care” screen. On the click of the icon, the application creates PDF/XML Report.    The Summary of Care PDF/XML has 14 sections as part of the report. The section name ‘Client Information’   in the key is also one of them and this key configuration helps in either showing or hiding this section in the report.            IMPACT: If client does not have related data for the section, the system currently displays “No Information Available” on the generated PDF.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of ‘Client Information’ section.  N – Disables this section and will be not part of the generated PDF/XML report.',
										'Y,N',
										'N',
										'',
										'',
										'Y')
END
ELSE
BEGIN
UPDATE SystemConfigurationKeys
		SET Value = 'Y'
		WHERE [Key] = 'ShowTransitionCareAssessmentandPlanTreatment'
END


IF NOT EXISTS(select 1 from SystemConfigurationKeys where [Key] = 'ShowTransitionCareOutpatientVisitInfo')
BEGIN
INSERT INTO SystemConfigurationKeys (CreateDate,
									ModifiedDate,
									RecordDeleted,
									DeletedDate,
									DeletedBy,
									[Key],
									Value,
									[Description],
									AcceptedValues,
									ShowKeyForViewingAndEditing,
									Modules,
									Screens,
									AllowEdit)
								VALUES(GETDATE(),
										GETDATE(),
										null,
										null,
										null,
										'ShowTransitionCareOutpatientVisitInfo',
										'Y',
										'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary report is one of the 9 menu set measures which is mandatory to be fulfilled.  The objective as stated is to “The EP who transitions their patient to another setting of care or provider of care or refers their patient to another provider of care should provide summary care record for each transition of care or referral”. In SmartCare, we have added function with icon named as ‘SC’ and this icon is part of the tool bar on the document “Summary of Care” screen. On the click of the icon, the application creates PDF/XML Report.    The Summary of Care PDF/XML has 14 sections as part of the report. The section name ‘Client Information’   in the key is also one of them and this key configuration helps in either showing or hiding this section in the report.            IMPACT: If client does not have related data for the section, the system currently displays “No Information Available” on the generated PDF.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of ‘Client Information’ section.  N – Disables this section and will be not part of the generated PDF/XML report.',
										'Y,N',
										'N',
										'',
										'',
										'Y')
END
ELSE
BEGIN
UPDATE SystemConfigurationKeys
		SET Value = 'Y'
		WHERE [Key] = 'ShowTransitionCareOutpatientVisitInfo'
END


IF NOT EXISTS(select 1 from SystemConfigurationKeys where [Key] = 'ShowTransitionInpatientVisitInfo')
BEGIN
INSERT INTO SystemConfigurationKeys (CreateDate,
									ModifiedDate,
									RecordDeleted,
									DeletedDate,
									DeletedBy,
									[Key],
									Value,
									[Description],
									AcceptedValues,
									ShowKeyForViewingAndEditing,
									Modules,
									Screens,
									AllowEdit)
								VALUES(GETDATE(),
										GETDATE(),
										null,
										null,
										null,
										'ShowTransitionInpatientVisitInfo',
										'Y',
										'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary report is one of the 9 menu set measures which is mandatory to be fulfilled.  The objective as stated is to “The EP who transitions their patient to another setting of care or provider of care or refers their patient to another provider of care should provide summary care record for each transition of care or referral”. In SmartCare, we have added function with icon named as ‘SC’ and this icon is part of the tool bar on the document “Summary of Care” screen. On the click of the icon, the application creates PDF/XML Report.    The Summary of Care PDF/XML has 14 sections as part of the report. The section name ‘Client Information’   in the key is also one of them and this key configuration helps in either showing or hiding this section in the report.            IMPACT: If client does not have related data for the section, the system currently displays “No Information Available” on the generated PDF.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of ‘Client Information’ section.  N – Disables this section and will be not part of the generated PDF/XML report.',
										'Y,N',
										'N',
										'',
										'',
										'Y')
END
ELSE
BEGIN
UPDATE SystemConfigurationKeys
		SET Value = 'Y'
		WHERE [Key] = 'ShowTransitionInpatientVisitInfo'
END


IF NOT EXISTS(select 1 from SystemConfigurationKeys where [Key] = 'ShowTransitionCareUDI')
BEGIN
INSERT INTO SystemConfigurationKeys (CreateDate,
									ModifiedDate,
									RecordDeleted,
									DeletedDate,
									DeletedBy,
									[Key],
									Value,
									[Description],
									AcceptedValues,
									ShowKeyForViewingAndEditing,
									Modules,
									Screens,
									AllowEdit)
								VALUES(GETDATE(),
										GETDATE(),
										null,
										null,
										null,
										'ShowTransitionCareUDI',
										'Y',
										'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary report is one of the 9 menu set measures which is mandatory to be fulfilled.  The objective as stated is to “The EP who transitions their patient to another setting of care or provider of care or refers their patient to another provider of care should provide summary care record for each transition of care or referral”. In SmartCare, we have added function with icon named as ‘SC’ and this icon is part of the tool bar on the document “Summary of Care” screen. On the click of the icon, the application creates PDF/XML Report.    The Summary of Care PDF/XML has 14 sections as part of the report. The section name ‘Client Information’   in the key is also one of them and this key configuration helps in either showing or hiding this section in the report.            IMPACT: If client does not have related data for the section, the system currently displays “No Information Available” on the generated PDF.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of ‘Client Information’ section.  N – Disables this section and will be not part of the generated PDF/XML report.',
										'Y,N',
										'N',
										'',
										'',
										'Y')
END
ELSE
BEGIN
UPDATE SystemConfigurationKeys
		SET Value = 'Y'
		WHERE [Key] = 'ShowTransitionCareUDI'
END