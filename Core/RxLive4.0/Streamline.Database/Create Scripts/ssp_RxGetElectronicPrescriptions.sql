USE [EPCS]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RxGetElectronicPrescriptions]    Script Date: 1/10/2017 2:46:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







          
            
CREATE PROCEDURE [dbo].[ssp_RxGetElectronicPrescriptions]          
    @ClientMedicationScriptIds varchar(max) ,          
    @OriginalData INT          
        
AS 
/*
Changelog:   
--  Date			Author			Purpose
June 01 2016		VIthobha		To get Electronic Prescribed Medication data for preview list 
*/          
    BEGIN TRY          
        
          
        --BEGIN TRAN          
          
        DECLARE @Preview CHAR(1)         
        DECLARE @RefillResponseType CHAR(1) = NULL --'N'           
          
  DECLARE @results TABLE        
  (          
   --PHARMACY DETAILS          
              NCPDPID VARCHAR(35) ,  --ID OF THE  PHARMACY          
              STORENAME VARCHAR(35) ,  --NAME OF THE PHARMACY STORE          
              PHARMACY_ADDRESS1 VARCHAR(35) ,  --PRIMARY ADDRESS OF PHARMACY          
              PHARMACY_ADDRESS2 VARCHAR(35) ,  --ADDRESS LINE2 OF PHARMACY          
              PHARMACY_CITY VARCHAR(35) ,  --PHARMACY CITY          
              PHARMACY_STATE VARCHAR(2) ,  --PHARMACY STATE          
              PHARMACY_ZIPCODE VARCHAR(9) ,  --PHARMACY ZIP CODE          
              PHARMACY_EMAIL VARCHAR(80) ,  --PHARMACY EMAIL          
              PHARMACY_TE VARCHAR(25) ,  --PHARMACY PRIMARY PHONE_NO          
              PHARMACY_FX VARCHAR(25) ,  --PHARMACY PRIMARY FAX NO          
          
-- PRESCRIBER DETAILS          
              PRESCRIBER_SPI VARCHAR(35) ,  --SPI ID OF THE PRESCRIBER GIVEN AT THE TIME OF REGISTRATION          
              PRESCRIBER_CLINIC_NAME VARCHAR(35) ,  --PRESCRIBER CLINIC NAME          
              PRESCRIBER_LASTNAME VARCHAR(35) ,  --PRESCRIBER LASTNAME          
              PRESCRIBER_MIDDLENAME VARCHAR(35) ,          
              PRESCRIBER_FIRSTNAME VARCHAR(35) ,  --PRESCRIBER FIRSTNAME          
              PRESCRIBER_NAME_PREFIX VARCHAR(10) ,          
              PRESCRIBER_SPECIALITY_QUALIFIER VARCHAR(2) ,  --PRESCRIBER SPECIALITY CODE QUALIFIER LIKE DE(DRUG ENFORCEMENT AGENCY) OR AM(AMERICAN MEDICAL ASSOCIATION)          
              PRESCRIBER_SPECIALITY_CODE VARCHAR(10) ,  --DEA SPECIALITY CODE         
              PRESCRIBER_ADDRESS1 VARCHAR(35) ,  --PRESCRIBER PRIMARY ADDRESS          
              PRESCRIBER_ADDRESS2 VARCHAR(35) ,          
              PRESCRIBER_CITY VARCHAR(35) ,  --PRESCRIBER CITY          
              PRESCRIBER_STATE VARCHAR(2) ,  --PRESCRIBER STATE          
              PRESCRIBER_ZIPCODE VARCHAR(9) ,  --PRESCRIBER ZIPCODE          
              PRESCRIBER_EMAIL VARCHAR(80) ,  --PRESCRIBER EMAIL          
              PRESCRIBER_TE VARCHAR(25) ,  --PHARMACY PRIMARY PHONE_NO          
              PRESCRIBER_FX VARCHAR(35) ,  --PHARMACY PRIMARY FAX NO          
          
--PATIENT DETAILS          
              PATIENT_FILE_ID VARCHAR(35) ,  --PATIENT FILEID.ANY UNIQUE ID GIVEN TO A PATIENT FORM THE APPLICATION          
              PATIENT_LASTNAME VARCHAR(35) ,  --PATIENT LASTNAME          
              PATIENT_MIDDLENAME VARCHAR(35) ,          
              PATIENT_FIRSTNAME VARCHAR(35) ,  --PATIENT FIRSTNAME          
              PATIENT_GENDER CHAR(1) ,  --PATIENT GENDER          
              PATIENT_DOB VARCHAR(10) ,  --PATIENT DATE OF BIRTH          
              PATIENT_ADDRESS1 VARCHAR(35) ,   --PATIENT PRIMARY ADDRESS          
              PATIENT_ADDRESS2 VARCHAR(35) ,          
              PATIENT_CITY VARCHAR(35) ,  --PATIENT CITY          
              PATIENT_STATE VARCHAR(2) ,  --PATIENT STATE          
              PATIENT_ZIPCODE VARCHAR(9) ,  --PATIENT ZIPCODE          
              PATIENT_EMAIL VARCHAR(80) ,  --PATIENT EMAIL          
              PATIENT_TE VARCHAR(100), --VARCHAR(25) ,  --PATIENT TELEPHONE          
              PATIENT_CP VARCHAR(100) -- VARCHAR(25) ,  --PATIENT CELLULAR PHONE NO          
            )        
                    
        DECLARE @medicationresults TABLE          
            (         
     ClientMedicationScriptId INT,        
              RXREFERENCENUMBER VARCHAR(35) ,  --PHARMACY RX REFERENCE NUMBER SENT IN NEWRX RESPONSE FOR REFILL REQUEST          
              PRESCRIBER_OREDERNO VARCHAR(35) ,  --PRESCRIBER OREDER NUMBER TRACK PRESCIPTION ORDER NO IN PRESCRIBER SOFTWARE SYSTEM          
          
--MEDICATION DETAILS          
              DRUG_DESCRIPTION VARCHAR(105) ,  --DESCRIPTION OF THE DRUG MUST CONTAIN DRUG NAME,FORM AND STRENGTH i,e Zoloft 50 mg tablets          
          
-- Optional elements          
              PRODUCT_CODE VARCHAR(35) ,  --DRUG CODE          
              PRODUCT_CODE_QUALIFIER VARCHAR(3) ,  --DRUG CODE QUALIFIER LIKE ND FOR NDC          
              DOSAGE_FORM VARCHAR(10) ,   --DRUG DOSAGE FORM          
              STRENGTH VARCHAR(70) ,  --STRENGTH OF THE DRUG          
              STRENGTH_UNITS VARCHAR(35) ,  --UNITS OF STRENGTH          
   -- End Optional elements          
              DRUG_QUANTITY_QUALIFIER VARCHAR(2) ,  --UNITS OF MEASURE LIKE U2 FOR TABLET AND ZZ MUTUALLY DEFINED i,e NOT DEFINED IN TABLE          
              DRUG_QUANTITY_VALUE FLOAT ,  --MEASURE VALUE LIKE 20 OF U2(TABLETS)          
              DRUG_DAYS_SUPPLY INT ,  --PRESCRIBER OREDER DAYS SUPPLY          
              DRUG_DIRECTIONS VARCHAR(MAX), -- VARCHAR(140) ,  --DIRECTIONS FOR PATIENT TO TAKE THE DRUG          
              DRUG_INSTRUCTIONS VARCHAR(MAX), -- VARCHAR(140) ,  --DIRECTIONS FOR PATIENT TO TAKE THE DRUG         
              DRUG_NOTE VARCHAR(MAX), -- VARCHAR(210) ,  --NOTE ADDED FOR THIS MEDICATION          
          
--REFILLS DETAILS          
              REFILL_QUALIFIER CHAR(1) ,  -- we do not allow PRN refills  --REFILL QUALIFIER "R" OR "PRN"          
              REFILL_QUANTITY INT ,  --REFILL QUANTITY          
              SUBSTITUTIONS CHAR(1) ,  --SUBSTTUTIONS ALLOWED i,e 0(SUBSTITUTION ALLOWED) OR 1(SUBSTITUTION NOT ALLOWED)  FOR NEWRX          
              WRITTEN_DATE VARCHAR(10) ,  --PRESCRIBER WTORE THE PRESCRIPTION DATE          
              P_START_DATE VARCHAR(10), --Prescription Start Date
			  P_END_DATE VARCHAR(10),  --Prescription End Date
			LAST_FILL_DATE VARCHAR(10),  --DATE DRUG SHOUD BE TAKEN          
			RELATES_TO_MESSAGEID VARCHAR(35),          
			POTENCY_UNIT_CODE VARCHAR(35),        
			DEACODE INT -- To differentiate controlled & non controlled medications, other than 0(zero) = controlled medications             
            )          
          
        DECLARE @ScriptOutput TABLE          
            (          
              ClientMedicationScriptId INT ,          
              PON VARCHAR(35) ,          
              RxReferenceNumber VARCHAR(35) ,          
              DrugDescription VARCHAR(250) ,          
              SureScriptsQuantityQualifier VARCHAR(3) ,          
              SureScriptsQuantity DECIMAL(29, 14) ,          
              TotalDaysInScript INT ,          
              ScriptInstructions VARCHAR(MAX), -- VARCHAR(140) ,          
              ScriptNote VARCHAR(MAX), -- VARCHAR(210) ,          
              Refills INT ,          
              DispenseAsWritten CHAR(1) , -- Y/N          
              OrderDate DATETIME ,          
              NDC VARCHAR(35),          
			RelatesToMessageID VARCHAR(35),          
			PotencyUnitCode VARCHAR(35)          
            )          
          
-- map the script output to activities          
        DECLARE @ScriptActivityMap TABLE          
            (          
              ClientMedicationScriptId INT ,          
              ClientMedicationScriptActivityId INT          
            )          
          
        DECLARE @currScriptId INT          
                
        DECLARE @DrugsDEACodes TABLE            
        (            
          ClientMedicationScriptDrugId INT ,           
          ClientMedicationScriptId INT,         
          DEACode CHAR(1)            
        )            
    DECLARE @cDrugsDEAScriptDrugId INT ,         
		@ClientMedicationScriptId INT,           
        @cDrugsDEAMedicationId INT ,            
        @cDrugsDEACode CHAR(1)            
         
        IF @OriginalData > 0           
            SET @Preview = 'N'          
        ELSE           
            SET @Preview = 'Y'        
                    
                
    -- get the deacodes for all ClientMedicationScriptDrugs             
      IF @Preview != 'Y'         
      BEGIN         
            DECLARE cDrugsDEA CURSOR fast_forward              
            FOR              
                SELECT DISTINCT              
                        cmsd.ClientMedicationScriptDrugId ,              
                        cmsd.ClientMedicationScriptId,          
                        cmi.StrengthId              
                FROM    ClientMedicationScriptDrugs AS cmsd              
                        JOIN ClientMedicationInstructions AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId              
                WHERE   cmsd.ClientMedicationScriptId in ( select item from [dbo].fnSplit(@ClientMedicationScriptIds,',') )              
                        AND ISNULL(cmsd.RecordDeleted, 'N') <> 'Y'              
                        AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'              
              
            OPEN cDrugsDEA              
              
            FETCH cDrugsDEA INTO @cDrugsDEAScriptDrugId,           
               @ClientMedicationScriptId,          
                @cDrugsDEAMedicationId              
              
            WHILE @@fetch_status = 0               
                BEGIN              
                    EXEC [csp_SCClientMedicationC2C5Drugs] @cDrugsDEAMedicationId,              
                        @cDrugsDEACode OUTPUT              
              
                    INSERT  INTO @DrugsDEACodes              
                            ( ClientMedicationScriptDrugId ,            
                              ClientMedicationScriptId,          
                              DEACode              
                            )              
                    VALUES  ( @cDrugsDEAScriptDrugId ,              
							@ClientMedicationScriptId,          
                              @cDrugsDEACode              
                            )              
              
                    FETCH cDrugsDEA INTO @cDrugsDEAScriptDrugId,            
						@ClientMedicationScriptId,          
                        @cDrugsDEAMedicationId              
                END              
              
            CLOSE cDrugsDEA              
              
            DEALLOCATE cDrugsDEA         
       END         
       ELSE        
       BEGIN        
   DECLARE cDrugsDEA CURSOR fast_forward              
            FOR              
                SELECT DISTINCT              
                        cmsd.ClientMedicationScriptDrugId ,              
                        cmsd.ClientMedicationScriptId,          
                        cmi.StrengthId              
                FROM    ClientMedicationScriptDrugsPreview AS cmsd              
                        JOIN ClientMedicationInstructionsPreview AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId              
                WHERE   cmsd.ClientMedicationScriptId in ( select item from [dbo].fnSplit(@ClientMedicationScriptIds,',') )              
                        AND ISNULL(cmsd.RecordDeleted, 'N') <> 'Y'              
                        AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'              
              
            OPEN cDrugsDEA              
              
            FETCH cDrugsDEA INTO @cDrugsDEAScriptDrugId,           
               @ClientMedicationScriptId,          
                @cDrugsDEAMedicationId              
              
            WHILE @@fetch_status = 0               
                BEGIN              
                    EXEC [csp_SCClientMedicationC2C5Drugs] @cDrugsDEAMedicationId,              
                        @cDrugsDEACode OUTPUT              
              
                    INSERT  INTO @DrugsDEACodes              
                            ( ClientMedicationScriptDrugId ,            
                              ClientMedicationScriptId,          
                              DEACode              
              )              
                    VALUES  ( @cDrugsDEAScriptDrugId ,              
							@ClientMedicationScriptId,          
                              @cDrugsDEACode              
                            )              
              
                    FETCH cDrugsDEA INTO @cDrugsDEAScriptDrugId,            
						@ClientMedicationScriptId,          
                        @cDrugsDEAMedicationId              
                END              
              
            CLOSE cDrugsDEA              
              
            DEALLOCATE cDrugsDEA         
       END              
          
        IF @Preview != 'Y'           
            BEGIN          
                DECLARE currScripts CURSOR fast_forward          
                FOR          
                   select item from [dbo].fnSplit(@ClientMedicationScriptIds,',')        
            END          
        ELSE           
            BEGIN          
                DECLARE currScripts CURSOR fast_forward          
                FOR          
                    select item from [dbo].fnSplit(@ClientMedicationScriptIds,',')         
            END          
          
        OPEN currScripts          
          
        FETCH currScripts INTO @currScriptId        
          
        WHILE @@fetch_status = 0           
            BEGIN          
              
                INSERT  INTO @ScriptOutput          
                        ( ClientMedicationScriptId ,          
                          PON ,          
                          RxReferenceNumber ,          
                          DrugDescription ,          
                          SureScriptsQuantityQualifier ,          
                          SureScriptsQuantity ,          
                          TotalDaysInScript ,          
                          ScriptInstructions ,          
                          ScriptNote ,          
                          Refills ,          
						DispenseAsWritten ,          
                          OrderDate ,          
                          NDC,          
						RelatesToMessageID,          
						PotencyUnitCode          
                        )          
                        EXEC scsp_SureScriptsScriptOutput @ClientMedicationScriptId = @currScriptId,          
                            @PreviewData = @Preview,          
                            @RefillResponseType = @RefillResponseType          
          
                 
                FETCH currScripts INTO @currScriptId         
          
            END          
          
        CLOSE currScripts          
          
        DEALLOCATE currScripts          
              
-- create a results record for every drug strength          
        INSERT  INTO @medicationresults          
                (         
                  ClientMedicationScriptId,        
				RXREFERENCENUMBER ,          
                  PRESCRIBER_OREDERNO ,          
                  DRUG_DESCRIPTION ,          
                  DRUG_QUANTITY_QUALIFIER ,          
                  DRUG_QUANTITY_VALUE ,          
                  DRUG_DAYS_SUPPLY ,          
                  DRUG_DIRECTIONS ,          
                  DRUG_INSTRUCTIONS,        
                  DRUG_NOTE ,          
                  REFILL_QUALIFIER ,          
                  REFILL_QUANTITY ,          
                  SUBSTITUTIONS ,          
                  WRITTEN_DATE ,
				  P_START_DATE,
				  P_END_DATE,           
                  PRODUCT_CODE ,          
                  PRODUCT_CODE_QUALIFIER,          
				  RELATES_TO_MESSAGEID,          
				  POTENCY_UNIT_CODE,        
				  DEACODE          
                )          
                SELECT  distinct so.ClientMedicationScriptId,        
						so.RxReferenceNumber ,          
                        so.PON ,          
                        so.DrugDescription ,          
                        so.SureScriptsQuantityQualifier ,          
                        so.SureScriptsQuantity ,          
                        so.TotalDaysInScript ,          
                        --so.ScriptInstructions ,        
                        Substring(so.ScriptInstructions, 1,Charindex(';', so.ScriptInstructions)-1) ,        
						Substring(so.ScriptInstructions, Charindex(';', so.ScriptInstructions)+1, LEN(so.ScriptInstructions)) ,          
                        so.ScriptNote ,          
                        'R' ,          
                        so.Refills ,          
                        CASE WHEN so.DispenseAsWritten = 'Y' THEN '1'          
                             ELSE '0'          
                        END ,          
                        dbo.ssf_SureScriptsMedicationPreviewDateFormat(so.OrderDate) ,
					   dbo.ssf_SureScriptsMedicationPreviewDateFormat(CMSDP.StartDate),
					   dbo.ssf_SureScriptsMedicationPreviewDateFormat(CMSDP.EndDate),          
                        so.NDC ,          
                        CASE WHEN so.NDC IS NOT NULL THEN 'ND'          
                             ELSE NULL          
                        END,          
					   so.RelatesToMessageID,          
					   so.PotencyUnitCode,        
					   D.DEACode        
                FROM    @ScriptOutput AS so          
                JOIN @DrugsDEACodes as D ON D.ClientMedicationScriptId = so.ClientMedicationScriptId        
                JOIN ClientMedicationScriptDrugsPreview as CMSDP ON CMSDP.ClientMedicationScriptId = so.ClientMedicationScriptId --Pranay
		       
        
-- insert null value intially & Original values will be update below                       
  INSERT INTO @results(PRESCRIBER_MIDDLENAME)        
  SELECT null        
          
-- Pharmacy Information          
        IF @Preview != 'Y'           
            BEGIN          
                UPDATE  r          
                SET     NCPDPID = p.SureScriptsPharmacyIdentifier ,          
                        STORENAME = p.PharmacyName, -- ssdp.STORE_NAME , --substring(p.PharmacyName, 1, 35),          
                        PHARMACY_ADDRESS1 = p.Address,      
                        PHARMACY_CITY = p.City , --substring(p.City, 1, 35),          
						PHARMACY_STATE = p.State , --p.State,          
                        PHARMACY_ZIPCODE = p.ZipCode, --_CODE , --p.ZipCode,          
    --PHARMACY_EMAIL =          
                        PHARMACY_TE = dbo.ssf_SureScriptsFormatPhone(p.PhoneNumber) ,          
                        PHARMACY_FX = dbo.ssf_SureScriptsFormatPhone(p.FaxNumber)          
                FROM    @results AS r          
                        CROSS JOIN ClientMedicationScripts AS cms          
                        JOIN Pharmacies AS p ON p.PharmacyId = cms.PharmacyId          
						WHERE   cms.ClientMedicationScriptId in( select item from [dbo].fnSplit(@ClientMedicationScriptIds,',')  )      
            END          
        ELSE           
            BEGIN          
       UPDATE  r          
                SET     NCPDPID = p.SureScriptsPharmacyIdentifier ,          
                        STORENAME = p.PharmacyName, -- ssdp.STORE_NAME , --substring(p.PharmacyName, 1, 35),          
                        PHARMACY_ADDRESS1 = p.Address,      
                        PHARMACY_CITY = p.City , --substring(p.City, 1, 35),          
						PHARMACY_STATE = p.State , --p.State,          
                        PHARMACY_ZIPCODE = p.ZipCode, --_CODE , --p.ZipCode,            
    --PHARMACY_EMAIL =          
                        PHARMACY_TE = dbo.ssf_SureScriptsFormatPhone(p.PhoneNumber) ,          
                        PHARMACY_FX = dbo.ssf_SureScriptsFormatPhone(p.FaxNumber)          
                FROM    @results AS r          
                        CROSS JOIN ClientMedicationScriptsPreview AS cms          
                        JOIN Pharmacies AS p ON p.PharmacyId = cms.PharmacyId          
						WHERE   cms.ClientMedicationScriptId in( select item from [dbo].fnSplit(@ClientMedicationScriptIds,',')  )         
            END          
             
          
          
        IF @Preview != 'Y'           
            BEGIN          
   -- Prescriber Information          
                UPDATE  r      
                SET     PRESCRIBER_SPI = LTRIM(RTRIM(ISNULL(s.SureScriptsPrescriberId,          
                                                            '')))          
                        + LTRIM(RTRIM(ISNULL(s.SureScriptsLocationId, ''))) ,          
                        PRESCRIBER_CLINIC_NAME = SUBSTRING(ag.AgencyName, 1,          
                                                           35) ,  -- substring(l.LocationName, 1, 35),          
                        PRESCRIBER_LASTNAME = s.LastName ,          
                        PRESCRIBER_MIDDLENAME = ISNULL(s.MiddleName, '') ,          
                        PRESCRIBER_FIRSTNAME = s.FirstName ,          
                        PRESCRIBER_NAME_PREFIX = '' ,          
                        PRESCRIBER_SPECIALITY_QUALIFIER = NULL ,          
                        PRESCRIBER_SPECIALITY_CODE = sld.LicenseNumber,          
                        PRESCRIBER_ADDRESS1 = dbo.ssf_SureScriptsAddressElement(ag.Address,          
                                                              1, 'Y') ,          
                        PRESCRIBER_ADDRESS2 = '' ,          
                        PRESCRIBER_CITY = ISNULL(ag.City, '') ,       -- substring(l.City, 1, 35),          
                        PRESCRIBER_STATE = ISNULL(ag.State, '') ,     -- l.State,          
                        PRESCRIBER_ZIPCODE = CASE WHEN ( LEN(REPLACE(LTRIM(RTRIM(ag.ZipCode)),          
                                                              '-', '')) NOT IN (          
                                                         5, 9 ) )          
                                                       OR ( REPLACE(LTRIM(RTRIM(ag.ZipCode)),          
                                                              '-', '') LIKE '%[^0-9]%' )          
                                                  THEN ''          
                                ELSE REPLACE(LTRIM(RTRIM(ag.ZipCode)),          
                                                              '-', '')          
                                             END ,          
                        PRESCRIBER_EMAIL = NULL ,          
                        PRESCRIBER_TE = dbo.ssf_SureScriptsFormatPhone(s.PhoneNumber) ,          
                        PRESCRIBER_FX = dbo.ssf_SureScriptsFormatPhone(s.FaxNumber)          
                FROM    @results AS r          
                        CROSS JOIN ClientMedicationScripts AS cms          
                        CROSS JOIN Agency AS ag          
                        JOIN Staff AS s ON s.StaffId = cms.OrderingPrescriberId          
					    JOIN StaffLicenseDegrees as sld ON sld.StaffLicenseDegreeId=cms.StaffLicenseDegreeId  
						WHERE   cms.ClientMedicationScriptId in( select item from [dbo].fnSplit(@ClientMedicationScriptIds,',')  )          
            END          
        ELSE           
            BEGIN          
   -- Prescriber Information          
		UPDATE  r          
                SET     PRESCRIBER_SPI = LTRIM(RTRIM(ISNULL(s.SureScriptsPrescriberId,          
                                                            '')))          
                        + LTRIM(RTRIM(ISNULL(s.SureScriptsLocationId, ''))) ,          
                        PRESCRIBER_CLINIC_NAME = SUBSTRING(ag.AgencyName, 1,          
                                  35) ,  -- substring(l.LocationName, 1, 35),          
                        PRESCRIBER_LASTNAME = s.LastName ,          
                        PRESCRIBER_MIDDLENAME = ISNULL(s.MiddleName, '') ,          
                        PRESCRIBER_FIRSTNAME = s.FirstName ,          
                        PRESCRIBER_NAME_PREFIX = '' ,          
                        PRESCRIBER_SPECIALITY_QUALIFIER = NULL ,          
                        PRESCRIBER_SPECIALITY_CODE = sld.LicenseNumber ,          
                        PRESCRIBER_ADDRESS1 = dbo.ssf_SureScriptsAddressElement(ag.Address,          
                                                              1, 'Y') ,          
                        PRESCRIBER_ADDRESS2 = '' ,          
                        PRESCRIBER_CITY = ISNULL(ag.City, '') ,       -- substring(l.City, 1, 35),          
						PRESCRIBER_STATE = ISNULL(ag.State, '') ,     -- l.State,          
                        PRESCRIBER_ZIPCODE = CASE WHEN ( LEN(REPLACE(LTRIM(RTRIM(ag.ZipCode)),          
                                                              '-', '')) NOT IN (          
                                                         5, 9 ) )          
                                                       OR ( REPLACE(LTRIM(RTRIM(ag.ZipCode)),          
                                                              '-', '') LIKE '%[^0-9]%' )          
                                                  THEN ''          
                                                  ELSE REPLACE(LTRIM(RTRIM(ag.ZipCode)),          
                                                              '-', '')          
                                             END ,          
                        PRESCRIBER_EMAIL = NULL ,                              PRESCRIBER_TE = dbo.ssf_SureScriptsFormatPhone(s.PhoneNumber) ,          
                        PRESCRIBER_FX = dbo.ssf_SureScriptsFormatPhone(s.FaxNumber)          
                FROM    @results AS r          
                        CROSS JOIN ClientMedicationScriptsPreview AS cms          
                        CROSS JOIN Agency AS ag          
                        JOIN Staff AS s ON s.StaffId = cms.OrderingPrescriberId          
					    JOIN StaffLicenseDegrees as sld ON sld.StaffLicenseDegreeId=cms.StaffLicenseDegreeId   
						WHERE   cms.ClientMedicationScriptId in( select item from [dbo].fnSplit(@ClientMedicationScriptIds,',')  )        
            END          
             
          
-- If this is not a new order, get the client data from the refill request          
        IF ISNULL(@RefillResponseType, 'Z') NOT IN ( 'A', 'C' )           
            BEGIN          
   -- Client Information          
                   IF @Preview != 'Y'           
                    BEGIN          
                        UPDATE  r          
                        SET     PATIENT_FILE_ID = CAST(cms.ClientId AS VARCHAR(35)) ,          
                                PATIENT_LASTNAME = SUBSTRING(LTRIM(RTRIM(c.LastName)),          
                                                             1, 35) ,          
                                PATIENT_FIRSTNAME = SUBSTRING(LTRIM(RTRIM(c.FirstName)),          
                                                              1, 35) ,          
								PATIENT_MIDDLENAME = ISNULL(SUBSTRING(LTRIM(RTRIM(c.MiddleName)),          
                                                              1, 35), '') ,          
                                PATIENT_GENDER = CASE WHEN c.Sex NOT IN ( 'M',          
                                                              'F' ) THEN 'U'          
                                                      ELSE c.Sex          
                                                 END ,          
                                PATIENT_DOB = dbo.ssf_SureScriptsFormatDate(c.DOB) ,          
                                PATIENT_ADDRESS1 = dbo.ssf_SureScriptsAddressElement(ca.Address,          
                                                              1, 'Y') ,          
								PATIENT_ADDRESS2 = dbo.ssf_SureScriptsAddressElement(ca.Address,          
                                                              2, 'Y') ,          
                                PATIENT_CITY = SUBSTRING(ca.City, 1, 35) ,          
                                PATIENT_STATE = CASE WHEN LEN(ISNULL(LTRIM(RTRIM(ca.State)),          
								'')) <> 2          
                                                     THEN ''          
                                                     ELSE LTRIM(RTRIM(ca.State))          
                                                END ,          
                                PATIENT_ZIPCODE = CASE WHEN ( LEN(REPLACE(LTRIM(RTRIM(ca.Zip)),          
                                                              '-', '')) NOT IN (          
                                                              5, 9 ) )          
                                                            OR ( REPLACE(LTRIM(RTRIM(ca.Zip)),          
                                                              '-', '') LIKE '%[^0-9]%' )          
                                                       THEN ''          
                                                       ELSE REPLACE(LTRIM(RTRIM(ca.Zip)),          
                                                              '-', '')          
                                                  END ,          
       --PATIENT_EMAIL varchar(80),  --PATIENT EMAIL          
                                PATIENT_TE = dbo.ssf_SureScriptsFormatPhone(ISNULL(cp.PhoneNumber,          
                                                              cp2.PhoneNumber)) ,          
                                PATIENT_CP = dbo.ssf_SureScriptsFormatPhone(ISNULL(ch.PhoneNumber,          
                                                              ch2.PhoneNumber))          
                        FROM    @results AS r          
                                CROSS JOIN ClientMedicationScripts AS cms          
                  JOIN Clients AS c ON c.ClientId = cms.ClientId          
                                LEFT OUTER JOIN ClientAddresses AS ca ON ca.ClientId = c.ClientId          
                                                              AND ca.AddressType = 90          
                                                              AND ISNULL(ca.RecordDeleted,          
                                                              'N') <> 'Y'          
                                LEFT OUTER JOIN ClientPhones AS cp ON cp.ClientId = c.ClientId          
                                                              AND cp.PhoneType = 30          
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
       WHERE     cms.ClientMedicationScriptId in( select item from [dbo].fnSplit(@ClientMedicationScriptIds,',')  ) and                
                                 NOT EXISTS ( SELECT *          
                                                 FROM   ClientAddresses AS ca3          
                                                 WHERE  ca3.ClientId = ca.ClientId          
                                                        AND ca3.AddressType = ca.AddressType          
                                                        AND ISNULL(ca3.RecordDeleted,          
                                                              'N') <> 'Y'          
                                                        AND ca3.ClientAddressId > ca.ClientAddressId )          
                              AND NOT EXISTS ( SELECT *          
                                                 FROM   ClientPhones AS cp3          
                                                 WHERE  cp3.ClientId = cp.ClientId          
													AND cp3.PhoneType = cp.PhoneType          
                                                        AND ISNULL(cp3.RecordDeleted,          
                                                              'N') <> 'Y'          
                                                        AND cp3.ClientPhoneId > cp.ClientPhoneId )          
                                AND NOT EXISTS ( SELECT *          
                                                 FROM   ClientPhones AS cp3          
                                                 WHERE  cp3.ClientId = cp2.ClientId          
                                                        AND cp3.PhoneType = cp2.PhoneType          
                                                        AND ISNULL(cp3.RecordDeleted,          
                                                              'N') <> 'Y'          
                                                        AND cp3.ClientPhoneId > cp2.ClientPhoneId )          
                                AND NOT EXISTS ( SELECT *          
                                                 FROM   ClientPhones AS cp3         
                                                 WHERE  cp3.ClientId = ch.ClientId          
                                                        AND cp3.PhoneType = ch.PhoneType          
                                                        AND ISNULL(cp3.RecordDeleted,          
                                                              'N') <> 'Y'          
                                                        AND cp3.ClientPhoneId > ch.ClientPhoneId )          
                                AND NOT EXISTS ( SELECT *          
                                                 FROM   ClientPhones AS cp3          
                                                 WHERE  cp3.ClientId = ch2.ClientId          
                                                        AND cp3.PhoneType = ch2.PhoneType          
                                                        AND ISNULL(cp3.RecordDeleted,          
                                                              'N') <> 'Y'          
                                                        AND cp3.ClientPhoneId > ch2.ClientPhoneId )          
                    END          
                ELSE           
                    BEGIN          
                    
      UPDATE  r          
                        SET     PATIENT_FILE_ID = CAST(cms.ClientId AS VARCHAR(35)) ,          
                                PATIENT_LASTNAME = SUBSTRING(LTRIM(RTRIM(c.LastName)),          
                                                             1, 35) ,          
                                PATIENT_FIRSTNAME = SUBSTRING(LTRIM(RTRIM(c.FirstName)),          
                                                              1, 35) ,          
                                PATIENT_MIDDLENAME = ISNULL(SUBSTRING(LTRIM(RTRIM(c.MiddleName)),          
                                                              1, 35), '') ,          
                                PATIENT_GENDER = CASE WHEN c.Sex NOT IN ( 'M',          
                                                              'F' ) THEN 'U'          
                                                      ELSE c.Sex          
                                                 END ,          
                                PATIENT_DOB = dbo.ssf_SureScriptsFormatDate(c.DOB) ,          
                                PATIENT_ADDRESS1 = LTRIM(RTRIM(dbo.ssf_SureScriptsAddressElement(ca.Address,          
                                                              1, 'Y'))) ,          
                                PATIENT_ADDRESS2 = LTRIM(RTRIM(dbo.ssf_SureScriptsAddressElement(ca.Address,          
                                                              2, 'Y'))) ,          
                                PATIENT_CITY = SUBSTRING(LTRIM(RTRIM(ca.City)), 1, 35) ,          
                                PATIENT_STATE = CASE WHEN LEN(ISNULL(LTRIM(RTRIM(ca.State)),          
                                                              '')) <> 2          
                     THEN ''          
                                                     ELSE LTRIM(RTRIM(ca.State))          
                                                END ,          
                                PATIENT_ZIPCODE = CASE WHEN ( LEN(REPLACE(LTRIM(RTRIM(ca.Zip)),          
                                                              '-', '')) NOT IN (          
                                                              5, 9 ) )          
                                                            OR ( REPLACE(LTRIM(RTRIM(ca.Zip)),          
                                                              '-', '') LIKE '%[^0-9]%' )          
                                                       THEN ''          
                                                       ELSE REPLACE(LTRIM(RTRIM(ca.Zip)),          
                                                              '-', '')          
                                                  END ,          
								PATIENT_TE = dbo.ssf_SureScriptsFormatPhone(ISNULL(cp.PhoneNumber,          
                                                              cp2.PhoneNumber)) ,          
								PATIENT_CP = dbo.ssf_SureScriptsFormatPhone(ISNULL(ch.PhoneNumber,          
                                                              ch2.PhoneNumber))          
                        FROM    @results AS r          
                                CROSS JOIN ClientMedicationScriptsPreview AS cms          
                                JOIN Clients AS c ON c.ClientId = cms.ClientId          
                                LEFT OUTER JOIN ClientAddresses AS ca ON ca.ClientId = c.ClientId          
                                                              AND ca.AddressType = 90          
                                                              AND ISNULL(ca.RecordDeleted,          
                                                              'N') <> 'Y'          
                                LEFT OUTER JOIN ClientPhones AS cp ON cp.ClientId = c.ClientId          
                                                              AND cp.PhoneType = 30          
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
                        WHERE   cms.ClientMedicationScriptId in( select item from [dbo].fnSplit(@ClientMedicationScriptIds,',')  ) and                  
                                 NOT EXISTS ( SELECT *          
                                                 FROM   ClientAddresses AS ca3          
                                                 WHERE  ca3.ClientId = ca.ClientId          
                                                        AND ca3.AddressType = ca.AddressType          
                                                        AND ISNULL(ca3.RecordDeleted,          
                                                         'N') <> 'Y'          
                                                        AND ca3.ClientAddressId > ca.ClientAddressId )          
                                AND NOT EXISTS ( SELECT *          
                                                 FROM   ClientPhones AS cp3          
                                                 WHERE  cp3.ClientId = cp.ClientId          
                                                        AND cp3.PhoneType = cp.PhoneType          
                                                        AND ISNULL(cp3.RecordDeleted,          
                                                              'N') <> 'Y'          
                                                        AND cp3.ClientPhoneId > cp.ClientPhoneId )          
                                AND NOT EXISTS ( SELECT *          
                                                 FROM   ClientPhones AS cp3          
                                                 WHERE  cp3.ClientId = cp2.ClientId          
                                                        AND cp3.PhoneType = cp2.PhoneType          
                                                        AND ISNULL(cp3.RecordDeleted,          
                                                 'N') <> 'Y'          
                                                        AND cp3.ClientPhoneId > cp2.ClientPhoneId )          
                                AND NOT EXISTS ( SELECT *          
                                                 FROM   ClientPhones AS cp3          
                                                 WHERE  cp3.ClientId = ch.ClientId          
                                                        AND cp3.PhoneType = ch.PhoneType          
                                                        AND ISNULL(cp3.RecordDeleted,          
                                                              'N') <> 'Y'          
                                                        AND cp3.ClientPhoneId > ch.ClientPhoneId )          
                                AND NOT EXISTS ( SELECT *          
                                                 FROM   ClientPhones AS cp3          
                                                 WHERE  cp3.ClientId = ch2.ClientId          
                                                        AND cp3.PhoneType = ch2.PhoneType          
                                                        AND ISNULL(cp3.RecordDeleted,          
                                                              'N') <> 'Y'          
                                                        AND cp3.ClientPhoneId > ch2.ClientPhoneId )          
          
           
            
                        
                    END          
            END                  ELSE           
            BEGIN          
                DECLARE @SurescriptsRefillRequestId INT          
                IF @Preview = 'Y'           
                    BEGIN          
                        SELECT  top 1 @SurescriptsRefillRequestId = SurescriptsRefillRequestId          
                        FROM    ClientMedicationScriptsPreview          
                        WHERE   ClientMedicationScriptId in( select item from [dbo].fnSplit(@ClientMedicationScriptIds,',')  )         
          
                    END         
                ELSE           
                    BEGIN          
                        SELECT top 1 @SurescriptsRefillRequestId = SurescriptsRefillRequestId          
                        FROM    ClientMedicationScripts          
                        WHERE   ClientMedicationScriptId in( select item from [dbo].fnSplit(@ClientMedicationScriptIds,',')  )        
          
                    END          
          
                DECLARE @patientInfo TABLE          
                    (          
                      PATIENT_FILE_ID VARCHAR(35) ,          
                      PATIENT_LASTNAME VARCHAR(100) ,          
                      PATIENT_FIRSTNAME VARCHAR(100) ,          
                      PATIENT_MIDDLENAME VARCHAR(100) ,          
					  PATIENT_GENDER VARCHAR(5) ,          
                      PATIENT_DOB VARCHAR(10) ,          
                      PATIENT_ADDRESS1 VARCHAR(100) ,          
                      PATIENT_ADDRESS2 VARCHAR(100) ,          
                      PATIENT_CITY VARCHAR(100) ,          
                      PATIENT_STATE VARCHAR(5) ,          
                      PATIENT_ZIPCODE VARCHAR(100) ,          
                      PATIENT_TE VARCHAR(100) ,          
                      PATIENT_CP VARCHAR(100)          
                    )          
          
                INSERT  INTO @patientInfo          
                        EXEC csp_RDLClientPrescriptionSurescriptsPatientInfo @SurescriptsRefillRequestId          
          
                UPDATE  r          
                SET     PATIENT_FILE_ID = p.PATIENT_FILE_ID ,                          PATIENT_LASTNAME = p.PATIENT_LASTNAME ,          
                        PATIENT_FIRSTNAME = p.PATIENT_FIRSTNAME ,          
                        PATIENT_MIDDLENAME = p.PATIENT_MIDDLENAME ,          
                        PATIENT_GENDER = p.PATIENT_GENDER ,          
                        PATIENT_DOB = p.PATIENT_DOB ,          
                        PATIENT_ADDRESS1 = p.PATIENT_ADDRESS1 ,          
                        PATIENT_ADDRESS2 = p.PATIENT_ADDRESS2 ,          
                        PATIENT_CITY = p.PATIENT_CITY ,          
                    PATIENT_STATE = p.PATIENT_STATE ,          
                        PATIENT_ZIPCODE = p.PATIENT_ZIPCODE ,          
                        PATIENT_TE = p.PATIENT_TE ,          
                        PATIENT_CP = p.PATIENT_CP          
                FROM    @results AS r          
                        CROSS JOIN @patientInfo AS p          
          
                
            END          
          
        declare @ControlledMedicationScriptIds varchar(max)  
			set @ControlledMedicationScriptIds = (SELECT ISNULL(STUFF((SELECT ' ,' + cast(ISNULL(ClientMedicationScriptId,'') as varchar)  
			FROM @medicationresults where DEACode<> 0 FOR XML PATH(''),type ).value('.', 'nvarchar(max)'), 1, 2, ' '), '') )    
          
        SELECT  ClientMedicationScriptId,           
                DRUG_DESCRIPTION ,          
                PRODUCT_CODE ,          
                PRODUCT_CODE_QUALIFIER ,          
                DOSAGE_FORM ,          
                STRENGTH ,          
                STRENGTH_UNITS ,          
                CASE WHEN qtyCode.SmartCareRxCode IS NULL          
                     THEN r.DRUG_QUANTITY_QUALIFIER          
                     ELSE qtyCode.SmartCareRxCode          
                END AS DRUG_QUANTITY_QUALIFIER ,          
                DRUG_QUANTITY_VALUE ,          
                DRUG_DAYS_SUPPLY ,          
                DRUG_DIRECTIONS ,          
                DRUG_INSTRUCTIONS,        
                --CASE WHEN ISNULL(@RefillResponseType, 'Z') IN ( 'A', 'C' )          
                --     THEN NULL          
                --     ELSE DRUG_NOTE          
                --END AS DRUG_NOTE ,          
				DRUG_NOTE,          
                REFILL_QUALIFIER ,          
                REFILL_QUANTITY ,          
                CASE WHEN SUBSTITUTIONS = '1' THEN 'Not Allowed'          
                     ELSE 'Allowed'          
                END AS SUBSTITUTIONS ,          
				REPLACE(written_date, '-', '/') AS WRITTEN_DATE , 
				REPLACE(p_start_date, '-', '/') AS P_START_DATE,
				REPLACE(p_end_date, '-', '/') AS P_END_DATE,         
                REPLACE(last_fill_date,'-','/')  AS LAST_FILL_DATE,          
				RELATES_TO_MESSAGEID,          
				POTENCY_UNIT_CODE,          
				ISNULL(@RefillResponseType,' ') AS RefillResponseType,        
				DEACode,  
				@ControlledMedicationScriptIds as ControlledMedicationScriptIds        
              
        FROM    @medicationresults AS r          
                --LEFT OUTER JOIN SureScriptsCodes AS qtyCode ON qtyCode.Category = 'QUANTITYTYPE'          
                --                                              AND qtyCode.SurescriptsCode = r.DRUG_QUANTITY_QUALIFIER          
		LEFT OUTER JOIN SureScriptsCodes AS qtyCode ON qtyCode.Category = 'QuantityUnitOfMeasure'          
                                                              AND qtyCode.SurescriptsCode = r.POTENCY_UNIT_CODE      
		order by DEACode desc                                                                    
          
  SELECT          
                NCPDPID ,          
                STORENAME ,          
                PHARMACY_ADDRESS1 ,          
                PHARMACY_ADDRESS2 ,          
                PHARMACY_CITY ,          
                PHARMACY_STATE ,          
                PHARMACY_ZIPCODE ,          
                PHARMACY_EMAIL ,          
                dbo.csf_RDLSurescriptsFormatPhone(PHARMACY_TE) AS PHARMACY_TE ,          
                dbo.csf_RDLSurescriptsFormatPhone(PHARMACY_FX) AS PHARMACY_FX ,          
                '<b>Pharmacy Information </b><br> ' +        
                '<b>' + ISNULL(STORENAME,'') + ' - NCPDP ID:  '+ ISNULL(NCPDPID,'') + '</b><br> ' +        
                ISNULL(PHARMACY_ADDRESS1,'') + ' ' + ISNULL(PHARMACY_CITY,'') + ', ' + ISNULL(PHARMACY_STATE,'') + ' ' + ISNULL(PHARMACY_ZIPCODE,'') +'<br> ' +        
                'P: '+ ISNULL(dbo.csf_RDLSurescriptsFormatPhone(PHARMACY_TE),'') + ' &nbsp; F: ' + ISNULL(dbo.csf_RDLSurescriptsFormatPhone(PHARMACY_FX),'') + '<br> ' as PHARMACYDETIALS,        
                PRESCRIBER_SPI ,          
                PRESCRIBER_CLINIC_NAME ,          
                PRESCRIBER_LASTNAME ,          
                PRESCRIBER_MIDDLENAME ,          
                PRESCRIBER_FIRSTNAME ,          
                PRESCRIBER_NAME_PREFIX ,          
                PRESCRIBER_SPECIALITY_QUALIFIER ,          
                PRESCRIBER_SPECIALITY_CODE,          
                PRESCRIBER_ADDRESS1 ,          
                PRESCRIBER_ADDRESS2 ,          
                PRESCRIBER_CITY ,          
                PRESCRIBER_STATE ,          
                PRESCRIBER_ZIPCODE ,          
                PRESCRIBER_EMAIL ,          
                dbo.csf_RDLSurescriptsFormatPhone(PRESCRIBER_TE) AS PRESCRIBER_TE ,          
                dbo.csf_RDLSurescriptsFormatPhone(PRESCRIBER_FX) AS PRESCRIBER_FX ,          
                '<b>Prescriber Information </b><br> ' +        
                '<b>' + ISNULL(PRESCRIBER_LASTNAME,'') + ', '+ ISNULL(PRESCRIBER_FIRSTNAME,'') + '</b><br> ' +        
                ISNULL(PRESCRIBER_ADDRESS1,'') + ' ' + ISNULL(PRESCRIBER_ADDRESS2,'') + ' ' + ISNULL(PRESCRIBER_CITY,'') + ', ' + ISNULL(PRESCRIBER_STATE,'') + ' ' + ISNULL(PRESCRIBER_ZIPCODE,'') +'<br> ' +        
                'P: '+ ISNULL(dbo.csf_RDLSurescriptsFormatPhone(PRESCRIBER_TE),'') + ' &nbsp; F: ' + ISNULL(dbo.csf_RDLSurescriptsFormatPhone(PRESCRIBER_FX),'') + '<br> ' +        
                'DEA: '+ ISNULL(PRESCRIBER_SPECIALITY_CODE,'') as PRESCRIBERDETAILS,
                PATIENT_FILE_ID ,          
                PATIENT_LASTNAME ,          
                PATIENT_MIDDLENAME ,          
                PATIENT_FIRSTNAME ,          
                PATIENT_GENDER ,          
    --CONVERT(VARCHAR(10), CAST(patient_dob AS DATE), 101),          
                SUBSTRING(PATIENT_DOB, 6, 2) + '/' + SUBSTRING(PATIENT_DOB, 9,          
                                                              2) + '/'          
                + SUBSTRING(PATIENT_DOB, 1, 4) AS PATIENT_DOB ,          
                PATIENT_ADDRESS1 ,          
                PATIENT_ADDRESS2 ,          
                PATIENT_CITY ,          
                PATIENT_STATE ,          
                PATIENT_ZIPCODE ,          
                PATIENT_EMAIL ,          
                dbo.csf_RDLSurescriptsFormatPhone(PATIENT_TE) AS PATIENT_TE ,          
                dbo.csf_RDLSurescriptsFormatPhone(PATIENT_CP) AS PATIENT_CP,        
                '<b>Client Information </b><br> ' +        
                '<b>' + ISNULL(PATIENT_LASTNAME,'') + ', '+ ISNULL(PATIENT_FIRSTNAME,'') + ' ' +  ISNULL(PATIENT_MIDDLENAME,'') + '</b><br> ' +        
                'Gender:' + ISNULL(PATIENT_GENDER,'') +  '&nbsp;&nbsp; DOB:' + ISNULL(SUBSTRING(PATIENT_DOB, 6, 2) + '/' + SUBSTRING(PATIENT_DOB, 9,2) + '/'+ SUBSTRING(PATIENT_DOB, 1, 4),'') +'<br> ' +        
                ISNULL(PATIENT_ADDRESS1,'') + ' ' +ISNULL(PATIENT_ADDRESS2,'') + ISNULL(PATIENT_CITY,'') + ', ' + ISNULL(PATIENT_STATE,'') + ' ' + ISNULL(PATIENT_ZIPCODE,'') +'<br> ' +        
                'H: '+ ISNULL(dbo.csf_RDLSurescriptsFormatPhone(PATIENT_TE),'') + ' &nbsp; M: ' + ISNULL(dbo.csf_RDLSurescriptsFormatPhone(PATIENT_CP),'') as PATIENTDETAILS        
		FROM    @results AS r     
       
                     
        --COMMIT TRAN          
          
    END TRY          
    BEGIN CATCH          
     DECLARE @errMessage NVARCHAR(4000)          
        SET @errMessage = ERROR_MESSAGE()          
          
        RAISERROR(@errMessage, 16, 1)          
    END CATCH          
          






GO


