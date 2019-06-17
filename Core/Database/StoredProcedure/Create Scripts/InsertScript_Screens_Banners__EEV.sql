-- Insert Screens and Banners entires that related to the Banners
IF NOT EXISTS
(
    SELECT 1
    FROM screens
    WHERE screenid = 1268
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
        (1268,
         'Electronic Eligibility Verification Configurations',
         5762,
         '/Modules/ElectronicEligibilityVerification/ActivityPages/Admin/ListPages/ElectronicEligibilityVerificationConfigurations.ascx',
         NULL,
         4
        );
        SET IDENTITY_INSERT screens OFF;
    END
	ELSE
	BEGIN
		Update Screens Set ScreenUrl = '/Modules/ElectronicEligibilityVerification/ActivityPages/Admin/ListPages/ElectronicEligibilityVerificationConfigurations.ascx'
		Where ScreenId = 1268
	END
IF NOT EXISTS
(
    SELECT 1
    FROM screens
    WHERE screenid = 1269
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
        (1269,
         'Electronic Eligibility Verification Configuration',
         5761,
         '/Modules/ElectronicEligibilityVerification/ActivityPages/Admin/Detail/ElectronicEligibilityVerificationConfiguration.ascx',
         NULL,
         4
        );
        SET IDENTITY_INSERT screens OFF;
    END;
IF NOT EXISTS
(
    SELECT 1
    FROM banners
    WHERE ScreenId = 1268
          AND BannerName = 'Electronic Eligibility Verification Configurations'
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
        ('Electronic Eligibility Verification Configurations',
         'Electronic Eligibility Verification Configurations',
         'Y',
         1,
         'N',
         4,
         1268
        );
    END;