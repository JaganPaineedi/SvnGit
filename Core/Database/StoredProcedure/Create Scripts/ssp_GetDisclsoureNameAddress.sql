/****** Object:  StoredProcedure [dbo].[ssp_GetDisclsoureNameAddress]    Script Date: 03/18/2016 10:00:32 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetDisclsoureNameAddress]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetDisclsoureNameAddress]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetDisclsoureNameAddress]    Script Date: 03/18/2016 10:00:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetDisclsoureNameAddress] @DisclsoureDetailId INT
AS
/*************************************************************************/                
/* Stored Procedure: dbo.ssp_GetDisclsoureNameAddress             */                
/* Copyright: DisclosureTo Details					 */                
/* Creation Date:  25/03/2016											 */                
/*                                                                       */                
/* Purpose: retuns the details of NamAddress               */               
/*                                                                       */              
/* Input Parameters: @DisclsoureDetailId                                       */              
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
/*	25/03/2016		Lakshmi kanth		Returning NameAddress from disclosureTo Details, for task#613.8 Network 180															*/
/*************************************************************************/  
BEGIN TRY      
BEGIN
	SELECT DT.DisclosedToDetailId
		,DT.NAME
		,DT.DisclsoureAddress
		,DT.Fax
	FROM DisclosedToDetails  DT
	WHERE ISNULL(RecordDeleted, 'N') <> 'Y'
		AND DisclosedToDetailId = @DisclsoureDetailId
	--ORDER BY DisclsoureDetailId DESC
END
END TRY

    BEGIN CATCH                                 
        DECLARE @Error VARCHAR(8000)                                  
        SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
            + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
            + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
                     '[ssp_GetDisclsoureNameAddress]') + '*****'
            + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
            + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
            + CONVERT(VARCHAR, ERROR_STATE())                                  
                      
--set @result=0                                                    
                              
        RAISERROR                                   
 (                                  
  @Error, -- Message text.                                  
  16,                                  
  1                                 
 ) ;                                  
                                  
    END CATCH      
GO

