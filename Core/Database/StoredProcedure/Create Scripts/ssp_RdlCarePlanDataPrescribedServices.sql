
/****** Object:  StoredProcedure [dbo].[ssp_RdlCarePlanDataPrescribedServices]    Script Date: 01/13/2015 16:50:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RdlCarePlanDataPrescribedServices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RdlCarePlanDataPrescribedServices]
GO



/****** Object:  StoredProcedure [dbo].[ssp_RdlCarePlanDataPrescribedServices]    Script Date: 01/13/2015 16:50:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
  
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
CREATE PROCEDURE [dbo].[ssp_RdlCarePlanDataPrescribedServices]--848028 --490
(  
  @DocumentVersionId AS INT    
 )      
AS  
BEGIN   
/************************************************************************/                                                            
/* Stored Procedure: csp_RdlCarePlanDataPrescribedServices    */                                                   
/* Creation Date:  25-03-2013           */                                                             
/* Purpose: Get Data for the RDL          */                                                           
/* Input Parameters: DocumentVersionId         */                                                          
/* Purpose: Use For Rdl Report           */                                                                                                       
/* Author:  Gayathri Naik            */  
/* Modifications                                                        */  
/* ---------------------------------------------------------------------*/  
/*                     Javed             Changed the place where the Record Deleted was used */  
/* 5-20-2013           Jeff Riley        Added Objective numbers        */  
/* 10-23-2013     MalathiShiva           Added Recorddeleted check for Objectives */  
/* 13/Jan/2014    Aravind                Modified As part for Core CarePlan  Module- Task #915 -Ability to CRUD Treatment Plans
							             Valley - Customizations
 27/Aug/2015	  R.M.Manikandan		 Added Two Column Time and Duration    Task No:#30 -New Directions - Support Go Live						                                                                            
 05/Nov/2015	  Venkatesh MR			Order of giving columns was wrong so it was giving an error -Ref- Task - 55 - Valley Go Live Support						                                                                            
/* 04/27/2018     Neha		            Added a new column called Intervention Details in the intervention section. 
									    Task #10004 Porter Starke Customization */
 
/************************************************************************/  */
Begin Try  

declare @CustomFieldsFlag char(1)
declare @LableTimeDuration varchar(10)

--27/Aug/2015	  R.M.Manikandan
set @CustomFieldsFlag=(Select top 1 value  from SystemConfigurationKeys where [Key]='ShowAdditionalTimeAndDurationInCarePlanIntervention')
if @CustomFieldsFlag='Y' 
begin 
Set @LableTimeDuration='Time:' 
end 
else 
begin 
set @LableTimeDuration='Duration:' 
end
 -- Changes End       

  
declare @Results table(  
 AuthorizationCodeName varchar(max),  
 DocumentVersionId int,  
 NumberOfSessions int,  
 FrequencyType varchar(max),  
 PersonResponsible varchar(max),  
 UnitType varchar(max),  
 PrescribedServiceId int,  
 ObjectiveNumbers varchar(max),   
 --27/Aug/2015	  R.M.Manikanda
 Number int,
 Duration varchar(100),
 InterventionDetails varchar(max)
  -- Changes End       
)  
  
  
insert into @Results(  
 AuthorizationCodeName,  
 DocumentVersionId,  
 NumberOfSessions,  
 FrequencyType,  
 PersonResponsible,  
 UnitType,  
 PrescribedServiceId, 
 --27/Aug/2015	  R.M.Manikanda
 Number,
 Duration,
 InterventionDetails
 -- Changes End       
)  
Select Distinct AC.DisplayAs As AuthorizationCodeName ,   
   CPPS.DocumentVersionId,      
  CPPS.NumberOfSessions,         
  dbo.csf_GetGlobalCodeNameById(CPPS.[FrequencyType]) as [FrequencyType] ,   
    
  GC.CodeName as PersonResponsible,    
  isnull(convert(nvarchar,CPPS.[Units]),'')+'  '+isnull(dbo.csf_GetGlobalCodeNameById(CPPS.[UnitType]),'') as [UnitType],   
  --27/Aug/2015   R.M.Manikanda  
  CPPSO.CarePlanPrescribedServiceId  ,
    CPPS.Number,
  isnull(dbo.csf_GetGlobalCodeNameById(CPPS.[Duration]),'') as [Duration],
  CPPS.InterventionDetails
   -- Changes End       
from  CarePlanPrescribedServices CPPS  
LEFT JOIN CarePlanPrescribedServiceObjectives CPPSO ON   CPPSO.CarePlanPrescribedServiceId=CPPS.CarePlanPrescribedServiceId AND ISNULL(CPPSO.RecordDeleted,'N')='N'  
LEFT JOIN AuthorizationCodes   AC ON AC.AuthorizationCodeId = CPPS.AuthorizationCodeId AND ISNULL(AC.RecordDeleted,'N')='N'  
left join Globalcodes GC on CPPS.PersonResponsible=GC.GlobalcOdeid AND ISNULL(GC.RecordDeleted,'N')='N'  
where CPPS.DocumentversionId=@DocumentversionId AND   
      ISNULL(CPPS.RecordDeleted,'N')='N'  
  
update r  
set r.ObjectiveNumbers = (select CONVERT(VARCHAR,o.ObjectiveNumber) + ','  
        from CarePlanPrescribedServiceObjectives pso  
        join CarePlanObjectives o on o.CarePlanObjectiveId = pso.CarePlanObjectiveId  
        where pso.CarePlanPrescribedServiceId = r.PrescribedServiceId  
        and ISNULL(pso.RecordDeleted,'N')='N'  
        for XML PATH(''))  
from @Results r  
  
select r.AuthorizationCodeName,  
       r.DocumentVersionId,  
       r.NumberOfSessions,  
       r.FrequencyType,  
       r.PersonResponsible,  
       r.UnitType,
--27/Aug/2015	  R.M.Manikanda
       r.Number,
       r.Duration,
       r.InterventionDetails,
       @LableTimeDuration as LableTimeDuration ,
       @CustomFieldsFlag as CustomFieldsFlag, 
 -- Changes End       
       left(r.ObjectiveNumbers,len(r.ObjectiveNumbers)-1) as ObjectiveNumbers  
from @Results r  
  
  
  
END TRY  
 BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_RdlCarePlanDataPrescribedServices') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                                          
				16
				,-- Severity.                                                                                  
				1 -- State.                                                                                                          
				);
	END CATCH
END  
  
  
GO


