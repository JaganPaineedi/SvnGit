If Exists (Select * From   sys.Objects 
          Where  Object_Id = Object_Id(N'dbo.ssp_PMClaims837Professional') 
                 And Type In ( N'P', N'PC' )) 
Drop Procedure dbo.ssp_PMClaims837Professional
Go



CREATE PROCEDURE [dbo].[ssp_PMClaims837Professional]
    @CurrentUser VARCHAR(30) ,
    @ClaimBatchId INT
AS /********************************************************************************  
-- Stored Procedure: dbo.ssp_PMClaims837Professional   
--  
-- Copyright: 2006 Streamline Healthcate Solutions  
--  
-- Purpose: Generates electronic claims  
--  
-- Updates:                                                         
-- Date			Author		Purpose  
-- 10.20.2006	JHB			Created  
-- 12.03.2007	SFarber		Modified to handle clients with multiple home addresses and phones  
-- 08.11.2011	SFarber		Modified to remove subscriber address is patient is not a subscriber  
-- 09.27.2011	dharvey		Added condition for EndDateOfService when ProcedureCodes.EndDateEqualsStartDate='Y'  
-- 11.18.2011	SFarber		Removed hardcoded last 4 digits of the Billing Provider zip code  
-- 12.01.2011	SFarber		Modified to not send SBR04 if SBR03 is available.  
-- 12.16.2011	SFarber		Modified to pad zip codes with '9999'  
-- 01.03.2012	Sferenz		Modified Paymentzip to varchar(9)  
-- 01.05.2012	sferenz		Modified CTP segment to show if DrugCodeUnitCount value is not null  
-- 07.13.2012	avoss		added addtional diagnoses to #charges table  
-- 10.12.2012	MSuma		added CLientwasPresent to   #ClaimLines_temp
-- 06.11.2013	dknewtson	added a replace statement around all zip codes pulled from main tables to handle dashes before padding with '9999'
-- 07.11.2013	dknewtson	added a couple of RecordDeleted Checks and modified the insert into #837HeaderTrailer 
-- 08.08.2013	dknewtson	Uncommented other insured loop and repaired Cursor logic.
-- 03/17/2014	NJain		Combined this with ssp_PMClaims837ProfessionalVersion5.
-- 07/07/2014	NJain		Combined 837P and HCFA1500
-- 07/08/2014	NJain		Added scsps for Combine Charges, Other Insured and Diagnosis Code calculation
-- 07/10/2014	NJain		Added the new logic for grouping claims, using the CoveragePlanClaimGroupingCriteria table
-- 07/15/2014	NJain		Added logic for Voids & Rebills
-- 08/08/2014	NJain		Updated data types for BillingProviderIdGroup and RenderingProviderIdGroup fields to VARCHAR(35)	
-- 10/15/2014	NJain		Updated logic for Registration and Discharge Dates from Client Episodes			
-- 09-OCT-2014	Akwinass	Removed ''DiagnosisCode1,DiagnosisCode2,DiagnosisCode3'' from #Charges	Table and Inserting Diagnosis into #ClaimLines Table Logic is modified for based on ServiceDiagnosis Table (Task #134 in Engineering Improvement Initiatives- NBL(I))	
-- 25-Nov-2014 SuryaBalan   Handled Parentheses in phone numbers from Agency Table for Task #686 CoreBugs-Billing contact in 837 process is not removing punctuation  		
-- 12/16/2014	NJain		Updated to read Element and Segment terminators from ClaimFormats table.
-- 01/15/2015	NJain		Updated DaignosisCode logic
-- 01/21/2015	NJain		Updated DiagnosisCode logic
-- 01/28/2015	NJain		Updated #ClaimLines logic before executing get billing codes to add CoveragePlanId
-- 06/24/2015	NJain		Added K3 Segment, Macon City Consolidated Systems Analyst Projects #28
-- 07/01/2015	Dknewtson	Adding REF*NF Segment for Loop 2010BB for Magellan BCBSM Value Options
-- 07/20/2015	NJain		Added NTE Segment
-- 07/22/2015	NJain		Updated to use Allowed Amounts when required by the plan
-- 08/04/2015	NJain		Updated to get Plan Name from CoveragePlans for the NM1 40 segment
-- 08/25/2015	NJain		Moved temp table creation logic out of scsp loops
-- 08/27/2015	NJain		Updated to only populate Client info as insured info in #Charges when Client Is Subscriber is checked
-- 09/15/2015	TRemisoski	Commiting ICD10 Changes from Tom - njain
-- 09/16/2015   Dknewtson   Including Loop 2420C Service Facility funcationality (default to NULL) at Service Hierarchical level for CEI Task #62
-- 09/17/2015	TRemisoski	EndDateOfService calculation fixed for services when UnitType = 112
-- 09/18/2015	TRemisoski	Optimization for CTE that selects "new" claimlines
-- 09/21/2015	NJain		Added Billing Provider Taxonomy segment MFS Set Up #7
-- 09/22/2015	TRemisoski	Changed insert into #837Service to only populate diagnosis pointers 1-4
-- 09/24/2015   SFarber     Moved code that calculates billing code and units before expected payment/adjustment calculation
-- 09/29/2015	NJain		Updated to not send Agency Tax Id in Rendering NPI field
-- 09/30/2015	NJain		Added RecordDeleted check on ServiceDiagnosis
-- 10/01/2015   Dknewtson   Modified to remove SSN when the value is '999999999'
-- 10/01/2015   SFarber     Added call to scsp_PMClaims837PreCombineCharges
-- 10/02/2015	NJain		Added Place Of Service Override logic
-- 10/09/2015	NJain		Changed insert into #837BillingProviders to Group By BillingProviderNPI instead of BillingProviderId
-- 10/29/2015	NJain		Added CN1Segment for Valley
-- 10/30/2015	NJain		Added BillingCodeDescription for SV1 segment for Valley
-- 11/17/2015	NJain		Added Filed21ICDIndicator for Paper Claims
-- 11/18/2015	NJain		Updated to populate Field17ReferringName in ClaimNPIHCFA1500s
							Added logic to split claims for pre and post 10/1 servies
-- 11/30/2015   Dknewtson   Removed requirement for FacilityID and FacilityIDQualifier for FacilityNM1 Segment N3 Segment and N4 segment. 
--                          added logic to remove the billing provider id and qualifier elements if the qualifier is null
-- 12/4/2015    Dknewtson   Added a check to prevent reprocessing if the claim batch is billed
-- 12/10/2015   Dknewtson   Included Client Payed amount in claims grouping to carry forward to claim lines.
-- 12/11/2015	NJain		Added Claim Line Bundling logic       
							Changed ClaimUnits TO DECIMAL(9,2) FROM INT         
-- 12/14/2015	NJain		Changed ssp_PMClaimsUpdateClaimsTables to ssp_PMClaimsUpdateClaimsTablesNew for updating Claims tables	
-- 12/15/2015	NJain		Added #837OtherInsuredsGrouping table to get correct count of segments and modified logic to get SVD segments specific to claim line							Moved ClaimUnits to SVD05 instead of SVD04. Per HIPAA guide, SVD04 is not used				
-- 1/13/2015   Dknewtson    Removed unused elements from NM1*87 segment Pay To Provider per implementation guide.
-- 1/20/2016	NJain		Added condition to only look at negative amounts for ledger type of 4204 in #OtherInsuredAdjustment
							Added BillingCode AND Modifiers fields FOR HCFA grouping in #ClaimGroups TABLE
							Moved creation of temp tables outside the override scsp LOOP FOR HCFA GROUPING
							WHEN Inserting INTO #ClaimGroups changed COUNT(*) TO COUNT(DISTINCT ClaimLineId)
-- 3/11/2016	NJain		Fixed issue with NTE Segment generating in the wrong location							
-- 3/13/2016    TRemisoski  Moved if for #837Service output to original location (1-line code change)							
-- 3/13/2016    TRemisoski  Added support for CLIA Reference number (Medicare standard).
-- 3/23/2016    Dknewtson   Providing Functionality to remove billing providerid where required.
-- 3/23/2016   Dknewtson    Performance Improvements: Replaced CTE with Temp tables - Reduced calls to the string filter and updatetext by concatenating segment for a given loop prior to update.
-- 3/29/2016	NJain		Added @seg17 in the beginning for Services data
-- 3/29/2016	NJain		Updated to accommodate upto 4 characters after the decimal in ICD 10 Code on Paper Claims
							#610 - Pines Support
-- 4/11/2016   Dknewtson    Corrected Diagnosis code calculation for bundled claims.
-- 6/7/2016	   njain		Removed allowed amount calculation logic, this needs to happen through the overnight process
							Added PayToProviderTaxId COLUMN TO #837BillingProviders (TO MATCH 837 I ssp)                             
-- JUN-29-2016 Dknewtson	Fixed Payer Claim Control Number Grouping
-- 7/7/2016	   NJain		Updated to exclude client charges from #OtherInsured tables where the Client Balance is 0 and there is a copy transfer from primary to Client to Secondary
-- 7/28/2016   Dknewtson	Checking record deleted on void batches when checking if claim line items have been voided.
-- 7/28/2016   Dknewtson	Including Charges in ClaimBatchCharges when the claim line item is picked up by voids to ensure Billing history is updated properly.
-- 9/21/2016   Dknewtson	Storing Claim Data for Void Batches, including code to use data when creating void claims (Both Paper and Electronic)
-- 10/7/2016   njain		Added fields for Attending First and Last Name to match 837 I	
-- 10/17/2016  Dknewtson	Updated to support 'U' unknown sex when specified per implementation guide.                     
-- 10/18/2016  Dknewtson	Reverting changes from Nimesh for Attending.
-- 10/19/2016  Dknewtson	Increasing LineItemControlNumber column in #837Services to Varchar(50) (Just in case)
-- 10/26/2016  TRemisoski   Bug fix for CMS1500 printing of charge amounts that exceed 2 decimal places.
-- 11/06/2016  TRemisoski   Default insurance type code to '47' for medicare other insured only if medicare is secondary.
-- 12/05/2016  MJensen		Moved EmergencyIndicator from SV108 to SV109.  
-- 12/11/2016  TRemisoski   Set #ClaimLines.EndDateOfService based on whether the SCSP has been called or not.  Woods SGL #412
-- 12/22/2016  GSelvamani   Assigned Parameters to Internal variables to avoid Parameter Sniffing Issues - ARC Support Go Live #106
-- 1/11/2017   Dknewtson    Removed "DeletedCharges" reference. Adding system configuration to allow subscriber grouping by provider commercial number for keystone - SGL #57
-- 1/17/2017   Dknewtson	Updated check for PCN - only erroring the charge if there are no payer claim control numbers available for any billed claim line item.
							replaced join to #ClaimLines on chargeid to ChargeErrors with join to ClaimBatchCharges. Voids don't neccesarily have specific chargeids.
-- 1/23/2017   Dknewtson	also replacing "7" if the previously sent claim is a replacement claim.
-- 2/28/2017   Dknewtson    Allowing claims to be sent through the old method if no data exist in the claimlineitemgroupstoreddata table.
-- 3/3/2017	   NJain		Updated to not send PCS codes. DELETE FROM #ServiceDiagnosis where ICD10CodeType = PCS	
-- 3/8/2017    Dknewtson    Implementing Superivising loop as a custom only segment.
-- 4/7/2017	   NJain		Implementing EII #513. Coverage Plan Rule for "For these procedures, calculate Billing Code & Units after combining same day services". 
							(Ignore Clinician When Bundling) -- Rule = 4277
							Use #ProcedureCodesToBundleAfterCombiningSameDayServices
-- 4/21/2017   NJain		Implementing second rule for EII #513. 	Coverage Plan Rule for "For these procedures, calculate Billing Code & Units after combining same day services".							(Consider Clinician When Bundling) -- Rule = 4278			
							Use #ProcedureCodesToBundleAfterCombiningSameDayServices		
-- 5/9/2017	   Dknewtson	Including the ability to bundle by supervising IDs, Harbor Support 797	
-- 5/23/2017   Dknewtson	Need to pull the payer claim control number through ERClaimLineItemCharges if it's available.
-- 5/26/2017   NJain		Updated to use PlaceofServiceCode instead of PlaceofService when bundling Charges into ClaimLines. Same PlaceofServiceCode can have different										PlaceofService values. MFS SGL #119
-- 5/31/2017   MJensen		Correct billing codes for #otherInsured - Harbor task #797
-- 6/23/2017   Dknewtson	Clients may have different addresses based on date of service. Must send seperate subscriber segment ids in this case. Keystone #42
-- 6/27/2017   Dknewtson	Use Client address history based on system configuration key 837UseClientAddressHistory keystone #42
-- 9/11/2017   NJain		Updated to include MedicalRecordNumber for REF EA segment in all temp tables and in the 837. Updating to #Charges table should work 
-- 10/25/2017  NJain		Updated to Bundle Add on Services in the same claim as the primary service when Auto Bundle is checked on the plan. EII #587
-- 10/31/2017  NJain		Implementing Rule #4279 to remove modifiers when specified - Journey Customizations #1200
-- 11/16/2017  MJensen		Round HCFA charges before totalling.  Harbor support #1455.
-- 11/17/2017  NJain		Updated #4279 rule to left join to CoveragePlanRuleVariables table. If All Procedures are selected, this table is not populated - Journey Customizations #1200
-- 11/20/2017  NJain		Updated to do DISTINCT inserts into #OtherInsuredAdjustment. Also updated LEFT JOIN to GlobalCodes to JOIN Woods SGL #757
-- 12/1/2017   Dknewtson	Modified Other Insured logic to remove "subtract charge amount for secondary payers" "if there is a subsequent payer set PR to 0" "If there is a subsequent payer subtract" 
							and replaced with automaticly including an OA-23 to balance secondary other insureds for tertiary billing. Aspen Pointe - Support Go Live 618
-- 01/11/2018 	Msood	Commented the code to check DSMCode or b.ICD9Code Not Null condition in Service Diagnoses table Using b.ICD10Code 
-- 				Why: 	Spring River-Support Go Live Task#93
-- 01/30/2018	NJain		Updated to only insert the MaxClaimLineIds from #Claims table into #837SubscriberClients table. Inserting other ClaimLineIds generates extraneous SBR segments. Thresholds Support #1199
-- 02/05/2018	TRemisoski	CAS3Segment was counted twice for segment count causing segment count mismatch.  Changed second CAS3Segment reference to CAS4Segment.  Harbor Support #1594.
-- 02/07/2018   Dknewtson	Updated code to remove pay to provider information to look at the address and not the ProviderIds for these. Also commented out REF segments as these are not included in the implementation specification
							Spring River - Support Go Live 101.2
-- 03/13/2018   Dknewtson	Pay To Provider Zip must match Billing provider Zip, correcting insert. Key Point Support Go Live 1138
-- 03/14/2018	NJain		Adding order by when inserting into #837Services table. Boundless Support #187
-- 03/20/2018   Dknewtson	Grouping Other Insureds and summing their payments by claim since this is reported on the claim level and AMT02 loop 2320 must be the sum of all SVD02 on the claim lines for the claim. Before we were GROUPING without summing.
							A Renewed Mind - Support #835
-- 03/23/2018   Dknewtson   Moving CLIA Reference number to the correct position and making sure it updates to the #ClaimLines table. Valley - Enhancements #17
-- 04/24/2018   Dknewtson   Added RenderingProviderNPI and SupervisingProvider2310DID to grouping criteria
-- 05/16/2018   Dknewtson   Adding code to pull from the ERClaimLineItem associated with the voided claim line item when the ERClaimLineItemCharges records don't exist. MFS - Support Go Live 381
-- 06/01/2018	dknewtson	Updated procedure codes to calculate billing code/claim units after combining same day service logic to look at all values in the ClaimLine table that were grouped when updating the #Charges and #Groups table with the calculated billing codes.
							Harbor - Support 1676
-- 06/11/2018  Dknewtson    Setting @FormatType to 'P' in all cases. No reason not to. AC - Support Go Live 103
-- 07/05/2018	dknewtson   Added code to group by procedure rate degree group name Harbor - Support Go Live 1676
-- 07/16/2018 Dknewtson		Added time of service as a grouping option for F&CS since time is sent on their claims in the NTE Segment. Family & Children's Services - Support Go Live #305
-- 07/17/2018	MJensen		Add replacement claim info on paper claims.  Philhaven Support #337
-- 07/17/2018	Vsinha		If the OverrideClaim for client coverage plan is checked then address will display from client plans else the address will display from cverage plan on paper claims.  AspenPointe - Support Go Live #791
-- 09/05/2018   GSelvamani  What - Updated GroupNumber field length from varchar(25) to varchar(30)
							Why - CCC Implementation #17120
-- 08/31/2018	tchen		What: Added 'RenderingProvider' segments for #837Services --copied from the logic from the #837Claims' 'RenderingProvider' segments with some modifications
							Why: CCC - Environmental Issues #92
-- 09/10/2018	tchen		What: Added the default logic for DateOfService grouping to group on the DATE part of the DateOfService when there is no CoveragePlanGroupingCriteria matched
							Why: CCC - Environmental Issues #92
-- 09/17/2018   SFarber     Modified to use diagnosis order when calculating ranking in #ClaimDiagnosisRank
-- 10/08/2018	MJensen		(4/23/2018) Modified rendering provider to allow non-person entities on pass-thru claims.	CEI Enhancements #364
-- 20 Sep 2018 Dknewtson		Going through DocumentMoves table to find charges marked to be corrected. Philhaven - Support #337.1
-- 09/12/2018  Robert Caffrey - Added Other Insured Address Information for Electronic Claims - AC Support #77
--11/2/2018		Rega		-Removed Subscriber SSN segment from all claims - Aurora SGL #29
--11/20/2018    Sanjay      What: Added the scsp_PMClaims837UpdateBundleInfo to add custom logic to claim bundling.
                            Why: Childrens Services Center-Customizations 12 
-- 11/29/2018	tchen		What: added the Loop 2420E for Ordering Provider
							Why: Unison - Customizations #500.03
-- 11/30/2018	tchen		What: Modified PaymentAddress1 to be VARCHAR(55)
							Why: ViaQuest - Implementation #5100
-- 11/30/2018	tchen		What: Changed the insert for #837Claims fields RenderingSecondaryQualifier2 and RenderingSecondaryId2 to NULL
							Why: ViaQuest - Implementation #5100
-- 11/26/2018	vsinha		If the OverrideClaim for client coverage plan is checked then address and ElectronicClaimsPayerId will display from client plans else the address will display from cverage plan on paper claims.  Westbridge-Customizations #3

-- 02/04/2018   Dknewtson   Adding code to prevent grouping and bundling when priority is different. - Journey SGL 326
-- 02/18/2018   Dknewtson   Excluding the OA-23 adjustment on secondaries unless the amount to be sent is positive. - Journey SGL 326
*********************************************************************************/


    SET ANSI_WARNINGS OFF 
    SET NOCOUNT ON
    DECLARE @ParamClaimBatchId INT
    DECLARE @ParamCurrentUser VARCHAR(30)  
    SET @ParamClaimBatchId = @ClaimBatchId
    SET @ParamCurrentUser = @CurrentUser

    DECLARE @ICD10StartDate DATETIME
	
    IF 0 = ( SELECT COUNT(*)
             FROM   dbo.ClaimBatches AS cb
             WHERE  cb.ClaimBatchId = @ParamClaimBatchId
                    AND cb.CoveragePlanId IS NOT NULL
           )
        BEGIN
            SELECT  @ICD10StartDate = MIN(cp.ICD10StartDate)
            FROM    dbo.CoveragePlans AS cp
                    JOIN dbo.ClaimBatches AS cb ON cb.PayerId = cp.PayerId
            WHERE   cb.ClaimBatchId = @ParamClaimBatchId
        END
    ELSE
        BEGIN
            SELECT  @ICD10StartDate = cp.ICD10StartDate
            FROM    dbo.CoveragePlans AS cp
                    JOIN dbo.ClaimBatches AS cb ON cb.CoveragePlanId = cp.CoveragePlanId
            WHERE   cb.ClaimBatchId = @ParamClaimBatchId
        END


--Updating the ClaimBatch Status to Selected, in case status is ProcessLAter
    UPDATE  a
    SET     a.Status = 4521
    FROM    dbo.ClaimBatches a
    WHERE   a.ClaimBatchId = @ParamClaimBatchId
            AND a.Status = 4525



    CREATE TABLE #Charges
        (
          ClaimLineId INT NULL ,
          ChargeId INT NOT NULL ,
          ClientId INT NULL ,
          ClientLastName VARCHAR(30) NULL ,
          ClientFirstname VARCHAR(20) NULL ,
          ClientMiddleName VARCHAR(20) NULL ,
          ClientSSN CHAR(11) NULL ,
          ClientSuffix VARCHAR(10) NULL ,
          ClientAddress1 VARCHAR(30) NULL ,
          ClientAddress2 VARCHAR(30) NULL ,
          ClientCity VARCHAR(30) NULL ,
          ClientState CHAR(2) NULL ,
          ClientZip CHAR(25) NULL ,
          ClientHomePhone CHAR(10) NULL ,
          ClientDOB DATETIME NULL ,
          ClientSex CHAR(1) NULL ,
          ClientIsSubscriber CHAR(1) NULL ,
          SubscriberContactId INT NULL ,
          StudentStatus INT NULL ,
          MaritalStatus INT NULL ,
          EmploymentStatus INT NULL ,
          EmploymentRelated CHAR(1) NULL ,
          AutoRelated CHAR(1) NULL ,
          OtherAccidentRelated CHAR(1) NULL ,
          RegistrationDate DATETIME NULL ,
          DischargeDate DATETIME NULL ,
          RelatedHospitalAdmitDate DATETIME NULL ,
          ClientCoveragePlanId INT NULL ,
          InsuredId VARCHAR(25) NULL ,
          GroupNumber VARCHAR(30) NULL ,
          GroupName VARCHAR(100) NULL ,
          InsuredLastName VARCHAR(30) NULL ,
          InsuredFirstName VARCHAR(20) NULL ,
          InsuredMiddleName VARCHAR(20) NULL ,
          InsuredSuffix VARCHAR(10) NULL ,
          InsuredRelation INT NULL ,
          InsuredRelationCode VARCHAR(20) NULL ,
          InsuredAddress1 VARCHAR(30) NULL ,
          InsuredAddress2 VARCHAR(30) NULL ,
          InsuredCity VARCHAR(30) NULL ,
          InsuredState CHAR(2) NULL ,
          InsuredZip VARCHAR(25) NULL ,
          InsuredHomePhone CHAR(10) NULL ,
          InsuredSex CHAR(1) NULL ,
          InsuredSSN VARCHAR(9) NULL ,
          InsuredDOB DATETIME NULL ,
          ServiceId INT NULL ,
          GroupServiceId INT NULL ,
          GroupId INT NULL ,
          DateOfService DATETIME NULL ,
          EndDateOfService DATETIME NULL ,
          ProcedureCodeId INT NULL ,
          ServiceUnits DECIMAL(7, 2) NULL ,
          ServiceUnitType INT NULL ,
          ProgramId INT NULL ,
          LocationId INT NULL ,
          PlaceOfService INT NULL ,
          PlaceOfServiceCode CHAR(2) NULL ,
          TypeOfServiceCode CHAR(2) NULL ,
          DiagnosisQualifier1 VARCHAR(3) NULL ,
          DiagnosisQualifier2 VARCHAR(3) NULL ,
          DiagnosisQualifier3 VARCHAR(3) NULL ,
          DiagnosisQualifier4 VARCHAR(3) NULL ,
          DiagnosisQualifier5 VARCHAR(3) NULL ,
          DiagnosisQualifier6 VARCHAR(3) NULL ,
          DiagnosisQualifier7 VARCHAR(3) NULL ,
          DiagnosisQualifier8 VARCHAR(3) NULL ,
          DiagnosisCode1 VARCHAR(20) NULL ,
          DiagnosisCode2 VARCHAR(20) NULL ,
          DiagnosisCode3 VARCHAR(20) NULL ,
          DiagnosisCode4 VARCHAR(20) NULL ,
          DiagnosisCode5 VARCHAR(20) NULL ,
          DiagnosisCode6 VARCHAR(20) NULL ,
          DiagnosisCode7 VARCHAR(20) NULL ,
          DiagnosisCode8 VARCHAR(20) NULL ,
          AuthorizationId INT NULL ,
          AuthorizationNumber VARCHAR(35) NULL ,
          SubmissionReasonCode CHAR(1) NULL ,
          PayerClaimControlNumber VARCHAR(80) NULL ,
          MedicalRecordNumber VARCHAR(30) NULL ,
          CLIANumber VARCHAR(50) NULL ,
          EmergencyIndicator CHAR(1) NULL ,
          ClinicianId INT NULL ,
          ClinicianLastName VARCHAR(30) NULL ,
          ClinicianFirstName VARCHAR(20) NULL ,
          ClinicianMiddleName VARCHAR(20) NULL ,
          ClinicianSex CHAR(1) NULL ,
		  ClinicianDegree INT NULL ,
		  ClinicalDegreeGroupName VARCHAR(250) , 
          AttendingId INT NULL ,
          Priority INT NULL ,
          CoveragePlanId INT NULL ,
          MedicaidPayer CHAR(1) NULL ,
          MedicarePayer CHAR(1) NULL ,
          PayerName VARCHAR(100) NULL ,
          PayerAddressHeading VARCHAR(100) NULL ,
          PayerAddress1 VARCHAR(60) NULL ,
          PayerAddress2 VARCHAR(60) NULL ,
          PayerCity VARCHAR(30) NULL ,
          PayerState CHAR(2) NULL ,
          PayerZip CHAR(25) NULL ,
          ProviderCommercialNumber VARCHAR(50) NULL ,
          InsuranceCommissionersCode VARCHAR(50) NULL ,
          MedicareInsuranceTypeCode CHAR(2) NULL ,
          ClaimFilingIndicatorCode CHAR(2) NULL ,
          ElectronicClaimsPayerId VARCHAR(20) NULL ,
          ClaimOfficeNumber VARCHAR(20) NULL ,
          ChargeAmount MONEY NULL ,
          PaidAmount MONEY NULL ,
          BalanceAmount MONEY NULL ,
          ApprovedAmount MONEY NULL ,
          ClientPayment MONEY NULL ,
          ExpectedPayment MONEY NULL ,
          ExpectedAdjustment MONEY NULL ,
          AgencyName VARCHAR(100) NULL ,
          BillingProviderTaxIdType VARCHAR(2) NULL ,
          BillingProviderTaxId VARCHAR(9) NULL ,
          BillingProviderIdType VARCHAR(2) NULL ,
          BillingProviderId VARCHAR(35) NULL ,
          BillingTaxonomyCode VARCHAR(30) NULL ,
          BillingProviderLastName VARCHAR(60) NULL ,
          BillingProviderFirstName VARCHAR(25) NULL ,
          BillingProviderMiddleName VARCHAR(25) NULL ,
          BillingProviderNPI CHAR(10) NULL ,
          PayToProviderTaxIdType VARCHAR(2) NULL ,
          PayToProviderTaxId VARCHAR(9) NULL ,
          PayToProviderIdType VARCHAR(2) NULL ,
          PayToProviderId VARCHAR(35) NULL ,
          PayToProviderLastName VARCHAR(35) NULL ,
          PayToProviderFirstName VARCHAR(25) NULL ,
          PayToProviderMiddleName VARCHAR(25) NULL ,
          PayToProviderNPI CHAR(10) NULL ,
          RenderingProviderTaxIdType VARCHAR(2) NULL ,
          RenderingProviderTaxId VARCHAR(9) NULL ,
          RenderingProviderIdType VARCHAR(2) NULL ,
          RenderingProviderId VARCHAR(35) NULL ,
          RenderingProviderLastName VARCHAR(35) NULL ,
          RenderingProviderFirstName VARCHAR(25) NULL ,
          RenderingProviderMiddleName VARCHAR(25) NULL ,
          RenderingProviderTaxonomyCode VARCHAR(20) NULL ,
          RenderingProviderNPI CHAR(10) NULL ,
          ReferringProviderTaxIdType VARCHAR(2) NULL ,
          ReferringProviderTaxId VARCHAR(9) NULL ,
          ReferringProviderIdType VARCHAR(2) NULL ,
          ReferringProviderId VARCHAR(35) NULL ,
          ReferringProviderLastName VARCHAR(35) NULL ,
          ReferringProviderFirstName VARCHAR(25) NULL ,
          ReferringProviderMiddleName VARCHAR(25) NULL ,
          ReferringProviderNPI CHAR(10) NULL ,
          FacilityEntityCode VARCHAR(2) NULL ,
          FacilityName VARCHAR(35) NULL ,
          FacilityTaxIdType VARCHAR(2) NULL ,
          FacilityTaxId VARCHAR(9) NULL ,
          FacilityProviderIdType VARCHAR(2) NULL ,
          FacilityProviderId VARCHAR(35) NULL ,
          FacilityAddress1 VARCHAR(30) NULL ,
          FacilityAddress2 VARCHAR(30) NULL ,
          FacilityCity VARCHAR(30) NULL ,
          FacilityState CHAR(2) NULL ,
          FacilityZip VARCHAR(25) NULL ,
          FacilityPhone VARCHAR(10) NULL ,
          FacilityNPI CHAR(10) NULL ,
          SupervisingProvider2310DLastName VARCHAR(60) NULL ,
          SupervisingProvider2310DFirstName VARCHAR(35) NULL ,
          SupervisingProvider2310DMiddleName VARCHAR(25) NULL ,
          SupervisingProvider2310DIdType VARCHAR(2) NULL ,
          SupervisingProvider2310DId VARCHAR(80) NULL ,
          SupervisingProvider2310DSecondaryIdType1 VARCHAR(3) NULL ,
          SupervisingProvider2310DSecondaryId1 VARCHAR(50) ,
          SupervisingProvider2310DSecondaryIdType2 VARCHAR(3) NULL ,
          SupervisingProvider2310DSecondaryId2 VARCHAR(50) ,
          SupervisingProvider2310DSecondaryIdType3 VARCHAR(3) NULL ,
          SupervisingProvider2310DSecondaryId3 VARCHAR(50) ,
          SupervisingProvider2310DSecondaryIdType4 VARCHAR(3) NULL ,
          SupervisingProvider2310DSecondaryId4 VARCHAR(50) ,
          ServiceLineFacilityEntityCode VARCHAR(2) NULL ,
          ServiceLineFacilityName VARCHAR(35) NULL ,
          ServiceLineFacilityTaxIdType VARCHAR(2) NULL ,
          ServiceLineFacilityTaxId VARCHAR(9) NULL ,
          ServiceLineFacilityProviderIdType VARCHAR(2) NULL ,
          ServiceLineFacilityProviderId VARCHAR(35) NULL ,
          ServiceLineFacilityAddress1 VARCHAR(30) NULL ,
          ServiceLineFacilityAddress2 VARCHAR(30) NULL ,
          ServiceLineFacilityCity VARCHAR(30) NULL ,
          ServiceLineFacilityState CHAR(2) NULL ,
          ServiceLineFacilityZip VARCHAR(25) NULL ,
          ServiceLineFacilityPhone VARCHAR(10) NULL ,
          ServiceLineFacilityNPI CHAR(10) NULL ,
          PaymentAddress1 VARCHAR(55) NULL ,
          PaymentAddress2 VARCHAR(30) NULL ,
          PaymentCity VARCHAR(30) NULL ,
          PaymentState CHAR(2) NULL ,
          PaymentZip VARCHAR(25) NULL ,
          PaymentPhone VARCHAR(10) NULL ,
          ReferringId INT NULL , -- Not tracked in application  
          BillingCode VARCHAR(15) NULL ,
          Modifier1 CHAR(2) NULL ,
          Modifier2 CHAR(2) NULL ,
          Modifier3 CHAR(2) NULL ,
          Modifier4 CHAR(2) NULL ,
          BillingCodeDescription VARCHAR(50) NULL ,
          RevenueCode VARCHAR(15) NULL ,
          RevenueCodeDescription VARCHAR(100) NULL ,
          ClaimUnits DECIMAL(9, 2) NULL ,
          HCFAReservedValue VARCHAR(15) NULL ,
          VoidedClaimLineItemId INT NULL ,
          InpatientAdmitDate DATETIME ,
          [ClaimNoteReferenceCode] [VARCHAR](80) NULL ,
          [ClaimNote] [VARCHAR](MAX) NULL ,
          [ServiceNoteReferenceCode] [VARCHAR](15) NULL ,
          [ServiceNote] [VARCHAR](MAX) NULL ,
          PrimaryServiceId INT NULL
        )  
        
        
    IF @@error <> 0
        GOTO error  

  
    CREATE INDEX temp_Charges_PK ON #Charges (ChargeId)  

  
    IF @@error <> 0
        GOTO error 
        
        
    CREATE TABLE #ClaimLines
        (
          ClaimLineId INT IDENTITY
                          NOT NULL ,
          ToVoidClaimLineItemGroupId INT ,
          ClaimLineItemGroupId INT ,
          ChargeId INT NULL ,
          ClientId INT NULL ,
          ClientLastName VARCHAR(30) NULL ,
          ClientFirstname VARCHAR(20) NULL ,
          ClientMiddleName VARCHAR(20) NULL ,
          ClientSSN CHAR(11) NULL ,
          ClientSuffix VARCHAR(10) NULL ,
          ClientAddress1 VARCHAR(30) NULL ,
          ClientAddress2 VARCHAR(30) NULL ,
          ClientCity VARCHAR(30) NULL ,
          ClientState CHAR(2) NULL ,
          ClientZip CHAR(25) NULL ,
          ClientHomePhone CHAR(10) NULL ,
          ClientDOB DATETIME NULL ,
          ClientSex CHAR(1) NULL ,
          ClientIsSubscriber CHAR(1) NULL ,
          SubscriberContactId INT NULL ,
          StudentStatus INT NULL ,
          MaritalStatus INT NULL ,
          EmploymentStatus INT NULL ,
          EmploymentRelated CHAR(1) NULL ,
          AutoRelated CHAR(1) NULL ,
          OtherAccidentRelated CHAR(1) NULL ,
          RegistrationDate DATETIME NULL ,
          DischargeDate DATETIME NULL ,
          RelatedHospitalAdmitDate DATETIME NULL ,
          ClientCoveragePlanId INT NULL ,
          InsuredId VARCHAR(25) NULL ,
          GroupNumber VARCHAR(30) NULL ,
          GroupName VARCHAR(100) NULL ,
          InsuredLastName VARCHAR(30) NULL ,
          InsuredFirstName VARCHAR(20) NULL ,
          InsuredMiddleName VARCHAR(20) NULL ,
          InsuredSuffix VARCHAR(10) NULL ,
          InsuredRelation INT NULL ,
          InsuredRelationCode VARCHAR(20) NULL ,
          InsuredAddress1 VARCHAR(30) NULL ,
          InsuredAddress2 VARCHAR(30) NULL ,
          InsuredCity VARCHAR(30) NULL ,
          InsuredState CHAR(2) NULL ,
          InsuredZip VARCHAR(25) NULL ,
          InsuredHomePhone CHAR(10) NULL ,
          InsuredSex CHAR(1) NULL ,
          InsuredSSN VARCHAR(9) NULL ,
          InsuredDOB DATETIME NULL ,
          ServiceId INT NULL ,
          GroupServiceId INT NULL ,
          GroupId INT NULL ,
          DateOfService DATETIME NULL ,
          EndDateOfService DATETIME NULL ,
          ProcedureCodeId INT NULL ,
          ServiceUnits DECIMAL(7, 2) NULL ,
          ServiceUnitType INT NULL ,
          ProgramId INT NULL ,
          LocationId INT NULL ,
          PlaceOfService INT NULL ,
          PlaceOfServiceCode CHAR(2) NULL ,
          TypeOfServiceCode CHAR(2) NULL ,
          DiagnosisQualifier1 VARCHAR(3) NULL ,
          DiagnosisQualifier2 VARCHAR(3) NULL ,
          DiagnosisQualifier3 VARCHAR(3) NULL ,
          DiagnosisQualifier4 VARCHAR(3) NULL ,
          DiagnosisQualifier5 VARCHAR(3) NULL ,
          DiagnosisQualifier6 VARCHAR(3) NULL ,
          DiagnosisQualifier7 VARCHAR(3) NULL ,
          DiagnosisQualifier8 VARCHAR(3) NULL ,
          DiagnosisCode1 VARCHAR(20) NULL ,
          DiagnosisCode2 VARCHAR(20) NULL ,
          DiagnosisCode3 VARCHAR(20) NULL ,
          DiagnosisCode4 VARCHAR(20) NULL ,
          DiagnosisCode5 VARCHAR(20) NULL ,
          DiagnosisCode6 VARCHAR(20) NULL ,
          DiagnosisCode7 VARCHAR(20) NULL ,
          DiagnosisCode8 VARCHAR(20) NULL ,
          AuthorizationId INT NULL ,
          AuthorizationNumber VARCHAR(35) NULL ,
          SubmissionReasonCode CHAR(1) NULL ,
          PayerClaimControlNumber VARCHAR(80) NULL ,
          MedicalRecordNumber VARCHAR(30) NULL ,
          CLIANumber VARCHAR(50) NULL ,
          EmergencyIndicator CHAR(1) NULL ,
          ClinicianId INT NULL ,
          ClinicianLastName VARCHAR(30) NULL ,
          ClinicianFirstName VARCHAR(20) NULL ,
          ClinicianMiddleName VARCHAR(20) NULL ,
          ClinicianSex CHAR(1) NULL ,
		  ClinicianDegree INT NULL ,
		  ClinicalDegreeGroupName VARCHAR(250) , 
          AttendingId INT NULL ,
          Priority INT NULL ,
          CoveragePlanId INT NULL ,
          MedicaidPayer CHAR(1) NULL ,
          MedicarePayer CHAR(1) NULL ,
          PayerName VARCHAR(100) NULL ,
          PayerAddressHeading VARCHAR(100) NULL ,
          PayerAddress1 VARCHAR(60) NULL ,
          PayerAddress2 VARCHAR(60) NULL ,
          PayerCity VARCHAR(30) NULL ,
          PayerState CHAR(2) NULL ,
          PayerZip CHAR(25) NULL ,
          ProviderCommercialNumber VARCHAR(50) NULL ,
          InsuranceCommissionersCode VARCHAR(50) NULL ,
          MedicareInsuranceTypeCode CHAR(2) NULL ,
          ClaimFilingIndicatorCode CHAR(2) NULL ,
          ElectronicClaimsPayerId VARCHAR(20) NULL ,
          ClaimOfficeNumber VARCHAR(20) NULL ,
          ChargeAmount MONEY NULL ,
          PaidAmount MONEY NULL ,
          Adjustments MONEY NULL ,
          BalanceAmount MONEY NULL ,
          ApprovedAmount MONEY NULL ,
          ClientPayment MONEY NULL ,
          ExpectedPayment MONEY NULL ,
          ExpectedAdjustment MONEY NULL ,
          AgencyName VARCHAR(100) NULL ,
          BillingProviderTaxIdType VARCHAR(2) NULL ,
          BillingProviderTaxId VARCHAR(9) NULL ,
          BillingProviderIdType VARCHAR(2) NULL ,
          BillingProviderId VARCHAR(35) NULL ,
          BillingTaxonomyCode VARCHAR(30) NULL ,
          BillingProviderLastName VARCHAR(60) NULL ,
          BillingProviderFirstName VARCHAR(25) NULL ,
          BillingProviderMiddleName VARCHAR(25) NULL ,
          BillingProviderNPI CHAR(10) NULL ,
          PayToProviderTaxIdType VARCHAR(2) NULL ,
          PayToProviderTaxId VARCHAR(9) NULL ,
          PayToProviderIdType VARCHAR(2) NULL ,
          PayToProviderId VARCHAR(35) NULL ,
          PayToProviderLastName VARCHAR(35) NULL ,
          PayToProviderFirstName VARCHAR(25) NULL ,
          PayToProviderMiddleName VARCHAR(25) NULL ,
          PayToProviderNPI CHAR(10) NULL ,
          RenderingProviderTaxIdType VARCHAR(2) NULL ,
          RenderingProviderTaxId VARCHAR(9) NULL ,
          RenderingProviderIdType VARCHAR(2) NULL ,
          RenderingProviderId VARCHAR(35) NULL ,
          RenderingProviderLastName VARCHAR(35) NULL ,
          RenderingProviderFirstName VARCHAR(25) NULL ,
          RenderingProviderMiddleName VARCHAR(25) NULL ,
          RenderingProviderTaxonomyCode VARCHAR(20) NULL ,
          RenderingProviderNPI CHAR(10) NULL ,
          ReferringProviderTaxIdType VARCHAR(2) NULL ,
          ReferringProviderTaxId VARCHAR(9) NULL ,
          ReferringProviderIdType VARCHAR(2) NULL ,
          ReferringProviderId VARCHAR(35) NULL ,
          ReferringProviderLastName VARCHAR(35) NULL ,
          ReferringProviderFirstName VARCHAR(25) NULL ,
          ReferringProviderMiddleName VARCHAR(25) NULL ,
          ReferringProviderNPI CHAR(10) NULL ,
          FacilityEntityCode VARCHAR(2) NULL ,
          FacilityName VARCHAR(35) NULL ,
          FacilityTaxIdType VARCHAR(2) NULL ,
          FacilityTaxId VARCHAR(9) NULL ,
          FacilityProviderIdType VARCHAR(2) NULL ,
          FacilityProviderId VARCHAR(35) NULL ,
          FacilityAddress1 VARCHAR(30) NULL ,
          FacilityAddress2 VARCHAR(30) NULL ,
          FacilityCity VARCHAR(30) NULL ,
          FacilityState CHAR(2) NULL ,
          FacilityZip VARCHAR(25) NULL ,
          FacilityPhone VARCHAR(10) NULL ,
          FacilityNPI CHAR(10) NULL ,
          SupervisingProvider2310DLastName VARCHAR(60) NULL ,
          SupervisingProvider2310DFirstName VARCHAR(35) NULL ,
          SupervisingProvider2310DMiddleName VARCHAR(25) NULL ,
          SupervisingProvider2310DIdType VARCHAR(2) NULL ,
          SupervisingProvider2310DId VARCHAR(80) NULL ,
          SupervisingProvider2310DSecondaryIdType1 VARCHAR(3) NULL ,
          SupervisingProvider2310DSecondaryId1 VARCHAR(50) ,
          SupervisingProvider2310DSecondaryIdType2 VARCHAR(3) NULL ,
          SupervisingProvider2310DSecondaryId2 VARCHAR(50) ,
          SupervisingProvider2310DSecondaryIdType3 VARCHAR(3) NULL ,
          SupervisingProvider2310DSecondaryId3 VARCHAR(50) ,
          SupervisingProvider2310DSecondaryIdType4 VARCHAR(3) NULL ,
          SupervisingProvider2310DSecondaryId4 VARCHAR(50) ,
          ServiceLineFacilityEntityCode VARCHAR(2) NULL ,
          ServiceLineFacilityName VARCHAR(35) NULL ,
          ServiceLineFacilityTaxIdType VARCHAR(2) NULL ,
          ServiceLineFacilityTaxId VARCHAR(9) NULL ,
          ServiceLineFacilityProviderIdType VARCHAR(2) NULL ,
          ServiceLineFacilityProviderId VARCHAR(35) NULL ,
          ServiceLineFacilityAddress1 VARCHAR(30) NULL ,
          ServiceLineFacilityAddress2 VARCHAR(30) NULL ,
          ServiceLineFacilityCity VARCHAR(30) NULL ,
          ServiceLineFacilityState CHAR(2) NULL ,
          ServiceLineFacilityZip VARCHAR(25) NULL ,
          ServiceLineFacilityPhone VARCHAR(10) NULL ,
          ServiceLineFacilityNPI CHAR(10) NULL ,
          PaymentAddress1 VARCHAR(55) NULL ,
          PaymentAddress2 VARCHAR(30) NULL ,
          PaymentCity VARCHAR(30) NULL ,
          PaymentState CHAR(2) NULL ,
          PaymentZip VARCHAR(25) NULL ,
          PaymentPhone VARCHAR(10) NULL ,
          ReferringId INT NULL , -- Not tracked in application  
          BillingCode VARCHAR(15) NULL ,
          Modifier1 CHAR(2) NULL ,
          Modifier2 CHAR(2) NULL ,
          Modifier3 CHAR(2) NULL ,
          Modifier4 CHAR(2) NULL ,
          BillingCodeDescription VARCHAR(50) NULL ,
          RevenueCode VARCHAR(15) NULL ,
          RevenueCodeDescription VARCHAR(100) NULL ,
          ClaimUnits DECIMAL(9, 2) NULL ,
          HCFAReservedValue VARCHAR(15) NULL ,
          DiagnosisPointer VARCHAR(10) NULL ,
          DiagnosisPointer1 CHAR(1) NULL ,
          DiagnosisPointer2 CHAR(1) NULL ,
          DiagnosisPointer3 CHAR(1) NULL ,
          DiagnosisPointer4 CHAR(1) NULL ,
          DiagnosisPointer5 CHAR(1) NULL ,
          DiagnosisPointer6 CHAR(1) NULL ,
          DiagnosisPointer7 CHAR(1) NULL ,
          DiagnosisPointer8 CHAR(1) NULL ,
          LineItemControlNumber INT NULL ,
          ClientGroupId INT NULL ,  
-- Custom Fields  
          CustomField1 VARCHAR(100) NULL ,
          CustomField2 VARCHAR(100) NULL ,
          CustomField3 VARCHAR(100) NULL ,
          CustomField4 VARCHAR(100) NULL ,
          CustomField5 VARCHAR(100) NULL ,
          CustomField6 VARCHAR(100) NULL ,
          CustomField7 VARCHAR(100) NULL ,
          CustomField8 VARCHAR(100) NULL ,
          CustomField9 VARCHAR(100) NULL ,
          CustomField10 VARCHAR(100) NULL , 
 	--Added by MSuma
          ClientWasPresent CHAR(1) ,
          VoidedClaimLineItemId INT NULL ,
          InpatientAdmitDate DATETIME ,
          [ClaimNoteReferenceCode] [VARCHAR](80) NULL ,
          [ClaimNote] [VARCHAR](MAX) NULL ,
          [ServiceNoteReferenceCode] [VARCHAR](15) NULL ,
          [ServiceNote] [VARCHAR](MAX) NULL ,
          MonthOfService INT NULL ,
          WeekOfService INT NULL ,
          ClaimId INT NULL ,
          PrimaryServiceId INT NULL
        )  
  
    IF @@error <> 0
        GOTO error  

  
    CREATE INDEX temp_ClaimLines_PK ON #ClaimLines (ClaimLineId)  

  
    IF @@error <> 0
        GOTO ERROR
        
        
    CREATE TABLE #ClaimLines_Temp
        (
          ClaimLineId INT NOT NULL ,
          ToVoidClaimLineItemGroupId INT ,
          ClaimLineItemGroupId INT ,
          ChargeId INT NULL ,
          ClientId INT NULL ,
          ClientLastName VARCHAR(30) NULL ,
          ClientFirstname VARCHAR(20) NULL ,
          ClientMiddleName VARCHAR(20) NULL ,
          ClientSSN CHAR(11) NULL ,
          ClientSuffix VARCHAR(10) NULL ,
          ClientAddress1 VARCHAR(30) NULL ,
          ClientAddress2 VARCHAR(30) NULL ,
          ClientCity VARCHAR(30) NULL ,
          ClientState CHAR(2) NULL ,
          ClientZip CHAR(25) NULL ,
          ClientHomePhone CHAR(10) NULL ,
          ClientDOB DATETIME NULL ,
          ClientSex CHAR(1) NULL ,
          ClientIsSubscriber CHAR(1) NULL ,
          SubscriberContactId INT NULL ,
          StudentStatus INT NULL ,
          MaritalStatus INT NULL ,
          EmploymentStatus INT NULL ,
          EmploymentRelated CHAR(1) NULL ,
          AutoRelated CHAR(1) NULL ,
          OtherAccidentRelated CHAR(1) NULL ,
          RegistrationDate DATETIME NULL ,
          DischargeDate DATETIME NULL ,
          RelatedHospitalAdmitDate DATETIME NULL ,
          ClientCoveragePlanId INT NULL ,
          InsuredId VARCHAR(25) NULL ,
          GroupNumber VARCHAR(30) NULL ,
          GroupName VARCHAR(100) NULL ,
          InsuredLastName VARCHAR(30) NULL ,
          InsuredFirstName VARCHAR(20) NULL ,
          InsuredMiddleName VARCHAR(20) NULL ,
          InsuredSuffix VARCHAR(10) NULL ,
          InsuredRelation INT NULL ,
          InsuredRelationCode VARCHAR(20) NULL ,
          InsuredAddress1 VARCHAR(30) NULL ,
          InsuredAddress2 VARCHAR(30) NULL ,
          InsuredCity VARCHAR(30) NULL ,
          InsuredState CHAR(2) NULL ,
          InsuredZip VARCHAR(25) NULL ,
          InsuredHomePhone CHAR(10) NULL ,
          InsuredSex CHAR(1) NULL ,
          InsuredSSN VARCHAR(9) NULL ,
          InsuredDOB DATETIME NULL ,
          ServiceId INT NULL ,
          GroupServiceId INT NULL ,
          GroupId INT NULL ,
          DateOfService DATETIME NULL ,
          EndDateOfService DATETIME NULL ,
          ProcedureCodeId INT NULL ,
          ServiceUnits DECIMAL(7, 2) NULL ,
          ServiceUnitType INT NULL ,
          ProgramId INT NULL ,
          LocationId INT NULL ,
          PlaceOfService INT NULL ,
          PlaceOfServiceCode CHAR(2) NULL ,
          TypeOfServiceCode CHAR(2) NULL ,
          DiagnosisQualifier1 VARCHAR(3) NULL ,
          DiagnosisQualifier2 VARCHAR(3) NULL ,
          DiagnosisQualifier3 VARCHAR(3) NULL ,
          DiagnosisQualifier4 VARCHAR(3) NULL ,
          DiagnosisQualifier5 VARCHAR(3) NULL ,
          DiagnosisQualifier6 VARCHAR(3) NULL ,
          DiagnosisQualifier7 VARCHAR(3) NULL ,
          DiagnosisQualifier8 VARCHAR(3) NULL ,
          DiagnosisCode1 VARCHAR(20) NULL ,
          DiagnosisCode2 VARCHAR(20) NULL ,
          DiagnosisCode3 VARCHAR(20) NULL ,
          DiagnosisCode4 VARCHAR(20) NULL ,
          DiagnosisCode5 VARCHAR(20) NULL ,
          DiagnosisCode6 VARCHAR(20) NULL ,
          DiagnosisCode7 VARCHAR(20) NULL ,
          DiagnosisCode8 VARCHAR(20) NULL ,
          AuthorizationId INT NULL ,
          AuthorizationNumber VARCHAR(35) NULL ,
          SubmissionReasonCode CHAR(1) NULL ,
          PayerClaimControlNumber VARCHAR(80) NULL ,
          MedicalRecordNumber VARCHAR(30) NULL ,
          CLIANumber VARCHAR(50) NULL ,
          EmergencyIndicator CHAR(1) NULL ,
          ClinicianId INT NULL ,
          ClinicianLastName VARCHAR(30) NULL ,
          ClinicianFirstName VARCHAR(20) NULL ,
          ClinicianMiddleName VARCHAR(20) NULL ,
          ClinicianSex CHAR(1) NULL ,
		  ClinicianDegree INT NULL ,
		  ClinicalDegreeGroupName VARCHAR(250) , 
          AttendingId INT NULL ,
          Priority INT NULL ,
          CoveragePlanId INT NULL ,
          MedicaidPayer CHAR(1) NULL ,
          MedicarePayer CHAR(1) NULL ,
          PayerName VARCHAR(100) NULL ,
          PayerAddressHeading VARCHAR(100) NULL ,
          PayerAddress1 VARCHAR(60) NULL ,
          PayerAddress2 VARCHAR(60) NULL ,
          PayerCity VARCHAR(30) NULL ,
          PayerState CHAR(2) NULL ,
          PayerZip CHAR(25) NULL ,
          ProviderCommercialNumber VARCHAR(50) NULL ,
          InsuranceCommissionersCode VARCHAR(50) NULL ,
          MedicareInsuranceTypeCode CHAR(2) NULL ,
          ClaimFilingIndicatorCode CHAR(2) NULL ,
          ElectronicClaimsPayerId VARCHAR(20) NULL ,
          ClaimOfficeNumber VARCHAR(20) NULL ,
          ChargeAmount MONEY NULL ,
          PaidAmount MONEY NULL ,
          Adjustments MONEY NULL ,
          BalanceAmount MONEY NULL ,
          ApprovedAmount MONEY NULL ,
          ClientPayment MONEY NULL ,
          ExpectedPayment MONEY NULL ,
          ExpectedAdjustment MONEY NULL ,
          AgencyName VARCHAR(100) NULL ,
          BillingProviderTaxIdType VARCHAR(2) NULL ,
          BillingProviderTaxId VARCHAR(9) NULL ,
          BillingProviderIdType VARCHAR(2) NULL ,
          BillingProviderId VARCHAR(35) NULL ,
          BillingTaxonomyCode VARCHAR(30) NULL ,
          BillingProviderLastName VARCHAR(60) NULL ,
          BillingProviderFirstName VARCHAR(25) NULL ,
          BillingProviderMiddleName VARCHAR(25) NULL ,
          BillingProviderNPI CHAR(10) NULL ,
          PayToProviderTaxIdType VARCHAR(2) NULL ,
          PayToProviderTaxId VARCHAR(9) NULL ,
          PayToProviderIdType VARCHAR(2) NULL ,
          PayToProviderId VARCHAR(35) NULL ,
          PayToProviderLastName VARCHAR(35) NULL ,
          PayToProviderFirstName VARCHAR(25) NULL ,
          PayToProviderMiddleName VARCHAR(25) NULL ,
          PayToProviderNPI CHAR(10) NULL ,
          RenderingProviderTaxIdType VARCHAR(2) NULL ,
          RenderingProviderTaxId VARCHAR(9) NULL ,
          RenderingProviderIdType VARCHAR(2) NULL ,
          RenderingProviderId VARCHAR(35) NULL ,
          RenderingProviderLastName VARCHAR(35) NULL ,
          RenderingProviderFirstName VARCHAR(25) NULL ,
          RenderingProviderMiddleName VARCHAR(25) NULL ,
          RenderingProviderTaxonomyCode VARCHAR(20) NULL ,
          RenderingProviderNPI CHAR(10) NULL ,
          ReferringProviderTaxIdType VARCHAR(2) NULL ,
          ReferringProviderTaxId VARCHAR(9) NULL ,
          ReferringProviderIdType VARCHAR(2) NULL ,
          ReferringProviderId VARCHAR(35) NULL ,
          ReferringProviderLastName VARCHAR(35) NULL ,
          ReferringProviderFirstName VARCHAR(25) NULL ,
          ReferringProviderMiddleName VARCHAR(25) NULL ,
          ReferringProviderNPI CHAR(10) NULL ,
          FacilityEntityCode VARCHAR(2) NULL ,
          FacilityName VARCHAR(35) NULL ,
          FacilityTaxIdType VARCHAR(2) NULL ,
          FacilityTaxId VARCHAR(9) NULL ,
          FacilityProviderIdType VARCHAR(2) NULL ,
          FacilityProviderId VARCHAR(35) NULL ,
          FacilityAddress1 VARCHAR(30) NULL ,
          FacilityAddress2 VARCHAR(30) NULL ,
          FacilityCity VARCHAR(30) NULL ,
          FacilityState CHAR(2) NULL ,
          FacilityZip VARCHAR(25) NULL ,
          FacilityPhone VARCHAR(10) NULL ,
          FacilityNPI CHAR(10) NULL ,
          SupervisingProvider2310DLastName VARCHAR(60) NULL ,
          SupervisingProvider2310DFirstName VARCHAR(35) NULL ,
          SupervisingProvider2310DMiddleName VARCHAR(25) NULL ,
          SupervisingProvider2310DIdType VARCHAR(2) NULL ,
          SupervisingProvider2310DId VARCHAR(80) NULL ,
          SupervisingProvider2310DSecondaryIdType1 VARCHAR(3) NULL ,
          SupervisingProvider2310DSecondaryId1 VARCHAR(50) ,
          SupervisingProvider2310DSecondaryIdType2 VARCHAR(3) NULL ,
          SupervisingProvider2310DSecondaryId2 VARCHAR(50) ,
          SupervisingProvider2310DSecondaryIdType3 VARCHAR(3) NULL ,
          SupervisingProvider2310DSecondaryId3 VARCHAR(50) ,
          SupervisingProvider2310DSecondaryIdType4 VARCHAR(3) NULL ,
          SupervisingProvider2310DSecondaryId4 VARCHAR(50) ,
          ServiceLineFacilityEntityCode VARCHAR(2) NULL ,
          ServiceLineFacilityName VARCHAR(35) NULL ,
          ServiceLineFacilityTaxIdType VARCHAR(2) NULL ,
          ServiceLineFacilityTaxId VARCHAR(9) NULL ,
          ServiceLineFacilityProviderIdType VARCHAR(2) NULL ,
          ServiceLineFacilityProviderId VARCHAR(35) NULL ,
          ServiceLineFacilityAddress1 VARCHAR(30) NULL ,
          ServiceLineFacilityAddress2 VARCHAR(30) NULL ,
          ServiceLineFacilityCity VARCHAR(30) NULL ,
          ServiceLineFacilityState CHAR(2) NULL ,
          ServiceLineFacilityZip VARCHAR(25) NULL ,
          ServiceLineFacilityPhone VARCHAR(10) NULL ,
          ServiceLineFacilityNPI CHAR(10) NULL ,
          PaymentAddress1 VARCHAR(55) NULL ,
          PaymentAddress2 VARCHAR(30) NULL ,
          PaymentCity VARCHAR(30) NULL ,
          PaymentState CHAR(2) NULL ,
          PaymentZip VARCHAR(25) NULL ,
          PaymentPhone VARCHAR(10) NULL ,
          ReferringId INT NULL , -- Not tracked in application  
          BillingCode VARCHAR(15) NULL ,
          Modifier1 CHAR(2) NULL ,
          Modifier2 CHAR(2) NULL ,
          Modifier3 CHAR(2) NULL ,
          Modifier4 CHAR(2) NULL ,
          BillingCodeDescription VARCHAR(50) NULL ,
          RevenueCode VARCHAR(15) NULL ,
          RevenueCodeDescription VARCHAR(100) NULL ,
          ClaimUnits DECIMAL(9, 2) NULL ,
          HCFAReservedValue VARCHAR(15) NULL ,
          DiagnosisPointer VARCHAR(10) NULL ,
          DiagnosisPointer1 CHAR(1) NULL ,
          DiagnosisPointer2 CHAR(1) NULL ,
          DiagnosisPointer3 CHAR(1) NULL ,
          DiagnosisPointer4 CHAR(1) NULL ,
          DiagnosisPointer5 CHAR(1) NULL ,
          DiagnosisPointer6 CHAR(1) NULL ,
          DiagnosisPointer7 CHAR(1) NULL ,
          DiagnosisPointer8 CHAR(1) NULL ,
          LineItemControlNumber INT NULL ,
          ClientGroupId INT NULL ,  
-- Custom Fields  
          CustomField1 VARCHAR(100) NULL ,
          CustomField2 VARCHAR(100) NULL ,
          CustomField3 VARCHAR(100) NULL ,
          CustomField4 VARCHAR(100) NULL ,
          CustomField5 VARCHAR(100) NULL ,
          CustomField6 VARCHAR(100) NULL ,
          CustomField7 VARCHAR(100) NULL ,
          CustomField8 VARCHAR(100) NULL ,
          CustomField9 VARCHAR(100) NULL ,
          CustomField10 VARCHAR(100) NULL ,
  	--Added by MSuma
          ClientWasPresent CHAR(1) ,
          VoidedClaimLineItemId INT NULL ,
          InpatientAdmitDate DATETIME ,
          [ClaimNoteReferenceCode] [VARCHAR](80) NULL ,
          [ClaimNote] [VARCHAR](MAX) NULL ,
          [ServiceNoteReferenceCode] [VARCHAR](15) NULL ,
          [ServiceNote] [VARCHAR](MAX) NULL ,
          MonthOfService INT NULL ,
          WeekOfService INT NULL ,
          ClaimId INT NULL ,
          PrimaryServiceId INT NULL
        )  
  
    IF @@error <> 0
        GOTO error  

  
    CREATE INDEX temp_ClaimLines_Temp_PK ON #ClaimLines_Temp (ClaimLineId)  

  
    IF @@error <> 0
        GOTO error  
        
        
    CREATE TABLE #OtherInsured
        (
          OtherInsuredId INT IDENTITY
                             NOT NULL ,
		  ClaimOtherInsuredId INT,
          ClaimLineId INT NOT NULL ,
          ChargeId INT NOT NULL ,
          Priority INT NOT NULL ,
          ClientCoveragePlanId INT NOT NULL ,
          CoveragePlanId INT NOT NULL ,
          InsuranceTypeCode CHAR(2) NULL ,
          ClaimFilingIndicatorCode CHAR(2) NULL ,
          PayerName VARCHAR(100) NULL ,
		  PayerAddress1 VARCHAR(55) NULL,
		  PayerAddress2 VARCHAR(55) NULL,
		  PayerCity VARCHAR(30) NULL,
		  PayerState VARCHAR (2) NULL ,
		  PayerZip Varchar(15) NULL,
          InsuredId VARCHAR(25) NULL ,
          GroupNumber VARCHAR(30) NULL ,
          GroupName VARCHAR(50) NULL ,
          PaidAmount MONEY NULL ,
          Adjustments MONEY NULL ,
          AllowedAmount MONEY NULL ,
          PreviousPaidAmount MONEY NULL ,
          ClientResponsibility MONEY NULL ,
          PaidDate DATETIME NULL ,
          InsuredLastName VARCHAR(20) NULL ,
          InsuredFirstName VARCHAR(20) NULL ,
          InsuredMiddleName VARCHAR(20) NULL ,
          InsuredSuffix VARCHAR(10) NULL ,
          InsuredSex CHAR(1) NULL ,
          InsuredDOB DATETIME NULL ,
          InsuredRelation INT NULL ,
          InsuredRelationCode VARCHAR(10) NULL ,
          DenialCode VARCHAR(10) NULL ,
          PayerType VARCHAR(10) NULL ,
          HIPAACOBCode CHAR(1) NULL ,
          ElectronicClaimsPayerId VARCHAR(20) NULL ,
          BillingCode VARCHAR(15) NULL ,
          Modifier1 CHAR(2) NULL ,
          Modifier2 CHAR(2) NULL ,
          Modifier3 CHAR(2) NULL ,
          Modifier4 CHAR(2) NULL ,
          BillingCodeDescription VARCHAR(50) NULL ,
          RevenueCode VARCHAR(15) NULL ,
          RevenueCodeDescription VARCHAR(100) NULL ,
          ClaimUnits DECIMAL(9, 2) NULL
        )    

	CREATE TABLE #ClaimOtherInsured
	(
		  ClaimOtherInsuredId INT PRIMARY KEY NOT NULL ,
		  ClaimId INT NOT NULL ,
          Priority INT NOT NULL ,
          InsuranceTypeCode CHAR(2) NULL ,
          ClaimFilingIndicatorCode CHAR(2) NULL ,
          PayerName VARCHAR(100) NULL ,
          InsuredId VARCHAR(25) NULL ,
          GroupNumber VARCHAR(30) NULL ,
          GroupName VARCHAR(50) NULL ,
          PaidAmount MONEY NULL ,
          AllowedAmount MONEY NULL ,
          ClientResponsibility MONEY NULL ,
          PaidDate DATETIME NULL ,
          InsuredLastName VARCHAR(20) NULL ,
          InsuredFirstName VARCHAR(20) NULL ,
          InsuredMiddleName VARCHAR(20) NULL ,
          InsuredSuffix VARCHAR(10) NULL ,
          InsuredSex CHAR(1) NULL ,
          InsuredDOB DATETIME NULL ,
          InsuredRelationCode VARCHAR(10) NULL ,
          ElectronicClaimsPayerId VARCHAR(20) NULL ,
	)
        
        
    IF @@error <> 0
        GOTO error  

  
    CREATE INDEX temp_otherinsured ON #OtherInsured (ClaimLineId)  

  
    IF @@error <> 0
        GOTO error 
        
        
    CREATE TABLE #OtherInsuredPaid
        (
          OtherInsuredId INT NOT NULL ,
          PaidAmount MONEY NULL ,
          Adjustments MONEY NULL ,
          AllowedAmount MONEY NULL ,
          PreviousPaidAmount MONEY NULL ,
          PaidDate DATETIME NULL ,
          DenialCode VARCHAR(10) NULL
        ) 
        
        
    CREATE TABLE #OtherInsuredAdjustment
        (
          OtherInsuredId CHAR(10) NOT NULL ,
          ARLedgerId INT NULL ,
          DenialCode INT NULL ,
          HIPAAGroupCode VARCHAR(10) NULL ,
          HIPAACode VARCHAR(10) NULL ,
          LedgerType INT NULL ,
          Amount MONEY NULL
        ) 
        
        
    IF @@error <> 0
        GOTO error    
    

    CREATE TABLE #OtherInsuredAdjustment2
        (
          OtherInsuredId CHAR(10) NOT NULL ,
          HIPAAGroupCode VARCHAR(10) NULL ,
          HIPAACode VARCHAR(10) NULL ,
          Amount MONEY NULL
        )    

    IF @@error <> 0
        GOTO ERROR
        
        
    CREATE TABLE #OtherInsuredAdjustment3
        (
          OtherInsuredId CHAR(10) NOT NULL ,
          HIPAAGroupCode VARCHAR(10) NULL ,
          HIPAACode1 VARCHAR(10) NULL ,
          Amount1 MONEY NULL ,
          HIPAACode2 VARCHAR(10) NULL ,
          Amount2 MONEY NULL ,
          HIPAACode3 VARCHAR(10) NULL ,
          Amount3 MONEY NULL ,
          HIPAACode4 VARCHAR(10) NULL ,
          Amount4 MONEY NULL ,
          HIPAACode5 VARCHAR(10) NULL ,
          Amount5 MONEY NULL ,
          HIPAACode6 VARCHAR(10) NULL ,
          Amount6 MONEY NULL
        )    
    

    IF @@error <> 0
        GOTO error    
    

    CREATE TABLE #PriorPayment
        (
          ClaimLineId INT NULL ,
          PaidAmout MONEY NULL ,
          BalanceAmount MONEY NULL ,
          ClientPayment MONEY NULL
        )    
        
        
        
--837 tables  
    CREATE TABLE #837BillingProviders
        (
          UniqueId INT IDENTITY
                       NOT NULL ,
          BillingId CHAR(10) NULL ,
          HierId INT NULL ,
          BillingProviderLastName VARCHAR(60) NULL ,
          BillingProviderFirstName VARCHAR(35) NULL ,
          BillingProviderMiddleName VARCHAR(35) NULL ,
          BillingProviderSuffix VARCHAR(35) NULL ,
          BillingProviderIdQualifier VARCHAR(2) NULL ,
          BillingProviderId VARCHAR(80) NOT NULL ,
          BillingProviderAddress1 VARCHAR(55) NULL ,
          BillingProviderAddress2 VARCHAR(55) NULL ,
          BillingProviderCity VARCHAR(30) NULL ,
          BillingProviderState VARCHAR(2) NULL ,
          BillingProviderZip VARCHAR(15) NULL ,
          BillingProviderAdditionalIdQualifier VARCHAR(35) NULL ,
          BillingProviderAdditionalId VARCHAR(250) NULL ,
          BillingProviderAdditionalIdQualifier2 VARCHAR(35) NULL ,
          BillingProviderAdditionalId2 VARCHAR(250) NULL ,
          BillingProviderAdditionalIdQualifier3 VARCHAR(35) NULL ,
          BillingProviderAdditionalId3 VARCHAR(250) NULL ,
          BillingProviderContactName VARCHAR(125) NULL ,
          BillingProviderContactNumber1Qualifier VARCHAR(5) NULL ,
          BillingProviderContactNumber1 VARCHAR(165) NULL ,
          BillingProviderTaxonomyCode VARCHAR(100) NULL ,
          PayToProviderLastName VARCHAR(35) NULL ,
          PayToProviderFirstName VARCHAR(35) NULL ,
          PayToProviderMiddleName VARCHAR(35) NULL ,
          PayToProviderSuffix VARCHAR(35) NULL ,
          PayToProviderIdQualifier VARCHAR(2) NULL ,
          PayToProviderId VARCHAR(80) NULL ,
          PayToProviderAddress1 VARCHAR(55) NULL ,
          PayToProviderAddress2 VARCHAR(55) NULL ,
          PayToProviderCity VARCHAR(30) NULL ,
          PayToProviderState VARCHAR(2) NULL ,
          PayToProviderZip VARCHAR(15) NULL ,
          PayToProviderSecondaryQualifier VARCHAR(3) NULL ,
          PayToProviderSecondaryId VARCHAR(30) NULL ,
          PayToProviderSecondaryQualifier2 VARCHAR(3) NULL ,
          PayToProviderSecondaryId2 VARCHAR(30) NULL ,
          PayToProviderSecondaryQualifier3 VARCHAR(3) NULL ,
          PayToProviderSecondaryId3 VARCHAR(30) NULL ,
          PayToProviderTaxId VARCHAR(35) NULL ,
          HLSegment VARCHAR(MAX) NULL ,
          BillingProviderNM1Segment VARCHAR(MAX) NULL ,
          BillingProviderN3Segment VARCHAR(MAX) NULL ,
          BillingProviderN4Segment VARCHAR(MAX) NULL ,
          BillingProviderRefSegment VARCHAR(MAX) NULL ,
          BillingProviderRef2Segment VARCHAR(MAX) NULL ,
          BillingProviderRef3Segment VARCHAR(MAX) NULL ,
          BillingProviderPerSegment VARCHAR(MAX) NULL ,
          PayToProviderNM1Segment VARCHAR(MAX) NULL ,
          PayToProviderN3Segment VARCHAR(MAX) NULL ,
          PayToProviderN4Segment VARCHAR(MAX) NULL ,
          PayToProviderRefSegment VARCHAR(MAX) NULL ,
          PayToProviderRef2Segment VARCHAR(MAX) NULL ,
          PayToProviderRef3Segment VARCHAR(MAX) NULL ,
          BillingPRVSegment VARCHAR(MAX) NULL
        )   
  
    IF @@error <> 0
        GOTO error  
  
    CREATE TABLE #837SubscriberClients
        (
          UniqueId INT IDENTITY
                       NOT NULL ,
          RefBillingProviderId INT NOT NULL ,
          ClientGroupId INT NOT NULL ,
          ClientId INT NOT NULL ,
          CoveragePlanId INT NOT NULL ,
          InsuredId VARCHAR(25) NULL ,
          Priority INT NULL ,
          GroupNumber VARCHAR(30) NULL ,
          GroupName VARCHAR(60) NULL ,
          MedicareInsuranceTypeCode VARCHAR(2) NULL ,
          HierId INT NULL ,
          HierParentId INT NULL ,
          HierChildCode VARCHAR(1) NULL ,
          RelationCode VARCHAR(2) NULL ,
          ClaimFilingIndicatorCode VARCHAR(2) NULL ,
          SubmissionReasonCode VARCHAR(2) NULL ,
          SubscriberEntityQualifier VARCHAR(1) NULL ,
          SubscriberLastName VARCHAR(35) NULL ,
          SubscriberFirstName VARCHAR(25) NULL ,
          SubscriberMiddleName VARCHAR(25) NULL ,
          SubscriberSuffix VARCHAR(10) NULL ,
          SubscriberIdQualifier VARCHAR(2) NULL ,
          SubscriberIdInsuredId VARCHAR(80) NULL ,
          SubscriberAddress1 VARCHAR(55) NULL ,
          SubscriberAddress2 VARCHAR(55) NULL ,
          SubscriberCity VARCHAR(30) NULL ,
          SubscriberState VARCHAR(2) NULL ,
          SubscriberZip VARCHAR(15) NULL ,
          SubscriberDOB VARCHAR(35) NULL ,
          SubscriberSex VARCHAR(1) NULL ,
          SubscriberSSN VARCHAR(9) NULL ,
          PayerName VARCHAR(35) NULL ,
          PayerIdQualifier VARCHAR(2) NULL ,
          ProviderCommercialNumber VARCHAR(50) NULL ,
          InsuranceCommissionersCode VARCHAR(50) NULL ,
          ElectronicClaimsPayerId VARCHAR(80) NULL ,
          ClaimOfficeNumber VARCHAR(80) NULL ,
          PayerAddress1 VARCHAR(55) NULL ,
          PayerAddress2 VARCHAR(55) NULL ,
          PayerCity VARCHAR(30) NULL ,
          PayerState VARCHAR(2) NULL ,
          PayerZip VARCHAR(15) NULL ,
          PayerCountryCode VARCHAR(3) NULL ,
          PayerAdditionalIdQualifier VARCHAR(10) NULL ,
          PayerAdditionalId VARCHAR(95) NULL ,
          ResponsibleQualifier VARCHAR(3) NULL ,
          ResponsibleLastName VARCHAR(35) NULL ,
          ResponsibleFirstName VARCHAR(25) NULL ,
          ResponsibleMiddleName VARCHAR(25) NULL ,
          ResponsibleSuffix VARCHAR(10) NULL ,
          ResponsibleAddress1 VARCHAR(55) NULL ,
          ResponsibleAddress2 VARCHAR(55) NULL ,
          ResponsibleCity VARCHAR(30) NULL ,
          ResponsibleState VARCHAR(2) NULL ,
          ResponsibleZip VARCHAR(15) NULL ,
          ResponsibleCountryCode VARCHAR(3) NULL ,
          ClientRelationship VARCHAR(3) NULL ,
          ClientDateOfDeath VARCHAR(35) NULL ,
          ClientPregnancyIndicator VARCHAR(1) NULL ,
          ClientLastName VARCHAR(35) NULL ,
          ClientFirstName VARCHAR(25) NULL ,
          ClientMiddleName VARCHAR(25) NULL ,
          ClientSuffix VARCHAR(10) NULL ,
          InsuredIdQualifier VARCHAR(2) NULL ,
          ClientInsuredId VARCHAR(80) NULL ,
          ClientAddress1 VARCHAR(55) NULL ,
          ClientAddress2 VARCHAR(55) NULL ,
          ClientCity VARCHAR(30) NULL ,
          ClientState VARCHAR(2) NULL ,
          ClientZip VARCHAR(15) NULL ,
          ClientCountryCode VARCHAR(3) NULL ,
          ClientDOB VARCHAR(35) NULL ,
          ClientSex VARCHAR(1) NULL ,
          ClientIsSubscriber CHAR(1) NULL ,
          ClientIdQualifier VARCHAR(20) NULL ,
          ClientSecondaryId VARCHAR(155) NULL ,
          SubscriberHLSegment VARCHAR(MAX) NULL ,
          SubscriberSegment VARCHAR(MAX) NULL ,
          SubscriberPatientSegment VARCHAR(MAX) NULL ,
          SubscriberNM1Segment VARCHAR(MAX) NULL ,
          SubscriberN3Segment VARCHAR(MAX) NULL ,
          SubscriberN4Segment VARCHAR(MAX) NULL ,
          SubscriberDMGSegment VARCHAR(MAX) NULL ,
          SubscriberRefSegment VARCHAR(MAX) NULL ,
          PayerNM1Segment VARCHAR(MAX) NULL ,
          PayerN3Segment VARCHAR(MAX) NULL ,
          PayerN4Segment VARCHAR(MAX) NULL ,
          PayerRefSegment VARCHAR(MAX) NULL ,
          PayerRefNFSegment VARCHAR(MAX) NULL ,
          PayerRefG2Segment VARCHAR(MAX) NULL ,
          ResponsibleNM1Segment VARCHAR(MAX) NULL ,
          ResponsibleN3Segment VARCHAR(MAX) NULL ,
          ResponsibleN4Segment VARCHAR(MAX) NULL ,
          PatientHLSegment VARCHAR(MAX) NULL ,
          PatientPatSegment VARCHAR(MAX) NULL ,
          PatientNM1Segment VARCHAR(MAX) NULL ,
          PatientN3Segment VARCHAR(MAX) NULL ,
          PatientN4Segment VARCHAR(MAX) NULL ,
          PatientDMGSegment VARCHAR(MAX) NULL,  
		)   
  
    IF @@error <> 0
        GOTO error  
  
    CREATE TABLE #837Claims
        (
          UniqueId INT IDENTITY
                       NOT NULL ,
          RefSubscriberClientId INT NOT NULL ,
          ClaimLineId INT NOT NULL ,
          ClaimLineItemGroupId INT ,
          ToVoidClaimLineItemGroupId INT ,
          ClaimId VARCHAR(30) NULL ,
          NewClaimId INT NULL ,
          HierParentId INT NULL ,
          TotalAmount MONEY NULL ,
          PlaceOfService VARCHAR(2) NULL ,
          SubmissionReasonCode VARCHAR(1) NULL ,
          SignatureIndicator VARCHAR(1) NULL ,
          MedicareAssignCode VARCHAR(1) NULL ,
          BenefitsAssignCertificationIndicator VARCHAR(1) NULL ,
          ReleaseCode VARCHAR(1) NULL ,
          PatientSignatureCode VARCHAR(1) NULL ,
          RelatedCauses1Code VARCHAR(3) NULL ,
          RelatedCauses2Code VARCHAR(3) NULL ,
          RelatedCauses3Code VARCHAR(3) NULL ,
          AutoAccidentStateCode VARCHAR(2) NULL ,
          SpecialProgramIndicator VARCHAR(3) NULL ,
          ParticipationAgreement VARCHAR(1) NULL ,
          DelayReasonCode VARCHAR(2) NULL ,
          OrderDate VARCHAR(35) NULL ,
          InitialTreatmentDate VARCHAR(35) NULL ,
          ReferralDate VARCHAR(35) NULL ,
          LastSeenDate VARCHAR(35) NULL ,
          CurrentIllnessDate VARCHAR(35) NULL ,
          AcuteManifestationDate VARCHAR(185) NULL ,
          SimilarSymptomDate VARCHAR(375) NULL ,
          AccidentDate VARCHAR(375) NULL ,
          EstimatedBirthDate VARCHAR(35) NULL ,
          PrescriptionDate VARCHAR(35) NULL ,
          DisabilityFromDate VARCHAR(185) NULL ,
          DisabilityToDate VARCHAR(185) NULL ,
          LastWorkedDate VARCHAR(35) NULL ,
          WorkReturnDate VARCHAR(35) NULL ,
          RelatedHospitalAdmitDate VARCHAR(35) NULL ,
          RelatedHospitalDischargeDate VARCHAR(35) NULL ,
          PatientAmountPaid MONEY NULL ,
          TotalPurchasedServiceAmount MONEY NULL ,
          ServiceAuthorizationExceptionCode VARCHAR(30) NULL ,
          PriorAuthorizationNumber VARCHAR(65) NULL ,
          PayerClaimControlNumber VARCHAR(80) NULL ,
          CLIANumber VARCHAR(50) NULL ,
          MedicalRecordNumber VARCHAR(30) NULL ,
          DiagnosisQualifier1 VARCHAR(3) NULL ,
          DiagnosisQualifier2 VARCHAR(3) NULL ,
          DiagnosisQualifier3 VARCHAR(3) NULL ,
          DiagnosisQualifier4 VARCHAR(3) NULL ,
          DiagnosisQualifier5 VARCHAR(3) NULL ,
          DiagnosisQualifier6 VARCHAR(3) NULL ,
          DiagnosisQualifier7 VARCHAR(3) NULL ,
          DiagnosisQualifier8 VARCHAR(3) NULL ,
          DiagnosisCode1 VARCHAR(30) NULL ,
          DiagnosisCode2 VARCHAR(30) NULL ,
          DiagnosisCode3 VARCHAR(30) NULL ,
          DiagnosisCode4 VARCHAR(30) NULL ,
          DiagnosisCode5 VARCHAR(30) NULL ,
          DiagnosisCode6 VARCHAR(30) NULL ,
          DiagnosisCode7 VARCHAR(30) NULL ,
          DiagnosisCode8 VARCHAR(30) NULL ,
          ReferringEntityCode VARCHAR(10) NULL ,
          ReferringEntityQualifier VARCHAR(5) NULL ,
          ReferringLastName VARCHAR(75) NULL ,
          ReferringFirstName VARCHAR(55) NULL ,
          ReferringMiddleName VARCHAR(55) NULL ,
          ReferringSuffix VARCHAR(25) NULL ,
          ReferringIdQualifier VARCHAR(5) NULL ,
          ReferringId VARCHAR(165) NULL ,
          ReferringTaxonomyCode VARCHAR(65) NULL ,
          ReferringSecondaryQualifier VARCHAR(10) NULL ,
          ReferringSecondaryId VARCHAR(65) NULL ,
          ReferringSecondaryQualifier2 VARCHAR(10) NULL ,
          ReferringSecondaryId2 VARCHAR(65) NULL ,
          ReferringSecondaryQualifier3 VARCHAR(10) NULL ,
          ReferringSecondaryId3 VARCHAR(65) NULL ,
          RenderingEntityQualifier VARCHAR(1) NULL ,
          RenderingLastName VARCHAR(35) NULL ,
          RenderingFirstName VARCHAR(25) NULL ,
          RenderingMiddleName VARCHAR(25) NULL ,
          RenderingSuffix VARCHAR(10) NULL ,
          RenderingEntityCode VARCHAR(2) NULL ,
          RenderingIdQualifier VARCHAR(2) NULL ,
          RenderingId VARCHAR(80) NULL ,
          RenderingTaxonomyCode VARCHAR(30) NULL ,
          RenderingSecondaryQualifier VARCHAR(20) NULL ,
          RenderingSecondaryId VARCHAR(160) NULL ,
          RenderingSecondaryQualifier2 VARCHAR(20) NULL ,
          RenderingSecondaryId2 VARCHAR(160) NULL ,
          RenderingSecondaryQualifier3 VARCHAR(20) NULL ,
          RenderingSecondaryId3 VARCHAR(160) NULL ,
          ServicesEntityQualifier VARCHAR(1) NULL ,
          ServicesIdQualifier VARCHAR(2) NULL ,
          ServicesId VARCHAR(80) NULL ,
          servicesSecondaryQualifier VARCHAR(20) NULL ,
          servicesSecondaryId VARCHAR(160) NULL ,
          FacilityEntityCode VARCHAR(2) NULL ,
          FacilityName VARCHAR(35) NULL ,
          FacilityIdQualifier VARCHAR(2) NULL ,
          FacilityId VARCHAR(80) NULL ,
          FacilityAddress1 VARCHAR(55) NULL ,
          FacilityAddress2 VARCHAR(55) NULL ,
          FacilityCity VARCHAR(30) NULL ,
          FacilityState VARCHAR(2) NULL ,
          FacilityZip VARCHAR(15) NULL ,
          FacilityCountryCode VARCHAR(3) NULL ,
          FacilitySecondaryQualifier VARCHAR(3) NULL ,
          FacilitySecondaryId VARCHAR(30) NULL ,
          FacilitySecondaryQualifier2 VARCHAR(3) NULL ,
          FacilitySecondaryId2 VARCHAR(30) NULL ,
          FacilitySecondaryQualifier3 VARCHAR(3) NULL ,
          FacilitySecondaryId3 VARCHAR(30) NULL ,
          SupervisingProvider2310DLastName VARCHAR(60) NULL ,
          SupervisingProvider2310DFirstName VARCHAR(35) NULL ,
          SupervisingProvider2310DMiddleName VARCHAR(25) NULL ,
          SupervisingProvider2310DIdType VARCHAR(2) NULL ,
          SupervisingProvider2310DId VARCHAR(80) NULL ,
          SupervisingProvider2310DSecondaryIdType1 VARCHAR(3) NULL ,
          SupervisingProvider2310DSecondaryId1 VARCHAR(50) NULL ,
          SupervisingProvider2310DSecondaryIdType2 VARCHAR(3) NULL ,
          SupervisingProvider2310DSecondaryId2 VARCHAR(50) NULL ,
          SupervisingProvider2310DSecondaryIdType3 VARCHAR(3) NULL ,
          SupervisingProvider2310DSecondaryId3 VARCHAR(50) NULL ,
          SupervisingProvider2310DSecondaryIdType4 VARCHAR(3) NULL ,
          SupervisingProvider2310DSecondaryId4 VARCHAR(50) NULL ,
          SupervisorLastName VARCHAR(35) NULL ,
          SupervisorFirstName VARCHAR(25) NULL ,
          SupervisorMiddleName VARCHAR(25) NULL ,
          SupervisorSuffix VARCHAR(10) NULL ,
          SupervisorQualifier VARCHAR(2) NULL ,
          SupervisorId VARCHAR(80) NULL ,
          [ClaimNoteReferenceCode] [VARCHAR](80) NULL ,
          [ClaimNote] [VARCHAR](MAX) NULL ,
          CLMSegment VARCHAR(MAX) NULL ,
          ReferralDateDTPSegment VARCHAR(MAX) NULL ,
          AdmissionDateDTPSegment VARCHAR(MAX) NULL ,
          DischargeDateDTPSegment VARCHAR(MAX) NULL ,
          PatientAmountPaidSegment VARCHAR(MAX) NULL ,
          AuthorizationNumberRefSegment VARCHAR(MAX) NULL ,
          PayerClaimControlNumberRefSegment VARCHAR(MAX) NULL ,
          CLIANumberRefSegment VARCHAR(50) NULL ,
          MedicalRecordNumberRefSegment VARCHAR(MAX) NULL ,
          HISegment VARCHAR(MAX) NULL ,
          ReferringNM1Segment VARCHAR(MAX) NULL ,
          ReferringRefSegment VARCHAR(MAX) NULL ,
          ReferringRef2Segment VARCHAR(MAX) NULL ,
          ReferringRef3Segment VARCHAR(MAX) NULL ,
          RenderingNM1Segment VARCHAR(MAX) NULL ,
          RenderingPRVSegment VARCHAR(MAX) NULL ,
          RenderingRefSegment VARCHAR(MAX) NULL ,
          RenderingRef2Segment VARCHAR(MAX) NULL ,
          RenderingRef3Segment VARCHAR(MAX) NULL ,
          FacilityNM1Segment VARCHAR(MAX) NULL ,
          FacilityN3Segment VARCHAR(MAX) NULL ,
          FacilityN4Segment VARCHAR(MAX) NULL ,
          FacilityRefSegment VARCHAR(MAX) NULL ,
          FacilityRef2Segment VARCHAR(MAX) NULL ,
          FacilityRef3Segment VARCHAR(MAX) NULL ,
          Supervising2310DNM1Segment VARCHAR(MAX) NULL ,
          Supervising2310DREF1Segment VARCHAR(MAX) NULL ,
          Supervising2310DREF2Segment VARCHAR(MAX) NULL ,
          Supervising2310DREF3Segment VARCHAR(MAX) NULL ,
          Supervising2310DREF4Segment VARCHAR(MAX) NULL ,
          CoveragePlanId INT NULL ,
          [AttendingPRVSegment] VARCHAR(MAX) NULL ,
          [NTESegment] VARCHAR(MAX) NULL
        )   
  
    IF @@error <> 0
        GOTO error  
  
    CREATE TABLE #837OtherInsureds
        (
          UniqueId INT IDENTITY
                       NOT NULL ,
          RefClaimId INT NOT NULL ,
          --RefServiceId INT NOT NULL ,
          ClaimLineId INT NULL ,
          Priority INT NULL ,
          PayerSequenceNumber VARCHAR(1) NULL ,
          SubscriberRelationshipCode VARCHAR(2) NULL ,
          GroupNumber VARCHAR(30) NULL ,
          GroupName VARCHAR(60) NULL ,
          InsuranceTypeCode VARCHAR(3) NULL ,
          ClaimFilingIndicatorCode VARCHAR(2) NULL ,
          AdjustmentGroupCode VARCHAR(15) NULL ,
          AdjustmentReasonCode1 VARCHAR(30) NULL ,
          AdjustmentAmount1 VARCHAR(100) NULL ,
          AdjustmentQuantity1 VARCHAR(80) NULL ,
          AdjustmentReasonCode2 VARCHAR(30) NULL ,
          AdjustmentAmount2 VARCHAR(100) NULL ,
          AdjustmentQuantity2 VARCHAR(80) NULL ,
          AdjustmentReasonCode3 VARCHAR(30) NULL ,
          AdjustmentAmount3 VARCHAR(100) NULL ,
          AdjustmentQuantity3 VARCHAR(80) NULL ,
          AdjustmentReasonCode4 VARCHAR(30) NULL ,
          AdjustmentAmount4 VARCHAR(100) NULL ,
          AdjustmentQuantity4 VARCHAR(80) NULL ,
          AdjustmentReasonCode5 VARCHAR(30) NULL ,
          AdjustmentAmount5 VARCHAR(100) NULL ,
          AdjustmentQuantity5 VARCHAR(80) NULL ,
          AdjustmentReasonCode6 VARCHAR(30) NULL ,
          AdjustmentAmount6 VARCHAR(100) NULL ,
          AdjustmentQuantity6 VARCHAR(80) NULL ,
          PayerPaidAmount MONEY NULL ,
          TotalPayerPaidAmount MONEY NULL ,
          PayerAllowedAmount MONEY NULL ,
          TotalPayerAllowedAmount MONEY NULL ,
          PatientResponsibilityAmount MONEY NULL ,
          InsuredDOB VARCHAR(35) NULL ,
          InsuredSex VARCHAR(1) NULL ,
          BenefitsAssignCertificationIndicator VARCHAR(1) NULL ,
          PatientSignatureSourceCode VARCHAR(1) NULL ,
          InformationReleaseCode VARCHAR(1) NULL ,
          InsuredQualifier VARCHAR(2) NULL ,
          InsuredLastName VARCHAR(35) NULL ,
          InsuredFirstName VARCHAR(25) NULL ,
          InsuredMiddleName VARCHAR(25) NULL ,
          InsuredSuffix VARCHAR(10) NULL ,
          InsuredIdQualifier VARCHAR(2) NULL ,
          InsuredId VARCHAR(80) NULL ,
          InsuredAddress1 VARCHAR(55) NULL ,
          InsuredAddress2 VARCHAR(55) NULL ,
          InsuredCity VARCHAR(30) NULL ,
          InsuredState VARCHAR(2) NULL ,
          InsuredZip VARCHAR(15) NULL ,
          InsuredSecondaryQualifier VARCHAR(3) NULL ,
          InsuredSecondaryId VARCHAR(30) NULL ,
          PayerName VARCHAR(35) NULL ,
          PayerQualifier VARCHAR(2) NULL ,
          PayerId VARCHAR(80) NULL ,
		  PayerAddress1 VARCHAR(55) NULL,
		  PayerAddress2 VARCHAR(55) NULL,
		  PayerCity VARCHAR(30) NULL,
		  PayerState VARCHAR (2) NULL ,
		  PayerZip Varchar(15) NULL,
          PaymentDate VARCHAR(35) NULL ,
          PayerSecondaryQualifier VARCHAR(10) NULL ,
          PayerSecondaryId VARCHAR(65) NULL ,
          PayerAuthorizationQualifier VARCHAR(10) NULL ,
          PayerAuthorizationNumber VARCHAR(65) NULL ,
          SubscriberSegment VARCHAR(MAX) NULL ,
          PayerPaidAmountSegment VARCHAR(MAX) NULL ,
          PayerAllowedAmountSegment VARCHAR(MAX) NULL ,
          PatientResponsbilityAmountSegment VARCHAR(MAX) NULL ,
          DMGSegment VARCHAR(MAX) NULL ,
          OISegment VARCHAR(MAX) NULL ,
          OINM1Segment VARCHAR(MAX) NULL ,
          OIN3Segment VARCHAR(MAX) NULL ,
          OIN4Segment VARCHAR(MAX) NULL ,
          OIRefSegment VARCHAR(MAX) NULL ,
          PayerNM1Segment VARCHAR(MAX) NULL ,
		  PayerN3Segment VARCHAR(Max) NULL,
		  PayerN4Segment VARCHAR(MAX) NULL,
          PayerPaymentDTPSegment VARCHAR(MAX) NULL ,
          PayerRefSegment VARCHAR(MAX) NULL , --srf 1/19/2012 added for Harbor MACSIS  
          AuthorizationNumberRefSegment VARCHAR(MAX) NULL ,
		)   

		CREATE TABLE #837OtherInsuredClaimLines
		(
		  UniqueId INT IDENTITY NOT NULL ,
		  ClaimLineId int NOT NULL ,
		  [Priority] INT NOT NULL,
          SVDSegment VARCHAR(MAX) NULL ,
          CAS1Segment VARCHAR(MAX) NULL ,
          CAS2Segment VARCHAR(MAX) NULL ,
          CAS3Segment VARCHAR(MAX) NULL ,
          CAS4Segment VARCHAR(MAX) NULL ,
          ServiceAdjudicationDTPSegment VARCHAR(MAX) NULL,  
		)
  
    
    IF @@error <> 0
        GOTO error  
  
    CREATE TABLE #837OtherInsuredsGrouping
        (
          UniqueId INT IDENTITY
                       NOT NULL ,
          RefClaimId INT NOT NULL ,
          SubscriberSegment VARCHAR(MAX) NULL ,
          PayerPaidAmountSegment VARCHAR(MAX) NULL ,
          PayerAllowedAmountSegment VARCHAR(MAX) NULL ,
          PatientResponsbilityAmountSegment VARCHAR(MAX) NULL ,
          DMGSegment VARCHAR(MAX) NULL ,
          OISegment VARCHAR(MAX) NULL ,
          OINM1Segment VARCHAR(MAX) NULL ,
          OIN3Segment VARCHAR(MAX) NULL ,
          OIN4Segment VARCHAR(MAX) NULL ,
          OIRefSegment VARCHAR(MAX) NULL ,
          PayerNM1Segment VARCHAR(MAX) NULL ,
		  PayerN3Segment VARCHAR(Max) NULL ,
		  PayerN4Segment VARCHAR(Max) NULL ,
          PayerPaymentDTPSegment VARCHAR(MAX) NULL ,
          PayerRefSegment VARCHAR(MAX) NULL ,
          AuthorizationNumberRefSegment VARCHAR(MAX) NULL ,
		)
    
  
    IF @@error <> 0
        GOTO error  
        
    CREATE TABLE #837Services
        (
          UniqueId INT IDENTITY
                       NOT NULL ,
          RefClaimId INT NOT NULL ,
          ClaimLineId INT ,
          ServiceLineCounter INT NULL ,
          ServiceIdQualifier VARCHAR(2) NULL ,
          BillingCode VARCHAR(48) NULL ,
          Modifier1 VARCHAR(2) NULL ,
          Modifier2 VARCHAR(2) NULL ,
          Modifier3 VARCHAR(2) NULL ,
          Modifier4 VARCHAR(2) NULL ,
          BillingCodeDescription VARCHAR(50) NULL ,
          LineItemChargeAmount MONEY NULL ,
          UnitOfMeasure VARCHAR(2) NULL ,
          ServiceUnitCount VARCHAR(15) NULL ,
          PlaceOfService VARCHAR(2) NULL ,
          DiagnosisCodePointer1 VARCHAR(2) NULL ,
          DiagnosisCodePointer2 VARCHAR(2) NULL ,
          DiagnosisCodePointer3 VARCHAR(2) NULL ,
          DiagnosisCodePointer4 VARCHAR(2) NULL ,
          DiagnosisCodePointer5 VARCHAR(2) NULL ,
          DiagnosisCodePointer6 VARCHAR(2) NULL ,
          DiagnosisCodePointer7 VARCHAR(2) NULL ,
          DiagnosisCodePointer8 VARCHAR(2) NULL ,
          EmergencyIndicator VARCHAR(1) NULL ,
          CopayStatusCode VARCHAR(1) NULL ,
          ServiceDateQualifier VARCHAR(3) NULL ,
          ServiceDate VARCHAR(35) NULL ,
          ReferralDate VARCHAR(35) NULL ,
          CurrentIllnessDate VARCHAR(35) NULL ,
          PriorAuthorizationReferenceQualifier VARCHAR(10) NULL ,
          PriorAuthorizationReferenceNumber VARCHAR(65) NULL ,
          LineItemControlNumber VARCHAR(50) NULL ,
		  RenderingEntityCode VARCHAR(10) NULL,
          RenderingEntityQualifier VARCHAR(1) NULL ,
          RenderingLastName VARCHAR(35) NULL ,
          RenderingFirstName VARCHAR(25) NULL ,
          RenderingMiddleName VARCHAR(25) NULL ,
          RenderingSuffix VARCHAR(10) NULL ,
          RenderingIdQualifier VARCHAR(2) NULL ,
          RenderingId VARCHAR(80) NULL ,
          RenderingTaxonomyCode VARCHAR(30) NULL ,
          RenderingSecondaryQualifier VARCHAR(20) NULL ,
          RenderingSecondaryId VARCHAR(160) NULL ,
          ServicesEntityQualifier VARCHAR(1) NULL ,
          ServicesIdQualifier VARCHAR(2) NULL ,
          ServicesId VARCHAR(80) NULL ,
          servicesSecondaryQualifier VARCHAR(20) NULL ,
          servicesSecondaryId VARCHAR(160) NULL ,
          FacilityEntityCode VARCHAR(2) NULL ,
          FacilityName VARCHAR(35) NULL ,
          FacilityIdQualifier VARCHAR(2) NULL ,
          FacilityId VARCHAR(80) NULL ,
          FacilityAddress1 VARCHAR(55) NULL ,
          FacilityAddress2 VARCHAR(55) NULL ,
          FacilityCity VARCHAR(30) NULL ,
          FacilityState VARCHAR(2) NULL ,
          FacilityZip VARCHAR(15) NULL ,
          FacilityCountryCode VARCHAR(3) NULL ,
          FacilitySecondaryQualifier VARCHAR(3) NULL ,
          FacilitySecondaryId VARCHAR(30) NULL ,
          SupervisorLastName VARCHAR(35) NULL ,
          SupervisorFirstName VARCHAR(25) NULL ,
          SupervisorMiddleName VARCHAR(25) NULL ,
          SupervisorSuffix VARCHAR(10) NULL ,
          SupervisorQualifier VARCHAR(2) NULL ,
          SupervisorId VARCHAR(80) NULL ,
          ReferringEntityCode VARCHAR(3) NULL ,
          ReferringEntityQualifier VARCHAR(1) NULL ,
          ReferringLastName VARCHAR(35) NULL ,
          ReferringFirstName VARCHAR(25) NULL ,
          ReferringMiddleName VARCHAR(25) NULL ,
          ReferringSuffix VARCHAR(10) NULL ,
          ReferringIdQualifier VARCHAR(2) NULL ,
          ReferringId VARCHAR(80) NULL ,
          ReferringTaxonomyCode VARCHAR(30) NULL ,
          ReferringSecondaryQualifier VARCHAR(3) NULL ,
          ReferringSecondaryId VARCHAR(30) NULL ,
          PayerName VARCHAR(150) NULL ,
          PayerIdQualifier VARCHAR(15) NULL ,
          PayerId VARCHAR(325) NULL ,
          PayerReferenceIdQualifier VARCHAR(20) NULL ,
          PayerPriorAuthorizationNumber VARCHAR(125) NULL ,
          ApprovedAmount MONEY NULL ,
          [ServiceNoteReferenceCode] [VARCHAR](15) NULL ,
          [ServiceNote] [VARCHAR](MAX) NULL ,
          LXSegment VARCHAR(MAX) NULL ,
          SV1Segment VARCHAR(MAX) NULL ,
          ServiceDateDTPSegment VARCHAR(MAX) NULL ,
          ReferralDateDTPSegment VARCHAR(MAX) NULL ,
          LineItemControlRefSegment VARCHAR(MAX) NULL ,
          ProviderAuthorizationRefSegment VARCHAR(MAX) NULL ,
          FacilityNM1Segment VARCHAR(MAX) NULL ,
          FacilityN3Segment VARCHAR(MAX) NULL ,
          FacilityN4Segment VARCHAR(MAX) NULL ,
          FacilityRefSegment VARCHAR(MAX) NULL ,
          SupervisorNM1Segment VARCHAR(MAX) NULL ,
          ReferringNM1Segment VARCHAR(MAX) NULL ,
          PayerNM1Segment VARCHAR(MAX) NULL ,
          ApprovedAmountSegment VARCHAR(MAX) NULL ,
          K3Segment VARCHAR(MAX) NULL ,
          [ServiceNTESegment] VARCHAR(MAX) NULL ,
          ContractInformationSegment VARCHAR(MAX) NULL,
		  RenderingNM1Segment VARCHAR(MAX) NULL,
		  RenderingPRVSegment VARCHAR(MAX) NULL,
		  RenderingRefSegment VARCHAR(MAX) NULL,
          OrderingNM1Segment VARCHAR(MAX) NULL,
		  OrderingN3Segment VARCHAR(MAX) NULL,
		  OrderingN4Segment VARCHAR(MAX) NULL,
		  OrderingREFSegment VARCHAR(MAX) NULL,
		  OrderingPERSegment VARCHAR(MAX) NULL,
		  OrderingProviderLastName VARCHAR(MAX) NULL,
		  OrderingProviderFirstName VARCHAR(MAX) NULL,
		  OrderingProviderMiddleName VARCHAR(MAX) NULL,
		  OrderingProviderNameSuffix VARCHAR(MAX) NULL,
		  OrderingProviderIdentifier VARCHAR(MAX) NULL,
		  OrderingProviderAddress1 VARCHAR(MAX) NULL,
		  OrderingProviderAddress2 VARCHAR(MAX) NULL,
		  OrderingProviderCity VARCHAR(MAX) NULL,
		  OrderingProviderState VARCHAR(MAX) NULL,
		  OrderingProviderZip VARCHAR(MAX) NULL,
		  OrderingProviderSecondaryIdQualifier VARCHAR(MAX) NULL,
		  OrderingProviderSecondaryIdentifier VARCHAR(MAX) NULL,
		  OrderingProviderContactName VARCHAR(MAX) NULL,
		  OrderingProviderCommNumberQualifier1 VARCHAR(MAX) NULL,
		  OrderingProviderCommNumber1 VARCHAR(MAX) NULL,
		  OrderingProviderCommNumberQualifier2 VARCHAR(MAX) NULL,
		  OrderingProviderCommNumber2 VARCHAR(MAX) NULL,
		  OrderingProviderCommNumberQualifier3 VARCHAR(MAX) NULL,
		  OrderingProviderCommNumber3 VARCHAR(MAX) NULL
        )   
  
    IF @@error <> 0
        GOTO error  
  
  
--NEW**  
    CREATE TABLE #837DrugIdentification
        (
          UniqueId INT IDENTITY
                       NOT NULL ,
          RefServiceId INT NOT NULL ,
          NationalDrugCodeQualifier VARCHAR(2) NULL ,
          NationalDrugCode VARCHAR(30) NULL ,
          DrugUnitPrice MONEY NULL ,
          DrugCodeUnitCount VARCHAR(15) NULL ,
          DrugUnitOfMeasure VARCHAR(15) NULL ,
          LINSegment VARCHAR(MAX) NULL ,
          CTPSegment VARCHAR(MAX) NULL
        )  
   
  
    IF @@error <> 0
        GOTO error  
         
  
    CREATE TABLE #837HeaderTrailer
        (
          TransactionSetControlNumberHeader VARCHAR(9) NULL ,
          TransactionSetPurposeCode VARCHAR(2) NULL ,
          ApplicationTransactionId VARCHAR(30) NULL ,
          CreationDate VARCHAR(8) NULL ,
          CreationTime VARCHAR(4) NULL ,
          EncounterId VARCHAR(2) NULL ,
          TransactionTypeCode VARCHAR(30) NULL ,
          SubmitterEntityQualifier VARCHAR(1) NULL ,
          SubmitterLastName VARCHAR(60) NULL ,
          SubmitterFirstName VARCHAR(25) NULL ,
          SubmitterMiddleName VARCHAR(25) NULL ,
          SubmitterId VARCHAR(80) NULL ,
          SubmitterContactName VARCHAR(125) NULL ,
          SubmitterCommNumber1Qualifier VARCHAR(5) NULL ,
          SubmitterCommNumber1 VARCHAR(165) NULL ,
          SubmitterCommNumber2Qualifier VARCHAR(5) NULL ,
          SubmitterCommNumber2 VARCHAR(165) NULL ,
          SubmitterCommNumber3Qualifier VARCHAR(5) NULL ,
          SubmitterCommNumber3 VARCHAR(165) NULL ,
          ReceiverLastName VARCHAR(35) NULL ,
          ReceiverPrimaryId VARCHAR(80) NULL ,
          TransactionSegmentCount VARCHAR(20) NULL ,
          TransactionSetControlNumberTrailer VARCHAR(9) NULL ,
          STSegment VARCHAR(MAX) NULL ,
          BHTSegment VARCHAR(MAX) NULL ,
          TransactionTypeRefSegment VARCHAR(MAX) NULL ,
          SubmitterNM1Segment VARCHAR(MAX) NULL ,
          SubmitterPerSegment VARCHAR(MAX) NULL ,
          ReceiverNm1Segment VARCHAR(MAX) NULL ,
          SESegment VARCHAR(MAX) NULL ,
          ImplementationConventionReference VARCHAR(20) NULL
        )  
  
    IF @@error <> 0
        GOTO error  
  
    CREATE TABLE #HIPAAHeaderTrailer
        (
          AuthorizationIdQualifier VARCHAR(2) NULL ,
          AuthorizationId VARCHAR(10) NULL ,
          SecurityIdQualifier VARCHAR(2) NULL ,
          SecurityId VARCHAR(10) NULL ,
          InterchangeSenderQualifier VARCHAR(2) NULL ,
          InterchangeSenderId VARCHAR(15) NULL ,
          InterchangeReceiverQualifier VARCHAR(2) NULL ,
          InterchangeReceiverId VARCHAR(15) NULL ,
          InterchangeDate VARCHAR(6) NULL ,
          InterchangeTime VARCHAR(4) NULL ,
          InterchangeControlStandardsId VARCHAR(1) NULL ,
          InterchangeControlVersionNumber VARCHAR(5) NULL ,
          InterchangeControlNumberHeader VARCHAR(9) NULL ,
          AcknowledgeRequested VARCHAR(1) NULL ,
          UsageIndicator VARCHAR(1) NULL ,
          ComponentSeparator VARCHAR(10) NULL ,
          FunctionalIdCode VARCHAR(2) NULL ,
          ApplicationSenderCode VARCHAR(15) NULL ,
          ApplicationReceiverCode VARCHAR(15) NULL ,
          FunctionalDate VARCHAR(8) NULL ,
          FunctionalTime VARCHAR(4) NULL ,
          GroupControlNumberHeader VARCHAR(9) NULL ,
          ResponsibleAgencyCode VARCHAR(2) NULL ,
          VersionCode VARCHAR(12) NULL ,
          NumberOfTransactions VARCHAR(6) NULL ,
          GroupControlNumberTrailer VARCHAR(9) NULL ,
          NumberOfGroups VARCHAR(6) NULL ,
          InterchangeControlNumberTrailer VARCHAR(9) NULL ,
          InterchangeHeaderSegment VARCHAR(MAX) NULL ,
          FunctionalHeaderSegment VARCHAR(MAX) NULL ,
          FunctionalTrailerSegment VARCHAR(MAX) NULL ,
          InterchangeTrailerSegment VARCHAR(MAX) NULL,  
		)  
  
    IF @@error <> 0
        GOTO error  
        
        
        -- HCFA tables
    CREATE TABLE #ClaimGroupsData
        (
          ClaimGroupId INT NOT NULL ,
          PayerNameAndAddress VARCHAR(250) NULL ,
          Field1Medicare CHAR(1) NULL ,
          Field1Medicaid CHAR(1) NULL ,
          Field1Champus CHAR(1) NULL ,
          Field1Champva CHAR(1) NULL ,
          Field1GroupHealthPlan CHAR(1) NULL ,
          Field1GroupFeca CHAR(1) NULL ,
          Field1GroupOther CHAR(1) NULL ,
          Field1aInsuredNumber VARCHAR(25) NULL ,
          Field2PatientName VARCHAR(50) NULL ,
          Field3PatientDOBMM CHAR(2) NULL ,
          Field3PatientDOBDD CHAR(2) NULL ,
          Field3PatientDOBYY VARCHAR(4) NULL ,
          Field3PatientMale CHAR(1) NULL ,
          Field3PatientFemale CHAR(1) NULL ,
          Field4InsuredName VARCHAR(50) NULL ,
          Field5PatientAddress VARCHAR(50) NULL ,
          Field5PatientCity VARCHAR(50) NULL ,
          Field5PatientState CHAR(2) NULL ,
          Field5PatientZip VARCHAR(12) NULL ,
          Field5PatientPhone VARCHAR(15) NULL ,
          Field6RelationshipSelf CHAR(1) NULL ,
          Field6RelationshipSpouse CHAR(1) NULL ,
          Field6RelationshipChild CHAR(1) NULL ,
          Field6RelationshipOther CHAR(1) NULL ,
          Field7InsuredAddress VARCHAR(50) NULL ,
          Field7InsuredCity VARCHAR(50) NULL ,
          Field7InsuredState CHAR(2) NULL ,
          Field7InsuredZip VARCHAR(12) NULL ,
          Field7InsuredPhone VARCHAR(15) NULL ,
          Field8PatientStatusSingle CHAR(1) NULL ,
          Field8PatientStatusMarried CHAR(1) NULL ,
          Field8PatientStatusOther CHAR(1) NULL ,
          Field8PatientStatusEmployed CHAR(1) NULL ,
          Field8PatientStatusFullTime CHAR(1) NULL ,
          Field8PatientStatusPartTime CHAR(1) NULL ,
          Field9OtherInsuredName VARCHAR(50) NULL ,
          Field9OtherInsuredGroupNumber VARCHAR(50) NULL ,
          Field9OtherInsuredDOBMM CHAR(2) NULL ,
          Field9OtherInsuredDOBDD CHAR(2) NULL ,
          Field9OtherInsuredDOBYY VARCHAR(4) NULL ,
          Field9OtherInsuredMale CHAR(1) NULL ,
          Field9OtherInsuredFemale CHAR(1) NULL ,
          Field9OtherInsuredEmployer VARCHAR(50) NULL ,
          Field9OtherInsuredPlan VARCHAR(50) NULL ,
          Field10aYes CHAR(1) NULL ,
          Field10aNo CHAR(1) NULL ,
          Field10bYes CHAR(1) NULL ,
          Field10bNo CHAR(1) NULL ,
          Field10cYes CHAR(1) NULL ,
          Field10cNo CHAR(1) NULL ,
          Field10d VARCHAR(50) NULL ,
          Field11InsuredGroupNumber VARCHAR(50) NULL ,
          Field11InsuredDOBMM CHAR(2) NULL ,
          Field11InsuredDOBDD CHAR(2) NULL ,
          Field11InsuredDOBYY VARCHAR(4) NULL ,
          Field11InsuredMale CHAR(1) NULL ,
          Field11InsuredFemale CHAR(1) NULL ,
          Field11InsuredEmployer VARCHAR(50) NULL ,
          Field11InsuredPlan VARCHAR(50) NULL ,
          Field11OtherPlanYes CHAR(1) NULL ,
          Field11OtherPlanNo CHAR(1) NULL ,
          Field12Signed VARCHAR(25) NULL ,
          Field12Date VARCHAR(12) NULL ,
          Field13Signed VARCHAR(25) NULL ,
          Field14InjuryMM CHAR(2) NULL ,
          Field14InjuryDD CHAR(2) NULL ,
          Field14InjuryYY VARCHAR(4) NULL ,
          Field15FirstInjuryMM CHAR(2) NULL ,
          Field15FirstInjuryDD CHAR(2) NULL ,
          Field15FirstInjuryYY VARCHAR(4) NULL ,
          Field16FromMM CHAR(2) NULL ,
          Field16FromDD CHAR(2) NULL ,
          Field16FromYY VARCHAR(4) NULL ,
          Field16ToMM CHAR(2) NULL ,
          Field16ToDD CHAR(2) NULL ,
          Field16ToYY VARCHAR(4) NULL ,
          Field17ReferringName VARCHAR(25) NULL ,
          Field17aReferringIdQualifier VARCHAR(2) NULL ,
          Field17aReferringId VARCHAR(25) NULL ,
          Field17bReferringNPI VARCHAR(10) NULL ,
          Field18FromMM CHAR(2) NULL ,
          Field18FromDD CHAR(2) NULL ,
          Field18FromYY VARCHAR(4) NULL ,
          Field18ToMM CHAR(2) NULL ,
          Field18ToDD CHAR(2) NULL ,
          Field18ToYY VARCHAR(4) NULL ,
          Field19 VARCHAR(50) NULL ,
          Field20LabYes CHAR(1) NULL ,
          Field20LabNo CHAR(1) NULL ,
          Field20Charges1 VARCHAR(7) NULL ,
          Field20Charges2 VARCHAR(2) NULL ,
          Field21Diagnosis11 VARCHAR(3) NULL ,
          Field21Diagnosis12 VARCHAR(4) NULL ,
          Field21Diagnosis21 VARCHAR(3) NULL ,
          Field21Diagnosis22 VARCHAR(4) NULL ,
          Field21Diagnosis31 VARCHAR(3) NULL ,
          Field21Diagnosis32 VARCHAR(4) NULL ,
          Field21Diagnosis41 VARCHAR(3) NULL ,
          Field21Diagnosis42 VARCHAR(4) NULL ,
          Field21ICDIndicator CHAR(2) NULL ,
          Field22MedicaidResubmissionCode VARCHAR(25) NULL ,
          Field22MedicaidReferenceNumber VARCHAR(25) NULL ,
          Field23AuthorizationNumber VARCHAR(35) NULL ,
          Field24aFromMM1 CHAR(2) NULL ,
          Field24aFromDD1 CHAR(2) NULL ,
          Field24aFromYY1 VARCHAR(4) NULL ,
          Field24aToMM1 CHAR(2) NULL ,
          Field24aToDD1 CHAR(2) NULL ,
          Field24aToYY1 VARCHAR(4) NULL ,
          Field24bPlaceOfService1 CHAR(2) NULL ,
          Field24cEMG1 VARCHAR(3) NULL ,
          Field24dProcedureCode1 VARCHAR(15) NULL ,
          Field24dModifier11 VARCHAR(2) NULL ,
          Field24dModifier21 VARCHAR(2) NULL ,
          Field24dModifier31 VARCHAR(2) NULL ,
          Field24dModifier41 VARCHAR(2) NULL ,
          Field24eDiagnosisCode1 VARCHAR(20) NULL ,
          Field24fCharges11 VARCHAR(10) NULL ,
          Field24fCharges21 VARCHAR(2) NULL ,
          Field24gUnits1 VARCHAR(3) NULL ,
          Field24hEPSDT1 VARCHAR(3) NULL ,
          Field24iRenderingIdQualifier1 VARCHAR(2) NULL ,
          Field24jRenderingId1 VARCHAR(25) NULL ,
          Field24jRenderingNPI1 VARCHAR(10) NULL ,
          Field24aFromMM2 CHAR(2) NULL ,
          Field24aFromDD2 CHAR(2) NULL ,
          Field24aFromYY2 VARCHAR(4) NULL ,
          Field24aToMM2 CHAR(2) NULL ,
          Field24aToDD2 CHAR(2) NULL ,
          Field24aToYY2 VARCHAR(4) NULL ,
          Field24bPlaceOfService2 CHAR(2) NULL ,
          Field24cEMG2 VARCHAR(3) NULL ,
          Field24dProcedureCode2 VARCHAR(15) NULL ,
          Field24dModifier12 VARCHAR(2) NULL ,
          Field24dModifier22 VARCHAR(2) NULL ,
          Field24dModifier32 VARCHAR(2) NULL ,
          Field24dModifier42 VARCHAR(2) NULL ,
          Field24eDiagnosisCode2 VARCHAR(20) NULL ,
          Field24fCharges12 VARCHAR(10) NULL ,
          Field24fCharges22 VARCHAR(2) NULL ,
          Field24gUnits2 VARCHAR(3) NULL ,
          Field24hEPSDT2 VARCHAR(3) NULL ,
          Field24iRenderingIdQualifier2 VARCHAR(2) NULL ,
          Field24jRenderingId2 VARCHAR(25) NULL ,
          Field24jRenderingNPI2 VARCHAR(10) NULL ,
          Field24aFromMM3 CHAR(2) NULL ,
          Field24aFromDD3 CHAR(2) NULL ,
          Field24aFromYY3 VARCHAR(4) NULL ,
          Field24aToMM3 CHAR(2) NULL ,
          Field24aToDD3 CHAR(2) NULL ,
          Field24aToYY3 VARCHAR(4) NULL ,
          Field24bPlaceOfService3 CHAR(2) NULL ,
          Field24cEMG3 VARCHAR(3) NULL ,
          Field24dProcedureCode3 VARCHAR(15) NULL ,
          Field24dModifier13 VARCHAR(2) NULL ,
          Field24dModifier23 VARCHAR(2) NULL ,
          Field24dModifier33 VARCHAR(2) NULL ,
          Field24dModifier43 VARCHAR(2) NULL ,
          Field24eDiagnosisCode3 VARCHAR(20) NULL ,
          Field24fCharges13 VARCHAR(10) NULL ,
          Field24fCharges23 VARCHAR(2) NULL ,
          Field24gUnits3 VARCHAR(3) NULL ,
          Field24hEPSDT3 VARCHAR(3) NULL ,
          Field24iRenderingIdQualifier3 VARCHAR(2) NULL ,
          Field24jRenderingId3 VARCHAR(25) NULL ,
          Field24jRenderingNPI3 VARCHAR(10) NULL ,
          Field24aFromMM4 CHAR(2) NULL ,
          Field24aFromDD4 CHAR(2) NULL ,
          Field24aFromYY4 VARCHAR(4) NULL ,
          Field24aToMM4 CHAR(2) NULL ,
          Field24aToDD4 CHAR(2) NULL ,
          Field24aToYY4 VARCHAR(4) NULL ,
          Field24bPlaceOfService4 CHAR(2) NULL ,
          Field24cEMG4 VARCHAR(3) NULL ,
          Field24dProcedureCode4 VARCHAR(15) NULL ,
          Field24dModifier14 VARCHAR(2) NULL ,
          Field24dModifier24 VARCHAR(2) NULL ,
          Field24dModifier34 VARCHAR(2) NULL ,
          Field24dModifier44 VARCHAR(2) NULL ,
          Field24eDiagnosisCode4 VARCHAR(20) NULL ,
          Field24fCharges14 VARCHAR(10) NULL ,
          Field24fCharges24 VARCHAR(2) NULL ,
          Field24gUnits4 VARCHAR(3) NULL ,
          Field24hEPSDT4 VARCHAR(3) NULL ,
          Field24iRenderingIdQualifier4 VARCHAR(2) NULL ,
          Field24jRenderingId4 VARCHAR(25) NULL ,
          Field24jRenderingNPI4 VARCHAR(10) NULL ,
          Field24aFromMM5 CHAR(2) NULL ,
          Field24aFromDD5 CHAR(2) NULL ,
          Field24aFromYY5 VARCHAR(4) NULL ,
          Field24aToMM5 CHAR(2) NULL ,
          Field24aToDD5 CHAR(2) NULL ,
          Field24aToYY5 VARCHAR(4) NULL ,
          Field24bPlaceOfService5 CHAR(2) NULL ,
          Field24cEMG5 VARCHAR(3) NULL ,
          Field24dProcedureCode5 VARCHAR(15) NULL ,
          Field24dModifier15 VARCHAR(2) NULL ,
          Field24dModifier25 VARCHAR(2) NULL ,
          Field24dModifier35 VARCHAR(2) NULL ,
          Field24dModifier45 VARCHAR(2) NULL ,
          Field24eDiagnosisCode5 VARCHAR(20) NULL ,
          Field24fCharges15 VARCHAR(10) NULL ,
          Field24fCharges25 VARCHAR(2) NULL ,
          Field24gUnits5 VARCHAR(3) NULL ,
          Field24hEPSDT5 VARCHAR(3) NULL ,
          Field24iRenderingIdQualifier5 VARCHAR(2) NULL ,
          Field24jRenderingId5 VARCHAR(25) NULL ,
          Field24jRenderingNPI5 VARCHAR(10) NULL ,
          Field24aFromMM6 CHAR(2) NULL ,
          Field24aFromDD6 CHAR(2) NULL ,
          Field24aFromYY6 VARCHAR(4) NULL ,
          Field24aToMM6 CHAR(2) NULL ,
          Field24aToDD6 CHAR(2) NULL ,
          Field24aToYY6 VARCHAR(4) NULL ,
          Field24bPlaceOfService6 CHAR(2) NULL ,
          Field24cEMG6 VARCHAR(3) NULL ,
          Field24dProcedureCode6 VARCHAR(15) NULL ,
          Field24dModifier16 VARCHAR(2) NULL ,
          Field24dModifier26 VARCHAR(2) NULL ,
          Field24dModifier36 VARCHAR(2) NULL ,
          Field24dModifier46 VARCHAR(2) NULL ,
          Field24eDiagnosisCode6 VARCHAR(20) NULL ,
          Field24fCharges16 VARCHAR(10) NULL ,
          Field24fCharges26 VARCHAR(2) NULL ,
          Field24gUnits6 VARCHAR(3) NULL ,
          Field24hEPSDT6 VARCHAR(3) NULL ,
          Field24iRenderingIdQualifier6 VARCHAR(2) NULL ,
          Field24jRenderingId6 VARCHAR(25) NULL ,
          Field24jRenderingNPI6 VARCHAR(10) NULL ,
          Field25TaxId VARCHAR(11) NULL ,
          Field25SSN CHAR(1) NULL ,
          Field25EIN CHAR(1) NULL ,
          Field26PatientAccountNo VARCHAR(25) NULL ,
          Field27AssignmentYes CHAR(1) NULL ,
          Field27AssignmentNo CHAR(1) NULL ,
          Field28fTotalCharges1 VARCHAR(10) NULL ,
          Field28fTotalCharges2 VARCHAR(2) NULL ,
          Field29Paid1 VARCHAR(10) NULL ,
          Field29Paid2 VARCHAR(2) NULL ,
          Field30Balance1 VARCHAR(10) NULL ,
          Field30Balance2 VARCHAR(2) NULL ,
          Field31Signed VARCHAR(30) NULL ,
          Field31Date VARCHAR(10) NULL ,
          Field32Facility VARCHAR(100) NULL ,
          Field32aFacilityNPI VARCHAR(10) NULL ,
          Field32bFacilityProviderId VARCHAR(25) NULL ,
          Field33BillingPhone VARCHAR(20) NULL ,
          Field33BillingAddress VARCHAR(100) NULL ,
          Field33aNPI VARCHAR(10) NULL ,
          Field33bBillingProviderId VARCHAR(25) NULL ,    
		)     
    
    IF @@error <> 0
        GOTO error    
        
    CREATE TABLE #ProcedureCodesToBundleAfterCombiningSameDayServices
        (
          CoveragePlanId INT NOT NULL ,
          ProcedureCodeId INT NOT NULL ,
		  AppliesToAllProcedureCodes CHAR(1) NOT NULL ,
          RuleId INT NOT NULL
        )    
        
        
    IF @@error <> 0
        GOTO error  
        
    UPDATE  dbo.ClaimBatches
    SET     BatchProcessProgress = 0
    WHERE   ClaimBatchId = @ParamClaimBatchId  
  
    IF @@error <> 0
        GOTO error  
  
    DECLARE @CurrentDate DATETIME  
    DECLARE @ErrorNumber INT 
    DECLARE @ErrorMessage NVARCHAR(MAX) 
    DECLARE @ClaimFormatId INT  
    DECLARE @Electronic CHAR(1) --- Y or N
    DECLARE @FormatType CHAR(1) --- I or P  
  
    SET @CurrentDate = GETDATE()  
    
    
    SELECT  @ClaimFormatId = a.ClaimFormatId ,
            @Electronic = b.Electronic ,
            @FormatType = 'P'
    FROM    dbo.ClaimBatches a
            JOIN dbo.ClaimFormats b ON ( a.ClaimFormatId = b.ClaimFormatId )
            LEFT JOIN dbo.GlobalCodes gc ON ( b.FormatType = gc.GlobalCodeId )
    WHERE   a.ClaimBatchId = @ParamClaimBatchId
    
    
    
    IF @@error <> 0
        GOTO error
    
    -- Validate Claim Formats and Agency information for electronic claims  
---- Updated 3/17 to use the GetMessageByCode functiuon
    IF @Electronic = 'Y'
        BEGIN
            IF EXISTS ( SELECT  *
                        FROM    dbo.Agency
                        WHERE   AgencyName IS NULL
                                OR BillingContact IS NULL
                                OR BillingPhone IS NULL )
                BEGIN
                    SET @ErrorNumber = 30001
                    SET @ErrorMessage = ( SELECT    dbo.Ssf_GetMesageByMessageCode(29, 'ABBMISSINGFROMAGENCY_SSP', 'Agency Name, Billing Contact and Billing Contact Phone are missing from Agency. Please set values and rerun claims')
                                        )
                    GOTO error
                END

            IF EXISTS ( SELECT  *
                        FROM    dbo.ClaimFormats
                        WHERE   ClaimFormatId = @ClaimFormatId
                                AND ( BillingLocationCode IS NULL
                                      OR ReceiverCode IS NULL
                                      OR ReceiverPrimaryId IS NULL
                                      OR ProductionOrTest IS NULL
                                      OR Version IS NULL
                                    ) )
                BEGIN
                    SET @ErrorNumber = 30001
                    SET @ErrorMessage = ( SELECT    dbo.Ssf_GetMesageByMessageCode(29, 'BRRPVREQ_SSP', 'Billing Location Code, Receiver Code, Receiver Primary Id, Production or Test and Version are required in Claim Formats for electronic claims. Please set values and rerun claims')
                                        )
                    GOTO error
                END
            IF EXISTS ( SELECT  1
                        FROM    dbo.ClaimBatches cb
                        WHERE   cb.ClaimBatchId = @ParamClaimBatchId
                                AND ( cb.BilledDate IS NOT NULL
                                      OR cb.Status = 4524
                                    ) )
                BEGIN
                    SET @ErrorNumber = 30001
                    SET @ErrorMessage = ( SELECT    dbo.Ssf_GetMesageByMessageCode(29, 'CLAIMBATCHALREADYBILLED', 'This Claim Batch has been billed and can not be reprocessed.')
                                        )
                    GOTO error
                END          
        END 
	
	
	
	
	-- Fetch the add on service, if not selected in the batch
    IF EXISTS ( SELECT  1
                FROM    dbo.ClaimBatchCharges a
                        JOIN dbo.ClaimBatches b ON b.ClaimBatchId = a.ClaimBatchId
                        JOIN dbo.Charges c ON c.ChargeId = a.ChargeId
                        JOIN dbo.ClientCoveragePlans c2 ON c2.ClientCoveragePlanId = c.ClientCoveragePlanId
                        JOIN dbo.Services d ON d.ServiceId = c.ServiceId
                        JOIN dbo.ServiceAddOnCodes e ON e.ServiceId = d.ServiceId
                        JOIN dbo.Services f ON f.ServiceId = e.AddOnServiceId
                        JOIN dbo.Charges g ON g.ServiceId = f.ServiceId
                        JOIN dbo.ClientCoveragePlans g2 ON g2.ClientCoveragePlanId = g.ClientCoveragePlanId
                        JOIN dbo.CoveragePlans g3 ON g3.CoveragePlanId = g2.CoveragePlanId
                        LEFT JOIN dbo.ClaimBatchCharges h ON h.ChargeId = g.ChargeId
                                                             AND h.ClaimBatchId = @ClaimBatchId
                                                             AND ISNULL(h.RecordDeleted, 'N') = 'N'
                WHERE   a.ClaimBatchId = @ClaimBatchId
                        AND f.Status = 75
                        AND g2.CoveragePlanId = c2.CoveragePlanId
                        AND g.ReadyToBill = 'Y'
                        AND h.ChargeId IS NULL
                        AND ISNULL(g3.AddOnChargesOption, '') IN ( 'A', 'B' )
                        AND ISNULL(a.RecordDeleted, 'N') = 'N'
                        AND ISNULL(b.RecordDeleted, 'N') = 'N'
                        AND ISNULL(c.RecordDeleted, 'N') = 'N'
                        AND ISNULL(d.RecordDeleted, 'N') = 'N'
                        AND ISNULL(e.RecordDeleted, 'N') = 'N'
                        AND ISNULL(f.RecordDeleted, 'N') = 'N'
                        AND ISNULL(g.RecordDeleted, 'N') = 'N'
                        AND ISNULL(g2.RecordDeleted, 'N') = 'N' )
        BEGIN 
				
            INSERT  INTO ClaimBatchCharges
                    ( ClaimBatchId ,
                      ChargeId ,
                      CreatedBy ,
                      ModifiedBy
                    )
                    SELECT  DISTINCT
                            a.ClaimBatchId ,
                            g.ChargeId ,
                            @CurrentUser ,
                            @CurrentUser
                    FROM    dbo.ClaimBatchCharges a
                            JOIN dbo.ClaimBatches b ON b.ClaimBatchId = a.ClaimBatchId
                            JOIN dbo.Charges c ON c.ChargeId = a.ChargeId
                            JOIN dbo.ClientCoveragePlans c2 ON c2.ClientCoveragePlanId = c.ClientCoveragePlanId
                            JOIN dbo.Services d ON d.ServiceId = c.ServiceId
                            JOIN dbo.ServiceAddOnCodes e ON e.ServiceId = d.ServiceId
                            JOIN dbo.Services f ON f.ServiceId = e.AddOnServiceId
                            JOIN dbo.Charges g ON g.ServiceId = f.ServiceId
                            JOIN dbo.ClientCoveragePlans g2 ON g2.ClientCoveragePlanId = g.ClientCoveragePlanId
                            JOIN dbo.CoveragePlans g3 ON g3.CoveragePlanId = g2.CoveragePlanId
                            LEFT JOIN dbo.ClaimBatchCharges h ON h.ChargeId = g.ChargeId
                                                                 AND h.ClaimBatchId = @ClaimBatchId
                                                                 AND ISNULL(h.RecordDeleted, 'N') = 'N'
                    WHERE   a.ClaimBatchId = @ClaimBatchId
                            AND f.Status = 75
                            AND g2.CoveragePlanId = c2.CoveragePlanId
                            AND g.ReadyToBill = 'Y'
                            AND h.ChargeId IS NULL
                            AND ISNULL(g3.AddOnChargesOption, '') IN ( 'A', 'B' )
                            AND NOT EXISTS ( SELECT *
                                             FROM   dbo.ClaimBatchCharges a2
                                             WHERE  a2.ClaimBatchId = a.ClaimBatchId
                                                    AND a2.ChargeId = g.ChargeId
                                                    AND ISNULL(a2.RecordDeleted, 'N') = 'N' )
                            AND ISNULL(a.RecordDeleted, 'N') = 'N'
                            AND ISNULL(b.RecordDeleted, 'N') = 'N'
                            AND ISNULL(c.RecordDeleted, 'N') = 'N'
                            AND ISNULL(d.RecordDeleted, 'N') = 'N'
                            AND ISNULL(e.RecordDeleted, 'N') = 'N'
                            AND ISNULL(f.RecordDeleted, 'N') = 'N'
                            AND ISNULL(g.RecordDeleted, 'N') = 'N'
                            AND ISNULL(g2.RecordDeleted, 'N') = 'N'

        END	
	
	
	-- voids
    CREATE TABLE #ClaimBatchVoids
        (
          ClaimLineItemGroupId INT ,
          PayerClaimControlNumber VARCHAR(MAX)
        )

    INSERT  INTO #ClaimBatchVoids
            ( ClaimLineItemGroupId ,
              PayerClaimControlNumber
			)
            SELECT  cli.ClaimLineItemGroupId ,
                    COALESCE(MAX(ecli2.PayerClaimNumber), MAX(ecli.PayerClaimNumber), MAX(clig.PayerClaimNumber))
            FROM    dbo.ClaimBatches AS curbatch
                    JOIN dbo.ClaimBatchCharges AS cbc ON cbc.ClaimBatchId = curbatch.ClaimBatchId
                                                         AND ISNULL(cbc.RecordDeleted, 'N') <> 'Y'
                    JOIN dbo.ClaimLineItemCharges AS clic ON clic.ChargeId = cbc.ChargeId
                                                             AND ISNULL(clic.RecordDeleted, 'N') <> 'Y'
                    JOIN dbo.ClaimLineItems AS cli ON cli.ClaimLineItemId = clic.ClaimLineItemId
                                                      AND ( ISNULL(cli.VoidedClaim, 'N') <> 'Y'
                                                            OR NOT EXISTS ( SELECT  1
                                                                            FROM    dbo.ClaimLineItems voidclaim
                                                                                    JOIN dbo.ClaimLineItemGroups voidclaimgroup ON voidclaimgroup.ClaimLineItemGroupId = voidclaim.ClaimLineItemGroupId
                                                                                    JOIN dbo.ClaimBatches voidclaimbatch ON voidclaimbatch.ClaimBatchId = voidclaimgroup.ClaimBatchId
                                                                                                                            AND ISNULL(voidclaimbatch.RecordDeleted, 'N') <> 'Y'
                                                                                                                            AND voidclaimbatch.BilledDate IS NOT NULL
                                                                            WHERE   voidclaim.OriginalClaimLineItemId = cli.ClaimLineItemId
                                                                                    AND ISNULL(voidclaim.VoidedClaim, 'N') = 'Y' )
                                                          )
                                                      AND ISNULL(cli.RecordDeleted, 'N') <> 'Y'
                                                      AND ISNULL(cli.ToBeVoided, 'N') = 'Y'
                    JOIN dbo.ClaimLineItemGroups AS clig ON clig.ClaimLineItemGroupId = cli.ClaimLineItemGroupId
                                                            AND ISNULL(clig.RecordDeleted, 'N') <> 'Y'
                    JOIN dbo.ClaimBatches AS ToVoidBatch ON ToVoidBatch.ClaimBatchId = clig.ClaimBatchId
                                                            AND ISNULL(ToVoidBatch.RecordDeleted, 'N') <> 'Y'
                                                            AND ToVoidBatch.BilledDate IS NOT NULL
                    LEFT JOIN dbo.ERClaimLineItemCharges AS eclic ON eclic.ChargeId = cbc.ChargeId
                    LEFT JOIN dbo.ERClaimLineItems AS ecli2 ON eclic.ERClaimLineItemId = ecli2.ERClaimLineItemId
                    LEFT JOIN dbo.ERClaimLineItems AS ecli ON ecli.ClaimLineItemId = cli.ClaimLineItemId
                                                              AND ISNULL(ecli.RecordDeleted, 'N') <> 'Y'
            WHERE   curbatch.ClaimBatchId = @ParamClaimBatchId
            GROUP BY cli.ClaimLineItemGroupId


    CREATE TABLE #ClaimBatchClaimSubmissions
        (
          ChargeId INT ,
          SubmissionReasonCode VARCHAR(1) ,
          PayerClaimControlNumber VARCHAR(MAX) ,
          VoidedClaimLineItemId INT ,
          ClaimLineItemGroupId INT ,
          Replacement CHAR(1)
        )



    INSERT  INTO #ClaimBatchClaimSubmissions
            ( ChargeId ,
              SubmissionReasonCode ,
              PayerClaimControlNumber ,
              VoidedClaimLineItemId
	        )
            SELECT  clic.ChargeId-- ChargeId - int
                    ,
                    '8'-- SubmissionReasonCode - varchar(1)
                    ,
                    NULL-- PayerClaimControlNumber - varchar(max)
                    ,
                    cli.ClaimLineItemId-- VoidedClaimLineItemId - int
            FROM    #ClaimBatchVoids cbv
                    JOIN dbo.ClaimLineItems cli ON cli.ClaimLineItemGroupId = cbv.ClaimLineItemGroupId
                                                   AND ISNULL(cli.RecordDeleted, 'N') <> 'Y'
                    JOIN dbo.ClaimLineItemCharges clic ON clic.ClaimLineItemId = cli.ClaimLineItemId
                                                          AND ISNULL(clic.RecordDeleted, 'N') <> 'Y'
            WHERE   NOT EXISTS ( SELECT 1
                                 FROM   ClaimLineItemGroupStoredData cligsd
                                 WHERE  cligsd.ClaimLineItemGroupId = cbv.ClaimLineItemGroupId
                                        AND ISNULL(cligsd.RecordDeleted, 'N') <> 'Y' )
                    AND NOT EXISTS ( SELECT 1
                                     FROM   dbo.ClaimNPIHCFA1500s chcfa
                                     WHERE  chcfa.ClaimLineItemGroupId = cbv.ClaimLineItemGroupId
                                            AND ISNULL(chcfa.RecordDeleted, 'N') <> 'Y' )

    DELETE  cbv
    FROM    #ClaimBatchVoids cbv
    WHERE   NOT EXISTS ( SELECT 1
                         FROM   ClaimLineItemGroupStoredData cligsd
                         WHERE  cligsd.ClaimLineItemGroupId = cbv.ClaimLineItemGroupId
                                AND ISNULL(cligsd.RecordDeleted, 'N') <> 'Y' )
            AND NOT EXISTS ( SELECT 1
                             FROM   dbo.ClaimNPIHCFA1500s chcfa
                             WHERE  chcfa.ClaimLineItemGroupId = cbv.ClaimLineItemGroupId
                                    AND ISNULL(chcfa.RecordDeleted, 'N') <> 'Y' )
									-- 1 new claim
									-- 7 replacment claim
									-- 8 void
    INSERT  INTO #ClaimBatchClaimSubmissions
            ( ChargeId ,
              SubmissionReasonCode ,
              PayerClaimControlNumber ,
              VoidedClaimLineItemId
			)
			-- where 835 has been received
            SELECT  cbc.ChargeId ,
                    '7' ,
                    NULL ,
                    MAX(er.ClaimLineItemId) --+ '00'  
            FROM    ClaimBatchCharges cbc
                    JOIN Charges ch ON cbc.ChargeId = ch.ChargeId
                    JOIN Charges ch2 ON ( ch.ChargeId = ch2.ChargeId
										OR EXISTS ( SELECT	1
													FROM	dbo.DocumentMoves dm
													WHERE	dm.ServiceIdTo = ch.ServiceId
															AND ch.ClientCoveragePlanId = ch2.ClientCoveragePlanId
															AND ch2.ServiceId = dm.ServiceIdFrom
															AND ISNULL(dm.RecordDeleted, 'N') <> 'Y' )
										)
										AND ISNULL(ch2.RecordDeleted, 'N') <> 'Y'
  -- 835 was received for the charge  
                    JOIN ERClaimLineItemCharges clic ON clic.ChargeId = ch2.ChargeId
                                                        AND ISNULL(clic.RecordDeleted, 'N') = 'N'
                    JOIN ERClaimLineItems er ON er.ERClaimLineItemId = clic.ERClaimLineItemId
                                                AND ISNULL(er.RecordDeleted, 'N') = 'N'
                                                AND er.ClaimLineItemId IS NOT NULL			
  -- Charge was previously sent  
                    JOIN dbo.ClaimLineItems AS cli ON cli.ClaimLineItemId = er.ClaimLineItemId
                                                      AND ISNULL(cli.VoidedClaim, 'N') <> 'Y'
                                                      AND ISNULL(cli.ToBeVoided, 'N') <> 'Y'
                                                      AND ISNULL(cli.RecordDeleted, 'N') <> 'Y'
                                                      AND ISNULL(cli.ToBeResubmitted, 'N') = 'Y'  -- to be resubmitted is required.
                    JOIN dbo.ClaimLineItemGroups AS clig ON clig.ClaimLineItemGroupId = cli.ClaimLineItemGroupId
                                                            AND ISNULL(clig.RecordDeleted, 'N') <> 'Y'
																	 -- this might be redundant because we're already checking to be voided on claim lines
                                                            AND NOT EXISTS ( SELECT 1
                                                                             FROM   #ClaimBatchVoids cbv
                                                                             WHERE  cbv.ClaimLineItemGroupId = clig.ClaimLineItemGroupId )
                    JOIN dbo.ClaimBatches AS cb ON cb.ClaimBatchId = clig.ClaimBatchId
                                                   AND ISNULL(cb.RecordDeleted, 'N') <> 'Y'
                                                   AND cb.BilledDate IS NOT NULL
            WHERE   cbc.ClaimBatchId = @ParamClaimBatchId
                    AND ISNULL(cbc.RecordDeleted, 'N') = 'N'
            GROUP BY cbc.ChargeId

			-- where 835 has not been received
    INSERT  INTO #ClaimBatchClaimSubmissions
            ( ChargeId ,
              SubmissionReasonCode ,
              PayerClaimControlNumber ,
              VoidedClaimLineItemId
					
					
            )
            SELECT  cbc.ChargeId ,
                    '7' ,
                    NULL ,
                    MAX(cli.ClaimLineItemId) --+ '00'  
            FROM    dbo.ClaimBatchCharges cbc
                    JOIN dbo.Charges ch ON cbc.ChargeId = ch.ChargeId
                    --JOIN dbo.Charges ch2 ON ch.ChargeId = ch2.ChargeId
					JOIN dbo.Charges ch2 ON ( ch.ChargeId = ch2.ChargeId
												OR EXISTS ( SELECT	1
															FROM	dbo.DocumentMoves dm
															WHERE	dm.ServiceIdTo = ch.ServiceId
																	AND ch.ClientCoveragePlanId = ch2.ClientCoveragePlanId
																	AND ch2.ServiceId = dm.ServiceIdFrom
																	AND ISNULL(dm.RecordDeleted, 'N') <> 'Y' )
											)
											AND ISNULL(ch2.RecordDeleted, 'N') <> 'Y'
					JOIN dbo.ClaimLineItemCharges AS clic ON clic.ChargeId = ch2.ChargeId
                                                             AND ISNULL(clic.RecordDeleted, 'N') <> 'Y'
                    JOIN dbo.ClaimLineItems AS cli ON cli.ClaimLineItemId = clic.ClaimLineItemId
                                                      AND ISNULL(cli.VoidedClaim, 'N') <> 'Y'
                                                      AND ISNULL(cli.ToBeVoided, 'N') <> 'Y'
                                                      AND ISNULL(cli.RecordDeleted, 'N') <> 'Y'
                                                      AND ISNULL(cli.ToBeResubmitted, 'N') = 'Y'  -- to be resubmitted is required.
                    JOIN dbo.ClaimLineItemGroups AS clig ON clig.ClaimLineItemGroupId = cli.ClaimLineItemGroupId
                                                            AND ISNULL(clig.RecordDeleted, 'N') <> 'Y'
																	 -- this might be redundant because we're already checking to be voided on claim lines
                                                            AND NOT EXISTS ( SELECT 1
                                                                             FROM   #ClaimBatchVoids cbv
                                                                             WHERE  cbv.ClaimLineItemGroupId = clig.ClaimLineItemGroupId )
                    JOIN dbo.ClaimBatches AS cb ON cb.ClaimBatchId = clig.ClaimBatchId
                                                   AND ISNULL(cb.RecordDeleted, 'N') <> 'Y'
                                                   AND cb.BilledDate IS NOT NULL
            WHERE   NOT EXISTS ( SELECT 1
                                 FROM   #ClaimBatchClaimSubmissions AS cbcs
                                 WHERE  cbcs.ChargeId = cbc.ChargeId )
                    AND cbc.ClaimBatchId = @ParamClaimBatchId
                    AND ISNULL(cbc.RecordDeleted, 'N') = 'N'
            GROUP BY cbc.ChargeId

	-- very lowest priority is the ERClaimLineItem through the ClaimLineItemId on ERClaimLineItems

	UPDATE	cbcs
	SET		PayerClaimControlNumber = ecli.PayerClaimNumber
	FROM	#ClaimBatchClaimSubmissions cbcs
			JOIN dbo.ERClaimLineItems ecli ON cbcs.VoidedClaimLineItemId = ecli.ClaimLineItemId
				AND ISNULL(ecli.RecordDeleted,'N') <> 'Y'

	-- next highest is ClaimLineItemGroup going through the ClaimLineItemId
	UPDATE	cbcs
	SET		PayerClaimControlNumber = clig.PayerClaimNumber
	FROM	#ClaimBatchClaimSubmissions cbcs
			JOIN ClaimLineItems cli ON cbcs.VoidedClaimLineItemId = cli.ClaimLineItemId
			JOIN dbo.ClaimLineItemGroups clig ON clig.ClaimLineItemGroupId = cli.ClaimLineItemGroupId
	WHERE NULLIF(RTRIM(LTRIM(clig.PayerClaimNumber)),'') IS NOT NULL 

	-- next highest priority is the claim line item group going through the claimlineitemcharges table
    UPDATE  cbcs
    SET     PayerClaimControlNumber = clig.PayerClaimNumber
    FROM    #ClaimBatchClaimSubmissions AS cbcs
            JOIN dbo.ClaimLineItemCharges AS clic ON clic.ChargeId = cbcs.ChargeId
                                                     AND clic.ClaimLineItemId = cbcs.VoidedClaimLineItemId
            JOIN dbo.ClaimLineItems AS cli ON cli.ClaimLineItemId = clic.ClaimLineItemId
            JOIN dbo.ClaimLineItemGroups AS clig ON clig.ClaimLineItemGroupId = cli.ClaimLineItemGroupId
	WHERE NULLIF(RTRIM(LTRIM(clig.PayerClaimNumber)),'') IS NOT NULL 

   -- next highest priority is the claim line item joined to the ERClaimLineItems directly

     UPDATE cbcs
     SET    PayerClaimControlNumber = ecli.PayerClaimNumber
     FROM   #ClaimBatchClaimSubmissions AS cbcs
            JOIN ERClaimLineItems ecli
               ON ecli.ClaimLineItemId = cbcs.VoidedClaimLineItemId
                  AND ISNULL(ecli.RecordDeleted, 'N') <> 'Y'
     WHERE  ecli.PayerClaimNumber IS NOT NULL
            AND NOT EXISTS ( SELECT 1
                             FROM   ERClaimLineItems ecli2
                             WHERE  ISNULL(ecli2.RecordDeleted, 'N') <> 'Y'
                                    AND ecli2.ClaimLineItemId = cbcs.VoidedClaimLineItemId
                                    AND (
                                          DATEDIFF(DAY, ecli.CreatedDate, ecli2.CreatedDate) > 0
                                          OR (
                                               DATEDIFF(DAY, ecli.CreatedDate, ecli2.CreatedDate) = 0
                                               AND ecli.ERClaimLineItemId < ecli2.ERClaimLineItemId
                                             )
                                        )
                                    AND ecli2.PayerClaimNumber IS NOT NULL )


	-- next highest priority is the claim line item group going through erclaimlineitemcharges table
	-- 

    UPDATE  cbcs
    SET     cbcs.PayerClaimControlNumber = ISNULL(ecli.PayerClaimNumber, erclig.PayerClaimNumber)
    FROM    #ClaimBatchClaimSubmissions AS cbcs
            JOIN ERClaimLineItemCharges erclic ON erclic.ChargeId = cbcs.ChargeId
            JOIN dbo.ERClaimLineItems AS ecli ON erclic.ERClaimLineItemId = ecli.ERClaimLineItemId
                                                 AND ecli.ClaimLineItemId = cbcs.VoidedClaimLineItemId
            JOIN dbo.ClaimLineItems AS ercli ON ercli.ClaimLineItemId = ecli.ClaimLineItemId
            JOIN dbo.ClaimLineItemGroups AS erclig ON erclig.ClaimLineItemGroupId = ercli.ClaimLineItemGroupId
    WHERE   ecli.PayerClaimNumber IS NOT NULL
            OR erclig.PayerClaimNumber IS NOT NULL

    INSERT  INTO #ClaimBatchClaimSubmissions
            ( ChargeId ,
              SubmissionReasonCode ,
              PayerClaimControlNumber ,
              VoidedClaimLineItemId
			)
            SELECT  cbc.ChargeId ,
                    '1' ,
                    NULL ,
                    NULL
            FROM    dbo.ClaimBatchCharges cbc
            WHERE   cbc.ClaimBatchId = @ParamClaimBatchId
                    AND ISNULL(cbc.RecordDeleted, 'N') = 'N'
                    AND NOT EXISTS ( SELECT 1
                                     FROM   #ClaimBatchVoids AS cbv
                                            JOIN dbo.ClaimLineItemGroups clig ON clig.ClaimLineItemGroupId = cbv.ClaimLineItemGroupId
                                            JOIN dbo.ClaimLineItems cli ON cli.ClaimLineItemGroupId = clig.ClaimLineItemGroupId
                                            JOIN dbo.ClaimLineItemCharges clic ON clic.ClaimLineItemId = cli.ClaimLineItemId
                                                                                  AND clic.ChargeId = cbc.ChargeId )
                    AND NOT EXISTS ( SELECT 1
                                     FROM   #ClaimBatchClaimSubmissions AS cbcs
                                     WHERE  cbcs.ChargeId = cbc.ChargeId )

-- For voids, we need to include all of the original charges in the claim batch so billing history is updated properly

    INSERT  INTO dbo.ClaimBatchCharges
            ( ClaimBatchId ,
              ChargeId ,
              RowIdentifier ,
              CreatedBy ,
              CreatedDate ,
              ModifiedBy ,
              ModifiedDate
			)
            SELECT  @ParamClaimBatchId  -- ClaimBatchId - int
                    ,
                    clic.ChargeId-- ChargeId - int
                    ,
                    NEWID()-- RowIdentifier - type_GUID
                    ,
                    @ParamCurrentUser-- CreatedBy - type_CurrentUser
                    ,
                    @CurrentDate-- CreatedDate - type_CurrentDatetime
                    ,
                    @ParamCurrentUser-- ModifiedBy - type_CurrentUser
                    ,
                    @CurrentDate-- ModifiedDate - type_CurrentDatetime
            FROM    #ClaimBatchVoids AS cbv
                    JOIN dbo.ClaimLineItemGroups AS clig ON clig.ClaimLineItemGroupId = cbv.ClaimLineItemGroupId
                    JOIN dbo.ClaimLineItems AS cli ON cli.ClaimLineItemGroupId = clig.ClaimLineItemGroupId
                    JOIN dbo.ClaimLineItemCharges AS clic ON clic.ClaimLineItemId = cli.ClaimLineItemId
            WHERE   NOT EXISTS ( SELECT 1
                                 FROM   dbo.ClaimBatchCharges AS cbc
                                 WHERE  cbc.ChargeId = clic.ChargeId
                                        AND cbc.ClaimBatchId = @ParamClaimBatchId )
 
                

    INSERT  INTO #Charges
            ( ChargeId ,
              ClientId ,
              ClientLastName ,
              ClientFirstname ,
              ClientMiddleName ,
              ClientSSN ,
              ClientSuffix ,
              ClientDOB ,
              ClientSex ,
              ClientIsSubscriber ,
              SubscriberContactId ,
              MaritalStatus ,
              EmploymentStatus ,
                  --RegistrationDate ,
                  --DischargeDate ,
              ClientCoveragePlanId ,
              InsuredId ,
              GroupNumber ,
              GroupName ,
              InsuredLastName ,
              InsuredFirstName ,
              InsuredMiddleName ,
              InsuredSuffix ,
              InsuredRelation ,
              InsuredSex ,
              InsuredSSN ,
              InsuredDOB ,
              ServiceId ,
              DateOfService ,
              ProcedureCodeId ,
              ServiceUnits ,
              ServiceUnitType ,
              ProgramId ,
              LocationId ,
              ClinicianId ,
              ClinicianLastName ,
              ClinicianFirstName ,
              ClinicianMiddleName ,
              ClinicianSex ,
			  ClinicianDegree ,
              AttendingId ,
              Priority ,
              CoveragePlanId ,
              MedicaidPayer ,
              MedicarePayer ,
              PayerName ,
              PayerAddressHeading ,
              PayerAddress1 ,
              PayerAddress2 ,
              PayerCity ,
              PayerState ,
              PayerZip ,
              MedicareInsuranceTypeCode ,
              ClaimFilingIndicatorCode ,
              ElectronicClaimsPayerId ,
              ClaimOfficeNumber ,
              SubmissionReasonCode ,
              PayerClaimControlNumber ,
              VoidedClaimLineItemId ,
              ChargeAmount ,
              ReferringId ,
              FacilityName ,
              FacilityAddress1 ,
              FacilityAddress2 ,
              FacilityCity ,
              FacilityState ,
              FacilityZip ,
              FacilityPhone
			)
            SELECT  a.ChargeId ,
                    e.ClientId ,
                    e.LastName ,
                    e.FirstName ,
                    e.MiddleName ,
                    NULLIF(e.SSN, '999999999') ,
                    e.Suffix ,
                    e.DOB ,
                    e.Sex ,
                    d.ClientIsSubscriber ,
                    d.SubscriberContactId ,
                    e.MaritalStatus ,
                    e.EmploymentStatus ,
                        --i.RegistrationDate ,
                        --i.DischargeDate ,
                    d.ClientCoveragePlanId ,
                    REPLACE(REPLACE(d.InsuredId, '-', RTRIM('')), ' ', RTRIM('')) ,
                    d.GroupNumber ,
                    d.GroupName ,
                    CASE WHEN ISNULL(d.ClientIsSubscriber, 'N') = 'N' THEN NULL
                         ELSE e.LastName
                    END ,
                    CASE WHEN ISNULL(d.ClientIsSubscriber, 'N') = 'N' THEN NULL
                         ELSE e.FirstName
                    END ,
                    CASE WHEN ISNULL(d.ClientIsSubscriber, 'N') = 'N' THEN NULL
                         ELSE e.MiddleName
                    END ,
                    CASE WHEN ISNULL(d.ClientIsSubscriber, 'N') = 'N' THEN NULL
                         ELSE e.Suffix
                    END ,
                    NULL ,
                    CASE WHEN ISNULL(d.ClientIsSubscriber, 'N') = 'N' THEN NULL
                         ELSE e.Sex
                    END ,
                    CASE WHEN ISNULL(d.ClientIsSubscriber, 'N') = 'N' THEN NULL
                         ELSE NULLIF(e.SSN, '999999999')
                    END ,
                    CASE WHEN ISNULL(d.ClientIsSubscriber, 'N') = 'N' THEN NULL
                         ELSE e.DOB
                    END ,
                    c.ServiceId ,
                    c.DateOfService ,
                    c.ProcedureCodeId ,
                    c.Unit ,
                    c.UnitType ,
                    c.ProgramId ,
                    c.LocationId ,
                    c.ClinicianId ,
                    f.LastName ,
                    f.FirstName ,
                    f.MiddleName ,
                    f.Sex ,
					f.Degree ,
                    c.AttendingId ,
                    b.Priority ,
                    g.CoveragePlanId ,
                    g.MedicaidPlan ,
                    g.MedicarePlan ,
                    g.CoveragePlanName ,
                    g.CoveragePlanName ,
                    case when ISNULL(d.OverrideClaim, 'N') = 'Y' then 
                                CASE WHEN CHARINDEX(CHAR(13) + CHAR(10), d.ClaimAddress) = 0 THEN d.ClaimAddress  
                                    ELSE SUBSTRING(d.ClaimAddress, 1, CHARINDEX(CHAR(13) + CHAR(10), d.ClaimAddress) - 1)  
                                    END
						else
							case when ISNULL(d.OverrideClaim, 'N') = 'N' then 
                    CASE WHEN CHARINDEX(CHAR(13) + CHAR(10), g.Address) = 0 THEN g.Address
                         ELSE SUBSTRING(g.Address, 1, CHARINDEX(CHAR(13) + CHAR(10), g.Address) - 1)
                                 end
                            end
                    END ,
                     case when ISNULL(d.OverrideClaim, 'N') = 'Y' then 
                                CASE WHEN CHARINDEX(CHAR(13) + CHAR(10), d.ClaimAddress) = 0 THEN NULL  
                                    ELSE RIGHT(d.ClaimAddress, LEN(d.ClaimAddress) - CHARINDEX(CHAR(13) + CHAR(10), d.ClaimAddress) - 1)  
                                    END
						else
							case when ISNULL(d.OverrideClaim, 'N') = 'N' then 
                    CASE WHEN CHARINDEX(CHAR(13) + CHAR(10), g.Address) = 0 THEN NULL
                         ELSE RIGHT(g.Address, LEN(g.Address) - CHARINDEX(CHAR(13) + CHAR(10), g.Address) - 1)
                                   END
                          end
                    END ,
                    CASE WHEN ISNULL(d.OverrideClaim, 'N') = 'Y' THEN d.ClaimCity ELSE g.City end,  
                    CASE WHEN ISNULL(d.OverrideClaim, 'N') = 'Y' THEN d.ClaimState ELSE g.State end,  
                    CASE WHEN ISNULL(d.OverrideClaim, 'N') = 'Y' THEN d.ClaimZipCode ELSE g.ZipCode end, 
                    NULL/*d.MedicareInsuranceTypg1eCode*/ ,
                    k.ExternalCode1 ,
                    CASE WHEN ISNULL(d.OverrideClaim, 'N') = 'Y' THEN d.ElectronicClaimsPayerId ELSE g.ElectronicClaimsPayerId end,
                    CASE WHEN k.ExternalCode1 <> 'CI' THEN NULL
                         ELSE CASE WHEN RTRIM(g.ElectronicClaimsOfficeNumber) IN ( '', '0000' ) THEN NULL
                                   ELSE g.ElectronicClaimsOfficeNumber
                              END
                    END ,
                    a.SubmissionReasonCode ,
                    a.PayerClaimControlNumber ,
                    a.VoidedClaimLineItemId ,
                    c.Charge ,
                    c.ReferringId ,
                    l.LocationName ,
                    CASE WHEN CHARINDEX(CHAR(13) + CHAR(10), l.Address) = 0 THEN l.Address
                         ELSE SUBSTRING(l.Address, 1, CHARINDEX(CHAR(13) + CHAR(10), l.Address) - 1)
                    END ,
                    CASE WHEN CHARINDEX(CHAR(13) + CHAR(10), l.Address) = 0 THEN NULL
                         ELSE RIGHT(l.Address, LEN(l.Address) - CHARINDEX(CHAR(13) + CHAR(10), l.Address) - 1)
                    END ,
                    l.City ,
                    l.State ,
                    l.ZipCode ,
                    SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(l.PhoneNumber, ' ', RTRIM('')), '(', RTRIM('')), ')', RTRIM('')), '-', RTRIM('')), 1, 10)
            FROM    #ClaimBatchClaimSubmissions AS a
                    JOIN dbo.Charges b ON ( a.ChargeId = b.ChargeId
                                            --AND ISNULL(a.RecordDeleted, 'N') = 'N'
                                            AND ISNULL(b.RecordDeleted, 'N') = 'N'
                                          )
                    JOIN dbo.Services c ON ( b.ServiceId = c.ServiceId
                                             AND ISNULL(c.RecordDeleted, 'N') = 'N'
                                           )
                    JOIN dbo.ClientCoveragePlans d ON ( b.ClientCoveragePlanId = d.ClientCoveragePlanId
                                                      --  AND ISNULL(d.RecordDeleted, 'N') = 'N'
                                                        )
                    JOIN dbo.Clients e ON ( c.ClientId = e.ClientId
                                            AND ISNULL(e.RecordDeleted, 'N') = 'N'
                                          )
                    JOIN dbo.Staff f ON ( c.ClinicianId = f.StaffId
                                          AND ISNULL(f.RecordDeleted, 'N') = 'N'
                                        )
                    JOIN dbo.CoveragePlans g ON ( d.CoveragePlanId = g.CoveragePlanId
                                                  --AND ISNULL(g.RecordDeleted, 'N') = 'N'
                                                  )
                        /*LEFT JOIN ClientEpisodes i ON ( e.ClientId = i.ClientId
                                                        AND e.CurrentEpisodeNumber = i.EpisodeNumber
                                                        AND ISNULL(i.RecordDeleted, 'N') = 'N'
                                                      )*/
                    LEFT JOIN dbo.GlobalCodes k ON ( g.ClaimFilingIndicatorCode = k.GlobalCodeId )
                    LEFT JOIN dbo.Locations l ON ( c.LocationId = l.LocationId
                                                   AND ISNULL(l.RecordDeleted, 'N') = 'N'
                                                 )
                --WHERE   a.ClaimBatchId = @ParamClaimBatchId    

            

                     
    IF @@error <> 0
        GOTO error  

---- 6/18/2015 njain	Added Claim Overrides logic
--    UPDATE  a
--    SET     PayerName = b.CoveragePlanName ,
--            PayerAddressHeading = b.CoveragePlanName ,
--            PayerAddress1 = b.CoveragePlanName ,
--		--PayerAddress2 = 	
--            ElectronicClaimsPayerId = b.ElectronicClaimsPayerId ,
--            ClaimOfficeNumber = b.ElectronicClaimsOfficeNumber
--    FROM    #Charges a
--            JOIN dbo.ClientCoveragePlans b ON b.ClientCoveragePlanId = a.ClientCoveragePlanId
--                                              AND ISNULL(b.RecordDeleted, 'N') = 'N'
--    WHERE   ISNULL(b.OverrideClaim, 'N') = 'Y'        
        
        
    --IF @@error <> 0
    --    GOTO error  



-- Added 10/15/2014
	-- Set Registration and Discharge from ClientEpisodes
    UPDATE  ch
    SET     ch.RegistrationDate = ISNULL(ce.RegistrationDate, ce.InitialRequestDate) ,
            ch.DischargeDate = ce.DischargeDate
    FROM    dbo.ClientEpisodes ce
            JOIN #Charges ch ON ch.ClientId = ce.ClientId
    WHERE   ce.RegistrationDate <= ch.DateOfService
            AND ( ce.DischargeDate IS NULL
                  OR DATEADD(dd, 1, ce.DischargeDate) > ch.DateOfService
                )
            AND ISNULL(ce.RecordDeleted, 'N') = 'N'



	
        
          -- Get home address  
    UPDATE  ch
    SET     ch.ClientAddress1 = CASE WHEN CHARINDEX(CHAR(13) + CHAR(10), ca.Address) = 0 THEN ca.Address
                                     ELSE SUBSTRING(ca.Address, 1, CHARINDEX(CHAR(13) + CHAR(10), ca.Address) - 1)
                                END ,
            ch.ClientAddress2 = CASE WHEN CHARINDEX(CHAR(13) + CHAR(10), ca.Address) = 0 THEN NULL
                                     ELSE RIGHT(ca.Address, LEN(ca.Address) - CHARINDEX(CHAR(13) + CHAR(10), ca.Address) - 1)
                                END ,
            ch.ClientCity = ca.City ,
            ch.ClientState = ca.State ,
            ch.ClientZip = ca.Zip ,
            ch.InsuredAddress1 = CASE WHEN CHARINDEX(CHAR(13) + CHAR(10), ca.Address) = 0 THEN ca.Address
                                      ELSE SUBSTRING(ca.Address, 1, CHARINDEX(CHAR(13) + CHAR(10), ca.Address) - 1)
                                 END ,
            ch.InsuredAddress2 = CASE WHEN CHARINDEX(CHAR(13) + CHAR(10), ca.Address) = 0 THEN NULL
                                      ELSE RIGHT(ca.Address, LEN(ca.Address) - CHARINDEX(CHAR(13) + CHAR(10), ca.Address) - 1)
                                 END ,
            ch.InsuredCity = ca.City ,
            ch.InsuredState = ca.State ,
            ch.InsuredZip = ca.Zip
    FROM    #Charges ch
            JOIN dbo.ClientAddresses ca ON ca.ClientId = ch.ClientId
    WHERE   ca.AddressType = 90
            AND ISNULL(ca.RecordDeleted, 'N') = 'N'
            
            
            -- Get home phone  
    UPDATE  ch
    SET     ch.ClientHomePhone = SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(cp.PhoneNumberText, ' ', RTRIM('')), '(', RTRIM('')), ')', RTRIM('')), '-', RTRIM('')), 1, 10) ,
            ch.InsuredHomePhone = SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(cp.PhoneNumberText, ' ', RTRIM('')), '(', RTRIM('')), ')', RTRIM('')), '-', RTRIM('')), 1, 10)
    FROM    #Charges ch
            JOIN dbo.ClientPhones cp ON cp.ClientId = ch.ClientId
    WHERE   cp.PhoneType = 30
            AND cp.IsPrimary = 'Y'
            AND ISNULL(cp.RecordDeleted, 'N') = 'N'  
  
    IF @@error <> 0
        GOTO error  
  
    UPDATE  ch
    SET     ch.ClientHomePhone = SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(cp.PhoneNumberText, ' ', RTRIM('')), '(', RTRIM('')), ')', RTRIM('')), '-', RTRIM('')), 1, 10) ,
            ch.InsuredHomePhone = SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(cp.PhoneNumberText, ' ', RTRIM('')), '(', RTRIM('')), ')', RTRIM('')), '-', RTRIM('')), 1, 10)
    FROM    #Charges ch
            JOIN dbo.ClientPhones cp ON cp.ClientId = ch.ClientId
    WHERE   ch.ClientHomePhone IS NULL
            AND cp.PhoneType = 30
            AND ISNULL(cp.RecordDeleted, 'N') = 'N'  
  
    IF @@error <> 0
        GOTO error 
        
        
        
        -- Get insured information,     
    UPDATE  a
    SET     a.InsuredLastName = b.LastName ,
            a.InsuredFirstName = b.FirstName ,
            a.InsuredMiddleName = b.MiddleName ,
            a.InsuredSuffix = b.Suffix ,
            a.InsuredRelation = b.Relationship ,
            a.InsuredAddress1 = CASE WHEN CHARINDEX(CHAR(13) + CHAR(10), c.Address) = 0 THEN c.Address
                                     ELSE SUBSTRING(c.Address, 1, CHARINDEX(CHAR(13) + CHAR(10), c.Address) - 1)
                                END ,
            a.InsuredAddress2 = CASE WHEN CHARINDEX(CHAR(13) + CHAR(10), c.Address) = 0 THEN NULL
                                     ELSE RIGHT(c.Address, LEN(c.Address) - CHARINDEX(CHAR(13) + CHAR(10), c.Address) - 1)
                                END ,
            a.InsuredCity = c.City ,
            a.InsuredState = c.State ,
            a.InsuredZip = c.Zip ,
            a.InsuredHomePhone = SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(d.PhoneNumberText, ' ', RTRIM('')), '(', RTRIM('')), ')', RTRIM('')), '-', RTRIM('')), 1, 10) ,
            a.InsuredSex = b.Sex ,
            a.InsuredSSN = b.SSN ,
            a.InsuredDOB = b.DOB
    FROM    #Charges a
            JOIN dbo.ClientContacts b ON ( a.SubscriberContactId = b.ClientContactId )
            LEFT JOIN dbo.ClientContactAddresses c ON ( b.ClientContactId = c.ClientContactId
                                                        AND c.AddressType = 90
                                                        AND ISNULL(c.RecordDeleted, 'N') <> 'Y'
                                                      )
            LEFT JOIN dbo.ClientContactPhones d ON ( b.ClientContactId = d.ClientContactId
                                                     AND d.PhoneType = 30
                                                     AND ISNULL(d.RecordDeleted, 'N') <> 'Y'
                                                   )
    WHERE   ISNULL(b.RecordDeleted, 'N') <> 'Y'

    IF EXISTS ( SELECT  1
                FROM    dbo.SystemConfigurationKeys AS sck
                WHERE   [Key] = 'UseClientAddressHistoryFor837Billing'
                        AND ISNULL(sck.Value, 'N') = 'Y'
                        AND ISNULL(sck.RecordDeleted, 'N') <> 'Y' )
        BEGIN

		CREATE TABLE #OrderedAddressHistory
		(
			DateOfService DATETIME,
			ClientAddressId INT,
			ClientId INT,
			RowNumber INT
		)

		INSERT INTO #OrderedAddressHistory ( DateOfService, ClientAddressId, ClientId, RowNumber )
		SELECT c.DateOfService,cah.ClientAddressId,c.ClientId,ROW_NUMBER() OVER (PARTITION BY c.ClientId,c.DateOfService ORDER BY cah.ModifiedDate DESC ) AS RowNumber
		FROM #Charges AS c
		JOIN dbo.ClientAddressHistory  AS cah ON cah.ClientId = cl.ClientId
															-- the effective dates are weird...
                                                            AND DATEDIFF(DAY, ISNULL(cah.StartDate, '1900-1-1'), c.DateOfService) >= 0
                                                            AND ( cah.EndDate IS NULL
                                                                  OR DATEDIFF(DAY, c.DateOfService, cah.EndDate) >= 0
                                                                )
            UPDATE  c
            SET     ClientAddress1 = CASE WHEN CHARINDEX(CHAR(13) + CHAR(10), cah.Address) = 0 THEN cah.Address
                                          ELSE SUBSTRING(cah.Address, 1, CHARINDEX(CHAR(13) + CHAR(10), cah.Address) - 1)
                                     END ,
                    ClientAddress2 = CASE WHEN CHARINDEX(CHAR(13) + CHAR(10), cah.Address) = 0 THEN NULL
                                          ELSE RIGHT(cah.Address, LEN(cah.Address) - CHARINDEX(CHAR(13) + CHAR(10), cah.Address) - 1)
                                     END ,
                    ClientCity = cah.City ,
                    ClientState = cah.State ,
                    ClientZip = cah.Zip
		  -- upodate insured only if the subscriber contact is null
                    ,
                    InsuredAddress1 = CASE WHEN c.SubscriberContactId IS NULL THEN CASE WHEN CHARINDEX(CHAR(13) + CHAR(10), cah.Address) = 0 THEN cah.Address
                                                                                        ELSE SUBSTRING(cah.Address, 1, CHARINDEX(CHAR(13) + CHAR(10), cah.Address) - 1)
                                                                                   END
                                           ELSE c.InsuredAddress1
                                      END ,
                    InsuredAddress2 = CASE WHEN c.SubscriberContactId IS NULL THEN CASE WHEN CHARINDEX(CHAR(13) + CHAR(10), cah.Address) = 0 THEN NULL
                                                                                        ELSE RIGHT(cah.Address, LEN(cah.Address) - CHARINDEX(CHAR(13) + CHAR(10), cah.Address) - 1)
                                                                                   END
                                           ELSE c.InsuredAddress2
                                      END ,
                    InsuredCity = CASE WHEN c.SubscriberContactId IS NULL THEN cah.City
                                       ELSE c.InsuredCity
                                  END ,
                    InsuredState = CASE WHEN c.SubscriberContactId IS NULL THEN cah.State
                                        ELSE c.InsuredState
                                   END ,
                    InsuredZip = CASE WHEN c.SubscriberContactId IS NULL THEN cah.Zip
                                      ELSE c.InsuredZip
                                 END
            FROM    #Charges c
                    JOIN dbo.Clients cl ON cl.ClientId = c.ClientId
					JOIN #OrderedAddressHistory AS oah ON cl.ClientId = oah.ClientId
					AND oah.DateOfService = c.DateOfService
					and oah.RowNumber = 1
                    JOIN dbo.ClientAddressHistory AS cah ON  oah.ClientAddressId = cah.ClientAddressId
        END

    IF @@error <> 0
        GOTO error 

	-- Clean up Addresses

    UPDATE #Charges 
	SET  ClientAddress1 = RTRIM(LTRIM(ClientAddress1))
		,ClientAddress2 = RTRIM(LTRIM(ClientAddress2))
		,InsuredAddress1 = RTRIM(LTRIM(InsuredAddress1))
		,InsuredAddress2 = RTRIM(LTRIM(InsuredAddress2))
        
        -- 10/2/2015 Place Of Service: Get From Service, if NUll then get from Location, then use the override logic
        
    UPDATE  a
    SET     a.PlaceOfService = b.PlaceOfServiceId ,
            a.PlaceOfServiceCode = c.ExternalCode1
    FROM    #Charges a
            JOIN dbo.Services b ON b.ServiceId = a.ServiceId
            LEFT JOIN dbo.GlobalCodes c ON c.GlobalCodeId = b.PlaceOfServiceId		
        
   
    UPDATE  a
    SET     a.PlaceOfService = b.PlaceOfService ,
            a.PlaceOfServiceCode = c.ExternalCode1
    FROM    #Charges a
            LEFT JOIN dbo.Locations b ON ( a.LocationId = b.LocationId )
            LEFT JOIN dbo.GlobalCodes c ON ( b.PlaceOfService = c.GlobalCodeId )
    WHERE   a.PlaceOfService IS NULL


-- override logic    
    IF EXISTS ( SELECT  *
                FROM    sys.procedures
                WHERE   name = 'ssp_PMClaimsGetPlaceOfService' )
        BEGIN
            EXEC dbo.ssp_PMClaimsGetPlaceOfService
        END
    

-- Default Place of Service
    UPDATE  a
    SET     PlaceOfServiceCode = '11'
    FROM    #Charges a
    WHERE   ISNULL(PlaceOfServiceCode, '') = ''    


    IF @@error <> 0
        GOTO error    
    

-- Updat Authorization Number for Service    
    UPDATE  a
    SET     a.AuthorizationId = c.AuthorizationId ,
            a.AuthorizationNumber = c.AuthorizationNumber
    FROM    #Charges a
            JOIN dbo.ServiceAuthorizations b ON ( a.ServiceId = b.ServiceId
                                                  AND a.ClientCoveragePlanId = b.ClientCoveragePlanId
                                                )
            JOIN dbo.Authorizations c ON ( b.AuthorizationId = c.AuthorizationId )    
    

    IF @@error <> 0
        GOTO ERROR
        
        
    UPDATE  a
    SET     a.AgencyName = b.AgencyName ,
            a.PaymentAddress1 = CASE WHEN CHARINDEX(CHAR(13) + CHAR(10), b.PaymentAddress) = 0 THEN b.PaymentAddress
                                     ELSE SUBSTRING(b.PaymentAddress, 1, CHARINDEX(CHAR(13) + CHAR(10), b.PaymentAddress) - 1)
                                END ,
            a.PaymentAddress2 = CASE WHEN CHARINDEX(CHAR(13) + CHAR(10), b.PaymentAddress) = 0 THEN NULL
                                     ELSE RIGHT(b.PaymentAddress, LEN(b.PaymentAddress) - CHARINDEX(CHAR(13) + CHAR(10), b.PaymentAddress) - 1)
                                END ,
            a.PaymentCity = b.PaymentCity ,
            a.PaymentState = b.PaymentState ,
            a.PaymentZip = b.PaymentZip ,
            --Task #686 CoreBugs-Billing contact in 837 process is not removing punctuation  
            a.PaymentPhone = SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(b.BillingPhone, ' ', RTRIM('')), '-', RTRIM('')), '(', RTRIM('')), ')', RTRIM('')), 1, 10) ,
            a.BillingTaxonomyCode = b.BillingTaxonomy
    FROM    #Charges a
            CROSS JOIN dbo.Agency b
            
            
    IF @@error <> 0
        GOTO error 
        
        
    IF @Electronic = 'Y'
        BEGIN
        
            EXEC dbo.scsp_PMClaims837UpdateCharges @ParamCurrentUser, @ParamClaimBatchId, @ClaimFormatId
        
        END
        
    IF @Electronic <> 'Y'
        BEGIN
        
            EXEC dbo.scsp_PMClaimsHCFA1500UpdateCharges @ParamCurrentUser, @ParamClaimBatchId
        
        END
        
        
    UPDATE  dbo.ClaimBatches
    SET     BatchProcessProgress = 10
    WHERE   ClaimBatchId = @ParamClaimBatchId    
    

    IF @@error <> 0
        GOTO ERROR
        
     
     
        
        -- Determine Billing and  Rendering Provider Ids    
    EXEC dbo.ssp_PMClaimsGetProviderIds    
    
    IF @@error <> 0
        GOTO error  
        
    UPDATE  a
    SET     a.RenderingProviderTaxonomyCode = c.ExternalCode1
    FROM    #Charges a
            JOIN dbo.Staff b ON ( a.ClinicianId = b.StaffId )
            JOIN dbo.GlobalCodes c ON ( b.TaxonomyCode = c.GlobalCodeId )
    WHERE   a.RenderingProviderId IS NOT NULL    

    IF @@error <> 0
        GOTO error   
    
	IF OBJECT_ID('scsp_PMClaims837UpdateProviderIds','P') IS NOT NULL
		EXEC scsp_PMClaims837UpdateProviderIds @ParamCurrentUser, @ParamClaimBatchId, @ClaimFormatId, @FormatType

    IF @@error <> 0
        GOTO error    
    
      -- Get Procedure Codes for bundling after combining same day services
    INSERT  INTO #ProcedureCodesToBundleAfterCombiningSameDayServices
            ( CoveragePlanId ,
              ProcedureCodeId ,
			  AppliesToAllProcedureCodes ,
              RuleId
            )
            SELECT DISTINCT
                    a.CoveragePlanId ,
                    ISNULL(d.ProcedureCodeId,-1) ,
					ISNULL(c.AppliesToAllProcedureCodes,'N'),
                    c.RuleTypeId
            FROM    #Charges a
                    JOIN dbo.CoveragePlans b ON b.CoveragePlanId = a.CoveragePlanId
                    JOIN dbo.CoveragePlanRules c ON ( ( c.CoveragePlanId = b.CoveragePlanId
                                                        AND ISNULL(b.BillingRulesTemplate, 'T') = 'T'
                                                      )
                                                      OR ( c.CoveragePlanId = b.UseBillingRulesTemplateId
                                                           AND ISNULL(b.BillingRulesTemplate, 'T') = 'O'
                                                         )
                                                    )
                    LEFT JOIN dbo.CoveragePlanRuleVariables d ON d.CoveragePlanRuleId = c.CoveragePlanRuleId
            WHERE   c.RuleTypeId IN ( 4277, 4278 )
                    AND ISNULL(c.RecordDeleted, 'N') = 'N'
                    AND ISNULL(d.RecordDeleted, 'N') = 'N'
		                    
    
    IF @@error <> 0
        GOTO error 
        
	  -- Remove Clinician from #Charges if Rule 4277 is there
    UPDATE  a
    SET     ClinicianId = NULL ,
            RenderingProviderId = NULL
    FROM    #Charges a
            JOIN #ProcedureCodesToBundleAfterCombiningSameDayServices b ON (b.ProcedureCodeId = a.ProcedureCodeId OR b.AppliesToAllProcedureCodes = 'Y') 
                                                                           AND b.CoveragePlanId = a.CoveragePlanId
    WHERE   b.RuleId = 4277
	
	
    --SELECT  *
    --FROM    #ProcedureCodesToBundleAfterCombiningSameDayServices
		  
		        
    IF @@error <> 0
        GOTO error      
    
    -- Billing Code Calculation logic. Only calculate for Procedure Codes not in the temp table above
    SET IDENTITY_INSERT #ClaimLines ON

    IF @@error <> 0
        GOTO error     

    INSERT  INTO #ClaimLines
            ( ClaimLineId ,
              ServiceId ,
              ServiceUnits ,
              ChargeId ,
              CoveragePlanId
			)
            SELECT  a.ChargeId ,
                    a.ServiceId ,
                    a.ServiceUnits ,
                    a.ChargeId ,
                    a.CoveragePlanId
            FROM    #Charges a
            WHERE    NOT EXISTS ( SELECT  1
                                  FROM    #ProcedureCodesToBundleAfterCombiningSameDayServices b
                                  WHERE   b.CoveragePlanId = a.CoveragePlanId
                                          AND (
                                                a.ProcedureCodeId = b.ProcedureCodeId
                                                OR b.AppliesToAllProcedureCodes = 'Y'
                                              ) )
	
	
	
    IF @@error <> 0
        GOTO error     

    SET IDENTITY_INSERT #ClaimLines OFF

    IF @@error <> 0
        GOTO error     


    EXEC dbo.ssp_PMClaimsGetBillingCodes      

    IF @@error <> 0
        GOTO error     

    UPDATE  a
    SET     a.BillingCode = b.BillingCode ,
            a.Modifier1 = b.Modifier1 ,
            a.Modifier2 = b.Modifier2 ,
            a.Modifier3 = b.Modifier3 ,
            a.Modifier4 = b.Modifier4 ,
            a.BillingCodeDescription = b.BillingCodeDescription ,
            a.RevenueCode = b.RevenueCode ,
            a.RevenueCodeDescription = b.RevenueCodeDescription ,
            a.ClaimUnits = b.ClaimUnits
    FROM    #Charges a
            JOIN #ClaimLines b ON ( a.ChargeId = b.ClaimLineId )    

    IF @@error <> 0
        GOTO error     

    DELETE  FROM #ClaimLines
 
    IF @@error <> 0
        GOTO error		

    -- Added 7/15/2014 Voids & Rebills logic
    -- Override Billing Code/Modifier on charges where we are sending voids  
    UPDATE  a
    SET     a.BillingCode = b.BillingCode ,
            a.Modifier1 = b.Modifier1 ,
            a.Modifier2 = b.Modifier2 ,
            a.Modifier3 = b.Modifier3 ,
            a.Modifier4 = b.Modifier4 ,
            a.RevenueCode = b.RevenueCode ,
            a.RevenueCodeDescription = b.RevenueCodeDescription ,
            a.ClaimUnits = b.Units ,
            a.ChargeAmount = b.ChargeAmount
    FROM    #Charges a
            JOIN dbo.ClaimLineItems b ON a.VoidedClaimLineItemId = b.ClaimLineItemId
    WHERE   a.SubmissionReasonCode = '8'  

    IF @@error <> 0
        GOTO ERROR

    -- determine expected payment       
    --EXEC ssp_PMClaimsGetExpectedPayments    

    IF @@error <> 0
        GOTO error    
    
    UPDATE  dbo.ClaimBatches
    SET     BatchProcessProgress = 20
    WHERE   ClaimBatchId = @ParamClaimBatchId    
    
    IF @@error <> 0
        GOTO error  
        
        
    -- Subtract contractual adjustments for coverage plan    
    UPDATE  a
    SET     a.ChargeAmount = a.ChargeAmount - ( CASE WHEN ISNULL(b.ExpectedAdjustment, 0) > a.ChargeAmount THEN a.ChargeAmount
                                                     ELSE ISNULL(b.ExpectedAdjustment, 0)
                                                END )
    FROM    #Charges a
            JOIN dbo.Charges b ON b.ChargeId = a.ChargeId
            JOIN dbo.CoveragePlans c ON c.CoveragePlanId = a.CoveragePlanId
    WHERE   ISNULL(c.SendAllowedAmountOnClaims, 'N') = 'Y'
    

    IF @@error <> 0
        GOTO ERROR
    
	-- Set custom modifiers    
    IF OBJECT_ID('dbo.scsp_PMClaims837PreCombineCharges', 'P') IS NOT NULL
        BEGIN
            EXEC dbo.scsp_PMClaims837PreCombineCharges
	
        END  

-- Added 3/25 Combine charges scsp        
    DECLARE @ExecuteCombineChargesSCSP CHAR(1) = 'N'
    IF EXISTS ( SELECT  *
                FROM    sys.objects
                WHERE   name = 'scsp_PMClaims837CombineCharges'
                        AND type = 'P' )
        BEGIN
            EXEC dbo.scsp_PMClaims837CombineCharges @CurrentUser = @ParamCurrentUser, @ClaimFormatId = @ClaimFormatId, @ClaimBatchId = @ParamClaimBatchId, @FormatType = @FormatType, @ExecuteCombineChargesSCSP = @ExecuteCombineChargesSCSP OUTPUT
        END
    IF @ExecuteCombineChargesSCSP = 'N'
        BEGIN

            CREATE TABLE #Groups
                (
                  ChargeId INT ,
                  ClaimFormatId INT ,
                  CoveragePlanId INT ,
                  BillingProviderIdGroup VARCHAR(35) ,
                  RenderingProviderIdGroup VARCHAR(35) ,
				  SupervisingProvider2310DIdGroup VARCHAR(80),
				  RenderingProviderNPIGroup CHAR(10),
                  ClinicianIdGroup INT ,
                  ProcedureCodeIdGroup INT ,
                  ClientIdGroup INT ,
                  ClientAddress1 VARCHAR(30) ,
                  ClientAddress2 VARCHAR(30) ,
                  ClientCity VARCHAR(30) ,
                  ClientState CHAR(2) ,
                  ClientZip CHAR(25) ,
                  InsuredAddress1 VARCHAR(30) NULL ,
                  InsuredAddress2 VARCHAR(30) NULL ,
                  InsuredCity VARCHAR(30) NULL ,
                  InsuredState CHAR(2) NULL ,
                  InsuredZip VARCHAR(25) NULL ,
                  AuthorizationIdGroup INT ,
                  DateOfServiceGroup DATETIME ,
                  ClientCoveragePlanIdGroup INT ,
                  PlaceOfServiceGroup INT ,
                  SubmissionReasonCodeGroup CHAR(1) ,
                  BillingCodeGroup VARCHAR(15) ,
                  Modifier1Group VARCHAR(2) ,
                  Modifier2Group VARCHAR(2) ,
                  Modifier3Group VARCHAR(2) ,
                  Modifier4Group VARCHAR(2) ,
                  GroupIdGroup INT ,
                  RevenueCodeGroup VARCHAR(15) ,
                  RevenueCodeDescriptionGroup VARCHAR(15) ,
                  InpatientAdmitDateGroup DATETIME ,
                  MedicalRecordNumberGroup VARCHAR(30) NULL ,
				  ClinicalDegreeGroup VARCHAR(250) NULL ,
				  [Priority] INT NULL
                )
	
            UPDATE   a
            SET      a.ClinicalDegreeGroupName = pr.DegreeGroupName
            FROM     #Charges a
                     JOIN CoveragePlans e
                        ON a.CoveragePlanId = e.CoveragePlanId
                     JOIN dbo.ProcedureRates AS pr
                        ON pr.ProcedureCodeId = a.ProcedureCodeId
                           AND ISNULL(CASE e.BillingCodeTemplate
                                        WHEN 'T' THEN e.CoveragePlanId
                                        WHEN 'O' THEN e.UseBillingCodesFrom
                                        ELSE NULL
                                      END, 0) = ISNULL(pr.CoveragePlanId, 0)
                           AND ISNULL(pr.RecordDeleted, 'N') <> 'Y'
                           AND pr.FromDate <= a.DateOfService
                           AND (
                                 DATEADD(dd, 1, pr.ToDate) > a.DateOfService
                                 OR pr.ToDate IS NULL
                               )
                     JOIN ProcedureRateDegrees PRD
                        ON pr.ProcedureRateId = PRD.ProcedureRateId
                           AND ISNULL(PRD.RecordDeleted, 'N') = 'N'
                           AND ISNULL(pr.DegreeGroupName, '') <> ''
                           AND PRD.Degree = a.ClinicianDegree
	

            INSERT  INTO #Groups
                    ( ChargeId ,
                      ClaimFormatId ,
                      CoveragePlanId ,
                      BillingProviderIdGroup ,
                      RenderingProviderIdGroup ,
					  RenderingProviderNPIGroup ,
					  SupervisingProvider2310DIdGroup ,
                      ClinicianIdGroup ,
                      ProcedureCodeIdGroup ,
                      ClientIdGroup ,
                      ClientAddress1 ,
                      ClientAddress2 ,
                      ClientCity ,
                      ClientState ,
                      ClientZip ,
                      InsuredAddress1 ,
                      InsuredAddress2 ,
                      InsuredCity ,
                      InsuredState ,
                      InsuredZip ,
                      AuthorizationIdGroup ,
                      DateOfServiceGroup ,
                      ClientCoveragePlanIdGroup ,
                      PlaceOfServiceGroup ,
                      SubmissionReasonCodeGroup ,
                      BillingCodeGroup ,
                      Modifier1Group ,
                      Modifier2Group ,
                      Modifier3Group ,
                      Modifier4Group ,
                      GroupIdGroup ,
                      RevenueCodeGroup ,
                      RevenueCodeDescriptionGroup ,
                      InpatientAdmitDateGroup ,
                      MedicalRecordNumberGroup ,
					  ClinicalDegreeGroup,
					  [Priority]
					 )
                    SELECT  a.ChargeId ,
                            @ClaimFormatId ,
                            a.CoveragePlanId ,
                            a.BillingProviderId ,
                            a.RenderingProviderId ,
							a.RenderingProviderNPI ,
							a.SupervisingProvider2310DId ,
                            a.ClinicianId ,
                            a.ProcedureCodeId ,
                            a.ClientId ,
                            a.ClientAddress1 ,
                            a.ClientAddress2 ,
                            a.ClientCity ,
                            a.ClientState ,
                            a.ClientZip ,
                            a.InsuredAddress1 ,
                            a.InsuredAddress2 ,
                            a.InsuredCity ,
                            a.InsuredState ,
                            a.InsuredZip ,
                            a.AuthorizationId ,
                            a.DateOfService ,
                            a.ClientCoveragePlanId ,
                            a.PlaceOfService ,
                            a.SubmissionReasonCode ,
                            a.BillingCode ,
                            a.Modifier1 ,
                            a.Modifier2 ,
                            a.Modifier3 ,
                            a.Modifier4 ,
                            a.GroupId ,
                            a.RevenueCode ,
                            a.RevenueCodeDescription ,
                            a.InpatientAdmitDate ,
                            a.MedicalRecordNumber ,
						    a.ClinicalDegreeGroupName,
							a.[Priority]
                    FROM    #Charges a

            UPDATE  a
            SET     a.BillingProviderIdGroup = CASE WHEN ISNULL(b.BillingProviderId, 'N') = 'N' THEN NULL
                                                    ELSE a.BillingProviderIdGroup
                                               END ,
                    a.RenderingProviderIdGroup = CASE WHEN ISNULL(b.RenderingProviderId, 'N') = 'N' THEN NULL
                                                      ELSE a.RenderingProviderIdGroup
                                                 END ,
					a.RenderingProviderNPIGroup = CASE WHEN ISNULL(b.RenderingProviderNPI,'N') = 'N' THEN NULL
													   ELSE a.RenderingProviderNPIGroup
												  END,
					a.SupervisingProvider2310DIdGroup = CASE WHEN ISNULL(b.SupervisingProvider2310DId,'N') = 'N' THEN NULL 
															 ELSE a.SupervisingProvider2310DIdGroup 
														END ,
                    a.ClinicianIdGroup = CASE WHEN ISNULL(b.ClinicianId, 'N') = 'N' THEN NULL
                                              ELSE a.ClinicianIdGroup
                                         END ,
                    a.ProcedureCodeIdGroup = CASE WHEN ISNULL(b.ProcedureCodeId, 'N') = 'N' THEN NULL
                                                  ELSE a.ProcedureCodeIdGroup
                                             END ,
                    a.ClientIdGroup = CASE WHEN ISNULL(b.ClientId, 'N') = 'N' THEN NULL
                                           ELSE a.ClientIdGroup
                                      END ,
                    a.ClientAddress1 = CASE WHEN ISNULL(b.ClientId, 'N') = 'N' THEN NULL
                                            ELSE a.ClientAddress1
                                       END ,
                    a.ClientAddress2 = CASE WHEN ISNULL(b.ClientId, 'N') = 'N' THEN NULL
                                            ELSE a.ClientAddress2
                                       END ,
                    a.ClientCity = CASE WHEN ISNULL(b.ClientId, 'N') = 'N' THEN NULL
                                        ELSE a.ClientCity
                                   END ,
                    a.ClientState = CASE WHEN ISNULL(b.ClientId, 'N') = 'N' THEN NULL
                                         ELSE a.ClientState
                                    END ,
                    a.ClientZip = CASE WHEN ISNULL(b.ClientId, 'N') = 'N' THEN NULL
                                       ELSE a.ClientZip
                                  END ,
                    a.InsuredAddress1 = CASE WHEN ISNULL(b.ClientId, 'N') = 'N' THEN NULL
                                             ELSE a.InsuredAddress1
                                        END ,
                    a.InsuredAddress2 = CASE WHEN ISNULL(b.ClientId, 'N') = 'N' THEN NULL
                                             ELSE a.InsuredAddress2
                                        END ,
                    a.InsuredCity = CASE WHEN ISNULL(b.ClientId, 'N') = 'N' THEN NULL
                                         ELSE a.InsuredCity
                                    END ,
                    a.InsuredState = CASE WHEN ISNULL(b.ClientId, 'N') = 'N' THEN NULL
                                          ELSE a.InsuredState
                                     END ,
                    a.InsuredZip = CASE WHEN ISNULL(b.ClientId, 'N') = 'N' THEN NULL
                                        ELSE a.InsuredZip
                                   END ,
                    a.AuthorizationIdGroup = CASE WHEN ISNULL(b.AuthorizationId, 'N') = 'N' THEN NULL
                                                  ELSE a.AuthorizationIdGroup
                                             END ,
                    a.DateOfServiceGroup = CASE WHEN isnull(b.TimeOfService,'N') = 'N' and ISNULL(b.DateOfService, 'N') = 'N' THEN NULL
												WHEN isnull(b.TimeOfService,'N') = 'Y' then a.DateOfServiceGroup
                                                ELSE CONVERT(DATETIME, CONVERT(VARCHAR, a.DateOfServiceGroup, 101)) 
										   END ,
                    a.ClientCoveragePlanIdGroup = CASE WHEN ISNULL(b.ClientCoveragePlanId, 'N') = 'N' THEN NULL
                                                       ELSE a.ClientCoveragePlanIdGroup
                                                  END ,
                    a.PlaceOfServiceGroup = CASE WHEN ISNULL(b.PlaceOfService, 'N') = 'N' THEN NULL
                                                 ELSE a.PlaceOfServiceGroup
                                            END ,
                    a.SubmissionReasonCodeGroup = CASE WHEN ISNULL(b.SubmissionReasonCode, 'N') = 'N' THEN NULL
                                                       ELSE a.SubmissionReasonCodeGroup
                                                  END ,
                    a.BillingCodeGroup = CASE WHEN ISNULL(b.BillingCode, 'N') = 'N' THEN NULL
                                              ELSE a.BillingCodeGroup
                                         END ,
                    a.Modifier1Group = CASE WHEN ISNULL(b.Modifier1, 'N') = 'N' THEN NULL
                                            ELSE a.Modifier1Group
                                       END ,
                    a.Modifier2Group = CASE WHEN ISNULL(b.Modifier2, 'N') = 'N' THEN NULL
                                            ELSE a.Modifier2Group
                                       END ,
                    a.Modifier3Group = CASE WHEN ISNULL(b.Modifier3, 'N') = 'N' THEN NULL
                                            ELSE a.Modifier3Group
                                       END ,
                    a.Modifier4Group = CASE WHEN ISNULL(b.Modifier4, 'N') = 'N' THEN NULL
                                            ELSE a.Modifier4Group
                                       END ,
                    a.GroupIdGroup = CASE WHEN ISNULL(b.GroupId, 'N') = 'N' THEN NULL
                                          ELSE a.GroupIdGroup
                                     END ,
                    a.RevenueCodeGroup = CASE WHEN ISNULL(b.RevenueCode, 'N') = 'N' THEN NULL
                                              ELSE a.RevenueCodeGroup
                                         END ,
                    a.RevenueCodeDescriptionGroup = CASE WHEN ISNULL(b.RevenueCodeDescription, 'N') = 'N' THEN NULL
                                                         ELSE a.RevenueCodeDescriptionGroup
                                                    END ,
                    a.InpatientAdmitDateGroup = CASE WHEN ISNULL(b.InpatientAdmitDate, 'N') = 'N' THEN NULL
                                                     ELSE a.InpatientAdmitDateGroup
                                                END  ,           
					a.ClinicalDegreeGroup = CASE WHEN ISNULL(b.ClinicalDegreeGroup,'N') = 'N' THEN NULL
												 ELSE a.ClinicalDegreeGroup   
                                                END
            FROM    #Groups a
                    JOIN dbo.CoveragePlanClaimGroupingCriteria b ON a.ClaimFormatId = b.ClaimFormatId
                                                                    AND a.CoveragePlanId = b.CoveragePlanId
            WHERE   ISNULL(b.RecordDeleted, 'N') = 'N'


			--tchen modified 09/10/2018
			UPDATE  g
			SET     g.DateOfServiceGroup = CONVERT(DATETIME, CONVERT(VARCHAR, g.DateOfServiceGroup, 101))
			FROM    #Groups AS g
			WHERE   NOT EXISTS
			(   SELECT  1
				FROM    CoveragePlanClaimGroupingCriteria AS cpcgc
				WHERE   g.ClaimFormatId = cpcgc.ClaimFormatId
						AND g.CoveragePlanId = cpcgc.CoveragePlanId
						AND ISNULL(cpcgc.RecordDeleted, 'N') = 'N' )
		
			-- preserve the date of service joining preferences

			UPDATE c
			SET DateOfService = a.DateOfServiceGroup
			FROM #Groups a
			JOIN #Charges c ON a.ChargeId = c.ChargeId


	-- For Rules 4277, 4278, Update ProcedureCodeId in #Groups
            UPDATE  a
            SET     ProcedureCodeIdGroup = b.ProcedureCodeId
            FROM    #Groups a
                    JOIN #Charges b ON b.ChargeId = a.ChargeId
                    JOIN #ProcedureCodesToBundleAfterCombiningSameDayServices c ON (c.ProcedureCodeId = b.ProcedureCodeId OR c.AppliesToAllProcedureCodes = 'Y')
                                                                                   AND c.CoveragePlanId = b.CoveragePlanId
		
							
-- Combine claims   
-- Use combination of Billing Provider, Rendering Provider,  
-- Client, Authorization Number, Procedure Code, Date Of Service  
            INSERT  INTO #ClaimLines
                    ( BillingProviderId ,
                      RenderingProviderId ,
					  RenderingProviderNPI ,
					  SupervisingProvider2310DId ,
                      ClientId ,
                      ClientAddress1 ,
                      ClientAddress2 ,
                      ClientCity ,
                      ClientState ,
                      ClientZip ,
                      InsuredAddress1 ,
                      InsuredAddress2 ,
                      InsuredCity ,
                      InsuredState ,
                      InsuredZip ,
                      ClinicianId ,
                      AuthorizationId ,
                      ProcedureCodeId ,
                      DateOfService ,
                      ClientCoveragePlanId ,
                      PlaceOfService ,
                      ServiceUnits ,
                      ChargeAmount ,
                      ClientPayment ,
                      ChargeId ,
                      SubmissionReasonCode ,
                      BillingCode ,
                      Modifier1 ,
                      Modifier2 ,
                      Modifier3 ,
                      Modifier4 ,
                      GroupId ,
                      RevenueCode ,
                      RevenueCodeDescription ,
                      ClaimUnits ,
                      InpatientAdmitDate ,
                      MedicalRecordNumber ,
					  ClinicalDegreeGroupName ,
					  [Priority]
					)
                    SELECT  b.BillingProviderIdGroup ,
                            b.RenderingProviderIdGroup ,
							b.RenderingProviderNPIGroup ,
							b.SupervisingProvider2310DIdGroup ,
                            b.ClientIdGroup ,
                            b.ClientAddress1 ,
                            b.ClientAddress2 ,
                            b.ClientCity ,
                            b.ClientState ,
                            b.ClientZip ,
                            b.InsuredAddress1 ,
                            b.InsuredAddress2 ,
                            b.InsuredCity ,
                            b.InsuredState ,
                            b.InsuredZip ,
                            b.ClinicianIdGroup ,
                            b.AuthorizationIdGroup ,
                            b.ProcedureCodeIdGroup ,
                            b.DateOfServiceGroup ,
                            b.ClientCoveragePlanIdGroup ,
                            b.PlaceOfServiceGroup ,
                            SUM(a.ServiceUnits) ,
                            SUM(a.ChargeAmount) ,
                            SUM(a.ClientPayment) ,
                            MAX(a.ChargeId) ,
                            b.SubmissionReasonCodeGroup ,
                            b.BillingCodeGroup ,
                            b.Modifier1Group ,
                            b.Modifier2Group ,
                            b.Modifier3Group ,
                            b.Modifier4Group ,
                            b.GroupIdGroup ,
                            b.RevenueCodeGroup ,
                            b.RevenueCodeDescriptionGroup ,
                            SUM(a.ClaimUnits) ,
                            b.InpatientAdmitDateGroup ,
                            a.MedicalRecordNumber ,
							b.ClinicalDegreeGroup,
							b.[Priority]
                    FROM    #Charges a
                            JOIN #Groups b ON a.ChargeId = b.ChargeId
                    WHERE   NOT EXISTS ( SELECT		 1
                                         FROM     #ProcedureCodesToBundleAfterCombiningSameDayServices c
                                         WHERE    c.CoveragePlanId = a.CoveragePlanId
											  AND (a.ProcedureCodeId  = c.ProcedureCodeId 
													OR c.AppliesToAllProcedureCodes = 'Y'
											  )
										) -- Exclude Procedure Codes in the temp table #ProcedureCodesToBundleAfterCombiningSameDayServices
                    GROUP BY b.BillingProviderIdGroup ,
                            b.RenderingProviderIdGroup ,
							b.RenderingProviderNPIGroup ,
							b.SupervisingProvider2310DIdGroup ,
                            b.ClientIdGroup ,
                            b.ClientAddress1 ,
                            b.ClientAddress2 ,
                            b.ClientCity ,
                            b.ClientState ,
                            b.ClientZip ,
                            b.InsuredAddress1 ,
                            b.InsuredAddress2 ,
                            b.InsuredCity ,
                            b.InsuredState ,
                            b.InsuredZip ,
                            b.ClinicianIdGroup ,
                            b.AuthorizationIdGroup ,
                            b.ProcedureCodeIdGroup ,
                            b.ClientCoveragePlanIdGroup ,
                            b.PlaceOfServiceGroup ,
                            b.SubmissionReasonCodeGroup ,
                            b.BillingCodeGroup ,
                            b.Modifier1Group ,
                            b.Modifier2Group ,
                            b.Modifier3Group ,
                            b.Modifier4Group ,
                            b.GroupIdGroup ,
                            b.DateOfServiceGroup ,
                            b.RevenueCodeGroup ,
                            b.RevenueCodeDescriptionGroup ,
                            b.InpatientAdmitDateGroup ,
                            a.MedicalRecordNumber ,
							b.ClinicalDegreeGroup ,
							b.[Priority]
  
            IF @@error <> 0
                GOTO error  
  
				

	-- Copy #ClaimLines to another table. Need to run get billing codes ssp again
            SELECT  *
            INTO    #ClaimLinesII
            FROM    #ClaimLines
			
            IF @@error <> 0
                GOTO error  
			
            TRUNCATE TABLE #ClaimLines
            
            IF @@error <> 0
                GOTO error  

			UPDATE a SET a.DateOfService = CAST(a.DateOfService as date)
			        FROM    #Charges a
                            JOIN #Groups b ON a.ChargeId = b.ChargeId
                    WHERE   a.ProcedureCodeId IN ( SELECT   DISTINCT
                                                            c.ProcedureCodeId
                                                   FROM     #ProcedureCodesToBundleAfterCombiningSameDayServices c
                                                   WHERE    c.CoveragePlanId = a.CoveragePlanId )
            
	-- Insert Procedure Codes that are in the temp table #ProcedureCodesToBundleAfterCombiningSameDayServices	            
            INSERT  INTO #ClaimLines
                    ( BillingProviderId ,
                      RenderingProviderId ,
					  RenderingProviderNPI ,
					  SupervisingProvider2310DId ,
                      ClientId ,
                      ClientAddress1 ,
                      ClientAddress2 ,
                      ClientCity ,
                      ClientState ,
                      ClientZip ,
                      InsuredAddress1 ,
                      InsuredAddress2 ,
                      InsuredCity ,
                      InsuredState ,
                      InsuredZip ,
                      ClinicianId ,
                      AuthorizationId ,
                      ProcedureCodeId ,
                      DateOfService ,
                      ClientCoveragePlanId ,
                      PlaceOfService ,
                      ServiceUnits ,
                      ChargeAmount ,
                      ClientPayment ,
                      ChargeId ,
                      ServiceId ,
                      SubmissionReasonCode ,
                      BillingCode ,
                      Modifier1 ,
                      Modifier2 ,
                      Modifier3 ,
                      Modifier4 ,
                      GroupId ,
                      RevenueCode ,
                      RevenueCodeDescription ,
                      ClaimUnits ,
                      InpatientAdmitDate ,
                      CoveragePlanId ,
                      MedicalRecordNumber ,
					  ClinicalDegreeGroupName ,
					  [Priority]
					)
                    SELECT  b.BillingProviderIdGroup ,
                            b.RenderingProviderIdGroup ,
							b.RenderingProviderNPIGroup ,
							b.SupervisingProvider2310DIdGroup ,
                            b.ClientIdGroup ,
                            b.ClientAddress1 ,
                            b.ClientAddress2 ,
                            b.ClientCity ,
                            b.ClientState ,
                            b.ClientZip ,
                            b.InsuredAddress1 ,
                            b.InsuredAddress2 ,
                            b.InsuredCity ,
                            b.InsuredState ,
                            b.InsuredZip ,
                            b.ClinicianIdGroup ,
                            b.AuthorizationIdGroup ,
                            a.ProcedureCodeId ,
                            a.DateOfService ,
                            b.ClientCoveragePlanIdGroup ,
                            b.PlaceOfServiceGroup ,
                            SUM(a.ServiceUnits) ,
                            SUM(a.ChargeAmount) ,
                            SUM(a.ClientPayment) ,
                            MAX(a.ChargeId) ,
                            MAX(a.ServiceId) ,
                            b.SubmissionReasonCodeGroup ,
                            b.BillingCodeGroup ,
                            b.Modifier1Group ,
                            b.Modifier2Group ,
                            b.Modifier3Group ,
                            b.Modifier4Group ,
                            b.GroupIdGroup ,
                            b.RevenueCodeGroup ,
                            b.RevenueCodeDescriptionGroup ,
                            SUM(a.ClaimUnits) ,
                            b.InpatientAdmitDateGroup ,
                            a.CoveragePlanId ,
                            a.MedicalRecordNumber ,
							b.ClinicalDegreeGroup ,
							b.[Priority]
                    FROM    #Charges a
                            JOIN #Groups b ON a.ChargeId = b.ChargeId
                    WHERE   EXISTS ( SELECT		 1
                                         FROM     #ProcedureCodesToBundleAfterCombiningSameDayServices c
                                         WHERE    c.CoveragePlanId = a.CoveragePlanId
											  AND (a.ProcedureCodeId  = c.ProcedureCodeId 
													OR c.AppliesToAllProcedureCodes = 'Y'
											  )
										) 
                    GROUP BY b.BillingProviderIdGroup ,
                            b.RenderingProviderIdGroup ,
							b.RenderingProviderNPIGroup ,
							b.SupervisingProvider2310DIdGroup ,
                            b.ClientIdGroup ,
                            b.ClientAddress1 ,
                            b.ClientAddress2 ,
                            b.ClientCity ,
                            b.ClientState ,
                            b.ClientZip ,
                            b.InsuredAddress1 ,
                            b.InsuredAddress2 ,
                            b.InsuredCity ,
                            b.InsuredState ,
                            b.InsuredZip ,
                            b.ClinicianIdGroup ,
                            b.AuthorizationIdGroup ,
                            a.ProcedureCodeId ,
                            b.ClientCoveragePlanIdGroup ,
                            b.PlaceOfServiceGroup ,
                            b.SubmissionReasonCodeGroup ,
                            b.BillingCodeGroup ,
                            b.Modifier1Group ,
                            b.Modifier2Group ,
                            b.Modifier3Group ,
                            b.Modifier4Group ,
                            b.GroupIdGroup ,
                            a.DateOfService ,
                            b.RevenueCodeGroup ,
                            b.RevenueCodeDescriptionGroup ,
                            b.InpatientAdmitDateGroup ,
                            a.CoveragePlanId ,
                            a.MedicalRecordNumber ,
							b.ClinicalDegreeGroup ,
							b.[Priority]
  
            IF @@error <> 0
                GOTO error                 

		
	-- Run get billing codes again, this time for Procedure Codes in the temp table #ProcedureCodesToBundleAfterCombiningSameDayServices		
            EXEC dbo.ssp_PMClaimsGetBillingCodes
	
	-- Update billing code back #Charges
            UPDATE  a
            SET     BillingCode = c.BillingCode ,
                    Modifier1 = c.Modifier1 ,
                    Modifier2 = c.Modifier2 ,
                    Modifier3 = c.Modifier3 ,
                    Modifier4 = c.Modifier4 ,
                    RevenueCode = c.RevenueCode ,
                    RevenueCodeDescription = c.RevenueCodeDescription
            FROM    #Charges a
					JOIN #Groups g ON g.ChargeId = a.ChargeId
                    JOIN #ProcedureCodesToBundleAfterCombiningSameDayServices b ON (b.ProcedureCodeId = a.ProcedureCodeId OR b.AppliesToAllProcedureCodes = 'Y')
                                                                                   AND b.CoveragePlanId = a.CoveragePlanId
                    JOIN #CLaimLines c ON ISNULL(c.BillingProviderId, '') = ISNULL(g.BillingProviderIdGroup, '')
                                          AND ISNULL(c.RenderingProviderId, '') = ISNULL(g.RenderingProviderIdGroup, '')
										  AND ISNULL(c.RenderingProviderNPI,'') = ISNULL(g.RenderingProviderNPIGroup,'')
										  AND ISNULL(c.SupervisingProvider2310DId,'') = ISNULL(g.supervisingProvider2310DIdGroup,'')
                                          AND ISNULL(c.ClientId, '') = ISNULL(g.ClientIdGroup, '')
                                          AND ISNULL(c.ClinicianId, '') = ISNULL(g.ClinicianIdGroup, '')
                                          AND ISNULL(c.AuthorizationId, '') = ISNULL(g.AuthorizationIdGroup, '')
                                          AND ISNULL(c.ProcedureCodeId, '') = ISNULL(g.ProcedureCodeIdGroup, '')
                                          AND ISNULL(CONVERT(DATETIME, CONVERT(VARCHAR, c.DateOfService, 101)), '') = ISNULL(CONVERT(DATETIME, CONVERT(VARCHAR, g.DateOfServiceGroup, 101)), '')
                                          AND ISNULL(c.ClientCoveragePlanId, '') = ISNULL(g.ClientCoveragePlanIdGroup, '')
                                          AND ISNULL(c.PlaceOfService, '') = ISNULL(g.PlaceOfServiceGroup, '')
                                          AND ISNULL(c.SubmissionReasonCode, '') = ISNULL(g.SubmissionReasonCodeGroup, '')
                                          AND ISNULL(c.GroupId, '') = ISNULL(g.GroupIdGroup, '')
                                          AND ISNULL(c.InpatientAdmitDate, '') = ISNULL(g.InpatientAdmitDateGroup, '') 
                                          AND ISNULL(c.MedicalRecordNumber, '') = ISNULL(g.MedicalRecordNumberGroup, '') 
										  AND ISNULL(c.ClinicalDegreeGroupName,'') = ISNULL(g.ClinicalDegreeGroup,'')
										  AND ISNULL(c.[Priority],'') = ISNULL(g.[Priority],'')
			
			
            UPDATE  a
            SET     BillingCodeGroup = c.BillingCode ,
                    Modifier1Group = c.Modifier1 ,
                    Modifier2Group = c.Modifier2 ,
                    Modifier3Group = c.Modifier3 ,
                    Modifier4Group = c.Modifier4 ,
                    RevenueCodeGroup = c.RevenueCode ,
                    RevenueCodeDescriptionGroup = c.RevenueCodeDescription
            FROM    #Groups a
                    JOIN #Charges c ON c.ChargeId = a.ChargeId                                      
						
			
			
            IF @@error <> 0
                GOTO error 
			

	-- Insert the removed records back into #ClaimLines
            INSERT  INTO #ClaimLines
                    ( BillingProviderId ,
                      RenderingProviderId ,
					  RenderingProviderNPI ,
					  SupervisingProvider2310DId ,
                      ClientId ,
                      ClientAddress1 ,
                      ClientAddress2 ,
                      ClientCity ,
                      ClientState ,
                      ClientZip ,
                      InsuredAddress1 ,
                      InsuredAddress2 ,
                      InsuredCity ,
                      InsuredState ,
                      InsuredZip ,
                      ClinicianId ,
                      AuthorizationId ,
                      ProcedureCodeId ,
                      DateOfService ,
                      ClientCoveragePlanId ,
                      PlaceOfService ,
                      ServiceUnits ,
                      ChargeAmount ,
                      ClientPayment ,
                      ChargeId ,
                      SubmissionReasonCode ,
                      BillingCode ,
                      Modifier1 ,
                      Modifier2 ,
                      Modifier3 ,
                      Modifier4 ,
                      GroupId ,
                      RevenueCode ,
                      RevenueCodeDescription ,
                      ClaimUnits ,
                      InpatientAdmitDate ,
                      MedicalRecordNumber ,
					  ClinicalDegreeGroupName ,
					  [Priority]
					)
                    SELECT  BillingProviderId ,
                            RenderingProviderId ,
							RenderingProviderNPI ,
							SupervisingProvider2310DId ,
                            ClientId ,
                            ClientAddress1 ,
                            ClientAddress2 ,
                            ClientCity ,
                            ClientState ,
                            ClientZip ,
                            InsuredAddress1 ,
                            InsuredAddress2 ,
                            InsuredCity ,
                            InsuredState ,
                            InsuredZip ,
                            ClinicianId ,
                            AuthorizationId ,
                            ProcedureCodeId ,
                            DateOfService ,
                            ClientCoveragePlanId ,
                            PlaceOfService ,
                            ServiceUnits ,
                            ChargeAmount ,
                            ClientPayment ,
                            ChargeId ,
                            SubmissionReasonCode ,
                            BillingCode ,
                            Modifier1 ,
                            Modifier2 ,
                            Modifier3 ,
                            Modifier4 ,
                            GroupId ,
                            RevenueCode ,
                            RevenueCodeDescription ,
                            ClaimUnits ,
                            InpatientAdmitDate ,
                            MedicalRecordNumber ,
							ClinicalDegreeGroupName ,
							[Priority]
                    FROM    #ClaimLinesII
		
			
			
			
			
            IF @@error <> 0
                GOTO error 
			
			
			-- Don't need Rev Code in Professional Claims
            UPDATE  #Charges
            SET     RevenueCode = NULL ,
                    RevenueCodeDescription = NULL
			
            UPDATE  #ClaimLines
            SET     RevenueCode = NULL ,
                    RevenueCodeDescription = NULL
			
            UPDATE  #Groups
            SET     RevenueCodeGroup = NULL ,
                    RevenueCodeDescriptionGroup = NULL
			
			
            IF @@error <> 0
                GOTO error                 
			
            UPDATE  a
            SET     a.ClaimLineId = b.ClaimLineId
            FROM    #Charges a
                    JOIN #Groups g ON ( a.ChargeId = g.ChargeId )
                    JOIN #ClaimLines b ON ISNULL(b.BillingProviderId, '') = ISNULL(g.BillingProviderIdGroup, '')
                                          AND ISNULL(b.RenderingProviderId, '') = ISNULL(g.RenderingProviderIdGroup, '')
										  AND ISNULL(b.RenderingProviderNPI,'') = ISNULL(g.RenderingProviderNPIGroup,'')
										  AND ISNULL(b.SupervisingProvider2310DId,'') = ISNULL(g.supervisingProvider2310DIdGroup,'')
                                          AND ISNULL(b.ClientId, '') = ISNULL(g.ClientIdGroup, '')
                                          AND ISNULL(b.ClientAddress1, '') = ISNULL(g.ClientAddress1, '')
                                          AND ISNULL(b.ClientAddress2, '') = ISNULL(g.ClientAddress2, '')
                                          AND ISNULL(b.ClientCity, '') = ISNULL(g.ClientCity, '')
                                          AND ISNULL(b.ClientState, '') = ISNULL(g.ClientState, '')
                                          AND ISNULL(b.ClientZip, '') = ISNULL(g.ClientZip, '')
                                          AND ISNULL(b.InsuredAddress1, '') = ISNULL(g.InsuredAddress1, '')
                                          AND ISNULL(b.InsuredAddress2, '') = ISNULL(g.InsuredAddress2, '')
                                          AND ISNULL(b.InsuredCity, '') = ISNULL(g.InsuredCity, '')
                                          AND ISNULL(b.InsuredState, '') = ISNULL(g.InsuredState, '')
                                          AND ISNULL(b.InsuredZip, '') = ISNULL(g.InsuredZip, '')
                                          AND ISNULL(b.ClinicianId, '') = ISNULL(g.ClinicianIdGroup, '')
                                          AND ISNULL(b.AuthorizationId, '') = ISNULL(g.AuthorizationIdGroup, '')
                                          AND ISNULL(b.ProcedureCodeId, '') = ISNULL(g.ProcedureCodeIdGroup, '')
                                          AND ISNULL(b.DateOfService, '') = ISNULL(g.DateOfServiceGroup, '')
                                          AND ISNULL(b.ClientCoveragePlanId, '') = ISNULL(g.ClientCoveragePlanIdGroup, '')
                                          AND ISNULL(b.PlaceOfService, '') = ISNULL(g.PlaceOfServiceGroup, '')
                                          AND ISNULL(b.SubmissionReasonCode, '') = ISNULL(g.SubmissionReasonCodeGroup, '')
                                          AND ISNULL(b.BillingCode, '') = ISNULL(g.BillingCodeGroup, '')
                                          AND ISNULL(b.Modifier1, '') = ISNULL(g.Modifier1Group, '')
                                          AND ISNULL(b.Modifier2, '') = ISNULL(g.Modifier2Group, '')
                                          AND ISNULL(b.Modifier3, '') = ISNULL(g.Modifier3Group, '')
                                          AND ISNULL(b.Modifier4, '') = ISNULL(g.Modifier4Group, '')
                                          AND ISNULL(b.GroupId, '') = ISNULL(g.GroupIdGroup, '')
                                          AND ISNULL(b.RevenueCode, '') = ISNULL(g.RevenueCodeGroup, '')
                                          AND ISNULL(b.RevenueCodeDescription, '') = ISNULL(g.RevenueCodeDescriptionGroup, '')
                                          AND ISNULL(b.InpatientAdmitDate, '') = ISNULL(g.InpatientAdmitDateGroup, '')
                                          AND ISNULL(b.MedicalRecordNumber, '') = ISNULL(g.MedicalRecordNumberGroup, '') 
										  AND ISNULL(b.ClinicalDegreeGroupName,'') = ISNULL(g.ClinicalDegreeGroup,'')
										  AND ISNULL(b.[Priority],'') = ISNULL(g.[Priority],'')
  
            IF @@error <> 0
                GOTO error  
  
 
            UPDATE  a
            SET     a.ClientId = b.ClientId ,
                    a.ClientLastName = b.ClientLastName ,
                    a.ClientFirstname = b.ClientFirstname ,
                    a.ClientMiddleName = b.ClientMiddleName ,
                    a.ClientSSN = b.ClientSSN ,
                    a.ClientSuffix = b.ClientSuffix ,
                    a.ClientAddress1 = b.ClientAddress1 ,
                    a.ClientAddress2 = b.ClientAddress2 ,
                    a.ClientCity = b.ClientCity ,
                    a.ClientState = b.ClientState ,
                    a.ClientZip = b.ClientZip ,
                    a.ClientHomePhone = b.ClientHomePhone ,
                    a.ClientDOB = b.ClientDOB ,
                    a.ClientSex = b.ClientSex ,
                    a.ClientIsSubscriber = b.ClientIsSubscriber ,
                    a.SubscriberContactId = b.SubscriberContactId ,
                    a.MaritalStatus = b.MaritalStatus ,
                    a.EmploymentStatus = b.EmploymentStatus ,
                    a.RegistrationDate = b.RegistrationDate ,
                    a.DischargeDate = b.DischargeDate ,
                    a.InsuredId = b.InsuredId ,
                    a.GroupNumber = b.GroupNumber ,
                    a.GroupName = b.GroupName ,
                    a.InsuredLastName = b.InsuredLastName ,
                    a.InsuredFirstName = b.InsuredFirstName ,
                    a.InsuredMiddleName = b.InsuredMiddleName ,
                    a.InsuredSuffix = b.InsuredSuffix ,
                    a.InsuredRelation = b.InsuredRelation ,
                    a.InsuredAddress1 = b.InsuredAddress1 ,
                    a.InsuredAddress2 = b.InsuredAddress2 ,
                    a.InsuredCity = b.InsuredCity ,
                    a.InsuredState = b.InsuredState ,
                    a.InsuredZip = b.InsuredZip ,
                    a.InsuredHomePhone = b.InsuredHomePhone ,
                    a.InsuredSex = b.InsuredSex ,
                    a.InsuredSSN = b.InsuredSSN ,
                    a.InsuredDOB = b.InsuredDOB ,
                    --a.ServiceId = b.ServiceId ,
                    a.ServiceUnitType = b.ServiceUnitType ,
                    a.ProgramId = b.ProgramId ,
                    a.LocationId = b.LocationId ,
                    --ClinicianId = b.ClinicianId ,
                    a.ClinicianLastName = b.ClinicianLastName ,
                    a.ClinicianFirstName = b.ClinicianFirstName ,
                    a.ClinicianMiddleName = b.ClinicianMiddleName ,
                    a.ClinicianSex = b.ClinicianSex ,
					a.ClinicianDegree = b.ClinicianDegree ,
                    a.AttendingId = b.AttendingId ,
                    --a.Priority = b.Priority ,
                    a.CoveragePlanId = b.CoveragePlanId ,
                    a.MedicaidPayer = b.MedicaidPayer ,
                    a.MedicarePayer = b.MedicarePayer ,
                    a.PayerName = b.PayerName ,
                    a.PayerAddressHeading = b.PayerAddressHeading ,
                    a.PayerAddress1 = b.PayerAddress1 ,
                    a.PayerAddress2 = b.PayerAddress2 ,
                    a.PayerCity = b.PayerCity ,
                    a.PayerState = b.PayerState ,
                    a.PayerZip = b.PayerZip ,
                    a.ProviderCommercialNumber = b.ProviderCommercialNumber ,
                    a.InsuranceCommissionersCode = b.InsuranceCommissionersCode ,
                    a.MedicareInsuranceTypeCode = b.MedicareInsuranceTypeCode ,
                    a.ClaimFilingIndicatorCode = b.ClaimFilingIndicatorCode ,
                    a.ElectronicClaimsPayerId = b.ElectronicClaimsPayerId ,
                    a.ClaimOfficeNumber = b.ClaimOfficeNumber ,
                    a.AuthorizationNumber = b.AuthorizationNumber ,
                    a.PlaceOfServiceCode = b.PlaceOfServiceCode ,
                    a.AgencyName = b.AgencyName ,
                    a.PaymentAddress1 = b.PaymentAddress1 ,
                    a.PaymentAddress2 = b.PaymentAddress2 ,
                    a.PaymentCity = b.PaymentCity ,
                    a.PaymentState = b.PaymentState ,
                    a.PaymentZip = b.PaymentZip ,
                    a.PaymentPhone = b.PaymentPhone ,
                    a.BillingProviderTaxIdType = b.BillingProviderTaxIdType ,
                    a.BillingProviderTaxId = b.BillingProviderTaxId ,
                    a.BillingProviderIdType = b.BillingProviderIdType ,
                    --BillingProviderId = b.BillingProviderId ,
                    a.BillingTaxonomyCode = b.BillingTaxonomyCode ,
                    a.BillingProviderLastName = b.BillingProviderLastName ,
                    a.BillingProviderFirstName = b.BillingProviderFirstName ,
                    a.BillingProviderMiddleName = b.BillingProviderMiddleName ,
                    a.BillingProviderNPI = b.BillingProviderNPI ,
                    a.PayToProviderTaxIdType = b.PayToProviderTaxIdType ,
                    a.PayToProviderTaxId = b.PayToProviderTaxId ,
                    a.PayToProviderIdType = b.PayToProviderIdType ,
                    a.PayToProviderId = b.PayToProviderId ,
                    a.PayToProviderLastName = b.PayToProviderLastName ,
                    a.PayToProviderFirstName = b.PayToProviderFirstName ,
                    a.PayToProviderMiddleName = b.PayToProviderMiddleName ,
                    a.PayToProviderNPI = b.PayToProviderNPI ,
                    a.RenderingProviderTaxIdType = b.RenderingProviderTaxIdType ,
                    a.RenderingProviderTaxId = b.RenderingProviderTaxId ,
                    a.RenderingProviderIdType = b.RenderingProviderIdType ,
                    --RenderingProviderId = b.RenderingProviderId ,
                    a.RenderingProviderLastName = b.RenderingProviderLastName ,
                    a.RenderingProviderFirstName = b.RenderingProviderFirstName ,
                    a.RenderingProviderMiddleName = b.RenderingProviderMiddleName ,
                    a.RenderingProviderTaxonomyCode = b.RenderingProviderTaxonomyCode ,
                    --a.RenderingProviderNPI = b.RenderingProviderNPI ,
                    a.ReferringId = b.ReferringId ,
                    a.ReferringProviderNPI = b.ReferringProviderNPI ,
                    a.FacilityEntityCode = b.FacilityEntityCode ,
                    a.FacilityName = b.FacilityName ,
                    a.FacilityTaxIdType = b.FacilityTaxIdType ,
                    a.FacilityTaxId = b.FacilityTaxId ,
                    a.FacilityProviderIdType = b.FacilityProviderIdType ,
                    a.FacilityProviderId = b.FacilityProviderId ,
                    a.FacilityAddress1 = b.FacilityAddress1 ,
                    a.FacilityAddress2 = b.FacilityAddress2 ,
                    a.FacilityCity = b.FacilityCity ,
                    a.FacilityState = b.FacilityState ,
                    a.FacilityZip = b.FacilityZip ,
                    a.FacilityPhone = b.FacilityPhone ,
                    a.FacilityNPI = b.FacilityNPI ,
                    a.SupervisingProvider2310DLastName = b.SupervisingProvider2310DLastName ,
                    a.SupervisingProvider2310DFirstName = b.SupervisingProvider2310DFirstName ,
                    a.SupervisingProvider2310DMiddleName = b.SupervisingProvider2310DMiddleName ,
                    a.SupervisingProvider2310DIdType = b.SupervisingProvider2310DIdType ,
                    --a.SupervisingProvider2310DId = b.SupervisingProvider2310DId ,
                    a.SupervisingProvider2310DSecondaryIdType1 = b.SupervisingProvider2310DSecondaryIdType1 ,
                    a.SupervisingProvider2310DSecondaryId1 = b.SupervisingProvider2310DSecondaryId1 ,
                    a.SupervisingProvider2310DSecondaryIdType2 = b.SupervisingProvider2310DSecondaryIdType2 ,
                    a.SupervisingProvider2310DSecondaryId2 = b.SupervisingProvider2310DSecondaryId2 ,
                    a.SupervisingProvider2310DSecondaryIdType3 = b.SupervisingProvider2310DSecondaryIdType3 ,
                    a.SupervisingProvider2310DSecondaryId3 = b.SupervisingProvider2310DSecondaryId3 ,
                    a.SupervisingProvider2310DSecondaryIdType4 = b.SupervisingProvider2310DSecondaryIdType4 ,
                    a.SupervisingProvider2310DSecondaryId4 = b.SupervisingProvider2310DSecondaryId4 ,
                    a.ServiceLineFacilityEntityCode = b.ServiceLineFacilityEntityCode ,
                    a.ServiceLineFacilityName = b.ServiceLineFacilityName ,
                    a.ServiceLineFacilityTaxIdType = b.ServiceLineFacilityTaxIdType ,
                    a.ServiceLineFacilityTaxId = b.ServiceLineFacilityTaxId ,
                    a.ServiceLineFacilityProviderIdType = b.ServiceLineFacilityProviderIdType ,
                    a.ServiceLineFacilityProviderId = b.ServiceLineFacilityProviderId ,
                    a.ServiceLineFacilityAddress1 = b.ServiceLineFacilityAddress1 ,
                    a.ServiceLineFacilityAddress2 = b.ServiceLineFacilityAddress2 ,
                    a.ServiceLineFacilityCity = b.ServiceLineFacilityCity ,
                    a.ServiceLineFacilityState = b.ServiceLineFacilityState ,
                    a.ServiceLineFacilityZip = b.ServiceLineFacilityZip ,
                    a.ServiceLineFacilityPhone = b.ServiceLineFacilityPhone ,
                    a.ServiceLineFacilityNPI = b.ServiceLineFacilityNPI ,
                    a.VoidedClaimLineItemId = b.VoidedClaimLineItemId ,
                    a.ClaimNoteReferenceCode = b.ClaimNoteReferenceCode ,
                    a.ClaimNote = b.ClaimNote ,
                    a.ServiceNoteReferenceCode = b.ServiceNoteReferenceCode ,
                    a.ServiceNote = b.ServiceNote ,
                    a.PayerClaimControlNumber = b.PayerClaimControlNumber ,
					a.CLIANumber = b.CLIANumber ,
                    a.BillingProviderId = CASE WHEN a.BillingProviderId IS NULL THEN b.BillingProviderId
                                               ELSE a.BillingProviderId
                                          END ,
                    a.RenderingProviderId = CASE WHEN a.RenderingProviderId IS NULL THEN b.RenderingProviderId
                                                 ELSE a.RenderingProviderId
                                            END ,
					a.RenderingProviderNPI = CASE WHEN a.RenderingProviderNPI IS NULL THEN b.RenderingProviderNPI
												  ELSE a.RenderingProviderNPI
                                             END ,
                    a.SupervisingProvider2310DId = CASE WHEN a.SupervisingProvider2310DId IS NULL THEN b.SupervisingProvider2310DId
														ELSE a.SupervisingProvider2310DId
												   END ,
                    a.ClinicianId = CASE WHEN a.ClinicianId IS NULL THEN b.ClinicianId
                                         ELSE a.ClinicianId
                                    END ,
                    a.ProcedureCodeId = CASE WHEN a.ProcedureCodeId IS NULL THEN b.ProcedureCodeId
                                             ELSE a.ProcedureCodeId
                                        END ,
                    a.AuthorizationId = CASE WHEN a.AuthorizationId IS NULL THEN b.AuthorizationId
                                             ELSE a.AuthorizationId
                                        END ,
                    a.DateOfService = CASE WHEN a.DateOfService IS NULL THEN b.DateOfService
                                           ELSE a.DateOfService
                                      END ,
                    a.ClientCoveragePlanId = CASE WHEN a.ClientCoveragePlanId IS NULL THEN b.ClientCoveragePlanId
                                                  ELSE a.ClientCoveragePlanId
                                             END ,
                    a.PlaceOfService = CASE WHEN a.PlaceOfService IS NULL THEN b.PlaceOfService
                                            ELSE a.PlaceOfService
                                       END ,
                    a.SubmissionReasonCode = CASE WHEN a.SubmissionReasonCode IS NULL THEN b.SubmissionReasonCode
                                                  ELSE a.SubmissionReasonCode
                                             END ,
                    a.BillingCode = CASE WHEN a.BillingCode IS NULL THEN b.BillingCode
                                         ELSE a.BillingCode
                                    END ,
                    a.Modifier1 = CASE WHEN a.Modifier1 IS NULL THEN b.Modifier1
                                       ELSE a.Modifier1
                                  END ,
                    a.Modifier2 = CASE WHEN a.Modifier2 IS NULL THEN b.Modifier2
                                       ELSE a.Modifier2
                                  END ,
                    a.Modifier3 = CASE WHEN a.Modifier3 IS NULL THEN b.Modifier3
                                       ELSE a.Modifier3
                                  END ,
                    a.Modifier4 = CASE WHEN a.Modifier4 IS NULL THEN b.Modifier4
                                       ELSE a.Modifier4
                                  END ,
                    a.GroupId = CASE WHEN a.GroupId IS NULL THEN b.GroupId
                                     ELSE a.GroupId
                                END ,
                    a.RevenueCode = CASE WHEN a.RevenueCode IS NULL THEN b.RevenueCode
                                         ELSE a.RevenueCode
                                    END ,
                    a.RevenueCodeDescription = CASE WHEN a.RevenueCodeDescription IS NULL THEN b.RevenueCodeDescription
                                                    ELSE a.RevenueCodeDescription
                                               END ,
                    a.InpatientAdmitDate = CASE WHEN a.InpatientAdmitDate IS NULL THEN b.InpatientAdmitDate
                                                ELSE a.InpatientAdmitDate
                                           END ,
					a.ClinicalDegreeGroupName = CASE WHEN a.ClinicalDegreeGroupName IS NULL THEN b.ClinicalDegreeGroupName 
													 ELSE a.ClinicalDegreeGroupName 
                                           END
            FROM    #ClaimLines a
                    JOIN #Charges b ON ( a.ChargeId = b.ChargeId )
  
            IF @@error <> 0
                GOTO error   
                
         
         -- Implementing Rule #4279
            UPDATE  a
            SET     Modifier1 = NULL ,
                    Modifier2 = NULL ,
                    Modifier3 = NULL ,
                    Modifier4 = NULL
            FROM    #ClaimLines a
                    JOIN #Charges b ON b.ClaimLineId = a.ClaimLineId
                    JOIN CoveragePlans c ON c.CoveragePlanId = b.CoveragePlanId
                    JOIN dbo.CoveragePlanRules d ON ( ( d.CoveragePlanId = c.CoveragePlanId
                                                        AND ISNULL(c.BillingRulesTemplate, 'T') = 'T'
                                                      )
                                                      OR ( d.CoveragePlanId = c.UseBillingRulesTemplateId
                                                           AND ISNULL(c.BillingRulesTemplate, 'T') = 'O'
                                                         )
                                                    )
                    LEFT JOIN dbo.CoveragePlanRuleVariables e ON e.CoveragePlanRuleId = d.CoveragePlanRuleId
                                                                 AND ISNULL(e.RecordDeleted, 'N') = 'N'
            WHERE   d.RuleTypeId IN ( 4279 )
                    AND ( e.ProcedureCodeId = b.ProcedureCodeId
                          OR ISNULL(d.AppliesToAllProcedureCodes, 'N') = 'Y'
                        )
                    AND ISNULL(d.RecordDeleted, 'N') = 'N'
                    
			
			
            IF @@error <> 0
                GOTO error 

        END

	-- 12.11.2016 - Do not set end date of service if the custom combine charges proc was executed.
    IF @ExecuteCombineChargesSCSP = 'N'
        BEGIN
		-- legacy behavior - set EndDateOfService for all #ClaimLines entries
            UPDATE  a
            SET     EndDateOfService = CASE WHEN b.EndDateEqualsStartDate = 'Y' THEN a.DateOfService
                                            WHEN b.EnteredAs = 110 THEN DATEADD(mi, a.ServiceUnits, a.DateOfService)
                                            WHEN b.EnteredAs = 111 THEN DATEADD(hh, a.ServiceUnits, a.DateOfService)
                                            WHEN b.EnteredAs = 112 THEN DATEADD(dd, a.ServiceUnits - 1, a.DateOfService)
                                            ELSE a.DateOfService
                                       END
            FROM    #ClaimLines a
                    JOIN ProcedureCodes b ON ( a.ProcedureCodeId = b.ProcedureCodeId )
        END
    ELSE
        BEGIN
		-- apply legacy behavior to claim lines that have no end date of service
            UPDATE  a
            SET     EndDateOfService = CASE WHEN b.EndDateEqualsStartDate = 'Y' THEN a.DateOfService
                                            WHEN b.EnteredAs = 110 THEN DATEADD(mi, a.ServiceUnits, a.DateOfService)
                                            WHEN b.EnteredAs = 111 THEN DATEADD(hh, a.ServiceUnits, a.DateOfService)
                                            WHEN b.EnteredAs = 112 THEN DATEADD(dd, a.ServiceUnits - 1, a.DateOfService)
                                            ELSE a.DateOfService
                                       END
            FROM    #ClaimLines a
                    JOIN ProcedureCodes b ON ( a.ProcedureCodeId = b.ProcedureCodeId )
            WHERE   a.EndDateOfService IS NULL

    
        END       

  

    IF @@error <> 0
        GOTO error         
        
        
    UPDATE  a
    SET     a.ReferringProviderLastName = LTRIM(RTRIM(SUBSTRING(b.CodeName, 1, CHARINDEX(',', b.CodeName) - 1))) ,
            a.ReferringProviderFirstName = LTRIM(RTRIM(SUBSTRING(b.CodeName, CHARINDEX(',', b.CodeName) + 1, LEN(b.CodeName)))) ,
            a.ReferringProviderTaxIdType = a.PayToProviderTaxIdType ,
            a.ReferringProviderTaxId = a.PayToProviderTaxId ,
            a.ReferringProviderIdType = '1G' ,
            a.ReferringProviderId = LTRIM(RTRIM(b.ExternalCode1)) ,
            a.ReferringProviderNPI = LTRIM(RTRIM(b.ExternalCode2))
    FROM    #ClaimLines a
            JOIN dbo.GlobalCodes b ON ( a.ReferringId = b.GlobalCodeId )
    WHERE   CHARINDEX(',', b.CodeName) > 0
            AND a.ReferringId IS NOT NULL    

    
    IF @@error <> 0
        GOTO ERROR
        
      
    UPDATE  dbo.ClaimBatches
    SET     BatchProcessProgress = 30
    WHERE   ClaimBatchId = @ParamClaimBatchId    

    
    IF @@error <> 0
        GOTO ERROR
        
-- 3/25 Other Insured SCSP

    DECLARE @ExecuteOtherInsuredSCSP CHAR(1) = 'N'
    IF EXISTS ( SELECT  *
                FROM    sys.objects
                WHERE   name = 'scsp_PMClaims837OtherInsuredInformation'
                        AND type = 'P' )
        BEGIN
            EXEC dbo.scsp_PMClaims837OtherInsuredInformation @CurrentUser = @ParamCurrentUser, @ClaimFormatId = @ClaimFormatId, @ClaimBatchId = @ParamClaimBatchId, @FormatType = @FormatType, @ExecuteOtherInsuredSCSP = @ExecuteOtherInsuredSCSP OUTPUT
        END

    IF @ExecuteOtherInsuredSCSP = 'N'
        BEGIN

-- Determine other insured information  
            INSERT  INTO #OtherInsured
                    ( ClaimLineId ,
                      ChargeId ,
                      Priority ,
                      ClientCoveragePlanId ,
                      CoveragePlanId ,
                      InsuranceTypeCode ,
                      ClaimFilingIndicatorCode ,
                      PayerName ,
					  PayerAddress1,
		              PayerAddress2,
		              PayerCity ,
		              PayerState ,
		              PayerZip ,
                      InsuredId ,
                      GroupNumber ,
                      GroupName ,
                      InsuredLastName ,
                      InsuredFirstName ,
                      InsuredMiddleName ,
                      InsuredSuffix ,
                      InsuredSex ,
                      InsuredDOB ,
                      InsuredRelation ,
                      InsuredRelationCode ,
                      PayerType ,
                      ElectronicClaimsPayerId
					)
                    SELECT  a.ClaimLineId ,
                            c.ChargeId ,
                            c.Priority ,
                            c.ClientCoveragePlanId ,
                            d.CoveragePlanId ,
                            CASE WHEN ( k.ExternalCode1 = 'MB' )
                                      AND ( c.Priority > 1 ) THEN '47'
                                 ELSE ''
                            END , --srf 3/14/2011 per implementation guide   
--'MB' when 'MC' then 'MC' when 'CI' then 'C1'   
--when 'BL' then 'C1' when 'HM' then 'C1' else 'OT' end,  
                            k.ExternalCode1 ,
                            f.CoveragePlanName ,
							CASE WHEN CHARINDEX(CHAR(13) + CHAR(10), f.Address) = 0 THEN f.Address
								 ELSE SUBSTRING(f.Address, 1, CHARINDEX(CHAR(13) + CHAR(10), f.Address) - 1)
							END ,
							CASE WHEN CHARINDEX(CHAR(13) + CHAR(10), f.Address) = 0 THEN NULL
								 ELSE RIGHT(f.Address, LEN(f.Address) - CHARINDEX(CHAR(13) + CHAR(10), f.Address) - 1)
							END ,
							f.City ,
							f.State ,
							f.ZipCode ,
                            REPLACE(REPLACE(d.InsuredId, '-', RTRIM('')), ' ', RTRIM('')) ,
                            d.GroupNumber ,
                            d.GroupName ,
                            CASE WHEN d.SubscriberContactId IS NULL THEN a.ClientLastName
                                 ELSE e.LastName
                            END ,
                            CASE WHEN d.SubscriberContactId IS NULL THEN a.ClientFirstname
                                 ELSE e.FirstName
                            END ,
                            CASE WHEN d.SubscriberContactId IS NULL THEN a.ClientMiddleName
                                 ELSE e.MiddleName
                            END ,
                            CASE WHEN d.SubscriberContactId IS NULL THEN a.ClientSuffix
                                 ELSE e.Suffix
                            END ,
                            CASE WHEN d.SubscriberContactId IS NULL THEN a.ClientSex
                                 ELSE e.Sex
                            END ,
                            CASE WHEN d.SubscriberContactId IS NULL THEN a.ClientDOB
                                 ELSE e.DOB
                            END ,
                            e.Relationship ,
                            g.ExternalCode1 ,
                            i.ExternalCode1 ,
                            f.ElectronicClaimsPayerId
                    FROM    #ClaimLines a
                            JOIN dbo.Charges b ON ( a.ChargeId = b.ChargeId )
                            JOIN dbo.Charges c ON ( b.ServiceId = c.ServiceId
                                                    AND c.Priority <> 0
                                                    AND c.Priority < b.Priority
                                                  )
                            JOIN dbo.ClientCoveragePlans d ON ( c.ClientCoveragePlanId = d.ClientCoveragePlanId )
                            LEFT JOIN dbo.ClientContacts e ON ( d.SubscriberContactId = e.ClientContactId )
                            JOIN dbo.CoveragePlans f ON ( d.CoveragePlanId = f.CoveragePlanId
                                                          AND ISNULL(f.Capitated, 'N') = 'N'
                                                        )
                            LEFT JOIN dbo.GlobalCodes g ON ( e.Relationship = g.GlobalCodeId )
                            JOIN dbo.Payers h ON f.PayerId = h.PayerId
                            LEFT JOIN dbo.GlobalCodes i ON ( h.PayerType = i.GlobalCodeId )  
--LEFT JOIN CustomClientContacts j ON (e.ClientContactId = j.ClientContactId)  
                            LEFT JOIN dbo.GlobalCodes k ON ( f.ClaimFilingIndicatorCode = k.GlobalCodeId )
                    WHERE   ISNULL(e.RecordDeleted, 'N') <> 'Y'
                            AND c.ChargeId NOT IN ( SELECT  DISTINCT
                                                            arclient.ChargeId
                                                    FROM    dbo.ARLedger arclient
                                                    WHERE   arclient.ChargeId = c.ChargeId
                                                            AND arclient.CoveragePlanId IS NULL
                                                    GROUP BY arclient.ChargeId
                                                    HAVING  SUM(arclient.Amount) = 0 ) -- Exclude client charges with zero balance                                                   
                    ORDER BY a.ClaimLineId ,
                            c.Priority  
  


            IF @@error <> 0
                GOTO ERROR
        

            INSERT  INTO #OtherInsuredPaid
                    ( OtherInsuredId ,
                      PaidAmount ,
                      Adjustments ,
                      AllowedAmount ,
                      PreviousPaidAmount ,
                      PaidDate ,
                      DenialCode
					)
                    SELECT  a.OtherInsuredId ,
                            SUM(CASE WHEN d.ClientCoveragePlanId = a.ClientCoveragePlanId
                                          AND e.LedgerType = 4202 THEN -e.Amount
                                     ELSE 0
                                END) ,
                            SUM(CASE WHEN d.ClientCoveragePlanId = a.ClientCoveragePlanId
                                          AND e.LedgerType = 4203 THEN -e.Amount
                                     ELSE 0
                                END) ,
                            SUM(CASE WHEN e.LedgerType = 4201 THEN e.Amount
                                     WHEN e.LedgerType = 4203
                                          AND d.Priority <> 0
                                          AND d.Priority < a.Priority THEN e.Amount
                                     ELSE 0
                                END) ,
                            SUM(CASE WHEN e.LedgerType = 4202
                                          AND d.Priority <> 0
                                          AND d.Priority < a.Priority THEN -e.Amount
                                     ELSE 0
                                END) ,
                            MAX(CASE WHEN e.LedgerType = 4202
                                          AND d.ClientCoveragePlanId = a.ClientCoveragePlanId THEN e.PostedDate
                                     ELSE NULL
                                END) ,
                            MAX(CASE WHEN e.LedgerType = 4204
                                          AND d.ClientCoveragePlanId = a.ClientCoveragePlanId THEN f.ExternalCode1
                                     ELSE NULL
                                END)
                    FROM    #OtherInsured a
                            JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                            JOIN dbo.Charges c ON ( b.ChargeId = c.ChargeId )
                            JOIN dbo.Charges d ON ( d.ServiceId = c.ServiceId )
                            JOIN dbo.ARLedger e ON ( d.ChargeId = e.ChargeId
                                                     AND ISNULL(e.MarkedAsError, 'N') = 'N'
                                                     AND ISNULL(e.ErrorCorrection, 'N') = 'N'
                                                   )
                            LEFT JOIN dbo.GlobalCodes f ON ( e.AdjustmentCode = f.GlobalCodeId )
                    GROUP BY a.OtherInsuredId  
  

            IF @@error <> 0
                GOTO error  
                    

-- Update Paid Date to last activity date in case there is no payment  
            UPDATE  a
            SET     a.PaidDate = ( SELECT   MAX(c.PostedDate)
                                   FROM     dbo.ARLedger c
                                   WHERE    c.ChargeId = b.ChargeId
                                            AND ISNULL(c.MarkedAsError, 'N') = 'N'
                                            AND ISNULL(c.ErrorCorrection, 'N') = 'N'
                                 )
            FROM    #OtherInsuredPaid a
                    JOIN #OtherInsured b ON ( a.OtherInsuredId = b.OtherInsuredId )
            WHERE   a.PaidDate IS NULL
    

            IF @@error <> 0
                GOTO error    

    
            UPDATE  a
            SET     a.PaidAmount = b.PaidAmount ,
                    a.Adjustments = b.Adjustments ,
                    a.AllowedAmount = b.AllowedAmount ,
                    a.PreviousPaidAmount = b.PreviousPaidAmount ,
                    a.PaidDate = b.PaidDate ,
                    a.DenialCode = b.DenialCode
            FROM    #OtherInsured a
                    JOIN #OtherInsuredPaid b ON ( a.OtherInsuredId = b.OtherInsuredId )    

    
            IF @@error <> 0
                GOTO error    
        
        

            UPDATE  a
            SET     a.ApprovedAmount = b.AllowedAmount
            FROM    #ClaimLines a
                    JOIN #OtherInsured b ON ( a.ClaimLineId = b.ClaimLineId )
            WHERE   NOT EXISTS ( SELECT *
                                 FROM   #OtherInsured c
                                 WHERE  a.ClaimLineId = c.ClaimLineId
                                        AND c.AllowedAmount > b.AllowedAmount )    

    
            IF @@error <> 0
                GOTO error                             
        
        
---- HCFA only

            IF @Electronic <> 'Y'
                BEGIN
                    CREATE TABLE #ClaimLinePaid
                        (
                          ClaimLineId INT NOT NULL ,
                          PaidAmount MONEY NULL ,
                          Adjustments MONEY NULL
                        )    
    
                    IF @@error <> 0
                        GOTO error    
    
                    INSERT  INTO #ClaimLinePaid
                            ( ClaimLineId ,
                              PaidAmount ,
                              Adjustments
  							)
                            SELECT  ClaimLineId ,
                                    SUM(PaidAmount) ,
                                    SUM(Adjustments)
                            FROM    #OtherInsured
                            GROUP BY ClaimLineId    
    
                    IF @@error <> 0
                        GOTO error    
    
                    UPDATE  a
                    SET     a.PaidAmount = ISNULL(b.PaidAmount, 0) ,
                            a.Adjustments = ISNULL(b.Adjustments, 0)
                    FROM    #ClaimLines a
                            LEFT JOIN #ClaimLinePaid b ON ( a.ClaimLineId = b.ClaimLineId )    
    
                    IF @@error <> 0
                        GOTO error
                END
        

-- Get Billing Codes for Other Insurances    
            UPDATE  OI
            SET     OI.BillingCode = cli.BillingCode ,
                    OI.Modifier1 = cli.Modifier1 ,
                    OI.Modifier2 = cli.Modifier2 ,
                    OI.Modifier3 = cli.Modifier3 ,
                    OI.Modifier4 = cli.Modifier4 ,
                    OI.RevenueCode = cli.RevenueCode ,
                    OI.RevenueCodeDescription = cli.RevenueCodeDescription ,
                    OI.ClaimUnits = cli.Units
            FROM    #OtherInsured OI
                    JOIN ClaimLineItemCharges clic ON OI.ChargeId = clic.ChargeId
                    JOIN ClaimLineItems cli ON clic.ClaimLineItemId = cli.ClaimLineItemId
                    JOIN ClaimLineItemGroups clig ON cli.ClaimLineItemGroupId = clig.ClaimLineItemGroupId
                    JOIN ClaimBatches cb ON clig.ClaimBatchId = cb.ClaimBatchId
            WHERE   cb.BilledDate IS NOT NULL
                    AND NOT EXISTS ( SELECT 1
                                     FROM   ClaimLineItemCharges clic1
                                            JOIN ClaimLineItems cli1 ON clic1.ClaimLineItemId = cli1.ClaimLineItemId
                                            JOIN ClaimLineItemGroups clig1 ON cli1.ClaimLineItemGroupId = clig1.ClaimLineItemGroupId
                                            JOIN ClaimBatches cb1 ON clig1.ClaimBatchId = cb1.ClaimBatchId
                                     WHERE  clic1.ChargeId = OI.ChargeId
                                            AND cb1.BilledDate > cb.BilledDate )
					
            IF @@error <> 0
                GOTO ERROR   
        
        
-- Update values from current claim if they cannot be determined    
            UPDATE  a
            SET     a.BillingCode = b.BillingCode ,
                    a.Modifier1 = b.Modifier1 ,
                    a.Modifier2 = b.Modifier2 ,
                    a.Modifier3 = b.Modifier3 ,
                    a.Modifier4 = b.Modifier4 ,
                    a.RevenueCode = b.RevenueCode ,
                    a.RevenueCodeDescription = b.RevenueCodeDescription ,
                    a.ClaimUnits = b.ClaimUnits
            FROM    #OtherInsured a
                    JOIN #ClaimLines b ON ( a.ClaimLineId = b.ClaimLineId )
            WHERE   ( a.BillingCode IS NULL
                      AND a.RevenueCode IS NULL
                    )
                    OR a.ClaimUnits IS NULL    

    
            IF @@error <> 0
                GOTO ERROR
        


---- QUestion: HIPAA Group Code

            INSERT  INTO #OtherInsuredAdjustment
                    ( OtherInsuredId ,
                      ARLedgerId ,
                      HIPAACode ,
                      HIPAAGroupCode ,
                      LedgerType ,
                      Amount
					)
                    SELECT DISTINCT
                            a.OtherInsuredId ,
                            e.ARLedgerId ,
                            f.ExternalCode1 ,
                            f.ExternalCode2 ,
                            e.LedgerType ,
                            e.Amount
                    FROM    #OtherInsured a
                            JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                            JOIN dbo.Charges d ON ( b.ServiceId = d.ServiceId
                                                    AND d.ClientCoveragePlanId = a.ClientCoveragePlanId
                                                  )
                            JOIN dbo.ARLedger e ON ( d.ChargeId = e.ChargeId
                                                     AND ISNULL(e.MarkedAsError, 'N') = 'N'
                                                     AND ISNULL(e.ErrorCorrection, 'N') = 'N'
                                                   )
                            LEFT JOIN dbo.GlobalCodes f ON ( e.AdjustmentCode = f.GlobalCodeId )
                    WHERE   ( e.LedgerType = 4203
                              OR ( e.LedgerType = 4204
                                   AND e.Amount < 0
                                 )
                            )-- IN ( 4203, 4204 ) 
                            
            
            IF @@error <> 0
                GOTO error  

			-- include an adjustment on secondary and lower priority payers for OA-23 for the difference in balance. 
            INSERT  INTO #OtherInsuredAdjustment
                    ( OtherInsuredId ,
                      ARLedgerId ,
                      DenialCode ,
                      HIPAAGroupCode ,
                      HIPAACode ,
                      LedgerType ,
                      Amount
				    )
                    SELECT  a.OtherInsuredId   -- OtherInsuredId - char(10)
                            ,
                            NULL-- ARLedgerId - int
                            ,
                            NULL-- DenialCode - int
                            ,
                            'OA'-- HIPAAGroupCode - varchar(10)
                            ,
                            '23'-- HIPAACode - varchar(10)
                            ,
                            4204-- LedgerType - int
                            ,
                            b.ChargeAmount + adjust.Amount - oip.PaidAmount-- Amount - money
                    FROM    #OtherInsured a
                            JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                            JOIN #OtherInsuredPaid AS oip ON a.OtherInsuredId = oip.OtherInsuredId
                            JOIN ( SELECT   SUM(oia.Amount) ,
                                            oia.OtherInsuredId
                                   FROM     #OtherInsuredAdjustment AS oia
                                   GROUP BY oia.OtherInsuredId
                                 ) adjust ( Amount, OtherInsuredId ) ON adjust.OtherInsuredId = a.OtherInsuredId
                    WHERE   a.Priority > 1
							AND b.ChargeAmount + adjust.Amount - oip.PaidAmount > 0.00

----Question: Code below is commented out in 837P only?
-- this isn't really relevent since other insured information isn't included on the CMS1500. 
            IF @Electronic <> 'Y'
                BEGIN
                    UPDATE  #OtherInsuredAdjustment
                    SET     HIPAACode = '2'
                    WHERE   ISNULL(RTRIM(HIPAACode), '') = ''
                            AND LedgerType = 4204  
  

                    IF @@error <> 0
                        GOTO error  
  


                    UPDATE  #OtherInsuredAdjustment
                    SET     HIPAACode = '45' --srf 5/20/2008 changed from A2  
                    WHERE   ISNULL(RTRIM(HIPAACode), '') = ''
                            AND LedgerType = 4203  
  

                    IF @@error <> 0
                        GOTO error  
  


-- Map to HIPAA group codes  
                    UPDATE  #OtherInsuredAdjustment
                    SET     HIPAAGroupCode = CASE WHEN HIPAACode IN ( '1', '2', '3' ) THEN 'PR'
                                                  WHEN ( LedgerType = 4203
                                                         OR HIPAACode IN ( '96' )
                                                       ) THEN 'CO'
                                                  ELSE 'OA'
                                             END --Added 9/8/200 srf  




                    IF @@error <> 0
                        GOTO error  
  
                END 
  

  
-- Summarize   
            INSERT  INTO #OtherInsuredAdjustment2
                    ( OtherInsuredId ,
                      HIPAAGroupCode ,
                      HIPAACode ,
                      Amount
					)
                    SELECT  OtherInsuredId ,
                            HIPAAGroupCode ,
                            HIPAACode ,
                            SUM(-Amount)
                    FROM    #OtherInsuredAdjustment
                    GROUP BY OtherInsuredId ,
                            HIPAAGroupCode ,
                            HIPAACode  
  

            IF @@error <> 0
                GOTO error         
        

-- Convert from rows to columns  
            INSERT  INTO #OtherInsuredAdjustment3
                    ( OtherInsuredId ,
                      HIPAAGroupCode ,
                      HIPAACode1
					)
                    SELECT  OtherInsuredId ,
                            HIPAAGroupCode ,
                            MAX(HIPAACode)
                    FROM    #OtherInsuredAdjustment2
                    GROUP BY OtherInsuredId ,
                            HIPAAGroupCode  
  

            IF @@error <> 0
                GOTO ERROR
        
        
            UPDATE  a
            SET     a.Amount1 = b.Amount
            FROM    #OtherInsuredAdjustment3 a
                    JOIN #OtherInsuredAdjustment2 b ON ( a.OtherInsuredId = b.OtherInsuredId
                                                         AND a.HIPAAGroupCode = b.HIPAAGroupCode
                                                         AND a.HIPAACode1 = b.HIPAACode
                                                       )  
  


            IF @@error <> 0
                GOTO error  
  

            UPDATE  a
            SET     a.HIPAACode2 = b.HIPAACode ,
                    a.Amount2 = b.Amount
            FROM    #OtherInsuredAdjustment3 a
                    JOIN #OtherInsuredAdjustment2 b ON ( a.OtherInsuredId = b.OtherInsuredId
                                                         AND a.HIPAAGroupCode = b.HIPAAGroupCode
                                                         AND a.HIPAACode1 <> b.HIPAACode
                                                       )  
  


            IF @@error <> 0
                GOTO error  
  

            UPDATE  a
            SET     a.HIPAACode3 = b.HIPAACode ,
                    a.Amount3 = b.Amount
            FROM    #OtherInsuredAdjustment3 a
                    JOIN #OtherInsuredAdjustment2 b ON ( a.OtherInsuredId = b.OtherInsuredId
                                                         AND a.HIPAAGroupCode = b.HIPAAGroupCode
                                                         AND a.HIPAACode1 <> b.HIPAACode
                                                         AND a.HIPAACode2 <> b.HIPAACode
                                                       )  
  


            IF @@error <> 0
                GOTO error  
  

            UPDATE  a
            SET     a.HIPAACode4 = b.HIPAACode ,
                    a.Amount4 = b.Amount
            FROM    #OtherInsuredAdjustment3 a
                    JOIN #OtherInsuredAdjustment2 b ON ( a.OtherInsuredId = b.OtherInsuredId
                                                         AND a.HIPAAGroupCode = b.HIPAAGroupCode
                                                         AND a.HIPAACode1 <> b.HIPAACode
                                                         AND a.HIPAACode2 <> b.HIPAACode
                                                         AND a.HIPAACode3 <> b.HIPAACode
                                                       )  
  


            IF @@error <> 0
                GOTO error  
  

            UPDATE  a
            SET     a.HIPAACode5 = b.HIPAACode ,
                    a.Amount5 = b.Amount
            FROM    #OtherInsuredAdjustment3 a
                    JOIN #OtherInsuredAdjustment2 b ON ( a.OtherInsuredId = b.OtherInsuredId
                                                         AND a.HIPAAGroupCode = b.HIPAAGroupCode
                                                         AND a.HIPAACode1 <> b.HIPAACode
                                                         AND a.HIPAACode2 <> b.HIPAACode
                                                         AND a.HIPAACode3 <> b.HIPAACode
                                                         AND a.HIPAACode4 <> b.HIPAACode
                                                       )  
  


            IF @@error <> 0
                GOTO error  
  

            UPDATE  a
            SET     a.HIPAACode6 = b.HIPAACode ,
                    a.Amount6 = b.Amount
            FROM    #OtherInsuredAdjustment3 a
                    JOIN #OtherInsuredAdjustment2 b ON ( a.OtherInsuredId = b.OtherInsuredId
                                                         AND a.HIPAAGroupCode = b.HIPAAGroupCode
                                                         AND a.HIPAACode1 <> b.HIPAACode
                                                         AND a.HIPAACode2 <> b.HIPAACode
                                                         AND a.HIPAACode3 <> b.HIPAACode
                                                         AND a.HIPAACode4 <> b.HIPAACode
                                                         AND a.HIPAACode5 <> b.HIPAACode
                                                       )  
  


            IF @@error <> 0
                GOTO error  
  

-- Update patient responsibility amount  
            UPDATE  a
            SET     a.ClientResponsibility = ISNULL(b.Amount1, 0) + ISNULL(b.Amount2, 0) + ISNULL(b.Amount3, 0) + ISNULL(b.Amount4, 0) + ISNULL(b.Amount5, 0) + ISNULL(b.Amount6, 0)
            FROM    #OtherInsured a
                    JOIN #OtherInsuredAdjustment3 b ON ( a.OtherInsuredId = b.OtherInsuredId
                                                         AND b.HIPAAGroupCode = 'PR'
                                                       )                  
                                               

            IF @@error <> 0
                GOTO error  

        END		


-- Default Values and Hipaa Codes  
    UPDATE  #ClaimLines
    SET     ClientSex = CASE WHEN ClientSex NOT IN ( 'M', 'F', 'U' ) THEN NULL
                             ELSE ClientSex
                        END ,
            InsuredSex = CASE WHEN InsuredSex NOT IN ( 'M', 'F', 'U' ) THEN NULL
                              ELSE InsuredSex
                         END ,
            MedicareInsuranceTypeCode = CASE WHEN MedicareInsuranceTypeCode IS NULL
                                                  AND Priority > 1
                                                  AND MedicarePayer = 'Y' THEN '47'
                                             ELSE MedicareInsuranceTypeCode
                                        END ,
            PlaceOfServiceCode = CASE WHEN PlaceOfServiceCode IS NULL THEN '11'
                                      ELSE PlaceOfServiceCode
                                 END  
  


    IF @@error <> 0
        GOTO error  
  
  
  

    UPDATE  a
    SET     a.InsuredRelationCode = CASE WHEN a.InsuredRelation IS NULL THEN '18'
                                         WHEN b.ExternalCode1 = '32'
                                              AND a.ClientSex = 'M' THEN '33'
                                         ELSE b.ExternalCode1
                                    END
    FROM    #ClaimLines a
            LEFT JOIN dbo.GlobalCodes b ON ( a.InsuredRelation = b.GlobalCodeId )  
  

    IF @@error <> 0
        GOTO error  
  

    UPDATE  #OtherInsured
    SET     InsuredSex = CASE WHEN InsuredSex NOT IN ( 'M', 'F' ) THEN NULL
                              ELSE InsuredSex
                         END  
  


    IF @@error <> 0
        GOTO error  
  

    UPDATE  a
    SET     a.InsuredRelationCode = CASE WHEN a.InsuredRelation IS NULL THEN '18'
                                         WHEN b.ExternalCode1 = '32'
                                              AND a2.ClientSex = 'M' THEN '33'
                                         ELSE b.ExternalCode1
                                    END
    FROM    #OtherInsured a
            JOIN #ClaimLines a2 ON ( a.ClaimLineId = a2.ClaimLineId )
            LEFT JOIN dbo.GlobalCodes b ON ( a.InsuredRelation = b.GlobalCodeId )  
  

    IF @@error <> 0
        GOTO error  
  

-- Set Admit Date  
    UPDATE  #ClaimLines
    SET     RelatedHospitalAdmitDate = RegistrationDate
    WHERE   PlaceOfServiceCode IN ( '21', '31', '51', '52', '62' )   
  

    IF @@error <> 0
        GOTO error  
     
	  
-- Update zip codes for electronic claims
    IF @Electronic = 'Y'
        BEGIN
            UPDATE  #ClaimLines
            SET     ClientZip = LEFT(REPLACE(ClientZip, '-', '') + '9999', 9) ,
                    InsuredZip = LEFT(REPLACE(InsuredZip, '-', '') + '9999', 9) ,
                    PaymentZip = LEFT(REPLACE(PaymentZip, '-', '') + '9999', 9) ,
                    FacilityZip = LEFT(REPLACE(FacilityZip, '-', '') + '9999', 9) ,
                    PayerZip = LEFT(REPLACE(PayerZip, '-', '') + '9999', 9) 

			UPDATE #OtherInsured
			SET  PayerZip = Left(REPLACE(PayerZip, '-', '') + '9999', 9) 
        END 




-- Custom Updates

    IF @Electronic = 'Y'
        BEGIN 
            EXEC dbo.scsp_PMClaims837UpdateClaimLines @CurrentUser = @ParamCurrentUser, @ClaimBatchId = @ParamClaimBatchId, @FormatType = @FormatType  
  
            IF @@error <> 0
                GOTO error 
                
            UPDATE  dbo.ClaimBatches
            SET     BatchProcessProgress = 40
            WHERE   ClaimBatchId = @ParamClaimBatchId    
    
            IF @@error <> 0
                GOTO error  
                
        END


    IF @Electronic <> 'Y'
        BEGIN
            EXEC dbo.scsp_PMClaimsHCFA1500UpdateClaimLines @CurrentUser = @ParamCurrentUser, @ClaimBatchId = @ParamClaimBatchId    
    
            IF @@error <> 0
                GOTO error    
    
            UPDATE  dbo.ClaimBatches
            SET     BatchProcessProgress = 40
            WHERE   ClaimBatchId = @ParamClaimBatchId    
    
            IF @@error <> 0
                GOTO error  
        END 
        

        
-- Set Diagnosis Codes
    CREATE TABLE #ClaimLineDiagnoses837
        (
          DiagnosisId INT IDENTITY
                          NOT NULL ,
          ClaimLineId INT NOT NULL ,
          DiagnosisCode VARCHAR(20) NULL ,
          PrimaryDiagnosis CHAR(1) NULL ,
          IsICD10Code CHAR(1) null,
		  DiagnosisOrder int
        )  
  
    IF @@error <> 0
        GOTO error  
  
    CREATE TABLE #ClaimLineDiagnoses837Columns
        (
          ClaimLineId INT NOT NULL ,
          DiagnosisId1 INT NULL ,
          DiagnosisId2 INT NULL ,
          DiagnosisId3 INT NULL ,
          DiagnosisId4 INT NULL ,
          DiagnosisId5 INT NULL ,
          DiagnosisId6 INT NULL ,
          DiagnosisId7 INT NULL ,
          DiagnosisId8 INT NULL,  
		)  
  
    IF @@error <> 0
        GOTO ERROR
        

    -- 09-OCT-2014	Akwinass
    CREATE TABLE #Services
        (
          ClaimLineId INT NOT NULL ,
          ServiceId INT NULL ,
          DateOfService DATETIME
        )

    IF @@error <> 0
        GOTO error

    CREATE TABLE #ServiceDiagnosis
        (
          ClaimLineId INT NOT NULL ,
          IsICD10Code CHAR(1) NULL ,
          DiagnosisCode VARCHAR(20) ,
          [Order] INT ,
          Rnk INT
        )

    IF @@error <> 0
        GOTO error



-- Added 01/15/2014 Common logic for populating #ServiceDiagnosis for Electronic and Paper

    INSERT  INTO #Services
            ( ClaimLineId ,
              ServiceId ,
              DateOfService
			)
            SELECT DISTINCT
                    ClaimLineId ,
                    ServiceId ,
                    DateOfService
            FROM    #Charges

    IF @@error <> 0
        GOTO ERROR

-- Get Diagnoses from ServiceDiagnosis
-- T.Remisoski - changed to handle the case when migrated data does not carry in the [Order] value.
    INSERT  INTO #ServiceDiagnosis
            ( ClaimLineId ,
              [Order] ,
              IsICD10Code ,
              DiagnosisCode 
			)
            SELECT  z.ClaimLineId ,
                    ROW_NUMBER() OVER ( ORDER BY z.[Order] ASC, z.DiagnosisCode ASC ) ,
                    z.IsICD10Code ,
                    z.DiagnosisCode
            FROM    ( SELECT DISTINCT
                                a.ClaimLineId ,
                                b.[Order] AS [Order] ,
                                CASE WHEN DATEDIFF(DAY, @ICD10StartDate, a.DateOfService) >= 0 THEN 'Y'
                                     ELSE 'N'
                                END AS IsICD10Code ,
                    -- I noticed the asterisk character getting saved in ServiceDiagnosis.ICD10 so removing it here
                                CASE WHEN DATEDIFF(DAY, @ICD10StartDate, a.DateOfService) >= 0 THEN REPLACE(b.ICD10Code, '*', '')
                                     ELSE ISNULL(b.DSMCode, b.ICD9Code)
                                END AS DiagnosisCode
                      FROM      #Services a
                                JOIN dbo.ServiceDiagnosis b ON b.ServiceId = a.ServiceId
                                                               AND ISNULL(b.RecordDeleted, 'N') = 'N'
                      WHERE     ( ( ( @ICD10StartDate IS NULL
                                    OR DATEDIFF(DAY, @ICD10StartDate, a.DateOfService) < 0
                                    ) -- Msood 01/11/2018
                                    --AND ( b.DSMCode IS NOT NULL
                                    --      OR b.ICD9Code IS NOT NULL
                                   --     )
                                  )
                                  OR ( DATEDIFF(DAY, @ICD10StartDate, a.DateOfService) >= 0
                                       AND b.ICD10Code IS NOT NULL
                                     )
                                )
                    ) AS z
                            
                            
                            
                            
    IF @@error <> 0
        GOTO error

-- Remove duplicate diagnoses having different orders, remove the one with the higher order
    UPDATE  a
    SET     a.DiagnosisCode = NULL
    FROM    #ServiceDiagnosis a
            JOIN #ServiceDiagnosis b ON b.ClaimLineId = a.ClaimLineId
                                        AND b.DiagnosisCode = a.DiagnosisCode
    WHERE   a.[Order] > b.[Order] 

    DELETE  FROM #ServiceDiagnosis
    WHERE   DiagnosisCode IS NULL
            OR DiagnosisCode = '799.9'	-- T.Remisoski - Need better way
            OR DiagnosisCode IN ( SELECT DISTINCT
                                            ICD10Code
                                  FROM      dbo.DiagnosisICD10Codes b
                                  WHERE     b.ICD10CodeType = 'PCS' )


    IF @@error <> 0
        GOTO error

        
-- Convert to ICD Codes
    UPDATE  a
    SET     a.DiagnosisCode = d.ICDCode
    FROM    #ServiceDiagnosis a
            JOIN #ClaimLines b ON ( a.ClaimLineId = b.ClaimLineId )
            JOIN dbo.CoveragePlans c ON ( b.CoveragePlanId = c.CoveragePlanId )
            JOIN dbo.DiagnosisDSMCodes d ON ( a.DiagnosisCode = d.DSMCode )
    WHERE   ISNULL(c.BillingDiagnosisType, 'I') = 'I'
            AND d.ICDCode IS NOT NULL
            AND a.IsICD10Code = 'N'
                    
    IF @@error <> 0
        GOTO error




    DECLARE @ExecuteClaimGrouperSCSP CHAR(1) = 'N'
        
-- 837P Diagnoses
    IF @Electronic = 'Y'
        BEGIN
		-- 3/25 Added Claim Grouping and Diag Code SCSP. 
		-- Note: This scsp is called later for HCFA since there is more Claim Grouping logic at that stage and it is specific for HCFA.
            IF EXISTS ( SELECT  *
                        FROM    sys.objects
                        WHERE   name = 'scsp_PMClaims837GrouperAndDiagnosisCodeCalculation'
                                AND type = 'P' )
                BEGIN
                    EXEC dbo.scsp_PMClaims837GrouperAndDiagnosisCodeCalculation @CurrentUser = @ParamCurrentUser, @ClaimFormatId = @ClaimFormatId, @ClaimBatchId = @ParamClaimBatchId, @FormatType = @FormatType, @ExecuteClaimGrouperSCSP = @ExecuteClaimGrouperSCSP OUTPUT
                END
			
            IF ( @ExecuteClaimGrouperSCSP = 'N' )
                BEGIN                   

-- Order Diagnosis
        ;
                    WITH    OrderingDiagnosis
                              AS ( SELECT  DISTINCT
                                            ClaimLineId ,
                                            DiagnosisCode ,
                                            ROW_NUMBER() OVER ( PARTITION BY ClaimLineId ORDER BY [Order] ASC, DiagnosisCode ASC ) AS Rnk
                                   FROM     #ServiceDiagnosis
                                 )
                        UPDATE  a
                        SET     a.Rnk = b.Rnk
                        FROM    #ServiceDiagnosis a
                                JOIN OrderingDiagnosis b ON b.ClaimLineId = a.ClaimLineId
                                                            AND b.DiagnosisCode = a.DiagnosisCode

                    IF @@error <> 0
                        GOTO error

-- Update #ClaimLines

                    UPDATE  a
                    SET     a.DiagnosisQualifier1 = CASE WHEN ISNULL(b.IsICD10Code, 'N') = 'Y' THEN 'ABK'
                                                         ELSE 'BK'
                                                    END ,
                            a.DiagnosisCode1 = b.DiagnosisCode ,
                            a.DiagnosisPointer1 = '1'
                    FROM    #ClaimLines a
                            JOIN #ServiceDiagnosis b ON b.ClaimLineId = a.ClaimLineId
                    WHERE   b.Rnk = 1


                    UPDATE  a
                    SET     a.DiagnosisQualifier2 = CASE WHEN ISNULL(b.IsICD10Code, 'N') = 'Y' THEN 'ABF'
                                                         ELSE 'BF'
                                                    END ,
                            a.DiagnosisCode2 = b.DiagnosisCode ,
                            a.DiagnosisPointer2 = '2'
                    FROM    #ClaimLines a
                            JOIN #ServiceDiagnosis b ON b.ClaimLineId = a.ClaimLineId
                    WHERE   b.Rnk = 2


                    UPDATE  a
                    SET     a.DiagnosisQualifier3 = CASE WHEN ISNULL(b.IsICD10Code, 'N') = 'Y' THEN 'ABF'
                                                         ELSE 'BF'
                                                    END ,
                            a.DiagnosisCode3 = b.DiagnosisCode ,
                            a.DiagnosisPointer3 = '3'
                    FROM    #ClaimLines a
                            JOIN #ServiceDiagnosis b ON b.ClaimLineId = a.ClaimLineId
                    WHERE   b.Rnk = 3        
        

                    UPDATE  a
                    SET     a.DiagnosisQualifier4 = CASE WHEN ISNULL(b.IsICD10Code, 'N') = 'Y' THEN 'ABF'
                                                         ELSE 'BF'
                                                    END ,
                            a.DiagnosisCode4 = b.DiagnosisCode ,
                            a.DiagnosisPointer4 = '4'
                    FROM    #ClaimLines a
                            JOIN #ServiceDiagnosis b ON b.ClaimLineId = a.ClaimLineId
                    WHERE   b.Rnk = 4        
        
        
                    UPDATE  a
                    SET     a.DiagnosisQualifier5 = CASE WHEN ISNULL(b.IsICD10Code, 'N') = 'Y' THEN 'ABF'
                                                         ELSE 'BF'
                                                    END ,
                            a.DiagnosisCode5 = b.DiagnosisCode ,
                            a.DiagnosisPointer5 = '5'
                    FROM    #ClaimLines a
                            JOIN #ServiceDiagnosis b ON b.ClaimLineId = a.ClaimLineId
                    WHERE   b.Rnk = 5
        
                    UPDATE  a
                    SET     a.DiagnosisQualifier6 = CASE WHEN ISNULL(b.IsICD10Code, 'N') = 'Y' THEN 'ABF'
                                                         ELSE 'BF'
                                                    END ,
                            a.DiagnosisCode6 = b.DiagnosisCode ,
                            a.DiagnosisPointer6 = '6'
                    FROM    #ClaimLines a
                            JOIN #ServiceDiagnosis b ON b.ClaimLineId = a.ClaimLineId
                    WHERE   b.Rnk = 6
        
        
                    UPDATE  a
                    SET     a.DiagnosisQualifier7 = CASE WHEN ISNULL(b.IsICD10Code, 'N') = 'Y' THEN 'ABF'
                                                         ELSE 'BF'
                                                    END ,
                            a.DiagnosisCode7 = b.DiagnosisCode ,
                            a.DiagnosisPointer7 = '7'
                    FROM    #ClaimLines a
                            JOIN #ServiceDiagnosis b ON b.ClaimLineId = a.ClaimLineId
                    WHERE   b.Rnk = 7
        
        
                    UPDATE  a
                    SET     a.DiagnosisQualifier8 = CASE WHEN ISNULL(b.IsICD10Code, 'N') = 'Y' THEN 'ABF'
                                                         ELSE 'BF'
                                                    END ,
                            a.DiagnosisCode8 = b.DiagnosisCode ,
                            a.DiagnosisPointer8 = '8'
                    FROM    #ClaimLines a
                            JOIN #ServiceDiagnosis b ON b.ClaimLineId = a.ClaimLineId
                    WHERE   b.Rnk = 8


                    UPDATE  #ClaimLines
                    SET     DiagnosisCode1 = CASE WHEN ISNULL(DiagnosisCode1, '') = '' THEN NULL
                                                  ELSE DiagnosisCode1
                                             END ,
                            DiagnosisCode2 = CASE WHEN ISNULL(DiagnosisCode2, '') = '' THEN NULL
                                                  ELSE DiagnosisCode2
                                             END ,
                            DiagnosisCode3 = CASE WHEN ISNULL(DiagnosisCode3, '') = '' THEN NULL
                                                  ELSE DiagnosisCode3
                                             END ,
                            DiagnosisCode4 = CASE WHEN ISNULL(DiagnosisCode4, '') = '' THEN NULL
                                                  ELSE DiagnosisCode4
                                             END ,
                            DiagnosisCode5 = CASE WHEN ISNULL(DiagnosisCode5, '') = '' THEN NULL
                                                  ELSE DiagnosisCode5
                                             END ,
                            DiagnosisCode6 = CASE WHEN ISNULL(DiagnosisCode6, '') = '' THEN NULL
                                                  ELSE DiagnosisCode6
                                             END ,
                            DiagnosisCode7 = CASE WHEN ISNULL(DiagnosisCode7, '') = '' THEN NULL
                                                  ELSE DiagnosisCode7
                                             END ,
                            DiagnosisCode8 = CASE WHEN ISNULL(DiagnosisCode8, '') = '' THEN NULL
                                                  ELSE DiagnosisCode8
                                             END ,
                            DiagnosisPointer1 = CASE WHEN ISNULL(DiagnosisCode1, '') = '' THEN NULL
                                                     ELSE DiagnosisPointer1
                                                END ,
                            DiagnosisPointer2 = CASE WHEN ISNULL(DiagnosisCode2, '') = '' THEN NULL
                                                     ELSE DiagnosisPointer2
                                                END ,
                            DiagnosisPointer3 = CASE WHEN ISNULL(DiagnosisCode3, '') = '' THEN NULL
                                                     ELSE DiagnosisPointer3
                                                END ,
                            DiagnosisPointer4 = CASE WHEN ISNULL(DiagnosisCode4, '') = '' THEN NULL
                                                     ELSE DiagnosisPointer4
                                                END ,
                            DiagnosisPointer5 = CASE WHEN ISNULL(DiagnosisCode5, '') = '' THEN NULL
                                                     ELSE DiagnosisPointer5
                                                END ,
                            DiagnosisPointer6 = CASE WHEN ISNULL(DiagnosisCode6, '') = '' THEN NULL
                                                     ELSE DiagnosisPointer6
                                                END ,
                            DiagnosisPointer7 = CASE WHEN ISNULL(DiagnosisCode7, '') = '' THEN NULL
                                                     ELSE DiagnosisPointer7
                                                END ,
                            DiagnosisPointer8 = CASE WHEN ISNULL(DiagnosisCode8, '') = '' THEN NULL
                                                     ELSE DiagnosisPointer8
                                                END
  
  
 
  
                    IF @@error <> 0
                        GOTO error 
                END      
        END		

    UPDATE  dbo.ClaimBatches
    SET     BatchProcessProgress = 50
    WHERE   ClaimBatchId = @ParamClaimBatchId  


---- HCFA1500 Diagnoses		
--    IF @Electronic <> 'Y'
--        BEGIN
   
   
-- Order Diagnosis
        ;
    WITH    OrderingDiagnosis
              AS ( SELECT  DISTINCT
                            ClaimLineId ,
                            DiagnosisCode ,
                            ROW_NUMBER() OVER ( PARTITION BY ClaimLineId ORDER BY [Order] asc, DiagnosisCode asc ) AS Rnk
                   FROM     #ServiceDiagnosis
                 )
        UPDATE  a
        SET     a.Rnk = b.Rnk
        FROM    #ServiceDiagnosis a
                JOIN OrderingDiagnosis b ON b.ClaimLineId = a.ClaimLineId
                                            AND b.DiagnosisCode = a.DiagnosisCode

 
    IF @@error <> 0
        GOTO ERROR
            
    INSERT  INTO #ClaimLineDiagnoses837
            ( ClaimLineId ,
              DiagnosisCode ,
              PrimaryDiagnosis ,
              IsICD10Code,
			  DiagnosisOrder
			)
            SELECT DISTINCT
                    ClaimLineId ,
                    DiagnosisCode ,
                    'Y' ,
                    IsICD10Code,
					Rnk
            FROM    #ServiceDiagnosis
            WHERE   Rnk = 1
    
    IF @@error <> 0
        GOTO error    
    
    insert  into #ClaimLineDiagnoses837
            (ClaimLineId,
             DiagnosisCode,
             IsICD10Code,
             DiagnosisOrder)
    select  a.ClaimLineId,
            a.DiagnosisCode,
            a.IsICD10Code,
            min(a.Rnk)
    from    #ServiceDiagnosis a
    where   not exists ( select *
                         from   #ClaimLineDiagnoses837 b
                         where  a.ClaimLineId = b.ClaimLineId
                                and a.DiagnosisCode = b.DiagnosisCode )
    group by a.ClaimLineId,
            a.DiagnosisCode,
            a.IsICD10Code
    
    IF @@error <> 0
        GOTO error    
                
           
    UPDATE  dbo.ClaimBatches
    SET     BatchProcessProgress = 50
    WHERE   ClaimBatchId = @ParamClaimBatchId 
           
    IF @@error <> 0
        GOTO error    
        --END
        

-- Delete Old ChargeErrors  
    DELETE  c
    FROM    ClaimBatchCharges b
            JOIN dbo.ChargeErrors c ON ( b.ChargeId = c.ChargeId )
    WHERE   b.ClaimBatchId = @ParamClaimBatchId

  
    IF @@error <> 0
        GOTO error      
      

-- Validate required fields    
    EXEC dbo.ssp_PMClaims837Validations @ParamCurrentUser, @ParamClaimBatchId, @FormatType  


-- Delete the error Charges    
    DELETE  a
    FROM    #ClaimLines a
            JOIN dbo.ChargeErrors b ON ( a.ChargeId = b.ChargeId )   

   
	
    IF @@error <> 0
        GOTO error 

    UPDATE  dbo.ClaimBatches
    SET     BatchProcessProgress = 55
    WHERE   ClaimBatchId = @ParamClaimBatchId 
            
	
    IF @@error <> 0
        GOTO error 
        
-- Update PrimaryServiceId in #ClaimLines
    UPDATE  a
    SET     PrimaryServiceId = c.ServiceId
    FROM    #ClaimLines a
            JOIN #Charges b ON b.ClaimLineId = a.ClaimLineId
            JOIN dbo.Services c ON c.ServiceId = b.ServiceId
            JOIN dbo.ServiceAddOnCodes d ON d.ServiceId = c.ServiceId
            JOIN #Charges e ON e.ServiceId = d.AddOnServiceId
            JOIN dbo.CoveragePlans f ON f.CoveragePlanId = b.CoveragePlanId
    WHERE   ISNULL(f.AddOnChargesOption, '') IN ( 'A', 'B' )
	
    UPDATE  e2
    SET     PrimaryServiceId = c.ServiceId
    FROM    #ClaimLines a
            JOIN #Charges b ON b.ClaimLineId = a.ClaimLineId
            JOIN dbo.Services c ON c.ServiceId = b.ServiceId
            JOIN dbo.ServiceAddOnCodes d ON d.ServiceId = c.ServiceId
            JOIN #Charges e ON e.ServiceId = d.AddOnServiceId
            JOIN #ClaimLines e2 ON e2.ClaimLineId = e.ClaimLineId
            JOIN dbo.CoveragePlans f ON f.CoveragePlanId = b.CoveragePlanId
    WHERE   ISNULL(f.AddOnChargesOption, '') IN ( 'A', 'B' )	
	           
	           
    IF @@error <> 0
        GOTO error 	           
       
---- Generate 837P

    IF @Electronic = 'Y'
        BEGIN
			
-- Bundling Logic

            CREATE TABLE #Claims
                (
                  ClaimId INT IDENTITY
                              NOT NULL ,
                  ClientId INT ,
                  ClientIdGroup INT ,
                  ClientAddress1 VARCHAR(30) ,
                  ClientAddress2 VARCHAR(30) ,
                  ClientCity VARCHAR(30) ,
                  ClientState CHAR(2) ,
                  ClientZip CHAR(25) ,
                  InsuredAddress1 VARCHAR(30) NULL ,
                  InsuredAddress2 VARCHAR(30) NULL ,
                  InsuredCity VARCHAR(30) NULL ,
                  InsuredState CHAR(2) NULL ,
                  InsuredZip VARCHAR(25) NULL ,
                  MinClaimLineId INT ,
                  MaxClaimLineId INT ,
                  MinDateOfService DATETIME ,
                  MaxDateOfService DATETIME ,
                  YearOfService INT ,
                  MonthOfService INT ,
                  WeekOfService INT ,
                  DateOfService DATETIME ,
                  ClaimAmount MONEY ,
                  BillingProviderNPI VARCHAR(10) NULL ,
                  PlaceOfService CHAR(2) NULL ,
                  RenderingProviderNPI VARCHAR(10) NULL ,
                  RenderingProviderSecondaryId VARCHAR(35) NULL ,
                  SupervisingProvider2310DId VARCHAR(80) NULL ,
                  SupervisingProvider2310DSecondaryId1 VARCHAR(50) NULL ,
                  SupervisingProvider2310DSecondaryId2 VARCHAR(50) NULL ,
                  SupervisingProvider2310DSecondaryId3 VARCHAR(50) NULL ,
                  SupervisingProvider2310DSecondaryId4 VARCHAR(50) NULL ,
                  AuthorizationId VARCHAR(35) NULL ,
                  BundlingTimeFrame CHAR(1) NULL ,
                  PrimaryDiagnosis VARCHAR(10) NULL ,
                  BillingCode VARCHAR(10) NULL ,
                  Modifier1 CHAR(2) NULL ,
                  Modifier2 CHAR(2) NULL ,
                  Modifier3 CHAR(2) NULL ,
                  Modifier4 CHAR(2) NULL ,
                  RevenueCode VARCHAR(10) NULL ,
                  RevenueCodeDescription VARCHAR(100) NULL ,
                  IsICD10Claim CHAR(1) NULL ,
                  PayerClaimControlNumber VARCHAR(80) NULL ,
                  MedicalRecordNumber VARCHAR(30) NULL ,
                  PrimaryServiceId INT NULL ,
				  [Priority] INT NULL
                )
	
            CREATE TABLE #ClaimLineBundling
                (
                  ClaimLineId INT ,
                  CoveragePlanId INT ,
                  ClaimFormatId INT ,
                  BillingProviderNPI VARCHAR(10) NULL ,
                  PlaceOfService CHAR(2) NULL ,
                  ClientId INT NULL ,
                  ClientIdGroup INT ,
                  ClientAddress1 VARCHAR(30) ,
                  ClientAddress2 VARCHAR(30) ,
                  ClientCity VARCHAR(30) ,
                  ClientState CHAR(2) ,
                  ClientZip CHAR(25) ,
                  InsuredAddress1 VARCHAR(30) NULL ,
                  InsuredAddress2 VARCHAR(30) NULL ,
                  InsuredCity VARCHAR(30) NULL ,
                  InsuredState CHAR(2) NULL ,
                  InsuredZip VARCHAR(25) NULL ,
                  RenderingProviderNPI VARCHAR(10) NULL ,
                  RenderingProviderSecondaryId VARCHAR(35) NULL ,
                  SupervisingProvider2310DId VARCHAR(80) NULL ,
                  SupervisingProvider2310DSecondaryId1 VARCHAR(50) NULL ,
                  SupervisingProvider2310DSecondaryId2 VARCHAR(50) NULL ,
                  SupervisingProvider2310DSecondaryId3 VARCHAR(50) NULL ,
                  SupervisingProvider2310DSecondaryId4 VARCHAR(50) NULL ,
                  AuthorizationId VARCHAR(35) NULL ,
                  BundlingTimeFrame CHAR(1) NULL ,
                  PrimaryDiagnosis VARCHAR(10) NULL ,
                  BillingCode VARCHAR(10) NULL ,
                  Modifier1 CHAR(2) NULL ,
                  Modifier2 CHAR(2) NULL ,
                  Modifier3 CHAR(2) NULL ,
                  Modifier4 CHAR(2) NULL ,
                  RevenueCode VARCHAR(10) NULL ,
                  RevenueCodeDescription VARCHAR(100) NULL ,
                  YearOfService INT ,
                  MonthOfService INT ,
                  WeekOfService INT ,
                  DateOfService DATETIME ,
                  IsICD10Claim CHAR(1) ,
                  PayerClaimControlNumber VARCHAR(80) NULL ,
                  MedicalRecordNumber VARCHAR(30) NULL ,
                  PrimaryServiceId INT NULL,
				  [Priority] INT NULL
                )
	
	
            IF @@error <> 0
                GOTO error 
        
        
            INSERT  INTO #ClaimLineBundling
                    ( ClaimLineId ,
                      CoveragePlanId ,
                      ClaimFormatId ,
                      BillingProviderNPI ,
                      PlaceOfService ,
                      ClientId ,
                      ClientAddress1 ,
                      ClientAddress2 ,
                      ClientCity ,
                      ClientState ,
                      ClientZip ,
                      InsuredAddress1 ,
                      InsuredAddress2 ,
                      InsuredCity ,
                      InsuredState ,
                      InsuredZip ,
                      RenderingProviderNPI ,
                      RenderingProviderSecondaryId ,
                      SupervisingProvider2310DId ,
                      SupervisingProvider2310DSecondaryId1 ,
                      SupervisingProvider2310DSecondaryId2 ,
                      SupervisingProvider2310DSecondaryId3 ,
                      SupervisingProvider2310DSecondaryId4 ,
                      AuthorizationId ,
                      BundlingTimeFrame ,
                      PrimaryDiagnosis ,
                      BillingCode ,
                      Modifier1 ,
                      Modifier2 ,
                      Modifier3 ,
                      Modifier4 ,
                      RevenueCode ,
                      RevenueCodeDescription ,
                      YearOfService ,
                      MonthOfService ,
                      WeekOfService ,
                      DateOfService ,
                      PayerClaimControlNumber ,
                      MedicalRecordNumber ,
                      PrimaryServiceId,
					  [Priority]
					)
                    SELECT DISTINCT
                            ClaimLineId ,
                            CoveragePlanId ,
                            @ClaimFormatId ,
                            BillingProviderNPI ,
                            PlaceOfServiceCode ,
                            ClientId ,
                            ClientAddress1 ,
                            ClientAddress2 ,
                            ClientCity ,
                            ClientState ,
                            ClientZip ,
                            InsuredAddress1 ,
                            InsuredAddress2 ,
                            InsuredCity ,
                            InsuredState ,
                            InsuredZip ,
                            RenderingProviderNPI ,
                            RenderingProviderId ,
                            SupervisingProvider2310DId ,
                            SupervisingProvider2310DSecondaryId1 ,
                            SupervisingProvider2310DSecondaryId2 ,
                            SupervisingProvider2310DSecondaryId3 ,
                            SupervisingProvider2310DSecondaryId4 ,
                            AuthorizationNumber ,
                            NULL ,
                            DiagnosisCode1 ,
                            BillingCode ,
                            Modifier1 ,
                            Modifier2 ,
                            Modifier3 ,
                            Modifier4 ,
                            RevenueCode ,
                            RevenueCodeDescription ,
                            DATEPART(YEAR, DateOfService) ,
                            DATEPART(MONTH, DateOfService) ,
                            DATEPART(WEEK, DateOfService) ,
                            DateOfService ,
                            PayerClaimControlNumber ,
                            MedicalRecordNumber ,
                            PrimaryServiceId
						  , [Priority]
                    FROM    #ClaimLines

            UPDATE  #ClaimLineBundling
            SET     IsICD10Claim = CASE WHEN EXISTS ( SELECT    1
                                                      FROM      #ServiceDiagnosis sd
                                                      WHERE     sd.ClaimLineId = sd.ClaimLineId
                                                                AND ISNULL(sd.IsICD10Code, 'N') = 'Y' ) THEN 'Y'
                                        ELSE 'N'
                                   END
  
                                                           
                     
		        
            IF @@error <> 0
                GOTO ERROR
        
	-- By default no bundling will occur, all NULL values in the configuration table will be treated as No
            UPDATE  a
            SET     a.ClaimLineId = a.ClaimLineId ,
                    a.BillingProviderNPI = a.BillingProviderNPI ,
                    a.PlaceOfService = a.PlaceOfService ,
                    a.ClientId = a.ClientId ,
                    a.YearOfService = CASE WHEN ISNULL(b.BundlingTimeFrame, 'N') IN ( 'A', 'N' ) THEN NULL
                                           ELSE a.YearOfService
                                      END ,
                    a.MonthOfService = CASE WHEN ISNULL(b.BundlingTimeFrame, 'N') = 'M' THEN a.MonthOfService
                                            ELSE NULL
                                       END ,
                    a.WeekOfService = CASE WHEN ISNULL(b.BundlingTimeFrame, 'N') = 'W' THEN a.WeekOfService
                                           ELSE NULL
                                      END ,
                    a.BundlingTimeFrame = b.BundlingTimeFrame ,
                    a.RenderingProviderNPI = CASE WHEN ISNULL(b.RenderingProviderNPI, 'Y') = 'N' THEN NULL
                                                  ELSE a.RenderingProviderNPI
                                             END ,
                    a.RenderingProviderSecondaryId = CASE WHEN ISNULL(b.RenderingProviderSecondaryId, 'Y') = 'N' THEN NULL
                                                          ELSE a.RenderingProviderSecondaryId
                                                     END ,
                    a.SupervisingProvider2310DId = CASE WHEN ISNULL(b.SupervisingProvider2310DId, 'Y') = 'N' THEN NULL
                                                        ELSE a.SupervisingProvider2310DId
                                                   END ,
                    a.SupervisingProvider2310DSecondaryId1 = CASE WHEN ISNULL(b.SupervisingProvider2310DSecondaryId1, 'Y') = 'N' THEN NULL
                                                                  ELSE a.SupervisingProvider2310DSecondaryId1
                                                             END ,
                    a.SupervisingProvider2310DSecondaryId2 = CASE WHEN ISNULL(b.SupervisingProvider2310DSecondaryId2, 'Y') = 'N' THEN NULL
                                                                  ELSE a.SupervisingProvider2310DSecondaryId2
                                                             END ,
                    a.SupervisingProvider2310DSecondaryId3 = CASE WHEN ISNULL(b.SupervisingProvider2310DSecondaryId3, 'Y') = 'N' THEN NULL
                                                                  ELSE a.SupervisingProvider2310DSecondaryId3
                                                             END ,
                    a.SupervisingProvider2310DSecondaryId4 = CASE WHEN ISNULL(b.SupervisingProvider2310DSecondaryId4, 'Y') = 'N' THEN NULL
                                                                  ELSE a.SupervisingProvider2310DSecondaryId4
                                                             END ,
                    a.AuthorizationId = CASE WHEN ISNULL(b.AuthorizationId, 'Y') = 'N' THEN NULL
                                             ELSE a.AuthorizationId
                                        END ,
                    a.PrimaryDiagnosis = CASE WHEN ISNULL(b.PrimaryDiagnosis, 'Y') = 'N' THEN NULL
                                              ELSE a.PrimaryDiagnosis
                                         END ,
                    a.BillingCode = CASE WHEN a.PrimaryServiceId IS NOT NULL THEN NULL
                                         ELSE CASE WHEN ISNULL(b.BillingCode, 'Y') = 'N' THEN NULL
                                                   ELSE a.BillingCode
                                              END
                                    END ,
                    a.Modifier1 = CASE WHEN a.PrimaryServiceId IS NOT NULL THEN NULL
                                       ELSE CASE WHEN ISNULL(b.Modifier1, 'Y') = 'N' THEN NULL
                                                 ELSE a.Modifier1
                                            END
                                  END ,
                    a.Modifier2 = CASE WHEN a.PrimaryServiceId IS NOT NULL THEN NULL
                                       ELSE CASE WHEN ISNULL(b.Modifier2, 'Y') = 'N' THEN NULL
                                                 ELSE a.Modifier2
                                            END
                                  END ,
                    a.Modifier3 = CASE WHEN a.PrimaryServiceId IS NOT NULL THEN NULL
                                       ELSE CASE WHEN ISNULL(b.Modifier3, 'Y') = 'N' THEN NULL
                                                 ELSE a.Modifier3
                                            END
                                  END ,
                    a.Modifier4 = CASE WHEN a.PrimaryServiceId IS NOT NULL THEN NULL
                                       ELSE CASE WHEN ISNULL(b.Modifier4, 'Y') = 'N' THEN NULL
                                                 ELSE a.Modifier4
                                            END
                                  END ,
                    a.RevenueCode = CASE WHEN a.PrimaryServiceId IS NOT NULL THEN NULL
                                         ELSE CASE WHEN ISNULL(b.RevenueCode, 'Y') = 'N' THEN NULL
                                                   ELSE a.RevenueCode
                                              END
                                    END ,
                    a.RevenueCodeDescription = CASE WHEN a.PrimaryServiceId IS NOT NULL THEN NULL
                                                    ELSE CASE WHEN ISNULL(b.RevenueCodeDescription, 'Y') = 'N' THEN NULL
                                                              ELSE a.RevenueCodeDescription
                                                         END
                                               END
            FROM    #ClaimLineBundling a
                    LEFT JOIN dbo.CoveragePlanClaimBundlingCriteria b ON b.CoveragePlanId = a.CoveragePlanId
                                                                         AND b.ClaimFormatId = a.ClaimFormatId
                                                                         AND ISNULL(b.RecordDeleted, 'N') = 'N'
	        
	           -- Set custom bundle code jcs to handle bundling different POS  
   IF OBJECT_ID('dbo.scsp_PMClaims837UpdateBundleInfo', 'P') IS NOT NULL  
    BEGIN              
     EXEC dbo.scsp_PMClaims837UpdateBundleInfo @CurrentUser = @ParamCurrentUser, @ClaimBatchId = @ParamClaimBatchId, @FormatType = @FormatType  
   
    END    
  -- END Set custom bundle code jcs to handle bundling different POS 
	        
	        
	        
	        
    
    
            UPDATE  a
            SET     a.DateOfService = CASE WHEN a.YearOfService IS NULL
                                                AND a.MonthOfService IS NULL
                                                AND a.WeekOfService IS NULL
                                                AND ISNULL(a.BundlingTimeFrame, 'N') <> 'A' THEN a.DateOfService
                                           ELSE NULL
                                      END
            FROM    #ClaimLineBundling a
	
	        
        
            IF @@error <> 0
                GOTO error    
	
	
            INSERT  INTO #Claims
                    ( ClientId ,
                      ClientAddress1 ,
                      ClientAddress2 ,
                      ClientCity ,
                      ClientState ,
                      ClientZip ,
                      InsuredAddress1 ,
                      InsuredAddress2 ,
                      InsuredCity ,
                      InsuredState ,
                      InsuredZip ,
                      MinClaimLineId ,
                      MaxClaimLineId ,
                      MinDateOfService ,
                      MaxDateOfService ,
                      YearOfService ,
                      MonthOfService ,
                      WeekOfService ,
                      DateOfService ,
                      ClaimAmount ,
                      BillingProviderNPI ,
                      PlaceOfService ,
                      RenderingProviderNPI ,
                      RenderingProviderSecondaryId ,
                      SupervisingProvider2310DId ,
                      SupervisingProvider2310DSecondaryId1 ,
                      SupervisingProvider2310DSecondaryId2 ,
                      SupervisingProvider2310DSecondaryId3 ,
                      SupervisingProvider2310DSecondaryId4 ,
                      AuthorizationId ,
                      PrimaryDiagnosis ,
                      BillingCode ,
                      Modifier1 ,
                      Modifier2 ,
                      Modifier3 ,
                      Modifier4 ,
                      RevenueCode ,
                      RevenueCodeDescription ,
                      IsICD10Claim ,
                      PayerClaimControlNumber ,
                      MedicalRecordNumber ,
                      PrimaryServiceId
					  , [Priority]
					)
                    SELECT DISTINCT
                            b.ClientId ,
                            b.ClientAddress1 ,
                            b.ClientAddress2 ,
                            b.ClientCity ,
                            b.ClientState ,
                            b.ClientZip ,
                            b.InsuredAddress1 ,
                            b.InsuredAddress2 ,
                            b.InsuredCity ,
                            b.InsuredState ,
                            b.InsuredZip ,
                            MIN(a.ClaimLineId) ,
                            MAX(a.ClaimLineId) ,
                            MIN(a.DateOfService) ,
                            MAX(a.DateOfService) ,
                            b.YearOfService ,
                            b.MonthOfService ,
                            b.WeekOfService ,
                            b.DateOfService ,
                            SUM(a.ChargeAmount) ,
                            b.BillingProviderNPI ,
                            b.PlaceOfService ,
                            b.RenderingProviderNPI ,
                            b.RenderingProviderSecondaryId ,
                            b.SupervisingProvider2310DId ,
                            b.SupervisingProvider2310DSecondaryId1 ,
                            b.SupervisingProvider2310DSecondaryId2 ,
                            b.SupervisingProvider2310DSecondaryId3 ,
                            b.SupervisingProvider2310DSecondaryId4 ,
                            b.AuthorizationId ,
                            b.PrimaryDiagnosis ,
                            b.BillingCode ,
                            b.Modifier1 ,
                            b.Modifier2 ,
                            b.Modifier3 ,
                            b.Modifier4 ,
                            b.RevenueCode ,
                            b.RevenueCodeDescription ,
                            b.IsICD10Claim ,
                            b.PayerClaimControlNumber ,
                            b.MedicalRecordNumber ,
                            b.PrimaryServiceId
							,b.[Priority]
                    FROM    #ClaimLines a
                            JOIN #ClaimLineBundling b ON b.ClaimLineId = a.ClaimLineId
                    GROUP BY b.BillingProviderNPI ,
                            b.PlaceOfService ,
                            b.ClientId ,
                            b.ClientAddress1 ,
                            b.ClientAddress2 ,
                            b.ClientCity ,
                            b.ClientState ,
                            b.ClientZip ,
                            b.InsuredAddress1 ,
                            b.InsuredAddress2 ,
                            b.InsuredCity ,
                            b.InsuredState ,
                            b.InsuredZip ,
                            b.RenderingProviderNPI ,
                            b.RenderingProviderSecondaryId ,
                            b.SupervisingProvider2310DId ,
                            b.SupervisingProvider2310DSecondaryId1 ,
                            b.SupervisingProvider2310DSecondaryId2 ,
                            b.SupervisingProvider2310DSecondaryId3 ,
                            b.SupervisingProvider2310DSecondaryId4 ,
                            b.AuthorizationId ,
                            b.PrimaryDiagnosis ,
                            b.BillingCode ,
                            b.Modifier1 ,
                            b.Modifier2 ,
                            b.Modifier3 ,
                            b.Modifier4 ,
                            b.RevenueCode ,
                            b.RevenueCodeDescription ,
                            b.YearOfService ,
                            b.MonthOfService ,
                            b.WeekOfService ,
                            b.DateOfService ,
                            b.IsICD10Claim ,
                            b.PayerClaimControlNumber ,
                            b.MedicalRecordNumber ,
                            b.PrimaryServiceId
							,b.[Priority]

            CREATE INDEX XI_Claims_MaxClaimLineId ON #Claims (MaxClaimLineId)
				  


            IF @@error <> 0
                GOTO error    
	
			
			
			--SELECT * FROM #ClaimLineBundling
			
			--SELECT * FROM #Claims
			
			
            UPDATE  a
            SET     a.ClaimId = c.ClaimId
            FROM    #ClaimLines a
                    JOIN #ClaimLineBundling b ON b.ClaimLineId = a.ClaimLineId
                    JOIN #Claims c ON b.ClientId = c.ClientId
                                      AND ISNULL(b.ClientAddress1, '') = ISNULL(c.ClientAddress1, '')
                                      AND ISNULL(b.ClientAddress2, '') = ISNULL(c.ClientAddress2, '')
                                      AND ISNULL(b.ClientCity, '') = ISNULL(c.ClientCity, '')
                                      AND ISNULL(b.ClientState, '') = ISNULL(c.ClientState, '')
                                      AND ISNULL(b.ClientZip, '') = ISNULL(c.ClientZip, '')
                                      AND ISNULL(b.InsuredAddress1, '') = ISNULL(c.InsuredAddress1, '')
                                      AND ISNULL(b.InsuredAddress2, '') = ISNULL(c.InsuredAddress2, '')
                                      AND ISNULL(b.InsuredCity, '') = ISNULL(c.InsuredCity, '')
                                      AND ISNULL(b.InsuredState, '') = ISNULL(c.InsuredState, '')
                                      AND ISNULL(b.InsuredZip, '') = ISNULL(c.InsuredZip, '')
                                      AND b.BillingProviderNPI = c.BillingProviderNPI
                                      AND b.PlaceOfService = c.PlaceOfService
                                      AND ISNULL(b.RenderingProviderNPI, '') = ISNULL(c.RenderingProviderNPI, '')
                                      AND ISNULL(b.RenderingProviderSecondaryId, '') = ISNULL(c.RenderingProviderSecondaryId, '')
                                      AND ISNULL(b.SupervisingProvider2310DId, '') = ISNULL(c.SupervisingProvider2310DId, '')
                                      AND ISNULL(b.SupervisingProvider2310DSecondaryId1, '') = ISNULL(c.SupervisingProvider2310DSecondaryId1, '')
                                      AND ISNULL(b.SupervisingProvider2310DSecondaryId2, '') = ISNULL(c.SupervisingProvider2310DSecondaryId2, '')
                                      AND ISNULL(b.SupervisingProvider2310DSecondaryId3, '') = ISNULL(c.SupervisingProvider2310DSecondaryId3, '')
                                      AND ISNULL(b.SupervisingProvider2310DSecondaryId4, '') = ISNULL(c.SupervisingProvider2310DSecondaryId4, '')
                                      AND ISNULL(b.AuthorizationId, '') = ISNULL(c.AuthorizationId, '')
                                      AND ISNULL(b.PrimaryDiagnosis, '') = ISNULL(c.PrimaryDiagnosis, '')
                                      AND ISNULL(b.BillingCode, '') = ISNULL(c.BillingCode, '')
                                      AND ISNULL(b.Modifier1, '') = ISNULL(c.Modifier1, '')
                                      AND ISNULL(b.Modifier2, '') = ISNULL(c.Modifier2, '')
                                      AND ISNULL(b.Modifier3, '') = ISNULL(c.Modifier3, '')
                                      AND ISNULL(b.Modifier4, '') = ISNULL(c.Modifier4, '')
                                      AND ISNULL(b.RevenueCode, '') = ISNULL(c.RevenueCode, '')
                                      AND ISNULL(b.RevenueCodeDescription, '') = ISNULL(c.RevenueCodeDescription, '')
                                      AND a.ClaimLineId BETWEEN c.MinClaimLineId
                                                        AND     c.MaxClaimLineId
                                      AND CAST(a.DateOfService AS DATE) BETWEEN CAST(c.MinDateOfService AS DATE)
                                                                        AND     CAST(c.MaxDateOfService AS DATE)
                                      AND ISNULL(b.IsICD10Claim, 'N') = ISNULL(c.IsICD10Claim, 'N')
                                      AND ISNULL(b.PayerClaimControlNumber, '') = ISNULL(c.PayerClaimControlNumber, '')
                                      AND ISNULL(b.MedicalRecordNumber, '') = ISNULL(c.MedicalRecordNumber, '')
                                      AND ISNULL(b.PrimaryServiceId, '') = ISNULL(c.PrimaryServiceId, '')
									  AND ISNULL(b.[Priority],'') = ISNULL(c.[Priority],'')
                                      
                                      
													
          -- need to fix diagnosis here somehow.

            
            IF @@error <> 0
                GOTO error

                                
            CREATE TABLE #ClaimDiagnosisRank
                (
                  UniqueId INT IDENTITY ,
                  ClaimId INT ,
                  DiagnosisCode VARCHAR(20) ,
                  IsICD10Code CHAR(1) ,
                  PrimaryDiagnosis CHAR(1) ,
				  DiagnosisOrder int,
                  Rnk INT
                )                                  

            insert  into #ClaimDiagnosisRank
                    (ClaimId,
                     DiagnosisCode,
                     IsICD10Code,
                     DiagnosisOrder)
            select  a.ClaimId,
                    rtrim(ltrim(b.DiagnosisCode)),
                    b.IsICD10Code,
                    min(b.DiagnosisOrder)
            from    #Claims a
                    join #ClaimLines cl on cl.ClaimId = a.ClaimId
                    join #ClaimLineDiagnoses837 b on b.ClaimLineId = cl.ClaimLineId
            group by a.ClaimId,
                    b.DiagnosisCode,
                    b.IsICD10Code

            update  cdr
            set     cdr.PrimaryDiagnosis = 'Y'
            from    #ClaimDiagnosisRank cdr
                    join #Claims c on cdr.ClaimId = c.ClaimId
            where   exists ( select 1
                             from   #ClaimLines cl
                                    join #ClaimLineDiagnoses837 cld on cld.ClaimLineId = cl.ClaimLineId
                             where  cl.ClaimId = c.ClaimId
                                    and cld.DiagnosisCode = cdr.DiagnosisCode
                                    and isnull(cld.PrimaryDiagnosis, 'N') = 'Y' );
            with  rnk_Diagnosis
                    as (select  UniqueId,
                                row_number() over (partition by ClaimId order by isnull(PrimaryDiagnosis, 'N') desc, DiagnosisOrder asc, DiagnosisCode asc) as rnk
                        from    #ClaimDiagnosisRank)
              update  cdr
              set     cdr.Rnk = rd.rnk
              from    #ClaimDiagnosisRank cdr
                      join rnk_Diagnosis rd on cdr.UniqueId = rd.UniqueId
                        
            update  cl
            set     cl.DiagnosisCode1 = null,
                    cl.DiagnosisQualifier1 = null,
                    cl.DiagnosisPointer1 = null,
                    cl.DiagnosisCode2 = null,
                    cl.DiagnosisQualifier2 = null,
                    cl.DiagnosisPointer2 = null,
                    cl.DiagnosisCode3 = null,
                    cl.DiagnosisQualifier3 = null,
                    cl.DiagnosisPointer3 = null,
                    cl.DiagnosisCode4 = null,
                    cl.DiagnosisQualifier4 = null,
                    cl.DiagnosisPointer4 = null,
					cl.DiagnosisCode5 = null,
                    cl.DiagnosisQualifier5 = null,
                    cl.DiagnosisPointer5 = null,
                    cl.DiagnosisCode6 = null,
                    cl.DiagnosisQualifier6 = null,
                    cl.DiagnosisPointer6 = null,
                    cl.DiagnosisCode7 = null,
                    cl.DiagnosisQualifier7 = null,
                    cl.DiagnosisPointer7 = null,
                    cl.DiagnosisCode8 = null,
                    cl.DiagnosisQualifier8 = null,
                    cl.DiagnosisPointer8 = null
            from    #Claims c
                    join #ClaimLines cl on c.ClaimId = cl.ClaimId
  
            -- set up the maxclaimlineitem with the ranked diagnosis.

            update  cl
            set     cl.DiagnosisCode1 = cdr.DiagnosisCode,
                    cl.DiagnosisQualifier1 = case when isnull(cdr.IsICD10Code, 'N') = 'Y' then 'ABK'
                                                  else 'BK'
                                             end,
                    cl.DiagnosisPointer1 = '1'
            from    #Claims c
                    join #ClaimLines cl on c.MaxClaimLineId = cl.ClaimLineId
                    join #ClaimDiagnosisRank cdr on cdr.ClaimId = c.ClaimId
                                                    and cdr.Rnk = 1

            update  cl
            set     cl.DiagnosisCode2 = cdr.DiagnosisCode,
                    cl.DiagnosisQualifier2 = case when isnull(cdr.IsICD10Code, 'N') = 'Y' then 'ABF'
                                                  else 'BF'
                                             end,
                    cl.DiagnosisPointer2 = '2'
            from    #Claims c
                    join #ClaimLines cl on c.MaxClaimLineId = cl.ClaimLineId
                    join #ClaimDiagnosisRank cdr on cdr.ClaimId = c.ClaimId
                                                    and cdr.Rnk = 2

            update  cl
            set     cl.DiagnosisCode3 = cdr.DiagnosisCode,
                    cl.DiagnosisQualifier3 = case when isnull(cdr.IsICD10Code, 'N') = 'Y' then 'ABF'
                                                  else 'BF'
                                             end,
                    cl.DiagnosisPointer3 = '3'
            from    #Claims c
                    join #ClaimLines cl on c.MaxClaimLineId = cl.ClaimLineId
                    join #ClaimDiagnosisRank cdr on cdr.ClaimId = c.ClaimId
                                                    and cdr.Rnk = 3

            update  cl
            set     cl.DiagnosisCode4 = cdr.DiagnosisCode,
                    cl.DiagnosisQualifier4 = case when isnull(cdr.IsICD10Code, 'N') = 'Y' then 'ABF'
                                                  else 'BF'
                                             end,
                    cl.DiagnosisPointer4 = '4'
            from    #Claims c
                    join #ClaimLines cl on c.MaxClaimLineId = cl.ClaimLineId
                    join #ClaimDiagnosisRank cdr on cdr.ClaimId = c.ClaimId
                                                    and cdr.Rnk = 4

            update  cl
            set     cl.DiagnosisCode5 = cdr.DiagnosisCode,
                    cl.DiagnosisQualifier5 = case when isnull(cdr.IsICD10Code, 'N') = 'Y' then 'ABF'
                                                  else 'BF'
                                             end,
                    cl.DiagnosisPointer5 = '5'
            from    #Claims c
                    join #ClaimLines cl on c.MaxClaimLineId = cl.ClaimLineId
                    join #ClaimDiagnosisRank cdr on cdr.ClaimId = c.ClaimId
                                                    and cdr.Rnk = 5

            update  cl
            set     cl.DiagnosisCode6 = cdr.DiagnosisCode,
                    cl.DiagnosisQualifier6 = case when isnull(cdr.IsICD10Code, 'N') = 'Y' then 'ABF'
                                                  else 'BF'
                                             end,
                    cl.DiagnosisPointer6 = '6'
            from    #Claims c
                    join #ClaimLines cl on c.MaxClaimLineId = cl.ClaimLineId
                    join #ClaimDiagnosisRank cdr on cdr.ClaimId = c.ClaimId
                                                    and cdr.Rnk = 6

            update  cl
            set     cl.DiagnosisCode7 = cdr.DiagnosisCode,
                    cl.DiagnosisQualifier7 = case when isnull(cdr.IsICD10Code, 'N') = 'Y' then 'ABF'
                                                  else 'BF'
                                             end,
                    cl.DiagnosisPointer7 = '7'
            from    #Claims c
                    join #ClaimLines cl on c.MaxClaimLineId = cl.ClaimLineId
                    join #ClaimDiagnosisRank cdr on cdr.ClaimId = c.ClaimId
                                                    and cdr.Rnk = 7

            update  cl
            set     cl.DiagnosisCode8 = cdr.DiagnosisCode,
                    cl.DiagnosisQualifier8 = case when isnull(cdr.IsICD10Code, 'N') = 'Y' then 'ABF'
                                                  else 'BF'
                                             end,
                    cl.DiagnosisPointer8 = '8'
            from    #Claims c
                    join #ClaimLines cl on c.MaxClaimLineId = cl.ClaimLineId
                    join #ClaimDiagnosisRank cdr on cdr.ClaimId = c.ClaimId
                                                    and cdr.Rnk = 8

 


			-- Other Insured Claim level Grouping

            INSERT   INTO #ClaimOtherInsured
                     (
                       ClaimOtherInsuredId
                     , ClaimId
                     , Priority
                     , InsuranceTypeCode
                     , ClaimFilingIndicatorCode
                     , PayerName
                     , InsuredId
                     , GroupNumber
                     , GroupName
                     , PaidAmount
                     , AllowedAmount
                     , ClientResponsibility
                     , PaidDate
                     , InsuredLastName
                     , InsuredFirstName
                     , InsuredMiddleName
                     , InsuredSuffix
                     , InsuredSex
                     , InsuredDOB
                     , InsuredRelationCode
                     , ElectronicClaimsPayerId
			         )
                     SELECT   MAX(oi.OtherInsuredId)      -- ClaimOtherInsuredId - int
                            , cl.ClaimId-- ClaimId - int
                            , oi.Priority	-- Priority - int
                            , oi.InsuranceTypeCode-- InsuranceTypeCode - char(2)
                            , oi.ClaimFilingIndicatorCode-- ClaimFilingIndicatorCode - char(2)
                            , oi.PayerName-- PayerName - varchar(100)
                            , oi.InsuredId-- InsuredId - varchar(25)
                            , oi.GroupNumber-- GroupNumber - varchar(25)
                            , oi.GroupName-- GroupName - varchar(50)
                            , SUM(oi.PaidAmount)-- PaidAmount - money
                            , SUM(oi.AllowedAmount)-- AllowedAmount - money
                            , SUM(oi.ClientResponsibility)-- ClientResponsibility - money
                            , MAX(oi.PaidDate)-- PaidDate - datetime
                            , oi.InsuredLastName-- InsuredLastName - varchar(20)
                            , oi.InsuredFirstName-- InsuredFirstName - varchar(20)
                            , oi.InsuredMiddleName-- InsuredMiddleName - varchar(20)
                            , oi.InsuredSuffix-- InsuredSuffix - varchar(10)
                            , oi.InsuredSex-- InsuredSex - char(1)
                            , oi.InsuredDOB-- InsuredDOB - datetime
                            , oi.InsuredRelationCode-- InsuredRelationCode - varchar(10)
                            , oi.ElectronicClaimsPayerId-- ElectronicClaimsPayerId - varchar(20)
                     FROM     #OtherInsured oi
                              JOIN #ClaimLines AS cl
                                 ON oi.ClaimLineId = cl.ClaimLineId
                     GROUP BY cl.ClaimId
                            , oi.[Priority]
                            , oi.InsuranceTypeCode-- InsuranceTypeCode - char(2)
                            , oi.ClaimFilingIndicatorCode-- ClaimFilingIndicatorCode - char(2)
                            , oi.PayerName-- PayerName - varchar(100)
                            , oi.InsuredId-- InsuredId - varchar(25)
                            , oi.GroupNumber-- GroupNumber - varchar(25)
                            , oi.GroupName-- GroupName - varchar(50)
                            , oi.InsuredLastName-- InsuredLastName - varchar(20)
                            , oi.InsuredFirstName-- InsuredFirstName - varchar(20)
                            , oi.InsuredMiddleName-- InsuredMiddleName - varchar(20)
                            , oi.InsuredSuffix-- InsuredSuffix - varchar(10)
                            , oi.InsuredSex-- InsuredSex - char(1)
                            , oi.InsuredDOB-- InsuredDOB - datetime
                            , oi.InsuredRelationCode-- InsuredRelationCode - varchar(10)
                            , oi.ElectronicClaimsPayerId-- ElectronicClaimsPayerId - varchar(20)



            IF @@error <> 0
                GOTO error  

            INSERT  INTO #ClaimLines
                    ( ToVoidClaimLineItemGroupId ,
                      BillingProviderTaxIdType ,
                      BillingProviderTaxId ,
                      BillingProviderIdType ,
                      BillingProviderId ,
                      BillingTaxonomyCode ,
                      BillingProviderLastName ,
                      BillingProviderFirstName ,
                      BillingProviderMiddleName ,
                      BillingProviderNPI ,
                      PayToProviderTaxIdType ,
                      PayToProviderTaxId ,
                      PayToProviderIdType ,
                      PayToProviderId ,
                      PayToProviderLastName ,
                      PayToProviderFirstName ,
                      PayToProviderMiddleName ,
                      PayToProviderNPI ,
                      PaymentAddress1-- VARCHAR(30) NULL
                      ,
                      PaymentAddress2-- VARCHAR(30) NULL
                      ,
                      PaymentCity-- VARCHAR(30) NULL
                      ,
                      PaymentState-- CHAR(2) NULL
                      ,
                      PaymentZip-- VARCHAR(25) NULL
                      ,
                      PaymentPhone-- VARCHAR(10) NULL
                      ,
                      ClientId ,
                      InsuredId ,
                      [Priority] ,
                      CoveragePlanId ,
                      GroupNumber ,
                      GroupName ,
                      InsuredLastName ,
                      InsuredFirstName ,
                      InsuredMiddleName ,
                      InsuredSuffix ,
                      InsuredRelation ,
                      InsuredRelationCode ,
                      InsuredAddress1 ,
                      InsuredAddress2 ,
                      InsuredCity ,
                      InsuredState ,
                      InsuredZip ,
                      InsuredHomePhone ,
                      InsuredSex ,
                      InsuredSSN ,
                      InsuredDOB ,
                      ClientLastName ,
                      ClientFirstname ,
                      ClientMiddleName ,
                      ClientSSN ,
                      ClientSuffix ,
                      ClientAddress1 ,
                      ClientAddress2 ,
                      ClientCity ,
                      ClientState ,
                      ClientZip ,
                      ClientHomePhone ,
                      ClientDOB ,
                      ClientSex ,
                      ClientIsSubscriber ,
                      PayerAddress1 ,
                      PayerAddress2 ,
                      PayerCity ,
                      PayerState ,
                      PayerZip ,
                      PayerName ,
                      ProviderCommercialNumber --VARCHAR(50) NULL
                      ,
                      InsuranceCommissionersCode-- VARCHAR(50) NULL
                      ,
                      MedicareInsuranceTypeCode --CHAR(2) NULL
                      ,
                      ClaimFilingIndicatorCode --CHAR(2) NULL
                      ,
                      ElectronicClaimsPayerId ,
                      ClaimOfficeNumber ,
                      SubmissionReasonCode ,
                      ClaimId ,
                      PayerClaimControlNumber
					)
                    SELECT  cligsd.ClaimLineItemGroupId AS ToVoidCLaimLineItemGroupId ,
                            cligsd.BillingProviderTaxIdType ,
                            cligsd.BillingProviderTaxId ,
                            cligsd.BillingProviderIdType ,
                            cligsd.BillingProviderId ,
                            cligsd.BillingTaxonomyCode ,
                            cligsd.BillingProviderLastName ,
                            cligsd.BillingProviderFirstName ,
                            cligsd.BillingProviderMiddleName ,
                            cligsd.BillingProviderNPI ,
                            cligsd.PayToProviderTaxIdType ,
                            cligsd.PayToProviderTaxId ,
                            cligsd.PayToProviderIdType ,
                            cligsd.PayToProviderId ,
                            cligsd.PayToProviderLastName ,
                            cligsd.PayToProviderFirstName ,
                            cligsd.PayToProviderMiddleName ,
                            cligsd.PayToProviderNPI ,
                            cligsd.PaymentAddress1-- VARCHAR(30) NULL
                            ,
                            cligsd.PaymentAddress2-- VARCHAR(30) NULL
                            ,
                            cligsd.PaymentCity-- VARCHAR(30) NULL
                            ,
                            cligsd.PaymentState-- CHAR(2) NULL
                            ,
                            cligsd.PaymentZip-- VARCHAR(25) NULL
                            ,
                            cligsd.PaymentPhone-- VARCHAR(10) NULL
                            ,
                            cligsd.ClientId ,
                            cligsd.InsuredId ,
                            cligsd.ChargePriority ,
                            cligsd.CoveragePlanId ,
                            cligsd.GroupNumber ,
                            cligsd.GroupName ,
                            cligsd.InsuredLastName ,
                            cligsd.InsuredFirstName ,
                            cligsd.InsuredMiddleName ,
                            cligsd.InsuredSuffix ,
                            cligsd.InsuredRelation ,
                            cligsd.InsuredRelationCode ,
                            cligsd.InsuredAddress1 ,
                            cligsd.InsuredAddress2 ,
                            cligsd.InsuredCity ,
                            cligsd.InsuredState ,
                            cligsd.InsuredZip ,
                            cligsd.InsuredHomePhone ,
                            cligsd.InsuredSex ,
                            cligsd.InsuredSSN ,
                            cligsd.InsuredDOB ,
                            cligsd.ClientLastName ,
                            cligsd.ClientFirstname ,
                            cligsd.ClientMiddleName ,
                            cligsd.ClientSSN ,
                            cligsd.ClientSuffix ,
                            cligsd.ClientAddress1 ,
                            cligsd.ClientAddress2 ,
                            cligsd.ClientCity ,
                            cligsd.ClientState ,
                            cligsd.ClientZip ,
                            cligsd.ClientHomePhone ,
                            cligsd.ClientDOB ,
                            cligsd.ClientSex ,
                            cligsd.ClientIsSubscriber ,
                            cligsd.PayerAddress1 ,
                            cligsd.PayerAddress2 ,
                            cligsd.PayerCity ,
                            cligsd.PayerState ,
                            cligsd.PayerZip ,
                            cligsd.PayerName ,
                            cligsd.ProviderCommercialNumber --VARCHAR(50) NULL
                            ,
                            cligsd.InsuranceCommissionersCode-- VARCHAR(50) NULL
                            ,
                            cligsd.MedicareInsuranceTypeCode --CHAR(2) NULL
                            ,
                            cligsd.ClaimFilingIndicatorCode --CHAR(2) NULL
                            ,
                            cligsd.ElectronicClaimsPayerId ,
                            cligsd.ClaimOfficeNumber ,
                            '8' ,
                            ISNULL(( SELECT MAX(cl.ClaimId)
                                     FROM   #ClaimLines AS cl
                                   ), 0) + ROW_NUMBER() OVER ( ORDER BY cbv.ClaimLineItemGroupId ) ,
                            cbv.PayerClaimControlNumber
                    FROM    #ClaimBatchVoids AS cbv
                            JOIN dbo.ClaimLineItemGroupStoredData AS cligsd ON cligsd.ClaimLineItemGroupId = cbv.ClaimLineItemGroupId
            IF EXISTS ( SELECT  1
                        FROM    #ClaimLines a
                        WHERE   a.SubmissionReasonCode IN ( '7', '8' )
                                AND a.PayerClaimControlNumber IS NULL )
                BEGIN
                    INSERT  INTO dbo.ChargeErrors
                            ( ChargeId ,
                              ErrorType ,
                              ErrorDescription ,
                              CreatedBy ,
                              CreatedDate ,
                              ModifiedBy ,
                              ModifiedDate
                            
									
                            )
                            SELECT  clic.ChargeId  -- ChargeId - int
                                    ,
                                    4556-- ErrorType - type_GlobalCode
                                    ,
                                    'Void or Replacement Claim requires Payer Claim Control Number. Check Claim Line Item Details.'-- ErrorDescription - varchar(1000)
                                    ,
                                    @ParamCurrentUser-- CreatedBy - type_CurrentUser
                                    ,
                                    GETDATE()-- CreatedDate - type_CurrentDatetime
                                    ,
                                    @ParamCurrentUser-- ModifiedBy - type_CurrentUser
                                    ,
                                    GETDATE()-- ModifiedDate - type_CurrentDatetime
                            FROM    #ClaimLines a
                                    JOIN #ClaimBatchVoids cbv ON cbv.ClaimLineItemGroupId = a.ToVoidClaimLineItemGroupId
                                    JOIN dbo.ClaimLineItemGroups AS clig ON clig.ClaimLineItemGroupId = cbv.ClaimLineItemGroupId
                                    JOIN dbo.ClaimLineItems AS cli ON cli.ClaimLineItemGroupId = clig.ClaimLineItemGroupId
                                    JOIN dbo.ClaimLineItemCharges AS clic ON clic.ClaimLineItemId = cli.ClaimLineItemId
                            WHERE   a.SubmissionReasonCode IN ( '7', '8' )
                                    AND a.PayerClaimControlNumber IS NULL
                END
   			


            DELETE  a
            FROM    #ClaimLines a
                    JOIN #ClaimBatchVoids cbv ON cbv.ClaimLineItemGroupId = a.ToVoidClaimLineItemGroupId
                    JOIN dbo.ClaimLineItemGroups AS clig ON clig.ClaimLineItemGroupId = cbv.ClaimLineItemGroupId
                    JOIN dbo.ClaimLineItems AS cli ON cli.ClaimLineItemGroupId = clig.ClaimLineItemGroupId
                    JOIN dbo.ClaimLineItemCharges AS clic ON clic.ClaimLineItemId = cli.ClaimLineItemId
                    JOIN dbo.ChargeErrors AS ce ON ce.ChargeId = clic.ChargeId
            WHERE   a.PayerClaimControlNumber IS NULL			 
			
			-- if we managed to find a payer claim control number, don't error the charge
			--
            DELETE  ce
            FROM    #ClaimLines a
                    JOIN #ClaimBatchVoids cbv ON cbv.ClaimLineItemGroupId = a.ToVoidClaimLineItemGroupId
                    JOIN dbo.ClaimLineItemGroups AS clig ON clig.ClaimLineItemGroupId = cbv.ClaimLineItemGroupId
                    JOIN dbo.ClaimLineItems AS cli ON cli.ClaimLineItemGroupId = clig.ClaimLineItemGroupId
                    JOIN dbo.ClaimLineItemCharges AS clic ON clic.ClaimLineItemId = cli.ClaimLineItemId
                    JOIN dbo.ChargeErrors AS ce ON ce.ChargeId = clic.ChargeId
            WHERE   a.PayerClaimControlNumber IS NOT NULL		

            INSERT  INTO #Claims
                    ( MinClaimLineId ,
                      MaxClaimLineId ,
                      PayerClaimControlNumber
							
                    )
                    SELECT  cl.ClaimLineId ,
                            cl.ClaimLineId ,
                            cl.PayerClaimControlNumber
                    FROM    #ClaimLines AS cl
                    WHERE   cl.ToVoidClaimLineItemGroupId IS NOT NULL
							
																
            --IF EXISTS ( SELECT  *
            --            FROM    sys.tables
            --            WHERE   name = 'CustomTempClaimLines' )
            --    BEGIN
            --        DROP TABLE dbo.CustomTempClaimLines
            --    END
            --SELECT  *
            --INTO    CustomTempClaimLines
            --FROM    #ClaimLines
			
            IF @@error <> 0
                GOTO error    
    
    
            UPDATE  dbo.ClaimBatches
            SET     BatchProcessProgress = 60
            WHERE   ClaimBatchId = @ParamClaimBatchId    
    
            IF @@error <> 0
                GOTO error    	
			
			
			
            IF ( SELECT COUNT(*)
                 FROM   #ClaimLines
               ) = 0
                BEGIN  
                    GOTO ProcessedStatus 
                END  
  
            IF @@error <> 0
                GOTO error  
			
				
-- Delete old data related to the batch  
            EXEC dbo.ssp_PMClaimsUpdateClaimsTablesNew @ParamCurrentUser, @ParamClaimBatchId  
			
			  
            IF @@error <> 0
                GOTO error  
  
            UPDATE  dbo.ClaimBatches
            SET     BatchProcessProgress = 70
            WHERE   ClaimBatchId = @ParamClaimBatchId  
  


            IF @@error <> 0
                GOTO ERROR
        
            DECLARE @TotalClaims INT  
            DECLARE @TotalBilledAmount MONEY  
  
  
            DECLARE @e_sep CHAR(1) ,
                @te_sep VARCHAR(10)  
            DECLARE @se_sep CHAR(1) ,
                @tse_sep VARCHAR(10)  
            DECLARE @seg_term VARCHAR(2) ,
                @tseg_term VARCHAR(10)
  
            DECLARE @ClientGroupId INT ,
                @ClientGroupCount INT  
            DECLARE @ClaimLimit INT  
            DECLARE @ClaimsPerClientLimit INT  
            DECLARE @LastClientId INT ,
                @CurrentClientId INT  
  
            DECLARE @BatchFileNumber INT  
            DECLARE @NumberOfSegments INT  

            DECLARE @FunctionalTrailer VARCHAR(1000) ,
                @InterchangeTrailer VARCHAR(1000) ,
                @TransactionTrailer VARCHAR(1000)  
            DECLARE @seg1 VARCHAR(1000) ,
                @seg2 VARCHAR(1000) ,
                @seg3 VARCHAR(1000) ,
                @seg4 VARCHAR(1000) ,
                @seg5 VARCHAR(1000) ,
                @seg6 VARCHAR(1000) ,
                @seg7 VARCHAR(1000) ,
                @seg8 VARCHAR(1000) ,
                @seg9 VARCHAR(1000) ,
                @seg10 VARCHAR(1000) ,
                @seg11 VARCHAR(1000) ,
                @seg12 VARCHAR(1000) ,
                @seg13 VARCHAR(1000) ,
                @seg14 VARCHAR(1000) ,
                @seg15 VARCHAR(1000) ,
                @seg16 VARCHAR(1000) ,
                @seg17 VARCHAR(1000) ,
                @seg18 VARCHAR(1000) ,
                @seg19 VARCHAR(1000) ,
                @seg20 VARCHAR(1000) ,
                @seg21 VARCHAR(1000) ,
                @seg22 VARCHAR(1000) ,
                @seg23 VARCHAR(1000) ,
                @seg24 VARCHAR(1000) ,
                @seg25 VARCHAR(1000) ,
                @seg26 VARCHAR(1000) ,
                @seg27 VARCHAR(1000) ,
                @seg28 VARCHAR(1000) ,
                @seg29 VARCHAR(1000) ,
                @seg30 VARCHAR(1000) ,
                @seg31 VARCHAR(1000)  				

            DECLARE @ToVoidClaimLineItemGroupId INT ,
                @ClaimLineItemGroupId INT ,
                @PrePayerClaimControlNumberClaimData VARCHAR(MAX) ,
                @PostPayerClaimControlNumberClaimData VARCHAR(MAX)
  
            DECLARE @ProviderLoopId INT  
            DECLARE @SubscriberLoopId INT  
            DECLARE @ClaimLoopId INT  
--New**  
            DECLARE @ServiceLoopId INT  
--New** end  
            DECLARE @ServiceCount INT  
            DECLARE @HierId INT  
            DECLARE @ProviderHierId INT  
            DECLARE @TextPointer BINARY(16)  
            DECLARE @ClaimLineId INT  
            DECLARE @CoveragePlan VARCHAR(10)  
            DECLARE @DateString VARCHAR(8)  
			
            DECLARE @ClaimId INT
			
            CREATE TABLE #FinalData ( DataText TEXT NULL )  
  
            IF @@error <> 0
                GOTO error  
  
-- Split into multiple files if exceeding limit  
  
            SELECT  @ClientGroupId = 0 ,
                    @ClientGroupCount = 0 ,
                    @ClaimLimit = 5000 ,
                    @ClaimsPerClientLimit = 100 ,
                    @BatchFileNumber = 0  
  
            SELECT  @DateString = CONVERT(VARCHAR, GETDATE(), 112)  
  
            IF @@error <> 0
                GOTO error  
  
-- Create multiple files if exceeding claim limit per file  
            WHILE EXISTS ( SELECT   *
                           FROM     #ClaimLines )
                BEGIN  
    
                    SELECT  @BatchFileNumber = @BatchFileNumber + 1  
  
                    IF @@error <> 0
                        GOTO error  
  
                    DELETE  FROM #ClaimLines_Temp  
  
                    IF @@error <> 0
                        GOTO error  
  
                    SET ROWCOUNT @ClaimLimit  
  
                    IF @@error <> 0
                        GOTO error  
  
                    INSERT  INTO #ClaimLines_Temp
                            SELECT  *
                            FROM    #ClaimLines  
  
                    IF @@error <> 0
                        GOTO error  
  
                    DELETE  a
                    FROM    #ClaimLines a
                            JOIN #ClaimLines_Temp b ON ( a.ClaimLineId = b.ClaimLineId )  
  
                    IF @@error <> 0
                        GOTO error  
  
                    SET ROWCOUNT 0  
   
                    IF @@error <> 0
                        GOTO error  
  
-- If number of claims per Client exceeds @ClaimsPerClientLimit  
-- Split the claims into multiple groups  

					;
                    WITH    ct_ClientGroups
                              AS ( SELECT   ClaimLineId ,
                                            DENSE_RANK() OVER ( ORDER BY ClientId , ClientAddress1 , ClientAddress2 , ClientCity, ClientState, ClientZip , InsuredAddress1 , InsuredAddress2 , InsuredCity , InsuredState , InsuredZip ) AS ClientGroupId
                                   FROM     #ClaimLines_Temp
                                 )
                        UPDATE  clt
                        SET     ClientGroupId = ccg.ClientGroupId
                        FROM    #ClaimLines_Temp clt
                                JOIN ct_ClientGroups ccg ON clt.ClaimLineId = ccg.ClaimLineId
  
  
                    IF @@error <> 0
                        GOTO error  
  
                    SELECT  @TotalClaims = COUNT(*) ,
                            @TotalBilledAmount = ISNULL(SUM(ChargeAmount), 0)
                    FROM    #ClaimLines_Temp  
  
--print 'Number of Claims = ' + convert(varchar,@TotalClaims)  
--print 'Total Billed Amount  = ' + convert(varchar, @TotalBilledAmount)  
  
                    SELECT  @e_sep = ISNULL(ComponentElementSeparator, '*') ,
                            @te_sep = 'TE_SEP' ,
                            @se_sep = ISNULL(ElementDelimiter, ':') ,
                            @tse_sep = 'TSE_SEP' ,
                            @seg_term = ISNULL(SegmentTerminator, '~') --char(13)+char(10)  
                            ,
                            @tseg_term = 'TSEG_TERM'
                    FROM    dbo.ClaimFormats
                    WHERE   ClaimFormatId = @ClaimFormatId
						
                    IF @@error <> 0
                        GOTO error  
  
-- Populate Interchange Control Header  
                    IF @BatchFileNumber = 1
                        BEGIN  
  
                            DELETE  FROM #HIPAAHeaderTrailer  
  
                            IF @@error <> 0
                                GOTO error  
  
-- NJain Added 7/10/2014
-- Updated the Insert statement to use the new fields from ClaimFormats table. If the data in these fields is NULL, then use the previously hard-coded values.
                            INSERT  INTO #HIPAAHeaderTrailer
                                    ( AuthorizationIdQualifier ,
                                      AuthorizationId ,
                                      SecurityIdQualifier ,
                                      SecurityId ,
                                      InterchangeSenderQualifier ,
                                      InterchangeSenderId ,
                                      InterchangeReceiverQualifier ,
                                      InterchangeReceiverId ,
                                      InterchangeDate ,
                                      InterchangeTime ,
                                      InterchangeControlStandardsId ,
                                      InterchangeControlVersionNumber ,
                                      InterchangeControlNumberHeader ,
                                      AcknowledgeRequested ,
                                      UsageIndicator ,
                                      ComponentSeparator ,
                                      FunctionalIdCode ,
                                      ApplicationSenderCode ,
                                      ApplicationReceiverCode ,
                                      FunctionalDate ,
                                      FunctionalTime ,
                                      GroupControlNumberHeader ,
                                      ResponsibleAgencyCode ,
                                      VersionCode ,
                                      NumberOfTransactions ,
                                      GroupControlNumberTrailer ,
                                      NumberOfGroups ,
                                      InterchangeControlNumberTrailer 
									)
                                    SELECT  ISNULL(AuthorizationIdQualifier, '00') ,
                                            ISNULL(AuthorizationId, SPACE(10)) ,
                                            ISNULL(SecurityInfoQualifier, '00') ,
                                            ISNULL(SecurityId, SPACE(10)) ,
                                            ISNULL(InterchangeSenderQualifier, 'ZZ') ,
                                            BillingLocationCode ,
                                            ISNULL(InterchangeReceiverQualifier, 'ZZ') ,
                                            ReceiverCode ,
                                            RIGHT(CONVERT(VARCHAR, GETDATE(), 112), 6) ,
                                            SUBSTRING(CONVERT(VARCHAR, GETDATE(), 108), 1, 2) + SUBSTRING(CONVERT(VARCHAR, GETDATE(), 108), 4, 2) ,
                                            '^' ,
                                            '00501' ,
                                            REPLICATE('0', 9 - LEN(CONVERT(VARCHAR, @ParamClaimBatchId))) + CONVERT(VARCHAR, @ParamClaimBatchId) ,
                                            '0' ,
                                            ProductionOrTest ,
                                            @tse_sep ,
                                            'HC' ,
                                            ISNULL(ApplicationSenderCode, BillingLocationCode) ,
                                            ISNULL(ApplicationReceiverCode, ReceiverCode) ,
                                            CONVERT(VARCHAR, GETDATE(), 112) ,
                                            SUBSTRING(CONVERT(VARCHAR, GETDATE(), 108), 1, 2) + SUBSTRING(CONVERT(VARCHAR, GETDATE(), 108), 4, 2) ,
                                            CONVERT(VARCHAR, @ParamClaimBatchId) ,
                                            'X' ,
                                            '005010X222A1' ,
                                            '1' ,
                                            CONVERT(VARCHAR, @ParamClaimBatchId) ,
                                            '1' ,
                                            REPLICATE('0', 9 - LEN(CONVERT(VARCHAR, @ParamClaimBatchId))) + CONVERT(VARCHAR, @ParamClaimBatchId)
                                    FROM    dbo.ClaimFormats
                                    WHERE   ClaimFormatId = @ClaimFormatId

-- 									





                            EXEC dbo.scsp_PMClaims837UpdateSegmentData @CurrentUser = @ParamCurrentUser, @ClaimBatchId = @ParamClaimBatchId, @FormatType = @FormatType
                            IF @@error <> 0
                                GOTO error  
  
-- Set up Interchange and Functional header and trailer segments  
                            UPDATE  #HIPAAHeaderTrailer
                            SET     InterchangeHeaderSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'ISA' + @te_sep + AuthorizationIdQualifier + @te_sep + AuthorizationId + @te_sep + SecurityIdQualifier + @te_sep + SecurityId + @te_sep + InterchangeSenderQualifier + @te_sep + InterchangeSenderId + SPACE(15 - LEN(InterchangeSenderId)) + @te_sep + InterchangeReceiverQualifier + @te_sep + InterchangeReceiverId + SPACE(15 - LEN(InterchangeReceiverId)) + @te_sep + InterchangeDate + @te_sep + InterchangeTime + @te_sep + InterchangeControlStandardsId + @te_sep + InterchangeControlVersionNumber + @te_sep + InterchangeControlNumberHeader + @te_sep + AcknowledgeRequested + @te_sep + UsageIndicator + @te_sep + ComponentSeparator ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                                    FunctionalHeaderSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'GS' + @te_sep + FunctionalIdCode + @te_sep + ApplicationSenderCode + @te_sep + ApplicationReceiverCode + @te_sep + FunctionalDate + @te_sep + FunctionalTime + @te_sep + GroupControlNumberHeader + @te_sep + ResponsibleAgencyCode + @te_sep + VersionCode ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                                    FunctionalTrailerSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'GE' + @te_sep + NumberOfTransactions + @te_sep + GroupControlNumberTrailer ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                                    InterchangeTrailerSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'IEA' + @te_sep + NumberOfGroups + @te_sep + InterchangeControlNumberTrailer ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + CASE WHEN @seg_term = CHAR(13) + CHAR(10) THEN ''
                                                                                                                                                                                                                                                                                                          ELSE @seg_term
                                                                                                                                                                                                                                                                                                     END  
  
                            IF @@error <> 0
                                GOTO error  
  
                        END -- HIPAA Header Trailer  
  
  
-- In case of the last batch of the file  
                    IF NOT EXISTS ( SELECT  *
                                    FROM    #ClaimLines )
                        BEGIN  
  
                            UPDATE  #HIPAAHeaderTrailer
                            SET     NumberOfTransactions = @BatchFileNumber  
  
                            IF @@error <> 0
                                GOTO error  
  
                            UPDATE  #HIPAAHeaderTrailer
                            SET     FunctionalTrailerSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'GE' + @te_sep + NumberOfTransactions + @te_sep + GroupControlNumberTrailer ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term  
  
                            IF @@error <> 0
                                GOTO error  
  
                        END  
  
-- Populate Header and Trailer #837HeaderTrailer  
                    DELETE  FROM #837HeaderTrailer  
  
                    IF @@error <> 0
                        GOTO error  

                    INSERT  INTO #837HeaderTrailer
                            ( TransactionSetControlNumberHeader ,
                              TransactionSetPurposeCode ,
                              ApplicationTransactionId ,
                              CreationDate ,
                              CreationTime ,
                              EncounterId ,
                              TransactionTypeCode ,
                              SubmitterEntityQualifier ,
                              SubmitterLastName ,
                              SubmitterId ,
                              SubmitterContactName ,
                              SubmitterCommNumber1Qualifier ,
                              SubmitterCommNumber1 ,
                              ReceiverLastName ,
                              ReceiverPrimaryId ,
                              TransactionSetControlNumberTrailer ,
                              ImplementationConventionReference  
							)
                            SELECT  REPLICATE('0', 8 - LEN(CONVERT(VARCHAR, @ParamClaimBatchId))) + CONVERT(VARCHAR, @ParamClaimBatchId) + CONVERT(VARCHAR, @BatchFileNumber - 1)--TransactionSetControlNumberHeader
                                    ,
                                    '00'--TransactionSetPurposeCode
                                    ,
                                    REPLICATE('0', 9 - LEN(CONVERT(VARCHAR, @ParamClaimBatchId))) + CONVERT(VARCHAR, @ParamClaimBatchId)--ApplicationTransactionId
                                    ,
                                    CONVERT(VARCHAR, GETDATE(), 112)--CreationDate
                                    ,
                                    SUBSTRING(CONVERT(VARCHAR, GETDATE(), 108), 1, 2) + SUBSTRING(CONVERT(VARCHAR, GETDATE(), 108), 4, 2)--CreationTime
                                    ,
                                    'CH'--EncounterId
                                    ,
                                    CASE WHEN a.ProductionOrTest = 'T' THEN '005010X222A1'
                                         ELSE '005010X222A1'
                                    END --TransactionTypeCode -- not sure who did this, but since the ref 87 segment was removed for 5010 compliance, it doesn't matter. -dknewtson
                                    ,
                                    '2' -- SubmitterEntityQualifier
                                    ,
                                    b.AgencyName -- SubmitterLastName
                                    ,
                                    a.BillingLocationCode -- SubmitterId
                                    ,
                                    b.BillingContact -- SubmitterContactName
                                    ,
                                    'TE' --SubmitterCommNumber1Qualifier
                                    ,
                                    --Modified for Task #686 CoreBugs-Billing contact in 837 process is not removing punctuation  
                                    SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(b.BillingPhone, ' ', RTRIM('')), '-', RTRIM('')), '(', RTRIM('')), ')', RTRIM('')), 1, 10)
							-- SubmitterCommNumber1
                                    ,
                                    PlanName.CoveragePlanName -- ReceiverLastName
                                    ,
                                    a.ReceiverPrimaryId -- ReceiverPrimaryId
                                    ,
                                    REPLICATE('0', 8 - LEN(CONVERT(VARCHAR, @ParamClaimBatchId))) + CONVERT(VARCHAR, @ParamClaimBatchId) + CONVERT(VARCHAR, @BatchFileNumber - 1) --TransactionSetControlNumberTrailer
                                    ,
                                    a.Version -- ImplementationConventionReference
                            FROM    dbo.ClaimFormats a
                                    CROSS JOIN dbo.Agency b
                                    CROSS JOIN ( SELECT DISTINCT
                                                        ISNULL(b.CoveragePlanName, c.PayerName) AS CoveragePlanName
                                                 FROM   dbo.ClaimBatches a
                                                        LEFT JOIN dbo.CoveragePlans b ON b.CoveragePlanId = a.CoveragePlanId
                                                        LEFT JOIN dbo.Payers c ON c.PayerId = a.PayerId
                                                 WHERE  a.ClaimBatchId = @ParamClaimBatchId
                                                        AND a.ClaimFormatId = @ClaimFormatId
                                               ) AS PlanName
                            WHERE   a.ClaimFormatId = @ClaimFormatId  
  
  
                    IF @@error <> 0
                        GOTO error  
  
-- Populate #837BillingProviders, one record for each provider id  
                    DELETE  FROM #837BillingProviders  
  
                    IF @@error <> 0
                        GOTO error  
  
                    INSERT  INTO #837BillingProviders
                            ( BillingProviderLastName ,
                              BillingProviderFirstName ,
                              BillingProviderMiddleName ,
                              BillingProviderIdQualifier ,
                              BillingProviderId ,
                              BillingProviderAddress1 ,
                              BillingProviderAddress2 ,
                              BillingProviderCity ,
                              BillingProviderState ,
                              BillingProviderZip ,
                              BillingProviderAdditionalIdQualifier ,
                              BillingProviderAdditionalId ,
                              BillingProviderAdditionalIdQualifier2 ,
                              BillingProviderAdditionalId2 ,
                              BillingProviderContactName ,
                              BillingProviderContactNumber1Qualifier ,
                              BillingProviderContactNumber1 ,
                              BillingProviderTaxonomyCode ,
                              PayToProviderLastName ,
                              PayToProviderFirstName ,
                              PayToProviderMiddleName ,
                              PayToProviderIdQualifier ,
                              PayToProviderId ,
                              PayToProviderAddress1 ,
                              PayToProviderAddress2 ,
                              PayToProviderCity ,
                              PayToProviderState ,
                              PayToProviderZip ,
                              PayToProviderSecondaryQualifier ,
                              PayToProviderSecondaryId ,
                              PayToProviderSecondaryQualifier2 ,
                              PayToProviderSecondaryId2
							)
                            SELECT  MAX(a.BillingProviderLastName) ,
                                    MAX(a.BillingProviderFirstName) ,
                                    MAX(a.BillingProviderMiddleName) ,
                                    'XX' ,
                                    a.BillingProviderNPI ,
                                    MAX(a.PaymentAddress1) ,
                                    MAX(a.PaymentAddress2) ,
                                    MAX(a.PaymentCity) ,
                                    MAX(a.PaymentState) ,
                                    MAX(LEFT(REPLACE(a.PaymentZip, '-', '') + '9999', 9)) ,
                                    MAX(a.BillingProviderIdType) ,
                                    MAX(a.BillingProviderId) ,
                                    MAX(CASE WHEN a.BillingProviderTaxIdType = '24' THEN 'EI'
                                             ELSE 'SY'
                                        END) ,
                                    MAX(a.BillingProviderTaxId) ,
                                    MAX(b.BillingContact) ,
                                    'TE' ,
                                    MAX(REPLACE(b.BillingPhone, '-', '')) ,
                                    MAX(a.BillingTaxonomyCode) ,
                                    MAX(a.PayToProviderLastName) ,
                                    MAX(a.PayToProviderFirstName) ,
                                    MAX(a.PayToProviderMiddleName) ,
                                    'XX' ,
                                    MAX(a.PayToProviderNPI) ,
                                    MAX(a.PaymentAddress1) ,
                                    MAX(a.PaymentAddress2) ,
                                    MAX(a.PaymentCity) ,
                                    MAX(a.PaymentState) ,
                                    MAX(LEFT(REPLACE(a.PaymentZip, '-', '') + '9999', 9)) ,
                                    MAX(a.PayToProviderIdType) ,
                                    MAX(a.PayToProviderId) ,
                                    MAX(CASE WHEN a.PayToProviderTaxIdType = '24' THEN 'EI'
                                             ELSE 'SY'
                                        END) ,
                                    MAX(a.PayToProviderTaxId)
                            FROM    #ClaimLines_Temp a
                                    CROSS JOIN dbo.Agency b
                            GROUP BY a.BillingProviderNPI  
  
                    IF @@error <> 0
                        GOTO error  

                    DECLARE @GroupSubscribersByProviderCommercialNumber CHAR(1) = 'N'
					
                    SELECT  @GroupSubscribersByProviderCommercialNumber = ISNULL(NULLIF(dbo.ssf_GetSystemConfigurationKeyValue('Group837SubscriberByProviderCommercialNumber'), ''), 'N')

                    IF @GroupSubscribersByProviderCommercialNumber = 'N'
                        BEGIN
                            UPDATE  clt
                            SET     clt.ProviderCommercialNumber = maxprov.ProviderCommercialNumber
                            FROM    #ClaimLines_Temp clt
                                    JOIN #837BillingProviders bp ON ( clt.BillingProviderNPI = bp.BillingProviderId )
                                    JOIN ( SELECT   bp2.UniqueId ,
                                                    clt2.ClientGroupId ,
                                                    clt2.ClientId ,
                                                    clt2.ClientAddress1 ,
                                                    clt2.ClientAddress2 ,
                                                    clt2.ClientCity ,
                                                    clt2.ClientState ,
                                                    clt2.ClientZip ,
                                                    clt2.InsuredAddress1 ,
                                                    clt2.InsuredAddress2 ,
                                                    clt2.InsuredCity ,
                                                    clt2.InsuredState ,
                                                    clt2.InsuredZip ,
                                                    clt2.CoveragePlanId ,
                                                    clt2.InsuredId ,
                                                    clt2.Priority ,
                                                    clt2.SubmissionReasonCode ,
                                                    MAX(clt2.ProviderCommercialNumber) AS ProviderCommercialNumber
                                           FROM     #ClaimLines_Temp clt2
                                                    JOIN #837BillingProviders bp2 ON clt2.BillingProviderNPI = bp2.BillingProviderId
                                           GROUP BY bp2.UniqueId ,
                                                    clt2.ClientGroupId ,
                                                    clt2.ClientId ,
                                                    clt2.ClientAddress1 ,
                                                    clt2.ClientAddress2 ,
                                                    clt2.ClientCity ,
                                                    clt2.ClientState ,
                                                    clt2.ClientZip ,
                                                    clt2.InsuredAddress1 ,
                                                    clt2.InsuredAddress2 ,
                                                    clt2.InsuredCity ,
                                                    clt2.InsuredState ,
                                                    clt2.InsuredZip ,
                                                    clt2.CoveragePlanId ,
                                                    clt2.InsuredId ,
                                                    clt2.Priority ,
                                                    clt2.SubmissionReasonCode
                                         ) maxprov ON maxprov.ClientGroupId = clt.ClientGroupId
                                                      AND maxprov.ClientId = clt.ClientId
                                                      AND maxprov.ClientAddress1 = clt.ClientAddress1
                                                      AND maxprov.ClientAddress2 = clt.ClientAddress2
                                                      AND maxprov.ClientCity = clt.ClientCity
                                                      AND maxprov.ClientState = clt.ClientState
                                                      AND maxprov.ClientZip = clt.ClientZip
                                                      AND maxprov.InsuredAddress1 = clt.InsuredAddress1
                                                      AND maxprov.InsuredAddress2 = clt.InsuredAddress2
                                                      AND maxprov.InsuredCity = clt.InsuredCity
                                                      AND maxprov.InsuredState = clt.InsuredState
                                                      AND maxprov.InsuredZip = clt.InsuredZip
                                                      AND maxprov.CoveragePlanId = clt.CoveragePlanId
                                                      AND maxprov.InsuredId = clt.InsuredId
                                                      AND maxprov.Priority = clt.Priority
                                                      AND maxprov.SubmissionReasonCode = clt.SubmissionReasonCode
                                                      AND maxprov.UniqueId = bp.UniqueId
                        END 
  
  
-- Populate #837SubscriberClients, one record for each provider id/patient  
                    DELETE  FROM #837SubscriberClients  
  
                    IF @@error <> 0
                        GOTO error  
                    INSERT  INTO #837SubscriberClients
                            ( RefBillingProviderId ,
                              ClientGroupId ,
                              ClientId ,
                              CoveragePlanId ,
                              InsuredId ,
                              Priority ,
                              GroupNumber ,
                              GroupName ,
                              RelationCode ,
                              MedicareInsuranceTypeCode ,
                              ClaimFilingIndicatorCode ,
                              SubmissionReasonCode ,
                              SubscriberEntityQualifier ,
                              SubscriberLastName ,
                              SubscriberFirstName ,
                              SubscriberMiddleName ,
                              SubscriberSuffix ,
                              SubscriberIdQualifier ,
                              SubscriberIdInsuredId ,
                              SubscriberAddress1 ,
                              SubscriberAddress2 ,
                              SubscriberCity ,
                              SubscriberState ,
                              SubscriberZip ,
                              SubscriberDOB ,
                              SubscriberSex ,
                              SubscriberSSN ,
                              PayerName ,
                              PayerIdQualifier ,
                              ProviderCommercialNumber ,
                              InsuranceCommissionersCode ,
                              ElectronicClaimsPayerId ,
                              ClaimOfficeNumber ,
                              PayerAddress1 ,
                              PayerAddress2 ,
                              PayerCity ,
                              PayerState ,
                              PayerZip ,
                              ClientLastName ,
                              ClientFirstName ,
                              ClientMiddleName ,
                              ClientSuffix ,
                              ClientAddress1 ,
                              ClientAddress2 ,
                              ClientCity ,
                              ClientState ,
                              ClientZip ,
                              ClientDOB ,
                              ClientSex ,
                              ClientIsSubscriber
							)
                            SELECT  b.UniqueId ,
                                    a.ClientGroupId ,
                                    a.ClientId ,
                                    a.CoveragePlanId ,
                                    a.InsuredId ,
                                    a.Priority ,
                                    MAX(a.GroupNumber) ,
                                    MAX(a.GroupName) ,
                                    MAX(a.InsuredRelationCode) ,
                                    MAX(a.MedicareInsuranceTypeCode) ,
                                    MAX(a.ClaimFilingIndicatorCode) ,
                                    a.SubmissionReasonCode ,
                                    '1' ,
                                    MAX(RTRIM(a.InsuredLastName)) ,
                                    MAX(RTRIM(a.InsuredFirstName)) ,
                                    MAX(RTRIM(a.InsuredMiddleName)) ,
                                    MAX(RTRIM(a.InsuredSuffix)) ,
                                    'MI' ,
                                    a.InsuredId ,
                                    RTRIM(a.InsuredAddress1) ,
                                    RTRIM(a.InsuredAddress2) ,
                                    RTRIM(a.InsuredCity) ,
                                    RTRIM(a.InsuredState) ,
                                    RTRIM(a.InsuredZip) ,
                                    MAX(CONVERT(VARCHAR, a.InsuredDOB, 112)) ,
                                    MAX(a.InsuredSex) ,
                                    MAX(a.InsuredSSN) ,
                                    MAX(a.PayerName) ,
                                    'PI' ,
                                    a.ProviderCommercialNumber ,
                                    MAX(a.InsuranceCommissionersCode) ,
                                    MAX(a.ElectronicClaimsPayerId) ,
                                    MAX(a.ClaimOfficeNumber) ,
                                    MAX(RTRIM(a.PayerAddress1)) ,
                                    MAX(RTRIM(a.PayerAddress2)) ,
                                    MAX(RTRIM(a.PayerCity)) ,
                                    MAX(RTRIM(a.PayerState)) ,
                                    MAX(RTRIM(a.PayerZip)) ,
                                    MAX(RTRIM(a.ClientLastName)) ,
                                    MAX(RTRIM(a.ClientFirstname)) ,
                                    MAX(RTRIM(a.ClientMiddleName)) ,
                                    MAX(RTRIM(a.ClientSuffix)) ,
                                    RTRIM(a.ClientAddress1) ,
                                    RTRIM(a.ClientAddress2) ,
                                    RTRIM(a.ClientCity) ,
                                    RTRIM(a.ClientState) ,
                                    RTRIM(a.ClientZip) ,
                                    MAX(CONVERT(VARCHAR, a.ClientDOB, 112)) ,
                                    MAX(a.ClientSex) ,
                                    MAX(a.ClientIsSubscriber)
                            FROM    #ClaimLines_Temp a
                                    JOIN #837BillingProviders b ON ( a.BillingProviderNPI = b.BillingProviderId )
                                    JOIN #Claims c ON c.MaxClaimLineId = a.ClaimLineId
                            GROUP BY b.UniqueId ,
                                    a.ClientGroupId ,
                                    a.ClientId ,
                                    RTRIM(a.ClientAddress1) ,
                                    RTRIM(a.ClientAddress2) ,
                                    RTRIM(a.ClientCity) ,
                                    RTRIM(a.ClientState) ,
                                    RTRIM(a.ClientZip) ,
                                    RTRIM(a.InsuredAddress1) ,
                                    RTRIM(a.InsuredAddress2) ,
                                    RTRIM(a.InsuredCity) ,
                                    RTRIM(a.InsuredState) ,
                                    RTRIM(a.InsuredZip) ,
                                    a.CoveragePlanId ,
                                    a.InsuredId ,
                                    a.Priority ,
                                    a.SubmissionReasonCode ,
                                    a.ProviderCommercialNumber
  
  
                    IF @@error <> 0
                        GOTO error  
  
 
  
-- Populate #837Claims table, one record for each provider id/patient/claim  
                    DELETE  FROM #837Claims  
  
                    IF @@error <> 0
                        GOTO error  
  
                    INSERT  INTO #837Claims
                            ( RefSubscriberClientId ,
                              ClaimLineId ,
                              ClaimLineItemGroupId ,
                              ToVoidClaimLineItemGroupId ,
                              ClaimId ,
                              TotalAmount ,
                              PlaceOfService ,
                              SubmissionReasonCode ,
                              RelatedHospitalAdmitDate ,
                              SignatureIndicator ,
                              MedicareAssignCode ,
                              BenefitsAssignCertificationIndicator ,
                              ReleaseCode ,
                              PatientSignatureCode ,
                              DiagnosisQualifier1 ,
                              DiagnosisQualifier2 ,
                              DiagnosisQualifier3 ,
                              DiagnosisQualifier4 ,
                              DiagnosisQualifier5 ,
                              DiagnosisQualifier6 ,
                              DiagnosisQualifier7 ,
                              DiagnosisQualifier8 ,
                              DiagnosisCode1 ,
                              DiagnosisCode2 ,
                              DiagnosisCode3 ,
                              DiagnosisCode4 ,
                              DiagnosisCode5 ,
                              DiagnosisCode6 ,
                              DiagnosisCode7 ,
                              DiagnosisCode8 ,
                              RenderingEntityCode ,
                              RenderingEntityQualifier ,
                              RenderingLastName ,
                              RenderingFirstName ,
                              RenderingIdQualifier ,
                              RenderingId ,
                              RenderingTaxonomyCode ,
                              RenderingSecondaryQualifier ,
                              RenderingSecondaryId ,
                              RenderingSecondaryQualifier2 ,
                              RenderingSecondaryId2 ,
                              ReferringEntityCode ,
                              ReferringEntityQualifier ,
                              ReferringLastName ,
                              ReferringFirstName ,
                              ReferringIdQualifier ,
                              ReferringId ,
                              ReferringSecondaryQualifier ,
                              ReferringSecondaryId ,
                              ReferringSecondaryQualifier2 ,
                              ReferringSecondaryId2 ,
                              PatientAmountPaid ,
                              PriorAuthorizationNumber ,
                              PayerClaimControlNumber ,
                              CLIANumber ,
                              MedicalRecordNumber ,
                              FacilityEntityCode ,
                              FacilityName ,
                              FacilityIdQualifier ,
                              FacilityId ,
                              FacilityAddress1 ,
                              FacilityAddress2 ,
                              FacilityCity ,
                              FacilityState ,
                              FacilityZip ,
                              FacilitySecondaryQualifier ,
                              FacilitySecondaryId /*,  
FacilitySecondaryQualifier2 ,FacilitySecondaryId2*/ ,
                              SupervisingProvider2310DLastName --VARCHAR(60) NULL ,
                              ,
                              SupervisingProvider2310DFirstName --VARCHAR(35) NULL ,
                              ,
                              SupervisingProvider2310DMiddleName --VARCHAR(25) NULL ,
                              ,
                              SupervisingProvider2310DIdType --VARCHAR(2) NULL ,
                              ,
                              SupervisingProvider2310DId --VARCHAR(80) NULL ,
                              ,
                              SupervisingProvider2310DSecondaryIdType1 --VARCHAR(3) NULL ,
                              ,
                              SupervisingProvider2310DSecondaryId1 --VARCHAR(50) ,
                              ,
                              SupervisingProvider2310DSecondaryIdType2 --VARCHAR(3) NULL ,
                              ,
                              SupervisingProvider2310DSecondaryId2 --VARCHAR(50) ,
                              ,
                              SupervisingProvider2310DSecondaryIdType3 --VARCHAR(3) NULL ,
                              ,
                              SupervisingProvider2310DSecondaryId3 --VARCHAR(50) ,
                              ,
                              SupervisingProvider2310DSecondaryIdType4 --VARCHAR(3) NULL ,
                              ,
                              SupervisingProvider2310DSecondaryId4 --VARCHAR(50) ,
                              ,
                              ClaimNoteReferenceCode ,
                              ClaimNote    
							)
                            SELECT  b.UniqueId ,
                                    a.ClaimLineId ,
                                    a.ClaimLineItemGroupId ,
                                    a.ToVoidClaimLineItemGroupId ,
                                    MAX(CONVERT(VARCHAR, a.ClientId) + '-' + CONVERT(VARCHAR, a.LineItemControlNumber)) ,
                                    SUM(a.ChargeAmount) ,
                                    MAX(a.PlaceOfServiceCode) ,
                                    MAX(a.SubmissionReasonCode) ,
                                    CONVERT(VARCHAR, MAX(a.RelatedHospitalAdmitDate), 112) ,
                                    'Y' ,
                                    'A' ,
                                    'Y' ,
                                    'Y' ,
                                    '' ,  -- srf 3/14/2011 -- 'I' and '' set per instructions.  
                                    MAX(a.DiagnosisQualifier1) ,
                                    MAX(a.DiagnosisQualifier2) ,
                                    MAX(a.DiagnosisQualifier3) ,
                                    MAX(a.DiagnosisQualifier4) ,
                                    MAX(a.DiagnosisQualifier5) ,
                                    MAX(a.DiagnosisQualifier6) ,
                                    MAX(a.DiagnosisQualifier7) ,
                                    MAX(a.DiagnosisQualifier8) ,
                                    MAX(REPLACE(a.DiagnosisCode1, '.', '')) ,
                                    MAX(REPLACE(a.DiagnosisCode2, '.', '')) ,
                                    MAX(REPLACE(a.DiagnosisCode3, '.', '')) ,
                                    MAX(REPLACE(a.DiagnosisCode4, '.', '')) ,
                                    MAX(REPLACE(a.DiagnosisCode5, '.', '')) ,
                                    MAX(REPLACE(a.DiagnosisCode6, '.', '')) ,
                                    MAX(REPLACE(a.DiagnosisCode7, '.', '')) ,
                                    MAX(REPLACE(a.DiagnosisCode8, '.', '')) ,
                                    '82' ,
                                    MAX(CASE WHEN a.RenderingProviderTaxIdType = '2' THEN '2'  -- Flag for pass thru claims
										ELSE '1' END ) ,
                                    MAX(a.RenderingProviderLastName) ,
                                    MAX(a.RenderingProviderFirstName) ,
                                    MAX(CASE WHEN ISNULL(a.RenderingProviderNPI, '') <> '' THEN 'XX'
                                             ELSE NULL
                                        END) ,
                                    MAX(CASE WHEN ISNULL(a.RenderingProviderNPI, '') <> '' THEN a.RenderingProviderNPI
                                             ELSE NULL
                                        END) ,
                                    MAX(a.RenderingProviderTaxonomyCode) ,
                                    MAX(a.RenderingProviderIdType) ,
                                    MAX(a.RenderingProviderId) ,
                                    NULL ,
                                    NULL ,
                                    'DN' ,
                                    '1' ,
                                    MAX(a.ReferringProviderLastName) ,
                                    MAX(a.ReferringProviderFirstName) ,
                                    MAX(CASE WHEN a.ReferringProviderNPI IS NULL THEN a.ReferringProviderIdType
                                             ELSE 'XX'
                                        END) ,
                                    MAX(CASE WHEN a.ReferringProviderNPI IS NULL THEN a.ReferringProviderId
                                             ELSE a.ReferringProviderNPI
                                        END) ,
                                    MAX(a.ReferringProviderIdType) ,
                                    MAX(a.ReferringProviderId) ,
                                    MAX(CASE WHEN a.ReferringProviderNPI IS NOT NULL THEN ( CASE WHEN a.ReferringProviderTaxIdType = '24' THEN 'EI'
                                                                                                 ELSE 'SY'
                                                                                            END )
                                             ELSE NULL
                                        END) ,
                                    MAX(CASE WHEN a.ReferringProviderNPI IS NOT NULL THEN a.ReferringProviderTaxId
                                             ELSE NULL
                                        END) ,
                                    SUM(a.ClientPayment) ,
                                    MAX(a.AuthorizationNumber) ,
                                    MAX(a.PayerClaimControlNumber) ,
                                    MAX(a.CLIANumber) ,
                                    MAX(a.MedicalRecordNumber) ,
                                    MAX(a.FacilityEntityCode) ,
                                    MAX(a.FacilityName) ,
                                    MAX(CASE WHEN a.FacilityNPI IS NULL THEN a.FacilityTaxIdType
                                             ELSE 'XX'
                                        END) ,
                                    MAX(CASE WHEN a.FacilityNPI IS NULL THEN a.FacilityTaxId
                                             ELSE a.FacilityNPI
                                        END) ,
                                    MAX(a.FacilityAddress1) ,
                                    MAX(a.FacilityAddress2) ,
                                    MAX(a.FacilityCity) ,
                                    MAX(a.FacilityState) ,
                                    MAX(a.FacilityZip) ,
                                    MAX(a.FacilityProviderIdType) ,
                                    MAX(a.FacilityProviderId) ,
/*,  
max(case when a.FacilityNPI is not null then   
(case when a.FacilityTaxIdType = '24' then 'EI' else 'SY' end) else null end),  
max(case when a.FacilityNPI is not null then a.FacilityTaxId else null end)  
*/
                                    MAX(a.SupervisingProvider2310DLastName) ,
                                    MAX(a.SupervisingProvider2310DFirstName) ,
                                    MAX(a.SupervisingProvider2310DMiddleName) ,
                                    MAX(a.SupervisingProvider2310DIdType) ,
                                    MAX(a.SupervisingProvider2310DId) ,
                                    MAX(a.SupervisingProvider2310DSecondaryIdType1) ,
                                    MAX(a.SupervisingProvider2310DSecondaryId1) ,
                                    MAX(a.SupervisingProvider2310DSecondaryIdType2) ,
                                    MAX(a.SupervisingProvider2310DSecondaryId2) ,
                                    MAX(a.SupervisingProvider2310DSecondaryIdType3) ,
                                    MAX(a.SupervisingProvider2310DSecondaryId3) ,
                                    MAX(a.SupervisingProvider2310DSecondaryIdType4) ,
                                    MAX(a.SupervisingProvider2310DSecondaryId4) ,
                                    MAX(a.ClaimNoteReferenceCode) ,
                                    MAX(a.ClaimNote)
                            FROM    #ClaimLines_Temp a
                                    JOIN #837SubscriberClients b ON ( a.ClientGroupId = b.ClientGroupId
                                                                      AND a.ClientId = b.ClientId
                                                                      AND a.CoveragePlanId = b.CoveragePlanId
                                                                      AND ISNULL(a.InsuredId, 'ISNULL') = ISNULL(b.InsuredId, 'ISNULL')
                                                                      AND a.Priority = b.Priority
                                                                      AND a.SubmissionReasonCode = b.SubmissionReasonCode
                                                                      AND ISNULL(a.ProviderCommercialNumber, 'ISNULL') = ISNULL(b.ProviderCommercialNumber, 'ISNULL')
                                                                    )
                                    JOIN #837BillingProviders c ON ( c.UniqueId = b.RefBillingProviderId
                                                                     AND a.BillingProviderNPI = c.BillingProviderId
                                                                   )
                                    JOIN #Claims d ON d.MaxClaimLineId = a.ClaimLineId
                            GROUP BY b.UniqueId ,
                                    a.ClaimLineId ,
                                    a.ClaimLineItemGroupId ,
                                    a.ToVoidClaimLineItemGroupId

  
                    IF @@error <> 0
                        GOTO error  

					-- Update TotalAmount with the ClaimAmount
                    UPDATE  a
                    SET     a.TotalAmount = b.ClaimAmount ,
                            a.NewClaimId = b.ClaimId
                    FROM    #837Claims a
                            JOIN #Claims b ON b.MaxClaimLineId = a.ClaimLineId


                    IF @@error <> 0
                        GOTO error  
  
-- Populate #837OtherInsureds  
                    DELETE  FROM #837OtherInsureds  
  
                    IF @@error <> 0
                        GOTO error  
  
                    INSERT  INTO #837OtherInsureds
                            ( RefClaimId ,
                              PayerSequenceNumber ,
                              SubscriberRelationshipCode ,
                              InsuranceTypeCode ,
                              ClaimFilingIndicatorCode ,
                              PayerPaidAmount ,
                              PayerAllowedAmount ,
                              InsuredDOB ,
                              InsuredSex ,
                              BenefitsAssignCertificationIndicator ,
                              PatientSignatureSourceCode ,
                              InformationReleaseCode ,
                              InsuredQualifier ,
                              InsuredLastName ,
                              InsuredFirstName ,
                              InsuredMiddleName ,
                              InsuredSuffix ,
                              InsuredIdQualifier ,
                              InsuredId ,
                              InsuredSecondaryQualifier ,
                              PayerName ,
                              PayerQualifier ,
                              PayerId ,
							  PayerAddress1 ,
							  PayerAddress2 ,
							  PayerCity ,
							  PayerState ,
							  PayerZip ,
                              PaymentDate ,
                              GroupName ,
                              PatientResponsibilityAmount ,
                              Priority
							)
                            SELECT  a.UniqueId ,
                                    CASE b.Priority
                                      WHEN 1 THEN 'P'
                                      WHEN 2 THEN 'S'
                                      ELSE 'T'
                                    END ,
                                    b.InsuredRelationCode ,
                                    b.InsuranceTypeCode ,
                                    b.ClaimFilingIndicatorCode ,
                                    b.PaidAmount ,
                                    NULL ,--b.AllowedAmount,  --srf 3/14/2011 set allowed amount to null as it is not required  
                                    CONVERT(VARCHAR, b.InsuredDOB, 112) ,
                                    b.InsuredSex ,
                                    'Y' ,
                                    'P' ,
                                    'Y' , --srf 3/14/2011 set to 'P', 'Y' per guide   
                                    '1' ,
                                    RTRIM(b.InsuredLastName) ,
                                    RTRIM(b.InsuredFirstName) ,
                                    RTRIM(b.InsuredMiddleName) ,
                                    RTRIM(b.InsuredSuffix) ,
                                    'MI' ,
                                    b.InsuredId ,
                                    'IG' ,
                                    b.PayerName ,
                                    'PI' ,
                                    b.ElectronicClaimsPayerId ,
									b.PayerAddress1,
									b.PayerAddress2,
									b.PayerCity,
									b.PayerState,
									b.PayerZip,
                                    CONVERT(VARCHAR, b.PaidDate, 112) ,
                                    b.GroupName ,
                                    b.ClientResponsibility ,
                                    b.Priority
                            FROM    #837Claims a
                                    JOIN #Claims a2 ON a2.MaxClaimLineId = a.ClaimLineId
                                    JOIN #ClaimOtherInsured b ON ( b.ClaimId = a2.ClaimId )  

-- TODO: Don't need to include other insured.  Just Subscriber Clients and Claims.
  
                    IF @@error <> 0
                        GOTO error  
  
                    UPDATE  a
                    SET     a.TotalPayerPaidAmount = ( SELECT   SUM(b.PayerPaidAmount)
                                                       FROM     #837OtherInsureds b
                                                       WHERE    b.RefClaimId = a.RefClaimId
                                                       GROUP BY b.RefClaimId
                                                     )
                    FROM    #837OtherInsureds a

--  SELECT * FROM #837OtherInsureds
  
-- Populate #837Services  
                    DELETE  FROM #837Services  
  
                    IF @@error <> 0
                        GOTO error  
  
                    INSERT  INTO #837Services
                            ( RefClaimId ,
                              ClaimLineId ,
                              ServiceIdQualifier ,
                              BillingCode ,
                              Modifier1 ,
                              Modifier2 ,
                              Modifier3 ,
                              Modifier4 ,
                              BillingCodeDescription ,
                              LineItemChargeAmount ,
                              UnitOfMeasure ,
                              ServiceUnitCount ,
                              PlaceOfService ,
                              DiagnosisCodePointer1 ,
                              DiagnosisCodePointer2 ,
                              DiagnosisCodePointer3 ,
                              DiagnosisCodePointer4 ,
                              DiagnosisCodePointer5 ,
                              DiagnosisCodePointer6 ,
                              DiagnosisCodePointer7 ,
                              DiagnosisCodePointer8 ,
                              EmergencyIndicator ,
                              ServiceDateQualifier ,
                              ServiceDate ,
                              LineItemControlNumber ,
                              ApprovedAmount ,
                              FacilityEntityCode ,--VARCHAR(2) NULL ,
                              FacilityName ,--VARCHAR(35) NULL ,
                              FacilityIdQualifier ,--VARCHAR(2) NULL ,
                              FacilityId ,--VARCHAR(80) NULL ,
                              FacilityAddress1 ,-- VARCHAR(55) NULL ,
                              FacilityAddress2 ,-- VARCHAR(55) NULL ,
                              FacilityCity ,--VARCHAR(30) NULL ,
                              FacilityState ,-- VARCHAR(2) NULL ,
                              FacilityZip ,--VARCHAR(15) NULL ,
                              FacilitySecondaryQualifier ,--VARCHAR(3) NULL ,
                              FacilitySecondaryId ,--VARCHAR(30) NULL ,
                              ServiceNoteReferenceCode ,
                              ServiceNote,
							  RenderingEntityCode,
							  RenderingEntityQualifier
							)
                            SELECT  b.UniqueId ,
                                    a.ClaimLineId ,
                                    'HC' ,
                                    a.BillingCode ,
                                    a.Modifier1 ,
                                    a.Modifier2 ,
                                    a.Modifier3 ,
                                    a.Modifier4 ,
                                    a.BillingCodeDescription ,
                                    a.ChargeAmount ,
                                    'UN' ,
                                    ( CASE WHEN CONVERT(INT, a.ClaimUnits * 10) = CONVERT(INT, a.ClaimUnits) * 10 THEN CONVERT(VARCHAR, CONVERT(INT, a.ClaimUnits))
                                           ELSE CONVERT(VARCHAR, a.ClaimUnits)
                                      END ) ,
                                    '' AS PlaceOfServiceCode , --a.PlaceOfServiceCode, --srf 3/18/2011 set place of service code to '' as it will always match place of service on claim.  per version 5 guideline  
                                    a.DiagnosisPointer1 ,
                                    a.DiagnosisPointer2 ,
                                    a.DiagnosisPointer3 ,
                                    a.DiagnosisPointer4 ,
									-- we can only send 4 pointers with our current process
                                    NULL ,	--a.DiagnosisPointer5 ,
                                    NULL ,	--a.DiagnosisPointer6 ,
                                    NULL ,	--a.DiagnosisPointer7 ,
                                    NULL ,	--a.DiagnosisPointer8 ,
                                    a.EmergencyIndicator ,
                                    CASE WHEN CONVERT(VARCHAR, a.DateOfService, 112) = CONVERT(VARCHAR, a.EndDateOfService, 112) THEN 'D8'
                                         ELSE 'RD8'
                                    END ,
                                    CASE WHEN CONVERT(VARCHAR, a.DateOfService, 112) = CONVERT(VARCHAR, a.EndDateOfService, 112) THEN CONVERT(VARCHAR, a.EndDateOfService, 112)
                                         ELSE RTRIM(CONVERT(VARCHAR, a.DateOfService, 112)) + '-' + RTRIM(CONVERT(VARCHAR, a.EndDateOfService, 112))
                                    END ,
                                    CONVERT(VARCHAR, a.LineItemControlNumber) ,
                                    a.ApprovedAmount ,
                                    a.ServiceLineFacilityEntityCode ,
                                    a.ServiceLineFacilityName ,
                                    CASE WHEN a.FacilityNPI IS NULL THEN a.ServiceLineFacilityTaxIdType
                                         ELSE 'XX'
                                    END ,
                                    CASE WHEN a.ServiceLineFacilityNPI IS NULL THEN a.ServiceLineFacilityTaxId
                                         ELSE a.ServiceLineFacilityNPI
                                    END ,
                                    a.ServiceLineFacilityAddress1 ,
                                    a.ServiceLineFacilityAddress2 ,
                                    a.ServiceLineFacilityCity ,
                                    a.ServiceLineFacilityState ,
                                    a.ServiceLineFacilityZip ,
                                    a.ServiceLineFacilityProviderIdType ,
                                    a.ServiceLineFacilityProviderId ,
                                    a.ServiceNoteReferenceCode ,
                                    a.ServiceNote,
									'82',
									'1'
                            FROM    #ClaimLines_Temp a
                                    JOIN #837Claims b ON ( b.NewClaimId = a.ClaimId )
                            ORDER BY a.PrimaryServiceId ,
                                    a.ClaimId ,
                                    a.ServiceId ,
                                    a.ChargeId
  
                    IF @@error <> 0
                        GOTO error  
  
  
  
  
--New**  
-- Populate #837DrugIdentification  
                    DELETE  FROM #837DrugIdentification  
  
  
                    EXEC dbo.scsp_PMClaims837UpdateDrugIdentificationSegment @CurrentUser = @ParamCurrentUser, @ClaimBatchId = @ParamClaimBatchId, @FormatType = @FormatType  
  
                    IF @@error <> 0
                        GOTO error  
  
--End New**  
  
                    EXEC dbo.scsp_PMClaims837UpdateSegmentData @CurrentUser = @ParamCurrentUser, @ClaimBatchId = @ParamClaimBatchId, @FormatType = @FormatType  
  
                    IF @@error <> 0
                        GOTO error  
  
-- Update Segments for Header and Trailer  
                    UPDATE  #837HeaderTrailer
                    SET     STSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'ST' + @te_sep + '837' + @te_sep + TransactionSetControlNumberHeader + @te_sep + ImplementationConventionReference ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                            BHTSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'BHT' + @te_sep + '0019' + @te_sep + TransactionSetPurposeCode + @te_sep + ApplicationTransactionId + @te_sep + CreationDate + @te_sep + CreationTime + @te_sep + EncounterId ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,  
--srf set TransactionTypeRefSegment to null per version 5 specs 3/15/2011  
                            TransactionTypeRefSegment = NULL ,  
--UPPER(replace(replace(replace(replace(replace(replace((  
--'REF' + @te_sep + '87'+ @te_sep + TransactionTypeCode    
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,  
                            SubmitterNM1Segment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'NM1' + @te_sep + '41' + @te_sep + SubmitterEntityQualifier + @te_sep + SubmitterLastName + @te_sep + @te_sep + @te_sep + @te_sep + @te_sep + '46' + @te_sep + SubmitterId ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                            SubmitterPerSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'PER' + @te_sep + 'IC' + @te_sep + SubmitterContactName + @te_sep + SubmitterCommNumber1Qualifier + @te_sep + SubmitterCommNumber1 ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                            ReceiverNm1Segment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'NM1' + @te_sep + '40' + @te_sep + '2' + @te_sep + ReceiverLastName + @te_sep + @te_sep + @te_sep + @te_sep + @te_sep + '46' + @te_sep + ReceiverPrimaryId ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term  
  
                    IF @@error <> 0
                        GOTO error  
  
-- Update segments for Billing and Pay to Provider  
                    UPDATE  #837BillingProviders
                    SET     BillingPRVSegment = CASE WHEN BillingProviderTaxonomyCode IS NULL THEN NULL
                                                     ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'PRV' + @te_sep + 'BI' + @te_sep + 'PXC' + @te_sep + BillingProviderTaxonomyCode ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                END ,
                            BillingProviderNM1Segment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'NM1' + @te_sep + '85' + @te_sep + CASE WHEN ISNULL(RTRIM(BillingProviderFirstName), '') = '' THEN '2'
                                                                                                                                                        ELSE '1'
                                                                                                                                                   END + @te_sep + BillingProviderLastName + CASE WHEN ISNULL(RTRIM(BillingProviderIdQualifier), '') = '' THEN RTRIM('')
                                                                                                                                                                                                  ELSE @te_sep + CASE WHEN ISNULL(RTRIM(BillingProviderFirstName), '') = '' THEN RTRIM('')
                                                                                                                                                                                                                      ELSE RTRIM(BillingProviderFirstName)
                                                                                                                                                                                                                 END + @te_sep + CASE WHEN ISNULL(RTRIM(BillingProviderMiddleName), '') = '' THEN RTRIM('')
                                                                                                                                                                                                                                      ELSE RTRIM(BillingProviderMiddleName)
                                                                                                                                                                                                                                 END + @te_sep + @te_sep + CASE WHEN ISNULL(RTRIM(BillingProviderSuffix), '') = '' THEN RTRIM('')
                                                                                                                                                                                                                                                                ELSE RTRIM(BillingProviderSuffix)
                                                                                                                                                                                                                                                           END + CASE WHEN ISNULL(RTRIM(BillingProviderIdQualifier), '') = '' THEN RTRIM('')
                                                                                                                                                                                                                                                                      ELSE @te_sep + BillingProviderIdQualifier + @te_sep + BillingProviderId
                                                                                                                                                                                                                                                                 END
                                                                                                                                                                                             END ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                            BillingProviderN3Segment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'N3' + @te_sep + REPLACE(REPLACE(REPLACE(BillingProviderAddress1, '#', ' '), '.', ' '), '-', ' ') + ( CASE WHEN ISNULL(RTRIM(BillingProviderAddress2), '') = '' THEN RTRIM('')
                                                                                                                                                                                                                          ELSE @te_sep + REPLACE(REPLACE(REPLACE(BillingProviderAddress2, '#', ' '), '.', ' '), '-', ' ')
                                                                                                                                                                                                                     END ) ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                            BillingProviderN4Segment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'N4' + @te_sep + BillingProviderCity + @te_sep + BillingProviderState + @te_sep + REPLACE(BillingProviderZip, '-', '') ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                            BillingProviderRefSegment = CASE WHEN BillingProviderAdditionalId IS NULL THEN NULL
                                                             ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'REF' + @te_sep + BillingProviderAdditionalIdQualifier + @te_sep + BillingProviderAdditionalId ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                        END ,
                            BillingProviderRef2Segment = CASE WHEN BillingProviderAdditionalId2 IS NULL THEN NULL
                                                              ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'REF' + @te_sep + BillingProviderAdditionalIdQualifier2 + @te_sep + BillingProviderAdditionalId2 ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                         END ,
                            BillingProviderRef3Segment = CASE WHEN BillingProviderAdditionalId3 IS NULL THEN NULL
                                                              ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'REF' + @te_sep + BillingProviderAdditionalIdQualifier3 + @te_sep + BillingProviderAdditionalId3 ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                         END ,
                            PayToProviderNM1Segment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'NM1' + @te_sep + '87' + @te_sep + '2'/* + @te_sep + PayToProviderLastName + @te_sep + @te_sep + @te_sep + @te_sep + @te_sep + PayToProviderIdQualifier + @te_sep + PayToProviderId */ ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                            PayToProviderN3Segment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'N3' + @te_sep + REPLACE(REPLACE(REPLACE(PayToProviderAddress1, '#', ' '), '.', ' '), '-', ' ') + ( CASE WHEN ISNULL(RTRIM(PayToProviderAddress2), '') = '' THEN RTRIM('')
                                                                                                                                                                                                                      ELSE @te_sep + REPLACE(REPLACE(REPLACE(PayToProviderAddress2, '#', ' '), '.', ' '), '-', ' ')
                                                                                                                                                                                                                 END ) ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                            PayToProviderN4Segment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'N4' + @te_sep + PayToProviderCity + @te_sep + PayToProviderState + @te_sep + PayToProviderZip ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term 
                            --PayToProviderRefSegment = CASE WHEN PayToProviderSecondaryId IS NULL THEN NULL
                            --                               ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'REF' + @te_sep + PayToProviderSecondaryQualifier + @te_sep + PayToProviderSecondaryId ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                            --                          END ,
                            --PayToProviderRef2Segment = CASE WHEN PayToProviderSecondaryId2 IS NULL THEN NULL
                            --                                ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'REF' + @te_sep + PayToProviderSecondaryQualifier2 + @te_sep + PayToProviderSecondaryId2 ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                            --                           END ,
                            --PayToProviderRef3Segment = CASE WHEN PayToProviderSecondaryId3 IS NULL THEN NULL
                            --                                ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'REF' + @te_sep + PayToProviderSecondaryQualifier3 + @te_sep + PayToProviderSecondaryId3 ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                            --                           END  
  
                    IF @@error <> 0
                        GOTO error  
  
-- do not send pay to provider info if Billing And Pay to providers are the same  
                    UPDATE  #837BillingProviders
                    SET     PayToProviderNM1Segment = NULL ,
                            PayToProviderN3Segment = NULL ,
                            PayToProviderN4Segment = NULL ,
                            PayToProviderRefSegment = NULL ,
                            PayToProviderRef2Segment = NULL ,
                            PayToProviderRef3Segment = NULL
                    WHERE   BillingProviderAddress1 = PayToProviderAddress1
                            AND ISNULL(BillingProviderAddress2, '') = ISNULL(PayToProviderAddress2, '')
                            AND BillingProviderCity = PayToProviderCity
                            AND BillingProviderState = PayToProviderState
                            AND BillingProviderZip = PayToProviderZip
  
                    IF @@error <> 0
                        GOTO error  
  
/*  
where BillingProviderLastName = PayToProviderLastName  
and (BillingProviderFirstName = PayToProviderFirstName or  
(BillingProviderFirstName is null and PayToProviderFirstName is null))  
and (BillingProviderMiddleName = PayToProviderMiddleName or  
(BillingProviderMiddleName is null and PayToProviderMiddleName is null))  
and BillingProviderAddress1 = PayToProviderAddress1  
and BillingProviderCity = PayToProviderCity  
and BillingProviderState = PayToProviderState  
and BillingProviderZip = PayToProviderZip  
*/  
  
--Update Segments for Subscriber Patient  
                    UPDATE  #837SubscriberClients
                    SET     SubscriberSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'SBR' + @te_sep + ( CASE Priority
                                                                                                                              WHEN 1 THEN 'P'
                                                                                                                              WHEN 2 THEN 'S'
                                                                                                                              ELSE 'T'
                                                                                                                            END ) + @te_sep + CASE WHEN RelationCode = '18' THEN '18'
                                                                                                                                                   ELSE RTRIM('')
                                                                                                                                              END + CASE WHEN ISNULL(RTRIM(GroupNumber), '') = '' THEN @te_sep
                                                                                                                                                         ELSE @te_sep + RTRIM(GroupNumber)
                                                                                                                                                    END + CASE WHEN ISNULL(RTRIM(GroupName), '') = ''
                                                                                                                                                                    OR ISNULL(RTRIM(GroupNumber), '') <> '' THEN @te_sep
                                                                                                                                                               ELSE @te_sep + RTRIM(GroupName)
                                                                                                                                                          END + CASE WHEN ISNULL(RTRIM(MedicareInsuranceTypeCode), '') = '' THEN @te_sep
                                                                                                                                                                     ELSE @te_sep + RTRIM(MedicareInsuranceTypeCode)
                                                                                                                                                                END + @te_sep + @te_sep + @te_sep + @te_sep + RTRIM(ClaimFilingIndicatorCode) ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                            SubscriberNM1Segment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'NM1' + @te_sep + 'IL' + @te_sep + SubscriberEntityQualifier + @te_sep + SubscriberLastName + @te_sep + ( CASE WHEN ISNULL(RTRIM(SubscriberFirstName), '') = '' THEN RTRIM('')
                                                                                                                                                                                                                          ELSE SubscriberFirstName
                                                                                                                                                                                                                     END ) + @te_sep + ( CASE WHEN ISNULL(RTRIM(SubscriberMiddleName), '') = '' THEN RTRIM('')
                                                                                                                                                                                                                                              ELSE SubscriberMiddleName
                                                                                                                                                                                                                                         END ) + @te_sep + ( CASE WHEN ISNULL(RTRIM(SubscriberSuffix), '') = '' THEN @te_sep
                                                                                                                                                                                                                                                                  ELSE @te_sep + RTRIM(SubscriberSuffix)
                                                                                                                                                                                                                                                             END ) + @te_sep + SubscriberIdQualifier + @te_sep + REPLACE(REPLACE(InsuredId, '-', RTRIM('')), ' ', RTRIM('')) ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                            SubscriberN3Segment = CASE WHEN ClientIsSubscriber = 'Y' THEN UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'N3' + @te_sep + RTRIM(REPLACE(REPLACE(REPLACE(SubscriberAddress1, '#', ' '), '.', ' '), '-', ' ')) + ( CASE WHEN ISNULL(RTRIM(SubscriberAddress2), '') = '' THEN RTRIM('')
                                                                                                                                                                                                                                                               ELSE @te_sep + RTRIM(REPLACE(REPLACE(REPLACE(SubscriberAddress2, '#', ' '), '.', ' '), '-', ' '))
                                                                                                                                                                                                                                                          END ) ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                       ELSE NULL
                                                  END ,
                            SubscriberN4Segment =   
--srf 3/25/2011  set to null if the client is not the subscriber  
                            CASE WHEN ClientIsSubscriber = 'Y' THEN UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'N4' + @te_sep + SubscriberCity + @te_sep + SubscriberState + @te_sep + SubscriberZip ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                 ELSE NULL
                            END ,
                            SubscriberDMGSegment =   
--srf 3/25/2011 set to null if client is not the subscriber   
                            CASE WHEN ClientIsSubscriber = 'Y' THEN UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'DMG' + @te_sep + 'D8' + @te_sep + SubscriberDOB + @te_sep + ( CASE WHEN SubscriberSex IS NULL THEN 'U'
                                                                                                                                                                                                ELSE SubscriberSex
                                                                                                                                                                                           END ) ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                 ELSE NULL
                            END ,
--11/2/2018 set to null Aurora SGL#29 remove rendering provider ssn
                            SubscriberRefSegment = NULL,
							 --CASE WHEN SubscriberSSN IS NULL THEN NULL
        --                                                ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'REF' + @te_sep + 'SY' + @te_sep + SubscriberSSN ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
        --                                           END ,
                            PayerNM1Segment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'NM1' + @te_sep + 'PR' + @te_sep + '2' + @te_sep + PayerName + @te_sep + @te_sep + @te_sep + @te_sep + @te_sep + PayerIdQualifier + @te_sep + ElectronicClaimsPayerId ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                            PayerN3Segment = CASE WHEN PayerAddress1 IS NULL THEN NULL
                                                  ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'N3' + @te_sep + RTRIM(REPLACE(REPLACE(REPLACE(PayerAddress1, '#', ' '), '.', ' '), '-', ' ')) + ( CASE WHEN ISNULL(RTRIM(PayerAddress2), '') = '' THEN RTRIM('')
                                                                                                                                                                                                                       ELSE @te_sep + RTRIM(REPLACE(REPLACE(REPLACE(PayerAddress2, '#', ' '), '.', ' '), '-', ' '))
                                                                                                                                                                                                                  END ) ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                             END ,
                            PayerN4Segment = CASE WHEN PayerAddress1 IS NULL THEN NULL
                                                  ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'N4' + @te_sep + PayerCity + @te_sep + PayerState + @te_sep + PayerZip ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                             END ,
                            PayerRefSegment = CASE WHEN ISNULL(RTRIM(ClaimOfficeNumber), '') = '' THEN NULL
                                                   ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'REF' + @te_sep + 'FY' + @te_sep + ClaimOfficeNumber ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                              END ,
                            PayerRefG2Segment = CASE WHEN ISNULL(RTRIM(ProviderCommercialNumber), '') = '' THEN NULL
                                                     ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'REF' + @te_sep + 'G2' + @te_sep + ProviderCommercialNumber ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                END ,
                            PayerRefNFSegment = CASE WHEN ISNULL(RTRIM(InsuranceCommissionersCode), '') = '' THEN NULL
                                                     ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'REF' + @te_sep + 'NF' + @te_sep + InsuranceCommissionersCode ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                END ,
                            PatientPatSegment = CASE WHEN RelationCode = '18' THEN NULL
                                                     ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'PAT' + @te_sep + RelationCode ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                END ,
                            PatientNM1Segment = CASE WHEN RelationCode = '18' THEN NULL
                                                     ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'NM1' + @te_sep + 'QC' + @te_sep + '1' + @te_sep + ClientLastName + ( CASE WHEN ISNULL(RTRIM(ClientFirstName), '') = '' THEN ( CASE WHEN ISNULL(RTRIM(ClientMiddleName), '') <> ''
                                                                                                                                                                                                                                                           OR ISNULL(RTRIM(ClientSuffix), '') <> '' THEN @te_sep
                                                                                                                                                                                                                                                      ELSE RTRIM('')
                                                                                                                                                                                                                                                 END )
                                                                                                                                                                                             ELSE @te_sep + RTRIM(ClientFirstName)
                                                                                                                                                                                        END ) + ( CASE WHEN ISNULL(RTRIM(ClientMiddleName), '') = '' THEN ( CASE WHEN ISNULL(RTRIM(ClientSuffix), '') <> '' THEN @te_sep
                                                                                                                                                                                                                                                                 ELSE RTRIM('')
                                                                                                                                                                                                                                                            END )
                                                                                                                                                                                                       ELSE @te_sep + RTRIM(ClientMiddleName)
                                                                                                                                                                                                  END ) + ( CASE WHEN ISNULL(RTRIM(ClientSuffix), '') = '' THEN RTRIM('')
                                                                                                                                                                                                                 ELSE @te_sep + @te_sep + RTRIM(ClientSuffix)
                                                                                                                                                                                                            END ) ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                END ,
                            PatientN3Segment = CASE WHEN RelationCode = '18' THEN NULL
                                                    ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'N3' + @te_sep + REPLACE(REPLACE(REPLACE(ClientAddress1, '#', ' '), '.', ' '), '-', ' ') + ( CASE WHEN ISNULL(RTRIM(ClientAddress2), '') = '' THEN RTRIM('')
                                                                                                                                                                                                                   ELSE @te_sep + RTRIM(REPLACE(REPLACE(REPLACE(ClientAddress2, '#', ' '), '.', ' '), '-', ' '))
                                                                                                                                                                                                              END ) ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                               END ,
                            PatientN4Segment = CASE WHEN RelationCode = '18' THEN NULL
                                                    ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'N4' + @te_sep + ClientCity + @te_sep + ClientState + @te_sep + ClientZip ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                               END ,
                            PatientDMGSegment = CASE WHEN RelationCode = '18' THEN NULL
                                                     ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'DMG' + @te_sep + 'D8' + @te_sep + ClientDOB + @te_sep + ( CASE WHEN ClientSex IS NULL THEN 'U'
                                                                                                                                                                                  ELSE ClientSex
                                                                                                                                                                             END ) ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                END  
  
                    IF @@error <> 0
                        GOTO error  

						
  
  
                   
					
--Update segment information for #837Claims  
                    UPDATE  #837Claims
                    SET     CLMSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'CLM' + @te_sep + ClaimId + @te_sep + ( CASE WHEN CONVERT(INT, TotalAmount * 100) = CONVERT(INT, TotalAmount) * 100 THEN CONVERT(VARCHAR, CONVERT(INT, TotalAmount))
                                                                                                                                              ELSE CONVERT(VARCHAR, TotalAmount)
                                                                                                                                         END ) + @te_sep + @te_sep + @te_sep + PlaceOfService + @tse_sep + 'B' + @tse_sep + SubmissionReasonCode + @te_sep + SignatureIndicator + @te_sep + MedicareAssignCode + @te_sep + BenefitsAssignCertificationIndicator + @te_sep + ReleaseCode + @te_sep + PatientSignatureCode ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                            AdmissionDateDTPSegment = CASE WHEN RelatedHospitalAdmitDate IS NULL THEN NULL
                                                           ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'DTP' + @te_sep + '435' + @te_sep + 'D8' + @te_sep + RelatedHospitalAdmitDate ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                      END ,
                            PatientAmountPaidSegment = CASE WHEN PatientAmountPaid IN ( 0, NULL ) THEN NULL
                                                            ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'AMT' + @te_sep + 'F5' + @te_sep + ( CASE WHEN CONVERT(INT, PatientAmountPaid * 100) = CONVERT(INT, PatientAmountPaid) * 100 THEN CONVERT(VARCHAR, CONVERT(INT, PatientAmountPaid))
                                                                                                                                                                   ELSE CONVERT(VARCHAR, PatientAmountPaid)
                                                                                                                                                              END ) ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                       END ,
                            AuthorizationNumberRefSegment = CASE WHEN ISNULL(RTRIM(PriorAuthorizationNumber), '') = '' THEN NULL
                                                                 ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'REF' + @te_sep + 'G1' + @te_sep + PriorAuthorizationNumber ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                            END ,
                            PayerClaimControlNumberRefSegment = CASE WHEN ISNULL(RTRIM(PayerClaimControlNumber), '') = '' THEN NULL
                                                                     ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'REF' + @te_sep + 'F8' + @te_sep + PayerClaimControlNumber ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                                END ,
                            CLIANumberRefSegment = CASE WHEN ISNULL(RTRIM(CLIANumber), '') = '' THEN NULL
                                                        ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'REF' + @te_sep + 'X4' + @te_sep + CLIANumber ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                   END ,
                            MedicalRecordNumberRefSegment = CASE WHEN ISNULL(RTRIM(MedicalRecordNumber), '') = '' THEN NULL
                                                                 ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'REF' + @te_sep + 'EA' + @te_sep + MedicalRecordNumber ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                            END ,
                            NTESegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((        
 /*NTE00*/ 'NTE' + @te_sep + /*NTE01*/ClaimNoteReferenceCode + @te_sep + /*NTE02*/ClaimNote ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                            HISegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'HI' + @te_sep + ISNULL(DiagnosisQualifier1, '') + @tse_sep + DiagnosisCode1 + ( CASE WHEN DiagnosisCode2 IS NOT NULL THEN @te_sep + ISNULL(DiagnosisQualifier2, '') + @tse_sep + DiagnosisCode2 + ( CASE WHEN DiagnosisCode3 IS NOT NULL THEN @te_sep + ISNULL(DiagnosisQualifier3, '') + @tse_sep + DiagnosisCode3 + ( CASE WHEN DiagnosisCode4 IS NOT NULL THEN @te_sep + ISNULL(DiagnosisQualifier4, '') + @tse_sep + DiagnosisCode4 + ( CASE WHEN DiagnosisCode5 IS NOT NULL THEN @te_sep + ISNULL(DiagnosisQualifier5, '') + @tse_sep + DiagnosisCode5 + ( CASE WHEN DiagnosisCode6 IS NOT NULL THEN @te_sep + ISNULL(DiagnosisQualifier6, '') + @tse_sep + DiagnosisCode6 + ( CASE WHEN DiagnosisCode7 IS NOT NULL THEN @te_sep + ISNULL(DiagnosisQualifier7, '') + @tse_sep + DiagnosisCode7 + ( CASE WHEN DiagnosisCode8 IS NOT NULL THEN @te_sep + ISNULL(DiagnosisQualifier8, '') + @tse_sep + DiagnosisCode8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ELSE RTRIM('')
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         END )
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          ELSE RTRIM('')
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     END )
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      ELSE RTRIM('')
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 END )
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  ELSE RTRIM('')
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             END )
                                                                                                                                                                                                                                                                                                                                                                                                                              ELSE RTRIM('')
                                                                                                                                                                                                                                                                                                                                                                                                                         END )
                                                                                                                                                                                                                                                                                                          ELSE RTRIM('')
                                                                                                                                                                                                                                                                                                     END )
                                                                                                                                                                                      ELSE RTRIM('')
                                                                                                                                                                                 END ) ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                            ReferringNM1Segment = CASE WHEN ReferringId IS NULL
                                                            AND ReferringSecondaryId IS NULL THEN NULL
                                                       ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'NM1' + @te_sep + ReferringEntityCode + @te_sep + ReferringEntityQualifier + @te_sep + ReferringLastName + @te_sep + ReferringFirstName + ( CASE WHEN ReferringIdQualifier = 'XX' THEN @te_sep + @te_sep + @te_sep + @te_sep + ReferringIdQualifier + @te_sep + ReferringId
                                                                                                                                                                                                                                                                     ELSE RTRIM('')
                                                                                                                                                                                                                                                                END ) ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                  END ,
                            ReferringRefSegment = CASE WHEN ReferringSecondaryId IS NULL THEN NULL
                                                       ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'REF' + @te_sep + ReferringSecondaryQualifier + @te_sep + ReferringSecondaryId ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                  END ,
                            ReferringRef2Segment = CASE WHEN ReferringSecondaryId2 IS NULL THEN NULL
                                                        ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'REF' + @te_sep + ReferringSecondaryQualifier2 + @te_sep + ReferringSecondaryId2 ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                   END ,
                            ReferringRef3Segment = CASE WHEN ReferringSecondaryId3 IS NULL THEN NULL
                                                        ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'REF' + @te_sep + ReferringSecondaryQualifier3 + @te_sep + ReferringSecondaryId3 ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                   END ,
                            RenderingNM1Segment = CASE WHEN ISNULL(RTRIM(RenderingId), '') = '' THEN NULL
                                                       ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'NM1' + @te_sep + RenderingEntityCode + @te_sep + RenderingEntityQualifier + @te_sep + RenderingLastName + @te_sep + RenderingFirstName + @te_sep + @te_sep + @te_sep + @te_sep + RenderingIdQualifier + @te_sep + RenderingId ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                  END ,
                            RenderingPRVSegment = CASE WHEN ISNULL(RTRIM(RenderingId), '') = '' THEN NULL
                                                       ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'PRV' + @te_sep + 'PE' + @te_sep + 'PXC' + @te_sep + RenderingTaxonomyCode --srf 3/14/2011 changed 'zz' to 'PCX' per guide  
                                                                                                                    ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                  END ,
                            RenderingRefSegment = CASE WHEN ISNULL(RTRIM(RenderingId), '') = ''
                                                            OR ISNULL(RTRIM(RenderingSecondaryId), '') = '' THEN NULL
                                                       ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'REF' + @te_sep + RenderingSecondaryQualifier + @te_sep + RenderingSecondaryId ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                  END ,
                            RenderingRef2Segment = CASE WHEN ISNULL(RTRIM(RenderingSecondaryId2), '') = '' THEN NULL
                                                        ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'REF' + @te_sep + RenderingSecondaryQualifier2 + @te_sep + RenderingSecondaryId2 ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                   END ,
                            RenderingRef3Segment = CASE WHEN ISNULL(RTRIM(RenderingSecondaryId3), '') = '' THEN NULL
                                                        ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'REF' + @te_sep + RenderingSecondaryQualifier3 + @te_sep + RenderingSecondaryId3 ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                   END ,
                            FacilityNM1Segment = CASE WHEN ISNULL(RTRIM(FacilityAddress1), '') = ''
                                                           OR ISNULL(RTRIM(FacilityCity), '') = ''
                                                           OR ISNULL(RTRIM(FacilityState), '') = ''
                                                           OR ISNULL(RTRIM(FacilityZip), '') = ''
                                                           OR ISNULL(RTRIM(FacilityEntityCode), '') = ''
                                                           OR ISNULL(RTRIM(FacilityName), '') = ''
                                                           --OR ISNULL(RTRIM(FacilityidQualifier), '') = ''
                                                           --OR ISNULL(RTRIM(FacilityId), '') = '' 
                                                           THEN NULL
                                                      ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'NM1' + @te_sep + FacilityEntityCode + @te_sep + '2' + @te_sep + FacilityName + ISNULL(@te_sep + @te_sep + @te_sep + @te_sep + @te_sep + FacilityIdQualifier + @te_sep + FacilityId, '') ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                 END ,
                            FacilityN3Segment = CASE WHEN ISNULL(RTRIM(FacilityAddress1), '') = ''
                                                          OR ISNULL(RTRIM(FacilityCity), '') = ''
                                                          OR ISNULL(RTRIM(FacilityState), '') = ''
                                                          OR ISNULL(RTRIM(FacilityZip), '') = ''
                                                          OR ISNULL(RTRIM(FacilityEntityCode), '') = ''
                                                          OR ISNULL(RTRIM(FacilityName), '') = ''
                                                          --OR ISNULL(RTRIM(FacilityidQualifier), '') = ''
                                                          --OR ISNULL(RTRIM(FacilityId), '') = '' 
                                                          THEN NULL
                                                     ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'N3' + @te_sep + REPLACE(REPLACE(REPLACE(FacilityAddress1, '#', ' '), '.', ' '), '-', ' ') + ( CASE WHEN ISNULL(RTRIM(FacilityAddress2), '') = '' THEN RTRIM('')
                                                                                                                                                                                                                      ELSE @te_sep + REPLACE(REPLACE(REPLACE(FacilityAddress2, '#', ' '), '.', ' '), '-', ' ')
                                                                                                                                                                                                                 END ) ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                END ,
                            FacilityN4Segment = CASE WHEN ISNULL(RTRIM(FacilityAddress1), '') = ''
                                                          OR ISNULL(RTRIM(FacilityCity), '') = ''
                                                          OR ISNULL(RTRIM(FacilityState), '') = ''
                                                          OR ISNULL(RTRIM(FacilityZip), '') = ''
                                                          OR ISNULL(RTRIM(FacilityEntityCode), '') = ''
                                                          OR ISNULL(RTRIM(FacilityName), '') = ''
                                                          --OR ISNULL(RTRIM(FacilityidQualifier), '') = ''
                                                          --OR ISNULL(RTRIM(FacilityId), '') = '' 
                                                          THEN NULL
                                                     ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'N4' + @te_sep + FacilityCity + @te_sep + FacilityState + @te_sep + FacilityZip ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                END ,
                            FacilityRefSegment = CASE WHEN ISNULL(RTRIM(FacilitySecondaryId), '') = '' THEN NULL
                                                      ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'REF' + @te_sep + FacilitySecondaryQualifier + @te_sep + FacilitySecondaryId ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                 END ,
                            FacilityRef2Segment = CASE WHEN ISNULL(RTRIM(FacilitySecondaryId2), '') = '' THEN NULL
                                                       ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'REF' + @te_sep + FacilitySecondaryQualifier2 + @te_sep + FacilitySecondaryId2 ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                  END ,
                            FacilityRef3Segment = CASE WHEN ISNULL(RTRIM(FacilitySecondaryId3), '') = '' THEN NULL
                                                       ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'REF' + @te_sep + FacilitySecondaryQualifier3 + @te_sep + FacilitySecondaryId3 ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                  END ,
                            Supervising2310DNM1Segment = CASE WHEN ISNULL(RTRIM(SupervisingProvider2310DLastName), '') = '' THEN NULL
                                                              ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE('NM1' + @te_sep + 'DQ' + @te_sep + '1' + @te_sep + SupervisingProvider2310DLastName + @te_sep + ISNULL(SupervisingProvider2310DFirstName, '') + @te_sep + ISNULL(SupervisingProvider2310DMiddleName, '') + ISNULL(@te_sep + @te_sep + @te_sep + ISNULL(SupervisingProvider2310DIdType, 'XX') + @te_sep + SupervisingProvider2310DId, ''), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                         END ,
                            Supervising2310DREF1Segment = CASE WHEN ISNULL(RTRIM(SupervisingProvider2310DSecondaryId1), '') = '' THEN NULL
                                                               ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE('REF' + @te_sep + SupervisingProvider2310DSecondaryIdType1 + @te_sep + SupervisingProvider2310DSecondaryId1, @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                          END ,
                            Supervising2310DREF2Segment = CASE WHEN ISNULL(RTRIM(SupervisingProvider2310DSecondaryId2), '') = '' THEN NULL
                                                               ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE('REF' + @te_sep + SupervisingProvider2310DSecondaryIdType2 + @te_sep + SupervisingProvider2310DSecondaryId2, @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                          END ,
                            Supervising2310DREF3Segment = CASE WHEN ISNULL(RTRIM(SupervisingProvider2310DSecondaryId3), '') = '' THEN NULL
                                                               ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE('REF' + @te_sep + SupervisingProvider2310DSecondaryIdType3 + @te_sep + SupervisingProvider2310DSecondaryId3, @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                          END ,
                            Supervising2310DREF4Segment = CASE WHEN ISNULL(RTRIM(SupervisingProvider2310DSecondaryId4), '') = '' THEN NULL
                                                               ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE('REF' + @te_sep + SupervisingProvider2310DSecondaryIdType4 + @te_sep + SupervisingProvider2310DSecondaryId4, @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                          END  
  
  
                    IF @@error <> 0
                        GOTO error  
  
  
  
  
  --SELECT * FROM #837Claims AS c
  
  
  
-- Update segment information for #837OtherInsureds  
                    UPDATE  #837OtherInsureds
                    SET     SubscriberSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'SBR' + @te_sep + PayerSequenceNumber + @te_sep + SubscriberRelationshipCode + -- srf 3/22/2011 -- set to group number based on version 5 guide  
 CASE WHEN ISNULL(RTRIM(GroupNumber), '') = '' THEN @te_sep
      ELSE @te_sep + RTRIM(GroupNumber)
 END + CASE WHEN ISNULL(RTRIM(GroupName), '') = ''
                 OR ISNULL(RTRIM(GroupNumber), '') <> '' THEN @te_sep
            ELSE @te_sep + RTRIM(GroupName)
       END + -- srf 3/22/2011 -- set to group number based on version 5 guide  
--  isnull(rtrim(InsuredId),rtrim('')) + @te_sep + isnull(rtrim(GroupName),rtrim('')) +   
@te_sep + InsuranceTypeCode + @te_sep + @te_sep + @te_sep + @te_sep + ClaimFilingIndicatorCode ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                            PayerPaidAmountSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'AMT' + @te_sep + 'D' + @te_sep + CONVERT(VARCHAR, PayerPaidAmount) ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                            PayerAllowedAmountSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'AMT' + @te_sep + 'B6' + @te_sep + CONVERT(VARCHAR, PayerAllowedAmount) ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,   
--srf 3/18/2011 removed subscriber DMG per guide                              
                            DMGSegment = NULL ,  
--UPPER(replace(replace(replace(replace(replace(replace((  
--'DMG' + @te_sep +  'D8' + @te_sep +  InsuredDOB + @te_sep +    
--(case when InsuredSex is null then 'U' else InsuredSex end)  
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term,   
                            OISegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'OI' + @te_sep + @te_sep + @te_sep + BenefitsAssignCertificationIndicator + @te_sep + PatientSignatureSourceCode + @te_sep + @te_sep + InformationReleaseCode ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                            OINM1Segment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'NM1' + @te_sep + 'IL' + @te_sep + InsuredQualifier + @te_sep + InsuredLastName + @te_sep + InsuredFirstName + @te_sep + @te_sep + @te_sep + @te_sep + InsuredIdQualifier + @te_sep + InsuredId ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,   
/*OIRefSegment = UPPER(replace(replace(replace(replace(replace(replace((  
'REF' + @te_sep +  InsuredSecondaryQualifier + @te_sep +    
InsuredSecondaryId   
), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term, */
                            PayerNM1Segment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'NM1' + @te_sep + 'PR' + @te_sep + '2' + @te_sep + PayerName + @te_sep + @te_sep + @te_sep + @te_sep + @te_sep + PayerQualifier + @te_sep + PayerId ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                            PayerPaymentDTPSegment = NULL,
							PayerN3Segment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'N3' + @te_sep + PayerAddress1 + ISNULL(@te_Sep + PayerAddress2, '') ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term,
							PayerN4Segment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'N3' + @te_sep + PayerCity + @te_sep + PayerState + @te_sep + PayerZip ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
 --srf 3/22/2011 set to blank per version 5 guide --   The Claim Check or Remittance Date (Loop 2330, DTP) is only required when the Line Adjudication Information (Loop 2430, SVD) is not used and the claim has been previousl
--y adjudicated by the provider in loop 2330B. ErrCode:40708,Severity:Error, HIPAA Type4-Situation {LoopID=2430;SegID=CLM;SegPos=37}  
--case when  isnull(rtrim(PaymentDate),'') = '' then null else  
--UPPER(replace(replace(replace(replace(replace(replace((  
--'DTP' + @te_sep +  '573' + @te_sep +  'D8' + @te_sep + PaymentDate  
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end  
  
                    IF @@error <> 0
                        GOTO error  

                        
-- Other Insured Adjustment Information  
                    INSERT INTO #837OtherInsuredClaimLines
                             (
                               ClaimLineId
							 , [Priority]
                             , SVDSegment
                             , CAS1Segment
                             , CAS2Segment
                             , CAS3Segment
                             , CAS4Segment
                             , ServiceAdjudicationDTPSegment
                             )
                    SELECT  ClaimLineId = b.ClaimLineId
							,[Priority] = b.[Priority]
							,SVDSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'SVD' + @te_sep + b.ElectronicClaimsPayerId + @te_sep + ( CASE WHEN CONVERT(INT, b.PaidAmount * 100) = CONVERT(INT, b.PaidAmount) * 100 THEN CONVERT(VARCHAR, CONVERT(INT, b.PaidAmount))
                                                                                                                                                  ELSE CONVERT(VARCHAR, b.PaidAmount)
                                                                                                                                             END ) + @te_sep + 'HC' + @tse_sep + RTRIM(b.BillingCode) + ( CASE WHEN b.Modifier1 IS NOT NULL THEN @tse_sep + RTRIM(b.Modifier1)
                                                                                                                                                                                                               ELSE RTRIM('')
                                                                                                                                                                                                          END ) + ( CASE WHEN b.Modifier2 IS NOT NULL THEN @tse_sep + RTRIM(b.Modifier2)
                                                                                                                                                                                                                         ELSE RTRIM('')
                                                                                                                                                                                                                    END ) + ( CASE WHEN b.Modifier3 IS NOT NULL THEN @tse_sep + RTRIM(b.Modifier3)
                                                                                                                                                                                                                                   ELSE RTRIM('')
                                                                                                                                                                                                                              END ) + ( CASE WHEN b.Modifier4 IS NOT NULL THEN @tse_sep + RTRIM(b.Modifier4)
                                                                                                                                                                                                                                             ELSE RTRIM('')
                                                                                                                                                                                                                                        END ) + @te_sep + @te_sep + ( CASE WHEN CONVERT(INT, b.ClaimUnits * 10) = CONVERT(INT, b.ClaimUnits) * 10 THEN CONVERT(VARCHAR, CONVERT(INT, b.ClaimUnits))
                                                                                                                                                                                                                                                                           ELSE CONVERT(VARCHAR, b.ClaimUnits)
                                                                                                                                                                                                                                                                      END ) ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                            CAS1Segment = CASE WHEN c.HIPAACode1 IS NULL
                                                      OR c.Amount1 IN ( 0, NULL ) THEN NULL
                                                 ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'CAS' + @te_sep + 'PR' + @te_sep + c.HIPAACode1 + @te_sep + CONVERT(VARCHAR, c.Amount1) + CASE WHEN c.HIPAACode2 IS NULL
                                                                                                                                                                                                                  OR c.Amount2 IN ( 0, NULL ) THEN RTRIM('')
                                                                                                                                                                                                             ELSE @te_sep + @te_sep + c.HIPAACode2 + @te_sep + CONVERT(VARCHAR, c.Amount2)
                                                                                                                                                                                                        END + CASE WHEN c.HIPAACode3 IS NULL
                                                                                                                                                                                                                        OR c.Amount3 IN ( 0, NULL ) THEN RTRIM('')
                                                                                                                                                                                                                   ELSE @te_sep + @te_sep + c.HIPAACode3 + @te_sep + CONVERT(VARCHAR, c.Amount3)
                                                                                                                                                                                                              END + CASE WHEN c.HIPAACode4 IS NULL
                                                                                                                                                                                                                              OR c.Amount4 IN ( 0, NULL ) THEN RTRIM('')
                                                                                                                                                                                                                         ELSE @te_sep + @te_sep + c.HIPAACode4 + @te_sep + CONVERT(VARCHAR, c.Amount4)
                                                                                                                                                                                                                    END + CASE WHEN c.HIPAACode5 IS NULL
                                                                                                                                                                                                                                    OR c.Amount5 IN ( 0, NULL ) THEN RTRIM('')
                                                                                                                                                                                                                               ELSE @te_sep + @te_sep + c.HIPAACode5 + @te_sep + CONVERT(VARCHAR, c.Amount5)
                                                                                                                                                                                                                          END + CASE WHEN c.HIPAACode6 IS NULL
                                                                                                                                                                                                                                          OR c.Amount6 IN ( 0, NULL ) THEN RTRIM('')
                                                                                                                                                                                                                                     ELSE @te_sep + @te_sep + c.HIPAACode6 + @te_sep + CONVERT(VARCHAR, c.Amount6)
                                                                                                                                                                                                                                END ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                            END ,
                            CAS2Segment = CASE WHEN d.HIPAACode1 IS NULL
                                                      OR d.Amount1 IN ( 0, NULL ) THEN NULL
                                                 ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'CAS' + @te_sep + 'CO' + @te_sep + d.HIPAACode1 + @te_sep + CONVERT(VARCHAR, d.Amount1) + CASE WHEN d.HIPAACode2 IS NULL
                                                                                                                                                                                                                  OR d.Amount2 IN ( 0, NULL ) THEN RTRIM('')
                                                                                                                                                                                                             ELSE @te_sep + @te_sep + d.HIPAACode2 + @te_sep + CONVERT(VARCHAR, d.Amount2)
                                                                                                                                                                                                        END + CASE WHEN d.HIPAACode3 IS NULL
                                                                                                                                                                                                                        OR d.Amount3 IN ( 0, NULL ) THEN RTRIM('')
                                                                                                                                                                                                                   ELSE @te_sep + @te_sep + d.HIPAACode3 + @te_sep + CONVERT(VARCHAR, d.Amount3)
                                                                                                                                                                                                              END + CASE WHEN d.HIPAACode4 IS NULL
                                                                                                                                                                                                                              OR d.Amount4 IN ( 0, NULL ) THEN RTRIM('')
                                                                                                                                                                                                                         ELSE @te_sep + @te_sep + d.HIPAACode4 + @te_sep + CONVERT(VARCHAR, d.Amount4)
                                                                                                                                                                                                                    END + CASE WHEN d.HIPAACode5 IS NULL
                                                                                                                                                                                                                                    OR d.Amount5 IN ( 0, NULL ) THEN RTRIM('')
                                                                                                                                                                                                                               ELSE @te_sep + @te_sep + d.HIPAACode5 + @te_sep + CONVERT(VARCHAR, d.Amount5)
                                                                                                                                                                                                                          END + CASE WHEN d.HIPAACode6 IS NULL
                                                                                                                                                                                                                                          OR d.Amount6 IN ( 0, NULL ) THEN RTRIM('')
                                                                                                                                                                                                                                     ELSE @te_sep + @te_sep + d.HIPAACode6 + @te_sep + CONVERT(VARCHAR, d.Amount6)
                                                                                                                                                                                                                                END ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                            END ,
                            CAS3Segment = CASE WHEN e.HIPAACode1 IS NULL
                                                      OR e.Amount1 IN ( 0, NULL ) THEN NULL
                                                 ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'CAS' + @te_sep + 'OA' + @te_sep + e.HIPAACode1 + @te_sep + CONVERT(VARCHAR, e.Amount1) + CASE WHEN e.HIPAACode2 IS NULL
                                                                                                                                                                                                                  OR e.Amount2 IN ( 0, NULL ) THEN RTRIM('')
                                                                                                                                                                                                             ELSE @te_sep + @te_sep + e.HIPAACode2 + @te_sep + CONVERT(VARCHAR, e.Amount2)
                                                                                                                                                                                                        END + CASE WHEN e.HIPAACode3 IS NULL
                                                                                                                                                                                                                        OR e.Amount3 IN ( 0, NULL ) THEN RTRIM('')
                                                                                                                                                                                                                   ELSE @te_sep + @te_sep + e.HIPAACode3 + @te_sep + CONVERT(VARCHAR, e.Amount3)
                                                                                                                                                                                                              END + CASE WHEN e.HIPAACode4 IS NULL
                                                                                                                                                                                                                              OR e.Amount4 IN ( 0, NULL ) THEN RTRIM('')
                                                                                                                                                                                                                         ELSE @te_sep + @te_sep + e.HIPAACode4 + @te_sep + CONVERT(VARCHAR, e.Amount4)
                                                                                                                                                                                                                    END + CASE WHEN e.HIPAACode5 IS NULL
                                                                                                                                                                                                                                    OR e.Amount5 IN ( 0, NULL ) THEN RTRIM('')
                                                                                                                                                                                                                               ELSE @te_sep + @te_sep + e.HIPAACode5 + @te_sep + CONVERT(VARCHAR, e.Amount5)
                                                                                                                                                                                                                          END + CASE WHEN e.HIPAACode6 IS NULL
                                                                                                                                                                                                                                          OR e.Amount6 IN ( 0, NULL ) THEN RTRIM('')
                                                                                                                                                                                                                                     ELSE @te_sep + @te_sep + e.HIPAACode6 + @te_sep + CONVERT(VARCHAR, e.Amount6)
                                                                                                                                                                                                                                END ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                            END ,
                            CAS4Segment = CASE WHEN f.HIPAACode1 IS NULL
                                                      OR f.Amount1 IN ( 0, NULL ) THEN NULL
                                                 ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'CAS' + @te_sep + 'PI' + @te_sep + f.HIPAACode1 + @te_sep + CONVERT(VARCHAR, f.Amount1) + CASE WHEN f.HIPAACode2 IS NULL
                                                                                                                                                                                                                  OR f.Amount2 IN ( 0, NULL ) THEN RTRIM('')
                                                                                                                                                                                                             ELSE @te_sep + @te_sep + f.HIPAACode2 + @te_sep + CONVERT(VARCHAR, f.Amount2)
                                                                                                                                                                                                        END + CASE WHEN e.HIPAACode3 IS NULL
                                                                                                                                                                                                                        OR f.Amount3 IN ( 0, NULL ) THEN RTRIM('')
                                                                                                                                                                                                                   ELSE @te_sep + @te_sep + f.HIPAACode3 + @te_sep + CONVERT(VARCHAR, f.Amount3)
                                                                                                                                                                                                              END + CASE WHEN e.HIPAACode4 IS NULL
                                                                                                                                                                                                                              OR f.Amount4 IN ( 0, NULL ) THEN RTRIM('')
                                                                                                                                                                                                                         ELSE @te_sep + @te_sep + f.HIPAACode4 + @te_sep + CONVERT(VARCHAR, f.Amount4)
                                                                                                                                                                                                                    END + CASE WHEN f.HIPAACode5 IS NULL
                                                                                                                                                                                                                                    OR f.Amount5 IN ( 0, NULL ) THEN RTRIM('')
                                                                                                                                                                                                                               ELSE @te_sep + @te_sep + f.HIPAACode5 + @te_sep + CONVERT(VARCHAR, f.Amount5)
                                                                                                                                                                                                                          END + CASE WHEN f.HIPAACode6 IS NULL
                                                                                                                                                                                                                                          OR f.Amount6 IN ( 0, NULL ) THEN RTRIM('')
                                                                                                                                                                                                                                     ELSE @te_sep + @te_sep + f.HIPAACode6 + @te_sep + CONVERT(VARCHAR, f.Amount6)
                                                                                                                                                                                                                                END ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                            END ,
                            ServiceAdjudicationDTPSegment = CASE WHEN ISNULL(RTRIM(CONVERT(VARCHAR,b.PaidDate,112)), '') = '' THEN NULL
                                                                   ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'DTP' + @te_sep + '573' + @te_sep + 'D8' + @te_sep + CONVERT(VARCHAR,b.PaidDate,112) ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                              END
                    FROM    #OtherInsured AS b
							JOIN #837Services a ON a.ClaimLineId = b.ClaimLineId
							LEFT JOIN #OtherInsuredAdjustment3 c ON ( b.OtherInsuredId = c.OtherInsuredId
                                                                      AND c.HIPAAGroupCode = 'PR'
                                                                    )
                            LEFT JOIN #OtherInsuredAdjustment3 d ON ( b.OtherInsuredId = d.OtherInsuredId
                                                                      AND d.HIPAAGroupCode = 'CO'
                                                                    )
                            LEFT JOIN #OtherInsuredAdjustment3 e ON ( b.OtherInsuredId = e.OtherInsuredId
                                                                      AND e.HIPAAGroupCode = 'OA'
                                                                    )
                            LEFT JOIN #OtherInsuredAdjustment3 f ON ( b.OtherInsuredId = f.OtherInsuredId
                                                                      AND f.HIPAAGroupCode = 'PI'
                                                                    )   
					WHERE (ISNULL(b.PaidAmount,0) <> 0 
						  OR c.HIPAAGroupCode IS NOT NULL 
						  OR d.HIPAAGroupCode IS NOT NULL 
						  OR e.HIPAAGroupCode IS NOT NULL 
						  OR f.HIPAAGroupCode IS NOT NULL
						  )
	  
	  
	--SELECT * FROM #837OtherInsureds
	
                    IF @@error <> 0
                        GOTO error  
  
-- update segments for #837Services  
                    UPDATE  #837Services
                    SET     SV1Segment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'SV1' + @te_sep + ServiceIdQualifier + @tse_sep + RTRIM(BillingCode) + ( CASE WHEN Modifier1 IS NOT NULL THEN @tse_sep + RTRIM(Modifier1)
                                                                                                                                                                               WHEN Modifier1 IS NULL
                                                                                                                                                                                    AND ISNULL(BillingCodeDescription, '') <> '' THEN @tse_sep
                                                                                                                                                                               ELSE RTRIM('')
                                                                                                                                                                          END ) + ( CASE WHEN Modifier2 IS NOT NULL THEN @tse_sep + RTRIM(Modifier2)
                                                                                                                                                                                         WHEN Modifier2 IS NULL
                                                                                                                                                                                              AND ISNULL(BillingCodeDescription, '') <> '' THEN @tse_sep
                                                                                                                                                                                         ELSE RTRIM('')
                                                                                                                                                                                    END ) + ( CASE WHEN Modifier3 IS NOT NULL THEN @tse_sep + RTRIM(Modifier3)
                                                                                                                                                                                                   WHEN Modifier3 IS NULL
                                                                                                                                                                                                        AND ISNULL(BillingCodeDescription, '') <> '' THEN @tse_sep
                                                                                                                                                                                                   ELSE RTRIM('')
                                                                                                                                                                                              END ) + ( CASE WHEN Modifier4 IS NOT NULL THEN @tse_sep + RTRIM(Modifier4)
                                                                                                                                                                                                             WHEN Modifier4 IS NULL
                                                                                                                                                                                                                  AND ISNULL(BillingCodeDescription, '') <> '' THEN @tse_sep
                                                                                                                                                                                                             ELSE RTRIM('')
                                                                                                                                                                                                        END ) + ( CASE WHEN ISNULL(BillingCodeDescription, '') <> '' THEN @tse_sep + RTRIM(BillingCodeDescription)
                                                                                                                                                                                                                       ELSE RTRIM('')
                                                                                                                                                                                                                  END ) + @te_sep + ( CASE WHEN CONVERT(INT, LineItemChargeAmount * 100) = CONVERT(INT, LineItemChargeAmount) * 100 THEN CONVERT(VARCHAR, CONVERT(INT, LineItemChargeAmount))
                                                                                                                                                                                                                                           ELSE CONVERT(VARCHAR, LineItemChargeAmount)
                                                                                                                                                                                                                                      END ) + @te_sep + UnitOfMeasure + @te_sep + ServiceUnitCount + @te_sep + PlaceOfService + @te_sep + @te_sep + DiagnosisCodePointer1 + ( CASE WHEN DiagnosisCodePointer2 IS NOT NULL THEN @tse_sep + DiagnosisCodePointer2
                                                                                                                                                                                                                                                                                                                                                                                   ELSE RTRIM('')
                                                                                                                                                                                                                                                                                                                                                                              END ) + ( CASE WHEN DiagnosisCodePointer3 IS NOT NULL THEN @tse_sep + DiagnosisCodePointer3
                                                                                                                                                                                                                                                                                                                                                                                             ELSE RTRIM('')
                                                                                                                                                                                                                                                                                                                                                                                        END ) + ( CASE WHEN DiagnosisCodePointer4 IS NOT NULL THEN @tse_sep + DiagnosisCodePointer4
                                                                                                                                                                                                                                                                                                                                                                                                       ELSE RTRIM('')
                                                                                                                                                                                                                                                                                                                                                                                                  END ) + ( CASE WHEN DiagnosisCodePointer5 IS NOT NULL THEN @tse_sep + DiagnosisCodePointer5
                                                                                                                                                                                                                                                                                                                                                                                                                 ELSE RTRIM('')
                                                                                                                                                                                                                                                                                                                                                                                                            END ) + ( CASE WHEN DiagnosisCodePointer6 IS NOT NULL THEN @tse_sep + DiagnosisCodePointer6
                                                                                                                                                                                                                                                                                                                                                                                                                           ELSE RTRIM('')
                                                                                                                                                                                                                                                                                                                                                                                                                      END ) + ( CASE WHEN DiagnosisCodePointer7 IS NOT NULL THEN @tse_sep + DiagnosisCodePointer7
                                                                                                                                                                                                                                                                                                                                                                                                                                     ELSE RTRIM('')
                                                                                                                                                                                                                                                                                                                                                                                                                                END ) + ( CASE WHEN DiagnosisCodePointer8 IS NOT NULL THEN @tse_sep + DiagnosisCodePointer8
                                                                                                                                                                                                                                                                                                                                                                                                                                               ELSE RTRIM('')
                                                                                                                                                                                                                                                                                                                                                                                                                                          END ) + ( CASE WHEN EmergencyIndicator IS NOT NULL THEN @te_sep + @te_sep + EmergencyIndicator  -- 12/05/2016  MJensen 
                                                                                                                                                                                                                                                                                                                                                                                                                                                         ELSE RTRIM('')
                                                                                                                                                                                                                                                                                                                                                                                                                                                    END ) ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                            FacilityNM1Segment = CASE WHEN ISNULL(RTRIM(FacilityAddress1), '') = ''
                                                           OR ISNULL(RTRIM(FacilityCity), '') = ''
                                                           OR ISNULL(RTRIM(FacilityState), '') = ''
                                                           OR ISNULL(RTRIM(FacilityZip), '') = ''
                                                           OR ISNULL(RTRIM(FacilityEntityCode), '') = ''
                                                           OR ISNULL(RTRIM(FacilityName), '') = '' THEN NULL
                                                      ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'NM1' + @te_sep + FacilityEntityCode + @te_sep + '2' + @te_sep + FacilityName + ISNULL(@te_sep + @te_sep + @te_sep + @te_sep + @te_sep + FacilityIdQualifier + @te_sep + FacilityId, '') ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                 END ,
                            FacilityN3Segment = CASE WHEN ISNULL(RTRIM(FacilityAddress1), '') = ''
                                                          OR ISNULL(RTRIM(FacilityCity), '') = ''
                                                          OR ISNULL(RTRIM(FacilityState), '') = ''
                                                          OR ISNULL(RTRIM(FacilityZip), '') = ''
                                                          OR ISNULL(RTRIM(FacilityEntityCode), '') = ''
                                                          OR ISNULL(RTRIM(FacilityName), '') = '' THEN NULL
                                                     ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'N3' + @te_sep + REPLACE(REPLACE(REPLACE(FacilityAddress1, '#', ' '), '.', ' '), '-', ' ') + ( CASE WHEN ISNULL(RTRIM(FacilityAddress2), '') = '' THEN RTRIM('')
                                                                                                                                                                                                                      ELSE @te_sep + REPLACE(REPLACE(REPLACE(FacilityAddress2, '#', ' '), '.', ' '), '-', ' ')
                                                                                                                                                                                                                 END ) ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                END ,
                            FacilityN4Segment = CASE WHEN ISNULL(RTRIM(FacilityAddress1), '') = ''
                                                          OR ISNULL(RTRIM(FacilityCity), '') = ''
                                                          OR ISNULL(RTRIM(FacilityState), '') = ''
                                                          OR ISNULL(RTRIM(FacilityZip), '') = ''
                                                          OR ISNULL(RTRIM(FacilityEntityCode), '') = ''
                                                          OR ISNULL(RTRIM(FacilityName), '') = '' THEN NULL
                                                     ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'N4' + @te_sep + FacilityCity + @te_sep + FacilityState + @te_sep + FacilityZip ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                END ,
                            FacilityRefSegment = CASE WHEN ISNULL(RTRIM(FacilitySecondaryId), '') = '' THEN NULL
                                                      ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'REF' + @te_sep + FacilitySecondaryQualifier + @te_sep + FacilitySecondaryId ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                 END ,
                            ServiceDateDTPSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'DTP' + @te_sep + '472' + @te_sep + ServiceDateQualifier + @te_sep + ServiceDate ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                            LineItemControlRefSegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'REF' + @te_sep + '6R' + @te_sep + LineItemControlNumber ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term ,
                            ApprovedAmountSegment = NULL ,--srf 3/14/2011 set to null per guide  
--case when ApprovedAmount is null then null else  
--UPPER(replace(replace(replace(replace(replace(replace((  
--'AMT' + @te_sep +  'AAE' + @te_sep +  convert(varchar,ApprovedAmount)   
--), @e_sep,''),@se_sep,''),@seg_term,''),'&',''),@te_sep,@e_sep),@tse_sep,@se_sep)) + @seg_term end   
                            ServiceNTESegment = UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'NTE' + @te_sep + ServiceNoteReferenceCode + @te_sep + ServiceNote ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term,
							--tchen added 8/31/2018
							RenderingNM1Segment = CASE WHEN ISNULL(RTRIM(RenderingId), '') = '' THEN NULL
                                                       ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'NM1' + @te_sep + RenderingEntityCode + @te_sep + RenderingEntityQualifier + @te_sep + RenderingLastName + @te_sep + RenderingFirstName + @te_sep + ISNULL(RenderingMiddleName,'') + @te_sep + @te_sep + ISNULL(RenderingSuffix,'') + @te_sep + RenderingIdQualifier + @te_sep + RenderingId ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                  END,
                            RenderingPRVSegment = CASE WHEN ISNULL(RTRIM(RenderingId), '') = '' THEN NULL
                                                       ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'PRV' + @te_sep + 'PE' + @te_sep + 'PXC' + @te_sep + RenderingTaxonomyCode
                                                                                                                    ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                  END, 
                            RenderingRefSegment = CASE WHEN ISNULL(RTRIM(RenderingId), '') = ''
                                                            OR ISNULL(RTRIM(RenderingSecondaryId), '') = '' THEN NULL
                                                       ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'REF' + @te_sep + RenderingSecondaryQualifier + @te_sep + RenderingSecondaryId), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                  END,
							OrderingNM1Segment = CASE WHEN ISNULL(RTRIM(OrderingProviderLastName), '') = '' THEN NULL
													  ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE('NM1' + @te_sep + 'DK' + @te_sep + '1' + @te_sep + OrderingProviderLastName + @te_sep + ISNULL(OrderingProviderFirstName, '') + @te_sep + ISNULL(OrderingProviderMiddleName, '') + @te_sep + @te_sep + ISNULL(OrderingProviderNameSuffix, '') + @te_sep + CASE WHEN NULLIF(OrderingProviderIdentifier, '') IS NOT NULL THEN 'XX' ELSE '' END + @te_sep + ISNULL(OrderingProviderIdentifier, ''), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
												 END,
							OrderingN3Segment = CASE WHEN ISNULL(RTRIM(OrderingProviderAddress1), '') = '' THEN NULL
													 ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'N3' + @te_sep + REPLACE(REPLACE(REPLACE(OrderingProviderAddress1, '#', ' '), '.', ' '), '-', ' ') + ( CASE WHEN ISNULL(RTRIM(OrderingProviderAddress2), '') = '' THEN RTRIM('')
                                                                                                                                                                                                                          ELSE @te_sep + REPLACE(REPLACE(REPLACE(OrderingProviderAddress2, '#', ' '), '.', ' '), '-', ' ')
                                                                                                                                                                                                                     END ) ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
												 END,
							OrderingN4Segment = CASE WHEN ISNULL(RTRIM(OrderingProviderCity), '') = '' THEN NULL
													 ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'N4' + @te_sep + OrderingProviderCity + @te_sep + ISNULL(OrderingProviderState, '') + @te_sep + ISNULL(REPLACE(OrderingProviderZip, '-', ''), '') ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
												 END,
							OrderingREFSegment = CASE WHEN ISNULL(RTRIM(OrderingProviderSecondaryIdentifier), '') = '' THEN NULL
                                                      ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( 'REF' + @te_sep + OrderingProviderSecondaryIdQualifier + @te_sep + OrderingProviderSecondaryIdentifier , @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                 END,
							OrderingPERSegment = CASE WHEN ISNULL(RTRIM(OrderingProviderCommNumber1), '') = '' THEN NULL
                                                      ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'PER' + @te_sep + 'IC' + @te_sep + ISNULL(OrderingProviderContactName, '') + @te_sep + OrderingProviderCommNumberQualifier1 + @te_sep + CASE OrderingProviderCommNumberQualifier1 WHEN 'TE' THEN REPLACE(REPLACE(REPLACE(OrderingProviderCommNumber1, '-', ''), '(',''), ')','') ELSE OrderingProviderCommNumber1 END
																													+ CASE WHEN OrderingProviderCommNumber2 IS NOT NULL THEN @te_sep + OrderingProviderCommNumberQualifier2 + @te_sep + CASE OrderingProviderCommNumberQualifier2 WHEN 'TE' THEN REPLACE(REPLACE(REPLACE(OrderingProviderCommNumber2, '-', ''), '(',''), ')','') ELSE OrderingProviderCommNumber2 END ELSE '' END
																													+ CASE WHEN OrderingProviderCommNumber3 IS NOT NULL THEN @te_sep + OrderingProviderCommNumberQualifier3 + @te_sep + CASE OrderingProviderCommNumberQualifier3 WHEN 'TE' THEN REPLACE(REPLACE(REPLACE(OrderingProviderCommNumber3, '-', ''), '(',''), ')','') ELSE OrderingProviderCommNumber3 END ELSE '' END
																													 ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                                 END
  
                    IF @@error <> 0
                        GOTO error  
  
  
  
--New** Start  
-- update segments for #837DrugIdentification  
                    UPDATE  #837DrugIdentification
                    SET     LINSegment = CASE WHEN NationalDrugCode IS NULL THEN NULL
                                              ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'LIN' + @te_sep + @te_sep + ISNULL(RTRIM(NationalDrugCodeQualifier), RTRIM('')) + @te_sep + ISNULL(RTRIM(NationalDrugCode), RTRIM('')) ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                         END ,
                            CTPSegment = CASE WHEN DrugCodeUnitCount IS NULL THEN NULL
                                              ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(( 'CTP' + @te_sep + @te_sep + @te_sep + ISNULL(RTRIM(DrugUnitPrice), RTRIM('')) + @te_sep + ISNULL(RTRIM(DrugCodeUnitCount), RTRIM('')) + @te_sep + ISNULL(RTRIM(DrugUnitOfMeasure), RTRIM('')) ), @e_sep, ''), @se_sep, ''), @seg_term, ''), '&', ''), @te_sep, @e_sep), @tse_sep, @se_sep)) + @seg_term
                                         END  
  
  
  
--New** End  
  
  --SELECT * FROM #837Services
  
                    EXEC dbo.scsp_PMClaims837UpdateSegments @CurrentUser = @ParamCurrentUser, @ClaimBatchId = @ParamClaimBatchId, @FormatType = @FormatType  
  
                    IF @@error <> 0
                        GOTO error  
  
                    UPDATE  dbo.ClaimBatches
                    SET     BatchProcessProgress = 80
                    WHERE   ClaimBatchId = @ParamClaimBatchId  
  
                    IF @@error <> 0
                        GOTO error  
  
--XXX  
--select * from #837BillingProviders  
--select * from #837SubscriberClients  
--select * from #837Claims  
--select * from #837Services  
--select * from #837OtherInsureds  
--SELECT * FROM #837OtherInsuredsGrouping
  
-- Compute Segments  
-- Segments from Header and Trailer  
                    SELECT  @NumberOfSegments = 6 --srf 3/14/2011 changed from 7 to 6 due to the  TransactionTypeRefSegment being set to null per version 5 guide  
  
  --SELECT * FROM #837HeaderTrailer

-- Segments from Billing Provider  
                    SELECT  @NumberOfSegments = @NumberOfSegments + COUNT(*) -- HL Segment  
                            + ISNULL(SUM(CASE WHEN BillingPRVSegment IS NULL THEN 0
                                              ELSE 1
                                         END) + SUM(CASE WHEN BillingProviderNM1Segment IS NULL THEN 0
                                                         ELSE 1
                                                    END) + SUM(CASE WHEN BillingProviderN3Segment IS NULL THEN 0
                                                                    ELSE 1
                                                               END) + SUM(CASE WHEN BillingProviderN4Segment IS NULL THEN 0
                                                                               ELSE 1
                                                                          END) + SUM(CASE WHEN BillingProviderRefSegment IS NULL THEN 0
                                                                                          ELSE 1
                                                                                     END) + SUM(CASE WHEN BillingProviderRef2Segment IS NULL THEN 0
                                                                                                     ELSE 1
                                                                                                END) + SUM(CASE WHEN BillingProviderRef3Segment IS NULL THEN 0
                                                                                                                ELSE 1
                                                                                                           END) + SUM(CASE WHEN BillingProviderPerSegment IS NULL THEN 0
                                                                                                                           ELSE 1
                                                                                                                      END) + SUM(CASE WHEN PayToProviderNM1Segment IS NULL THEN 0
                                                                                                                                      ELSE 1
                                                                                                                                 END) + SUM(CASE WHEN PayToProviderN3Segment IS NULL THEN 0
                                                                                                                                                 ELSE 1
                                                                                                                                            END) + SUM(CASE WHEN PayToProviderN4Segment IS NULL THEN 0
                                                                                                                                                            ELSE 1
                                                                                                                                                       END) + SUM(CASE WHEN PayToProviderRefSegment IS NULL THEN 0
                                                                                                                                                                       ELSE 1
                                                                                                                                                                  END) + SUM(CASE WHEN PayToProviderRef2Segment IS NULL THEN 0
                                                                                                                                                                                  ELSE 1
                                                                                                                                                                             END) + SUM(CASE WHEN PayToProviderRef3Segment IS NULL THEN 0
                                                                                                                                                                                             ELSE 1
                                                                                                                                                                                        END), 0)
                    FROM    #837BillingProviders  
  
					
  
  --SELECT @NumberOfSegments,* FROM #837BillingProviders

                    IF @@error <> 0
                        GOTO error  
  
-- Segments from Subscriber Patient   
                    SELECT  @NumberOfSegments = @NumberOfSegments + COUNT(*) -- Subsriber HL Segment  
                            + SUM(CASE WHEN SubscriberSegment IS NULL THEN 0
                                       ELSE 1
                                  END) + SUM(CASE WHEN SubscriberPatientSegment IS NULL THEN 0
                                                  ELSE 1
                                             END) + SUM(CASE WHEN SubscriberNM1Segment IS NULL THEN 0
                                                             ELSE 1
                                                        END) + SUM(CASE WHEN SubscriberN3Segment IS NULL THEN 0
                                                                        ELSE 1
                                                                   END) + SUM(CASE WHEN SubscriberN4Segment IS NULL THEN 0
                                                                                   ELSE 1
                                                                              END) + SUM(CASE WHEN SubscriberDMGSegment IS NULL THEN 0
                                                                                              ELSE 1
                                                                                         END) + SUM(CASE WHEN SubscriberRefSegment IS NULL THEN 0
                                                                                                         ELSE 1
                                                                                                    END) + SUM(CASE WHEN PayerNM1Segment IS NULL THEN 0
                                                                                                                    ELSE 1
                                                                                                               END) + SUM(CASE WHEN PayerN3Segment IS NULL THEN 0
                                                                                                                               ELSE 1
                                                                                                                          END) + SUM(CASE WHEN PayerN4Segment IS NULL THEN 0
                                                                                                                                          ELSE 1
                                                                                                                                     END) + SUM(CASE WHEN PayerRefSegment IS NULL THEN 0
                                                                                                                                                     ELSE 1
                                                                                                                                                END) + SUM(CASE WHEN PayerRefG2Segment IS NULL THEN 0
                                                                                                                                                                ELSE 1
                                                                                                                                                           END) + SUM(CASE WHEN PayerRefNFSegment IS NULL THEN 0
                                                                                                                                                                           ELSE 1
                                                                                                                                                                      END) + SUM(CASE WHEN ResponsibleNM1Segment IS NULL THEN 0
                                                                                                                                                                                      ELSE 1
                                                                                                                                                                                 END) + SUM(CASE WHEN ResponsibleN3Segment IS NULL THEN 0
                                                                                                                                                                                                 ELSE 1
                                                                                                                                                                                            END) + SUM(CASE WHEN ResponsibleN4Segment IS NULL THEN 0
                                                                                                                                                                                                            ELSE 1
                                                                                                                                                                                                       END) + SUM(CASE WHEN PatientPatSegment IS NULL THEN 0
                                                                                                                                                                                                                       ELSE 1
                                                                                                                                                                                                                  END) -- Patient HL Segment   
                            + SUM(CASE WHEN PatientPatSegment IS NULL THEN 0
                                       ELSE 1
                                  END) + SUM(CASE WHEN PatientNM1Segment IS NULL THEN 0
                                                  ELSE 1
                                             END) + SUM(CASE WHEN PatientN3Segment IS NULL THEN 0
                                                             ELSE 1
                                                        END) + SUM(CASE WHEN PatientN4Segment IS NULL THEN 0
                                                                        ELSE 1
                                                                   END) + SUM(CASE WHEN PatientDMGSegment IS NULL THEN 0
                                                                                   ELSE 1
                                                                              END)
                    FROM    #837SubscriberClients  
  --SELECT @NumberOfSegments,* FROM #837SubscriberClients
                    IF @@error <> 0
                        GOTO error  
  
-- Segments from Claim  
                    SELECT  @NumberOfSegments = @NumberOfSegments + SUM(CASE WHEN CLMSegment IS NULL THEN 0
                                                                             ELSE 1
                                                                        END) + SUM(CASE WHEN ReferralDateDTPSegment IS NULL THEN 0
                                                                                        ELSE 1
                                                                                   END) + SUM(CASE WHEN AdmissionDateDTPSegment IS NULL THEN 0
                                                                                                   ELSE 1
                                                                                              END) + SUM(CASE WHEN DischargeDateDTPSegment IS NULL THEN 0
                                                                                                              ELSE 1
                                                                                                         END) + SUM(CASE WHEN PatientAmountPaidSegment IS NULL THEN 0
                                                                                                                         ELSE 1
                                                                                                                    END) + SUM(CASE WHEN AuthorizationNumberRefSegment IS NULL THEN 0
                                                                                                                                    ELSE 1
                                                                                                                               END) + SUM(CASE WHEN PayerClaimControlNumberRefSegment IS NULL THEN 0
                                                                                                                                               ELSE 1
                                                                                                                                          END) + SUM(CASE WHEN NTESegment IS NULL THEN 0
                                                                                                                                                          ELSE 1
                                                                                                                                                     END) + SUM(CASE WHEN HISegment IS NULL THEN 0
                                                                                                                                                                     ELSE 1
                                                                                                                                                                END) + SUM(CASE WHEN ReferringNM1Segment IS NULL THEN 0
                                                                                                                                                                                ELSE 1
                                                                                                                                                                           END) + SUM(CASE WHEN ReferringRefSegment IS NULL THEN 0
                                                                                                                                                                                           ELSE 1
                                                                                                                                                                                      END) + SUM(CASE WHEN ReferringRef2Segment IS NULL THEN 0
                                                                                                                                                                                                      ELSE 1
                                                                                                                                                                                                 END) + SUM(CASE WHEN ReferringRef3Segment IS NULL THEN 0
                                                                                                                                                                                                                 ELSE 1
                                                                                                                                                                                                            END) + SUM(CASE WHEN RenderingNM1Segment IS NULL THEN 0
                                                                                                                                                                                                                            ELSE 1
                                                                                                                                                                                                                       END) + SUM(CASE WHEN RenderingPRVSegment IS NULL THEN 0
                                                                                                                                                                                                                                       ELSE 1
                                                                                                                                                                                                                                  END) + SUM(CASE WHEN RenderingRefSegment IS NULL THEN 0
                                                                                                                                                                                                                                                  ELSE 1
                                                                                                                                                                                                                                             END) + SUM(CASE WHEN RenderingRef2Segment IS NULL THEN 0
                                                                                                                                                                                                                                                             ELSE 1
                                                                                                                                                                                                                                                        END) + SUM(CASE WHEN RenderingRef3Segment IS NULL THEN 0
                                                                                                                                                                                                                                                                        ELSE 1
                                                                                                                                                                                                                                                                   END) + SUM(CASE WHEN FacilityNM1Segment IS NULL THEN 0
                                                                                                                                                                                                                                                                                   ELSE 1
                                                                                                                                                                                                                                                                              END) + SUM(CASE WHEN FacilityN3Segment IS NULL THEN 0
                                                                                                                                                                                                                                                                                              ELSE 1
                                                                                                                                                                                                                                                                                         END) + SUM(CASE WHEN FacilityN4Segment IS NULL THEN 0
                                                                                                                                                                                                                                                                                                         ELSE 1
                                                                                                                                                                                                                                                                                                    END) + SUM(CASE WHEN FacilityRefSegment IS NULL THEN 0
                                                                                                                                                                                                                                                                                                                    ELSE 1
                                                                                                                                                                                                                                                                                                               END) + SUM(CASE WHEN FacilityRef2Segment IS NULL THEN 0
                                                                                                                                                                                                                                                                                                                               ELSE 1
                                                                                                                                                                                                                                                                                                                          END) + SUM(CASE WHEN FacilityRef3Segment IS NULL THEN 0
                                                                                                                                                                                                                                                                                                                                          ELSE 1
                                                                                                                                                                                                                                                                                                                                     END) + SUM(CASE WHEN CLIANumberRefSegment IS NULL THEN 0
                                                                                                                                                                                                                                                                                                                                                     ELSE 1
                                                                                                                                                                                                                                                                                                                                                END) + SUM(CASE WHEN MedicalRecordNumberRefSegment IS NULL THEN 0
                                                                                                                                                                                                                                                                                                                                                                ELSE 1
                                                                                                                                                                                                                                                                                                                                                           END) + SUM(CASE WHEN Supervising2310DNM1Segment IS NULL THEN 0
                                                                                                                                                                                                                                                                                                                                                                           ELSE 1
                                                                                                                                                                                                                                                                                                                                                                      END) + SUM(CASE WHEN Supervising2310DREF1Segment IS NULL THEN 0
                                                                                                                                                                                                                                                                                                                                                                                      ELSE 1
                                                                                                                                                                                                                                                                                                                                                                                 END) + SUM(CASE WHEN Supervising2310DREF2Segment IS NULL THEN 0
                                                                                                                                                                                                                                                                                                                                                                                                 ELSE 1
                                                                                                                                                                                                                                                                                                                                                                                            END) + SUM(CASE WHEN Supervising2310DREF3Segment IS NULL THEN 0
                                                                                                                                                                                                                                                                                                                                                                                                            ELSE 1
                                                                                                                                                                                                                                                                                                                                                                                                       END) + SUM(CASE WHEN Supervising2310DREF4Segment IS NULL THEN 0
                                                                                                                                                                                                                                                                                                                                                                                                                       ELSE 1
                                                                                                                                                                                                                                                                                                                                                                                                                  END)
                    FROM    #837Claims  
  --SELECT @NumberOfSegments,* FROM #837Claims
                    IF @@error <> 0
                        GOTO error  
  
-- Segments from Other Insured  
                    SELECT  @NumberOfSegments = @NumberOfSegments + ISNULL(SUM(CASE WHEN SubscriberSegment IS NULL THEN 0
                                                                                    ELSE 1
                                                                               END) + SUM(CASE WHEN PayerPaidAmountSegment IS NULL THEN 0
                                                                                               ELSE 1
                                                                                          END) + SUM(CASE WHEN PayerAllowedAmountSegment IS NULL THEN 0
                                                                                                          ELSE 1
                                                                                                     END) + SUM(CASE WHEN PatientResponsbilityAmountSegment IS NULL THEN 0
                                                                                                                     ELSE 1
                                                                                                                END) + SUM(CASE WHEN DMGSegment IS NULL THEN 0
                                                                                                                                ELSE 1
                                                                                                                           END) + SUM(CASE WHEN OISegment IS NULL THEN 0
                                                                                                                                           ELSE 1
                                                                                                                                      END) + SUM(CASE WHEN OINM1Segment IS NULL THEN 0
                                                                                                                                                      ELSE 1
                                                                                                                                                 END) + SUM(CASE WHEN OIN3Segment IS NULL THEN 0
                                                                                                                                                                 ELSE 1
                                                                                                                                                            END) + SUM(CASE WHEN OIN4Segment IS NULL THEN 0
                                                                                                                                                                            ELSE 1
                                                                                                                                                                       END) + SUM(CASE WHEN OIRefSegment IS NULL THEN 0
                                                                                                                                                                                       ELSE 1
                                                                                                                                                                                  END) + SUM(CASE WHEN PayerNM1Segment IS NULL THEN 0
                                                                                                                                                                                                  ELSE 1
                                                                                                                                                                                             END) 
																																															 + SUM(CASE WHEN PayerN3Segment IS NULL THEN 0
                                                                                                                                                                                                  ELSE 1
                                                                                                                                                                                             END) + SUM(CASE WHEN PayerN4Segment IS NULL THEN 0
                                                                                                                                                                                                  ELSE 1
                                                                                                                                                                                             END) + SUM(CASE WHEN PayerPaymentDTPSegment IS NULL THEN 0
                                                                                                                                                                                                             ELSE 1
                                                                                                                                                                                                        END) + SUM(CASE WHEN PayerRefSegment IS NULL THEN 0
                                                                                                                                                                                                                        ELSE 1
                                                                                                                                                                                                                   END) --srf 1/19/2012 added PayerRefSegment  
                                                                           + SUM(CASE WHEN AuthorizationNumberRefSegment IS NULL THEN 0
                                                                                      ELSE 1
                                                                                 END), 0)
                    FROM    #837OtherInsureds
  --SELECT @NumberOfSegments,* FROM #837OtherInsureds
  

                    IF @@error <> 0
                        GOTO error  
  
-- Segments from Service  
                    SELECT  @NumberOfSegments = @NumberOfSegments + COUNT(*) -- LX segment  
                            + SUM(CASE WHEN SV1Segment IS NULL THEN 0
                                       ELSE 1
                                  END) + SUM(CASE WHEN ServiceDateDTPSegment IS NULL THEN 0
                                                  ELSE 1
                                             END) + SUM(CASE WHEN K3Segment IS NULL THEN 0
                                                             ELSE 1
                                                        END) + SUM(CASE WHEN ReferralDateDTPSegment IS NULL THEN 0
                                                                        ELSE 1
                                                                   END) + SUM(CASE WHEN LineItemControlRefSegment IS NULL THEN 0
                                                                                   ELSE 1
                                                                              END) + SUM(CASE WHEN ProviderAuthorizationRefSegment IS NULL THEN 0
                                                                                              ELSE 1
                                                                                         END) + SUM(CASE WHEN FacilityNM1Segment IS NULL THEN 0
                                                                                                         ELSE 1
                                                                                                    END) + SUM(CASE WHEN FacilityN3Segment IS NULL THEN 0
                                                                                                                    ELSE 1
                                                                                                               END) + SUM(CASE WHEN FacilityN4Segment IS NULL THEN 0
                                                                                                                               ELSE 1
                                                                                                                          END) + SUM(CASE WHEN FacilityRefSegment IS NULL THEN 0
                                                                                                                                          ELSE 1
                                                                                                                                     END) + SUM(CASE WHEN SupervisorNM1Segment IS NULL THEN 0
                                                                                                                                                     ELSE 1
                                                                                                                                                END) + SUM(CASE WHEN ReferringNM1Segment IS NULL THEN 0
                                                                                                                                                                ELSE 1
                                                                                                                                                           END) + SUM(CASE WHEN PayerNM1Segment IS NULL THEN 0
                                                                                                                                                                           ELSE 1
                                                                                                                                                                      END) + SUM(CASE WHEN ApprovedAmountSegment IS NULL THEN 0
                                                                                                                                                                                      ELSE 1
                                                                                                                                                                                 END) + SUM(CASE WHEN ServiceNTESegment IS NULL THEN 0
                                                                                                                                                                                                 ELSE 1
                                                                                                                                                                                            END) + SUM(CASE WHEN ContractInformationSegment IS NULL THEN 0
                                                                                                                                                                                                            ELSE 1
                                                                                                                                                                                                       END)
																																																	   + SUM(CASE WHEN RenderingNM1Segment IS NULL THEN 0
                                                                                                                                                                                                            ELSE 1
                                                                                                                                                                                                       END)
																																																		   + SUM(CASE WHEN RenderingPRVSegment IS NULL THEN 0
																																																				ELSE 1
																																																		   END)
																																																			   + SUM(CASE WHEN RenderingRefSegment IS NULL THEN 0
																																																					ELSE 1
																																																			   END)
																																																				+ SUM(CASE WHEN OrderingNM1Segment IS NULL THEN 0
                                                                                                                                                                                                            ELSE 1
                                                                                                                                                                                                       END)
																																																	   + SUM(CASE WHEN OrderingN3Segment IS NULL THEN 0
                                                                                                                                                                                                            ELSE 1
                                                                                                                                                                                                       END)
																																																	   + SUM(CASE WHEN OrderingN4Segment IS NULL THEN 0
                                                                                                                                                                                                            ELSE 1
                                                                                                                                                                                                       END)
																																																	   + SUM(CASE WHEN OrderingREFSegment IS NULL THEN 0
                                                                                                                                                                                                            ELSE 1
                                                                                                                                                                                                       END)
																																																	   + SUM(CASE WHEN OrderingPERSegment IS NULL THEN 0
                                                                                                                                                                                                            ELSE 1
                                                                                                                                                                                                       END)
                    FROM    #837Services  
  --SELECT @NumberOfSegments,* FROM #837Services
                    IF @@error <> 0
                        GOTO error  
  
-- Segments from Other Insured for Adjustments  
                    SELECT  @NumberOfSegments = @NumberOfSegments + ISNULL(SUM(CASE WHEN SVDSegment IS NULL THEN 0
                                                                                    ELSE 1
                                                                               END) + SUM(CASE WHEN CAS1Segment IS NULL THEN 0
                                                                                               ELSE 1
                                                                                          END) + SUM(CASE WHEN CAS2Segment IS NULL THEN 0
                                                                                                          ELSE 1
                                                                                                     END) + SUM(CASE WHEN CAS3Segment IS NULL THEN 0
                                                                                                                     ELSE 1
                                                                                                                END) + SUM(CASE WHEN CAS4Segment IS NULL THEN 0
                                                                                                                                ELSE 1
                                                                                                                           END) + SUM(CASE WHEN ServiceAdjudicationDTPSegment IS NULL THEN 0
                                                                                                                                           ELSE 1
                                                                                                                                      END), 0)
                    FROM    #837OtherInsuredClaimLines  
  --SELECT @NumberOfSegments,* FROM #837OtherInsureds
                    IF @@error <> 0
                        GOTO error  
  
  
--NEW** segments for #837DrugIdentification  
                    SELECT  @NumberOfSegments = @NumberOfSegments + ISNULL(SUM(CASE WHEN LINSegment IS NULL THEN 0
                                                                                    ELSE 1
                                                                               END) + SUM(CASE WHEN CTPSegment IS NULL THEN 0
                                                                                               ELSE 1
                                                                                          END), 0)
                    FROM    #837DrugIdentification  
  --SELECT @NumberOfSegments,* FROM #837DrugIdentification
                    IF @@error <> 0
                        GOTO error  
  
--NEW** End  
  --SELECT * FROM #837OtherInsureds
                    IF EXISTS ( SELECT  1
                                FROM    #837Claims
                                WHERE   ToVoidClaimLineItemGroupId IS NOT NULL )
                        SELECT  @NumberOfSegments = @NumberOfSegments + SUM(cligsd.SegmentCount - 2) -- -2 for LX segment from services and REF*6R segment which is generated but not included in the claim when voiding.
                        FROM    #837Claims AS c
                                JOIN dbo.ClaimLineItemGroupStoredData AS cligsd ON c.ToVoidClaimLineItemGroupId = cligsd.ClaimLineItemGroupId
                        WHERE   c.ToVoidClaimLineItemGroupId IS NOT NULL
					
  
  
-- Generate File  
                    SELECT  @HierId = 0  
  
                    IF @@error <> 0
                        GOTO error  
  
-- Interchange and Functional Header  
                    SELECT  @seg1 = InterchangeHeaderSegment ,
                            @seg2 = FunctionalHeaderSegment ,
                            @FunctionalTrailer = FunctionalTrailerSegment ,
                            @InterchangeTrailer = InterchangeTrailerSegment
                    FROM    #HIPAAHeaderTrailer  
  
                    IF @@error <> 0
                        GOTO error  
  
                    DELETE  FROM #FinalData  
  
                    IF @@error <> 0
                        GOTO error  
  
                    INSERT  INTO #FinalData
                    VALUES  ( RTRIM(@seg1) )  
  
  
                    IF @@error <> 0
                        GOTO error  
  
                    SELECT  @TextPointer = TEXTPTR(DataText)
                    FROM    #FinalData  
  
                    IF @@error <> 0
                        GOTO error  
  
                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg2  
  
                    IF @@error <> 0
                        GOTO error  
  
-- Transaction Header  
                    SELECT  @seg1 = NULL ,
                            @seg2 = NULL ,
                            @seg3 = NULL ,
                            @seg4 = NULL ,
                            @seg5 = NULL ,
                            @seg6 = NULL ,
                            @seg7 = NULL ,
                            @seg8 = NULL ,
                            @seg9 = NULL ,
                            @seg10 = NULL ,
                            @seg11 = NULL ,
                            @seg12 = NULL ,
                            @seg13 = NULL ,
                            @seg14 = NULL ,
                            @seg15 = NULL ,
                            @seg16 = NULL ,
                            @seg17 = NULL ,
                            @seg18 = NULL ,
                            @seg19 = NULL ,
                            @seg20 = NULL ,
                            @seg21 = NULL ,
                            @seg22 = NULL ,
                            @seg23 = NULL  
  
                    IF @@error <> 0
                        GOTO error  
  
                    SELECT  @seg1 = STSegment ,
                            @seg2 = BHTSegment ,
                            @seg3 = TransactionTypeRefSegment ,
                            @seg4 = SubmitterNM1Segment ,
                            @seg5 = SubmitterPerSegment ,
                            @seg6 = ReceiverNm1Segment ,
                            @TransactionTrailer = ( 'SE' + @e_sep + CONVERT(VARCHAR, @NumberOfSegments) + @e_sep + TransactionSetControlNumberHeader + @seg_term )
                    FROM    #837HeaderTrailer  
  

  
  
                    IF @@error <> 0
                        GOTO error  
  
                    EXEC dbo.ssp_PM837StringFilter @seg1, @e_sep, @se_sep, @seg_term, @seg1 OUTPUT  
                    EXEC dbo.ssp_PM837StringFilter @seg2, @e_sep, @se_sep, @seg_term, @seg2 OUTPUT  
                    EXEC dbo.ssp_PM837StringFilter @seg3, @e_sep, @se_sep, @seg_term, @seg3 OUTPUT  
                    EXEC dbo.ssp_PM837StringFilter @seg4, @e_sep, @se_sep, @seg_term, @seg4 OUTPUT  
                    EXEC dbo.ssp_PM837StringFilter @seg5, @e_sep, @se_sep, @seg_term, @seg5 OUTPUT  
                    EXEC dbo.ssp_PM837StringFilter @seg6, @e_sep, @se_sep, @seg_term, @seg6 OUTPUT  
  
                    IF @@error <> 0
                        GOTO error  
  
                    IF ( @seg1 IS NOT NULL )
                        UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg1  
                    IF ( @seg2 IS NOT NULL )
                        UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg2  
                    IF ( @seg3 IS NOT NULL )
                        UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg3  
                    IF ( @seg4 IS NOT NULL )
                        UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg4  
                    IF ( @seg5 IS NOT NULL )
                        UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg5  
                    IF ( @seg6 IS NOT NULL )
                        UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg6  
  
                    IF @@error <> 0
                        GOTO error  
  
-- Billing PRovider  
                    SELECT  @seg1 = NULL ,
                            @seg2 = NULL ,
                            @seg3 = NULL ,
                            @seg4 = NULL ,
                            @seg5 = NULL ,
                            @seg6 = NULL ,
                            @seg7 = NULL ,
                            @seg8 = NULL ,
                            @seg9 = NULL ,
                            @seg10 = NULL ,
                            @seg11 = NULL ,
                            @seg12 = NULL ,
                            @seg13 = NULL ,
                            @seg14 = NULL ,
                            @seg15 = NULL ,
                            @seg16 = NULL ,
                            @seg17 = NULL ,
                            @seg18 = NULL ,
                            @seg19 = NULL ,
                            @seg20 = NULL ,
                            @seg21 = NULL ,
                            @seg22 = NULL ,
                            @seg23 = NULL  
  
                    IF @@error <> 0
                        GOTO error  
  
                    DECLARE cur_Provider CURSOR
                    FOR
                        SELECT  UniqueId ,
                                BillingPRVSegment ,
                                BillingProviderNM1Segment ,
                                BillingProviderN3Segment ,
                                BillingProviderN4Segment ,
                                BillingProviderRefSegment ,
                                BillingProviderRef2Segment ,
                                BillingProviderRef3Segment ,
                                BillingProviderPerSegment ,
                                PayToProviderNM1Segment ,
                                PayToProviderN3Segment ,
                                PayToProviderN4Segment ,
                                PayToProviderRefSegment ,
                                PayToProviderRef2Segment ,
                                PayToProviderRef3Segment
                        FROM    #837BillingProviders   
  
                    IF @@error <> 0
                        GOTO error  
  
                    OPEN cur_Provider   
  
                    IF @@error <> 0
                        GOTO error  
  
                    FETCH cur_Provider INTO @ProviderLoopId, @seg1, @seg2, @seg3, @seg4, @seg5, @seg6, @seg7, @seg8, @seg9, @seg10, @seg11, @seg13, @seg14, @seg15
  
                    IF @@error <> 0
                        GOTO error  
  
                    WHILE @@fetch_status = 0
                        BEGIN  
  
-- Increment Hierarchical ID  
                            SELECT  @HierId = @HierId + 1  
                            SELECT  @ProviderHierId = @HierId  
   
                            IF @@error <> 0
                                GOTO error  
  
-- HL Segment   
                            SELECT  @seg12 = 'HL' + @e_sep + CONVERT(VARCHAR, @ProviderHierId) + @e_sep + @e_sep + '20' + @e_sep + '1' + @seg_term  
  
  
                            IF @@error <> 0
                                GOTO error  
  
                            EXEC dbo.ssp_PM837StringFilter @seg1, @e_sep, @se_sep, @seg_term, @seg1 OUTPUT  
                            EXEC dbo.ssp_PM837StringFilter @seg2, @e_sep, @se_sep, @seg_term, @seg2 OUTPUT  
                            EXEC dbo.ssp_PM837StringFilter @seg3, @e_sep, @se_sep, @seg_term, @seg3 OUTPUT  
                            EXEC dbo.ssp_PM837StringFilter @seg4, @e_sep, @se_sep, @seg_term, @seg4 OUTPUT  
                            EXEC dbo.ssp_PM837StringFilter @seg5, @e_sep, @se_sep, @seg_term, @seg5 OUTPUT  
                            EXEC dbo.ssp_PM837StringFilter @seg6, @e_sep, @se_sep, @seg_term, @seg6 OUTPUT  
                            EXEC dbo.ssp_PM837StringFilter @seg7, @e_sep, @se_sep, @seg_term, @seg7 OUTPUT  
                            EXEC dbo.ssp_PM837StringFilter @seg8, @e_sep, @se_sep, @seg_term, @seg8 OUTPUT  
                            EXEC dbo.ssp_PM837StringFilter @seg9, @e_sep, @se_sep, @seg_term, @seg9 OUTPUT  
                            EXEC dbo.ssp_PM837StringFilter @seg10, @e_sep, @se_sep, @seg_term, @seg10 OUTPUT  
                            EXEC dbo.ssp_PM837StringFilter @seg11, @e_sep, @se_sep, @seg_term, @seg11 OUTPUT  
                            EXEC dbo.ssp_PM837StringFilter @seg13, @e_sep, @se_sep, @seg_term, @seg13 OUTPUT  
                            EXEC dbo.ssp_PM837StringFilter @seg14, @e_sep, @se_sep, @seg_term, @seg14 OUTPUT
                            EXEC dbo.ssp_PM837StringFilter @seg15, @e_sep, @se_sep, @seg_term, @seg15 OUTPUT 
                            
  
                            IF @@error <> 0
                                GOTO error  
  
                            IF ( @seg12 IS NOT NULL )
                                UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg12  
                            IF ( @seg1 IS NOT NULL )
                                UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg1  
                            IF ( @seg2 IS NOT NULL )
                                UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg2  
                            IF ( @seg3 IS NOT NULL )
                                UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg3  
                            IF ( @seg4 IS NOT NULL )
                                UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg4  
                            IF ( @seg5 IS NOT NULL )
                                UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg5  
                            IF ( @seg6 IS NOT NULL )
                                UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg6  
                            IF ( @seg7 IS NOT NULL )
                                UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg7  
                            IF ( @seg8 IS NOT NULL )
                                UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg8  
                            IF ( @seg9 IS NOT NULL )
                                UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg9  
                            IF ( @seg10 IS NOT NULL )
                                UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg10  
                            IF ( @seg11 IS NOT NULL )
                                UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg11  
                            IF ( @seg13 IS NOT NULL )
                                UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg13  
                            IF ( @seg14 IS NOT NULL )
                                UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg14 
                            IF ( @seg15 IS NOT NULL )
                                UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg15
                            
  
                            IF @@error <> 0
                                GOTO error  
  
-- Loop to get subscriber  
                            DECLARE cur_Subscriber CURSOR
                            FOR
                                SELECT  UniqueId ,
                                        SubscriberSegment ,	       --1
                                        SubscriberPatientSegment , --2
                                        SubscriberNM1Segment ,     --3
                                        SubscriberN3Segment ,      --4 
                                        SubscriberN4Segment ,      --5
                                        SubscriberDMGSegment ,     --6
                                        SubscriberRefSegment ,     --7
                                        PayerNM1Segment ,          --8
                                        PayerN3Segment ,           --9
                                        PayerN4Segment ,           --10
                                        PayerRefSegment ,          --11
                                        PayerRefNFSegment ,        --12
                                        PayerRefG2Segment ,        --13
																   --20 (Patient HL)
                                        PatientPatSegment ,        --14
                                        PatientNM1Segment ,        --15
                                        PatientN3Segment ,         --16
                                        PatientN4Segment ,         --17
                                        PatientDMGSegment          --18
                                FROM    #837SubscriberClients
                                WHERE   RefBillingProviderId = @ProviderLoopId   
  
                            IF @@error <> 0
                                GOTO error  
  
                            OPEN cur_Subscriber  
  
                            IF @@error <> 0
                                GOTO error  
  
                            FETCH cur_Subscriber INTO @SubscriberLoopId, @seg1, @seg2, @seg3, @seg4, @seg5, @seg6, @seg7, @seg8, @seg9, @seg10, @seg11, @seg12, @seg13, @seg14, @seg15, @seg16, @seg17, @seg18
  
                            IF @@error <> 0
                                GOTO error  
  
                            WHILE @@fetch_status = 0
                                BEGIN  
  
-- Increment Hierarchical ID  
                                    SELECT  @HierId = @HierId + 1  
   
                                    IF @@error <> 0
                                        GOTO error  
  
-- HL Segment for Subsriber Loop  
                                    SELECT  @seg19 = 'HL' + @e_sep + CONVERT(VARCHAR, @HierId) + @e_sep + CONVERT(VARCHAR, @ProviderHierId) + @e_sep + '22' + @e_sep + ( CASE WHEN @seg14 IS NULL THEN '0'
                                                                                                                                                                              ELSE '1'
                                                                                                                                                                         END ) + @seg_term  
  
                                    IF @@error <> 0
                                        GOTO error  
  
-- HL Segment for Patient Loop  
                                    IF @seg14 IS NOT NULL
                                        BEGIN   
                                            SELECT  @HierId = @HierId + 1  
  
                                            IF @@error <> 0
                                                GOTO error  
  
                                            SELECT  @seg20 = 'HL' + @e_sep + CONVERT(VARCHAR, @HierId) + @e_sep + CONVERT(VARCHAR, @HierId - 1) + @e_sep + '23' + @e_sep + '0' + @seg_term  
  
                                            IF @@error <> 0
                                                GOTO error  
  
                                        END  
  
  
                                    EXEC dbo.ssp_PM837StringFilter @seg1, @e_sep, @se_sep, @seg_term, @seg1 OUTPUT  
                                    EXEC dbo.ssp_PM837StringFilter @seg2, @e_sep, @se_sep, @seg_term, @seg2 OUTPUT  
                                    EXEC dbo.ssp_PM837StringFilter @seg3, @e_sep, @se_sep, @seg_term, @seg3 OUTPUT  
                                    EXEC dbo.ssp_PM837StringFilter @seg4, @e_sep, @se_sep, @seg_term, @seg4 OUTPUT  
                                    EXEC dbo.ssp_PM837StringFilter @seg5, @e_sep, @se_sep, @seg_term, @seg5 OUTPUT  
                                    EXEC dbo.ssp_PM837StringFilter @seg6, @e_sep, @se_sep, @seg_term, @seg6 OUTPUT  
                                    EXEC dbo.ssp_PM837StringFilter @seg7, @e_sep, @se_sep, @seg_term, @seg7 OUTPUT  
                                    EXEC dbo.ssp_PM837StringFilter @seg8, @e_sep, @se_sep, @seg_term, @seg8 OUTPUT  
                                    EXEC dbo.ssp_PM837StringFilter @seg9, @e_sep, @se_sep, @seg_term, @seg9 OUTPUT  
                                    EXEC dbo.ssp_PM837StringFilter @seg10, @e_sep, @se_sep, @seg_term, @seg10 OUTPUT  
                                    EXEC dbo.ssp_PM837StringFilter @seg11, @e_sep, @se_sep, @seg_term, @seg11 OUTPUT  
                                    EXEC dbo.ssp_PM837StringFilter @seg12, @e_sep, @se_sep, @seg_term, @seg12 OUTPUT  
                                    EXEC dbo.ssp_PM837StringFilter @seg13, @e_sep, @se_sep, @seg_term, @seg13 OUTPUT  
                                    EXEC dbo.ssp_PM837StringFilter @seg14, @e_sep, @se_sep, @seg_term, @seg14 OUTPUT  
                                    EXEC dbo.ssp_PM837StringFilter @seg15, @e_sep, @se_sep, @seg_term, @seg15 OUTPUT  
                                    EXEC dbo.ssp_PM837StringFilter @seg16, @e_sep, @se_sep, @seg_term, @seg16 OUTPUT  
                                    EXEC dbo.ssp_PM837StringFilter @seg17, @e_sep, @se_sep, @seg_term, @seg17 OUTPUT  
                                    EXEC dbo.ssp_PM837StringFilter @seg18, @e_sep, @se_sep, @seg_term, @seg18 OUTPUT  
                                    EXEC dbo.ssp_PM837StringFilter @seg19, @e_sep, @se_sep, @seg_term, @seg19 OUTPUT 
                                    EXEC dbo.ssp_PM837StringFilter @seg20, @e_sep, @se_sep, @seg_term, @seg20 OUTPUT                                  

                                    IF @@error <> 0
                                        GOTO error  
  
                                    IF ( @seg19 IS NOT NULL )
                                        UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg19  
									-- Subscriber Section
                                    IF ( @seg1 IS NOT NULL )
                                        UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg1  
                                    IF ( @seg2 IS NOT NULL )
                                        UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg2  
                                    IF ( @seg3 IS NOT NULL )
                                        UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg3  
                                    IF ( @seg4 IS NOT NULL )
                                        UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg4  
                                    IF ( @seg5 IS NOT NULL )
                                        UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg5  
                                    IF ( @seg6 IS NOT NULL )
                                        UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg6  
                                    IF ( @seg7 IS NOT NULL )
                                        UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg7  
                                    IF ( @seg8 IS NOT NULL )
                                        UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg8  
                                    IF ( @seg9 IS NOT NULL )
                                        UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg9  
                                    IF ( @seg10 IS NOT NULL )
                                        UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg10  
                                    IF ( @seg11 IS NOT NULL )
                                        UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg11  
                                    IF ( @seg12 IS NOT NULL )
                                        UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg12  
                                    IF ( @seg13 IS NOT NULL )
                                        UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg13  

                                    IF ( @seg20 IS NOT NULL )
                                        UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg20  
									-- Patient Section
                                    IF ( @seg14 IS NOT NULL )
                                        UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg14  
                                    IF ( @seg15 IS NOT NULL )
                                        UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg15  
                                    IF ( @seg16 IS NOT NULL )
                                        UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg16  
                                    IF ( @seg17 IS NOT NULL )
                                        UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg17  
                                    IF ( @seg18 IS NOT NULL )
                                        UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg18 
  
                                    IF @@error <> 0
                                        GOTO error  
-- Loop to get Claim  
-- if @VoidClaimLineItemGroupId is not null use new void logic for everything past here.
                                    DECLARE cur_Claim CURSOR
                                    FOR
                                        SELECT  UniqueId ,
                                                ToVoidClaimLineItemGroupId ,
                                                ClaimLineItemGroupId ,
                                                CLMSegment ,
                                                ReferralDateDTPSegment ,
                                                AdmissionDateDTPSegment ,
                                                DischargeDateDTPSegment ,
                                                PatientAmountPaidSegment ,
                                                AuthorizationNumberRefSegment ,
                                                PayerClaimControlNumberRefSegment ,
                                                CLIANumberRefSegment ,
                                                NTESegment ,
                                                MedicalRecordNumberRefSegment ,
                                                HISegment ,
                                                ReferringNM1Segment ,
                                                ReferringRefSegment ,
                                                ReferringRef2Segment ,
                                                ReferringRef3Segment ,
                                                RenderingNM1Segment ,
                                                RenderingPRVSegment ,
                                                RenderingRefSegment ,
                                                RenderingRef2Segment ,
                                                RenderingRef3Segment ,
                                                FacilityNM1Segment ,
                                                FacilityN3Segment ,
                                                FacilityN4Segment ,
                                                FacilityRefSegment ,
                                                FacilityRef2Segment ,
                                                FacilityRef3Segment ,
                                                Supervising2310DNM1Segment ,
                                                Supervising2310DREF1Segment ,
                                                Supervising2310DREF2Segment ,
                                                Supervising2310DREF3Segment ,
                                                Supervising2310DREF4Segment
                                        FROM    #837Claims
                                        WHERE   RefSubscriberClientId = @SubscriberLoopId   
  
                                    IF @@error <> 0
                                        GOTO error  
  
                                    OPEN cur_Claim  
  
                                    IF @@error <> 0
                                        GOTO error  
  
                                    FETCH cur_Claim INTO @ClaimLoopId, @ToVoidClaimLineItemGroupId, @ClaimLineItemGroupId, @seg1, @seg2, @seg3, @seg4, @seg5, @seg6, @seg7, @seg8, @seg9, @seg10, @seg11, @seg12, @seg13, @seg14, @seg15, @seg16, @seg17, @seg18, @seg19, @seg20, @seg21, @seg22, @seg23, @seg24, @seg25, @seg26, @seg27, @seg28, @seg29, @seg30, @seg31
  
                                    IF @@error <> 0
                                        GOTO error  
  
                                    WHILE @@fetch_status = 0
                                        BEGIN  

											-- for voids, perform the following instead.
											-- We need to replace the segments

                                            IF @ToVoidClaimLineItemGroupId IS NOT NULL
                                                BEGIN
                                                    SET @PrePayerClaimControlNumberClaimData = NULL
                                                    SET @PostPayerClaimControlNumberClaimData = NULL

                                                    SELECT  @PrePayerClaimControlNumberClaimData = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(cligsd.PrePayerClaimControlNumberClaimData, cligsd.SubElementSeperator, @tse_sep), cligsd.ElementSeperator, @te_sep), cligsd.SegmentTerminator, @tseg_term), @seg_term, ''), @e_sep, ''), @se_sep, ''), @te_sep, @e_sep), @tse_sep, @se_sep), @tseg_term, @seg_term) ,
                                                            @PostPayerClaimControlNumberClaimData = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(cligsd.PostPayerClaimControlNumberClaimData, cligsd.SubElementSeperator, @tse_sep), cligsd.ElementSeperator, @te_sep), cligsd.SegmentTerminator, @tseg_term), @seg_term, ''), @e_sep, ''), @se_sep, ''), @te_sep, @e_sep), @tse_sep, @se_sep), @tseg_term, @seg_term)
                                                    FROM    dbo.ClaimLineItemGroupStoredData AS cligsd
                                                    WHERE   cligsd.ClaimLineItemGroupId = @ToVoidClaimLineItemGroupId

                                                    SELECT  @PrePayerClaimControlNumberClaimData = REPLACE(REPLACE(@PrePayerClaimControlNumberClaimData, @se_sep + '1' + @e_sep, @se_sep + '8' + @e_sep), @se_sep + '7' + @e_sep, @se_sep + '8' + @e_sep)
																										
                                                    EXEC dbo.ssp_PM837StringFilter @seg7, @e_sep, @se_sep, @seg_term, @seg7 OUTPUT  

                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @PrePayerClaimControlNumberClaimData
													
                                                    IF ( @seg7 IS NOT NULL )
                                                        UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg7  

                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @PostPayerClaimControlNumberClaimData


                                                END
                                            ELSE
                                                BEGIN
											
											-- claim (don't need to split further)
                                                    EXEC dbo.ssp_PM837StringFilter @seg1, @e_sep, @se_sep, @seg_term, @seg1 OUTPUT  
                                                    EXEC dbo.ssp_PM837StringFilter @seg2, @e_sep, @se_sep, @seg_term, @seg2 OUTPUT  
                                                    EXEC dbo.ssp_PM837StringFilter @seg3, @e_sep, @se_sep, @seg_term, @seg3 OUTPUT  
                                                    EXEC dbo.ssp_PM837StringFilter @seg4, @e_sep, @se_sep, @seg_term, @seg4 OUTPUT  
                                                    EXEC dbo.ssp_PM837StringFilter @seg5, @e_sep, @se_sep, @seg_term, @seg5 OUTPUT  
                                                    EXEC dbo.ssp_PM837StringFilter @seg6, @e_sep, @se_sep, @seg_term, @seg6 OUTPUT  
                                                    EXEC dbo.ssp_PM837StringFilter @seg7, @e_sep, @se_sep, @seg_term, @seg7 OUTPUT  
                                                    EXEC dbo.ssp_PM837StringFilter @seg8, @e_sep, @se_sep, @seg_term, @seg8 OUTPUT  
                                                    EXEC dbo.ssp_PM837StringFilter @seg9, @e_sep, @se_sep, @seg_term, @seg9 OUTPUT  
                                                    EXEC dbo.ssp_PM837StringFilter @seg10, @e_sep, @se_sep, @seg_term, @seg10 OUTPUT  
                                                    EXEC dbo.ssp_PM837StringFilter @seg11, @e_sep, @se_sep, @seg_term, @seg11 OUTPUT  
                                                    EXEC dbo.ssp_PM837StringFilter @seg12, @e_sep, @se_sep, @seg_term, @seg12 OUTPUT  
                                                    EXEC dbo.ssp_PM837StringFilter @seg13, @e_sep, @se_sep, @seg_term, @seg13 OUTPUT  
                                                    EXEC dbo.ssp_PM837StringFilter @seg14, @e_sep, @se_sep, @seg_term, @seg14 OUTPUT  
                                                    EXEC dbo.ssp_PM837StringFilter @seg15, @e_sep, @se_sep, @seg_term, @seg15 OUTPUT  
                                                    EXEC dbo.ssp_PM837StringFilter @seg16, @e_sep, @se_sep, @seg_term, @seg16 OUTPUT  
                                                    EXEC dbo.ssp_PM837StringFilter @seg17, @e_sep, @se_sep, @seg_term, @seg17 OUTPUT  
                                                    EXEC dbo.ssp_PM837StringFilter @seg18, @e_sep, @se_sep, @seg_term, @seg18 OUTPUT  
                                                    EXEC dbo.ssp_PM837StringFilter @seg19, @e_sep, @se_sep, @seg_term, @seg19 OUTPUT  
                                                    EXEC dbo.ssp_PM837StringFilter @seg20, @e_sep, @se_sep, @seg_term, @seg20 OUTPUT  
                                                    EXEC dbo.ssp_PM837StringFilter @seg21, @e_sep, @se_sep, @seg_term, @seg21 OUTPUT  
                                                    EXEC dbo.ssp_PM837StringFilter @seg22, @e_sep, @se_sep, @seg_term, @seg22 OUTPUT  
                                                    EXEC dbo.ssp_PM837StringFilter @seg23, @e_sep, @se_sep, @seg_term, @seg23 OUTPUT
                                                    EXEC dbo.ssp_PM837StringFilter @seg24, @e_sep, @se_sep, @seg_term, @seg24 OUTPUT  
                                                    EXEC dbo.ssp_PM837StringFilter @seg25, @e_sep, @se_sep, @seg_term, @seg25 OUTPUT  
                                                    EXEC dbo.ssp_PM837StringFilter @seg26, @e_sep, @se_sep, @seg_term, @seg26 OUTPUT  
                                                    EXEC dbo.ssp_PM837StringFilter @seg27, @e_sep, @se_sep, @seg_term, @seg27 OUTPUT  
                                                    EXEC dbo.ssp_PM837StringFilter @seg28, @e_sep, @se_sep, @seg_term, @seg28 OUTPUT  
                                                    EXEC dbo.ssp_PM837StringFilter @seg29, @e_sep, @se_sep, @seg_term, @seg29 OUTPUT  
                                                    EXEC dbo.ssp_PM837StringFilter @seg30, @e_sep, @se_sep, @seg_term, @seg30 OUTPUT  
                                                    EXEC dbo.ssp_PM837StringFilter @seg31, @e_sep, @se_sep, @seg_term, @seg31 OUTPUT  
                                                    
                                                    
                                                    
                                                    
  
                                                    IF @@error <> 0
                                                        GOTO error  
  
                                                    IF ( @seg1 IS NOT NULL )
                                                        BEGIN														
                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg1  
                                                            UPDATE  dbo.ClaimLineItemGroupStoredData
                                                            SET     PrePayerClaimControlNumberClaimData = ISNULL(PrePayerClaimControlNumberClaimData, '') + @seg1 ,
                                                                    SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                            WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                        END

                                                    IF ( @seg2 IS NOT NULL )
                                                        BEGIN
                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg2  
                                                            UPDATE  dbo.ClaimLineItemGroupStoredData
                                                            SET     PrePayerClaimControlNumberClaimData = ISNULL(PrePayerClaimControlNumberClaimData, '') + @seg2 ,
                                                                    SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                            WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                        END

                                                    IF ( @seg3 IS NOT NULL )
                                                        BEGIN
                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg3  
                                                            UPDATE  dbo.ClaimLineItemGroupStoredData
                                                            SET     PrePayerClaimControlNumberClaimData = ISNULL(PrePayerClaimControlNumberClaimData, '') + @seg3 ,
                                                                    SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                            WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                        END

                                                    IF ( @seg4 IS NOT NULL )
                                                        BEGIN
                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg4  
                                                            UPDATE  dbo.ClaimLineItemGroupStoredData
                                                            SET     PrePayerClaimControlNumberClaimData = ISNULL(PrePayerClaimControlNumberClaimData, '') + @seg4 ,
                                                                    SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                            WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                        END

                                                    IF ( @seg5 IS NOT NULL )
                                                        BEGIN
                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg5  
                                                            UPDATE  dbo.ClaimLineItemGroupStoredData
                                                            SET     PrePayerClaimControlNumberClaimData = ISNULL(PrePayerClaimControlNumberClaimData, '') + @seg5 ,
                                                                    SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                            WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                        END

                                                    IF ( @seg6 IS NOT NULL )
                                                        BEGIN
                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg6  
                                                            UPDATE  dbo.ClaimLineItemGroupStoredData
                                                            SET     PrePayerClaimControlNumberClaimData = ISNULL(PrePayerClaimControlNumberClaimData, '') + @seg6 ,
                                                                    SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                            WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                        END

                                                    IF ( @seg7 IS NOT NULL )-- PayerClaimControlNumber  
                                                        UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg7  

                                                    IF ( @seg8 IS NOT NULL )
                                                        BEGIN
                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg8  
                                                            UPDATE  dbo.ClaimLineItemGroupStoredData
                                                            SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg8 ,
                                                                    SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                            WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                        END

                                                    IF ( @seg9 IS NOT NULL )
                                                        BEGIN
                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg9  
                                                            UPDATE  dbo.ClaimLineItemGroupStoredData
                                                            SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg9 ,
                                                                    SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                            WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                        END

                                                    IF ( @seg10 IS NOT NULL )
                                                        BEGIN
                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg10  
                                                            UPDATE  dbo.ClaimLineItemGroupStoredData
                                                            SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg10 ,
                                                                    SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                            WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                        END

                                                    IF ( @seg11 IS NOT NULL )
                                                        BEGIN
                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg11  
                                                            UPDATE  dbo.ClaimLineItemGroupStoredData
                                                            SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg11 ,
                                                                    SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                            WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                        END

                                                    IF ( @seg12 IS NOT NULL )
                                                        BEGIN
                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg12  
                                                            UPDATE  dbo.ClaimLineItemGroupStoredData
                                                            SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg12 ,
                                                                    SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                            WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                        END

                                                    IF ( @seg13 IS NOT NULL )
                                                        BEGIN
                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg13  
                                                            UPDATE  dbo.ClaimLineItemGroupStoredData
                                                            SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg13 ,
                                                                    SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                            WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                        END

                                                    IF ( @seg14 IS NOT NULL )
                                                        BEGIN
                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg14  
                                                            UPDATE  dbo.ClaimLineItemGroupStoredData
                                                            SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg14 ,
                                                                    SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                            WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                        END

                                                    IF ( @seg15 IS NOT NULL )
                                                        BEGIN
                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg15  
                                                            UPDATE  dbo.ClaimLineItemGroupStoredData
                                                            SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg15 ,
                                                                    SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                            WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                        END

                                                    IF ( @seg16 IS NOT NULL )
                                                        BEGIN
                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg16  
                                                            UPDATE  dbo.ClaimLineItemGroupStoredData
                                                            SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg16 ,
                                                                    SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                            WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                        END

                                                    IF ( @seg17 IS NOT NULL )
                                                        BEGIN
                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg17  
                                                            UPDATE  dbo.ClaimLineItemGroupStoredData
                                                            SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg17 ,
                                                                    SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                            WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                        END

                                                    IF ( @seg18 IS NOT NULL )
                                                        BEGIN
                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg18  
                                                            UPDATE  dbo.ClaimLineItemGroupStoredData
                                                            SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg18 ,
                                                                    SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                            WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                        END

                                                    IF ( @seg19 IS NOT NULL )
                                                        BEGIN
                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg19  
                                                            UPDATE  dbo.ClaimLineItemGroupStoredData
                                                            SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg19 ,
                                                                    SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                            WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                        END

                                                    IF ( @seg20 IS NOT NULL )
                                                        BEGIN
                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg20  
                                                            UPDATE  dbo.ClaimLineItemGroupStoredData
                                                            SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg20 ,
                                                                    SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                            WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                        END

                                                    IF ( @seg21 IS NOT NULL )
                                                        BEGIN
                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg21  
                                                            UPDATE  dbo.ClaimLineItemGroupStoredData
                                                            SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg21 ,
                                                                    SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                            WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                        END

                                                    IF ( @seg22 IS NOT NULL )
                                                        BEGIN
                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg22  
                                                            UPDATE  dbo.ClaimLineItemGroupStoredData
                                                            SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg22 ,
                                                                    SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                            WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                        END

                                                    IF ( @seg23 IS NOT NULL )
                                                        BEGIN
                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg23  
                                                            UPDATE  dbo.ClaimLineItemGroupStoredData
                                                            SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg23 ,
                                                                    SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                            WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                        END

                                                    IF ( @seg24 IS NOT NULL )
                                                        BEGIN
                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg24
                                                            UPDATE  dbo.ClaimLineItemGroupStoredData
                                                            SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg24 ,
                                                                    SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                            WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                        END

                                                    IF ( @seg25 IS NOT NULL )
                                                        BEGIN
                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg25
                                                            UPDATE  dbo.ClaimLineItemGroupStoredData
                                                            SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg25 ,
                                                                    SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                            WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                        END
  
                                                    IF ( @seg26 IS NOT NULL )
                                                        BEGIN
                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg26
                                                            UPDATE  dbo.ClaimLineItemGroupStoredData
                                                            SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg26 ,
                                                                    SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                            WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                        END
  
                                                    IF ( @seg27 IS NOT NULL )
                                                        BEGIN
                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg27
                                                            UPDATE  dbo.ClaimLineItemGroupStoredData
                                                            SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg27 ,
                                                                    SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                            WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                        END
  
                                                    IF ( @seg28 IS NOT NULL )
                                                        BEGIN
                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg28
                                                            UPDATE  dbo.ClaimLineItemGroupStoredData
                                                            SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg28 ,
                                                                    SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                            WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                        END
  
                                                    IF ( @seg29 IS NOT NULL )
                                                        BEGIN
                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg29
                                                            UPDATE  dbo.ClaimLineItemGroupStoredData
                                                            SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg29 ,
                                                                    SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                            WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                        END
  
                                                    IF ( @seg30 IS NOT NULL )
                                                        BEGIN
                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg30
                                                            UPDATE  dbo.ClaimLineItemGroupStoredData
                                                            SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg30 ,
                                                                    SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                            WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                        END
													
                                                    IF ( @seg31 IS NOT NULL )
                                                        BEGIN
                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg31
                                                            UPDATE  dbo.ClaimLineItemGroupStoredData
                                                            SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg31 ,
                                                                    SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                            WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                        END
													
                                                    IF @@error <> 0
                                                        GOTO error  
  
  
-- Initialize Service Count  
                                                    SELECT  @ServiceCount = 0  
  
                                                    IF @@error <> 0
                                                        GOTO error  
  
-- Loop to get Other Insured  
                                                    DECLARE cur_OtherInsured CURSOR
                                                    FOR
                                                        SELECT DISTINCT
                                                                SubscriberSegment ,
                                                                PayerPaidAmountSegment ,
                                                                PayerAllowedAmountSegment ,
                                                                PatientResponsbilityAmountSegment ,
                                                                DMGSegment ,
                                                                OISegment ,
                                                                OINM1Segment ,
                                                                OIN3Segment ,
                                                                OIN4Segment ,
                                                                OIRefSegment ,
                                                                PayerNM1Segment ,
																PayerN3Segment ,
																PayerN4Segment ,
                                                                PayerPaymentDTPSegment ,
                                                                PayerRefSegment, --srf 1/19/2012 added PayerRefSegment  
                                                                AuthorizationNumberRefSegment
                                                        FROM    #837OtherInsureds
                                                        WHERE   RefClaimId = @ClaimLoopId   
  
											
                                                    PRINT @ClaimLoopId
											
  
                                                    IF @@error <> 0
                                                        GOTO error  
  
                                                    OPEN cur_OtherInsured  
  
                                                    IF @@error <> 0
                                                        GOTO error  
  
                                                    FETCH cur_OtherInsured INTO @seg1, @seg2, @seg3, @seg4, @seg5, @seg6, @seg7, @seg8, @seg9, @seg10, @seg11, @seg12, @seg13, @seg14, @seg15, @seg16
  
                                                    IF @@error <> 0
                                                        GOTO error  
 
                                                    WHILE @@fetch_status = 0
                                                        BEGIN  
													-- Other Insured
                                                            EXEC dbo.ssp_PM837StringFilter @seg1, @e_sep, @se_sep, @seg_term, @seg1 OUTPUT  
                                                            EXEC dbo.ssp_PM837StringFilter @seg2, @e_sep, @se_sep, @seg_term, @seg2 OUTPUT  
                                                            EXEC dbo.ssp_PM837StringFilter @seg3, @e_sep, @se_sep, @seg_term, @seg3 OUTPUT  
                                                            EXEC dbo.ssp_PM837StringFilter @seg4, @e_sep, @se_sep, @seg_term, @seg4 OUTPUT  
                                                            EXEC dbo.ssp_PM837StringFilter @seg5, @e_sep, @se_sep, @seg_term, @seg5 OUTPUT  
                                                            EXEC dbo.ssp_PM837StringFilter @seg6, @e_sep, @se_sep, @seg_term, @seg6 OUTPUT  
                                                            EXEC dbo.ssp_PM837StringFilter @seg7, @e_sep, @se_sep, @seg_term, @seg7 OUTPUT  
                                                            EXEC dbo.ssp_PM837StringFilter @seg8, @e_sep, @se_sep, @seg_term, @seg8 OUTPUT  
                                                            EXEC dbo.ssp_PM837StringFilter @seg9, @e_sep, @se_sep, @seg_term, @seg9 OUTPUT  
                                                            EXEC dbo.ssp_PM837StringFilter @seg10, @e_sep, @se_sep, @seg_term, @seg10 OUTPUT  
                                                            EXEC dbo.ssp_PM837StringFilter @seg11, @e_sep, @se_sep, @seg_term, @seg11 OUTPUT  
                                                            EXEC dbo.ssp_PM837StringFilter @seg12, @e_sep, @se_sep, @seg_term, @seg12 OUTPUT  
                                                            EXEC dbo.ssp_PM837StringFilter @seg13, @e_sep, @se_sep, @seg_term, @seg13 OUTPUT  
                                                            EXEC dbo.ssp_PM837StringFilter @seg14, @e_sep, @se_sep, @seg_term, @seg14 OUTPUT
															EXEC dbo.ssp_PM837StringFilter @seg15, @e_sep, @se_sep, @seg_term, @seg15 OUTPUT 
															EXEC dbo.ssp_PM837StringFilter @seg16, @e_sep, @se_sep, @seg_term, @seg16 OUTPUT   
  
                                                            IF @@error <> 0
                                                                GOTO error  
  
                                                            IF ( @seg1 IS NOT NULL )
                                                                BEGIN
                                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg1  
                                                                    UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                    SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg1 ,
                                                                            SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                    WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                END
                                                            IF ( @seg2 IS NOT NULL )
                                                                BEGIN
                                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg2  
                                                                    UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                    SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg2 ,
                                                                            SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                    WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                END
                                                            IF ( @seg3 IS NOT NULL )
                                                                BEGIN
                                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg3   
                                                                    UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                    SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg3 ,
                                                                            SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                    WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                END

                                                            IF ( @seg4 IS NOT NULL )
                                                                BEGIN
                                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg4   
                                                                    UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                    SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg4 ,
                                                                            SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                    WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                END

                                                            IF ( @seg5 IS NOT NULL )
                                                                BEGIN
                                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg5   
                                                                    UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                    SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg5 ,
                                                                            SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                    WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                END

                                                            IF ( @seg6 IS NOT NULL )
                                                                BEGIN
                                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg6   
                                                                    UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                    SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg6 ,
                                                                            SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                    WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                END

                                                            IF ( @seg7 IS NOT NULL )
                                                                BEGIN
                                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg7   
                                                                    UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                    SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg7 ,
                                                                            SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                    WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                END

                                                            IF ( @seg8 IS NOT NULL )
                                                                BEGIN
                                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg8   
                                                                    UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                    SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg8 ,
                                                                            SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                    WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                END

                                                            IF ( @seg9 IS NOT NULL )
                                                                BEGIN
                                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg9		 
                                                                    UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                    SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg9 ,
                                                                            SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                    WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                END

                                                            IF ( @seg10 IS NOT NULL )
                                                                BEGIN
                                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg10   
                                                                    UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                    SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg10 ,
                                                                            SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                    WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                END

                                                            IF ( @seg11 IS NOT NULL )
                                                                BEGIN
                                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg11   
                                                                    UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                    SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg11 ,
                                                                            SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                    WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                END

                                                            IF ( @seg12 IS NOT NULL )
                                                                BEGIN
                                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg12   
                                                                    UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                    SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg12 ,
                                                                            SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                    WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                END

                                                            IF ( @seg13 IS NOT NULL )
                                                                BEGIN
                                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg13   
                                                                    UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                    SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg13 ,
                                                                            SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                    WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                END

                                                            IF ( @seg14 IS NOT NULL )
                                                                BEGIN
                                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg14   
                                                                    UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                    SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg14 ,
                                                                            SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                    WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                END
															
															IF ( @seg15 IS NOT NULL )
                                                                BEGIN
                                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @SEG15   
                                                                    UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                    SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg15 ,
                                                                            SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                    WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                END

															IF ( @seg16 IS NOT NULL )
                                                                BEGIN
                                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @SEG16   
                                                                    UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                    SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg16 ,
                                                                            SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                    WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                END
  
                                                            IF @@error <> 0
                                                                GOTO error  
  
                                                            SELECT  @seg1 = NULL ,
                                                                    @seg2 = NULL ,
                                                                    @seg3 = NULL ,
                                                                    @seg4 = NULL ,
                                                                    @seg5 = NULL ,
                                                                    @seg6 = NULL ,
                                                                    @seg7 = NULL ,
                                                                    @seg8 = NULL ,
                                                                    @seg9 = NULL ,
                                                                    @seg10 = NULL ,
                                                                    @seg11 = NULL ,
                                                                    @seg12 = NULL ,
                                                                    @seg13 = NULL ,
                                                                    @seg14 = NULL ,
                                                                    @seg15 = NULL ,
                                                                    @seg16 = NULL ,
                                                                    @seg17 = NULL ,
                                                                    @seg18 = NULL ,
                                                                    @seg19 = NULL ,
                                                                    @seg20 = NULL ,
                                                                    @seg21 = NULL ,
                                                                    @seg22 = NULL  
  
                                                            IF @@error <> 0
                                                                GOTO error  
  
                                                            FETCH cur_OtherInsured INTO @seg1, @seg2, @seg3, @seg4, @seg5, @seg6, @seg7, @seg8, @seg9, @seg10, @seg11, @seg12, @seg13, @seg14, @seg15, @seg16
  
                                                            IF @@error <> 0
                                                                GOTO error  
  
                                                        END -- Other Insured Loop  
  
                                                    CLOSE cur_OtherInsured  
 
                                                    IF @@error <> 0
                                                        GOTO error  
  
                                                    DEALLOCATE cur_OtherInsured  
  
                                                    IF @@error <> 0
                                                        GOTO error  
  
-- Loop to get Service  
                                                    DECLARE cur_Service CURSOR
                                                    FOR
                                                        SELECT  UniqueId ,
                                                                SV1Segment ,
                                                                ServiceDateDTPSegment ,
                                                                ReferralDateDTPSegment ,
                                                                ContractInformationSegment ,
                                                                LineItemControlRefSegment ,
                                                                ProviderAuthorizationRefSegment ,
                                                                K3Segment ,
                                                                FacilityNM1Segment ,
                                                                FacilityN3Segment ,
                                                                FacilityN4Segment ,
                                                                FacilityRefSegment ,
                                                                SupervisorNM1Segment ,
                                                                ReferringNM1Segment ,
                                                                PayerNM1Segment ,
                                                                ApprovedAmountSegment ,
                                                                ServiceNTESegment,
																RenderingNM1Segment,
																RenderingPRVSegment,
																RenderingRefSegment
																OrderingNM1Segment,
																OrderingN3Segment,
																OrderingN4Segment,
																OrderingREFSegment,
																OrderingPERSegment
                                                        FROM    #837Services
                                                        WHERE   RefClaimId = @ClaimLoopId   
  
                                                    IF @@error <> 0
                                                        GOTO error  
  
                                                    OPEN cur_Service  
  
                                                    IF @@error <> 0
                                                        GOTO error  
  
                                                    FETCH cur_Service INTO @ServiceLoopId, @seg1, @seg2, @seg3, @seg4, @seg5, @seg6, @seg7, @seg8, @seg9, @seg10, @seg11, @seg12, @seg13, @seg14, @seg15, @seg16, @seg17, @seg18, @seg19, @seg20, @seg21, @seg22, @seg23, @seg24
  
                                                    IF @@error <> 0
                                                        GOTO error  
  
                                                    WHILE @@fetch_status = 0
                                                        BEGIN  
  
                                                            SELECT  @ServiceCount = @ServiceCount + 1  
  
                                                            IF @@error <> 0
                                                                GOTO error  
  
-- LX segment  
                                                            SELECT  @seg25 = 'LX' + @e_sep + CONVERT(VARCHAR, @ServiceCount) + @seg_term  
  
                                                            IF @@error <> 0
                                                                GOTO error  
													
                                                            EXEC dbo.ssp_PM837StringFilter @seg25, @e_sep, @se_sep, @seg_term, @seg25 OUTPUT  	
                                                            EXEC dbo.ssp_PM837StringFilter @seg1, @e_sep, @se_sep, @seg_term, @seg1 OUTPUT  
                                                            EXEC dbo.ssp_PM837StringFilter @seg2, @e_sep, @se_sep, @seg_term, @seg2 OUTPUT  
                                                            EXEC dbo.ssp_PM837StringFilter @seg3, @e_sep, @se_sep, @seg_term, @seg3 OUTPUT  
                                                            EXEC dbo.ssp_PM837StringFilter @seg4, @e_sep, @se_sep, @seg_term, @seg4 OUTPUT  
                                                            EXEC dbo.ssp_PM837StringFilter @seg5, @e_sep, @se_sep, @seg_term, @seg5 OUTPUT  
                                                            EXEC dbo.ssp_PM837StringFilter @seg6, @e_sep, @se_sep, @seg_term, @seg6 OUTPUT  
                                                            EXEC dbo.ssp_PM837StringFilter @seg7, @e_sep, @se_sep, @seg_term, @seg7 OUTPUT  
                                                            EXEC dbo.ssp_PM837StringFilter @seg8, @e_sep, @se_sep, @seg_term, @seg8 OUTPUT  
                                                            EXEC dbo.ssp_PM837StringFilter @seg9, @e_sep, @se_sep, @seg_term, @seg9 OUTPUT  
                                                            EXEC dbo.ssp_PM837StringFilter @seg10, @e_sep, @se_sep, @seg_term, @seg10 OUTPUT  
                                                            EXEC dbo.ssp_PM837StringFilter @seg11, @e_sep, @se_sep, @seg_term, @seg11 OUTPUT  
                                                            EXEC dbo.ssp_PM837StringFilter @seg12, @e_sep, @se_sep, @seg_term, @seg12 OUTPUT  
                                                            EXEC dbo.ssp_PM837StringFilter @seg13, @e_sep, @se_sep, @seg_term, @seg13 OUTPUT 
                                                            EXEC dbo.ssp_PM837StringFilter @seg14, @e_sep, @se_sep, @seg_term, @seg14 OUTPUT  
                                                            EXEC dbo.ssp_PM837StringFilter @seg15, @e_sep, @se_sep, @seg_term, @seg15 OUTPUT  
                                                            EXEC dbo.ssp_PM837StringFilter @seg16, @e_sep, @se_sep, @seg_term, @seg16 OUTPUT  
                                                            EXEC dbo.ssp_PM837StringFilter @seg17, @e_sep, @se_sep, @seg_term, @seg17 OUTPUT  
                                                            EXEC dbo.ssp_PM837StringFilter @seg18, @e_sep, @se_sep, @seg_term, @seg18 OUTPUT  
                                                            EXEC dbo.ssp_PM837StringFilter @seg19, @e_sep, @se_sep, @seg_term, @seg19 OUTPUT  
  															EXEC dbo.ssp_PM837StringFilter @seg20, @e_sep, @se_sep, @seg_term, @seg20 OUTPUT  
                                                            EXEC dbo.ssp_PM837StringFilter @seg21, @e_sep, @se_sep, @seg_term, @seg21 OUTPUT  
                                                            EXEC dbo.ssp_PM837StringFilter @seg22, @e_sep, @se_sep, @seg_term, @seg22 OUTPUT  
                                                            EXEC dbo.ssp_PM837StringFilter @seg23, @e_sep, @se_sep, @seg_term, @seg23 OUTPUT  
                                                            EXEC dbo.ssp_PM837StringFilter @seg24, @e_sep, @se_sep, @seg_term, @seg24 OUTPUT  
                                                            IF @@error <> 0
                                                                GOTO error  
  
                                                            IF ( @seg25 IS NOT NULL )
                                                                BEGIN
                                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg25    
                                                                    UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                    SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg25 ,
                                                                            SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                    WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                END

                                                            IF ( @seg1 IS NOT NULL )
                                                                BEGIN
                                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg1   
                                                                    UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                    SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg1 ,
                                                                            SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                    WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                END

                                                            IF ( @seg2 IS NOT NULL )
                                                                BEGIN
                                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg2   
                                                                    UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                    SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg2 ,
                                                                            SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                    WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                END

                                                            IF ( @seg3 IS NOT NULL )
                                                                BEGIN
                                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg3   
                                                                    UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                    SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg3 ,
                                                                            SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                    WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                END

                                                            IF ( @seg4 IS NOT NULL )
                                                                BEGIN
                                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg4   
                                                                    UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                    SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg4 ,
                                                                            SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                    WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                END

                                                            IF ( @seg5 IS NOT NULL )
                                                                BEGIN
                                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg5   
                                                                    UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                    SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg5 ,
                                                                            SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                    WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                END

                                                            IF ( @seg6 IS NOT NULL )
                                                                BEGIN
                                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg6   
                                                                    UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                    SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg6 ,
                                                                            SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                    WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                END

                                                            IF ( @seg7 IS NOT NULL )
                                                                BEGIN
                                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg7   
                                                                    UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                    SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg7 ,
                                                                            SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                    WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                END

                                                            IF ( @seg8 IS NOT NULL )
                                                                BEGIN
                                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg8   
                                                                    UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                    SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg8 ,
                                                                            SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                    WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                END

                                                            IF ( @seg9 IS NOT NULL )
                                                                BEGIN
                                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg9   
                                                                    UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                    SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg9 ,
                                                                            SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                    WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                END

                                                            IF ( @seg10 IS NOT NULL )
                                                                BEGIN
                                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg10   
                                                                    UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                    SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg10 ,
                                                                            SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                    WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                END

                                                            IF ( @seg11 IS NOT NULL )
                                                                BEGIN
                                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg11   
                                                                    UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                    SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg11 ,
                                                                            SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                    WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                END

                                                            IF ( @seg12 IS NOT NULL )
                                                                BEGIN
                                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg12  
                                                                    UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                    SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg12 ,
                                                                            SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                    WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                END

                                                            IF ( @seg13 IS NOT NULL )
                                                                BEGIN
                                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg13  
                                                                    UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                    SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg13 ,
                                                                            SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                    WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                END

                                                            IF ( @seg14 IS NOT NULL )
                                                                BEGIN
                                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg14 
                                                                    UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                    SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg14 ,
                                                                            SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                    WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                END

                                                            IF ( @seg15 IS NOT NULL )
                                                                BEGIN
                                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg15 
                                                                    UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                    SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg15 ,
                                                                            SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                    WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                END

                                                            IF ( @seg16 IS NOT NULL )
                                                                BEGIN
                                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg16   
                                                                    UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                    SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg16 ,
                                                                            SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                    WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                END

															IF ( @seg17 IS NOT NULL )
                                                                BEGIN
                                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg17   
                                                                    UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                    SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg17 ,
                                                                            SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                    WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                END

															IF ( @seg18 IS NOT NULL )
                                                                BEGIN
                                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg18   
                                                                    UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                    SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg18 ,
                                                                            SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                    WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                END

															IF ( @seg19 IS NOT NULL )
                                                                BEGIN
                                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg19   
                                                                    UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                    SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg19 ,
                                                                            SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                    WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                END
                                                     
															IF ( @seg20 IS NOT NULL )
                                                                BEGIN
                                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg20   
                                                                    UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                    SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg20 ,
                                                                            SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                    WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                END

															IF ( @seg21 IS NOT NULL )
                                                                BEGIN
                                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg21   
                                                                    UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                    SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg21 ,
                                                                            SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                    WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                END

															IF ( @seg22 IS NOT NULL )
                                                                BEGIN
                                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg22   
                                                                    UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                    SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg22 ,
                                                                            SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                    WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                END

															IF ( @seg23 IS NOT NULL )
                                                                BEGIN
                                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg23   
                                                                    UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                    SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg23 ,
                                                                            SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                    WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                END

															IF ( @seg24 IS NOT NULL )
                                                                BEGIN
                                                                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg24   
                                                                    UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                    SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg24 ,
                                                                            SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                    WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                END
                                                            IF @@error <> 0
                                                                GOTO error  
  
--select @ServiceLoopId= null,@seg1 = null, @seg2 = null, @seg3 = null, @seg4 = null, @seg5 = null, @seg6 = null,   
--@seg7 = null, @seg8 = null, @seg9 = null, @seg10 = null, @seg11 = null, @seg12 = null ,  
--@seg13 = null, @seg14 = null, @seg15 = null, @seg16 = null, @seg17 = null, @seg18 = null,  
--@seg19 = null, @seg20 = null, @seg21 = null, @seg22 = null  
  
                                                            IF @@error <> 0
                                                                GOTO error  
  
--NEW** Start   
-- Loop to get #837DrugIdentification  
                                                            DECLARE cur_DrugIdentification CURSOR
                                                            FOR
                                                                SELECT  LINSegment ,
                                                                        CTPSegment
                                                                FROM    #837DrugIdentification
                                                                WHERE   RefServiceId = @ServiceLoopId   
  
                                                            IF @@error <> 0
                                                                GOTO error  
  
                                                            OPEN cur_DrugIdentification  
  
                                                            IF @@error <> 0
                                                                GOTO error  
  
                                                            FETCH cur_DrugIdentification INTO @seg1, @seg2  
  
                                                            IF @@error <> 0
                                                                GOTO error  
  
                                                            WHILE @@fetch_status = 0
                                                                BEGIN  
  
                                                                    EXEC dbo.ssp_PM837StringFilter @seg1, @e_sep, @se_sep, @seg_term, @seg1 OUTPUT  
                                                                    EXEC dbo.ssp_PM837StringFilter @seg2, @e_sep, @se_sep, @seg_term, @seg2 OUTPUT  
  
                                                                    IF @@error <> 0
                                                                        GOTO error  
  
                                                                    IF ( @seg1 IS NOT NULL )
                                                                        BEGIN
                                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg1   
                                                                            UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                            SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg1 ,
                                                                                    SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                            WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                        END

                                                                    IF ( @seg2 IS NOT NULL )
                                                                        BEGIN
                                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg2   
                                                                            UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                            SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg2 ,
                                                                                    SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                            WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                        END
  
                                                                    IF @@error <> 0
                                                                        GOTO error  
  
  
                                                                    SELECT  @seg1 = NULL ,
                                                                            @seg2 = NULL  
                                                                    IF @@error <> 0
                                                                        GOTO error  
  
  
                                                                    IF @@error <> 0
                                                                        GOTO error  
  
--New**  
                                                                    FETCH cur_DrugIdentification INTO @seg1, @seg2  
  
                                                                    IF @@error <> 0
                                                                        GOTO error  
  
                                                                END -- Other DrugIdentification Loop  
  
                                                            CLOSE cur_DrugIdentification  
  
                                                            IF @@error <> 0
                                                                GOTO error  
  
                                                            DEALLOCATE cur_DrugIdentification  
  
                                                            IF @@error <> 0
                                                                GOTO error  
  
                                                            SELECT  @seg1 = NULL ,
                                                                    @seg2 = NULL  
  
                                                            IF @@error <> 0
                                                                GOTO error  
  
--NEW** end  
  
-- Loop to get Other Insured Adjustments  
                                                            DECLARE cur_OtherInsured CURSOR
                                                            FOR
                                                                SELECT  oicl.SVDSegment ,
                                                                        oicl.CAS1Segment ,
                                                                        oicl.CAS2Segment ,
                                                                        oicl.CAS3Segment ,
                                                                        oicl.CAS4Segment ,
                                                                        oicl.ServiceAdjudicationDTPSegment
                                                                FROM    #837OtherInsuredClaimLines AS oicl
                                                                        JOIN #837Services b ON b.ClaimLineId = oicl.ClaimLineId
                                                                WHERE   b.UniqueId = @ServiceLoopId 
																		ORDER BY oicl.Priority
  
                                                            IF @@error <> 0
                                                                GOTO error  
  
                                                            OPEN cur_OtherInsured  
  
                                                            IF @@error <> 0
                                                                GOTO error  
  
                                                            FETCH cur_OtherInsured INTO @seg1, @seg2, @seg3, @seg4, @seg5, @seg6
  
                                                            IF @@error <> 0
                                                                GOTO error  
  
                                                            WHILE @@fetch_status = 0
                                                                BEGIN  
  
                                                                    EXEC dbo.ssp_PM837StringFilter @seg1, @e_sep, @se_sep, @seg_term, @seg1 OUTPUT  
                                                                    EXEC dbo.ssp_PM837StringFilter @seg2, @e_sep, @se_sep, @seg_term, @seg2 OUTPUT  
                                                                    EXEC dbo.ssp_PM837StringFilter @seg3, @e_sep, @se_sep, @seg_term, @seg3 OUTPUT  
                                                                    EXEC dbo.ssp_PM837StringFilter @seg4, @e_sep, @se_sep, @seg_term, @seg4 OUTPUT  
                                                                    EXEC dbo.ssp_PM837StringFilter @seg5, @e_sep, @se_sep, @seg_term, @seg5 OUTPUT  
                                                                    EXEC dbo.ssp_PM837StringFilter @seg6, @e_sep, @se_sep, @seg_term, @seg6 OUTPUT  
  
                                                                    IF @@error <> 0
                                                                        GOTO error  
  
                                                                    IF ( @seg1 IS NOT NULL )
                                                                        BEGIN
                                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg1   
                                                                            UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                            SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg1 ,
                                                                                    SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                            WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                        END

                                                                    IF ( @seg2 IS NOT NULL )
                                                                        BEGIN
                                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg2   
                                                                            UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                            SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg2 ,
                                                                                    SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                            WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                        END

                                                                    IF ( @seg3 IS NOT NULL )
                                                                        BEGIN
                                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg3   
                                                                            UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                            SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg3 ,
                                                                                    SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                            WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                        END

                                                                    IF ( @seg4 IS NOT NULL )
                                                                        BEGIN
                                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg4   
                                                                            UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                            SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg4 ,
                                                                                    SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                            WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                        END

                                                                    IF ( @seg5 IS NOT NULL )
                                                                        BEGIN
                                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg5   
                                                                            UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                            SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg5 ,
                                                                                    SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                            WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                        END
																		
                                                                    IF ( @seg6 IS NOT NULL )
                                                                        BEGIN
                                                                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @seg6   
                                                                            UPDATE  dbo.ClaimLineItemGroupStoredData
                                                                            SET     PostPayerClaimControlNumberClaimData = ISNULL(PostPayerClaimControlNumberClaimData, '') + @seg6 ,
                                                                                    SegmentCount = ISNULL(SegmentCount, 0) + 1
                                                                            WHERE   ClaimLineItemGroupId = @ClaimLineItemGroupId
                                                                        END
  
                                                                    IF @@error <> 0
                                                                        GOTO error  
  
                                                                    SELECT  @seg1 = NULL ,
                                                                            @seg2 = NULL ,
                                                                            @seg3 = NULL ,
                                                                            @seg4 = NULL ,
                                                                            @seg5 = NULL ,
                                                                            @seg6 = NULL ,
                                                                            @seg7 = NULL ,
                                                                            @seg8 = NULL ,
                                                                            @seg9 = NULL ,
                                                                            @seg10 = NULL ,
                                                                            @seg11 = NULL ,
                                                                            @seg12 = NULL ,
                                                                            @seg13 = NULL ,
                                                                            @seg14 = NULL ,
                                                                            @seg15 = NULL ,
                                                                            @seg16 = NULL ,
                                                                            @seg17 = NULL ,
                                                                            @seg18 = NULL ,
                                                                            @seg19 = NULL ,
                                                                            @seg20 = NULL ,
                                                                            @seg21 = NULL ,
                                                                            @seg22 = NULL 
  
  
                                                                    IF @@error <> 0
                                                                        GOTO error  
  
                                                                    FETCH cur_OtherInsured INTO @seg1, @seg2, @seg3, @seg4, @seg5, @seg6
  
                                                                    IF @@error <> 0
                                                                        GOTO error  
  
                                                                END -- Other Insured Adjustment Loop  
-- DONTNEEDTOPASSHERE
  
                                                            CLOSE cur_OtherInsured  
  
                                                            IF @@error <> 0
                                                                GOTO error  
  
                                                            DEALLOCATE cur_OtherInsured  
  
                                                            IF @@error <> 0
                                                                GOTO error  
  
                                                            SELECT  @seg1 = NULL ,
                                                                    @seg2 = NULL ,
                                                                    @seg3 = NULL ,
                                                                    @seg4 = NULL ,
                                                                    @seg5 = NULL ,
                                                                    @seg6 = NULL ,
                                                                    @seg7 = NULL ,
                                                                    @seg8 = NULL ,
                                                                    @seg9 = NULL ,
                                                                    @seg10 = NULL ,
                                                                    @seg11 = NULL ,
                                                                    @seg12 = NULL ,
                                                                    @seg13 = NULL ,
                                                                    @seg14 = NULL ,
                                                                    @seg15 = NULL ,
                                                                    @seg16 = NULL ,
                                                                    @seg17 = NULL ,
                                                                    @seg18 = NULL ,
                                                                    @seg19 = NULL ,
                                                                    @seg20 = NULL ,
                                                                    @seg21 = NULL ,
                                                                    @seg22 = NULL ,
																	@seg23 = NULL ,
																	@seg24 = NULL
  
  
                                                            IF @@error <> 0
                                                                GOTO error  
  
  
                                                            FETCH cur_Service INTO @ServiceLoopId, @seg1, @seg2, @seg3, @seg4, @seg5, @seg6, @seg7, @seg8, @seg9, @seg10, @seg11, @seg12, @seg13, @seg14, @seg15, @seg16, @seg17, @seg18, @seg19, @seg20, @seg21, @seg22, @seg23, @seg24
  
                                                            IF @@error <> 0
                                                                GOTO error  
  
                                                        END -- Service Loop  
  
                                                    CLOSE cur_Service  
  
                                                    IF @@error <> 0
                                                        GOTO error  
  
                                                    DEALLOCATE cur_Service  
  
                                                    IF @@error <> 0
                                                        GOTO error  
  
                                                    SELECT  @ServiceLoopId = NULL ,
                                                            @seg1 = NULL ,
                                                            @seg2 = NULL ,
                                                            @seg3 = NULL ,
                                                            @seg4 = NULL ,
                                                            @seg5 = NULL ,
                                                            @seg6 = NULL ,
                                                            @seg7 = NULL ,
                                                            @seg8 = NULL ,
                                                            @seg9 = NULL ,
                                                            @seg10 = NULL ,
                                                            @seg11 = NULL ,
                                                            @seg12 = NULL ,
                                                            @seg13 = NULL ,
                                                            @seg14 = NULL ,
                                                            @seg15 = NULL ,
                                                            @seg16 = NULL ,
                                                            @seg17 = NULL ,
                                                            @seg18 = NULL ,
                                                            @seg19 = NULL ,
                                                            @seg20 = NULL ,
                                                            @seg21 = NULL ,
                                                            @seg22 = NULL ,
                                                            @ClaimLineItemGroupId = NULL ,
                                                            @ToVoidClaimLineItemGroupId = NULL
  
                                                    IF @@error <> 0
                                                        GOTO error  

                                                END
  
                                            FETCH cur_Claim INTO @ClaimLoopId, @ToVoidClaimLineItemGroupId, @ClaimLineItemGroupId, @seg1, @seg2, @seg3, @seg4, @seg5, @seg6, @seg7, @seg8, @seg9, @seg10, @seg11, @seg12, @seg13, @seg14, @seg15, @seg16, @seg17, @seg18, @seg19, @seg20, @seg21, @seg22, @seg23, @seg24, @seg25, @seg26, @seg27, @seg28, @seg29, @seg30, @seg31
  
                                            IF @@error <> 0
                                                GOTO error  
  
                                        END -- Claim Loop  
  
                                    CLOSE cur_Claim  
  
                                    IF @@error <> 0
                                        GOTO error  
  
                                    DEALLOCATE cur_Claim  
  
                                    IF @@error <> 0
                                        GOTO error  
  
                                    SELECT  @seg1 = NULL ,
                                            @seg2 = NULL ,
                                            @seg3 = NULL ,
                                            @seg4 = NULL ,
                                            @seg5 = NULL ,
                                            @seg6 = NULL ,
                                            @seg7 = NULL ,
                                            @seg8 = NULL ,
                                            @seg9 = NULL ,
                                            @seg10 = NULL ,
                                            @seg11 = NULL ,
                                            @seg12 = NULL ,
                                            @seg13 = NULL ,
                                            @seg14 = NULL ,
                                            @seg15 = NULL ,
                                            @seg16 = NULL ,
                                            @seg17 = NULL ,
                                            @seg18 = NULL ,
                                            @seg19 = NULL ,
                                            @seg20 = NULL ,
                                            @seg21 = NULL ,
                                            @seg22 = NULL ,
                                            @seg23 = NULL ,
                                            @seg24 = NULL  
  
                                    IF @@error <> 0
                                        GOTO error  
  
                                    FETCH cur_Subscriber INTO @SubscriberLoopId, @seg1, @seg2, @seg3, @seg4, @seg5, @seg6, @seg7, @seg8, @seg9, @seg10, @seg11, @seg12, @seg13, @seg14, @seg15, @seg16, @seg17, @seg18
  
                                    IF @@error <> 0
                                        GOTO error  
  
                                END -- Subscriber Loop  
  
                            CLOSE cur_Subscriber  
  
                            IF @@error <> 0
                                GOTO error  
  
                            DEALLOCATE cur_Subscriber  
  
                            IF @@error <> 0
                                GOTO error  
  
                            SELECT  @seg1 = NULL ,
                                    @seg2 = NULL ,
                                    @seg3 = NULL ,
                                    @seg4 = NULL ,
                                    @seg5 = NULL ,
                                    @seg6 = NULL ,
                                    @seg7 = NULL ,
                                    @seg8 = NULL ,
                                    @seg9 = NULL ,
                                    @seg10 = NULL ,
                                    @seg11 = NULL ,
                                    @seg12 = NULL ,
                                    @seg13 = NULL ,
                                    @seg14 = NULL ,
                                    @seg15 = NULL ,
                                    @seg16 = NULL ,
                                    @seg17 = NULL ,
                                    @seg18 = NULL ,
                                    @seg19 = NULL ,
                                    @seg20 = NULL ,
                                    @seg21 = NULL ,
                                    @seg22 = NULL  
  
                            IF @@error <> 0
                                GOTO error  
  
                            FETCH cur_Provider INTO @ProviderLoopId, @seg1, @seg2, @seg3, @seg4, @seg5, @seg6, @seg7, @seg8, @seg9, @seg10, @seg11, @seg13, @seg14, @seg15  
  
                            IF @@error <> 0
                                GOTO error  
  
                        END -- Billing Provider Loop  
  
                    CLOSE cur_Provider  
  
                    IF @@error <> 0
                        GOTO error  
  
                    DEALLOCATE cur_Provider  
  
                    IF @@error <> 0
                        GOTO error  
  
-- Transaction Trailer  
                    UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @TransactionTrailer  
  
                    IF @@error <> 0
                        GOTO error  
  
-- In case of last file populate functional and interchange trailer  
                    IF NOT EXISTS ( SELECT  *
                                    FROM    #ClaimLines )
                        BEGIN  
  
                            SELECT  @FunctionalTrailer = FunctionalTrailerSegment ,
                                    @InterchangeTrailer = InterchangeTrailerSegment
                            FROM    #HIPAAHeaderTrailer  
  
                            IF @@error <> 0
                                GOTO error  
  
-- Functional Group Trailer  
                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @FunctionalTrailer  
  
                            IF @@error <> 0
                                GOTO error  
  
-- Interchange Group Trailer  
                            UPDATETEXT #FinalData.DataText @TextPointer NULL NULL @InterchangeTrailer  
  
                            IF @@error <> 0
                                GOTO error  
  
                        END  
  
                END -- File Creation  
  
-- Update the claim file data, status and processed date  
            UPDATE  a
            SET     a.ElectronicClaimsData = b.DataText ,
                    a.Status = 4523 ,
                    a.ProcessedDate = CONVERT(VARCHAR, GETDATE(), 101) ,
                    a.SegmentTerminater = @seg_term ,
                    a.BatchProcessProgress = 100
            FROM    dbo.ClaimBatches a
                    CROSS JOIN #FinalData b
            WHERE   a.ClaimBatchId = @ParamClaimBatchId  
  
            IF @@error <> 0
                GOTO error  
        
        
        
        END




---- Generate HCFA1500
                        
    IF @Electronic <> 'Y'
        BEGIN
            IF ( SELECT COUNT(*)
                 FROM   #ClaimLines
               ) = 0
                AND ( SELECT    COUNT(*)
                      FROM      #ClaimBatchVoids AS cbv
                    ) = 0
                BEGIN       
                    GOTO ProcessedStatus    
                END    
    
            IF @@error <> 0
                GOTO error    
                
                
                
            CREATE TABLE #ClaimGroups
                (
                  ClaimGroupId INT IDENTITY
                                   NOT NULL ,
                  BillingProviderId VARCHAR(35) NULL ,  -- 03/05/2014 Changed definition from NOT NULL to NULL   
                  ClientCoveragePlanId INT NOT NULL ,
                  ClientId INT NOT NULL ,
                  ClientAddress1 VARCHAR(30) ,
                  ClientAddress2 VARCHAR(30) ,
                  ClientCity VARCHAR(30) ,
                  ClientState CHAR(2) ,
                  ClientZip CHAR(25) ,
                  InsuredAddress1 VARCHAR(30) NULL ,
                  InsuredAddress2 VARCHAR(30) NULL ,
                  InsuredCity VARCHAR(30) NULL ,
                  InsuredState CHAR(2) NULL ,
                  InsuredZip VARCHAR(25) NULL ,
                  AuthorizationId INT NULL ,
                  ClinicianId INT NULL ,
                  MinClaimLineId INT NOT NULL ,
                  MaxClaimLineId INT NOT NULL ,
                  ClaimLineCount INT NOT NULL ,
                  IsICD10Claim CHAR(1) NULL ,
                  BillingCode VARCHAR(10) NULL ,
                  Modifier1 CHAR(2) NULL ,
                  Modifier2 CHAR(2) NULL ,
                  Modifier3 CHAR(2) NULL ,
                  Modifier4 CHAR(2) NULL
				  ,SubmissionReasonCode CHAR(1)  -- MAJ 4/10/18
                )    
    
            IF @@error <> 0
                GOTO error    
                        
            CREATE TABLE #ClaimGroupsDistinctDiagnoses
                (
                  ClaimGroupId INT NOT NULL ,
                  DiagnosesCount INT NOT NULL
                )    
    
            IF @@error <> 0
                GOTO error    
    
            CREATE TABLE #ClaimGroupCharges
                (
                  ClaimGroupId INT NOT NULL ,
                  TotalChargeAmount MONEY NULL ,
                  TotalPaidAmount MONEY NULL ,
                  TotalBalanceAmount MONEY NULL
                )    
    
            IF @@error <> 0
                GOTO error    
    
            CREATE TABLE #ClaimGroupsDiagnoses
                (
                  ClaimGroupId INT NULL ,
                  DiagnosisCode1 VARCHAR(20) NULL ,
                  DiagnosisCode2 VARCHAR(20) NULL ,
                  DiagnosisCode3 VARCHAR(20) NULL ,
                  DiagnosisCode4 VARCHAR(20) NULL
                )    
    
            IF @@error <> 0
                GOTO error    
-- Create Claim Groups    
-- 3/25 Added Claim Grouping and Diag Code SCSP. 
-- DECLARE @ExecuteClaimGrouperSCSP CHAR(1)
            IF EXISTS ( SELECT  *
                        FROM    sys.objects
                        WHERE   name = 'scsp_PMClaims837GrouperAndDiagnosisCodeCalculation'
                                AND type = 'P' )
                BEGIN 
                    EXEC dbo.scsp_PMClaims837GrouperAndDiagnosisCodeCalculation @CurrentUser = @ParamCurrentUser, @ClaimFormatId = @ClaimFormatId, @ClaimBatchId = @ParamClaimBatchId, @FormatType = @FormatType, @ExecuteClaimGrouperSCSP = @ExecuteClaimGrouperSCSP OUTPUT
                END 

            IF ( @ExecuteClaimGrouperSCSP = 'N' )
                BEGIN
                    
    
                    INSERT  INTO #ClaimGroups
                            ( BillingProviderId ,
                              ClientCoveragePlanId ,
                              ClientId ,
                              ClientAddress1 ,
                              ClientAddress2 ,
                              ClientCity ,
                              ClientState ,
                              ClientZip ,
                              InsuredAddress1 ,
                              InsuredAddress2 ,
                              InsuredCity ,
                              InsuredState ,
                              InsuredZip ,
                              AuthorizationId ,
                              ClinicianId ,
                              MinClaimLineId ,
                              MaxClaimLineId ,
                              ClaimLineCount ,
                              IsICD10Claim
							  ,SubmissionReasonCode  -- MAJ 4/10/18
							)
                            SELECT DISTINCT
                                    a.BillingProviderId ,
                                    a.ClientCoveragePlanId ,
                                    a.ClientId ,
                                    a.ClientAddress1 ,
                                    a.ClientAddress2 ,
                                    a.ClientCity ,
                                    a.ClientState ,
                                    a.ClientZip ,
                                    a.InsuredAddress1 ,
                                    a.InsuredAddress2 ,
                                    a.InsuredCity ,
                                    a.InsuredState ,
                                    a.InsuredZip ,
                                    a.AuthorizationId ,
                                    a.ClinicianId ,
                                    MIN(a.ClaimLineId) ,
                                    MAX(a.ClaimLineId) ,
                                    COUNT(DISTINCT a.ClaimLineId) ,
                                    ISNULL(b.IsICD10Code, 'N')
									,a.SubmissionReasonCode  -- MAJ 4/10/18
                            FROM    #ClaimLines a
                                    LEFT JOIN #ServiceDiagnosis b ON b.ClaimLineId = a.ClaimLineId
                            GROUP BY a.SubmissionReasonCode,  -- MAJ 4/10/18
									a.BillingProviderId ,
                                    a.ClientCoveragePlanId ,
                                    a.ClientId ,
                                    a.ClientAddress1 ,
                                    a.ClientAddress2 ,
                                    a.ClientCity ,
                                    a.ClientState ,
                                    a.ClientZip ,
                                    a.InsuredAddress1 ,
                                    a.InsuredAddress2 ,
                                    a.InsuredCity ,
                                    a.InsuredState ,
                                    a.InsuredZip ,
                                    a.AuthorizationId ,
                                    a.ClinicianId ,
                                    ISNULL(b.IsICD10Code, 'N')
                            ORDER BY a.SubmissionReasonCode,  -- MAJ 4/10/18
									a.BillingProviderId ,
                                    a.ClientCoveragePlanId ,
                                    a.ClientId ,
                                    a.AuthorizationId ,
                                    a.ClinicianId    
    
    
    --SELECT * FROM #ClaimGroups
    
    
                    IF @@error <> 0
                        GOTO error    

--SELECT * FROM #ClaimGroups
    
                    WHILE EXISTS ( SELECT   *
                                   FROM     #ClaimGroups
                                   WHERE    ClaimLineCount > 6 )
                        BEGIN    
    
                            INSERT  INTO #ClaimGroups
                                    ( BillingProviderId ,
                                      ClientCoveragePlanId ,
                                      ClientId ,
                                      ClientAddress1 ,
                                      ClientAddress2 ,
                                      ClientCity ,
                                      ClientState ,
                                      ClientZip ,
                                      InsuredAddress1 ,
                                      InsuredAddress2 ,
                                      InsuredCity ,
                                      InsuredState ,
                                      InsuredZip ,
                                      AuthorizationId ,
                                      ClinicianId ,
                                      MinClaimLineId ,
                                      MaxClaimLineId ,
                                      ClaimLineCount ,
                                      IsICD10Claim
									  ,SubmissionReasonCode  -- MAJ 4/10/18
									)
                                    SELECT  BillingProviderId ,
                                            ClientCoveragePlanId ,
                                            ClientId ,
                                            ClientAddress1 ,
                                            ClientAddress2 ,
                                            ClientCity ,
                                            ClientState ,
                                            ClientZip ,
                                            InsuredAddress1 ,
                                            InsuredAddress2 ,
                                            InsuredCity ,
                                            InsuredState ,
                                            InsuredZip ,
                                            AuthorizationId ,
                                            ClinicianId ,
                                            MinClaimLineId + 6 ,
                                            MaxClaimLineId ,
                                            MaxClaimLineId - ( MinClaimLineId + 6 ) + 1 ,
                                            IsICD10Claim
											,SubmissionReasonCode -- MAJ 4/10/18
                                    FROM    #ClaimGroups
                                    WHERE   ClaimLineCount > 6    
    
                            IF @@error <> 0
                                GOTO error    
    
                            UPDATE  a
                            SET     a.MaxClaimLineId = a.MinClaimLineId + 5 ,
                                    a.ClaimLineCount = 6
                            FROM    #ClaimGroups a
                                    JOIN #ClaimGroups b ON ( ISNULL(a.BillingProviderId, '') = ISNULL(b.BillingProviderId, '')
                                                             AND ISNULL(a.ClientCoveragePlanId, 0) = ISNULL(b.ClientCoveragePlanId, 0)
                                                             AND ISNULL(a.ClientId, 0) = ISNULL(b.ClientId, 0)
                                                             AND ISNULL(a.ClientAddress1, '') = ISNULL(b.ClientAddress1, '')
                                                             AND ISNULL(a.ClientAddress2, '') = ISNULL(b.ClientAddress2, '')
                                                             AND ISNULL(a.ClientCity, '') = ISNULL(b.ClientCity, '')
                                                             AND ISNULL(a.ClientState, '') = ISNULL(b.ClientState, '')
                                                             AND ISNULL(a.ClientZip, '') = ISNULL(b.ClientZip, '')
                                                             AND ISNULL(a.InsuredAddress1, '') = ISNULL(b.InsuredAddress1, '')
                                                             AND ISNULL(a.InsuredAddress2, '') = ISNULL(b.InsuredAddress2, '')
                                                             AND ISNULL(a.InsuredCity, '') = ISNULL(b.InsuredCity, '')
                                                             AND ISNULL(a.InsuredState, '') = ISNULL(b.InsuredState, '')
                                                             AND ISNULL(a.InsuredZip, '') = ISNULL(b.InsuredZip, '')
                                                             AND ISNULL(a.AuthorizationId, 0) = ISNULL(b.AuthorizationId, 0)
                                                             AND ISNULL(a.ClinicianId, 0) = ISNULL(b.ClinicianId, 0)
                                                             AND ISNULL(a.IsICD10Claim, 'N') = ISNULL(b.IsICD10Claim, 'N')
															 AND ISNULL(a.SubmissionReasonCode,'') = ISNULL(b.SubmissionReasonCode,'')  -- MAJ 4/10/18
                                                           )
                            WHERE   a.ClaimLineCount > 6
                                    AND a.MaxClaimLineId = b.MaxClaimLineId
                                    AND a.MinClaimLineId < b.MinClaimLineId    
    
                            IF @@error <> 0
                                GOTO error    
    
                        END    
    
-- Set Diagnoses    
                    
    
                    INSERT  INTO #ClaimGroupsDistinctDiagnoses
                            ( ClaimGroupId ,
                              DiagnosesCount
							)
                            SELECT  a.ClaimGroupId ,
                                    COUNT(DISTINCT b.DiagnosisCode)
                            FROM    #ClaimGroups a
                                    JOIN #ClaimLineDiagnoses837 b ON ( a.MinClaimLineId <= b.ClaimLineId
                                                                       AND a.MaxClaimLineId >= b.ClaimLineId
                                                                     )
                            WHERE   b.PrimaryDiagnosis = 'Y'
                                    AND ISNULL(a.IsICD10Claim, 'N') = ISNULL(b.IsICD10Code, 'N')
                            GROUP BY a.ClaimGroupId ,
                                    a.IsICD10Claim
    
                    IF @@error <> 0
                        GOTO error    
    
-- Split Claim Group if it has more than 4 primary distinct diagnoses    
                    WHILE EXISTS ( SELECT   *
                                   FROM     #ClaimGroupsDistinctDiagnoses
                                   WHERE    DiagnosesCount > 4 )
                        BEGIN     
    
                            INSERT  INTO #ClaimGroups
                                    ( BillingProviderId ,
                                      ClientCoveragePlanId ,
                                      ClientId ,
                                      ClientAddress1 ,
                                      ClientAddress2 ,
                                      ClientCity ,
                                      ClientState ,
                                      ClientZip ,
                                      InsuredAddress1 ,
                                      InsuredAddress2 ,
                                      InsuredCity ,
                                      InsuredState ,
                                      InsuredZip ,
                                      AuthorizationId ,
                                      ClinicianId ,
                                      MinClaimLineId ,
                                      MaxClaimLineId ,
                                      ClaimLineCount ,
                                      IsICD10Claim
									  ,SubmissionReasonCode -- MAJ 4/10/18
									)
                                    SELECT  a.BillingProviderId ,
                                            a.ClientCoveragePlanId ,
                                            a.ClientId ,
                                            a.ClientAddress1 ,
                                            a.ClientAddress2 ,
                                            a.ClientCity ,
                                            a.ClientState ,
                                            a.ClientZip ,
                                            a.InsuredAddress1 ,
                                            a.InsuredAddress2 ,
                                            a.InsuredCity ,
                                            a.InsuredState ,
                                            a.InsuredZip ,
                                            a.AuthorizationId ,
                                            a.ClinicianId ,
                                            a.MaxClaimLineId - 1 ,
                                            a.MaxClaimLineId ,
                                            1 ,
                                            a.IsICD10Claim
											,a.SubmissionReasonCode -- MAJ 4/10/18
                                    FROM    #ClaimGroups a
                                            JOIN #ClaimGroupsDistinctDiagnoses b ON ( a.ClaimGroupId = b.ClaimGroupId )
                                    WHERE   b.DiagnosesCount > 4    
    
                            IF @@error <> 0
                                GOTO error    
    
                            UPDATE  a
                            SET     a.MaxClaimLineId = a.MaxClaimLineId - 1
                            FROM    #ClaimGroups a
                                    JOIN #ClaimGroups b ON ( ISNULL(a.BillingProviderId, '') = ISNULL(b.BillingProviderId, '')
                                                             AND ISNULL(a.ClientCoveragePlanId, 0) = ISNULL(b.ClientCoveragePlanId, 0)
                                                             AND ISNULL(a.ClientId, 0) = ISNULL(b.ClientId, 0)
                                                             AND ISNULL(a.ClientAddress1, '') = ISNULL(b.ClientAddress1, '')
                                                             AND ISNULL(a.ClientAddress2, '') = ISNULL(b.ClientAddress2, '')
                                                             AND ISNULL(a.ClientCity, '') = ISNULL(b.ClientCity, '')
                                                             AND ISNULL(a.ClientState, '') = ISNULL(b.ClientState, '')
                                                             AND ISNULL(a.ClientZip, '') = ISNULL(b.ClientZip, '')
                                                             AND ISNULL(a.InsuredAddress1, '') = ISNULL(b.InsuredAddress1, '')
                                                             AND ISNULL(a.InsuredAddress2, '') = ISNULL(b.InsuredAddress2, '')
                                                             AND ISNULL(a.InsuredCity, '') = ISNULL(b.InsuredCity, '')
                                                             AND ISNULL(a.InsuredState, '') = ISNULL(b.InsuredState, '')
                                                             AND ISNULL(a.InsuredZip, '') = ISNULL(b.InsuredZip, '')
                                                             AND ISNULL(a.AuthorizationId, 0) = ISNULL(b.AuthorizationId, 0)
                                                             AND ISNULL(a.ClinicianId, 0) = ISNULL(b.ClinicianId, 0)
                                                             AND ISNULL(a.IsICD10Claim, 'N') = ISNULL(b.IsICD10Claim, 'N')
															 AND ISNULL(a.SubmissionReasonCode,'') = ISNULL(b.SubmissionReasonCode,'') -- MAJ 4/10/18
                                                           )
                                    JOIN #ClaimGroupsDistinctDiagnoses c ON ( a.ClaimGroupId = c.ClaimGroupId )
                            WHERE   c.DiagnosesCount > 4
                                    AND a.MaxClaimLineId = b.MaxClaimLineId
                                    AND a.MinClaimLineId < b.MinClaimLineId    
    
                            IF @@error <> 0
                                GOTO error    
    
                            DELETE  FROM #ClaimGroupsDistinctDiagnoses    
    
                            IF @@error <> 0
                                GOTO error    
    
                            INSERT  INTO #ClaimGroupsDistinctDiagnoses
                                    ( ClaimGroupId ,
                                      DiagnosesCount
									)
                                    SELECT  a.ClaimGroupId ,
                                            COUNT(DISTINCT b.DiagnosisCode)
                                    FROM    #ClaimGroups a
                                            JOIN #ClaimLineDiagnoses837 b ON ( a.MinClaimLineId <= b.ClaimLineId
                                                                               AND a.MaxClaimLineId >= b.ClaimLineId
                                                                             )
                                    WHERE   b.PrimaryDiagnosis = 'Y'
                                            AND ISNULL(a.IsICD10Claim, 'N') = ISNULL(b.IsICD10Code, 'N')
                                    GROUP BY a.ClaimGroupId ,
                                            a.IsICD10Claim 
    
                            IF @@error <> 0
                                GOTO error    
    
                        END    
    
                    INSERT  INTO #ClaimGroupsDiagnoses
                            ( ClaimGroupId ,
                              DiagnosisCode1
							)
                            SELECT  a.ClaimGroupId ,
                                    MAX(b.DiagnosisCode)
                            FROM    #ClaimGroups a
                                    JOIN #ClaimLineDiagnoses837 b ON ( a.MinClaimLineId <= b.ClaimLineId
                                                                       AND a.MaxClaimLineId >= b.ClaimLineId
                                                                     )
                            WHERE   b.PrimaryDiagnosis = 'Y'
                                    AND ISNULL(a.IsICD10Claim, 'N') = ISNULL(b.IsICD10Code, 'N')
                            GROUP BY a.ClaimGroupId ,
                                    a.IsICD10Claim   
    
                    IF @@error <> 0
                        GOTO error    
    
                    UPDATE  c
                    SET     c.DiagnosisCode2 = b.DiagnosisCode
                    FROM    #ClaimGroupsDiagnoses c
                            JOIN #ClaimGroups a ON ( c.ClaimGroupId = a.ClaimGroupId )
                            JOIN #ClaimLineDiagnoses837 b ON ( a.MinClaimLineId <= b.ClaimLineId
                                                               AND a.MaxClaimLineId >= b.ClaimLineId
                                                             )
                    WHERE   b.PrimaryDiagnosis = 'Y'
                            AND ISNULL(a.IsICD10Claim, 'N') = ISNULL(b.IsICD10Code, 'N')
                            AND c.DiagnosisCode1 <> b.DiagnosisCode    
    
                    IF @@error <> 0
                        GOTO error    
    
                    UPDATE  c
                    SET     c.DiagnosisCode3 = b.DiagnosisCode
                    FROM    #ClaimGroupsDiagnoses c
                            JOIN #ClaimGroups a ON ( c.ClaimGroupId = a.ClaimGroupId )
                            JOIN #ClaimLineDiagnoses837 b ON ( a.MinClaimLineId <= b.ClaimLineId
                                                               AND a.MaxClaimLineId >= b.ClaimLineId
                                                             )
                    WHERE   b.PrimaryDiagnosis = 'Y'
                            AND ISNULL(a.IsICD10Claim, 'N') = ISNULL(b.IsICD10Code, 'N')
                            AND c.DiagnosisCode1 <> b.DiagnosisCode
                            AND c.DiagnosisCode2 <> b.DiagnosisCode    
    
                    IF @@error <> 0
                        GOTO error    
    
                    UPDATE  c
                    SET     c.DiagnosisCode4 = b.DiagnosisCode
                    FROM    #ClaimGroupsDiagnoses c
                            JOIN #ClaimGroups a ON ( c.ClaimGroupId = a.ClaimGroupId )
                            JOIN #ClaimLineDiagnoses837 b ON ( a.MinClaimLineId <= b.ClaimLineId
                                                               AND a.MaxClaimLineId >= b.ClaimLineId
                                                             )
                    WHERE   b.PrimaryDiagnosis = 'Y'
                            AND ISNULL(a.IsICD10Claim, 'N') = ISNULL(b.IsICD10Code, 'N')
                            AND c.DiagnosisCode1 <> b.DiagnosisCode
                            AND c.DiagnosisCode2 <> b.DiagnosisCode
                            AND c.DiagnosisCode3 <> b.DiagnosisCode    
    
                    IF @@error <> 0
                        GOTO error    
    
                    UPDATE  c
                    SET     c.DiagnosisCode4 = b.DiagnosisCode
                    FROM    #ClaimGroupsDiagnoses c
                            JOIN #ClaimGroups a ON ( c.ClaimGroupId = a.ClaimGroupId )
                            JOIN #ClaimLineDiagnoses837 b ON ( a.MinClaimLineId <= b.ClaimLineId
                                                               AND a.MaxClaimLineId >= b.ClaimLineId
                                                             )
                    WHERE   b.PrimaryDiagnosis = 'Y'
                            AND ISNULL(a.IsICD10Claim, 'N') = ISNULL(b.IsICD10Code, 'N')
                            AND c.DiagnosisCode1 <> b.DiagnosisCode
                            AND c.DiagnosisCode2 <> b.DiagnosisCode
                            AND c.DiagnosisCode3 <> b.DiagnosisCode    
    
                    IF @@error <> 0
                        GOTO error    
    
-- Non Primary Diagnosis    
                    UPDATE  c
                    SET     c.DiagnosisCode2 = b.DiagnosisCode
                    FROM    #ClaimGroupsDiagnoses c
                            JOIN #ClaimGroups a ON ( c.ClaimGroupId = a.ClaimGroupId )
                            JOIN #ClaimLineDiagnoses837 b ON ( a.MinClaimLineId <= b.ClaimLineId
                                                               AND a.MaxClaimLineId >= b.ClaimLineId
                                                             )
                    WHERE   ISNULL(b.PrimaryDiagnosis, '') = ''
                            AND ISNULL(a.IsICD10Claim, 'N') = ISNULL(b.IsICD10Code, 'N')
                            AND c.DiagnosisCode1 <> b.DiagnosisCode
                            AND c.DiagnosisCode2 IS NULL    
    
                    IF @@error <> 0
                        GOTO error    
    
                    UPDATE  c
                    SET     c.DiagnosisCode3 = b.DiagnosisCode
                    FROM    #ClaimGroupsDiagnoses c
                            JOIN #ClaimGroups a ON ( c.ClaimGroupId = a.ClaimGroupId )
                            JOIN #ClaimLineDiagnoses837 b ON ( a.MinClaimLineId <= b.ClaimLineId
                                                               AND a.MaxClaimLineId >= b.ClaimLineId
                                                             )
                    WHERE   ISNULL(b.PrimaryDiagnosis, '') = ''
                            AND ISNULL(a.IsICD10Claim, 'N') = ISNULL(b.IsICD10Code, 'N')
                            AND c.DiagnosisCode1 <> b.DiagnosisCode
                            AND c.DiagnosisCode2 <> b.DiagnosisCode
                            AND c.DiagnosisCode3 IS NULL    
    
                    IF @@error <> 0
                        GOTO error    
    
                    UPDATE  c
                    SET     c.DiagnosisCode4 = b.DiagnosisCode
                    FROM    #ClaimGroupsDiagnoses c
                            JOIN #ClaimGroups a ON ( c.ClaimGroupId = a.ClaimGroupId )
                            JOIN #ClaimLineDiagnoses837 b ON ( a.MinClaimLineId <= b.ClaimLineId
                                                               AND a.MaxClaimLineId >= b.ClaimLineId
                                                             )
                    WHERE   ISNULL(b.PrimaryDiagnosis, '') = ''
                            AND ISNULL(a.IsICD10Claim, 'N') = ISNULL(b.IsICD10Code, 'N')
                            AND c.DiagnosisCode1 <> b.DiagnosisCode
                            AND c.DiagnosisCode2 <> b.DiagnosisCode
                            AND c.DiagnosisCode3 <> b.DiagnosisCode
                            AND c.DiagnosisCode4 IS NULL    
    
                    IF @@error <> 0
                        GOTO error    
    
-- Update Diagnosis Pointers    
                    UPDATE  b
                    SET     b.DiagnosisPointer = '1'
                    FROM    #ClaimGroupsDiagnoses z
                            JOIN #ClaimGroups a ON ( a.ClaimGroupId = z.ClaimGroupId )
                            JOIN #ClaimLines b ON ( ISNULL(a.BillingProviderId, '') = ISNULL(b.BillingProviderId, '')
                                                    AND ISNULL(a.ClientCoveragePlanId, 0) = ISNULL(b.ClientCoveragePlanId, 0)
                                                    AND ISNULL(a.ClientId, 0) = ISNULL(b.ClientId, 0)
                                                    AND ISNULL(a.ClientAddress1, '') = ISNULL(b.ClientAddress1, '')
                                                    AND ISNULL(a.ClientAddress2, '') = ISNULL(b.ClientAddress2, '')
                                                    AND ISNULL(a.ClientCity, '') = ISNULL(b.ClientCity, '')
                                                    AND ISNULL(a.ClientState, '') = ISNULL(b.ClientState, '')
                                                    AND ISNULL(a.ClientZip, '') = ISNULL(b.ClientZip, '')
                                                    AND ISNULL(a.InsuredAddress1, '') = ISNULL(b.InsuredAddress1, '')
                                                    AND ISNULL(a.InsuredAddress2, '') = ISNULL(b.InsuredAddress2, '')
                                                    AND ISNULL(a.InsuredCity, '') = ISNULL(b.InsuredCity, '')
                                                    AND ISNULL(a.InsuredState, '') = ISNULL(b.InsuredState, '')
                                                    AND ISNULL(a.InsuredZip, '') = ISNULL(b.InsuredZip, '')
                                                    AND ISNULL(a.AuthorizationId, 0) = ISNULL(b.AuthorizationId, 0)
                                                    AND ISNULL(a.ClinicianId, 0) = ISNULL(b.ClinicianId, 0)
													AND ISNULL(a.SubmissionReasonCode,'') = ISNULL(b.SubmissionReasonCode,'') -- MAJ 4/10/18
                                                    AND a.MinClaimLineId <= b.ClaimLineId
                                                    AND a.MaxClaimLineId >= b.ClaimLineId
                                                  )
                            JOIN #ClaimLineDiagnoses837 c ON ( c.ClaimLineId = b.ClaimLineId )
                    WHERE   c.DiagnosisCode = z.DiagnosisCode1
                            AND ISNULL(a.IsICD10Claim, 'N') = ISNULL(c.IsICD10Code, 'N')
    
                    IF @@error <> 0
                        GOTO error    
    
                    UPDATE  b
                    SET     b.DiagnosisPointer = CASE WHEN b.DiagnosisPointer IS NULL THEN '2'
                                                      ELSE b.DiagnosisPointer + ',2'
                                                 END
                    FROM    #ClaimGroupsDiagnoses z
                            JOIN #ClaimGroups a ON ( a.ClaimGroupId = z.ClaimGroupId )
                            JOIN #ClaimLines b ON ( ISNULL(a.BillingProviderId, '') = ISNULL(b.BillingProviderId, '')
                                                    AND ISNULL(a.ClientCoveragePlanId, 0) = ISNULL(b.ClientCoveragePlanId, 0)
                                                    AND ISNULL(a.ClientId, 0) = ISNULL(b.ClientId, 0)
                                                    AND ISNULL(a.ClientAddress1, '') = ISNULL(b.ClientAddress1, '')
                                                    AND ISNULL(a.ClientAddress2, '') = ISNULL(b.ClientAddress2, '')
                                                    AND ISNULL(a.ClientCity, '') = ISNULL(b.ClientCity, '')
                                                    AND ISNULL(a.ClientState, '') = ISNULL(b.ClientState, '')
                                                    AND ISNULL(a.ClientZip, '') = ISNULL(b.ClientZip, '')
                                                    AND ISNULL(a.InsuredAddress1, '') = ISNULL(b.InsuredAddress1, '')
                                                    AND ISNULL(a.InsuredAddress2, '') = ISNULL(b.InsuredAddress2, '')
                                                    AND ISNULL(a.InsuredCity, '') = ISNULL(b.InsuredCity, '')
                                                    AND ISNULL(a.InsuredState, '') = ISNULL(b.InsuredState, '')
                                                    AND ISNULL(a.InsuredZip, '') = ISNULL(b.InsuredZip, '')
                                                    AND ISNULL(a.AuthorizationId, 0) = ISNULL(b.AuthorizationId, 0)
                                                    AND ISNULL(a.ClinicianId, 0) = ISNULL(b.ClinicianId, 0)
													AND ISNULL(a.SubmissionReasonCode,'') = ISNULL(b.SubmissionReasonCode,'') -- MAJ 4/10/18
                                                    AND a.MinClaimLineId <= b.ClaimLineId
                                                    AND a.MaxClaimLineId >= b.ClaimLineId
                                                  )
                            JOIN #ClaimLineDiagnoses837 c ON ( c.ClaimLineId = b.ClaimLineId )
                    WHERE   c.DiagnosisCode = z.DiagnosisCode2
                            AND ISNULL(a.IsICD10Claim, 'N') = ISNULL(c.IsICD10Code, 'N')
    
                    IF @@error <> 0
                        GOTO error    
    
                    UPDATE  b
                    SET     b.DiagnosisPointer = CASE WHEN b.DiagnosisPointer IS NULL THEN '3'
                                                      ELSE b.DiagnosisPointer + ',3'
                                                 END
                    FROM    #ClaimGroupsDiagnoses z
                            JOIN #ClaimGroups a ON ( a.ClaimGroupId = z.ClaimGroupId )
                            JOIN #ClaimLines b ON ( ISNULL(a.BillingProviderId, '') = ISNULL(b.BillingProviderId, '')
                                                    AND ISNULL(a.ClientCoveragePlanId, 0) = ISNULL(b.ClientCoveragePlanId, 0)
                                                    AND ISNULL(a.ClientId, 0) = ISNULL(b.ClientId, 0)
                                                    AND ISNULL(a.ClientAddress1, '') = ISNULL(b.ClientAddress1, '')
                                                    AND ISNULL(a.ClientAddress2, '') = ISNULL(b.ClientAddress2, '')
                                                    AND ISNULL(a.ClientCity, '') = ISNULL(b.ClientCity, '')
                                                    AND ISNULL(a.ClientState, '') = ISNULL(b.ClientState, '')
                                                    AND ISNULL(a.ClientZip, '') = ISNULL(b.ClientZip, '')
                                                    AND ISNULL(a.InsuredAddress1, '') = ISNULL(b.InsuredAddress1, '')
                                                    AND ISNULL(a.InsuredAddress2, '') = ISNULL(b.InsuredAddress2, '')
                                                    AND ISNULL(a.InsuredCity, '') = ISNULL(b.InsuredCity, '')
                                                    AND ISNULL(a.InsuredState, '') = ISNULL(b.InsuredState, '')
                                                    AND ISNULL(a.InsuredZip, '') = ISNULL(b.InsuredZip, '')
                                                    AND ISNULL(a.AuthorizationId, 0) = ISNULL(b.AuthorizationId, 0)
                                                    AND ISNULL(a.ClinicianId, 0) = ISNULL(b.ClinicianId, 0)
													AND ISNULL(a.SubmissionReasonCode,'') = ISNULL(b.SubmissionReasonCode,'') -- MAJ 4/10/18
                                                    AND a.MinClaimLineId <= b.ClaimLineId
                                                    AND a.MaxClaimLineId >= b.ClaimLineId
                                                  )
                            JOIN #ClaimLineDiagnoses837 c ON ( c.ClaimLineId = b.ClaimLineId )
                    WHERE   c.DiagnosisCode = z.DiagnosisCode3
                            AND ISNULL(a.IsICD10Claim, 'N') = ISNULL(c.IsICD10Code, 'N')
    
                    IF @@error <> 0
                        GOTO error    
    
                    UPDATE  b
                    SET     b.DiagnosisPointer = CASE WHEN b.DiagnosisPointer IS NULL THEN '4'
                                                      ELSE b.DiagnosisPointer + ',4'
                                                 END
                    FROM    #ClaimGroupsDiagnoses z
                            JOIN #ClaimGroups a ON ( a.ClaimGroupId = z.ClaimGroupId )
                            JOIN #ClaimLines b ON ( ISNULL(a.BillingProviderId, '') = ISNULL(b.BillingProviderId, '')
                                                    AND ISNULL(a.ClientCoveragePlanId, 0) = ISNULL(b.ClientCoveragePlanId, 0)
                                                    AND ISNULL(a.ClientId, 0) = ISNULL(b.ClientId, 0)
                                                    AND ISNULL(a.ClientAddress1, '') = ISNULL(b.ClientAddress1, '')
                                                    AND ISNULL(a.ClientAddress2, '') = ISNULL(b.ClientAddress2, '')
                                                    AND ISNULL(a.ClientCity, '') = ISNULL(b.ClientCity, '')
                                                    AND ISNULL(a.ClientState, '') = ISNULL(b.ClientState, '')
                                                    AND ISNULL(a.ClientZip, '') = ISNULL(b.ClientZip, '')
                                                    AND ISNULL(a.InsuredAddress1, '') = ISNULL(b.InsuredAddress1, '')
                                                    AND ISNULL(a.InsuredAddress2, '') = ISNULL(b.InsuredAddress2, '')
                                                    AND ISNULL(a.InsuredCity, '') = ISNULL(b.InsuredCity, '')
                                                    AND ISNULL(a.InsuredState, '') = ISNULL(b.InsuredState, '')
                                                    AND ISNULL(a.InsuredZip, '') = ISNULL(b.InsuredZip, '')
                                                    AND ISNULL(a.AuthorizationId, 0) = ISNULL(b.AuthorizationId, 0)
                                                    AND ISNULL(a.ClinicianId, 0) = ISNULL(b.ClinicianId, 0)
													AND ISNULL(a.SubmissionReasonCode,'') = ISNULL(b.SubmissionReasonCode,'') -- MAJ 4/10/18
                                                    AND a.MinClaimLineId <= b.ClaimLineId
                                                    AND a.MaxClaimLineId >= b.ClaimLineId
                                                  )
                            JOIN #ClaimLineDiagnoses837 c ON ( c.ClaimLineId = b.ClaimLineId )
                            JOIN #ServiceDiagnosis sd ON sd.ClaimLineId = b.ClaimLineId
                                                         AND ISNULL(a.IsICD10Claim, 'N') = ISNULL(sd.IsICD10Code, 'N')
                    WHERE   c.DiagnosisCode = z.DiagnosisCode4
                            AND ISNULL(a.IsICD10Claim, 'N') = ISNULL(c.IsICD10Code, 'N')
    
                    IF @@error <> 0
                        GOTO error    
    
                    INSERT  INTO #ClaimGroupCharges
                            ( ClaimGroupId ,
                              TotalChargeAmount ,
                              TotalPaidAmount ,
                              TotalBalanceAmount
							)
                            SELECT  a.ClaimGroupId ,
                                    SUM(ROUND(b.ChargeAmount, 2)) ,
                                    SUM(b.PaidAmount) ,
                                    SUM(ROUND(b.ChargeAmount, 2) - b.PaidAmount - b.Adjustments)
                            FROM    #ClaimGroups a
                                    JOIN #ClaimLines b ON ( ISNULL(a.BillingProviderId, '') = ISNULL(b.BillingProviderId, '')
                                                            AND ISNULL(a.ClientCoveragePlanId, 0) = ISNULL(b.ClientCoveragePlanId, 0)
                                                            AND ISNULL(a.ClientId, 0) = ISNULL(b.ClientId, 0)
                                                            AND ISNULL(a.ClientAddress1, '') = ISNULL(b.ClientAddress1, '')
                                                            AND ISNULL(a.ClientAddress2, '') = ISNULL(b.ClientAddress2, '')
                                                            AND ISNULL(a.ClientCity, '') = ISNULL(b.ClientCity, '')
                                                            AND ISNULL(a.ClientState, '') = ISNULL(b.ClientState, '')
                                                            AND ISNULL(a.ClientZip, '') = ISNULL(b.ClientZip, '')
                                                            AND ISNULL(a.InsuredAddress1, '') = ISNULL(b.InsuredAddress1, '')
                                                            AND ISNULL(a.InsuredAddress2, '') = ISNULL(b.InsuredAddress2, '')
                                                            AND ISNULL(a.InsuredCity, '') = ISNULL(b.InsuredCity, '')
                                                            AND ISNULL(a.InsuredState, '') = ISNULL(b.InsuredState, '')
                                                            AND ISNULL(a.InsuredZip, '') = ISNULL(b.InsuredZip, '')
                                                            AND ISNULL(a.AuthorizationId, 0) = ISNULL(b.AuthorizationId, 0)
                                                            AND ISNULL(a.ClinicianId, 0) = ISNULL(b.ClinicianId, 0)
															AND ISNULL(a.SubmissionReasonCode,'') = ISNULL(b.SubmissionReasonCode,'') -- MAJ 4/10/18
                                                            AND a.MinClaimLineId <= b.ClaimLineId
                                                            AND a.MaxClaimLineId >= b.ClaimLineId
                                                          )
                            GROUP BY a.ClaimGroupId ,
                                    a.IsICD10Claim    
    
                    IF @@error <> 0
                        GOTO error    
                END
    
-- Update Final Data    
            INSERT  INTO #ClaimGroupsData
                    ( ClaimGroupId ,
                      PayerNameAndAddress ,
                      Field1Medicare ,
                      Field1Medicaid ,
                      Field1Champus ,
                      Field1Champva ,
                      Field1GroupHealthPlan ,
                      Field1GroupFeca ,
                      Field1GroupOther ,
                      Field1aInsuredNumber ,
                      Field2PatientName ,
                      Field3PatientDOBMM ,
                      Field3PatientDOBDD ,
                      Field3PatientDOBYY ,
                      Field3PatientMale ,
                      Field3PatientFemale ,
                      Field4InsuredName ,
                      Field5PatientAddress ,
                      Field5PatientCity ,
                      Field5PatientState ,
                      Field5PatientZip ,
                      Field5PatientPhone ,
                      Field6RelationshipSelf ,
                      Field6RelationshipSpouse ,
                      Field6RelationshipChild ,
                      Field6RelationshipOther ,
                      Field7InsuredAddress ,
                      Field7InsuredCity ,
                      Field7InsuredState ,
                      Field7InsuredZip ,
                      Field7InsuredPhone ,
                      Field8PatientStatusSingle ,
                      Field8PatientStatusMarried ,
                      Field8PatientStatusOther ,
                      Field8PatientStatusEmployed ,
                      Field8PatientStatusFullTime ,
                      Field8PatientStatusPartTime ,
                      Field10aYes ,
                      Field10aNo ,
                      Field10bYes ,
                      Field10bNo ,
                      Field10cYes ,
                      Field10cNo ,
                      Field11InsuredGroupNumber ,
                      Field11InsuredDOBMM ,
                      Field11InsuredDOBDD ,
                      Field11InsuredDOBYY ,
                      Field11InsuredMale ,
                      Field11InsuredFemale ,
                      Field11InsuredEmployer ,
                      Field11InsuredPlan ,
                      Field11OtherPlanYes ,
                      Field11OtherPlanNo ,
                      Field12Signed ,
                      Field12Date ,
                      Field13Signed ,
                      Field17aReferringIdQualifier ,
                      Field17aReferringId ,
                      Field17bReferringNPI ,
                      Field17ReferringName ,
                      Field21Diagnosis11 ,
                      Field21Diagnosis12 ,
                      Field21Diagnosis21 ,
                      Field21Diagnosis22 ,
                      Field21Diagnosis31 ,
                      Field21Diagnosis32 ,
                      Field21Diagnosis41 ,
                      Field21Diagnosis42 ,
                      Field21ICDIndicator ,
                      Field22MedicaidResubmissionCode ,
                      Field22MedicaidReferenceNumber ,
                      Field23AuthorizationNumber ,
                      Field25TaxId ,
                      Field25SSN ,
                      Field25EIN ,
                      Field26PatientAccountNo ,
                      Field27AssignmentYes ,
                      Field27AssignmentNo ,
                      Field28fTotalCharges1 ,
                      Field28fTotalCharges2 ,
                      Field29Paid1 ,
                      Field29Paid2 ,
                      Field30Balance1 ,
                      Field30Balance2 ,
                      Field31Signed ,
                      Field31Date ,
                      Field32Facility ,
                      Field32aFacilityNPI ,
                      Field32bFacilityProviderId ,
                      Field33BillingPhone ,
                      Field33BillingAddress ,
                      Field33aNPI ,
                      Field33bBillingProviderId
					)
                    SELECT  a.ClaimGroupId ,
                            MAX(ISNULL(RTRIM(b.PayerAddressHeading) + CHAR(13) + CHAR(10), RTRIM('')) + RTRIM(b.PayerAddress1) + ISNULL(CHAR(13) + CHAR(10) + RTRIM(b.PayerAddress2), RTRIM('')) + CHAR(13) + CHAR(10) + ISNULL(RTRIM(b.PayerCity), RTRIM('')) + ', ' + ISNULL(RTRIM(b.PayerState), '') + ' ' + ISNULL(RTRIM(b.PayerZip), '')) ,
                            MAX(CASE WHEN b.MedicarePayer = 'Y' THEN 'X'
                                     ELSE NULL
                                END) ,
                            MAX(CASE WHEN b.MedicaidPayer = 'Y' THEN 'X'
                                     ELSE NULL
                                END) ,
                            NULL ,
                            NULL ,
                            NULL ,
                            NULL ,
                            MAX(CASE WHEN ISNULL(b.MedicarePayer, 'N') = 'N'
                                          AND ISNULL(b.MedicaidPayer, 'N') = 'N' THEN 'X'
                                     ELSE NULL
                                END) ,
                            MAX(b.InsuredId) ,
                            MAX(b.ClientLastName + ', ' + b.ClientFirstname + ' ' + ISNULL(SUBSTRING(RTRIM(b.ClientMiddleName), 1, 1), RTRIM(''))) ,
                            MAX(CASE WHEN DATEPART(mm, b.ClientDOB) < 10 THEN '0'
                                     ELSE RTRIM('')
                                END + CONVERT(VARCHAR, DATEPART(mm, b.ClientDOB))) ,
                            MAX(CASE WHEN DATEPART(dd, b.ClientDOB) < 10 THEN '0'
                                     ELSE RTRIM('')
                                END + CONVERT(VARCHAR, DATEPART(dd, b.ClientDOB))) ,
                            MAX(CONVERT(VARCHAR, DATEPART(yy, b.ClientDOB))) ,
                            MAX(CASE WHEN b.ClientSex = 'M' THEN 'X'
                                     ELSE NULL
                                END) ,
                            MAX(CASE WHEN b.ClientSex = 'F' THEN 'X'
                                     ELSE NULL
                                END) ,
                            MAX(b.InsuredLastName + ', ' + b.InsuredFirstName + ' ' + ISNULL(SUBSTRING(RTRIM(b.InsuredMiddleName), 1, 1), RTRIM(''))) ,
                            MAX(b.ClientAddress1) ,
                            MAX(b.ClientCity) ,
                            MAX(b.ClientState) ,
                            MAX(b.ClientZip) ,
                            MAX(CASE WHEN LEN(b.ClientHomePhone) <= 7 THEN '     ' + SUBSTRING(b.ClientHomePhone, 1, 3) + '-' + SUBSTRING(b.ClientHomePhone, 4, 4)
                                     WHEN LEN(b.ClientHomePhone) = 10 THEN SUBSTRING(b.ClientHomePhone, 1, 3) + '   ' + SUBSTRING(b.ClientHomePhone, 4, 3) + '-' + SUBSTRING(b.ClientHomePhone, 7, 4)
                                     ELSE b.ClientHomePhone
                                END) ,
                            MAX(CASE WHEN b.ClientIsSubscriber = 'Y' THEN 'X'
                                     ELSE NULL
                                END) ,
                            MAX(CASE WHEN b.InsuredRelationCode = '01' THEN 'X'
                                     ELSE NULL
                                END) ,
                            MAX(CASE WHEN b.InsuredRelationCode = '19' THEN 'X'
                                     ELSE NULL
                                END) ,
                            MAX(CASE WHEN ISNULL(b.ClientIsSubscriber, 'N') = 'N'
                                          AND ISNULL(b.InsuredRelationCode, '') NOT IN ( '01', '19' ) THEN 'X'
                                     ELSE NULL
                                END) ,
                            MAX(b.InsuredAddress1) ,
                            MAX(b.InsuredCity) ,
                            MAX(b.InsuredState) ,
                            MAX(b.InsuredZip) ,
                            MAX(CASE WHEN LEN(b.InsuredHomePhone) = 7 THEN '     ' + SUBSTRING(b.InsuredHomePhone, 1, 3) + '-' + SUBSTRING(b.InsuredHomePhone, 4, 4)
                                     WHEN LEN(b.InsuredHomePhone) = 10 THEN SUBSTRING(b.InsuredHomePhone, 1, 3) + '    ' + SUBSTRING(b.InsuredHomePhone, 4, 3) + '-' + SUBSTRING(b.InsuredHomePhone, 7, 4)
                                     ELSE b.InsuredHomePhone
                                END) ,
                            MAX(CASE WHEN b.MaritalStatus IN ( 10075, 10078 ) THEN 'X'
                                     ELSE NULL
                                END) ,
                            MAX(CASE WHEN b.MaritalStatus IN ( 10076 ) THEN 'X'
                                     ELSE NULL
                                END) ,
                            MAX(CASE WHEN b.MaritalStatus NOT IN ( 10075, 10076, 10078 ) THEN 'X'
                                     ELSE NULL
                                END) ,
                            MAX(CASE WHEN b.EmploymentStatus IN ( 10053, 10213, 10232 ) THEN 'X'
                                     ELSE NULL
                                END) ,
                            NULL ,
                            NULL ,
                            NULL ,
                            'X' ,
                            NULL ,
                            'X' ,
                            NULL ,
                            'X' ,
                            MAX(b.GroupNumber) ,
                            MAX(CASE WHEN DATEPART(mm, b.InsuredDOB) < 10 THEN '0'
                                     ELSE RTRIM('')
                                END + CONVERT(VARCHAR, DATEPART(mm, b.InsuredDOB))) ,
                            MAX(CASE WHEN DATEPART(dd, b.InsuredDOB) < 10 THEN '0'
                                     ELSE RTRIM('')
                                END + CONVERT(VARCHAR, DATEPART(dd, b.InsuredDOB))) ,
                            MAX(CONVERT(VARCHAR, DATEPART(yy, b.InsuredDOB))) ,
                            MAX(CASE WHEN b.InsuredSex = 'M' THEN 'X'
                                     ELSE NULL
                                END) ,
                            MAX(CASE WHEN b.InsuredSex = 'F' THEN 'X'
                                     ELSE NULL
                                END) ,
                            NULL ,
                            MAX(b.PayerName) ,
                            NULL ,
                            'X' ,
                            'SIGNATURE ON FILE' ,
                            MAX(CONVERT(VARCHAR, b.RegistrationDate, 101)) ,
                            'SIGNATURE ON FILE' ,
                            MAX(b.ReferringProviderIdType) ,
                            MAX(b.ReferringProviderId) ,
                            MAX(b.ReferringProviderNPI) ,
                            MAX(( ISNULL(b.ReferringProviderFirstName, '') ) + ' ' + ( ISNULL(b.ReferringProviderLastName, '') )) ,
                            SUBSTRING(c.DiagnosisCode1, 1, 3) ,
                            CASE WHEN c.DiagnosisCode1 LIKE '%.%' THEN SUBSTRING(c.DiagnosisCode1, CHARINDEX('.', c.DiagnosisCode1) + 1, 4)
                                 ELSE NULL
                            END ,
                            SUBSTRING(c.DiagnosisCode2, 1, 3) ,
                            CASE WHEN c.DiagnosisCode2 LIKE '%.%' THEN SUBSTRING(c.DiagnosisCode2, CHARINDEX('.', c.DiagnosisCode2) + 1, 4)
                                 ELSE NULL
                            END ,
                            SUBSTRING(c.DiagnosisCode3, 1, 3) ,
                            CASE WHEN c.DiagnosisCode3 LIKE '%.%' THEN SUBSTRING(c.DiagnosisCode3, CHARINDEX('.', c.DiagnosisCode3) + 1, 4)
                                 ELSE NULL
                            END ,
                            SUBSTRING(c.DiagnosisCode4, 1, 3) ,
                            CASE WHEN c.DiagnosisCode4 LIKE '%.%' THEN SUBSTRING(c.DiagnosisCode4, CHARINDEX('.', c.DiagnosisCode4) + 1, 4)
                                 ELSE NULL
                            END ,
                            CASE WHEN MAX(ISNULL(b2.IsICD10Code, 'N')) = 'N' THEN '9'
                                 ELSE '10'
                            END ,
                            CASE WHEN MAX(a.SubmissionReasonCode) IN ('7','8') THEN MAX(a.SubmissionReasonCode) ELSE NULL END ,  -- MAJ 4/10/18
                            CASE WHEN MAX(a.SubmissionReasonCode) IN ('7','8') THEN MAX(b.PayerClaimControlNumber) ELSE NULL END ,  -- MAJ 4/10/18
                            MAX(b.AuthorizationNumber) ,
                            MAX(b.PayToProviderTaxId) ,
                            NULL ,
                            'X' ,
                            MAX(CONVERT(VARCHAR, b.ClientId)) ,
                            'X' ,
                            NULL ,
                            -- 10/26/2016 - T.Remisoski - Round Charges, Payments, Balance Amounts
                            CONVERT(VARCHAR, CONVERT(INT, FLOOR(ROUND(d.TotalChargeAmount, 2)))) ,
                            CASE WHEN CONVERT(INT, d.TotalChargeAmount * 100) % 100 < 10 THEN '0' + CONVERT(VARCHAR, CONVERT(INT, d.TotalChargeAmount * 100) % 100)
                                 ELSE CONVERT(VARCHAR, CONVERT(INT, d.TotalChargeAmount * 100) % 100)
                            END ,
                            CONVERT(VARCHAR, CONVERT(INT, FLOOR(ROUND(d.TotalPaidAmount, 2)))) ,
                            CASE WHEN CONVERT(INT, d.TotalPaidAmount * 100) % 100 < 10 THEN '0' + CONVERT(VARCHAR, CONVERT(INT, d.TotalPaidAmount * 100) % 100)
                                 ELSE CONVERT(VARCHAR, CONVERT(INT, d.TotalPaidAmount * 100) % 100)
                            END ,
                            CONVERT(VARCHAR, CONVERT(INT, FLOOR(ROUND(d.TotalBalanceAmount, 2)))) ,
                            CASE WHEN CONVERT(INT, d.TotalBalanceAmount * 100) % 100 < 10 THEN '0' + CONVERT(VARCHAR, CONVERT(INT, d.TotalBalanceAmount * 100) % 100)
                                 ELSE CONVERT(VARCHAR, CONVERT(INT, d.TotalBalanceAmount * 100) % 100)
                            END ,
                            MAX(SUBSTRING(RTRIM(e.FirstName) + ' ' + RTRIM(e.LastName) + ' ' + ISNULL(RTRIM(f.CodeName), RTRIM('')), 1, 30)) ,
                            CONVERT(VARCHAR, GETDATE(), 101) ,
                            MAX(b.FacilityName + CHAR(13) + CHAR(10) + b.FacilityAddress1 + CHAR(13) + CHAR(10) + CASE WHEN b.FacilityAddress2 IS NOT NULL THEN b.FacilityAddress2 + CHAR(13) + CHAR(10)
                                                                                                                       ELSE RTRIM('')
                                                                                                                  END + b.FacilityCity + ', ' + b.FacilityState + ' ' + b.FacilityZip + CHAR(13) + CHAR(10) + CASE WHEN LEN(b.FacilityPhone) = 7 THEN SUBSTRING(b.FacilityPhone, 1, 3) + '-' + SUBSTRING(b.FacilityPhone, 4, 4)
                                                                                                                                                                                                                   WHEN LEN(b.FacilityPhone) = 10 THEN '(' + SUBSTRING(b.FacilityPhone, 1, 3) + ') ' + SUBSTRING(b.FacilityPhone, 4, 3) + '-' + SUBSTRING(b.FacilityPhone, 7, 4)
                                                                                                                                                                                                                   ELSE b.FacilityPhone
                                                                                                                                                                                                              END) ,
                            MAX(b.FacilityNPI) ,
                            MAX(b.FacilityProviderIdType + b.FacilityProviderId) ,
                            MAX(CASE WHEN LEN(b.PaymentPhone) = 7 THEN SPACE(6) + SUBSTRING(b.PaymentPhone, 1, 3) + '-' + SUBSTRING(b.PaymentPhone, 4, 4)
                                     WHEN LEN(b.PaymentPhone) = 10 THEN SUBSTRING(b.PaymentPhone, 1, 3) + SPACE(3) + SUBSTRING(b.PaymentPhone, 4, 3) + '-' + SUBSTRING(b.PaymentPhone, 7, 4)
                                     ELSE b.PaymentPhone
                                END) ,
                            MAX(b.PayToProviderLastName + CHAR(13) + CHAR(10) + b.PaymentAddress1 + CHAR(13) + CHAR(10) + CASE WHEN b.PaymentAddress2 IS NOT NULL THEN b.PaymentAddress2 + CHAR(13) + CHAR(10)
                                                                                                                               ELSE RTRIM('')
                                                                                                                          END + b.PaymentCity + ', ' + b.PaymentState + ' ' + b.PaymentZip) ,
                            MAX(b.BillingProviderNPI) ,
                            MAX(b.BillingProviderIdType + b.BillingProviderId)
                    FROM    #ClaimGroups a
                            JOIN #ClaimGroupsDiagnoses c ON ( a.ClaimGroupId = c.ClaimGroupId )
                            JOIN #ClaimLines b ON ( ISNULL(a.BillingProviderId, '') = ISNULL(b.BillingProviderId, '')
                                                    AND ISNULL(a.ClientCoveragePlanId, 0) = ISNULL(b.ClientCoveragePlanId, 0)
                                                    AND ISNULL(a.ClientId, 0) = ISNULL(b.ClientId, 0)
                                                    AND ISNULL(a.ClientAddress1, '') = ISNULL(b.ClientAddress1, '')
                                                    AND ISNULL(a.ClientAddress2, '') = ISNULL(b.ClientAddress2, '')
                                                    AND ISNULL(a.ClientCity, '') = ISNULL(b.ClientCity, '')
                                                    AND ISNULL(a.ClientState, '') = ISNULL(b.ClientState, '')
                                                    AND ISNULL(a.ClientZip, '') = ISNULL(b.ClientZip, '')
                                                    AND ISNULL(a.InsuredAddress1, '') = ISNULL(b.InsuredAddress1, '')
                                                    AND ISNULL(a.InsuredAddress2, '') = ISNULL(b.InsuredAddress2, '')
                                                    AND ISNULL(a.InsuredCity, '') = ISNULL(b.InsuredCity, '')
                                                    AND ISNULL(a.InsuredState, '') = ISNULL(b.InsuredState, '')
                                                    AND ISNULL(a.InsuredZip, '') = ISNULL(b.InsuredZip, '')
                                                    AND ISNULL(a.AuthorizationId, 0) = ISNULL(b.AuthorizationId, 0)
													AND ISNULL(a.SubmissionReasonCode,'') = ISNULL(b.SubmissionReasonCode,'') -- MAJ 4/10/18
                                                    AND a.MinClaimLineId <= b.ClaimLineId
                                                    AND a.MaxClaimLineId >= b.ClaimLineId
                                                  )
                            JOIN #ServiceDiagnosis b2 ON b2.ClaimLineId = b.ClaimLineId
                            JOIN #ClaimGroupCharges d ON ( a.ClaimGroupId = d.ClaimGroupId )
                            LEFT JOIN dbo.Staff e ON ( b.ClinicianId = e.StaffId )
                            LEFT JOIN dbo.GlobalCodes f ON ( e.Degree = f.GlobalCodeId )
                    GROUP BY a.ClaimGroupId ,
                            a.IsICD10Claim ,
                            SUBSTRING(c.DiagnosisCode1, 1, 3) ,
                            CASE WHEN c.DiagnosisCode1 LIKE '%.%' THEN SUBSTRING(c.DiagnosisCode1, CHARINDEX('.', c.DiagnosisCode1) + 1, 4)
                                 ELSE NULL
                            END ,
                            SUBSTRING(c.DiagnosisCode2, 1, 3) ,
                            CASE WHEN c.DiagnosisCode2 LIKE '%.%' THEN SUBSTRING(c.DiagnosisCode2, CHARINDEX('.', c.DiagnosisCode2) + 1, 4)
                                 ELSE NULL
                            END ,
                            SUBSTRING(c.DiagnosisCode3, 1, 3) ,
                            CASE WHEN c.DiagnosisCode3 LIKE '%.%' THEN SUBSTRING(c.DiagnosisCode3, CHARINDEX('.', c.DiagnosisCode3) + 1, 4)
                                 ELSE NULL
                            END ,
                            SUBSTRING(c.DiagnosisCode4, 1, 3) ,
                            CASE WHEN c.DiagnosisCode4 LIKE '%.%' THEN SUBSTRING(c.DiagnosisCode4, CHARINDEX('.', c.DiagnosisCode4) + 1, 4)
                                 ELSE NULL
                            END ,
                            CONVERT(VARCHAR, CONVERT(INT, FLOOR(ROUND(d.TotalChargeAmount, 2)))) ,
                            CASE WHEN CONVERT(INT, d.TotalChargeAmount * 100) % 100 < 10 THEN '0' + CONVERT(VARCHAR, CONVERT(INT, d.TotalChargeAmount * 100) % 100)
                                 ELSE CONVERT(VARCHAR, CONVERT(INT, d.TotalChargeAmount * 100) % 100)
                            END ,
                            CONVERT(VARCHAR, CONVERT(INT, FLOOR(ROUND(d.TotalPaidAmount, 2)))) ,
                            CASE WHEN CONVERT(INT, d.TotalPaidAmount * 100) % 100 < 10 THEN '0' + CONVERT(VARCHAR, CONVERT(INT, d.TotalPaidAmount * 100) % 100)
                                 ELSE CONVERT(VARCHAR, CONVERT(INT, d.TotalPaidAmount * 100) % 100)
                            END ,
                            CONVERT(VARCHAR, CONVERT(INT, FLOOR(ROUND(d.TotalBalanceAmount, 2)))) ,
                            CASE WHEN CONVERT(INT, d.TotalBalanceAmount * 100) % 100 < 10 THEN '0' + CONVERT(VARCHAR, CONVERT(INT, d.TotalBalanceAmount * 100) % 100)
                                 ELSE CONVERT(VARCHAR, CONVERT(INT, d.TotalBalanceAmount * 100) % 100)
                            END    
    
            IF @@error <> 0
                GOTO error    
    
            UPDATE  z
            SET     z.Field24aFromMM1 = CASE WHEN DATEPART(mm, b.DateOfService) < 10 THEN '0'
                                             ELSE RTRIM('')
                                        END + CONVERT(VARCHAR, DATEPART(mm, b.DateOfService)) ,
                    z.Field24aFromDD1 = CASE WHEN DATEPART(dd, b.DateOfService) < 10 THEN '0'
                                             ELSE RTRIM('')
                                        END + CONVERT(VARCHAR, DATEPART(dd, b.DateOfService)) ,
                    z.Field24aFromYY1 = CONVERT(VARCHAR, DATEPART(yy, b.DateOfService)) ,
                    z.Field24aToMM1 = CASE WHEN DATEPART(mm, b.EndDateOfService) < 10 THEN '0'
                                           ELSE RTRIM('')
                                      END + CONVERT(VARCHAR, DATEPART(mm, b.EndDateOfService)) ,
                    z.Field24aToDD1 = CASE WHEN DATEPART(dd, b.EndDateOfService) < 10 THEN '0'
                                           ELSE RTRIM('')
                                      END + CONVERT(VARCHAR, DATEPART(dd, b.EndDateOfService)) ,
                    z.Field24aToYY1 = CONVERT(VARCHAR, DATEPART(yy, b.EndDateOfService)) ,
                    z.Field24bPlaceOfService1 = b.PlaceOfServiceCode ,
                    z.Field24dProcedureCode1 = b.BillingCode ,
                    z.Field24dModifier11 = b.Modifier1 ,
                    z.Field24dModifier21 = b.Modifier2 ,
                    z.Field24dModifier31 = b.Modifier3 ,
                    z.Field24dModifier41 = b.Modifier4 ,
                    z.Field24eDiagnosisCode1 = b.DiagnosisPointer ,
                    z.Field24fCharges11 = CONVERT(VARCHAR, CONVERT(INT, FLOOR(ROUND(b.ChargeAmount, 2)))) ,
                    z.Field24fCharges21 = CASE WHEN CONVERT(INT, ROUND(b.ChargeAmount, 2) * 100) % 100 < 10 THEN '0' + CONVERT(VARCHAR, CONVERT(INT, ROUND(b.ChargeAmount, 2) * 100) % 100)
                                               ELSE CONVERT(VARCHAR, CONVERT(INT, ROUND(b.ChargeAmount, 2) * 100) % 100)
                                          END ,
                    z.Field24gUnits1 = CONVERT(VARCHAR, b.ClaimUnits) ,
                    z.Field24iRenderingIdQualifier1 = b.RenderingProviderIdType ,
                    z.Field24jRenderingId1 = b.RenderingProviderId ,
                    z.Field24jRenderingNPI1 = b.RenderingProviderNPI
            FROM    #ClaimGroupsData z
                    JOIN #ClaimGroups a ON ( z.ClaimGroupId = a.ClaimGroupId )
                    JOIN #ClaimLines b ON ( ISNULL(a.BillingProviderId, '') = ISNULL(b.BillingProviderId, '')
                                            AND ISNULL(a.ClientCoveragePlanId, 0) = ISNULL(b.ClientCoveragePlanId, 0)
                                            AND ISNULL(a.ClientId, 0) = ISNULL(b.ClientId, 0)
                                            AND ISNULL(a.ClientAddress1, '') = ISNULL(b.ClientAddress1, '')
                                            AND ISNULL(a.ClientAddress2, '') = ISNULL(b.ClientAddress2, '')
                                            AND ISNULL(a.ClientCity, '') = ISNULL(b.ClientCity, '')
                                            AND ISNULL(a.ClientState, '') = ISNULL(b.ClientState, '')
                                            AND ISNULL(a.ClientZip, '') = ISNULL(b.ClientZip, '')
                                            AND ISNULL(a.InsuredAddress1, '') = ISNULL(b.InsuredAddress1, '')
                                            AND ISNULL(a.InsuredAddress2, '') = ISNULL(b.InsuredAddress2, '')
                                            AND ISNULL(a.InsuredCity, '') = ISNULL(b.InsuredCity, '')
                                            AND ISNULL(a.InsuredState, '') = ISNULL(b.InsuredState, '')
                                            AND ISNULL(a.InsuredZip, '') = ISNULL(b.InsuredZip, '')
                                            AND ISNULL(a.AuthorizationId, 0) = ISNULL(b.AuthorizationId, 0)
											AND ISNULL(a.SubmissionReasonCode,'') = ISNULL(b.SubmissionReasonCode,'') -- MAJ 4/10/18
                                            AND a.MinClaimLineId <= b.ClaimLineId
                                            AND a.MaxClaimLineId >= b.ClaimLineId
                                          )
            WHERE   b.ClaimLineId = a.MinClaimLineId    
    
            IF @@error <> 0
                GOTO error    
    
            UPDATE  z
            SET     z.Field24aFromMM2 = CASE WHEN DATEPART(mm, b.DateOfService) < 10 THEN '0'
                                             ELSE RTRIM('')
                                        END + CONVERT(VARCHAR, DATEPART(mm, b.DateOfService)) ,
                    z.Field24aFromDD2 = CASE WHEN DATEPART(dd, b.DateOfService) < 10 THEN '0'
                                             ELSE RTRIM('')
                                        END + CONVERT(VARCHAR, DATEPART(dd, b.DateOfService)) ,
                    z.Field24aFromYY2 = CONVERT(VARCHAR, DATEPART(yy, b.DateOfService)) ,
                    z.Field24aToMM2 = CASE WHEN DATEPART(mm, b.EndDateOfService) < 10 THEN '0'
                                           ELSE RTRIM('')
                                      END + CONVERT(VARCHAR, DATEPART(mm, b.EndDateOfService)) ,
                    z.Field24aToDD2 = CASE WHEN DATEPART(dd, b.EndDateOfService) < 10 THEN '0'
                                           ELSE RTRIM('')
                                      END + CONVERT(VARCHAR, DATEPART(dd, b.EndDateOfService)) ,
                    z.Field24aToYY2 = CONVERT(VARCHAR, DATEPART(yy, b.EndDateOfService)) ,
                    z.Field24bPlaceOfService2 = b.PlaceOfServiceCode ,
                    z.Field24dProcedureCode2 = b.BillingCode ,
                    z.Field24dModifier12 = b.Modifier1 ,
                    z.Field24dModifier22 = b.Modifier2 ,
                    z.Field24dModifier32 = b.Modifier3 ,
                    z.Field24dModifier42 = b.Modifier4 ,
                    z.Field24eDiagnosisCode2 = b.DiagnosisPointer ,
                    z.Field24fCharges12 = CONVERT(VARCHAR, CONVERT(INT, FLOOR(ROUND(b.ChargeAmount, 2)))) ,
                    z.Field24fCharges22 = CASE WHEN CONVERT(INT, ROUND(b.ChargeAmount, 2) * 100) % 100 < 10 THEN '0' + CONVERT(VARCHAR, CONVERT(INT, ROUND(b.ChargeAmount, 2) * 100) % 100)
                                               ELSE CONVERT(VARCHAR, CONVERT(INT, ROUND(b.ChargeAmount, 2) * 100) % 100)
                                          END ,
                    z.Field24gUnits2 = CONVERT(VARCHAR, b.ClaimUnits) ,
                    z.Field24iRenderingIdQualifier2 = b.RenderingProviderIdType ,
                    z.Field24jRenderingId2 = b.RenderingProviderId ,
                    z.Field24jRenderingNPI2 = b.RenderingProviderNPI
            FROM    #ClaimGroupsData z
                    JOIN #ClaimGroups a ON ( z.ClaimGroupId = a.ClaimGroupId )
                    JOIN #ClaimLines b ON ( ISNULL(a.BillingProviderId, '') = ISNULL(b.BillingProviderId, '')
                                            AND ISNULL(a.ClientCoveragePlanId, 0) = ISNULL(b.ClientCoveragePlanId, 0)
                                            AND ISNULL(a.ClientId, 0) = ISNULL(b.ClientId, 0)
                                            AND ISNULL(a.ClientAddress1, '') = ISNULL(b.ClientAddress1, '')
                                            AND ISNULL(a.ClientAddress2, '') = ISNULL(b.ClientAddress2, '')
                                            AND ISNULL(a.ClientCity, '') = ISNULL(b.ClientCity, '')
                                            AND ISNULL(a.ClientState, '') = ISNULL(b.ClientState, '')
                                            AND ISNULL(a.ClientZip, '') = ISNULL(b.ClientZip, '')
                                            AND ISNULL(a.InsuredAddress1, '') = ISNULL(b.InsuredAddress1, '')
                                            AND ISNULL(a.InsuredAddress2, '') = ISNULL(b.InsuredAddress2, '')
                                            AND ISNULL(a.InsuredCity, '') = ISNULL(b.InsuredCity, '')
                                            AND ISNULL(a.InsuredState, '') = ISNULL(b.InsuredState, '')
                                            AND ISNULL(a.InsuredZip, '') = ISNULL(b.InsuredZip, '')
                                            AND ISNULL(a.AuthorizationId, 0) = ISNULL(b.AuthorizationId, 0)
											AND ISNULL(a.SubmissionReasonCode,'') = ISNULL(b.SubmissionReasonCode,'') -- MAJ 4/10/18
                                            AND a.MinClaimLineId <= b.ClaimLineId
                                            AND a.MaxClaimLineId >= b.ClaimLineId
                                          )
            WHERE   b.ClaimLineId = a.MinClaimLineId + 1    
    
            IF @@error <> 0
                GOTO error    
    
            UPDATE  z
            SET     z.Field24aFromMM3 = CASE WHEN DATEPART(mm, b.DateOfService) < 10 THEN '0'
                                             ELSE RTRIM('')
                                        END + CONVERT(VARCHAR, DATEPART(mm, b.DateOfService)) ,
                    z.Field24aFromDD3 = CASE WHEN DATEPART(dd, b.DateOfService) < 10 THEN '0'
                                             ELSE RTRIM('')
                                        END + CONVERT(VARCHAR, DATEPART(dd, b.DateOfService)) ,
                    z.Field24aFromYY3 = CONVERT(VARCHAR, DATEPART(yy, b.DateOfService)) ,
                    z.Field24aToMM3 = CASE WHEN DATEPART(mm, b.EndDateOfService) < 10 THEN '0'
                                           ELSE RTRIM('')
                                      END + CONVERT(VARCHAR, DATEPART(mm, b.EndDateOfService)) ,
                    z.Field24aToDD3 = CASE WHEN DATEPART(dd, b.EndDateOfService) < 10 THEN '0'
                                           ELSE RTRIM('')
                                      END + CONVERT(VARCHAR, DATEPART(dd, b.EndDateOfService)) ,
                    z.Field24aToYY3 = CONVERT(VARCHAR, DATEPART(yy, b.EndDateOfService)) ,
                    z.Field24bPlaceOfService3 = b.PlaceOfServiceCode ,
                    z.Field24dProcedureCode3 = b.BillingCode ,
                    z.Field24dModifier13 = b.Modifier1 ,
                    z.Field24dModifier23 = b.Modifier2 ,
                    z.Field24dModifier33 = b.Modifier3 ,
                    z.Field24dModifier43 = b.Modifier4 ,
                    z.Field24eDiagnosisCode3 = b.DiagnosisPointer ,
                    z.Field24fCharges13 = CONVERT(VARCHAR, CONVERT(INT, FLOOR(ROUND(b.ChargeAmount, 2)))) ,
                    z.Field24fCharges23 = CASE WHEN CONVERT(INT, ROUND(b.ChargeAmount, 2) * 100) % 100 < 10 THEN '0' + CONVERT(VARCHAR, CONVERT(INT, ROUND(b.ChargeAmount, 2) * 100) % 100)
                                               ELSE CONVERT(VARCHAR, CONVERT(INT, ROUND(b.ChargeAmount, 2) * 100) % 100)
                                          END ,
                    z.Field24gUnits3 = CONVERT(VARCHAR, b.ClaimUnits) ,
                    z.Field24iRenderingIdQualifier3 = b.RenderingProviderIdType ,
                    z.Field24jRenderingId3 = b.RenderingProviderId ,
                    z.Field24jRenderingNPI3 = b.RenderingProviderNPI
            FROM    #ClaimGroupsData z
                    JOIN #ClaimGroups a ON ( z.ClaimGroupId = a.ClaimGroupId )
                    JOIN #ClaimLines b ON ( ISNULL(a.BillingProviderId, '') = ISNULL(b.BillingProviderId, '')
                                            AND ISNULL(a.ClientCoveragePlanId, 0) = ISNULL(b.ClientCoveragePlanId, 0)
                                            AND ISNULL(a.ClientId, 0) = ISNULL(b.ClientId, 0)
                                            AND ISNULL(a.ClientAddress1, '') = ISNULL(b.ClientAddress1, '')
                                            AND ISNULL(a.ClientAddress2, '') = ISNULL(b.ClientAddress2, '')
                                            AND ISNULL(a.ClientCity, '') = ISNULL(b.ClientCity, '')
                                            AND ISNULL(a.ClientState, '') = ISNULL(b.ClientState, '')
                                            AND ISNULL(a.ClientZip, '') = ISNULL(b.ClientZip, '')
                                            AND ISNULL(a.InsuredAddress1, '') = ISNULL(b.InsuredAddress1, '')
                                            AND ISNULL(a.InsuredAddress2, '') = ISNULL(b.InsuredAddress2, '')
                                            AND ISNULL(a.InsuredCity, '') = ISNULL(b.InsuredCity, '')
                                            AND ISNULL(a.InsuredState, '') = ISNULL(b.InsuredState, '')
                                            AND ISNULL(a.InsuredZip, '') = ISNULL(b.InsuredZip, '')
                                            AND ISNULL(a.AuthorizationId, 0) = ISNULL(b.AuthorizationId, 0)
											AND ISNULL(a.SubmissionReasonCode,'') = ISNULL(b.SubmissionReasonCode,'') -- MAJ 4/10/18
                                            AND a.MinClaimLineId <= b.ClaimLineId
                                            AND a.MaxClaimLineId >= b.ClaimLineId
                                          )
            WHERE   b.ClaimLineId = a.MinClaimLineId + 2    
    
            IF @@error <> 0
                GOTO error    
    
            UPDATE  z
            SET     z.Field24aFromMM4 = CASE WHEN DATEPART(mm, b.DateOfService) < 10 THEN '0'
                                             ELSE RTRIM('')
                                        END + CONVERT(VARCHAR, DATEPART(mm, b.DateOfService)) ,
                    z.Field24aFromDD4 = CASE WHEN DATEPART(dd, b.DateOfService) < 10 THEN '0'
                                             ELSE RTRIM('')
                                        END + CONVERT(VARCHAR, DATEPART(dd, b.DateOfService)) ,
                    z.Field24aFromYY4 = CONVERT(VARCHAR, DATEPART(yy, b.DateOfService)) ,
                    z.Field24aToMM4 = CASE WHEN DATEPART(mm, b.EndDateOfService) < 10 THEN '0'
                                           ELSE RTRIM('')
                                      END + CONVERT(VARCHAR, DATEPART(mm, b.EndDateOfService)) ,
                    z.Field24aToDD4 = CASE WHEN DATEPART(dd, b.EndDateOfService) < 10 THEN '0'
                                           ELSE RTRIM('')
                                      END + CONVERT(VARCHAR, DATEPART(dd, b.EndDateOfService)) ,
                    z.Field24aToYY4 = CONVERT(VARCHAR, DATEPART(yy, b.EndDateOfService)) ,
                    z.Field24bPlaceOfService4 = b.PlaceOfServiceCode ,
                    z.Field24dProcedureCode4 = b.BillingCode ,
                    z.Field24dModifier14 = b.Modifier1 ,
                    z.Field24dModifier24 = b.Modifier2 ,
                    z.Field24dModifier34 = b.Modifier3 ,
                    z.Field24dModifier44 = b.Modifier4 ,
                    z.Field24eDiagnosisCode4 = b.DiagnosisPointer ,
                    z.Field24fCharges14 = CONVERT(VARCHAR, CONVERT(INT, FLOOR(ROUND(b.ChargeAmount, 2)))) ,
                    z.Field24fCharges24 = CASE WHEN CONVERT(INT, ROUND(b.ChargeAmount, 2) * 100) % 100 < 10 THEN '0' + CONVERT(VARCHAR, CONVERT(INT, ROUND(b.ChargeAmount, 2) * 100) % 100)
                                               ELSE CONVERT(VARCHAR, CONVERT(INT, ROUND(b.ChargeAmount, 2) * 100) % 100)
                                          END ,
                    z.Field24gUnits4 = CONVERT(VARCHAR, b.ClaimUnits) ,
                    z.Field24iRenderingIdQualifier4 = b.RenderingProviderIdType ,
                    z.Field24jRenderingId4 = b.RenderingProviderId ,
                    z.Field24jRenderingNPI4 = b.RenderingProviderNPI
            FROM    #ClaimGroupsData z
                    JOIN #ClaimGroups a ON ( z.ClaimGroupId = a.ClaimGroupId )
                    JOIN #ClaimLines b ON ( ISNULL(a.BillingProviderId, '') = ISNULL(b.BillingProviderId, '')
                                            AND ISNULL(a.ClientCoveragePlanId, 0) = ISNULL(b.ClientCoveragePlanId, 0)
                                            AND ISNULL(a.ClientId, 0) = ISNULL(b.ClientId, 0)
                                            AND ISNULL(a.ClientAddress1, '') = ISNULL(b.ClientAddress1, '')
                                            AND ISNULL(a.ClientAddress2, '') = ISNULL(b.ClientAddress2, '')
                                            AND ISNULL(a.ClientCity, '') = ISNULL(b.ClientCity, '')
                                            AND ISNULL(a.ClientState, '') = ISNULL(b.ClientState, '')
                                            AND ISNULL(a.ClientZip, '') = ISNULL(b.ClientZip, '')
                                            AND ISNULL(a.InsuredAddress1, '') = ISNULL(b.InsuredAddress1, '')
                                            AND ISNULL(a.InsuredAddress2, '') = ISNULL(b.InsuredAddress2, '')
                                            AND ISNULL(a.InsuredCity, '') = ISNULL(b.InsuredCity, '')
                                            AND ISNULL(a.InsuredState, '') = ISNULL(b.InsuredState, '')
                                            AND ISNULL(a.InsuredZip, '') = ISNULL(b.InsuredZip, '')
                                            AND ISNULL(a.AuthorizationId, 0) = ISNULL(b.AuthorizationId, 0)
											AND ISNULL(a.SubmissionReasonCode,'') = ISNULL(b.SubmissionReasonCode,'') -- MAJ 4/10/18
                                            AND a.MinClaimLineId <= b.ClaimLineId
                                            AND a.MaxClaimLineId >= b.ClaimLineId
                                          )
            WHERE   b.ClaimLineId = a.MinClaimLineId + 3    
    
            IF @@error <> 0
                GOTO error    
    
            UPDATE  z
            SET     z.Field24aFromMM5 = CASE WHEN DATEPART(mm, b.DateOfService) < 10 THEN '0'
                                             ELSE RTRIM('')
                                        END + CONVERT(VARCHAR, DATEPART(mm, b.DateOfService)) ,
                    z.Field24aFromDD5 = CASE WHEN DATEPART(dd, b.DateOfService) < 10 THEN '0'
                                             ELSE RTRIM('')
                                        END + CONVERT(VARCHAR, DATEPART(dd, b.DateOfService)) ,
                    z.Field24aFromYY5 = CONVERT(VARCHAR, DATEPART(yy, b.DateOfService)) ,
                    z.Field24aToMM5 = CASE WHEN DATEPART(mm, b.EndDateOfService) < 10 THEN '0'
                                           ELSE RTRIM('')
                                      END + CONVERT(VARCHAR, DATEPART(mm, b.EndDateOfService)) ,
                    z.Field24aToDD5 = CASE WHEN DATEPART(dd, b.EndDateOfService) < 10 THEN '0'
                                           ELSE RTRIM('')
                                      END + CONVERT(VARCHAR, DATEPART(dd, b.EndDateOfService)) ,
                    z.Field24aToYY5 = CONVERT(VARCHAR, DATEPART(yy, b.EndDateOfService)) ,
                    z.Field24bPlaceOfService5 = b.PlaceOfServiceCode ,
                    z.Field24dProcedureCode5 = b.BillingCode ,
                    z.Field24dModifier15 = b.Modifier1 ,
                    z.Field24dModifier25 = b.Modifier2 ,
                    z.Field24dModifier35 = b.Modifier3 ,
                    z.Field24dModifier45 = b.Modifier4 ,
                    z.Field24eDiagnosisCode5 = b.DiagnosisPointer ,
                    z.Field24fCharges15 = CONVERT(VARCHAR, CONVERT(INT, FLOOR(ROUND(b.ChargeAmount, 2)))) ,
                    z.Field24fCharges25 = CASE WHEN CONVERT(INT, ROUND(b.ChargeAmount, 2) * 100) % 100 < 10 THEN '0' + CONVERT(VARCHAR, CONVERT(INT, ROUND(b.ChargeAmount, 2) * 100) % 100)
                                               ELSE CONVERT(VARCHAR, CONVERT(INT, ROUND(b.ChargeAmount, 2) * 100) % 100)
                                          END ,
                    z.Field24gUnits5 = CONVERT(VARCHAR, b.ClaimUnits) ,
                    z.Field24iRenderingIdQualifier5 = b.RenderingProviderIdType ,
                    z.Field24jRenderingId5 = b.RenderingProviderId ,
                    z.Field24jRenderingNPI5 = b.RenderingProviderNPI
            FROM    #ClaimGroupsData z
                    JOIN #ClaimGroups a ON ( z.ClaimGroupId = a.ClaimGroupId )
                    JOIN #ClaimLines b ON ( ISNULL(a.BillingProviderId, '') = ISNULL(b.BillingProviderId, '')
                                            AND ISNULL(a.ClientCoveragePlanId, 0) = ISNULL(b.ClientCoveragePlanId, 0)
                                            AND ISNULL(a.ClientId, 0) = ISNULL(b.ClientId, 0)
                                            AND ISNULL(a.ClientAddress1, '') = ISNULL(b.ClientAddress1, '')
                                            AND ISNULL(a.ClientAddress2, '') = ISNULL(b.ClientAddress2, '')
                                            AND ISNULL(a.ClientCity, '') = ISNULL(b.ClientCity, '')
                                            AND ISNULL(a.ClientState, '') = ISNULL(b.ClientState, '')
                                            AND ISNULL(a.ClientZip, '') = ISNULL(b.ClientZip, '')
                                            AND ISNULL(a.InsuredAddress1, '') = ISNULL(b.InsuredAddress1, '')
                                            AND ISNULL(a.InsuredAddress2, '') = ISNULL(b.InsuredAddress2, '')
                                            AND ISNULL(a.InsuredCity, '') = ISNULL(b.InsuredCity, '')
                                            AND ISNULL(a.InsuredState, '') = ISNULL(b.InsuredState, '')
                                            AND ISNULL(a.InsuredZip, '') = ISNULL(b.InsuredZip, '')
                                            AND ISNULL(a.AuthorizationId, 0) = ISNULL(b.AuthorizationId, 0)
											AND ISNULL(a.SubmissionReasonCode,'') = ISNULL(b.SubmissionReasonCode,'') -- MAJ 4/10/18
                                            AND a.MinClaimLineId <= b.ClaimLineId
                                            AND a.MaxClaimLineId >= b.ClaimLineId
                                          )
            WHERE   b.ClaimLineId = a.MinClaimLineId + 4    
    
            IF @@error <> 0
                GOTO error    
    
            UPDATE  z
            SET     z.Field24aFromMM6 = CASE WHEN DATEPART(mm, b.DateOfService) < 10 THEN '0'
                                             ELSE RTRIM('')
                                        END + CONVERT(VARCHAR, DATEPART(mm, b.DateOfService)) ,
                    z.Field24aFromDD6 = CASE WHEN DATEPART(dd, b.DateOfService) < 10 THEN '0'
                                             ELSE RTRIM('')
                                        END + CONVERT(VARCHAR, DATEPART(dd, b.DateOfService)) ,
                    z.Field24aFromYY6 = CONVERT(VARCHAR, DATEPART(yy, b.DateOfService)) ,
                    z.Field24aToMM6 = CASE WHEN DATEPART(mm, b.EndDateOfService) < 10 THEN '0'
                                           ELSE RTRIM('')
                                      END + CONVERT(VARCHAR, DATEPART(mm, b.EndDateOfService)) ,
                    z.Field24aToDD6 = CASE WHEN DATEPART(dd, b.EndDateOfService) < 10 THEN '0'
                                           ELSE RTRIM('')
                                      END + CONVERT(VARCHAR, DATEPART(dd, b.EndDateOfService)) ,
                    z.Field24aToYY6 = CONVERT(VARCHAR, DATEPART(yy, b.EndDateOfService)) ,
                    z.Field24bPlaceOfService6 = b.PlaceOfServiceCode ,
                    z.Field24dProcedureCode6 = b.BillingCode ,
                    z.Field24dModifier16 = b.Modifier1 ,
                    z.Field24dModifier26 = b.Modifier2 ,
                    z.Field24dModifier36 = b.Modifier3 ,
                    z.Field24dModifier46 = b.Modifier4 ,
                    z.Field24eDiagnosisCode6 = b.DiagnosisPointer ,
                    z.Field24fCharges16 = CONVERT(VARCHAR, CONVERT(INT, FLOOR(ROUND(b.ChargeAmount, 2)))) ,
                    z.Field24fCharges26 = CASE WHEN CONVERT(INT, ROUND(b.ChargeAmount, 2) * 100) % 100 < 10 THEN '0' + CONVERT(VARCHAR, CONVERT(INT, ROUND(b.ChargeAmount, 2) * 100) % 100)
                                               ELSE CONVERT(VARCHAR, CONVERT(INT, ROUND(b.ChargeAmount, 2) * 100) % 100)
                                          END ,
                    z.Field24gUnits6 = CONVERT(VARCHAR, b.ClaimUnits) ,
                    z.Field24iRenderingIdQualifier6 = b.RenderingProviderIdType ,
                    z.Field24jRenderingId6 = b.RenderingProviderId ,
                    z.Field24jRenderingNPI6 = b.RenderingProviderNPI
            FROM    #ClaimGroupsData z
                    JOIN #ClaimGroups a ON ( z.ClaimGroupId = a.ClaimGroupId )
                    JOIN #ClaimLines b ON ( ISNULL(a.BillingProviderId, '') = ISNULL(b.BillingProviderId, '')
                                            AND ISNULL(a.ClientCoveragePlanId, 0) = ISNULL(b.ClientCoveragePlanId, 0)
                                            AND ISNULL(a.ClientId, 0) = ISNULL(b.ClientId, 0)
                                            AND ISNULL(a.ClientAddress1, '') = ISNULL(b.ClientAddress1, '')
                                            AND ISNULL(a.ClientAddress2, '') = ISNULL(b.ClientAddress2, '')
                                            AND ISNULL(a.ClientCity, '') = ISNULL(b.ClientCity, '')
                                            AND ISNULL(a.ClientState, '') = ISNULL(b.ClientState, '')
                                            AND ISNULL(a.ClientZip, '') = ISNULL(b.ClientZip, '')
                                            AND ISNULL(a.InsuredAddress1, '') = ISNULL(b.InsuredAddress1, '')
                                            AND ISNULL(a.InsuredAddress2, '') = ISNULL(b.InsuredAddress2, '')
                                            AND ISNULL(a.InsuredCity, '') = ISNULL(b.InsuredCity, '')
                                            AND ISNULL(a.InsuredState, '') = ISNULL(b.InsuredState, '')
                                            AND ISNULL(a.InsuredZip, '') = ISNULL(b.InsuredZip, '')
                                            AND ISNULL(a.AuthorizationId, 0) = ISNULL(b.AuthorizationId, 0)
											AND ISNULL(a.SubmissionReasonCode,'') = ISNULL(b.SubmissionReasonCode,'') -- MAJ 4/10/18
                                            AND a.MinClaimLineId <= b.ClaimLineId
                                            AND a.MaxClaimLineId >= b.ClaimLineId
                                          )
            WHERE   b.ClaimLineId = a.MinClaimLineId + 5    
    
            IF @@error <> 0
                GOTO error    
    
-- Keep only 1 other insured - Either Primary or Secondary depending on the current coverage priority    
            DELETE  a
            FROM    #OtherInsured a
                    JOIN #ClaimLines b ON ( a.ClaimLineId = b.ClaimLineId )
            WHERE   ( b.Priority = 1
                      AND a.Priority <> 2
                    )
                    OR ( b.Priority > 1
                         AND a.Priority <> 1
                       )    
    
            IF @@error <> 0
                GOTO error    
    
            UPDATE  z
            SET     z.Field9OtherInsuredName = c.InsuredLastName + ', ' + c.InsuredFirstName + ' ' + ISNULL(SUBSTRING(RTRIM(c.InsuredMiddleName), 1, 1), RTRIM('')) ,
                    z.Field9OtherInsuredGroupNumber = c.GroupNumber ,
                    z.Field9OtherInsuredDOBMM = CONVERT(VARCHAR, DATEPART(mm, c.InsuredDOB)) ,
                    z.Field9OtherInsuredDOBDD = CONVERT(VARCHAR, DATEPART(dd, c.InsuredDOB)) ,
                    z.Field9OtherInsuredDOBYY = CONVERT(VARCHAR, DATEPART(yy, c.InsuredDOB)) ,
                    z.Field9OtherInsuredMale = CASE WHEN c.InsuredSex = 'M' THEN 'X'
                                                    ELSE NULL
                                               END ,
                    z.Field9OtherInsuredFemale = CASE WHEN c.InsuredSex = 'F' THEN 'X'
                                                      ELSE NULL
                                                 END ,
                    z.Field9OtherInsuredEmployer = NULL ,
                    z.Field9OtherInsuredPlan = c.PayerName ,
                    z.Field11OtherPlanYes = 'X' ,
                    z.Field11OtherPlanNo = NULL
            FROM    #ClaimGroupsData z
                    JOIN #ClaimGroups a ON ( z.ClaimGroupId = a.ClaimGroupId )
                    JOIN #ClaimLines b ON ( ISNULL(a.BillingProviderId, '') = ISNULL(b.BillingProviderId, '')
                                            AND ISNULL(a.ClientCoveragePlanId, 0) = ISNULL(b.ClientCoveragePlanId, 0)
                                            AND ISNULL(a.ClientId, 0) = ISNULL(b.ClientId, 0)
                                            AND ISNULL(a.ClientAddress1, '') = ISNULL(b.ClientAddress1, '')
                                            AND ISNULL(a.ClientAddress2, '') = ISNULL(b.ClientAddress2, '')
                                            AND ISNULL(a.ClientCity, '') = ISNULL(b.ClientCity, '')
                                            AND ISNULL(a.ClientState, '') = ISNULL(b.ClientState, '')
                                            AND ISNULL(a.ClientZip, '') = ISNULL(b.ClientZip, '')
                                            AND ISNULL(a.InsuredAddress1, '') = ISNULL(b.InsuredAddress1, '')
                                            AND ISNULL(a.InsuredAddress2, '') = ISNULL(b.InsuredAddress2, '')
                                            AND ISNULL(a.InsuredCity, '') = ISNULL(b.InsuredCity, '')
                                            AND ISNULL(a.InsuredState, '') = ISNULL(b.InsuredState, '')
                                            AND ISNULL(a.InsuredZip, '') = ISNULL(b.InsuredZip, '')
                                            AND ISNULL(a.AuthorizationId, 0) = ISNULL(b.AuthorizationId, 0)
											AND ISNULL(a.SubmissionReasonCode,'') = ISNULL(b.SubmissionReasonCode,'') -- MAJ 4/10/18
                                            AND a.MinClaimLineId <= b.ClaimLineId
                                            AND a.MaxClaimLineId >= b.ClaimLineId
                                          )
                    JOIN #OtherInsured c ON ( b.ClaimLineId = c.ClaimLineId )    
    
            IF @@error <> 0
                GOTO error    
-- MAJ 4/10/18 begin section added
-- Error resumbitted/void claims w/o payer claim control number
   IF EXISTS ( SELECT  1
                        FROM    #ClaimGroupsData a
                        WHERE   a.Field22MedicaidResubmissionCode IN ( '7', '8' )
                                AND a.Field22MedicaidReferenceNumber IS NULL )
                BEGIN
                    INSERT  INTO dbo.ChargeErrors
                            ( ChargeId ,
                              ErrorType ,
                              ErrorDescription ,
                              CreatedBy ,
                              CreatedDate ,
                              ModifiedBy ,
                              ModifiedDate
                            
									
                            )
                            SELECT  b.ChargeId  -- ChargeId - int
                                    ,
                                    4556-- ErrorType - type_GlobalCode
                                    ,
                                    'Void or Replacement Claim requires Payer Claim Control Number. Check Claim Line Item Details.'-- ErrorDescription - varchar(1000)
                                    ,
                                    @ParamCurrentUser-- CreatedBy - type_CurrentUser
                                    ,
                                    GETDATE()-- CreatedDate - type_CurrentDatetime
                                    ,
                                    @ParamCurrentUser-- ModifiedBy - type_CurrentUser
                                    ,
                                    GETDATE()-- ModifiedDate - type_CurrentDatetime
                            FROM    #ClaimGroupsData a
									JOIN #ClaimLines b ON ( ISNULL(a.BillingProviderId, '') = ISNULL(b.BillingProviderId, '')
                                                    AND ISNULL(a.ClientCoveragePlanId, 0) = ISNULL(b.ClientCoveragePlanId, 0)
                                                    AND ISNULL(a.ClientId, 0) = ISNULL(b.ClientId, 0)
                                                    AND ISNULL(a.ClientAddress1, '') = ISNULL(b.ClientAddress1, '')
                                                    AND ISNULL(a.ClientAddress2, '') = ISNULL(b.ClientAddress2, '')
                                                    AND ISNULL(a.ClientCity, '') = ISNULL(b.ClientCity, '')
                                                    AND ISNULL(a.ClientState, '') = ISNULL(b.ClientState, '')
                                                    AND ISNULL(a.ClientZip, '') = ISNULL(b.ClientZip, '')
                                                    AND ISNULL(a.InsuredAddress1, '') = ISNULL(b.InsuredAddress1, '')
                                                    AND ISNULL(a.InsuredAddress2, '') = ISNULL(b.InsuredAddress2, '')
                                                    AND ISNULL(a.InsuredCity, '') = ISNULL(b.InsuredCity, '')
                                                    AND ISNULL(a.InsuredState, '') = ISNULL(b.InsuredState, '')
                                                    AND ISNULL(a.InsuredZip, '') = ISNULL(b.InsuredZip, '')
                                                    AND ISNULL(a.AuthorizationId, 0) = ISNULL(b.AuthorizationId, 0)
													AND ISNULL(a.SubmissionReasonCode,'') = ISNULL(b.SubmissionReasonCode,'') 
                                                    AND a.MinClaimLineId <= b.ClaimLineId
                                                    AND a.MaxClaimLineId >= b.ClaimLineId
                                                  )
									WHERE   a.Field22MedicaidResubmissionCode IN ( '7', '8' )
                                    AND a.Field22MedicaidReferenceNumber IS NULL

					IF @@error <> 0
					GOTO error

					DELETE  a
					FROM    #ClaimGroupsData a
					WHERE   a.Field22MedicaidReferenceNumber IS NULL
							AND a.Field22MedicaidResubmissionCode IN ( '7', '8' )	

					IF @@error <> 0
					GOTO error

                END
		 	

            IF @@error <> 0
                GOTO error 

				IF EXISTS (SELECT 1 FROM #ClaimBatchVoids AS cbv
					WHERE cbv.PayerClaimControlNumber IS NULL)
				                BEGIN
                    INSERT  INTO dbo.ChargeErrors
                            ( ChargeId ,
                              ErrorType ,
                              ErrorDescription ,
                              CreatedBy ,
                              CreatedDate ,
                              ModifiedBy ,
                              ModifiedDate
                            
									
                            )
                            SELECT  clic.ChargeId  -- ChargeId - int
                                    ,
                                    4556-- ErrorType - type_GlobalCode
                                    ,
                                    'Void or Replacement Claim requires Payer Claim Control Number. Check Claim Line Item Details.'-- ErrorDescription - varchar(1000)
                                    ,
                                    @ParamCurrentUser-- CreatedBy - type_CurrentUser
                                    ,
                                    GETDATE()-- CreatedDate - type_CurrentDatetime
                                    ,
                                    @ParamCurrentUser-- ModifiedBy - type_CurrentUser
                                    ,
                                    GETDATE()-- ModifiedDate - type_CurrentDatetime
                            FROM    #ClaimBatchVoids a
									JOIN ClaimLineItemGroups clig ON clig.ClaimLineItemGroupId = a.ClaimLineItemGroupId
									JOIN ClaimLineItems cli ON cli.ClaimLineItemGroupId = clig.ClaimLineItemGroupId
									JOIN ClaimLineItemCharges clic ON clic.ClaimLineItemId = cli.ClaimLineItemId
									WHERE a.PayerClaimControlNumber IS NULL

					IF @@error <> 0
					GOTO error

					DELETE FROM #ClaimBatchVoids
					WHERE PayerClaimControlNumber IS NULL

					IF @@error <> 0
					GOTO error

                END
-- MAJ 4/10/18  end section added
       
        
        -- Delete old data related to the batch    
--exec ssp_PMClaimsUpdateClaimsTables @ParamCurrentUser, @ParamClaimBatchId    
    
--if @@error <> 0 goto error    
    
            UPDATE  dbo.ClaimBatches
            SET     BatchProcessProgress = 90
            WHERE   ClaimBatchId = @ParamClaimBatchId    
    
            IF @@error <> 0
                GOTO error    
    
            DELETE  c
            FROM    dbo.ClaimLineItemGroups a
                    JOIN dbo.ClaimLineItems b ON ( a.ClaimLineItemGroupId = b.ClaimLineItemGroupId )
                    JOIN dbo.ClaimLineItemCharges c ON ( c.ClaimLineItemId = b.ClaimLineItemId )
            WHERE   a.ClaimBatchId = @ParamClaimBatchId    
    
            IF @@error <> 0
                GOTO error    
    
            DELETE  b
            FROM    dbo.ClaimLineItemGroups a
                    JOIN dbo.ClaimLineItems b ON ( a.ClaimLineItemGroupId = b.ClaimLineItemGroupId )
            WHERE   a.ClaimBatchId = @ParamClaimBatchId    
    
            IF @@error <> 0
                GOTO error    
    
    
            DELETE  b
            FROM    dbo.ClaimLineItemGroups a
                    JOIN dbo.ClaimNPIHCFA1500s b ON ( a.ClaimLineItemGroupId = b.ClaimLineItemGroupId )
            WHERE   a.ClaimBatchId = @ParamClaimBatchId    
    
            IF @@error <> 0
                GOTO error    
    
            DELETE  a
            FROM    dbo.ClaimLineItemGroups a
            WHERE   a.ClaimBatchId = @ParamClaimBatchId    
    
            IF @@error <> 0
                GOTO error    
    
-- Update Claims tables    
-- One record for each claim     
            INSERT  INTO dbo.ClaimLineItemGroups
                    ( ClaimBatchId ,
                      ClientId ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate ,
                      DeletedBy
					)
                    SELECT  @ParamClaimBatchId ,
                            ClientId ,
                            @ParamCurrentUser ,
                            @CurrentDate ,
                            @ParamCurrentUser ,
                            @CurrentDate ,
                            CONVERT(VARCHAR, ClaimGroupId)
                    FROM    #ClaimGroups    

            INSERT  INTO dbo.ClaimLineItemGroups
                    ( CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate ,
                      ClaimBatchId ,
                      ClientId ,
                      DeletedBy ,
                      RecordDeleted
					)
                    SELECT  @ParamCurrentUser-- CreatedBy - type_CurrentUser
                            ,
                            @CurrentDate-- CreatedDate - type_CurrentDatetime
                            ,
                            @ParamCurrentUser-- ModifiedBy - type_CurrentUser
                            ,
                            @CurrentDate-- ModifiedDate - type_CurrentDatetime
                            ,
                            @ParamClaimBatchId-- ClaimBatchId - int
                            ,
                            clig.ClientId-- ClientId - int
                            ,
                            clig.ClaimLineItemGroupId ,
                            'Y' -- V for Void
                    FROM    #ClaimBatchVoids AS cbv
                            JOIN dbo.ClaimLineItemGroups AS clig ON clig.ClaimLineItemGroupId = cbv.ClaimLineItemGroupId	
    
            IF @@error <> 0
                GOTO error    
    
-- One record for each line item (same as number of claims in case of 837)    
            INSERT  INTO dbo.ClaimLineItems
                    ( ClaimLineItemGroupId ,
                      BillingCode ,
                      Modifier1 ,
                      Modifier2 ,
                      Modifier3 ,
                      Modifier4 ,
                      RevenueCode ,
                      RevenueCodeDescription ,
                      Units ,
                      DateOfService ,
                      ChargeAmount ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate ,
                      DeletedBy
					)
                    SELECT  c.ClaimLineItemGroupId ,
                            b.BillingCode ,
                            b.Modifier1 ,
                            b.Modifier2 ,
                            b.Modifier3 ,
                            b.Modifier4 ,
                            b.RevenueCode ,
                            b.RevenueCodeDescription ,
                            b.ClaimUnits ,
                            b.DateOfService ,
                            b.ChargeAmount ,
                            @ParamCurrentUser ,
                            @CurrentDate ,
                            @ParamCurrentUser ,
                            @CurrentDate ,
                            CONVERT(VARCHAR, b.ClaimLineId)
                    FROM    #ClaimGroups a
                            JOIN #ClaimLines b ON ( ISNULL(a.BillingProviderId, '') = ISNULL(b.BillingProviderId, '')
                                                    AND ISNULL(a.ClientCoveragePlanId, 0) = ISNULL(b.ClientCoveragePlanId, 0)
                                                    AND ISNULL(a.ClientId, 0) = ISNULL(b.ClientId, 0)
                                                    AND ISNULL(a.ClientAddress1, '') = ISNULL(b.ClientAddress1, '')
                                                    AND ISNULL(a.ClientAddress2, '') = ISNULL(b.ClientAddress2, '')
                                                    AND ISNULL(a.ClientCity, '') = ISNULL(b.ClientCity, '')
                                                    AND ISNULL(a.ClientState, '') = ISNULL(b.ClientState, '')
                                                    AND ISNULL(a.ClientZip, '') = ISNULL(b.ClientZip, '')
                                                    AND ISNULL(a.InsuredAddress1, '') = ISNULL(b.InsuredAddress1, '')
                                                    AND ISNULL(a.InsuredAddress2, '') = ISNULL(b.InsuredAddress2, '')
                                                    AND ISNULL(a.InsuredCity, '') = ISNULL(b.InsuredCity, '')
                                                    AND ISNULL(a.InsuredState, '') = ISNULL(b.InsuredState, '')
                                                    AND ISNULL(a.InsuredZip, '') = ISNULL(b.InsuredZip, '')
                                                    AND ISNULL(a.AuthorizationId, 0) = ISNULL(b.AuthorizationId, 0)
													AND ISNULL(a.SubmissionReasonCode,'') = ISNULL(b.SubmissionReasonCode,'') -- MAJ 4/10/18
                                                    AND a.MinClaimLineId <= b.ClaimLineId
                                                    AND a.MaxClaimLineId >= b.ClaimLineId
                                                  )
                            JOIN dbo.ClaimLineItemGroups c ON ( CONVERT(VARCHAR, a.ClaimGroupId) = c.DeletedBy )
                                                              AND ISNULL(c.RecordDeleted, 'N') <> 'Y' -- V for Void
                    WHERE   c.ClaimBatchId = @ParamClaimBatchId    

            INSERT  INTO dbo.ClaimLineItems
                    ( ClaimLineItemGroupId ,
                      BillingCode ,
                      Modifier1 ,
                      Modifier2 ,
                      Modifier3 ,
                      Modifier4 ,
                      RevenueCode ,
                      RevenueCodeDescription ,
                      Units ,
                      DateOfService ,
                      ChargeAmount ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate ,
                      OriginalClaimLineItemId ,
                      ToBeVoided
					)
                    SELECT  clig.ClaimLineItemGroupId ,
                            cli.BillingCode ,
                            cli.Modifier1 ,
                            cli.Modifier2 ,
                            cli.Modifier3 ,
                            cli.Modifier4 ,
                            cli.RevenueCode ,
                            cli.RevenueCodeDescription ,
                            cli.Units ,
                            cli.DateOfService ,
                            cli.ChargeAmount ,
                            @ParamCurrentUser ,
                            @CurrentDate ,
                            @ParamCurrentUser ,
                            @CurrentDate ,
                            cli.ClaimLineItemId ,
                            'Y'
                    FROM    #ClaimBatchVoids AS cbv
                            JOIN dbo.ClaimLineItemGroups AS clig ON clig.DeletedBy = CONVERT(VARCHAR, cbv.ClaimLineItemGroupId)
                                                                    AND ISNULL(clig.RecordDeleted, 'N') = 'Y'
                                                                    AND clig.ClaimBatchId = @ParamClaimBatchId
                            JOIN dbo.ClaimLineItems AS cli ON cli.ClaimLineItemGroupId = cbv.ClaimLineItemGroupId
    
            IF @@error <> 0
                GOTO error    
    
            UPDATE  a
            SET     a.LineItemControlNumber = c.ClaimLineItemId
            FROM    dbo.ClaimLineItemGroups b
                    JOIN dbo.ClaimLineItems c ON ( b.ClaimLineItemGroupId = c.ClaimLineItemGroupId )
                    JOIN #ClaimLines a ON ( CONVERT(VARCHAR, a.ClaimLineId) = c.DeletedBy )
            WHERE   b.ClaimBatchId = @ParamClaimBatchId    
    
            IF @@error <> 0
                GOTO error    
    
            UPDATE  a
            SET     a.Field26PatientAccountNo = a.Field26PatientAccountNo + '-' + CONVERT(VARCHAR, b.ClaimLineItemGroupId)
            FROM    #ClaimGroupsData a
                    JOIN dbo.ClaimLineItemGroups b ON ( CONVERT(VARCHAR, a.ClaimGroupId) = b.DeletedBy )
            WHERE   b.ClaimBatchId = @ParamClaimBatchId    
    
            IF @@error <> 0
                GOTO error    
    
            INSERT  INTO dbo.ClaimNPIHCFA1500s
                    ( ClaimLineItemGroupId ,
                      PayerNameAndAddress ,
                      Field1Medicare ,
                      Field1Medicaid ,
                      Field1Champus ,
                      Field1Champva ,
                      Field1GroupHealthPlan ,
                      Field1GroupFeca ,
                      Field1GroupOther ,
                      Field1aInsuredNumber ,
                      Field2PatientName ,
                      Field3PatientDOBMM ,
                      Field3PatientDOBDD ,
                      Field3PatientDOBYY ,
                      Field3PatientMale ,
                      Field3PatientFemale ,
                      Field4InsuredName ,
                      Field5PatientAddress ,
                      Field5PatientCity ,
                      Field5PatientState ,
                      Field5PatientZip ,
                      Field5PatientPhone ,
                      Field6RelationshipSelf ,
                      Field6RelationshipSpouse ,
                      Field6RelationshipChild ,
                      Field6RelationshipOther ,
                      Field7InsuredAddress ,
                      Field7InsuredCity ,
                      Field7InsuredState ,
                      Field7InsuredZip ,
                      Field7InsuredPhone ,
                      Field8PatientStatusSingle ,
                      Field8PatientStatusMarried ,
                      Field8PatientStatusOther ,
                      Field8PatientStatusEmployed ,
                      Field8PatientStatusFullTime ,
                      Field8PatientStatusPartTime ,
                      Field9OtherInsuredName ,
                      Field9OtherInsuredGroupNumber ,
                      Field9OtherInsuredDOBMM ,
                      Field9OtherInsuredDOBDD ,
                      Field9OtherInsuredDOBYY ,
                      Field9OtherInsuredMale ,
                      Field9OtherInsuredFemale ,
                      Field9OtherInsuredEmployer ,
                      Field9OtherInsuredPlan ,
                      Field10aYes ,
                      Field10aNo ,
                      Field10bYes ,
                      Field10bNo ,
                      Field10cYes ,
                      Field10cNo ,
                      Field10d ,
                      Field11InsuredGroupNumber ,
                      Field11InsuredDOBMM ,
                      Field11InsuredDOBDD ,
                      Field11InsuredDOBYY ,
                      Field11InsuredMale ,
                      Field11InsuredFemale ,
                      Field11InsuredEmployer ,
                      Field11InsuredPlan ,
                      Field11OtherPlanYes ,
                      Field11OtherPlanNo ,
                      Field12Signed ,
                      Field12Date ,
                      Field13Signed ,
                      Field14InjuryMM ,
                      Field14InjuryDD ,
                      Field14InjuryYY ,
                      Field15FirstInjuryMM ,
                      Field15FirstInjuryDD ,
                      Field15FirstInjuryYY ,
                      Field16FromMM ,
                      Field16FromDD ,
                      Field16FromYY ,
                      Field16ToMM ,
                      Field16ToDD ,
                      Field16ToYY ,
                      Field17ReferringName ,
                      Field17aReferringIdQualifier ,
                      Field17aReferringId ,
                      Field17bReferringNPI ,
                      Field18FromMM ,
                      Field18FromDD ,
                      Field18FromYY ,
                      Field18ToMM ,
                      Field18ToDD ,
                      Field18ToYY ,
                      Field19 ,
                      Field20LabYes ,
                      Field20LabNo ,
                      Field20Charges1 ,
                      Field20Charges2 ,
                      Field21Diagnosis11 ,
                      Field21Diagnosis12 ,
                      Field21Diagnosis21 ,
                      Field21Diagnosis22 ,
                      Field21Diagnosis31 ,
                      Field21Diagnosis32 ,
                      Field21Diagnosis41 ,
                      Field21Diagnosis42 ,
                      Field21ICDIndicator ,
                      Field22MedicaidResubmissionCode ,
                      Field22MedicaidReferenceNumber ,
                      Field23AuthorizationNumber ,
                      Field24aFromMM1 ,
                      Field24aFromDD1 ,
                      Field24aFromYY1 ,
                      Field24aToMM1 ,
                      Field24aToDD1 ,
                      Field24aToYY1 ,
                      Field24bPlaceOfService1 ,
                      Field24cEMG1 ,
                      Field24dProcedureCode1 ,
                      Field24dModifier11 ,
                      Field24dModifier21 ,
                      Field24dModifier31 ,
                      Field24dModifier41 ,
                      Field24eDiagnosisCode1 ,
                      Field24fCharges11 ,
                      Field24fCharges21 ,
                      Field24gUnits1 ,
                      Field24hEPSDT1 ,
                      Field24iRenderingIdQualifier1 ,
                      Field24jRenderingId1 ,
                      Field24jRenderingNPI1 ,
                      Field24aFromMM2 ,
                      Field24aFromDD2 ,
                      Field24aFromYY2 ,
                      Field24aToMM2 ,
                      Field24aToDD2 ,
                      Field24aToYY2 ,
                      Field24bPlaceOfService2 ,
                      Field24cEMG2 ,
                      Field24dProcedureCode2 ,
                      Field24dModifier12 ,
                      Field24dModifier22 ,
                      Field24dModifier32 ,
                      Field24dModifier42 ,
                      Field24eDiagnosisCode2 ,
                      Field24fCharges12 ,
                      Field24fCharges22 ,
                      Field24gUnits2 ,
                      Field24hEPSDT2 ,
                      Field24iRenderingIdQualifier2 ,
                      Field24jRenderingId2 ,
                      Field24jRenderingNPI2 ,
                      Field24aFromMM3 ,
                      Field24aFromDD3 ,
                      Field24aFromYY3 ,
                      Field24aToMM3 ,
                      Field24aToDD3 ,
                      Field24aToYY3 ,
                      Field24bPlaceOfService3 ,
                      Field24cEMG3 ,
                      Field24dProcedureCode3 ,
                      Field24dModifier13 ,
                      Field24dModifier23 ,
                      Field24dModifier33 ,
                      Field24dModifier43 ,
                      Field24eDiagnosisCode3 ,
                      Field24fCharges13 ,
                      Field24fCharges23 ,
                      Field24gUnits3 ,
                      Field24hEPSDT3 ,
                      Field24iRenderingIdQualifier3 ,
                      Field24jRenderingId3 ,
                      Field24jRenderingNPI3 ,
                      Field24aFromMM4 ,
                      Field24aFromDD4 ,
                      Field24aFromYY4 ,
                      Field24aToMM4 ,
                      Field24aToDD4 ,
                      Field24aToYY4 ,
                      Field24bPlaceOfService4 ,
                      Field24cEMG4 ,
                      Field24dProcedureCode4 ,
                      Field24dModifier14 ,
                      Field24dModifier24 ,
                      Field24dModifier34 ,
                      Field24dModifier44 ,
                      Field24eDiagnosisCode4 ,
                      Field24fCharges14 ,
                      Field24fCharges24 ,
                      Field24gUnits4 ,
                      Field24hEPSDT4 ,
                      Field24iRenderingIdQualifier4 ,
                      Field24jRenderingId4 ,
                      Field24jRenderingNPI4 ,
                      Field24aFromMM5 ,
                      Field24aFromDD5 ,
                      Field24aFromYY5 ,
                      Field24aToMM5 ,
                      Field24aToDD5 ,
                      Field24aToYY5 ,
                      Field24bPlaceOfService5 ,
                      Field24cEMG5 ,
                      Field24dProcedureCode5 ,
                      Field24dModifier15 ,
                      Field24dModifier25 ,
                      Field24dModifier35 ,
                      Field24dModifier45 ,
                      Field24eDiagnosisCode5 ,
                      Field24fCharges15 ,
                      Field24fCharges25 ,
                      Field24gUnits5 ,
                      Field24hEPSDT5 ,
                      Field24iRenderingIdQualifier5 ,
                      Field24jRenderingId5 ,
                      Field24jRenderingNPI5 ,
                      Field24aFromMM6 ,
                      Field24aFromDD6 ,
                      Field24aFromYY6 ,
                      Field24aToMM6 ,
                      Field24aToDD6 ,
                      Field24aToYY6 ,
                      Field24bPlaceOfService6 ,
                      Field24cEMG6 ,
                      Field24dProcedureCode6 ,
                      Field24dModifier16 ,
                      Field24dModifier26 ,
                      Field24dModifier36 ,
                      Field24dModifier46 ,
                      Field24eDiagnosisCode6 ,
                      Field24fCharges16 ,
                      Field24fCharges26 ,
                      Field24gUnits6 ,
                      Field24hEPSDT6 ,
                      Field24iRenderingIdQualifier6 ,
                      Field24jRenderingId6 ,
                      Field24jRenderingNPI6 ,
                      Field25TaxId ,
                      Field25SSN ,
                      Field25EIN ,
                      Field26PatientAccountNo ,
                      Field27AssignmentYes ,
                      Field27AssignmentNo ,
                      Field28fTotalCharges1 ,
                      Field28fTotalCharges2 ,
                      Field29Paid1 ,
                      Field29Paid2 ,
                      Field30Balance1 ,
                      Field30Balance2 ,
                      Field31Signed ,
                      Field31Date ,
                      Field32Facility ,
                      Field32aFacilityNPI ,
                      Field32bFacilityProviderId ,
                      Field33BillingPhone ,
                      Field33BillingAddress ,
                      Field33aNPI ,
                      Field33bBillingProviderId ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
					)
                    SELECT  b.ClaimLineItemGroupId ,
                            a.PayerNameAndAddress ,
                            a.Field1Medicare ,
                            a.Field1Medicaid ,
                            a.Field1Champus ,
                            a.Field1Champva ,
                            a.Field1GroupHealthPlan ,
                            a.Field1GroupFeca ,
                            a.Field1GroupOther ,
                            a.Field1aInsuredNumber ,
                            a.Field2PatientName ,
                            a.Field3PatientDOBMM ,
                            a.Field3PatientDOBDD ,
                            a.Field3PatientDOBYY ,
                            a.Field3PatientMale ,
                            a.Field3PatientFemale ,
                            a.Field4InsuredName ,
                            a.Field5PatientAddress ,
                            a.Field5PatientCity ,
                            a.Field5PatientState ,
                            a.Field5PatientZip ,
                            a.Field5PatientPhone ,
                            a.Field6RelationshipSelf ,
                            a.Field6RelationshipSpouse ,
                            a.Field6RelationshipChild ,
                            a.Field6RelationshipOther ,
                            a.Field7InsuredAddress ,
                            a.Field7InsuredCity ,
                            a.Field7InsuredState ,
                            a.Field7InsuredZip ,
                            a.Field7InsuredPhone ,
                            a.Field8PatientStatusSingle ,
                            a.Field8PatientStatusMarried ,
                            a.Field8PatientStatusOther ,
                            a.Field8PatientStatusEmployed ,
                            a.Field8PatientStatusFullTime ,
                            a.Field8PatientStatusPartTime ,
                            a.Field9OtherInsuredName ,
                            a.Field9OtherInsuredGroupNumber ,
                            a.Field9OtherInsuredDOBMM ,
                            a.Field9OtherInsuredDOBDD ,
                            a.Field9OtherInsuredDOBYY ,
                            a.Field9OtherInsuredMale ,
                            a.Field9OtherInsuredFemale ,
                            a.Field9OtherInsuredEmployer ,
                            a.Field9OtherInsuredPlan ,
                            a.Field10aYes ,
                            a.Field10aNo ,
                            a.Field10bYes ,
                            a.Field10bNo ,
                            a.Field10cYes ,
                            a.Field10cNo ,
                            a.Field10d ,
                            a.Field11InsuredGroupNumber ,
                            a.Field11InsuredDOBMM ,
                            a.Field11InsuredDOBDD ,
                            a.Field11InsuredDOBYY ,
                            a.Field11InsuredMale ,
                            a.Field11InsuredFemale ,
                            a.Field11InsuredEmployer ,
                            a.Field11InsuredPlan ,
                            a.Field11OtherPlanYes ,
                            a.Field11OtherPlanNo ,
                            a.Field12Signed ,
                            a.Field12Date ,
                            a.Field13Signed ,
                            a.Field14InjuryMM ,
                            a.Field14InjuryDD ,
                            a.Field14InjuryYY ,
                            a.Field15FirstInjuryMM ,
                            a.Field15FirstInjuryDD ,
                            a.Field15FirstInjuryYY ,
                            a.Field16FromMM ,
                            a.Field16FromDD ,
                            a.Field16FromYY ,
                            a.Field16ToMM ,
                            a.Field16ToDD ,
                            a.Field16ToYY ,
                            a.Field17ReferringName ,
                            a.Field17aReferringIdQualifier ,
                            a.Field17aReferringId ,
                            a.Field17bReferringNPI ,
                            a.Field18FromMM ,
                            a.Field18FromDD ,
                            a.Field18FromYY ,
                            a.Field18ToMM ,
                            a.Field18ToDD ,
                            a.Field18ToYY ,
                            a.Field19 ,
                            a.Field20LabYes ,
                            a.Field20LabNo ,
                            a.Field20Charges1 ,
                            a.Field20Charges2 ,
                            a.Field21Diagnosis11 ,
                            a.Field21Diagnosis12 ,
                            a.Field21Diagnosis21 ,
                            a.Field21Diagnosis22 ,
                            a.Field21Diagnosis31 ,
                            a.Field21Diagnosis32 ,
                            a.Field21Diagnosis41 ,
                            a.Field21Diagnosis42 ,
                            a.Field21ICDIndicator ,
                            a.Field22MedicaidResubmissionCode ,
                            a.Field22MedicaidReferenceNumber ,
                            a.Field23AuthorizationNumber ,
                            a.Field24aFromMM1 ,
                            a.Field24aFromDD1 ,
                            a.Field24aFromYY1 ,
                            a.Field24aToMM1 ,
                            a.Field24aToDD1 ,
                            a.Field24aToYY1 ,
                            a.Field24bPlaceOfService1 ,
                            a.Field24cEMG1 ,
                            a.Field24dProcedureCode1 ,
                            a.Field24dModifier11 ,
                            a.Field24dModifier21 ,
                            a.Field24dModifier31 ,
                            a.Field24dModifier41 ,
                            a.Field24eDiagnosisCode1 ,
                            a.Field24fCharges11 ,
                            a.Field24fCharges21 ,
                            a.Field24gUnits1 ,
                            a.Field24hEPSDT1 ,
                            a.Field24iRenderingIdQualifier1 ,
                            a.Field24jRenderingId1 ,
                            a.Field24jRenderingNPI1 ,
                            a.Field24aFromMM2 ,
                            a.Field24aFromDD2 ,
                            a.Field24aFromYY2 ,
                            a.Field24aToMM2 ,
                            a.Field24aToDD2 ,
                            a.Field24aToYY2 ,
                            a.Field24bPlaceOfService2 ,
                            a.Field24cEMG2 ,
                            a.Field24dProcedureCode2 ,
                            a.Field24dModifier12 ,
                            a.Field24dModifier22 ,
                            a.Field24dModifier32 ,
                            a.Field24dModifier42 ,
                            a.Field24eDiagnosisCode2 ,
                            a.Field24fCharges12 ,
                            a.Field24fCharges22 ,
                            a.Field24gUnits2 ,
                            a.Field24hEPSDT2 ,
                            a.Field24iRenderingIdQualifier2 ,
                            a.Field24jRenderingId2 ,
                            a.Field24jRenderingNPI2 ,
                            a.Field24aFromMM3 ,
                            a.Field24aFromDD3 ,
                            a.Field24aFromYY3 ,
                            a.Field24aToMM3 ,
                            a.Field24aToDD3 ,
                            a.Field24aToYY3 ,
                            a.Field24bPlaceOfService3 ,
                            a.Field24cEMG3 ,
                            a.Field24dProcedureCode3 ,
                            a.Field24dModifier13 ,
                            a.Field24dModifier23 ,
                            a.Field24dModifier33 ,
                            a.Field24dModifier43 ,
                            a.Field24eDiagnosisCode3 ,
                            a.Field24fCharges13 ,
                            a.Field24fCharges23 ,
                            a.Field24gUnits3 ,
                            a.Field24hEPSDT3 ,
                            a.Field24iRenderingIdQualifier3 ,
                            a.Field24jRenderingId3 ,
                            a.Field24jRenderingNPI3 ,
                            a.Field24aFromMM4 ,
                            a.Field24aFromDD4 ,
                            a.Field24aFromYY4 ,
                            a.Field24aToMM4 ,
                            a.Field24aToDD4 ,
                            a.Field24aToYY4 ,
                            a.Field24bPlaceOfService4 ,
                            a.Field24cEMG4 ,
                            a.Field24dProcedureCode4 ,
                            a.Field24dModifier14 ,
                            a.Field24dModifier24 ,
                            a.Field24dModifier34 ,
                            a.Field24dModifier44 ,
                            a.Field24eDiagnosisCode4 ,
                            a.Field24fCharges14 ,
                            a.Field24fCharges24 ,
                            a.Field24gUnits4 ,
                            a.Field24hEPSDT4 ,
                            a.Field24iRenderingIdQualifier4 ,
                            a.Field24jRenderingId4 ,
                            a.Field24jRenderingNPI4 ,
                            a.Field24aFromMM5 ,
                            a.Field24aFromDD5 ,
                            a.Field24aFromYY5 ,
                            a.Field24aToMM5 ,
                            a.Field24aToDD5 ,
                            a.Field24aToYY5 ,
                            a.Field24bPlaceOfService5 ,
                            a.Field24cEMG5 ,
                            a.Field24dProcedureCode5 ,
                            a.Field24dModifier15 ,
                            a.Field24dModifier25 ,
                            a.Field24dModifier35 ,
                            a.Field24dModifier45 ,
                            a.Field24eDiagnosisCode5 ,
                            a.Field24fCharges15 ,
                            a.Field24fCharges25 ,
                            a.Field24gUnits5 ,
                            a.Field24hEPSDT5 ,
                            a.Field24iRenderingIdQualifier5 ,
                            a.Field24jRenderingId5 ,
                            a.Field24jRenderingNPI5 ,
                            a.Field24aFromMM6 ,
                            a.Field24aFromDD6 ,
                            a.Field24aFromYY6 ,
                            a.Field24aToMM6 ,
                            a.Field24aToDD6 ,
                            a.Field24aToYY6 ,
                            a.Field24bPlaceOfService6 ,
                            a.Field24cEMG6 ,
                            a.Field24dProcedureCode6 ,
                            a.Field24dModifier16 ,
                            a.Field24dModifier26 ,
                            a.Field24dModifier36 ,
                            a.Field24dModifier46 ,
                            a.Field24eDiagnosisCode6 ,
                            a.Field24fCharges16 ,
                            a.Field24fCharges26 ,
                            a.Field24gUnits6 ,
                            a.Field24hEPSDT6 ,
                            a.Field24iRenderingIdQualifier6 ,
                            a.Field24jRenderingId6 ,
                            a.Field24jRenderingNPI6 ,
                            a.Field25TaxId ,
                            a.Field25SSN ,
                            a.Field25EIN ,
                            a.Field26PatientAccountNo ,
                            a.Field27AssignmentYes ,
                            a.Field27AssignmentNo ,
                            a.Field28fTotalCharges1 ,
                            a.Field28fTotalCharges2 ,
                            a.Field29Paid1 ,
                            a.Field29Paid2 ,
                            a.Field30Balance1 ,
                            a.Field30Balance2 ,
                            a.Field31Signed ,
                            a.Field31Date ,
                            a.Field32Facility ,
                            a.Field32aFacilityNPI ,
                            a.Field32bFacilityProviderId ,
                            a.Field33BillingPhone ,
                            a.Field33BillingAddress ,
                            a.Field33aNPI ,
                            a.Field33bBillingProviderId ,
                            @ParamCurrentUser ,
                            @CurrentDate ,
                            @ParamCurrentUser ,
                            @CurrentDate
                    FROM    #ClaimGroupsData a
                            JOIN dbo.ClaimLineItemGroups b ON ( CONVERT(VARCHAR, a.ClaimGroupId) = b.DeletedBy )
                                                              AND ISNULL(b.RecordDeleted, 'N') <> 'Y'
                    WHERE   b.ClaimBatchId = @ParamClaimBatchId    


            INSERT  INTO dbo.ClaimNPIHCFA1500s
                    ( ClaimLineItemGroupId ,
                      PayerNameAndAddress ,
                      Field1Medicare ,
                      Field1Medicaid ,
                      Field1Champus ,
                      Field1Champva ,
                      Field1GroupHealthPlan ,
                      Field1GroupFeca ,
                      Field1GroupOther ,
                      Field1aInsuredNumber ,
                      Field2PatientName ,
                      Field3PatientDOBMM ,
                      Field3PatientDOBDD ,
                      Field3PatientDOBYY ,
                      Field3PatientMale ,
                      Field3PatientFemale ,
                      Field4InsuredName ,
                      Field5PatientAddress ,
                      Field5PatientCity ,
                      Field5PatientState ,
                      Field5PatientZip ,
                      Field5PatientPhone ,
                      Field6RelationshipSelf ,
                      Field6RelationshipSpouse ,
                      Field6RelationshipChild ,
                      Field6RelationshipOther ,
                      Field7InsuredAddress ,
                      Field7InsuredCity ,
                      Field7InsuredState ,
                      Field7InsuredZip ,
                      Field7InsuredPhone ,
                      Field8PatientStatusSingle ,
                      Field8PatientStatusMarried ,
                      Field8PatientStatusOther ,
                      Field8PatientStatusEmployed ,
                      Field8PatientStatusFullTime ,
                      Field8PatientStatusPartTime ,
                      Field9OtherInsuredName ,
                      Field9OtherInsuredGroupNumber ,
                      Field9OtherInsuredDOBMM ,
                      Field9OtherInsuredDOBDD ,
                      Field9OtherInsuredDOBYY ,
                      Field9OtherInsuredMale ,
                      Field9OtherInsuredFemale ,
                      Field9OtherInsuredEmployer ,
                      Field9OtherInsuredPlan ,
                      Field10aYes ,
                      Field10aNo ,
                      Field10bYes ,
                      Field10bNo ,
                      Field10cYes ,
                      Field10cNo ,
                      Field10d ,
                      Field11InsuredGroupNumber ,
                      Field11InsuredDOBMM ,
                      Field11InsuredDOBDD ,
                      Field11InsuredDOBYY ,
                      Field11InsuredMale ,
                      Field11InsuredFemale ,
                      Field11InsuredEmployer ,
                      Field11InsuredPlan ,
                      Field11OtherPlanYes ,
                      Field11OtherPlanNo ,
                      Field12Signed ,
                      Field12Date ,
                      Field13Signed ,
                      Field14InjuryMM ,
                      Field14InjuryDD ,
                      Field14InjuryYY ,
                      Field15FirstInjuryMM ,
                      Field15FirstInjuryDD ,
                      Field15FirstInjuryYY ,
                      Field16FromMM ,
                      Field16FromDD ,
                      Field16FromYY ,
                      Field16ToMM ,
                      Field16ToDD ,
                      Field16ToYY ,
                      Field17ReferringName ,
                      Field17aReferringIdQualifier ,
                      Field17aReferringId ,
                      Field17bReferringNPI ,
                      Field18FromMM ,
                      Field18FromDD ,
                      Field18FromYY ,
                      Field18ToMM ,
                      Field18ToDD ,
                      Field18ToYY ,
                      Field19 ,
                      Field20LabYes ,
                      Field20LabNo ,
                      Field20Charges1 ,
                      Field20Charges2 ,
                      Field21Diagnosis11 ,
                      Field21Diagnosis12 ,
                      Field21Diagnosis21 ,
                      Field21Diagnosis22 ,
                      Field21Diagnosis31 ,
                      Field21Diagnosis32 ,
                      Field21Diagnosis41 ,
                      Field21Diagnosis42 ,
                      Field21ICDIndicator ,
                      Field22MedicaidResubmissionCode ,
                      Field22MedicaidReferenceNumber ,
                      Field23AuthorizationNumber ,
                      Field24aFromMM1 ,
                      Field24aFromDD1 ,
                      Field24aFromYY1 ,
                      Field24aToMM1 ,
                      Field24aToDD1 ,
                      Field24aToYY1 ,
                      Field24bPlaceOfService1 ,
                      Field24cEMG1 ,
                      Field24dProcedureCode1 ,
                      Field24dModifier11 ,
                      Field24dModifier21 ,
                      Field24dModifier31 ,
                      Field24dModifier41 ,
                      Field24eDiagnosisCode1 ,
                      Field24fCharges11 ,
                      Field24fCharges21 ,
                      Field24gUnits1 ,
                      Field24hEPSDT1 ,
                      Field24iRenderingIdQualifier1 ,
                      Field24jRenderingId1 ,
                      Field24jRenderingNPI1 ,
                      Field24aFromMM2 ,
                      Field24aFromDD2 ,
                      Field24aFromYY2 ,
                      Field24aToMM2 ,
                      Field24aToDD2 ,
                      Field24aToYY2 ,
                      Field24bPlaceOfService2 ,
                      Field24cEMG2 ,
                      Field24dProcedureCode2 ,
                      Field24dModifier12 ,
                      Field24dModifier22 ,
                      Field24dModifier32 ,
                      Field24dModifier42 ,
                      Field24eDiagnosisCode2 ,
                      Field24fCharges12 ,
                      Field24fCharges22 ,
                      Field24gUnits2 ,
                      Field24hEPSDT2 ,
                      Field24iRenderingIdQualifier2 ,
                      Field24jRenderingId2 ,
                      Field24jRenderingNPI2 ,
                      Field24aFromMM3 ,
                      Field24aFromDD3 ,
                      Field24aFromYY3 ,
                      Field24aToMM3 ,
                      Field24aToDD3 ,
                      Field24aToYY3 ,
                      Field24bPlaceOfService3 ,
                      Field24cEMG3 ,
                      Field24dProcedureCode3 ,
                      Field24dModifier13 ,
                      Field24dModifier23 ,
                      Field24dModifier33 ,
                      Field24dModifier43 ,
                      Field24eDiagnosisCode3 ,
                      Field24fCharges13 ,
                      Field24fCharges23 ,
                      Field24gUnits3 ,
                      Field24hEPSDT3 ,
                      Field24iRenderingIdQualifier3 ,
                      Field24jRenderingId3 ,
                      Field24jRenderingNPI3 ,
                      Field24aFromMM4 ,
                      Field24aFromDD4 ,
                      Field24aFromYY4 ,
                      Field24aToMM4 ,
                      Field24aToDD4 ,
                      Field24aToYY4 ,
                      Field24bPlaceOfService4 ,
                      Field24cEMG4 ,
                      Field24dProcedureCode4 ,
                      Field24dModifier14 ,
                      Field24dModifier24 ,
                      Field24dModifier34 ,
                      Field24dModifier44 ,
                      Field24eDiagnosisCode4 ,
                      Field24fCharges14 ,
                      Field24fCharges24 ,
                      Field24gUnits4 ,
                      Field24hEPSDT4 ,
                      Field24iRenderingIdQualifier4 ,
                      Field24jRenderingId4 ,
                      Field24jRenderingNPI4 ,
                      Field24aFromMM5 ,
                      Field24aFromDD5 ,
                      Field24aFromYY5 ,
                      Field24aToMM5 ,
                      Field24aToDD5 ,
                      Field24aToYY5 ,
                      Field24bPlaceOfService5 ,
                      Field24cEMG5 ,
                      Field24dProcedureCode5 ,
                      Field24dModifier15 ,
                      Field24dModifier25 ,
                      Field24dModifier35 ,
                      Field24dModifier45 ,
                      Field24eDiagnosisCode5 ,
                      Field24fCharges15 ,
                      Field24fCharges25 ,
                      Field24gUnits5 ,
                      Field24hEPSDT5 ,
                      Field24iRenderingIdQualifier5 ,
                      Field24jRenderingId5 ,
                      Field24jRenderingNPI5 ,
                      Field24aFromMM6 ,
                      Field24aFromDD6 ,
                      Field24aFromYY6 ,
                      Field24aToMM6 ,
                      Field24aToDD6 ,
                      Field24aToYY6 ,
                      Field24bPlaceOfService6 ,
                      Field24cEMG6 ,
                      Field24dProcedureCode6 ,
                      Field24dModifier16 ,
                      Field24dModifier26 ,
                      Field24dModifier36 ,
                      Field24dModifier46 ,
                      Field24eDiagnosisCode6 ,
                      Field24fCharges16 ,
                      Field24fCharges26 ,
                      Field24gUnits6 ,
                      Field24hEPSDT6 ,
                      Field24iRenderingIdQualifier6 ,
                      Field24jRenderingId6 ,
                      Field24jRenderingNPI6 ,
                      Field25TaxId ,
                      Field25SSN ,
                      Field25EIN ,
                      Field26PatientAccountNo ,
                      Field27AssignmentYes ,
                      Field27AssignmentNo ,
                      Field28fTotalCharges1 ,
                      Field28fTotalCharges2 ,
                      Field29Paid1 ,
                      Field29Paid2 ,
                      Field30Balance1 ,
                      Field30Balance2 ,
                      Field31Signed ,
                      Field31Date ,
                      Field32Facility ,
                      Field32aFacilityNPI ,
                      Field32bFacilityProviderId ,
                      Field33BillingPhone ,
                      Field33BillingAddress ,
                      Field33aNPI ,
                      Field33bBillingProviderId ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
					)
                    SELECT  clig.ClaimLineItemGroupId ,
                            chcfa.PayerNameAndAddress ,
                            chcfa.Field1Medicare ,
                            chcfa.Field1Medicaid ,
                            chcfa.Field1Champus ,
                            chcfa.Field1Champva ,
                            chcfa.Field1GroupHealthPlan ,
                            chcfa.Field1GroupFeca ,
                            chcfa.Field1GroupOther ,
                            chcfa.Field1aInsuredNumber ,
                            chcfa.Field2PatientName ,
                            chcfa.Field3PatientDOBMM ,
                            chcfa.Field3PatientDOBDD ,
                            chcfa.Field3PatientDOBYY ,
                            chcfa.Field3PatientMale ,
                            chcfa.Field3PatientFemale ,
                            chcfa.Field4InsuredName ,
                            chcfa.Field5PatientAddress ,
                            chcfa.Field5PatientCity ,
                            chcfa.Field5PatientState ,
                            chcfa.Field5PatientZip ,
                            chcfa.Field5PatientPhone ,
                            chcfa.Field6RelationshipSelf ,
                            chcfa.Field6RelationshipSpouse ,
                            chcfa.Field6RelationshipChild ,
                            chcfa.Field6RelationshipOther ,
                            chcfa.Field7InsuredAddress ,
                            chcfa.Field7InsuredCity ,
                            chcfa.Field7InsuredState ,
                            chcfa.Field7InsuredZip ,
                            chcfa.Field7InsuredPhone ,
                            chcfa.Field8PatientStatusSingle ,
                            chcfa.Field8PatientStatusMarried ,
                            chcfa.Field8PatientStatusOther ,
                            chcfa.Field8PatientStatusEmployed ,
                            chcfa.Field8PatientStatusFullTime ,
                            chcfa.Field8PatientStatusPartTime ,
                            chcfa.Field9OtherInsuredName ,
                            chcfa.Field9OtherInsuredGroupNumber ,
                            chcfa.Field9OtherInsuredDOBMM ,
                            chcfa.Field9OtherInsuredDOBDD ,
                            chcfa.Field9OtherInsuredDOBYY ,
                            chcfa.Field9OtherInsuredMale ,
                            chcfa.Field9OtherInsuredFemale ,
                            chcfa.Field9OtherInsuredEmployer ,
                            chcfa.Field9OtherInsuredPlan ,
                            chcfa.Field10aYes ,
                            chcfa.Field10aNo ,
                            chcfa.Field10bYes ,
                            chcfa.Field10bNo ,
                            chcfa.Field10cYes ,
                            chcfa.Field10cNo ,
                            chcfa.Field10d ,
                            chcfa.Field11InsuredGroupNumber ,
                            chcfa.Field11InsuredDOBMM ,
                            chcfa.Field11InsuredDOBDD ,
                            chcfa.Field11InsuredDOBYY ,
                            chcfa.Field11InsuredMale ,
                            chcfa.Field11InsuredFemale ,
                            chcfa.Field11InsuredEmployer ,
                            chcfa.Field11InsuredPlan ,
                            chcfa.Field11OtherPlanYes ,
                            chcfa.Field11OtherPlanNo ,
                            chcfa.Field12Signed ,
                            chcfa.Field12Date ,
                            chcfa.Field13Signed ,
                            chcfa.Field14InjuryMM ,
                            chcfa.Field14InjuryDD ,
                            chcfa.Field14InjuryYY ,
                            chcfa.Field15FirstInjuryMM ,
                            chcfa.Field15FirstInjuryDD ,
                            chcfa.Field15FirstInjuryYY ,
                            chcfa.Field16FromMM ,
                            chcfa.Field16FromDD ,
                            chcfa.Field16FromYY ,
                            chcfa.Field16ToMM ,
                            chcfa.Field16ToDD ,
                            chcfa.Field16ToYY ,
                            chcfa.Field17ReferringName ,
                            chcfa.Field17aReferringIdQualifier ,
                            chcfa.Field17aReferringId ,
                            chcfa.Field17bReferringNPI ,
                            chcfa.Field18FromMM ,
                            chcfa.Field18FromDD ,
                            chcfa.Field18FromYY ,
                            chcfa.Field18ToMM ,
                            chcfa.Field18ToDD ,
                            chcfa.Field18ToYY ,
                            chcfa.Field19 ,
                            chcfa.Field20LabYes ,
                            chcfa.Field20LabNo ,
                            chcfa.Field20Charges1 ,
                            chcfa.Field20Charges2 ,
                            chcfa.Field21Diagnosis11 ,
                            chcfa.Field21Diagnosis12 ,
                            chcfa.Field21Diagnosis21 ,
                            chcfa.Field21Diagnosis22 ,
                            chcfa.Field21Diagnosis31 ,
                            chcfa.Field21Diagnosis32 ,
                            chcfa.Field21Diagnosis41 ,
                            chcfa.Field21Diagnosis42 ,
                            chcfa.Field21ICDIndicator ,
                            '8' ,
                            cbv.PayerClaimControlNumber ,
                            chcfa.Field23AuthorizationNumber ,
                            chcfa.Field24aFromMM1 ,
                            chcfa.Field24aFromDD1 ,
                            chcfa.Field24aFromYY1 ,
                            chcfa.Field24aToMM1 ,
                            chcfa.Field24aToDD1 ,
                            chcfa.Field24aToYY1 ,
                            chcfa.Field24bPlaceOfService1 ,
                            chcfa.Field24cEMG1 ,
                            chcfa.Field24dProcedureCode1 ,
                            chcfa.Field24dModifier11 ,
                            chcfa.Field24dModifier21 ,
                            chcfa.Field24dModifier31 ,
                            chcfa.Field24dModifier41 ,
                            chcfa.Field24eDiagnosisCode1 ,
                            chcfa.Field24fCharges11 ,
                            chcfa.Field24fCharges21 ,
                            chcfa.Field24gUnits1 ,
                            chcfa.Field24hEPSDT1 ,
                            chcfa.Field24iRenderingIdQualifier1 ,
                            chcfa.Field24jRenderingId1 ,
                            chcfa.Field24jRenderingNPI1 ,
                            chcfa.Field24aFromMM2 ,
                            chcfa.Field24aFromDD2 ,
                            chcfa.Field24aFromYY2 ,
                            chcfa.Field24aToMM2 ,
                            chcfa.Field24aToDD2 ,
                            chcfa.Field24aToYY2 ,
                            chcfa.Field24bPlaceOfService2 ,
                            chcfa.Field24cEMG2 ,
                            chcfa.Field24dProcedureCode2 ,
                            chcfa.Field24dModifier12 ,
                            chcfa.Field24dModifier22 ,
                            chcfa.Field24dModifier32 ,
                            chcfa.Field24dModifier42 ,
                            chcfa.Field24eDiagnosisCode2 ,
                            chcfa.Field24fCharges12 ,
                            chcfa.Field24fCharges22 ,
                            chcfa.Field24gUnits2 ,
                            chcfa.Field24hEPSDT2 ,
                            chcfa.Field24iRenderingIdQualifier2 ,
                            chcfa.Field24jRenderingId2 ,
                            chcfa.Field24jRenderingNPI2 ,
                            chcfa.Field24aFromMM3 ,
                            chcfa.Field24aFromDD3 ,
                            chcfa.Field24aFromYY3 ,
                            chcfa.Field24aToMM3 ,
                            chcfa.Field24aToDD3 ,
                            chcfa.Field24aToYY3 ,
                            chcfa.Field24bPlaceOfService3 ,
                            chcfa.Field24cEMG3 ,
                            chcfa.Field24dProcedureCode3 ,
                            chcfa.Field24dModifier13 ,
                            chcfa.Field24dModifier23 ,
                            chcfa.Field24dModifier33 ,
                            chcfa.Field24dModifier43 ,
                            chcfa.Field24eDiagnosisCode3 ,
                            chcfa.Field24fCharges13 ,
                            chcfa.Field24fCharges23 ,
                            chcfa.Field24gUnits3 ,
                            chcfa.Field24hEPSDT3 ,
                            chcfa.Field24iRenderingIdQualifier3 ,
                            chcfa.Field24jRenderingId3 ,
                            chcfa.Field24jRenderingNPI3 ,
                            chcfa.Field24aFromMM4 ,
                            chcfa.Field24aFromDD4 ,
                            chcfa.Field24aFromYY4 ,
                            chcfa.Field24aToMM4 ,
                            chcfa.Field24aToDD4 ,
                            chcfa.Field24aToYY4 ,
                            chcfa.Field24bPlaceOfService4 ,
                            chcfa.Field24cEMG4 ,
                            chcfa.Field24dProcedureCode4 ,
                            chcfa.Field24dModifier14 ,
                            chcfa.Field24dModifier24 ,
                            chcfa.Field24dModifier34 ,
                            chcfa.Field24dModifier44 ,
                            chcfa.Field24eDiagnosisCode4 ,
                            chcfa.Field24fCharges14 ,
                            chcfa.Field24fCharges24 ,
                            chcfa.Field24gUnits4 ,
                            chcfa.Field24hEPSDT4 ,
                            chcfa.Field24iRenderingIdQualifier4 ,
                            chcfa.Field24jRenderingId4 ,
                            chcfa.Field24jRenderingNPI4 ,
                            chcfa.Field24aFromMM5 ,
                            chcfa.Field24aFromDD5 ,
                            chcfa.Field24aFromYY5 ,
                            chcfa.Field24aToMM5 ,
                            chcfa.Field24aToDD5 ,
                            chcfa.Field24aToYY5 ,
                            chcfa.Field24bPlaceOfService5 ,
                            chcfa.Field24cEMG5 ,
                            chcfa.Field24dProcedureCode5 ,
                            chcfa.Field24dModifier15 ,
                            chcfa.Field24dModifier25 ,
                            chcfa.Field24dModifier35 ,
                            chcfa.Field24dModifier45 ,
                            chcfa.Field24eDiagnosisCode5 ,
                            chcfa.Field24fCharges15 ,
                            chcfa.Field24fCharges25 ,
                            chcfa.Field24gUnits5 ,
                            chcfa.Field24hEPSDT5 ,
                            chcfa.Field24iRenderingIdQualifier5 ,
                            chcfa.Field24jRenderingId5 ,
                            chcfa.Field24jRenderingNPI5 ,
                            chcfa.Field24aFromMM6 ,
                            chcfa.Field24aFromDD6 ,
                            chcfa.Field24aFromYY6 ,
                            chcfa.Field24aToMM6 ,
                            chcfa.Field24aToDD6 ,
                            chcfa.Field24aToYY6 ,
                            chcfa.Field24bPlaceOfService6 ,
                            chcfa.Field24cEMG6 ,
                            chcfa.Field24dProcedureCode6 ,
                            chcfa.Field24dModifier16 ,
                            chcfa.Field24dModifier26 ,
                            chcfa.Field24dModifier36 ,
                            chcfa.Field24dModifier46 ,
                            chcfa.Field24eDiagnosisCode6 ,
                            chcfa.Field24fCharges16 ,
                            chcfa.Field24fCharges26 ,
                            chcfa.Field24gUnits6 ,
                            chcfa.Field24hEPSDT6 ,
                            chcfa.Field24iRenderingIdQualifier6 ,
                            chcfa.Field24jRenderingId6 ,
                            chcfa.Field24jRenderingNPI6 ,
                            chcfa.Field25TaxId ,
                            chcfa.Field25SSN ,
                            chcfa.Field25EIN ,
                            chcfa.Field26PatientAccountNo ,
                            chcfa.Field27AssignmentYes ,
                            chcfa.Field27AssignmentNo ,
                            chcfa.Field28fTotalCharges1 ,
                            chcfa.Field28fTotalCharges2 ,
                            chcfa.Field29Paid1 ,
                            chcfa.Field29Paid2 ,
                            chcfa.Field30Balance1 ,
                            chcfa.Field30Balance2 ,
                            chcfa.Field31Signed ,
                            chcfa.Field31Date ,
                            chcfa.Field32Facility ,
                            chcfa.Field32aFacilityNPI ,
                            chcfa.Field32bFacilityProviderId ,
                            chcfa.Field33BillingPhone ,
                            chcfa.Field33BillingAddress ,
                            chcfa.Field33aNPI ,
                            chcfa.Field33bBillingProviderId ,
                            @ParamCurrentUser ,
                            @CurrentDate ,
                            @ParamCurrentUser ,
                            @CurrentDate
                    FROM    #ClaimBatchVoids AS cbv
                            JOIN dbo.ClaimNPIHCFA1500s chcfa ON chcfa.ClaimLineItemGroupId = cbv.ClaimLineItemGroupId
                            JOIN dbo.ClaimLineItemGroups AS clig ON clig.DeletedBy = CONVERT(VARCHAR, cbv.ClaimLineItemGroupId)
                                                                    AND ISNULL(clig.RecordDeleted, 'N') = 'Y'
                                                                    AND clig.ClaimBatchId = @ParamClaimBatchId
    
            IF @@error <> 0
                GOTO error    
    
            EXEC dbo.scsp_PMClaimsHCFA1500 @ParamCurrentUser, @ParamClaimBatchId    
    
            IF @@error <> 0
                GOTO error    
				-- claim line item charges for voids.

            INSERT  INTO dbo.ClaimLineItemCharges
                    ( ClaimLineItemId ,
                      ChargeId ,
                      RowIdentifier ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
					)
                    SELECT  cli.ClaimLineItemId-- ClaimLineItemId - int
                            ,
                            clic.ChargeId-- ChargeId - int
                            ,
                            NEWID()-- RowIdentifier - type_GUID
                            ,
                            @ParamCurrentUser-- CreatedBy - type_CurrentUser
                            ,
                            @CurrentDate-- CreatedDate - type_CurrentDatetime
                            ,
                            @ParamCurrentUser-- ModifiedBy - type_CurrentUser
                            ,
                            @CurrentDate-- ModifiedDate - type_CurrentDatetime
                    FROM    #ClaimBatchVoids AS cbv
                            JOIN dbo.ClaimLineItemGroups AS clig ON clig.DeletedBy = CONVERT(VARCHAR, cbv.ClaimLineItemGroupId)
                                                                    AND ISNULL(clig.RecordDeleted, 'N') = 'V'
                                                                    AND clig.ClaimBatchId = @ParamClaimBatchId
                            JOIN dbo.ClaimLineItems AS cli ON cli.ClaimLineItemGroupId = clig.ClaimLineItemGroupId
                            JOIN dbo.ClaimLineItems AS cli2 ON cli.OriginalClaimLineItemId = cli2.ClaimLineItemId
                            JOIN dbo.ClaimLineItemCharges AS clic ON clic.ClaimLineItemId = cli2.ClaimLineItemId

            IF @@error <> 0
                GOTO error    
    
    
            UPDATE  c
            SET     c.DeletedBy = NULL ,
                    c.RecordDeleted = NULL
            FROM    dbo.ClaimLineItemGroups b
                    JOIN dbo.ClaimLineItems c ON ( b.ClaimLineItemGroupId = c.ClaimLineItemGroupId )
            WHERE   b.ClaimBatchId = @ParamClaimBatchId    
    
            IF @@error <> 0
                GOTO error    
    
            UPDATE  b
            SET     b.DeletedBy = NULL ,
                    b.RecordDeleted = NULL
            FROM    dbo.ClaimLineItemGroups b
            WHERE   b.ClaimBatchId = @ParamClaimBatchId    
    
            IF @@error <> 0
                GOTO error    
    
            INSERT  INTO dbo.ClaimLineItemCharges
                    ( ClaimLineItemId ,
                      ChargeId ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
					)
                    SELECT  a.LineItemControlNumber ,
                            b.ChargeId ,
                            @ParamCurrentUser ,
                            @CurrentDate ,
                            @ParamCurrentUser ,
                            @CurrentDate
                    FROM    #ClaimLines a
                            JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )    
    
            IF @@error <> 0
                GOTO error    
    
            UPDATE  c
            SET     c.BillingCode = a.BillingCode ,
                    c.Modifier1 = a.Modifier1 ,
                    c.Modifier2 = a.Modifier2 ,
                    c.Modifier3 = a.Modifier3 ,
                    c.Modifier4 = a.Modifier4 ,
                    c.RevenueCode = a.RevenueCode ,
                    c.RevenueCodeDescription = a.RevenueCodeDescription
            FROM    #ClaimLines a
                    JOIN #Charges b ON ( a.ClaimLineId = b.ClaimLineId )
                    JOIN dbo.Charges c ON ( b.ChargeId = c.ChargeId )    
    
            IF @@error <> 0
                GOTO error    

-- Update the claim file data, status and processed date    
            UPDATE  a
            SET     a.Status = 4723 ,
                    a.ProcessedDate = CONVERT(VARCHAR, GETDATE(), 101) ,
                    a.BatchProcessProgress = 100 ,
                    a.ModifiedBy = @ParamCurrentUser ,
                    a.ModifiedDate = @CurrentDate
            FROM    dbo.ClaimBatches a
            WHERE   a.ClaimBatchId = @ParamClaimBatchId    
        

        END
        
        
    ProcessedStatus: 
    SELECT  dbo.Ssf_GetMesageByMessageCode(450, 'PROCESSEDSUCCESSFULLY_SSP', 'Processed Successfully') AS ErrorMessage

    RETURN

    error:

    SELECT  @ErrorMessage AS ErrorMessage


GO


