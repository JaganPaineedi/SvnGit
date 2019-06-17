
IF NOT EXISTS
(
    SELECT Category
    FROM GlobalCodeCategories
    WHERE Category = 'MOBNOTIFICATIONMTD'
)
    BEGIN
        INSERT INTO GlobalCodeCategories
(Category,
 CategoryName,
 Active,
 AllowAddDelete,
 AllowCodeNameEdit,
 AllowSortOrderEdit,
 Description,
 UserDefinedCategory,
 HasSubcodes,
 UsedInPracticeManagement
)
        VALUES
('MOBNOTIFICATIONMTD',
 'Mobile Notification Method',
 'Y',
 'N',
 'N',
 'N',
 'Different types of notification methods which we are using to send notifications',
 'N',
 'N',
 'Y'
);
    END;
IF NOT EXISTS
(
    SELECT GlobalCodeId
    FROM GlobalCodes
    WHERE Category = 'MOBNOTIFICATIONMTD'
          AND Code = 'PUSHNOTIFICATION'
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
('MOBNOTIFICATIONMTD',
 'Push',
 'PUSHNOTIFICATION',
 'Mobile Push Notifications',
 'Y',
 'Y',
 1,
 NULL,
 NULL,
 NULL,
 NULL,
 NULL
);
    END;
IF NOT EXISTS
(
    SELECT GlobalCodeId
    FROM GlobalCodes
    WHERE Category = 'MOBNOTIFICATIONMTD'
          AND Code = 'EMAILNOTIFICATION'
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
('MOBNOTIFICATIONMTD',
 'Email',
 'EMAILNOTIFICATION',
 'Mobile Email Notifications',
 'Y',
 'Y',
 2,
 NULL,
 NULL,
 NULL,
 NULL,
 NULL
);
    END;
IF NOT EXISTS
(
    SELECT GlobalCodeId
    FROM GlobalCodes
    WHERE Category = 'MOBNOTIFICATIONMTD'
          AND Code = 'SMSNOTIFICATION'
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
('MOBNOTIFICATIONMTD',
 'SMS',
 'SMSNOTIFICATION',
 'Mobile SMS Notifications',
 'Y',
 'Y',
 3,
 NULL,
 NULL,
 NULL,
 NULL,
 NULL
);
    END;
GO