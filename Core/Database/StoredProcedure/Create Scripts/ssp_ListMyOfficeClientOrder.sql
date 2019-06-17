IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListMyOfficeClientOrder]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_ListMyOfficeClientOrder]
GO

/****** Object:  StoredProcedure [dbo].[[ssp_ListMyOfficeClientOrder]]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_ListMyOfficeClientOrder] @PageNumber INT
	/******************************************************************************                                   
**  File: [ssp_ListMyOfficeClientOrder]                                            
**  Name: [ssp_ListMyOfficeClientOrder]                       
**  Desc: Get Data for Client Orders.
**  Called by:                                                 
**  Parameters:                            
**  Auth:  Pavani                             
**  Date:  1/12/2016
**  Created: For the Task MHP-Customizations#55
*******************************************************************************                                                
**  Change History                                          
*******************************************************************************                                          
**  Date:             Author:       Description:  
**  6 Feb 2017        Pavani       What: Added Left join for ClientPrograms and Programs tables
                                   Why : MHP Customizations 55.1
    25 APR 2017       Pavani       What: Modified From Date And To Date Condition
                                   Whay: MHP Customizations 55.23
   02 April 2018      Kavya        What: Added  CHARINDEX(',', MM.Strength) <= 0 conditon to restrict the ' , ' in Strength values.
                                   Why:  AHN-Support Go Live: #209 Orders: Cannot navigate to orders banner 
	26 Jul 2018		  Chethan N	   What: Removed Active and RecordDeleted check for Orders 
	17 Jan 2019		  Chethan N	   What : Changed Staff table INNER JOIN to LEFT JOIN
								   Why : Orders for which Ordering Physician is Inactive or marked as deleted were not populating in the list page
                                   
*******************************************************************************/
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@ClientId INT
	,@fromDate DATETIME
	,@toDate DATETIME
	,@OrderType INT
	,@AssignedTo INT
	,@OrderedBy INT
	,@OtherFilter INT
	,@LoggedInStaffId INT
	,@Status INT
	,@Program INT
	,@Priority INT
	,@ReceivedFrom DATETIME
	,@ReceivedTo DATETIME
AS
BEGIN
	BEGIN TRY
		CREATE TABLE #customfilters (clientorderid INT NOT NULL)

		DECLARE @ApplyFilterClicked CHAR(1)
		DECLARE @CustomFilterApplied CHAR(1)
		DECLARE @OrderId INT

		SET @OrderId = (
				SELECT TOP 1 R.IntegerCodeId
				FROM Recodes R
				JOIN RecodeCategories RC ON RC.CategoryName = 'RxOrder'
					AND RC.RecodeCategoryId = R.RecodeCategoryId
				WHERE ISNULL(R.RecordDeleted, 'N') = 'N'
				)
		SET @SortExpression = Rtrim(Ltrim(@SortExpression))

		IF Isnull(@SortExpression, '') = ''
		BEGIN
			SET @SortExpression = 'OrderName'
		END

		------ Get Permissioned Orders for the logged in Staff ------                        
		CREATE TABLE #PermissionTable (PermissionItemId INT)

		INSERT INTO #PermissionTable (PermissionItemId)
		EXEC ssp_GetPermisionedOrder @LoggedInStaffId = @LoggedInStaffId

		SET @ApplyFilterClicked = 'Y'
		SET @CustomFilterApplied = 'N'

		IF @OtherFilter > 10000
		BEGIN
			SET @CustomFilterApplied = 'Y'

			INSERT INTO #customfilters (clientorderid)
			EXEC Scsp_SCClientMemberOrder @OrderType = @OrderType
				,@AssignedTo = @AssignedTo
				,@OtherFilter = @OtherFilter
		END;

		WITH listclientorders
		AS (
			SELECT DISTINCT CO.ClientOrderId
				,CASE 
					WHEN O.OrderType = 8501
						THEN O.OrderName + ' ' + CASE 
								WHEN (
										ISNUMERIC(isnull(MM.Strength, 'a')) = 1
										AND CHARINDEX('.', MM.Strength) <= 0
										AND CHARINDEX(',', MM.Strength) <= 0
										)
									AND (
										MDF.DosageFormDescription = 'Tablet'
										OR MDF.DosageFormDescription = 'Capsule'
										)
									THEN UPPER(ISNULL(MDF.DosageFormAbbreviation, '') + ' ' + cast(cast(isnull(MM.Strength, 1) * isnull(CO.MedicationDosage, 1) AS INT) AS VARCHAR(200)) + ISNULL(MM.StrengthUnitOfMeasure, ''))
								ELSE '(' + UPPER(ISNULL(convert(VARCHAR(15), CAST(CAST((ROUND(CO.MedicationDosage, 2) * 100) AS INT) AS FLOAT) / 100), '') + '    
) ' + ISNULL(MDF.DosageFormAbbreviation, '') + ' ' + COALESCE(MM.Strength, OS.MedictionOtherStrength, CO.MedicationOtherDosage, '') + ISNULL(MM.StrengthUnitOfMeasure, ''))
								END
					ELSE O.OrderName
					END AS [OrderName]
				,G.CodeName AS [OrderType]
				,OTF.DisplayName AS FrequencyName
				,CO.OrderStartDateTime
				,CO.OrderEndDateTime
				,S1.LastName + ', ' + S1.FirstName AS OrderedBy
				,S.LastName + ', ' + S.FirstName AS AssignedTo
				,G1.CodeName AS Priority
				,CO.OrderPendAcknowledge
				,CO.OrderPendRequiredRoleAcknowledge
				,CO.OrderPended
				,CO.OrderId
				,CASE 
					WHEN O.OrderType = 8501
						THEN O.OrderName + ' <br/> Sig: ' + CASE 
								WHEN (
										ISNUMERIC(isnull(MM.Strength, 'a')) = 1
										AND CHARINDEX('.', MM.Strength) <= 0
										AND CHARINDEX(',', MM.Strength) <= 0
										)
									AND (
										MDF.DosageFormDescription = 'Tablet'
										OR MDF.DosageFormDescription = 'Capsule'
										)
									THEN UPPER(ISNULL(MDF.DosageFormAbbreviation, '') + ' ' + cast(cast(isnull(MM.Strength, 1) * isnull(CO.MedicationDosage, 1) AS INT) AS VARCHAR(200)) + ISNULL(MM.StrengthUnitOfMeasure, '') + ' ' + ISNULL(MDR.RouteAbbreviation, '') + ' ' + otf.DisplayName)
								ELSE '(' + UPPER(ISNULL(convert(VARCHAR(15), CAST(CAST((ROUND(CO.MedicationDosage, 2) * 100) AS INT) AS FLOAT) / 100), '') + ') ' + ISNULL(MDF.DosageFormAbbreviation, '') + ' ' + COALESCE(MM.Strength, OS.MedictionOtherStrength, CO.MedicationOtherDosage, '') + ISNULL(MM.StrengthUnitOfMeasure, '') + ' ' + ISNULL(MDR.RouteAbbreviation, '') + ' ' + otf.DisplayName)
								END
					ELSE O.OrderName
					END AS OrderToolTip
				,GC3.CodeName AS STATUS
				,ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '') + ' (' + CONVERT(VARCHAR(10), C.ClientId, 101) + ')' AS ClientName
				,P.ProgramCode AS Programs
				,COR.ResultDateTime AS DateReceived
				,CO.ParentClientOrderId
				,C.ClientId AS ClientId
			FROM ClientOrders AS CO
			INNER JOIN Orders AS O ON O.OrderId = CO.OrderId
				--AND (Isnull(O.RecordDeleted, 'N') = 'N')
				--AND (Isnull(O.Active, 'Y') = 'Y')
			INNER JOIN GlobalCodes AS G ON G.GlobalCodeId = O.OrderType
				AND (Isnull(G.RecordDeleted, 'N') = 'N')
			LEFT JOIN globalcodes AS G1 ON G1.GlobalCodeId = CO.OrderPriorityId
				AND (Isnull(G1.RecordDeleted, 'N') = 'N')
			LEFT JOIN staff S1 ON S1.staffid = CO.OrderingPhysician
			LEFT JOIN staff S ON S.StaffId = CO.AssignedTo
			LEFT JOIN ordertemplatefrequencies OTF ON OTF.ordertemplatefrequencyid = CO.ordertemplatefrequencyid
				AND (Isnull(OTF.RecordDeleted, 'N') = 'N')
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
			LEFT JOIN GlobalCodes AS GC3 ON GC3.GlobalCodeId = CO.OrderStatus
				AND ISNULL(GC3.RecordDeleted, 'N') = 'N'
			LEFT JOIN OrderRoutes AS ORT ON ORT.OrderRouteId = CO.MedicationOrderRouteId
				AND ISNULL(ORT.RecordDeleted, 'N') = 'N'
			LEFT JOIN MDRoutes AS MDR ON MDR.RouteId = ORT.RouteId
				AND ISNULL(ORT.RecordDeleted, 'N') = 'N'
			JOIN Clients AS C ON C.Clientid = CO.Clientid
				AND ISNULL(C.RecordDeleted, 'N') = 'N'
			INNER JOIN StaffClients sc ON sc.ClientId = c.ClientId
				AND sc.StaffId = @LoggedInStaffId
			LEFT JOIN ClientPrograms AS CP ON CP.ClientId = CO.ClientId
				AND CP.PrimaryAssignment = 'Y'
				AND ISNULL(CP.RecordDeleted, 'N') = 'N'
			LEFT JOIN Programs AS P ON P.ProgramId = CP.ProgramId
				AND ISNULL(P.RecordDeleted, 'N') = 'N'
			LEFT JOIN (
				SELECT ClientOrderId
					,max(ResultDateTime) AS ResultDateTime
				FROM ClientOrderResults
				WHERE ISNULL(RecordDeleted, 'N') = 'N'
					AND (
						@ReceivedFrom IS NULL
						OR (
							cast(ResultDateTime AS DATE) >= cast(@ReceivedFrom AS DATE)
							AND CAST(ResultDateTime AS DATE) <= cast(@ReceivedTo AS DATE)
							)
						)
				GROUP BY ClientOrderId
				) AS COR ON COR.ClientOrderId = CO.ClientOrderId
			WHERE (
					(
						@clientid = - 1
						OR CO.clientid = @clientid
						)
					AND (
						@Program = - 1
						OR P.ProgramId = @Program
						)
					AND (
						@Priority = - 1
						OR CO.OrderPriorityId = @Priority
						)
					AND (CO.ORDERFLAG = 'Y')
					AND (Isnull(CO.OrderPended, 'N') = 'N')
					AND (Isnull(CO.OrderPendAcknowledge, 'N') = 'N')
					AND (Isnull(CO.OrderPendRequiredRoleAcknowledge, 'N') = 'N')
					AND Isnull(CO.RecordDeleted, 'N') = 'N'
					AND (
						(
							@CustomFilterApplied = 'Y'
							AND EXISTS (
								SELECT *
								FROM #customfilters CF
								WHERE CF.clientorderid = CO.ClientOrderId
								)
							)
						OR (
							@CustomFilterApplied = 'N'
							AND (
								Isnull(@OrderType, - 1) = - 1
								OR O.ordertype = @OrderType
								)
							)
						)
					AND CASE 
						WHEN (@AssignedTo > - 1)
							THEN CASE 
									WHEN (CO.AssignedTo = @AssignedTo)
										THEN 1
									END
						ELSE 1
						END = 1
					AND CASE 
						WHEN (@OrderedBy > - 1)
							THEN CASE 
									WHEN (CO.OrderingPhysician = @OrderedBy)
										THEN 1
									END
						ELSE 1
						END = 1
					AND (
						(
						-- 25-04-2017 Pavani
							@fromDate IS NULL
							OR cast(CO.OrderStartDateTime AS DATE) >= cast(@fromDate AS DATE)
							)
						AND (
							@toDate IS NULL
							OR cast(CO.OrderStartDateTime AS DATE) <= cast(@toDate AS DATE)
							)
							--End
						)
					AND (
						@ReceivedFrom IS NULL
						OR (
							cast(COR.ResultDateTime AS DATE) >= cast(@ReceivedFrom AS DATE)
							AND CAST(COR.ResultDateTime AS DATE) <= cast(@ReceivedTo AS DATE)
							)
						)
					AND (
						ISNULL(O.Permissioned, 'N') = 'N'
						OR (
							O.Permissioned = 'Y'
							AND EXISTS (
								SELECT 1
								FROM #PermissionTable
								WHERE PermissionItemId = O.OrderId
								)
							)
						)
					AND (
						CO.OrderStatus = @Status
						OR @Status = - 1
						)
					)
			)
			,counts
		AS (
			SELECT Count(*) AS TotalRows
			FROM listclientorders
			)
			,rankresultset
		AS (
			SELECT ClientOrderId
				,OrderName
				,[OrderType]
				,FrequencyName
				,OrderStartDateTime
				,OrderEndDateTime
				,OrderedBy
				,AssignedTo
				,Priority
				,OrderPendAcknowledge
				,OrderPendRequiredRoleAcknowledge
				,OrderPended
				,OrderId
				,OrderToolTip
				,STATUS
				,ClientName
				,Programs
				,DateReceived
				,ParentClientOrderId
				,ClientId
				,Count(*) OVER () AS TotalCount
				,Rank() OVER (
					ORDER BY CASE 
							WHEN @SortExpression = 'ClientOrderId'
								THEN ClientOrderId
							END
						,CASE 
							WHEN @SortExpression = 'ClientOrderId DESC'
								THEN ClientOrderId
							END DESC
						,CASE 
							WHEN @SortExpression = 'ClientName'
								THEN ClientName
							END
						,CASE 
							WHEN @SortExpression = 'ClientName DESC'
								THEN ClientName
							END DESC
						,CASE 
							WHEN @SortExpression = 'OrderName'
								THEN OrderName
							END
						,CASE 
							WHEN @SortExpression = 'OrderName DESC'
								THEN OrderName
							END DESC
						,CASE 
							WHEN @SortExpression = 'OrderType'
								THEN OrderType
							END
						,CASE 
							WHEN @SortExpression = 'OrderType DESC'
								THEN OrderType
							END DESC
						,CASE 
							WHEN @SortExpression = 'FrequencyName'
								THEN FrequencyName
							END
						,CASE 
							WHEN @SortExpression = 'FrequencyName DESC'
								THEN FrequencyName
							END DESC
						,CASE 
							WHEN @SortExpression = 'OrderStartDateTime'
								THEN OrderStartDateTime
							END
						,CASE 
							WHEN @SortExpression = 'OrderStartDateTime DESC'
								THEN OrderStartDateTime
							END DESC
						,CASE 
							WHEN @SortExpression = 'OrderEndDateTime'
								THEN OrderEndDateTime
							END
						,CASE 
							WHEN @SortExpression = 'OrderEndDateTime DESC'
								THEN OrderEndDateTime
							END DESC
						,CASE 
							WHEN @SortExpression = 'AssignedTo'
								THEN AssignedTo
							END
						,CASE 
							WHEN @SortExpression = 'AssignedTo DESC'
								THEN AssignedTo
							END DESC
						,CASE 
							WHEN @SortExpression = 'OrderedBy'
								THEN OrderedBy
							END
						,CASE 
							WHEN @SortExpression = 'OrderedBy DESC'
								THEN OrderedBy
							END DESC
						,CASE 
							WHEN @SortExpression = 'Priority'
								THEN Priority
							END
						,CASE 
							WHEN @SortExpression = 'Priority DESC'
								THEN Priority
							END DESC
						,CASE 
							WHEN @SortExpression = 'Status'
								THEN STATUS
							END
						,CASE 
							WHEN @SortExpression = 'Status DESC'
								THEN STATUS
							END DESC
						,CASE 
							WHEN @SortExpression = 'Programs'
								THEN Programs
							END
						,CASE 
							WHEN @SortExpression = 'Programs DESC'
								THEN Programs
							END DESC
						,CASE 
							WHEN @SortExpression = 'DateReceived'
								THEN DateReceived
							END
						,CASE 
							WHEN @SortExpression = 'DateReceived DESC'
								THEN DateReceived
							END DESC
						,CASE 
							WHEN @SortExpression = 'ParentClientOrderId'
								THEN ParentClientOrderId
							END
						,CASE 
							WHEN @SortExpression = 'ParentClientOrderId DESC'
								THEN ParentClientOrderId
							END DESC
						,clientorderid
					) AS RowNumber
			FROM listclientorders
			)
		SELECT TOP (
				CASE 
					WHEN (@PageNumber = - 1)
						THEN (
								SELECT Isnull(totalrows, 0)
								FROM counts
								)
					ELSE (@PageSize)
					END
				) ClientOrderId
			,OrderName
			,[OrderType]
			,FrequencyName
			,OrderStartDateTime
			,OrderEndDateTime
			,OrderedBy
			,AssignedTo
			,Priority
			,OrderPendAcknowledge
			,OrderPendRequiredRoleAcknowledge
			,OrderPended
			,OrderId
			,OrderToolTip
			,STATUS
			,ClientName
			,Programs
			,DateReceived
			,ParentClientOrderId
			,ClientId
			,totalcount
			,rownumber
		INTO #finalresultset
		FROM rankresultset
		WHERE rownumber > ((@PageNumber - 1) * @PageSize)

		IF (
				SELECT Isnull(Count(*), 0)
				FROM #finalresultset
				) < 1
		BEGIN
			SELECT 0 AS PageNumber
				,0 AS NumberOfPages
				,0 NumberOfRows
		END
		ELSE
		BEGIN
			SELECT TOP 1 @PageNumber AS PageNumber
				,CASE (totalcount % @PageSize)
					WHEN 0
						THEN Isnull((totalcount / @PageSize), 0)
					ELSE Isnull((totalcount / @PageSize), 0) + 1
					END AS NumberOfPages
				,Isnull(totalcount, 0) AS NumberOfRows
			FROM #finalresultset
		END

		UPDATE a
		SET a.OrderName = O.OrderName + ' (' + MD.MedicationName + ')'
			,a.OrderToolTip = O.OrderName + ' (' + MD.MedicationName + ')'
		FROM #finalresultset a
		JOIN Orders O ON O.OrderId = a.OrderId
		LEFT JOIN MedAdminRecords MAR ON MAR.ClientOrderId = a.ClientOrderId
			AND MAR.ClientMedicationId IS NOT NULL
			AND ISNULL(MAR.RecordDeleted, 'N') = 'N'
		LEFT JOIN ClientMedications CM ON CM.ClientMedicationId = MAR.ClientMedicationId
			AND ISNULL(CM.RecordDeleted, 'N') = 'N'
		LEFT JOIN MDMedicationNames MD ON MD.MedicationNameId = CM.MedicationNameId
			AND ISNULL(MD.RecordDeleted, 'N') = 'N'
		WHERE a.OrderId = @OrderId

		SELECT ClientOrderId
			,ClientName
			,OrderName
			,[OrderType]
			,FrequencyName
			,Priority
			,STATUS
			,AssignedTo
			,Programs
			,OrderedBy
			,CONVERT(VARCHAR(10), OrderStartDateTime, 101) + ' ' + RIGHT('0' + LTRIM(RIGHT(CONVERT(VARCHAR, OrderStartDateTime, 100), 7)), 7) AS OrderStartDateTime
			,CONVERT(VARCHAR(10), OrderEndDateTime, 101) + ' ' + RIGHT('0' + LTRIM(RIGHT(CONVERT(VARCHAR, OrderEndDateTime, 100), 7)), 7) AS OrderEndDateTime
			,CONVERT(VARCHAR(10), DateReceived, 101) + ' ' + RIGHT('0' + LTRIM(RIGHT(CONVERT(VARCHAR, DateReceived, 100), 7)), 7) AS DateReceived
			,ParentClientOrderId
			,OrderPendAcknowledge
			,OrderPendRequiredRoleAcknowledge
			,OrderPended
			,OrderId
			,OrderToolTip
			,ClientId
		FROM #finalresultset
		ORDER BY rownumber

		DROP TABLE #customfilters
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_ListMyOfficeClientOrder') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())

		RAISERROR (
				@Error
				,-- Message text.                                                             
				16
				,-- Severity.                                         
				1 -- State.                                                             
				);
	END CATCH
END
