IF NOT EXISTS
(
    SELECT 1
    FROM globalcodes
    WHERE GlobalCodeId = 5767
)
    BEGIN
        SET IDENTITY_INSERT dbo.GlobalCodes ON;
        INSERT INTO globalcodes
        (GlobalCodeId,
         Category,
         CodeName,
         Description,
         Active,
         CannotModifyNameOrDelete
        )
        VALUES
        (5767,
         'SCREENTYPE',
         'API',
         NULL,
         'Y',
         'N'
        );
        SET IDENTITY_INSERT dbo.GlobalCodes OFF;
    END;
ELSE
    BEGIN
        UPDATE globalcodes
          SET
              Category = 'SCREENTYPE',
              CodeName = 'API',
              Description = NULL,
              Active = 'Y',
              CannotModifyNameOrDelete = 'N'
        WHERE GlobalCodeId = 5767;
    END;

IF NOT EXISTS
(
    SELECT 1
    FROM Tabs
    WHERE TabId = 7
)
    BEGIN
        SET IDENTITY_INSERT dbo.Tabs ON;
        INSERT INTO Tabs
        (TabId,
         TabName,
         DisplayAs,
         Dynamic,
         TabOrder,
         DefaultScreenId
        )
        VALUES
        (7,
         'API',
         'API',
         'N',
         100,
         NULL
        );
        SET IDENTITY_INSERT dbo.Tabs OFF;
    END;
ELSE
    BEGIN
        UPDATE Tabs
          SET
              TabName = 'API',
              DisplayAs = 'API',
              Dynamic = 'N',
              TabOrder = 100,
              DefaultScreenId = NULL
        WHERE TabId = 7;
    END;


-- Insert Screens and Banners entires that related to the Banners
IF NOT EXISTS
(
    SELECT 1
    FROM screens
    WHERE screenid = 1271
)
    BEGIN
        SET IDENTITY_INSERT screens ON;
        INSERT INTO screens
        (screenid,
         screenname,
         screentype,
         screenurl,
         screentoolbarurl,
         tabid
        )
        VALUES
        (1271,
         '/api/Patient/Id',
         5767,
         '/api/Patient/Id',
         NULL,
         7
        );
        SET IDENTITY_INSERT screens OFF;
    END;
IF NOT EXISTS
(
    SELECT 1
    FROM screens
    WHERE screenid = 1272
)
    BEGIN
        SET IDENTITY_INSERT screens ON;
        INSERT INTO screens
        (screenid,
         screenname,
         screentype,
         screenurl,
         screentoolbarurl,
         tabid
        )
        VALUES
        (1272,
         '/api/Patient/Details',
         5767,
         '/api/Patient/Details',
         NULL,
         7
        );
        SET IDENTITY_INSERT screens OFF;
    END;
IF NOT EXISTS
(
    SELECT 1
    FROM screens
    WHERE screenid = 1273
)
    BEGIN
        SET IDENTITY_INSERT screens ON;
        INSERT INTO screens
        (screenid,
         screenname,
         screentype,
         screenurl,
         screentoolbarurl,
         tabid
        )
        VALUES
        (1273,
         '/api/Patient/SummaryOfCareCCDXML',
         5767,
         '/api/Patient/SummaryOfCareCCDXML',
         NULL,
         7
        );
        SET IDENTITY_INSERT screens OFF;
    END;
IF NOT EXISTS
(
    SELECT 1
    FROM screens
    WHERE screenid = 1274
)
    BEGIN
        SET IDENTITY_INSERT screens ON;
        INSERT INTO screens
        (screenid,
         screenname,
         screentype,
         screenurl,
         screentoolbarurl,
         tabid
        )
        VALUES
        (1274,
         '/api/Patient/DemographicDetails',
         5767,
         '/api/Patient/DemographicDetails',
         NULL,
         7
        );
        SET IDENTITY_INSERT screens OFF;
    END;
IF NOT EXISTS
(
    SELECT 1
    FROM screens
    WHERE screenid = 1275
)
    BEGIN
        SET IDENTITY_INSERT screens ON;
        INSERT INTO screens
        (screenid,
         screenname,
         screentype,
         screenurl,
         screentoolbarurl,
         tabid
        )
        VALUES
        (1275,
         '/api/Patient/Allergies',
         5767,
         '/api/Patient/Allergies',
         NULL,
         7
        );
        SET IDENTITY_INSERT screens OFF;
    END;
IF NOT EXISTS
(
    SELECT 1
    FROM screens
    WHERE screenid = 1276
)
    BEGIN
        SET IDENTITY_INSERT screens ON;
        INSERT INTO screens
        (screenid,
         screenname,
         screentype,
         screenurl,
         screentoolbarurl,
         tabid
        )
        VALUES
        (1276,
         '/api/Patient/CurrentMedications',
         5767,
         '/api/Patient/CurrentMedications',
         NULL,
         7
        );
        SET IDENTITY_INSERT screens OFF;
    END;
IF NOT EXISTS
(
    SELECT 1
    FROM screens
    WHERE screenid = 1277
)
    BEGIN
        SET IDENTITY_INSERT screens ON;
        INSERT INTO screens
        (screenid,
         screenname,
         screentype,
         screenurl,
         screentoolbarurl,
         tabid
        )
        VALUES
        (1277,
         '/api/Patient/ActiveProblems',
         5767,
         '/api/Patient/ActiveProblems',
         NULL,
         7
        );
        SET IDENTITY_INSERT screens OFF;
    END;
IF NOT EXISTS
(
    SELECT 1
    FROM screens
    WHERE screenid = 1278
)
    BEGIN
        SET IDENTITY_INSERT screens ON;
        INSERT INTO screens
        (screenid,
         screenname,
         screentype,
         screenurl,
         screentoolbarurl,
         tabid
        )
        VALUES
        (1278,
         '/api/Patient/HistoryOfEncounters',
         5767,
         '/api/Patient/HistoryOfEncounters',
         NULL,
         7
        );
        SET IDENTITY_INSERT screens OFF;
    END;
IF NOT EXISTS
(
    SELECT 1
    FROM screens
    WHERE screenid = 1279
)
    BEGIN
        SET IDENTITY_INSERT screens ON;
        INSERT INTO screens
        (screenid,
         screenname,
         screentype,
         screenurl,
         screentoolbarurl,
         tabid
        )
        VALUES
        (1279,
         '/api/Patient/Immunizations',
         5767,
         '/api/Patient/Immunizations',
         NULL,
         7
        );
        SET IDENTITY_INSERT screens OFF;
    END;
IF NOT EXISTS
(
    SELECT 1
    FROM screens
    WHERE screenid = 1280
)
    BEGIN
        SET IDENTITY_INSERT screens ON;
        INSERT INTO screens
        (screenid,
         screenname,
         screentype,
         screenurl,
         screentoolbarurl,
         tabid
        )
        VALUES
        (1280,
         '/api/Patient/SocialHistory',
         5767,
         '/api/Patient/SocialHistory',
         NULL,
         7
        );
        SET IDENTITY_INSERT screens OFF;
    END;
IF NOT EXISTS
(
    SELECT 1
    FROM screens
    WHERE screenid = 1281
)
    BEGIN
        SET IDENTITY_INSERT screens ON;
        INSERT INTO screens
        (screenid,
         screenname,
         screentype,
         screenurl,
         screentoolbarurl,
         tabid
        )
        VALUES
        (1281,
         '/api/Patient/VitalSigns',
         5767,
         '/api/Patient/VitalSigns',
         NULL,
         7
        );
        SET IDENTITY_INSERT screens OFF;
    END;
IF NOT EXISTS
(
    SELECT 1
    FROM screens
    WHERE screenid = 1282
)
    BEGIN
        SET IDENTITY_INSERT screens ON;
        INSERT INTO screens
        (screenid,
         screenname,
         screentype,
         screenurl,
         screentoolbarurl,
         tabid
        )
        VALUES
        (1282,
         '/api/Patient/PlanOfTreatment',
         5767,
         '/api/Patient/PlanOfTreatment',
         NULL,
         7
        );
        SET IDENTITY_INSERT screens OFF;
    END;
IF NOT EXISTS
(
    SELECT 1
    FROM screens
    WHERE screenid = 1283
)
    BEGIN
        SET IDENTITY_INSERT screens ON;
        INSERT INTO screens
        (screenid,
         screenname,
         screentype,
         screenurl,
         screentoolbarurl,
         tabid
        )
        VALUES
        (1283,
         '/api/Patient/Goals',
         5767,
         '/api/Patient/Goals',
         NULL,
         7
        );
        SET IDENTITY_INSERT screens OFF;
    END;
IF NOT EXISTS
(
    SELECT 1
    FROM screens
    WHERE screenid = 1284
)
    BEGIN
        SET IDENTITY_INSERT screens ON;
        INSERT INTO screens
        (screenid,
         screenname,
         screentype,
         screenurl,
         screentoolbarurl,
         tabid
        )
        VALUES
        (1284,
         '/api/Patient/HistoryOfProcedures',
         5767,
         '/api/Patient/HistoryOfProcedures',
         NULL,
         7
        );
        SET IDENTITY_INSERT screens OFF;
    END;
IF NOT EXISTS
(
    SELECT 1
    FROM screens
    WHERE screenid = 1285
)
    BEGIN
        SET IDENTITY_INSERT screens ON;
        INSERT INTO screens
        (screenid,
         screenname,
         screentype,
         screenurl,
         screentoolbarurl,
         tabid
        )
        VALUES
        (1285,
         '/api/Patient/StudiesSummary',
         5767,
         '/api/Patient/StudiesSummary',
         NULL,
         7
        );
        SET IDENTITY_INSERT screens OFF;
    END;
IF NOT EXISTS
(
    SELECT 1
    FROM screens
    WHERE screenid = 1286
)
    BEGIN
        SET IDENTITY_INSERT screens ON;
        INSERT INTO screens
        (screenid,
         screenname,
         screentype,
         screenurl,
         screentoolbarurl,
         tabid
        )
        VALUES
        (1286,
         '/api/Patient/LaboratoryTests',
         5767,
         '/api/Patient/LaboratoryTests',
         NULL,
         7
        );
        SET IDENTITY_INSERT screens OFF;
    END;
IF NOT EXISTS
(
    SELECT 1
    FROM screens
    WHERE screenid = 1287
)
    BEGIN
        SET IDENTITY_INSERT screens ON;
        INSERT INTO screens
        (screenid,
         screenname,
         screentype,
         screenurl,
         screentoolbarurl,
         tabid
        )
        VALUES
        (1287,
         '/api/Patient/CareTeamMembers',
         5767,
         '/api/Patient/CareTeamMembers',
         NULL,
         7
        );
        SET IDENTITY_INSERT screens OFF;
    END;
IF NOT EXISTS
(
    SELECT 1
    FROM screens
    WHERE screenid = 1288
)
    BEGIN
        SET IDENTITY_INSERT screens ON;
        INSERT INTO screens
        (screenid,
         screenname,
         screentype,
         screenurl,
         screentoolbarurl,
         tabid
        )
        VALUES
        (1288,
         '/api/Patient/UniqueDeviceIdentifier',
         5767,
         '/api/Patient/UniqueDeviceIdentifier',
         NULL,
         7
        );
        SET IDENTITY_INSERT screens OFF;
    END;
IF NOT EXISTS
(
    SELECT 1
    FROM screens
    WHERE screenid = 1289
)
    BEGIN
        SET IDENTITY_INSERT screens ON;
        INSERT INTO screens
        (screenid,
         screenname,
         screentype,
         screenurl,
         screentoolbarurl,
         tabid
        )
        VALUES
        (1289,
         '/api/Account/ValidateSmartKey',
         5767,
         '/api/Account/ValidateSmartKey',
         NULL,
         7
        );
        SET IDENTITY_INSERT screens OFF;
    END;
IF NOT EXISTS
(
    SELECT 1
    FROM screens
    WHERE screenid = 1290
)
    BEGIN
        SET IDENTITY_INSERT screens ON;
        INSERT INTO screens
        (screenid,
         screenname,
         screentype,
         screenurl,
         screentoolbarurl,
         tabid
        )
        VALUES
        (1290,
         '/api/Briefcase',
         5767,
         '/api/Briefcase',
         NULL,
         7
        );
        SET IDENTITY_INSERT screens OFF;
    END;
IF NOT EXISTS
(
    SELECT 1
    FROM screens
    WHERE screenid = 1291
)
    BEGIN
        SET IDENTITY_INSERT screens ON;
        INSERT INTO screens
        (screenid,
         screenname,
         screentype,
         screenurl,
         screentoolbarurl,
         tabid
        )
        VALUES
        (1291,
         '/api/calendarevent',
         5767,
         '/api/calendarevent',
         NULL,
         7
        );
        SET IDENTITY_INSERT screens OFF;
    END;
	
IF NOT EXISTS
(
    SELECT 1
    FROM screens
    WHERE Code = 'REGISTERFORMOBILENOTIFICATIONS'
)
    BEGIN
        --SET IDENTITY_INSERT screens ON;
        INSERT INTO screens
        (screenname,
         screentype,
         screenurl,
         screentoolbarurl,
         tabid,
		 Code
        )
        VALUES
        ('/api/MyPreference/RegisterForMobileNotifications',
         5767,
         '/api/MyPreference/RegisterForMobileNotifications',
         NULL,
         7,
		 'REGISTERFORMOBILENOTIFICATIONS'
        );
        --SET IDENTITY_INSERT screens OFF;
    END;	