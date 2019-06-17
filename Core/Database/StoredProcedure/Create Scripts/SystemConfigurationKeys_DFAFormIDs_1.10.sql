/********************************************************************************************
Author		:	Vinay K S
CreatedDate	:	24 Jan 2019
Purpose		:   This is to set SystemConfigurationKeys 'ShowCustomTabInRegistrationBasedOnTheseFormId' for initial 
                setup at Registration Document Gold.
                This will store 3 DFA FormId as comma(,) separated for RegistrationDocument(C).
                We will split this value field based on the comma to get Specific DFA Form Id,
                first value will use for Additional Information tab, 
                Second value will use for Episode tab 
                and third value will use for ProgramEnrollment tab',
                This as to be executed only once.
*********************************************************************************************/

IF EXISTS ( SELECT  *
                FROM    SystemConfigurationKeys
                WHERE   [Key] = 'ShowCustomTabInRegistrationBasedOnTheseFormId' )
Begin 

Declare @FormID INT
Declare @ConfigFormIDs VARCHAR(50)

select Top 1 @FormID=formid  from forms order by 1 desc
select @ConfigFormIDs=cast(@FormID+1 as varchar)+','+cast(@FormID+2 as varchar)+','+cast(@FormID+3 as varchar)


Declare @SystemConfigValue VARCHAR(50)
select @SystemConfigValue=[Value] FROM SystemConfigurationKeys WHERE [Key] = 'ShowCustomTabInRegistrationBasedOnTheseFormId' 

IF (@SystemConfigValue IS NULL) OR (@SystemConfigValue = '')
BEGIN
	UPDATE SystemConfigurationKeys 
	SET Value = @ConfigFormIDs
	Where [key]='ShowCustomTabInRegistrationBasedOnTheseFormId'
	PRINT 'Key Updated'
END

END


