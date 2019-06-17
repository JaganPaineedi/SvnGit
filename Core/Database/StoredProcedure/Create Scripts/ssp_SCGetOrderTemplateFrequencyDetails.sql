IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetOrderTemplateFrequencyDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetOrderTemplateFrequencyDetails]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetOrderTemplateFrequencyDetails]
@OrderTemplateFrequencyId INT
AS
/******************************************************************************
**		File: ssp_SCGetOrderTemplateFrequencyDetails.sql
**		Name: ssp_SCGetOrderTemplateFrequencyDetails
**		Desc: GetOrderTemplateFrequencyDetails 
**              
**		Return values: DetailPageOrderTemplateFrequencies
** 
**		Called by: SHS.SmartCareWeb\ActivityPages\Admin\Detail\OrderTemplateFrequencyDetails.ascx.cs  
**              
**		Parameters:
**		Input							Output
**      @OrderTemplateFrequencyId
**
**		Auth: Jason Stecznski
**		Date: 3/29/2015
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**		6/3/2015	Steczynski			Added IsDefault to Select statement
**		30/7/2015	Chethan N			What: Added SelectDays to Select statement
										Why: Philhaven Development task# 318
**		2/3/2016	Varun				What: Added OneTimeOnly to Select statement
										Why: Renaissance - Dev Items task# 651										
**    
*******************************************************************************/
BEGIN
BEGIN TRY

	SELECT OrderTemplateFrequencyId,  
		  CreatedBy,
          CreatedDate,
          ModifiedBy,
          ModifiedDate,
          RecordDeleted,
          DeletedDate,
          DeletedBy,
          TimesPerDay,
          CONVERT(VARCHAR(20), DispenseTime1) AS DispenseTime1, 
          CONVERT(VARCHAR(20), DispenseTime2) AS DispenseTime2, 
          CONVERT(VARCHAR(20), DispenseTime3) AS DispenseTime3, 
          CONVERT(VARCHAR(20), DispenseTime4) AS DispenseTime4, 
          CONVERT(VARCHAR(20), DispenseTime5) AS DispenseTime5, 
          CONVERT(VARCHAR(20), DispenseTime6) AS DispenseTime6, 
          CONVERT(VARCHAR(20), DispenseTime7) AS DispenseTime7, 
          CONVERT(VARCHAR(20), DispenseTime8) AS DispenseTime8, 
          FrequencyId,
          IsPRN,
          RxFrequencyId,
          DisplayName,
		  IsDefault,
		  SelectDays,
		  OneTimeOnly
	FROM dbo.OrderTemplateFrequencies  
	WHERE OrderTemplateFrequencyId = @OrderTemplateFrequencyId

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


