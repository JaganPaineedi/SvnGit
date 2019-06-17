--- Update to DocumentCodes to facilitate Client Order Control
UPDATE DocumentCodes
SET ClientOrder = 'Y'
	,TableList = 'DocumentProgressNotes,NoteEMCodeOptions,ClientOrders,ClientOrdersDiagnosisIIICodes,ClientGridOrders,ClientOrderQnAnswers'
WHERE DocumentCodeId = 300

-------------- Update Script for NoteTags to handle Client Order Control functionality-----------
UPDATE NoteTags
SET CalculatedStoredProcedure = 'ssp_NoteTagClientOrderControl',
ScreenId = NULL	
WHERE TagName = 'Order Labs'

UPDATE NoteTags
SET TagBehavior = 'AutoRefresh'
WHERE TagName = 'Ordered Labs'