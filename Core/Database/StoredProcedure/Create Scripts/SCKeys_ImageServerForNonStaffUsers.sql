--System configuration key 'DONOTSHOWVALIDATIONONSAVE' for task - Harbor - Support #1456.

--To configure Show OR Do Not show Validation For Duration on Click Save.

IF NOT EXISTS
( 
   SELECT 1 FROM dbo.SystemConfigurationKeys WHERE [Key] = 'ImageServerForNonStaffUsers'
 )

BEGIN
INSERT  INTO [SystemConfigurationKeys]
        ( [Key]
        , [Value]
        , [Description]
        , [AcceptedValues]
        , [ShowKeyForViewingAndEditing]
        , [Modules]
        , [Screens]
        , [AllowEdit]
        )
VALUES  ( 'ImageServerForNonStaffUsers'
        , '2'
        , 'Image Servers For non staff users.'
        , 'Integer'
        , 'Y'
        , 'Scanning'
        , 'Non Staff User scanning'
        , 'Y'
        )
END

