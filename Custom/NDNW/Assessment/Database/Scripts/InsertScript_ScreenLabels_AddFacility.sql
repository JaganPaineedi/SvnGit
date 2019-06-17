--Created On  :27 April 2015 
--Create By    :Malathi Shiva 
--Purpose  :New Directions - Customizations: Task# 6 Assessment Document - To modify "Add Disposition" to "Add facility" in Label's


delete from ScreenLabels where ScreenId = 10018

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
10018,
5763,
'Y',
'Anchor_addDisposition',
'finalDiv',
'Disposition',
'Add Disposition',
'Y',
'Add Facility')