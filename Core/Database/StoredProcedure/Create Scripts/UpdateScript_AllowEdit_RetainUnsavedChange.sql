--Script to enable the edit from UI for RETAINUNSAVEDCHANGESFORXHOURS key
--AspenPointe-Environment Issues #159

update SystemConfigurationKeys set AllowEdit='Y' where [KEY] = 'RETAINUNSAVEDCHANGESFORXHOURS'

