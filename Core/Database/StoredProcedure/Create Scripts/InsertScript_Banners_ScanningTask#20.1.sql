SET IDENTITY_INSERT Screens on
    IF NOT EXISTS(SELECT * FROM Screens WHERE ScreenId=1259)
	INSERT INTO Screens
	(ScreenId, ScreenName, ScreenType, ScreenURL,TabId,ScreenToolbarURL)
	VALUES 
	(1259,'Scanning',5762,'/ActivityPages/Office/ListPages/ImageRecordsList.ascx',2,'/ScreenToolBars/ImageRecordsListPageToolBar.ascx')
	else
	update Screens set
	ScreenName='Scanning',
	ScreenType=5762,
	ScreenURL='/ActivityPages/Office/ListPages/ImageRecordsList.ascx',
	TabId=2,
	ScreenToolbarURL='/ScreenToolBars/ImageRecordsListPageToolBar.ascx'
	where ScreenId=1259
		
	
    IF NOT EXISTS(SELECT * FROM Screens WHERE ScreenId=1260)
	INSERT INTO Screens
	(ScreenId, ScreenName, ScreenType, ScreenURL,TabId,ScreenToolbarURL)
	VALUES 
	(1260,'Upload File Detail',5765,'/ActivityPages/Office/Custom/UploadMedicalRecordDetail.ascx',2,null)
	else
	update Screens set
	ScreenName='Upload File Detail',
	ScreenType=5765,
	ScreenURL='/ActivityPages/Office/Custom/UploadMedicalRecordDetail.ascx',
	TabId=2,
	ScreenToolbarURL=null
	where ScreenId=1260
	
	
    IF NOT EXISTS(SELECT * FROM Screens WHERE ScreenId=1261)
	INSERT INTO Screens
	(ScreenId, ScreenName, ScreenType, ScreenURL,TabId,ScreenToolbarURL)
	VALUES 
	(1261,'Scanned Medical Record Detail',5765,'/ActivityPages/Office/Custom/ScannedImageMedicalRecordDetail.ascx',2,null)
	else
	update Screens set
	ScreenName='Scanned Medical Record Detail',
	ScreenType=5765,
	ScreenURL='/ActivityPages/Office/Custom/ScannedImageMedicalRecordDetail.ascx',
	TabId=2,
	ScreenToolbarURL=null
	where ScreenId=1261
		
SET IDENTITY_INSERT Screens off


IF Not EXISTS(SELECT ScreenId FROM Banners WHERE ScreenId=1259)
      Insert INTO Banners(BannerName,DisplayAs,Active,DefaultOrder,TabId,Custom,ScreenId)
      Values('Scanning','Scanning','Y',1,2,'N',1259)
else
    UPDATE Banners SET BannerName='Scanning',
	DisplayAs='Scanning',
	Active='Y',
	DefaultOrder=1,
	TabId=2
	WHERE ScreenId=1259 
      

