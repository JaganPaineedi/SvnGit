/****** Object:  StoredProcedure [dbo].[ssp_SCInsertSurveillanceDownloadHistory]    Script Date: 17-05-2017 13:04:33 ******/
DROP PROCEDURE [dbo].[ssp_SCInsertSurveillanceDownloadHistory]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCInsertSurveillanceDownloadHistory]    Script Date: 17-05-2017 13:04:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[ssp_SCInsertSurveillanceDownloadHistory]   
@DocumentIds varchar(max)                          
/********************************************************************************                                          
-- Stored Procedure: dbo.SendPagePublicHealthSurveillance                                            
-- Copyright: Streamline Healthcate Solutions                                          
-- Purpose: used by Public Health Surveillance list page to insert record 
-- in SurveillanceDownloadHistory Table                                         
-- Updates:                                                                                                 
-- Date        Author            Purpose                                          
-- 05.12.2017  Varun			 Created.                                                
*********************************************************************************/                                          
AS                                                              
 Begin                                                                          
 BEGIN TRY
	DECLARE @DocumentId INT
	DECLARE @PublicHealthSurveillanceId INT
	DECLARE @RowCount INT
	DECLARE @Counter INT

	SET @RowCount = 0

	--Split the clientIds and store it in table variable @ClientTable
	DECLARE @TempTable TABLE (
		Id INT identity
		,DocumentId INT
		)

	INSERT INTO @TempTable (DocumentId)
	SELECT item
	FROM [dbo].fnSplit(@DocumentIds, ',')

	SET @RowCount = @@RowCount
	SET @Counter = 1

	--loop through the Clientids to insert the record in the PublicHealthSurveillances table for each client id(row)
	WHILE @Counter <= @RowCount
	BEGIN
		SELECT @DocumentId = DocumentId
		FROM @TempTable
		WHERE Id = @Counter

		-- insert the record in the SurveillanceDownloadHistory table
		INSERT INTO SurveillanceDownloadHistory (
			DocumentId
			,LastDownload
			)
		VALUES (
			@DocumentId
			,getdate()
			)

		SET @Counter = @Counter + 1
	END
END TRY                                                                                     
BEGIN CATCH                              
                            
DECLARE @Error varchar(8000)                                                                           
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                        
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'SendPagePublicHealthSurveillance')                                                                                                         
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                          
    + '*****' + Convert(varchar,ERROR_STATE())                                                       
 RAISERROR                                                     
 (                                                              
  @Error, -- Message text.                                                                                                        
  16, -- Severity.                                     
  1 -- State.                                                                                                        
 );                                                                                                      
END CATCH                                            
END  

GO


