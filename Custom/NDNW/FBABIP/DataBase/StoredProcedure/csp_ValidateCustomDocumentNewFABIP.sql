/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomDocumentNewFABIP]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentNewFABIP]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomDocumentNewFABIP]
GO


/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomDocumentNewFABIP]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_ValidateCustomDocumentNewFABIP]
	@StaffId int,
	@ClientId int,
	@DocumentCodeId int
AS
BEGIN

	SELECT 'FBA/BIP - Initial document must be created before Quarterly, Annual, or Restraints' AS ValidationMessage,
	       'E' AS WarningOrError
	FROM Clients c
	WHERE c.ClientId = @ClientId AND
	      NOT EXISTS ( SELECT *
	                   FROM Documents d
	                   WHERE d.ClientId = c.ClientId AND
	                         d.DocumentCodeId = 10502 AND
	                         d.Status = 22 AND
	                         ISNULL(d.RecordDeleted,'N') = 'N' )
	   
END

GO


