IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_SCGetToolBarListPageViews')
                    AND type IN ( N'P', N'PC' ) )
    BEGIN
        DROP PROCEDURE ssp_SCGetToolBarListPageViews;
    END;
GO

CREATE PROCEDURE ssp_SCGetToolBarListPageViews
@ScreenId INT,
@StaffId INT
AS
/******************************************************************************
**		File: 
**		Name: ssp_SCGetToolBarViews
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
**		Date: 3/21/2017
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		    Author:				    Description:
**		--------		--------				-------------------------------------------
**      3/21/2017          jcarlson             created
**		5/31/2017		jcarlson				Reniassance Dev Items 630.6 - Show all views
*******************************************************************************/
    BEGIN TRY

    --ListPageColumnConfigurationColumns
		SELECT a.ListPageColumnConfigurationId AS ViewId, a.ViewName
		FROM dbo.ListPageColumnConfigurations AS a
		WHERE a.ScreenId = @ScreenId 
		AND a.Active = 'Y'
		AND ISNULL(a.RecordDeleted,'N')='N'
		ORDER BY CASE WHEN ISNULL(a.Template,'N') = 'Y' THEN 1 ELSE 2 END 
	 


    END TRY
    BEGIN CATCH
        DECLARE @Error VARCHAR(8000);
        SELECT  @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetToolBarListPageViews') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());		
        RAISERROR(@Error,		16,1 );

    END CATCH;