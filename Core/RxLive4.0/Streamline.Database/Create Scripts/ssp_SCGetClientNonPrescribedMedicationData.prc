CREATE procedure [dbo].[ssp_SCGetClientNonPrescribedMedicationData]                        
                                               
(                                                                    
 @ClientId int,  
 @MedicationIds   varchar(2000)                                                                       
)                                                                    
as                                                                    
/*********************************************************************/                                                          
                     
/* Stored Procedure: dbo.[ssp_SCGetClientNonPrescribedMedicationData]   */                                                       
                        
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                                                          
                     
/* Creation Date:    11/Sep/07                                       */                                                          
                    
/*                                                                   */                                                          
                     
/* Purpose:  To retrieve MedicationData   */                                                                            
/*                                                                   */                                                          
                   
/* Input Parameters: none        @ClientId */                                                                          
/*                                                                   */                                                          
                     
/* Output Parameters:   None           */                                                                            
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
                     
/*   Date       Author       Purpose                                 */                                                          
                     
/*  12/Dec/07    Sonia       Created                                 */                                                          
                     
/*********************************************************************/                                                          
                
begin                                                                    
declare @Strength varchar(250)                                                                
declare @strSql nvarchar(4000)  
  
set @strSql='                                  
select distinct a.*,rtrim(ltrim(isnull(DSMCode,''0'')))+ ''_'' + rtrim(ltrim(isnull(cast(DSMNumber as    
varchar),''0''))) as DxId  ,b.MedicationName  as MedicationName,IsNull(MDD.DEACode,''0'') as DrugCategory                
                                             
    
            
from ClientMedications a  join MDMedicationNames b on a.MedicationNameId=b.MedicationNameId                     
JOIN ClientMedicationInstructions CMI on (CMI.ClientMedicationId=a.ClientMedicationId and    
IsNull(CMI.RecordDeleted,''N'')<>''Y'')                            
JOIN MDMedications MD ON ( MD.MedicationNameId =a.MedicationNameId AND   
IsNull(MD.RecordDeleted,''N'')<>''Y'' AND md.medicationid=CMI.strengthid)                                           
left  JOIN MDDrugs MDD ON ( MDD.ClinicalFormulationId =MD.ClinicalFormulationId AND    
IsNull(MDD.RecordDeleted,''N'')<>''Y'')                                              
                          
where (ClientId=' + convert(varchar,@ClientId) + '  AND isnull(a.discontinued,''N'') <> ''Y'' and    
IsNull(a.RecordDeleted,''N'')<>''Y''                                 
and IsNull(a.RecordDeleted,''N'')<>''Y'') and a.ClientMedicationId in (' + @MedicationIds + ')'                       
    
  
execute sp_executesql @strSql                              
                                                        
set @strSql='select CMI.*,(MD.StrengthDescription + '' '' + Convert(varchar,CMI.Quantity) + '' '' +    
Convert(varchar,GC.CodeName) + '' ''+ Convert(varchar,GC1.CodeName))  as Instruction           FROM    
ClientMedicationInstructions CMI                                            
   
Join ClientMedications CM on (CMI.clientmedicationId=CM.clientMedicationid)                                                 
LEFT JOIN GlobalCodes GC on (GC.GlobalCodeID = CMI.Unit)                                              
LEFT JOIN GlobalCodes GC1 on (GC1.GlobalCodeId = CMI.Schedule)                                              
Join MDMedicationNames MDM on (CM.MedicationNameId=MDM.MedicationNameId)                                                       
Join MDMedications MD on (MD.MedicationID = CMI.StrengthId)                                      
where IsNull(CMI.RecordDeleted,''N'')<>''Y'' and CMI.ClientMedicationID in     
(' + @MedicationIds + ')'     
      
print @strSql  
execute sp_executesql @strSql                              
                                                          
 set @strSql=           
'Select distinct CMA.*                               
from ClientMedications CM                              
join ClientMedicationInstructions CMI on (CM.ClientMedicationId=CMI.ClientMedicationId and    
IsNull(CMI.RecordDeleted,''N'')<>''Y'')                              
inner join ClientMedicationInteractions CMA on ((clientmedicationId1=CM.ClientMedicationId or    
clientmedicationid2=CM.ClientMedicationId) and IsNull(CMA.RecordDeleted,''N'')<>''Y'')                              
where (ClientId=' + convert(varchar,@ClientId) + ' AND isnull(CM.discontinued,''N'') <> ''Y'' and    
IsNull(CM.RecordDeleted,''N'')<>''Y'')                                 
and  (CMI.StartDate<=getdate() and CMI.EndDate>=convert(datetime, convert(varchar,getdate(),101),101))       
and CM.ClientMedicationId in (' + @MedicationIds + ')'               
  
execute sp_executesql @strSql                             
                              
set @strSql='    
Select distinct CMID.*,MDDI.SeverityLevel as InteractionLevel,MDDI.InteractionDescription,MDDI.DrugInteractionMonographId        
                          
from ClientMedications CM                  
join ClientMedicationInstructions CMI on (CM.ClientMedicationId=CMI.ClientMedicationId and    
IsNull(CMI.RecordDeleted,''N'')<>''Y'')                              
inner join ClientMedicationInteractions CMA on ((clientmedicationId1=CM.ClientMedicationId or    
clientmedicationid2=CM.ClientMedicationId) and IsNull(CMA.RecordDeleted,''N'')<>''Y'')                
inner join ClientMedicationInteractionDetails CMID on (CMID.ClientMedicationInteractionId=CMA.ClientMedicationInteractionId    
and IsNull(CMID.RecordDeleted,''N'')<>''Y'')                              
inner join MDDrugDrugInteractions MDDI on (CMID.DrugDrugInteractionId=MDDI.DrugDrugInteractionId and    
IsNull(MDDI.RecordDeleted,''N'')<>''Y'')                              
where (ClientId=' + convert(varchar,@ClientId) + ' AND isnull(CM.discontinued,''N'') <> ''Y'' and    
IsNull(CM.RecordDeleted,''N'')<>''Y'' )                                
and  (CMI.StartDate<=getdate() and CMI.EndDate>=convert(datetime, convert(varchar,getdate(),101),101))                           
        
and CM.ClientMedicationId in (' + @MedicationIds + ')      
order by CMID.ClientMedicationInteractionId '  
  
  
execute sp_executesql @strSql                           
                               
exec ssp_SCGetClientNonPrescribedDrugsAllergyInteraction @ClientId                              
                                                                
IF (@@error!=0)                                                                            
    BEGIN                                                                            
        RAISERROR  20002 '[ssp_SCGetClientNonPrescribedMedicationData] : An error  occured'                            
                                                                               
        RETURN(1)                                                                            
                              
    END                                                                                 
                                                                          
end   