/****** Object:  StoredProcedure [dbo].[ssp_NoteSystemTagGetCurrentProblems]    Script Date: 03/13/2013 16:19:27 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_NoteSystemTagGetOrderedProblems]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_NoteSystemTagGetOrderedProblems]
GO

CREATE PROCEDURE [dbo].[ssp_NoteSystemTagGetOrderedProblems]
	/*********************************************************************************/
	-- Copyright: Streamline Healthcate Solutions                      
	--                      
	-- Purpose: Customization support for Reception list page depending on the custom filter selection.                      
	--                      
	-- Author:  Vaibhav khare                      
	-- Date:    20 May 2011             
	-- Jay Wheeler Changed to only pull records with a start date of today for ordered problems.               
	--                      
	-- *****History****                      
	/* 2012-09-21   Vaibhav khare  Created          */
	/* 2013-03-21    New two parameters added by Deej. As per the discussion with Wasif*/
	/* 2014-07-25 Adding new logic for New problem popup */
	/* 2015-04-27  Adding logic for displaying Diagnosis Order */
	--03 Sep  2015  vkhare   Modified for ICD10 changes                  
	/*********************************************************************************/
	@ClientId INT
	,@EffectiveDate VARCHAR(50)
	,@DocumentId INT
AS
BEGIN
	BEGIN TRY
		--- Get the most current problems list              
		CREATE TABLE #ProblemsResults (
			ICD9Code VARCHAR(25) NULL
			,ICDDescription VARCHAR(500) NULL
			,ProblemStatus VARCHAR(500) NULL
			,SpanText VARCHAR(2000) NULL
			,ProblemOrder INT
			)

		DECLARE @CurrentDocumentVersionId INT

		SELECT @CurrentDocumentVersionId = CurrentDocumentVersionId
		FROM documents
		WHERE documentid = @DocumentId

		INSERT INTO #ProblemsResults (
			ICD9Code
			,ICDDescription
			,ProblemStatus
			,SpanText
			,ProblemOrder
			)
		SELECT ISNULL(b.ICD10Code, CPDH.DSMCode)
			,IsNull(b.ICDDescription, DICO.ICDDescription)
			,c.SubCodeName
			,'<span contenteditable="False"            
    isNew=' + CASE 
				WHEN ISNULL(CPDH.NewProblem, '') = 'Y'
					THEN '"Yes"'
				ELSE '"No"'
				END + ' problemStatus="' + ISNULL(CAST(CPDH.ProblemStatus AS VARCHAR(50)), '') + '"' + ' diagnosisCode="' + ISNULL(CAST(CPDH.DSMCode AS VARCHAR(50)), '') + '" ></span>'
			,CPDH.DiagnosisOrder
		FROM ClientProblemsDiagnosisHistory CPDH
		LEFT JOIN DiagnosisICD10Codes b ON CPDH.ICD10CodeId = b.ICD10CodeId
		LEFT JOIN DiagnosisICDCodes DICO ON CPDH.DSMCode = DICO.ICDCode
		LEFT JOIN GlobalSubCodes c ON CPDH.ProblemStatus = c.GlobalSubCodeId
		WHERE CPDH.DocumentVersionId = @CurrentDocumentVersionId
			AND CPDH.AddToNote = 'Y'
			--and  CAST(ISNULL(a.StartDate,DATEADD(DAY,1,GETDATE())) AS DATE)  =  CAST(GETDATE() AS DATE)     -- MJW Per Stefanie, start date = today is an ordered problem          
			--and  CAST(ISNULL(a.EndDate,DATEADD(DAY,1,GETDATE())) AS DATE)  <  CAST(GETDATE() AS DATE)               
			AND ISNULL(CPDH.RecordDeleted, 'N') = 'N'

		-- Build Final String              
		DECLARE @ICD9Code VARCHAR(500)
			,@ICDDescription VARCHAR(500)
			,@SpanText VARCHAR(2000)
			,@ProblemOrder INT
		DECLARE @ProblemStatus VARCHAR(500)
		DECLARE @FinalString VARCHAR(max)

		SET @FinalString = '<span><b>Ordered Problems</b> </span><span taggroup="diagnosis">'

		DECLARE cur_Problems CURSOR
		FOR
		--order by case ProblemType when  'Major' then 1 when 'Minor' then 2 else 3 end              
		SELECT ICD9Code
			,ICDDescription
			,UPPER(ProblemStatus)
			,SpanText
			,ProblemOrder
		FROM #ProblemsResults

		OPEN cur_Problems

		FETCH cur_Problems
		INTO @ICD9Code
			,@ICDDescription
			,@ProblemStatus
			,@SpanText
			,@ProblemOrder

		WHILE @@FETCH_STATUS = 0
		BEGIN
			DECLARE @ProblemText VARCHAR(100)

			IF @ProblemStatus = ''
				OR @ProblemStatus IS NULL
				SET @ProblemText = ''
			ELSE
				SET @ProblemText = ' - ' + isnull(@ProblemStatus, '')

			SET @FinalString = @FinalString + '<br>'
			SET @FinalString = @FinalString + ISNULL(CAST(@ProblemOrder AS VARCHAR(50)), '') + CASE 
					WHEN @ProblemOrder IS NULL
						THEN ''
					ELSE ' - '
					END + isnull(@ICDDescription, '') + ' : ' + isnull(@ICD9Code, '') + @ProblemText
			SET @FinalString += @SpanText

			-- set @LastProblemType = @ProblemType              
			FETCH cur_Problems
			INTO @ICD9Code
				,@ICDDescription
				,@ProblemStatus
				,@SpanText
				,@ProblemOrder
		END

		IF @FinalString IS NULL
			SET @FinalString = 'None'

		CLOSE cur_Problems

		DEALLOCATE cur_Problems

		SELECT '<span style=''color:black''>' + @FinalString + '</span></span>' AS 'name'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_NoteSystemTagGetCurrentProblems') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                           
				16
				,-- Severity.                                    
				1 -- State.                                    
				);
	END CATCH

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
	/*    
    
exec ssp_NoteSystemTagGetOrderedProblems 29934    
*/
