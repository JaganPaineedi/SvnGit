
IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'MAR_ShowAdministeredName') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('MAR_ShowAdministeredName' 
				,NULL
				,NULL
				,'N' 
				,'MAR'
				,'908'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'MAR'
		   ,Screens= '908'
		   ,Comments= NULL  
		   ,SourceTableName= 'Systemconfigurations'
			WHERE [Key]='OrganizationName';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'INITIALIZEDIAGNOSISORDER') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('INITIALIZEDIAGNOSISORDER' 
				,'Y,N,B'
				,NULL
				,'N' 
				,'Service Note, Service Detail, Group Service Detail'
				,'29,207,210,46'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N,B'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Service Note, Service Detail, Group Service Detail'
		   ,Screens= '29,207,210,46'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='INITIALIZEDIAGNOSISORDER';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowDocumentVersionComments') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowDocumentVersionComments' 
				,'Y,N'
				,NULL
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowDocumentVersionComments';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'IsDocumentVersionCommentMandatory') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('IsDocumentVersionCommentMandatory' 
				,'Y,N'
				,NULL
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='IsDocumentVersionCommentMandatory';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'DiagnosisPageSize') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('DiagnosisPageSize' 
				,NULL
				,NULL
				,'N' 
				,'ICD10Diagnosis'
				,'979'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'ICD10Diagnosis'
		   ,Screens= '979'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='DiagnosisPageSize';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'BEDPROGRAMENROLLMENT') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('BEDPROGRAMENROLLMENT' 
				,'Do not require program enrollment, Require program enrollment, Enroll client automatically'
				,NULL
				,'N' 
				,'BedBoard/Census Management, BedBoard/Bed Activity Details'
				,'910,911'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Do not require program enrollment, Require program enrollment, Enroll client automatically'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'BedBoard/Census Management, BedBoard/Bed Activity Details'
		   ,Screens= '910,911'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='BEDPROGRAMENROLLMENT';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'BEDBOARDADMISSIONORDERREQUIRED') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('BEDBOARDADMISSIONORDERREQUIRED' 
				,'yes,no'
				,'Bedboard Admission can be done for the Client either with the Admission Order by physician or directly without admission order. This key will enable control of admission with or without the Admission Order.        IMPACT: The user can admit client with or without admission order based on the value of this key.        VALUE: There are 2 Values which will enable or disable this feature. yes – This value enforces the user to admit only if the client is having the admission order. If the admission order is not available for this client, the application displays an alert - “Admission Order not found for selected client. Please create Admission Order”. no – This value enables the user to admit patient with or without admission order.  Note: The entry in ‘Value’ column is case-sensitive.'
				,'N' 
				,'BedBoard/Census Management, BedBoard/Bed Activity Details'
				,'910,911'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'yes,no'
		   ,[Description]= 'Bedboard Admission can be done for the Client either with the Admission Order by physician or directly without admission order. This key will enable control of admission with or without the Admission Order.        IMPACT: The user can admit client with or without admission order based on the value of this key.        VALUE: There are 2 Values which will enable or disable this feature. yes – This value enforces the user to admit only if the client is having the admission order. If the admission order is not available for this client, the application displays an alert - “Admission Order not found for selected client. Please create Admission Order”. no – This value enables the user to admit patient with or without admission order.  Note: The entry in ‘Value’ column is case-sensitive.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'BedBoard/Census Management, BedBoard/Bed Activity Details'
		   ,Screens= '910,911'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='BEDBOARDADMISSIONORDERREQUIRED';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'BEDBOARDDISCHARGEORDERREQUIRED') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('BEDBOARDDISCHARGEORDERREQUIRED' 
				,'yes,no'
				,'Bedboard Discharge can be done for the Client either with the Discharge Order by physician or directly without discharge order. This key will enable control of discharge with or without the Discharge Order.        IMPACT: The user can admit client with or without Discharge order based on the value of this key.        VALUE: There are 2 values which will enable or disable this feature. yes – This value enforces the user to admit only if the client is having the Discharge order. If the Discharge order is not available for this client, the application displays an alert - “Discharge Order not found for selected client. Please create Discharge Order”. no – This value enables the user to discharge patient with or without discharge order.  Note: The entry in ‘Value’ column is case-sensitive.'
				,'N' 
				,'BedBoard/Census Management, BedBoard/Bed Activity Details'
				,'910,911'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'yes,no'
		   ,[Description]= 'Bedboard Discharge can be done for the Client either with the Discharge Order by physician or directly without discharge order. This key will enable control of discharge with or without the Discharge Order.        IMPACT: The user can admit client with or without Discharge order based on the value of this key.        VALUE: There are 2 values which will enable or disable this feature. yes – This value enforces the user to admit only if the client is having the Discharge order. If the Discharge order is not available for this client, the application displays an alert - “Discharge Order not found for selected client. Please create Discharge Order”. no – This value enables the user to discharge patient with or without discharge order.  Note: The entry in ‘Value’ column is case-sensitive.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'BedBoard/Census Management, BedBoard/Bed Activity Details'
		   ,Screens= '910,911'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='BEDBOARDDISCHARGEORDERREQUIRED';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'BEDCENSUSADMISSIONORDERREQUIRED') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('BEDCENSUSADMISSIONORDERREQUIRED' 
				,'yes,no'
				,'Bed Census Admission can be done for the Client either with the Admission Order by physician or directly without admission order. This key will enable control of admission with or without the Admission Order.        IMPACT: The user can admit client with or without admission order based on the value of this key.        VALUE: There are 2 Values which will enable or disable this feature. yes – This value enforces the user to admit only if the client is having the admission order. If the admission order is not available for this client, the application displays an alert - “Admission Order not found for selected client. Please create Admission Order”. no – This value enables the user to admit patient with or without admission order.  Note: The entry in ‘Value’ column is case-sensitive.'
				,'N' 
				,'BedBoard/Census Management, BedBoard/Bed Activity Details'
				,'910,911'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'yes,no'
		   ,[Description]= 'Bed Census Admission can be done for the Client either with the Admission Order by physician or directly without admission order. This key will enable control of admission with or without the Admission Order.        IMPACT: The user can admit client with or without admission order based on the value of this key.        VALUE: There are 2 Values which will enable or disable this feature. yes – This value enforces the user to admit only if the client is having the admission order. If the admission order is not available for this client, the application displays an alert - “Admission Order not found for selected client. Please create Admission Order”. no – This value enables the user to admit patient with or without admission order.  Note: The entry in ‘Value’ column is case-sensitive.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'BedBoard/Census Management, BedBoard/Bed Activity Details'
		   ,Screens= '910,911'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='BEDCENSUSADMISSIONORDERREQUIRED';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'BEDCENSUSDISCHARGEORDERREQUIRED') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('BEDCENSUSDISCHARGEORDERREQUIRED' 
				,'yes,no'
				,'Bed Census Discharge can be done for the Client either with the Discharge Order by physician or directly without discharge order. This key will enable control of discharge with or without the Discharge Order.        IMPACT: The user can admit client with or without Discharge order based on the value of this key.        VALUE: There are 2 values which will enable or disable this feature. yes – This value enforces the user to admit only if the client is having the Discharge order. If the Discharge order is not available for this client, the application displays an alert - “Discharge Order not found for selected client. Please create Discharge Order”. no – This value enables the user to discharge patient with or without discharge order.  Note: The entry in ‘Value’ column is case-sensitive.'
				,'N' 
				,'BedBoard/Census Management, BedBoard/Bed Activity Details'
				,'910,911'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'yes,no'
		   ,[Description]= 'Bed Census Discharge can be done for the Client either with the Discharge Order by physician or directly without discharge order. This key will enable control of discharge with or without the Discharge Order.        IMPACT: The user can admit client with or without Discharge order based on the value of this key.        VALUE: There are 2 values which will enable or disable this feature. yes – This value enforces the user to admit only if the client is having the Discharge order. If the Discharge order is not available for this client, the application displays an alert - “Discharge Order not found for selected client. Please create Discharge Order”. no – This value enables the user to discharge patient with or without discharge order.  Note: The entry in ‘Value’ column is case-sensitive.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'BedBoard/Census Management, BedBoard/Bed Activity Details'
		   ,Screens= '910,911'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='BEDCENSUSDISCHARGEORDERREQUIRED';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ClaimLineWebServiceURL') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ClaimLineWebServiceURL' 
				,'Web Services Folder Path'
				,NULL
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Web Services Folder Path'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'MAR'
		   ,Screens= '908'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ClaimLineWebServiceURL';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'DISPLAYPROVIDERAPPLICATIONDROPDOWN') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('DISPLAYPROVIDERAPPLICATIONDROPDOWN' 
				,'True,False'
				,NULL
				,'N' 
				,'Provider dropdown in Application'
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'True,False'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Provider dropdown in Application'
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='DISPLAYPROVIDERAPPLICATIONDROPDOWN';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'DisplayInsurerDropdown') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('DisplayInsurerDropdown' 
				,'Y,N'
				,NULL
				,'N' 
				,'Insurer dropdown in CM Widgets'
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Insurer dropdown in CM Widgets'
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='DisplayInsurerDropdown';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'EnableCMClientInfoTab') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('EnableCMClientInfoTab' 
				,'True,False'
				,NULL
				,'N' 
				,'Client Information(Admin)'
				,'969'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'True,False'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Client Information(Admin)'
		   ,Screens= '969'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='EnableCMClientInfoTab';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'EnablePlanCMTab') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('EnablePlanCMTab' 
				,'True,False'
				,NULL
				,'N' 
				,'Plan Details'
				,'309'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'True,False'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Plan Details'
		   ,Screens= '309'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='EnablePlanCMTab';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'StaffProviderInsurerFilter') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('StaffProviderInsurerFilter' 
				,'Y,N'
				,NULL
				,'N' 
				,'Staff List Page'
				,'84'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Staff List Page'
		   ,Screens= '84'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='StaffProviderInsurerFilter';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'DISPLAYCAREMANAGEMENTTAB') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('DISPLAYCAREMANAGEMENTTAB' 
				,'True,False'
				,NULL
				,'N' 
				,'Staff Details'
				,'329'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'True,False'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Staff Details'
		   ,Screens= '329'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='DISPLAYCAREMANAGEMENTTAB';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'EnableSADemographicTab') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('EnableSADemographicTab' 
				,'True,False'
				,NULL
				,'N' 
				,'Client Information'
				,'370'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'True,False'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Client Information'
		   ,Screens= '370'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='EnableSADemographicTab';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'DisplayProviderDropDown') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('DisplayProviderDropDown' 
				,'Y,N'
				,NULL
				,'N' 
				,'Client Search pop up'
				,'27'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Client Search pop up'
		   ,Screens= '27'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='DisplayProviderDropDown';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'DefaultClinicianFromClaimToServiceCreation') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('DefaultClinicianFromClaimToServiceCreation' 
				,NULL
				,NULL
				,'N' 
				,'Service From Claims'
				,'1116'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Service From Claims'
		   ,Screens= '1116'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='DefaultClinicianFromClaimToServiceCreation';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'CoreDataModelVersion4.0') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('CoreDataModelVersion4.0' 
				,NULL
				,NULL
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='CoreDataModelVersion4.0';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'EnableAmendmentRequestEnableIcon') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('EnableAmendmentRequestEnableIcon' 
				,'Y,N'
				,NULL
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='EnableAmendmentRequestEnableIcon';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowClinicalInstruction') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowClinicalInstruction' 
				,'Y,N'
				,NULL
				,'N' 
				,'ClinicalSummary'
				,'939'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'ClinicalSummary'
		   ,Screens= '939'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowClinicalInstruction';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowClinicalSummaryFutureOrders') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowClinicalSummaryFutureOrders' 
				,'Y,N'
				,NULL
				,'N' 
				,'ClinicalSummary'
				,'939'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'ClinicalSummary'
		   ,Screens= '939'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowClinicalSummaryFutureOrders';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'CDM_MeaningfulUse') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('CDM_MeaningfulUse' 
				,NULL
				,NULL
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='CDM_MeaningfulUse';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'CSUpComingAppointmentRangeInMonths') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('CSUpComingAppointmentRangeInMonths' 
				,NULL
				,NULL
				,'N' 
				,'Appointment Search'
				,'362'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Appointment Search'
		   ,Screens= '362'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='CSUpComingAppointmentRangeInMonths';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'MovedToICD10') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('MovedToICD10' 
				,NULL
				,NULL
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= Null
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='MovedToICD10';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowClientInformationToolTip') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowClientInformationToolTip' 
				,'Y,N'
				,NULL
				,'N' 
				,'Client Tab'
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Client Tab'
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowClientInformationToolTip';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowResidentialUnitBedInToolTip') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowResidentialUnitBedInToolTip' 
				,'Y,N'
				,NULL
				,'N' 
				,'Client Tab'
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Client Tab'
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowResidentialUnitBedInToolTip';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowSSNInToolTip') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowSSNInToolTip' 
				,'Y,N'
				,NULL
				,'N' 
				,'Client Tab'
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Client Tab'
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowSSNInToolTip';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowMedicaidIDInToolTip') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowMedicaidIDInToolTip' 
				,'Y,N'
				,NULL
				,'N' 
				,'Client Tab'
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Client Tab'
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowMedicaidIDInToolTip';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'BILLINGDIAGNOSISDEFAULTBUTTON') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('BILLINGDIAGNOSISDEFAULTBUTTON' 
				,'ICD10,NULL'
				,NULL
				,'N' 
				,'Service Note, Service Detail'
				,'29,207,210'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'ICD10,NULL'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Service Note, Service Detail'
		   ,Screens= '29,207,210'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='BILLINGDIAGNOSISDEFAULTBUTTON';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'AddWaterMarkInDisclosure') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('AddWaterMarkInDisclosure' 
				,'Y,N'
				,NULL
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='AddWaterMarkInDisclosure';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'DisclosureWaterMarkText') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('DisclosureWaterMarkText' 
				,NULL
				,NULL
				,'N' 
				,'Disclosure/Request Details'
				,'26'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Disclosure/Request Details'
		   ,Screens= '26'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='DisclosureWaterMarkText';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowClientAddressInToolTip') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowClientAddressInToolTip' 
				,'Y,N'
				,NULL
				,'N' 
				,'Client Tab'
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Client Tab'
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowClientAddressInToolTip';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowPhoneNumberInToolTip') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowPhoneNumberInToolTip' 
				,'Y,N'
				,NULL
				,'N' 
				,'Client Tab'
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Client Tab'
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowPhoneNumberInToolTip';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowDOBInToolTip') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowDOBInToolTip' 
				,'Y,N'
				,NULL
				,'N' 
				,'Client Tab'
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Client Tab'
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowDOBInToolTip';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowSexInToolTip') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowSexInToolTip' 
				,'Y,N'
				,NULL
				,'N' 
				,'Client Tab'
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Client Tab'
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowSexInToolTip';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowClientPlansInToolTip') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowClientPlansInToolTip' 
				,'Y,N'
				,NULL
				,'N' 
				,'Client Tab'
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Client Tab'
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowClientPlansInToolTip';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowPrimaryClinicianNameInToolTip') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowPrimaryClinicianNameInToolTip' 
				,'Y,N'
				,NULL
				,'N' 
				,'Client Tab'
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Client Tab'
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowPrimaryClinicianNameInToolTip';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowPrimaryProgramInToolTip') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowPrimaryProgramInToolTip' 
				,'Y,N'
				,NULL
				,'N' 
				,'Client Tab'
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Client Tab'
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowPrimaryProgramInToolTip';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowMedicationInToolTip') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowMedicationInToolTip' 
				,'Y,N'
				,NULL
				,'N' 
				,'Client Tab'
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Client Tab'
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowMedicationInToolTip';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'MARDefaultAdministrationWindow') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('MARDefaultAdministrationWindow' 
				,NULL
				,NULL
				,'N' 
				,'MAR'
				,'908'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'MAR'
		   ,Screens= '908'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='MARDefaultAdministrationWindow';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ValidateFromWebService') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ValidateFromWebService' 
				,'Y,N'
				,NULL
				,'N' 
				,'Login Page, Rx - Login Screen'
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Login Page, Rx - Login Screen'
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ValidateFromWebService';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'AuthWebServiceURL') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('AuthWebServiceURL' 
				,NULL
				,NULL
				,'N' 
				,'Login Page, Rx - Login Screen'
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Login Page, Rx - Login Screen'
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='AuthWebServiceURL';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'WebServiceKeyToken') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('WebServiceKeyToken' 
				,NULL
				,NULL
				,'N' 
				,'Login Page, Rx - Login Screen'
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Login Page, Rx - Login Screen'
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='WebServiceKeyToken';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'BillingDiagnosisStartDate') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('BillingDiagnosisStartDate' 
				,NULL
				,NULL
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='BillingDiagnosisStartDate';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'CollectionsBalanceAmount') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('CollectionsBalanceAmount' 
				,NULL
				,NULL
				,'N' 
				,'Collections'
				,'1153'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Collections'
		   ,Screens= '1153'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='CollectionsBalanceAmount';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'Collections#OfDaysOld') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('Collections#OfDaysOld' 
				,NULL
				,NULL
				,'N' 
				,'Collections'
				,'1153'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Collections'
		   ,Screens= '1153'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='Collections#OfDaysOld';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'Payment#OfDaysOld') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('Payment#OfDaysOld' 
				,NULL
				,NULL
				,'N' 
				,'Collections'
				,'1155'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Collections'
		   ,Screens= '1155'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='Payment#OfDaysOld';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'LetterSaveAndClose') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('LetterSaveAndClose' 
				,'Y,false,true,0,1'
				,NULL
				,'N' 
				,'Letter'
				,'1156'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,false,true,0,1'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Letter'
		   ,Screens= '1156'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='LetterSaveAndClose';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'InitializeAxisIVToFactorsLookupInDSM5') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('InitializeAxisIVToFactorsLookupInDSM5' 
				,'Y,N'
				,NULL
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='InitializeAxisIVToFactorsLookupInDSM5';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ATTENDINGREFERRING') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ATTENDINGREFERRING' 
				,'Y,N'
				,NULL
				,'N' 
				,'Service Note'
				,'29'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Service Note'
		   ,Screens= '29'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ATTENDINGREFERRING';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowCMAuthorizationReasonforchange') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowCMAuthorizationReasonforchange' 
				,'Y,N'
				,NULL
				,'N' 
				,'CareManagement'
				,'1043'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'CareManagement'
		   ,Screens= '1043'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowCMAuthorizationReasonforchange';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowClientDateOfEnrollment') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowClientDateOfEnrollment' 
				,'Y,N'
				,NULL
				,'N' 
				,'Client Tab'
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Client Tab'
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowClientDateOfEnrollment';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowPrimaryPharmacy') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowPrimaryPharmacy' 
				,'Y,N'
				,NULL
				,'N' 
				,'Client Tab'
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Client Tab'
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowPrimaryPharmacy';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'INCLUDEBILLINGDIAGNOSISRULEOUT') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('INCLUDEBILLINGDIAGNOSISRULEOUT' 
				,'Y,N'
				,NULL
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='INCLUDEBILLINGDIAGNOSISRULEOUT';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'DISABLEBILLINGDXIFSERVICENOTEISDX') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('DISABLEBILLINGDXIFSERVICENOTEISDX' 
				,'Y,N'
				,NULL
				,'N' 
				,'Service Note'
				,'29'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Service Note'
		   ,Screens= '29'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='DISABLEBILLINGDXIFSERVICENOTEISDX';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'AutoExpandMultilineTextBox') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('AutoExpandMultilineTextBox' 
				,'Y,N'
				,NULL
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='AutoExpandMultilineTextBox';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'REQUIREPROVIDERINFORMATIONSTARTDATE') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('REQUIREPROVIDERINFORMATIONSTARTDATE' 
				,'Y,N'
				,NULL
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='REQUIREPROVIDERINFORMATIONSTARTDATE';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'DEFAULTORDERTEMPLATEFREQUENCYID') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('DEFAULTORDERTEMPLATEFREQUENCYID' 
				,NULL
				,NULL
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='DEFAULTORDERTEMPLATEFREQUENCYID';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'DEFAULTORDERPRIORITYID') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('DEFAULTORDERPRIORITYID' 
				,NULL
				,NULL
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='DEFAULTORDERPRIORITYID';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'DEFAULTORDERSCHEDULEID') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('DEFAULTORDERSCHEDULEID' 
				,NULL
				,NULL
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='DEFAULTORDERSCHEDULEID';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'LABSOFTORGANIZATIONID') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('LABSOFTORGANIZATIONID' 
				,'LabSoftOrganizations.LabSoftOrganizationId'
				,NULL
				,'N' 
				,'ClientOrders'
				,'772'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'LabSoftOrganizations.LabSoftOrganizationId'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'ClientOrders'
		   ,Screens= '772'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='LABSOFTORGANIZATIONID';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'LABSOFTWEBSERVICEURL') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('LABSOFTWEBSERVICEURL' 
				,'Hosted LabSoftWebService Url'
				,NULL
				,'N' 
				,'ClientOrders'
				,'772'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Hosted LabSoftWebService Url'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'ClientOrders'
		   ,Screens= '772'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='LABSOFTWEBSERVICEURL';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'LABSOFTENABLED') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('LABSOFTENABLED' 
				,'Y,N'
				,NULL
				,'N' 
				,'ClientOrders'
				,'772'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'ClientOrders'
		   ,Screens= '772'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='LABSOFTENABLED';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowNPIProviderValidation') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowNPIProviderValidation' 
				,'Y,N'
				,NULL
				,'N' 
				,'CareManagement'
				,'950'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'CareManagement'
		   ,Screens= '950'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowNPIProviderValidation';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'CLEARMEDICAID') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('CLEARMEDICAID' 
				,'Y,N'
				,NULL
				,'N' 
				,'Insurance Eligibility Verification'
				,'381'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Insurance Eligibility Verification'
		   ,Screens= '381'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='CLEARMEDICAID';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'RETAINUNSAVEDCHANGESFORXHOURS') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('RETAINUNSAVEDCHANGESFORXHOURS' 
				,NULL
				,NULL
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='RETAINUNSAVEDCHANGESFORXHOURS';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'WB_RefreshRate') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('WB_RefreshRate' 
				,NULL
				,NULL
				,'N' 
				,'Whiteboard'
				,'907'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Whiteboard'
		   ,Screens= '907'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='WB_RefreshRate';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'BedBoardAutoRefreshInterval') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('BedBoardAutoRefreshInterval' 
				,NULL
				,NULL
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='BedBoardAutoRefreshInterval';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'DisplayInstantMessageAsAlert') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('DisplayInstantMessageAsAlert' 
				,NULL
				,NULL
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='DisplayInstantMessageAsAlert';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowMoveGroupMessage') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowMoveGroupMessage' 
				,'Y,N'
				,NULL
				,'N' 
				,'TeamScheduling'
				,'758'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'TeamScheduling'
		   ,Screens= '758'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowMoveGroupMessage';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'Autosecondarycopayment') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('Autosecondarycopayment' 
				,'Y,N'
				,NULL
				,'N' 
				,'Payment Adjustment'
				,'323'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Payment Adjustment'
		   ,Screens= '323'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='Autosecondarycopayment';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'EnablePaymentActivityType') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('EnablePaymentActivityType' 
				,'Y,N'
				,NULL
				,'N' 
				,'Payment Adjustment'
				,'323'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Payment Adjustment'
		   ,Screens= '323'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='EnablePaymentActivityType';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'MARMinutesBeforeOverdue') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('MARMinutesBeforeOverdue' 
				,NULL
				,NULL
				,'N' 
				,'MAR'
				,'1133'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'MAR'
		   ,Screens= '1133'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='MARMinutesBeforeOverdue';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'REALLOCATIONEXCLUDEPAYMENTS') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('REALLOCATIONEXCLUDEPAYMENTS' 
				,NULL
				,NULL
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='REALLOCATIONEXCLUDEPAYMENTS';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'EnableClientEntrollValidation') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('EnableClientEntrollValidation' 
				,'true,false'
				,NULL
				,'N' 
				,'Bed Census, BedBoard'
				,'147,10206,910,912'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'true,false'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Bed Census, BedBoard'
		   ,Screens= '147,10206,910,912'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='EnableClientEntrollValidation';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'MARMinutes2XBeforeOverdue') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('MARMinutes2XBeforeOverdue' 
				,NULL
				,NULL
				,'N' 
				,'MAR'
				,'908'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'MAR'
		   ,Screens= '908'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='MARMinutes2XBeforeOverdue';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'MAR_RefreshRate') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('MAR_RefreshRate' 
				,NULL
				,NULL
				,'N' 
				,'MAR'
				,'908'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'MAR'
		   ,Screens= '908'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='MAR_RefreshRate';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'EnableCoSigner') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('EnableCoSigner' 
				,'True,False'
				,NULL
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'True,False'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='EnableCoSigner';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'AppointmentMessage') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('AppointmentMessage' 
				,'Dynamically generate the string from ssp'
				,NULL
				,'N' 
				,'Reception'
				,'324'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Dynamically generate the string from ssp'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Reception'
		   ,Screens= '324'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='AppointmentMessage';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ScreenIdToRedirectOnClientCreation') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ScreenIdToRedirectOnClientCreation' 
				,NULL
				,NULL
				,'N' 
				,'Client Search, Providers'
				,'27,1070'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Client Search, Providers'
		   ,Screens= '27,1070'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ScreenIdToRedirectOnClientCreation';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'SurveillanceSyndromeVendorId') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('SurveillanceSyndromeVendorId' 
				,NULL
				,NULL
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='SurveillanceSyndromeVendorId';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowClinicalSummarySections') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowClinicalSummarySections' 
				,NULL
				,NULL
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowClinicalSummarySections';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ProductNameAndVersion') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ProductNameAndVersion' 
				,'NULL," " (eg:-"SmartCare 4.0")'
				,NULL
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = '(eg:-"SmartCare 4.0")'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ProductNameAndVersion';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'PlaceOfService') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('PlaceOfService' 
				,'Y,N'
				,NULL
				,'N' 
				,'Group Service Detail'
				,'46'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Group Service Detail'
		   ,Screens= '46'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='PlaceOfService';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'LoginAttemptCount') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('LoginAttemptCount' 
				,NULL
				,NULL
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='LoginAttemptCount';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'NeverDisplayTimelyAppointmentPopupAtAll') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('NeverDisplayTimelyAppointmentPopupAtAll' 
				,'Y,N'
				,'Unable to Offer a Timely Appointment'
				,'N' 
				,'UnableToOfferTimelyAppointment/Appointment Search, Refusal Reason'
				,'362,382'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'Unable to Offer a Timely Appointment'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'UnableToOfferTimelyAppointment/Appointment Search, Refusal Reason'
		   ,Screens= '362,382'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='NeverDisplayTimelyAppointmentPopupAtAll';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'DisplayTimelyAppointmentPopupAllTheTime') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('DisplayTimelyAppointmentPopupAllTheTime' 
				,'Y,N'
				,'Unable to Offer a Timely Appointment'
				,'N' 
				,'UnableToOfferTimelyAppointment/Appointment Search, Refusal Reason'
				,'362,382'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'Unable to Offer a Timely Appointment'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'UnableToOfferTimelyAppointment/Appointment Search, Refusal Reason'
		   ,Screens= '362,382'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='DisplayTimelyAppointmentPopupAllTheTime';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'DoNotDisplayTheTimelyAppointmentPopupAfterFirstScheduledAppointment') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('DoNotDisplayTheTimelyAppointmentPopupAfterFirstScheduledAppointment' 
				,'Y,N'
				,'Unable to Offer a Timely Appointment'
				,'N' 
				,'UnableToOfferTimelyAppointment/Appointment Search, Refusal Reason'
				,'362,382'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'Unable to Offer a Timely Appointment'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'UnableToOfferTimelyAppointment/Appointment Search, Refusal Reason'
		   ,Screens= '362,382'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='DoNotDisplayTheTimelyAppointmentPopupAfterFirstScheduledAppointment';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'EMCodingDocumentCodes') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('EMCodingDocumentCodes' 
				,'Comma seperated document code ids'
				,NULL
				,'N' 
				,'EM code Documents '
				,'908'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Comma seperated document code ids'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'EM code Documents '
		   ,Screens= '908'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='EMCodingDocumentCodes';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'SHOWASAMSUMMARY') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('SHOWASAMSUMMARY' 
				,'Y,N'
				,'To display the ASAM Document summary tab on each screen.Y = show all summary fields , N = do not show summary field  - default N'
				,'N' 
				,'All Documents using core ASAM tabs'
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'To display the ASAM Document summary tab on each screen.Y = show all summary fields , N = do not show summary field  - default N'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'All Documents using core ASAM tabs'
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='SHOWASAMSUMMARY';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ScreenFilterDisabledListPages') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ScreenFilterDisabledListPages' 
				,'Comma separated Screen ids'
				,'Screen Ids of list pages(Saparated by '','') for which we do not want to insert Filters'
				,'N' 
				,'Claims Processing'
				,'368'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Comma separated Screen ids'
		   ,[Description]= 'Screen Ids of list pages(Saparated by ",") for which we do not want to insert Filters'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Claims Processing'
		   ,Screens= '368'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ScreenFilterDisabledListPages';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowSignatureDeclinePopup') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowSignatureDeclinePopup' 
				,'Y,N'
				,'This key configuration is used to show or no-show Decline Signature Popup.              Value: Y OR N . If this value is Y, the GlobalCodeCategory DOCSIGNDECLINEREASON must have values in globalcodes table.'
				,'N' 
				,'Documents'
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'N'
		   ,[Description]= 'This key configuration is used to show or no-show Decline Signature Popup.              Value: Y OR N . If this value is Y, the GlobalCodeCategory DOCSIGNDECLINEREASON must have values in globalcodes table.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Documents'
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowSignatureDeclinePopup';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'PaymentAdjustmentPostingRequireLocation') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('PaymentAdjustmentPostingRequireLocation' 
				,'Y,N'
				,'This key is used to customize location selection requirement validation on payment adjustment popup screen.'
				,'N' 
				,'Payment Adjustment pop up'
				,'323'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'This key is used to customize location selection requirement validation on payment adjustment popup screen.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Payment Adjustment pop up'
		   ,Screens= '323'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='PaymentAdjustmentPostingRequireLocation';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowInterventionDate') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowInterventionDate' 
				,'Y,N'
				,NULL
				,'N' 
				,'Authorization Detail Page-Intervention Date'
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Authorization Detail Page-Intervention Date'
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowInterventionDate';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowAuthorizationCodes') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowAuthorizationCodes' 
				,'Y,N'
				,NULL
				,'N' 
				,'Authorization Defaults List Page'
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= NULL
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Authorization Defaults List Page'
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowAuthorizationCodes';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ProductivityCalculationSP') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ProductivityCalculationSP' 
				,'ssp_SCCalculateOpenPeriodProductivityMetrics'
				,'This value of this key is the name of the Stored Procedure used for productivity calculation. This Stored Procedure (SP) when called is responsible for calculation logic for data in the “Documented Service Total” widget in the dashboard. This widget displays a table containing staff, hours and lag details. Currently, the “ssp_SCCalculateOpenPeriodProductivityMetrics” is configured as default. If any customer needs different calculation and parameters, then new Stored Procedure is created and the name of the new SP will be updated as a value for this key. The primary input parameters for productivity calculation are configured in the following screens --- ‘Team Productivity’, ‘Productivity Targets’ and ‘Staff Targets’.        IMPACT: This value of this key (stored procedure name) is responsible for productivity calculation. The input for calculating productivity is obtained from these screens --- ‘Team Productivity’, ‘Productivity Targets’ and ‘Staff Targets’, which are dynamically passed to the SP, after which, the SP computes the productivity.         VALUE: “ssp_SCCalculateOpenPeriodProductivityMetrics” is the default SP used for calculation.For customers who would need different logic for calculation, a new SP can be created and the SP name is set as the value for this key [ProductivityCalculationSP].'
				,'N' 
				,'Widgets'
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'ssp_SCCalculateOpenPeriodProductivityMetrics'
		   ,[Description]= 'This value of this key is the name of the Stored Procedure used for productivity calculation. This Stored Procedure (SP) when called is responsible for calculation logic for data in the “Documented Service Total” widget in the dashboard. This widget displays a table containing staff, hours and lag details. Currently, the “ssp_SCCalculateOpenPeriodProductivityMetrics” is configured as default. If any customer needs different calculation and parameters, then new Stored Procedure is created and the name of the new SP will be updated as a value for this key. The primary input parameters for productivity calculation are configured in the following screens --- ‘Team Productivity’, ‘Productivity Targets’ and ‘Staff Targets’.        IMPACT: This value of this key (stored procedure name) is responsible for productivity calculation. The input for calculating productivity is obtained from these screens --- ‘Team Productivity’, ‘Productivity Targets’ and ‘Staff Targets’, which are dynamically passed to the SP, after which, the SP computes the productivity.         VALUE: “ssp_SCCalculateOpenPeriodProductivityMetrics” is the default SP used for calculation.For customers who would need different logic for calculation, a new SP can be created and the SP name is set as the value for this key [ProductivityCalculationSP].'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Widgets'
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ProductivityCalculationSP';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'SuperVisorServiceTotalsWidgetSP') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('SuperVisorServiceTotalsWidgetSP' 
				,'Y,N'
				,'This key enables display of widget named ‘Supervisor Document Service Totals’ on the dashboard. This widget gives the details of productivity of the Unit, Program and the Team as per the selection done in the widget dropdown box. The dropdown is populated based on users’ permission. This permission is set in the “Supervision Hierarchy” screen in Administration Tab.    IMPACT: The dropdown of the widget depends on the permission, and the data is calculated based on staff timings.     VALUE: There are 2 values which will enable or disable this feature.  Y – This value enables the display of this widget on the dashboard.  N/NULL – This value disables the widget and is not visible on the dashboard.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'This key enables display of widget named ‘Supervisor Document Service Totals’ on the dashboard. This widget gives the details of productivity of the Unit, Program and the Team as per the selection done in the widget dropdown box. The dropdown is populated based on users’ permission. This permission is set in the “Supervision Hierarchy” screen in Administration Tab.    IMPACT: The dropdown of the widget depends on the permission, and the data is calculated based on staff timings.     VALUE: There are 2 values which will enable or disable this feature.  Y – This value enables the display of this widget on the dashboard.  N/NULL – This value disables the widget and is not visible on the dashboard.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='SuperVisorServiceTotalsWidgetSP';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'DisableNotificationForPrescriber') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('DisableNotificationForPrescriber' 
				,'Y,N'
				,'The SmartCare application has inbuilt notification system where it will trigger the notification for physician when a scheduled service is marked as ‘Show’ in the Reception Screen. This notification automatically pops-up on the left side of the Physicians screen.     This key helps in disabling the notification if the ordering physician himself is the prescriber. So that if the Prescriber himself is the physician, then the notification will not pop-up on the screen.     IMPACT: This key helps in avoiding the unnecessary notification alert for prescriber and intelligently makes sure that the prescriber himself is the physician.         VALUE: There are 2 values which will enable or disable this feature.  Y – This value disables the notification and no pop-up will appear if the prescriber is the physician.  N/Null – This value enables the notification.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'The SmartCare application has inbuilt notification system where it will trigger the notification for physician when a scheduled service is marked as ‘Show’ in the Reception Screen. This notification automatically pops-up on the left side of the Physicians screen.     This key helps in disabling the notification if the ordering physician himself is the prescriber. So that if the Prescriber himself is the physician, then the notification will not pop-up on the screen.     IMPACT: This key helps in avoiding the unnecessary notification alert for prescriber and intelligently makes sure that the prescriber himself is the physician.         VALUE: There are 2 values which will enable or disable this feature.  Y – This value disables the notification and no pop-up will appear if the prescriber is the physician.  N/Null – This value enables the notification.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='DisableNotificationForPrescriber';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'EnableToolSSNTop') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('EnableToolSSNTop' 
				,'Y,N'
				,'As SSN Number is Social Security Number which is client confidential detail and as per federal rules the applications are not supposed to publicly display it unintentionally. Due to this reason we are displaying only the last 4 digit of the SSN on the regular display screen and user can explicitly view it either through tool tip option by hovering mouse on SSN Field or by clicking on Modify. With EnableToolSSNTop configuration values as ‘Y’ the respective screen will display the SSN Number in the tool tip through mouse over on SSN Number field. This tool tip feature is enabled in Client Summary, PMClient Summary, PMClient Information  and Client Information  screen.       IMPACT: This is extra security feature which the client can use to restrict unintentionally display of SSN. Enabling of this feature will show tool tip on Client Summary, PMClient Summary, PMClient Information  and Client Information  screen. Disabling this will not show the SSN Number as tool tip.      VALUE: There are 2 Values which will enable or disable this feature.  Y  – This Enables the SSN Number display on Tool Tip.  N or NULL – This will disable the option and no tool tip is displayed on mouse over.'
				,'N' 
				,'ClientSummary, CareManagement, ClientInformation'
				,'977,994,969'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'As SSN Number is Social Security Number which is client confidential detail and as per federal rules the applications are not supposed to publicly display it unintentionally. Due to this reason we are displaying only the last 4 digit of the SSN on the regular display screen and user can explicitly view it either through tool tip option by hovering mouse on SSN Field or by clicking on Modify. With EnableToolSSNTop configuration values as ‘Y’ the respective screen will display the SSN Number in the tool tip through mouse over on SSN Number field. This tool tip feature is enabled in Client Summary, PMClient Summary, PMClient Information  and Client Information  screen.       IMPACT: This is extra security feature which the client can use to restrict unintentionally display of SSN. Enabling of this feature will show tool tip on Client Summary, PMClient Summary, PMClient Information  and Client Information  screen. Disabling this will not show the SSN Number as tool tip.      VALUE: There are 2 Values which will enable or disable this feature.  Y  – This Enables the SSN Number display on Tool Tip.  N or NULL – This will disable the option and no tool tip is displayed on mouse over.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'ClientSummary, CareManagement, ClientInformation'
		   ,Screens= '977,994,969'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='EnableToolSSNTop';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'SetDefaultFilterOnPaymentServiceSearch') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('SetDefaultFilterOnPaymentServiceSearch' 
				,'Y,N'
				,'This key configuration helps in managing the display of default search criteria in ‘Service Search’ screen. By enabling this key, the search criteria will get reset to ‘Find Only Service Where the Balance>0’ irrespective of the previous search. This is explained in detail in ‘Value’ section below.    The background of this functionality is explained here. Let us say that the bill is raised to payer and the hospital receives the payment through EOB [Explanation of Benefit]. Now, either the user will import the EOB directly or it can be posted manually using the function “Payment/Adjustment Posting” from ‘My Office’ tab.    The payment is adjusted with the services depending upon the selection of the service from the ‘Service Search’ tab. By default, the search criteria keeps the previous search for that window till it is closed. By enabling (Value = Y) this key, the search criteria will get reset to ‘Find Only Service Where the Balance>0’ irrespective of the previous search.          IMPACT: Enabling this configuration resets the search criteria. Hence, new search can be done and different services can be selected. If the value is set to N or NULL, the previous search criteria is saved when switching between windows and the user has to click reset explicitly if he wants to change the search criteria.          VALUE: There are 2 values which would enable or disable this feature.  Y – Enables this feature and resets search criteria automatically.  N/Null – Keeps the previous search criteria when switching the tab and gets reset when the Payment/Adjustment Posting screen is closed.'
				,'N' 
				,'Office Detail'
				,'354'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'This key configuration helps in managing the display of default search criteria in ‘Service Search’ screen. By enabling this key, the search criteria will get reset to ‘Find Only Service Where the Balance>0’ irrespective of the previous search. This is explained in detail in ‘Value’ section below.    The background of this functionality is explained here. Let us say that the bill is raised to payer and the hospital receives the payment through EOB [Explanation of Benefit]. Now, either the user will import the EOB directly or it can be posted manually using the function “Payment/Adjustment Posting” from ‘My Office’ tab.    The payment is adjusted with the services depending upon the selection of the service from the ‘Service Search’ tab. By default, the search criteria keeps the previous search for that window till it is closed. By enabling (Value = Y) this key, the search criteria will get reset to ‘Find Only Service Where the Balance>0’ irrespective of the previous search.          IMPACT: Enabling this configuration resets the search criteria. Hence, new search can be done and different services can be selected. If the value is set to N or NULL, the previous search criteria is saved when switching between windows and the user has to click reset explicitly if he wants to change the search criteria.          VALUE: There are 2 values which would enable or disable this feature.  Y – Enables this feature and resets search criteria automatically.  N/Null – Keeps the previous search criteria when switching the tab and gets reset when the Payment/Adjustment Posting screen is closed.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Office Detail'
		   ,Screens= '354'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='SetDefaultFilterOnPaymentServiceSearch';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'MAROverdueLookbackHours') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('MAROverdueLookbackHours' 
				,24
				,'Client MAR (Medication Administration Record) is the client level banner and it is used by the care provider for recording and viewing the MAR instructions for prescribed drugs with the status (like ‘Given, ‘Refused’, ‘Not Given’ and others).    In Client MAR screen, the dosage specifically scheduled for that hour will show up. If the nurse has administered that dose, then she will be marking it as ‘Given’. Incase, the dose is not administered, then the system will automatically display an alert on the top of the screen with the Overdue icon.  The value set for this key [MAROverdueLookbackHours] is the number of hours that the alert message should be displayed on the screen.          IMPACT: This message will be visible only for the number of hours specified in this configuration key and after that, it will disappear.   The Overdue drugs can be viewed from reports.          VALUE: The values are in hours. Usually, it is set to 24 hours.'
				,'N' 
				,'Client MAR, WhiteBoard, Group MAR'
				,'908,907,1133'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 24
		   ,[Description]= 'Client MAR (Medication Administration Record) is the client level banner and it is used by the care provider for recording and viewing the MAR instructions for prescribed drugs with the status (like ‘Given, ‘Refused’, ‘Not Given’ and others).    In Client MAR screen, the dosage specifically scheduled for that hour will show up. If the nurse has administered that dose, then she will be marking it as ‘Given’. Incase, the dose is not administered, then the system will automatically display an alert on the top of the screen with the Overdue icon.  The value set for this key [MAROverdueLookbackHours] is the number of hours that the alert message should be displayed on the screen.          IMPACT: This message will be visible only for the number of hours specified in this configuration key and after that, it will disappear.   The Overdue drugs can be viewed from reports.          VALUE: The values are in hours. Usually, it is set to 24 hours.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Client MAR, WhiteBoard, Group MAR'
		   ,Screens= '908,907,1133'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='MAROverdueLookbackHours';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'MARNumberofShifts') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('MARNumberofShifts' 
				,'2 ,3'
				,'Client MAR (Medication Administration Record) is the client level banner and it is used by the care provider for recording and viewing the MAR instructions for prescribed drugs with the status (like ‘Given, ‘Refused’, ‘Not Given’ and others).    This key helps in dynamically generating and displaying the schedule in the ‘Client MAR’ screen. For instance, if the value of this key is set to 2, it means that the nurse is working 12 hour (24/2) shift. In this scenario, the screen will be populated with 12 columns.           IMPACT: The display of hours (in that particular shift) in the Client MAR Screen depends on this configuration, and the medicines allocated for the patient shows up at respective time interval. The start time is configured in ‘MARShiftStartTime’ key, and the starting time of the shift is calculated from that value.            VALUE: There are 2 values which will are permitted.  2 – This value creates 12 hour shift  3 – This value creates 8 hour shift'
				,'N' 
				,'Client MAR'
				,'908'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = '2 ,3'
		   ,[Description]= 'Client MAR (Medication Administration Record) is the client level banner and it is used by the care provider for recording and viewing the MAR instructions for prescribed drugs with the status (like ‘Given, ‘Refused’, ‘Not Given’ and others).    This key helps in dynamically generating and displaying the schedule in the ‘Client MAR’ screen. For instance, if the value of this key is set to 2, it means that the nurse is working 12 hour (24/2) shift. In this scenario, the screen will be populated with 12 columns.           IMPACT: The display of hours (in that particular shift) in the Client MAR Screen depends on this configuration, and the medicines allocated for the patient shows up at respective time interval. The start time is configured in ‘MARShiftStartTime’ key, and the starting time of the shift is calculated from that value.            VALUE: There are 2 values which will are permitted.  2 – This value creates 12 hour shift  3 – This value creates 8 hour shift'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Client MAR'
		   ,Screens= '908'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='MARNumberofShifts';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'MARShiftStartTime') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('MARShiftStartTime' 
				,'01:00:00,02:00:00,03:00:00,04:00:00,05:00:00,06:00:00/07:00:00,08:00:00,09:00:00,10:00:00,11:00:00,12:00:00,13:00:00,14:00:00,15:00:00,16:00:00,17:00:00,18:00:00,19:00:00,20:00:00,21:00:00,22:00:00,23:00:00,00:00:00'
				,'Client MAR (Medication Administration Record) is the client level banner and it is used by the care provider for recording and viewing the MAR instructions for prescribed drugs with the status (like ‘Given, ‘Refused’, ‘Not Given’ and others).    In Client MAR screen, the schedule hour columns are divided as per the shift frequency. The value of this key is set to a start time, which is entered in 24 hour format.          IMPACT: The start time in Client MAR screen is populated from this configuration key. The 8 hour shift or 12 hour shift starts with this time consideration.          VALUE: The values are in format HH:MM and 24 hour format is used. The default configuration is 08:00 hours.'
				,'N' 
				,'Client MAR'
				,'908'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = '01:00:00,02:00:00,03:00:00,04:00:00,05:00:00,06:00:00/07:00:00,08:00:00,09:00:00,10:00:00,11:00:00,12:00:00,13:00:00,14:00:00,15:00:00,16:00:00,17:00:00,18:00:00,19:00:00,20:00:00,21:00:00,22:00:00,23:00:00,00:00:00'
		   ,[Description]= 'Client MAR (Medication Administration Record) is the client level banner and it is used by the care provider for recording and viewing the MAR instructions for prescribed drugs with the status (like ‘Given, ‘Refused’, ‘Not Given’ and others).    In Client MAR screen, the schedule hour columns are divided as per the shift frequency. The value of this key is set to a start time, which is entered in 24 hour format.          IMPACT: The start time in Client MAR screen is populated from this configuration key. The 8 hour shift or 12 hour shift starts with this time consideration.          VALUE: The values are in format HH:MM and 24 hour format is used. The default configuration is 08:00 hours.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Client MAR'
		   ,Screens= '908'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='MARShiftStartTime';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'MARAutoScheduleDays') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('MARAutoScheduleDays' 
				,'1,2,3,4'
				,'+ MARAutoScheduleDays - Client MAR (Medication Administration Record) is the client level banner and it is used by the care provider for recording and viewing the MAR instructions for prescribed drugs with the status (like ‘Given, ‘Refused’, ‘Not Given’ and others).    The MAR record is created by NIGHTLY JOB or ON DEMAND and the system utilizes the value for this key – MARAutoScheduleDays to determine how many days from current should the system create the MAR records. VALUE: The values correspond to number of day(s). Ex: Value of 1 is equal to 1 Day.  • If the value of this key is 1, then the MAR record will be created for the current day  • If the value of this key is 2, then the MAR record will be created for current day plus the next day'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = '1,2,3,4'
		   ,[Description]= '+ MARAutoScheduleDays - Client MAR (Medication Administration Record) is the client level banner and it is used by the care provider for recording and viewing the MAR instructions for prescribed drugs with the status (like ‘Given, ‘Refused’, ‘Not Given’ and others).    The MAR record is created by NIGHTLY JOB or ON DEMAND and the system utilizes the value for this key – MARAutoScheduleDays to determine how many days from current should the system create the MAR records. VALUE: The values correspond to number of day(s). Ex: Value of 1 is equal to 1 Day.  • If the value of this key is 1, then the MAR record will be created for the current day  • If the value of this key is 2, then the MAR record will be created for current day plus the next day'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='MARAutoScheduleDays';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'MAREnableStaffDropDown') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('MAREnableStaffDropDown' 
				,'Y,N'
				,'Client MAR (Medication Administration Record) is the client level banner and it is used by the care provider for recording and viewing the MAR instructions for prescribed drugs with the status (like ‘Given, ‘Refused’, ‘Not Given’ and others).    The SmartCare Application by default selects the logged-in user as the drug administer in the Client MAR function. The selection of the Administer can be changed by using this configuration key [MAREnableStaffDropDown], where this enables, disables the dropdown selection containing a list of the staff who can administer drug to the patient.          IMPACT: By enabling this feature, it will allow selection of any user from the drop-down for administering the drug. If the value is N or NULL, the logged-in user is the only person allowed to administer the drug.          VALUE: There are 2 values which will enable or disable this feature.  Y – This value enables selection of dropdown in the scheduled Client MAR.  N/NULL – This value disables selection and the logged-in user is assigned by default.'
				,'N' 
				,'Client MAR'
				,'908'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'Client MAR (Medication Administration Record) is the client level banner and it is used by the care provider for recording and viewing the MAR instructions for prescribed drugs with the status (like ‘Given, ‘Refused’, ‘Not Given’ and others).    The SmartCare Application by default selects the logged-in user as the drug administer in the Client MAR function. The selection of the Administer can be changed by using this configuration key [MAREnableStaffDropDown], where this enables, disables the dropdown selection containing a list of the staff who can administer drug to the patient.          IMPACT: By enabling this feature, it will allow selection of any user from the drop-down for administering the drug. If the value is N or NULL, the logged-in user is the only person allowed to administer the drug.          VALUE: There are 2 values which will enable or disable this feature.  Y – This value enables selection of dropdown in the scheduled Client MAR.  N/NULL – This value disables selection and the logged-in user is assigned by default.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Client MAR'
		   ,Screens= '908'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='MAREnableStaffDropDown';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'UseHTML5Signature') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('UseHTML5Signature' 
				,'Y,N'
				,'Documents can be signed in one of the 3 ways (bulleted below) in SmartCare application. One of the options is to sign using ‘Mouse/Touch Pad’, which captures the signature on the screen when the user signs using finger or stylus. The value set for this key - “UseHTML5Signature” controls the display of the option to sign using Mouse/Touch pad.    When this key is set to ‘Y’, it provides an additional option for the user to sign using “Mouse/Touchpad”.  Here is the background:  The user is presented the following 3 options for signing.  a. Using Password: This option allows signing with password. Type the password in the box when ‘Password’ option-button is selected, and click ‘Sign’  b. Using Signature Pad: This will allow the user to use signature pad for signing, as they are using currently  c. Using Mouse / Touchpad: With this option, the user can sign using their mouse on the screen (while working on laptop / desktop), OR they would be able to sign using finger on a device / tablet PC like Samsung Galaxy tab or Apple iPad. From a device testing point of view, this has been certified on Samsung Galaxy Note 10.1 SM-P6010 Tablet (running OS – Android 4.3 Jelly Bean) AND Apple Ipad3 [16gb Wifi Only].    IMPACT: If the value of this key is set to ‘N’ or ‘NULL’, the Mouse/Touch Pad signature option will not appear on the signature pop-up.    VALUE: There are 2 values which will enable or disable this feature.  Y – When this key is set to ‘Y’, it provides an additional option via a ‘radio button’ for the user to sign using “Mouse/Touchpad”.  N/Null – With this value, the user will not see the option to sign using Mouse/Touch Pad.'
				,'N' 
				,'SignaturePage, Rx- Patient Consent Signature Pop up'
				,'61'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'Documents can be signed in one of the 3 ways (bulleted below) in SmartCare application. One of the options is to sign using ‘Mouse/Touch Pad’, which captures the signature on the screen when the user signs using finger or stylus. The value set for this key - “UseHTML5Signature” controls the display of the option to sign using Mouse/Touch pad.    When this key is set to ‘Y’, it provides an additional option for the user to sign using “Mouse/Touchpad”.  Here is the background:  The user is presented the following 3 options for signing.  a. Using Password: This option allows signing with password. Type the password in the box when ‘Password’ option-button is selected, and click ‘Sign’  b. Using Signature Pad: This will allow the user to use signature pad for signing, as they are using currently  c. Using Mouse / Touchpad: With this option, the user can sign using their mouse on the screen (while working on laptop / desktop), OR they would be able to sign using finger on a device / tablet PC like Samsung Galaxy tab or Apple iPad. From a device testing point of view, this has been certified on Samsung Galaxy Note 10.1 SM-P6010 Tablet (running OS – Android 4.3 Jelly Bean) AND Apple Ipad3 [16gb Wifi Only].    IMPACT: If the value of this key is set to ‘N’ or ‘NULL’, the Mouse/Touch Pad signature option will not appear on the signature pop-up.    VALUE: There are 2 values which will enable or disable this feature.  Y – When this key is set to ‘Y’, it provides an additional option via a ‘radio button’ for the user to sign using “Mouse/Touchpad”.  N/Null – With this value, the user will not see the option to sign using Mouse/Touch Pad.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'SignaturePage, Rx- Patient Consent Signature Pop up'
		   ,Screens= '61'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='UseHTML5Signature';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowRXMedInMAR') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowRXMedInMAR' 
				,'Y,N'
				,'Client MAR (Medication Administration Record) is the client level banner and it is used by the care provider for recording and viewing the MAR instructions for prescribed drugs with the status (like ‘Given, ‘Refused’, ‘Not Given’ and others).    By default, the Client MAR displays only the records which are being ordered from the ‘Client Orders’ screen and any orders made from the ‘Medication’ (SM eRx) screen will not appear on Client MAR screen. By enabling this key, the Orders made from the Medication screen in Rx application will sync with the Client MAR and get displayed as part of the schedule.          IMPACT: If this feature is not enabled, then any medication / dose prescribed through the Medication screen of Rx application will not show up, and will not be recorded in the medication list for the client in the Client MAR function.          VALUE: There are 2 values which will enable or disable this feature.  Y– This value enables the Client MAR to synchronize with the Rx application and get medication information  N/NULL – This value retrieves and displays only those orders made through Client Orders.'
				,'N' 
				,'Client MAR'
				,'908'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'Client MAR (Medication Administration Record) is the client level banner and it is used by the care provider for recording and viewing the MAR instructions for prescribed drugs with the status (like ‘Given, ‘Refused’, ‘Not Given’ and others).    By default, the Client MAR displays only the records which are being ordered from the ‘Client Orders’ screen and any orders made from the ‘Medication’ (SM eRx) screen will not appear on Client MAR screen. By enabling this key, the Orders made from the Medication screen in Rx application will sync with the Client MAR and get displayed as part of the schedule.          IMPACT: If this feature is not enabled, then any medication / dose prescribed through the Medication screen of Rx application will not show up, and will not be recorded in the medication list for the client in the Client MAR function.          VALUE: There are 2 values which will enable or disable this feature.  Y– This value enables the Client MAR to synchronize with the Rx application and get medication information  N/NULL – This value retrieves and displays only those orders made through Client Orders.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Client MAR'
		   ,Screens= '908'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowRXMedInMAR';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'FQHCTab') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('FQHCTab' 
				,'Y,N'
				,'This configuration enables display of additional tab in ‘Client Information Admin’ screen with the tab name as ‘FQHC’.  ‘FQHC’ stands for ‘Federally Qualified Health Centre’. Few hospitals who are treating patients enrolled under federal plans are supposed to record the specific information like Entry Date, Hispanic origin, veteran status and others.  Enabling this tab will help provider in getting this information as part of the client information.         IMPACT: Enabling and disabling of this configuration will impact on visibility and data entry on ‘FQHC’ tab on ‘Client Information Admin’ screen.        VALUE: There are 2 values which will enable or disable this feature.  Y – This value enables the display of the tab ‘FQHC’ in ‘Client Information Admin’ screen.  N or NULL – With this value, the tab ‘FQHC’ will not be visible on the ‘Client Information Admin’ screen.'
				,'N' 
				,'Client Information (Admin)'
				,'370'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'This configuration enables display of additional tab in ‘Client Information Admin’ screen with the tab name as ‘FQHC’.  ‘FQHC’ stands for ‘Federally Qualified Health Centre’. Few hospitals who are treating patients enrolled under federal plans are supposed to record the specific information like Entry Date, Hispanic origin, veteran status and others.  Enabling this tab will help provider in getting this information as part of the client information.         IMPACT: Enabling and disabling of this configuration will impact on visibility and data entry on ‘FQHC’ tab on ‘Client Information Admin’ screen.        VALUE: There are 2 values which will enable or disable this feature.  Y – This value enables the display of the tab ‘FQHC’ in ‘Client Information Admin’ screen.  N or NULL – With this value, the tab ‘FQHC’ will not be visible on the ‘Client Information Admin’ screen.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Client Information (Admin)'
		   ,Screens= '370'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='FQHCTab';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ProductivityServiceHourCalculationFunction') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ProductivityServiceHourCalculationFunction' 
				,'ssf_SCCalculateStaffTargets'
				,'This key calls the Stored Procedure (SP) in the Database which is responsible for calculation logic for ‘service hour’ in the “Documented Service Total” Widget in the dashboard which is having ‘My Hrs TD’, ‘My Lab’ and ‘Team Hrs TD’. Currently the “ssf_SCCalculateStaffTargets” is configured as default and if any customer needs different calculation and parameters then new Stored Procedure is created and will be linked in this field.  The Input parameters are configured in the Screen ‘Staff Targets’.          IMPACT: This SP is responsible only for the calculation and The metrics is derived from the data inputs from the screens ‘Staff Targets’.           VALUE: “ssf_SCCalculateStaffTargets” is the default SP used for calculation and for customers who would need different logic for calculation, an additional SP is created and the SP name is configured.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'ssf_SCCalculateStaffTargets'
		   ,[Description]= 'This key calls the Stored Procedure (SP) in the Database which is responsible for calculation logic for ‘service hour’ in the “Documented Service Total” Widget in the dashboard which is having ‘My Hrs TD’, ‘My Lab’ and ‘Team Hrs TD’. Currently the “ssf_SCCalculateStaffTargets” is configured as default and if any customer needs different calculation and parameters then new Stored Procedure is created and will be linked in this field.  The Input parameters are configured in the Screen ‘Staff Targets’.          IMPACT: This SP is responsible only for the calculation and The metrics is derived from the data inputs from the screens ‘Staff Targets’.           VALUE: “ssf_SCCalculateStaffTargets” is the default SP used for calculation and for customers who would need different logic for calculation, an additional SP is created and the SP name is configured.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ProductivityServiceHourCalculationFunction';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ClaimFileCreation_FileNameModification') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ClaimFileCreation_FileNameModification' 
				,'Y,N'
				,'The Charges once billed and processed without any warnings/error will be ready for the claim file creation. In SmartCare, we use ‘Create Claim File’ Button to generate the claim file in ‘Generate Electronic Claim/Claim Processing’ Screen from parent screen of ‘Charges/Claims’. While we are generating the Claim file, the system by default names the claim file with the batch number eg: 782-CBHNP-UB04.837. This can be changed, and on click of save, the file gets saved with the same name what has been edited on the screen. Thus, this key facilitates saving of the file name in the database as modified by the user in the application.        IMPACT: This configuration key helps user to save the file name in the database as edited on the screen.        VALUE: There are 2 values which will enable or disable this feature. Y – This value enables changing the name of the file and saves the new file name in the database. N/Null – This value does not save the new name in the database.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'The Charges once billed and processed without any warnings/error will be ready for the claim file creation. In SmartCare, we use ‘Create Claim File’ Button to generate the claim file in ‘Generate Electronic Claim/Claim Processing’ Screen from parent screen of ‘Charges/Claims’. While we are generating the Claim file, the system by default names the claim file with the batch number eg: 782-CBHNP-UB04.837. This can be changed, and on click of save, the file gets saved with the same name what has been edited on the screen. Thus, this key facilitates saving of the file name in the database as modified by the user in the application.        IMPACT: This configuration key helps user to save the file name in the database as edited on the screen.        VALUE: There are 2 values which will enable or disable this feature. Y – This value enables changing the name of the file and saves the new file name in the database. N/Null – This value does not save the new name in the database.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ClaimFileCreation_FileNameModification';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'MARDefaultLocationCode') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('MARDefaultLocationCode' 
				,5170
				,'This key helps in capturing the drug administration charge in the MAR (Medication Administration Record).   When the Drug is ordered from the Medication or the Cleint Order screen then this drug is administered by the nurse at the clients bed for residential client and Inpatients.  The procedure code for this can be put into the value of the key where everytime the drug is administered the specific charge is charged to the patient.    IMPACT: A single charge is applied for the drug administration irrespective of if it is a Drug Dose, Infusions or Injections. If the value is empty then this charge is not captured and applied to the patient.     VALUE: The value is the ‘ProcedureCodeID’ which need to be identified from the ‘ProcedureCodes’ table.  Eg: 5170'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 5170
		   ,[Description]= 'This key helps in capturing the drug administration charge in the MAR (Medication Administration Record).   When the Drug is ordered from the Medication or the Cleint Order screen then this drug is administered by the nurse at the clients bed for residential client and Inpatients.  The procedure code for this can be put into the value of the key where everytime the drug is administered the specific charge is charged to the patient.    IMPACT: A single charge is applied for the drug administration irrespective of if it is a Drug Dose, Infusions or Injections. If the value is empty then this charge is not captured and applied to the patient.     VALUE: The value is the ‘ProcedureCodeID’ which need to be identified from the ‘ProcedureCodes’ table.  Eg: 5170'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='MARDefaultLocationCode';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'MeaningfulUseStageLevel') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('MeaningfulUseStageLevel' 
				,'8767, 8766'
				,'As part of the CMS initiative for use of EHR (Electronic Health Records) system by physician, they are certain objectives to be met by the EHR system, and these objectives are divided into 3 stages (for ‘Meaningful Use’ certification). The compliance deadline for meeting the stages are Stage -1 by 2012, Stage -2 by 2014 and Stage – 3 by 2016. Once the EHR is meeting those objectives, then the Physician who is using it will be paid under EHR Incentive program.  SmartCare is certified for meeting these objectives for both Stage 1 and Stage 2. Any hospital can use only one stage at the time. The value in this key determines which stage of Meaningful Use features are being used by the organization.        IMPACT: The Meaningful Use dashboard is influenced by these stages. Depending upon the value of this configuration key, the display of dashboard changes.        VALUE: We are using the global codes for enabling certain feature(s), which are specific to these MU Stages.  8767 – is for Stage 1  8766 – is for Stage 2'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = '8767, 8766'
		   ,[Description]= 'As part of the CMS initiative for use of EHR (Electronic Health Records) system by physician, they are certain objectives to be met by the EHR system, and these objectives are divided into 3 stages (for ‘Meaningful Use’ certification). The compliance deadline for meeting the stages are Stage -1 by 2012, Stage -2 by 2014 and Stage – 3 by 2016. Once the EHR is meeting those objectives, then the Physician who is using it will be paid under EHR Incentive program.  SmartCare is certified for meeting these objectives for both Stage 1 and Stage 2. Any hospital can use only one stage at the time. The value in this key determines which stage of Meaningful Use features are being used by the organization.        IMPACT: The Meaningful Use dashboard is influenced by these stages. Depending upon the value of this configuration key, the display of dashboard changes.        VALUE: We are using the global codes for enabling certain feature(s), which are specific to these MU Stages.  8767 – is for Stage 1  8766 – is for Stage 2'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='MeaningfulUseStageLevel';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowClinicalSummaryGeneralInfo') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowClinicalSummaryGeneralInfo' 
				,'Y,N'
				,'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary is one of the 13 core measures which are mandatory to be fulfilled.  The objective as stated is to “Provide clinical summaries for patients for each office visit”. In SmartCare, we have added function with icon named as ‘CS’ and this icon is part of the tool bar on ‘Services’ and ‘Service Notes’ screen. On the click of the icon, the application creates PDF/XML Report.  The Clinical Summary PDF/XML has 19 sections as part of the report. All these 19 sections are individual keys in the SystemConfigurationKeys table.     In this case, the name of the section is ‘General Information’ and the name of the key is ‘ShowClinicalSummaryGeneralInfo’. The display of ‘General Information’ section/segment in the application is as described in the ‘Values’ heading below.          IMPACT: This key basically assists in managing the display of the section and data within the section.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of the header and data grid of Allergies section. If the client is not having any data for the section, then this table will show as “No Information Available”. If data exists (allergies are recorded), then it will display data with details.  N– This value disables this section and the header and the data grid is hidden and will be not part of the generated PDF/XML report.'
				,'N' 
				,'ClinicalSummary'
				,'939'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary is one of the 13 core measures which are mandatory to be fulfilled.  The objective as stated is to “Provide clinical summaries for patients for each office visit”. In SmartCare, we have added function with icon named as ‘CS’ and this icon is part of the tool bar on ‘Services’ and ‘Service Notes’ screen. On the click of the icon, the application creates PDF/XML Report.  The Clinical Summary PDF/XML has 19 sections as part of the report. All these 19 sections are individual keys in the SystemConfigurationKeys table.     In this case, the name of the section is ‘General Information’ and the name of the key is ‘ShowClinicalSummaryGeneralInfo’. The display of ‘General Information’ section/segment in the application is as described in the ‘Values’ heading below.          IMPACT: This key basically assists in managing the display of the section and data within the section.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of the header and data grid of Allergies section. If the client is not having any data for the section, then this table will show as “No Information Available”. If data exists (allergies are recorded), then it will display data with details.  N– This value disables this section and the header and the data grid is hidden and will be not part of the generated PDF/XML report.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'ClinicalSummary'
		   ,Screens= '939'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowClinicalSummaryGeneralInfo';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowClinicalSummaryClientInfo') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowClinicalSummaryClientInfo' 
				,'Y,N'
				,'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary is one of the 13 core measures which are mandatory to be fulfilled.  The objective as stated is to “Provide clinical summaries for patients for each office visit”. In SmartCare, we have added function with icon named as ‘CS’ and this icon is part of the tool bar on ‘Services’ and ‘Service Notes’ screen. On the click of the icon, the application creates PDF/XML Report.  The Clinical Summary PDF/XML has 19 sections as part of the report. All these 19 sections are individual keys in the SystemConfigurationKeys table.     In this case, the name of the section is ‘Client Information’ and the name of the key is ‘ShowClinicalSummaryClientInfo’. The display of ‘Client Information’ section/segment in the application is as described in the ‘Values’ heading below.    Impact: This key basically assists in managing the display of the section and data within the section.         VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of the header and data grid of Allergies section. If the client is not having any data for the section, then this table will show as “No Information Available”. If data exists (allergies are recorded), then it will display data with details.  N– This value disables this section and the header and the data grid is hidden and will be not part of the generated PDF/XML report.'
				,'N' 
				,'ClinicalSummary'
				,'939'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary is one of the 13 core measures which are mandatory to be fulfilled.  The objective as stated is to “Provide clinical summaries for patients for each office visit”. In SmartCare, we have added function with icon named as ‘CS’ and this icon is part of the tool bar on ‘Services’ and ‘Service Notes’ screen. On the click of the icon, the application creates PDF/XML Report.  The Clinical Summary PDF/XML has 19 sections as part of the report. All these 19 sections are individual keys in the SystemConfigurationKeys table.     In this case, the name of the section is ‘Client Information’ and the name of the key is ‘ShowClinicalSummaryClientInfo’. The display of ‘Client Information’ section/segment in the application is as described in the ‘Values’ heading below.    Impact: This key basically assists in managing the display of the section and data within the section.         VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of the header and data grid of Allergies section. If the client is not having any data for the section, then this table will show as “No Information Available”. If data exists (allergies are recorded), then it will display data with details.  N– This value disables this section and the header and the data grid is hidden and will be not part of the generated PDF/XML report.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'ClinicalSummary'
		   ,Screens= '939'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowClinicalSummaryClientInfo';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowClinicalSummaryVisitReason') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowClinicalSummaryVisitReason' 
				,'Y,N'
				,'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary is one of the 13 core measures which are mandatory to be fulfilled.  The objective as stated is to “Provide clinical summaries for patients for each office visit”. In SmartCare, we have added function with icon named as ‘CS’ and this icon is part of the tool bar on ‘Services’ and ‘Service Notes’ screen. On the click of the icon, the application creates PDF/XML Report.  The Clinical Summary PDF/XML has 19 sections as part of the report. All these 19 sections are individual keys in the SystemConfigurationKeys table.     In this case, the name of the section is ‘Reason For Visit’ and the name of the key is ‘ShowClinicalSummaryVisitReason’. The display of ‘Reason For Visit’ section/segment in the application is as described in the ‘Values’ heading below.          IMPACT: This key basically assists in managing the display of the section and data within the section.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of the header and data grid of Allergies section. If the client is not having any data for the section, then this table will show as “No Information Available”. If data exists (allergies are recorded), then it will display data with details.  N– This value disables this section and the header and the data grid is hidden and will be not part of the generated PDF/XML report.'
				,'N' 
				,'ClinicalSummary'
				,'939'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary is one of the 13 core measures which are mandatory to be fulfilled.  The objective as stated is to “Provide clinical summaries for patients for each office visit”. In SmartCare, we have added function with icon named as ‘CS’ and this icon is part of the tool bar on ‘Services’ and ‘Service Notes’ screen. On the click of the icon, the application creates PDF/XML Report.  The Clinical Summary PDF/XML has 19 sections as part of the report. All these 19 sections are individual keys in the SystemConfigurationKeys table.     In this case, the name of the section is ‘Reason For Visit’ and the name of the key is ‘ShowClinicalSummaryVisitReason’. The display of ‘Reason For Visit’ section/segment in the application is as described in the ‘Values’ heading below.          IMPACT: This key basically assists in managing the display of the section and data within the section.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of the header and data grid of Allergies section. If the client is not having any data for the section, then this table will show as “No Information Available”. If data exists (allergies are recorded), then it will display data with details.  N– This value disables this section and the header and the data grid is hidden and will be not part of the generated PDF/XML report.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'ClinicalSummary'
		   ,Screens= '939'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowClinicalSummaryVisitReason';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowClinicalSummaryDiagnosis') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowClinicalSummaryDiagnosis' 
				,'Y,N'
				,'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary is one of the 13 core measures which are mandatory to be fulfilled.  The objective as stated is to “Provide clinical summaries for patients for each office visit”. In SmartCare, we have added function with icon named as ‘CS’ and this icon is part of the tool bar on ‘Services’ and ‘Service Notes’ screen. On the click of the icon, the application creates PDF/XML Report.  The Clinical Summary PDF/XML has 19 sections as part of the report. All these 19 sections are individual keys in the SystemConfigurationKeys table.     In this case, the name of the section is ‘Current Diagnosis/Problem List’ and the name of the key is ‘ShowClinicalSummaryDiagnosis’. The display of ‘Current Diagnosis/Problem List’ section/segment in the application is as described in the ‘Values’ heading below.          IMPACT: This key basically assists in managing the display of the section and data within the section.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of the header and data grid of Allergies section. If the client is not having any data for the section, then this table will show as “No Information Available”. If data exists (allergies are recorded), then it will display data with details.  N– This value disables this section and the header and the data grid is hidden and will be not part of the generated PDF/XML report.'
				,'N' 
				,'ClinicalSummary'
				,'939'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary is one of the 13 core measures which are mandatory to be fulfilled.  The objective as stated is to “Provide clinical summaries for patients for each office visit”. In SmartCare, we have added function with icon named as ‘CS’ and this icon is part of the tool bar on ‘Services’ and ‘Service Notes’ screen. On the click of the icon, the application creates PDF/XML Report.  The Clinical Summary PDF/XML has 19 sections as part of the report. All these 19 sections are individual keys in the SystemConfigurationKeys table.     In this case, the name of the section is ‘Current Diagnosis/Problem List’ and the name of the key is ‘ShowClinicalSummaryDiagnosis’. The display of ‘Current Diagnosis/Problem List’ section/segment in the application is as described in the ‘Values’ heading below.          IMPACT: This key basically assists in managing the display of the section and data within the section.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of the header and data grid of Allergies section. If the client is not having any data for the section, then this table will show as “No Information Available”. If data exists (allergies are recorded), then it will display data with details.  N– This value disables this section and the header and the data grid is hidden and will be not part of the generated PDF/XML report.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'ClinicalSummary'
		   ,Screens= '939'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowClinicalSummaryDiagnosis';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowClinicalSummaryProcedureIntervention') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowClinicalSummaryProcedureIntervention' 
				,'Y,N'
				,'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary is one of the 13 core measures which are mandatory to be fulfilled.  The objective as stated is to “Provide clinical summaries for patients for each office visit”. In SmartCare, we have added function with icon named as ‘CS’ and this icon is part of the tool bar on ‘Services’ and ‘Service Notes’ screen. On the click of the icon, the application creates PDF/XML Report.  The Clinical Summary PDF/XML has 19 sections as part of the report. All these 19 sections are individual keys in the SystemConfigurationKeys table.     In this case, the name of the section is ‘Procedure/Interventions Performed During Visit’ and the name of the key is ‘ShowClinicalSummaryProcedureIntervention’. The display of ‘Procedure/Interventions Performed During Visit’ section/segment in the application is as described in the ‘Values’ heading below.          IMPACT: This key basically assists in managing the display of the section and data within the section.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of the header and data grid of Allergies section. If the client is not having any data for the section, then this table will show as “No Information Available”. If data exists (allergies are recorded), then it will display data with details.  N– This value disables this section and the header and the data grid is hidden and will be not part of the generated PDF/XML report.'
				,'N' 
				,'ClinicalSummary'
				,'939'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary is one of the 13 core measures which are mandatory to be fulfilled.  The objective as stated is to “Provide clinical summaries for patients for each office visit”. In SmartCare, we have added function with icon named as ‘CS’ and this icon is part of the tool bar on ‘Services’ and ‘Service Notes’ screen. On the click of the icon, the application creates PDF/XML Report.  The Clinical Summary PDF/XML has 19 sections as part of the report. All these 19 sections are individual keys in the SystemConfigurationKeys table.     In this case, the name of the section is ‘Procedure/Interventions Performed During Visit’ and the name of the key is ‘ShowClinicalSummaryProcedureIntervention’. The display of ‘Procedure/Interventions Performed During Visit’ section/segment in the application is as described in the ‘Values’ heading below.          IMPACT: This key basically assists in managing the display of the section and data within the section.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of the header and data grid of Allergies section. If the client is not having any data for the section, then this table will show as “No Information Available”. If data exists (allergies are recorded), then it will display data with details.  N– This value disables this section and the header and the data grid is hidden and will be not part of the generated PDF/XML report.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'ClinicalSummary'
		   ,Screens= '939'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowClinicalSummaryProcedureIntervention';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowClinicalSummaryVitals') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowClinicalSummaryVitals' 
				,'Y,N'
				,'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary is one of the 13 core measures which are mandatory to be fulfilled.  The objective as stated is to “Provide clinical summaries for patients for each office visit”. In SmartCare, we have added function with icon named as ‘CS’ and this icon is part of the tool bar on ‘Services’ and ‘Service Notes’ screen. On the click of the icon, the application creates PDF/XML Report.  The Clinical Summary PDF/XML has 19 sections as part of the report. All these 19 sections are individual keys in the SystemConfigurationKeys table.     In this case, the name of the section is ‘Vital Signs’ and the name of the key is ‘ShowClinicalSummaryVitals’. The display of ‘Vital Signs’ section/segment in the application is as described in the ‘Values’ heading below.          IMPACT: This key basically assists in managing the display of the section and data within the section.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of the header and data grid of Allergies section. If the client is not having any data for the section, then this table will show as “No Information Available”. If data exists (allergies are recorded), then it will display data with details.  N– This value disables this section and the header and the data grid is hidden and will be not part of the generated PDF/XML report.'
				,'N' 
				,'ClinicalSummary'
				,'939'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary is one of the 13 core measures which are mandatory to be fulfilled.  The objective as stated is to “Provide clinical summaries for patients for each office visit”. In SmartCare, we have added function with icon named as ‘CS’ and this icon is part of the tool bar on ‘Services’ and ‘Service Notes’ screen. On the click of the icon, the application creates PDF/XML Report.  The Clinical Summary PDF/XML has 19 sections as part of the report. All these 19 sections are individual keys in the SystemConfigurationKeys table.     In this case, the name of the section is ‘Vital Signs’ and the name of the key is ‘ShowClinicalSummaryVitals’. The display of ‘Vital Signs’ section/segment in the application is as described in the ‘Values’ heading below.          IMPACT: This key basically assists in managing the display of the section and data within the section.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of the header and data grid of Allergies section. If the client is not having any data for the section, then this table will show as “No Information Available”. If data exists (allergies are recorded), then it will display data with details.  N– This value disables this section and the header and the data grid is hidden and will be not part of the generated PDF/XML report.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'ClinicalSummary'
		   ,Screens= '939'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowClinicalSummaryVitals';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowClinicalSummaryAllergies') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowClinicalSummaryAllergies' 
				,'Y,N'
				,'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary is one of the 13 core measures which are mandatory to be fulfilled.  The objective as stated is to “Provide clinical summaries for patients for each office visit”. In SmartCare, we have added function with icon named as ‘CS’ and this icon is part of the tool bar on ‘Services’ and ‘Service Notes’ screen. On the click of the icon, the application creates PDF/XML Report.  The Clinical Summary PDF/XML has 19 sections as part of the report. All these 19 sections are individual keys in the SystemConfigurationKeys table.     In this case, the name of the section is ‘Allergies’ and the name of the key is ‘ShowClinicalSummaryAllergies’. The display of ‘Allergies’ section/segment in the application is as described in the ‘Values’ heading below.          IMPACT: This key basically assists in managing the display of the section and data within the section.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of the header and data grid of Allergies section. If the client is not having any data for the section, then this table will show as “No Information Available”. If data exists (allergies are recorded), then it will display data with details.  N– This value disables this section and the header and the data grid is hidden and will be not part of the generated PDF/XML report.'
				,'N' 
				,'ClinicalSummary'
				,'939'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary is one of the 13 core measures which are mandatory to be fulfilled.  The objective as stated is to “Provide clinical summaries for patients for each office visit”. In SmartCare, we have added function with icon named as ‘CS’ and this icon is part of the tool bar on ‘Services’ and ‘Service Notes’ screen. On the click of the icon, the application creates PDF/XML Report.  The Clinical Summary PDF/XML has 19 sections as part of the report. All these 19 sections are individual keys in the SystemConfigurationKeys table.     In this case, the name of the section is ‘Allergies’ and the name of the key is ‘ShowClinicalSummaryAllergies’. The display of ‘Allergies’ section/segment in the application is as described in the ‘Values’ heading below.          IMPACT: This key basically assists in managing the display of the section and data within the section.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of the header and data grid of Allergies section. If the client is not having any data for the section, then this table will show as “No Information Available”. If data exists (allergies are recorded), then it will display data with details.  N– This value disables this section and the header and the data grid is hidden and will be not part of the generated PDF/XML report.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'ClinicalSummary'
		   ,Screens= '939'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowClinicalSummaryAllergies';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowClinicalSummarySmokingStatus') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowClinicalSummarySmokingStatus' 
				,'Y,N'
				,'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary is one of the 13 core measures which are mandatory to be fulfilled.  The objective as stated is to “Provide clinical summaries for patients for each office visit”. In SmartCare, we have added function with icon named as ‘CS’ and this icon is part of the tool bar on ‘Services’ and ‘Service Notes’ screen. On the click of the icon, the application creates PDF/XML Report.  The Clinical Summary PDF/XML has 19 sections as part of the report. All these 19 sections are individual keys in the SystemConfigurationKeys table.     In this case, the name of the section is ‘Smoking Status’ and the name of the key is ‘ShowClinicalSummarySmokingStatus’. The display of ‘Smoking Status’ section/segment in the application is as described in the ‘Values’ heading below.          IMPACT: This key basically assists in managing the display of the section and data within the section.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of the header and data grid of Allergies section. If the client is not having any data for the section, then this table will show as “No Information Available”. If data exists (allergies are recorded), then it will display data with details.  N– This value disables this section and the header and the data grid is hidden and will be not part of the generated PDF/XML report.'
				,'N' 
				,'ClinicalSummary'
				,'939'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary is one of the 13 core measures which are mandatory to be fulfilled.  The objective as stated is to “Provide clinical summaries for patients for each office visit”. In SmartCare, we have added function with icon named as ‘CS’ and this icon is part of the tool bar on ‘Services’ and ‘Service Notes’ screen. On the click of the icon, the application creates PDF/XML Report.  The Clinical Summary PDF/XML has 19 sections as part of the report. All these 19 sections are individual keys in the SystemConfigurationKeys table.     In this case, the name of the section is ‘Smoking Status’ and the name of the key is ‘ShowClinicalSummarySmokingStatus’. The display of ‘Smoking Status’ section/segment in the application is as described in the ‘Values’ heading below.          IMPACT: This key basically assists in managing the display of the section and data within the section.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of the header and data grid of Allergies section. If the client is not having any data for the section, then this table will show as “No Information Available”. If data exists (allergies are recorded), then it will display data with details.  N– This value disables this section and the header and the data grid is hidden and will be not part of the generated PDF/XML report.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'ClinicalSummary'
		   ,Screens= '939'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowClinicalSummarySmokingStatus';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowClinicalSummaryCurrentMedication') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowClinicalSummaryCurrentMedication' 
				,'Y,N'
				,'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary is one of the 13 core measures which are mandatory to be fulfilled.  The objective as stated is to “Provide clinical summaries for patients for each office visit”. In SmartCare, we have added function with icon named as ‘CS’ and this icon is part of the tool bar on ‘Services’ and ‘Service Notes’ screen. On the click of the icon, the application creates PDF/XML Report.  The Clinical Summary PDF/XML has 19 sections as part of the report. All these 19 sections are individual keys in the SystemConfigurationKeys table.     In this case, the name of the section is ‘Current Medications’ and the name of the key is ‘ShowClinicalSummaryCurrentMedication’. The display of ‘Current Medications’ section/segment in the application is as described in the ‘Values’ heading below.          IMPACT: This key basically assists in managing the display of the section and data within the section.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of the header and data grid of Allergies section. If the client is not having any data for the section, then this table will show as “No Information Available”. If data exists (allergies are recorded), then it will display data with details.  N– This value disables this section and the header and the data grid is hidden and will be not part of the generated PDF/XML report.'
				,'N' 
				,'ClinicalSummary'
				,'939'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary is one of the 13 core measures which are mandatory to be fulfilled.  The objective as stated is to “Provide clinical summaries for patients for each office visit”. In SmartCare, we have added function with icon named as ‘CS’ and this icon is part of the tool bar on ‘Services’ and ‘Service Notes’ screen. On the click of the icon, the application creates PDF/XML Report.  The Clinical Summary PDF/XML has 19 sections as part of the report. All these 19 sections are individual keys in the SystemConfigurationKeys table.     In this case, the name of the section is ‘Current Medications’ and the name of the key is ‘ShowClinicalSummaryCurrentMedication’. The display of ‘Current Medications’ section/segment in the application is as described in the ‘Values’ heading below.          IMPACT: This key basically assists in managing the display of the section and data within the section.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of the header and data grid of Allergies section. If the client is not having any data for the section, then this table will show as “No Information Available”. If data exists (allergies are recorded), then it will display data with details.  N– This value disables this section and the header and the data grid is hidden and will be not part of the generated PDF/XML report.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'ClinicalSummary'
		   ,Screens= '939'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowClinicalSummaryCurrentMedication';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowClinicalSummaryMedicationAdministrated') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowClinicalSummaryMedicationAdministrated' 
				,'Y,N'
				,'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary is one of the 13 core measures which are mandatory to be fulfilled.  The objective as stated is to “Provide clinical summaries for patients for each office visit”. In SmartCare, we have added function with icon named as ‘CS’ and this icon is part of the tool bar on ‘Services’ and ‘Service Notes’ screen. On the click of the icon, the application creates PDF/XML Report.  The Clinical Summary PDF/XML has 19 sections as part of the report. All these 19 sections are individual keys in the SystemConfigurationKeys table.     In this case, the name of the section is ‘AMedications Administrated During Visit’ and the name of the key is ‘ShowClinicalSummaryMedicationAdministrated’. The display of ‘Medications Administrated During Visit’ section/segment in the application is as described in the ‘Values’ heading below.          IMPACT: This key basically assists in managing the display of the section and data within the section.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of the header and data grid of Allergies section. If the client is not having any data for the section, then this table will show as “No Information Available”. If data exists (allergies are recorded), then it will display data with details.  N– This value disables this section and the header and the data grid is hidden and will be not part of the generated PDF/XML report.'
				,'N' 
				,'ClinicalSummary'
				,'939'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary is one of the 13 core measures which are mandatory to be fulfilled.  The objective as stated is to “Provide clinical summaries for patients for each office visit”. In SmartCare, we have added function with icon named as ‘CS’ and this icon is part of the tool bar on ‘Services’ and ‘Service Notes’ screen. On the click of the icon, the application creates PDF/XML Report.  The Clinical Summary PDF/XML has 19 sections as part of the report. All these 19 sections are individual keys in the SystemConfigurationKeys table.     In this case, the name of the section is ‘AMedications Administrated During Visit’ and the name of the key is ‘ShowClinicalSummaryMedicationAdministrated’. The display of ‘Medications Administrated During Visit’ section/segment in the application is as described in the ‘Values’ heading below.          IMPACT: This key basically assists in managing the display of the section and data within the section.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of the header and data grid of Allergies section. If the client is not having any data for the section, then this table will show as “No Information Available”. If data exists (allergies are recorded), then it will display data with details.  N– This value disables this section and the header and the data grid is hidden and will be not part of the generated PDF/XML report.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'ClinicalSummary'
		   ,Screens= '939'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowClinicalSummaryMedicationAdministrated';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowClinicalSummaryImmunizations') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowClinicalSummaryImmunizations' 
				,'Y,N'
				,'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary is one of the 13 core measures which are mandatory to be fulfilled.  The objective as stated is to “Provide clinical summaries for patients for each office visit”. In SmartCare, we have added function with icon named as ‘CS’ and this icon is part of the tool bar on ‘Services’ and ‘Service Notes’ screen. On the click of the icon, the application creates PDF/XML Report.  The Clinical Summary PDF/XML has 19 sections as part of the report. All these 19 sections are individual keys in the SystemConfigurationKeys table.     In this case, the name of the section is ‘Immunizations Administrated During Visit’ and the name of the key is ‘ShowClinicalSummaryImmunizations’. The display of ‘Immunizations Administrated During Visit’ section/segment in the application is as described in the ‘Values’ heading below.          IMPACT: This key basically assists in managing the display of the section and data within the section.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of the header and data grid of Allergies section. If the client is not having any data for the section, then this table will show as “No Information Available”. If data exists (allergies are recorded), then it will display data with details.  N– This value disables this section and the header and the data grid is hidden and will be not part of the generated PDF/XML report.'
				,'N' 
				,'ClinicalSummary'
				,'939'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary is one of the 13 core measures which are mandatory to be fulfilled.  The objective as stated is to “Provide clinical summaries for patients for each office visit”. In SmartCare, we have added function with icon named as ‘CS’ and this icon is part of the tool bar on ‘Services’ and ‘Service Notes’ screen. On the click of the icon, the application creates PDF/XML Report.  The Clinical Summary PDF/XML has 19 sections as part of the report. All these 19 sections are individual keys in the SystemConfigurationKeys table.     In this case, the name of the section is ‘Immunizations Administrated During Visit’ and the name of the key is ‘ShowClinicalSummaryImmunizations’. The display of ‘Immunizations Administrated During Visit’ section/segment in the application is as described in the ‘Values’ heading below.          IMPACT: This key basically assists in managing the display of the section and data within the section.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of the header and data grid of Allergies section. If the client is not having any data for the section, then this table will show as “No Information Available”. If data exists (allergies are recorded), then it will display data with details.  N– This value disables this section and the header and the data grid is hidden and will be not part of the generated PDF/XML report.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'ClinicalSummary'
		   ,Screens= '939'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowClinicalSummaryImmunizations';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowClinicalSummaryResultReviewed') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowClinicalSummaryResultReviewed' 
				,'Y,N'
				,'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary is one of the 13 core measures which are mandatory to be fulfilled.  The objective as stated is to “Provide clinical summaries for patients for each office visit”. In SmartCare, we have added function with icon named as ‘CS’ and this icon is part of the tool bar on ‘Services’ and ‘Service Notes’ screen. On the click of the icon, the application creates PDF/XML Report.  The Clinical Summary PDF/XML has 19 sections as part of the report. All these 19 sections are individual keys in the SystemConfigurationKeys table.     In this case, the name of the section is ‘Result Reviewed Date of Visit’ and the name of the key is ‘ShowClinicalSummaryResultReviewed’. The display of ‘Result Reviewed Date of Visit’ section/segment in the application is as described in the ‘Values’ heading below.          IMPACT: This key basically assists in managing the display of the section and data within the section.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of the header and data grid of Allergies section. If the client is not having any data for the section, then this table will show as “No Information Available”. If data exists (allergies are recorded), then it will display data with details.  N– This value disables this section and the header and the data grid is hidden and will be not part of the generated PDF/XML report.'
				,'N' 
				,'ClinicalSummary'
				,'939'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary is one of the 13 core measures which are mandatory to be fulfilled.  The objective as stated is to “Provide clinical summaries for patients for each office visit”. In SmartCare, we have added function with icon named as ‘CS’ and this icon is part of the tool bar on ‘Services’ and ‘Service Notes’ screen. On the click of the icon, the application creates PDF/XML Report.  The Clinical Summary PDF/XML has 19 sections as part of the report. All these 19 sections are individual keys in the SystemConfigurationKeys table.     In this case, the name of the section is ‘Result Reviewed Date of Visit’ and the name of the key is ‘ShowClinicalSummaryResultReviewed’. The display of ‘Result Reviewed Date of Visit’ section/segment in the application is as described in the ‘Values’ heading below.          IMPACT: This key basically assists in managing the display of the section and data within the section.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of the header and data grid of Allergies section. If the client is not having any data for the section, then this table will show as “No Information Available”. If data exists (allergies are recorded), then it will display data with details.  N– This value disables this section and the header and the data grid is hidden and will be not part of the generated PDF/XML report.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'ClinicalSummary'
		   ,Screens= '939'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowClinicalSummaryResultReviewed';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowClinicalSummaryEducation') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowClinicalSummaryEducation' 
				,'Y,N'
				,'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary is one of the 13 core measures which are mandatory to be fulfilled.  The objective as stated is to “Provide clinical summaries for patients for each office visit”. In SmartCare, we have added function with icon named as ‘CS’ and this icon is part of the tool bar on ‘Services’ and ‘Service Notes’ screen. On the click of the icon, the application creates PDF/XML Report.  The Clinical Summary PDF/XML has 19 sections as part of the report. All these 19 sections are individual keys in the SystemConfigurationKeys table.     In this case, the name of the section is ‘Patient Education/Decision Aides’ and the name of the key is ‘ShowClinicalSummaryEducation’. The display of ‘Patient Education/Decision Aides’ section/segment in the application is as described in the ‘Values’ heading below.          IMPACT: This key basically assists in managing the display of the section and data within the section.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of the header and data grid of Allergies section. If the client is not having any data for the section, then this table will show as “No Information Available”. If data exists (allergies are recorded), then it will display data with details.  N– This value disables this section and the header and the data grid is hidden and will be not part of the generated PDF/XML report.'
				,'N' 
				,'ClinicalSummary'
				,'939'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary is one of the 13 core measures which are mandatory to be fulfilled.  The objective as stated is to “Provide clinical summaries for patients for each office visit”. In SmartCare, we have added function with icon named as ‘CS’ and this icon is part of the tool bar on ‘Services’ and ‘Service Notes’ screen. On the click of the icon, the application creates PDF/XML Report.  The Clinical Summary PDF/XML has 19 sections as part of the report. All these 19 sections are individual keys in the SystemConfigurationKeys table.     In this case, the name of the section is ‘Patient Education/Decision Aides’ and the name of the key is ‘ShowClinicalSummaryEducation’. The display of ‘Patient Education/Decision Aides’ section/segment in the application is as described in the ‘Values’ heading below.          IMPACT: This key basically assists in managing the display of the section and data within the section.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of the header and data grid of Allergies section. If the client is not having any data for the section, then this table will show as “No Information Available”. If data exists (allergies are recorded), then it will display data with details.  N– This value disables this section and the header and the data grid is hidden and will be not part of the generated PDF/XML report.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'ClinicalSummary'
		   ,Screens= '939'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowClinicalSummaryEducation';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowClinicalSummaryReferralToOther') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowClinicalSummaryReferralToOther' 
				,'Y,N'
				,'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary is one of the 13 core measures which are mandatory to be fulfilled.  The objective as stated is to “Provide clinical summaries for patients for each office visit”. In SmartCare, we have added function with icon named as ‘CS’ and this icon is part of the tool bar on ‘Services’ and ‘Service Notes’ screen. On the click of the icon, the application creates PDF/XML Report.  The Clinical Summary PDF/XML has 19 sections as part of the report. All these 19 sections are individual keys in the SystemConfigurationKeys table.     In this case, the name of the section is ‘Referrals To Other Providers’ and the name of the key is ‘ShowClinicalSummaryReferralToOther’. The display of ‘Referrals To Other Providers’ section/segment in the application is as described in the ‘Values’ heading below.          IMPACT: This key basically assists in managing the display of the section and data within the section.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of the header and data grid of Allergies section. If the client is not having any data for the section, then this table will show as “No Information Available”. If data exists (allergies are recorded), then it will display data with details.  N– This value disables this section and the header and the data grid is hidden and will be not part of the generated PDF/XML report.'
				,'N' 
				,'ClinicalSummary'
				,'939'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary is one of the 13 core measures which are mandatory to be fulfilled.  The objective as stated is to “Provide clinical summaries for patients for each office visit”. In SmartCare, we have added function with icon named as ‘CS’ and this icon is part of the tool bar on ‘Services’ and ‘Service Notes’ screen. On the click of the icon, the application creates PDF/XML Report.  The Clinical Summary PDF/XML has 19 sections as part of the report. All these 19 sections are individual keys in the SystemConfigurationKeys table.     In this case, the name of the section is ‘Referrals To Other Providers’ and the name of the key is ‘ShowClinicalSummaryReferralToOther’. The display of ‘Referrals To Other Providers’ section/segment in the application is as described in the ‘Values’ heading below.          IMPACT: This key basically assists in managing the display of the section and data within the section.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of the header and data grid of Allergies section. If the client is not having any data for the section, then this table will show as “No Information Available”. If data exists (allergies are recorded), then it will display data with details.  N– This value disables this section and the header and the data grid is hidden and will be not part of the generated PDF/XML report.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'ClinicalSummary'
		   ,Screens= '939'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowClinicalSummaryReferralToOther';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowClinicalSummaryAppointments') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowClinicalSummaryAppointments' 
				,'Y,N'
				,'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary is one of the 13 core measures which are mandatory to be fulfilled.  The objective as stated is to “Provide clinical summaries for patients for each office visit”. In SmartCare, we have added function with icon named as ‘CS’ and this icon is part of the tool bar on ‘Services’ and ‘Service Notes’ screen. On the click of the icon, the application creates PDF/XML Report.  The Clinical Summary PDF/XML has 19 sections as part of the report. All these 19 sections are individual keys in the SystemConfigurationKeys table.     In this case, the name of the section is ‘Up Coming Appointments’ and the name of the key is ‘ShowClinicalSummaryAppointments’. The display of ‘Up Coming Appointments’ section/segment in the application is as described in the ‘Values’ heading below.          IMPACT: This key basically assists in managing the display of the section and data within the section.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of the header and data grid of Allergies section. If the client is not having any data for the section, then this table will show as “No Information Available”. If data exists (allergies are recorded), then it will display data with details.  N– This value disables this section and the header and the data grid is hidden and will be not part of the generated PDF/XML report.'
				,'N' 
				,'ClinicalSummary'
				,'939'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary is one of the 13 core measures which are mandatory to be fulfilled.  The objective as stated is to “Provide clinical summaries for patients for each office visit”. In SmartCare, we have added function with icon named as ‘CS’ and this icon is part of the tool bar on ‘Services’ and ‘Service Notes’ screen. On the click of the icon, the application creates PDF/XML Report.  The Clinical Summary PDF/XML has 19 sections as part of the report. All these 19 sections are individual keys in the SystemConfigurationKeys table.     In this case, the name of the section is ‘Up Coming Appointments’ and the name of the key is ‘ShowClinicalSummaryAppointments’. The display of ‘Up Coming Appointments’ section/segment in the application is as described in the ‘Values’ heading below.          IMPACT: This key basically assists in managing the display of the section and data within the section.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of the header and data grid of Allergies section. If the client is not having any data for the section, then this table will show as “No Information Available”. If data exists (allergies are recorded), then it will display data with details.  N– This value disables this section and the header and the data grid is hidden and will be not part of the generated PDF/XML report.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'ClinicalSummary'
		   ,Screens= '939'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowClinicalSummaryAppointments';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowClinicalSummaryGoalsObjectives') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowClinicalSummaryGoalsObjectives' 
				,'Y,N'
				,'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary is one of the 13 core measures which are mandatory to be fulfilled.  The objective as stated is to “Provide clinical summaries for patients for each office visit”. In SmartCare, we have added function with icon named as ‘CS’ and this icon is part of the tool bar on ‘Services’ and ‘Service Notes’ screen. On the click of the icon, the application creates PDF/XML Report.  The Clinical Summary PDF/XML has 19 sections as part of the report. All these 19 sections are individual keys in the SystemConfigurationKeys table.     In this case, the name of the section is ‘Plan of Care’ and the name of the key is ShowClinicalSummaryGoalsObjectives. The display of ‘Plan of Care’ section/segment in the application is as described in the ‘Values’ heading below.          IMPACT: This key basically assists in managing the display of the section and data within the section.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of the header and data grid of Allergies section. If the client is not having any data for the section, then this table will show as “No Information Available”. If data exists (allergies are recorded), then it will display data with details.  N– This value disables this section and the header and the data grid is hidden and will be not part of the generated PDF/XML report.'
				,'N' 
				,'ClinicalSummary'
				,'939'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary is one of the 13 core measures which are mandatory to be fulfilled.  The objective as stated is to “Provide clinical summaries for patients for each office visit”. In SmartCare, we have added function with icon named as ‘CS’ and this icon is part of the tool bar on ‘Services’ and ‘Service Notes’ screen. On the click of the icon, the application creates PDF/XML Report.  The Clinical Summary PDF/XML has 19 sections as part of the report. All these 19 sections are individual keys in the SystemConfigurationKeys table.     In this case, the name of the section is ‘Plan of Care’ and the name of the key is ShowClinicalSummaryGoalsObjectives. The display of ‘Plan of Care’ section/segment in the application is as described in the ‘Values’ heading below.          IMPACT: This key basically assists in managing the display of the section and data within the section.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of the header and data grid of Allergies section. If the client is not having any data for the section, then this table will show as “No Information Available”. If data exists (allergies are recorded), then it will display data with details.  N– This value disables this section and the header and the data grid is hidden and will be not part of the generated PDF/XML report.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'ClinicalSummary'
		   ,Screens= '939'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowClinicalSummaryGoalsObjectives';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowClinicalSummaryProcedureDuringVisit') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowClinicalSummaryProcedureDuringVisit' 
				,'Y,N'
				,'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary is one of the 13 core measures which are mandatory to be fulfilled.  The objective as stated is to “Provide clinical summaries for patients for each office visit”. In SmartCare, we have added function with icon named as ‘CS’ and this icon is part of the tool bar on ‘Services’ and ‘Service Notes’ screen. On the click of the icon, the application creates PDF/XML Report.  The Clinical Summary PDF/XML has 19 sections as part of the report. All these 19 sections are individual keys in the SystemConfigurationKeys table.     In this case, the name of the section is ‘Procedure/Interventions Performed During Visit’ and the name of the key is ‘ShowClinicalSummaryProcedureDuringVisit’. The display of ‘Procedure/Interventions Performed During Visit’ section/segment in the application is as described in the ‘Values’ heading below.          IMPACT: This key basically assists in managing the display of the section and data within the section.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of the header and data grid of Allergies section. If the client is not having any data for the section, then this table will show as “No Information Available”. If data exists (allergies are recorded), then it will display data with details.  N– This value disables this section and the header and the data grid is hidden and will be not part of the generated PDF/XML report.'
				,'N' 
				,'ClinicalSummary'
				,'939'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary is one of the 13 core measures which are mandatory to be fulfilled.  The objective as stated is to “Provide clinical summaries for patients for each office visit”. In SmartCare, we have added function with icon named as ‘CS’ and this icon is part of the tool bar on ‘Services’ and ‘Service Notes’ screen. On the click of the icon, the application creates PDF/XML Report.  The Clinical Summary PDF/XML has 19 sections as part of the report. All these 19 sections are individual keys in the SystemConfigurationKeys table.     In this case, the name of the section is ‘Procedure/Interventions Performed During Visit’ and the name of the key is ‘ShowClinicalSummaryProcedureDuringVisit’. The display of ‘Procedure/Interventions Performed During Visit’ section/segment in the application is as described in the ‘Values’ heading below.          IMPACT: This key basically assists in managing the display of the section and data within the section.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of the header and data grid of Allergies section. If the client is not having any data for the section, then this table will show as “No Information Available”. If data exists (allergies are recorded), then it will display data with details.  N– This value disables this section and the header and the data grid is hidden and will be not part of the generated PDF/XML report.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'ClinicalSummary'
		   ,Screens= '939'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowClinicalSummaryProcedureDuringVisit';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowClinicalSummaryOrderPending') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowClinicalSummaryOrderPending' 
				,'Y,N'
				,'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary is one of the 13 core measures which are mandatory to be fulfilled.  The objective as stated is to “Provide clinical summaries for patients for each office visit”. In SmartCare, we have added function with icon named as ‘CS’ and this icon is part of the tool bar on ‘Services’ and ‘Service Notes’ screen. On the click of the icon, the application creates PDF/XML Report.  The Clinical Summary PDF/XML has 19 sections as part of the report. All these 19 sections are individual keys in the SystemConfigurationKeys table.     In this case, the name of the section is ‘Orders/Tests Initiated/Pending During Visit’ and the name of the key is ‘ShowClinicalSummaryOrderPending’. The display of ‘Orders/Tests Initiated/Pending During Visit’ section/segment in the application is as described in the ‘Values’ heading below.          IMPACT: This key basically assists in managing the display of the section and data within the section.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of the header and data grid of Allergies section. If the client is not having any data for the section, then this table will show as “No Information Available”. If data exists (allergies are recorded), then it will display data with details.  N– This value disables this section and the header and the data grid is hidden and will be not part of the generated PDF/XML report.'
				,'N' 
				,'ClinicalSummary'
				,'939'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary is one of the 13 core measures which are mandatory to be fulfilled.  The objective as stated is to “Provide clinical summaries for patients for each office visit”. In SmartCare, we have added function with icon named as ‘CS’ and this icon is part of the tool bar on ‘Services’ and ‘Service Notes’ screen. On the click of the icon, the application creates PDF/XML Report.  The Clinical Summary PDF/XML has 19 sections as part of the report. All these 19 sections are individual keys in the SystemConfigurationKeys table.     In this case, the name of the section is ‘Orders/Tests Initiated/Pending During Visit’ and the name of the key is ‘ShowClinicalSummaryOrderPending’. The display of ‘Orders/Tests Initiated/Pending During Visit’ section/segment in the application is as described in the ‘Values’ heading below.          IMPACT: This key basically assists in managing the display of the section and data within the section.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of the header and data grid of Allergies section. If the client is not having any data for the section, then this table will show as “No Information Available”. If data exists (allergies are recorded), then it will display data with details.  N– This value disables this section and the header and the data grid is hidden and will be not part of the generated PDF/XML report.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'ClinicalSummary'
		   ,Screens= '939'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowClinicalSummaryOrderPending';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowClinicalSummaryCareTeam') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowClinicalSummaryCareTeam' 
				,'Y,N'
				,'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary is one of the 13 core measures which are mandatory to be fulfilled.  The objective as stated is to “Provide clinical summaries for patients for each office visit”. In SmartCare, we have added function with icon named as ‘CS’ and this icon is part of the tool bar on ‘Services’ and ‘Service Notes’ screen. On the click of the icon, the application creates PDF/XML Report.  The Clinical Summary PDF/XML has 19 sections as part of the report. All these 19 sections are individual keys in the SystemConfigurationKeys table.     In this case, the name of the section is ‘Participants/Care Team’ and the name of the key is ‘ShowClinicalSummaryCareTeam’. The display of ‘Participants/Care Team’ section/segment in the application is as described in the ‘Values’ heading below.          IMPACT: This key basically assists in managing the display of the section and data within the section.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of the header and data grid of Allergies section. If the client is not having any data for the section, then this table will show as “No Information Available”. If data exists (allergies are recorded), then it will display data with details.  N– This value disables this section and the header and the data grid is hidden and will be not part of the generated PDF/XML report.'
				,'N' 
				,'ClinicalSummary'
				,'939'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary is one of the 13 core measures which are mandatory to be fulfilled.  The objective as stated is to “Provide clinical summaries for patients for each office visit”. In SmartCare, we have added function with icon named as ‘CS’ and this icon is part of the tool bar on ‘Services’ and ‘Service Notes’ screen. On the click of the icon, the application creates PDF/XML Report.  The Clinical Summary PDF/XML has 19 sections as part of the report. All these 19 sections are individual keys in the SystemConfigurationKeys table.     In this case, the name of the section is ‘Participants/Care Team’ and the name of the key is ‘ShowClinicalSummaryCareTeam’. The display of ‘Participants/Care Team’ section/segment in the application is as described in the ‘Values’ heading below.          IMPACT: This key basically assists in managing the display of the section and data within the section.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of the header and data grid of Allergies section. If the client is not having any data for the section, then this table will show as “No Information Available”. If data exists (allergies are recorded), then it will display data with details.  N– This value disables this section and the header and the data grid is hidden and will be not part of the generated PDF/XML report.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'ClinicalSummary'
		   ,Screens= '939'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowClinicalSummaryCareTeam';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'EnableClinicalSummaryIcon') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('EnableClinicalSummaryIcon' 
				,'Y'
				,'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary is one of the 13 core measures which are mandatory to be fulfilled. The objective as stated is to “Provide clinical summaries for patients for each office visit”. In SmartCare, we have added function with icon named as ‘CS’ and this icon is part of the tool bar on ‘Services’ and ‘Service Notes’ screens. This key helps in displaying the ‘CS’ Icon if the value is set to ‘Y’. If the value is ‘N’ or ‘Null’, this icon will be not displayed on tool bar of Service Notes screen.        IMPACT: As part of the Meaningful Use compliance this feature is introduced, and it has 19 sections in the report.  These sections are configurable either to be included in or excluded from the report. This report can be downloaded either in the PDF format or XML.        VALUE: There are 2 values which will enable or disable this feature. Y – This value enables the display of the ‘CS’ icon in ‘Service’ and ‘Service Notes’ tool bar. N/NULL – This value disables this feature and the icon will not be visible in ‘Service’ and ‘Service Notes’ tool bar.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y'
		   ,[Description]= 'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary is one of the 13 core measures which are mandatory to be fulfilled. The objective as stated is to “Provide clinical summaries for patients for each office visit”. In SmartCare, we have added function with icon named as ‘CS’ and this icon is part of the tool bar on ‘Services’ and ‘Service Notes’ screens. This key helps in displaying the ‘CS’ Icon if the value is set to ‘Y’. If the value is ‘N’ or ‘Null’, this icon will be not displayed on tool bar of Service Notes screen.        IMPACT: As part of the Meaningful Use compliance this feature is introduced, and it has 19 sections in the report.  These sections are configurable either to be included in or excluded from the report. This report can be downloaded either in the PDF format or XML.        VALUE: There are 2 values which will enable or disable this feature. Y – This value enables the display of the ‘CS’ icon in ‘Service’ and ‘Service Notes’ tool bar. N/NULL – This value disables this feature and the icon will not be visible in ‘Service’ and ‘Service Notes’ tool bar.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='EnableClinicalSummaryIcon';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowTransitionCareSummaryGeneralInfo') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowTransitionCareSummaryGeneralInfo' 
				,'Y,N'
				,'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary report is one of the 9 menu set measures which is mandatory to be fulfilled.  The objective as stated is to “The EP who transitions their patient to another setting of care or provider of care or refers their patient to another provider of care should provide summary care record for each transition of care or referral”. In SmartCare, we have added function with icon named as ‘SC’ and this icon is part of the tool bar on the document “Summary of Care” screen. On the click of the icon, the application creates PDF/XML Report.    The Summary of Care PDF/XML has 14 sections as part of the report. The section name ‘General Information’   in the key is also one of them and this key configuration helps in either showing or hiding this section in the report.            IMPACT: If client does not have related data for the section, the system currently displays “No Information Available” on the generated PDF.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of ‘General Information’ section.  N – Disables this section and will be not part of the generated PDF/XML report.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary report is one of the 9 menu set measures which is mandatory to be fulfilled.  The objective as stated is to “The EP who transitions their patient to another setting of care or provider of care or refers their patient to another provider of care should provide summary care record for each transition of care or referral”. In SmartCare, we have added function with icon named as ‘SC’ and this icon is part of the tool bar on the document “Summary of Care” screen. On the click of the icon, the application creates PDF/XML Report.    The Summary of Care PDF/XML has 14 sections as part of the report. The section name ‘General Information’   in the key is also one of them and this key configuration helps in either showing or hiding this section in the report.            IMPACT: If client does not have related data for the section, the system currently displays “No Information Available” on the generated PDF.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of ‘General Information’ section.  N – Disables this section and will be not part of the generated PDF/XML report.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowTransitionCareSummaryGeneralInfo';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowTransitionCareSummaryClientInfo') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowTransitionCareSummaryClientInfo' 
				,'Y,N'
				,'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary report is one of the 9 menu set measures which is mandatory to be fulfilled.  The objective as stated is to “The EP who transitions their patient to another setting of care or provider of care or refers their patient to another provider of care should provide summary care record for each transition of care or referral”. In SmartCare, we have added function with icon named as ‘SC’ and this icon is part of the tool bar on the document “Summary of Care” screen. On the click of the icon, the application creates PDF/XML Report.    The Summary of Care PDF/XML has 14 sections as part of the report. The section name ‘Client Information’   in the key is also one of them and this key configuration helps in either showing or hiding this section in the report.            IMPACT: If client does not have related data for the section, the system currently displays “No Information Available” on the generated PDF.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of ‘Client Information’ section.  N – Disables this section and will be not part of the generated PDF/XML report.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary report is one of the 9 menu set measures which is mandatory to be fulfilled.  The objective as stated is to “The EP who transitions their patient to another setting of care or provider of care or refers their patient to another provider of care should provide summary care record for each transition of care or referral”. In SmartCare, we have added function with icon named as ‘SC’ and this icon is part of the tool bar on the document “Summary of Care” screen. On the click of the icon, the application creates PDF/XML Report.    The Summary of Care PDF/XML has 14 sections as part of the report. The section name ‘Client Information’   in the key is also one of them and this key configuration helps in either showing or hiding this section in the report.            IMPACT: If client does not have related data for the section, the system currently displays “No Information Available” on the generated PDF.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of ‘Client Information’ section.  N – Disables this section and will be not part of the generated PDF/XML report.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowTransitionCareSummaryClientInfo';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowTransitionCareSummaryCareTeam') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowTransitionCareSummaryCareTeam' 
				,'Y,N'
				,'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary report is one of the 9 menu set measures which is mandatory to be fulfilled.  The objective as stated is to “The EP who transitions their patient to another setting of care or provider of care or refers their patient to another provider of care should provide summary care record for each transition of care or referral”. In SmartCare, we have added function with icon named as ‘SC’ and this icon is part of the tool bar on the document “Summary of Care” screen. On the click of the icon, the application creates PDF/XML Report.    The Summary of Care PDF/XML has 14 sections as part of the report. The section name ‘Participants/Care Team’   in the key is also one of them and this key configuration helps in either showing or hiding this section in the report.            IMPACT: If client does not have related data for the section, the system currently displays “No Information Available” on the generated PDF.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of ‘Participants/Care Team’ section.  N – Disables this section and will be not part of the generated PDF/XML report.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary report is one of the 9 menu set measures which is mandatory to be fulfilled.  The objective as stated is to “The EP who transitions their patient to another setting of care or provider of care or refers their patient to another provider of care should provide summary care record for each transition of care or referral”. In SmartCare, we have added function with icon named as ‘SC’ and this icon is part of the tool bar on the document “Summary of Care” screen. On the click of the icon, the application creates PDF/XML Report.    The Summary of Care PDF/XML has 14 sections as part of the report. The section name ‘Participants/Care Team’   in the key is also one of them and this key configuration helps in either showing or hiding this section in the report.            IMPACT: If client does not have related data for the section, the system currently displays “No Information Available” on the generated PDF.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of ‘Participants/Care Team’ section.  N – Disables this section and will be not part of the generated PDF/XML report.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowTransitionCareSummaryCareTeam';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowTransitionCareSummaryDiagnosis') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowTransitionCareSummaryDiagnosis' 
				,'Y,N'
				,'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary report is one of the 9 menu set measures which is mandatory to be fulfilled.  The objective as stated is to “The EP who transitions their patient to another setting of care or provider of care or refers their patient to another provider of care should provide summary care record for each transition of care or referral”. In SmartCare, we have added function with icon named as ‘SC’ and this icon is part of the tool bar on the document “Summary of Care” screen. On the click of the icon, the application creates PDF/XML Report.    The Summary of Care PDF/XML has 14 sections as part of the report. The section name ‘General Information’   in the key is also one of them and this key configuration helps in either showing or hiding this section in the report.            IMPACT: If client does not have related data for the section, the system currently displays “No Information Available” on the generated PDF.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of ‘General Information’ section.  N – Disables this section and will be not part of the generated PDF/XML report.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary report is one of the 9 menu set measures which is mandatory to be fulfilled.  The objective as stated is to “The EP who transitions their patient to another setting of care or provider of care or refers their patient to another provider of care should provide summary care record for each transition of care or referral”. In SmartCare, we have added function with icon named as ‘SC’ and this icon is part of the tool bar on the document “Summary of Care” screen. On the click of the icon, the application creates PDF/XML Report.    The Summary of Care PDF/XML has 14 sections as part of the report. The section name ‘General Information’   in the key is also one of them and this key configuration helps in either showing or hiding this section in the report.            IMPACT: If client does not have related data for the section, the system currently displays “No Information Available” on the generated PDF.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of ‘General Information’ section.  N – Disables this section and will be not part of the generated PDF/XML report.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowTransitionCareSummaryDiagnosis';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowTransitionCareSummaryVitals') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowTransitionCareSummaryVitals' 
				,'Y,N'
				,'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary report is one of the 9 menu set measures which is mandatory to be fulfilled.  The objective as stated is to “The EP who transitions their patient to another setting of care or provider of care or refers their patient to another provider of care should provide summary care record for each transition of care or referral”. In SmartCare, we have added function with icon named as ‘SC’ and this icon is part of the tool bar on the document “Summary of Care” screen. On the click of the icon, the application creates PDF/XML Report.    The Summary of Care PDF/XML has 14 sections as part of the report. The section name ‘Vital Signs’   in the key is also one of them and this key configuration helps in either showing or hiding this section in the report.      IMPACT: If client does not have related data for the section, the system currently displays “No Information Available” on the generated PDF.    VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of ‘Vital Signs’section.  N – Disables this section and will be not part of the generated PDF/XML report.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary report is one of the 9 menu set measures which is mandatory to be fulfilled.  The objective as stated is to “The EP who transitions their patient to another setting of care or provider of care or refers their patient to another provider of care should provide summary care record for each transition of care or referral”. In SmartCare, we have added function with icon named as ‘SC’ and this icon is part of the tool bar on the document “Summary of Care” screen. On the click of the icon, the application creates PDF/XML Report.    The Summary of Care PDF/XML has 14 sections as part of the report. The section name ‘Vital Signs’   in the key is also one of them and this key configuration helps in either showing or hiding this section in the report.      IMPACT: If client does not have related data for the section, the system currently displays “No Information Available” on the generated PDF.    VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of ‘Vital Signs’section.  N – Disables this section and will be not part of the generated PDF/XML report.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowTransitionCareSummaryVitals';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowTransitionCareSummaryAllergies') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowTransitionCareSummaryAllergies' 
				,'Y,N'
				,'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary report is one of the 9 menu set measures which is mandatory to be fulfilled.  The objective as stated is to “The EP who transitions their patient to another setting of care or provider of care or refers their patient to another provider of care should provide summary care record for each transition of care or referral”. In SmartCare, we have added function with icon named as ‘SC’ and this icon is part of the tool bar on the document “Summary of Care” screen. On the click of the icon, the application creates PDF/XML Report.    The Summary of Care PDF/XML has 14 sections as part of the report. The section name Allergies in the key is also one of them and this key configuration helps in either showing or hiding this section in the report.            IMPACT: If client does not have related data for the section, the system currently displays “No Information Available” on the generated PDF.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of ‘Allergies’ section.  N – Disables this section and will be not part of the generated PDF/XML report.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary report is one of the 9 menu set measures which is mandatory to be fulfilled.  The objective as stated is to “The EP who transitions their patient to another setting of care or provider of care or refers their patient to another provider of care should provide summary care record for each transition of care or referral”. In SmartCare, we have added function with icon named as ‘SC’ and this icon is part of the tool bar on the document “Summary of Care” screen. On the click of the icon, the application creates PDF/XML Report.    The Summary of Care PDF/XML has 14 sections as part of the report. The section name Allergies in the key is also one of them and this key configuration helps in either showing or hiding this section in the report.            IMPACT: If client does not have related data for the section, the system currently displays “No Information Available” on the generated PDF.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of ‘Allergies’ section.  N – Disables this section and will be not part of the generated PDF/XML report.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowTransitionCareSummaryAllergies';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowTransitionCareSummarySmokingStatus') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowTransitionCareSummarySmokingStatus' 
				,'Y,N'
				,'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary report is one of the 9 menu set measures which is mandatory to be fulfilled.  The objective as stated is to “The EP who transitions their patient to another setting of care or provider of care or refers their patient to another provider of care should provide summary care record for each transition of care or referral”. In SmartCare, we have added function with icon named as ‘SC’ and this icon is part of the tool bar on the document “Summary of Care” screen. On the click of the icon, the application creates PDF/XML Report.    The Summary of Care PDF/XML has 14 sections as part of the report. The section name ‘Smoking Status’   in the key is also one of them and this key configuration helps in either showing or hiding this section in the report.      IMPACT: If client does not have related data for the section, the system currently displays “No Information Available” on the generated PDF.    VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of ‘Smoking Status’ section.  N – Disables this section and will be not part of the generated PDF/XML report.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary report is one of the 9 menu set measures which is mandatory to be fulfilled.  The objective as stated is to “The EP who transitions their patient to another setting of care or provider of care or refers their patient to another provider of care should provide summary care record for each transition of care or referral”. In SmartCare, we have added function with icon named as ‘SC’ and this icon is part of the tool bar on the document “Summary of Care” screen. On the click of the icon, the application creates PDF/XML Report.    The Summary of Care PDF/XML has 14 sections as part of the report. The section name ‘Smoking Status’   in the key is also one of them and this key configuration helps in either showing or hiding this section in the report.      IMPACT: If client does not have related data for the section, the system currently displays “No Information Available” on the generated PDF.    VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of ‘Smoking Status’ section.  N – Disables this section and will be not part of the generated PDF/XML report.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowTransitionCareSummarySmokingStatus';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowTransitionCareSummaryCurrentMedication') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowTransitionCareSummaryCurrentMedication' 
				,'Y,N'
				,'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary report is one of the 9 menu set measures which is mandatory to be fulfilled.  The objective as stated is to “The EP who transitions their patient to another setting of care or provider of care or refers their patient to another provider of care should provide summary care record for each transition of care or referral”. In SmartCare, we have added function with icon named as ‘SC’ and this icon is part of the tool bar on the document “Summary of Care” screen. On the click of the icon, the application creates PDF/XML Report.    The Summary of Care PDF/XML has 14 sections as part of the report. The section name ‘Current Medications’   in the key is also one of them and this key configuration helps in either showing or hiding this section in the report.            IMPACT: If client does not have related data for the section, the system currently displays “No Information Available” on the generated PDF.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of ‘Current Medications’section.  N – Disables this section and will be not part of the generated PDF/XML report.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary report is one of the 9 menu set measures which is mandatory to be fulfilled.  The objective as stated is to “The EP who transitions their patient to another setting of care or provider of care or refers their patient to another provider of care should provide summary care record for each transition of care or referral”. In SmartCare, we have added function with icon named as ‘SC’ and this icon is part of the tool bar on the document “Summary of Care” screen. On the click of the icon, the application creates PDF/XML Report.    The Summary of Care PDF/XML has 14 sections as part of the report. The section name ‘Current Medications’   in the key is also one of them and this key configuration helps in either showing or hiding this section in the report.            IMPACT: If client does not have related data for the section, the system currently displays “No Information Available” on the generated PDF.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of ‘Current Medications’section.  N – Disables this section and will be not part of the generated PDF/XML report.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowTransitionCareSummaryCurrentMedication';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowTransitionCareSummaryImmunizations') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowTransitionCareSummaryImmunizations' 
				,'Y,N'
				,'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary report is one of the 9 menu set measures which is mandatory to be fulfilled.  The objective as stated is to “The EP who transitions their patient to another setting of care or provider of care or refers their patient to another provider of care should provide summary care record for each transition of care or referral”. In SmartCare, we have added function with icon named as ‘SC’ and this icon is part of the tool bar on the document “Summary of Care” screen. On the click of the icon, the application creates PDF/XML Report.    The Summary of Care PDF/XML has 14 sections as part of the report. The section name ‘Immunizations’   in the key is also one of them and this key configuration helps in either showing or hiding this section in the report.            IMPACT: If client does not have related data for the section, the system currently displays “No Information Available” on the generated PDF.    VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of ‘Immunizations’ section.  N – Disables this section and will be not part of the generated PDF/XML report.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary report is one of the 9 menu set measures which is mandatory to be fulfilled.  The objective as stated is to “The EP who transitions their patient to another setting of care or provider of care or refers their patient to another provider of care should provide summary care record for each transition of care or referral”. In SmartCare, we have added function with icon named as ‘SC’ and this icon is part of the tool bar on the document “Summary of Care” screen. On the click of the icon, the application creates PDF/XML Report.    The Summary of Care PDF/XML has 14 sections as part of the report. The section name ‘Immunizations’   in the key is also one of them and this key configuration helps in either showing or hiding this section in the report.            IMPACT: If client does not have related data for the section, the system currently displays “No Information Available” on the generated PDF.    VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of ‘Immunizations’ section.  N – Disables this section and will be not part of the generated PDF/XML report.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowTransitionCareSummaryImmunizations';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowTransitionCareSummaryRadiologyResultReviewed') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowTransitionCareSummaryRadiologyResultReviewed' 
				,'Y,N'
				,'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary report is one of the 9 menu set measures which is mandatory to be fulfilled.  The objective as stated is to “The EP who transitions their patient to another setting of care or provider of care or refers their patient to another provider of care should provide summary care record for each transition of care or referral”. In SmartCare, we have added function with icon named as ‘SC’ and this icon is part of the tool bar on the document “Summary of Care” screen. On the click of the icon, the application creates PDF/XML Report.    The Summary of Care PDF/XML has 14 sections as part of the report. The section name ‘Lab/Radiology Results - Ordered in Past 6 Months’   in the key is also one of them and this key configuration helps in either showing or hiding this section in the report.            IMPACT: If client does not have related data for the section, the system currently displays “No Information Available” on the generated PDF.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of ‘Lab/Radiology Results - Ordered in Past 6 Months’ section.  N – Disables this section and will be not part of the generated PDF/XML report.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary report is one of the 9 menu set measures which is mandatory to be fulfilled.  The objective as stated is to “The EP who transitions their patient to another setting of care or provider of care or refers their patient to another provider of care should provide summary care record for each transition of care or referral”. In SmartCare, we have added function with icon named as ‘SC’ and this icon is part of the tool bar on the document “Summary of Care” screen. On the click of the icon, the application creates PDF/XML Report.    The Summary of Care PDF/XML has 14 sections as part of the report. The section name ‘Lab/Radiology Results - Ordered in Past 6 Months’   in the key is also one of them and this key configuration helps in either showing or hiding this section in the report.            IMPACT: If client does not have related data for the section, the system currently displays “No Information Available” on the generated PDF.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of ‘Lab/Radiology Results - Ordered in Past 6 Months’ section.  N – Disables this section and will be not part of the generated PDF/XML report.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowTransitionCareSummaryRadiologyResultReviewed';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowTransitionCareSummaryMostRecentLevelofFunctioning') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowTransitionCareSummaryMostRecentLevelofFunctioning' 
				,'Y,N'
				,'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary report is one of the 9 menu set measures which is mandatory to be fulfilled.  The objective as stated is to “The EP who transitions their patient to another setting of care or provider of care or refers their patient to another provider of care should provide summary care record for each transition of care or referral”. In SmartCare, we have added function with icon named as ‘SC’ and this icon is part of the tool bar on the document “Summary of Care” screen. On the click of the icon, the application creates PDF/XML Report.    The Summary of Care PDF/XML has 14 sections as part of the report. The section name ‘Most Recent Level of Functioning’   in the key is also one of them and this key configuration helps in either showing or hiding this section in the report.            IMPACT: If client does not have related data for the section, the system currently displays “No Information Available” on the generated PDF.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of ‘Most Recent Level of Functioning’ section.  N – Disables this section and will be not part of the generated PDF/XML report.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary report is one of the 9 menu set measures which is mandatory to be fulfilled.  The objective as stated is to “The EP who transitions their patient to another setting of care or provider of care or refers their patient to another provider of care should provide summary care record for each transition of care or referral”. In SmartCare, we have added function with icon named as ‘SC’ and this icon is part of the tool bar on the document “Summary of Care” screen. On the click of the icon, the application creates PDF/XML Report.    The Summary of Care PDF/XML has 14 sections as part of the report. The section name ‘Most Recent Level of Functioning’   in the key is also one of them and this key configuration helps in either showing or hiding this section in the report.            IMPACT: If client does not have related data for the section, the system currently displays “No Information Available” on the generated PDF.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of ‘Most Recent Level of Functioning’ section.  N – Disables this section and will be not part of the generated PDF/XML report.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowTransitionCareSummaryMostRecentLevelofFunctioning';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowTransitionCareSummaryReasonforReferral') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowTransitionCareSummaryReasonforReferral' 
				,'Y,N'
				,'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary report is one of the 9 menu set measures which is mandatory to be fulfilled.  The objective as stated is to “The EP who transitions their patient to another setting of care or provider of care or refers their patient to another provider of care should provide summary care record for each transition of care or referral”. In SmartCare, we have added function with icon named as ‘SC’ and this icon is part of the tool bar on the document “Summary of Care” screen. On the click of the icon, the application creates PDF/XML Report.    The Summary of Care PDF/XML has 14 sections as part of the report. The section name  ‘Reason for Referral’   in the key is also one of them and this key configuration helps in either showing or hiding this section in the report.            IMPACT: If client does not have related data for the section, the system currently displays “No Information Available” on the generated PDF.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of ‘Reason for Referral’ section.  N – Disables this section and will be not part of the generated PDF/XML report.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary report is one of the 9 menu set measures which is mandatory to be fulfilled.  The objective as stated is to “The EP who transitions their patient to another setting of care or provider of care or refers their patient to another provider of care should provide summary care record for each transition of care or referral”. In SmartCare, we have added function with icon named as ‘SC’ and this icon is part of the tool bar on the document “Summary of Care” screen. On the click of the icon, the application creates PDF/XML Report.    The Summary of Care PDF/XML has 14 sections as part of the report. The section name  ‘Reason for Referral’   in the key is also one of them and this key configuration helps in either showing or hiding this section in the report.            IMPACT: If client does not have related data for the section, the system currently displays “No Information Available” on the generated PDF.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of ‘Reason for Referral’ section.  N – Disables this section and will be not part of the generated PDF/XML report.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowTransitionCareSummaryReasonforReferral';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/
IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowTransitionCareSummaryGoalsObjectives') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowTransitionCareSummaryGoalsObjectives' 
				,'Y,N'
				,'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary report is one of the 9 menu set measures which is mandatory to be fulfilled.  The objective as stated is to “The EP who transitions their patient to another setting of care or provider of care or refers their patient to another provider of care should provide summary care record for each transition of care or referral”. In SmartCare, we have added function with icon named as ‘SC’ and this icon is part of the tool bar on the document “Summary of Care” screen. On the click of the icon, the application creates PDF/XML Report.    The Summary of Care PDF/XML has 14 sections as part of the report. The section name ‘Plan of Care’   in the key is also one of them and this key configuration helps in either showing or hiding this section in the report.            IMPACT: If client does not have related data for the section, the system currently displays “No Information Available” on the generated PDF.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of ‘Plan of Care’section.  N – Disables this section and will be not part of the generated PDF/XML report.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary report is one of the 9 menu set measures which is mandatory to be fulfilled.  The objective as stated is to “The EP who transitions their patient to another setting of care or provider of care or refers their patient to another provider of care should provide summary care record for each transition of care or referral”. In SmartCare, we have added function with icon named as ‘SC’ and this icon is part of the tool bar on the document “Summary of Care” screen. On the click of the icon, the application creates PDF/XML Report.    The Summary of Care PDF/XML has 14 sections as part of the report. The section name ‘Plan of Care’   in the key is also one of them and this key configuration helps in either showing or hiding this section in the report.            IMPACT: If client does not have related data for the section, the system currently displays “No Information Available” on the generated PDF.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of ‘Plan of Care’section.  N – Disables this section and will be not part of the generated PDF/XML report.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowTransitionCareSummaryGoalsObjectives';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowTransitionCareSummaryProcedure') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowTransitionCareSummaryProcedure' 
				,'Y,N'
				,'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary report is one of the 9 menu set measures which is mandatory to be fulfilled.  The objective as stated is to “The EP who transitions their patient to another setting of care or provider of care or refers their patient to another provider of care should provide summary care record for each transition of care or referral”. In SmartCare, we have added function with icon named as ‘SC’ and this icon is part of the tool bar on the document “Summary of Care” screen. On the click of the icon, the application creates PDF/XML Report.    The Summary of Care PDF/XML has 14 sections as part of the report. The section name ‘Procedures’   in the key is also one of them and this key configuration helps in either showing or hiding this section in the report.            IMPACT: If client does not have related data for the section, the system currently displays “No Information Available” on the generated PDF.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of ‘Procedures’ section.  N – Disables this section and will be not part of the generated PDF/XML report.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'As part of the compliance on Meaningful Use Stage 1, the Clinical Summary report is one of the 9 menu set measures which is mandatory to be fulfilled.  The objective as stated is to “The EP who transitions their patient to another setting of care or provider of care or refers their patient to another provider of care should provide summary care record for each transition of care or referral”. In SmartCare, we have added function with icon named as ‘SC’ and this icon is part of the tool bar on the document “Summary of Care” screen. On the click of the icon, the application creates PDF/XML Report.    The Summary of Care PDF/XML has 14 sections as part of the report. The section name ‘Procedures’   in the key is also one of them and this key configuration helps in either showing or hiding this section in the report.            IMPACT: If client does not have related data for the section, the system currently displays “No Information Available” on the generated PDF.          VALUE: There are 2 values which will enable or disable this feature.  Y /NULL – This value enables the display of ‘Procedures’ section.  N – Disables this section and will be not part of the generated PDF/XML report.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowTransitionCareSummaryProcedure';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'LabsWidgetLookbackMonths') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('LabsWidgetLookbackMonths' 
				,'1,2,3'
				,'This widget is part of the Dashboard named as “Lab Result”. This widget shows the lab results in the grid. As per this configuration, we can configure how many prior months results are required to be shown.      IMPACT: Based on the value set for this key, the ''Lab Result'' widget lists values for those many prior months. If more records are there, then the scroll bar appears.      VALUE: The value of this key is the number of prior months that the user wants to view results. For instance, if the value is ‘3’, then 3 prior months lab results will be listed in the widget.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = '1,2,3'
		   ,[Description]= 'This widget is part of the Dashboard named as “Lab Result”. This widget shows the lab results in the grid. As per this configuration, we can configure how many prior months results are required to be shown.      IMPACT: Based on the value set for this key, the ''Lab Result'' widget lists values for those many prior months. If more records are there, then the scroll bar appears.      VALUE: The value of this key is the number of prior months that the user wants to view results. For instance, if the value is ‘3’, then 3 prior months lab results will be listed in the widget.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='LabsWidgetLookbackMonths';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ALWAYSREQUIREDIAGNOSISONSERVICE') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ALWAYSREQUIREDIAGNOSISONSERVICE' 
				,'Y,N'
				,'This key helps in making the Diagnosis code mandatory before the service is marked as ‘Complete’. Here is the background. Charging of the billable services goes through these service statuses -- Scheduled, Show and Complete. Once it is marked as complete, the bill can be generated for that service. If the bill is getting paid by the insurance company, the Diagnosis code is mandatory.        IMPACT: This key makes the diagnosis code mandatory for all the services. If the Diagnosis code is not captured when the service is marked for completion (i.e, when ‘Complete’ drop-down is selected), then the following alert is displayed – “Billing diagnosis code required for completing the service”.        VALUE: There are 2 values which will enable or disable this feature. Y/Null – This value makes it mandatory for the user to enter diagnosis code before updating the status of a service to ‘Complete’. If the diagnosis code is not available, then application alerts with message “Billing diagnosis code required for completing the service”. N – This value does not check the Diagnosis code rule and allows completing the service without the diagnosis code.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'This key helps in making the Diagnosis code mandatory before the service is marked as ‘Complete’. Here is the background. Charging of the billable services goes through these service statuses -- Scheduled, Show and Complete. Once it is marked as complete, the bill can be generated for that service. If the bill is getting paid by the insurance company, the Diagnosis code is mandatory.        IMPACT: This key makes the diagnosis code mandatory for all the services. If the Diagnosis code is not captured when the service is marked for completion (i.e, when ‘Complete’ drop-down is selected), then the following alert is displayed – “Billing diagnosis code required for completing the service”.        VALUE: There are 2 values which will enable or disable this feature. Y/Null – This value makes it mandatory for the user to enter diagnosis code before updating the status of a service to ‘Complete’. If the diagnosis code is not available, then application alerts with message “Billing diagnosis code required for completing the service”. N – This value does not check the Diagnosis code rule and allows completing the service without the diagnosis code.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ALWAYSREQUIREDIAGNOSISONSERVICE';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'CustomLogoPath') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('CustomLogoPath' 
				,'App_Themes/Includes/Images/Logo.gif'
				,'This key provides an option to the customer site to display their logo in the Login screen of the application. This value in this key is the logo that gets displayed in the Login screen. This logo appears in both Patient Portal and User Portal login screens.  All types of images are supported in the login page.        IMPACT: This image is displayed only on the login screen and will not be used in any other function.        VALUE: The Value for this key is the image path from the server. App_Themes/Includes/Images/Logo.gif If the value is blank, a default blank image (‘X’ mark) is displayed.'
				,'N' 
				,'Login Screen'
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'App_Themes/Includes/Images/Logo.gif'
		   ,[Description]= 'This key provides an option to the customer site to display their logo in the Login screen of the application. This value in this key is the logo that gets displayed in the Login screen. This logo appears in both Patient Portal and User Portal login screens.  All types of images are supported in the login page.        IMPACT: This image is displayed only on the login screen and will not be used in any other function.        VALUE: The Value for this key is the image path from the server. App_Themes/Includes/Images/Logo.gif If the value is blank, a default blank image (‘X’ mark) is displayed.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Login Screen'
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='CustomLogoPath';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ALLOWNEGATIVEPAYMENTBALANCE') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ALLOWNEGATIVEPAYMENTBALANCE' 
				,'Y,N,NA'
				,'This key configuration helps in controlling the update of payments which will cause the negative payment. The scenario is explained below.  Let us say that the bill is raised to payer and the hospital receives the payment through EOB [Explanation of Benefit]. Now, either the user will import the EOB directly or it can be posted manually using the function “Payment/Adjustment Posting” from ‘My Office’ tab.  Once the Payment amount is added for a payer or plan, the balance will increase. This balance is adjusted with services. On the selection of the services through service search, the services will appear for adjustment where the amount is allocated for each service and updated. If the payment made is more than the balance amount then the balance becomes negative amount.           IMPACT: Depending upon hospital requirements, this alert is set. Disabling this feature will help hospital in avoiding negative balance and any wrong payment posting over and above the payments received.          VALUE: There are 2 Values which will enable or disable this feature.  Y – Negative balance is allowed.  N/Null – This value will disallow allocating payment that will cause negative balance. An alert is shown on the screen stating ‘You may not enter an amount that would make the balance negative’.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N,NA'
		   ,[Description]= 'This key configuration helps in controlling the update of payments which will cause the negative payment. The scenario is explained below.  Let us say that the bill is raised to payer and the hospital receives the payment through EOB [Explanation of Benefit]. Now, either the user will import the EOB directly or it can be posted manually using the function “Payment/Adjustment Posting” from ‘My Office’ tab.  Once the Payment amount is added for a payer or plan, the balance will increase. This balance is adjusted with services. On the selection of the services through service search, the services will appear for adjustment where the amount is allocated for each service and updated. If the payment made is more than the balance amount then the balance becomes negative amount.           IMPACT: Depending upon hospital requirements, this alert is set. Disabling this feature will help hospital in avoiding negative balance and any wrong payment posting over and above the payments received.          VALUE: There are 2 Values which will enable or disable this feature.  Y – Negative balance is allowed.  N/Null – This value will disallow allocating payment that will cause negative balance. An alert is shown on the screen stating ‘You may not enter an amount that would make the balance negative’.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ALLOWNEGATIVEPAYMENTBALANCE';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'USEPATIENTPORTAL') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('USEPATIENTPORTAL' 
				,'Y,N'
				,'The Smartcare Application has the option for patient login where patients can login and view their medical information if required credentials (user/password) and permissions (respective reports) are granted by the hospital. If this is enabled (Y), all patients having access to the portal can login and view specific documents and data as per the permission given by the provider. In a scenario where this key is disabled (N or NULL), then after entering user/password information and clicking on ‘Login’ button, an alert will be displayed that this information is not available.    IMPACT: If this configuration is disabled, then the patient will not have access to the portal.    VALUE: There are 2 values which will enable or disable this feature.  Y – This value enables access for patient portal  N/Null – This value does disable the access.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'The Smartcare Application has the option for patient login where patients can login and view their medical information if required credentials (user/password) and permissions (respective reports) are granted by the hospital. If this is enabled (Y), all patients having access to the portal can login and view specific documents and data as per the permission given by the provider. In a scenario where this key is disabled (N or NULL), then after entering user/password information and clicking on ‘Login’ button, an alert will be displayed that this information is not available.    IMPACT: If this configuration is disabled, then the patient will not have access to the portal.    VALUE: There are 2 values which will enable or disable this feature.  Y – This value enables access for patient portal  N/Null – This value does disable the access.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='USEPATIENTPORTAL';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'StoreInDocumentVersionViews') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('StoreInDocumentVersionViews' 
				,'0,1'
				,'This configuration will enable the customer to define if they would like the disclosure PDFs to be generated dynamically OR they would like to store in the database.    IMPACT:  With the above background, the following 2 conditions have been considered and implemented.  o If System configuration key ‘StoreInDocumentVersionViews’ is set to ‘0’, then system will check whether required PDF exists in DocumentVersionViews table or not. If it is exists, the PDF will be taken from the DocumentVersionViews and it will display. If it does not exist, then system will generate a new PDF and it will show. It will not make any entry to DocumentVersionViews table.  o If System configuration key ‘StoreInDocumentVersionViews’ is set to ‘1’, the system will check whether required PDF exists in or not. If it is exists, the PDF will be taken from the DocumentVersionViews and it will display. If it does not exist, then system will generate a new PDF and it will show. It will also make a new entry to DocumentVersionViews table.    VALUE:  - Setting this key to 0 will enable dynamic generation of PDFs  - Setting this key to 1 will store records in DocumentVersionViews table  - By default, we are setting this to 0  Note: The above setting of the key to 0 or 1 will be more relevant in the case of a brand new customer. Since this solution is being used by existing customers who are unable to print disclosures, the ‘StoreInDocumentVersionViews’ key is set to 0.    Note: Let us say that we have an existing customer who chooses StoreInDocumentVersionViews = ‘1’ as an option. This means, they are saving in their hard-disk space.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = '0,1'
		   ,[Description]= 'This configuration will enable the customer to define if they would like the disclosure PDFs to be generated dynamically OR they would like to store in the database.    IMPACT:  With the above background, the following 2 conditions have been considered and implemented.  o If System configuration key ‘StoreInDocumentVersionViews’ is set to ‘0’, then system will check whether required PDF exists in DocumentVersionViews table or not. If it is exists, the PDF will be taken from the DocumentVersionViews and it will display. If it does not exist, then system will generate a new PDF and it will show. It will not make any entry to DocumentVersionViews table.  o If System configuration key ‘StoreInDocumentVersionViews’ is set to ‘1’, the system will check whether required PDF exists in or not. If it is exists, the PDF will be taken from the DocumentVersionViews and it will display. If it does not exist, then system will generate a new PDF and it will show. It will also make a new entry to DocumentVersionViews table.    VALUE:  - Setting this key to 0 will enable dynamic generation of PDFs  - Setting this key to 1 will store records in DocumentVersionViews table  - By default, we are setting this to 0  Note: The above setting of the key to 0 or 1 will be more relevant in the case of a brand new customer. Since this solution is being used by existing customers who are unable to print disclosures, the ‘StoreInDocumentVersionViews’ key is set to 0.    Note: Let us say that we have an existing customer who chooses StoreInDocumentVersionViews = ‘1’ as an option. This means, they are saving in their hard-disk space.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='StoreInDocumentVersionViews';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'PASSWORDMINIMUMLENGTH') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('PASSWORDMINIMUMLENGTH' 
				,'1,2,3,4,5,6,7,8'
				,'These keys enable setting up the additional rules for Password creation for both Client and Staff.            IMPACT:  Enforcing rules around setting passwords (enhancing complexity of password) helps in better security of data. The system alerts with warning (tool tip) icon to the user if the new password doesn’t adhere to these rules. Now, if any of the columns are made ‘Y’ and that particular condition is not satisfied, then a warning (tool tip) icon is displayed.           VALUE: If ‘PASSWORDMINIMUMLENGTH’ value is made ‘10’, then the user can set the password only with the specified number of characters equal to or greater than the value set in this column. (For eg: If the value is set to 10 and the user enters 8 characters in the password field, then a validation is displayed).'
				,'N' 
				,'Login Page, Staff Preferencses, Staff Details'
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = '1,2,3,4,5,6,7,8'
		   ,[Description]= 'These keys enable setting up the additional rules for Password creation for both Client and Staff.            IMPACT:  Enforcing rules around setting passwords (enhancing complexity of password) helps in better security of data. The system alerts with warning (tool tip) icon to the user if the new password doesn’t adhere to these rules. Now, if any of the columns are made ‘Y’ and that particular condition is not satisfied, then a warning (tool tip) icon is displayed.           VALUE: If ‘PASSWORDMINIMUMLENGTH’ value is made ‘10’, then the user can set the password only with the specified number of characters equal to or greater than the value set in this column. (For eg: If the value is set to 10 and the user enters 8 characters in the password field, then a validation is displayed).'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Login Page, Staff Preferencses, Staff Details'
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='PASSWORDMINIMUMLENGTH';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'PASSWORDREQUIREUPPERCASE') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('PASSWORDREQUIREUPPERCASE' 
				,'Y,N'
				,'These keys enable setting up the additional rules for Password creation for both Client and Staff.            IMPACT:  Enforcing rules around setting passwords (enhancing complexity of password) helps in better security of data. The system alerts with warning (tool tip) icon to the user if the new password doesn’t adhere to these rules. Now, if any of the columns are made ‘Y’ and that particular condition is not satisfied, then a warning (tool tip) icon is displayed.           VALUE: If ‘PASSWORDREQUIREUPPERCASE’ value is made ‘Y’, then the user can set / change the password only when an uppercase value is entered. In other words, if ‘PASSWORDREQUIREUPPERCASE’ value is made ‘Y’, then the user should not able to change the password in ‘My Preferences’ screen without an ’Uppercase’ value in the password.'
				,'N' 
				,'Login Page, Staff Preferencses, Staff Details'
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'These keys enable setting up the additional rules for Password creation for both Client and Staff.            IMPACT:  Enforcing rules around setting passwords (enhancing complexity of password) helps in better security of data. The system alerts with warning (tool tip) icon to the user if the new password doesn’t adhere to these rules. Now, if any of the columns are made ‘Y’ and that particular condition is not satisfied, then a warning (tool tip) icon is displayed.           VALUE: If ‘PASSWORDREQUIREUPPERCASE’ value is made ‘Y’, then the user can set / change the password only when an uppercase value is entered. In other words, if ‘PASSWORDREQUIREUPPERCASE’ value is made ‘Y’, then the user should not able to change the password in ‘My Preferences’ screen without an ’Uppercase’ value in the password.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Login Page, Staff Preferencses, Staff Details'
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='PASSWORDREQUIREUPPERCASE';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'PASSWORREQUIRENUMERIC') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('PASSWORREQUIRENUMERIC' 
				,'Y,N'
				,'These keys enable setting up the additional rules for Password creation for both Client and Staff.          IMPACT:  Enforcing rules around setting passwords (enhancing complexity of password) helps in better security of data. The system alerts with warning (tool tip) icon to the user if the new password doesn’t adhere to these rules. Now, if any of the columns are made ‘Y’ and that particular condition is not satisfied, then a warning (tool tip) icon is displayed.         VALUE: If ‘PASSWORREQUIRENUMERIC’ value is made ‘Y’, then the user can set / change the password only when a Numeric value is entered. In other words, if ‘PASSWORREQUIRENUMERIC’ value is made ‘Y’, then the user should not able to change the password in ‘My Preferences’ screen without a ‘Numeric’ value in the password.'
				,'N' 
				,'Login Page, Staff Preferencses, Staff Details'
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'These keys enable setting up the additional rules for Password creation for both Client and Staff.          IMPACT:  Enforcing rules around setting passwords (enhancing complexity of password) helps in better security of data. The system alerts with warning (tool tip) icon to the user if the new password doesn’t adhere to these rules. Now, if any of the columns are made ‘Y’ and that particular condition is not satisfied, then a warning (tool tip) icon is displayed.         VALUE: If ‘PASSWORREQUIRENUMERIC’ value is made ‘Y’, then the user can set / change the password only when a Numeric value is entered. In other words, if ‘PASSWORREQUIRENUMERIC’ value is made ‘Y’, then the user should not able to change the password in ‘My Preferences’ screen without a ‘Numeric’ value in the password.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Login Page, Staff Preferencses, Staff Details'
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='PASSWORREQUIRENUMERIC';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'PASSWORDREQUIRESPECIALCHARACTER') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('PASSWORDREQUIRESPECIALCHARACTER' 
				,'Y,N'
				,'These keys enable setting up the additional rules for Password creation for both Client and Staff.            IMPACT:  Enforcing rules around setting passwords (enhancing complexity of password) helps in better security of data. The system alerts with warning (tool tip) icon to the user if the new password doesn’t adhere to these rules. Now, if any of the columns are made ‘Y’ and that particular condition is not satisfied, then a warning (tool tip) icon is displayed.           VALUE: When ‘PASSWORDREQUIRESPECIALCHARACTER’ value is made ‘Y’, then the user can set / change the password only when a special character is entered. In other words, if ‘PASSWORDREQUIRESPECIALCHARACTER’ value is made ‘Y’, then the user should not able to change the password in ‘My Preferences’ screen without a ‘Special character’ in the password.'
				,'N' 
				,'Login Page, Staff Preferencses, Staff Details'
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'These keys enable setting up the additional rules for Password creation for both Client and Staff.            IMPACT:  Enforcing rules around setting passwords (enhancing complexity of password) helps in better security of data. The system alerts with warning (tool tip) icon to the user if the new password doesn’t adhere to these rules. Now, if any of the columns are made ‘Y’ and that particular condition is not satisfied, then a warning (tool tip) icon is displayed.           VALUE: When ‘PASSWORDREQUIRESPECIALCHARACTER’ value is made ‘Y’, then the user can set / change the password only when a special character is entered. In other words, if ‘PASSWORDREQUIRESPECIALCHARACTER’ value is made ‘Y’, then the user should not able to change the password in ‘My Preferences’ screen without a ‘Special character’ in the password.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Login Page, Staff Preferencses, Staff Details'
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='PASSWORDREQUIRESPECIALCHARACTER';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'EndUserMonitoringEnabled') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('EndUserMonitoringEnabled' 
				,'Y,N'
				,'This key is for internal use where the development  team enables this key to monitor the end user application performance and we are using the 3rd party tool called ‘App Dynamics’ for analytics which will capture the required exceptions and other details to tune the application performance.     IMPACT: Turning on this key enables performance monitoring of a customer environment.     VALUE: There are 2 values which will enable or disable this feature.  Y– This value enables monitoring the performance, and application captures all the analytics needed for the analytics.  N/Null – This value disables performance monitoring.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'This key is for internal use where the development  team enables this key to monitor the end user application performance and we are using the 3rd party tool called ‘App Dynamics’ for analytics which will capture the required exceptions and other details to tune the application performance.     IMPACT: Turning on this key enables performance monitoring of a customer environment.     VALUE: There are 2 values which will enable or disable this feature.  Y– This value enables monitoring the performance, and application captures all the analytics needed for the analytics.  N/Null – This value disables performance monitoring.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='EndUserMonitoringEnabled';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'EndUserMonitoringFilePath') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('EndUserMonitoringFilePath' 
				,'\AppDynamics\Javascript01'
				,'This key is used for facilitating performance monitoring using a tool called AppDynamics. The value of this key is the path of Java scripts and the tool (AppDynamics) uses this JavaScript to monitor our application and capture exceptions and produces required reports. In other words, the AppDynamics JavaScripts need to be placed in this path so that monitoring through the AppDynamics is possible.     Precondition: For using this key [EndUserMonitoringFilePath], another key [EndUserMonitoringEnabled] has to be set to ‘Y’.     VALUE: The value will be the Javascript path.  \AppDynamics\Javascript01'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = '\AppDynamics\Javascript01'
		   ,[Description]= 'This key is used for facilitating performance monitoring using a tool called AppDynamics. The value of this key is the path of Java scripts and the tool (AppDynamics) uses this JavaScript to monitor our application and capture exceptions and produces required reports. In other words, the AppDynamics JavaScripts need to be placed in this path so that monitoring through the AppDynamics is possible.     Precondition: For using this key [EndUserMonitoringFilePath], another key [EndUserMonitoringEnabled] has to be set to ‘Y’.     VALUE: The value will be the Javascript path.  \AppDynamics\Javascript01'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='EndUserMonitoringFilePath';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ExchangeEnableSync') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ExchangeEnableSync' 
				,'N'
				,'Outlook integration is part of the SmartCare application where we are sending messages, appointments from the SmartCare application to user via MS Outlook application. These parameters will be used in the integration interface and will do one-way update from SmartCare application to the users’ outlook.        IMPACT: This is one-way communication from SmartCare application to users’ Microsoft Outlook. Please note that any changes done in the outlook for the message or appointments will not reflect in the SmartCare Application.        VALUE: These are customer specific values.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'N'
		   ,[Description]= 'Outlook integration is part of the SmartCare application where we are sending messages, appointments from the SmartCare application to user via MS Outlook application. These parameters will be used in the integration interface and will do one-way update from SmartCare application to the users’ outlook.        IMPACT: This is one-way communication from SmartCare application to users’ Microsoft Outlook. Please note that any changes done in the outlook for the message or appointments will not reflect in the SmartCare Application.        VALUE: These are customer specific values.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ExchangeEnableSync';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ExchangeURL') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ExchangeURL' 
				,'https://servername/EWS/Exchange.asmx'
				,'Outlook integration is part of the SmartCare application where we are sending messages, appointments from the SmartCare application to user via MS Outlook application. These parameters will be used in the integration interface and will do one-way update from SmartCare application to the users’ outlook.        IMPACT: This is one-way communication from SmartCare application to users’ Microsoft Outlook. Please note that any changes done in the outlook for the message or appointments will not reflect in the SmartCare Application.        VALUE: These are customer specific values.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'https://servername/EWS/Exchange.asmx'
		   ,[Description]= 'Outlook integration is part of the SmartCare application where we are sending messages, appointments from the SmartCare application to user via MS Outlook application. These parameters will be used in the integration interface and will do one-way update from SmartCare application to the users’ outlook.        IMPACT: This is one-way communication from SmartCare application to users’ Microsoft Outlook. Please note that any changes done in the outlook for the message or appointments will not reflect in the SmartCare Application.        VALUE: These are customer specific values.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ExchangeURL';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ExchangeVerifyCertificate') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ExchangeVerifyCertificate' 
				,'true,false'
				,'Outlook integration is part of the SmartCare application where we are sending messages, appointments from the SmartCare application to user via MS Outlook application. These parameters will be used in the integration interface and will do one-way update from SmartCare application to the users’ outlook.        IMPACT: This is one-way communication from SmartCare application to users’ Microsoft Outlook. Please note that any changes done in the outlook for the message or appointments will not reflect in the SmartCare Application.        VALUE: These are customer specific values.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'true,false'
		   ,[Description]= 'Outlook integration is part of the SmartCare application where we are sending messages, appointments from the SmartCare application to user via MS Outlook application. These parameters will be used in the integration interface and will do one-way update from SmartCare application to the users’ outlook.        IMPACT: This is one-way communication from SmartCare application to users’ Microsoft Outlook. Please note that any changes done in the outlook for the message or appointments will not reflect in the SmartCare Application.        VALUE: These are customer specific values.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ExchangeVerifyCertificate';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ExchangeUsername') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ExchangeUsername' 
				,'UserName'
				,'Outlook integration is part of the SmartCare application where we are sending messages, appointments from the SmartCare application to user via MS Outlook application. These parameters will be used in the integration interface and will do one-way update from SmartCare application to the users’ outlook.        IMPACT: This is one-way communication from SmartCare application to users’ Microsoft Outlook. Please note that any changes done in the outlook for the message or appointments will not reflect in the SmartCare Application.        VALUE: These are customer specific values.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'UserName'
		   ,[Description]= 'Outlook integration is part of the SmartCare application where we are sending messages, appointments from the SmartCare application to user via MS Outlook application. These parameters will be used in the integration interface and will do one-way update from SmartCare application to the users’ outlook.        IMPACT: This is one-way communication from SmartCare application to users’ Microsoft Outlook. Please note that any changes done in the outlook for the message or appointments will not reflect in the SmartCare Application.        VALUE: These are customer specific values.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ExchangeUsername';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ExchangePassword') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ExchangePassword' 
				,'Password'
				,'Outlook integration is part of the SmartCare application where we are sending messages, appointments from the SmartCare application to user via MS Outlook application. These parameters will be used in the integration interface and will do one-way update from SmartCare application to the users’ outlook.        IMPACT: This is one-way communication from SmartCare application to users’ Microsoft Outlook. Please note that any changes done in the outlook for the message or appointments will not reflect in the SmartCare Application.        VALUE: These are customer specific values.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Password'
		   ,[Description]= 'Outlook integration is part of the SmartCare application where we are sending messages, appointments from the SmartCare application to user via MS Outlook application. These parameters will be used in the integration interface and will do one-way update from SmartCare application to the users’ outlook.        IMPACT: This is one-way communication from SmartCare application to users’ Microsoft Outlook. Please note that any changes done in the outlook for the message or appointments will not reflect in the SmartCare Application.        VALUE: These are customer specific values.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ExchangePassword';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ExchangeDomain') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ExchangeDomain' 
				,'Domain'
				,'Outlook integration is part of the SmartCare application where we are sending messages, appointments from the SmartCare application to user via MS Outlook application. These parameters will be used in the integration interface and will do one-way update from SmartCare application to the users’ outlook.        IMPACT: This is one-way communication from SmartCare application to users’ Microsoft Outlook. Please note that any changes done in the outlook for the message or appointments will not reflect in the SmartCare Application.        VALUE: These are customer specific values.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Domain'
		   ,[Description]= 'Outlook integration is part of the SmartCare application where we are sending messages, appointments from the SmartCare application to user via MS Outlook application. These parameters will be used in the integration interface and will do one-way update from SmartCare application to the users’ outlook.        IMPACT: This is one-way communication from SmartCare application to users’ Microsoft Outlook. Please note that any changes done in the outlook for the message or appointments will not reflect in the SmartCare Application.        VALUE: These are customer specific values.'
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ExchangeDomain';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ExchangeAlertSubscriberStaffIds') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ExchangeAlertSubscriberStaffIds' 
				,'N'
				,'Outlook integration is part of the SmartCare application where we are sending messages, appointments from the SmartCare application to user via MS Outlook application. These parameters will be used in the integration interface and will do one-way update from SmartCare application to the users’ outlook.        IMPACT: This is one-way communication from SmartCare application to users’ Microsoft Outlook. Please note that any changes done in the outlook for the message or appointments will not reflect in the SmartCare Application.        VALUE: These are customer specific values.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'N'
		   ,[Description]= 'Outlook integration is part of the SmartCare application where we are sending messages, appointments from the SmartCare application to user via MS Outlook application. These parameters will be used in the integration interface and will do one-way update from SmartCare application to the users’ outlook.        IMPACT: This is one-way communication from SmartCare application to users’ Microsoft Outlook. Please note that any changes done in the outlook for the message or appointments will not reflect in the SmartCare Application.        VALUE: These are customer specific values.' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ExchangeAlertSubscriberStaffIds';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'validateHealthMaintenaceForClient') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('validateHealthMaintenaceForClient' 
				,'Y,N'
				,'As part of the compliance on Meaningful Use Stage 1, the Patient Reminders is one of the 9 menu set measures which is mandatory to be fulfilled.  The objective as stated is to “Send reminders to patients, per patient with preference for preventive/follow-up care”. In SmartCare, we have function called “Health Maintenance Alert”. This pop-up alert will appear on the screen whenever the data is meeting the trigger point criteria. Eg: We have named an alert as ‘Male Gender Alert’. Whenever we have male patient, the system is supposed to educate them with specific preventive care instructions. In the application, if you are selecting a male client either from the quick dropdown or through search, an alert appears on the client screen with specific message where the physician can accept/reject and close the alert. This alert appears on every selection of this patient in the application.     Health Maintenance has 3 levels of setup in the application.  1st level – Health Maintenance Template List Screen: This screen is part of the Administration tab where we can define name of alert as template name.  2nd Level - Health Maintenance Triggering Factor: In this screen, we are configuring the trigger points for the alert. These trigger points are specific to client level. The factors for defining are Age, Diagnosis, Medication, Procedure, Gender. As per the selection, the parameters can be defined for each of them. Eg: On selection of Gender, Male/Female dropdown appears for selection. Interdependent trigger factors can be inserted for a template.  3rd Level – systemconfigurationkeys: To enable the trigger to pop-up, we have to enable the master key by updating the value to ‘Y’ for the key ‘validateHealthMaintenanceForClient’.    IMPACT: On the Maintenance Alert Pop-up, the Accept and Reject buttons are available, and as per the user selection this is recorded and is updated in the widget ‘Patient Reminder (Menu 4)’ on the ‘Meaningful Use Dashboard’.    VALUE: There are 2 values which will enable or disable this feature.  Y – This value enables this feature and pop-up will appear.  N/NULL – This value disables this feature. No pop-up will appear.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'As part of the compliance on Meaningful Use Stage 1, the Patient Reminders is one of the 9 menu set measures which is mandatory to be fulfilled.  The objective as stated is to “Send reminders to patients, per patient with preference for preventive/follow-up care”. In SmartCare, we have function called “Health Maintenance Alert”. This pop-up alert will appear on the screen whenever the data is meeting the trigger point criteria. Eg: We have named an alert as ‘Male Gender Alert’. Whenever we have male patient, the system is supposed to educate them with specific preventive care instructions. In the application, if you are selecting a male client either from the quick dropdown or through search, an alert appears on the client screen with specific message where the physician can accept/reject and close the alert. This alert appears on every selection of this patient in the application.     Health Maintenance has 3 levels of setup in the application.  1st level – Health Maintenance Template List Screen: This screen is part of the Administration tab where we can define name of alert as template name.  2nd Level - Health Maintenance Triggering Factor: In this screen, we are configuring the trigger points for the alert. These trigger points are specific to client level. The factors for defining are Age, Diagnosis, Medication, Procedure, Gender. As per the selection, the parameters can be defined for each of them. Eg: On selection of Gender, Male/Female dropdown appears for selection. Interdependent trigger factors can be inserted for a template.  3rd Level – systemconfigurationkeys: To enable the trigger to pop-up, we have to enable the master key by updating the value to ‘Y’ for the key ‘validateHealthMaintenanceForClient’.    IMPACT: On the Maintenance Alert Pop-up, the Accept and Reject buttons are available, and as per the user selection this is recorded and is updated in the widget ‘Patient Reminder (Menu 4)’ on the ‘Meaningful Use Dashboard’.    VALUE: There are 2 values which will enable or disable this feature.  Y – This value enables this feature and pop-up will appear.  N/NULL – This value disables this feature. No pop-up will appear.' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='validateHealthMaintenaceForClient';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'LoginAttemptTimeOut') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('LoginAttemptTimeOut' 
				,'1,2,3,4,5,6,7,8,9,10'
				,'This key checks on the failed login attempt by user due to the wrong username or password.After retry by the user more than the attempts being put in the value of this key the system prompts the message as "Your account has been disabled.Please contact system administrator" where the user need to get the account reactivated by the administrator.      IMPACT: After retying for more than the attempts specified in the value the user is disabled. The Administrator will enable this user.       VALUE: The user can disable this by inputting value as "Null". The attempts can be configured by selecting value from the dropdown'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = '1,2,3,4,5,6,7,8,9,10'
		   ,[Description]= 'This key checks on the failed login attempt by user due to the wrong username or password.After retry by the user more than the attempts being put in the value of this key the system prompts the message as "Your account has been disabled.Please contact system administrator" where the user need to get the account reactivated by the administrator.      IMPACT: After retying for more than the attempts specified in the value the user is disabled. The Administrator will enable this user.       VALUE: The user can disable this by inputting value as "Null". The attempts can be configured by selecting value from the dropdown' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='LoginAttemptTimeOut';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'SeverityLevel1RequiresAcknowledment') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('SeverityLevel1RequiresAcknowledment' 
				,NULL
				,'Significance:  In the smartcare orders when a drug is being prescribed then we have a column “ACK” where the acknowledgement button is displayed and this need to be acknowledged by the doctor who is prescribing it. Few of the drugs and the related Interaction levels are less risky and can be recommended without acknowledgement. This key configuration helps in making the Acknowledgement as a required action and additionally we can also configure severity level for which the acknowledgement is required.      Impact: The Impact will be on the Client Orders screen. This configuration affects the column “ACK” and acknowledge button where it will either show or hide deepening on the configuration.     Value: There are 2 values which will enable or disable mandatory acknowledgement at this level.  Y – Acknowledgement button will appear.  Null/N – Acknowledgement is hidden.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= 'Significance:  In the smartcare orders when a drug is being prescribed then we have a column “ACK” where the acknowledgement button is displayed and this need to be acknowledged by the doctor who is prescribing it. Few of the drugs and the related Interaction levels are less risky and can be recommended without acknowledgement. This key configuration helps in making the Acknowledgement as a required action and additionally we can also configure severity level for which the acknowledgement is required.      Impact: The Impact will be on the Client Orders screen. This configuration affects the column “ACK” and acknowledge button where it will either show or hide deepening on the configuration.     Value: There are 2 values which will enable or disable mandatory acknowledgement at this level.  Y – Acknowledgement button will appear.  Null/N – Acknowledgement is hidden.' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='SeverityLevel1RequiresAcknowledment';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'SeverityLevel2RequiresAcknowledment') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('SeverityLevel2RequiresAcknowledment' 
				,NULL
				,'Significance:  In the smartcare orders when a drug is being prescribed then we have a column “ACK” where the acknowledgement button is displayed and this need to be acknowledged by the doctor who is prescribing it. Few of the drugs and the related Interaction levels are less risky and can be recommended without acknowledgement. This key configuration helps in making the Acknowledgement as a required action and additionally we can also configure severity level for which the acknowledgement is required.      Impact: The Impact will be on the Client Orders screen. This configuration affects the column “ACK” and acknowledge button where it will either show or hide deepening on the configuration.     Value: There are 2 values which will enable or disable mandatory acknowledgement at this level.  Y – Acknowledgement button will appear.  Null/N – Acknowledgement is hidden.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= 'Significance:  In the smartcare orders when a drug is being prescribed then we have a column “ACK” where the acknowledgement button is displayed and this need to be acknowledged by the doctor who is prescribing it. Few of the drugs and the related Interaction levels are less risky and can be recommended without acknowledgement. This key configuration helps in making the Acknowledgement as a required action and additionally we can also configure severity level for which the acknowledgement is required.      Impact: The Impact will be on the Client Orders screen. This configuration affects the column “ACK” and acknowledge button where it will either show or hide deepening on the configuration.     Value: There are 2 values which will enable or disable mandatory acknowledgement at this level.  Y – Acknowledgement button will appear.  Null/N – Acknowledgement is hidden.' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='SeverityLevel2RequiresAcknowledment';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'SeverityLevel3RequiresAcknowledment') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('SeverityLevel3RequiresAcknowledment' 
				,NULL
				,'Significance:  In the smartcare orders when a drug is being prescribed then we have a column “ACK” where the acknowledgement button is displayed and this need to be acknowledged by the doctor who is prescribing it. Few of the drugs and the related Interaction levels are less risky and can be recommended without acknowledgement. This key configuration helps in making the Acknowledgement as a required action and additionally we can also configure severity level for which the acknowledgement is required.      Impact: The Impact will be on the Client Orders screen. This configuration affects the column “ACK” and acknowledge button where it will either show or hide deepening on the configuration.     Value: There are 2 values which will enable or disable mandatory acknowledgement at this level.  Y – Acknowledgement button will appear.  Null/N – Acknowledgement is hidden.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= 'Significance:  In the smartcare orders when a drug is being prescribed then we have a column “ACK” where the acknowledgement button is displayed and this need to be acknowledged by the doctor who is prescribing it. Few of the drugs and the related Interaction levels are less risky and can be recommended without acknowledgement. This key configuration helps in making the Acknowledgement as a required action and additionally we can also configure severity level for which the acknowledgement is required.      Impact: The Impact will be on the Client Orders screen. This configuration affects the column “ACK” and acknowledge button where it will either show or hide deepening on the configuration.     Value: There are 2 values which will enable or disable mandatory acknowledgement at this level.  Y – Acknowledgement button will appear.  Null/N – Acknowledgement is hidden.' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='SeverityLevel3RequiresAcknowledment';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowProgramInOtherDropdown') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowProgramInOtherDropdown' 
				,NULL
				,'To show values in Other Dropdown of Inquiry/Grievance List page'
				,'N' 
				,'Grievances, Inquiries'
				,'70,72'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= 'To show values in Other Dropdown of Inquiry/Grievance List page' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Grievances, Inquiries'
		   ,Screens= '70,72'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowProgramInOtherDropdown';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'RefreshReceptionGridInterval') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('RefreshReceptionGridInterval' 
				,NULL
				,'This key provides an option to the customer site to change the refresh interrval time for Reception Grid in milliseconds'
				,'N' 
				,'Reception'
				,'324'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= 'This key provides an option to the customer site to change the refresh interrval time for Reception Grid in milliseconds' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Reception'
		   ,Screens= '324'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='RefreshReceptionGridInterval';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'DirectMessageRetieveListURL') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('DirectMessageRetieveListURL' 
				,NULL
				,'Direct Message HISP API Retrieve Message List URL'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= 'Direct Message HISP API Retrieve Message List URL' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='DirectMessageRetieveListURL';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'DirectMessageRetieveURL') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('DirectMessageRetieveURL' 
				,NULL
				,'Direct Message HISP API Retieve Single Message URL'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= 'Direct Message HISP API Retieve Single Message URL' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='DirectMessageRetieveURL';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'DirectMessageAttachmentRetieveURL') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('DirectMessageAttachmentRetieveURL' 
				,NULL
				,'Direct Message HISP API Retieve Single Attachment URL'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= 'Direct Message HISP API Retieve Single Attachment URL' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='DirectMessageAttachmentRetieveURL';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'DirectMessageUploadeAttachmentURL') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('DirectMessageUploadeAttachmentURL' 
				,NULL
				,'Direct Message HISP API Upload Attachement URL'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= 'Direct Message HISP API Upload Attachement URL' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='DirectMessageUploadeAttachmentURL';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'DirectMessageSendURL') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('DirectMessageSendURL' 
				,NULL
				,'Direct Message HISP API Upload/Send Message URL'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= 'Direct Message HISP API Upload/Send Message URL' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='DirectMessageSendURL';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'MAR_EnableBarcoding') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('MAR_EnableBarcoding' 
				,NULL
				,'Enable or disable MAR Barcoding'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= 'Enable or disable MAR Barcoding' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='MAR_EnableBarcoding';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'DAILYMULTIVIEWLISTPERPAGE') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('DAILYMULTIVIEWLISTPERPAGE' 
				,'1,2,3,4,5,6,7,8,9,10'
				,'Significance:  This key configuration helps to configure multistaff view group for number of staff for Daily View.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = '1,2,3,4,5,6,7,8,9,10'
		   ,[Description]= 'Significance:  This key configuration helps to configure multistaff view group for number of staff for Daily View.' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='DAILYMULTIVIEWLISTPERPAGE';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'WEEKLYMULTIVIEWLISTPERPAGE') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('WEEKLYMULTIVIEWLISTPERPAGE' 
				,'1,2,3,4,5,6,7,8,9,10'
				,'Significance:  This key configuration helps to configure multistaff view group for number of staff for Weekly View.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = '1,2,3,4,5,6,7,8,9,10'
		   ,[Description]= 'Significance:  This key configuration helps to configure multistaff view group for number of staff for Weekly View.' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='WEEKLYMULTIVIEWLISTPERPAGE';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'MARShowDiscontinueMedsFromPastXDays') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('MARShowDiscontinueMedsFromPastXDays' 
				,NULL
				,'Significance:  This key configuration helps in defining the Discontinue Medicine being displayed in the Group Client MAR Screen.       As per the values Discontinue medicine will show up accordingly. If it is 30 then all the Medicine discontinue in last 30 days      will be displayed.     Impact: The Impact will be on the Group Client MAR List page .     Value: By deafult 30 will be inserted for MARShowDiscontinueMedsFromPastXDays key .'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= 'Significance:  This key configuration helps in defining the Discontinue Medicine being displayed in the Group Client MAR Screen.       As per the values Discontinue medicine will show up accordingly. If it is 30 then all the Medicine discontinue in last 30 days      will be displayed.     Impact: The Impact will be on the Group Client MAR List page .     Value: By deafult 30 will be inserted for MARShowDiscontinueMedsFromPastXDays key .' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='MARShowDiscontinueMedsFromPastXDays';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'AppointmentSearchDurationOverride') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('AppointmentSearchDurationOverride' 
				,NULL
				,'Allows override for appointment search duration. Default value set to N will allow exsiting behavior of duration equal to the minutes entered in search. Override value to Y and the duration from the search result line record will be used.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= 'Allows override for appointment search duration. Default value set to N will allow exsiting behavior of duration equal to the minutes entered in search. Override value to Y and the duration from the search result line record will be used.' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='AppointmentSearchDurationOverride';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ClinicianForBedServices') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ClinicianForBedServices' 
				,NULL
				,'Significance:  This key configuration helps in assigning clinician to the Bed Census Services created by the overnight job.     Impact: The Impact will be on the Bed Census Services created by the overnight job.     Value: Value stored in this key is Staff Id'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= 'Significance:  This key configuration helps in assigning clinician to the Bed Census Services created by the overnight job.     Impact: The Impact will be on the Bed Census Services created by the overnight job.     Value: Value stored in this key is Staff Id' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ClinicianForBedServices';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'PaymentAdjustmentPostingRequireLocation') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('PaymentAdjustmentPostingRequireLocation' 
				,'Y,N'
				,'This key is used to customize location selection requirement validation on payment adjustment popup screen.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'This key is used to customize location selection requirement validation on payment adjustment popup screen.' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='PaymentAdjustmentPostingRequireLocation';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'SERVICECOMPLETIONLAGDAYS') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('SERVICECOMPLETIONLAGDAYS' 
				,NULL
				,'Value for this Key identifies the number of days from the Date Of Service after which the Service is picked up by the Service Completion process for the first time.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= 'Value for this Key identifies the number of days from the Date Of Service after which the Service is picked up by the Service Completion process for the first time.' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='SERVICECOMPLETIONLAGDAYS';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'BEDCENSUSSERVICECREATIONLAGDAYS') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('BEDCENSUSSERVICECREATIONLAGDAYS' 
				,NULL
				,'Value for this Key identifies the number of days from the Attendance Date after which a Show Service is created for the Attendance Date.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= 'Value for this Key identifies the number of days from the Attendance Date after which a Show Service is created for the Attendance Date.' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='BEDCENSUSSERVICECREATIONLAGDAYS';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'RXPatientSummaryTemplate') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('RXPatientSummaryTemplate' 
				,NULL
				,'Template which contains Axis I, II and III and not ICD 10'
				,'N' 
				,'Rx - Patient Summary'
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= 'Template which contains Axis I, II and III and not ICD 10' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Rx - Patient Summary'
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='RXPatientSummaryTemplate';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'RXPatientSummayTemplateICD10') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('RXPatientSummayTemplateICD10' 
				,NULL
				,'Template which contains ICD 10 and not Axis I, II and III'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= 'Template which contains ICD 10 and not Axis I, II and III' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='RXPatientSummayTemplateICD10';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowSignatureDeclinePopup') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowSignatureDeclinePopup' 
				,NULL
				,'This key configuration is used to show or no-show Decline Signature Popup.              Value: Y OR N . If this value is Y, the GlobalCodeCategory DOCSIGNDECLINEREASON must have values in globalcodes table.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= 'This key configuration is used to show or no-show Decline Signature Popup.              Value: Y OR N . If this value is Y, the GlobalCodeCategory DOCSIGNDECLINEREASON must have values in globalcodes table.' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowSignatureDeclinePopup';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'RXPatientSummaryTemplateICD10') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('RXPatientSummaryTemplateICD10' 
				,NULL
				,'Template which contains ICD 10 and not Axis I, II and III'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= 'Template which contains ICD 10 and not Axis I, II and III' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='RXPatientSummaryTemplateICD10';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'OrderedMedicationPrescriptionToolTip') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('OrderedMedicationPrescriptionToolTip' 
				,NULL
				,'Medication Info Icon for Prescription Note and Comment Fields'
				,'N' 
				,'Rx - New Order Screen '
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= 'Medication Info Icon for Prescription Note and Comment Fields' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Rx - New Order Screen '
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='OrderedMedicationPrescriptionToolTip';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ApplyCustomCaseLoadLogic') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ApplyCustomCaseLoadLogic' 
				,NULL
				,'This key will be used in ssp_ListPageSCMyCaseload to invoke the custom sp or not'
				,'N' 
				,'My CaseLoad list page'
				,'18'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= 'This key will be used in ssp_ListPageSCMyCaseload to invoke the custom sp or not' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'My CaseLoad list page'
		   ,Screens= '18'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ApplyCustomCaseLoadLogic';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowAdditionalTimeAndDurationInCarePlanIntervention') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowAdditionalTimeAndDurationInCarePlanIntervention' 
				,'Y,N'
				,'Enable additional Time text field and Duration Drop down field in care plan intervention tab'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'Enable additional Time text field and Duration Drop down field in care plan intervention tab' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowAdditionalTimeAndDurationInCarePlanIntervention';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowRecentCoveragePlan') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowRecentCoveragePlan' 
				,NULL
				,'Displaying Recent Coverage Plan'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= 'Displaying Recent Coverage Plan' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowRecentCoveragePlan';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'DefaultReleaseCheckToProvider') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('DefaultReleaseCheckToProvider' 
				,NULL
				,'Enable Check Release To Provider'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= 'Enable Check Release To Provider' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='DefaultReleaseCheckToProvider';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'DefaultReleaseCheckToProviderMessage') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('DefaultReleaseCheckToProviderMessage' 
				,NULL
				,'Enable Provider Message text customizable'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= 'Enable Provider Message text customizable' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='DefaultReleaseCheckToProviderMessage';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'HideorShowAuthorizationCodes') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('HideorShowAuthorizationCodes' 
				,NULL
				,NULL
				,'N' 
				,'Authorization Defaults List Page'
				,'1149'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= NULL 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Authorization Defaults List Page'
		   ,Screens= '1149'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='HideorShowAuthorizationCodes';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'GETPROVIDERNAMEFROMAGENCYFORELIGIBILITYVERIFICATION') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('GETPROVIDERNAMEFROMAGENCYFORELIGIBILITYVERIFICATION' 
				,NULL
				,'Value to decide the Provider name for Eligibility verification comes from Agency table'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= 'Value to decide the Provider name for Eligibility verification comes from Agency table' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='GETPROVIDERNAMEFROMAGENCYFORELIGIBILITYVERIFICATION';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'PROVIDERNAMEFORELIGIBILITYVERIFICATION') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('PROVIDERNAMEFORELIGIBILITYVERIFICATION' 
				,NULL
				,'Provider Name used for Eligibility verification'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= 'Provider Name used for Eligibility verification' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='PROVIDERNAMEFORELIGIBILITYVERIFICATION';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'RequireDiagnosisOnDxDocuments') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('RequireDiagnosisOnDxDocuments' 
				,'Y,N'
				,'Toggles a validation for all DocumentCodes where DiagnosisDocuments = ''Y'' or DSMV =''Y''. If enabled, the document must contain diagnosis information or the No Diagnosis box must be checked.'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'Toggles a validation for all DocumentCodes where DiagnosisDocuments = ''Y'' or DSMV =''Y''. If enabled, the document must contain diagnosis information or the No Diagnosis box must be checked.' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='RequireDiagnosisOnDxDocuments';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'EMCodeCalculationForNewPatient') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('EMCodeCalculationForNewPatient' 
				,'Y,N'
				,'The EMCode calculation can yeild higher results for a new patient visit compared to an existing patient visit. This key allows us to enable or disable higher code generation for new patient visit.'
				,'N' 
				,'PrimaryCare'
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'The EMCode calculation can yeild higher results for a new patient visit compared to an existing patient visit. This key allows us to enable or disable higher code generation for new patient visit.' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'PrimaryCare'
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='EMCodeCalculationForNewPatient';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowInterventionEndDateInCMAuthorizationDetails') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowInterventionEndDateInCMAuthorizationDetails' 
				,NULL
				,'Disable Intervention End Date'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= 'Disable Intervention End Date' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowInterventionEndDateInCMAuthorizationDetails';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'FAILEDPRESCRIPTIONALERTSTARTDATE') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('FAILEDPRESCRIPTIONALERTSTARTDATE' 
				,'MM/DD/YYYY'
				,'Used by ssp_AlertFailedPrescriptionTransmission to determine how far back in time to search for failed prescription transmissions.'
				,'N' 
				,NULL
				,NULL
				,'if this key is not specified, ssp_AlertFailedPrescriptionTransmission will default to today() - 1' 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'MM/DD/YYYY'
		   ,[Description]= 'Used by ssp_AlertFailedPrescriptionTransmission to determine how far back in time to search for failed prescription transmissions.' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= 'if this key is not specified, ssp_AlertFailedPrescriptionTransmission will default to today() - 1'  
		   ,SourceTableName= NULL
			WHERE [Key]='FAILEDPRESCRIPTIONALERTSTARTDATE';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ValidateRefundType') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ValidateRefundType' 
				,NULL
				,'Validating the refund type drop down in Payments Adjustments pop up'
				,'N' 
				,'Payment/Adjustment Details'
				,'323'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= 'Validating the refund type drop down in Payments Adjustments pop up' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Payment/Adjustment Details'
		   ,Screens= '323'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ValidateRefundType';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'PREVENTBILLEDSERVICESOVERRIDE') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('PREVENTBILLEDSERVICESOVERRIDE' 
				,'Y,N'
				,'To prevent billed service from override'
				,'N' 
				,'Service Detail'
				,'207'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'To prevent billed service from override' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Service Detail'
		   ,Screens= '207'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='PREVENTBILLEDSERVICESOVERRIDE';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'EnableClaimEntryStartStopTime') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('EnableClaimEntryStartStopTime' 
				,NULL
				,'Enable StartTime and EndTime fields in Claim Entry'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= 'Enable StartTime and EndTime fields in Claim Entry' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='EnableClaimEntryStartStopTime';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'REQUIREDIAGNOSISCONDITIONVALIDATION') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('REQUIREDIAGNOSISCONDITIONVALIDATION' 
				,'Y,N'
				,'This Key will be used to invoke the ICD10 code additional/Exclude code validation'
				,'N' 
				,NULL
				,NULL
				,'All the screens where Validations require for core diagnosis document and custom documents that have diagnosis' 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'This Key will be used to invoke the ICD10 code additional/Exclude code validation' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= 'All the screens where Validations require for core diagnosis document and custom documents that have diagnosis'  
		   ,SourceTableName= NULL
			WHERE [Key]='REQUIREDIAGNOSISCONDITIONVALIDATION';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'RXEnableFormulary') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('RXEnableFormulary' 
				,'Y,N'
				,'RXEnableFormulary'
				,'N' 
				,'Rx - New Order Screen - Formulary Tab'
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'RXEnableFormulary' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Rx - New Order Screen - Formulary Tab'
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='RXEnableFormulary';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'AdminDisableTimeSheetAfterNumberOfDay') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('AdminDisableTimeSheetAfterNumberOfDay' 
				,NULL
				,'TimeSheet will be disabled for Admin Role'
				,'N' 
				,'Time Sheet Entry'
				,'1172'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= 'TimeSheet will be disabled for Admin Role' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Time Sheet Entry'
		   ,Screens= '1172'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='AdminDisableTimeSheetAfterNumberOfDay';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'UserDisableTimeSheetAfterNumberOfDay') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('UserDisableTimeSheetAfterNumberOfDay' 
				,NULL
				,'TimeSheet will be disabled for User Role'
				,'N' 
				,'Time Sheet Entry'
				,'1172'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= 'TimeSheet will be disabled for User Role' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Time Sheet Entry'
		   ,Screens= '1172'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='UserDisableTimeSheetAfterNumberOfDay';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'SetDefaultAttending') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('SetDefaultAttending' 
				,'Y,N'
				,'This key is used to set Default staff Attending, If SetDefaultAttending is "Y" then AttendingId is fetched from Clients.'
				,'N' 
				,'Service Detail'
				,'210'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'This key is used to set Default staff Attending, If SetDefaultAttending is "Y" then AttendingId is fetched from Clients.' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Service Detail'
		   ,Screens= '210'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='SetDefaultAttending';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'InstallSigPadDriverPrompt') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('InstallSigPadDriverPrompt' 
				,'Y,N'
				,'Documents can be signed in one of the 3 ways in SmartCare application. One of the options is to sign using Signature Pad, if a customer is not using signature pads and do not want to install any software(especially SigPlus driver), then they can turn it as ''N'', then the driver prompt will not display in IE. *Note- By default driver prompt will not display in Chrome. This key will not stop signing the user if he/she installed Sigweb driver (Signature pad will work in both IE and Chrome)'
				,'N' 
				,'SC Signature Pop up, Rx - Patient consent Signature Pop up'
				,'61'
				,'Documents can be signed in one of the 3 ways in SmartCare application. One of the options is to sign using Signature Pad, if a customer is not using signature pads and do not want to install any software(especially SigPlus driver), then they can turn it as ''N'', then the driver prompt will not display in IE. *Note- By default driver prompt will not display in Chrome. This key will not stop signing the user if he/she installed Sigweb driver (Signature pad will work in both IE and Chrome)' 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'Documents can be signed in one of the 3 ways in SmartCare application. One of the options is to sign using Signature Pad, if a customer is not using signature pads and do not want to install any software(especially SigPlus driver), then they can turn it as ''N'', then the driver prompt will not display in IE. *Note- By default driver prompt will not display in Chrome. This key will not stop signing the user if he/she installed Sigweb driver (Signature pad will work in both IE and Chrome)' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'SC Signature Pop up, Rx - Patient consent Signature Pop up'
		   ,Screens= '61'
		   ,Comments= 'Documents can be signed in one of the 3 ways in SmartCare application. One of the options is to sign using Signature Pad, if a customer is not using signature pads and do not want to install any software(especially SigPlus driver), then they can turn it as ''N'', then the driver prompt will not display in IE. *Note- By default driver prompt will not display in Chrome. This key will not stop signing the user if he/she installed Sigweb driver (Signature pad will work in both IE and Chrome)'  
		   ,SourceTableName= NULL
			WHERE [Key]='InstallSigPadDriverPrompt';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ExcludePaidServicesFromReallocation') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ExcludePaidServicesFromReallocation' 
				,'Y,N'
				,'Purpose of this Key is to exclude Paid Services from Reallocation process'
				,'N' 
				,NULL
				,NULL
				,'Purpose of this Key is to exclude Paid Services from Reallocation process' 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'Purpose of this Key is to exclude Paid Services from Reallocation process' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= 'Purpose of this Key is to exclude Paid Services from Reallocation process'  
		   ,SourceTableName= NULL
			WHERE [Key]='ExcludePaidServicesFromReallocation';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ShowAllClientsServices') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ShowAllClientsServices' 
				,'Y,N'
				,'when the Client Access permission of "Clinician in Program which Shares Clients" and the user does not have "All Clients",     then on the Services/Notes List page - that the user would ONLY be able to see those services that are in a Program that      is associated to the User Account.'
				,'N' 
				,'Services/ Notes'
				,NULL
				,'when the Client Access permission of "Clinician in Program which Shares Clients" and the user does not have "All Clients",     then on the Services/Notes List page - that the user would ONLY be able to see those services that are in a Program that      is associated to the User Account.' 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'when the Client Access permission of "Clinician in Program which Shares Clients" and the user does not have "All Clients",     then on the Services/Notes List page - that the user would ONLY be able to see those services that are in a Program that      is associated to the User Account.' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Services/ Notes'
		   ,Screens= NULL
		   ,Comments= 'when the Client Access permission of "Clinician in Program which Shares Clients" and the user does not have "All Clients",     then on the Services/Notes List page - that the user would ONLY be able to see those services that are in a Program that      is associated to the User Account.'  
		   ,SourceTableName= NULL
			WHERE [Key]='ShowAllClientsServices';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'MakeDisclosedToAsTypeableSearch') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('MakeDisclosedToAsTypeableSearch' 
				,'Y,N'
				,'Make DisclosedTo As TypeableSearch'
				,'N' 
				,'Disclosure/Request'
				,'26'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'Make DisclosedTo As TypeableSearch' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Disclosure/Request'
		   ,Screens= '26'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='MakeDisclosedToAsTypeableSearch';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'EnableLOCUS') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('EnableLOCUS' 
				,NULL
				,'Enable/ Disable LOCUS to use by customer'
				,'N' 
				,NULL
				,NULL
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= 'Enable/ Disable LOCUS to use by customer' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= NULL
		   ,Screens= NULL
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='EnableLOCUS';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'AuthorizationscreenId') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('AuthorizationscreenId' 
				,NULL
				,'Authorization ScreenId for Contact Notes Authorization link'
				,'N' 
				,'Contact Note Detail'
				,'924'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = NULL
		   ,[Description]= 'Authorization ScreenId for Contact Notes Authorization link' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Contact Note Detail'
		   ,Screens= '924'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='AuthorizationscreenId';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'REPORTERRORFORMISSINGBILLINGCODES') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('REPORTERRORFORMISSINGBILLINGCODES' 
				,'Y,N'
				,'Purpose of this Key is If Billing Code is not found on the Payments/adjustments tab, this key controls if an error is generated or it is ignored'
				,'N' 
				,'ClinicalSummary'
				,'939'
				,'If Y, report error.If N, dont report error. Default value should be Y'
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'Purpose of this Key is If Billing Code is not found on the Payments/adjustments tab, this key controls if an error is generated or it is ignored' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'ClinicalSummary'
		   ,Screens= '939'
		   ,Comments= 'If Y, report error.If N, dont report error. Default value should be Y'
		   ,SourceTableName= NULL
			WHERE [Key]='REPORTERRORFORMISSINGBILLINGCODES';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'ENABLEBATCHSCANNING') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('ENABLEBATCHSCANNING' 
				,'Y,N'
				,'Purpose of this Key to show and hide Batch scanning button on scanning list page'
				,'N' 
				,'Scanning list page'
				,'83'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= 'Purpose of this Key to show and hide Batch scanning button on scanning list page' 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Scanning list page'
		   ,Screens= '83'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='ENABLEBATCHSCANNING';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/

IF NOT EXISTS (SELECT 1 FROM systemconfigurationkeys WHERE [Key] = 'MakeLocationOnReceptionScreenAsRequired') 
	BEGIN 
		INSERT INTO systemconfigurationkeys 
				([Key]
				,AcceptedValues
				,[Description]
				,ShowKeyForViewingAndEditing
				,Modules
				,Screens
				,Comments
				,SourceTableName) 
		VALUES ('MakeLocationOnReceptionScreenAsRequired' 
				,'Y,N'
				,NULL
				,'N' 
				,'Reception List Page-Balance Entry-Payment Details Popup'
				,'365'
				,NULL 
				,NULL)
  END	
ELSE
   BEGIN
		   UPDATE systemconfigurationkeys
		   SET AcceptedValues = 'Y,N'
		   ,[Description]= NULL 
		   ,ShowKeyForViewingAndEditing= 'N'
		   ,Modules= 'Reception List Page-Balance Entry-Payment Details Popup'
		   ,Screens= '365'
		   ,Comments= NULL  
		   ,SourceTableName= NULL
			WHERE [Key]='MakeLocationOnReceptionScreenAsRequired';
   END	 	
/********************************* systemconfigurationkeys table *****************************************/
