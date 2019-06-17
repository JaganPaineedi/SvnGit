IF OBJECT_ID('ssp_GETCurrentProblems','P') IS NOT NULL
DROP PROCEDURE [dbo].[ssp_GETCurrentProblems]
GO

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[ssp_GETCurrentProblems] @ClientId INT
	,@DocumentId INT
	,@EffectiveDate VARCHAR(50)
	/*********************************************************************************/
	/* Stored Procedure: ssp_GETClientProblems           */
	/* Copyright: Streamline Healthcare Solutions          */
	/* Creation Date:  2012-09-21              */
	/* Purpose: Populates Progress Note Template list page         */
	/* Input Parameters:@SessionId,@InstanceId,@PageNumber,@PageSize,@SortExpression,*/
	/*      @Active,@TagTypeId ,@Others      */
	/* Return:                      */
	/*       */
	/* Calls:                   */
	/* Data Modifications:                */
	/* Updates:                   */
	/* Date              Author         Purpose          */
	/* 2012-09-21   Vaibhav khare  Created          */
	/* 2014-04-22 Chuck Blaine  Added left join to GlobalSubCodes in order to pull the current status of the problem instead of hard-coding 'Stable'*/
	/* 2014-06-30 Wasif Butt   Removed filtereing for problems on note and added effective date match between start and end date */
	/* 2014-07-01   Gautam    Selected distinct DSMCode and Diagnosis should be less than current date  Req. for Primary Care - Summit Pointe 181         */
	/* 2014-07-25 Added new logic based on  New client problem popup */
	/*2014-08-01 Was adding One row every time in Progress note */
	/* JAN-29-2015  dharvey  Added title on output when "None" is initialized */
	/* 2015-04-27  Adding logic for displaying Diagnosis Order */
	--03 Sep  2015  vkhare   Modified for ICD10 changes         
	/*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		DECLARE @temp VARCHAR(MAX)
		DECLARE @tempstart VARCHAR(MAX)

		SET @temp = '<b>Current Problems</b> <span taggroup="diagnosis">'
		SET @tempstart = @temp

		SELECT @temp = COALESCE(@temp, '') + '<span contenteditable=''False''          
   major=' + CASE 
				WHEN CP.ProblemType = '8151'
					THEN '"Yes"'
				ELSE '"No"'
				END + ' additionalWorkup=' + CASE 
				WHEN CP.AdditionalWorkUp = 'Y'
					THEN '"Yes"'
				ELSE '"No"'
				END + ' isNew=' + CASE 
				WHEN CP.NewProblem = 'Y'
					THEN '"Yes"'
				ELSE '"No"'
				END + ' addToNote=' + CASE 
				WHEN CP.AddToNote = 'Y'
					THEN '"Yes"'
				ELSE '"No"'
				END + ' problemStatus="' + CASE 
				WHEN cp.ProblemStatus IS NULL
					THEN ''
				ELSE ISNULL(gsc.SubCodeName, '')
				END + '"' + ' diagnosisCode="' + IsNull(cp.ICD10Code, cp.DSMCode) + '" > ' + '<br>' + CASE 
				WHEN CP.DiagnosisOrder IS NULL
					THEN ''
				ELSE CAST(CP.DiagnosisOrder AS VARCHAR(50)) + ' - '
				END + IsNUll(DIC.ICDDescription, DICO.ICDDescription) + ' : ' + IsNull(cp.ICD10Code, cp.DSMCode) + '</span>'
		FROM (
			SELECT DISTINCT ClientId
				,ProblemType
				,AdditionalWorkUp
				,NewProblem
				,AddToNote
				,ProblemStatus
				,ClientProblems.ICD10CodeId
				,ClientProblems.DiagnosisOrder
				,ClientProblems.ICD10Code
				,ClientProblems.DSMCode
			FROM ClientProblems
			WHERE ClientId = @ClientId
				AND ISNULL(RecordDeleted, 'N') = 'N'
				AND ISNULL(Discontinue, 'N') = 'N'
				AND CAST(@effectiveDate AS DATETIME) BETWEEN ISNULL(DATEADD(DAY, - 1, StartDate), DATEADD(DAY, - 1, GETDATE()))
					AND ISNULL(DATEADD(DAY, - 1, EndDate), DATEADD(DAY, 1, GETDATE()))
			--AND convert(VARCHAR(10), StartDate, 101) <= convert(VARCHAR(10), @EffectiveDate, 101)    
			--AND (    
			-- EndDate IS NULL    
			-- OR convert(VARCHAR(10), EndDate, 101) >= convert(VARCHAR(10), @EffectiveDate, 101)    
			-- )    
			--AND CAST(ISNULL(StartDate, DATEADD(DAY, 1, GETDATE())) AS DATE) < CAST(GETDATE() AS DATE)    
			GROUP BY ProblemType
				,AdditionalWorkUp
				,NewProblem
				,AddToNote
				,ProblemStatus
				,ClientProblems.ICD10CodeId
				,ClientId
				,ClientProblems.DiagnosisOrder
				,ClientProblems.ICD10Code
				,ClientProblems.DSMCode
			) CP
		LEFT JOIN DiagnosisICD10Codes DIC ON CP.ICD10Codeid = DIC.ICD10CodeId
		LEFT JOIN DiagnosisICDCodes DICO ON CP.DSMCode = DICO.ICDCode
		LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = CP.ProblemType
		LEFT JOIN dbo.GlobalSubCodes AS gsc ON gsc.GlobalSubCodeId = cp.ProblemStatus
		WHERE CP.ClientId = @ClientId
			AND CP.ProblemType = 8151

		IF LEN(@temp) > LEN(@tempstart)
			SELECT '<span style=''color:black''>' + @temp + '</span>'
		ELSE
			SELECT '<span style=''color:black''><b>Current Problems</b><br/>None</span>'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GETCurrentProblems') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


