/****** Object:  StoredProcedure [dbo].[ssp_SCGetInpatientCodingDiagnosisLists]    Script Date: 09/16/2015 12:09:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[ssp_SCGetInpatientCodingDiagnosisLists]
    @ClientId INT ,
    @effectiveDate VARCHAR(10) ,
    @DocumentVersionId INT
AS /*********************************************************************
/* Stored Procedure: [ssp_SCGetInpatientCodingDiagnosisLists]             */
/* Date              Author                  Purpose                 */
/* 4/17/2015         Hemant kumar            what:This sp will call on Refresh button click why:Inpatient Coding Document #228*/
/*********************************************************************/
/**  Change History **/
/********************************************************************************/
/**  Date:      Author:     Description: **/
	 7/15/2015	NJain		Added Axis 3 initialization   
	 9/16/2015	NJain		Updated ICD10 join to join on ICD10CodeId instead of ICD10Code
	 11/3/2015  NJain		Removed ICD9 code initialization
**  --------  --------    ------------------------------------------- */
    BEGIN
        BEGIN TRY
            DECLARE @effectivedatepara DATETIME

            SET @effectivedatepara = ( SELECT   CONVERT(DATETIME, @effectiveDate)
                                     )

            DECLARE @DiagnosisDocumentCodeID INT
            DECLARE @CurDiagnosisDocumentCodeID INT
            DECLARE @LatestDiagnosisDocumentVersionId INT
            DECLARE @LatestInpatientCodingDiagnosisListDocumentVersionId INT
            DECLARE @ICD9effectiveDate DATETIME
            DECLARE @ICD10effectiveDate DATETIME
            DECLARE @LatestICD9DocumentVersionID INT
            DECLARE @InpatientCodingDiagnosisListId INT
            DECLARE @LatestICD10DocumentVersionID INT

            CREATE TABLE #tempInpatientCodingDiagnosisList
                (
                  TableName VARCHAR(250) ,
                  InpatientCodingDiagnosisId INT ,
                  CreatedBy VARCHAR(30) ,
                  CreatedDate DATETIME ,
                  ModifiedBy VARCHAR(30) ,
                  ModifiedDate DATETIME ,
                  RecordDeleted VARCHAR(1) ,
                  DeletedDate DATETIME ,
                  DeletedBy VARCHAR(30) ,
                  DocumentVersionId INT ,
                  ICD10CodeId INT ,
                  SNOMEDCODE VARCHAR(20) ,
                  ICD9Code VARCHAR(20) ,
                  DiagnosisType INT ,
                  RuleOut VARCHAR(1) ,
                  DiagnosisOrder INT ,
                  OnAdmit INT ,
                  DSMDescription VARCHAR(MAX) ,
                  DiagnosisTypeText VARCHAR(250) ,
                  DSMCode CHAR(6) ,
                  DSMNumber INT ,
                  ICD10Code VARCHAR(20)
                )

            SET @LatestInpatientCodingDiagnosisListDocumentVersionId = @DocumentVersionId

            IF ( @LatestInpatientCodingDiagnosisListDocumentVersionId > 0 )
                BEGIN
                    DELETE  FROM InpatientCodingDiagnoses
                    WHERE   DocumentVersionId = @LatestInpatientCodingDiagnosisListDocumentVersionId
                END

            SET @ICD9effectiveDate = ( SELECT TOP 1
                                                a.ModifiedDate
                                       FROM     Documents AS a
                                                INNER JOIN DocumentCodes AS Dc ON Dc.DocumentCodeId = a.DocumentCodeId
                                                INNER JOIN DiagnosesIII AS DIII ON a.CurrentDocumentVersionId = DIII.DocumentVersionId
                                       WHERE    a.ClientId = @ClientId
                                                AND a.STATUS = 22
                                                AND Dc.DiagnosisDocument = 'Y'
                                                AND ISNULL(a.RecordDeleted, 'N') <> 'Y'
                                                AND ISNULL(Dc.RecordDeleted, 'N') <> 'Y'
                                       ORDER BY a.EffectiveDate DESC ,
                                                a.ModifiedDate DESC
                                     )
            SET @ICD10effectiveDate = ( SELECT TOP 1
                                                a.ModifiedDate
                                        FROM    Documents AS a
                                                INNER JOIN DocumentCodes AS Dc ON Dc.DocumentCodeId = a.DocumentCodeId
                                                INNER JOIN DocumentDiagnosisCodes AS DDC ON a.CurrentDocumentVersionId = DDC.DocumentVersionId
                                        WHERE   a.ClientId = @ClientId
                                                AND a.STATUS = 22
                                                AND Dc.DiagnosisDocument = 'Y'
                                                AND ISNULL(a.RecordDeleted, 'N') <> 'Y'
                                                AND ISNULL(Dc.RecordDeleted, 'N') <> 'Y'
                                        ORDER BY a.EffectiveDate DESC ,
                                                a.ModifiedDate DESC
                                      )

            IF ( @ICD9effectiveDate IS NULL )
                BEGIN
                    SET @LatestICD10DocumentVersionID = ( SELECT TOP 1
                                                                    a.CurrentDocumentVersionId
                                                          FROM      Documents AS a
                                                                    INNER JOIN DocumentCodes AS Dc ON Dc.DocumentCodeId = a.DocumentCodeId
                                                                    INNER JOIN DocumentDiagnosisCodes AS DDC ON a.CurrentDocumentVersionId = DDC.DocumentVersionId
                                                          WHERE     a.ClientId = @ClientId
                                                                    AND CAST(a.EffectiveDate AS DATE) <= CAST(@effectivedatepara AS DATE)
                                                                    AND a.STATUS = 22
                                                                    AND Dc.DiagnosisDocument = 'Y'
                                                                    AND ISNULL(a.RecordDeleted, 'N') <> 'Y'
                                                                    AND ISNULL(Dc.RecordDeleted, 'N') <> 'Y'
                                                          ORDER BY  a.EffectiveDate DESC ,
                                                                    a.ModifiedDate DESC
                                                        )

                    IF @LatestICD10DocumentVersionID IS NOT NULL
                        BEGIN
                            INSERT  INTO #tempInpatientCodingDiagnosisList
                                    ( TableName ,
                                      InpatientCodingDiagnosisId ,
                                      DocumentVersionId ,
                                      ICD9Code ,
                                      DiagnosisType ,
                                      RuleOut ,
                                      CreatedBy ,
                                      CreatedDate ,
                                      ModifiedBy ,
                                      ModifiedDate ,
                                      RecordDeleted ,
                                      DeletedDate ,
                                      DeletedBy ,
                                      DSMDescription ,
                                      DiagnosisTypeText ,
                                      ICD10CodeId ,
                                      OnAdmit ,
                                      DiagnosisOrder ,
                                      ICD10Code ,
                                      SNOMEDCODE
					                )
                                    SELECT  Placeholder.TableName ,
                                            ( -1 * ROW_NUMBER() OVER ( ORDER BY DDC.ICD9Code ) ) AS InpatientCodingDiagnosisId ,
                                            -1 AS DocumentVersionId ,
                                            DDC.ICD9Code ,
                                            DDC.DiagnosisType ,
                                            DDC.RuleOut ,
                                            DDC.CreatedBy ,
                                            DDC.CreatedDate ,
                                            DDC.ModifiedBy ,
                                            DDC.ModifiedDate ,
                                            DDC.RecordDeleted ,
                                            DDC.DeletedDate ,
                                            DDC.DeletedBy ,
                                            ICD10.ICDDescription AS DSMDescription ,
                                            dbo.csf_GetGlobalCodeNameById(DDC.DiagnosisType) AS 'DiagnosisTypeText' ,
                                            ICD10.ICD10CodeId ,
                                            -1 AS 'OnAdmit' ,
                                            DiagnosisOrder ,
                                            DDC.ICD10Code ,
                                            DDC.SNOMEDCODE
                                    FROM    ( SELECT    'InpatientCodingDiagnoses' AS TableName
                                            ) AS Placeholder
                                            LEFT JOIN DocumentDiagnosisCodes DDC ON ( DDC.DocumentVersionId = @LatestICD10DocumentVersionID
                                                                                      AND ISNULL(DDC.RecordDeleted, 'N') <> 'Y'
                                                                                    )
                                            INNER JOIN DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = DDC.ICD10CodeId
                                            LEFT JOIN SNOMEDCTCodes SNC ON SNC.SNOMEDCTCode = DDC.SNOMEDCODE

                            SELECT  *
                            FROM    #tempInpatientCodingDiagnosisList
                        END
                END
            ELSE
                IF ( @ICD10effectiveDate IS NULL )
                    BEGIN
                        SET @InpatientCodingDiagnosisListId = -1
                        SET @LatestICD9DocumentVersionID = ( SELECT TOP 1
                                                                    a.CurrentDocumentVersionId
                                                             FROM   Documents AS a
                                                                    INNER JOIN DocumentCodes AS Dc ON Dc.DocumentCodeId = a.DocumentCodeId
                                                                    INNER JOIN DiagnosesIII AS DIII ON a.CurrentDocumentVersionId = DIII.DocumentVersionId
                                                             WHERE  a.ClientId = @ClientID
                                                                    AND CAST(a.EffectiveDate AS DATE) <= CAST(@effectivedatepara AS DATE)
                                                                    AND a.STATUS = 22
                                                                    AND Dc.DiagnosisDocument = 'Y'
                                                                    AND ISNULL(a.RecordDeleted, 'N') <> 'Y'
                                                                    AND ISNULL(Dc.RecordDeleted, 'N') <> 'Y'
                                                             ORDER BY a.EffectiveDate DESC ,
                                                                    a.ModifiedDate DESC
                                                           )
						
						SELECT @LatestICD9DocumentVersionID = -1
						
                        INSERT  INTO #tempInpatientCodingDiagnosisList
                                ( TableName ,
                                  DocumentVersionId ,
                                  ICD9Code ,
                                  DiagnosisType ,
                                  RuleOut ,
                                  CreatedBy ,
                                  CreatedDate ,
                                  ModifiedBy ,
                                  ModifiedDate ,
                                  RecordDeleted ,
                                  DeletedDate ,
                                  DeletedBy ,
                                  DSMDescription ,
                                  DiagnosisTypeText ,
                                  DSMCode ,
                                  DSMNumber ,
                                  OnAdmit ,
                                  DiagnosisOrder ,
                                  InpatientCodingDiagnosisId
				                )
			--SELECT  Placeholder.TableName ,
			--        ( -1 * ROW_NUMBER() OVER ( ORDER BY DIandII.DSMCode ) ) AS InpatientCodingDiagnosisId ,
			--        -1 AS DocumentVersionId ,
			--        DIandII.DSMCode AS ICD9Code ,
			--        DIandII.DiagnosisType ,
			--        DIandII.RuleOut ,
			--        DIandII.CreatedBy ,
			--        DIandII.CreatedDate ,
			--        DIandII.ModifiedBy ,
			--        DIandII.ModifiedDate ,
			--        DIandII.RecordDeleted ,
			--        DIandII.DeletedDate ,
			--        DIandII.DeletedBy ,
			--        DSM.DSMDescription ,
			--        gc.CodeName AS 'DiagnosisTypeText' ,
			--        DSM.DSMCode ,
			--        DSM.DSMNumber ,
			--        -1 AS 'OnAdmit' ,
			--        -1 AS 'DiagnosisOrder'
			--FROM    ( SELECT    'InpatientCodingDiagnoses' AS TableName
			--        ) AS Placeholder
			--        LEFT JOIN DiagnosesIAndII DIandII ON ( DIandII.DocumentVersionId = @LatestICD9DocumentVersionID
			--                                               AND ISNULL(DIandII.RecordDeleted, 'N') <> 'Y'
			--                                             )
			--        LEFT JOIN globalcodes gc ON DIandII.DiagnosisType = gc.globalcodeid
			--        INNER JOIN DiagnosisDSMDescriptions DSM ON ( DSM.DSMCode = DIandII.DSMCode
			--                                                     AND DSM.DSMNumber = DIandII.DSMNumber
			--                                                   )
			--UNION
			--SELECT  Placeholder.TableName ,
			--        -1 AS InpatientCodingDiagnosisId ,
			--        -1 AS DocumentVersionId ,
			--        DIIICodes.ICDCode AS ICD9Code ,
			--        '' AS DiagnosisType ,
			--        'N' AS RuleOut ,
			--        DIIICodes.CreatedBy ,
			--        DIIICodes.CreatedDate ,
			--        DIIICodes.ModifiedBy ,
			--        DIIICodes.ModifiedDate ,
			--        DIIICodes.RecordDeleted ,
			--        DIIICodes.DeletedDate ,
			--        DIIICodes.DeletedBy ,
			--        ICD.ICDDescription AS DSMDescription ,
			--        '' AS 'DiagnosisTypeText' ,
			--        DIIICodes.ICDCode AS DSMCode ,
			--        NULL AS 'DSMNumber' ,
			--        -1 AS 'OnAdmit' ,
			--        -1 AS 'DiagnosisOrder'
			--FROM    ( SELECT    'InpatientCodingDiagnoses' AS TableName
			--        ) AS Placeholder
			--        LEFT JOIN dbo.DiagnosesIII DIII ON ( DIII.DocumentVersionId = @LatestICD9DocumentVersionID
			--                                             AND ISNULL(DIII.RecordDeleted, 'N') <> 'Y'
			--                                           )
			--        LEFT JOIN dbo.DiagnosesIIICodes DIIICodes ON ( DIIICodes.DocumentVersionId = @LatestICD9DocumentVersionID
			--                                                       AND ISNULL(DIIICodes.RecordDeleted, 'N') <> 'Y'
			--                                                     )
			--        LEFT JOIN dbo.DiagnosisICDCodes ICD ON ICD.ICDCode = DIIICodes.ICDCode                                                                                   
                                SELECT  * ,
                                        ( -1 * ROW_NUMBER() OVER ( ORDER BY ICD9Code ) ) AS InpatientCodingDiagnosisId
                                FROM    ( SELECT    Placeholder.TableName ,
					--ROW_NUM as InpatientCodingDiagnosisId ,
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
                                                    DSM.DSMCode ,
                                                    DSM.DSMNumber ,
                                                    -1 AS 'OnAdmit' ,
                                                    DiagnosisOrder
                                          FROM      ( SELECT    'InpatientCodingDiagnoses' AS TableName
                                                    ) AS Placeholder
                                                    LEFT JOIN DiagnosesIAndII DIandII ON ( DIandII.DocumentVersionId = @LatestICD9DocumentVersionID
                                                                                           AND ISNULL(DIandII.RecordDeleted, 'N') <> 'Y'
                                                                                         )
                                                    LEFT JOIN globalcodes gc ON DIandII.DiagnosisType = gc.globalcodeid
                                                    INNER JOIN DiagnosisDSMDescriptions DSM ON ( DSM.DSMCode = DIandII.DSMCode
                                                                                                 AND DSM.DSMNumber = DIandII.DSMNumber
                                                                                               )
                                          UNION
                                          SELECT    Placeholder.TableName ,
					---1 AS InpatientCodingDiagnosisId ,
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
                                                    DIIICodes.ICDCode AS DSMCode ,
                                                    NULL AS 'DSMNumber' ,
                                                    -1 AS 'OnAdmit' ,
                                                    -1 AS 'DiagnosisOrder'
                                          FROM      ( SELECT    'InpatientCodingDiagnoses' AS TableName
                                                    ) AS Placeholder
                                                    LEFT JOIN dbo.DiagnosesIII DIII ON ( DIII.DocumentVersionId = @LatestICD9DocumentVersionID
                                                                                         AND ISNULL(DIII.RecordDeleted, 'N') <> 'Y'
                                                                                       )
                                                    LEFT JOIN dbo.DiagnosesIIICodes DIIICodes ON ( DIIICodes.DocumentVersionId = @LatestICD9DocumentVersionID
                                                                                                   AND ISNULL(DIIICodes.RecordDeleted, 'N') <> 'Y'
                                                                                                 )
                                                    LEFT JOIN dbo.DiagnosisICDCodes ICD ON ICD.ICDCode = DIIICodes.ICDCode
                                        ) a
                                ORDER BY ICD9Code ASC

                        SELECT  *
                        FROM    #tempInpatientCodingDiagnosisList
                    END
                ELSE
                    IF ( @ICD9effectiveDate > @ICD10effectiveDate )
                        BEGIN
                            SET @InpatientCodingDiagnosisListId = -1
                            SET @LatestICD9DocumentVersionID = ( SELECT TOP 1
                                                                        a.CurrentDocumentVersionId
                                                                 FROM   Documents AS a
                                                                        INNER JOIN DocumentCodes AS Dc ON Dc.DocumentCodeId = a.DocumentCodeId
                                                                        INNER JOIN DiagnosesIII AS DIII ON a.CurrentDocumentVersionId = DIII.DocumentVersionId
                                                                 WHERE  a.ClientId = @ClientID
                                                                        AND CAST(a.EffectiveDate AS DATE) <= CAST(@effectivedatepara AS DATE)
                                                                        AND a.STATUS = 22
                                                                        AND Dc.DiagnosisDocument = 'Y'
                                                                        AND ISNULL(a.RecordDeleted, 'N') <> 'Y'
                                                                        AND ISNULL(Dc.RecordDeleted, 'N') <> 'Y'
                                                                 ORDER BY a.EffectiveDate DESC ,
                                                                        a.ModifiedDate DESC
                                                               )
							
							SELECT @LatestICD9DocumentVersionID = -1
							
                            INSERT  INTO #tempInpatientCodingDiagnosisList
                                    ( TableName ,
                                      DocumentVersionId ,
                                      ICD9Code ,
                                      DiagnosisType ,
                                      RuleOut ,
                                      CreatedBy ,
                                      CreatedDate ,
                                      ModifiedBy ,
                                      ModifiedDate ,
                                      RecordDeleted ,
                                      DeletedDate ,
                                      DeletedBy ,
                                      DSMDescription ,
                                      DiagnosisTypeText ,
                                      DSMCode ,
                                      DSMNumber ,
                                      OnAdmit ,
                                      DiagnosisOrder ,
                                      InpatientCodingDiagnosisId
				                    )
			--SELECT  Placeholder.TableName ,
			--        ( -1 * ROW_NUMBER() OVER ( ORDER BY DIandII.DSMCode ) ) AS InpatientCodingDiagnosisId ,
			--        -1 AS DocumentVersionId ,
			--        DIandII.DSMCode AS ICD9Code ,
			--        DIandII.DiagnosisType ,
			--        DIandII.RuleOut ,
			--        DIandII.CreatedBy ,
			--        DIandII.CreatedDate ,
			--        DIandII.ModifiedBy ,
			--        DIandII.ModifiedDate ,
			--        DIandII.RecordDeleted ,
			--        DIandII.DeletedDate ,
			--        DIandII.DeletedBy ,
			--        DSM.DSMDescription ,
			--        gc.CodeName AS 'DiagnosisTypeText' ,
			--        DSM.DSMCode ,
			--        DSM.DSMNumber ,
			--        -1 AS 'OnAdmit' ,
			--        -1 AS 'DiagnosisOrder'
			--FROM    ( SELECT    'InpatientCodingDiagnoses' AS TableName
			--        ) AS Placeholder
			--        LEFT JOIN DiagnosesIAndII DIandII ON ( DIandII.DocumentVersionId = @LatestICD9DocumentVersionID
			--                                               AND ISNULL(DIandII.RecordDeleted, 'N') <> 'Y'
			--                                             )
			--        LEFT JOIN globalcodes gc ON DIandII.DiagnosisType = gc.globalcodeid
			--        INNER JOIN DiagnosisDSMDescriptions DSM ON ( DSM.DSMCode = DIandII.DSMCode
			--                                                     AND DSM.DSMNumber = DIandII.DSMNumber
			--                                                   )
			--UNION
			--SELECT  Placeholder.TableName ,
			--        -1 AS InpatientCodingDiagnosisId ,
			--        -1 AS DocumentVersionId ,
			--        DIIICodes.ICDCode AS ICD9Code ,
			--        '' AS DiagnosisType ,
			--        'N' AS RuleOut ,
			--        DIIICodes.CreatedBy ,
			--        DIIICodes.CreatedDate ,
			--        DIIICodes.ModifiedBy ,
			--        DIIICodes.ModifiedDate ,
			--        DIIICodes.RecordDeleted ,
			--        DIIICodes.DeletedDate ,
			--        DIIICodes.DeletedBy ,
			--        ICD.ICDDescription AS DSMDescription ,
			--        '' AS 'DiagnosisTypeText' ,
			--        DIIICodes.ICDCode AS DSMCode ,
			--        NULL AS 'DSMNumber' ,
			--        -1 AS 'OnAdmit' ,
			--        -1 AS 'DiagnosisOrder'
			--FROM    ( SELECT    'InpatientCodingDiagnoses' AS TableName
			--        ) AS Placeholder
			--        LEFT JOIN dbo.DiagnosesIII DIII ON ( DIII.DocumentVersionId = @LatestICD9DocumentVersionID
			--                                             AND ISNULL(DIII.RecordDeleted, 'N') <> 'Y'
			--                                           )
			--        LEFT JOIN dbo.DiagnosesIIICodes DIIICodes ON ( DIIICodes.DocumentVersionId = @LatestICD9DocumentVersionID
			--                                                       AND ISNULL(DIIICodes.RecordDeleted, 'N') <> 'Y'
			--                                                     )
			--        LEFT JOIN dbo.DiagnosisICDCodes ICD ON ICD.ICDCode = DIIICodes.ICDCode      
                                    SELECT  * ,
                                            ( -1 * ROW_NUMBER() OVER ( ORDER BY ICD9Code ) ) AS InpatientCodingDiagnosisId
                                    FROM    ( SELECT    Placeholder.TableName ,
					--ROW_NUM as InpatientCodingDiagnosisId ,
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
                                                        DSM.DSMCode ,
                                                        DSM.DSMNumber ,
                                                        -1 AS 'OnAdmit' ,
                                                        DiagnosisOrder
                                              FROM      ( SELECT    'InpatientCodingDiagnoses' AS TableName
                                                        ) AS Placeholder
                                                        LEFT JOIN DiagnosesIAndII DIandII ON ( DIandII.DocumentVersionId = @LatestICD9DocumentVersionID
                                                                                               AND ISNULL(DIandII.RecordDeleted, 'N') <> 'Y'
                                                                                             )
                                                        LEFT JOIN globalcodes gc ON DIandII.DiagnosisType = gc.globalcodeid
                                                        INNER JOIN DiagnosisDSMDescriptions DSM ON ( DSM.DSMCode = DIandII.DSMCode
                                                                                                     AND DSM.DSMNumber = DIandII.DSMNumber
                                                                                                   )
                                              UNION
                                              SELECT    Placeholder.TableName ,
					---1 AS InpatientCodingDiagnosisId ,
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
                                                        DIIICodes.ICDCode AS DSMCode ,
                                                        NULL AS 'DSMNumber' ,
                                                        -1 AS 'OnAdmit' ,
                                                        -1 AS 'DiagnosisOrder'
                                              FROM      ( SELECT    'InpatientCodingDiagnoses' AS TableName
                                                        ) AS Placeholder
                                                        LEFT JOIN dbo.DiagnosesIII DIII ON ( DIII.DocumentVersionId = @LatestICD9DocumentVersionID
                                                                                             AND ISNULL(DIII.RecordDeleted, 'N') <> 'Y'
                                                                                           )
                                                        LEFT JOIN dbo.DiagnosesIIICodes DIIICodes ON ( DIIICodes.DocumentVersionId = @LatestICD9DocumentVersionID
                                                                                                       AND ISNULL(DIIICodes.RecordDeleted, 'N') <> 'Y'
                                                                                                     )
                                                        LEFT JOIN dbo.DiagnosisICDCodes ICD ON ICD.ICDCode = DIIICodes.ICDCode
                                            ) a
                                    ORDER BY ICD9Code ASC

                            SELECT  *
                            FROM    #tempInpatientCodingDiagnosisList
                        END
                    ELSE
                        BEGIN
                            SET @LatestICD10DocumentVersionID = ( SELECT TOP 1
                                                                            a.CurrentDocumentVersionId
                                                                  FROM      Documents AS a
                                                                            INNER JOIN DocumentCodes AS Dc ON Dc.DocumentCodeId = a.DocumentCodeId
                                                                            INNER JOIN DocumentDiagnosisCodes AS DDC ON a.CurrentDocumentVersionId = DDC.DocumentVersionId
                                                                  WHERE     a.ClientId = @ClientId
                                                                            AND CAST(a.EffectiveDate AS DATE) <= CAST(@effectivedatepara AS DATE)
                                                                            AND a.STATUS = 22
                                                                            AND Dc.DiagnosisDocument = 'Y'
                                                                            AND ISNULL(a.RecordDeleted, 'N') <> 'Y'
                                                                            AND ISNULL(Dc.RecordDeleted, 'N') <> 'Y'
                                                                  ORDER BY  a.EffectiveDate DESC ,
                                                                            a.ModifiedDate DESC
                                                                )

                            IF @LatestICD10DocumentVersionID IS NOT NULL
                                BEGIN
                                    INSERT  INTO #tempInpatientCodingDiagnosisList
                                            ( TableName ,
                                              InpatientCodingDiagnosisId ,
                                              DocumentVersionId ,
                                              ICD9Code ,
                                              DiagnosisType ,
                                              RuleOut ,
                                              CreatedBy ,
                                              CreatedDate ,
                                              ModifiedBy ,
                                              ModifiedDate ,
                                              RecordDeleted ,
                                              DeletedDate ,
                                              DeletedBy ,
                                              DSMDescription ,
                                              DiagnosisTypeText ,
                                              ICD10CodeId ,
                                              OnAdmit ,
                                              DiagnosisOrder ,
                                              ICD10Code ,
                                              SNOMEDCODE
					                        )
                                            SELECT  Placeholder.TableName ,
                                                    ( -1 * ROW_NUMBER() OVER ( ORDER BY DDC.ICD9Code ) ) AS InpatientCodingDiagnosisId ,
                                                    -1 AS DocumentVersionId ,
                                                    DDC.ICD9Code ,
                                                    DDC.DiagnosisType ,
                                                    DDC.RuleOut ,
                                                    DDC.CreatedBy ,
                                                    DDC.CreatedDate ,
                                                    DDC.ModifiedBy ,
                                                    DDC.ModifiedDate ,
                                                    DDC.RecordDeleted ,
                                                    DDC.DeletedDate ,
                                                    DDC.DeletedBy ,
                                                    ICD10.ICDDescription AS DSMDescription ,
                                                    dbo.csf_GetGlobalCodeNameById(DDC.DiagnosisType) AS 'DiagnosisTypeText' ,
                                                    ICD10.ICD10CodeId ,
                                                    -1 AS 'OnAdmit' ,
                                                    DiagnosisOrder ,
                                                    DDC.ICD10Code ,
                                                    DDC.SNOMEDCODE
                                            FROM    ( SELECT    'InpatientCodingDiagnoses' AS TableName
                                                    ) AS Placeholder
                                                    LEFT JOIN DocumentDiagnosisCodes DDC ON ( DDC.DocumentVersionId = @LatestICD10DocumentVersionID
                                                                                              AND ISNULL(DDC.RecordDeleted, 'N') <> 'Y'
                                                                                            )
                                                    INNER JOIN DiagnosisICD10Codes ICD10 ON ICD10.ICD10Code = DDC.ICD10Code
                                                    LEFT JOIN SNOMEDCTCodes SNC ON SNC.SNOMEDCTCode = DDC.SNOMEDCODE

                                    SELECT  *
                                    FROM    #tempInpatientCodingDiagnosisList
                                END
                        END
        END TRY

        BEGIN CATCH
            DECLARE @Error VARCHAR(8000)

            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetInpatientCodingDiagnosisLists') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

            RAISERROR (
				@Error
				,-- Message text.                                                                            
				16
				,-- Severity.                                                                            
				1 -- State.                                                                            
				);
        END CATCH
    END

GO
