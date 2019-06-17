IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = OBJECT_ID(N'[dbo].[ssp_SCUpdateASPRescheduleAppointments]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_SCUpdateASPRescheduleAppointments] 

go 

SET ansi_nulls ON 

go 

SET quoted_identifier ON 

go
CREATE PROCEDURE [dbo].[ssp_SCUpdateASPRescheduleAppointments] (  
	@ClientId               INT,
	@ProgramId              INT,
	@FrequencyValue         INT,
	@FrequencyCode          VARCHAR(50),
	@Monday                 CHAR(1),      
	@Tuesday                CHAR(1),      
	@Wednesday              CHAR(1),      
	@Thursday               CHAR(1),      
	@Friday                 CHAR(1),      
	@Saturday               CHAR(1),      
	@Sunday                 CHAR(1),   
	@SearchStartDate        DATE,
	@SearchEndDate          DATE,
	@Reschedule             CHAR(1),
	@DateToReschedule			DATE,
    @PreferredAppointmentDate	DATE,
    @DeletedBy				varchar(100)
 )
AS  
-- =============================================  
-- Author:  Gautam  
-- Create date: 31-Dec-2013 
-- Description: Cancel the @DateToReschedule appointment and create new appointments for @PreferredAppointmentDate
/*
Date				Author				Purpose
31-Dec-2013			Gautam				Created
21-Apr-2015			Revathi				what:while reschedule getting more than one available date,Error Message condition changed
										why:task #235 Philhaven Development
*/	
-- =============================================  
BEGIN    
	Begin Try
		
		DECLARE @ErrorMsg as nvarchar(max)

		select @ErrorMsg=dbo.Ssf_GetMesageByMessageCode(921,'VALIDATEASPMESSAGE','The requested date is already schedule by other user. Please change date and search again.')   
			
		Create Table #AdmissionAvailableDates(
			AvailableDate DATE
			)
     
		Exec ssp_SCSearchASP @ClientId ,@ProgramId,@FrequencyValue,@FrequencyCode,@Monday ,      
					@Tuesday, @Wednesday,@Thursday,@Friday,  @Saturday,@Sunday,
					  @SearchStartDate,@SearchEndDate,'Y',
					@DateToReschedule,'Y'
		
	 	If NOT EXISTS(Select 1 from #AdmissionAvailableDates WHERE AvailableDate = @PreferredAppointmentDate )--by Revathi  21-Apr-2015
		Begin 
			Print @ErrorMsg
			Return
		End	
			
		Begin Tran		
		-- Update appointment for @DateToReschedule
		update ProgramAppointments 
		set ModifiedBy=@DeletedBy,ModifiedDate=getdate() ,AppointmentDate=@PreferredAppointmentDate
		where ClientId=@ClientId and ProgramId=@ProgramId
			and cast(AppointmentDate as date) =@DateToReschedule                                                               
			And Isnull(RecordDeleted,'N')='N'
		
		
		Commit Tran
		
	 END try 

      BEGIN catch 
          DECLARE @Error VARCHAR(max) 
		  if @@TRANCOUNT > 0 rollback tran    
          SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
                      + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) 
                      + '*****' 
                      + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 
                      'ssp_SCUpdateASPRescheduleAppointments' 
                      ) 
                      + '*****' + CONVERT(VARCHAR, ERROR_LINE()) 
                      + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) 
                      + '*****' + CONVERT(VARCHAR, ERROR_STATE()) 

          RAISERROR ( @Error, 
                      -- Message text.                                                                                 
                      16, 
                      -- Severity.                                                                                 
                      1 
          -- State.                                                                                 
          ); 
      END catch 
  END 

go  