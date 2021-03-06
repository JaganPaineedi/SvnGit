IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomPsychiatricServiceGeneral]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomPsychiatricServiceGeneral]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_RDLCustomPsychiatricServiceGeneral] 
(@DocumentVersionId INT)
/*************************************************
  Date:			Author:       Description:                            
  
  -------------------------------------------------------------------------            
 02-Jan-2015    Revathi      What: Psychiatric Service General tab information
                             Why:task #823 Woods-Customizations
************************************************/
  AS 
 BEGIN
				
	Begin Try 		
	
	declare @LoggedInStaffId int;
	declare @ClientId int;
	declare @ServiceId int;
	declare @NextPsychiatricAppointment varchar(max);
	select @LoggedInStaffId =  AuthorId,@ServiceId= ServiceId,@ClientId = ClientId  from  Documents Doc where  Doc.CurrentDocumentVersionId = @DocumentVersionId
	SELECT @NextPsychiatricAppointment =  (A.Subject +', '+(CONVERT(VARCHAR(20), A.StartTime, 101) + ' ' + RIGHT(CONVERT(VARCHAR, A.StartTime, 0), 6))+' (' + S.LastName + ', ' + S.FirstName+')')   FROM Appointments A
INNER JOIN Services SR on SR.ServiceId=A.ServiceId
INNER JOIN Staff S ON A.StaffId=S.StaffId 
WHERE 
SR.ClinicianId =@LoggedInStaffId  AND SR.ClientId=@ClientId 
AND A.StartTime>(SELECT DateOfService FROM  Services WHERE ServiceId=@ServiceId)
AND (SR.ServiceId is null or SR.Status in (70, 71, 75)) 
AND SR.ProcedureCodeId in(select ProcedureCodeId from ProcedureCodes where AssociatedNoteId=(select DocumentCodeId from Documents where ServiceId =@ServiceId))
AND ISNULL(A.RecordDeleted,'N') <> 'Y'
AND ISNULL(S.RecordDeleted,'N') <> 'Y'
AND ISNULL(SR.RecordDeleted,'N')<>'Y'
			
		SELECT  Distinct 
		DocumentVersionId,
		@ServiceId as ServiceId,
		@ClientId as ClientId,
		@NextPsychiatricAppointment as NextPsychiatricAppointment,
		CG.SummaryAndRecommendations,
		CG.MedicationListAtTheTimeOfTransition
		FROM CustomDocumentPsychiatricServiceNoteGenerals CG			
		WHERE 				
		ISNULL(CG.RecordDeleted,'N')='N'		
		AND CG.DocumentVersionId = @DocumentVersionId
	End Try
 
  BEGIN CATCH          
   DECLARE @Error varchar(8000)                                                 
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                        
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RDLCustomPsychiatricServiceGeneral')                                                                               
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                
   + '*****' + Convert(varchar,ERROR_STATE())                                           
   RAISERROR ( @Error, /* Message text.*/16, /* Severity.*/ 1 /*State.*/ );             
 END CATCH          
END