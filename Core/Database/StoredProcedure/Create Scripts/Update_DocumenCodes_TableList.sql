/*Neha added a new table called MedicationReconciliationExternalMedications to the table list to handle 
the other external medications.*/
UPDATE DocumentCodes
SET TableList = 'DocumentMedicationReconciliations,MedicationReconciliationCurrentMedications,MedicationReconciliationCCDMedications,MedicationReconciliationExternalMedications,ClientMedicationInstructions'
WHERE DocumentCodeId = 1643
