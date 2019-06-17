IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetToDoDocumentsForClients]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetToDoDocumentsForClients]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetToDoDocumentsForClients] --550,550,'N'      
	@StaffId INT
	,@LoggedInStaffId INT
	,@RefreshData CHAR(1) = NULL
	/******************************************************************************************************/
	/* Stored Procedure: ssp_GetToDoDocumentsForClients						                       	      */
	/*																				                      */
	/* Copyright: Streamline Healthcate Solutions									                      */
	/*																				                      */
	/* Purpose: used by dashboard Documents widget For Pathway						                      */
	/*																				                      */
	/* Updates:																		                      */
	/* Date           Author			Purpose										                      */
	/*	22/Nov/2016  Arjun KR        To Get ToDo document for client. Task #447 Aspen Pointe Customizations*/
	/*  24/MAR/2017  Gautam          Change to display other documents assigned to Client,Task 447.11 - 
														Patient Portal Gaps,AspenPointe-Customizations	 */
	/*  18/MAY/2017  Vijay          "Document To Do" Widget display order is not working,Task #447.13 - 
														Patient Portal,AspenPointe-Customizations	 */		
	/*  21/Aug/2017  Sunil.D        "Document To Do" On click of document Need to display in client tab
													But Its Not Displaying. AspenPointe Support #271	 */	
	/*  07/Nov/2017  Vandana Ojha    What : Added check to get only document and avoid group note
									 Why  :  "Document To Do" Should not display GroupNote as per task #34 Carelink EIT*/	
	/*  13/Nov/2017  Venkatesh MR    What : Added Status check before getting the Document list
									 Why  : Widget was showing the signed status documents also. Ref task #78 Bluebonnet - Environment Issues Tracking*/																									
    /*  08/JAN/2018  Akwinass        What : Included ServiceId column.
									 Why  : To redirect service note documents. Ref task #1 StarCare-Environment Issues Tracking*/
	/*
		11/Jun/2018	 tchen			 What: 1. Removed duplicate listings from the #ResultSetDocuments
										   2. Modified to also delete to-do document when the document is signed
									 Why: PSS - Environment Issues Trackings #45
		16/Nov/2018	 tchen			 What: Added EffectiveDate check to only remove to-do documents that have effective dates equal or prior to the effective date of the in-progress or signed document
									 Why: PSS - Support Go Live #311.2
	
	
	
	
	
	*/																							
	/*****************************************************************************************************/
AS
BEGIN
	BEGIN TRY
		DECLARE @DocStatus VARCHAR(250)
		DECLARE @NumbOfDays INT
		DECLARE @Status INT
		DECLARE @TempClientId INT
		DECLARE @UserCode varchar(30)
		
		Select top 1 @UserCode= UserCode From Staff Where StaffId=@LoggedInStaffId AND ISNULL(RecordDeleted, 'N') = 'N'
		
		Create Table #DeletedDocuments
		(ToDoDocumentId int,
		InProgressDocumentId int)
		
		SET @TempClientId = (
				SELECT TempClientId
				FROM Staff
				WHERE StaffId = @StaffId
					AND ISNULL(RecordDeleted, 'N') = 'N'
				)
		SET @DocStatus = (
				SELECT TOP 1 Value
				FROM SystemConfigurationKeys
				WHERE [Key] = 'SETSTATUSDOCUMENT'
				)
		SET @NumbOfDays = (
				SELECT TOP 1 CAST(Value AS INT)
				FROM SystemConfigurationKeys
				WHERE [Key] = 'SETNUMBEROFDAYSFORDOCUMENTTODOWIDGET'
				)
		SET @Status = (
				SELECT TOP 1 [Status]
				FROM ClientEpisodes
				WHERE ClientId = @TempClientId
					AND ISNULL(RecordDeleted, 'N') = 'N'
				ORDER BY ClientEpisodeId DESC
				)
		-- Get All TODO DocumentId which will be deleted 
		Insert into #DeletedDocuments
		(ToDoDocumentId,InProgressDocumentId)
		Select b.DocumentId,c.DocumentId
		FROM Documents b        
		JOIN Documents c ON b.ClientId = c.ClientId
			AND b.DocumentCodeId = c.DocumentCodeId
			AND b.AuthorId = c.AuthorId
		--JOIN #ResultSetDocuments a ON a.DocumentId = b.DocumentId 
		WHERE b.STATUS = 20 -- To Do  
			AND c.STATUS IN (21,22) -- In Progress and signed --tchen 6/12/2018 
			AND b.AuthorId=@LoggedInStaffId
			AND Isnull(b.RecordDeleted, 'N') = 'N'
			AND Isnull(c.RecordDeleted, 'N') = 'N'
			AND b.EffectiveDate <= c.EffectiveDate --tchen 11/16/2018
		
		-- Update Previous ToDoDocumentId with InProgressDocumentId
		update CD
		Set CD.DocumentId=DD.InProgressDocumentId
		From ClientDocumentAssignmentDocuments CD join #DeletedDocuments DD on CD.DocumentId=DD.ToDoDocumentId
		
		-- Finally Delete ToDoDocumentId 	
		UPDATE b
		SET b.RecordDeleted = 'Y',
			b.DeletedDate=getdate(),
			b.DeletedBy= @UserCode       
		FROM Documents b  
		Where exists(Select 1 from #DeletedDocuments DD where b.DocumentId= DD.ToDoDocumentId)    
			
		Create Table #ResultSetDocuments
		( DocumentName Varchar(100),
			DocumentAssignmentDate date,
			DocumentStatus varchar(250),
			DocumentScreenId int,
			DocumentId int,
			ClientId int,
			PriorityOrder int)
		
		Insert into #ResultSetDocuments
		SELECT DC.DocumentName
			,cast(CDAD.DocumentAssignmentDate AS DATE) AS DocumentAssignmentDate
			,GC.CodeName AS DocumentStatus
			,S.ScreenId AS DocumentScreenId
			,CD.DocumentId AS DocumentId
			,case when D.ClientId is null then ( select top(1) ClientId from Services where GroupServiceId=D.GroupServiceId) else D.ClientId end 
			,CDAD.PriorityOrder AS PriorityOrder 
		FROM ClientDocumentAssignments CDAD
		JOIN ClientDocumentAssignmentDocuments CD ON CDAD.ClientDocumentAssignmentId = CD.ClientDocumentAssignmentId
			AND ISNULL(CD.RecordDeleted, 'N') = 'N'
		JOIN Documents D ON CD.DocumentId = D.DocumentId
			AND ISNULL(D.RecordDeleted, 'N') = 'N'
		INNER JOIN DocumentCodes DC ON CDAD.DocumentCodeId = DC.DocumentCodeId
		INNER JOIN Screens S ON S.DocumentCodeId = DC.DocumentCodeId
		JOIN GlobalCodes GC ON D.STATUS = GC.GlobalCodeId 
		WHERE ISNULL(CDAD.RecordDeleted, 'N') = 'N'
			AND D.GroupServiceId is null       --Added to avoid group note in document to do widget --by vandana
			AND (CDAD.ClientId = @TempClientId)
			AND D.STATUS IN (
				SELECT CAST(token AS INT)
				FROM dbo.SplitString(@DocStatus, ',')
				)
			AND DATEADD(DAY, @NumbOfDays, cast(D.EffectiveDate AS DATE)) >= cast(GETDATE() AS DATE)
		--AND D.AuthorId= @TempClientId       
		
		UNION
		
		SELECT DC.DocumentName
			,cast(D.EffectiveDate AS DATE) AS DocumentAssignmentDate
			,GC.CodeName AS DocumentStatus
			,S.ScreenId AS DocumentScreenId
			,CD.DocumentId AS DocumentId
			,case when D.ClientId is null then ( select top(1) ClientId from Services where GroupServiceId=D.GroupServiceId) else D.ClientId end 
			,10000 AS PriorityOrder
		FROM Documents D
		JOIN DocumentVersions CD ON CD.DocumentId = D.DocumentId
			AND ISNULL(D.RecordDeleted, 'N') = 'N'
		INNER JOIN DocumentCodes DC ON D.DocumentCodeId = DC.DocumentCodeId
		INNER JOIN Screens S ON S.DocumentCodeId = DC.DocumentCodeId
		JOIN GlobalCodes GC ON D.STATUS = GC.GlobalCodeId 
		WHERE ISNULL(CD.RecordDeleted, 'N') = 'N'
			AND D.GroupServiceId is null       --Added to avoid group note in document to do widget --by vandana
			AND D.AuthorId = @LoggedInStaffId
			AND DATEADD(DAY, @NumbOfDays, cast(D.EffectiveDate AS DATE)) >= cast(GETDATE() AS DATE)
			AND not exists(Select 1 from ClientDocumentAssignments CDAD
		JOIN ClientDocumentAssignmentDocuments CD ON CDAD.ClientDocumentAssignmentId = CD.ClientDocumentAssignmentId
		where CD.DocumentId=D.DocumentId AND ISNULL(CDAD.RecordDeleted, 'N') = 'N' AND ISNULL(CD.RecordDeleted, 'N') = 'N')
		AND D.STATUS IN ( -- Get the Documents only status which are configured in System COnfigurationKeys Ref Task #Bluebonet Environment Issue Tracking #78 - Venkatesh
				SELECT CAST(token AS INT)
				FROM dbo.SplitString(@DocStatus, ',')
				)
	    UNION
	    		
		SELECT DC.DocumentName
			,cast(D.EffectiveDate AS DATE) AS DocumentAssignmentDate
			,GC.CodeName AS DocumentStatus
			,S.ScreenId AS DocumentScreenId
			,CD.DocumentId AS DocumentId
			,D.ClientId  as ClientId
			,20000 AS PriorityOrder
		FROM Documents D
		JOIN DocumentVersions CD ON CD.DocumentId = D.DocumentId
			AND ISNULL(D.RecordDeleted, 'N') = 'N'
		INNER JOIN DocumentCodes DC ON D.DocumentCodeId = DC.DocumentCodeId
		INNER JOIN Screens S ON S.DocumentCodeId = DC.DocumentCodeId
		JOIN GlobalCodes GC ON D.STATUS = GC.GlobalCodeId
		WHERE ISNULL(CD.RecordDeleted, 'N') = 'N'
			AND D.GroupServiceId is null       --Added to avoid group note in document to do widget --by vandana
			AND DATEADD(DAY, @NumbOfDays, cast(D.EffectiveDate AS DATE)) >= cast(GETDATE() AS DATE)
			AND D.STATUS IN (   -- Get the Documents only status which are configured in System COnfigurationKeys Ref Task #Bluebonet Environment Issue Tracking #78 - Venkatesh
				SELECT CAST(token AS INT)
				FROM dbo.SplitString(@DocStatus, ',')
				)
			AND EXISTS (
				SELECT 1
				FROM DocumentSignatures DS
				WHERE DS.DocumentId = D.DocumentId
					AND DS.ClientId = @TempClientId
					AND DS.ISClient = 'Y'
					AND ISNULL(DS.RecordDeleted, 'N') = 'N'
				)

		-- 18/MAY/2017  Vijay
 		Update #ResultSetDocuments Set PriorityOrder =(Select max(PriorityOrder)+1 from #ResultSetDocuments where PriorityOrder not in(10000, 20000))
		Where PriorityOrder =10000 and exists(Select 1 from #ResultSetDocuments where PriorityOrder not in(10000, 20000))
		   
		Update #ResultSetDocuments Set PriorityOrder =(Select max(PriorityOrder)+1 from #ResultSetDocuments where PriorityOrder not in(20000))
		Where PriorityOrder =20000 and exists(Select 1 from #ResultSetDocuments where PriorityOrder not in(20000))
	   
		--tchen added to remove duplicates 6/11/2018:
		DELETE  rsd
		FROM    #ResultSetDocuments AS rsd
		WHERE   EXISTS
		(   SELECT  1
			FROM    #ResultSetDocuments AS rsd2
			WHERE   rsd.DocumentName = rsd2.DocumentName
					--AND rsd.DocumentAssignmentDate = rsd2.DocumentAssignmentDate
					AND rsd.DocumentStatus = rsd2.DocumentStatus
					AND rsd.DocumentScreenId = rsd2.DocumentScreenId
					AND rsd.DocumentId = rsd2.DocumentId
					AND rsd.ClientId = rsd2.ClientId
					AND rsd2.PriorityOrder < rsd.PriorityOrder )

		SELECT TD.DocumentName
			,TD.DocumentAssignmentDate
			,TD.DocumentStatus
			,TD.DocumentScreenId
			,TD.DocumentId
			,TD.ClientId
			,TD.PriorityOrder
			,ISNULL(D.ServiceId, 0) AS ServiceId
		FROM #ResultSetDocuments TD
		LEFT JOIN Documents D ON TD.DocumentId = D.DocumentId
		ORDER BY PriorityOrder		
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetToDoDocumentsForClients') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                                    
				16
				,-- Severity.                                                                                                    
				1 -- State.                                                                                                    
				);
	END CATCH
END
