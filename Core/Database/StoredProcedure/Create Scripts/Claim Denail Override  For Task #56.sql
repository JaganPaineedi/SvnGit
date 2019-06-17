update Banners set TabId = 4 where BannerName like '%Claim Denial Overrides%' 

update Screens set TabId = 4,
ScreenURL = 'Modules/ClaimDenialOverrides/ActivityPages/Admin/ListPages/ClaimDenialOverridesList.ascx' 
where ScreenId = 1139

update Screens set TabId = 4,
ScreenURL= 'Modules/ClaimDenialOverrides/ActivityPages/Admin/Detail/ClaimDenialOverrides.ascx'
where ScreenId = 1140





