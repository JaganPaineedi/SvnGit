/****** Object:  StoredProcedure [dbo].[ssp_SCInitializeInpatientCodingDocument]    Script Date: 11/03/2015 16:21:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[ssp_SCInitializeInpatientCodingDocument]
    (
      @ClientID INT ,
      @StaffID INT ,
      @CustomParameters XML  
    )
AS /***  
/* Stored Procedure: [ssp_SCInitializeInpatientCodingDocument]       */  
/* Date              Author                  Purpose                 */  
/* 4/17/2015         Hemant kumar            what:To Initialize Data why:Inpatient Coding Document #228      */  
/*********************************************************************/  
/**  Change History **/                                                                           
/********************************************************************************/                                                                             
/**  Date:  Author:     Description: **/                  
 7/15/2015 NJain  Added Axis 3 initialization    
 11/3/2015 NJain  Removed ICD9 initialization  
**  --------  --------    ------------------------------------------- */  
    BEGIN  
        BEGIN TRY  
            DECLARE @DiagnosisDocumentCodeID INT  
            DECLARE @CurDiagnosisDocumentCodeID INT  
            DECLARE @LatestDiagnosisDocumentVersionId INT  
  
  -- InpatientCodingDocuments                        
            SELECT TOP 1
                    'InpatientCodingDocuments' AS TableName ,
                    -1 AS 'DocumentVersionId' ,  
                    --'' AS CreatedBy ,  
                    I.[CreatedBy] ,
                    GETDATE() AS CreatedDate ,  
                    --'' AS ModifiedBy ,  
                    I.[ModifiedBy] ,
                    GETDATE() AS ModifiedDate
            FROM    systemconfigurations s
                    LEFT JOIN InpatientCodingDocuments I ON s.Databaseversion = -1  
  
            SET @LatestDiagnosisDocumentVersionId = ( SELECT TOP 1
                                                                CurrentDocumentVersionId
                                                      FROM      Documents a
                                                                INNER JOIN DocumentCodes Dc ON Dc.DocumentCodeid = a.DocumentCodeid
                                                      WHERE     a.ClientId = @ClientID
                                                                AND a.[Status] = 22
                                                                AND Dc.DiagnosisDocument = 'Y'
                                                                AND a.EffectiveDate <= CAST(GETDATE() AS DATE)
                                                                AND ISNULL(a.RecordDeleted, 'N') <> 'Y'
                                                                AND ISNULL(Dc.RecordDeleted, 'N') <> 'Y'
                                                      ORDER BY  a.EffectiveDate DESC ,
                                                                a.ModifiedDate DESC
                                                    )  
            SET @DiagnosisDocumentCodeID = ( SELECT TOP 1
                                                    DocumentCodeId
                                             FROM   Documents
                                             WHERE  CurrentDocumentVersionId = @LatestDiagnosisDocumentVersionId
                                           )  
            SET @CurDiagnosisDocumentCodeID = ( SELECT TOP 1
                                                        DocumentCodeId
                                                FROM    DocumentCodes
                                                WHERE   DocumentCodeId = @DiagnosisDocumentCodeID
                                                        AND DSMV = 'Y'
                                              )  
  
            IF ( @CurDiagnosisDocumentCodeID IS NULL )
                BEGIN  
                    DECLARE @LatestICD9DocumentVersionID INT  
  
                    SET @LatestICD9DocumentVersionID = ( SELECT TOP 1
                                                                a.CurrentDocumentVersionId
                                                         FROM   Documents AS a
                                                                INNER JOIN DocumentCodes AS Dc ON Dc.DocumentCodeId = a.DocumentCodeId
                                                                INNER JOIN dbo.DiagnosesIAndII AS DIII ON a.CurrentDocumentVersionId = DIII.DocumentVersionId
                                                         WHERE  a.ClientId = @ClientID
                                                                AND a.EffectiveDate <= CAST(GETDATE() AS DATE)
                                                                AND a.STATUS = 22
                                                                AND Dc.DiagnosisDocument = 'Y'
                                                                AND ISNULL(a.RecordDeleted, 'N') <> 'Y'
                                                                AND ISNULL(Dc.RecordDeleted, 'N') <> 'Y'
                                                         ORDER BY a.EffectiveDate DESC ,
                                                                a.ModifiedDate DESC
                                                       )  
                    
                    SELECT @LatestICD9DocumentVersionID = -1
                    
                    IF @LatestICD9DocumentVersionID IS NOT NULL
                        BEGIN  
                            SELECT  Placeholder.TableName ,
                                    -1 AS DocumentVersionId ,
                                    DIandII.DSMCode AS ICD9Code ,
                                    DIandII.DiagnosisType ,
                                    DIandII.RuleOut ,
                                    DIandII.CreatedBy ,
                                    DIandII.CreatedDate ,
                                    DIandII.ModifiedBy ,
                                    DIandII.ModifiedDate ,
                                    DIandII.RecordDeleted ,
                                    DIandII.DeletedDate ,
                                    DIandII.DeletedBy ,
                                    DSM.DSMDescription ,
                                    gc.CodeName AS 'DiagnosisTypeText' ,
                                    DSM.DSMNumber AS 'DSMNumber' ,
                                    -1 AS 'OnAdmit' ,
                                    DiagnosisOrder
                            FROM    ( SELECT    'InpatientCodingDiagnoses' AS TableName
                                    ) AS Placeholder
                                    LEFT JOIN DiagnosesIAndII DIandII ON ( DIandII.DocumentVersionId = @LatestICD9DocumentVersionID
                                                                           AND ISNULL(DIandII.RecordDeleted, 'N') <> 'Y'
                                                                         )
                                    LEFT JOIN globalcodes gc ON DIandII.DiagnosisType = gc.globalcodeid
                                    INNER JOIN DiagnosisDSMDescriptions DSM ON ( DSM.DSMCode = DIandII.DSMCode
                                                                                 AND DSM.DSMNumber = DIandII.DSMNumber
                                                                               )
                            UNION
                            SELECT  Placeholder.TableName ,
                                    -1 AS DocumentVersionId ,
                                    DIIICodes.ICDCode AS ICD9Code ,
                                    '' AS DiagnosisType ,
                                    'N' AS RuleOut ,
                                    DIIICodes.CreatedBy ,
                                    DIIICodes.CreatedDate ,
                                    DIIICodes.ModifiedBy ,
                                    DIIICodes.ModifiedDate ,
                                    DIIICodes.RecordDeleted ,
                                    DIIICodes.DeletedDate ,
                                    DIIICodes.DeletedBy ,
                                    ICD.ICDDescription AS DSMDescription ,
                                    '' AS 'DiagnosisTypeText' ,
                                    NULL AS 'DSMNumber' ,
                                    -1 AS 'OnAdmit' ,
                                    -1 AS 'DiagnosisOrder'
                            FROM    ( SELECT    'InpatientCodingDiagnoses' AS TableName
                                    ) AS Placeholder
                                    LEFT JOIN dbo.DiagnosesIII DIII ON ( DIII.DocumentVersionId = @LatestICD9DocumentVersionID
                                                                         AND ISNULL(DIII.RecordDeleted, 'N') <> 'Y'
                                                                       )
                                    LEFT JOIN dbo.DiagnosesIIICodes DIIICodes ON ( DIIICodes.DocumentVersionId = @LatestICD9DocumentVersionID
                                                                                   AND ISNULL(DIIICodes.RecordDeleted, 'N') <> 'Y'
                                                                                 )
                                    LEFT JOIN dbo.DiagnosisICDCodes ICD ON ICD.ICDCode = DIIICodes.ICDCode  
                        END  
                END  
            ELSE
                BEGIN  
                    DECLARE @LatestICD10DocumentVersionID INT  
  
                    SET @LatestICD10DocumentVersionID = ( SELECT TOP 1
                                                                    a.CurrentDocumentVersionId
                                                          FROM      Documents AS a
                                                                    INNER JOIN DocumentCodes AS Dc ON Dc.DocumentCodeId = a.DocumentCodeId
                                                                    INNER JOIN DocumentDiagnosisCodes AS DDC ON a.CurrentDocumentVersionId = DDC.DocumentVersionId
                                                          WHERE     a.ClientId = @ClientId
                                                                    AND a.EffectiveDate <= CAST(GETDATE() AS DATE)
                                                                    AND a.STATUS = 22
                                                                    AND Dc.DiagnosisDocument = 'Y'
                                                                    AND ISNULL(a.RecordDeleted, 'N') <> 'Y'
                                                                    AND ISNULL(Dc.RecordDeleted, 'N') <> 'Y'
                                                          ORDER BY  a.EffectiveDate DESC ,
                                                                    a.ModifiedDate DESC
                                                        )  
  
                    IF @LatestICD10DocumentVersionID IS NOT NULL
                        BEGIN  
                            SELECT  Placeholder.TableName ,
                                    DDC.CreatedBy ,
                                    DDC.CreatedDate ,
                                    DDC.ModifiedBy ,
                                    DDC.ModifiedDate ,
                                    DDC.RecordDeleted ,
                                    DDC.DeletedDate ,
                                    DDC.DeletedBy ,
                                    -1 AS DocumentVersionId ,
                                    DDC.ICD10Code ,
                                    DDC.ICD9Code ,
                                    DDC.DiagnosisType ,
                                    dbo.ssf_GetGlobalCodeNameById(DDC.DiagnosisType) AS 'DiagnosisTypeText' ,
                                    DDC.RuleOut ,
                                    CAST(DDC.ICD10CodeId AS INT) AS ICD10CodeId ,
                                    DDC.SNOMEDCODE ,
                                    ICD10.ICDDescription AS DSMDescription ,
                                    -1 AS 'OnAdmit' ,
                                    DiagnosisOrder
                            FROM    ( SELECT    'InpatientCodingDiagnoses' AS TableName
                                    ) AS Placeholder
                                    LEFT JOIN DocumentDiagnosisCodes DDC ON ( DDC.DocumentVersionId = @LatestICD10DocumentVersionID
                                                                              AND ISNULL(DDC.RecordDeleted, 'N') <> 'Y'
                                                                            )
                                    INNER JOIN DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = DDC.ICD10CodeId
                                    LEFT JOIN SNOMEDCTCodes SNC ON SNC.SNOMEDCTCode = DDC.SNOMEDCODE  
                        END  
                END  
        END TRY  
  
        BEGIN CATCH  
            DECLARE @Error VARCHAR(MAX)  
  
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCInitializeInpatientCodingDocument') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '
*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
            RAISERROR (  
    @Error  
    ,  
    -- Message text.                                                                                   
    16  
    ,  
    -- Severity.                                                                                   
    1  
    -- State.                                                                                   
    );  
        END CATCH  
    END  

GO
