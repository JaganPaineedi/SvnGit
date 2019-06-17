/****** Object:  UserDefinedFunction [dbo].[ssf_SCMedicationUnits]    Script Date: 05/10/2017 12:25:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssf_SCMedicationUnits]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ssf_SCMedicationUnits]
GO

/****** Object:  UserDefinedFunction [dbo].[ssf_SCMedicationUnits]    Script Date: 05/10/2017 12:25:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create function [dbo].[ssf_SCMedicationUnits]  (    
/************************************************************/      
/* Procedure: ssf_SCMedicationUnits       */      
/*               */      
/* Purpose: Select correct "units" values from GlobalCodes */      
/* for the given medication/strength      */      
/*               */      
/* Created by: TER           */      
/*               */      
/* Created date: 1/7/2008         */      
/* Modified by:Sonia (To accomodate change related to solutions and suspensions need to be treated like liquids*/    
/* As per Task #1 MM-1.5*/    
/* 2013.06.19 - T. Remisoski - Added "SR24" to the liquids list.*/
/* 2017.01.20 - Sanjay - what-:Added "suph" to the liquids list.
                         why-: Key Point - Support Go Live #758 */
/************************************************************/      
	@MedicationId int   )
	RETURNS @Return table 
( 
GlobalCodeId int , 
CodeName varchar(250) -- Maximum token size is 100 chars... 
)    
as      
 BEGIN      
declare @RouteAdministrationCode2 char(2), @StrengthDescription varchar(250)      
      
declare @GCml int, @GCmg int, @GCunits int, @GCcc int, @GCeach int, @GCPuffs int, @GCDrops int, @GCAppls int    
      
select @GCml = 4922, @GCmg = 4921, @GCunits = 4923, @GCcc = 4924, @GCeach = 4925,    
   @GCPuffs = 4926, @GCDrops = 4927, @GCAppls = 4928    
    
      
select @RouteAdministrationCode2 = ra.RouteAdministrationCode2, @StrengthDescription = med.StrengthDescription      
from dbo.MDMedications as med      
join dbo.MDClinicalFormulations as cf on cf.ClinicalFormulationId = med.ClinicalFormulationId      
join mdrouteadministrations as ra on ra.RouteAdministrationId = cf.RouteAdministrationId      
where med.MedicationId = @MedicationId      
    
 

if @RouteAdministrationCode2 in ('PO', 'RC') and (@StrengthDescription like '%syrp%' or @StrengthDescription like '%liqd%'     
  or @StrengthDescription like '%soln%' or @StrengthDescription like '%susp%' or @StrengthDescription like '%susr%' 
  or @StrengthDescription like '%elix%' or @StrengthDescription like '%conc%' or @StrengthDescription like '%SR24%' or @StrengthDescription like '%suph%')--Added @StrengthDescription like '%suph%' on 20-01-2017 for task @StrengthDescription like '%suph%' 
   insert into @Return
 select GlobalCodeId, CodeName from GlobalCodes where GlobalCodeId in (@GCml, @GCmg)      
else if @RouteAdministrationCode2 in ('PO', 'RC')    
insert into @Return  
 select GlobalCodeId, CodeName from GlobalCodes where GlobalCodeId = @GCeach      
else if @RouteAdministrationCode2 in ('IM', 'IV')       
insert into @Return  
 select GlobalCodeId, CodeName from GlobalCodes where GlobalCodeId in (@GCml, @GCmg, @GCunits, @GCcc, @GCeach)    
else if @RouteAdministrationCode2 in ('IH')     
insert into @Return  
 select GlobalCodeId, CodeName from GlobalCodes where GlobalCodeId in (@GCPuffs)    
else if @RouteAdministrationCode2 in ('OP') and (@StrengthDescription like '%Drop%' or @StrengthDescription like '%Drp%')   
insert into @Return    
 select GlobalCodeId, CodeName from GlobalCodes where GlobalCodeId in (@GCDrops)    
else if @RouteAdministrationCode2 in ('OP') and (@StrengthDescription like '%Gel%' or @StrengthDescription like '%Oint%')   
insert into @Return    
 select GlobalCodeId, CodeName from GlobalCodes where GlobalCodeId in (@GCAppls)    
else if @RouteAdministrationCode2 in ('TP')    
insert into @Return   
 select GlobalCodeId, CodeName from GlobalCodes where GlobalCodeId in (@GCAppls)    
else        
insert into @Return  
 select GlobalCodeId, CodeName from GlobalCodes where GlobalCodeId in (@GCunits, @GCeach)      
 

    


return 
-- 
END
GO


