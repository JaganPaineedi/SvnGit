USE [MedicationDev8.30]
GO
/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientMedicationScriptHistory]    Script Date: 03/25/2009 16:28:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
ALTER procedure              
[dbo].[ssp_SCGetClientMedicationScriptHistory]    
(                                
@ClientId Int,                        
@ClientMedicationId int,    
@ClientMedicationScriptId int                                
)                                                             
as                                                                
/*********************************************************************/                                        
                                             
/* Stored Procedure: dbo.ssp_SCGetClientMedicationScriptHistory                */                              
                                                       
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                                        
                                             
/* Creation Date:    27/Nov/2007                                         */                                    
                                                
/*                                                                   */                                        
                                             
/* Purpose:  To Get Client Medication's Scripts  Data */                                                        
                             
/*                                                                   */                                        
                                           
/* Input Parameters: none        @ClientId,@ClientMedicationId */                                                                  
                 
/*                                                                   */                                        
                                             
/* Output Parameters:   None                           */                                                      
                               
/*                                                                   */                                        
                                             
/* Return:  0=success, otherwise an error number                     */                                        
                                             
/*                                                                   */                                        
                                             
/* Called By:Order Details Page of Medication Mgt                                                              
       */                                                                        
/*                                                                   */                                        
                                             
/* Calls:                                                            */                                        
                                             
/*                                                                   */                                        
                                             
/* Data Modifications:                                               */                                        
                                             
/*                                                                   */                                        
                                             
/* Updates:                                                          */                                        
                                             
/*   Date         Author            Purpose                                    */                              
                                                       
/*  27/Nov/2007    Sonia Dhamija    Created                                    */                              
/* 4th April 2008 Sonia Dhamija  Altered (as per DataModel Changes*/                 
/* 26th May 2008 Sonia Altered(To retrive Script History based on scriptId also*/   
/* 25 Nov 2008 Loveena Altered(To display Reprint Reason in Script History)*/  
/* 12 Feb 2009 Loveena Altered(To display Locations in Script History in Order Details Page)*/   
/*********************************************************************/                                        
                                        
                                                           
---To Pull Client Medications Scripts  Data                              
Select CMSA.ClientMedicationScriptId,PharmacyName,CMSA.CreatedDate as              
ScriptCreationDate,CMS.LocationId as LocationId,Locations.LocationName,GlobalCodes.CodeName as Reason,                          
case                           
when CMSA.Method is null then ''                           
when CMSA.Method='F' then 'Faxed'                          
when CMSA.Method='P' then 'Printed'       
when CMSA.Method='C' then 'Chart Copy'                         
else ''                          
end                           
as DeliveryMethod,            
case                           
when CMS.OrderingMethod is null then ''                          
when CMS.OrderingMethod='F' then 'Faxed'                          
when CMS.OrderingMethod='P' then 'Printed'  
                    
else ''                          
end                           
as OrderingMethod,            
            
CMSA.CreatedBy      
--,CMSD.ClientMedicationScriptDrugId                         
From ClientMedicationScripts CMS                        
JOIN ClientMedicationScriptActivities CMSA on              
(CMSA.ClientMedicationScriptId=CMS.ClientMedicationScriptId and              
(Isnull(CMSA.RecordDeleted,'N')<>'Y'))         
        
                         
JOIN ClientMedicationScriptDrugs CMSD on              
(CMSD.ClientMedicationScriptId=CMS.ClientMedicationScriptId and              
(Isnull(CMSD.RecordDeleted,'N')<>'Y'))  
  
--Following Join Added By Loveena in Ref to Task#83 to display Reprint Reason in Script History  
Left outer JOIN GlobalCodes  on              
(GlobalCodes.GlobalCodeID=CMSA.Reason and              
(Isnull(GlobalCodes.RecordDeleted,'N')<>'Y'))              
  
--Following Join Added by Loveena in Ref to Task#83 to display Location in Script History.  
Inner Join Locations on  
(Locations.LocationId= CMS.LocationId and              
(Isnull(Locations.RecordDeleted,'N')<>'Y'))  
                
left outer JOIN Pharmacies P ON (CMSA.PharmacyId=P.PharmacyId and              
(Isnull(P.RecordDeleted,'N')<>'Y') and (Isnull(P.Active,'N')='Y'))                          
Where CMS.clientid=@ClientId and      
--Follwoing condition added by sonia    
CMS.ClientMedicationScriptId=@ClientMedicationScriptId   and          
--Condition added by sonia    
(Isnull(CMS.RecordDeleted,'N')<> 'Y')          
and         
Exists (Select ClientMedicationInstructionId         
from ClientMedicationInstructions CMI         
where CMI.ClientMedicationInstructionId=CMSD.ClientMedicationInstructionId         
and ClientMedicationId=@ClientMedicationId)        
group by CMSA.ClientMedicationScriptId,PharmacyName,             
CMSA.CreatedDate,CMS.LocationId,CMSA.Method,CMS.OrderingMethod,CMSA.CreatedBy,CMSA.ClientMedicationScriptActivityId,GlobalCodes.CodeName,Locations.LocationName      
                    
order by CMSA.ClientMedicationScriptActivityId desc                    
                               
                             
IF (@@error!=0)                                                                        
    BEGIN                                                                        
        RAISERROR  20002 'ssp_SCGetClientMedicationScriptHistory : An error  occured'                        
                                                             
  RETURN(1)       
                        
END   
  
  

