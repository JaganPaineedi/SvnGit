-- What : In Service From Claims, when user clicks on ServiceId hyperlink it navigates to Service Detail page and it is not showing the Favorite icon. 
--        Because in Systemconfigurationkeys table Service Detail page's screenid is missing hence it is not showing. If we update the Service Detail page's 
--        screenid i.e. 210 for Key=ADDSCREENIDTOSHOWFAVICONONTOOLBAR it will work as expected.

-- Why  : 	ARC Build Cycle Tasks #3

UPDATE SYSTEMCONFIGURATIONKEYS Set VALUE=',29,207,210,'  where [Key]='ADDSCREENIDTOSHOWFAVICONONTOOLBAR'

 