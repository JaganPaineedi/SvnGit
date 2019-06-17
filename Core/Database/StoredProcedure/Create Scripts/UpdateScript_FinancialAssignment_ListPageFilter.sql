-- To update existing financial Assingment for List Page filter 

Update FinancialAssignments 
SET ListPageFilter='Y', AllChargeAdjustmentCodes='Y', AllServiceClinicians ='Y'
WHERE ISNULL(RecordDeleted,'N')<>'Y'
 