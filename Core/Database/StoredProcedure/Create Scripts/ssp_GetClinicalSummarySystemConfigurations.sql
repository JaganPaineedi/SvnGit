IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = Object_id(N'[dbo].[ssp_GetClinicalSummarySystemConfigurations]')
			AND TYPE IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetClinicalSummarySystemConfigurations]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE ssp_GetClinicalSummarySystemConfigurations   
    
AS  
/******************************************************************************  
**  File: ssp_GetClinicalSummarySystemConfigurations.sql  
**  Name: ssp_GetClinicalSummarySystemConfigurations  
**  Desc: Provides general client information for the Clinical Summary  
**  
**  Return values:  
**  
**  Called by:  
**  
**  Parameters:  
**  Input   Output  
**  ServiceId      -----------  
**  
**  Created By: Veena S Mani  
**  Date:  Oct 16 2014  
*******************************************************************************  
**  Change History  
*******************************************************************************  
**  Date:  Author:    Description:  
**  -------- --------   -------------------------------------------  
  
*******************************************************************************/  
  
BEGIN  
 SET NOCOUNT ON;  
  
 BEGIN TRY  
   
 SELECT [Value] as Value,  
 [key] as [Key],  
 Case   
 --when [Key]='ShowClinicalSummaryGeneralInfo' then 'General Information'   
 -- when [Key]='ShowClinicalSummaryClientInfo' then 'Client Information'   
  when [Key]='ShowClinicalSummaryVisitReason' then 'Reason For Visit'   
     when [Key]='ShowClinicalSummaryDiagnosis' then 'Current Diagnosis/Problem List'  
  when [Key]='ShowClinicalSummaryProcedureIntervention' then 'Procedure/Interventions Performed During Visit'  
  when [Key]='ShowClinicalSummaryVitals' then 'Vital Signs'   
  when [Key]='ShowClinicalSummaryAllergies' then 'Allergies'   
     when [Key]='ShowClinicalSummarySmokingStatus' then 'Smoking Status'  
  when [Key]='ShowClinicalSummaryCurrentMedication' then 'Current Mediciation'  
  when [Key]='ShowClinicalSummaryMedicationAdministrated' then 'Medication Administrated During Visit'   
     when [Key]='ShowClinicalSummaryImmunizations' then 'Immunization Administrated During Visit'  
  when [Key]='ShowClinicalSummaryResultReviewed' then 'Result Reviewed Date of Visit'  
  when [Key]='ShowClinicalSummaryEducation' then 'Patient Education/Decision Aides'   
  when [Key]='ShowClinicalSummaryReferralToOther' then 'Referral to Other Providers'   
     when [Key]='ShowClinicalSummaryAppointments' then 'Up Coming Appointments'  
  --when [Key]='ShowClinicalSummaryGoalsObjectives' then 'Goals/Objectives'  
  when [Key]='ShowClinicalSummaryOrderPending' then 'Orders/Tests Initiated/Pending During Visit'   
     when [Key]='ShowClinicalSummaryCareTeam' then 'Participants/Care Team'  
     when [Key]='ShowClinicalSummaryGoalsObjectives' then 'Plan of Care'  
     when [Key]='ShowClinicalInstruction' then 'Clinical Instructions'  
     when [Key]='ShowClinicalSummaryProcedureDuringVisit' then 'Procedures During Visit' 
      when [Key]='ShowClinicalSummaryFutureOrders' then 'Future Orders/Tests Initiated/Pending During Visit'  
    
    
   else '' end  as Name  
 from systemconfigurationkeys   
 where [key] in ('ShowClinicalSummaryGeneralInfo','ShowClinicalSummaryClientInfo','ShowClinicalSummaryVisitReason','ShowClinicalSummaryDiagnosis','ShowClinicalSummaryProcedureIntervention',  
 'ShowClinicalSummaryVitals','ShowClinicalSummaryAllergies','ShowClinicalSummarySmokingStatus','ShowClinicalSummaryCurrentMedication','ShowClinicalSummaryMedicationAdministrated',  
 'ShowClinicalSummaryImmunizations','ShowClinicalSummaryResultReviewed','ShowClinicalSummaryEducation','ShowClinicalSummaryReferralToOther','ShowClinicalSummaryAppointments','ShowClinicalSummaryGoalsObjectives',  
 'ShowClinicalSummaryOrderPending','ShowClinicalSummaryCareTeam','ShowClinicalInstruction','ShowClinicalSummaryProcedureDuringVisit','ShowClinicalSummaryFutureOrders') and isnull(value,'Y') <>'N' 
   
    
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, Error_number()) + '*****'   
  + CONVERT(VARCHAR(4000), Error_message()) + '*****'  
   + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_GetClinicalSummarySystemConfigurations') + '*****'   
   + CONVERT(VARCHAR, Error_line()) + '*****'  
    + CONVERT(VARCHAR, Error_severity()) + '*****'  
     + CONVERT(VARCHAR, Error_state())  
  
  RAISERROR (  
    @Error  
    ,16  
    ,1  
    );  
 END CATCH  
END