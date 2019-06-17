/********************************************************************************                                                        
         
-- Copyright: Streamline Healthcare Solutions          
--          
-- Purpose: Called in Update screen for KPIMaster        
--          
/* Data Modifications:                                               */    
/*                                                                   */    
/*   Date  		Author       Purpose                                    */    
/*   7 Mar 2019    Abhishek     Created                        */    
/*********************************************************************/       
*********************************************************************************/
update KPIMaster set CollectionStoredProcedure = 'ssp_SCKPIReportHL7QueueAlerts', Active = 'Y', ProcessingStoredProcedure = 'ssp_SCKPIReportProcessAlerts' where kpimasterId = 4