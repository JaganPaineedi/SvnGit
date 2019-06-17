CREATE  PROCEDURE [dbo].[ssp_SCGetClientMedicationSystemReports]      
  @ReportName  nvarchar(100)                 
AS                            
/*********************************************************************/                              
/* Stored Procedure: dbo.[ssp_SCMedicationStrength]                */                              
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                              
/* Creation Date:    21/Aug/07                                         */                             
/*                                                                   */                              
/* Purpose:  Populate Strength combobox   */                              
/*                                                                   */                            
/* Input Parameters: none       */                            
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
/*   Date     Author       Purpose                                    */                              
/*  21/Aug/07   Rishu    Created                                    */                              
/*********************************************************************/                                 
BEGIN                  
               
select ReportURL from dbo.SystemReports where ReportName=@ReportName and IsNull(RecordDeleted,'N')<>'Y'      
                   
                            
 IF (@@error!=0)                              
BEGIN                              
    RAISERROR  20002 'ssp_SCGetClientMedicationSystemReports : An error  occured'                              
                             
    RETURN(1)                              
                               
END                                   
                            
END   