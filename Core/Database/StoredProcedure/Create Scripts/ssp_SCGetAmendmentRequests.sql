
/****** Object:  StoredProcedure [dbo].[ssp_SCGetAmendmentRequests]    Script Date: 06/15/2015 23:02:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetAmendmentRequests]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetAmendmentRequests]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetAmendmentRequests]    Script Date: 06/15/2015 23:02:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetAmendmentRequests] (@DocumentVersionId INT)
AS
/******************************************************************************    
**  Name: ssp_SCGetAmendmentRequests    
**  Desc: This fetches data for Amendment Requests Document  
*******************************************************************************    
**  Change History     
**  Date:       Author:    Description:    
**  --------   --------   -------------------------------------------    
   30 Oct 2014   Prasan      created   , Why : MeaningFul Use -> task#65
   06 Nov 2014	 Ponnin		What : Date/Time of Request and Date/Time of Decision. Why : For task #65 of  Client Amendment Request
*******************************************************************************/ 
BEGIN
	SELECT car.DocumentVersionId
		,car.CreatedBy
		,car.CreatedDate
		,car.ModifiedBy
		,car.ModifiedDate
		,car.RecordDeleted
		,car.DeletedBy
		,car.DeletedDate
		,car.ReasonForRequest
	FROM ClientAmendmentRequestDocuments car
	WHERE car.DocumentVersionId = @DocumentVersionId
		AND ISNULL(car.RecordDeleted, 'N') = 'N'

	SELECT cardd.ClientAmendmentRequestDetailDocumentId
		,cardd.CreatedBy
		,cardd.CreatedDate
		,cardd.ModifiedBy
		,cardd.ModifiedDate
		,cardd.RecordDeleted
		,cardd.DeletedBy
		,cardd.DeletedDate
		,cardd.DocumentVersionId
		,cardd.AmendedDocumentVersionId
		,cardd.AmendmentRequested
		,cardd.AcceptedOrDenied
		,cardd.ReasonForDenial
		,cardd.DateOfRequest
		,cardd.DateOfDecision
		,dc.DocumentName
		,(ISNULL(s.LastName + ', ', '') + s.FirstName) Author
		,CONVERT(VARCHAR, d.EffectiveDate, 101) EffectiveDate
	FROM ClientAmendmentRequestDetailDocuments cardd
	INNER JOIN DocumentVersions dv ON dv.DocumentVersionId = cardd.AmendedDocumentVersionId
		AND ISNULL(dv.RecordDeleted, 'N') = 'N'
	INNER JOIN Documents d ON d.DocumentId = dv.DocumentId
		AND ISNULL(d.RecordDeleted, 'N') = 'N'
	INNER JOIN Staff s ON s.StaffId = d.AuthorId
	INNER JOIN DocumentCodes dc ON dc.DocumentCodeId = d.DocumentCodeId
	WHERE cardd.DocumentVersionId = @DocumentVersionId
		AND ISNULL(cardd.RecordDeleted, 'N') = 'N'
END

GO


