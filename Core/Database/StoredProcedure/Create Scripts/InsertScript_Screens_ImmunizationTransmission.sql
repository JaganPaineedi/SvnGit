IF NOT EXISTS (SELECT [SCREENNAME] FROM SCREENS WHERE [SCREENID] = 1230 )
BEGIN
SET IDENTITY_INSERT Screens ON
INSERT INTO [SCREENS]
          ([SCREENID]
          ,[SCREENNAME]
          ,[SCREENTYPE]
          ,[SCREENURL]
          ,[TABID]
          )
    VALUES 
	      (1230,
          'HL7 Parser'
          ,5765
          ,'/Modules/ImmunizationTransmissionLog/Client/Custom/HL7ParserPopup.ascx'
          ,2
          )
           END
ELSE
update Screens
set 
ScreenName='HL7 Parser',
ScreenType=5765,
ScreenURL= '/Modules/ImmunizationTransmissionLog/Client/Custom/HL7ParserPopup.ascx',
TabId=2   
where ScreenId=1230   
SET IDENTITY_INSERT Screens OFF

IF NOT EXISTS (SELECT [SCREENNAME] FROM SCREENS WHERE [SCREENID] = 1231 )
BEGIN
SET IDENTITY_INSERT Screens ON
INSERT INTO [SCREENS]
          ([SCREENID]
          ,[SCREENNAME]
          ,[SCREENTYPE]
          ,[SCREENURL]
          ,[TABID]
          )
    VALUES 
	      (1231,
          'Immunization Transmission Summary'
          ,5764
          ,'/Modules/ImmunizationTransmissionLog/Client/Summary/ImmunizationTransmissionSummary.ascx'
          ,2
          )
           END
ELSE
update Screens
set 
ScreenName='Immunization Transmission Summary',
ScreenType=5764,
ScreenURL= '/Modules/ImmunizationTransmissionLog/Client/Summary/ImmunizationTransmissionSummary.ascx',
TabId=2   
where ScreenId=1231   
SET IDENTITY_INSERT Screens OFF