IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  NAME = 'CSF_CommonValidateCustomDocumentDSM5Diagnosis') 
  DROP FUNCTION [dbo].csf_commonvalidatecustomdocumentdsm5diagnosis 

go 

SET ansi_nulls ON 

go 

SET quoted_identifier ON 

go 

CREATE FUNCTION Csf_commonvalidatecustomdocumentdsm5diagnosis ( 
@DocumentVersionId INT) 
returns @validationReturnTable TABLE( 
  tablename       VARCHAR(100) NULL, 
  columnname      VARCHAR(100) NULL, 
  errormessage    VARCHAR(max) NULL, 
  taborder        INT NULL, 
  validationorder INT NULL) 
  BEGIN 
      DECLARE @ECIProgramId INT 
      DECLARE @ClientId INT 
      DECLARE @StaffId INT 
      DECLARE @EffectiveDate DATETIME 
      DECLARE @PrimaryTypeCount INT 
      DECLARE @DiagnosisCount INT 
      DECLARE @NoDiagnosis CHAR(1) ='Y' 

      SELECT TOP 1 @ClientId = d.clientid 
      FROM   documents d 
      WHERE  d.inprogressdocumentversionid = @DocumentVersionId 
             AND Isnull(d.recorddeleted, 'N') = 'N' 

      SELECT @StaffId = d.authorid 
      FROM   documents d 
      WHERE  d.inprogressdocumentversionid = @DocumentVersionId 

      SET @EffectiveDate = CONVERT(DATETIME, CONVERT(VARCHAR, Getdate(), 101)) 

      DECLARE @tempvalidationReturnTable TABLE 
        ( 
           tablename       VARCHAR(100) NULL, 
           columnname      VARCHAR(100) NULL, 
           errormessage    VARCHAR(max) NULL, 
           taborder        INT NULL, 
           validationorder INT NULL 
        ) 

      IF EXISTS (SELECT 1 
                 FROM   documentdiagnosis 
                 WHERE  documentversionid = @DocumentVersionId 
                        AND Isnull(nodiagnosis, 'N') = 'N') 
        BEGIN 
            SET @NoDiagnosis = 'N' 
        END 

      /*Added Validation for primary type */ 
      SELECT @PrimaryTypeCount = Count(diagnosistype) 
      FROM   documentdiagnosiscodes 
      WHERE  documentversionid = @DocumentVersionId 
             AND diagnosistype = 140 
             AND Isnull(recorddeleted, 'N') = 'N' 

      SELECT @DiagnosisCount = Count(diagnosistype) 
      FROM   documentdiagnosiscodes 
      WHERE  documentversionid = @DocumentVersionId 
             AND Isnull(recorddeleted, 'N') = 'N' 

      IF( @DiagnosisCount = 0 
          AND @NoDiagnosis = 'N' ) 
        BEGIN 
            INSERT INTO @tempvalidationReturnTable 
                        (tablename, 
                         columnname, 
                         errormessage, 
                         taborder, 
                         validationorder) 
            SELECT 'DocumentDiagnosisCodes', 
                   'DiagnosisType', 
                   'Diagnosis - One Diagnosis must be required.', 
                   1, 
                   3 
        END 

      IF( @PrimaryTypeCount = 0 ) 
        BEGIN 
            INSERT INTO @tempvalidationReturnTable 
                        (tablename, 
                         columnname, 
                         errormessage, 
                         taborder, 
                         validationorder) 
            SELECT 'DocumentDiagnosisCodes', 
                   'DiagnosisType', 
                   'Diagnosis - A diagnosis code of type primary is required.', 
                   1, 
                   3 
            FROM   documentdiagnosiscodes 
            WHERE  documentversionid = @DocumentVersionId 
                   AND Isnull(recorddeleted, 'N') = 'N' 
        END 

      /*Added Validation for DX Code */ 
      DECLARE @ICD10CodeWithoutDistinctCount INT 
      DECLARE @ICD10CodeWithDistinctCount INT 

      SELECT @ICD10CodeWithoutDistinctCount = Count(icd10codeid) 
      FROM   documentdiagnosiscodes DD 
      WHERE  DD.documentversionid = @DocumentVersionId 
             AND Isnull(DD.recorddeleted, 'N') = 'N' 

      SELECT @ICD10CodeWithDistinctCount = Count(DISTINCT icd10codeid) 
      FROM   documentdiagnosiscodes DD 
      WHERE  DD.documentversionid = @DocumentVersionId 
             AND Isnull(DD.recorddeleted, 'N') = 'N' 

      IF( @ICD10CodeWithoutDistinctCount != @ICD10CodeWithDistinctCount ) 
        BEGIN 
            INSERT INTO @tempvalidationReturnTable 
                        (tablename, 
                         columnname, 
                         errormessage, 
                         taborder, 
                         validationorder) 
            SELECT 'DocumentDiagnosisCodes', 
                   'ICD10Code', 
'Diagnosis - Dx code is added multiple times across orders. Please delete duplicate values and continue'
       , 
1, 
2 
FROM   documentdiagnosiscodes 
WHERE  documentversionid = @DocumentVersionId 
       AND Isnull(recorddeleted, 'N') = 'N' 
END 

    --Commented by Jagan as per Jill email to remove this validation.    
    -- /*Added Validation for GAF score validation based on ECI Program*/    
    -- Select Top 1 @ECIProgramId = R.IntegerCodeId FROM Recodes R    
    -- INNER JOIN  RecodeCategories RC ON R.RecodeCategoryId = RC.RecodeCategoryId AND    
    -- RC.CategoryCode='XECIProgram'  AND ISNULL(RC.RecordDeleted, 'N') = 'N'    
    -- IF NOT EXISTS(SELECT 1 FROM ClientPrograms CP    
    -- JOIN Programs P ON P.ProgramId=CP.ProgramId   
    -- WHERE Cp.ClientId=@ClientId AND Cp.ProgramId=@ECIProgramId AND Cp.Status=4 AND ISNULL(CP.RecordDeleted, 'N') = 'N')  
    -- BEGIN   
    -- INSERT  INTO @tempvalidationReturnTable   
    -- ( TableName ,   
    -- ColumnName ,   
    -- ErrorMessage ,   
    -- TabOrder ,   
    -- ValidationOrder   
    -- )   
    -- SELECT  'DocumentDiagnosis' ,   
    -- 'GAFScore' ,   
    -- 'Diagnosis - Level of Functioning Score - GAF Score is required' ,   
    -- 1 ,   
    -- 4 FROM DocumentDiagnosis WHERE DocumentVersionId=@DocumentVersionId   AND GAFScore is null   
    -- AND ISNULL(RecordDeleted, 'N') = 'N'   
    -- END   
    /*Added Validation for Diagnosis Order 1 duplication */ 
    DECLARE @DiagnosisType INT 
    DECLARE @DiagnosisOrder VARCHAR(20) 
    DECLARE @DiagnosisOrderCheck VARCHAR(20) 
    DECLARE @COUNT INT=0 
    DECLARE diagnosis_cursor CURSOR FOR 
      SELECT diagnosistype, 
             diagnosisorder 
      FROM   documentdiagnosiscodes DD 
      WHERE  DD.documentversionid = @DocumentVersionId 
             AND Isnull(DD.recorddeleted, 'N') = 'N' 

    OPEN diagnosis_cursor 

    FETCH next FROM diagnosis_cursor INTO @DiagnosisType, @DiagnosisOrder; 

    WHILE @@FETCH_STATUS = 0 
      BEGIN 
          IF( @COUNT = 0 ) 
            BEGIN 
                SET @DiagnosisOrderCheck=@DiagnosisOrder; 
                SET @COUNT=@COUNT + 1; 
            -- select @COUNT as count   
            -- select @DiagnosisOrderCheck as DiagnosisOrderCheck   
            --select @DiagnosisOrder   
            END 
          ELSE 
            BEGIN 
                IF( @DiagnosisOrder = @DiagnosisOrderCheck ) 
                  --select @DiagnosisType,@DiagnosisOrder   
                  SET @COUNT=@COUNT + 1; 

                --select @DiagnosisOrder   
                IF( (SELECT Count(diagnosisorder) 
                     FROM   documentdiagnosiscodes DD 
                     WHERE  DD.documentversionid = @DocumentVersionId 
                            AND Isnull(DD.recorddeleted, 'N') = 'N' 
                            AND diagnosisorder = @DiagnosisOrder) > 1 ) 
                  BEGIN 
                      --select @DiagnosisType,@DiagnosisOrder   
                      IF @DiagnosisOrder = 1 
                        BEGIN 
                            SET @DiagnosisOrderCheck=@DiagnosisOrder; 

                            INSERT INTO @tempvalidationReturnTable 
                                        (tablename, 
                                         columnname, 
                                         errormessage, 
                                         taborder, 
                                         validationorder) 
                            SELECT 'DocumentDiagnosisCodes', 
                                   'DiagnosisOrder', 
                                   'Diagnosis - Order of ' + @DiagnosisOrder 
                                   + ' can occur only one time.', 
                                   1, 
                                   1 
                            FROM   documentdiagnosiscodes 
                            WHERE  documentversionid = @DocumentVersionId 
                                   AND Isnull(recorddeleted, 'N') = 'N' 
                        END 
                  END 
            END 

          FETCH next FROM diagnosis_cursor INTO @DiagnosisType, @DiagnosisOrder 
      END 

    CLOSE diagnosis_cursor 

    DEALLOCATE diagnosis_cursor 

    RETURN 
END 