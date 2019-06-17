/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomPsychiatricNoteSubjective]    Script Date: 01/20/2015 10:26:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomPsychiatricNoteSubjective]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomPsychiatricNoteSubjective]
GO

/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomPsychiatricNoteSubjective] 80, null  Script Date: 01/20/2015 10:26:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_ValidateCustomPsychiatricNoteSubjective] @DocumentVersionId INT,@TDocumentType Char(1)
AS
/**************************************************************  
Created By   : Lakshmi
Created Date : 13-11-2015
Description  : Used to Validate Subjective.
Called From  : csp_ValidateCustomDocumentMedicalNote
/*  Date			  Author				  Description */
/*  13-11-2015	      Lakshmi				      Created    */

**************************************************************/
DECLARE @TabOrder INT = 1
DECLARE @ValidationOrder INT = 55
DECLARE @ProblemNumber  INT = 0
DECLARE @TwoItemCount INT = 0
DECLARE @AssociatedSymptomsText VARCHAR(250)
DECLARE @validationReturnTable TABLE (TableName VARCHAR(100) NULL,ColumnName VARCHAR(100) NULL,ErrorMessage VARCHAR(max) NULL,TabOrder INT NULL,ValidationOrder INT NULL)


DECLARE @SubjectiveText VARCHAR(MAX),@TypeOfProblem INT, @Severity INT,@Duration INT,@TimeOfDayAllday CHAR(1),@TimeOfDayMorning CHAR(1),@TimeOfDayAfternoon CHAR(1),@TimeOfDayNight CHAR(1),@LocationHome CHAR(1),@LocationSchool CHAR(1),@LocationWork CHAR(1),@LocationEveryWhere CHAR(1),@LocationOther CHAR(1),@LocationOtherText VARCHAR(max),@AssociatedSignsSymptoms INT,@ModifyingFactors VARCHAR(max),@AssociatedSignsSymptomsOtherText VARCHAR(MAX),@ProblemStatus INT,@DiscussLongActingInjectable char(1), @ProblemMDMComments VARCHAR(max),@ICD10Code VARCHAR(max), @ContextText VARCHAR(MAX)
DECLARE FA_cursor CURSOR FAST_FORWARD FOR
SELECT SubjectiveText,TypeOfProblem,Severity,Duration,TimeOfDayAllday,TimeOfDayMorning,TimeOfDayAfternoon,TimeOfDayNight,LocationHome,LocationSchool,LocationWork,LocationEverywhere,LocationOther,LocationOtherText,AssociatedSignsSymptoms,ModifyingFactors,AssociatedSignsSymptomsOtherText,ProblemStatus,DiscussLongActingInjectable,ProblemMDMComments,ICD10Code,ContextText FROM CustomPsychiatricNoteProblems WHERE DocumentVersionId = @DocumentVersionId AND ISNULL(RecordDeleted, 'N') = 'N' ORDER BY PsychiatricNoteProblemId ASC

OPEN FA_cursor
FETCH NEXT FROM FA_cursor INTO  @SubjectiveText ,@TypeOfProblem , @Severity,@Duration,@TimeOfDayAllday,@TimeOfDayMorning ,@TimeOfDayAfternoon ,@TimeOfDayNight,@LocationHome ,@LocationSchool,@LocationWork,@LocationEveryWhere ,@LocationOther,@LocationOtherText,@AssociatedSignsSymptoms,@ModifyingFactors,@AssociatedSignsSymptomsOtherText,@ProblemStatus,
@DiscussLongActingInjectable, @ProblemMDMComments,@ICD10Code,@ContextText

WHILE @@FETCH_STATUS = 0
BEGIN
	
	SET @ProblemNumber = @ProblemNumber + 1
	
    IF ISNULL(@SubjectiveText,'') = ''
    BEGIN
		SET @ValidationOrder = @ValidationOrder + 1
		INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
		SELECT 'CustomPsychiatricNoteProblems','SubjectiveText','General - Problem ' + CAST(@ProblemNumber AS VARCHAR(200)) + ' - Problem is required.',@TabOrder,@ValidationOrder
	END
	--IF ISNULL(@TypeOfProblem,0) = 0
 --   BEGIN
	--	SET @ValidationOrder = @ValidationOrder + 1
	--	INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
	--	SELECT 'CustomPsychiatricNoteProblems','TypeOfProblem','General - Problem ' + CAST(@ProblemNumber AS VARCHAR(200)) + ' - Type of problem is required.',@TabOrder,@ValidationOrder
	--END
	
	--IF ISNULL(@Severity,0) = 0
 --   BEGIN
	--	SET @ValidationOrder = @ValidationOrder + 1
	--	INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
	--	SELECT 'CustomPsychiatricNoteProblems','Severity','General - Subjective ' + CAST(@ProblemNumber AS VARCHAR(200)) + ' - Severity is required.',@TabOrder,@ValidationOrder
	--END
	
	--IF ISNULL(@Duration,0) = 0
 --   BEGIN
	--	SET @ValidationOrder = @ValidationOrder + 1
	--	INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
	--	SELECT 'CustomPsychiatricNoteProblems','Duration','General - Subjective ' + CAST(@ProblemNumber AS VARCHAR(200)) + ' - Duration is required.',@TabOrder,@ValidationOrder
	--END
	
	--IF ISNULL(@Intensity,0) = 0
 --   BEGIN
	--	SET @ValidationOrder = @ValidationOrder + 1
	--	INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
	--	SELECT 'CustomPsychiatricNoteProblems','Intensity','General - Subjective ' + CAST(@ProblemNumber AS VARCHAR(200)) + ' - Intensity is required.',@TabOrder,@ValidationOrder
	--END
	
	--IF ISNULL(@ProblemStatus,0) = 0
 --   BEGIN
	--	SET @ValidationOrder = @ValidationOrder + 1
	--	INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
	--	SELECT 'CustomPsychiatricNoteProblems','ProblemStatus','Medical Decision Making  - Subjective ' + CAST(@ProblemNumber AS VARCHAR(200)) + ' - Subjective status is required.',3,@ValidationOrder
	--END
	
	--IF ISNULL(@ProblemMDMComments,'') = ''
 --   BEGIN
	--	SET @ValidationOrder = @ValidationOrder + 1
	--	INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
	--	SELECT 'CustomPsychiatricNoteProblems','ProblemMDMComments','Medical Decision Making - Subjective ' + CAST(@ProblemNumber AS VARCHAR(200)) + ' - Subjective comments is required.',3,@ValidationOrder
	--END
	
	-- IF ISNULL(@SubjectiveText,'') = ''
 --   BEGIN
	--	SET @ValidationOrder = @ValidationOrder + 1
	--	INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
	--	SELECT 'CustomPsychiatricNoteProblems','SubjectiveText','General - Problem ' + CAST(@ProblemNumber AS VARCHAR(200)) + ' - Problem Text is required.',@TabOrder,@ValidationOrder
	--END
	
	SET @TwoItemCount = 0
	IF ISNULL(@Severity,0) > 0
    BEGIN
		SET @TwoItemCount = @TwoItemCount + 1
    END
	
	IF ISNULL(@Duration,0) > 0
    BEGIN
		SET @TwoItemCount = @TwoItemCount + 1
    END
    
  --  IF ISNULL(@Intensity,0) > 0
  --  BEGIN
		--SET @TwoItemCount = @TwoItemCount + 1
  --  END
    
    IF ISNULL(@TimeOfDayMorning,'N') <> 'N' OR  ISNULL(@TimeOfDayAfternoon,'N') <> 'N' OR ISNULL(@TimeOfDayAllday,'N') <> 'N' OR ISNULL(@TimeOfDayNight,'N') <> 'N'
    BEGIN
		SET @TwoItemCount = @TwoItemCount + 1
    END
    
    IF ISNULL(@LocationHome,'N') <> 'N' OR ISNULL(@LocationSchool,'N') <> 'N' OR ISNULL(@LocationWork,'N') <> 'N' OR ISNULL(@LocationEveryWhere,'N') <> 'N' OR ISNULL(@LocationOther,'N') <> 'N'
    BEGIN
		SET @TwoItemCount = @TwoItemCount + 1
    END
    
    IF ISNULL(@ContextText,'') <> ''
    BEGIN
		SET @TwoItemCount = @TwoItemCount + 1
    END
    
    IF ISNULL(@TwoItemCount,0) < 2
    BEGIN
		SET @ValidationOrder = @ValidationOrder + 1
		INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
		SELECT 'CustomPsychiatricNoteProblems','Severity','General - Problem ' + CAST(@ProblemNumber AS VARCHAR(200)) + ' - At least two items are required.',@TabOrder,@ValidationOrder
    END
	
	
	--IF (ISNULL(@ICD10Code,'') <> '' and  @ICD10Code in(SELECT 
	--	r.CharacterCodeId 
	--FROM Recodes r 
	--JOIN RecodeCategories rc  ON r.RecodeCategoryId = rc.RecodeCategoryId 
	--WHERE rc.CategoryCode IN ('XICD10RECODES')) and @DiscussLongActingInjectable is null)
 --   BEGIN
	--	SET @ValidationOrder = @ValidationOrder + 1
	--	INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
	--	SELECT 'CustomPsychiatricNoteProblems','SubjectiveText','Medical Decision Making - Problem ' + CAST(@ProblemNumber AS VARCHAR(200)) + ' - Did you discuss long acting injectable with client – is required.',@TabOrder,@ValidationOrder
	--END
    
    IF ISNULL(@LocationOther,'N') = 'Y' AND ISNULL(@LocationOtherText,'') = ''
    BEGIN
		SET @ValidationOrder = @ValidationOrder + 1
		INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
		SELECT 'CustomPsychiatricNoteProblems','LocationOtherText','General - Problem ' + CAST(@ProblemNumber AS VARCHAR(200)) + ' - Location Other Text is required when other is selected.',@TabOrder,@ValidationOrder
	END
	
	--IF ISNULL(@AssociatedSignsSymptoms,0) > 0
 --   BEGIN
	--	SELECT TOP 1 @AssociatedSymptomsText = CodeName FROM GlobalCodes WHERE GlobalCodeId = @AssociatedSignsSymptoms
	--	IF ISNULL(@AssociatedSymptomsText,'') = 'Other' AND ISNULL(@AssociatedSignsSymptomsOtherText,'') = ''
	--	BEGIN
	--		SET @ValidationOrder = @ValidationOrder + 1
	--		INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
	--		SELECT 'CustomPsychiatricNoteProblems','AssociatedSignsSymptomsOtherText','Genral - Subjective ' + CAST(@ProblemNumber AS VARCHAR(200)) + ' - Associated Signs/Symptoms comment is required when Other is selected.',@TabOrder,@ValidationOrder
	--	END
	--END
    
    FETCH NEXT FROM FA_cursor INTO @SubjectiveText ,@TypeOfProblem , @Severity,@Duration,@TimeOfDayAllday,@TimeOfDayMorning ,@TimeOfDayAfternoon ,@TimeOfDayNight,@LocationHome ,@LocationSchool,@LocationWork,@LocationEveryWhere ,@LocationOther,@LocationOtherText,@AssociatedSignsSymptoms,@ModifyingFactors,@AssociatedSignsSymptomsOtherText,@ProblemStatus,
@DiscussLongActingInjectable, @ProblemMDMComments,@ICD10Code,@ContextText
END

CLOSE FA_cursor
DEALLOCATE FA_cursor


	

SELECT * FROM @validationReturnTable

IF @@error <> 0
	GOTO error

RETURN

error:

RAISERROR ( 'csp_ValidateCustomPsychiatricNoteSubjective failed.  Please contact your system administrator.',16,1)



--Select * From documentvalidations where documentcodeid=60000