 /****** Object:  StoredProcedure [dbo].[ssp_SCGetClientMedicationForPrescriber]    Script Date: 12/03/2009 15:45:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter PROCEDURE [dbo].[ssp_SCGetClientMedicationForPrescriber] --92,'11/25/2009 8:07:29 PM','11/26/2009 9:40:19 AM'                                                                
(                                                                                                             
 @PrescriberId bigint,              
 @LastReviewTime datetime,              
 @ServerTime datetime                                                                                                            
)                                                                                                            
as                                                                                                            
/**********************************************************************/                                                                                                                
/* Stored Procedure: dbo.ssp_SCGetClientMedicationForPrescriber    */                                                                                                               
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC     */                                                                                                                
/* Creation Date:    03/11/2009                               */                                                                                                          
/*                                                           */                                                                                                          
/* Purpose:Used to get the medication details for the prescriber */                                                                                                               
/*                                                           */                                                                                                          
/* Input Parameters: @PrescribeId,@LastReviewTime,@ServeTime         */                                                                                                          
/*                                                           */                                                                                                          
/* Output Parameters:   None         */                                                                                                          
/*                                                           */                                                                                                          
/* Return:  0=success, otherwise an error number    */                                                                                                          
/*                                                           */                                                                                                           
/* Called By: ssp_SCGetClientMedicationForPrescriber() in ClientMedications  */                                                                                                          
/*                                                           */                                                                                                           
/* Calls:                                                    */                                                                                                          
/*                                                           */                                                                                                           
/* Data Modifications:                                       */                                                                                                          
/*                                                           */                                                                                                           
/* Updates:               */                                                   /*    Date 18-Non-2009       Author : Mohit      Purpose                       */                       
/**********************************************************************/                                                                                                         
                                                                                                              
                                                                                                            
BEGIN                                                  
                                                
--Retrive StartDate and EndDate from ClientMedicationScriptDrugs                                                
  create table #temp(MedicationStartDate datetime,MedicationEndDate datetime,clientmedicationid int,ScriptEventType char(1),ScriptId int,SpecialInstructions varchar(1000),OrderDate datetime)                                                
insert into #temp                                                
select                                                 
                                       
case CMS.ScriptEventType                                            
when 'R' then CM.MedicationStartDate                                           
else Min(CMSD.StartDate)                                            
end  as MedicationStartDate,                                          
                                            
Max(CMSD.EndDate) as MedicationEndDate,                                                
cm.clientmedicationid,                                                
CMS.ScriptEventType  as  ScriptEventType,CMS.ClientMedicationScriptId  as ScriptId,                                  
CMSD.SpecialInstructions as SpecialInstructions,                            
CMS.ScriptCreationDate as OrderDate                          
                                              
FROM ClientMedications CM                                                                                                          
join ClientMedicationInstructions CMI                                                
on CMI.ClientMedicationId=CM.ClientMedicationId and  IsNull(CMI.RecordDeleted,'N')='N'                                                       
JOIN ClientMedicationScriptDrugs CMSD                                                 
on CMI.ClientMedicationInstructionId=CMSD.ClientMedicationInstructionId and IsNull(CMSD.RecordDeleted,'N')='N'                                                      
join ClientMedicationScripts CMS on CMS.ClientMedicationScriptId=CMSD.ClientMedicationScriptId and IsNull(CMS.RecordDeleted,'N')='N'                                           
WHERE IsNull(CM.RecordDeleted,'N')='N' and IsNull(CM.Ordered,'N')='Y'                                                  
                                                                  
group by cm.clientmedicationid,CMS.ScriptEventType,CMS.ClientMedicationScriptId,CM.MedicationStartDate,CMSD.SpecialInstructions,CMS.ScriptCreationDate                            
order by cm.clientmedicationid                                           
                                                
                                              
                                                    
---------------------- Client Medications ----------------------                                                   
                                                       
--Retreive results of Ordered Medications                                                                                                      
Select distinct                                               
CM.ClientMedicationId, CM.ClientId, CM.Ordered,CM.MedicationNameId,                                                     
CM.DrugPurpose, CM.DSMCode, CM.DSMNumber, CM.NewDiagnosis,                                                     
                   
CMs.OrderingPrescriberId as PrescriberId, CMs.OrderingPrescriberName as PrescriberName, CM.ExternalPrescriberName,                                       
             
T.SpecialInstructions,                                  
                                
                                  
 CM.DAW, CM.Discontinued, CM.DiscontinuedReason, CM.DiscontinueDate,                                                     
CM.RowIdentifier, CM.CreatedBy, CM.CreatedDate, CM.ModifiedBy, CM.ModifiedDate, CM.RecordDeleted, CM.DeletedDate, CM.DeletedBy,                                                     
MDN.MedicationName,                                          
CMS.OrderingPrescriberName As PrescribedByName,                                                    
                                                 
T.MedicationStartDate as MedicationStartDate,                                                
T.MedicationEndDate as MedicationEndDate,                                                
                                                
isnull(CM.DSMCode,'0')+ '_' + isnull(cast(CM.DSMNumber as varchar),'0') as DxId ,                                                     
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
T.OrderDate as OrderDate,                        
CM.TitrationType,                      
CM.OffLabel,                        
CM.DiscontinuedReasonCode ,                     
(IsNull(MD.StrengthDescription,'') + ' ' + isnull(cast(CMI.Quantity as varchar),'') + ' ' + IsNull(GC.CodeName,'') + ' '+ IsNull(GC1.CodeName,'')) as Instruction ,          
          
C.LastName  + ', ' + C.FirstName as ClientName,           
CONVERT(VARCHAR(8), C.DOB, 1)  as DOB ,          
GCode.CodeName as disCodeName,        
case CMSA.Method        
when 'F' then 'Faxed'                                                            
when 'P' then 'Printed'        
end        
as Method,        
GCode1.CodeName as Reason,       
S1.LastName + ', ' + S1.FirstName as CreatedBy,      
CMSA.CreatedDate as Date       
FROM ClientMedications CM            
                                                                                                         
JOIN MDMedicationNames MDN ON ( MDN.MedicationNameId =CM.MedicationNameId AND IsNull(MDN.RecordDeleted,'N')='N')                                                                      
join ClientMedicationInstructions CMI on CMI.ClientMedicationId=CM.ClientMedicationId and  IsNull(CMI.RecordDeleted,'N')='N'                                           
JOIN ClientMedicationScriptDrugs CMSD on CMI.ClientMedicationInstructionId=CMSD.ClientMedicationInstructionId and IsNull(CMSD.RecordDeleted,'N')='N'                                                       
join ClientMedicationScripts CMS on CMS.ClientMedicationScriptId=CMSD.ClientMedicationScriptId  and   IsNull(CMS.RecordDeleted,'N')='N'                                                
join ClientMedicationScriptActivities CMSA on CMSA.ClientMedicationScriptId = CMS.ClientMedicationScriptId and IsNull(CMSA.RecordDeleted,'N')='N'          
LEFT JOIN GlobalCodes GC on (GC.GlobalCodeID = CMI.Unit)                                                             
LEFT JOIN GlobalCodes GC1 on (GC1.GlobalCodeId = CMI.Schedule)             
Join MDMedications MD on (MD.MedicationID = CMI.StrengthId and  IsNull(MD.RecordDeleted,'N')='N')            
JOIN #temp T on T.Clientmedicationid=CM.Clientmedicationid and T.ScriptEventType=CMS.ScriptEventType and CMS.ClientMedicationScriptId=T.ScriptId                                   
inner join Staff S on CM.PrescriberId = S.StaffId   and  IsNull(S.RecordDeleted,'N')='N'           
--add by mohit         
inner join Staff S1 on S1.UserCode = CMSA.CreatedBy  and  IsNull(S1.RecordDeleted,'N')='N'        
LEFT JOIN Clients  C on (C.ClientId = CM.ClientId )           
LEFT JOIN GlobalCodes GCode on (GCode.GlobalCodeId = CM.DiscontinuedReasonCode )     
LEFT JOIN GlobalCodes GCode1 on (GCode1.GlobalCodeId = CMSA.Reason )          
WHERE CM.PrescriberId = @PrescriberId and                                    
CMS.CreatedDate > @LastReviewTime and CMS.CreatedDate <= @ServerTime and              
isnull(DiscontinuedReasonCode,0) <> 5512              
and  IsNull(CM.RecordDeleted,'N')='N' and IsNull(CM.Ordered,'N')='Y'                                
                                       
                                                    
--union                                                    
                   
----Retreive results of Non Order Medications                                                    
--Select distinct                                                     
--CM.ClientMedicationId, CM.ClientId, CM.Ordered,CM.MedicationNameId,                                                     
--CM.DrugPurpose, CM.DSMCode, CM.DSMNumber, CM.NewDiagnosis,                                               
--CM.PrescriberId, CM.PrescriberName, CM.ExternalPrescriberName,                                            
--CM.SpecialInstructions,            
-- CM.DAW, CM.Discontinued, CM.DiscontinuedReason, CM.DiscontinueDate,                                                     
--CM.RowIdentifier, CM.CreatedBy, CM.CreatedDate, CM.ModifiedBy, CM.ModifiedDate, CM.RecordDeleted, CM.DeletedDate, CM.DeletedBy,                                                     
--MDN.MedicationName,                                                     
--IsNull(CM.PrescriberName, CM.ExternalPrescriberName) As PrescribedByName,                                                    
--CM.MedicationStartDate,                                                    
--CM.MedicationEndDate,                                                      
                                                                                
--isnull(CM.DSMCode,'0')+ '_' + isnull(cast(CM.DSMNumber as varchar),'0') as DxId ,                                                      
--case CM.Discontinued                                                     
--when 'Y' then 'Discontinued'                                        
--else 'New'                                                     
--end                                                    
                                                    
--as OrderStatus,                                                    
--case CM.Discontinued                                                     
--when 'Y' then CM.DiscontinueDate                                                    
--Else CM.CreatedDate                                                    
--end as OrderStatusDate,-1 as MedicationScriptId,                            
--NULL as OrderDate,                        
--CM.TitrationType,                                                  
--CM.OffLabel,                       
--CM.DiscontinuedReasonCode,            
--(IsNull(MD.StrengthDescription,'') + ' ' + isnull(cast(CMI.Quantity as varchar),'') + ' ' + IsNull(GC.CodeName,'') + ' '+ IsNull(GC1.CodeName,'')) as Instruction,          
          
--C.FirstName  + ', ' + C.LastName as ClientName,          
--CONVERT(VARCHAR(8), C.DOB, 1)  as DOB ,          
--GCode.CodeName as disCodeName ,        
--case CMSA.Method        
--when 'F' then 'Faxed'                                                            
--when 'P' then 'Printed'        
--end        
--as Method,        
--Reason        
----S1.LastName + ', ' + S1.FirstName as CreatedBy                                                                                               
                         
--FROM ClientMedications CM                                                                                                          
--JOIN MDMedicationNames MDN ON ( MDN.MedicationNameId =CM.MedicationNameId AND IsNull(MDN.RecordDeleted,'N')='N')                                                                         
--left outer join ClientMedicationInstructions CMI on CMI.ClientMedicationId=CM.ClientMedicationId and  IsNull(CMI.RecordDeleted,'N')='N'                                     
--JOIN ClientMedicationScriptDrugs CMSD on CMI.ClientMedicationInstructionId=CMSD.ClientMedicationInstructionId and IsNull(CMSD.RecordDeleted,'N')='N'                                                       
--join ClientMedicationScripts CMS on CMS.ClientMedicationScriptId=CMSD.ClientMedicationScriptId  and   IsNull(CMS.RecordDeleted,'N')='N'                                                
--join ClientMedicationScriptActivities CMSA on CMSA.ClientMedicationScriptId = CMS.ClientMedicationScriptId and IsNull(CMSA.RecordDeleted,'N')='N'          
--LEFT JOIN GlobalCodes GC on (GC.GlobalCodeID = CMI.Unit)                                                             
--LEFT JOIN GlobalCodes GC1 on (GC1.GlobalCodeId = CMI.Schedule)             
--Join MDMedications MD on (MD.MedicationID = CMI.StrengthId and  IsNull(MD.RecordDeleted,'N')='N')            
--inner join Staff S on CM.PrescriberId = S.StaffId           
----add by mohit          
----inner join Staff S1 on S1.UserCode = CMSA.CreatedBy         
--LEFT JOIN Clients  C on (C.ClientId = CM.ClientId )            
--LEFT JOIN GlobalCodes  GCode on (GCode.GlobalCodeId = CM.DiscontinuedReasonCode )            
--WHERE IsNull(CM.RecordDeleted,'N')='N' and               
--CM.PrescriberId = @PrescriberId and                                    
--CMS.CreatedDate > @LastReviewTime and CMS.CreatedDate <= @ServerTime and              
--isnull(DiscontinuedReasonCode,0) <> 5512                    
--and                          
--IsNull(CM.Ordered,'N')='N'                           
              
Order by OrderDate                                                                    
                                                                                         
                                                                                                       
                                                                    
      
                                                                                                            
IF (@@error!=0)                                                                           
 BEGIN                                                                                                              
  RAISERROR  20002 'Client Medication Details: An Error Occured '                                                                        
        RETURN(1)                                  
    END                                                                                                              
    RETURN(0)                                                                                         
END 