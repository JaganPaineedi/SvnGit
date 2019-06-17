
/****** Object:  StoredProcedure [dbo].[ssp_GetAssociatedDocumentsToValues]    Script Date: 03/18/2016 09:59:01 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetAssociatedDocumentsToValues]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetAssociatedDocumentsToValues]

/****** Object:  StoredProcedure [dbo].[ssp_GetAssociatedDocumentsToValues]    Script Date: 03/18/2016 09:59:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetAssociatedDocumentsToValues] @ClientId INT = NULL
	,@DisclosureNameSearch VARCHAR(max)
AS
/*************************************************************************/                
/* Stored Procedure: dbo.ssp_GetAssociatedDocumentsToValues             */                
/* Copyright: DisclosureTo Details	
	Created By Sunil.D							 */                
/* Creation Date:  21/09/2017										 */                
/*                                                                       */                
/* Purpose: retuns the details of NamAddress
 Task: Thresholds-Enhancements #838              */               
/*                                                                       */              
/* Input Parameters: @ClientId,@DisclosureNameSearch                                       */              
/*																		 */                
/* Output Parameters:													 */                
/*                                                                       */                
/* Return:                                                               */                
/*                                                                       */                
/* Called By:                                                            */                
/*                                                                       */                
/* Calls:                                                                */                
/*                                                                       */                
/* Data Modifications:                                                   */                
/*                                                                       */                
/* Updates:                                                              */                
/*  Date            Author				Purpose                  */  
 
 
/*************************************************************************/ 
BEGIN TRY
BEGIN
	DECLARE @DisclosureName VARCHAR(50)
	SET @DisclosureName = '%' + @DisclosureNameSearch + '%' 
	SELECT DISTINCT CAST(CC.ClientContactId AS VARCHAR(12)) + 'C' AS DisclosedToDetailId 
			,(CC.LastName + ', ' + CC.FirstName ) AS NAME
		FROM ClientContacts AS CC
		WHERE CC.ClientId = @ClientId
			AND (
				CC.FirstName LIKE @DisclosureName
				OR CC.LastName LIKE @DisclosureName
				OR CC.ListAs LIKE @DisclosureName
				)
			AND ISNULL(CC.RecordDeleted, 'N') = 'N'
			AND Active = 'Y' 
		UNION 
	SELECT DISTINCT CAST(DT.DisclosedToDetailId AS VARCHAR(12)) + 'D' AS DisclosedToDetailId 
		,DT.NAME
	FROM DisclosedToDetails  DT
	WHERE  
		ISNULL(RecordDeleted, 'N') = 'N'
		AND (
			DT.FirstName LIKE @DisclosureName
			OR DT.LastName LIKE @DisclosureName
			OR DT.NAME LIKE @DisclosureName
			)
END
END TRY
 BEGIN CATCH                                 
        DECLARE @Error VARCHAR(8000)                                  
        SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
            + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
            + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
                     '[ssp_GetAssociatedDocumentsToValues]') + '*****'
            + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
            + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
            + CONVERT(VARCHAR, ERROR_STATE())                                  
                                                                    
                              
        RAISERROR                                   
 (                                  
  @Error,                               
  16,                                  
  1                                 
 ) ;                                  
                                  
    END CATCH    
GO

