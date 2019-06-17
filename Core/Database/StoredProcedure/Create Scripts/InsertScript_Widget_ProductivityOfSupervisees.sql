
IF NOT EXISTS (SELECT 1 FROM Widgets WHERE WidgetName='Productivity of Supervisees')
BEGIN
	INSERT INTO Widgets
	(WidgetName,WidgetURL,CustomWidget,Width,Height,DisplayAs)
	VALUES (
	'Productivity of Supervisees'
	,'/ActivityPages/Office/Summary/Widgets/ProductivityOfSupervisees.ascx'
	,'N'
	,2
	,1
	,'Productivity of Supervisees'
	)
END
ELSE
BEGIN
	UPDATE Widgets
	SET 
	WidgetName = 'Productivity of Supervisees'
	,WidgetURL='/ActivityPages/Office/Summary/Widgets/ProductivityOfSupervisees.ascx'
	,CustomWidget='N'
	,Width=2
	,Height=1
	,DisplayAs='Productivity of Supervisees'
	WHERE WidgetName='Productivity of Supervisees'
END
