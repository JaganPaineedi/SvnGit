/****** Object:  UserDefinedFunction [dbo].[smsf_GetDocuments]    Script Date: 12/11/2017 19:27:55 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[smsf_GetDocuments]')
			AND type IN (
				N'FN'
				,N'IF'
				,N'TF'
				,N'FS'
				,N'FT'
				)
		)
	DROP FUNCTION [dbo].[smsf_GetDocuments]
GO

/****** Object:  UserDefinedFunction [dbo].[smsf_GetDocuments]    Script Date: 12/11/2017 19:27:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
    
CREATE FUNCTION [dbo].[smsf_GetDocuments] (@ClientId INT, @StaffId INT)    
RETURNS VARCHAR(MAX)    
AS    
BEGIN    
 DECLARE @JsonResult VARCHAR(MAX);    
    
 SELECT @JsonResult = dbo.smsf_FlattenedJSON((    
    SELECT DC.DocumentName    
     ,D.Effectivedate    
     ,S.DisplayAs    
     ,D.AuthorId    
     ,D.ClientId    
     ,D.DocumentId    
     ,DV.DocumentVersionId   
     --,ISNULL(DVV.ViewHTML,'') AS ViewHTML    
    FROM Documents D    
    INNER JOIN DocumentSignatures DS ON DS.DocumentId = D.DocumentId    
    INNER JOIN DocumentVersions DV ON DV.DocumentId =D.DocumentId    
    INNER JOIN DocumentVersionViews DVV ON DVV.DocumentVersionId = DV.DocumentVersionId    
    INNER JOIN DocumentCodes DC ON DC.DocumentCodeId = D.DocumentCodeId    
    INNER JOIN Staff S ON S.StaffId = D.AuthorId   
      
    WHERE D.STATUS = 22    
     AND D.ClientId = @ClientId
	 AND D.AuthorId = @StaffId 
     AND (DS.IsClient = 'Y' OR (DS.IsClient = 'N' AND DS.RelationToClient IS NOT NULL))  
     AND DS.SignatureDate IS NULL    
     AND ISNULL(D.RecordDeleted,'N') = 'N'    
     AND ISNULL(DS.RecordDeleted,'N') = 'N'    
     AND ISNULL(DC.RecordDeleted,'N') = 'N'    
     AND ISNULL(S.RecordDeleted,'N') = 'N'    
     AND S.Active = 'Y'    
     AND DC.Active = 'Y'    
     AND DVV.ViewHTML IS NOT NULL    
    ORDER BY D.Effectivedate DESC    
    FOR XML PATH    
     ,ROOT    
    ));    
    
 RETURN REPLACE(@JsonResult, '"', '''');    
END; 