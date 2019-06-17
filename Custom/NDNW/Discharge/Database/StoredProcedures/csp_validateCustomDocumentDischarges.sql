/****** Object:  StoredProcedure [dbo].[csp_validateCustomDocumentDischarges]    Script Date: 12/14/2016 9:36:14 AM ******/
DROP PROCEDURE [dbo].[csp_validateCustomDocumentDischarges]
GO

/****** Object:  StoredProcedure [dbo].[csp_validateCustomDocumentDischarges]    Script Date: 12/14/2016 9:36:14 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[csp_validateCustomDocumentDischarges] @DocumentVersionId INT
AS /******************************************************************************
**  File: [csp_validateCustomDocumentDischarges]
**  Name: [csp_validateCustomDocumentDischarges]
**  Desc: For Validation  on Discharges
**  Return values: Resultset having validation messages
**  Called by:
**  Parameters:
**  Auth:  Anto
**  Date:  FEB 18 2015
**			JUN 13 2015 - T.Remisoski - adjust validation for ReferralTo
**			JUN 13 2015 - T.Remisoski - change 'CustomDocumentDischarge' to
										correct table name.
**			AUG 13 2015 - T.Remisoski - disable some validations for legacy
										clients that were migrated
**          Dec 14 2016    R.Caffrey  - disable All Treatment Plans completed for 
										Agency Discharge - NDNW Support #492
**			May 15 2017	-  Prateek    - Turned off a validation wrt New Directions - Support Go Live #640										
*******************************************************************************/

    BEGIN

        BEGIN TRY

            DECLARE @CustomDocumentDischarge TABLE ( DocumentVersionId INT NOT NULL
                                                   , RecordDeleted type_YOrN NULL
                                                   , DeletedBy type_UserId NULL
                                                   , DeletedDate DATETIME NULL
                                                   , NewPrimaryClientProgramId INT NULL
                                                   , DischargeType CHAR(1) NULL
                                                   , TransitionDischarge type_GlobalCode NULL
                                                   , DischargeDetails VARCHAR(MAX) NULL
                                                   , OverallProgress VARCHAR(MAX) NULL
                                                   , StatusLastContact VARCHAR(MAX) NULL
                                                   , EducationLevel type_GlobalCode NULL
                                                   , MaritalStatus type_GlobalCode NULL
                                                   , EducationStatus type_GlobalCode NULL
                                                   , EmploymentStatus type_GlobalCode NULL
                                                   , ForensicCourtOrdered type_GlobalCode NULL
                                                   , CurrentlyServingMilitary type_GlobalCode NULL
                                                   , Legal type_GlobalCode NULL
                                                   , JusticeSystem type_GlobalCode NULL
                                                   , LivingArrangement type_GlobalCode NULL
                                                   , Arrests VARCHAR(20) NULL
                                                   , AdvanceDirective type_GlobalCode NULL
                                                   , TobaccoUse type_GlobalCode NULL
                                                   , AgeOfFirstTobaccoUse VARCHAR(20) NULL
                                                   , CountyResidence type_GlobalCode NULL
                                                   , CountyFinancialResponsibility type_GlobalCode NULL
                                                   , NoReferral type_YOrN NULL
                                                   , SymptomsReoccur VARCHAR(MAX) NULL
                                                   , ReferredTo VARCHAR(MAX) NULL
                                                   , Reason VARCHAR(MAX) NULL
                                                   , DatesTimes VARCHAR(MAX) NULL
                                                   , ReferralDischarge type_GlobalCode NULL
                                                   , Treatmentcompletion type_GlobalCode NULL
                                                   , CoOccurringHealthProblem type_YOrN NULL
                                                   , ClientType type_GlobalCode NULL
                                                   , HealthInsurance type_Comment2 NULL
                                                   , NumberOfMonthsEmployed INT NULL
                                                   , SchoolAttendance type_GlobalCode NULL
                                                   , NumberOfEmployers INT NULL
                                                   , StableHousing INT NULL
                                                   , ArrestsInLast12Months INT NULL
                                                   , IncarceratedInLast12Months INT NULL
                                                   , GrossAnnualHouseholdIncome DECIMAL NULL
                                                   , VocationalRehab type_YOrN NULL )

--*INSERT LIST*--
            INSERT INTO @CustomDocumentDischarge
                    ( DocumentVersionId
                    ,RecordDeleted
                    ,DeletedBy
                    ,DeletedDate
                    ,NewPrimaryClientProgramId
                    ,DischargeType
                    ,TransitionDischarge
                    ,DischargeDetails
                    ,OverallProgress
                    ,StatusLastContact
                    ,EducationLevel
                    ,MaritalStatus
                    ,EducationStatus
                    ,EmploymentStatus
                    ,ForensicCourtOrdered
                    ,CurrentlyServingMilitary
                    ,Legal
                    ,JusticeSystem
                    ,LivingArrangement
                    ,Arrests
                    ,AdvanceDirective
                    ,TobaccoUse
                    ,AgeOfFirstTobaccoUse
                    ,CountyResidence
                    ,CountyFinancialResponsibility
                    ,NoReferral
                    ,SymptomsReoccur
                    ,ReferredTo
                    ,Reason
                    ,DatesTimes
                    ,ReferralDischarge
                    ,Treatmentcompletion
                    ,CoOccurringHealthProblem
                    ,ClientType
                    ,HealthInsurance
                    ,NumberOfMonthsEmployed
                    ,SchoolAttendance
                    ,NumberOfEmployers
                    ,StableHousing
                    ,ArrestsInLast12Months
                    ,IncarceratedInLast12Months
                    ,GrossAnnualHouseholdIncome
                    ,VocationalRehab )

--*Select LIST*--
                    SELECT DocumentVersionId
                        ,   RecordDeleted
                        ,   DeletedBy
                        ,   DeletedDate
                        ,   NewPrimaryClientProgramId
                        ,   DischargeType
                        ,   TransitionDischarge
                        ,   DischargeDetails
                        ,   OverallProgress
                        ,   StatusLastContact
                        ,   EducationLevel
                        ,   MaritalStatus
                        ,   EducationStatus
                        ,   EmploymentStatus
                        ,   ForensicCourtOrdered
                        ,   CurrentlyServingMilitary
                        ,   Legal
                        ,   JusticeSystem
                        ,   LivingArrangement
                        ,   Arrests
                        ,   AdvanceDirective
                        ,   TobaccoUse
                        ,   AgeOfFirstTobaccoUse
                        ,   CountyResidence
                        ,   CountyFinancialResponsibility
                        ,   NoReferral
                        ,   SymptomsReoccur
                        ,   ReferredTo
                        ,   Reason
                        ,   DatesTimes
                        ,   ReferralDischarge
                        ,   TreatmentCompletion
                        ,   CoOccurringHealthProblem
                        ,   ClientType
                        ,   HealthInsurance
                        ,   NumberOfMonthsEmployed
                        ,   SchoolAttendance
                        ,   NumberOfEmployers
                        ,   StableHousing
                        ,   ArrestsInLast12Months
                        ,   IncarceratedInLast12Months
                        ,   GrossAnnualHouseholdIncome
                        ,   VocationalRehab
                        FROM dbo.CustomDocumentDischarges C
                        WHERE C.DocumentVersionId = @DocumentVersionId
                            AND ISNULL(C.RecordDeleted, 'N') <> 'Y'

            DECLARE @ClientId INT
            SELECT @ClientId = ClientId
                FROM Documents
                WHERE InProgressDocumentVersionId = @DocumentVersionId
                    AND ISNULL(RecordDeleted, 'N') = 'N'

-- flag whether a given client was migrated from the legacy system
            DECLARE @IsLegacyClient CHAR(1) = 'N'
            SET @IsLegacyClient = ( SELECT CASE WHEN ExternalClientId IS NOT NULL THEN 'Y'
                                                ELSE 'N'
                                           END
                                        FROM Clients
                                        WHERE ClientId = @ClientId )

            DECLARE @Programcount INT
            DECLARE @PrimaryProgramcount INT
            SELECT @Programcount = COUNT(*)
                FROM ClientPrograms
                WHERE ClientId = @ClientId
                    AND Status IN ( 4, 1 )
            IF ( @Programcount = 1 )
                BEGIN
                    BEGIN
                        SELECT @PrimaryProgramcount = COUNT(*)
                            FROM ClientPrograms
                            WHERE ClientId = @ClientId
                                AND PrimaryAssignment = 'Y'
                    END
                END

            DECLARE @Discharge CHAR(2) = ''
            DECLARE @Count INT
            SELECT @Count = COUNT(*)
                FROM CustomDischargePrograms
                WHERE DocumentVersionId = @DocumentVersionId
                    AND RecordDeleted = 'N'
            IF ( @Count >= 1 )
                BEGIN
                    SET @Discharge = 'D'
                END


            DECLARE @SUAdmissionDocumentVersionID INT
            DECLARE @SUAdmissionCheck CHAR(1)

            SELECT TOP 1 @SUAdmissionDocumentVersionID = CurrentDocumentVersionId
                FROM CustomDocumentSUAdmissions CDSA
                    INNER JOIN Documents Doc ON CDSA.DocumentVersionId = Doc.CurrentDocumentVersionId
                WHERE Doc.ClientId = @ClientId
                    AND Doc.[Status] <> 22
                    AND ISNULL(CDSA.RecordDeleted, 'N') = 'N'
                    AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
                ORDER BY Doc.EffectiveDate DESC
                ,   Doc.ModifiedDate DESC

            IF ( @SUAdmissionDocumentVersionID <> '' )
                BEGIN
                    SET @SUAdmissionCheck = 'Y'
                END
            ELSE
                BEGIN
                    SET @SUAdmissionCheck = 'N'
                END

            DECLARE @BedCensusCount INT
            DECLARE @BedCensusCheck CHAR(1)

            SELECT @BedCensusCount = COUNT(*)
                FROM ClientInpatientVisits
                WHERE Status = 4982
                    AND AdmitDate IS NOT NULL
                    AND DischargedDate IS NULL
                    AND ClientId = @ClientId
            IF ( @BedCensusCount >= 1 )
                BEGIN
                    SET @BedCensusCheck = 'Y'
                END
            ELSE
                BEGIN
                    SET @BedCensusCheck = 'N'
                END


            DECLARE @CareplanDocumentVersionID INT
            DECLARE @CareplanCheck CHAR(1)

            SELECT TOP 1 @CareplanDocumentVersionID = CurrentDocumentVersionId
                FROM DocumentCarePlans CDSA
                    INNER JOIN Documents Doc ON CDSA.DocumentVersionId = Doc.CurrentDocumentVersionId
                WHERE Doc.ClientId = @ClientId
                    AND Doc.[Status] = 22
                    AND ISNULL(CDSA.RecordDeleted, 'N') = 'N'
                    AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
                ORDER BY Doc.EffectiveDate DESC
                ,   Doc.ModifiedDate DESC

            IF ( @CareplanDocumentVersionID <> '' )
                BEGIN
                    SET @CareplanCheck = 'Y'
                END
            ELSE
                BEGIN
                    SET @CareplanCheck = 'N'
                END





            DECLARE @OpenCareplanDocumentVersionID INT
            DECLARE @OpenCareplanCheck CHAR(1)

            SELECT TOP 1 @OpenCareplanDocumentVersionID = CurrentDocumentVersionId
                FROM DocumentCarePlans CDSA
                    INNER JOIN Documents Doc ON CDSA.DocumentVersionId = Doc.CurrentDocumentVersionId
                WHERE Doc.ClientId = @ClientId
                    AND Doc.[Status] <> 22
                    AND ISNULL(CDSA.RecordDeleted, 'N') = 'N'
                    AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
                ORDER BY Doc.EffectiveDate DESC
                ,   Doc.ModifiedDate DESC

            IF ( @OpenCareplanDocumentVersionID <> '' )
                BEGIN
                    SET @OpenCareplanCheck = 'Y'
                END
            ELSE
                BEGIN
                    SET @OpenCareplanCheck = 'N'
                END







            DECLARE @LatestICD10DocumentVersionID INT
            DECLARE @ICD10Check CHAR(1)
            DECLARE @AdminCloseGlobalcode INT

            SET @LatestICD10DocumentVersionID = ( SELECT TOP 1 CurrentDocumentVersionId
                                                    FROM Documents a
                                                        INNER JOIN DocumentCodes Dc ON Dc.DocumentCodeId = a.DocumentCodeId
                                                    WHERE a.ClientId = @ClientId
                                                        AND a.EffectiveDate <= CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101))
                                                        AND a.Status = 22
                                                        AND Dc.DiagnosisDocument = 'Y'
                                                        AND a.DocumentCodeId = 1601
                                                        AND ISNULL(a.RecordDeleted, 'N') <> 'Y'
                                                        AND ISNULL(Dc.RecordDeleted, 'N') <> 'Y'
                                                    ORDER BY a.EffectiveDate DESC
                                                    ,   a.ModifiedDate DESC )
            SELECT @AdminCloseGlobalcode = GlobalCodeId
                FROM GlobalCodes
                WHERE Category = 'xPROGDISCHARGEREASON'
                    AND CodeName = 'Administrative discharge'


            IF ( @LatestICD10DocumentVersionID <> '' )
                BEGIN
                    SET @ICD10Check = 'Y'
                END
            ELSE
                BEGIN
                    SET @ICD10Check = 'N'
                END


            DECLARE @CountNonPrimaryProgram INT
            DECLARE @NonPrimaryProgram CHAR(1)
            SELECT @CountNonPrimaryProgram = ClientProgramId
                FROM CustomDischargePrograms
                WHERE DocumentVersionId = @DocumentVersionId
                    AND ClientProgramId NOT IN ( SELECT ClientProgramId
                                                    FROM ClientPrograms
                                                    WHERE ClientId = @ClientId
                                                        AND PrimaryAssignment = 'Y'
                                                        AND Status IN ( 1, 4 ) )
            IF ( @CountNonPrimaryProgram >= 1 )
                BEGIN
                    SET @NonPrimaryProgram = 'Y'
                END

            DECLARE @DiagnosisDocumentVersionID INT
            DECLARE @DiagnosisDocumentCheck CHAR(1)
            SELECT TOP 1 @DiagnosisDocumentVersionID = CurrentDocumentVersionId
                FROM DocumentDiagnosisCodes CDSA
                    INNER JOIN Documents Doc ON CDSA.DocumentVersionId = Doc.CurrentDocumentVersionId
                WHERE Doc.ClientId = @ClientId
                    AND Doc.[Status] = 22
                    AND ISNULL(CDSA.RecordDeleted, 'N') = 'N'
                    AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
                ORDER BY Doc.EffectiveDate DESC
                ,   Doc.ModifiedDate DESC

            IF ( @DiagnosisDocumentVersionID <> '' )
                BEGIN
                    SET @DiagnosisDocumentCheck = 'Y'
                END
            ELSE
                BEGIN
                    SET @DiagnosisDocumentCheck = 'N'
                END




            DECLARE @FlexcareDocumentVersionID INT
            DECLARE @FlexcareCheck CHAR(1)
            SELECT @FlexcareDocumentVersionID = COUNT(NewPrimaryClientProgramId)
                FROM CustomDocumentDischarges
                WHERE DocumentVersionId = @DocumentVersionId
                    AND NewPrimaryClientProgramId IN ( SELECT IntegerCodeId
                                                        FROM Recodes
                                                        WHERE CodeName = 'Flexcare' )
            IF ( @FlexcareDocumentVersionID >= 1 )
                BEGIN
                    SET @FlexcareCheck = 'Y'
                END
            ELSE
                BEGIN
                    SET @FlexcareCheck = 'N'
                END





            DECLARE @TobaccoUsecount INT
            DECLARE @TobaccoUseCheck CHAR(1)
            SELECT @TobaccoUsecount = COUNT(TobaccoUse)
                FROM CustomDocumentDischarges
                WHERE DocumentVersionId = @DocumentVersionId
                    AND NewPrimaryClientProgramId IN ( SELECT GlobalCodeId
                                                        FROM GlobalCodes
                                                        WHERE Category = 'XSMOKINGSTATUS'
                                                            AND CodeName IN ( 'Never smoked', 'Former smoker', 'Current someday smoker', 'Current everyday smoker', 'Use smokeless tobacco only in last 30 days', 'Current status unknown', 'Not applicable', 'Former smoking status unknown' ) )

            IF ( @TobaccoUsecount >= 1 )
                BEGIN
                    SET @TobaccoUseCheck = 'Y'
                END



            DECLARE @ReferralCount INT
            SELECT @ReferralCount = COUNT(*)
                FROM CustomDischargeReferrals
                WHERE DocumentVersionId = @DocumentVersionId


            DECLARE @validationReturnTable TABLE ( TableName VARCHAR(200)
                                                 , ColumnName VARCHAR(200)
                                                 , ErrorMessage VARCHAR(1000)
                                                 , PageIndex INT
                                                 , TabOrder INT
                                                 , ValidationOrder INT )

--#############################################################################
-- Task 464, add a method to bypass validation
--############################################################################# 
            IF EXISTS ( SELECT 1
                            FROM DocumentVersionValidationExceptions DVVE
                            WHERE DVVE.DocumentVersionId = @DocumentVersionId
                                AND DVVE.DocumentCodeId = 46225 )
                BEGIN
                    SELECT TableName
                        ,   ColumnName
                        ,   ErrorMessage
                        ,   PageIndex
                        ,   TabOrder
                        ,   ValidationOrder
                        FROM @validationReturnTable
                        ORDER BY ValidationOrder ASC

                    IF EXISTS ( SELECT *
                                    FROM @validationReturnTable )
                        BEGIN
                            SELECT 1 AS ValidationStatus
                        END
                    ELSE
                        BEGIN
                            SELECT 0 AS ValidationStatus
                        END
                        RETURN
                END


--#############################################################################
-- end task 464 change
--############################################################################# 


            INSERT INTO @validationReturnTable
                    ( TableName
                    ,ColumnName
                    ,ErrorMessage
                    ,ValidationOrder )
--This validation returns three fields
--Field1 = TableName
--Field2 = ColumnName
--Field3 = ErrorMessage
                    SELECT 'CustomDocumentDischarges'
                        ,   'CoOccurringHealthProblem'
                        ,   'General – Client Information – Co-Occurring health problems is required'
                        ,   1
                        FROM @CustomDocumentDischarge
                        WHERE ISNULL(CoOccurringHealthProblem, '') = ''
                    UNION
                    SELECT 'CustomDocumentDischarges'
                        ,   'ClientType'
                        ,   'General – Client Information – Client Type is required'
                        ,   2
                        FROM @CustomDocumentDischarge
                        WHERE ISNULL(ClientType, '') = ''
                    UNION
                    SELECT 'CustomDocumentDischarges'
                        ,   'HealthInsurance'
                        ,   'General – Client Information – Health Insurance is required'
                        ,   3
                        FROM @CustomDocumentDischarge
                        WHERE ISNULL(HealthInsurance, '') = ''
                    UNION
                    SELECT 'CustomDocumentDischarges'
                        ,   'TransitionDischarge'
                        ,   'General – Discharge - Please specify Discharge Reason'
                        ,   4
                        FROM @CustomDocumentDischarge
                        WHERE ISNULL(TransitionDischarge, '') = ''
                    UNION
                    SELECT 'CustomDocumentDischarges'
                        ,   'DischargeDetails'
                        ,   'General – Discharge - Please specify Discharge Details'
                        ,   5
                        FROM @CustomDocumentDischarge
                        WHERE ISNULL(DischargeDetails, '') = ''
                    UNION
                    SELECT 'CustomDocumentDischarges'
                        ,   'OverallProgress'
                        ,   'Progress Review – Overall Progress - Please specify Overall Progress and movement toward recovery '
                        ,   6
                        FROM @CustomDocumentDischarge
                        WHERE ISNULL(OverallProgress, '') = ''
                            AND @Discharge = 'D'
                            AND @FlexcareCheck = 'N'
                    UNION
                    SELECT 'CustomDocumentDischarges'
                        ,   'StatusLastContact'
                        ,   'Progress Review – Overall Progress - Please specify Status at last contact'
                        ,   7
                        FROM @CustomDocumentDischarge
                        WHERE ISNULL(StatusLastContact, '') = ''
                            AND @Discharge = 'D'
                            AND @FlexcareCheck = 'N'
                    UNION
                    SELECT 'CustomDocumentDischarges'
                        ,   'Treatmentcompletion'
                        ,   'Progress Review – Treatment Completion is required'
                        ,   8
                        FROM @CustomDocumentDischarge
                        WHERE ISNULL(Treatmentcompletion, 0) <= 0
                            AND @Discharge = 'D'
                    UNION
                    SELECT 'CustomDocumentDischarges'
                        ,   'EducationLevel'
                        ,   'Progress Review – Additional Information - Education Level is required'
                        ,   9
                        FROM @CustomDocumentDischarge
                        WHERE ISNULL(EducationLevel, 0) <= 0
                            AND @Discharge = 'D'
                    UNION
                    SELECT 'CustomDocumentDischarges'
                        ,   'MaritalStatus'
                        ,   'Progress Review – Additional Information - Marital Status is required'
                        ,   10
                        FROM @CustomDocumentDischarge
                        WHERE ISNULL(MaritalStatus, 0) <= 0
                            AND @Discharge = 'D'
                    UNION
                    SELECT 'CustomDocumentDischarges'
                        ,   'EducationStatus'
                        ,   'Progress Review – Additional Information - Education Status is required'
                        ,   11
                        FROM @CustomDocumentDischarge
                        WHERE ISNULL(EducationStatus, 0) <= 0
                            AND @Discharge = 'D'
                    UNION
                    SELECT 'CustomDocumentDischarges'
                        ,   'EmploymentStatus'
                        ,   'Progress Review – Additional Information - Employment Status is required'
                        ,   12
                        FROM @CustomDocumentDischarge
                        WHERE ISNULL(EmploymentStatus, 0) <= 0
                            AND @Discharge = 'D'
                    UNION
                    SELECT 'CustomDocumentDischarges'
                        ,   'VocationalRehab'
                        ,   'Progress Review – Additional Information - Currently enrolled in vocational rehab is required'
                        ,   13
                        FROM @CustomDocumentDischarge
                        WHERE ISNULL(VocationalRehab, '') = ''
                            AND @Discharge = 'D'
                    UNION
                    SELECT 'CustomDocumentDischarges'
                        ,   'NumberOfMonthsEmployed'
                        ,   'Progress Review – Additional Information - # of months employed is required'
                        ,   14
                        FROM @CustomDocumentDischarge
                        WHERE ISNULL(NumberOfMonthsEmployed, -1) < 0
                            AND @Discharge = 'D'
                    UNION
                    SELECT 'CustomDocumentDischarges'
                        ,   'SchoolAttendance'
                        ,   'Progress Review – Additional Information - School attendance is required'
                        ,   15
                        FROM @CustomDocumentDischarge
                        WHERE ISNULL(SchoolAttendance, 0) <= 0
                            AND @Discharge = 'D'
                    UNION
                    SELECT 'CustomDocumentDischarges'
                        ,   'NumberOfEmployers'
                        ,   'Progress Review – Additional Information - # of employers is required'
                        ,   16
                        FROM @CustomDocumentDischarge
                        WHERE ISNULL(NumberOfEmployers, -1) < 0
                            AND @Discharge = 'D'
                    UNION
                    SELECT 'CustomDocumentDischarges'
                        ,   'CurrentlyServingMilitary'
                        ,   'Progress Review – Additional Information - Have you ever or are you currently serving in the military is required'
                        ,   17
                        FROM @CustomDocumentDischarge
                        WHERE ISNULL(CurrentlyServingMilitary, 0) <= 0
                            AND @Discharge = 'D'
                    UNION
                    SELECT 'CustomDocumentDischarges'
                        ,   'Legal'
                        ,   'Progress Review – Additional Information - Legal is required'
                        ,   18
                        FROM @CustomDocumentDischarge
                        WHERE ISNULL(Legal, 0) <= 0
                            AND @Discharge = 'D'
                    UNION
                    SELECT 'CustomDocumentDischarges'
                        ,   'LivingArrangement'
                        ,   'Progress Review – Additional Information - Living arrangement is required'
                        ,   19
                        FROM @CustomDocumentDischarge
                        WHERE ISNULL(LivingArrangement, 0) <= 0
                            AND @Discharge = 'D'
                    UNION
                    SELECT 'CustomDocumentDischarges'
                        ,   'Arrests'
                        ,   'Progress Review – Additional Information - # of arrests in the last 30 days is required'
                        ,   20
                        FROM @CustomDocumentDischarge
                        WHERE ISNULL(Arrests, '') = ''
                            AND @Discharge = 'D'
                    UNION
                    SELECT 'CustomDocumentDischarges'
                        ,   'StableHousing'
                        ,   'Progress Review – Additional Information - # of days in stable housing in last 90 days is required'
                        ,   21
                        FROM @CustomDocumentDischarge
                        WHERE ISNULL(StableHousing, -1) < 0
                            AND @Discharge = 'D'
                    UNION
                    SELECT 'CustomDocumentDischarges'
                        ,   'ArrestsInLast12Months'
                        ,   'Progress Review – Additional Information - # of arrests in last 12 months is required'
                        ,   22
                        FROM @CustomDocumentDischarge
                        WHERE ISNULL(ArrestsInLast12Months, -1) < 0
                            AND @Discharge = 'D'
                    UNION
                    SELECT 'CustomDocumentDischarges'
                        ,   'AdvanceDirective'
                        ,   'Progress Review – Additional Information – Advance Directive is required'
                        ,   23
                        FROM @CustomDocumentDischarge
                        WHERE ISNULL(AdvanceDirective, 0) <= 0
                            AND @Discharge = 'D'
                    UNION
                    SELECT 'CustomDocumentDischarges'
                        ,   'IncarceratedInLast12Months'
                        ,   'Progress Review – Additional Information - # of days incarcerated in last 12 months is required'
                        ,   24
                        FROM @CustomDocumentDischarge
                        WHERE ISNULL(IncarceratedInLast12Months, -1) < 0
                            AND @Discharge = 'D'
                    UNION
                    SELECT 'CustomDocumentDischarges'
                        ,   'TobaccoUse'
                        ,   'Progress Review – Additional Information - Tobacco Use is required'
                        ,   25
                        FROM @CustomDocumentDischarge
                        WHERE ISNULL(TobaccoUse, 0) <= 0
                            AND @Discharge = 'D'
                    UNION
                    SELECT 'CustomDocumentDischarges'
                        ,   'AgeOfFirstTobaccoUse'
                        ,   'Progress Review – Additional Information – Age of First Tobacco Use is required'
                        ,   26
                        FROM @CustomDocumentDischarge
                        WHERE ISNULL(AgeOfFirstTobaccoUse, '') = ''
                            AND @Discharge = 'D'
                            AND @TobaccoUseCheck = 'Y'
                    UNION
                    SELECT 'CustomDocumentDischarges'
                        ,   'CountyResidence'
                        ,   'Progress Review – Additional Information – County of Residence is required'
                        ,   27
                        FROM @CustomDocumentDischarge
                        WHERE ISNULL(CountyResidence, 0) <= 0
                            AND @Discharge = 'D'
                    UNION
                    SELECT 'CustomDocumentDischarges'
                        ,   'CountyFinancialResponsibility'
                        ,   'Progress Review – Additional Information – County of Financial Responsibility is required'
                        ,   28
                        FROM @CustomDocumentDischarge
                        WHERE ISNULL(CountyFinancialResponsibility, 0) <= 0
                            AND @Discharge = 'D'
                    UNION
                    SELECT 'CustomDocumentDischarges'
                        ,   'GrossAnnualHouseholdIncome'
                        ,   'Progress Review – Additional Information – Gross annual household income'
                        ,   29
                        FROM @CustomDocumentDischarge
                        WHERE ISNULL(GrossAnnualHouseholdIncome, -1) < 0
                            AND @Discharge = 'D'

--Union
--Select 'CustomDocumentDischarges', 'NoReferral', 'Referrals/Disposition Plan – Disposition Plan – Referral is required',30
--FROM @CustomDocumentDischarge
--WHERE IsNULL (NoReferral,'') <> 'Y' AND @ReferralCount = 0 AND @Discharge = 'D'
                    UNION
                    SELECT 'CustomDocumentDischarges'
                        ,   'SymptomsReoccur'
                        ,   'Referrals/Disposition Plan – Disposition Plan - If symptoms reoccur or additional services are needed is required '
                        ,   31
                        FROM @CustomDocumentDischarge
                        WHERE ISNULL(SymptomsReoccur, '') = ''
                            AND @Discharge = 'D'
                    UNION
                    SELECT 'CustomDocumentDischarges'
                        ,   'ReferredTo'
                        ,   'Referrals/ Disposition Plan – Referrals - Please specify Referred to'
                        ,   32
                        FROM @CustomDocumentDischarge
                        WHERE ISNULL(ReferredTo, '') = ''
                            AND @Discharge = 'D'
                            AND ISNULL(NoReferral, 'N') <> 'Y'
                    UNION
                    SELECT 'CustomDocumentDischarges'
                        ,   'DischargeType'
                        ,   'General – Program Actions – Primary Program must be transferred to another Program before you can discharge'
                        ,   33
                        FROM @CustomDocumentDischarge
                        WHERE ISNULL(DischargeType, '') = 'P'
                            AND @PrimaryProgramcount = 1
                    UNION
                    SELECT 'CustomDocumentDischarges'
                        ,   'DischargeType'
                        ,   'General – Program Actions – Open SUD Admission must be closed before discharge'
                        ,   34
                        FROM @CustomDocumentDischarge
                        WHERE @SUAdmissionCheck = 'Y'
                    UNION
                    SELECT 'CustomDocumentDischarges'
                        ,   'DischargeType'
                        ,   'General – Program Actions - Open Residential Bed Census must be discharged prior to Agency Discharge'
                        ,   35
                        FROM @CustomDocumentDischarge
                        WHERE ISNULL(DischargeType, '') = 'A'
                            AND @BedCensusCheck = 'Y'
                    --UNION
                    --SELECT 'CustomDocumentDischarges'
                    --    ,   'DischargeType'
                    --    ,   'General – Program Actions – All Care Plans/Treatment Plans need to be completed prior to Agency Discharge'
                    --    ,   36
                    --    FROM @CustomDocumentDischarge
                    --    WHERE ISNULL(DischargeType, '') = 'A'
                    --        AND @CareplanCheck = 'N'
                    --        AND @IsLegacyClient = 'N'
                    UNION
                    SELECT 'CustomDocumentDischarges'
                        ,   'DischargeType'
                        ,   'General – Program Actions - Must close all goals and objectives before you can do Agency Discharge '
                        ,   37
                        FROM @CustomDocumentDischarge
                        WHERE ISNULL(DischargeType, '') = 'A'
                            AND @OpenCareplanCheck = 'Y'
                            AND @IsLegacyClient = 'N'
                    UNION
                    SELECT 'CustomDocumentDischarges'
                        ,   'TransitionDischarge'
                        ,   'Client must have a diagnosis document or Discharge Reason must be “Administrative discharge” '
                        ,   38
                        FROM @CustomDocumentDischarge
                        WHERE ISNULL(TransitionDischarge, '') <> @AdminCloseGlobalcode
                            AND @ICD10Check = 'N'
                            AND @IsLegacyClient = 'N'





--Union
--Select 'CustomDocumentDischarges', 'DischargeType', 'General – Program Actions - Only the Primary Program can be Discharged',28
--FROM @CustomDocumentDischarge
--WHERE IsNULL (DischargeType,'') = 'A' AND  @NonPrimaryProgram = 'Y'
                    
                    /*Turned off the validation Prateek 5/15/2017 wrt New Directions - Support Go Live #640*/
                    --UNION
                    --SELECT 'CustomDocumentDischarges'
                    --    ,   'DischargeType'
                    --    ,   'General – Program Actions -  Diagnosis co-signature must be completed prior to Discharge'
                    --    ,   39
                    --    FROM @CustomDocumentDischarge
                    --    WHERE ISNULL(DischargeType, '') = 'A'
                    --        AND @DiagnosisDocumentCheck = 'N'
                    --        AND @IsLegacyClient = 'N'





            SELECT TableName
                ,   ColumnName
                ,   ErrorMessage
                ,   PageIndex
                ,   TabOrder
                ,   ValidationOrder
                FROM @validationReturnTable
                ORDER BY ValidationOrder ASC

         


        END TRY

        BEGIN CATCH

            DECLARE @Error VARCHAR(8000)
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), '[csp_validateCustomDocumentDischarges]') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())
            RAISERROR
 (
  @Error, -- Message text.
  16, -- Severity.
  1 -- State.
 );
        END CATCH
    END








GO


