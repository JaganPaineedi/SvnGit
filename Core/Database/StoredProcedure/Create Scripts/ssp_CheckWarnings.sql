IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_CheckWarnings]')
                    AND type IN ( N'P', N'PC' ) ) 
    DROP PROCEDURE [dbo].[ssp_CheckWarnings]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 

CREATE PROCEDURE dbo.ssp_CheckWarnings
    @ClientId INT ,
    @ServiceId INT ,
    @ProcedureCodeId INT ,
    @ClinicianId INT ,
    @StartDate DATETIME ,
    @EndDate DATETIME ,
    @Attending VARCHAR(10) ,
    @ServiceCompletionStatus VARCHAR(10) ,
    @ProgramId INT ,
    @LocationId INT ,
    @Degree INT ,
    @UnitValue DECIMAL(9, 2) ,
    @PreviousStatus INT
/******************************************************************************  
**  
**  Name: SSP_CheckWarnings  
**  Desc:   
**  This procedure is used to check the warnings for the service, while completing the service.  
**  
**  Return values:  
**   
**  Called by:   ServiceDetails.cs  
**                
**  Parameters:  
**  Input       Output  
**              @ClientId int,  
**  @ServiceId int,  
**  @ProcedureCodeId int,  
**  @ClinicianId int,  
**  @StartDate DateTime,  
**  @EndDate DateTime,  
**  @Attending varchar(10),  
**  @DSMCode1 varchar(10),  
**  @DSMCode2 varchar(10),  
**  @DSMCode3 varchar(10)        
**  
**  Auth: Rohit  
**  Date:   
*******************************************************************************  
**  Change History  
*******************************************************************************  
**  Date:        Author:   Description:  
**  09/24/2006   Rohit D   For checking billing diagnosis for Billable Procedure  
**  01/31/2006   SFarber   Modified to check if the service has been already completed  
**  06/12/2012   Anil      Add condition b.NoAuthorizationRequiredOverride = 'Y w.rf to task 1710 in PM Web Bugs 
**  11/02/2012   Jagdeep   Commented error message (A service that has a $0 rate must be marked as ''Not billable'' in order to complete);as per task #12-5 IG: PM: Ability to bill $0 charge on an 837 	Interact Development Implementation
**  12-Feb-2012  Rakesh Garg Comment the condition added by Anil  b.NoAuthorizationRequiredOverride = 'Y w.rf to task 1710 in PM Web Bugs as commented in 3.x Thread.
**	05-Apr-2013	 Manjit		Condition("IF @AssociatedNoteId > 0 and @Billable = 'Y'") added on date("11/02/2012") has been Un-Commented by discuss with Javed
							and get(@RateId and @Billable) in single query on Services table
**  06/21/2013   SFarber   Replaced csp_CheckWarnings with scsp_CheckWarnings
**  10/22/2013   Jeff Riley Added checks for invalid duration and/or DateTimeIn/DateTimeOut ranges	
**  14/11/2013   Aravind   Added logic for "Not to show warning/error messages"  for ServiceStatus(Cancel/Errors/NoShow ).#302 - Summit 3.5 Implementation
**	DEC-27-2013		dharvey		Correctd Join logic from Documents to DocumentCodes record deleted check #462 Venture Region 3.5
** JUNE-05-2014 Katta Sharath Kumar Added logic for "Not to show warning/error messages for Billing diagnosis required for completing the service."  for ServiceStatus(Complete).#1530 - Core Bugs task#
**	10/12/2014		NJain		Added ssp for Add-On Service creation
**  OCT-07-2014  Akwinass  Removed the Parameters @DSMCode1,@DSMCode2,@DSMCode3 and Modified the Billing Diagnosis Validation Based on @ServiceId (Task #134 in Engineering Improvement Initiatives- NBL(I))
**  NOV-06-2014  Akwinass  Merged (10/12/2014 - NJain) (Task #134 in Engineering Improvement Initiatives- NBL(I))
**  June-30-2015 Arjun K R Added condition ISNULL(RecordDeleted,'N')<>'Y' while selecting records from servicediagnosis table. Task #25 WMU Support Go Live.
**  SEP-29-2015  Gautam     Added checks for ICD10 diagnosis which require other diagnoses codes /conflict with certain other diagnosis codes, Task#44,Diagnosis Changes (ICD10)
**  Nov-19-2015  MD Khusro  Replace 'DateTimeIn' and 'DateTimeOut' with 'DateOfService' and 'EndDateOfService' for validations on Time In/Time Out as suggested by Javed 
**							and modified 'EndDateOfService' logic to handle 12:00 AM case for validation 'End Date does not equal Start Date.'  w.r.t Allegan Support #205
**  2/12/2016	  jcarlson  allow exclusion of procedure codes from requiring a diagnosis valley sgl 261
**  06/20/2016   jcarlson   added in missing core global code ids
**  16/Sep/2016	 Gautam		Added code to not throw error if @OverrideCharge exists in Services. For OverrideCharge , 
							Rate may not exists.,Bradford - Support Go Live: #196 HL7: services created from HL 7 are not completing
**  19 oct 2016  jwheeler       Added validation for ICD10 Diagnoses codes with respect to fiscal year.  Philhaven-Support #72.
** 23 JAN 2017    Pabitra      What: Added condition to check for the ProcedureCode need diagnosis or not 
                               Why:Camino Support Go Live #201 
** 4/7/2017      Hemant     Modified the Hour calculation logic for "Duration does not match DateTimeIn/DateTimeOut." validation. Harbor - Support Task# 1146.1                             
** 5/31/2017	 Gautam		Added LTrim and RTrim to remove the Trailing spaces on ICD 10 Code Service Error
							Why: Philhaven-Support Task#120
	6/15/2017	MJensen		Copy parms to internal variables for parameter sniffing.  
							Thresolds Support 977
6/29/2017		Msood		What: Added condition to check ICD10Code is Not NULL 
							Why: Allegan - Support Task #1068	
08/03/2017      MD Hussain  What: Added condition to check for service completion status for Service Date/Time warnings 
							Why: Key Point - Support Go Live: #1143.2	
07/12/2017	    Gautam      what: added condition for new serviceErrors,if location is non billable defined in CoveragePlanRules & System config key
							why  :Texas - Customizations #112	
04/12/2018     Swatika     What/Why: Added new validation namely "Non-billable service require a signed note to complete."
							Engineering Improvement Initiatives- NBL(I) #709																							
*******************************************************************************/
AS 

	DECLARE		@ParmClientId INT = @ClientId,
				@ParmServiceId INT = @ServiceId ,
				@ParmProcedureCodeId INT = @ProcedureCodeId ,
				@ParmClinicianId INT = @ClinicianId ,
				@ParmStartDate DATETIME = @StartDate,
				@ParmEndDate DATETIME = @EndDate,
				@ParmAttending VARCHAR(10) = @Attending,
				@ParmServiceCompletionStatus VARCHAR(10) = @ServiceCompletionStatus,
				@ParmProgramId INT = @ProgramId ,
				@ParmLocationId INT = @LocationId,
				@ParmDegree INT = @Degree,
				@ParmUnitValue DECIMAL(9, 2) = @UnitValue,
				@ParmPreviousStatus INT = @PreviousStatus

    DECLARE @Count INT  
    DECLARE @ServiceAlreadyCompleted CHAR(1)  
    DECLARE @Billable CHAR(1) ,
        @RateId INT   
    DECLARE @DoesNotRequireStaffForService CHAR(1)
    -- 06/16/2016	 Gautam	
    DECLARE @OverrideCharge CHAR(1)= 'N'
      
    DECLARE @DiagnosisRequiredOnServiceCompletion CHAR(1)
    --JUNE-05-2014 Katta Sharath Kumar
	Select top 1 @DiagnosisRequiredOnServiceCompletion=Value from SystemConfigurationKeys where [Key]='ALWAYSREQUIREDIAGNOSISONSERVICE' AND ISNULL(RecordDeleted,'N')='N'
	IF @DiagnosisRequiredOnServiceCompletion IS NULL
	BEGIN
		SET @DiagnosisRequiredOnServiceCompletion='Y'
	END
    --#############################################################################
    -- Enforcement of ICD10 code availability of Fiscal Year (table: ICD10FiscalYearAvailability)
    --############################################################################# 
    DECLARE @EnforceICD10FiscalYearValidation CHAR(1) = 'Y'


    SELECT @EnforceICD10FiscalYearValidation = Value
        FROM SystemConfigurationKeys SCK
        WHERE [Key] = 'EnforceICD10FiscalYearValidation'
            AND ISNULL(RecordDeleted, 'N') = 'N'
    
    --#############################################################################
    -- end EnforceICD10FiscalYearValidation init
    --############################################################################# 
	
    IF @ParmPreviousStatus IS NULL 
        BEGIN   
            SET @ParmPreviousStatus = 0  
        END  
  
    IF @ParmPreviousStatus = 75
        OR EXISTS ( SELECT  *
                    FROM    Services
                    WHERE   ServiceId = @ParmServiceId
                            AND Status NOT IN ( 70, 71, 75 ) ) 
        BEGIN  
  
            DELETE  FROM serviceErrors
            WHERE   ServiceId = @ParmServiceId  
  
            SELECT  ServiceErrorId ,
                    ServiceId ,
                    CoveragePlanId ,
                    ErrorType ,
                    ErrorSeverity ,
                    ErrorMessage ,
                    NextStep ,
                    RowIdentifier ,
                    CreatedBy ,
                    CreatedDate ,
                    ModifiedBy ,
                    ModifiedDate ,
                    RecordDeleted ,
                    DeletedDate ,
                    DeletedBy
            FROM    ServiceErrors
            WHERE   ServiceId = @ParmServiceId  
  
            RETURN  
  
        END  
   
-- determine if the service has been already completed  
    IF EXISTS ( SELECT  *
                FROM    Charges
                WHERE   ServiceId = @ParmServiceId
                        AND ISNULL(RecordDeleted, 'N') = 'N' ) 
        SET @ServiceAlreadyCompleted = 'Y'  
    ELSE 
        SET @ServiceAlreadyCompleted = 'N'  
  
    DELETE  FROM serviceErrors
    WHERE   ServiceId = @ParmServiceId 

    DECLARE @EffectiveDate DateTime
    SET @RateId = NULL   
-----  Modified By Atul     For Task # 1699     
    DECLARE @UserCode VARCHAR(30)  
    SELECT  @UserCode = ModifiedBy ,
            @Billable = ISNULL(Billable, 'N') ,
            @RateId = ProcedureRateId,
            @EffectiveDate = DateOfService,

            -- 06/16/2016	 Gautam	
            @OverrideCharge = ISNULL(OverrideCharge, 'N') 
    FROM    Services
    WHERE   ServiceId = @ParmServiceId  
  
  
  
    SELECT  @DoesNotRequireStaffForService = DoesNotRequireStaffForService
    FROM    procedurecodes
    WHERE   procedurecodeid = @ParmProcedureCodeId 
    
--Added by Pabitra 3-JAN-2017 
DECLARE @IsDiagnosisRequired CHAR(1)='Y'
IF EXISTS(SELECT 1 From ProcedureCodes  PC Inner Join Services S on
PC.ProcedureCodeId=S.ProcedureCodeId AND S.ServiceId=@ParmServiceId AND 
PC.DoesNotRequireBillingDiagnosis='Y')
BEGIN
SET @IsDiagnosisRequired='N'
END
--End-
    
    
     
  
    IF ( ISNULL(@DoesNotRequireStaffForService, 'N') = 'N' ) 
        BEGIN  
            IF ISNULL(@ParmClinicianId, 0) = 0 --clinician not selected  
                BEGIN   
                    INSERT  INTO serviceErrors
                            ( ServiceId ,
                              ErrorType ,
                              ErrorMessage ,
                              CreatedBy ,
                              ModifiedBy 
                            )
                    VALUES  ( @ParmServiceId ,
                              4401 ,
                              'This code require that a clinician be specified for a service.' ,
                              @UserCode ,
                              @UserCode
                            )  
                END  
        END  
  
-- added on 22 Dec 2006 REF Task #233 by Bhupinder Bajwa  
--SELECT @Billable = isnull(Billable,'N') from Services where ServiceId=@ParmServiceId  -- Commented by Manjit becuase it get in above query on Services
   
-- Added following If condition by ref. of task #2338  
-- If Staff.EHRUser <> 'Y' then a service can be completed even   
-- if that Procedure Code requires a note but no note exists.  
    IF EXISTS ( SELECT  *
                FROM    Staff
                WHERE   StaffId = @ParmClinicianId
                        AND EHRUser = 'Y' )
        AND  -- Modified by Bhupinder Bajwa REF Task #501  
        @ParmServiceCompletionStatus = 'Completed'    --condition added to check status Ref Task #38 by Bhupinder Bajwa  
        AND @ParmPreviousStatus <> 75                     -- Bhupinder Bajwa REF Task # 491 (29 Mar 2007)  
        BEGIN  
  --Check Rule 2 for ProcedureCode   
  --Must have a signed note before completing a service  
            DECLARE @AssociatedNoteId INT  
    
            SELECT  @AssociatedNoteId = d.DocumentCodeID
            FROM    Documents d
                    JOIN DocumentCodes dc ON d.documentcodeid = dc.documentcodeid
                                             AND ISNULL(dc.recorddeleted, 'N') <> 'Y' --#462 Venture Region 3.5
                    JOIN Services s ON s.serviceid = d.serviceid
                                       AND ISNULL(s.recorddeleted, 'N') <> 'Y'
                    JOIN ProcedureCodes p ON s.procedurecodeid = p.procedurecodeid
                                             AND ISNULL(p.recorddeleted, 'N') <> 'Y'
            WHERE   d.serviceid = @ParmServiceId
                    AND (p.RequiresSignedNote = 'Y' or p.RequireSignedNoteForNonBillableService = 'Y')--04/12/2018     Swatika
                    AND ISNULL(d.recorddeleted, 'N') <> 'Y'  
  
            IF @AssociatedNoteId IS NULL 
                BEGIN  
                    SELECT  @AssociatedNoteId = p.AssociatedNoteId
                    FROM    Services s
                            JOIN ProcedureCodes p ON s.procedurecodeid = p.procedurecodeid
                                                     AND ISNULL(p.recorddeleted, 'N') <> 'Y'
                    WHERE   s.serviceid = @ParmServiceId
                            AND (p.RequiresSignedNote = 'Y' or p.RequireSignedNoteForNonBillableService = 'Y')--04/12/2018     Swatika
                            AND ISNULL(s.recorddeleted, 'N') <> 'Y'   
                END  
  
  
            IF @AssociatedNoteId > 0
                AND @Billable = 'Y'      -- condition for Billable added on 22 Dec 2006 REF Task #233 by Bhupinder Bajwa 
                AND exists(Select 1 from  Services s
									JOIN ProcedureCodes p ON s.procedurecodeid = p.procedurecodeid
                                                     AND ISNULL(p.recorddeleted, 'N') <> 'Y'
							WHERE   s.serviceid = @ParmServiceId
                            AND (p.RequiresSignedNote = 'Y' )
                            AND ISNULL(s.recorddeleted, 'N') <> 'Y' )  --04/12/2018     Swatika
                BEGIN  
                    IF NOT EXISTS ( SELECT  *
                                    FROM    documents
                                    WHERE   serviceid = @ParmServiceId
                                            AND status = 22
                                            AND CurrentVersionStatus = 22
                                            AND ISNULL(recorddeleted, 'N') <> 'Y' ) 
                        BEGIN  
                            INSERT  INTO serviceErrors
                                    ( ServiceId ,
                                      ErrorType ,
                                      ErrorMessage ,
                                      CreatedBy ,
                                      ModifiedBy 
                                    )
                            VALUES  ( @ParmServiceId ,
                                      4402 ,
                                      'Must have a signed note before completing a service.' ,
                                      @UserCode ,
                                      @UserCode
                                    )  
                        END  
                END 
              
              IF @AssociatedNoteId > 0
				 AND exists(Select 1 from  Services s
									JOIN ProcedureCodes p ON s.procedurecodeid = p.procedurecodeid
                                                     AND ISNULL(p.recorddeleted, 'N') <> 'Y'
							WHERE   s.serviceid = @ParmServiceId
                            AND p.RequireSignedNoteForNonBillableService = 'Y' 
                            AND ISNULL(s.recorddeleted, 'N') <> 'Y' )  --04/12/2018     Swatika
                BEGIN  
                    IF NOT EXISTS ( SELECT  *
                                    FROM    documents
                                    WHERE   serviceid = @ParmServiceId
                                            AND status = 22
                                            AND CurrentVersionStatus = 22
                                            AND ISNULL(recorddeleted, 'N') <> 'Y' ) 
                        BEGIN  
                            INSERT  INTO serviceErrors
                                    ( ServiceId ,
                                      ErrorType ,
                                      ErrorMessage ,
                                      CreatedBy ,
                                      ModifiedBy 
                                    )
                            VALUES  ( @ParmServiceId ,
                                      4402 ,
                                      'Non-billable service require a signed note to complete.' ,
                                      @UserCode ,
                                      @UserCode
                                    )  
                        END  
                END   
  
        END  
   
    IF @Billable = 'Y'
		--JUNE-05-2014 Katta Sharath Kumar
        AND @ParmServiceCompletionStatus = 'Completed' AND @DiagnosisRequiredOnServiceCompletion='Y'
        --2/12/2016 jcarlson -- allow exclusion of procedure codes from requiring a diagnosis
        AND NOT EXISTS  ( SELECT 1 FROM dbo.ssf_RecodeValuesCurrent('ServiceCompleteDiagnosisExcludeProcedureCodes') AS r
					   WHERE r.IntegerCodeId = @ParmProcedureCodeId
				    )
        BEGIN  
			--OCT-07-2014 Akwinass
            DECLARE @BillingDiagnosisCount INT = 0
            SELECT @BillingDiagnosisCount = COUNT(ServiceDiagnosisId) FROM ServiceDiagnosis WHERE ServiceId = @ParmServiceId AND ISNULL(RecordDeleted,'N')<>'Y'
            IF (ISNULL(@BillingDiagnosisCount, 0) = 0 AND @IsDiagnosisRequired='Y')
                BEGIN                   
                    INSERT  INTO serviceErrors
                            ( ServiceId ,	
                              ErrorType ,
                              ErrorMessage ,
                              CreatedBy ,
                              ModifiedBy  
                            )
                    VALUES  ( @ParmServiceId ,
                              4404 ,
                              'Billing diagnosis required for completing the service.' ,
                              @UserCode ,
                              @UserCode
                            )  
                END
            ELSE IF ISNULL(@BillingDiagnosisCount, 0) <= 8 AND ISNULL(@BillingDiagnosisCount, 0) > 0
                BEGIN
                    DECLARE @OrderCount INT = 0
					SELECT @OrderCount = COUNT(ServiceDiagnosisId) FROM ServiceDiagnosis WHERE ServiceId = @ParmServiceId AND ISNULL([Order],0) > 0 AND ISNULL(RecordDeleted,'N')<>'Y'
					IF ((ISNULL(@BillingDiagnosisCount, 0) <> ISNULL(@OrderCount, 0) OR @OrderCount = 0) AND @IsDiagnosisRequired='Y')
					BEGIN 
						INSERT  INTO serviceErrors
								( ServiceId ,
								  ErrorType ,
								  ErrorMessage ,
								  CreatedBy ,
								  ModifiedBy  
								)
						VALUES  ( @ParmServiceId ,
								  4404 ,
								  'Billing diagnosis order required for completing the service.' ,
								  @UserCode ,
								  @UserCode
								)  
                   END
                END  
           ELSE IF ISNULL(@BillingDiagnosisCount, 0) > 8
                BEGIN 
                    SELECT @BillingDiagnosisCount = COUNT(ServiceDiagnosisId) FROM ServiceDiagnosis WHERE ServiceId = @ParmServiceId AND ISNULL([Order],0) > 0 AND ISNULL(RecordDeleted,'N')<>'Y'                 
                    IF (ISNULL(@BillingDiagnosisCount, 0) < 8  AND @IsDiagnosisRequired='Y')
					BEGIN 
						INSERT  INTO serviceErrors
								( ServiceId ,
								  ErrorType ,
								  ErrorMessage ,
								  CreatedBy ,
								  ModifiedBy  
								)
						VALUES  ( @ParmServiceId ,
								  4404 ,
								  'Billing diagnosis order required for completing the service.' ,
								  @UserCode ,
								  @UserCode
								)  
                    END
                END  
            -- SEP-29-2015  Gautam  
            IF ISNULL(@BillingDiagnosisCount, 0) >0
				BEGIN
					INSERT  INTO serviceErrors
								( ServiceId ,
								  ErrorType ,
								  ErrorMessage ,
								  CreatedBy ,
								  ModifiedBy  
								)
						select @ParmServiceId ,4404 ,ErrorMessage,
								 @UserCode ,@UserCode
						from dbo.ssf_ValidateICD10AdditionalCodes_ServiceDiagnosis(@ParmServiceId)
						Union
						select  @ParmServiceId ,4404 ,ErrorMessage,
								 @UserCode ,@UserCode
						from dbo.ssf_ValidateICD10ExcludeCodes_ServiceDiagnosis(@ParmServiceId)
            --#############################################################################
            -- Check ICD10 validity with respect to Fiscal Year
            --############################################################################# 
                    IF @EnforceICD10FiscalYearValidation = 'Y'
                         AND @EffectiveDate >= '10/1/2015' -- FY16
                        BEGIN
                            DECLARE @FiscalYear INTEGER 
                            SELECT @FiscalYear = YEAR(DATEADD(dd, 92, @EffectiveDate))

                            INSERT INTO ServiceErrors
                                    ( ServiceId
                                    ,ErrorType
                                    ,ErrorMessage
                                    ,CreatedBy
                                    ,ModifiedBy )
                                    SELECT @ParmServiceId
                                        ,   4404
                                        -- Gautam 5/31/2017
                                        ,   'ICD10 Code ''' + Rtrim(Ltrim(SD.ICD10Code)) + ''' is not valid for FY' + CAST(@FiscalYear AS VARCHAR)
                                        ,   @UserCode
                                        ,   @UserCode
                                        FROM ServiceDiagnosis SD
                                              WHERE SD.ServiceId = @ParmServiceId
                                            AND ISNULL(SD.RecordDeleted, 'N') = 'N'
                                            AND SD.ICD10Code IS NOT NULL -- Msood 6/29/2017
                                            AND NOT EXISTS ( SELECT 1
                                                                FROM ICD10FiscalYearAvailability IFYA
                                                                WHERE SD.ICD10Code = IFYA.ICD10Code
                                                                    AND IFYA.CMSFiscalYear = @FiscalYear
                                                                    AND ISNULL(IFYA.RecordDeleted, 'N') = 'N' )


                        END
            --#############################################################################
            -- End ICD0 validity with respect to fiscal year
            --############################################################################# 
				END
        END  
  
--   
-- Check for rate and authorization if the service has not been previously completed  
--  
    IF @ServiceAlreadyCompleted = 'N' 
        BEGIN  
            IF @ParmServiceCompletionStatus = 'Completed'
                AND @Billable = 'Y' 
                BEGIN  
    -- Code added on 04 Dec 2006 Ref Task #145   
    /*
    declare @RateId int  
    set @RateId = null    
    select @RateId = ProcedureRateId from Services where ServiceId = @ParmServiceId  -- Commented by Manjit becuase it get in above query on Services
    */
					-- 06/16/2016	 Gautam	
                    IF ( @RateId IS NULL  and @OverrideCharge = 'N') 
                        BEGIN  
                            INSERT  INTO serviceErrors
                                    ( ServiceId ,
                                      ErrorType ,
                                      ErrorMessage ,
                                      CreatedBy ,
                                      ModifiedBy  
                                    )
                            VALUES  ( @ParmServiceId ,
                                      4403 ,
                                      'Unable to find a matching rate for the selected procedure.' ,
                                      @UserCode ,
                                      @UserCode
                                    )  
                        END  
   
    -- Code added on 02 Jan 2007 REF Task #255  
                    IF ( @RateId IS NOT NULL ) 
                        BEGIN  
                            DECLARE @RateAmt MONEY  
                            SET @RateAmt = 0  
                            SELECT  @RateAmt = Amount
                            FROM    ProcedureRates
                            WHERE   ProcedureRateId = @RateId   
   /*
      if (@RateAmt = 0)  
      begin     
        insert into serviceErrors(ServiceId,ErrorType,ErrorMessage ,CreatedBy,ModifiedBy  )   
               values(@ParmServiceId,4403,'A service that has a $0 rate must be marked as ''Not billable'' in order to complete.',@UserCode,@UserCode)     
      end  */
                        END     
                END  
  
  
  
  -- Check For Authorizations    
            EXEC ssp_PMServiceAuthorizations @CurrentUser = @UserCode, @ServiceId = @ParmServiceId, @ServiceDeleted = 'N'    
    
  -- Check how many coverage plans do not have authorization     
            INSERT  INTO serviceErrors
                    ( ServiceId ,
                      ErrorType ,
                      ErrorMessage ,
                      ErrorSeverity
                    )
                    SELECT  @ParmServiceId ,
                            CASE WHEN d.Status IN ( 71, 75 ) THEN 4406
                                 ELSE 4408
                            END ,
                            CASE WHEN d.Status IN ( 71, 75 ) THEN 'Required authorization missing for '
                                 ELSE 'Authorization for scheduled service missing for '
                            END + +c.DisplayAs + '-' + ISNULL(b.InsuredId, '') ,
                            CASE WHEN @ParmServiceCompletionStatus = 'Completed' THEN 'E'
                                 ELSE 'W'
                            END
                    FROM    ServiceAuthorizations a
                            JOIN ClientCoveragePlans b ON ( a.ClientCoveragePlanId = b.ClientCoveragePlanId )
                            JOIN CoveragePlans c ON ( b.CoveragePlanId = c.CoveragePlanId )
                            JOIN Services d ON ( d.serviceid = a.serviceid )
                    WHERE   a.ServiceId = @ParmServiceId
                            AND ISNULL(a.RecordDeleted, 'N') = 'N'
                            AND ISNULL(d.RecordDeleted, 'N') = 'N'
                            AND a.AuthorizationId IS NULL
                            AND a.AuthorizationRequested = 'N'
                            AND d.status IN ( 70, 71, 75 ) --scheduled, show, complete 
     --and b.NoAuthorizationRequiredOverride = 'Y'    --Added By Anil Ref. Task PM Web Bugs 1710  on 12/6/2012   -- Commented By Rakesh Garg
         
    
            INSERT  INTO serviceErrors
                    ( ServiceId ,
                      ErrorType ,
                      ErrorMessage ,
                      ErrorSeverity
                    )
                    SELECT  @ParmServiceId ,
                            CASE WHEN d.Status IN ( 71, 75 ) THEN 4407
                                 ELSE 4409
                            END ,
                            CASE WHEN d.Status IN ( 71, 75 ) THEN 'Authorization requested but not approved for '
                                 ELSE 'Authorization requested but not approved for scheduled service for '
                            END + +c.DisplayAs + '-' + ISNULL(b.InsuredId, '') ,
                            CASE WHEN @ParmServiceCompletionStatus = 'Completed' THEN 'E'
                                 ELSE 'W'
                            END
                    FROM    ServiceAuthorizations a
                            JOIN ClientCoveragePlans b ON ( a.ClientCoveragePlanId = b.ClientCoveragePlanId )
                            JOIN CoveragePlans c ON ( b.CoveragePlanId = c.CoveragePlanId )
                            JOIN Services d ON ( d.serviceid = a.serviceid )
                    WHERE   a.ServiceId = @ParmServiceId
                            AND ISNULL(a.RecordDeleted, 'N') = 'N'
                            AND ISNULL(d.RecordDeleted, 'N') = 'N'
                            AND a.AuthorizationRequested = 'Y'
                            AND d.status IN ( 70, 71, 75 ) --scheduled, show, complete     
                            AND a.AuthorizationRequested = 'Y'    
  
  
  
-- Code added on 14-Mar-07 (Bhupinder Bajwa) Task # 478  
            IF ( @ParmServiceCompletionStatus = 'Completed' )
                AND @Billable = 'Y' --@Billable added 9/24/2007 SRF  
                BEGIN  
                    DECLARE @InformationComplete CHAR(1)  
                    SELECT  @InformationComplete = ISNULL(InformationComplete, 'N')
                    FROM    Clients
                    WHERE   ClientId = @ParmClientId  
                    IF ( @InformationComplete = 'N' ) 
                        BEGIN  
                            INSERT  INTO serviceErrors
                                    ( ServiceId ,
                                      ErrorType ,
                                      ErrorMessage ,
                                      ErrorSeverity ,
                                      CreatedBy ,
                                      ModifiedBy  
                                    )
                            VALUES  ( @ParmServiceId ,
                                      4410 ,
                                      'Financial information has not been completed for this client.' ,
                                      'E' ,
                                      @UserCode ,
                                      @UserCode
                                    )  
                        END   
                END  
  
        
        END  

-- Make sure duration and units are the same
   IF (@ParmServiceCompletionStatus = 'Completed')  -- Added by MD on 08/03/2017
   BEGIN
    INSERT  INTO ServiceErrors
            ( ServiceId ,
              ErrorType ,
              ErrorMessage
            )
            SELECT  @ParmServiceId ,
                    4411 ,
                    'Duration does not match DateTimeIn/DateTimeOut.'
            FROM    Services s
            WHERE   s.ServiceId = @ParmServiceId
					-- Replace DateTimeOut with EndDateOfService as suggested by Javed
                    AND s.EndDateOfService IS NOT NULL
                    AND s.UnitType in (110,111)  --For Minutes and Hours as suggested by Javed
                    --AND DATEDIFF(MINUTE, s.DateTimeIn, s.DateTimeOut) <> s.Unit	-- Replace DateTimeOut with EndDateOfService as suggested by Javed
                    AND s.Unit <>(case when s.UnitType=110 then cast(DATEDIFF(MINUTE, s.DateOfService, s.EndDateOfService) AS decimal(18,2)) 
									   when s.UnitType=111 then 
									   --Hemant 4/7/2017
									   CAST(CAST((s.EndDateOfService - s.DateOfService) AS FLOAT) * 24.0 AS DECIMAL(18,2))
									   --cast(DATEDIFF(HOUR, s.DateOfService, s.EndDateOfService) AS decimal(18,2)) 
									   --Hemant 4/7/2017
									   end )
                    AND ISNULL(s.RecordDeleted, 'N') = 'N'
  

-- Make sure end date equals start date
    INSERT  INTO ServiceErrors
            ( ServiceId ,
              ErrorType ,
              ErrorMessage
            )
            SELECT  @ParmServiceId ,
                    4412 ,
                    'End Date does not equal Start Date.'
            FROM    Services s
                    JOIN ProcedureCodes pc ON pc.ProcedureCodeId = s.ProcedureCodeId
            WHERE   s.ServiceId = @ParmServiceId
                    AND s.EndDateOfService IS NOT NULL
                    AND s.UnitType in (110,111) --For Minutes and Hours as suggested by Javed
                    AND pc.EndDateEqualsStartDate = 'Y'
                    --Modified on 11/19/2015 by MD Hussain to handle 12:00 AM case
                    --AND CAST(s.DateTimeIn AS DATE) <> CAST(s.DateTimeOut AS DATE)
                    AND CAST(s.DateOfService AS DATE) <> CAST(DATEADD(MINUTE,-1,CAST(s.EndDateOfService AS DATETIME)) AS DATE) 
                    --Changes End-------------------------------
                    AND ISNULL(s.RecordDeleted, 'N') = 'N'
                    AND ISNULL(pc.RecordDeleted, 'N') = 'N'

-- Units cannot be negative
    INSERT  INTO ServiceErrors
            ( ServiceId ,
              ErrorType ,
              ErrorMessage
            )
            SELECT  @ParmServiceId ,
                    4413 ,
                    'Duration cannot be negative.'
            FROM    Services s
            WHERE   s.ServiceId = @ParmServiceId
                    AND s.Unit < 0
                    AND ISNULL(s.RecordDeleted, 'N') = 'N'
  
  -- Service Date/Time does not match Time In/Time Out -- Added this new validation as suggested by Javed

    INSERT  INTO ServiceErrors
            ( ServiceId ,
              ErrorType ,
              ErrorMessage
            )
            SELECT  @ParmServiceId ,
                    4414 ,
                    'Service Date/Time does not match Time In/Time Out.'
            FROM    Services s
            WHERE   s.ServiceId = @ParmServiceId
					AND s.DateTimeIn IS NOT NULL
                    AND s.DateTimeOut IS NOT NULL
                    AND s.UnitType = 110
                    AND (s.DateOfService <> s.DateTimeIn 
						OR s.EndDateOfService <> s.DateTimeOut) 
                    AND ISNULL(s.RecordDeleted, 'N') = 'N'
  
  END
  
 -- Start 07/12/2017  Gautam    
If Exists(SELECT 1 FROM SystemConfigurationKeys where [Key]='EvaluateServiceForNonBillableLocationBillingRule' AND Value='Yes')  
and (@ParmServiceCompletionStatus = 'Completed')   and @Billable='Y'
BEGIN
	DECLARE @CoveragePlanId INT
	DECLARE @PrevClientCoveragePlanId INT
	DECLARE @NextClientCoveragePlanId INT
	DECLARE @BillableFound CHAR(1) = 'N'

	EXEC SSP_PMGETNEXTBILLABLEPAYER @ClientId = @ParmClientId
		,@ServiceId = @ParmServiceId
		,@DateOfService = @ParmStartDate
		,@ProcedureCodeId = @ParmProcedureCodeId
		,@ClinicianId = @ParmClinicianId
		,@ClientCoveragePlanId = NULL
		,@NextClientCoveragePlanId = @NextClientCoveragePlanId OUTPUT

	WHILE ISNULL(@NextClientCoveragePlanId, 0) <> 0
	BEGIN
		SELECT @PrevClientCoveragePlanId = @NextClientCoveragePlanId

		SELECT @BillableFound = 'N'

		SELECT @CoveragePlanId = CoveragePlanId
		FROM ClientCoveragePlans
		WHERE ClientCoveragePlanId = @NextClientCoveragePlanId
			AND ISNULL(RecordDeleted, 'N') = 'N'
		-- Check if non billable locations exists
		IF EXISTS (
				SELECT 1
				FROM ProcedureRates PR
				WHERE PR.ProcedureCodeId = @ParmProcedureCodeId
					AND ISNULL(PR.RecordDeleted, 'N') = 'N'
					AND EXISTS (
						SELECT 1
						FROM CoveragePlanRules CR
						LEFT JOIN CoveragePlanRuleVariables CPR ON CR.CoveragePlanRuleId = CPR.CoveragePlanRuleId
							AND ISNULL(CPR.RecordDeleted, 'N') = 'N'
						WHERE CR.CoveragePlanId = @CoveragePlanId
							AND ISNULL(CR.RecordDeleted, 'N') = 'N'
							AND CR.RuleTypeId = 4280 --non billable locations            
							AND (
								ISNULL(CR.AppliesToAllLocations, 'N') = 'Y'
								OR ISNULL(CPR.AppliesToAllLocations, 'N') = 'Y'
								OR CPR.LocationId = @ParmLocationId
								)
						)
				)
		BEGIN
			SELECT @BillableFound = 'Y'
		END
		-- Find next biallbale ClientCoveragePlanId
		IF @NextClientCoveragePlanId <> 0
		BEGIN
			SELECT @NextClientCoveragePlanId = 0

			EXEC SSP_PMGETNEXTBILLABLEPAYER @ClientId = @ParmClientId
				,@ServiceId = @ParmServiceId
				,@DateOfService = @ParmStartDate
				,@ProcedureCodeId = @ParmProcedureCodeId
				,@ClinicianId = @ParmClinicianId
				,@ClientCoveragePlanId = @PrevClientCoveragePlanId
				,@NextClientCoveragePlanId = @NextClientCoveragePlanId OUTPUT
		END

		IF @BillableFound = 'Y'
			AND isnull(@NextClientCoveragePlanId, 0) = 0
		BEGIN
			INSERT INTO ServiceErrors (
				ServiceId
				,ErrorType
				,ErrorMessage
				)
			SELECT @ParmServiceId
				,4280
				,'Service location is non billable'
			FROM Services s
			WHERE s.ServiceId = @ParmServiceId
				AND ISNULL(s.RecordDeleted, 'N') = 'N'

			UPDATE Services
			SET Billable = 'N' --Uncheck “Billable” box             
				,[Status] = 75 --Service status from Show status to Complete Status            
				,Charge = NULL
				,ProcedureRateId = NULL
			WHERE ServiceId = @ParmServiceId
				AND ISNULL(RecordDeleted, 'N') = 'N'

			SELECT @NextClientCoveragePlanId = 0
		END
		-- If rule does not exists for current plan then bill against this plan and don't show validation 
		IF (
				@BillableFound = 'N'
				AND isnull(@NextClientCoveragePlanId, 0) <> 0
				)
		BEGIN
			SELECT @NextClientCoveragePlanId = 0
		END
	END
END

-- END 07/12/2017  Gautam  
-----------------------------  
--  
-- Call scsp_CheckWarnings  
--  

    EXEC scsp_CheckWarnings @ParmClientId, @ParmServiceId, @ParmProcedureCodeId, @ParmClinicianId, @ParmStartDate, @ParmEndDate, @ParmAttending, @ParmServiceCompletionStatus, @ParmProgramId, @ParmLocationId, @ParmDegree, @ParmUnitValue, @Count, @ServiceAlreadyCompleted, @Billable, @DoesNotRequireStaffForService, @ParmPreviousStatus  
 
    -- Added 10/12/2014 NJain Add On Services creation
    IF NOT EXISTS ( SELECT  *
                    FROM    dbo.ServiceAddOnCodes
                    WHERE   AddOnServiceId = @ParmServiceId )
        AND EXISTS ( SELECT *
                     FROM   Services
                     WHERE  ServiceId = @ParmServiceId
                            AND Status = 75 )                        
        BEGIN
			
            SET NOCOUNT ON
        
            EXEC ssp_SCCreateAddOnServices @ParmServiceId
        END
  
    SELECT  ServiceErrorId ,
            ServiceId ,
            CoveragePlanId ,
            ErrorType ,
            ErrorSeverity ,
            ErrorMessage ,
            NextStep ,
            RowIdentifier ,
            CreatedBy ,
            CreatedDate ,
            ModifiedBy ,
            ModifiedDate ,
            RecordDeleted ,
            DeletedDate ,
            DeletedBy
    FROM    ServiceErrors
    WHERE   ServiceId = @ParmServiceId


GO


