/****** Object:  StoredProcedure [dbo].[ssp_ListPageClientReminders]    Script Date: 10/07/2014 15:04:34 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageClientReminders]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_ListPageClientReminders]
GO

/****** Object:  StoredProcedure [dbo].[ssp_ListPageClientReminders]    Script Date: 10/07/2014 15:04:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_ListPageClientReminders] @SessionId VARCHAR(30)
	,@InstanceId INT
	,@PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@ReminderDateFromFilter DATETIME
	,@ReminderDateToFilter DATETIME
	,@ReminderStatusFilter VARCHAR(2)
	,@ReminderTypeFilter INT
	,@ReminderCommTypeFilter INT
	,@LoggedInStaffId INT
	,@StaffId INT
	/********************************************************************************                                          
-- Stored Procedure: ssp_ListPageClientReminder                                          
--                                          
-- Copyright: Streamline Healthcare Solutions                                          
--                                          
-- Purpose:	Used By Client Reminder List Page                                        
--                                          
-- Updates:                                                                                                 
-- Date         Author             Purpose                                          
-- 12.07.2011   Priyanka Gupta     CREATED.
-- 22.07.2011	Shifali			   Modified for Data Model Changes	   
-- 07.JAN.2014	Revathi			   what:Added join with staffclients table to display associated clients for login staff
								   why:Engineering Improvement Initiatives- NBL(I) task #77 My office List Pages should always have StaffID as an input parameter                                              
-- Oct.01.2014	Pradeep.A		   Merged the Code CHanges done by Sharth for the Meaningful USe task #46.	
--JUN.20.2016	Ravichandra		   Removed the physical table ListPageSCClientReminders from SP
--								   Why:Task #108, Engineering Improvement Initiatives- NBL(I)	
--								   108 - Do NOT use list page tables for remaining list pages (refer #107)								   
*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		CREATE TABLE #ResultSET (
			ClientReminderId INT
			,Processed VARCHAR(3)
			,ClientId INT
			,ClientName VARCHAR(200)
			,Phone VARCHAR(50)
			,ReminderTypeName VARCHAR(100)
			,ReminderDate DATETIME
			,CommunicationType VARCHAR(250)
			)


		INSERT INTO #ResultSET (
			ClientReminderId
			,Processed
			,ClientId
			,ClientName
			,Phone
			,ReminderTypeName
			,ReminderDate
			,CommunicationType
			)
		SELECT CR.ClientReminderId
			,CASE 
				WHEN (CR.Processed = 'Y')
					THEN 'Yes'
				WHEN (CR.Processed = 'N')
					THEN 'No'
				END AS Processed
			,CR.ClientId
			,C.LastName + ', ' + C.FirstName AS ClientName
			,CR.PhoneNumber
			,CRT.ReminderTypeName AS ReminderTypeName
			,CR.ReminderDate
			,GC.CodeName AS CommunicationType
		FROM ClientReminders CR
		INNER JOIN Clients C ON CR.ClientId = C.ClientId
		--Added by Revathi on 07.JAN.2014 for task #77 Engineering Improvement Initiatives- NBL(I)
		INNER JOIN StaffClients sc ON sc.ClientId = c.ClientId
			AND sc.StaffId = @LoggedInStaffId
		LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = CR.CommunicationType
		LEFT JOIN ClientReminderTypes CRT ON CRT.ClientReminderTypeId = CR.ClientReminderTypeId
		WHERE (
				ISNULL(CR.RecordDeleted, 'N') = 'N'
				AND ISNULL(C.RecordDeleted, 'N') = 'N'
				AND ISNULL(CRT.RecordDeleted, 'N') = 'N'
				AND (
					@ReminderDateFromFilter IS NULL
					OR CR.ReminderDate >= @ReminderDateFromFilter
					)
				AND (
					@ReminderDateToFilter IS NULL
					OR CR.ReminderDate < dateadd(dd, 1, @ReminderDateToFilter)
					)
				AND (
					(CR.ClientReminderTypeId = @ReminderTypeFilter)
					OR (@ReminderTypeFilter = - 1)
					)
				AND (
					(CR.CommunicationType = @ReminderCommTypeFilter)
					OR (@ReminderCommTypeFilter = 0)
					)
				AND (
					(CR.Processed = @ReminderStatusFilter)
					OR @ReminderStatusFilter = '-1'
					)
				)
				
				
;WITH Counts
		AS (SELECT Count(*) AS TotalRows
			FROM #ResultSet)
			,RankResultSet
			AS (SELECT ClientReminderId
						,Processed
						,ClientId
						,ClientName
						,Phone
						,ReminderTypeName
						,ReminderDate
						,CommunicationType
					,Count(*) OVER () AS TotalCount
					,row_number() OVER (ORDER BY CASE WHEN @SortExpression = 'Processed' THEN Processed END
												,CASE WHEN @SortExpression = 'Processed DESC' THEN Processed END DESC
												,CASE WHEN @SortExpression = 'ClientId' THEN ClientId END
												,CASE 
													WHEN @SortExpression = 'ClientId DESC'
														THEN ClientId
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
													WHEN @SortExpression = 'Phone'
														THEN Phone
													END
												,CASE 
													WHEN @SortExpression = 'Phone DESC'
														THEN Phone
													END DESC
												,CASE 
													WHEN @SortExpression = 'ReminderTypeName'
														THEN ReminderTypeName
													END
												,CASE 
													WHEN @SortExpression = 'ReminderTypeName DESC'
														THEN ReminderTypeName
													END DESC
												,CASE 
													WHEN @SortExpression = 'ReminderDate'
														THEN ReminderDate
													END
												,CASE 
													WHEN @SortExpression = 'ReminderDate DESC'
														THEN ReminderDate
													END DESC
												,CASE 
													WHEN @SortExpression = 'CommunicationType'
														THEN CommunicationType
													END
												,CASE 
													WHEN @SortExpression = 'CommunicationType DESC'
														THEN CommunicationType
													END DESC
												,ClientReminderId
																	) AS RowNumber        
							FROM #ResultSet	)
		SELECT TOP (CASE WHEN (@PageNumber = - 1)
						THEN (SELECT ISNULL(TotalRows, 0) FROM Counts)
					ELSE (@PageSize)
					END
			)	ClientReminderId
			,Processed
			,ClientId
			,ClientName
			,Phone
			,ReminderTypeName
			,ReminderDate
			,CommunicationType
			,TotalCount
			,RowNumber
		INTO #FinalResultSet
		FROM RankResultSet
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize)

		IF (SELECT ISNULL(Count(*), 0)	FROM #FinalResultSet) < 1
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
						THEN ISNULL((Totalcount / @PageSize), 0)
					ELSE ISNULL((Totalcount / @PageSize), 0) + 1
					END AS NumberOfPages
				,ISNULL(Totalcount, 0) AS NumberofRows
			FROM #FinalResultSet
		END

			SELECT RS.ClientReminderId AS ClientReminderId
			,RS.Processed
			,RS.ClientId
			,RS.ClientName
			,RS.Phone
			,RS.ReminderTypeName
			,RS.ReminderDate
			,(
				SELECT REPLACE(REPLACE(STUFF((
									SELECT CHAR(10) + CASE 
											WHEN (Processed = 'Y')
												THEN 'Processed Yes on '
											WHEN (Processed = 'N')
												THEN 'Processed No on '
											END + CONVERT(VARCHAR, ProcessedDate, 101) + ' ' + RIGHT('0' + LTRIM(RIGHT(CONVERT(VARCHAR, ProcessedDate, 0), 7)), 7)
									FROM ClientReminderProcessLogs CRPL
									WHERE CRPL.CLientReminderId = RS.ClientReminderId
									ORDER BY CRPL.ProcessedDate DESC
									FOR XML PATH('')
									), 1, 1, ''), '&lt;', '<'), '&gt;', '>')
				) AS ProcessedLog
			,RS.CommunicationType
			,
			------Added by Katta Sharath Kumar on 26.SEP.2014 for task #46-Meaningful Use
			(
				SELECT TOP 1 CONVERT(VARCHAR, CRPL.ProcessedDate, 101) + ' ' + RIGHT('0' + LTRIM(RIGHT(CONVERT(VARCHAR, CRPL.ProcessedDate, 0), 7)), 7)
				FROM ClientReminderProcessLogs CRPL
				WHERE CRPL.CLientReminderId = RS.ClientReminderId
				ORDER BY CRPL.ProcessedDate DESC
				) AS ProcessedDate
		FROM #FinalResultSet RS
		ORDER BY RowNumber	

	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_ListPageClientReminders') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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

