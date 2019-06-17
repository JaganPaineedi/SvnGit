IF NOT EXISTS ( SELECT  *
                FROM    dbo.DocumentValidations
                WHERE   DocumentCodeId = 1601
                        AND Active = 'Y'
                        AND ErrorMessage = 'At lease 1 diagnosis code must be entered or no diagnosis should be checked' )
    BEGIN 

        INSERT  INTO DocumentValidations
                ( DocumentCodeId ,
                  Active ,
                  TabName ,
                  TabOrder ,
                  TableName ,
                  ColumnName ,
                  ValidationLogic ,
                  ValidationOrder ,
                  ErrorMessage
                )
                SELECT  1601 ,
                        'Y' ,
                        'Diagnosis' ,
                        1 ,
                        'DocumentDiagnosis' ,
                        'ICD10Code' ,
                        'FROM    dbo.DocumentVersions a
WHERE   a.DocumentVersionId = @DocumentVersionId
        AND ( NOT EXISTS ( SELECT   1
                           FROM     dbo.DocumentDiagnosisCodes b
                           WHERE    b.DocumentVersionId = a.DocumentVersionId
                                    AND ISNULL(b.RecordDeleted, ''N'') = ''N'' )
              AND NOT EXISTS ( SELECT    1
                              FROM      dbo.DocumentDiagnosis c
                              WHERE     c.DocumentVersionId = a.DocumentVersionId
                                        AND ISNULL(c.RecordDeleted, ''N'') = ''N''
                                        AND ISNULL(c.NoDiagnosis, ''N'') = ''Y'' )
            )' ,
                        1 ,
                        'At lease 1 diagnosis code must be entered or no diagnosis should be checked'

    END