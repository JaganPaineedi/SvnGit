set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

CREATE procedure [dbo].[ssp_SCMedicationUnits]  
/************************************************************/  
/* Procedure: ssp_SCMedicationUnits       */  
/*               */  
/* Purpose: Select correct "units" values from GlobalCodes */  
/* for the given medication/strength      */  
/*               */  
/* Created by: TER           */  
/*               */  
/* Created date: 1/7/2008         */  
/* Modified by:Sonia (To accomodate change related to solutions and suspensions need to be treated like liquids*/
/* As per Task #1 MM-1.5
(Implemented changes as per Task #1 MM 1.5 Stored Procs Changed to Support Production)
*/

/************************************************************/  
  
 @MedicationId int  
as  
  
declare @RouteAdministrationCode2 char(2), @StrengthDescription varchar(250)  
  
declare @GCml int, @GCmg int, @GCunits int, @GCcc int, @GCeach int  
  
select @GCml = 4922, @GCmg = 4921, @GCunits = 4923, @GCcc = 4924, @GCeach = 4925  
  
select @RouteAdministrationCode2 = ra.RouteAdministrationCode2, @StrengthDescription = med.StrengthDescription  
from dbo.MDMedications as med  
join dbo.MDClinicalFormulations as cf on cf.ClinicalFormulationId = med.ClinicalFormulationId  
join mdrouteadministrations as ra on ra.RouteAdministrationId = cf.RouteAdministrationId  
where med.MedicationId = @MedicationId  
  
if @@error <> 0 goto error  
  
if @RouteAdministrationCode2 in ('PO', 'RC') and (@StrengthDescription like '%syrp%' or @StrengthDescription like '%liqd%' 
		or @StrengthDescription like '%soln%' or @StrengthDescription like '%susp%')
 select GlobalCodeId, CodeName from GlobalCodes where GlobalCodeId in (@GCml, @GCmg)  
else if @RouteAdministrationCode2 in ('PO', 'RC')  
 select GlobalCodeId, CodeName from GlobalCodes where GlobalCodeId = @GCeach  
else if @RouteAdministrationCode2 in ('IM', 'IV')  
 select GlobalCodeId, CodeName from GlobalCodes where GlobalCodeId in (@GCml, @GCmg, @GCunits, @GCcc, @GCeach)  
else   
 select GlobalCodeId, CodeName from GlobalCodes where GlobalCodeId in (@GCunits, @GCeach)  
  
if @@error <> 0 goto error  
  
return 0  
  
error:  
raiserror('ssp_SCMedicationUnits raised error for MedicationId: %d', 16, 1, @MedicationId)  
  





