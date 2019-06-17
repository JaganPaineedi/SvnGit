IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCCreateAttendanceAssignmentRecurring]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCCreateAttendanceAssignmentRecurring]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCCreateAttendanceAssignmentRecurring] 
	@UserCode VARCHAR(30)
	,@FromDate DATETIME
	,@ToDate DATETIME
	,@Monday CHAR(1)
	,@Tuesday CHAR(1)
	,@Wednesday CHAR(1)
	,@Thursday CHAR(1)
	,@Friday CHAR(1)
	,@Saturday CHAR(1)
	,@Sunday CHAR(1)
	,@AssignmentDate DATETIME
	,@GroupServiceIds VARCHAR(MAX)
AS
/****************************************************************************/
/* Stored Procedure: ssp_SCCreateAttendanceAssignmentRecurring              */
/* Copyright: 2006 Streamline Healthcare Solutions                           */
/* Author: Revathi                                                         */
/* Creation Date:  June 09,2015                                            */
/* Purpose: To Create Recurring Attendance Group Services                  */
/* Input Parameters:@UserCode,@FromDate,@ToDate,@Monday,@Tuesday,@Wednesday,
@Thursday,@Friday,@Saturday,@Sunday,@AssignmentDate,@GroupServiceIds        */
/* Output Parameters:None                                                   */
/* Return:                                                                  */
/* Calls:                                                                   */
/* Called From:                                                             */
/* Data Modifications:                                                      */
/*                                                                          */
/*-------------Modification History--------------------------               */
/*-------Date-----------Author------------Purpose---------------------------*/
/*       09-June-2015  Revathi          Created(Task #829 in Woods - Customizations).*/
/*       23-June-2015  Akwinass         Removed the GroupClients Insert(Task #829.01 in Woods - Environment Issues Tracking).*/
/*       05-Aug-2015   Akwinass         Included DocumentSignatures Insert(Task #513 in Valley Client Acceptance Testing Issues).*/
/*       15-Aug-2015   Akwinass         Included AssociatedNoteId Insert On Documents Table(Task #264 in Valley Client Acceptance Testing Issues).*/
/*       17-Aug-2015   Akwinass         Modified Units Logic(Task #264 in Valley Client Acceptance Testing Issues).*/
/*       01-Sep-2015   Akwinass         Removed min and max Logic (Task #373 in Valley Client Acceptance Testing Issues).*/
/*       22-Feb-2016   Akwinass	        What:Included Condition to Avoid Inserting into ServiceDiagnosis when the Order is NULL.          
							            Why:task #167 Valley - Support Go Live*/
/*       13-APRIL-2016 Akwinass	        What:Included GroupNoteType Column.          
							            Why:task #167.1 Valley - Support Go Live*/
/*       28-JUNE-2016  Dhanil	         What:changed Groups.AttendanceDefaultProcedureCodeId to  Groups .ProcedureCodeId to schedule the services through attendance         
							             Why:task #119 Woods - Support Go Live*/	
/*       27-JULY-2016  Pabitra           What:Added  modifiers paarameter to ssf_PMServiceCalculateCharge function
                                         Why: Task#50 Camino Support Go live */							             
/*		07-Jan-2018		Deej			What: Commented the Document Status check while inserting in to DocumentSignatures
										Why: Boundless - Support #57 */								             						          
/****************************************************************************/
BEGIN
	BEGIN TRY	
		IF OBJECT_ID('tempdb..#AttendanceGroupServices') IS NOT NULL
			DROP TABLE #AttendanceGroupServices
		IF OBJECT_ID('tempdb..#AttendanceGroup') IS NOT NULL
			DROP TABLE #AttendanceGroup
		IF OBJECT_ID('tempdb..#Notes') IS NOT NULL
			DROP TABLE #Notes
		IF OBJECT_ID('tempdb..#ClientSplitTable') IS NOT NULL
			DROP TABLE #ClientSplitTable
		IF OBJECT_ID('tempdb..#TempGroupServiceId') IS NOT NULL
			DROP TABLE #TempGroupServiceId
		IF OBJECT_ID('tempdb..#Document') IS NOT NULL
			DROP TABLE #Document
		IF OBJECT_ID('tempdb..#DocumentVersion') IS NOT NULL
			DROP TABLE #DocumentVersion
		IF OBJECT_ID('tempdb..#GroupClients') IS NOT NULL
			DROP TABLE #GroupClients

		CREATE TABLE #AttendanceGroupServices (
			ServiceId INT
			,GroupId INT
			,ClientId INT
			,ProgramId INT
			,StaffId INT
			,AssignmentDate DATETIME
			,StartDateTime DATETIME
			,EndDateTime DATETIME
			,GroupServiceId INT
			)

		INSERT INTO #AttendanceGroupServices (
			ServiceId
			,GroupId
			,ClientId
			,ProgramId
			,StaffId
			,AssignmentDate
			,StartDateTime
			,EndDateTime
			,GroupServiceId
			)
		SELECT NULL
			,(
				SELECT TOP 1 GS.GroupId
				FROM GroupServices GS
				WHERE GS.GroupServiceId = R.GroupServiceId
				)
			,S.ClientId
			,S.ProgramId
			,S.ClinicianId
			,cast(R.RecurringDate AS VARCHAR)
			,cast(R.RecurringDate AS VARCHAR) + ' ' + LTRIM(RIGHT(CONVERT(VARCHAR(20), convert(DATETIME, S.DateOfService), 100), 7))
			,cast(R.RecurringDate AS VARCHAR) + ' ' + LTRIM(RIGHT(CONVERT(VARCHAR(20), convert(DATETIME, S.EndDateOfService), 100), 7))
			,NULL
		FROM Services S		
		INNER JOIN (
			SELECT GroupServiceId
				,AssignmentDate
				,RecurringDate
				,weekdays
			FROM [dbo].[ssf_GetAllDatesforAttendanceAssignmentRecurring](@UserCode, @FromDate, @ToDate, @Monday, @Tuesday, @Wednesday, @Thursday, @Friday, @Saturday, @Sunday, @AssignmentDate, @GroupServiceIds)
			) AS R ON R.GroupServiceId = S.GroupServiceId
		WHERE ISNULL(S.RecordDeleted, 'N') = 'N'
			AND S.[Status] = 70
		ORDER BY R.RecurringDate
			,S.GroupServiceId
			,S.ServiceId ASC

		
		IF EXISTS (	SELECT * FROM #AttendanceGroupServices)
		BEGIN
			
			CREATE TABLE #AttendanceGroup (
				GroupId INT
				,billable CHAR(1)
				,DateOfService DATETIME
				,EndDateOfService DATETIME
				)

			INSERT INTO #AttendanceGroup (
				GroupId
				,DateOfService
				,EndDateOfService
				)
			SELECT GroupId
				,StartDateTime
				,EndDateTime
			FROM (
				SELECT ROW_NUMBER() OVER (
						PARTITION BY GroupId
						,cast(AssignmentDate AS DATE) ORDER BY StartDateTime
						) AS Row
					,GroupId
					,StartDateTime
					,EndDateTime
				FROM #AttendanceGroupServices
				) AS GetGroup
			WHERE Row = 1

		
			CREATE TABLE #Notes (
				NoteId INT identity(1,1) NOT NULL
				,ClientId INT NULL
				,ClientNoteId INT NULL
				,GlobalCodeId INT NULL
				,NoteType INT NULL
				,Bitmap VARCHAR(200) NULL
				,NoteNumber INT NULL
				,Note VARCHAR(100) NULL
				,CodeName VARCHAR(250) NULL
				)

			CREATE TABLE #ClientSplitTable (
				ClientId INT
				,GroupId INT
				)

			INSERT INTO #ClientSplitTable (
				ClientId
				,GroupId
				)
			SELECT DISTINCT ClientId
				,GroupId
			FROM #AttendanceGroupServices

			
		

			CREATE TABLE #TempGroupServiceId (
				GroupServiceId INT
				,GroupId INT
				,DateOfService DATETIME
				)

			UPDATE AG
			SET AG.billable = CASE 
					WHEN P.NotBillable = 'Y'
						THEN 'N'
					ELSE 'Y'
					END
			FROM Groups G
			--28-JUNE-2016  Dhanil
			INNER JOIN ProcedureCodes P ON G.ProcedureCodeId = P.ProcedureCodeId
			INNER JOIN #AttendanceGroup AG ON G.GroupId = AG.GroupId
				AND isnull(P.RecordDeleted, 'N') = 'N'
				AND isnull(G.RecordDeleted, 'N') = 'N'

			UPDATE AG
			SET AG.billable = CASE 
					WHEN P.NotBillable = 'Y'
						THEN 'N'
					ELSE 'Y'
					END
			FROM Groups G
			--28-JUNE-2016  Dhanil
			INNER JOIN ProcedureCodes P ON G.ProcedureCodeId = P.ProcedureCodeId
				AND G.ProcedureCodeId IS NULL
			INNER JOIN #AttendanceGroup AG ON G.GroupId = AG.GroupId
				AND isnull(P.RecordDeleted, 'N') = 'N'
				AND isnull(G.RecordDeleted, 'N') = 'N'

			MERGE INTO GroupServices S
			USING (
				SELECT @UserCode AS CreatedBy
					,GETDATE() AS CreatedDate
					,@UserCode AS ModifiedBy
					,GETDATE() AS ModifiedDate
					,G.GroupId
					,CASE 
						WHEN G.ProcedureCodeId IS NOT NULL
							THEN G.ProcedureCodeId
						ELSE G.ProcedureCodeId
						END ProcedureCodeId
					,AG.DateOfService
					,AG.EndDateOfService
					,[dbo].[ssf_SCCalculateAttendanceUnits](AG.DateOfService, AG.EndDateOfService, G.Unit, G.UnitType) AS Unit
					,G.UnitType
					,G.ClinicianId
					,G.ProgramId
					,G.LocationId
					,G.Comment
					,AG.Billable
					,70 AS [Status]
					,G.PlaceOfServiceId
				FROM Groups G
				INNER JOIN #AttendanceGroup AG ON AG.GroupId = G.GroupId
				) AS GA
				ON 1 = 0
			WHEN NOT MATCHED
				THEN
					INSERT (
						CreatedBy
						,CreatedDate
						,ModifiedBy
						,ModifiedDate
						,GroupId
						,ProcedureCodeId
						,DateOfService
						,EndDateOfService
						,Unit
						,UnitType
						,ClinicianId
						,ProgramId
						,LocationId
						,Comment
						,Billable
						,[Status]
						,PlaceOfServiceId
						)
					VALUES (
						GA.CreatedBy
						,GA.CreatedDate
						,GA.ModifiedBy
						,GA.ModifiedDate
						,GA.GroupId
						,GA.ProcedureCodeId
						,GA.EndDateOfService
						,GA.EndDateOfService
						,GA.Unit
						,GA.UnitType
						,GA.ClinicianId
						,GA.ProgramId
						,GA.LocationId
						,GA.Comment
						,GA.Billable
						,GA.[Status]
						,GA.PlaceOfServiceId
						)
			OUTPUT inserted.GroupServiceId
				,GA.GroupId
				,GA.DateOfService
			INTO #TempGroupServiceId(GroupServiceId, GroupId, DateOfService);
			
			CREATE TABLE #GroupClients (GroupId INT,ClientId INT)

			INSERT INTO #GroupClients (
				GroupId
				,ClientId
				)
			SELECT DISTINCT AGS.GroupId
				,AGS.ClientId				
			FROM #AttendanceGroupServices AGS			

			INSERT INTO #Notes (
				ClientId
				,ClientNoteId
				,GlobalCodeId
				,NoteType
				,Bitmap
				,Note
				,CodeName
				)
			SELECT DISTINCT cn.ClientId
				,cn.ClientNoteId
				,gc.GlobalCodeId
				,cn.NoteType
				,gc.Bitmap
				,cn.Note
				,gc.CodeName
			FROM #AttendanceGroupServices gcl
			INNER JOIN #ClientSplitTable cst ON gcl.ClientId = cst.ClientId
				AND gcl.GroupId = cst.GroupId
			INNER JOIN ClientNotes cn ON gcl.clientid = cn.clientid
			LEFT JOIN GlobalCodes gc ON gc.GlobalCodeId = cn.NoteType
			WHERE isnull(cn.RecordDeleted, 'N') = 'N'
				AND cn.Active = 'Y'
				AND (
					datediff(dd, cn.EndDate, getdate()) <= 0
					OR cn.EndDate IS NULL
					)
				AND gc.Category = 'ClientNoteType'
			ORDER BY cn.clientid
				,cn.ClientNoteId DESC

			UPDATE n
			SET NoteNumber = n.NoteId - fn.FirstNoteId + 1
			FROM #Notes n
			INNER JOIN (
				SELECT ClientId
					,min(NoteId) AS FirstNoteId
				FROM #Notes
				GROUP BY ClientId
				) fn ON fn.ClientId = n.ClientId

			INSERT INTO Services (
				ClientId
				,GroupServiceId
				,ProcedureCodeId
				,DateOfService
				,EndDateOfService
				,Unit
				,UnitType
				,[Status]
				,ClinicianId
				,ProgramId
				,LocationId
				,Billable
				,CreatedBy
				,CreatedDate
				,ModifiedBy
				,ModifiedDate
				,PlaceOfServiceId
				,ProcedureRateId
				,Charge
				)
			SELECT DISTINCT GC.ClientId
				,TG.GroupServiceId
				,CASE 
					WHEN G.ProcedureCodeId IS NOT NULL
						THEN G.ProcedureCodeId
					ELSE G.ProcedureCodeId
					END ProcedureCodeId
				,AGS.StartDateTime
				,AGS.EndDateTime
				,[dbo].[ssf_SCCalculateAttendanceUnits](AGS.StartDateTime, AGS.EndDateTime, G.Unit, G.UnitType) AS Unit
				,G.UnitType
				,70 AS [Status]
				,AGS.StaffId
				,AGS.ProgramId
				,G.LocationId
				,AG.Billable
				,@UserCode
				,GETDATE()
				,@UserCode
				,GETDATE()
				,g.PlaceOfServiceId
				--Pabitra 07/27/2016
				,(SELECT TOP 1 ProcedureRateId FROM [dbo].ssf_PMServiceCalculateCharge(GC.ClientId, AGS.StartDateTime, AGS.StaffId, CASE WHEN G.ProcedureCodeId IS NOT NULL THEN G.ProcedureCodeId ELSE G.ProcedureCodeId END, [dbo].[ssf_SCCalculateAttendanceUnits](AGS.StartDateTime, AGS.EndDateTime, G.Unit, G.UnitType), AGS.ProgramId, G.LocationId,NULL,NULL,NULL,NULL))
				,(SELECT TOP 1 Charge FROM [dbo].ssf_PMServiceCalculateCharge(GC.ClientId, AGS.StartDateTime, AGS.StaffId, CASE WHEN G.ProcedureCodeId IS NOT NULL THEN G.ProcedureCodeId ELSE G.ProcedureCodeId END, [dbo].[ssf_SCCalculateAttendanceUnits](AGS.StartDateTime, AGS.EndDateTime, G.Unit, G.UnitType), AGS.ProgramId, G.LocationId,NULL,NULL,NULL,NULL))
			FROM #GroupClients GC
			INNER JOIN #AttendanceGroupServices AGS ON GC.ClientId = AGS.ClientId
				AND AGS.ServiceId IS NULL
				AND AGS.GroupId = GC.Groupid
			INNER JOIN #TempGroupServiceId TG ON TG.GroupId = AGS.GroupId
				AND CAST(AGS.AssignmentDate AS DATE) = CAST(TG.DateOfService AS DATE)
			INNER JOIN Groups G ON G.GroupId = GC.Groupid
			INNER JOIN #AttendanceGroup AG ON AG.GroupId = AGS.GroupId
				AND AG.DateOfService = TG.DateOfService
				--28-JUNE-2016  Dhanil
			LEFT JOIN ProcedureCodes PC ON G.ProcedureCodeId = PC.ProcedureCodeId
			LEFT JOIN Clients ON GC.ClientId = Clients.ClientId
			LEFT JOIN (
				SELECT ClientId
					,max(NoteNumber) AS BitmapNo
					,max(CASE NoteNumber
							WHEN 1
								THEN GlobalCodeId
							ELSE NULL
							END) AS BitmapId1
					,max(CASE NoteNumber
							WHEN 1
								THEN CodeName + ' : ' + Note
							ELSE NULL
							END) AS Note1
					,max(CASE NoteNumber
							WHEN 2
								THEN GlobalCodeId
							ELSE NULL
							END) AS BitmapId2
					,max(CASE NoteNumber
							WHEN 2
								THEN CodeName + ' : ' + Note
							ELSE NULL
							END) AS Note2
					,max(CASE NoteNumber
							WHEN 3
								THEN GlobalCodeId
							ELSE NULL
							END) AS BitmapId3
					,max(CASE NoteNumber
							WHEN 3
								THEN CodeName + ' : ' + Note
							ELSE NULL
							END) AS Note3
					,max(CASE NoteNumber
							WHEN 4
								THEN GlobalCodeId
							ELSE NULL
							END) AS BitmapId4
					,max(CASE NoteNumber
							WHEN 4
								THEN CodeName + ' : ' + Note
							ELSE NULL
							END) AS Note4
					,max(CASE NoteNumber
							WHEN 5
								THEN GlobalCodeId
							ELSE NULL
							END) AS BitmapId5
					,max(CASE NoteNumber
							WHEN 5
								THEN CodeName + ' : ' + Note
							ELSE NULL
							END) AS Note5
				FROM #Notes
				WHERE NoteNumber <= 5
				GROUP BY ClientId
				) n ON n.ClientId = GC.ClientId
			INNER JOIN #ClientSplitTable cst ON cst.ClientId = GC.ClientId
			WHERE		  
				isnull(G.RecordDeleted, 'N') = 'N'				
				AND isnull(Clients.RecordDeleted, 'N') = 'N'
			
			INSERT INTO GroupServiceStaff (
				GroupServiceId
				,StaffId
				,Unit
				,UnitType
				,EndDateOfService
				,DateOfService
				,CreatedBy
				,CreatedDate
				,ModifiedBy
				,ModifiedDate
				)
			SELECT GroupServiceId
				,StaffId
				,Unit
				,UnitType
				,EndDateTime
				,StartDateTime
				,@UserCode
				,GETDATE()
				,@UserCode
				,GETDATE()
			FROM (
				SELECT ROW_NUMBER() OVER (
						PARTITION BY TG.GroupServiceId
						,GS.StaffId ORDER BY GS.StartDateTime ASC
						) AS Row
					,TG.GroupServiceId
					,GS.StaffId
					,[dbo].[ssf_SCCalculateAttendanceUnits](GS.StartDateTime, GS.EndDateTime, G.Unit, G.UnitType) AS Unit
					,G.UnitType
					,GS.EndDateTime
					,GS.StartDateTime
				FROM #AttendanceGroupServices GS
				INNER JOIN Groups G ON GS.GroupId = G.GroupId
				INNER JOIN Staff S ON GS.StaffId = S.StaffId
				INNER JOIN #TempGroupServiceId TG ON GS.GroupId = TG.GroupId
					AND CAST(GS.AssignmentDate AS DATE) = CAST(TG.DateOfService AS DATE)
				WHERE isnull(S.RecordDeleted, 'N') = 'N'
					AND isnull(G.RecordDeleted, 'N') = 'N'
				) AS GetGroupService
			WHERE GetGroupService.Row = 1

			INSERT INTO Appointments (
				StaffId
				,Subject
				,GroupServiceId
				,StartTime
				,EndTime
				,ShowTimeAs
				,AppointmentType
				,LocationId
				,SpecificLocation
				)
			SELECT GSS.StaffId
				,'Group Service: ' + G.GroupName + ' (#' + cast(G.GroupId AS VARCHAR) + ')'
				,GS.GroupServiceId
				,GSS.DateOfService
				,GSS.EndDateOfService
				,4342
				,4763
				,GS.LocationId
				,GS.SpecificLocation
			FROM GroupServiceStaff GSS
			INNER JOIN GroupServices GS ON GSS.GroupServiceId = GS.GroupServiceId
			INNER JOIN #TempGroupServiceId TG ON GS.GroupServiceId = TG.GroupServiceId
			INNER JOIN Groups G ON TG.GroupId = G.GroupId
			WHERE ISNULL(GSS.RecordDeleted, 'N') = 'N'
				AND ISNULL(GS.RecordDeleted, 'N') = 'N'
				AND ISNULL(G.RecordDeleted, 'N') = 'N'

			CREATE TABLE #Document (
				DocumentId INT
				,AuthorId INT
				)

			CREATE TABLE #DocumentVersion (
				DocumentVersionId INT
				,DocumentId INT
				)

			MERGE INTO Documents D
			USING (
				SELECT S.ClientId
					,gndc.ServiceNoteCodeId AS documentcodeid
					,GS.DateOfService AS EffectiveDate
					,S.ServiceId
					,CASE 
						WHEN S.[Status] = 70
							THEN 20
						ELSE 21
						END AS [Status]
					,CASE 
						WHEN S.[Status] = 70
							THEN 20
						ELSE 21
						END AS CurrentVersionStatus
					,S.ClinicianId AS AuthorId
				FROM Services S
				INNER JOIN GroupServices GS ON GS.GroupServiceId = S.GroupServiceId
				INNER JOIN #TempGroupServiceId TG ON GS.GroupServiceId = TG.GroupServiceId
				INNER JOIN Groups g ON G.GroupId = TG.GroupId
				INNER JOIN GroupNoteDocumentCodes gndc ON gndc.GroupNoteDocumentCodeId = g.GroupNoteDocumentCodeId
					AND isnull(gndc.RecordDeleted, 'N') = 'N' AND gndc.GroupNoteDocumentCodeId IS NOT NULL
					AND ISNULL(g.GroupNoteType,0) = 9383
				WHERE isnull(S.RecordDeleted, 'N') = 'N'
					AND isnull(G.RecordDeleted, 'N') = 'N'
					AND isnull(GS.RecordDeleted, 'N') = 'N'
				) AS GD
				ON D.documentcodeid = GD.DocumentCodeId
					AND D.ClientId = GD.ClientId
					AND D.ServiceId = GD.ServiceId
					AND CAST(D.EffectiveDate AS DATE) = CAST(GD.EffectiveDate AS DATE)					
			WHEN NOT MATCHED
				THEN
					INSERT (
						ClientId
						,DocumentCodeId
						,EffectiveDate
						--,DueDate
						,[Status]
						,AuthorId
						,ServiceId
						--,DocumentShared
						,SignedByAuthor
						,SignedByAll
						,ToSign
						,CurrentVersionStatus
						)
					VALUES (
						GD.ClientId
						,GD.documentcodeid
						,GD.EffectiveDate
						--,GD.EffectiveDate
						,GD.[Status]
						,GD.AuthorId
						,GD.ServiceId
						--,'Y'
						,'N'
						,'N'
						,NULL
						,GD.CurrentVersionStatus
						)
			OUTPUT inserted.DocumentId
				,GD.AuthorId
			INTO #Document(DocumentId, AuthorId);

			MERGE INTO DocumentVersions D
			USING (
				SELECT AD.DocumentId
					,AuthorId
				FROM #Document AD
				) AS DV
				ON DV.DocumentId = D.DocumentId
			WHEN NOT MATCHED
				THEN
					INSERT (
						DocumentId
						,Version
						,RevisionNumber
						,AuthorId
						)
					VALUES (
						DV.DocumentId
						,1
						,1
						,DV.AuthorId
						)
			OUTPUT inserted.DocumentVersionId
				,DV.DocumentId
			INTO #DocumentVersion(DocumentVersionId, DocumentId);

			UPDATE D
			SET CurrentDocumentVersionId = AD.DocumentVersionId
				,InProgressDocumentVersionId = AD.DocumentVersionId
			FROM Documents D
			INNER JOIN #DocumentVersion AD ON AD.DocumentId = D.DocumentId;
			
			INSERT INTO DocumentSignatures (
				CreatedBy
				,CreatedDate
				,ModifiedBy
				,ModifiedDate
				,DocumentId
				,SignedDocumentVersionId
				,StaffId
				,ClientId
				,IsClient
				,RelationToClient
				,RelationToAuthor
				,SignerName
				,SignatureOrder
				,SignatureDate
				,VerificationMode
				,PhysicalSignature
				,DeclinedSignature
				,ClientSignedPaper
				,RevisionNumber
				)
			SELECT @UserCode
				,GETDATE()
				,@UserCode
				,GETDATE()
				,D.DocumentId
				,NULL--D.DocumentVersionId --,SignedDocumentVersionId,  
				,Doc.AuthorId --StaffId,  
				,NULL--Doc.ClientId --ClientId,  
				,NULL --'Y' --IsClient,  
				,NULL --RelationToClient,  
				,NULL --RelationToAuthor,  
				,NULL--ISNULL(S.LastName + ' ,' + S.FirstName, NULL) --SignerName,  
				,1 --SignatureOrder,  
				,NULL --GETDATE() --SignatureDate,  
				,NULL --VerificationMode,  
				,NULL --PhysicalSignature,  
				,NULL --DeclinedSignature,  
				,NULL --ClientSignedPaper,  
				,NULL --RevisionNumber  
			FROM Documents Doc
			JOIN #Document C ON Doc.DocumentID = C.DocumentID
			JOIN DocumentVersions D ON D.DocumentID = Doc.DocumentId
			LEFT JOIN Staff S ON S.StaffId = D.AuthorId
			WHERE NOT EXISTS (
					SELECT *
					FROM DocumentSignatures DS
					WHERE DS.DocumentId = Doc.DocumentID
					)
				--AND Doc.[Status] = 21

			------------------------------------------------------------------------------------------------------------     
			DECLARE @DynamicSQL VARCHAR(MAX)

			SET @DynamicSQL = ' CREATE TABLE #ServiceDiagnoses(DSMCode char(6), DSMNumber int, SortOrder int,[Version] int,DiagnosisOrder int, DSMVCodeId VARCHAR(20),ICD10Code VARCHAR(20),ICD9Code VARCHAR(20),[Description] VARCHAR(MAX),[Order] INT)'
			SET @DynamicSQL = @DynamicSQL + CHAR(13) + CHAR(10) + ' DECLARE @ServiceId INT'
			SET @DynamicSQL = @DynamicSQL + CHAR(13) + CHAR(10) + ' CREATE TABLE #GroupServiceBillingDiagnosis(ServiceDiagnosisId INT IDENTITY(1,1),ServiceId INT,DSMCode VARCHAR(20),DSMNumber INT,DSMVCodeId VARCHAR(20),ICD10Code VARCHAR(20),ICD9Code VARCHAR(20),[Description] VARCHAR(MAX),[Order] INT)'

			SELECT @DynamicSQL = COALESCE(@DynamicSQL + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10), '') + CAST(' SET @ServiceId = ' + CAST(S.ServiceId AS VARCHAR(25)) + CHAR(13) + CHAR(10) + ' INSERT INTO #ServiceDiagnoses(DSMCode, DSMNumber, SortOrder,[Version],DiagnosisOrder,DSMVCodeId,ICD10Code,ICD9Code,[Description],[Order])' + CHAR(13) + CHAR(10) + ' EXEC ssp_SCBillingDiagnosiServiceNote @varClientId = ' + CAST(S.ClientId AS VARCHAR(25)) + ',@varDate = ''' + CAST(S.DateOfService AS VARCHAR(100)) + ''',@varProgramId = ' + CAST(S.ProgramId AS VARCHAR(25)) AS VARCHAR(MAX)) + CHAR(13) + CHAR(10) + ' INSERT INTO #GroupServiceBillingDiagnosis(ServiceId,DSMCode,DSMNumber,DSMVCodeId,ICD10Code,ICD9Code,[Description],[Order])' + CHAR(13) + CHAR(10) + ' SELECT @ServiceId,DSMCode,DSMNumber,DSMVCodeId,ICD10Code,ICD9Code,[Description],[Order] FROM #ServiceDiagnoses' + CHAR(13) + CHAR(10) + ' DELETE FROM #ServiceDiagnoses'
			FROM Services S
			INNER JOIN GroupServices GS ON S.GroupServiceId = GS.GroupServiceId
			INNER JOIN #TempGroupServiceId TGS ON S.GroupServiceId = TGS.GroupServiceId

			SET @DynamicSQL = @DynamicSQL + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + ' INSERT INTO ServiceDiagnosis(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,ServiceId,DSMCode,DSMNumber,DSMVCodeId,ICD10Code,ICD9Code,[Order])'
			--22-Feb-2016    Akwinass
			SET @DynamicSQL = @DynamicSQL + CHAR(13) + CHAR(10) + ' SELECT ''' + @UserCode + ''',''' + CONVERT(VARCHAR, GETDATE(), 120) + ''',''' + @UserCode + ''',''' + CONVERT(VARCHAR, GETDATE(), 120) + ''',ServiceId,DSMCode,DSMNumber,DSMVCodeId,ICD10Code,ICD9Code,[Order] FROM #GroupServiceBillingDiagnosis WHERE [Order] IS NOT NULL'
			SET @DynamicSQL = @DynamicSQL + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + ' DROP TABLE #GroupServiceBillingDiagnosis'
			SET @DynamicSQL = @DynamicSQL + CHAR(13) + CHAR(10) + ' DROP TABLE #ServiceDiagnoses'

			EXEC (@DynamicSQL)
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCCreateAttendanceAssignmentRecurring') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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

