/***********************************************************************************************************
Created By: Ajay K Bangar
Task : Key Point - Environment Issues Tracking: #251
Created On: 02-Fab-2016
Purpose : This Function use to set start and End time in same day as in Activity Date.
***********************************************************************************************************/
UPDATE ClientActivities 
SET    ActivityStartTime = CONVERT(DATETIME, CONVERT(CHAR(8), ActivityDate, 112) 
                                             + ' ' 
                                             + CONVERT(CHAR(8), 
                                             ActivityStartTime, 108) 
                                  ), 
       ActivityEndTime = CONVERT(DATETIME, CONVERT(CHAR(8), ActivityDate, 112) + 
                                           ' ' 
                                           + CONVERT(CHAR(8), ActivityEndTime, 
                                           108)) 
WHERE  Isnull(RecordDeleted, 'N') = 'N' 
       AND ( ActivityStartTime <> CONVERT(DATETIME, 
                                  CONVERT(CHAR(8), ActivityDate, 112) + 
                                  ' ' 
                                  + CONVERT(CHAR(8), 
                                  ActivityStartTime, 
                                      108 
                                        )) 
              OR ActivityEndTime <> CONVERT(DATETIME, 
                                    CONVERT(CHAR(8), ActivityDate, 
                                    112) + 
                                    ' ' 
                                    + CONVERT(CHAR(8), 
                                    ActivityEndTime, 
                                    108 
                                    )) ) 