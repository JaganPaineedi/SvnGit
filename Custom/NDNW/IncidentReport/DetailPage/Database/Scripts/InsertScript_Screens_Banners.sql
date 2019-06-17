-- Insert Screens and Banners entires that related to the Banners
IF NOT EXISTS (
		SELECT *
		FROM screens
		WHERE screenid = 62004
		)
BEGIN
	SET IDENTITY_INSERT screens ON

	INSERT INTO screens (
		screenid
		,screenname
		,screentype
		,screenurl
		,screentoolbarurl
		,tabid
		,initializationstoredprocedure
		,validationstoredprocedurecomplete
		,ValidationStoredProcedureUpdate
		,postupdatestoredprocedure
		,documentcodeid
		)
	VALUES (
		62004
		,'Incident Report'
		,5761
		,'/Custom/IncidentReport/DetailPage/WebPages/IncidentReport.ascx'
		,NULL
		,1
		,'csp_InitIncidentReport'
		,NULL
		,'csp_SCValidateIncidentReport'
		,'csp_SCPostUpdateIncidentReport'
		,NULL
		)

	SET IDENTITY_INSERT screens OFF
END
ELSE
BEGIN
	UPDATE screens
	SET screenname = 'Incident Report'
		,screentype = 5761
		,screenurl = '/Custom/IncidentReport/DetailPage/WebPages/IncidentReport.ascx'
		,screentoolbarurl = NULL
		,tabid = 1
		,initializationstoredprocedure = 'csp_InitIncidentReport'
		,validationstoredprocedurecomplete = NULL
		,ValidationStoredProcedureUpdate = 'csp_SCValidateIncidentReport'
		,postupdatestoredprocedure = 'csp_SCPostUpdateIncidentReport'
		,documentcodeid = NULL
	WHERE screenid = 62004
END
		--IF NOT EXISTS(SELECT * 
		--              FROM   banners 
		--              WHERE  ScreenId =62004 
		--              AND BannerName='Incident Report') 
		--  BEGIN 
		--      INSERT INTO banners 
		--              (BannerName, 
		--		 DisplayAs, 
		--		 Active, 
		--		 DefaultOrder, 
		--		 Custom, 
		--		 TabId, 
		--		 ScreenId, 
		--		 ScreenParameters, 
		--		 ParentBannerId) 
		--      VALUES     ('Incident Report', 
		--                  'Incident Report', 
		--                  'N', 
		--                  1, 
		--                  'N', 
		--                  2, 
		--                  62004, 
		--                  NULL,
		--                  NULL) 
		--END 
