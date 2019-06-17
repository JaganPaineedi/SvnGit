
IF EXISTS
(
    SELECT *
    FROM sys.objects
    WHERE OBJECT_ID = OBJECT_ID(N'[SMSP_GETDOCUMENT]')
          AND OBJECTPROPERTY(OBJECT_ID, N'IsProcedure') = 1
)
    DROP PROCEDURE [dbo].[SMSP_GETDOCUMENT];
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE PROCEDURE SMSP_GETDOCUMENT @DOCUMENTVERSIONID INT --SMSP_GETDOCUMENT 1601298  
AS
-- =============================================        
-- Author:  Pradeep A        
-- Create date: 24-10-2018  
-- Description: Get Offline Document  
/*        
 Author   Modified Date   Reason        
     
        
*/

-- =============================================    

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
               D.DocumentCodeId
        FROM Documents D
             INNER JOIN DocumentSignatures DS ON DS.DocumentId = D.DocumentId
             INNER JOIN DocumentVersions DV ON DV.DocumentId = D.DocumentId
             INNER JOIN DocumentVersionViews DVV ON DVV.DocumentVersionId = DV.DocumentVersionId
             INNER JOIN DocumentCodes DC ON DC.DocumentCodeId = D.DocumentCodeId
             INNER JOIN Staff S ON S.StaffId = D.AuthorId
             INNER JOIN Clients C ON C.CLientId = D.ClientId
        WHERE D.STATUS = 22
              AND DV.DocumentVersionId = @DocumentVersionId
              AND DS.IsClient IN('Y', 'N')
             AND ISNULL(D.RecordDeleted, 'N') = 'N'
             AND ISNULL(DS.RecordDeleted, 'N') = 'N'
             AND ISNULL(DC.RecordDeleted, 'N') = 'N'
             AND ISNULL(S.RecordDeleted, 'N') = 'N'
             AND S.Active = 'Y'
             AND DC.Active = 'Y'
        ORDER BY D.Effectivedate DESC;
    END TRY
    BEGIN CATCH
        DECLARE @Error VARCHAR(8000);
        SET @Error = CONVERT(VARCHAR, ERROR_NUMBER())+'*****'+CONVERT(VARCHAR(4000), ERROR_MESSAGE())+'*****'+isnull(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PMPayments')+'*****'+CONVERT(VARCHAR, ERROR_LINE())+'*****'+CONVERT(VARCHAR, ERROR_SEVERITY())+'*****'+CONVERT(VARCHAR, ERROR_STATE());
        RAISERROR(@Error, 16, 1);
    END CATCH;      