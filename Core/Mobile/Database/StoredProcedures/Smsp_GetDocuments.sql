
/****** Object:  StoredProcedure [dbo].[Smsp_GetDocuments]    Script Date: 08-13-2018 18:05:52 ******/
IF EXISTS
(
    SELECT *
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Smsp_GetDocuments]')
          AND type IN(N'P', N'PC')
)
    DROP PROCEDURE [dbo].[Smsp_GetDocuments];
GO

/****** Object:  StoredProcedure [dbo].[SMSP_GETDOCUMENTS]    Script Date: 08-13-2018 18:05:52 ******/

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE PROCEDURE [dbo].[Smsp_GetDocuments] @StaffId INT
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: 13-08-2018
-- Description: Get Offline Document
/*      
 Author			   Modified Date    Reason      
 Vishnu Narayanan  29-10-2018       Added condition for getting Documents if Co-Signer is selected as Other Signer      
      
*/
-- =============================================  
     BEGIN
         BEGIN TRY
             SELECT DC.DocumentName, 
                    D.Effectivedate, 
                    S.DisplayAs, 
                    D.AuthorId, 
                    D.ClientId, 
                    (C.FirstName+' '+C.LastName) AS ClientName, 
                    D.DocumentId, 
                    DV.DocumentVersionId, 
                    ISNULL(DVV.ViewHTML, '') AS ViewHTML, 
                    DS.SignedDocumentVersionId, 
                    DS.SignatureId, 
                    D.DocumentCodeId, 
                    DS.SignerName, 
                    DS.RelationToClient, 
                    DS.IsClient
             FROM Documents D
                  INNER JOIN DocumentSignatures DS ON DS.DocumentId = D.DocumentId
                  INNER JOIN DocumentVersions DV ON DV.DocumentId = D.DocumentId
                  INNER JOIN DocumentVersionViews DVV ON DVV.DocumentVersionId = DV.DocumentVersionId
                  INNER JOIN DocumentCodes DC ON DC.DocumentCodeId = D.DocumentCodeId
                  INNER JOIN Staff S ON S.StaffId = D.AuthorId
                  INNER JOIN Clients C ON C.CLientId = D.ClientId
             WHERE D.STATUS = 22
                   AND D.AuthorId = @StaffId
                   AND (DS.IsClient = 'Y' OR (DS.IsClient = 'N' AND DS.RelationToClient IS NOT NULL))
                  AND DS.SignatureDate IS NULL
                  AND ISNULL(D.RecordDeleted, 'N') = 'N'
                  AND ISNULL(DS.RecordDeleted, 'N') = 'N'
                  AND ISNULL(DC.RecordDeleted, 'N') = 'N'
                  AND ISNULL(S.RecordDeleted, 'N') = 'N'
                  AND S.Active = 'Y'
                  AND DC.Active = 'Y'
                  AND DVV.ViewHTML IS NOT NULL
             ORDER BY D.Effectivedate DESC;
         END TRY
         BEGIN CATCH
             DECLARE @Error VARCHAR(8000);
             SET @Error = CONVERT(VARCHAR, ERROR_NUMBER())+'*****'+CONVERT(VARCHAR(4000), ERROR_MESSAGE())+'*****'+ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'Smsp_GetDocuments')+'*****'+CONVERT(VARCHAR, ERROR_LINE())+'*****'+CONVERT(VARCHAR, ERROR_SEVERITY())+'*****'+CONVERT(VARCHAR, ERROR_STATE());
             RAISERROR(@Error, -- Message text.                                                                     
             16, -- Severity.                                                            
             1 -- State.                                                         
             );
         END CATCH;
     END;
GO