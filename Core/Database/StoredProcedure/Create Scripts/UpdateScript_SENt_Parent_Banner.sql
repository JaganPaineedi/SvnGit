DECLARE @ParentBannerId INT;
IF NOT EXISTS
(
    SELECT 1
    FROM banners
    WHERE BannerName = 'SENt Services'
)
    BEGIN
        INSERT INTO banners
        (BannerName,
         DisplayAs,
         Active,
         DefaultOrder,
         Custom,
         TabId,
         ScreenId
        )
        VALUES
        ('SENt Services',
         'SENt Services',
         'Y',
         1,
         'N',
         4,
         NULL
        );
        SET @ParentBannerId = SCOPE_IDENTITY();
    END;
ELSE
    BEGIN
        SELECT TOP 1 @ParentBannerId = BannerId
        FROM Banners
        WHERE BannerName = 'SENt Services';
    END;
IF EXISTS
(
    SELECT 1
    FROM banners
    WHERE ScreenId = 1268
          AND BannerName = 'Electronic Eligibility Verification Configurations'
)
    BEGIN
        UPDATE Banners
          SET
              ParentBannerId = @ParentBannerId
        WHERE ScreenId = 1268
              AND BannerName = 'Electronic Eligibility Verification Configurations';
    END;
IF EXISTS
(
    SELECT 1
    FROM banners
    WHERE ScreenId = 1030
          AND BannerName = 'Messages Interface'
)
    BEGIN
        UPDATE Banners
          SET
              ParentBannerId = @ParentBannerId
        WHERE ScreenId = 1030
              AND BannerName = 'Messages Interface';
    END;
IF EXISTS
(
    SELECT 1
    FROM banners
    WHERE ScreenId = 1187
          AND BannerName = 'LabSoft Messages Interface'
)
    BEGIN
        UPDATE Banners
          SET
              ParentBannerId = @ParentBannerId
        WHERE ScreenId = 1187
              AND BannerName = 'LabSoft Messages Interface';
    END;