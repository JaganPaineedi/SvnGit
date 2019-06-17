/****** Object:  StoredProcedure [dbo].[csp_GetPsychEvalNextAppointments]    Script Date: 01/08/2015 10:20:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetPsychEvalNextAppointments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetPsychEvalNextAppointments]
GO

/****** Object:  StoredProcedure [dbo].[csp_GetPsychEvalNextAppointments]    Script Date: 01/08/2015 10:20:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_GetPsychEvalNextAppointments] (
	 @ServiceId int,
	 @LoggedInStaffId int,
	 @ClientId int,
	 @ProcedureCodeId int = NULL,
	 @DateOfService datetime = NULL
	)
AS
BEGIN
	/********************************************************************************                                                   
--  
-- Copyright: Streamline Healthcare Solutions  
-- "Psychiatric Service"
-- Purpose: Script for Task #823 - Woods Customizations
--  
-- Author:  Dhanil Manuel
-- Date:    12-31-2014
-- *****History****  

*********************************************************************************/

	                      
BEGIN TRY	
	SELECT SR.ServiceId
		,(A.[Subject] +', '+(CONVERT(VARCHAR(20), A.StartTime, 101) + ' ' + RIGHT(CONVERT(VARCHAR, A.StartTime, 0), 6)) +' (' + S.LastName + ', ' + S.FirstName+')') AS Appointment
	FROM Appointments A
	INNER JOIN Services SR ON SR.ServiceId = A.ServiceId
	INNER JOIN Staff S ON A.StaffId = S.StaffId
	WHERE SR.ClinicianId = @LoggedInStaffId
		AND SR.ClientId = @ClientId
		AND A.StartTime > (SELECT DateOfService FROM Services WHERE ServiceId = @ServiceId)
		AND (SR.ServiceId IS NULL OR SR.[Status] IN (70,71,75))
		AND SR.ProcedureCodeId IN (SELECT ProcedureCodeId FROM ProcedureCodes WHERE AssociatedNoteId = (SELECT DocumentCodeId FROM Documents WHERE ServiceId = @ServiceId))
		AND ISNULL(A.RecordDeleted, 'N') <> 'Y'
		AND ISNULL(S.RecordDeleted, 'N') <> 'Y'
		AND ISNULL(SR.RecordDeleted, 'N') <> 'Y'	
END TRY
                                                                                                 
BEGIN CATCH                    
DECLARE @Error varchar(8000)                                                                 
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                               
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_GetPsychEvalNextAppointments')                                                                                               
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                               
    + '*****' + Convert(varchar,ERROR_STATE())                                            
 RAISERROR                                                                                               
 (                                     
  @Error, -- Message text.                                                                                              
  16, -- Severity.                                                                                              
  1 -- State.                                                                         
 );                                                                                            
END CATCH                                           
END 

GO


