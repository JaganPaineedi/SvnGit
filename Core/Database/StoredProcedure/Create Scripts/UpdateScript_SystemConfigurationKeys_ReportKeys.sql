
/*
Update [Value] = '' with the appropriate value as it exists in the customers Web.config for the following key.
<add key="pdfViewerControlLicenseKey" value="HjUsPi8pPi0tLT4tMC4+LS8wLywwJycnJw==" />
*/

UPDATE SystemConfigurationKeys
SET [Value] = ''
WHERE [KEY] = 'pdfViewerControlLicenseKey'

/*
Update [Value] = '' with the appropriate value as it exists in the customers Web.config for the following key.
<add key="ReportServerConnect" value="Data Source=10.0.253.5;Initial Catalog=ReportServer;uid=qauser;pwd=qa@user123;" />
*/

UPDATE SystemConfigurationKeys
SET [Value] = ''
WHERE [KEY] = 'ReportServerConnect'


/*
Update [Value] = '' with the appropriate value as it exists in the customers Web.config for the following key.
<add key="ShowRDLAfterSign" value="false"/>
*/

UPDATE SystemConfigurationKeys
SET [Value] = ''
WHERE [KEY] = 'ShowRDLAfterSign'