insert into dbo.SystemConfigurationKeys([Key],[Value],[Description],AcceptedValues,ShowKeyForViewingAndEditing,AllowEdit)
select 'CQMSolution_CertificationNumber','15.04.04.2855.Smar.05.00.1.171231','This key contains streamline current Meaningful Use Certifcation number','15.04.04.2855.Smar.05.00.1.171231','Y','Y'
where not exists( select 1
			   from SystemConfigurationKeys
			   where [Key] = 'CQMSolution_CertificationNumber'
			   and isnull(RecordDeleted,'N')='N'
			   )