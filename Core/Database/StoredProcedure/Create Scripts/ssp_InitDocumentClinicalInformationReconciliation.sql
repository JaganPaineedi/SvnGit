/****** Object:  StoredProcedure [dbo].[ssp_InitDocumentClinicalInformationReconciliation]    Script Date: 06/09/2015 11:17:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InitDocumentClinicalInformationReconciliation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_InitDocumentClinicalInformationReconciliation]
GO


/****** Object:  StoredProcedure [dbo].[ssp_InitDocumentClinicalInformationReconciliation]    Script Date: 06/09/2015 11:17:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_InitDocumentClinicalInformationReconciliation]
    (
      @ClientId INT ,
      @StaffID INT ,
      @CustomParameters XML   
    )
AS
    BEGIN

        SELECT TOP 1
                'ClinicalInformationReconciliation' AS TableName ,
                -1 AS 'DocumentVersionId' ,
                c.CreatedBy ,
                c.CreatedDate ,
                c.ModifiedBy ,
                c.ModifiedDate ,
                c.RecordDeleted ,
                c.DeletedBy ,
                c.DeletedDate ,
                c.Medications ,
                c.Allergies ,
                c.Diagnoses
        
        from systemconfigurations s left outer join dbo.ClinicalInformationReconciliation C                                                                        
  on s.Databaseversion = -1                                           
    END


GO


