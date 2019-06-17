-----------------Screen entry for Billing Code Exchange popup ------------------------------

/*  26/March/2016		Ponnin				 What : Screen script for BillingCode Exchange popup.
											 Why : Network 180 - Customizations task #702 */
											 
											 
   SET IDENTITY_INSERT [SCREENS] ON
GO
IF NOT EXISTS (SELECT [SCREENNAME] FROM SCREENS WHERE [SCREENID] = 1185 )
BEGIN
INSERT INTO [SCREENS]
          ([SCREENID]
          ,[SCREENNAME]
          ,[SCREENTYPE]
          ,[SCREENURL]
          ,[TABID]
          )
    VALUES 
	      (1185,
          'Billing Code Exchange popup'
          ,5765
          ,'/CommonUserControls/BillingCodeExchangeClaimsPopup.ascx'
          ,4
          )
           END
ELSE
update Screens
set 
ScreenName='Billing Code Exchange popup',
ScreenType=5765,
ScreenURL= '/CommonUserControls/BillingCodeExchangeClaimsPopup.ascx',
TabId=4   
where ScreenId=1185        
         
GO
SET IDENTITY_INSERT [SCREENS] OFF
GO
