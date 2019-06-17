/****** Object:  StoredProcedure [dbo].[ssp_GetMARDetails]    Script Date: 06/27/2017 16:04:54 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetMARDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetMARDetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetMARDetails]    Script Date: 06/27/2017 16:04:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_GetMARDetails] @ClientId INT
	,@ShiftDate DATE
	,@ShiftStartTime VARCHAR(8)
	,@ShiftEndTime VARCHAR(8)
	,@Display VARCHAR(15)
	,
	--varchar(15),-- text (times per day)                   
	@SortBy VARCHAR(25)
	,-- text,                   
	@OtherFilter INT
	,@OrderType INT = - 1
	,@StaffId INT = NULL
	/*********************************************************************/
	/* Stored Procedure: dbo.ssp_GetMARDetails          */
	/* Creation Date: 25/07/2013                                           */
	/*                                                                       */
	/* Purpose: To display Mars detail                   
                                   */
	/*                                                                   */
	/* Input Parameters: @ClientId               */
	/*                                                                    */
	/* Output Parameters:                         */
	/*  set @ClientId =7                   
  set @ShiftDate ='2013-08-20'                   
  set @ShiftStartTime ='16:00'                   
  set  @ShiftEndTime ='23:00'                   
  set  @Display =''                   
  set  @SortBy ='Route'                                                                 */
	/*  exec ssp_GetMARDetails 2104726,'2018-09-26','00:00','07:00','All','Order date',null, -1, 13798          */
	/*                                                                                      */
	/*  Date                  Author                 Purpose                                */
	/* 25th July 2013         Gautam    Created                                         
	-- Old Comments deleted
	 18/Jan/2018  Gautam        What: Added code to check for Rx completion to return NotCompletedInRx ,Task#5.5,Renaissance - Dev Items
	 03/Apr/2018  Bibhu		    What: Changed Join to Left Join - ClientMedicationScripts as Non Prescribed Medication will not have Ordered Information
								Why : Journey - Environment Issues Tracking task #607
	 05/Apr/2018  Chethan N     What: Removed Active and RecordDeleted check of Orders table as MAR records should be populated on Client MAR even if Orders are deleted and Added Null check for Strength
								Why : AHN-Support Go Live task # 200			
	 16/Apr/2018  Chethan N     What: NotCompleteInRx should be marked as 'N' When SystemConfigurationKey "CompleteOrdersToRx" is 'N'
								Why : AHN-Support Go Live task # 223
	 03/May/2018  Gautam	    What: Separated MAR details retrieving logic. MAR details for Client Orders are retrieved from Client Order related tables and MAR details for Client Medications are retrieved from Client Medication related tables.
				  & Chethan N		 and changed code to make compatible with SQL 2016.
			  					Why:  AHN Support GO live task #195				
	 05/Jun/2018  Chethan N	    What : Retrieving Client Medications and Client Orders which are active with past end date.
								Why : AHN Support GO live Task #271				
	 22/Jun/2018  Chethan N	    What : Retrieving titration steps of the Client Medication to display in Client MAR.
								Why : Porter Starke-Customizations Task #11				
	 10/Jul/2018  Chethan N	    What : Retrieving Prescribed column -- S - SmartCare medication, Y - Rx Prescribed, N - Rx non Prescribed.
								Why : AspenPointe - Support Go Live Task #773.93.		
	 25/Jul/2018  Gautam        What : Added code to make compatible with SQL 2016.	QA Deploy issue							
	 26/Jul/2018  Chethan N	    What : Retrieving Quantity in titration steps of the Client Medication to display on Client MAR.
								Why : Porter Starke-Customizations Task #11								
	 04/Sep/2018  Chethan N	    What : Retrieving discontinued Medications and Client Orders based on SystemConfigurationKeys 'MARShowDiscontinueMedsFromPastXDays'.
								Why : PEP - Support Go Live Task #38								
	 11/Sep/2018  Chethan N	    What : Retrieving Consent Required and Consent Obtained information.
								Why : StarCare - SmartCareIP Task #8	
	 25/Sep/2018  Chethan N		What : 1. Retrieving OtherStrength = 'Y' - Client Order having Other Strength, 'N' - Client Order having defined Strength
									2. Retrieving OverrideMARDispenseTimes permission for the logged in staff.
								Why : CCC-Customizations task #74									
	 03/Oct/2018  Chethan N	    What : 1. Removed StrengthUnitOfMeasure from Dispense History
									2. Changes to reflect the Administered Date/Time when medications are dispensed outside Scheduled Date/Time.
								Why : AHN Support GO live Task #383									
	 29/Oct/2018  Chethan N	    What : Changed the Dispense History icon.
								Why : AHN Support GO live Task #378									
	 16/Jan/2019  Chethan N	    What : Added SmartCareOrderEntry check for ClientMedications table to exclude Medications created from Client Orders.
								Why : WestBridge - Support Go Live task #32								
	 04/Feb/2019  Chethan N	    What : Changes to populate Override Meds.
								Why : AHN Support Go live Task #512	*/	
	/*********************************************************************/
AS
BEGIN
	DECLARE @ShiftStartTimeTemp TIME(0)
	DECLARE @ShiftEndTimeTemp TIME(0)
	DECLARE @ShiftStartTimeNew TIME(0) = NULL
	DECLARE @ShiftEndTimeNew TIME(0) = NULL
	DECLARE @ShiftDateTemp DATE = NULL
	DECLARE @OverdueHours INT
	--To get Overdue hours from SystemConfigurationKeys                       
	DECLARE @MinutesBeforeOverdue INT
	DECLARE @2XMinutesBeforeOverdue INT
	DECLARE @MARDefaultAdministrationWindow INT
	DECLARE @MARStatusNotGiven INT
	DECLARE @MARStatusNotGivenGlobalcodeId INT
	DECLARE @COMPLETEORDERSTORX VARCHAR(1)
	DECLARE @ShowDiscontinueMedsFromPastXDays INT
	DECLARE @ConsentDurationMonths INT
	DECLARE @MedConsentsRequireClientSignature VARCHAR(1)
	DECLARE @PermissionTemplateId INT
	DECLARE @OverrideMARDispenseTime CHAR(1) 

	SELECT @COMPLETEORDERSTORX = ISNULL(SCK.[Value], 'N')
	FROM SystemConfigurationKeys SCK
	WHERE SCK.[Key] = 'COMPLETEORDERSTORX'
	
	SELECT @MedConsentsRequireClientSignature = ISNULL(MedConsentsRequireClientSignature, 'Y'),
		   @ConsentDurationMonths = ISNULL(ConsentDurationMonths, 12)
	FROM SystemConfigurations

	BEGIN TRY
		-- Update MAR ClientOrderId for RX Order where ClientOrderid is null    
		UPDATE MAR
		SET MAR.ClientOrderId = (
				SELECT TOP 1 MA.ClientOrderid
				FROM MedAdminRecords MA
				WHERE MA.ClientMedicationId = MAR.ClientMedicationId
					AND MA.ClientOrderid IS NOT NULL
				)
		FROM MedAdminRecords MAR
		WHERE MAR.ClientOrderId IS NULL
			AND (ISNULL(RecordDeleted, 'N') = 'N')
		
		
		-- Update MAR ClientMedicationId for SC Order where ClientMedicationId is null
			UPDATE MAR
			SET MAR.ClientMedicationId = CMR.ClientMedicationId
			FROM MedAdminRecords MAR
			JOIN ClientOrderMedicationReferences CMR ON CMR.ClientOrderId=MAR.ClientOrderId
			WHERE MAR.ClientMedicationId IS NULL
				AND (ISNULL(RecordDeleted, 'N') = 'N')

		-- Update the Not Given status for MAR Schedule based on "MARoverdueLookbackHours" System configurations                    
		EXEC [ssp_SCUpdateMARNotGivenStatus] @ClientId

		SELECT @OverdueHours = Value
		FROM SystemConfigurationKeys
		WHERE [Key] = 'MARoverdueLookbackHours'
			AND (ISNULL(RecordDeleted, 'N') = 'N')

		SELECT @MinutesBeforeOverdue = Value
		FROM SystemConfigurationKeys
		WHERE [Key] = 'MARMinutesBeforeOverdue'
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

		SELECT @MARDefaultAdministrationWindow = Value
		FROM SystemConfigurationKeys
		WHERE [Key] = 'MARDefaultAdministrationWindow'
			AND (ISNULL(RecordDeleted, 'N') = 'N')

		SELECT @ShowDiscontinueMedsFromPastXDays = Value
		FROM SystemConfigurationKeys
		WHERE [Key] = 'MARShowDiscontinueMedsFromPastXDays'
			AND (ISNULL(RecordDeleted, 'N') = 'N')

		SELECT @2XMinutesBeforeOverdue = CASE 
				WHEN ISNULL(@2XMinutesBeforeOverdue, 0) = 0
					THEN 60
				ELSE @2XMinutesBeforeOverdue
				END

		SELECT TOP 1 @MARStatusNotGivenGlobalcodeId = GlobalCodeId
		FROM GlobalCodes
		WHERE category = 'MARStatus'
			AND CodeName = 'Not Given (Not filled by Pharmacy)'
			AND ISNULL(RecordDeleted, 'N') = 'N'

		IF @ShiftEndTime = '00:00'
		BEGIN
			SET @ShiftEndTime = '23:59'
		END

		--set @ShiftDate=cast(@ShiftDate as date)                       
		--set @ClientId=7                       
		SET @ShiftStartTimeTemp = CAST(@ShiftStartTime AS TIME(0))
		SET @ShiftEndTimeTemp = CAST(@ShiftEndTime AS TIME(0))

		IF DATEDIFF(hh, @ShiftStartTimeTemp, @ShiftEndTimeTemp) < 0
		BEGIN
			SET @ShiftEndTimeTemp = '23:59:00'
			SET @ShiftStartTimeNew = '00:00:00'
			SET @ShiftEndTimeNew = @ShiftEndTimeTemp
			SET @ShiftDateTemp = DATEADD(d, 1, @ShiftDate)
		END

		SELECT TOP 1 @MARStatusNotGivenGlobalcodeId = GlobalCodeId
		FROM GlobalCodes
		WHERE category = 'MARStatus'
			AND CodeName = 'Not Given (Not filled by Pharmacy)'
			AND ISNULL(RecordDeleted, 'N') = 'N'

		-- Fill the MAR data from RX if not available in MAR                      
		-- Check the Key 'ShowRXMedInMAR' in SystemConfigurationKeys table to show data from RX into MAR                    
		IF 
			--(      
			--  SELECT Value      
			--  FROM SystemConfigurationKeys      
			--  WHERE [Key] = 'ShowRXMedInMAR'      
			--   AND (ISNULL(RecordDeleted, 'N') = 'N')      
			--  ) = 'Y'      
			-- AND     
			(
				@OrderType = - 1
				OR @OrderType = 8856
				)
		BEGIN
			EXEC [ssp_InsertRXMedToMAR] @ClientId
				,@ShiftDate
				,@ShiftDateTemp
		END

		--CREATE TABLE #ListAdministered (
		--	ClientOrderId INT
		--	,ScheduleCount INT
		--	,AdministeredCount INT
		--	)

		CREATE TABLE #ListOverdueMedication (
			MedAdminRecordId INT
			,OrderName VARCHAR(500)
			,DueDate VARCHAR(10)
			,DueTime VARCHAR(5)
			,OverdueSchedule VARCHAR(MAX)
			,OrderType VARCHAR(50)
			,ClientOrderId INT
			)

		CREATE TABLE #ListMedRecords (
			MedAdminRecordId INT
			,CreatedBy VARCHAR(30)
			,CreatedDate DATETIME
			,ModifiedBy VARCHAR(30)
			,ModifiedDate DATETIME
			,RecordDeleted CHAR(1)
			,DeletedDate DATETIME
			,DeletedBy VARCHAR(30)
			,ClientOrderId INT
			,ScheduledDate DATE
			,ScheduledTime TIME(0)
			,DualSignRequired CHAR(1)
			,AdministeredDate VARCHAR(10)
			,AdministeredTime VARCHAR(5)
			,AdministeredBy INT
			,[Status] INT
			,StatusText VARCHAR(150)
			,StatusCode VARCHAR(25)
			,AdministeredDose VARCHAR(25)
			,Comment TEXT
			,PRNReason TEXT
			,NotGivenReason TEXT
			,PainId INT
			,DualSignedbyStaffId INT
			,DualSignedDate DATETIME
			,OrigScheduledID INT
			,IsDiscontinuedOrCompleted CHAR(1)
			,MedicationType INT
			,ScheduleTooltip VARCHAR(max)
			,OrderStartDateTime DATETIME
			,CodeName VARCHAR(250)
			,OrderName VARCHAR(500)
			,MedicineAdditionalInformation VARCHAR(max)
			,
			--IsDispensedByRx               CHAR(1),                       
			SpecialInstructions VARCHAR(max)
			,MedicineRouteOtherInformation VARCHAR(max)
			,RouteAbbreviation VARCHAR(max)
			,Strength VARCHAR(25)
			,StrengthUnitOfMeasure VARCHAR(25)
			,MedicineDisplayAlternate VARCHAR(100)
			,IsPRN CHAR(1)
			,MedicationFrequency VARCHAR(50)
			,IsSelfAdministered CHAR(1)
			,RxFlag CHAR(1)
			,User2Comments TEXT
			,User2PRNReason TEXT
			,User2NotGivenReason TEXT
			,User2PainId INT
			,MedicationDosage VARCHAR(30)
			,MedicationUnit VARCHAR(30)
			,ClientMedicationId INT
			,AdministrationTimeWindow VARCHAR(30)
			,IsStockMedication CHAR(1)
			,MayUseOwnSupply CHAR(1)
			,AcknowedgePending CHAR(1)
			,MedicationNameId INT
			,RouteId VARCHAR(max)
			,ConsentIsRequired CHAR(1)
			,DispenseBrand CHAR(1)
			,NonMedicationOrders CHAR(1)
			,OrderId INT
			,IsQuestionsRequire CHAR(1)
			,HazardousMedication VARCHAR(100)
			--,AdministeredUnit VARCHAR(100)                    
			,NoOfDosageForm DECIMAL
			,DosageFormAbbreviation VARCHAR(100)
			--,AdministerInLast24Hours VARCHAR(100)                    
			,DispenseHistory24 VARCHAR(max)
			,InboundMedicationId INT
			,QnA VARCHAR(MAX)
			,NotCompletedInRx CHAR(1)-- 18/Jan/2018  Gautam 
			,IsRxSource CHAR(1)
			,IsPastDateRecords CHAR(1)
			,TitrationSteps VARCHAR(max)
			,ClientMedicationInstructionId INT
			,Prescribed CHAR(1)
			,OtherStrength CHAR(1)
			)

		CREATE TABLE #Questions (
			QId INT
			,ClientOrderId INT
			,MedAdminRecordId INT
			,Que VARCHAR(max)
			,ans VARCHAR(max)
			)

		CREATE TABLE #ClientAdministerTime (
			ClientOrderId INT
			,AdministerDate DATETIME
			,NextAdministeredDate DATETIME
			,ClientMedicationInstructionId INT
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

		INSERT INTO #ListMedRecords
		SELECT MedAdminRecordId
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedDate
			,DeletedBy
			,ClientOrderId
			,ScheduledDate
			,ScheduledTime
			,DualSignRequired
			,AdministeredDate
			,AdministeredTime
			,AdministeredBy
			,STATUS
			,StatusText
			,StatusCode
			,AdministeredDose
			,Comment
			,PRNReason
			,NotGivenReason
			,PainId
			,DualSignedbyStaffId
			,DualSignedDate
			,OrigScheduledID
			,IsDiscontinuedOrCompleted
			,MedicationType
			,ScheduleTooltip
			,OrderStartDateTime
			,CodeName
			,OrderName
			,MedicineAdditionalInformation
			,
			--IsDispensedByRx,                       
			SpecialInstructions
			,MedicineRouteOtherInformation
			,RouteAbbreviation
			,Strength
			,StrengthUnitOfMeasure
			,MedicationName
			,IsPRN
			,MedicationFrequency
			,IsSelfAdministered
			,RxFlag
			,--- RxFlag flag                      
			User2Comments
			,User2PRNReason
			,User2NotGivenReason
			,User2PainId
			,MedicationDosage
			,MedicationUnit
			,ClientMedicationId
			,AdministrationTimeWindow
			,IsStockMedication
			,MayUseOwnSupply
			,AcknowedgePending
			,MedicationNameId
			,RouteId
			,ConsentIsRequired
			,DispenseBrand
			,NonMedicationOrders
			,OrderId
			,IsQuestionsRequire
			,HazardousMedication
			--,AdministeredUnit                    
			,NoOfDosageForm
			,DosageFormAbbreviation
			--,AdministerInLast24Hours                     
			,DispenseHistory24
			,InboundMedicationId
			,QnA
			,NotCompletedInRx
			,IsRxSource
			,IsPastDateRecords
			,TitrationSteps
			,ClientMedicationInstructionId
			,Prescribed
			,OtherStrength
		FROM ( 
		-- MedAdmin Records for current Client Medications
			SELECT MA.MedAdminRecordId
				,MA.CreatedBy
				,MA.CreatedDate
				,MA.ModifiedBy
				,MA.ModifiedDate
				,MA.RecordDeleted
				,MA.DeletedDate
				,MA.DeletedBy
				,MA.ClientOrderId
				,MA.ScheduledDate
				,MA.ScheduledTime
				,'N' AS DualSignRequired
				,CONVERT(VARCHAR(10), MA.AdministeredDate, 101) AS AdministeredDate
				,CONVERT(VARCHAR(5), MA.AdministeredTime, 108) AS AdministeredTime
				,MA.AdministeredBy
				,MA.STATUS
				,GC.CodeName AS 'StatusText'
				,GC.ExternalCode1 AS 'StatusCode'
				,MA.AdministeredDose
				,MA.Comment
				,MA.PRNReason
				,MA.NotGivenReason
				,MA.PainId
				,MA.DualSignedbyStaffId
				,MA.DualSignedDate
				,MA.OrigScheduledID
				,CASE 
					WHEN isnull(CM.Discontinued, 'N') = 'Y'
						THEN 'Y'
					ELSE 'N'
					END AS 'IsDiscontinuedOrCompleted'
				,GC1.GlobalCodeId AS 'MedicationType'
				,C.LastName + ', ' + C.FirstName + '<br/>Drug: ' + MN.MedicationName + '<br/>Dose: ' + ISNULL(convert(VARCHAR(15), CMI.Quantity), '') + ' ' + ISNULL(GC3.CodeName, '') + '<br/>Route: ' + ISNULL(MDR.RouteAbbreviation, '') + ' <br/> Sig: ' 
				+ISNULL(convert(VARCHAR(15), CMI.Quantity), '') + ' ' + ISNULL(GC3.CodeName, '') + ' ' + ISNULL(GC1.CodeName, '') + CASE 
							WHEN ISNULL(OTF.IsPRN, 'N') = 'Y'
								THEN ' (PRN)'
							ELSE ''
					END AS ScheduleTooltip
				,CM.MedicationStartDate AS OrderStartDateTime
				,MDR.RouteAbbreviation AS CodeName
				,MN.MedicationName AS OrderName
				,CASE WHEN (ISNULL(CM.SmartCareOrderEntry, 'N') = 'Y' OR ISNULL(CM.Ordered, 'N') = 'Y') THEN
					'<div style="float:left">' + ISNULL(S.LastName, '') + ',' + ISNULL(S.FirstName, '') + '<br/><i> Ordered: </i> ' + CONVERT(VARCHAR(10), CM.MedicationStartDate, 101) + '@' + CONVERT(VARCHAR(5), CM.MedicationStartDate, 108) + '<br/><b>' + MN.MedicationName + '</b> - ' 
					+ ISNULL(convert(VARCHAR(15), CMI.Quantity), '') + ' ' + ISNULL(GC3.CodeName, '') + ' ' + ISNULL(GC1.CodeName, '') + '</div><div style="float:left;width:15px !important;">&nbsp;&nbsp;&nbsp</div>' + '<div style="display:table-cell">' + ISNULL(S.LastName, '') + ',' + 
					ISNULL(S.FirstName, '') + ' ' +
					case when CMS.ScriptCreationDate is not null then
					'<br/><i> Dispensed: </i> ' + CONVERT(VARCHAR(10), CAST(CMS.ScriptCreationDate AS DATETIME), 101) + '@' + CONVERT(VARCHAR(5), CAST(CMS.ScriptCreationDate AS DATETIME), 108) 
					else '<br/><i> Medication not completed in Rx </i> ' end
					 + '<br/><b>' + MN.MedicationName + '(' + MM.MedicationDescription + ')' + 
					'</b> - ' + '' + '</div>' 
				ELSE '' END AS 'MedicineAdditionalInformation'
				,
				--''                         
				--AS IsDispensedByRx,                         
				CM.SpecialInstructions AS 'SpecialInstructions'
				,'<b>Sig</b>: ' +ISNULL(convert(VARCHAR(15), CMI.Quantity), '') + ' ' + ISNULL(GC3.CodeName, '') + ' ' + ISNULL(GC1.CodeName, '') + CASE 
								WHEN ISNULL(OTF.IsPRN, 'N') = 'Y'
									THEN ' (PRN)'
								ELSE ''
								END
				--+ '<br/><b>Route:</b> ' + ISNULL(MDR.RouteAbbreviation, '') 
				
				+ '<br/> <b>Note to Pharmacy:</b> ' + CASE 
					WHEN ISNULL(CM.IncludeCommentOnPrescription, 'N') = 'Y'
						THEN ISNULL(CM.Comments, '')
					ELSE ''
					END AS MedicineRouteOtherInformation
				,MDR.RouteAbbreviation
				,ISNULL(MM.Strength, '') AS Strength
				,ISNULL(MM.StrengthUnitOfMeasure, '') AS StrengthUnitOfMeasure
				,'(' + MN.MedicationName + ')' AS MedicationName
				,ISNULL(OTF.IsPRN, 'N') AS 'IsPRN'
				,OTF.TimesPerDay AS 'MedicationFrequency'
				,--GC1.CodeName as 'MedicationFrequency'                      
				'N' AS IsSelfAdministered
				,'N' AS RxFlag
				,--- RxFlag flag                        
				MA.User2Comments
				,MA.User2PRNReason
				,MA.User2NotGivenReason
				,MA.User2PainId
				,CMI.Quantity AS 'MedicationDosage'
				,ISNULL(GC3.CodeName, '') AS 'MedicationUnit'
				,MA.ClientMedicationId
				,@MARDefaultAdministrationWindow AS 'AdministrationTimeWindow'
				,'N' AS IsStockMedication
				,'N' AS MayUseOwnSupply
				,'N' AS AcknowedgePending
				,CM.MedicationNameId AS MedicationNameId
				,MDR.RouteId
				,'N' AS ConsentIsRequired
				,'N' AS DispenseBrand
				,'N' AS NonMedicationOrders
				,NULL AS OrderId
				,'N' AS IsQuestionsRequire
				,'' as 'HazardousMedication'
				--,MA.AdministeredUnit                      
				,MA.NoOfDosageForm
				,ISNULL('# of ' + R.CodeName, 'N') AS DosageFormAbbreviation
				--,NULL AS AdministerInLast24Hours                       
				,NULL AS DispenseHistory24
				,NULL AS InboundMedicationId
				,'' AS QnA
				,'N' AS NotCompletedInRx
				,'Y' AS IsRxSource
				,'N' AS IsPastDateRecords
				,'' AS TitrationSteps
				,MA.ClientMedicationInstructionId
				,ISNULL(CM.Ordered, 'N') AS Prescribed
				,'N' AS OtherStrength
			FROM MedAdminRecords AS MA
			INNER JOIN ClientMedications AS CM ON MA.ClientMedicationId = CM.ClientMedicationId
				AND ISNULL(CM.RecordDeleted, 'N') = 'N'
				AND (ISNULL(MA.RecordDeleted, 'N') = 'N')
				and ISNULL(CM.SmartCareOrderEntry, 'N') = 'N'
			INNER JOIN ClientMedicationInstructions AS CMI ON MA.ClientMedicationInstructionId = CMI.ClientMedicationInstructionId
				AND ISNULL(CMI.RecordDeleted, 'N') = 'N'
				AND ISNULL(CMI.Active, 'Y') = 'Y'
			INNER JOIN ClientMedicationScriptDrugs CMSD ON CMI.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId
				AND isnull(CMSD.RecordDeleted, 'N') = 'N'
			LEFT JOIN ClientMedicationScripts CMS ON CMS.ClientMedicationScriptId = CMSD.ClientMedicationScriptId--03/Apr/2018  Bibhu
				AND isnull(CMS.RecordDeleted, 'N') = 'N'
			INNER JOIN Clients AS C ON C.ClientId = CM.ClientId
				AND ISNULL(C.RecordDeleted, 'N') = 'N'
			INNER JOIN MDMedicationNames MN ON CM.MedicationNameId = MN.MedicationNameId
				AND ISNULL(MN.RecordDeleted, 'N') = 'N'
			INNER JOIN OrderTemplateFrequencies OTF ON OTF.RxFrequencyId = CMI.Schedule
				AND ISNULL(OTF.RecordDeleted, 'N') = 'N'
			LEFT JOIN GlobalCodes AS GC ON GC.GlobalCodeId = MA.STATUS
				AND ISNULL(GC.RecordDeleted, 'N') = 'N'
			INNER JOIN GlobalCodes AS GC1 ON GC1.GlobalCodeId = CMI.Schedule
				AND ISNULL(GC1.RecordDeleted, 'N') = 'N'
			LEFT JOIN Staff AS S ON S.StaffId = CM.PrescriberId
				AND ISNULL(S.RecordDeleted, 'N') = 'N'
			INNER JOIN MdMedications MM ON CMI.StrengthId = MM.MedicationId
				AND ISNULL(MM.RecordDeleted, 'N') = 'N' --and MM.Status =4881 --select * from GlobalCodes where GlobalCodeId in (4882,4881,4884)                        
			LEFT JOIN MDRoutes AS MDR ON MDR.RouteId = MM.RouteId
				AND ISNULL(MDR.RecordDeleted, 'N') = 'N'
			LEFT JOIN GlobalCodes AS GC3 ON GC3.GlobalCodeId = CMI.Unit
				AND ISNULL(GC3.RecordDeleted, 'N') = 'N'
			--LEFT JOIN ClientOrders CO ON CO.ClientOrderId = MA.ClientOrderId
			--	AND ISNULL(CO.RecordDeleted, 'N') = 'N'
			--LEFT JOIN Orders AS O ON CO.OrderId = O.OrderId
				--AND ISNULL(O.RecordDeleted, 'N') = 'N'
				--AND ISNULL(O.Active, 'Y') = 'Y'
			--LEFT JOIN GlobalCodes AS GC4 ON GC4.GlobalCodeId = O.AdministrationTimeWindow
			--	AND ISNULL(GC4.RecordDeleted, 'N') = 'N'
			--LEFT JOIN GlobalCodes AS GC5 ON GC5.GlobalCodeId = O.HazardousMedication
			--	AND ISNULL(GC5.RecordDeleted, 'N') = 'N'
			LEFT JOIN MDRoutedDosageFormMedications MDRF ON MDRF.RoutedDosageFormMedicationId = MM.RoutedDosageFormMedicationId
				AND ISNULL(MDRF.RecordDeleted, 'N') = 'N'
			LEFT JOIN MDDosageForms MDF ON MDF.DosageFormId = MDRF.DosageFormId
				AND ISNULL(MDF.RecordDeleted, 'N') = 'N'
			LEFT JOIN Recodes AS R ON R.IntegerCodeId = MDF.DosageFormId
				AND R.RecodeCategoryId = (
					SELECT RC.RecodeCategoryId
					FROM RecodeCategories RC
					WHERE RC.CategoryName = 'XDosageFormAbbreviation'
					)
				AND ISNULL(R.RecordDeleted, 'N') = 'N'
			WHERE (
					@OrderType = - 1
					OR @OrderType = 8856
					)
				AND (CM.ClientId = @ClientId) --@ClientId         
				AND  ISNULL(OTF.IsDefault, 'N') = 'Y'
				AND (
					--(
					--	@ShiftDateTemp IS NULL
					--	AND (
							(
								(
								MA.ScheduledDate = @ShiftDate
								OR MA.ScheduledDate = @ShiftDateTemp
								)
								AND (
									MA.AdministeredDate IS NULL
									OR MA.ScheduledDate = MA.AdministeredDate
									OR NOT EXISTS (
										SELECT 1
										FROM GlobalCodes GCT
										WHERE GCT.GlobalCodeId = MA.STATUS
											AND GCT.ExternalCode1 = 'Given'
										)
									)
								)
							OR (
								MA.AdministeredDate IS NOT NULL
								AND (
									MA.AdministeredDate = @ShiftDate
									OR MA.AdministeredDate = @ShiftDateTemp
									)
								AND EXISTS (
									SELECT 1
									FROM GlobalCodes GCT
									WHERE GCT.GlobalCodeId = MA.STATUS
										AND GCT.ExternalCode1 = 'Given'
									)
								)
							--)
						--)
					--OR (
					--	@ShiftDateTemp IS NOT NULL
					--	AND (
					--		MA.ScheduledDate = @ShiftDate
					--		OR MA.ScheduledDate = @ShiftDateTemp
					--		)
					--	)
					)
				AND (
					@Display = 'All'
					OR (
						@Display = 'PRN'
						AND ISNULL(OTF.IsPRN, 'N') = 'Y'
						)
					OR (
						@Display = 'Scheduled'
						AND ISNULL(OTF.IsPRN, 'N') = 'N'
						AND ISNULL(OTF.OneTimeOnly, 'N') = 'N'
						)
					--Seema 03-Mar-2016      
					OR (
						@Display = 'One Time Only'
						AND ISNULL(OTF.OneTimeOnly, 'N') = 'Y'
						)
					)
			--AND (CO.DiscontinuedDateTime is null or  -- To display Discontinue order till next 24 hours                      
			--(ISNULL(CO.OrderDiscontinued,'N')='Y' and  Datediff (hh,CO.DiscontinuedDateTime,GetDate())<24)) 
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
			-- MedAdmin Records of current Client Orders
			SELECT MA.MedAdminRecordId
				,MA.CreatedBy
				,MA.CreatedDate
				,MA.ModifiedBy
				,MA.ModifiedDate
				,MA.RecordDeleted
				,MA.DeletedDate
				,MA.DeletedBy
				,MA.ClientOrderId
				,MA.ScheduledDate
				,MA.ScheduledTime
				,isnull(O.DualSignRequired,'N') as 'DualSignRequired'
				,CONVERT(VARCHAR(10), MA.AdministeredDate, 101) AS AdministeredDate
				,CONVERT(VARCHAR(5), MA.AdministeredTime, 108) AS AdministeredTime
				,MA.AdministeredBy
				,MA.STATUS
				,GC.CodeName AS 'StatusText'
				,GC.ExternalCode1 AS 'StatusCode'
				,MA.AdministeredDose
				,MA.Comment
				,MA.PRNReason
				,MA.NotGivenReason
				,MA.PainId
				,MA.DualSignedbyStaffId
				,MA.DualSignedDate
				,MA.OrigScheduledID
				,CASE 
					WHEN CO.OrderStatus = 6508
						THEN 'Y'
					ELSE isnull(CO.OrderDiscontinued,'N')
					END --  6508 Order Complete                      
				AS 'IsDiscontinuedOrCompleted'
				,GC1.GlobalCodeId    AS 'MedicationType' --GC1.GlobalCodeId                    
				,CASE 
					WHEN O.OrderType = 8501
						THEN CASE 
								WHEN IM.ClientOrderId IS NOT NULL
									THEN C.LastName + ', ' + C.FirstName + '<br/>Drug: ' + REPLACE(REPLACE(REPLACE(IM.DrugNDCDescription, 'DELAY.', 'DELAYED'), 'DOCUSATE SOD.', 'DOCUSATE SOD. '), '. ', '. - ') + '<br/>Sig: ' + ISNULL(IM.ProviderPharmacyInstructions, '') + CASE 
											WHEN ISNULL(CO.IsPRN, 'N') = 'Y'
												THEN ' (PRN)'
											ELSE ''
											END
										--+ UPPER(ISNULL(convert(VARCHAR(15),CAST(CAST((ROUND(CO.MedicationDosage , 2)*100) AS INT) AS FLOAT ) /100),'') +') '                     
								ELSE 
										C.LastName + ', ' + C.FirstName + '<br/>Drug: ' + O.OrderName + 
										'<br/>Dose: ' + ISNULL(convert(VARCHAR(15),CO.MedicationDosage), '') + ' ' + ISNULL(GC3.CodeName, '') + '<br/>Route: ' + ISNULL(MDR.RouteAbbreviation, '') +
										' <br/> Sig: ' +
										+ ISNULL(convert(VARCHAR(15),CO.MedicationDosage), '') + ' ' + ISNULL(GC3.CodeName, '')  +  ' ' + otf.DisplayName + CASE 
											WHEN ISNULL(OTF.IsPRN, 'N') = 'Y' THEN ' (PRN)' ELSE '' END 

											
								END
					ELSE CASE 
							WHEN IM.ClientOrderId IS NOT NULL
								THEN C.LastName + ', ' + C.FirstName + '<br/>Drug: ' + REPLACE(REPLACE(REPLACE(IM.DrugNDCDescription, 'DELAY.', 'DELAYED'), 'DOCUSATE SOD.', 'DOCUSATE SOD. '), '. ', '. - ') + '<br/> ' + ISNULL(CO.CommentsText, '') + CASE 
										WHEN ISNULL(CO.IsPRN, 'N') = 'Y'
											THEN ' PRN'
										ELSE ''
										END
									--+ UPPER(ISNULL(convert(VARCHAR(15),CAST(CAST((ROUND(CO.MedicationDosage , 2)*100) AS INT) AS FLOAT ) /100),'') +') '                     
							ELSE C.LastName + ', ' + C.FirstName + '<br/>Drug: ' + O.OrderName + '<br/> ' + ISNULL(CO.CommentsText, '') + CASE 
									WHEN ISNULL(CO.IsPRN, 'N') = 'Y'
										THEN ' PRN'
									ELSE ''
									END
							END
					END AS ScheduleTooltip
				,CO.OrderStartDateTime
				,MDR.RouteAbbreviation AS CodeName
				,CASE 
					WHEN IM.ClientOrderId IS NOT NULL
						THEN REPLACE(REPLACE(REPLACE(IM.DrugNDCDescription, 'DELAY.', 'DELAYED'), 'DOCUSATE SOD.', 'DOCUSATE SOD. '), '. ', '. - ')
					ELSE O.OrderName
					END OrderName
				,'<div style="float:left">' + S.LastName + ',' + S.FirstName + '<br/><i> Ordered: </i> ' + CONVERT(VARCHAR(10), OrderStartDateTime, 101) + '@' + CONVERT(VARCHAR(5), OrderStartDateTime, 108) + '<br/><b>' + O.OrderName + '</b> - ' +    
						UPPER(COALESCE(MM.Strength, OS.MedictionOtherStrength, CO.MedicationOtherDosage, '') + ' ' + ISNULL(MM.StrengthUnitOfMeasure, '') + ' ' + ISNULL(MDR.RouteAbbreviation, '') + ' ' + isnull(otf.DisplayName,''))
					 + '</div><div style="float:left;width:15px !important;">&nbsp;&nbsp;&nbsp</div>' + '<div style="display:table-cell">' + CASE 
					WHEN IM.ClientOrderId IS NOT NULL
						AND IM.DispensedDateTime IS NOT NULL
						THEN  IM.EnteredBy + '<br/><i> Dispensed: </i> ' + CONVERT(VARCHAR(10), CAST(IM.DispensedDateTime AS DATETIME), 101) + '@' + CONVERT(VARCHAR(5), CAST(IM.DispensedDateTime AS DATETIME), 108) + '<br/><b>' + REPLACE(
								REPLACE(REPLACE(IM.DrugNDCDescription, 'DELAY.', 'DELAYED'), 'DOCUSATE SOD.', 'DOCUSATE SOD. '), '. ', '. - ') + '</b> - ' + ISNULL(IM.ProviderPharmacyInstructions, '') + '</div>'
					when CMS1.ScriptCreationDate is not null then
						 ISNULL(S1.LastName, '') + ',' + ISNULL(S1.FirstName, '') + ' ' + '<br/><i> Dispensed: </i> ' + CONVERT(VARCHAR(10), CAST(CMS1.ScriptCreationDate AS DATETIME), 101) + '@' + 
						CONVERT(VARCHAR(5), CAST(CMS1.ScriptCreationDate AS DATETIME), 108)  + '<br/><b>' + MDM.MedicationName + '(' + MM.MedicationDescription + ')' + 
						'</b> - ' + '' + '</div>' 
					WHEN IM.ClientOrderId IS NOT NULL
						THEN IM.EnteredBy + '<br/><i> Dispensed: </i> Information not available <br/><b>' + REPLACE(REPLACE(REPLACE(IM.DrugNDCDescription, 'DELAY.', 'DELAYED'), 'DOCUSATE SOD.', 'DOCUSATE SOD. '), '. ', '. - ') + 
							'</b> -' + ISNULL(IM.ProviderPharmacyInstructions, '') + '</div>'
					WHEN @COMPLETEORDERSTORX = 'Y' THEN '<br/><i> Medication not completed in Rx </i> '  + '<br/><b>' + MDM.MedicationName + '(' + MM.MedicationDescription + ')' + 
					'</b> - ' + '' + '</div>' 
					ELSE ''
					END AS 'MedicineAdditionalInformation'
				,
				--''                       
				--AS IsDispensedByRx,                       
				CO.CommentsText AS 'SpecialInstructions'
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
																					ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS  DATETIME)), 0) >= 
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
														END + '</span><img id="imgInfoMAR" style="float:right" src="../MAR/Images/24H.png" value="###DispenseHistory24###" />'
											ELSE ''
											END + '<br/><b>Rationale</b>: ' + CASE 
											WHEN ISNULL(CO.RationaleText, '') = 'Other'
												THEN ISNULL(CO.RationaleOtherText, '')
											ELSE ISNULL(CO.RationaleText, '')
											END + ' ' + 
										'<br/> <b>Note to Pharmacy:</b> ' + CASE 
										WHEN ISNULL(CM1.IncludeCommentOnPrescription, 'N') = 'Y'
											THEN ISNULL(CM1.Comments, '')
										ELSE ''
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
																			ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0))AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0))AS DATETIME)), 0) <= 24
																			AND (ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0))AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0))AS DATETIME)), 0) >= 0
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
																				ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0))AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS DATETIME)), 0) <= 24
																				AND (
																					ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0))AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0)) AS DATETIME)), 0) >= 
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
																					ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0))AS DATETIME)), 0) <= 
																					24
																					AND (
																						ISNULL(DATEDIFF(hh, CAST(CAST(MA1.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA1.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0))AS DATETIME)), 
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
													END + '</span><img id="imgInfoMAR" style="float:right" src="../MAR/Images/24H.png" value="###DispenseHistory24###" />'
										ELSE ''
										END + '<br/><b> Rationale</b>: ' + CASE 
										WHEN ISNULL(CO.RationaleText, '') = 'Other'
											THEN ISNULL(CO.RationaleOtherText, '')
										ELSE ISNULL(CO.RationaleText, '')
										END + ' ' + 
										'<br/> <b>Note to Pharmacy:</b> ' + CASE 
										WHEN ISNULL(CM1.IncludeCommentOnPrescription, 'N') = 'Y'
											THEN ISNULL(CM1.Comments, '')
										ELSE ''
										END + ' ' + 
										CASE 
										WHEN ISNULL(CO.IsPRN, 'N') = 'Y'
											THEN ' PRN'
										ELSE ''
										END
								END
					ELSE isnull(CO.CommentsText,'') + ' ' + ISNULL(GC1.CodeName, '') + 
										
										CASE 
							WHEN ISNULL(CO.IsPRN, 'N') = 'Y'
								THEN ' PRN'
							ELSE ''
							END
					END AS MedicineRouteOtherInformation
				,MDR.RouteAbbreviation
				,ISNULL(MM.Strength, '') AS Strength
				,ISNULL(MM.StrengthUnitOfMeasure, '') AS StrengthUnitOfMeasure
				,CASE 
					WHEN IM.ClientOrderId IS NOT NULL
						THEN CASE 
								WHEN ISNULL(O.AlternateOrderName1, '') <> ''
									THEN '(' + REPLACE(REPLACE(O.AlternateOrderName1, 'DELAY.', 'DELAYED'), '. ', '. - ') + ')'
								ELSE '' --'(' + O.OrderName + ')'      
								END
					ELSE CASE 
							WHEN ISNULL(O.AlternateOrderName1, '') <> ''
								THEN ' (' + O.AlternateOrderName1 + ')'
							ELSE '' --'(' + O.OrderName + ')'      
							END
					END AS MedicationName
				,CASE 
					WHEN ISNULL(CO.IsPRN, 'N') = 'Y'
						THEN 'Y'
					ELSE 'N'
					END AS 'IsPRN'
				,OTF.TimesPerDay AS 'MedicationFrequency' -- GC1.CodeName                    
				,ISNULL(CO.MaySelfAdminister, 'N') AS IsSelfAdministered
				--,CASE 
				--	WHEN IM.ClientOrderId IS NULL and (ISNULL(CM1.Ordered, 'N') = 'N' and ISNULL(CM1.SmartCareOrderEntry, 'N') = 'N')
				--		THEN 'Y'
				--	ELSE 'N'
				--	END AS 
				,'N' as RxFlag
				,--- RxFlag flag                      
				MA.User2Comments
				,MA.User2PRNReason
				,MA.User2NotGivenReason
				,MA.User2PainId
				,CASE 
					WHEN IM.ClientOrderId IS NULL
						THEN CAST(CAST((ROUND(CO.MedicationDosage, 2) * 100) AS INT) AS FLOAT) / 100
					ELSE IM.Dose
					END AS 'MedicationDosage'
				,CASE 
					WHEN IM.ClientOrderId IS NULL
						THEN GC3.CodeName
					ELSE IM.GiveUnit
					END AS 'MedicationUnit'
				,MA.ClientMedicationId
				,GC4.CodeName AS 'AdministrationTimeWindow'
				,ISNULL(O.IsStockMedication, 'N') AS IsStockMedication
				,ISNULL(CO.MayUseOwnSupply, 'N') AS MayUseOwnSupply
				,ISNULL(CO.OrderPendAcknowledge, 'N') AS AcknowedgePending
				,MDM.MedicationNameId AS MedicationNameId
				,MDR.RouteId AS RouteId
				,ISNULL(CO.ConsentIsRequired, 'N') AS ConsentIsRequired
				,ISNULL(CO.DispenseBrand, 'N') AS DispenseBrand
				,CASE 
					WHEN O.OrderType = 8501
						THEN 'N'
					ELSE 'Y'
					END AS NonMedicationOrders
				,O.OrderId
				,CASE 
					WHEN EXISTS (
							SELECT 1
							FROM OrderQuestions OQ
							WHERE OQ.OrderId = O.OrderId
								AND OQ.ShowQuestionTimeOption = 'A'
								AND ISNULL(OQ.RecordDeleted, 'N') = 'N'
							)
						THEN 'Y'
					ELSE 'N'
					END AS 'IsQuestionsRequire'
				,GC5.Code + '###' + CAST(GC5.[Description] AS VARCHAR(MAX)) 'HazardousMedication'
				--,MA.AdministeredUnit                    
				,MA.NoOfDosageForm
				,ISNULL('# of ' + R.CodeName, 'N') AS DosageFormAbbreviation
				--,NULL AS AdministerInLast24Hours                     
				,NULL AS DispenseHistory24
				,IM.InboundMedicationId AS InboundMedicationId
				,'' AS QnA
				,CASE 
					WHEN @COMPLETEORDERSTORX = 'N'
						THEN 'N'
					WHEN (ISNULL(CM1.Ordered, 'N') = 'Y' and ISNULL(CM1.SmartCareOrderEntry, 'N') = 'Y')
						THEN 'N'
					WHEN (ISNULL(CM1.SmartCareOrderEntry, 'N') = 'N')
						THEN 'N'
					ELSE 'Y'
					END AS NotCompletedInRx
				,'N' AS IsRxSource
				,'N' AS IsPastDateRecords
				,'' AS TitrationSteps
				,MA.ClientMedicationInstructionId
				,'S' AS Prescribed
				,CASE 
					WHEN CO.MedicationOrderStrengthId IS NULL OR OS.MedicationId IS NULL
						THEN 'Y'
					ELSE 'N'
					END	AS OtherStrength
			FROM MedAdminRecords AS MA
			INNER JOIN ClientOrders AS CO ON MA.ClientOrderId = CO.ClientOrderId
				AND ISNULL(CO.RecordDeleted, 'N') = 'N'
				AND (ISNULL(MA.RecordDeleted, 'N') = 'N')
			INNER JOIN Clients AS C ON C.ClientId = CO.ClientId
				AND ISNULL(C.RecordDeleted, 'N') = 'N'
			INNER JOIN Orders AS O ON CO.OrderId = O.OrderId
				--AND ISNULL(O.RecordDeleted, 'N') = 'N'
				--AND ISNULL(O.Active, 'Y') = 'Y'
			LEFT JOIN GlobalCodes AS GC ON GC.GlobalCodeId = MA.STATUS
				AND ISNULL(GC.RecordDeleted, 'N') = 'N'
			--INNER JOIN OrderFrequencies AS OFS ON OFS.OrderFrequencyId = CO.OrderFrequencyId                    
			-- AND ISNULL(OFS.RecordDeleted, 'N') = 'N'                    
			LEFT JOIN OrderTemplateFrequencies AS OTF ON OTF.OrderTemplateFrequencyId = CO.OrderTemplateFrequencyId
				AND ISNULL(OTF.RecordDeleted, 'N') = 'N'
			LEFT JOIN GlobalCodes AS GC1 ON GC1.GlobalCodeId = OTF.RxFrequencyId                    
			 AND ISNULL(GC1.RecordDeleted, 'N') = 'N'                    
			INNER JOIN Staff AS S ON S.StaffId = CO.OrderingPhysician
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
			LEFT JOIN GlobalCodes AS GC2 ON GC2.GlobalCodeId = OTF.FrequencyId
				AND ISNULL(GC2.RecordDeleted, 'N') = 'N'
			LEFT JOIN InboundMedications AS IM ON IM.ClientOrderId = CO.ClientOrderId
				AND ISNULL(IM.RecordDeleted, 'N') = 'N'
			LEFT JOIN GlobalCodes AS GC3 ON GC3.GlobalCodeId = CO.MedicationUnits
				AND ISNULL(GC3.RecordDeleted, 'N') = 'N'
			LEFT JOIN GlobalCodes AS GC4 ON GC4.GlobalCodeId = O.AdministrationTimeWindow
				AND ISNULL(GC4.RecordDeleted, 'N') = 'N'
			LEFT JOIN GlobalCodes AS GC5 ON GC5.GlobalCodeId = O.HazardousMedication
				AND ISNULL(GC5.RecordDeleted, 'N') = 'N'
			LEFT JOIN Recodes AS R ON R.IntegerCodeId = MDF.DosageFormId
				AND R.RecodeCategoryId = (
					SELECT RC.RecodeCategoryId
					FROM RecodeCategories RC
					WHERE RC.CategoryName = 'XDosageFormAbbreviation'
					)
				AND ISNULL(R.RecordDeleted, 'N') = 'N'
			LEFT JOIN ClientMedications AS CM1 ON MA.ClientMedicationId = CM1.ClientMedicationId
				AND ISNULL(CM1.RecordDeleted, 'N') = 'N'
				and ISNULL(CM1.SmartCareOrderEntry, 'N') = 'Y'
			LEFT JOIN ClientMedicationInstructions AS CMI1 ON CM1.ClientMedicationId = CMI1.ClientMedicationId
				AND ISNULL(CMI1.RecordDeleted, 'N') = 'N'
				AND ISNULL(CMI1.Active, 'Y') = 'Y'
			LEFT JOIN ClientMedicationScriptDrugs CMSD ON CMI1.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId
				AND isnull(CMSD.RecordDeleted, 'N') = 'N'
			LEFT JOIN ClientMedicationScripts CMS1 ON CMS1.ClientMedicationScriptId = CMSD.ClientMedicationScriptId--03/Apr/2018  Bibhu
				AND isnull(CMS1.RecordDeleted, 'N') = 'N'
			LEFT JOIN Staff AS S1 ON S1.StaffId = CM1.PrescriberId
				AND ISNULL(S1.RecordDeleted, 'N') = 'N'
			WHERE  (
					@OrderType = - 1
					OR (
						@OrderType = 8856
						AND O.OrderType = 8501
						)
					OR (
						@OrderType = 8857
						AND O.OrderType <> 8501
						)
					)
				AND (NOT EXISTS( SELECT 1 FROM Recodes R JOIN RecodeCategories RC ON RC.CategoryName = 'RxOrder' 
										AND RC.RecodeCategoryId = R.RecodeCategoryId WHERE ISNULL(R.RecordDeleted, 'N') = 'N' 
										AND R.IntegerCodeId = O.OrderId ))

				AND (CO.ClientId = @ClientId)
				AND (
					--(
					--	@ShiftDateTemp IS NULL
					--	AND (
							(
								(
								MA.ScheduledDate = @ShiftDate
								OR MA.ScheduledDate = @ShiftDateTemp
								)
								AND (
									MA.AdministeredDate IS NULL
									OR MA.ScheduledDate = MA.AdministeredDate
									OR NOT EXISTS (
										SELECT 1
										FROM GlobalCodes GCT
										WHERE GCT.GlobalCodeId = MA.STATUS
											AND GCT.ExternalCode1 = 'Given'
										)
									)
								)
							OR (
								MA.AdministeredDate IS NOT NULL
								AND (
									MA.AdministeredDate = @ShiftDate
									OR MA.AdministeredDate = @ShiftDateTemp
									)
								AND EXISTS (
									SELECT 1
									FROM GlobalCodes GCT
									WHERE GCT.GlobalCodeId = MA.STATUS
										AND GCT.ExternalCode1 = 'Given'
									)
								)
							--)
						--)
					--OR (
					--	@ShiftDateTemp IS NOT NULL
					--	AND (
					--		MA.ScheduledDate = @ShiftDate
					--		OR MA.ScheduledDate = @ShiftDateTemp
					--		)
					--	)
					)
				AND (
					@Display = 'All'
					OR (
						@Display = 'PRN'
						AND ISNULL(CO.IsPRN, 'N') = 'Y'
						)
					OR (
						@Display = 'Scheduled'
						AND ISNULL(CO.IsPRN, 'N') <> 'Y'
						AND ISNULL(OTF.OneTimeOnly, 'N') <> 'Y'
						)
					--Seema 03-Mar-2016    
					OR (
						@Display = 'One Time Only'
						AND ISNULL(OTF.OneTimeOnly, 'N') = 'Y'
						)
					)
			-- Chethan N -- Sep/04/2018
				AND (
						(
						ISNULL(CO.RecordDeleted, 'N') = 'N'
						AND CO.DiscontinuedDateTime IS NULL
						)
					OR -- To display Discontinue order till next @ShowDiscontinueMedsFromPastXDays day(s)              
						(
						ISNULL(CO.OrderDiscontinued, 'N') = 'Y'
						AND DATEDIFF(D, CO.DiscontinuedDateTime, @ShiftDate) <= ISNULL(@ShowDiscontinueMedsFromPastXDays, 1)
						)
						
					)
			-- Client Medications with Past end date
			UNION ALL
			SELECT -CM.ClientMedicationId AS MedAdminRecordId
				,CM.CreatedBy
				,CM.CreatedDate
				,CM.ModifiedBy
				,CM.ModifiedDate
				,CM.RecordDeleted
				,CM.DeletedDate
				,CM.DeletedBy
				,COMR.ClientOrderId
				,NULL AS ScheduledDate
				,NULL AS ScheduledTime
				,'N' AS DualSignRequired
				,NULL AS AdministeredDate
				,NULL AS AdministeredTime
				,NULL AS AdministeredBy
				,NULL AS STATUS
				,NULL AS 'StatusText'
				,NULL AS 'StatusCode'
				,NULL AS AdministeredDose
				,NULL AS Comment
				,NULL AS PRNReason
				,NULL AS NotGivenReason
				,NULL AS PainId
				,NULL AS DualSignedbyStaffId
				,NULL AS DualSignedDate
				,NULL AS OrigScheduledID
				,CASE 
					WHEN isnull(CM.Discontinued, 'N') = 'Y'
						THEN 'Y'
					ELSE 'N'
					END AS 'IsDiscontinuedOrCompleted'
				,GC1.GlobalCodeId AS 'MedicationType'
				,C.LastName + ', ' + C.FirstName + '<br/>Drug: ' + MN.MedicationName + '<br/>Dose: ' + ISNULL(convert(VARCHAR(15), CMI.Quantity), '') + ' ' + ISNULL(GC3.CodeName, '') + '<br/>Route: ' + ISNULL(MDR.RouteAbbreviation, '') + ' <br/> Sig: ' 
				+ISNULL(convert(VARCHAR(15), CMI.Quantity), '') + ' ' + ISNULL(GC3.CodeName, '') + ' ' + ISNULL(GC1.CodeName, '') + CASE 
							WHEN ISNULL(OTF.IsPRN, 'N') = 'Y'
								THEN ' (PRN)'
							ELSE ''
					END AS ScheduleTooltip
				,CM.MedicationStartDate AS OrderStartDateTime
				,MDR.RouteAbbreviation AS CodeName
				,MN.MedicationName AS OrderName
				,CASE WHEN (ISNULL(CM.SmartCareOrderEntry, 'N') = 'Y' OR ISNULL(CM.Ordered, 'N') = 'Y') THEN
					'<div style="float:left">' + ISNULL(S.LastName, '') + ',' + ISNULL(S.FirstName, '') + '<br/><i> Ordered: </i> ' + CONVERT(VARCHAR(10), CM.MedicationStartDate, 101) + '@' + CONVERT(VARCHAR(5), CM.MedicationStartDate, 108) + '<br/><b>' + MN.MedicationName + '</b> - ' 
					+ ISNULL(convert(VARCHAR(15), CMI.Quantity), '') + ' ' + ISNULL(GC3.CodeName, '') + ' ' + ISNULL(GC1.CodeName, '') 
					+ '<br/><i>End Date</i> - ' + CONVERT(VARCHAR(10), CM.MedicationEndDate, 101) + '</div>'+
					'<div style="float:left;width:15px !important;">&nbsp;&nbsp;&nbsp</div>' + '<div style="display:table-cell">' + ISNULL(S.LastName, '') + ',' + ISNULL(S.FirstName, '') + ' ' +
					case when CMS.ScriptCreationDate is not null then
					'<br/><i> Dispensed: </i> ' + CONVERT(VARCHAR(10), CAST(CMS.ScriptCreationDate AS DATETIME), 101) + '@' + CONVERT(VARCHAR(5), CAST(CMS.ScriptCreationDate AS DATETIME), 108) 
					else '<br/><i> Medication not completed in Rx </i> ' end
					 + '<br/><b>' + MN.MedicationName + '(' + MM.MedicationDescription + ')' + 
					'</b> - ' + '' + '</div>' 
				ELSE '' END AS 'MedicineAdditionalInformation'
				,
				--''                         
				--AS IsDispensedByRx,                         
				CM.SpecialInstructions AS 'SpecialInstructions'
				,'<b>Sig</b>: ' +ISNULL(convert(VARCHAR(15), CMI.Quantity), '') + ' ' + ISNULL(GC3.CodeName, '') + ' ' + ISNULL(GC1.CodeName, '') + CASE 
								WHEN ISNULL(OTF.IsPRN, 'N') = 'Y'
									THEN ' (PRN)'
								ELSE ''
								END
				--+ '<br/><b>Route:</b> ' + ISNULL(MDR.RouteAbbreviation, '') 
				
				+ '<br/> <b>Note to Pharmacy:</b> ' + CASE 
					WHEN ISNULL(CM.IncludeCommentOnPrescription, 'N') = 'Y'
						THEN ISNULL(CM.Comments, '')
					ELSE ''
					END AS MedicineRouteOtherInformation
				,MDR.RouteAbbreviation
				,ISNULL(MM.Strength, '') AS Strength
				,ISNULL(MM.StrengthUnitOfMeasure, '') AS StrengthUnitOfMeasure
				,'(' + MN.MedicationName + ')' AS MedicationName
				,ISNULL(OTF.IsPRN, 'N') AS 'IsPRN'
				,OTF.TimesPerDay AS 'MedicationFrequency'
				,--GC1.CodeName as 'MedicationFrequency'                      
				'N' AS IsSelfAdministered
				,'N' AS RxFlag
				,NULL AS User2Comments
				,NULL AS User2PRNReason
				,NULL AS User2NotGivenReason
				,NULL AS User2PainId
				,CMI.Quantity AS 'MedicationDosage'
				,ISNULL(GC3.CodeName, '') AS 'MedicationUnit'
				,CM.ClientMedicationId
				,@MARDefaultAdministrationWindow AS 'AdministrationTimeWindow'
				,'N' AS IsStockMedication
				,'N' AS MayUseOwnSupply
				,'N' AS AcknowedgePending
				,CM.MedicationNameId AS MedicationNameId
				,MDR.RouteId
				,'N' AS ConsentIsRequired
				,'N' AS DispenseBrand
				,'N' AS NonMedicationOrders
				,NULL AS OrderId
				,'N' AS IsQuestionsRequire
				,'' as 'HazardousMedication'
				--,MA.AdministeredUnit                      
				,NULL AS NoOfDosageForm
				,ISNULL('# of ' + R.CodeName, 'N') AS DosageFormAbbreviation
				--,NULL AS AdministerInLast24Hours                       
				,NULL AS DispenseHistory24
				,NULL AS InboundMedicationId
				,'' AS QnA
				,'N' AS NotCompletedInRx
				,'Y' AS IsRxSource
				,'Y' AS IsPastDateRecords
				,'' AS TitrationSteps
				,NULL AS ClientMedicationInstructionId
				,ISNULL(CM.Ordered, 'N') AS Prescribed
				,'N' AS OtherStrength
			FROM ClientMedications AS CM 
			INNER JOIN ClientMedicationInstructions AS CMI ON CM.ClientMedicationId = CMI.ClientMedicationId
				AND ISNULL(CMI.RecordDeleted, 'N') = 'N'
				AND ISNULL(CMI.Active, 'Y') = 'Y'
			INNER JOIN ClientMedicationScriptDrugs CMSD ON CMI.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId
				AND isnull(CMSD.RecordDeleted, 'N') = 'N'
			LEFT JOIN ClientMedicationScripts CMS ON CMS.ClientMedicationScriptId = CMSD.ClientMedicationScriptId--03/Apr/2018  Bibhu
				AND isnull(CMS.RecordDeleted, 'N') = 'N'
			INNER JOIN Clients AS C ON C.ClientId = CM.ClientId
				AND ISNULL(C.RecordDeleted, 'N') = 'N'
			INNER JOIN MDMedicationNames MN ON CM.MedicationNameId = MN.MedicationNameId
				AND ISNULL(MN.RecordDeleted, 'N') = 'N'
			INNER JOIN OrderTemplateFrequencies OTF ON OTF.RxFrequencyId = CMI.Schedule
				AND ISNULL(OTF.RecordDeleted, 'N') = 'N'
			--LEFT JOIN GlobalCodes AS GC ON GC.GlobalCodeId = MA.STATUS
			--	AND ISNULL(GC.RecordDeleted, 'N') = 'N'
			INNER JOIN GlobalCodes AS GC1 ON GC1.GlobalCodeId = CMI.Schedule
				AND ISNULL(GC1.RecordDeleted, 'N') = 'N'
			LEFT JOIN Staff AS S ON S.StaffId = CM.PrescriberId
				AND ISNULL(S.RecordDeleted, 'N') = 'N'
			INNER JOIN MdMedications MM ON CMI.StrengthId = MM.MedicationId
				AND ISNULL(MM.RecordDeleted, 'N') = 'N' --and MM.Status =4881 --select * from GlobalCodes where GlobalCodeId in (4882,4881,4884)                        
			LEFT JOIN MDRoutes AS MDR ON MDR.RouteId = MM.RouteId
				AND ISNULL(MDR.RecordDeleted, 'N') = 'N'
			LEFT JOIN GlobalCodes AS GC3 ON GC3.GlobalCodeId = CMI.Unit
				AND ISNULL(GC3.RecordDeleted, 'N') = 'N'
			LEFT JOIN MDRoutedDosageFormMedications MDRF ON MDRF.RoutedDosageFormMedicationId = MM.RoutedDosageFormMedicationId
				AND ISNULL(MDRF.RecordDeleted, 'N') = 'N'
			LEFT JOIN MDDosageForms MDF ON MDF.DosageFormId = MDRF.DosageFormId
				AND ISNULL(MDF.RecordDeleted, 'N') = 'N'
			LEFT JOIN Recodes AS R ON R.IntegerCodeId = MDF.DosageFormId
				AND R.RecodeCategoryId = (
					SELECT RC.RecodeCategoryId
					FROM RecodeCategories RC
					WHERE RC.CategoryName = 'XDosageFormAbbreviation'
					)
				AND ISNULL(R.RecordDeleted, 'N') = 'N'
			LEFT JOIN ClientOrderMedicationReferences COMR ON COMR.ClientMedicationId = CM.ClientMedicationId
				AND ISNULL(COMR.IsActive, 'N') = 'Y'
			WHERE EXISTS(SELECT 1 FROM MedAdminRecords MA 
							WHERE MA.ClientMedicationId = CM.ClientMedicationId
							AND (ISNULL(MA.RecordDeleted, 'N') = 'N'))
				AND ISNULL(CM.RecordDeleted, 'N') = 'N'
				AND ISNULL(CM.SmartCareOrderEntry, 'N') = 'N'
				AND ISNULL(CM.Discontinued, 'N') ='N'
				AND (
					@OrderType = - 1
					OR @OrderType = 8856
					)
				AND (CM.ClientId = @ClientId) --@ClientId         
				AND  ISNULL(OTF.IsDefault, 'N') = 'Y'				
				AND (
						CM.MedicationEndDate IS NOT NULL
						AND CAST(CM.MedicationEndDate AS DATE) < CAST(@ShiftDate AS DATE)
					)
				AND (
					@Display = 'All'
					OR (
						@Display = 'PRN'
						AND ISNULL(OTF.IsPRN, 'N') = 'Y'
						)
					OR (
						@Display = 'Scheduled'
						AND ISNULL(OTF.IsPRN, 'N') = 'N'
						AND ISNULL(OTF.OneTimeOnly, 'N') = 'N'
						)
					--Seema 03-Mar-2016      
					OR (
						@Display = 'One Time Only'
						AND ISNULL(OTF.OneTimeOnly, 'N') = 'Y'
						)
					)
					
			-- CLient Orders with Past end date
			UNION ALL
			
			SELECT -CO.ClientOrderId AS MedAdminRecordId
				,CO.CreatedBy
				,CO.CreatedDate
				,CO.ModifiedBy
				,CO.ModifiedDate
				,CO.RecordDeleted
				,CO.DeletedDate
				,CO.DeletedBy
				,CO.ClientOrderId
				,NULL AS ScheduledDate
				,NULL AS ScheduledTime
				,isnull(O.DualSignRequired,'N') as 'DualSignRequired'
				,NULL AS AdministeredDate
				,NULL AS AdministeredTime
				,NULL AS AdministeredBy
				,NULL AS STATUS
				,NULL AS 'StatusText'
				,NULL AS 'StatusCode'
				,NULL AS AdministeredDose
				,NULL AS Comment
				,NULL AS PRNReason
				,NULL AS NotGivenReason
				,NULL AS PainId
				,NULL AS DualSignedbyStaffId
				,NULL AS DualSignedDate
				,NULL AS OrigScheduledID
				,CASE 
					WHEN CO.OrderStatus = 6508
						THEN 'Y'
					ELSE isnull(CO.OrderDiscontinued,'N')
					END --  6508 Order Complete                      
				AS 'IsDiscontinuedOrCompleted'
				,GC1.GlobalCodeId    AS 'MedicationType' --GC1.GlobalCodeId                    
				,CASE 
					WHEN O.OrderType = 8501
						THEN CASE 
								WHEN IM.ClientOrderId IS NOT NULL
									THEN C.LastName + ', ' + C.FirstName + '<br/>Drug: ' + REPLACE(REPLACE(REPLACE(IM.DrugNDCDescription, 'DELAY.', 'DELAYED'), 'DOCUSATE SOD.', 'DOCUSATE SOD. '), '. ', '. - ') + '<br/>Sig: ' + ISNULL(IM.ProviderPharmacyInstructions, '') + CASE 
											WHEN ISNULL(CO.IsPRN, 'N') = 'Y'
												THEN ' (PRN)'
											ELSE ''
											END
										--+ UPPER(ISNULL(convert(VARCHAR(15),CAST(CAST((ROUND(CO.MedicationDosage , 2)*100) AS INT) AS FLOAT ) /100),'') +') '                     
								ELSE 
										C.LastName + ', ' + C.FirstName + '<br/>Drug: ' + O.OrderName + 
										'<br/>Dose: ' + ISNULL(convert(VARCHAR(15),CO.MedicationDosage), '') + ' ' + ISNULL(GC3.CodeName, '') + '<br/>Route: ' + ISNULL(MDR.RouteAbbreviation, '') +
										' <br/> Sig: ' +
										+ ISNULL(convert(VARCHAR(15),CO.MedicationDosage), '') + ' ' + ISNULL(GC3.CodeName, '')  +  ' ' + otf.DisplayName + CASE 
											WHEN ISNULL(OTF.IsPRN, 'N') = 'Y' THEN ' (PRN)' ELSE '' END 

											
								END
					ELSE CASE 
							WHEN IM.ClientOrderId IS NOT NULL
								THEN C.LastName + ', ' + C.FirstName + '<br/>Drug: ' + REPLACE(REPLACE(REPLACE(IM.DrugNDCDescription, 'DELAY.', 'DELAYED'), 'DOCUSATE SOD.', 'DOCUSATE SOD. '), '. ', '. - ') + '<br/> ' + ISNULL(CO.CommentsText, '') + CASE 
										WHEN ISNULL(CO.IsPRN, 'N') = 'Y'
											THEN ' PRN'
										ELSE ''
										END
									--+ UPPER(ISNULL(convert(VARCHAR(15),CAST(CAST((ROUND(CO.MedicationDosage , 2)*100) AS INT) AS FLOAT ) /100),'') +') '                     
							ELSE C.LastName + ', ' + C.FirstName + '<br/>Drug: ' + O.OrderName + '<br/> ' + ISNULL(CO.CommentsText, '') + CASE 
									WHEN ISNULL(CO.IsPRN, 'N') = 'Y'
										THEN ' PRN'
									ELSE ''
									END
							END
					END AS ScheduleTooltip
				,CO.OrderStartDateTime
				,MDR.RouteAbbreviation AS CodeName
				,CASE 
					WHEN IM.ClientOrderId IS NOT NULL
						THEN REPLACE(REPLACE(REPLACE(IM.DrugNDCDescription, 'DELAY.', 'DELAYED'), 'DOCUSATE SOD.', 'DOCUSATE SOD. '), '. ', '. - ')
					ELSE O.OrderName
					END OrderName
				,'<div style="float:left">' + S.LastName + ',' + S.FirstName + '<br/><i> Ordered: </i> ' + CONVERT(VARCHAR(10), OrderStartDateTime, 101) + '@' + CONVERT(VARCHAR(5), OrderStartDateTime, 108) + '<br/><b>' + O.OrderName + '</b> - ' +    
						UPPER(COALESCE(MM.Strength, OS.MedictionOtherStrength, CO.MedicationOtherDosage, '') + ' ' + ISNULL(MM.StrengthUnitOfMeasure, '') + ' ' + ISNULL(MDR.RouteAbbreviation, '') + ' ' + isnull(otf.DisplayName,''))
					 + '<br/><i>End Date</i> - ' + CONVERT(VARCHAR(10), CO.OrderEndDateTime, 101) 
					 + '</div><div style="float:left;width:15px !important;">&nbsp;&nbsp;&nbsp</div>' + '<div style="display:table-cell">' + CASE 
					WHEN IM.ClientOrderId IS NOT NULL
						AND IM.DispensedDateTime IS NOT NULL
						THEN  IM.EnteredBy + '<br/><i> Dispensed: </i> ' + CONVERT(VARCHAR(10), CAST(IM.DispensedDateTime AS DATETIME), 101) + '@' + CONVERT(VARCHAR(5), CAST(IM.DispensedDateTime AS DATETIME), 108) + '<br/><b>' + REPLACE(
								REPLACE(REPLACE(IM.DrugNDCDescription, 'DELAY.', 'DELAYED'), 'DOCUSATE SOD.', 'DOCUSATE SOD. '), '. ', '. - ') + '</b> - ' + ISNULL(IM.ProviderPharmacyInstructions, '') + '</div>'
					when CMS1.ScriptCreationDate is not null then
						 ISNULL(S1.LastName, '') + ',' + ISNULL(S1.FirstName, '') + ' ' + '<br/><i> Dispensed: </i> ' + CONVERT(VARCHAR(10), CAST(CMS1.ScriptCreationDate AS DATETIME), 101) + '@' + 
						CONVERT(VARCHAR(5), CAST(CMS1.ScriptCreationDate AS DATETIME), 108)  + '<br/><b>' + MDM.MedicationName + '(' + MM.MedicationDescription + ')' + 
						'</b> - ' + '' + '</div>' 
					WHEN IM.ClientOrderId IS NOT NULL
						THEN IM.EnteredBy + '<br/><i> Dispensed: </i> Information not available <br/><b>' + REPLACE(REPLACE(REPLACE(IM.DrugNDCDescription, 'DELAY.', 'DELAYED'), 'DOCUSATE SOD.', 'DOCUSATE SOD. '), '. ', '. - ') + 
							'</b> -' + ISNULL(IM.ProviderPharmacyInstructions, '') + '</div>'
					WHEN @COMPLETEORDERSTORX = 'Y' THEN '<br/><i> Medication not completed in Rx </i> '  + '<br/><b>' + MDM.MedicationName + '(' + MM.MedicationDescription + ')' + 
					'</b> - ' + '' + '</div>' 
					ELSE '' 
					END AS 'MedicineAdditionalInformation'
				,
				--''                       
				--AS IsDispensedByRx,                       
				CO.CommentsText AS 'SpecialInstructions'
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
														END + '</span><img id="imgInfoMAR" style="float:right" src="../MAR/Images/24H.png" value="###DispenseHistory24###" />'
											ELSE ''
											END + '<br/><b>Rationale</b>: ' + CASE 
											WHEN ISNULL(CO.RationaleText, '') = 'Other'
												THEN ISNULL(CO.RationaleOtherText, '')
											ELSE ISNULL(CO.RationaleText, '')
											END + ' ' + 
										'<br/> <b>Note to Pharmacy:</b> ' + CASE 
										WHEN ISNULL(CM1.IncludeCommentOnPrescription, 'N') = 'Y'
											THEN ISNULL(CM1.Comments, '')
										ELSE ''
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
													END + '</span><img id="imgInfoMAR" style="float:right" src="../MAR/Images/24H.png" value="###DispenseHistory24###" />'
										ELSE ''
										END + '<br/><b> Rationale</b>: ' + CASE 
										WHEN ISNULL(CO.RationaleText, '') = 'Other'
											THEN ISNULL(CO.RationaleOtherText, '')
										ELSE ISNULL(CO.RationaleText, '')
										END + ' ' + 
										'<br/> <b>Note to Pharmacy:</b> ' + CASE 
										WHEN ISNULL(CM1.IncludeCommentOnPrescription, 'N') = 'Y'
											THEN ISNULL(CM1.Comments, '')
										ELSE ''
										END + ' ' + 
										CASE 
										WHEN ISNULL(CO.IsPRN, 'N') = 'Y'
											THEN ' PRN'
										ELSE ''
										END
								END
					ELSE isnull(CO.CommentsText,'') + ' ' + ISNULL(GC1.CodeName, '') + 
										
										CASE 
							WHEN ISNULL(CO.IsPRN, 'N') = 'Y'
								THEN ' PRN'
							ELSE ''
							END
					END AS MedicineRouteOtherInformation
				,MDR.RouteAbbreviation
				,ISNULL(MM.Strength, '') AS Strength
				,ISNULL(MM.StrengthUnitOfMeasure, '') AS StrengthUnitOfMeasure
				,CASE 
					WHEN IM.ClientOrderId IS NOT NULL
						THEN CASE 
								WHEN ISNULL(O.AlternateOrderName1, '') <> ''
									THEN '(' + REPLACE(REPLACE(O.AlternateOrderName1, 'DELAY.', 'DELAYED'), '. ', '. - ') + ')'
								ELSE '' --'(' + O.OrderName + ')'      
								END
					ELSE CASE 
							WHEN ISNULL(O.AlternateOrderName1, '') <> ''
								THEN ' (' + O.AlternateOrderName1 + ')'
							ELSE '' --'(' + O.OrderName + ')'      
							END
					END AS MedicationName
				,CASE 
					WHEN ISNULL(CO.IsPRN, 'N') = 'Y'
						THEN 'Y'
					ELSE 'N'
					END AS 'IsPRN'
				,OTF.TimesPerDay AS 'MedicationFrequency' -- GC1.CodeName                    
				,ISNULL(CO.MaySelfAdminister, 'N') AS IsSelfAdministered
				,'N' as RxFlag
				,NULL AS User2Comments
				,NULL AS User2PRNReason
				,NULL AS User2NotGivenReason
				,NULL AS User2PainId
				,CASE 
					WHEN IM.ClientOrderId IS NULL
						THEN CAST(CAST((ROUND(CO.MedicationDosage, 2) * 100) AS INT) AS FLOAT) / 100
					ELSE IM.Dose
					END AS 'MedicationDosage'
				,CASE 
					WHEN IM.ClientOrderId IS NULL
						THEN GC3.CodeName
					ELSE IM.GiveUnit
					END AS 'MedicationUnit'
				,COMR.ClientMedicationId
				,GC4.CodeName AS 'AdministrationTimeWindow'
				,ISNULL(O.IsStockMedication, 'N') AS IsStockMedication
				,ISNULL(CO.MayUseOwnSupply, 'N') AS MayUseOwnSupply
				,ISNULL(CO.OrderPendAcknowledge, 'N') AS AcknowedgePending
				,MDM.MedicationNameId AS MedicationNameId
				,MDR.RouteId AS RouteId
				,ISNULL(CO.ConsentIsRequired, 'N') AS ConsentIsRequired
				,ISNULL(CO.DispenseBrand, 'N') AS DispenseBrand
				,CASE 
					WHEN O.OrderType = 8501
						THEN 'N'
					ELSE 'Y'
					END AS NonMedicationOrders
				,O.OrderId
				,CASE 
					WHEN EXISTS (
							SELECT 1
							FROM OrderQuestions OQ
							WHERE OQ.OrderId = O.OrderId
								AND OQ.ShowQuestionTimeOption = 'A'
								AND ISNULL(OQ.RecordDeleted, 'N') = 'N'
							)
						THEN 'Y'
					ELSE 'N'
					END AS 'IsQuestionsRequire'
				,GC5.Code + '###' + CAST(GC5.[Description] AS VARCHAR(MAX)) 'HazardousMedication'
				--,MA.AdministeredUnit                    
				,NULL AS NoOfDosageForm
				,ISNULL('# of ' + R.CodeName, 'N') AS DosageFormAbbreviation
				--,NULL AS AdministerInLast24Hours                     
				,NULL AS DispenseHistory24
				,IM.InboundMedicationId AS InboundMedicationId
				,'' AS QnA
				,CASE 
					WHEN @COMPLETEORDERSTORX = 'N'
						THEN 'N'
					WHEN (ISNULL(CM1.Ordered, 'N') = 'Y' and ISNULL(CM1.SmartCareOrderEntry, 'N') = 'Y')
						THEN 'N'
					WHEN (ISNULL(CM1.SmartCareOrderEntry, 'N') = 'N')
						THEN 'N'
					ELSE 'Y'
					END AS NotCompletedInRx
				,'N' AS IsRxSource
				,'Y' AS IsPastDateRecords
				,'' AS TitrationSteps
				,NULL AS ClientMedicationInstructionId
				,'S' AS Prescribed
				,'N' AS OtherStrength
			FROM ClientOrders AS CO
			INNER JOIN Clients AS C ON C.ClientId = CO.ClientId
				AND ISNULL(C.RecordDeleted, 'N') = 'N'
			INNER JOIN Orders AS O ON CO.OrderId = O.OrderId
				--AND ISNULL(O.RecordDeleted, 'N') = 'N'
				--AND ISNULL(O.Active, 'Y') = 'Y'
			--LEFT JOIN GlobalCodes AS GC ON GC.GlobalCodeId = MA.STATUS
			--	AND ISNULL(GC.RecordDeleted, 'N') = 'N'
			--INNER JOIN OrderFrequencies AS OFS ON OFS.OrderFrequencyId = CO.OrderFrequencyId                    
			-- AND ISNULL(OFS.RecordDeleted, 'N') = 'N'                    
			LEFT JOIN OrderTemplateFrequencies AS OTF ON OTF.OrderTemplateFrequencyId = CO.OrderTemplateFrequencyId
				AND ISNULL(OTF.RecordDeleted, 'N') = 'N'
			LEFT JOIN GlobalCodes AS GC1 ON GC1.GlobalCodeId = OTF.RxFrequencyId                    
			 AND ISNULL(GC1.RecordDeleted, 'N') = 'N'                    
			INNER JOIN Staff AS S ON S.StaffId = CO.OrderingPhysician
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
			LEFT JOIN GlobalCodes AS GC2 ON GC2.GlobalCodeId = OTF.FrequencyId
				AND ISNULL(GC2.RecordDeleted, 'N') = 'N'
			LEFT JOIN InboundMedications AS IM ON IM.ClientOrderId = CO.ClientOrderId
				AND ISNULL(IM.RecordDeleted, 'N') = 'N'
			LEFT JOIN GlobalCodes AS GC3 ON GC3.GlobalCodeId = CO.MedicationUnits
				AND ISNULL(GC3.RecordDeleted, 'N') = 'N'
			LEFT JOIN GlobalCodes AS GC4 ON GC4.GlobalCodeId = O.AdministrationTimeWindow
				AND ISNULL(GC4.RecordDeleted, 'N') = 'N'
			LEFT JOIN GlobalCodes AS GC5 ON GC5.GlobalCodeId = O.HazardousMedication
				AND ISNULL(GC5.RecordDeleted, 'N') = 'N'
			LEFT JOIN Recodes AS R ON R.IntegerCodeId = MDF.DosageFormId
				AND R.RecodeCategoryId = (
					SELECT RC.RecodeCategoryId
					FROM RecodeCategories RC
					WHERE RC.CategoryName = 'XDosageFormAbbreviation'
					)
				AND ISNULL(R.RecordDeleted, 'N') = 'N'
			JOIN ClientOrderMedicationReferences COMR ON COMR.ClientOrderId = CO.ClientOrderId
				AND ISNULL(COMR.IsActive, 'N') = 'Y'
			LEFT JOIN ClientMedications AS CM1 ON COMR.ClientMedicationId = CM1.ClientMedicationId
				AND ISNULL(CM1.RecordDeleted, 'N') = 'N'
				and ISNULL(CM1.SmartCareOrderEntry, 'N') = 'Y'
			LEFT JOIN ClientMedicationInstructions AS CMI1 ON CM1.ClientMedicationId = CMI1.ClientMedicationId
				AND ISNULL(CMI1.RecordDeleted, 'N') = 'N'
				AND ISNULL(CMI1.Active, 'Y') = 'Y'
			LEFT JOIN ClientMedicationScriptDrugs CMSD ON CMI1.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId
				AND isnull(CMSD.RecordDeleted, 'N') = 'N'
			LEFT JOIN ClientMedicationScripts CMS1 ON CMS1.ClientMedicationScriptId = CMSD.ClientMedicationScriptId--03/Apr/2018  Bibhu
				AND isnull(CMS1.RecordDeleted, 'N') = 'N'
			LEFT JOIN Staff AS S1 ON S1.StaffId = CM1.PrescriberId
				AND ISNULL(S1.RecordDeleted, 'N') = 'N'
			WHERE  EXISTS(SELECT 1 FROM MedAdminRecords MA 
							WHERE MA.ClientOrderId = CO.ClientOrderId
							AND (ISNULL(MA.RecordDeleted, 'N') = 'N'))
					AND ISNULL(CO.RecordDeleted, 'N') = 'N'
					AND ISNULL(CO.OrderDiscontinued, 'N') = 'N'
					AND (
					@OrderType = - 1
					OR (
						@OrderType = 8856
						AND O.OrderType = 8501
						)
					OR (
						@OrderType = 8857
						AND O.OrderType <> 8501
						)
					)
				AND (NOT EXISTS( SELECT 1 FROM Recodes R JOIN RecodeCategories RC ON RC.CategoryName = 'RxOrder' 
										AND RC.RecodeCategoryId = R.RecodeCategoryId WHERE ISNULL(R.RecordDeleted, 'N') = 'N' 
										AND R.IntegerCodeId = O.OrderId ))

				AND (CO.ClientId = @ClientId)
				AND (
					(
						CO.OrderEndDateTime IS NOT NULL
						AND CAST(CO.OrderEndDateTime AS DATE) < CAST(@ShiftDate AS DATE)
						)
					)
				AND (
					@Display = 'All'
					OR (
						@Display = 'PRN'
						AND ISNULL(CO.IsPRN, 'N') = 'Y'
						)
					OR (
						@Display = 'Scheduled'
						AND ISNULL(CO.IsPRN, 'N') <> 'Y'
						AND ISNULL(OTF.OneTimeOnly, 'N') <> 'Y'
						)
					--Seema 03-Mar-2016    
					OR (
						@Display = 'One Time Only'
						AND ISNULL(OTF.OneTimeOnly, 'N') = 'Y'
						)
					)
			) AllData
		ORDER BY CASE 
				WHEN @SortBy = 'Order date'
					THEN AllData.OrderStartDateTime
				END ASC
			,CASE 
				WHEN @SortBy = 'Reverse order date'
					THEN AllData.OrderStartDateTime
				END DESC
			,CASE 
				WHEN @SortBy = 'Route'
					THEN AllData.RouteAbbreviation
				END ASC
			,CASE 
				WHEN @SortBy = 'Alphabetical'
					THEN AllData.OrderName
				END ASC
			,CASE 
				WHEN @SortBy = 'Due time'
					THEN DATEDIFF(ss, CAST(CAST(AllData.ScheduledDate AS DATE) AS DATETIME) + CAST(CAST(AllData.Scheduledtime AS TIME(0)) AS DATETIME), GETDATE())
				END
			,CASE 
				WHEN @SortBy = ''
					THEN AllData.ScheduledDate
				END

		--INSERT INTO #ListAdministered
		--SELECT ClientOrderId
		--	,Count(ScheduledTime)
		--	,COUNT(AdministeredTime)
		--FROM #listmedrecords
		--GROUP BY ClientOrderId

		--INSERT INTO #ListAdministered
		--SELECT ClientMedicationId
		--	,Count(ScheduledTime)
		--	,COUNT(AdministeredTime)
		--FROM #listmedrecords
		--GROUP BY ClientMedicationId

		--UPDATE R
		--SET R.IsDiscontinuedOrCompleted = 'Y'
		--FROM #listmedrecords R
		--INNER JOIN #ListAdministered L ON R.ClientOrderId = L.ClientOrderId
		--INNER JOIN ClientOrders CO ON CO.ClientOrderId = R.ClientOrderId
		--	AND ISNULL(CO.RecordDeleted, 'N') = 'N'
		--	AND cast(CO.OrderEndDateTime AS DATE) = R.ScheduledDate
		--WHERE L.ScheduleCount = L.AdministeredCount
		--	AND L.ScheduleCount > 0

		--UPDATE R
		--SET R.IsDiscontinuedOrCompleted = 'Y'
		--FROM #listmedrecords R
		--INNER JOIN ClientMedications CO ON CO.ClientMedicationId = R.ClientMedicationId
		--	AND ISNULL(CO.RecordDeleted, 'N') = 'N'
		----and cast(CO.OrderEndDateTime as DATE)=R.ScheduledDate                      
		--WHERE CO.Discontinued = 'Y'	

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
								FROM #ListMedRecords CM1
								INNER JOIN MedAdminRecords MA ON MA.ClientOrderId = CM1.ClientOrderId
									AND MA.AdministeredTime IS NOT NULL
								LEFT JOIN GlobalCodes AS GC ON GC.GlobalCodeId = MA.STATUS
									AND ISNULL(GC.RecordDeleted, 'N') = 'N'
								WHERE MA.ClientOrderId = CM.ClientOrderId
									AND (
										ISNULL(DATEDIFF(hh, CAST(CAST(MA.AdministeredDate AS DATE) AS DATETIME) +CAST(CAST(MA.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0))AS DATETIME)), 0) <= 24
										AND (ISNULL(DATEDIFF(hh, CAST(CAST(MA.AdministeredDate AS DATE) AS DATETIME) + CAST(CAST(MA.AdministeredTime AS TIME(0)) AS DATETIME), CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(CAST(GETDATE() AS TIME(0))AS DATETIME)), 0) >= 0
											)
										)
									AND ISNULL(MA.RecordDeleted, 'N') = 'N'
								FOR XML PATH('')
								), '&lt;', '<'), '&gt;', '>'), '')
				)
		FROM #ListMedRecords CM
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
		FROM #ListMedRecords CM
		WHERE CM.DispenseHistory24 <> ''
			------ Update RxFlag flag                      
			----UPDATE R                      
			----SET R.RxFlag='N'                      
			----From #listmedrecords R                       
			----Where exists( Select 1 from InboundMedications IM                      
			----    Where R.ClientOrderId=IM.ClientOrderId                      
			----    and ISNULL(IM.RecordDeleted, 'N') = 'N' )                      
			/*Remove duplicate records from the temp table before processing the table for return*/

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
		FROM #ListMedRecords CM
		WHERE CM.DispenseHistory24 <> ''
		
		UPDATE MAR
		SET MAR.ConsentIsRequired = 'S'
		FROM #ListMedRecords MAR
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
					AND D.ClientId = @ClientId
				WHERE MAR.ClientMedicationId = CM.ClientMedicationId
					---AND (ISNULL(CMC.ConsentEndDate, DATEADD(month, @ConsentDurationMonths, ISNULL(CMCD.ConsentStartDate, CONVERT(DATE, GETDATE(), 101)))) >= CONVERT(DATE, GETDATE(), 101))
				)
		;WITH CTE
		AS (
			SELECT *
				,ROW_NUMBER() OVER (
					PARTITION BY MedAdminRecordId ORDER BY InboundMedicationId DESC
					) AS Rn
			FROM #ListMedRecords
			)
		DELETE
		FROM CTE
		WHERE Rn > 1

		INSERT INTO #Questions
		SELECT DISTINCT OQ.QuestionId
			,CO.ClientOrderId
			,LMR.MedAdminRecordId
			,OQ.Question
			,(
				CASE 
					WHEN (
							CQ.AnswerType = 8535
							OR CQ.AnswerType = 8536
							OR CQ.AnswerType = 8538
							)
						THEN GC.CodeName
					ELSE (
							CASE 
								WHEN (
										CQ.AnswerType = 8537
										OR CQ.AnswerType = 8537
										OR CQ.AnswerType = 8539
										)
									THEN CQ.AnswerText
								ELSE CASE 
										WHEN CQ.AnswerType = 8540
											THEN CONVERT(VARCHAR(10), CQ.AnswerDateTime, 101)
										ELSE (
												CASE 
													WHEN RIGHT(CONVERT(VARCHAR, CQ.AnswerDateTime, 100), 8) = ' 12:00AM'
														THEN CONVERT(VARCHAR, CQ.AnswerDateTime, 101)
													ELSE CONVERT(VARCHAR, CQ.AnswerDateTime, 101) + ' ' + RIGHT('0' + LTRIM(RIGHT(CONVERT(VARCHAR, CQ.AnswerDateTime, 0), 7)), 7)
													END
												)
										END
								END
							)
					END
				) AS answer
		FROM OrderQuestions OQ
		JOIN ClientOrders CO ON OQ.Orderid = CO.OrderId
		JOIN dbo.ClientOrderQnAnswers CQ ON CQ.QuestionId = OQ.QuestionId
			AND CO.ClientOrderId = CQ.ClientOrderId
		LEFT JOIN GlobalCodes GC ON Gc.GlobalCodeId = CQ.AnswerValue
			AND ISNULL(Gc.RecordDeleted, 'N') <> 'Y'
		JOIN MedAdminRecords MAR ON MAR.ClientOrderId = CO.ClientOrderId
		JOIN #ListMedRecords LMR ON LMR.MedAdminRecordId = MAR.MedAdminRecordId
		WHERE ISNULL(OQ.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(CQ.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(CO.RecordDeleted, 'N') <> 'Y'

		UPDATE LMAR
		SET QnA = REPLACE(REPLACE(STUFF((
							SELECT DISTINCT ' ' + Convert(VARCHAR(MAX), ROW_NUMBER() OVER (
										ORDER BY QE.ClientOrderId
										)) + '. ' + CASE 
									WHEN RIGHT(RTRIM(QE.Que), 1) = '?'
										THEN QE.Que
									ELSE QE.Que + '?'
									END + ' ' + QE.ans + '</br>'
							FROM #Questions QE
							WHERE LMAR.MedAdminRecordId = QE.MedAdminRecordId
							FOR XML PATH('')
							), 1, 1, ''), '&lt;', '<'), '&gt;', '>')
		FROM #ListMedRecords LMAR
		
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
		--JOIN MDRoutes AS MDR ON MDR.RouteId = MM.RouteId
		--	AND ISNULL(MDR.RecordDeleted, 'N') = 'N'
		WHERE CMI.TitrationStepNumber IS NOT NULL 
		AND EXISTS (SELECT 1 FROM #ListMedRecords LMR 
					WHERE LMR.ClientMedicationId = CM.ClientMedicationId 
						AND ISNULL(IsRxSource, 'N') = 'Y')
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
										+ '</b> ' + TS.Strength + ' '  + TS.StrengthUnitOfMeasure + ' ' + TS.DosageFormAbbreviation + ', ' + LMAR.RouteAbbreviation + ' ' + dbo.ssf_RemoveTrailingZeros(TS.Quantity) + '  '
										+ CAST(CONVERT(VARCHAR(8), TS.StartDate, 1) AS VARCHAR(10)) + ' - ' + CAST(CONVERT(VARCHAR(8), TS.EndDate, 1) AS VARCHAR(10)) 
										+ ' ('+ CAST([Days] AS VARCHAR(3)) + 
										CASE WHEN [Days] = 1 THEN ' Day)' 
											ELSE ' Days)'
											END + '</br>'
							FROM #Titrations TS
							WHERE LMAR.ClientMedicationId = TS.ClientMedicationId
							FOR XML PATH('')
							), 1, 1, ''), '&lt;', '<'), '&gt;', '>')
		FROM #ListMedRecords LMAR
		

		SELECT MedAdminRecordId
			,LstMed.CreatedBy
			,LstMed.CreatedDate
			,LstMed.ModifiedBy
			,LstMed.ModifiedDate
			,LstMed.RecordDeleted
			,LstMed.DeletedDate
			,LstMed.DeletedBy
			, case when LstMed.IsRxSource='Y'
						then  ClientMedicationId else  ClientOrderId end AS ClientOrderId
			,CASE 
				WHEN EXISTS (
						SELECT 1
						FROM GlobalCodes GCT
						WHERE GCT.GlobalCodeId = [STATUS]
							AND GCT.ExternalCode1 = 'Given'
						)
					THEN ISNULL(AdministeredDate, ScheduledDate)
				ELSE ScheduledDate
				END AS ScheduledDate
			,CASE 
				WHEN EXISTS (
						SELECT 1
						FROM GlobalCodes GCT
						WHERE GCT.GlobalCodeId = [STATUS]
							AND GCT.ExternalCode1 = 'Given'
						)
					THEN CONVERT(VARCHAR(5), ISNULL(AdministeredTime, ScheduledTime), 108)
				ELSE CONVERT(VARCHAR(5), ScheduledTime, 108)
				END AS ScheduledTime
			,DualSignRequired
			,AdministeredDate
			,AdministeredTime
			,AdministeredBy
			,[Status]
			,StatusText
			,StatusCode
			,AdministeredDose
			,LstMed.Comment
			,PRNReason
			,NotGivenReason
			,PainId
			,DualSignedbyStaffId
			,DualSignedDate
			,OrigScheduledID
			,IsDiscontinuedOrCompleted
			,MedicationType
			,ScheduleTooltip
			,Strength
			,StrengthUnitOfMeasure
			,IsPRN
			,IsSelfAdministered
			,User2Comments
			,User2PRNReason
			,User2NotGivenReason
			,User2PainId
			,ISNULL(GC2.CodeName, '') AS 'PainName'
			,ISNULL(GC3.CodeName, '') AS 'User2PainName'
			,ISNULL(S.LastName, '') +  ISNULL(',' + S.FirstName, '') AS 'AdministeredName'
			,S1.LastName + ',' + S1.FirstName AS 'DualSignedStaffName'
			,LstMed.IsRxSource
			,AdministrationTimeWindow
			,IsStockMedication
			,MayUseOwnSupply
			,AcknowedgePending
			,MedicationNameId
			,RouteId
			,ConsentIsRequired
			,DispenseBrand
			,NonMedicationOrders
			,OrderId
			,IsQuestionsRequire
			,HazardousMedication
			--,AdministeredUnit                    
			,NoOfDosageForm
			,DosageFormAbbreviation
			--,AdministerInLast24Hours    
			,QnA
			,LstMed.NotCompletedInRx
			,ISNULL(LstMed.ClientMedicationInstructionId, -1) AS ClientMedicationInstructionId
		FROM #ListMedRecords AS LstMed
		LEFT JOIN GlobalCodes AS GC1 ON GC1.GlobalCodeId = LstMed.[Status]
			AND ISNULL(GC1.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes AS GC2 ON GC2.GlobalCodeId = LstMed.PainId
			AND ISNULL(GC2.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes AS GC3 ON GC3.GlobalCodeId = LstMed.User2PainId
			AND ISNULL(GC3.RecordDeleted, 'N') = 'N'
		LEFT JOIN Staff AS S ON S.StaffId = LstMed.AdministeredBy
			AND ISNULL(S.RecordDeleted, 'N') = 'N'
		LEFT JOIN Staff AS S1 ON S1.StaffId = LstMed.DualSignedbyStaffId
			AND ISNULL(S1.RecordDeleted, 'N') = 'N'
		WHERE (
				LstMed.ScheduledTime IS NULL
				OR (ISNULL(DATEDIFF(hh, CAST(CAST(LstMed.ScheduledDate AS DATE) AS DATETIME) + CAST(CAST(LstMed.Scheduledtime AS TIME(0)) AS DATETIME), GETDATE()), 0) <= @OverdueHours)
				OR (
					(ISNULL(DATEDIFF(hh, CAST(CAST(LstMed.ScheduledDate AS DATE) AS DATETIME) + CAST(CAST(LstMed.Scheduledtime AS TIME(0)) AS DATETIME), GETDATE()), 0) > @OverdueHours)
					AND AdministeredTime IS NOT NULL
					)
				)

		--Select Orders Information                       
		SELECT ClientOrderId
			,MedicineDisplay
			,MedicineDisplayAlternate
			,MedicineAdditionalInformation
			,OrderedDate
			,OrderedTime
			,
			--IsDispensedByRx,                       
			SpecialInstructions
			,MedicineRouteOtherInformation
			,IsDiscontinuedOrCompleted
			,MedicationType
			,DualSignRequired
			,OrderStartDateTime
			,RouteAbbreviation
			,ScheduledDate
			,Scheduledtime
			,AdministeredDate
			,AdministeredTime
			,Strength
			,StrengthUnitOfMeasure
			,IsPRN
			,MedicationFrequency
			,IsToAdminister
			,IsSelfAdministered
			,RxFlag
			,MedicationDosage
			,MedicationUnit
			,IsRxSource
			,AdministrationTimeWindow
			,IsStockMedication
			,MayUseOwnSupply
			,AcknowedgePending
			,MedicationNameId AS MedicationNameId
			,RouteId AS RouteId
			,ConsentIsRequired
			,DispenseBrand
			,NonMedicationOrders
			,OrderId
			,IsQuestionsRequire
			,HazardousMedication
			--,AdministeredUnit                    
			--,NoOfDosageForm      
			--,DosageFormAbbreviation      
			--,AdministerInLast24Hours                     
			,DispenseHistory24
			,QnA
			,NotCompletedInRx
			,IsPastDateRecords
			,TitrationSteps
			,ClientMedicationInstructionId
			,Prescribed
			,OtherStrength
		FROM (
			SELECT DISTINCT case when LstMed.IsRxSource='Y'
						then  ClientMedicationId else  ClientOrderId end AS ClientOrderId
				,OrderName + ' ' + ISNULL(Strength, '') + ' ' + ISNULL(StrengthUnitOfMeasure, '') AS 'MedicineDisplay'
				,MedicineDisplayAlternate AS 'MedicineDisplayAlternate'
				,ISNULL(MedicineAdditionalInformation, '') AS MedicineAdditionalInformation
				,CONVERT(VARCHAR(10), OrderStartDateTime, 101) AS 'OrderedDate'
				,SUBSTRING(CONVERT(VARCHAR(8), OrderStartDateTime, 108), 1, 5) AS 'OrderedTime'
				,
				--'' AS 'IsDispensedByRx',                       
				SpecialInstructions
				,ISNULL(MedicineRouteOtherInformation, '') AS MedicineRouteOtherInformation
				,max(IsDiscontinuedOrCompleted) AS IsDiscontinuedOrCompleted
				,MedicationType
				,DualSignRequired
				,OrderStartDateTime
				,RouteAbbreviation
				,max(ScheduledDate) AS ScheduledDate
				,max(Scheduledtime) AS Scheduledtime
				,max(AdministeredDate) AS AdministeredDate
				,max(AdministeredTime) AS AdministeredTime
				,Strength
				,StrengthUnitOfMeasure
				,IsPRN
				,MedicationFrequency
				,CASE 
					WHEN max(AdministeredTime) IS NOT NULL
						AND IsPRN = 'Y'
						AND (ISNULL(DATEDIFF(hh, GETDATE(), dateadd(hh, ROUND(24 / cast(MedicationFrequency AS INT), 0), CAST(CAST(max(AdministeredDate) AS DATE) AS DATETIME) + CAST(CAST(max(AdministeredTime) AS TIME(0)) AS DATETIME))), 0) > 0)
						THEN 'N'
					ELSE 'Y'
					END AS 'IsToAdminister'
				,IsSelfAdministered
				,RxFlag
				,MedicationDosage
				,MedicationUnit
				,LstMed.IsRxSource
				,AdministrationTimeWindow
				,IsStockMedication
				,MayUseOwnSupply
				,AcknowedgePending
				,MedicationNameId
				,RouteId
				,ConsentIsRequired
				,DispenseBrand
				,NonMedicationOrders
				,OrderId
				,IsQuestionsRequire
				,HazardousMedication
				--,AdministeredUnit                    
				--,NoOfDosageForm      
				--,DosageFormAbbreviation      
				--,AdministerInLast24Hours                     
				,DispenseHistory24
				,QnA
				,NotCompletedInRx
				,IsPastDateRecords
				,TitrationSteps
				,ISNULL(ClientMedicationInstructionId, -1) AS ClientMedicationInstructionId
				,Prescribed
				,OtherStrength
			FROM #ListMedRecords AS LstMed
			GROUP BY ClientOrderId
				,ClientMedicationId
				,OrderName
				,MedicineDisplayAlternate
				,MedicineAdditionalInformation
				,SpecialInstructions
				,MedicineRouteOtherInformation
				,MedicationType
				,DualSignRequired
				,OrderStartDateTime
				,RouteAbbreviation
				,Strength
				,StrengthUnitOfMeasure
				,IsPRN
				,MedicationFrequency
				,IsSelfAdministered
				,RxFlag
				,MedicationDosage
				,MedicationUnit
				,AdministrationTimeWindow
				,IsStockMedication
				,MayUseOwnSupply
				,AcknowedgePending
				,MedicationNameId
				,RouteId
				,ConsentIsRequired
				,DispenseBrand
				,NonMedicationOrders
				,OrderId
				,IsQuestionsRequire
				,HazardousMedication
				--,AdministeredUnit        
				--,NoOfDosageForm      
				--,DosageFormAbbreviation      
				--,AdministerInLast24Hours                     
				,DispenseHistory24
				,QnA
				,NotCompletedInRx
				,IsRxSource
				,IsPastDateRecords
				,TitrationSteps
				,ClientMedicationInstructionId
				,Prescribed
				,OtherStrength
			) OrderData
		ORDER BY CASE 
				WHEN @SortBy = 'Order date'
					THEN OrderStartDateTime
				END ASC
			,CASE 
				WHEN @SortBy = 'Reverse order date'
					THEN OrderStartDateTime
				END DESC
			,CASE 
				WHEN @SortBy = 'Route'
					THEN RouteAbbreviation
				END ASC
			,CASE 
				WHEN @SortBy = 'Alphabetical'
					THEN MedicineDisplay
				END ASC
			,CASE 
				WHEN @SortBy = 'Due time'
					THEN DATEDIFF(ss, CAST(CAST(ScheduledDate AS DATE) AS DATETIME) + CAST(CAST(Scheduledtime AS TIME(0)) AS DATETIME) , GETDATE())
				END
			,CASE 
				WHEN @SortBy = ''
					THEN ScheduledDate
				END

		-- Shift details                       
		SELECT MARNoteId
			,M.CreatedBy
			,M.CreatedDate
			,M.ModifiedBy
			,M.ModifiedDate
			,M.RecordDeleted
			,M.DeletedDate
			,M.DeletedBy
			,M.ShiftDate
			,M.ShiftTime
			,M.ShiftNotes
			,C.ClientId
			,M.LoggedInUser
			,CONVERT(VARCHAR(10), C.DOB, 101) AS DOB
			,ISNULL(NoKnownAllergies, 'N') AS NoKnownAllergies
		FROM Clients C
		LEFT JOIN MARNotes M ON C.ClientId = M.ClientId
			AND (ISNULL(M.RecordDeleted, 'N') = 'N')
		WHERE (C.ClientId = @ClientId)
			AND (ISNULL(C.RecordDeleted, 'N') = 'N')

		-- Overdue Medications                       
		INSERT INTO #ListOverdueMedication
		SELECT MA.MedAdminRecordId
			,O.OrderName
			,CONVERT(VARCHAR(10), MA.ScheduledDate, 101) AS 'DueDate'
			,SUBSTRING(CONVERT(VARCHAR(8), MA.ScheduledTime, 108), 1, 5) AS 'DueTime'
			,('div_' + CONVERT(VARCHAR(15), CO.ClientOrderId) + '_' + SUBSTRING(convert(VARCHAR(10), cast(MA.ScheduledDate AS DATE), 103), 1, 2) + '_' + SUBSTRING(CONVERT(VARCHAR(8), MA.ScheduledTime, 108), 1, 2)) AS 'OverdueSchedule'
			,CO.OrderType
			,CO.ClientOrderId
		FROM MedAdminRecords AS MA
		INNER JOIN ClientOrders AS CO ON MA.ClientOrderId = CO.ClientOrderId
			AND ISNULL(CO.RecordDeleted, 'N') = 'N'
			AND (ISNULL(MA.RecordDeleted, 'N') = 'N')
			AND isnull(CO.OrderDiscontinued, 'N') <> 'Y'
			AND ISNULL(CO.OrderPendAcknowledge, 'N') = 'N'
		INNER JOIN Clients AS C ON C.ClientId = CO.ClientId
			AND ISNULL(C.RecordDeleted, 'N') = 'N'
		INNER JOIN Orders AS O ON CO.OrderId = O.OrderId
			AND ISNULL(O.RecordDeleted, 'N') = 'N'
			AND ISNULL(O.Active, 'Y') = 'Y'
		--INNER JOIN OrderFrequencies AS OFS ON OFS.OrderFrequencyId = CO.OrderFrequencyId                    
		-- AND ISNULL(OFS.RecordDeleted, 'N') = 'N'                    
		INNER JOIN OrderTemplateFrequencies AS OTF ON OTF.OrderTemplateFrequencyId = CO.OrderTemplateFrequencyId
			AND ISNULL(OTF.RecordDeleted, 'N') = 'N'
		INNER JOIN GlobalCodes AS GC1 ON GC1.GlobalCodeId = OTF.TimesPerDay
			AND ISNULL(GC1.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes AS GC2 ON GC2.GlobalCodeId = O.AdministrationTimeWindow
			AND ISNULL(GC2.RecordDeleted, 'N') = 'N'
		WHERE MA.AdministeredDate IS NULL
			AND MA.Scheduledtime IS NOT NULL
			AND MA.ClientMedicationInstructionId IS NULL
			AND (CO.ClientId = @ClientId)
			AND (ISNULL(CO.ConsentIsRequired, 'N') = 'N' OR ISNULL(CO.ConsentIsRequired, 'N') = 'S')
			-- Gautam 09th Apr,14                    
			--AND (O.DualSignRequired='Y' and                     
			--DATEDIFF(mi, CAST(CAST(MA.ScheduledDate AS DATE) AS DATETIME) + CAST(MA.Scheduledtime AS TIME(0)), GETDATE()) >=  case when ISNULL(GC2.CodeName,0) =0 then 60 else GC2.CodeName end                    
			--or ISnull(O.DualSignRequired,'N')='N' and                     
			--Commented above lines as AdministrationTimeWindow is specified order level : PPOTNURU 18/09/2014                    
			AND (
				DATEDIFF(mi, CAST(CAST(MA.ScheduledDate AS DATE) AS DATETIME) + CAST(CAST(MA.Scheduledtime AS TIME(0)) AS DATETIME), GETDATE()) >= CASE 
					WHEN ISNULL(GC2.CodeName, 0) = 0
						THEN 60
					ELSE GC2.CodeName
					END
				)
			AND ISNULL(DATEDIFF(hh, CAST(CAST(MA.ScheduledDate AS DATE) AS DATETIME) + CAST(CAST(MA.Scheduledtime AS TIME(0)) AS DATETIME), GETDATE()), 0) <= @OverdueHours
			--AND (
			--		@Display = 'All'
			--		OR @Display = 'PRN'
			--		OR @Display = 'Scheduled'
			--		OR @Display = 'One Time Only' --Seema 03-Mar-2016    
			--		)
			--	AND ISNULL(CO.IsPRN, 'N') <> 'Y'
		
		UNION
		
		SELECT MA.MedAdminRecordId
			,MN.MedicationName
			,CONVERT(VARCHAR(10), MA.ScheduledDate, 101) AS 'DueDate'
			,SUBSTRING(CONVERT(VARCHAR(8), MA.ScheduledTime, 108), 1, 5) AS 'DueTime'
			,('div_' + CONVERT(VARCHAR(15), CM.ClientMedicationId) + '_' + SUBSTRING(convert(VARCHAR(10), cast(MA.ScheduledDate AS DATE), 103), 1, 2) + '_' + SUBSTRING(CONVERT(VARCHAR(8), MA.ScheduledTime, 108), 1, 2)) AS 'OverdueSchedule'
			,'Medication'
			,CM.ClientMedicationId
		FROM MedAdminRecords AS MA
		INNER JOIN ClientMedications AS CM ON MA.ClientMedicationId = CM.ClientMedicationId
			AND ISNULL(CM.RecordDeleted, 'N') = 'N'
			AND (ISNULL(MA.RecordDeleted, 'N') = 'N')
			AND isnull(CM.Discontinued, 'N') <> 'Y'
			AND ISNULL(CM.SmartCareOrderEntry, 'N') = 'N'  
		INNER JOIN Clients AS C ON C.ClientId = CM.ClientId
			AND ISNULL(C.RecordDeleted, 'N') = 'N'
		INNER JOIN MDMedicationNames MN ON CM.MedicationNameId = MN.MedicationNameId
			AND ISNULL(MN.RecordDeleted, 'N') = 'N'
		INNER JOIN ClientMedicationInstructions AS CMI ON CM.ClientMedicationId = CMI.ClientMedicationId
			AND ISNULL(CMI.RecordDeleted, 'N') = 'N'
			AND ISNULL(CMI.Active, 'Y') = 'Y'
		WHERE MA.AdministeredDate IS NULL
			AND MA.Scheduledtime IS NOT NULL
			AND (CM.ClientId = @ClientId)
			AND DATEDIFF(mi, CAST(CAST(MA.ScheduledDate AS DATE) AS DATETIME) + CAST(CAST(MA.Scheduledtime AS TIME(0))AS DATETIME), GETDATE()) >= @MinutesBeforeOverdue
			AND ISNULL(DATEDIFF(hh, CAST(CAST(MA.ScheduledDate AS DATE) AS DATETIME) + CAST(CAST(MA.Scheduledtime AS TIME(0))AS DATETIME), GETDATE()), 0) <= @OverdueHours
			--AND (
			--	(
			--		@Display = 'All'
			--		OR @Display = 'PRN'
			--		OR @Display = 'Scheduled'
			--		OR @Display = 'One Time Only' --Seema 03-Mar-2016     
			--		)
			--	AND CMI.Schedule NOT IN (
			--		4866
			--		,50488
			--		,50510
			--		)
			--	)

		SELECT DISTINCT (MedAdminRecordId)
			,OrderName
			,DueDate
			,DueTime
			,OverdueSchedule
			,OrderType
			,ClientOrderId
		FROM #ListOverdueMedication

		--------------------------                    
		-- Allergies Name                      
		-- 11th Dec  2014          Hemant                    
		/*                
  DECLARE @ToolTip VARCHAR(MAX)                    
                    
  SET @ToolTip = ''                    
                    
  SELECT @ToolTip = @ToolTip + MDA.ConceptDescription + ' <br/>'                    
  FROM MDAllergenConcepts MDA                    
  INNER JOIN ClientAllergies CA ON CA.AllergenConceptId = MDA.AllergenConceptId                    
   AND CA.ClientId = @ClientId                    
   AND ISNULL(CA.RecordDeleted, 'N') = 'N'                    
   AND ISNULL(MDA.RecordDeleted, 'N') = 'N'                    
   AND ISNULL(CA.Active, 'Y') = 'Y'                    
  ORDER BY MDA.ConceptDescription                    
  */
		DECLARE @ToolTip VARCHAR(MAX) = ''

		CREATE TABLE #Allergy (
			ConceptDescription VARCHAR(MAX)
			,ALLERGYNAME VARCHAR(100)
			)

		INSERT INTO #Allergy
		SELECT MDA.ConceptDescription + ' (' + CASE 
				WHEN ISNULL(CA.AllergyType, '') = 'A'
					THEN 'Allergy'
				WHEN ISNULL(CA.AllergyType, '') = 'I'
					THEN 'Intolerance'
				WHEN ISNULL(CA.AllergyType, '') = 'F'
					THEN 'Failed Trials'
				ELSE ''
				END + ')' + CASE 
				WHEN CA.Comment IS NOT NULL
					THEN ' - ' + SUBSTRING(CA.Comment, 0, 100)
				ELSE ''
				END + '<br/>'
			,MDA.ConceptDescription
		FROM MDAllergenConcepts MDA
		INNER JOIN ClientAllergies CA ON CA.AllergenConceptId = MDA.AllergenConceptId
			AND CA.ClientId = @ClientId
			AND ISNULL(CA.RecordDeleted, 'N') = 'N'
			AND ISNULL(MDA.RecordDeleted, 'N') = 'N'
			AND ISNULL(CA.Active, 'Y') = 'Y'
		ORDER BY MDA.ConceptDescription

		SELECT @ToolTip = @ToolTip + ConceptDescription
		FROM #Allergy
		ORDER BY ALLERGYNAME

		SELECT @ToolTip AS Allergy

		-- 11th Dec  2014          Hemant                    
		-------------------------------------                    
		-- Allergies Name                       
		--SELECT CASE                     
		--  WHEN MDA.ConceptDescription IS NULL                    
		--   THEN ''                    
		--  ELSE MDA.ConceptDescription + ' <br/>'                    
		--  END AS Allergy                    
		--FROM MDAllergenConcepts MDA                    
		--INNER JOIN ClientAllergies CA ON CA.AllergenConceptId = MDA.AllergenConceptId                    
		-- AND CA.ClientId = @ClientId                    
		-- AND ISNULL(CA.RecordDeleted, 'N') = 'N'                    
		-- AND ISNULL(MDA.RecordDeleted, 'N') = 'N'                    
		-- AND ISNULL(CA.Active, 'Y') = 'Y'                    
		--ORDER BY MDA.ConceptDescription                    
		-- PRN Administer gap time                      
		INSERT INTO #ClientAdministerTime
		SELECT DISTINCT case when IsRxSource='Y'
						then  ClientMedicationId else  ClientOrderId end AS ClientOrderId
			,CAST(CAST(max(AdministeredDate) AS DATE) AS DATETIME) + CAST(CAST(max(AdministeredTime) AS TIME(0)) AS DATETIME) AS 'AdministeredDate'
			,dateadd(hh, ROUND(24 / cast(MedicationFrequency AS INT), 0) - 1, CAST(CAST(max(AdministeredDate) AS DATE) AS -- -1 to reduce 1 day                      
					DATETIME) + CAST(CAST(max(AdministeredTime) AS TIME(0)) AS DATETIME)) AS 'NextAdministeredDate'
			,ISNULL(ClientMedicationInstructionId, -1) AS ClientMedicationInstructionId
		FROM #ListMedRecords
		WHERE AdministeredTime IS NOT NULL
			AND IsPRN = 'Y'
			AND ClientOrderId IS NOT NULL
		--and Status in (SELECT Globalcodeid from GlobalCodes where (CodeName='Given' or CodeName='Self-Administered') AND Category='MARStatus' AND ISNULL(RecordDeleted,'N')<>'Y')                       
		GROUP BY ClientOrderId
			,ClientMedicationId
			,MedicationFrequency
			,IsRxSource
			,ClientMedicationInstructionId

		SELECT CONVERT(VARCHAR(10), GCO.ScheduledDate, 101) AS 'GapDate'
			,SUBSTRING(CONVERT(VARCHAR(8), GCO.ScheduledDate, 108), 1, 5) AS 'GapTime'
			,('div_' + CONVERT(VARCHAR(15), GCO.ClientOrderId) + '_' + SUBSTRING(convert(VARCHAR(10), cast(GCO.ScheduledDate AS DATE), 103), 1, 2) + '_' + SUBSTRING(CONVERT(VARCHAR(8), GCO.ScheduledDate, 108), 1, 2) + '_' + CAST(CAT.ClientMedicationInstructionId AS VARCHAR(10))) AS 'GapSchedule'
		FROM #ClientAdministerTime CAT
		CROSS APPLY dbo.ssf_GenerateClientOrderAdminsterGap(CAT.ClientOrderId, CAT.AdministerDate, CAT.NextAdministeredDate, 'hh') AS GCO
		
		 
 
		SELECT TOP 1 @PermissionTemplateId =  GlobalCodeID
		FROM GlobalCodes
		WHERE Code = 'OverrideMARDispenseTimes'
			AND Category = 'STAFFLIST'
			AND ISNULL(RecordDeleted, 'N') = 'N'

		SELECT @OverrideMARDispenseTime = CASE 
				WHEN EXISTS (
						SELECT 1
						FROM ViewStaffPermissions vs
						WHERE vs.permissionitemid = @PermissionTemplateId
							AND vs.StaffId = @StaffId
						)
					THEN 'Y'
				ELSE 'N'
				END 
		
		SELECT ISNULL(@OverrideMARDispenseTime, 'N') AS OverrideMARDispenseTime
		
		SELECT 0 AS PageNumber
			,0 AS NumberOfPages
			,ISNULL((
					SELECT COUNT(*)
					FROM #listmedrecords
					), 0) AS NumberOfRows

		--For other filter                           
		DECLARE @CustomFilters TABLE (MARId INT)
		DECLARE @CustomFiltersApplied CHAR(1)

		IF @OtherFilter > 10000
		BEGIN
			SET @CustomFiltersApplied = 'Y'

			INSERT INTO @CustomFilters (MARId)
			EXEC SCSP_LISTPAGEMAR @ClientId = @ClientId
				,@ShiftDate = @ShiftDate
				,@ShiftStartTime = @ShiftStartTime
				,@ShiftEndTime = @ShiftEndTime
				,@Display = @Display
				,@SortBy = @SortBy
				,@OtherFilter = @OtherFilter
		END

		DROP TABLE #listmedrecords

		--DROP TABLE #ListAdministered

		DROP TABLE #ClientAdministerTime
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_GetMARDetails') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + 
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



GO



