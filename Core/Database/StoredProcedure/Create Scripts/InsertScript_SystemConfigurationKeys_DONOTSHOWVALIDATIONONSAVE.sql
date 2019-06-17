--System configuration key 'DONOTSHOWVALIDATIONONSAVE' for task - Harbor - Support #1456.

--To configure Show OR Do Not show Validation For Duration on Click Save.

IF NOT EXISTS
( 
   SELECT 1 FROM dbo.SystemConfigurationKeys WHERE [Key] = 'DurationRequiredOnSaveForShowStatus'
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
VALUES  ( 'DurationRequiredOnSaveForShowStatus'
        , 'Y'
        , 'on status = schedule require a duration on save AND on status = show - do not required duration on save.'
        , 'Y,N'
        , 'Y'
        , 'Services'
        , 'Service Note'
        , 'Y'
        )
END

