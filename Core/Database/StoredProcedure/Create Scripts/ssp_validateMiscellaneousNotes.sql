
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_validateMiscellaneousNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_validateMiscellaneousNotes]
GO

/****** Object:  StoredProcedure [dbo].[ssp_validateMiscellaneousNotes]    Script Date: 02/12/2016 18:14:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
   
CREATE    PROCEDURE [dbo].[ssp_validateMiscellaneousNotes]      
@documentVersionId Int     
as      
/************************************************************************    
Created By         Date           Reason 
     
Vijeta Sinha    02/17/2016   Created to make Core MiscellaneousNotes from custom under the task-  Engineering Improvement Initiatives- NBL(I)#310  
PradeepT        24 July 2017  What: Making call to SCSP_ValidateMiscellaneousNotes which will claa custom validation sp csp_ValidateMiscleniousNotes
                              Why: To Impelemnt Custom validation(As per MHP- Customization #59.1)
JPeralta		 Dec 07, 2017  Spring River SGL #20 To validate Intake program when Service is show to discharge from program before signing note
Neelima			10 Sept 2018	What: Added SCSP SCSP_ValidateMiscellaneousNotesIntake for Boundless, since they doesnot require the discharge validation Why: 	Boundless - Support #303
**************************************************************************/      
 BEGIN 
     BEGIN TRY      
DECLARE @ProcedureCodeId INT

SELECT @ProcedureCodeId = s.ProcedureCodeId
FROM documents d
JOIN DocumentVersions dv ON dv.DocumentId = d.DocumentId
JOIN services s ON s.ServiceId = d.ServiceId
WHERE dv.DocumentVersionId = @DocumentVersionId

INSERT INTO #validationReturnTable (
	TableName
	,ColumnName
	,ErrorMessage
	)
--This validation returns three fields      
--Field1 = TableName      
--Field2 = ColumnName      
--Field3 = ErrorMessage      
SELECT 'CustomMiscellaneousNotes'
	,'Narration'
	,'Narrative must be specified.'
FROM CustomMiscellaneousNotes c
WHERE c.DocumentVersionId = @documentVersionId
	AND isnull(convert(VARCHAR(max), Narration), '') = ''

--Intake Program Validation
IF EXISTS ( SELECT  *    
            FROM    sys.objects    
            WHERE   object_id = OBJECT_ID(N'SCSP_ValidateMiscellaneousNoShowIntake')    
                    AND type IN ( N'P', N'PC' ) )   
    BEGIN       
     EXEC SCSP_ValidateMiscellaneousNoShowIntake @documentVersionId  
     END  
 ELSE
 BEGIN 
  IF EXISTS
             (
                 SELECT *
                 FROM documents d
                  JOIN DocumentVersions dv ON dv.DocumentId = d.DocumentId
                  JOIN services s ON s.ServiceId = d.ServiceId
			   JOIN Programs p ON s.ProgramId = p.ProgramId
             WHERE dv.DocumentVersionId = @DocumentVersionId
                       AND p.ProgramName LIKE 'Intake%'  
				   and s.Status IN(71, 75)
                 ) 
                       
              -- Show

                 BEGIN
                     INSERT INTO #validationReturnTable
                     (TableName,
                      ColumnName,
                      ErrorMessage,
                      TabOrder,
                      ValidationOrder
                     )
                     VALUES
                     ('Services',
                      'ProgramId',
                      'Discharging the client from intake program before signing the note is required',
                      1,
                      1
                     );
             END;
 END

IF EXISTS ( SELECT  *    
            FROM    sys.objects    
            WHERE   object_id = OBJECT_ID(N'SCSP_ValidateMiscellaneousNotes')    
                    AND type IN ( N'P', N'PC' ) )   
    BEGIN       
     EXEC SCSP_ValidateMiscellaneousNotes @documentVersionId  
     END  
END TRY
 BEGIN CATCH                      
 DECLARE @ERROR VARCHAR(8000)                      
 SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                       
    + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_validateMiscellaneousNotes')                       
    + '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                        
    + '*****' + CONVERT(VARCHAR,ERROR_STATE())                      
 RAISERROR                       
 (                      
  @Error, -- Message text.                      
  16,  -- Severity.                      
  1  -- State.                      
 );                   
END CATCH   
END





