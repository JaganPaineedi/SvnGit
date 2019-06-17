--Validation scripts for PHQ9A
/******************************************************************************** 

-- *****History****  
/*       Date           Author				Purpose                   */
/*       21/Aug/2015	Vijay Yadav			For Validation to use 
											DocumentValidations table */
											
*********************************************************************************/

IF NOT EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1635 and ErrorMessage='Over the last weeks-Little interest/pleasure in doing things is required' and TableName = 'PHQ9Documents')
BEGIN
INSERT [dbo].[DocumentValidations] ([Active], [DocumentCodeId], [DocumentType], [TabName], [TabOrder], [TableName], [ColumnName], [ValidationLogic], [ValidationDescription], [ValidationOrder], [ErrorMessage]) VALUES (N'Y', 1635, NULL, N'PHQ9', 1, N'PHQ9Documents', N'LittleInterest', N'FROM PHQ9Documents WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(LittleInterest,'''')='''' AND  ISNULL(RecordDeleted,''N'') = ''N''', 'PHQ9 – Over the last weeks-Little interest/pleasure in doing things is required', CAST(1 AS Decimal(18, 0)), 'Over the last weeks-Little interest/pleasure in doing things is required')
END

IF NOT EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1635 and ErrorMessage='Over the last weeks-Feeling down/depressed/hopeless is required' and TableName = 'PHQ9Documents')
BEGIN
INSERT [dbo].[DocumentValidations] ([Active], [DocumentCodeId], [DocumentType], [TabName], [TabOrder], [TableName], [ColumnName], [ValidationLogic], [ValidationDescription], [ValidationOrder], [ErrorMessage]) VALUES (N'Y', 1635, NULL, N'PHQ9', 2, N'PHQ9Documents', N'FeelingDown', N'FROM PHQ9Documents WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(FeelingDown,'''')='''' AND  ISNULL(RecordDeleted,''N'') = ''N''', 'PHQ9 - Over the last weeks-Feeling down/depressed/hopeless is required', CAST(1 AS Decimal(18, 0)), 'Over the last weeks-Feeling down/depressed/hopeless is required')
END

IF NOT EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1635 and ErrorMessage='Over the last weeks-Trouble falling/staying awake is required' and TableName = 'PHQ9Documents')
BEGIN
INSERT [dbo].[DocumentValidations] ([Active], [DocumentCodeId], [DocumentType], [TabName], [TabOrder], [TableName], [ColumnName], [ValidationLogic], [ValidationDescription], [ValidationOrder], [ErrorMessage]) VALUES (N'Y', 1635, NULL, N'PHQ9', 3, N'PHQ9Documents', N'TroubleFalling', N'FROM PHQ9Documents WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(TroubleFalling,'''')='''' AND  ISNULL(RecordDeleted,''N'') = ''N''', 'Over the last weeks-Trouble falling/staying awake is required', CAST(1 AS Decimal(18, 0)), 'Over the last weeks-Trouble falling/staying awake is required')
END

IF NOT EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1635 and ErrorMessage='Over the last weeks-Feeling tired or having little energy is required' and TableName = 'PHQ9Documents')
BEGIN
INSERT [dbo].[DocumentValidations] ([Active], [DocumentCodeId], [DocumentType], [TabName], [TabOrder], [TableName], [ColumnName], [ValidationLogic], [ValidationDescription], [ValidationOrder], [ErrorMessage]) VALUES (N'Y', 1635, NULL, N'PHQ9', 4, N'PHQ9Documents', N'FeelingTired', N'FROM PHQ9Documents WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(FeelingTired,'''')=''''  AND  ISNULL(RecordDeleted,''N'') = ''N''', N'Over the last weeks-Feeling tired or having little energy is required', CAST(4 AS Decimal(18, 0)), N'Over the last weeks-Feeling tired or having little energy is required')
END

IF NOT EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1635 and ErrorMessage='Over the last weeks-Poor appetite/overeating is required' and TableName = 'PHQ9Documents')
BEGIN
INSERT [dbo].[DocumentValidations] ([Active], [DocumentCodeId], [DocumentType], [TabName], [TabOrder], [TableName], [ColumnName], [ValidationLogic], [ValidationDescription], [ValidationOrder], [ErrorMessage]) VALUES (N'Y', 1635, NULL, N'PHQ9', 5, N'PHQ9Documents', N'PoorAppetite', N'FROM PHQ9Documents WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(PoorAppetite,'''')=''''  AND  ISNULL(RecordDeleted,''N'') = ''N''', N'Over the last weeks-Poor appetite/overeating is required', CAST(5 AS Decimal(18, 0)), N'Over the last weeks-Poor appetite/overeating is required')
END

IF NOT EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1635 and ErrorMessage='Over the last weeks-Feeling bad about yourself is required' and TableName = 'PHQ9Documents')
BEGIN
INSERT [dbo].[DocumentValidations] ([Active], [DocumentCodeId], [DocumentType], [TabName], [TabOrder], [TableName], [ColumnName], [ValidationLogic], [ValidationDescription], [ValidationOrder], [ErrorMessage]) VALUES (N'Y', 1635, NULL, N'PHQ9', 6, N'PHQ9Documents', N'FeelingBad', N'FROM PHQ9Documents WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(FeelingBad,'''')=''''  AND  ISNULL(RecordDeleted,''N'') = ''N''', N'Over the last weeks-Feeling bad about yourself is required', CAST(6 AS Decimal(18, 0)), N'Over the last weeks-Feeling bad about yourself is required')
END

IF NOT EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1635 and ErrorMessage='Over the last weeks-Trouble concentrating is required' and TableName = 'PHQ9Documents')
BEGIN
INSERT [dbo].[DocumentValidations] ([Active], [DocumentCodeId], [DocumentType], [TabName], [TabOrder], [TableName], [ColumnName], [ValidationLogic], [ValidationDescription], [ValidationOrder], [ErrorMessage]) VALUES (N'Y', 1635, NULL, N'PHQ9', 7, N'PHQ9Documents', N'TroubleConcentrating', N'FROM PHQ9Documents WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(TroubleConcentrating,'''')=''''  AND  ISNULL(RecordDeleted,''N'') = ''N''', N'Over the last weeks-Trouble concentrating is required', CAST(7 AS Decimal(18, 0)), N'Over the last weeks-Trouble concentrating is required')
END

IF NOT EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1635 and ErrorMessage='Over the last weeks-Moving/speaking slowly is required' and TableName = 'PHQ9Documents')
BEGIN
INSERT [dbo].[DocumentValidations] ([Active], [DocumentCodeId], [DocumentType], [TabName], [TabOrder], [TableName], [ColumnName], [ValidationLogic], [ValidationDescription], [ValidationOrder], [ErrorMessage]) VALUES (N'Y', 1635, NULL, N'PHQ9', 8, N'PHQ9Documents', N'MovingOrSpeakingSlowly', N'FROM PHQ9Documents WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(MovingOrSpeakingSlowly,'''')='''' AND  ISNULL(RecordDeleted,''N'') = ''N''', N'Over the last weeks-Moving/speaking slowly is required', CAST(8 AS Decimal(18, 0)), N'Over the last weeks-Moving/speaking slowly is required')
END

IF NOT EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1635 and ErrorMessage='Over the last weeks-Thoughts that you would be better off is required' and TableName = 'PHQ9Documents')
BEGIN
INSERT [dbo].[DocumentValidations] ([Active], [DocumentCodeId], [DocumentType], [TabName], [TabOrder], [TableName], [ColumnName], [ValidationLogic], [ValidationDescription], [ValidationOrder], [ErrorMessage]) VALUES (N'Y', 1635, NULL, N'PHQ9', 9, N'PHQ9Documents', N'HurtingYourself', N'FROM PHQ9Documents WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(HurtingYourself,'''')='''' AND  ISNULL(RecordDeleted,''N'') = ''N''', N'Over the last weeks-Thoughts that you would be better off is required', CAST(9 AS Decimal(18, 0)), N'Over the last weeks-Thoughts that you would be better off is required')
END


IF NOT EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1635 and ErrorMessage='Over the last weeks-Checked off any problems, how difficult is required' and TableName = 'PHQ9Documents')
BEGIN
INSERT [dbo].[DocumentValidations] ([Active], [DocumentCodeId], [DocumentType], [TabName], [TabOrder], [TableName], [ColumnName], [ValidationLogic], [ValidationDescription], [ValidationOrder], [ErrorMessage]) VALUES (N'Y', 1635, NULL, N'PHQ9', 10, N'PHQ9Documents', N'GetAlongOtherPeople', N'FROM PHQ9Documents WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(GetAlongOtherPeople,'''')=''''  AND  ISNULL(RecordDeleted,''N'') = ''N''', N'Over the last weeks-Checked off any problems, how difficult is required', CAST(10 AS Decimal(18, 0)), N'Over the last weeks-Checked off any problems, how difficult is required')
END


IF NOT EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1635 and ErrorMessage='Documentation of follow-up plan is required' and TableName = 'PHQ9Documents' and ColumnName = 'DocumentationFollowup')
BEGIN
INSERT [dbo].[DocumentValidations] ([Active], [DocumentCodeId], [DocumentType], [TabName], [TabOrder], [TableName], [ColumnName], [ValidationLogic], [ValidationDescription], [ValidationOrder], [ErrorMessage]) 
VALUES (N'Y', 1635, NULL, N'PHQ9', 11, N'PHQ9Documents', N'DocumentationFollowup', N'FROM PHQ9Documents WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(OtherInterventions, ''Y'') = ''Y'' AND ISNULL(DocumentationFollowup,'''')=''''  AND  ISNULL(RecordDeleted,''N'') = ''N''', N'Documentation of follow-up plan is required', CAST(11 AS Decimal(18, 0)), N'Documentation of follow-up plan is required')
END