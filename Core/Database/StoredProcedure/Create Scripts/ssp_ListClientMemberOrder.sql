
GO

/****** Object:  StoredProcedure [dbo].[ssp_ListClientMemberOrder]    Script Date: 10/28/2013 19:13:33 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListClientMemberOrder]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_ListClientMemberOrder]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_ListClientMemberOrder]    Script Date: 10/28/2013 19:13:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_ListClientMemberOrder]
	-- =============================================                          
	-- Author: Vithobha                        
	-- Create date:27/06/2013                         
	-- Description: Return the Client Orders data for List page based on the filter.                   
	-- exec ssp_ListClientMemberOrder -1,100,'OrderName', 2104621,null,null,-1,-1,-1,-1 ,'N'    
	/*  Date                  Author                 Purpose								*/
	/* 27th June 2013         Vithobha				Created									*/
	/* 16th Sep 2013		  Gautam				Modified to rectifiy Date filter issue  */
	/* 24th Sep 2013		  Gautam				Modified AssignedTo from Inner join to Left Why : AssignedTo is not mandatory  */
	/* 07th Oct 2013          PPotnuru              Modified: added tooltip and checking unacknowledge orders exist for the client */
	/* 28th Oct 2013          Prasan                Modified date filter condition */
	/* 6th Mar 2014           Prasan                Modified OrderedBy and AssignedStaff style from "LastName FirstName" to "LastName, FirstName"*/
	/* 26th Mar 2014          Prasan                Modified OrderToolTip to display MedictionOtherStrength/MedicationOtherDosage if Strength is null */
	/* 15th May 2014          Gautam                Added input parameter @NonStaffUser and display OrderType for NonStaffUser using Recodes Ref, Task#20, Patient Portal, Meaningful use */
	/* 14th Jul  2014		  PPOTNURU 			    Added open paranthesis in the SIG, why task 199 Philhaven development	*/
	/* 25th Sep 2014          Gautam                Displayed Medicine name with Dose* Strength if numeric. Ref. Task #206, Philhaven development*/
	/* 19th Feb 2015		  Gautam				The column OrderFrequencyId changed to OrderTemplateFrequencyId in ClientOrders table
													and linked directly to OrderTemplateFrequencies table, Why : Task#221,Philhaven Development */
	/* 13th Mar 2015		  Chethan N				What: Checking for orders permission for the logged in staff
													Why: Woods - Customizations task#844*/
	/* 15th May 2015		  Chethan N				What: Added New parameter '@Status' and retriveing column ClientOrders.OrderStatus AS Status
													Why: Philhaven Development task#264*/
	/* 28th May 2015		  Chethan N				What: Retrieving Ordering Physician instead of Order By Staff
													Why: Philhaven Development task#287*/
	/* 29th Jul 2015          Gautam                What : Remove () for Non Medication Orders and Dose* Strength only for Tablet and capsules
													Why : Philhaven Development task#259  */
	/* 13th Jan 2015		  Chethan N				What: Retrieving Order Name from MDMedicationNames for Client Medication Mapping Client orders
													Why: Engineering Improvement Initiatives- NBL(I) task#280*/
	/* 02nd Jan 2016		  Chethan N				What: Retrieving ParentClientOrderid
													Why: Renaissance - Dev Items task #5*/
	/* 03/17/2017			  Pradeep				What : Staff S1 is made as Left join to show all the records which has OrderingPhysician as NULL 
													Why : Allegan - Support : #711*/
	/* 20th Nov 2017		  Chethan N				What: Added NULL check to the Medication Name
													Why: MHP-Environment Issues task #208*/
	/* 28th Mar 2018		  Nandita				What: Removed comma from Strength column value
													Why: AHN SGL Issues task #196
		26 Jul 2018			  Chethan N				What: Removed Active and RecordDeleted check for Orders	
		03 Oct 2018			  Chethan N				What: Replaced OrderedBy filter with OrderingPhysician	
													Why : CCC SGL task #36*/
	/* 31 Jan 2019			  Neha                  What: Retreiving GenerateRequisition, RequisitionReportName, DocumentVersionId and OrderNumber.
													Why: To download Requisition for a particular Client Order	*/
	-- =============================================                         
	@PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@ClientId INT
	,@DOSFrom DATETIME
	,@DOSTo DATETIME
	,@OrderType INT
	,@AssignedTo INT = - 1
	,@OrderedBy INT = - 1
	,@OtherFilter INT
	,@NonStaffUser CHAR(1)
	,@LoggedInStaffId INT = - 1
	,@Status INT = - 1
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
			SELECT CO.ClientOrderId
				,CASE 
					--+ COALESCE(MM.Strength, OS.MedictionOtherStrength, CO.MedicationOtherDosage, '') + ' ' + ISNULL(MM.StrengthUnitOfMeasure, '') 
					--case when (ISNUMERIC(isnull(MM.Strength,'a'))=1 and CHARINDEX('.',MM.Strength) <=0 ) then UPPER(ISNULL(MDF.DosageFormAbbreviation, '') + ' ' + cast(cast(isnull(MM.Strength,1) * isnull(CO.MedicationDosage,1) as int) as varchar(200)) +  ISNULL(MM.StrengthUnitOfMeasure, '') + ' ' +  ISNULL(MDR.RouteAbbreviation, '') + ' ' + otf.DisplayName) else '(' + UPPER(ISNULL(convert(VARCHAR(15),CAST(CAST((ROUND(CO.MedicationDosage , 2)*100) AS INT) AS FLOAT ) /100),'') +') ' + ISNULL(MDF.DosageFormAbbreviation, '') + ' ' + COALESCE(MM.Strength, OS.MedictionOtherStrength, CO.MedicationOtherDosage, '')  + ISNULL(MM.StrengthUnitOfMeasure, '') + ' ' +  ISNULL(MDR.RouteAbbreviation, '') + ' ' + otf.DisplayName) end
					WHEN O.OrderType = 8501
						THEN O.OrderName + ' ' + CASE 
								WHEN (
										ISNUMERIC(isnull(MM.Strength, 'a')) = 1
										AND CHARINDEX('.', MM.Strength) <= 0
										)
									AND (
										MDF.DosageFormDescription = 'Tablet'
										OR MDF.DosageFormDescription = 'Capsule'
										)
									THEN UPPER(ISNULL(MDF.DosageFormAbbreviation, '') + ' ' + cast(cast(isnull(REPLACE(MM.Strength, ',', ''), 1) * isnull(CO.MedicationDosage, 1) AS INT) AS VARCHAR(200)) + ISNULL(MM.StrengthUnitOfMeasure, ''))
								ELSE '(' + UPPER(ISNULL(convert(VARCHAR(15), CAST(CAST((ROUND(CO.MedicationDosage, 2) * 100) AS INT) AS FLOAT) / 100), '') + ') ' + ISNULL(MDF.DosageFormAbbreviation, '') + ' ' + COALESCE(MM.Strength, OS.MedictionOtherStrength, CO.MedicationOtherDosage, '') + ISNULL(MM.StrengthUnitOfMeasure, ''))
								END
					ELSE O.OrderName
					END AS [OrderName]
				,G.CodeName AS [OrderType]
				,
				-- OTF.frequencyname                AS FrequencyName,         
				OTF.DisplayName AS FrequencyName
				,CO.OrderStartDateTime
				,CO.OrderEndDateTime
				,S1.LastName + ', ' + S1.FirstName AS OrderingPhysician
				,S.LastName + ', ' + S.FirstName AS AssignedStaff
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
										)
									AND (
										MDF.DosageFormDescription = 'Tablet'
										OR MDF.DosageFormDescription = 'Capsule'
										)
									THEN UPPER(ISNULL(MDF.DosageFormAbbreviation, '') + ' ' + cast(cast(isnull(REPLACE(MM.Strength, ',', ''), 1) * isnull(CO.MedicationDosage, 1) AS INT) AS VARCHAR(200)) + ISNULL(MM.StrengthUnitOfMeasure, '') + ' ' + ISNULL(MDR.RouteAbbreviation, '') + ' ' + otf.DisplayName)
								ELSE '(' + UPPER(ISNULL(convert(VARCHAR(15), CAST(CAST((ROUND(CO.MedicationDosage, 2) * 100) AS INT) AS FLOAT) / 100), '') + ') ' + ISNULL(MDF.DosageFormAbbreviation, '') + ' ' + COALESCE(MM.Strength, OS.MedictionOtherStrength, CO.MedicationOtherDosage, '') + ISNULL(MM.StrengthUnitOfMeasure, '') + ' ' + ISNULL(MDR.RouteAbbreviation, '') + ' ' + otf.DisplayName)
								END
					ELSE O.OrderName
					END AS OrderToolTip
				,GC3.CodeName AS STATUS
				,CO.ParentClientOrderId
				,L.GenerateRequisition AS GenerateRequisition
				,L.RequisitionReportName AS RequisitionReportName
				,CO.DocumentVersionId AS DocumentVersionId
				,CON.OrderNumber AS OrderNumber
			FROM ClientOrders AS CO
			INNER JOIN Orders AS O ON O.OrderId = CO.OrderId
			LEFT JOIN Laboratories AS L ON L.LaboratoryId = CO.LaboratoryId
			INNER JOIN GlobalCodes AS G ON G.GlobalCodeId = O.OrderType
				AND (Isnull(G.RecordDeleted, 'N') = 'N')
			LEFT JOIN globalcodes AS G1 ON G1.GlobalCodeId = CO.OrderPriorityId
				AND (Isnull(G1.RecordDeleted, 'N') = 'N')
			LEFT JOIN staff S1 ON S1.staffid = CO.OrderingPhysician
				AND (Isnull(S1.RecordDeleted, 'N') = 'N')
			LEFT JOIN staff S ON S.StaffId = CO.AssignedTo
				AND (Isnull(S.RecordDeleted, 'N') = 'N')
			--LEFT JOIN orderfrequencies OFR ON CO.orderfrequencyid = OFR.orderfrequencyid
			--	AND (Isnull(OFR.RecordDeleted, 'N') = 'N')
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
			LEFT JOIN ClientOrderOrderNumbers CON ON CO.ClientOrderId = CON.ClientOrderId
				AND ISNULL(CON.RecordDeleted, 'N') = 'N'
			WHERE (
					CO.clientid = @ClientId
					AND (CO.ORDERFLAG = 'Y')
					AND (Isnull(CO.OrderPended, 'N') = 'N')
					AND (Isnull(CO.OrderPendAcknowledge, 'N') = 'N')
					AND (Isnull(CO.OrderPendRequiredRoleAcknowledge, 'N') = 'N')
					AND Isnull(CO.RecordDeleted, 'N') = 'N'
					AND (
						(
							@NonStaffUser = 'Y'
							AND G.GlobalCodeId IN (
								SELECT IntegerCodeId
								FROM dbo.ssf_RecodeValuesCurrent('Xpatientporatlclientordertypes')
								)
							)
						OR (@NonStaffUser = 'N')
						)
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
					--AND ( @DOSFrom IS NULL         
					--       OR cast(CO.OrderStartDateTime as date) >= @DOSFrom )         
					--AND ( @DOSTo IS NULL         
					--       OR ( cast(CO.OrderStartDateTime as date) <= @DOSTo and (CO.OrderEndDateTime is NULL or cast(CO.OrderEndDateTime as date) <=  @DOSTo) ))       
					AND (
						(
							CAST(ISNULL(@DOSFrom, CO.OrderStartDateTime) AS DATE) <= CAST(CO.OrderStartDateTime AS DATE) -- ignoring time
							AND CAST(ISNULL(@DOSTo, CO.OrderStartDateTime) AS DATE) >= CAST(CO.OrderStartDateTime AS DATE)
							)
						OR (
							CAST(ISNULL(@DOSFrom, CO.OrderStartDateTime) AS DATE) >= CAST(CO.OrderStartDateTime AS DATE)
							AND CAST(ISNULL(@DOSFrom, CO.OrderStartDateTime) AS DATE) <= CAST(ISNULL(CO.OrderEndDateTime, ISNULL(@DOSFrom, CO.OrderStartDateTime)) AS DATE)
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
				,OrderingPhysician
				,AssignedStaff
				,Priority
				,OrderPendAcknowledge
				,OrderPendRequiredRoleAcknowledge
				,OrderPended
				,OrderId
				,OrderToolTip
				,STATUS
				,ParentClientOrderId
				,GenerateRequisition
				,RequisitionReportName
				,DocumentVersionId
				,OrderNumber
				,Count(*) OVER () AS TotalCount
				,Rank() OVER (
					ORDER BY CASE 
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
							WHEN @SortExpression = 'AssignedStaff'
								THEN AssignedStaff
							END
						,CASE 
							WHEN @SortExpression = 'AssignedStaff DESC'
								THEN AssignedStaff
							END DESC
						,CASE 
							WHEN @SortExpression = 'OrderingPhysician'
								THEN OrderingPhysician
							END
						,CASE 
							WHEN @SortExpression = 'OrderingPhysician DESC'
								THEN OrderingPhysician
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
							WHEN @SortExpression = 'ParentClientOrderId'
								THEN ParentClientOrderId
							END
						,CASE 
							WHEN @SortExpression = 'ParentClientOrderId DESC'
								THEN ParentClientOrderId
							END DESC
						,CASE 
							WHEN @SortExpression = 'ClientOrderId'
								THEN ClientOrderId
							END
						,CASE 
							WHEN @SortExpression = 'ClientOrderId DESC'
								THEN ClientOrderId
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
			,OrderingPhysician
			,AssignedStaff
			,Priority
			,OrderPendAcknowledge
			,OrderPendRequiredRoleAcknowledge
			,OrderPended
			,OrderId
			,OrderToolTip
			,STATUS
			,ParentClientOrderId
			,GenerateRequisition
			,RequisitionReportName
			,DocumentVersionId
			,OrderNumber
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
		SET a.OrderName = O.OrderName + ISNULL(' (' + MD.MedicationName + ')', '')
			,a.OrderToolTip = O.OrderName + ISNULL(' (' + MD.MedicationName + ')', '')
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
			,[OrderType]
			,OrderName
			,FrequencyName
			,CONVERT(VARCHAR(10), OrderStartDateTime, 101) + ' ' + RIGHT('0' + LTRIM(RIGHT(CONVERT(VARCHAR, OrderStartDateTime, 100), 7)), 7) AS OrderStartDateTime
			,CONVERT(VARCHAR(10), OrderEndDateTime, 101) + ' ' + RIGHT('0' + LTRIM(RIGHT(CONVERT(VARCHAR, OrderEndDateTime, 100), 7)), 7) AS OrderEndDateTime
			,STATUS
			,OrderingPhysician
			,AssignedStaff
			,Priority
			,OrderPendAcknowledge
			,OrderPendRequiredRoleAcknowledge
			,OrderPended
			,OrderId
			,OrderToolTip
			,ParentClientOrderId
			,GenerateRequisition
			,RequisitionReportName
			,DocumentVersionId
			,OrderNumber
		FROM #finalresultset
		ORDER BY rownumber

		---Unacknowledge Information
		SELECT COUNT(*) AS UnacknowledgeOrdersCount
			,REPLACE(REPLACE(STUFF((
							SELECT ' ' + (
									G.CodeName + ' - ' + O.OrderName + ' - ' + + CASE 
										WHEN (
												ISNUMERIC(isnull(MD.Strength, 'a')) = 1
												AND CHARINDEX('.', MD.Strength) <= 0
												)
											AND (
												MDF.DosageFormDescription = 'Tablet'
												OR MDF.DosageFormDescription = 'Capsule'
												)
											THEN '(' + UPPER(ISNULL(convert(VARCHAR(15), CAST(CAST((ROUND(CO.MedicationDosage, 2) * 100) AS INT) AS FLOAT) / 100), '') + ') ' + ISNULL(MDF.DosageFormAbbreviation, '') + ' ' + cast(cast(isnull(md.Strength, 1) * isnull(CO.MedicationDosage, 1) AS INT) AS VARCHAR(200)) + ISNULL(MD.StrengthUnitOfMeasure, '') + ' ' + ISNULL(MDR.RouteAbbreviation, '') + ' ' + otf.DisplayName)
										ELSE CASE 
												WHEN O.OrderType = 8501
													THEN '(' + UPPER(ISNULL(convert(VARCHAR(15), CAST(CAST((ROUND(CO.MedicationDosage, 2) * 100) AS INT) AS FLOAT) / 100), '') + ') ' + ISNULL(MDF.DosageFormAbbreviation, '') + ' ' + COALESCE(MD.Strength, ODS.MedictionOtherStrength, CO.MedicationOtherDosage, '') + ISNULL(MD.StrengthUnitOfMeasure, '') + ' ' + ISNULL(MDR.RouteAbbreviation, '') + ' ' + otf.DisplayName)
												ELSE UPPER(ISNULL(MDF.DosageFormAbbreviation, '') + ' ' + COALESCE(MD.Strength, ODS.MedictionOtherStrength, CO.MedicationOtherDosage, '') + ISNULL(MD.StrengthUnitOfMeasure, '') + ' ' + ISNULL(MDR.RouteAbbreviation, '') + ' ' + otf.DisplayName)
												END
										END
									) + '<br/>'
							FROM ClientOrders AS CO
							INNER JOIN Orders AS O ON O.OrderId = CO.OrderId
								AND Isnull(CO.RecordDeleted, 'N') = 'N'
								--AND Isnull(O.RecordDeleted, 'N') = 'N'
								--AND Isnull(O.Active, 'Y') = 'Y'
								AND CO.Active = 'Y'
							--LEFT JOIN OrderFrequencies OFR ON CO.OrderFrequencyId = OFR.OrderFrequencyId
							--	AND Isnull(OFR.RecordDeleted, 'N') = 'N'
							LEFT JOIN OrderTemplateFrequencies OTF ON OTF.OrderTemplateFrequencyId = CO.OrderTemplateFrequencyId
								AND Isnull(OTF.RecordDeleted, 'N') = 'N'
							LEFT JOIN Staff S ON S.StaffId = CO.AssignedTo
								AND S.Active = 'Y'
								AND Isnull(S.RecordDeleted, 'N') = 'N'
							LEFT JOIN Staff S1 ON S1.StaffId = CO.OrderedBy
								AND S1.Active = 'Y'
								AND Isnull(S1.RecordDeleted, 'N') = 'N'
							LEFT JOIN GlobalCodes AS G ON G.GlobalCodeId = O.OrderType
								AND Isnull(G.RecordDeleted, 'N') = 'N'
							LEFT JOIN GlobalCodes G1 ON G1.GlobalCodeId = CO.OrderPriorityId
								AND Isnull(G1.RecordDeleted, 'N') = 'N'
							LEFT JOIN OrderStrengths ODS ON ODS.OrderStrengthId = CO.MedicationOrderStrengthId
								AND ISNULL(ODS.RecordDeleted, 'N') != 'Y'
							LEFT JOIN MDMedications md ON md.MedicationId = ISNULL(ODS.MedicationId, 0)
								AND ISNULL(md.RecordDeleted, 'N') != 'Y'
							LEFT JOIN MDRoutedDosageFormMedications MDRF ON MDRF.RoutedDosageFormMedicationId = Md.RoutedDosageFormMedicationId
								AND ISNULL(MDRF.RecordDeleted, 'N') = 'N'
							LEFT JOIN MDDosageForms MDF ON MDF.DosageFormId = MDRF.DosageFormId
								AND ISNULL(MDF.RecordDeleted, 'N') = 'N'
							LEFT JOIN GlobalCodes AS GC2 -- for frequency
								ON GC2.GlobalCodeId = OTF.FrequencyId
								AND ISNULL(GC2.RecordDeleted, 'N') = 'N'
							LEFT JOIN OrderRoutes AS ORT -- for routes
								ON ORT.OrderRouteId = CO.MedicationOrderRouteId
								AND ISNULL(ORT.RecordDeleted, 'N') = 'N'
							LEFT JOIN MDRoutes AS MDR ON MDR.RouteId = ORT.RouteId
								AND ISNULL(ORT.RecordDeleted, 'N') = 'N'
							WHERE CO.clientid = @ClientId
								AND (
									CO.OrderPended = 'Y'
									OR CO.OrderPendAcknowledge = 'Y'
									OR CO.OrderPendRequiredRoleAcknowledge = 'Y'
									)
								AND CO.OrderFlag = 'Y'
							FOR XML PATH('')
							), 1, 1, ''), '&lt;', '<'), '&gt;', '>') 'UnacknowledgeOrders'
		FROM ClientOrders AS CO
		INNER JOIN Orders AS O ON O.OrderId = CO.OrderId
			AND Isnull(CO.RecordDeleted, 'N') = 'N'
			--AND Isnull(O.RecordDeleted, 'N') = 'N'
			--AND Isnull(O.Active, 'Y') = 'Y'
			AND CO.Active = 'Y'
		--LEFT JOIN OrderFrequencies OFR ON CO.OrderFrequencyId = OFR.OrderFrequencyId
		--	AND Isnull(OFR.RecordDeleted, 'N') = 'N'
		LEFT JOIN OrderTemplateFrequencies OTF ON OTF.OrderTemplateFrequencyId = CO.OrderTemplateFrequencyId
			AND Isnull(OTF.RecordDeleted, 'N') = 'N'
		LEFT JOIN Staff S ON S.StaffId = CO.AssignedTo
			AND S.Active = 'Y'
			AND Isnull(S.RecordDeleted, 'N') = 'N'
		LEFT JOIN Staff S1 ON S1.StaffId = CO.OrderedBy
			AND S1.Active = 'Y'
			AND Isnull(S1.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes AS G ON G.GlobalCodeId = O.OrderType
			AND Isnull(G.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes G1 ON G1.GlobalCodeId = CO.OrderPriorityId
			AND Isnull(G1.RecordDeleted, 'N') = 'N'
		WHERE CO.clientid = @ClientId
			AND (
				CO.OrderPended = 'Y'
				OR CO.OrderPendAcknowledge = 'Y'
				OR CO.OrderPendRequiredRoleAcknowledge = 'Y'
				)
			AND CO.OrderFlag = 'Y'

		DROP TABLE #customfilters
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_ListClientMemberOrder') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())

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


