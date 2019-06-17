IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCQueryOrgLevelSuperviseesDashboardProductivityMetrics]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCQueryOrgLevelSuperviseesDashboardProductivityMetrics]
GO

CREATE PROCEDURE [dbo].[ssp_SCQueryOrgLevelSuperviseesDashboardProductivityMetrics] --'2018-02-02 10:45:36.430',1    
	@ProductivityDate AS DATE = NULL
	,@StaffId AS INT
AS -- =============================================     
--[ssp_SCQueryOrgLevelSuperviseesDashboardProductivityMetrics] null,550 
-- Author:  Vandana Ojha     
-- Create date: 25/09/2018      
-- Description: Query current day org level productivity metrics to be displayed     
--What: Modified select statement to avoid displaying duplicate staff names in the 'Productivity of Supervisees' widget.
--Why: Duplicate staff names were displaying in the 'Productivity of Supervisees' widget when a particular staff is assigned with multiple programs in the staff targets screen.
--CCC-Customizations #35
--=============================================      
BEGIN
	BEGIN TRY
		DECLARE @SPNAME VARCHAR(200)

		SELECT @SPNAME = Value
		FROM SystemConfigurationKeys
		WHERE "Key" = 'SuperVisorServiceTotalsWidgetSP'

		IF @ProductivityDate IS NULL
			SELECT @ProductivityDate = CAST(GETDATE() AS DATE)

		/* Calculate productivity period date if none exists for the previous day */
		IF NOT EXISTS (
				SELECT *
				FROM DailyStaffProductivity
				WHERE ProductivityDate = DATEADD(DAY, - 1, @ProductivityDate)
				)
			AND EXISTS (
				SELECT *
				FROM dbo.ProgramProductivityPeriodDates
				WHERE StartDate <= @ProductivityDate
					AND EndDate >= @ProductivityDate
				)
		BEGIN
			--EXEC csp_SCCalculateOpenPeriodProductivityMetrics       
			IF (
					@SPNAME IS NOT NULL
					AND LTRIM(RTRIM(@SPNAME)) != ''
					)
			BEGIN
				EXEC @SPNAME
			END
		END
		ELSE
		BEGIN
			

			WITH ChildPrograms
			AS (
				SELECT *
				FROM StaffSupervisors SS
				WHERE SS.SupervisorId = @StaffId
					AND ISNULL(SS.RecordDeleted, 'N') = 'N'
				)
			SELECT AVG(dp.AverageLagPeriodToDate) AvgLagOrg
				,
				/*Added New Case condition for handling Actual Hours(0 or null) dipaly N/A*/
				CASE 
					WHEN SUM(ActualHoursPeriodToDate) IS NULL
						OR SUM(ActualHoursPeriodToDate) = 0
						THEN NULL
					WHEN SUM(TargetHoursPeriodToDate) IS NULL
						OR SUM(TargetHoursPeriodToDate) = 0
						THEN 1
					ELSE SUM(ActualHoursPeriodToDate) / SUM(TargetHoursPeriodToDate)
					END AS AvgHourToTargetRatioPeriodToDateOrg
			FROM ChildPrograms AS cp
			INNER JOIN DailyStaffProductivity AS dp ON cp.StaffId = dp.StaffId  
			INNER JOIN Staff st ON dp.StaffId = st.StaffId
			INNER JOIN StaffSupervisors SS ON SS.StaffId = st.StaffId 
			WHERE dp.ProductivityDate = DATEADD(DAY, - 1, @ProductivityDate);
			 ;With AggrStaff
			  as
			  (
				 SELECT
				 -- CAST(st.Lastname + ', ' + st.FirstName AS VARCHAR(250)) AS ParentLevelName  
				st.StaffId 
				,SUM(AverageLagPeriodToDate) AS AvgLagOrg  
				,SUM(ActualHourToTargetRatioPeriodToDate) AS AvgHourToTargetRatioPeriodToDateOrg  
			    FROM DailyStaffProductivity AS dp  
			    INNER JOIN Staff st ON dp.StaffId = st.StaffId  
			    INNER JOIN StaffSupervisors SS ON SS.StaffId = st.StaffId  
			    WHERE ISNULL(st.RecordDeleted, 'N') = 'N'  
				AND ISNULL(SS.RecordDeleted, 'N') = 'N'  
				AND st.active = 'Y'  
				AND SS.SupervisorId=@StaffId  
				AND dp.ProductivityDate = DATEADD(DAY, - 1, @ProductivityDate)  
				Group by st.StaffId 
			  )
			SELECT CAST(st.Lastname + ', ' + st.FirstName AS VARCHAR(250)) AS ParentLevelName
				,Aggr.StaffId AS OrganizationLevelId
				,AvgLagOrg
				,AvgHourToTargetRatioPeriodToDateOrg
			FROM AggrStaff as Aggr  -- DailyStaffProductivity AS dp
			INNER JOIN Staff st ON Aggr.StaffId = st.StaffId
			INNER JOIN StaffSupervisors SS ON SS.StaffId = st.StaffId
			WHERE ISNULL(st.RecordDeleted, 'N') = 'N'
				AND ISNULL(SS.RecordDeleted, 'N') = 'N'
				AND st.active = 'Y'
				AND SS.SupervisorId=@StaffId
				--AND dp.ProductivityDate = DATEADD(DAY, - 1, @ProductivityDate)
			ORDER BY ParentLevelName ASC;
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[ssp_SCQueryOrgLevelSuperviseesDashboardProductivityMetrics]') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                            
				16
				,-- Severity.                                                                            
				1 -- State.                                                                            
				);
	END CATCH
END
