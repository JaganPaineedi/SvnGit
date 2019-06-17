
IF EXISTS ( SELECT
                    *
                FROM
                    sys.objects
                WHERE
                    object_id = OBJECT_ID(N'ssp_AppointmentLogsForExternalAppointments')
                    AND type IN ( N'P' , N'PC' ) )
    BEGIN 
        DROP PROCEDURE ssp_AppointmentLogsForExternalAppointments; 
    END;
                    GO
SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO


CREATE PROC ssp_AppointmentLogsForExternalAppointments
    (
      @AppointmentId INT = NULL ,
      @Action CHAR(1) = NULL ,
      @LoggedInUser VARCHAR(30)
    )
AS /******************************************************************************                                            
**  File:                                             
**  Name: ssp_AppointmentLogsForExternalAppointments                                            
**  Desc: This storeProcedure will executed for loging the appointement table update
**  
**  Parameters:   
**  Input   @@AppointmentId INT
	,@Action char(1)
**  Output     ----------       -----------   
**    
**  Auth:  Sudhir Singh  
**  Date:  may 2, 2012  
*******************************************************************************   
**  Change History    
*******************************************************************************   
**  Date:  Author:    Description:   
**  --------  --------    -------------------------------------------   
**    5-31-2012		Wasif Butt		Added insert for single and recurring appointments 
**    6-07-2012		Sudhir Singh	Updated to check the status of group service [dbo].[SCGetGroupServiceStatus](@GroupserviceID)this done in previous version  
**	  7/18/2012		Wasif Butt		Removed the logic of LoggedInUser from sp and added to application.
**    20Sept2012	Shifali			Modified - Rectified IF/ELSE Block as in case of individual service note, in case of updation,no queue record was being	inserted
**	  11/30/2012	Wasif Butt		Modified - Rectified Update logic for clinician change and remove sync for past appointments
**   10/03/2016     jcarlson			added logic to handle the deletion of recurring appointments that are not the master appointment Pathway SGL 265
**	 12/26/2017		jcarlson		Pathway SGL 265 - 
									Scenario
										1) Create an appointment
										2) Before the above appointment is synced, delete the appointment
										....
										3) The original record in ExternalAppointmentQueue to create the appointment in Outlook is still there but since it has not been synced the Delete record is not placed in queue
										3a) This causes a deleted ( in smartcare ) appointment to be created and never removed
									Solutions
										If a delete is going to be inserted and an I exist for that record in the QUEUE, do not insert the Delete. Remove the and archive the I from QUEUE
									When finding the master appointment Id do not limit based on recurrence index, this was preventing the first occurance from being removed from outlook calendar
*******************************************************************************/   
    BEGIN	

        DECLARE
            @ServiceId INT ,
            @GroupServiceId INT ,
            @StaffId INT = 0 ,
            @StartTime DATETIME ,
            @PreviousStaffId INT = 0 ,
            @PreviousStartTime DATETIME = GETDATE() ,
            @PreviouslySynced BIT = 0 ,
		  -------used for recurring appointment records for deletion
            @MasterAppointmentId INT ,
            @RecurringAppointment type_YOrN ,
            @RecurringOccurrenceIndex INT; 

		

        
        SELECT
                @ServiceId = ServiceId ,
                @GroupServiceId = GroupServiceId ,
                @StaffId = StaffId ,
                @StartTime = StartTime ,
                @RecurringAppointment = RecurringAppointment ,
                @RecurringOccurrenceIndex = RecurringOccurrenceIndex
            FROM
                Appointments
            WHERE
                AppointmentId = @AppointmentId;


			 --If appointment is recurring appointment and is not master record ( occurance index = 1 ) 
			 -- find master record id
        IF ISNULL(@RecurringAppointment , 'N') = 'Y'
           BEGIN
                
                SELECT
                        @MasterAppointmentId = b.AppointmentId
                    FROM
                        Appointments AS a
                    JOIN RecurringAppointments AS b ON b.RecurringAppointmentId = a.RecurringAppointmentId
                    WHERE
                        a.AppointmentId = @AppointmentId;
            END;
                
        
        IF EXISTS ( SELECT
                            1
                        FROM
                            ExternalMappings
                        WHERE
                            RecordId = @AppointmentId
                            AND Category = 'Appointments'
                            AND ISNULL(RecordDeleted , 'N') = 'N' )
		  --handle non master recurring appointments 
		  --	 if the master record has been sycned we can set @previouslySynced to true 
		  --		AS child records would have been synced as well
            OR EXISTS ( SELECT
                                1
                            FROM
                                ExternalMappings
                            WHERE
                                RecordId = @MasterAppointmentId
                                AND Category = 'Appointments'
                                AND ISNULL(RecordDeleted , 'N') = 'N'
                                AND ISNULL(@RecurringAppointment , 'N') = 'Y'
                                AND ISNULL(@RecurringOccurrenceIndex , 1) <> 1 )
            BEGIN
                SET @PreviouslySynced = 1;
			 
            END;
            
			IF @PreviouslySynced = 0 AND @Action = 'D'
			AND EXISTS( SELECT 1
						FROM dbo.ExternalAppointmentQueue AS a
						WHERE a.AppointmentId = @AppointmentId
						AND a.[Action] = 'I'
						AND ISNULL(a.RecordDeleted,'N')='N'
					  )
			OR EXISTS( 
			
			 SELECT 1
						FROM dbo.ExternalAppointmentQueue AS a
						WHERE a.AppointmentId = @MasterAppointmentId
						AND a.[Action] = 'I'
						AND ISNULL(a.RecordDeleted,'N')='N'
			)
			BEGIN
			
				SELECT a.ExternalAppointmentQueueId, a.CreatedBy, a.CreatedDate, a.ModifiedBy, a.ModifiedDate, a.RecordDeleted, a.DeletedDate, a.DeletedBy, a.AppointmentId,
                     a.[Action], a.ExternalIdentifier, a.ExternalInterfaceCallParameters, a.ErrorMessage
					 INTO #ToRemove
				FROM dbo.ExternalAppointmentQueue AS a
				WHERE a.AppointmentId IN( @AppointmentId, @MasterAppointmentId)

				INSERT INTO dbo.ExternalAppointmentArchive ( CreatedBy, ModifiedBy, AppointmentId, Action,
				                                              ExternalIdentifier, ExternalInterfaceCallParameters, ErrorMessage, StaffId, StartTime, EndTime )
				SELECT @LoggedInUser,@LoggedInUser,a.AppointmentId,Action,ExternalIdentifier,ExternalInterfaceCallParameters,'Appointment was deleted before the Initial record was synced.',ap.StaffId,ap.StartTime,ap.EndTime
				FROM #ToRemove AS a
				JOIN Appointments AS ap ON ap.AppointmentId = a.AppointmentId


				DELETE FROM a 
				FROM dbo.ExternalAppointmentQueue AS a
				JOIN #ToRemove AS b ON b.ExternalAppointmentQueueId = a.ExternalAppointmentQueueId

				RETURN;
			END
     
        IF EXISTS ( SELECT
                            1
                        FROM
                            ExternalMappings
                        WHERE
                            RecordId = @AppointmentId
                            AND Category = 'Staff'
                            AND ISNULL(RecordDeleted , 'N') = 'N' )
            BEGIN
            
                SELECT TOP 1
                        @PreviousStaffId = ISNULL(CONVERT(INT , ExternalCode) , 0)
                    FROM
                        ExternalMappings
                    WHERE
                        RecordId = @AppointmentId
                        AND Category = 'Staff'
                        AND ISNULL(RecordDeleted , 'N') = 'N'
                    ORDER BY
                        CreatedDate DESC;
            END;
            
            --test selects
		  /*
        SELECT
                @AppointmentId AS 'AppointmentId ' ,
                @Action AS 'Action' ,
                @LoggedInUser AS 'LoggedInUser' ,
                @StartTime AS '@StartTime' ,
                @PreviouslySynced AS '@PreviouslySynced' ,
                @StaffId AS 'New StaffId' ,
                @PreviousStaffId AS 'PreviousStaffId' ,
                @PreviousStartTime AS 'PreviousStartTime' ,
                @GroupServiceId AS 'GroupServiceId' ,
                @ServiceId AS 'ServiceId' ,
                @MasterAppointmentId AS MasterAppointmentId ,
                @RecurringAppointment AS RecurringAppointment ,
                @RecurringOccurrenceIndex AS RecurringOccurrenceIndex;
            */
        IF ( @StartTime >= DATEADD(mi , 15 , GETDATE())
             AND @StaffId IS NOT NULL
           )	--If start time is after 15 minutes from now then add in queue
        --( @StaffId <> @PreviousStaffId
        --     OR ( @StaffId = @PreviousStaffId
        --          AND ( CONVERT(CHAR(10), @PreviousStartTime, 101) >= CONVERT(CHAR(10), GETDATE(), 101)
        --                OR CONVERT(CHAR(10), @StartTime, 101) >= CONVERT(CHAR(10), GETDATE(), 101)
        --              )
        --        )
        --   ) 
            BEGIN
        
                IF ( @Action = 'D' )
                    BEGIN
                        IF ( @PreviouslySynced = 1 )
                            BEGIN
                                INSERT INTO ExternalAppointmentQueue
                                        ( AppointmentId ,
                                          Action ,
                                          CreatedBy ,
                                          ModifiedBy
                                        )
                                    VALUES
                                        ( @AppointmentId ,
                                          'D' ,
                                          @LoggedInUser ,
                                          @LoggedInUser
                                        );
                            END;
                    END;
                ELSE
                    BEGIN
                        IF ( ISNULL(@ServiceId , 0) = 0
                             AND ISNULL(@GroupServiceId , 0) = 0
                           )
                            BEGIN
								--If never synced before but action was update e.g moving appointment from past which never synced to future
                                IF ( @PreviouslySynced = 0
                                     AND @Action = 'U'
                                   )
                                    BEGIN                            
                                        INSERT INTO ExternalAppointmentQueue
                                                ( AppointmentId ,
                                                  Action ,
                                                  CreatedBy ,
                                                  ModifiedBy

                                                )
                                            VALUES
                                                ( @AppointmentId ,
                                                  'I' ,
                                                  @LoggedInUser ,
                                                  @LoggedInUser			
                                                );
                          
                                    END;
                          
                                INSERT INTO ExternalAppointmentQueue
                                        ( AppointmentId ,
                                          Action ,
                                          CreatedBy ,
                                          ModifiedBy

                                        )
                                    VALUES
                                        ( @AppointmentId ,
                                          @Action ,
                                          @LoggedInUser ,
                                          @LoggedInUser			
                                        );
                            END;
                        ELSE
                            BEGIN
                                IF ( ISNULL(@ServiceId , 0) > 0 )
                                    BEGIN
                            
                                        IF ( @Action = 'I' )
                                            BEGIN
                                                INSERT INTO ExternalAppointmentQueue
                                                        ( AppointmentId ,
                                                          Action ,
                                                          CreatedBy ,
                                                          ModifiedBy
										
                                                        )
                                                    SELECT
                                                            @AppointmentId ,
                                                            'I' ,
                                                            ModifiedBy ,
                                                            ModifiedBy
                                                        FROM
                                                            Services
                                                        WHERE
                                                            ServiceId = @ServiceId
                                                            AND Status IN ( 70 , 71 , 72 );
                                            END;
/*END

                        ELSE IF ( ISNULL(@ServiceId, 0) > 0 ) 
                            BEGIN*/
                            
                                        ELSE
                                            IF ( @Action = 'U' )
                                                BEGIN
                                                    IF ( @StaffId = @PreviousStaffId )
                                                        BEGIN            
                                                            INSERT INTO ExternalAppointmentQueue
                                                                    ( AppointmentId ,
                                                                      Action ,
                                                                      CreatedBy ,
                                                                      ModifiedBy
										
                                                                    )
                                                                SELECT
                                                                        @AppointmentId ,
                                                                        'U' ,
                                                                        ModifiedBy ,
                                                                        ModifiedBy
                                                                    FROM
                                                                        Services
                                                                    WHERE
                                                                        ServiceId = @ServiceId
                                                                        AND Status IN ( 70 , 71 , 72 );

                                                        END;
                                                    ELSE
                                                        BEGIN

                                                            INSERT INTO ExternalAppointmentQueue
                                                                    ( AppointmentId ,
                                                                      Action ,
                                                                      CreatedBy ,
                                                                      ModifiedBy
										
                                                                    )
                                                                SELECT
                                                                        @AppointmentId ,
                                                                        'D' ,
                                                                        ModifiedBy ,
                                                                        ModifiedBy
                                                                    FROM
                                                                        Services
                                                                    WHERE
                                                                        ServiceId = @ServiceId
                                                                        AND Status IN ( 70 , 71 , 72 );
                                                            INSERT INTO ExternalAppointmentQueue
                                                                    ( AppointmentId ,
                                                                      Action ,
                                                                      CreatedBy ,
                                                                      ModifiedBy
										
                                                                    )
                                                                SELECT
                                                                        @AppointmentId ,
                                                                        'I' ,
                                                                        ModifiedBy ,
                                                                        ModifiedBy
                                                                    FROM
                                                                        Services
                                                                    WHERE
                                                                        ServiceId = @ServiceId
                                                                        AND Status IN ( 70 , 71 , 72 );
                                                        END;
                                                END;
                                            ELSE
                                                BEGIN
                                                    INSERT INTO ExternalAppointmentQueue
                                                            ( AppointmentId ,
                                                              Action ,
                                                              CreatedBy ,
                                                              ModifiedBy
										
                                                            )
                                                        SELECT
                                                                @AppointmentId ,
                                                                'D' ,
                                                                ModifiedBy ,
                                                                ModifiedBy
                                                            FROM
                                                                Services
                                                            WHERE
                                                                ServiceId = @ServiceId
                                                                AND Status = 73;
				
                                                    INSERT INTO ExternalAppointmentQueue
                                                            ( AppointmentId ,
                                                              Action ,
                                                              CreatedBy ,
                                                              ModifiedBy
										
                                                            )
                                                        SELECT
                                                                AppointmentId ,
                                                                'D' ,
                                                                @LoggedInUser ,
                                                                @LoggedInUser
                                                            FROM
                                                                Appointments
                                                            WHERE
                                                                ServiceId = @ServiceId
                                                                AND AppointmentId <> @AppointmentId; 
                                                END;
                                    END;
                                ELSE
                                    BEGIN
                                        IF ( ISNULL(@GroupServiceId , 0) > 0 )
                                            BEGIN                        
                                                IF ( dbo.SCGetGroupServiceStatus(@GroupServiceId) IN ( 70 , 71 , 72 ) )
                                                    BEGIN
                                            
                                                        IF ( @Action = 'U' )
                                                            BEGIN
                                                                IF ( @StaffId = @PreviousStaffId )
                                                                    BEGIN
                                                                        INSERT INTO ExternalAppointmentQueue
                                                                                ( AppointmentId ,
                                                                                  Action ,
                                                                                  CreatedBy ,
                                                                                  ModifiedBy
														
                                                                                )
                                                                            VALUES
                                                                                ( @AppointmentId ,
                                                                                  'U' ,
                                                                                  @LoggedInUser ,
                                                                                  @LoggedInUser
														
                                                                                );

                                                                    END;
                                                                ELSE
                                                                    BEGIN
            
                                                                        INSERT INTO ExternalAppointmentQueue
                                                                                ( AppointmentId ,
                                                                                  Action ,
                                                                                  CreatedBy ,
                                                                                  ModifiedBy
														
                                                                                )
                                                                            VALUES
                                                                                ( @AppointmentId ,
                                                                                  'D' ,
                                                                                  @LoggedInUser ,
                                                                                  @LoggedInUser
														
                                                                                );

                                                                        INSERT INTO ExternalAppointmentQueue
                                                                                ( AppointmentId ,
                                                                                  Action ,
                                                                                  CreatedBy ,
                                                                                  ModifiedBy
														
                                                                                )
                                                                            VALUES
                                                                                ( @AppointmentId ,
                                                                                  'I' ,
                                                                                  @LoggedInUser ,
                                                                                  @LoggedInUser
														
                                                                                );
                                                                    END;
                                                            END;
                                                        ELSE
                                                            BEGIN
                                                                INSERT INTO ExternalAppointmentQueue
                                                                        ( AppointmentId ,
                                                                          Action ,
                                                                          CreatedBy ,
                                                                          ModifiedBy
														
                                                                        )
                                                                    VALUES
                                                                        ( @AppointmentId ,
                                                                          @Action ,
                                                                          @LoggedInUser ,
                                                                          @LoggedInUser
                                                                        );
                                                            END;
                                            
                                                    END;
                                                ELSE
                                                    IF ( dbo.SCGetGroupServiceStatus(@GroupServiceId) = 73 )
                                                        BEGIN
                                                            INSERT INTO ExternalAppointmentQueue
                                                                    ( AppointmentId ,
                                                                      Action ,
                                                                      CreatedBy ,
                                                                      ModifiedBy
														
                                                                    )
                                                                VALUES
                                                                    ( @AppointmentId ,
                                                                      'D' ,
                                                                      @LoggedInUser ,
                                                                      @LoggedInUser
														
                                                                    );
                                                        END;
                                            END;
                                    END;
                            END;
                    END;
            END;  

    END;




GO

