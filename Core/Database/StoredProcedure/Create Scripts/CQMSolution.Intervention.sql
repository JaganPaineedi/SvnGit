/****** Object:  StoredProcedure [CQMSolution].[Intervention]    Script Date: 01-02-2018 11:55:43 ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[CQMSolution].[Intervention]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [CQMSolution].[Intervention];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE PROCEDURE [CQMSolution].[Intervention]
    @type VARCHAR(255) ,  -- 'ep' or 'eh'
    @providerNPI VARCHAR(50) ,   -- this is whatever id is used to identify a physician in your system
    @startDate DATETIME ,      -- start date of the reporting period
    @stopDate DATETIME ,      -- end date of the reporting period
    @practiceID VARCHAR(255) ,   -- ExternalPracticeID
    @batchId INT
	WITH RECOMPILE
AS /******************************************************************************
**		File: Database\Modules\CQMSolutions\StoredProcedures
**		Name: [CQMSolution].[Intervention]
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
              [Account_Number]
            )
            SELECT  @batchId ,
                    lngId = NULL ,
                    CLIENT_ID = s.ClientId ,
                    REC_TYPE = 'CQM' ,
                    SEC_TYPE = 'INTERVENTION' ,
                    D001 = NULL ,
                    D002 = NULL ,
                    D003 = NULL ,
                    D004 = mvs.Concept ,
                    D005 = PC.ProcedureCodeName ,
                    D006 = mvs.CodeSystemOID ,
                    D007 = mvs.CodeSystem ,
                    D008 = dbo.[GetDateFormatForLabSoft](S.DateOfService,
                                                         '|^~\&') ,
                    D009 = dbo.[GetDateFormatForLabSoft](S.EndDateOfService,
                                                         '|^~\&') ,
                    D010 = CASE 
						WHEN s.[Status] = 70 THEN 'ORD'
						WHEN s.[Status] in (75,71) THEN 'PRF'
						WHEN s.[Status] in (72,73,76) THEN 'PRFND' 
					END   ,
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
                    ValueSetOID = mvs.ValueSetOID ,
                    IDRoot = NULL ,
                    IDExtension = NULL ,
                    ACCOUNT_NUMBER = S.ServiceId
         FROM    #Services AS s
	   JOIN ProcedureCodes PC ON PC.ProcedureCodeId = s.ProcedureCodeId
		  AND ISNULL(PC.RecordDeleted, 'N') = 'N'
	   LEFT JOIN ( SELECT (SELECT STUFF((SELECT ';' + b.Concept
					   FROM dbo.ProcedureCodeCQMConfigurations AS a
					   JOIN CQMSolution.MeasureValueSet AS b ON b.MeasureValueSetId = a.MeasureValueSetId WHERE aa.ProcedureCodeId = a.ProcedureCodeId
					   AND b.Category = 'Intervention'
					   and isnull(a.RecordDeleted,'N')='N'
					   ORDER BY b.MeasureValueSetId
					   FOR XML PATH('')),1,1,'') ) AS Concept,
				       (SELECT STUFF((SELECT ';' + b.CodeSystem
					   FROM dbo.ProcedureCodeCQMConfigurations AS a
					   JOIN CQMSolution.MeasureValueSet AS b ON b.MeasureValueSetId = a.MeasureValueSetId WHERE aa.ProcedureCodeId = a.ProcedureCodeId
					   AND b.Category = 'Intervention'
					   and isnull(a.RecordDeleted,'N')='N'
					   ORDER BY b.MeasureValueSetId
					   FOR XML PATH('')),1,1,'')) AS CodeSystem,
					  (SELECT STUFF((SELECT ';' + b.CodeSystemOID
					   FROM dbo.ProcedureCodeCQMConfigurations AS a
					   JOIN CQMSolution.MeasureValueSet AS b ON b.MeasureValueSetId = a.MeasureValueSetId
					   AND b.Category = 'Intervention'
					   and isnull(a.RecordDeleted,'N')='N'
					   WHERE aa.ProcedureCodeId = a.ProcedureCodeId
					   ORDER BY b.MeasureValueSetId
					   FOR XML PATH('')),1,1,'')) AS CodeSystemOID,
				       (SELECT STUFF((SELECT ';' + b.ValueSetOID
					   FROM dbo.ProcedureCodeCQMConfigurations AS a
					   JOIN CQMSolution.MeasureValueSet AS b ON b.MeasureValueSetId = a.MeasureValueSetId
					   AND b.Category = 'Intervention'
					   and isnull(a.RecordDeleted,'N')='N'
					   WHERE aa.ProcedureCodeId = a.ProcedureCodeId
					   ORDER BY b.MeasureValueSetId
					   FOR XML PATH('')),1,1,'')) AS ValueSetOID,
					  aa.ProcedureCodeId
				FROM dbo.ProcedureCodes AS aa
				WHERE EXISTS( SELECT 1
								FROM dbo.ProcedureCodeCQMConfigurations AS bb 
								WHERE aa.ProcedureCodeId = bb.ProcedureCodeId
								AND ISNULL(bb.RecordDeleted,'N')='N'
								) 
			) AS mvs ON mvs.ProcedureCodeId = pc.ProcedureCodeId
        WHERE s.DateOfService >= @startDate
		  AND s.DateOfService <= @stopDate


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
              Account_Number
            )
            SELECT distinct @batchId ,
                    lngId = NULL ,
                    CLIENT_ID = D.ClientId ,
                    REC_TYPE = 'CQM' ,
                    SEC_TYPE = 'INTERVENTION' ,
                    D001 = null,
                    D002 = null,
                    D003 = null,
                    D004 = '225337009',
                    D005 = DC.DocumentName ,
                    D006 = '2.16.840.1.113883.6.96' ,
                    D007 = 'SNOMEDCT' ,
                    D008 =  REPLACE(CONVERT(VARCHAR(10), isnull(sd.PerformedAt,d.EffectiveDate), 112)
                            + CONVERT(VARCHAR(8),isnull(sd.PerformedAt,d.EffectiveDate), 114), ':',
                            '') ,
                    D009 =  REPLACE(CONVERT(VARCHAR(10), isnull(sd.PerformedAt,d.EffectiveDate), 112)
                            + CONVERT(VARCHAR(8),isnull(sd.PerformedAt,d.EffectiveDate), 114), ':',
                            ''),
                    D010 = CASE WHEN D.DocumentId IS NULL THEN 'PRFND'
						  when d.status = 21 then 'PRFND'
						  when d.Status = 22 then 'PRF'
						  else null
                           END  ,
                    D011 = null ,
                    D012 = null ,
                    D013 = null ,
                    D014 = NULL ,
                    D015 = NULL ,
                    D016 = null ,
                    D017 = NULL ,
                    D018 = NULL ,
                    D019 = NULL ,
                    D020 = null,
                    D021 = null,
                    D022 = null ,
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
                    ValueSetOID = null ,
                    IDRoot = NULL ,
                    IDExtension = NULL ,
                    ACCOUNT_NUMBER = D.DocumentId
            FROM    #Services AS a
                    LEFT JOIN Documents D ON a.ClientId = D.ClientId
                                             AND ISNULL(D.RecordDeleted, 'N') = 'N'
                                             AND D.Status = 22 
                    JOIN suicideriskassessmentdocuments as sd on d.CurrentDocumentVersionId = sd.DocumentVersionId
				and isnull(sd.RecordDeleted,'N')='N'
                    JOIN DocumentCodes DC ON DC.DocumentCodeId = d.DocumentCodeID
                                             AND ISNULL(DC.RecordDeleted, 'N') = 'N'
	   union
	   
            SELECT distinct @batchId ,
                    lngId = NULL ,
                    CLIENT_ID = D.ClientId ,
                    REC_TYPE = 'CQM' ,
                    SEC_TYPE = 'INTERVENTION' ,
                    D001 = null,
                    D002 = null,
                    D003 = null,
                    D004 = '225337009',
                    D005 = DC.DocumentName ,
                    D006 = '2.16.840.1.113883.6.96' ,
                    D007 = 'SNOMEDCT' ,
                    D008 =  REPLACE(CONVERT(VARCHAR(10), d.EffectiveDate, 112)
                            + CONVERT(VARCHAR(8),d.EffectiveDate, 114), ':',
                            '') ,
                    D009 =  REPLACE(CONVERT(VARCHAR(10), d.EffectiveDate, 112)
                            + CONVERT(VARCHAR(8),d.EffectiveDate, 114), ':',
                            ''),
                    D010 = CASE WHEN D.DocumentId IS NULL THEN 'PRFND'
						  when d.status = 21 then 'PRFND'
						  when d.Status = 22 then 'PRF'
						  else null
                           END  ,
                    D011 = null ,
                    D012 = null ,
                    D013 = null ,
                    D014 = NULL ,
                    D015 = NULL ,
                    D016 = null ,
                    D017 = NULL ,
                    D018 = NULL ,
                    D019 = NULL ,
                    D020 = null,
                    D021 = null,
                    D022 = null ,
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
                    ValueSetOID = null ,
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
				and DC.DocumentCodeId <> 1636;

			
GO

