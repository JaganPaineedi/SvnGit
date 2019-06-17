IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetDropdownDeletedItem]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetDropdownDeletedItem]
GO

CREATE PROCEDURE [dbo].[ssp_GetDropdownDeletedItem] @ParamsList VARCHAR(max)
	,@KeyValue VARCHAR(20)
AS
BEGIN
	/*********************************************************************/
	/* Stored Procedure: dbo.ssp_GetDropdownDeletedItem					 */
	/* Copyright: 2011 Streamline Healht Care Solutions					 */
	/* Creation Date:  12/14/2012										 */
	/*                                                                   */
	/* Purpose:  Get Deleted or Active Items from for Drodown List Ref task 825 in Threshold 3.5xMerge Issues */
	/*                                                                   */
	/* Output Parameters:												 */
	/*                                                                   */
	/* Called By:                                                        */
	/*                                                                   */
	/* Calls:                                                            */
	/*                                                                   */
	/* Data Modifications:                                               */
	/*                                                                   */
	/* Updates:                                                          */
	/*  Date          Author            Purpose                          */
	/* 12/14/2012     Rakesh            Created                          */
	/* 12/31/2012     Maninder          Selected ProgramName instead of ProgramCode from Programs : for Task#2498 in Thresholds Bugs/Feature   */
	/* 03/29/2013     Rakesh Garg       Add condition for Staff table for getting dropdown data  w.r f to task  #68  Interact Customizations Issues Tracking  */
	/* 11/07/2013     Wasif Butt	    Chage to parameter list, extracting parameters into variables and architectural update for DFA dropdowns. */
	/* 02/07/2014     Venkatesh MR	    Changed as per the task 66 in care management to smartcare. got the error "Conversion failed when converting the varchar value 'AL' to data type int.*****ssp_GetDropdownDeletedItem"*/
	/* 03/17/2015     Shankha B			SWMBH SUPPORT #904, Added condition for Providers */
	
	/*********************************************************************/
	BEGIN TRY
		DECLARE @splitOn CHAR(1) = ','
			,@spName VARCHAR(100)
			,@tableName VARCHAR(100)
			,@keyColumn VARCHAR(100)
			,@textColumn VARCHAR(100)
			,@displayAs VARCHAR(100)
			,@LoggedInStaffId VARCHAR(100)

		SELECT [index]
			,item
		INTO #items
		FROM dbo.fnSplitWithIndex(@ParamsList, @splitOn)

		SELECT @spName = [0]
			,@tableName = [1]
			,@keyColumn = [2]
			,@textColumn = [3]
			,@displayAs = [4]
			,@LoggedInStaffId = [5]
		FROM (
			SELECT [index]
				,item
			FROM #items
			) AS SourceTable
		PIVOT(max(item) FOR [index] IN (
					[0]
					,[1]
					,[2]
					,[3]
					,[4]
					,[5]
					)) AS PivotTable;

		DROP TABLE #items

		IF isnull(@spName, '') != ''
		BEGIN
			IF EXISTS (
					SELECT *
					FROM sys.objects
					WHERE object_id = OBJECT_ID(@spName)
						AND type IN (
							N'P'
							,N'PC'
							)
					)
			BEGIN
				EXEC @spName @ParamsList
					,@KeyValue
			END
		END
		ELSE
		BEGIN
			IF (@TableName = 'PROCEDURECODES')
				SELECT ProcedureCodeID
					,ProcedureCodeName
				FROM ProcedureCodes
				WHERE ProcedureCodeID = @KeyValue
			ELSE IF (@TableName = 'PROGRAMS')
				SELECT ProgramId
					,ProgramName
				FROM PROGRAMS
				WHERE ProgramId = @KeyValue
			ELSE IF (@TableName = 'GLOBALCODES')
				SELECT [GlobalCodeId]
					,[CreatedBy]
					,[CreatedDate]
					,[ModifiedBy]
					,[ModifiedDate]
					,[Category]
					,[CodeName]
					,[Code]
					,[Description]
					,[Active]
					,[CannotModifyNameOrDelete]
					,[SortOrder]
					,[ExternalCode1]
					,[ExternalSource1]
					,[ExternalCode2]
					,[ExternalSource2]
					,[Bitmap]
					,[BitmapImage]
					,[Color]
				FROM [dbo].[GlobalCodes]
				WHERE GlobalCodeID = @KeyValue
			ELSE IF (@TableName = 'GLOBALSUBCODES')
				SELECT [GlobalSubCodeId]
					,[GlobalCodeId]
					,[SubCodeName]
					,[Code]
					,[Description]
					,[Active]
					,[CannotModifyNameOrDelete]
					,[SortOrder]
					,[ExternalCode1]
					,[ExternalSource1]
					,[ExternalCode2]
					,[ExternalSource2]
					,[Bitmap]
					,[BitmapImage]
					,[Color]
					,[RowIdentifier]
					,[CreatedBy]
					,[CreatedDate]
					,[ModifiedBy]
					,[ModifiedDate]
				FROM [dbo].[GlobalSubCodes]
				WHERE GlobalSubCodeId = @KeyValue
					-- Below Else If condition added by Rakesh w.r f to task  #68  Interact Customizations Issues Tracking
			ELSE IF (@TableName = 'STAFF')
			BEGIN
				IF (@keyColumn = 'AttendingId')
					SELECT Convert(VARCHAR(100), LastName + ', ' + FirstName) AS AttendingName
						,StaffId AS AttendingId
					FROM Staff
					WHERE StaffId = @KeyValue
				ELSE IF (@keyColumn = 'ClinicianId')
					SELECT Convert(VARCHAR(100), LastName + ', ' + FirstName) AS ClinicianName
						,StaffId AS ClinicianId
					FROM Staff
					WHERE StaffId = @KeyValue
			END
			ELSE IF (@TableName = 'STAFFPROCEDURES')
			BEGIN
				SELECT Staffid
					,pc.ProcedureCodeID
					,ProcedureCodeName AS Procedurecode
					,'Y' AS Active
				FROM dbo.StaffProcedures AS sp
				JOIN dbo.ProcedureCodes AS pc ON sp.ProcedureCodeId = pc.ProcedureCodeId
				WHERE pc.ProcedureCodeId = @keyValue
					AND StaffId = @LoggedInStaffId
			END
					-- Changes End here
			ELSE IF (@TableName = 'PROVIDERS')
			BEGIN
				SELECT DISTINCT Providers.ProviderID
					,CASE dbo.providers.ProviderType
						WHEN 'I'
							THEN dbo.providers.ProviderName + ', ' + dbo.providers.FirstName
						WHEN 'F'
							THEN dbo.providers.ProviderName
						END AS ProviderName
				FROM Providers
				WHERE ProviderID = @keyValue
			END
			ELSE
			BEGIN
				DECLARE @SQL AS VARCHAR(200)

				IF EXISTS (
						SELECT 1
						FROM sys.columns c
						INNER JOIN sys.objects o ON c.object_id = o.object_id
						WHERE o.NAME LIKE @TableName
							AND c.NAME LIKE isnull(@displayAs, @textColumn)
						)
				BEGIN
					SET @SQL = 'Select * from ' + @TableName + ' where ' + @keyColumn + '=' + '''' + @KeyValue + '''' --Modified by Venkatesh

					EXEC (@SQL)
				END
				ELSE
				BEGIN
					SET @SQL = 'Select *,' + @textColumn + ' as ' + isnull(@displayAs, @textColumn) + ' from ' + @TableName + ' where ' + @keyColumn + '=' + '''' + @KeyValue + '''' --Modified by Venkatesh

					EXEC (@SQL)
				END
			END
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetDropdownDeletedItem') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                                    
				16
				,-- Severity.                                                                                                    
				1 -- State.                                                                                                    
				);
	END CATCH
END
