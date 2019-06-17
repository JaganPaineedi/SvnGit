-- Msood 11/02/2018  -- Engineering Improvement Initiatives- NBL(I) Task #733


If Exists (Select * from Screens where ScreenURL ='/Modules/PlaceofService/Admin/ListPages/PlaceofServices.ascx' and ScreenId = 951)
Begin
Update Screens Set ScreenName ='Place of Services Overrides' where ScreenURL ='/Modules/PlaceofService/Admin/ListPages/PlaceofServices.ascx'  and ScreenId = 951
End
Go

If Exists (Select * from Screens where ScreenURL ='/Modules/PlaceofService/Admin/Detail/PlaceofServices.ascx'  and ScreenId = 952)
Begin
Update Screens Set ScreenName ='Place of Services Override Details' where ScreenURL ='/Modules/PlaceofService/Admin/Detail/PlaceofServices.ascx'  and ScreenId = 952
End
Go


If Exists (Select * from Screens where ScreenURL ='/Modules/PlaceofService/Admin/Detail/POSGeneral.ascx'  and ScreenId = 953)
Begin
Update Screens Set ScreenName ='Place of Services Override - Popup' where ScreenURL ='/Modules/PlaceofService/Admin/Detail/POSGeneral.ascx'  and ScreenId = 953
End
Go



If Exists (Select * from Banners where BannerName ='Place of Service'  and ScreenId = 951)
Begin
Update Banners Set BannerName ='Place of Services Overrides', DisplayAs='Place of Services Overrides' where BannerName ='Place of Service'  and ScreenId = 951
End
Go
