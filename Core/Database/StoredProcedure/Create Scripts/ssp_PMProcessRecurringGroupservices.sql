/****** Object:  StoredProcedure [dbo].[ssp_PMProcessRecurringGroupservices]    Script Date: 07/28/2016 12:26:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMProcessRecurringGroupservices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMProcessRecurringGroupservices]
GO

/****** Object:  StoredProcedure [dbo].[ssp_PMProcessRecurringGroupservices]    Script Date: 07/28/2016 12:26:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_PMProcessRecurringGroupservices]
    @RecurringGroupServicesId INT = NULL
AS /******************************************************************************      
**  File: dbo.ssp_PMProcessRecurringGroupservices.prc       
**  Name: dbo.ssp_PMProcessRecurringGroupservices       
**  Desc: This will be used to Expand Recurring GroupServices.       
**      
**  This template can be customized:      
**                    
**  Return values:      
**       
**  Called by:         
**                    
**  Parameters:      
**  Input      Output      
**  ----------     -----------      
**  @RecurringGroupServicesId    
**      
**  Auth: Nisha Mittal      
**  Date: 06.07.2010      
*******************************************************************************      
**  Change History      
*******************************************************************************      
**  Date:  Author:   Description:      
**  ----------- ------------ ---------------------------------------      
**  06.07.2010  Nisha Mittal Created      
**	07.27.2012	Wasif Butt - Made changes to the document creation process 
**				which was not updating the "InProgressDocumentVersionId" and 
**				"CurrentVersionStatus" for expanding recurrence.
**  1/31/2013   What: Added null check for NumberOfDaysRecurringServicesSchedule : isnull(NumberOfDaysRecurringServicesSchedule,30)
				Why:  for task#456 in 3.x Issues as null value was being directly used for further operation
**	Feb 13 2013	Wasif Butt - Added code to insert/update/delete external appointment sync
**	Mar 20 2013	Wasif Butt - Removed the copy of status and documents to recurring group services from original group services
**	Sep 01 2015	Wasif Butt - Integer NULL variables should be tested by either is null or isnull() not with the equal sign (=)
**  Oct 21 2015 NJain	   - Removed SET @NewGroupServiceId = SCOPE_IDENTITY, instead added OUTPUT INSERTED.GroupServiceId INTO #NewGroupService
**  Nov 17 2015 NJain	   - Added Select @NewGroupServiceId from #NewGroupService
**  JULY 27 2016 Akwinass  - Added logic to work with deleted Group Services (Task #377 in Engineering Improvement Initiatives- NBL(I))
**  AUG  22 2016 Akwinass  - Removed distinct logic for @LoopCounter. Since it is affecting loop logic. (Task #377 in Engineering Improvement Initiatives- NBL(I))
*******************************************************************************/    
    BEGIN        
        BEGIN TRY        
            BEGIN TRAN        
  -- UnprocessedRecurringGroupService        
            IF OBJECT_ID('tempdb..#UnprocessedRecurringGroupService') IS NOT NULL
                BEGIN        
                    DROP TABLE #UnprocessedRecurringGroupService        
                END        
            CREATE TABLE #UnprocessedRecurringGroupService
                (
                  Id INT IDENTITY(1, 1)
                         NOT NULL ,
                  GroupServiceId INT NULL ,
                  RecurringGroupServiceId INT NULL ,
                  APPNTGSID INT NULL
                )        
        
  -- Staff Count         
            IF OBJECT_ID('tempdb..#Staff') IS NOT NULL
                BEGIN        
                    DROP TABLE #Staff        
                END        
            CREATE TABLE #Staff
                (
                  Id INT IDENTITY(1, 1)
                         NOT NULL ,
                  NoofOccurrences INT NOT NULL ,
                  StaffId INT NOT NULL ,
                  GroupServiceId INT NOT NULL
                )        
        
  -- Temporary Appointments        
            IF OBJECT_ID('tempdb..#TempAppointMents') IS NOT NULL
                BEGIN        
                    DROP TABLE #TempAppointMents        
                END        
            CREATE TABLE #TempAppointMents
                (
                  Id INT IDENTITY(1, 1)
                         NOT NULL ,
                  AppointmentId INT NOT NULL ,
                  StaffId INT NOT NULL ,
                  Subject VARCHAR(250) NULL ,
                  StartTime DATETIME NOT NULL ,
                  EndTime DATETIME NOT NULL ,
                  AppointmentType INT NULL ,
                  ShowTimeAs INT NOT NULL ,
                  LocationId INT NULL ,
                  SpecificLocation VARCHAR(250) NULL ,
                  ServiceId INT NULL ,
                  GroupServiceId INT NULL ,
                  AppointmentProcedureGroupId INT NULL ,
                  RecurringAppointment CHAR(1) NULL ,
                  RecurringDescription VARCHAR(250) NULL ,
                  RecurringAppointmentId INT NULL ,
                  RecurringServiceId INT NULL ,
                  RecurringGroupServiceId INT NULL ,
                  CreatedBy VARCHAR(30) NOT NULL ,
                  CreatedDate DATETIME NOT NULL ,
                  ModifiedBy VARCHAR(30) NOT NULL ,
                  ModifiedDate DATETIME NOT NULL
                )        
        
  -- New Group Service        
            IF OBJECT_ID('tempdb..#NewGroupService') IS NOT NULL
                BEGIN        
                    DROP TABLE #NewGroupService        
                END        
            CREATE TABLE #NewGroupService
                (
                  Id INT IDENTITY(1, 1)
                         NOT NULL ,
                  NewGroupServiceId INT NOT NULL
                )        
     
   -- Services        
            IF OBJECT_ID('tempdb..#Services') IS NOT NULL
                BEGIN        
                    DROP TABLE #Services        
                END        
            CREATE TABLE #Services
                (
                  Id INT IDENTITY(1, 1)
                         NOT NULL ,
                  ServiceId INT NOT NULL ,
                  GroupServiceId INT NOT NULL
                )        
      
  /* Looking all records from RecurringGroupServiceProcessLog table        
  and fetching those into temporary table */    
        
            IF ( @RecurringGroupServicesId IS NULL )
                BEGIN       
                    INSERT  INTO #UnprocessedRecurringGroupService
                            ( GroupServiceId ,
                              RecurringGroupServiceId ,
                              APPNTGSID        
                            )        
  /*SELECT DISTINCT RGSPL.GroupServiceId, APPNT.RecurringGroupServiceId   
  FROM         dbo.RecurringGroupServicesProcessLog AS RGSPL INNER JOIN    
         dbo.RecurringGroupServicesUnprocessed AS RGSUP ON RGSPL.RecurringGroupServiceId = RGSUP.RecurringGroupServiceId INNER JOIN    
         dbo.RecurringGroupServices AS RGS ON RGSPL.RecurringGroupServiceId = RGS.RecurringGroupServiceId INNER JOIN    
         dbo.Appointments AS APPNT ON RGSUP.RecurringGroupServiceId = APPNT.RecurringGroupServiceId    
  WHERE     (ISNULL(RGS.Processed, 'N') = 'N') AND (ISNULL(RGSPL.RecordDeleted, 'N') = 'N') AND (ISNULL(RGSUP.RecordDeleted, 'N') = 'N') AND (ISNULL(RGS.RecordDeleted,     
         'N') = 'N') AND (ISNULL(APPNT.RecordDeleted, 'N') = 'N')*/
                            SELECT DISTINCT
                                    RGSPL.GroupServiceId ,
                                    RGSPL.RecurringGroupServiceId ,
                                    dbo.Appointments.GroupServiceId AS Expr1
                            FROM    dbo.RecurringGroupServicesProcessLog AS RGSPL
                                    INNER JOIN dbo.RecurringGroupServicesUnprocessed AS RGSUP ON RGSPL.RecurringGroupServiceId = RGSUP.RecurringGroupServiceId
                                    INNER JOIN dbo.RecurringGroupServices AS RGS ON RGSPL.RecurringGroupServiceId = RGS.RecurringGroupServiceId
                                    FULL OUTER JOIN dbo.Appointments ON RGSUP.RecurringGroupServiceId = dbo.Appointments.RecurringGroupServiceId
                                                                        AND RGSPL.GroupServiceId = dbo.Appointments.GroupServiceId
                            WHERE   ( ISNULL(RGS.Processed, 'N') = 'N'
                                      OR ISNULL(RGS.LastDateOfService, rgs.EndDate) <> rgs.EndDate
                                    )
                                    AND ( ISNULL(RGSPL.RecordDeleted, 'N') = 'N' )
                                    --AND ( ISNULL(RGSUP.RecordDeleted, 'N') = 'N' )
                                    AND ( ISNULL(RGS.RecordDeleted, 'N') = 'N' )
                                    AND ( ISNULL(dbo.Appointments.GroupServiceId, 0) = 0 )
                                    AND ( ISNULL(RGSPL.GroupServiceId, 0) <> 0 )    
                END    
            ELSE
                BEGIN    
                    INSERT  INTO #UnprocessedRecurringGroupService
                            ( GroupServiceId ,
                              RecurringGroupServiceId ,
                              APPNTGSID        
                            )        
  /*SELECT DISTINCT RGSPL.GroupServiceId, APPNT.RecurringGroupServiceId    
  FROM         dbo.RecurringGroupServicesProcessLog AS RGSPL INNER JOIN    
         dbo.RecurringGroupServicesUnprocessed AS RGSUP ON RGSPL.RecurringGroupServiceId = RGSUP.RecurringGroupServiceId INNER JOIN    
         dbo.RecurringGroupServices AS RGS ON RGSPL.RecurringGroupServiceId = RGS.RecurringGroupServiceId INNER JOIN    
         dbo.Appointments AS APPNT ON RGSUP.RecurringGroupServiceId = APPNT.RecurringGroupServiceId    
  WHERE     (ISNULL(RGS.Processed, 'N') = 'N') AND (ISNULL(RGSPL.RecordDeleted, 'N') = 'N') AND (ISNULL(RGSUP.RecordDeleted, 'N') = 'N') AND (ISNULL(RGS.RecordDeleted,     
         'N') = 'N') AND (ISNULL(APPNT.RecordDeleted, 'N') = 'N') AND    
                      (RGS.RecurringGroupServiceId = @RecurringGroupServicesId)*/
                            SELECT DISTINCT
                                    RGSPL.GroupServiceId ,
                                    RGSPL.RecurringGroupServiceId ,
                                    dbo.Appointments.GroupServiceId AS Expr1
                            FROM    dbo.RecurringGroupServicesProcessLog AS RGSPL
                                    INNER JOIN dbo.RecurringGroupServicesUnprocessed AS RGSUP ON RGSPL.RecurringGroupServiceId = RGSUP.RecurringGroupServiceId
                                    INNER JOIN dbo.RecurringGroupServices AS RGS ON RGSPL.RecurringGroupServiceId = RGS.RecurringGroupServiceId
                                    FULL OUTER JOIN dbo.Appointments ON RGSUP.RecurringGroupServiceId = dbo.Appointments.RecurringGroupServiceId
                                                                        AND RGSPL.GroupServiceId = dbo.Appointments.GroupServiceId
                            WHERE   ( ISNULL(RGS.Processed, 'N') = 'N'
                                      OR ISNULL(RGS.LastDateOfService, rgs.EndDate) <> rgs.EndDate
                                    )
                                    AND ( ISNULL(RGSPL.RecordDeleted, 'N') = 'N' )
                                    --AND ( ISNULL(RGSUP.RecordDeleted, 'N') = 'N' )
                                    AND ( ISNULL(RGS.RecordDeleted, 'N') = 'N' )
                                    AND ( RGS.RecurringGroupServiceId = @RecurringGroupServicesId )
                                    AND ( ISNULL(dbo.Appointments.GroupServiceId, 0) = 0 )
                                    AND ( ISNULL(RGSPL.GroupServiceId, 0) <> 0 )                 
                END        
            DECLARE @ModifiedDate type_CurrentDatetime        
            SET @ModifiedDate = GETDATE()       
      
  --select * from #UnprocessedRecurringGroupService    
  --return    
            IF EXISTS ( SELECT  RecurringGroupServiceId
                        FROM    #UnprocessedRecurringGroupService )
                BEGIN        
                    DECLARE @Counter INT= 1        
                    DECLARE @LoopCounter INT= ( SELECT  COUNT(RecurringGroupServiceId)
                                                FROM    #UnprocessedRecurringGroupService
                                              );        
                    DECLARE @GroupServiceId INT        
                    DECLARE @GroupServiceCounter INT        
                    DECLARE @GSCount INT       
                    DECLARE @StaffCounter INT        
                    DECLARE @TotalStaff INT         
                    DECLARE @RecurringGroupServiceId INT        
                    DECLARE @NewGroupServiceId INT    
                    DECLARE @NumberOfDaysRecurringServicesSchedule INT       
        
                    SELECT  @NumberOfDaysRecurringServicesSchedule = ISNULL(NumberOfDaysRecurringServicesSchedule, 30)
                    FROM    SystemConfigurations       
       
   -- Loop for all unprocessed group services        
                    WHILE @Counter <= @LoopCounter
                        BEGIN        
                            SET @GroupServiceId = ( SELECT  GroupServiceId
                                                    FROM    #UnprocessedRecurringGroupService
                                                    WHERE   Id = @Counter
                                                  );        
                            SET @RecurringGroupServiceId = ( SELECT RecurringGroupServiceId
                                                             FROM   #UnprocessedRecurringGroupService
                                                             WHERE  Id = @Counter
                                                           );        
            
                            DECLARE @LastDateOfService DATETIME     
                            DECLARE @RecurrenceStartDate DATETIME    
                            DECLARE @EndDateOfService DATETIME    
                            DECLARE @RecurrenceEndDate DATETIME    
       
                            SELECT  @LastDateOfService = LastDateOfService ,
                                    @RecurrenceStartDate = RecurrenceStartDate ,
                                    @RecurrenceEndDate = EndDate
                            FROM    RecurringGroupServices
                            WHERE   RecurringGroupServiceId = @RecurringGroupServiceId     
       
                            IF ( @LastDateOfService IS NULL )
                                SET @LastDateOfService = @RecurrenceStartDate    
                            SET @EndDateOfService = DATEADD(dd, @NumberOfDaysRecurringServicesSchedule, @LastDateOfService)     
    
        
  -- Insert into #Staff table        
      
  --select @LastDateOfService as '@LastDateOfService'    
  --select @EndDateOfService as '@EndDateOfService'    
  --return     
                            TRUNCATE TABLE #Staff        
                            INSERT  INTO #Staff
                                    ( NoofOccurrences ,
                                      StaffId ,
                                      GroupServiceId
                                    )
                                    SELECT  COUNT(StaffId) AS NoOfOccurrences ,
                                            StaffId ,
                                            @GroupServiceId
                                    FROM    dbo.Appointments
                                    WHERE   ( ISNULL(RecordDeleted, 'N') = 'N' )
                                            AND ( RecurringGroupServiceId = @RecurringGroupServiceId )
                                            AND ( StartTime >= @LastDateOfService )
                                            AND ( EndTime <= @EndDateOfService )
                                            AND ( ISNULL(GroupServiceId, 0) = 0 )
                                    GROUP BY StaffId     
          
  --select * from #Staff    
  --return     
      
  /* start inserting into temporary services table */    
                            TRUNCATE TABLE #Services    
                            INSERT  INTO #Services
                                    ( ServiceId ,
                                      GroupServiceId
                                    )
                                    SELECT  ServiceId ,
                                            GroupServiceId
                                    FROM    Services
                                    WHERE   GroupServiceId = @GroupServiceId
                                            AND ( ISNULL(RecordDeleted, 'N') = 'N' )    
                                            
                                            
                             /********JULY 27 2016****Akwinass*********Added below logic to work with deleted group services***********************************************************************************/
							IF NOT EXISTS (SELECT 1 FROM #Services) AND EXISTS(SELECT 1 FROM GroupServices WHERE GroupServiceId = @GroupServiceId AND (ISNULL(RecordDeleted, 'N') = 'Y'))
							BEGIN
								IF OBJECT_ID('tempdb..#DeletedServices') IS NOT NULL
									DROP TABLE #DeletedServices
								CREATE TABLE #DeletedServices (DeletedMonth INT,DeletedDay INT,DeletedYear INT,DeletedHour INT,DeletedMinute INT,DeletedSecond INT,ServiceId INT,GroupServiceId INT)
								INSERT INTO #DeletedServices (DeletedMonth,DeletedDay,DeletedYear,DeletedHour,DeletedMinute,DeletedSecond,ServiceId,GroupServiceId)
								SELECT MONTH(DeletedDate),Day(DeletedDate),YEAR(DeletedDate),DATEPART(HOUR, DeletedDate),DATEPART(MINUTE, DeletedDate),DATEPART(SECOND, DeletedDate),ServiceId,GroupServiceId FROM Services WHERE GroupServiceId = @GroupServiceId AND (ISNULL(RecordDeleted, 'N') = 'Y')

								IF OBJECT_ID('tempdb..#DeletedGroupServices') IS NOT NULL
									DROP TABLE #DeletedGroupServices
								CREATE TABLE #DeletedGroupServices (DeletedMonth INT,DeletedDay INT,DeletedYear INT,DeletedHour INT,DeletedMinute INT,DeletedSecond INT,GroupServiceId INT)
								INSERT INTO #DeletedGroupServices (DeletedMonth,DeletedDay,DeletedYear,DeletedHour,DeletedMinute,DeletedSecond,GroupServiceId)
								SELECT MONTH(DeletedDate),Day(DeletedDate),YEAR(DeletedDate),DATEPART(HOUR, DeletedDate),DATEPART(MINUTE, DeletedDate),DATEPART(SECOND, DeletedDate),GroupServiceId FROM GroupServices WHERE GroupServiceId = @GroupServiceId AND (ISNULL(RecordDeleted, 'N') = 'Y')
                 
								DECLARE @GroupId INT
								SELECT TOP 1 @GroupId = GroupId FROM GroupServices WHERE GroupServiceId = @GroupServiceId
								IF EXISTS(SELECT 1 FROM Groups where GroupId = @GroupId and ISNULL(UsesAttendanceFunctions,'N') = 'Y')
								BEGIN
									INSERT INTO #Services (ServiceId,GroupServiceId)
									SELECT DISTINCT S.ServiceId,S.GroupServiceId FROM #DeletedServices S JOIN #DeletedGroupServices GS ON S.GroupServiceId = GS.GroupServiceId JOIN Services ON S.ServiceId = Services.ServiceId WHERE S.DeletedMonth = GS.DeletedMonth AND S.DeletedDay = GS.DeletedDay AND S.DeletedYear = GS.DeletedYear AND S.DeletedHour = GS.DeletedHour AND S.DeletedMinute = GS.DeletedMinute AND S.DeletedSecond >= GS.DeletedSecond
								END
								ELSE
								BEGIN
									INSERT INTO #Services (ServiceId,GroupServiceId)
									SELECT ServiceId,GroupServiceId FROM (SELECT ROW_NUMBER() OVER (PARTITION BY Services.GroupServiceId,Services.ClientId ORDER BY Services.ServiceId DESC) AS Row,S.ServiceId,S.GroupServiceId FROM #DeletedServices S JOIN #DeletedGroupServices GS ON S.GroupServiceId = GS.GroupServiceId JOIN Services ON S.ServiceId = Services.ServiceId WHERE S.DeletedMonth = GS.DeletedMonth AND S.DeletedDay = GS.DeletedDay AND S.DeletedYear = GS.DeletedYear AND S.DeletedHour = GS.DeletedHour AND S.DeletedMinute = GS.DeletedMinute AND S.DeletedSecond >= GS.DeletedSecond) AS GetGroupService WHERE Row = 1 ORDER BY ServiceId ASC
								END
							END
							/*******************End deleted group service logic************************************************************************************************************/
      
  /* end inserting into temporary services table */    
  /* Start Inserting into GroupServices */        
                            SET @GroupServiceCounter = ISNULL(( SELECT  NoofOccurrences
                                                                FROM    #Staff
                                                                WHERE   Id = 1
                                                              ), 0);        
                            TRUNCATE TABLE #NewGroupService;        
                            SET @GSCount = 1        
  --select @GroupServiceCounter as '@GroupServiceCounter'    
  --return    
                            WHILE @GSCount <= @GroupServiceCounter
                                BEGIN        
        
                                    INSERT  INTO GroupServices
                                            ( GroupId ,
                                              ProcedureCodeId ,
                                              DateOfService ,
                                              EndDateOfService ,
                                              Unit ,
                                              UnitType ,
                                              ClinicianId ,
                                              AttendingId ,
                                              ProgramId ,
                                              LocationId ,
                                              Status ,
                                              CancelReason ,
                                              Billable ,
                                              Comment        
    --,ExternalReferenceId        
                                              ,
                                              CreatedBy ,
                                              CreatedDate ,
                                              ModifiedBy ,
                                              ModifiedDate        
                                            )
                                    OUTPUT  INSERTED.GroupServiceId
                                            INTO #NewGroupService ( NewGroupServiceId )
                                            SELECT  GroupId ,
                                                    ProcedureCodeId ,
                                                    DateOfService ,
                                                    EndDateOfService ,
                                                    Unit ,
                                                    UnitType ,
                                                    ClinicianId ,
                                                    AttendingId ,
                                                    ProgramId ,
                                                    LocationId ,
                                                    Status ,
                                                    CancelReason ,
                                                    Billable ,
                                                    Comment        
   --,ExternalReferenceId        
                                                    ,
                                                    CreatedBy ,
                                                    @ModifiedDate ,
                                                    ModifiedBy ,
                                                    @ModifiedDate
                                            FROM    GroupServices
                                            WHERE   GroupServiceId = @GroupServiceId
                                                    --JULY 27 2016 Akwinass
                                                    --AND ( ISNULL(RecordDeleted, 'N') = 'N' )        
                 
                 
                 
                                    DELETE  FROM #NewGroupService
                                    WHERE   NewGroupServiceId IS NULL
                 
                 
                                    --SET @NewGroupServiceId = SCOPE_IDENTITY()        
          --select    @NewGroupServiceId as '@NewGroupServiceId'    
   -- Insert all new Group Service Ids in temporary table        
                                    --INSERT  INTO #NewGroupService
                                    --        ( NewGroupServiceId )
                                    --VALUES  ( @NewGroupServiceId )  
                                    
                                    --SELECT  *
                                    --FROM    #NewGroupService      
       
   /* Start inserting into Services */    
   
									
                                    SELECT  @NewGroupServiceId = NewGroupServiceId
                                    FROM    #NewGroupService
									
                                    DECLARE @ServiceCounter INT = 1    
                                    DECLARE @TotalServices INT = ( SELECT   COUNT(*)
                                                                   FROM     #Services
                                                                 )    
       
                                    WHILE @ServiceCounter <= @TotalServices
                                        BEGIN    
                                            DECLARE @OldServiceId INT = ( SELECT    ServiceId
                                                                          FROM      #Services
                                                                          WHERE     id = @ServiceCounter
                                                                        )    
                                            DECLARE @NewServiceId INT;    
       
    --select @ServiceCounter    
                                            INSERT  INTO [Services]
                                                    ( ClientId ,
                                                      GroupServiceId ,
                                                      ProcedureCodeId ,
                                                      DateOfService ,
                                                      EndDateOfService ,
                                                      RecurringService ,
                                                      Unit ,
                                                      UnitType ,
                                                      Status ,
                                                      --CancelReason ,
                                                      ProviderId ,
                                                      ClinicianId ,
                                                      AttendingId ,
                                                      ProgramId ,
                                                      LocationId ,
                                                      Billable ,
                                                      --DiagnosisCode1 ,
                                                      --DiagnosisNumber1 ,
                                                      --DiagnosisVersion1 ,
                                                      --DiagnosisCode2 ,
                                                      --DiagnosisNumber2 ,
                                                      --DiagnosisVersion2 ,
                                                      --DiagnosisCode3 ,
                                                      --DiagnosisNumber3 ,
                                                      --DiagnosisVersion3 ,
                                                      ClientWasPresent ,
                                                      --OtherPersonsPresent ,
                                                      --AuthorizationsApproved ,
                                                      --AuthorizationsNeeded ,
                                                      --AuthorizationsRequested ,
                                                      --Charge ,
                                                      --NumberOfTimeRescheduled ,
                                                      --NumberOfTimesCancelled ,
                                                      --ProcedureRateId ,
                                                      --DoNotComplete ,
                                                      Comment ,
                                                      --Flag1 ,
                                                      --OverrideError ,
                                                      --OverrideBy ,
                                                      ReferringId ,
                                                      --DateTimeIn ,
                                                      --DateTimeOut ,
                                                      NoteAuthorId    
       --,ExternalReferenceId    
                                                      ,
                                                      CreatedBy ,
                                                      CreatedDate ,
                                                      ModifiedBy ,
                                                      ModifiedDate
                                                    )
                                                    SELECT  ClientId ,
                                                            @NewGroupServiceId ,
                                                            ProcedureCodeId ,
                                                            DateOfService ,
                                                            EndDateOfService ,
                                                            'Y' ,
                                                            Unit ,
                                                            UnitType ,
                                                            70 ,	-- Status Scheduled
                                                            --CancelReason ,
                                                            ProviderId ,
                                                            ClinicianId ,
                                                            AttendingId ,
                                                            ProgramId ,
                                                            LocationId ,
                                                            Billable ,
                                                            --DiagnosisCode1 ,
                                                            --DiagnosisNumber1 ,
                                                            --DiagnosisVersion1 ,
                                                            --DiagnosisCode2 ,
                                                            --DiagnosisNumber2 ,
                                                            --DiagnosisVersion2 ,
                                                            --DiagnosisCode3 ,
                                                            --DiagnosisNumber3 ,
                                                            --DiagnosisVersion3 ,
                                                            ClientWasPresent ,
                                                            --OtherPersonsPresent ,
                                                            --AuthorizationsApproved ,
                                                            --AuthorizationsNeeded ,
                                                            --AuthorizationsRequested ,
                                                            --Charge ,
                                                            --NumberOfTimeRescheduled ,
                                                            --NumberOfTimesCancelled ,
                                                            --ProcedureRateId ,
                                                            --DoNotComplete ,
                                                            Comment ,
                                                            --Flag1 ,
                                                            --OverrideError ,
                                                            --OverrideBy ,
                                                            ReferringId ,
                                                            --DateTimeIn ,
                                                            --DateTimeOut ,
                                                            NoteAuthorId ,     
     --ExternalReferenceId,     
                                                            CreatedBy ,
                                                            @ModifiedDate ,
                                                            ModifiedBy ,
                                                            @ModifiedDate
                                                    FROM    Services
                                                    WHERE   GroupServiceId = @GroupServiceId
                                                            AND ServiceId = @OldServiceId
                                                            AND @NewGroupServiceId IS NOT NULL
       
                                            SET @NewServiceId = SCOPE_IDENTITY();      
   /* End inserting into Services */    
       --select @NewServiceId    
   
   /*---------------------------------------------------------------------
   ----------------------Removing copying to recurring items--------------
   
                                            DECLARE @CurrentDocumentVersionId INT    
                                            DECLARE @NewDocumentId INT     
   /* start inserting into Documents table */    
                                            INSERT  INTO Documents
                                                    ( ClientId ,
                                                      ServiceId ,
                                                      GroupServiceId ,
                                                      EventId ,
                                                      ProviderId ,
                                                      DocumentCodeId ,
                                                      InitializedXML ,
                                                      EffectiveDate ,
                                                      DueDate ,
                                                      Status ,
                                                      AuthorId ,
                                                      CurrentDocumentVersionId ,
                                                      DocumentShared ,
                                                      SignedByAuthor ,
                                                      SignedByAll ,
                                                      ToSign ,
                                                      ProxyId ,
                                                      UnderReview ,
                                                      UnderReviewBy ,
                                                      RequiresAuthorAttention ,
                                                      InProgressDocumentVersionId ,
                                                      CurrentVersionStatus
      --,ExternalReferenceId    
                                                      ,
                                                      CreatedBy ,
                                                      CreatedDate ,
                                                      ModifiedBy ,
                                                      ModifiedDate
                                                    )
                                                    SELECT  [ClientId] ,
                                                            @NewServiceId ,
                                                            @NewGroupServiceId ,
                                                            [EventId] ,
                                                            [ProviderId] ,
                                                            [DocumentCodeId] ,
                                                            [InitializedXML] ,
                                                            [EffectiveDate] ,
                                                            [DueDate] ,
                                                            20 ,
                                                            [AuthorId] ,
                                                            [CurrentDocumentVersionId] ,
                                                            [DocumentShared] ,
                                                            [SignedByAuthor] ,
                                                            [SignedByAll] ,
                                                            [ToSign] ,
                                                            [ProxyId] ,
                                                            [UnderReview] ,
                                                            [UnderReviewBy] ,
                                                            [RequiresAuthorAttention] ,
                                                            [InProgressDocumentVersionId] ,
                                                            [CurrentVersionStatus]
     --,[ExternalReferenceId]    
                                                            ,
                                                            [CreatedBy] ,
                                                            @ModifiedDate ,
                                                            [ModifiedBy] ,
                                                            @ModifiedDate
                                                    FROM    [Documents]
                                                    WHERE   GroupServiceId = @GroupServiceId
                                                            AND ServiceId = @OldServiceId
                                                            AND ( ISNULL(ServiceId,
                                                              '') <> '' )
                                                            AND ( ISNULL(ClientId,
                                                              '') <> '' )
                                                            AND ISNULL(RecordDeleted,
                                                              'N') = 'N'    
       
                                            SET @NewDocumentId = SCOPE_IDENTITY()      
                                            SET @CurrentDocumentVersionId = ( SELECT
                                                              CurrentDocumentVersionId
                                                              FROM
                                                              Documents
                                                              WHERE
                                                              DocumentId = @NewDocumentId
                                                              )    
   --select @NewDocumentId as documentid    
   /* end inserting into Documents table */       
       
   /* start inserting into DocumentVersions table */    
                                            INSERT  INTO DocumentVersions
                                                    ( [DocumentId] ,
                                                      [Version] ,
                                                      [EffectiveDate] ,
                                                      [DocumentChanges] ,
                                                      [ReasonForChanges]    
      --,[ExternalReferenceId]    
                                                      ,
                                                      [CreatedBy] ,
                                                      [CreatedDate] ,
                                                      [ModifiedBy] ,
                                                      [ModifiedDate]
                                                    )
                                                    SELECT  @NewDocumentId ,
                                                            Version ,
                                                            EffectiveDate ,
                                                            DocumentChanges ,
                                                            ReasonForChanges    
      --,ExternalReferenceId    
                                                            ,
                                                            CreatedBy ,
                                                            @ModifiedDate ,
                                                            ModifiedBy ,
                                                            @ModifiedDate
                                                    FROM    DocumentVersions
                                                    WHERE   DocumentVersionId = @CurrentDocumentVersionId
                                                            AND ISNULL(RecordDeleted,
                                                              'N') = 'N'    
       
       
                                            DECLARE @NewDocumentVersionId INT = SCOPE_IDENTITY()      
       
   /* start update Document table */    
                                            UPDATE  Documents
                                            SET     CurrentDocumentVersionId = @NewDocumentVersionId ,
                                                    InProgressDocumentVersionId = @NewDocumentVersionId
                                            WHERE   DocumentId = @NewDocumentId    
   /* end update Document table */    
       
   --select @NewDocumentVersionId as 'NewDocumentVersionId'    
   /* end inserting into DocumentVersions table */      
       
   /* start inserting into DocumentSignatures table */    
                                            INSERT  INTO DocumentSignatures
                                                    ( [DocumentId] ,
                                                      [SignedDocumentVersionId] ,
                                                      [StaffId] ,
                                                      [ClientId] ,
                                                      [IsClient] ,
                                                      [RelationToClient] ,
                                                      [RelationToAuthor] ,
                                                      [SignerName] ,
                                                      [SignatureOrder] ,
                                                      [SignatureDate] ,
                                                      [VerificationMode] ,
                                                      [PhysicalSignature] ,
                                                      [DeclinedSignature] ,
                                                      [ClientSignedPaper]    
      --,[ExternalReferenceId]    
                                                      ,
                                                      [CreatedBy] ,
                                                      [CreatedDate] ,
                                                      [ModifiedBy] ,
                                                      [ModifiedDate]
                                                    )
                                                    SELECT  @NewDocumentId ,
                                                            @NewDocumentVersionId ,
                                                            StaffId ,
                                                            ClientId ,
                                                            IsClient ,
                                                            RelationToClient ,
                                                            RelationToAuthor ,
                                                            SignerName ,
                                                            SignatureOrder ,
                                                            SignatureDate ,
                                                            VerificationMode ,
                                                            PhysicalSignature ,
                                                            DeclinedSignature ,
                                                            ClientSignedPaper    
    --,ExternalReferenceId    
                                                            ,
                                                            CreatedBy ,
                                                            @ModifiedDate ,
                                                            ModifiedBy ,
                                                            @ModifiedDate
                                                    FROM    DocumentSignatures
                                                    WHERE   SignedDocumentVersionId = @CurrentDocumentVersionId
                                                            AND ISNULL(RecordDeleted,
                                                              'N') = 'N'    
   /* end inserting into DocumentSignatures table */     
   
   
   
   ----------------------Removing copying to recurring items--------------
   ---------------------------------------------------------------------*/
   
   
   
   
   --select 'DocumentSignatures'    
   --select @ServiceCounter as 'ServiceCounter'    
                                            SET @ServiceCounter = @ServiceCounter + 1    
                                        END    
     /* end */        
     --select @GSCount as 'GSCount'    
                                    SET @GSCount = @GSCount + 1;        
                                END        
       /* End Inserting into GroupServices */        
                     
       /*Start Inserting into Appointments table */        
                            SET @TotalStaff = ( SELECT  COUNT(*)
                                                FROM    #Staff
                                              );        
                            SET @StaffCounter = 1;        
                            WHILE @StaffCounter <= @TotalStaff
                                BEGIN        
          
          
      --select @StaffCounter as 'StaffCounter'    
      --select @TotalStaff    
                                    DECLARE @StaffId INT        
                                    SET @StaffId = ( SELECT StaffId
                                                     FROM   #Staff
                                                     WHERE  Id = @StaffCounter
                                                   );        
              
      /* Start Selecting into temporary appointments for particular staff*/        
       
                                    TRUNCATE TABLE #TempAppointMents;        
                                    INSERT  INTO #TempAppointMents
                                            ( AppointmentId ,
                                              StaffId ,
                                              Subject ,
                                              StartTime ,
                                              EndTime ,
                                              AppointmentType ,
                                              ShowTimeAs ,
                                              LocationId ,
                                              SpecificLocation ,
                                              ServiceId ,
                                              GroupServiceId ,
                                              AppointmentProcedureGroupId ,
                                              RecurringAppointment ,
                                              RecurringDescription ,
                                              RecurringAppointmentId ,
                                              RecurringServiceId ,
                                              RecurringGroupServiceId ,
                                              CreatedBy ,
                                              CreatedDate ,
                                              ModifiedBy ,
                                              ModifiedDate
                                            )
                                            SELECT  AppointmentId ,
                                                    StaffId ,
                                                    Subject ,
                                                    StartTime ,
                                                    EndTime ,
                                                    AppointmentType ,
                                                    ShowTimeAs ,
                                                    LocationId ,
                                                    SpecificLocation ,
                                                    ServiceId ,
                                                    GroupServiceId ,
                                                    AppointmentProcedureGroupId ,
                                                    RecurringAppointment ,
                                                    RecurringDescription ,
                                                    RecurringAppointmentId ,
                                                    RecurringServiceId ,
                                                    RecurringGroupServiceId ,
                                                    CreatedBy ,
                                                    CreatedDate ,
                                                    ModifiedBy ,
                                                    ModifiedDate
                                            FROM    dbo.Appointments
                                            WHERE   ( StaffId = @StaffId )     
    --AND (GroupServiceId = @GroupServiceId)     
                                                    AND ( RecurringGroupServiceId = @RecurringGroupServiceId )
                                                    AND ( ISNULL(RecordDeleted, 'N') = 'N' )
                                                    AND ( StartTime >= @LastDateOfService
                                                          AND EndTime <= @EndDateOfService
                                                        )
                                                    AND ISNULL(GroupServiceId, 0) = 0     
        
   /* End Selecting into temporary appointments for particular staff*/        
      --select * from  #TempAppointMents      
      --ROLLBACK TRAN        
      --return    
                                    DECLARE @TotalAppointment INT        
                                    SET @TotalAppointment = ( SELECT    COUNT(*)
                                                              FROM      #TempAppointMents
                                                            );        
                                    DECLARE @Appointmentcount INT        
                                    SET @Appointmentcount = 1      
      --declare @NewServicesId int =(select TOP 1 ServiceId from Services where GroupServiceId= (select NewGroupServiceId from #NewGroupService where Id=1))      
                                    WHILE @Appointmentcount <= @TotalAppointment
                                        BEGIN        
  --select @TotalAppointment as 'TotalAppointment'    
                                            DECLARE @NewGroupServicesId INT      
                                           
                                         --   SELECT * FROM #NewGroupService
                                           
 --select NewGroupServiceId from #NewGroupService    
                                            SET @NewGroupServicesId = ( SELECT  NewGroupServiceId
                                                                        FROM    #NewGroupService
                                                                        WHERE   Id = @Appointmentcount
                                                                      );        
  --select @NewGroupServicesId as 'NewGroupServicesId'    
                                            DECLARE @OldAppointmentId INT        
                                            SET @OldAppointmentId = ( SELECT    AppointmentId
                                                                      FROM      #TempAppointMents
                                                                      WHERE     Id = @Appointmentcount
                                                                    );        
      
                                            DECLARE @NewDateOfService DATETIME= ( SELECT    StartTime
                                                                                  FROM      Appointments
                                                                                  WHERE     AppointmentId = @OldAppointmentId
                                                                                );     
                                            DECLARE @NewEndDateOfService DATETIME= ( SELECT EndTime
                                                                                     FROM   Appointments
                                                                                     WHERE  AppointmentId = @OldAppointmentId
                                                                                   );     
                                                              
  --select @OldAppointmentId as 'OldAppointmentId'    
  --select ServiceId from Services where GroupServiceId in( select NewGroupServiceId from #NewGroupService)    
        --select * from #Services    
        --select @NewServicesId as 'NewServicesId'    
           
      /* Wasif Butt - Code section replaced
                                            UPDATE  AppointMents         
										    --set ServiceId=@NewServicesId,     
                                            SET     GroupServiceId = @NewGroupServicesId ,
                                                    Subject = Subject ,
                                                    LocationId = LocationId ,
                                                    SpecificLocation = SpecificLocation ,
                                                    ModifiedDate = @ModifiedDate
                                            FROM    #TempAppointMents
                                            WHERE   AppointmentId = @OldAppointmentId ;     
                                                    
         Wasif Butt - End */                        

                                            UPDATE  a
                                            SET     a.GroupServiceId = @NewGroupServicesId ,
                                                    a.Subject = ta.Subject ,
                                                    a.LocationId = ta.LocationId ,
                                                    a.SpecificLocation = ta.SpecificLocation ,
                                                    a.ModifiedDate = @ModifiedDate
                                            FROM    dbo.Appointments a
                                                    INNER JOIN #TempAppointMents ta ON ta.AppointmentId = a.AppointmentId
                                            WHERE   ta.AppointmentId = @OldAppointmentId;

                                                       
       /* end deleting from Appointments table */      
/*  Insert for exchange sync	*/
                                            IF EXISTS ( SELECT  *
                                                        FROM    sys.objects
                                                        WHERE   object_id = OBJECT_ID(N'[dbo].[ExternalAppointmentQueue]')
                                                                AND type IN ( N'U' ) )
                                                BEGIN
                                                    INSERT  INTO dbo.ExternalAppointmentQueue
                                                            ( CreatedBy ,
                                                              CreatedDate ,
                                                              ModifiedBy ,
                                                              ModifiedDate ,
                                                              AppointmentId ,
                                                              Action 
                                                            )
                                                            SELECT  CreatedBy ,
                                                                    CreatedDate ,
                                                                    ModifiedBy ,
                                                                    @ModifiedDate ,
                                                                    AppointmentId ,
                                                                    'U'
                                                            FROM    #TempAppointMents
                                                            WHERE   AppointmentId = @OldAppointmentId
                                                    
                                                END
/*  End Insert for exchange sync	*/
           
       /* start updating DateOfService and EnddateofService */    
                                            UPDATE  GroupServices
                                            SET     DateOfService = @NewDateOfService ,
                                                    EndDateOfService = @NewEndDateOfService
                                            WHERE   GroupServiceId = @NewGroupServicesId    
      
                                            UPDATE  Services
                                            SET     DateOfService = @NewDateOfService ,
                                                    EndDateOfService = @NewEndDateOfService
                                            WHERE   GroupServiceId = @NewGroupServicesId    
      
                                            UPDATE  Documents
                                            SET     EffectiveDate = @NewDateOfService
                                            WHERE   GroupServiceId = @NewGroupServicesId    
       /* end updating DateOfService and EnddateofService */    
           
             
           --SELECT @OldAppointmentId AS 'OldAppointmentId'    
                                            SET @Appointmentcount = @Appointmentcount + 1;     
       --SET @NewServicesId =@NewServicesId+1    
                                        END         
                                    SET @StaffCounter = @StaffCounter + 1;        
                                END        
     /* End Inserting into Appointments table */        
             
                            DECLARE @NewGroupServiceCount INT = ( SELECT    COUNT(*)
                                                                  FROM      #NewGroupService
                                                                );        
                            DECLARE @NewGroupServiceCounter INT= 1      
                            WHILE @NewGroupServiceCounter <= @NewGroupServiceCount
                                BEGIN        
                                    SET @NewGroupServiceId = ( SELECT   NewGroupServiceId
                                                               FROM     #NewGroupService
                                                               WHERE    Id = @NewGroupServiceCounter
                                                             );        
                                    DECLARE @DateOfService DATETIME= ( SELECT   DateOfService
                                                                       FROM     GroupServices
                                                                       WHERE    GroupServiceId = @NewGroupServiceId
                                                                     );     
                                    DECLARE @EndDateOfServices DATETIME= ( SELECT   EndDateOfService
                                                                           FROM     GroupServices
                                                                           WHERE    GroupServiceId = @NewGroupServiceId
                                                                         );     
       /* start inserting into GroupServiceStaff Tables */    
                                    INSERT  INTO GroupServiceStaff
                                            ( [GroupServiceId] ,
                                              [StaffId] ,
                                              [Unit] ,
                                              [UnitType] ,
                                              [EndDateOfService] ,
                                              [DateOfService] ,
                                              [CreatedBy] ,
                                              [CreatedDate] ,
                                              [ModifiedBy] ,
                                              [ModifiedDate]
                                            )
                                            SELECT  @NewGroupServiceId ,
                                                    StaffId ,
                                                    Unit ,
                                                    UnitType ,
                                                    @EndDateOfServices ,
                                                    @DateOfService ,
                                                    CreatedBy ,
                                                    @ModifiedDate ,
                                                    ModifiedBy ,
                                                    @ModifiedDate
                                            FROM    RecurringGroupServiceStaff
                                            WHERE   RecurringGroupServiceId = @RecurringGroupServiceId    
     /* end inserting into */    
           
       /* start inserting into RecurringGroupServicesProcessLog */        
                                    INSERT  INTO RecurringGroupServicesProcessLog
                                            ( RecurringGroupServiceId ,
                                              GroupServiceId ,
                                              CreatedBy ,
                                              CreatedDate ,
                                              ModifiedBy ,
                                              ModifiedDate
                                            )
                                            SELECT  RecurringGroupServiceId ,
                                                    @NewGroupServiceId ,
                                                    CreatedBy ,
                                                    @ModifiedDate ,
                                                    ModifiedBy ,
                                                    @ModifiedDate
                                            FROM    RecurringGroupServicesProcessLog
                                            WHERE   GroupServiceId = @GroupServiceId
                                                    AND RecurringGroupServiceId = @RecurringGroupServiceId
                                                    AND ( ISNULL(RecordDeleted, 'N') = 'N' )      
          
      --SELECT @NewGroupServiceCounter AS 'NewGroupServiceCounter'    
          
                                    SET @NewGroupServiceCounter = @NewGroupServiceCounter + 1        
                                END        
     /* end inserting into RecurringGroupServicesProcessLog */        
           
         
                            IF ( @EndDateOfService >= @RecurrenceEndDate )
                                BEGIN    
  /* start set processed flag to 'Y' when completed */    
                                    UPDATE  RecurringGroupServices
                                    SET     Processed = 'Y' ,
                                            LastDateOfService = @LastDateOfService
                                    WHERE   RecurringGroupServiceId = @RecurringGroupServiceId     
  /* end set processed flag to 'Y' when completed */    
      
  /* start deleting from RecurringGroupServicesUnprocessed */        
                                    UPDATE  RecurringGroupServicesUnprocessed
                                    SET     RecordDeleted = 'Y'
                                    WHERE   RecurringGroupServiceId = @RecurringGroupServiceId        
     --delete from RecurringGroupServicesUnprocessed where RecurringGroupServiceId=@RecurringGroupServiceId        
     /* end deleting from RecurringGroupServicesUnprocessed */        
                                END    
                            ELSE
                                BEGIN    
  /* start set new lastdateofservice */    
                                    UPDATE  RecurringGroupServices
                                    SET     LastDateOfService = @LastDateOfService
                                    WHERE   RecurringGroupServiceId = @RecurringGroupServiceId     
  /* end set new lastdateofservice */    
                                END    
         
         
                            SET @Counter = @Counter + 1;        
                        END        
                END        
        
            COMMIT TRAN     
 --ROLLBACK TRAN       
            RETURN             
        END TRY        
        BEGIN CATCH        
            ROLLBACK TRAN    
            
            
            SELECT  ERROR_MESSAGE() AS ErrorMessage    
--            RAISERROR        
--(                                   
--  'Failed to execute ssp_PMProcessRecurringGroupservices', -- Message text.                                                                                    
--  16, -- Severity.                                                                                    
--  1 -- State.                                                                                    
-- ) ;                                                                                    
        END CATCH        
    END 



GO


