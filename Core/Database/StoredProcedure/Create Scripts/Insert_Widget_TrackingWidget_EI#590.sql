-- Author: Vijay P
--Created On: 7th August 2018
--Why: Engineering Improvement Initiatives- NBL(I) - Task#590

IF NOT EXISTS (SELECT 1 FROM Widgets WHERE WidgetURL='/ActivityPages/Office/Summary/Widgets/TrackingWidget.ascx')
BEGIN
INSERT INTO Widgets (WidgetName,WidgetURL,CustomWidget,Width,Height,RefreshInterval, AutoRefreshInterval,DisplayAs)
VALUES ('Tracking Widget','/ActivityPages/Office/Summary/Widgets/TrackingWidget.ascx','N',4,2,10,3,'Tracking Widget')
END
ELSE
BEGIN
	UPDATE Widgets SET Width = 4 WHERE WidgetURL='/ActivityPages/Office/Summary/Widgets/TrackingWidget.ascx'
END