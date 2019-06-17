/****** Object:  StoredProcedure [dbo].[ssp_ListOrdersAndRounding]    Script Date: 12th feb 2016 18:40:12 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListOrdersAndRounding]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_ListOrdersAndRounding]
GO

/****** Object:  StoredProcedure [dbo].[ssp_ListOrdersAndRounding]    Script Date:12th feb 2016 18:40:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_ListOrdersAndRounding]
	-- =============================================                            
	-- Author: Seema Thakur                          
	-- Create date:12th feb 2016                          
	-- Description: Return the  Orders data for List page based on the filter.                     
	-- exec ssp_ListOrdersAndRounding -1,100,'OrderName', 2,null,null,-1,-1,-1,-1,550,-1    
	/*																					*/
	/*  Date                  Author                 Purpose								*/
	/* 12th feb 2016         Seema	Thakur 			 Created									
		26 Jul 2018			  Chethan N				 What: Removed Active and RecordDeleted check for Orders*/

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
	,@Active INT
	,@StaffId INT
	,@OtherFilter INT
	,@LoggedInStaffId INT = -1
	,@ClientName VARCHAR(100)
AS
BEGIN
	BEGIN TRY
		CREATE TABLE #CustomFilters (ClientOrderId INT NOT NULL)

		CREATE TABLE #StaffOrderRoles (
			OrderId INT
			,NeedsToAcknowledge CHAR(1)
			,CanAcknowledge CHAR(1)
			,CanPendingRelease CHAR(1)
			)

		INSERT INTO #StaffOrderRoles
		SELECT OA.OrderId
			,max(isnull(OA.NeedsToAcknowledge, 'N'))
			,max(isnull(OA.CanAcknowledge, 'N'))
			,max(isnull(OA.CanPendingRelease, 'N'))
		FROM OrderAcknowledgments OA
		LEFT JOIN StaffRoles SR ON OA.RoleId = SR.RoleId
			AND Isnull(OA.RecordDeleted, 'N') = 'N'
			AND Isnull(SR.RecordDeleted, 'N') = 'N'
		WHERE SR.StaffId = @StaffId
		GROUP BY OA.OrderId
		
		DECLARE @ApplyFilterClicked CHAR(1)
		DECLARE @CustomFilterApplied CHAR(1)
		
		------ Get Permissioned Orders for the logged in Staff ------		
		CREATE TABLE #PermissionTable ( PermissionItemId int )
		INSERT INTO #PermissionTable (PermissionItemId)
			EXEC ssp_GetPermisionedOrder @LoggedInStaffId = @LoggedInStaffId
		
		CREATE TABLE #FinalresultwithQA(
		 ClientOrderId INT
			,OrderName  VARCHAR(100)
			,[OrderType] VARCHAR(100)
			,FrequencyName VARCHAR(100)
			,OrderStartDateTime DATETIME
			,OrderEndDateTime DATETIME
			,OrderedBy VARCHAR(100)
			,AssignedStaff VARCHAR(100)
			,Priority VARCHAR(100)
			,OrderPendAcknowledge CHAR(1)
			,OrderPendRequiredRoleAcknowledge CHAR(1)
			,OrderPended CHAR(1)
			,OrderId INT
			,Active VARCHAR(10)
			,AcknowledgeStatus CHAR(1)
			,ReleaseStatus CHAR(1)
			,OrderToolTip VARCHAR(MAX)
			,QnA VARCHAR(MAX)
			,clientName VARCHAR(MAX)
			,ClientId INT
			)
		
		CREATE TABLE #Questions (
			QId INT
			,ClientOrderId INT
			,Que VARCHAR(max)
			,ans VARCHAR(max)
			)

		SET @SortExpression = Rtrim(Ltrim(@SortExpression))

		IF Isnull(@SortExpression, '') = ''
		BEGIN
			SET @SortExpression = 'OrderName'
		END

		SET @ApplyFilterClicked = 'Y'
		SET @CustomFilterApplied = 'N'

		IF @OtherFilter > 10000
		BEGIN
			SET @CustomFilterApplied = 'Y'

			INSERT INTO #CustomFilters (ClientOrderId)
			EXEC scsp_scClientOrders @OrderType = @OrderType
				,@AssignedTo = @AssignedTo
				,@OtherFilter = @OtherFilter
		END;

		WITH listclientorders
		AS (
			SELECT CO.ClientOrderId
				,O.OrderName
				,G.CodeName AS [OrderType]
				,OTF.DisplayName AS FrequencyName
				,CO.OrderStartDateTime
				,CO.OrderEndDateTime
				,CASE 
					WHEN S1.DisplayAs IS NULL
						THEN S1.LastName + ' ' + S1.FirstName
					ELSE S1.DisplayAs
					END AS OrderedBy
				,CASE 
					WHEN S.DisplayAs IS NULL
						THEN S.LastName + ' ' + S.FirstName
					ELSE S.DisplayAs
					END AS AssignedStaff
				,G1.CodeName AS Priority
				,CO.OrderPendAcknowledge
				,CO.OrderPendRequiredRoleAcknowledge
				,CO.OrderPended
				,CO.OrderId
				,Active = CASE Isnull(CO.Active, 'Y')
					WHEN 'Y'
						THEN 'Active'
					ELSE 'Inactive'
					END
				,AcknowledgeStatus = CASE 
					WHEN isnull(SOR.NeedsToAcknowledge, 'N') = 'Y'
						THEN CASE 
								WHEN isnull(CO.OrderPendRequiredRoleAcknowledge, 'N') = 'Y'
									THEN 'Y'
								ELSE 'N'
								END
					ELSE CASE 
							WHEN isnull(SOR.CanAcknowledge, 'N') = 'Y'
								THEN CASE 
										WHEN isnull(CO.OrderPendAcknowledge, 'N') = 'Y'
											THEN 'Y'
										ELSE 'N'
										END
							END
					END
				,ReleaseStatus = CASE 
					WHEN isnull(SOR.CanPendingRelease, 'N') = 'Y'
						THEN CASE 
								WHEN isnull(CO.OrderPended, 'N') = 'Y'
									THEN 'Y'
								ELSE 'N'
								END
					ELSE 'N'
					END
				,CASE 
					WHEN O.OrderType = 8501
						THEN O.OrderName + ' <br/> Sig: ' 
						+ case when (ISNUMERIC(isnull(MM.Strength,'a'))=1 and CHARINDEX('.',MM.Strength) <=0 ) and (MDF.DosageFormDescription ='Tablet' or MDF.DosageFormDescription ='Capsule') then UPPER(ISNULL(MDF.DosageFormAbbreviation, '') + ' ' + cast(cast(isnull(MM.Strength,1) * isnull(CO.MedicationDosage,1) as int) as varchar(200)) +  ISNULL(MM.StrengthUnitOfMeasure, '') + ' ' +  ISNULL(MDR.RouteAbbreviation, '') + ' ' + otf.DisplayName) else '(' + UPPER(ISNULL(convert(VARCHAR(15),CAST(CAST((ROUND(CO.MedicationDosage , 2)*100) AS INT) AS FLOAT ) /100),'') +') ' + ISNULL(MDF.DosageFormAbbreviation, '') + ' ' + COALESCE(MM.Strength, OS.MedictionOtherStrength, CO.MedicationOtherDosage, '')  + ISNULL(MM.StrengthUnitOfMeasure, '') + ' ' +  ISNULL(MDR.RouteAbbreviation, '') + ' ' + otf.DisplayName) end
					ELSE O.OrderName
					END AS OrderToolTip
				,CASE 
					WHEN C.ClientType='I'
						THEN C.LastName+', '+C.FirstName +' ('+ CAST(C.ClientId as varchar)+')' 
					ELSE C.OrganizationName
					END as clientName
				,C.ClientId as ClientId
			FROM ClientOrders AS CO
			INNER JOIN Orders AS O ON O.OrderId = CO.OrderId
				AND Isnull(CO.RecordDeleted, 'N') = 'N'
				--AND Isnull(O.RecordDeleted, 'N') = 'N'
				--AND Isnull(O.Active, 'Y') = 'Y'
			LEFT JOIN OrderTemplateFrequencies OTF ON OTF.OrderTemplateFrequencyId = CO.OrderTemplateFrequencyId
				AND Isnull(OTF.RecordDeleted, 'N') = 'N'
			LEFT JOIN Staff S ON S.StaffId = CO.AssignedTo
				AND Isnull(S.RecordDeleted, 'N') = 'N'
			LEFT JOIN Staff S1 ON S1.StaffId = CO.OrderedBy
				AND Isnull(S1.RecordDeleted, 'N') = 'N'
			LEFT JOIN GlobalCodes AS G ON G.GlobalCodeId = O.OrderType
				AND Isnull(G.RecordDeleted, 'N') = 'N'
			LEFT JOIN GlobalCodes G1 ON G1.GlobalCodeId = CO.OrderPriorityId
				AND Isnull(G1.RecordDeleted, 'N') = 'N'
			LEFT JOIN #StaffOrderRoles SOR ON CO.OrderId = SOR.OrderId
			LEFT JOIN OrderStrengths AS OS -- for strengths
				ON CO.MedicationOrderStrengthId = OS.OrderStrengthId
				AND ISNULL(OS.RecordDeleted, 'N') = 'N'
			LEFT JOIN MdMedications MM ON MM.medicationId = OS.medicationId
				AND ISNULL(MM.RecordDeleted, 'N') = 'N'
			LEFT JOIN MDRoutedDosageFormMedications MDRF ON MDRF.RoutedDosageFormMedicationId=MM.RoutedDosageFormMedicationId
                AND ISNULL(MDRF.RecordDeleted, 'N') = 'N'
            LEFT JOIN MDDosageForms MDF ON MDF.DosageFormId=MDRF.DosageFormId
                AND ISNULL(MDF.RecordDeleted, 'N') = 'N'		
			LEFT JOIN GlobalCodes AS GC2 -- for frequency
				ON GC2.GlobalCodeId = OTF.FrequencyId
				AND ISNULL(GC2.RecordDeleted, 'N') = 'N'
			LEFT JOIN OrderRoutes AS ORT -- for routes
				ON ORT.OrderRouteId = CO.MedicationOrderRouteId
				AND ISNULL(ORT.RecordDeleted, 'N') = 'N'
			LEFT JOIN MDRoutes AS MDR ON MDR.RouteId = ORT.RouteId
				AND ISNULL(ORT.RecordDeleted, 'N') = 'N'
			JOIN Clients AS C ON CO.ClientId = C.ClientId AND ISNULL(C.RecordDeleted, 'N') = 'N' AND C.Active = 'Y' --Seema
			JOIN StaffClients AS SC ON SC.StaffId = @StaffId AND SC.ClientId  = C.ClientId--Seema
			WHERE ((@ClientId = 0
							OR (
								CO.clientid=@ClientId
								)
							)
					AND 
					 (@ClientName = ''
							OR (
								C.FirstName like '%'+@ClientName+'%' OR C.LastName like '%'+@ClientName+'%'
								)
								OR (C.OrganizationName like '%'+@ClientName+'%')
							)	
					AND (
						CO.OrderPended = 'Y'
						OR CO.OrderPendAcknowledge = 'Y'
						OR CO.OrderPendRequiredRoleAcknowledge = 'Y'
						)
					AND CO.OrderFlag = 'Y'
					AND (
						(
							@CustomFilterApplied = 'Y'
							AND EXISTS (
								SELECT *
								FROM #customfilters CF
								WHERE CF.clientorderid = CO.clientorderid
								)
							)
						OR (
							@CustomFilterApplied = 'N'
							AND (
								Isnull(@OrderType, - 1) = - 1
								OR O.ordertype = @OrderType
								)
							)
						AND (
							@Active = - 1
							OR (
								@Active = 1
								AND Isnull(CO.active, 'Y') = 'Y'
								)
							OR (
								@Active = 2
								AND Isnull(CO.active, 'N') = 'N'
								)
							)
						)
					AND CASE 
						WHEN (@AssignedTo > - 1)
							THEN CASE 
									WHEN (CO.assignedto = @AssignedTo)
										THEN 1
									END
						ELSE 1
						END = 1
					AND CASE 
						WHEN (@OrderedBy > - 1)
							THEN CASE 
									WHEN (CO.orderedby = @OrderedBy)
										THEN 1
									END
						ELSE 1
						END = 1
					AND (
						@DOSFrom IS NULL
						OR CO.orderstartdatetime >= @DOSFrom
						)
					AND (
						@DOSTo IS NULL
						OR CO.orderstartdatetime <= @DOSTo
						)
					AND (
							ISNULL(O.Permissioned,'N')='N' 
							OR 
							(
								O.Permissioned= 'Y' 
								AND Exists (SELECT 1 from #PermissionTable where PermissionItemId = O.OrderId)
							)
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
				,AssignedStaff
				,Priority
				,OrderPendAcknowledge
				,OrderPendRequiredRoleAcknowledge
				,OrderPended
				,OrderId
				,Active
				,AcknowledgeStatus
				,ReleaseStatus
				,OrderToolTip
				,clientName
				,ClientId
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
							WHEN @SortExpression = 'Active'
								THEN Active
							END
						,CASE 
							WHEN @SortExpression = 'Active DESC'
								THEN Active
							END DESC
						,CASE 
							WHEN @SortExpression = 'clientName'
								THEN clientName
							END
						,CASE 
							WHEN @SortExpression = 'clientName DESC'
								THEN clientName
							END DESC
						,ClientOrderId
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
			,AssignedStaff
			,Priority
			,OrderPendAcknowledge
			,OrderPendRequiredRoleAcknowledge
			,OrderPended
			,OrderId
			,Active
			,AcknowledgeStatus
			,ReleaseStatus
			,OrderToolTip
			,totalcount
			,rownumber
			,clientName
			,ClientId
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

		INSERT INTO #FinalresultwithQA
		SELECT ClientOrderId
			,OrderName
			,[OrderType]
			,FrequencyName
			,CONVERT(VARCHAR(10), OrderStartDateTime, 101) + ' ' + RIGHT('0'+LTRIM(RIGHT(CONVERT(VARCHAR, OrderStartDateTime, 100), 7)),7) AS OrderStartDateTime
			,CONVERT(VARCHAR(10), OrderEndDateTime, 101) + ' ' + RIGHT('0'+LTRIM(RIGHT(CONVERT(VARCHAR, OrderEndDateTime, 100), 7)),7) AS OrderEndDateTime
			,OrderedBy
			,AssignedStaff
			,Priority
			,OrderPendAcknowledge
			,OrderPendRequiredRoleAcknowledge
			,OrderPended
			,OrderId
			,Active
			,isnull(AcknowledgeStatus, 'N') AS AcknowledgeStatus
			,isnull(ReleaseStatus, 'N') AS ReleaseStatus
			,OrderToolTip
			,''
			,clientName
			,ClientId
		FROM #finalresultset
		ORDER BY rownumber
		
		Insert into #Questions
		select distinct  
		   OQ.QuestionId
		   ,CO.ClientOrderId
		   ,OQ.Question   
		   ,(case when (CQ.AnswerType=8535 or  CQ.AnswerType=8536 or  CQ.AnswerType=8538) then GC.CodeName
		   else (case when (CQ.AnswerType=8537 or  CQ.AnswerType=8537 OR CQ.AnswerType=8539) then CQ.AnswerText else
		   case when  CQ.AnswerType=8540 then CONVERT(VARCHAR(10), CQ.AnswerDateTime, 101) else 
		   (CASE WHEN RIGHT(CONVERT(varchar, CQ.AnswerDateTime, 100), 8) = ' 12:00AM' THEN CONVERT(varchar, CQ.AnswerDateTime, 101) ELSE CONVERT(varchar, CQ.AnswerDateTime, 101) +' '+ RIGHT('0'+LTRIM(RIGHT(CONVERT(varchar,CQ.AnswerDateTime,0),7)),7) END)
			end
			end) end) as answer   
		   from OrderQuestions OQ
		   join  ClientOrders  CO on OQ.Orderid = CO.OrderId
		   join dbo.ClientOrderQnAnswers CQ on CQ.QuestionId=OQ.QuestionId and CO.ClientOrderId= CQ.ClientOrderId
		   left join GlobalCodes GC on Gc.GlobalCodeId=CQ.AnswerValue AND ISNULL(Gc.RecordDeleted,'N')<>'Y'
		   JOIN #FinalresultwithQA FQA ON FQA.ClientOrderId = CO.ClientOrderId
		   where ISNULL(OQ.RecordDeleted,'N')<>'Y' 
		   AND ISNULL(CQ.RecordDeleted,'N')<>'Y'
		   AND ISNULL(CO.RecordDeleted,'N')<>'Y'
		
		UPDATE  FQA 
		SET QnA = REPLACE(REPLACE(STUFF(  
			  (SELECT Distinct ' ' + Convert(VARCHAR(MAX), ROW_NUMBER() OVER( ORDER BY QE.ClientOrderId)) +'. '+ CASE WHEN RIGHT(QE.Que,1) = '?' THEN QE.Que ELSE QE.Que + '?' END  +  ' '  + QE.ans  +'</br>' 
			  From #Questions QE  
			  Where  FQA.ClientOrderId = QE.ClientOrderId              
			  FOR XML PATH(''))  
			  ,1,1,'')  
			  ,'&lt;','<'),'&gt;','>')
		FROM #FinalresultwithQA FQA
		
		SELECT ClientOrderId
			,clientName as ClientName
			,[OrderType]
			,OrderName
			,FrequencyName as Frequency
			,Priority
			,Active as Status
			,OrderStartDateTime as StartDate
			,OrderEndDateTime as EndDate
			,OrderedBy
			,AssignedStaff as AssignedTo
			,OrderPendAcknowledge
			,OrderPendRequiredRoleAcknowledge
			,OrderPended
			,OrderId
			,AcknowledgeStatus
			,ReleaseStatus
			,OrderToolTip
			,QnA
			,ClientId
		FROM #FinalresultwithQA


		DROP TABLE #customfilters

		DROP TABLE #StaffOrderRoles

		DROP TABLE #finalresultset
		
		DROP TABLE #FinalresultwithQA
		
		DROP TABLE #Questions
		
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_ListOrdersAndRounding') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())

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

