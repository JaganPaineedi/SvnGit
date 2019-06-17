CREATE procedure [dbo].[ssp_SCGetClientMedicationOrderDetails]                  
(                      
 @ClientMedicationId int  =0                      
)                      
as                      
/*********************************************************************/                              
/* Stored Procedure: dbo.ssp_SCGetMedicationOrderDetails                */                              
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                              
/* Creation Date:    12/Sep/07                                         */                             
/*                                                                   */                              
/* Purpose:  To retrieve ClientMedicationOrderDetails   */                              
/*                                                                   */                            
/* Input Parameters: none        @ClientMedicationId */                            
/*                                                                   */                              
/* Output Parameters:   None                           */                              
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
/*   Date      Author       Purpose                                  */                              
/*  04/Nov/07    Sonia    Created                                    */                              
/*********************************************************************/                         
begin                      
               
    
         
select *,isnull(DSMCode,'0')+ '_' + isnull(cast(DSMNumber as varchar),'0') as DxId from clientmedications where clientmedicationid=@ClientMedicationId and ISNULL(RecordDeleted,'N')='N'                
                
                    
select StrengthDescription,CMI.*,           
( Convert(varchar,CMI.Quantity) + ' ' + Convert(varchar,GC.CodeName) + ' '+ Convert(varchar,GC1.CodeName))  as Instruction,MN.MedicationName           
                                  
             
from clientmedicationinstructions CMI inner Join ClientMedications CM on (CMI.clientmedicationid=CM.clientmedicationid and ISNULL(CMI.RecordDeleted,'N')='N')          
JOIN MDMedications M on (M.MedicationNameId=CM.MedicationNameId and M.MedicationId=CMI.StrengthId and ISNULL(M.RecordDeleted,'N')='N')            
JOIN MDMedicationNames MN on(MN.MedicationNameId=M.MedicationNameId and ISNULL(MN.RecordDeleted,'N')='N' )         
LEFT JOIN GlobalCodes GC on (GC.GlobalCodeID = CMI.Unit)                            
LEFT JOIN GlobalCodes GC1 on (GC1.GlobalCodeId = CMI.Schedule)                             
where  CM.clientmedicationid=@ClientMedicationId and ISNULL(CM.RecordDeleted,'N')='N'                
    
    
                        
                  
                  
IF (@@error!=0)                              
    BEGIN                              
        RAISERROR  20002 'ssp_SCGetMedicationOrderDetails : An error  occured'                              
     
        RETURN(1)                              
                                   
    END                       
                            
end  