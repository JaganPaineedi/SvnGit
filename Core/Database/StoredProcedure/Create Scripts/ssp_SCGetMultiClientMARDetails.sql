 /****** Object:  StoredProcedure [dbo].[ssp_SCGetMultiClientMARDetails]    Script Date: 15/04/2015 11:48:52 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetMultiClientMARDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetMultiClientMARDetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetMultiClientMARDetails]    Script Date: 15/04/2015 11:48:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetMultiClientMARDetails] @ShiftDate DATE
	,@ShiftTime VARCHAR(8)
	,@ProgramId INT = 0
	,@UnitId INT = 0
	,@OtherFilter INT = 0
	,@Active CHAR
	,@StaffId INT = NULL
	--,@SortBy VARCHAR(25)                          
	-- text,                           
	--@OrderType INT=-1                          
	/*********************************************************************/
	/* Stored Procedure: dbo.ssp_SCGetMultiClientMARDetails          */
	/* Creation Date: 04/15/2015                                           */
	/*                                                                       */
	/* Purpose: To display Multi Client Mar detail                           
                                   */
	/*                                                                   */
	/* Input Parameters: @ShiftDate ,@ShiftTime              */
	/*                                                                    */
	/* Test Parameters:                         */
	/*   set @ShiftDate ='2013-08-20'                           
  set @ShiftTime ='16:00'                                                                */
	/*  exec ssp_SCGetMultiClientMARDetails @ShiftDate='2018-11-29 00:00:00',@ShiftTime=N'09:00 AM',    
  @ProgramId=0,@UnitId=0,@OtherFilter=0 , @Active='Y', @StaffId = 13722      */
	/*                                                                                      */
	/* Date                 Author    Purpose                                */
	/* 15th Apr 2015        Gautam    Created    Task #820 - Multi - Client MAR 1.4.8.18.3, Woods - Customizations */ 
	-- Old Comments deleted
/*  08/Jan/2018		Chethan N			What: Retrieving ClientMedicationId when Meds are from Rx. 
										Why : MHP-Support Go Live task #427
/*  18/Jan/2018     Gautam             What: Added code to check for Rx completion to return NotCompletedInRx 
									   Task#5.5,Renaissance - Dev Items							*/
	05/Apr/2018     Chethan N           What: Removed Active and RecordDeleted check of Orders table as MAR records should be populated on Group MAR even if Orders are deleted
										Why : AHN-Support Go Live task # 200
	05/Jun/2018		Gautam				What: Separated MAR details retrieving logic. MAR details for Client Orders are retrieved from Client Order related tables and MAR details for Client Medications are retrieved from Client Medication related tables.
					& Chethan N				and changed code to make compatible with SQL 2016.
			  							Why:  AHN Support GO live task #195				  							
	05/Apr/2018     Chethan N           What : Retrieving Client Medications and Client Orders on Group MAR which are active with past end date.
										Why : AHN-Support Go Live task # 271.	
	22/Jun/2018		Chethan N			What : Retrieving titration steps of the Client Medication to display in Client MAR.
										Why : Porter Starke-Customizations Task #11	
    25/Jul/2018     Gautam              What : Added code to make compatible with SQL 2016.	QA Deploy issue								
	26/Jul/2018		Chethan N			What : Retrieving Quantity in titration steps of the Client Medication to display on Group MAR.
										Why : Porter Starke-Customizations Task #11								
	31/Jul/2018		Chethan N			What : Added @StaffId parameter and StaffClients check.
										Why : Porter Starke-Customizations Task #11							
	04/Sep/2018		Chethan N			What : Retrieving discontinued Medications and Client Orders based on SystemConfigurationKeys 'MARShowDiscontinueMedsFromPastXDays'.
										Why : PEP - Support Go Live Task #38								
	11/Sep/2018		Chethan N			What : Retrieving Consent Required and Consent Obtained information.
										Why : StarCare - SmartCareIP Task #8								
	 29/Oct/2018	Chethan N			What : Removed StrengthUnitOfMeasure from Dispense History
										Why : AHN Support GO live Task #383								
	 06/Dec/2018	Chethan N			What : Pulling PRN ClientMedications to Group MAR.
										Why : Aspen Point Build Cycle Task #134									
	 04/Feb/2019	Chethan N			What : Changes to populate Override Meds.
										Why : AHN Support Go live Task #512	
	 22/Mar/2019	Gautam			    What : Added code to display Client Image based on SystemConfig Keys ShowClientImageOnGroupMARScreen
										Why : Screen was throwing Timeout error due Client image size,AHN-Support Go Live #511	*/	
	/*********************************************************************/
AS
BEGIN
	DECLARE @OverdueHours INT
	--To get Overdue hours from SystemConfigurationKeys                                 
	DECLARE @MinutesBeforeOverdue INT
	DECLARE @2XMinutesBeforeOverdue INT
	DECLARE @ShiftStartTimeTemp TIME(0)
	DECLARE @ShiftEndTimeTemp TIME(0)
	DECLARE @TimeFormatValue INT
	DECLARE @ShowAdministeredName VARCHAR(20)
	DECLARE @ShowDiscontinueMedsFromPastXDays INT
	DECLARE @COMPLETEORDERSTORX VARCHAR(1)
	DECLARE @ConsentDurationMonths INT
	DECLARE @MedConsentsRequireClientSignature VARCHAR(1)
	DECLARE @ShowClientImageOnMAR VARCHAR(5)

	BEGIN TRY
		SET @ShiftStartTimeTemp = DATEADD(MI, - 90, CAST(@ShiftTime AS TIME(0))) -- Display record 90 minutes before the slected time                            
		SET @ShiftEndTimeTemp = DATEADD(MI, 90, CAST(@ShiftTime AS TIME(0))) -- Display record 90 minutes after the slected time                            
		
		SELECT TOP 1 @ShowClientImageOnMAR = value
		FROM SystemConfigurationKeys
		WHERE [key] = 'ShowClientImageOnGroupMARScreen'
			AND isnull(RecordDeleted, 'N') = 'N'
			
		SELECT TOP 1 @TimeFormatValue = value
		FROM SystemConfigurationKeys
		WHERE [key] = 'MARTimeFormat'
			AND isnull(RecordDeleted, 'N') = 'N'

		SELECT TOP 1 @ShowAdministeredName = value
		FROM SystemConfigurationKeys
		WHERE [key] = 'MAR_ShowAdministeredName'
			AND isnull(RecordDeleted, 'N') = 'N'

		SELECT @OverdueHours = Value
		FROM SystemConfigurationKeys
		WHERE [Key] = 'MARoverdueLookbackHours'
			AND (ISNULL(RecordDeleted, 'N') = 'N')

		SELECT @MinutesBeforeOverdue = Value
		FROM SystemConfigurationKeys
		WHERE [Key] = 'MARMinutesBeforeOverdue'
			AND (ISNULL(RecordDeleted, 'N') = 'N')

		SELECT @ShowDiscontinueMedsFromPastXDays = Value
		FROM SystemConfigurationKeys
		WHERE [Key] = 'MARShowDiscontinueMedsFromPastXDays'
			AND (ISNULL(RecordDeleted, 'N') = 'N')

		SELECT @MinutesBeforeOverdue = CASE 
				WHEN ISNULL(@MinutesBeforeOverdue, 0) = 0
					THEN 60
				ELSE @MinutesBeforeOverdue
				END

		SELECT @2XMinutesBeforeOverdue = Value
		FROM SystemConfigurationKeys
		WHERE [Key] = 'MARMinutes2XBeforeOverdue'
			AND (ISNULL(RecordDeleted, 'N') = 'N')

		SELECT @2XMinutesBeforeOverdue = CASE 
				WHEN ISNULL(@2XMinutesBeforeOverdue, 0) = 0
					THEN 60
				ELSE @2XMinutesBeforeOverdue
				END
		

		SELECT @COMPLETEORDERSTORX = ISNULL(SCK.[Value], 'N')
		FROM SystemConfigurationKeys SCK
		WHERE SCK.[Key] = 'COMPLETEORDERSTORX'
	
		SELECT @MedConsentsRequireClientSignature = ISNULL(MedConsentsRequireClientSignature, 'N'),
			   @ConsentDurationMonths = ISNULL(ConsentDurationMonths, 12)
		FROM SystemConfigurations
		                  
		CREATE TABLE #ListOverdueMedication (
			MedAdminRecordId INT
			,OrderName VARCHAR(500)
			,DueDate VARCHAR(10)
			,DueTime VARCHAR(5)
			,OverdueSchedule VARCHAR(MAX)
			,OrderType VARCHAR(50)
			,ClientId INT
			)

		CREATE TABLE #ClientDetails (
			ClientId INT
			,ClientName VARCHAR(200)
			,DOB DATE
			,Allergies VARCHAR(max)
			,OverDueMedication VARCHAR(max)
			,HasRefused VARCHAR(1)
			,RefusedInfo VARCHAR(max)
			)

		CREATE TABLE #ClientMedication (
			ClientId INT
			,ClientMedicationId INT
			,MedAdminRecordId INT
			,ClientOrderId INT
			,MedicationName VARCHAR(500)
			,Directions VARCHAR(500)
			,SpecialInstructions VARCHAR(max)
			,NeedsDualSignature VARCHAR(1)
			,CanSelfAdminister VARCHAR(1)
			,HasRefused VARCHAR(1)
			,IsPRN VARCHAR(1)
			,IsDiscontinued VARCHAR(1)
			,MedicationStatus VARCHAR(500)
			,DisplayOrder INT
			,MedicineRouteOtherInformation VARCHAR(max)
			,DispenseHistory24 VARCHAR(max)
			,DisableDispense VARCHAR(1)
			,ConsentIsRequired CHAR(1)
			,IsDiscontinuedOrCompleted CHAR(1)
			,AcknowedgePending CHAR(1)
			,Strength VARCHAR(25)
			,StrengthUnitOfMeasure VARCHAR(25)
			,NotCompletedInRx CHAR(1)-- 18/Jan/2018  Gautam 
			,IsRxSource CHAR(1)
			,IsPastDateRecords CHAR(1)
			,TitrationSteps VARCHAR(max)
			,ClientMedicationInstructionId INT
			,Prescribed CHAR(1)
			)
		
		CREATE TABLE #Titrations (
			ClientMedicationInstructionId INT
			,ClientMedicationId INT
			,TitrationStepNumber VARCHAR(5)
			,StartDate DATETIME
			,EndDate DATETIME
			,[Days] INT
			,DosageFormAbbreviation VARCHAR(10)
			,Strength VARCHAR(25)
			,StrengthUnitOfMeasure VARCHAR(25)
			,StepRank BIGINT
			,Quantity  VARCHAR(10)
			)

		INSERT INTO #ClientMedication
		SELECT DISTINCT CM.ClientId
				,MA.ClientMedicationId
				,MA.MedAdminRecordId
				,MA.ClientOrderId
				,'(' + MN.MedicationName + ')' AS MedicationName
				,MDR.RouteAbbreviation AS 'Directions'
				,CM.SpecialInstructions AS 'SpecialInstructions'
				,'N' AS NeedsDualSignature
				,'N' AS CanSelfAdminister
				,'N' AS HasRefused
				,CASE 
					WHEN CMI.Schedule IN (
							4866
							,50488
							,50510
							)
						THEN 'Y'
					ELSE 'N'
					END AS 'IsPRN'
				,CASE 
					WHEN isnull(CM.Discontinued, 'N') = 'Y'
						THEN 'Y'
					ELSE 'N'
					END AS 'IsDiscontinued'	
					,CASE 
				WHEN GC.CodeName IS NOT NULL
					THEN GC.CodeName + '<br/>' + CONVERT(VARCHAR(10), MA.AdministeredDate, 101) + '<br/>' + CASE @TimeFormatValue
							WHEN 12
								THEN CONVERT(VARCHAR(8), MA.AdministeredTime, 100)
							ELSE SUBSTRING(CONVERT(VARCHAR(8), MA.AdministeredTime, 108), 1, 5)
							END + CASE 
							WHEN @ShowAdministeredName = 'Y'
								THEN '<br/>' + ISNULL(S.LastName, '') +  ISNULL(',' + S.FirstName, '')
							ELSE ''
							END
				ELSE ''
				END AS MedicationStatus	
				,CASE 
				WHEN CMI.Schedule IN (
							4866
							,50488
							,50510
							)
					THEN 2
				ELSE 1
				END AS 'DisplayOrder'
				,'<b>Sig</b>: ' +ISNULL(convert(VARCHAR(15), CMI.Quantity), '') + ' ' + ISNULL(GC3.CodeName, '') + ' ' + ISNULL(GC1.CodeName, '') + CASE 
								WHEN ISNULL(OTF.IsPRN, 'N') = 'Y'
									THEN ' (PRN)'
								ELSE ''
								END
				+ '<br/> <b>Note to Pharmacy:</b> ' + CASE 
					WHEN ISNULL(CM.IncludeCommentOnPrescription, 'N') = 'Y'
						THEN ISNULL(CM.Comments, '')
					ELSE ''
					END AS MedicineRouteOtherInformation	
				,'' AS 'DispenseHistory24'
				,'Y' AS 'DisableDispense'
				,'N' AS ConsentIsRequired 
				,CASE 
					WHEN isnull(CM.Discontinued, 'N') = 'Y'
						THEN 'Y'
					ELSE 'N'
					END AS 'IsDiscontinuedOrCompleted'
				,'N' As AcknowedgePending
				,ISNULL(MM.Strength, '') AS Strength
				,ISNULL(MM.StrengthUnitOfMeasure, '') AS StrengthUnitOfMeasure
				,'N' AS NotCompletedInRx
				,'Y' AS IsRxSource
				,'N' AS IsPastDateRecords
				,'' AS TitrationSteps
				,MA.ClientMedicationInstructionId
				,ISNULL(CM.Ordered, 'N') AS Prescribed
			FROM MedAdminRecords AS MA
			INNER JOIN ClientMedications AS CM ON MA.ClientMedicationId = CM.ClientMedicationId
				AND ISNULL(CM.RecordDeleted, 'N') = 'N'
				AND (ISNULL(MA.RecordDeleted, 'N') = 'N')
				AND ISNULL(CM.SmartCareOrderEntry, 'N') = 'N'
			INNER JOIN ClientMedicationInstructions AS CMI ON MA.ClientMedicationInstructionId = CMI.ClientMedicationInstructionId
				AND ISNULL(CMI.RecordDeleted, 'N') = 'N'
			INNER JOIN Clients AS C ON C.ClientId = CM.ClientId
				AND ISNULL(C.RecordDeleted, 'N') = 'N'
			JOIN StaffClients SC ON SC.ClientId = C.ClientId AND SC.StaffId = @StaffId
			INNER JOIN MDMedicationNames MN ON CM.MedicationNameId = MN.MedicationNameId
				AND ISNULL(MN.RecordDeleted, 'N') = 'N'
			LEFT JOIN GlobalCodes AS GC ON GC.GlobalCodeId = MA.STATUS
				AND ISNULL(GC.RecordDeleted, 'N') = 'N'
			INNER JOIN GlobalCodes AS GC1 ON GC1.GlobalCodeId = CMI.Schedule
				AND ISNULL(GC1.RecordDeleted, 'N') = 'N'
			INNER JOIN OrderTemplateFrequencies OTF ON OTF.RxFrequencyId = CMI.Schedule
				AND ISNULL(OTF.RecordDeleted, 'N') = 'N'
			LEFT JOIN Staff AS S ON S.StaffId = MA.AdministeredBy
				AND ISNULL(S.RecordDeleted, 'N') = 'N'
			INNER JOIN MdMedications MM ON CMI.StrengthId = MM.MedicationId
				AND ISNULL(MM.RecordDeleted, 'N') = 'N' --and MM.Status =4881 --select * from GlobalCodes where GlobalCodeId in (4882,4881,4884)  
			LEFT JOIN MDRoutes AS MDR ON MDR.RouteId = MM.RouteId
				AND ISNULL(MDR.RecordDeleted, 'N') = 'N'
			LEFT JOIN GlobalCodes AS GC3 ON GC3.GlobalCodeId = CMI.Unit
				AND ISNULL(GC3.RecordDeleted, 'N') = 'N'
			JOIN ClientPrograms CP ON CP.ClientId = CM.ClientId
				AND ISNULL(CP.RecordDeleted, 'N') = 'N' AND ISNULL(CP.Status, 5) IN (1,4)
			AND (ISNULL(CP.RequestedDate, CP.EnrolledDate) <= @ShiftDate AND ISNULL(DischargedDate, @ShiftDate) >= @ShiftDate) 
			JOIN Programs P ON P.ProgramId = CP.ProgramId
			AND (ISNULL(MARClientOrderMedication, 'N')= 'Y' OR ISNULL(MARPrescribedMedication, 'N')= 'Y' OR ISNULL(MARNonOrderedMedication, 'N')= 'Y') 
			LEFT JOIN ClientInpatientVisits CIV ON CIV.ClientId = CM.ClientId
				AND ISNULL(CIV.RecordDeleted, 'N') = 'N'
			LEFT JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CIV.ClientInpatientVisitId
				AND ISNULL(BA.RecordDeleted, 'N') = 'N'
			LEFT JOIN Beds B ON BA.BedId = B.BedId
				AND ISNULL(B.RecordDeleted, 'N') = 'N'
			LEFT JOIN Rooms R ON B.RoomId = R.RoomId
				AND ISNULL(R.RecordDeleted, 'N') = 'N'
			LEFT JOIN Units U ON R.UnitId = U.UnitId
				AND ISNULL(U.RecordDeleted, 'N') = 'N'
			LEFT JOIN ClientOrders CO ON CO.ClientOrderId = MA.ClientOrderId
			WHERE MA.ScheduledDate = @ShiftDate
			AND (
				ISNULL(@ProgramId, 0) = 0
				OR CP.ProgramId = @ProgramId
				)
			AND  ISNULL(OTF.IsDefault, 'N') = 'Y'
			AND (
				ISNULL(@UnitId, 0) = 0
				OR R.UnitId = @UnitId
				)
			AND (
				(
					MA.ScheduledTime IS NULL
					AND (  CMI.Schedule IN (  
						   4866  
						   ,50488  
						   ,50510  
						   )  
						 ) 
			-- Chethan N -- Dec/06/2018
						 OR EXISTS(SELECT 1 FROM OrderTemplateFrequencies OTF WHERE OTF.OrderTemplateFrequencyId = CO.OrderTemplateFrequencyId AND ISNULL(OTF.IsPRN, 'N') = 'Y' )
						 )
				OR (
					MA.ScheduledTime >= @ShiftStartTimeTemp
					AND MA.ScheduledTime <= @ShiftEndTimeTemp
					)
				)
				AND (ISNULL(CM.Discontinued, 'N') <> @Active)
			-- Chethan N -- Sep/04/2018
				AND (
						(
						ISNULL(CM.RecordDeleted, 'N') = 'N'
						AND CM.DiscontinueDate IS NULL
						)
					OR -- To display Discontinue order till next @ShowDiscontinueMedsFromPastXDays day(s)
						(
						ISNULL(CM.Discontinued, 'N') = 'Y'
						AND DATEDIFF(D, CM.DiscontinueDate, @ShiftDate) <= ISNULL(@ShowDiscontinueMedsFromPastXDays, 1)
						)
					)
	 	
		UNION ALL
		SELECT DISTINCT CO.ClientId
			,MA.ClientMedicationId
			,MA.MedAdminRecordId
			,MA.ClientOrderId
			,O.OrderName AS MedicationName     
			,MDR.RouteAbbreviation AS 'Directions'
			,CO.CommentsText AS 'SpecialInstructions'
			,ISNULL(O.DualSignRequired, 'N') AS NeedsDualSignature
			,ISNULL(CO.MaySelfAdminister, 'N') AS CanSelfAdminister
			,CASE 
				WHEN GC.CodeName = 'Refused'
					THEN 'Y'
				ELSE 'N'
				END AS HasRefused
			,CASE 
				WHEN ISNULL(CO.IsPRN, 'N') = 'Y'
					THEN 'Y'
				ELSE 'N'
				END AS 'IsPRN'
			,CASE 
				WHEN CO.OrderStatus = 6510 --Discontinued            
					THEN 'Y'
				ELSE 'N'
				END AS 'IsDiscontinued'
			,CASE 
				WHEN GC.CodeName IS NOT NULL
					THEN GC.CodeName + '<br/>' + CONVERT(VARCHAR(10), MA.AdministeredDate, 101) + '<br/>' + CASE @TimeFormatValue
							WHEN 12
								THEN CONVERT(VARCHAR(8), MA.AdministeredTime, 100)
							ELSE SUBSTRING(CONVERT(VARCHAR(8), MA.AdministeredTime, 108), 1, 5)
							END + CASE 
							WHEN @ShowAdministeredName = 'Y'
								THEN '<br/>' + + ISNULL(S1.LastName, '') +  ISNULL(',' + S1.FirstName, '')
							ELSE ''
							END
				ELSE ''
				END AS MedicationStatus
			,CASE 
				WHEN ISNULL(CO.IsPRN, 'N') = 'Y'
					THEN 2
				WHEN CO.OrderStatus = 6508
					THEN 3
				WHEN CO.OrderStatus = 6510
					THEN 4
				ELSE 1
				END AS 'DisplayOrder'
				,CASE 
					WHEN O.OrderType = 8501
						THEN CASE 
								WHEN IM.ClientOrderId IS NULL
									THEN '<b>Sig</b>: ' +ISNULL(convert(VARCHAR(15), CO.MedicationDosage), '') + ' ' + ISNULL(GC3.CodeName, '') + ' ' + ISNULL(GC1.CodeName, '') + CASE 
											WHEN ISNULL(CO.IsPRN, 'N') = 'Y'
												THEN ' (PRN)'
											ELSE ''
											END + CASE 
											WHEN ISNULL(CO.MaxDispense, 'a') <> 'a'
												THEN '<br/><span style=''color:red''>Max Allowed In 24 Hours:  ' + ISNULL(CO.MaxDispense, '') + '<br/>Admin In Last 24 Hours: ' + CASE 
														WHEN cast((
																	SELECT SUM(CASE 
																				WHEN ISNUMERIC(isnull(MA1.AdministeredDose, 'a')) = 1
																					THEN cast(MA1.AdministeredDose AS DECIMAL(10, 2))
																				ELSE 0
																				END)
																	FROM MedAdminRecords MA1
																	WHERE MA1.ClientOrderId = CO.ClientOrderId
																		AND (
																			ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS DATETIME)), 0) <= 24
																			AND (ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS DATETIME)), 0) >= 0
																				)
																			)
																	) AS VARCHAR(100)) = '0.00'
															THEN '0'
														WHEN right(cast((
																		SELECT SUM(CASE 
																					WHEN ISNUMERIC(isnull(MA1.AdministeredDose, 'a')) = 1
																						THEN cast(MA1.AdministeredDose AS DECIMAL(10, 2))
																					ELSE 0
																					END)
																		FROM MedAdminRecords MA1
																		WHERE MA1.ClientOrderId = CO.ClientOrderId
																			AND (
																				ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS DATETIME)), 0) <= 24
																				AND (
																					ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS DATETIME)), 0) >= 
																					0
																					)
																				)
																		) AS VARCHAR(100)), 3) = '.00'
															THEN substring(cast((
																			SELECT SUM(CASE 
																						WHEN ISNUMERIC(isnull(MA1.AdministeredDose, 'a')) = 1
																							THEN cast(MA1.AdministeredDose AS DECIMAL(10, 2))
																						ELSE 0
																						END)
																			FROM MedAdminRecords MA1
																			WHERE MA1.ClientOrderId = CO.ClientOrderId
																				AND (
																					ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS DATETIME)), 0) <= 
																					24
																					AND (
																						ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS DATETIME)), 
																							0) >= 0
																						)
																					)
																			) AS VARCHAR(100)), 1, len(cast((
																				SELECT SUM(CASE 
																							WHEN ISNUMERIC(isnull(MA1.AdministeredDose, 'a')) = 1
																								THEN cast(MA1.AdministeredDose AS DECIMAL(10, 2))
																							ELSE 0
																							END)
																				FROM MedAdminRecords MA1
																				WHERE MA1.ClientOrderId = CO.ClientOrderId
																					AND (
																						ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS DATETIME)), 
																							0) <= 24
																						AND (
																							ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS DATETIME)), 0) >= 0
																							)
																						)
																				) AS VARCHAR(100))) - 3) + ' ' + ISNULL(MM.StrengthUnitOfMeasure, '')
														ELSE cast((
																	SELECT SUM(CASE 
																				WHEN ISNUMERIC(isnull(MA1.AdministeredDose, 'a')) = 1
																					THEN cast(MA1.AdministeredDose AS DECIMAL(10, 2))
																				ELSE 0
																				END)
																	FROM MedAdminRecords MA1
																	WHERE MA1.ClientOrderId = CO.ClientOrderId
																		AND (
																			ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS DATETIME)), 0) <= 24
																			AND (ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS DATETIME)), 0) >= 0
																				)
																			)
																	) AS VARCHAR(100)) + ' ' + ISNULL(MM.StrengthUnitOfMeasure, '')
														END + '</span>'--'<img id="imgInfoMAR" style="float:right" src="../App_Themes/Includes/Images/redinfo.png" value="###DispenseHistory24###" />'
											ELSE ''
											END + '<br/><b>Rationale</b>: ' + CASE 
											WHEN ISNULL(CO.RationaleText, '') = 'Other'
												THEN ISNULL(CO.RationaleOtherText, '')
											ELSE ISNULL(CO.RationaleText, '')
											END
								ELSE '<b>Sig</b>: ' + ISNULL(IM.ProviderPharmacyInstructions, '') + ' ' + CASE 
										WHEN ISNULL(CO.IsPRN, 'N') = 'Y'
											THEN ' PRN'
										ELSE ''
										END + CASE 
										WHEN ISNULL(CO.MaxDispense, 'a') <> 'a'
											THEN '<br/><span style=''color:red''>Max Allowed In 24 Hours:  ' + ISNULL(CO.MaxDispense, '') + '<br/>Admin In Last 24 Hours: ' + CASE 
													WHEN cast((
																SELECT SUM(CASE 
																			WHEN ISNUMERIC(isnull(MA1.AdministeredDose, 'a')) = 1
																				THEN cast(MA1.AdministeredDose AS DECIMAL(10, 2))
																			ELSE 0
																			END)
																FROM MedAdminRecords MA1
																WHERE MA1.ClientOrderId = CO.ClientOrderId
																	AND (
																		ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS DATETIME)), 0) <= 24
																		AND (ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS DATETIME)), 0) >= 0
																			)
																		)
																) AS VARCHAR(100)) = '0.00'
														THEN '0'
													WHEN right(cast((
																	SELECT SUM(CASE 
																				WHEN ISNUMERIC(isnull(MA1.AdministeredDose, 'a')) = 1
																					THEN cast(MA1.AdministeredDose AS DECIMAL(10, 2))
																				ELSE 0
																				END)
																	FROM MedAdminRecords MA1
																	WHERE MA1.ClientOrderId = CO.ClientOrderId
																		AND (
																			ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS DATETIME)), 0) <= 24
																			AND (ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS DATETIME)), 0) >= 0
																				)
																			)
																	) AS VARCHAR(100)), 3) = '.00'
														THEN substring(cast((
																		SELECT SUM(CASE 
																					WHEN ISNUMERIC(isnull(MA1.AdministeredDose, 'a')) = 1
																						THEN cast(MA1.AdministeredDose AS DECIMAL(10, 2))
																					ELSE 0
																					END)
																		FROM MedAdminRecords MA1
																		WHERE MA1.ClientOrderId = CO.ClientOrderId
																			AND (
																				ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS DATETIME)), 0) <= 24
																				AND (
																					ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS DATETIME)), 0) >= 
																					0
																					)
																				)
																		) AS VARCHAR(100)), 1, len(cast((
																			SELECT SUM(CASE 
																						WHEN ISNUMERIC(isnull(MA1.AdministeredDose, 'a')) = 1
																							THEN cast(MA1.AdministeredDose AS DECIMAL(10, 2))
																						ELSE 0
																						END)
																			FROM MedAdminRecords MA1
																			WHERE MA1.ClientOrderId = CO.ClientOrderId
																				AND (
																					ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS DATETIME)), 0) <= 
																					24
																					AND (
																						ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS DATETIME)), 
																							0) >= 0
																						)
																					)
																			) AS VARCHAR(100))) - 3) + ' ' + ISNULL(MM.StrengthUnitOfMeasure, '')
													ELSE cast((
																SELECT SUM(CASE 
																			WHEN ISNUMERIC(isnull(MA1.AdministeredDose, 'a')) = 1
																				THEN cast(MA1.AdministeredDose AS DECIMAL(10, 2))
																			ELSE 0
																			END)
																FROM MedAdminRecords MA1
																WHERE MA1.ClientOrderId = CO.ClientOrderId
																	AND (
																		ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS DATETIME)), 0) <= 24
																		AND (ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS DATETIME)), 0) >= 0
																			)
																		)
																) AS VARCHAR(100)) + ' ' + ISNULL(MM.StrengthUnitOfMeasure, '')
													END + '</span>'--+ '</span><img id="imgInfoMAR" style="float:right" src="../App_Themes/Includes/Images/redinfo.png" value="###DispenseHistory24###" />'
										ELSE ''
										END + '<br/><b> Rationale</b>: ' + CASE 
										WHEN ISNULL(CO.RationaleText, '') = 'Other'
											THEN ISNULL(CO.RationaleOtherText, '')
										ELSE ISNULL(CO.RationaleText, '')
										END + ' ' + CASE 
										WHEN ISNULL(CO.IsPRN, 'N') = 'Y'
											THEN ' PRN'
										ELSE ''
										END
								END
					ELSE CO.CommentsText + CASE 
							WHEN ISNULL(CO.IsPRN, 'N') = 'Y'
								THEN ' PRN'
							ELSE ''
							END
					END AS MedicineRouteOtherInformation
			,'' AS 'DispenseHistory24'
			,'Y' AS 'DisableDispense'
			,ISNULL(CO.ConsentIsRequired, 'N') AS ConsentIsRequired
			,CASE 
				WHEN CO.OrderStatus = 6508
					THEN 'Y'
				ELSE CO.OrderDiscontinued
				END --  6508 Order Complete      
			AS 'IsDiscontinuedOrCompleted'
			,ISNULL(CO.OrderPendAcknowledge, 'N') AS AcknowedgePending
			,ISNULL(MM.Strength, '') AS Strength
			,ISNULL(MM.StrengthUnitOfMeasure, '') AS StrengthUnitOfMeasure
			,CASE 
				WHEN @COMPLETEORDERSTORX = 'N'
					THEN 'N'
				WHEN (ISNULL(CM.Ordered, 'N') = 'Y' and ISNULL(CM.SmartCareOrderEntry, 'N') = 'Y')
					THEN 'N'
				WHEN (ISNULL(CM.SmartCareOrderEntry, 'N') = 'N')
					THEN 'N'
				ELSE 'Y'
				END AS NotCompletedInRx
			,'N' AS IsRxSource
			,'N' AS IsPastDateRecords
			,'' AS TitrationSteps
			,MA.ClientMedicationInstructionId
			,'S' AS Prescribed
		FROM MedAdminRecords AS MA
		INNER JOIN ClientOrders AS CO ON MA.ClientOrderId = CO.ClientOrderId
		INNER JOIN Clients AS C ON C.ClientId = CO.ClientId
			AND ISNULL(C.RecordDeleted, 'N') = 'N'
		JOIN StaffClients SC ON SC.ClientId = C.ClientId AND SC.StaffId = @StaffId
		INNER JOIN Orders AS O ON CO.OrderId = O.OrderId
		JOIN ClientPrograms CP ON CP.ClientId = CO.ClientId
			AND ISNULL(CP.RecordDeleted, 'N') = 'N' AND ISNULL(CP.Status, 5) IN (1,4)
			AND (ISNULL(CP.RequestedDate, CP.EnrolledDate) <= @ShiftDate AND ISNULL(DischargedDate, @ShiftDate) >= @ShiftDate) 
		JOIN Programs P ON P.ProgramId = CP.ProgramId
			AND (ISNULL(MARClientOrderMedication, 'N')= 'Y' OR ISNULL(MARPrescribedMedication, 'N')= 'Y' OR ISNULL(MARNonOrderedMedication, 'N')= 'Y') 
		LEFT JOIN ClientInpatientVisits CIV ON CIV.ClientId = CO.ClientId
			AND ISNULL(CIV.RecordDeleted, 'N') = 'N'
		LEFT JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CIV.ClientInpatientVisitId
			AND ISNULL(BA.RecordDeleted, 'N') = 'N'
		LEFT JOIN Beds B ON BA.BedId = B.BedId
			AND ISNULL(B.RecordDeleted, 'N') = 'N'
		LEFT JOIN Rooms R ON B.RoomId = R.RoomId
			AND ISNULL(R.RecordDeleted, 'N') = 'N'
		LEFT JOIN Units U ON R.UnitId = U.UnitId
			AND ISNULL(U.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes AS GC ON GC.GlobalCodeId = MA.STATUS
			AND ISNULL(GC.RecordDeleted, 'N') = 'N'
		LEFT JOIN OrderTemplateFrequencies AS OTF ON OTF.OrderTemplateFrequencyId = CO.OrderTemplateFrequencyId
			AND ISNULL(OTF.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes AS GC1 ON GC1.GlobalCodeId = OTF.RxFrequencyId
			AND ISNULL(GC1.RecordDeleted, 'N') = 'N'
		INNER JOIN Staff AS S ON S.StaffId = CO.OrderedBy
			AND ISNULL(S.RecordDeleted, 'N') = 'N'
		LEFT JOIN MDMedicationNames MDM ON MDM.MedicationNameId = O.MedicationNameId
			AND ISNULL(MDM.RecordDeleted, 'N') = 'N'
		LEFT JOIN OrderRoutes AS ORT ON ORT.OrderRouteId = CO.MedicationOrderRouteId
			AND ISNULL(ORT.RecordDeleted, 'N') = 'N'
		LEFT JOIN MDRoutes AS MDR ON MDR.RouteId = ORT.RouteId
			AND ISNULL(ORT.RecordDeleted, 'N') = 'N'
		LEFT JOIN OrderStrengths AS OS ON CO.MedicationOrderStrengthId = OS.OrderStrengthId
			AND ISNULL(OS.RecordDeleted, 'N') = 'N'
		LEFT JOIN MdMedications MM ON MM.medicationId = OS.medicationId
			AND ISNULL(MM.RecordDeleted, 'N') = 'N'
		LEFT JOIN MDRoutedDosageFormMedications MDRF ON MDRF.RoutedDosageFormMedicationId = MM.RoutedDosageFormMedicationId
			AND ISNULL(MDRF.RecordDeleted, 'N') = 'N'
		LEFT JOIN MDDosageForms MDF ON MDF.DosageFormId = MDRF.DosageFormId
			AND ISNULL(MDF.RecordDeleted, 'N') = 'N'
		LEFT JOIN InboundMedications AS IM ON IM.ClientOrderId = CO.ClientOrderId
			AND ISNULL(IM.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes AS GC3 ON GC3.GlobalCodeId = OS.MedicationUnit
			AND ISNULL(GC3.RecordDeleted, 'N') = 'N'
		LEFT JOIN Staff AS S1 ON S1.StaffId = MA.AdministeredBy
			AND ISNULL(S1.RecordDeleted, 'N') = 'N'
		LEFT JOIN ClientMedications AS CM ON MA.ClientMedicationId = CM.ClientMedicationId
				AND ISNULL(CM.RecordDeleted, 'N') = 'N'
				and ISNULL(CM.SmartCareOrderEntry, 'N') = 'Y'
		WHERE MA.ScheduledDate = @ShiftDate
			AND (
				ISNULL(@ProgramId, 0) = 0
				OR CP.ProgramId = @ProgramId
				)
			AND (
				ISNULL(@UnitId, 0) = 0
				OR R.UnitId = @UnitId
				)
			AND (
				(
					MA.ScheduledTime IS NULL
					AND ISNULL(CO.IsPRN, 'N') = 'Y'
					)
				OR (
					MA.ScheduledTime >= @ShiftStartTimeTemp
					AND MA.ScheduledTime <= @ShiftEndTimeTemp
					)
				)
			AND (
					(
					ISNULL(CO.RecordDeleted, 'N') = 'N'
					AND CO.DiscontinuedDateTime IS NULL
					)
				OR -- To display Discontinue order till next @ShowDiscontinueMedsFromPastXDays day(s)             
					(
					ISNULL(CO.OrderDiscontinued, 'N') = 'Y'
					AND Datediff(D, CO.DiscontinuedDateTime, @ShiftDate) <= ISNULL(@ShowDiscontinueMedsFromPastXDays, 1)
					)
					
				)
				AND (ISNULL(CO.OrderDiscontinued, 'N') <> @Active)
				AND (NOT EXISTS( SELECT 1 FROM Recodes R JOIN RecodeCategories RC ON RC.CategoryName = 'RxOrder' 
										AND RC.RecodeCategoryId = R.RecodeCategoryId WHERE ISNULL(R.RecordDeleted, 'N') = 'N' 
										AND R.IntegerCodeId = O.OrderId ))
										
		--- Client Orders / Medication with Past End Date
		INSERT INTO #ClientMedication
		SELECT DISTINCT CM.ClientId
				,CM.ClientMedicationId
				,-CM.ClientMedicationId AS MedAdminRecordId
				,NULL AS ClientOrderId
				,'(' + MN.MedicationName + ')' AS MedicationName
				,MDR.RouteAbbreviation AS 'Directions'
				,CM.SpecialInstructions AS 'SpecialInstructions'
				,'N' AS NeedsDualSignature
				,'N' AS CanSelfAdminister
				,'N' AS HasRefused
				,CASE 
					WHEN CMI.Schedule IN (
							4866
							,50488
							,50510
							)
						THEN 'Y'
					ELSE 'N'
					END AS 'IsPRN'
				,CASE 
					WHEN isnull(CM.Discontinued, 'N') = 'Y'
						THEN 'Y'
					ELSE 'N'
					END AS 'IsDiscontinued'	
					,'' AS MedicationStatus	
				,5 AS 'DisplayOrder'
				,'<b>Sig</b>: ' +ISNULL(convert(VARCHAR(15), CMI.Quantity), '') + ' ' + ISNULL(GC3.CodeName, '') + ' ' + ISNULL(GC1.CodeName, '') + CASE 
								WHEN ISNULL(OTF.IsPRN, 'N') = 'Y'
									THEN ' (PRN)'
								ELSE ''
								END
				+ '<br/> <b>Note to Pharmacy:</b> ' + CASE 
					WHEN ISNULL(CM.IncludeCommentOnPrescription, 'N') = 'Y'
						THEN ISNULL(CM.Comments, '')
					ELSE ''
					END AS MedicineRouteOtherInformation	
				,'' AS 'DispenseHistory24'
				,'Y' AS 'DisableDispense'
				,'N' AS ConsentIsRequired 
				,CASE 
					WHEN isnull(CM.Discontinued, 'N') = 'Y'
						THEN 'Y'
					ELSE 'N'
					END AS 'IsDiscontinuedOrCompleted'
				,'N' As AcknowedgePending
				,ISNULL(MM.Strength, '') AS Strength
				,ISNULL(MM.StrengthUnitOfMeasure, '') AS StrengthUnitOfMeasure
				,'N' AS NotCompletedInRx
				,'Y' AS IsRxSource
				,'Y' AS IsPastDateRecords
				,'' AS TitrationSteps
				,NULL AS ClientMedicationInstructionId
				,ISNULL(CM.Ordered, 'N') AS Prescribed
			FROM  ClientMedications AS CM 
			INNER JOIN ClientMedicationInstructions AS CMI ON CM.ClientMedicationId = CMI.ClientMedicationId
				AND ISNULL(CMI.RecordDeleted, 'N') = 'N'
			INNER JOIN Clients AS C ON C.ClientId = CM.ClientId
				AND ISNULL(C.RecordDeleted, 'N') = 'N'
			INNER JOIN MDMedicationNames MN ON CM.MedicationNameId = MN.MedicationNameId
				AND ISNULL(MN.RecordDeleted, 'N') = 'N'
			INNER JOIN GlobalCodes AS GC1 ON GC1.GlobalCodeId = CMI.Schedule
				AND ISNULL(GC1.RecordDeleted, 'N') = 'N'
			INNER JOIN OrderTemplateFrequencies OTF ON OTF.RxFrequencyId = CMI.Schedule
				AND ISNULL(OTF.RecordDeleted, 'N') = 'N'
			INNER JOIN MdMedications MM ON CMI.StrengthId = MM.MedicationId
				AND ISNULL(MM.RecordDeleted, 'N') = 'N' --and MM.Status =4881 --select * from GlobalCodes where GlobalCodeId in (4882,4881,4884)  
			LEFT JOIN MDRoutes AS MDR ON MDR.RouteId = MM.RouteId
				AND ISNULL(MDR.RecordDeleted, 'N') = 'N'
			LEFT JOIN GlobalCodes AS GC3 ON GC3.GlobalCodeId = CMI.Unit
				AND ISNULL(GC3.RecordDeleted, 'N') = 'N'
			JOIN #ClientMedication TCM ON TCM.ClientId = CM.ClientId
			WHERE  ISNULL(CM.RecordDeleted, 'N') = 'N'
				AND ISNULL(CM.SmartCareOrderEntry, 'N') = 'N'
				AND ISNULL(CM.Discontinued, 'N') ='N'        
				AND  ISNULL(OTF.IsDefault, 'N') = 'Y'		
				AND (
						CM.MedicationEndDate IS NOT NULL
						AND CAST(CM.MedicationEndDate AS DATE) < CAST(@ShiftDate AS DATE)
					)
				AND EXISTS(SELECT 1 FROM MedAdminRecords MA 
							WHERE MA.ClientMedicationId = CM.ClientMedicationId
							AND (ISNULL(MA.RecordDeleted, 'N') = 'N'))
	 	
		UNION ALL
		SELECT DISTINCT CO.ClientId
			,COMR.ClientMedicationId
			,- CO.ClientOrderId AS MedAdminRecordId
			,CO.ClientOrderId
			,O.OrderName AS MedicationName      
			,MDR.RouteAbbreviation AS 'Directions'
			,CO.CommentsText AS 'SpecialInstructions'
			,ISNULL(O.DualSignRequired, 'N') AS NeedsDualSignature
			,ISNULL(CO.MaySelfAdminister, 'N') AS CanSelfAdminister
			,NULL AS HasRefused
			,NULL AS 'IsPRN'
			,NULL AS 'IsDiscontinued'
			,NULL AS MedicationStatus
			,5 AS 'DisplayOrder'
			,CASE 
				WHEN O.OrderType = 8501
					THEN CASE 
							WHEN IM.ClientOrderId IS NULL
								THEN '<b>Sig</b>: ' +ISNULL(convert(VARCHAR(15), CO.MedicationDosage), '') + ' ' + ISNULL(GC3.CodeName, '') + ' ' + ISNULL(GC1.CodeName, '') + CASE 
										WHEN ISNULL(CO.IsPRN, 'N') = 'Y'
											THEN ' (PRN)'
										ELSE ''
										END + CASE 
										WHEN ISNULL(CO.MaxDispense, 'a') <> 'a'
											THEN '<br/><span style=''color:red''>Max Allowed In 24 Hours:  ' + ISNULL(CO.MaxDispense, '') + '<br/>Admin In Last 24 Hours: ' + CASE 
													WHEN cast((
																SELECT SUM(CASE 
																			WHEN ISNUMERIC(isnull(MA1.AdministeredDose, 'a')) = 1
																				THEN cast(MA1.AdministeredDose AS DECIMAL(10, 2))
																			ELSE 0
																			END)
																FROM MedAdminRecords MA1
																WHERE MA1.ClientOrderId = CO.ClientOrderId
																	AND (
																		ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) +CAST( CAST(GETDATE() AS TIME(0)) AS DATETIME)), 0) <= 24
																		AND (ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0))AS DATETIME)), 0) >= 0
																			)
																		)
																) AS VARCHAR(100)) = '0.00'
														THEN '0'
													WHEN right(cast((
																	SELECT SUM(CASE 
																				WHEN ISNUMERIC(isnull(MA1.AdministeredDose, 'a')) = 1
																					THEN cast(MA1.AdministeredDose AS DECIMAL(10, 2))
																				ELSE 0
																				END)
																	FROM MedAdminRecords MA1
																	WHERE MA1.ClientOrderId = CO.ClientOrderId
																		AND (
																			ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS DATETIME)), 0) <= 24
																			AND (
																				ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS DATETIME)), 0) >= 
																				0
																				)
																			)
																	) AS VARCHAR(100)), 3) = '.00'
														THEN substring(cast((
																		SELECT SUM(CASE 
																					WHEN ISNUMERIC(isnull(MA1.AdministeredDose, 'a')) = 1
																						THEN cast(MA1.AdministeredDose AS DECIMAL(10, 2))
																					ELSE 0
																					END)
																		FROM MedAdminRecords MA1
																		WHERE MA1.ClientOrderId = CO.ClientOrderId
																			AND (
																				ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS DATETIME)), 0) <= 
																				24
																				AND (
																					ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS DATETIME)), 
																						0) >= 0
																					)
																				)
																		) AS VARCHAR(100)), 1, len(cast((
																			SELECT SUM(CASE 
																						WHEN ISNUMERIC(isnull(MA1.AdministeredDose, 'a')) = 1
																							THEN cast(MA1.AdministeredDose AS DECIMAL(10, 2))
																						ELSE 0
																						END)
																			FROM MedAdminRecords MA1
																			WHERE MA1.ClientOrderId = CO.ClientOrderId
																				AND (
																					ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS DATETIME)), 
																						0) <= 24
																					AND (
																						ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0
																									))AS DATETIME)), 0) >= 0
																						)
																					)
																			) AS VARCHAR(100))) - 3) + ' ' + ISNULL(MM.StrengthUnitOfMeasure, '')
													ELSE cast((
																SELECT SUM(CASE 
																			WHEN ISNUMERIC(isnull(MA1.AdministeredDose, 'a')) = 1
																				THEN cast(MA1.AdministeredDose AS DECIMAL(10, 2))
																			ELSE 0
																			END)
																FROM MedAdminRecords MA1
																WHERE MA1.ClientOrderId = CO.ClientOrderId
																	AND (
																		ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS DATETIME)), 0) <= 24
																		AND (ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS DATETIME)), 0) >= 0
																			)
																		)
																) AS VARCHAR(100)) + ' ' + ISNULL(MM.StrengthUnitOfMeasure, '')
													END + '</span>'--'<img id="imgInfoMAR" style="float:right" src="../App_Themes/Includes/Images/redinfo.png" value="###DispenseHistory24###" />'
										ELSE ''
										END + '<br/><b>Rationale</b>: ' + CASE 
										WHEN ISNULL(CO.RationaleText, '') = 'Other'
											THEN ISNULL(CO.RationaleOtherText, '')
										ELSE ISNULL(CO.RationaleText, '')
										END
							ELSE '<b>Sig</b>: ' + ISNULL(IM.ProviderPharmacyInstructions, '') + ' ' + CASE 
									WHEN ISNULL(CO.IsPRN, 'N') = 'Y'
										THEN ' PRN'
									ELSE ''
									END + CASE 
									WHEN ISNULL(CO.MaxDispense, 'a') <> 'a'
										THEN '<br/><span style="color:red">Max Allowed In 24 Hours:  ' + ISNULL(CO.MaxDispense, '') + '<br/>Admin In Last 24 Hours: ' + CASE 
												WHEN cast((
															SELECT SUM(CASE 
																		WHEN ISNUMERIC(isnull(MA1.AdministeredDose, 'a')) = 1
																			THEN cast(MA1.AdministeredDose AS DECIMAL(10, 2))
																		ELSE 0
																		END)
															FROM MedAdminRecords MA1
															WHERE MA1.ClientOrderId = CO.ClientOrderId
																AND (
																	ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS DATETIME)), 0) <= 24
																	AND (ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0))AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS DATETIME)), 0) >= 0
																		)
																	)
															) AS VARCHAR(100)) = '0.00'
													THEN '0'
												WHEN right(cast((
																SELECT SUM(CASE 
																			WHEN ISNUMERIC(isnull(MA1.AdministeredDose, 'a')) = 1
																				THEN cast(MA1.AdministeredDose AS DECIMAL(10, 2))
																			ELSE 0
																			END)
																FROM MedAdminRecords MA1
																WHERE MA1.ClientOrderId = CO.ClientOrderId
																	AND (
																		ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS DATETIME)), 0) <= 24
																		AND (ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS DATETIME)), 0) >= 0
																			)
																		)
																) AS VARCHAR(100)), 3) = '.00'
													THEN substring(cast((
																	SELECT SUM(CASE 
																				WHEN ISNUMERIC(isnull(MA1.AdministeredDose, 'a')) = 1
																					THEN cast(MA1.AdministeredDose AS DECIMAL(10, 2))
																				ELSE 0
																				END)
																	FROM MedAdminRecords MA1
																	WHERE MA1.ClientOrderId = CO.ClientOrderId
																		AND (
																			ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS DATETIME)), 0) <= 24
																			AND (
																				ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS DATETIME)), 0) >= 
																				0
																				)
																			)
																	) AS VARCHAR(100)), 1, len(cast((
																		SELECT SUM(CASE 
																					WHEN ISNUMERIC(isnull(MA1.AdministeredDose, 'a')) = 1
																						THEN cast(MA1.AdministeredDose AS DECIMAL(10, 2))
																					ELSE 0
																					END)
																		FROM MedAdminRecords MA1
																		WHERE MA1.ClientOrderId = CO.ClientOrderId
																			AND (
																				ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS DATETIME)), 0) <= 
																				24
																				AND (
																					ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS DATETIME)), 
																						0) >= 0
																					)
																				)
																		) AS VARCHAR(100))) - 3) + ' ' + ISNULL(MM.StrengthUnitOfMeasure, '')
												ELSE cast((
															SELECT SUM(CASE 
																		WHEN ISNUMERIC(isnull(MA1.AdministeredDose, 'a')) = 1
																			THEN cast(MA1.AdministeredDose AS DECIMAL(10, 2))
																		ELSE 0
																		END)
															FROM MedAdminRecords MA1
															WHERE MA1.ClientOrderId = CO.ClientOrderId
																AND (
																	ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS DATETIME)), 0) <= 24
																	AND (ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS DATETIME)), 0) >= 0
																		)
																	)
															) AS VARCHAR(100)) + ' ' + ISNULL(MM.StrengthUnitOfMeasure, '')
												END --+ '</span><img id="imgInfoMAR" style="float:right" src="../App_Themes/Includes/Images/redinfo.png" value="###DispenseHistory24###" />'
									ELSE ''
									END + '<br/><b> Rationale</b>: ' + CASE 
									WHEN ISNULL(CO.RationaleText, '') = 'Other'
										THEN ISNULL(CO.RationaleOtherText, '')
									ELSE ISNULL(CO.RationaleText, '')
									END + ' ' + CASE 
									WHEN ISNULL(CO.IsPRN, 'N') = 'Y'
										THEN ' PRN'
									ELSE ''
									END
							END
				ELSE CO.CommentsText + CASE 
						WHEN ISNULL(CO.IsPRN, 'N') = 'Y'
							THEN ' PRN'
						ELSE ''
						END
				END AS MedicineRouteOtherInformation
			,'' AS 'DispenseHistory24'
			,'Y' AS 'DisableDispense'
			,ISNULL(CO.ConsentIsRequired, 'N') AS ConsentIsRequired
			,CASE 
				WHEN CO.OrderStatus = 6508
					THEN 'Y'
				ELSE CO.OrderDiscontinued
				END --  6508 Order Complete      
			AS 'IsDiscontinuedOrCompleted'
			,ISNULL(CO.OrderPendAcknowledge, 'N') AS AcknowedgePending
			,ISNULL(MM.Strength, '') AS Strength
			,ISNULL(MM.StrengthUnitOfMeasure, '') AS StrengthUnitOfMeasure
			,CASE 
				WHEN @COMPLETEORDERSTORX = 'N'
					THEN 'N'
				WHEN (ISNULL(CM.Ordered, 'N') = 'Y' and ISNULL(CM.SmartCareOrderEntry, 'N') = 'Y')
					THEN 'N'
				WHEN (ISNULL(CM.SmartCareOrderEntry, 'N') = 'N')
					THEN 'N'
				ELSE 'Y'
				END AS NotCompletedInRx
			,'N' AS IsRxSource
			,'Y' AS IsPastDateRecords
			,'' AS TitrationSteps
			,NULL AS ClientMedicationInstructionId
			,'S' AS Prescribed
		FROM ClientOrders AS CO 
		JOIN ClientOrderMedicationReferences COMR ON COMR.ClientOrderId = CO.ClientOrderId
				AND ISNULL(COMR.IsActive, 'N') = 'Y'
		INNER JOIN Clients AS C ON C.ClientId = CO.ClientId
			AND ISNULL(C.RecordDeleted, 'N') = 'N'
		INNER JOIN Orders AS O ON CO.OrderId = O.OrderId
		LEFT JOIN OrderTemplateFrequencies AS OTF ON OTF.OrderTemplateFrequencyId = CO.OrderTemplateFrequencyId
			AND ISNULL(OTF.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes AS GC1 ON GC1.GlobalCodeId = OTF.RxFrequencyId
			AND ISNULL(GC1.RecordDeleted, 'N') = 'N'
		INNER JOIN Staff AS S ON S.StaffId = CO.OrderedBy
			AND ISNULL(S.RecordDeleted, 'N') = 'N'
		LEFT JOIN MDMedicationNames MDM ON MDM.MedicationNameId = O.MedicationNameId
			AND ISNULL(MDM.RecordDeleted, 'N') = 'N'
		LEFT JOIN OrderRoutes AS ORT ON ORT.OrderRouteId = CO.MedicationOrderRouteId
			AND ISNULL(ORT.RecordDeleted, 'N') = 'N'
		LEFT JOIN MDRoutes AS MDR ON MDR.RouteId = ORT.RouteId
			AND ISNULL(ORT.RecordDeleted, 'N') = 'N'
		LEFT JOIN OrderStrengths AS OS ON CO.MedicationOrderStrengthId = OS.OrderStrengthId
			AND ISNULL(OS.RecordDeleted, 'N') = 'N'
		LEFT JOIN MdMedications MM ON MM.medicationId = OS.medicationId
			AND ISNULL(MM.RecordDeleted, 'N') = 'N'
		LEFT JOIN MDRoutedDosageFormMedications MDRF ON MDRF.RoutedDosageFormMedicationId = MM.RoutedDosageFormMedicationId
			AND ISNULL(MDRF.RecordDeleted, 'N') = 'N'
		LEFT JOIN MDDosageForms MDF ON MDF.DosageFormId = MDRF.DosageFormId
			AND ISNULL(MDF.RecordDeleted, 'N') = 'N'
		LEFT JOIN InboundMedications AS IM ON IM.ClientOrderId = CO.ClientOrderId
			AND ISNULL(IM.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes AS GC3 ON GC3.GlobalCodeId = OS.MedicationUnit
			AND ISNULL(GC3.RecordDeleted, 'N') = 'N'
		LEFT JOIN ClientMedications AS CM ON COMR.ClientMedicationId = CM.ClientMedicationId
				AND ISNULL(CM.RecordDeleted, 'N') = 'N'
				and ISNULL(CM.SmartCareOrderEntry, 'N') = 'Y'
		JOIN #ClientMedication TCM ON TCM.ClientId = CO.ClientId
		WHERE EXISTS(SELECT 1 FROM MedAdminRecords MA 
							WHERE MA.ClientOrderId = CO.ClientOrderId
							AND (ISNULL(MA.RecordDeleted, 'N') = 'N'))
				AND ISNULL(CO.RecordDeleted, 'N') = 'N'
				AND ISNULL(CO.OrderDiscontinued, 'N') = 'N'
				AND (NOT EXISTS( SELECT 1 FROM Recodes R JOIN RecodeCategories RC ON RC.CategoryName = 'RxOrder' 
										AND RC.RecodeCategoryId = R.RecodeCategoryId WHERE ISNULL(R.RecordDeleted, 'N') = 'N' 
										AND R.IntegerCodeId = O.OrderId ))
				AND (
					(
						CO.OrderEndDateTime IS NOT NULL
						AND CAST(CO.OrderEndDateTime AS DATE) < CAST(@ShiftDate AS DATE)
						)
					)


		INSERT INTO #ClientDetails (
			ClientId
			,ClientName
			,DOB
			)
		SELECT DISTINCT CM.ClientId
			,C.LastName + ', ' + C.FirstName
			,CONVERT(VARCHAR(10), C.DOB, 101) AS DOB
		FROM #ClientMedication CM
		INNER JOIN Clients C ON CM.ClientId = C.ClientId
		WHERE ISNULL(C.RecordDeleted, 'N') = 'N'
		
		UPDATE CD
		SET CD.Allergies = isnull(REPLACE(REPLACE(STUFF((
								SELECT DISTINCT ', ' + MDA.ConceptDescription + CASE 
								WHEN CA.Comment IS NOT NULL
									THEN ' - ' + SUBSTRING(CA.Comment, 0, 100)
								ELSE ''
								END 
								FROM MDAllergenConcepts MDA
								INNER JOIN ClientAllergies CA ON CA.AllergenConceptId = MDA.AllergenConceptId
								WHERE CA.ClientId = CD.ClientId
									AND ISNULL(CA.RecordDeleted, 'N') = 'N'
									AND ISNULL(MDA.RecordDeleted, 'N') = 'N'
									AND ISNULL(CA.Active, 'Y') = 'Y'
								FOR XML PATH('')
								), 1, 1, ''), '&lt;', '<'), '&gt;', '>'), '')
		FROM #ClientDetails CD
		
		UPDATE CD
		SET CD.Allergies =  'No Known Allergy' 
		FROM #ClientDetails CD
		JOIN Clients C ON C.ClientId = CD.ClientId AND ISNULL(C.NoKnownAllergies, '') = 'Y'

		UPDATE CD
		SET CD.HasRefused = CASE 
				WHEN EXISTS (
						SELECT 1
						FROM MedAdminRecords MA
						INNER JOIN ClientOrders AS CO ON MA.ClientOrderId = CO.ClientOrderId
							AND ISNULL(MA.RecordDeleted, 'N') = 'N'
							AND ISNULL(CO.RecordDeleted, 'N') = 'N'
						INNER JOIN GlobalCodes AS GC ON GC.GlobalCodeId = MA.STATUS
							AND ISNULL(GC.RecordDeleted, 'N') = 'N'
						WHERE CO.ClientId = CD.ClientId
							AND GC.CodeName = 'Refused'
							AND (ISNULL(DATEDIFF(ss, CAST(CAST(MA.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(@ShiftDate AS DATE) AS DATETIME) + CAST(CAST(@ShiftTime AS TIME(0)) AS DATETIME)), 0) >= 0)
							AND CAST(MA.AdministeredDate AS DATE) = CAST(@ShiftDate AS DATE)
						)
					THEN 'Y'
				ELSE 'N'
				END
		FROM #ClientDetails CD

		UPDATE CD
		SET CD.RefusedInfo = isnull(REPLACE(REPLACE((
							SELECT DISTINCT CONVERT(VARCHAR(10), CAST(MA.AdministeredDate AS DATE), 101) + '  ' + CASE @TimeFormatValue
									WHEN 12
										THEN CONVERT(VARCHAR(8), MA.AdministeredTime, 100)
									ELSE SUBSTRING(CONVERT(VARCHAR(8), MA.AdministeredTime, 108), 1, 5)
									END + ' - ' + O.OrderName + ' ' + isnull(MM.Strength, '') + ' ' + isnull(MM.StrengthUnitOfMeasure, '') + CHAR(10)
							FROM MedAdminRecords MA
							INNER JOIN ClientOrders AS CO ON MA.ClientOrderId = CO.ClientOrderId
								AND ISNULL(MA.RecordDeleted, 'N') = 'N'
								AND ISNULL(CO.RecordDeleted, 'N') = 'N'
							INNER JOIN Orders AS O ON CO.OrderId = O.OrderId
								AND ISNULL(O.RecordDeleted, 'N') = 'N'
								AND ISNULL(O.Active, 'Y') = 'Y'
							INNER JOIN GlobalCodes AS GC ON GC.GlobalCodeId = MA.STATUS
								AND ISNULL(GC.RecordDeleted, 'N') = 'N'
							LEFT JOIN OrderStrengths AS OS ON CO.MedicationOrderStrengthId = OS.OrderStrengthId
								AND ISNULL(OS.RecordDeleted, 'N') = 'N'
							LEFT JOIN MdMedications MM ON MM.medicationId = OS.medicationId
								AND ISNULL(MM.RecordDeleted, 'N') = 'N'
							WHERE CO.ClientId = CD.ClientId
								AND GC.CodeName = 'Refused'
								AND (ISNULL(DATEDIFF(ss, CAST(CAST(MA.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(@ShiftDate AS DATE) AS DATETIME) + CAST(CAST(@ShiftTime AS TIME(0)) AS DATETIME)), 0) >= 0)
								AND CAST(MA.AdministeredDate AS DATE) = CAST(@ShiftDate AS DATE)
							FOR XML PATH('')
							), '&lt;', '<'), '&gt;', '>'), '')
		FROM #ClientDetails CD
		WHERE CD.HasRefused = 'Y'
		
		UPDATE CM
		SET CM.DispenseHistory24 = (
				isnull(REPLACE(REPLACE((
								SELECT DISTINCT CONVERT(VARCHAR(12), MA.AdministeredDate, 101) + ' ' + SUBSTRING(CONVERT(VARCHAR(8), MA.AdministeredTime, 108), 1, 5) + ' - ' + CASE 
										WHEN isnull(MA.AdministeredDose, '') = ''
											THEN ''
										ELSE ''
										END + CASE 
										WHEN GC.CodeName = 'Refused'
											THEN ' Refused'
												--WHEN GC.CodeName = 'Not Given (Not filled by Pharmacy)'                    
												-- THEN ' Not Given'                   
										ELSE cast(isnull(MA.AdministeredDose, '') AS VARCHAR) --+ ' ' + ISNULL(CM1.StrengthUnitOfMeasure, '')
										END + '<br/>'
								FROM #ClientMedication CM1
								INNER JOIN MedAdminRecords MA ON MA.ClientOrderId = CM1.ClientOrderId
									AND MA.AdministeredTime IS NOT NULL
								LEFT JOIN GlobalCodes AS GC ON GC.GlobalCodeId = MA.STATUS
									AND ISNULL(GC.RecordDeleted, 'N') = 'N'
								WHERE MA.ClientOrderId = CM.ClientOrderId
									AND (
										ISNULL(DATEDIFF(hh, CAST(CAST(MA.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS DATETIME)), 0) <= 24
										AND (ISNULL(DATEDIFF(hh, CAST(CAST(MA.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS DATETIME)), 0) >= 0
											)
										)
									AND ISNULL(MA.RecordDeleted, 'N') = 'N'
								FOR XML PATH('')
								), '&lt;', '<'), '&gt;', '>'), '')
				)
		FROM #ClientMedication CM
		INNER JOIN ClientOrders AS CO ON CM.ClientOrderId = CO.ClientOrderId
			AND (ISNULL(CO.RecordDeleted, 'N') = 'N')
		
		UPDATE CM
		SET CM.DispenseHistory24 = CASE 
				WHEN CM.DispenseHistory24 = '0.00'
					THEN '0'
				WHEN RIGHT(CM.DispenseHistory24, 3) = '.00'
					THEN CASE 
							WHEN SUBSTRING(CM.DispenseHistory24, 1, len(CM.DispenseHistory24) - 3) = '0'
								THEN SUBSTRING(CM.DispenseHistory24, 1, len(CM.DispenseHistory24) - 3)
							ELSE SUBSTRING(CM.DispenseHistory24, 1, len(CM.DispenseHistory24) - 3) --+ ' ' + ISNULL(CM.StrengthUnitOfMeasure, '')
							END
				WHEN RIGHT(CM.DispenseHistory24, 1) = '0'
					THEN SUBSTRING(CM.DispenseHistory24, 1, len(CM.DispenseHistory24) - 1) --+ ' ' + ISNULL(CM.StrengthUnitOfMeasure,'')              
				WHEN CM.DispenseHistory24 = '0'
					THEN CM.DispenseHistory24
				ELSE CM.DispenseHistory24 --+ ' ' + ISNULL(CM.StrengthUnitOfMeasure, '')
				END
		FROM #ClientMedication CM
		WHERE CM.DispenseHistory24 <> ''
		
		UPDATE CM
		SET CM.DispenseHistory24 = CM.DispenseHistory24 + 'Total: ' + cast((
					SELECT SUM(CASE 
								WHEN ISNUMERIC(isnull(MA1.AdministeredDose, 'a')) = 1
									THEN cast(MA1.AdministeredDose AS DECIMAL(10, 2)) -- issue here                      
								ELSE 0
								END)
					FROM MedAdminRecords MA1
					WHERE MA1.ClientOrderId = CM.ClientOrderId
						AND (
							ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0))AS DATETIME)), 0) <= 24
							AND (ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0))AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0))AS DATETIME)), 0) >= 0)
							)
					) AS VARCHAR(100))
		FROM #ClientMedication CM
		WHERE CM.DispenseHistory24 <> ''
				
		------ Consent Required 		
		UPDATE MAR
		SET MAR.ConsentIsRequired = 'S'
		FROM #ClientMedication MAR
		WHERE MAR.ConsentIsRequired = 'Y'
		AND MAR.IsPastDateRecords = 'N'
		AND MAR.IsDiscontinuedOrCompleted = 'N'
		AND	EXISTS (
				SELECT 1
				FROM ClientMedications CM
				JOIN ClientMedicationConsents CMC ON CMC.MedicationNameId = CM.MedicationNameId AND ISNULL(CMC.RecordDeleted, 'N') = 'N'
				JOIN ClientMedicationConsentDocuments AS CMCD ON CMCD.DocumentVersionId = CMC.DocumentVersionId AND ISNULL(CMCD.RecordDeleted, 'N') = 'N'
				JOIN DocumentVersions AS DV ON CMCD.DocumentVersionId = DV.DocumentVersionId AND ISNULL(DV.RecordDeleted, 'N') = 'N'
				JOIN Documents AS D ON D.DocumentId = DV.DocumentId AND ISNULL(D.RecordDeleted, 'N') = 'N'
					AND D.ClientId = MAR.ClientId
				WHERE MAR.ClientMedicationId = CM.ClientMedicationId
					--AND (ISNULL(CMC.ConsentEndDate, DATEADD(month, @ConsentDurationMonths, ISNULL(CMCD.ConsentStartDate, CONVERT(DATE, GETDATE(), 101)))) >= CONVERT(DATE, GETDATE(), 101))
				)
		

		-- Overdue Medications                               
		INSERT INTO #ListOverdueMedication
		SELECT MA.MedAdminRecordId
			,O.OrderName
			,CONVERT(VARCHAR(10), MA.ScheduledDate, 101) AS 'DueDate'
			,SUBSTRING(CONVERT(VARCHAR(8), MA.ScheduledTime, 108), 1, 5) AS 'DueTime'
			,('div_' + CONVERT(VARCHAR(15), CO.ClientOrderId) + '_' + SUBSTRING(convert(VARCHAR(10), cast(MA.ScheduledDate AS DATE), 103), 1, 2) + '_' + SUBSTRING(CONVERT(VARCHAR(8), MA.ScheduledTime, 108), 1, 2)) AS 'OverdueSchedule'
			,CO.OrderType
			,CO.ClientId
		FROM MedAdminRecords AS MA
		INNER JOIN ClientOrders AS CO ON MA.ClientOrderId = CO.ClientOrderId
			AND ISNULL(CO.RecordDeleted, 'N') = 'N'
			AND (ISNULL(MA.RecordDeleted, 'N') = 'N')
			AND isnull(CO.OrderDiscontinued, 'N') <> 'Y'
			AND ISNULL(CO.OrderPendAcknowledge, 'N') = 'N'
		INNER JOIN Clients AS C ON C.ClientId = CO.ClientId
			AND ISNULL(C.RecordDeleted, 'N') = 'N'
		INNER JOIN #ClientDetails CD ON CD.ClientId = CO.ClientId
		INNER JOIN Orders AS O ON CO.OrderId = O.OrderId
			AND ISNULL(O.RecordDeleted, 'N') = 'N'
			AND ISNULL(O.Active, 'Y') = 'Y'
		INNER JOIN OrderTemplateFrequencies AS OTF ON OTF.OrderTemplateFrequencyId = CO.OrderTemplateFrequencyId
			AND ISNULL(OTF.RecordDeleted, 'N') = 'N'
		INNER JOIN GlobalCodes AS GC1 ON GC1.GlobalCodeId = OTF.TimesPerDay
			AND ISNULL(GC1.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes AS GC2 ON GC2.GlobalCodeId = O.AdministrationTimeWindow
			AND ISNULL(GC2.RecordDeleted, 'N') = 'N'
		WHERE MA.ClientMedicationInstructionId IS NULL
			AND MA.Scheduledtime IS NOT NULL
			AND MA.AdministeredDate IS NULL
			AND (ISNULL(CO.ConsentIsRequired, 'N') = 'N' OR ISNULL(CO.ConsentIsRequired, 'N') = 'S')
			AND (
				DATEDIFF(mi, CAST(CAST(MA.ScheduledDate AS DATE) AS DATETIME) + CAST(CAST(MA.Scheduledtime AS TIME(0)) AS DATETIME), GETDATE()) >= CASE 
					WHEN ISNULL(GC2.CodeName, 0) = 0
						THEN 60
					ELSE GC2.CodeName
					END
				)
			AND ISNULL(DATEDIFF(hh, CAST(CAST(MA.ScheduledDate AS DATE) AS DATETIME) + CAST(CAST(MA.Scheduledtime AS TIME(0)) AS DATETIME), GETDATE()), 0) <= @OverdueHours
			--AND ISNULL(CO.IsPRN, 'N') <> 'Y'
		
		UNION
		
		SELECT MA.MedAdminRecordId
			,MN.MedicationName
			,CONVERT(VARCHAR(10), MA.ScheduledDate, 101) AS 'DueDate'
			,SUBSTRING(CONVERT(VARCHAR(8), MA.ScheduledTime, 108), 1, 5) AS 'DueTime'
			,('div_' + CONVERT(VARCHAR(15), CM.ClientMedicationId) + '_' + SUBSTRING(convert(VARCHAR(10), cast(MA.ScheduledDate AS DATE), 103), 1, 2) + '_' + SUBSTRING(CONVERT(VARCHAR(8), MA.ScheduledTime, 108), 1, 2)) AS 'OverdueSchedule'
			,'Medication'
			,CM.ClientId
		FROM MedAdminRecords AS MA
		INNER JOIN ClientMedications AS CM ON MA.ClientMedicationId = CM.ClientMedicationId
			AND ISNULL(CM.RecordDeleted, 'N') = 'N'
			AND (ISNULL(MA.RecordDeleted, 'N') = 'N')
			AND isnull(CM.Discontinued, 'N') <> 'Y'
			AND ISNULL(CM.SmartCareOrderEntry, 'N') = 'N' 
		INNER JOIN Clients AS C ON C.ClientId = CM.ClientId
			AND ISNULL(C.RecordDeleted, 'N') = 'N'
		INNER JOIN #ClientDetails CD ON CD.ClientId = CM.ClientId
		INNER JOIN MDMedicationNames MN ON CM.MedicationNameId = MN.MedicationNameId
			AND ISNULL(MN.RecordDeleted, 'N') = 'N'
		INNER JOIN ClientMedicationInstructions AS CMI ON CM.ClientMedicationId = CMI.ClientMedicationId
			AND ISNULL(CMI.RecordDeleted, 'N') = 'N'
		WHERE MA.AdministeredDate IS NULL
			AND MA.Scheduledtime IS NOT NULL
			AND DATEDIFF(mi, CAST(CAST(MA.ScheduledDate AS DATE) AS DATETIME) + CAST(CAST(MA.Scheduledtime AS TIME(0)) AS DATETIME), GETDATE()) >= @MinutesBeforeOverdue
			AND ISNULL(DATEDIFF(hh, CAST(CAST(MA.ScheduledDate AS DATE) AS DATETIME) + CAST(CAST(MA.Scheduledtime AS TIME(0)) AS DATETIME), GETDATE()), 0) <= @OverdueHours
			--AND CMI.Schedule NOT IN (
			--	4866
			--	,50488
			--	,50510
			--	)

		--select * from  #ListOverdueMedication 
				    
		-- Update DisableDispense  for Client Orders  
		UPDATE CM
		SET CM.DisableDispense = CASE 
				WHEN (
						(CM.ConsentIsRequired = 'N' OR CM.ConsentIsRequired = 'S')
						AND CM.IsDiscontinuedOrCompleted = 'N'
						AND CM.AcknowedgePending = 'N'
						AND CM.NeedsDualSignature = 'N'
						AND NOT EXISTS (
							SELECT 1
							FROM #ListOverdueMedication LO
							WHERE CM.MedAdminRecordId = LO.MedAdminRecordId
							)
						AND (
							DATEDIFF(mi, CAST(CAST(MA.ScheduledDate AS DATE) AS DATETIME) + CAST(CAST(MA.Scheduledtime AS TIME(0)) AS DATETIME), GETDATE()) <= CASE 
								WHEN ISNULL(GC2.CodeName, 0) = 0
									THEN 60
								ELSE GC2.CodeName
								END
							AND DATEDIFF(mi, GETDATE(), CAST(CAST(MA.ScheduledDate AS DATE) AS DATETIME) + CAST(CAST(MA.Scheduledtime AS TIME(0)) AS DATETIME)) <= CASE 
								WHEN ISNULL(GC2.CodeName, 0) = 0
									THEN 60
								ELSE GC2.CodeName
								END
							)
						)
					THEN 'N'
				ELSE 'Y'
				END
		FROM #ClientMedication CM
		INNER JOIN MedAdminRecords MA ON MA.MedAdminRecordId = CM.MedAdminRecordId
		INNER JOIN ClientOrders AS CO ON MA.ClientOrderId = CO.ClientOrderId
			AND ISNULL(CO.RecordDeleted, 'N') = 'N'
			AND (ISNULL(MA.RecordDeleted, 'N') = 'N')
			AND isnull(CO.OrderDiscontinued, 'N') <> 'Y'
			AND ISNULL(CO.OrderPendAcknowledge, 'N') = 'N'
		INNER JOIN Orders AS O ON CO.OrderId = O.OrderId
			AND ISNULL(O.RecordDeleted, 'N') = 'N'
			AND ISNULL(O.Active, 'Y') = 'Y'
		LEFT JOIN GlobalCodes AS GC2 ON GC2.GlobalCodeId = O.AdministrationTimeWindow
			AND ISNULL(GC2.RecordDeleted, 'N') = 'N'
		WHERE CM.IsPastDateRecords = 'N'

	-- Update DisableDispense for RX
		UPDATE CM
		SET CM.DisableDispense = CASE 
				WHEN (
						(CM.ConsentIsRequired = 'N' OR CM.ConsentIsRequired = 'S')
						AND CM.IsDiscontinuedOrCompleted = 'N'
						AND CM.AcknowedgePending = 'N'
						AND CM.NeedsDualSignature = 'N'
						AND NOT EXISTS (
							SELECT 1
							FROM #ListOverdueMedication LO
							WHERE CM.MedAdminRecordId = LO.MedAdminRecordId
							)
						AND (
							DATEDIFF(mi, CAST(CAST(MA.ScheduledDate AS DATE) AS DATETIME) + CAST(CAST(MA.Scheduledtime AS TIME(0))AS DATETIME), GETDATE()) <= 60
							AND DATEDIFF(mi, GETDATE(), CAST(CAST(MA.ScheduledDate AS DATE) AS DATETIME) + CAST(CAST(MA.Scheduledtime AS TIME(0))AS DATETIME)) <= 60
							)
						)
					THEN 'N'
				ELSE 'Y'
				END
		FROM #ClientMedication CM
		INNER JOIN MedAdminRecords MA ON MA.MedAdminRecordId = CM.MedAdminRecordId
		where CM.IsRxSource = 'Y' and (ISNULL(MA.RecordDeleted, 'N') = 'N')
				AND CM.IsPastDateRecords = 'N'
		
		----- Titration Steps
		INSERT INTO #Titrations
		SELECT CMI.ClientMedicationInstructionId
			,CMI.ClientMedicationId
			,CMI.TitrationStepNumber
			,CMSD.StartDate
			,CMSD.EndDate
			,CMSD.[Days]
			,MDF.DosageFormAbbreviation
			,ISNULL(MM.Strength, '') AS Strength
			,ISNULL(MM.StrengthUnitOfMeasure, '') AS StrengthUnitOfMeasure
			,RANK() OVER   
				(PARTITION BY CMI.TitrationStepNumber, CMI.ClientMedicationId ORDER BY CMI.ClientMedicationInstructionId) AS StepRank 
			,CMI.Quantity
		FROM ClientMedicationInstructions CMI
		JOIN ClientMedications CM ON CMI.ClientMedicationId = CM.ClientMedicationId
			AND isnull(CMI.Active, 'Y') = 'Y'
			AND isnull(CMI.RecordDeleted, 'N') = 'N'
			AND isnull(CM.RecordDeleted, 'N') = 'N'
			AND (ISNULL(CM.Discontinued, 'N') = 'N'
				OR CAST(CM.DiscontinueDate AS DATE) >  CAST(GETDATE() AS DATE))
		JOIN ClientMedicationScriptDrugs CMSD ON CMI.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId
			AND ISNULL(CMSD.RecordDeleted, 'N') = 'N'
		JOIN MdMedications MM ON CMI.StrengthId = MM.MedicationId
			AND ISNULL(MM.RecordDeleted, 'N') = 'N'
		JOIN MDRoutedDosageFormMedications MDRF ON MDRF.RoutedDosageFormMedicationId = MM.RoutedDosageFormMedicationId
			AND ISNULL(MDRF.RecordDeleted, 'N') = 'N'
		JOIN MDDosageForms MDF ON MDF.DosageFormId = MDRF.DosageFormId
			AND ISNULL(MDF.RecordDeleted, 'N') = 'N'
		WHERE CMI.TitrationStepNumber IS NOT NULL 
		AND EXISTS (SELECT 1 FROM #ClientMedication LMR 
					WHERE LMR.ClientMedicationId = CM.ClientMedicationId 
						AND ISNULL(LMR.IsRxSource, 'N') = 'Y')
		ORDER BY CMI.ClientMedicationInstructionId

		;WITH CTE
		AS (SELECT ROW_NUMBER() OVER (
					PARTITION BY TS.TitrationStepNumber, TS.ClientMedicationId ORDER BY TS.ClientMedicationInstructionId
					) AS Rn , *
			FROM #Titrations TS)
		UPDATE TS SET TS.TitrationStepNumber = TS.TitrationStepNumber + '.' + CAST(TS.StepRank AS VARCHAR(2))
		FROM #Titrations TS
		JOIN CTE T ON T.TitrationStepNumber = TS.TitrationStepNumber AND T.ClientMedicationId = TS.ClientMedicationId
		WHERE Rn > 1

		UPDATE LMAR
		SET TitrationSteps = REPLACE(REPLACE(STUFF((
							SELECT DISTINCT ' <b>Step ' + TS.TitrationStepNumber 
										+ '</b> ' + TS.Strength + ' '  + TS.StrengthUnitOfMeasure + ' ' + TS.DosageFormAbbreviation + ', ' + LMAR.Directions + ' ' + dbo.ssf_RemoveTrailingZeros(TS.Quantity) + '  '
										+ CAST(CONVERT(VARCHAR(8), TS.StartDate, 1) AS VARCHAR(10)) + ' - ' + CAST(CONVERT(VARCHAR(8), TS.EndDate, 1) AS VARCHAR(10)) 
										+ ' ('+ CAST([Days] AS VARCHAR(3)) + 
										CASE WHEN [Days] = 1 THEN ' Day)' 
											ELSE ' Days)'
											END + '</br>'
							FROM #Titrations TS
							WHERE LMAR.ClientMedicationId = TS.ClientMedicationId
							FOR XML PATH('')
							), 1, 1, ''), '&lt;', '<'), '&gt;', '>')
		FROM #ClientMedication LMAR
			
		--Update OverdueMedication    
		UPDATE CD
		SET CD.OverDueMedication = STUFF((
					SELECT CHAR(10) + OrderName + ' (' + DueDate + ', ' + DueTime + ')'
					FROM #ListOverdueMedication OM
					WHERE OM.ClientId = CD.ClientId
					FOR XML PATH('')
						,TYPE
					).value('.', 'NVARCHAR(MAX)'), 1, 1, '')
		FROM #ClientDetails CD
		
		
		SELECT CD.ClientId
			,CD.ClientName
			,CD.DOB
			,CD.Allergies
			,CD.OverDueMedication
			, case when @ShowClientImageOnMAR='Yes' then CP.Picture else NULL end AS ClientImage
			,CD.HasRefused
			,CD.RefusedInfo
		FROM #ClientDetails CD
		LEFT JOIN ClientPictures CP ON CD.ClientId = CP.ClientId
			AND ISNULL(CP.RecordDeleted, 'N') = 'N'
			AND CP.Active = 'Y'
		ORDER BY CD.ClientName, CD.ClientId

		SELECT ClientId
			,ClientMedicationId
			,MedAdminRecordId
			,case when IsRxSource='Y'
						then  ClientMedicationId else  ClientOrderId end AS ClientOrderId
			,MedicationName 
			,Strength + ' ' + StrengthUnitOfMeasure AS Directions
			,SpecialInstructions
			,NeedsDualSignature
			,CanSelfAdminister
			,HasRefused
			,IsPRN
			,IsDiscontinued
			,MedicationStatus
			,ISNULL(DispenseHistory24, '') AS DispenseHistory24
			,DisableDispense
			,ISNULL(MedicineRouteOtherInformation, '') AS MedicineRouteOtherInformation
			,NotCompletedInRx
			,IsPastDateRecords
			,ISNULL(TitrationSteps, '') AS TitrationSteps
			,ISNULL(ClientMedicationInstructionId, -1) AS ClientMedicationInstructionId
			,Prescribed
			,ConsentIsRequired
		FROM #ClientMedication
		WHERE MedicationName <> ''
		ORDER BY ClientId
			,DisplayOrder
    
		SELECT 0 AS PageNumber
			,0 AS NumberOfPages
			,ISNULL((
					SELECT COUNT(*)
					FROM #ClientDetails
					), 0) AS NumberOfRows

		--For other filter                                                      
		DECLARE @CustomFilters TABLE (MARId INT)
		DECLARE @CustomFiltersApplied CHAR(1)

		IF @OtherFilter > 10000
		BEGIN
			SET @CustomFiltersApplied = 'Y'

			INSERT INTO @CustomFilters (MARId)
			EXEC SCSP_SCGetMultiClientMARDetails @ShiftDate = @ShiftDate
				,@ShiftTime = @ShiftTime
				,@OtherFilter = @OtherFilter
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_SCGetMultiClientMARDetails') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + 
			CONVERT(VARCHAR, Error_state())

		RAISERROR (
				@Error
				,-- Message text.                 
				16
				,-- Severity.                 
				1 -- State.                 
				);
	END CATCH
END

