 /*********************************************************************************  
 -- Feb.15.2018 Radhakrishnan  
         --What: Client Hover: Enhancements being requested  
         --Why: MHP-Customizations - Task 121  
    Update ClientInformationToolTipItems based on the SystemConfigurationKeys          
*********************************************************************************/  

   --1
   Update ClientInformationToolTipItems   
   Set  RecordDeleted = (  SELECT 'Value1' = CASE Value WHEN 'Y' THEN 'N' WHEN 'N' THEN 'Y' ELSE 'Y' END 					 
   FROM SystemConfigurationKeys Where [key] = 'ShowClientInformationToolTip'  )
   WHERE [NAME]='ClientInformation'   
   --2
   Update ClientInformationToolTipItems   
   Set  RecordDeleted = (  SELECT 'Value1' = CASE Value WHEN 'Y' THEN 'N' WHEN 'N' THEN 'Y' ELSE 'Y' END 						 
   FROM SystemConfigurationKeys Where [key] = 'ShowClientAddressInToolTip'  )
   WHERE [NAME]='ClientAddress'   
   --3
   Update ClientInformationToolTipItems   
   Set  RecordDeleted = (  SELECT 'Value1' =  CASE Value WHEN 'Y' THEN 'N' WHEN 'N' THEN 'Y' ELSE 'Y' END 						 
   FROM SystemConfigurationKeys Where [key] = 'ShowPhoneNumberInToolTip'  )
   WHERE [NAME]='PhoneNumber'   
   --4
   Update ClientInformationToolTipItems   
   Set  RecordDeleted = (  SELECT 'Value1' =  CASE Value WHEN 'Y' THEN 'N' WHEN 'N' THEN 'Y' ELSE 'Y' END 					 
   FROM SystemConfigurationKeys Where [key] = 'ShowDOBInToolTip'  )
   WHERE [NAME]='DOB'   
   --5
   Update ClientInformationToolTipItems   
   Set  RecordDeleted = (  SELECT 'Value1' =  CASE Value WHEN 'Y' THEN 'N' WHEN 'N' THEN 'Y' ELSE 'Y' END 					 
   FROM SystemConfigurationKeys Where [key] = 'ShowSexInToolTip'  )
   WHERE [NAME]='Sex'   
   --6
   Update ClientInformationToolTipItems   
   Set  RecordDeleted = (  SELECT 'Value1' =  CASE Value WHEN 'Y' THEN 'N' WHEN 'N' THEN 'Y' ELSE 'Y' END 					 
   FROM SystemConfigurationKeys Where [key] = 'ShowSSNInToolTip'  )
   WHERE [NAME]='SSN'   
   --7
   Update ClientInformationToolTipItems   
   Set  RecordDeleted = (  SELECT 'Value1' =  CASE Value WHEN 'Y' THEN 'N' WHEN 'N' THEN 'Y' ELSE 'Y' END 						 
   FROM SystemConfigurationKeys Where [key] = 'ShowClientPlansInToolTip'  )
   WHERE [NAME]='ClientPlans'   
   --8
   Update ClientInformationToolTipItems   
   Set  RecordDeleted = (  SELECT 'Value1' =  CASE Value WHEN 'Y' THEN 'N' WHEN 'N' THEN 'Y' ELSE 'Y' END 				 
   FROM SystemConfigurationKeys Where [key] = 'ShowMedicaidIDInToolTip'  )
   WHERE [NAME]='MedicaidID'   
   --9
   Update ClientInformationToolTipItems   
   Set  RecordDeleted = (  SELECT 'Value1' =  CASE Value WHEN 'Y' THEN 'N' WHEN 'N' THEN 'Y' ELSE 'Y' END 						 
   FROM SystemConfigurationKeys Where [key] = 'ShowPrimaryClinicianNameInToolTip'  )
   WHERE [NAME]='PrimaryClinicianName'   
   --10
   Update ClientInformationToolTipItems   
   Set  RecordDeleted = (  SELECT 'Value1' =  CASE Value WHEN 'Y' THEN 'N' WHEN 'N' THEN 'Y' ELSE 'Y' END 					 
   FROM SystemConfigurationKeys Where [key] = 'ShowPrimaryProgramInToolTip'  )
   WHERE [NAME]='PrimaryProgram'   
   --11
   Update ClientInformationToolTipItems   
   Set  RecordDeleted = (  SELECT 'Value1' =  CASE Value WHEN 'Y' THEN 'N' WHEN 'N' THEN 'Y' ELSE 'Y' END 					 
   FROM SystemConfigurationKeys Where [key] = 'ShowResidentialUnitBedInToolTip'  )
   WHERE [NAME]='ResidentialUnitBed'   
   --12
   Update ClientInformationToolTipItems   
   Set  RecordDeleted = (  SELECT 'Value1' =  CASE Value WHEN 'Y' THEN 'N' WHEN 'N' THEN 'Y' ELSE 'Y' END 						 
   FROM SystemConfigurationKeys Where [key] = 'ShowMedicationInToolTip'  )
   WHERE [NAME]='Medication'   
   --13
   Update ClientInformationToolTipItems   
   Set  RecordDeleted = (  SELECT 'Value1' =  CASE Value WHEN 'Y' THEN 'N' WHEN 'N' THEN 'Y' ELSE 'Y' END 					 
   FROM SystemConfigurationKeys Where [key] = 'ShowRecentCoveragePlan'  )
   WHERE [NAME]='RecentCoveragePlan'   
   --14
   Update ClientInformationToolTipItems   
   Set  RecordDeleted = (  SELECT 'Value1' =  CASE Value WHEN 'Y' THEN 'N' WHEN 'N' THEN 'Y' ELSE 'Y' END 					 
   FROM SystemConfigurationKeys Where [key] = 'ShowClientDateOfEnrollment'  )
   WHERE [NAME]='ClientDateOfEnrollment'   
   --15
   Update ClientInformationToolTipItems   
   Set  RecordDeleted = (  SELECT 'Value1' = CASE Value WHEN 'Y' THEN 'N' WHEN 'N' THEN 'Y' ELSE 'Y' END 					 
   FROM SystemConfigurationKeys Where [key] = 'ShowPrimaryPharmacy'  )
   WHERE [NAME]='PrimaryPharmacy'   
   
    --16
   Update ClientInformationToolTipItems   
   Set  RecordDeleted = (  SELECT 'Value1' = CASE Value WHEN 'Y' THEN 'N' WHEN 'N' THEN 'Y' ELSE 'Y' END 					 
   FROM SystemConfigurationKeys Where [key] = 'ShowDateOfInjury'  )
   WHERE [NAME]='DateOfInjury'   
 
   