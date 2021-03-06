/****** Object:  StoredProcedure [dbo].[csp_ReportPrintCallReminder]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportPrintCallReminder]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportPrintCallReminder]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportPrintCallReminder]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
  
    
CREATE PROCEDURE [dbo].[csp_ReportPrintCallReminder]
    @ApptDate SMALLDATETIME ,
    @ReceptionView INT
AS 
    BEGIN  
/********************************************************************************  
-- Stored Procedure: dbo.[csp_ReportPrintCallReminder]   
--  
-- Copyright: 2006 Streamline Healthcate Solutions  
--  
-- Purpose: Generates data for Call Reminder Report  
--   
--   
--  
-- Updates:                                                         
-- Date        Author      Purpose  
-- 06.04.2012  JJN        Created  
  08.08.2012	avoss		modified primary clinician logic
*********************************************************************************/  
        DECLARE @statusScheduled INT = 70  
  
--Client ID, Name, Appt date and time, phone numbers,clinician, procedure code, location, and sorted by clinician/date  
  
        CREATE TABLE #ClientPhones
            (
              ClientId INT ,
              Phones VARCHAR(500),  
            )  
  
        INSERT  INTO #ClientPhones
                ( Clientid ,
                  Phones
                )
                SELECT DISTINCT
                        s.ClientId ,
                        ''''
                FROM    Services s
                WHERE   DATEDIFF(dd, @ApptDate, s.DateofService) = 0  
  
--Concatenate Phone Numbers  
        UPDATE  a
        SET     a.Phones = b.Phones
        FROM    #ClientPhones a
                JOIN ( SELECT   b1.ClientId ,
                                ( SELECT    ''(''
                                            + CASE WHEN CHARINDEX(''2'',
                                                              gc.CodeName, 1) > 0
                                                   THEN LEFT(gc.CodeName, 1)
                                                        + ''2''
                                                   ELSE LEFT(gc.CodeName, 1)
                                              END + '') ''
                                            + COALESCE(PhoneNumber
                                                       + CASE WHEN DoNotContact = ''Y''
                                                              THEN '' (DNC)''
                                                              ELSE ''''
                                                         END, '''') + ''~''
                                  FROM      ClientPhones b2
                                            JOIN dbo.GlobalCodes gc ON ( gc.Category = ''PHONETYPE''
                                                              AND gc.GlobalCodeId = b2.PhoneType
                                                              )
                                  WHERE     b2.ClientId = b1.ClientId
                                            AND ISNULL(b2.RecordDeleted, ''N'') = ''N''
                                  ORDER BY  SortOrder--PhoneNumber
                                FOR
                                  XML PATH('''')
                                ) AS Phones
                       FROM     ClientPhones b1
                       WHERE    ISNULL(b1.RecordDeleted, ''N'') = ''N''
                       GROUP BY ClientId
                     ) b ON b.ClientId = a.ClientId  
  
        UPDATE  #ClientPhones
        SET     Phones = NULL
        WHERE   LEN(Phones) = 0  
  
        SELECT  c.ClientId ,
                ClientName = c.LastName + '', '' + c.FirstName + COALESCE('' ''
                                                              + LEFT(c.MiddleName,
                                                              1) + ''.'', '''') ,
                StartTime = CONVERT(VARCHAR(50), s.DateofService, 100) ,
                Phones = REPLACE(LEFT(cp.Phones,
                                      COALESCE(LEN(cp.Phones) - 1, 0)), ''~'',
                                 CHAR(13) + CHAR(10)) ,
                pc.ProcedureCodeName ,
                l.LocationName ,
                ClinicianName = clin.LastName + '', '' + clin.FirstName
                + COALESCE('' '' + UPPER(LEFT(LTRIM(clin.MiddleName), 1)) + ''.'',
                           '''') ,
                PrimaryName = prim.LastName + '', '' + prim.FirstName
                + COALESCE('' '' + UPPER(LEFT(LTRIM(prim.MiddleName), 1)) + ''.'',
                           '''') ,
                s.DateOfService
        FROM    ReceptionViews r
                LEFT JOIN ReceptionViewLocations rvl ON rvl.ReceptionViewId = r.ReceptionViewId
                                                        AND r.AllLocations <> ''Y''
                LEFT JOIN ReceptionViewStaff rvs ON rvs.ReceptionViewId = r.ReceptionViewId
                                                    AND r.AllStaff <> ''Y''
                LEFT JOIN ReceptionViewPrograms rvp ON rvp.ReceptionViewId = r.ReceptionViewId
                                                       AND r.AllPrograms <> ''Y''
                JOIN Services s ON ( s.LocationId = rvl.LocationId
                                     OR r.AllLocations = ''Y''
                                   )
                                   AND ( s.ProgramId = rvp.ProgramId
                                         OR r.AllPrograms = ''Y''
                                       )
                                   AND ( s.ClinicianId = rvs.Staffid
                                         OR r.AllStaff = ''Y''
                                       )
                                   AND DATEDIFF(dd, @ApptDate, s.DateofService) = 0
                                   AND s.Status = @statusScheduled
                JOIN Clients c ON c.ClientId = s.ClientId
                JOIN dbo.Locations AS l ON l.LocationId = s.LocationId
                LEFT JOIN Staff clin ON clin.StaffId = s.ClinicianId 
/*avoss change per Jess 08.08.2012*/
Left Join Staff prim on prim.StaffId =  ISNULL(c.PrimaryClinicianId,

                --LEFT JOIN Staff prim ON prim.StaffId = ISNULL(
															( SELECT TOP 1
                                                              ClinicianId
                                                              FROM
                                                              Services x
                                                              JOIN ProcedureCodes pc ON x.ProcedureCodeId = pc.ProcedureCodeId
                                                              WHERE
                                                              x.ClientId = c.ClientId
                                                              AND ISNULL(x.RecordDeleted,
                                                              ''N'') = ''N''
                                                              AND x.status IN (
                                                              71, 75 )
                                                              AND pc.DisplayAs LIKE ''CSP%''
                                                              ORDER BY x.DateOfService DESC
                                                              ))
                                                              --,c.PrimaryClinicianId)
                JOIN ProcedureCodes pc ON pc.ProcedureCodeId = s.ProcedureCodeId
                LEFT JOIN #ClientPhones cp ON cp.ClientId = s.ClientId
        WHERE   DATEDIFF(dd, @ApptDate, s.DateofService) = 0
                AND r.ReceptionViewId = @ReceptionView
                AND ISNULL(r.RecordDeleted, ''N'') = ''N''
                AND ISNULL(s.RecordDeleted, ''N'') = ''N''
                AND ISNULL(c.RecordDeleted, ''N'') = ''N''
                AND ISNULL(clin.RecordDeleted, ''N'') = ''N''
                AND ISNULL(prim.RecordDeleted, ''N'') = ''N''
                AND ISNULL(pc.RecordDeleted, ''N'') = ''N''
                AND ISNULL(rvl.RecordDeleted, ''N'') = ''N''
                AND ISNULL(rvs.RecordDeleted, ''N'') = ''N''
                AND ISNULL(rvp.RecordDeleted, ''N'') = ''N''
        ORDER BY clin.LastName ,
                clin.FirstName ,
                s.DateofService  
  
    END  
' 
END
GO
