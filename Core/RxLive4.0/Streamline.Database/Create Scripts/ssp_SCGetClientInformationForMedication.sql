CREATE PROCEDURE [dbo].[ssp_SCGetClientInformationForMedication]                                        
(                                        
@ClientID as bigint                                        
)                                        
AS                                        
Begin                                        
/*********************************************************************/                                          
/* Stored Procedure: dbo.ssp_ClientInformationSelProcReport                */                                          
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                                          
/* Creation Date:    7/24/05                                         */                                          
/*                                                                   */                                          
/* Purpose:  Return Tables for ClientInformations and fill the type Dataset*/                                          
/*                                                                   */                                        
/* Input Parameters: none             */                                        
/*                                                                   */                                          
/* Output Parameters:   None                   */                                          
/*                                                                   */                                          
/* Return:  0=success, otherwise an error number                     */                                          
/*                                                                   */                                          
/* Called By:                                                        */                                          
/*                                                                   */                                          
/* Calls:                                                            */                                          
/*                                                                   */                                          
/* Data Modifications:                                               */                                          
/*                                                                   */                                          
/* Updates:                                                          */                                          
/*   Date     Author       Purpose                                    */                                          
/*                                  */                                          
/*********************************************************************/                                         
                                        
                                        
Select * from Clients where ClientID = @ClientID and (RecordDeleted is null or RecordDeleted='N')                                        
Select 0 AS DeleteButton,* from  ClientEpisodes where ClientID=@ClientID and (RecordDeleted is null or RecordDeleted='N')                                        
                                    
--ClientPhones                                     
SELECT     ClientPhones.*, GlobalCodes.SortOrder                                  
FROM         ClientPhones INNER JOIN                                    
                      GlobalCodes ON ClientPhones.PhoneType = GlobalCodes.GlobalCodeId                                    
WHERE     (ClientPhones.ClientId = @ClientID) AND (ISNULL(ClientPhones.RecordDeleted, 'N') = 'N') AND (GlobalCodes.Active = 'Y') AND                                     
                      (ISNULL(GlobalCodes.RecordDeleted, 'N') = 'N')                                    
                                  
--ClientAddresses                                     
SELECT     ClientAddresses.*, GlobalCodes.SortOrder                                   
FROM         ClientAddresses INNER JOIN                          
                      GlobalCodes ON ClientAddresses.AddressType = GlobalCodes.GlobalCodeId                                    
WHERE     (ClientAddresses.ClientId = @ClientID) AND (ISNULL(ClientAddresses.RecordDeleted, 'N') = 'N') AND (GlobalCodes.Active = 'Y') AND                                     
                      (ISNULL(GlobalCodes.RecordDeleted, 'N') = 'N')                                  
                                  
                                    
Select ClientContacts.ClientContactId,ClientContacts.ClientId,'D' as 'DeleteButton','N' as 'RadioButton',                   
 ClientContacts.LastName +', ' +ClientContacts.FirstName as Contact,GlobalCodes.CodeName,(Select top 1 PhoneNumber from ClientContactPhones where ClientContactPhones.ClientContactId = ClientContacts.ClientContactId and phonenumber is not null and         
 
     
      
        
         
             
             
                 
                  
                    
IsNull(RecordDeleted,'N')='N' order by phonetype ) as Phone,                                      
 ClientContacts.Organization,ClientContacts.Guardian,ClientContacts.EmergencyContact,ClientContacts.FinanciallyResponsible,ClientContacts.DOB,ClientContacts.ListAs,ClientContacts.Email,                                      
 (Select top 1 Address from clientcontactAddresses where clientcontactAddresses.ClientContactId = ClientContacts.ClientContactId and Address is not null order by AddressType) as Address,ClientContacts.Comment,ClientContacts.Relationship                   
  
    
      
        
         
,ClientContacts.FirstName,ClientContacts.LastName,ClientContacts.MiddleName,ClientContacts.Prefix,ClientContacts.Suffix,ClientContacts.RowIdentifier,ClientContacts.ExternalReferenceId,ClientContacts.CreatedBy,ClientContacts.CreatedDate,                   
  
    
      
       
ClientContacts.ModifiedBy,                           
ClientContacts.ModifiedDate,ClientContacts.RecordDeleted,ClientContacts.DeletedDate,ClientContacts.DeletedBy,ClientContacts.SSN,ClientContacts.SEX                                      
  from ClientContacts                                      
  inner join Globalcodes on GlobalCodes.GlobalCodeId = ClientContacts.Relationship and isNull(Globalcodes.RecordDeleted,'N')<>'Y' and category='RELATIONSHIP'                                          
  Where isNull(ClientContacts.RecordDeleted,'N')<>'Y' and ClientContacts.ClientId=@ClientID                                        
                                  
                                    
--clientcontactphones                                     
SELECT     ClientContactPhones.*, GlobalCodes.SortOrder                                  
FROM         ClientContactPhones INNER JOIN                                    
                      ClientContacts ON ClientContacts.ClientContactId = ClientContactPhones.ClientContactId AND ClientContacts.ClientId = @ClientID AND                                     
                      ISNULL(ClientContacts.RecordDeleted, 'N') = 'N' INNER JOIN                                    
                      GlobalCodes ON ClientContactPhones.PhoneType = GlobalCodes.GlobalCodeId                                    
WHERE     (ISNULL(ClientContactPhones.RecordDeleted, 'N') = 'N') AND (GlobalCodes.Active = 'Y') AND (ISNULL(GlobalCodes.RecordDeleted, 'N') = 'N')                                    
                                    
--ClientContactaddresses                                    
SELECT     ClientContactAddresses.*, GlobalCodes.SortOrder                                  
FROM         ClientContactAddresses INNER JOIN                                    
                      ClientContacts ON ClientContacts.ClientContactId = ClientContactAddresses.ClientContactId AND ClientContacts.ClientId = @ClientID AND                                     
                      ISNULL(ClientContacts.RecordDeleted, 'N') = 'N' INNER JOIN                                    
                      GlobalCodes ON ClientContactAddresses.AddressType = GlobalCodes.GlobalCodeId                      
WHERE     (ISNULL(ClientContactAddresses.RecordDeleted, 'N') = 'N') AND (GlobalCodes.Active = 'Y') AND (ISNULL(GlobalCodes.RecordDeleted, 'N') = 'N')                       
                                    
                                 
                                     
 IF (@@error!=0)                                        
 BEGIN                                        
        RAISERROR  20002  'ssp_ClientInformation_SelProcReport: An Error Occured'                                        
        RETURN(1)                                        
 END                                        
 RETURN(0)                                        
                                         
End   