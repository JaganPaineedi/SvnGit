--Script to update GUID for core forms


UPDATE FormS SET FormGUID = '3BF97D49-EEA4-4DC3-B321-E96EA5F0BD3B' WHERE FormName ='Advance Directives' AND TableName = 'AdvanceDirective' 
UPDATE FormS SET FormGUID = 'AED6AD51-5702-4533-9018-F56E06EC6F13' WHERE FormName ='Clinical Info Reconciliation' AND TableName = 'ClinicalInformationReconciliation' 
UPDATE FormS SET FormGUID = '4C867F9C-D6ED-4329-88D5-287A81681B8B' WHERE FormName ='Med History Consent' AND TableName = 'MedicationHistoryRequestConsents' 
UPDATE FormS SET FormGUID = 'DEA699E7-9AB2-46D3-AD59-D13B729941E3' WHERE FormName ='Note' AND TableName = 'CustomMiscellaneousNotes' 
UPDATE FormS SET FormGUID = '8BF47A4A-8D90-47B8-AF1D-1794EADEF860' WHERE FormName ='Transition of Care' AND TableName = 'TransitionOfCareDocuments' 