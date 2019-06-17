--Created by on 16-March-2015 SuryaBalan Task 5 New Directions - Customizations
--To change "Select Disposition" to "Select facility"

DECLARE @ApplicationMessageId INT
Delete ApplicationMessages where  MessageCode='SELECTFACILITY'
INSERT INTO ApplicationMessages (
CreatedBy,
CreatedDate,
PrimaryScreenId,
MessageCode,
OriginalText,
[Override],
OverrideText)
Values
 ('streamline-dbo',
GETDATE(),
10683,
'SELECTFACILITY',
'Select Disposition',
'Y',
'Select Facility'
)

set @ApplicationMessageId = (select top 1 ApplicationMessageId from ApplicationMessages where MessageCode='SELECTFACILITY')

INSERT INTO ApplicationMessageScreens (
CreatedBy,
CreatedDate,
ApplicationMessageId,
ScreenId)

Values('streamline-dbo',
GETDATE(),
@ApplicationMessageId,
10683)
