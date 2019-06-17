IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_SCQueryStaffDashboardProductivityMetrics]')
                    AND type IN ( N'P', N'PC' ) ) 
    DROP PROCEDURE [dbo].[ssp_SCQueryStaffDashboardProductivityMetrics]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ssp_SCQueryStaffDashboardProductivityMetrics]    
    @ProductivityDate AS DATE = NULL ,    
    @StaffId AS INT ,    
    @ProjectedTimeOffHours AS INT = NULL    
AS -- =============================================      
-- Author:  Suhail Ali      
-- Create date: 4/3/2012      
-- Description: Query current day staff productivity metrics. If Project time-off hours are passed in then      
-- re-calculate productivity metrics before querying       
-- Sample Usage:       
-- DECLARE @StaffId AS INT      
-- DECLARE @ProductivityDate AS DATE = GETDATE()      
-- SELECT  @StaffId = StaffId      
-- FROM    Staff      
-- WHERE   UserCode = 'ChrisTeamA'      
-- EXEC [dbo].[ssp_SCQueryStaffDashboardProductivityMetrics] @ProductivityDate,      
--    @StaffId, 20      
--      
--Modified by Maninder: Added else keyword to avoid duplicate dataset return  
----Modified by Gautam : Renamed the Key name in SystemConfigurationKeys table from "ServiceTotalsWidgetSP" 
--                        to "ProductivityCalculationSP" Ref. Task#1200, Core Bugs
--04/05/2018 Lakshmi   Call the "SCSP(scsp_SCListStaffBasedOnStaffTargetSetup)" to display clinical staff have a productivity and also checked staff active condition, As per the task Spring River-Support Go Live #160
--24/10/2018 Neethu    Modified  logic to exclude Non staff users from 'Documented Service Totals Widget' 
-- =============================================    
    BEGIN        
              
        IF @ProductivityDate IS NULL   
            SELECT  @ProductivityDate = CAST(GETDATE() AS DATE)    
    
  /* If producitivy number do not exist for the previous day then return all zeros. This will give the end user  
  an indication that the calculations have not been run  
  */    
        IF NOT EXISTS ( SELECT  *  
                        FROM    DailyStaffProductivity  
                        WHERE   ProductivityDate = DATEADD(DAY, -1,  
                                                           @ProductivityDate) )   
            BEGIN  
                SELECT  st.StaffId ,  
                        st.FirstName ,  
                        st.LastName ,  
                        0 AS ActualHourToTargetRatioPeriodToDate ,    -- Hrs TD %    
                        0 AS AverageLagPeriodToDate ,       -- Lag To Date    
                        0 AS TargetDailyHoursNeededToPeriodEnd ,     -- Target (per 8 hour day)                    
                        0 AS ProgramProductivityEndDate ,  -- Period End Date    
                        0 AS BusinessDaysRemaining ,        -- Business Days Remaining    
                        0 AS TargetToPeriodEnd ,         -- My Target for The period    
                        0 AS TargetHoursPeriodToDate ,       -- My Target To Date    
                        0 AS ActualHoursPeriodToDate ,       -- My Hours To Date    
                        0 AS RemainingTargetHours ,        -- Hours Needed to Hit Target    
                        0 AS TodaysServiceHours ,         -- Today's service hours    
                        0 AS TargetProgramHourPeriodToDate ,       -- Team Target    
                        0 AS ActualProgramHourPeriodToDate ,       -- Team Hours    
                        0 AS ActualProgramHourToTargetRatioPeriodToDate ,    -- Team Hours TD %    
                        0 AS PreviousPeriodStaffTargetHoursPeriodToDate ,    -- My Target (Previous Period)    
                        0 AS PreviousPeriodStaffActualHoursPeriodToDate ,    -- My Hours (Previous Period)    
                        0 AS PreviousPeriodStaffActualHourToTargetRatioPeriodToDate , -- My Hours % (Previous Period)    
                        0 AS PreviousPeriodStaffProductivityEndDate ,      -- Period End Date (Previous Period)    
                        0 AS PreviousPeriodProgramTargetHoursPeriodToDate ,   -- Team Target (Previous Period)    
                        0 AS PreviousPeriodProgramActualHoursPeriodToDate ,   -- Team Hours (Previous Period)    
                        0 AS PreviousPeriodProgramActualHourToTargetRatioPeriodToDate -- Team Hours % (Previous Period)        
                FROM    Staff AS st  
                WHERE   st.StaffId = @StaffId   
  
               IF EXISTS (SELECT * FROM	sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_SCListStaffBasedOnStaffTargetSetup]')
                AND type IN ( N'P', N'PC'))
						BEGIN
							EXEC scsp_SCListStaffBasedOnStaffTargetSetup
						END
						ELSE
						BEGIN
							SELECT  st.StaffId ,    
									st.FirstName ,    
									st.Lastname ,    
									0 AS ActualHourToTargetRatioPeriodToDate ,    -- Hrs TD %      
									0 AS AverageLagPeriodToDate        -- Lag To Date      
							FROM    Staff AS st WHERE ISNULL(st.RecordDeleted, 'N') = 'N' AND  st.Active = 'Y'     and ISNULL(st.NonStaffUser,'N') = 'N'--24/10/2018 Neethu 
						END 
            END  
          ELSE
          BEGIN    
        IF @ProjectedTimeOffHours IS NOT NULL   
            BEGIN  
              DECLARE @SPNAME varchar(200)
			  SELECT @SPNAME=Value FROM SystemConfigurationKeys WHERE "Key"= 'ProductivityCalculationSP'      
    UPDATE  Staff  
                SET     ProjectedTimeOffHours = @ProjectedTimeOffHours  
                WHERE   StaffId = @StaffId    
						AND ProjectedTimeOffHours <> @ProjectedTimeOffHours

                IF @@ROWCOUNT = 1   
                    --EXEC csp_SCCalculateOpenPeriodProductivityMetrics @ProductivityDate,  
                    --    @StaffId, NULL 
                     IF(@SPNAME IS NOT NULL AND LTRIM(RTRIM(@SPNAME))!='')
						BEGIN
							EXEC @SPNAME @ProductivityDate,@StaffId, NULL 
						END
                    
            END;    
        WITH    PreviousPeriodStaffProductivity  
                  AS ( SELECT   StaffId ,  
                                ProgramId ,  
                                ProductivityDate AS PreviousPeriodProductivityEndDate ,  
                                TargetHoursPeriodToDate AS PreviousPeriodTargetHoursPeriodToDate ,  
                                ActualHoursPeriodToDate AS PreviousPeriodActualHoursPeriodToDate ,  
                                ActualHourToTargetRatioPeriodToDate AS PreviousPeriodActualHourToTargetRatioPeriodToDate  
                       FROM     dbo.DailyStaffProductivity dsp  
                       WHERE    dsp.StaffId = @StaffId  
                                AND ProductivityDate IN (  
                                SELECT  MAX(ProductivityDate) AS PreviousProgramProductivityEndDate  
                                FROM    dbo.DailyStaffProductivity idsp  
                                WHERE   idsp.StaffId = dsp.StaffId  
                                        AND DATEADD(DAY, -1, @ProductivityDate) > ProductivityDate  
                                        AND ProductivityPeriodId NOT IN (  
                                        SELECT  ProductivityPeriodId  
                                        FROM    dbo.DailyStaffProductivity iidsp  
                                        WHERE   iidsp.StaffId = dsp.StaffId  
                                                AND iidsp.ProductivityDate = DATEADD(DAY,  
                                                              -1,  
                                                              @ProductivityDate) ) )  
                     ),  
                PreviousPeriodProgramProductivity  
                  AS ( SELECT   ProgramId ,  
                                MAX(ProductivityDate) ProgramProductivityEndDate ,  
                                SUM(TargetHoursPeriodToDate) AS PreviousPeriodTargetHoursPeriodToDate ,  
                                SUM(ActualHoursPeriodToDate) AS PreviousPeriodActualHoursPeriodToDate ,  
                                ( CASE WHEN SUM(TargetHoursPeriodToDate) IS NULL  
                                            OR SUM(TargetHoursPeriodToDate) = 0  
                                       THEN 1  
                                       ELSE SUM(ActualHoursPeriodToDate)  
                                            / SUM(TargetHoursPeriodToDate)  
                                  END ) AS PreviousPeriodActualHourToTargetRatioPeriodToDate  
                       FROM     dbo.DailyStaffProductivity dsp  
                       WHERE    dsp.ProgramId IN (  
                                SELECT  ProgramId  
                                FROM    dbo.DailyStaffProductivity idsp  
                                WHERE   StaffId = @StaffId  
                                        AND ProductivityDate = DATEADD(DAY, -1,  
                                                              @ProductivityDate) )  
                                AND ProductivityDate IN (  
                                SELECT  MAX(ProductivityDate) AS PreviousProgramProductivityEndDate  
                                FROM    dbo.DailyStaffProductivity idsp  
                                WHERE   idsp.ProgramId = dsp.ProgramId  
                                        AND DATEADD(DAY, -1, @ProductivityDate) > ProductivityDate  
                                        AND ProductivityPeriodId NOT IN (  
                                        SELECT  ProductivityPeriodId  
                                        FROM    dbo.DailyStaffProductivity iidsp  
                                        WHERE   iidsp.ProgramId = idsp.ProgramId  
                                          AND iidsp.ProductivityDate = DATEADD(DAY,  
                                                              -1,  
                                                              @ProductivityDate) ) )  
                       GROUP BY ProgramId  
                     ),  
                AggProgramProductivity  
                  AS ( SELECT   idp.ProgramId ,  
                                SUM(TargetHoursPeriodToDate) AS TargetProgramHourPeriodToDate ,  
                                SUM(ActualHoursPeriodToDate) AS ActualProgramHourPeriodToDate ,  
                                CASE WHEN SUM(TargetHoursPeriodToDate) IS NULL  
                                          OR SUM(TargetHoursPeriodToDate) = 0  
                                     THEN 1  
                                     ELSE SUM(ActualHoursPeriodToDate)  
                                          / SUM(TargetHoursPeriodToDate)  
                                END AS ActualProgramHourToTargetRatioPeriodToDate  
                       FROM     DailyStaffProductivity AS idp  
                       WHERE    idp.ProgramId IN (  
                                SELECT  iidsp.ProgramId  
                                FROM    DailyStaffProductivity iidsp  
                                WHERE   iidsp.ProductivityDate = DATEADD(DAY,  
                                                              -1,  
                                                              @ProductivityDate)  
                                        AND iidsp.Staffid = @StaffId )  
                                AND idp.ProductivityDate = DATEADD(DAY, -1,  
                                                              @ProductivityDate)  
                       GROUP BY idp.ProgramId  
                     )  
            SELECT  st.StaffId ,  
                    st.FirstName ,  
                    st.LastName ,  
                    ActualHourToTargetRatioPeriodToDate ,    -- Hrs TD %    
                    AverageLagPeriodToDate ,       -- Lag To Date    
                    TargetDailyHoursNeededToPeriodEnd ,     -- Target (per 8 hour day)                    
                    pppd.EndDate AS ProgramProductivityEndDate ,  -- Period End Date    
                    BusinessDaysRemaining ,        -- Business Days Remaining    
                    TargetToPeriodEnd ,         -- My Target for The period    
                    TargetHoursPeriodToDate ,       -- My Target To Date    
                    ActualHoursPeriodToDate ,       -- My Hours To Date    
                    RemainingTargetHours ,        -- Hours Needed to Hit Target    
                    ( SELECT    SUM(ActualHours)  
                      FROM      csv_SCGetDailyStaffServiceHours ish  
                      WHERE     ish.ServiceDate = @ProductivityDate  
                                AND ish.StaffId = dp.StaffId  
                    ) AS TodaysServiceHours ,         -- Today's service hours    
                    app.TargetProgramHourPeriodToDate ,       -- Team Target    
                    app.ActualProgramHourPeriodToDate ,       -- Team Hours    
                    app.ActualProgramHourToTargetRatioPeriodToDate ,    -- Team Hours TD %    
                    ppsp.PreviousPeriodTargetHoursPeriodToDate AS PreviousPeriodStaffTargetHoursPeriodToDate ,    -- My Target (Previous Period)    
                    ppsp.PreviousPeriodActualHoursPeriodToDate AS PreviousPeriodStaffActualHoursPeriodToDate ,    -- My Hours (Previous Period)    
                    ppsp.PreviousPeriodActualHourToTargetRatioPeriodToDate AS PreviousPeriodStaffActualHourToTargetRatioPeriodToDate , -- My Hours % (Previous Period)    
                    ppsp.PreviousPeriodProductivityEndDate AS PreviousPeriodStaffProductivityEndDate ,      -- Period End Date (Previous Period)    
                    pppp.PreviousPeriodTargetHoursPeriodToDate AS PreviousPeriodProgramTargetHoursPeriodToDate ,   -- Team Target (Previous Period)    
                    pppp.PreviousPeriodActualHoursPeriodToDate AS PreviousPeriodProgramActualHoursPeriodToDate ,   -- Team Hours (Previous Period)    
                    pppp.PreviousPeriodActualHourToTargetRatioPeriodToDate AS PreviousPeriodProgramActualHourToTargetRatioPeriodToDate -- Team Hours % (Previous Period)        
            FROM    DailyStaffProductivity AS dp  
                    INNER JOIN Staff st  
                        ON dp.StaffId = st.StaffId  
                    LEFT OUTER JOIN PreviousPeriodStaffProductivity AS ppsp  
                        ON ppsp.StaffId = dp.StaffId  
                           AND ppsp.ProgramId = dp.ProgramId  
                    LEFT OUTER JOIN PreviousPeriodProgramProductivity AS pppp  
                        ON pppp.ProgramId = dp.ProgramId  
                    LEFT OUTER JOIN AggProgramProductivity AS app  
                        ON app.ProgramId = dp.ProgramId  
                    INNER JOIN dbo.ProgramProductivityPeriodDates pppd  
                        ON pppd.ProgramProductivityPeriodDateId = dp.ProductivityPeriodId  
            WHERE   dp.StaffId = @StaffId  
                    AND ProductivityDate = DATEADD(DAY, -1, @ProductivityDate)    
    
    
        SELECT  st.StaffId ,  
                st.FirstName ,  
                st.Lastname ,  
                ActualHourToTargetRatioPeriodToDate ,    -- Hrs TD %    
                AverageLagPeriodToDate        -- Lag To Date    
        FROM    DailyStaffProductivity AS dp  
                INNER JOIN Staff st  
                    ON dp.StaffId = st.StaffId  
                     AND ISNULL(st.RecordDeleted, 'N') = 'N'  
					 AND st.Active = 'Y' and ISNULL(st.NonStaffUser,'N') = 'N'-- 24/10/2018 Neethu 
        WHERE   ProgramId IN (  
                SELECT  ProgramId  
                FROM    DailyStaffProductivity AS idp  
                WHERE   StaffId = @StaffId  
                        AND dp.ProductivityDate = idp.ProductivityDate )  
                AND dp.ProductivityDate = DATEADD(DAY, -1, @ProductivityDate)    
    end
    END    
       
    
  
  
  
  
  
GO
