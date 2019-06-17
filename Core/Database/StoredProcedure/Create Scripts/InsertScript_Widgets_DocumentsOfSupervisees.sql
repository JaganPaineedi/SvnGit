
IF NOT EXISTS (SELECT 1 FROM Widgets WHERE WidgetName='Documents of Supervisees')
BEGIN
	INSERT INTO Widgets
	(WidgetName,WidgetURL,CustomWidget,Width,Height,DisplayAs)
	VALUES (
	'Documents of Supervisees'
	,'/ActivityPages/Office/Summary/Widgets/DocumentsOfSupervisees.ascx'
	,'N'
	,2
	,1
	,'Documents of Supervisees'
	)
END
ELSE
BEGIN
	UPDATE Widgets
	SET 
	WidgetName = 'Documents of Supervisees'
	,WidgetURL='/ActivityPages/Office/Summary/Widgets/DocumentsOfSupervisees.ascx'
	,CustomWidget='N'
	,Width=2
	,Height=1
	,DisplayAs='Documents of Supervisees'
	WHERE WidgetName='Documents of Supervisees'
END
