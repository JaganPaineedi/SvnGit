/*
Added by Lakshmi on 21/08/2017 as par the task A Renewed Mind - Support #699
*/

IF EXISTS (SELECT 1 FROM Banners WHERE ScreenId=108 AND ISNULL(RecordDeleted,'N')='N')
BEGIN
UPDATE Banners set RecordDeleted='Y' WHERE ScreenId=108 AND ISNULL(RecordDeleted,'N')='N'
END 