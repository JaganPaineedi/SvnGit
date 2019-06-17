------------------------------ Spring River-Support Go Live #298 ----------------------------------
------------------------- Author : Vsinha -------- Date: 09/07/2018----------------------------------
 /*
Key : SetNumberValueToCalculateEndDateForAddendumCarePlan
Default Value: 180

Allowed Values:
Integer (Number of Days) For Example: 90,180... etc.

Read Key as --- Set Number Value To Calculate EndDate For Addendum CarePlan. Enter the number of Month(s) here, which is used to calculate the Addendum Care Plan End Date based on signed Initial/Annual Care Plan's Effective date.

Description:
When the value of the key 'SetNumberValueToCalculateEndDateForAddendumCarePlan' is set to as Integer value which will indicate the number of Days, based on this key value, system will set the End Date of Addendum Care Plan based on sigend Intial/Annual Care Plan's Effective Date. 
*/

IF NOT EXISTS ( SELECT  *
                FROM    SystemConfigurationKeys
                WHERE   [Key] = 'SetNumberValueToCalculateEndDateForAddendumCarePlan' )
    BEGIN

        INSERT  INTO SystemConfigurationKeys
                ( [CreatedBy],
				  [CreateDate],
				  [ModifiedBy],
				  [ModifiedDate],
                  [Key] ,
                  [Value] ,
                  [Description] ,
                  [AcceptedValues],
                  [ShowKeyForViewingAndEditing],
                  [AllowEdit]
                )
        VALUES  (  'Spring River-SGL#298' 
				  , GETDATE()
				  , 'Spring River-SGL#298'
				  , GETDATE()
                  ,'SetNumberValueToCalculateEndDateForAddendumCarePlan' 
                  ,'180' 
                  ,'Set Naluumber Ve To Calculate EndDate For Addendum CarePlan. Enter the number of Days(s) here, which is used to calculate the Addendum Care Plan End Date based on signed Initial/Annual Care Plan''s Effective date.' 
                  ,'Number of Days in Digit'
                  ,'Y'
                  ,'Y'
                );
 
    END;


