/****** Object:  StoredProcedure [dbo].[csp_CommonValidateCustomDocumentDSM5Diagnosis]    Script Date: 08/12/2016 14:48:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CommonValidateCustomDocumentDSM5Diagnosis]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CommonValidateCustomDocumentDSM5Diagnosis] --733554
GO

/****** Object:  StoredProcedure [dbo].[csp_CommonValidateCustomDocumentDSM5Diagnosis]    Script Date: 08/12/2016 14:48:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_CommonValidateCustomDocumentDSM5Diagnosis] 
 @DocumentVersionId int    
AS  
 Begin  
BEGIN TRY       
/******************************************************************************************/  
/* Stored Procedure: [csp_CommonValidateCustomDocumentDSM5Diagnosis] 2655            */  
/*       Date			Author                  Purpose          */
-------------------------------------------------------------------------------------------  
/*      04-08-2016	   Lakshmi 	            What : Validation SP CustomDocumentDSM5Diagnosis
										    Why :  Task# 70 Project:Camino Support Go live */
/*      19-19-2016	   Venkatesh 	        What : Added new validation 'Diagnosis - A diagnosis list is required.'
										    Why :  Task# 174 Project:Camino Support Go live */
										      
/******************************************************************************************/   

DECLARE @ECIProgramId int
DECLARE @ClientId int
DECLARE @StaffId int
DECLARE @EffectiveDate datetime 
DECLARE @PrimaryTypeCount int
DECLARE @DiagnosisCount int   
DECLARE @NoDiagnosis CHAR(1) ='Y' 

SELECT TOP 1 @ClientId = d.ClientId  
FROM Documents d  

WHERE d.InProgressDocumentVersionId = @DocumentVersionId   AND ISNULL(d.RecordDeleted,'N')='N'
SELECT @StaffId = d.AuthorId  
FROM Documents d  
WHERE d.InProgressDocumentVersionId = @DocumentVersionId  
  
SET @EffectiveDate = CONVERT(datetime, convert(varchar, getdate(), 101)) 

CREATE TABLE [#tempvalidationReturnTable] (        
   TableName varchar(100) null,       
   ColumnName varchar(100) null,       
   ErrorMessage varchar(max) null,
   TabOrder int null,  
   ValidationOrder int null  
   )  
   
  IF EXISTS (Select 1 from DocumentDiagnosis WHERE DocumentVersionId=@DocumentVersionId and isnull(NoDiagnosis,'N')='N')
  BEGIN
	SET @NoDiagnosis = 'N'
  END
  
  /*Added Validation for primary type */ 
  SELECT @PrimaryTypeCount=count(DiagnosisType)  FROM DocumentDiagnosisCodes   
  where DocumentVersionId=@DocumentVersionId and DiagnosisType=140 and isnull(recorddeleted,'N')='N'

  SELECT @DiagnosisCount=count(DiagnosisType)  FROM DocumentDiagnosisCodes   
  where DocumentVersionId=@DocumentVersionId and isnull(recorddeleted,'N')='N'


  IF(@DiagnosisCount=0 AND @NoDiagnosis = 'N')  
BEGIN  
 INSERT  INTO #tempvalidationReturnTable  
        ( TableName ,  
          ColumnName ,  
          ErrorMessage ,  
          TabOrder ,  
          ValidationOrder  
        )  
        SELECT  'DocumentDiagnosisCodes' ,  
          'DiagnosisType' ,  
          'Diagnosis - One Diagnosis must be required.' ,  
         1,  
         3 
END

IF(@PrimaryTypeCount=0)
BEGIN
 INSERT  INTO #tempvalidationReturnTable
								( TableName ,
								  ColumnName ,
								  ErrorMessage ,
								  TabOrder ,
								  ValidationOrder
								)
								SELECT  'DocumentDiagnosisCodes' ,
								  'DiagnosisType' ,
								  'Diagnosis - A diagnosis code of type primary is required.' ,
								 1 ,
								 3 FROM DocumentDiagnosisCodes WHERE  DocumentVersionId=@DocumentVersionId 
								  AND ISNULL(RecordDeleted, 'N') = 'N'
END
   
  /*Added Validation for DX Code */ 
 DECLARE @ICD10CodeWithoutDistinctCount INT
 DECLARE @ICD10CodeWithDistinctCount INT
 
 SELECT  @ICD10CodeWithoutDistinctCount = COUNT(ICD10CodeId) FROM DocumentDiagnosisCodes DD
 WHERE DD.DocumentVersionId=@DocumentVersionId  AND ISNULL(DD.RecordDeleted, 'N') = 'N'
 
 SELECT  @ICD10CodeWithDistinctCount = COUNT(DISTINCT ICD10CodeId) FROM DocumentDiagnosisCodes DD
 WHERE DD.DocumentVersionId=@DocumentVersionId  AND ISNULL(DD.RecordDeleted, 'N') = 'N'
 
 IF(@ICD10CodeWithoutDistinctCount!=@ICD10CodeWithDistinctCount)
 BEGIN
 INSERT  INTO #tempvalidationReturnTable
								( TableName ,
								  ColumnName ,
								  ErrorMessage ,
								  TabOrder ,
								  ValidationOrder
								)
								SELECT  'DocumentDiagnosisCodes' ,
								  'ICD10Code' ,
								 'Diagnosis - Dx code is added multiple times across orders. Please delete duplicate values and continue' ,
								 1 ,
								 2 FROM DocumentDiagnosisCodes WHERE DocumentVersionId=@DocumentVersionId
								  AND ISNULL(RecordDeleted, 'N') = 'N'
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
	 -- INSERT  INTO #tempvalidationReturnTable
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
	DECLARE @DiagnosisOrder varchar(20)
	DECLARE @DiagnosisOrderCheck varchar(20)
	DECLARE @COUNT INT=0
	
DECLARE Diagnosis_cursor CURSOR FOR
SELECT   DiagnosisType,DiagnosisOrder FROM DocumentDiagnosisCodes DD
WHERE DD.DocumentVersionId=@DocumentVersionId  AND ISNULL(DD.RecordDeleted, 'N') = 'N'  
OPEN Diagnosis_cursor

   FETCH NEXT FROM Diagnosis_cursor INTO @DiagnosisType,@DiagnosisOrder;
   WHILE @@FETCH_STATUS = 0
   BEGIN
   IF(@COUNT=0)
   BEGIN
    SET @DiagnosisOrderCheck=@DiagnosisOrder;
    SET @COUNT=@COUNT+1;
   -- select @COUNT as count
   -- select @DiagnosisOrderCheck as DiagnosisOrderCheck
   --select @DiagnosisOrder
   END
   ELSE
   BEGIN
   IF(@DiagnosisOrder=@DiagnosisOrderCheck)
   --select @DiagnosisType,@DiagnosisOrder
     SET @COUNT=@COUNT+1;
   --select @DiagnosisOrder
   if((SELECT  count(DiagnosisOrder) FROM DocumentDiagnosisCodes DD
   WHERE DD.DocumentVersionId=@DocumentVersionId  AND ISNULL(DD.RecordDeleted, 'N') = 'N' and DiagnosisOrder=@DiagnosisOrder)>1  )
   BEGIN
     --select @DiagnosisType,@DiagnosisOrder
    IF @DiagnosisOrder = 1
    BEGIN
		SET @DiagnosisOrderCheck=@DiagnosisOrder;
		INSERT  INTO #tempvalidationReturnTable
								( TableName ,
								  ColumnName ,
								  ErrorMessage ,
								  TabOrder ,
								  ValidationOrder
								)
								SELECT  'DocumentDiagnosisCodes' ,
								  'DiagnosisOrder' ,
								 'Diagnosis - Order of '+@DiagnosisOrder+' can occur only one time.' ,
								 1 ,
								 1 FROM DocumentDiagnosisCodes WHERE DocumentVersionId=@DocumentVersionId
								  AND ISNULL(RecordDeleted, 'N') = 'N'
	END
   END
   END
 
    FETCH NEXT FROM Diagnosis_cursor INTO @DiagnosisType,@DiagnosisOrder
   END
   CLOSE Diagnosis_cursor   
   DEALLOCATE Diagnosis_cursor
   
   set @DiagnosisOrderCheck='';
   SELECT    distinct TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder  from #tempvalidationReturnTable
    order by taborder,ValidationOrder

 
END TRY
  BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_CommonValidateCustomDocumentDSM5Diagnosis') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	END CATCH
    
  
End  
  
  

--if @@error <> 0 goto error    
--return   
--error:    
--raiserror 50000 'csp_CommonValidateCustomDocumentDSM5Diagnosis failed.  Please contact your system administrator.'  

--GO


