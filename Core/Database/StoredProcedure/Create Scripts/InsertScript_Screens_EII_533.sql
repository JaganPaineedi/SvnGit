SELECT * FROM Screens WHERE ScreenId IN (1219,1220,1222)
SELECT * FROM Screens WHERE ScreenId IN (1248,1249,1250)
SET IDENTITY_INSERT Screens ON 
IF NOT EXISTS (SELECT 1 FROM Screens WHERE ScreenId = 1248)
BEGIN
	INSERT INTO Screens (ScreenId,ScreenName,ScreenType,ScreenURL,TabId)
	VALUES (1248,'ExportDFAPopUp',5765,'/ActivityPages/Admin/Detail/DfaUserInterface/ExportDFAPopUp.ascx',4)
END


IF NOT EXISTS (SELECT 1 FROM Screens WHERE ScreenId = 1249)
BEGIN
	INSERT INTO Screens (ScreenId,ScreenName,ScreenType,ScreenURL,TabId)
	VALUES (1249,'CreateTablePopUp',5765,'/ActivityPages/Admin/Detail/DfaUserInterface/CreateTablePopUp.ascx',4)
END

IF NOT EXISTS (SELECT 1 FROM Screens WHERE ScreenId = 1250)
BEGIN
	INSERT INTO Screens (ScreenId,ScreenName,ScreenType,ScreenURL,TabId)
	VALUES (1250,'DFA Import',5765,'/ActivityPages/Admin/Detail/DfaUserInterface/DFAImport.ascx',4)
SET IDENTITY_INSERT Screens OFF
END