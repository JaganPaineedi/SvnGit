/********************************************************************************                                                      
-- Copyright: Streamline Healthcare Solutions    
-- Purpose: Updating Screens & Banner name for Inquiry Gold Document.  
-- Author:  Alok Kumar
-- Date:    13 June 2018
*********************************************************************************/


-- Inquiry Details Screens Table Update
----------------------------------------   Screens Table   -----------------------------------  
DECLARE @BannerName VARCHAR(100)
DECLARE @ScreenCode VARCHAR(100) 
DECLARE @ScreenId INT
DECLARE @ScreenName VARCHAR(100)
DECLARE @OldBannerName VARCHAR(100) 


SET @ScreenCode = 'Inquiries'
SET @ScreenId = (Select  top 1 ScreenId from Screens WHERE  Code = @ScreenCode)
SET @ScreenName = 'Inquiry Details(C)' 


---Screens
IF EXISTS (SELECT ScreenId  FROM   Screens WHERE  Code = @ScreenCode) 
BEGIN 
      UPDATE Screens 
		SET    ScreenName = @ScreenName
      WHERE  Code = @ScreenCode
END 

 -----------------------------------------------END--------------------------------------------  
 
 
 


-- Inquiry List(My Office) Screens & Banner Table Update
----------------------------------------   Screens & Banner Table   -----------------------------------  

SET @OldBannerName = 'Inquiries'
SET @ScreenCode = 'Inquiries_1'
SET @ScreenId = (Select  top 1 ScreenId from Screens WHERE  Code = @ScreenCode)
SET @BannerName = 'Inquiries(C)'
SET @ScreenName = 'Inquiries(C)' 


---Screens
IF EXISTS (SELECT ScreenId  FROM   Screens WHERE  Code = @ScreenCode) 
BEGIN 
      UPDATE Screens 
		SET    ScreenName = @ScreenName
      WHERE  Code = @ScreenCode
END 


---Banner
IF EXISTS (SELECT 1 FROM dbo.Banners WHERE ScreenId =@ScreenId AND BannerName = @OldBannerName)
BEGIN	
	UPDATE Banners 
	SET		BannerName = @BannerName,
			DisplayAs = @BannerName
	WHERE	ScreenId = @ScreenId AND BannerName = @OldBannerName
END

 -----------------------------------------------END--------------------------------------------  





-- Inquiry List(Clients) Screens & Banner Table Update
----------------------------------------   Screens & Banner Table   ----------------------------------- 
 
SET @OldBannerName = 'Client Inquiries'
SET @ScreenCode = 'Inquiries_2'
SET @ScreenId = (Select  top 1 ScreenId from Screens WHERE  Code = @ScreenCode)
SET @BannerName = 'Client Inquiries(C)'
SET @ScreenName = 'Client Inquiries(C)' 


---Screens
IF EXISTS (SELECT ScreenId  FROM   Screens WHERE  Code = @ScreenCode) 
BEGIN 
      UPDATE Screens 
		SET    ScreenName = @ScreenName
      WHERE  Code = @ScreenCode
END 


---Banner
IF  EXISTS (SELECT 1 FROM dbo.Banners WHERE ScreenId =@ScreenId AND BannerName = @OldBannerName)
BEGIN
	UPDATE Banners 
	SET		BannerName = @BannerName,
			DisplayAs = @BannerName
	WHERE	ScreenId = @ScreenId AND BannerName = @OldBannerName
END

 -----------------------------------------------END--------------------------------------------  
