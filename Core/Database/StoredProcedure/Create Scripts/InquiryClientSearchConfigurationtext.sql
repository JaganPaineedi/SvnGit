-- /********************************************************************************************
-- Author			:  AlokKumar Meher 
-- CreatedDate		:  26 June 2018 
-- Purpose			:  Update script for Inquiry
-- *********************************************************************************************/
-- --Updatiing ClientSearchCustomConfigurations table

-- DECLARE @ScreenId INT
-- DECLARE @ScreenCode VARCHAR(100)

-- SET @ScreenCode = 'Inquiries'
-- SET @ScreenId = (Select  top 1 ScreenId from Screens WHERE  Code = @ScreenCode)
-- --Print @ScreenId

-- IF EXISTS(Select 1 from ClientSearchCustomConfigurations)
-- BEGIN

	-- Update ClientSearchCustomConfigurations set EnablesOn3Searches1 = 'N', OpenScreenId1 = @ScreenId, OpenScreenId2 = @ScreenId
-- END


GO
