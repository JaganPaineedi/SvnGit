if exists (select * from dbo.SystemConfigurationKeys as sck where sck.[Key] like '%MAR_EnableBarcoding%')
begin
update dbo.SystemConfigurationKeys
set AcceptedValues = 'Y,N'
, ShowKeyForViewingAndEditing = 'Y'
where [Key] = 'MAR_EnableBarcoding'
end
