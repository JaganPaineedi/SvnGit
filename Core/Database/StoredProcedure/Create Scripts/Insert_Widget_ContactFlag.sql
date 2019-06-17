IF NOT EXISTS (SELECT 1 FROM Widgets WHERE WidgetURL='/ActivityPages/Office/Summary/Widgets/ContactsFlags.ascx')
BEGIN
INSERT INTO Widgets (WidgetName,WidgetURL,CustomWidget,Width,Height,RefreshInterval, AutoRefreshInterval,DisplayAs)
VALUES ('Contacts/ Flags Widget','/ActivityPages/Office/Summary/Widgets/ContactsFlags.ascx','N',1,1,400,77777,'Contacts/ Flags Widget')
END


