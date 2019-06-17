if OBJECT_ID('ssf_GetLatestDocumentVersionIdForLoggedInUser', 'FN') is not null
	drop function dbo.ssf_GetLatestDocumentVersionIdForLoggedInUser
go

create function ssf_GetLatestDocumentVersionIdForLoggedInUser
(
	@DocumentId int,
	@LoggedInUserId int
) returns int as
/************************************************************************/              
/* Stored Function: dbo.ssf_GetLatestDocumentVersionIdForLoggedInUser	*/              
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC				*/              
/* Creation Date:    22 Mar 2017                                        */              
/*																		*/              
/* Purpose: Given a document id and the logged in staff, return the		*/              
/*			most recent document version associated with the document.	*/
/*			In general, the author should get the "in progress" version	*/
/*			while non-authors should get the "current" version.			*/
/*			Created to centralize this logic for use in various stored	*/
/*			procedures.													*/
/*																		*/            
/* Input Parameters: @DocumentId ,@LoggedInUserId						*/            
/*																		*/              
/*																		*/              
/* Return: DocumentVersionId int					                    */              
/*																		*/              
/* Called By:															*/              
/*																		*/              
/* Calls:																*/              
/*																		*/              
/* Data Modifications:													*/              
/*																		*/              
/* Updates:																*/              
/*   Date         Author         Purpose                                */              
/* 22 Mar 2017    T.Remisoski    Created                                */  
/* 23 Mar 2018    Vsinha        Join Documents table with Documentversions table to check that documentVersion should not be deleted for that document : Woods -SGL #864*/    
/* 22 June 2018   Sachin        What : When user trying to first time save text field on a new versions text disappearing
                                Why  : When user trying to first time save text field on a new versions text disappearing  because after Saving the document, the documentversionid 
                                is pulling existing instead of newly saved documentversionid hence this issue. 
                                Per discssion with Gautam and Tom , added the condition : WHEN (DVI.AuthorId = @LoggedInUserId) THEN D.InProgressDocumentVersionId */      
/************************************************************************/              

begin

	declare @LatestDocumentVersionId int = 0

	select @LatestDocumentVersionId =
	CASE
			WHEN (D.AuthorId = @LoggedInUserId) THEN ISNULL(D.InProgressDocumentVersionId, D.CurrentDocumentVersionId)	-- just in case InprogressDocumentVersionId is null for some reason
				WHEN (D.ReviewerId = @LoggedInUserId) THEN
					CASE WHEN (D.Status = 25 OR D.CurrentVersionStatus = 25) THEN D.InProgressDocumentVersionId ELSE D.CurrentDocumentVersionId END
				WHEN DC.AllowEditingByNonAuthors = 'Y' THEN D.InProgressDocumentVersionId 					
				
				-- Added By Sachin (changed by Tom)				
				WHEN (DVI.AuthorId = @LoggedInUserId) THEN D.InProgressDocumentVersionId
				
				-- This only allows proxies to edit the first version of the document.  May need to review with core committee.
				WHEN (D.AuthorId IN (SELECT ProxyForStaffId FROM StaffProxies WHERE StaffId = @LoggedInUserId AND ISNULL(RecordDeleted, 'N') = 'N')
					  OR D.ProxyId = @LoggedInUserId OR D.Status IN(22,23) OR D.DocumentShared = 'Y') THEN D.CurrentDocumentVersionId
				ELSE D.CurrentDocumentVersionId
		   END
		FROM Documents D
		JOIN DocumentCodes DC ON DC.DocumentCodeId = D.DocumentCodeId
		left join DocumentVersions DVI ON DVI.DocumentVersionId = D.InProgressDocumentVersionId AND ISNULL(DVI.RecordDeleted,'N')='N'
		left join DocumentVersions DVC ON DVC.DocumentVersionId = D.CurrentDocumentVersionId AND ISNULL(DVC.RecordDeleted,'N')='N'
	WHERE D.DocumentId = @DocumentID 
	 AND ISNULL(D.RecordDeleted,'N')='N'
	 
	return @LatestDocumentVersionId

end
GO

