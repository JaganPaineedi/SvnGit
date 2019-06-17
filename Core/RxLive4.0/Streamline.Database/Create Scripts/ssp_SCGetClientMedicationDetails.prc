  
Create PROCEDURE [dbo].[ssp_SCGetClientMedicationDetails]                                                                             
(                                                                                  
 @ClientId bigint                                                                                  
)                                                                                  
as                                                                                  
/**********************************************************************/                                                                                      
/* Stored Procedure: dbo.ssp_SCGetClientMedicationDetails    */                                                                                     
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC     */                                                                                      
/* Creation Date:    09/04/2007                              */                                                                                
/*                                                           */                                                                                
/* Purpose:Used to get the medication details for the client */                                                                                     
/*                                                           */                                                                                
/* Input Parameters: @ClientId         */                                                                                
/*                                                           */                                                                                
/* Output Parameters:   None         */                                                                                
/*                                                           */                                                                                
/* Return:  0=success, otherwise an error number    */                                                                                
/*                                                           */                                                                                 
/* Called By: ssp_SCGetClientMedicationDetails() in ClientMedications  */                                                                                
/*                                                           */                                                                                 
/* Calls:                                                    */                                                                                
/*                                                           */                                                                                 
/* Data Modifications:                                       */                                                                                
/*                                                           */                                                                                 
/* Updates:  Edited By Rohit Verma on  09/07/2007            */                                                                                             
/*    Date        Author       Purpose                       */                                                                                
/* 09/04/2007   Rohit Verma    Created                       */                               
/* 27/02/2008   Sonia   To get discontinued medications    */                                 
/* 4thApril2008 Sonia  Modified (To accomodate data Model Changes of 2377)*/                               
/* 11thApril2007 Sonia Modified (To accomodate changes as per Task #1 Med Mgt -Support*/                          
/* 16thApril2008 Sonia (To accomodate changes related to retrieval of OrderStatus and OrderStatusDate*/       
/* Changes as specified in 2377 SC-Support  i.e Logic of retrieval of StartDate,EndDate,OrderStatus and OrderStatusDate has been changed*/                        
/* Reference Task #38 Procedure altered to Display MedicationStartDate as ClientMedications.MedicationStartDate in case of refill and Min(ScriptDrugs.StartDate) in case of Change Order*/                  
/* 10/06/2008   Sonia   To Display Min(ScriptDrug.StartDate) in View History for refill case also*/              
/* Reference Task Reference Task 1.5.3 - View Medication History: Start and End dates displaying wrong value  */            
/* Reference Task #67 1.6.1 - Special Instructions Changes*/                         
/* Changes made to retrive SpecialInstructions value from ClientMedicationScriptDrugs*/      
/* 16/01/2009   Loveena   To OrderDate in View History*/
/* 10/02/2009   Loveena   Ref to Task#2387 View History Sort Order*/                          
/**********************************************************************/                                                                               
                                                                                    
                                                                                  
BEGIN                        
                      
----Retrive StartDate and EndDate from ClientMedicationScriptDrugs                      
  create table #temp(MedicationStartDate datetime,MedicationEndDate datetime,clientmedicationid int,ScriptEventType char(1),ScriptId int,SpecialInstructions varchar(1000),OrderDate datetime)                      
insert into #temp                      
select                       
--Following changes by sonia              
--Reference Task 1.5.3 - View Medication History: Start and End dates displaying wrong value              
case CMS.ScriptEventType                  
when 'R' then CM.MedicationStartDate                 
else Min(CMSD.StartDate)                  
end  as MedicationStartDate,                
--Min(CMSD.StartDate) as MedicationStartDate,                          
--changes end over here                  
Max(CMSD.EndDate) as MedicationEndDate,                      
cm.clientmedicationid,                      
CMS.ScriptEventType  as  ScriptEventType,CMS.ClientMedicationScriptId  as ScriptId,        
CMSD.SpecialInstructions as SpecialInstructions,  
CMS.OrderDate as OrderDate  
                    
FROM ClientMedications CM                                                                                
join ClientMedicationInstructions CMI                      
on CMI.ClientMedicationId=CM.ClientMedicationId and  IsNull(CMI.RecordDeleted,'N')='N'                             
JOIN ClientMedicationScriptDrugs CMSD                       
on CMI.ClientMedicationInstructionId=CMSD.ClientMedicationInstructionId and IsNull(CMSD.RecordDeleted,'N')='N'                            
join ClientMedicationScripts CMS on CMS.ClientMedicationScriptId=CMSD.ClientMedicationScriptId and IsNull(CMS.RecordDeleted,'N')='N'                          
WHERE CM.ClientId = @ClientId and  IsNull(CM.RecordDeleted,'N')='N' and IsNull(CM.Ordered,'N')='Y'                        
                                        
group by cm.clientmedicationid,CMS.ScriptEventType,CMS.ClientMedicationScriptId,CM.MedicationStartDate,CMSD.SpecialInstructions,CMS.OrderDate  
order by cm.clientmedicationid                      
                      
                    
                                                                                  
---------------------- Client Medications ----------------------                         
                                                         
                              
--Retreive results of Ordered Medications                                                                            
Select distinct                           
CM.ClientMedicationId, CM.ClientId, CM.Ordered,CM.MedicationNameId,                           
CM.DrugPurpose, CM.DSMCode, CM.DSMNumber, CM.NewDiagnosis,                           
CM.PrescriberId, CM.PrescriberName, CM.ExternalPrescriberName,                           
--<SONIA> Changes made to retrive SpecialInstructions value from ClientMedicationScriptDrugs      
T.SpecialInstructions,        
--CM.SpecialInstructions,        
--<SONIA>      
        
 CM.DAW, CM.Discontinued, CM.DiscontinuedReason, CM.DiscontinueDate,                           
CM.RowIdentifier, CM.CreatedBy, CM.CreatedDate, CM.ModifiedBy, CM.ModifiedDate, CM.RecordDeleted, CM.DeletedDate, CM.DeletedBy,                           
MDN.MedicationName,                           
CMS.OrderingPrescriberName As PrescribedByName,                          
--CMSD.StartDate as MedicationStartDate,                          
--CMSD.EndDate as MedicationEndDate,                                                                     
T.MedicationStartDate as MedicationStartDate,                      
T.MedicationEndDate as MedicationEndDate,                      
                      
isnull(CM.DSMCode,'0')+ '_' + isnull(cast(CM.DSMNumber as varchar),'0') as DxId ,MDN.MedicationName  as MedicationName,                            
case CM.Discontinued                           
when 'Y' then   'Discontinued'                   
else                           
  Case CMS.ScriptEventType                          
  When 'N' then 'New'                          
  When 'C' then 'Changed'                          
  When 'R' then 'Re-Ordered'                           
  end                         
                         
end                          
                          
as OrderStatus,                          
case CM.Discontinued                           
when 'Y' then CM.DiscontinueDate                          
Else CMS.ScriptCreationDate                          
end as OrderStatusDate,CMS.ClientMedicationScriptId as MedicationScriptId,                          
  
T.OrderDate as OrderDate  
                                       
FROM ClientMedications CM                                                                                
JOIN MDMedicationNames MDN ON ( MDN.MedicationNameId =CM.MedicationNameId AND IsNull(MDN.RecordDeleted,'N')='N')                                                                               
join ClientMedicationInstructions CMI on CMI.ClientMedicationId=CM.ClientMedicationId and  IsNull(CMI.RecordDeleted,'N')='N'                 
JOIN ClientMedicationScriptDrugs CMSD on CMI.ClientMedicationInstructionId=CMSD.ClientMedicationInstructionId and IsNull(CMSD.RecordDeleted,'N')='N'                             
join ClientMedicationScripts CMS on CMS.ClientMedicationScriptId=CMSD.ClientMedicationScriptId  and   IsNull(CMS.RecordDeleted,'N')='N'                      
JOIN #temp T on T.Clientmedicationid=CM.Clientmedicationid and T.ScriptEventType=CMS.ScriptEventType and CMS.ClientMedicationScriptId=T.ScriptId                    
                          
WHERE CM.ClientId = @ClientId and  IsNull(CM.RecordDeleted,'N')='N' and IsNull(CM.Ordered,'N')='Y'                                           
--and CMSD.StartDate                      
                                  
                          
union                          
                          
--Retreive results of Non Order Medications                          
Select distinct                           
CM.ClientMedicationId, CM.ClientId, CM.Ordered,CM.MedicationNameId,                           
CM.DrugPurpose, CM.DSMCode, CM.DSMNumber, CM.NewDiagnosis,                           
CM.PrescriberId, CM.PrescriberName, CM.ExternalPrescriberName,                           
CM.SpecialInstructions, CM.DAW, CM.Discontinued, CM.DiscontinuedReason, CM.DiscontinueDate,                           
CM.RowIdentifier, CM.CreatedBy, CM.CreatedDate, CM.ModifiedBy, CM.ModifiedDate, CM.RecordDeleted, CM.DeletedDate, CM.DeletedBy,                           
MDN.MedicationName,                           
IsNull(CM.PrescriberName, CM.ExternalPrescriberName) As PrescribedByName,                          
CM.MedicationStartDate,                          
CM.MedicationEndDate,                            
                                                                    
isnull(CM.DSMCode,'0')+ '_' + isnull(cast(CM.DSMNumber as varchar),'0') as DxId ,MDN.MedicationName  as MedicationName,                            
case CM.Discontinued                           
when 'Y' then 'Discontinued'              
else 'New'                           
end                          
                          
as OrderStatus,                          
case CM.Discontinued                           
when 'Y' then CM.DiscontinueDate                          
Else CM.CreatedDate                          
end as OrderStatusDate,-1 as MedicationScriptId,  
  
NULL as OrderDate                         
                                       
FROM ClientMedications CM                                                                                
JOIN MDMedicationNames MDN ON ( MDN.MedicationNameId =CM.MedicationNameId AND IsNull(MDN.RecordDeleted,'N')='N')                                                                               
left outer join ClientMedicationInstructions CMI on CMI.ClientMedicationId=CM.ClientMedicationId and  IsNull(CMI.RecordDeleted,'N')='N'                       WHERE CM.ClientId = @ClientId and  IsNull(CM.RecordDeleted,'N')='N' and     
IsNull(CM.Ordered,'N')='N' 
--Added by Loveena in Ref to Task#2387 View History Sort by Order Date.
Order by OrderDate                                          
                                 
                          
                                                                                 
----------------- End of Client Medications --------------------                                                                                  
                                          
---------------------- Client Medication Instructions ----------------------                                         
-- Getting the Instructions                                                                                 
--(MDMedications.Strength + MDMedications.StrengthUnitOfMeasure + , +                                                                  
--MDDosageForms.DosageFormAbbreviation + , +                                                                                 
--MDRoutes.RouteAbbreviation) + space + ClientMedicationInstructions.Quantity + space + ClientMedicationInstructions.Unit +  --space + ClientMedicationInstructions.Schedule                                                                                 
--You can get to MDMedications using MedicationId from ClientMedicationInstructions.                                                                                 
--To get to MDDosageForms join MDMedications to MDRouteDosageFormMedications to MDDosageForms                                                                                 
--To get to MDRoutes join MDMedications to MDRoutes                                                                            
                                                                   
Select CMI.*,                                              
(IsNull(MD.StrengthDescription,'') + ' ' + isnull(cast(CMI.Quantity as varchar),'') + ' ' + IsNull(GC.CodeName,'') + ' '+ IsNull(GC1.CodeName,'')) as Instruction,MDM.MedicationName as 'MedicationName',                                                      
 
     
      
       
          
             
             
                
                  
                     
                      
case CM.Discontinued                           
when 'Y' then   'Discontinued'                       
else                           
    
  Case ISNULL(CMS.ScriptEventType,'N')                          
  When 'N' then 'New'                          
  When 'C' then 'Changed'                          
  When 'R' then 'Re-Ordered'                           
  end                          
                         
end                          
                          
as MedicationOrderStatus,ISNULL(CMS.ClientMedicationScriptId,-1) as MedicationScriptId,    
convert(varchar,CMSD.StartDate,101) as StartDate,    
convert(varchar,CMSD.EndDate,101) as EndDate                      
FROM ClientMedicationInstructions CMI                              
Join ClientMedications CM on (CMI.clientmedicationId=CM.clientMedicationid )                                                                         
LEFT JOIN GlobalCodes GC on (GC.GlobalCodeID = CMI.Unit)                                   
LEFT JOIN GlobalCodes GC1 on (GC1.GlobalCodeId = CMI.Schedule)                                               
Join MDMedicationNames MDM on (CM.MedicationNameId=MDM.MedicationNameId and IsNull(MDM.RecordDeleted,'N')='N')                                                                               
Join MDMedications MD on (MD.MedicationID = CMI.StrengthId and  IsNull(MD.RecordDeleted,'N')='N')                                                                       
left join ClientMedicationScriptDrugs CMSD on CMI.ClientMedicationInstructionId=CMSD.ClientMedicationInstructionId and IsNull(CMSD.RecordDeleted,'N')='N'                             
left join ClientMedicationScripts CMS on CMS.ClientMedicationScriptId=CMSD.ClientMedicationScriptId and IsNull(CMS.RecordDeleted,'N')='N'                             
--Join MDMedicationNames MDM1 on (MDM1.MedicationNameId = MD.MedicationNameId)                                                                    
WHERE CM.ClientId = @ClientId and IsNull(CMI.RecordDeleted,'N')='N'                                          
                        
/* this condition commented by Sonia as Discontinued Medications also need to be displayed on View History pop up ref. TAsk #636    */                        
--and IsNull(CM.Discontinued,'N')<>'Y'                                                       
                                                       
                                                          
ORDER BY  CM.MedicationStartDate, CM.MedicationEndDate  
  
  
                                                                                          
drop table #temp                      
                                
----------------- End of Client Medication Instructions --------------------                                                                                
                                                                                  
IF (@@error!=0)                                                 
 BEGIN                                                                                    
  RAISERROR  20002 'Client Medication Details: An Error Occured '                                              
        RETURN(1)                                                                                    
    END                                                                                    
    RETURN(0)                                                               
END   