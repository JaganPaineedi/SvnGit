insert into SystemConfigurationKeys
(
[Key]
,[Value]
,[Description]
,ShowKeyForViewingAndEditing
,AllowEdit
)
select 
'ShowReport_ScriptManager_AsyncPostBackTimeout',
'300',
'This key sets ShowReport.aspx Script Managers AsyncPostBackTime. The value should be in seconds.',
'Y',
'Y'
where not exists( select 1
				from SystemConfigurationKeys as a
				where a.[Key] = 'ShowReport_ScriptManager_AsyncPostBackTimeout'
				and isnull(a.RecordDeleted,'N')='N'
			 )