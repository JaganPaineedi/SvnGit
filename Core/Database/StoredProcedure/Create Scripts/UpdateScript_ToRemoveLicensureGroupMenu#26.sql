
--Task#26 Heartland East - Customizations
--Description: 10.Inactivate/remove banner for Licensure Group under Admin tab as we will be replacing that functionality
--created under task #6800 Heartland Customizations with this new button and popup.

UPDATE SCREENS SET RECORDDELETED = 'Y' WHERE SCREENNAME = 'Licensure Group'
UPDATE BANNERS SET RECORDDELETED = 'Y' WHERE BANNERNAME = 'Licensure Group'