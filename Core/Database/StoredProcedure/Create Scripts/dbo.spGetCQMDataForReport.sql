IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'spGetCQMDataForReport')
                    AND type IN ( N'P', N'PC' ) )
    BEGIN
        DROP PROCEDURE spGetCQMDataForReport;
    END;
                    GO

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

CREATE PROCEDURE [dbo].[spGetCQMDataForReport]
    @type VARCHAR(255) ,  -- 'ep' or 'eh'
    @providerNPI VARCHAR(50) ,   -- this is whatever id is used to identify a physician in your system
    @startDate DATETIME ,      -- start date of the reporting period
    @stopDate DATETIME ,      -- end date of the reporting period
    @practiceID VARCHAR(255)   -- ExternalPracticeID
	WITH RECOMPILE
AS /******************************************************************************
**		File: Database\Modules\CQMSolutions\StoredProcedures
**		Name: [spGetCQMDataForReport]
**		Desc: 
**
**		Called by: dbo.spGetCQMDataForReport
**
**		Auth: jcarlson
**		Date: 2/1/2018
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:	 		   Description:
**		--------		--------			   ------------------------------------------
**        2/1/2018       jcarlson               created comment header
**												added batching logic
**		03/26/2018		jcarlson				removed CQM Testing logic
*******************************************************************************/
    BEGIN
        SET NOCOUNT ON;
    --Create Batch
        DECLARE @BatchId INT = 0;
        INSERT  INTO CQMSolution.StagingCQMDataBatches
                ( [Type] ,
                  ProviderNPI ,
                  StartDate ,
                  StopDate ,
                  PracticeID ,
                  Processed ,
                  BatchCreatedDate
                )
                SELECT  @type ,
                        @providerNPI ,
                        @startDate ,
                        @stopDate ,
                        @practiceID ,
                        0 ,
                        GETDATE();
    
        SELECT  @BatchId = SCOPE_IDENTITY();
		CREATE TABLE #Clinicians (
		StaffId INT PRIMARY KEY
		)
				
		DECLARE @providerId INT;
		SELECT @providerId = StaffId
		FROM dbo.Staff
		WHERE StaffId = @providerNPI
		AND ISNULL(RecordDeleted,'N')='N'

		INSERT INTO #Clinicians
		        ( StaffId )
		SELECT @providerId

     
	 CREATE TABLE #Services (
	 ServiceId INT PRIMARY KEY,
	 DateOfService DATETIME,
	 EndDateOfService DATETIME,
	 ProcedureCodeId INT,
	 LocationId INT,
	 ClientId INT,
	 ClinicianId INT,
	 ProgramId INT,
	 [Status] INT,
	 CancelReason INT
	 )

	 INSERT INTO #Services
	         ( ServiceId ,
	           DateOfService ,
	           EndDateOfService ,
	           ProcedureCodeId ,
	           LocationId ,
	           ClientId ,
	           ClinicianId ,
	           ProgramId ,
	           [Status] ,
	           CancelReason
	         )
SELECT    s.ServiceId, s.DateOfService, s.EndDateOfService, s.ProcedureCodeId, s.LocationId, s.ClientId, s.ClinicianId, s.ProgramId, s.[Status],
                s.CancelReason
      FROM      Services AS s
      WHERE     ( ( s.DateOfService >= @startDate
                AND s.DateOfService <= @stopDate )
			 or ( s.DateOfService >= DateAdd(month,-13,@StartDate) ) )
                AND ISNULL(s.RecordDeleted, 'N') = 'N'
                AND @type = 'EP'
                AND EXISTS ( SELECT st.StaffId
                             FROM #Clinicians AS st
							 WHERE st.StaffId = s.ClinicianId
							 )
      UNION
      SELECT    s.ServiceId, s.DateOfService, s.EndDateOfService, s.ProcedureCodeId, s.LocationId, s.ClientId, s.ClinicianId, s.ProgramId, s.[Status],
                s.CancelReason
      FROM      Services AS s
      WHERE     ( ( s.DateOfService >= @startDate
                AND s.DateOfService <= @stopDate )
			 or ( s.DateOfService >= DateAdd(month,-13,@StartDate) ) )
                AND ISNULL(s.RecordDeleted, 'N') = 'N'
                AND EXISTS ( SELECT 1
                             FROM   dbo.ClientInpatientVisits AS civ
                             WHERE  ISNULL(civ.RecordDeleted, 'N') = 'N'
                                    AND civ.ClientId = s.ClientId
                                    AND CONVERT(DATE, civ.AdmitDate) <= CONVERT(DATE, s.DateOfService)
                                    AND ( CONVERT(DATE, civ.DischargedDate) >= CONVERT(DATE, s.DateOfService)
                                          OR civ.DischargedDate IS NULL
                                        ) )
                AND @type = 'EH'
                AND EXISTS ( SELECT st.StaffId
                             FROM #Clinicians AS st
							 WHERE st.StaffId = s.ClinicianId
							 )

        EXEC [CQMSolution].[Participiant] @type, @providerNPI, @startDate, @stopDate,
            @practiceID, @BatchId;
    -- Author
        EXEC [CQMSolution].[Author] @type, @providerNPI, @startDate, @stopDate,
            @practiceID, @BatchId;

    -- DocOf
        EXEC [CQMSolution].[DocOf] @type, @providerNPI, @startDate, @stopDate,
            @practiceID, @BatchId;

    -- Communication
        EXEC [CQMSolution].[Communication] @type, @providerNPI, @startDate,
            @stopDate, @practiceID, @BatchId;

    -- Device
        EXEC [CQMSolution].[Device] @type, @providerNPI, @startDate, @stopDate,
            @practiceID, @BatchId;

    -- Problem
        EXEC [CQMSolution].[Problem] @type, @providerNPI, @startDate,
            @stopDate, @practiceID, @BatchId;

    -- Diagnostic Study
        EXEC [CQMSolution].[DiagnosticStudy] @type, @providerNPI, @startDate,
            @stopDate, @practiceID, @BatchId;

    --Encounter
        EXEC [CQMSolution].[Encounter] @type, @providerNPI, @startDate,
            @stopDate, @practiceID, @BatchId;

    -- Medication
        EXEC [CQMSolution].[Medication] @type, @providerNPI, @startDate,
            @stopDate, @practiceID, @BatchId;

    -- Intervention
        EXEC [CQMSolution].[Intervention] @type, @providerNPI, @startDate,
            @stopDate, @practiceID, @BatchId;

    -- Laboratory Test
        EXEC [CQMSolution].[LaboratoryTest] @type, @providerNPI, @startDate,
            @stopDate, @practiceID, @BatchId;

    -- Physical Exam
        EXEC [CQMSolution].[PhysicalExam] @type, @providerNPI, @startDate,
            @stopDate, @practiceID, @BatchId;

    -- Procedure
        EXEC [CQMSolution].[Procedure] @type, @providerNPI, @startDate,
            @stopDate, @practiceID, @BatchId;

    -- Risk Category
        EXEC [CQMSolution].[Assessment] @type, @providerNPI, @startDate,
            @stopDate, @practiceID, @BatchId;
    
    -- Social History
        EXEC [CQMSolution].[SocialHistory] @type, @providerNPI, @startDate,
            @stopDate, @practiceID, @BatchId;

    -- Transfer
        EXEC [CQMSolution].[Transfer] @type, @providerNPI, @startDate,
            @stopDate, @practiceID, @BatchId;

    /* Always run patient characteristic and client last since those sp look at the data in staging table to determine
       what clients to extract */

    --  Patient Characteristic
        EXEC [CQMSolution].[Patientcharacteristic] @type, @providerNPI,
            @startDate, @stopDate, @practiceID, @BatchId;

    -- Client 
        EXEC [CQMSolution].[Client] @type, @providerNPI, @startDate, @stopDate,
            @practiceID, @BatchId;

	
        SELECT  [lngId] ,
                [CLIENT_ID] ,
                [REC_TYPE] ,
                [SEC_TYPE] ,
                [D001] ,
                [D002] ,
                [D003] ,
                [D004] ,
                [D005] ,
                [D006] ,
                [D007] ,
                [D008] ,
                [D009] ,
                [D010] ,
                [D011] ,
                [D012] ,
                [D013] ,
                [D014] ,
                [D015] ,
                [D016] ,
                [D017] ,
                [D018] ,
                [D019] ,
                [D020] ,
                [D021] ,
                [D022] ,
                [D023] ,
                [D024] ,
                [D025] ,
                [D026] ,
                [D027] ,
                [D028] ,
                [D029] ,
                [D030] ,
                [D031] ,
                [D032] ,
                [D033] ,
                [D034] ,
                [D035] ,
                [D036] ,
                [D037] ,
                [D038] ,
                [D039] ,
                [D040] ,
                [D041] ,
                [D042] ,
                [D043] ,
                [D044] ,
                [D045] ,
                [D046] ,
                [D047] ,
                [D048] ,
                [D049] ,
                [D050] ,
                [ValueSetOID] ,
                [IDRoot]  --If it is not provided the default values will be created by application
                ,
                [IDExtension] --If it is not provided the default values will be created by application
                ,
                [ACCOUNT_NUMBER] -- (CAN BE OPTIONAL IF YOU DO NOT WANT TO POPULATE)
        FROM    [CQMSolution].[StagingCQMData] AS a
        WHERE   a.StagingCQMDataBatchId = @BatchId;

        UPDATE  CQMSolution.StagingCQMDataBatches
        SET     Processed = 1
        WHERE   StagingCQMDataBatchId = @BatchId;


    --Add logic to delete from Both Tables... wrap in system configuration key

        DECLARE @RemoveStageData VARCHAR(1) = ISNULL(NULLIF(dbo.ssf_GetSystemConfigurationKeyValue('CQMSolutionRemoveStageData'),
                                                            ''), 'Y'); --default value is yes
    
        IF ( @RemoveStageData = 'Y' )
            BEGIN
                DELETE  FROM a
                FROM    CQMSolution.StagingCQMData AS a
                WHERE   a.StagingCQMDataBatchId = @BatchId;

                DELETE  FROM a
                FROM    CQMSolution.StagingCQMDataBatches AS a
                WHERE   a.StagingCQMDataBatchId = @BatchId;
            END;
    END; 					


GO

