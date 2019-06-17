/*update script for already existed records those have different start and end time from activityDate
Added by Kavya 03rd Nov 2017 -threshol support #743*/
UPDATE ClientActivities
SET ActivityStartTime= CONVERT(varchar(10),ActivityDate,101)+' '+LEFT(RIGHT(CONVERT(VARCHAR, ActivityStartTime, 100), 7),5),
 ActivityEndTime=CONVERT(varchar(10),ActivityDate,101)+' '+LEFT(RIGHT(CONVERT(VARCHAR, ActivityEndTime, 100), 7),5),
 ModifiedBy='ThresholdsSupport#743' ,
 ModifiedDate=getdate()
WHERE  datediff(day, ActivityDate,ISNULL(ActivityStartTime,ActivityDate)) <> 0 or datediff(day, ActivityDate,ISNULL(ActivityEndTime,ActivityDate))<>0
