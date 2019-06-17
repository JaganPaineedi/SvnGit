
IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ProgramIdFilteredBy') 
	BEGIN 
		INSERT INTO SystemConfigurationKeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'ProgramIdFilteredBy' 
				,ProgramIdFilteredBy 
				,'Program Id'
				,'Program Id Filtered' 
				,'N' 
				,'Program Id Filtered By in ServiceDropDownConfigurations Table' 
				,'ServiceDropDownConfigurations' 
				From  ServiceDropdownConfigurations
	END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ProgramIdFilteredBy FROM ServiceDropDownConfigurations)
		   ,AcceptedValues = 'Program Id'
		   ,[Description]= 'Program Id Filtered' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Program Id Filtered By in ServiceDropDownConfigurations Table'  
		   ,SourceTableName= 'ServiceDropDownConfigurations'
			WHERE [Key]='ProgramIdFilteredBy';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ProgramIdUsesSharedTable') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'ProgramIdUsesSharedTable' 
				,ProgramIdUsesSharedTable 
				,'Y,N'
				,'Program Id Uses in Shared Table' 
				,'N' 
				,'Program Id Uses Shared Table in ServiceDropDownConfigurations Table' 
				,'ServiceDropDownConfigurations' 
				From  ServiceDropdownConfigurations
	 END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ProgramIdUsesSharedTable FROM ServiceDropDownConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Program Id Uses in Shared Table' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Program Id Uses Shared Table in ServiceDropDownConfigurations Table'   
		   ,SourceTableName= 'ServiceDropDownConfigurations'
			WHERE [Key]='ProgramIdUsesSharedTable';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ProgramIdSharedTableStoredProcedure') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'ProgramIdSharedTableStoredProcedure' 
				,ProgramIdSharedTableStoredProcedure
				,'StoredProcedure for Program Id Shared Table' 
				,'Program Id Shared Table StoredProcedure' 
				,'N' 
				,'Program Id Shared Table StoredProcedure in ServiceDropDownConfigurations Table' 
				,'ServiceDropDownConfigurations'
				From  ServiceDropdownConfigurations 
	END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ProgramIdSharedTableStoredProcedure FROM ServiceDropDownConfigurations)
		   ,AcceptedValues = 'StoredProcedure for Program Id Shared Table'
		   ,[Description]= 'Program Id Shared Table StoredProcedure'  
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Program Id Filtered By in ServiceDropDownConfigurations Table'  
		   ,SourceTableName= 'ServiceDropDownConfigurations'
			WHERE [Key]='ProgramIdSharedTableStoredProcedure';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ProgramIdStoredProcedure') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'ProgramIdStoredProcedure' 
				,ProgramIdStoredProcedure 
				,'StoredProcedure for Program Id'
				,'Program Id StoredProcedure' 
				,'N' 
				,'Program Id StoredProcedure in ServiceDropDownConfigurations Table' 
				,'ServiceDropDownConfigurations'
				From  ServiceDropdownConfigurations 
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ProgramIdStoredProcedure FROM ServiceDropDownConfigurations)
		   ,AcceptedValues = 'StoredProcedure for Program Id'
		   ,[Description]= 'Program Id StoredProcedure' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Program Id StoredProcedure in ServiceDropDownConfigurations Table'  
		   ,SourceTableName= 'ServiceDropDownConfigurations'
			WHERE [Key]='ProgramIdStoredProcedure';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ClinicianIdFilteredBy') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'ClinicianIdFilteredBy' 
				,ClinicianIdFilteredBy 
				,'Clinician Id Filtered By' 
				,'Clinician Id to Filter'
				,'N' 
				,'Clinician Id Filtered By in ServiceDropDownConfigurations Table' 
				,'ServiceDropDownConfigurations' 
				From  ServiceDropdownConfigurations
	END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ClinicianIdFilteredBy FROM ServiceDropDownConfigurations)
		   ,AcceptedValues = 'Clinician Id Filtered By'
		   ,[Description]= 'Clinician Id to Filter'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Clinician Id Filtered By in ServiceDropDownConfigurations Table'   
		   ,SourceTableName= 'ServiceDropDownConfigurations'
			WHERE [Key]='ClinicianIdFilteredBy';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ClinicianIdUsesSharedTable') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'ClinicianIdUsesSharedTable' 
				,ClinicianIdUsesSharedTable 
				,'Y,N'
				,'Clinician Id Uses Shared Table' 
				,'N' 
				,'Clinician Id Uses Shared Table in ServiceDropDownConfigurations Table' 
				,'ServiceDropDownConfigurations'
				From  ServiceDropdownConfigurations
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ClinicianIdUsesSharedTable FROM ServiceDropDownConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Clinician Id Uses Shared Table' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Clinician Id Uses Shared Table in ServiceDropDownConfigurations Table'  
		   ,SourceTableName= 'ServiceDropDownConfigurations'
			WHERE [Key]='ClinicianIdUsesSharedTable';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ClinicianIdSharedTableStoredProcedure') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'ClinicianIdSharedTableStoredProcedure' 
				,ClinicianIdSharedTableStoredProcedure
				,'StoredProcedure for Clinician Id Shared Table'
				,'Clinician Id Shared Table StoredProcedure' 
				,'N' 
				,'Clinician Id Shared Table StoredProcedure in ServiceDropDownConfigurations Table' 
				,'ServiceDropDownConfigurations'
				From  ServiceDropdownConfigurations 
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ClinicianIdSharedTableStoredProcedure FROM ServiceDropDownConfigurations)
		   ,AcceptedValues = 'StoredProcedure for Clinician Id Shared Table'
		   ,[Description]= 'Clinician Id Shared Table StoredProcedure'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Clinician Id Shared Table StoredProcedure in ServiceDropDownConfigurations Table'  
		   ,SourceTableName= 'ServiceDropDownConfigurations'
			WHERE [Key]='ClinicianIdSharedTableStoredProcedure';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ClinicianIdStoredProcedure') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'ClinicianIdStoredProcedure' 
				,ClinicianIdStoredProcedure 
				,'StoredProcedure for Clinician Id' 
				,'Clinician Id StoredProcedure'
				,'N' 
				,'Clinician Id StoredProcedure in ServiceDropDownConfigurations Table' 
				,'ServiceDropDownConfigurations'
				From  ServiceDropdownConfigurations
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ClinicianIdStoredProcedure FROM ServiceDropDownConfigurations)
		   ,AcceptedValues = 'StoredProcedure for Clinician Id'
		   ,[Description]= 'Clinician Id StoredProcedure' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Clinician Id StoredProcedure in ServiceDropDownConfigurations Table'
		   ,SourceTableName= 'ServiceDropDownConfigurations'
			WHERE [Key]='ClinicianIdStoredProcedure';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ProcedureCodeIdFilteredBy') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'ProcedureCodeIdFilteredBy' 
				,ProcedureCodeIdFilteredBy
				,'ProcedureCode Id Filter By'
				,'ProcedureCode Id Filtered By' 
				,'N' 
				,'ProcedureCode Id Filtered By in ServiceDropDownConfigurations Table' 
				,'ServiceDropDownConfigurations' 
				From  ServiceDropdownConfigurations 
	END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ProcedureCodeIdFilteredBy FROM ServiceDropDownConfigurations)
		   ,AcceptedValues = 'ProcedureCode Id Filter By'
		   ,[Description]= 'ProcedureCode Id Filtered By' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'ProcedureCode Id Filtered By in ServiceDropDownConfigurations Table'   
		   ,SourceTableName= 'ServiceDropDownConfigurations'
			WHERE [Key]='ProcedureCodeIdFilteredBy';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ProcedureCodeIdUsesSharedTable') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'ProcedureCodeIdUsesSharedTable' 
				,ProcedureCodeIdUsesSharedTable
				,'Y,N'
				,'ProcedureCode Id Uses Shared Table' 
				,'N' 
				,'ProcedureCode Id Uses Shared Table in ServiceDropDownConfigurations Table' 
				,'ServiceDropDownConfigurations' 
				From  ServiceDropdownConfigurations 
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ProcedureCodeIdUsesSharedTable FROM ServiceDropDownConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'ProcedureCode Id Uses Shared Table' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'ProcedureCode Id Uses Shared Table in ServiceDropDownConfigurations Table'  
		   ,SourceTableName= 'ServiceDropDownConfigurations'
			WHERE [Key]='ProcedureCodeIdUsesSharedTable';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ProcedureCodeIdSharedTableStoredProcedure') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'ProcedureCodeIdSharedTableStoredProcedure' 
				,ProcedureCodeIdSharedTableStoredProcedure
				,'StoredProcedure for ProcedureCode Id Shared Table' 
				,'ProcedureCode Id Shared Table StoredProcedure' 
				,'N' 
				,'ProcedureCode Id Shared Table StoredProcedure in ServiceDropDownConfigurations Table' 
				,'ServiceDropDownConfigurations' 
				From  ServiceDropdownConfigurations 
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ProcedureCodeIdSharedTableStoredProcedure FROM ServiceDropDownConfigurations)
		   ,AcceptedValues = 'StoredProcedure for ProcedureCode Id Shared Table' 
		   ,[Description]= 'ProcedureCode Id Shared Table StoredProcedure'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'ProcedureCode Id Shared Table StoredProcedure in ServiceDropDownConfigurations Table'
		   ,SourceTableName= 'ServiceDropDownConfigurations'
			WHERE [Key]='ProcedureCodeIdSharedTableStoredProcedure';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ProcedureCodeIdStoredProcedure') 
	BEGIN  
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'ProcedureCodeIdStoredProcedure' 
				,ProcedureCodeIdStoredProcedure 
				,'StoredProcedure for ProcedureCode Id'
				,'ProcedureCode Id StoredProcedure' 
				,'N' 
				,'ProcedureCode Id StoredProcedure in ServiceDropDownConfigurations Table' 
				,'ServiceDropDownConfigurations'
				From  ServiceDropdownConfigurations
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ProcedureCodeIdStoredProcedure FROM ServiceDropDownConfigurations)
		   ,AcceptedValues = 'StoredProcedure for ProcedureCode Id'
		   ,[Description]= 'ProcedureCode Id StoredProcedure' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'ProcedureCode Id StoredProcedure in ServiceDropDownConfigurations Table'
		   ,SourceTableName= 'ServiceDropDownConfigurations'
			WHERE [Key]='ProcedureCodeIdStoredProcedure';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'LocationIdFilteredBy') 
	BEGIN  
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'LocationIdFilteredBy' 
				,LocationIdFilteredBy 
				,'Location Id Filter By'
				,'Location Id Filtered By' 
				,'N' 
				,'Location Id Filtered By in ServiceDropDownConfigurations Table' 
				,'ServiceDropDownConfigurations' 
				From  ServiceDropdownConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select LocationIdFilteredBy FROM ServiceDropDownConfigurations)
		   ,AcceptedValues = 'Location Id Filter By'
		   ,[Description]= 'Location Id Filtered By' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Location Id Filtered By in ServiceDropDownConfigurations Table'   
		   ,SourceTableName= 'ServiceDropDownConfigurations'
			WHERE [Key]='LocationIdFilteredBy';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'LocationIdUsesSharedTable') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'LocationIdUsesSharedTable' 
				,LocationIdUsesSharedTable 
				,'Y,N'
				,'Location Id Uses Shared Table' 
				,'N' 
				,'Location Id Uses Shared Table in ServiceDropDownConfigurations Table' 
				,'ServiceDropDownConfigurations' 
				From  ServiceDropdownConfigurations 
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select LocationIdUsesSharedTable FROM ServiceDropDownConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Location Id Uses Shared Table' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Location Id Uses Shared Table in ServiceDropDownConfigurations Table' 
		   ,SourceTableName= 'ServiceDropDownConfigurations'
			WHERE [Key]='LocationIdUsesSharedTable';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'LocationIdSharedTableStoredProcedure') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'LocationIdSharedTableStoredProcedure' 
				,LocationIdSharedTableStoredProcedure 
				,'StoredProcedure for Location Id Shared Table'
				,'Location Id Shared Table StoredProcedure' 
				,'N' 
				,'Location Id Shared Table StoredProcedure in ServiceDropDownConfigurations Table' 
				,'ServiceDropDownConfigurations' 
				From  ServiceDropdownConfigurations 
	END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select LocationIdSharedTableStoredProcedure FROM ServiceDropDownConfigurations)
		   ,AcceptedValues = 'StoredProcedure for Location Id Shared Table'
		   ,[Description]= 'Location Id Shared Table StoredProcedure'  
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Location Id Shared Table StoredProcedure in ServiceDropDownConfigurations Table' 
		   ,SourceTableName= 'ServiceDropDownConfigurations'
			WHERE [Key]='LocationIdSharedTableStoredProcedure';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'LocationIdStoredProcedure') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'LocationIdStoredProcedure' 
				,LocationIdStoredProcedure 
				,'StoredProcedure for Location Id'
				,'Location Id StoredProcedure' 
				,'N' 
				,'Location Id StoredProcedure in ServiceDropDownConfigurations Table' 
				,'ServiceDropDownConfigurations'
				From  ServiceDropdownConfigurations
	 END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select LocationIdStoredProcedure FROM ServiceDropDownConfigurations)
		   ,AcceptedValues = 'StoredProcedure for Location Id'
		   ,[Description]= 'Location Id StoredProcedure' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Location Id StoredProcedure in ServiceDropDownConfigurations Table'
		   ,SourceTableName= 'ServiceDropDownConfigurations'
			WHERE [Key]='LocationIdStoredProcedure';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'PlaceOfServiceIdFilteredBy') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'PlaceOfServiceIdFilteredBy' 
				,PlaceOfServiceIdFilteredBy
				,'Place Of Service Id Filtered By' 
				,'Place Of Service Id Filtered By' 
				,'N' 
				,'Place Of Service IdF iltered By in ServiceDropDownConfigurations Table' 
				,'ServiceDropDownConfigurations' 
				From  ServiceDropdownConfigurations 
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select PlaceOfServiceIdFilteredBy FROM ServiceDropDownConfigurations)
		   ,AcceptedValues = 'Place Of Service Id Filtered By'
		   ,[Description]= 'Place Of Service Id Filtered By'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Place Of Service IdF iltered By in ServiceDropDownConfigurations Table' 
		   ,SourceTableName= 'ServiceDropDownConfigurations'
			WHERE [Key]='PlaceOfServiceIdFilteredBy';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'PlaceOfServiceIdUsesSharedTable') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'PlaceOfServiceIdUsesSharedTable' 
				,PlaceOfServiceIdUsesSharedTable
				,'Place Of Service Id for Shared Table' 
				,'Place Of Service Id Uses Shared Table' 
				,'N' 
				,'Place Of Service Id Uses Shared Table in ServiceDropDownConfigurations Table' 
				,'ServiceDropDownConfigurations' 
				From  ServiceDropdownConfigurations 
	END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select PlaceOfServiceIdUsesSharedTable FROM ServiceDropDownConfigurations)
		   ,AcceptedValues = 'Place Of Service Id for Shared Table'
		   ,[Description]= 'Place Of Service Id Uses Shared Table' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Place Of Service Id Uses Shared Table in ServiceDropDownConfigurations Table'
		   ,SourceTableName= 'ServiceDropDownConfigurations'
			WHERE [Key]='PlaceOfServiceIdUsesSharedTable';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'PlaceOfServiceIdSharedTableStoredProcedure') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'PlaceOfServiceIdSharedTableStoredProcedure' 
				,PlaceOfServiceIdSharedTableStoredProcedure 
				,'StoredProcedure for Place Of Service Id Shared Table'
				,'Place Of Service Id Shared Table StoredProcedure' 
				,'N' 
				,'Place Of Service Id Shared Table StoredProcedure in ServiceDropDownConfigurations Table' 
				,'ServiceDropDownConfigurations' 
				From  ServiceDropdownConfigurations
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select PlaceOfServiceIdSharedTableStoredProcedure FROM ServiceDropDownConfigurations)
		   ,AcceptedValues = 'StoredProcedure for Place Of Service Id Shared Table'
		   ,[Description]= 'Place Of Service Id Shared Table StoredProcedure' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Place Of Service Id Shared Table StoredProcedure in ServiceDropDownConfigurations Table'
		   ,SourceTableName= 'ServiceDropDownConfigurations'
			WHERE [Key]='PlaceOfServiceIdSharedTableStoredProcedure';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'PlaceOfServiceIdStoredProcedure') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'PlaceOfServiceIdStoredProcedure' 
				,PlaceOfServiceIdStoredProcedure 
				,'StoredProcedure for Place Of Service Id'
				,'Place Of Service Id StoredProcedure' 
				,'N' 
				,'Place Of Service Id StoredProcedure in ServiceDropDownConfigurations Table' 
				,'ServiceDropDownConfigurations' 
				From  ServiceDropdownConfigurations 
	END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select PlaceOfServiceIdStoredProcedure FROM ServiceDropDownConfigurations)
		   ,AcceptedValues = 'StoredProcedure for Place Of Service Id'
		   ,[Description]= 'Place Of Service Id StoredProcedure' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Place Of Service Id StoredProcedure in ServiceDropDownConfigurations Table' 
		   ,SourceTableName= 'ServiceDropDownConfigurations'
			WHERE [Key]='PlaceOfServiceIdStoredProcedure';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'AttendingIdFilteredBy') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'AttendingIdFilteredBy' 
				,AttendingIdFilteredBy 
				,'Attending Id Filtered By'
				,'Attending Id Filtered By' 
				,'N' 
				,'Attending Id Filtered By in ServiceDropDownConfigurations Table' 
				,'ServiceDropDownConfigurations'
				From  ServiceDropdownConfigurations
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select AttendingIdFilteredBy FROM ServiceDropDownConfigurations)
		   ,AcceptedValues = 'Attending Id Filtered By'
		   ,[Description]= 'Attending Id Filtered By'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Attending Id Filtered By in ServiceDropDownConfigurations Table' 
		   ,SourceTableName= 'ServiceDropDownConfigurations'
			WHERE [Key]='AttendingIdFilteredBy';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'AttendingIdUsesSharedTable') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'AttendingIdUsesSharedTable' 
				,AttendingIdUsesSharedTable 
				,'Y,N'
				,'Attending Id Uses Shared Table' 
				,'N' 
				,'Attending Id Uses Shared Table in ServiceDropDownConfigurations Table' 
				,'ServiceDropDownConfigurations'
				From  ServiceDropdownConfigurations
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select AttendingIdUsesSharedTable FROM ServiceDropDownConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Attending Id Uses Shared Table'  
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Attending Id Uses Shared Table in ServiceDropDownConfigurations Table' 
		   ,SourceTableName= 'ServiceDropDownConfigurations'
			WHERE [Key]='AttendingIdUsesSharedTable';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'AttendingIdSharedTableStoredProcedure') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'AttendingIdSharedTableStoredProcedure' 
				,AttendingIdSharedTableStoredProcedure
				,'StoredProcedure for Attending Id Shared Table' 
				,'Attending Id Shared Table StoredProcedure' 
				,'N' 
				,'Attending Id Shared Table StoredProcedure in ServiceDropDownConfigurations Table' 
				,'ServiceDropDownConfigurations' 
				From  ServiceDropdownConfigurations
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select AttendingIdSharedTableStoredProcedure FROM ServiceDropDownConfigurations)
		   ,AcceptedValues = 'StoredProcedure for Attending Id Shared Table' 
		   ,[Description]= 'Attending Id Shared Table StoredProcedure'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Attending Id Shared Table StoredProcedure in ServiceDropDownConfigurations Table' 
		   ,SourceTableName= 'ServiceDropDownConfigurations'
			WHERE [Key]='AttendingIdSharedTableStoredProcedure';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'AttendingIdStoredProcedure') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'AttendingIdStoredProcedure' 
				,AttendingIdStoredProcedure 
				,'StoredProcedure for Attending Id'
				,'Attending Id StoredProcedure' 
				,'N' 
				,'Attending Id StoredProcedure in ServiceDropDownConfigurations Table' 
				,'ServiceDropDownConfigurations' 
				From  ServiceDropdownConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select AttendingIdStoredProcedure FROM ServiceDropDownConfigurations)
		   ,AcceptedValues = 'StoredProcedure for Attending Id'
		   ,[Description]= 'Attending Id StoredProcedure' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Attending Id StoredProcedure in ServiceDropDownConfigurations Table'  
		   ,SourceTableName= 'ServiceDropDownConfigurations'
			WHERE [Key]='AttendingIdStoredProcedure';
   END	
/********************************* systemconfigurationkeys table *****************************************/


--select * from ServiceDropDownConfigurations

----CreatedBy
----CreatedDate
----ModifiedBy
----ModifiedDate
----RecordDeleted
----DeletedDate
----DeletedBy
--			ProgramIdFilteredBy
--			ProgramIdUsesSharedTable
--			ProgramIdSharedTableStoredProcedure
--			ProgramIdStoredProcedure
--			ClinicianIdFilteredBy
--			ClinicianIdUsesSharedTable
--			ClinicianIdSharedTableStoredProcedure
--			ClinicianIdStoredProcedure
--			ProcedureCodeIdFilteredBy
--			ProcedureCodeIdUsesSharedTable
--			ProcedureCodeIdSharedTableStoredProcedure
--			ProcedureCodeIdStoredProcedure
--			LocationIdFilteredBy
--			LocationIdUsesSharedTable
--			LocationIdSharedTableStoredProcedure
--			LocationIdStoredProcedure
--			PlaceOfServiceIdFilteredBy
--			PlaceOfServiceIdUsesSharedTable
--			PlaceOfServiceIdSharedTableStoredProcedure
--			PlaceOfServiceIdStoredProcedure
--			AttendingIdFilteredBy
--			AttendingIdUsesSharedTable
--			AttendingIdSharedTableStoredProcedure
--			AttendingIdStoredProcedure
