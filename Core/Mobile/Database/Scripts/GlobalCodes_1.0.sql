
IF NOT EXISTS
(
    SELECT GlobalCodeId
    FROM GlobalCodes
    WHERE Category = 'NOTIFICATIONTYPE'
          AND Code = 'NOTIFICATIONTYPEFLAGS'
)
    BEGIN
        INSERT INTO GlobalCodes
(Category,
 CodeName,
 Code,
 Description,
 Active,
 CannotModifyNameOrDelete,
 SortOrder,
 ExternalCode1,
 ExternalSource1,
 ExternalCode2,
 ExternalSource2,
 Bitmap
)
        VALUES
('NOTIFICATIONTYPE',
 'Flags',
 'NOTIFICATIONTYPEFLAGS',
 'Mobile Flag Notifications',
 'Y',
 'Y',
 4,
 NULL,
 NULL,
 NULL,
 NULL,
 NULL
);
    END;
GO