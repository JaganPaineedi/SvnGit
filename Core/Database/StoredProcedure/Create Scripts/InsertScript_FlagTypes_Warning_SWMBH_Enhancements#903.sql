IF NOT EXISTS(SELECT * FROM FlagTypes where FlagTypeId = 10647)
BEGIN
    SET IDENTITY_INSERT FlagTypes ON
    INSERT INTO FlagTypes
    (
        FlagTypeId
        ,FlagType
        ,Active
        ,PermissionedFlag
        ,DoNotDisplayFlag
        ,NeverPopup
        ,BitmapImage
        ,Comments
    )
    Values
    (
        10647
        ,'WARNING'
        ,'Y'
        ,'N'
        ,'N'
        ,'N'
        ,0x47494638396114001400F20000C0C0C0FFFF0080808080800000000000000000000000000021F90401000000002C000000001400140000034A08BADCFE30AE41A51B2113CBB0161CE065C1C679C467A1445AAE5AAB4263EBBE3439103578911A20AE31129208BE895080149A9440A6C0991419AF48A26DCB155415DEB0581C2A9B0109003B
        ,'[Comments] - 1227'
    )
    SET IDENTITY_INSERT FlagTypes OFF
END