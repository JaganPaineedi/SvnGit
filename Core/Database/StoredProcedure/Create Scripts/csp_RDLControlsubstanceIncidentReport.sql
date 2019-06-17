/****** Object:  StoredProcedure [dbo].[csp_RDLControlsubstanceIncidentReport]    ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLControlsubstanceIncidentReport]')
			AND type IN (
				N'P'
				, N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_RDLControlsubstanceIncidentReport];
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLControlsubstanceIncidentReport]    ******/
SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE PROCEDURE [dbo].[csp_RDLControlsubstanceIncidentReport] 
	  @StartDate DATETIME
	, @EndDate DATETIME 
	, @PrescriberId int
AS

/******************************************************************************
* Creation Date:  6/DEC/2016
*
* Purpose: Gather data for Control Substance Audit Report - EPCS #32
* 
* Customer: EPCS
*
* Called By: Control Substance Audit Report
*
* Calls:
*
* Dependent Upon:
*
* Depends upon this: Report Days to Service
*
* Modifications:
* Date			Author			Purpose
* 
*02/22/2017     Pranay          EPCS Task: Added failed attempt, Modified user details 
*13/04/2018     Vinod           Added Date check condition for the start date and end date as per the task requirement of 	Aspen Point Build Cycle Tasks 38
                                to solve Control Substance Incident Report displaying data attempt date not within the start date and end date
                                          
*****************************************************************************/
SET NOCOUNT ON;

BEGIN
-- Two Factor Attempt
 SELECT s.FirstName + ' '+S.LastName AS AttemptedUser
        ,TFA.CreatedDate AS DateRangeStart
         ,'Permission' AS AttemptLocation
        ,CASE
         WHEN tfa.Authenticated='N' 
         THEN 'Failed' 
        WHEN tfa.Authenticated='Y' 
        THEN 'Successful' 
	    END AS Outcome 
		,'None' AS ClientName
		,s.FirstName + ' '+S.LastName AS StaffName
	    ,NULL AS ScriptId
        FROM Staff S 
        LEFT JOIN dbo.TwoFactorAuthenticationDeviceRegistrations TFA ON TFA.StaffId = S.StaffId
        WHERE TFA.StaffId=@PrescriberId AND TFA.ModifiedDate BETWEEN @StartDate AND @EndDate

UNION all

--Granting Prescription
      SELECT s.FirstName + ' '+S.LastName AS AttemptedUser
	  ,CMS.CreatedDate AS DateRangeStart
      ,CASE   
       WHEN CMI.SignHash IS NOT NULL
       THEN 'Prescription' 
       END AS AttemptLocation
      ,CASE   
       WHEN CMI.SignHash IS NOT NULL  
       THEN 'Successful' 
	   END AS Outcome 
	  ,C.FirstName+' '+C.LastName AS ClientName
	  ,'None' AS StaffName
	  ,CMS.ClientMedicationScriptId AS ScriptId
      FROM Staff S 
      LEFT JOIN ClientMedications AS CM ON CM.PrescriberId=S.StaffId AND ISNULL(CM.RecordDeleted,'N') <> 'Y'
      LEFT JOIN MDMedicationNames AS MedName ON MedName.MedicationNameId = CM.MedicationNameId AND ISNULL(MedName.RecordDeleted,'N') <> 'Y'
--LEFT JOIN dbo.MDMedications AS MDMed ON MDMed.MedicationNameId = MedName.MedicationNameId
      LEFT JOIN ClientMedicationInstructions AS CMI ON CMI.ClientMedicationId=CM.ClientMedicationId AND ISNULL(CMI.RecordDeleted,'N') <> 'Y'
      LEFT JOIN ClientMedicationScriptDrugs AS CMSD ON CMSD.ClientMedicationInstructionId=CMI.ClientMedicationInstructionId AND ISNULL(CMSD.RecordDeleted,'N') <> 'Y'
      LEFT JOIN ClientMedicationScripts AS CMS ON CMS.ClientMedicationScriptId=CMSD.ClientMedicationScriptId AND ISNULL(CMS.RecordDeleted,'N') <> 'Y'
      LEFT JOIN Clients C ON C.ClientId=CM.ClientId 
      WHERE CM.PrescriberId=@PrescriberId AND CMS.ModifiedDate BETWEEN @StartDate AND @EndDate AND CMI.SignHash IS NOT NULL

  UNION ALL

  -- Login Attempt
  SELECT  sfa.IPAddress AS AttemptedUser
       ,sfa.CreatedDate AS DateRageStart

	   ,'Login Attempt ' AS AttemptLocation
       ,'Failed' AS Outcome 
	   ,'None' AS ClientName
	   , S.FirstName+' '+S.LastName AS StaffName
	   , NULL AS ScriptId
from dbo.StaffFailedLoginAttempts sfa
LEFT JOIN Staff AS s ON sfa.[UserCode]=s.UserCode WHERE s.StaffId=@PrescriberId  AND sfa.ModifiedDate BETWEEN @StartDate AND @EndDate

UNION ALL

--Modified Details
       SELECT (SELECT s.FirstName +' '+s.LastName  FROM  Staff s WHERE s.UserCode =(SELECT ModifiedBY FROM staff s WHERE s.StaffId=@PrescriberId)) AS AttemptedUser
       , s.createdDate AS DateRangeStart
	   ,'Modified UserDetails' AS AttempLocation
	   ,'Successful' AS OutCome
	   ,'None' AS ClientName
	   ,s.FirstName+''+S.LastName AS StaffName
	   ,NULL AS ScriptID
	   FROM Staff S WHERE S.StaffId=@PrescriberId AND S.CreatedDate BETWEEN @StartDate AND @EndDate --Aspenpoint Build Cycle Tasks 38


END
GO


