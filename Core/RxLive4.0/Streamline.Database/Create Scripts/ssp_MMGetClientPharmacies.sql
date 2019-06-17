Create procedure [dbo].[ssp_MMGetClientPharmacies]                            
@ClientId int                            
                        
as                          
/**********************************************************************/                              
/* Stored Procedure: dbo.ssp_MMGetClientPharmacies            */                              
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC              */                              
/* Creation Date:    23-Dec-2008                                       */                              
/*                                                                    */                              
/* Purpose:Used to get ClientPharmacies                  */                             
/*                                                                    */                            
/* Input Parameters: @ClientId                    */                            
/*                                                                    */                              
/* Output Parameters:   None                                          */                              
/*                                                                    */                              
/* Return:  0=success, otherwise an error number                      */                              
/*                                                                    */                              
/* Called By: ClientMedications.cs               */                              
/*                                                                    */                              
/* Calls:                                                             */                              
/*                                                                    */                              
/* Data Modifications:                                                */                              
/*                                                                    */                              
/* Updates:                                                           */                              
/*    Date        Author       Purpose                                */                              
/* 23-Dec-2008   Loveena    Created                                   */          
/*                   */                          
/*                   */  
/**********************************************************************/                               
                          
BEGIN                            
  
select ClientPharmacyId,ClientId,SequenceNumber,PharmacyId,RowIdentifier,ExternalReferenceId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RecordDeleted,DeletedDate,DeletedBy from ClientPharmacies where ClientId=@ClientId and ISNULL(RecordDeleted,'N')='N'                                                      
                          
  
    IF (@@error!=0)                            
    BEGIN                            
        RAISERROR  20002 'Client Pharmacies : An Error Occured '                            
        RETURN(1)                            
    END                            
    RETURN(0)                            
END   
