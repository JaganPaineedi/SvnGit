/****** Object:  StoredProcedure [dbo].[ssp_SCGetSOCFunctionalCognitiveDetails]     ******/
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.ROUTINES
		WHERE SPECIFIC_SCHEMA = 'dbo'
			AND SPECIFIC_NAME = 'ssp_SCGetSOCFunctionalCognitiveDetails'
		)
	DROP PROCEDURE [dbo].[ssp_SCGetSOCFunctionalCognitiveDetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetSOCFunctionalCognitiveDetails]     ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetSOCFunctionalCognitiveDetails] @ClientId INT
	,@Startdate DATE
	,@EndDate DATE
	,@Type CHAR(1)
	,@DocumentVersionId INT
AS /*********************************************************************/
/* Stored Procedure: dbo.ssp_SCGetSOCFunctionalCognitiveDetails            */
/* Creation Date:    22/Aug/2017                */
/* Purpose:  To Get summary Of care Functional, Cognitive ,Assessment and Plan of Treatment                */
/*    Exec ssp_SCGetSOCFunctionalCognitiveDetails                                              */
/* Input Parameters:                           */
/* Date   Author   Purpose              */
/* 22/Aug/2017  Gautam   Created           Certification MU3   */
/*
 12/Dec/2017	Ravichandra	changes done for new requirement 
							Meaningful Use Stage 3 task 68 - Summary of Care    */
/*********************************************************************/
BEGIN
	BEGIN TRY
		CREATE TABLE #FunctionalCognitiveDetails (
			EffectiveDate DATE
			,Question VARCHAR(300)
			,answer VARCHAR(max)
			,OrderName VARCHAR(500)
			,SNOMEDCode VARCHAR(50)
			,AgencyName VARCHAR(250)
			,[Address] VARCHAR(100)
			,City VARCHAR(30)
			,[State] VARCHAR(2)
			,ZipCode VARCHAR(12)
			,MainPhone VARCHAR(50)
			)

		IF EXISTS (
				SELECT *
				FROM sys.objects
				WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetSOCFunctionalCognitiveDetails]')
					AND type IN (
						N'P'
						,N'PC'
						)
				)
		BEGIN
			EXEC csp_SCGetSOCFunctionalCognitiveDetails @ClientId
				,@Startdate
				,@EndDate
				,@Type
				,@DocumentVersionId
		END

		SELECT EffectiveDate
			,Question
			,answer
			,OrderName
			,SNOMEDCode
			,AgencyName
			,[Address]
			,City
			,[State]
			,ZipCode
			,MainPhone
		FROM #FunctionalCognitiveDetails
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(max)

		SET @Error = convert(VARCHAR, error_number()) + '*****' + convert(VARCHAR(4000), error_message()) + '*****' + isnull(convert(VARCHAR, error_procedure()), 'ssp_SCGetSOCFunctionalCognitiveDetails') + '*****' + convert(VARCHAR, error_line()) + '*****' + convert(VARCHAR, error_severity()) + '*****' + convert(VARCHAR, error_state())

		RAISERROR (
				@Error
				,
				-- Message text.                           
				16
				,
				-- Severity.                                                                                                             
				1
				-- State.                                                                                                             
				);
	END CATCH
END
