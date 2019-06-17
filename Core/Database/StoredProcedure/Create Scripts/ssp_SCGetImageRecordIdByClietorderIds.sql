/****** Object:  StoredProcedure [dbo].[ssp_SCGetImageRecordIdByClietorderIds]    Script Date: 01/04/2017 11:51:26 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetImageRecordIdByClietorderIds]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetImageRecordIdByClietorderIds]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetImageRecordIdByClietorderIds]    Script Date: 01/04/2017 11:51:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetImageRecordIdByClietorderIds] 
@ClientOrderIds VARCHAR(500)
	,@ResultOrEReq VARCHAR(50)
AS
/******************************************************************************                                
                            
**  Name: [ssp_SCGetImageRecordIdByClietorderIds]                                
**  Desc: Get ImageRecordId and ImageServerId for Client Orders
**                                
**  This template can be customized:                                
**                                              
**  Return values:                                
**                                 
**  Called by:                                   
**                                              
**  Parameters:                                
**  Input       Output                                
**     ----------       -----------                                
**                                
**  Auth: Chethan N                   
**  Date: 03 Jan 2017
*******************************************************************************                                
**  Change History                                
*******************************************************************************                                
**  Date:  Author:    Description:                                
**  --------  --------    -------------------------------------------                                
**   
**  08/16/2018		Chethan N		What : Retrieving 'Lab Results' OR 'Lab Requisition' based on the @ResultOrEReq parameter.
									Why : AHN Support GO live Task # 163	                                 
*******************************************************************************/
BEGIN TRY
	
		SELECT COIR.ImageRecordId
			,IR.ImageServerId
		FROM ClientOrderImageRecords COIR
		JOIN ImageRecords IR ON IR.ImageRecordId = COIR.ImageRecordId
		WHERE ClientOrderId IN (
				SELECT Token
				FROM [dbo].[SplitString](@ClientOrderIds, ',')
				)
			AND (
				(
					@ResultOrEReq = 'Result'
					AND IR.RecordDescription <> 'Lab Requisition'
					)
				OR (
					@ResultOrEReq = 'EReq'
					AND IR.RecordDescription = 'Lab Requisition'
					)
				)
			AND ISNULL(COIR.RecordDeleted, 'N') = 'N'
			AND ISNULL(IR.RecordDeleted, 'N') = 'N'
END TRY

BEGIN CATCH          
	DECLARE @Error varchar(8000)                                                 
	SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                        
	+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCGetImageRecordIdByClietorderIds')                                                                               
	+ '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                
	+ '*****' + Convert(varchar,ERROR_STATE())                                           
	RAISERROR ( @Error, /* Message text.*/16, /* Severity.*/ 1 /*State.*/ );    
END CATCH
GO


