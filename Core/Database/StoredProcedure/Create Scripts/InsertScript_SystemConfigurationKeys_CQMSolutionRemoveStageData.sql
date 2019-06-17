insert into dbo.SystemConfigurationKeys([Key],[Value],[Description],AcceptedValues,ShowKeyForViewingAndEditing,AllowEdit)
select 'CQMSolutionRemoveStageData','Y','This key controls whether or not the staging data is deleted once the data has been returned to the CQM application.','Y,N','Y','Y'
where not exists( select 1
			   from SystemConfigurationKeys
			   where [Key] = 'CQMSolutionRemoveStageData'
			   and isnull(RecordDeleted,'N')='N'
			   )
