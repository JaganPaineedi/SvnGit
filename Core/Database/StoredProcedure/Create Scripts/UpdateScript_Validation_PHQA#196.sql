--Validation Updatescripts for AspenPointe-Environment Issues: #196

/*********************************************************************************/


IF EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1634 and  TableName='PHQ9ADocuments' and ColumnName='FeelingDown')
BEGIN
UPDATE DocumentValidations SET [TabName]='PHQ-A' ,[ValidationDescription]='PHQ-A – Feeling down, depressed, irritable, or hopeless is required' where DocumentCodeId=1634 and TableName='PHQ9ADocuments' and ColumnName='FeelingDown'
END

IF EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1634 and  TableName='PHQ9ADocuments' and ColumnName='LittleInterest')
BEGIN
UPDATE DocumentValidations SET [TabName]='PHQ-A' ,[ValidationDescription]='PHQ-A- little interest or pleasure in doing things is required' where DocumentCodeId=1634 and  TableName='PHQ9ADocuments' and ColumnName='LittleInterest'
END

IF EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1634 and  TableName='PHQ9ADocuments' and ColumnName='TroubleFalling')
BEGIN
UPDATE DocumentValidations SET [TabName]='PHQ-A' ,[ValidationDescription]='PHQ-A- trouble falling asleep, staying asleep, or sleeping too much is required' where DocumentCodeId=1634 and  TableName='PHQ9ADocuments' and ColumnName='TroubleFalling'
END

IF EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1634 and  TableName='PHQ9ADocuments' and ColumnName='PoorAppetite')
BEGIN
UPDATE DocumentValidations SET [TabName]='PHQ-A' ,[ValidationDescription]='PHQ-A-Poor appetite, weight loss, or overeating is required' where DocumentCodeId=1634 and TableName='PHQ9ADocuments' and ColumnName='PoorAppetite'
END

IF EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1634 and  TableName='PHQ9ADocuments' and ColumnName='FeelingTired')
BEGIN
UPDATE DocumentValidations SET [TabName]='PHQ-A' ,[ValidationDescription]='PHQ-A-Feeling tired, or having little energy is required' where DocumentCodeId=1634 and TableName='PHQ9ADocuments' and ColumnName='FeelingTired'
END

IF EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1634 and  TableName='PHQ9ADocuments' and ColumnName='FeelingBad')
BEGIN
UPDATE DocumentValidations SET [TabName]='PHQ-A' ,[ValidationDescription]='PHQ-A-Feeling bad about yourself-or feeling that you are a failure… is required' where DocumentCodeId=1634 and TableName='PHQ9ADocuments' and ColumnName='FeelingBad'
END
----------------------------------------------------------------------------------------------------------------------------------




IF EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1634 and TableName='PHQ9ADocuments' and ColumnName='TroubleConcentrating')
BEGIN
UPDATE DocumentValidations SET [TabName]='PHQ-A' ,[ValidationDescription]='PHQ-A- Trouble concentrating on things like school work, reading, or watching TV is required' where DocumentCodeId=1634 and TableName='PHQ9ADocuments' and ColumnName='TroubleConcentrating'
END

IF EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1634 and TableName='PHQ9ADocuments' and ColumnName='MovingOrSpeakingSlowly')
BEGIN
UPDATE DocumentValidations SET [TabName]='PHQ-A' ,[ValidationDescription]='PHQ-A-Moving or speaking so slowly that other people could have noticed… is required' where DocumentCodeId=1634 and TableName='PHQ9ADocuments' and ColumnName='MovingOrSpeakingSlowly'
END

IF EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1634 and TableName='PHQ9ADocuments' and ColumnName='HurtingYourself')
BEGIN
UPDATE DocumentValidations SET [TabName]='PHQ-A' ,[ValidationDescription]='PHQ-A- thoughts that you would be better off dead, or of hurting yourself in some way is required' where DocumentCodeId=1634 and TableName='PHQ9ADocuments' and ColumnName='HurtingYourself'
END

IF EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1634 and TableName='PHQ9ADocuments' and ColumnName='PastYear')
BEGIN
UPDATE DocumentValidations SET [TabName]='PHQ-A' ,[ValidationDescription]='PHQ-A- In the past year have you felt depressed or sad most days, even if you felt okay sometimes is required' where DocumentCodeId=1634 and TableName='PHQ9ADocuments' and ColumnName='PastYear'
END

IF EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1634 and TableName='PHQ9ADocuments' and ColumnName='ProblemDifficulty')
BEGIN
UPDATE DocumentValidations SET [TabName]='PHQ-A' ,[ValidationDescription]='PHQ-A - If you are experiencing any of the problems on this form, how difficult have these problems made it for you to do your work, take is required' where DocumentCodeId=1634 and TableName='PHQ9ADocuments' and ColumnName='ProblemDifficulty'
END

IF EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1634 and TableName='PHQ9ADocuments' and ColumnName='PastMonth')
BEGIN
UPDATE DocumentValidations SET [TabName]='PHQ-A' ,[ValidationDescription]='PHQ-A- Has there been a time in the past month when you have had serious thoughts about ending your life is required' where DocumentCodeId=1634 and TableName='PHQ9ADocuments' and ColumnName='PastMonth'
END

IF EXISTS(SELECT DocumentCodeId FROM DocumentValidations WHERE DocumentCodeId=1634 and TableName='PHQ9ADocuments' and ColumnName='SuicideAttempt')
BEGIN
UPDATE DocumentValidations SET [TabName]='PHQ-A' ,[ValidationDescription]='PHQ-A- Have you EVER, in your WHOLE LIFE, tried to kill yourself or made a suicide attempt is required' where DocumentCodeId=1634 and TableName='PHQ9ADocuments' and ColumnName='SuicideAttempt'
END


