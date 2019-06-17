ALTER procedure [dbo].[ssp_SCGetClientMedicationOrderDetails]                                  
(                                      
 @ClientMedicationId int  =0,      
 @ClientMedicationScriptId int =-1      --A new Parameter added by Sonia so that order details can be feteched according to ScriptId if its being passed                                
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
/* 26/May/08 Sonia Modified*/    
/* Modified the logic of fetching data from ClientMedicationScriptDrugs*/    
/* As in case ScriptId is being passed OrderDetails should be fetched accordingly*/    
/*Otherwise latest Details from  ClientMedicationScriptDrugs*/     
/* 28/May/08 Sonia Modified*/   
/*Task # 49 MM1.5.2 Non Ordered Medication:Order details are not displaying for some fields. 
Records need not to be fetched from ClientMedicationScriptDrugs in case Medication is a non -ordered Medication*/
/*********************************************************************/                                         
begin                                      
                               
declare @MedicationId int      
declare @ClientMedicationOrdered char(1)              
      
select @ClientMedicationOrdered=ISNULL(Ordered,'N')
from ClientMedications
where Clientmedicationid=@ClientMedicationId

select CM.*,isnull(DSMCode,'0')+ '_' + isnull(cast(DSMNumber as varchar),'0') as DxId,MDN.MedicationName as MedicationName        
from clientmedications CM        
join MDMedicationNames MDN on (CM.MedicationNameId=MDN.MedicationNameId) and ISNULL(MDN.RecordDeleted,'N')='N'          
where clientmedicationid=@ClientMedicationId and ISNULL(CM.RecordDeleted,'N')='N'                                
                                
-----Case of Non-Ordered Medication-------
--If condition added by Sonia
--Ref Task # 49 MM1.5.2 Non Ordered Medication:Order details are not displaying for some fields
--Case of Non Ordered Medication   
if((@ClientMedicationScriptId=-1) and (@ClientMedicationOrdered='N'))      
begin    
--ScriptId also needs to be retrieved                                 
select StrengthDescription,CMI.*,            
CMSD.StartDate,CMSD.Days,CMSD.Pharmacy,CMSD.Sample,CMSD.Stock,CMSD.Refills,CMSD.EndDate,                          
( Convert(varchar,CMI.Quantity) + ' ' + Convert(varchar,GC.CodeName) + ' '+ Convert(varchar,GC1.CodeName))  as Instruction,MN.MedicationName,CMSD.ClientMedicationScriptId                           
from clientmedicationinstructions CMI             
inner Join ClientMedications CM             
on (CMI.clientmedicationid=CM.clientmedicationid and ISNULL(CMI.RecordDeleted,'N')='N')                          
left join ClientMedicationScriptDrugs CMSD on (CMSD.ClientMedicationInstructionId=CMI.ClientMedicationInstructionId and ISNULL(CMSD.RecordDeleted,'N')='N')            
JOIN MDMedications M on (M.MedicationNameId=CM.MedicationNameId and M.MedicationId=CMI.StrengthId and ISNULL(M.RecordDeleted,'N')='N')                            
JOIN MDMedicationNames MN on(MN.MedicationNameId=M.MedicationNameId and ISNULL(MN.RecordDeleted,'N')='N' )                         
LEFT JOIN GlobalCodes GC on (GC.GlobalCodeID = CMI.Unit)                                            
LEFT JOIN GlobalCodes GC1 on (GC1.GlobalCodeId = CMI.Schedule)                                             
where  CM.clientmedicationid=@ClientMedicationId and ISNULL(CM.RecordDeleted,'N')='N'             
and ISNULL(CMI.RecordDeleted,'N')='N'          
end --Case of Non Ordered Medication   

--Case of Ordered Medication and ScriptId as -1  needs to fetch latest script Drugs records ends over here  
else if((@ClientMedicationScriptId=-1) and (@ClientMedicationOrdered='Y'))      
begin    
--ScriptId also needs to be retrieved                                 
select StrengthDescription,CMI.*,            
CMSD.StartDate,CMSD.Days,CMSD.Pharmacy,CMSD.Sample,CMSD.Stock,CMSD.Refills,CMSD.EndDate,                          
( Convert(varchar,CMI.Quantity) + ' ' + Convert(varchar,GC.CodeName) + ' '+ Convert(varchar,GC1.CodeName))  as Instruction,MN.MedicationName,CMSD.ClientMedicationScriptId                           
from clientmedicationinstructions CMI             
inner Join ClientMedications CM             
on (CMI.clientmedicationid=CM.clientmedicationid and ISNULL(CMI.RecordDeleted,'N')='N')                          
left join ClientMedicationScriptDrugs CMSD on (CMSD.ClientMedicationInstructionId=CMI.ClientMedicationInstructionId and ISNULL(CMSD.RecordDeleted,'N')='N')            
JOIN MDMedications M on (M.MedicationNameId=CM.MedicationNameId and M.MedicationId=CMI.StrengthId and ISNULL(M.RecordDeleted,'N')='N')                            
JOIN MDMedicationNames MN on(MN.MedicationNameId=M.MedicationNameId and ISNULL(MN.RecordDeleted,'N')='N' )                         
LEFT JOIN GlobalCodes GC on (GC.GlobalCodeID = CMI.Unit)                                            
LEFT JOIN GlobalCodes GC1 on (GC1.GlobalCodeId = CMI.Schedule)                                             
where  CM.clientmedicationid=@ClientMedicationId and ISNULL(CM.RecordDeleted,'N')='N'             
--New Logic of feteching Data  as per Task #38 and Task #39
and CMSD.ModifiedDate=
(
Select max(ModifiedDate) 
from ClientMedicationScriptDrugs  CMSD1
where CMSD1.ClientMedicationInstructionId=CMI.ClientMedicationInstructionId
)       
and ISNULL(CMI.RecordDeleted,'N')='N'          
      
end--Case of Ordered Medication and ScriptId as -1  needs to fetch latest script Drugs records ends over here  

else --In case its a Ordered Medication Case
begin     
--ScriptId also needs to be retrieved      
select StrengthDescription,CMI.*,            
CMSD.StartDate,CMSD.Days,CMSD.Pharmacy,CMSD.Sample,CMSD.Stock,CMSD.Refills,CMSD.EndDate,                          
( Convert(varchar,CMI.Quantity) + ' ' + Convert(varchar,GC.CodeName) + ' '+ Convert(varchar,GC1.CodeName))  as Instruction,MN.MedicationName,CMSD.ClientMedicationScriptId                           
from clientmedicationinstructions CMI             
inner Join ClientMedications CM             
on (CMI.clientmedicationid=CM.clientmedicationid and ISNULL(CMI.RecordDeleted,'N')='N')                          
join ClientMedicationScriptDrugs CMSD on (CMSD.ClientMedicationInstructionId=CMI.ClientMedicationInstructionId and ISNULL(CMSD.RecordDeleted,'N')='N')            
JOIN MDMedications M on (M.MedicationNameId=CM.MedicationNameId and M.MedicationId=CMI.StrengthId and ISNULL(M.RecordDeleted,'N')='N')                            
JOIN MDMedicationNames MN on(MN.MedicationNameId=M.MedicationNameId and ISNULL(MN.RecordDeleted,'N')='N' )                         
LEFT JOIN GlobalCodes GC on (GC.GlobalCodeID = CMI.Unit)                                            
LEFT JOIN GlobalCodes GC1 on (GC1.GlobalCodeId = CMI.Schedule)                                             
where  CM.clientmedicationid=@ClientMedicationId and ISNULL(CM.RecordDeleted,'N')='N'             
and CMSD.ClientMedicationScriptId=@ClientMedicationScriptId      
and ISNULL(CMI.RecordDeleted,'N')='N'          
      
      
end      
      
      
                  
              
Select TOP 1 @MedicationId=strengthId               
from ClientMedicationInstructions              
where ClientMedicationId=@ClientMedicationId              
               
exec ssp_SCClientMedicationC2C5Drugs @MedicationId                  
                                     
                                  
                  
IF (@@error!=0)                                              
    BEGIN                                        
        RAISERROR  20002 'ssp_SCGetMedicationOrderDetails : An error  occured'                                              
                     
        RETURN(1)                                              
        
    END                                       
                                            
end 
