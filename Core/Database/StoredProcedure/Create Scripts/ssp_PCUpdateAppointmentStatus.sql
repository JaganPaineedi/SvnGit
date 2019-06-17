

/****** Object:  StoredProcedure [dbo].[ssp_PCUpdateAppointmentStatus]    Script Date: 10/26/2012 18:28:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PCUpdateAppointmentStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PCUpdateAppointmentStatus]
GO



/****** Object:  StoredProcedure [dbo].[ssp_PCUpdateAppointmentStatus]    Script Date: 10/26/2012 18:28:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

    
CREATE Procedure [dbo].[ssp_PCUpdateAppointmentStatus]                  
(                  
  @AppointmentId int = 0,                  
  @StatusId int = 0,                  
  @CancelReason int = 0,          
  @CurrentUser varchar(30)     
)                  
AS   
       
/********************************************************************************                                                  
-- Stored Procedure: ssp_PCUpdateAppointmentStatus
--
-- Copyright: Streamline Healthcare Solutions
--
-- Purpose: Procedure to update Appointment Status
--
-- Author:  Mamta Gupta
-- Date:    Oct 27 2012
-- 
Date			Author					Purpose

 
*********************************************************************************/
BEGIN
	Begin Try     
	--To update Status in appointment table
	Update Appointments
		Set Status=@StatusId,
			CancelReason=@CancelReason,
			ModifiedBy=@CurrentUser,
			ModifiedDate=GETDATE(),
			ExamRoom = NULL
		where AppointmentId=@AppointmentId
	if(@StatusId=8042 or @StatusId=8044)
	Begin
	--To Set RecordDeleted='Y' in PrimaryCareAppointmentsStatusHistory table if status is rescheduled
		Update PrimaryCareAppointmentsStatusHistory
		Set RecordDeleted='Y',
			DeletedBy=@CurrentUser,
			DeletedDate=GETDATE()
		where PrimaryCareAppointmentId = @AppointmentId
	End
	Else
	Begin
		Insert into PrimaryCareAppointmentsStatusHistory
		(
			PrimaryCareAppointmentId,
			Status,
			Time
		)
		Values
		(
			@AppointmentId,
			@StatusId,
			GETDATE()
		)
	End
	End Try                                                                                                           
	BEGIN CATCH                                    
		DECLARE @Error varchar(8000)                                                                               
		SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                             
		+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),                            
		'ssp_PCUpdateAppointmentStatus')                                                                                                               
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


