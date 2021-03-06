/****** Object:  StoredProcedure [dbo].[ssp_SCGetGroupTemplateDetails]    Script Date: 07/24/2015 12:27:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetGroupTemplateDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetGroupTemplateDetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetGroupTemplateDetails]    Script Date: 07/24/2015 12:27:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetGroupTemplateDetails] @GroupTemplateId INT
AS
/**************************************************************  
Created By   : Akwinass
Created Date : 13-APRIL-2016 
Description  : Used to Get Group Template Data  
Called From  : Group Template Screens
/*  Date			  Author				  Description */
/*  13-APRIL-2016	  Akwinass				  Created    */
**************************************************************/ 
BEGIN
	BEGIN TRY	
		SELECT D.[DocumentId]
			,D.[CreatedBy]
			,D.[CreatedDate]
			,D.[ModifiedBy]
			,D.[ModifiedDate]
			,D.[RecordDeleted]
			,D.[DeletedDate]
			,D.[DeletedBy]
			,D.[ClientId]
			,D.[ServiceId]
			,D.[GroupServiceId]
			,D.[EventId]
			,D.[ProviderId]
			,D.[DocumentCodeId]
			,D.[EffectiveDate]
			,D.[DueDate]
			,D.[Status]
			,D.[AuthorId]
			,D.[CurrentDocumentVersionId]
			,D.[DocumentShared]
			,D.[SignedByAuthor]
			,D.[SignedByAll]
			,D.[ToSign]
			,D.[ProxyId]
			,D.[UnderReview]
			,D.[UnderReviewBy]
			,D.[RequiresAuthorAttention]
			,D.[InitializedXML]
			,D.[BedAssignmentId]
			,D.[ReviewerId]
			,D.[InProgressDocumentVersionId]
			,D.[CurrentVersionStatus]
			,D.[ClientLifeEventId]
			,D.[AppointmentId]
		FROM [Documents] D
		JOIN GroupTemplates GT ON D.DocumentId = GT.DocumentId
		WHERE GT.GroupTemplateId = @GroupTemplateId
			AND ISNULL(GT.RecordDeleted, 'N') = 'N'
			AND ISNULL(D.RecordDeleted, 'N') = 'N'
  	
		SELECT GT.GroupTemplateId
			,GT.CreatedBy
			,GT.CreatedDate
			,GT.ModifiedBy
			,GT.ModifiedDate
			,GT.RecordDeleted
			,GT.DeletedBy
			,GT.DeletedDate
			,GT.GroupId
			,GT.StaffId
			,GT.DocumentId
			,GT.StartDate
			,GT.EndDate			
		FROM GroupTemplates GT
		WHERE GT.GroupTemplateId = @GroupTemplateId
			AND ISNULL(GT.RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[ssp_SCGetGroupTemplateDetails]') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


