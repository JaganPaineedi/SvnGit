-- Script to correct BannerName name 'Calender' to 'Calendar'
-- Task Core Bugs > Tasks#2188 > fix the spelling for the word 'calender' in all banners.
update Banners
set displayas=REPLACE(displayas, 'Calender', 'Calendar'),
BannerName =REPLACE(BannerName, 'Calender', 'Calendar')
from Banners
where displayas like '%calender%'