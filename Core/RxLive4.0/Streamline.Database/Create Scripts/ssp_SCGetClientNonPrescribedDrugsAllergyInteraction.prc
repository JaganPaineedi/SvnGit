CREATE procedure [dbo].[ssp_SCGetClientNonPrescribedDrugsAllergyInteraction]                                                
(                                                
 @ClientId int                                             
)                                                
as                 
Begin Try                                           
/*********************************************************************/                                                        
/* Stored Procedure: dbo.[ssp_SCGetClientNonPrescribedDrugsAllergyInteraction]                */                                                        
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                                                        
/* Creation Date:    6/Dec/07                                      */                                                       
/*                                                                   */                                                        
/* Purpose:  To retrieve Drug Allergy interaction details for Non Prescribed medications */                                                        
/*                                                                   */                                                      
/* Input Parameters: none        @MedicationNameIds */                                                      
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
/*  6/Dec/07    Sonia    Created                                    */                                                        
/*********************************************************************/                                                   
            
declare @query nvarchar(4000)            
       
/* Case Of client is allergetic to a Medication Name*/          
       
Select distinct MDA.AllergenConceptId,MD.MedicationNameId,MDA.ConceptDescription         
from MDMedications MD          
inner join MDAllergenConcepts MDA on (MDA.MedicationNameId=MD.MedicationNameId and IsNull(MD.RecordDeleted,'N')<>'Y')         
JOIN ClientAllergies CA on (CA.AllergenConceptId=MDA.AllergenConceptId and IsNull(CA.RecordDeleted,'N')<>'Y')          
where CA.ClientId=@ClientId   and           
MD.MedicationNameId in (       
Select distinct CM.MedicationNameId       
from ClientMedications CM      
join ClientMedicationInstructions CMI on (CM.ClientMedicationId=CMI.ClientMedicationId and IsNull(CMI.RecordDeleted,'N')<>'Y')      
where     
CM.ClientMedicationId not in (Select ClientMedicationId from ClientMedicationScriptDrugs )    
and (CM.ClientId=@ClientId  AND isnull(CM.discontinued,'N') <> 'Y' and IsNull(CM.RecordDeleted,'N')<>'Y')         
and  (CMI.StartDate<=getdate() and CMI.EndDate>=convert(datetime, convert(varchar,getdate(),101),101))) and IsNull(MDA.RecordDeleted,'N')<>'Y'           
    
          
union     
          
/* Case Of client is allergetic to a Ingredient*/          
          
Select distinct MDA.AllergenConceptId,MD.MedicationNameId,MDA.ConceptDescription       
from MDMedications MD          
inner join MDClinicalFormulations MDC on (MD.ClinicalFormulationId=MDC.ClinicalFormulationId  and IsNull(MDC.RecordDeleted,'N')<>'Y')        
inner join MDIngredientListIngredientCodes MIC on (MIC.IngredientListId=MDC.IngredientListId  and IsNull(MIC.RecordDeleted,'N')<>'Y')        
inner join MDAllergenConcepts MDA on (MDA.HierarchicalIngredientCodeId=MIC.HierarchicalIngredientCodeId )        
JOIN ClientAllergies CA on (CA.AllergenConceptId=MDA.AllergenConceptId and IsNull(CA.RecordDeleted,'N')<>'Y')          
where CA.ClientId=@ClientId   and           
MD.MedicationNameId in (       
Select distinct CM.MedicationNameId       
from ClientMedications CM      
join ClientMedicationInstructions CMI on (CM.ClientMedicationId=CMI.ClientMedicationId and IsNull(CMI.RecordDeleted,'N')<>'Y')      
where     
CM.ClientMedicationId not in (Select ClientMedicationId from ClientMedicationScriptDrugs )    
and (CM.ClientId=@ClientId  AND isnull(CM.discontinued,'N') <> 'Y' and IsNull(CM.RecordDeleted,'N')<>'Y')         
and  (CMI.StartDate<=getdate() and CMI.EndDate>=convert(datetime, convert(varchar,getdate(),101),101))) and IsNull(MDA.RecordDeleted,'N')<>'Y'           
    
          
          
union     
          
/* Case Of client is allergetic to a Allergen group*/          
          
Select distinct MDA.AllergenConceptId,MD.MedicationNameId,MDA.ConceptDescription          
from MDMedications MD          
inner join MDClinicalFormulations MDC on (MD.ClinicalFormulationId=MDC.ClinicalFormulationId and IsNull(MDC.RecordDeleted,'N')<>'Y')        
inner join MDIngredientListIngredientCodes MIC on (MIC.IngredientListId=MDC.IngredientListId  and IsNull(MIC.RecordDeleted,'N')<>'Y')        
inner join MDAllergenGroupIngredients MDG on (MDG.HierarchicalIngredientCodeId=MIC.HierarchicalIngredientCodeId  and IsNull(MDG.RecordDeleted,'N')<>'Y')        
inner join MDAllergenConcepts MDA on MDA.AllergenGroupId=MDG.AllergenGroupId          
JOIN ClientAllergies CA on (CA.AllergenConceptId=MDA.AllergenConceptId and IsNull(CA.RecordDeleted,'N')<>'Y')          
where CA.ClientId=@ClientId and           
MD.MedicationNameId in (       
Select distinct CM.MedicationNameId       
from ClientMedications CM      
join ClientMedicationInstructions CMI on (CM.ClientMedicationId=CMI.ClientMedicationId and IsNull(CMI.RecordDeleted,'N')<>'Y')      
where     
CM.ClientMedicationId not in (Select ClientMedicationId from ClientMedicationScriptDrugs )    
and (CM.ClientId=@ClientId  AND isnull(CM.discontinued,'N') <> 'Y' and IsNull(CM.RecordDeleted,'N')<>'Y')         
and  (CMI.StartDate<=getdate() and CMI.EndDate>=convert(datetime, convert(varchar,getdate(),101),101))) and IsNull(MDA.RecordDeleted,'N')<>'Y'           
    
          
         
          
end try            
            
BEGIN CATCH                    
 declare @Error varchar(8000)                    
 set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                     
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[ssp_SCGetClientNonPrescribedDrugsAllergyInteraction]')                     
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                      
    + '*****' + Convert(varchar,ERROR_STATE())                    
                      
 RAISERROR                     
 (                    
  @Error, -- Message text.                    
  16, -- Severity.                    
  1 -- State.                    
 );                    
                    
END CATCH   