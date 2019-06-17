-----------------Screen entry for AssociatedStaffProviders popup ------------------------------

/*  25/Jan/2017	Basudev Sahu				 What : Screen script for AssociatedStaffProviders popup.
											 Why : CEI SGL task #364 */
											 
											 
   SET IDENTITY_INSERT [SCREENS] ON
GO
IF NOT EXISTS (SELECT [SCREENNAME] FROM SCREENS WHERE [SCREENID] = 1213 )
BEGIN
INSERT INTO [SCREENS]
          ([SCREENID]
          ,[SCREENNAME]
          ,[SCREENTYPE]
          ,[SCREENURL]
          ,[TABID]
          )
    VALUES 
	      (1213,
          'AssociatedStaffProviders popup'
          ,5765
          ,'/CommonUserControls/AssociatedStaffProvidersPopup.ascx'
          ,4
          )
           END
ELSE
update Screens
set 
ScreenName='AssociatedStaffProviders popup',
ScreenType=5765,
ScreenURL= '/CommonUserControls/AssociatedStaffProvidersPopup.ascx',
TabId=4   
where ScreenId=1213        
         
GO
SET IDENTITY_INSERT [SCREENS] OFF
GO
