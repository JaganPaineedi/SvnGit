IF EXISTS ( SELECT
                    *
                FROM
                    sys.objects
                WHERE
                    object_id = OBJECT_ID(N'ssp_SCGetListPageConfigurations')
                    AND type IN ( N'P' , N'PC' ) )
    BEGIN 
        DROP PROCEDURE ssp_SCGetListPageConfigurations; 
    END;
                    GO

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO
CREATE PROCEDURE ssp_SCGetListPageConfigurations @ScreenId INT,
@StaffId INT = -1
AS /******************************************************************************
**		File: ssp_SCGetListPageConfigurations.sql
**		Name: ssp_SCGetListPageConfigurations
**		Desc: 
**
**		This template can be customized:
**              
**		Return values:
** 
**		Called by:   
**              
**		Parameters:
**		Input							Output
**     ----------							-----------
**
**		Auth: 
**		Date: 
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		    Author:				    Description:
**		--------		--------				-------------------------------------------
**	    03/08/2017      jcarlson			    created
**		05/31/2017		jcarlson				do not limit by staff
*******************************************************************************/ 
    BEGIN
	
        BEGIN TRY
		--Screens
		SELECT a.ScreenId
		FROM dbo.Screens AS a
		WHERE a.ScreenId = @ScreenId

		--ListPageColumnConfigurationColumns
		SELECT a.ListPageColumnConfigurationId, a.CreatedBy, a.CreatedDate, a.ModifiedBy, a.ModifiedDate, a.RecordDeleted, a.DeletedBy, a.DeletedDate, a.ScreenId,
             a.StaffId, a.ViewName, a.Active, a.DefaultView, a.Template
		FROM dbo.ListPageColumnConfigurations AS a
		WHERE a.ScreenId = @ScreenId 
		AND ISNULL(a.RecordDeleted,'N')='N'
		ORDER BY CASE WHEN ISNULL(a.Template,'N') = 'Y' THEN 1 ELSE 2 END
		--ListPageColumnConfigurations
	    SELECT a.ListPageColumnConfigurationColumnId, a.CreatedBy, a.CreatedDate, a.ModifiedBy, a.ModifiedDate, a.RecordDeleted, a.DeletedBy, a.DeletedDate,
            a.ListPageColumnConfigurationId, a.FieldName, a.Caption, a.DisplayAs, a.SortOrder, a.ShowColumn, a.Width, a.Fixed 
		FROM dbo.ListPageColumnConfigurationColumns AS a
		JOIN dbo.ListPageColumnConfigurations AS b ON b.ListPageColumnConfigurationId = a.ListPageColumnConfigurationId
		AND ISNULL(b.RecordDeleted,'N')='N'
		WHERE b.ScreenId = @ScreenId 
		AND ISNULL(a.RecordDeleted,'N')='N'
		ORDER BY a.SortOrder


        END TRY

        BEGIN CATCH
            DECLARE @Error VARCHAR(8000);

            SET @Error = CONVERT(VARCHAR , ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000) , ERROR_MESSAGE())
                + '*****' + ISNULL(CONVERT(VARCHAR , ERROR_PROCEDURE()) , 'ssp_SCGetListPageConfigurations') + '*****'
                + CONVERT(VARCHAR , ERROR_LINE()) + '*****' + CONVERT(VARCHAR , ERROR_SEVERITY()) + '*****'
                + CONVERT(VARCHAR , ERROR_STATE());

            RAISERROR (
				@Error
				,-- Message text.                                                                     
				16
				,-- Severity.                                                            
				1 -- State.                                                         
				);
        END CATCH;
    END;

GO

