IF EXISTS ( SELECT	*
			FROM	sys.objects
			WHERE	object_id = OBJECT_ID(N'[dbo].[ssp_SureScriptsGetPendingNewRxRequests]')
					AND type IN ( N'P', N'PC' ) ) 
	DROP PROCEDURE ssp_SureScriptsGetPendingNewRxRequests
GO


/****** Object:  StoredProcedure [dbo].[ssp_SureScriptsGetPendingNewRxRequests]    Script Date: 12/17/2013 9:39:30 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[ssp_SureScriptsGetPendingNewRxRequests]
AS /*****************************************************************************************************/
/*
Stored Procedure: dbo.ssp_SureScriptsGetPendingNewRxRequests

Copyright: 2011 Streamline Healthcare Solutions, LLC

Creation Date:  2011.03.04

Purpose:
	Get new medication orders that have not been sent to Surescripts yet.

Input Parameters: None

Output Parameters:

Return:
	Data table with format as required by windows service

Calls:

Called by:
	Surescripts Client Windows Service

Log:
	2011.03.04 - Created.

7/16/2013 - kalpers added DEANumber, NPI for prescriber
7/16/2013 - kalpers changed the date from 20130101 to 2013-01-01
9/5/2013  - Kalpers changed the date written to use the function ssp_SureScriptsGetPendingNewRxRequests
9/14/2013 - Kalpers added RelatesToMessageID
9/16/2013 - Kalpers added PotencyUnitCode
12/10/2013 - Kalpers nulled out prescriber license number because some pharmacies are only 4.x
12/17/2013 - Kalpers changed the custom function csf_SurescriptsXMLCharReplace to ssf_SurescriptsXMLCharReplace to handle the max characters
10/29/2014 - Wasif Butt	Added Pharmacy NPI, split the prescriber address into address 1 and address 2, added drug database identifier 
7/20/2015 -	Wasif Butt	BenefitsCoordination on NewRx for formulary
10/01/2015 - Wasif Butt	Diagnosis selection on medicationscripts
11/04/2015 - Wasif Butt	Change ICD10Code character limit to 20
11/17/2015 - Wasif Butt	Change PlanName character limit to 100
11/25/2015 - Wasif Butt	Update diagnosis join to DSM based on varchar match instead of int
06/27/2016 - Wasif Butt	change quantity qualifier to 3 chars
12/23/2016 - Pranay		added NADEA Number and DEA Number
12/23/2016 - Nandita	SI Flag for Digital Siganture on file.
12/27/2016 - Wasif Butt	Added DEA Schedule for EPCS
12/27/2016 - Wasif Butt	When NADEA Number is present we need to include/append that on Notes to Pharmacy along with prescriber notes to pharmacy. Per SureScripts guidelines format should be "NADEAN:Numberhere - PrescriberNotes".
05/25/2017 - Robert Caffrey - Harbor Support #1396 - Send Prescriber License Number when Value Confiuration Key SurescriptsAlwaysSendPrescriberLicense is Y
10/22/2017- Added By Pranay w.r.t MU Change
11/08/2017 - Nandita Added logic to check if atleast one phone is present for a client and not just 'Home' type
11/10/2017 - Wasif Butt Send diagnosis code instead of diagnosis decimal code	
11/13.2017-  PranayB  Added LEFT JOIN dbo.Locations AS ag ON ag.LocationId = cms.LocationId in order to get the prescribing location from the locations table but not the agent table.
12/15/2017-  PranayB Added ca.AddressType logic w.r.t CEI-SupportGoLive Task#854
12/18/2017-  PranayB Added ca.AddressType OrderBy w.r.t CEI -support Task#854
01/05/2018-PranayB   Added PhoneNumnerType w.r.t Task#928 KCMH
01/22/3018 -PranayB  Added left JOIN Locations AS l ON l.LocationId = cms.LocationId w.r.t Task#817
01/31/2018 -PranayB Added  Logic to pull the location properties like add,city,zip from the agency table only when the l.address in not null w.r.t CEI Task#817. 
03/01/2018- Nandita Corrected the Drug Description size to 250 from 35.
05/11/2018- Pranay Bodhu bug changes alias from ca to ca3 for the ClientAddress
09/07/2018 - Pranay Bodhu Added list of drugs under DRU_GHB which need NADEA# w.r.t ps task#115
10/29/2018- Pranay Bodhu replaced ssf_SureScriptsAddressElement(l.[Address], 1, 'Y') to ssf_SureScriptsAddressElement(l.[Address], 2, 'Y') w.r.t Sure-Scripts Task# 7 
12/17/2018- Pranay Bodhu Added ISNULL(cmi.Active,'N')='Y' w.r.t Boundless - Support: #367
,*/

/*****************************************************************************************************/
	BEGIN TRY

		DECLARE	@STATUSPENDING INT,
			@STATUSINQUEUE INT
		SET @STATUSPENDING = 5562
		SET @STATUSINQUEUE = 5561

		BEGIN TRAN

		DECLARE	@results TABLE
			(
			  ClientMedicationScriptActivityId INT,
			  RXREFERENCENUMBER VARCHAR(35),		--PHARMACY RX REFERENCE NUMBER SENT IN NEWRX RESPONSE FOR REFILL REQUEST
			  PRESCRIBER_OREDERNO VARCHAR(35),  --PRESCRIBER OREDER NUMBER TRACK PRESCIPTION ORDER NO IN PRESCRIBER SOFTWARE SYSTEM

	  --PHARMACY DETAILS
			  NCPDPID VARCHAR(35),  --ID OF THE  PHARMACY
			  STORENAME VARCHAR(35),  --NAME OF THE PHARMACY STORE
			  PHARMACY_ADDRESS1 VARCHAR(35),  --PRIMARY ADDRESS OF PHARMACY
			  PHARMACY_ADDRESS2 VARCHAR(35),  --ADDRESS LINE2 OF PHARMACY
			  PHARMACY_CITY VARCHAR(35),  --PHARMACY CITY
			  PHARMACY_STATE VARCHAR(2),  --PHARMACY STATE
			  PHARMACY_ZIPCODE VARCHAR(9),  --PHARMACY ZIP CODE
			  PHARMACY_EMAIL VARCHAR(80),  --PHARMACY EMAIL
			  PHARMACY_TE VARCHAR(25),  --PHARMACY PRIMARY PHONE_NO
			  PHARMACY_FX VARCHAR(25),  --PHARMACY PRIMARY FAX NO
  			  PHARMACY_NPI varchar(10), --PHARMACY NPI 
-- PRESCRIBER DETAILS
			  PRESCRIBER_SPI VARCHAR(35),  --SPI ID OF THE PRESCRIBER GIVEN AT THE TIME OF REGISTRATION
			  PRESCRIBER_LICENSE VARCHAR(35),
			  PRESCRIBER_DEA_NUMBER VARCHAR(30),
			  PRESCRIBER_NADEA_NUMBER VARCHAR(30),
			  PRESCRIBER_NATIONAL_PROVIDER_ID VARCHAR(10),
			  PRESCRIBER_CLINIC_NAME VARCHAR(35),  --PRESCRIBER CLINIC NAME
			  PRESCRIBER_LASTNAME VARCHAR(35),  --PRESCRIBER LASTNAME
			  PRESCRIBER_MIDDLENAME VARCHAR(35),
			  PRESCRIBER_FIRSTNAME VARCHAR(35),  --PRESCRIBER FIRSTNAME
			  PRESCRIBER_NAME_PREFIX VARCHAR(10),
			  PRESCRIBER_SPECIALITY_QUALIFIER VARCHAR(2),  --PRESCRIBER SPECIALITY CODE QUALIFIER LIKE DE(DRUG ENFORCEMENT AGENCY) OR AM(AMERICAN MEDICAL ASSOCIATION)
			  PRESCRIBER_SPECIALITY_CODE VARCHAR(10),  --PRESCRIBER SPECIALITY CODE(AMA OR DEA SPECIALITY CODE)
			  PRESCRIBER_ADDRESS1 VARCHAR(35),  --PRESCRIBER PRIMARY ADDRESS
			  PRESCRIBER_ADDRESS2 VARCHAR(35),
			  PRESCRIBER_CITY VARCHAR(35),  --PRESCRIBER CITY
			  PRESCRIBER_STATE VARCHAR(2),  --PRESCRIBER STATE
			  PRESCRIBER_ZIPCODE VARCHAR(9),  --PRESCRIBER ZIPCODE
			  PRESCRIBER_EMAIL VARCHAR(80),  --PRESCRIBER EMAIL
			  PRESCRIBER_TE VARCHAR(25),  --PHARMACY PRIMARY PHONE_NO
			  PRESCRIBER_FX VARCHAR(35),  --PHARMACY PRIMARY FAX NO
			  AGENT_FIRST_NAME VARCHAR(35), -- prescribing agent first name
			  AGENT_LAST_NAME VARCHAR(35),  -- prescribing agent last name
			  SUPERVISOR_NATIONAL_PROVIDER_ID VARCHAR(10),
			  SUPERVISOR_LASTNAME VARCHAR(35), -- SUPERVISOR LASTNAME
			  SUPERVISOR_MIDDLENAME VARCHAR(35), -- SUPERVISOR MIDDLENAME
			  SUPERVISOR_FIRSTNAME VARCHAR(35),-- SUPERVISOR FIRSTNAME
			  SUPERVISOR_NAME_PREFIX VARCHAR(35),
			  SUPERVISOR_DEA_NUMBER VARCHAR(30),
			  SUPERVISOR_ADDRESS1 VARCHAR(35),  --SUPERVISOR PRIMARY ADDRESS
			  SUPERVISOR_ADDRESS2 VARCHAR(35),
			  SUPERVISOR_CITY VARCHAR(35),  --SUPERVISOR CITY
			  SUPERVISOR_STATE VARCHAR(2),  --SUPERVISOR STATE
			  SUPERVISOR_ZIPCODE VARCHAR(9),  --SUPERVISOR ZIPCODE
			  SUPERVISOR_TE VARCHAR(25),  --SUPERVISOR PRIMARY PHONE_NO
			  SUPERVISOR_FX VARCHAR(35),  --SUPERVISOR PRIMARY FAX NO

--PATIENT DETAILS
			  PATIENT_FILE_ID VARCHAR(35),  --PATIENT FILEID.ANY UNIQUE ID GIVEN TO A PATIENT FORM THE APPLICATION
			  PATIENT_LASTNAME VARCHAR(35),  --PATIENT LASTNAME
			  PATIENT_MIDDLENAME VARCHAR(35),
			  PATIENT_FIRSTNAME VARCHAR(35),  --PATIENT FIRSTNAME
			  PATIENT_GENDER CHAR(1),  --PATIENT GENDER
			  PATIENT_DOB VARCHAR(10),  --PATIENT DATE OF BIRTH
			  PATIENT_ADDRESS1 VARCHAR(35),   --PATIENT PRIMARY ADDRESS
			  PATIENT_ADDRESS2 VARCHAR(35),
			  PATIENT_CITY VARCHAR(35),  --PATIENT CITY
			  PATIENT_STATE VARCHAR(2),  --PATIENT STATE
			  PATIENT_ZIPCODE VARCHAR(9),  --PATIENT ZIPCODE
			  PATIENT_EMAIL VARCHAR(80),  --PATIENT EMAIL
			  PATIENT_TE VARCHAR(25),  --PATIENT TELEPHONE
			  PATIENT_CP VARCHAR(25),  --PATIENT CELLULAR PHONE NO

--MEDICATION DETAILS
			  DRUG_DESCRIPTION VARCHAR(105),  --DESCRIPTION OF THE DRUG MUST CONTAIN DRUG NAME,FORM AND STRENGTH i,e Zoloft 50 mg tablets

-- Optional elements
			  PRODUCT_CODE VARCHAR(35),  --DRUG CODE
			  PRODUCT_CODE_QUALIFIER VARCHAR(3),  --DRUG CODE QUALIFIER LIKE ND FOR NDC
			  DOSAGE_FORM VARCHAR(10),   --DRUG DOSAGE FORM
			  STRENGTH VARCHAR(70),  --STRENGTH OF THE DRUG
			  STRENGTH_UNITS VARCHAR(35),  --UNITS OF STRENGTH
	  -- End Optional elements
			  DRUG_QUANTITY_QUALIFIER VARCHAR(3),  --UNITS OF MEASURE LIKE U2 FOR TABLET AND ZZ MUTUALLY DEFINED i,e NOT DEFINED IN TABLE
			  DRUG_QUANTITY_VALUE FLOAT,  --MEASURE VALUE LIKE 20 OF U2(TABLETS)
			  DRUG_DAYS_SUPPLY INT,  --PRESCRIBER OREDER DAYS SUPPLY
			  DRUG_DIRECTIONS VARCHAR(MAX), -- VARCHAR(140) ,  --DIRECTIONS FOR PATIENT TO TAKE THE DRUG
			  DRUG_NOTE VARCHAR(MAX), --VARCHAR(210) ,  --NOTE ADDED FOR THIS MEDICATION
  			  DRU_DEA_SCHEDULE varchar(6),	--SCHEDULE OF DRUG MUST CONATIN DEA SCHEDULE FOR CONTROLLED SUBSTANCES FOR EPCS
			  DRU_SI_FLAG CHAR(1),	--DIGITAL SIGNATURE RECORDED
			  DRU_GHB CHAR(1), --Gammahydroxybutyric acid REQUIRES NADEA AND PRATITIONER NOTES

--REFILLS DETAILS
			  REFILL_QUALIFIER CHAR(1),  -- we do not allow PRN refills  --REFILL QUALIFIER "R" OR "PRN"
			  REFILL_QUANTITY INT,  --REFILL QUANTITY
			  SUBSTITUTIONS CHAR(1),  --SUBSTTUTIONS ALLOWED i,e 0(SUBSTITUTION ALLOWED) OR 1(SUBSTITUTION NOT ALLOWED)  FOR NEWRX
			  WRITTEN_DATE VARCHAR(10),  --PRESCRIBER WTORE THE PRESCRIPTION DATE
			  EFFECTIVE_DATE varchar(10), --PRESCRIBER WANTS TO START THE MEDICATION EFFECTIVE DATE (STARTDATE)
			  LAST_FILL_DATE VARCHAR(8),  --DATE DRUG SHOUD BE TAKEN
			  RELATES_TO_MESSAGEID VARCHAR(35),
			  PotencyUnitCode VARCHAR(35),
			  DRUG_DB_CODE int, -- Meaningfule use requirment to include RxNormCode
			  DrugDBCodeQualifier varchar(30),		--Meaningfule use requirment to RxNormCode TTY

--FORMULARY - NEW RX BENEFITS COORDINATION CHANGES
			  PLAN_NAME varchar(100),		--Plan name on script
			  MUTUALLY_DEFINED varchar(9),		--Mutually defined identifier between eligibility and order
			  PAYER_ID varchar(20),		--PayerId
			  BIN_LOCATION_NUMBER varchar(30),		--BIN location number
			  PAYER_NAME varchar(35),		--PBM Payer Name
			  CARDHOLDER_ID varchar(35),		--Cardholder id
			  CARDHOLDER_LASTNAME varchar(35),		--Cardholder name
			  CARDHOLDER_FIRSTNAME varchar(35),		--cardholder name
			  GROUP_ID varchar(35),		--Group Id
			  PATIENT_PAYER_ID VARCHAR(35),  --PATIENT ID .ANY UNIQUE ID GIVEN TO A PATIENT BY THE PBM PAYER
--DIAGNOSIS - 
			 DIAGNOSIS_CODE varchar(20),
			 DIAGNOSIS_INFERRED_BY int,
			 DIAGNOSIS_QUALIFIER varchar(3)
)

		DECLARE	@ScriptOutput TABLE
			(
			  ClientMedicationScriptId INT,
			  PON VARCHAR(35),
			  RxReferenceNumber VARCHAR(35),
			  DrugDescription VARCHAR(250),
			  SureScriptsQuantityQualifier VARCHAR(3),
			  SureScriptsQuantity DECIMAL(29, 14),
			  TotalDaysInScript INT,
			  ScriptInstructions VARCHAR(MAX), -- VARCHAR(140) ,
			  ScriptNote VARCHAR(MAX), -- VARCHAR(210) ,
			  Refills INT,
			  DispenseAsWritten CHAR(1), -- Y/N
			  OrderDate DATETIME,
			  NDC VARCHAR(35),
			  RelatesToMessageID VARCHAR(35),
			  PotencyUnitCode VARCHAR(35)
			)

-- map the script output to activities
		DECLARE	@ScriptActivityMap TABLE
			(
			  ClientMedicationScriptId INT,
			  ClientMedicationScriptActivityId INT
			)

		DECLARE	@currScriptId INT,
			@currScriptActivityId INT,
			@currLocationId INT


		DECLARE currScripts CURSOR fast_forward
		FOR
			SELECT	cmsa.ClientMedicationScriptId,
					cmsa.ClientMedicationScriptActivityId,
					cms.LocationId
			FROM	ClientMedicationScriptActivities AS cmsa
					JOIN ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = cmsa.ClientMedicationScriptId
			WHERE	cmsa.Method = 'E'
					AND cmsa.Status = @STATUSINQUEUE
					AND ( ( cms.SurescriptsRefillRequestId IS NULL AND cms.SurescriptsChangeRequestId IS NULL) -- Added By Pranay W.r.t ChangeRequest
						  OR ( EXISTS ( SELECT	*
										FROM	SureScriptsRefillRequests AS ssrr
										WHERE	ssrr.SurescriptsRefillRequestId = cms.SurescriptsRefillRequestId
												AND ssrr.StatusOfRequest = 'N'
												AND ISNULL(ssrr.RecordDeleted,
														   'N') <> 'Y' ) )
						)
					AND ISNULL(cms.RecordDeleted, 'N') <> 'Y'
					AND ISNULL(cmsa.RecordDeleted, 'N') <> 'Y'
			ORDER BY cmsa.ClientMedicationScriptActivityId  -- FIFO



		OPEN currScripts

		FETCH currScripts INTO @currScriptId, @currScriptActivityId,
			@currLocationid

		WHILE @@fetch_status = 0 
			BEGIN
   
				INSERT	INTO @ScriptOutput
						( ClientMedicationScriptId,
						  PON,
						  RxReferenceNumber,
						  DrugDescription,
						  SureScriptsQuantityQualifier,
						  SureScriptsQuantity,
						  TotalDaysInScript,
						  ScriptInstructions,
						  ScriptNote,
						  Refills,
						  DispenseAsWritten,
						  OrderDate,
						  NDC,
						  RelatesToMessageID,
						  PotencyUnitCode
                        )
						EXEC scsp_SureScriptsScriptOutput 
							@ClientMedicationScriptId = @currScriptId,
							@PreviewData = 'N'

				UPDATE	ClientMedicationScriptActivities
				SET		Status = @STATUSPENDING
				WHERE	ClientMedicationScriptActivityId = @currScriptActivityId


				INSERT	INTO @ScriptActivityMap
						( ClientMedicationScriptId,
						  ClientMedicationScriptActivityId
                        )
				VALUES	( @currScriptId,
						  @currScriptActivityId
                        )

				FETCH currScripts INTO @currScriptId, @currScriptActivityId,
					@currLocationid

			END

		CLOSE currScripts

		DEALLOCATE currScripts

-- create a results record for every drug strength
		INSERT	INTO @results
				( ClientMedicationScriptActivityId,
				  RXREFERENCENUMBER,
				  PRESCRIBER_OREDERNO,
				  DRUG_DESCRIPTION,
				  DRUG_QUANTITY_QUALIFIER,
				  DRUG_QUANTITY_VALUE,
				  DRUG_DAYS_SUPPLY,
				  DRUG_DIRECTIONS,
				  DRUG_NOTE,
				  REFILL_QUALIFIER,
				  REFILL_QUANTITY,
				  SUBSTITUTIONS,
				  WRITTEN_DATE,
				  PRODUCT_CODE,
				  PRODUCT_CODE_QUALIFIER,
				  RELATES_TO_MESSAGEID,
				  PotencyUnitCode
                )
				SELECT	map.ClientMedicationScriptActivityId,
						so.RxReferenceNumber,
						so.PON,
						so.DrugDescription,
						so.SureScriptsQuantityQualifier,
						so.SureScriptsQuantity,
						so.TotalDaysInScript,
						so.ScriptInstructions,
						so.ScriptNote,
						'R',
						so.Refills,
						CASE WHEN so.DispenseAsWritten = 'Y' THEN '1'
							 ELSE '0'
						END,
						dbo.ssf_SureScriptsFormatDate(GETDATE()), --so.OrderDate) ,
						so.NDC,
						CASE WHEN so.NDC IS NOT NULL THEN 'ND'
							 ELSE NULL
						END,
						RelatesToMessageID,
						so.PotencyUnitCode
				FROM	@ScriptOutput AS so
						JOIN @ScriptActivityMap AS map ON map.ClientMedicationScriptId = so.ClientMedicationScriptId
-- Pharmacy Information
		UPDATE	r
		SET		NCPDPID = p.SureScriptsPharmacyIdentifier,
				STORENAME = ssdp.StoreName,  --ssdp.STORE_NAME , --substring(p.PharmacyName, 1, 35),
				PHARMACY_ADDRESS1 = CASE WHEN REPLACE(ssdp.ADDRESSLine1, ' ',
													  '') = '' THEN ''
										 ELSE ssdp.ADDRESSLine1
									END, --substring(p.Address, 1, 35),
				PHARMACY_ADDRESS2 = CASE WHEN REPLACE(ssdp.ADDRESSLine2, ' ',
													  '') = '' THEN ''
										 ELSE ssdp.ADDRESSLine2
									END, --'',
				PHARMACY_CITY = ssdp.CITY, --substring(p.City, 1, 35),
				PHARMACY_STATE = ssdp.STATE, --p.State,
				PHARMACY_ZIPCODE = ssdp.zip, --ssdp.ZIP_CODE , --p.ZipCode,
--PHARMACY_EMAIL =
				PHARMACY_TE = dbo.ssf_SureScriptsFormatPhone(p.PhoneNumber),
				PHARMACY_FX = dbo.ssf_SureScriptsFormatPhone(p.FaxNumber),
				PHARMACY_NPI = ssdp.NPI
		FROM	@results AS r
				JOIN ClientMedicationScriptActivities AS cmsa ON cmsa.ClientMedicationScriptActivityId = r.ClientMedicationScriptActivityId
				JOIN Pharmacies AS p ON p.PharmacyId = cmsa.PharmacyId
                --JOIN SureScriptsDownloadedPharmacies AS ssdp ON ssdp.NCPDP_NO = p.SureScriptsPharmacyIdentifier
				JOIN dbo.SureScriptsPharmacyUpdate AS ssdp ON ( ssdp.NCPDPID = p.SureScriptsPharmacyIdentifier )

-- Prescriber Information
		UPDATE	r
		SET		PRESCRIBER_SPI = LTRIM(RTRIM(ISNULL(s.SureScriptsPrescriberId,
													'')))
				+ LTRIM(RTRIM(ISNULL(s.SureScriptsLocationId, ''))),
				PRESCRIBER_LICENSE = CASE WHEN EXISTS (SELECT 1 FROM dbo.SystemConfigurationKeys WHERE [key] = 'SurescriptsAlwaysSendPrescriberLicense' AND [Value] = 'Y' AND ISNULL(RecordDeleted, 'N') <> 'Y' ) then 	s.LicenseNumber ELSE NULL end ,
				PRESCRIBER_NADEA_NUMBER = sld1.licenseNumber,
				PRESCRIBER_DEA_NUMBER = sld.licenseNumber,
				PRESCRIBER_NATIONAL_PROVIDER_ID = s.NationalProviderId,
				PRESCRIBER_CLINIC_NAME = CASE WHEN LocationName IS NULL then SUBSTRING(ag.AgencyName, 1, 35) else SUBSTRING(l.LocationName, 1, 35) end,  -- substring(l.LocationName, 1, 35),
				PRESCRIBER_LASTNAME = s.LastName,
				PRESCRIBER_MIDDLENAME = ISNULL(s.MiddleName, ''),
				PRESCRIBER_FIRSTNAME = s.FirstName,
				PRESCRIBER_NAME_PREFIX = '',
				PRESCRIBER_SPECIALITY_QUALIFIER = NULL,
				PRESCRIBER_SPECIALITY_CODE = NULL,
				PRESCRIBER_ADDRESS1 = CASE WHEN l.[Address] IS NULL THEN dbo.ssf_SureScriptsAddressElement(ag.Address,
															  1, 'Y') ELSE dbo.ssf_SureScriptsAddressElement(l.[Address],
															  1, 'Y') end,
				PRESCRIBER_ADDRESS2 = CASE WHEN l.[Address] IS NULL THEN ISNULL(dbo.ssf_SureScriptsAddressElement(ag.Address,
															  2, 'Y'),'') ELSE dbo.ssf_SureScriptsAddressElement(l.[Address],
															  2, 'Y') end,
				PRESCRIBER_CITY = CASE WHEN l.[Address] IS NULL THEN ISNULL(ag.City,'')  else ISNULL(l.City, '') end,       -- substring(l.City, 1, 35),
				PRESCRIBER_STATE = CASE WHEN l.[Address] IS NULL THEN ISNULL(ag.STATE,'') else	ISNULL(l.State, '') end,     -- l.State,
				PRESCRIBER_ZIPCODE = 
				CASE WHEN l.[Address] IS NULL THEN
                
				(CASE WHEN ( LEN(REPLACE(LTRIM(RTRIM(ag.ZipCode)),
															 '-', '')) NOT IN (
												 5, 9 ) )
											   OR ( REPLACE(LTRIM(RTRIM(ag.ZipCode)),
															'-', '') LIKE '%[^0-9]%' )
										  THEN ''
										  ELSE REPLACE(LTRIM(RTRIM(ag.ZipCode)),
													   '-', '')
									 END)
									 ELSE 
									 (  CASE WHEN ( LEN(REPLACE(LTRIM(RTRIM(l.ZipCode)),
															 '-', '')) NOT IN (
												 5, 9 ) )
											   OR ( REPLACE(LTRIM(RTRIM(l.ZipCode)),
															'-', '') LIKE '%[^0-9]%' )
										  THEN ''
										  ELSE REPLACE(LTRIM(RTRIM(l.ZipCode)),
													   '-', '')
									 END
									 
									 
									 
									 
									 ) end
									 
									 ,
				PRESCRIBER_EMAIL = NULL,
				PRESCRIBER_TE = case when dbo.ssf_SureScriptsFormatPhone(l.PhoneNumber) IS null then dbo.ssf_SureScriptsFormatPhone(s.PhoneNumber) else dbo.ssf_SureScriptsFormatPhone(l.PhoneNumber)  end,
				PRESCRIBER_FX = Case when dbo.ssf_SureScriptsFormatPhone(l.FaxNumber) IS null then dbo.ssf_SureScriptsFormatPhone(s.PhoneNumber) else dbo.ssf_SureScriptsFormatPhone(l.FaxNumber)  end,
				SUPERVISOR_NATIONAL_PROVIDER_ID = ISNULL(s2.NationalProviderId,
														 ''),
				SUPERVISOR_LASTNAME = ISNULL(s2.LastName, ''),
				SUPERVISOR_MIDDLENAME = ISNULL(s2.MiddleName, ''),
				SUPERVISOR_FIRSTNAME = ISNULL(s2.FirstName, ''),
				SUPERVISOR_NAME_PREFIX = '',
				SUPERVISOR_DEA_NUMBER = ISNULL(s2.DEANumber, ''),
				SUPERVISOR_ADDRESS1 = dbo.ssf_SureScriptsAddressElement(ag.Address,
															  1, 'Y'),
				SUPERVISOR_ADDRESS2 = '',
				SUPERVISOR_CITY = ISNULL(ag.City, ''),       -- substring(l.City, 1, 35),
				SUPERVISOR_STATE = ISNULL(ag.State, ''),     -- l.State,
				SUPERVISOR_ZIPCODE = CASE WHEN ( LEN(REPLACE(LTRIM(RTRIM(ag.ZipCode)),
															 '-', '')) NOT IN (
												 5, 9 ) )
											   OR ( REPLACE(LTRIM(RTRIM(ag.ZipCode)),
															'-', '') LIKE '%[^0-9]%' )
										  THEN ''
										  ELSE REPLACE(LTRIM(RTRIM(ag.ZipCode)),
													   '-', '')
									 END,
				SUPERVISOR_TE = dbo.ssf_SureScriptsFormatPhone(s2.PhoneNumber),
				SUPERVISOR_FX = dbo.ssf_SureScriptsFormatPhone(s2.FaxNumber)
		FROM	@results AS r
				JOIN ClientMedicationScriptActivities AS cmsa ON cmsa.ClientMedicationScriptActivityId = r.ClientMedicationScriptActivityId
				JOIN ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = cmsa.ClientMedicationScriptId
				JOIN ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationScriptId=cms.ClientMedicationScriptId
				JOIN dbo.ClientMedicationInstructions AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId AND ISNULL(cmi.Active,'N')='Y'
				JOIN Staff AS s ON s.StaffId = cms.OrderingPrescriberId
				Join StaffLicenseDegrees AS sld on sld.StaffLicenseDegreeId= cms.StaffLicenseDegreeId
				left join StaffLicenseDegrees AS sld1 on Sld1.StaffId = cms.OrderingPrescriberId and Sld1.LicenseTypeDegree = 9404 and Sld1.PrimaryValue = 'Y'
				LEFT JOIN dbo.Staff AS s2 ON s2.StaffId = s.RxAuthorizedProvider
				left JOIN Locations AS l ON l.LocationId = cms.LocationId   AND ISNULL(l.RecordDeleted,  
                                                              'N') <> 'Y'  
				CROSS JOIN Agency AS ag

-- Diagnosis Information
		UPDATE	r
		SET	 
		--	 DIAGNOSIS_CODE = 'A01.1',
		--	 DIAGNOSIS_INFERRED_BY = 1 ,
		--	 DIAGNOSIS_QUALIFIER = 'ABF'
			 DIAGNOSIS_CODE = isnull(ICD10Code, ''),
			 DIAGNOSIS_INFERRED_BY = 1 ,
			 DIAGNOSIS_QUALIFIER = case when ICD10CodeId is not null then 'ABF' else 'DX' end 
		FROM	@results AS r
				JOIN ClientMedicationScriptActivities AS cmsa ON cmsa.ClientMedicationScriptActivityId = r.ClientMedicationScriptActivityId
				join ClientMedicationScriptDrugs as cmsd on cmsd.ClientMedicationScriptId = cmsa.ClientMedicationScriptId 
				join dbo.ClientMedicationInstructions as cmi on cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId AND ISNULL(cmi.Active,'N')='Y'
				join dbo.ClientMedications as cm on cm.ClientMedicationId = cmi.ClientMedicationId
				left join dbo.DiagnosisICD10Codes as dic on DSMCode = convert(varchar(15),dic.ICD10CodeId)

-- GHB Drug
        UPDATE  r
        SET     DRU_GHB = ( CASE WHEN MedName.MedicationName LIKE '%Xyrem%'
                                      OR MedName.MedicationName LIKE '%Subutex%'
                                      OR MedName.MedicationName LIKE '%Gamma-Hydroxybutyric Acid%'
                                      OR MedName.MedicationName LIKE '%Suboxone%'
                                      OR MedName.MedicationName LIKE '%Zubsolv%'
                                      OR MedName.MedicationName LIKE '%Bunavail%'
                                      OR MedName.MedicationName LIKE '%Buprenorphine%'
                                      OR MedName.MedicationName LIKE '%Buprenex%'
                                      OR MedName.MedicationName LIKE '%Belbuca%'
                                      OR MedName.MedicationName LIKE '%Sublocade%'
                                      OR MedName.MedicationName LIKE '%Probuphine%'
                                      OR MedName.MedicationName LIKE '%Butrans%'
                                 THEN 'Y'
                                 ELSE 'N'
                            END ) ,
                EFFECTIVE_DATE = dbo.ssf_SureScriptsFormatDate(cmsd.StartDate)
        FROM    @results AS r
                JOIN ClientMedicationScriptActivities AS cmsa ON cmsa.ClientMedicationScriptActivityId = r.ClientMedicationScriptActivityId
                JOIN ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationScriptId = cmsa.ClientMedicationScriptId
                JOIN dbo.ClientMedicationInstructions AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId AND ISNULL(cmi.Active,'N')='Y'
                JOIN dbo.ClientMedications AS cm ON cm.ClientMedicationId = cmi.ClientMedicationId
                JOIN MDMedicationNames AS MedName ON MedName.MedicationNameId = cm.MedicationNameId;

-- Client Information
		UPDATE	r
		SET		PATIENT_FILE_ID = CAST(cms.ClientId AS VARCHAR(35)),
				PATIENT_LASTNAME = SUBSTRING(LTRIM(RTRIM(c.LastName)), 1, 35),
				PATIENT_FIRSTNAME = SUBSTRING(LTRIM(RTRIM(c.FirstName)), 1, 35),
				PATIENT_MIDDLENAME = ISNULL(SUBSTRING(LTRIM(RTRIM(c.MiddleName)),
													  1, 35), ''),
				PATIENT_GENDER = CASE WHEN c.Sex NOT IN ( 'M', 'F' ) THEN 'U'
									  ELSE c.Sex
								 END,
				PATIENT_DOB = dbo.ssf_SureScriptsFormatDate(c.DOB),
				PATIENT_ADDRESS1 = dbo.ssf_SureScriptsAddressElement(ca.Address,
															  1, 'Y'),
				PATIENT_ADDRESS2 = dbo.ssf_SureScriptsAddressElement(ca.Address,
															  2, 'Y'),
				PATIENT_CITY = SUBSTRING(ca.City, 1, 35),
				PATIENT_STATE = CASE WHEN LEN(ISNULL(LTRIM(RTRIM(ca.State)),
													 '')) <> 2 THEN ''
									 ELSE LTRIM(RTRIM(ca.State))
								END,
				PATIENT_ZIPCODE = CASE WHEN ( LEN(REPLACE(LTRIM(RTRIM(ca.Zip)),
														  '-', '')) NOT IN ( 5,
															  9 ) )
											OR ( REPLACE(LTRIM(RTRIM(ca.Zip)),
														 '-', '') LIKE '%[^0-9]%' )
									   THEN ''
									   ELSE REPLACE(LTRIM(RTRIM(ca.Zip)), '-',
													'')
								  END,
	--PATIENT_EMAIL varchar(80),  --PATIENT EMAIL
				PATIENT_TE = dbo.ssf_SureScriptsFormatPhone(ISNULL(cp.PhoneNumber,
															  cp2.PhoneNumber)),
				PATIENT_CP = dbo.ssf_SureScriptsFormatPhone(ISNULL(ch.PhoneNumber,
															  ch2.PhoneNumber))
		FROM	@results AS r
				JOIN ClientMedicationScriptActivities AS cmsa ON cmsa.ClientMedicationScriptActivityId = r.ClientMedicationScriptActivityId
				JOIN ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = cmsa.ClientMedicationScriptId
				JOIN Clients AS c ON c.ClientId = cms.ClientId
				LEFT OUTER JOIN ClientAddresses AS ca ON ca.ClientId = c.ClientId
														 AND ca.AddressType = (SELECT TOP 1
															  ca3.AddressType
															  FROM
															  ClientAddresses
															  AS ca3
															  WHERE
															  ca3.ClientId = c.ClientId
															  AND  ISNULL(ca3.Address, '') != ''
                                                              AND ISNULL(ca3.City, '') != ''
                                                              AND ISNULL(ca3.State, '') != ''
                                                              AND ISNULL(ca3.Zip, '') != ''
                                                              AND ISNULL(ca3.RecordDeleted, 'N') != 'Y' 
															  ORDER BY CASE WHEN ca3.AddressType = 90 THEN 1 --Home
                                                              WHEN ca3.AddressType = 92 THEN 2 --Temporary Residence
                                                              WHEN ca3.AddressType = 91 THEN 3 --Office
                                                              WHEN ca3.AddressType = 93 THEN 4-- other
                                                              ELSE 5
                                                              END ASC)
														 AND ISNULL(ca.RecordDeleted,
															  'N') <> 'Y'
				LEFT OUTER JOIN ClientPhones AS cp ON cp.ClientId = c.ClientId
													  AND cp.PhoneType = (SELECT TOP 1
															  ca3.PhoneType
															  FROM
															  ClientPhones
															  AS ca3
															  WHERE
															  ca3.ClientId = c.ClientId
															  AND  ISNULL(ca3.PhoneNumber, '') != ''
                                                              AND ISNULL(ca3.RecordDeleted, 'N') != 'Y' 
															  ORDER BY CASE WHEN ca3.PhoneType = 30 THEN 1 --Home
                                                              WHEN ca3.PhoneType = 32 THEN 2 --Home2
                                                              WHEN ca3.PhoneType = 34 THEN 3 --Mobile
                                                              WHEN ca3.PhoneType = 35 THEN 4-- Mobile 2
                                                              WHEN ca3.PhoneType = 31 THEN 5-- Business
                                                              WHEN ca3.PhoneType = 33 THEN 6-- Business 2
                                                              WHEN ca3.PhoneType = 37 THEN 7 -- School
                                                              WHEN ca3.PhoneType = 38 THEN 8 --Other
                                                              ELSE 9
                                                              END ASC)
													  AND ISNULL(cp.RecordDeleted,
															  'N') <> 'Y'
				LEFT OUTER JOIN ClientPhones AS cp2 ON cp2.ClientId = c.ClientId
													   AND cp2.PhoneType = 32
													   AND ISNULL(cp2.RecordDeleted,
															  'N') <> 'Y'
				LEFT OUTER JOIN ClientPhones AS ch ON ch.ClientId = c.ClientId
													  AND ch.PhoneType = 34
													  AND ISNULL(ch.RecordDeleted,
															  'N') <> 'Y'
				LEFT OUTER JOIN ClientPhones AS ch2 ON ch2.ClientId = c.ClientId
													   AND ch2.PhoneType = 35
													   AND ISNULL(ch2.RecordDeleted,
															  'N') <> 'Y'
													   AND NOT EXISTS ( SELECT
															  *
															  FROM
															  ClientAddresses
															  AS ca3
															  WHERE
															  ca3.ClientId = ca.ClientId
															  AND ca3.AddressType = ca.AddressType
															  AND ISNULL(ca3.RecordDeleted,
															  'N') <> 'Y'
															  AND ca3.ClientAddressId > ca.ClientAddressId )
													   AND NOT EXISTS ( SELECT
															  *
															  FROM
															  ClientPhones AS cp3
															  WHERE
															  cp3.ClientId = cp.ClientId
															  AND cp3.PhoneType = cp.PhoneType
															  AND ISNULL(cp3.RecordDeleted,
															  'N') <> 'Y'
															  AND cp3.ClientPhoneId > cp.ClientPhoneId )
													   AND NOT EXISTS ( SELECT
															  *
															  FROM
															  ClientPhones AS cp3
															  WHERE
															  cp3.ClientId = cp2.ClientId
															  AND cp3.PhoneType = cp2.PhoneType
															  AND ISNULL(cp3.RecordDeleted,
															  'N') <> 'Y'
															  AND cp3.ClientPhoneId > cp2.ClientPhoneId )
													   AND NOT EXISTS ( SELECT
															  *
															  FROM
															  ClientPhones AS cp3
															  WHERE
															  cp3.ClientId = ch.ClientId
															  AND cp3.PhoneType = ch.PhoneType
															  AND ISNULL(cp3.RecordDeleted,
															  'N') <> 'Y'
															  AND cp3.ClientPhoneId > ch.ClientPhoneId )
													   AND NOT EXISTS ( SELECT
															  *
															  FROM
															  ClientPhones AS cp3
															  WHERE
															  cp3.ClientId = ch2.ClientId
															  AND cp3.PhoneType = ch2.PhoneType
															  AND ISNULL(cp3.RecordDeleted,
															  'N') <> 'Y'
															  AND cp3.ClientPhoneId > ch2.ClientPhoneId )

--Update Coordination of benefits
;WITH	responses
				  AS ( SELECT	SureScriptsEligibilityResponseId,
								ClientId,
								ResponseDate,
								SegmentControlNumber,								
								CAST(ResponseMessage AS XML) AS response,
								CAST(SegmentControlNumber AS INT) AS segmentcontrolnumbervalue
					   FROM		SureScriptsEligibilityResponse as sser
					   WHERE	status = 1
								AND ResponseDate > DATEADD(dd, -3, GETDATE())								
					 ),
					 coo as (
select ClientId,	SegmentControlNumber,
								segmentcontrolnumbervalue,
								CASE WHEN response.exist('/eligibilityresponse[1]/infosource[1]/payer[1]/payerid[1]') = 1
									 THEN response.value('/eligibilityresponse[1]/infosource[1]/payer[1]/payerid[1]',
														 'varchar(20)')
									 ELSE response.value('/eligibilityresponse[1]/infosource[1]/thirdpartyadmin[1]/payerid[1]',
														 'varchar(20)')
								END AS ParticipantId,
								CASE WHEN response.exist('/eligibilityresponse[1]/infosource[1]/payer[1]/payername[1]') = 1
									 THEN response.value('/eligibilityresponse[1]/infosource[1]/payer[1]/payername[1]',
														 'varchar(35)')
									 ELSE response.value('/eligibilityresponse[1]/infosource[1]/thirdpartyadmin[1]/organizationname[1]',
														 'varchar(35)')
								END AS PBMName,
								response.value('/eligibilityresponse[1]/infosource[1]/interchangecontrolnumber[1]', 'varchar(9)') AS InterchangeControlNumber,

								response.query('/eligibilityresponse/subscriber/benefit[servicetype[@code="30"]]/subscriberadditionalid[referenceidentificationtype[@qualifier="N6"]]/referenceidentification').value('referenceidentification[1]',
															  'varchar(35)') AS BinLocationNumber,
								response.value('/eligibilityresponse[1]/subscriber[1]/patient[1]/patientname[1]/last[1]',
											   'varchar(35)') AS PatientLastName,
								response.value('/eligibilityresponse[1]/subscriber[1]/patient[1]/patientname[1]/first[1]',
											   'varchar(35)') AS PatientFirstName,
								response.value('/eligibilityresponse[1]/subscriber[1]/patient[1]/patientname[1]/middle[1]',
											   'varchar(35)') AS PatientMiddleName,
								response.value('/eligibilityresponse[1]/subscriber[1]/patient[1]/patientname[1]/suffix[1]',
											   'varchar(35)') AS PatientSuffix,
								response.value('/eligibilityresponse[1]/subscriber[1]/patient[1]/patientid[1]',
											   'varchar(35)') AS PatientPayerId,
								response.value('/eligibilityresponse[1]/subscriber[1]/patient[1]/sex[1]',
											   'varchar(1)') AS PatientGender,
								response.value('/eligibilityresponse[1]/subscriber[1]/patient[1]/date-of-birth[1]',
											   'varchar(8)') AS PatientDOB,
								response.value('/eligibilityresponse[1]/subscriber[1]/patient[1]/patientaddress[1]/address[1]',
											   'varchar(35)') AS PatientAddress,
								response.value('/eligibilityresponse[1]/subscriber[1]/patient[1]/patientaddress[1]/city[1]',
											   'varchar(35)') AS PatientCity,
								response.value('/eligibilityresponse[1]/subscriber[1]/patient[1]/patientaddress[1]/state[1]',
											   'varchar(35)') AS PatientState,
								response.value('/eligibilityresponse[1]/subscriber[1]/patient[1]/patientaddress[1]/zip[1]',
											   'varchar(35)') AS PatientZipcode,
								response.value('/eligibilityresponse[1]/subscriber[1]/patient[1]/patientid[1]',
											   'varchar(80)') AS PatientId,
								response.value('/eligibilityresponse[1]/subscriber[1]/patient[1]/subscriberadditionalid[referenceidentificationtype[@qualifier="HJ"]][1]/referenceidentification[1]',
											   'varchar(35)') AS CardHolderId,
								response.value('/eligibilityresponse[1]/subscriber[1]/patient[1]/subscriberadditionalid[referenceidentificationtype[@qualifier="HJ"]][1]/identityname[1]',
											   'varchar(35)') AS CardHolderName,
								response.query('/eligibilityresponse/subscriber/benefit[servicetype[@code="30"]]/subscriberadditionalid[referenceidentificationtype[@qualifier="6P"]]/referenceidentification').value('referenceidentification[1]',
															  'varchar(35)') AS GroupId,
								response.query('/eligibilityresponse/subscriber/benefit[servicetype[@code="30"]]/info').value('info[1]','varchar(1)') AS PlanActive,
								response.query('/eligibilityresponse[1]/subscriber[1]/benefit[1]/plancoveragedescription').value('plancoveragedescription[1]','varchar(35)') AS PlanText
						FROM		responses
					   WHERE	response.exist('/eligibilityresponse[@type="271"]') = 1
								AND response.exist('/eligibilityresponse/subscriber/benefit[servicetype[@code="30"]]') = 1
								--and response.query('/eligibilityresponse[1]/subscriber[1]/benefit[1]/plancoveragedescription').value('plancoveragedescription[1]','varchar(35)') = 'PLANX'
								)
								
                            update  r
                            set     PLAN_NAME = case when PlanActive = 'A' then isnull(co.PBMName, '') + ' - ' + isnull(co.PlanText, '') end 
                                  , MUTUALLY_DEFINED = co.InterchangeControlNumber
                                  , PAYER_ID = co.ParticipantId 
                                  , BIN_LOCATION_NUMBER = case when PlanActive = 'A' then co.BinLocationNumber end
                                  , PAYER_NAME = case when PlanActive = 'A' then co.PBMName end
                                  , CARDHOLDER_ID = case when PlanActive = 'A' then co.CardHolderId end
                                  , CARDHOLDER_LASTNAME = case when PlanActive = 'A' then co.CardHolderName end
                                  , CARDHOLDER_FIRSTNAME = case when PlanActive = 'A' then co.CardHolderName end
                                  , GROUP_ID = case when PlanActive = 'A' then co.GroupId end 
								  , PATIENT_PAYER_ID = co.PatientPayerId
                            from    @results as r
                                    join ClientMedicationScriptActivities as cmsa on cmsa.ClientMedicationScriptActivityId = r.ClientMedicationScriptActivityId
                                    join ClientMedicationScripts as cms on cms.ClientMedicationScriptId = cmsa.ClientMedicationScriptId
                                    left join coo as co on co.ClientId = cms.ClientId
                                                           and (isnull(co.PBMName, '') + ' - ' + isnull(co.PlanText, '') = cms.PlanName or cms.PlanName is null)

--select top 100 * from @results as r
--                            join ClientMedicationScriptActivities as cmsa on cmsa.ClientMedicationScriptActivityId = r.ClientMedicationScriptActivityId
--                            join ClientMedicationScripts as cms on cms.ClientMedicationScriptId = cmsa.ClientMedicationScriptId
--							left join coo as co on co.ClientId = cms.ClientId
--                            and (isnull(co.PBMName, '') + ' - ' + isnull(co.PlanText, '') = cms.PlanName or cms.PlanName is null)

		SELECT	ClientMedicationScriptActivityId,
				dbo.ssf_SurescriptsXMLCharReplace(RXREFERENCENUMBER, 35) AS RXREFERENCENUMBER,
				PRESCRIBER_OREDERNO,
				NCPDPID,
				dbo.ssf_SurescriptsXMLCharReplace(STORENAME, 35) AS STORENAME,
				dbo.ssf_SurescriptsXMLCharReplace(PHARMACY_ADDRESS1, 35) AS PHARMACY_ADDRESS1,
				dbo.ssf_SurescriptsXMLCharReplace(PHARMACY_ADDRESS2, 35) AS PHARMACY_ADDRESS2,
				dbo.ssf_SurescriptsXMLCharReplace(PHARMACY_CITY, 35) AS PHARMACY_CITY,
				PHARMACY_STATE,
				PHARMACY_ZIPCODE,
				PHARMACY_EMAIL,
				PHARMACY_TE,
				PHARMACY_FX,
				PHARMACY_NPI,
				PRESCRIBER_SPI,
				PRESCRIBER_LICENSE,
				PRESCRIBER_DEA_NUMBER,
				PRESCRIBER_NADEA_NUMBER,
				PRESCRIBER_NATIONAL_PROVIDER_ID,
				dbo.ssf_SurescriptsXMLCharReplace(PRESCRIBER_CLINIC_NAME, 35) AS PRESCRIBER_CLINIC_NAME,
				dbo.ssf_SurescriptsXMLCharReplace(PRESCRIBER_LASTNAME, 35) AS PRESCRIBER_LASTNAME,
				dbo.ssf_SurescriptsXMLCharReplace(PRESCRIBER_MIDDLENAME, 35) AS PRESCRIBER_MIDDLENAME,
				dbo.ssf_SurescriptsXMLCharReplace(PRESCRIBER_FIRSTNAME, 35) AS PRESCRIBER_FIRSTNAME,
				PRESCRIBER_NAME_PREFIX,
				PRESCRIBER_SPECIALITY_QUALIFIER,
				PRESCRIBER_SPECIALITY_CODE,
				dbo.ssf_SurescriptsXMLCharReplace(PRESCRIBER_ADDRESS1, 35) AS PRESCRIBER_ADDRESS1,
				dbo.ssf_SurescriptsXMLCharReplace(PRESCRIBER_ADDRESS2, 35) AS PRESCRIBER_ADDRESS2,
				dbo.ssf_SurescriptsXMLCharReplace(PRESCRIBER_CITY, 35) AS PRESCRIBER_CITY,
				PRESCRIBER_STATE,
				PRESCRIBER_ZIPCODE,
				PRESCRIBER_EMAIL,
				PRESCRIBER_TE,
				PRESCRIBER_FX,
				SUPERVISOR_NATIONAL_PROVIDER_ID,
				SUPERVISOR_LASTNAME,
				SUPERVISOR_MIDDLENAME,
				SUPERVISOR_FIRSTNAME,
				SUPERVISOR_NAME_PREFIX,
				SUPERVISOR_DEA_NUMBER,
				SUPERVISOR_ADDRESS1,
				SUPERVISOR_ADDRESS2,
				SUPERVISOR_CITY,
				SUPERVISOR_STATE,
				SUPERVISOR_ZIPCODE,
				SUPERVISOR_TE,
				SUPERVISOR_FX,
				AGENT_FIRST_NAME,
				AGENT_LAST_NAME,
				PATIENT_FILE_ID,
				dbo.ssf_SurescriptsXMLCharReplace(PATIENT_LASTNAME, 35) AS PATIENT_LASTNAME,
				dbo.ssf_SurescriptsXMLCharReplace(PATIENT_MIDDLENAME, 35) AS PATIENT_MIDDLENAME,
				dbo.ssf_SurescriptsXMLCharReplace(PATIENT_FIRSTNAME, 35) AS PATIENT_FIRSTNAME,
				PATIENT_GENDER,
				PATIENT_DOB,
				dbo.ssf_SurescriptsXMLCharReplace(PATIENT_ADDRESS1, 35) AS PATIENT_ADDRESS1,
				dbo.ssf_SurescriptsXMLCharReplace(PATIENT_ADDRESS2, 35) AS PATIENT_ADDRESS2,
				dbo.ssf_SurescriptsXMLCharReplace(PATIENT_CITY, 35) AS PATIENT_CITY,
				dbo.ssf_SurescriptsXMLCharReplace(PATIENT_STATE, 9) AS PATIENT_STATE,
				PATIENT_ZIPCODE,
				PATIENT_EMAIL,
				PATIENT_TE,
				PATIENT_CP,
				dbo.ssf_SurescriptsXMLCharReplace(DRUG_DESCRIPTION, 250) AS DRUG_DESCRIPTION,
				PRODUCT_CODE,
				PRODUCT_CODE_QUALIFIER,
				DOSAGE_FORM,
				STRENGTH,
				STRENGTH_UNITS,
				DRUG_QUANTITY_QUALIFIER,
				DRUG_QUANTITY_VALUE,
				DRUG_DAYS_SUPPLY,
				dbo.ssf_SurescriptsXMLCharReplace(DRUG_DIRECTIONS, 140) AS DRUG_DIRECTIONS,
				case 
				when isnull(DRU_GHB, 'N') = 'Y' and isnull(PRESCRIBER_NADEA_NUMBER, '') <> '' 
				then dbo.ssf_SurescriptsXMLCharReplace('NADEAN:' + isnull(PRESCRIBER_NADEA_NUMBER, '') + ' GHB:' + isnull(DRUG_NOTE, ''), 210) 
				--when isnull(DRU_SI_FLAG, 'N') = 'Y' and isnull(PRESCRIBER_NADEA_NUMBER, '') <> '' 
				--then dbo.ssf_SurescriptsXMLCharReplace('NADEAN:' + isnull(PRESCRIBER_NADEA_NUMBER, '') + ' ' + isnull(DRUG_NOTE, ''), 210) 
				else dbo.ssf_SurescriptsXMLCharReplace(DRUG_NOTE, 210) end AS DRUG_NOTE,
				md.DEACode as DRU_DEA_SCHEDULE,
				case when cast(isnull(md.DEACode, 0) as int) >= 2 then 'Y' else 'N' end DRU_SI_FLAG,
				REFILL_QUALIFIER,
				REFILL_QUANTITY,
				SUBSTITUTIONS,
				WRITTEN_DATE,
				EFFECTIVE_DATE,
				LAST_FILL_DATE,
				RELATES_TO_MESSAGEID,
				PotencyUnitCode,
				RxNormCode as DRUG_DB_CODE,
				TTY as DrugDBCodeQualifier,
				PLAN_NAME,
	  		    MUTUALLY_DEFINED,
			    PAYER_ID,
			    BIN_LOCATION_NUMBER,
			    PAYER_NAME,
			    CARDHOLDER_ID,
			    CARDHOLDER_LASTNAME,
			    CARDHOLDER_FIRSTNAME,
			    GROUP_ID,
				PATIENT_PAYER_ID,
				case when charindex('.', DIAGNOSIS_CODE) > 0 then replace(r.DIAGNOSIS_CODE, '.', '') else r.DIAGNOSIS_CODE end as DIAGNOSIS_CODE,
				DIAGNOSIS_INFERRED_BY,
				DIAGNOSIS_QUALIFIER
			 		FROM	@results as r left join dbo.MDRxNormCodes as mrnc on  PRODUCT_CODE = NationalDrugCode and mrnc.MDRxNormCodeId = (select top 1 MDRxNormCodeId from MDRxNormCodes where NationalDrugCode = PRODUCT_CODE )
										  left join dbo.MDDrugs as md on r.PRODUCT_CODE = md.NationalDrugCode and isnull(md.RecordDeleted, 'N') = 'N'

		COMMIT TRAN

	END TRY
	BEGIN CATCH

		IF @@trancount > 0 
			ROLLBACK TRAN

		DECLARE	@errMessage NVARCHAR(4000)
		SET @errMessage = ERROR_MESSAGE()

		RAISERROR(@errMessage, 16, 1)
	END CATCH



GO


