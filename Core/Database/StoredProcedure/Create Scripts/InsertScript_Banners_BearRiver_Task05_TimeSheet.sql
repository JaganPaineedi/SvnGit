
IF NOT EXISTS(SELECT 1 FROM Banners WHERE ScreenId=1171 and BannerName='TimeSheet')
INSERT INTO Banners(BannerName,DisplayAs,Active,DefaultOrder,Custom,TabId,ScreenId)
VALUES
(
	'TimeSheet'
	,'Time Sheet'
	,'Y'
	,60
	,'N'
	,1
	,1171
)
ELSE
UPDATE Banners
SET 
BannerName = 'TimeSheet'
,DisplayAs='Time Sheet'
,Active='Y'
,DefaultOrder=60
,Custom='N'
,TabId=1
,ScreenId=1171
WHERE ScreenId=1171 and BannerName='TimeSheet'
