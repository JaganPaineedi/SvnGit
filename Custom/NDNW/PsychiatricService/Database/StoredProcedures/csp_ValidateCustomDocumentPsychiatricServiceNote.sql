/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomDocumentPsychiatricServiceNote]    Script Date: 06/30/2014 18:07:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentPsychiatricServiceNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomDocumentPsychiatricServiceNote]
GO

/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomDocumentPsychiatricServiceNote]    Script Date: 06/30/2014 18:07:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_ValidateCustomDocumentPsychiatricServiceNote]  
 @DocumentVersionId int    
AS  
   
/*********************************************************************/
/* Stored Procedure: [csp_ValidateCustomDocumentPsychiatricServiceNote]   */
/*       Date              Author                  Purpose                   */
/*      18-12-2014     Dhanil Manuel               To Retrieve Data  for RDL   */
/*      23-12-2014     Akwinass                    History Tab Problem Validation Included*/
/*********************************************************************/
 
DECLARE @DocumentType varchar(10)
DECLARE @ClientId int  
DECLARE @EffectiveDate datetime  
DECLARE @StaffId int  
DECLARE @DocumentCodeId int
  
SELECT @ClientId = d.ClientId  
FROM Documents d  
WHERE d.InProgressDocumentVersionId = @DocumentVersionId  
  
SELECT @StaffId = d.AuthorId  
FROM Documents d  
WHERE d.InProgressDocumentVersionId = @DocumentVersionId  
  
SET @EffectiveDate = CONVERT(datetime, convert(varchar, getdate(), 101))  

 CREATE TABLE [#validationReturnTable] (        
   TableName varchar(100) null,       
   ColumnName varchar(100) null,       
   ErrorMessage varchar(max) null,
   TabOrder int null,  
   ValidationOrder int null  
   )  

  
DECLARE @Variables varchar(max)    
SET @Variables = 'DECLARE @DocumentVersionId int  
      SET @DocumentVersionId = ' + convert(varchar(20), @DocumentVersionId) +    
     ' DECLARE @ClientId int  
      SET @ClientId = ' + convert(varchar(20), @ClientId) +   
     'DECLARE @EffectiveDate datetime  
      SET @EffectiveDate = ''' + CONVERT(varchar(20), @EffectiveDate, 101) + '''' +  
     'DECLARE @StaffId int  
      SET @StaffId = ' + CONVERT(varchar(20), @StaffId)  
  

If Not Exists (Select 1 From CustomDocumentValidationExceptions where DocumentVersionId = @DocumentVersionId and DocumentValidationid is null)    
Begin
Exec csp_validateDocumentsTableSelect @DocumentVersionId, 21300, @DocumentType, @Variables

DECLARE @ValidationOrder INT = 11
DECLARE @ProblemNumber  INT = 0
DECLARE @TwoItemCount INT = 0
DECLARE @AssociatedSymptomsText VARCHAR(250)
DECLARE @ProblemText VARCHAR(MAX),@Severity INT,@Duration VARCHAR(150),@Intensity INT,@TimeOfDayMorning CHAR(1),@TimeOfDayNoon CHAR(1),@TimeOfDayAfternoon CHAR(1),@TimeOfDayEvening CHAR(1),@TimeOfDayNight CHAR(1),@ContextHome CHAR(1),@ContextSchool CHAR(1),@ContextWork CHAR(1),@ContextCommunity CHAR(1),@ContextOther CHAR(1),@ContextOtherText VARCHAR(max),@AssociatedSignsSymptoms INT,@ModifyingFactors VARCHAR(max),@AssociatedSignsSymptomsOtherText VARCHAR(MAX),@ProblemStatus INT
DECLARE FA_cursor CURSOR FAST_FORWARD FOR
SELECT ProblemText,Severity,Duration,Intensity,TimeOfDayMorning,TimeOfDayNoon,TimeOfDayAfternoon,TimeOfDayEvening,TimeOfDayNight,ContextHome,ContextSchool,ContextWork,ContextCommunity,ContextOther,ContextOtherText,AssociatedSignsSymptoms,ModifyingFactors,AssociatedSignsSymptomsOtherText,ProblemStatus FROM CustomPsychiatricServiceNoteProblems WHERE DocumentVersionId = @DocumentVersionId AND ISNULL(RecordDeleted, 'N') = 'N' ORDER BY PsychiatricServiceNoteProblemId ASC

OPEN FA_cursor
FETCH NEXT FROM FA_cursor INTO @ProblemText,@Severity,@Duration,@Intensity,@TimeOfDayMorning,@TimeOfDayNoon,@TimeOfDayAfternoon,@TimeOfDayEvening,@TimeOfDayNight,@ContextHome,@ContextSchool,@ContextWork,@ContextCommunity,@ContextOther,@ContextOtherText,@AssociatedSignsSymptoms,@ModifyingFactors,@AssociatedSignsSymptomsOtherText,@ProblemStatus

WHILE @@FETCH_STATUS = 0
BEGIN
	
	SET @ProblemNumber = @ProblemNumber + 1
	
    IF ISNULL(@ProblemText,'') = ''
    BEGIN
		SET @ValidationOrder = @ValidationOrder + 1
		INSERT INTO #validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
		SELECT 'CustomPsychiatricServiceNoteProblems','ProblemText','History - Problem ' + CAST(@ProblemNumber AS VARCHAR(200)) + ' - Problem is required.',2,@ValidationOrder
	END
	IF ISNULL(@ProblemStatus,0) = 0
    BEGIN
		SET @ValidationOrder = @ValidationOrder + 1
		INSERT INTO #validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
		SELECT 'CustomPsychiatricServiceNoteProblems','ProblemStatus','Medical Decision Making - Problem ' + CAST(@ProblemNumber AS VARCHAR(200)) + ' - Problem Status is required.',3,@ValidationOrder
	END
	
	SET @TwoItemCount = 0
	IF ISNULL(@Severity,0) > 0
    BEGIN
		SET @TwoItemCount = @TwoItemCount + 1
    END
	
	IF ISNULL(@Duration,'') <> ''
    BEGIN
		SET @TwoItemCount = @TwoItemCount + 1
    END
    
    IF ISNULL(@Intensity,0) > 0
    BEGIN
		SET @TwoItemCount = @TwoItemCount + 1
    END
    IF ISNULL(@ModifyingFactors,'') > ''
    BEGIN
  SET @TwoItemCount = @TwoItemCount + 1
    END
    
    IF ISNULL(@TimeOfDayMorning,'N') <> 'N' OR ISNULL(@TimeOfDayNoon,'N') <> 'N' OR ISNULL(@TimeOfDayAfternoon,'N') <> 'N' OR ISNULL(@TimeOfDayEvening,'N') <> 'N' OR ISNULL(@TimeOfDayNight,'N') <> 'N'
    BEGIN
		SET @TwoItemCount = @TwoItemCount + 1
    END
    
    IF ISNULL(@ContextHome,'N') <> 'N' OR ISNULL(@ContextSchool,'N') <> 'N' OR ISNULL(@ContextWork,'N') <> 'N' OR ISNULL(@ContextCommunity,'N') <> 'N' OR ISNULL(@ContextOther,'N') <> 'N'
    BEGIN
		SET @TwoItemCount = @TwoItemCount + 1
    END
    
    IF ISNULL(@AssociatedSignsSymptoms,0) > 0
    BEGIN
		SET @TwoItemCount = @TwoItemCount + 1
    END
    
    IF ISNULL(@TwoItemCount,0) < 2
    BEGIN
		SET @ValidationOrder = @ValidationOrder + 1
		INSERT INTO #validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
		SELECT 'CustomPsychiatricServiceNoteProblems','Severity','History - Problem ' + CAST(@ProblemNumber AS VARCHAR(200)) + ' - At least two items are required.',2,@ValidationOrder
    END
    
    IF ISNULL(@ContextOther,'N') = 'Y' AND ISNULL(@ContextOtherText,'') = ''
    BEGIN
		SET @ValidationOrder = @ValidationOrder + 1
		INSERT INTO #validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
		SELECT 'CustomPsychiatricServiceNoteProblems','ContextOtherText','History - Problem ' + CAST(@ProblemNumber AS VARCHAR(200)) + ' - Context comment is required when Other is selected.',2,@ValidationOrder
	END
	
	IF ISNULL(@AssociatedSignsSymptoms,0) > 0
    BEGIN
		SELECT TOP 1 @AssociatedSymptomsText = CodeName FROM GlobalCodes WHERE GlobalCodeId = @AssociatedSignsSymptoms
		IF ISNULL(@AssociatedSymptomsText,'') = 'Other' AND ISNULL(@AssociatedSignsSymptomsOtherText,'') = ''
		BEGIN
			SET @ValidationOrder = @ValidationOrder + 1
			INSERT INTO #validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
			SELECT 'CustomPsychiatricServiceNoteProblems','AssociatedSignsSymptomsOtherText','History - Problem ' + CAST(@ProblemNumber AS VARCHAR(200)) + ' - Associated Signs/Symptoms comment is required when Other is selected.',2,@ValidationOrder
		END
	END
    
    FETCH NEXT FROM FA_cursor INTO @ProblemText,@Severity,@Duration,@Intensity,@TimeOfDayMorning,@TimeOfDayNoon,@TimeOfDayAfternoon,@TimeOfDayEvening,@TimeOfDayNight,@ContextHome,@ContextSchool,@ContextWork,@ContextCommunity,@ContextOther,@ContextOtherText,@AssociatedSignsSymptoms,@ModifyingFactors,@AssociatedSignsSymptomsOtherText,@ProblemStatus
END

CLOSE FA_cursor
DEALLOCATE FA_cursor

select TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder  from #validationReturnTable order by taborder,ValidationOrder
if @@error <> 0 goto error    
End    
   
if @@error <> 0 goto error    
    
return   
  
error:    
raiserror 50000 'csp_ValidateCustomDocumentPsychiatricServiceNote failed.  Please contact your system administrator.'  

GO


