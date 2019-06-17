/****** Object:  StoredProcedure [CQMSolution].[Problem]    Script Date: 01-02-2018 12:14:48 ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[CQMSolution].[Problem]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [CQMSolution].[Problem];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE PROCEDURE [CQMSolution].[Problem]
    @type VARCHAR(255) ,  -- 'ep' or 'eh'
    @providerNPI VARCHAR(50) ,   -- this is whatever id is used to identify a physician in your system
    @startDate DATETIME ,      -- start date of the reporting period
    @stopDate DATETIME ,      -- end date of the reporting period
    @practiceID VARCHAR(255) ,   -- ExternalPracticeID
    @batchId INT
	WITH RECOMPILE
AS /******************************************************************************
**		File: Database\Modules\CQMSolutions\StoredProcedures
**		Name: [CQMSolution].[Problem]
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
    BEGIN

/* Query SNOMEDCT and ICD10 diagnosis code from diagnosis documents */
        WITH    RnkDiagnosis
                  AS ( SELECT   doc.ClientId ,
                                CAST(CAST(doc.EffectiveDate AS DATE) AS DATETIME) AS [EffectiveStartDate] ,
                                diag.DocumentVersionId ,
                                diag.[DiagnosisOrder] ,
                                Rnk = DENSE_RANK() OVER ( PARTITION BY doc.[ClientId] ORDER BY doc.EffectiveDate ASC, doc.CurrentDocumentVersionId ASC ) ,
                                diag.ICD10CodeId ,
                                diag.ICD10Code ,
                                diag.SNOMEDCODE
                       FROM     Documents doc
                                INNER JOIN DocumentDiagnosisCodes diag ON doc.CurrentDocumentVersionId = diag.DocumentVersionId
                                                              AND ISNULL(doc.RecordDeleted,
                                                              'N') = 'N'
                                                              AND ISNULL(diag.RecordDeleted,
                                                              'N') = 'N'
                       WHERE    doc.Status IN ( 21, 22 )
                                AND EXISTS ( SELECT 1
                                             FROM   #Services AS a
                                             WHERE  a.ClientId = doc.ClientId )
											 AND EXISTS ( SELECT 1
															FROM #Clinicians AS st
															WHERE doc.AuthorId = st.StaffId
															)
                     ),
                CmbDiagnosis
                  AS ( SELECT DISTINCT
                                ACCOUNT_NUMBER = r1.DocumentVersionId ,
                                CLIENT_ID = r1.ClientId ,
                                ProblemCode = CAST(r1.ICD10Code AS VARCHAR(25)) ,
                                ProblemDescription = CAST(ICD.ICDDescription AS VARCHAR(255)) ,
                                DateLow = r1.EffectiveStartDate ,
                                DateHigh = COALESCE(DATEADD(DAY, -1,
                                                            r2.EffectiveStartDate),
                                                    '12-31-2999') ,
                                IsPrimaryDiagnosis = CAST(CASE
                                                              WHEN r1.[DiagnosisOrder] = 1
                                                              THEN 'Y'
                                                              ELSE 'N'
                                                          END AS CHAR(1)) ,
                                CodeSystem = '2.16.840.1.113883.6.90' ,
                                CodeSystemName = 'ICD10CM'
                       FROM     RnkDiagnosis r1
                                LEFT OUTER JOIN RnkDiagnosis r2 ON r1.ClientId = r2.ClientId
                                                              AND r2.Rnk = r1.Rnk
                                                              + 1
                                INNER JOIN DiagnosisICD10Codes ICD ON ICD.ICD10CodeId = r1.ICD10CodeId
                                                              AND ISNULL(ICD.RecordDeleted,
                                                              'N') = 'N'
                       UNION
                       SELECT DISTINCT
                                ACCOUNT_NUMBER = r1.DocumentVersionId ,
                                CLIENT_ID = r1.ClientId ,
                                ProblemCode = CAST(SNO.SNOMEDCTCode AS VARCHAR(25)) ,
                                ProblemDescription = CAST(SNO.SNOMEDCTDescription AS VARCHAR(255)) ,
                                DateLow = r1.EffectiveStartDate ,
                                DateHigh = COALESCE(DATEADD(DAY, -1,
                                                            r2.EffectiveStartDate),
                                                    '12-31-2999') ,
                                IsPrimaryDiagnosis = CAST(CASE
                                                              WHEN r1.[DiagnosisOrder] = 1
                                                              THEN 'Y'
                                                              ELSE 'N'
                                                          END AS CHAR(1)) ,
                                CodeSystem = '2.16.840.1.113883.6.96' ,
                                CodeSystemName = 'SNOMEDCT'
                       FROM     RnkDiagnosis r1
                                LEFT OUTER JOIN RnkDiagnosis r2 ON r1.ClientId = r2.ClientId
                                                              AND r2.Rnk = r1.Rnk
                                                              + 1
                                INNER JOIN SNOMEDCTCodes SNO ON SNO.SNOMEDCTCode = r1.SNOMEDCODE
                                                              AND ISNULL(RecordDeleted,
                                                              'N') = 'N'
                                                              AND NOT EXISTS ( SELECT
                                                              *
                                                              FROM
                                                              SNOMEDCTCodes isno
                                                              WHERE
                                                              isno.SNOMEDCTCodeId > SNO.SNOMEDCTCodeId
                                                              AND isno.SNOMEDCTCode = SNO.SNOMEDCTCode
                                                              AND ISNULL(isno.RecordDeleted,
                                                              'N') = 'N' )
                     )
            SELECT  *
            INTO    #DocDiagnosis
            FROM    CmbDiagnosis
            WHERE   DateLow >= @startDate
                    AND DateLow <= @stopDate;

/* Diagnosis from Service */
        SELECT  ACCOUNT_NUMBER = svc.ServiceId ,
                CLIENT_ID = svc.ClientId ,
                ProblemCode = CAST(sd.ICD10Code AS VARCHAR(25)) ,
                ProblemDescription = CAST(ICD.ICDDescription AS VARCHAR(255)) ,
                DateLow = svc.DateOfService ,
                DateHigh = svc.DateOfService ,
                IsPrimaryDiagnosis = CAST(CASE WHEN sd.[Order] = 1 THEN 'Y'
                                               ELSE 'N'
                                          END AS CHAR(1)) ,
                CodeSystem = '2.16.840.1.113883.6.90' ,
                CodeSystemName = 'ICD10CM'
        INTO    #SvcDiagnosis
        FROM    #Services svc
                INNER JOIN ServiceDiagnosis sd ON svc.ServiceId = sd.ServiceId
                                                  AND ISNULL(sd.RecordDeleted,
                                                             'N') = 'N'
                INNER JOIN DiagnosisICD10Codes ICD ON ICD.ICD10Code = sd.ICD10Code
                                                      AND ISNULL(ICD.RecordDeleted,
                                                              'N') = 'N'
                                                      AND NOT EXISTS ( SELECT
                                                              *
                                                              FROM
                                                              DiagnosisICD10Codes idiag
                                                              WHERE
                                                              idiag.ICD10Code = sd.ICD10Code
                                                              AND ISNULL(idiag.RecordDeleted,
                                                              'N') = 'N'
                                                              AND idiag.ICD10CodeId > ICD.ICD10CodeId )

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
                SELECT  @batchId ,
                        lngId = NULL ,
                        CLIENT_ID = CLIENT_ID ,
                        REC_TYPE = 'CQM' ,
                        SEC_TYPE = 'PROBLEM' ,
                        D001 = ProblemCode ,
                        D002 = ProblemDescription ,
                        D003 = dbo.[GetDateFormatForLabSoft](DateLow, '|^~\&') ,
                        D004 = dbo.[GetDateFormatForLabSoft](DateHigh, '|^~\&') ,
                        D005 = 'DIAG' ,
                        D006 = NULL ,
                        D007 = NULL ,
                        D008 = NULL ,
                        D009 = NULL ,
                        D010 = NULL ,
                        D011 = alldiag.CodeSystem ,
                        D012 = alldiag.CodeSystemName ,
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
                        D031 = 'CD' ,
                        D032 = 'Active' ,
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
                        alldiag.ACCOUNT_NUMBER
                FROM    ( SELECT    *
                          FROM      #DocDiagnosis
                          UNION
                          SELECT    *
                          FROM      #SvcDiagnosis
                        ) alldiag;
    END;

GO

