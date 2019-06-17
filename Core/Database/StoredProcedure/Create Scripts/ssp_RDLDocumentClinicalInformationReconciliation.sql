/****** Object:  StoredProcedure [dbo].[ssp_RDLDocumentClinicalInformationReconciliation]    Script Date: 06/09/2015 11:16:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLDocumentClinicalInformationReconciliation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLDocumentClinicalInformationReconciliation]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLDocumentClinicalInformationReconciliation]    Script Date: 06/09/2015 11:16:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_RDLDocumentClinicalInformationReconciliation]
    (
      @DocumentVersionId INT
    )
AS
    BEGIN

        SELECT  a.DocumentVersionId ,
                a.Medications ,
                a.Allergies ,
                a.Diagnoses ,
                CONVERT(VARCHAR, c.EffectiveDate, 101) AS EffectiveDate,
                d.ClientId ,
                CONVERT(VARCHAR, d.DOB, 101) AS DOB,
                d.FirstName AS ClientFirstname,
                d.LastName AS ClientLastName,
                e.StaffId ,
                e.FirstName AS StaffFirstName,
                e.LastName AS StaffLastName
        FROM    ClinicalInformationReconciliation a
                JOIN dbo.DocumentVersions b ON b.DocumentVersionId = a.DocumentVersionId
                JOIN dbo.Documents c ON c.DocumentId = b.DocumentId
                JOIN dbo.Clients d ON d.ClientId = c.ClientId
                JOIN dbo.Staff e ON e.StaffId = b.AuthorId
        WHERE   a.DocumentVersionId = @DocumentVersionId
                AND ISNULL(a.RecordDeleted, 'N') = 'N'
                AND ISNULL(b.RecordDeleted, 'N') = 'N'
                AND ISNULL(c.RecordDeleted, 'N') = 'N'
                AND ISNULL(d.RecordDeleted, 'N') = 'N'
                AND ISNULL(e.RecordDeleted, 'N') = 'N'

    END


GO


