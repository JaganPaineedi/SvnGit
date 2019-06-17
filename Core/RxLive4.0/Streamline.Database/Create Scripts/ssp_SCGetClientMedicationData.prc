USE [MedicationDev8.30]
GO
/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientMedicationData]    Script Date: 03/25/2009 16:27:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
ALTER procedure [dbo].[ssp_SCGetClientMedicationData] 
(                                                                                          
 @ClientId int                                                                                             
)                                                                                          
as                                                                                          
/*********************************************************************/                                                                                                  
/* Stored Procedure: dbo.[ssp_SCGetClientMedicationData]                */                                                                                                  
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                                                                                                  
/* Creation Date:    11/Sep/07                                         */                                                                                                 
/*                                                                   */                                                                                                  
/* Purpose:  To retrieve MedicationData   */                                                                                                  
/*                                                                   */                                                                                                
/* Input Parameters: none        @ClientId */                                                                                                
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
/*   Date     Author       Purpose                                */                                                                                                  
/*  11/Sep/07    Rishu    Created      */     
/*  27/Feb/07 Sonia Modified toget interactions of Non order medications*/         
/*  11th April Sonia Modified          
(Following changes implemented)            
--CM.OrderStatus,CM.OrderStatusDate,CM.OrderDate removed from Selection list              
-- Condition removed CM.OrderStatus = 'A'  removed                    
--In ClientMedicationInstructions Following removed from selection list            
--mincmi.StartDate, cmi.Days, cmi.Pharmacy, cmi.Sample, cmi.Stock, cmi.Refills,cmi.EndDate, removed                                                                                  
--Condtion removed  cm.OrderStatus = 'A'            
--In ClientMedicationInteractions            
--Condtion removed  cm.OrderStatus = 'A'            
--Data retrieval from ClientMedicationScriptDrugs added            
--In ClientMedicationInteractionDetails            
--Condition removed cm.OrderStatus = 'A'      */           
/*  26/May/08 Sonia Modified  reference Task #39 MM#1.5.1      
--Logic of Initialization changed as per New requirement of Task #39 MM 1.5.1*/      
/*28/May/08 Sonia Modified to replace the NULL DrugCategory with 0*/      
/*Reference Task #47 MM1.5*/    
/*Modified by Chandan 19th Nov 2008 for getting MedicationInteraction Name in the Interaction table*/    
/*Task #82 - MM -1.6.5          */       
/*Modified by Chandan 15th Dec 2008 for getting StartDate and End Date from Drugs in Instruction table*/    
/*Task #74 - MM -1.7          */     
/*********************************************************************/                                                   
begin                                                                          
                 
                            
select distinct                        
CM.ClientMedicationId, CM.ClientId, CM.Ordered,                         
--CM.OrderDate, removed                        
CM.MedicationNameId, CM.DrugPurpose, CM.DSMCode, CM.DSMNumber,                             
CM.NewDiagnosis, CM.PrescriberId, CM.PrescriberName, CM.ExternalPrescriberName, CM.SpecialInstructions, CM.DAW, CM.Discontinued,                             
CM.DiscontinuedReason, CM.DiscontinueDate, CM.RowIdentifier, CM.CreatedBy, CM.CreatedDate, CM.ModifiedBy, CM.ModifiedDate, CM.RecordDeleted,                             
CM.DeletedDate,CM.DeletedBy,                        
CM.MedicationStartDate,                        
CM.MedicationEndDate,                        
--CM.OrderStatus, CM.OrderStatusDate,                            
rtrim(ltrim(isnull(DSMCode,'0')))+ '_' + rtrim(ltrim(isnull(cast(DSMNumber as varchar),'0'))) as DxId ,MDN.MedicationName  as MedicationName                    
--Changes by sonia    
--*Reference Task #47 MM1.5 as in some cases DEACode is not found for some medications    
--,MDDrugs.DEACODE as DrugCategory,CM.DEACode,--commented by sonia    
,ISNULL(MDDrugs.DEACODE,'0') as DrugCategory,CM.DEACode,--added by sonia              
Case when CM.Ordered = 'Y' then 0 else 1 end,    
CM.TitrationType, --Added by Chandan
CM.DateTerminated,
CAST(A.ClientMedicationScriptId as Varchar) as MedicationScriptId  -- Added by Ankesh Bharti in ref to task # 2409                  
from ClientMedications CM                            
join MDMedicationNames MDN on CM.MedicationNameId=MDN.MedicationNameId                     
left outer JOIN  ClientMedicationInstructions ON ClientMedicationInstructions.ClientMedicationId = CM.ClientMedicationId and isnull(ClientMedicationInstructions.Active,'Y') = 'Y' and isnull(ClientMedicationInstructions.RecordDeleted, 'N') <> 'Y'
left outer JOIN  MDMedications on MDMedications.MedicationId = ClientMedicationInstructions.StrengthId AND ISNULL(dbo.ClientMedicationInstructions.RecordDeleted, 'N') <> 'Y' and ISNULL(dbo.MDMedications.RecordDeleted, 'N') <> 'Y'              
left outer JOIN  MDDrugs ON dbo.MDMedications.ClinicalFormulationId = MDDrugs.ClinicalFormulationId  AND ISNULL(dbo.MDDrugs.RecordDeleted, 'N') <> 'Y'              
left outer join(Select ClientMedicationInstructionId,MAX(ClientMedicationScriptId) as ClientMedicationScriptId from ClientMedicationScriptDrugs 
group by ClientMedicationInstructionId) A on A.ClientMedicationInstructionId = ClientMedicationInstructions.ClientMedicationInstructionId                           
where CM.ClientId=@ClientId                             
--and CM.OrderStatus = 'A' column removed 
AND isnull(CM.discontinued,'N') <> 'Y'                             
and IsNull(CM.RecordDeleted,'N')<>'Y'                                                     
and IsNull(MDN.RecordDeleted,'N')<>'Y'                            
order by Case when CM.Ordered = 'Y' then 0 else 1 end                
  
  
--******** Get Data From ClientMedicationInstructions ******* --  
  
select cmi.ClientMedicationInstructionId,                         
cmi.ClientMedicationId,                    
cmi.StrengthId,                         
cmi.Quantity,                             
cmi.Unit,  
cmi.Schedule,  
cmi.Active, -- Field added by Ankesh Bharti                          
--mincmi.StartDate, removed                        
--cmi.Days, cmi.Pharmacy, cmi.Sample, cmi.Stock, cmi.Refills, removed                            
--cmi.EndDate, removed                        
cmi.RowIdentifier,                        
cmi.CreatedBy,                         
cmi.CreatedDate,                         
cmi.ModifiedBy,                      
cmi.ModifiedDate,                             
cmi.RecordDeleted,  
cmi.DeletedDate,  
cmi.DeletedBy,  
(MD.StrengthDescription + ' ' + Convert(varchar,CMI.Quantity) + ' ' + Convert(varchar,GC.CodeName) + ' '+ Convert(varchar,GC1.CodeName))  as Instruction,  
MDM.MedicationName  as MedicationName,  
'' as InformationComplete, --'InformationComplete' field added by Ankesh Bharti with ref to Task # 77.         
--convert(varchar,CMSD.StartDate,101) as StartDate,    
--convert(varchar,CMSD.EndDate,101) as EndDate ,   
CMSD.StartDate,  
CMSD.EndDate,   
cmi.TitrationStepNumber, --Added by Chandan    
CMSD.Days,    
CMSD.Pharmacy,    
CMSD.Sample,    
CMSD.Stock,  
MD.StrengthDescription as TitrateSummary,  
'Y' as DBdata,    
CAST(CMSD.ClientMedicationScriptId as varchar) as MedicationScriptId                                                          
FROM ClientMedicationInstructions CMI                            
Join ClientMedications CM on (CMI.clientmedicationId=CM.clientMedicationid)                                    
LEFT JOIN GlobalCodes GC on (GC.GlobalCodeID = CMI.Unit) and isnull(gc.RecordDeleted, 'N') <> 'Y'              
LEFT JOIN GlobalCodes GC1 on (GC1.GlobalCodeId = CMI.Schedule) and isnull(gc1.RecordDeleted, 'N') <> 'Y'       
Join MDMedicationNames MDM on (CM.MedicationNameId=MDM.MedicationNameId)                            
Join MDMedications MD on (MD.MedicationID = CMI.StrengthId)              
join     ClientMedicationScriptDrugs CMSD on   CMI.ClientMedicationInstructionId  =  CMSD.ClientMedicationInstructionId   and isnull(CMSD.RecordDeleted, 'N') <> 'Y'    
where cm.ClientId = @ClientId        
--Ref Task #127    
and CMSD.ModifiedDate=      
(      
Select max(ModifiedDate)       
from ClientMedicationScriptDrugs  CMSD1      
where CMSD1.ClientMedicationInstructionId=CMI.ClientMedicationInstructionId and  isnull(CMSD1.RecordDeleted, 'N') <> 'Y'     
)                     
--removed and cm.OrderStatus = 'A'  
and isnull(cmi.Active,'Y')='Y'                            
AND isnull(cm.discontinued,'N') <> 'Y'                             
and isnull(cmi.RecordDeleted, 'N') <> 'Y'                            
and isnull(cm.RecordDeleted, 'N') <> 'Y'                            
and isnull(mdm.RecordDeleted, 'N') <> 'Y'                            
and isnull(md.RecordDeleted, 'N') <> 'Y'                            
order by MDM.MedicationName asc                          
--********************************************************************** --  
                        
                      
--Get Data From ClientMedicationScriptDrugs                      
select CMSD.*                  
FROM ClientMedicationScriptDrugs CMSD                      
join ClientMedicationInstructions CMI on (CMSD.ClientMedicationInstructionId=CMI.ClientMedicationInstructionId) and isnull(CMSD.RecordDeleted, 'N') <> 'Y' and isnull(CMI.Active, 'Y') <> 'N'                        
Join ClientMedications CM on (CMI.clientmedicationId=CM.clientMedicationid)                                                                       
where cm.ClientId = @ClientId                         
--Logic of Initialization changed as per New requirement of Task #38 MM 1.5.1      
--Old logic Commented      
/*--and CMSD.StartDate in                   
(                  
Select max(startdate)                   
from ClientMedicationScriptDrugs  CMSD1                    
where CMSD1.ClientMedicationInstructionId=CMI.ClientMedicationInstructionId                  
and isnull(CMSD1.RecordDeleted, 'N') <> 'Y' and isnull(CMI.RecordDeleted, 'N') <> 'Y'        
 */      
--New Logic      
and CMSD.ModifiedDate=      
(      
Select max(ModifiedDate)       
from ClientMedicationScriptDrugs  CMSD1      
where CMSD1.ClientMedicationInstructionId=CMI.ClientMedicationInstructionId      
)                     
                      
AND isnull(cm.discontinued,'N') <> 'Y'                             
and isnull(cmi.RecordDeleted, 'N') <> 'Y'             
and isnull(cm.RecordDeleted, 'N') <> 'Y'                            
                        
order by CMSD.ClientMedicationScriptDrugId,CMI.ClientMedicationId DESC                          
                      
                      
                          
----ClientMedicationInteractions                      
                        
--Select distinct cma.ClientMedicationInteractionId, cma.ClientMedicationId1, cma.ClientMedicationId2, cma.InteractionLevel,                            
--cma.PrescriberAcknowledgementRequired, cma.PrescriberAcknowledged, cma.RowIdentifier, cma.CreatedBy, cma.CreatedDate,                            
--cma.ModifiedBy, cma.ModifiedDate, cma.RecordDeleted, cma.DeletedDate, cma.DeletedBy                                                   
--from ClientMedications CM                                                    
--join ClientMedicationInstructions CMI on (CM.ClientMedicationId=CMI.ClientMedicationId and IsNull(CMI.RecordDeleted,'N')<>'Y')                           
--inner join ClientMedicationInteractions CMA on ((clientmedicationId1=CM.ClientMedicationId or clientmedicationid2=CM.ClientMedicationId) and IsNull(CMA.RecordDeleted,'N')<>'Y')                                                    
--where cm.ClientId = @ClientId                            
----and cm.OrderStatus = 'A'                            
--AND isnull(cm.discontinued,'N') <> 'Y'                             
--and isnull(cm.RecordDeleted, 'N') <> 'Y'      
      
--Added By Chandan on 19th Nov 2008    
Select distinct cma.ClientMedicationInteractionId, cma.ClientMedicationId1, cma.ClientMedicationId2, cma.InteractionLevel,                            
cma.PrescriberAcknowledgementRequired, cma.PrescriberAcknowledged, cma.RowIdentifier, cma.CreatedBy, cma.CreatedDate,                            
cma.ModifiedBy, cma.ModifiedDate, cma.RecordDeleted, cma.DeletedDate, cma.DeletedBy,CM1.MedicationNameId ,CM2.MedicationNameId,MDN1.MedicationName as ClientMedicationId1Name,MDN2.MedicationName  as ClientMedicationId2Name                                  
  
  
from ClientMedications CM                                                    
join ClientMedicationInstructions CMI on (CM.ClientMedicationId=CMI.ClientMedicationId and IsNull(CMI.RecordDeleted,'N')<>'Y')                           
inner join ClientMedicationInteractions CMA on ((clientmedicationId1=CM.ClientMedicationId or clientmedicationid2=CM.ClientMedicationId) and IsNull(CMA.RecordDeleted,'N')<>'Y')      
inner join ClientMedications CM1 on (cma.ClientMedicationId1=CM1.ClientMedicationId)    
inner join ClientMedications CM2 on (cma.ClientMedicationId2=CM2.ClientMedicationId)    
inner join MDMedicationNames MDN1 on (MDN1.MedicationNameId=CM1.MedicationNameId)    
inner join MDMedicationNames MDN2 on (MDN2.MedicationNameId=CM2.MedicationNameId)    
where cm.ClientId = @ClientId                            
--and cm.OrderStatus = 'A'                            
AND isnull(cm.discontinued,'N') <> 'Y'                             
and isnull(cm.RecordDeleted, 'N') <> 'Y'                         
                                              
                                                    
Select distinct cmid.ClientMedicationInteractionDetailId, cmid.ClientMedicationInteractionId, cmid.DrugDrugInteractionId,                             
cmid.RowIdentifier, cmid.CreatedBy, cmid.CreatedDate, cmid.ModifiedBy, cmid.ModifiedDate, cmid.RecordDeleted,                             
cmid.DeletedDate, cmid.DeletedBy,               
MDDI.SeverityLevel as InteractionLevel,MDDI.InteractionDescription,MDDI.DrugInteractionMonographId                             
from ClientMedications CM                                                    
join ClientMedicationInstructions CMI on (CM.ClientMedicationId=CMI.ClientMedicationId and IsNull(CMI.RecordDeleted,'N')<>'Y')             
inner join ClientMedicationInteractions CMA on ((clientmedicationId1=CM.ClientMedicationId or clientmedicationid2=CM.ClientMedicationId) and IsNull(CMA.RecordDeleted,'N')<>'Y')      
inner join ClientMedicationInteractionDetails CMID on (CMID.ClientMedicationInteractionId=CMA.ClientMedicationInteractionId and IsNull(CMID.RecordDeleted,'N')<>'Y')                                                    
inner join MDDrugDrugInteractions MDDI on (CMID.DrugDrugInteractionId=MDDI.DrugDrugInteractionId and IsNull(MDDI.RecordDeleted,'N')<>'Y')                                                    
where cm.ClientId = @ClientId                  
--and cm.OrderStatus = 'A'                            
AND isnull(cm.discontinued,'N') <> 'Y'                             
and isnull(cm.RecordDeleted, 'N') <> 'Y'                                                 
order by CMID.ClientMedicationInteractionId                                                    
                                                     
exec ssp_SCGetClientDrugAllergyInteraction @ClientId                                                    
                                                                                      
IF (@@error!=0)                                                                                 
    BEGIN                                                                                                  
        RAISERROR  20002 'ssp_SCGetClientMedicationData : An error  occured'                                                                                                  
                                                                                                     
        RETURN(1)                                                                                                  
                                                            
    END                                                                                                       
                                                                                                
end           
          
          
    
    
    
    
    
    