IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLIncidentReportFallDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLIncidentReportFallDetails]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLIncidentReportFallDetails]    Script Date: 11/27/2013 16:30:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[csp_RDLIncidentReportFallDetails]  
(                                                                                                                                                                                        
  @IncidentReportFallDetailId int                                                                                                                                                        
)                                                     
AS 

/*********************************************************************/                                                                                                                                      
/* Stored Procedure: dbo.[csp_RDLIncidentReportFallDetails]                */                                                                                                                                      
/* Copyright: 2008 Streamline Healthcare Solutions,  LLC             */                                                                                                                                      
/* Creation Date:   06-May-2015                                     */                                                                                                                                      
/*                                                                   */                                                                                                                                      
/* Purpose:  Get Data for CustomIncidentReportFallDetails Pages */                                                                                                                                    
/*                                                                   */                                                                                                                                    
/* Input Parameters:  @IncidentReportFallDetailId             */                                                                                                                                    
/*                                                                   */                                                                                                                                      
/* Output Parameters:   None                   */                                                                                                                                      
/*                                                                   */                                                                                                                                      
/* Return:  0=success, otherwise an error number                     */                                                                                                                                      
/*                                                                   */                                                                                                                                      
/* Called By:                                                        */                                                                                                                                      
/*                                                                   */                  
/* Calls:                        */                       
/* */                                         
/* Data Modifications:   */                                          
/*      */                                                                                     
/* Updates:                                          
 Date			Author			Purpose       
 ----------		---------		--------------------------------------                                                                               
 07-May-2015	Ravichandra		what:Use For Rdl Report  
								why:task #818 Woods – Customizations                                    
*/                                                                                                           
/*********************************************************************/                                                                                                                              
                                                                                                                                                                                                                                 
BEGIN
BEGIN TRY  
		
		SELECT
			(S.LastName +', '+ S.FirstName) AS SignedBy
			,dbo.csf_GetGlobalCodeNameById(CIRFD.FallDetailsDescribeIncident) AS DescribeIncident
			,dbo.csf_GetGlobalCodeNameById(CIRFD.FallDetailsCauseOfIncident) AS CauseOfIncident
			,CIRFD.FallDetailsCauseOfIncidentText AS FallDetailsCauseOfIncidentText 
			,CIRFD.FallDetailsNone AS None
			,CIRFD.FallDetailsCane AS Cane
			,CIRFD.FallDetailsSeatLapBelt AS SeatLapBelt
			,CIRFD.FallDetailsWheelchair AS Wheelchair
			,CIRFD.FallDetailsGaitBelt AS GaitBelt
			,CIRFD.FallDetailsWheellchairTray AS WheellchairTray
			,CIRFD.FallDetailsWalker AS Walker
			,CIRFD.FallDetailsMafosBraces AS MafosBraces
			,CIRFD.FallDetailsHelmet AS Helmet
			,CIRFD.FallDetailsChestHarness AS ChestHarness
			,CIRFD.FallDetailsOther AS Other
			,CIRFD.FallDetailsOtherText AS OtherText
			,dbo.csf_GetGlobalCodeNameById(CIRFD.FallDetailsIncidentOccurredWhile) AS IncidentOccurredWhile
			,G.Code AS IncidentOccurredWhileCode
			,dbo.csf_GetGlobalCodeNameById(CIRFD.FallDetailsFootwearAtTimeOfIncident) AS FootwearAtTimeOfIncident
			,CASE CIRFD.FallDetailsWheelsLocked
			   WHEN 'Y' THEN 'Yes' 
			   WHEN 'N' THEN 'No' 
			   WHEN 'U' THEN 'Unknown' 
			   END AS WheelsLocked
			,CASE CIRFD.FallDetailsWhereBedWheelsUnlocked
			   WHEN 'Y' THEN 'Yes' 
			   WHEN 'N' THEN 'No' 
			   WHEN 'U' THEN 'Unknown' 
			   END  AS WhereBedWheelsUnlocked
			,CIRFD.FallDetailsNA AS NA
			,CIRFD.FallDetailsFullLength AS FullLength
			,CIRFD.FallDetails2Half AS FallDetails2Half
			,CIRFD.FallDetails4Half AS FallDetails4Half
			,CIRFD.FallDetailsBothSidesUp AS BothSidesUp
			,CIRFD.FallDetailsOneSideUp AS OneSideUp
			,CIRFD.FallDetailsBumperPads AS BumperPads
			,CIRFD.FallDetailsFurtherDescription AS FurtherDescription
			,CIRFD.FallDetailsFurtherDescriptiontext AS FurtherDescriptiontext
			,CIRFD.FallDetailsWasAnAlarmPresent AS WasAnAlarmPresent
			,CIRFD.FallDetailsAlarmSoundedDuringIncident AS AlarmSoundedDuringIncident
			,CIRFD.FallDetailsAlarmDidNotSoundDuringIncident AS AlarmDidNotSoundDuringIncident
			,CIRFD.FallDetailsBedMat AS BedMat
			,CIRFD.FallDetailsBeam AS Beam
			,CIRFD.FallDetailsBabyMonitor AS BabyMonitor
			,CIRFD.FallDetailsFloorMat AS FloorMat
			,CIRFD.FallDetailsMagneticClip AS MagneticClip
			,CIRFD.FallDetailsTypeOfAlarmOtherText AS TypeOfAlarmOtherText
			,CIRFD.FallDetailsTypeOfAlarmOther AS TypeOfAlarmOther
			,CIRFD.FallDetailsDescriptionOfincident AS DescriptionOfincident
			,CIRFD.FallDetailsActionsTakenByStaff AS ActionsTakenByStaff
			,CIRFD.FallDetailsWitnesses AS Witnesses
			,(SS.LastName +', '+ SS.FirstName) AS  StaffNotifiedForInjury
			,(SSS.LastName +', '+ SSS.FirstName) AS  FallDetailsSupervisorFlaggedId
			,CONVERT(VARCHAR(10), CIRFD.FallDetailsDateStaffNotified, 101) AS DateStaffNotified
	        ,(right('0' + LTRIM(SUBSTRING(CONVERT(VARCHAR, CIRFD.FallDetailsTimestaffNotified, 100), 13, 2)), 2) + ':' + SUBSTRING(CONVERT(VARCHAR, CIRFD.FallDetailsTimestaffNotified, 100), 16, 2) + ' ' + SUBSTRING(CONVERT(VARCHAR, CIRFD.FallDetailsTimestaffNotified, 100), 18, 2)) AS TimestaffNotified
			,CIRFD.FallDetailsNoMedicalStaffNotified AS NoMedicalStaffNotified
			,CONVERT(VARCHAR(10),CIRFD.SignedDate,101) AS SignedDate
			,CIRFD.PhysicalSignature AS PhysicalSignature
			,CIRFD.CurrentStatus AS CurrentStatus
			,CIRFD.InProgressStatus AS InProgressStatus
			FROM CustomIncidentReportFallDetails  CIRFD
			LEFT JOIN Staff S ON CIRFD.SignedBy = S.StaffId  
			LEFT JOIN Staff SS ON CIRFD.FallDetailsStaffNotifiedForInjury = SS.StaffId  
			LEFT JOIN Staff SSS ON CIRFD.FallDetailsSupervisorFlaggedId = SSS.StaffId  
			Left JOin GlobalCodes G ON G.GlobalCodeId=CIRFD.FallDetailsIncidentOccurredWhile
			AND isnull(S.RecordDeleted, 'N') <> 'Y'
			WHERE CIRFD.IncidentReportFallDetailId = @IncidentReportFallDetailId 
			AND isnull(CIRFD.RecordDeleted, 'N') = 'N'  
  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLIncidentReportFallDetails') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.  
    16  
    ,-- Severity.  
    1 -- State.  
    );  
 END CATCH  
END 