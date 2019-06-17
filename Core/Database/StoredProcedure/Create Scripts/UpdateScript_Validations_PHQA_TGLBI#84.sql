--Update Script Validation scripts for PHQ9A
/******************************************************************************** 
											
		Created By			Created Date    Purpose
		Pabitra				23/04/2018		Added condition for "ClientDeclinedToParticipate" check box
											Task: #84
											Project : Texas Go Live Build Issues 

*********************************************************************************/


IF EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1634 and  TableName='PHQ9ADocuments' and ColumnName='FeelingDown')
BEGIN
UPDATE DocumentValidations SET [ValidationLogic]=N'FROM PHQ9ADocuments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(FeelingDown,'''')='''' AND ISNULL(ClientDeclinedToParticipate,''N'') = ''N'' AND  ISNULL(RecordDeleted,''N'') = ''N'''  where DocumentCodeId=1634 and TableName='PHQ9ADocuments' and ColumnName='FeelingDown'
END

IF EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1634 and  TableName='PHQ9ADocuments' and ColumnName='LittleInterest')
BEGIN
UPDATE DocumentValidations SET [ValidationLogic]= N'FROM PHQ9ADocuments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(LittleInterest,'''')='''' AND ISNULL(ClientDeclinedToParticipate,''N'') = ''N'' AND  ISNULL(RecordDeleted,''N'') = ''N''' where DocumentCodeId=1634 and  TableName='PHQ9ADocuments' and ColumnName='LittleInterest'
END

IF EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1634 and  TableName='PHQ9ADocuments' and ColumnName='TroubleFalling')
BEGIN
UPDATE DocumentValidations SET [ValidationLogic]= N'FROM PHQ9ADocuments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(TroubleFalling,'''')='''' AND ISNULL(ClientDeclinedToParticipate,''N'') = ''N'' AND  ISNULL(RecordDeleted,''N'') = ''N''' where DocumentCodeId=1634 and  TableName='PHQ9ADocuments' and ColumnName='TroubleFalling'
END

IF EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1634 and  TableName='PHQ9ADocuments' and ColumnName='PoorAppetite')
BEGIN
UPDATE DocumentValidations SET [ValidationLogic]= N'FROM PHQ9ADocuments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(PoorAppetite,'''')='''' AND ISNULL(ClientDeclinedToParticipate,''N'') = ''N'' AND  ISNULL(RecordDeleted,''N'') = ''N''' where DocumentCodeId=1634 and TableName='PHQ9ADocuments' and ColumnName='PoorAppetite'
END

IF EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1634 and  TableName='PHQ9ADocuments' and ColumnName='FeelingTired')
BEGIN
UPDATE DocumentValidations SET [ValidationLogic]=N'FROM PHQ9ADocuments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(FeelingTired,'''')='''' AND ISNULL(ClientDeclinedToParticipate,''N'') = ''N'' AND  ISNULL(RecordDeleted,''N'') = ''N''' where DocumentCodeId=1634 and TableName='PHQ9ADocuments' and ColumnName='FeelingTired'
END

IF EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1634 and  TableName='PHQ9ADocuments' and ColumnName='FeelingBad')
BEGIN
UPDATE DocumentValidations SET [ValidationLogic]=N'FROM PHQ9ADocuments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(FeelingBad,'''')=''''  AND ISNULL(ClientDeclinedToParticipate,''N'') = ''N'' AND ISNULL(RecordDeleted,''N'') = ''N''' where DocumentCodeId=1634 and TableName='PHQ9ADocuments' and ColumnName='FeelingBad'
END
----------------------------------------------------------------------------------------------------------------------------------




IF EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1634 and TableName='PHQ9ADocuments' and ColumnName='TroubleConcentrating')
BEGIN
UPDATE DocumentValidations SET [ValidationLogic]=N'FROM PHQ9ADocuments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(TroubleConcentrating,'''')='''' AND ISNULL(ClientDeclinedToParticipate,''N'') = ''N'' AND  ISNULL(RecordDeleted,''N'') = ''N''' where DocumentCodeId=1634 and TableName='PHQ9ADocuments' and ColumnName='TroubleConcentrating'
END

IF EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1634 and TableName='PHQ9ADocuments' and ColumnName='MovingOrSpeakingSlowly')
BEGIN
UPDATE DocumentValidations SET [ValidationLogic]=N'FROM PHQ9ADocuments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(MovingOrSpeakingSlowly,'''')='''' AND ISNULL(ClientDeclinedToParticipate,''N'') = ''N'' AND  ISNULL(RecordDeleted,''N'') = ''N''' where DocumentCodeId=1634 and TableName='PHQ9ADocuments' and ColumnName='MovingOrSpeakingSlowly'
END

IF EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1634 and TableName='PHQ9ADocuments' and ColumnName='HurtingYourself')
BEGIN
UPDATE DocumentValidations SET [ValidationLogic]=N'FROM PHQ9ADocuments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(HurtingYourself,'''')='''' AND ISNULL(ClientDeclinedToParticipate,''N'') = ''N'' AND  ISNULL(RecordDeleted,''N'') = ''N''' where DocumentCodeId=1634 and TableName='PHQ9ADocuments' and ColumnName='HurtingYourself'
END

IF EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1634 and TableName='PHQ9ADocuments' and ColumnName='PastYear')
BEGIN
UPDATE DocumentValidations SET [ValidationLogic]=N'FROM PHQ9ADocuments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(PastYear,'''')='''' AND ISNULL(ClientDeclinedToParticipate,''N'') = ''N'' AND  ISNULL(RecordDeleted,''N'') = ''N''' where DocumentCodeId=1634 and TableName='PHQ9ADocuments' and ColumnName='PastYear'
END

IF EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1634 and TableName='PHQ9ADocuments' and ColumnName='ProblemDifficulty')
BEGIN
UPDATE DocumentValidations SET [ValidationLogic]=N'FROM PHQ9ADocuments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(ProblemDifficulty,'''')='''' AND ISNULL(ClientDeclinedToParticipate,''N'') = ''N'' AND  ISNULL(RecordDeleted,''N'') = ''N''' where DocumentCodeId=1634 and TableName='PHQ9ADocuments' and ColumnName='ProblemDifficulty'
END

IF EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1634 and TableName='PHQ9ADocuments' and ColumnName='PastMonth')
BEGIN
UPDATE DocumentValidations SET [ValidationLogic]=N'FROM PHQ9ADocuments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(PastMonth,'''')='''' AND ISNULL(ClientDeclinedToParticipate,''N'') = ''N'' AND  ISNULL(RecordDeleted,''N'') = ''N''' where DocumentCodeId=1634 and TableName='PHQ9ADocuments' and ColumnName='PastMonth'
END

IF EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1634 and TableName='PHQ9ADocuments' and ColumnName='SuicideAttempt')
BEGIN
UPDATE DocumentValidations SET [ValidationLogic]=N'FROM PHQ9ADocuments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(SuicideAttempt,'''')='''' AND ISNULL(ClientDeclinedToParticipate,''N'') = ''N'' AND  ISNULL(RecordDeleted,''N'') = ''N''' where DocumentCodeId=1634 and TableName='PHQ9ADocuments' and ColumnName='SuicideAttempt'
END


