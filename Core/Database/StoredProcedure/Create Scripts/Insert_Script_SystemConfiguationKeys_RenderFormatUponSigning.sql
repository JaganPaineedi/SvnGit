if not exists (select 1 from dbo.SystemConfigurationKeys as sck where sck.[Key] = 'RenderFormatUponSigning')
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
values  ( 'RenderFormatUponSigning'  -- Key - varchar(200)
        , 'PDF'  -- Value - varchar(max)
        , 'This systemconfiguration key allows specifying what the system needs to do upon signing the document. If it''s set to PDF it''ll keep the existing behavior of generating PDF, if it''s NONE then it''ll display the screen with successful signing message and generate the PDF in background and store it in the database, if it''s HTML then it''ll generate HTML report.'  -- Description - type_Comment2
        , 'PDF,NONE,HTML'  -- AcceptedValues - varchar(max)
        , 'Y'  -- ShowKeyForViewingAndEditing - type_YOrN
        , 'ReportViewer'  -- Modules - varchar(500)
        , 'Documents,ServiceNotes'  -- Screens - varchar(500)
        , 'To avoid rendering PDF upon signing select option NONE'  -- Comments - type_Comment2
        )
end

