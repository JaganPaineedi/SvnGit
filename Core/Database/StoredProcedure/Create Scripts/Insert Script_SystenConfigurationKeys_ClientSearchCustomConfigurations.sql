
IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ButtonLabel1') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'ButtonLabel1' 
				,ButtonLabel1 
				,'Button Label'
				,'Button Label 1' 
				,'N' 
				,'Button Label 1 in ClientSearchCustomConfigurations Table' 
				,'ClientSearchCustomConfigurations' 
				From  ClientSearchCustomConfigurations 
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ButtonLabel1 FROM ClientSearchCustomConfigurations)
		   ,AcceptedValues = 'Button Label'
		   ,[Description]= 'Button Label 1' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Button Label 1 in ClientSearchCustomConfigurations Table'
		   ,SourceTableName= 'ClientSearchCustomConfigurations'
			WHERE [Key]='ButtonLabel1';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ButtonObjectName1') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'ButtonObjectName1' 
				,ButtonObjectName1 
				,'Button Object Name'
				,'Button Object Name 1' 
				,'N' 
				,'Button Object Name 1 in ClientSearchCustomConfigurations Table' 
				,'ClientSearchCustomConfigurations' 
				From  ClientSearchCustomConfigurations 
	 END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ButtonObjectName1 FROM ClientSearchCustomConfigurations)
		   ,AcceptedValues = 'Button Object Name'
		   ,[Description]= 'Button Object Name 1'  
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Button Object Name 1 in ClientSearchCustomConfigurations Table' 
		   ,SourceTableName= 'ClientSearchCustomConfigurations'
			WHERE [Key]='ButtonObjectName1';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'NeedsClientId1') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'NeedsClientId1' 
				,NeedsClientId1
				,'Y,N' 
				,'Needs Client Id 1' 
				,'N' 
				,'Needs Client Id 1 in ClientSearchCustomConfigurations Table' 
				,'ClientSearchCustomConfigurations'
				From  ClientSearchCustomConfigurations 
	 END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select NeedsClientId1 FROM ClientSearchCustomConfigurations)
		   ,AcceptedValues = 'Y,N' 
		   ,[Description]= 'Needs Client Id 1'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Needs Client Id 1 in ClientSearchCustomConfigurations Table'
		   ,SourceTableName= 'ClientSearchCustomConfigurations'
			WHERE [Key]='NeedsClientId1';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'EnablesOn3Searches1') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'EnablesOn3Searches1' 
				,EnablesOn3Searches1
				,'Y,N'
				,'Enables On 3 Searches 1' 
				,'N' 
				,'Enables On 3 Searches 1 in ClientSearchCustomConfigurations Table' 
				,'ClientSearchCustomConfigurations'
				From  ClientSearchCustomConfigurations
   END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select EnablesOn3Searches1 FROM ClientSearchCustomConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Enables On 3 Searches 1' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Enables On 3 Searches 1 in ClientSearchCustomConfigurations Table' 
		   ,SourceTableName= 'ClientSearchCustomConfigurations'
			WHERE [Key]='EnablesOn3Searches1';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'SendSearchParameters1') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'SendSearchParameters1' 
				,SendSearchParameters1
				,'Y,N' 
				,'Send Search Parameters 1'
				,'N' 
				,'Send Search Parameters 1 in ClientSearchCustomConfigurations Table' 
				,'ClientSearchCustomConfigurations' 
				From  ClientSearchCustomConfigurations 
	 END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select SendSearchParameters1 FROM ClientSearchCustomConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Send Search Parameters 1' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Send Search Parameters 1 in ClientSearchCustomConfigurations Table' 
		   ,SourceTableName= 'ClientSearchCustomConfigurations'
			WHERE [Key]='SendSearchParameters1';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'OpenScreenId1') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'OpenScreenId1' 
				,OpenScreenId1 
				,'Screen Id'
				,'Open Screen Id 1' 
				,'N' 
				,'Open Screen Id 1 in ClientSearchCustomConfigurations Table' 
				,'ClientSearchCustomConfigurations'
				From  ClientSearchCustomConfigurations 
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select OpenScreenId1 FROM ClientSearchCustomConfigurations)
		   ,AcceptedValues = 'Screen Id'
		   ,[Description]= 'Open Screen Id 1'  
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Open Screen Id 1 in ClientSearchCustomConfigurations Table'
		   ,SourceTableName= 'ClientSearchCustomConfigurations'
			WHERE [Key]='OpenScreenId1';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ButtonLabel2') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'ButtonLabel2' 
				,ButtonLabel2
				,'Button Label'
				,'Button Label 2' 
				,'N' 
				,'Button Label 2 in ClientSearchCustomConfigurations Table' 
				,'ClientSearchCustomConfigurations' 
				From  ClientSearchCustomConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ButtonLabel2 FROM ClientSearchCustomConfigurations)
		   ,AcceptedValues = 'Button Label'
		   ,[Description]= 'Button Label 2' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Button Label 2 in ClientSearchCustomConfigurations Table'
		   ,SourceTableName= 'ClientSearchCustomConfigurations'
			WHERE [Key]='ButtonLabel2';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ButtonObjectName2') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'ButtonObjectName2' 
				,ButtonObjectName2 
				,'Button Object Name' 
				,'Button Object Name 2'
				,'N' 
				,'Button Object Name 2 in ClientSearchCustomConfigurations Table' 
				,'ClientSearchCustomConfigurations' 
				From  ClientSearchCustomConfigurations 
    END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ButtonObjectName2 FROM ClientSearchCustomConfigurations)
		   ,AcceptedValues = 'Button Object Name'
		   ,[Description]= 'Button Object Name 2' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Button Object Name 2 in ClientSearchCustomConfigurations Table' 
		   ,SourceTableName= 'ClientSearchCustomConfigurations'
			WHERE [Key]='ButtonObjectName2';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'NeedsClientId2') 
	BEGIN  
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'NeedsClientId2' 
				,NeedsClientId2
				,'Y,N'
				,'Needs Client Id 2' 
				,'N' 
				,'Needs Client Id 2 in ClientSearchCustomConfigurations Table' 
				,'ClientSearchCustomConfigurations' 
				From  ClientSearchCustomConfigurations 
    END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select NeedsClientId2 FROM ClientSearchCustomConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Needs Client Id 2' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Needs Client Id 2 in ClientSearchCustomConfigurations Table' 
		   ,SourceTableName= 'ClientSearchCustomConfigurations'
			WHERE [Key]='NeedsClientId2';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'EnablesOn3Searches2') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'EnablesOn3Searches2' 
				,EnablesOn3Searches2
				,'Y,N'
				,'Enables On 3 Searches 2' 
				,'N' 
				,'Enables On 3 Searches 2 in ClientSearchCustomConfigurations Table' 
				,'ClientSearchCustomConfigurations' 
				From  ClientSearchCustomConfigurations
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select EnablesOn3Searches2 FROM ClientSearchCustomConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Enables On 3 Searches 2' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Enables On 3 Searches 2 in ClientSearchCustomConfigurations Table'
		   ,SourceTableName= 'ClientSearchCustomConfigurations'
			WHERE [Key]='EnablesOn3Searches2';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'SendSearchParameters2') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'SendSearchParameters2' 
				,SendSearchParameters2
				,'Y,N' 
				,'Send Search Parameters 2' 
				,'N' 
				,'Send Search Parameters 2 in ClientSearchCustomConfigurations Table' 
				,'ClientSearchCustomConfigurations' 
				From  ClientSearchCustomConfigurations
    END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select SendSearchParameters2 FROM ClientSearchCustomConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Send Search Parameters 2' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Send Search Parameters 2 in ClientSearchCustomConfigurations Table' 
		   ,SourceTableName= 'ClientSearchCustomConfigurations'
			WHERE [Key]='SendSearchParameters2';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'OpenScreenId2') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'OpenScreenId2' 
				,OpenScreenId2 
				,'Screen Id'
				,'Open Screen Id 2' 
				,'N' 
				,'Open Screen Id 2 in ClientSearchCustomConfigurations Table' 
				,'ClientSearchCustomConfigurations'
				From  ClientSearchCustomConfigurations 
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select OpenScreenId2 FROM ClientSearchCustomConfigurations)
		   ,AcceptedValues = 'Screen Id'
		   ,[Description]= 'Open Screen Id 2'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Open Screen Id 2 in ClientSearchCustomConfigurations Table' 
		   ,SourceTableName= 'ClientSearchCustomConfigurations'
			WHERE [Key]='OpenScreenId2';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ButtonLabel3') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'ButtonLabel3' 
				,ButtonLabel3
				,'Button Label'
				,'Button Label 3' 
				,'N' 
				,'Button Label 3 in ClientSearchCustomConfigurations Table' 
				,'ClientSearchCustomConfigurations'
				From  ClientSearchCustomConfigurations 
     END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ButtonLabel3 FROM ClientSearchCustomConfigurations)
		   ,AcceptedValues = 'Button Label'
		   ,[Description]= 'Button Label 3'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Button Label 3 in ClientSearchCustomConfigurations Table'
		   ,SourceTableName= 'ClientSearchCustomConfigurations'
			WHERE [Key]='ButtonLabel3';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ButtonObjectName3') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'ButtonObjectName3' 
				,ButtonObjectName3 
				,'Button Object Name'
				,'Button Object Name 3' 
				,'N' 
				,'Button Object Name 3 in ClientSearchCustomConfigurations Table' 
				,'ClientSearchCustomConfigurations' 
				From  ClientSearchCustomConfigurations
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ButtonObjectName3 FROM ClientSearchCustomConfigurations)
		   ,AcceptedValues = 'Button Object Name'
		   ,[Description]= 'Button Object Name 3' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Button Object Name 3 in ClientSearchCustomConfigurations Table'
		   ,SourceTableName= 'ClientSearchCustomConfigurations'
			WHERE [Key]='ButtonObjectName3';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'NeedsClientId3') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'NeedsClientId3' 
				,NeedsClientId3 
				,'Y,N'
				,'Needs Client Id 3' 
				,'N' 
				,'Needs Client Id 3 in ClientSearchCustomConfigurations Table' 
				,'ClientSearchCustomConfigurations' 
				From  ClientSearchCustomConfigurations
	END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select NeedsClientId3 FROM ClientSearchCustomConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Needs Client Id 3' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Needs Client Id 3 in ClientSearchCustomConfigurations Table'
		   ,SourceTableName= 'ClientSearchCustomConfigurations'
			WHERE [Key]='NeedsClientId3';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'EnablesOn3Searches3') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'EnablesOn3Searches3' 
				,EnablesOn3Searches3 
				,'Y,N'
				,'Enables On 3 Searches 3' 
				,'N' 
				,'Enables On 3 Searches 3 in ClientSearchCustomConfigurations Table' 
				,'ClientSearchCustomConfigurations' 
				From  ClientSearchCustomConfigurations 
	END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select EnablesOn3Searches3 FROM ClientSearchCustomConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Enables On 3 Searches 3' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Enables On 3 Searches 3 in ClientSearchCustomConfigurations Table'
		   ,SourceTableName= 'ClientSearchCustomConfigurations'
			WHERE [Key]='EnablesOn3Searches3';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'SendSearchParameters3') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'SendSearchParameters3' 
				,SendSearchParameters3
				,'Y,N' 
				,'Send Search Parameters 3' 
				,'N' 
				,'Send Search Parameters 3 in ClientSearchCustomConfigurations Table' 
				,'ClientSearchCustomConfigurations'
				From  ClientSearchCustomConfigurations 
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select SendSearchParameters3 FROM ClientSearchCustomConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Send Search Parameters 3'  
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Send Search Parameters 3 in ClientSearchCustomConfigurations Table'
		   ,SourceTableName= 'ClientSearchCustomConfigurations'
			WHERE [Key]='SendSearchParameters3';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'OpenScreenId3') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'OpenScreenId3' 
				,OpenScreenId3
				,'Screen Id' 
				,'Open Screen Id 3' 
				,'N' 
				,'Open Screen Id 3 in ClientSearchCustomConfigurations Table' 
				,'ClientSearchCustomConfigurations'
				From  ClientSearchCustomConfigurations
	END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select OpenScreenId3 FROM ClientSearchCustomConfigurations)
		   ,AcceptedValues = 'Screen Id'
		   ,[Description]= 'Open Screen Id 3'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Open Screen Id 3 in ClientSearchCustomConfigurations Table' 
		   ,SourceTableName= 'ClientSearchCustomConfigurations'
			WHERE [Key]='OpenScreenId3';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ButtonLabel4') 
	BEGIN  
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'ButtonLabel4' 
				,ButtonLabel4 
				,'Button Label'
				,'Button Label 4' 
				,'N' 
				,'Button Label 4 in ClientSearchCustomConfigurations Table' 
				,'ClientSearchCustomConfigurations' 
				From  ClientSearchCustomConfigurations
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ButtonLabel4 FROM ClientSearchCustomConfigurations)
		   ,AcceptedValues = 'Button Label'
		   ,[Description]= 'Button Label 4' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Button Label 4 in ClientSearchCustomConfigurations Table'
		   ,SourceTableName= 'ClientSearchCustomConfigurations'
			WHERE [Key]='ButtonLabel4';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ButtonObjectName4') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'ButtonObjectName4' 
				,ButtonObjectName4 
				,'Button Object Name'
				,'Button Object Name 4' 
				,'N' 
				,'Button Object Name 4 in ClientSearchCustomConfigurations Table' 
				,'ClientSearchCustomConfigurations' 
				From  ClientSearchCustomConfigurations 
	END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ButtonObjectName4 FROM ClientSearchCustomConfigurations)
		   ,AcceptedValues = 'Button Object Name'
		   ,[Description]= 'Button Object Name 4' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Button Object Name 4 in ClientSearchCustomConfigurations Table'
		   ,SourceTableName= 'ClientSearchCustomConfigurations'
			WHERE [Key]='ButtonObjectName4';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'NeedsClientId4') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'NeedsClientId4' 
				,NeedsClientId4 
				,'Y,N'
				,'Needs Client Id 4' 
				,'N' 
				,'Needs Client Id 4 in ClientSearchCustomConfigurations Table' 
				,'ClientSearchCustomConfigurations'
				From  ClientSearchCustomConfigurations 
   END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select NeedsClientId4 FROM ClientSearchCustomConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Needs Client Id 4' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Needs Client Id 4 in ClientSearchCustomConfigurations Table'
		   ,SourceTableName= 'ClientSearchCustomConfigurations'
			WHERE [Key]='NeedsClientId4';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'EnablesOn3Searches4') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'EnablesOn3Searches4' 
				,EnablesOn3Searches4 
				,'Y,N'
				,'Enables On 3 Searches 4' 
				,'N' 
				,'Enables On 3 Searches 4 in ClientSearchCustomConfigurations Table' 
				,'ClientSearchCustomConfigurations' 
				From  ClientSearchCustomConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select EnablesOn3Searches4 FROM ClientSearchCustomConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Enables On 3 Searches 4'  
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Enables On 3 Searches 4 in ClientSearchCustomConfigurations Table'
		   ,SourceTableName= 'ClientSearchCustomConfigurations'
			WHERE [Key]='EnablesOn3Searches4';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'SendSearchParameters4') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'SendSearchParameters4' 
				,SendSearchParameters4
				,'Y,N' 
				,'Send Search Parameters 4' 
				,'N' 
				,'Send Search Parameters 4 in ClientSearchCustomConfigurations Table' 
				,'ClientSearchCustomConfigurations' 
				From  ClientSearchCustomConfigurations
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select SendSearchParameters4 FROM ClientSearchCustomConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Send Search Parameters 4'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Send Search Parameters 4 in ClientSearchCustomConfigurations Table' 
		   ,SourceTableName= 'ClientSearchCustomConfigurations'
			WHERE [Key]='SendSearchParameters4';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'OpenScreenId4') 
	BEGIN  
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'OpenScreenId4' 
				,OpenScreenId4
				,'Screen Id'
				,'Open Screen Id 4' 
				,'N' 
				,'Open Screen Id 4 in ClientSearchCustomConfigurations Table' 
				,'ClientSearchCustomConfigurations'
				From  ClientSearchCustomConfigurations
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select OpenScreenId4 FROM ClientSearchCustomConfigurations)
		   ,AcceptedValues = 'Screen Id'
		   ,[Description]= 'Open Screen Id 4' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Open Screen Id 4 in ClientSearchCustomConfigurations Table'
		   ,SourceTableName= 'ClientSearchCustomConfigurations'
			WHERE [Key]='OpenScreenId4';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'Button1CreatesClient') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'Button1CreatesClient' 
				,Button1CreatesClient 
				,'Y,N'
				,'Button 1 Creates Client' 
				,'N' 
				,'Button 1 Creates Client in ClientSearchCustomConfigurations Table' 
				,'ClientSearchCustomConfigurations' 
				From  ClientSearchCustomConfigurations
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select Button1CreatesClient FROM ClientSearchCustomConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Button 1 Creates Client' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Button 1 Creates Client in ClientSearchCustomConfigurations Table' 
		   ,SourceTableName= 'ClientSearchCustomConfigurations'
			WHERE [Key]='Button1CreatesClient';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'Button2CreatesClient') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'Button2CreatesClient' 
				,Button2CreatesClient 
				,'Y,N'
				,'Button 2 Creates Client' 
				,'N' 
				,'Button 2 Creates Client in ClientSearchCustomConfigurations Table' 
				,'ClientSearchCustomConfigurations' 
				From  ClientSearchCustomConfigurations
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select Button2CreatesClient FROM ClientSearchCustomConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]='Button 2 Creates Client'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Button 2 Creates Client in ClientSearchCustomConfigurations Table'
		   ,SourceTableName= 'ClientSearchCustomConfigurations'
			WHERE [Key]='Button2CreatesClient';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'Button3CreatesClient') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'Button3CreatesClient' 
				,Button3CreatesClient 
				,'Y,N'
				,'Button 3 Creates Client' 
				,'N' 
				,'Button 3 Creates Client in ClientSearchCustomConfigurations Table' 
				,'ClientSearchCustomConfigurations' 
				From  ClientSearchCustomConfigurations 
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select Button3CreatesClient FROM ClientSearchCustomConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Button 3 Creates Client' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Button 3 Creates Client in ClientSearchCustomConfigurations Table'
		   ,SourceTableName= 'ClientSearchCustomConfigurations'
			WHERE [Key]='Button3CreatesClient';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'Button4CreatesClient') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'Button4CreatesClient' 
				,Button4CreatesClient 
				,'Y,N'
				,'Button 4 Creates Client' 
				,'N' 
				,'Button 4 Creates Client in ClientSearchCustomConfigurations Table' 
				,'ClientSearchCustomConfigurations'
				 From  ClientSearchCustomConfigurations
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select Button4CreatesClient FROM ClientSearchCustomConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Button 4 Creates Client' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Button 4 Creates Client in ClientSearchCustomConfigurations Table'
		   ,SourceTableName= 'ClientSearchCustomConfigurations'
			WHERE [Key]='Button4CreatesClient';
   END	
/********************************* systemconfigurationkeys table *****************************************/


--SELECT * FROM ClientSearchCustomConfigurations
--		ButtonLabel1
--		ButtonObjectName1
--		NeedsClientId1
--		EnablesOn3Searches1
--		SendSearchParameters1
--		OpenScreenId1
--		ButtonLabel2
--		ButtonObjectName2
--		NeedsClientId2
--		EnablesOn3Searches2
--		SendSearchParameters2
--		OpenScreenId2
--		ButtonLabel3
--		ButtonObjectName3
--		NeedsClientId3
--		EnablesOn3Searches3
--		SendSearchParameters3
--		OpenScreenId3
--		ButtonLabel4
--		ButtonObjectName4
--		NeedsClientId4
--		EnablesOn3Searches4
--		SendSearchParameters4
--		OpenScreenId4
--		Button1CreatesClient
--		Button2CreatesClient
--		Button3CreatesClient
--		Button4CreatesClient
