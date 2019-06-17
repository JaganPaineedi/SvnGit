 ----------------Update the ssps to csps to make the treatment plan as custom for ARM----------------------
 
 UPDATE dc
 SET    StoredProcedure = 'csp_ScWebGetTreatmentPlanInitial'
 FROM   documentcodes dc
 WHERE  dc.StoredProcedure = 'ssp_ScWebGetTreatmentPlanInitial' and DocumentCodeId=1483
 
 UPDATE dc
 SET    StoredProcedure = 'csp_ScWebGetTreatmentPlanUpdate'
 FROM   documentcodes dc
 WHERE  dc.StoredProcedure = 'ssp_ScWebGetTreatmentPlanUpdate' and DocumentCodeId in (1484,1485)
 
 UPDATE s
 SET    InitializationStoredProcedure = 'csp_ScwebInitializeTreatmentPlanInitial'
 FROM   screens s
 WHERE  s.InitializationStoredProcedure = 'ssp_ScwebInitializeTreatmentPlanInitial' and DocumentCodeId=1483
 
 UPDATE s
 SET    InitializationStoredProcedure = 'csp_ScwebInitializeTreatmentPlanUpdate'
 FROM   screens s
 WHERE  s.InitializationStoredProcedure = 'ssp_ScwebInitializeTreatmentPlanUpdate' and DocumentCodeId=1484
 
 UPDATE s
 SET    InitializationStoredProcedure = 'csp_ScwebInitializeTreatmentPlanReview'
 FROM   screens s
 WHERE  s.InitializationStoredProcedure = 'ssp_ScwebInitializeTreatmentPlanReview' and DocumentCodeId=1485