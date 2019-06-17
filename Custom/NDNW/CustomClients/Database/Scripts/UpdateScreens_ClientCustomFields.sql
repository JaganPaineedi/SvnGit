/*******************************************************
*12/26/14 - Tryan 
* Updates Screens.CustomFieldFormid to contain the
* Form Id of our custom form, CustomClients
*******************************************************/

DECLARE @NewFormId INT

SELECT @NewFormId = FormId 
FROM Forms 
WHERE FormName = 'CustomClients'

UPDATE dbo.Screens
SET CustomFieldFormId = (SELECT @NewFormId)
WHERE ScreenName = 'Client Information (Admin)'