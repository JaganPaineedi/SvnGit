/****** Object:  StoredProcedure [dbo].[ssp_SCBillingDiagnosisGroupService]    Script Date: 03/12/2015 18:17:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCBillingDiagnosisGroupService]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCBillingDiagnosisGroupService]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCBillingDiagnosisGroupService]    Script Date: 03/12/2015 18:17:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCBillingDiagnosisGroupService] @Services XML,
@GroupServiceDate varchar(100) = Null
AS
/****************************************************************************/
/* Stored Procedure: ssp_SCBillingDiagnosisGroupService                      */
/* Copyright: 2006 Streamline Healthcare Solutions                           */
/* Author: Akwinass                                                         */
/* Creation Date:  Mar 19,2015                                              */
/* Purpose: To Initialize Group Service Billing Diagnosis                   */
/* Input Parameters:      @Services                                        */
/* Output Parameters:None                                                   */
/* Return:                                                                  */
/* Calls:                                                                   */
/* Called From:                                                             */
/* Data Modifications:                                                      */
/*                                                                          */
/*-------------Modification History--------------------------               */
/*-------Date-----------Author------------Purpose---------------------------*/
/*       19-MAR-2015    Akwinass          Created(Task# 1419 in Engineering Improvement Initiatives- NBL(I)).*/
/*       24-MAR-2015    Akwinass          Node Exist Check Implemented(Task# 1419 in Engineering Improvement Initiatives- NBL(I)).*/
/*       05-OCT-2015    Akwinass          Implemented NULL check for Date of Service (Task# 1917 in Core Bugs).*/
/*       01-Jan-2017    Hemant Kumar      What:Included the @GroupServiceDate parameter to fix the Billing Diagnosis initialization issue.
										  Why: It's pulling the most recent diagnosis for a member rather than taking 
										  into account the date of the group service and pulling in the diagnosis 
										  that was primary for that member on that particular date.
										  Project:Thresholds - Support #581
*/
/****************************************************************************/
BEGIN
	BEGIN TRY
	
	DECLARE @DynamicSQL VARCHAR(MAX)	
	SET @DynamicSQL = ' CREATE TABLE #ServiceDiagnoses(DSMCode char(6), DSMNumber int, SortOrder int,[Version] int,DiagnosisOrder int, DSMVCodeId VARCHAR(20),ICD10Code VARCHAR(20),ICD9Code VARCHAR(20),[Description] VARCHAR(MAX),[Order] INT)'
	SET @DynamicSQL = @DynamicSQL + CHAR(13)+CHAR(10) +' DECLARE @ServiceId INT'
	SET @DynamicSQL = @DynamicSQL + CHAR(13)+CHAR(10) +' CREATE TABLE #GroupServiceBillingDiagnosis(ServiceDiagnosisId INT IDENTITY(1,1),ServiceId INT,DSMCode VARCHAR(20),DSMNumber INT,DSMVCodeId VARCHAR(20),ICD10Code VARCHAR(20),ICD9Code VARCHAR(20),[Description] VARCHAR(MAX),[Order] INT)'
	
	SELECT @DynamicSQL = COALESCE(@DynamicSQL + CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10), '') + CAST(' SET @ServiceId = '+a.b.value('ServiceId[1]', 'VARCHAR(25)')+CHAR(13)+CHAR(10)+' INSERT INTO #ServiceDiagnoses(DSMCode, DSMNumber, SortOrder,[Version],DiagnosisOrder, DSMVCodeId,ICD10Code,ICD9Code,[Description],[Order])'+CHAR(13)+CHAR(10)+' EXEC ssp_SCBillingDiagnosiServiceNote @varClientId = ' + a.b.value('ClientId[1]', 'VARCHAR(25)') + ',' + case when a.b.value('xs:dateTime(DateofService[1])', 'DATETIME') IS NOT NULL then '@varDate = ''' + CAST(a.b.value('xs:dateTime(DateofService[1])', 'DATETIME') AS VARCHAR(100)) +'''' else '@varDate = '''+ @GroupServiceDate +'''' end +',@varProgramId = ' + a.b.value('ProgramId[1]', 'VARCHAR(25)') AS VARCHAR(MAX)) +CHAR(13)+CHAR(10)+' INSERT INTO #GroupServiceBillingDiagnosis(ServiceId,DSMCode,DSMNumber,DSMVCodeId,ICD10Code,ICD9Code,[Description],[Order])'+CHAR(13)+CHAR(10)+' SELECT @ServiceId,DSMCode,DSMNumber,DSMVCodeId,ICD10Code,ICD9Code,[Description],[Order] FROM #ServiceDiagnoses'+CHAR(13)+CHAR(10)+' DELETE FROM #ServiceDiagnoses'
	FROM @Services.nodes('BillingDiagnosis/Services') a(b)
	
	SET @DynamicSQL = @DynamicSQL + CHAR(13)+CHAR(10) + CHAR(13)+CHAR(10) +' SELECT (ServiceDiagnosisId * -1) AS ServiceDiagnosisId,ServiceId,DSMCode,DSMNumber,DSMVCodeId,ICD10Code,ICD9Code,[Order],[Description] FROM #GroupServiceBillingDiagnosis'
	SET @DynamicSQL = @DynamicSQL + CHAR(13)+CHAR(10) + CHAR(13)+CHAR(10) +' DROP TABLE #GroupServiceBillingDiagnosis'
	SET @DynamicSQL = @DynamicSQL + CHAR(13)+CHAR(10) +' DROP TABLE #ServiceDiagnoses'
   		
	EXEC (@DynamicSQL)
	
	END TRY

	BEGIN CATCH
		IF (@@error != 0)
		BEGIN
			
			RAISERROR ('ssp_SCBillingDiagnosisGroupService: An Error Occured While Updating ',16,1);

			RETURN
		END
	END CATCH
END

GO