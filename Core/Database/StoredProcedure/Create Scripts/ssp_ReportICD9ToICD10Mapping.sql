IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   name = 'ssp_ReportICD9ToICD10Mapping'
                    AND type = 'P' )
    DROP PROCEDURE ssp_ReportICD9ToICD10Mapping
GO

CREATE PROCEDURE ssp_ReportICD9ToICD10Mapping
    (
      @ICD9DSMCode VARCHAR(6) ,
      @Mapped INT
    )
AS /******************************************************
Name		Date		Description
njain		3/30/2015	Created
njain		8/5/2015	Updated to add '*' when DSMV is checked
******************************************************/
    BEGIN


        IF @Mapped = 0
            BEGIN
                SELECT DISTINCT
                        ICD9.ICDCode AS ICD9Code ,
                        ICD9.ICDDescription AS ICD9Description ,
                        CASE WHEN ISNULL(ICD10.DSMVCode, 'N') = 'Y' THEN ICD10.ICD10Code + '*'
                             ELSE ICD10.ICD10Code
                        END AS ICD10Code ,
                        ICD10.ICDDescription AS ICD10Description
                FROM    dbo.DiagnosisICDCodes AS ICD9
                        LEFT JOIN dbo.DiagnosisICD10ICD9Mapping AS Map ON Map.ICD9Code = ICD9.ICDCode
                        LEFT JOIN dbo.DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = Map.ICD10CodeId
                WHERE   ICD10.ICD10Code IS NULL
                        AND ( ICD9.ICDCode = @ICD9DSMCode
                              OR @ICD9DSMCode IS NULL
                            )
                UNION
                SELECT DISTINCT
                        DSM.DSMCode AS ICD9Code ,
                        DSMDescription.DSMDescription AS ICD9Description ,
                        CASE WHEN ISNULL(ICD10.DSMVCode, 'N') = 'Y' THEN ICD10.ICD10Code + '*'
                             ELSE ICD10.ICD10Code
                        END AS ICD10Code ,
                        ICD10.ICDDescription AS ICD10Description
                FROM    dbo.DiagnosisDSMCodes AS DSM
                        LEFT JOIN dbo.DiagnosisDSMDescriptions DSMDescription ON DSMDescription.DSMCode = DSM.DSMCode
                        LEFT JOIN dbo.DiagnosisICD10ICD9Mapping AS Map ON Map.ICD9Code = DSM.DSMCode
                        LEFT JOIN dbo.DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = Map.ICD10CodeId
                WHERE   ICD10.ICD10Code IS NULL
                        AND ( DSM.DSMCode = @ICD9DSMCode
                              OR @ICD9DSMCode IS NULL
                            )
                ORDER BY ICD9Code        
            END
            
            
            
            
        IF @Mapped = 1
            BEGIN
                SELECT DISTINCT
                        ICD9.ICDCode AS ICD9Code ,
                        ICD9.ICDDescription AS ICD9Description ,
                        CASE WHEN ISNULL(ICD10.DSMVCode, 'N') = 'Y' THEN ICD10.ICD10Code + '*'
                             ELSE ICD10.ICD10Code
                        END AS ICD10Code ,
                        ICD10.ICDDescription AS ICD10Description
                FROM    dbo.DiagnosisICDCodes AS ICD9
                        LEFT JOIN dbo.DiagnosisICD10ICD9Mapping AS Map ON Map.ICD9Code = ICD9.ICDCode
                        LEFT JOIN dbo.DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = Map.ICD10CodeId
                WHERE   ICD10.ICD10Code IS NOT NULL
                        AND ( ICD9.ICDCode = @ICD9DSMCode
                              OR @ICD9DSMCode IS NULL
                            )
                UNION
                SELECT DISTINCT
                        DSM.DSMCode AS ICD9Code ,
                        DSMDescription.DSMDescription AS ICD9Description ,
                        CASE WHEN ISNULL(ICD10.DSMVCode, 'N') = 'Y' THEN ICD10.ICD10Code + '*'
                             ELSE ICD10.ICD10Code
                        END AS ICD10Code ,
                        ICD10.ICDDescription AS ICD10Description
                FROM    dbo.DiagnosisDSMCodes AS DSM
                        LEFT JOIN dbo.DiagnosisDSMDescriptions DSMDescription ON DSMDescription.DSMCode = DSM.DSMCode
                        LEFT JOIN dbo.DiagnosisICD10ICD9Mapping AS Map ON Map.ICD9Code = DSM.DSMCode
                        LEFT JOIN dbo.DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = Map.ICD10CodeId
                WHERE   ICD10.ICD10Code IS NOT NULL
                        AND ( DSM.DSMCode = @ICD9DSMCode
                              OR @ICD9DSMCode IS NULL
                            )
                ORDER BY ICD9Code        
            END
            
    END