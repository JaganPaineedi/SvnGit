/********************************************************************************                                                    
--    
-- Copyright: Streamline Healthcare Solutions    
--    
--	Purpose: To delete the entries from Preview tables except recent data. KCMHSAS – Support Task#556
--	Author:  Anto Jenkins  
--	Date:    20 Jul 2016

*********************************************************************************/ 

DECLARE @Yesterday datetime
SET @Yesterday = DATEADD(dd,-1,getdate())

DELETE FROM ClientMedicationScriptsPreview
WHERE ModifiedDate < @Yesterday
DELETE FROM ClientMedicationInstructionsPreview
WHERE ModifiedDate < @Yesterday
DELETE FROM ClientMedicationScriptDrugsPreview
WHERE ModifiedDate < @Yesterday
DELETE FROM ClientMedicationScriptDrugStrengthsPreview
WHERE ModifiedDate < @Yesterday
DELETE FROM ClientMedicationsPreview
WHERE ModifiedDate < @Yesterday