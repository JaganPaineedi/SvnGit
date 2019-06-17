IF EXISTS ( SELECT
                    *
                FROM
                    sys.objects
                WHERE
                    object_id = OBJECT_ID(N'[dbo].[ssp_PMServiceComplete]')
                    AND type IN ( N'P' , N'PC' ) )
    DROP PROCEDURE [dbo].[ssp_PMServiceComplete];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE PROCEDURE [dbo].[ssp_PMServiceComplete]
    @UserCode VARCHAR(30) ,
    @ServiceId INT ,
    @ServiceCompleted CHAR(1) OUTPUT
AS /*********************************************************************/  
/* Stored Procedure: dbo.ssp_PMServiceComplete                         */  
/* Creation Date:    9/25/06                                         */  
/*                                                                   */  
/* Purpose:           */  
/*                                                                   *//* Input Parameters:           */  
/*                                                                   */  
/* Output Parameters:                                                */  
/*                                                                   */  
/* Return Status:                                                    */  
/*                                                                   */  
/* Called By:       */  
/*                                                                   */  
/* Calls:                                                            */  
/*                                                                   */  
/* Data Modifications:                                               */  
/*                                                                   */  
/* Updates:                                                          */  
/*   Date        Author      Purpose                                    */  
/*  9/25/06      JHB   Created   */  
/* 2/14/08      SRF   Changed logic to check if service is billable not procedure           */  
/* OCT-08-2014  Akwinass  Removed the variable @DSMCode1,@DSMCode2,@DSMCode3 and Modified the Billing Diagnosis Validation Based on @ServiceId (Task #134 in Engineering Improvement Initiatives- NBL(I))*/  
/*16/Sep/2016	Gautam		Added code to not throw error if @OverrideCharge exists in Services. For OverrideCharge , 
							Rate may not exists.,Bradford - Support Go Live: #196 HL7: services created from HL 7 are not completing */
/* 06/Oct/2016  jcarlson	   added in modifiers 1- 4 when calling ssp_PMServiceCalculateCharge, to take into account modifiers in procedure rate selection*/
/*16/Feb/2017   Lakshmi        Added RecordDeleted check to the serviceerrors table, as per the task CEI - Support Go Live #555*/
/*********************************************************************/  
  
    DECLARE @OverrideCharge CHAR(1)= 'N';  --16/Sep/2016	Gautam
        
    CREATE TABLE #ServiceErrors
        (
          ServiceErrorId INT NULL ,
          ServiceId INT NULL ,
          CoveragePlanId INT NULL ,
          ErrorType INT NULL ,
          ErrorSeverity CHAR(1) NULL ,
          ErrorMessage VARCHAR(1000) NULL ,
          NextStep INT NULL ,
          RowIdentifier UNIQUEIDENTIFIER NULL ,
          CreatedBy VARCHAR(30) NULL ,
          CreatedDate DATETIME NULL ,
          ModifiedBy VARCHAR(30) NULL ,
          ModifiedDate DATETIME NULL ,
          RecordDeleted CHAR(1) NULL ,
          DeletedDate DATETIME NULL ,
          DeletedBy VARCHAR(30) NULL
        );  
  
    DECLARE
        @ClientId INT ,
        @ProcedureCodeId INT ,
        @ClinicianId INT ,
        @StartDate DATETIME ,
        @EndDate DATETIME ,
        @Attending VARCHAR(10) ,
        @ServiceCompletionStatus VARCHAR(10) ,
        @ProgramId INT ,
        @LocationId INT ,
        @Degree INT ,
        @UnitValue DECIMAL(9 , 2) ,
        @ProcedureRateId INT ,
        @Charge MONEY ,
        @Billable CHAR(1) ,
        @ModifierId1 INT ,
        @ModifierId2 INT ,
        @ModifierId3 INT ,
        @ModifierId4 INT; 
  
  
    DECLARE @CurrentDate SMALLDATETIME;  
  
    SET @CurrentDate = GETDATE();  
    SET @ServiceCompleted = NULL;  
  
    SET @ServiceCompletionStatus = 'Completed';  
  
    SELECT
            @ClientId = a.ClientId ,
            @ProcedureCodeId = a.ProcedureCodeId ,
            @ClinicianId = a.ClinicianId ,
            @StartDate = a.DateOfService ,
            @EndDate = a.EndDateOfService ,
            @Attending = a.AttendingId ,
            @ProgramId = a.ProgramId ,
            @LocationId = a.LocationId ,
            @Degree = b.Degree ,
            @UnitValue = a.Unit ,
            @ProcedureRateId = ProcedureRateId ,
            @Charge = a.Charge ,
            @Billable = a.Billable ,
            @OverrideCharge = ISNULL(a.OverrideCharge , 'N') , --16/Sep/2016	Gautam
            @ModifierId1 = a.ModifierId1 ,
            @ModifierId2 = a.ModifierId2 ,
            @ModifierId3 = a.ModifierId3 ,
            @ModifierId4 = a.ModifierId4
        FROM
            Services a
        JOIN Staff b ON ( a.ClinicianId = b.StaffId )
        JOIN ProcedureCodes c ON ( a.ProcedureCodeId = c.ProcedureCodeId )
        WHERE
            a.ServiceId = @ServiceId;  
  
    IF @@error <> 0
        GOTO error;  
  
--if @ProcedureRateId is null or @Charge is null  
--begin  
 -- srf 10/3/2007 Charge should be re-calculated everytime the service set to complete  
    IF @OverrideCharge = 'N'  --16/Sep/2016	Gautam
        BEGIN
            EXEC ssp_PMServiceCalculateCharge @ClientId = @ClientId , @DateOfService = @StartDate , @ClinicianId = @ClinicianId ,
                @ProcedureCodeId = @ProcedureCodeId , @Units = @UnitValue , @ProgramId = @ProgramId , @LocationId = @LocationId ,
                @ProcedureRateId = @ProcedureRateId OUTPUT , @Charge = @Charge OUTPUT , @ModifierId1 = @ModifierId1 , @ModifierId2 = @ModifierId2 ,
                @ModifierId3 = @ModifierId3 , @ModifierId4 = @ModifierId4;  
        END;  

    IF @@error <> 0
        GOTO error;  
--end  
  
  
    BEGIN TRAN;  
  
    IF @@error <> 0
        GOTO error;  
  
-- Mark Service as Complete  
    UPDATE
            Services
        SET
            status = 75 ,
            ProcedureRateId = @ProcedureRateId ,
            Charge = @Charge ,
            ModifiedBy = @UserCode ,
            ModifiedDate = @CurrentDate
        WHERE
            ServiceId = @ServiceId;  
  
    IF @@error <> 0
        GOTO error;  
  
-- Check Warnings  
    INSERT INTO #ServiceErrors
            EXEC ssp_CheckWarnings @ClientId = @ClientId , @ServiceId = @ServiceId , @ProcedureCodeId = @ProcedureCodeId , @ClinicianId = @ClinicianId ,
                @StartDate = @StartDate , @EndDate = @EndDate , @Attending = @Attending , @ServiceCompletionStatus = @ServiceCompletionStatus ,
                @ProgramId = @ProgramId , @LocationId = @LocationId , @Degree = @Degree , @UnitValue = @UnitValue , @PreviousStatus = 71;  
   
  
    IF @@error <> 0
        GOTO error;  
  
-- If there are errors set the service status back to show.  
    IF EXISTS ( SELECT
                        *
                    FROM
                        ServiceErrors
                    WHERE
                        ServiceId = @ServiceId
                        AND ErrorSeverity = 'E' AND ISNULL(RecordDeleted,'N')='N' ) --16/Feb/2017 Lakshmi 
        BEGIN  
            UPDATE
                    Services
                SET
                    status = 71 ,
                    ModifiedBy = @UserCode ,
                    ModifiedDate = @CurrentDate
                WHERE
                    ServiceId = @ServiceId;  
  
            IF @@error <> 0
                GOTO error;  
  
            EXEC ssp_PMServiceAuthorizations @UserCode , @ServiceId;  
  
            IF @@error <> 0
                GOTO error;  
  
            COMMIT TRAN;  
  
            IF @@error <> 0
                GOTO error;  
  
            RETURN;  
        END;  
  
-- Create Charge for billable procedure codes  
    IF ( ISNULL(@Billable , 'N') = 'Y' )
        BEGIN  
            EXEC ssp_PMCreateInitialCharge @UserCode = @UserCode , @ServiceId = @ServiceId;  
  
            IF @@error <> 0
                GOTO error;  
        END;  
  
    COMMIT TRAN;  
  
    IF @@error <> 0
        GOTO error;  
  
    SET @ServiceCompleted = 'Y';  
  
    RETURN;  
  
    error:  
  
    IF @@trancount > 0
        ROLLBACK TRAN;  
  