/****** Object:  StoredProcedure [CQMSolution].[Encounter]    Script Date: 01-02-2018 11:55:28 ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[CQMSolution].[Encounter]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [CQMSolution].[Encounter];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE PROCEDURE [CQMSolution].[Encounter]
    @type VARCHAR(255) ,  -- 'ep' or 'eh'
    @providerNPI VARCHAR(50) ,   -- this is whatever id is used to identify a physician in your system
    @startDate DATETIME ,      -- start date of the reporting period
    @stopDate DATETIME ,      -- end date of the reporting period
    @practiceID VARCHAR(255) ,
    @batchId INT   -- ExternalPracticeID
	WITH RECOMPILE
AS /******************************************************************************
**		File: Database\Modules\CQMSolutions\StoredProcedures
**		Name: [CQMSolution].[Encounter]
**		Desc: 
**
**		Called by: dbo.spGetCQMDataForReport
**
**		Auth: jcarlson
**		Date: 2/1/2018
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**		--------	--------			------------------------------------------
**      02/01/2018  jcarlson            created comment header
**									    added batching logic
**									    updated logic to use new ssf_GetServices function instead of type specific functions
**									    removed union
**      02/08/2018  sbhowmik	        removed dependecy on cqm.MeasureValueSet for @CPTCodeSystem and @SnomedCodeSystem
**		04/02/2018	jcarlson			Removed deprecated logic
*******************************************************************************/


    CREATE TABLE #DischargeCodes
        (
          ServiceId INT ,
          StatusCode VARCHAR(MAX) ,
          StatusCodeSystem VARCHAR(MAX)
        );

    IF @type = 'EH'
        BEGIN
            INSERT  INTO #DischargeCodes
                    ( ServiceId ,
                      StatusCode ,
                      StatusCodeSystem
                    )
                    SELECT DISTINCT
                            a.ServiceId ,
                            gcDischargeType.ExternalCode2 AS 'DischargeStatusCode' ,
                            gcDischargeType.Code AS 'DischargeStatusCodeSystem'
                    FROM    #Services AS a
                            JOIN dbo.ClientInpatientVisits AS civ ON civ.ClientId = a.ClientId
                                                              AND CONVERT(DATE, civ.AdmitDate) <= CONVERT(DATE, a.DateOfService)
                                                              AND ( CONVERT(DATE, civ.DischargedDate) >= CONVERT(DATE, a.DateOfService)
                                                              OR civ.DischargedDate IS NULL
                                                              )
                            JOIN GlobalCodes AS gcDischargeType ON civ.DischargeType = gcDischargeType.GlobalCodeId;
        END;


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
                    NULL AS 'lngId' ,
                    a.ClientId AS 'CLIENT_ID' ,
                    'CQM' AS 'REC_TYPE' ,
                    'ENCOUNTER' AS 'SEC_TYPE' ,
                    NULL AS 'D001' ,
                    codes.Concept AS 'D002' ,
                    left(pc.ProcedureCodeName,255) AS 'D003' ,
                    codes.CodeSystemOID AS 'D004' ,
                    codes.CodeSystem AS 'D005' ,
                    REPLACE(CONVERT(VARCHAR(10), a.DateOfService, 112)
                            + CONVERT(VARCHAR(8), a.DateOfService, 114), ':',
                            '') AS 'D006' ,
                    REPLACE(CONVERT(VARCHAR(10), a.EndDateOfService, 112)
                            + CONVERT(VARCHAR(8), a.EndDateOfService, 114),
                            ':', '') AS 'D007' ,
                    CASE 
						WHEN a.[Status] = 70 THEN 'ORD'
						WHEN a.[Status] in (75,71) THEN 'PRF'
						WHEN a.[Status] in (72,73,76) THEN 'PRFND' 
					END AS 'D008' ,
                    NULL AS 'D009' ,
                    NULL AS 'D010' ,
                    NULL AS 'D011' ,
                    NULL AS 'D012' ,
                    l.CQMCode AS 'D013' ,
                    left(l.LocationName,255) AS 'D014' ,
                    REPLACE(CONVERT(VARCHAR(10), a.DateOfService, 112)
                            + CONVERT(VARCHAR(8), a.DateOfService, 114), ':',
                            '') AS 'D015' ,
                    REPLACE(CONVERT(VARCHAR(10), a.EndDateOfService, 112)
                            + CONVERT(VARCHAR(8), a.EndDateOfService, 114),
                            ':', '') AS 'D016' ,
                   gcL.ExternalCode1 AS 'D017' ,
                    gcL.Code AS 'D018' ,
                    id.StatusCode AS 'D019' ,
                    id.StatusCodeSystem AS 'D020' ,
                    NULL AS 'D021' ,
                    sd.ICD10Code AS 'D022' ,
                    left(ICD.ICDDescription,255) AS 'D023' ,
                    '2.16.840.1.113883.6.90' AS 'D024' ,
                    'ICD10CM' AS 'D025' ,
                    sd.ICD10Code AS 'D026' ,
                    left(ICD.ICDDescription,255) AS 'D027' ,
                    '2.16.840.1.113883.6.90' AS 'D028' ,
                    'ICD10CM' AS 'D029' ,
                    REPLACE(CONVERT(VARCHAR(10), a.DateOfService, 112)
                            + CONVERT(VARCHAR(8), a.DateOfService, 114), ':',
                            '') AS 'D030' ,
                    REPLACE(CONVERT(VARCHAR(10), a.EndDateOfService, 112)
                            + CONVERT(VARCHAR(8), a.EndDateOfService, 114),
                            ':', '') AS 'D031' ,
                    NULL AS 'D032' ,
                    NULL AS 'D033' ,
                    NULL AS 'D034' ,
                    NULL AS 'D035' ,
                    NULL AS 'D036' ,
                    NULL AS 'D037' ,
                    NULL AS 'D038' ,
                    NULL AS 'D039' ,
                    NULL AS 'D040' ,
                    NULL AS 'D041' ,
                    NULL AS 'D042' ,
                    NULL AS 'D043' ,
                    NULL AS 'D044' ,
                    NULL AS 'D045' ,
                    NULL AS 'D046' ,
                    NULL AS 'D047' ,
                    NULL AS 'D048' ,
                    NULL AS 'D049' ,
                    NULL AS 'D050' ,
                    NULL AS 'ValueSetOID' ,
                    NULL AS 'IDRoot' ,
                    NULL AS 'IDExtension' ,
                    a.ServiceId AS 'Account_Number'
            FROM    #Services AS a
                    JOIN ProcedureCodes AS pc ON pc.ProcedureCodeId = a.ProcedureCodeId
				LEFT JOIN ( SELECT (	 SELECT STUFF((SELECT ';' + b.Concept
											 FROM dbo.ProcedureCodeCQMConfigurations AS a
											 JOIN CQMSolution.MeasureValueSet AS b ON b.MeasureValueSetId = a.MeasureValueSetId WHERE aa.ProcedureCodeId = a.ProcedureCodeId
											 AND b.Category = 'Encounter'
					   and isnull(a.RecordDeleted,'N')='N'
											 ORDER BY b.MeasureValueSetId
											 FOR XML PATH('')),1,1,'') ) AS Concept,
								    (SELECT STUFF((SELECT ';' + b.CodeSystem
												FROM dbo.ProcedureCodeCQMConfigurations AS a
												JOIN CQMSolution.MeasureValueSet AS b ON b.MeasureValueSetId = a.MeasureValueSetId WHERE aa.ProcedureCodeId = a.ProcedureCodeId
												AND b.Category = 'Encounter'
					   and isnull(a.RecordDeleted,'N')='N'
												ORDER BY b.MeasureValueSetId
												FOR XML PATH('')),1,1,'')) AS CodeSystem,
								    (SELECT STUFF((SELECT ';' + b.CodeSystemOID
												FROM dbo.ProcedureCodeCQMConfigurations AS a
												JOIN CQMSolution.MeasureValueSet AS b ON b.MeasureValueSetId = a.MeasureValueSetId
												AND b.Category = 'Encounter'
					   and isnull(a.RecordDeleted,'N')='N'
												WHERE aa.ProcedureCodeId = a.ProcedureCodeId
												ORDER BY b.MeasureValueSetId
												FOR XML PATH('')),1,1,'')) AS CodeSystemOID,
								    aa.ProcedureCodeId
					   FROM dbo.ProcedureCodes AS aa
					   WHERE EXISTS( SELECT 1
								    FROM dbo.ProcedureCodeCQMConfigurations AS bb 
								    WHERE aa.ProcedureCodeId = bb.ProcedureCodeId
								    AND ISNULL(bb.RecordDeleted,'N')='N'
								    ) 
					   ) AS codes ON codes.ProcedureCodeId = a.ProcedureCodeId
				JOIN Locations AS l ON l.LocationId = a.LocationId
                    LEFT JOIN GlobalCodes AS gcL ON l.CQMCodeType = gcL.GlobalCodeId
					AND ISNULL(gcL.RecordDeleted,'N')='N'
                    LEFT JOIN dbo.ServiceDiagnosis AS sd ON sd.ServiceId = a.ServiceId
                                                            AND ISNULL(sd.RecordDeleted,'N') = 'N'
                                                            AND sd.[Order] = 1
                    LEFT JOIN dbo.DiagnosisICD10Codes ICD ON ICD.ICD10Code = sd.ICD10Code
                                                             AND ISNULL(ICD.RecordDeleted,'N') = 'N'
                                                             AND NOT EXISTS ( SELECT
															   *
															   FROM
															   DiagnosisICD10Codes idiag
															   WHERE idiag.ICD10Code = sd.ICD10Code
																AND ISNULL(idiag.RecordDeleted,'N') = 'N'
																AND idiag.ICD10CodeId > ICD.ICD10CodeId )
                    LEFT JOIN #DischargeCodes AS id ON id.ServiceId = a.ServiceId
				    and @Type = 'EH';



							
				

GO