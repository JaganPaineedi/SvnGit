IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCSyncExternalAppointments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCSyncExternalAppointments]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCSyncExternalAppointments]
/********************************************************************************          
-- Stored Procedure: dbo.ssp_SCSyncOutlookAppointment
--          
-- Copyright: 2007 Streamline Healthcate Solutions          
--          
-- Creation Date:    5.18.2012                                                     
--                                                                               
-- Purpose: Sync appointments with outlook          
--          
-- Updates:                                                                 
-- Date				Author			 Purpose          
-- 05.18.2012		Wasif Butt		 Created  - To sync the exchange appointments in queue.            
-- 10.30.2012		Wasif Butt		 modified - To accommodate clinician change and mapping logic
-- 03.12.2012		Wasif Butt		 modified - To exclude old appointments from sync
-- 03.13.2012		Wasif Butt		 modified - To accommodate clinician change through calendar, team scheduling, groups etc
-- 12.12.2013		Wasif Butt		 modified - To accommodate appointment that were deleted before sync could process them etc
-- 06.21.2016		Wasif Butt		 Added	  - To 4.0 thread along with some modifications;
-- 06.21.2016		Wasif Butt		 modified - Remove check for record delete because we need to sync deleted appointments as well
-- 06.21.2016		Wasif Butt		 modified - Added try catch block logic to continue processing in case one appointment sync fails
*********************************************************************************/
AS 
    BEGIN
        CREATE TABLE #Queue
            (
              ExternalAppointmentQueueId INT NOT NULL ,
              AppointmentId INT NULL ,
              Action CHAR(1) NULL ,
              ExternalIdentifier VARCHAR(MAX)
            )
        INSERT  INTO #Queue
                ( ExternalAppointmentQueueId ,
                  AppointmentId ,
                  Action 
                )
                SELECT 
                --TOP 1
                        eaq.ExternalAppointmentQueueId ,
                        eaq.AppointmentId ,
                        eaq.Action 
                FROM    dbo.ExternalAppointmentQueue eaq
                --ORDER BY ExternalAppointmentQueueId DESC
				where isnull(RecordDeleted, 'N') = 'N'
                ORDER BY ExternalAppointmentQueueId ASC

                        -- Select XML:
        DECLARE @ExchangeSettingsXML XML
        SELECT  @ExchangeSettingsXML = dbo.ssf_GetExchangeSettingsXML()                        
        DECLARE @TargetUserEmail VARCHAR(MAX)
        DECLARE @AppointmentXML XML
        DECLARE @RecurrenceXML XML
        DECLARE @RecurrenceOccurenceIndex INT 
        DECLARE @returned VARCHAR(MAX)
        DECLARE @returnedXML XML
        DECLARE @returnedId VARCHAR(MAX)
        DECLARE @StatusType VARCHAR(MAX)
        DECLARE @Today DATETIME = GETDATE()

        WHILE ( SELECT  COUNT(ExternalAppointmentQueueId)
                FROM    #Queue
              ) > 0 
            BEGIN
           -- BEGIN TRANSACTION
           
                UPDATE
                q SET ExternalIdentifier = em.ExternalCode
                FROM #Queue q LEFT JOIN ExternalMappings em ON q.AppointmentId = em.RecordId AND em.Category = 'Appointments' AND ISNULL(em.RecordDeleted, 'N') = 'N' 
                WHERE q.AppointmentId = em.RecordId
           
				--SELECT * FROM #Queue
           
                DECLARE @ExternalAppointmentQueueId INT
                DECLARE @AppointmentId INT
                DECLARE @StaffId INT
                DECLARE @StartTime DATETIME
                DECLARE @EndTime DATETIME
                DECLARE @RecurringAppointmentId INT
                DECLARE @Action CHAR(1)
                DECLARE @ExternalIdentifier VARCHAR(MAX)
                SELECT TOP 1
                        @ExternalAppointmentQueueId = q.ExternalAppointmentQueueId ,
                        @AppointmentId = q.AppointmentId ,
                        @Action = q.Action ,
                        @ExternalIdentifier = q.ExternalIdentifier
                FROM    #Queue q 
				ORDER BY ExternalAppointmentQueueId ASC

				--For testing the values
                --SELECT  @ExternalAppointmentQueueId as ExternalAppointmentQueueId ,
                --        @AppointmentId as AppointmentId ,
                --        @Action as Action ,
                --        @ExternalIdentifier as ExternalIdentifier

                DECLARE @recurring CHAR(1)
                DECLARE @occurence INT
                		
                SELECT  @recurring = RecurringAppointment ,                
                        --@recurring = CASE WHEN ISNULL(RecurringAppointment, 'N') = 'Y' AND RecurringAppointmentId IS NOT NULL
                        --                  THEN RecurringAppointment
                        --             END ,
                        @RecurringAppointmentId = RecurringAppointmentId ,
                        @StartTime = StartTime
                FROM    appointments
                WHERE   AppointmentId = @AppointmentId
						
                --PRINT 'StartTime ' + CONVERT(VARCHAR(10), @StartTime, 101)
                --    + ' Today ' + CONVERT(VARCHAR(10), @Today, 101)
                    
                IF DATEDIFF(day, @Today, @StartTime) >= 0
                    BEGIN
						BEGIN TRY
                        IF ISNULL(@recurring, 'N') = 'N' --Single Appointment
                            BEGIN
                                
                            --is appointment mapped to StaffId already 
                                IF EXISTS ( SELECT  ExternalCode
                                            FROM    ExternalMappings
                                            WHERE   RecordId = @AppointmentId
                                                    AND Category = 'Staff'
                                                    AND ISNULL(RecordDeleted,
                                                              'N') = 'N' ) 
                                    BEGIN
                                        SELECT  @StaffId = CONVERT(INT, ExternalCode)
                                        FROM    ExternalMappings
                                        WHERE   RecordId = @AppointmentId
                                                AND Category = 'Staff'
                                                AND ISNULL(RecordDeleted, 'N') = 'N'
                                        
                                        SELECT  @StartTime = StartTime ,
                                                @EndTime = EndTime
                                        FROM    Appointments a
                                        WHERE   a.AppointmentId = @AppointmentId
                                                
                                        SELECT  @TargetUserEmail = Email
                                        FROM    Staff s
                                        WHERE   s.StaffId = @StaffId

                                    END
                                ELSE 
                                    BEGIN
                                    
                                        SELECT  @StartTime = StartTime ,
                                                @EndTime = EndTime ,
                                                @StaffId = a.StaffId
                                        FROM    Appointments a
                                        WHERE   a.AppointmentId = @AppointmentId
                                                
                                        SELECT  @TargetUserEmail = Email
                                        FROM    Staff s
                                        WHERE   s.StaffId = @StaffId
                                    END
                                
                                
                                
                                SELECT  @AppointmentXML = dbo.ssf_GetAppointmentXML(@AppointmentId)                        
        
					--For testing the values
                                --SELECT  @TargetUserEmail ,
                                --        @StaffId ,
                                --        @AppointmentId ,
                                --        @Action ,
                                --        @AppointmentXML ,
                                --        @ExchangeSettingsXML ,
                                --        @ExternalIdentifier
						                        
                                SELECT  @returned = CASE WHEN @Action = 'I' and @AppointmentId is not null
                                                         THEN dbo.ssf_ExternalCreateSingleAppointment(CAST(@ExchangeSettingsXML AS VARCHAR(MAX)),
                                                              @TargetUserEmail,
                                                              CAST(@AppointmentXML AS VARCHAR(MAX)))
                                                         WHEN @Action = 'U' and @AppointmentId is not null and @ExternalIdentifier is not null 
                                                         THEN dbo.ssf_ExternalUpdateSingleAppointment(CAST(@ExchangeSettingsXML AS VARCHAR(MAX)),
                                                              @TargetUserEmail,
                                                              @ExternalIdentifier,
                                                              CAST(@AppointmentXML AS VARCHAR(MAX)))
                                                         WHEN @Action = 'D' and @AppointmentId is not null and @ExternalIdentifier is not null 
                                                         THEN dbo.ssf_ExternalDeleteSingleAppointment(CAST(@ExchangeSettingsXML AS VARCHAR(MAX)),
                                                              @TargetUserEmail,
                                                              @ExternalIdentifier)
                                                         ELSE 'Error'
                                                    END     
                            END							
                        ELSE		--Recurring Appointment
                            BEGIN 
                            
                            --is appointment mapped to StaffId already 
                                IF EXISTS ( SELECT  ExternalCode
                                            FROM    ExternalMappings
                                            WHERE   RecordId = @AppointmentId
                                                    AND Category = 'Staff'
                                                    AND ISNULL(RecordDeleted,
                                                              'N') = 'N' ) 
                                    BEGIN
                                        SELECT  @StaffId = CONVERT(INT, ExternalCode)
                                        FROM    ExternalMappings
                                        WHERE   RecordId = @AppointmentId
                                                AND Category = 'Staff'
                                                AND ISNULL(RecordDeleted, 'N') = 'N'
                                        
                                        SELECT  @StartTime = StartTime ,
                                                @EndTime = EndTime ,
                                                @RecurrenceOccurenceIndex = a.RecurringOccurrenceIndex
                                        FROM    Appointments a
                                        WHERE   a.AppointmentId = @AppointmentId
                                                
                                        SELECT  @TargetUserEmail = Email
                                        FROM    Staff s
                                        WHERE   s.StaffId = @StaffId
                                    END
                                ELSE 
                                    BEGIN
                                        SELECT  @StartTime = StartTime ,
                                                @EndTime = EndTime ,
                                                @StaffId = a.StaffId ,
                                                @RecurrenceOccurenceIndex = a.RecurringOccurrenceIndex
                                        FROM    Appointments a
                                        WHERE   a.AppointmentId = @AppointmentId
                                                
                                        SELECT  @TargetUserEmail = Email
                                        FROM    Staff s
                                        WHERE   s.StaffId = @StaffId
                                    END
                                
                                SELECT  @AppointmentXML = dbo.ssf_GetAppointmentXML(@AppointmentId)                        
                                SELECT  @RecurrenceXML = dbo.ssf_GetRecurrenceXML(@AppointmentId)                        
        
					--		For testing the values
				    --      SELECT  @TargetUserEmail ,
				    --      @AppointmentXML ,
				    --      @ExchangeSettingsXML
					
					--AppointmentId Inserted, Updated or Deleted is Master Appointment
                                IF EXISTS ( SELECT  RecurringAppointmentId
                                            FROM    dbo.RecurringAppointments
                                            WHERE   AppointmentId = @AppointmentId ) 
                                    BEGIN
                                        SELECT  @returned = CASE
                                                              WHEN @Action = 'I' and @AppointmentId is not null
                                                              THEN dbo.ssf_ExternalCreateRecurringAppointment(CAST(@ExchangeSettingsXML AS VARCHAR(MAX)),
                                                              @TargetUserEmail,
                                                              CAST(@AppointmentXML AS VARCHAR(MAX)),
                                                              CAST(@RecurrenceXML AS VARCHAR(MAX)))
                                                              WHEN @Action = 'U' and @AppointmentId is not null and @ExternalIdentifier is not null 
                                                              THEN dbo.ssf_ExternalUpdateRecurringAppointment(CAST(@ExchangeSettingsXML AS VARCHAR(MAX)),
                                                              @TargetUserEmail,
                                                              @ExternalIdentifier,
                                                              CAST(@AppointmentXML AS VARCHAR(MAX)),
                                                              CAST(@RecurrenceXML AS VARCHAR(MAX)))
                                                              WHEN @Action = 'D' and @AppointmentId is not null and @ExternalIdentifier is not null 
                                                              THEN dbo.ssf_ExternalDeleteRecurringAppointment(CAST(@ExchangeSettingsXML AS VARCHAR(MAX)),
                                                              @TargetUserEmail,
                                                              @ExternalIdentifier)
                                                              ELSE 'Error'
                                                            END
                                    END	                        
                                ELSE -- AppointmentId Inserted, Updated or Deleted is an exception (not master appointment)
                                    BEGIN
                                        SELECT  @ExternalIdentifier = ExternalCode
                                        FROM    dbo.ExternalMappings
                                        WHERE   Category = 'Appointments'
                                                AND RecordId = ( SELECT TOP 1
                                                              AppointmentId
                                                              FROM
                                                              dbo.RecurringAppointments
                                                              WHERE
                                                              RecurringAppointmentId = @RecurringAppointmentId
                                                              )
                                        SELECT  @returned = CASE
                                                              WHEN (@Action = 'I' and @AppointmentId is not null)
                                                              OR (@Action = 'U' and @AppointmentId is not null and @ExternalIdentifier is not null) 
                                                              THEN dbo.ssf_ExternalUpdateExceptionAppointment(CAST(@ExchangeSettingsXML AS VARCHAR(MAX)),
                                                              @TargetUserEmail,
                                                              @ExternalIdentifier,
                                                              @RecurrenceOccurenceIndex,
                                                              CAST(@AppointmentXML AS VARCHAR(MAX)))
                                                              WHEN @Action = 'D' and @AppointmentId is not null and @ExternalIdentifier is not null 
                                                              THEN dbo.ssf_ExternalDeleteExceptionAppointment(CAST(@ExchangeSettingsXML AS VARCHAR(MAX)),
                                                              @TargetUserEmail,
                                                              @ExternalIdentifier,
                                                              @RecurrenceOccurenceIndex)
                                                              ELSE 'Error'
                                                            END
                                    END									
                            END
                                
                        SET @returnedXML = CAST(@returned AS XML)

                        SELECT  @returnedXML
                        SELECT  @StatusType = T.c.value('.', 'VARCHAR(max)')
                        FROM    @returnedXML.nodes('/ExchangeAPIOutput/StatusType') T ( c )
                     END TRY
					 BEGIN CATCH
					 SET @StatusType = NULL
					 END CATCH
                    END
                ELSE 
                    SELECT  @StatusType = NULL
                    
                    --PRINT 'StatusType ' + @StatusType
                    
                IF @StatusType IS NOT NULL 
                    BEGIN
                        UPDATE  ExternalAppointmentQueue
                        SET     ExternalIdentifier = T.c.value('.',
                                                              'VARCHAR(max)')
                        FROM    @returnedXML.nodes('/ExchangeAPIOutput/ExchangeItemID') T ( c )
                        WHERE   ExternalAppointmentQueueId = @ExternalAppointmentQueueId
                                
                                
                        UPDATE  ExternalAppointmentQueue
                        SET     ErrorMessage = T.c.value('.', 'VARCHAR(max)')
                        FROM    @returnedXML.nodes('/ExchangeAPIOutput/StatusMessage') T ( c )
                        WHERE   ExternalAppointmentQueueId = @ExternalAppointmentQueueId
                        
                        
                        INSERT  INTO dbo.ExternalAppointmentArchive
                                ( CreatedBy ,
                                  CreatedDate ,
                                  ModifiedBy ,
                                  ModifiedDate ,
                                  AppointmentId ,
                                  Action ,
                                  ExternalIdentifier ,
                                  ExternalInterfaceCallParameters ,
                                  ErrorMessage ,
                                  StaffId ,
                                  StartTime ,
                                  EndTime
                                        
                                )
                                SELECT  CreatedBy ,
                                        CreatedDate ,
                                        ModifiedBy ,
                                        ModifiedDate ,
                                        AppointmentId ,
                                        Action ,
                                        ExternalIdentifier ,
                                        ExternalInterfaceCallParameters ,
                                        ErrorMessage ,
                                        @StaffId ,
                                        @StartTime ,
                                        @EndTime
                                FROM    dbo.ExternalAppointmentQueue
                                WHERE   ExternalAppointmentQueueId = @ExternalAppointmentQueueId

                        IF ( @Action = 'I'
                             OR @Action = 'U'
                           )
                            AND @StatusType <> 'Error' 
                            BEGIN
                                UPDATE  dbo.ExternalMappings
                                SET     RecordDeleted = 'Y'
                                WHERE   RecordId = @AppointmentId
                                        AND TableName = 'Appointments'
                                        AND ( Category = 'Appointments'
                                              OR Category = 'Staff'
                                            )
                                --PRINT CONVERT(VARCHAR(MAX), @AppointmentId)
                                INSERT  INTO dbo.ExternalMappings
                                        ( CreatedBy ,
                                          CreatedDate ,
                                          ModifiedBy ,
                                          ModifiedDate ,
                                          Purpose ,
                                          Category ,
                                          TableName ,
                                          RecordId ,
                                          ExternalCode ,
                                          ExternalCodeDescription
                                                
                                                
                                        )
                                        SELECT  CreatedBy ,
                                                CreatedDate ,
                                                ModifiedBy ,
                                                ModifiedDate ,
                                                'Map External Appointments' ,
                                                'Appointments' ,
                                                'Appointments' ,
                                                @AppointmentId ,
                                                ExternalIdentifier ,
                                                'External Id'
                                        FROM    dbo.ExternalAppointmentQueue
                                        WHERE   ExternalAppointmentQueueId = @ExternalAppointmentQueueId
                                --PRINT CONVERT(VARCHAR(MAX), @StaffId)
                                INSERT  INTO dbo.ExternalMappings
                                        ( CreatedBy ,
                                          CreatedDate ,
                                          ModifiedBy ,
                                          ModifiedDate ,
                                          Purpose ,
                                          Category ,
                                          TableName ,
                                          RecordId ,
                                          ExternalCode ,
                                          ExternalCodeDescription
                                        )
                                        SELECT  CreatedBy ,
                                                CreatedDate ,
                                                ModifiedBy ,
                                                ModifiedDate ,
                                                'Map External Staff' ,
                                                'Staff' ,
                                                'Appointments' ,
                                                @AppointmentId ,
                                                CONVERT(VARCHAR(MAX), @StaffId) ,
                                                'External Appointment Staff'
                                        FROM    dbo.ExternalAppointmentQueue
                                        WHERE   ExternalAppointmentQueueId = @ExternalAppointmentQueueId
                            END
                        ELSE 
                            IF @Action = 'D'
                                AND @StatusType <> 'Error' 
                                BEGIN
                                    UPDATE  dbo.ExternalMappings
                                    SET     RecordDeleted = 'Y'
                                    WHERE   RecordId = @AppointmentId
                                            AND TableName = 'Appointments'
                                            AND ( Category = 'Appointments'
                                                  OR Category = 'Staff'
                                                )
                                END                                      
                        DELETE  FROM dbo.ExternalAppointmentQueue
                        WHERE   ExternalAppointmentQueueId = @ExternalAppointmentQueueId
                    END
                ELSE 
                    BEGIN           
                    
                        --PRINT 'Sync Skipped For Past Date Or No Status Message Returned From Exchange Webservice API'
                        
                        if @AppointmentId is null 
                            begin                             
                                update  ExternalAppointmentQueue
                                set     ErrorMessage = 'Sync Skipped as Appointment was deleted or does not exist in Appointments table any more.'
                                where   ExternalAppointmentQueueId = @ExternalAppointmentQueueId
                            end 
                        else 
                            if @ExternalIdentifier is null 
                                begin                             
                                    update  ExternalAppointmentQueue
                                set     ErrorMessage = 'Sync Skipped as ExternalIdentifier is missing.'
                                    where   ExternalAppointmentQueueId = @ExternalAppointmentQueueId
                                end 
                            else 
                                begin                             
                                    update  ExternalAppointmentQueue
                                    set     ErrorMessage = 'Sync Skipped For Past Date Or No Status Message Returned From Exchange Webservice API'
                                    where   ExternalAppointmentQueueId = @ExternalAppointmentQueueId
                                end 
                        
                        INSERT  INTO dbo.ExternalAppointmentArchive
                                ( CreatedBy ,
                                  CreatedDate ,
                                  ModifiedBy ,
                                  ModifiedDate ,
                                  AppointmentId ,
                                  Action ,
                                  ExternalIdentifier ,
                                  ExternalInterfaceCallParameters ,
                                  ErrorMessage ,
                                  StaffId ,
                                  StartTime ,
                                  EndTime
                                )
                                SELECT  CreatedBy ,
                                        CreatedDate ,
                                        ModifiedBy ,
                                        ModifiedDate ,
                                        AppointmentId ,
                                        Action ,
                                        ExternalIdentifier ,
                                        ExternalInterfaceCallParameters ,
                                        ErrorMessage ,
                                        @StaffId ,
                                        @StartTime ,
                                        @EndTime
                                FROM    dbo.ExternalAppointmentQueue
                                WHERE   ExternalAppointmentQueueId = @ExternalAppointmentQueueId
                        DELETE  FROM dbo.ExternalAppointmentQueue
                        WHERE   ExternalAppointmentQueueId = @ExternalAppointmentQueueId

                    END
                DELETE  FROM #Queue
                WHERE   ExternalAppointmentQueueId = @ExternalAppointmentQueueId
        --COMMIT TRANSACTION
            END
        DROP TABLE #Queue
    END





GO


