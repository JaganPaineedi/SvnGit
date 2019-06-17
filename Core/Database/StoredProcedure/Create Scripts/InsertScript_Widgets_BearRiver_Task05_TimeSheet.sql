
IF NOT EXISTS (SELECT 1 FROM Widgets WHERE WidgetName='Leave Monthly Widget')
BEGIN
	INSERT INTO Widgets
	(WidgetName,WidgetURL,CustomWidget,Width,Height,DisplayAs)
	VALUES (
	'Leave Monthly Widget'
	,'Modules/Timesheet/Summary/Widget/MonthlyTimeSheetData.ascx'
	,'N'
	,3
	,1
	,'Leave Monthly Widget'
	)
END
ELSE
BEGIN
	UPDATE Widgets
	SET 
	WidgetName = 'Leave Monthly Widget'
	,WidgetURL='Modules/Timesheet/Summary/Widget/MonthlyTimeSheetData.ascx'
	,CustomWidget='N'
	,Width=3
	,Height=1
	,DisplayAs='Leave Monthly Widget'
	WHERE WidgetName='Leave Monthly Widget'
END
