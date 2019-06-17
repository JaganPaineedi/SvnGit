/********************************************************************************                                                   
--  
-- Copyright: Streamline Healthcare Solutions 
-- Purpose: Payment EOB Screen Script Task #840 - Renaissance - Dev Items.
--  
-- Author:  Akwinass
-- Date:    04-MAR-2016
--  
-- *****History****  
*********************************************************************************/
---------------------------Attendance Pop-up Page---------------------------------------
IF NOT EXISTS (
		SELECT ScreenId
		FROM Screens
		WHERE ScreenId = 1189
		)
BEGIN
	SET IDENTITY_INSERT Screens ON

	INSERT INTO [Screens] (
		ScreenId
		,[ScreenName]
		,[ScreenType]
		,[ScreenURL]
		,[TabId]
		,[HelpURL] 
		)
	VALUES (
		1189
		,'Payment EOB'
		,5765
		,'/ActivityPages/Office/Custom/PaymentEOBPopUp.ascx'
		,1	
		,'../Help/overview.htm'	
		)

	SET IDENTITY_INSERT Screens OFF
END
ELSE
BEGIN
	UPDATE screens
	SET screenname = 'Payment EOB'
		,screentype = 5765
		,screenurl = '/ActivityPages/Office/Custom/PaymentEOBPopUp.ascx'
		,tabid = 1
		,HelpURL = '../Help/overview.htm'
	WHERE screenid = 1189
END 
---------------------------End----------------------------------------------------------------------