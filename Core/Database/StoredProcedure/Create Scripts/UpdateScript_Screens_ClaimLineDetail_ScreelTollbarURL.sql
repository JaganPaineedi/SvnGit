---------------------------------------------------------
--Author : K. Soujanya
--Date   : 11/15/2018
--Purpose: Script to update the ScreenToolbarURL path, as per the requiremnt Created new user control and added action drop down  :#591 SWMBH - Enhancements.
---------------------------------------------------------
UPDATE Screens
SET ScreenToolbarURL = '/ScreenToolBars/ClaimLineDetailPageToolBar.ascx'
WHERE ScreenId = 1010
