/****** Object:  StoredProcedure [dbo].[ssp_SCDocumentProgressNotesPostUpdate]    Script Date: 10/19/2015 11:33:53 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCDocumentProgressNotesPostUpdate]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCDocumentProgressNotesPostUpdate]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCDocumentProgressNotesPostUpdate]    Script Date: 10/19/2015 11:33:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[ssp_SCDocumentProgressNotesPostUpdate] (
	@ScreenKeyId INT
	,@StaffId INT
	,@CurrentUser VARCHAR(30)
	,@CustomParameters XML
	)
AS 
/****************************************************************************
** Author:		Wasif Butt
** Create date: Nov, 22 2013
** Description:	Create service for the signed progress note
**	
**	Modifications:
**		Date			Author			Description
**	--------------	------------------	------------------------------------
**	6/18/2014		Wasif Butt			Add code to insert into ClientProblemsDiagnosisHistory table
**	03/08/2014		Vkhare			Removing eantry in ClientProblemsDiagnosisHistory based on new problem pop up
--  OCT-07-2014     Akwinass        What: Insert removed from Services table and inserted into ServiceDiagnosis table '@DiagnosisCode1,@DiagnosisNumber1,@DiagnosisCode2,@DiagnosisNumber2,@DiagnosisCode3,@DiagnosisNumber3'
									Why: Task #134 in Engineering Improvement Initiatives- NBL(I).
							

	APR-21-2015		dharvey			Replaced COUNT(ClientProblemId) with COUNT(*) to return Dx results
	2015-04-27  Vaibhav Khare Adding logic for displaying Diagnosis Order	 
	2015-10-19  Shankha B	  Added additional/Correct fields into ServiceDiagnosis table from the ClientProblemsDiagnosisHistory
   14/11/2017  Sunil.D       What: Added script to insert data into ServiceAddOnCodes table 
						     Why:Task:#10,Project:Andrews Center - Customizations Project
	2015-07-11	Chethan N		What : Avoid creating Service when ProcedureCodeId is NULL.
								Why : Engineering Improvement Initiatives- NBL(I) task #654.
   31/01/2019  Chita Ranjan     What: Added If Exists condition to avoid creating duplicate services.
                                Why: ssp_SCDocumentProgressNotesPostUpdate is calling two times by the application as a result duplicate services are creating. Renaissance - Current Project Tasks #138
****************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @DocumentVersionId INT = - 1
			,@effectiveDate DATETIME

		SELECT @DocumentVersionId = InProgressDocumentVersionId
			,@effectiveDate = EffectiveDate
		FROM dbo.Documents AS d
		WHERE DocumentId = @ScreenKeyId

		DECLARE @ClientId INT
			,@DateOfService DATETIME
			,@ClinicianId INT
			,@ProcedureCodeId INT
			,@Units INT
			,@ProgramId INT
			,@LocationId INT
			,@Billable [type_YOrN]
			,@ProcedureRateId INT
			,@Charge MONEY

		SELECT @ClientId = d.ClientId
			,@DateOfService = neco.StartTime
			,@ClinicianId = d.AuthorId
			,@ProcedureCodeId = neco.ProcedureCodeId
			,@Units = DATEDIFF(minute, StartTime, EndTime)
			,@ProgramId = neco.ProgramId
			,@LocationId = neco.LocationId
			,@Billable = CASE 
				WHEN pc.NotBillable = 'N'
					THEN 'Y'
				ELSE 'N'
				END
		FROM documents d
		JOIN dbo.DocumentVersions AS dv ON d.InProgressDocumentVersionId = dv.DocumentVersionId
		JOIN NoteEMCodeOptions AS neco ON dv.DocumentVersionId = neco.DocumentVersionId
		LEFT JOIN dbo.ProcedureCodes AS pc ON neco.ProcedureCodeId = pc.ProcedureCodeId
		WHERE d.DocumentId = @ScreenKeyId
			AND ISNULL(d.RecordDeleted, 'N') = 'N'
			AND ISNULL(dv.RecordDeleted, 'N') = 'N'
			AND ISNULL(neco.RecordDeleted, 'N') = 'N'
			AND ISNULL(pc.RecordDeleted, 'N') = 'N'

	  
		--------SERVICE DiagnosisCode change
		DECLARE @tempClientProblems TABLE (
			ID INT IDENTITY(1, 1) NOT NULL
			,ClientProblemId INT
			,ICD10Code VARCHAR(50)
			,ICD10CodeId INT
			,DSMCode VARCHAR(50)
			,DSMNumber INT
			,ProblemOrder INT			
			,ICD9Code  VARCHAR(50)
			)

		---ENd  SERVICE DiagnosisCode change 
	IF EXISTS(SELECT 1 FROM documents d
		JOIN dbo.DocumentVersions AS dv ON d.InProgressDocumentVersionId = dv.DocumentVersionId
		JOIN NoteEMCodeOptions AS neco ON dv.DocumentVersionId = neco.DocumentVersionId AND neco.ProcedureCodeId IS NOT NULL
		WHERE d.DocumentId = @ScreenKeyId 
				AND ISNULL(d.RecordDeleted, 'N') = 'N'
				AND ISNULL(dv.RecordDeleted, 'N') = 'N'
				AND ISNULL(neco.RecordDeleted, 'N') = 'N')
		BEGIN
			IF ISNULL(@Billable, 'N') = 'Y'
				BEGIN
					EXEC dbo.ssp_PMServiceCalculateCharge @ClientId = @ClientId
						,-- int
						@DateOfService = @DateOfService
						,-- datetime
						@ClinicianId = @ClinicianId
						,-- int
						@ProcedureCodeId = @ProcedureCodeId
						,-- int
						@Units = @Units
						,-- int
						@ProgramId = @ProgramId
						,-- int
						@LocationId = @LocationId
						,-- int
						@ProcedureRateId = @ProcedureRateId OUTPUT
						,-- int
						@Charge = @Charge OUTPUT -- money
				END
			IF EXISTS(Select 1 From  Documents  WHERE DocumentId = @ScreenKeyId AND ServiceId IS NULL)	
		     BEGIN	
			INSERT INTO dbo.Services (
				ClientId
				,ProcedureCodeId
				,DateOfService
				,EndDateOfService
				,Unit
				,UnitType
				,STATUS
				,ClinicianId
				,AttendingId
				,ProgramId
				,LocationId
				,Billable
				,DateTimeIn
				,DateTimeOut
				,NoteAuthorId
				,ModifierId1
				,ModifierId2
				,ModifierId3
				,ModifierId4
				,ClientWasPresent
				,ProcedureRateId
				,Charge
				)
			SELECT d.ClientId
				,neco.ProcedureCodeId
				,neco.StartTime
				,neco.EndTime
				,DATEDIFF(minute, StartTime, EndTime)
				,110 --Minutes
				,71 --Show	75		--Complete
				,d.AuthorId
				,d.AuthorId
				,neco.ProgramId
				,neco.LocationId
				,CASE 
					WHEN pc.NotBillable = 'N'
						THEN 'Y'
					ELSE 'N'
					END
				,neco.StartTime
				,neco.EndTime
				,d.AuthorId
				,ModifierId1
				,ModifierId2
				,ModifierId3
				,ModifierId4
				,'Y'
				,@ProcedureRateId
				,@Charge
			FROM documents d
			JOIN dbo.DocumentVersions AS dv ON d.InProgressDocumentVersionId = dv.DocumentVersionId
			JOIN NoteEMCodeOptions AS neco ON dv.DocumentVersionId = neco.DocumentVersionId
			LEFT JOIN dbo.ProcedureCodes AS pc ON neco.ProcedureCodeId = pc.ProcedureCodeId
			WHERE d.DocumentId = @ScreenKeyId
				AND ISNULL(d.RecordDeleted, 'N') = 'N'
				AND ISNULL(dv.RecordDeleted, 'N') = 'N'
				AND ISNULL(neco.RecordDeleted, 'N') = 'N'
				AND ISNULL(pc.RecordDeleted, 'N') = 'N'

			DECLARE @NewServiceId INT

			SET @NewServiceId = SCOPE_IDENTITY()

			UPDATE documents
			SET ServiceId = @NewServiceId
			WHERE DocumentId = @ScreenKeyId
			
			INSERT INTO @tempClientProblems
			SELECT CP.ClientProblemId
				,CP.ICD10Code
				,CP.ICD10CodeId
				,CP.DSMCode
				,CP.DSMNumber
				,CP.DiagnosisOrder
				,ICD9.ICDCode
			FROM ClientProblemsDiagnosisHistory CP
			LEFT JOIN DiagnosisICDCodes AS ICD9 ON icd9.icdCode = CP.dsmCode
			WHERE CP.DocumentVersionId = @DocumentVersionId
				AND ISNULL(CP.RecordDeleted, 'N') = 'N'
				AND ISNULL(CP.Discontinue, 'N') = 'N'
			ORDER BY CP.DiagnosisOrder

			--  OCT-07-2014  Akwinass
			INSERT INTO [ServiceDiagnosis] (
				ServiceId
				,ICD10Code
				,DSMVCodeId
				,DSMCode
				,DSMNumber
				,ICD9Code
				,[Order]
				)
			SELECT 
				@NewServiceId
				,ICD10Code
				,ICD10CodeId
				,DSMCode
				,DSMNumber
				,ICD9Code
				,ProblemOrder
			FROM @tempClientProblems
			
			
					 ----------------------14/11/2017  Sunil.D  -------------------
			  Insert into ServiceAddOnCodes(
			  ServiceId,
			  AddOnProcedureCodeId,
			  AddOnProcedureCodeStartTime,
			  AddOnProcedureCodeUnit,
			  AddOnProcedureCodeUnitType) 
			  select
			  d.ServiceId,
			  PNAC.AddOnProcedureCodeId,
			  PNAC.AddOnProcedureCodeStartTime,
			  PNAC.AddOnProcedureCodeUnit,
			  s.UnitType
			  FROM documents d  
			  JOIN dbo.DocumentVersions AS dv ON d.InProgressDocumentVersionId = dv.DocumentVersionId  
			  JOIN ProgressNoteAddOnCodes AS PNAC ON dv.DocumentVersionId = PNAC.DocumentVersionId  
			  JOIN services AS s ON s.ServiceId = d.ServiceId  
			  WHERE d.DocumentId = @ScreenKeyId  
			   AND ISNULL(d.RecordDeleted, 'N') = 'N'  
			   AND ISNULL(dv.RecordDeleted, 'N') = 'N'  
			   AND ISNULL(PNAC.RecordDeleted, 'N') = 'N'  
			   AND ISNULL(s.RecordDeleted, 'N') = 'N' 
		END
   END
   
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCDocumentProgressNotesPostUpdate') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


