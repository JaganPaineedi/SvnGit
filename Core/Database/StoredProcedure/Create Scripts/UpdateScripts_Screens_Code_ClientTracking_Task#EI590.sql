-- =============================================   
-- Author:    Vijay 
-- Create date: Oct 24, 2018
-- What:Updating Screens.Code column value 
-- Why:Engineering Improvement Initiatives- NBL(I) - Task# 590 
-- =============================================     

--Treatment Episode Details - ScreenId = 1223
IF EXISTS (SELECT 1 FROM dbo.SCREENS WHERE ScreenId = 1223 AND Code IS NULL)
BEGIN
	UPDATE Screens SET Code='21787F00-493C-4472-8CA4-55C90F69B0E9', ModifiedBy = 'EI#590' WHERE ScreenId = 1223
END


--Client Information(C) - ScreenId = 969
IF EXISTS (SELECT 1 FROM dbo.SCREENS WHERE ScreenId = 969 AND Code IS NULL)
BEGIN
	UPDATE Screens SET Code = 'EBE5E772-9B16-40C5-ACA1-A85D8786F374', ModifiedBy = 'EI#590' WHERE ScreenId = 969
END


--Registration Document - ScreenId = 10500
--We are using ScreeName because of ScreenId is different for few customers[MFS-10684]
IF EXISTS (SELECT 1 FROM dbo.SCREENS WHERE ScreenName = 'Registration Document' AND ScreenId = 10500 AND Code IS NULL)
BEGIN
	UPDATE Screens SET Code = '0D3F4ED7-F309-4DA1-8831-82274ADAB661', ModifiedBy = 'EI#590' WHERE ScreenName = 'Registration Document' AND ScreenId = 10500
END

--Registration Document - ScreenId = 10684
--We are using ScreeName because of ScreenId is different for few customers[MFS-10684]
IF EXISTS (SELECT 1 FROM dbo.SCREENS WHERE ScreenName = 'Registration Document' AND ScreenId = 10684 AND Code IS NULL)
BEGIN
	UPDATE Screens SET Code = '0D3F4ED7-F309-4DA1-8831-82274ADAB661', ModifiedBy = 'EI#590' WHERE ScreenName = 'Registration Document' AND ScreenId = 10684
END

--Admission Document[ for NDNW] - ScreenId = 10500
IF EXISTS (SELECT 1 FROM dbo.SCREENS WHERE ScreenName = 'Admission Document' AND ScreenId = 10500 AND Code IS NULL)
BEGIN
	UPDATE Screens SET Code = '0D3F4ED7-F309-4DA1-8831-82274ADAB661', ModifiedBy = 'EI#590' WHERE ScreenName = 'Admission Document' AND ScreenId = 10500 
END


--Program Assignment Details - ScreenId = 302
IF EXISTS (SELECT 1 FROM dbo.SCREENS WHERE ScreenId = 302 AND Code IS NULL)
BEGIN
	UPDATE Screens SET Code = 'A3A19310-4572-4558-ADA1-1105559C94CC', ModifiedBy = 'EI#590' WHERE ScreenId = 302
END