/****** Object:  StoredProcedure [CQMSolution].[Medication]    Script Date: 01-02-2018 12:13:49 ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[CQMSolution].[Medication]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [CQMSolution].[Medication];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE PROCEDURE [CQMSolution].[Medication]
    @type VARCHAR(255) ,  -- 'ep' or 'eh'
    @providerNPI VARCHAR(50) ,   -- this is whatever id is used to identify a physician in your system
    @startDate DATETIME ,      -- start date of the reporting period
    @stopDate DATETIME ,      -- end date of the reporting period
    @practiceID VARCHAR(255) ,   -- ExternalPracticeID
    @batchId INT
	WITH RECOMPILE
AS /******************************************************************************
**		File: Database\Modules\CQMSolutions\StoredProcedures
**		Name: [CQMSolution].[Medication]
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
**		2/5/2018	    jcarlson		added logic to remove fields when negating drug ( ie. drug discontinued reason is selected )
**		2/6/2018		Chethan N		What : Added logic to identify MAR 'Given' status - to retrieve D014
										Why : Meaningful Use - Stage 3 task #71
*******************************************************************************/


    SELECT  DISTINCT
            @batchId AS BatchId ,
            NULL AS lngId ,
            cm.ClientId AS CLIENT_ID ,
            'CQM' AS REC_TYPE ,
            'MEDICATION' AS SEC_TYPE ,
            CASE WHEN gc.GlobalCodeId IS NOT NULL THEN NULL
                 ELSE  mdnorm.RxNorm
            END AS 'D001' ,
            mmn.MedicationName AS 'D002' ,
            mmn.MedicationName AS 'D003' ,
            NULL AS 'D004' ,
            NULL AS 'D005' ,
            NULL AS 'D006' ,
            NULL AS 'D007' ,
            NULL AS 'D008' ,
            NULL AS 'D009' ,
            CASE WHEN gc.GlobalCodeId IS NOT NULL THEN NULL
                 ELSE mdmed.MedicationDescription
            END AS 'D010' ,
            NULL AS 'D011' ,
            REPLACE(CONVERT(VARCHAR(10), cmsd.StartDate, 112)
                    + CONVERT(VARCHAR(8), cmsd.StartDate, 114), ':', '') AS 'D012' ,
            REPLACE(CONVERT(VARCHAR(10), cmsd.EndDate, 112)
                    + CONVERT(VARCHAR(8), cmsd.EndDate, 114), ':', '') AS 'D013' ,
            CASE WHEN EXISTS ( SELECT   1
                               FROM     MedAdminRecords MAR
                                        JOIN GlobalCodes MGC ON MGC.GlobalCodeId = MAR.[Status]
													 AND ( MGC.Code = 'Given'
													 OR MGC.Code = 'Self-Administered'
                                                              )
                               WHERE    MAR.ClientMedicationId = cm.ClientMedicationId
                                        AND ISNULL(MAR.RecordDeleted, 'N') = 'N' )
                 THEN 'DISP'
			  WHEN EXISTS ( SELECT   1
                               FROM     MedAdminRecords MAR
                                        JOIN GlobalCodes MGC ON MGC.GlobalCodeId = MAR.[Status]
													 AND ( MGC.Code = 'NotGiven'
													 OR MGC.Code = 'Refused'
													 OR MGC.Code = 'Rescheduled'
                                                              )
                               WHERE    MAR.ClientMedicationId = cm.ClientMedicationId
                                        AND ISNULL(MAR.RecordDeleted, 'N') = 'N' )
                 THEN 'DISPND'
                 WHEN gc.GlobalCodeId IS NOT NULL THEN gc.Code
                 ELSE 'ORD'
            END AS 'D014' ,
            NULL AS 'D015' ,
            NULL AS 'D016' ,
            NULL AS 'D017' ,
            NULL AS 'D018' ,
            NULL AS 'D019' ,
            NULL AS 'D020' ,
            '103321005' AS 'D021' ,
            '2.16.840.1.113883.6.96' AS 'D022' ,
            'Request by physician' AS 'D023' ,
            '2.16.840.1.113883.6.88' AS 'D024' ,
            'RxNorm' AS 'D025' ,
            CASE WHEN gc.GlobalCodeId IS NOT NULL THEN NULL
                 ELSE CAST(cmsd.Refills AS INT)
            END AS 'D026' ,
            NULL AS 'D027' ,
            NULL AS 'D028' ,
            CAST(cmsd.Pharmacy AS INT) AS 'D029' ,
            NULL AS 'D030' ,
            CASE WHEN gc.GlobalCodeId IS NOT NULL
                      AND LOWER(gc.CodeName) LIKE '%not done%'
                 THEN '2.16.840.1.113883.3.117.1.7.1.93'
                 ELSE NULL
            END AS 'D031' ,
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
            CASE WHEN gc.GlobalCodeId IS NOT NULL
                      AND LOWER(gc.CodeName) LIKE '%not done%'
                 THEN '2.16.840.1.113762.1.4.1021.7'
                 WHEN gc.GlobalCodeId IS NOT NULL
                      AND LOWER(gc.CodeName) LIKE '%not complete%'
                 THEN '2.16.840.1.113762.1.4.1021.8'
                 ELSE NULL
            END AS ValueSetOID ,
            cm.ClientMedicationId AS ACCOUNT_NUMBER ,
            NULL AS IDRoot ,
            NULL AS IDExtension ,
            ROW_NUMBER() OVER ( PARTITION BY cmsd.ClientMedicationScriptDrugId ORDER BY ( SELECT
                                                              0
                                                              ) ) AS rowNumber ,
            mdmed.MedicationId AS MedicationId,
		  gc.GlobalCodeId as DiscontinuedReason
    INTO    #TempResults
    FROM    dbo.ClientMedicationScripts AS cms
            JOIN dbo.ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationScriptId = cms.ClientMedicationScriptId
		  and isnull(cmsd.RecordDeleted,'N')='N'
            JOIN dbo.ClientMedicationScriptDrugStrengths AS cmsds ON cmsds.ClientMedicationScriptId = cmsd.ClientMedicationScriptId
		  and isnull(cmsds.RecordDeleted,'N')='N'
            JOIN dbo.ClientMedications AS cm ON cm.ClientMedicationId = cmsds.ClientMedicationId
		  and isnull(cm.RecordDeleted,'N')='N'
            LEFT JOIN GlobalCodes AS gc ON cm.DiscontinuedReasonCode = gc.GlobalCodeId
            JOIN dbo.ClientMedicationInstructions AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId
                                                            AND cmsds.ClientMedicationId = cmi.ClientMedicationId
												and isnull(cmi.RecordDeleted,'N')='N'
            JOIN dbo.MDMedicationNames AS mmn ON mmn.MedicationNameId = cm.MedicationNameId
                                                 AND ISNULL(mmn.RecordDeleted,
                                                            'N') = 'N'
            JOIN dbo.MDMedications AS mdmed ON mdmed.MedicationId = cmi.StrengthId
                                               AND ISNULL(mdmed.RecordDeleted,
                                                          'N') = 'N'
            JOIN dbo.MDDrugs AS mddrug ON mddrug.ClinicalFormulationId = mdmed.ClinicalFormulationId
                                          AND ISNULL(mddrug.RecordDeleted, 'N') = 'N'
		  left Join MDMedicationsRxNorm as mdnorm on mdnorm.MedicationId = mdmed.MedicationId
								and isnull(mdnorm.RecordDeleted,'N')='N'
								and exists( select 1
										  from CQMSolution.MeasureValueSet as mvs
										  where isnull(mvs.RecordDeleted,'N')='N'
										  and mvs.CodeSystem = 'RxNorm'
										  and mvs.MeasureId in(2,68,69,128,136,137,159,160,161,165,169,177)
										  and mvs.Concept = mdnorm.RxNorm)
		  JOIN #Clinicians AS st ON cms.OrderingPrescriberId = st.StaffId
    WHERE   cmsd.StartDate >= @startDate
            AND cmsd.StartDate <= @stopDate
		  and isnull(cms.RecordDeleted,'N')='N'
            AND EXISTS ( SELECT 1
                         FROM  #Services AS a
                         WHERE  a.ClientId = cms.ClientId );

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
              ACCOUNT_NUMBER ,
              [IDRoot] ,
              [IDExtension]
            )
            SELECT  BatchId ,
                    lngId ,
                    CLIENT_ID ,
                    REC_TYPE ,
                    SEC_TYPE ,
                    D001 ,
                    D002 ,
                    D003 ,
                    D004 ,
                    D005 ,
                    D006 ,
                    D007 ,
                    D008 ,
                    D009 ,
                    D010 ,
                    D011 ,
                    D012 ,
                    D013 ,
                    D014 ,
                    D015 ,
                    D016 ,
                    D017 ,
                    D018 ,
                    D019 ,
                    D020 ,
                    D021 ,
                    D022 ,
                    D023 ,
                    D024 ,
                    D025 ,
                    D026 ,
                    D027 ,
                    D028 ,
                    D029 ,
                    D030 ,
                    D031 ,
                    D032 ,
                    D033 ,
                    D034 ,
                    D035 ,
                    D036 ,
                    D037 ,
                    D038 ,
                    D039 ,
                    D040 ,
                    D041 ,
                    D042 ,
                    D043 ,
                    D044 ,
                    D045 ,
                    D046 ,
                    D047 ,
                    D048 ,
                    D049 ,
                    D050 ,
                    ValueSetOID ,
                    ACCOUNT_NUMBER ,
                    IDRoot ,
                    IDExtension
            FROM    #TempResults
           -- WHERE   rowNumber = 1
		  union
            SELECT  BatchId ,
                    lngId ,
                    CLIENT_ID ,
                    REC_TYPE ,
                    SEC_TYPE ,
                    D001 ,
                    D002 ,
                    D003 ,
                    D004 ,
                    D005 ,
                    D006 ,
                    D007 ,
                    D008 ,
                    D009 ,
                    D010 ,
                    D011 ,
                    D012 ,
                    D013 ,
                    'ACT' , --send an Active as well
                    D015 ,
                    D016 ,
                    D017 ,
                    D018 ,
                    D019 ,
                    D020 ,
                    D021 ,
                    D022 ,
                    D023 ,
                    D024 ,
                    D025 ,
                    D026 ,
                    D027 ,
                    D028 ,
                    D029 ,
                    D030 ,
                    D031 ,
                    D032 ,
                    D033 ,
                    D034 ,
                    D035 ,
                    D036 ,
                    D037 ,
                    D038 ,
                    D039 ,
                    D040 ,
                    D041 ,
                    D042 ,
                    D043 ,
                    D044 ,
                    D045 ,
                    D046 ,
                    D047 ,
                    D048 ,
                    D049 ,
                    D050 ,
                    ValueSetOID ,
                    ACCOUNT_NUMBER ,
                    IDRoot ,
                    IDExtension
            FROM    #TempResults
            WHERE  -- rowNumber = 1
		--  and 
		  DiscontinuedReason is null
		  
		  union
            SELECT  BatchId ,
                    lngId ,
                    CLIENT_ID ,
                    REC_TYPE ,
                    SEC_TYPE ,
                    D001 ,
                    D002 ,
                    D003 ,
                    D004 ,
                    D005 ,
                    D006 ,
                    D007 ,
                    D008 ,
                    D009 ,
                    D010 ,
                    D011 ,
                    D012 ,
                    D013 ,
                    'DISP' , --send an DISP as well, if not already sent
                    D015 ,
                    D016 ,
                    D017 ,
                    D018 ,
                    D019 ,
                    D020 ,
                    D021 ,
                    D022 ,
                    D023 ,
                    D024 ,
                    D025 ,
                    D026 ,
                    D027 ,
                    D028 ,
                    D029 ,
                    D030 ,
                    D031 ,
                    D032 ,
                    D033 ,
                    D034 ,
                    D035 ,
                    D036 ,
                    D037 ,
                    D038 ,
                    D039 ,
                    D040 ,
                    D041 ,
                    D042 ,
                    D043 ,
                    D044 ,
                    D045 ,
                    D046 ,
                    D047 ,
                    D048 ,
                    D049 ,
                    D050 ,
                    ValueSetOID ,
                    ACCOUNT_NUMBER ,
                    IDRoot ,
                    IDExtension
            FROM    #TempResults as a
           WHERE --  rowNumber = 1
		  --and 
		  not exists (Select 1
					   from #TempResults as b
					   where b.Client_Id = a.Client_Id
					   and b.ACCOUNT_NUMBER = a.ACCOUNT_NUMBER
					   and b.MedicationId = a.MedicationId
					   and b.rowNumber = a.rowNumber
					   and b.D014 = 'DISP'
					  -- and b.rowNumber = 1
					   )

GO