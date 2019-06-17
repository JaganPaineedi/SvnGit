 --Created By: Neelima
--Created Date: 25 May 2015
--Purpose:Create a banner and a screen for Client Fee

                   
----------------------------------------   Screens Table   -----------------------------------
SET identity_insert screens on
IF Not EXISTS(SELECT ScreenId FROM Screens WHERE ScreenId=50001)
BEGIN
insert into Screens(ScreenId,ScreenName,ScreenType,ScreenURL,TabId,InitializationStoredProcedure)
values
(50001,'Client Fee',5761,'/Custom/ClientFees/WebPages/ClientFees.ascx',2,'csp_InitCustomClientFees')
END
 
Set Identity_Insert screens OFF
 -----------------------------------------------END--------------------------------------------
    
----------------------------------------   Banners Table   -----------------------------------

IF Not EXISTS(SELECT ScreenId FROM Banners WHERE ScreenId=50001)
BEGIN
insert into Banners(BannerName,DisplayAs,DefaultOrder,Custom,TabId,ScreenId)
values
('Client Fee','Client Fee',20,'N',2,50001)
END

-----------------------------------------------END--------------------------------------------




    
    
    
    
    






    
