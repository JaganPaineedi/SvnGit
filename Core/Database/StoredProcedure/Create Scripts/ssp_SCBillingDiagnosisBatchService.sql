/****** Object:  StoredProcedure [dbo].[ssp_SCBillingDiagnosisBatchService]    Script Date: 07/14/2016 17:52:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCBillingDiagnosisBatchService]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCBillingDiagnosisBatchService]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCBillingDiagnosisBatchService]    Script Date: 07/14/2016 17:52:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCBillingDiagnosisBatchService] @Services XML,@UserCode VARCHAR(30) = NULL
AS
/****************************************************************************/
/* Stored Procedure: ssp_SCBillingDiagnosisGroupService                      */
/* Copyright: 2006 Streamline Healthcare Solutions                           */
/* Purpose: To Initialize batch Service Billing Diagnosis                   */
/* Input Parameters:      @Services                                        */
/* Output Parameters:None                                                   */
/* Return:                                                                  */
/* Calls:                                                                   */
/* Called From:                                                             */
/* Data Modifications:                                                      */
/*                                                                          */
/*-------------Modification History--------------------------               */
/*-------Date-----------Author------------Purpose---------------------------*/
/*       19-JUNE-2015    Dhanil          task #1290 Philhaven customization issues*/
/*       14-JULY-2016    Akwinass        Included @UserCode (Task #52 in The ARC - Environment Issues Tracking)*/
/*       08-NOV-2016     Akwinass        Modified the code to avoid duplicates. (Task #2327 in Core Bugs)*/
/****************************************************************************/
BEGIN
	BEGIN TRY
	
		DECLARE @DynamicSQL VARCHAR(MAX)	
	SET @DynamicSQL = ' CREATE TABLE #ServiceDiagnoses(DSMCode char(6), DSMNumber int, SortOrder int,[Version] int,DiagnosisOrder int, DSMVCodeId VARCHAR(20),ICD10Code VARCHAR(20),ICD9Code VARCHAR(20),[Description] VARCHAR(MAX),[Order] INT)'
	SET @DynamicSQL = @DynamicSQL + CHAR(13)+CHAR(10) +' DECLARE @ServiceId INT'
	SET @DynamicSQL = @DynamicSQL + CHAR(13)+CHAR(10) +' CREATE TABLE #GroupServiceBillingDiagnosis(ServiceDiagnosisId INT IDENTITY(1,1),ServiceId INT,DSMCode VARCHAR(20),DSMNumber INT,DSMVCodeId VARCHAR(20),ICD10Code VARCHAR(20),ICD9Code VARCHAR(20),[Description] VARCHAR(MAX),[Order] INT)'
	
	SELECT @DynamicSQL = COALESCE(@DynamicSQL + CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10), '') + CAST(' SET @ServiceId = '+a.b.value('ServiceId[1]', 'VARCHAR(25)')+CHAR(13)+CHAR(10)+' INSERT INTO #ServiceDiagnoses(DSMCode, DSMNumber, SortOrder,[Version],DiagnosisOrder, DSMVCodeId,ICD10Code,ICD9Code,[Description],[Order])'+CHAR(13)+CHAR(10)+' EXEC ssp_SCBillingDiagnosiServiceNote @varClientId = ' + a.b.value('ClientId[1]', 'VARCHAR(25)') + ',' + case when a.b.value('xs:dateTime(DateOfService[1])', 'DATETIME') IS NOT NULL then '@varDate = ''' + CAST(a.b.value('xs:dateTime(DateOfService[1])', 'DATETIME') AS VARCHAR(100)) +'''' else '@varDate = NULL' end  +',@varProgramId = ' + a.b.value('ProgramId[1]', 'VARCHAR(25)') AS VARCHAR(MAX)) +CHAR(13)+CHAR(10)+' INSERT INTO #GroupServiceBillingDiagnosis(ServiceId,DSMCode,DSMNumber,DSMVCodeId,ICD10Code,ICD9Code,[Description],[Order])'+CHAR(13)+CHAR(10)+' SELECT @ServiceId,DSMCode,DSMNumber,DSMVCodeId,ICD10Code,ICD9Code,[Description],[Order] FROM #ServiceDiagnoses'+CHAR(13)+CHAR(10)+' DELETE FROM #ServiceDiagnoses'
	FROM @Services.nodes('BillingDiagnosis/Services') a(b)
	
	SET @DynamicSQL = @DynamicSQL + CHAR(13)+CHAR(10) + CHAR(13)+CHAR(10) +' insert into ServiceDiagnosis(CreatedBy,ModifiedBy,ServiceId,
DSMCode,
DSMNumber,
DSMVCodeId,
ICD10Code,
ICD9Code,
[Order]) SELECT distinct '''+@UserCode+''','''+@UserCode+''',ServiceId,DSMCode,DSMNumber,DSMVCodeId,ICD10Code,ICD9Code,[Order] FROM #GroupServiceBillingDiagnosis  sd where sd.ServiceId >0 and  sd.ServiceId not in(select bd.ServiceId from  ServiceDiagnosis bd )  '
	SET @DynamicSQL = @DynamicSQL + CHAR(13)+CHAR(10) + CHAR(13)+CHAR(10) +'  DELETE FROM #ServiceDiagnoses' +'  DROP TABLE #GroupServiceBillingDiagnosis'
	SET @DynamicSQL = @DynamicSQL + CHAR(13)+CHAR(10) +' DROP TABLE #ServiceDiagnoses'
		
	EXEC (@DynamicSQL)


	END TRY

	BEGIN CATCH
		IF (@@error != 0)
		BEGIN
			RAISERROR 20006 'ssp_SCBillingDiagnosisBatchService: An Error Occured'

			RETURN
		END
	END CATCH
END

GO


