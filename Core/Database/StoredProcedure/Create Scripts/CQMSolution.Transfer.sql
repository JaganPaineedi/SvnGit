/****** Object:  StoredProcedure [CQMSolution].[Transfer]    Script Date: 01-02-2018 12:16:20 ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[CQMSolution].[Transfer]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [CQMSolution].[Transfer];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE PROCEDURE [CQMSolution].[Transfer]
    @type VARCHAR(255) ,  -- 'ep' or 'eh'
    @providerNPI VARCHAR(50) ,   -- this is whatever id is used to identify a physician in your system
    @startDate DATETIME ,      -- start date of the reporting period
    @stopDate DATETIME ,      -- end date of the reporting period
    @practiceID VARCHAR(255) ,   -- ExternalPracticeID
    @batchId INT
	WITH RECOMPILE
AS /******************************************************************************
**		File: Database\Modules\CQMSolutions\StoredProcedures
**		Name: [CQMSolution].[Transfer]
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
**		  2/8/2018		 sbhowmik	   updated logic to use SNOMEDCTCode from Programs table
**		4/19/2018		 jcarlson		updated logic to use CQMCode and CQMCodeType from Programs Table to allow users to use different code systems
*******************************************************************************/
;
    WITH    cpclients
              AS ( SELECT   civ.ClientId ,
                            ba.ProgramId ,
                            ba.StartDate ,
                            ba.EndDate ,
                            ( SELECT TOP 1
                                        ProgramId
                              FROM      BedAssignments nba
                              WHERE     nba.BedAssignmentId = ba.NextBedAssignmentId
                            ) AS NewProgamId ,
                            ( SELECT TOP 1
                                        StartDate
                              FROM      BedAssignments nba
                              WHERE     nba.BedAssignmentId = ba.NextBedAssignmentId
                            ) AS NewStartDate ,
                            ( SELECT TOP 1
                                        EndDate
                              FROM      BedAssignments nba
                              WHERE     nba.BedAssignmentId = ba.NextBedAssignmentId
                            ) AS NewEndDate ,
                            ba.BedAssignmentId
                   FROM     ClientInpatientVisits civ
                            JOIN BedAssignments ba ON ba.ClientInpatientVisitId = civ.ClientInpatientVisitId
                   WHERE    Disposition = 5203
                            AND ba.[Status] = 5002
                            AND ISNULL(ba.RecordDeleted, 'N') = 'N'
                            AND ISNULL(civ.RecordDeleted, 'N') = 'N'
                 ),
            cpProgram
              AS ( SELECT   P.ProgramName ,
                            P1.ProgramName AS NewProgramName ,
                            P.CQMCode AS CQMCode ,
							gcP.Code AS CQMCodeName,
							gcP.ExternalCode1 AS CQMCodeSystem,
                            P1.CQMCode AS NewCQMCode ,
							gcP2.Code AS NewCQMCodeName,
							gcP2.ExternalCode1 AS NewCQMCodeSystem,
                            cc.ClientId ,
                            cc.StartDate ,
                            cc.EndDate ,
                            cc.NewStartDate ,
                            cc.NewEndDate ,
                            cc.BedAssignmentId
                   FROM     cpclients cc
                            LEFT JOIN Programs P ON cc.ProgramId = P.ProgramId
                                                    AND ISNULL(P.RecordDeleted,
                                                              'N') = 'N'
							LEFT JOIN GlobalCodes AS gcP ON p.CQMCodeType = gcP.GlobalCodeId
                            LEFT JOIN Programs P1 ON P1.ProgramId = cc.NewProgamId
                                                     AND ISNULL(P1.RecordDeleted,
                                                              'N') = 'N'
							LEFT JOIN GlobalCodes AS gcP2 ON p1.CQMCodeType = gcP2.GlobalCodeId
                 )
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
                        CLIENT_ID = CPP.ClientId ,
                        REC_TYPE = 'CQM' ,
                        SEC_TYPE = 'Transfer' ,
                        D001 = NULL ,
                        D002 = CPP.CQMCode ,
                        D003 = CPP.ProgramName ,
                        D004 = CPP.CQMCodeSystem ,
                        D005 = CPP.CQMCodeName ,
                        D006 = dbo.[GetDateFormatForLabSoft](CPP.StartDate,
                                                             '|^~\&') ,
                        D007 = dbo.[GetDateFormatForLabSoft](CPP.EndDate,
                                                             '|^~\&') ,
                        D008 = CPP.NewCQMCode ,
                        D009 = CPP.NewProgramName ,
                        D010 = CPP.NewCQMCodeSystem,
                        D011 = CPP.NewCQMCodeName ,
                        D012 = dbo.[GetDateFormatForLabSoft](CPP.NewStartDate,
                                                             '|^~\&') ,
                        D013 = dbo.[GetDateFormatForLabSoft](CPP.NewEndDate,
                                                             '|^~\&') ,
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
                        IDExtension = NULL ,
                        ACCOUNT_NUMBER = CPP.BedAssignmentId
                FROM    cpProgram CPP
                WHERE   EXISTS ( SELECT 1
                                 FROM  #Services AS a
                                 WHERE  a.ClientId = CPP.ClientId );
GO

