/****** Object:  StoredProcedure [dbo].[ssp_SCWEBDeleteAppointment]    Script Date: 06/21/2015 18:49:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[ssp_SCWEBDeleteAppointment]
    @UserId VARCHAR(30) ,
    @AppointmentId INT = NULL ,
    @RecurringAppointmentId INT = NULL ,
    @RecurringAppointmentExceptionId INT = NULL ,
    @OccurenceOrSeries CHAR(1) = 'S' , -- 'O' - occurence, 'S' - series          
    @ExceptionDate DATETIME = NULL          
/********************************************************************************          
-- Stored Procedure: dbo.ssp_PMDeleteAppointment            
--          
-- Copyright: 2007 Streamline Healthcate Solutions          
--          
-- Creation Date:    10.20.2007                                                     
--                                                                               
-- Purpose: Deletes appointment          
--          
-- Updates:                                                                 
-- Date        Author      Purpose          
-- 10.20.2007  SFarber     Created.            
--  Modified Date : 12.12.2007        
--  Purpose : To set Appointment Id =null on deletion of Exception Occurence        
--	6/21/2015		njain		Added validations scsp Philhaven Set up #83

*********************************************************************************/
AS
    DECLARE @DeletedDate DATETIME          
          
    SET @DeletedDate = GETDATE()          

    DECLARE @CurrentUserId INT
	
    DECLARE @StaffId INT
	
    DECLARE @ValidationStatus INT = 0
    DECLARE @ValidationMessage VARCHAR(MAX)
	
    SELECT  @CurrentUserId = StaffId
    FROM    dbo.Staff
    WHERE   UserCode = @UserId
            AND Active = 'Y'
            AND ISNULL(RecordDeleted, 'N') = 'N'
	
	
    SELECT  @StaffId = StaffId
    FROM    dbo.Appointments
    WHERE   AppointmentId = @AppointmentId
	
	
    BEGIN TRAN

          
    IF @RecurringAppointmentId IS NULL -- Individual appointment          
        BEGIN          
            UPDATE  a
            SET     RecordDeleted = 'Y' ,
                    DeletedBy = @UserId ,
                    DeletedDate = @DeletedDate
            FROM    Appointments a
            WHERE   AppointmentId = @AppointmentId          
          
            IF @@error <> 0
                GOTO error          
        END          
    ELSE -- Recurring Appointment           
        BEGIN          
            IF @OccurenceOrSeries = 'S'
                BEGIN          
                    UPDATE  ra
                    SET     RecordDeleted = 'Y' ,
                            DeletedBy = @UserId ,
                            DeletedDate = @DeletedDate
                    FROM    RecurringAppointments ra
                    WHERE   RecurringAppointmentId = @RecurringAppointmentId          
          
                    IF @@error <> 0
                        GOTO error          
          
                    UPDATE  a
                    SET     RecordDeleted = 'Y' ,
                            DeletedBy = @UserId ,
                            DeletedDate = @DeletedDate
                    FROM    Appointments a
                            JOIN RecurringAppointments ra ON ra.AppointmentId = a.AppointmentId
                    WHERE   ra.RecurringAppointmentId = @RecurringAppointmentId          
          
                    IF @@error <> 0
                        GOTO error          
          
                    UPDATE  rae
                    SET     RecordDeleted = 'Y' ,
                            DeletedBy = @UserId ,
                            DeletedDate = @DeletedDate
                    FROM    RecurringAppointmentExceptions rae
                            JOIN RecurringAppointments ra ON ra.RecurringAppointmentId = rae.RecurringAppointmentId
                    WHERE   ra.RecurringAppointmentId = @RecurringAppointmentId          
          
                    IF @@error <> 0
                        GOTO error          
          
    -- Logically delete all exception appointments and physically delete the rest          
                    UPDATE  a
                    SET     RecordDeleted = 'Y' ,
                            DeletedBy = @UserId ,
                            DeletedDate = @DeletedDate
                    FROM    Appointments a
                            JOIN RecurringAppointmentExceptions rae ON rae.AppointmentId = a.AppointmentId
                    WHERE   rae.RecurringAppointmentId = @RecurringAppointmentId          
          
                    IF @@error <> 0
                        GOTO error          
          
                    DELETE  a
                    FROM    Appointments a
                    WHERE   RecurringAppointmentId = @RecurringAppointmentId
                            AND ISNULL(RecordDeleted, 'N') <> 'Y'          
          
                    IF @@error <> 0
                        GOTO error          
                END          
            ELSE -- Occurence          
                BEGIN          
                    IF @RecurringAppointmentExceptionId IS NOT NULL
                        BEGIN          
                            UPDATE  rae
                            SET     AppointmentDeleted = 'Y' ,
                                    AppointmentId = NULL , -- Modified By Balvinder to insert null on Deletion of Exception Recurrence        
                                    ModifiedBy = @UserId ,
                                    ModifiedDate = @DeletedDate
                            FROM    RecurringAppointmentExceptions rae
                            WHERE   rae.RecurringAppointmentExceptionId = @RecurringAppointmentExceptionId          
          
                            IF @@error <> 0
                                GOTO error          
                        END          
                    ELSE
                        BEGIN          
                            INSERT  INTO RecurringAppointmentExceptions
                                    ( RecurringAppointmentId ,
                                      ExceptionDate ,
                                      AppointmentDeleted ,
                                      CreatedBy ,
                                      CreatedDate ,
                                      ModifiedBy ,
                                      ModifiedDate
                                    )
                                    SELECT  @RecurringAppointmentId ,
                                            @ExceptionDate ,
                                            'Y' ,
                                            @UserId ,
                                            @DeletedDate ,
                                            @UserId ,
                                            @DeletedDate          
          
                            IF @@error <> 0
                                GOTO error          
                        END          
          
                    IF @AppointmentId IS NOT NULL
                        BEGIN          
                            UPDATE  a
                            SET     RecordDeleted = 'Y' ,
                                    DeletedBy = @UserId ,
                                    DeletedDate = @DeletedDate
                            FROM    Appointments a
                            WHERE   a.RecurringAppointmentId = @RecurringAppointmentId
                                    AND StartTime = @ExceptionDate         
               
                            IF @@error <> 0
                                GOTO error          
                        END               
                END          
        END          
          
	
    IF NOT EXISTS ( SELECT  *
                    FROM    sys.procedures
                    WHERE   name = 'scsp_SCValidateDeleteAppointment' )
        BEGIN
	
            COMMIT TRAN
	
        END
	
    IF EXISTS ( SELECT  *
                FROM    sys.procedures
                WHERE   name = 'scsp_SCValidateDeleteAppointment' )
        BEGIN
	
	
            EXEC scsp_SCValidateDeleteAppointment @CurrentUserId, @StaffId, @AppointmentId, @ValidationStatus OUTPUT, @ValidationMessage OUTPUT	

			
            
            IF @ValidationStatus = 1
                BEGIN
            
                    GOTO error 
                    --ROLLBACK TRAN
                    --PRINT @@error
                    
            
                END 		
            
            IF @ValidationStatus = 0
                BEGIN
            
                    COMMIT TRAN
            
                END

        END          
        
          
    RETURN          
          
    error:          
--Added by vishant to implement message code functionality 
    DECLARE @ErrorMessage NVARCHAR(MAX)
    SELECT  @ErrorMessage = dbo.Ssf_GetMesageByMessageCode(29, 'FAILEDEXC_ssp_PMDeleteAppointment_SSP', 'Failed to execute ssp_PMDeleteAppointment')          
--raiserror('Failed to execute ssp_PMDeleteAppointment', 16, 1)
    IF ISNULL(@ValidationMessage, '') <> ''
        BEGIN
            SELECT  @ErrorMessage = @ValidationMessage
        END
    
    RAISERROR(@ErrorMessage, 16, 1)
    ROLLBACK TRAN

GO
