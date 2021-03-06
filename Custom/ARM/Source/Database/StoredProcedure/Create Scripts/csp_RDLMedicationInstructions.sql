/****** Object:  StoredProcedure [dbo].[csp_RDLMedicationInstructions]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLMedicationInstructions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLMedicationInstructions]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLMedicationInstructions]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_RDLMedicationInstructions]
(      
 @ClientId int,                
 @ClientMedicationId VARCHAR(500)                  
)       
/*********************************************************************/    
/* Procedure: csp_RDLMedicationInstructions            */    
/*                                                                   */    
/* Purpose: retrieve  data for rendering the RDL Report for Harbor Consent */    
/*                  */    
/*                                                                   */    
/* Parameters: @ClientMedicationId VARCHAR(500)                      */    
/*                                                                   */    
/*                                                                   */    
/* Returns/Results: Returns fields required for generating RDL Report (MedicationName,*/    
/*     Insrtuctions,StartDate,endDate */    
/*                                                                   */    
/* Created By: Loveena                                       */    
/*                                                                   */    
/* Created Date: 16-May-2009                                          */    
/*                                                                   */    
/* Revision History:                                                
	avoss	04/15/2010	Show Range information rather than dosages for meds with range info available
	
*/               
AS     
                 
BEGIN     
    

BEGIN TRY              

declare @ClientMedicationIds table
(ClientMedicationId int)

insert into @ClientMedicationIds

SELECT Item
FROM [dbo].fnSplit(@ClientMedicationId,'','') 

--select * from @ClientMedicationIds

create table #MedicationDosages
(MedicationNameId int, EffectiveDate datetime, ClientDOB datetime, DosageInfo varchar(max))
insert into #MedicationDosages
(MedicationNameId, EffectiveDate, ClientDOB)
select Distinct 
 cm.MedicationNameId
,getdate()--cm.EffectiveDate
,c.DOB
from ClientMedications cm
join Clients c on c.CLientId = cm.ClientId
join @ClientMedicationIds ci on ci.ClientmedicationId = cm.ClientmedicationId

	declare @MedicationNameId int, @EffectiveDate datetime, @ClientDOB datetime 

	declare cDose cursor for    
	select distinct
	MedicationNameId,
	EffectiveDate,  
	ClientDOB
	from #MedicationDosages
   
	open cDose    
    
	fetch cDose into    
	@MedicationNameId,    
	@EffectiveDate,
	@ClientDOB      
    
--	Fetch from cDose into @MedicationNameId, @EffectiveDate, @ClientDOB
	WHILE (@@FETCH_STATUS = 0)
	BEGIN    
   
	declare @age int  

	declare @results table (  
	   DosageInfo varchar(500)  
	)    

		select @age = dbo.GetAge(@ClientDOB, @EffectiveDate)  

		if @age < 18  
		begin  
			insert into @results (DosageInfo)
			exec scsp_MMDosageRangeInfoByMedicationNamePediatric @MedicationNameId, @ClientDOB

			update m  
			set DosageInfo = r.DosageInfo
			from #MedicationDosages m
			cross join @Results r 	
			where m.MedicationNameId = @MedicationNameId		
		end  

		else if @age < 65  
		begin  
			insert into @results (DosageInfo)
			exec scsp_MMDosageRangeInfoByMedicationNameAdult @MedicationNameId

			update m  
			set DosageInfo = r.DosageInfo
			from #MedicationDosages m
			cross join @Results r 	
			where m.MedicationNameId = @MedicationNameId		
		end  
	   
		else  
		begin  
			insert into @results (DosageInfo)
			exec scsp_MMDosageRangeInfoByMedicationNameGeriatric @MedicationNameId

			update m  
			set DosageInfo = r.DosageInfo
			from #MedicationDosages m
			cross join @Results r 	
			where m.MedicationNameId = @MedicationNameId		
		end  

	delete from @Results
	
	Fetch next from cDose into @MedicationNameId, @EffectiveDate, @ClientDOB
	
	END    

	close cDose    
	deallocate cDose 

--	delete md
--	from #MedicationDosages md
--	where md.DosageInfo like ''%Ranges Not Available%''
 
--Add Side Effects 
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
	
	fetch  cPatientMonographId into @ClientMedicationId1,    @PatientEducationMonographId 

   END    
   close cPatientMonographId    
   deallocate cPatientMonographId    
    
   
    
--   drop table #output    









	select 
	cmi.ClientMedicationInstructionId,                                         
	cmi.ClientMedicationId,    
	CM.MedicationNameId,                                               
	(MD.StrengthDescription + '' '' + Convert(varchar,CMI.Quantity) + '' '' + Convert(varchar,GC.CodeName) + '' ''+ Convert(varchar,GC1.CodeName))  as Instruction,                  
	MDM.MedicationName  as MedicationName,                  
	CONVERT(varchar,CMSD.StartDate,101) as StartDate,               
	CONVERT(varchar,CMSD.EndDate,101) as EndDate
	--AV Addtions 02/18/2010
	,(select OrganizationName from SystemConfigurations) as OrganizationName
	,ra.DosageInfo as RangeInformation        
	,case when ra.MedicationNameId is not null then ''Y'' else ''N'' end as RangeDataExists 
	,o.CommonSideEffects                                              
	FROM ClientMedicationInstructions CMI                                            
	Join ClientMedications CM on (CMI.clientmedicationId=CM.clientMedicationid)                                                    
	LEFT JOIN GlobalCodes GC on (GC.GlobalCodeID = CMI.Unit) and isnull(gc.RecordDeleted, ''N'') <> ''Y''                              
	LEFT JOIN GlobalCodes GC1 on (GC1.GlobalCodeId = CMI.Schedule) and isnull(gc1.RecordDeleted, ''N'') <> ''Y''                       
	Join MDMedicationNames MDM on (CM.MedicationNameId=MDM.MedicationNameId)                                            
	Join MDMedications MD on (MD.MedicationID = CMI.StrengthId)                              
	join ClientMedicationScriptDrugs CMSD on   CMI.ClientMedicationInstructionId  =  CMSD.ClientMedicationInstructionId   
		and isnull(CMSD.RecordDeleted, ''N'') <> ''Y''
	left join #MedicationDosages ra on ra.MedicationNameId = cm.MedicationNameId
	left join #Output o on o.ClientMedicationId = cm.CLientMedicationId
	where cm.ClientId = @ClientId    
	and CAST( CM.ClientMedicationId as varchar(50)) in (SELECT * FROM [dbo].fnSplit(@ClientMedicationId,'','') )                    
	and CMSD.ModifiedDate= ( 
		Select max(ModifiedDate) 
		from ClientMedicationScriptDrugs  CMSD1                      
		where CMSD1.ClientMedicationInstructionId=CMI.ClientMedicationInstructionId and isnull(CMSD1.RecordDeleted, ''N'') <> ''Y''
	)                                     
	--removed and cm.OrderStatus = ''A''                  
	and isnull(cmi.Active,''Y'')=''Y''                                            
	and isnull(cm.discontinued,''N'') <> ''Y''                                             
	and isnull(cmi.RecordDeleted, ''N'') <> ''Y''                                            
	and isnull(cm.RecordDeleted, ''N'') <> ''Y''                                            
	and isnull(mdm.RecordDeleted, ''N'') <> ''Y''                                            
	and isnull(md.RecordDeleted, ''N'') <> ''Y''                        
	order by MDM.MedicationName asc    



 drop table #output    

 End try    
 BEGIN CATCH    
   DECLARE @Error varchar(8000)                          
   SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                         
   + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''scsp_RDLHaborConsent'')                                                         
   + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                          
   + ''*****'' + Convert(varchar,ERROR_STATE())                                                        
  RAISERROR                                                         
  (                                                        
   @Error, -- Message text.                                                        
   16, -- Severity.                                                        
   1 -- State.                                                        
  );                                                        
 END CATCH    
      
END
' 
END
GO
