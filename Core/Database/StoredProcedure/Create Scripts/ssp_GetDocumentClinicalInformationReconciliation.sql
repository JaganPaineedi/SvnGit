/****** Object:  StoredProcedure [dbo].[ssp_GetDocumentClinicalInformationReconciliation]    Script Date: 06/09/2015 09:57:35 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetDocumentClinicalInformationReconciliation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetDocumentClinicalInformationReconciliation]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetDocumentClinicalInformationReconciliation]    Script Date: 06/09/2015 09:57:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_GetDocumentClinicalInformationReconciliation]
    (
      @DocumentVersionId INT
    )
AS
    BEGIN

        SELECT  DocumentVersionId ,
                CreatedBy ,
                CreatedDate ,
                ModifiedBy ,
                ModifiedDate ,
                RecordDeleted ,
                DeletedBy ,
                DeletedDate ,
                Medications ,
                Allergies ,
                Diagnoses 
        FROM    ClinicalInformationReconciliation
        WHERE   DocumentVersionId = @DocumentVersionId
                AND ISNULL(RecordDeleted, 'N') = 'N'

    END


GO


