
/****** Object:  StoredProcedure [dbo].[ssp_SCUpdateStaffReportsTimelines]    Script Date: 06/20/2017 16:39:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCUpdateStaffReportsTimelines]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCUpdateStaffReportsTimelines]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCUpdateStaffReportsTimelines]    Script Date: 06/20/2017 16:39:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCUpdateStaffReportsTimelines]
AS /*********************************************************************/
/* Stored Procedure: dbo.ssp_SCUpdateStaffReportsTimelines           */
/* Creation Date:    9/25/06                                         */
/*                                                                   */
/* Purpose: Update Graph tables used by SmartCare		     */
/*                                                                   *//* Input Parameters:						     */
/*                                                                   */
/* Output Parameters:                                                */
/*                                                                   */
/* Return Status:                                                    */
/*                                                                   */
/* Called By: SQL Job Scheduler					     */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:                                                          */
/*   Date		Author      Purpose                                    */
/*  9/25/06		TER			Created                                    
	10/21/2010	avoss		Modififed for sc web and to use HRMServiceNOtes
	OCT-3-2014	dharvey		Optimized for performance.  Replaced DELETE/INSERT for TimelineServices 
							with TRUNCATE/INSERT to repopulate the table.
    6/20/2017  Gautam		What: Used Cast statement with Date and Time and added condition to check the ClientId and DateofService before adding the records in TimeLineServices table
						    Why: Interact - Support Task#649	*/						
/*	02/12/2018	Rajeshwari	Added Condition for ReportYear is to compare previous year ( Harbor - Support #1343)*/	
/*********************************************************************/


	SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

-- select * from TimeLineAxisV

-- may want to change this at a later date to retain values and just update existing rows.
-- this would become relevant if we were doing synchronization to the offline version of smartcare.
    --DELETE  FROM TimelineAxisV
    TRUNCATE TABLE TimelineAxisV
--select * from TimelineAxisV --select top 1 * from DiagnosesV  --Select top 1 * from CustomHRMServiceNotes
-- dx documents take precedence over Service-Specified GAF on a given date

    IF OBJECT_ID('tempdb..#DocumentsForTimeliness') IS NOT NULL 
        DROP TABLE #DocumentsForTimeliness

    SELECT  DocumentId ,
            CurrentDocumentVersionId ,
            ClientId ,
            EffectiveDate ,
            Status ,
            DocumentShared
    INTO    #DocumentsForTimeliness
    FROM    Documents
    WHERE   DocumentCodeId IN ( SELECT DocumentCodeId FROM DocumentCodes WHERE DiagnosisDocument = 'Y' ) 
            AND ISNULL(recorddeleted, 'N') = 'N'
	
	
    INSERT  INTO TimelineAxisV
            ( ClientId ,
              DiagnosisDate ,
              Score
            )
            SELECT  a.ClientId ,
                    a.DiagnosisDate ,
                    a.AxisV
            FROM    ( SELECT    b.ClientId ,
                                --CONVERT(DATETIME, CONVERT(VARCHAR, b.EffectiveDate, 101)) AS DiagnosisDate ,
                                CAST(b.EffectiveDate AS DATE) AS DiagnosisDate ,
                                MAX(a.AxisV) AS AxisV
                      FROM      DiagnosesV a --JOIN Documents b  ON ( a.DocumentVersionId = b.CurrentDocumentVersionId )
                                JOIN #DocumentsForTimeliness b ON ( a.DocumentVersionId = b.CurrentDocumentVersionId )
                      --WHERE     ISNULL(b.recorddeleted, 'N') <> 'Y'
                      WHERE     ( b.DocumentShared = 'Y'
                                  OR b.Status = 22
                                )
                                AND b.EffectiveDate IS NOT NULL
                                --AND a.AxisV IS NOT NULL
                                --AND a.AxisV <> 0
                                AND ISNULL(a.AxisV, 0) <> 0
                      GROUP BY  b.ClientId ,
                                --CONVERT(DATETIME, CONVERT(VARCHAR, b.EffectiveDate, 101))
                                CAST(b.EffectiveDate AS DATE) -- Gautam 6/20/2017
                    ) AS a
            WHERE   NOT EXISTS ( SELECT 1
                                 FROM   TimelineAxisV AS b
                                 WHERE  b.clientId = a.clientid
                                        AND cast(b.diagnosisdate as date) = a.diagnosisdate )


-- may want to change this at a later date to retain values and just update existing rows.
-- this would become relevant if we were doing synchronization to the offline version of smartcare.
    --DELETE  FROM TimelineHospitalizations
    TRUNCATE TABLE TimelineHospitalizations

--select * from timelinehospitalizations

    INSERT  INTO TimelineHospitalizations
            ( ClientId ,
              HospitalizationDate ,
              Activity
            )
            SELECT  a.ClientId ,
                    a.HospitalizationDate ,
                    a.Activity
            FROM    ( SELECT    ClientId ,
                                AdmitDate AS HospitalizationDate ,
                                'ADMIT' AS Activity
                      FROM      ClientHospitalizations
                      WHERE     Hospitalized = 'Y'
                                AND AdmitDate IS NOT NULL
                      UNION
                      SELECT    ClientId ,
                                DischargeDate ,
                                'DISCHARGE'
                      FROM      ClientHospitalizations
                      WHERE     Hospitalized = 'Y'
                                AND AdmitDate IS NOT NULL
                                AND DischargeDate IS NOT NULL
                    ) AS a
            WHERE   NOT EXISTS ( SELECT 1
                                 FROM   TimelineHospitalizations AS b
                                 WHERE  b.ClientId = a.ClientId
                                        AND cast(b.HospitalizationDate as date) = cast(a.HospitalizationDate as date) -- -- Gautam 6/20/2017
                                         AND b.Activity = a.Activity )

--
-- TimelineServices
--
    IF OBJECT_ID('tempdb..#ServicesForTimeliness') IS NOT NULL 
        DROP TABLE #ServicesForTimeliness
		
    SELECT  ServiceId ,
            ClientId ,
            DateOfService ,
            Status ,
            ClinicianId ,
            ProcedureCodeId ,
            UnitType ,
            Unit
    INTO    #ServicesForTimeliness
    FROM    services a
    WHERE   ISNULL(a.recorddeleted, 'N') = 'N'
           AND   a.Status IN ( 71, 75 )
            -- -- Gautam 6/20/2017
            and not exists(Select 1 from TimelineServices b where b.ClientId=a.ClientId
									and cast(b.ServiceDate as date)= a.DateOfService)


/** REPLACED DELETE/INSERT due to performance issues **/
    TRUNCATE TABLE TimelineServices

	
    INSERT  INTO TimelineServices
            ( ClientId ,
              ServiceDate
            )
            SELECT DISTINCT
                    ClientId ,
                    CAST(a.DateOfService AS DATE)
            FROM    #ServicesForTimeliness a
           


/*
 update the staff reports table.  this runs fast enough; so we don't care whether or not they
 are SmartCare users.
*/
--
-- update existing rows.
--
    UPDATE  b
    SET     FaceToFaceHours = CAST(a.FaceToFaceHours AS INT) ,
            ModifiedBy = 'PracticeManagement' ,
            ModifiedDate = GETDATE()
    FROM    StaffReports AS b
            JOIN ( SELECT   a.StaffId ,
                            DATEPART(yyyy, b.DateOfService) AS ReportYear ,
         DATEPART(mm, b.DateOfService) AS ReportMonth ,
                            SUM(( d.CreditPercentage / 100.0 ) * b.Unit * ( CASE WHEN b.UnitType = 111 THEN 60
                                                                                 ELSE 1
                                                                            END )) / 60 AS FacetoFaceHours
                   FROM     Staff AS a --JOIN Services AS b  ON ( b.ClinicianId = a.StaffId )
                            JOIN #ServicesForTimeliness AS b ON ( b.ClinicianId = a.StaffId )
                            JOIN ProcedureCodes AS d ON ( d.ProcedurecodeId = b.ProcedureCodeId )
                   --WHERE    ISNULL(b.RecordDeleted, 'N') <> 'Y'
                   WHERE    b.Status = 75	-- complete
                            AND b.DateOfService >= CONVERT(DATETIME, CONVERT(VARCHAR, DATEPART(mm, GETDATE())) + '/1/' + CONVERT(VARCHAR, DATEPART(yy, GETDATE()) - 1))
                            AND b.UnitType IN ( 111, 110 )	-- (hours, minutes)
                            AND d.FaceToFace = 'Y'
                   GROUP BY a.StaffId ,
                            DATEPART(yyyy, b.DateOfService) ,
                            DATEPART(mm, b.DateOfService)
                 ) AS a ON ( b.staffId = a.StaffId
                             AND b.ReportYear = a.ReportYear
                             AND b.ReportMonth = a.ReportMonth
                           )
    WHERE   ISNULL(b.facetofacehours, -1) <> ISNULL(CAST(a.FaceToFaceHours AS INT), -1)


    INSERT  INTO StaffReports
            ( StaffId ,
              ReportYear ,
              ReportMonth ,
              FaceToFaceHours ,
              CreatedBy ,
              CreatedDate ,
              ModifiedBy ,
              ModifiedDate
            )
            SELECT  a.StaffId ,
                    a.ReportYear ,
                    a.ReportMonth ,
                    CAST(a.FaceToFaceHours AS INT) ,
                    'PracticeManagement' ,
                    GETDATE() ,
                    'PracticeManagement' ,
                    GETDATE()
            FROM    ( SELECT    a.StaffId ,
                                DATEPART(yyyy, b.DateOfService) AS ReportYear ,
                                DATEPART(mm, b.DateOfService) AS ReportMonth ,
                                SUM(( d.CreditPercentage / 100.0 ) * b.Unit * ( CASE WHEN b.UnitType = 111 THEN 60
                                                                                     ELSE 1
                                                                                END )) / 60 AS FacetoFaceHours
                      FROM      Staff AS a --JOIN Services AS b  ON ( b.ClinicianId = a.StaffId )
                                JOIN #ServicesForTimeliness AS b ON ( b.ClinicianId = a.StaffId )
                                JOIN ProcedureCodes AS d ON ( d.ProcedurecodeId = b.ProcedureCodeId )
                      --WHERE     ISNULL(b.RecordDeleted, 'N') <> 'Y'
                      WHERE     b.Status = 75	-- complete
                                AND b.DateOfService >= CONVERT(DATETIME, CONVERT(VARCHAR, DATEPART(mm, GETDATE())) + '/1/' + CONVERT(VARCHAR, DATEPART(yy, GETDATE()) - 1))
                                AND b.UnitType IN ( 111, 110 )	-- (hours, minutes)
                                AND d.FaceToFace = 'Y'
                      GROUP BY  a.StaffId ,
                                DATEPART(yyyy, b.DateOfService) ,
                                DATEPART(mm, b.DateOfService)
                    ) AS a
            WHERE   NOT EXISTS ( SELECT 1
                                 FROM   StaffReports AS b
                                 WHERE  b.StaffId = a.StaffId
                                        AND b.ReportYear = a.reportYear
                                        AND b.ReportMonth = a.ReportMonth )

--
-- update PrimaryCaseload, TotalCaseload, PrimaryAxisV for the current month only
--

    DECLARE @caseloadclients TABLE
        (
          staffid INT ,
          clientid INT
        )

-- do totals first
    INSERT  INTO @caseloadclients
            SELECT  a.primaryclinicianid AS StaffId ,
                    a.ClientId
            FROM    clients AS a
            WHERE   a.active = 'Y'
                    AND ISNULL(a.recorddeleted, 'N') <> 'Y'
-- or client was seen by clinician in last six months
            UNION
            SELECT  c.ClinicianId AS StaffId ,
                    a.clientid
            FROM    Clients a --JOIN Services c  ON ( a.ClientId = c.ClientId )
                    JOIN #ServicesForTimeliness c ON ( a.ClientId = c.ClientId )
            WHERE   a.active = 'Y'
                    AND c.DateOfService >= DATEADD(month, -6, GETDATE())
                    AND ISNULL(a.RecordDeleted, 'N') <> 'Y'
                    --AND ISNULL(c.RecordDeleted, '') <> 'Y'
                    AND c.status NOT IN ( 72, 73 )

    UPDATE  b
    SET     TotalCaseload = summ.sum_cases ,
            ModifiedBy = 'PracticeManagement' ,
            ModifiedDate = GETDATE()
    FROM    StaffReports AS b
            JOIN ( SELECT   staffid ,
                            COUNT(*) AS sum_cases
                   FROM     @caseloadclients
                   GROUP BY staffid
                 ) AS summ ON ( summ.StaffId = b.StaffId )
    WHERE   b.ReportYear = DATEPART(year, GETDATE())-1
            AND b.ReportMonth = DATEPART(month, GETDATE())
    --WHERE   DATEDIFF(yy, b.ReportYear, GETDATE()) = 0
    --        AND DATEDIFF(yy, b.ReportMonth, GETDATE()) = 0


-- now delete the clients who are not primary
    DELETE  FROM a
    FROM    @caseloadclients AS a
            JOIN clients AS b ON b.clientid = a.clientid
    WHERE   b.PrimaryClinicianId <> a.staffid

-- all that are left are primary
    UPDATE  b
    SET     PrimaryCaseload = summ.sum_cases ,
            ModifiedBy = 'PracticeManagement' ,
            ModifiedDate = GETDATE()
    FROM    StaffReports AS b
            JOIN ( SELECT   staffid ,
                            COUNT(*) AS sum_cases
                   FROM     @caseloadclients
                   GROUP BY staffid
                 ) AS summ ON ( summ.StaffId = b.StaffId )
    WHERE   b.ReportYear = DATEPART(year, GETDATE())-1    -----02/12/2018	Rajeshwari
            AND b.ReportMonth = DATEPART(month, GETDATE())
    --WHERE   DATEDIFF(yy, b.ReportYear, GETDATE()) = 0
    --        AND DATEDIFF(yy, b.ReportMonth, GETDATE()) = 0


-- TimelineAxisV is tricky.  Get the most recent axis V for each client and average them
-- for each clinician's caseload.

    UPDATE  b
    SET     PrimaryAxisV = summ.avg_axisv ,
            ModifiedBy = 'PracticeManagement' ,
            ModifiedDate = GETDATE()
    FROM    StaffReports AS b
            JOIN ( SELECT   a.staffid ,
                            AVG(b.Score) AS avg_axisv
                   FROM     @caseloadclients AS a
                            JOIN TimelineAxisV AS b ON ( b.ClientId = a.clientid )
                   WHERE    NOT EXISTS ( SELECT 1
                                         FROM   TimelineAxisV c
                                         WHERE  c.ClientId = b.ClientId
                                                AND c.DiagnosisDate > b.DiagnosisDate )
                   GROUP BY a.staffid
                 ) AS summ ON ( summ.StaffId = b.StaffId )
    WHERE   b.ReportYear = DATEPART(year, GETDATE())-1   -----02/12/2018	Rajeshwari
            AND b.ReportMonth = DATEPART(month, GETDATE())
    --WHERE   DATEDIFF(yy, b.ReportYear, GETDATE()) = 0  
    --        AND DATEDIFF(yy, b.ReportMonth, GETDATE()) = 0

GO


