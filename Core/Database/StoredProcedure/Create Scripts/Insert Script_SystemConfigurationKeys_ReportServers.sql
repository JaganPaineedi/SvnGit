
IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'Name') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'Name' 
				,Name
				,'Report Server Name'
				,'Reporr Server Name' 
				,'N' 
				,'Report Server Name in Report servers Table' 
				,'ReportServers' 
				From ReportServers 
	END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select Name FROM ReportServers)
		   ,AcceptedValues = 'Report Server Name' 
		   ,[Description]= 'Reporr Server Name'  
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Report Server Name in Report servers Table' 
		   ,SourceTableName= 'ReportServers'
			WHERE [Key]='Name';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'URL') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'URL' 
				,URL 
				,'Report Server URL'
				,'Report Server URL' 
				,'N' 
				,'Report Server URL in Report servers Table' 
				,'ReportServers' 
				From ReportServers 
	 END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select URL FROM ReportServers)
		   ,AcceptedValues = 'Report Server URL' 
		   ,[Description]= 'Report Server URL'  
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Report Server URL in Report servers Table' 
		   ,SourceTableName= 'ReportServers'
			WHERE [Key]='URL';
   END		
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ConnectionString') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'ConnectionString' 
				,ConnectionString 
				,'Report Server Connection String'
				,'Report Server Connection String' 
				,'N' 
				,'Report Server Connection String in Report server Table' 
				,'ReportServers' 
				From ReportServers 
	END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ConnectionString FROM ReportServers)
		   ,AcceptedValues = 'Report Server Connection String'
		   ,[Description]= 'Report Server Connection String'  
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Report Server Connection String in Report server Table'
		   ,SourceTableName= 'ReportServers'
			WHERE [Key]='ConnectionString';
   END		
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'DomainName') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'DomainName' 
				,DomainName
				,'Report Server Domain Name' 
				,'Report Server Domain Name' 
				,'N' 
				,'Report Server Domain Name in Report server Table' 
				,'ReportServers' 
				From ReportServers
	END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select DomainName FROM ReportServers)
		   ,AcceptedValues = 'Report Server Domain Name'
		   ,[Description]= 'Report Server Domain Name'  
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Report Server Domain Name in Report server Table' 
		   ,SourceTableName= 'ReportServers'
			WHERE [Key]='DomainName';
   END		
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'UserName') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'UserName' 
				,UserName 
				,'Report Server User Name'
				,'Report Server User Name' 
				,'N' 
				,'Report Server Domain Name in Report server Table' 
				,'ReportServers' 
				From ReportServers 
	END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select UserName FROM ReportServers)
		   ,AcceptedValues = 'Report Server User Name'
		   ,[Description]= 'Report Server User Name'  
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Report Server Domain Name in Report server Table' 
		   ,SourceTableName= 'ReportServers'
			WHERE [Key]='UserName';
   END		
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'Password') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'Password' 
				,[Password]
				,'Report Server Password'
				,'Report Server Password' 
				,'N' 
				,'Report Server Password in Report server Table' 
				,'ReportServers' 
				From ReportServers
    END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select [Password] FROM ReportServers)
		   ,AcceptedValues = 'Report Server Password' 
		   ,[Description]= 'Report Server Password'  
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Report Server Password in Report server Table' 
		   ,SourceTableName= 'ReportServers'
			WHERE [Key]='Password';
   END		
/********************************* systemconfigurationkeys table *****************************************/



--select * from ReportServers
----ReportServerId
--			Name
--			URL
--			ConnectionString
--			DomainName
--			UserName
--			Password
----RowIdentifier
----CreatedBy
----CreatedDate
----ModifiedBy
----ModifiedDate
----RecordDeleted
----DeletedDate
----DeletedBy
