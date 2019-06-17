
/****** Object:  StoredProcedure [dbo].[ssp_InsertRXMedToMAR]    Script Date: 12/13/2013 11:48:52 ******/ 
IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = OBJECT_ID(N'[dbo].[ssp_InsertRXMedToMAR]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_InsertRXMedToMAR] 

go 

/****** Object:  StoredProcedure [dbo].[ssp_InsertRXMedToMAR]    Script Date: 12/13/2013 11:48:52 ******/ 
SET ansi_nulls ON 

go 

SET quoted_identifier ON 

go 

CREATE PROCEDURE [dbo].[ssp_InsertRXMedToMAR] @ClientId INT
	,@ShiftDate DATE = NULL
	,@ShiftDateTemp DATE = NULL
	,@ClientMedicationId VARCHAR(MAX)= NULL
	,@ClientMedicationInstructionId INT =NULL
AS
/*********************************************************************/
/* Stored Procedure: dbo.ssp_InsertRXMedToMAR          */
/* Creation Date: 12/13/2013                                           */
/*                                                                       */
/* Purpose: To Insert RX Medicine data into MAR if not available in MAR   
                                   */
/*                                                                   */
/* Input Parameters: @ClientId               */
/*                                                                    */
/* Output Parameters:                         */
/*                                                              */
/*  exec ssp_InsertRXMedToMAR 164,'2015-03-13',null         */
/*                                                                                      */
/*  Date        Author   Purpose                                */
/* 13/Dec/2013  Gautam   Created                                           
 09/Apr/2015	Gautam   Added code to check client enrolled in programs with MARPrescribedMedication checked  
							task #321, Key Point - Customizations   
 23/Jul/2015    Gautam   Input parameter @ShiftDate and @ShiftDateTemp value set to default null and related   
							code changes.Task#205,Engineering Improvement Initiatives- NBL(I): #205 Group MAR Does Not show RX Medications           
 26/Nov/2015	Chethan N  What : Introduced Recodes to identify the PRN frequency/Directions  
							Why : Key Point - Environment Issues Tracking task# 321.4          
 29/Dec/2015    Gautam     What : Added code related to DaysOfWeek in ClientMedicationScriptDispenseDays table   
							Why : Key Point Environment Issue Tracking: Task# 151  
 13/jan/2016	Chethan N  What : Creating Client Orders mapping to the Client Medications  
							Why : Engineering Improvement Initiatives- NBL(I) task# 280  
 08/Feb/2016    Gautam      What : Added code to delete the future invalid entry in MedAdminRecords table  
							Why : Key Point - Environment Issues Tracking 151 - Changes to Client MAR   
 11/May/2016    Gautam      What : Added code related to SystemConfigurationKeys=SETSTARTDATEFORMARCREATION   
							 Why : To create MAR data from Order Start date ,Woods - Support Go Live,#77    
 14/Feb/2017	Chethan N	What : Checking for ClientPrograms.RequestedDate       
 29/Aug/2017	Chethan N	What: To create MAR data from current date time not Order Start date time.  
							Why:  Renaissance - Dev Items task #5.1          
 18/Jan/2017    Shankha/Gautam  What: Added code to check for Rx completion to return NotCompletedInRx ,Task#5.5,Renaissance - Dev Items       
 09/Apr/2018    Chethan     What: Creating MAR records only for Rx medication, Task  AHN Support GO live, #195				
 16/Apr/2018	Chethan N   What: Avoiding creation of MAR records when there is no mapping OrderTemplateFrequencies which is set as 'Rx default' = 'Y'
							Why : AHN-Support Go Live task # 223
 14/May/2018     Gautam          what: Change code to make compatible with SQL 2016. Why:  AHN Support GO live task #195			
 05/Jun/2018	Chethan N	What : Added parameter @OrderTemplateFrequencyId to Mapping SP.
							Why : AHN Support GO live Task #271
 22/Jun/2018	Chethan N	What : Avoiding creation of the MAR records for End Date of Client Medication Instruction.
							Why : Porter Starke-Customizations Task #11							
 25/Sep/2018    Gautam      What: Added code to update Dispence time based on OrderTemplateFrequencyOverRides table value, CCC customization #74
 08/Oct/2018	Chethan N	What : Changed Data type of parameter @ClientMedicationId to VARCHAR and added code to handle comma separated ClientMedicationId's.
							Why : Engineering Improvement Initiatives- NBL(I) task #672								
 10/Oct/2018    Gautam      What: Added code to NOT create MAR after MARShiftEndTime For PEP - Support Go Live ,Tasks #37							
 07/Dec/2018	Chethan N	What : Creating ClientOrder only when the MAR records are created.	
							Why : WestBridge - Support Go Live Task #17 	
 18/Jan/2019    Chethan N   What: Avoiding deletion of future MAR records based on SystemConfigurationKey 'MARShowDiscontinueMedsFromPastXDays'.
							Why: Discontinued medication should be displayed in the MAR for the number of days specified in SystemConfigurationKey 'MARShowDiscontinueMedsFromPastXDays'.
								MAR AHN-Build Cycle Tasks# 15	*/
/*********************************************************************/
BEGIN
	BEGIN TRY
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
		DECLARE @Error VARCHAR(max)
		DECLARE @ClientOrderTargetDate DATE,@DiscontinueEndDate DATE
		DECLARE @ClientOrderTargetEndTime TIME(0)
		DECLARE @AutoScheduleDays INT
		DECLARE @DaysOfWeek VARCHAR(40)
		DECLARE @Interval INT
			,@LastScheduleDate DATE
		DECLARE @CurrentTime TIME(0)
		DECLARE @RxClientOrderId INT,@OrderTemplateFrequencyId INT
		DECLARE @ClientMedicationInstructionIdValue INT
		DECLARE @StartDateForMARCreation VARCHAR(20)
		DECLARE @MedicationStartDate DATE
		DECLARE @COMPLETEORDERSTORX VARCHAR(1)
		DECLARE @MARShiftStartTime VARCHAR(20),@MARShiftEndTime VARCHAR(20),@CreateMARONLYDuringShiftTimes VARCHAR(10)
		DECLARE @ShowDiscontinueMedsFromPastXDays INT

		SELECT @COMPLETEORDERSTORX = ISNULL(SCK.[Value], 'N')
		FROM SystemConfigurationKeys SCK
		WHERE SCK.[Key] = 'COMPLETEORDERSTORX'

		SET @ScheduleDate = GETDATE()

		SELECT @UserName = 'SHSDBA'

		SELECT @AutoScheduleDays = Value
		FROM SystemConfigurationKeys
		WHERE [Key] = 'MARAutoScheduleDays'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		
		SELECT @ShowDiscontinueMedsFromPastXDays = Value
		FROM SystemConfigurationKeys
		WHERE [Key] = 'MARShowDiscontinueMedsFromPastXDays'
			AND (ISNULL(RecordDeleted, 'N') = 'N')

		SELECT @StartDateForMARCreation = Value
		FROM SystemConfigurationKeys
		WHERE [Key] = 'SETSTARTDATEFORMARCREATION'
			AND ISNULL(RecordDeleted, 'N') = 'N'
			
		SELECT @MARShiftStartTime = Value FROM SystemConfigurationKeys WHERE [Key] = 'MARShiftStartTime' AND ISNULL(RecordDeleted, 'N') = 'N'
		SELECT @MARShiftEndTime = Value FROM SystemConfigurationKeys WHERE [Key] = 'MARShiftEndTime' AND ISNULL(RecordDeleted, 'N') = 'N'
		SELECT @CreateMARONLYDuringShiftTimes = ISNULL(SCK.[Value], 'No') FROM SystemConfigurationKeys SCK WHERE SCK.[Key] = 'CreateMARDuringShiftTimes' 
					AND ISNULL(SCK.RecordDeleted, 'N') = 'N'

		IF @ShiftDate IS NULL
		BEGIN
			SET @ShiftDate = CAST(getdate() AS DATE)
			SET @ShiftDateTemp = DATEADD(d, 1, @ShiftDate)
		END

		-- Delete all the MAR which has invalid future entry for modified ClientMedicationId  
		UPDATE MAR
		SET MAR.RecordDeleted = 'Y'
			,MAR.DeletedDate = getdate()
			,MAR.DeletedBy = @UserName
		FROM MedAdminRecords MAR
		JOIN (
			SELECT DISTINCT CM.ClientMedicationId
				,cast(CMS.StartDate AS DATE) AS 'StartDate'
				,cast(CMS.EndDate AS DATE) AS 'EndDate'
				,CMI.ClientMedicationInstructionId
			FROM ClientMedications CM
			JOIN ClientMedicationInstructions CMI ON CM.ClientMedicationId = CMI.ClientMedicationId
				AND ISNULL(CMI.RecordDeleted, 'N') = 'N'
				AND CMI.Active = 'N'
			JOIN ClientMedicationScriptDrugs CMS ON CMS.ClientMedicationInstructionId = CMI.ClientMedicationInstructionId
				AND ISNULL(CMS.RecordDeleted, 'N') = 'N'
			WHERE ISNULL(CM.RecordDeleted, 'N') = 'N'
				AND CM.ClientId = @ClientId
				AND (@ClientMedicationId is null or EXISTS(SELECT 1 FROM [dbo].[SplitString] (@ClientMedicationId,',') AS T WHERE T.Token = CM.ClientMedicationId ))
				AND (@ClientMedicationInstructionId is null or CMS.ClientMedicationInstructionId =@ClientMedicationInstructionId)
			) ActiveMed ON MAR.ClientMedicationId = ActiveMed.ClientMedicationId
			AND MAR.ClientMedicationInstructionId = ActiveMed.ClientMedicationInstructionId
		WHERE cast(MAR.ScheduledDate AS DATE) >= ActiveMed.StartDate
			AND cast(MAR.ScheduledDate AS DATE) <= ActiveMed.EndDate
			AND cast(MAR.ScheduledDate AS DATE) >= CAST(DATEADD(DD, ISNULL(@ShowDiscontinueMedsFromPastXDays, 1), GETDATE()) AS DATE)
			--AND MAR.ScheduledTime >= cast(getdate() AS TIME(0))
			AND MAR.AdministeredDate IS NULL
			AND MAR.RecordDeleted IS NULL

		CREATE TABLE #AdministerDays (DayNo INT)

		CREATE TABLE #ScheduleDays (SDate DATE)

		CREATE TABLE #ClientwithFrequency (
			Sequence INT IDENTITY(1, 1)
			,ClientMedicationId INT
			,MedicationStartDate DATE
			,IsPRN CHAR(1)
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
			,DaysOfWeek VARCHAR(40)
			,Interval INT
			,ClientMedicationInstructionId INT
			,OrderTemplateFrequencyId INT
			,DiscontinueEndDate DATE
			)

		IF EXISTS (
				SELECT 1
				FROM ClientPrograms CP
				JOIN Programs P ON CP.ProgramId = P.ProgramId
				WHERE ISnull(CP.RecordDeleted, 'N') = 'N'
					AND ISnull(P.RecordDeleted, 'N') = 'N'
					AND CP.ClientId = @ClientId
					AND CP.STATUS IN (
						1
						,4
						) --Referred (1),Enrolled(4)  
					AND IsNull(P.MARPrescribedMedication, 'N') = 'Y'
					AND (
						cast(CP.EnrolledDate AS DATE) <= cast(@ScheduleDate AS DATE)
						OR cast(CP.RequestedDate AS DATE) <= cast(@ScheduleDate AS DATE)
						)
				)
		BEGIN
			-- Get all OrderFrequency for ClientOrderId in #ClientWithFrequency         
			INSERT INTO #ClientwithFrequency (
				ClientMedicationId
				,MedicationStartDate
				,IsPRN
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
				,DaysOfWeek
				,Interval
				,ClientMedicationInstructionId
				,OrderTemplateFrequencyId
				,DiscontinueEndDate
				)
			SELECT MI.ClientMedicationId
				,MI.StartDate
				,MI.IsPRN
				,CASE 
					WHEN MI.DispenseTime1 IS NOT NULL
						THEN CONVERT(VARCHAR(15), MI.DispenseTime1, 108)
					ELSE NULL
					END
				,CASE 
					WHEN MI.DispenseTime2 IS NOT NULL
						THEN CONVERT(VARCHAR(15), MI.DispenseTime2, 108)
					ELSE NULL
					END
				,CASE 
					WHEN MI.DispenseTime3 IS NOT NULL
						THEN CONVERT(VARCHAR(15), MI.DispenseTime3, 108)
					ELSE NULL
					END
				,CASE 
					WHEN MI.DispenseTime4 IS NOT NULL
						THEN CONVERT(VARCHAR(15), MI.DispenseTime4, 108)
					ELSE NULL
					END
				,CASE 
					WHEN MI.DispenseTime5 IS NOT NULL
						THEN CONVERT(VARCHAR(15), MI.DispenseTime5, 108)
					ELSE NULL
					END
				,CASE 
					WHEN MI.DispenseTime6 IS NOT NULL
						THEN CONVERT(VARCHAR(15), MI.DispenseTime6, 108)
					ELSE NULL
					END
				,CASE 
					WHEN MI.DispenseTime7 IS NOT NULL
						THEN CONVERT(VARCHAR(15), MI.DispenseTime7, 108)
					ELSE NULL
					END
				,CASE 
					WHEN MI.DispenseTime8 IS NOT NULL
						THEN CONVERT(VARCHAR(15), MI.DispenseTime8, 108)
					ELSE NULL
					END
				,CAST(MI.EndDate AS DATE)
				,CAST('23:59:00' AS TIME(0))
				,MI.DaysOfWeek
				,CASE 
					WHEN CONVERT(FLOAT, MI.ExternalCode1) < 1
						THEN CASE 
								WHEN (1 / CONVERT(FLOAT, MI.ExternalCode1)) > 1
									THEN FLOOR(1 / CONVERT(FLOAT, MI.ExternalCode1))
								ELSE 1
								END
					ELSE 1
					END
				,MI.ClientMedicationInstructionId
				,MI.OrderTemplateFrequencyId
				,MI.DiscontinueDate
			FROM (
				SELECT CMI.ClientMedicationInstructionId
					,ISNULL(OTF.IsPRN, 'N') AS IsPRN
					,CMI.ClientMedicationId
					,CMSD.StartDate
					,DATEADD(D, -1, CMSD.EndDate) AS EndDate
					,OTF.DispenseTime1
					,OTF.DispenseTime2
					,OTF.DispenseTime3
					,OTF.DispenseTime4
					,OTF.DispenseTime5
					,OTF.DispenseTime6
					,OTF.DispenseTime7
					,OTF.DispenseTime8
					,CMDD.DaysOfWeek
					,GC.ExternalCode1
					,OTF.OrderTemplateFrequencyId
					,CAST(CM.DiscontinueDate AS DATE) as DiscontinueDate
					,ROW_NUMBER() OVER (
						PARTITION BY CMI.ClientMedicationId ORDER BY CMI.ClientMedicationInstructionId ASC
						) AS RowCountNo
				FROM ClientMedicationInstructions CMI
				INNER JOIN ClientMedications CM ON CMI.ClientMedicationId = CM.ClientMedicationId
					AND isnull(CMI.Active, 'Y') = 'Y'
					AND isnull(CMI.RecordDeleted, 'N') = 'N'
					AND isnull(CM.RecordDeleted, 'N') = 'N'
					AND (ISNULL(CM.Discontinued, 'N') = 'N'
						OR CAST(CM.DiscontinueDate AS DATE) >  CAST(GETDATE() AS DATE))
				INNER JOIN ClientMedicationScriptDrugs CMSD ON CMI.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId
					AND isnull(CMSD.RecordDeleted, 'N') = 'N'
				INNER JOIN OrderTemplateFrequencies OTF ON OTF.RxFrequencyId = CMI.Schedule
					AND ISNULL(OTF.RecordDeleted, 'N') = 'N'
				INNER JOIN GlobalCodes GC ON CMI.Schedule = Gc.GlobalCodeId
					AND isnull(GC.RecordDeleted, 'N') = 'N'
				LEFT JOIN ClientMedicationScriptDispenseDays CMDD ON CMDD.ClientMedicationId = CM.ClientMedicationId
					AND CMDD.ClientMedicationInstructionId = CMI.ClientMedicationInstructionId
					AND CMDD.ClientMedicationScriptId = CMSD.ClientMedicationScriptId
					AND isnull(CMDD.RecordDeleted, 'N') = 'N'
				WHERE ISNULL(CM.Ordered, 'N') = 'Y'
					and ISNULL(CM.SmartCareOrderEntry, 'N') = 'N'	
					AND CM.ClientId = @ClientId
					AND ISNULL(OTF.IsDefault, 'N') = 'Y'
					AND CMI.ModifiedDate > = DATEADD(D,-60,GETDATE())
					AND (@ClientMedicationId is null or EXISTS(SELECT 1 FROM [dbo].[SplitString] (@ClientMedicationId,',') AS T WHERE T.Token = CM.ClientMedicationId ))
					AND (@ClientMedicationInstructionId is null or CMSD.ClientMedicationInstructionId =@ClientMedicationInstructionId)
					AND (
						(
							@ShiftDate >= CMSD.StartDate
							AND @ShiftDate <= DATEADD(D, -1, CMSD.EndDate)
							)
						OR (
							CMSD.EndDate IS NULL
							OR (
								@ShiftDateTemp >= CMSD.StartDate
								AND @ShiftDateTemp <= DATEADD(D, -1, CMSD.EndDate)
								)
							)
						)
				) MI
			--WHERE MI.RowCountNo = 1
		END

		IF EXISTS (
				SELECT 1
				FROM ClientPrograms CP
				JOIN Programs P ON CP.ProgramId = P.ProgramId
				WHERE ISnull(CP.RecordDeleted, 'N') = 'N'
					AND ISnull(P.RecordDeleted, 'N') = 'N'
					AND CP.ClientId = @ClientId
					AND CP.STATUS IN (
						1
						,4
						) --Referred (1),Enrolled(4)  
					AND IsNull(P.MARNonOrderedMedication, 'N') = 'Y'
					AND (
						cast(CP.EnrolledDate AS DATE) <= cast(@ScheduleDate AS DATE)
						OR cast(CP.RequestedDate AS DATE) <= cast(@ScheduleDate AS DATE)
						)
				)
		BEGIN
			INSERT INTO #ClientwithFrequency (
				ClientMedicationId
				,MedicationStartDate
				,IsPRN
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
				,DaysOfWeek
				,Interval
				,ClientMedicationInstructionId
				,OrderTemplateFrequencyId
				,DiscontinueEndDate
				)
			SELECT MI.ClientMedicationId
				,MI.StartDate
				,MI.IsPRN
				,CASE 
					WHEN MI.DispenseTime1 IS NOT NULL
						THEN CONVERT(VARCHAR(15), MI.DispenseTime1, 108)
					ELSE NULL
					END
				,CASE 
					WHEN MI.DispenseTime2 IS NOT NULL
						THEN CONVERT(VARCHAR(15), MI.DispenseTime2, 108)
					ELSE NULL
					END
				,CASE 
					WHEN MI.DispenseTime3 IS NOT NULL
						THEN CONVERT(VARCHAR(15), MI.DispenseTime3, 108)
					ELSE NULL
					END
				,CASE 
					WHEN MI.DispenseTime4 IS NOT NULL
						THEN CONVERT(VARCHAR(15), MI.DispenseTime4, 108)
					ELSE NULL
					END
				,CASE 
					WHEN MI.DispenseTime5 IS NOT NULL
						THEN CONVERT(VARCHAR(15), MI.DispenseTime5, 108)
					ELSE NULL
					END
				,CASE 
					WHEN MI.DispenseTime6 IS NOT NULL
						THEN CONVERT(VARCHAR(15), MI.DispenseTime6, 108)
					ELSE NULL
					END
				,CASE 
					WHEN MI.DispenseTime7 IS NOT NULL
						THEN CONVERT(VARCHAR(15), MI.DispenseTime7, 108)
					ELSE NULL
					END
				,CASE 
					WHEN MI.DispenseTime8 IS NOT NULL
						THEN CONVERT(VARCHAR(15), MI.DispenseTime8, 108)
					ELSE NULL
					END
				,CAST(MI.EndDate AS DATE)
				,CAST('23:59:00' AS TIME(0))
				,MI.DaysOfWeek
				,CASE 
					WHEN CONVERT(FLOAT, MI.ExternalCode1) < 1
						THEN CASE 
								WHEN (1 / CONVERT(FLOAT, MI.ExternalCode1)) > 1
									THEN FLOOR(1 / CONVERT(FLOAT, MI.ExternalCode1))
								ELSE 1
								END
					ELSE 1
					END
				,MI.ClientMedicationInstructionId
				,MI.OrderTemplateFrequencyId
				,MI.DiscontinueDate 
			FROM (
				SELECT CMI.ClientMedicationInstructionId
					,ISNULL(OTF.IsPRN, 'N') AS IsPRN
					,CMI.ClientMedicationId
					,CMSD.StartDate
					,DATEADD(D, -1, CMSD.EndDate) AS EndDate
					,OTF.DispenseTime1
					,OTF.DispenseTime2
					,OTF.DispenseTime3
					,OTF.DispenseTime4
					,OTF.DispenseTime5
					,OTF.DispenseTime6
					,OTF.DispenseTime7
					,OTF.DispenseTime8
					,CMDD.DaysOfWeek
					,GC.ExternalCode1
					,OTF.OrderTemplateFrequencyId
					,CAST(CM.DiscontinueDate AS DATE) as DiscontinueDate 
					,ROW_NUMBER() OVER (
						PARTITION BY CMI.ClientMedicationId ORDER BY CMI.ClientMedicationInstructionId ASC
						) AS RowCountNo
				FROM ClientMedicationInstructions CMI
				INNER JOIN ClientMedications CM ON CMI.ClientMedicationId = CM.ClientMedicationId
					AND isnull(CMI.Active, 'Y') = 'Y'
					AND isnull(CMI.RecordDeleted, 'N') = 'N'
					AND isnull(CM.RecordDeleted, 'N') = 'N'
					AND (ISNULL(CM.Discontinued, 'N') = 'N'
						OR CAST(CM.DiscontinueDate AS DATE) >  CAST(GETDATE() AS DATE))
				INNER JOIN ClientMedicationScriptDrugs CMSD ON CMI.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId
					AND isnull(CMSD.RecordDeleted, 'N') = 'N'
				INNER JOIN OrderTemplateFrequencies OTF ON OTF.RxFrequencyId = CMI.Schedule
					AND ISNULL(OTF.RecordDeleted, 'N') = 'N'
				LEFT JOIN GlobalCodes GC ON CMI.Schedule = Gc.GlobalCodeId
					AND isnull(GC.RecordDeleted, 'N') = 'N'
				LEFT JOIN ClientMedicationScriptDispenseDays CMDD ON CMDD.ClientMedicationId = CM.ClientMedicationId
					AND CMDD.ClientMedicationInstructionId = CMI.ClientMedicationInstructionId
					AND isnull(CMDD.RecordDeleted, 'N') = 'N'
				WHERE ISNULL(CM.Ordered, 'N') = 'N'
					AND ISNULL(CM.SmartCareOrderEntry, 'N') = 'N'
					AND CM.ClientId = @ClientId
					AND ISNULL(OTF.IsDefault, 'N') = 'Y'
					AND (@ClientMedicationId is null or EXISTS(SELECT 1 FROM [dbo].[SplitString] (@ClientMedicationId,',') AS T WHERE T.Token = CM.ClientMedicationId ))
					AND (@ClientMedicationInstructionId is null or CMSD.ClientMedicationInstructionId =@ClientMedicationInstructionId)
					AND CMI.ModifiedDate > = DATEADD(D,-60,GETDATE())
					AND (
						(
							@ShiftDate >= CMSD.StartDate
							AND @ShiftDate <= DATEADD(D, -1, CMSD.EndDate)
							)
						OR (
							CMSD.EndDate IS NULL
							OR (
								@ShiftDateTemp >= CMSD.StartDate
								AND @ShiftDateTemp <= DATEADD(D, -1, CMSD.EndDate)
								)
							)
						)
				) MI
			--WHERE MI.RowCountNo = 1
		END
		
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
				From #ClientwithFrequency C Join ClientMedicationInstructions CO ON CO.ClientMedicationInstructionId = C.ClientMedicationInstructionId
								AND ISNULL(CO.RecordDeleted, 'N') = 'N'
					INNER JOIN ClientMedications CM ON CM.ClientMedicationId = CO.ClientMedicationId
								AND ISNULL(CM.RecordDeleted, 'N') = 'N' 
					--INNER JOIN OrderTemplateFrequencies OTF ON OTF.OrderTemplateFrequencyId = C.OrderTemplateFrequencyId
					--	AND ISNULL(OTF.RecordDeleted, 'N') = 'N'
					--INNER JOIN Strengths s on  s.StrengthId= C.StrengthId  
					JOIN OrderTemplateFrequencyOverRides OTFR ON OTFR.ClientId = CM.ClientId
						AND OTFR.RxFrequencyId = CO.Schedule
						AND OTFR.MedicationId = CO.StrengthId
						AND ISNULL(OTFR.RecordDeleted, 'N') = 'N'
				
					
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

		BEGIN TRAN

		-- Loop through all ClientOrderId and @ScheduleDate should be less than or equal to @TargetDate   
		WHILE (@CurrentSequence <= @TotalClientOrder)
		BEGIN
			SELECT @ClientOrderIdTemp = ClientMedicationId
				,@IsPRN = IsPRN
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
				,@DaysOfWeek = DaysOfWeek
				,@Interval = Interval
				,@ClientMedicationInstructionIdValue = ClientMedicationInstructionId
				,@MedicationStartDate = MedicationStartDate
				,@OrderTemplateFrequencyId=OrderTemplateFrequencyId
				,@DiscontinueEndDate=DiscontinueEndDate
			FROM #ClientwithFrequency
			WHERE Sequence = @CurrentSequence

			SET @ScheduleDate = @MedicationStartDate --@ShiftDate --GETDATE()   
				-- Set @TargetDate based on ClientOrder End date  else Today date  
				--set @TargetDate=@ClientOrderTargetDate  
				--IF @TargetDate is null   
				--BEGIN  
				--       SET @TargetDate=DATEADD(d,case when @AutoScheduleDays >1 then @AutoScheduleDays-1 else @AutoScheduleDays end,@ShiftDate)  
				--END  
			SET @AutoScheduleDays = CASE 
					WHEN ISNULL(@AutoScheduleDays, '') = ''
						THEN 30
					ELSE @AutoScheduleDays
					END
			SET @TargetDate = DATEADD(d, CASE 
						WHEN @AutoScheduleDays > 1
							THEN @AutoScheduleDays - 1
						ELSE @AutoScheduleDays
						END, CAST(getdate() AS DATE))

			IF @ClientOrderTargetDate IS NOT NULL
				AND @ClientOrderTargetDate < @TargetDate
				SET @TargetDate = @ClientOrderTargetDate

			IF @DiscontinueEndDate is not null and 
					(@DiscontinueEndDate < @TargetDate and @DiscontinueEndDate > CAST(getdate() AS DATE))
				SET @TargetDate = @DiscontinueEndDate
			
			IF @DiscontinueEndDate =CAST(getdate() AS DATE)
				SET @TargetDate = dateadd(d,-1,@ScheduleDate)
			
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

			IF @StartDateForMARCreation IS NOT NULL
				AND isdate(@StartDateForMARCreation) = 1
			BEGIN
				IF @ScheduleDate < @StartDateForMARCreation
					SET @ScheduleDate = @StartDateForMARCreation
			END

			WHILE (@ScheduleDate <= @TargetDate)
			BEGIN

				--EXEC ssp_CreateRxMappingClientOrder @ClientOrderIdTemp,@OrderTemplateFrequencyId,
				--	@ClientMedicationInstructionIdValue,@RxClientOrderId OUTPUT
					
				-- @FrequencyTime1 is not null and  (@ClientOrderTargetEndTime is not entered or its after frequency time)  
				-- (@ScheduleDate + @FrequencyTime1) should be greater than current date time.  
				IF @FrequencyTime1 IS NOT NULL
					AND (
						DATEDIFF(ss, GETDATE(), CAST(CAST(@ScheduleDate AS DATE) AS DATETIME) + CAST(CAST(@FrequencyTime1 AS TIME(0)) AS DATETIME)) > 0
						OR @StartDateForMARCreation IS NOT NULL
						)
					AND @IsPRN <> 'Y'
				BEGIN
					IF NOT EXISTS (
							SELECT *
							FROM MedAdminRecords
							WHERE ClientMedicationId = @ClientOrderIdTemp
								AND ScheduledDate = @ScheduleDate
								AND ScheduledTime = @FrequencyTime1
								AND ISNULL(RecordDeleted, 'N') = 'N'
							)
					BEGIN
						EXEC ssp_CreateRxMappingClientOrder @ClientOrderIdTemp,@OrderTemplateFrequencyId,  
							@ClientMedicationInstructionIdValue,@RxClientOrderId OUTPUT 

						INSERT INTO MedAdminRecords (
							CreatedBy
							,CreatedDate
							,ModifiedBy
							,ModifiedDate
							,ClientMedicationId
							,ScheduledDate
							,ScheduledTime
							,ClientOrderId
							,ClientMedicationInstructionId
							)
						VALUES (
							@UserName
							,GETDATE()
							,@UserName
							,GETDATE()
							,@ClientOrderIdTemp
							,@ScheduleDate
							,@FrequencyTime1
							,@RxClientOrderId
							,@ClientMedicationInstructionIdValue
							)
					END
				END

				IF @FrequencyTime2 IS NOT NULL
					AND (
						DATEDIFF(ss, GETDATE(), CAST(CAST(@ScheduleDate AS DATE) AS DATETIME) + CAST(CAST(@FrequencyTime2 AS TIME(0)) AS DATETIME)) > 0
						OR @StartDateForMARCreation IS NOT NULL
						)
					AND @IsPRN <> 'Y'
				BEGIN
					IF NOT EXISTS (
							SELECT *
							FROM MedAdminRecords
							WHERE ClientMedicationId = @ClientOrderIdTemp
								AND ScheduledDate = @ScheduleDate
								AND ScheduledTime = @FrequencyTime2
								AND ISNULL(RecordDeleted, 'N') = 'N'
							)
					BEGIN
						EXEC ssp_CreateRxMappingClientOrder @ClientOrderIdTemp,@OrderTemplateFrequencyId,  
							@ClientMedicationInstructionIdValue,@RxClientOrderId OUTPUT 

						INSERT INTO MedAdminRecords (
							CreatedBy
							,CreatedDate
							,ModifiedBy
							,ModifiedDate
							,ClientMedicationId
							,ScheduledDate
							,ScheduledTime
							,ClientOrderId
							,ClientMedicationInstructionId
							)
						VALUES (
							@UserName
							,GETDATE()
							,@UserName
							,GETDATE()
							,@ClientOrderIdTemp
							,@ScheduleDate
							,@FrequencyTime2
							,@RxClientOrderId
							,@ClientMedicationInstructionIdValue
							)
					END
				END

				IF @FrequencyTime3 IS NOT NULL
					AND (
						DATEDIFF(ss, GETDATE(), CAST(CAST(@ScheduleDate AS DATE) AS DATETIME) + CAST(CAST(@FrequencyTime3 AS TIME(0)) AS DATETIME)) > 0
						OR @StartDateForMARCreation IS NOT NULL
						)
					AND @IsPRN <> 'Y'
				BEGIN
					IF NOT EXISTS (
							SELECT *
							FROM MedAdminRecords
							WHERE ClientMedicationId = @ClientOrderIdTemp
								AND ScheduledDate = @ScheduleDate
								AND ScheduledTime = @FrequencyTime3
								AND ISNULL(RecordDeleted, 'N') = 'N'
							)
					BEGIN
						EXEC ssp_CreateRxMappingClientOrder @ClientOrderIdTemp,@OrderTemplateFrequencyId,  
							@ClientMedicationInstructionIdValue,@RxClientOrderId OUTPUT 

						INSERT INTO MedAdminRecords (
							CreatedBy
							,CreatedDate
							,ModifiedBy
							,ModifiedDate
							,ClientMedicationId
							,ScheduledDate
							,ScheduledTime
							,ClientOrderId
							,ClientMedicationInstructionId
							)
						VALUES (
							@UserName
							,GETDATE()
							,@UserName
							,GETDATE()
							,@ClientOrderIdTemp
							,@ScheduleDate
							,@FrequencyTime3
							,@RxClientOrderId
							,@ClientMedicationInstructionIdValue
							)
					END
				END

				IF @FrequencyTime4 IS NOT NULL
					AND (
						DATEDIFF(ss, GETDATE(), CAST(CAST(@ScheduleDate AS DATE) AS DATETIME) + CAST(CAST(@FrequencyTime4 AS TIME(0)) AS DATETIME)) > 0
						OR @StartDateForMARCreation IS NOT NULL
						)
					AND @IsPRN <> 'Y'
				BEGIN
					IF NOT EXISTS (
							SELECT *
							FROM MedAdminRecords
							WHERE ClientMedicationId = @ClientOrderIdTemp
								AND ScheduledDate = @ScheduleDate
								AND ScheduledTime = @FrequencyTime4
								AND ISNULL(RecordDeleted, 'N') = 'N'
							)
					BEGIN
						EXEC ssp_CreateRxMappingClientOrder @ClientOrderIdTemp,@OrderTemplateFrequencyId,  
							@ClientMedicationInstructionIdValue,@RxClientOrderId OUTPUT 

						INSERT INTO MedAdminRecords (
							CreatedBy
							,CreatedDate
							,ModifiedBy
							,ModifiedDate
							,ClientMedicationId
							,ScheduledDate
							,ScheduledTime
							,ClientOrderId
							,ClientMedicationInstructionId
							)
						VALUES (
							@UserName
							,GETDATE()
							,@UserName
							,GETDATE()
							,@ClientOrderIdTemp
							,@ScheduleDate
							,@FrequencyTime4
							,@RxClientOrderId
							,@ClientMedicationInstructionIdValue
							)
					END
				END

				IF @FrequencyTime5 IS NOT NULL
					AND (
						DATEDIFF(ss, GETDATE(), CAST(CAST(@ScheduleDate AS DATE) AS DATETIME) + CAST(CAST(@FrequencyTime5 AS TIME(0)) AS DATETIME)) > 0
						OR @StartDateForMARCreation IS NOT NULL
						)
					AND @IsPRN <> 'Y'
				BEGIN
					IF NOT EXISTS (
							SELECT *
							FROM MedAdminRecords
							WHERE ClientMedicationId = @ClientOrderIdTemp
								AND ScheduledDate = @ScheduleDate
								AND ScheduledTime = @FrequencyTime5
								AND ISNULL(RecordDeleted, 'N') = 'N'
							)
					BEGIN
						EXEC ssp_CreateRxMappingClientOrder @ClientOrderIdTemp,@OrderTemplateFrequencyId,  
							@ClientMedicationInstructionIdValue,@RxClientOrderId OUTPUT 

						INSERT INTO MedAdminRecords (
							CreatedBy
							,CreatedDate
							,ModifiedBy
							,ModifiedDate
							,ClientMedicationId
							,ScheduledDate
							,ScheduledTime
							,ClientOrderId
							,ClientMedicationInstructionId
							)
						VALUES (
							@UserName
							,GETDATE()
							,@UserName
							,GETDATE()
							,@ClientOrderIdTemp
							,@ScheduleDate
							,@FrequencyTime5
							,@RxClientOrderId
							,@ClientMedicationInstructionIdValue
							)
					END
				END

				IF @FrequencyTime6 IS NOT NULL
					AND (
						DATEDIFF(ss, GETDATE(), CAST(CAST(@ScheduleDate AS DATE) AS DATETIME) + CAST(CAST(@FrequencyTime6 AS TIME(0)) AS DATETIME)) > 0
						OR @StartDateForMARCreation IS NOT NULL
						)
					AND @IsPRN <> 'Y'
				BEGIN
					IF NOT EXISTS (
							SELECT *
							FROM MedAdminRecords
							WHERE ClientMedicationId = @ClientOrderIdTemp
								AND ScheduledDate = @ScheduleDate
								AND ScheduledTime = @FrequencyTime6
								AND ISNULL(RecordDeleted, 'N') = 'N'
							)
					BEGIN
						EXEC ssp_CreateRxMappingClientOrder @ClientOrderIdTemp,@OrderTemplateFrequencyId,  
							@ClientMedicationInstructionIdValue,@RxClientOrderId OUTPUT 

						INSERT INTO MedAdminRecords (
							CreatedBy
							,CreatedDate
							,ModifiedBy
							,ModifiedDate
							,ClientMedicationId
							,ScheduledDate
							,ScheduledTime
							,ClientOrderId
							,ClientMedicationInstructionId
							)
						VALUES (
							@UserName
							,GETDATE()
							,@UserName
							,GETDATE()
							,@ClientOrderIdTemp
							,@ScheduleDate
							,@FrequencyTime6
							,@RxClientOrderId
							,@ClientMedicationInstructionIdValue
							)
					END
				END

				IF @FrequencyTime7 IS NOT NULL
					AND (
						DATEDIFF(ss, GETDATE(), CAST(CAST(@ScheduleDate AS DATE) AS DATETIME) + CAST(CAST(@FrequencyTime7 AS TIME(0)) AS DATETIME)) > 0
						OR @StartDateForMARCreation IS NOT NULL
						)
					AND @IsPRN <> 'Y'
				BEGIN
					IF NOT EXISTS (
							SELECT *
							FROM MedAdminRecords
							WHERE ClientMedicationId = @ClientOrderIdTemp
								AND ScheduledDate = @ScheduleDate
								AND ScheduledTime = @FrequencyTime7
								AND ISNULL(RecordDeleted, 'N') = 'N'
							)
					BEGIN
						EXEC ssp_CreateRxMappingClientOrder @ClientOrderIdTemp,@OrderTemplateFrequencyId,  
							@ClientMedicationInstructionIdValue,@RxClientOrderId OUTPUT 

						INSERT INTO MedAdminRecords (
							CreatedBy
							,CreatedDate
							,ModifiedBy
							,ModifiedDate
							,ClientMedicationId
							,ScheduledDate
							,ScheduledTime
							,ClientOrderId
							,ClientMedicationInstructionId
							)
						VALUES (
							@UserName
							,GETDATE()
							,@UserName
							,GETDATE()
							,@ClientOrderIdTemp
							,@ScheduleDate
							,@FrequencyTime7
							,@RxClientOrderId
							,@ClientMedicationInstructionIdValue
							)
					END
				END

				IF @FrequencyTime8 IS NOT NULL
					AND (
						DATEDIFF(ss, GETDATE(), CAST(CAST(@ScheduleDate AS DATE) AS DATETIME) + CAST(CAST(@FrequencyTime8 AS TIME(0)) AS DATETIME)) > 0
						OR @StartDateForMARCreation IS NOT NULL
						)
					AND @IsPRN <> 'Y'
				BEGIN
					IF NOT EXISTS (
							SELECT *
							FROM MedAdminRecords
							WHERE ClientMedicationId = @ClientOrderIdTemp
								AND ScheduledDate = @ScheduleDate
								AND ScheduledTime = @FrequencyTime8
								AND ISNULL(RecordDeleted, 'N') = 'N'
							)
					BEGIN
						EXEC ssp_CreateRxMappingClientOrder @ClientOrderIdTemp,@OrderTemplateFrequencyId,  
							@ClientMedicationInstructionIdValue,@RxClientOrderId OUTPUT 

						INSERT INTO MedAdminRecords (
							CreatedBy
							,CreatedDate
							,ModifiedBy
							,ModifiedDate
							,ClientMedicationId
							,ScheduledDate
							,ScheduledTime
							,ClientOrderId
							,ClientMedicationInstructionId
							)
						VALUES (
							@UserName
							,GETDATE()
							,@UserName
							,GETDATE()
							,@ClientOrderIdTemp
							,@ScheduleDate
							,@FrequencyTime8
							,@RxClientOrderId
							,@ClientMedicationInstructionIdValue
							)
					END
				END

				--For PRN     
				IF @IsPRN = 'Y' -- PRN Medication schedule   
				BEGIN
					IF NOT EXISTS (
							SELECT *
							FROM MedAdminRecords
							WHERE ClientMedicationId = @ClientOrderIdTemp
								AND ScheduledDate = @ScheduleDate
								AND ISNULL(RecordDeleted, 'N') = 'N'
							)
					BEGIN
						EXEC ssp_CreateRxMappingClientOrder @ClientOrderIdTemp,@OrderTemplateFrequencyId,  
							@ClientMedicationInstructionIdValue,@RxClientOrderId OUTPUT 

						INSERT INTO MedAdminRecords (
							CreatedBy
							,CreatedDate
							,ModifiedBy
							,ModifiedDate
							,ClientMedicationId
							,ScheduledDate
							,ScheduledTime
							,ClientOrderId
							,ClientMedicationInstructionId
							)
						VALUES (
							@UserName
							,GETDATE()
							,@UserName
							,GETDATE()
							,@ClientOrderIdTemp
							,@ScheduleDate
							,NULL
							,@RxClientOrderId
							,@ClientMedicationInstructionIdValue
							)
					END
				END

				--SET @ScheduleDate=DATEADD(d, 1, @ScheduleDate)   
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

		COMMIT TRAN

		DROP TABLE #ClientwithFrequency
	END TRY

	BEGIN CATCH
		SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + 
		Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_InsertRXMedToMAR') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' +
		 CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())

		RAISERROR (
				@Error
				,-- Message text.               
				16
				,-- Severity.               
				1 -- State.               
				);
	END CATCH
END

GO


