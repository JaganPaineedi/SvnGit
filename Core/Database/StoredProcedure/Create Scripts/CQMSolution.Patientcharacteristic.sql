/****** Object:  StoredProcedure [CQMSolution].[Patientcharacteristic]    Script Date: 01-02-2018 12:14:06 ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[CQMSolution].[Patientcharacteristic]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [CQMSolution].[Patientcharacteristic];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE PROCEDURE [CQMSolution].[Patientcharacteristic]
    @type VARCHAR(255) ,-- 'ep' or 'eh'
    @providerNPI VARCHAR(50) ,-- this is whatever id is used to identify a physician in your system
    @startDate DATETIME ,-- start date of the reporting period
    @stopDate DATETIME ,-- end date of the reporting period
    @practiceID VARCHAR(255) ,-- ExternalPracticeID
    @batchId INT
	WITH RECOMPILE
AS /******************************************************************************
**		File: Database\Modules\CQMSolutions\StoredProcedures
**		Name: [CQMSolution].[Patientcharacteristic]
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
**		  2/8/2018		 sbhowmik      updated logic to use Payer.PayerCode
*******************************************************************************/
    WITH    ClientPlan
              AS ( SELECT DISTINCT
                             c.ClientId ,
                            PayerCode = CASE WHEN p.PayerCode IS NULL THEN 349  -- Other
                                             ELSE p.PayerCode
                                        END ,
                            PayerCodeDescription = cp.CoveragePlanName
                   FROM     Clients c
                            INNER JOIN ClientCoveragePlans ccp ON c.ClientId = ccp.ClientId
                                                              AND ISNULL(c.RecordDeleted,
                                                              'N') = 'N'
                                                              AND ISNULL(ccp.RecordDeleted,
                                                              'N') = 'N'
                            INNER JOIN CoveragePlans cp ON cp.CoveragePlanId = ccp.CoveragePlanId
                                                           AND ISNULL(cp.RecordDeleted,
                                                              'N') = 'N'
                            INNER JOIN ClientCoverageHistory cch ON cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
                            INNER JOIN Payers p ON p.PayerId = cp.PayerId
                                                   AND ISNULL(p.RecordDeleted,
                                                              'N') = 'N'
                   WHERE    cch.StartDate BETWEEN @startDate AND @stopDate
                            AND ( cch.EndDate > @startDate
                                  OR cch.EndDate IS NULL
                                )
								AND EXISTS( SELECT 1
											FROM #Services AS s
											WHERE c.ClientId = s.ClientId
											)
                 ),
            ClientPlanRanked
              AS ( SELECT   Rnk = ROW_NUMBER() OVER ( PARTITION BY ClientId ORDER BY PayerCode ASC ) ,
                            *
                   FROM     ClientPlan
                 )
        SELECT  *
        INTO    #Payers
        FROM    ClientPlanRanked cpr
        WHERE   EXISTS ( SELECT *
                         FROM   #Services AS istg
                         WHERE  istg.ClientId = cpr.ClientId );

    SELECT  ClientId ,
            ExpiredDate = REPLACE(CONVERT(VARCHAR(8), DeceasedOn, 112)
                                  + CONVERT(VARCHAR(8), DeceasedOn, 114), ':',
                                  '') ,
            ExpiredReasonCode = 419099009 ,
            ExpiredReasonDesc = COALESCE(gcdeath.CodeName, 'Death')
    INTO    #Death
    FROM    dbo.Clients c
            LEFT OUTER JOIN GlobalCodes gcdeath ON c.CauseofDeath = gcdeath.GlobalCodeId
                                                   AND ISNULL(gcdeath.RecordDeleted,
                                                              'N') = 'N'
    WHERE   DeceasedOn IS NOT NULL
            AND DeceasedOn BETWEEN @startDate AND @stopDate
            AND EXISTS ( SELECT *
                         FROM   #Services istg
                         WHERE  istg.ClientId = c.ClientId );

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
              [IDExtension]
	        )
            SELECT  @batchId ,
                    lngId = NULL ,
                    CLIENT_ID = ClientId ,
                    REC_TYPE = 'CQM' ,
                    SEC_TYPE = 'PATIENTCHARACTERISTIC' ,
                    D001 = PayerCode ,
                    D002 = PayerCodeDescription ,
                    D003 = NULL ,
                    D004 = NULL ,
                    D005 = NULL ,
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
                    ValueSetOID = NULL ,
                    IDRoot = NULL ,
                    IDExtension = NULL
            FROM    #Payers
            UNION
            SELECT  @batchId ,
                    lngId = NULL ,
                    CLIENT_ID = ClientId ,
                    REC_TYPE = 'CQM' ,
                    SEC_TYPE = 'PATIENTCHARACTERISTIC' ,
                    D001 = NULL ,
                    D002 = NULL ,
                    D003 = NULL ,
                    D004 = NULL ,
                    D005 = NULL ,
                    D006 = NULL ,
                    D007 = NULL ,
                    D008 = NULL ,
                    D009 = NULL ,
                    D010 = NULL ,
                    D011 = NULL ,
                    D012 = ExpiredDate ,
                    D013 = ExpiredReasonCode ,
                    D014 = ExpiredReasonDesc ,
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
                    ValueSetOID = NULL ,
                    IDRoot = NULL ,
                    IDExtension = NULL
            FROM    #Death;
GO


