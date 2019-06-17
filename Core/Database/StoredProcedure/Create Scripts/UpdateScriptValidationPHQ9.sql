--Update Script Validation scripts for PHQ9
/******************************************************************************** 
											
		Created By			Created Date    Purpose
		D.Sunil				27/02/2017		MHP cosutomization Request for 'If 'Yes' is selected for 'Did Client refuse assessment or was it contraindicated?' validations should not apply to entire document.  Should be able to sign with only a 'Yes' response to this question'		
											and Core commitee approved.
											Task: #39.1
											Project : MHP-Customizations

*********************************************************************************/
IF   EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1635 and ErrorMessage='Over the last weeks-Little interest/pleasure in doing things is required' and TableName = 'PHQ9Documents')
BEGIN
Update [dbo].[DocumentValidations] set [ValidationLogic]=N'FROM PHQ9Documents WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(LittleInterest,'''')='''' AND ISNULL(ClientRefusedOrContraIndicated,''N'')=''N''  AND  ISNULL(RecordDeleted,''N'') = ''N''' where DocumentCodeId=1635 and ErrorMessage='Over the last weeks-Little interest/pleasure in doing things is required' and TableName = 'PHQ9Documents'
END
IF   EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1635 and ErrorMessage='Over the last weeks-Feeling down/depressed/hopeless is required' and TableName = 'PHQ9Documents')
BEGIN
Update [dbo].[DocumentValidations] set [ValidationLogic]= N'FROM PHQ9Documents WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(TroubleFalling,'''')=''''  AND ISNULL(ClientRefusedOrContraIndicated,''N'')=''N''  AND  ISNULL(RecordDeleted,''N'') = ''N'''  WHERE DocumentCodeId=1635 and ErrorMessage='Over the last weeks-Feeling down/depressed/hopeless is required' and TableName = 'PHQ9Documents'
END
IF   EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1635 and ErrorMessage='Over the last weeks-Trouble falling/staying awake is required' and TableName = 'PHQ9Documents')
BEGIN
Update [dbo].[DocumentValidations] set [ValidationLogic]= N'FROM PHQ9Documents WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(TroubleFalling,'''')=''''  AND ISNULL(ClientRefusedOrContraIndicated,''N'')=''N''  AND  ISNULL(RecordDeleted,''N'') = ''N'''  WHERE DocumentCodeId=1635 and ErrorMessage='Over the last weeks-Trouble falling/staying awake is required' and TableName = 'PHQ9Documents'
END
IF   EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1635 and ErrorMessage='Over the last weeks-Feeling tired or having little energy is required' and TableName = 'PHQ9Documents')
BEGIN
Update [dbo].[DocumentValidations] set [ValidationLogic]= N'FROM PHQ9Documents WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(FeelingTired,'''')='''' AND ISNULL(ClientRefusedOrContraIndicated,''N'')=''N'' AND  ISNULL(RecordDeleted,''N'') = ''N'''  WHERE DocumentCodeId=1635 and ErrorMessage='Over the last weeks-Feeling tired or having little energy is required' and TableName = 'PHQ9Documents'
END
IF   EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1635 and ErrorMessage='Over the last weeks-Poor appetite/overeating is required' and TableName = 'PHQ9Documents')
BEGIN
Update [dbo].[DocumentValidations] set [ValidationLogic]=  N'FROM PHQ9Documents WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(PoorAppetite,'''')='''' AND ISNULL(ClientRefusedOrContraIndicated,''N'')=''N''  AND  ISNULL(RecordDeleted,''N'') = ''N'''  WHERE DocumentCodeId=1635 and ErrorMessage='Over the last weeks-Poor appetite/overeating is required' and TableName = 'PHQ9Documents'
END
IF   EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1635 and ErrorMessage='Over the last weeks-Feeling bad about yourself is required' and TableName = 'PHQ9Documents')
BEGIN
Update [dbo].[DocumentValidations] set [ValidationLogic]=  N'FROM PHQ9Documents WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(FeelingBad,'''')='''' AND ISNULL(ClientRefusedOrContraIndicated,''N'')=''N''  AND  ISNULL(RecordDeleted,''N'') = ''N'''  WHERE DocumentCodeId=1635 and ErrorMessage='Over the last weeks-Feeling bad about yourself is required' and TableName = 'PHQ9Documents'
END
IF   EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1635 and ErrorMessage='Over the last weeks-Trouble concentrating is required' and TableName = 'PHQ9Documents')
BEGIN
Update [dbo].[DocumentValidations] set [ValidationLogic]=  N'FROM PHQ9Documents WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(TroubleConcentrating,'''')=''''  AND ISNULL(ClientRefusedOrContraIndicated,''N'')=''N''  AND  ISNULL(RecordDeleted,''N'') = ''N''' WHERE DocumentCodeId=1635 and ErrorMessage='Over the last weeks-Trouble concentrating is required' and TableName = 'PHQ9Documents'
END
IF   EXISTS(SELECT DocumentCodeId FROM DocumentValidations  WHERE DocumentCodeId=1635 and ErrorMessage='Over the last weeks-Moving/speaking slowly is required' and TableName = 'PHQ9Documents')
BEGIN
Update [dbo].[DocumentValidations] set [ValidationLogic]=  N'FROM PHQ9Documents WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(MovingOrSpeakingSlowly,'''')='''' AND ISNULL(ClientRefusedOrContraIndicated,''N'')=''N'' AND  ISNULL(RecordDeleted,''N'') = ''N'''  WHERE DocumentCodeId=1635 and ErrorMessage='Over the last weeks-Moving/speaking slowly is required' and TableName = 'PHQ9Documents'
END
IF   EXISTS(SELECT DocumentCodeId FROM DocumentValidations  WHERE DocumentCodeId=1635 and ErrorMessage='Over the last weeks-Thoughts that you would be better off is required' and TableName = 'PHQ9Documents')
BEGIN
Update [dbo].[DocumentValidations] set [ValidationLogic]=  N'FROM PHQ9Documents WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(HurtingYourself,'''')='''' AND ISNULL(ClientRefusedOrContraIndicated,''N'')=''N'' AND  ISNULL(RecordDeleted,''N'') = ''N'''  WHERE DocumentCodeId=1635 and ErrorMessage='Over the last weeks-Thoughts that you would be better off is required' and TableName = 'PHQ9Documents'
END
IF   EXISTS(SELECT DocumentCodeId FROM DocumentValidations  WHERE DocumentCodeId=1635 and ErrorMessage='Over the last weeks-Checked off any problems, how difficult is required' and TableName = 'PHQ9Documents')
BEGIN
Update [dbo].[DocumentValidations] set [ValidationLogic]=  N'FROM PHQ9Documents WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(GetAlongOtherPeople,'''')='''' AND ISNULL(ClientRefusedOrContraIndicated,''N'')=''N'' AND  ISNULL(RecordDeleted,''N'') = ''N'''   WHERE DocumentCodeId=1635 and ErrorMessage='Over the last weeks-Checked off any problems, how difficult is required' and TableName = 'PHQ9Documents'
END
IF   EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1635 and ErrorMessage='Documentation of follow-up plan is required' and TableName = 'PHQ9Documents' and ColumnName = 'DocumentationFollowup')
BEGIN
Update [dbo].[DocumentValidations] set [ValidationLogic]=  N'FROM PHQ9Documents WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(OtherInterventions, ''Y'') = ''Y'' AND ISNULL(DocumentationFollowup,'''')='''' AND ISNULL(ClientRefusedOrContraIndicated,''N'')=''N''  AND  ISNULL(RecordDeleted,''N'') = ''N'''  WHERE DocumentCodeId=1635 and ErrorMessage='Documentation of follow-up plan is required' and TableName = 'PHQ9Documents' and ColumnName = 'DocumentationFollowup'
END

