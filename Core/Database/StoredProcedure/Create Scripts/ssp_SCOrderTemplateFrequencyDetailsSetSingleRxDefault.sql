IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCOrderTemplateFrequencyDetailsSetSingleRxDefault]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCOrderTemplateFrequencyDetailsSetSingleRxDefault]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCOrderTemplateFrequencyDetailsSetSingleRxDefault]
@OrderTemplateFrequencyId INT
AS
/******************************************************************************
**		File: ssp_SCOrderTemplateFrequencyDetailsSetSingleRxDefault.sql
**		Name: ssp_SCOrderTemplateFrequencyDetailsSetSingleRxDefault
**		Desc: When IsDefault = 'Y' for @OrderTemplateFrequencyId  
**			  this SP sets IsDefault to 'N' For all records except 
**			  @OrderTemplateFrequencyId for the matching RxFrequencyId
**              
**		Return values: 
** 
**		Called by: SHS.SmartCareWeb\MAR\Admin\Detail\OrderTemplateFrequencyDetails.ascx.cs
**              
**		Parameters:
**		Input							Output
**      @OrderTemplateFrequencyId
**		@IsDefault
**
**		Auth: Jason Stecznski
**		Date: 6/5/2015
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**		---			---					---
**    
*******************************************************************************/
BEGIN
BEGIN TRY

	DECLARE @IsDefault VARCHAR(1), 
			@RxFrequencyId INT

	SELECT @IsDefault = IsDefault, @RxFrequencyId = RxFrequencyId 
	FROM dbo.OrderTemplateFrequencies 
	WHERE OrderTemplateFrequencyId = @OrderTemplateFrequencyId

	IF @IsDefault = 'Y' AND @RxFrequencyId > 0
		BEGIN
			UPDATE dbo.OrderTemplateFrequencies
			SET IsDefault = 'N'
			WHERE RxFrequencyId = @RxFrequencyId
			AND OrderTemplateFrequencyId <> @OrderTemplateFrequencyId;
		END

 END TRY                
   BEGIN CATCH                
       DECLARE @Error VARCHAR(8000)                                                   
    SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                  
    + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'[csp_GetRDLHeader]')                                                   
    + '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****ERROR_SEVERITY=' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                  
    + '*****ERROR_STATE=' + CONVERT(VARCHAR,ERROR_STATE())                                                  
    RAISERROR                                                   
    (                                                   
    @Error, -- Message text.                                                   
    16, -- Severity.                                                   
    1 -- State.                             
    )                
   END CATCH                              
END

GO


