-- MSOOD 4/20/2017 PATHWAY - SUPPORT GO LIVE 159

IF NOT EXISTS(SELECT *
	FROM WIDGETS
	WHERE WIDGETNAME='Assigned Document(s)')
BEGIN
	INSERT INTO WIDGETS ( WIDGETNAME,WIDGETURL,CUSTOMWIDGET, WIDTH, HEIGHT, REFRESHINTERVAL, AUTOREFRESHINTERVAL, DISPLAYAS)
	VALUES              ( 'Assigned Document(s)', '/ACTIVITYPAGES/OFFICE/SUMMARY/WIDGETS/DOCUMENTNCMO.ASCX', 'N',2,1,10,6000,'Assigned Document(s)' )
END
GO
