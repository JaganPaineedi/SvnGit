
/*********************************************** *****************************************/
/*	Author : Seema Thakur                                                                */
/*  Date   : 03-Feb-2016																 */
/*  Purpose : Task #369 Philhaven Development.                                                                                  */
/*****************************************************************************************/


IF NOT EXISTS (SELECT * FROM SystemConfigurationKeys WHERE [Key] = 'SetDefaultAttending')
BEGIN
INSERT INTO [dbo].[SystemConfigurationKeys]
        ( [Key]
        , [Value]
        , [Description]
        , [AcceptedValues]
        , [ShowKeyForViewingAndEditing]
        , [Modules]
        , [Screens]
        , [Comments]
        )
VALUES  ( 'SetDefaultAttending'  -- Key - varchar(200)
        , 'N'  -- Value - varchar(max)
        , 'This key is used to set Default staff Attending, If SetDefaultAttending is "Y" then AttendingId is fetched from Clients.'  -- Description - type_Comment2
        , 'Y,N'  -- AcceptedValues - varchar(max)
        , 'Y' -- ShowKeyForViewingAndEditing - type_YOrN
        , 'Service Detail\Service Note'  -- Modules - varchar(500)
        , null  -- Screens - varchar(500)
        , null  -- Comments - type_Comment2
        )            
 END
ELSE
BEGIN
UPDATE [SystemConfigurationKeys]
       SET [Value] = 'N'
       ,[Description]='This key is used to set Default staff Attending, If SetDefaultAttending if "Y" then AttendingId is fetched from Clients.' 
       , [AcceptedValues]='Y,N'
       , [ShowKeyForViewingAndEditing]='Y'
       , [Modules]='Service Detail\Service Note'
       , [Screens]=null
       , [Comments]=null
       WHERE [Key] = 'SetDefaultAttending'
END

