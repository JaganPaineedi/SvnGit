
/****** Object:  StoredProcedure [dbo].[ssp_GetDisclsoureToValues]    Script Date: 03/18/2016 09:59:01 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetDisclsoureToValues]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetDisclsoureToValues]

/****** Object:  StoredProcedure [dbo].[ssp_GetDisclsoureToValues]    Script Date: 03/18/2016 09:59:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetDisclsoureToValues] @ClientId INT = NULL
	,@DisclosureNameSearch VARCHAR(max)
AS
/*************************************************************************/                
/* Stored Procedure: dbo.ssp_GetDisclsoureToValues             */                
/* Copyright: DisclosureTo Details					 */                
/* Creation Date:  25/03/2016											 */                
/*                                                                       */                
/* Purpose: retuns the details of NamAddress               */               
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
/*	25/03/2016		Lakshmi kanth		Getting data for binding from disclosureTo Details, for task#613.8 Network 180		*/
/*  21-July-2016    Basudev Sahu     Removed Client specific condition for disclosure name search for task 297 Network 180 Environment Issues Tracking  */
/*  4/10/2017       Hemant Kumar     Included the Client Contacts table to the Disclosed To search field to get the client contacts on search, for task#613.8 Network 180*/
/*  5/29/2017       Hemant Kumar     Modified the preference is that the display is standardized for both Organizational contacts and Client contacts to be “LastName, FirstName”."
                                     Harbor - Support #831.1
*/
/*************************************************************************/ 
BEGIN TRY
BEGIN
	DECLARE @DisclosureName VARCHAR(50)
	SET @DisclosureName = '%' + @DisclosureNameSearch + '%'
	
	SELECT DISTINCT CAST(CC.ClientContactId AS VARCHAR(12)) + 'C' AS DisclosedToDetailId
			--,CC.ListAs
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
	--ClientId = @ClientId    --21-July-2016    Basudev Sahu 
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
                     '[ssp_GetDisclsoureToValues]') + '*****'
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

