/****** Object:  StoredProcedure [dbo].[ssp_SCCreateAddOnServices]    Script Date: 1/11/2017 1:19:45 PM ******/
DROP PROCEDURE [dbo].[ssp_SCCreateAddOnServices]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCCreateAddOnServices]    Script Date: 1/11/2017 1:19:45 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[ssp_SCCreateAddOnServices] ( @ServiceId INT )
AS /*************************************************************************
Created: 10/12/2014
Purpose: To Create Add-On Services
Author: NJain

**  NOV-06-2014  Akwinass  Removed 'DiagnosisCode1,DiagnosisNumber1,DiagnosisVersion1,DiagnosisCode2,DiagnosisNumber2,DiagnosisVersion2,DiagnosisCode3,DiagnosisNumber3,DiagnosisVersion3' from Services Table (Task #134 in Engineering Improvement Initiatives- NBL(I))

4/28/2015		NJain			Added RecordDeleted check on ServiceDiagnosis table when inserting diagnosis for Add On 	
							Services
8/29/2015		NJain			updated the AddOnServiceId field set to null statement only for current primary service								
Oct-19-2015     Akwinass        Modified the logic as per new Columns 'AddOnProcedureCodeStartTime,AddOnProcedureCodeUnit,AddOnProcedureCodeUnitType' from 'ServiceAddOnCodes'(Task #213 in Engineering Improvement Initiatives- NBL(I)) 
Nov-4-2015	 jcarlson		  modifed logic that looks for service errors to only look for error with a severity of 'E'
						  Also added in a check to stop the creation of the add on service if it has already been created, per recommendation by Tom.
Nov-18-2015 jcarlson		  merged in Slaviks changes, due to script failing 
The DELETE statement conflicted with the REFERENCE constraint "Services_ServiceAuthorizations_FK". The conflict occurred in database "ValleySmartCareProd", table "dbo.ServiceAuthorizations", column 'ServiceId'.
2/1/2016	NJain			Commented out Insert Into #TempServiceErrors
3/16/2016	NJain		    Updated to calculate Units for Add On Services from Start & End Time
22-3-2015 Rajesh S Removed GroupserviceId and passed NULL - Woods - Environment trackingissues - 111
4/7/2016	NJain			Committing Tom's changes for Add On Service Start Time: ISNULL(b.AddOnProcedureCodeStartTime, a.DateOfService)
6/18/2016	NJain			Updated to calculate End DOS when Add on is in Units.
6/27/2016	NJain			Updated to get Billable Flag from the Add-On Service Procedure Code -- Woods SGL #147
07/22/2016  jcarlson		added procedure code display as to addon service error message, for more clarity to the user on the front end. Added else statement to unit coversion, to handle units that cannot be converted to time.
10/18/2016  jcarlson	     modified logic that would detemine the end date of service, date time out, and units for Daily services
					     moved logic that would associate the add on service id to the serviceaddoncode record
						to before ssp_checkwarnings is run
						added logic to removed the associated add on service id if the add on service has any errors
1/10/2017 Robert Caffrey - Harbor Support # 1146 - Items to Minutes Calculation fix
**************************************************************************/


    DECLARE @OverrideErrors CHAR(1)
	
    SELECT  @OverrideErrors = ISNULL(OverrideError, 'N')
    FROM    Services
    WHERE   ServiceId = @ServiceId
	
    IF NOT EXISTS ( SELECT  se.*
                    FROM    dbo.ServiceErrors se
                    WHERE   se.ServiceId = @ServiceId
                            AND se.ErrorSeverity = 'E'
                            AND ISNULL(se.RecordDeleted, 'N') = 'N' )
        OR EXISTS ( SELECT  se.*
                    FROM    dbo.ServiceErrors se
                    WHERE   se.ServiceId = @ServiceId
                            AND se.ErrorSeverity = 'E'
                            AND @OverrideErrors = 'Y' )
        BEGIN
												
            CREATE TABLE #AddOnProcedureCodeId
                (
                  PrimaryProcedureCodeId INT ,
                  AddOnProcedureCodeId INT ,
                  AddOnProcedureCodeStartTime DATETIME ,
                  AddOnProcedureCodeUnit DECIMAL(18, 2) ,
                  AddOnProcedureCodeUnitType INT
                )
	
            CREATE TABLE #AddOnServiceId
                (
                  PrimaryServiceId INT ,
                  AddOnServiceId INT ,
                  StartDate DATETIME ,
                  EndDate DATETIME ,
                  Unit DECIMAL(18, 2) ,
                  UnitType INT
                )
                            
                            
            INSERT  INTO #AddOnProcedureCodeId
                    ( PrimaryProcedureCodeId ,
                      AddOnProcedureCodeId ,
                      AddOnProcedureCodeStartTime ,
                      AddOnProcedureCodeUnit ,
                      AddOnProcedureCodeUnitType
                    )
                    SELECT DISTINCT
                            a.ProcedureCodeId ,
                            b.AddOnProcedureCodeId ,
                            ISNULL(b.AddOnProcedureCodeStartTime, a.DateOfService) ,
                            b.AddOnProcedureCodeUnit ,
                            b.AddOnProcedureCodeUnitType
                    FROM    Services a
                            JOIN dbo.ServiceAddOnCodes b ON b.ServiceId = a.ServiceId
                    WHERE   a.ServiceId = @ServiceId
                            AND ISNULL(b.RecordDeleted, 'N') = 'N'
	
-- 1. Create Add-on Services with identical informationas Primary Service, except the Procedure Code Id						
            INSERT  INTO Services
                    ( ClientId ,
                      GroupServiceId ,
                      ProcedureCodeId ,
                      DateOfService ,
                      EndDateOfService ,
                      RecurringService ,
                      Unit ,
                      UnitType ,
                      Status ,
                      CancelReason ,
                      ProviderId ,
                      ClinicianId ,
                      AttendingId ,
                      ProgramId ,
                      LocationId ,
                      Billable ,
                      ClientWasPresent ,
                      OtherPersonsPresent ,
                      AuthorizationsApproved ,
                      AuthorizationsNeeded ,
                      AuthorizationsRequested ,
                      Charge ,
                      NumberOfTimeRescheduled ,
                      NumberOfTimesCancelled ,
                      ProcedureRateId ,
                      DoNotComplete ,
                      Comment ,
                      Flag1 ,
                      OverrideError ,
                      OverrideBy ,
                      ReferringId ,
                      DateTimeIn ,
                      DateTimeOut ,
                      NoteAuthorId ,
                      ModifierId1 ,
                      ModifierId2 ,
                      ModifierId3 ,
                      ModifierId4 ,
                      PlaceOfServiceId ,
                      SpecificLocation
                    )
            OUTPUT  INSERTED.ServiceId ,
                    INSERTED.DateOfService ,
                    INSERTED.EndDateOfService ,
                    INSERTED.Unit ,
                    INSERTED.UnitType
                    INTO #AddOnServiceId ( AddOnServiceId, StartDate, EndDate, Unit, UnitType )
                    SELECT  ClientId ,
                            NULL ,--GroupServiceId ,
                            b.AddOnProcedureCodeId ,
                            b.AddOnProcedureCodeStartTime AS DateOfService ,
                            CASE WHEN GC.GlobalCodeId = 110 THEN DATEADD(MINUTE, b.AddOnProcedureCodeUnit, b.AddOnProcedureCodeStartTime)
                                 WHEN GC.GlobalCodeId = 111 THEN DATEADD(HOUR, b.AddOnProcedureCodeUnit, b.AddOnProcedureCodeStartTime)
                                 --calculate the end date of service the same way the front end does
						   WHEN GC.GlobalCodeId = 112 THEN DATEADD(DAY, ( b.AddOnProcedureCodeUnit - 1 ), b.AddOnProcedureCodeStartTime)
                                 WHEN GC.GlobalCodeId = 116 THEN DATEADD(MINUTE, b.AddOnProcedureCodeUnit, b.AddOnProcedureCodeStartTime)
                                 ELSE EndDateOfService
                            END EndDateOfService ,
                            RecurringService ,
                            b.AddOnProcedureCodeUnit ,
                            b.AddOnProcedureCodeUnitType ,
                            Status ,
                            CancelReason ,
                            ProviderId ,
                            ClinicianId ,
                            AttendingId ,
                            ProgramId ,
                            LocationId ,
                            CASE WHEN ISNULL(pc.NotBillable, 'N') = 'Y' THEN 'N'
                                 ELSE 'Y'
                            END ,
                            ClientWasPresent ,
                            OtherPersonsPresent ,
                            AuthorizationsApproved ,
                            AuthorizationsNeeded ,
                            AuthorizationsRequested ,
                            NULL , --Charge ,
                            NumberOfTimeRescheduled ,
                            NumberOfTimesCancelled ,
                            NULL ,-- ProcedureRateId ,
                            DoNotComplete ,
                            Comment ,
                            Flag1 ,
                            OverrideError ,
                            OverrideBy ,
                            ReferringId ,
                            b.AddOnProcedureCodeStartTime AS DateTimeIn ,
                            CASE WHEN GC.GlobalCodeId = 110 THEN DATEADD(MINUTE, b.AddOnProcedureCodeUnit, b.AddOnProcedureCodeStartTime)
                                 WHEN GC.GlobalCodeId = 111 THEN DATEADD(HOUR, b.AddOnProcedureCodeUnit, b.AddOnProcedureCodeStartTime)
                                 --calculate the end date of service the same way the front end does
						   WHEN GC.GlobalCodeId = 112 THEN DATEADD(DAY, ( b.AddOnProcedureCodeUnit - 1 ), b.AddOnProcedureCodeStartTime)
                                 WHEN GC.GlobalCodeId = 116 THEN DATEADD(MINUTE, b.AddOnProcedureCodeUnit, b.AddOnProcedureCodeStartTime)
                                 ELSE EndDateOfService
                            END DateTimeOut ,
                            NoteAuthorId ,
                            ModifierId1 ,
                            ModifierId2 ,
                            ModifierId3 ,
                            ModifierId4 ,
                            PlaceOfServiceId ,
                            SpecificLocation
                    FROM    dbo.Services a
                            JOIN #AddOnProcedureCodeId b ON a.ProcedureCodeId = b.PrimaryProcedureCodeId
                            JOIN GlobalCodes GC ON b.AddOnProcedureCodeUnitType = GC.GlobalCodeId
                            JOIN dbo.ProcedureCodes pc ON pc.ProcedureCodeId = b.AddOnProcedureCodeId
                    WHERE   a.ServiceId = @ServiceId
                            AND NOT EXISTS ( SELECT 1
                                             FROM   ServiceAddOnCodes saoc
                                             WHERE  saoc.ServiceId = @ServiceId
                                                    AND saoc.AddOnProcedureCodeId = b.AddOnProcedureCodeId
                                                    AND saoc.AddOnServiceId IS NOT NULL
                                                    AND ISNULL(saoc.RecordDeleted, 'N') = 'N' )
								
			
			
            UPDATE  #AddOnServiceId
            SET     PrimaryServiceId = @ServiceId
			
			
            UPDATE  #AddOnServiceId
            SET     Unit = CASE WHEN UnitType = 110 THEN DATEDIFF(MINUTE, StartDate, EndDate)
                                WHEN UnitType = 111 THEN DATEDIFF(HOUR, StartDate, EndDate)
						  -- add 1 unit back to the difference between the start and end date to get the correct units
                                WHEN UnitType = 112 THEN ( DATEDIFF(DAY, StartDate, EndDate) + 1 )
                                WHEN UnitType = 116 THEN DATEDIFF(MINUTE, StartDate, EndDate)
						  ELSE Unit --Handles all unit types that cannot be coverted to a time value
                           END
			
            UPDATE  a
            SET     Unit = b.Unit
            FROM    dbo.Services a
                    JOIN #AddOnServiceId b ON b.AddOnServiceId = a.ServiceId
                    
                    
                    
			
            INSERT  INTO ServiceDiagnosis
                    ( ServiceId ,
                      DSMCode ,
                      DSMNumber ,
                      DSMVCodeId ,
                      ICD10Code ,
                      ICD9Code ,
                      [Order]
                    )
                    SELECT  a.AddonServiceId ,
                            c.DSMCode ,
                            c.DSMNumber ,
                            c.DSMVCodeId ,
                            c.ICD10Code ,
                            c.ICD9Code ,
                            c.[Order]
                    FROM    #AddOnServiceId a
                            JOIN Services b ON b.ServiceId = a.PrimaryServiceId
                            JOIN dbo.ServiceDiagnosis c ON c.ServiceId = b.ServiceId
                    WHERE   ISNULL(c.RecordDeleted, 'N') = 'N'
			
			
            			
-- 2. Calculate Charge for and Validate the add-on Services just created	

            DECLARE @ClientId INT = ( SELECT    ClientId
                                      FROM      Services
                                      WHERE     ServiceId = @ServiceId
                                    )

            DECLARE @ClinicianId INT = ( SELECT ClinicianId
                                         FROM   Services
                                         WHERE  ServiceId = @ServiceId
                                       )
            --DECLARE @StartDate DATETIME = ( SELECT  DateOfService
            --                                FROM    Services
            --                                WHERE   ServiceId = @ServiceId
            --                              )
            --DECLARE @EndDate DATETIME = ( SELECT    EndDateOfService
            --                              FROM      Services
            --                              WHERE     ServiceId = @ServiceId
            --                            )
            DECLARE @Attending VARCHAR(10) = ( SELECT   AttendingId
                                               FROM     Services
                                               WHERE    ServiceId = @ServiceId
                                             )
            
            DECLARE @ServiceCompletionStatus VARCHAR(10) = 'COMPLETED'
            DECLARE @ProgramId INT = ( SELECT   ProgramId
                                       FROM     Services
                                       WHERE    ServiceId = @ServiceId
                                     )
            DECLARE @LocationId INT = ( SELECT  LocationId
                                        FROM    Services
                                        WHERE   ServiceId = @ServiceId
                                      )
            DECLARE @Degree INT = ( SELECT  b.Degree
                                    FROM    Services a
                                            JOIN dbo.Staff b ON a.ClinicianId = b.StaffId
                                    WHERE   a.ServiceId = @ServiceId
                                            AND b.Active = 'Y'
                                            AND ISNULL(b.RecordDeleted, 'N') = 'N'
                                  )
            --DECLARE @UnitValue DECIMAL = ( SELECT   Unit
            --                               FROM     Services
            --                               WHERE    ServiceId = @ServiceId
            --                             )
            DECLARE @PreviousStatus INT = 71

            DECLARE @ProcedureCodeId INT

            DECLARE @I INT 
            DECLARE @J INT 

            SELECT  @I = MIN(AddOnServiceId)
            FROM    #AddOnServiceId


-- Delete Add-On Service Errors from the Primary Service

            DELETE  FROM dbo.ServiceErrors
            WHERE   ServiceId = @ServiceId
                    AND ErrorMessage LIKE 'Add-On Service Error:%'

-- Claculate Charge and Validate Add-On Services
			
				--Associate the add on service id to the serviceaddoncode record before check warnings runs
				UPDATE  a
                    SET     AddOnServiceId = b.ServiceId
                    FROM    dbo.ServiceAddOnCodes a
                            JOIN dbo.Services b ON a.AddOnProcedureCodeId = b.ProcedureCodeId
                            JOIN #AddOnServiceId c ON b.ServiceId = c.AddOnServiceId
                    WHERE   a.ServiceId = @ServiceId
            CREATE TABLE #TempServiceErrors
                (
                  ServiceErrorId INT ,
                  ServiceId INT ,
                  CoveragePlanId INT ,
                  ErrorType INT ,
                  ErrorSeverity CHAR(1) ,
                  ErrorMessage VARCHAR(1000) ,
                  NextStep INT ,
                  RowIdentifier VARCHAR(100) ,
                  CreatedBy VARCHAR(30) ,
                  CreatedDate DATETIME ,
                  ModifiedBy VARCHAR(30) ,
                  ModifiedDate DATETIME ,
                  RecordDeleted CHAR(1) ,
                  DeletedDate DATETIME ,
                  DeletedBy VARCHAR(30)
                )
            
            WHILE @I <= ( SELECT    MAX(AddOnServiceId)
                          FROM      #AddOnServiceId
                        )
                BEGIN
		
                    DECLARE @AddOnProcedureCodeId INT = ( SELECT    ProcedureCodeId
                                                          FROM      Services
                                                          WHERE     ServiceId = @I
                                                        )
                                                        
                    DECLARE @StartDate DATETIME = ( SELECT  StartDate
                                                    FROM    #AddOnServiceId
                                                    WHERE   AddOnServiceId = @I
                                                  )
                                          
                    DECLARE @EndDate DATETIME = ( SELECT    EndDate
                                                  FROM      #AddOnServiceId
                                                  WHERE     AddOnServiceId = @I
                                                )
                                                        
                    DECLARE @UnitValue DECIMAL = ( SELECT   Unit
                                                   FROM     #AddOnServiceId
                                                   WHERE    AddOnServiceId = @I
                                                 )

					
                    DECLARE @Charge MONEY = NULL
                    DECLARE @ProcedureRateId INT = NULL
					


                    EXEC dbo.ssp_PMServiceCalculateCharge @ClientId = @ClientId, -- int
                        @DateOfService = @StartDate, -- datetime
                        @ClinicianId = @ClinicianId, -- int
                        @ProcedureCodeId = @AddOnProcedureCodeId, -- int
                        @Units = @UnitValue, -- decimal
                        @ProgramId = @ProgramId, -- int
                        @LocationId = @LocationId, -- int
                        @ProcedureRateId = @ProcedureRateId OUTPUT, -- int
                        @Charge = @Charge OUTPUT -- money
                    
                    
                    
                    UPDATE  dbo.Services
                    SET     Charge = @Charge ,
                            ProcedureRateId = @ProcedureRateID
                    WHERE   ServiceId = @I
                    
                    
                    /*SELECT  @Charge = ISNULL(@Charge, '0')
                    SELECT  @ProcedureRateId = ISNULL(@ProcedureRateId, 0)
                    
                    PRINT @Charge 
                    PRINT @ProcedureRateId*/

                    
                    --INSERT  INTO #TempServiceErrors
                    EXEC dbo.ssp_CheckWarnings @ClientId = @ClientId, -- int
                        @ServiceId = @I, -- int
                        @ProcedureCodeId = @AddOnProcedureCodeId, -- int
                        @ClinicianId = @ClinicianId, -- int
                        @StartDate = @StartDate, -- datetime
                        @EndDate = @EndDate, -- datetime
                        @Attending = @Attending, -- varchar(10)                               
                        @ServiceCompletionStatus = @ServiceCompletionStatus, -- varchar(10)
                        @ProgramId = @ProgramId, -- int
                        @LocationId = @LocationId, -- int
                        @Degree = @Degree, -- int
                        @UnitValue = @UnitValue, -- decimal
                        @PreviousStatus = @PreviousStatus -- int
                            
                    SELECT  @J = @I
                    
                    SELECT  @I = MIN(AddOnServiceId)
                    FROM    #AddOnServiceId
                    WHERE   AddonServiceId > @J
                            
                END
                            
                                                      
-- Remove scheduling conflict errors from Add-On Services
            DELETE  FROM dbo.ServiceErrors
            WHERE   ErrorMessage IN ( 'An overlapping service exists for this clinician at this time.', 'An overlapping service exists for this client at this time.' )
                    AND ServiceId IN ( SELECT DISTINCT
                                                AddOnServiceId
                                       FROM     #AddOnServiceId )
    
-- 3. Check for Errors in the Add-On Services	

-- If there are no errors in the Add-On Services, update ServiceAddOnCodes table
	/*		
	No longer needed		
            IF NOT EXISTS ( SELECT  *
                            FROM    ServiceErrors a
                                    JOIN #AddOnServiceId b ON a.ServiceId = b.AddOnServiceId
                            WHERE   a.ErrorSeverity = 'E'
                                    AND ISNULL(a.RecordDeleted, 'N') = 'N' )
                OR EXISTS ( SELECT  *
                            FROM    ServiceErrors a
                                    JOIN #AddOnServiceId b ON a.ServiceId = b.AddOnServiceId
                            WHERE   a.ErrorSeverity = 'E'
                                    AND ISNULL(a.RecordDeleted, 'N') = 'N'
                                    AND @OverrideErrors = 'Y' )
                BEGIN
								
                    UPDATE  a
                    SET     AddOnServiceId = b.ServiceId
                    FROM    dbo.ServiceAddOnCodes a
                            JOIN dbo.Services b ON a.AddOnProcedureCodeId = b.ProcedureCodeId
                            JOIN #AddOnServiceId c ON b.ServiceId = c.AddOnServiceId
                    WHERE   a.ServiceId = @ServiceId
                END				
				*/		
                        
-- If there are errors in the Add-On Services, update Primary Service with the Errors and rollback Add-On service changes. 						
            IF EXISTS ( SELECT  *
                        FROM    ServiceErrors a
                                JOIN #AddOnServiceId b ON a.ServiceId = b.AddOnServiceId
                        WHERE   a.ErrorSeverity = 'E'
                                AND @OverrideErrors = 'N'
                                AND ISNULL(a.RecordDeleted, 'N') = 'N' )
                BEGIN

                    INSERT  INTO ServiceErrors
                            ( ServiceId ,
                              ErrorType ,
                              ErrorSeverity ,
                              ErrorMessage
                            )
                            SELECT  @ServiceId ,
                                    a.ErrorType ,
                                    a.ErrorSeverity ,
                                    'Add-On Service Error: ' + pc.DisplayAs + ' - ' + a.ErrorMessage
                            FROM    dbo.ServiceErrors a
                                    JOIN #AddOnServiceId b ON a.ServiceId = b.AddOnServiceId
							 JOIN dbo.Services AS s ON b.AddOnServiceId = s.ServiceId
							 JOIN dbo.ProcedureCodes AS pc ON pc.ProcedureCodeId = s.ProcedureCodeId                             
                                
                    DELETE  s
                    FROM    dbo.ServiceErrors s
                    WHERE   EXISTS ( SELECT *
                                     FROM   #AddOnServiceId a
                                     WHERE  a.AddOnServiceId = s.ServiceId )
 
 
                    --remove the associated add on service id, if the add on service has any errors
				--this is already handled
                    UPDATE  dbo.ServiceAddOnCodes
                    SET     AddOnServiceId = NULL
                    WHERE   ServiceId IN ( SELECT   PrimaryServiceId
                                           FROM     #AddOnServiceId )
								
                    DELETE  s
                    FROM    dbo.ServiceDiagnosis s
                    WHERE   EXISTS ( SELECT *
                                     FROM   #AddOnServiceId a
                                     WHERE  a.AddOnServiceId = s.ServiceId )

                    DELETE  s
                    FROM    dbo.ServiceAuthorizations s
                    WHERE   EXISTS ( SELECT *
                                     FROM   #AddOnServiceId a
                                     WHERE  a.AddOnServiceId = s.ServiceId )

                    DELETE  s
                    FROM    dbo.Services s
                    WHERE   EXISTS ( SELECT *
                                     FROM   #AddOnServiceId a
                                     WHERE  a.AddOnServiceId = s.ServiceId )
					
                    UPDATE  dbo.Services
                    SET     Status = 71
                    WHERE   ServiceId = @ServiceId
			
                END								
						
						
							
            DROP TABLE #AddOnProcedureCodeId
							
            DROP TABLE #AddOnServiceId	
            
            DROP TABLE #TempServiceErrors
            

            
        END

GO


