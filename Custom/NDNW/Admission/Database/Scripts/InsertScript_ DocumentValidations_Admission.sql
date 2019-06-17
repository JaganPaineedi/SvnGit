/**********************************************************************************************/
/* UpdateScript for DocumentValidations Table - Task #4.01 New Directions - Customizations    */
/* Author : Arjun K R                                                                         */
/* Date   : 4 June 2015                                                                       */
/**********************************************************************************************/


IF EXISTS(select * from DocumentValidations where TabName='Insurance' AND TableName='CustomDocumentRegistrations' AND ColumnName='ClientMonthlyIncome' AND DocumentCodeId=10500)
 BEGIN 
	UPDATE DocumentValidations SET ValidationLogic=' FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(ClientMonthlyIncome,-1)=-1' 
	WHERE TabName='Insurance' AND TableName='CustomDocumentRegistrations' AND ColumnName='ClientMonthlyIncome' AND DocumentCodeId=10500
 END
 
 
IF EXISTS(select * from DocumentValidations where TabName='Insurance' AND TableName='CustomDocumentRegistrations' AND ColumnName='ClientAnnualIncome' AND DocumentCodeId=10500)
 BEGIN 
	UPDATE DocumentValidations SET ValidationLogic=' FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(ClientMonthlyIncome,-1)=-1' 
	WHERE TabName='Insurance' AND TableName='CustomDocumentRegistrations' AND ColumnName='ClientAnnualIncome' AND DocumentCodeId=10500
 END
 
IF EXISTS(select * from DocumentValidations where TabName='Insurance' AND TableName='CustomDocumentRegistrations' AND ColumnName='NumberInHousehold' AND DocumentCodeId=10500)
 BEGIN 
	UPDATE DocumentValidations SET ValidationLogic=' FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(NumberInHousehold,-1)=-1' 
	WHERE TabName='Insurance' AND TableName='CustomDocumentRegistrations' AND ColumnName='NumberInHousehold' AND DocumentCodeId=10500
 END
 
 IF EXISTS(select * from DocumentValidations where TabName='Insurance' AND TableName='CustomDocumentRegistrations' AND ColumnName='DependentsInHousehold' AND DocumentCodeId=10500)
 BEGIN 
	UPDATE DocumentValidations SET ValidationLogic=' FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(DependentsInHousehold,-1)=-1' 
	WHERE TabName='Insurance' AND TableName='CustomDocumentRegistrations' AND ColumnName='DependentsInHousehold' AND DocumentCodeId=10500
 END
 
 IF EXISTS(select * from DocumentValidations where TabName='Insurance' AND TableName='CustomDocumentRegistrations' AND ColumnName='HouseholdAnnualIncome' AND DocumentCodeId=10500)
 BEGIN 
	UPDATE DocumentValidations SET ValidationLogic=' FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(HouseholdAnnualIncome,-1)=-1' 
	WHERE TabName='Insurance' AND TableName='CustomDocumentRegistrations' AND ColumnName='HouseholdAnnualIncome' AND DocumentCodeId=10500
 END
 
 IF EXISTS(select * from DocumentValidations where TabName='Insurance' AND TableName='CustomDocumentRegistrations' AND ColumnName='PrimarySource' AND DocumentCodeId=10500)
 BEGIN 
	UPDATE DocumentValidations SET ValidationLogic='FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(PrimarySource,-1)=-1' 
	WHERE TabName='Insurance' AND TableName='CustomDocumentRegistrations' AND ColumnName='PrimarySource' AND DocumentCodeId=10500
 END
 
 
 

 
 
