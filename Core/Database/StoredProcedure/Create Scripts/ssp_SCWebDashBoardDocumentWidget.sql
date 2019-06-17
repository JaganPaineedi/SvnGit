/****** Object:  StoredProcedure [dbo].[ssp_SCWebDashBoardDocumentWidget]    Script Date: 04/20/2017 11:49:09 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebDashBoardDocumentWidget]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCWebDashBoardDocumentWidget]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCWebDashBoardDocumentWidget]    Script Date: 04/20/2017 11:49:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCWebDashBoardDocumentWidget] @StaffId INT
	,@LoggedInStaffId INT
	,@RefreshData CHAR(1) = NULL
	/****************************************************************************/
	/* Stored Procedure: ssp_SCWebDashBoardDocumentWidget        */
	/*                    */
	/* Copyright: Streamline Healthcate Solutions         */
	/*                    */
	/* Purpose: used by dashboard Documents widget For Pathway      */
	/*                    */
	/* Updates:                  */
	/* Date           Author   Purpose          */
	/* 01/09/2016   Ravi    WHAT: Logic referred  from Threshold CSP 'csp_SCWebDashBoardDocumentWidget'   */
	/*         Why:Pathway - Support Go Live: #159 Contribution functionality 
	   04/26/2017   Gautam  What: Added logic for StaffClients access for all documents. Dashboard couent was not
									matching with Document list page ,Pathway - Support Go Live: #159 Contribution functionality 
      05/18/2017	Msood	What: Changed CurrentDocumentVersionId to InProgressDocumentVersionId
					Why: Showing wrong number of records on My Documents list page, Pathway - Support Go Live Task# 159									*/
	/*08/21/2017    Bernardin  Modified Column names as same as in UI design. MFS - Support Go Live# 159*/
	/*25/Sep/2017	Irfan	What: Added Distinct to DocumentId. Since it was showing duplicate number on Assigned Document widget.
							Why:  Spring River - Environment Issues Tracking -#89*/
    /*17/Oct/2017   Bernardin  What: Commented OR condition for selecting In Progress MHA Documents(d.CurrentVersionStatus = 25) 
                               Why: There is a diference between Document Wedget and Document List page, Because wedget ssp selecting both In Progress and To be Reviewed status as In Progress. But list page considered only In Progress Status. MFS - SGL# 179 */
     /*06/Mar/2019   Neelima  What: When the user create a co-sign for the Service Notes, the count is not increasing in the ‘Co-Sign’ column under ‘Assigned Documents’ widget, So added select statement to get the Cosign documents for Service Note.
                               Why: Core Bugs #2714
 */
	/****************************************************************************/
AS
BEGIN
	BEGIN TRY
		DECLARE @CarePlanDocumentNavigationId INT
		DECLARE @NotesDocumentNavigationId INT
		DECLARE @AssessmentDocumentNavigationId INT
		DECLARE @OtherDocumentNavigationId INT
		DECLARE @AssessmentDueNow INT
		DECLARE @AssessmentInProgress INT
		DECLARE @AssessmentDuInFourteen INT
		DECLARE @AssessmentCoSign INT
		DECLARE @AssessmentAssigned INT
		DECLARE @AssessmentMemberSign INT
		DECLARE @AssessmentToSign INT
		DECLARE @NotesDueNow INT
		DECLARE @NotesInProgress INT
		DECLARE @NotesDuInFourteen INT
		DECLARE @NotesCoSign INT
		DECLARE @NotesAssigned INT
		DECLARE @NotesMemberSign INT
		DECLARE @NotesToSign INT
		--                  
		DECLARE @CarePlanDueNow INT
		DECLARE @CarePlanInProgress INT
		DECLARE @CarePlanDueInFourteen INT
		DECLARE @CarePlanCoSign INT
		DECLARE @CarePlanAssigned INT
		DECLARE @CarePlanMemberSign INT
		DECLARE @CarePlanToSign INT
		DECLARE @OthersDueNow INT
		DECLARE @OthersInProgress INT
		DECLARE @OthersDueInFourteen INT
		DECLARE @OthersCoSign INT
		DECLARE @OthersAssigned INT
		DECLARE @OthersMemberSign INT
		DECLARE @OthersToSign INT
		DECLARE @Today DATETIME;

		CREATE TABLE #DocumentCodeFilters (
			DocumentCodeId INT
			,DocumentNavigationId INT
			)

		CREATE TABLE #DocumentCounts (
			CountType VARCHAR(20)
			,DocumentNavigationId INT
			,DocumentCount INT
			)

		CREATE TABLE #DocumentCodeFiltersNotOthers (
			DocumentCodeId INT
			,DocumentNavigationId INT
			)

		CREATE TABLE #DocumentCodeFiltersForServiceNote (
			DocumentCodeId INT
			,DocumentNavigationId INT
			)

		SELECT @NotesDocumentNavigationId = a.DocumentNavigationId
		FROM DocumentWidgetDocumentNavigations a
		WHERE a.ColumnNumber = 1
			AND ISNULL(RecordDeleted, 'N') <> 'Y'

		SELECT @CarePlanDocumentNavigationId = a.DocumentNavigationId
		FROM DocumentWidgetDocumentNavigations a
		WHERE a.ColumnNumber = 2
			AND ISNULL(RecordDeleted, 'N') <> 'Y'

		SELECT @AssessmentDocumentNavigationId = a.DocumentNavigationId
		FROM DocumentWidgetDocumentNavigations a
		WHERE a.ColumnNumber = 3

		SET @OtherDocumentNavigationId = 0;
		SET @Today = convert(CHAR(10), getdate(), 101);

		INSERT INTO #DocumentCodeFiltersForServiceNote (DocumentCodeId)
		EXEC ssp_GetDocumentNavigationDocumentCodes @DocumentNavigationId = @NotesDocumentNavigationId

		UPDATE #DocumentCodeFiltersForServiceNote
		SET DocumentNavigationId = @NotesDocumentNavigationId
		WHERE DocumentNavigationId IS NULL

		INSERT INTO #DocumentCodeFilters (DocumentCodeId)
		EXEC ssp_GetDocumentNavigationDocumentCodes @DocumentNavigationId = @CarePlanDocumentNavigationId

		UPDATE #DocumentCodeFilters
		SET DocumentNavigationId = @CarePlanDocumentNavigationId
		WHERE DocumentNavigationId IS NULL

		INSERT INTO #DocumentCodeFilters (DocumentCodeId)
		EXEC ssp_GetDocumentNavigationDocumentCodes @DocumentNavigationId = @AssessmentDocumentNavigationId

		UPDATE #DocumentCodeFilters
		SET DocumentNavigationId = @AssessmentDocumentNavigationId
		WHERE DocumentNavigationId IS NULL

		-------------Added yo retain copy of Notes,Assessment,CarePlan-----------              
		INSERT INTO #DocumentCodeFiltersNotOthers
		SELECT DocumentCodeId
			,DocumentNavigationId
		FROM #DocumentCodeFilters

		------------Ends-----------------              
		INSERT INTO #DocumentCodeFilters (DocumentCodeId)
		EXEC ssp_GetDocumentNavigationDocumentCodes @DocumentNavigationId = 0

		UPDATE #DocumentCodeFilters
		SET DocumentNavigationId = @OtherDocumentNavigationId
		WHERE DocumentNavigationId IS NULL

		INSERT INTO #DocumentCounts (
			CountType
			,DocumentNavigationId
			,DocumentCount
			)
		SELECT 'DueNow'
			,dcf.DocumentNavigationId
			,count(DISTINCT d.DocumentId)
		FROM Documents d
		JOIN #DocumentCodeFilters dcf ON dcf.DocumentCodeId = d.DocumentCodeId
		WHERE (
				d.AuthorId = @StaffId
				OR d.ProxyId = @StaffId
				)
			AND d.CurrentVersionStatus = 20
			AND (CONVERT(DATE, d.DueDate, 101) <= CONVERT(DATE, @today, 101))
			AND isnull(d.RecordDeleted, 'N') <> 'Y'
			AND EXISTS ( --04/26/2017   Gautam
				SELECT 1
				FROM StaffClients c
				WHERE c.ClientId = d.ClientId
					AND c.StaffId = @LoggedInStaffId
				)
		GROUP BY dcf.DocumentNavigationId
		
		UNION
		
		SELECT 'InProgress'					
			,dcf.DocumentNavigationId
			,count(DISTINCT d.DocumentId)		--Added on 22-Sep-2017 by Irfan
		FROM Documents d
		JOIN #DocumentCodeFilters dcf ON dcf.DocumentCodeId = d.DocumentCodeId
		WHERE (
				d.AuthorId = @StaffId
				OR d.ProxyId = @StaffId
				)
			AND (
				d.CurrentVersionStatus = 21
				--OR d.CurrentVersionStatus = 25
				)
			AND isnull(d.RecordDeleted, 'N') <> 'Y'
			AND d.ClientId IS NOT NULL
			AND EXISTS (
				SELECT 1
				FROM StaffClients c
				WHERE c.ClientId = d.ClientId
					AND c.StaffId = @LoggedInStaffId
				)
		GROUP BY dcf.DocumentNavigationId
		
		UNION
		
		SELECT 'InProgress'
			,dcf.DocumentNavigationId
			,count(DISTINCT d.DocumentId)	--Added on 22-Sep-2017 by Irfan
		FROM Documents d
		JOIN #DocumentCodeFiltersForServiceNote dcf ON dcf.DocumentCodeId = d.DocumentCodeId
		WHERE (
				d.AuthorId = @StaffId
				OR d.ProxyId = @StaffId
				)
			AND (
				d.CurrentVersionStatus = 21
				--OR d.CurrentVersionStatus = 25
				)
			AND isnull(d.RecordDeleted, 'N') <> 'Y'
			AND d.ClientId IS NOT NULL
			AND EXISTS (
				SELECT 1
				FROM StaffClients c
				WHERE c.ClientId = d.ClientId
					AND c.StaffId = @LoggedInStaffId
				)
		GROUP BY dcf.DocumentNavigationId
		
		UNION
		
		SELECT 'DuInFourteen'
			,dcf.DocumentNavigationId
			,count(DISTINCT d.DocumentId)
		FROM Documents d
		JOIN #DocumentCodeFilters dcf ON dcf.DocumentCodeId = d.DocumentCodeId
		WHERE (
				d.AuthorId = @StaffId
				OR d.ProxyId = @StaffId
				)
			AND d.CurrentVersionStatus = 20
			AND d.ClientId IS NOT NULL
			AND (
				CONVERT(DATE, d.DueDate, 101) >= CONVERT(DATE, @today, 101)
				AND CONVERT(DATE, d.DueDate, 101) < dateadd(dd, 15, CONVERT(DATE, @today, 101))
				)
			AND isnull(d.RecordDeleted, 'N') <> 'Y'
			AND EXISTS (
				SELECT 1
				FROM StaffClients c
				WHERE c.ClientId = d.ClientId
					AND c.StaffId = @LoggedInStaffId
				)
		GROUP BY dcf.DocumentNavigationId
		
		UNION
		
		SELECT 'CoSign'
			,dcf.DocumentNavigationId
			,count(DISTINCT d.DocumentId)
		FROM Documents d
		JOIN DocumentSignatures ds ON ds.DocumentId = d.DocumentId
		JOIN #DocumentCodeFilters dcf ON dcf.DocumentCodeId = d.DocumentCodeId
		WHERE ds.signaturedate IS NULL
			AND isnull(ds.declinedsignature, 'N') = 'N'
			AND ds.StaffId = @StaffId
			AND (ds.StaffId <> d.AuthorId)
			AND (ds.StaffId <> isnull(d.ReviewerId, 0))
			AND d.CurrentVersionStatus = 22
			AND isnull(ds.DeclinedSignature, 'N') = 'N'
			AND isnull(d.RecordDeleted, 'N') <> 'Y'
			AND isnull(ds.RecordDeleted, 'N') <> 'Y'
			AND EXISTS (
				SELECT 1
				FROM StaffClients c
				WHERE c.ClientId = d.ClientId
					AND c.StaffId = @LoggedInStaffId
				)
		GROUP BY dcf.DocumentNavigationId
		
		UNION 
		
		SELECT 'CoSign'  
		   ,dcf.DocumentNavigationId  
		   ,count(DISTINCT d.DocumentId)  
		  FROM Documents d  
		  JOIN DocumentSignatures ds ON ds.DocumentId = d.DocumentId  
		  JOIN #DocumentCodeFiltersForServiceNote dcf ON dcf.DocumentCodeId = d.DocumentCodeId  
		  WHERE ds.signaturedate IS NULL  
		   AND isnull(ds.declinedsignature, 'N') = 'N'  
		   AND ds.StaffId = @StaffId  
		   AND (ds.StaffId <> d.AuthorId)  
		   AND (ds.StaffId <> isnull(d.ReviewerId, 0))  
		   AND d.CurrentVersionStatus = 22  
		   AND isnull(ds.DeclinedSignature, 'N') = 'N'  
		   AND isnull(d.RecordDeleted, 'N') <> 'Y'  
		   AND isnull(ds.RecordDeleted, 'N') <> 'Y'  
		   AND EXISTS (  
			SELECT 1  
			FROM StaffClients c  
			WHERE c.ClientId = d.ClientId  
			 AND c.StaffId = @LoggedInStaffId  
			)   
		  GROUP BY dcf.DocumentNavigationId    
		
		UNION
		
		SELECT 'Assigned'
			,dcf.DocumentNavigationId
			,count(DISTINCT D.DocumentId)
		FROM Documents AS D
		-- Msood 5/18/2017
		JOIN DocumentAssignedTasks AS DAT ON D.InProgressDocumentVersionId = DAT.DocumentVersionId -- msood 5/17/2017
		JOIN CarePlanPrograms AS CDC ON D.InProgressDocumentVersionId = CDC.DocumentVersionId
			AND CDC.StaffId = @LoggedInStaffId
		JOIN #DocumentCodeFilters dcf ON dcf.DocumentCodeId = D.DocumentCodeId
		WHERE DAT.AssignmentStatus <> 6822
		-- Msood 5/18/2017
			AND (DAT.StaffId = @LoggedInStaffId or D.AuthorId=@LoggedInStaffId OR D.ProxyId=@LoggedInStaffId or D.ReviewerId=@LoggedInStaffId)
			AND d.CurrentVersionStatus IN (
				21
				,22
				)
			AND ISNULL(D.RecordDeleted, 'N') = 'N'
			AND ISNULL(DAT.RecordDeleted, 'N') = 'N'
			AND ISNULL(CDC.RecordDeleted, 'N') = 'N'
			AND ISNULL(CDC.AssignForContribution, 'N') = 'Y'
			AND EXISTS (
				SELECT 1
				FROM StaffClients c
				WHERE c.ClientId = d.ClientId
					AND c.StaffId = @LoggedInStaffId
				)
		GROUP BY dcf.DocumentNavigationId
		
		UNION
		
		SELECT 'MemberSign'
			,dcf.DocumentNavigationId
			,count(DISTINCT d.DocumentId)
		FROM Documents d
		JOIN DocumentSignatures ds ON ds.DocumentId = d.DocumentId
		JOIN #DocumentCodeFiltersNotOthers dcf ON dcf.DocumentCodeId = d.DocumentCodeId
		WHERE ds.signaturedate IS NULL
			AND isnull(ds.declinedsignature, 'N') = 'N'
			AND ds.ClientId IS NOT NULL
			AND ds.IsClient = 'Y'
			AND d.CurrentVersionStatus = 22
			AND isnull(d.RecordDeleted, 'N') <> 'Y'
			AND isnull(ds.RecordDeleted, 'N') <> 'Y'
			AND (
				d.AuthorId = @StaffId
				OR d.ReviewerId = @StaffId
				)
			AND EXISTS (
				SELECT 1
				FROM StaffClients c
				WHERE c.ClientId = d.ClientId
					AND c.StaffId = @LoggedInStaffId
				)
		GROUP BY dcf.DocumentNavigationId
		
		UNION
		
		SELECT 'MemberSign'
			,dcf.DocumentNavigationId
			,count(DISTINCT d.DocumentId)
		FROM Documents d
		JOIN DocumentSignatures ds ON ds.DocumentId = d.DocumentId
		JOIN (
			SELECT DocumentCodeId
				,DocumentNavigationId
			FROM #DocumentCodeFilters
			
			EXCEPT
			
			SELECT DocumentCodeId
				,DocumentNavigationId
			FROM #DocumentCodeFiltersNotOthers
			) AS dcf ON dcf.DocumentCodeId = d.DocumentCodeId
		WHERE ds.signaturedate IS NULL
			AND isnull(ds.declinedsignature, 'N') = 'N'
			AND ds.ClientId IS NOT NULL
			AND ds.IsClient = 'Y'
			AND d.CurrentVersionStatus = 22
			AND isnull(d.RecordDeleted, 'N') <> 'Y'
			AND isnull(ds.RecordDeleted, 'N') <> 'Y'
			AND (
				d.AuthorId = @StaffId
				OR d.ReviewerId = @StaffId
				)
			AND EXISTS (
				SELECT 1
				FROM StaffClients c
				WHERE c.ClientId = d.ClientId
					AND c.StaffId = @LoggedInStaffId
				)
		GROUP BY dcf.DocumentNavigationId
		
		UNION
		
		SELECT 'ToSign'
			,dcf.DocumentNavigationId
			,COUNT(DISTINCT d.DocumentId)
		FROM Documents d
		JOIN #DocumentCodeFilters dcf ON dcf.DocumentCodeId = d.DocumentCodeId
		JOIN Screens sr ON sr.DocumentCodeId = d.DocumentCodeId
		WHERE EXISTS (
				SELECT 1
				FROM DocumentSignatures ds
				WHERE ds.DocumentId = d.DocumentId
					AND ds.Signaturedate IS NULL
					AND ISNULL(ds.DeclinedSignature, 'N') = 'N'
					AND ds.StaffId = @LoggedInStaffId
					AND ds.StaffId = d.AuthorId
					AND ISNULL(ds.RecordDeleted, 'N') <> 'Y'
				)
			AND EXISTS (
				SELECT 1
				FROM StaffClients c
				WHERE c.ClientId = d.ClientId
					AND c.StaffId = @LoggedInStaffId
				)
			AND d.CurrentVersionStatus = 21
			AND d.ToSign = 'Y'
			AND ISNULL(d.RecordDeleted, 'N') <> 'Y'
		GROUP BY dcf.DocumentNavigationId

		-------------------Ends-----------------                  
		SELECT @NotesDueNow = max(CASE 
					WHEN CountType = 'DueNow'
						AND DocumentNavigationId = @NotesDocumentNavigationId
						THEN DocumentCount
					ELSE 0
					END)
			,@NotesInProgress = max(CASE 
					WHEN CountType = 'InProgress'
						AND DocumentNavigationId = @NotesDocumentNavigationId
						THEN DocumentCount
					ELSE 0
					END)
			,@NotesDuInFourteen = max(CASE 
					WHEN CountType = 'DuInFourteen'
						AND DocumentNavigationId = @NotesDocumentNavigationId
						THEN DocumentCount
					ELSE 0
					END)
			,@NotesCoSign = max(CASE 
					WHEN CountType = 'CoSign'
						AND DocumentNavigationId = @NotesDocumentNavigationId
						THEN DocumentCount
					ELSE 0
					END)
			,@NotesAssigned = max(CASE 
					WHEN CountType = 'Assigned'
						AND DocumentNavigationId = @NotesDocumentNavigationId
						THEN DocumentCount
					ELSE 0
					END)
			,@NotesMemberSign = max(CASE 
					WHEN CountType = 'MemberSign'
						AND DocumentNavigationId = @NotesDocumentNavigationId
						THEN DocumentCount
					ELSE 0
					END)
			,@NotesToSign = max(CASE 
					WHEN CountType = 'ToSign'
						AND DocumentNavigationId = @NotesDocumentNavigationId
						THEN DocumentCount
					ELSE 0
					END)
			,
			----------------------------                  
			@CarePlanDueNow = max(CASE 
					WHEN CountType = 'DueNow'
						AND DocumentNavigationId = @CarePlanDocumentNavigationId
						THEN DocumentCount
					ELSE 0
					END)
			,@CarePlanInProgress = max(CASE 
					WHEN CountType = 'InProgress'
						AND DocumentNavigationId = @CarePlanDocumentNavigationId
						THEN DocumentCount
					ELSE 0
					END)
			,@CarePlanDueInFourteen = max(CASE 
					WHEN CountType = 'DuInFourteen'
						AND DocumentNavigationId = @CarePlanDocumentNavigationId
						THEN DocumentCount
					ELSE 0
					END)
			,@CarePlanCoSign = max(CASE 
					WHEN CountType = 'CoSign'
						AND DocumentNavigationId = @CarePlanDocumentNavigationId
						THEN DocumentCount
					ELSE 0
					END)
			,@CarePlanAssigned = max(CASE 
					WHEN CountType = 'Assigned'
						AND DocumentNavigationId = @CarePlanDocumentNavigationId
						THEN DocumentCount
					ELSE 0
					END)
			,@CarePlanMemberSign = max(CASE 
					WHEN CountType = 'MemberSign'
						AND DocumentNavigationId = @CarePlanDocumentNavigationId
						THEN DocumentCount
					ELSE 0
					END)
			,@CarePlanToSign = max(CASE 
					WHEN CountType = 'ToSign'
						AND DocumentNavigationId = @CarePlanDocumentNavigationId
						THEN DocumentCount
					ELSE 0
					END)
			,
			----------------------------                  
			@AssessmentDueNow = max(CASE 
					WHEN CountType = 'DueNow'
						AND DocumentNavigationId = @AssessmentDocumentNavigationId
						THEN DocumentCount
					ELSE 0
					END)
			,@AssessmentInProgress = max(CASE 
					WHEN CountType = 'InProgress'
						AND DocumentNavigationId = @AssessmentDocumentNavigationId
						THEN DocumentCount
					ELSE 0
					END)
			,@AssessmentDuInFourteen = max(CASE 
					WHEN CountType = 'DuInFourteen'
						AND DocumentNavigationId = @AssessmentDocumentNavigationId
						THEN DocumentCount
					ELSE 0
					END)
			,@AssessmentCoSign = max(CASE 
					WHEN CountType = 'CoSign'
						AND DocumentNavigationId = @AssessmentDocumentNavigationId
						THEN DocumentCount
					ELSE 0
					END)
			,@AssessmentAssigned = max(CASE 
					WHEN CountType = 'Assigned'
						AND DocumentNavigationId = @AssessmentDocumentNavigationId
						THEN DocumentCount
					ELSE 0
					END)
			,@AssessmentMemberSign = max(CASE 
					WHEN CountType = 'MemberSign'
						AND DocumentNavigationId = @AssessmentDocumentNavigationId
						THEN DocumentCount
					ELSE 0
					END)
			,@AssessmentToSign = max(CASE 
					WHEN CountType = 'ToSign'
						AND DocumentNavigationId = @AssessmentDocumentNavigationId
						THEN DocumentCount
					ELSE 0
					END)
			,
			-----------------------------                      
			@OthersDueNow = max(CASE 
					WHEN CountType = 'DueNow'
						AND DocumentNavigationId = 0
						THEN DocumentCount
					ELSE 0
					END)
			,@OthersInProgress = max(CASE 
					WHEN CountType = 'InProgress'
						AND DocumentNavigationId = 0
						THEN DocumentCount
					ELSE 0
					END)
			,@OthersDueInFourteen = max(CASE 
					WHEN CountType = 'DuInFourteen'
						AND DocumentNavigationId = 0
						THEN DocumentCount
					ELSE 0
					END)
			,@OthersCoSign = max(CASE 
					WHEN CountType = 'CoSign'
						AND DocumentNavigationId = 0
						THEN DocumentCount
					ELSE 0
					END)
			,@OthersAssigned = max(CASE 
					WHEN CountType = 'Assigned'
						AND DocumentNavigationId = 0
						THEN DocumentCount
					ELSE 0
					END)
			,@OthersMemberSign = max(CASE 
					WHEN CountType = 'MemberSign'
						AND DocumentNavigationId = 0
						THEN DocumentCount
					ELSE 0
					END)
			,@OthersToSign = max(CASE 
					WHEN CountType = 'ToSign'
						AND DocumentNavigationId = 0
						THEN DocumentCount
					ELSE 0
					END)
		FROM #DocumentCounts dc

		SELECT @NotesDocumentNavigationId AS NotesDocumentNavigationid
			,@NotesDueNow AS NotesDueNow
			,@NotesInProgress AS NotesInProgress
			,@NotesDuInFourteen AS NotesDuInFourteen
			,@NotesCoSign AS NotesCoSign
			,@NotesAssigned AS NotesAssigned
			,@NotesMemberSign AS NotesMemberSign
			,@NotesToSign AS NotesToSign
			,
			----                     
			@CarePlanDocumentNavigationId AS CarePlanDocumentNavigationId
			,@CarePlanDueNow AS CarePlanDueNow
			,@CarePlanInProgress AS CarePlanInProgress
			,@CarePlanDueInFourteen AS CarePlanDueInFourteen
			,@CarePlanCoSign AS CarePlanCoSign
			,@CarePlanAssigned AS CarePlanAssigned
			,@CarePlanMemberSign AS CarePlanMemberSign
			,@CarePlanToSign AS CarePlanToSign
			,
			----                             
			@AssessmentDocumentNavigationId AS MHADocumentNavigationId
			--,@AssessmentDueNow AS AssessmentDueNow
			,@AssessmentDueNow AS MHADueNow
			--,@AssessmentInProgress AS AssessmentInProgress
			,@AssessmentInProgress AS MHAInProgress
			--,@AssessmentDuInFourteen AS AssessmentDueInFourteen
			,@AssessmentDuInFourteen AS MHADueInFourteen
			--,@AssessmentCoSign AS AssessmentCoSign
			,@AssessmentCoSign AS MHACoSign
			--,@AssessmentAssigned AS AssessmentAssigned
			,@AssessmentAssigned AS MHAAssigned
			,@AssessmentMemberSign AS AssessmentMemberSign
			--,@AssessmentToSign AS AssessmentToSign
			,@AssessmentToSign AS MHAToSign
			,
			------                                
			0 AS OtherDocumentNavigationId
			,@OthersDueNow AS OthersDueNow
			,@OthersInProgress AS OthersInProgress
			,@OthersDueInFourteen AS OthersDueInFourteen
			,@OthersCoSign AS OthersCoSign
			,@OthersAssigned AS OthersAssigned
			,@OthersMemberSign AS OthersMemberSign
			,@OthersToSign AS OthersToSign

		RETURN
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCWebDashBoardDocumentWidget') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                                            
				16
				,-- Severity.                                                                                                            
				1 -- State.                                                                                                            
				);
	END CATCH
END
