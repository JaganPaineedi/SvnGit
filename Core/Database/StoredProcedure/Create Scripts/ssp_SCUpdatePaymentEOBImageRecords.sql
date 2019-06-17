/****** Object:  StoredProcedure [dbo].[ssp_SCUpdatePaymentEOBImageRecords]    Script Date: 03/07/2016 11:35:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCUpdatePaymentEOBImageRecords]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCUpdatePaymentEOBImageRecords]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCUpdatePaymentEOBImageRecords]    Script Date: 03/07/2016 11:35:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCUpdatePaymentEOBImageRecords] (
	@ImageRecordIds VARCHAR(MAX),
	@UserCode VARCHAR(30)
	)

/********************************************************************************                                                 
** Stored Procedure: ssp_SCUpdatePaymentEOBImageRecords                                                    
**                                                  
** Copyright: Streamline Healthcate Solutions                                                    
** Updates:                                                                                                         
** Date            Author              Purpose   
** 07-MAR-2016	   Akwinass			   What:To Update Payment EOB Image Records      
**									   Why:Task #840 in Renaissance - Dev Items 
*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		IF OBJECT_ID('tempdb..#ImageRecordIds') IS NOT NULL
			DROP TABLE #ImageRecordIds
			
		CREATE TABLE #ImageRecordIds(ImageRecordId INT)
		
		IF ISNULL(@ImageRecordIds,'') <> ''
		BEGIN
			INSERT INTO #ImageRecordIds (ImageRecordId)
			SELECT DISTINCT item FROM dbo.fnSplit(ISNULL(@ImageRecordIds,''), ',') WHERE ISNULL(item, '') <> ''
		END
		
		DECLARE @ImageRecord_Id INT

		DECLARE imagerecordid_cursor CURSOR
		FOR
		SELECT ImageRecordId
		FROM #ImageRecordIds

		OPEN imagerecordid_cursor

		FETCH NEXT FROM imagerecordid_cursor INTO @ImageRecord_Id

		WHILE @@FETCH_STATUS = 0
		BEGIN			
			EXEC [dbo].[ssp_SCDeleteImageRecords] @ImageRecordId = @ImageRecord_Id,@UserCode = @UserCode

			FETCH NEXT FROM imagerecordid_cursor INTO @ImageRecord_Id
		END

		CLOSE imagerecordid_cursor

		DEALLOCATE imagerecordid_cursor
	END TRY

      BEGIN CATCH
          DECLARE @error VARCHAR(8000)

          SET @error= CONVERT(VARCHAR, Error_number()) + '*****'
                      + CONVERT(VARCHAR(4000), Error_message())
                      + '*****'
                      + Isnull(CONVERT(VARCHAR, Error_procedure()),
                      'ssp_SCUpdatePaymentEOBImageRecords')
                      + '*****' + CONVERT(VARCHAR, Error_line())
                      + '*****' + CONVERT(VARCHAR, Error_severity())
                      + '*****' + CONVERT(VARCHAR, Error_state())

          RAISERROR (@error,-- Message text.
                     16,-- Severity.
                     1 -- State.
          );
      END CATCH
  END 
GO


