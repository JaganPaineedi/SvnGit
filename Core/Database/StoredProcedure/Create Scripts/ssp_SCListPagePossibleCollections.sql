/****** Object:  StoredProcedure [dbo].[ssp_SCListPagePossibleCollections]    Script Date: 08/10/2015 19:40:01 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCListPagePossibleCollections]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCListPagePossibleCollections]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCListPagePossibleCollections]    Script Date: 08/10/2015 19:40:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCListPagePossibleCollections] @PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@ProgramFilter INT
	,@ProgramViewFilter INT
	,@Balance DECIMAL(10, 2)
	,@LastPaymentDate DATETIME
	,@StaffId INT
	,@Days INT
	,@OtherFilter INT
	,@ExcludeIC CHAR(1) = 'Y'
	/********************************************************************************                                                          
-- Stored Procedure: ssp_SCListPagePossibleCollections        
--        
-- Copyright: Streamline Healthcate Solutions        
--        
-- Purpose: To display clients data in possible collections     
--        
-- Author:  Vamsi.N        
-- Date:    02/27/2015        
-- Date              Author                  Purpose                   
-- 27-Aug-2015		 Akwinass				 Modified based on latest requirement(Task #936 in Valley - Customizations) 
-- 24-Nov-2015  Manjunath K             What:Added Condition in "where" for filtering ProgramView.  
           Why :Clients who were not part of those programs were displaying.  
-- 11-Dec-2015		 Venkatesh				 Show all the collections based new parameter Exclude InternalCollections
-- 03-Mar-2017		 Chethan N				 What : Excluding clients for which the payment received date is less than the ‘X’ days which is entered in the ‘# of Days Old >’ filter
--											 Why : Bradford - Support Go Live task #337 
-- 22-Feb-2018      Gautam                   What: Changed the code to improve performances, Valley - Support Go Live, #1439 -Possible Collections page is not opening 
-- 27-July-2018		Bibhu					 what:Added join with staffclients table to display associated clients for login staff  
          									 why:Engineering Improvement Initiatives- NBL(I) task #77 My office List Pages should always have StaffID as an input parameter  
*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		DECLARE @CustomFiltersApplied CHAR(1) = 'N'

		SET @SortExpression = RTRIM(LTRIM(@SortExpression))

		IF ISNULL(@SortExpression, '') = ''
			SET @SortExpression = 'ClientName DESC'

		--          
		--Declare table to get data if Other filter exists -------          
		--          
		CREATE TABLE #PossibleCollections (ClientId INT NOT NULL)

		CREATE TABLE #TotalPossibleCollections (
			ClientId INT
			,ClientName VARCHAR(250)
			,DateOfLastVisit DATETIME
			,FinancialResponsible VARCHAR(MAX)
			,TotalAmountDue DECIMAL(18, 2)
			,DateOfLastPayment DATETIME
			,PrimaryClinician VARCHAR(250)
			,PrimaryProgram VARCHAR(250)
			,ServiceId INT
			,PaymentId INT
			,FinancialActivityId INT
			,Collections VARCHAR(3)
			)

		-- --          
		-- --Get custom filters           
		-- --                                                      
		IF @OtherFilter > 10000
		BEGIN
			IF OBJECT_ID('dbo.scsp_SCListPagePossibleCollections', 'P') IS NOT NULL
			BEGIN
				SET @CustomFiltersApplied = 'Y'

				INSERT INTO #PossibleCollections (ClientId)
				EXEC scsp_SCListPagePossibleCollections @ProgramFilter = @ProgramFilter
					,@ProgramViewFilter = @ProgramViewFilter
					,@Balance = @Balance
					,@LastPaymentDate = @LastPaymentDate
					,@StaffId = @StaffId
					,@Days = @Days
					,@OtherFilter = @OtherFilter
			END
		END
				-- --                                         
				-- --Insert data in to temp table which is fetched below by appling filter.             
				-- 22-Feb-2018      Gautam     
				;
				WITH ClientList as (
				SELECT C.ClientId
				FROM Clients C
				WHERE (
					@CustomFiltersApplied = 'Y'
					AND EXISTS (
						SELECT *
						FROM #PossibleCollections cf
						WHERE cf.ClientId = c.ClientId
						)
					)
				OR (
					@CustomFiltersApplied = 'N'
					AND NOT EXISTS (
						SELECT 1
						FROM Collections CO
						JOIN globalcodes gc ON gc.globalcodeid = co.collectionstatus
							AND gc.code NOT IN (
								'STECA'
								,'R'
								)
						WHERE CO.ClientId = c.ClientId
							AND ISNULL(CO.RecordDeleted, 'N') = 'N'
							AND ISNULL(@ExcludeIC, 'Y') = 'Y'
						)
					AND C.Active = 'Y'
					AND ISNULL(C.RecordDeleted, 'N') = 'N'
					AND (
						@Balance IS NULL
						OR ISNULL(C.CurrentBalance, 0.00) > CAST(@Balance AS MONEY)
						)
					AND NOT EXISTS (
						SELECT 1
						FROM Payments P
						WHERE P.ClientId = C.ClientId
							AND (DATEDIFF(dd, P.DateReceived, GETDATE()) < ISNULL(@Days, 0))
						)
					)
					), 
				 TempClientPossibleCOllection
		AS (
			SELECT C.ClientId
				,ROW_NUMBER() OVER (
					PARTITION BY C.ClientId ORDER BY C.ClientId
						,S.DateOfService DESC
						,CC.ModifiedDate DESC
						,P.DateReceived DESC
						,CP.ModifiedDate DESC
					) AS ROW
				,C.LastName + ',' + + ' ' + C.FirstName + '(' + CONVERT(VARCHAR, C.ClientId) + ')' AS ClientName
				,S.DateOfService AS DateOfLastVisitText
				,S.ServiceId AS DateOfLastVisitId
				,CC.LastName + ', ' + CC.FirstName AS FinancialResponsible
				,P.DateReceived AS DateOfLastPayment
				,Pg.ProgramCode AS PrimaryProgram
				,P.PaymentId AS DateOfLastPaymentId
				,P.FinancialActivityId AS FinancialActivityId
				,St.LastName + ', ' + St.FirstName AS PrimaryClinician
				,ISNULL(C.CurrentBalance, 0.00) AS TotalAmountDue
				,CASE 
					WHEN EXISTS (
							SELECT 1
							FROM Collections CO
							JOIN globalcodes gc ON gc.globalcodeid = co.collectionstatus
								AND gc.code NOT IN (
									'STECA'
									,'R'
									)
							WHERE CO.ClientId = c.ClientId
								AND ISNULL(CO.RecordDeleted, 'N') = 'N'
							)
						THEN 'Yes'
					ELSE 'No'
					END Collections
			FROM ClientList CL
			Join Clients C on CL.ClientId= C.ClientId
			INNER JOIN StaffClients sc ON  sc.StaffId = @StaffId AND sc.ClientId = CL.ClientId    ------------  27-July-2018		Bibhu	
			LEFT JOIN Services S ON C.ClientId = S.ClientId
				AND Isnull(S.RecordDeleted, 'N') <> 'Y'
				AND S.Billable = 'Y'
				AND S.[Status] IN (
					71
					,75
					)
			LEFT JOIN ClientContacts CC ON CC.ClientId = C.ClientId
				AND ISNULL(CC.RecordDeleted, 'N') = 'N'
				AND ISNULL(CC.FinanciallyResponsible, 'N') = 'Y'
				AND ISNULL(CC.Active, 'N') = 'Y'
			LEFT JOIN Payments P ON P.ClientId = C.ClientId
				AND ISNULL(P.RecordDeleted, 'N') = 'N'
			LEFT JOIN ClientPrograms AS cp ON cp.ClientId = C.ClientId
				AND ISNULL(cp.RecordDeleted, 'N') = 'N'
				AND cp.[Status] = 4
				AND ISNULL(cp.PrimaryAssignment, 'N') = 'Y'
			LEFT JOIN Programs pg ON cp.ProgramId = pg.ProgramId
				AND ISNULL(pg.RecordDeleted, 'N') = 'N'
				AND ISNULL(pg.Active, 'N') = 'Y'
			LEFT JOIN Staff AS st ON st.StaffId = C.PrimaryClinicianId
			 
			WHERE (
					@CustomFiltersApplied = 'Y'
					--AND EXISTS (
					--	SELECT *
					--	FROM #PossibleCollections cf
					--	WHERE cf.ClientId = c.ClientId
					--	)
					)
				OR (
					@CustomFiltersApplied = 'N'
					AND (
						@ProgramFilter = 0
						OR pg.ProgramId = @ProgramFilter
						)
					AND (
						ISNULL(@ProgramViewFilter, 0) = 0
						OR (
							cp.[Status] = 4
							AND EXISTS (
								SELECT 1
								FROM ProgramViewPrograms PV
								WHERE PV.ProgramViewId = @ProgramViewFilter
									AND PV.ProgramId = CP.ProgramId
									AND ISNULL(PV.RecordDeleted, 'N') = 'N'
								)
							)
						)
					AND (
						@Balance IS NULL
						OR ISNULL(C.CurrentBalance, 0.00) > CAST(@Balance AS MONEY)
						)
					AND (
						@LastPaymentDate IS NULL
						OR CAST(P.DateReceived AS DATE) > cast(@LastPaymentDate AS DATE)
						)
					)
			)
			
		INSERT INTO #TotalPossibleCollections (
			ClientId
			,ClientName
			,DateOfLastVisit
			,FinancialResponsible
			,TotalAmountDue
			,DateOfLastPayment
			,PrimaryClinician
			,PrimaryProgram
			,ServiceId
			,PaymentId
			,FinancialActivityId
			,Collections
			)
		SELECT T.ClientId
			,T.ClientName
			,T.DateOfLastVisitText AS DateOfLastVisit
			,ISNULL(T.FinancialResponsible, T.ClientName) AS FinancialResponsible
			,T.TotalAmountDue
			,T.DateOfLastPayment AS DateOfLastPayment
			,T.PrimaryClinician
			,T.PrimaryProgram
			,T.DateOfLastVisitId AS ServiceId
			,T.DateOfLastPaymentId AS PaymentId
			,T.FinancialActivityId
			,T.Collections
		FROM TempClientPossibleCOllection t 
		WHERE t.ROW = 1

		IF @PageNumber = - 1
		BEGIN
			SET @PageSize = (
					SELECT COUNT(*) AS totalrows
					FROM #TotalPossibleCollections
					)
		END;

		WITH PossibleCollections
		AS (
			SELECT ClientId
				,ClientName
				,DateOfLastVisit
				,FinancialResponsible
				,TotalAmountDue
				,DateOfLastPayment
				,PrimaryClinician
				,PrimaryProgram
				,ServiceId
				,PaymentId
				,FinancialActivityId
				,Collections
				,COUNT(*) OVER () AS TotalCount
				,ROW_NUMBER() OVER (
					ORDER BY CASE 
							WHEN @SortExpression = 'ClientName'
								THEN ClientName
							END
						,CASE 
							WHEN @SortExpression = 'ClientName DESC'
								THEN ClientName
							END DESC
						,CASE 
							WHEN @SortExpression = 'FinancialResponsible'
								THEN FinancialResponsible
							END
						,CASE 
							WHEN @SortExpression = 'FinancialResponsible DESC'
								THEN FinancialResponsible
							END DESC
						,CASE 
							WHEN @SortExpression = 'DateOfLastVisit'
								THEN DateOfLastVisit
							END
						,CASE 
							WHEN @SortExpression = 'DateOfLastVisit DESC'
								THEN DateOfLastVisit
							END DESC
						,CASE 
							WHEN @SortExpression = 'TotalAmountDue'
								THEN TotalAmountDue
							END
						,CASE 
							WHEN @SortExpression = 'TotalAmountDue DESC'
								THEN TotalAmountDue
							END DESC
						,CASE 
							WHEN @SortExpression = 'DateOfLastPayment'
								THEN DateOfLastPayment
							END
						,CASE 
							WHEN @SortExpression = 'DateOfLastPayment DESC'
								THEN DateOfLastPayment
							END DESC
						,CASE 
							WHEN @SortExpression = 'PrimaryClinician'
								THEN PrimaryClinician
							END
						,CASE 
							WHEN @SortExpression = 'PrimaryClinician DESC'
								THEN PrimaryClinician
							END DESC
						,CASE 
							WHEN @SortExpression = 'PrimaryProgram'
								THEN PrimaryProgram
							END
						,CASE 
							WHEN @SortExpression = 'PrimaryProgram DESC'
								THEN PrimaryProgram
							END DESC
						,CASE 
							WHEN @SortExpression = 'Collections'
								THEN Collections
							END
						,CASE 
							WHEN @SortExpression = 'Collections DESC'
								THEN Collections
							END DESC
						,ClientId
					) AS RowNumber
			FROM #TotalPossibleCollections
			)
		SELECT TOP (@PageSize) ClientId
			,ClientName
			,convert(VARCHAR, DateOfLastVisit, 101) AS DateOfLastVisit
			,FinancialResponsible
			,'$ ' + CAST(TotalAmountDue AS VARCHAR) TotalAmountDue
			,convert(VARCHAR, DateOfLastPayment, 101) AS DateOfLastPayment
			,PrimaryClinician
			,PrimaryProgram
			,ServiceId
			,PaymentId
			,FinancialActivityId
			,Collections
			,TotalCount
			,RowNumber
		INTO #FinalResultSet
		FROM PossibleCollections
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

		SELECT ClientId
			,ClientName
			,DateOfLastVisit
			,FinancialResponsible
			,TotalAmountDue
			,DateOfLastPayment
			,PrimaryClinician
			,PrimaryProgram
			,ServiceId
			,PaymentId
			,FinancialActivityId
			,Collections
		FROM #FinalResultSet 
		ORDER BY RowNumber
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCListPagePossibleCollections') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


