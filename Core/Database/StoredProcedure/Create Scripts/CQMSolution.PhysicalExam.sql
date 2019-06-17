/****** Object:  StoredProcedure [CQMSolution].[PhysicalExam]    Script Date: 01-02-2018 12:14:31 ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[CQMSolution].[PhysicalExam]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [CQMSolution].[PhysicalExam];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE PROCEDURE [CQMSolution].[PhysicalExam]
    @type VARCHAR(255) ,  -- 'ep' or 'eh'
    @providerNPI VARCHAR(50) ,   -- this is whatever id is used to identify a physician in your system
    @startDate DATETIME ,      -- start date of the reporting period
    @stopDate DATETIME ,      -- end date of the reporting period
    @practiceID VARCHAR(255) ,   -- ExternalPracticeID
    @batchId INT
	WITH RECOMPILE
AS /******************************************************************************
**		File: Database\Modules\CQMSolutions\StoredProcedures
**		Name: [CQMSolution].[PhysicalExam]
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
**									   added batching logic
**									   updated logic to use new ssf_GetServices function instead of type specific functions
*******************************************************************************/
    INSERT  INTO [CQMSolution].[StagingCQMData]
            ( [StagingCQMDataBatchId] ,
              [lngId] ,
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
              [IDRoot] ,
              [IDExtension] ,
              [ACCOUNT_NUMBER]
            )
            SELECT distinct @batchId ,
                    lngId = NULL ,
                    CLIENT_ID = CHDA.ClientId ,
                    REC_TYPE = 'CQM' ,
                    SEC_TYPE = 'PHYSICALEXAM' ,
                    D001 = NULL ,
                    D002 = HDA.LOINCCode ,
                    D003 = HDA.Description ,
                    D004 = '2.16.840.1.113883.6.1' ,
                    D005 = 'LOINC' ,
                    D006 = dbo.[GetDateFormatForLabSoft](CHDA.HealthRecordDate,
                                                         '|^~\&') ,
                    D007 = dbo.[GetDateFormatForLabSoft](CHDA.HealthRecordDate,
                                                         '|^~\&') ,
                    D008 = 'PRF' ,
                    D009 = NULL ,
                    D010 = NULL ,
                    D011 = NULL ,
                    D012 = NULL ,
                    D013 = CHDA.Value ,
                    D014 = GC.CodeName ,
                    D015 = NULL ,
                    D016 = '2.16.840.1.113883.6.96' ,
                    D017 = O.ValueType ,
                    D018 = NULL ,
                    D019 = NULL ,
                    D020 = NULL ,
                    D021 = NULL ,
                    D022 = NULL ,
                    D023 = NULL ,
                    D024 = NULL ,
                    D025 = NULL ,
                    D026 = NULL ,
                    D027 = NULL ,
                    D028 = NULL ,
                    D029 = NULL ,
                    D030 = NULL ,
                    D031 = NULL ,
                    D032 = NULL ,
                    D033 = NULL ,
                    D034 = NULL ,
                    D035 = NULL ,
                    D036 = NULL ,
                    D037 = NULL ,
                    D038 = NULL ,
                    D039 = NULL ,
                    D040 = NULL ,
                    D041 = NULL ,
                    D042 = NULL ,
                    D043 = NULL ,
                    D044 = NULL ,
                    D045 = NULL ,
                    D046 = NULL ,
                    D047 = NULL ,
                    D048 = NULL ,
                    D049 = NULL ,
                    D050 = NULL ,
                    ValueSetOID = NULL ,
                    IDRoot = NULL ,
                    IDExtension = NULL ,
                    ACCOUNT_NUMBER = CHDA.ClientHealthDataAttributeId
                    FROM    ClientHealthDataAttributes CHDA
                    JOIN HealthDataAttributes HDA ON HDA.HealthDataAttributeId = CHDA.HealthDataAttributeId
                    JOIN Observations O ON O.ObservationMethodIdentifier = HDA.LOINCCode
                    JOIN Clients C ON C.ClientId = CHDA.ClientId
                    JOIN GlobalCodes GC ON GC.GlobalCodeId = HDA.Units
            WHERE   ISNULL(CHDA.RecordDeleted, 'N') = 'N'
                    AND ISNULL(HDA.RecordDeleted, 'N') = 'N'
                    AND ISNULL(C.RecordDeleted, 'N') = 'N'
                    AND ISNULL(O.RecordDeleted, 'N') = 'N'
                    AND CONVERT(DATE, CHDA.HealthRecordDate) >= CONVERT(DATE, @startDate)
                    AND CONVERT(DATE, CHDA.HealthRecordDate) <= CONVERT(DATE, @stopDate)
                    AND HDA.HealthDataAttributeId IN ( 110, 111, 112, 113, 116 )
                    AND EXISTS ( SELECT 1
                                 FROM   #Services AS a
                                 WHERE  a.ClientId = CHDA.ClientId )
            ORDER BY CHDA.ClientId;


GO

