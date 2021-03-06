/****** Object:  StoredProcedure [dbo].[csp_InitCustomDocumentIntakeInterview]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentIntakeInterview]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomDocumentIntakeInterview]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentIntakeInterview]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE	PROCEDURE  [dbo].[csp_InitCustomDocumentIntakeInterview]
(
 @ClientID int,
 @StaffID int,
 @CustomParameters xml
)
AS

SELECT	TOP 1 ''CustomDocumentIntakeInterview'' AS TableName,
		-1 AS ''DocumentVersionId'',
		'''' as CreatedBy,
		getdate() as CreatedDate,
		'''' as ModifiedBy,
		getdate() as ModifiedDate,
		C.LastName,
		C.FirstName,
		CA.Address,
		CA.City,
		CA.State,
		RTRIM(CA.Zip) AS ''Zip'',
		RTRIM(Counties.CountyName) AS ''County'',
		Coalesce(CP.PhoneNumber, CP2.PhoneNumber) AS ''HomePhoneNumber'',
		CP3.PhoneNumber AS ''AlternatePhoneNumber'',
		C.Email,
		C.SSN,
		C.DOB,
		GC.GlobalCodeId AS ''Sex'',
		Alias.LastName AS ''AliasLastName'',
		Alias.FirstName AS ''AliasFirstName'',
		C.MaritalStatus,
		CASE	WHEN	CR1.ClientRaceId IS NOT NULL
				THEN	''Y''
				ELSE	''N''
		END AS ''EthnicityIndian'',
		CASE	WHEN	CR2.ClientRaceId IS NOT NULL
				THEN	''Y''
				ELSE	''N''
		END AS ''EthnicityAlaskan'',
		CASE	WHEN	CR3.ClientRaceId IS NOT NULL
				THEN	''Y''
				ELSE	''N''
		END AS ''EthnicityAsian'',
		CASE	WHEN	CR4.ClientRaceId IS NOT NULL
				THEN	''Y''
				ELSE	''N''
		END AS ''EthnicityBlack'',
		CASE	WHEN	CR5.ClientRaceId IS NOT NULL
				THEN	''Y''
				ELSE	''N''
		END AS ''EthnicityHawaiian'',
		CASE	WHEN	CR6.ClientRaceId IS NOT NULL
				THEN	''Y''
				ELSE	''N''
		END AS ''EthnicityCaucasian'',
		CASE	WHEN	CR7.ClientRaceId IS NOT NULL
				THEN	''Y''
				ELSE	''N''
		END AS ''EthnicityMultiRacial'',
		CASE	WHEN	CR8.ClientRaceId IS NOT NULL
				THEN	''Y''
				ELSE	''N''
		END AS ''EthnicityOther'',
		CASE	WHEN	CR9.ClientRaceId IS NOT NULL
				THEN	''Y''
				ELSE	''N''
		END AS ''EthnicityUnknown'',
		CC.LastName AS ''GuardianLastName'',
		CC.FirstName AS ''GuardianFirstName'',
		CCP.PhoneNumber AS ''GuardianPhoneNumber'',
		CC2.LastName AS ''EmergencyContactLastName'',
		CC2.FirstName AS ''EmergencyContactFirstName'',
		CCP3.PhoneNumber AS ''EmergencyContactPhoneNumber''
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
AND			CP3.PhoneType NOT IN (''30'', ''32'')	-- Home Phone 1 and 2
AND			CP3.PhoneType = (SELECT MIN(CP4.PhoneType) FROM ClientPhones CP4 WHERE CP3.ClientId = CP4.ClientId AND CP4.PhoneType NOT IN (''30'', ''32''))	-- Home Phone 1 and 2
LEFT JOIN	Counties
ON			C.CountyOfResidence = Counties.CountyFIPS
LEFT JOIN	GlobalCodes GC
ON			C.Sex = GC.ExternalCode1
AND			GC.Category = ''xddgender''
LEFT JOIN	ClientAliases Alias
ON			C.ClientId = Alias.ClientId
AND			Alias.AliasType <> 4221 -- Real Name
AND			Alias.ClientAliasId =	(	SELECT	MIN(Alias2.ClientAliasId)
										FROM	ClientAliases Alias2
										WHERE	C.ClientId = Alias2.ClientId
										AND		Alias2.AliasType <> 4221 -- Real Name
									)
LEFT JOIN	ClientRaces CR1
ON			C.ClientId = CR1.ClientId
AND			CR1.RaceId = 20443 -- American Indian
LEFT JOIN	ClientRaces CR2
ON			C.ClientId = CR2.ClientId
AND			CR2.RaceId = 20540 -- Alaskan Native
LEFT JOIN	ClientRaces CR3
ON			C.ClientId = CR3.ClientId
AND			CR3.RaceId = 20557 -- Asian
LEFT JOIN	ClientRaces CR4
ON			C.ClientId = CR4.ClientId
AND			CR4.RaceId = 20562 -- Black or African American
LEFT JOIN	ClientRaces CR5
ON			C.ClientId = CR5.ClientId
AND			CR5.RaceId = 20572 -- Native Hawaiian or Other Pacific Islander
LEFT JOIN	ClientRaces CR6
ON			C.ClientId = CR6.ClientId
AND			CR6.RaceId = 20578 -- White
LEFT JOIN	ClientRaces CR7
ON			C.ClientId = CR7.ClientId
AND			CR7.RaceId = 20583 -- Multi-Racial
LEFT JOIN	ClientRaces CR8
ON			C.ClientId = CR8.ClientId
AND			CR8.RaceId = 20586 -- Other
LEFT JOIN	ClientRaces CR9
ON			C.ClientId = CR9.ClientId
AND			CR9.RaceId = 20593 -- Unknown
LEFT JOIN	ClientContacts CC
ON			C.ClientId = CC.ClientId
AND			CC.Guardian = ''Y''
LEFT JOIN	ClientContactPhones CCP
ON			CC.ClientContactId = CCP.ClientContactId
AND			CCP.PhoneType = (	SELECT	MIN(CCP2.PhoneType)
								FROM	ClientContactPhones CCP2
								WHERE	CCP.ClientContactId = CCP2.ClientContactId
							)
LEFT JOIN	ClientContacts CC2
ON			C.ClientId = CC2.ClientId
AND			CC2.EmergencyContact = ''Y''
LEFT JOIN	ClientContactPhones CCP3
ON			CC2.ClientContactId = CCP3.ClientContactId
AND			CCP3.PhoneType = (	SELECT	MIN(CCP4.PhoneType)
								FROM	ClientContactPhones CCP4
								WHERE	CCP3.ClientContactId = CCP4.ClientContactId
							)
							
WHERE	@ClientID = C.ClientId
' 
END
GO
