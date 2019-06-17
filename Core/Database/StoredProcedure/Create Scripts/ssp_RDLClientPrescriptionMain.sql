/****** Object:  StoredProcedure [dbo].[ssp_RDLClientPrescriptionMain]    Script Date: 11/26/2014 18:25:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLClientPrescriptionMain]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLClientPrescriptionMain]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLClientPrescriptionMain]    Script Date: 11/26/2014 18:25:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
  
CREATE PROCEDURE [dbo].[ssp_RDLClientPrescriptionMain]  
    @ClientMedicationScriptIds INT ,  
    @OrderingMethod CHAR(1) ,  
    @OriginalData INT ,  
    @LocationId INT ,  
    @PrintChartCopy CHAR(5) ,  
    @SessionId VARCHAR(24) ,  
    @RefillResponseType CHAR(1) = NULL  
	
  
/* ========================================================================================== 
  Procedure Name :[ssp_RDLClientPrescriptionMain]
  Purpose : Displays Medication Details for the Mode-Print RDL
  Modifications:
  *Name*      *Date*                   *Purpose*
 TER - 8/21/09 - Added city, state, zip to location address field.  
 avoss - replaced line 428 with new preview location address logic  
 avoss - 10-04-2009 - Added a check for C2 Meds  
 avoss - 10-16-2009 --add sysconfig offset days for duration on titrations  
 avoss - 10-16-2009 --added messages for c2 drugs  
 avoss - 10-28-2009  --changed titration logic for multiple titrations on a script  
 avoss - 11-12-2009 --spell out the quantities for meds using user-defined functions  
 ter - 11-13-2009 -- fix "do not fill" language and left join to StaffSignatureFacsimiles  
 avoss - 11-13-2009 --Ohio pharmacy board changes  
   srf/ter - 09-14-2010 -- print different strengths of c2 meds on different pages  
 ter - 12-27-2011 - change to work with ordering method proc under all conditions  
 kalpers - 8-10-2012 -- Added a filter for clientmedicationid for the pon  
 kalpers - 1-2-2013 -- Commented out where statement because logic was in the join and the where only allowed for one PON to update for PatientSummary  
 kalpers - 1-2-2013 -- Added a page sort to force the titration summary to be at the top of the list for each titration  
 kalpers - 3-7-2013 -- Added condition to only validate order method if the order method isn't a chart copy  
 kalpers - 3-7-2013 -- Added where condition on update to not update order method for chart copy  
 kalpers - 3-12-2013 -- Added logic to the routine that updates the mutliple lines script  
 kalpers - 4-9-2013 -- Extended PON to Days and Refills  
 kalpers - 10-6-2013 -- Updated the PON number for Titration to sum up the number of days as part of the PON number by Client Medication Id  
 kalpers - 10-25-2013 -- Changed the instructional summary to remove the text because of missing data  
 kalpers - 10-25-2013 -- Added RxReference and specific message for refill request for e-prescribed not going through SureScripts  
 kalpers - 10-28-2013 -- Added PotencyUnitCodeDescription as part of the group by for determining instructions  
 kalpers - 11-17-2013 -- remove the conversion of Pharmacy Dec 10,2 to Int  
 Munish  - 11-06-2014 -- Modified CSP as per Kalamazoo 3.5 Implementation task #132
 Munish  - 11-06-2014 -- Modified CSP as per Kalamazoo 3.5 Implementation task #132 commented Location Zip Code Duplication
 Steczynski - 3/25/2015 -- Steczynski Format Quantity to drop trailing zeros, applied dbo.ssf_RemoveTrailingZeros, Task 215 
 Malathi Shiva - 12/Aug/2015	- Core Bugs : Task# 1861, Seperated Comments from Special instructions
 Wasif Butt	- 22/Sep/2015	- added isnull check for potency so instruction doesn't get wiped when potency can't be mapped.
 Vithobha	- 19/Nov/2015	-Added isnull check for potency at final select so quantity doesn't get wiped when potency can't be mapped. A Renewed Mind - Support: #370 Rx: Quantity missing from Medications
 Anto - 16/Mar/2016	- Valley - Support Go Live: #329, Added asterisk with  pharmacy and quantity text.
 Anto - 28/Nov/2016	- Modified the logic to show the Prescriber details always on the RDL.  Camino - Support Go Live #304
 Nandita-30/March/2017 - Changed the custom tp core stored procedure
 Pranay -04-April-2017    Added condition  @Preview 
 Malathi Shiva - 28/July/2017	- Pines-Support : Task# 844, Added active check in ClientAllergies table - Merged Anto's changes done in core csp to this ssp
 Vithobha		- 1/Aug/2017 -  A Renewed Mind - Support: Task# 370 Added logic to show Quantity in words. - Merged changes done in custom csp to this ssp
 Vithobha		- 1/Aug/2017 -  Harbor - Support: #728 Added Logic for showing LicenseNumber for Suboxone. - Merged changes done in custom csp to this ssp
 Vithobha		- 1/Aug/2017 -  Summit Pointe - Support: #703 Made changes to show VerbalOrderReadBack.  - Merged changes done in custom csp to this ssp
 Anto		    - 1/Aug/2017 -  Modified the logic to display Chart copy on the RDL while faxing an order. KCMHSAS - Support #481
 Malathi Shiva  - 1/Aug/2017 -  Valley - Support Go Live: Task# 330 - If this recode category(XHighlandSpringsRxLogo) is present and it has an y locationId mapped then it will display HighLand Springs logo else Valley logo.
								If the category is not present then 
 Anto		    - 24/Aug/2017	- Merging changes of Wasif (Diagnosis fix) from valley environment to display ICD10Codeid in Print RDL.		
 Anto		    - 19/Sep/2017	- Casting ICD10CodeId into varchar which fails in some scenario. Newaygo - Support: #679		
 Bernardin      - 17/Oct/2017	- What: Added record deleted condition to avoid selecting NA DEA No in rdl. Why: Thresholds-Support#1063		
 Nandita	    - 8/Nov/2017	- Added logic to check if atleast one phone is present for a client and not just 'Home' type
 Pranay          -05/Dec/2017	-Added 'No substitutions' w.r.t MHP		Task#357.									
Pranay          -06/DEC/2017   -Added @AddressType w.r.t CEI-SupportGoLive Task#854
Pranay          -18/DEC/2017   -Added ca.AddressType OrderBy w.r.t CEI -support Task#854	
PranayB         -01/Jan/2018     Added @PhoneNumberType w.r.t KCMHSAS - Support Task	#928 - Rx.	
Vithobha		- 30/Jan/2018	- Corrected the issues with Phone number on Client Prescription, Offshore QA Bugs: #644	
Vithobha		- 05/Dec/2017	- Show/Hide Pharmacy Information based on PharmacyId, Thresholds - Support 1067								
 Vithobha		-19/Feb/2018	- Removed the conditions for checking Print/Fax, Becasue Pharmacy details were not showing on Chart copy. Texas Go Live Build Issues# 683
 PranayB         -08/jan/2018    -Added DxPurpose w.r.t harbor enhancement task#23	
19/Jan/2018    -addeed Case Statement for DxPurpose w.r.t Harbor Task#23		 
 Nandita		- 2/Feb/2018	- Added Pharmacy city,state and Zipcode for Pharmacy address  
 Anto		    -11/May/2018    - Modified the code to display the Cell number instead of a home number as a priority MFS - Support Go Live #373.1
 PranayB        -7/July/2018      Added Addtional drugs to NADEA list w.r.t EPCS 75
 Anto		    -24/Sep/2018    - Modified the code by calling a scsp to display 4 prescriptions on one page based on a system configuration key value.	Porter Starke-Customizations #52
 Vithobha		- 31/July/2017 -  KCMHSAS - Support #479 Added Supervisor signature - Merged changes done in custom csp to this ssp
=======================================================================================================================*/  
AS   

DECLARE @PSSSystemkeyvalue CHAR(10)    
SELECT @PSSSystemkeyvalue = Value FROM SystemConfigurationKeys where [key] = 'PRINTFOURPRESCRIPTIONSPERPAGE'    
If EXISTS (select 1 from sys.procedures where name = 'scsp_RDLClientPrescriptionMain') AND @PSSSystemkeyvalue = 'Yes'    
  BEGIN    
     EXEC scsp_RDLClientPrescriptionMain @ClientMedicationScriptIds,@OrderingMethod,@OriginalData,@LocationId,@PrintChartCopy,@SessionId,@RefillResponseType    
  END    
ELSE    
  BEGIN      


DECLARE @Preview CHAR(1)
DECLARE @MedicationNameId INT
DECLARE @NADEA VARCHAR(25)
DECLARE @VerbalOrderReadBack CHAR(1) 
DECLARE @AddressType INT 
DECLARE @PhoneNumberType INT
DECLARE @PharmacyId INT
DECLARE @DisplayFullPharmacyAddress VARCHAR(10)

SELECT @DisplayFullPharmacyAddress=Value FROM SystemConfigurationKeys WHERE [Key]='DisplayFullPharmacyAddress'
IF @OriginalData > 0 
            SET @Preview = 'N'
        ELSE 
            SET @Preview = 'Y'

IF @Preview !='Y' --Pranay
BEGIN
  SELECT @MedicationNameId=MedName.MedicationNameId,@PharmacyId = cms.PharmacyId FROM	ClientMedicationScripts AS cms
							JOIN ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationScriptId = CMS.ClientMedicationScriptId
															  AND ISNULL(cmsd.RecordDeleted,
															  'N') <> 'Y'
							JOIN ClientMedicationInstructions AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId
															  AND ISNULL(cmi.RecordDeleted,
															  'N') <> 'Y' AND ISNULL(cmi.Active,'Y')='Y'
							JOIN ClientMedications AS cm ON cm.ClientMedicationId = cmi.ClientMedicationId
															  AND ISNULL(cm.RecordDeleted,'N') <> 'Y'
							JOIN MDMedicationNames AS MedName ON MedName.MedicationNameId = cm.MedicationNameId
												AND ISNULL(MedName.RecordDeleted,
														   'N') <> 'Y'
							WHERE @ClientMedicationScriptIds = cms.ClientMedicationScriptId AND 
							ISNULL(cms.RecordDeleted, 'N') <> 'Y'

 SELECT @AddressType = ca.AddressType
                             FROM   ClientAddresses ca
                                    JOIN dbo.ClientMedicationScripts cp ON cp.ClientId = ca.ClientId
                             WHERE  ISNULL(ca.Address, '') != ''
                                    AND ISNULL(ca.City, '') != ''
                                    AND ISNULL(ca.State, '') != ''
                                    AND ISNULL(ca.Zip, '') != ''
                                    AND ISNULL(ca.RecordDeleted, 'N') != 'Y'
                                    AND cp.ClientMedicationScriptId = @ClientMedicationScriptIds
									ORDER BY CASE WHEN ca.AddressType = 90 THEN 1 --Home
                                    WHEN ca.AddressType = 92 THEN 2 --Temporary Residence
                                    WHEN ca.AddressType = 91 THEN 3 --Office
                                    WHEN ca.AddressType = 93 THEN 4-- other
                                    ELSE 5
                                    END ASC;
  SELECT  top 1 @PhoneNumberType = ca.PhoneType
    FROM    ClientPhones ca
            JOIN dbo.ClientMedicationScripts cp ON cp.ClientId = ca.ClientId
    WHERE   ISNULL(ca.PhoneNumber, '') != ''
            AND ISNULL(ca.RecordDeleted, 'N') = 'N'
            AND cp.ClientMedicationScriptId = @ClientMedicationScriptIds
    ORDER BY CASE WHEN ca.PhoneType = 34 THEN 1 --Mobile
                  WHEN ca.PhoneType = 35 THEN 2-- Mobile 2
                  WHEN ca.PhoneType = 30 THEN 3 --Home
                  WHEN ca.PhoneType = 32 THEN 4 --Home2
                  WHEN ca.PhoneType = 31 THEN 5-- Business
                  WHEN ca.PhoneType = 33 THEN 6-- Business 2
                  WHEN ca.PhoneType = 37 THEN 7 -- School
                  WHEN ca.PhoneType = 38 THEN 8 --Other
                  ELSE 9
             END ASC;									
END

ELSE
 BEGIN
  SELECT @MedicationNameId=MedName.MedicationNameId,@PharmacyId = cms.PharmacyId FROM	ClientMedicationScriptsPreview AS cms
							JOIN ClientMedicationScriptDrugsPreview AS cmsd ON cmsd.ClientMedicationScriptId = CMS.ClientMedicationScriptId
															  AND ISNULL(cmsd.RecordDeleted,
															  'N') <> 'Y'
							JOIN ClientMedicationInstructionsPreview AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId
															  AND ISNULL(cmi.RecordDeleted,
															  'N') <> 'Y' AND ISNULL(cmi.Active,'Y')='Y'
							JOIN ClientMedicationsPreview AS cm ON cm.ClientMedicationId = cmi.ClientMedicationId
															  AND ISNULL(cm.RecordDeleted,'N') <> 'Y'
							JOIN MDMedicationNames AS MedName ON MedName.MedicationNameId = cm.MedicationNameId
												AND ISNULL(MedName.RecordDeleted,
														   'N') <> 'Y'
							WHERE @ClientMedicationScriptIds = cms.ClientMedicationScriptId AND 
							ISNULL(cms.RecordDeleted, 'N') <> 'Y'
  
SELECT @AddressType = ca.AddressType
                             FROM   ClientAddresses ca
                                    JOIN ClientMedicationScriptsPreview cp ON cp.ClientId = ca.ClientId
                             WHERE  ISNULL(ca.Address, '') != ''
                                    AND ISNULL(ca.City, '') != ''
                                    AND ISNULL(ca.State, '') != ''
                                    AND ISNULL(ca.Zip, '') != ''
                                    AND ISNULL(ca.RecordDeleted, 'N') != 'Y'
                                    AND cp.ClientMedicationScriptId = @ClientMedicationScriptIds
									ORDER BY CASE WHEN ca.AddressType = 90 THEN 1 --Home
                                    WHEN ca.AddressType = 92 THEN 2 --Temporary Residence
                                    WHEN ca.AddressType = 91 THEN 3 --Office
                                    WHEN ca.AddressType = 93 THEN 4-- other
                                    ELSE 5
                                    END ASC;
SELECT  top 1 @PhoneNumberType = ca.PhoneType
FROM    ClientPhones ca
        JOIN dbo.ClientMedicationScriptsPreview cp ON cp.ClientId = ca.ClientId
WHERE   ISNULL(ca.PhoneNumber, '') != ''
        AND ISNULL(ca.RecordDeleted, 'N') = 'N'
        AND cp.ClientMedicationScriptId = @ClientMedicationScriptIds
ORDER BY CASE WHEN ca.PhoneType = 34 THEN 1 --Mobile
              WHEN ca.PhoneType = 35 THEN 2-- Mobile 2
              WHEN ca.PhoneType = 30 THEN 3 --Home
              WHEN ca.PhoneType = 32 THEN 4 --Home2              
              WHEN ca.PhoneType = 31 THEN 5-- Business
              WHEN ca.PhoneType = 33 THEN 6-- Business 2
              WHEN ca.PhoneType = 37 THEN 7 -- School
              WHEN ca.PhoneType = 38 THEN 8 --Other
              ELSE 9
         END ASC;									
END 



CREATE TABLE #tempMedicationName 
(MedicationNameId int not null primary key,      
MedicationName varchar(100))

INSERT INTO #tempMedicationName EXEC ssp_MMGetAlternativeMedicationNames @MedicationNameId


SET @NADEA = ''

IF @Preview != 'Y' -- Select  NADEA from  the orginaldata
BEGIN 

 IF EXISTS (SELECT #tempMedicationName.MedicationNameId FROM #tempMedicationName WHERE #tempMedicationName.MedicationName LIKE '%Xyrem%' OR #tempMedicationName.MedicationName LIKE '%Subutex%' OR #tempMedicationName.MedicationName like '%Gamma-Hydroxybutyric Acid%' OR 
 #tempMedicationName.MedicationName like  '%Suboxone%' OR #tempMedicationName.MedicationName like '%Zubsolv%' OR #tempMedicationName.MedicationName like '%Bunavail%'
        OR #tempMedicationName.MedicationName like '%Buprenorphine%'
		OR #tempMedicationName.MedicationName like '%Buprenex%'
		OR #tempMedicationName.MedicationName like '%Belbuca%'
		OR #tempMedicationName.MedicationName like '%Sublocade%'
		OR #tempMedicationName.MedicationName like '%Probuphine%'
		OR #tempMedicationName.MedicationName like '%Butrans%')
 BEGIN
   SELECT @NADEA=sldForNADEA.LicenseNumber FROM	ClientMedicationScripts AS cms
							
				JOIN Staff AS st ON st.StaffId = cms.OrderingPrescriberId
				AND ISNULL(st.RecordDeleted,'N') <> 'Y'
				JOIN StaffLicenseDegrees as sldForNADEA ON sldForNADEA.StaffId=st.StaffId AND sldForNADEA.LicenseTypeDegree =9404 AND sldForNADEA.PrimaryValue='Y' AND ISNULL(sldForNADEA.RecordDeleted, 'N') <> 'Y'
				WHERE 
			    @ClientMedicationScriptIds = cms.ClientMedicationScriptId AND 
			    ISNULL(cms.RecordDeleted, 'N') <> 'Y'
    END
  END 

ELSE	
  BEGIN
     IF EXISTS (SELECT #tempMedicationName.MedicationNameId FROM #tempMedicationName WHERE #tempMedicationName.MedicationName LIKE '%Xyrem%' OR #tempMedicationName.MedicationName LIKE '%Subutex%' OR #tempMedicationName.MedicationName like '%Gamma-Hydroxybutyric Acid%' OR 
      #tempMedicationName.MedicationName like  '%Suboxone%' OR #tempMedicationName.MedicationName like '%Zubsolv%' OR #tempMedicationName.MedicationName like '%Bunavail%'
	    OR #tempMedicationName.MedicationName like '%Buprenorphine%'
		OR #tempMedicationName.MedicationName like '%Buprenex%'
		OR #tempMedicationName.MedicationName like '%Belbuca%'
		OR #tempMedicationName.MedicationName like '%Sublocade%'
		OR #tempMedicationName.MedicationName like '%Probuphine%'
		OR #tempMedicationName.MedicationName like '%Butrans%')
     BEGIN
        SELECT @NADEA=sldForNADEA.LicenseNumber FROM	ClientMedicationScriptsPreview AS cms
							JOIN ClientMedicationScriptDrugsPreview AS cmsd ON cmsd.ClientMedicationScriptId = CMS.ClientMedicationScriptId
															  AND ISNULL(cmsd.RecordDeleted,
															  'N') <> 'Y'
							JOIN ClientMedicationInstructionsPreview AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId
															  AND ISNULL(cmi.RecordDeleted,
															  'N') <> 'Y' AND ISNULL(cmi.Active,'Y')='Y'
							JOIN ClientMedicationsPreview AS cm ON cm.ClientMedicationId = cmi.ClientMedicationId
															  AND ISNULL(cm.RecordDeleted,'N') <> 'Y'
							JOIN MDMedicationNames AS MedName ON MedName.MedicationNameId = cm.MedicationNameId
												AND ISNULL(MedName.RecordDeleted,
														   'N') <> 'Y'
							JOIN Staff AS st ON st.StaffId = cm.PrescriberId
												AND ISNULL(st.RecordDeleted,
														   'N') <> 'Y'
							JOIN StaffLicenseDegrees as sldForNADEA ON sldForNADEA.StaffId=st.StaffId
							WHERE 
							sldForNADEA.LicenseTypeDegree =9404 AND sldForNADEA.PrimaryValue='Y' AND ISNULL(sldForNADEA.RecordDeleted, 'N') <> 'Y' AND
							@ClientMedicationScriptIds = cms.ClientMedicationScriptId AND 
							ISNULL(cms.RecordDeleted, 'N') <> 'Y'
      END
	     
  
  END   


  							

    DECLARE @DrugsDEACodes TABLE  
        (  
          ClientMedicationScriptDrugId INT ,  
          DEACode CHAR(1)  
        )  
    DECLARE @cDrugsDEAScriptDrugId INT ,  
        @cDrugsDEAMedicationId INT ,  
        @cDrugsDEACode CHAR(1)  
  
    DECLARE @DrDegree TABLE ( Degree INT )  
    INSERT  INTO @DrDegree  
-- need a safer way to make this generic  
            SELECT  globalCodeId  
            FROM    globalCodes  
            WHERE   category = 'DEGREE'  
                    AND externalcode1 IN ( 'MD', 'DO', 'PHD', 'PSYD' )  
  
    DECLARE @PON VARCHAR(50)  
    DECLARE @StartDate DATETIME  
    SET @StartDate = '04/9/2008'  
  
    IF @OrderingMethod <> 'X'   
        BEGIN  
            EXEC [csp_SCValidateOderingMethod] @ClientMedicationScriptId = @ClientMedicationScriptIds,  
                @OriginalData = @OriginalData,  
                @ModifiedOrderingMedthod = @OrderingMethod OUTPUT  
        END  
  
    IF @PrintChartCopy IN ( 'True', 'False' )   
        BEGIN  
            SET @PrintChartCopy = 'Y'  
        END  
  
--check for c2 meds for signature options  
    DECLARE @C2Meds VARCHAR(1) --Y,N  
    SET @C2Meds = 'N'  
  
    DECLARE @ClientMedications TABLE  
        (  
          ClientMedicationId INT ,  
          TitrationType CHAR(1)  
        )  
  
    IF @OriginalData > 0   
        BEGIN  
            INSERT  INTO @ClientMedications  
                    ( ClientMedicationId ,  
                      TitrationType  
                    )  
                    SELECT  b.ClientMedicationId ,  
         CASE WHEN b.TitrationType IS NOT NULL  
                                      AND b.CountStartDates > 1  
                                 THEN b.TitrationType  
                                 ELSE NULL  
                            END  
                    FROM    ClientMedicationScripts AS cms  
                            JOIN ( SELECT   cm2.ClientMedicationId ,  
                                            cm2.TitrationType ,  
                                            cms2.ClientMedicationScriptId ,  
                                            COUNT(DISTINCT cmsd2.StartDate) AS CountStartDates  
                                   FROM     ClientMedicationScripts AS cms2  
                                            JOIN ClientMedicationScriptDrugs  
                                            AS cmsd2 ON cmsd2.ClientMedicationScriptId = cms2.ClientMedicationScriptId  
                                            JOIN ClientMedicationInstructions  
                                            AS cmi2 ON cmi2.ClientMedicationInstructionId = cmsd2.ClientMedicationInstructionId  AND ISNULL(cmi2.Active,'Y')='Y'
                                            JOIN ClientMedications AS cm2 ON cm2.ClientMedicationId = cmi2.ClientMedicationId  
                                   GROUP BY cm2.ClientMedicationId ,  
                                            cms2.ClientMedicationScriptId ,  
                                            cm2.TitrationType  
                                 ) AS b ON b.ClientMedicationScriptId = cms.ClientMedicationScriptId  
                    WHERE   cms.ClientMedicationScriptId = @ClientMedicationScriptIds  
  
        END  
    ELSE   
        BEGIN  
            INSERT  INTO @ClientMedications  
                    ( ClientMedicationId ,  
                      TitrationType  
                    )  
                    SELECT  b.ClientMedicationId ,  
                            CASE WHEN b.TitrationType IS NOT NULL  
                                      AND b.CountStartDates > 1  
                                 THEN b.TitrationType  
                                 ELSE NULL  
                            END  
                    FROM    ClientMedicationScriptsPreview AS cms  
                            JOIN ( SELECT   cm2.ClientMedicationId ,  
                                            cm2.TitrationType ,  
                                            cms2.ClientMedicationScriptId ,  
                                            COUNT(DISTINCT cmsd2.StartDate) AS CountStartDates  
                                   FROM     ClientMedicationScriptsPreview AS cms2  
                                            JOIN ClientMedicationScriptDrugsPreview  
                                            AS cmsd2 ON cmsd2.ClientMedicationScriptId = cms2.ClientMedicationScriptId  
                                            JOIN ClientMedicationInstructionsPreview  
                                            AS cmi2 ON cmi2.ClientMedicationInstructionId = cmsd2.ClientMedicationInstructionId  AND ISNULL(cmi2.Active,'Y')='Y'
                                            JOIN ClientMedicationsPreview AS cm2 ON cm2.ClientMedicationId = cmi2.ClientMedicationId  
                                   GROUP BY cm2.ClientMedicationId ,  
                                            cms2.ClientMedicationScriptId ,  
                                            cm2.TitrationType  
                                 ) AS b ON b.ClientMedicationScriptId = cms.ClientMedicationScriptId  
                    WHERE   cms.ClientMedicationScriptId = @ClientMedicationScriptIds  
  
        END  
  
  
  
    DECLARE @FaxFlag CHAR(1) ,  
        @ShowCoverLetter CHAR(1)  --Check to display  
        ,  
        @PharmacyCoverLetters INT  
  
    SELECT  @PharmacyCoverLetters = ISNULL(PharmacyCoverLetters, 0)  
    FROM    systemConfigurations  
  
    SELECT  @FaxFlag = CASE WHEN @OrderingMethod = 'F' THEN 'Y'  
                            ELSE 'N'  
                       END  
  
    DECLARE @OhioBoardCertDate DATETIME  
    SELECT  @OhioBoardCertDate = '11/12/2009'  
     --Vithobha Added Logic for showing LicenseNumber for Suboxone 
    DECLARE @SubOxoneMedicationNameId int 
    DECLARE @SystemConfigurationKeys int
    DECLARE @LicenseNumber varchar(25)
    DECLARE @ClientMedicationsSubOxone int
    DECLARE @PrescriberId int
    DECLARE @GlobalcodeSubOxone int 
    SELECT @GlobalcodeSubOxone = GlobalCodeId FROM GlobalCodes WHERE Category='DEGREE' AND CodeName like '%SubOxone%'
    SELECT @SubOxoneMedicationNameId = MedicationNameId from MDMedicationNames where MedicationName ='SubOxone'
    SELECT @ClientMedicationsSubOxone = CM.ClientMedicationId , @PrescriberId = CM.PrescriberId from @ClientMedications Temp 
    Join ClientMedications CM on Temp.ClientMedicationId = CM.ClientMedicationId
    where MedicationNameId = @SubOxoneMedicationNameId 
	SELECT @SystemConfigurationKeys = COUNT(*) from SystemConfigurationKeys SC where 
	cast(SC.Value as int)=@GlobalcodeSubOxone and	[Key]='SubOxoneLicense'
	
	if( @ClientMedicationsSubOxone is not null and  @SystemConfigurationKeys > 0)
	begin
			select top 1 @LicenseNumber=  LicenseNumber from StaffLicenseDegrees
			 where StaffId = @PrescriberId and LicenseTypeDegree=@GlobalcodeSubOxone
			 and (StartDate is null or getdate()>= StartDate) and (getdate()<=EndDate or EndDate is null)
			 order by ModifiedDate
	end
  
    CREATE TABLE #ClientScriptInstructions  
        (  
          ClientMedicationScriptId INT ,  
          OrderingMethod VARCHAR(5) ,  
          CopyType VARCHAR(20) ,  
          ScriptOrderedDate DATETIME ,  
          PON VARCHAR(50) ,  
          ClientMedicationInstructionId INT ,  
          MedicationName VARCHAR(MAX) ,  
          DrugPurpose varchar(max),
          StrengthId INT ,  
          InstructionStrengthDescription VARCHAR(MAX) ,  
          TitrationStrengthDescription VARCHAR(MAX) ,  
          InstructionSummary VARCHAR(MAX) ,  
          PatientScheduleSummary VARCHAR(MAX) ,  
          DisbursedAmount dec(10, 2) ,  
          UnitScheduleString VARCHAR(MAX) ,  
          UnitValue VARCHAR(MAX) ,  
          UnitValueString VARCHAR(2) ,  
          ScheduleValue VARCHAR(MAX) ,  
          TitrationStepNumber INT ,  
          MedicationStartDate DATETIME ,  
          MedicationEndDate DATETIME ,  
          OrderDate DATETIME ,  
          Quantity DECIMAL(10, 2) ,  
          SchedValueMultiplier DECIMAL(10, 2) ,  
          TotalQuantity VARCHAR(MAX) ,  
          DrugStartDate DATETIME ,  
          DrugEndDate DATETIME ,  
          Refills DECIMAL(10, 2) ,  
          DurationDays INT ,  
          Pharmacy DECIMAL(10, 2) ,  
          Sample DECIMAL(10, 2) ,  
          Stock DECIMAL(10, 2) ,  
          DAW VARCHAR(MAX) ,  
          SpecialInstructions VARCHAR(MAX) ,  
          OrderStatus VARCHAR(MAX) ,  
          OffLabel CHAR(1) ,  
          Comments VARCHAR(MAX) ,  
          IncludeCommentOnPrescription CHAR(1) ,  
          PharmacyText VARCHAR(MAX) ,  
           PotencyUnitCodeDescription VARCHAR(35),
		  DxPurpose VARCHAR(max)   
        )  
  
    CREATE TABLE #ClientScriptInstructionResults  
        (  
          ClientMedicationScriptId INT ,  
          OrderingMethod VARCHAR(5) ,  
          CopyType VARCHAR(20) ,  
          ScriptOrderedDate DATETIME ,  
          PON VARCHAR(50) ,  
          InsrtuctionMultipleStrengthGroupId INT ,  
          ClientMedicationInstructionId INT ,  
          MedicationName VARCHAR(MAX) , 
          DrugPurpose varchar(max), 
          InstructionSummary VARCHAR(MAX) ,  
          PatientScheduleSummary VARCHAR(MAX) ,  
          OrderDate DATETIME ,  
          DrugStartDate DATETIME ,  
          DrugEndDate DATETIME ,  
          Refills DECIMAL(10, 2) ,  
          DurationDays INT ,  
          DAW VARCHAR(MAX) ,  
          SpecialInstructions VARCHAR(MAX) ,  
          Comments VARCHAR(MAX),
          OrderStatus VARCHAR(30) ,  
          Titration CHAR(1) ,  
          Multiples CHAR(1) ,  
          SingleLine CHAR(1) ,  
          PharmacyText VARCHAR(MAX) ,  
          PageNumber INT ,  
          PageSort INT ,  
          PotencyUnitCodeDescription VARCHAR(35),
		  DxPurpose VARCHAR(max)     
        )  
  
    CREATE TABLE #QuantitySummary  
        (  
          InsrtuctionMultipleStrengthGroupId INT ,  
          ClientMedicationInstructionId INT ,  
          PON VARCHAR(50) ,  
          StrengthId INT ,  
          TitrationStepNumber INT ,  
          DurationDays INT ,  
          Quantity DECIMAL(10, 2) ,  
          Pharmacy DECIMAL(10, 2) ,  
          TotalQuantity DECIMAL(10, 2) ,  
          Sample DECIMAL(10, 2) ,  
          Stock DECIMAL(10, 2) ,  
          DisbursedAmount DECIMAL(10, 2) ,  
          DisbursedTotal DECIMAL(10, 2) ,  
          DisbursedFlag CHAR(1) ,  
          PharmacyTotal DECIMAL(10, 2) ,  
          GroupTotal DECIMAL(10, 2) ,  
          DrugStartDate DATETIME ,  
          DrugEndDate DATETIME ,  
          Refills DECIMAL(10, 2) ,  
          Titration CHAR(1) ,  
          Multiples CHAR(1) ,  
          SingleLine CHAR(1) ,  
          PotencyUnitCodeDescription VARCHAR(35)  
        )  
  
    CREATE TABLE #ScriptHeader  
        (  
          OrganizationName VARCHAR(500) ,  
          ClientMedicationScriptId INT ,  
          OrderingMethod CHAR(1) ,  
          AllergyList VARCHAR(1000) ,  
          ClientId INT ,  
          ClientName VARCHAR(300) ,  
          ClientAddress VARCHAR(500) ,  
          ClientHomePhone VARCHAR(200) ,  
          ClientDOB DATETIME ,  
          LocationAddress VARCHAR(500) ,  
          LocationName VARCHAR(200) ,  
          LocationPhone VARCHAR(200) ,  
          LocationFax VARCHAR(200) ,  
          PharmacyName VARCHAR(700) ,  
          PharmacyAddress VARCHAR(500) ,  
          PharmacyPhone VARCHAR(200) ,  
          PharmacyFax VARCHAR(200) ,  
          RxReferenceNumber VARCHAR(35) ,  
          SureScriptsRefillRequestId INT  
        )  
  
    CREATE TABLE #ScriptSignatures  
        (  
          ClientMedicationScriptId INT ,  
          OrderingMethod CHAR(1) ,  
          PrescriberId INT ,  
          Prescriber VARCHAR(500) , 
		  Supervisor VARCHAR(500) ,		  
          Creator VARCHAR(500) ,  
          CreatedBy VARCHAR(30) ,  
          SignatureFacsimile IMAGE ,  
          PrintDrugInformation CHAR(1)  
        )  
  
  
    DECLARE @TitrationPONs TABLE  
        (  
          PON VARCHAR(50) ,  
          Titration CHAR(1)  
        )  
    DECLARE @StrengthGroupInstructionIds TABLE  
        (  
          StrengthId INT ,  
          ClientMedicationInstructionId INT  
        )  
    DECLARE @TitrationInstructions TABLE  
        (  
          PON VARCHAR(50) ,  
          TitrationInstruction VARCHAR(MAX) ,  
          TitrationStartDate DATETIME ,  
          TitrationEndDate DATETIME ,  
          DurationDays INT  
        )  
    DECLARE @TitrationDays TABLE  
        (  
          PON VARCHAR(50) ,  
          TitrationStepNumber INT ,  
          DrugStartDate DATETIME ,  
          DrugEndDate DATETIME ,  
          DurationDays INT ,  
          DayNumber INT  
        )  
  
    DECLARE @TitrationRecords CHAR(1) ,  
        @MultInstRecords CHAR(1)  
  
    DECLARE @MultPON VARCHAR(50) ,  
        @MultInsrtuctionMultipleStrengthGroupId INT ,  
        @MultClientMedicationInstructionId INT ,  
        @MultPharmInstructionString VARCHAR(MAX) ,  
        @MultPatientInstructionSummaryString VARCHAR(MAX)  
  
    DECLARE @TitrationId INT ,  
        @MaxTitrationId INT ,  
        @TitrationInstructionString VARCHAR(MAX) ,  
        @StepId INT ,  
        @MaxStepId INT ,  
        @StepNumber INT ,  
        @StepInstructionString VARCHAR(MAX) ,  
        @TIPon VARCHAR(50) ,  
        @TIString VARCHAR(MAX)  
  
    DECLARE @Titrations TABLE  
        (  
          TitrationId INT IDENTITY ,  
          PON VARCHAR(50) ,  
          TitrationString VARCHAR(MAX)  
        )  
  
    DECLARE @TitrationSteps TABLE  
        (  
          StepId INT IDENTITY ,  
          PON VARCHAR(50) ,  
          StepNumber INT ,  
          StepString VARCHAR(MAX)  
        )  
  
    DECLARE @TitrationSummary TABLE  
        (  
          PON VARCHAR(50) ,  
          InsrtuctionMultipleStrengthGroupId INT ,  
          StrengthId INT ,  
          InstructionSummary VARCHAR(MAX)  
        )  
  
--Multiple Lines - Titrations Cursor for Finding quantities and grouping  
    DECLARE @PONCur1 VARCHAR(50) ,  
        @StrengthIdCur1 INT ,  
        @PotencyUnitCodeDescriptionCur1 VARCHAR(35) ,  
        @TitrationCur1 CHAR(1) ,  
        @MultiplesCur1 CHAR(1) ,  
        @SingleLineCur1 CHAR(1) ,  
        @IdxCur1 INT  
  
--Allergy Loop  
    DECLARE @AllergyList VARCHAR(1000) ,  
        @AllergyId INT ,  
        @MaxAllergyId INT  
    DECLARE @AllergyListTable TABLE  
        (  
          AllergyId INT IDENTITY ,  
          ConceptDescription VARCHAR(200)  
        )  
  
--C2 Meds check  
    DECLARE @C2MedsList TABLE ( PON VARCHAR(50) )  
--Controlled substances check  
    DECLARE @ControlledMedsList TABLE ( PON VARCHAR(50) )  
  
    SELECT  @StartDate = '04/9/2008' ,  
            @AllergyId = 1  
  
    IF ( @OriginalData > 0 )   
        BEGIN  
        select @VerbalOrderReadBack=VerbalOrderReadBack from ClientMedicationScripts  
			where ClientMedicationScriptId=  @ClientMedicationScriptIds
-- Get Client Alergy List  
            INSERT  INTO @AllergyListTable  
                    ( ConceptDescription  
                    )  
                    SELECT  ISNULL(ConceptDescription,  
                                   'No Known Medication/Other Allergies')  
                    FROM    ClientMedicationScripts AS cms  
                            JOIN Clients AS c ON c.ClientId = cms.ClientId  
                                                 AND ISNULL(c.RecordDeleted,  
                                                    'N') <> 'Y'  
                            LEFT JOIN ClientAllergies AS cla ON cla.ClientId = c.ClientId  
                                                              AND ISNULL(cla.RecordDeleted,  
                                                              'N') <> 'Y'  
                            LEFT JOIN MDAllergenConcepts AS MDAl ON MDAl.AllergenConceptId = cla.AllergenConceptId  
                    WHERE   ISNULL(cms.RecordDeleted, 'N') <> 'Y'  
                            AND @ClientMedicationScriptIds = cms.ClientMedicationScriptId  
                            AND ISNULL(cla.AllergyType, 'A') IN ( 'A' )--'I' intolerance 
                            AND ISNULL( cla.Active, 'N') = 'Y'  
                    ORDER BY ISNULL(ConceptDescription,  
                                    'No Known Medication/Other Allergies')  
  
    --Find Max Allergy in temp table for while loop  
            SET @MaxAllergyId = ( SELECT    MAX(AllergyId)  
                                  FROM      @AllergyListTable  
                                )  
  
    --Begin Loop to create Allergy List  
            WHILE @AllergyId <= @MaxAllergyId   
                BEGIN  
                    SET @AllergyList = ISNULL(@AllergyList, '')  
                        + CASE WHEN @AllergyId <> 1 THEN ', '  
                               ELSE ''  
                          END + ( SELECT    ISNULL(ConceptDescription, '')  
                                  FROM      @AllergyListTable t  
                                  WHERE     t.AllergyId = @AllergyId  
                                )  
                    SET @AllergyId = @AllergyId + 1  
                END  
    --End Loop  
   
 --get Client Info  
            INSERT  INTO #ScriptHeader  
                    ( OrganizationName ,  
                      ClientMedicationScriptId ,  
                      OrderingMethod ,  
                      AllergyList ,  
                      ClientId ,  
                      ClientName ,  
                      ClientAddress ,  
                      ClientHomePhone ,  
                      ClientDOB ,  
                      LocationAddress ,  
                      LocationName ,  
                      LocationPhone ,  
                      LocationFax ,  
                      PharmacyName ,  
                      PharmacyAddress ,  
                      PharmacyPhone ,  
                      PharmacyFax ,  
                      RxReferenceNumber ,  
                      SureScriptsRefillRequestId  
                    )  
                    SELECT  ( SELECT    OrganizationName  
                              FROM      SystemConfigurations  
                            ) AS OrganizationName ,  
                            cms.ClientMedicationScriptId ,  
                            @OrderingMethod AS OrderingMethod ,  
                            @AllergyList AS AllergyList ,  
                            c.ClientId ,  
                            c.LastName + ', ' + c.FirstName AS ClientName ,  
                            ISNULL(ca.Display, '') AS ClientAddress ,  
                            ISNULL(cph.PhoneNumber, '             ') AS ClientHomePhone ,  
                            c.DOB AS ClientDOB ,  
                            ISNULL(l.AddressDisplay, '') + CHAR(10) AS LocationAddress,  
                            --+ ISNULL(l.City, '') + ', ' + ISNULL(l.State, '')  
                            --+ ' ' + ISNULL(l.ZipCode, '') AS LocationAddress 
                            ISNULL(l.LocationName, '') AS LocationName ,  
                            CASE WHEN ISNULL(l.PhoneNumber, '             ') = ''  
                                 THEN '             '  
                                 ELSE ISNULL(l.PhoneNumber, '           ')  
                                      + ' '  
                            END AS LocationPhone ,  
                            CASE WHEN ISNULL(l.FaxNumber, '             ') = ''  
                                 THEN '             '  
                                 ELSE ISNULL(l.FaxNumber, '         ')  
                                      + ' '  
                            END AS LocationFax ,  
                            ISNULL(p.PharmacyName, '') AS PharmacyName ,  
                            CASE WHEN ISNULL(@DisplayFullPharmacyAddress,'N') = 'N'  
                                 THEN ISNULL(p.AddressDisplay , '')   
                                 ELSE ISNULL(p.AddressDisplay + ', '+p.City+', '+p.State+', '+ p.ZipCode, '')  
                            END AS PharmacyAddress ,  
                            CASE WHEN ISNULL(p.PhoneNumber, '             ') = ''  
                                 THEN '             '  
                                 ELSE ISNULL(p.PhoneNumber, '             ')  
                                      + ' '  
                            END AS PharmacyPhone ,  
                            CASE WHEN ISNULL(p.FaxNumber, '             ') = ''  
                                 THEN '             '  
                                 ELSE ISNULL(p.FaxNumber, '             ')  
                                      + ' '  
                            END AS PharmacyFax ,  
                            CASE WHEN ISNULL(ssrr.StatusOfRequest, ' ') = 'N'  
                                      AND ISNULL(ssrd.DeniedMessageId, '') <> ''  
                                 THEN ssrr.RxReferenceNumber  
                                 ELSE ''  
                            END ,  
                            ISNULL(cms.SureScriptsRefillRequestId, -1)  
                    FROM    ClientMedicationScripts AS cms  
                            JOIN Clients AS c ON c.ClientId = cms.ClientId  
                                                 AND ISNULL(c.RecordDeleted,  
                                                            'N') <> 'Y'  
                            LEFT JOIN ClientAddresses AS ca ON ca.ClientId = c.ClientId  
                                                              AND ca.AddressType IN (90,91,92,93)
                                                              AND ISNULL(ca.RecordDeleted,  
                                                              'N') <> 'Y'  
                            LEFT JOIN ClientPhones AS cph ON cph.ClientId = c.ClientId  
                                                            AND cph.PhoneType = @PhoneNumberType
                                                             AND ISNULL(cph.RecordDeleted,  
                                                              'N') <> 'Y'  
                            JOIN Locations AS l ON l.LocationId = cms.LocationId  
                                                   AND ISNULL(l.RecordDeleted,  
                                                              'N') <> 'Y'  
                            LEFT JOIN Pharmacies AS p ON p.PharmacyId = cms.PharmacyId  
                                                         --AND (@OrderingMethod = 'F'  or @OrderingMethod = 'P' )
                            LEFT JOIN dbo.SureScriptsRefillRequests ssrr ON ( cms.SureScriptsRefillRequestId = ssrr.SureScriptsRefillRequestId )  
                            LEFT JOIN dbo.SurescriptsRefillDenials ssrd ON ( ssrr.SureScriptsRefillRequestId = ssrd.SurescriptsRefillRequestId )  
                    WHERE   ISNULL(cms.RecordDeleted, 'N') <> 'Y'  
                            AND @ClientMedicationScriptIds = cms.ClientMedicationScriptId  
  
 --Set Show Cover Letter Flag for Script  
            SELECT  @ShowCoverLetter = CASE WHEN @FaxFlag = 'Y'  
                                                 AND ISNULL(p.NumberOfTimesFaxed,  
                                                            0) < @PharmacyCoverLetters  
                                            THEN 'Y'  
                                            ELSE 'N'  
                                       END  
            FROM    ClientMedicationScripts AS cms  
                    JOIN Pharmacies AS p ON p.PharmacyId = cms.PharmacyId  
  
   -- get the deacodes for all ClientMedicationScriptDrugs  
            DECLARE cDrugsDEA CURSOR fast_forward  
            FOR  
                SELECT DISTINCT  
                        cmsd.ClientMedicationScriptDrugId ,  
                        cmi.StrengthId  
                FROM    ClientMedicationScriptDrugs AS cmsd  
                        JOIN ClientMedicationInstructions AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId  
                WHERE   cmsd.ClientMedicationScriptId = @ClientMedicationScriptIds  
                        AND ISNULL(cmsd.RecordDeleted, 'N') <> 'Y'  
                        AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'  AND ISNULL(cmi.Active,'Y')='Y'
  
            OPEN cDrugsDEA  
  
            FETCH cDrugsDEA INTO @cDrugsDEAScriptDrugId,  
                @cDrugsDEAMedicationId  
  
            WHILE @@fetch_status = 0   
                BEGIN  
                    EXEC [csp_SCClientMedicationC2C5Drugs] @cDrugsDEAMedicationId,  
                        @cDrugsDEACode OUTPUT  
  
                    INSERT  INTO @DrugsDEACodes  
                            ( ClientMedicationScriptDrugId ,  
                              DEACode  
                            )  
                    VALUES  ( @cDrugsDEAScriptDrugId ,  
                              @cDrugsDEACode  
                            )  
  
                    FETCH cDrugsDEA INTO @cDrugsDEAScriptDrugId,  
                        @cDrugsDEAMedicationId  
                END  
  
            CLOSE cDrugsDEA  
  
            DEALLOCATE cDrugsDEA  
  
 --Get Signature Info  
            INSERT  INTO #ScriptSignatures  
                    SELECT DISTINCT  
                            cms.ClientMedicationScriptId ,  
                            @OrderingMethod AS OrderingMethod ,  
                            cm.PrescriberId ,  
                            CASE WHEN ISNULL(st.SigningSuffix, '') = ''  
                                 THEN st.FirstName + ' ' + st.Lastname + ', '  
                                      + stDeg.CodeName  
                                 ELSE st.FirstName + ' ' + st.Lastname + ', '  
                                      + st.SigningSuffix  
                            END  
                           +  ' DEA #: ' + ISNULL(sld.LicenseNumber, '') + ', ' + 'NA DEA #: ' + @NADEA + ', ' + 'LIC #: '  + ISNULL(st.LicenseNumber, '')  AS Prescriber ,
                            'Supervising Physician: ' + CASE 
							WHEN ISNULL(sSupervisor.SigningSuffix, '') = ''
								THEN sSupervisor.FirstName + ' ' + sSupervisor.Lastname + ', ' + ISNULL(suDeg.CodeName,'') 
							ELSE sSupervisor.FirstName + ' ' + sSupervisor.Lastname + ', ' + sSupervisor.SigningSuffix
							END + CASE 
							WHEN sSupervisor.Degree IN (
									SELECT Degree
									FROM @DrDegree
									)
								THEN '     DEA #: ' + ISNULL(sSupervisor.DEANumber, '')
							ELSE CASE 
									WHEN EXISTS (
											SELECT *
											FROM @DrugsDEACodes
											WHERE DEACode IN (
													2
													,3
													,4
													,5
													)
											)
										THEN '     DEA #: ' + ISNULL(sSupervisor.DEANumber, '') + ', ' + 'CTP #: ' + ISNULL(sSupervisor.LicenseNumber, '')
									ELSE '     CTP #: ' + ISNULL(sSupervisor.LicenseNumber, '')
									END
							END AS Supervisor
                            ,CASE WHEN ( @OrderingMethod = 'F' )   
                                      AND ( st.StaffId <> v.StaffId )  
                                 THEN 'Prescribing Agent: '  
                                      + CASE WHEN ISNULL(v.SigningSuffix, '') = ''  
                                             THEN v.FirstName + ' '  
                                                  + v.Lastname + ', '  
                                                  + vDeg.CodeName  
                                             ELSE v.FirstName + ' '  
                                                  + v.Lastname + ', '  
                                                  + v.SigningSuffix  
        END  
                                 ELSE ''  
                            END AS Creator ,  
                            cms.CreatedBy ,  
                            sf.SignatureFacsimile ,  
                            cms.PrintDrugInformation  
                    FROM    ClientMedicationScripts AS cms  
                            JOIN ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationScriptId = CMS.ClientMedicationScriptId  
                                                              AND ISNULL(cmsd.RecordDeleted,  
                                                              'N') <> 'Y'  
                            JOIN ClientMedicationInstructions AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId  
                                                              AND ISNULL(cmi.RecordDeleted,  
                                                              'N') <> 'Y'  AND ISNULL(cmi.Active,'Y')='Y'
                            JOIN ClientMedications AS cm ON cm.ClientMedicationId = cmi.ClientMedicationId  
                                                            AND ISNULL(cm.RecordDeleted,  
                                                              'N') <> 'Y'  
                            JOIN Staff AS v ON v.UserCode = cms.CreatedBy  
                                               AND ISNULL(v.RecordDeleted, 'N') <> 'Y'  
							JOIN Staff AS s ON s.StaffId = cms.OrderingPrescriberId          
					        LEFT JOIN StaffLicenseDegrees as sld ON sld.StaffLicenseDegreeId=cms.StaffLicenseDegreeId  
                            LEFT JOIN globalCodes AS vDeg ON vDeg.GlobalCodeId = v.Degree  
                            JOIN Staff AS st ON st.StaffId = cm.PrescriberId  
                                                AND ISNULL(st.RecordDeleted,  
                                                           'N') <> 'Y'  
							JOIN MDMedicationNames AS MedName ON MedName.MedicationNameId = cm.MedicationNameId
												AND ISNULL(MedName.RecordDeleted,
														   'N') <> 'Y'
                            LEFT JOIN globalCodes AS stDeg ON stDeg.GlobalCodeId = st.Degree  
                            LEFT JOIN StaffSignatureFacsimiles AS sf ON sf.StaffId = cm.PrescriberId  
                                                              AND ISNULL(sf.RecordDeleted,  
                                                              'N') <> 'Y'  
                                                              AND @OrderingMethod = 'F'
							LEFT JOIN Staff AS sSupervisor ON sSupervisor.StaffId = v.RxAuthorizedProvider
							LEFT JOIN globalCodes AS suDeg ON suDeg.GlobalCodeId = sSupervisor.Degree												
															  
                    WHERE   ISNULL(cms.RecordDeleted, 'N') <> 'Y'  
                            AND @ClientMedicationScriptIds = cms.ClientMedicationScriptId  
  
 /*main*/  
            INSERT  INTO #ClientScriptInstructions  
                    SELECT  cms.ClientMedicationScriptId ,  
                            @OrderingMethod AS OrderingMethod ,  
                            CASE WHEN @OrderingMethod <> 'C'  
                                 THEN 'Prescription'  
                                 ELSE 'Chart'  
                            END AS CopyType ,  
                            cms.OrderDate AS ScriptOrderedDate ,  
                            CAST(cms.ClientMedicationScriptId AS VARCHAR)  
                            + '-'  
                            + CAST(CASE WHEN cmTemp.TitrationType IS NULL  
                                        THEN cmi.StrengthId  
                                        ELSE ( SELECT   MIN(cmi2.StrengthId)  
                                               FROM     ClientMedicationScriptDrugs  
                                                        AS cmsd2  
                                                        JOIN ClientMedicationInstructions cmi2 ON cmi2.ClientMedicationInstructionId = cmsd2.ClientMedicationInstructionId  
                                               WHERE    cmsd2.ClientMedicationScriptId = cmsd.ClientMedicationScriptId  
                                                        AND cmi2.ClientMedicationId = cm.ClientMedicationId  
                                                        AND ISNULL(cmsd2.RecordDeleted,  
                                                              'N') <> 'Y'  
                                                        AND ISNULL(cmi2.RecordDeleted,  
                                                              'N') <> 'Y'  AND ISNULL(cmi2.Active,'Y')='Y'
       )  
                                   END AS VARCHAR) + '-'  
                            + CAST(CASE WHEN cmTemp.TitrationType IS NULL  
                                        THEN cmsd.DAYS  
                                        ELSE ( SELECT   SUM(b.days)  
                                               FROM     dbo.ClientMedicationInstructions a  
                                                        JOIN dbo.ClientMedicationScriptDrugs b ON ( a.ClientMedicationInstructionId = b.ClientMedicationInstructionId )  
                                               WHERE    ISNULL(a.RecordDeleted,  
                                                              'N') <> 'Y'  AND ISNULL(a.Active,'Y')='Y'
                                                        AND ISNULL(b.RecordDeleted,  
                                                              'N') <> 'Y'  
                                                        AND a.ClientMedicationId = cm.ClientMedicationId  
                                             )  
                                   END AS VARCHAR(10)) + '-'  
                            + CAST(REPLACE(cmsd.Refills, '.00', '') AS VARCHAR(10)) AS PON ,  
                            cmi.ClientMedicationInstructionId ,  
                            CASE WHEN cmTemp.TitrationType IS NULL  
                                 THEN MDMeds.MedicationDescription  
                                      + CASE WHEN mdrt.RouteAbbreviation IS NULL  
                                             THEN ''  
                                             ELSE ', '  
                                                  + mdrt.RouteAbbreviation  
                                        END  
                                 ELSE MedName.MedicationName  
                            END , 
                            dic.ICD10Code, 
                            cmi.StrengthId ,  
                            MDMeds.StrengthDescription AS InstructionStrengthDescription ,  
                            MDMeds.MedicationDescription  
                            + CASE WHEN mdrt.RouteAbbreviation IS NULL THEN ''  
                                   ELSE ', ' + mdrt.RouteAbbreviation  
                              END AS TitrationStrengthDescription ,  
                            NULL AS InstructionSummary ,  
                            NULL AS PatientScheduleSummary ,  
                            cmsd.Sample + cmsd.Stock AS disbursedAmount ,  
                            '(' + gc1.codeName + ') ' + gc2.codeName AS UnitScheduleString ,  
                            gc1.codeName AS UnitValue ,  
 --Pharmacy Text Change  
                            CASE ISNULL(cmsd.PharmacyText, '')  
                              WHEN ''  
                              THEN CASE WHEN gc1.codeName IN ( 'units', 'each' )  
                                        THEN '#'  
                                        ELSE 'x '  
                                   END  
                              ELSE ''  
                            END AS UnitValueString ,  
                            gc2.codeName AS ScheduleValue ,  
                            CASE WHEN cmTemp.TitrationType IS NULL THEN 0  
                                 ELSE ISNULL(cmi.TitrationStepNumber, 0)  
                            END AS TitrationStepNumber ,  
                            cm.MedicationStartDate ,  
                            cm.MedicationEndDate ,  
                            cms.OrderDate ,  
                            dbo.ssf_RemoveTrailingZeros(CMI.Quantity) AS Quantity ,  
                            gc2.ExternalCode1 AS SchedValueMultiplier ,  
                            CASE WHEN cms.CreatedDate < @StartDate  
                                 THEN REPLACE(cmi.Quantity, '.00', '')
                                      * cmsd.Days * gc2.ExternalCode1  
                                 --ELSE CONVERT(INT, cmsd.pharmacy)  
                                 ELSE cmsd.Pharmacy  
                            END AS TotalQuantity ,  
                            cmsd.StartDate AS DrugStartDate , --Titration Start (Drug)  
                            cmsd.EndDate AS DrugEndDate , --Titration End (Drug)  
                            REPLACE(cmsd.Refills, '.00', '') AS Refills ,  
                            cmsd.Days AS DurationDays ,  
                            REPLACE(cmsd.Pharmacy, '.00', '') AS Pharmacy ,  
                            REPLACE(cmsd.Sample, '.00', '') AS Sample ,  
                            REPLACE(cmsd.Stock, '.00', '') AS Stock ,  
                            CASE WHEN ISNULL(cm.DAW, 'N') = 'N'  
                                 THEN 'Substitutions Allowed'  
                                 WHEN ( ISNULL(cm.DAW, 'N') = 'Y'  
                                        AND @OrderingMethod <> 'P'  
                                      ) THEN 'Dispense as Written'  
                                 WHEN ( ISNULL(cm.DAW, 'N') = 'Y'  
                                        AND @OrderingMethod = 'P'  
                                      )  
                                 THEN 'No substitutions.'  
                                 ELSE ''  
                            END AS DAW ,  
                            LTRIM(RTRIM(cm.SpecialInstructions)) AS SpecialInstructions ,  
                            CASE WHEN ISNULL(CM.Discontinued, 'N') = 'Y'  
                                      AND RTRIM(CM.DiscontinuedReason) NOT IN (  
                                      'Re-Order', 'Change Order' )  
                                 THEN 'Discontinued'  
                                 ELSE CASE CMS.ScriptEventType  
                                        WHEN 'N' THEN 'New'  
                                        WHEN 'C' THEN 'Changed'  
                                        WHEN 'R' THEN 'Re-Ordered'  
                                      END  
                            END AS OrderStatus ,  
                            cm.OffLabel ,  
                            cm.Comments ,  
                            cm.IncludeCommentOnPrescription , 
                            cmsd.PharmacyText, 
                            map.SmartCareRxCode
							,CASE WHEN dic.ICD10Code  IS NULL THEN cm.DrugPurpose ELSE dic.ICD10Code END  AS DxPurpose    
                    FROM    ClientMedicationScripts AS cms  
                            JOIN ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationScriptId = CMS.ClientMedicationScriptId  
                                                              AND ISNULL(cmsd.RecordDeleted,  
                                                              'N') <> 'Y'  
                            JOIN ClientMedicationInstructions AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId  
                                                              AND ISNULL(cmi.RecordDeleted,  
                                                              'N') <> 'Y'  AND ISNULL(cmi.Active,'Y')='Y'
                            JOIN ClientMedications AS cm ON cm.ClientMedicationId = cmi.ClientMedicationId  
                                                            AND ISNULL(cm.RecordDeleted,  
                                                              'N') <> 'Y'  
                            JOIN @ClientMedications AS cmTemp ON cmTemp.ClientMedicationId = cm.ClientMedicationId  
                            JOIN MDMedicationNames AS MedName ON MedName.MedicationNameId = cm.MedicationNameId  
                                                              AND ISNULL(MedName.RecordDeleted,  
                                                              'N') <> 'Y'  
                            JOIN MDMedications AS MDMeds ON MDMeds.MedicationId = cmi.StrengthId  
                            JOIN GlobalCodes AS gc1 ON gc1.GlobalCodeId = cmi.Unit  
                            JOIN GlobalCodes AS gc2 ON gc2.GlobalCodeId = cmi.Schedule  
                            LEFT JOIN MDRoutes AS mdrt ON mdrt.RouteId = MDMeds.RouteId  
                            LEFT JOIN surescriptscodes AS map ON ( cmi.PotencyUnitCode = LTRIM(RTRIM(map.SureScriptsCode))  
      AND map.Category = 'QuantityUnitOfMeasure'  
                                                              ) 
						    LEFT JOIN dbo.DiagnosisICD10Codes as dic on cast(dic.ICD10CodeId as varchar) = cm.DSMCode                                                            
                    WHERE   ISNULL(cms.RecordDeleted, 'N') <> 'Y'  
                            AND @ClientMedicationScriptIds = cms.ClientMedicationScriptId  
    
  --Determine if C2Meds are on the script  
            IF EXISTS ( SELECT  *  
                        FROM    @DrugsDEACodes  
                        WHERE   DEACode = '2' )   
                BEGIN  
                    SET @C2Meds = 'Y'  
   
                    INSERT  INTO @C2MedsList  
                            ( PON  
                            )  
                            SELECT DISTINCT  
                                    csi.PON  
                            FROM    #ClientScriptInstructions csi  
                                    JOIN ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationScriptId = csi.ClientMedicationScriptId  
                                    JOIN @DrugsDEACodes AS ddc ON ddc.ClientMedicationScriptDrugId = cmsd.ClientMedicationScriptDrugId  
                            WHERE   ddc.DEACode = 2  
                                    AND ISNULL(cmsd.RecordDeleted, 'N') <> 'Y'  
  
                END  
  
  
 --Determine if Controlled Meds are on the script  
            IF EXISTS ( SELECT  *  
                        FROM    @DrugsDEACodes  
                        WHERE   DEACode > 0 )   
                BEGIN  
   
                    INSERT  INTO @ControlledMedsList  
                            ( PON  
                            )  
                            SELECT DISTINCT  
                                    csi.PON  
                            FROM    #ClientScriptInstructions csi  
                                    JOIN ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationScriptId = csi.ClientMedicationScriptId  
                                    JOIN @DrugsDEACodes AS ddc ON ddc.ClientMedicationScriptDrugId = cmsd.ClientMedicationScriptDrugId  
                            WHERE   DEACode > 0  
 --and cmsd.ClientMedicationScriptDrugId = @clientmedicationscriptdrugid  
                                    AND ISNULL(cmsd.RecordDeleted, 'N') <> 'Y'  
  
                END  
  
 --End  
  
  
   
        END --End Original Data Select  
  
--Begin Preview Data Select  
    IF ( ISNULL(@OriginalData, 0) = 0 )   
        BEGIN  
			select @VerbalOrderReadBack=VerbalOrderReadBack from ClientMedicationScriptsPreview 
			where ClientMedicationScriptId=  @ClientMedicationScriptIds 
        
-- Get Client Alergy List  
            INSERT  INTO @AllergyListTable  
                    ( ConceptDescription  
                    )  
                    SELECT  ISNULL(ConceptDescription,  
                                   'No Known Medication/Other Allergies')  
                    FROM    ClientMedicationScriptsPreview AS cms  
                            JOIN Clients AS c ON c.ClientId = cms.ClientId  
                                                 AND ISNULL(c.RecordDeleted,  
                                                            'N') <> 'Y'  
                            LEFT JOIN ClientAllergies AS cla ON cla.ClientId = c.ClientId  
                                                              AND ISNULL(cla.RecordDeleted,  
                                                              'N') <> 'Y'  
                            LEFT JOIN MDAllergenConcepts AS MDAl ON MDAl.AllergenConceptId = cla.AllergenConceptId  
                    WHERE   ISNULL(cms.RecordDeleted, 'N') <> 'Y'  
                            AND @ClientMedicationScriptIds = cms.ClientMedicationScriptId  
                            AND ISNULL(cla.AllergyType, 'A') IN ( 'A' )--'I' intolerance  
                            AND ISNULL(cla.Active, 'N') = 'Y' 
                    ORDER BY ISNULL(ConceptDescription,  
                                    'No Known Medication/Other Allergies')  
  
    --Find Max Allergy in temp table for while loop  
            SET @MaxAllergyId = ( SELECT    MAX(AllergyId)  
                                  FROM      @AllergyListTable  
                                )  
  
    --Begin Loop to create Allergy List  
            WHILE @AllergyId <= @MaxAllergyId   
                BEGIN  
                    SET @AllergyList = ISNULL(@AllergyList, '')  
                        + CASE WHEN @AllergyId <> 1 THEN ', '  
                               ELSE ''  
                          END + ( SELECT    ISNULL(ConceptDescription, '')  
                                  FROM      @AllergyListTable t  
                                  WHERE     t.AllergyId = @AllergyId  
                                )  
                    SET @AllergyId = @AllergyId + 1  
                END  
    --End Loop  
   
 --get Client Info  
            INSERT  INTO #ScriptHeader  
                    ( OrganizationName ,  
                      ClientMedicationScriptId ,  
                      OrderingMethod ,  
                      AllergyList ,  
                      ClientId ,  
                      ClientName ,  
                      ClientAddress ,  
                      ClientHomePhone ,  
                      ClientDOB ,  
                      LocationAddress ,  
                      LocationName ,  
                      LocationPhone ,  
                      LocationFax ,  
                      PharmacyName ,  
                      PharmacyAddress ,  
                      PharmacyPhone ,  
                      PharmacyFax ,  
                      RxReferenceNumber ,  
                      SureScriptsRefillRequestId  
                    )  
                    SELECT  ( SELECT    OrganizationName  
                              FROM      SystemConfigurations  
                            ) AS OrganizationName ,  
                            cms.ClientMedicationScriptId ,  
                            @OrderingMethod AS OrderingMethod ,  
                            @AllergyList AS AllergyList ,  
                            c.ClientId ,  
                            c.LastName + ', ' + c.FirstName AS ClientName ,  
                            ISNULL(ca.Display, '') AS ClientAddress ,  
                            ISNULL(cph.PhoneNumber, '             ') AS ClientHomePhone ,  
                            c.DOB AS ClientDOB ,  
                            ISNULL(l.AddressDisplay, '') + CHAR(10) AS LocationAddress,  
                            --+ ISNULL(l.City + ', ', '') + ISNULL(l.State, '')  
                            --+ ' ' + ISNULL(l.ZipCode, '') AS LocationAddress ,  
                            ISNULL(l.LocationName, '') AS LocationName ,  
                            CASE WHEN ISNULL(l.PhoneNumber, '             ') = ''  
                                 THEN '             '  
                                 ELSE ISNULL(l.PhoneNumber, '           ')  
                                      + ' '  
                            END AS LocationPhone ,  
                            CASE WHEN ISNULL(l.FaxNumber, '             ') = ''  
                                 THEN '             '  
                                 ELSE ISNULL(l.FaxNumber, '             ')  
                                      + ' '  
                            END AS LocationFax ,  
                            ISNULL(p.PharmacyName, '') AS PharmacyName ,  
                            CASE WHEN ISNULL(@DisplayFullPharmacyAddress,'N') = 'N'  
                                 THEN ISNULL(p.AddressDisplay , '')   
                                 ELSE ISNULL(p.AddressDisplay + ', '+p.City+', '+p.State+', '+ p.ZipCode, '') 
                            END  AS PharmacyAddress , 
                            CASE WHEN ISNULL(p.PhoneNumber, '             ') = ''  
                                 THEN '             '  
                                 ELSE ISNULL(p.PhoneNumber, '             ')  
                                      + ' '  
                            END AS PharmacyPhone ,  
                            CASE WHEN ISNULL(p.FaxNumber, '             ') = ''  
                                 THEN '             '  
                                 ELSE ISNULL(p.FaxNumber, '             ')  
                                      + ' '  
                            END AS PharmacyFax ,  
                            '' ,  
                            cms.SureScriptsRefillRequestId  
                    FROM    ClientMedicationScriptsPreview AS cms  
                            JOIN Clients AS c ON c.ClientId = cms.ClientId  
                     AND ISNULL(c.RecordDeleted,  
                                                            'N') <> 'Y'  
                            LEFT JOIN ClientAddresses AS ca ON ca.ClientId = c.ClientId  
                                                              AND ca.AddressType = 90  
                                                              AND ISNULL(ca.RecordDeleted,  
                                                              'N') <> 'Y'  
                            LEFT JOIN ClientPhones AS cph ON cph.ClientId = c.ClientId  
                                                             AND cph.PhoneType = 30  
                                                             AND ISNULL(cph.RecordDeleted,  
                                                              'N') <> 'Y'  
                            JOIN Locations AS l ON l.LocationId = cms.LocationId  
                                                   AND ISNULL(l.RecordDeleted,  
                                                              'N') <> 'Y'  
                            LEFT JOIN Pharmacies AS p ON p.PharmacyId = cms.PharmacyId  
                                                         AND (@OrderingMethod = 'F'  or @OrderingMethod = 'P' )  
       --LEFT JOIN dbo.SureScriptsRefillRequests ssrr ON ( cms.SureScriptsRefillRequestId = ssrr.SureScriptsRefillRequestId )  
                            --LEFT JOIN dbo.SurescriptsRefillDenials ssrd ON ( ssrr.SureScriptsRefillRequestId = ssrd.SurescriptsRefillRequestId )  
                    WHERE   ISNULL(cms.RecordDeleted, 'N') <> 'Y'  
                            AND @ClientMedicationScriptIds = cms.ClientMedicationScriptId  
  
 --Set Show Cover Letter Flag for Script  
            SELECT  @ShowCoverLetter = CASE WHEN @FaxFlag = 'Y'  
                                                 AND ISNULL(p.NumberOfTimesFaxed,  
                                                            0) < @PharmacyCoverLetters  
                                            THEN 'Y'  
                                            ELSE 'N'  
                                       END  
            FROM    ClientMedicationScriptsPreview AS cms  
                    JOIN Pharmacies AS p ON p.PharmacyId = cms.PharmacyId  
  
   -- get the deacodes for all ClientMedicationScriptDrugs  
            DECLARE cDrugsDEA CURSOR fast_forward  
            FOR  
                SELECT DISTINCT  
                        cmsd.ClientMedicationScriptDrugId ,  
                        cmi.StrengthId  
                FROM    ClientMedicationScriptDrugsPreview AS cmsd  
                        JOIN ClientMedicationInstructionsPreview AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId  
                WHERE   cmsd.ClientMedicationScriptId = @ClientMedicationScriptIds  
                        AND ISNULL(cmsd.RecordDeleted, 'N') <> 'Y'  
                        AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'  AND ISNULL(cmi.Active,'Y')='Y'
  
            OPEN cDrugsDEA  
  
            FETCH cDrugsDEA INTO @cDrugsDEAScriptDrugId,  
                @cDrugsDEAMedicationId  
  
            WHILE @@fetch_status = 0   
                BEGIN  
                    EXEC [csp_SCClientMedicationC2C5Drugs] @cDrugsDEAMedicationId,  
                        @cDrugsDEACode OUTPUT  
  
                    INSERT  INTO @DrugsDEACodes  
                            ( ClientMedicationScriptDrugId ,  
                              DEACode  
                            )  
                    VALUES  ( @cDrugsDEAScriptDrugId ,  
                              @cDrugsDEACode  
                            )  
  
                    FETCH cDrugsDEA INTO @cDrugsDEAScriptDrugId,  
                        @cDrugsDEAMedicationId  
                END  
  
            CLOSE cDrugsDEA  
  
            DEALLOCATE cDrugsDEA  
  
 --Get Signature Info  
            INSERT  INTO #ScriptSignatures  
                    SELECT DISTINCT  
                            cms.ClientMedicationScriptId ,  
                            @OrderingMethod AS OrderingMethod ,  
                cm.PrescriberId ,  
                            CASE WHEN ISNULL(st.SigningSuffix, '') = ''  
                                 THEN st.FirstName + ' ' + st.Lastname + ', '  
                                      + stDeg.CodeName  
                                 ELSE st.FirstName + ' ' + st.Lastname + ', '  
                                      + st.SigningSuffix  
                            END  
                             +  ' DEA #: ' + ISNULL(sld.LicenseNumber, '') + ', ' + 'NA DEA #: ' + @NADEA + ', ' + 'LIC #: '  + ISNULL(st.LicenseNumber, '')  AS Prescriber ,
                            'Supervising Physician: ' + CASE 
								WHEN ISNULL(sSupervisor.SigningSuffix, '') = ''
									THEN sSupervisor.FirstName + ' ' + sSupervisor.Lastname + ', ' + ISNULL(suDeg.CodeName,'')
								ELSE sSupervisor.FirstName + ' ' + sSupervisor.Lastname + ', ' + sSupervisor.SigningSuffix
								END + CASE 
								WHEN sSupervisor.Degree IN (
										SELECT Degree
										FROM @DrDegree
										)
									THEN '     DEA #: ' + ISNULL(sSupervisor.DEANumber, '')
								ELSE CASE 
										WHEN EXISTS (
												SELECT *
												FROM @DrugsDEACodes
												WHERE DEACode IN (
														2
														,3
														,4
														,5
														)
												)
											THEN '     DEA #: ' + ISNULL(sSupervisor.DEANumber, '') + ', ' + 'CTP #: ' + ISNULL(sSupervisor.LicenseNumber, '')
										ELSE '     CTP #: ' + ISNULL(sSupervisor.LicenseNumber, '')
										END
								END AS Supervisor
                            ,CASE WHEN ( @OrderingMethod = 'F' )  
                                      AND ( st.StaffId <> v.StaffId )  
                                 THEN 'Prescribing Agent: '  
                                      + CASE WHEN ISNULL(v.SigningSuffix, '') = ''  
                                             THEN v.FirstName + ' '  
                                                  + v.Lastname + ', '  
                                                  + vDeg.CodeName  
                                             ELSE v.FirstName + ' '  
                                                  + v.Lastname + ', '  
                                                  + v.SigningSuffix  
                                        END  
                                 ELSE ''  
                            END AS Creator ,  
                            cms.CreatedBy ,  
                            sf.SignatureFacsimile ,  
                            cms.PrintDrugInformation  
                    FROM    ClientMedicationScriptsPreview AS cms  
                            JOIN ClientMedicationScriptDrugsPreview AS cmsd ON cmsd.ClientMedicationScriptId = CMS.ClientMedicationScriptId  
                                                              AND ISNULL(cmsd.RecordDeleted,  
                                                              'N') <> 'Y'  
                            JOIN ClientMedicationInstructionsPreview AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId  
                                                              AND ISNULL(cmi.RecordDeleted,  
                                                              'N') <> 'Y'  AND ISNULL(cmi.Active,'Y')='Y'
                            JOIN ClientMedicationsPreview AS cm ON cm.ClientMedicationId = cmi.ClientMedicationId  
                                                              AND ISNULL(cm.RecordDeleted,  
                                                              'N') <> 'Y'  
                            JOIN Staff AS v ON v.UserCode = cms.CreatedBy  
                                               AND ISNULL(v.RecordDeleted, 'N') <> 'Y'  
							JOIN Staff AS s ON s.StaffId = cms.OrderingPrescriberId          
					        LEFT JOIN StaffLicenseDegrees as sld ON sld.StaffLicenseDegreeId=cms.StaffLicenseDegreeId  
							JOIN MDMedicationNames AS MedName ON MedName.MedicationNameId = cm.MedicationNameId
												AND ISNULL(MedName.RecordDeleted,
														   'N') <> 'Y'
          LEFT JOIN globalCodes AS vDeg ON vDeg.GlobalCodeId = v.Degree  
                            JOIN Staff AS st ON st.StaffId = cm.PrescriberId  
                                                AND ISNULL(st.RecordDeleted,  
                                                           'N') <> 'Y'  
                            LEFT JOIN globalCodes AS stDeg ON stDeg.GlobalCodeId = st.Degree  
                            LEFT JOIN StaffSignatureFacsimiles AS sf ON sf.StaffId = cm.PrescriberId  
                                                              AND ISNULL(sf.RecordDeleted,  
                                                              'N') <> 'Y'  
                                                              AND @OrderingMethod = 'F' 
							LEFT JOIN Staff AS sSupervisor ON sSupervisor.StaffId = v.RxAuthorizedProvider
							LEFT JOIN globalCodes AS suDeg ON suDeg.GlobalCodeId = sSupervisor.Degree 															  
                    WHERE   ISNULL(cms.RecordDeleted, 'N') <> 'Y'  
                            AND @ClientMedicationScriptIds = cms.ClientMedicationScriptId  
  
 /*main*/  
            INSERT  INTO #ClientScriptInstructions  
                    SELECT  cms.ClientMedicationScriptId ,  
                            @OrderingMethod AS OrderingMethod ,  
                            CASE WHEN @OrderingMethod <> 'C'  
                                 THEN 'Prescription'  
                                 ELSE 'Chart'  
                            END AS CopyType ,  
                            cms.OrderDate AS ScriptOrderedDate ,  
                            CAST(cms.ClientMedicationScriptId AS VARCHAR)  
                            + '-'  
                            + CAST(CASE WHEN cmTemp.TitrationType IS NULL  
                                        THEN cmi.StrengthId  
                                        ELSE ( SELECT   MIN(cmi2.StrengthId)  
                                               FROM     ClientMedicationScriptDrugsPreview  
                                                        AS cmsd2  
                                                        JOIN ClientMedicationInstructionsPreview cmi2 ON cmi2.ClientMedicationInstructionId = cmsd2.ClientMedicationInstructionId  
                                               WHERE    cmsd2.ClientMedicationScriptId = cmsd.ClientMedicationScriptId  
                                                        AND cmi2.ClientMedicationId = cm.ClientMedicationId  
                                                        AND ISNULL(cmsd2.RecordDeleted,  
                                                              'N') <> 'Y'  
                                                        AND ISNULL(cmi2.RecordDeleted,  
                                                              'N') <> 'Y'  AND ISNULL(cmi2.Active,'Y')='Y'
                                             )  
                                   END AS VARCHAR) + '-'  
                            + CAST(CASE WHEN cmTemp.TitrationType IS NULL  
                                        THEN cmsd.DAYS  
                                        ELSE ( SELECT   SUM(b.days)  
                                               FROM     dbo.ClientMedicationInstructionsPreview a  
                                                        JOIN dbo.ClientMedicationScriptDrugsPreview b ON ( a.ClientMedicationInstructionId = b.ClientMedicationInstructionId )  
                                               WHERE    ISNULL(a.RecordDeleted,  
                                                              'N') <> 'Y'  AND ISNULL(a.Active,'Y')='Y'
                                                        AND ISNULL(b.RecordDeleted,  
                                                              'N') <> 'Y'  
                                                        AND a.ClientMedicationId = cm.ClientMedicationId  
                                             )  
                                   END AS VARCHAR(10)) + '-'  
                            + CAST(REPLACE(cmsd.Refills, '.00', '') AS VARCHAR(10)) AS PON ,  
                            cmi.ClientMedicationInstructionId ,  
                            CASE WHEN cmTemp.TitrationType IS NULL  
                                 THEN MDMeds.MedicationDescription  
                                      + CASE WHEN mdrt.RouteAbbreviation IS NULL  
                                             THEN ''  
                                             ELSE ', '  
                                                  + mdrt.RouteAbbreviation  
                                        END  
                                 ELSE MedName.MedicationName  
                            END ,  
                            dic.ICD10Code,
                            cmi.StrengthId ,  
                            MDMeds.StrengthDescription AS InstructionStrengthDescription ,  
                            MDMeds.MedicationDescription  
                            + CASE WHEN mdrt.RouteAbbreviation IS NULL THEN ''  
                                   ELSE ', ' + mdrt.RouteAbbreviation  
                              END AS TitrationStrengthDescription ,  
                            NULL AS InstructionSummary ,  
                            NULL AS PatientScheduleSummary ,  
                            cmsd.Sample + cmsd.Stock AS disbursedAmount ,  
                            '(' + gc1.codeName + ') ' + gc2.codeName AS UnitScheduleString ,  
                            gc1.codeName AS UnitValue ,  
 --Pharmacy Text Change  
                            CASE ISNULL(cmsd.PharmacyText, '')  
                              WHEN ''  
                              THEN CASE WHEN gc1.codeName IN ( 'units', 'each' )  
                                        THEN '#'  
                                        ELSE 'x '  
                                   END  
                              ELSE ''  
                            END AS UnitValueString ,  
                            gc2.codeName AS ScheduleValue ,  
                            CASE WHEN cmTemp.TitrationType IS NULL THEN 0  
                                 ELSE ISNULL(cmi.TitrationStepNumber, 0)  
                            END AS TitrationStepNumber ,  
                            cm.MedicationStartDate ,  
                            cm.MedicationEndDate ,  
                            cms.OrderDate ,  
                            dbo.ssf_RemoveTrailingZeros(CMI.Quantity) AS Quantity ,  
                            gc2.ExternalCode1 AS SchedValueMultiplier ,  
                            CASE WHEN cms.CreatedDate < @StartDate  
                                 THEN REPLACE(cmi.Quantity, '.00', '')
                                      * cmsd.Days * gc2.ExternalCode1  
                                 --ELSE CONVERT(INT, cmsd.pharmacy)  
                                 ELSE cmsd.Pharmacy  
                            END AS TotalQuantity ,  
                            cmsd.StartDate AS DrugStartDate , --Titration Start (Drug)  
                            cmsd.EndDate AS DrugEndDate , --Titration End (Drug)  
                            REPLACE(cmsd.Refills, '.00', '') AS Refills ,  
                            cmsd.Days AS DurationDays ,  
                            REPLACE(cmsd.Pharmacy, '.00', '') AS Pharmacy ,  
                            REPLACE(cmsd.Sample, '.00', '') AS Sample ,  
                            REPLACE(cmsd.Stock, '.00', '') AS Stock ,  
                            CASE WHEN ISNULL(cm.DAW, 'N') = 'N'  
                                 THEN 'Substitutions Allowed'  
                                 WHEN ( ISNULL(cm.DAW, 'N') = 'Y'  
                                        AND @OrderingMethod <> 'P'  
                                      ) THEN 'Dispense as Written'  
                                 WHEN ( ISNULL(cm.DAW, 'N') = 'Y'  
                                        AND @OrderingMethod = 'P'  
                                      )  
                                 THEN 'No substitutions.'  
                                 ELSE ''  
                            END AS DAW ,  
                            LTRIM(RTRIM(cm.SpecialInstructions)) AS SpecialInstructions ,  
                            CASE WHEN ISNULL(CM.Discontinued, 'N') = 'Y'  
                                      AND RTRIM(CM.DiscontinuedReason) NOT IN (  
                                      'Re-Order', 'Change Order' )  
                                 THEN 'Discontinued'  
                                 ELSE CASE CMS.ScriptEventType  
                                        WHEN 'N' THEN 'New'  
                                        WHEN 'C' THEN 'Changed'  
                                        WHEN 'R' THEN 'Re-Ordered'  
                                      END  
                            END AS OrderStatus ,  
                            cm.OffLabel ,  
                            cm.Comments ,  
                            cm.IncludeCommentOnPrescription ,  
                            cmsd.PharmacyText,
                             map.SmartCareRxCode,
							CASE WHEN dic.ICD10Code  IS NULL THEN cm.DrugPurpose ELSE dic.ICD10Code END  AS DxPurpose  
                    FROM    ClientMedicationScriptsPreview AS cms  
                            JOIN ClientMedicationScriptDrugsPreview AS cmsd ON cmsd.ClientMedicationScriptId = CMS.ClientMedicationScriptId  
                                                              AND ISNULL(cmsd.RecordDeleted,  
                                                              'N') <> 'Y'  
                            JOIN ClientMedicationInstructionsPreview AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId  
                                                              AND ISNULL(cmi.RecordDeleted,  
                                                              'N') <> 'Y'  AND ISNULL(cmi.Active,'Y')='Y'
                            JOIN ClientMedicationsPreview AS cm ON cm.ClientMedicationId = cmi.ClientMedicationId  
                                                              AND ISNULL(cm.RecordDeleted,  
                                                              'N') <> 'Y'  
                            JOIN @ClientMedications AS cmTemp ON cmTemp.ClientMedicationId = cm.ClientMedicationId  
                            JOIN MDMedicationNames AS MedName ON MedName.MedicationNameId = cm.MedicationNameId  
                                                              AND ISNULL(MedName.RecordDeleted,  
                                                              'N') <> 'Y'  
                            JOIN MDMedications AS MDMeds ON MDMeds.MedicationId = cmi.StrengthId  
                            JOIN GlobalCodes AS gc1 ON gc1.GlobalCodeId = cmi.Unit  
                            JOIN GlobalCodes AS gc2 ON gc2.GlobalCodeId = cmi.Schedule  
                            LEFT JOIN MDRoutes AS mdrt ON mdrt.RouteId = MDMeds.RouteId  
                            LEFT JOIN surescriptscodes AS map ON ( cmi.PotencyUnitCode = LTRIM(RTRIM(map.SureScriptsCode))  
                                                              AND map.Category = 'QuantityUnitOfMeasure'  
                                                              )  
							LEFT JOIN dbo.DiagnosisICD10Codes as dic on cast(dic.ICD10CodeId as varchar) = cm.DSMCode                                                              
                    WHERE   ISNULL(cms.RecordDeleted, 'N') <> 'Y'  
                            AND @ClientMedicationScriptIds = cms.ClientMedicationScriptId  
  
   
 --Determine if C2Meds are on the script  
            IF EXISTS ( SELECT  *  
                        FROM    @DrugsDEACodes  
                        WHERE   DEACode = 2 )   
                BEGIN  
                    SET @C2Meds = 'Y'  
  
                    INSERT  INTO @C2MedsList  
                            SELECT DISTINCT  
                                    csi.PON  
                            FROM    #ClientScriptInstructions csi  
                                    JOIN ClientMedicationScriptDrugsPreview AS cmsd ON cmsd.ClientMedicationScriptId = csi.ClientMedicationScriptId  
                                    JOIN @DrugsDEACodes AS ddc ON ddc.ClientMedicationScriptDrugId = cmsd.ClientMedicationScriptDrugId  
                            WHERE   ddc.DEACode = 2  
                                    AND ISNULL(cmsd.RecordDeleted, 'N') <> 'Y'  
  
                END  
  
 --Determine if Controlled Meds are on the script  
            IF EXISTS ( SELECT  *  
                        FROM    @DrugsDEACodes  
                        WHERE   DEACode > 0 )   
                BEGIN  
   
                    INSERT  INTO @ControlledMedsList  
                            ( PON  
                            )  
                            SELECT DISTINCT  
                                    csi.PON  
                            FROM    #ClientScriptInstructions csi  
                                    JOIN ClientMedicationScriptDrugsPreview AS cmsd ON cmsd.ClientMedicationScriptId = csi.ClientMedicationScriptId  
                                    JOIN @DrugsDEACodes AS ddc ON ddc.ClientMedicationScriptDrugId = cmsd.ClientMedicationScriptDrugId  
                            WHERE   ddc.DEACode > 0  
                                    AND ISNULL(cmsd.RecordDeleted, 'N') <> 'Y'  
  
                END  
  
  
 --End  
  
        END --End Preview Data Select  
  
  
  
--  
--Data Updates for the script  
--  
  
    INSERT  INTO #QuantitySummary  
            SELECT  NULL ,  
                    ClientMedicationInstructionId ,  
                    PON ,  
                    StrengthId ,  
                    TitrationStepNumber ,  
                    DurationDays ,  
                    Quantity ,  
                    Pharmacy ,  
                    TotalQuantity ,  
                    Sample ,  
                    Stock ,  
                    DisbursedAmount ,  
                    NULL AS DisbursedTotal ,  
                    NULL AS DisbursedFlag ,  
                    NULL AS PharmacyTotal ,  
                    NULL AS GroupTotal ,  
                    DrugStartDate ,  
                    DrugEndDate ,  
                    Refills ,  
                    NULL AS Titration ,  
                    NULL AS Multiples ,  
                    NULL AS SingleLine ,  
                    PotencyUnitCodeDescription  
            FROM    #ClientScriptInstructions  
            ORDER BY PON ,  
                    StrengthId ,  
                    TitrationStepNumber ,  
                    DrugStartDate ,  
                    DrugEndDate ,  
                    Refills  
           
  
    INSERT  INTO @TitrationPONs  
            SELECT  PON ,  
                    CASE WHEN SUM(( ISNULL(TitrationStepNumber, 0) )) >= 1  
                              AND COUNT(( ISNULL(TitrationStepNumber, 0) )) > 1  
                         THEN 'Y'  
                         ELSE 'N'  
                    END AS Titration  
            FROM    #QuantitySummary qs  
            GROUP BY PON  
  
    UPDATE  qs  
    SET     titration = tp.titration  
    FROM    #QuantitySummary qs  
            JOIN @TitrationPONs tp ON tp.PON = qs.PON  
  
    UPDATE  qs  
    SET     Multiples = 'Y'  
    FROM    #QuantitySummary qs  
    WHERE   EXISTS ( SELECT *  
                     FROM   #QuantitySummary qs2  
                     WHERE  qs2.PON = qs.PON  
                            AND qs2.StrengthId = qs.StrengthId  
                            AND qs2.PotencyUnitCodeDescription = qs.PotencyUnitCodeDescription  
                            AND qs2.DrugStartDate = qs.DrugStartDate  
                            AND qs2.DrugEndDate = qs.DrugEndDate  
                            AND qs2.Refills = qs.Refills  
                            AND qs2.ClientMedicationInstructionId <> qs.ClientMedicationInstructionId  
                            AND qs2.Titration <> 'Y' )    
   
    UPDATE  qs  
    SET     Multiples = 'N'  
    FROM    #QuantitySummary qs  
    WHERE   Multiples IS NULL  
    UPDATE  qs  
    SET     SingleLine = CASE WHEN ( Multiples <> 'Y'  
                                     AND Titration <> 'Y'  
                                   ) THEN 'Y'  
                              ELSE 'N'  
                         END  
    FROM    #QuantitySummary qs  
  
    INSERT  INTO @StrengthGroupInstructionIds  
            SELECT  StrengthId ,  
                    ClientMedicationInstructionId  
            FROM    #QuantitySummary  
            WHERE   ( Multiples = 'Y'  
                      OR Titration = 'Y'  
                    )  
   
    UPDATE  a  
    SET     DisbursedTotal = b.DisbursedTotal ,  
            PharmacyTotal = b.PharmacyTotal ,  
            GroupTotal = b.GroupTotal  
    FROM    #QuantitySummary a  
            JOIN ( SELECT   qs.StrengthId ,  
                            qs.pon ,  
                            qs.PotencyUnitCodeDescription ,  
                            SUM(qs.DisbursedAmount) AS DisbursedTotal ,  
                            SUM(qs.TotalQuantity) - SUM(qs.DisbursedAmount) AS PharmacyTotal ,  
                            SUM(qs.TotalQuantity) AS GroupTotal  
                   FROM     #QuantitySummary qs  
                            JOIN @StrengthGroupInstructionIds sg ON sg.StrengthId = qs.StrengthId  
                                                              AND sg.ClientMedicationInstructionId = qs.ClientMedicationInstructionId  
                   GROUP BY qs.StrengthId ,  
                            qs.pon ,  
                            qs.PotencyUnitCodeDescription  
                 ) b ON b.StrengthId = a.StrengthId  
                        AND a.pon = b.pon  
                        AND a.PotencyUnitCodeDescription = b.PotencyUnitCodeDescription  
            JOIN @StrengthGroupInstructionIds c ON c.StrengthId = a.StrengthId  
                                                   AND c.ClientMedicationInstructionId = a.ClientMedicationInstructionId  
  
    UPDATE  qs  
    SET     DisbursedTotal = DisbursedAmount ,  
            PharmacyTotal = TotalQuantity - DisbursedAmount ,  
            GroupTotal = TotalQuantity  
    FROM    #QuantitySummary qs  
    WHERE   Singleline = 'Y'  
            AND GroupTotal IS NULL  
  
 --Start Create Strength Groups For Multiple instruction orders  
    DECLARE InsStrengthGroup CURSOR  
    FOR  
        SELECT  PON ,  
                StrengthId ,  
                PotencyUnitCodeDescription ,  
                Titration ,  
                Multiples ,  
                SingleLine  
        FROM    #QuantitySummary  
        GROUP BY PON ,  
                StrengthId ,  
                PotencyUnitCodeDescription ,  
                Titration ,  
                Multiples ,  
                SingleLine  
  
    OPEN InsStrengthGroup  
    SET @IdxCur1 = 1  
    FETCH NEXT FROM InsStrengthGroup INTO @PONCur1, @StrengthIdCur1,  
        @PotencyUnitCodeDescriptionCur1, @TitrationCur1, @MultiplesCur1,  
        @SingleLineCur1  
    WHILE ( @@fetch_status = 0 )   
        BEGIN   
            UPDATE  qs  
            SET     InsrtuctionMultipleStrengthGroupId = @IdxCur1  
            FROM    #QuantitySummary qs  
            WHERE   qs.PON = @PONCur1  
                    AND qs.StrengthId = @StrengthIdCur1  
                    AND qs.Titration = @TitrationCur1  
                    AND qs.Multiples = @MultiplesCur1  
                    AND qs.SingleLine = @SingleLineCur1  
                    AND qs.PotencyUnitCodeDescription = @PotencyUnitCodeDescriptionCur1  
            SET @IdxCur1 = @IdxCur1 + 1  
     
            FETCH NEXT FROM InsStrengthGroup INTO @PONCur1, @StrengthIdCur1,  
                @PotencyUnitCodeDescriptionCur1, @TitrationCur1,  
                @MultiplesCur1, @SingleLineCur1  
        END  
    CLOSE InsStrengthGroup  
    DEALLOCATE InsStrengthGroup  
 --End Create Strength Groups For Multiple instruction orders  
   
    BEGIN  
  --Set Titrations to same StrengthGroup for report purposes  
        UPDATE  a  
        SET     InsrtuctionMultipleStrengthGroupId = b.InsrtuctionMultipleStrengthGroupId  
        FROM    #QuantitySummary a  
                JOIN ( SELECT   PON ,  
                                MIN(InsrtuctionMultipleStrengthGroupId) AS InsrtuctionMultipleStrengthGroupId  
                       FROM     #QuantitySummary  
                       WHERE    titration = 'Y'  
                       GROUP BY PON  
                     ) b ON b.PON = a.PON  
  
        SELECT  @TitrationRecords = CASE WHEN EXISTS ( SELECT *  
                                                       FROM   #QuantitySummary  
        WHERE  titration = 'Y' )  
                                         THEN 'Y'  
                                         ELSE 'N'  
                                    END  
        SELECT  @MultInstRecords = CASE WHEN EXISTS ( SELECT  *  
                                                      FROM    #QuantitySummary  
                                                      WHERE   Multiples = 'Y' )  
                                        THEN 'Y'  
                                        ELSE 'N'  
                                   END  
    END  
    
 --Update instructions for drugs that are not multiple instructions or titrations and set Disbursed Flag for multiples  
    BEGIN  
        UPDATE  csi  
        SET     InstructionSummary = RTRIM(LTRIM(csi.TitrationStrengthDescription))  
                + SPACE(1) + CONVERT(VARCHAR(16), REPLACE(csi.Quantity, '.00',  
                                                          '')) + SPACE(1)  
                + CASE WHEN csi.UnitScheduleString IS NOT NULL  
                            AND csi.UnitScheduleString <> ''  
                       THEN CONVERT(VARCHAR(250), csi.UnitScheduleString)  
                       ELSE ''  
                  END + CASE WHEN csi.UnitValueString <> ''  
                             THEN ' (' + csi.UnitValueString + ') '  
                             ELSE ''  
                        END  
                + CASE ISNULL(csi.PharmacyText, '')  
                    WHEN ''  
                     THEN '**' + CONVERT(VARCHAR(16), replace(qs.PharmacyTotal, '.00',
                                                      '**')) + ' '
                         + isnull(qs.PotencyUnitCodeDescription, '')  
                    ELSE ''  
                  END + CASE WHEN ISNULL(csi.DisbursedAmount, 0) = 0 THEN ''  
                             ELSE ' ('  
                                  + REPLACE(CAST(( qs.DisbursedTotal ) AS VARCHAR(16)),  
                                            '.00', '')  
                                  + '  disbursed to client from samples)'  
                        END + CASE WHEN c2.PON IS NOT NULL  
                                        AND qs.PharmacyTotal > 0  
                                   THEN ' ('  
                                        + dbo.DecimalToText(REPLACE(qs.PharmacyTotal,  
                                                              '.00', ''))  
                                        + ')'  
                                   ELSE ''  
                              END  
        FROM    #ClientScriptInstructions csi  
                JOIN #QuantitySummary qs ON qs.PON = csi.PON  
                                            AND qs.ClientMedicationInstructionId = csi.ClientMedicationInstructionId  
                                            AND qs.Titration = 'N'  
                                            AND qs.Multiples = 'N'  
                                            AND qs.SingleLine = 'Y'  
                LEFT JOIN @ControlledMedsList c2 ON c2.PON = csi.PON  
  
        UPDATE  a  
        SET     a.DisbursedFlag = b.DisbursedFlag  
        FROM    #QuantitySummary a  
                JOIN ( SELECT   InsrtuctionMultipleStrengthGroupId ,  
                                CASE WHEN SUM(qs2.disbursedAmount) > 0  
                                     THEN 'Y'  
                                     ELSE 'N'  
                                END AS DisbursedFlag  
                       FROM     #QuantitySummary qs2  
                       WHERE    qs2.multiples = 'Y'  
                                OR qs2.SingleLine = 'Y'  
                       GROUP BY qs2.InsrtuctionMultipleStrengthGroupId  
                     ) AS b ON b.InsrtuctionMultipleStrengthGroupId = a.InsrtuctionMultipleStrengthGroupId  
        WHERE   ( a.Multiples = 'Y'  
                  OR a.SingleLine = 'Y'  
                )  
    
        UPDATE  a  
        SET     a.disbursedFlag = b.disbursedFlag  
        FROM    #QuantitySummary a  
                JOIN ( SELECT   qs2.InsrtuctionMultipleStrengthGroupId ,  
                                qs2.StrengthId ,  
                                CASE WHEN SUM(qs2.disbursedAmount) > 0  
                                     THEN 'Y'  
                                     ELSE 'N'  
                                END AS DisbursedFlag  
                       FROM     #QuantitySummary qs2  
                       WHERE    Titration = 'Y'  
                       GROUP BY qs2.InsrtuctionMultipleStrengthGroupId ,  
                                StrengthId  
                     ) AS b ON b.InsrtuctionMultipleStrengthGroupId = a.InsrtuctionMultipleStrengthGroupId  
                               AND b.StrengthId = a.StrengthId  
        WHERE   a.titration = 'Y'  
    END  
   
 --Begin Multiple Instruction Logic  
    IF @MultInstRecords = 'Y'   
        BEGIN  
            DECLARE MultCursor CURSOR  
            FOR  
                SELECT  csi.PON ,  
                        qs.InsrtuctionMultipleStrengthGroupId ,  
                        @MultPharmInstructionString --,@MultPatientInstructionSummaryString  
                FROM    #ClientScriptInstructions csi  
                        JOIN #QuantitySummary qs ON qs.PON = csi.PON  
                                                    AND qs.ClientMedicationInstructionId = csi.ClientMedicationInstructionId  
                                                    AND qs.Titration = 'N'  
                                                    AND qs.Multiples = 'Y'  
                                                    AND qs.SingleLine = 'N'  
                GROUP BY csi.PON ,  
                        qs.InsrtuctionMultipleStrengthGroupId  
  
            OPEN MultCursor  
            FETCH NEXT FROM MultCursor INTO @MultPON,  
                @MultInsrtuctionMultipleStrengthGroupId,  
                @MultPharmInstructionString  
            WHILE ( @@fetch_status = 0 )   
                BEGIN  
                    UPDATE  csi  
                    SET     csi.InstructionSummary =  
         -- csi.InstructionStrengthDescription +  
                            CASE ISNULL(csi.PharmacyText, 0)  
                              WHEN '0'  
                              THEN ' ' + csi.UnitValueString  
                                   + CONVERT(VARCHAR(16), REPLACE(qs.PharmacyTotal,  
                                                              '.00', ''))  
                                   + ' ' + qs.PotencyUnitCodeDescription  
                              ELSE ''  
                            END + CASE WHEN qs.DisbursedFlag = 'N' THEN ''  
                                       ELSE ' ('  
                                            + REPLACE(CAST(( qs.DisbursedTotal ) AS VARCHAR(16)),  
                                                      '.00', '')  
                                            + '  disbursed to client from samples)'  
                                  END + CASE WHEN c2.PON IS NOT NULL  
                                             THEN ' ('  
                                                  + dbo.DecimalToText(REPLACE(qs.PharmacyTotal,  
                                                              '.00', ''))  
                                                  + ')'  
                                             ELSE ''  
                                        END  
                    FROM    #ClientScriptInstructions csi  
                            JOIN #QuantitySummary qs ON qs.PON = csi.PON  
                                                        AND qs.ClientMedicationInstructionId = csi.ClientMedicationInstructionId  
                                                        AND qs.InsrtuctionMultipleStrengthGroupId = @MultInsrtuctionMultipleStrengthGroupId  
                            LEFT JOIN @ControlledMedsList c2 ON c2.PON = csi.PON  
                    WHERE   qs.InsrtuctionMultipleStrengthGroupId = @MultInsrtuctionMultipleStrengthGroupId  
  
                    DECLARE MultiPatientCursor CURSOR  
                    FOR  
                        SELECT  qs.InsrtuctionMultipleStrengthGroupId ,  
                                csi.ClientMedicationInstructionId ,  
                                @MultPatientInstructionSummaryString  
                        FROM    #ClientScriptInstructions csi  
                                JOIN #QuantitySummary qs ON qs.PON = csi.PON  
                                                            AND qs.ClientMedicationInstructionId = csi.ClientMedicationInstructionId  
                                                            AND qs.Titration = 'N'  
                                                            AND qs.Multiples = 'Y'  
                                                            AND qs.SingleLine = 'N'  
                        WHERE   csi.PON = @MultPON  
                                AND qs.InsrtuctionMultipleStrengthGroupId = @MultInsrtuctionMultipleStrengthGroupId  
                        GROUP BY qs.InsrtuctionMultipleStrengthGroupId ,  
                                csi.ClientMedicationInstructionId  
  
                    OPEN MultiPatientCursor  
                    FETCH NEXT FROM MultiPatientCursor INTO @MultInsrtuctionMultipleStrengthGroupId,  
                        @MultClientMedicationInstructionId,  
                        @MultPatientInstructionSummaryString  
                    WHILE ( @@fetch_status = 0 )   
                        BEGIN  
  --PharmacyText  
                            SELECT  @MultPatientInstructionSummaryString = ISNULL(@MultPatientInstructionSummaryString,  
                                                              '')  
    --+ csi.InstructionStrengthDescription  
                                    + CASE WHEN csi.UnitScheduleString LIKE '%Written in Note%'  
                                           THEN ''  
                                           ELSE CONVERT(VARCHAR(6), REPLACE(csi.Quantity,  
                                                              '.00', ''))  
                                                + ' ' + csi.UnitScheduleString  
                                                + CHAR(13) + CHAR(10)  
                                      END  
                            FROM    #ClientScriptInstructions csi  
                                    JOIN #QuantitySummary qs ON qs.PON = csi.PON  
                                                              AND qs.ClientMedicationInstructionId = csi.ClientMedicationInstructionId  
                                                              AND qs.Titration = 'N'  
                                                              AND qs.Multiples = 'Y'  
                                                              AND qs.SingleLine = 'N'  
                                                              AND qs.InsrtuctionMultipleStrengthGroupId = @MultInsrtuctionMultipleStrengthGroupId  
                            WHERE   csi.PON = @MultPON  
                                    AND qs.InsrtuctionMultipleStrengthGroupId = @MultInsrtuctionMultipleStrengthGroupId  
                                    AND csi.ClientMedicationInstructionId = @MultClientMedicationInstructionId  
  
                            UPDATE  csi  
                            SET     csi.PatientScheduleSummary = ISNULL(csi.PatientScheduleSummary,  
                                                              '')  
                                    + @MultPatientInstructionSummaryString  
                            FROM    #ClientScriptInstructions csi  
                                    JOIN #QuantitySummary qs ON qs.PON = csi.PON  
                                                              AND qs.ClientMedicationInstructionId = csi.ClientMedicationInstructionId  
                                                              AND qs.Titration = 'N'  
                                                              AND qs.Multiples = 'Y'  
                                                              AND qs.SingleLine = 'N'  
                            WHERE   csi.PON = @MultPON  
                                    AND qs.InsrtuctionMultipleStrengthGroupId = @MultInsrtuctionMultipleStrengthGroupId  
  
      
                            FETCH NEXT FROM MultiPatientCursor INTO @MultInsrtuctionMultipleStrengthGroupId,  
                                @MultClientMedicationInstructionId,  
                                @MultPatientInstructionSummaryString  
                            SET @MultPatientInstructionSummaryString = ''  
                        END  
                    CLOSE MultiPatientCursor  
                    DEALLOCATE MultiPatientCursor  
                    SELECT  @MultPharmInstructionString = ''  
    
                    FETCH NEXT FROM MultCursor INTO @MultPON,  
                        @MultInsrtuctionMultipleStrengthGroupId,  
                        @MultPharmInstructionString  
                END  
  
            CLOSE MultCursor  
            DEALLOCATE MultCursor  
  
        END  
--End Multiple Instruction Logic  
  
 --Begin Titration Instructions  
    IF @TitrationRecords = 'Y'   
        BEGIN  
            INSERT  INTO @TitrationDays  
                    SELECT DISTINCT  
                            csi.PON ,  
                            csi.TitrationStepNumber ,  
                            QS.DrugStartDate ,  
                            QS.DrugEndDate ,  
                            QS.DurationDays ,  
                            NULL AS DayNumber  
                    FROM    #ClientScriptInstructions csi  
                            JOIN #QuantitySummary qs ON qs.PON = csi.PON  
                                                        AND qs.TitrationStepNumber = csi.TitrationStepNumber  
                                                        AND qs.titration = 'Y'  
  
            UPDATE  td  
            SET     DayNumber = CASE WHEN TitrationStepNumber = 1 THEN 1  
                                     ELSE 1 + DATEDIFF(dd,  
                                                       ( SELECT  
                                                              a.DrugStartDate  
                                                         FROM @TitrationDays a  
                                                         WHERE  
                                                              a.TitrationStepNumber = 1  
                                                              AND a.PON = td.PON  
                                                       ), td.DrugStartDate)  
                                END  
            FROM    @TitrationDays td  
  
            INSERT  INTO @Titrations  
                    SELECT DISTINCT  
                            csi.PON ,  
                            NULL  
                    FROM    #ClientScriptInstructions csi  
                            JOIN #QuantitySummary qs ON qs.PON = csi.PON  
                                                        AND qs.titration = 'Y'  
     
            SELECT  @TitrationId = 1 --,@StepId = 1  
            SET @MaxTitrationId = ( SELECT  MAX(titrationId)  
                                    FROM    @Titrations  
                                  )  
     
            WHILE @TitrationId <= @MaxTitrationId   
                BEGIN  
                    SELECT  @StepInstructionString = '' ,  
                            @TitrationInstructionString = '' --reset instruction string also  
                    SELECT  @PON = PON  
                    FROM    @Titrations  
                    WHERE   TitrationId = @TitrationId  
     
                    INSERT  INTO @TitrationSteps  
                            SELECT  csi.PON ,  
                                    csi.TitrationStepNumber ,  
                                    'Day ' + CONVERT(VARCHAR(6), td.DayNumber)  
                                    + SPACE(5)  
                                    + csi.InstructionStrengthDescription  
                                    + ' ('  
                                    + CONVERT(VARCHAR(6), REPLACE(csi.Quantity,  
       '.00', ''))  
                                    + ') ' + csi.UnitScheduleString  
    --+ space(2) + 'Start - End Date: ' + convert(varchar(12),csi.DrugStartDate,101) + ' - ' + convert(varchar(12),csi.DrugEndDate,101)  
                                    + SPACE(5) + 'Duration: '  
                                    + CONVERT(VARCHAR(6), csi.DurationDays)  
                                    + ' Days' --as TitrationInstruction  
                            FROM    #ClientScriptInstructions csi  
                                    JOIN #QuantitySummary qs ON qs.PON = csi.PON  
                                                              AND qs.titration = 'Y'  
                                                              AND qs.TitrationStepNumber = csi.TitrationStepNumber  
                                                              AND qs.ClientMedicationInstructionId = csi.ClientMedicationInstructionId  
                                    JOIN @TitrationDays td ON td.PON = csi.PON  
                                                              AND td.TitrationStepNumber = csi.TitrationStepNumber  
                            WHERE   csi.PON = @PON  
                            ORDER BY csi.ClientMedicationScriptId ,  
                                    csi.PON ,  
                                    csi.TitrationStepNumber ,  
                                    td.DayNumber  
      
                    SELECT  @MaxStepId = @@Identity ,  
                            @StepId = 1  
                    WHILE @StepId <= @MaxStepId   
                        BEGIN  
                            UPDATE  t  
                            SET     TitrationString = ISNULL(TitrationString,  
                                                             '')  
                                    + ISNULL(StepString, '') + CHAR(13)  
                                    + CHAR(10)  
                            FROM    @Titrations t  
                                    JOIN @TitrationSteps ts ON @PON = ts.PON  
                            WHERE   ts.StepId = @StepId  
                                    AND t.TitrationId = @TitrationId  
  
                            SET @StepId = @StepId + 1  
                        END  
                    SELECT  @TitrationInstructionString = TitrationString  
                    FROM    @Titrations  
                    SET @TitrationInstructionString = @TitrationInstructionString  
                        + @StepInstructionString  
                    SET @TitrationId = @TitrationId + 1  
                END  
     
            DECLARE @titrationAdjustment INT  
            SELECT  @titrationAdjustment = CASE WHEN ISNULL(MedicationRxEndDateOffset,  
                                                            0) > 0 THEN 0  
                                                ELSE 1  
                                           END  
            FROM    SystemConfigurations  
  
            INSERT  INTO @TitrationInstructions  
                    SELECT  t.PON ,  
                            t.TitrationString ,  
                            MIN(csi.drugStartDate) ,  
                            MAX(csi.drugEndDate) ,  
                            DATEDIFF(dd, MIN(csi.drugStartDate),  
                                     MAX(DATEADD(dd, @titrationAdjustment,  
                                                 csi.drugEndDate))) --Add a day to the Max(DrugEndDate) for  
                    FROM    @Titrations t  
                            JOIN #ClientScriptInstructions csi ON t.PON = csi.PON  
                    --WHERE   t.PON = @PON  
                    GROUP BY t.PON ,  
                            t.TitrationString  
        END  
  
    UPDATE  csi  
    SET     PatientScheduleSummary = ti.TitrationInstruction  
    FROM    #ClientScriptInstructions csi  
            JOIN @TitrationInstructions ti ON ti.PON = csi.PON  
  
    INSERT  INTO @TitrationSummary  
            SELECT  csi.PON ,  
                    qs.InsrtuctionMultipleStrengthGroupId ,  
                    csi.StrengthId ,  
                    csi.TitrationStrengthDescription + ' '  
                    + csi.UnitValueString  
                    + CONVERT(VARCHAR(16), REPLACE(qs.PharmacyTotal, '.00', ''))  
                    + CASE WHEN qs.DisbursedFlag = 'N' THEN ''  
                           ELSE ' ('  
                                + REPLACE(CAST(( qs.DisbursedTotal ) AS VARCHAR(16)),  
                                          '.00', '')  
                                + '  disbursed to client from samples)'  
                      END --as InstructionSummary  
                    + CASE WHEN c2.PON IS NOT NULL  
                           THEN ' ('  
                                + dbo.DecimalToText(REPLACE(qs.PharmacyTotal,  
                                                            '.00', '')) + ') '  
                                + LTRIM(RTRIM(ISNULL(csi.PotencyUnitCodeDescription,  
                                                     '')))  
                           ELSE ''  
                      END  
            FROM    #ClientScriptInstructions csi  
                    JOIN #QuantitySummary qs ON qs.PON = csi.PON  
                                                AND qs.ClientMedicationInstructionId = csi.ClientMedicationInstructionId  
                                                AND qs.Titration = 'Y'  
                                                AND qs.StrengthId = csi.StrengthId  
                    LEFT JOIN @ControlledMedsList c2 ON c2.PON = csi.PON  
            GROUP BY csi.PON ,  
                    qs.InsrtuctionMultipleStrengthGroupId ,  
                    csi.StrengthId ,  
                    csi.TitrationStrengthDescription ,  
                    csi.UnitValueString ,  
                    qs.PharmacyTotal ,  
                    qs.DisbursedFlag ,  
                    qs.DisbursedTotal ,  
                    c2.PON ,  
                    csi.PotencyUnitCodeDescription  
            
    SET @TIString = ''  
 --titration instruction summary logic  
    DECLARE TitrationInst CURSOR  
    FOR  
        SELECT  s.PON ,  
                s.InstructionSummary  
        FROM    @TitrationSummary s  
    OPEN TitrationInst  
    FETCH NEXT FROM TitrationInst INTO @TIPon, @TIString  
    WHILE ( @@fetch_status = 0 )   
        BEGIN  
            UPDATE  csi  
            SET     InstructionSummary = ISNULL(csi.InstructionSummary, '')  
                    + ISNULL(@TIString, '') + CHAR(13) + CHAR(10)  
            FROM    #ClientScriptInstructions csi  
                    JOIN #QuantitySummary qs ON qs.PON = csi.PON  
            WHERE   csi.PON = @TIPon  
            SET @TIString = ''  
            FETCH NEXT FROM TitrationInst INTO @TIPon, @TIString  
        END  
    CLOSE TitrationInst  
    DEALLOCATE TitrationInst  
-- End Titration Logic  
  
  
--Create the Instruction Results for all drugs  
    BEGIN  
        INSERT  INTO #ClientScriptInstructionResults  
                ( ClientMedicationScriptId ,  
                  OrderingMethod ,  
                  CopyType ,  
                  ScriptOrderedDate ,  
                  PON ,  
                  InsrtuctionMultipleStrengthGroupId ,  
                  ClientMedicationInstructionId ,  
                  MedicationName ,
                  DrugPurpose,  
                  InstructionSummary ,  
                  PatientScheduleSummary ,  
                  OrderDate ,  
                  DrugStartDate ,  
                  DrugEndDate ,  
                  Refills ,  
                  DurationDays ,  
                  DAW ,  
                  SpecialInstructions ,  
                  Comments ,
                  OrderStatus ,  
                  Titration ,  
                  Multiples ,  
                  SingleLine ,  
                  PharmacyText ,  
                  PageSort ,  
                  PotencyUnitCodeDescription,
				  DxPurpose    
                )  
--Non Multiples, Non Titrations  
                SELECT DISTINCT  
                        csi.ClientMedicationScriptId ,  
                        csi.OrderingMethod ,  
           csi.CopyType ,  
                        csi.ScriptOrderedDate ,  
                        csi.PON ,  
                        qs.InsrtuctionMultipleStrengthGroupId ,  
                        csi.ClientmedicationInstructionId ,  
                        csi.MedicationName ,  
                        csi.DrugPurpose,
                        csi.InstructionSummary ,  
                        csi.PatientScheduleSummary ,  
                        csi.OrderDate ,  
                        csi.DrugStartDate ,  
                        csi.DrugEndDate ,  
                        REPLACE(qs.Refills, '.00', '') ,  
                        qs.DurationDays ,  
                        csi.DAW , 
                        ISNULL(csi.SpecialInstructions, '') as SpecialInstructions,
                        CASE WHEN ISNULL(csi.Comments, '') <> ''  
                                              AND ISNULL(csi.IncludeCommentOnPrescription,  
                                                         'N') <> 'N'  
                                         THEN  LTRIM(RTRIM(ISNULL(csi.Comments,  
                                                              '')))  
                                         ELSE ''  
                                    END as Comments,  
                        csi.OrderStatus ,  
                        qs.Titration ,  
                        qs.Multiples ,  
                        qs.SingleLine ,  
                        csi.PharmacyText ,  
                        1 AS PageSort ,  
                        csi.PotencyUnitCodeDescription
						,csi.DxPurpose  
                FROM    #ClientScriptInstructions csi  
                        JOIN #QuantitySummary qs ON qs.PON = csi.PON  
                                                    AND csi.ClientmedicationInstructionId = qs.ClientmedicationInstructionId  
                                                    AND qs.SingleLine = 'Y'  
                WHERE   @OrderingMethod NOT IN ( 'X', 'C' )  
                        AND qs.SingleLine = 'Y' --uncommented  
--and @PrintChartCopy = 'N'  
                UNION  
                SELECT DISTINCT  
                        csi.ClientMedicationScriptId ,  
                        'X' AS OrderingMethod ,  
                        'Chart' AS CopyType ,  
                        csi.ScriptOrderedDate ,  
                        csi.PON ,  
                        qs.InsrtuctionMultipleStrengthGroupId ,  
                        csi.ClientmedicationInstructionId ,  
                        csi.MedicationName ,
                        csi.DrugPurpose,  
                        csi.InstructionSummary ,  
                        csi.PatientScheduleSummary ,  
                        csi.OrderDate ,  
                        csi.DrugStartDate ,  
                        csi.DrugEndDate ,  
                        REPLACE(qs.Refills, '.00', '') ,  
                        qs.DurationDays ,  
                        csi.DAW ,  
                        ISNULL(csi.SpecialInstructions, '') as SpecialInstructions,
                        CASE WHEN ISNULL(csi.Comments, '') <> ''  
                                              AND ISNULL(csi.IncludeCommentOnPrescription,  
                                                         'N') <> 'N'  
                                         THEN  LTRIM(RTRIM(ISNULL(csi.Comments,  
                                                              '')))  
                                         ELSE ''  
                                    END as Comments,  
                        csi.OrderStatus ,  
                        qs.Titration ,  
                        qs.Multiples ,  
                        qs.SingleLine ,  
                        csi.PharmacyText ,  
                        1 AS PageSort ,  
                        csi.PotencyUnitCodeDescription 
						,csi.DxPurpose  
                FROM    #ClientScriptInstructions csi  
                        JOIN #QuantitySummary qs ON qs.PON = csi.PON  
                                                    AND csi.ClientmedicationInstructionId = qs.ClientmedicationInstructionId  
                                                    AND qs.SingleLine = 'Y'  
                WHERE   qs.SingleLine = 'Y'  
                        AND @PrintChartCopy = 'Y'  
/**/  
--multiple instructions  
                UNION  
                SELECT DISTINCT  
                        csi.ClientMedicationScriptId ,  
                        csi.OrderingMethod ,  
                        csi.CopyType ,  
                        csi.ScriptOrderedDate ,  
                        csi.PON ,  
                        qs.InsrtuctionMultipleStrengthGroupId ,  
                        qs.InsrtuctionMultipleStrengthGroupId ,  
                        csi.MedicationName ,  
                        csi.DrugPurpose ,
                        csi.InstructionSummary ,  
                        csi.PatientScheduleSummary ,  
                        csi.OrderDate ,  
                        csi.DrugStartDate ,  
                        csi.DrugEndDate ,  
                        REPLACE(qs.Refills, '.00', '') ,  
                        qs.DurationDays ,  
                        csi.DAW ,  
                        ISNULL(csi.SpecialInstructions, '') as SpecialInstructions,
                        CASE WHEN ISNULL(csi.Comments, '') <> ''  
                                              AND ISNULL(csi.IncludeCommentOnPrescription,  
                                                         'N') <> 'N'  
                                         THEN  LTRIM(RTRIM(ISNULL(csi.Comments,  
                                                              '')))  
                                         ELSE ''  
                                    END as Comments,   
                        csi.OrderStatus ,  
                        qs.Titration ,  
                        qs.Multiples ,  
                        qs.SingleLine ,  
                        csi.PharmacyText ,  
                        1 AS PageSort ,  
                        csi.PotencyUnitCodeDescription 
						, csi.DxPurpose  
                FROM    #ClientScriptInstructions csi  
                        JOIN #QuantitySummary qs ON qs.PON = csi.PON  
                                                    AND csi.ClientmedicationInstructionId = qs.ClientmedicationInstructionId  
                                                    AND qs.Multiples = 'Y'  
                WHERE   @OrderingMethod NOT IN ( 'X', 'C' )  
                UNION  
                SELECT DISTINCT  
                        csi.ClientMedicationScriptId ,  
                        'X' AS OrderingMethod ,  
                        'Chart' AS CopyType ,  
                        csi.ScriptOrderedDate ,  
                        csi.PON ,  
                        qs.InsrtuctionMultipleStrengthGroupId ,  
                        qs.InsrtuctionMultipleStrengthGroupId ,  
                        csi.MedicationName ,  
                        csi.DrugPurpose,
                        csi.InstructionSummary ,  
                        csi.PatientScheduleSummary ,  
                        csi.OrderDate ,  
                        csi.DrugStartDate ,  
                        csi.DrugEndDate ,  
                        REPLACE(qs.Refills, '.00', '') ,  
                        qs.DurationDays ,  
                        csi.DAW ,  
                        ISNULL(csi.SpecialInstructions, '') as SpecialInstructions,
                        CASE WHEN ISNULL(csi.Comments, '') <> ''  
                                              AND ISNULL(csi.IncludeCommentOnPrescription,  
                                                         'N') <> 'N'  
                                         THEN  LTRIM(RTRIM(ISNULL(csi.Comments,  
                                                              '')))  
                                         ELSE ''  
                                    END as Comments,   
                        csi.OrderStatus ,  
                        qs.Titration ,  
                        qs.Multiples ,  
                        qs.SingleLine ,  
                        csi.PharmacyText ,  
                        1 AS PageSort ,  
                        csi.PotencyUnitCodeDescription ,
						csi.DxPurpose   
                FROM    #ClientScriptInstructions csi  
                        JOIN #QuantitySummary qs ON qs.PON = csi.PON  
                                                    AND csi.ClientmedicationInstructionId = qs.ClientmedicationInstructionId  
                                                    AND qs.Multiples = 'Y'  
                WHERE   @PrintChartCopy = 'Y'  
--Titrations  
                UNION  
                SELECT DISTINCT  
                        csi.ClientMedicationScriptId ,  
                        csi.OrderingMethod ,  
                        csi.CopyType ,  
                        csi.ScriptOrderedDate ,  
                        csi.PON ,  
                        qs.InsrtuctionMultipleStrengthGroupId ,  
                        qs.InsrtuctionMultipleStrengthGroupId ,  
                        csi.MedicationName ,
                        csi.DrugPurpose,  
                        csi.InstructionSummary ,  
                        csi.PatientScheduleSummary ,  
                        csi.OrderDate ,  
                        ti.TitrationStartDate ,  
                        ti.TitrationEndDate ,  
                        REPLACE(qs.Refills, '.00', '') ,  
                        ti.DurationDays ,  
                        csi.DAW ,  
                        ISNULL(csi.SpecialInstructions, '') as SpecialInstructions,
                        CASE WHEN ISNULL(csi.Comments, '') <> ''  
                                              AND ISNULL(csi.IncludeCommentOnPrescription,  
                                                         'N') <> 'N'  
                                         THEN  LTRIM(RTRIM(ISNULL(csi.Comments,  
                                                              '')))  
                                         ELSE ''  
                                    END as Comments,    
                        csi.OrderStatus ,  
                        qs.Titration ,  
                        qs.Multiples ,  
                        qs.SingleLine ,  
                        NULL , -- ,csi.PharmacyText  
                        0 AS PageSort ,  
                        csi.PotencyUnitCodeDescription ,
						csi.DxPurpose  
                FROM    #ClientScriptInstructions csi  
                        JOIN @TitrationInstructions ti ON ti.PON = csi.PON  
                        JOIN #QuantitySummary qs ON qs.PON = csi.PON  
                                                    AND csi.ClientmedicationInstructionId = qs.ClientmedicationInstructionId  
                                                    AND qs.Titration = 'Y'  
                WHERE   @OrderingMethod NOT IN ( 'X', 'C' )  
                UNION  
                SELECT DISTINCT  
                        csi.ClientMedicationScriptId ,  
                        'X' AS OrderingMethod ,  
                        'Chart' AS CopyType ,  
                        csi.ScriptOrderedDate ,  
                        csi.PON ,  
                        qs.InsrtuctionMultipleStrengthGroupId ,  
                        qs.InsrtuctionMultipleStrengthGroupId ,  
                        csi.MedicationName ,  
                        csi.DrugPurpose,
                        csi.InstructionSummary ,  
                        csi.PatientScheduleSummary ,  
                        csi.OrderDate ,  
                        ti.TitrationStartDate ,  
                        ti.TitrationEndDate ,  
                        REPLACE(qs.Refills, '.00', '') ,  
                        ti.DurationDays ,  
                        csi.DAW ,  
                        ISNULL(csi.SpecialInstructions, '') as SpecialInstructions,
                        CASE WHEN ISNULL(csi.Comments, '') <> ''  
                                              AND ISNULL(csi.IncludeCommentOnPrescription,  
                                                         'N') <> 'N'  
                                         THEN  LTRIM(RTRIM(ISNULL(csi.Comments,  
                                                              '')))  
                                         ELSE ''  
                                    END as Comments,  
                        csi.OrderStatus ,  
                        qs.Titration ,  
                        qs.Multiples ,  
                        qs.SingleLine ,  
                        NULL ,  
                        1 AS PageSort ,  
                        csi.PotencyUnitCodeDescription 
						,csi.DxPurpose   
                FROM    #ClientScriptInstructions csi  
                        JOIN @TitrationInstructions ti ON ti.PON = csi.PON  
                        JOIN #QuantitySummary qs ON qs.PON = csi.PON  
                                                    AND csi.ClientmedicationInstructionId = qs.ClientmedicationInstructionId  
                                                    AND qs.Titration = 'Y'  
                WHERE   @PrintChartCopy = 'Y'  
--order by csi.ClientMedicationScriptId, csi.PON, CopyType  
    END  
  
    UPDATE  a  
    SET     OrderingMethod = @OrderingMethod  
    FROM    #ClientScriptInstructionResults AS a  
    WHERE   a.OrderingMethod <> 'X'  
  
    BEGIN  
--this is the dataset  
--Add Messages to script  
        DECLARE @Message1 VARCHAR(MAX) ,  
            @Message2 VARCHAR(MAX)  
  
--DO not fill c2 meds before DrugStartDate  
--if exists (  
--   select *  
-- from #ClientScriptInstructionResults  
--   where  @C2Meds = 'Y'  
--   and OrderDate < DrugStartDate  
--)  
        IF EXISTS ( SELECT  MIN(DrugStartDate)  
                    FROM    #ClientScriptInstructionResults  
                    WHERE   @C2Meds = 'Y'  
                    GROUP BY ClientMedicationScriptId  
                    HAVING  MAX(OrderDate) < MIN(DrugStartDate) )   
            BEGIN  
                SELECT  @Message1 = 'DO NOT FILL BEFORE: '  
                        + CONVERT(VARCHAR(12), MIN(a.DrugStartDate), 101)  
                FROM    #ClientScriptInstructionResults a  
                        JOIN @C2MedsList b ON b.PON = a.PON  
                WHERE   a.OrderDate < a.DrugStartDate  
                GROUP BY a.ClientMedicationScriptId ,  
                        a.PON  
            END  
  
-- setup page numbers  
        DECLARE @maxScriptsPerPage INT ,  
            @maxInstructionsPerPage INT  
        SET @maxScriptsPerPage = 2  
        SET @maxInstructionsPerPage = 6  
  
        DECLARE @currPageNumber INT ,  
            @currScriptId INT ,  
            @currNumberOfInstructions INT ,  
            @currNumberOfScripts INT  
  
        SET @currPageNumber = 0  
        SET @currNumberOfInstructions = 0  
        SET @currNumberOfScripts = 0  
  
        DECLARE @currCharIndex INT  
  
        DECLARE @cScriptId INT ,  
            @cOrderingMethod VARCHAR(5) ,  
            @cPON VARCHAR(MAX) ,  
            @cInsrtuctionMultipleStrengthGroupId INT ,  
            @cNumInstructions INT ,  
            @PatientScheduleSummary VARCHAR(MAX) ,  
            @cC2Med CHAR(1) ,  
            @MedName VARCHAR(MAX)  
  
        DECLARE cPageNumbering INSENSITIVE CURSOR  
        FOR  
            SELECT DISTINCT  
                    b.ClientMedicationScriptId ,  
                    b.OrderingMethod ,  
                    b.PON ,  
                    b.InsrtuctionMultipleStrengthGroupId ,  
                    b.PatientScheduleSummary ,  
                    CASE WHEN c.PON IS NOT  NULL THEN 'Y'  
                         ELSE 'N'  
                    END ,  
                    b.MedicationName  
            FROM    #ClientScriptInstructionResults AS b  
                    LEFT JOIN @C2MedsList c ON c.PON = b.PON  
--added left join to determine c2 med srf 9/10/2010  
ORDER BY            b.MedicationName ,  
                    b.ClientMedicationScriptId ,  
                    b.OrderingMethod ,  
                    b.PON ,  
                    b.InsrtuctionMultipleStrengthGroupId  
  
        OPEN cPageNumbering  
  
  
        FETCH cPageNumbering INTO @cScriptId, @cOrderingMethod, @cPON,  
            @cInsrtuctionMultipleStrengthGroupId, @PatientScheduleSummary,  
            @cC2Med, @MedName  
        WHILE @@fetch_status = 0   
            BEGIN  
  
                SET @cNumInstructions = 1  
  
  
                SET @currCharIndex = 0  
                WHILE CHARINDEX(CHAR(13), @PatientScheduleSummary,  
                                @currCharIndex + 1) > 0   
                    BEGIN  
                        SET @cNumInstructions = @cNumInstructions + 1  
                        SET @currCharIndex = CHARINDEX(CHAR(13),  
                                                       @PatientScheduleSummary,  
                                                       @currCharIndex + 1)  
                    END  
     
                IF @cNumInstructions > 1   
                    SET @cNumInstructions = @cNumInstructions - 1   -- trailing newline removal  
                SET @currNumberOfInstructions = @currNumberOfInstructions  
                    + @cNumInstructions  
                SET @currNumberOfScripts = @currNumberOfScripts + 1  
  
         
                IF ( @currNumberOfScripts > @maxScriptsPerPage )  
                    OR ( @currNumberOfInstructions > @maxInstructionsPerPage )  
                    OR ( @cC2Med = 'Y' )   
                    BEGIN  
        
                        SET @currPageNumber = @currPageNumber + 1  
                        SET @currNumberOfInstructions = 0  
                        SET @currNumberOfScripts = 0  
  
                    END  
  
                UPDATE  #ClientScriptInstructionResults  
                SET     PageNumber = @currPageNumber  
                WHERE   ClientMedicationScriptId = @cScriptId  
                        AND OrderingMethod = @cOrderingMethod  
                        AND PON = @cPON  
                        AND InsrtuctionMultipleStrengthGroupId = @cInsrtuctionMultipleStrengthGroupId  
  
                FETCH cPageNumbering INTO @cScriptId, @cOrderingMethod, @cPON,  
                    @cInsrtuctionMultipleStrengthGroupId,  
                    @PatientScheduleSummary, @cC2Med, @MedName  
            END  
  
        CLOSE cPageNumbering  
  
        DEALLOCATE cPageNumbering  
        
        DECLARE @Logo VARCHAR(20)
        If EXISTS(SELECT 1 FROM RecodeCategories WHERE CategoryCode = 'XHighlandSpringsRxLogo')
		BEGIN
			SET @Logo = 'Valley'
	  
			 IF @OriginalData > 0 
			  BEGIN 
				  SELECT @Logo = 'HighLand' 
				  FROM   ClientMedicationScripts CMS 
						 JOIN Recodes R 
						   ON CMS.LocationId = R.IntegerCodeId 
						 JOIN RecodeCategories RC 
						   ON R.RecodeCategoryId = RC.RecodeCategoryId 
				  WHERE  CMS.ClientMedicationScriptId = @ClientMedicationScriptIds 
						 AND RC.CategoryCode = 'XHighlandSpringsRxLogo' 
						 AND ISNULL(R.RecordDeleted, 'N') = 'N' 
						 AND ISNULL(RC.RecordDeleted, 'N') = 'N' 
			  END 
			ELSE 
			  BEGIN 
				  SELECT @Logo = 'HighLand' 
				  FROM   ClientMedicationScriptsPreview CMSP 
						 JOIN Recodes R 
						   ON CMSP.LocationId = R.IntegerCodeId 
						 JOIN RecodeCategories RC 
						   ON R.RecodeCategoryId = RC.RecodeCategoryId 
				  WHERE  CMSP.ClientMedicationScriptId = @ClientMedicationScriptIds 
						 AND RC.CategoryCode = 'XHighlandSpringsRxLogo' 
						 AND ISNULL(R.RecordDeleted, 'N') = 'N' 
						 AND ISNULL(RC.RecordDeleted, 'N') = 'N' 
			  END 
		END
		
        SELECT  h.OrganizationName ,  
                h.ClientMedicationScriptId ,  
                m.OrderingMethod ,  
                m.CopyType ,  
                m.PON ,  
                m.InsrtuctionMultipleStrengthGroupId ,  
                h.AllergyList ,  
                m.DrugPurpose as ICD10List,
                h.ClientId ,  
                h.ClientName ,  
                h.ClientAddress ,  
                CASE WHEN h.ClientHomePhone <> '             '  
					THEN  (SELECT dbo.ssf_GetGlobalCodeNameById(@PhoneNumberType) + ': ' + h.ClientHomePhone) 
					ELSE '' END AS ClientHomePhone,  
                h.ClientDOB ,  
                h.LocationAddress ,  
                h.LocationName ,  
                h.LocationPhone ,  
                h.LocationFax ,  
                h.PharmacyName ,  
                h.PharmacyAddress ,  
                h.PharmacyPhone ,  
                h.PharmacyFax ,  
                m.ClientMedicationInstructionId ,  
                m.ScriptOrderedDate ,  
                m.MedicationName ,  
                m.InstructionSummary , 
                m.PatientScheduleSummary ,  
                m.OrderDate ,  
                m.DrugStartDate ,  
                m.DrugEndDate ,  
                REPLACE(m.Refills  
                        + CASE WHEN SureScriptsRefillRequestId > 0 THEN 1  
                               ELSE 0  
                          END, '.00', '') AS Refills ,  
                m.DurationDays ,  
                m.DAW ,  
                m.SpecialInstructions ,  
                m.Comments ,
                m.OrderStatus ,  
                m.Titration ,  
                m.Multiples ,  
                m.SingleLine ,  
                s.PrescriberId ,  
                case when @LicenseNumber Is Not Null then  s.Prescriber +'  ,SubOxone#: ' +  @LicenseNumber
                  else s.Prescriber
                  end as Prescriber,   
				s.Supervisor,
                s.Creator ,  
                s.CreatedBy ,  
                s.SignatureFacsimile ,  
                s.PrintDrugInformation ,  
                @OriginalData AS OrigninalData ,  
                @PrintChartCopy AS PrintChartCopy ,  
                @C2Meds AS C2Meds ,  
                @Message1 AS Message1 ,  
                --@Message2 AS Message2 ,  
                CASE WHEN h.RxReferenceNumber <> ''  
                     THEN 'This is a response for an electronic refill request for a controlled substance, RXReference: ('  
                          + RTRIM(LTRIM(h.RxReferenceNumber)) + ')'  
                     ELSE ''  
                END AS Message2 ,  
                @ShowCoverLetter AS ShowCoverLetter ,  
                @FaxFlag AS FaxFlag ,  
                @PharmacyCoverLetters AS PharmacyCoverLetters ,  
                @OhioBoardCertDate AS OhioBoardCertDate ,  
                SureScriptsRefillRequestId ,  
                CASE WHEN ISNULL(m.PharmacyText, '')<>'' THEN '** ' + m.PharmacyText+
                + CASE WHEN ISNULL(m.PharmacyText, '') <> ''  
                       THEN ' '  
                            + CASE WHEN LOWER(m.PotencyUnitCodeDescription) = 'unspecified'  
                                   THEN ''  
--Vithobha	- 19/Nov/2015	- added isnull check for potency so quantity doesn't get wiped when potency can't be mapped.
                                   ELSE ISNULL(m.PotencyUnitCodeDescription, '')
                              END  
                                 -- Added Logic for showing Quantity in words
                              + CASE WHEN isnumeric( m.PharmacyText) = 1 THEN
                               '( ' + dbo.fnNumberToWords (m.PharmacyText)+' )' 
                               ELSE '( ' + m.PharmacyText + ' )' 
                               end
                       ELSE ''  
                  END +' **' 
                  ELSE '' END AS SpecialSummary ,  
                m.PageNumber,
                Case When ISNULL(@VerbalOrderReadBack,'N') = 'Y' 
					 then '(Verbal Order Read Back)'  else  '' 
                end as VerbalOrderReadBack   
                ,@Logo as Logo
				,ISNULL(@PharmacyId,0) AS PharmacyId
				,m.DxPurpose
        FROM    #ScriptHeader h  
                JOIN #ClientScriptInstructionResults m ON m.ClientMedicationScriptId = h.ClientMedicationScriptId  
                JOIN #ScriptSignatures s ON s.ClientMedicationScriptId = h.ClientMedicationScriptId  
        ORDER BY m.PageNumber ,  
                m.MedicationName ,  
                h.ClientMedicationScriptId ,  
                m.OrderingMethod ,  
                m.PON ,  
                m.InsrtuctionMultipleStrengthGroupId ,  
                m.ClientmedicationInstructionId ,  
                PageSort  
    END  
  
  
    DROP TABLE #ClientScriptInstructions  
    DROP TABLE #ClientScriptInstructionResults  
    DROP TABLE #QuantitySummary  
    DROP TABLE #ScriptHeader  
    DROP TABLE #ScriptSignatures  
END  
  
GO




