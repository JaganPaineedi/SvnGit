/****** Object:  StoredProcedure [dbo].[ssp_SCCreateToDoDocumentsForDocumentAssignments]    Script Date: 03/22/2017 10:51:17 ******/
IF EXISTS ( SELECT	*
			FROM	sys.objects
			WHERE	object_id = OBJECT_ID(N'[dbo].[ssp_SCCreateToDoDocumentsForDocumentAssignments]')
					AND type IN ( N'P', N'PC' ) )
	DROP PROCEDURE dbo.ssp_SCCreateToDoDocumentsForDocumentAssignments
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCCreateToDoDocumentsForDocumentAssignments]    Script Date: 10/19/2015 10:51:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCCreateToDoDocumentsForDocumentAssignments] 
@ClientId INT,
@UserCode varchar(30)
AS 
/*********************************************************************/ 
/* Stored Procedure: dbo.ssp_SCCreateToDoDocumentsForDocumentAssignments            */ 
/* Creation Date:    22/Mar/2017                 */ 
/* Purpose:  Used to create TO DO documents from ClientDocumentAssignments table   */ 
/*    Exec ssp_SCCreatePatientPortalDocuments                                         */
/* Input Parameters:                           */ 
/*  Date			Author			Purpose              */ 
/* 22/Mar/2017		Gautam			Created ,Task 447.11 - Patient Portal Gaps,AspenPointe-Customizations	           */ 
  /*********************************************************************/ 
  BEGIN      
      BEGIN try 
      
      Declare @AuthorId Int
      
      Select top 1 @AuthorId= StaffId From Staff Where TempClientId=@ClientId 
      
		CREATE TABLE #NewDocuments(
			ClientDocumentAssignmentId INT,
			ClientId int,
			EffectiveDate datetime,
			AuthorId int,
			DocumentCodeId int,
			DocumentId Int
		)
		
		CREATE TABLE #NewlyAddedVersions            
		 (          
		  DocumentId  Int      
		 )     
 
		-- Insert new To Do documents 
		insert into #NewDocuments(
		ClientDocumentAssignmentId,
		ClientId,
		AuthorId,
		DocumentCodeId,
		-- set effective date here
		EffectiveDate
		)
		select Distinct a.ClientDocumentAssignmentId,a.ClientId, @AuthorId, a.DocumentCodeId,getdate() 			
		from ClientDocumentAssignments a join Staff s on a.ClientId= s.TempClientId
		Where a.ClientId= @ClientId and ISNULL(a.RecordDeleted,'N') = 'N'
		and ISNULL(s.RecordDeleted,'N') = 'N'
		and not exists
		(select 1 from ClientDocumentAssignmentDocuments b
		where  a.ClientDocumentAssignmentId=b.ClientDocumentAssignmentId
		and isnull(b.RecordDeleted,'N') = 'N'
		)
		and not exists
		(select 1 from Documents b
		where  b.ClientId= @ClientId and b.AuthorId =@AuthorId and b.DocumentCodeId=a.DocumentCodeId
					and b.Status=20
		and isnull(b.RecordDeleted,'N') = 'N'
		)
		If not exists(Select 1 from #NewDocuments)
			Return
			
		BEGIN TRAN 
	
		INSERT INTO Documents(
			ClientId,
			DocumentCodeId,
			EffectiveDate,
			DueDate,
			Status,
			AuthorId,
			DocumentShared,
			SignedByAuthor,
			SignedByAll,
			ToSign,
			CurrentVersionStatus,
			CreatedBy,
			CreatedDate,
			ModifiedBy,
			ModifiedDate
		)
			OUTPUT INSERTED.DocumentId INTO #NewlyAddedVersions(DocumentId) 
		SELECT a.ClientId,
			   a.DocumentCodeId,
			   CONVERT(DATE,a.EffectiveDate,101),
			   CONVERT(DATE,a.EffectiveDate,101),
			   20,
			   a.AuthorId,
			   'Y',
			   'N',
			   'N',
			   NULL,
			   20,
			   @UserCode,
			   GETDATE(),
			   @UserCode,
			   GETDATE()
		FROM #NewDocuments a
		
		-- Insert new document version
		INSERT INTO DocumentVersions(
			DocumentId,
			Version,
			CreatedBy,
			CreatedDate,
			ModifiedBy,
			ModifiedDate
		)
		SELECT d.DocumentId,
			   1,
			   @UserCode,
			   GETDATE(),
			   @UserCode,
			   GETDATE()
		FROM Documents d
		join #NewlyAddedVersions b on d.DocumentId = b.DocumentId 
		--JOIN #NewDocuments a ON a.ClientId = d.ClientId and d.DocumentCodeId=a.DocumentCodeId
		WHERE d.Status = 20 AND
			  ISNULL(d.RecordDeleted,'N') = 'N'
			 
		-- Set document current and in progress document version id to newly created document version id
		UPDATE d
		SET CurrentDocumentVersionId = dv.DocumentVersionId,
			InProgressDocumentVersionId = dv.DocumentVersionId
		FROM Documents d
		JOIN #NewDocuments a ON a.ClientId = d.ClientId and a.DocumentCodeId=d.DocumentCodeId
		JOIN DocumentVersions dv ON dv.DocumentId = d.DocumentId
		WHERE d.Status = 20
		
		update N
		set N.DocumentId= NA.DocumentId
		From #NewDocuments N Join Documents D on N.ClientId = d.ClientId and N.DocumentCodeId=d.DocumentCodeId
		 Join #NewlyAddedVersions NA ON NA.DocumentId = d.DocumentId
		
		Insert Into ClientDocumentAssignmentDocuments
		(DocumentId ,ClientDocumentAssignmentId ,CreatedBy,CreatedDate,	ModifiedBy,	ModifiedDate)
		Select distinct a.DocumentId, a.ClientDocumentAssignmentId,@UserCode, GETDATE(),@UserCode, GETDATE()
		FROM  #NewDocuments a 
		WHERE 
		  not exists  
		  (select * from ClientDocumentAssignmentDocuments b  
		  where  a.ClientDocumentAssignmentId=b.ClientDocumentAssignmentId  and b.DocumentId=a.DocumentId 
		  and isnull(b.RecordDeleted,'N') = 'N'  
		  )  
		
		Update C
		set C.RecordDeleted=a.RecordDeleted, C.DeletedBy=a.DeletedBy, C.DeletedDate=a.DeletedDate
		From ClientDocumentAssignmentDocuments C Join ClientDocumentAssignments
		 a on C.ClientDocumentAssignmentId= a.ClientDocumentAssignmentId
		 where a.RecordDeleted='Y'
		
		
       COMMIT TRAN 
          
      END try 

      BEGIN catch 
          DECLARE @Error VARCHAR(max) 
		  if @@TRANCOUNT > 0 rollback tran
          SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
                      + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) 
                      + '*****' 
                      + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 
                      'ssp_SCCreateToDoDocumentsForDocumentAssignments' 
                      ) 
                      + '*****' + CONVERT(VARCHAR, ERROR_LINE()) 
                      + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) 
                      + '*****' + CONVERT(VARCHAR, ERROR_STATE()) 

          ROLLBACK TRANSACTION 

          RAISERROR ( @Error, 
                      -- Message text.                                                                                 
                      16, 
                      -- Severity.                                                                                 
                      1 
          -- State.                                                                                 
          ); 
      END catch 
  END 
