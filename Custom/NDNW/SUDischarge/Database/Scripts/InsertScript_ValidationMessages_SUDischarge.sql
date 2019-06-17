--Validation scripts for Task #930 in Valley - Customizations (SU Discharge Document)
/******************************************************************************** 

-- *****History****  
/*       Date           Author				Purpose                   */
/*       09/MAR/2015	Akwinass			Created                   */
-- 23-March-2015 SuryaBalan Copied from Valley New Directions for Task #8 New Directions-Customization
*********************************************************************************/
DELETE
FROM DocumentValidations
WHERE DocumentCodeId = 46221

INSERT [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	N'Y'
	,46221
	,NULL
	,'Discharge'
	,1
	,N'CustomDocumentSUDischarges'
	,N'DateOfDischarge'
	,N'FROM CustomDocumentSUDischarges WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(DateOfDischarge,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Discharge - Discharge - Date of Discharge is required.'
	,CAST(1 AS DECIMAL(18, 0))
	,N'Discharge - Discharge - Date of Discharge is required.'
	)
	,(
	N'Y'
	,46221
	,NULL
	,'Discharge'
	,1
	,N'CustomDocumentSUDischarges'
	,N'DischargeReason'
	,N'FROM CustomDocumentSUDischarges WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(DischargeReason,0) <= 0  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Discharge - Discharge - Discharge Reason is required.'
	,CAST(2 AS DECIMAL(18, 0))
	,N'Discharge - Discharge - Discharge Reason is required.'
	)
	,(
	N'Y'
	,46221
	,NULL
	,'Discharge Frequency'
	,2
	,N'CustomDocumentSUDischarges'
	,N'SUDischargeFrequencyOne'
	,N'FROM CustomDocumentSUDischarges WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(SUAdmissionDrugNameOne,0) > 0 AND ISNULL(SUAdmissionFrequencyOne,0) > 0 AND ISNULL(SUDischargeFrequencyOne,0) <= 0 and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Substance Use - Discharge Frequency drop down is required.'
	,CAST(3 AS DECIMAL(18, 0))
	,N'Substance Use - Discharge Frequency drop down is required.'
	)
	,(
	N'Y'
	,46221
	,NULL
	,'Discharge Frequency'
	,2
	,N'CustomDocumentSUDischarges'
	,N'SUDischargeFrequencyOne'
	,N'FROM CustomDocumentSUDischarges WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(SUAdmissionDrugNameTwo,0) > 0 AND ISNULL(SUAdmissionFrequencyTwo,0) > 0 AND ISNULL(SUDischargeFrequencyTwo,0) <= 0 and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Substance Use - Discharge Frequency drop down is required.'
	,CAST(3 AS DECIMAL(18, 0))
	,N'Substance Use - Discharge Frequency drop down is required.'
	)
	,(
	N'Y'
	,46221
	,NULL
	,'Discharge Frequency'
	,2
	,N'CustomDocumentSUDischarges'
	,N'SUDischargeFrequencyOne'
	,N'FROM CustomDocumentSUDischarges WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(SUAdmissionDrugNameThree,0) > 0 AND ISNULL(SUAdmissionFrequencyThree,0) > 0 AND ISNULL(SUDischargeFrequencyThree,0) <= 0 and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Substance Use - Discharge Frequency drop down is required.'
	,CAST(3 AS DECIMAL(18, 0))
	,N'Substance Use - Discharge Frequency drop down is required.'
	)
	,(
	N'Y'
	,46221
	,NULL
	,'Discharge Frequency'
	,2
	,N'CustomDocumentSUDischarges'
	,N'SUDischargeTobaccoUse'
	,N'FROM CustomDocumentSUDischarges WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(SUDischargeTobaccoUse,0) <= 0 and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Tobacco Use - Discharge Frequency drop down is required.'
	,CAST(4 AS DECIMAL(18, 0))
	,N'Tobacco Use - Discharge Frequency drop down is required.'
	)
	,(
	N'Y'
	,46221
	,NULL
	,'Discharge Information'
	,3
	,N'CustomDocumentSUDischarges'
	,N'LivingArrangement'
	,N'FROM CustomDocumentSUDischarges WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(LivingArrangement,0) <= 0 and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Demographics Information - Current Living Arrangement is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'Demographics Information - Current Living Arrangement is required.'
	)
	,(
	N'Y'
	,46221
	,NULL
	,'Discharge Information'
	,3
	,N'CustomDocumentSUDischarges'
	,N'EmploymentStatus'
	,N'FROM CustomDocumentSUDischarges WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(EmploymentStatus,0) <= 0 and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Demographics Information - Employment Status is required.'
	,CAST(6 AS DECIMAL(18, 0))
	,N'Demographics Information - Employment Status is required.'
	)
	,(
	N'Y'
	,46221
	,NULL
	,'Discharge Information'
	,3
	,N'CustomDocumentSUDischarges'
	,N'Education'
	,N'FROM CustomDocumentSUDischarges WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Education,0) <= 0 and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Demographics Information - Education is required.'
	,CAST(7 AS DECIMAL(18, 0))
	,N'Demographics Information - Education is required.'
	)
	,(
	N'Y'
	,46221
	,NULL
	,'Discharge Information'
	,3
	,N'CustomDocumentSUDischarges'
	,N'NumberOfArrests'
	,N'FROM CustomDocumentSUDischarges WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(NumberOfArrests,-1) = -1 and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Legal Information - # of arrests in past 30 days is required'
	,CAST(8 AS DECIMAL(18, 0))
	,N'Legal Information - # of arrests in past 30 days is required'
	)
	,(
	N'Y'
	,46221
	,NULL
	,'Discharge Information'
	,3
	,N'CustomDocumentSUDischarges'
	,N'NumberOfSelfHelpGroupsAttendedLast30Days'
	,N'FROM CustomDocumentSUDischarges WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(NumberOfSelfHelpGroupsAttendedLast30Days,-1) = -1 and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Discharge Information – Legal Information - Number of self-help groups attended in the last 30 days is required'
	,CAST(10 AS DECIMAL(18, 0))
	,N'Social Support - Number of self-help groups attended in the last 30 days is required'
	)
	,(
	N'Y'
	,46221
	,NULL
	,'Discharge Information'
	,3
	,N'CustomDocumentSUDischarges'
	,N'LastFaceToFaceDate'
	,N'FROM CustomDocumentSUDischarges WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(LastFaceToFaceDate,'''') = '''' and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Discharge Information – Legal Information – Last face to face contact is required'
	,CAST(11 AS DECIMAL(18, 0))
	,N'Other Information – Last face to face contact is required'
	)
	,(
	N'Y'
	,46221
	,NULL
	,'Discharge Information'
	,3
	,N'CustomDocumentSUDischarges'
	,N'SocialSupport'
	,N'FROM CustomDocumentSUDischarges WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(SocialSupport,0) <= 0 and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Participation in Social Support - Participation in Social Support is required.'
	,CAST(9 AS DECIMAL(18, 0))
	,N'Social Support - Participation in Social Support is required.'
	)
	
	,(
	N'Y'
	,46221
	,NULL
	,'Substance Use'
	,4
	,N'CustomDocumentSUDischarges'
	,N'SocialSupport'
	,N'FROM CustomDocumentSUDischarges WHERE DocumentVersionId=@DocumentVersionId AND  (PreferredUsage1 is NULL AND DrugName1 is NOT NULL)  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N' Substance Use - Preferred Usage is required'
	,CAST(12 AS DECIMAL(18, 0))
	,N'Substance Use - Preferred Usage is required'
	)
	
	,(
	N'Y'
	,46221
	,NULL
	,'Substance Use'
	,4
	,N'CustomDocumentSUDischarges'
	,N'DrugName1'
	,N'FROM CustomDocumentSUDischarges WHERE DocumentVersionId=@DocumentVersionId AND  (DrugName1 is NULL AND DrugName2 is NULL AND DrugName3 is NULL) and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Substance Use - Detailed Drug Use is required'
	,CAST(13 AS DECIMAL(18, 0))
	,N'Substance Use - Detailed Drug Use is required'
	)
	
	,(
	N'Y'
	,46221
	,NULL
	,'Substance Use'
	,4
	,N'CustomDocumentSUDischarges'
	,N'Severity1'
	,N'FROM CustomDocumentSUDischarges WHERE DocumentVersionId=@DocumentVersionId AND  (Severity1 is NULL  AND DrugName1 is NOT NULL) and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Substance Use - Severity is required'
	,CAST(14 AS DECIMAL(18, 0))
	,N'Substance Use - Severity is required'
	)
	
	,(
	N'Y'
	,46221
	,NULL
	,'Substance Use'
	,4
	,N'CustomDocumentSUDischarges'
	,N'Frequency1'
	,N'FROM CustomDocumentSUDischarges WHERE DocumentVersionId=@DocumentVersionId AND  (Frequency1 is  NULL AND DrugName1 is NOT NULL) and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Substance Use - Frequency is required'
	,CAST(15 AS DECIMAL(18, 0))
	,N'Substance Use - Frequency is required'
	)
	
	,(
	N'Y'
	,46221
	,NULL
	,'Substance Use'
	,4
	,N'CustomDocumentSUDischarges'
	,N'Route1'
	,N'FROM CustomDocumentSUDischarges WHERE DocumentVersionId=@DocumentVersionId AND  (Route1 is NULL AND DrugName1 is NOT NULL) and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Substance Use - Method is required'
	,CAST(16 AS DECIMAL(18, 0))
	,N'Substance Use - Method is required'
	)
	,(
	N'Y'
	,46221
	,NULL
	,'Substance Use'
	,4
	,N'CustomDocumentSUDischarges'
	,N'AgeOfFirstUseText1'
	,N'FROM CustomDocumentSUDischarges WHERE DocumentVersionId=@DocumentVersionId AND  (AgeOfFirstUseText1 is  NULL AND DrugName1 is NOT NULL) and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Substance Use - Age of First Use is required'
	,CAST(17 AS DECIMAL(18, 0))
	,N'Substance Use - Age of First Use is required'
	)
	
	,(
	N'Y'
	,46221
	,NULL
	,'Substance Use'
	,4
	,N'CustomDocumentSUDischarges'
	,N'PreferredUsage2'
	,N'FROM CustomDocumentSUDischarges WHERE DocumentVersionId=@DocumentVersionId AND  (PreferredUsage2 is NULL AND DrugName2 is NOT NULL)  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Substance Use - Preferred Usage is required'
	,CAST(18 AS DECIMAL(18, 0))
	,N'Substance Use - Preferred Usage is required'
	)
	
	,(
	N'Y'
	,46221
	,NULL
	,'Substance Use'
	,4
	,N'CustomDocumentSUDischarges'
	,N'Severity2'
	,N'FROM CustomDocumentSUDischarges WHERE DocumentVersionId=@DocumentVersionId AND  (Severity2 is NULL  AND DrugName2 is NOT NULL) and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Substance Use- Severity is required'
	,CAST(19 AS DECIMAL(18, 0))
	,N'Substance Use - Severity is required'
	)
	
	,(
	N'Y'
	,46221
	,NULL
	,'Substance Use'
	,4
	,N'CustomDocumentSUDischarges'
	,N'Frequency2'
	,N'FROM CustomDocumentSUDischarges WHERE DocumentVersionId=@DocumentVersionId AND  (Frequency2 is  NULL AND DrugName2 is NOT NULL) and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Substance Use - Substance Use- Frequency is required'
	,CAST(20 AS DECIMAL(18, 0))
	,N'Substance Use - Frequency is required'
	)
	
	,(
	N'Y'
	,46221
	,NULL
	,'Substance Use'
	,4
	,N'CustomDocumentSUDischarges'
	,N'Route2'
	,N'FROM CustomDocumentSUDischarges WHERE DocumentVersionId=@DocumentVersionId AND  (Route2 is NULL AND DrugName2 is NOT NULL) and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Substance Use - Method is required'
	,CAST(21 AS DECIMAL(18, 0))
	,N'Substance Use - Method is required'
	)
	
	,(
	N'Y'
	,46221
	,NULL
	,'Substance Use'
	,4
	,N'CustomDocumentSUDischarges'
	,N'AgeOfFirstUseText2'
	,N'FROM CustomDocumentSUDischarges WHERE DocumentVersionId=@DocumentVersionId AND  (AgeOfFirstUseText2 is  NULL AND DrugName2 is NOT NULL) and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Substance Use - Age of First Use is required'
	,CAST(22 AS DECIMAL(18, 0))
	,N'Substance Use - Age of First Use is required'
	)
	
	,(
	N'Y'
	,46221
	,NULL
	,'Substance Use'
	,4
	,N'CustomDocumentSUDischarges'
	,N'PreferredUsage3'
	,N'FROM CustomDocumentSUDischarges WHERE DocumentVersionId=@DocumentVersionId AND  (PreferredUsage3 is NULL AND DrugName3 is NOT NULL)  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Substance Use - Preferred Usage is required'
	,CAST(23 AS DECIMAL(18, 0))
	,N'Substance Use - Preferred Usage is required'
	)
	,(
	N'Y'
	,46221
	,NULL
	,'Substance Use'
	,4
	,N'CustomDocumentSUDischarges'
	,N'Severity1'
	,N'FROM CustomDocumentSUDischarges WHERE DocumentVersionId=@DocumentVersionId AND  (Severity3 is NULL  AND DrugName3 is NOT NULL) and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Substance Use - Severity is required'
	,CAST(24 AS DECIMAL(18, 0))
	,N'Substance Use - Severity is required'
	)
	
	,(
	N'Y'
	,46221
	,NULL
	,'Substance Use'
	,4
	,N'CustomDocumentSUDischarges'
	,N'Frequency1'
	,N'FROM CustomDocumentSUDischarges WHERE DocumentVersionId=@DocumentVersionId AND  (Frequency3 is  NULL AND DrugName3 is NOT NULL) and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Substance Use - Frequency is required'
	,CAST(25 AS DECIMAL(18, 0))
	,N'Substance Use - Frequency is required'
	)
	
	,(
	N'Y'
	,46221
	,NULL
	,'Substance Use'
	,4
	,N'CustomDocumentSUDischarges'
	,N'Route3'
	,N'FROM CustomDocumentSUDischarges WHERE DocumentVersionId=@DocumentVersionId AND  (Route3 is NULL AND DrugName3 is NOT NULL) and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Substance Use-Method is required'
	,CAST(26 AS DECIMAL(18, 0))
	,N'Substance Use -Method is required'
	)
	,(
	N'Y'
	,46221
	,NULL
	,'Substance Use'
	,4
	,N'CustomDocumentSUDischarges'
	,N'AgeOfFirstUseText3'
	,N'FROM CustomDocumentSUDischarges WHERE DocumentVersionId=@DocumentVersionId AND  (AgeOfFirstUseText3 is  NULL AND DrugName3 is NOT NULL) and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Substance Use-Age of First Use is required'
	,CAST(27 AS DECIMAL(18, 0))
	,N'Substance Use - Age of First Use is required'
	)