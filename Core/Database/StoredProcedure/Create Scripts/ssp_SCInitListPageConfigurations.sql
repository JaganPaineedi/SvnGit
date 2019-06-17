IF EXISTS ( SELECT
                    *
                FROM
                    sys.objects
                WHERE
                    object_id = OBJECT_ID(N'[dbo].[ssp_SCInitListPageConfigurations]')
                    AND type IN ( N'P' , N'PC' ) )
    DROP PROCEDURE [dbo].ssp_SCInitListPageConfigurations;
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCInitListPageConfigurationsr]    Script Date:   ******/
SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE PROCEDURE [dbo].ssp_SCInitListPageConfigurations
    @StaffId INT ,
    @ClientID INT ,
    @CustomParameters XML
AS /******************************************************************************
**		File: ssp_SCInitListPageConfigurations.sql
**		Name: ssp_SCInitListPageConfigurations
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
**		Auth: jcarlson
**		Date: 3/8/2017
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:	    	Author:	     			Description:
**		--------		--------				-------------------------------------------
**	    3/8/2017          jcarlson	            created
*******************************************************************************/     
    BEGIN
        BEGIN TRY
	

		  SELECT TOP 1
				'Screens' AS TableName ,
				-1 AS ScreenId,
				'' AS CreatedBy,
				GETDATE() AS CreatedDate,
				'' AS ModifiedBy,
				GETDATE() AS ModifiedDate
				FROM dbo.SystemConfigurations AS a


				
        END TRY

        BEGIN CATCH
            DECLARE @Error VARCHAR(8000);

            SET @Error = CONVERT(VARCHAR , ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000) , ERROR_MESSAGE())
                + '*****' + ISNULL(CONVERT(VARCHAR , ERROR_PROCEDURE()) , 'ssp_SCInitListPageConfigurations') + '*****'
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

