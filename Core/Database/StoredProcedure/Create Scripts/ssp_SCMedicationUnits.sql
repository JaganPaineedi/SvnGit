  
CREATE PROCEDURE [dbo].[ssp_SCMedicationUnits]  
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
 /* As per Task #1 MM-1.5*/  
 /* 2013.06.19 - T. Remisoski - Added "SR24" to the liquids list.*/  
 /* 2017.01.20 - Sanjay - what-:Added "suph" to the liquids list.  
                         why-: Key Point - Support Go Live #758 */  
 /* 2017.09.22 - Shankha - Why: Thresholds - Support: #1022 RX: SCRx - "mg" Not 
							   Available In "Units" Dropdown Menu For “Fluphenazine Decanoate*/                         
 /************************************************************/  
 @MedicationId INT  
AS  
DECLARE @RouteAdministrationCode2 CHAR(2)  
 ,@StrengthDescription VARCHAR(250)  
DECLARE @GCml INT  
 ,@GCmg INT  
 ,@GCunits INT  
 ,@GCcc INT  
 ,@GCeach INT  
 ,@GCPuffs INT  
 ,@GCDrops INT  
 ,@GCAppls INT  
  
SELECT @GCml = 4922  
 ,@GCmg = 4921  
 ,@GCunits = 4923  
 ,@GCcc = 4924  
 ,@GCeach = 4925  
 ,@GCPuffs = 4926  
 ,@GCDrops = 4927  
 ,@GCAppls = 4928  
  
SELECT @RouteAdministrationCode2 = ra.RouteAdministrationCode2  
 ,@StrengthDescription = med.StrengthDescription  
FROM dbo.MDMedications AS med  
JOIN dbo.MDClinicalFormulations AS cf ON cf.ClinicalFormulationId = med.ClinicalFormulationId  
JOIN mdrouteadministrations AS ra ON ra.RouteAdministrationId = cf.RouteAdministrationId  
WHERE med.MedicationId = @MedicationId  
  
IF @@error <> 0  
 GOTO error  
  
IF @RouteAdministrationCode2 IN (  
  'PO'  
  ,'RC'  
  )  
 AND (  
  @StrengthDescription LIKE '%syrp%'  
  OR @StrengthDescription LIKE '%liqd%'  
  OR @StrengthDescription LIKE '%soln%'  
  OR @StrengthDescription LIKE '%susp%'  
  OR @StrengthDescription LIKE '%susr%'  
  OR @StrengthDescription LIKE '%elix%'  
  OR @StrengthDescription LIKE '%conc%'  
  OR @StrengthDescription LIKE '%SR24%'  
  OR @StrengthDescription LIKE '%suph%'  
  ) --Added @StrengthDescription like '%suph%' on 20-01-2017 for task @StrengthDescription like '%suph%'      
 SELECT GlobalCodeId  
  ,CodeName  
 FROM GlobalCodes  
 WHERE GlobalCodeId IN (  
   @GCml  
   ,@GCmg  
   )  
ELSE IF @RouteAdministrationCode2 IN (  
  'PO'  
  ,'RC'  
  )  
 SELECT GlobalCodeId  
  ,CodeName  
 FROM GlobalCodes  
 WHERE GlobalCodeId = @GCeach  
ELSE IF @RouteAdministrationCode2 IN (  
  'IM'  
  ,'IV'  
  ,'IJ'  
  )  
 SELECT GlobalCodeId  
  ,CodeName  
 FROM GlobalCodes  
 WHERE GlobalCodeId IN (  
   @GCml  
   ,@GCmg  
   ,@GCunits  
   ,@GCcc  
   ,@GCeach  
   )  
ELSE IF @RouteAdministrationCode2 IN ('IH')  
 SELECT GlobalCodeId  
  ,CodeName  
 FROM GlobalCodes  
 WHERE GlobalCodeId IN (@GCPuffs)  
ELSE IF @RouteAdministrationCode2 IN ('OP')  
 AND (  
  @StrengthDescription LIKE '%Drop%'  
  OR @StrengthDescription LIKE '%Drp%'  
  )  
 SELECT GlobalCodeId  
  ,CodeName  
 FROM GlobalCodes  
 WHERE GlobalCodeId IN (@GCDrops)  
ELSE IF @RouteAdministrationCode2 IN ('OP')  
 AND (  
  @StrengthDescription LIKE '%Gel%'  
  OR @StrengthDescription LIKE '%Oint%'  
  )  
 SELECT GlobalCodeId  
  ,CodeName  
 FROM GlobalCodes  
 WHERE GlobalCodeId IN (@GCAppls)  
ELSE IF @RouteAdministrationCode2 IN ('TP')  
 SELECT GlobalCodeId  
  ,CodeName  
 FROM GlobalCodes  
 WHERE GlobalCodeId IN (@GCAppls)  
ELSE  
 SELECT GlobalCodeId  
  ,CodeName  
 FROM GlobalCodes  
 WHERE GlobalCodeId IN (  
   @GCunits  
   ,@GCeach  
   )  
  
IF @@error <> 0  
 GOTO error  
  
RETURN 0  
  
error:  
  
RAISERROR (  
  'ssp_SCMedicationUnits raised error for MedicationId: %d'  
  ,16  
  ,1  
  ,@MedicationId  
  )  