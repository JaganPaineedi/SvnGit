IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'csp_GetClientContactsName')
	BEGIN
		DROP  Procedure  csp_GetClientContactsName
	END

GO
Create Procedure [dbo].[csp_GetClientContactsName] --2
 @ClientID INT      
AS      
 /*********************************************************************/                                                                                            
 /* Stored Procedure: csp_GetClientContactsName      */                                                                                   
 /* Creation Date:  09/July/2013                                     */                                                                                            
 /* Purpose: To Get Member Contact           */      
 /* Input Parameters: @ClientId            */                                                                                          
 /* Output Parameters:              */                                                                                            
 /* Return:                 */                                                                                            
 /* Called By:Document Screen              */                                                                                  
 /* Calls:                                                            */                                                                                            
 /*                                                                   */                                                                                            
 /* Data Modifications:                                               */                                                                                            
 /* Updates:                                                          */                                                                                            
 /* Date              Author                  Purpose      */           
 /* 18/June/2013   Md Hussain Khusro         Create      */       
 /*********************************************************************/         
        
Begin                                  
Begin TRY       
      
 --SELECT DISTINCT  CC.ClientContactId      
 --    ,CC.ListAs      
 --    ,COALESCE(CC.LastName,'') + ', ' + COALESCE(CC.FirstName,'') AS Name
 --       ,dbo.csf_GetGlobalCodeNameById(Relationship) AS  Relationship      
 --    FROM       
 -- ClientContacts AS CC                  
 -- WHERE CC.ClientId=@ClientId AND ISNULL(CC.RecordDeleted,'N')='N' AND active='Y'     
 
  SELECT  
            ClientContacts.ClientContactId ,  
            ClientContacts.ClientId ,  
            ClientContacts.FirstName + ' ' + ClientContacts.LastName AS Name ,  
            --GlobalCodes.CodeName ,  
            GlobalCodes.CodeName AS RelationshipText ,  
            ( SELECT TOP ( 1 )  
                        PhoneNumber  
              FROM      ClientContactPhones  
   WHERE     ( ClientContactId = ClientContacts.ClientContactId )  
                        AND ( PhoneNumber IS NOT NULL )  
                        AND ( ISNULL(RecordDeleted, 'N') = 'N' )  AND ClientContacts.Active='Y'
              ORDER BY  PhoneType  
            ) AS Phone ,  
            --ClientContacts.ListAs ,  
            
            ( SELECT TOP ( 1 )  
                        --Address  
                        Display
              FROM      ClientContactAddresses  
              WHERE     ( ClientContactId = ClientContacts.ClientContactId )  
                        AND ( Address IS NOT NULL )  
              ORDER BY  AddressType  
            ) AS Address  
            --ClientContacts.Comment ,  
            --ClientContacts.Relationship ,  
            --ClientContacts.FirstName ,  
            --ClientContacts.LastName ,  
            --ClientContacts.MiddleName 
           
    FROM    ClientContacts  
            LEFT JOIN GlobalCodes ON GlobalCodes.GlobalCodeId = ClientContacts.Relationship  
                                      AND ISNULL(GlobalCodes.RecordDeleted,  
                                                 'N') <> 'Y'  
                                      AND GlobalCodes.Category = 'RELATIONSHIP'  
    WHERE   ( ISNULL(ClientContacts.RecordDeleted, 'N') <> 'Y' )  
            AND ( ClientContacts.ClientId = @ClientID )  AND ClientContacts.Active='Y'
 
 
        
END TRY                                                                              
BEGIN CATCH                                  
DECLARE @Error varchar(8000)                                                                               
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                         
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_GetClientContactsName')                                                                                                             
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