--System configuration key 'ReceptionPaymentPopupAutoPostDropdown' for task - Core Bugs #2404.
--Accepted values should be Global code Ids.


IF NOT EXISTS
( 
   SELECT 1 FROM dbo.SystemConfigurationKeys WHERE [Key] = 'SetReceptionPaymentPopupAutoPostDropdownDefault'
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
VALUES  ( 'SetReceptionPaymentPopupAutoPostDropdownDefault'
        , '8712'
        , 'To default the auto post drop down value to a specific global code.'
        , 'Accepted values should be Global code Ids'
        , 'Y'
        , 'Reception'
        , 'Reception Popup'
        , 'Y'
        )
END

