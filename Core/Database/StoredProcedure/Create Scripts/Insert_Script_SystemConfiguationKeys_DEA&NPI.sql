if not exists (select 1 from dbo.SystemConfigurationKeys as sck where sck.[Key] = 'DEA&NPI')
begin
insert into dbo.SystemConfigurationKeys
        ( [Key]
        , Value
        , Description
        , AcceptedValues
        , ShowKeyForViewingAndEditing
        , Modules
        , Screens
        , Comments
        )
values  ( 'DEA&NPI'  -- Key - varchar(200)
        , 'N'  -- Value - varchar(max)
        , 'This systemconfiguration key allows user to use DEA & NPI number from Staff table until data migration done to StaffLicenseDegrees table'  -- Description - type_Comment2
        , 'Y,N'  -- AcceptedValues - varchar(max)
        , 'Y'  -- ShowKeyForViewingAndEditing - type_YOrN
        , 'Staff Details'  -- Modules - varchar(500)
        , 'Staff Details'  -- Screens - varchar(500)
        , 'To avoid Updation of null into Staff table for DEA & NPI when data is not inserted into StaffLicenseDegrees table'  -- Comments - type_Comment2
        )
end