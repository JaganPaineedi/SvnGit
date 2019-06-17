/****** Object:  StoredProcedure [dbo].[csp_PostSignatureUpdatePsychiatricNote ]    Script Date: 07/07/2015 16:26:11 ******/
IF EXISTS (
		SELECT * 
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_PostSignatureUpdatePsychiatricNote ]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_PostSignatureUpdatePsychiatricNote]
GO

/****** Object:  StoredProcedure [dbo].[csp_PostSignatureUpdatePsychiatricNote] 737593    Script Date: 26/07/2015 16:26:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_PostSignatureUpdatePsychiatricNote ]  (
	 @DocumentVersionId int                          
	)
AS

BEGIN
DECLARE @ServiceId INT
DECLARE @NextphysicianComment VARCHAR(250)
DECLARE @Servicecomment VARCHAR(250)
DECLARE @MedicationReconciliation CHAR(1)
DECLARE @EffectiveDate datetime 
DECLARE @ClientId int  
DECLARE @CreatedBy VARCHAR(500)

SELECT TOP 1 
@ClientId=d.ClientId,
@EffectiveDate=CONVERT(datetime, convert(varchar, d.EffectiveDate, 101)),
@CreatedBy = d.CreatedBy
From Documents d Join DocumentVersions dv ON Dv.DocumentId=d.DocumentId
Where dv.DocumentVersionId  =@DocumentVersionId

  
  SELECT @MedicationReconciliation=MedicationReconciliation 
  FROM CustomDocumentPsychiatricNoteMDMs 
  where DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted, 'N') = 'N'
         
       IF(@MedicationReconciliation='Y')
       BEGIN
       IF EXISTS(SELECT 1 FROM ClientHealthDataAttributes where ClientId=@ClientId AND Cast(HealthRecordDate AS DATE)=CAST(@EffectiveDate AS DATE) AND  ISNULL(RecordDeleted, 'N') = 'N')
       BEGIN
       UPDATE  ClientHealthDataAttributes SET Value='Y' where ClientId=@ClientId and Cast(HealthRecordDate AS DATE)=CAST(@EffectiveDate AS DATE) and  HealthDataAttributeId=125 and HealthDataSubTemplateId=118 AND  ISNULL(RecordDeleted, 'N') = 'N'
       END
       END
       

SET @ServiceId=(SELECT ServiceId FROM Documents WHERE CurrentDocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,'N')<>'Y')
SET @NextphysicianComment=(SELECT NextPhysicianVisit FROM CustomDocumentPsychiatricNoteMDMs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,'N')<>'Y')

IF (@ServiceId >0 AND @NextphysicianComment IS NOT NULL)
BEGIN
    UPDATE Services SET Comment=@NextphysicianComment + ' '+ cast(ISNULL(Comment,'') as varchar) WHERE ServiceId=@ServiceId
END

EXEC csp_PostSignatureCustomDiagnosis @DocumentVersionId

END