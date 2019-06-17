
IF NOT EXISTS
(
    SELECT GlobalCodeId
    FROM GlobalCodes
    WHERE GlobalCodeId = 5933
          AND Category = 'PERMISSIONTEMPLATETP'
          AND Code = 'NOTIFICATIONS'
)
    BEGIN
        SET IDENTITY_INSERT GlobalCodes ON;
        INSERT INTO GlobalCodes
(GlobalCodeId,
 Category,
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
(5933,
 'PERMISSIONTEMPLATETP',
 'Notifications',
 'NOTIFICATIONS',
 'New permission template for Mobile Notifications',
 'Y',
 'Y',
 NULL,
 NULL,
 NULL,
 NULL,
 NULL,
 NULL
);
        SET IDENTITY_INSERT GlobalCodes OFF;
    END;
GO
