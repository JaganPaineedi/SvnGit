--Created by on 16-March-2015 SuryaBalan Task 5 New Directions - Customizations
--To change "Add Disposition" to "Add facility"

INSERT INTO ScreenLabels(
CreatedBy,
createddate,
ScreenId,
ScreenType,
LabelHasId,
LabelControlId,
NearestControlId,
TabControlId,
OriginalText,
Override,
OverrideText)
values(
'ADMIN',
GETDATE(),
10683,
5761,
'Y',
'Anchor_addDisposition',
'Disposition-1',
'ctl00_ctl00_ContentPlaceHolderActivityPageContents_ContentPlaceHolderPageContents_ctl00_inquiryTabPageInstance_C0',
'Add Disposition',
'Y',
'Add Facility')