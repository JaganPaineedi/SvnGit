/****** Object:  StoredProcedure [dbo].[csp_ReportDailySchedule]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportDailySchedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportDailySchedule]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportDailySchedule]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE   PROCEDURE [dbo].[csp_ReportDailySchedule]
/********************************************************************************                                                  
-- Stored Procedure: [csp_ReportDailySchedule]
--
-- Copyright: Streamline Healthcate Solutions
--
-- Purpose: Query to return data for the program assignment list page.
--
-- Author:  Pradeep
-- Date:    
--
-- *****History****
-- 22/03/2012		MSuma		Modified ReceptionStatus
-- 26/04/2012       Shruthi.S   Uncommented OrganizationName changes since it was required and changed the globalcodeids since for category ''receptionstatus'' globalcodeids are 6852,6853,6851
-- May 8, 2012      Kneale Alpers Modified the status (codename from globalcodes 250 chars) to substring the value to only 20 characters.

-- 23/05/2012       Shruthi.S   PrimaryCoverage and SecondaryCoverage is changed to 250 chars
*********************************************************************************/
    @SelectedDate SMALLDATETIME ,
    @ReceptionViewId INT ,
    @Status VARCHAR(100)
AS 
    DECLARE @ServiceStatuses TABLE ( Status INT )

--select * from globalCodes where category = ''ReceptionStatus'' select * from globalCodes where category=''servicestatus''
    INSERT  INTO @ServiceStatuses
            ( Status
            )
            SELECT  globalCodeId
            FROM    GlobalCodes
            WHERE   ( @status = 6852
                      AND globalCodeId IN ( 70, 71 )
                    )
                    OR ( @status = 6853
                         AND globalCodeId IN ( 72, 73 )
                       )
                    OR ( @status = 6851
                         AND globalCodeId IN ( 70 )
                       )
                    OR ( @status = 0
                         AND globalCodeId IN ( 70, 71, 72, 73, 76, 75 )
                       ) 

    CREATE TABLE #Results
        (
          ClientId INT ,
          ClientName VARCHAR(100) ,
          [Procedure] VARCHAR(300) ,
          [DateTime] SMALLDATETIME ,
          Status VARCHAR(20) ,
          Staff VARCHAR(300) ,
          MedicaidId VARCHAR(20) ,
          PrimaryCoverage VARCHAR(250) ,
          SecondaryCoverage VARCHAR(250) ,
          OrganizationName VARCHAR(100)
        )        
    INSERT  INTO #Results
            ( ClientId ,
              ClientName ,
              [Procedure] ,
              [DateTime] ,
              [Status],
              Staff
            )
            SELECT  a.clientId AS ''ClientId'' ,
                    b.LastName + '', '' + b.FirstName AS ''ClientName'' ,
                    d.displayAs AS ''Procedure'' ,
                    CONVERT(varchar,a.DateTimeIn,108) AS ''DateTime'' , 
                    SUBSTRING(e.CodeName, 1, 20) ,
                    c.firstName + '' '' + c.lastName AS ''Staff''
            FROM    services a
                    JOIN clients b ON b.clientId = a.clientId
                    JOIN staff c ON a.clinicianId = c.staffId
                    JOIN procedureCodes d ON a.procedureCodeId = d.procedureCodeId
                    JOIN globalCodes e ON e.globalCodeId = a.[status]
                    JOIN @serviceStatuses h ON a.[status] = h.[status]
            WHERE   DATEDIFF(day, a.DateOfService, @SelectedDate) = 0
                    AND EXISTS --Work through the receptionViews
	( SELECT  *
        FROM    ReceptionViews rv
                LEFT JOIN ReceptionViewLocations rvl ON rv.ReceptionViewId = rvl.ReceptionViewId
                LEFT JOIN ReceptionViewPrograms rvp ON rv.ReceptionViewId = rvp.ReceptionViewId
                LEFT JOIN ReceptionViewStaff rvs ON rv.ReceptionViewId = rvs.ReceptionViewId
        WHERE   rv.ReceptionViewId = @ReceptionViewId
                AND ( rv.AllLocations = ''Y''
                      OR a.LocationId = rvl.LocationId
                    )
                AND ( rv.AllPrograms = ''Y''
                      OR a.ProgramId = rvp.ProgramId
                    )
                AND ( rv.AllStaff = ''Y''
                      OR a.clinicianId = rvs.StaffId
                    ) )
                    AND ISNULL(a.RecordDeleted, ''N'') = ''N''
                    AND ISNULL(b.RecordDeleted, ''N'') = ''N''
                    AND ISNULL(c.RecordDeleted, ''N'') = ''N''
                    AND ISNULL(d.RecordDeleted, ''N'') = ''N''
                    AND ISNULL(e.RecordDeleted, ''N'') = ''N''
	

    UPDATE  a
    SET     PrimaryCoverage = cp1.CoveragePlanName
    FROM    #Results a
            JOIN ClientCoveragePlans ccp1 ON a.clientId = ccp1.clientId
            JOIN ClientCoverageHistory ch1 ON ccp1.clientCoveragePlanId = ch1.ClientCoveragePlanId
            JOIN CoveragePlans cp1 ON cp1.coveragePlanId = ccp1.CoveragePlanId
    WHERE   ch1.COBOrder = 1
            AND ch1.StartDate <= a.[DateTime]
            AND ( ch1.EndDate >= a.[DateTime]
                  OR ch1.EndDate IS NULL
                )

    UPDATE  a
    SET     SecondaryCoverage = cp1.CoveragePlanName
    FROM    #Results a
            JOIN ClientCoveragePlans ccp1 ON a.clientId = ccp1.clientId
            JOIN ClientCoverageHistory ch1 ON ccp1.clientCoveragePlanId = ch1.ClientCoveragePlanId
            JOIN CoveragePlans cp1 ON cp1.coveragePlanId = ccp1.CoveragePlanId
    WHERE   ch1.COBOrder = 2
            AND ch1.StartDate <= a.[DateTime]
            AND ( ch1.EndDate >= a.[DateTime]
                  OR ch1.EndDate IS NULL
                )

--Check for MedVenture coverage IP or OP.  If both exist, get the ID from the OP coverage
    UPDATE  a
    SET     MedicaidId = ccp1.InsuredId
    FROM    #Results a
            JOIN ClientCoveragePlans ccp1 ON a.clientId = ccp1.clientId
            JOIN ClientCoverageHistory ch1 ON ccp1.clientCoveragePlanId = ch1.ClientCoveragePlanId
            JOIN CoveragePlans cp1 ON cp1.coveragePlanId = ccp1.CoveragePlanId
    WHERE   ch1.StartDate <= a.[DateTime]
            AND ( ch1.EndDate >= a.[DateTime]
                  OR ch1.EndDate IS NULL
                )
            AND cp1.MedicaidPlan = ''Y''
            AND NOT EXISTS ( SELECT *
                             FROM   clientCoveragePlans ccp2
                                    JOIN coveragePlans cp2 ON ccp2.coveragePlanId = cp2.CoveragePlanId
                             WHERE  ccp2.ClientCoveragePlanId = ccp1.ClientCoveragePlanId
                                    AND cp2.CoveragePlanId > cp1.CoveragePlanId )

    UPDATE  a
    SET     a.OrganizationName = sc.OrganizationName
    FROM    #Results a
            CROSS JOIN SystemConfigurations sc

    SELECT  a.ClientId ,
            a.ClientName ,
            convert(varchar,a.[DateTime],108) as [DateTime], 
            a.MedicaidId ,
            a.PrimaryCoverage ,
            a.[Procedure] ,
            a.SecondaryCoverage ,
            a.Staff ,
            a.[Status] ,
            sc.OrganizationName
    FROM    dbo.SystemConfigurations sc
            LEFT JOIN #results a ON 1 = 1
    ORDER BY [DateTime] ,
            ClientName ,
            Staff




' 
END
GO
