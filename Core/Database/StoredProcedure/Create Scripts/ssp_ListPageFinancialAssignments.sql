IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageFinancialAssignments]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_ListPageFinancialAssignments]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_ListPageFinancialAssignments] (
	@PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@StaffId INT
	,@Status INT
	,@PayerType INT
	,@PayerId INT
	,@ProcedureCodeId INT
	,@AssignmentType INT
	,@CoveragePlanId INT
	,@ErrorReason INT
	,@ProgramId INT
	,@ServiceAreaId INT
	,@LocationId INT
	,@DenialReason INT
	,@AssignmentName VARCHAR(250)
	,@OtherFilter INT
	,@AllPurposes CHAR(1)
	,@RWQMAssignmentstaff INT
	,@primaryClinicianId INT = NULL
	)
	/********************************************************************************                                                   
** Stored Procedure: ssp_ListPageFinancialAssignments                                                      
**                                                    
** Copyright: Streamline Healthcate Solutions                                                      
** Updates:                                                                                                           
** Date            Author              Purpose     
** 25-Mar-2015    Veena      What:Get Financial Assignment ListPage Data        
**            Why:Valley Customizations #950    
** 06-Nov-2015    Revathi		what:PaymentCoveragePlan,Payer added in Payment
								Why:Valley Customizations #950 
** 16-Dec-2015    Revathi		what:Added Assignment Groupname and @AssignmentType condition in all the filter 
								Why:task #950 Valley Client Acceptance Testing Issues	
** 16-June-2017   Ajay			what: Added All purpose filter,RWQMAssignmentstaff filter
								Why: AHN Customization #Task:44													
*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		DECLARE @CustomFiltersApplied CHAR(1) = 'N'
		DECLARE @ApplyFilterClick AS CHAR(1)

		SET @SortExpression = RTRIM(LTRIM(@SortExpression))

		IF ISNULL(@SortExpression, '') = ''
			SET @SortExpression = 'FinancialAssignmentId desc'

		CREATE TABLE #ResultSet (
			FinancialAssignmentId INT
			,AssignmentName VARCHAR(500)
			,StaffName VARCHAR(500)
			,StaffName5 VARCHAR(500)			
			,RWQMAssigned VARCHAR(500)
			,ListPageFilter Char(3)
			,RevenueWorkQueueManagement Char(3)
			)

		CREATE TABLE #CustomFilters (FinancialAssignmentId INT)

		--Get custom filters                                                      
		IF @OtherFilter > 10000
		BEGIN
			IF OBJECT_ID('dbo.scsp_ListPageFinancialAssignments', 'P') IS NOT NULL
			BEGIN
				SET @CustomFiltersApplied = 'Y'

				INSERT INTO #CustomFilters (FinancialAssignmentId)
				EXEC scsp_ListPageFinancialAssignments @StaffId = @StaffId
					,@Status = @Status
					,@PayerType = @PayerType
					,@PayerId = @PayerId
					,@ProcedureCodeId = @ProcedureCodeId
					,@AssignmentType = @AssignmentType
					,@CoveragePlanId = @CoveragePlanId
					,@ErrorReason = @ErrorReason
					,@ProgramId = @ProgramId
					,@ServiceAreaId = @ServiceAreaId
					,@LocationId = @LocationId
					,@DenialReason = @DenialReason
					,@AssignmentName = @AssignmentName
					,@OtherFilter = @OtherFilter
			END
		END

		CREATE TABLE #Staff (
			FinancialAssignmentId INT
			,StaffName VARCHAR(500)
			,StaffId INT
			)

		INSERT INTO #Staff
		SELECT DISTINCT FA.FinancialAssignmentId
			,ISNULL(SF.LastName, '') + ', ' + ISNULL(SF.FirstName, '') AS StaffName
			,SF.Staffid
		FROM FinancialAssignments FA
		INNER JOIN Staff SF ON SF.FinancialAssignmentId = FA.FinancialAssignmentId
		ORDER BY StaffName
		
		 ----added by Ajay on  16-June-2017
		  CREATE TABLE #RWQMAssignmentStaff (  
		   FinancialAssignmentId INT  
		   ,StaffName VARCHAR(500)  
		   ,RWQMAssignmentStaffId INT  
		   )  
		  
		  INSERT INTO #RWQMAssignmentStaff  
		  SELECT DISTINCT FA.FinancialAssignmentId  
		   ,ISNULL(SF.LastName, '') + ', ' + ISNULL(SF.FirstName, '') AS StaffName  
		   ,SF.Staffid  
		  FROM FinancialAssignments FA  
		  INNER JOIN Staff SF ON SF.StaffId = FA.RWQMAssignedId  
		  ORDER BY StaffName  

		INSERT INTO #ResultSet (
			FinancialAssignmentId
			,AssignmentName
			,StaffName
			,StaffName5
			,RWQMAssigned                    --added by Ajay on  16-June-2017
			,ListPageFilter 
			,RevenueWorkQueueManagement 
			)
		SELECT FA.FinancialAssignmentId
			,FA.AssignmentName
			,STUFF((
					SELECT DISTINCT '; ' + StaffName
					FROM #Staff TS
					WHERE TS.FinancialAssignmentId = FA.FinancialAssignmentId
					FOR XML PATH('')
						,TYPE
					).value('.[1]', 'nvarchar(max)'), 1, 2, '') AS StaffName
			,STUFF((
					SELECT DISTINCT TOP 5 '; ' + StaffName
					FROM #Staff TS
					WHERE TS.FinancialAssignmentId = FA.FinancialAssignmentId
					FOR XML PATH('')
						,TYPE
					).value('.[1]', 'nvarchar(max)'), 1, 2, '') AS StaffName5
			,STUFF((
					SELECT DISTINCT '; ' + StaffName
					FROM #RWQMAssignmentStaff TS
					WHERE TS.RWQMAssignmentStaffId = FA.RWQMAssignedId
					FOR XML PATH('')
						,TYPE
					).value('.[1]', 'nvarchar(max)'), 1, 2, '') AS RWQMAssigned
			,Case ListPageFilter 
			When 'Y' then 'Yes'
			When 'N' then 'No'
			else 'No' End As ListPageFilter
			,Case RevenueWorkQueueManagement 
			When 'Y' then 'Yes'
			When 'N' then 'No'
			else 'No' End As RevenueWorkQueueManagement 
		FROM FinancialAssignments FA
		WHERE (
				(
					@CustomFiltersApplied = 'Y'
					AND EXISTS (
						SELECT *
						FROM #CustomFilters cf
						WHERE cf.FinancialAssignmentId = FA.FinancialAssignmentId
						)
					)
				OR (
					@CustomFiltersApplied = 'N'
					AND (
						isnull(@Status, - 1) = - 1
						OR --   All Status       
						(
							@Status = 1
							AND FA.Active = 'Y'
							)
						OR --   Active                   
						(
							@Status = 2
							AND isnull(FA.Active, 'N') = 'N'
							)
						)
					)
				AND ISNULL(FA.RecordDeleted, 'N') = 'N'
				AND (
					ISNULL(@StaffId,-1) = -1 
					OR EXISTS (
						SELECT 1
						FROM #staff S
						WHERE S.StaffId = @StaffId
							AND S.FinancialAssignmentId = FA.FinancialAssignmentId
						)
					)
				  ----added by Ajay on  16-June-2017
				AND (  
					 ISNULL(@RWQMAssignmentstaff,-1) = -1  
					 OR EXISTS (  
					  SELECT 1  
					  FROM #RWQMAssignmentStaff S  
					  WHERE S.RWQMAssignmentStaffId = @RWQMAssignmentstaff  
					   AND S.FinancialAssignmentId = FA.FinancialAssignmentId  
					  )  
					 )  
					AND (  
					 ISNULL(@AllPurposes,'') = ''    
					 OR (@AllPurposes='L' AND  FA.ListPageFilter='Y')  
					 OR  (@AllPurposes='R' AND FA.RevenueWorkQueueManagement='Y')  
					 )     
					 --end  
				AND (
					isnull(@AssignmentName, '') = ''
					OR FA.AssignmentName LIKE '%' + @AssignmentName + '%'
					)
				AND (
					--Modified by Revathi 16-Dec-2015
					@ProgramId = - 1
					OR (
						(
							(
								ISNULL(FA.ChargeProgram, '') <> ''
								AND ISNULL(FA.AllChargeProgram, 'N') = 'N'
								)
							OR (
								ISNULL(FA.PaymentProgram, '') <> ''
								AND ISNULL(FA.AllPaymentProgram, 'N') = 'N'
								)
							OR (
								ISNULL(FA.ServiceProgram, '') <> ''
								AND ISNULL(FA.AllServiceProgram, 'N') = 'N'
								)
							)
						AND EXISTS (
							SELECT 1
							FROM FinancialAssignmentPrograms FPR
							WHERE FPR.FinancialAssignmentId = FA.FinancialAssignmentId
								AND FPR.ProgramId = @ProgramId
								AND ISNULL(FPR.RecordDeleted, 'N') = 'N'
								AND (
									@AssignmentType = - 1
									OR FPR.AssignmentType = @AssignmentType
									)
							)
						)
					OR (
						(
							ISNULL(FA.ChargeProgram, '') <> ''
							AND ISNULL(FA.AllChargeProgram, 'N') = 'Y'
							)
						OR (
							ISNULL(FA.PaymentProgram, '') <> ''
							AND ISNULL(FA.AllPaymentProgram, 'N') = 'Y'
							)
						OR (
							ISNULL(FA.ServiceProgram, '') <> ''
							AND ISNULL(FA.AllServiceProgram, 'N') = 'Y'
							)
						)
					)
				AND (
					@PayerType = - 1
					OR (
						(
							(
								ISNULL(FA.ChargePayerType, '') <> ''
								AND ISNULL(FA.AllChargePayerType, 'N') = 'N'
								)
							OR (
								ISNULL(FA.PaymentPayerType, '') <> ''
								AND ISNULL(FA.AllPaymentPayerType, 'N') = 'N'
								)
							)
						AND EXISTS (
							SELECT 1
							FROM FinancialAssignmentPayerTypes FPR
							WHERE FPR.FinancialAssignmentId = FA.FinancialAssignmentId
								AND FPR.PayerTypeId = @PayerType
								AND ISNULL(FPR.RecordDeleted, 'N') = 'N'
								AND (
									@AssignmentType = - 1
									OR FPR.AssignmentType = @AssignmentType
									)
							)
						)
					OR (
						(
							ISNULL(FA.ChargePayerType, '') <> ''
							AND ISNULL(FA.AllChargePayerType, 'N') = 'Y'
							)
						OR (
							ISNULL(FA.PaymentPayerType, '') <> ''
							AND ISNULL(FA.AllPaymentPayerType, 'N') = 'Y'
							)
						)
					)
				AND (
					@PayerId = - 1
					OR (
						(
							(
								ISNULL(AllChargePayer, 'N') = 'N'
								AND ISNULL(FA.ChargePayer, '') <> ''
								)
							OR (
								ISNULL(AllPaymentPayer, 'N') = 'N'
								AND ISNULL(FA.PaymentPayer, '') <> ''
								)
							)
						AND EXISTS (
							SELECT 1
							FROM FinancialAssignmentPayers FPR
							WHERE FPR.FinancialAssignmentId = FA.FinancialAssignmentId
								AND FPR.PayerId = @PayerId
								AND ISNULL(FPR.RecordDeleted, 'N') = 'N'
								AND (
									@AssignmentType = - 1
									OR FPR.AssignmentType = @AssignmentType
									)
							)
						)
					OR (
						(
							ISNULL(AllChargePayer, 'N') = 'Y'
							AND ISNULL(FA.ChargePayer, '') <> ''
							)
						OR (
							ISNULL(AllPaymentPayer, 'N') = 'Y'
							AND ISNULL(FA.PaymentPayer, '') <> ''
							)
						)
					)
				AND (
					@CoveragePlanId = - 1
					OR (
						(
							(
								ISNULL(FA.ChargePlan, '') <> ''
								AND ISNULL(FA.AllChargePlan, 'N') = 'N'
								)
							OR (
								ISNULL(FA.PaymentPlan, '') <> ''
								AND ISNULL(FA.AllPaymentPlan, 'N') = 'N'
								)
							)
						AND EXISTS (
							SELECT 1
							FROM FinancialAssignmentPlans FPR
							WHERE FPR.FinancialAssignmentId = FA.FinancialAssignmentId
								AND FPR.CoveragePlanId = @CoveragePlanId
								AND (
									@AssignmentType = - 1
									OR FPR.AssignmentType = @AssignmentType
									)
								AND ISNULL(FPR.RecordDeleted, 'N') = 'N'
							)
						)
					OR (
						(
							ISNULL(FA.ChargePlan, '') <> ''
							AND ISNULL(FA.AllChargePlan, 'N') = 'Y'
							)
						OR (
							ISNULL(FA.PaymentPlan, '') <> ''
							AND ISNULL(FA.AllPaymentPlan, 'N') = 'Y'
							)
						)
					)
				AND (
					@LocationId = - 1
					OR (
						(
							(
								ISNULL(FA.ChargeLocation, '') <> ''
								AND ISNULL(FA.AllChargeLocation, 'N') = 'N'
								)
							OR (
								ISNULL(FA.PaymentLocation, '') <> ''
								AND ISNULL(FA.AllPaymentLocation, 'N') = 'N'
								)
							OR (
								ISNULL(FA.ServiceLocation, '') <> ''
								AND ISNULL(FA.AllServiceLocation, 'N') = 'N'
								)
							)
						AND EXISTS (
							SELECT 1
							FROM FinancialAssignmentLocations FPR
							WHERE FPR.FinancialAssignmentId = FA.FinancialAssignmentId
								AND FPR.LocationId = @LocationId
								AND ISNULL(FPR.RecordDeleted, 'N') = 'N'
								AND (
									@AssignmentType = - 1
									OR FPR.AssignmentType = @AssignmentType
									)
							)
						)
					OR (
						(
							ISNULL(FA.ChargeLocation, '') <> ''
							AND ISNULL(FA.AllChargeLocation, 'N') = 'Y'
							)
						OR (
							ISNULL(FA.PaymentLocation, '') <> ''
							AND ISNULL(FA.AllPaymentLocation, 'N') = 'Y'
							)
						OR (
							ISNULL(FA.ServiceLocation, '') <> ''
							AND ISNULL(FA.AllServiceLocation, 'N') = 'Y'
							)
						)
					)
				AND (
					@ErrorReason = - 1
					OR (
						(
							ISNULL(FA.ChargeErrorReason, '') <> ''
							AND ISNULL(FA.AllChargeErrorReason, 'N') = 'N'
							)
						AND EXISTS (
							SELECT 1
							FROM FinancialAssignmentErrorReasons FPR
							WHERE FPR.FinancialAssignmentId = FA.FinancialAssignmentId
								AND FPR.ErrorReasonId = @ErrorReason
								AND ISNULL(FPR.RecordDeleted, 'N') = 'N'
								AND (
									@AssignmentType = - 1
									OR FPR.AssignmentType = @AssignmentType
									)
							)
						)
					OR (
						ISNULL(FA.ChargeErrorReason, '') <> ''
						AND ISNULL(FA.AllChargeErrorReason, 'N') = 'Y'
						)
					)
				AND (
					@ProcedureCodeId = - 1
					OR (
						(
							(
								ISNULL(FA.ChargeProcedureCode, '') <> ''
								AND ISNULL(FA.AllChargeProcedureCode, 'N') = 'N'
								)
							OR (
								ISNULL(FA.ServiceProcedureCode, '') <> ''
								AND ISNULL(FA.AllServiceProcedureCode, 'N') = 'N'
								)
							)
						AND EXISTS (
							SELECT 1
							FROM FinancialAssignmentProcedureCodes FPR
							WHERE FPR.FinancialAssignmentId = FA.FinancialAssignmentId
								AND FPR.ProcedureCodeId = @ProcedureCodeId
								AND ISNULL(FPR.RecordDeleted, 'N') = 'N'
								AND (
									@AssignmentType = - 1
									OR FPR.AssignmentType = @AssignmentType
									)
							)
						)
					OR (
						(
							ISNULL(FA.ChargeProcedureCode, '') <> ''
							AND ISNULL(FA.AllChargeProcedureCode, 'N') = 'Y'
							)
						OR (
							ISNULL(FA.ServiceProcedureCode, '') <> ''
							AND ISNULL(FA.AllServiceProcedureCode, 'N') = 'Y'
							)
						)
					)
				AND (
					@ServiceAreaId = - 1
					OR (
						(
							(
								ISNULL(FA.ChargeServiceArea, '') <> ''
								AND ISNULL(FA.AllChargeServiceArea, 'N') = 'N'
								)
							OR (
								ISNULL(FA.PaymentServiceArea, '') <> ''
								AND ISNULL(FA.AllPaymentServiceArea, 'N') = 'N'
								)
							OR (
								ISNULL(FA.ServiceServiceArea, '') <> ''
								AND ISNULL(FA.AllServiceServiceArea, 'N') = 'N'
								)
							)
						AND EXISTS (
							SELECT 1
							FROM FinancialAssignmentServiceAreas FPR
							WHERE FPR.FinancialAssignmentId = FA.FinancialAssignmentId
								AND FPR.ServiceAreaId = @ServiceAreaId
								AND ISNULL(FPR.RecordDeleted, 'N') = 'N'
								AND (
									@AssignmentType = - 1
									OR FPR.AssignmentType = @AssignmentType
									)
							)
						)
					OR (
						(
							ISNULL(FA.ChargeServiceArea, '') <> ''
							AND ISNULL(FA.AllChargeServiceArea, 'N') = 'Y'
							)
						OR (
							ISNULL(FA.PaymentServiceArea, '') <> ''
							AND ISNULL(FA.AllPaymentServiceArea, 'N') = 'Y'
							)
						OR (
							ISNULL(FA.ServiceServiceArea, '') <> ''
							AND ISNULL(FA.AllServiceServiceArea, 'N') = 'Y'
							)
						)
					)
				AND (
					ISNULL(@primaryClinicianId, - 1) = - 1
					OR (
						(
							(
								ISNULL(FA.PaymentPrimaryClinician, '') <> ''
								AND ISNULL(FA.AllPaymentPrimaryClinician, 'N') = 'N'
								)
							OR (
								ISNULL(FA.ServicePrimaryClinician, '') <> ''
								AND ISNULL(FA.AllServicePrimaryClinician, 'N') = 'N'
								)
							)
						AND EXISTS (
							SELECT 1
							FROM FinancialAssignmentPrimaryClinicians FPR
							WHERE FPR.FinancialAssignmentId = FA.FinancialAssignmentId
								AND FPR.PrimaryClinicianId = @primaryClinicianId
								AND ISNULL(FPR.RecordDeleted, 'N') = 'N'
								AND (
									@AssignmentType = - 1
									OR FPR.AssignmentType = @AssignmentType
									)
							)
						)
					OR (
						(
							ISNULL(FA.PaymentPrimaryClinician, '') <> ''
							AND ISNULL(FA.AllPaymentPrimaryClinician, 'N') = 'Y'
							)
						OR (
							ISNULL(FA.ServicePrimaryClinician, '') <> ''
							AND ISNULL(FA.AllServicePrimaryClinician, 'N') = 'Y'
							)
						)
					)
				AND (
					@AssignmentType = - 1
					OR (
						@AssignmentType = 8979
						AND (
							(
								(
									ISNULL(FA.ChargePayerType, '') <> ''
									AND ISNULL(FA.AllChargePayerType, 'N') = 'Y'
									)
								OR (
									ISNULL(FA.ChargePayerType, '') <> ''
									AND ISNULL(FA.AllChargePayerType, 'N') = 'N'
									)
								)
							OR (
								(
									ISNULL(FA.ChargePayer, '') <> ''
									AND ISNULL(FA.AllChargePayer, 'N') = 'Y'
									)
								OR (
									ISNULL(FA.ChargePayer, '') <> ''
									AND ISNULL(FA.AllChargePayer, 'N') = 'N'
									)
								)
							OR (
								(
									ISNULL(FA.ChargePlan, '') <> ''
									AND ISNULL(FA.AllChargePlan, 'N') = 'Y'
									)
								OR (
									ISNULL(FA.ChargePlan, '') <> ''
									AND ISNULL(FA.AllChargePlan, 'N') = 'N'
									)
								)
							OR (
								(
									ISNULL(FA.ChargeProgram, '') <> ''
									AND ISNULL(FA.AllChargeProgram, 'N') = 'Y'
									)
								OR (
									ISNULL(FA.ChargeProgram, '') <> ''
									AND ISNULL(FA.AllChargeProgram, 'N') = 'N'
									)
								)
							OR (
								(
									ISNULL(FA.ChargeLocation, '') <> ''
									AND ISNULL(FA.AllChargeLocation, 'N') = 'Y'
									)
								OR (
									ISNULL(FA.ChargeLocation, '') <> ''
									AND ISNULL(FA.AllChargeLocation, 'N') = 'N'
									)
								)
							OR (
								(
									ISNULL(FA.ChargeServiceArea, '') <> ''
									AND ISNULL(FA.AllChargeServiceArea, 'N') = 'Y'
									)
								OR (
									ISNULL(FA.ChargeServiceArea, '') <> ''
									AND ISNULL(FA.AllChargeServiceArea, 'N') = 'N'
									)
								)
							OR (
								(
									ISNULL(FA.ChargeProcedureCode, '') <> ''
									AND ISNULL(FA.AllChargeProcedureCode, 'N') = 'Y'
									)
								OR (
									ISNULL(FA.ChargeProcedureCode, '') <> ''
									AND ISNULL(FA.AllChargeProcedureCode, 'N') = 'N'
									)
								)
							OR (
								(
									ISNULL(FA.ChargeErrorReason, '') <> ''
									AND ISNULL(FA.AllChargeErrorReason, 'N') = 'Y'
									)
								OR (
									ISNULL(FA.ChargeErrorReason, '') <> ''
									AND ISNULL(FA.AllChargeErrorReason, 'N') = 'N'
									)
								)
								--Added by Ajay
							OR (
								(
									ISNULL(FA.ChargeAdjustmentCodes, '') <> ''
									AND ISNULL(FA.AllChargeAdjustmentCodes, 'N') = 'Y'
									)
								OR (
									ISNULL(FA.ChargeErrorReason, '') <> ''
									AND ISNULL(FA.AllChargeErrorReason, 'N') = 'N'
									)
								)
							
							OR ISNULL(FA.ChargeResponsibleDays, '') <> ''
							OR ISNULL(FA.ChargeIncludeClientCharge, '') <> ''
							OR ISNULL(FA.FinancialAssignmentChargeClientLastNameFrom, '') <> ''
							OR ISNULL(FA.FinancialAssignmentChargeClientLastNameTo, '') <> ''
							)
						AND (
							@PayerType = - 1
							OR EXISTS (
								SELECT 1
								FROM FinancialAssignmentPayerTypes FPR
								WHERE FPR.FinancialAssignmentId = FA.FinancialAssignmentId
									AND FPR.AssignmentType = @AssignmentType
									AND FPR.PayerTypeId = @PayerType
									AND ISNULL(FPR.RecordDeleted, 'N') = 'N'
								)
							OR (
								ISNULL(FA.ChargePayerType, '') <> ''
								AND ISNULL(FA.AllChargePayerType, 'N') = 'Y'
								)
							)
						AND (
							@PayerId = - 1
							OR (
								EXISTS (
									SELECT 1
									FROM FinancialAssignmentPayers FPR
									WHERE FPR.FinancialAssignmentId = FA.FinancialAssignmentId
										AND FPR.AssignmentType = @AssignmentType
										AND FPR.PayerId = @PayerId
										AND ISNULL(FPR.RecordDeleted, 'N') = 'N'
									)
								OR (
									ISNULL(FA.ChargePayer, '') <> ''
									AND ISNULL(FA.AllChargePayer, 'N') = 'Y'
									)
								)
							)
						AND (
							@CoveragePlanId = - 1
							OR (
								EXISTS (
									SELECT 1
									FROM FinancialAssignmentPlans FPR
									WHERE FPR.FinancialAssignmentId = FA.FinancialAssignmentId
										AND FPR.AssignmentType = @AssignmentType
										AND FPR.CoveragePlanId = @CoveragePlanId
										AND ISNULL(FPR.RecordDeleted, 'N') = 'N'
									)
								OR (
									ISNULL(FA.ChargePlan, '') <> ''
									AND ISNULL(FA.AllChargePlan, 'N') = 'Y'
									)
								)
							)
						AND (
							@ProgramId = - 1
							OR (
								EXISTS (
									SELECT 1
									FROM FinancialAssignmentPrograms FPR
									WHERE FPR.FinancialAssignmentId = FA.FinancialAssignmentId
										AND FPR.AssignmentType = @AssignmentType
										AND FPR.ProgramId = @ProgramId
										AND ISNULL(FPR.RecordDeleted, 'N') = 'N'
									)
								OR (
									ISNULL(FA.ChargeProgram, '') <> ''
									AND ISNULL(FA.AllChargeProgram, 'N') = 'Y'
									)
								)
							)
						AND (
							@LocationId = - 1
							OR (
								EXISTS (
									SELECT 1
									FROM FinancialAssignmentLocations FPR
									WHERE FPR.FinancialAssignmentId = FA.FinancialAssignmentId
										AND FPR.AssignmentType = @AssignmentType
										AND FPR.LocationId = @LocationId
										AND ISNULL(FPR.RecordDeleted, 'N') = 'N'
									)
								OR (
									ISNULL(FA.ChargeLocation, '') <> ''
									AND ISNULL(FA.AllChargeLocation, 'N') = 'Y'
									)
								)
							)
						AND (
							@ServiceAreaId = - 1
							OR (
								EXISTS (
									SELECT 1
									FROM FinancialAssignmentServiceAreas FPR
									WHERE FPR.FinancialAssignmentId = FA.FinancialAssignmentId
										AND FPR.AssignmentType = @AssignmentType
										AND FPR.ServiceAreaId = @ServiceAreaId
										AND ISNULL(FPR.RecordDeleted, 'N') = 'N'
									)
								OR (
									ISNULL(FA.ChargeServiceArea, '') <> ''
									AND ISNULL(FA.AllChargeServiceArea, 'N') = 'Y'
									)
								)
							)
						AND (
							@ProcedureCodeId = - 1
							OR (
								EXISTS (
									SELECT 1
									FROM FinancialAssignmentProcedureCodes FPR
									WHERE FPR.FinancialAssignmentId = FA.FinancialAssignmentId
										AND FPR.AssignmentType = @AssignmentType
										AND FPR.ProcedureCodeId = @ProcedureCodeId
										AND ISNULL(FPR.RecordDeleted, 'N') = 'N'
									)
								OR (
									ISNULL(FA.ChargeProcedureCode, '') <> ''
									AND ISNULL(FA.AllChargeProcedureCode, 'N') = 'Y'
									)
								)
							)
						AND (
							@ErrorReason = - 1
							OR (
								EXISTS (
									SELECT 1
									FROM FinancialAssignmentErrorReasons FPR
									WHERE FPR.FinancialAssignmentId = FA.FinancialAssignmentId
										AND FPR.AssignmentType = @AssignmentType
										AND FPR.ErrorReasonId = @ErrorReason
										AND ISNULL(FPR.RecordDeleted, 'N') = 'N'
									)
								OR (
									ISNULL(FA.ChargeErrorReason, '') <> ''
									AND ISNULL(FA.AllChargeErrorReason, 'N') = 'Y'
									)
								)
							)
						)
					OR (
						@AssignmentType = 8977
						AND (
							(
								ISNULL(FA.FinancialAssignmentPaymentClientLastNameFrom, '') <> ''
								OR ISNULL(FA.FinancialAssignmentPaymentClientLastNameTo, '') <> ''
								OR (
									(
										ISNULL(FA.PaymentProgram, '') <> ''
										AND ISNULL(FA.AllPaymentProgram, 'N') = 'Y'
										)
									OR (
										ISNULL(FA.PaymentProgram, '') <> ''
										AND ISNULL(FA.AllPaymentProgram, 'N') = 'N'
										)
									)
								OR (
									(
										ISNULL(FA.PaymentPayerType, '') <> ''
										AND ISNULL(FA.AllPaymentPayerType, 'N') = 'Y'
										)
									OR (
										ISNULL(FA.PaymentPayerType, '') <> ''
										AND ISNULL(FA.AllPaymentPayerType, 'N') = 'N'
										)
									)
								OR (
									(
										ISNULL(FA.PaymentLocation, '') <> ''
										AND ISNULL(FA.AllPaymentLocation, 'N') = 'Y'
										)
									OR (
										ISNULL(FA.PaymentLocation, '') <> ''
										AND ISNULL(FA.AllPaymentLocation, 'N') = 'N'
										)
									)
								OR (
									(
										ISNULL(FA.PaymentPayer, '') <> ''
										AND ISNULL(FA.AllPaymentPayer, 'N') = 'Y'
										)
									OR (
										ISNULL(FA.PaymentPayer, '') <> ''
										AND ISNULL(FA.AllPaymentPayer, 'N') = 'N'
										)
									)
								OR (
									(
										ISNULL(FA.PaymentPlan, '') <> ''
										AND ISNULL(FA.AllPaymentPlan, 'N') = 'Y'
										)
									OR (
										ISNULL(FA.PaymentPlan, '') <> ''
										AND ISNULL(FA.AllPaymentPlan, 'N') = 'N'
										)
									)
								OR (
									(
										ISNULL(FA.PaymentPrimaryClinician, '') <> ''
										AND ISNULL(FA.AllPaymentPrimaryClinician, 'N') = 'Y'
										)
									OR (
										ISNULL(FA.PaymentPrimaryClinician, '') <> ''
										AND ISNULL(FA.AllPaymentPrimaryClinician, 'N') = 'N'
										)
									)
								OR (
									(
										ISNULL(FA.PaymentServiceArea, '') <> ''
										AND ISNULL(FA.AllPaymentServiceArea, 'N') = 'Y'
										)
									OR (
										ISNULL(FA.PaymentServiceArea, '') <> ''
										AND ISNULL(FA.AllPaymentServiceArea, 'N') = 'N'
										)
									)
								)
							AND (
								@ProgramId = - 1
								OR (
									EXISTS (
										SELECT 1
										FROM FinancialAssignmentPrograms FPR
										WHERE FPR.FinancialAssignmentId = FA.FinancialAssignmentId
											AND FPR.AssignmentType = @AssignmentType
											AND FPR.ProgramId = @ProgramId
											AND ISNULL(FPR.RecordDeleted, 'N') = 'N'
										)
									OR (
										ISNULL(FA.PaymentProgram, '') <> ''
										AND ISNULL(FA.AllPaymentProgram, 'N') = 'Y'
										)
									)
								)
							AND (
								@PayerType = - 1
								OR EXISTS (
									SELECT 1
									FROM FinancialAssignmentPayerTypes FPR
									WHERE FPR.FinancialAssignmentId = FA.FinancialAssignmentId
										AND FPR.AssignmentType = @AssignmentType
										AND FPR.PayerTypeId = @PayerType
										AND ISNULL(FPR.RecordDeleted, 'N') = 'N'
									)
								OR (
									ISNULL(FA.PaymentPayerType, '') <> ''
									AND ISNULL(FA.AllPaymentPayerType, 'N') = 'Y'
									)
								)
							AND (
								@LocationId = - 1
								OR (
									EXISTS (
										SELECT 1
										FROM FinancialAssignmentLocations FPR
										WHERE FPR.FinancialAssignmentId = FA.FinancialAssignmentId
											AND FPR.AssignmentType = @AssignmentType
											AND FPR.LocationId = @LocationId
											AND ISNULL(FPR.RecordDeleted, 'N') = 'N'
										)
									OR (
										ISNULL(FA.PaymentLocation, '') <> ''
										AND ISNULL(FA.AllPaymentLocation, 'N') = 'Y'
										)
									)
								)
							AND (
								@PayerId = - 1
								OR (
									EXISTS (
										SELECT 1
										FROM FinancialAssignmentPayers FPR
										WHERE FPR.FinancialAssignmentId = FA.FinancialAssignmentId
											AND FPR.AssignmentType = @AssignmentType
											AND FPR.PayerId = @PayerId
											AND ISNULL(FPR.RecordDeleted, 'N') = 'N'
										)
									OR (
										ISNULL(FA.PaymentPayer, '') <> ''
										AND ISNULL(FA.AllPaymentPayer, 'N') = 'Y'
										)
									)
								)
							AND (
								@CoveragePlanId = - 1
								OR (
									EXISTS (
										SELECT 1
										FROM FinancialAssignmentPlans FPR
										WHERE FPR.FinancialAssignmentId = FA.FinancialAssignmentId
											AND FPR.AssignmentType = @AssignmentType
											AND FPR.CoveragePlanId = @CoveragePlanId
											AND ISNULL(FPR.RecordDeleted, 'N') = 'N'
										)
									OR (
										ISNULL(FA.PaymentPlan, '') <> ''
										AND ISNULL(FA.AllPaymentPlan, 'N') = 'Y'
										)
									)
								)
							AND (
								ISNULL(@primaryClinicianId,-1) = - 1
								OR (
									EXISTS (
										SELECT 1
										FROM FinancialAssignmentPrimaryClinicians FPR
										WHERE FPR.FinancialAssignmentId = FA.FinancialAssignmentId
											AND FPR.AssignmentType = @AssignmentType
											AND FPR.primaryClinicianId = @primaryClinicianId
											AND ISNULL(FPR.RecordDeleted, 'N') = 'N'
										)
									OR (
										ISNULL(FA.PaymentPrimaryClinician, '') <> ''
										AND ISNULL(FA.AllPaymentPrimaryClinician, 'N') = 'Y'
										)
									)
								)
							AND (
								@ServiceAreaId = - 1
								OR (
									EXISTS (
										SELECT 1
										FROM FinancialAssignmentServiceAreas FPR
										WHERE FPR.FinancialAssignmentId = FA.FinancialAssignmentId
											AND FPR.AssignmentType = @AssignmentType
											AND FPR.ServiceAreaId = @ServiceAreaId
											AND ISNULL(FPR.RecordDeleted, 'N') = 'N'
										)
									OR (
										ISNULL(FA.PaymentServiceArea, '') <> ''
										AND ISNULL(FA.AllPaymentServiceArea, 'N') = 'Y'
										)
									)
								)
							)
						)
					OR (
						@AssignmentType = 8978
						AND (
							(
								ISNULL(FA.FinancialAssignmentServiceClientLastNameFrom, '') <> ''
								OR ISNULL(FA.FinancialAssignmentServiceClientLastNameTo, '') <> ''
								OR (
									(
										ISNULL(FA.ServiceProgram, '') <> ''
										AND ISNULL(FA.AllServiceProgram, 'N') = 'Y'
										)
									OR (
										ISNULL(FA.ServiceProgram, '') <> ''
										AND ISNULL(FA.AllServiceProgram, 'N') = 'N'
										)
									)
								OR (
									(
										ISNULL(FA.ServicePrimaryClinician, '') <> ''
										AND ISNULL(FA.AllServicePrimaryClinician, 'N') = 'Y'
										)
									OR (
										ISNULL(FA.ServicePrimaryClinician, '') <> ''
										AND ISNULL(FA.AllServicePrimaryClinician, 'N') = 'N'
										)
									)
								OR (   -- Added By Ajay
									(
										ISNULL(FA.ServiceClinicians, '') <> ''
										AND ISNULL(FA.AllServiceClinicians, 'N') = 'Y'
										)
									OR (
										ISNULL(FA.ServiceClinicians, '') <> ''
										AND ISNULL(FA.AllServiceClinicians, 'N') = 'N'
										)
									)
								OR (
									(
										ISNULL(FA.ServiceProcedureCode, '') <> ''
										AND ISNULL(FA.AllServiceProcedureCode, 'N') = 'Y'
										)
									OR (
										ISNULL(FA.ServiceProcedureCode, '') <> ''
										AND ISNULL(FA.AllServiceProcedureCode, 'N') = 'N'
										)
									)
								OR (
									(
										ISNULL(FA.ServiceServiceArea, '') <> ''
										AND ISNULL(FA.AllServiceServiceArea, 'N') = 'Y'
										)
									OR (
										ISNULL(FA.ServiceServiceArea, '') <> ''
										AND ISNULL(FA.AllServiceServiceArea, 'N') = 'N'
										)
									)
									OR (
									(
										ISNULL(FA.ServiceLocation, '') <> ''
										AND ISNULL(FA.AllServiceLocation, 'N') = 'Y'
										)
									OR (
										ISNULL(FA.ServiceLocation, '') <> ''
										AND ISNULL(FA.AllServiceLocation, 'N') = 'N'
										)
									)
								)
							AND (
								@ProgramId = - 1
								OR (
									EXISTS (
										SELECT 1
										FROM FinancialAssignmentPrograms FPR
										WHERE FPR.FinancialAssignmentId = FA.FinancialAssignmentId
											AND FPR.AssignmentType = @AssignmentType
											AND FPR.ProgramId = @ProgramId
											AND ISNULL(FPR.RecordDeleted, 'N') = 'N'
										)
									OR (
										ISNULL(FA.ServiceProgram, '') <> ''
										AND ISNULL(FA.AllServiceProgram, 'N') = 'Y'
										)
									)
								)
							AND (
								ISNULL(@primaryClinicianId,-1) = - 1
								OR (
									EXISTS (
										SELECT 1
										FROM FinancialAssignmentPrimaryClinicians FPR
										WHERE FPR.FinancialAssignmentId = FA.FinancialAssignmentId
											AND FPR.AssignmentType = @AssignmentType
											AND FPR.primaryClinicianId = @primaryClinicianId
											AND ISNULL(FPR.RecordDeleted, 'N') = 'N'
										)
									OR (
										ISNULL(FA.ServicePrimaryClinician, '') <> ''
										AND ISNULL(FA.AllServicePrimaryClinician, 'N') = 'Y'
										)
									)
								)
							AND (
								@ProcedureCodeId = - 1
								OR (
									EXISTS (
										SELECT 1
										FROM FinancialAssignmentProcedureCodes FPR
										WHERE FPR.FinancialAssignmentId = FA.FinancialAssignmentId
											AND FPR.AssignmentType = @AssignmentType
											AND FPR.ProcedureCodeId = @ProcedureCodeId
											AND ISNULL(FPR.RecordDeleted, 'N') = 'N'
										)
									OR (
										ISNULL(FA.ServiceProcedureCode, '') <> ''
										AND ISNULL(FA.AllServiceProcedureCode, 'N') = 'Y'
										)
									)
								)
								AND (
								 @LocationId = - 1
								OR (
									EXISTS (
										SELECT 1
										FROM FinancialAssignmentLocations FPR
										WHERE FPR.FinancialAssignmentId = FA.FinancialAssignmentId
											AND FPR.AssignmentType = @AssignmentType
											AND FPR.LocationId =  @LocationId
											AND ISNULL(FPR.RecordDeleted, 'N') = 'N'
										)
									OR (
										ISNULL(FA.ServiceLocation, '') <> ''
										AND ISNULL(FA.AllServiceLocation, 'N') = 'Y'
										)
									)
								)
							AND (
								@ServiceAreaId = - 1
								OR (
									EXISTS (
										SELECT 1
										FROM FinancialAssignmentServiceAreas FPR
										WHERE FPR.FinancialAssignmentId = FA.FinancialAssignmentId
											AND FPR.AssignmentType = @AssignmentType
											AND FPR.ServiceAreaId = @ServiceAreaId
											AND ISNULL(FPR.RecordDeleted, 'N') = 'N'
										)
									OR (
										ISNULL(FA.ServiceServiceArea, '') <> ''
										AND ISNULL(FA.AllServiceServiceArea, 'N') = 'Y'
										)
									)
								)
							)
						)
					)
					--Modified by Revathi 16-Dec-2015
				)
				;

		WITH Counts
		AS (
			SELECT Count(*) AS TotalRows
			FROM #ResultSet
			)
			,RankResultSet
		AS (
			SELECT FinancialAssignmentId
				,AssignmentName
				,StaffName
				,StaffName5
				,RWQMAssigned                   --added by Ajay on  16-June-2017
				,ListPageFilter
				,RevenueWorkQueueManagement
				,Count(*) OVER () AS TotalCount
				,Rank() OVER (
					ORDER BY CASE 
							WHEN @SortExpression = 'FinancialAssignmentId'
								THEN FinancialAssignmentId
							END
						,CASE 
							WHEN @SortExpression = 'FinancialAssignmentId desc'
								THEN FinancialAssignmentId
							END DESC
						,CASE 
							WHEN @SortExpression = 'AssignmentName'
								THEN AssignmentName
							END
						,CASE 
							WHEN @SortExpression = 'AssignmentName desc'
								THEN AssignmentName
							END DESC
						,CASE 
							WHEN @SortExpression = 'StaffName'
								THEN StaffName
							END
						,CASE 
							WHEN @SortExpression = 'StaffName desc'
								THEN StaffName
							END DESC
						,CASE 
							WHEN @SortExpression = 'RWQMAssigned'
								THEN RWQMAssigned
							END
						,CASE 
							WHEN @SortExpression = 'RWQMAssigned desc'
								THEN RWQMAssigned
							END DESC
						,CASE 
							WHEN @SortExpression = 'ListPageFilter'
								THEN ListPageFilter
							END
						,CASE 
							WHEN @SortExpression = 'ListPageFilter desc'
								THEN ListPageFilter
							END DESC
						,CASE 
							WHEN @SortExpression = 'RevenueWorkQueueManagement'
								THEN RevenueWorkQueueManagement
							END
						,CASE 
							WHEN @SortExpression = 'RevenueWorkQueueManagement desc'
								THEN RevenueWorkQueueManagement
							END DESC
						,FinancialAssignmentId
					) AS RowNumber
			FROM #ResultSet
			)
		SELECT TOP (
				CASE 
					WHEN (@PageNumber = - 1)
						THEN (
								SELECT Isnull(TotalRows, 0)
								FROM Counts
								)
					ELSE (@PageSize)
					END
				) FinancialAssignmentId
			,AssignmentName
			,StaffName
			,StaffName5
			,RWQMAssigned
			,ListPageFilter 
			,RevenueWorkQueueManagement
			,TotalCount
			,RowNumber
		INTO #FinalResultSet
		FROM RankResultSet
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize)

		IF (
				SELECT Isnull(Count(*), 0)
				FROM #FinalResultSet
				) < 1
		BEGIN
			SELECT 0 AS PageNumber
				,0 AS NumberOfPages
				,0 NumberofRows
		END
		ELSE
		BEGIN
			SELECT TOP 1 @PageNumber AS PageNumber
				,CASE (Totalcount % @PageSize)
					WHEN 0
						THEN Isnull((Totalcount / @PageSize), 0)
					ELSE Isnull((Totalcount / @PageSize), 0) + 1
					END AS NumberOfPages
				,Isnull(Totalcount, 0) AS NumberofRows
			FROM #FinalResultSet
		END

		SELECT FinancialAssignmentId
			,AssignmentName
			,StaffName
			,StaffName5
			,RWQMAssigned
			,ListPageFilter 
			,RevenueWorkQueueManagement
			
		FROM #FinalResultSet
		ORDER BY RowNumber
	END TRY

	BEGIN CATCH
		DECLARE @error VARCHAR(8000)

		SET @error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_ListPageFinancialAssignments') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())

		RAISERROR (
				@error
				,-- Message text.  
				16
				,-- Severity.  
				1 -- State.  
				);
	END CATCH
END
GO


