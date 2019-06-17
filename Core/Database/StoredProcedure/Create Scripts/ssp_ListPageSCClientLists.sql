/****** Object:  StoredProcedure [dbo].[ssp_ListPageSCClientLists]    Script Date: 11/11/2014 08:37:14 ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_ListPageSCClientLists]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [dbo].[ssp_ListPageSCClientLists]
GO


/****** Object:  StoredProcedure [dbo].[ssp_ListPageSCClientLists]    Script Date: 11/11/2014 08:37:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

        
CREATE PROCEDURE [dbo].[ssp_ListPageSCClientLists] @SessionId VARCHAR(30)
	,@InstanceId INT
	,@PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@StaffId INT
	,@AgeFrom INT
	,@AgeTo INT
	,@Sex VARCHAR(20)
	,@Race INT
	,@ProgramId INT
	,@ClinicianId INT
	,@SeenOrNotSeen VARCHAR(20)
	,@SeenOrNotSeenInDays INT
	,@HospitalizedOrNotHospitalized VARCHAR(20)
	,@HospitalizedOrNotHospitalizedInDays INT
	,@LOFCategory INT
	,@LOFMinimumValue INT
	,@LOFMaximumValue INT
	,@DiagnosisCondition1 CHAR(1)
	,@DiagnosisCode1 VARCHAR(20)
	,@DiagnosisCategoryCondition1 CHAR(1)
	,@DiagnosisCategory1 INT
	,@DiagnosisCondition2 CHAR
	,@DiagnosisCode2 VARCHAR(20)
	,@DiagnosisCategoryCondition2 CHAR(1)
	,@DiagnosisCategory2 INT
	,@HealthDataSubTemplateId1 INT
	,@HealthDataAttribute1 INT
	,@HealthDataAttributeMinimumValue1 INT
	,@HealthDataAttributeMaximumValue1 INT
	,@HealthDataTemplateId2 INT
	,@HealthDataSubTemplateId2 INT
	,@HealthDataAttributeMinimumValue2 INT
	,@HealthDataAttributeMaximumValue2 INT
	,@WaitingForLabResults VARCHAR(20)
	,@MedicationCondition CHAR(1)
	,@MedicationNameId INT
	,@MedicationCategoryCondition CHAR(1)
	,@MedicationCategory INT
	,@PrescriberId INT
	,@AllergyCondition CHAR(1)
	,@AllergenConceptId INT
	,@NoLabsForHealthDataCategoryId INT
	,@NoLabsForDays INT
	,@OtherFilter INT
	,@RowSelectionList VARCHAR(MAX)
	,@RefreshData INT = 0
	,@HealthDataAttribute2 INT
	,@HealthDataTemplateId3 INT
	,@HealthDataSubTemplateId3 INT
	,@HealthDataAttribute3 INT
	,@HealthDataAttributeMinimumValue3 INT
	,@HealthDataAttributeMaximumValue3 INT
	,@ReminderPreference INT
	,@FromDate DATETIME
	,@ToDate DATETIME
	,@Ethnicity INT -- Added 10/22/2014          
	,@PreferredLanguage INT -- Added 10/22/2014          
	/********************************************************************************                                                            
-- Stored Procedure: dbo.ssp_ListPageSCClientLists                                                           
--                                                            
-- Copyright: Streamline Healthcate Solutions                                                            
--                                                            
-- Purpose: used by ClientLists list page                                                            
--                                                            
-- Updates:                                                                                                                   
-- Date         Author               Purpose                                                            
-- 07.21.2011   Damanpreet           Created.                 
-- 08.20.2011   SFarber              Fixed various issues.          
-- 08.24.2011   Rohit Katoch         Change ReminderDate  format as "MM/DD/YYY"  task#1022 in Kalamazoo.          
-- 05.24.2012 Pralyankar			 Written Dynamic query for improving performance of a particular query.          
-- 05.29.2012   Pralyankar/Rakesh    W.r.f to task 1355 in Kalamazoo bugs for supporting ALl on Page selection           
-- June 15, 2012 Kneale              Added check for no filters used, fixed sort column names and added columns names for @columns          
-- Feb 11 2013 Swapan Mohan			Removed * from Select queries where exists checks are used to optimization purpose. Task #48 Interact Bugs/Features.          
-- Feb 19 2013 AmitSr				taken latest sp from kalamazoo production server and merge swapan changes.          
-- 07.JAN.2014 Revathi				what:Added join with staffclients table to display associated clients for login staff          
									why:Engineering Improvement Initiatives- NBL(I) task #77 My office List Pages should always have StaffID as an input parameter           
-- 01 Oct 2014	Pradeep.A			Added new Search criteria based on Vitals and Lab Filters.          
-- 08 Oct 2014	Pradeep.A			Added new parameter ReminderPreference.          
-- 14 Oct 2014	Pradeep.A			Added nee parameters FromDate,ToDate          
-- 22 Oct 2014	NJain				Added filter parameters @Ethnicity & @PreferredLanguage          
-- 30 Oct 2014	NJain				Added new fields for Diagnosis, Diagnosis Date, Medication, Medication Date, Allergy, Allergy Date, Ethnicity, Health Data Element, Health Data Value, Health Data Date, Communication Preference to the List Page.          
--									Why : Meaningful Use task# 64          
-- Nov 03 2014	Pradeep.A			Added client Filtering against the new DocumentDiagnosisCodes table.          
-- 11/4/2014	NJain				Added time to all date fields in the output          
-- 11/5/2014	NJain				Added Diagnosis Description fields    
-- 02/Sep/2015	Gautam				Change the code to Support for ICD10 from ICD9,Why: Diagnosis Changes (ICD10): #8 Patient List/Reminders    
-- 21-DEC-2015  Basudev Sahu		Modified For Task #609 Network180 Customization to Get Organisation  As ClientName
-- 20/06/2016	Ravichandra			Removed the physical table ListPageSCClientLists from SP
--									Why:Task #108, Engineering Improvement Initiatives- NBL(I)	
--									108 - Do NOT use list page tables for remaining list pages (refer #107)	
*****************************************************************************************************/
AS
BEGIN
BEGIN TRY
DECLARE @FiltersUsed INT = 0;

SELECT @FromDate = ISNULL(@FromDate, '1/1/1910')

SELECT @ToDate = ISNULL(@ToDate, '12/31/2199')

DECLARE @Time TIME

SELECT @TIME = CAST(@ToDate AS TIME)

IF @Time = '00:00:00.0000000'
	SET @ToDate = DATEADD(minute, 1439, @ToDate)

CREATE TABLE #ResultSet (
			RowId INT IDENTITY(1, 1)
			,ClientId INT
			,ClientName VARCHAR(100)
			,ClientAge INT
			,ClientSex VARCHAR(10)
			,ClientRace VARCHAR(250)
			,ClientReminderId INT
			,ReminderDate DATETIME
			,PrimaryDiagnosis VARCHAR(300)
			,PrimaryDiagnosisDescription VARCHAR(MAX)
			,DiagnosisDocumentId INT
			,IsSelected BIT
			,
			-- New Fields 10/29/2014          
			Diagnosis VARCHAR(MAX)
			,DiagnosisDescription VARCHAR(MAX)
			,DiagnosisDate DATETIME
			,Medication INT
			,MedicationDate DATETIME
			,Allergy INT
			,AllergyDate DATETIME
			,DateOfBirth DATETIME
			,Ethnicity INT
			,HealthDataElement INT
			,HealthDataValue VARCHAR(MAX)
			,HealthDataDate DATETIME
			,CommunicationPreference INT
			,CommunicationPreferenceDate DATETIME
			,DemographicsDate DATETIME
		)



SET @SortExpression = RTRIM(LTRIM(@SortExpression))

IF ISNULL(@SortExpression, '') = ''
	SET @SortExpression = 'ReminderDate desc'

                                            
DECLARE @Today DATE = GETDATE()
DECLARE @FilterDemographics CHAR(1) = 'N'
DECLARE @FilterDiagnosis CHAR(1) = 'N'
DECLARE @FilterLOGCategory CHAR(1) = 'N'
DECLARE @FilterMedication CHAR(1) = 'N'
DECLARE @FilterHealthData CHAR(1) = 'N'

CREATE TABLE #ClientFilters (
	 ClientId INT
	,FilterDemographics CHAR(1)
	,FilterDiagnosis CHAR(1)
	,FilterLOGCategory CHAR(1)
	,FilterMedication CHAR(1)
	,FilterHealthData CHAR(1)
	)

CREATE TABLE #Clients (ClientId INT)

CREATE TABLE #DiagnosisDocuments (
	ClientId INT
	,DocumentVersionId INT
	)

IF @AgeFrom > 0
	OR @AgeTo > 0
	OR ISNULL(@Sex, '') NOT IN (
		''
		,'0'
		)
	OR @Race > 0
	OR @ProgramId > 0
	OR @ClinicianId > 0
	OR @SeenOrNotSeenInDays > 0
	OR @HospitalizedOrNotHospitalizedInDays > 0
	OR @AllergenConceptId > 0
	OR @Ethnicity > 0 -- Added 10/22/2014          
	OR @PreferredLanguage > 0 -- Added 10/22/2014        
	OR @ReminderPreference > 0 -- Added 11/10/2014  
BEGIN
	SET @FiltersUsed = 1;
	SET @FilterDemographics = 'Y'

	INSERT INTO #ClientFilters (
		ClientId
		,FilterDemographics
		)
	SELECT c.ClientId
		,'Y'
	FROM Clients c
	WHERE c.Active = 'Y'
		AND ISNULL(c.RecordDeleted, 'N') = 'N'
		AND (
			(
				@AgeFrom <= 0
				AND @AgeTo <= 0
				)
			OR dbo.GetAge(c.DOB, GETDATE()) BETWEEN ISNULL(NULLIF(@AgeFrom, 0), 0)
				AND ISNULL(NULLIF(@AgeTo, 0), 1000)
			)
		AND (
			ISNULL(@Sex, '') IN (
				''
				,'0'
				)
			OR c.Sex = @Sex
			)
		AND (
			@Race <= 0
			OR EXISTS (
				SELECT 1
				FROM ClientRaces cr
				WHERE cr.ClientId = c.ClientId
					AND cr.RaceId = @Race
					AND ISNULL(cr.RecordDeleted, 'N') = 'N'
				)
			)
		AND (
			@Ethnicity <= 0
			OR c.HispanicOrigin = @Ethnicity
			) -- Added 10/22/2014          
		AND (
			@PreferredLanguage <= 0
			OR c.PrimaryLanguage = @PreferredLanguage
			) -- Added 10/22/2014          
		AND (
			@ReminderPreference <= 0
			OR c.ReminderPreference = @ReminderPreference
			)
		AND (
			@ProgramId <= 0
			OR EXISTS (
				SELECT 1
				FROM ClientPrograms cp
				WHERE cp.ClientId = c.ClientId
					AND cp.STATUS = 4
					AND cp.ProgramId = @ProgramId
					AND ISNULL(cp.RecordDeleted, 'N') = 'N'
				)
			)
		AND (
			@ClinicianId <= 0
			OR c.PrimaryClinicianId = @ClinicianId
			)
		AND (
			@SeenOrNotSeenInDays <= 0
			OR (
				@SeenOrNotSeen = 'Y'
				AND EXISTS (
					SELECT 1
					FROM Services s
					WHERE s.ClientId = c.ClientId
						AND s.STATUS IN (
							71
							,75
							)
						AND s.DateOfService >= DATEADD(dd, - @SeenOrNotSeenInDays, @Today)
						AND ISNULL(s.RecordDeleted, 'N') = 'N'
						AND (
							@FromDate IS NULL
							OR s.DateOfService >= @FromDate
							)
						AND (
							@ToDate IS NULL
							OR s.DateOfService <= @ToDate
							)
					)
				)
			OR (
				@SeenOrNotSeen = 'N'
				AND NOT EXISTS (
					SELECT 1
					FROM Services s
					WHERE s.ClientId = c.ClientId
						AND s.STATUS IN (
							71
							,75
							)
						AND s.DateOfService >= DATEADD(dd, - @SeenOrNotSeenInDays, @Today)
						AND ISNULL(s.RecordDeleted, 'N') = 'N'
						AND (
							@FromDate IS NULL
							OR s.DateOfService >= @FromDate
							)
						AND (
							@ToDate IS NULL
							OR s.DateOfService <= @ToDate
							)
					)
				)
			)
		AND (
			@HospitalizedOrNotHospitalizedInDays <= 0
			OR (
				@HospitalizedOrNotHospitalized = 'Y'
				AND EXISTS (
					SELECT 1
					FROM ClientHospitalizations ch
					WHERE ch.ClientId = c.ClientId
						AND ch.AdmitDate IS NOT NULL
						AND (
							DATEADD(dd, - @HospitalizedOrNotHospitalizedInDays, @Today) >= ch.AdmitDate
							OR DATEADD(dd, - @HospitalizedOrNotHospitalizedInDays, @Today) <= ISNULL(ch.DischargeDate, @Today)
							)
						AND ISNULL(ch.RecordDeleted, 'N') = 'N'
						AND (
							@FromDate IS NULL
							OR ch.AdmitDate >= @FromDate
							)
						AND (
							@ToDate IS NULL
							OR ch.AdmitDate <= @ToDate
							)
					)
				)
			OR (
				@HospitalizedOrNotHospitalized = 'N'
				AND NOT EXISTS (
					SELECT 1
					FROM ClientHospitalizations ch
					WHERE ch.ClientId = c.ClientId
						AND ch.AdmitDate IS NOT NULL
						AND (
							DATEADD(dd, - @HospitalizedOrNotHospitalizedInDays, @Today) >= ch.AdmitDate
							OR DATEADD(dd, - @HospitalizedOrNotHospitalizedInDays, @Today) <= ISNULL(ch.DischargeDate, @Today)
							)
						AND ISNULL(ch.RecordDeleted, 'N') = 'N'
						AND (
							@FromDate IS NULL
							OR ch.AdmitDate >= @FromDate
							)
						AND (
							@ToDate IS NULL
							OR ch.AdmitDate <= @ToDate
							)
					)
				)
			)
		AND (
			@AllergenConceptId <= 0
			OR (
				@AllergyCondition = 'E'
				AND EXISTS (
					SELECT 1
					FROM ClientAllergies ca
					WHERE ca.ClientId = c.ClientId
						AND ca.AllergenConceptId = @AllergenConceptId
						AND ca.Active = 'Y'
						AND ISNULL(ca.RecordDeleted, 'N') = 'N'
					)
				)
			OR (
				@AllergyCondition = 'N'
				AND NOT EXISTS (
					SELECT 1
					FROM ClientAllergies ca
					WHERE ca.ClientId = c.ClientId
						AND ca.AllergenConceptId = @AllergenConceptId
						AND ca.Active = 'Y'
						AND ISNULL(ca.RecordDeleted, 'N') = 'N'
					)
				)
			)
		AND (
			@ReminderPreference <= 0
			OR c.ReminderPreference = @ReminderPreference
			)
END

IF @LOFCategory > 0
	OR LEN(@DiagnosisCode1) > 0
	OR LEN(@DiagnosisCode2) > 0
	OR @DiagnosisCategory1 > 0
	OR @DiagnosisCategory2 > 0
BEGIN
	SET @FiltersUsed = 1;

	DECLARE @DiagnosisDSMCodes TABLE (
		DSMCode VARCHAR(10)
		,SearchType VARCHAR(20)
		)

	SET @FilterDiagnosis = 'Y'

	INSERT INTO #DiagnosisDocuments (
		ClientId
		,DocumentVersionId
		)
	SELECT c.ClientId
		,d.CurrentDocumentVersionId
	FROM Clients c
	INNER JOIN Documents d ON d.ClientId = c.ClientId
	WHERE c.Active = 'Y'
		AND d.STATUS = 22
		AND d.DocumentCodeId = 1601
		AND d.EffectiveDate < DATEADD(dd, 1, @Today)
		AND ISNULL(d.RecordDeleted, 'N') = 'N'
		AND (
			@FromDate IS NULL
			OR d.EffectiveDate >= @FromDate
			)
		AND (
			@ToDate IS NULL
			OR d.EffectiveDate <= @ToDate
			)
		AND NOT EXISTS (
			SELECT 1
			FROM Documents d2
			WHERE d2.ClientId = d.ClientId
				AND d2.STATUS = d.STATUS
				AND d2.DocumentCodeId = d.DocumentCodeId
				AND d2.EffectiveDate < DATEADD(dd, 1, @Today)
				AND ISNULL(d2.RecordDeleted, 'N') = 'N'
				AND d2.EffectiveDate > d.EffectiveDate
			)

	IF LEN(@DiagnosisCode1) > 0
		OR LEN(@DiagnosisCode2) > 0
		OR @DiagnosisCategory1 > 0
		OR @DiagnosisCategory2 > 0
	BEGIN
		INSERT INTO @DiagnosisDSMCodes (
			DSMCode
			,SearchType
			)
		SELECT dsm.ICD10Code
			,CASE dsm.ICD10Code
				WHEN @DiagnosisCode1
					THEN 'DxCode1'
				ELSE 'DxCode2'
				END
		FROM DiagnosisICD10Codes dsm
		WHERE dsm.ICD10Code IN (
				@DiagnosisCode1
				,@DiagnosisCode2
				)
		
		UNION
		
		SELECT dcc.DSMCode
			,CASE dcc.DiagnosisCategory
				WHEN @DiagnosisCategory1
					THEN 'DxCategory1'
				ELSE 'DxCategory2'
				END
		FROM DiagnosisCategoryCodes dcc
		WHERE dcc.DiagnosisCategory IN (
				@DiagnosisCategory1
				,@DiagnosisCategory2
				)
			AND ISNULL(dcc.RecordDeleted, 'N') = 'N'
			AND dcc.DSMCode IS NOT NULL
		
		--UNION
		
		--SELECT dsm.DSMCode
		--	,CASE dcc.DiagnosisCategory
		--		WHEN @DiagnosisCategory1
		--			THEN 'DxCategory1'
		--		ELSE 'DxCategory2'
		--		END
		--FROM DiagnosisCategoryCodes dcc
		--INNER JOIN DiagnosisDSMCodes dsm ON dsm.ICDCode = dcc.ICDCode
		--WHERE DiagnosisCategory IN (
		--		@DiagnosisCategory1
		--		,@DiagnosisCategory2
		--		)
		--	AND ISNULL(dcc.RecordDeleted, 'N') = 'N'
		--	AND ISNULL(dcc.RecordDeleted, 'N') = 'N'

		INSERT INTO #ClientFilters (
			ClientId
			,FilterDiagnosis
			)
		SELECT dd.ClientId
			,'Y'
		FROM #DiagnosisDocuments dd
		WHERE (
				ISNULL(@DiagnosisCode1, '') = ''
				OR (
					@DiagnosisCondition1 = 'E'
					AND EXISTS (
						SELECT d.DocumentVersionId
						FROM DocumentDiagnosisCodes d
						INNER JOIN @DiagnosisDSMCodes dsm ON dsm.DSMCode = d.ICD10Code
						WHERE d.DocumentVersionId = dd.DocumentVersionId
							AND dsm.SearchType = 'DxCode1'
							AND ISNULL(d.RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					@DiagnosisCondition1 = 'N'
					AND NOT EXISTS (
						SELECT d.DocumentVersionId
						FROM DocumentDiagnosisCodes d
						INNER JOIN @DiagnosisDSMCodes dsm ON dsm.DSMCode = d.ICD10Code
						WHERE d.DocumentVersionId = dd.DocumentVersionId
							AND dsm.SearchType = 'DxCode1'
							AND ISNULL(d.RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND (
				ISNULL(@DiagnosisCode2, '') = ''
				OR (
					@DiagnosisCondition2 = 'E'
					AND EXISTS (
						SELECT d.DocumentVersionId
						FROM DocumentDiagnosisCodes d
						INNER JOIN @DiagnosisDSMCodes dsm ON dsm.DSMCode = d.ICD10Code
						WHERE d.DocumentVersionId = dd.DocumentVersionId
							AND dsm.SearchType = 'DxCode2'
							AND ISNULL(d.RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					@DiagnosisCondition2 = 'N'
					AND NOT EXISTS (
						SELECT d.DocumentVersionId
						FROM DocumentDiagnosisCodes d
						INNER JOIN @DiagnosisDSMCodes dsm ON dsm.DSMCode = d.ICD10Code
						WHERE d.DocumentVersionId = dd.DocumentVersionId
							AND dsm.SearchType = 'DxCode2'
							AND ISNULL(d.RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND (
				@DiagnosisCategory1 <= 0
				OR (
					@DiagnosisCategoryCondition1 = 'E'
					AND EXISTS (
						SELECT d.DocumentVersionId
						FROM DocumentDiagnosisCodes d
						INNER JOIN @DiagnosisDSMCodes dsm ON dsm.DSMCode = d.ICD10Code
						WHERE d.DocumentVersionId = dd.DocumentVersionId
							AND dsm.SearchType = 'DxCategory1'
							AND ISNULL(d.RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					@DiagnosisCategoryCondition1 = 'N'
					AND NOT EXISTS (
						SELECT d.DocumentVersionId
						FROM DocumentDiagnosisCodes d
						INNER JOIN @DiagnosisDSMCodes dsm ON dsm.DSMCode = d.ICD10Code
						WHERE d.DocumentVersionId = dd.DocumentVersionId
							AND dsm.SearchType = 'DxCategory1'
							AND ISNULL(d.RecordDeleted, 'N') = 'N'
						)
					)
				)
			AND (
				@DiagnosisCategory2 <= 0
				OR (
					@DiagnosisCategoryCondition2 = 'E'
					AND EXISTS (
						SELECT d.DocumentVersionId
						FROM DocumentDiagnosisCodes d
						INNER JOIN @DiagnosisDSMCodes dsm ON dsm.DSMCode = d.ICD10Code
						WHERE d.DocumentVersionId = dd.DocumentVersionId
							AND dsm.SearchType = 'DxCategory2'
							AND ISNULL(d.RecordDeleted, 'N') = 'N'
						)
					)
				OR (
					@DiagnosisCategoryCondition2 = 'N'
					AND NOT EXISTS (
						SELECT d.DocumentVersionId
						FROM DocumentDiagnosisCodes d
						INNER JOIN @DiagnosisDSMCodes dsm ON dsm.DSMCode = d.ICD10Code
						WHERE d.DocumentVersionId = dd.DocumentVersionId
							AND dsm.SearchType = 'DxCategory2'
							AND ISNULL(d.RecordDeleted, 'N') = 'N'
						)
					)
				)
		
		UNION
				
		SELECT DD.ClientId
			,'Y'
		FROM #DiagnosisDocuments DD
		INNER JOIN DocumentDiagnosisCodes DDC ON DDC.DocumentVersionId = DD.DocumentVersionId
			AND DDC.ICD10Code IN (
				@DiagnosisCode1
				,@DiagnosisCode2
				)
	END

	--IF @LOFCategory = 6561
	--BEGIN
	--	SET @FilterLOGCategory = 'Y'

	--	INSERT INTO #ClientFilters (
	--		ClientId
	--		,FilterLOGCategory
	--		)
	--	SELECT dd.ClientId
	--		,'Y'
	--	FROM #DiagnosisDocuments dd
	--	WHERE EXISTS (
	--			SELECT 1
	--			FROM DiagnosesV d
	--			WHERE d.DocumentVersionId = dd.DocumentVersionId
	--				AND d.AxisV BETWEEN @LOFMinimumValue
	--					AND @LOFMaximumValue
	--				AND ISNULL(d.RecordDeleted, 'N') = 'N'
	--			)
	--END
END

IF @MedicationNameId > 0
	OR @MedicationCategory > 0
	OR @PrescriberId > 0
BEGIN
	SET @FiltersUsed = 1;
	SET @FilterMedication = 'Y'

	/* Below dynamic Query written By Pralyankar on May 24, 2012 for improving performance of below query */
	DECLARE @DynamicQuery NVARCHAR(4000)

	SET @DynamicQuery = 'SELECT c.ClientId, ''Y'' FROM Clients c WHERE c.Active = ''Y'' AND isnull(c.RecordDeleted, ''N'') = ''N'' '

	-------------------------------------------------------------          
	IF @MedicationNameId > 0
		AND @MedicationCondition = 'E'
	BEGIN
		SET @DynamicQuery = @DynamicQuery + ' and EXISTS(SELECT cm.ClientId FROM ClientMedications cm where cm.ClientId = c.ClientId and cm.MedicationNameId = ' + CAST(@MedicationNameId AS VARCHAR) + ' and isnull(cm.Discontinued, ''N'') =    
  
     
                    ''N'' and isnull(cm.RecordDeleted, ''N'') = ''N''           
               AND (          
                ''' + CAST(@FromDate AS VARCHAR) + ''' IS NULL          
                OR cm.MedicationStartDate >= ''' + CAST(@FromDate AS VARCHAR) + '''          
                )          
               AND (          
                ''' + CAST(@ToDate AS VARCHAR) + ''' IS NULL          
                OR cm.MedicationStartDate <= ''' + CAST(@ToDate AS VARCHAR) + '''          
                ))  '
	END

	IF @MedicationNameId > 0
		AND @MedicationCondition = 'N'
	BEGIN
		SET @DynamicQuery = @DynamicQuery + ' AND NOT EXISTS(SELECT cm.ClientId FROM ClientMedications cm where cm.ClientId = c.ClientId and cm.MedicationNameId = ' + CAST(@MedicationNameId AS VARCHAR) + ' and isnull(cm.Discontinued, ''N'') = 
  
    
      
        
''N'' and isnull(cm.RecordDeleted, ''N'') = ''N''           
               AND (          
                ''' + CAST(@FromDate AS VARCHAR) + ''' IS NULL          
                OR cm.MedicationStartDate >= ''' + CAST(@FromDate AS VARCHAR) + '''          
                )          
               AND (          
                ''' + CAST(@ToDate AS VARCHAR) + ''' IS NULL          
                OR cm.MedicationStartDate <= ''' + CAST(@ToDate AS VARCHAR) + '''          
                )) '
	END

	-------------------------------------------------------------          
	IF @MedicationCategory > 0
		AND @MedicationCategoryCondition = 'E'
	BEGIN
		SET @DynamicQuery = @DynamicQuery + ' And exists(SELECT cm.MedicationNameId FROM MedicationCategoryMedicationNames mc join ClientMedications cm on cm.MedicationNameId = mc.MedicationNameId where mc.MedicationCategory = ' + CAST(@MedicationCategory AS VARCHAR) + ' and cm.ClientId = c.ClientId and isnull(cm.Discontinued, ''N'') = ''N'' and isnull(mc.RecordDeleted, ''N'') = ''N'' and isnull(cm.RecordDeleted, ''N'') = ''N''           
               AND (          
                ''' + CAST(@FromDate AS VARCHAR) + ''' IS NULL          
                OR cm.MedicationStartDate >= ''' + CAST(@FromDate AS VARCHAR) + '''          
                )          
               AND (          
                ''' + CAST(@ToDate AS VARCHAR) + ''' IS NULL          
        OR cm.MedicationStartDate <= ''' + CAST(@ToDate AS VARCHAR) + '''          
                )) '
	END

	IF @MedicationCategory > 0
		AND @MedicationCategoryCondition = 'N'
	BEGIN
		SET @DynamicQuery = @DynamicQuery + ' And NOT exists(select cm.MedicationNameId from MedicationCategoryMedicationNames mc join ClientMedications cm on cm.MedicationNameId = mc.MedicationNameId where mc.MedicationCategory = ' + CAST(@MedicationCategory AS VARCHAR) + ' and cm.ClientId = c.ClientId and isnull(cm.Discontinued, ''N'') = ''N'' and isnull(mc.RecordDeleted, ''N'') = ''N'' and isnull(cm.RecordDeleted, ''N'') = ''N''           
               AND (          
                ''' + CAST(@FromDate AS VARCHAR) + ''' IS NULL          
                OR cm.MedicationStartDate >= ''' + CAST(@FromDate AS VARCHAR) + '''          
                )          
               AND (          
                ''' + CAST(@ToDate AS VARCHAR) + ''' IS NULL          
                OR cm.MedicationStartDate <= ''' + CAST(@ToDate AS VARCHAR) + '''          
                )) '
	END

	-------------------------------------------------------------          
	IF @PrescriberId > 0
	BEGIN
		SET @DynamicQuery = @DynamicQuery + ' And exists(SELECT cm.ClientId from ClientMedications cm where cm.ClientId = c.ClientId and cm.PrescriberId = ' + CAST(@PrescriberId AS VARCHAR) + ' and isnull(cm.Discontinued, ''N'') = ''N'' and   
  
    
      
                    isnull(cm.RecordDeleted, ''N'') = ''N''           
               AND (          
                ''' + CAST(@FromDate AS VARCHAR) + ''' IS NULL          
                OR cm.MedicationStartDate >= ''' + CAST(@FromDate AS VARCHAR) + '''          
                )          
               AND (          
                ''' + CAST(@ToDate AS VARCHAR) + ''' IS NULL          
                OR cm.MedicationStartDate <= ''' + CAST(@ToDate AS VARCHAR) + '''          
                )) '
	END

	-- Execute dynamic query and insert rows into Temp table           
	INSERT INTO #ClientFilters (
		ClientId
		,FilterMedication
		)
	EXEC sp_executesql @DynamicQuery
		--========================================================          
		/* Code commented by Pralyankar on May 24, 2012.           
  insert into #ClientFilters (ClientId, FilterMedication)               
  select c.ClientId, 'Y'          
  from Clients c          
  where c.Active = 'Y' and isnull(c.RecordDeleted, 'N') = 'N'          
   and (@MedicationNameId <= 0          
    or (@MedicationCondition = 'E' and exists(select cm.ClientId from ClientMedications cm where cm.ClientId = c.ClientId and cm.MedicationNameId = @MedicationNameId and isnull(cm.Discontinued, 'N') = 'N' and isnull(cm.RecordDeleted, 'N') = 'N'))         
 
    or (@MedicationCondition = 'N' and not exists(select cm.ClientId from ClientMedications cm where cm.ClientId = c.ClientId and cm.MedicationNameId = @MedicationNameId and isnull(cm.Discontinued, 'N') = 'N' and isnull(cm.RecordDeleted, 'N') = 'N')))    
  
    
      
   and (@MedicationCategory <= 0          
    or (@MedicationCategoryCondition = 'E' and exists(select cm.MedicationNameId from MedicationCategoryMedicationNames mc join ClientMedications cm on cm.MedicationNameId = mc.MedicationNameId where mc.MedicationCategory = @MedicationCategory and cm.Clie
  
    
      
        
ntId = c.ClientId and isnull(cm.Discontinued, 'N') = 'N' and isnull(mc.RecordDeleted, 'N') = 'N' and isnull(cm.RecordDeleted, 'N') = 'N'))                
    or (@MedicationCategoryCondition = 'N' and not exists(select cm.MedicationNameId from MedicationCategoryMedicationNames mc join ClientMedications cm on cm.MedicationNameId = mc.MedicationNameId where mc.MedicationCategory = @MedicationCategory and cm.
  
    
      
        
ClientId = c.ClientId and isnull(cm.Discontinued, 'N') = 'N' and isnull(mc.RecordDeleted, 'N') = 'N' and isnull(cm.RecordDeleted, 'N') = 'N')))          
   and (@PrescriberId <= 0 or exists(select cm.ClientId from ClientMedications cm where cm.ClientId = c.ClientId and cm.PrescriberId = @PrescriberId and isnull(cm.Discontinued, 'N') = 'N' and isnull(cm.RecordDeleted, 'N') = 'N'))                          
  
    
      
        
                                             
  */
END

--SELECT  * FROM    #ClientFilters          
IF @HealthDataSubTemplateId1 > 0
	OR @WaitingForLabResults = 'Y'
	OR @NoLabsForDays > 0
	OR @HealthDataTemplateId2 > 0
	OR @HealthDataTemplateId3 > 0
BEGIN
	SET @FiltersUsed = 1;
	SET @FilterHealthData = 'Y'

	INSERT INTO #ClientFilters (
		ClientId
		,FilterHealthData
		)
	SELECT c.ClientId
		,'Y'
	FROM Clients c
	WHERE c.Active = 'Y'
		AND ISNULL(c.RecordDeleted, 'N') = 'N'
		AND (
			@NoLabsForDays <= 0
			OR NOT EXISTS (
				SELECT 1
				FROM ClientHealthDataAttributes hd
				INNER JOIN HealthDataTemplateAttributes HDTA ON hd.HealthDataSubTemplateId = HDTA.HealthDataSubTemplateId
				WHERE hd.ClientId = c.ClientId
					AND (
						HDTA.HealthDataTemplateId = @NoLabsForHealthDataCategoryId
						OR @NoLabsForHealthDataCategoryId <= 0
						)
					AND DATEDIFF(dd, ISNULL(hd.HealthRecordDate, ''), @Today) <= @NoLabsForDays
					AND ISNULL(hd.RecordDeleted, 'N') = 'N'
					AND (
						@FromDate IS NULL
						OR hd.HealthRecordDate >= @FromDate
						)
					AND (
						@ToDate IS NULL
						OR hd.HealthRecordDate <= @ToDate
						)
				)
			)
		AND (
			ISNULL(@WaitingForLabResults, 'N') = 'N'
			OR EXISTS (
				SELECT 1
				FROM ClientOrders co
				INNER JOIN Orders O ON O.OrderId = co.OrderId
				WHERE co.ClientId = c.ClientId
					AND O.OrderType = 6481
					AND ISNULL(co.OrderStatus, 0) <> 6504
					AND ISNULL(co.RecordDeleted, 'N') = 'N'
					AND (
						@FromDate IS NULL
						OR co.OrderStartDateTime >= @FromDate
						)
					AND (
						@ToDate IS NULL
						OR co.OrderStartDateTime <= @ToDate
						)
				)
			)
		AND (
			@HealthDataSubTemplateId1 <= 0
			OR EXISTS (
				SELECT 1
				FROM ClientHealthDataAttributes hda
				WHERE hda.ClientId = c.ClientId
					AND ISNULL(hda.RecordDeleted, 'N') = 'N'
					AND (
						hda.HealthDataSubTemplateId = @HealthDataSubTemplateId1
						OR @HealthDataSubTemplateId1 <= 0
						)
					AND (
						hda.HealthDataAttributeId = @HealthDataAttribute1
						OR @HealthDataAttribute1 <= 0
						)
					AND CAST(ISNULL(hda.Value, 0) AS DECIMAL) BETWEEN @HealthDataAttributeMinimumValue1
						AND @HealthDataAttributeMaximumValue1
					AND (hda.HealthRecordDate >= @FromDate)
					AND (hda.HealthRecordDate <= @ToDate)
				)
			)
		AND (
			@HealthDataTemplateId2 <= 0
			OR EXISTS (
				SELECT 1
				FROM ClientHealthDataAttributes hda
				INNER JOIN HealthDataTemplateAttributes HDTA ON hda.HealthDataSubTemplateId = HDTA.HealthDataSubTemplateId
				WHERE hda.ClientId = c.ClientId
					AND ISNULL(hda.RecordDeleted, 'N') = 'N'
					AND (
						HDTA.HealthDataTemplateId = @HealthDataTemplateId2
						OR @HealthDataTemplateId2 <= 0
						)
					AND (
						hda.HealthDataSubTemplateId = @HealthDataSubTemplateId2
						OR @HealthDataSubTemplateId2 <= 0
						)
					AND (
						hda.HealthDataAttributeId = @HealthDataAttribute2
						OR @HealthDataAttribute2 <= 0
						)
					AND CAST(ISNULL(hda.Value, 0) AS DECIMAL) BETWEEN @HealthDataAttributeMinimumValue2
						AND @HealthDataAttributeMaximumValue2
					AND (
						@FromDate IS NULL
						OR hda.HealthRecordDate >= @FromDate
						)
					AND (
						@ToDate IS NULL
						OR hda.HealthRecordDate <= @ToDate
						)
				)
			)
		AND (
			@HealthDataTemplateId3 <= 0
			OR EXISTS (
				SELECT 1
				FROM ClientHealthDataAttributes hda
				INNER JOIN HealthDataTemplateAttributes HDTA ON hda.HealthDataSubTemplateId = HDTA.HealthDataSubTemplateId
				WHERE hda.ClientId = c.ClientId
					AND ISNULL(hda.RecordDeleted, 'N') = 'N'
					AND (
						HDTA.HealthDataTemplateId = @HealthDataTemplateId3
						OR @HealthDataTemplateId3 <= 0
						)
					AND (
						hda.HealthDataSubTemplateId = @HealthDataSubTemplateId3
						OR @HealthDataSubTemplateId3 <= 0
						)
					AND (
						hda.HealthDataAttributeId = @HealthDataAttribute3
						OR @HealthDataAttribute3 <= 0
						)
					AND CAST(ISNULL(hda.Value, 0) AS DECIMAL) BETWEEN @HealthDataAttributeMinimumValue3
						AND @HealthDataAttributeMaximumValue3
					AND (
						@FromDate IS NULL
						OR hda.HealthRecordDate >= @FromDate
						)
					AND (
						@ToDate IS NULL
						OR hda.HealthRecordDate <= @ToDate
						)
				)
			)
END

--SELECT  * FROM    #ClientFilters          
INSERT INTO #Clients (ClientId)
SELECT cf.ClientId
FROM #ClientFilters cf
GROUP BY cf.ClientId
HAVING (
		@FilterDemographics = 'N'
		OR MAX(FilterDemographics) = 'Y'
		)
	AND (
		@FilterDiagnosis = 'N'
		OR MAX(FilterDiagnosis) = 'Y'
		)
	AND (
		@FilterLOGCategory = 'N'
		OR MAX(FilterLOGCategory) = 'Y'
		)
	AND (
		@FilterMedication = 'N'
		OR MAX(FilterMedication) = 'Y'
		)
	AND (
		@FilterHealthData = 'N'
		OR MAX(FilterHealthData) = 'Y'
		)

--SELECT * FROM #ClientFilters          
-- Get result set                     
IF (@FiltersUsed = 1)
BEGIN
	INSERT INTO #ResultSet (
		ClientId
		,ClientName
		,ClientAge
		,ClientSex
		,ClientRace
		,ClientReminderId
		,ReminderDate
		,PrimaryDiagnosis
		,PrimaryDiagnosisDescription
		,DiagnosisDocumentId
		,IsSelected
		,Diagnosis
		,DiagnosisDescription
		,DiagnosisDate
		,Medication
		,MedicationDate
		,Allergy
		,AllergyDate
		,DateOfBirth
		,Ethnicity
		,HealthDataElement
		,HealthDataDate
		,CommunicationPreference
		,CommunicationPreferenceDate
		,DemographicsDate
		)
	SELECT DISTINCT c.ClientId,
	CASE     
						WHEN ISNULL(C.ClientType, 'I') = 'I'
						 THEN ISNULL(C.LastName, '') + ' ,' + ISNULL(C.FirstName, '')
						ELSE ISNULL(C.OrganizationName, '')
						END
	--	,c.LastName + ', ' + c.FirstName
		,dbo.GetAge(c.DOB, @Today)
		,CASE c.Sex
			WHEN 'M'
				THEN 'Male'
			WHEN 'F'
				THEN 'Female'
			WHEN 'U'
				THEN 'Unknown'
			ELSE c.Sex
			END
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,0
		,CASE 
			WHEN diagnosis.ICD10Code = @DiagnosisCode1
				THEN diagnosis.ICD10Code
			ELSE NULL
			END
		,CASE 
			WHEN diagnosis.ICD10Code = @DiagnosisCode1
				THEN diagnosis.ICD10Desc
			ELSE NULL
			END
		,-- DiagnosisDescription           
		diagnosis.EffectiveDate
		,cm.MedicationNameId
		,cm.MedicationStartDate
		,ca.AllergenConceptId
		,CASE 
			WHEN ca.ModifiedDate > ca.CreatedDate
				THEN ca.ModifiedDate
			WHEN ca.ModifiedDate <= ca.CreatedDate
				THEN ca.CreatedDate
			END
		,c.DOB
		,@Ethnicity
		,chda.HealthDataAttributeId
		,chda.HealthRecordDate
		,c.ReminderPreference
		,C.ModifiedDate
		,c.ModifiedDate
	FROM Clients c
	INNER JOIN #Clients cf ON cf.ClientId = c.ClientId
	--Added by Revathi on 07-Jan-2014 for task #77 Engineering Improvement Initiatives- NBL(I)          
	INNER JOIN StaffClients sc ON sc.ClientId = c.ClientId
		AND sc.StaffId = @StaffId
	LEFT JOIN (
		SELECT diagdoc.ClientId
			,diagdoc.EffectiveDate
			,diag.ICD10Code
			,ICD10Codes.ICDDescription AS ICD10Desc
		FROM dbo.Documents diagdoc
		INNER JOIN dbo.DocumentSignatures ds ON ds.DocumentId = diagdoc.DocumentId
		INNER JOIN dbo.DocumentDiagnosisCodes diag ON diagdoc.CurrentDocumentVersionId = diag.DocumentVersionId
		INNER JOIN #Clients cf2 ON diagdoc.ClientId = cf2.Clientid
		LEFT JOIN dbo.DiagnosisICD10Codes ICD10Codes ON ICD10Codes.ICD10Code = diag.ICD10Code
		WHERE diagdoc.ClientId = cf2.ClientId
			AND diagdoc.STATUS = 22
			AND diagdoc.EffectiveDate BETWEEN @FromDate
				AND @ToDate
			AND ISNULL(diagdoc.RecordDeleted, 'N') = 'N'
			AND ISNULL(ds.RecordDeleted, 'N') = 'N'
			AND ISNULL(diag.RecordDeleted, 'N') = 'N'
			AND (diag.ICD10Code = @DiagnosisCode1
				)
			--ORDER BY diagdoc.EffectiveDate ASC          
		) AS diagnosis ON c.ClientId = diagnosis.ClientId
	LEFT JOIN dbo.ClientMedications cm ON cm.ClientId = c.ClientId
		AND ISNULL(cm.RecordDeleted, 'N') = 'N'
		AND ISNULL(cm.Discontinued, 'N') = 'N'
		AND MedicationStartDate BETWEEN @FromDate
			AND @ToDate
		AND cm.MedicationNameId = @MedicationNameId
	LEFT JOIN dbo.ClientAllergies ca ON ca.ClientId = c.ClientId
		AND ISNULL(ca.RecordDeleted, 'N') = 'N'
		AND ca.AllergenConceptId = @AllergenConceptId
		AND CASE 
			WHEN ca.ModifiedDate > ca.CreatedDate
				THEN ca.ModifiedDate
			WHEN ca.ModifiedDate <= ca.CreatedDate
				THEN ca.CreatedDate
			END BETWEEN @FromDate
			AND @ToDate
	LEFT JOIN (
		SELECT a.ClientId
			,a.HealthDataAttributeId
			,MAX(a.HealthRecordDate) AS HealthRecordDate
		FROM dbo.ClientHealthDataAttributes a
		INNER JOIN #Clients cf ON a.ClientId = cf.ClientId
		WHERE ISNULL(a.RecordDeleted, 'N') = 'N'
			AND a.HealthDataAttributeId = @HealthDataAttribute1
			AND a.HealthRecordDate BETWEEN @FromDate
				AND @ToDate
		GROUP BY a.ClientId
			,a.HealthDataAttributeId
		) AS chda ON chda.ClientId = c.ClientId
	
	UNION
	
	SELECT DISTINCT c.ClientId,
	CASE     
						WHEN ISNULL(C.ClientType, 'I') = 'I'
						 THEN ISNULL(C.LastName, '') + ' ,' + ISNULL(C.FirstName, '')
						ELSE ISNULL(C.OrganizationName, '')
						END
	--	,c.LastName + ', ' + c.FirstName
		,dbo.GetAge(c.DOB, @Today)
		,CASE c.Sex
			WHEN 'M'
				THEN 'Male'
			WHEN 'F'
				THEN 'Female'
			WHEN 'U'
				THEN 'Unknown'
			ELSE c.Sex
			END
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,0
		,CASE 
			WHEN diagnosis.ICD10Code = @DiagnosisCode2
				THEN diagnosis.ICD10Code
			ELSE NULL
			END
		,CASE 
			WHEN diagnosis.ICD10Code = @DiagnosisCode2
				THEN diagnosis.ICD10Desc
			ELSE NULL
			END
		,-- DiagnosisDescription          
		diagnosis.EffectiveDate
		,cm.MedicationNameId
		,cm.MedicationStartDate
		,ca.AllergenConceptId
		,CASE 
			WHEN ca.ModifiedDate > ca.CreatedDate
				THEN ca.ModifiedDate
			WHEN ca.ModifiedDate <= ca.CreatedDate
				THEN ca.CreatedDate
			END
		,c.DOB
		,@Ethnicity
		,chda.HealthDataAttributeId
		,chda.HealthRecordDate
		,c.ReminderPreference
		,C.ModifiedDate
		,c.ModifiedDate
	FROM Clients c
	INNER JOIN #Clients cf ON cf.ClientId = c.ClientId
	--Added by Revathi on 07-Jan-2014 for task #77 Engineering Improvement Initiatives- NBL(I)          
	INNER JOIN StaffClients sc ON sc.ClientId = c.ClientId
		AND sc.StaffId = @StaffId
	LEFT JOIN (
		SELECT diagdoc.ClientId
			,diagdoc.EffectiveDate
			,diag.ICD10Code
			,ICD10Codes.ICDDescription AS ICD10Desc
		FROM dbo.Documents diagdoc
		INNER JOIN dbo.DocumentSignatures ds ON ds.DocumentId = diagdoc.DocumentId
		INNER JOIN dbo.DocumentDiagnosisCodes diag ON diagdoc.CurrentDocumentVersionId = diag.DocumentVersionId
		INNER JOIN #Clients cf2 ON diagdoc.ClientId = cf2.Clientid
		LEFT JOIN dbo.DiagnosisICD10Codes ICD10Codes ON ICD10Codes.ICD10Code = diag.ICD10Code
		WHERE diagdoc.ClientId = cf2.ClientId
			AND diagdoc.STATUS = 22
			AND diagdoc.EffectiveDate BETWEEN @FromDate
				AND @ToDate
			AND ISNULL(diagdoc.RecordDeleted, 'N') = 'N'
			AND ISNULL(ds.RecordDeleted, 'N') = 'N'
			AND ISNULL(diag.RecordDeleted, 'N') = 'N'
			AND ( diag.ICD10Code = @DiagnosisCode2
				)
			--ORDER BY diagdoc.EffectiveDate ASC          
		) AS diagnosis ON c.ClientId = diagnosis.ClientId
	LEFT JOIN dbo.ClientMedications cm ON cm.ClientId = c.ClientId
		AND ISNULL(cm.RecordDeleted, 'N') = 'N'
		AND ISNULL(cm.Discontinued, 'N') = 'N'
		AND MedicationStartDate BETWEEN @FromDate
			AND @ToDate
		AND cm.MedicationNameId = @MedicationNameId
	LEFT JOIN dbo.ClientAllergies ca ON ca.ClientId = c.ClientId
		AND ISNULL(ca.RecordDeleted, 'N') = 'N'
		AND ca.AllergenConceptId = @AllergenConceptId
		AND CASE 
			WHEN ca.ModifiedDate > ca.CreatedDate
				THEN ca.ModifiedDate
			WHEN ca.ModifiedDate <= ca.CreatedDate
				THEN ca.CreatedDate
			END BETWEEN @FromDate
			AND @ToDate
	LEFT JOIN (
		SELECT a.ClientId
			,a.HealthDataAttributeId
			,MAX(a.HealthRecordDate) AS HealthRecordDate
		FROM dbo.ClientHealthDataAttributes a
		INNER JOIN #Clients cf ON a.ClientId = cf.ClientId
		WHERE ISNULL(a.RecordDeleted, 'N') = 'N'
			AND a.HealthDataAttributeId = @HealthDataAttribute2
			AND a.HealthRecordDate BETWEEN @FromDate
				AND @ToDate
		GROUP BY a.ClientId
			,a.HealthDataAttributeId
		) AS chda ON chda.ClientId = c.ClientId
	WHERE (
			ISNULL(@DiagnosisCode2, '') <> ''
			OR @HealthDataAttribute2 > 0
			)
	
	UNION
	
	SELECT DISTINCT c.ClientId,
	CASE     
						WHEN ISNULL(C.ClientType, 'I') = 'I'
						 THEN ISNULL(C.LastName, '') + ' ,' + ISNULL(C.FirstName, '')
						ELSE ISNULL(C.OrganizationName, '')
						END
		--,c.LastName + ', ' + c.FirstName
		,dbo.GetAge(c.DOB, @Today)
		,CASE c.Sex
			WHEN 'M'
				THEN 'Male'
			WHEN 'F'
				THEN 'Female'
			WHEN 'U'
				THEN 'Unknown'
			ELSE c.Sex
			END
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,0
		,CASE 
			WHEN diagnosis.ICD10Code = @DiagnosisCode1
				THEN diagnosis.ICD10Code
			ELSE NULL
			END
		,CASE 
			WHEN diagnosis.ICD10Code = @DiagnosisCode1
				THEN diagnosis.ICD10Desc
			ELSE NULL
			END
		,-- DiagnosisDescription          
		diagnosis.EffectiveDate
		,cm.MedicationNameId
		,cm.MedicationStartDate
		,ca.AllergenConceptId
		,CASE 
			WHEN ca.ModifiedDate > ca.CreatedDate
				THEN ca.ModifiedDate
			WHEN ca.ModifiedDate <= ca.CreatedDate
				THEN ca.CreatedDate
			END
		,c.DOB
		,@Ethnicity
		,chda.HealthDataAttributeId
		,chda.HealthRecordDate
		,c.ReminderPreference
		,C.ModifiedDate
		,c.ModifiedDate
	FROM Clients c
	INNER JOIN #Clients cf ON cf.ClientId = c.ClientId
	--Added by Revathi on 07-Jan-2014 for task #77 Engineering Improvement Initiatives- NBL(I)          
	INNER JOIN StaffClients sc ON sc.ClientId = c.ClientId
		AND sc.StaffId = @StaffId
	LEFT JOIN (
		SELECT diagdoc.ClientId
			,diagdoc.EffectiveDate
			,diag.ICD10Code
			,ICD10Codes.ICDDescription AS ICD10Desc
		FROM dbo.Documents diagdoc
		INNER JOIN dbo.DocumentSignatures ds ON ds.DocumentId = diagdoc.DocumentId
		INNER JOIN dbo.DocumentDiagnosisCodes diag ON diagdoc.CurrentDocumentVersionId = diag.DocumentVersionId
		INNER JOIN #Clients cf2 ON diagdoc.ClientId = cf2.Clientid
		LEFT JOIN dbo.DiagnosisICD10Codes ICD10Codes ON ICD10Codes.ICD10Code = diag.ICD10Code
		WHERE diagdoc.ClientId = cf2.ClientId
			AND diagdoc.STATUS = 22
			AND diagdoc.EffectiveDate BETWEEN @FromDate
				AND @ToDate
			AND ISNULL(diagdoc.RecordDeleted, 'N') = 'N'
			AND ISNULL(ds.RecordDeleted, 'N') = 'N'
			AND ISNULL(diag.RecordDeleted, 'N') = 'N'
			AND ( diag.ICD10Code = @DiagnosisCode1
				)
			--ORDER BY diagdoc.EffectiveDate ASC          
		) AS diagnosis ON c.ClientId = diagnosis.ClientId
	LEFT JOIN dbo.ClientMedications cm ON cm.ClientId = c.ClientId
		AND ISNULL(cm.RecordDeleted, 'N') = 'N'
		AND ISNULL(cm.Discontinued, 'N') = 'N'
		AND MedicationStartDate BETWEEN @FromDate
			AND @ToDate
		AND cm.MedicationNameId = @MedicationNameId
	LEFT JOIN dbo.ClientAllergies ca ON ca.ClientId = c.ClientId
		AND ISNULL(ca.RecordDeleted, 'N') = 'N'
		AND ca.AllergenConceptId = @AllergenConceptId
		AND CASE 
			WHEN ca.ModifiedDate > ca.CreatedDate
				THEN ca.ModifiedDate
			WHEN ca.ModifiedDate <= ca.CreatedDate
				THEN ca.CreatedDate
			END BETWEEN @FromDate
			AND @ToDate
	LEFT JOIN (
		SELECT a.ClientId
			,a.HealthDataAttributeId
			,MAX(a.HealthRecordDate) AS HealthRecordDate
		FROM dbo.ClientHealthDataAttributes a
		INNER JOIN #Clients cf ON a.ClientId = cf.ClientId
		WHERE ISNULL(a.RecordDeleted, 'N') = 'N'
			AND a.HealthDataAttributeId = @HealthDataAttribute3
			AND a.HealthRecordDate BETWEEN @FromDate
				AND @ToDate
		GROUP BY a.ClientId
			,a.HealthDataAttributeId
		) AS chda ON chda.ClientId = c.ClientId
	WHERE @HealthDataAttribute3 > 0
	ORDER BY c.ClientId
END
ELSE
BEGIN
	INSERT INTO #ResultSet (
		ClientId
		,ClientName
		,ClientAge
		,ClientSex
		,ClientRace
		,ClientReminderId
		,ReminderDate
		,PrimaryDiagnosis
		,PrimaryDiagnosisDescription
		,DiagnosisDocumentId
		,IsSelected
		,Diagnosis
		,DiagnosisDescription
		,DiagnosisDate
		,Medication
		,MedicationDate
		,Allergy
		,AllergyDate
		,DateOfBirth
		,Ethnicity
		,HealthDataElement
		,HealthDataValue
		,HealthDataDate
		,CommunicationPreference
		,CommunicationPreferenceDate
		,DemographicsDate
		)
	SELECT DISTINCT c.ClientId,
	CASE     
						WHEN ISNULL(C.ClientType, 'I') = 'I'
						 THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')
						ELSE ISNULL(C.OrganizationName, '')
						END
		--,c.LastName + ', ' + c.FirstName
		,dbo.GetAge(c.DOB, @Today)
		,CASE c.Sex
			WHEN 'M'
				THEN 'Male'
			WHEN 'F'
				THEN 'Female'
			WHEN 'U'
				THEN 'Unknown'
			ELSE c.Sex
			END
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,0
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,c.ReminderPreference
		,c.ModifiedDate
		,c.ModifiedDate
	FROM Clients c --Added by Revathi on 07-Jan-2014 for task #77 Engineering Improvement Initiatives- NBL(I)          
	INNER JOIN StaffClients sc ON sc.ClientId = c.ClientId
		AND sc.StaffId = @StaffId
	WHERE c.Active = 'Y'
		AND ISNULL(c.RecordDeleted, 'N') = 'N'
	ORDER BY c.ClientId
END

UPDATE rs
SET ClientRace = gc.CodeName
FROM #ResultSet rs
INNER JOIN ClientRaces cr ON cr.ClientId = rs.ClientId
INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = cr.RaceId
WHERE ISNULL(cr.RecordDeleted, 'N') = 'N'
	AND NOT EXISTS (
		SELECT 1
		FROM ClientRaces cr2
		WHERE cr2.ClientId = cr.ClientId
			AND ISNULL(cr2.RecordDeleted, 'N') = 'N'
			AND cr2.ClientRaceId < cr.ClientRaceId
		)

UPDATE rs
SET ClientReminderId = cr.ClientReminderId
	,ReminderDate = cr.ReminderDate
FROM #ResultSet rs
INNER JOIN ClientReminders cr ON cr.ClientId = rs.ClientId
WHERE ISNULL(cr.RecordDeleted, 'N') = 'N'
	AND NOT EXISTS (
		SELECT 1
		FROM ClientReminders cr2
		WHERE cr2.ClientId = cr.ClientId
			AND ISNULL(cr2.RecordDeleted, 'N') = 'N'
			AND cr2.ReminderDate > cr.ReminderDate
		)

UPDATE rs
SET PrimaryDiagnosis = dx.ICD10Code
	,PrimaryDiagnosisDescription = (
		SELECT TOP 1 DI.ICDDescription
		FROM dbo.DiagnosisICD10Codes DI
		WHERE DI.ICD10Code = dx.ICD10Code
		)
	,DiagnosisDocumentId = d.DocumentId
FROM #ResultSet rs
INNER JOIN Documents d ON d.ClientId = rs.ClientId
INNER JOIN dbo.DocumentDiagnosisCodes dx ON dx.DocumentVersionId = d.CurrentDocumentVersionId
WHERE d.STATUS = 22
	AND d.DocumentCodeId =	1601
	AND d.EffectiveDate < DATEADD(dd, 1, @Today)
	AND dx.DiagnosisType = 140 -- Primary                       
	AND ISNULL(d.RecordDeleted, 'N') = 'N'
	AND ISNULL(dx.RecordDeleted, 'N') = 'N'
	AND NOT EXISTS (
		SELECT 1
		FROM Documents d2
		WHERE d2.ClientId = d.ClientId
			AND d2.STATUS = d.STATUS
			AND d2.DocumentCodeId = d.DocumentCodeId
			AND d2.EffectiveDate < DATEADD(dd, 1, @Today)
			AND ISNULL(d2.RecordDeleted, 'N') = 'N'
			AND d2.EffectiveDate > d.EffectiveDate
		)

UPDATE rs
SET HealthDataValue = chda.value
FROM #ResultSet rs
INNER JOIN dbo.ClientHealthDataAttributes chda ON chda.ClientId = rs.CLientId
	AND chda.HealthRecordDate = rs.HealthDataDate
	AND chda.HealthDataAttributeId = rs.HealthDataElement
WHERE ISNULL(chda.RecordDeleted, 'N') = 'N'

UPDATE rs
SET rs.DateOfBirth = CONVERT(VARCHAR(12), rs.DateOfBirth, 101)
FROM #ResultSet rs


--SELECT @PageNumber AS PageNumber  
-- ,ISNULL(MAX(PageNumber), 0) AS NumberOfPages  
-- ,ISNULL(MAX(RowNumber), 0) AS NumberOfRows  
-- ,'T' AS ArrayList  
--FROM ListPageSCClientLists  
--WHERE SessionId = @SessionId  
-- AND InstanceId = @InstanceId  
  
IF LOWER(@RowSelectionList) = 'all'  
BEGIN  
 UPDATE #ResultSet  
 SET IsSelected = 1  
END  
ELSE IF LOWER(@RowSelectionList) IN (  
  ''  
  ,'none'  
  )  
BEGIN  
 UPDATE #ResultSet  
 SET IsSelected = 0  
END  
  --W.r.f to task 1355 in Kalamazoo bugs for supporting ALl on Page selection                
ELSE IF LOWER(@RowSelectionList) = ('allonpage')  
BEGIN  
 CREATE TABLE #RowSelectionAll (  
  ClientId INT  
  ,IsSelected BIT  
  )  
  
 INSERT INTO #RowSelectionAll (  
  ClientId  
  ,IsSelected  
  )  
 SELECT ClientId  
  ,1  
 FROM #ResultSet  
 
  
 UPDATE #ResultSet  
 SET IsSelected = a.IsSelected  
 FROM #RowSelectionAll a  
 WHERE a.ClientId = #ResultSet.ClientId  
END  
  -- Changes End here                
ELSE  
BEGIN  
 CREATE TABLE #RowSelection (  
  ClientId INT  
  ,IsSelected BIT  
  )  
  
 INSERT INTO #RowSelection (  
  ClientId  
  ,IsSelected  
  )  
 SELECT ids  
  ,IsSelected  
 FROM dbo.SplitJSONString(@RowSelectionList, ',')  
  
 UPDATE #ResultSet  
 SET IsSelected = a.IsSelected  
 FROM #RowSelection a  
 WHERE a.ClientId = #ResultSet.ClientId  
END  



;WITH Counts
		AS (SELECT Count(*) AS TotalRows
			FROM #ResultSet)
			,RankResultSet
		AS (SELECT ClientId
					,ClientName
					,ClientAge
					,ClientSex
					,ClientRace
					,ClientReminderId
					,ReminderDate
					,PrimaryDiagnosis
					,PrimaryDiagnosisDescription
					,DiagnosisDocumentId
					,IsSelected
					,Diagnosis
					,DiagnosisDescription
					,DiagnosisDate
					,Medication
					,MedicationDate
					,Allergy
					,AllergyDate
					,DateOfBirth
					,Ethnicity
					,HealthDataElement
					,HealthDataValue
					,HealthDataDate
					,CommunicationPreference
					,CommunicationPreferenceDate
					,DemographicsDate
				,Count(*) OVER () AS TotalCount
				,ROW_NUMBER() OVER ( ORDER BY CASE	WHEN @SortExpression = 'ClientID'		 THEN ClientId       END
											,CASE	WHEN @SortExpression = 'ClientID desc'   THEN ClientId	   END DESC
											,CASE	WHEN @SortExpression = 'ClientName'      THEN ClientName	   END
											,CASE	WHEN @SortExpression = 'ClientName desc' THEN ClientName	   END DESC
											,CASE	WHEN @SortExpression = 'ClientAge'       THEN ClientAge	   END
											,CASE	WHEN @SortExpression = 'ClientAge desc'  THEN ClientAge	   END DESC
											,CASE	WHEN @SortExpression = 'ClientSex'       THEN ClientSex	   END
											,CASE	WHEN @SortExpression = 'ClientSex desc'  THEN ClientSex      END DESC
											,CASE	WHEN @SortExpression = 'Race'	         THEN ClientRace	   END
											,CASE	WHEN @SortExpression = 'Race desc'		 THEN ClientRace	   END DESC
											,CASE	WHEN @SortExpression = 'ReminderDate'	 THEN ReminderDate	END
											,CASE 	WHEN @SortExpression = 'ReminderDate desc'	THEN ReminderDate	END DESC
											,CASE 	WHEN @SortExpression = 'PrimaryDiagnosis'	THEN PrimaryDiagnosis	END
											,CASE	WHEN @SortExpression = 'PrimaryDiagnosis desc' THEN PrimaryDiagnosis	END DESC
											,CASE	WHEN @SortExpression = 'PrimaryDiagnosisDescription'  THEN PrimaryDiagnosisDescription	END
											,CASE	WHEN @SortExpression = 'PrimaryDiagnosisDescription desc'	THEN PrimaryDiagnosisDescription	END DESC
											,CASE	WHEN @SortExpression = 'IsSelected'			THEN IsSelected	END
											,CASE 	WHEN @SortExpression = 'IsSelected desc'	THEN IsSelected	END DESC
											,CASE 	WHEN @SortExpression = 'Diagnosis'			THEN Diagnosis	END
											,CASE 	WHEN @SortExpression = 'Diagnosis desc'		THEN Diagnosis	END DESC
											,CASE 	WHEN @SortExpression = 'DiagnosisDescription'	THEN DiagnosisDescription	END
											,CASE 	WHEN @SortExpression = 'DiagnosisDescription desc'	THEN DiagnosisDescription	END DESC
											,CASE 	WHEN @SortExpression = 'DiagnosisDate'	THEN DiagnosisDate	END
											,CASE 	WHEN @SortExpression = 'DiagnosisDate desc'	THEN DiagnosisDate	END DESC
											,CASE 	WHEN @SortExpression = 'Medication'	THEN Medication	END
											,CASE 	WHEN @SortExpression = 'Medication desc'	THEN Medication	END DESC
											,CASE	WHEN @SortExpression = 'MedicationDate'	THEN MedicationDate	END
											,CASE 	WHEN @SortExpression = 'MedicationDate desc'	THEN MedicationDate	END DESC
											,CASE 	WHEN @SortExpression = 'Allergy'	THEN Allergy	END
											,CASE	WHEN @SortExpression = 'Allergy desc'	THEN Allergy	END DESC
											,CASE 	WHEN @SortExpression = 'AllergyDate'	THEN AllergyDate	END
											,CASE	WHEN @SortExpression = 'AllergyDate desc'	THEN AllergyDate	END DESC
											,CASE 	WHEN @SortExpression = 'DateOfBirth'	THEN DateOfBirth	END
											,CASE 	WHEN @SortExpression = 'DateOfBirth desc'	THEN DateOfBirth	END DESC
											,CASE 	WHEN @SortExpression = 'Ethnicity'	THEN Ethnicity	END
											,CASE 	WHEN @SortExpression = 'Ethnicity desc'		THEN Ethnicity	END DESC
											,CASE 	WHEN @SortExpression = 'HealthDataElement'		THEN HealthDataElement	END
											,CASE 	WHEN @SortExpression = 'HealthDataElement desc'	THEN HealthDataElement	END DESC
											,CASE	WHEN @SortExpression = 'HealthDataValue'	THEN HealthDataValue	END
											,CASE	WHEN @SortExpression = 'HealthDataValue desc'		THEN HealthDataValue	END DESC
											,CASE 	WHEN @SortExpression = 'HealthDataDate'	THEN HealthDataDate	END
											,CASE 	WHEN @SortExpression = 'HealthDataDate desc'		THEN HealthDataDate	END DESC
											,CASE 	WHEN @SortExpression = 'CommunicationPreference'	THEN CommunicationPreference	END
											,CASE 	WHEN @SortExpression = 'CommunicationPreference desc'	THEN CommunicationPreference		END DESC
											,CASE 	WHEN @SortExpression = 'CommunicationPreferenceDate'	THEN CommunicationPreferenceDate	END
											,CASE 	WHEN @SortExpression = 'CommunicationPreferenceDate desc'	THEN CommunicationPreferenceDate	END DESC
											,CASE 	WHEN @SortExpression = 'DemographicsDate'	THEN DemographicsDate END
											,CASE	WHEN @SortExpression = 'DemographicsDate desc'	THEN DemographicsDate	END DESC
											,ClientId
										) AS RowNumber
			FROM #ResultSet	)
		SELECT TOP (CASE WHEN (@PageNumber = - 1)
						THEN (SELECT Isnull(TotalRows, 0) FROM Counts)
					ELSE (@PageSize)
					END
				) ClientId
					,ClientName
					,ClientAge
					,ClientSex
					,ClientRace
					,ClientReminderId
					,ReminderDate
					,PrimaryDiagnosis
					,PrimaryDiagnosisDescription
					,DiagnosisDocumentId
					,IsSelected
					,Diagnosis
					,DiagnosisDescription
					,DiagnosisDate
					,Medication
					,MedicationDate
					,Allergy
					,AllergyDate
					,DateOfBirth
					,Ethnicity
					,HealthDataElement
					,HealthDataValue
					,HealthDataDate
					,CommunicationPreference
					,CommunicationPreferenceDate
					,DemographicsDate
			,TotalCount
			,RowNumber
		INTO #FinalResultSet
		FROM RankResultSet
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize)

		IF (SELECT Isnull(Count(*), 0)	FROM #FinalResultSet) < 1
		BEGIN
			SELECT 0 AS PageNumber
				,0 AS NumberOfPages
				,0 NumberofRows
				,'T' AS ArrayList 
		END
		ELSE
		BEGIN
			SELECT TOP 1 @PageNumber AS PageNumber
				,CASE (Totalcount % @PageSize)
					WHEN 0
						THEN Isnull((Totalcount / @PageSize), 0)
					ELSE Isnull((Totalcount / @PageSize), 0) + 1
					END AS NumberOfPages
				,Isnull(Totalcount, 0) AS NumberofRows
				,'T' AS ArrayList 
			FROM #FinalResultSet
		END

		SELECT  
			ClientId AS ClientId  
			,a.ClientName AS ClientName  
			,a.ClientAge AS ClientAge  
			,a.ClientSex AS ClientSex  
			,a.ClientRace AS ClientRace  
			,a.ClientReminderId AS ClientReminderId  
			,CONVERT(VARCHAR(12), a.ReminderDate, 101) AS ReminderDate  
			,a.PrimaryDiagnosis AS PrimaryDiagnosis  
			,a.PrimaryDiagnosisDescription AS PrimaryDiagnosisDescription  
			,a.DiagnosisDocumentId AS DiagnosisDocumentId  
			,a.IsSelected AS IsSelected  
			,a.Diagnosis AS Diagnosis  
			,a.DiagnosisDescription AS DiagnosisDescription  
			,a.DiagnosisDate AS DiagnosisDate  
			,  
			-- CONVERT(VARCHAR(12), a.DiagnosisDate, 101) AS DiagnosisDate ,            
			mmn.MedicationName AS Medication  
			,a.MedicationDate AS MedicationDate  
			,  
			--CONVERT(VARCHAR(12), a.MedicationDate, 101) AS MedicationDate ,            
			mac.ConceptDescription AS Allergy  
			,a.AllergyDate AS AllergyDate  
			,  
			-- CONVERT(VARCHAR(12), a.AllergyDate, 101) AS AllergyDate ,            
			CONVERT(VARCHAR(12), a.DateOfBirth, 101) AS DateOfBirth  
			,ethnicity.CodeName AS Ethnicity  
			,hda.NAME AS HealthDataElement  
			,a.HealthDataValue AS HealthDataValue  
			,a.HealthDataDate AS HealthDataDate  
			,  
			-- CONVERT(VARCHAR(12), a.HealthDataDate, 101) AS HealthDataDate ,            
			commpref.CodeName AS CommunicationPreference  
			,CASE   
			WHEN commpref.CodeName IS NULL  
			THEN NULL  
			ELSE a.CommunicationPreferenceDate  
			END AS CommunicationPreferenceDate  
			,DemographicsDate  
		FROM #FinalResultSet a
		LEFT JOIN dbo.MDMedicationNames mmn ON mmn.MedicationNameId = a.Medication  
		 AND ISNULL(mmn.RecordDeleted, 'N') = 'N'  
		LEFT JOIN dbo.MDAllergenConcepts mac ON mac.AllergenConceptId = a.Allergy  
		 AND ISNULL(mac.RecordDeleted, 'N') = 'N'  
		LEFT JOIN GlobalCodes ethnicity ON ethnicity.GlobalCodeId = a.Ethnicity  
		 AND ethnicity.Active = 'Y'  
		 AND ISNULL(ethnicity.RecordDeleted, 'N') = 'N'  
		LEFT JOIN dbo.HealthDataAttributes hda ON hda.HealthDataAttributeId = a.HealthDataElement  
		 AND ISNULL(hda.RecordDeleted, 'N') = 'N'  
		LEFT JOIN GlobalCodes commpref ON commpref.GlobalCodeId = a.CommunicationPreference  
		 AND commpref.Active = 'Y'  
		 AND ISNULL(commpref.RecordDeleted, 'N') = 'N'  
		ORDER BY RowNumber
		
	END TRY
	
	 BEGIN CATCH
          DECLARE @error VARCHAR(8000)

          SET @error= CONVERT(VARCHAR, Error_number()) + '*****'
                      + CONVERT(VARCHAR(4000), Error_message())
                      + '*****'
                      + Isnull(CONVERT(VARCHAR, Error_procedure()),
                      'ssp_ListPageSCClientLists')
                      + '*****' + CONVERT(VARCHAR, Error_line())
                      + '*****' + CONVERT(VARCHAR, Error_severity())
                      + '*****' + CONVERT(VARCHAR, Error_state())

          RAISERROR (@error,-- Message text.
                     16,-- Severity.
                     1 -- State.
          );
      END CATCH
  END 
