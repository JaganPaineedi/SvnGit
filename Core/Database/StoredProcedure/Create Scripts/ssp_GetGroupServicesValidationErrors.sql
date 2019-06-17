/****** Object:  StoredProcedure [dbo].[ssp_GetGroupServicesValidationErrors]    Script Date: 07/10/2015 11:32:31 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetGroupServicesValidationErrors]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
    DROP PROCEDURE [dbo].[ssp_GetGroupServicesValidationErrors]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetGroupServicesValidationErrors] @GroupServiceid INT
	,@StaffId INT
AS 
/******************************************************************************                                                              
**  File: ssp_GetGroupServicesValidationErrors                                                          
**  Name: ssp_GetGroupServicesValidationErrors                                      
**  Desc: For Validation  for GroupServices documents                                
**  Return values: Resultset having validation messages                                                              
**  Called by:                                                               
**  Parameters:                                          
**  Auth:  Umesh                                              
**  Date:  Jun 17 2010                                                          
*******************************************************************************                                                              
**  Change History                                                              
*******************************************************************************                                                              
**  Date:       Author:       Description:
** 3/13/2013    Maninder      Commented D.GroupServiceId = @GroupServiceid because now D.GroupServiceId will be null for ClientNotes for Task#2724 in Thresholds Bugs/Feature
** 3/13/2013    Maninder      Changed sp name from csp_GetGroupServicesValidationErrors to ssp_GetGroupServicesValidationErrors
** 7/10/2015	NJain		  Chagned @validationReturnTable to #validationReturnTable
** 10/15/2015	Revathi		  what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  
							  why:task #609, Network180 Customization 
** 03/16/2016	Chethan N	  What : Added columns 'TabOrder' and 'ValidationOrder' to table #validationReturnTable -- Due to SCSP call which contains temp table with same name.
							  Why : WMU - Support Go Live task# 229
** 08/10/2018	JStedman		What: Added group note signing validations to require clients be enrolled in service program and service
								procedure be associated with the program
								Why: Journey Enh 64
*******************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @DocumentsWithNoError TABLE (
			DocumentId INT
			,ClientId INT
			,ClientName VARCHAR(100)
			)

		CREATE TABLE #validationGroupServices (
			RowId INT IDENTITY(1, 1)
			,TableName VARCHAR(200)
			,ColumnName VARCHAR(200)
			,ErrorMessage VARCHAR(200)
			,PageIndex INT
			,ServiceId INT
			,DocumentId INT
			)

		DECLARE @MyTableVar TABLE (
			RowId INT IDENTITY(1, 1)
			,DocumentId INT
			,DocumentVersionId INT
			,DocumentCodeId INT
			,ServiceId INT
			,ClientId INT
			,ClientName VARCHAR(100)
			,
			--ProcedureCodeId INT,                            
			ValidationProcedureName VARCHAR(200)
			);

		INSERT INTO @MyTableVar
		SELECT D.DocumentId
			,D.CurrentDocumentVersionId
			,SCR.DocumentCodeId
			,S.ServiceId
			,S.ClientId
			,
			--Added by Revathi  10/15/2015
			CASE 
				WHEN ISNULL(C.ClientType, 'I') = 'I'
					THEN (ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, ''))
				ELSE ISNULL(C.OrganizationName, '')
				END AS ClientName
			,SCR.ValidationStoredProcedureComplete
		FROM Services S
		INNER JOIN Documents D ON S.ServiceId = D.ServiceId
		INNER JOIN Screens SCR ON D.DocumentCodeId = SCR.DocumentCodeId
		INNER JOIN Clients C ON S.ClientId = C.ClientId
		WHERE --D.GroupServiceId = @GroupServiceid                 
			--AND 
			S.GroupServiceId = @GroupServiceid
			AND ISNULL(S.RecordDeleted, 'N') = 'N'
			AND ISNULL(SCR.RecordDeleted, 'N') = 'N'
			AND ISNULL(D.RecordDeleted, 'N') = 'N'
			AND D.AuthorId = @StaffId
			AND D.STATUS <> 22
			AND S.STATUS = 71

		CREATE TABLE #validationReturnTable (
			TableName VARCHAR(200)
			,ColumnName VARCHAR(200)
			,ErrorMessage VARCHAR(1000)
			,
			--PageIndex       int ,                            
			--ClientId int        
			ServiceId INT
			-- Added by Chethan N 03/16/2016
			 ,TabOrder INT  
			 ,ValidationOrder INT 
			)

		--DocumentId INT NULL                            
		DECLARE @Counter INT
		DECLARE @MaxCount INT
		DECLARE @ValidationProcedureName VARCHAR(200)

		SET @Counter = 1

		SELECT @MaxCount = MAX(RowId)
		FROM @MyTableVar

		IF (@MaxCount <> 0)
		BEGIN
			DECLARE @DocumentVersionId INT
			DECLARE @ClientId INT
			DECLARE @ClientName VARCHAR(100)
			DECLARE @DocumentId INT
			DECLARE @ServiceId INT
			DECLARE @CustomTableRecordCount INT
			DECLARE @DocumentCodeId INT
			DECLARE @FirstCustomTableName VARCHAR(100)

			WHILE (@Counter <= @MaxCount)
			BEGIN
				SELECT @DocumentVersionId = DocumentVersionId
					,@ServiceId = ServiceId
					,@ClientId = ClientId
					,@DocumentCodeId = DocumentCodeId
					,@ClientName = ClientName
					,@DocumentId = DocumentId
					,@ValidationProcedureName = ValidationProcedureName
				FROM @MyTableVar
				WHERE RowId = @Counter

				IF @Counter = 1
				BEGIN
					--Get The first Custom table according to documentCodeId      
					EXEC ssp_SCGetFirstCustomTableName @DocumentCodeId
						,@FirstCustomTableName OUTPUT
				END

				--Execute the Stored Procedure that calculate the count of Records in Custom Table      
				EXEC ssp_SCGetCustomTableCount @DocumentVersionId
					,@FirstCustomTableName
					,@CustomTableRecordCount OUTPUT

				IF @CustomTableRecordCount < 1
				BEGIN
					--If the record count of custom table =0 , Do not sign Document and continue with others      
					SET @Counter = @Counter + 1

					CONTINUE
				END

				DELETE
				FROM #validationReturnTable

				--Start Journey Enh 64
				DECLARE @CurrDate date = GETDATE();

				DECLARE @ServicesWithMissingPrograms TABLE( ServiceId int, ProgramId int, ClientId int );

				INSERT INTO @ServicesWithMissingPrograms
				SELECT
					s.ServiceId
					, s.ProgramId
					, s.ClientId
				FROM
					dbo.[Services] AS s
				WHERE
					s.ServiceId = @ServiceId
						AND NOT EXISTS (
							SELECT	*
							FROM	dbo.ClientPrograms AS cprg
									JOIN dbo.Programs AS prg ON prg.ProgramId = cprg.ProgramId
							WHERE	( cprg.RecordDeleted IS NULL OR cprg.RecordDeleted = 'N' )
									AND CAST(s.DateOfService AS date) BETWEEN cprg.EnrolledDate AND ISNULL(cprg.DischargedDate, @CurrDate)
									AND cprg.ClientId = s.ClientId
									AND cprg.ProgramId = s.ProgramId
						)
				;

				INSERT INTO #validationReturnTable
				(
					TableName
					, ColumnName
					, ErrorMessage
				)
				SELECT
					'Services'
					, 'ProgramId'
					, 'Client is not enrolled in Program; please enroll this client in the program, or choose a different program selection in the dropdown'
				FROM
					@ServicesWithMissingPrograms AS s
						INNER JOIN dbo.Clients AS c ON c.ClientId = s.ClientId
						INNER JOIN dbo.Programs AS prg ON prg.ProgramId = s.ProgramId
				UNION
				SELECT
					'Services'
					, 'ProcedureId'
					, 'Selected procedure is not associated with Program; please associate this procedure with the program, or choose a different procedure selection in the dropdown'
				FROM
					dbo.[Services] AS s
						INNER JOIN dbo.Programs AS prg ON prg.ProgramId = s.ProgramId
						INNER JOIN dbo.ProcedureCodes AS p ON p.ProcedureCodeId =  s.ProcedureCodeId
				WHERE
					s.ServiceId = @ServiceId
						AND NOT EXISTS (
							SELECT	*
							FROM	dbo.ProgramProcedures AS pp
							WHERE	( pp.RecordDeleted IS NULL OR pp.RecordDeleted = 'N' )
								AND CAST(s.DateOfService AS date) BETWEEN ISNULL(pp.StartDate, '01/01/1900') AND ISNULL(pp.EndDate, @CurrDate)
									AND pp.ProcedureCodeId = s.ProcedureCodeId
									AND pp.ProgramId = s.ProgramId
						)
						AND NOT EXISTS (
							SELECT
								*
							FROM
								@ServicesWithMissingPrograms AS tmp
							WHERE
								tmp.ServiceId = s.ServiceId
						)
				;

				DELETE FROM @ServicesWithMissingPrograms;
				--Stop Journey Enh 64

				IF @ValidationProcedureName IS NOT NULL
					AND RTRIM(LTRIM(@ValidationProcedureName)) <> ''
				BEGIN
					INSERT INTO #validationReturnTable (TableName,ColumnName,ErrorMessage,ServiceId) -- Added by Chethan N 03/16/2016
					--EXEC @ValidationProcedureName @DocumentVersionId ,@StaffId                       
					--Call the Validation Stored Procedure                            
					EXEC scsp_SCValidateDocument @StaffId
						,@DocumentId
						,@ValidationProcedureName
				END

				UPDATE #validationReturnTable
				SET ServiceId = @ServiceId

				SET @Counter = @Counter + 1

				IF (
						(
							SELECT COUNT(TableName)
							FROM #validationReturnTable
							) = 0
						)
				BEGIN
					INSERT INTO @DocumentsWithNoError (
						DocumentId
						,ClientId
						,ClientName
						)
					VALUES (
						@DocumentId
						,@ClientId
						,@ClientName
						)
				END

				INSERT INTO #validationGroupServices (
					TableName
					,ColumnName
					,ErrorMessage
					,
					--PageIndex ,                            
					ServiceId
					)
				SELECT DISTINCT TableName
					,ColumnName
					,ErrorMessage
					,
					--PageIndex    ,                            
					ServiceId
				FROM #validationReturnTable
			END
		END

		SELECT DISTINCT RowId
			,TableName
			,ColumnName
			,ErrorMessage
			,PageIndex
			,S.ClientId
			,#validationGroupServices.ServiceId
			,CASE 
				WHEN ISNULL(C.ClientType, 'I') = 'I'
					THEN (C.LastName + ' ' + C.FirstName)
				ELSE C.OrganizationName
				END AS ClientName
			,DocumentId
		FROM #validationGroupServices
		LEFT JOIN Services S ON #validationGroupServices.ServiceId = S.ServiceId
		LEFT JOIN Clients C ON S.ClientId = C.ClientId

		--WHERE ISNULL(C.RecordDeleted,'N')='N'  AND  ISNULL(S.RecordDeleted,'N')='N'                      
		SELECT DocumentId 
			,ClientId 
			,ClientName
		FROM @DocumentsWithNoError
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER())
		 + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE())
		  + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE())
		  , 'ssp_GetGroupServicesValidationErrors') + '*****' 
		  + CONVERT(VARCHAR, ERROR_LINE()) + '*****' 
		  + CONVERT(VARCHAR, ERROR_SEVERITY())
		   + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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

