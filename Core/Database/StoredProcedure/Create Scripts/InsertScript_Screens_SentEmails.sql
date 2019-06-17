IF NOT EXISTS (SELECT 1 FROM Screens WHERE ScreenId = 885)
BEGIN
    SET IDENTITY_INSERT dbo.Screens ON;
    INSERT INTO dbo.Screens (ScreenId,
                             ScreenName,
                             ScreenType,
                             ScreenURL,
                             ScreenToolbarURL,
                             TabId,
                             InitializationStoredProcedure)
    SELECT 885,
           'Send Email',
           5761,
           '/Modules/SendEmail/WebPages/SendEmail.ascx',
           NULL,
           2,
           'ssp_SCInitSendEmail';
    SET IDENTITY_INSERT dbo.Screens OFF;
END;
IF NOT EXISTS (SELECT 1 FROM Screens WHERE ScreenId = 886)
BEGIN
    SET IDENTITY_INSERT dbo.Screens ON;
    INSERT INTO dbo.Screens (ScreenId,
                             ScreenName,
                             ScreenType,
                             ScreenURL,
                             ScreenToolbarURL,
                             TabId)
    SELECT 886,
           'Send Email Upload Attachment',
           5765,
           '/Modules/SendEmail/WebPages/SendEmailUploadAttachment.ascx',
           NULL,
           2;
    SET IDENTITY_INSERT dbo.Screens OFF;
END;