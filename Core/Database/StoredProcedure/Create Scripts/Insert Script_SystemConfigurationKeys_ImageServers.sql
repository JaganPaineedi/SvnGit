
IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ImageServerName') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		Select  'ImageServerName' 
				,ImageServerName
				,'Image Server Name' 
				,'Image Server Name' 
				,'N' 
				,'Image Server Name in Image server Table' 
				,'ImageServers'
				From ImageServers
	END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ImageServerName FROM ImageServers)
		   ,AcceptedValues = 'Image Server Name' 
		   ,[Description]= 'Image Server Name'  
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Image Server Name in Image server Table' 
		   ,SourceTableName= 'ImageServers'
			WHERE [Key]='ImageServerName';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ImageServerURL') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		Select  'ImageServerURL' 
				,ImageServerURL
				,'Image Server URL'
				,'Image Server URL' 
				,'N' 
				,'Image Server URL in Image server Table' 
				,'ImageServers' 
				From ImageServers 
	END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ImageServerURL FROM ImageServers)
		   ,AcceptedValues = 'Image Server URL'
		   ,[Description]= 'Image Server URL'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Image Server URL in Image server Table' 
		   ,SourceTableName= 'ImageServers'
			WHERE [Key]='ImageServerURL';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ImageViewReportPath') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		Select  'ImageViewReportPath' 
				,ImageViewReportPath
				,'Image View Report Path'
				,'Image View Report Path' 
				,'N' 
				,'Image View Report Path in Image server Table' 
				,'ImageServers' 
				From ImageServers
	 END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ImageViewReportPath FROM ImageServers)
		   ,AcceptedValues = 'Image View Report Path'
		   ,[Description]= 'Image View Report Path' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Image View Report Path in Image server Table' 
		   ,SourceTableName= 'ImageServers'
			WHERE [Key]='ImageViewReportPath';
   END	
/********************************* systemconfigurationkeys table *****************************************/

--select * from imageservers
----ImageServerId
----CreatedBy
----CreatedDate
----ModifiedBy
----ModifiedDate
----RecordDeleted
----DeletedBy
----DeletedDate
--			ImageServerName
--			ImageServerURL
----ReportServerId
--			ImageViewReportPath