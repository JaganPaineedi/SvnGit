/****** Object:  StoredProcedure [dbo].[ssp_SureScriptsGetScriptInformation]    Script Date: 10/30/2012 11:10:17 AM ******/
IF EXISTS ( SELECT  1
            FROM    INFORMATION_SCHEMA.ROUTINES
            WHERE   SPECIFIC_SCHEMA = 'dbo'
                    AND SPECIFIC_NAME = 'ssp_SureScriptsGetScriptInformation' ) 
    DROP PROCEDURE [dbo].[ssp_SureScriptsGetScriptInformation]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SureScriptsGetScriptInformation]    Script Date: 10/30/2012 11:10:17 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SureScriptsGetScriptInformation]
/*****************************************************************************************************/
/*
Stored Procedure: dbo.ssp_SureScriptsGetPendingNewRxRequests

Copyright: 2011 Streamline Healthcare Solutions, LLC

Creation Date:  2011.03.04

Purpose:
	Get new medication orders that have not been sent to Surescripts yet.

Input Parameters:
   @ClientMedicationScriptActivityId int	-- script activity identifier from ClientMedicationScriptActivities
   @OrderingMethod char(1)					-- (P)rint / (F)ax / (E)lectronic
   @OriginalData int						-- 0 = pull from the temp tables
   @LocationId int 							-- Prescribing location identifier from Locations table
   @PrintChartCopy char(5)					-- 'Y' indicates a chart copy should be printed
   @SessionId varchar(24)					-- ASP Host session identifier


Output Parameters:

Return:
	Data table with format as required by web service

Calls:

Called by:
	Surescripts Client Windows Service

Log:
	2011.03.04 - Created.
Changes:
	3/25/2015 Steczynski Format Quantity to drop trailing zeros, applied dbo.ssf_RemoveTrailingZeros, Task 215 
 /*  21 Oct 2015	Revathi					what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  */ 
/* 											why:task #609, Network180 Customization  */ 	
*/
/*****************************************************************************************************/
    @ClientMedicationScriptActivityId INT ,
    @OrderingMethod CHAR(1) ,
    @OriginalData INT ,
    @LocationId INT ,
    @PrintChartCopy CHAR(5) ,
    @SessionId VARCHAR(24)

/*
   Changelog:
      TER - 8/21/09 - Added city, state, zip to location address field.
	avoss - replaced line 428 with new preview location address logic
	avoss - 10-04-2009	- Added a check for C2 Meds
	avoss - 10-16-2009	--add sysconfig offset days for duration on titrations
	avoss - 10-16-2009	--added messages for c2 drugs
	avoss - 10-28-2009  --changed titration logic for multiple titrations on a script
	avoss - 11-12-2009	--spell out the quantities for meds using user-defined functions
	ter -	11-13-2009	-- fix "do not fill" language and left join to StaffSignatureFacsimiles
	avoss - 11-13-2009	--Ohio pharmacy board changes
*/
AS 
    DECLARE @ClientMedicationScriptIds INT

    SELECT  @ClientMedicationScriptIds = ClientMedicationScriptId
    FROM    ClientMedicationScriptActivities
    WHERE   ClientMedicationScriptActivityId = @ClientMedicationScriptActivityId

    PRINT @ClientMedicationScriptIds

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

    IF @PrintChartCopy IN ( 'True', 'False' ) 
        BEGIN
            SET @PrintChartCopy = 'Y'
        END

--check for c2 meds for signature options
    DECLARE @C2Meds VARCHAR(1) --Y,N
    SET @C2Meds = 'N'


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

    CREATE TABLE #ClientScriptInstructions
        (
          ClientMedicationScriptId INT ,
          OrderingMethod VARCHAR(5) ,
          CopyType VARCHAR(20) ,
          ScriptOrderedDate DATETIME ,
          PON VARCHAR(50) ,
          ClientMedicationInstructionId INT ,
          MedicationName VARCHAR(MAX) ,
          StrengthId INT ,
          InstructionStrengthDescription VARCHAR(MAX) ,
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
          TotalQuantity VARCHAR(MAX) --decimal(10,2)
          ,
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
          PharmacyText VARCHAR(MAX)
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
          InstructionSummary VARCHAR(MAX) ,
          PatientScheduleSummary VARCHAR(MAX) ,
          OrderDate DATETIME ,
          DrugStartDate DATETIME ,
          DrugEndDate DATETIME ,
          Refills DECIMAL(10, 2) ,
          DurationDays INT ,
          DAW VARCHAR(MAX) ,
          SpecialInstructions VARCHAR(MAX) ,
          OrderStatus VARCHAR(30) ,
          Titration CHAR(1) ,
          Multiples CHAR(1) ,
          SingleLine CHAR(1) ,
          PharmacyText VARCHAR(MAX)
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
          SingleLine CHAR(1)
        )

    CREATE TABLE #ScriptHeader
        (
          OrganizationName VARCHAR(500) ,
          ClientMedicationScriptId INT ,
          ClientMedicationScriptActivityId INT ,
          OrderingMethod CHAR(1) ,
          AllergyList VARCHAR(1000) ,
          ClientId INT ,
          ClientName VARCHAR(300) ,
          ClientAddress VARCHAR(500) ,
          ClientHomePhone VARCHAR(20) ,
          ClientDOB DATETIME ,
          LocationAddress VARCHAR(500) ,
          LocationName VARCHAR(200) ,
          LocationPhone VARCHAR(20) ,
          LocationFax VARCHAR(20) ,
          PharmacyName VARCHAR(700) ,
          PharmacyAddress VARCHAR(500) ,
          PharmacyPhone VARCHAR(20) ,
          PharmacyFax VARCHAR(20)
        )

    CREATE TABLE #ScriptSignatures
        (
          ClientMedicationScriptId INT ,
          OrderingMethod CHAR(1) ,
          PrescriberId INT ,
          Prescriber VARCHAR(500) ,
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
-- Multiples cursor - variables
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
--Titration Tables
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
-- Get Client Alergy List
            INSERT  INTO @AllergyListTable
                    ( ConceptDescription
                    )
    --Modified by Loveena in ref to Task#2571-1.9.5.6: Change text for "No Known Allergies" dated 02Sept2009
    --select isnull(ConceptDescription, 'No Known Allergies')
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
    --Modified by Loveena in ref to Task#2571-1.9.5.6: Change text for "No Known Allergies" dated 02Sept2009
    --order by isnull(ConceptDescription, 'No Known Allergies')
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
                    SELECT  ( SELECT    OrganizationName
                              FROM      SystemConfigurations
                            ) AS OrganizationName ,
                            cms.ClientMedicationScriptId ,
                            @ClientMedicationScriptActivityId ,
                            @OrderingMethod AS OrderingMethod ,
                            @AllergyList AS AllergyList ,
                            c.ClientId ,
                            --Added by Revathi 21.Oct.2015
                           (case when ISNULL(C.ClientType,'I')='I' then  ISNULL(c.LastName,'') + ', ' + ISNULL(c.FirstName,'') else ISNULL(c.OrganizationName,'') end) AS ClientName ,
                            ISNULL(ca.Display, '') AS ClientAddress ,
                            ISNULL(cph.PhoneNumber, '             ') AS ClientHomePhone ,
                            c.DOB AS ClientDOB ,
                            ISNULL(l.Address, '') + CHAR(13) + CHAR(10)
                            + ISNULL(l.City, '') + ', ' + ISNULL(l.State, '')
                            + ' ' + ISNULL(l.ZipCode, '') AS LocationAddress ,
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
                            ISNULL(p.AddressDisplay, '') AS PharmacyAddress ,
                            CASE WHEN ISNULL(p.PhoneNumber, '             ') = ''
                                 THEN '             '
                                 ELSE ISNULL(p.PhoneNumber, '             ')
                                      + ' '
                            END AS PharmacyPhone ,
                            CASE WHEN ISNULL(p.FaxNumber, '             ') = ''
                                 THEN '             '
                                 ELSE ISNULL(p.FaxNumber, '             ')
                                      + ' '
                            END AS PharmacyFax
                    FROM    ClientMedicationScripts AS cms
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
                            + CASE WHEN st.Degree IN ( SELECT Degree
                                                       FROM   @DrDegree )
                                   THEN '     DEA #: ' + ISNULL(st.DEANumber,
                                                              '')
                                   ELSE CASE WHEN EXISTS ( SELECT
                                                              *
                                                           FROM
                                                              ClientMedicationScriptDrugs
                                                              AS cmsd2
                                                              JOIN ClientMedicationInstructions
                                                              AS cmi2 ON cmi2.ClientmedicationInstructionId = cmsd2.ClientmedicationInstructionId
                                                              JOIN MDMedications
                                                              AS mdm2 ON mdm2.MedicationId = cmi2.StrengthId
                                                              JOIN MDDrugs AS mdd2 ON mdd2.ClinicalFormulationId = mdm2.ClinicalFormulationId
                                                           WHERE
                                                              cmsd2.ClientMedicationScriptId = cms.ClientMedicationScriptId
                                                              AND mdd2.DEACode = 2
                                                              AND ISNULL(cmsd2.RecordDeleted,
                                                              'N') <> 'Y'
                                                              AND ISNULL(cmi2.RecordDeleted,
                                                              'N') <> 'Y'
                                                              AND ISNULL(mdm2.RecordDeleted,
                                                              'N') <> 'Y' AND ISNULL(cmi.Active,'Y')='Y'
                                                              AND ISNULL(mdd2.RecordDeleted,
                                                              'N') <> 'Y' )
                                             THEN '     DEA #: '
                                                  + ISNULL(st.DEANumber, '')
                                                  + ', ' + 'CTP #: '
                                                  + ISNULL(st.LicenseNumber,
                                                           '')
                                             ELSE '     CTP #: '
                                                  + ISNULL(st.LicenseNumber,
                                                           '')
                                        END
                              END AS Prescriber ,
                            CASE WHEN ( @OrderingMethod = 'F' )
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
                                                              'N') <> 'Y' AND ISNULL(cmi.Active,'Y')='Y'
                            JOIN ClientMedications AS cm ON cm.ClientMedicationId = cmi.ClientMedicationId
                                                            AND ISNULL(cm.RecordDeleted,
                                                              'N') <> 'Y'
                            JOIN Staff AS v ON v.UserCode = cms.CreatedBy
                                               AND ISNULL(v.RecordDeleted, 'N') <> 'Y'
                            LEFT JOIN globalCodes AS vDeg ON vDeg.GlobalCodeId = v.Degree
                            JOIN Staff AS st ON st.StaffId = cm.PrescriberId
                                                AND ISNULL(st.RecordDeleted,
                                                           'N') <> 'Y'
                            LEFT JOIN globalCodes AS stDeg ON stDeg.GlobalCodeId = st.Degree
                            LEFT JOIN StaffSignatureFacsimiles AS sf ON sf.StaffId = cm.PrescriberId
                                                              AND ISNULL(sf.RecordDeleted,
                                                              'N') <> 'Y'
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
                            + CAST(CASE WHEN ISNULL(cmi.TitrationStepNumber, 0) = 0
                                        THEN cmi.StrengthId
                                        ELSE ( SELECT   MIN(cmi2.StrengthId)
                                               FROM     ClientMedicationScriptDrugs
                                                        AS cmsd2
                                                        JOIN ClientMedicationInstructions cmi2 ON cmi2.ClientMedicationInstructionId = cmsd2.ClientMedicationInstructionId
                                               WHERE    cmsd2.ClientMedicationScriptId = cmsd.ClientMedicationScriptId
                                                        AND ISNULL(cmsd2.RecordDeleted,
                                                              'N') <> 'Y'
                                                        AND ISNULL(cmi2.RecordDeleted,
                                                              'N') <> 'Y' AND ISNULL(cmi2.Active,'Y')='Y'
                                             )
                                   END AS VARCHAR) AS PON ,
                            cmi.ClientMedicationInstructionId ,
                            MedName.MedicationName + ', '
                            + MDMeds.StrengthDescription ,
                            cmi.StrengthId ,
                            MDMeds.StrengthDescription AS InstructionStrengthDescription ,
                            NULL AS InstructionSummary ,
                            NULL AS PatientScheduleSummary ,
	--null as StrengthInstructionSummary,
	--case when cmsd.Sample + cmsd.Stock = 0 then 'N' else 'Y' end as DisbursedToClient,
	--case when cmsd.Sample + cmsd.Stock = 0 then null
	--	else space(2) + '(' + replace(cast((cmsd.Sample + cmsd.Stock) as varchar(10)),'.00','' )  + '  disbursed to client from samples)' end as SamplesToClient,
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
	-- case when gc1.codeName  in ('units', 'each') then '#' else 'x ' end as UnitValueString,
                            gc2.codeName AS ScheduleValue ,
                            ISNULL(cmi.TitrationStepNumber, 0) AS TitrationStepNumber ,
                            cm.MedicationStartDate ,
                            cm.MedicationEndDate ,
                            cms.OrderDate ,
                            dbo.ssf_RemoveTrailingZeros(CMI.Quantity) AS Quantity ,
                            gc2.ExternalCode1 AS SchedValueMultiplier ,
                            CASE WHEN cms.CreatedDate < @StartDate
                                 THEN REPLACE(cmi.Quantity, '.00', '')
                                      * cmsd.Days * gc2.ExternalCode1
  --else replace(cmsd.pharmacy,'.00','') end as TotalQuantity,
                                 ELSE CONVERT(INT, cmsd.pharmacy)
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
                                 THEN 'REMINDER: Prescribers must write "DAW" by hand on printed scripts.'
                                 ELSE ''
                            END AS DAW ,
                            cm.SpecialInstructions ,
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
                            cmsd.PharmacyText
                    FROM    ClientMedicationScripts AS cms
                            JOIN ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationScriptId = CMS.ClientMedicationScriptId
                                                              AND ISNULL(cmsd.RecordDeleted,
                                                              'N') <> 'Y'
                            JOIN ClientMedicationInstructions AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId
                                                              AND ISNULL(cmi.RecordDeleted,
                                                              'N') <> 'Y' AND ISNULL(cmi.Active,'Y')='Y'
                            JOIN ClientMedications AS cm ON cm.ClientMedicationId = cmi.ClientMedicationId
                                                            AND ISNULL(cm.RecordDeleted,
                                                              'N') <> 'Y'
                            JOIN MDMedicationNames AS MedName ON MedName.MedicationNameId = cm.MedicationNameId
                                                              AND ISNULL(MedName.RecordDeleted,
                                                              'N') <> 'Y'
                            JOIN MDMedications AS MDMeds ON MDMeds.MedicationId = cmi.StrengthId
                            JOIN GlobalCodes AS gc1 ON gc1.GlobalCodeId = cmi.Unit
                            JOIN GlobalCodes AS gc2 ON gc2.GlobalCodeId = cmi.Schedule
                    WHERE   ISNULL(cms.RecordDeleted, 'N') <> 'Y'
                            AND @ClientMedicationScriptIds = cms.ClientMedicationScriptId

		--Determine if C2Meds are on the script
            IF EXISTS ( SELECT  *
                        FROM    #ClientScriptInstructions csi
                                JOIN ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationScriptId = csi.ClientMedicationScriptId
                                JOIN ClientMedicationInstructions AS cmi ON cmi.ClientmedicationInstructionId = cmsd.ClientmedicationInstructionId
                                JOIN MDMedications AS mdm ON mdm.MedicationId = cmi.StrengthId
                                JOIN MDDrugs AS mdd ON mdd.ClinicalFormulationId = mdm.ClinicalFormulationId
                        WHERE   mdd.DEACode = 2
		--and cmsd.ClientMedicationScriptDrugId = @clientmedicationscriptdrugid
                                AND ISNULL(cmsd.RecordDeleted, 'N') <> 'Y'
                                AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'
								AND ISNULL(cmi.Active,'Y')='Y'
                                AND ISNULL(mdm.RecordDeleted, 'N') <> 'Y'
                                AND ISNULL(mdd.RecordDeleted, 'N') <> 'Y' ) 
                BEGIN
                    SET @C2Meds = 'Y'
	
                    INSERT  INTO @C2MedsList
                            ( PON
                            )
                            SELECT DISTINCT
                                    csi.PON
                            FROM    #ClientScriptInstructions csi
                                    JOIN ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationScriptId = csi.ClientMedicationScriptId
                                    JOIN ClientMedicationInstructions AS cmi ON cmi.ClientmedicationInstructionId = cmsd.ClientmedicationInstructionId
                                    JOIN MDMedications AS mdm ON mdm.MedicationId = cmi.StrengthId
                                    JOIN MDDrugs AS mdd ON mdd.ClinicalFormulationId = mdm.ClinicalFormulationId
                            WHERE   mdd.DEACode = 2
	--and cmsd.ClientMedicationScriptDrugId = @clientmedicationscriptdrugid
                                    AND ISNULL(cmsd.RecordDeleted, 'N') <> 'Y'
                                    AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'
									AND ISNULL(cmi.Active,'Y')='Y'
                                    AND ISNULL(mdm.RecordDeleted, 'N') <> 'Y'
                                    AND ISNULL(mdd.RecordDeleted, 'N') <> 'Y'

                END


	--Determine if Controlled Meds are on the script
            IF EXISTS ( SELECT  *
                        FROM    #ClientScriptInstructions csi
                                JOIN ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationScriptId = csi.ClientMedicationScriptId
                                JOIN ClientMedicationInstructions AS cmi ON cmi.ClientmedicationInstructionId = cmsd.ClientmedicationInstructionId
                                JOIN MDMedications AS mdm ON mdm.MedicationId = cmi.StrengthId
                                JOIN MDDrugs AS mdd ON mdd.ClinicalFormulationId = mdm.ClinicalFormulationId
                        WHERE   mdd.DEACode > 0
		--and cmsd.ClientMedicationScriptDrugId = @clientmedicationscriptdrugid
                                AND ISNULL(cmsd.RecordDeleted, 'N') <> 'Y'
                                AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'
								AND ISNULL(cmi.Active,'Y')='Y'
                                AND ISNULL(mdm.RecordDeleted, 'N') <> 'Y'
                                AND ISNULL(mdd.RecordDeleted, 'N') <> 'Y' ) 
                BEGIN
	
                    INSERT  INTO @ControlledMedsList
                            ( PON
                            )
                            SELECT DISTINCT
                                    csi.PON
                            FROM    #ClientScriptInstructions csi
                                    JOIN ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationScriptId = csi.ClientMedicationScriptId
                                    JOIN ClientMedicationInstructions AS cmi ON cmi.ClientmedicationInstructionId = cmsd.ClientmedicationInstructionId
                                    JOIN MDMedications AS mdm ON mdm.MedicationId = cmi.StrengthId
                                    JOIN MDDrugs AS mdd ON mdd.ClinicalFormulationId = mdm.ClinicalFormulationId
                            WHERE   mdd.DEACode > 0
	--and cmsd.ClientMedicationScriptDrugId = @clientmedicationscriptdrugid
                                    AND ISNULL(cmsd.RecordDeleted, 'N') <> 'Y'
                                    AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'
									AND ISNULL(cmi.Active,'Y')='Y'
                                    AND ISNULL(mdm.RecordDeleted, 'N') <> 'Y'
                                    AND ISNULL(mdd.RecordDeleted, 'N') <> 'Y'

                END

	--End


	
        END --End Original Data Select

--Begin Preview Data Select
    IF ( ISNULL(@OriginalData, 0) = 0 ) 
        BEGIN
-- Get Client Alergy List
            INSERT  INTO @AllergyListTable
                    ( ConceptDescription
                    )
    --Modified by Loveena in ref to Task#2571-1.9.5.6: Change text for "No Known Allergies" dated 02Sept2009
    --select isnull(ConceptDescription, 'No Known Allergies')
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
    --Modified by Loveena in ref to Task#2571-1.9.5.6: Change text for "No Known Allergies" dated 02Sept2009
--    order by isnull(ConceptDescription, 'No Known Allergies')
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
                    SELECT  ( SELECT    OrganizationName
                              FROM      SystemConfigurations
                            ) AS OrganizationName ,
                            cms.ClientMedicationScriptId ,
                            @OrderingMethod AS OrderingMethod ,
                            @AllergyList AS AllergyList ,
                            c.ClientId ,
                            --Added by Revathi 21.Oct.2015
                           (case when ISNULL(C.ClientType,'I')='I' then  ISNULL(c.LastName,'') + ', ' + ISNULL(c.FirstName,'') else ISNULL(c.OrganizationName,'') end) AS ClientName ,
                            ISNULL(ca.Display, '') AS ClientAddress ,
                            ISNULL(cph.PhoneNumber, '             ') AS ClientHomePhone ,
                            c.DOB AS ClientDOB ,
                            ISNULL(l.Address, '') + CHAR(13) + CHAR(10)
                            + ISNULL(l.City, '') + ', ' + ISNULL(l.State, '')
                            + ' ' + ISNULL(l.ZipCode, '') AS LocationAddress ,
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
                            ISNULL(p.AddressDisplay, '') AS PharmacyAddress ,
                            CASE WHEN ISNULL(p.PhoneNumber, '             ') = ''
                                 THEN '             '
                                 ELSE ISNULL(p.PhoneNumber, '             ')
                                      + ' '
                            END AS PharmacyPhone ,
                            CASE WHEN ISNULL(p.FaxNumber, '             ') = ''
                                 THEN '             '
                                 ELSE ISNULL(p.FaxNumber, '             ')
                                      + ' '
                            END AS PharmacyFax
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
                            + CASE WHEN st.Degree IN ( SELECT Degree
                                                       FROM   @DrDegree )
                                   THEN '     DEA #: ' + ISNULL(st.DEANumber,
                                                              '')
                                   ELSE CASE WHEN EXISTS ( SELECT
                                                              *
                                                           FROM
                                                              ClientMedicationScriptDrugsPreview
                                                              AS cmsd2
                                                              JOIN ClientMedicationInstructionsPreview
                                                              AS cmi2 ON cmi2.ClientmedicationInstructionId = cmsd2.ClientmedicationInstructionId
                                                              JOIN MDMedications
                                                              AS mdm2 ON mdm2.MedicationId = cmi2.StrengthId
                                                              JOIN MDDrugs AS mdd2 ON mdd2.ClinicalFormulationId = mdm2.ClinicalFormulationId
                                                           WHERE
                                                              cmsd2.ClientMedicationScriptId = cms.ClientMedicationScriptId
                                                              AND mdd2.DEACode = 2
                                                              AND ISNULL(cmsd2.RecordDeleted,
                                                              'N') <> 'Y'
                                                              AND ISNULL(cmi2.RecordDeleted,
                                                              'N') <> 'Y' AND ISNULL(cmi2.Active,'Y')='Y'
                                                              AND ISNULL(mdm2.RecordDeleted,
                                                              'N') <> 'Y'
                                                              AND ISNULL(mdd2.RecordDeleted,
                                                              'N') <> 'Y' )
                                             THEN '     DEA #: '
                                                  + ISNULL(st.DEANumber, '')
                                                  + ', ' + 'CTP #: '
                                                  + ISNULL(st.LicenseNumber,
                                                           '')
                                             ELSE '     CTP #: '
                                                  + ISNULL(st.LicenseNumber,
                                                           '')
                                        END
                              END AS Prescriber ,
                            CASE WHEN ( @OrderingMethod = 'F' )
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
                                                              'N') <> 'Y' AND ISNULL(cmi.Active,'Y')='Y'
                            JOIN ClientMedicationsPreview AS cm ON cm.ClientMedicationId = cmi.ClientMedicationId
                                                              AND ISNULL(cm.RecordDeleted,
                                                              'N') <> 'Y'
                            JOIN Staff AS v ON v.UserCode = cms.CreatedBy
                                               AND ISNULL(v.RecordDeleted, 'N') <> 'Y'
                            LEFT JOIN globalCodes AS vDeg ON vDeg.GlobalCodeId = v.Degree
                            JOIN Staff AS st ON st.StaffId = cm.PrescriberId
                                                AND ISNULL(st.RecordDeleted,
                                                           'N') <> 'Y'
                            LEFT JOIN globalCodes AS stDeg ON stDeg.GlobalCodeId = st.Degree
                            LEFT JOIN StaffSignatureFacsimiles AS sf ON sf.StaffId = cm.PrescriberId
                                                              AND ISNULL(sf.RecordDeleted,
                                                              'N') <> 'Y'
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
                            + CAST(CASE WHEN ISNULL(cmi.TitrationStepNumber, 0) = 0
                                        THEN cmi.StrengthId
                                        ELSE ( SELECT   MIN(cmi2.StrengthId)
                                               FROM     ClientMedicationScriptDrugsPreview
                                                        AS cmsd2
                                                        JOIN ClientMedicationInstructionsPreview cmi2 ON cmi2.ClientMedicationInstructionId = cmsd2.ClientMedicationInstructionId
                                               WHERE    cmsd2.ClientMedicationScriptId = cmsd.ClientMedicationScriptId
                                                        AND ISNULL(cmsd2.RecordDeleted,
                                                              'N') <> 'Y'
                                                        AND ISNULL(cmi2.RecordDeleted,
                                                              'N') <> 'Y' AND ISNULL(cmi2.Active,'Y')='Y'
                                             )
                                   END AS VARCHAR) AS PON ,
                            cmi.ClientMedicationInstructionId ,
                            MedName.MedicationName + ', '
                            + MDMeds.StrengthDescription ,
                            cmi.StrengthId ,
                            MDMeds.StrengthDescription AS InstructionStrengthDescription ,
                            NULL AS InstructionSummary ,
                            NULL AS PatientScheduleSummary ,
	--null as StrengthInstructionSummary,
	--case when cmsd.Sample + cmsd.Stock = 0 then 'N' else 'Y' end as DisbursedToClient,
	--case when cmsd.Sample + cmsd.Stock = 0 then null
	--	else space(2) + '(' + replace(cast((cmsd.Sample + cmsd.Stock) as varchar(10)),'.00','' )  + '  disbursed to client from samples)' end as SamplesToClient,
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
                            ISNULL(cmi.TitrationStepNumber, 0) AS TitrationStepNumber ,
                            cm.MedicationStartDate ,
                            cm.MedicationEndDate ,
                            cms.OrderDate ,
                            dbo.ssf_RemoveTrailingZeros(CMI.Quantity) AS Quantity ,
                            gc2.ExternalCode1 AS SchedValueMultiplier ,
                            CASE WHEN cms.CreatedDate < @StartDate
                                 THEN REPLACE(cmi.Quantity, '.00', '')
                                      * cmsd.Days * gc2.ExternalCode1
		--else replace(cmsd.pharmacy,'.00','') end as TotalQuantity,
                                 ELSE CONVERT(INT, cmsd.pharmacy)
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
                                 THEN 'REMINDER: Prescribers must write "DAW" by hand on printed scripts.'
                                 ELSE ''
                            END AS DAW ,
                            cm.SpecialInstructions ,
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
	--three fields below are missing in 1.9.8.7 preview tables
                            cm.OffLabel ,
                            cm.Comments ,
                            cm.IncludeCommentOnPrescription ,
                            cmsd.PharmacyText
                    FROM    ClientMedicationScriptsPreview AS cms
                            JOIN ClientMedicationScriptDrugsPreview AS cmsd ON cmsd.ClientMedicationScriptId = CMS.ClientMedicationScriptId
                                                              AND ISNULL(cmsd.RecordDeleted,
                                                              'N') <> 'Y'
                            JOIN ClientMedicationInstructionsPreview AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId
                                                              AND ISNULL(cmi.RecordDeleted,
                                                              'N') <> 'Y' AND ISNULL(cmi.Active,'Y')='Y'
                            JOIN ClientMedicationsPreview AS cm ON cm.ClientMedicationId = cmi.ClientMedicationId
                                                              AND ISNULL(cm.RecordDeleted,
                                                              'N') <> 'Y'
                            JOIN MDMedicationNames AS MedName ON MedName.MedicationNameId = cm.MedicationNameId
                                                              AND ISNULL(MedName.RecordDeleted,
                                                              'N') <> 'Y'
                            JOIN MDMedications AS MDMeds ON MDMeds.MedicationId = cmi.StrengthId
                            JOIN GlobalCodes AS gc1 ON gc1.GlobalCodeId = cmi.Unit
                            JOIN GlobalCodes AS gc2 ON gc2.GlobalCodeId = cmi.Schedule
                    WHERE   ISNULL(cms.RecordDeleted, 'N') <> 'Y'
                            AND @ClientMedicationScriptIds = cms.ClientMedicationScriptId

	
	--Determine if C2Meds are on the script
            IF EXISTS ( SELECT  *
                        FROM    #ClientScriptInstructions csi
                                JOIN ClientMedicationScriptDrugsPreview AS cmsd ON cmsd.ClientMedicationScriptId = csi.ClientMedicationScriptId
                                JOIN ClientMedicationInstructionsPreview AS cmi ON cmi.ClientmedicationInstructionId = cmsd.ClientmedicationInstructionId
                                JOIN MDMedications AS mdm ON mdm.MedicationId = cmi.StrengthId
                                JOIN MDDrugs AS mdd ON mdd.ClinicalFormulationId = mdm.ClinicalFormulationId
                        WHERE   mdd.DEACode = 2
		--and cmsd.ClientMedicationScriptDrugId = @clientmedicationscriptdrugid
                                AND ISNULL(cmsd.RecordDeleted, 'N') <> 'Y'
                                AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'
								AND ISNULL(cmi.Active,'Y')='Y'
                                AND ISNULL(mdm.RecordDeleted, 'N') <> 'Y'
                                AND ISNULL(mdd.RecordDeleted, 'N') <> 'Y' ) 
                BEGIN
                    SET @C2Meds = 'Y'

                    INSERT  INTO @C2MedsList
                            SELECT DISTINCT
                                    csi.PON
                            FROM    #ClientScriptInstructions csi
                                    JOIN ClientMedicationScriptDrugsPreview AS cmsd ON cmsd.ClientMedicationScriptId = csi.ClientMedicationScriptId
                                    JOIN ClientMedicationInstructionsPreview
                                    AS cmi ON cmi.ClientmedicationInstructionId = cmsd.ClientmedicationInstructionId
                                    JOIN MDMedications AS mdm ON mdm.MedicationId = cmi.StrengthId
                                    JOIN MDDrugs AS mdd ON mdd.ClinicalFormulationId = mdm.ClinicalFormulationId
                            WHERE   mdd.DEACode = 2
	--and cmsd.ClientMedicationScriptDrugId = @clientmedicationscriptdrugid
                                    AND ISNULL(cmsd.RecordDeleted, 'N') <> 'Y'
                                    AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'
									AND ISNULL(cmi.Active,'Y')='Y'
                                    AND ISNULL(mdm.RecordDeleted, 'N') <> 'Y'
                                    AND ISNULL(mdd.RecordDeleted, 'N') <> 'Y'

                END

	--Determine if Controlled Meds are on the script
            IF EXISTS ( SELECT  *
                        FROM    #ClientScriptInstructions csi
                                JOIN ClientMedicationScriptDrugsPreview AS cmsd ON cmsd.ClientMedicationScriptId = csi.ClientMedicationScriptId
                                JOIN ClientMedicationInstructionsPreview AS cmi ON cmi.ClientmedicationInstructionId = cmsd.ClientmedicationInstructionId
                                JOIN MDMedications AS mdm ON mdm.MedicationId = cmi.StrengthId
                                JOIN MDDrugs AS mdd ON mdd.ClinicalFormulationId = mdm.ClinicalFormulationId
                        WHERE   mdd.DEACode > 0
		--and cmsd.ClientMedicationScriptDrugId = @clientmedicationscriptdrugid
                                AND ISNULL(cmsd.RecordDeleted, 'N') <> 'Y'
                                AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'
								AND ISNULL(cmi.Active,'Y')='Y'
                                AND ISNULL(mdm.RecordDeleted, 'N') <> 'Y'
                                AND ISNULL(mdd.RecordDeleted, 'N') <> 'Y' ) 
                BEGIN
	
                    INSERT  INTO @ControlledMedsList
                            ( PON
                            )
                            SELECT DISTINCT
                                    csi.PON
                            FROM    #ClientScriptInstructions csi
                                    JOIN ClientMedicationScriptDrugsPreview AS cmsd ON cmsd.ClientMedicationScriptId = csi.ClientMedicationScriptId
                                    JOIN ClientMedicationInstructionsPreview
                                    AS cmi ON cmi.ClientmedicationInstructionId = cmsd.ClientmedicationInstructionId
                                    JOIN MDMedications AS mdm ON mdm.MedicationId = cmi.StrengthId
                                    JOIN MDDrugs AS mdd ON mdd.ClinicalFormulationId = mdm.ClinicalFormulationId
                            WHERE   mdd.DEACode > 0
	--and cmsd.ClientMedicationScriptDrugId = @clientmedicationscriptdrugid
                                    AND ISNULL(cmsd.RecordDeleted, 'N') <> 'Y'
                                    AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'
									AND ISNULL(cmi.Active,'Y')='Y'
                                    AND ISNULL(mdm.RecordDeleted, 'N') <> 'Y'
                                    AND ISNULL(mdd.RecordDeleted, 'N') <> 'Y'

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
                    NULL AS SingleLine
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
--	where exists ( select * from #QuantitySummary qs2 where qs2.PON = qs.PON and qs2.StrengthId = qs.StrengthId
--		and qs2.DrugStartDate = qs.DrugStartDate and qs2.DrugEndDate = qs.DrugEndDate and qs2.Refills = qs.Refills
--		and qs2.ClientMedicationInstructionId <> qs.ClientMedicationInstructionId and qs2.Titration <> 'Y' )

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
                            SUM(qs.DisbursedAmount) AS DisbursedTotal ,
                            SUM(qs.TotalQuantity) - SUM(qs.DisbursedAmount) AS PharmacyTotal ,
                            SUM(qs.TotalQuantity) AS GroupTotal
                   FROM     #QuantitySummary qs
                            JOIN @StrengthGroupInstructionIds sg ON sg.StrengthId = qs.StrengthId
                                                              AND sg.ClientMedicationInstructionId = qs.ClientMedicationInstructionId
                   GROUP BY qs.StrengthId
                 ) b ON b.StrengthId = a.StrengthId
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
                Titration ,
                Multiples ,
                SingleLine
        FROM    #QuantitySummary
        GROUP BY PON ,
                StrengthId ,
                Titration ,
                Multiples ,
                SingleLine

    OPEN InsStrengthGroup
    SET @IdxCur1 = 1
    FETCH NEXT FROM InsStrengthGroup INTO @PONCur1, @StrengthIdCur1,
        @TitrationCur1, @MultiplesCur1, @SingleLineCur1
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
            SET @IdxCur1 = @IdxCur1 + 1
			
            FETCH NEXT FROM InsStrengthGroup INTO @PONCur1, @StrengthIdCur1,
                @TitrationCur1, @MultiplesCur1, @SingleLineCur1
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
        SET     InstructionSummary = csi.InstructionStrengthDescription
                + SPACE(1) + CONVERT(VARCHAR(16), REPLACE(csi.Quantity, '.00',
                                                          '')) + SPACE(1)
                + CONVERT(VARCHAR(250), csi.UnitScheduleString) + ' ' + ' ('
                + csi.UnitValueString + ') '
                + CASE ISNULL(csi.PharmacyText, '')
                    WHEN ''
                    THEN CONVERT(VARCHAR(16), REPLACE(qs.PharmacyTotal, '.00',
                                                      ''))
                    ELSE ''
                  END + CASE WHEN ISNULL(csi.DisbursedAmount, 0) = 0 THEN ''
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
	 /*select @MultPatientInstructionSummaryString = case isnull(csi.PharmacyText,'') when '' then
	isnull(@MultPatientInstructionSummaryString,'')
    + csi.InstructionStrengthDescription
    + ' (' + convert(varchar(6),replace(csi.Quantity,'.00','')) + ') '
    + csi.UnitScheduleString +char(13)+char(10)
	else csi.PharmacyText +char(13)+char(10) end
    from #ClientScriptInstructions csi
    join #QuantitySummary qs on qs.PON = csi.PON
    and qs.ClientMedicationInstructionId = csi.ClientMedicationInstructionId
     and qs.Titration = 'N' and qs.Multiples = 'Y' and qs.SingleLine = 'N'
     and qs.InsrtuctionMultipleStrengthGroupId = @MultInsrtuctionMultipleStrengthGroupId
    where csi.PON = @MultPON and qs.InsrtuctionMultipleStrengthGroupId = @MultInsrtuctionMultipleStrengthGroupId
    and csi.ClientMedicationInstructionId = @MultClientMedicationInstructionId
    */
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
                    WHERE   t.PON = @PON
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
                    csi.InstructionStrengthDescription + ' '
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
                                                            '.00', '')) + ')'
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
                    csi.InstructionStrengthDescription ,
                    csi.UnitValueString ,
                    qs.PharmacyTotal ,
                    qs.DisbursedFlag ,
                    qs.DisbursedTotal ,
                    c2.PON

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
                        csi.InstructionSummary ,
                        csi.PatientScheduleSummary
--	,csi.StrengthInstructionSummary
--	,csi.DisbursedToClient
--	,csi.SamplesToClient
                        ,
                        csi.OrderDate ,
                        csi.DrugStartDate ,
                        csi.DrugEndDate ,
                        REPLACE(qs.Refills, '.00', '') ,
                        qs.DurationDays
--	,replace(qs.PharmacyTotal,'.00','')
--	,replace(qs.Sample,'.00','')
--	,replace(qs.Stock,'.00','')
                        ,
                        csi.DAW
	--change special instructions to include comments if specified
                        ,
                        CASE WHEN ISNULL(csi.SpecialInstructions, '') <> ''
                             THEN ISNULL(csi.SpecialInstructions, '')
                                  + CASE WHEN ISNULL(csi.Comments, '') <> ''
                                              AND ISNULL(csi.IncludeCommentOnPrescription,
                                                         'N') <> 'N'
                                         THEN ', ' + ISNULL(csi.Comments, '')
                                         ELSE ''
                                    END
                             WHEN ISNULL(csi.SpecialInstructions, '') = ''
                             THEN CASE WHEN ISNULL(csi.Comments, '') <> ''
                                            AND ISNULL(csi.IncludeCommentOnPrescription,
                                                       'N') <> 'N'
                                       THEN ISNULL(csi.Comments, '')
                                       ELSE ''
                                  END
                             ELSE ''
                        END --csi.SpecialInstructions
                        ,
                        csi.OrderStatus ,
                        qs.Titration ,
                        qs.Multiples ,
                        qs.SingleLine ,
                        csi.PharmacyText
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
                        csi.InstructionSummary ,
                        csi.PatientScheduleSummary
--	,csi.StrengthInstructionSummary
--	,csi.DisbursedToClient
--	,csi.SamplesToClient
                        ,
                        csi.OrderDate ,
                        csi.DrugStartDate ,
                        csi.DrugEndDate ,
                        REPLACE(qs.Refills, '.00', '') ,
                        qs.DurationDays
--	,replace(qs.PharmacyTotal,'.00','')
--	,replace(qs.Sample,'.00','')
--	,replace(qs.Stock,'.00','')
                        ,
                        csi.DAW
	--change special instructions to include comments if specified
                        ,
                        CASE WHEN ISNULL(csi.SpecialInstructions, '') <> ''
                             THEN ISNULL(csi.SpecialInstructions, '')
                                  + CASE WHEN ISNULL(csi.Comments, '') <> ''
                                              AND ISNULL(csi.IncludeCommentOnPrescription,
                                                         'N') <> 'N'
                                         THEN ', ' + ISNULL(csi.Comments, '')
                                         ELSE ''
                                    END
                             WHEN ISNULL(csi.SpecialInstructions, '') = ''
                             THEN CASE WHEN ISNULL(csi.Comments, '') <> ''
                                            AND ISNULL(csi.IncludeCommentOnPrescription,
                                                       'N') <> 'N'
                                       THEN ISNULL(csi.Comments, '')
                                       ELSE ''
                                  END
                             ELSE ''
                        END --csi.SpecialInstructions
                        ,
                        csi.OrderStatus ,
                        qs.Titration ,
                        qs.Multiples ,
                        qs.SingleLine ,
                        csi.PharmacyText
                FROM    #ClientScriptInstructions csi
                        JOIN #QuantitySummary qs ON qs.PON = csi.PON
                                                    AND csi.ClientmedicationInstructionId = qs.ClientmedicationInstructionId
                                                    AND qs.SingleLine = 'Y'
                WHERE   @OrderingMethod <> ( 'F' )
                        AND qs.SingleLine = 'Y'
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
                        csi.InstructionSummary ,
                        csi.PatientScheduleSummary
--	,csi.StrengthInstructionSummary
--	,csi.DisbursedToClient
--	,csi.SamplesToClient
                        ,
                        csi.OrderDate ,
                        csi.DrugStartDate ,
                        csi.DrugEndDate ,
                        REPLACE(qs.Refills, '.00', '') ,
                        qs.DurationDays
--	,replace(qs.PharmacyTotal,'.00','')
--	,replace(qs.Sample,'.00','')
--	,replace(qs.Stock,'.00','')
                        ,
                        csi.DAW
	--change special instructions to include comments if specified
                        ,
                        CASE WHEN ISNULL(csi.SpecialInstructions, '') <> ''
                             THEN ISNULL(csi.SpecialInstructions, '')
                                  + CASE WHEN ISNULL(csi.Comments, '') <> ''
                                              AND ISNULL(csi.IncludeCommentOnPrescription,
                                                         'N') <> 'N'
                                         THEN ', ' + ISNULL(csi.Comments, '')
                                         ELSE ''
                                    END
                             WHEN ISNULL(csi.SpecialInstructions, '') = ''
                             THEN CASE WHEN ISNULL(csi.Comments, '') <> ''
                                            AND ISNULL(csi.IncludeCommentOnPrescription,
                                                       'N') <> 'N'
                                       THEN ISNULL(csi.Comments, '')
                                       ELSE ''
                                  END
                             ELSE ''
                        END --csi.SpecialInstructions
                        ,
                        csi.OrderStatus ,
                        qs.Titration ,
                        qs.Multiples ,
                        qs.SingleLine ,
                        csi.PharmacyText
                FROM    #ClientScriptInstructions csi
                        JOIN #QuantitySummary qs ON qs.PON = csi.PON
                                                    AND csi.ClientmedicationInstructionId = qs.ClientmedicationInstructionId
                                                    AND qs.Multiples = 'Y'
                WHERE   @OrderingMethod NOT IN ( 'X', 'C' )
--and @PrintChartCopy = 'N'
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
                        csi.InstructionSummary ,
                        csi.PatientScheduleSummary
--	,csi.StrengthInstructionSummary
--	,csi.DisbursedToClient
--	,csi.SamplesToClient
                        ,
                        csi.OrderDate ,
                        csi.DrugStartDate ,
                        csi.DrugEndDate ,
                        REPLACE(qs.Refills, '.00', '') ,
                        qs.DurationDays
--	,replace(qs.PharmacyTotal,'.00','')
--	,replace(qs.Sample,'.00','')
--	,replace(qs.Stock,'.00','')
                        ,
                        csi.DAW
	--change special instructions to include comments if specified
                        ,
                        CASE WHEN ISNULL(csi.SpecialInstructions, '') <> ''
                             THEN ISNULL(csi.SpecialInstructions, '')
                                  + CASE WHEN ISNULL(csi.Comments, '') <> ''
                                              AND ISNULL(csi.IncludeCommentOnPrescription,
                                                         'N') <> 'N'
                                         THEN ', ' + ISNULL(csi.Comments, '')
                                         ELSE ''
                                    END
                             WHEN ISNULL(csi.SpecialInstructions, '') = ''
                             THEN CASE WHEN ISNULL(csi.Comments, '') <> ''
                                            AND ISNULL(csi.IncludeCommentOnPrescription,
                                                       'N') <> 'N'
                                       THEN ISNULL(csi.Comments, '')
                                       ELSE ''
                                  END
                             ELSE ''
                        END --csi.SpecialInstructions
                        ,
                        csi.OrderStatus ,
                        qs.Titration ,
                        qs.Multiples ,
                        qs.SingleLine ,
                        csi.PharmacyText
                FROM    #ClientScriptInstructions csi
                        JOIN #QuantitySummary qs ON qs.PON = csi.PON
                                                    AND csi.ClientmedicationInstructionId = qs.ClientmedicationInstructionId
                                                    AND qs.Multiples = 'Y'
                WHERE   @OrderingMethod <> 'F'
                        AND @PrintChartCopy = 'Y'
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
                        csi.InstructionSummary ,
                        csi.PatientScheduleSummary
--	,csi.StrengthInstructionSummary
--	,csi.DisbursedToClient
--	,csi.SamplesToClient
                        ,
                        csi.OrderDate ,
                        ti.TitrationStartDate ,
                        ti.TitrationEndDate ,
                        REPLACE(qs.Refills, '.00', '') ,
                        ti.DurationDays
--	,null as Pharmacy
--	,null as Sample
--	,null as Stock
                        ,
                        csi.DAW
	--change special instructions to include comments if specified
                        ,
                        CASE WHEN ISNULL(csi.SpecialInstructions, '') <> ''
                             THEN ISNULL(csi.SpecialInstructions, '')
                                  + CASE WHEN ISNULL(csi.Comments, '') <> ''
                                              AND ISNULL(csi.IncludeCommentOnPrescription,
                                                         'N') <> 'N'
                                         THEN ', ' + ISNULL(csi.Comments, '')
                                         ELSE ''
                                    END
                             WHEN ISNULL(csi.SpecialInstructions, '') = ''
                             THEN CASE WHEN ISNULL(csi.Comments, '') <> ''
                                            AND ISNULL(csi.IncludeCommentOnPrescription,
                                                       'N') <> 'N'
                                       THEN ISNULL(csi.Comments, '')
                                       ELSE ''
                                  END
                             ELSE ''
                        END --csi.SpecialInstructions
                        ,
                        csi.OrderStatus ,
                        qs.Titration ,
                        qs.Multiples ,
                        qs.SingleLine ,
                        NULL -- ,csi.PharmacyText
                FROM    #ClientScriptInstructions csi
                        JOIN @TitrationInstructions ti ON ti.PON = csi.PON
                        JOIN #QuantitySummary qs ON qs.PON = csi.PON
                                                    AND csi.ClientmedicationInstructionId = qs.ClientmedicationInstructionId
                                                    AND qs.Titration = 'Y'
                WHERE   @OrderingMethod NOT IN ( 'X', 'C' )
--and @PrintChartCopy = 'N'
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
                        csi.InstructionSummary ,
                        csi.PatientScheduleSummary
--	,csi.StrengthInstructionSummary
--	,csi.DisbursedToClient
--	,csi.SamplesToClient
                        ,
                        csi.OrderDate ,
                        ti.TitrationStartDate ,
                        ti.TitrationEndDate ,
                        REPLACE(qs.Refills, '.00', '') ,
                        ti.DurationDays
--	,null as Pharmacy
--	,null as Sample
--	,null as Stock
                        ,
                        csi.DAW
	--change special instructions to include comments if specified
                        ,
                        CASE WHEN ISNULL(csi.SpecialInstructions, '') <> ''
                             THEN ISNULL(csi.SpecialInstructions, '')
                                  + CASE WHEN ISNULL(csi.Comments, '') <> ''
                                              AND ISNULL(csi.IncludeCommentOnPrescription,
                                                         'N') <> 'N'
                                         THEN ', ' + ISNULL(csi.Comments, '')
                                         ELSE ''
                                    END
                             WHEN ISNULL(csi.SpecialInstructions, '') = ''
                             THEN CASE WHEN ISNULL(csi.Comments, '') <> ''
                                            AND ISNULL(csi.IncludeCommentOnPrescription,
                                                       'N') <> 'N'
                                       THEN ISNULL(csi.Comments, '')
                                       ELSE ''
                                  END
                             ELSE ''
                        END --csi.SpecialInstructions
                        ,
                        csi.OrderStatus ,
                        qs.Titration ,
                        qs.Multiples ,
                        qs.SingleLine ,
                        NULL -- ,csi.PharmacyText
                FROM    #ClientScriptInstructions csi
                        JOIN @TitrationInstructions ti ON ti.PON = csi.PON
                        JOIN #QuantitySummary qs ON qs.PON = csi.PON
                                                    AND csi.ClientmedicationInstructionId = qs.ClientmedicationInstructionId
                                                    AND qs.Titration = 'Y'
                WHERE   @OrderingMethod <> 'F'
                        AND @PrintChartCopy = 'Y'
--order by csi.ClientMedicationScriptId, csi.PON, CopyType
    END



    BEGIN
--this is the dataset
--Add Messages to script
        DECLARE @Message1 VARCHAR(MAX) ,
            @Message2 VARCHAR(MAX)

--DO not fill c2 meds before DrugStartDate
        IF EXISTS ( SELECT  *
                    FROM    #ClientScriptInstructionResults
                    WHERE   OrderDate < DrugStartDate
                            AND @C2Meds = 'Y' ) 
            BEGIN
                SELECT  @Message1 = 'DO NOT FILL BEFORE: '
                        + CONVERT(VARCHAR(12), MIN(a.DrugStartDate), 101)
                FROM    #ClientScriptInstructionResults a
                        JOIN @C2MedsList b ON b.PON = a.PON
                WHERE   a.OrderDate < a.DrugStartDate
                GROUP BY a.ClientMedicationScriptId ,
                        a.PON
            END

        SELECT  h.OrganizationName ,
                h.ClientMedicationScriptId ,
                h.ClientMedicationScriptActivityId ,
                m.OrderingMethod ,
                m.CopyType ,
                m.PON ,
                m.InsrtuctionMultipleStrengthGroupId ,
                h.AllergyList ,
                h.ClientId ,
                h.ClientName ,
                h.ClientAddress ,
                h.ClientHomePhone ,
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
--m.StrengthInstructionSummary,
--m.DisbursedToClient,
--replace(m.SamplesToClient,'.00','') as SamplesToClient,
                m.OrderDate ,
                m.DrugStartDate ,
                m.DrugEndDate ,
                REPLACE(m.Refills, '.00', '') AS Refills ,
                m.DurationDays ,
--m.Pharmacy,
--m.Sample,
--m.Stock,
                m.DAW ,
                m.SpecialInstructions ,
                m.OrderStatus ,
                m.Titration ,
                m.Multiples ,
                m.SingleLine ,
                s.PrescriberId ,
                s.Prescriber ,
                s.Creator ,
                s.CreatedBy ,
                s.SignatureFacsimile ,
                s.PrintDrugInformation ,
                @OriginalData AS OrigninalData ,
                @PrintChartCopy AS PrintChartCopy ,
                @C2Meds AS C2Meds ,
                @Message1 AS Message1 ,
                @Message2 AS Message2 ,
                @ShowCoverLetter AS ShowCoverLetter ,
                @FaxFlag AS FaxFlag ,
                @PharmacyCoverLetters AS PharmacyCoverLetters ,
                @OhioBoardCertDate AS OhioBoardCertDate ,
                m.PharmacyText AS SpecialSummary
        FROM    #ScriptHeader h
                JOIN #ClientScriptInstructionResults m ON m.ClientMedicationScriptId = h.ClientMedicationScriptId
                JOIN #ScriptSignatures s ON s.ClientMedicationScriptId = h.ClientMedicationScriptId
        ORDER BY h.ClientMedicationScriptId ,
                m.OrderingMethod ,
                m.PON ,
                m.InsrtuctionMultipleStrengthGroupId ,
                m.ClientmedicationInstructionId
    END


    DROP TABLE #ClientScriptInstructions
    DROP TABLE #ClientScriptInstructionResults
    DROP TABLE #QuantitySummary
    DROP TABLE #ScriptHeader
    DROP TABLE #ScriptSignatures

GO


