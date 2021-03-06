/****** Object:  StoredProcedure [dbo].[csp_RDLHarborConsent]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLHarborConsent]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLHarborConsent]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLHarborConsent]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_RDLHarborConsent]     
(                  
 @ClientMedicationId VARCHAR(500)                  
)       
/*********************************************************************/    
/* Procedure: csp_RDLHarborConsent            */    
/*                                                                   */    
/* Purpose: retrieve  data for rendering the RDL Report for Harbor Consent */    
/*                  */    
/*                                                                   */    
/* Parameters: @ClientMedicationId VARCHAR(500)                      */    
/*                                                                   */    
/*                                                                   */    
/* Returns/Results: Returns fields required for generating RDL Report (CommonSideEffects) */    
/*                                                                   */    
/* Created By: Loveena                                       */    
/*                                                                   */    
/* Created Date: 16-May-2009                                          */    
/*                                                                   */    
/* Revision History:                                                 */    
/*********************************************************************/               
AS     
                 
BEGIN     
SET FMTONLY OFF      
 BEGIN TRY               
                                             
                                
   create table #output     
   (    
   ClientMedicationId int,    
   PatientEducationMonographId int,    
   CommonSideEffects varchar(max)    
   )    
   declare @ClientMedicationId1 int    
   declare @PatientEducationMonographId int    
   declare @xyz varchar(max)    
   declare cPatientMonographId cursor for    
    
    select distinct CM.ClientMedicationId,PatientEducationMonographId from ClientMedications CM    
     inner join ClientMedicationInstructions CMI on CMI.ClientMedicationId=CM.ClientMedicationId    
     inner join MDMedications MD on MD.MedicationId = CMI.StrengthId    
     inner join MDPatientEducationMonographFormulations MDP on MDP.ClinicalFormulationId = MD.ClinicalFormulationId    
     where CM.ClientMedicationId in /*(60151,60152,60153)*/(SELECT * FROM [dbo].fnSplit(@ClientMedicationId,'',''))    
   open cPatientMonographId    
    
   fetch cPatientMonographId into    
   @ClientMedicationId1,    
   @PatientEducationMonographId       
    
   WHILE @@FETCH_STATUS=0    
   BEGIN    
            
    exec scsp_RDLMMPatientEducationMonographSideEffects @PatientEducationMonographId,@xyz output    
    
    insert into #output(ClientMedicationId,PatientEducationMonographId,CommonSideEffects)    
    values (@ClientMedicationId1,@PatientEducationMonographId,@xyz)    
   END    
   close cPatientMonographId    
   deallocate cPatientMonographId    
    
   select * from #output    
    
   drop table #output    
     
          
    
 END TRY    
     
 BEGIN CATCH    
   DECLARE @Error varchar(8000)                           
   SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                         
   + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_RDLHarborConsent'')                                                         
   + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                          
   + ''*****'' + Convert(varchar,ERROR_STATE())                                                        
  RAISERROR                                                         
  (                                                        
   @Error, -- Message text.                                                        
   16, -- Severity.                                                        
   1 -- State.                                                        
  );                
 END CATCH    
  SET FMTONLY ON      
END
' 
END
GO
