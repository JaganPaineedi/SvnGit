/****** Object:  StoredProcedure [CQMSolution].[RiskCategory]    Script Date: 01-02-2018 12:15:46 ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[CQMSolution].[RiskCategory]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [CQMSolution].[RiskCategory];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE PROCEDURE [CQMSolution].[RiskCategory]
    @type VARCHAR(255) ,  -- 'ep' or 'eh'
    @providerNPI VARCHAR(50) ,   -- this is whatever id is used to identify a physician in your system
    @startDate DATETIME ,      -- start date of the reporting period
    @stopDate DATETIME ,      -- end date of the reporting period
    @practiceID VARCHAR(255) ,   -- ExternalPracticeID
    @batchId INT
	WITH RECOMPILE
AS /******************************************************************************
**		File: Database\Modules\CQMSolutions\StoredProcedures
**		Name: [CQMSolution].[RiskCategory]
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
            SELECT  @batchId ,
                    lngId = NULL ,
                    CLIENT_ID = D.ClientId ,
                    REC_TYPE = 'CQM' ,
                    SEC_TYPE = 'RISKCATEGORY' ,
                    D001 = NULL ,
                    D002 = '44261-6' -- LOINC CODE
                    ,
                    D003 = DC.DocumentName -- DOCUMENT NAME 
                    ,
                    D004 = '2.16.840.1.113883.6.1' ,
                    D005 = 'LOINC' ,
                    D006 = D.EffectiveDate -- EFFECTIVEDATE
                    ,
                    D007 = D.EffectiveDate -- EFFECTIVEDATE
                    ,
                    D008 = CASE WHEN D.DocumentId IS NULL THEN 'RCTGND'
                                ELSE 'RCTG'
                           END
                    ,
                    D009 = p.TotalScore -- SCORE
                    ,
                    D010 = NULL ,
                    D011 = NULL ,
                    D012 = NULL ,
                    D013 = NULL ,
                    D014 = NULL ,
                    D015 = NULL ,
                    D016 = NULL ,
                    D017 = NULL ,
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
                    ValueSetOID = '2.16.840.1.113883.3.600.1.462' ,
                    IDRoot = NULL ,
                    IDExtension = NULL ,
                    ACCOUNT_NUMBER = D.DocumentId
            FROM    #Services AS a
                    LEFT JOIN Documents D ON a.ClientId = D.ClientId
                                             AND ISNULL(D.RecordDeleted, 'N') = 'N'
                                             AND D.Status = 22
                    JOIN PHQ9ADocuments p ON p.DocumentVersionId = D.CurrentDocumentVersionId
                                             AND ISNULL(p.RecordDeleted, 'N') = 'N'
                    JOIN DocumentCodes DC ON D.DocumentCodeId = DC.DocumentCodeId
                                             AND ISNULL(DC.RecordDeleted, 'N') = 'N'
            UNION
            SELECT  @batchId ,
                    lngId = NULL ,
                    CLIENT_ID = D.ClientId ,
                    REC_TYPE = 'CQM' ,
                    SEC_TYPE = 'RISKCATEGORY' ,
                    D001 = NULL ,
                    D002 = '44261-6' -- LOINC CODE
                    ,
                    D003 = DC.DocumentName -- DOCUMENT NAME 
                    ,
                    D004 = '2.16.840.1.113883.6.1' ,
                    D005 = 'LOINC' ,
                    D006 = D.EffectiveDate -- EFFECTIVEDATE
                    ,
                    D007 = D.EffectiveDate -- EFFECTIVEDATE
                    ,
                    D008 = CASE WHEN D.DocumentId IS NULL THEN 'RCTGND'
                                ELSE 'RCTG'
                           END 
                    ,
                    D009 = NULL-- SCORE
                    ,
                    D010 = NULL ,
                    D011 = NULL ,
                    D012 = NULL ,
                    D013 = NULL ,
                    D014 = NULL ,
                    D015 = NULL ,
                    D016 = NULL ,
                    D017 = NULL ,
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
                    ValueSetOID = '2.16.840.1.113883.3.600.1.462' ,
                    IDRoot = NULL ,
                    IDExtension = NULL ,
                    ACCOUNT_NUMBER = D.DocumentId
            FROM    #Services AS a
                    LEFT JOIN Documents D ON a.ClientId = D.ClientId
                                             AND ISNULL(D.RecordDeleted, 'N') = 'N'
                                             AND D.Status = 22 
                    JOIN PHQ9Documents p ON p.DocumentVersionId = D.CurrentDocumentVersionId
                                            AND ISNULL(p.RecordDeleted, 'N') = 'N'
                    JOIN DocumentCodes DC ON D.DocumentCodeId = DC.DocumentCodeId
                                             AND ISNULL(DC.RecordDeleted, 'N') = 'N'
            UNION
            SELECT  @batchId ,
                    lngId = NULL ,
                    CLIENT_ID = D.ClientId ,
                    REC_TYPE = 'CQM' ,
                    SEC_TYPE = 'RISKCATEGORY' ,
                    D001 = NULL ,
                    D002 = '225337009' -- LOINC CODE
                    ,
                    D003 = DC.DocumentName -- DOCUMENT NAME 
                    ,
                    D004 = '2.16.840.1.113883.6.1' ,
                    D005 = 'SNOMED' ,
                    D006 = D.EffectiveDate -- EFFECTIVEDATE
                    ,
                    D007 = D.EffectiveDate -- EFFECTIVEDATE
                    ,
                    D008 = CASE WHEN D.DocumentId IS NULL THEN 'RCTGND'
                                ELSE 'RCTG'
                           END 
                    ,
                    D009 = NULL -- SCORE
                    ,
                    D010 = NULL ,
                    D011 = NULL ,
                    D012 = NULL ,
                    D013 = NULL ,
                    D014 = NULL ,
                    D015 = NULL ,
                    D016 = NULL ,
                    D017 = NULL ,
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
                    ValueSetOID = '2.16.840.1.113883.3.600.1.462' ,
                    IDRoot = NULL ,
                    IDExtension = NULL ,
                    ACCOUNT_NUMBER = D.DocumentId
            FROM    #Services AS a
                    LEFT JOIN Documents D ON a.ClientId = D.ClientId
                                             AND ISNULL(D.RecordDeleted, 'N') = 'N'
                                             AND D.Status = 22 
                    JOIN dbo.ssf_RecodeValuesCurrent('XCQM161SuicideAssessmentDocCodes')
                    AS cd ON cd.IntegerCodeId = D.DocumentCodeId
                    JOIN DocumentCodes DC ON DC.DocumentCodeId = cd.IntegerCodeId
                                             AND ISNULL(DC.RecordDeleted, 'N') = 'N';
 
GO

