
/*Script to insert screen data for Batch Scanning*/
/*************************************************/

SET IDENTITY_INSERT SCREENS ON 

IF NOT EXISTS(SELECT 1 FROM SCREENS WHERE SCREENID = 1165)
INSERT INTO Screens 
(ScreenId,ScreenName,ScreenType,ScreenURL,TabId)
VALUES
(
	1165,'Batch Scan',5765,'/ActivityPages/Office/Custom/MedicalRecordBatchScan.ascx',1
)

IF NOT EXISTS(SELECT 1 FROM SCREENS WHERE SCREENID = 1164)
INSERT INTO Screens 
(ScreenId,ScreenName,ScreenType,ScreenURL,TabId)
VALUES
(
	1164,'Batch Upload',5765,'/ActivityPages/Office/Custom/MedicalRecordBatchUpload.ascx',1
)

IF NOT EXISTS(SELECT 1 FROM SCREENS WHERE SCREENID = 1166)
INSERT INTO Screens 
(ScreenId,ScreenName,ScreenType,ScreenURL,TabId)
VALUES
(
	1166,'Batch Image Upload',5765,'/CommonUserControls/BatchUploadImageRecords.ascx',2
)


SET IDENTITY_INSERT SCREENS OFF 

/*************************************************/
/******************End of Script******************/

