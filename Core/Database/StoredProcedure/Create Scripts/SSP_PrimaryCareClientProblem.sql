IF EXISTS (
		SELECT *
		FROM sysobjects
		WHERE type = 'P'
			AND NAME = 'SSP_PrimaryCareClientProblem'
		)
BEGIN
	DROP PROCEDURE SSP_PrimaryCareClientProblem
END
GO

CREATE PROCEDURE SSP_PrimaryCareClientProblem @clientId INT
	,@staffid INT
AS
/************************************************************************************/
/* Stored Procedure: dbo.[SSP_PrimaryCareClientProblem]12,93      */
/* Copyright: 2012 Streamline Healthcare Solutions,  LLC       */
/* Creation Date:   08/08/2012                 */
/*                        */
/* Input Parameters: @clientId,@staffid           */
/*                     */
/* Output Parameters:   None              */
/*                     */
/* Return:  0=success, otherwise an error number         */
/*                     */
/* Called By:                  */
/*                     */
/* Calls:                   */
/*                     */
/* Data Modifications:                */
/*                     */
/* Updates:                   */
/*  Date           Author     Purpose            */
/* 10-04-2012      Sunil Kh    Created          */
/* 24 Dec, 2012    Rakesh-II    only recommitting this  ssp As it was not delivered For CentraWellness w r t task 396 in   centra wellness/ Bugs Features  */
/* 21-Feb, 2013    Rakesh Garg  Modified As Problems are not populating on PC Client Summary Change Join from DiagnosisDSMDescriptions to table DiagnosisICDCodes */
/* 22-Feb,2013	   Vikas Kashyap Added condition For RecordDeleted check and EndDate IS NULL 	*/
/* 28-May-2013	   Munish Sood - Changed Created Date to Start Date */
/* 27-August-2015  Jayashree Behere- Added ICD10Code,ICD9Code  w.r.t Diagnosis Changes (ICD10) #10*/
/************************************************************************************/
BEGIN
	BEGIN TRY
		SELECT CP.StartDate AS CreatedDate
			,CP.ICD10Code
			,CP.DSMCode
			,DSM.ICDDescription AS DSMDescription
			,GC.CodeName AS ProblemType
			,CP.SNOMEDCODE AS SNOMEDCODE
			,SNC.SNOMEDCTDescription AS SNOMEDCTDescription
		FROM ClientProblems CP
		LEFT JOIN DiagnosisICD10Codes DSM ON CP.ICD10CodeId = DSM.ICD10CodeId
		LEFT JOIN SNOMEDCTCodes AS SNC ON SNC.SNOMEDCTCode = CP.SNOMEDCODE
		--AND CP.DSMNumber=DSM.DSMNumber AND CP.Axis=DSM.Axis  
		LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = CP.ProblemType
		WHERE CP.ClientId = @clientId
			AND ISNULL(CP.RecordDeleted, 'N') = 'N'
			AND (
				CP.EndDate IS NULL
				OR CONVERT(DATE, CP.EndDate, 101) > CONVERT(DATE, GETDATE(), 101)
				)
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'SSP_PrimaryCareClientProblem') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	END CATCH

	RETURN
END
GO


