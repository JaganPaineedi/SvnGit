/****** Object:  StoredProcedure [dbo].[ssp_RxGetElectronicPrescriptions]    Script Date: 06/02/2016 19:48:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RxGetElectronicPrescriptions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RxGetElectronicPrescriptions]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RxGetElectronicPrescriptions]    Script Date: 06/02/2016 19:48:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

          
            
CREATE PROCEDURE [dbo].[ssp_RxGetElectronicPrescriptions]          
    @ClientMedicationScriptIds varchar(max) ,          
    @OriginalData INT          
        
AS 
/*============================================================================================
Changelog:   
--  Date			Author			Purpose
06/ 01 /2016		Vithobha		To get Electronic Prescribed Medication data for preview list 
03/ 24/ 2017	     Wasif			Added logic to check if ';' exists before splitting string.
04/ 26/ 2017         Pranay          Added left Join for 'SureScriptsPharmacyUpdate' to get Pharmacy_Address1 and Address2
04/ 26/ 2017         Pranay          Added Case statements for the Pharmacy details if Pharmacy details are not Present in SureScriptsPharmacyUpdate then get from Pharmacies Table
06/16/2017			 jcarlson		Updated preview logic to fix issues with Titration on the preview screen
27/Sep/2017		     Irfan			What: Changed the length of these field 'STORENAME' from 35 to 100 and for PHARMACY_ZIPCODE from 9 to 12.
									Since the length of the Pharmacy Name and ZipCode was small and when we prescribe medication, the rdl was not loading in Rx. 
									Why: Spring River - Environment Issues Tracking -#105
10/19/2017          Pranay          Added Case Statement to get DAW(Substitution) value w.r.t MU stage3
24 Oct 2017			Vithobha		Hiding Pharmacy Information if PharmacyId is not saved, Thresholds - Support 1067
10/31/2017          Pranay          added  LEFT JOIN dbo.Locations AS ag ON ag.LocationId = cms.LocationId    w.r.t, Threshold -Support Task#1065
11/8/2017       Robert Caffrey      Changed Prescriber Phone and Fax to pull from Location to match Printed Scripts - CEI Support #817
09/8/2017		    Nandita			Added logic to check if atleast one phone is present for a client and not just 'Home' type
12/04/2017          Pranay          Added JOIN condition  MDMedications AS mdm ON mdm.MedicationId=cmi.StrengthId w.r.t 	Key Point - Support Go Live 1206
12/06/2017         PranayB           Added @AddressType w.r.t CEI-SupportGoLive Task#854
12/18/2017         PranayB          PranayB Added ca.AddressType OrderBy w.r.t CEI -support Task#854 
1/11/2018          PranayB          PranayB Added @ClientMedicationScriptId1 w.r.t CEI Task# 867.   
30/Jan/2018			Vithobha		Corrected the issues with Phone number on Client Prescription, Offshore QA Bugs: #644
03/21/2018         Bernardin        As "LicenseNumber" column length is 25 in "StaffLicenseDegrees" table. But the local variable declared only 10 charactoers. It's Changed PRESCRIBER_SPECIALITY_CODE VARCHAR(10) to PRESCRIBER_SPECIALITY_CODE VARCHAR(25). Barry Build Cycle Tasks# 3	
10/18/2018         Pranay B        Added isnull(cmi.Active,'Y')<>'N' w.r.t Boundless Task# 265
===========================================================================================*/          
    BEGIN TRY          
        
          
        --BEGIN TRAN          
          
        DECLARE @Preview CHAR(1)  
        DECLARE @PharmacyId INT
        DECLARE @AddressType INT  
		DECLARE @PhoneNumberType varchar(30)
	    DECLARE @PhoneNumberType1 varchar(30)    
        DECLARE @RefillResponseType CHAR(1) = NULL --'N'           
          
  DECLARE @results TABLE        
  (          
   --PHARMACY DETAILS          
              NCPDPID VARCHAR(35) ,  --ID OF THE  PHARMACY          
              STORENAME VARCHAR(100) ,  --NAME OF THE PHARMACY STORE    --Modified on 28-Sep-2017 by Irfan      
              PHARMACY_ADDRESS1 VARCHAR(35) ,  --PRIMARY ADDRESS OF PHARMACY          
              PHARMACY_ADDRESS2 VARCHAR(35) ,  --ADDRESS LINE2 OF PHARMACY          
              PHARMACY_CITY VARCHAR(35) ,  --PHARMACY CITY          
              PHARMACY_STATE VARCHAR(2) ,  --PHARMACY STATE          
              PHARMACY_ZIPCODE VARCHAR(12) ,  --PHARMACY ZIP CODE		 --Modified on 28-Sep-2017 by Irfan     
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
              PRESCRIBER_SPECIALITY_CODE VARCHAR(25) ,  --DEA SPECIALITY CODE         
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
    DECLARE @ClientMedicationScriptId1 int
	SELECT TOP 1 @ClientMedicationScriptId1 =item
				FROM [dbo].fnSplit(@ClientMedicationScriptIds, ',')       
        IF @OriginalData > 0           
            SET @Preview = 'N'          
        ELSE           
            SET @Preview = 'Y'        
           
           --24 Oct 2017			Vithobha	 
		IF @Preview = 'Y'
			BEGIN
				SELECT TOP 1 @PharmacyId = PharmacyId
				FROM ClientMedicationScriptsPreview
				WHERE ClientMedicationScriptId IN (
				SELECT item
				FROM [dbo].fnSplit(@ClientMedicationScriptIds, ',')	)
			
			SELECT @AddressType = ca.AddressType
                             FROM   ClientAddresses ca
                                    JOIN dbo.ClientMedicationScriptsPreview cp ON cp.ClientId = ca.ClientId
                             WHERE  ISNULL(ca.Address, '') != ''
                                    AND ISNULL(ca.City, '') != ''
                                    AND ISNULL(ca.State, '') != ''
                                    AND ISNULL(ca.Zip, '') != ''
                                    AND ISNULL(ca.RecordDeleted, 'N') != 'Y'
                                    AND cp.ClientMedicationScriptId = @ClientMedicationScriptId1
									ORDER BY CASE WHEN ca.AddressType = 90 THEN 1 --Home
                                    WHEN ca.AddressType = 92 THEN 2 --Temporary Residence
                                    WHEN ca.AddressType = 91 THEN 3 --Office
                                    WHEN ca.AddressType = 93 THEN 4-- other
                                    ELSE 5
                                    END ASC;
                                    
            DECLARE @PhoneNumberTemp TABLE (PhoneType varchar(30),row int)
								;with CTE_Phone
								AS
								(SELECT top 2 ca.PhoneType,row_number() OVER(ORDER BY CASE WHEN ca.PhoneType = 30 THEN 1 --Home
											  WHEN ca.PhoneType = 32 THEN 2 --Home2
											  WHEN ca.PhoneType = 34 THEN 3 --Mobile
											  WHEN ca.PhoneType = 35 THEN 4-- Mobile 2
											  WHEN ca.PhoneType = 31 THEN 5-- Business
											  WHEN ca.PhoneType = 33 THEN 6-- Business 2
											  WHEN ca.PhoneType = 37 THEN 7 -- School
											  WHEN ca.PhoneType = 38 THEN 8 --Other
											  ELSE 9
										 END ASC ) As row
								FROM    ClientPhones ca
										JOIN dbo.ClientMedicationScriptsPreview cp ON cp.ClientId = ca.ClientId
								WHERE   ISNULL(ca.PhoneNumber, '') != ''
										AND ISNULL(ca.RecordDeleted, 'N') = 'N'
										AND cp.ClientMedicationScriptId = @ClientMedicationScriptId1
										 )
									 
									 INSERT INTO  @PhoneNumberTemp(PhoneType,row)
									 SELECT PhoneType,row from CTE_Phone
									 
									 SELECT @PhoneNumberType=PhoneType FROM @PhoneNumberTemp where row=1
									 SELECT @PhoneNumberType1=PhoneType FROM @PhoneNumberTemp where row=2
			END
		ELSE
			BEGIN
				SELECT TOP 1 @PharmacyId = PharmacyId
				FROM ClientMedicationScripts
				WHERE ClientMedicationScriptId IN (
				SELECT item
				FROM [dbo].fnSplit(@ClientMedicationScriptIds, ',')	)
			
			SELECT @AddressType = ca.AddressType
                             FROM   ClientAddresses ca
                                    JOIN dbo.ClientMedicationScripts cp ON cp.ClientId = ca.ClientId
                             WHERE  ISNULL(ca.Address, '') != ''
                                    AND ISNULL(ca.City, '') != ''
                                    AND ISNULL(ca.State, '') != ''
                                    AND ISNULL(ca.Zip, '') != ''
                                    AND ISNULL(ca.RecordDeleted, 'N') != 'Y'
                                    AND cp.ClientMedicationScriptId = @ClientMedicationScriptId1
									ORDER BY CASE WHEN ca.AddressType = 90 THEN 1 --Home
                                    WHEN ca.AddressType = 92 THEN 2 --Temporary Residence
                                    WHEN ca.AddressType = 91 THEN 3 --Office
                                    WHEN ca.AddressType = 93 THEN 4-- other
                                    ELSE 5
                                    END ASC;
                                     SELECT @PhoneNumberType = ca.PhoneType
                                     FROM   ClientPhones ca
                                            JOIN dbo.ClientMedicationScripts cp ON cp.ClientId = ca.ClientId
                                     WHERE  ISNULL(ca.PhoneNumber, '') != ''
                                            AND ISNULL(ca.RecordDeleted, 'N') = 'N'
                                            AND cp.ClientMedicationScriptId = @ClientMedicationScriptId1
                                     ORDER BY CASE WHEN ca.PhoneType = 30
                                                   THEN 1 --Home
                                                   WHEN ca.PhoneType = 32
                                                   THEN 2 --Home2
                                                   WHEN ca.PhoneType = 34
                                                   THEN 3 --Mobile
                                                   WHEN ca.PhoneType = 35
                                                   THEN 4-- Mobile 2
                                                   WHEN ca.PhoneType = 31
                                                   THEN 5-- Business
                                                   WHEN ca.PhoneType = 33
                                                   THEN 6-- Business 2
                                                   WHEN ca.PhoneType = 37
                                                   THEN 7 -- School
                                                   WHEN ca.PhoneType = 38
                                                   THEN 8 --Other
                                                   ELSE 9
                                              END ASC;
			END
                    
                
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
                        AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y' AND ISNULL(cmi.Active,'Y')='Y'             
              
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
						AND ISNULL(cmi.Active,'Y')<>'N'          
              
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
			 select cmsp.ClientMedicationScriptId
				  , ''--a.RxReferenceNumber
				  , ''---a.PON
				  , mdm.MedicationDescription--a.DrugDescription
				  , ''--a.SureScriptsQuantityQualifier
				  , cmsd.Pharmacy
				  , ''--a.TotalDaysInScript
				  , CONVERT(VARCHAR(MAX),cmi.Quantity) + ' (' + gcUnit.CodeName + ') ' + gcSch.CodeName AS Directions
				  , cmsd.SpecialInstructions AS SpecialInstructions
				  , CASE
                                                              WHEN ISNULL(cmp.IncludeCommentOnPrescription,
                                                              'N') = 'Y'
                                                              THEN cmp.Comments
                                                              ELSE NULL
                                                            END
				  , 'R'
				  , cmsd.Refills
				  , CASE WHEN cmp.DAW = 'Y' THEN '1'          
                            ELSE '0'          
                       END 
				  , dbo.ssf_SureScriptsMedicationPreviewDateFormat(cmsp.OrderDate) 
				  , dbo.ssf_SureScriptsMedicationPreviewDateFormat(cmsd.StartDate)
				  , dbo.ssf_SureScriptsMedicationPreviewDateFormat(cmsd.EndDate)  
				  , ''--a.NDC           
                  , ''--CASE WHEN a.NDC IS NOT NULL THEN 'ND'          
					   --  ELSE NULL          
                    --END         
				  , ''--a.RelatesToMessageID
				  , ''--a.PotencyUnitCode
				  , dea.DEACode
				   FROM dbo.ClientMedicationScriptsPreview AS cmsp
				JOIN dbo.ClientMedicationScriptDrugspreview as cmsd on cmsd.ClientMedicationScriptId = cmsp.ClientMedicationScriptId
				JOIN @DrugsDEACodes AS dea ON dea.ClientMedicationScriptDrugId = cmsd.ClientMedicationScriptDrugId
				JOIN dbo.ClientMedicationInstructionspreview as cmi on cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId
				JOIN dbo.ClientMedicationsPreview AS cmp ON cmp.ClientMedicationId = cmi.ClientMedicationId
				JOIN dbo.MDMedicationNames AS MDmed ON MDmed.MedicationNameId = cmp.MedicationNameId
				jOIN MDMedications AS mdm ON mdm.MedicationId=cmi.StrengthId
				JOIN dbo.GlobalCodes AS gcUnit ON cmi.Unit = gcUnit.GlobalCodeId
				JOIN dbo.GlobalCodes AS gcSch ON cmi.Schedule = gcSch.GlobalCodeId
				WHERE EXISTS( SELECT 1
							  FROM @ScriptOutput AS a
							  WHERE a.ClientMedicationScriptId = cmsp.ClientMedicationScriptId )
	       
        
-- insert null value intially & Original values will be update below                       
  INSERT INTO @results(PRESCRIBER_MIDDLENAME)        
  SELECT null        
          
-- Pharmacy Information          
        IF @Preview != 'Y'           
            BEGIN          
                UPDATE  r          
                SET     NCPDPID = p.SureScriptsPharmacyIdentifier ,          
                STORENAME =CASE WHEN ssdp.StoreName IS NULL THEN p.PharmacyName ELSE ssdp.StoreName END, -- ssdp.STORE_NAME , --substring(p.PharmacyName, 1, 35),          
                PHARMACY_ADDRESS1 = CASE WHEN ssdp.ADDRESSLine1 IS NULL THEN LEFT(p.Address,35) ELSE ssdp.ADDRESSLine1 END, --substring(p.Address, 1, 35),
				PHARMACY_ADDRESS2 = CASE WHEN ssdp.ADDRESSLine2 IS NULL THEN '' ELSE ssdp.ADDRESSLine2 END, --'',
				PHARMACY_CITY = CASE WHEN ssdp.City IS NULL THEN  p.City ELSE ssdp.City END, --substring(p.City, 1, 35),
				PHARMACY_STATE = CASE WHEN ssdp.STATE IS NULL THEN p.State ELSE	ssdp.State END, --p.State,
				PHARMACY_ZIPCODE = CASE WHEN ssdp.zip IS NULL THEN p.ZipCode ELSE ssdp.Zip END, --ssdp.ZIP_CODE , --p.ZipCode,       
    --PHARMACY_EMAIL =          
                        PHARMACY_TE = dbo.ssf_SureScriptsFormatPhone(p.PhoneNumber) ,          
                        PHARMACY_FX = dbo.ssf_SureScriptsFormatPhone(p.FaxNumber)          
                FROM    @results AS r          
                        CROSS JOIN ClientMedicationScripts AS cms          
                        JOIN Pharmacies AS p ON p.PharmacyId = cms.PharmacyId
						LEFT JOIN dbo.SureScriptsPharmacyUpdate AS ssdp ON ( ssdp.NCPDPID = p.SureScriptsPharmacyIdentifier )          
						WHERE   cms.ClientMedicationScriptId in( select item from [dbo].fnSplit(@ClientMedicationScriptIds,',')  )      
            END          
        ELSE           
            BEGIN          
       UPDATE  r          
                SET     NCPDPID = p.SureScriptsPharmacyIdentifier ,          
                STORENAME =CASE WHEN ssdp.StoreName IS NULL THEN p.PharmacyName ELSE ssdp.StoreName END, -- ssdp.STORE_NAME , --substring(p.PharmacyName, 1, 35),          
                PHARMACY_ADDRESS1 = CASE WHEN ssdp.ADDRESSLine1 IS NULL THEN LEFT(p.Address,35) ELSE ssdp.ADDRESSLine1 END, --substring(p.Address, 1, 35),
				PHARMACY_ADDRESS2 = CASE WHEN ssdp.ADDRESSLine2 IS NULL  THEN '' ELSE ssdp.ADDRESSLine2 END, --'',
				PHARMACY_CITY = CASE WHEN ssdp.City IS NULL THEN  p.City ELSE ssdp.City END, --substring(p.City, 1, 35),
				PHARMACY_STATE = CASE WHEN ssdp.STATE IS NULL THEN p.State ELSE	ssdp.State END, --p.State,
				PHARMACY_ZIPCODE = CASE WHEN ssdp.zip IS NULL THEN p.ZipCode ELSE ssdp.Zip END, --ssdp.ZIP_CODE , --p.ZipCode,           
    --PHARMACY_EMAIL =          
                        PHARMACY_TE = dbo.ssf_SureScriptsFormatPhone(p.PhoneNumber) ,          
                        PHARMACY_FX = dbo.ssf_SureScriptsFormatPhone(p.FaxNumber)          
                FROM    @results AS r          
                        CROSS JOIN ClientMedicationScriptsPreview AS cms          
                        JOIN Pharmacies AS p ON p.PharmacyId = cms.PharmacyId 
						LEFT JOIN dbo.SureScriptsPharmacyUpdate AS ssdp ON ( ssdp.NCPDPID = p.SureScriptsPharmacyIdentifier )               
						WHERE   cms.ClientMedicationScriptId in( select item from [dbo].fnSplit(@ClientMedicationScriptIds,',')  )         
            END          
             
          
          
        IF @Preview != 'Y'           
            BEGIN          
   -- Prescriber Information          
                UPDATE  r      
                SET     PRESCRIBER_SPI = LTRIM(RTRIM(ISNULL(s.SureScriptsPrescriberId,          
                                                            '')))          
                        + LTRIM(RTRIM(ISNULL(s.SureScriptsLocationId, ''))) ,          
                        PRESCRIBER_CLINIC_NAME = SUBSTRING(ag.LocationName, 1,          
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
                        PRESCRIBER_TE = dbo.ssf_SureScriptsFormatPhone(ag.PhoneNumber) ,          
                        PRESCRIBER_FX = dbo.ssf_SureScriptsFormatPhone(ag.FaxNumber)          
                FROM    @results AS r          
                        CROSS JOIN ClientMedicationScripts AS cms          
                      --  CROSS JOIN Agency AS ag  
					    LEFT JOIN dbo.Locations AS ag ON ag.LocationId = cms.LocationId             
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
                        PRESCRIBER_CLINIC_NAME = SUBSTRING(ag.LocationName, 1,          
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
                        PRESCRIBER_EMAIL = NULL ,                              PRESCRIBER_TE = dbo.ssf_SureScriptsFormatPhone(ag.PhoneNumber) ,          
                        PRESCRIBER_FX = dbo.ssf_SureScriptsFormatPhone(ag.FaxNumber)          
                FROM    @results AS r          
                        CROSS JOIN ClientMedicationScriptsPreview AS cms          
                      --  CROSS JOIN Agency AS ag 
					    LEFT JOIN dbo.Locations AS ag ON ag.LocationId = cms.LocationId           
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
								PATIENT_TE = dbo.ssf_SureScriptsFormatPhone(cp.PhoneNumber),
                                PATIENT_CP = dbo.ssf_SureScriptsFormatPhone(cp2.PhoneNumber)      
                        FROM    @results AS r          
                                CROSS JOIN ClientMedicationScripts AS cms          
                  JOIN Clients AS c ON c.ClientId = cms.ClientId          
                                LEFT OUTER JOIN ClientAddresses AS ca ON ca.ClientId = c.ClientId          
                                                              AND ca.AddressType =@AddressType       
                                                              AND ISNULL(ca.RecordDeleted,          
                                                              'N') <> 'Y'          
                                LEFT OUTER JOIN ClientPhones AS cp ON cp.ClientId = c.ClientId          
                                                              AND cp.PhoneType =  @PhoneNumberType
                                                              AND ISNULL(cp.RecordDeleted,          
                                                              'N') <> 'Y'          
                                LEFT OUTER JOIN ClientPhones AS cp2 ON cp2.ClientId = c.ClientId          
                                                              AND cp2.PhoneType = @PhoneNumberType1          
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
								PATIENT_TE = dbo.ssf_SureScriptsFormatPhone(cp.PhoneNumber),
                                PATIENT_CP = dbo.ssf_SureScriptsFormatPhone(cp2.PhoneNumber)        
                        FROM    @results AS r          
                                CROSS JOIN ClientMedicationScriptsPreview AS cms          
                                JOIN Clients AS c ON c.ClientId = cms.ClientId          
                                LEFT OUTER JOIN ClientAddresses AS ca ON ca.ClientId = c.ClientId          
                                                              AND ca.AddressType = @AddressType       
                                                              AND ISNULL(ca.RecordDeleted,          
                                                              'N') <> 'Y'          
                                LEFT OUTER JOIN ClientPhones AS cp ON cp.ClientId = c.ClientId          
                                                              AND cp.PhoneType = @PhoneNumberType
                                                              AND ISNULL(cp.RecordDeleted,          
                                                              'N') <> 'Y'          
                                LEFT OUTER JOIN ClientPhones AS cp2 ON cp2.ClientId = c.ClientId          
                                                              AND cp2.PhoneType = @PhoneNumberType1          
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
                --24 Oct 2017			Vithobha	 
                CASE 
					WHEN ISNULL(@PharmacyId, '') <> ''
						THEN '<b>Pharmacy Information </b><br> ' +        
							'<b>' + ISNULL(STORENAME,'') + ' - NCPDP ID:  '+ ISNULL(NCPDPID,'') + '</b><br> ' +        
							ISNULL(PHARMACY_ADDRESS1,'') + ', '+ ISNULL(PHARMACY_ADDRESS2,'') + ' '  + ISNULL(PHARMACY_CITY,'') + ', ' + ISNULL(PHARMACY_STATE,'') + ' ' + ISNULL(PHARMACY_ZIPCODE,'') +'<br> ' +        
							'P: '+ ISNULL(dbo.csf_RDLSurescriptsFormatPhone(PHARMACY_TE),'') + ' &nbsp; F: ' + ISNULL(dbo.csf_RDLSurescriptsFormatPhone(PHARMACY_FX),'') + '<br> '
					ELSE ''
				END as PHARMACYDETIALS,
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
                CASE WHEN PATIENT_TE is not null THEN  (SELECT dbo.ssf_GetGlobalCodeNameById(@PhoneNumberType) + ': ' + dbo.csf_RDLSurescriptsFormatPhone(PATIENT_TE)) else '' END +
                ' &nbsp; ' +
                CASE WHEN PATIENT_CP is not null THEN  (SELECT dbo.ssf_GetGlobalCodeNameById(@PhoneNumberType1) + ': ' + dbo.csf_RDLSurescriptsFormatPhone(PATIENT_CP)) else '' END 
                as PATIENTDETAILS        
		FROM    @results AS r     
       
                     
        --COMMIT TRAN          
          
    END TRY          
    BEGIN CATCH          
     DECLARE @errMessage NVARCHAR(4000)          
        SET @errMessage = ERROR_MESSAGE()          
          
        RAISERROR(@errMessage, 16, 1)          
    END CATCH          
          








GO

