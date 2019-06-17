/********************************************************************************************
Author			:  AlokKumar Meher 
CreatedDate		:  10 Aug 2018 
Purpose			:  Insert script for SystemConfigurationKeys
*********************************************************************************************/

DECLARE @ScreenId INT
DECLARE @ScreenCode VARCHAR(100)

SET @ScreenCode = 'BDE62873-41E5-4842-AB04-C7E4D6D32C8D'
SET @ScreenId = (Select  top 1 ScreenId from Screens WHERE  Code = @ScreenCode)
--Print @ScreenId


IF NOT EXISTS ( SELECT  *
                FROM    SystemConfigurationKeys
                WHERE   [Key] = 'ShowCustomTabInRegistrationBasedOnTheseFormId' )
    BEGIN

        INSERT  INTO SystemConfigurationKeys
                ( [Key] ,
                  [Value] ,
                  [Description] ,
                  [AcceptedValues],
                  [ShowKeyForViewingAndEditing],
                  [Modules],
				  [Screens],
				  [Comments],
				  [SourceTableName],
				  [AllowEdit]
                )
        VALUES  ( 'ShowCustomTabInRegistrationBasedOnTheseFormId',
                  '',
                  'This will store 3 DFA FormId as comma(,) separated for RegistrationDocument(C). We will split this value field based on the comma to get Specific DFA Form Id, first value will use for Additional Information tab, Second value will use for Episode tab and third value will use for ProgramEnrollment tab',
                  'Numeric Values,Null,empty',
                  'Y',
                  'Registration Document(C)',
                  @ScreenId, 
                  NULL, 
                  NULL, 
                  'Y' 
                );
 
    END;
    