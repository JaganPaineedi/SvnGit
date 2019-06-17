IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[scsp_SCDocumentPostSignatureUpdates]') AND OBJECTPROPERTY(object_id, N'IsProcedure') = 1)
	DROP PROCEDURE scsp_SCDocumentPostSignatureUpdates
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE scsp_SCDocumentPostSignatureUpdates 
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

	@CurrentUserId  INT,
	@DocumentId     INT
AS

BEGIN

	RETURN
END
GO
