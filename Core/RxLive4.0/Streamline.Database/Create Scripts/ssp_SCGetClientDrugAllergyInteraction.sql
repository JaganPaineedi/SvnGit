set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

CREATE procedure [dbo].[ssp_SCGetClientDrugAllergyInteraction]                                                    
(                                                    
 @ClientId int                                                 
)                                                    
as                     
/*********************************************************************/                                                            
/* Stored Procedure: dbo.[ssp_SCGetClientMedicationAllergyInteraction]                */                                                            
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                                                            
/* Creation Date:    6/Dec/07                                      */                                                           
/*                                                                   */                                                            
/* Purpose:  To retrieve Drug Allergy interaction details   */                                                            
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
/*  6/Dec/07    Sonia    Created     
  Sonia (Implemented changes as per Task #1 MM 1.5 Stored Procs Changed to Support Production)                               */                                                            
/*********************************************************************/                                                       
    
--select * from clientmedications    
    
begin try    
    
declare @CurrentMedicationIds varchar(4000)    
declare @Query nvarchar(4000)    
declare @CurrMedId int    
declare @retval int    
--    
-- Build a list of current medication ids for the client    
--    
declare cCurrentMeds cursor for    
select distinct cmi.StrengthId    
from ClientMedicationInstructions as cmi    
join ClientMedications as cm on cm.ClientMedicationId = cmi.ClientMedicationId    
where cm.ClientId = @ClientId    
and isnull(cm.Discontinued, 'N') <> 'Y'    
and isnull(cm.RecordDeleted, 'N') <> 'Y'    
and isnull(cmi.RecordDeleted, 'N') <> 'Y'    
--and datediff(day, cmi.StartDate, getdate()) >= 0    
--and ((datediff(day, cmi.EndDate, getdate()) <= 0) or (cmi.EndDate is null))    
    
set @CurrentMedicationIds = ''    
    
open cCurrentMeds    
    
fetch cCurrentMeds into @CurrMedId    
    
while @@fetch_status = 0    
begin    
    
 if len(@CurrentMedicationIds) > 0 set @CurrentMedicationIds = @CurrentMedicationIds + ','    
    
 set @CurrentMedicationIds = @CurrentMedicationIds + cast(@CurrMedId as varchar)    
    
 fetch cCurrentMeds into @CurrMedId    
    
end    
    
close cCurrentMeds    
    
deallocate cCurrentMeds    
    
    
/* Case Of client is allergic to a Medication Name */      
      
set @Query='Select distinct MDA.AllergenConceptId,MD.MedicationNameId,MDA.ConceptDescription      
from MDMedications MD      
inner join MDAllergenConcepts MDA on MDA.MedicationNameId=MD.MedicationNameId      
JOIN ClientAllergies CA on CA.AllergenConceptId=MDA.AllergenConceptId      
where ISNULL(CA.RecordDeleted,''N'')<>''Y'' and CA.ClientId='+ cast(@ClientId as varchar) +    
case when len(@CurrentMedicationIds) > 0 then '  and      
MD.MedicationId in (' + @CurrentMedicationIds + ')'  else ' and 1=0 ' end    
      
set @Query =  @Query + ' union '      
      
/* Case Of client is allergetic to a Ingredient*/      
      
set @Query =  @Query + 'Select distinct MDA.AllergenConceptId,MD.MedicationNameId,MDA.ConceptDescription      
from MDMedications MD      
inner join MDClinicalFormulations MDC on MD.ClinicalFormulationId=MDC.ClinicalFormulationId      
inner join MDIngredientListIngredientCodes MIC on MIC.IngredientListId=MDC.IngredientListId      
inner join MDAllergenConcepts MDA on MDA.HierarchicalIngredientCodeId=MIC.HierarchicalIngredientCodeId      
JOIN ClientAllergies CA on CA.AllergenConceptId=MDA.AllergenConceptId      
where ISNULL(CA.RecordDeleted,''N'')<>''Y'' and  CA.ClientId='+ cast(@ClientId as varchar) +    
case when len(@CurrentMedicationIds) > 0 then '  and      
MD.MedicationId in (' + @CurrentMedicationIds + ')'  else ' and 1=0 ' end    
      
      
      
set @Query =  @Query + ' union '      
      
/* Case Of client is allergetic to a Allergen group*/      
      
set @Query =  @Query + 'Select distinct MDA.AllergenConceptId,MD.MedicationNameId,MDA.ConceptDescription      
from MDMedications MD      
inner join MDClinicalFormulations MDC on MD.ClinicalFormulationId=MDC.ClinicalFormulationId      
inner join MDIngredientListIngredientCodes MIC on MIC.IngredientListId=MDC.IngredientListId      
inner join MDAllergenGroupIngredients MDG on MDG.HierarchicalIngredientCodeId=MIC.HierarchicalIngredientCodeId      
inner join MDAllergenConcepts MDA on MDA.AllergenGroupId=MDG.AllergenGroupId      
JOIN ClientAllergies CA on CA.AllergenConceptId=MDA.AllergenConceptId      
where ISNULL(CA.RecordDeleted,''N'')<>''Y'' and  CA.ClientId='+ cast(@ClientId as varchar) +    
case when len(@CurrentMedicationIds) > 0 then '  and      
MD.MedicationId in (' + @CurrentMedicationIds + ')'  else ' and 1=0 ' end    
    
      
execute sp_executesql @Query      
    
    
return @retval    
    
end try    
begin catch                        
 declare @Error varchar(8000)                        
 set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                         
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[ssp_SCGetClientDrugAllergyInteraction]')                         
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                          
    + '*****' + Convert(varchar,ERROR_STATE())                        
                          
 RAISERROR                         
 (                        
  @Error, -- Message text.                        
  16, -- Severity.                        
  1 -- State.                        
 );                        
                        
end catch 
