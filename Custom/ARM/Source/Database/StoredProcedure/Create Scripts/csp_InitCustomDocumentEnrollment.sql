/****** Object:  StoredProcedure [dbo].[csp_InitCustomDocumentEnrollment]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentEnrollment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomDocumentEnrollment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentEnrollment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE	PROCEDURE  [dbo].[csp_InitCustomDocumentEnrollment]
(
 @ClientID int,
 @StaffID int,
 @CustomParameters xml
)
AS

SELECT	TOP 1 ''CustomDocumentEnrollment'' AS TableName,
		-1 AS ''DocumentVersionId'',
		'''' as CreatedBy,
		getdate() as CreatedDate,
		'''' as ModifiedBy,
		getdate() as ModifiedDate,
		
		UPPER(C.LastName) AS ''LastName'',
		UPPER(C.FirstName) AS ''FirstName'',
		UPPER(SUBSTRING(C.MiddleName, 1, 1)) AS ''MiddleName'',
		C.DOB,
		C.Sex,
		UPPER(CA.Address) AS ''Address'',
		UPPER(CA.City) AS ''City'',
		UPPER(CA.State) AS ''State'',
		RTRIM(CA.Zip) AS ''Zip'',
		Coalesce(CP.PhoneNumber, CP2.PhoneNumber) AS ''HomePhoneNumber'',
		Coalesce(CP3.PhoneNumber, CP4.PhoneNumber) AS ''BusinessPhoneNumber'',
		CR1.RaceId AS ''Race'',
		CC.Ethnicity as ''Ethnic'',
		C.MaritalStatus,
		
		C.SSN,
		UPPER(RTRIM(Counties.CountyName)) AS ''CountyOfResidence'',

		C.NumberOfDependents,
		CASE	C.AnnualHouseholdIncome
				WHEN	''999999.99''
				THEN	NULL
				ELSE	C.AnnualHouseholdIncome
		END	AS	''AnnualHouseholdIncome'',
		
		DI1.DSMCode AS ''PrimaryDX'',
		DI1.Axis AS ''PrimaryAxis'',
		DI2.DSMCode AS ''SecondaryDX'',
		DI2.Axis AS ''SecondaryAxis'',
		S.DateOfService AS ''DXAssessmentDate''
FROM		Clients C
LEFT JOIN	ClientAddresses CA
ON			C.ClientId = CA.ClientId
LEFT JOIN	ClientPhones CP
ON			C.ClientId = CP.ClientId
AND			CP.PhoneType = 30	-- Home Phone 1
LEFT JOIN	ClientPhones CP2
ON			C.ClientId = CP2.ClientId
AND			CP.PhoneType = 32	-- Home Phone 2
LEFT JOIN	ClientPhones CP3
ON			C.ClientId = CP3.ClientId
AND			CP3.PhoneType = 31	-- Work Phone 1
LEFT JOIN	ClientPhones CP4
ON			C.ClientId = CP4.ClientId
AND			CP4.PhoneType = 33	-- Work Phone 2
LEFT JOIN	ClientRaces CR1
ON			C.ClientId = CR1.ClientId
LEFT JOIN	Counties
ON			C.CountyOfResidence = Counties.CountyFIPS

LEFT JOIN	CustomClients CC
ON			C.ClientId = CC.ClientId

LEFT JOIN	Services S
ON			C.ClientId = S.ClientId
AND			S.ProcedureCodeId = ''24''	-- Assessment
AND			S.Status = ''75''	-- Complete
AND			ISNULL(S.RecordDeleted, ''N'') <> ''Y''
AND			S.DateOfService =	(	SELECT	MAX(S2.DateOfService)
									FROM	Services S2
									WHERE	S.ClientId = S2.ClientId
									AND		S2.ProcedureCodeId = ''24''	-- Assessment
									AND		S2.Status = ''75''	-- Complete
									AND		ISNULL(S2.RecordDeleted, ''N'') <> ''Y''
								)

LEFT JOIN	Documents D
ON			C.ClientId = D.ClientId
AND			D.DocumentCodeId = 5 --Diagnosis Document
AND			D.Status = 22 -- Signed
AND			D.EffectiveDate =	(	SELECT	MAX(D2.EffectiveDate)
									FROM	Documents D2
									WHERE	D.ClientId = D2.ClientId
									AND		D2.DocumentCodeId = 5 --Diagnosis Document
									AND		D2.Status = 22 -- Signed
									AND		ISNULL(D2.RecordDeleted, ''N'') <> ''Y''
								)
AND			ISNULL(D.RecordDeleted, ''N'') <> ''Y''
								
LEFT JOIN	DiagnosesIAndII DI1
ON			D.CurrentDocumentVersionId = DI1.DocumentVersionId
AND			DI1.DiagnosisType = 140	--Primary Diagnosis
AND			ISNULL(DI1.RuleOut, ''N'') <> ''Y''
AND			ISNULL(DI1.RecordDeleted, ''N'') <> ''Y''

LEFT JOIN	DiagnosesIAndII DI2
ON			D.CurrentDocumentVersionId = DI2.DocumentVersionId
AND			DI2.DiagnosisType = 142	-- Additional Diagnosis
AND			ISNULL(DI2.RuleOut, ''N'') <> ''Y''
AND			ISNULL(DI2.RecordDeleted, ''N'') <> ''Y''
AND			DI2.DiagnosisOrder =	(	SELECT	MIN(DI3.DiagnosisOrder)
										FROM	DiagnosesIAndII DI3
										WHERE	DI2.DocumentVersionId = DI3.DocumentVersionId
										AND			DI3.DiagnosisType = 142	-- Additional Diagnosis
										AND			ISNULL(DI3.RuleOut, ''N'') <> ''Y''
										AND			ISNULL(DI3.RecordDeleted, ''N'') <> ''Y''
									)
										

WHERE	@ClientID = C.ClientId
' 
END
GO
