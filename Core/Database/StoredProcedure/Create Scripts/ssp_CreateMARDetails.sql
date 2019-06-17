IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CreateMARDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_CreateMARDetails]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [SSP_CreateMARDetails] @UserCode VARCHAR(30) = NULL
	,@DocumentVersionId INT = NULL
	,@ClientOrderId VARCHAR(max) = NULL
AS
/*********************************************************************/
/* Stored Procedure: dbo.ssp_CreateMARDetails            */
/* Creation Date:    26/July/2013                  */
/* Purpose:  Used to create MAR entry                */
/*    Exec SSP_CreateMARDetails null,null,null                                             */
/* Input Parameters:                           */
/*  Date			Author			Purpose              */
/* 26/July/2013		Gautam			Created              */
/* 24/Apr/2014      Gautam          Added code to create MAR schedule for DispenseTime7 and DispenseTime8 
									Ref. Task #1105, Philhaven - Customization Issues Tracking 	*/
/* 16/Sep/2014      Gautam          Removed the check for OrderPended and OrderPendAcknowledge in MAR creation. 
									Ref. Task #206, Phil Dev - MAR Changes
   24/Oct/2014      Gautam          Added code for After1PM and 'Now+Schedule',Ref. Task#53, Meaningful Use									
   04/Feb/2015      Gautam          Added code for 8823 'Standing Administered Once', task #208, Philhaven Development																			 
   19/Feb/2015		Gautam			The column OrderFrequencyId changed to OrderTemplateFrequencyId in ClientOrders table
									and linked directly to OrderTemplateFrequencies table, Why : Task#221,Philhaven Development 
   09/Apr/2015      Gautam          Added code to check client enrolled in programs with MARClientOrderMedication checked
									task #321, Key Point - Customizations									
   28/Jul/2015      Gautam          Added code to schedule for more than a week and on sepecific days Task#318 - Orders - Vitals, Philhaven Development
   11/May/2016      Gautam          What : Added code related to SystemConfigurationKeys=SETSTARTDATEFORMARCREATION	
									Why : To create MAR data from Order Start date not current date,Woods - Support Go Live,#77	
   25/May/2016      Shankha         What: Added code to process ssp_InsertRXMedToMAR ONLY from SQL JOB , Woods - Support Go Live,#77	
   14/Feb/2017		Chethan N		What : Checking for ClientPrograms.RequestedDate.				
   31/Mar/2017		Chethan N		What: Converted Custom 'XMarStatus' to Core 'MarStatus'.
									Why:  Renaissance - Dev Items task #5.1					
   23/May/2017		Chethan N		What: Avoiding creation of MAR records for Medication Orders when 'COMPLETEORDERSTORX' is 'Y'.
									Why:  Renaissance - Dev Items task #5.1					
   29/Aug/2017		Chethan N		What: To create MAR data from current date time not Order Start date time.
									Why:  Renaissance - Dev Items task #5.1	
   29/Mar/2018      Gautam          What: dropped Temp table in end of SP. Why: Same temp table is being used in calling sp. Creating issue for invalid column. 
									Task  Journey - Environment Issues Tracking, #607
   09/Apr/2018      Gautam          What: Added code to save ClientMedicationId in MedAdminRecords from ClientOrderMedicationReferences. 
									Task  AHN Support GO live, #195	
   03/May/2018      Chethan N       What: Changed ClientOrderMedicationReferences to left join as Non Medication Orders will not have mapping Client Medications. 
									Why:  AHN Support GO live task #195	
   14/May/2018      Gautam          What: Changed code to make it compatible with SQL 2016. And set the ScheduleDate to last 60 days only.																	
   25/Sep/2018      Gautam          What: Added code to update Dispence time based on OrderTemplateFrequencyOverRides table value, CCC customization #74
   07/Oct/2018      Gautam          What: Added code to not create MAR after MARShiftEndTime For PEP - Support Go Live ,Tasks #37 
   06/Dec/2018      Chethan N       What: Removed Schedule Time check while creating MAR for the 'Now + Scheduled' medications as the job is scheduled to run every half hour and Records were created for every hour. 
									Why:  AHN Support GO live task #195	
   18/Jan/2019      Chethan N       What: Avoiding deletion of future MAR records based on SystemConfigurationKey 'MARShowDiscontinueMedsFromPastXDays'.
									Why: Discontinued medication should be displayed in the MAR for the number of days specified in SystemConfigurationKey 'MARShowDiscontinueMedsFromPastXDays'.
										MAR AHN-Build Cycle Tasks# 15	*/		
/*********************************************************************/
BEGIN
	DECLARE @UserName VARCHAR(30)
	DECLARE @TotalClientOrder INT
	DECLARE @CurrentSequence INT
	DECLARE @ClientOrderIdTemp INT
	DECLARE @ScheduleDate DATE
	DECLARE @TargetDate DATE
	DECLARE @FrequencyTime1 TIME(0)
	DECLARE @FrequencyTime2 TIME(0)
	DECLARE @FrequencyTime3 TIME(0)
	DECLARE @FrequencyTime4 TIME(0)
	DECLARE @FrequencyTime5 TIME(0)
	DECLARE @FrequencyTime6 TIME(0)
	DECLARE @FrequencyTime7 TIME(0)
	DECLARE @FrequencyTime8 TIME(0)
	DECLARE @IsPRN CHAR(1)
	DECLARE @IsNowAndSchedules CHAR(1)
	DECLARE @IsAfter1PM CHAR(1)
	DECLARE @IsStandingAdministeredOnce CHAR(1)
	DECLARE @ClientOrderDate DATE
	DECLARE @ClientOrderTargetDate DATE
	DECLARE @ClientOrderTargetEndTime TIME(0)
	DECLARE @AutoScheduleDays INT
	DECLARE @OrderScheduleId INT,@ClientMedicationValueId INT
	DECLARE @CurrentTime TIME(0)
	DECLARE @MedAdminRecordIdTemp INT
		,@StaffId INT
		,@GlobalCodeIdGiven INT
	DECLARE @Dosage DECIMAL(18, 2)
	DECLARE @DaysOfWeek VARCHAR(40)
	DECLARE @ScheduleDayNo INT
	DECLARE @Interval INT
		,@LastScheduleDate DATE
	DECLARE @ClientId INT
	DECLARE @StartDateForMARCreation VARCHAR(20)
	DECLARE @COMPLETEORDERTORX VARCHAR(1)
	DECLARE @MARShiftStartTime VARCHAR(20),@MARShiftEndTime VARCHAR(20),@CreateMARONLYDuringShiftTimes VARCHAR(10)
	DECLARE @ShowDiscontinueMedsFromPastXDays INT

	SET NOCOUNT ON
	
	SELECT @AutoScheduleDays = Value
	FROM SystemConfigurationKeys
	WHERE [Key] = 'MARAutoScheduleDays'
		AND ISNULL(RecordDeleted, 'N') = 'N'
		
	SELECT @ShowDiscontinueMedsFromPastXDays = Value
	FROM SystemConfigurationKeys
	WHERE [Key] = 'MARShowDiscontinueMedsFromPastXDays'
		AND (ISNULL(RecordDeleted, 'N') = 'N')

	--11/May/2016      Gautam
	SELECT @StartDateForMARCreation = Value
	FROM SystemConfigurationKeys
	WHERE [Key] = 'SETSTARTDATEFORMARCREATION'
		AND ISNULL(RecordDeleted, 'N') = 'N'

	SELECT @MARShiftStartTime = Value FROM SystemConfigurationKeys WHERE [Key] = 'MARShiftStartTime' AND ISNULL(RecordDeleted, 'N') = 'N'
	SELECT @MARShiftEndTime = Value FROM SystemConfigurationKeys WHERE [Key] = 'MARShiftEndTime' AND ISNULL(RecordDeleted, 'N') = 'N'
	SELECT @CreateMARONLYDuringShiftTimes = ISNULL(SCK.[Value], 'No') FROM SystemConfigurationKeys SCK WHERE SCK.[Key] = 'CreateMARDuringShiftTimes' 
					AND ISNULL(SCK.RecordDeleted, 'N') = 'N'
	
	SET @ScheduleDate = GETDATE()
	SET @TargetDate = DATEADD(d, CASE 
				WHEN @AutoScheduleDays > 1
					THEN @AutoScheduleDays - 1
				ELSE @AutoScheduleDays
				END, @ScheduleDate)

	SELECT TOP 1 @GlobalCodeIdGiven = GlobalcodeId
	FROM GlobalCodes
	WHERE category = 'MARStatus'
		AND CodeName = 'Given'
		AND ISNULL(RecordDeleted, 'N') = 'N'

	IF @UserCode IS NOT NULL
	BEGIN
		SELECT TOP 1 @UserName = UserCode
			,@StaffId = StaffId
		FROM Staff
		WHERE UserCode = @UserCode
			AND ISNULL(RecordDeleted, 'N') = 'N'
	END
	ELSE
	BEGIN
		SELECT @UserName = 'SHSDBA'
	END
	
	SELECT @COMPLETEORDERTORX = ISNULL(SCK.[Value], 'N')
		FROM SystemConfigurationKeys SCK WHERE SCK.[Key] = 'COMPLETEORDERSTORX'

	CREATE TABLE #ClientOrder (ClientOrderId INT)

	CREATE TABLE #AdministerDays (DayNo INT)

	CREATE TABLE #ScheduleDays (SDate DATE)

	CREATE TABLE #Clients (
		Sequence INT IDENTITY(1, 1)
		,ClientId INT
		)

	CREATE TABLE #ClientwithFrequency (
		Sequence INT IDENTITY(1, 1)
		,ClientOrderId INT
		,ClientOrderDate DATE
		,IsPRN CHAR(1)
		,IsAfter1PM CHAR(1)
		,IsNowAndSchedule CHAR(1)
		,IsStandingAdministeredOnce CHAR(1)
		,FrequencyTime1 TIME(0)
		,FrequencyTime2 TIME(0)
		,FrequencyTime3 TIME(0)
		,FrequencyTime4 TIME(0)
		,FrequencyTime5 TIME(0)
		,FrequencyTime6 TIME(0)
		,FrequencyTime7 TIME(0)
		,FrequencyTime8 TIME(0)
		,OrderEndDate DATE
		,OrderEndTime TIME(0)
		,MedicationDosage DECIMAL(18, 2)
		,DaysOfWeek VARCHAR(40)
		,Interval INT
		,ClientMedicationId INT
		)

	CREATE TABLE #DiscontinueClientOrder (ClientOrderId INT)

	BEGIN TRY
		BEGIN TRANSACTION

		-- Get all ClientOrderId from ClientOrders based on @DocumentId parameter (Signed data) or 
		-- @ClientOrderId parameter from Order/Rounding or 
		-- Get all ClientOrderId from ClientOrders which is not discontinued and is signed  (For Auto Schedule at night) 
		INSERT INTO #ClientOrder
		SELECT CO.ClientOrderId
		FROM ClientOrders CO
		INNER JOIN Orders O ON CO.OrderId = O.OrderId
			AND ISNULL(CO.OrderFlag, 'N') = 'Y'
			AND ISNULL(O.Active, 'Y') = 'Y'
			AND (
				CO.DiscontinuedDateTime IS NULL
				OR (
					ISNULL(CO.RecordDeleted, 'N') = 'Y'
					AND ISNULL(CO.OrderDiscontinued, 'N') = 'Y'
					)
				)
			AND ISNULL(O.RecordDeleted, 'N') = 'N'
			AND (
				(ISNULL(CO.RecordDeleted, 'N') = 'N')
				OR (
					ISNULL(CO.RecordDeleted, 'N') = 'Y'
					AND ISNULL(CO.OrderDiscontinued, 'N') = 'Y'
					)
				)
			AND (
				-- ISNULL(CO.OrderPended, 'Y') = 'N' 
				-- AND ISNULL(CO.OrderPendAcknowledge, 'Y') = 'N' 
				ISNULL(CO.OrderPendRequiredRoleAcknowledge, 'Y') = 'N'
				OR 
				ISNULL(CO.OrderDiscontinued, 'N') = 'Y'
				)
			--AND (@COMPLETEORDERTORX = 'N' OR (CO.OrderType <> 'Medication'))
		WHERE (
				@DocumentVersionId IS NULL
				OR CO.DocumentId = (
					SELECT TOP 1 DocumentId
					FROM DocumentVersions
					WHERE DocumentVersionId = @DocumentVersionId
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				)
			AND (
				@ClientOrderId IS NULL
				OR CO.ClientOrderId IN (
					SELECT item
					FROM dbo.FNSPLIT(@ClientOrderId, ',')
					)
				)
			AND ISNULL(O.AddOrderToMAR, 'Y') = 'Y'
			AND EXISTS (
				SELECT 1
				FROM ClientPrograms CP
				INNER JOIN Programs P ON CP.ProgramId = P.ProgramId
				WHERE ISnull(CP.RecordDeleted, 'N') = 'N'
					AND ISnull(P.RecordDeleted, 'N') = 'N'
					AND CP.ClientId = CO.ClientId
					AND CP.STATUS IN (
						1
						,4
						) --Referred (1),Enrolled(4)
					AND IsNull(P.MARClientOrderMedication, 'N') = 'Y'
					AND (cast(CP.EnrolledDate AS DATE) <= cast(@ScheduleDate AS DATE)
					OR cast(CP.RequestedDate AS DATE) <= cast(@ScheduleDate AS DATE))
				)

		--If PreviousClientOrderId = Not Null ,For the PreviousClientOrderId , Discontinue all future MAR schedules if they were created 
		INSERT INTO #DiscontinueClientOrder
		SELECT CO.PreviousClientOrderId
		FROM ClientOrders CO
		INNER JOIN #ClientOrder COI ON CO.ClientOrderId = COI.ClientOrderId
			AND (
				ISNULL(CO.RecordDeleted, 'N') = 'Y'
				AND ISNULL(CO.OrderDiscontinued, 'N') = 'Y'
				)

		UPDATE MA
		SET MA.RecordDeleted = 'Y'
			,MA.DeletedDate = GETDATE()
			,MA.DeletedBy = @UserName
			,MA.Comment = convert(VARCHAR(max), isnull(MA.Comment, '')) + 'Medication schedule discontinue after initiation of document : ' + convert(VARCHAR(10), CO.DocumentId)
		FROM MedAdminRecords MA
		INNER JOIN #DiscontinueClientOrder CLO ON MA.ClientOrderId = CLO.ClientOrderId
			AND ISNULL(MA.RecordDeleted, 'N') = 'N'
		INNER JOIN ClientOrders CO ON CO.ClientOrderId = CLO.ClientOrderId
			AND ISNULL(CO.RecordDeleted, 'N') = 'N'
		WHERE (
				MA.ScheduledDate = CAST(DATEADD(DD, ISNULL(@ShowDiscontinueMedsFromPastXDays, 1), @ScheduleDate) AS DATE)
				--AND (MA.ScheduledTime > CAST(SUBSTRING(CONVERT(VARCHAR(8), GETDATE(), 108), 1, 5) AS TIME(0))
				--	OR MA.ScheduledTime IS NULL)
				)
			OR (MA.ScheduledDate > CAST(DATEADD(DD, ISNULL(@ShowDiscontinueMedsFromPastXDays, 1), @ScheduleDate) AS DATE))

		-- Get all OrderFrequency for ClientOrderId in #ClientWithFrequency       
		INSERT INTO #ClientwithFrequency (
			ClientOrderId
			,ClientOrderDate
			,IsPRN
			,IsAfter1PM
			,IsNowAndSchedule
			,IsStandingAdministeredOnce
			,FrequencyTime1
			,FrequencyTime2
			,FrequencyTime3
			,FrequencyTime4
			,FrequencyTime5
			,FrequencyTime6
			,FrequencyTime7
			,FrequencyTime8
			,OrderEndDate
			,OrderEndTime
			,MedicationDosage
			,DaysOfWeek
			,Interval
			,ClientMedicationId
			)
		SELECT CO.ClientOrderId
			,cast(CO.OrderStartDateTime AS DATE)
			,CASE 
				WHEN ISNULL(CO.IsPRN, 'N') = 'Y'
					THEN 'Y'
				ELSE 'N'
				END
			,CASE 
				WHEN CO.OrderScheduleId = 8520
					THEN 'Y'
				ELSE 'N'
				END
			,-- Global codes 'After 1PM'
			CASE 
				WHEN CO.OrderScheduleId = 8546
					THEN 'Y'
				ELSE 'N'
				END
			,--Now + Scheduled
			CASE 
				WHEN CO.OrderScheduleId = 8823
					THEN 'Y'
				ELSE 'N'
				END
			,--StandingAdministeredOnce
			CASE 
				WHEN OTF.DispenseTime1 IS NOT NULL
					THEN CONVERT(VARCHAR(15), OTF.DispenseTime1, 108)
				ELSE NULL
				END
			,CASE 
				WHEN OTF.DispenseTime2 IS NOT NULL
					THEN CONVERT(VARCHAR(15), OTF.DispenseTime2, 108)
				ELSE NULL
				END
			,CASE 
				WHEN OTF.DispenseTime3 IS NOT NULL
					THEN CONVERT(VARCHAR(15), OTF.DispenseTime3, 108)
				ELSE NULL
				END
			,CASE 
				WHEN OTF.DispenseTime4 IS NOT NULL
					THEN CONVERT(VARCHAR(15), OTF.DispenseTime4, 108)
				ELSE NULL
				END
			,CASE 
				WHEN OTF.DispenseTime5 IS NOT NULL
					THEN CONVERT(VARCHAR(15), OTF.DispenseTime5, 108)
				ELSE NULL
				END
			,CASE 
				WHEN OTF.DispenseTime6 IS NOT NULL
					THEN CONVERT(VARCHAR(15), OTF.DispenseTime6, 108)
				ELSE NULL
				END
			,CASE 
				WHEN OTF.DispenseTime7 IS NOT NULL
					THEN CONVERT(VARCHAR(15), OTF.DispenseTime7, 108)
				ELSE NULL
				END
			,CASE 
				WHEN OTF.DispenseTime8 IS NOT NULL
					THEN CONVERT(VARCHAR(15), OTF.DispenseTime8, 108)
				ELSE NULL
				END
			,CAST(CO.OrderEndDateTime AS DATE)
			,CAST(CO.OrderEndDateTime AS TIME(0))
			,CO.MedicationDosage
			,CO.DaysOfWeek
			,CASE 
				WHEN GCF.CodeName = 'Every Other Day'
					THEN 2
				WHEN GCF.CodeName = 'Q3D'
					THEN 3
				WHEN GCF.CodeName = 'Weekly'
					THEN 7
				WHEN GCF.CodeName = 'Every 2 Weeks'
					THEN 14
				WHEN GCF.CodeName = 'Every 3 Weeks'
					THEN 21
				WHEN GCF.CodeName = 'Every 4 Weeks'
					THEN 28
				ELSE 1
				END
			,CMR.ClientMedicationId
		FROM ClientOrders CO
		INNER JOIN #ClientOrder O ON CO.ClientOrderId = O.ClientOrderId
			AND ISNULL(CO.RecordDeleted, 'N') = 'N'
		INNER JOIN OrderTemplateFrequencies OTF ON OTF.OrderTemplateFrequencyId = CO.OrderTemplateFrequencyId
			AND ISNULL(OTF.RecordDeleted, 'N') = 'N'
		LEFT JOIN ClientOrderMedicationReferences CMR ON CMR.ClientOrderId=O.ClientOrderId
		LEFT JOIN GlobalCodes GCF ON GCF.GlobalCodeId = OTF.RxFrequencyId
			AND ISNULL(GCF.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(OTF.SelectDays, 'N') = 'Y'
		WHERE (
				CO.OrderEndDateTime IS NULL
				OR CAST(CO.OrderEndDateTime AS DATE) >= CAST(GetDate() AS DATE)
				)
	
		If exists(Select 1 from OrderTemplateFrequencyOverRides where ISNULL(RecordDeleted, 'N') = 'N')
			Begin
				Update C
				Set C.FrequencyTime1=CASE WHEN OTFR.DispenseTime1 IS NOT NULL
											THEN CONVERT(VARCHAR(15), OTFR.DispenseTime1, 108) ELSE NULL END
					,C.FrequencyTime2=CASE WHEN OTFR.DispenseTime2 IS NOT NULL
											THEN CONVERT(VARCHAR(15), OTFR.DispenseTime2, 108) ELSE NULL END
					,C.FrequencyTime3=CASE WHEN OTFR.DispenseTime3 IS NOT NULL
											THEN CONVERT(VARCHAR(15), OTFR.DispenseTime3, 108) ELSE NULL END
					,C.FrequencyTime4=CASE WHEN OTFR.DispenseTime4 IS NOT NULL
											THEN CONVERT(VARCHAR(15), OTFR.DispenseTime4, 108) ELSE NULL END
					,C.FrequencyTime5=CASE WHEN OTFR.DispenseTime5 IS NOT NULL
											THEN CONVERT(VARCHAR(15), OTFR.DispenseTime5, 108) ELSE NULL END
					,C.FrequencyTime6=CASE WHEN OTFR.DispenseTime6 IS NOT NULL
											THEN CONVERT(VARCHAR(15), OTFR.DispenseTime6, 108) ELSE NULL END
					,C.FrequencyTime7=CASE WHEN OTFR.DispenseTime7 IS NOT NULL
											THEN CONVERT(VARCHAR(15), OTFR.DispenseTime7, 108) ELSE NULL END
					,C.FrequencyTime8=CASE WHEN OTFR.DispenseTime8 IS NOT NULL
											THEN CONVERT(VARCHAR(15), OTFR.DispenseTime8, 108) ELSE NULL END
					,C.DaysOfWeek=null
				From #ClientwithFrequency C Join ClientOrders CO ON CO.ClientOrderId = C.ClientOrderId
								AND ISNULL(CO.RecordDeleted, 'N') = 'N'
					INNER JOIN OrderTemplateFrequencies OTF ON OTF.OrderTemplateFrequencyId = CO.OrderTemplateFrequencyId
						AND ISNULL(OTF.RecordDeleted, 'N') = 'N'
					JOIN OrderStrengths OS ON OS.OrderStrengthId = CO.MedicationOrderStrengthId
					JOIN OrderTemplateFrequencyOverRides OTFR ON OTFR.ClientId = CO.ClientId
						AND OTFR.RxFrequencyId = OTF.RxFrequencyId
						AND OTFR.MedicationId = OS.MedicationId
						AND ISNULL(OTFR.RecordDeleted, 'N') = 'N'
				where CO.OrderType ='Medication'
											
				Update C
				Set C.FrequencyTime1=CASE WHEN OTFR.DispenseTime1 IS NOT NULL
											THEN CONVERT(VARCHAR(15), OTFR.DispenseTime1, 108) ELSE NULL END
					,C.FrequencyTime2=CASE WHEN OTFR.DispenseTime2 IS NOT NULL
											THEN CONVERT(VARCHAR(15), OTFR.DispenseTime2, 108) ELSE NULL END
					,C.FrequencyTime3=CASE WHEN OTFR.DispenseTime3 IS NOT NULL
											THEN CONVERT(VARCHAR(15), OTFR.DispenseTime3, 108) ELSE NULL END
					,C.FrequencyTime4=CASE WHEN OTFR.DispenseTime4 IS NOT NULL
											THEN CONVERT(VARCHAR(15), OTFR.DispenseTime4, 108) ELSE NULL END
					,C.FrequencyTime5=CASE WHEN OTFR.DispenseTime5 IS NOT NULL
											THEN CONVERT(VARCHAR(15), OTFR.DispenseTime5, 108) ELSE NULL END
					,C.FrequencyTime6=CASE WHEN OTFR.DispenseTime6 IS NOT NULL
											THEN CONVERT(VARCHAR(15), OTFR.DispenseTime6, 108) ELSE NULL END
					,C.FrequencyTime7=CASE WHEN OTFR.DispenseTime7 IS NOT NULL
											THEN CONVERT(VARCHAR(15), OTFR.DispenseTime7, 108) ELSE NULL END
					,C.FrequencyTime8=CASE WHEN OTFR.DispenseTime8 IS NOT NULL
											THEN CONVERT(VARCHAR(15), OTFR.DispenseTime8, 108) ELSE NULL END
					,C.DaysOfWeek=null
				From #ClientwithFrequency C Join ClientOrders CO ON CO.ClientOrderId = C.ClientOrderId
								AND ISNULL(CO.RecordDeleted, 'N') = 'N'
					INNER JOIN OrderTemplateFrequencies OTF ON OTF.OrderTemplateFrequencyId = CO.OrderTemplateFrequencyId
						AND ISNULL(OTF.RecordDeleted, 'N') = 'N'
					--JOIN OrderStrengths OS ON OS.OrderStrengthId = CO.MedicationOrderStrengthId
					JOIN OrderTemplateFrequencyOverRides OTFR ON OTFR.ClientId = CO.ClientId
						AND OTFR.OrderId = CO.OrderId
						AND ISNULL(OTFR.RecordDeleted, 'N') = 'N'
				where CO.OrderType <> 'Medication'	
			end
		   -- If any FrequencyTime is before @MARShiftStartTime	or after @MARShiftEndTime , update with NULL
		   If @CreateMARONLYDuringShiftTimes='Yes'
		  Begin
				Update C
				Set C.FrequencyTime1=CASE WHEN C.FrequencyTime1 IS NOT NULL and(
				DATEDIFF(ss, CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(@MARShiftStartTime AS TIME(0)) AS DATETIME), 
					  CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(C.FrequencyTime1 AS TIME(0)) AS DATETIME)) > 0 and
				DATEDIFF(ss, CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(@MARShiftEndTime AS TIME(0)) AS DATETIME), 
					  CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(C.FrequencyTime1 AS TIME(0)) AS DATETIME)) > 0
					  or
					  DATEDIFF(ss, CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(C.FrequencyTime1 AS TIME(0)) AS DATETIME), 
					  CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(@MARShiftStartTime AS TIME(0)) AS DATETIME)) > 0)
											THEN NULL ELSE C.FrequencyTime1 END
					,C.FrequencyTime2=CASE WHEN C.FrequencyTime2 IS NOT NULL and (
				DATEDIFF(ss, CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(@MARShiftStartTime AS TIME(0)) AS DATETIME), 
					  CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(C.FrequencyTime2 AS TIME(0)) AS DATETIME)) > 0 and
				DATEDIFF(ss, CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(@MARShiftEndTime AS TIME(0)) AS DATETIME), 
					  CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(C.FrequencyTime2 AS TIME(0)) AS DATETIME)) > 0
					  or
					  DATEDIFF(ss, CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(C.FrequencyTime2 AS TIME(0)) AS DATETIME), 
					  CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(@MARShiftStartTime AS TIME(0)) AS DATETIME)) > 0)
											THEN NULL ELSE C.FrequencyTime2 END
						,C.FrequencyTime3=CASE WHEN C.FrequencyTime3 IS NOT NULL and (
				DATEDIFF(ss, CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(@MARShiftStartTime AS TIME(0)) AS DATETIME), 
					  CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(C.FrequencyTime3 AS TIME(0)) AS DATETIME)) > 0 and
				DATEDIFF(ss, CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(@MARShiftEndTime AS TIME(0)) AS DATETIME), 
					  CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(C.FrequencyTime3 AS TIME(0)) AS DATETIME)) > 0
					   or
					  DATEDIFF(ss, CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(C.FrequencyTime3 AS TIME(0)) AS DATETIME), 
					  CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(@MARShiftStartTime AS TIME(0)) AS DATETIME)) > 0)
											THEN NULL ELSE C.FrequencyTime3 END
					,C.FrequencyTime4=CASE WHEN C.FrequencyTime4 IS NOT NULL and (
				DATEDIFF(ss, CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(@MARShiftStartTime AS TIME(0)) AS DATETIME), 
					  CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(C.FrequencyTime4 AS TIME(0)) AS DATETIME)) > 0 and
				DATEDIFF(ss, CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(@MARShiftEndTime AS TIME(0)) AS DATETIME), 
					  CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(C.FrequencyTime4 AS TIME(0)) AS DATETIME)) > 0
					   or
					  DATEDIFF(ss, CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(C.FrequencyTime4 AS TIME(0)) AS DATETIME), 
					  CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(@MARShiftStartTime AS TIME(0)) AS DATETIME)) > 0)
											THEN NULL ELSE C.FrequencyTime4 END
					,C.FrequencyTime5=CASE WHEN C.FrequencyTime5 IS NOT NULL and (
				DATEDIFF(ss, CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(@MARShiftStartTime AS TIME(0)) AS DATETIME), 
					  CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(C.FrequencyTime5 AS TIME(0)) AS DATETIME)) > 0 and
				DATEDIFF(ss, CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(@MARShiftEndTime AS TIME(0)) AS DATETIME), 
					  CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(C.FrequencyTime5 AS TIME(0)) AS DATETIME)) > 0
					   or
					  DATEDIFF(ss, CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(C.FrequencyTime5 AS TIME(0)) AS DATETIME), 
					  CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(@MARShiftStartTime AS TIME(0)) AS DATETIME)) > 0)
											THEN NULL ELSE C.FrequencyTime5 END
						,C.FrequencyTime6=CASE WHEN C.FrequencyTime6 IS NOT NULL and (
				DATEDIFF(ss, CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(@MARShiftStartTime AS TIME(0)) AS DATETIME), 
					  CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(C.FrequencyTime6 AS TIME(0)) AS DATETIME)) > 0 and
				DATEDIFF(ss, CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(@MARShiftEndTime AS TIME(0)) AS DATETIME), 
					  CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(C.FrequencyTime6 AS TIME(0)) AS DATETIME)) > 0
					   or
					  DATEDIFF(ss, CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(C.FrequencyTime6 AS TIME(0)) AS DATETIME), 
					  CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(@MARShiftStartTime AS TIME(0)) AS DATETIME)) > 0)
											THEN NULL ELSE C.FrequencyTime6 END
						,C.FrequencyTime7=CASE WHEN C.FrequencyTime7 IS NOT NULL and (
				DATEDIFF(ss, CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(@MARShiftStartTime AS TIME(0)) AS DATETIME), 
					  CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(C.FrequencyTime7 AS TIME(0)) AS DATETIME)) > 0 and
				DATEDIFF(ss, CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(@MARShiftEndTime AS TIME(0)) AS DATETIME), 
					  CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(C.FrequencyTime7 AS TIME(0)) AS DATETIME)) > 0
					   or
					  DATEDIFF(ss, CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(C.FrequencyTime7 AS TIME(0)) AS DATETIME), 
					  CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(@MARShiftStartTime AS TIME(0)) AS DATETIME)) > 0)
											THEN NULL ELSE C.FrequencyTime7 END
						,C.FrequencyTime8=CASE WHEN C.FrequencyTime8 IS NOT NULL and (
				DATEDIFF(ss, CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(@MARShiftStartTime AS TIME(0)) AS DATETIME), 
					  CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(C.FrequencyTime8 AS TIME(0)) AS DATETIME)) > 0 and
				DATEDIFF(ss, CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(@MARShiftEndTime AS TIME(0)) AS DATETIME), 
					  CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(C.FrequencyTime8 AS TIME(0)) AS DATETIME)) > 0
					   or
					  DATEDIFF(ss, CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(C.FrequencyTime8 AS TIME(0)) AS DATETIME), 
					  CAST(CAST(getdate() AS DATE) AS DATETIME) + CAST(CAST(@MARShiftStartTime AS TIME(0)) AS DATETIME)) > 0)
											THEN NULL ELSE C.FrequencyTime8 END
				From #ClientwithFrequency C 
		  end
						
		SELECT @TotalClientOrder = COUNT(*)
		FROM #clientwithfrequency

		SET @CurrentSequence = 1

		--select * from #ClientwithFrequency
		-- Loop through all ClientOrderId and @ScheduleDate should be less than or equal to @TargetDate 
		WHILE (@CurrentSequence <= @TotalClientOrder)
		BEGIN
			SELECT @ClientOrderIdTemp = ClientOrderId
				,@ClientOrderDate = ClientOrderDate
				,@IsPRN = IsPRN
				,@IsAfter1PM = IsAfter1PM
				,@IsNowAndSchedules = IsNowAndSchedule
				,@IsStandingAdministeredOnce = IsStandingAdministeredOnce
				,@FrequencyTime1 = FrequencyTime1
				,@FrequencyTime2 = FrequencyTime2
				,@FrequencyTime3 = FrequencyTime3
				,@FrequencyTime4 = FrequencyTime4
				,@FrequencyTime5 = FrequencyTime5
				,@FrequencyTime6 = FrequencyTime6
				,@FrequencyTime7 = FrequencyTime7
				,@FrequencyTime8 = FrequencyTime8
				,@ClientOrderTargetDate = OrderEndDate
				,@ClientOrderTargetEndTime = OrderEndTime
				,@Dosage = MedicationDosage
				,@DaysOfWeek = DaysOfWeek
				,@Interval = Interval
				,@ClientMedicationValueId=ClientMedicationId
			FROM #ClientwithFrequency
			WHERE Sequence = @CurrentSequence

			SET @ScheduleDate = @ClientOrderDate
			-- Set @TargetDate based on ClientOrder End date  else Today date
			SET @AutoScheduleDays = CASE 
					WHEN @AutoScheduleDays IS NULL
						THEN 1
					ELSE @AutoScheduleDays
					END
			SET @TargetDate = DATEADD(d, CASE 
						WHEN @AutoScheduleDays > 1
							THEN @AutoScheduleDays - 1
						ELSE @AutoScheduleDays
						END, CAST(getdate() AS DATE))

			--IF @ClientOrderTargetDate IS NOT NULL
			--BEGIN
			--	SET @TargetDate = @ClientOrderTargetDate
			--END
			--ELSE
			--BEGIN
			--	SET @TargetDate = DATEADD(d, @AutoScheduleDays - 1, GETDATE()) -- Or Set the SystemConfigurationKeys data
			--END
			
			IF @ClientOrderTargetDate IS NOT NULL
				AND @ClientOrderTargetDate < @TargetDate
				SET @TargetDate = @ClientOrderTargetDate
			
			TRUNCATE TABLE #AdministerDays

			TRUNCATE TABLE #ScheduleDays

			IF @DaysOfWeek IS NOT NULL
				AND @DaysOfWeek <> ''
			BEGIN
				INSERT INTO #AdministerDays
				SELECT item
				FROM dbo.FNSPLIT(@DaysOfWeek, ',')

				--select '#AdministerDays'
				--select * from #AdministerDays 
				INSERT INTO #ScheduleDays
				SELECT CAST(D.DATE AS DATE)
				FROM Dates D
				JOIN #AdministerDays A ON D.DayNumberOfWeek = A.DayNo
				WHERE CAST(DATE AS DATE) >= CAST(Getdate() AS DATE)
					AND CAST(DATE AS DATE) <= @TargetDate
				ORDER BY D.DATE ASC

				--select * from #ScheduleDays
				IF @Interval <= 7
				BEGIN
					SET @ScheduleDate = (
							SELECT TOP 1 SDate
							FROM #ScheduleDays
							)
				END
				ELSE
				BEGIN
					SELECT @LastScheduleDate = max(ScheduledDate)
					FROM MedAdminRecords
					WHERE ClientOrderId = @ClientOrderIdTemp
						AND ISNULL(RecordDeleted, 'N') = 'N'

					SET @ScheduleDate = CASE 
							WHEN @LastScheduleDate IS NULL
								THEN (
										SELECT TOP 1 SDate
										FROM #ScheduleDays
										)
							ELSE DATEADD(d, @Interval, @LastScheduleDate)
							END
				END
						--select @ScheduleDate as 'DaysOfWeek- last'
			END

			SELECT @CurrentTime = cast(datepart(hh, getdate()) AS VARCHAR(5)) + ':00:00'

			SELECT @Interval = CASE 
					WHEN @Interval <= 1
						THEN 1
					ELSE @Interval
					END

			--select @ScheduleDate , @TargetDate
			--SELECT @DaysOfWeek,@Interval,@ClientOrderIdTemp ,@ClientOrderDate ,@IsPRN ,@IsAfter1PM ,@IsNowAndSchedules,@IsStandingAdministeredOnce 
			--	,@FrequencyTime1 ,@FrequencyTime2 ,@FrequencyTime3 ,@FrequencyTime4 ,@FrequencyTime5 ,@FrequencyTime6 
			--	,@FrequencyTime7 ,@FrequencyTime8 ,@ClientOrderTargetDate ,@ClientOrderTargetEndTime ,@Dosage
			IF @StartDateForMARCreation IS NOT NULL
				AND isdate(@StartDateForMARCreation) = 1
			BEGIN
				IF @ScheduleDate < @StartDateForMARCreation
					SET @ScheduleDate = @StartDateForMARCreation
			END
			
			if @ScheduleDate < dateadd(d, -60,@TargetDate)
				begin
					set @ScheduleDate= DATEADD(d,-60,@TargetDate)
				end
			--set @ScheduleDate= DATEADD(d,1,@TargetDate)
			WHILE (@ScheduleDate <= @TargetDate)
			BEGIN -- Code to insert Now + Schedules schedule
				IF @IsNowAndSchedules = 'Y'
					AND CAST(@ScheduleDate AS DATE) = @ClientOrderDate
					AND @IsPRN <> 'Y'
				BEGIN
					IF NOT EXISTS (
							SELECT *
							FROM MedAdminRecords
							WHERE ClientOrderId = @ClientOrderIdTemp
								AND ScheduledDate = @ScheduleDate
								AND ISNULL(RecordDeleted, 'N') = 'N'
							)
					BEGIN
						INSERT INTO MedAdminRecords (
							CreatedBy
							,CreatedDate
							,ModifiedBy
							,ModifiedDate
							,ClientOrderId
							,ScheduledDate
							,ScheduledTime
							,ClientMedicationId
							)
						VALUES (
							@UserName
							,GETDATE()
							,@UserName
							,GETDATE()
							,@ClientOrderIdTemp
							,@ScheduleDate
							,@CurrentTime
							,@ClientMedicationValueId
							)
					END
				END

				IF @IsStandingAdministeredOnce = 'Y'
					AND CAST(@ScheduleDate AS DATE) = @ClientOrderDate
				BEGIN
					IF NOT EXISTS (
							SELECT *
							FROM MedAdminRecords
							WHERE ClientOrderId = @ClientOrderIdTemp
								AND ScheduledDate = @ScheduleDate
								AND ISNULL(RecordDeleted, 'N') = 'N'
							)
					BEGIN
						INSERT INTO MedAdminRecords (
							CreatedBy
							,CreatedDate
							,ModifiedBy
							,ModifiedDate
							,ClientOrderId
							,ScheduledDate
							,ScheduledTime
							,AdministeredDate
							,AdministeredTime
							,AdministeredBy
							,STATUS
							,AdministeredDose
							,ClientMedicationId
							)
						VALUES (
							@UserName
							,GETDATE()
							,@UserName
							,GETDATE()
							,@ClientOrderIdTemp
							,@ScheduleDate
							,@CurrentTime
							,@ScheduleDate
							,@CurrentTime
							,@StaffId
							,@GlobalCodeIdGiven
							,@Dosage
							,@ClientMedicationValueId
							)

						SELECT @MedAdminRecordIdTemp = SCOPE_IDENTITY()

						-- Create Administration history
						EXEC ssp_InsertMedAdministrationHistory @MedAdminRecordIdTemp

						-- Close the ClientOrder
						EXEC ssp_UpdateClientOrderStatus @MedAdminRecordIdTemp
							,@StaffId
					END
				END

				-- @FrequencyTime1 is not null and  (@ClientOrderTargetEndTime is not entered or its after frequency time)
				-- (@ScheduleDate + @FrequencyTime1) should be greater than current date time.
				IF (
						@FrequencyTime1 IS NOT NULL
						AND (DATEDIFF(ss, GETDATE(), CAST(CAST(@ScheduleDate AS DATE) AS DATETIME) + CAST(CAST(@FrequencyTime1 AS TIME(0)) AS DATETIME)) > 0 OR @StartDateForMARCreation IS NOT NULL)
						AND (
							@ClientOrderTargetEndTime IS NULL
							OR @ClientOrderTargetEndTime = '00:00:00'
							OR (
								@ScheduleDate = @TargetDate
								AND DATEDIFF(mi, @FrequencyTime1, @ClientOrderTargetEndTime) > 0
								)
							OR @ScheduleDate < @TargetDate
							)
						)
					AND @IsPRN <> 'Y'
					AND (
						@IsAfter1PM = 'N'
						OR (
							@IsAfter1PM = 'Y'
							AND datediff(ss, '13:00:00', @FrequencyTime1) > 0
							)
						)
					--AND (@CreateMARONLYDuringShiftTimes='No' or (@CreateMARONLYDuringShiftTimes='Yes' and 
					--DATEDIFF(ss, CAST(CAST(@ScheduleDate AS DATE) AS DATETIME) + CAST(CAST(@MARShiftStartTime AS TIME(0)) AS DATETIME), 
					--  CAST(CAST(@ScheduleDate AS DATE) AS DATETIME) + CAST(CAST(@FrequencyTime1 AS TIME(0)) AS DATETIME)) > 0
					--									@ScheduleDate = @TargetDate
					--			AND DATEDIFF(mi, @FrequencyTime1, @ClientOrderTargetEndTime) > 0
					--												))
					--	--MARShiftStartTime VARCHAR(20),@MARShiftEndTime VARCHAR(20),@CreateMARONLYDuringShiftTimes
				BEGIN
					IF NOT EXISTS (
							SELECT *
							FROM MedAdminRecords
							WHERE ClientOrderId = @ClientOrderIdTemp
								AND ScheduledDate = @ScheduleDate
								AND ScheduledTime = @FrequencyTime1
								AND ISNULL(RecordDeleted, 'N') = 'N'
							)
					BEGIN
						INSERT INTO MedAdminRecords (
							CreatedBy
							,CreatedDate
							,ModifiedBy
							,ModifiedDate
							,ClientOrderId
							,ScheduledDate
							,ScheduledTime
							,ClientMedicationId
							)
						VALUES (
							@UserName
							,GETDATE()
							,@UserName
							,GETDATE()
							,@ClientOrderIdTemp
							,@ScheduleDate
							,@FrequencyTime1
							,@ClientMedicationValueId
							)
					END
				END

				IF (
						@FrequencyTime2 IS NOT NULL
						AND (DATEDIFF(ss, GETDATE(), CAST(CAST(@ScheduleDate AS DATE) AS DATETIME) + CAST(CAST(@FrequencyTime2 AS TIME(0)) AS DATETIME)) > 0 OR @StartDateForMARCreation IS NOT NULL)
						AND (
							@ClientOrderTargetEndTime IS NULL
							OR @ClientOrderTargetEndTime = '00:00:00'
							OR (
								@ScheduleDate = @TargetDate
								AND DATEDIFF(mi, @FrequencyTime2, @ClientOrderTargetEndTime) > 0
								)
							OR @ScheduleDate < @TargetDate
							)
						)
					AND @IsPRN <> 'Y'
					AND (
						@IsAfter1PM = 'N'
						OR (
							@IsAfter1PM = 'Y'
							AND datediff(ss, '13:00:00', @FrequencyTime2) > 0
							)
						)
				BEGIN
					IF NOT EXISTS (
							SELECT *
							FROM MedAdminRecords
							WHERE ClientOrderId = @ClientOrderIdTemp
								AND ScheduledDate = @ScheduleDate
								AND ScheduledTime = @FrequencyTime2
								AND ISNULL(RecordDeleted, 'N') = 'N'
							)
					BEGIN
						INSERT INTO MedAdminRecords (
							CreatedBy
							,CreatedDate
							,ModifiedBy
							,ModifiedDate
							,ClientOrderId
							,ScheduledDate
							,ScheduledTime
							,ClientMedicationId
							)
						VALUES (
							@UserName
							,GETDATE()
							,@UserName
							,GETDATE()
							,@ClientOrderIdTemp
							,@ScheduleDate
							,@FrequencyTime2
							,@ClientMedicationValueId
							)
					END
				END

				IF (
						@FrequencyTime3 IS NOT NULL
						AND (DATEDIFF(ss, GETDATE(), CAST(CAST(@ScheduleDate AS DATE) AS DATETIME) + CAST(CAST(@FrequencyTime3 AS TIME(0))AS DATETIME)) > 0 OR @StartDateForMARCreation IS NOT NULL)
						AND (
							@ClientOrderTargetEndTime IS NULL
							OR @ClientOrderTargetEndTime = '00:00:00'
							OR (
								@ScheduleDate = @TargetDate
								AND DATEDIFF(mi, @FrequencyTime3, @ClientOrderTargetEndTime) > 0
								)
							OR @ScheduleDate < @TargetDate
							)
						)
					AND @IsPRN <> 'Y'
					AND (
						@IsAfter1PM = 'N'
						OR (
							@IsAfter1PM = 'Y'
							AND datediff(ss, '13:00:00', @FrequencyTime3) > 0
							)
						)
				BEGIN
					IF NOT EXISTS (
							SELECT *
							FROM MedAdminRecords
							WHERE ClientOrderId = @ClientOrderIdTemp
								AND ScheduledDate = @ScheduleDate
								AND ScheduledTime = @FrequencyTime3
								AND ISNULL(RecordDeleted, 'N') = 'N'
							)
					BEGIN
						INSERT INTO MedAdminRecords (
							CreatedBy
							,CreatedDate
							,ModifiedBy
							,ModifiedDate
							,ClientOrderId
							,ScheduledDate
							,ScheduledTime
							,ClientMedicationId
							)
						VALUES (
							@UserName
							,GETDATE()
							,@UserName
							,GETDATE()
							,@ClientOrderIdTemp
							,@ScheduleDate
							,@FrequencyTime3
							,@ClientMedicationValueId
							)
					END
				END

				IF (
						@FrequencyTime4 IS NOT NULL
						AND (DATEDIFF(ss, GETDATE(), CAST(CAST(@ScheduleDate AS DATE) AS DATETIME) + CAST(CAST(@FrequencyTime4 AS TIME(0)) AS DATETIME)) > 0 OR @StartDateForMARCreation IS NOT NULL)
						AND (
							@ClientOrderTargetEndTime IS NULL
							OR @ClientOrderTargetEndTime = '00:00:00'
							OR (
								@ScheduleDate = @TargetDate
								AND DATEDIFF(mi, @FrequencyTime4, @ClientOrderTargetEndTime) > 0
								)
							OR @ScheduleDate < @TargetDate
							)
						)
					AND @IsPRN <> 'Y'
					AND (
						@IsAfter1PM = 'N'
						OR (
							@IsAfter1PM = 'Y'
							AND datediff(ss, '13:00:00', @FrequencyTime4) > 0
							)
						)
				BEGIN
					IF NOT EXISTS (
							SELECT *
							FROM MedAdminRecords
							WHERE ClientOrderId = @ClientOrderIdTemp
								AND ScheduledDate = @ScheduleDate
								AND ScheduledTime = @FrequencyTime4
								AND ISNULL(RecordDeleted, 'N') = 'N'
							)
					BEGIN
						INSERT INTO MedAdminRecords (
							CreatedBy
							,CreatedDate
							,ModifiedBy
							,ModifiedDate
							,ClientOrderId
							,ScheduledDate
							,ScheduledTime
							,ClientMedicationId
							)
						VALUES (
							@UserName
							,GETDATE()
							,@UserName
							,GETDATE()
							,@ClientOrderIdTemp
							,@ScheduleDate
							,@FrequencyTime4
							,@ClientMedicationValueId
							)
					END
				END

				IF (
						@FrequencyTime5 IS NOT NULL
						AND (DATEDIFF(ss, GETDATE(), CAST(CAST(@ScheduleDate AS DATE) AS DATETIME) + CAST(CAST(@FrequencyTime5 AS TIME(0)) AS DATETIME)) > 0 OR @StartDateForMARCreation IS NOT NULL)
						AND (
							@ClientOrderTargetEndTime IS NULL
							OR @ClientOrderTargetEndTime = '00:00:00'
							OR (
								@ScheduleDate = @TargetDate
								AND DATEDIFF(mi, @FrequencyTime5, @ClientOrderTargetEndTime) > 0
								)
							OR @ScheduleDate < @TargetDate
							)
						)
					AND @IsPRN <> 'Y'
					AND (
						@IsAfter1PM = 'N'
						OR (
							@IsAfter1PM = 'Y'
							AND datediff(ss, '13:00:00', @FrequencyTime5) > 0
							)
						)
				BEGIN
					IF NOT EXISTS (
							SELECT *
							FROM MedAdminRecords
							WHERE ClientOrderId = @ClientOrderIdTemp
								AND ScheduledDate = @ScheduleDate
								AND ScheduledTime = @FrequencyTime5
								AND ISNULL(RecordDeleted, 'N') = 'N'
							)
					BEGIN
						INSERT INTO MedAdminRecords (
							CreatedBy
							,CreatedDate
							,ModifiedBy
							,ModifiedDate
							,ClientOrderId
							,ScheduledDate
							,ScheduledTime
							,ClientMedicationId
							)
						VALUES (
							@UserName
							,GETDATE()
							,@UserName
							,GETDATE()
							,@ClientOrderIdTemp
							,@ScheduleDate
							,@FrequencyTime5
							,@ClientMedicationValueId
							)
					END
				END

				IF (
						@FrequencyTime6 IS NOT NULL
						AND (DATEDIFF(ss, GETDATE(), CAST(CAST(@ScheduleDate AS DATE) AS DATETIME) + CAST(CAST(@FrequencyTime6 AS TIME(0)) AS DATETIME)) > 0 OR @StartDateForMARCreation IS NOT NULL)
						AND (
							@ClientOrderTargetEndTime IS NULL
							OR @ClientOrderTargetEndTime = '00:00:00'
							OR (
								@ScheduleDate = @TargetDate
								AND DATEDIFF(mi, @FrequencyTime6, @ClientOrderTargetEndTime) > 0
								)
							OR @ScheduleDate < @TargetDate
							)
						)
					AND @IsPRN <> 'Y'
					AND (
						@IsAfter1PM = 'N'
						OR (
							@IsAfter1PM = 'Y'
							AND datediff(ss, '13:00:00', @FrequencyTime6) > 0
							)
						)
				BEGIN
					IF NOT EXISTS (
							SELECT *
							FROM MedAdminRecords
							WHERE ClientOrderId = @ClientOrderIdTemp
								AND ScheduledDate = @ScheduleDate
								AND ScheduledTime = @FrequencyTime6
								AND ISNULL(RecordDeleted, 'N') = 'N'
							)
					BEGIN
						INSERT INTO MedAdminRecords (
							CreatedBy
							,CreatedDate
							,ModifiedBy
							,ModifiedDate
							,ClientOrderId
							,ScheduledDate
							,ScheduledTime
							,ClientMedicationId
							)
						VALUES (
							@UserName
							,GETDATE()
							,@UserName
							,GETDATE()
							,@ClientOrderIdTemp
							,@ScheduleDate
							,@FrequencyTime6
							,@ClientMedicationValueId
							)
					END
				END

				IF (
						@FrequencyTime7 IS NOT NULL
						AND (DATEDIFF(ss, GETDATE(), CAST(CAST(@ScheduleDate AS DATE) AS DATETIME) + CAST(CAST(@FrequencyTime7 AS TIME(0)) AS DATETIME)) > 0 OR @StartDateForMARCreation IS NOT NULL)
						AND (
							@ClientOrderTargetEndTime IS NULL
							OR @ClientOrderTargetEndTime = '00:00:00'
							OR (
								@ScheduleDate = @TargetDate
								AND DATEDIFF(mi, @FrequencyTime7, @ClientOrderTargetEndTime) > 0
								)
							OR @ScheduleDate < @TargetDate
							)
						)
					AND @IsPRN <> 'Y'
					AND (
						@IsAfter1PM = 'N'
						OR (
							@IsAfter1PM = 'Y'
							AND datediff(ss, '13:00:00', @FrequencyTime7) > 0
							)
						)
				BEGIN
					IF NOT EXISTS (
							SELECT *
							FROM MedAdminRecords
							WHERE ClientOrderId = @ClientOrderIdTemp
								AND ScheduledDate = @ScheduleDate
								AND ScheduledTime = @FrequencyTime7
								AND ISNULL(RecordDeleted, 'N') = 'N'
							)
					BEGIN
						INSERT INTO MedAdminRecords (
							CreatedBy
							,CreatedDate
							,ModifiedBy
							,ModifiedDate
							,ClientOrderId
							,ScheduledDate
							,ScheduledTime
							,ClientMedicationId
							)
						VALUES (
							@UserName
							,GETDATE()
							,@UserName
							,GETDATE()
							,@ClientOrderIdTemp
							,@ScheduleDate
							,@FrequencyTime7
							,@ClientMedicationValueId
							)
					END
				END

				IF (
						@FrequencyTime8 IS NOT NULL
						AND (DATEDIFF(ss, GETDATE(), CAST(CAST(@ScheduleDate AS DATE) AS DATETIME) + CAST(CAST(@FrequencyTime8 AS TIME(0)) AS DATETIME)) > 0 OR @StartDateForMARCreation IS NOT NULL)
						AND (
							@ClientOrderTargetEndTime IS NULL
							OR @ClientOrderTargetEndTime = '00:00:00'
							OR (
								@ScheduleDate = @TargetDate
								AND DATEDIFF(mi, @FrequencyTime8, @ClientOrderTargetEndTime) > 0
								)
							OR @ScheduleDate < @TargetDate
							)
						)
					AND @IsPRN <> 'Y'
					AND (
						@IsAfter1PM = 'N'
						OR (
							@IsAfter1PM = 'Y'
							AND datediff(ss, '13:00:00', @FrequencyTime8) > 0
							)
						)
				BEGIN
					IF NOT EXISTS (
							SELECT *
							FROM MedAdminRecords
							WHERE ClientOrderId = @ClientOrderIdTemp
								AND ScheduledDate = @ScheduleDate
								AND ScheduledTime = @FrequencyTime8
								AND ISNULL(RecordDeleted, 'N') = 'N'
							)
					BEGIN
						INSERT INTO MedAdminRecords (
							CreatedBy
							,CreatedDate
							,ModifiedBy
							,ModifiedDate
							,ClientOrderId
							,ScheduledDate
							,ScheduledTime
							,ClientMedicationId
							)
						VALUES (
							@UserName
							,GETDATE()
							,@UserName
							,GETDATE()
							,@ClientOrderIdTemp
							,@ScheduleDate
							,@FrequencyTime8
							,@ClientMedicationValueId
							)
					END
				END

				--For PRN   
				IF @IsPRN = 'Y' -- PRN Medication schedule 
				BEGIN
					IF NOT EXISTS (
							SELECT *
							FROM MedAdminRecords
							WHERE ClientOrderId = @ClientOrderIdTemp
								AND ScheduledDate = @ScheduleDate
								AND ISNULL(RecordDeleted, 'N') = 'N'
							)
					BEGIN
						INSERT INTO MedAdminRecords (
							CreatedBy
							,CreatedDate
							,ModifiedBy
							,ModifiedDate
							,ClientOrderId
							,ScheduledDate
							,ScheduledTime
							,ClientMedicationId
							)
						VALUES (
							@UserName
							,GETDATE()
							,@UserName
							,GETDATE()
							,@ClientOrderIdTemp
							,@ScheduleDate
							,NULL
							,@ClientMedicationValueId
							)
					END
				END

				IF NOT EXISTS (
						SELECT DayNo
						FROM #AdministerDays
						)
				BEGIN
					SET @ScheduleDate = DATEADD(d, @Interval, @ScheduleDate)
						--select @ScheduleDate
				END
				ELSE
				BEGIN
					IF EXISTS (
							SELECT SDate
							FROM #ScheduleDays
							WHERE SDate >= @ScheduleDate
							)
					BEGIN
						IF @Interval <= 7
						BEGIN
							SET @ScheduleDate = (
									SELECT TOP 1 SDate
									FROM #ScheduleDays
									WHERE SDate > @ScheduleDate
									ORDER BY SDate ASC
									)
								--select @ScheduleDate as '@@ScheduleDate - loop'
						END
						ELSE
						BEGIN
							SET @ScheduleDate = DATEADD(d, @Interval, @ScheduleDate)
								--select @ScheduleDate as '@ScheduleDate @Interval - loop'
						END
					END
					ELSE
					BEGIN
						SET @ScheduleDate = DATEADD(d, 1, @TargetDate)
					END
				END

				IF (@ScheduleDate > @TargetDate)
					BREAK
				ELSE
					CONTINUE
			END

			SET @CurrentSequence = @CurrentSequence + 1

			IF (@CurrentSequence > @TotalClientOrder)
				BREAK
			ELSE
				CONTINUE
		END

		COMMIT TRANSACTION
	
		Drop table #ClientOrder
		Drop table #AdministerDays
		Drop table #ScheduleDays
		Drop table #ClientwithFrequency
		Drop table #DiscontinueClientOrder
	
		IF @DocumentVersionId IS NULL
		BEGIN
			INSERT INTO #Clients
			SELECT DISTINCT ClientId
			FROM ClientMedications
			WHERE CAST(MedicationStartDate AS DATE) <= CAST(getdate() AS DATE)
				AND (
					MedicationEndDate IS NULL
					OR CAST(MedicationEndDate AS DATE) >= CAST(getdate() AS DATE)
					)
				AND ISNULL(Discontinued, 'N') = 'N'
				AND ISNULL(RecordDeleted, 'N') = 'N'
				AND (
					ISNULL(Ordered, 'N') = 'Y'
					OR (
						ISNULL(Ordered, 'N') = 'N'
						AND ISNULL(SmartCareOrderEntry, 'N') = 'N'
						)
					)

			SET @CurrentSequence = 1

			SELECT @TotalClientOrder = Count(*)
			FROM #Clients
			
			
			--SELECT * FROM #Clients
			WHILE (@CurrentSequence <= @TotalClientOrder)
			BEGIN
				SELECT @ClientId = ClientId
				FROM #Clients
				WHERE Sequence = @CurrentSequence
				--print 'aa'
				EXEC [dbo].[ssp_InsertRXMedToMAR] @ClientId

				SET @CurrentSequence = @CurrentSequence + 1
			END
		END
		Drop table #Clients
		
		SET NOCOUNT OFF
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(max)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_CreateMARDetails') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION

		SET NOCOUNT OFF

		RAISERROR (
				@Error
				,
				-- Message text.                                                                                 
				16
				,
				-- Severity.                                                                                 
				1
				-- State.                                                                                 
				);
	END CATCH
END
GO


