DECLARE @ClientHistoryPopup INT = 2210

/*
5761	Detail Page
5762	List Page
5763	Document Page
5764	Summary Page
5765	Custom Page
5766	ExternalScreen
*/

SET IDENTITY_INSERT Screens ON
INSERT INTO dbo.Screens ( ScreenId,ScreenName, ScreenType, ScreenURL,
                       TabId, InitializationStoredProcedure, ValidationStoredProcedureUpdate)
SELECT @ClientHistoryPopup , 
'Client Address History',
5761,
'/Modules/ClientInformation/Client/Detail/ClientAddressHistory.ascx',
2,
'ssp_SCInitClientAddressHistory',
'ssp_SCValidateClientAddressHistory'

SET IDENTITY_INSERT dbo.Screens OFF 

INSERT INTO dbo.ScreenPermissionControls ( ScreenId, ControlName, DisplayAs, Active)
SELECT @ClientHistoryPopup,'ButtonUpdate','ButtonUpdate','Y'
WHERE NOT EXISTS ( SELECT 
				   1
				   FROM dbo.ScreenPermissionControls AS a
				   WHERE a.ScreenId = @ClientHistoryPopup
				   AND ISNULL(a.RecordDeleted,'N')='N'
				 )