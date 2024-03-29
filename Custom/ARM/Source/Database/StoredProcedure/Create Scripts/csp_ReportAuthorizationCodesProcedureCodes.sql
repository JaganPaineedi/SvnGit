/****** Object:  StoredProcedure [dbo].[csp_ReportAuthorizationCodesProcedureCodes]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportAuthorizationCodesProcedureCodes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportAuthorizationCodesProcedureCodes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportAuthorizationCodesProcedureCodes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE PROCEDURE [dbo].[csp_ReportAuthorizationCodesProcedureCodes]
AS 
    CREATE TABLE #Temp
        (
          AuthorizationCodeName VARCHAR(100) ,
          AuthorizationCodeId INT ,
          ProcedureCodeName VARCHAR(100) ,
          ProcedureCodeId INT ,
          AuthRequired CHAR(1)
        )


    INSERT  INTO #Temp
            ( AuthorizationCodeName ,
              AuthorizationCodeId ,
              ProcedureCodeName ,
              ProcedureCodeId 
            )
            SELECT DISTINCT
                    ac.Displayas ,
                    ac.AuthorizationCodeId ,
                    pc.displayas ,
                    pc.procedurecodeid
            FROM    AuthorizationCodes ac
                    LEFT JOIN AuthorizationCodeProcedureCodes acpc ON acpc.authorizationcodeid = ac.authorizationcodeid
                    LEFT JOIN ProcedureCodes pc ON pc.ProcedureCodeId = pc.ProcedureCodeId
                                                   AND pc.active = ''Y''
                                                   AND ISNULL(pc.RecordDeleted,
                                                              ''N'') <> ''Y''
            WHERE   ac.active = ''Y''
                    AND ISNULL(ac.RecordDeleted, ''N'') <> ''Y''
                    AND ISNULL(acpc.RecordDeleted, ''N'') <> ''Y''
            ORDER BY 1 ,
                    3


    UPDATE  t
    SET     AuthRequired = CASE WHEN t.procedurecodeid = acpc.procedurecodeid
                                THEN ''X''
                                ELSE ''''
                           END
    FROM    AuthorizationCodeProcedureCodes acpc
            JOIN #Temp t ON acpc.AuthorizationCodeId = t.AuthorizationCodeId
                            AND acpc.ProcedureCodeid = t.ProcedureCodeId
                            AND ISNULL(acpc.Recorddeleted, ''N'') <> ''Y''





    SELECT  *
    FROM    #temp
    ORDER BY AuthorizationCodeName ,
            ProcedureCodeName
' 
END
GO
