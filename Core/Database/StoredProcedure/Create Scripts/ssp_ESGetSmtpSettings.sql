IF EXISTS (SELECT *
             FROM sys.objects
            WHERE object_id = OBJECT_ID(N'ssp_ESGetSmtpSettings')
              AND type IN ( N'P', N'PC' ))
BEGIN
    DROP PROCEDURE ssp_ESGetSmtpSettings;
END;
GO

CREATE PROCEDURE ssp_ESGetSmtpSettings
AS
/******************************************************************************
**		File: 
**		Name: ssp_ESGetSmtpSettings
**		Desc: 
**
**              
**		Return values:
** 
**		Called by:   
**              
**		Parameters:
**
**		Auth: jcarlson
**		Date: 10/4/2017
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		    Author:				    Description:
**		--------		--------				-------------------------------------------
**      10/4/2017       jcarlson	            created
**		10/8/2017		jcarlson				Modified to remove hardcoded values and pull from table
*******************************************************************************/
BEGIN TRY

    SELECT a.Username AS UserName,
           a.UserPassword AS [Password],
           a.ServerDetails AS Host,
           CONVERT(INT,a.PortDetails) AS Port,
           'Network' AS DeliveryMethod,
           'Y' AS EnableSSL,
           'N' AS UseDefaultCredentials,
           NULL AS PickupDirectoryLocation
   FROM dbo.CustomerForgotUsernameMailCredentials AS a

    RETURN;


END TRY
BEGIN CATCH
    DECLARE @Error VARCHAR(8000);
    SELECT @Error
        = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
          + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_ESGetSmtpSettings') + '*****'
          + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
          + CONVERT(VARCHAR, ERROR_STATE());
    RAISERROR(@Error, 16, 1);

END CATCH;