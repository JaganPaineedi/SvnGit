/****** Object:  StoredProcedure [dbo].[scsp_SCDocumentPostSignatureUpdates]    Script Date: 11/28/2014 15:27:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_SCDocumentPostSignatureUpdates]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_SCDocumentPostSignatureUpdates]
GO

/****** Object:  StoredProcedure [dbo].[scsp_SCDocumentPostSignatureUpdates]    Script Date: 11/28/2014 15:27:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[scsp_SCDocumentPostSignatureUpdates] (
	@CurrentUserId INT
	,@DocumentId INT
	)
AS 
/********************************************************************************                                                  
-- Stored Procedure: scsp_SCDocumentPostSignatureUpdates
--
-- Copyright: Streamline Healthcate Solutions
--
-- Purpose: Customization support for Document post signature updates.
--
-- *****History****
-- 13-June-2013		Gautam				Created 
*********************************************************************************/

DECLARE @DocumentCodeId INT
	,@ClientId INT
	,@AuthorID INT
	,@CreatedBy VARCHAR(30)
	,@DocumentVersionId INT
	,@DueDate DATETIME
	,@EffectiveDate DATETIME

SELECT @DocumentCodeId = d.DocumentCodeId
	,@ClientId = d.CLientId
	,@AuthorID = d.AuthorId
	,@CreatedBy = d.CreatedBy
	,@DocumentVersionId = d.CurrentDocumentVersionId
	,@EffectiveDate = d.EffectiveDate
FROM Documents d
WHERE d.DocumentId = @DocumentId
BEGIN

IF (@DocumentCodeId = 46225)
BEGIN
	EXEC csp_PostSignatureUpdateDischarges @DocumentVersionId
END
	RETURN
END
