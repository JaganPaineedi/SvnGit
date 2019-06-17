IF EXISTS ( SELECT  *
            FROM    sys.procedures
            WHERE   name = 'SSP_SCGETRDLINPATIENTCODINGDOCUMENT' )
    DROP PROCEDURE SSP_SCGETRDLINPATIENTCODINGDOCUMENT
GO



SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [DBO].[SSP_SCGETRDLINPATIENTCODINGDOCUMENT]
    (
      @DOCUMENTVERSIONID AS INT
    )
AS /*********************************************************************/
/* Stored Procedure: [ssp_SCGetRDLInpatientCodingDocument]             */
/* Date              Author                  Purpose                 */
/* 4/17/2015         Hemant kumar            what:To get the Inpatient data why:Inpatient Coding Document #228                         */
/*********************************************************************/
/**  Change History **/                                                                         
/********************************************************************************/                                                                           
/**  Date:			Author:			Description: **/                         
/*   09/02/2015     Chethan N       What : Added New column AttendingPhysicianId
									Why : Philhaven Development task# 338 */     
/*	 06/07/2017		NJain			Modified to only get discharge date if the client is discharge as of the signature date. Philhaven Support 179.1 */	 										                                
/**  --------  --------    ------------------------------------------- */  

    BEGIN
        BEGIN TRY
            DECLARE @ClientId INT
            DECLARE @OrganizationName VARCHAR(250)
            DECLARE @DocumentName VARCHAR(100)
            DECLARE @ClientName VARCHAR(100)
            DECLARE @EffectiveDate VARCHAR(10)
            DECLARE @DOB VARCHAR(10)
            DECLARE @ClientInpatientVisit VARCHAR(MAX)
            DECLARE @InpatientVisit INT
            DECLARE @ClientAdmitDate VARCHAR(10)
            DECLARE @DischargedDate VARCHAR(10)
            DECLARE @status VARCHAR(50)
            DECLARE @SignatureDate DATETIME

            SELECT  @ClientId = ClientId
            FROM    documents
            WHERE   InProgressDocumentVersionId = @DocumentVersionId

            SELECT TOP 1
                    @OrganizationName = OrganizationName
            FROM    SystemConfigurations

            SELECT  @ClientName = C.LastName + ', ' + C.FirstName ,
                    @EffectiveDate = CASE WHEN Documents.EffectiveDate IS NOT NULL THEN CONVERT(VARCHAR(10), Documents.EffectiveDate, 101)
                                          ELSE ''
                                     END ,
                    @DOB = CASE WHEN C.DOB IS NOT NULL THEN CONVERT(VARCHAR(10), C.DOB, 101)
                                ELSE ''
                           END
            FROM    Documents
                    INNER JOIN Staff S ON Documents.AuthorId = S.StaffId
                    INNER JOIN Clients C ON Documents.ClientId = C.ClientId
                                            AND ISNULL(C.RecordDeleted, 'N') <> 'Y'
                    INNER JOIN DocumentVersions dv ON dv.DocumentId = documents.DocumentId
                    INNER JOIN DocumentCodes ON DocumentCodes.DocumentCodeid = Documents.DocumentCodeId
                                                AND ISNULL(DocumentCodes.RecordDeleted, 'N') = 'N'
                    LEFT JOIN GlobalCodes GC ON S.Degree = GC.GlobalCodeId
            WHERE   dv.DocumentVersionId = @DocumentVersionId
                    AND ISNULL(Documents.RecordDeleted, 'N') = 'N'

            SELECT  @DocumentName = DocumentCodes.DocumentName
            FROM    Documents
                    INNER JOIN Staff S ON Documents.AuthorId = S.StaffId
                    INNER JOIN Clients C ON Documents.ClientId = C.ClientId
                                            AND ISNULL(C.RecordDeleted, 'N') <> 'Y'
                    INNER JOIN DocumentVersions dv ON dv.DocumentId = documents.DocumentId
                    INNER JOIN DocumentCodes ON DocumentCodes.DocumentCodeid = Documents.DocumentCodeId
                                                AND ISNULL(DocumentCodes.RecordDeleted, 'N') = 'N'
                    LEFT JOIN GlobalCodes GC ON S.Degree = GC.GlobalCodeId
            WHERE   dv.DocumentVersionId = @DocumentVersionId
                    AND ISNULL(Documents.RecordDeleted, 'N') = 'N'
			
			
            SELECT  @SignatureDate = b.SignatureDate
            FROM    dbo.Documents a
                    JOIN dbo.DocumentSignatures b ON b.DocumentId = a.DocumentId
            WHERE   a.Status = 22
                    AND b.SignatureOrder = 1
                    AND b.SignatureDate IS NOT NULL
                    AND a.CurrentDocumentVersionId = @DOCUMENTVERSIONID
                    AND ISNULL(b.RecordDeleted, 'N') = 'N'
			
			
            SET @InpatientVisit = ( SELECT  ClientInpatientVisitId
                                    FROM    InpatientCodingDocuments
                                    WHERE   documentversionid = @DocumentVersionId
                                  )
            SET @ClientInpatientVisit = ( SELECT    ( ISNULL(CONVERT(VARCHAR(12), AdmitDate, 101), '') + CASE WHEN CONVERT(VARCHAR(12), AdmitDate, 101) <> '' THEN '  -  '
                                                                                                              ELSE ''
                                                                                                         END + ISNULL(CONVERT(VARCHAR(12), DischargedDate, 101), '') + CASE WHEN CONVERT(VARCHAR(12), DischargedDate, 101) <> '' THEN '  -  '
                                                                                                                                                                            ELSE ''
                                                                                                                                                                       END + ISNULL(CONVERT(VARCHAR(12), G.CodeName, 101), '') ) AS Inpatientvisits
                                          FROM      ClientInpatientVisits CIV
                                                    LEFT JOIN GlobalCodes G ON CIV.[Status] = G.GlobalCodeId
                                          WHERE     ClientId = @ClientId
                                                    AND ClientInpatientVisitId = @InpatientVisit
                                                    AND ISNULL(CIV.RecordDeleted, 'N') <> 'Y'
                                        )
            SET @ClientAdmitDate = ( SELECT ISNULL(CONVERT(VARCHAR(12), AdmitDate, 101), '')
                                     FROM   ClientInpatientVisits CIV
                                     WHERE  ClientId = @ClientId
                                            AND ClientInpatientVisitId = @InpatientVisit
                                            AND ISNULL(CIV.RecordDeleted, 'N') <> 'Y'
                                   )
            SET @DischargedDate = ( SELECT  ( ISNULL(CONVERT(VARCHAR(12), DischargedDate, 101), '') )
                                    FROM    ClientInpatientVisits CIV
                                    WHERE   ClientId = @ClientId
                                            AND ClientInpatientVisitId = @InpatientVisit
                                            AND ISNULL(CIV.RecordDeleted, 'N') <> 'Y'
                                            AND DATEDIFF(dd, civ.DischargedDate, ISNULL(@SignatureDate, @EffectiveDate)) >= 0
                                  )
            SET @status = ( SELECT  ISNULL(CONVERT(VARCHAR(12), G.CodeName, 101), '')
                            FROM    ClientInpatientVisits CIV
                                    LEFT JOIN GlobalCodes G ON CIV.[Status] = G.GlobalCodeId
                            WHERE   ClientId = @ClientId
                                    AND ClientInpatientVisitId = @InpatientVisit
                                    AND ISNULL(CIV.RecordDeleted, 'N') <> 'Y'
                          )
			
            SET @ClientInpatientVisit = CONVERT(VARCHAR, @ClientAdmitDate, 101) + ' - ' + ISNULL(CONVERT(VARCHAR, @DischargedDate, 101), '')
			
			
            SELECT  DocumentVersionId ,
                    ICD.CreatedBy ,
                    ICD.CreatedDate ,
                    ICD.ModifiedBy ,
                    ICD.ModifiedDate ,
                    ICD.RecordDeleted ,
                    ICD.DeletedBy ,
                    ICD.DeletedDate ,
                    @ClientId AS ClientId ,
                    @ClientInpatientVisit AS ClientInpatientVisit ,
                    dbo.ssf_GetGlobalCodeNameById(ICD.[AdmitType]) AS AdmitType ,
                    dbo.ssf_GetGlobalCodeNameById(ICD.[AdmissionSource]) AS AdmissionSource ,
                    dbo.ssf_GetGlobalCodeNameById(ICD.[DischargeType]) AS DischargeType ,
                    @OrganizationName AS OrganizationName ,
                    @DocumentName AS DocumentName ,
                    @ClientName AS ClientName ,
                    @EffectiveDate AS EffectiveDate ,
                    @DOB AS DOB ,
                    ICD.DRG ,
                    @ClientAdmitDate AS AdmitDate ,
                    @DischargedDate AS DischageDate ,
                    CASE WHEN @DischargedDate IS NOT NULL THEN 'Discharged'
                         ELSE 'Admitted'
                    END AS [status] ,
                    @InpatientVisit AS InpatientVisit ,
                    S.DisplayAs AS AttendingPhysician
            FROM    InpatientCodingDocuments ICD
                    LEFT JOIN Staff S ON S.StaffId = ICD.AttendingPhysicianId
            WHERE   DocumentVersionId = @DocumentVersionId
                    AND ISNULL(ICD.RecordDeleted, 'N') = 'N'
        END TRY

        BEGIN CATCH
            DECLARE @Error VARCHAR(8000)

            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetRDLInpatientCodingDocument') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

            RAISERROR (
				@Error
				,-- Message text.                                                          
				16
				,-- Severity.                                                          
				1 -- State.                                                          
				)
        END CATCH
    END
GO

