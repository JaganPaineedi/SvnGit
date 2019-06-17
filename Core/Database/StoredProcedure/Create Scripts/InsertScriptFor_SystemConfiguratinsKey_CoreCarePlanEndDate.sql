
/*********************************************** *****************************************/
/*	Author : Pradeep Kumar Yadav                                                               */
/*  Date   : 15-Mar-2017																 */
/*  Purpose : Task #340 Pathway - Support Go Live                                                                                  */
/*****************************************************************************************/


IF NOT EXISTS (SELECT * FROM SystemConfigurationKeys WHERE [Key] = 'SetDurationForCoreCarePlanEndDate')
BEGIN
INSERT INTO [dbo].[SystemConfigurationKeys]
        ([Key]
        ,[Value]
        ,[Description]
        ,[AllowEdit]
        ,[AcceptedValues]
        ,[ShowKeyForViewingAndEditing]
        ,[Screens]
        ,[Comments]
        )
VALUES  ('SetDurationForCoreCarePlanEndDate'  -- Key - varchar(200)
        ,'180'  -- Value - varchar(max)
        ,'This key is used to determine Core care Plan End Date.'  -- Description - type_Comment2
        ,'Y'
        ,'It start from atlease 1 day and you can put as many days you want'
        ,'Y'
        , null  -- Screens - varchar(500)
        , null  -- Comments - type_Comment2
        )            
 END
 
 


