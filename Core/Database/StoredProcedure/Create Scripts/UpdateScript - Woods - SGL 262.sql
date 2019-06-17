--Update Script for Woods - Support Go Live 262
--Manjunath K 
UPDATE SCREENPERMISSIONCONTROLS 
SET CONTROLNAME = 'ButtonModify'
WHERE ControlName like 'ButtonButtonModify' AND ScreenId in (3,969, 370)

UPDATE SCREENPERMISSIONCONTROLS 
SET DisplayAs = 'ButtonModify' 
WHERE DisplayAs like 'ButtonButtonModify' AND ScreenId in (3,969, 370)