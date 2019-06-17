IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetDisclsoureDetailsForROI]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetDisclsoureDetailsForROI]
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetDisclsoureDetailsForROI] @DisclosedToDetailId INT = NULL
,@DiscloserType char(1)
AS
/*************************************************************************/                
/* Stored Procedure: dbo.ssp_GetDisclsoureDetailsForROI              */                
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
/*  Date            Author				Purpose                          */  
/*************************************************************************/ 
BEGIN TRY
BEGIN
		
  IF @DiscloserType='O'
	BEGIN			
		SELECT DISTINCT DisclosedToDetailId 
			,Name
			,OrganizationName
			,DisclsoureAddress
			,DisclsoureAddress2
			,City
			,S.StateAbbreviation AS DisclsoureState
			,ZipCode
			,PhoneNumber
		FROM DisclosedToDetails  DT
		LEFT JOIN States S ON DT.DisclsoureState=S.StateFIPS
		WHERE ISNULL(DT.RecordDeleted, 'N') = 'N'
		AND DisclosedToDetailId=@DisclosedToDetailId
    END
    ELSE IF @DiscloserType='C'
		BEGIN
			SELECT DISTINCT CC.ClientContactId AS DisclosedToDetailId
			,(CC.LastName + ', ' + CC.FirstName ) AS Name
			,Organization AS OrganizationName
			,CCA.[Address] AS DisclsoureAddress
			,'' AS DisclsoureAddress2
			,CCA.City
			,CCA.[State] AS DisclsoureState
			,CCA.Zip AS ZipCode
			,CCP.PhoneNumberText AS PhoneNumber
		FROM ClientContacts AS CC 
		LEFT JOIN ClientContactAddresses CCA ON CC.ClientContactId=CCA.ClientContactId
		LEFT JOIN ClientContactPhones CCP ON CC.ClientContactId=CCP.ClientContactId
		WHERE ISNULL(CC.RecordDeleted, 'N') = 'N'
		AND ISNULL(CCA.RecordDeleted, 'N') = 'N'
		AND ISNULL(CCP.RecordDeleted, 'N') = 'N'
		AND CC.ClientContactId =@DisclosedToDetailId
		END
		
END
END TRY
 BEGIN CATCH                                 
        DECLARE @Error VARCHAR(8000)                                  
        SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
            + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
            + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
                     '[ssp_GetDisclsoureDetailsForROI]') + '*****'
            + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
            + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
            + CONVERT(VARCHAR, ERROR_STATE())                                  
                                                                        
                              
        RAISERROR(@Error,16,1);                                  
                                  
    END CATCH    
GO

