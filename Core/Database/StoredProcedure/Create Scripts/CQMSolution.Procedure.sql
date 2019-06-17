/****** Object:  StoredProcedure [CQMSolution].[Procedure]    Script Date: 01-02-2018 12:15:30 ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[CQMSolution].[Procedure]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [CQMSolution].[Procedure];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE PROCEDURE [CQMSolution].[Procedure]
    @type VARCHAR(255) ,  -- 'ep' or 'eh'
    @providerNPI VARCHAR(50) ,   -- this is whatever id is used to identify a physician in your system
    @startDate DATETIME ,      -- start date of the reporting period
    @stopDate DATETIME ,      -- end date of the reporting period
    @practiceID VARCHAR(255) ,   -- ExternalPracticeID
    @batchId INT
	WITH RECOMPILE
AS /******************************************************************************
**		File: Database\Modules\CQMSolutions\StoredProcedures
**		Name: [CQMSolution].[Procedure]
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
**        2/8/2018       sbhowmik	   removed dependecy on cqm.MeasureValueSet for @CPTCodeSystem and @SnomedCodeSystem
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
              Account_Number
            )
            SELECT  @batchId ,
                    lngId = NULL ,
                    CLIENT_ID = a.ClientId ,
                    REC_TYPE = 'CQM' ,
                    SEC_TYPE = 'PROCEDURE' ,
                    D001 = codes.Concept
                    ,
                    D002 = left(pc.ProcedureCodeName,255) ,
                    D003 = NULL ,
                    D004 = NULL ,
                    D005 = REPLACE(CONVERT(VARCHAR(10), a.DateOfService, 112)
                                   + CONVERT(VARCHAR(8), a.DateOfService, 114),
                                   ':', '') ,
                    D006 = NULL ,
                    D007 = NULL ,
                    D008 = NULL ,
                    D009 = NULL ,
                    D010 = NULL ,
                    D011 = NULL ,
                    D012 = NULL ,
                    D013 = NULL ,
                    D014 = NULL ,
                    D015 = NULL ,
                    D016 = REPLACE(CONVERT(VARCHAR(10), a.EndDateOfService, 112)
                                   + CONVERT(VARCHAR(8), a.EndDateOfService, 114),
                                   ':', '') ,
                    D017 = NULL ,
                    D018 = NULL ,
                    D019 = NULL ,
                    D020 = CASE 
						WHEN a.[Status] = 70 THEN 'ORD'
						WHEN a.[Status] in (75,71) THEN 'PRF'
						WHEN a.[Status] in (72,73,76) THEN 'PRFND' 
					END   ,
                    D021 = codes.CodeSystemOID ,
                    D022 = codes.CodeSystem,
                    D023 = NULL ,
                    D024 = NULL ,
                    D025 = NULL ,
                    D026 = NULL ,
                    D027 = null ,
                    D028 = null ,
                    D029 = null ,
                    D030 = null ,
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
                    ValueSetOID = codes.ValueSetOID ,
                    IDRoot = NULL ,
                    IDExtension = NULL ,
                    a.ServiceId
            FROM   #Services AS a
                    JOIN ProcedureCodes AS pc ON pc.ProcedureCodeId = a.ProcedureCodeId
				LEFT JOIN ( SELECT (SELECT STUFF((SELECT ';' + b.Concept
											 FROM dbo.ProcedureCodeCQMConfigurations AS a
											 JOIN CQMSolution.MeasureValueSet AS b ON b.MeasureValueSetId = a.MeasureValueSetId WHERE aa.ProcedureCodeId = a.ProcedureCodeId
											 AND b.Category = 'Procedure'
					   and isnull(a.RecordDeleted,'N')='N'
											 ORDER BY b.MeasureValueSetId
											 FOR XML PATH('')),1,1,'') ) AS Concept,
								(SELECT STUFF((SELECT ';' + b.CodeSystem
											 FROM dbo.ProcedureCodeCQMConfigurations AS a
											 JOIN CQMSolution.MeasureValueSet AS b ON b.MeasureValueSetId = a.MeasureValueSetId WHERE aa.ProcedureCodeId = a.ProcedureCodeId
											 AND b.Category = 'Procedure'
					   and isnull(a.RecordDeleted,'N')='N'
											 ORDER BY b.MeasureValueSetId
											 FOR XML PATH('')),1,1,'')) AS CodeSystem,
								(SELECT STUFF((SELECT ';' + b.CodeSystemOID
											 FROM dbo.ProcedureCodeCQMConfigurations AS a
											 JOIN CQMSolution.MeasureValueSet AS b ON b.MeasureValueSetId = a.MeasureValueSetId
											 AND b.Category = 'Procedure'
					   and isnull(a.RecordDeleted,'N')='N'
											 WHERE aa.ProcedureCodeId = a.ProcedureCodeId
											 ORDER BY b.MeasureValueSetId
											 FOR XML PATH('')),1,1,'')) AS CodeSystemOID,
								(SELECT STUFF((SELECT ';' + b.ValueSetOID
											 FROM dbo.ProcedureCodeCQMConfigurations AS a
											 JOIN CQMSolution.MeasureValueSet AS b ON b.MeasureValueSetId = a.MeasureValueSetId
											 AND b.Category = 'Procedure'
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
					   ) AS codes ON codes.ProcedureCodeId = a.ProcedureCodeId
				    union
 SELECT  @batchId ,
                    lngId = NULL ,
                    CLIENT_ID = d.ClientId ,
                    REC_TYPE = 'CQM' ,
                    SEC_TYPE = 'PROCEDURE' ,
                    D001 = CASE 
						WHEN d.[Status] = 26 THEN '428119001'
						WHEN d.[Status] in (21,22) THEN '428191000124101' 
					END 
                    ,
                    D002 = left(dc.DocumentName,255) ,
                    D003 = NULL ,
                    D004 = NULL ,
                    D005 = REPLACE(CONVERT(VARCHAR(10), isnull(a.PerformedAt,d.EffectiveDate), 112)
                                   + CONVERT(VARCHAR(8),  isnull(a.PerformedAt,d.EffectiveDate), 114),
                                   ':', '') ,
                    D006 = NULL ,
                    D007 = NULL ,
                    D008 = NULL ,
                    D009 = NULL ,
                    D010 = NULL ,
                    D011 = NULL ,
                    D012 = NULL ,
                    D013 = NULL ,
                    D014 = NULL ,
                    D015 = NULL ,
                    D016 = REPLACE(CONVERT(VARCHAR(10),  isnull(a.PerformedAt,d.EffectiveDate), 112)
                                   + CONVERT(VARCHAR(8),  isnull(a.PerformedAt,d.EffectiveDate), 114),
                                   ':', '') ,
                    D017 =  CASE 
						WHEN d.[Status] = 26 THEN '428119001'
						WHEN d.[Status] in (21,22) THEN '428191000124101' 
					END,
                    D018 =  CASE 
						WHEN d.[Status] = 26 THEN '2.16.840.1.113883.6.96'
						WHEN d.[Status] in (21,22) THEN NULL 
					END ,
                    D019 = CASE 
						WHEN d.[Status] = 26 THEN 'SNOMEDCT'
						WHEN d.[Status] in (21,22) THEN NULL 
					END ,
                    D020 = CASE 
						WHEN d.[Status] = 26 THEN 'PRFND'
						WHEN d.[Status] in (21,22) THEN 'PRF' 
					END   ,
                    D021 = '2.16.840.1.113883.6.96' ,
                    D022 = 'SNOMEDCT',
                    D023 = NULL ,
                    D024 = NULL ,
                    D025 = NULL ,
                    D026 = NULL ,
                    D027 =null ,
                    D028 = null ,
                    D029 = null ,
                    D030 = null ,
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
                    ValueSetOID = CASE 
						WHEN d.[Status] = 26 THEN '2.16.840.1.113883.3.600.1.1502'
						WHEN d.[Status] in (21,22) THEN '2.16.840.1.113883.3.600.1.462' 
					END ,
                    IDRoot = NULL ,
                    IDExtension = NULL ,
                    d.DocumentId
			 from Documents as d
			 JOin DocumentCodes as dc on d.DocumentCodeId = dc.DocumentCodeId
			 and dc.DocumentCodeId = 1643
			 Join SuicideRiskAssessmentDocuments as a on d.CurrentDocumentVersionId = a.DocumentVersionId
			 and isnull(a.RecordDeleted,'N')='N'
			 where isnull(d.RecordDeleted,'N')='N'
			 and exists( select 1
					   from #services as a
					   where d.ClientId = a.ClientId
					   )
					   		 
   

GO
