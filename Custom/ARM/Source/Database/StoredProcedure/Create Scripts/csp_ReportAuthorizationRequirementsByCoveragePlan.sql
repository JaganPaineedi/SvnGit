/****** Object:  StoredProcedure [dbo].[csp_ReportAuthorizationRequirementsByCoveragePlan]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportAuthorizationRequirementsByCoveragePlan]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportAuthorizationRequirementsByCoveragePlan]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportAuthorizationRequirementsByCoveragePlan]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE PROCEDURE [dbo].[csp_ReportAuthorizationRequirementsByCoveragePlan] @PayerType INT
AS 
    CREATE TABLE #Temp
        (
          PayerTypeName VARCHAR(100) ,
          PayerName VARCHAR(100) ,
          CoveragePlanName VARCHAR(100) ,
          CoveragePlanId INT ,
          ProcedureCodeName VARCHAR(100) ,
          ProcedureCodeId INT ,
          AuthRequired CHAR(1)
        )


    INSERT  INTO #Temp
            ( PayerTypeName ,
              PayerName ,
              CoveragePlanName ,
              CoveragePlanId ,
              ProcedureCodeName ,
              ProcedureCodeId 
            )
            SELECT DISTINCT
                    gc.codename ,
                    p.PayerName ,
                    cp.DisplayAs ,
                    cp.coverageplanid ,
                    pc.displayas ,
                    pc.procedurecodeid
            FROM    coverageplans cp
                    JOIN payers p ON p.payerid = cp.payerid
                    JOIN globalcodes gc ON gc.globalcodeid = p.payertype
                    JOIN coverageplanrules cpr ON cpr.coverageplanid = cp.coverageplanid
                                                  AND cpr.ruletypeid = 4264
                                                  AND ISNULL(cpr.recorddeleted,
                                                             ''N'') <> ''Y''

--left join coverageplanrulevariables cprv on cprv.coverageplanruleid = cpr.coverageplanruleid and isnull(cprv.recorddeleted, ''N'')<> ''Y''
                    LEFT JOIN procedurecodes pc ON pc.procedurecodeid = pc.procedurecodeid
                                                   AND pc.active = ''Y''
                                                   AND ISNULL(pc.recorddeleted,
                                                              ''N'') <> ''Y''
            WHERE   cp.active = ''Y''
                    AND ISNULL(cp.recorddeleted, ''N'') <> ''Y''
                    AND ISNULL(cpr.recorddeleted, ''N'') <> ''Y''
                    AND ( @PayerType IS NULL
                          OR @PayerType = gc.globalcodeid
                        )
            ORDER BY 1 ,
                    2 ,
                    3 ,
                    5


    UPDATE  t
    SET     AuthRequired = CASE WHEN t.procedurecodeid = cprv.procedurecodeid
                                THEN ''X''
                                ELSE ''''
                           END
    FROM    coverageplanrules cpr
            JOIN coverageplanrulevariables cprv ON cprv.coverageplanruleid = cpr.coverageplanruleid
            JOIN #temp t ON t.coverageplanid = cpr.coverageplanid
                            AND cprv.procedurecodeid = t.procedurecodeid
    WHERE   cpr.ruletypeid = 4264
            AND ISNULL(cpr.recorddeleted, ''N'') <> ''Y''
            AND ISNULL(cprv.recorddeleted, ''N'') <> ''Y''


    SELECT  *
    FROM    #temp
    ORDER BY CoveragePlanName ,
            ProcedureCodeName
' 
END
GO
