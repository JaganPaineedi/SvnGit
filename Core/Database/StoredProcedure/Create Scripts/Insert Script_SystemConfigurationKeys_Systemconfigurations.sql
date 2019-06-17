
IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'OrganizationName') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT 'OrganizationName' 
				,OrganizationName
				,'Organization Name'
				,'Organization Name' 
				,'N' 
				,'Organization Name in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select OrganizationName FROM SystemConfigurations)
		   ,AcceptedValues = 'Organization Name'
		   ,[Description]= 'Organization Name'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Organization Name in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='OrganizationName';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'StateFIPS') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT 'StateFIPS' 
				,StateFIPS 
				,'State FIPS must be from States Table'
				,'State FIPS' 
				,'N' 
				,'State FIPSin SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations
	 END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select StateFIPS FROM SystemConfigurations)
		   ,AcceptedValues = 'State FIPS must be from States Table'
		   ,[Description]= 'State FIPS'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'State FIPSin SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='StateFIPS';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'LastUserName') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'LastUserName' 
				,LastUserName
				,'Last User Name who access' 
				,'Last User Name' 
				,'N' 
				,'Last User Name in SystemConfigurations Table' 
				,'SystemConfigurations'
				from SystemConfigurations 
	 END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select LastUserName FROM SystemConfigurations)
		   ,AcceptedValues = 'Last User Name who access' 
		   ,[Description]= 'Last User Name'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Last User Name in SystemConfigurations Table' 
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='LastUserName';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'FiscalMonth') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'FiscalMonth' 
				,FiscalMonth 
				,'Month'
				,'Fiscal Month' 
				,'N' 
				,'Fiscal Month in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
   END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select FiscalMonth FROM SystemConfigurations)
		   ,AcceptedValues = 'Month'
		   ,[Description]= 'Fiscal Month'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Fiscal Month in SystemConfigurations Table' 
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='FiscalMonth';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'DatabaseVersion') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'DatabaseVersion' 
				,DatabaseVersion
				,'Version of Database' 
				,'Database Version'
				,'N' 
				,'Database Version in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select DatabaseVersion FROM SystemConfigurations)
		   ,AcceptedValues = 'Version of Database'
		   ,[Description]= 'Database Version'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Database Version in SystemConfigurations Table'   
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='DatabaseVersion';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'AutoCreateDiagnosisFromAssessment') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'AutoCreateDiagnosisFromAssessment' 
				,AutoCreateDiagnosisFromAssessment 
				,'Y,N'
				,'Auto Create Diagnosis From Assessment' 
				,'N' 
				,'Auto Create Diagnosis From Assessment in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select AutoCreateDiagnosisFromAssessment FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Auto Create Diagnosis From Assessment'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Auto Create Diagnosis From Assessment in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='AutoCreateDiagnosisFromAssessment';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'IntializeAssessmentDiagnosis') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'IntializeAssessmentDiagnosis' 
				,IntializeAssessmentDiagnosis 
				,'Y,N' 
				,'Intialize Assessment Diagnosis'
				,'N' 
				,'Intialize Assessment Diagnosis in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
    END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select IntializeAssessmentDiagnosis FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Intialize Assessment Diagnosis'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Intialize Assessment Diagnosis in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='IntializeAssessmentDiagnosis';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'CareManagementInsurerName') 
	BEGIN  
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'CareManagementInsurerName' 
				,CareManagementInsurerName 
				,'Insurer Name'
				,'Care Management Insurer Name' 
				,'N' 
				,'Care Management Insurer Name in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
    END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select CareManagementInsurerName FROM SystemConfigurations)
		   ,AcceptedValues = 'Insurer Name'
		   ,[Description]= 'Care Management Insurer Name' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Care Management Insurer Name in SystemConfigurations Table' 
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='CareManagementInsurerName';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'CareManagementComment') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'CareManagementComment' 
				,CareManagementComment 
				,'Care Management Comment'
				,'Care Management Comment' 
				,'N' 
				,'Care Management Comment in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select CareManagementComment FROM SystemConfigurations)
		   ,AcceptedValues = 'Care Management Comment'
		   ,[Description]= 'Care Management Comment'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Care Management Comment in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='CareManagementComment';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'SCDefaultDoNotComplete') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'SCDefaultDoNotComplete' 
				,SCDefaultDoNotComplete
				,'Y,N' 
				,'SC Default Do Not Complete' 
				,'N' 
				,'SC default do not complete in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
    END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select SCDefaultDoNotComplete FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'SC Default Do Not Complete'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'SC default do not complete in SystemConfigurations Table' 
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='SCDefaultDoNotComplete';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'MedicationDaysDefault') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'MedicationDaysDefault' 
				,MedicationDaysDefault 
				,'Number of Days'
				,'Medication Days Default' 
				,'N' 
				,'Medication Days Default in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select MedicationDaysDefault FROM SystemConfigurations)
		   ,AcceptedValues = 'Number of Days'
		   ,[Description]= 'Medication Days Default'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Medication Days Default in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='MedicationDaysDefault';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'RecurringAppointmentsExpandedFromDays') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'RecurringAppointmentsExpandedFromDays' 
				,RecurringAppointmentsExpandedFromDays 
				,'Number of Days'
				,'Recurring Appointments Expanded From Days' 
				,'N' 
				,'Recurring Appointments Expanded From Days in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
     END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select RecurringAppointmentsExpandedFromDays FROM SystemConfigurations)
		   ,AcceptedValues = 'Number of Days'
		   ,[Description]= 'Recurring Appointments Expanded From Days'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Recurring Appointments Expanded From Days in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='RecurringAppointmentsExpandedFromDays';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'RecurringAppointmentsExpandedToDays') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'RecurringAppointmentsExpandedToDays' 
				,RecurringAppointmentsExpandedToDays 
				,'Number of Days'
				,'Recurring Appointments Expanded To Days' 
				,'N' 
				,'Recurring Appointments Expanded To Days in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select RecurringAppointmentsExpandedToDays FROM SystemConfigurations)
		   ,AcceptedValues = 'Number of Days'
		   ,[Description]= 'Recurring Appointments Expanded To Days'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Recurring Appointments Expanded To Days in SystemConfigurations Table' 
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='RecurringAppointmentsExpandedToDays';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'RecurringAppointmentsExpandedFrom') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'RecurringAppointmentsExpandedFrom' 
				,RecurringAppointmentsExpandedFrom 
				,'YYYY-MM-DD'
				,'Recurring Appointments Expanded From' 
				,'N' 
				,'Recurring Appointments Expanded From in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select RecurringAppointmentsExpandedFrom FROM SystemConfigurations)
		   ,AcceptedValues = 'YYYY-MM-DD'
		   ,[Description]= 'Recurring Appointments Expanded From'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Recurring Appointments Expanded From in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='RecurringAppointmentsExpandedFrom';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'RecurringAppointmentsExpandedTo') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'RecurringAppointmentsExpandedTo' 
				,RecurringAppointmentsExpandedTo 
				,'YYYY-MM-DD'
				,'Recurring Appointments Expanded To' 
				,'N' 
				,'Recurring Appointments Expanded To in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select RecurringAppointmentsExpandedTo FROM SystemConfigurations)
		   ,AcceptedValues = 'YYYY-MM-DD'
		   ,[Description]= 'Recurring Appointments Expanded To' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Recurring Appointments Expanded To in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='RecurringAppointmentsExpandedTo';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowGroupsBanner') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'ShowGroupsBanner' 
				,ShowGroupsBanner
				,'Y,N' 
				,'Show Groups Banner' 
				,'N' 
				,'Show Groups Banner in SystemConfigurations Table' 
				,'SystemConfigurations'
				from SystemConfigurations 
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ShowGroupsBanner FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Show Groups Banner'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Show Groups Banner in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='ShowGroupsBanner';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowBedCensusBanner') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'ShowBedCensusBanner' 
				,ShowBedCensusBanner
				,'Y,N' 
				,'Show Bed Census Banner' 
				,'N' 
				,'Show Bed Census Banner in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ShowBedCensusBanner FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Show Bed Census Banner'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Show Bed Census Banner in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='ShowBedCensusBanner';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'FilterTPAuthorizationCodesByAssigned') 
	BEGIN  
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'FilterTPAuthorizationCodesByAssigned' 
				,FilterTPAuthorizationCodesByAssigned 
				,'Y,N'
				,'Filter TP Authorization Codes By Assigned' 
				,'N' 
				,'Filter TP Authorization Codes By Assigned in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select FilterTPAuthorizationCodesByAssigned FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Filter TP Authorization Codes By Assigned'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Filter TP Authorization Codes By Assigned in SystemConfigurations Table' 
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='FilterTPAuthorizationCodesByAssigned';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowTPProceduresViewMode') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'ShowTPProceduresViewMode' 
				,ShowTPProceduresViewMode 
				,'Y,N'
				,'Show TP Procedures View Mode' 
				,'N' 
				,'Show TP Procedures View Mode in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ShowTPProceduresViewMode FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Show TP Procedures View Mode'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Show TP Procedures View Mode in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='ShowTPProceduresViewMode';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'DisableNoShowNotes') 
	BEGIN
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'DisableNoShowNotes' 
				,DisableNoShowNotes
				,'Y,N'
				,'Disable No Show Notes' 
				,'N' 
				,'Disable No Show Notes in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
   END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select DisableNoShowNotes FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Disable No Show Notes'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Disable No Show Notes in SystemConfigurations Table'   
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='DisableNoShowNotes';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'DisableCancelNotes') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'DisableCancelNotes' 
				,DisableCancelNotes 
				,'Y,N'
				,'Disable Cancel Notes' 
				,'N' 
				,'Disable Cancel Notes in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select DisableCancelNotes FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Disable Cancel Notes' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Disable Cancel Notes in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='DisableCancelNotes';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'DisableCancelEventNotes') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'DisableCancelEventNotes' 
				,DisableCancelEventNotes
				,'Y,N' 
				,'Disable Cancel Event Notes' 
				,'N' 
				,'Disable Cancel Event Notes in SystemConfigurations Table' 
				,'SystemConfigurations'
				from SystemConfigurations 
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select DisableCancelEventNotes FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N' 
		   ,[Description]= 'Disable Cancel Event Notes'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Disable Cancel Event Notes in SystemConfigurations Table'   
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='DisableCancelEventNotes';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'MedicationPatientOverviewTemplate') 
	BEGIN  
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'MedicationPatientOverviewTemplate' 
				,MedicationPatientOverviewTemplate
				,'Template Design'
				,'Medication Patient Overview Template' 
				,'N' 
				,'Medication Patient Overview Template in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select MedicationPatientOverviewTemplate FROM SystemConfigurations)
		   ,AcceptedValues = 'Template Design'
		   ,[Description]= 'Medication Patient Overview Template'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Medication Patient Overview Template in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='MedicationPatientOverviewTemplate';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'MedicationRxEndDateOffset') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'MedicationRxEndDateOffset' 
				,MedicationRxEndDateOffset 
				,'End Date Offset (Numeric Value)'
				,'Medication Rx End Date Offset' 
				,'N' 
				,'Medication Rx End Date Offset in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select MedicationRxEndDateOffset FROM SystemConfigurations)
		   ,AcceptedValues = 'End Date Offset (Numeric Value)'
		   ,[Description]= 'Medication Rx End Date Offset'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Medication Rx End Date Offset in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='MedicationRxEndDateOffset';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'SystemDatabaseId') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'SystemDatabaseId' 
				,SystemDatabaseId 
				,'System Database Id'
				,'System Database Id' 
				,'N' 
				,'System Database Id in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select SystemDatabaseId FROM SystemConfigurations)
		   ,AcceptedValues = 'System Database Id'
		   ,[Description]= 'System Database Id'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'System Database Id in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='SystemDatabaseId';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'EnablePrescriberSecurityQuestion') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'EnablePrescriberSecurityQuestion' 
				,EnablePrescriberSecurityQuestion 
				,'Y,N'
				,'Enable Prescriber Security Question' 
				,'N' 
				,'Enable Prescriber Security Question in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select EnablePrescriberSecurityQuestion FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Enable Prescriber Security Question'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Enable Prescriber Security Question in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='EnablePrescriberSecurityQuestion';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ProxyVerificationMessage') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'ProxyVerificationMessage' 
				,ProxyVerificationMessage 
				,'Verification Message'
				,'Proxy Verification Message' 
				,'N' 
				,'Proxy Verification Message in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ProxyVerificationMessage FROM SystemConfigurations)
		   ,AcceptedValues = 'Verification Message'
		   ,[Description]= 'Proxy Verification Message'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Proxy Verification Message in SystemConfigurations Table'   
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='ProxyVerificationMessage';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'NumberOfSecurityQuestions') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'NumberOfSecurityQuestions' 
				,NumberOfSecurityQuestions 
				,'Numeric Value'
				,'Number Of Security Questions' 
				,'N' 
				,'Number Of Security Questions in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select NumberOfSecurityQuestions FROM SystemConfigurations)
		   ,AcceptedValues = 'Numeric Value'
		   ,[Description]= 'Number Of Security Questions'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Number Of Security Questions in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='NumberOfSecurityQuestions';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'NumberOfPrescriberSecurityQuestions') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'NumberOfPrescriberSecurityQuestions' 
				,NumberOfPrescriberSecurityQuestions 
				,'Numeric Value'
				,'Number Of Prescriber Security Questions' 
				,'N' 
				,'Number Of Prescriber Security Questions in SystemConfigurations Table' 
				,'SystemConfigurations'
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select NumberOfPrescriberSecurityQuestions FROM SystemConfigurations)
		   ,AcceptedValues = 'Numeric Value'
		   ,[Description]= 'Number Of Prescriber Security Questions'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Number Of Prescriber Security Questions in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='NumberOfPrescriberSecurityQuestions';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'PharmacyCoverLetters') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'PharmacyCoverLetters' 
				,PharmacyCoverLetters
				,'Numeric Value'
				,'Pharmacy Cover Letters' 
				,'N' 
				,'Pharmacy Cover Letters in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select PharmacyCoverLetters FROM SystemConfigurations)
		   ,AcceptedValues = 'Numeric Value'
		   ,[Description]= 'Pharmacy Cover Letters'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Pharmacy Cover Letters in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='PharmacyCoverLetters';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'EnablePrescriptionReview') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'EnablePrescriptionReview' 
				,EnablePrescriptionReview
				,'Y,N'
				,'Enable Prescription Review' 
				,'N' 
				,'Enable Prescription Review in SystemConfigurations Table' 
				,'SystemConfigurations'
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select EnablePrescriptionReview FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Enable Prescription Review' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Enable Prescription Review in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='EnablePrescriptionReview';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'VerbalOrdersRequireApproval') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'VerbalOrdersRequireApproval' 
				,VerbalOrdersRequireApproval 
				,'Y,N'
				,'Verbal Orders Require Approval' 
				,'N' 
				,'Verbal Orders Require Approval in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select VerbalOrdersRequireApproval FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Verbal Orders Require Approval'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Verbal Orders Require Approval in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='VerbalOrdersRequireApproval';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'AllowRePrintFax') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'AllowRePrintFax' 
				,AllowRePrintFax 
				,'Y,N'
				,'Allow Re-Print Fax' 
				,'N' 
				,'Allow Re-Print Fax in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select AllowRePrintFax FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Allow Re-Print Fax'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Allow Re-Print Fax in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='AllowRePrintFax';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'AllowAllergyMedications') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'AllowAllergyMedications' 
				,AllowAllergyMedications 
				,'Y,N'
				,'Allow Allergy Medications' 
				,'N' 
				,'Allow Allergy Medications in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select AllowAllergyMedications FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Allow Allergy Medications'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Allow Allergy Medications in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='AllowAllergyMedications';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'AutoSaveTimeDuration') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'AutoSaveTimeDuration' 
				,AutoSaveTimeDuration 
				,'Time in Seconds'
				,'Auto Save Time Duration' 
				,'N' 
				,'Auto Save Time Duration in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select AutoSaveTimeDuration FROM SystemConfigurations)
		   ,AcceptedValues = 'Time in Seconds'
		   ,[Description]= 'Auto Save Time Duration' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Auto Save Time Duration in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='AutoSaveTimeDuration';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'AutoSaveEnabled') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'AutoSaveEnabled' 
				,AutoSaveEnabled 
				,'Y,N'
				,'Auto Save Enabled' 
				,'N' 
				,'Auto Save Enabled in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select AutoSaveEnabled FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Auto Save Enabled' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Auto Save Enabled in SystemConfigurations Table' 
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='AutoSaveEnabled';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'SureScriptsOrganizationId') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'SureScriptsOrganizationId' 
				,SureScriptsOrganizationId 
				,'Organization Id'
				,'Sure Scripts Organization Id' 
				,'N' 
				,'Sure Scripts Organization Id in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select SureScriptsOrganizationId FROM SystemConfigurations)
		   ,AcceptedValues = 'Organization Id'
		   ,[Description]= 'Sure Scripts Organization Id'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Sure Scripts Organization Id in SystemConfigurations Table'   
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='SureScriptsOrganizationId';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ConsentDurationMonths') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'ConsentDurationMonths' 
				,ConsentDurationMonths 
				,'Number of Months'
				,'Consent Duration Months' 
				,'N' 
				,'Consent Duration Months in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ConsentDurationMonths FROM SystemConfigurations)
		   ,AcceptedValues = 'Number of Months'
		   ,[Description]= 'Consent Duration Months'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Consent Duration Months in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='ConsentDurationMonths';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'MedConsentsRequireClientSignature') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'MedConsentsRequireClientSignature' 
				,MedConsentsRequireClientSignature 
				,'Y,N'
				,'Med Consents Require Client Signature' 
				,'N' 
				,'Med Consents Require Client Signature in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select MedConsentsRequireClientSignature FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Med Consents Require Client Signature'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Med Consents Require Client Signature in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='MedConsentsRequireClientSignature';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'EnableOtherPrescriberSelection') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'EnableOtherPrescriberSelection' 
				,EnableOtherPrescriberSelection 
				,'Y,N'
				,'Enable Other Prescriber Selection' 
				,'N' 
				,'Enable Other Prescriber Selection in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select EnableOtherPrescriberSelection FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Enable Other Prescriber Selection'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Enable Other Prescriber Selection in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='EnableOtherPrescriberSelection';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ReleaseListPageDefaultDocumentBannerId') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'ReleaseListPageDefaultDocumentBannerId' 
				,ReleaseListPageDefaultDocumentBannerId 
				,'Banner Id'
				,'Release List Page Default Document Banner Id' 
				,'N' 
				,'Release List Page Default Document Banner Id in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ReleaseListPageDefaultDocumentBannerId FROM SystemConfigurations)
		   ,AcceptedValues = 'Banner Id'
		   ,[Description]= 'Release List Page Default Document Banner Id' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Release List Page Default Document Banner Id in SystemConfigurations Table' 
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='ReleaseListPageDefaultDocumentBannerId';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ListPageRowsPerPage') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'ListPageRowsPerPage' 
				,ListPageRowsPerPage 
				,'Numeric Value'
				,'List Page Rows Per Page' 
				,'N' 
				,'List Page Rows Per Page in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ListPageRowsPerPage FROM SystemConfigurations)
		   ,AcceptedValues = 'Numeric Value'
		   ,[Description]= 'List Page Rows Per Page'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'List Page Rows Per Page in SystemConfigurations Table' 
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='ListPageRowsPerPage';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'MergeClientsProcess') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'MergeClientsProcess' 
				,MergeClientsProcess 
				,'Process'
				,'Merge Clients Process' 
				,'N' 
				,'Merge Clients Process in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select MergeClientsProcess FROM SystemConfigurations)
		   ,AcceptedValues = 'Process'
		   ,[Description]= 'Merge Clients Process'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Merge Clients Process in SystemConfigurations Table' 
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='MergeClientsProcess';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'NumberOfDaysRecurringServicesSchedule') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'NumberOfDaysRecurringServicesSchedule' 
				,NumberOfDaysRecurringServicesSchedule 
				,'Number Of Days'
				,'Number Of Days Recurring Services Schedule' 
				,'N' 
				,'Number Of Days Recurring Services Schedule in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select NumberOfDaysRecurringServicesSchedule FROM SystemConfigurations)
		   ,AcceptedValues = 'Number Of Days'
		   ,[Description]= 'Number Of Days Recurring Services Schedule'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Number Of Days Recurring Services Schedule in SystemConfigurations Table'   
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='NumberOfDaysRecurringServicesSchedule';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ChangeOrderStartDateUseToday') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'ChangeOrderStartDateUseToday' 
				,ChangeOrderStartDateUseToday 
				,'Y,N'
				,'Change Order Start Date Use Today' 
				,'N' 
				,'Change Order Start Date Use Today in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ChangeOrderStartDateUseToday FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Change Order Start Date Use Today'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Change Order Start Date Use Today in SystemConfigurations Table' 
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='ChangeOrderStartDateUseToday';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowNotificationPollingInterval') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'ShowNotificationPollingInterval' 
				,ShowNotificationPollingInterval 
				,'Polling Interval'
				,'Show Notification Polling Interval' 
				,'N' 
				,'Show Notification Polling Interval in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ShowNotificationPollingInterval FROM SystemConfigurations)
		   ,AcceptedValues = 'Polling Interval'
		   ,[Description]= 'Show Notification Polling Interval'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Show Notification Polling Interval in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='ShowNotificationPollingInterval';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'EmergencyAccessMinutes') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'EmergencyAccessMinutes' 
				,EmergencyAccessMinutes 
				,'Numeric Value'
				,'Emergency Access Minutes' 
				,'N' 
				,'Emergency Access Minutes in SystemConfigurations Table' 
				,'SystemConfigurations'
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select EmergencyAccessMinutes FROM SystemConfigurations)
		   ,AcceptedValues = 'Numeric Value'
		   ,[Description]= 'Emergency Access Minutes'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Emergency Access Minutes in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='EmergencyAccessMinutes';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'DocumentsInProgressShowWatermark') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'DocumentsInProgressShowWatermark' 
				,DocumentsInProgressShowWatermark 
				,'Y,N'
				,'Documents In Progress Show Watermark' 
				,'N' 
				,'Documents In Progress Show Watermark in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select DocumentsInProgressShowWatermark FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Documents In Progress Show Watermark'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Documents In Progress Show Watermark in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='DocumentsInProgressShowWatermark';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'DocumentsInProgressWatermarkImageLocation') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'DocumentsInProgressWatermarkImageLocation' 
				,DocumentsInProgressWatermarkImageLocation 
				,'Image Location'
				,'Documents In Progress Watermark Image Location' 
				,'N' 
				,'Documents In Progress Watermark Image Location in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select DocumentsInProgressWatermarkImageLocation FROM SystemConfigurations)
		   ,AcceptedValues = 'Image Location'
		   ,[Description]= 'Documents In Progress Watermark Image Location'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Documents In Progress Watermark Image Location in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='DocumentsInProgressWatermarkImageLocation';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'AllowMessageToBePartOfClientRecord') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'AllowMessageToBePartOfClientRecord' 
				,AllowMessageToBePartOfClientRecord 
				,'A,Y,N'
				,'Allow Message To Be Part Of Client Record' 
				,'N' 
				,'Allow Message To Be Part Of Client Record in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select AllowMessageToBePartOfClientRecord FROM SystemConfigurations)
		   ,AcceptedValues = 'A,Y,N'
		   ,[Description]= 'Allow Message To Be Part Of Client Record'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Allow Message To Be Part Of Client Record in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='AllowMessageToBePartOfClientRecord';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'DefaultMessageToBePartOfClientRecord') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'DefaultMessageToBePartOfClientRecord' 
				,DefaultMessageToBePartOfClientRecord 
				,'Y,N'
				,'Default Message To Be Part Of Client Record' 
				,'N' 
				,'Default Message To Be Part Of Client Record in SystemConfigurations Table' 
				,'SystemConfigurations'
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select DefaultMessageToBePartOfClientRecord FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Default Message To Be Part Of Client Record'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Default Message To Be Part Of Client Record in SystemConfigurations Table'   
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='DefaultMessageToBePartOfClientRecord';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ClientEducationHealthDataMonths') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'ClientEducationHealthDataMonths' 
				,ClientEducationHealthDataMonths 
				,'Number of months'
				,'Client Education Health Data Months' 
				,'N' 
				,'Client Education Health Data Months in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ClientEducationHealthDataMonths FROM SystemConfigurations)
		   ,AcceptedValues = 'Number of months'
		   ,[Description]= 'Client Education Health Data Months'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Client Education Health Data Months in SystemConfigurations Table' 
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='ClientEducationHealthDataMonths';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'SystemConfigurations') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'SystemConfigurations' 
				,SystemConfigurations 
				,'Numeric Value'
				,'System Configurations' 
				,'N' 
				,'System Configurations in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select SystemConfigurations FROM SystemConfigurations)
		   ,AcceptedValues = 'Numeric Value'
		   ,[Description]= 'System Configurations'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'System Configurations in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='SystemConfigurations';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'DisclosureCoverLetterReportFolderId') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'DisclosureCoverLetterReportFolderId' 
				,DisclosureCoverLetterReportFolderId 
				,'Numeric Value'
				,'Disclosure Cover Letter Report Folder Id' 
				,'N' 
				,'Disclosure Cover Letter Report Folder Id in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select DisclosureCoverLetterReportFolderId FROM SystemConfigurations)
		   ,AcceptedValues = 'Numeric Value'
		   ,[Description]= 'Disclosure Cover Letter Report Folder Id'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Disclosure Cover Letter Report Folder Id in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='DisclosureCoverLetterReportFolderId';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'DisclosureReportsFolderId') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'DisclosureReportsFolderId' 
				,DisclosureReportsFolderId 
				,'Numeric Value'
				,'Disclosure Reports Folder Id' 
				,'N' 
				,'Disclosure Reports Folder Id in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select DisclosureReportsFolderId FROM SystemConfigurations)
		   ,AcceptedValues = 'Numeric Value'
		   ,[Description]= 'Disclosure Reports Folder Id'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Disclosure Reports Folder Id in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='DisclosureReportsFolderId';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'AllowStaffAuthorizations') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'AllowStaffAuthorizations' 
				,AllowStaffAuthorizations 
				,'Y,N'
				,'Allow Staff Authorizations' 
				,'N' 
				,'Allow Staff Authorizations in SystemConfigurations Table' 
				,'SystemConfigurations'
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select AllowStaffAuthorizations FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Allow Staff Authorizations'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Allow Staff Authorizations in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='AllowStaffAuthorizations';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'FaxingInterface') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'FaxingInterface' 
				,FaxingInterface 
				,'Global Code Type'
				,'Faxing Interface' 
				,'N' 
				,'Faxing Interface in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select FaxingInterface FROM SystemConfigurations)
		   ,AcceptedValues = 'Global Code Type'
		   ,[Description]= 'Faxing Interface'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Faxing Interface in SystemConfigurations Table' 
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='FaxingInterface';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ServiceDetailsServicePagePath') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'ServiceDetailsServicePagePath' 
				,ServiceDetailsServicePagePath
				,'Details Service Page Path'
				,'Service Details Service Page Path' 
				,'N' 
				,'Service Details Service Page Path in SystemConfigurations Table' 
				,'SystemConfigurations'
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ServiceDetailsServicePagePath FROM SystemConfigurations)
		   ,AcceptedValues = 'Details Service Page Path'
		   ,[Description]= 'Service Details Service Page Path'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Service Details Service Page Path in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='ServiceDetailsServicePagePath';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ServiceNoteServicePagePath') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'ServiceNoteServicePagePath' 
				,ServiceNoteServicePagePath
				,'Service Note Service Page Path'
				,'Service Note Service Page Path' 
				,'N' 
				,'Service Note Service Page Path in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ServiceNoteServicePagePath FROM SystemConfigurations)
		   ,AcceptedValues = 'Service Note Service Page Path'
		   ,[Description]= 'Service Note Service Page Path'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Service Note Service Page Path in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='ServiceNoteServicePagePath';
   END	 
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ScreenCustomTabExceptions') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'ScreenCustomTabExceptions' 
				,ScreenCustomTabExceptions 
				,'Tab Exceptions'
				,'Screen Custom Tab Exceptions' 
				,'N' 
				,'Screen Custom Tab Exceptions in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ScreenCustomTabExceptions FROM SystemConfigurations)
		   ,AcceptedValues = 'Tab Exceptions'
		   ,[Description]= 'Screen Custom Tab Exceptions' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Screen Custom Tab Exceptions in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='ScreenCustomTabExceptions';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'EnableADAuthentication') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'EnableADAuthentication' 
				,EnableADAuthentication 
				,'Y,N'
				,'Enable AD Authentication' 
				,'N' 
				,'Enable AD Authentication in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select EnableADAuthentication FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Enable AD Authentication'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Enable AD Authentication in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='EnableADAuthentication';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'UseKeyPhrases') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'UseKeyPhrases' 
				,UseKeyPhrases 
				,'Y,N'
				,'Use Key Phrases' 
				,'N' 
				,'Use Key Phrases in SystemConfigurations Table' 
				,'SystemConfigurations'
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select UseKeyPhrases FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Use Key Phrases'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Use Key Phrases in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='UseKeyPhrases';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'OnlyChargeClientsWithFeeArrangement') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'OnlyChargeClientsWithFeeArrangement' 
				,OnlyChargeClientsWithFeeArrangement 
				,'Y,N'
				,'Only Charge Clients With Fee Arrangement' 
				,'N' 
				,'Only Charge Clients With Fee Arrangement in SystemConfigurations Table' 
				,'SystemConfigurations'
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select OnlyChargeClientsWithFeeArrangement FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Only Charge Clients With Fee Arrangement'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Only Charge Clients With Fee Arrangement in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='OnlyChargeClientsWithFeeArrangement';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'DocumentLockCheckProcessFrequency') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'DocumentLockCheckProcessFrequency' 
				,DocumentLockCheckProcessFrequency 
				,'Numeric Value'
				,'Document Lock Check Process Frequency' 
				,'N' 
				,'Document Lock Check Process Frequency in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select DocumentLockCheckProcessFrequency FROM SystemConfigurations)
		   ,AcceptedValues = 'Numeric Value'
		   ,[Description]= 'Document Lock Check Process Frequency'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Document Lock Check Process Frequency in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='DocumentLockCheckProcessFrequency';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'DocumentsDefaultCurrentEffectiveDate') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'DocumentsDefaultCurrentEffectiveDate' 
				,DocumentsDefaultCurrentEffectiveDate 
				,'Y,N'
				,'Documents Default Current Effective Date' 
				,'N' 
				,'Documents Default Current Effective Date in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select DocumentsDefaultCurrentEffectiveDate FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Documents Default Current Effective Date'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Documents Default Current Effective Date in SystemConfigurations Table' 
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='DocumentsDefaultCurrentEffectiveDate';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'RefillStartUseEndPlusOne') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'RefillStartUseEndPlusOne' 
				,RefillStartUseEndPlusOne 
				,'Y,N'
				,'Refill Start Use End Plus One' 
				,'N' 
				,'Refill Start Use End Plus One in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select RefillStartUseEndPlusOne FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Refill Start Use End Plus One'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Refill Start Use End Plus One in SystemConfigurations Table' 
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='RefillStartUseEndPlusOne';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'HideCustomAuthorizationControls') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'HideCustomAuthorizationControls' 
				,HideCustomAuthorizationControls 
				,'Y,N'
				,'Hide Custom Authorization Controls' 
				,'N' 
				,'Hide Custom Authorization Controls in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select HideCustomAuthorizationControls FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Hide Custom Authorization Controls'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Hide Custom Authorization Controls in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='HideCustomAuthorizationControls';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'DocumentSignaturesNoPassword') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'DocumentSignaturesNoPassword' 
				,DocumentSignaturesNoPassword 
				,'Y,N'
				,'Document Signatures No Password' 
				,'N' 
				,'Document Signatures No Password in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select DocumentSignaturesNoPassword FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Document Signatures No Password'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Document Signatures No Password in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='DocumentSignaturesNoPassword';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'PopulationTracking') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'PopulationTracking' 
				,PopulationTracking 
				,'Y,N'
				,'Population Tracking' 
				,'N' 
				,'Population Tracking in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select PopulationTracking FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Population Tracking'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Population Tracking in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='PopulationTracking';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'FaxCoverLetterFolderId') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'FaxCoverLetterFolderId' 
				,FaxCoverLetterFolderId 
				,'Folder Id'
				,'Fax Cover Letter Folder Id' 
				,'N' 
				,'Fax Cover Letter Folder Id in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select FaxCoverLetterFolderId FROM SystemConfigurations)
		   ,AcceptedValues = 'Folder Id'
		   ,[Description]= 'Fax Cover Letter Folder Id'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Fax Cover Letter Folder Id in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='FaxCoverLetterFolderId';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShareDocumentOnSave') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'ShareDocumentOnSave' 
				,ShareDocumentOnSave 
				,'Y,N'
				,'Share Document On Save' 
				,'N' 
				,'Share Document On Save in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ShareDocumentOnSave FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Share Document On Save' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Share Document On Save in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='ShareDocumentOnSave';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'LimitMyCaseLoadPrograms') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'LimitMyCaseLoadPrograms' 
				,LimitMyCaseLoadPrograms 
				,'Y,N'
				,'Limit My Case Load Programs' 
				,'N' 
				,'Limit My Case Load Programs in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select LimitMyCaseLoadPrograms FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Limit My Case Load Programs'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Limit My Case Load Programs in SystemConfigurations Table' 
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='LimitMyCaseLoadPrograms';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ReportURL') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'ReportURL' 
				,ReportURL 
				,'URL of Report Server'
				,'Report URL' 
				,'N' 
				,'Report URL in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ReportURL FROM SystemConfigurations)
		   ,AcceptedValues = 'URL of Report Server'
		   ,[Description]= 'Report URL'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Report URL in SystemConfigurations Table' 
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='ReportURL';
   END
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ReportFolderName') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'ReportFolderName' 
				,ReportFolderName
				,'Folder Name of Reports'
				,'Report Folder Name' 
				,'N' 
				,'Report Folder Name in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ReportFolderName FROM SystemConfigurations)
		   ,AcceptedValues = 'Folder Name of Reports'
		   ,[Description]= 'Report Folder Name'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Report Folder Name in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='ReportFolderName';
   END
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ReportServerDomain') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'ReportServerDomain' 
				,ReportServerDomain 
				,'Domain Name of Report Servers'
				,'Report Server Domain' 
				,'N' 
				,'Report Server Domain in SystemConfigurations Table' 
				,'SystemConfigurations'
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ReportServerDomain FROM SystemConfigurations)
		   ,AcceptedValues = 'Domain Name of Report Servers'
		   ,[Description]= 'Report Server Domain'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Report Server Domain in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='ReportServerDomain';
   END
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ReportServerUserName') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'ReportServerUserName' 
				,ReportServerUserName 
				,'User Name of Report Servers'
				,'Report Server User Name' 
				,'N' 
				,'Report Server User Name in SystemConfigurations Table' 
				,'SystemConfigurations'
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ReportServerUserName FROM SystemConfigurations)
		   ,AcceptedValues = 'User Name of Report Servers'
		   ,[Description]= 'Report Server User Name'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Report Server User Name in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='ReportServerUserName';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ReportServerPassword') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'ReportServerPassword' 
				,ReportServerPassword
				,'Password of Report Server'
				,'Report Server Password' 
				,'N' 
				,'Report Server Password in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ReportServerPassword FROM SystemConfigurations)
		   ,AcceptedValues = 'Password of Report Server'
		   ,[Description]='Report Server Password'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Report Server Password in SystemConfigurations Table' 
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='ReportServerPassword';
   END
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ReportServerConnection') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'ReportServerConnection' 
				,ReportServerConnection
				,'Connection of Report Server'
				,'Report Server Connection' 
				,'N' 
				,'Report Server Connection in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ReportServerConnection FROM SystemConfigurations)
		   ,AcceptedValues = 'Connection of Report Server'
		   ,[Description]= 'Report Server Connection'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Report Server Connection in SystemConfigurations Table'   
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='ReportServerConnection';
   END
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT * FROM systemconfigurationkeys WHERE [Key] = 'ShowTPGoalsOnServiceTab') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'ShowTPGoalsOnServiceTab' 
				,ShowTPGoalsOnServiceTab
				,'Y,N'
				,'Show TP Goals On Service Tab' 
				,'N' 
				,'Show TP Goals On Service Tab in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ShowTPGoalsOnServiceTab FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Show TP Goals On Service Tab'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Show TP Goals On Service Tab in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='ShowTPGoalsOnServiceTab';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ServiceOutTimeNotRequiredOnSave') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'ServiceOutTimeNotRequiredOnSave' 
				,ServiceOutTimeNotRequiredOnSave 
				,'Y,N'
				,'Service Out Time Not Required On Save' 
				,'N' 
				,'Service Out Time Not Required On Save in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ServiceOutTimeNotRequiredOnSave FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Service Out Time Not Required On Save' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Service Out Time Not Required On Save in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='ServiceOutTimeNotRequiredOnSave';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ReleaseReminderDays') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'ReleaseReminderDays' 
				,ReleaseReminderDays 
				,'Numeric Value'
				,'Release Reminder Days' 
				,'N' 
				,'Release Reminder Days in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ReleaseReminderDays FROM SystemConfigurations)
		   ,AcceptedValues = 'Numeric Value'
		   ,[Description]= 'Release Reminder Days'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Release Reminder Days in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='ReleaseReminderDays';
   END
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ServiceNoteDoNotDefaultDate') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'ServiceNoteDoNotDefaultDate' 
				,ServiceNoteDoNotDefaultDate 
				,'Y,N'
				,'Service Note Do Not Default Date' 
				,'N' 
				,'Service Note Do Not Default Date in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ServiceNoteDoNotDefaultDate FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Service Note Do Not Default Date' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Service Note Do Not Default Date in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='ServiceNoteDoNotDefaultDate';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'AdjudicateSpendDown') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'AdjudicateSpendDown' 
				,AdjudicateSpendDown 
				,'Y,N'
				,'Adjudicate Spend Down' 
				,'N' 
				,'Adjudicate Spend Down in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select AdjudicateSpendDown FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Adjudicate Spend Down'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Adjudicate Spend Down in SystemConfigurations Table' 
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='AdjudicateSpendDown';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ClaimPopulationDropdown') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'ClaimPopulationDropdown' 
				,ClaimPopulationDropdown 
				,'Y,N'
				,'Claim Population Dropdown' 
				,'N' 
				,'Claim Population Dropdown in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ClaimPopulationDropdown FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Claim Population Dropdown'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Claim Population Dropdown in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='ClaimPopulationDropdown';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'AppointmentSearchResultDays') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'AppointmentSearchResultDays' 
				,AppointmentSearchResultDays 
				,'Numeric Value'
				,'Appointment Search Result Days' 
				,'N' 
				,'Appointment Search Result Days in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select AppointmentSearchResultDays FROM SystemConfigurations)
		   ,AcceptedValues = 'Numeric Value'
		   ,[Description]= 'Appointment Search Result Days'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Appointment Search Result Days in SystemConfigurations Table'   
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='AppointmentSearchResultDays';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'AlwaysCreateClientChargeOnServiceCompletion') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'AlwaysCreateClientChargeOnServiceCompletion' 
				,AlwaysCreateClientChargeOnServiceCompletion 
				,'Y,N'
				,'Always Create Client Charge On Service Completion' 
				,'N' 
				,'Always Create Client Charge On Service Completion in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select AlwaysCreateClientChargeOnServiceCompletion FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Always Create Client Charge On Service Completion'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Always Create Client Charge On Service Completion in SystemConfigurations Table' 
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='AlwaysCreateClientChargeOnServiceCompletion';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = '835PaymentSourceTableNameId') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  '835PaymentSourceTableNameId' 
				,835PaymentSourceTableNameId 
				,'Payment SourceTableName Id'
				,'835 Payment SourceTableName Id' 
				,'N' 
				,'835 Payment SourceTableName Id in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select 835PaymentSourceTableNameId FROM SystemConfigurations)
		   ,AcceptedValues = 'Payment SourceTableName Id'
		   ,[Description]= '835 Payment SourceTableName Id' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= '835 Payment SourceTableName Id in SystemConfigurations Table' 
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='835PaymentSourceTableNameId';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = '835PaymentLocationId') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  '835PaymentLocationId' 
				,835PaymentLocationId 
				,'Location Id'
				,'835 Payment Location Id' 
				,'N' 
				,'835 Payment Location Id in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select 835PaymentLocationId FROM SystemConfigurations)
		   ,AcceptedValues = 'Location Id'
		   ,[Description]= '835 Payment Location Id'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= '835 Payment Location Id in SystemConfigurations Table' 
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='835PaymentLocationId';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ChargeAccountingPeriodByDateOfService') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'ChargeAccountingPeriodByDateOfService' 
				,ChargeAccountingPeriodByDateOfService 
				,'Y,N'
				,'Charge Accounting Period By Date Of Service' 
				,'N' 
				,'Charge Accounting Period By Date Of Service in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ChargeAccountingPeriodByDateOfService FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Charge Accounting Period By Date Of Service'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Charge Accounting Period By Date Of Service in SystemConfigurations Table' 
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='ChargeAccountingPeriodByDateOfService';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'AuthorizationDetailsReportFolderId') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'AuthorizationDetailsReportFolderId' 
				,AuthorizationDetailsReportFolderId 
				,'Folder Id'
				,'Authorization Details Report Folder Id' 
				,'N' 
				,'Authorization Details Report Folder Id in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select AuthorizationDetailsReportFolderId FROM SystemConfigurations)
		   ,AcceptedValues = 'Folder Id'
		   ,[Description]= 'Authorization Details Report Folder Id'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Authorization Details Report Folder Id in SystemConfigurations Table' 
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='AuthorizationDetailsReportFolderId';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'DefaultAppointmentDurationWhenNotSpecified') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'DefaultAppointmentDurationWhenNotSpecified' 
				,DefaultAppointmentDurationWhenNotSpecified 
				,'Numeric Value'
				,'Default Appointment Duration When Not Specified' 
				,'N' 
				,'Default Appointment Duration When Not Specified in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select DefaultAppointmentDurationWhenNotSpecified FROM SystemConfigurations)
		   ,AcceptedValues = 'Numeric Value'
		   ,[Description]= 'Default Appointment Duration When Not Specified'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Default Appointment Duration When Not Specified in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='DefaultAppointmentDurationWhenNotSpecified';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'HelpURL') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'HelpURL' 
				,HelpURL
				,'URL'
				,'Help URL' 
				,'N' 
				,'Help URL in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select HelpURL FROM SystemConfigurations)
		   ,AcceptedValues = 'URL'
		   ,[Description]= 'Help URL'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Help URL in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='HelpURL';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'FlowSheetSpecificToClient') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'FlowSheetSpecificToClient' 
				,FlowSheetSpecificToClient 
				,'Y,N'
				,'Flow Sheet Specific To Client' 
				,'N' 
				,'Flow Sheet Specific To Client in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select FlowSheetSpecificToClient FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Flow Sheet Specific To Client' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Flow Sheet Specific To Client in SystemConfigurations Table' 
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='FlowSheetSpecificToClient';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'UseSignaturePad') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'UseSignaturePad' 
				,UseSignaturePad 
				,'Y,N'
				,'Use Signature Pad' 
				,'N' 
				,'Use Signature Pad in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select UseSignaturePad FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Use Signature Pad' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Use Signature Pad in SystemConfigurations Table'   
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='UseSignaturePad';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ScannedDocumentDefaultAssociation') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'ScannedDocumentDefaultAssociation' 
				,ScannedDocumentDefaultAssociation 
				,'Global Code'
				,'Scanned Document Default Association' 
				,'N' 
				,'Scanned Document Default Association in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ScannedDocumentDefaultAssociation FROM SystemConfigurations)
		   ,AcceptedValues = 'Global Code'
		   ,[Description]= 'Scanned Document Default Association'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Scanned Document Default Association in SystemConfigurations Table' 
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='ScannedDocumentDefaultAssociation';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'AllowedResourceCount') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'AllowedResourceCount' 
				,AllowedResourceCount 
				,'Numeric Value'
				,'Allowed ReSource Count' 
				,'N' 
				,'Allowed ReSource Count in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select AllowedResourceCount FROM SystemConfigurations)
		   ,AcceptedValues = 'Numeric Value'
		   ,[Description]= 'Allowed ReSource Count' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Allowed ReSource Count in SystemConfigurations Table' 
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='AllowedResourceCount';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'UseResourceForService') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'UseResourceForService' 
				,UseResourceForService 
				,'Y,N'
				,'Use ReSource For Service' 
				,'N' 
				,'Use ReSource For Service in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select UseResourceForService FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Use ReSource For Service'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Use ReSource For Service in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='UseResourceForService';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ServiceInTimeNotRequiredOnSave') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT  'ServiceInTimeNotRequiredOnSave' 
				,ServiceInTimeNotRequiredOnSave 
				,'Y,N'
				,'Service In Time Not Required On Save' 
				,'N' 
				,'Service In Time Not Required On Save in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations 
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select ServiceInTimeNotRequiredOnSave FROM SystemConfigurations)
		   ,AcceptedValues = 'Y,N'
		   ,[Description]= 'Service In Time Not Required On Save'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Service In Time Not Required On Save in SystemConfigurations Table'  
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='ServiceInTimeNotRequiredOnSave';
   END	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'DeductiblesNeverMetMonthsFromToday') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,Value
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Comments
				,SourceTableName) 
		SELECT	'DeductiblesNeverMetMonthsFromToday' 
				,DeductiblesNeverMetMonthsFromToday 
				,'Numeric Value'
				,'Deductibles Never Met Months From Today' 
				,'N' 
				,'Deductibles Never Met Months From Today in SystemConfigurations Table' 
				,'SystemConfigurations' 
				from SystemConfigurations
	 END
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET Value = (Select DeductiblesNeverMetMonthsFromToday FROM SystemConfigurations)
		   ,AcceptedValues = 'Numeric Value'
		   ,[Description]= 'Deductibles Never Met Months From Today'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Comments= 'Deductibles Never Met Months From Today in SystemConfigurations Table' 
		   ,SourceTableName= 'SystemConfigurations'
			WHERE [Key]='DeductiblesNeverMetMonthsFromToday';
   END	
/********************************* systemconfigurationkeys table *****************************************/
