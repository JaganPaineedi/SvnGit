SET IDENTITY_INSERT Screens ON
IF Not EXISTS(SELECT ScreenId FROM Screens WHERE ScreenId=1190)
	INSERT INTO Screens
	(ScreenId, ScreenName, ScreenType, ScreenURL,TabId)
	VALUES 
	(1190,'Contact Notes',5762,'/ActivityPages/Office/ListPages/ContactNotes/ContactNoteList.ascx',1)
	else
	update Screens set
	ScreenName='Contact Notes',
	ScreenType=5762,
	ScreenURL='/ActivityPages/Office/ListPages/ContactNotes/ContactNoteList.ascx',
	TabId=1	where ScreenId=1190
SET IDENTITY_INSERT Screens off



----------------------------------------   Banner Table   -----------------------------------  
IF Not EXISTS(SELECT ScreenId FROM Banners WHERE ScreenId=1190)
      Insert INTO Banners(BannerName,DisplayAs,Active,DefaultOrder,TabId,Custom,ScreenId)
      Values('Contact Notes','Contact Notes','Y',1,1,'N',1190)
else
     UPDATE Banners SET BannerName='Contact Notes',
	DisplayAs='Contact Notes',
	Active='Y',
	DefaultOrder=1,
	TabId=1
	WHERE ScreenId=1190


UPDATE Screens SET ScreenURL='/ActivityPages/Office/Detail/ChargeDetailMain.ascx' WHERE ScreenId=319
UPDATE Screens SET ScreenURL='/ActivityPages/Client/Detail/Authorization/AuthorizationDetailMain.ascx' WHERE ScreenId=498

