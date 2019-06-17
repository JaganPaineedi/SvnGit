--Validation scripts for Suicide Risk Assessment
/******************************************************************************** 

-- *****History****  
/*       Date           Author				Purpose                   */
/*       14/Oct/2015	Seema        		For Validation to use 
											DocumentValidations table */
		 11/Feb/2016	Seema		    	Checking for SuicideRiskAssessmentNotDone
											Why : Meaningful Use Stage 2  task : #47											
*********************************************************************************/
DELETE
FROM DocumentValidations WHERE DocumentCodeId = 1636 and TableName = 'SuicideRiskAssessmentDocuments'

IF NOT EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1636 and ErrorMessage='Suicide - Details is required' and TableName = 'SuicideRiskAssessmentDocuments')
BEGIN
INSERT [dbo].[DocumentValidations] ([Active], [DocumentCodeId], [DocumentType], [TabName], [TabOrder], [TableName], [ColumnName], [ValidationLogic], [ValidationDescription], [ValidationOrder], [ErrorMessage]) VALUES (N'Y', 1636, NULL, N'Suicide Risk Assessment', 1, N'SuicideRiskAssessmentDocuments', N'SuicideBehaviorsPastHistory', N'FROM SuicideRiskAssessmentDocuments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(SuicideCurrent,''N'')=''Y'' AND ISNULL(SuicideBehaviorsPastHistory,'''')='''' AND ISNULL(SuicideRiskAssessmentNotDone,''N'') = ''N'' AND  ISNULL(RecordDeleted,''N'') = ''N''', 'Suicide – Details is required', CAST(1 AS Decimal(18, 0)), 'Details is required')
END

IF NOT EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1636 and ErrorMessage='Suicide - Clinical Response is required' and TableName = 'SuicideRiskAssessmentDocuments')
BEGIN
INSERT [dbo].[DocumentValidations] ([Active], [DocumentCodeId], [DocumentType], [TabName], [TabOrder], [TableName], [ColumnName], [ValidationLogic], [ValidationDescription], [ValidationOrder], [ErrorMessage]) VALUES (N'Y', 1636, NULL, N'Suicide Risk Assessment', 2, N'SuicideRiskAssessmentDocuments', N'SuicideClinicalResponse', N'FROM SuicideRiskAssessmentDocuments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(SuicideCurrent,''N'')=''Y'' AND ISNULL(SuicideClinicalResponse,'''')='''' AND ISNULL(SuicideRiskAssessmentNotDone,''N'') = ''N'' AND  ISNULL(RecordDeleted,''N'') = ''N''', 'Suicide - Clinical Response is required', CAST(1 AS Decimal(18, 0)), 'Clinical Response is required')
END