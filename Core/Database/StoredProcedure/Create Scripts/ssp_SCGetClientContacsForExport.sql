SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[ssp_SCGetClientContacsForExport]')
                    AND type IN (N'P', N'PC') ) 
    DROP PROCEDURE [ssp_SCGetClientContacsForExport]
GO

  
 
CREATE PROCEDURE [dbo].[ssp_SCGetClientContacsForExport]
	@ClientId INT
    
/****************************************************************************************************************************/                                                    
/* Stored Procedure: dbo.[ssp_SCGetClientContacsForExport]                                                                  */                                                    
/* Creation Date:    10/Nov/2014																				              */                                                    
/* Created By: Deej																							      */                                                    
/* Purpose: Get Client Contacts to export					                                                                */                                                    
/*                                                                                                                          */                                                     
/* Data Modifications:                                                                                                      */                                                    
/*                                                                                                                          */                                                    
/* Updates:                                                                                                                 */                                                    
/*   Date                   Author           Purpose                                                                        */      
/*   ----                   ------           -------                                                                        */      
/*   21/09/2017            Pradeep Y         They do not want time field in DOB for Task #709 Interact - Support                                                                                                  */                                                    
/****************************************************************************************************************************/
AS 
    BEGIN  
        BEGIN TRY  
            SELECT 
				  GC.CodeName AS Relations
				 ,CC.Prefix
				 ,CC.FirstName
				 ,CC.MiddleName
				 ,CC.LastName
				 ,CC.Suffix
				 ,Convert(varchar(15), CC.DOB, 101)As DOB
				 ,CASE WHEN CC.Sex='M' THEN 'Male' 
                  WHEN CC.Sex='F' THEN 'Female'  ELSE NULL END AS Sex 
				 ,CC.Email
				 ,CC.Active
				 ,GCP.CodeName AS PhoneType
				 ,CCP.PhoneNumber
				 ,GCA.CodeName AS AddressType
				 ,CCA.Display AS [Address]
				 ,ISNULL(CCA.Mailing,'N') AS Mailing
				 ,CC.ModifiedDate
				 ,CC.ModifiedBy
				 
			FROM 
				ClientContacts CC
			LEFT JOIN ClientContactAddresses CCA ON CCA.ClientContactId=CC.ClientContactId AND ISNULL(CCA.RecordDeleted,'N')='N' 
			LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId=CC.Relationship
			LEFT JOIN ClientContactPhones CCP ON CCP.ClientContactId=CC.ClientContactId AND ISNULL(CCP.RecordDeleted,'N')='N'
			LEFT JOIN GlobalCodes GCP ON GCP.GlobalCodeId=CCP.PhoneType
			LEFT JOIN GlobalCodes GCA ON GCA.GlobalCodeId=CCA.AddressType
			WHERE
				 ISNULL(CC.RecordDeleted,'N')='N' AND CC.ClientId= @ClientId 
            
            
        END TRY    
        BEGIN CATCH    
            DECLARE @Error VARCHAR(8000)                                                                           
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetClientContacsForExport') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())                                                      
            RAISERROR                                                                                                         
                (                                                                           
                 @Error, -- Message text.                                                                                                        
                 16, -- Severity.                                                                                                        
                 1 -- State.                                                                                                        
                );  
        END CATCH    
    END    


GO
