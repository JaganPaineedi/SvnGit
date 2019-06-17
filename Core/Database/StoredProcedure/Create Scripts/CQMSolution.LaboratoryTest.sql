/****** Object:  StoredProcedure [CQMSolution].[LaboratoryTest]    Script Date: 01-02-2018 11:56:02 ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[CQMSolution].[LaboratoryTest]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [CQMSolution].[LaboratoryTest];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE PROCEDURE [CQMSolution].[LaboratoryTest]
    @type VARCHAR(255) ,-- 'ep' or 'eh'
    @providerNPI VARCHAR(50) ,-- this is whatever id is used to identify a physician in your system
    @startDate DATETIME ,-- start date of the reporting period
    @stopDate DATETIME ,-- end date of the reporting period
    @practiceID VARCHAR(255) , -- ExternalPracticeID
    @batchId INT
	WITH RECOMPILE
AS /******************************************************************************
**		File: Database\Modules\CQMSolutions\StoredProcedures
**		Name: [CQMSolution].[LaboratoryTest]
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
**									   changed ssf_GetServices to exist from Join to prevent duplicates
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
                    CLIENT_ID = CO.ClientId ,
                    REC_TYPE = 'CQM' ,
                    SEC_TYPE = 'TESTRESULT' ,
                    D001 = NULL ,
                    D002 = NULL ,
                    D003 = H.LoincCode ,
                    D004 = H.TemplateName ,
                    D005 = COO.Value ,
                    D006 = O.Unit ,
                    D007 = NULL ,
                    D008 = NULL ,
                    D009 = NULL ,
                    D010 = NULL ,
                    D011 = NULL ,
                    D012 = dbo.[GetDateFormatForLabSoft](CO.OrderStartDateTime,
                                                         '|^~\&') ,
                    D013 = dbo.[GetDateFormatForLabSoft](CO.OrderStartDateTime,
                                                         '|^~\&') ,
                    D014 = '2.16.840.1.113883.6.1' ,
                    D015 = 'LOINC' ,
                    D016 = 'PRF' ,
                    D017 = COO.Flag ,
                    D018 = COO.FlagText ,
                    D019 = O.ValueType ,
                    D020 = '2.16.840.1.113883.6.96' ,
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
                    ACCOUNT_NUMBER = CO.ClientOrderId
            FROM    ClientOrders CO
                    JOIN Clients C ON C.ClientId = CO.ClientId
                    LEFT JOIN ClientOrderResults COR ON CO.ClientOrderId = COR.ClientOrderId
                                                        AND ISNULL(COR.RecordDeleted,
                                                              'N') = 'N'
                    LEFT JOIN ClientOrderObservations COO ON COR.ClientOrderResultId = COO.ClientOrderResultId
                                                             AND ISNULL(COO.RecordDeleted,
                                                              'N') = 'N'
                    LEFT JOIN Observations O ON O.ObservationId = COO.ObservationId
                                                AND ISNULL(O.RecordDeleted,
                                                           'N') = 'N'
                    LEFT JOIN Orders Ord ON Ord.OrderId = CO.OrderId
                    LEFT JOIN HealthDataTemplates H ON H.HealthDataTemplateId = Ord.LabId
					JOIN #Clinicians AS st ON co.OrderedBy = st.StaffId
            WHERE   ISNULL(CO.RecordDeleted, 'N') = 'N'
                    AND ISNULL(C.RecordDeleted, 'N') = 'N'
                    AND NOT EXISTS ( SELECT *
                                     FROM   OrderQuestions OQ
                                            JOIN ClientOrderQnAnswers COQ ON COQ.QuestionId = OQ.QuestionId
                                            JOIN GlobalCodes GC ON GC.GlobalCodeId = COQ.AnswerValue
                                                              AND GC.Category = 'XORDERTYPE'
                                     WHERE  OQ.OrderId = CO.OrderId
                                            AND OQ.Question = 'Specify the Order Type' )
                    AND EXISTS ( SELECT 1
                                 FROM   #Services AS a
                                 WHERE  a.ClientId = CO.ClientId );

GO

