 
/****** Object:  StoredProcedure [dbo].[ssp_PCIsSlotAlreadyBusy]    Script Date: 08/06/2012 12:46:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PCIsSlotAlreadyBusy]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PCIsSlotAlreadyBusy]

/****** Object:  StoredProcedure [dbo].[ssp_PCIsSlotAlreadyBusy]    Script Date: 08/06/2012 12:46:50 ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[ssp_PCIsSlotAlreadyBusy]
    (
      @StaffId INT ,
      @AppointmentId INT ,
      @StartDateTime DATETIME ,
      @EndDateTime DATETIME ,
      @AppointmentType INT,
      @Return VARCHAR(500) OUTPUT           
    )
AS 

/**************************************************************/                                                                                            
/* Stored Procedure: [ssp_PCIsSlotAlreadyBusy]   */
/* Task# - 7 - Scheduling - Primary Care - Summit Pointe*/                                                                                   
/* Creation Date:  06August2012                                */     
/* Creation By:	   Davinderk                                */                      
/* Purpose: To check the appointment busy or free      */                                                                                           
/* Input Parameters:   @StaffId,@AppointmentId,@StartDateTime,@EndDateTime,@AppointmentType */                                                                                          
/* Output Parameters:  @Return         */                                                                                            
/* Return:               */                                                                                            
/* Called By: Core My calendar - New Primary Care Entry      */                                                                                  
/* Calls:                                                     */                                                                                            
/*                                                            */                                                                                            
/* Data Modifications:                                        */                                                                                            
/* Updates:                                                   */                                                                                            
/* Date			Author				Purpose         */   
/* 27Aug2012	DavinderK			Updated - Select top 1 * -------> select top 1 */
/* 16Apr2018	Venkatesh			The system should have logic in place to prevent ( or at least warn ) of overlapping appointments, regardless of which kind of appointment it is. So commenting AppointmentType check Ref Andrews Center - Enhancements #202 */
/**************************************************************/     

BEGIN   
BEGIN TRY 
	DECLARE @strMessage VARCHAR(500)
	SET @Return = ''
	IF EXISTS ( SELECT  1
						 
				FROM    Appointments
				WHERE   StaffId = @StaffId
						AND ( ( StartTime <= @StartDateTime
								AND @StartDateTime < EndTime
							  )
							  OR ( @StartDateTime <= StartTime
								   AND StartTime < @EndDateTime
								 )
							)
						AND ShowTimeAs = 4342
						AND AppointmentId <> @AppointmentId
						--AND AppointmentType=@AppointmentType
						AND ISNULL(recorddeleted, 'N') = 'N' ) 
		BEGIN
			SET @Return = 'Another Appointment with busy status already exists'
		END
END TRY
        
BEGIN CATCH                                
	DECLARE @Error varchar(8000)                                                                          
	SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                       
	+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_PCIsSlotAlreadyBusy')                                                                                                           
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
	

