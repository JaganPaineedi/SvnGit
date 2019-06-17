/****** Object:  StoredProcedure [dbo].[ssp_InsertCCDsDataExportSchedules]    Script Date: 04/29/2015 14:51:57 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InsertCCDsDataExportSchedules]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_InsertCCDsDataExportSchedules]
GO

/****** Object:  StoredProcedure [dbo].[ssp_InsertCCDsDataExportSchedules]    Script Date: 04/29/2015 14:51:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_InsertCCDsDataExportSchedules] @CCDsDataExportId INT
	,@CreatedBy VARCHAR(250)
	,@ModifiedBy VARCHAR(250)
	,@StartTime DATETIME
	,@EndTime	DATETIME
	,@RecurrenceType varchar(1)
	,@EveryXDays	INT
	,@EveryWeekday	varchar(1)
	,@EveryXWeeks	INT
	,@WeeklyOnSundays	varchar(1)
	,@WeeklyOnMondays	varchar(1)
	,@WeeklyOnTuesdays	varchar(1)
	,@WeeklyOnWednesdays	varchar(1)
	,@WeeklyOnThursdays	varchar(1)
	,@WeeklyOnFridays	varchar(1)
	,@WeeklyOnSaturdays	varchar(1)
	,@MonthlyEveryXMonths	INT
	,@MonthlyOnXDayOfMonth	INT
	,@YearlyEveryXMonth		INT
	,@YearlyEveryXDayOfMonth	INT
	,@OnXthDay	INT
	,@OnDayType VARCHAR(10)
	,@RecurrenceStartDate DATETIME
	,@NoEndDate varchar(1)
	,@NumberOfOccurences INT
	,@EndDate DATETIME = NULL

AS
-- =============================================      
-- Author:  Vijay      
-- Create date: Oct 14, 2017     
-- Description:   Adding Data to CCDsDataExportSchedules table
/*      
 Author			Modified Date			Reason      
      
*/
-- ============================================= 
BEGIN TRY
	BEGIN
		
			INSERT INTO CCDsDataExportSchedules (
				 CCDsDataExportId
				,CreatedBy
				,ModifiedBy
				,StartTime
				,EndTime
				,RecurrenceType
				,EveryXDays
				,EveryWeekday				
				,EveryXWeeks
				,WeeklyOnSundays
				,WeeklyOnMondays
				,WeeklyOnTuesdays
				,WeeklyOnWednesdays
				,WeeklyOnThursdays
				,WeeklyOnFridays
				,WeeklyOnSaturdays
				,MonthlyEveryXMonths
				,MonthlyOnXDayOfMonth
				,YearlyEveryXMonth
				,YearlyEveryXDayOfMonth
				,OnXthDay
				,OnDayType
				,RecurrenceStartDate
				,NoEndDate
				,NumberOfOccurences
				,EndDate
				)
			VALUES (
				 @CCDsDataExportId
				,@CreatedBy
				,@ModifiedBy
				,@StartTime
				,@EndTime
				,@RecurrenceType
				,@EveryXDays
				,@EveryWeekday
				,@EveryXWeeks
				,@WeeklyOnSundays
				,@WeeklyOnMondays
				,@WeeklyOnTuesdays
				,@WeeklyOnWednesdays
				,@WeeklyOnThursdays
				,@WeeklyOnFridays
				,@WeeklyOnSaturdays
				,@MonthlyEveryXMonths
				,@MonthlyOnXDayOfMonth
				,@YearlyEveryXMonth
				,@YearlyEveryXDayOfMonth
				,@OnXthDay
				,@OnDayType
				,@RecurrenceStartDate
				,@NoEndDate
				,@NumberOfOccurences
				,@EndDate
				);
		
	END
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_InsertCCDsDataExportSchedules') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.       
			16
			,-- Severity.       
			1 -- State.                                                         
			);
END CATCH
GO

