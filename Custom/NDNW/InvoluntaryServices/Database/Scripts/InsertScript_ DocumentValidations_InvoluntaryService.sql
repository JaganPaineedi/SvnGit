/*
Insert script for Involuntary Services - Document - Validation Messgae
Author : Malathi Shiva
Created Date : 05/May/2015
Purpose : Task #36 - New Directions - Customizations
*/
DELETE
FROM DocumentValidations
WHERE DocumentCodeId = 28812
	AND TableName = 'CustomDocumentInvoluntaryServices'

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'28812'
	,NULL
	,'Involuntary Services'
	,'1'
	,'CustomDocumentInvoluntaryServices'
	,'SIDNumber'
	,'FROM CustomDocumentInvoluntaryServices WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(SIDNumber,-1)<=0 AND ISNULL(RecordDeleted,''N'')=''N'' '
	,'SID Number is required'
	,1
	,'SID Number is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'28812'
	,NULL
	,'Involuntary Services'
	,'1'
	,'CustomDocumentInvoluntaryServices'
	,'ServiceStatus'
	,'FROM CustomDocumentInvoluntaryServices WHERE DocumentVersionId=@DocumentVersionId	AND ISNULL(ServiceStatus,-1)<=0  AND ISNULL(RecordDeleted,''N'')=''N'''
	,'Service Status is required'
	,2
	,'Service Status is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'28812'
	,NULL
	,'Involuntary Services'
	,'1'
	,'CustomDocumentInvoluntaryServices'
	,'TypeOfPetition'
	,'FROM CustomDocumentInvoluntaryServices WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(TypeOfPetition,-1)<=0 AND ISNULL(RecordDeleted,''N'')=''N'' '
	,'Type of Petition/Notice of Mental Illness is required'
	,3
	,'Type of Petition/Notice of Mental Illness is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'28812'
	,NULL
	,'Involuntary Services'
	,'1'
	,'CustomDocumentInvoluntaryServices'
	,'DateOfPetition'
	,'FROM CustomDocumentInvoluntaryServices WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(DateOfPetition,'''')='''' AND ISNULL(RecordDeleted,''N'')=''N'' '
	,'Date of Petition/Notice of Mental Illness is required'
	,4
	,'Date of Petition/Notice of Mental Illness is required'
	)
INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'28812'
	,NULL
	,'Involuntary Services'
	,'1'
	,'CustomDocumentInvoluntaryServices'
	,'HearingRecommended'
	,'FROM CustomDocumentInvoluntaryServices WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(HearingRecommended,-1)<=0 AND ISNULL(RecordDeleted,''N'')=''N'' '
	,'Hearing Recommended is required'
	,5
	,'Hearing Recommended is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'28812'
	,NULL
	,'Involuntary Services'
	,'1'
	,'CustomDocumentInvoluntaryServices'
	,'ReasonForHearing'
	,'FROM CustomDocumentInvoluntaryServices WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(ReasonForHearing,-1)<=0 AND ISNULL(RecordDeleted,''N'')=''N''  '
	,'Reason for Hearing/Diversion Recommendation is required'
	,6
	,'Reason for Hearing/Diversion Recommendation is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'28812'
	,NULL
	,'Involuntary Services'
	,'1'
	,'CustomDocumentInvoluntaryServices'
	,'BasisForInvoluntaryServices'
	,'FROM CustomDocumentInvoluntaryServices WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(BasisForInvoluntaryServices,-1)<=0 AND (HearingRecommended IN (select GlobalCodeId from  GlobalCodes where Category =''XInHearingRecommend'' AND CodeName in (''No: Petition/Notice of Mental Illness Withdrawn'',''No: Client agrees to Voluntary Treatment'',''No: Lack of Probable Cause'',''No: 14 day Diversion'')AND ISNULL(RecordDeleted,''N'')=''N'')OR DispositionByJudge IN  (SELECT GlobalCodeId from  GlobalCodes where  Category =''XInDisposition''  AND CodeName in  (''Found not mentally ill'',''Dismissed'',''Conditionally released'') AND ISNULL(RecordDeleted,''N'')=''N'') ) AND ISNULL(RecordDeleted,''N'')=''N'''
	,'Basis for Involuntary Services is required'
	,7
	,'Basis for Involuntary Services is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'28812'
	,NULL
	,'Involuntary Services'
	,'1'
	,'CustomDocumentInvoluntaryServices'
	,'DispositionByJudge'
	,'FROM CustomDocumentInvoluntaryServices WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(DispositionByJudge,-1)<=0 AND HearingRecommended IN (select GlobalCodeId from  GlobalCodes where Category =''XInHearingRecommend'' AND  CodeName in (''No: Petition/Notice of Mental Illness Withdrawn'',''No: Client agrees to Voluntary Treatment'',''No: Lack of Probable Cause'',''No: 14 day Diversion'')AND ISNULL(RecordDeleted,''N'')=''N'') AND ISNULL(RecordDeleted,''N'')=''N''  '
	,'Disposition by Judge is required'
	,8
	,'Disposition by Judge is required'
	)

--INSERT INTO [dbo].[DocumentValidations] (
--	[Active]
--	,[DocumentCodeId]
--	,[DocumentType]
--	,[TabName]
--	,[TabOrder]
--	,[TableName]
--	,[ColumnName]
--	,[ValidationLogic]
--	,[ValidationDescription]
--	,[ValidationOrder]
--	,[ErrorMessage]
--	)
--VALUES (
--	'Y'
--	,'28812'
--	,NULL
--	,'Involuntary Services'
--	,'1'
--	,'CustomDocumentInvoluntaryServices'
--	,'InvoluntaryServicesCommitted'
--	,'FROM CustomDocumentInvoluntaryServices WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(InvoluntaryServicesCommitted,-1)<=0 AND ISNULL(RecordDeleted,''N'')=''N''  '
--	,'Committed is required'
--	,9
--	,'Committed is required'
--	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'28812'
	,NULL
	,'Involuntary Services'
	,'1'
	,'CustomDocumentInvoluntaryServices'
	,'ServiceSettingAssignedTo'
	,'FROM CustomDocumentInvoluntaryServices WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(ServiceSettingAssignedTo,-1)<=0 AND  (InvoluntaryServicesCommitted IN (SELECT GlobalCodeId FROM GlobalCodes WHERE Category =''XInCommitted'' AND CodeName=''Yes'' AND ISNULL(RecordDeleted,''N'')=''N'')) AND ISNULL(RecordDeleted,''N'')=''N''  '
	,'Service Setting Assigned To is required'
	,10
	,'Service Setting Assigned To is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'28812'
	,NULL
	,'Involuntary Services'
	,'1'
	,'CustomDocumentInvoluntaryServices'
	,'DateOfCommitment'
	,'FROM CustomDocumentInvoluntaryServices WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(DateOfCommitment,'''')='''' AND (InvoluntaryServicesCommitted IN (SELECT GlobalCodeId FROM GlobalCodes WHERE  Category =''XInCommitted'' AND CodeName=''Yes'' AND ISNULL(RecordDeleted,''N'')=''N'')) AND ISNULL(RecordDeleted,''N'')=''N'' '
	,'Date of Commitment is required'
	,11
	,'Date of Commitment is required'
	)
INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'28812'
	,NULL
	,'Involuntary Services'
	,'1'
	,'CustomDocumentInvoluntaryServices'
	,'DateOfCommitment'
	,'FROM CustomDocumentInvoluntaryServices WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(DateOfCommitment,'''') <> '''' AND DateOfCommitment < DateOfPetition  AND ISNULL(RecordDeleted,''N'')=''N'' '
	,'Date Of Commitment must be on or after the value in the "Date of Petition/Notice of Mental Illness" date field'
	,12
	,'Date Of CommitmentMust must be on or after the value in the "Date of Petition/Notice of Mental Illness" date field'
	)
	
INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'28812'
	,NULL
	,'Involuntary Services'
	,'1'
	,'CustomDocumentInvoluntaryServices'
	,'PeriodOfIntensiveTreatment'
	,'FROM CustomDocumentInvoluntaryServices WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(PeriodOfIntensiveTreatment,'''') <> '''' AND PeriodOfIntensiveTreatment < DateOfPetition  AND ISNULL(RecordDeleted,''N'')=''N'' '
	,'Last Date of 14-Day Period... must be on or after the value in the "Date of Petition/Notice of Mental Illness" date field'
	,13
	,'Last Date of 14-Day Period... must be on or after the value in the "Date of Petition/Notice of Mental Illness" date field'
	)
	
INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'28812'
	,NULL
	,'Involuntary Services'
	,'1'
	,'CustomDocumentInvoluntaryServices'
	,'LengthOfCommitment'
	,'FROM CustomDocumentInvoluntaryServices WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(LengthOfCommitment,-1)<=0 AND (InvoluntaryServicesCommitted IN (SELECT GlobalCodeId FROM GlobalCodes WHERE Category =''XInCommitted'' AND CodeName=''Yes'' AND ISNULL(RecordDeleted,''N'')=''N'')) AND ISNULL(RecordDeleted,''N'')=''N'' '
	,'Length of Commitment is required'
	,14
	,'Length of Commitment is required'
	)
	
--	INSERT INTO [dbo].[DocumentValidations] (
--	[Active]
--	,[DocumentCodeId]
--	,[DocumentType]
--	,[TabName]
--	,[TabOrder]
--	,[TableName]
--	,[ColumnName]
--	,[ValidationLogic]
--	,[ValidationDescription]
--	,[ValidationOrder]
--	,[ErrorMessage]
--	)
--VALUES (
--	'Y'
--	,'28812'
--	,NULL
--	,'Involuntary Services'
--	,'1'
--	,'CustomDocumentInvoluntaryServices'
--	,'LengthOfCommitment'
--	,'FROM CustomDocumentInvoluntaryServices WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(LengthOfCommitment,'''') <> '''' AND ISNULL(RecordDeleted,''N'')=''N'' '
--	,'Length of Commitment is required'
--	,14
--	,'Length of Commitment is required'
--	)