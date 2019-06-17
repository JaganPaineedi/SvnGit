IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCCalculateOpenPeriodProductivityMetrics]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCCalculateOpenPeriodProductivityMetrics]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCCalculateOpenPeriodProductivityMetrics] @ProductivityDate AS DATE = NULL
	,@StaffId AS INT = NULL
	,@ProgramId AS INT = NULL
AS -- =============================================  
-- Author:  Suhail Ali  
-- Create date: 4/3/2012  
-- Description: Calculates daily staff productivity metrics for open productivity periods.  Stores the calculation  
--    in a table for easy consumption for reports and dashboards.  If no staffid or programid is passed   
--    into the sp then it calculate productivity metrics for all staff for the current open productivity   
--    period.  
-- Example Usage:   
--  
-- Calculate for all open period staff and programs   
-- EXEC [dbo].[csp_SCCalculateOpenPeriodProductivityMetrics] NULL, NULL, NULL   
--  
-- Calculate for open period for a specific staff  
-- DECLARE @StaffId AS INT  
-- SELECT @StaffId = StaffId FROM Staff WHERE UserCode = 'ChrisTeamA'  
-- EXEC [dbo].[ssp_SCCalculateOpenPeriodProductivityMetrics] NULL, @StaffId, NULL 
-- Modified Date		Modified By		Purpose
-- 26-Sep-2016			Irfan			What: Corrected Alias name from staff1.StaffId to staff.StaffId 
--										as we are using an Alias for the temporary table #Staff as staff and
--										we were pulling staffId from this temporary table #Staff 
--										Why:  Pathway - Support Go Live - #222
--24/10/2018 Neethu    Modified  logic to exclude Non staff users from 'Documented Service Totals Widget' 

-- =============================================  
BEGIN
	BEGIN TRY
		IF OBJECT_ID('tempdb..#DailyStaffServiceHours') IS NOT NULL
			DROP TABLE #DailyStaffServiceHours

		IF OBJECT_ID('tempdb..#StaffProgramProductivityTarget') IS NOT NULL
			DROP TABLE #StaffProgramProductivityTarget

		IF OBJECT_ID('tempdb..#ProgramProductivity') IS NOT NULL
			DROP TABLE #ProgramProductivity

		IF OBJECT_ID('tempdb..#Staff') IS NOT NULL
			DROP TABLE #Staff

		IF @ProductivityDate IS NULL
			SELECT @ProductivityDate = CAST(GETDATE() AS DATE)

		DECLARE @OpenPeriodDaysBack AS INT = 180;-- 6 months (used to be 15 days)  

		-- If no records then lets do a full load going back 1 year  
		IF NOT EXISTS (
				SELECT *
				FROM dbo.DailyStaffProductivity
				)
			SELECT @OpenPeriodDaysBack = 365

		-- Populate Staff to calculate producitivity period  
		CREATE TABLE #Staff (
			StaffId INT NOT NULL
			,NAME VARCHAR(50) NOT NULL
			,HoursTimeOffProjected INT NOT NULL
			,PRIMARY KEY CLUSTERED ([StaffId] ASC) ON [PRIMARY]
			) ON [PRIMARY]

		INSERT INTO #Staff (
			StaffId
			,NAME
			,HoursTimeOffProjected
			)
		SELECT Staff.StaffId
			,Staff.UserCode AS NAME
			,ISNULL(ProjectedTimeOffHours, 0) AS HoursTimeOffProjected
		FROM Staff
		WHERE ISNULL(Staff.RecordDeleted, 'N') = 'N'
			AND Staff.UserCode IS NOT NULL
			AND (
				Staff.StaffId = @StaffId
				OR @StaffId IS NULL
				)
				and ISNULL(Staff.NonStaffUser,'N') = 'N'
		CREATE NONCLUSTERED INDEX IX_#Staff_Program ON #Staff (StaffId)

		CREATE TABLE #ProgramProductivity (
			ProgramProductivityId INT NOT NULL
			,ProgramId INT NOT NULL
			,StartDate DATE NOT NULL
			,EndDate DATE NULL PRIMARY KEY CLUSTERED ([ProgramProductivityId] ASC) WITH (
				PAD_INDEX = OFF
				,STATISTICS_NORECOMPUTE = OFF
				,IGNORE_DUP_KEY = OFF
				,ALLOW_ROW_LOCKS = ON
				,ALLOW_PAGE_LOCKS = ON
				) ON [PRIMARY]
			) ON [PRIMARY]

		-- Determine which productivity periods will be calculated based on today's date going back 15 days  
		INSERT INTO #ProgramProductivity (
			ProgramProductivityId
			,ProgramId
			,StartDate
			,EndDate
			)
		SELECT pppd.ProgramProductivityPeriodDateId AS ProgramProductivityId
			,ProgramId AS ProgramId
			,pppd.StartDate
			,pppd.EndDate
		FROM ProgramProductivityPeriods ppp
		INNER JOIN ProgramProductivityPeriodDates pppd ON ppp.ProgramProductivityPeriodId = pppd.ProgramProductivityPeriodId
			AND ISNULL(ppp.RecordDeleted, 'N') = 'N'
			AND ISNULL(pppd.RecordDeleted, 'N') = 'N'
		CROSS JOIN (
			SELECT @ProductivityDate AS CurrentDay
			) dt
		WHERE dt.CurrentDay >= pppd.StartDate
			AND dt.CurrentDay <= DATEADD(DAY, @OpenPeriodDaysBack, pppd.EndDate)
			AND (
				ppp.ProgramId = @ProgramId
				OR @ProgramId IS NULL
				)

		CREATE NONCLUSTERED INDEX IX_#ProgramProductivity_Program ON #ProgramProductivity (
			ProgramId
			,StartDate
			)

		CREATE TABLE #StaffProgramProductivityTarget (
			StaffProgramProductivityTargetId INT IDENTITY(1, 1) NOT NULL
			,StaffId INT NOT NULL
			,ProgramId INT NOT NULL
			,StartDate DATE NOT NULL
			,EndDate DATE NOT NULL
			,PercentWorked DECIMAL(3, 2) NOT NULL PRIMARY KEY CLUSTERED ([StaffProgramProductivityTargetId] ASC) WITH (
				PAD_INDEX = OFF
				,STATISTICS_NORECOMPUTE = OFF
				,IGNORE_DUP_KEY = OFF
				,ALLOW_ROW_LOCKS = ON
				,ALLOW_PAGE_LOCKS = ON
				) ON [PRIMARY]
			) ON [PRIMARY]

		INSERT INTO #StaffProgramProductivityTarget (
			StaffId
			,ProgramId
			,StartDate
			,EndDate
			,PercentWorked
			)
		SELECT stt.StaffId
			,stt.ProgramId
			,CASE 
				WHEN stt.StartDate > tp.StartDate
					THEN stt.StartDate
				ELSE tp.StartDate
				END AS StartDate
			,CASE 
				WHEN stt.EndDate < tp.EndDate
					THEN stt.EndDate
				ELSE tp.EndDate
				END AS EndDate
			,stt.PercentageWorked / 100.0 AS PercentageWorked
		FROM dbo.StaffTargetTemplates stt
		INNER JOIN #ProgramProductivity tp ON stt.ProgramId = tp.ProgramId
			AND (
				(
					stt.StartDate <= tp.StartDate
					AND (
						stt.EndDate >= tp.EndDate
						OR stt.EndDate IS NULL
						)
					)
				OR -- within range  
				(
					stt.StartDate >= tp.StartDate
					AND stt.StartDate <= tp.EndDate
					)
				OR -- overlap begin range  
				(
					stt.EndDate >= tp.StartDate
					AND stt.EndDate <= tp.EndDate
					)
				) --overlap end range  
		WHERE (
				stt.StaffId = @StaffId
				OR @StaffId IS NULL
				)
			AND (
				stt.ProgramId = @ProgramId
				OR @ProgramId IS NULL
				)
			AND ISNULL(stt.RecordDeleted, 'N') = 'N'

		CREATE NONCLUSTERED INDEX IX_#StaffProgramProductivityTarget_StaffProgram ON #StaffProgramProductivityTarget (
			StaffId
			,ProgramId
			,StartDate
			)

		CREATE TABLE #DailyStaffServiceHours (
			DailyStaffServiceHoursId INT IDENTITY(1, 1) NOT NULL
			,ServiceDate DATE NOT NULL
			,StaffId INT NOT NULL
			,ProgramId INT NOT NULL
			,ActualHours DECIMAL(10, 2) NULL
			,NumberOfServices INT NULL
			,AvgLag DECIMAL(10, 2) NULL -- This is the avg lag of service notes signed on this day                  
			PRIMARY KEY CLUSTERED ([DailyStaffServiceHoursId] ASC) WITH (
				PAD_INDEX = OFF
				,STATISTICS_NORECOMPUTE = OFF
				,IGNORE_DUP_KEY = OFF
				,ALLOW_ROW_LOCKS = ON
				,ALLOW_PAGE_LOCKS = ON
				) ON [PRIMARY]
			) ON [PRIMARY]

		DECLARE @FunctionName VARCHAR(200)

		SELECT @FunctionName = Value
		FROM SystemConfigurationKeys
		WHERE "Key" = 'ProductivityServiceHourCalculationFunction'

		EXEC scsp_SCCalculateOpenPeriodProductivityMetrics @StaffId
			,@ProgramId

		CREATE NONCLUSTERED INDEX IX_#DailyStaffServiceHours_StaffProgram ON #DailyStaffServiceHours (
			StaffId
			,ProgramId
			,ServiceDate
			);

		DECLARE @strSQL NVARCHAR(max) = 
			'; WITH    DailyStaffProductivity    
                  AS ( SELECT   dssh.ServiceDate AS ProductivityDate ,  
                                dssh.StaffId ,  
                                stpt.ProgramId ,  
                                ISNULL(( SELECT COUNT(*)  
                                         FROM   Dates dt  
                                         WHERE  dt.Date BETWEEN tp.StartDate AND tp.EndDate  
                                                AND IsWorkDay = ''Y''  
                                       ), 0) AS TotalBusinessDaysInPeriod ,  
                                ISNULL(( SELECT COUNT(DISTINCT Date)  
                                         FROM   Dates idt  
                                                INNER JOIN #StaffProgramProductivityTarget istpt  
                                                    ON istpt.StaffId = stpt.StaffId  
                                                       AND istpt.ProgramId = stpt.ProgramId  
                                            AND istpt.StartDate <= dssh.ServiceDate  
                                                       AND ( istpt.EndDate >= dssh.ServiceDate  
                                                             OR istpt.EndDate IS NULL  
                                                           )  
                                         WHERE  idt.Date BETWEEN CASE  
                                                              WHEN istpt.StartDate >= tp.StartDate  
                                                              AND istpt.StartDate <= dssh.ServiceDate  
                                                              THEN istpt.StartDate  
                                                              ELSE tp.StartDate  
                                                              END  
                                                         AND  CASE  
                                                              WHEN istpt.EndDate <= tp.EndDate  
                                                              AND istpt.EndDate >= dssh.ServiceDate  
                                                              THEN istpt.EndDate  
                                                              ELSE tp.EndDate  
                                                              END  
                                                AND IsWorkDay = ''Y''  
                                       ), 0) AS TotalBusinessDaysInStaffTargetPeriod ,  
                                ISNULL(( SELECT COUNT(*)  
                                         FROM   Dates dt  
                                         WHERE  dt.Date > dssh.ServiceDate  
                                                AND dt.Date <= tp.EndDate  
                                                AND IsWorkDay = ''Y''  
                                       ), 0) AS BusinessDaysRemaining ,  
                                dssh.ActualHours ,  
                                ( SELECT    SUM(ActualHours)  
                                  FROM      #DailyStaffServiceHours idssh  
                                  WHERE     idssh.ServiceDate BETWEEN tp.StartDate  
                                                              AND  
                                                              dssh.ServiceDate  
                                            AND idssh.ProgramId = dssh.ProgramId  
                                            AND idssh.StaffId = dssh.StaffId  
                                ) ActualHoursPeriodToDate ,  
                                tgt.CalculateYearlyTargetHours  
                                / wrkdays.TotalWorkDaysInYear AS AvgDailyHoursNeededToReachYearlyTarget ,  
                                ( SELECT    SUM(AvgLag * NumberOfServices)  
                                            / SUM(NumberOfServices) AS AvgLag -- weighted average based on number of services  
                                  FROM      #DailyStaffServiceHours idssh  
                                  WHERE     idssh.ServiceDate BETWEEN tp.StartDate  
                                                              AND  
                                                              dssh.ServiceDate  
                                            AND idssh.ProgramId = dssh.ProgramId  
                                            AND idssh.StaffId = dssh.StaffId  
                                ) AS AverageLagPeriodToDate ,  
                                AvgLag ,  
        NumberOfServices ,  
                                stpt.PercentWorked ,  
                                staff.HoursTimeOffProjected ,  
                                tp.ProgramProductivityId AS ProductivityPeriodId,  
        tp.StartDate AS ProductivityPeriodStartDate,  
        tp.EndDate AS ProductivityPeriodEndDate  
                       FROM     #DailyStaffServiceHours AS dssh  
                                INNER JOIN #StaffProgramProductivityTarget stpt  
                                    ON dssh.StaffId = stpt.StaffId  
                                       AND dssh.ProgramId = stpt.ProgramId  
                                       AND dssh.ServiceDate >= stpt.StartDate  
                                       AND dssh.ServiceDate <= stpt.EndDate  
                                INNER JOIN #ProgramProductivity tp  
                                    ON tp.ProgramId = stpt.ProgramId  
                                       AND dssh.ServiceDate BETWEEN tp.StartDate  
                                                            AND  
                                                              tp.EndDate  
                                CROSS JOIN ( SELECT COUNT(*) AS TotalWorkDaysInYear  
                                             FROM   Dates dt  
                                             WHERE  dt.[Year] = YEAR(GETDATE())  
                                                    AND IsWorkDay = ''Y'' 
                                           ) wrkdays  
                                INNER JOIN #Staff staff  
                                    ON staff.StaffId = dssh.StaffId'

		SET @strSQL = @strSQL + ' CROSS APPLY  ' + @FunctionName + ' (dssh.StaffId,    
                                                              dssh.ProgramId,  
                                                              dssh.ServiceDate) tgt'
		SET @strSQL = @strSQL + ' WHERE 1=1 '

		IF @ProductivityDate IS NOT NULL
			SET @strSQL = @strSQL + ' and dssh.ServiceDate < ''' + CONVERT(CHAR(10), @ProductivityDate, 101) + ''''

		IF @StaffId IS NOT NULL
			SET @strSQL = @strSQL + ' and staff.StaffId = ' + cast(@StaffId AS VARCHAR) + '' -- Modified on 26-Sep-2016 by Irfan

		IF @ProgramId IS NOT NULL
			SET @strSQL = @strSQL + ' and dssh.ProgramId = ' + cast(@ProgramId AS VARCHAR) + ''
		--Print @strSQL      
		SET @strSQL = @strSQL + 
			'), CalcTDTarget  

                  AS ( SELECT   ISNULL(( SELECT SUM(iAvgDailyHoursNeededToReachYearlyTarget  
                                                    * iTotalBusinessDaysInStaffTargetPeriod)  
                                         FROM   ( SELECT    AvgDailyHoursNeededToReachYearlyTarget AS iAvgDailyHoursNeededToReachYearlyTarget ,  
                                                            TotalBusinessDaysInStaffTargetPeriod AS iTotalBusinessDaysInStaffTargetPeriod  
                                                  FROM      DailyStaffProductivity idsp  
                                                  WHERE     idsp.StaffId = dsp.StaffId  
                                                            AND idsp.ProgramId = dsp.ProgramId  
                                                            AND dsp.ProductivityPeriodId = idsp.ProductivityPeriodId  
                                                  GROUP BY  AvgDailyHoursNeededToReachYearlyTarget ,  
                                                            TotalBusinessDaysInStaffTargetPeriod  
                                                ) a  
                                       ), 0) AS TargetToPeriodEnd ,  
                                ( SELECT    SUM(AvgDailyHoursNeededToReachYearlyTarget)  
                                  FROM      DailyStaffProductivity idsp  
                                            INNER JOIN Dates idt  
                                                ON idt.Date = idsp.ProductivityDate  
                                  WHERE     idsp.StaffId = dsp.StaffId  
                                            AND idsp.ProgramId = dsp.ProgramId  
                                            AND idsp.ProductivityPeriodId = dsp.ProductivityPeriodId  
                                            AND idsp.ProductivityDate BETWEEN dsp.ProductivityPeriodStartDate  
                                                              AND  
                                                              dsp.ProductivityDate  
                                            AND idt.IsWorkDay = ''Y''  
                                ) AS TargetHoursPeriodToDate ,  
                                *  
                       FROM     DailyStaffProductivity dsp  
                     ),  
               EightHourTarget  
                  AS ( SELECT   TargetToPeriodEnd - ActualHoursPeriodToDate AS RemainingTarget ,  
                                ( BusinessDaysRemaining * 8 * PercentWorked )  
                                - HoursTimeOffProjected AS PeriodWorkHoursRemaining ,  
                                *  
                       FROM     CalcTDTarget  
                     ),  
                SrcProgramProductivity  
                  AS ( SELECT   ProductivityDate ,  
                                StaffId ,  
                                ProgramId ,  
                                CASE WHEN RemainingTarget <= 0 THEN 0  
                                     WHEN PeriodWorkHoursRemaining  
                                          + HoursTimeOffProjected <= 0 THEN 0  
                                     WHEN PeriodWorkHoursRemaining <= 0  
                                     THEN ( RemainingTarget  
                                            / ( PeriodWorkHoursRemaining  
                                                + HoursTimeOffProjected ) )  
                                          * 8  
                                     ELSE ( RemainingTarget  
                                            / PeriodWorkHoursRemaining ) * 8  
                                END AS TargetDailyHoursNeededToPeriodEnd ,  
                                RemainingTarget AS RemainingTargetHours ,  
                                CASE WHEN PeriodWorkHoursRemaining <= 0  
                                     THEN PeriodWorkHoursRemaining  
                                          + HoursTimeOffProjected  
                                     ELSE PeriodWorkHoursRemaining  
                                END AS PeriodWorkHoursRemaining ,  
                                ( CASE WHEN TargetHoursPeriodToDate IS NULL  
                                            OR TargetHoursPeriodToDate = 0  
                                       THEN 1  
                                       ELSE ActualHoursPeriodToDate  
                                            / TargetHoursPeriodToDate  
                                  END ) AS ActualHourToTargetRatioPeriodToDate ,  
                                ActualHoursPeriodToDate ,  
                                TargetHoursPeriodToDate ,  
                                AverageLagPeriodToDate ,  
                                AvgLag AS AverageLag ,  
        NumberOfServices,  
                                ActualHours ,  
                                BusinessDaysRemaining ,  
                                CASE WHEN IsWorkDay = ''Y'' THEN AvgDailyHoursNeededToReachYearlyTarget ELSE NULL END as AvgDailyHoursNeededToReachYearlyTarget,  
                                TargetToPeriodEnd ,  
                                ProductivityPeriodId  
                       FROM     EightHourTarget eght INNER JOIN dates dt ON  
        eght.ProductivityDate = dt.[Date]  
                     )
                                             
MERGE INTO dbo.DailyStaffProductivity AS tgt  
                USING SrcProgramProductivity AS src  
                ON src.ProductivityDate = tgt.ProductivityDate  
                    AND src.StaffId = tgt.StaffId  
                    AND src.ProgramId = tgt.ProgramId       
                WHEN MATCHED   
                    THEN   
 UPDATE               SET  
            tgt.TargetDailyHoursNeededToPeriodEnd = src.TargetDailyHoursNeededToPeriodEnd ,  
            tgt.RemainingTargetHours = src.RemainingTargetHours ,  
            tgt.PeriodWorkHoursRemaining = src.PeriodWorkHoursRemaining ,  
            tgt.ActualHourToTargetRatioPeriodToDate = src.ActualHourToTargetRatioPeriodToDate ,  
            tgt.ActualHoursPeriodToDate = src.ActualHoursPeriodToDate ,  
            tgt.TargetHoursPeriodToDate = src.TargetHoursPeriodToDate ,  
            tgt.AverageLagPeriodToDate = src.AverageLagPeriodToDate ,  
            tgt.AverageLag = src.AverageLag ,  
   tgt.NumberOfServices = src.NumberOfServices,  
            tgt.ActualHours = src.ActualHours ,  
            tgt.BusinessDaysRemaining = src.BusinessDaysRemaining ,  
            tgt.AverageDailyTarget = src.AvgDailyHoursNeededToReachYearlyTarget ,  
            tgt.TargetToPeriodEnd = src.TargetToPeriodEnd ,  
            tgt.ProductivityPeriodId = src.ProductivityPeriodId ,  
            tgt.ModifiedDate = GETDATE()  
                WHEN NOT MATCHED   
                    THEN  
    INSERT  (  
              ProductivityDate ,  
              StaffId ,  
              ProgramId ,  
              AverageDailyTarget ,  
              TargetDailyHoursNeededToPeriodEnd ,  
              RemainingTargetHours ,  
              PeriodWorkHoursRemaining ,  
              ActualHourToTargetRatioPeriodToDate ,  
              ActualHoursPeriodToDate ,  
              TargetHoursPeriodToDate ,  
              AverageLagPeriodToDate ,  
              AverageLag ,  
     NumberOfServices,  
              ActualHours ,  
              BusinessDaysRemaining ,  
              TargetToPeriodEnd ,  
              ProductivityPeriodId  
            )            VALUES  
            ( src.ProductivityDate ,  
              src.StaffId ,  
              src.ProgramId ,  
              src.AvgDailyHoursNeededToReachYearlyTarget ,  
              src.TargetDailyHoursNeededToPeriodEnd ,  
              src.RemainingTargetHours ,  
              src.PeriodWorkHoursRemaining ,  
              src.ActualHourToTargetRatioPeriodToDate ,  
              src.ActualHoursPeriodToDate ,  
              src.TargetHoursPeriodToDate ,  
              src.AverageLagPeriodToDate ,  
              src.AverageLag ,  
     src.NumberOfServices,  
              src.ActualHours ,  
              src.BusinessDaysRemaining ,  
              src.TargetToPeriodEnd ,  
              src.ProductivityPeriodId   
         ) ;'

		EXEC sp_executeSQL @strSQL

		/* Retroactively remove any existing productivity row that are no longer valid based on staff target and program productivity */
		DELETE dsp
		FROM dbo.DailyStaffProductivity dsp
		INNER JOIN #ProgramProductivity pp ON dsp.ProgramId = pp.ProgramId
			AND pp.StartDate <= ProductivityDate
		WHERE NOT EXISTS (
				SELECT pppd.StartDate
					,pppd.EndDate
					,ppp.ProgramId
					,stt.StartDate
					,stt.EndDate
				FROM dbo.ProgramProductivityPeriodDates pppd
				INNER JOIN dbo.ProgramProductivityPeriods ppp ON pppd.ProgramProductivityPeriodId = ppp.ProgramProductivityPeriodId
					AND ISNULL(ppp.RecordDeleted, 'N') = 'N'
					AND ISNULL(pppd.RecordDeleted, 'N') = 'N'
					AND ISNULL(ppp.Active, 'Y') = 'Y'
				INNER JOIN dbo.StaffTargetTemplates stt ON stt.ProgramId = ppp.ProgramId
					AND ISNULL(stt.RecordDeleted, 'N') = 'N'
				WHERE ProgramProductivityPeriodDateId = dsp.ProductivityPeriodId
					AND stt.StaffId = dsp.StaffId
					AND dsp.ProductivityDate >= stt.StartDate
					AND (
						dsp.ProductivityDate <= stt.EndDate
						OR stt.EndDate IS NULL
						)
					AND dsp.ProductivityDate >= pppd.StartDate
					AND (
						dsp.ProductivityDate <= pppd.EndDate
						OR pppd.EndDate IS NULL
						)
				)
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_SCCalculateOpenPeriodProductivityMetrics') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())

		RAISERROR (
				@Error
				,-- Message text.                                           
				16
				,-- Severity.                                           
				1 -- State.                                           
				);
	END CATCH
END